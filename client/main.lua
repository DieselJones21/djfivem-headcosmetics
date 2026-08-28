local spawned = {} -- [serverId] = { [itemName] = entity }
local lastPed = {} -- [serverId] = ped handle

local function notify(msg, nType)
    if not Config.Notify then return end
    nType = nType or 'inform'

    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({ description = msg, type = nType })
        return
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
    if HasModelLoaded(hash) then return hash end

    RequestModel(hash)
    local timeout = GetGameTimer() + 7000
    while not HasModelLoaded(hash) do
        if GetGameTimer() > timeout then
            return nil
        end
        Wait(10)
    end
    return hash
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
    if not props then return end
    for _, entity in pairs(props) do
        deleteProp(entity)
    end
    spawned[serverId] = nil
    lastPed[serverId] = nil
end

local function attachOne(ped, name)
    local data = Config.Toys[name]
    if not data or ped == 0 or not DoesEntityExist(ped) then return nil end

    local hash = loadModel(data.model)
    if not hash then
        print(('[djfivem-headcosmetics] model failed to load: %s (is stream/ + ytyp started?)'):format(data.model))
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

    for name, entity in pairs(spawned[serverId]) do
        if not want[name] or pedChanged or not DoesEntityExist(entity) then
            deleteProp(entity)
            spawned[serverId][name] = nil
        end
    end

    for name in pairs(want) do
        if Config.Toys[name] and (not spawned[serverId][name] or not DoesEntityExist(spawned[serverId][name])) then
            local obj = attachOne(ped, name)
            if obj then
                spawned[serverId][name] = obj
            end
        end
    end
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
        for serverId in pairs(spawned) do
            if not seen[serverId] then
                clearPlayer(serverId)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for serverId in pairs(spawned) do
        clearPlayer(serverId)
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

AddEventHandler('QBCore:Client:OnPlayerLoaded', tellServerReady)
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
