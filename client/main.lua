local spawned = {} -- [serverId] = { [itemName] = entity }
local lastPed = {} -- [serverId] = ped handle
local playingAnim = {} -- [serverId] = { dict = string, name = string }
local attaching = {} -- [serverId] = { [itemName] = true }
local modelFailUntil = {} -- [hash] = GetGameTimer()
local modelWaitStarted = {} -- [hash] = GetGameTimer()

local function notify(msg, nType)
    if not Config.Notify then return end
    nType = nType or 'inform'

    if GetResourceState('ox_lib') == 'started' then
        local ok = pcall(function()
            exports.ox_lib:notify({ description = msg, type = nType })
        end)
        if ok then return end
    end

    if GetResourceState('qb-core') == 'started' or GetResourceState('qbx_core') == 'started' then
        local qbType = 'primary'
        if nType == 'error' then qbType = 'error'
        elseif nType == 'success' then qbType = 'success' end
        TriggerEvent('QBCore:Notify', msg, qbType)
        return
    end

    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)
    if HasModelLoaded(hash) then
        modelWaitStarted[hash] = nil
        return hash
    end
    if modelFailUntil[hash] and GetGameTimer() < modelFailUntil[hash] then
        return nil, 'cooldown'
    end

    RequestModel(hash)
    if HasModelLoaded(hash) then
        modelWaitStarted[hash] = nil
        return hash
    end

    -- Do not Wait() here: the 1s sync loop and statebag handler can run at the
    -- same time, and a blocking load froze nearby players' props for seconds.
    modelWaitStarted[hash] = modelWaitStarted[hash] or GetGameTimer()
    if GetGameTimer() - modelWaitStarted[hash] > 8000 then
        modelFailUntil[hash] = GetGameTimer() + 15000
        modelWaitStarted[hash] = nil
        return nil, 'failed'
    end
    return nil, 'waiting'
end

local function deleteProp(entity)
    if entity and DoesEntityExist(entity) then
        DetachEntity(entity, true, true)
        SetEntityAsMissionEntity(entity, true, true)
        DeleteObject(entity)
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
end

local function clearPlayer(serverId)
    local props = spawned[serverId]
    if props then
        for _, entity in pairs(props) do
            deleteProp(entity)
        end
    end
    spawned[serverId] = nil
    lastPed[serverId] = nil
    playingAnim[serverId] = nil
    attaching[serverId] = nil
end

local function attachOne(ped, name)
    local data = Config.Toys[name]
    if not data or ped == 0 or not DoesEntityExist(ped) then return nil end

    local hash, reason = loadModel(data.model)
    if not hash then
        if reason == 'failed' then
            print(('[djfivem-headcosmetics] model failed to load: %s (is stream/ + ytyp started?)'):format(data.model))
        end
        return nil
    end

    local coords = GetEntityCoords(ped)
    local obj = CreateObjectNoOffset(hash, coords.x, coords.y, coords.z, false, false, false)
    if not obj or obj == 0 then
        SetModelAsNoLongerNeeded(hash)
        return nil
    end

    SetEntityCollision(obj, false, false)
    pcall(SetEntityCompletelyDisableCollision, obj, true, true)
    pcall(SetCanClimbOnEntity, obj, false)
    AttachEntityToEntity(
        obj,
        ped,
        GetPedBoneIndex(ped, data.bone),
        data.x, data.y, data.z,
        data.xR, data.yR, data.zR,
        true, true, false, true, 1, true
    )
    SetModelAsNoLongerNeeded(hash)
    return obj
end

local function isLocalServerId(serverId)
    return serverId == GetPlayerServerId(PlayerId())
end

local function loadAnimDict(dict)
    if not dict or dict == '' then return false end
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    return HasAnimDictLoaded(dict)
end

local function stopPlushAnim(ped, serverId)
    local rec = playingAnim[serverId]
    if rec and ped ~= 0 and DoesEntityExist(ped) then
        StopAnimTask(ped, rec.dict, rec.name, 1.0)
    end
    playingAnim[serverId] = nil
end

-- Only the local player should TaskPlayAnim. Other clients already see that
-- player's replicated animation; driving it from here fights their game state.
local function syncAnim(ped, serverId, want)
    if not isLocalServerId(serverId) then return end

    if IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped) or IsEntityDead(ped) then
        if playingAnim[serverId] then
            stopPlushAnim(ped, serverId)
        end
        return
    end

    local chosen
    for name in pairs(want) do
        local data = Config.Toys[name]
        if data and data.animDict and data.animDict ~= '' and data.animName and data.animName ~= '' then
            chosen = data
            break
        end
    end

    if not chosen then
        if playingAnim[serverId] then
            stopPlushAnim(ped, serverId)
        end
        return
    end

    if not loadAnimDict(chosen.animDict) then return end
    if not IsEntityPlayingAnim(ped, chosen.animDict, chosen.animName, 3) then
        TaskPlayAnim(ped, chosen.animDict, chosen.animName, 8.0, -8.0, -1, 49, 0.0, false, false, false)
    end
    playingAnim[serverId] = { dict = chosen.animDict, name = chosen.animName }
end

local function listToSet(list)
    local set = {}
    if type(list) ~= 'table' then return set end
    for _, name in ipairs(list) do
        if type(name) == 'string' then
            set[name] = true
        end
    end
    return set
end

local function getPlayerId(serverId)
    if serverId == GetPlayerServerId(PlayerId()) then
        return PlayerId()
    end
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then return player end
    return nil
end

local function syncPlayer(serverId, list)
    local player = getPlayerId(serverId)
    if not player then
        clearPlayer(serverId)
        return
    end

    local ped = GetPlayerPed(player)
    if ped == 0 or not DoesEntityExist(ped) then return end

    spawned[serverId] = spawned[serverId] or {}
    local want = listToSet(list)
    local pedChanged = lastPed[serverId] ~= ped
    lastPed[serverId] = ped

    local drop = {}
    for name, entity in pairs(spawned[serverId]) do
        if not want[name] or pedChanged or not DoesEntityExist(entity) then
            drop[#drop + 1] = name
        end
    end
    for i = 1, #drop do
        local name = drop[i]
        deleteProp(spawned[serverId][name])
        spawned[serverId][name] = nil
    end

    attaching[serverId] = attaching[serverId] or {}

    for name in pairs(want) do
        if Config.Toys[name] then
            local existing = spawned[serverId][name]
            local alive = existing and DoesEntityExist(existing)
            if not alive and not attaching[serverId][name] then
                attaching[serverId][name] = true
                local obj = attachOne(ped, name)
                attaching[serverId][name] = nil
                if obj then
                    spawned[serverId][name] = obj
                end
            end
        end
    end

    syncAnim(ped, serverId, want)
end

AddStateBagChangeHandler(Config.StateBag, nil, function(bagName, _key, value)
    local player = GetPlayerFromStateBagName(bagName)
    if player == 0 then return end
    local serverId = GetPlayerServerId(player)

    CreateThread(function()
        local timeout = GetGameTimer() + 5000
        while (GetPlayerPed(player) == 0 or not DoesEntityExist(GetPlayerPed(player))) and GetGameTimer() < timeout do
            Wait(50)
        end
        syncPlayer(serverId, value)
    end)
end)

CreateThread(function()
    while true do
        Wait(1000)
        local seen = {}
        for _, player in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(player)
            seen[serverId] = true
            syncPlayer(serverId, Player(serverId).state[Config.StateBag])
        end
        local stale = {}
        for serverId in pairs(spawned) do
            if not seen[serverId] then
                stale[#stale + 1] = serverId
            end
        end
        for i = 1, #stale do
            clearPlayer(stale[i])
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    local localId = GetPlayerServerId(PlayerId())
    stopPlushAnim(PlayerPedId(), localId)
    local ids = {}
    for serverId in pairs(spawned) do
        ids[#ids + 1] = serverId
    end
    for i = 1, #ids do
        clearPlayer(ids[i])
    end
end)

local function requestToggle(name)
    if type(name) ~= 'string' or not Config.Toys[name] then return end
    TriggerServerEvent('djfivem-headcosmetics:toggle', name)
end

-- ox_inventory client export: client = { export = 'djfivem-headcosmetics.useCosmetic' }
exports('useCosmetic', function(data, _slot)
    if type(data) == 'table' and data.name then
        requestToggle(data.name)
    elseif type(data) == 'string' then
        requestToggle(data)
    end
end)

-- Original n93_halos event name, if another script still fires it.
RegisterNetEvent('n93_halos:useHalo', function(name)
    requestToggle(name)
end)

RegisterNetEvent('djfivem-headcosmetics:notify', notify)

local function tellServerReady()
    TriggerServerEvent('djfivem-headcosmetics:playerReady')
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', tellServerReady)
RegisterNetEvent('esx:playerLoaded', tellServerReady)

AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    CreateThread(function()
        Wait(1500)
        tellServerReady()
    end)
end)

exports('GetWearing', function()
    local list = Player(GetPlayerServerId(PlayerId())).state[Config.StateBag]
    return type(list) == 'table' and list or {}
end)

exports('IsWearing', function(name)
    local list = Player(GetPlayerServerId(PlayerId())).state[Config.StateBag]
    if type(list) ~= 'table' then return false end
    for i = 1, #list do
        if list[i] == name then return true end
    end
    return false
end)

exports('ReattachLocal', function(name)
    local serverId = GetPlayerServerId(PlayerId())
    local ped = PlayerPedId()
    spawned[serverId] = spawned[serverId] or {}
    deleteProp(spawned[serverId][name])
    spawned[serverId][name] = attachOne(ped, name)
    return spawned[serverId][name]
end)
