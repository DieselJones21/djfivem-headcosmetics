local equipped = {} -- [src] = { [itemName] = true }
local detected = {
    framework = 'standalone',
    inventory = 'standalone',
}

local QBCore
local ESX

local function detect()
    local framework = Config.Framework
    if framework == 'auto' then
        if GetResourceState('qbx_core') == 'started' then
            framework = 'qbx'
        elseif GetResourceState('qb-core') == 'started' then
            framework = 'qb'
        elseif GetResourceState('es_extended') == 'started' then
            framework = 'esx'
        else
            framework = 'standalone'
        end
    end

    local inventory = Config.Inventory
    if inventory == 'auto' then
        if GetResourceState('ox_inventory') == 'started' then
            inventory = 'ox'
        elseif GetResourceState('qs-inventory') == 'started' then
            inventory = 'qs'
        elseif GetResourceState('qb-inventory') == 'started' or GetResourceState('ps-inventory') == 'started' or GetResourceState('lj-inventory') == 'started' then
            inventory = 'qb'
        elseif framework == 'esx' then
            inventory = 'esx'
        elseif framework == 'qb' or framework == 'qbx' then
            inventory = 'qb'
        else
            inventory = 'standalone'
        end
    end

    detected.framework = framework
    detected.inventory = inventory

    if GetResourceState('qb-core') == 'started' then
        local ok, obj = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok then QBCore = obj end
    end

    if GetResourceState('es_extended') == 'started' then
        local ok, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)
        if ok then ESX = obj end
    end

    print(('[djfivem-headcosmetics] framework=%s inventory=%s'):format(framework, inventory))
end

-- Collect every identifier this player might have been saved under.
-- Early in the session QB/ESX identifiers are often missing, so login
-- restore must try license AND citizenid/esx identifier.
local function identifierKeys(src)
    local keys, seen = {}, {}
    local function add(key)
        if type(key) == 'string' and key ~= '' and not seen[key] then
            seen[key] = true
            keys[#keys + 1] = key
        end
    end

    add(GetPlayerIdentifierByType(src, 'license2'))
    add(GetPlayerIdentifierByType(src, 'license'))

    if QBCore then
        local player = QBCore.Functions.GetPlayer(src)
        if player and player.PlayerData and player.PlayerData.citizenid then
            add(player.PlayerData.citizenid)
        end
    end
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            add(xPlayer.identifier)
        end
    end
    return keys
end

local function itemCount(src, name)
    local inventory = detected.inventory
    local ok, count = pcall(function()
        if inventory == 'ox' then
            return exports.ox_inventory:GetItemCount(src, name) or 0
        end
        if inventory == 'qs' then
            local item = exports['qs-inventory']:GetItemByName(src, name)
            if not item then return 0 end
            return item.amount or item.count or 0
        end
        if inventory == 'qb' and QBCore then
            local player = QBCore.Functions.GetPlayer(src)
            if not player then return 0 end
            local item = player.Functions.GetItemByName(name)
            if not item then return 0 end
            return item.amount or item.count or 0
        end
        if inventory == 'esx' and ESX then
            local xPlayer = ESX.GetPlayerFromId(src)
            if not xPlayer then return 0 end
            local item = xPlayer.getInventoryItem(name)
            if not item then return 0 end
            return item.count or 0
        end
        return 1
    end)
    if not ok then return 0 end
    return count or 0
end

local function hasItem(src, name)
    return itemCount(src, name) > 0
end

local function inventoryReady(src)
    if detected.inventory == 'standalone' then return true end
    if detected.inventory == 'ox' then
        local ok, inv = pcall(function()
            return exports.ox_inventory:GetInventory(src)
        end)
        return ok and inv ~= nil
    end
    if QBCore then
        return QBCore.Functions.GetPlayer(src) ~= nil
    end
    if ESX then
        return ESX.GetPlayerFromId(src) ~= nil
    end
    return true
end

local function notify(src, msg, nType)
    TriggerClientEvent('djfivem-headcosmetics:notify', src, msg, nType)
end

local function equippedList(src)
    local list = {}
    local set = equipped[src]
    if not set then return list end
    for name in pairs(set) do
        list[#list + 1] = name
    end
    table.sort(list)
    return list
end

local pendingRestore = {} -- [src] = { item names }
local restoreAttempts = {} -- [src] = number
local restoreDone = {} -- [src] = true after this session finished restore
local sessionRemoved = {} -- [src] = { [itemName] = true } unequipped while restore is pending

local function pushState(src, persist)
    local list = equippedList(src)
    Player(src).state:set(Config.StateBag, list, true)
    if persist ~= false and Config.Persist then
        local encoded = json.encode(list)
        local keys = identifierKeys(src)
        for i = 1, #keys do
            SetResourceKvp('equipped:' .. keys[i], encoded)
        end
    end
end

local function loadSavedList(src)
    local keys = identifierKeys(src)
    local best = {}
    for i = 1, #keys do
        local raw = GetResourceKvpString('equipped:' .. keys[i])
        if raw and raw ~= '' then
            local ok, list = pcall(json.decode, raw)
            if ok and type(list) == 'table' then
                local count = #list
                if count == 0 then
                    for _ in pairs(list) do
                        count = count + 1
                        break
                    end
                end
                if count > #best then
                    best = list
                end
            end
        end
    end
    return best
end

-- Keep items the player already chose this session, and drop saved items
-- in the same replace-category so a new crown does not get overwritten
-- by the leftover KVP crown when restore finishes.
local function mergeSavedWithEquipped(src, saved)
    local current = equipped[src] or {}
    local occupied, seen, merged = {}, {}, {}

    for name in pairs(current) do
        local data = Config.Toys[name]
        if data and data.category and Config.ReplaceSameCategory[data.category] then
            occupied[data.category] = name
        end
        merged[#merged + 1] = name
        seen[name] = true
    end

    saved = saved or {}
    local removed = sessionRemoved[src] or {}
    for i = 1, #saved do
        local name = saved[i]
        if type(name) == 'string' and Config.Toys[name] and not seen[name] and not removed[name] then
            local category = Config.Toys[name].category
            if not (category and occupied[category]) then
                merged[#merged + 1] = name
                seen[name] = true
            end
        end
    end
    return merged
end

local function finishRestore(src, persist)
    pendingRestore[src] = nil
    restoreAttempts[src] = nil
    restoreDone[src] = true
    sessionRemoved[src] = nil
    pushState(src, persist)
end

local function tryRestore(src)
    if pendingRestore[src] == nil then return true end

    restoreAttempts[src] = (restoreAttempts[src] or 0) + 1

    -- Re-read KVP each attempt: citizenid/esx identifier may appear after QB/ESX load.
    local saved = mergeSavedWithEquipped(src, loadSavedList(src))
    pendingRestore[src] = saved

    if not inventoryReady(src) then
        if restoreAttempts[src] >= 15 then
            -- Do not persist; KVP still has the last known good list.
            pendingRestore[src] = nil
            restoreAttempts[src] = nil
            restoreDone[src] = true
            sessionRemoved[src] = nil
            return true
        end
        return false
    end

    if #saved == 0 then
        restoreDone[src] = true
        pendingRestore[src] = nil
        restoreAttempts[src] = nil
        sessionRemoved[src] = nil
        pushState(src, false)
        return true
    end

    local nextSet = {}
    local waiting = false
    for i = 1, #saved do
        local name = saved[i]
        if type(name) == 'string' and Config.Toys[name] then
            if detected.inventory == 'standalone' or hasItem(src, name) then
                nextSet[name] = true
            else
                waiting = true
            end
        end
    end

    -- Inventory can still be empty for a few seconds after "ready".
    if waiting and restoreAttempts[src] < 15 then
        return false
    end

    equipped[src] = nextSet
    if waiting then
        -- Apply what we found; leave KVP alone so next login can retry missing items.
        finishRestore(src, false)
        return true
    end

    finishRestore(src, true)
    return true
end

local function toggle(src, name)
    if type(src) ~= 'number' or src <= 0 then return end
    if type(name) ~= 'string' or not Config.Toys[name] then return end

    equipped[src] = equipped[src] or {}
    local label = Config.Toys[name].label or name

    if equipped[src][name] then
        equipped[src][name] = nil
        if pendingRestore[src] then
            sessionRemoved[src] = sessionRemoved[src] or {}
            sessionRemoved[src][name] = true
        end
        notify(src, 'Removed ' .. label, 'inform')
        if pendingRestore[src] then
            pendingRestore[src] = mergeSavedWithEquipped(src, pendingRestore[src])
            pushState(src, false)
            return
        end
        pushState(src)
        return
    end

    if detected.inventory ~= 'standalone' and not hasItem(src, name) then
        notify(src, 'You do not have this item', 'error')
        return
    end

    local category = Config.Toys[name].category
    if category and Config.ReplaceSameCategory[category] then
        local remove = {}
        for other in pairs(equipped[src]) do
            local otherData = Config.Toys[other]
            if otherData and otherData.category == category then
                remove[#remove + 1] = other
            end
        end
        for i = 1, #remove do
            equipped[src][remove[i]] = nil
        end
    end

    equipped[src][name] = true
    if sessionRemoved[src] then
        sessionRemoved[src][name] = nil
    end
    notify(src, 'Equipped ' .. label, 'success')
    if pendingRestore[src] then
        pendingRestore[src] = mergeSavedWithEquipped(src, pendingRestore[src])
        pushState(src, false)
        return
    end
    pushState(src)
end

RegisterNetEvent('djfivem-headcosmetics:toggle', function(name)
    toggle(source, name)
end)

RegisterNetEvent('n93_halos:useHalo', function(name)
    toggle(source, name)
end)

RegisterNetEvent('djfivem-headcosmetics:playerReady', function()
    local src = source
    equipped[src] = equipped[src] or {}

    if not Config.Persist then
        pushState(src, false)
        return
    end

    -- Framework + resource-start both fire this. Do not restart restore or
    -- overwrite a session that already finished / is still waiting.
    if pendingRestore[src] or restoreDone[src] then
        pushState(src, false)
        return
    end

    pendingRestore[src] = mergeSavedWithEquipped(src, loadSavedList(src))
    restoreAttempts[src] = 0
    tryRestore(src)
end)

AddEventHandler('playerDropped', function()
    local src = source
    equipped[src] = nil
    pendingRestore[src] = nil
    restoreAttempts[src] = nil
    restoreDone[src] = nil
    sessionRemoved[src] = nil
end)

local function registerUsables()
    -- ox_inventory uses the client export on the item definition. Registering
    -- QB/ESX usables on top of that would toggle twice (wear then immediately remove).
    if detected.inventory == 'ox' then
        print('[djfivem-headcosmetics] using ox_inventory item export (see install/ox_inventory_items.lua)')
        return
    end

    if (detected.framework == 'qb' or detected.framework == 'qbx') and QBCore then
        for name in pairs(Config.Toys) do
            QBCore.Functions.CreateUseableItem(name, function(src)
                toggle(src, name)
            end)
        end
        print('[djfivem-headcosmetics] registered QBCore usable items')
        return
    end

    if detected.framework == 'esx' and ESX then
        for name in pairs(Config.Toys) do
            ESX.RegisterUsableItem(name, function(src)
                toggle(src, name)
            end)
        end
        print('[djfivem-headcosmetics] registered ESX usable items')
        return
    end

    if detected.inventory == 'qs' then
        for name in pairs(Config.Toys) do
            exports['qs-inventory']:CreateUsableItem(name, function(src)
                toggle(src, name)
            end)
        end
        print('[djfivem-headcosmetics] registered qs-inventory usable items')
    end
end

CreateThread(function()
    Wait(500)
    detect()
    registerUsables()
end)

CreateThread(function()
    while true do
        Wait(2000)
        local sources = {}
        for src in pairs(pendingRestore) do
            sources[#sources + 1] = src
        end
        for i = 1, #sources do
            tryRestore(sources[i])
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.MissingItemCheckMs or 8000)
        if Config.UnequipIfItemMissing and detected.inventory ~= 'standalone' then
            local sources = {}
            for src in pairs(equipped) do
                sources[#sources + 1] = src
            end
            for i = 1, #sources do
                local src = sources[i]
                local set = equipped[src]
                if set and not pendingRestore[src] and inventoryReady(src) then
                    local changed = false
                    local remove = {}
                    for name in pairs(set) do
                        if not hasItem(src, name) then
                            remove[#remove + 1] = name
                        end
                    end
                    for j = 1, #remove do
                        set[remove[j]] = nil
                        changed = true
                    end
                    if changed then
                        pushState(src, true)
                    end
                end
            end
        end
    end
end)

if Config.DebugCommands then
    RegisterCommand('wearcosmetic', function(src, args)
        if src == 0 then
            print('This command must be used in-game.')
            return
        end
        toggle(src, args[1])
    end, false)

    RegisterCommand('clearcosmetics', function(src)
        if src == 0 then return end
        equipped[src] = {}
        pendingRestore[src] = nil
        restoreAttempts[src] = nil
        restoreDone[src] = true
        sessionRemoved[src] = nil
        pushState(src)
        notify(src, 'Cleared head cosmetics', 'inform')
    end, false)
end
