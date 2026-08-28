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

local function playerKey(src)
    if QBCore then
        local player = QBCore.Functions.GetPlayer(src)
        if player and player.PlayerData and player.PlayerData.citizenid then
            return player.PlayerData.citizenid
        end
    end
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            return xPlayer.identifier
        end
    end
    return GetPlayerIdentifierByType(src, 'license2')
        or GetPlayerIdentifierByType(src, 'license')
        or ('src:%s'):format(src)
end

local function itemCount(src, name)
    local inventory = detected.inventory
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
end

local function hasItem(src, name)
    return itemCount(src, name) > 0
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

local function pushState(src)
    local list = equippedList(src)
    Player(src).state:set(Config.StateBag, list, true)
    if Config.Persist then
        local key = playerKey(src)
        if key then
            SetResourceKvp('equipped:' .. key, json.encode(list))
        end
    end
end

local function toggle(src, name)
    if type(src) ~= 'number' or src <= 0 then return end
    if type(name) ~= 'string' or not Config.Toys[name] then return end

    equipped[src] = equipped[src] or {}
    local label = Config.Toys[name].label or name

    if equipped[src][name] then
        equipped[src][name] = nil
        notify(src, 'Removed ' .. label, 'inform')
        pushState(src)
        return
    end

    if detected.inventory ~= 'standalone' and not hasItem(src, name) then
        notify(src, 'You do not have this item', 'error')
        return
    end

    local category = Config.Toys[name].category
    if category and Config.ReplaceSameCategory[category] then
        for other in pairs(equipped[src]) do
            local otherData = Config.Toys[other]
            if otherData and otherData.category == category then
                equipped[src][other] = nil
            end
        end
    end

    equipped[src][name] = true
    notify(src, 'Equipped ' .. label, 'success')
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
    equipped[src] = {}

    if Config.Persist then
        local raw = GetResourceKvpString('equipped:' .. (playerKey(src) or ''))
        if raw and raw ~= '' then
            local ok, list = pcall(json.decode, raw)
            if ok and type(list) == 'table' then
                for i = 1, #list do
                    local name = list[i]
                    if Config.Toys[name] and (detected.inventory == 'standalone' or hasItem(src, name)) then
                        equipped[src][name] = true
                    end
                end
            end
        end
    end

    pushState(src)
end)

AddEventHandler('playerDropped', function()
    equipped[source] = nil
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
        Wait(Config.MissingItemCheckMs or 8000)
        if Config.UnequipIfItemMissing and detected.inventory ~= 'standalone' then
            for src, set in pairs(equipped) do
                local changed = false
                for name in pairs(set) do
                    if not hasItem(src, name) then
                        set[name] = nil
                        changed = true
                    end
                end
                if changed then
                    pushState(src)
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
        pushState(src)
        notify(src, 'Cleared head cosmetics', 'inform')
    end, false)
end
