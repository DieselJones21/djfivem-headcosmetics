local editing
local stepPos = 0.002
local stepRot = 1.0

local function helpText(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, -1)
end

local function dumpOffsets(name, data)
    local snippet
    if data.animDict and data.animDict ~= '' then
        snippet = ([[    ['%s'] = { model = '%s', bone = %s, x = %.4f, y = %.4f, z = %.4f, xR = %.2f, yR = %.2f, zR = %.2f, animDict = '%s', animName = '%s' },]]):format(
            name, data.model or name, data.bone or 24817, data.x, data.y, data.z, data.xR, data.yR, data.zR, data.animDict, data.animName or ''
        )
    else
        snippet = ([[    ['%s'] = { model = '%s', bone = %s, x = %.4f, y = %.4f, z = %.4f, xR = %.2f, yR = %.2f, zR = %.2f },]]):format(
            name, data.model or name, data.bone or 31086, data.x, data.y, data.z, data.xR, data.yR, data.zR
        )
    end
    print('^2[djfivem-headcosmetics] paste this into Config.Toys:^7')
    print(snippet)
    if GetResourceState('ox_lib') == 'started' then
        pcall(function()
            exports.ox_lib:setClipboard(snippet)
        end)
    end
    TriggerEvent('djfivem-headcosmetics:notify', 'Offset printed to F8 console', 'success')
end

local function stopEditor(save)
    if not editing then return end
    if save then
        dumpOffsets(editing.name, Config.Toys[editing.name])
    end
    editing = nil
end

local function startEditor(name)
    local data = Config.Toys[name]
    if not data then
        TriggerEvent('djfivem-headcosmetics:notify', 'Unknown cosmetic: ' .. tostring(name), 'error')
        return
    end

    editing = { name = name }
    if not exports[GetCurrentResourceName()]:IsWearing(name) then
        TriggerServerEvent('djfivem-headcosmetics:toggle', name)
        Wait(200)
    end

    TriggerEvent('djfivem-headcosmetics:notify', 'Editing ' .. (data.label or name) .. ' — Enter to save, Backspace to cancel', 'inform')
end

RegisterCommand(Config.EditorCommand, function(_, args)
    if Config.EditorAce and not IsPlayerAceAllowed(PlayerId(), Config.EditorAce) then
        TriggerEvent('djfivem-headcosmetics:notify', 'You cannot use the placement editor', 'error')
        return
    end

    if editing then
        stopEditor(false)
        return
    end

    local name = args[1]
    if not name then
        local wearing = exports[GetCurrentResourceName()]:GetWearing()
        name = wearing[1]
    end
    if not name then
        TriggerEvent('djfivem-headcosmetics:notify', 'Usage: /' .. Config.EditorCommand .. ' black_blue_crown', 'error')
        return
    end
    startEditor(name)
end, false)

CreateThread(function()
    while true do
        if not editing then
            Wait(400)
        else
            Wait(0)
            local data = Config.Toys[editing.name]
            if not data then
                stopEditor(false)
            else
                DisableControlAction(0, 191, true) -- ENTER
                DisableControlAction(0, 194, true) -- BACKSPACE
                DisableControlAction(0, 172, true) -- up
                DisableControlAction(0, 173, true) -- down
                DisableControlAction(0, 174, true) -- left
                DisableControlAction(0, 175, true) -- right
                DisableControlAction(0, 10, true)  -- page up
                DisableControlAction(0, 11, true)  -- page down
                DisableControlAction(0, 19, true)  -- LALT fine-tune
                DisableControlAction(0, 21, true)  -- LSHIFT coarse

                local pos = stepPos
                local rot = stepRot
                if IsDisabledControlPressed(0, 21) then
                    pos = 0.01
                    rot = 5.0
                elseif IsDisabledControlPressed(0, 19) then
                    pos = 0.001
                    rot = 0.25
                end

                local changed = false
                if IsDisabledControlPressed(0, 174) then data.x = data.x - pos; changed = true end
                if IsDisabledControlPressed(0, 175) then data.x = data.x + pos; changed = true end
                if IsDisabledControlPressed(0, 172) then data.y = data.y + pos; changed = true end
                if IsDisabledControlPressed(0, 173) then data.y = data.y - pos; changed = true end
                if IsDisabledControlPressed(0, 10) then data.z = data.z + pos; changed = true end
                if IsDisabledControlPressed(0, 11) then data.z = data.z - pos; changed = true end

                -- Numpad rotations
                if IsControlPressed(0, 108) then data.xR = data.xR - rot; changed = true end -- num4
                if IsControlPressed(0, 109) then data.xR = data.xR + rot; changed = true end -- num6
                if IsControlPressed(0, 111) then data.yR = data.yR + rot; changed = true end -- num8
                if IsControlPressed(0, 110) then data.yR = data.yR - rot; changed = true end -- num5
                if IsControlPressed(0, 117) then data.zR = data.zR - rot; changed = true end -- num7
                if IsControlPressed(0, 118) then data.zR = data.zR + rot; changed = true end -- num9

                if changed then
                    exports[GetCurrentResourceName()]:ReattachLocal(editing.name)
                end

                if IsDisabledControlJustPressed(0, 191) then
                    stopEditor(true)
                elseif IsDisabledControlJustPressed(0, 194) then
                    TriggerEvent('djfivem-headcosmetics:notify', 'Editor cancelled', 'inform')
                    stopEditor(false)
                else
                    helpText((
                        '~y~%s~s~~n~Pos ~g~%.3f %.3f %.3f~s~  Rot ~b~%.1f %.1f %.1f~s~~n~Arrows XY  PageUp/Down Z  Numpad 4/6/8/5/7/9 rot~n~Alt fine  Shift coarse  Enter save  Backspace cancel'
                    ):format(data.label or editing.name, data.x, data.y, data.z, data.xR, data.yR, data.zR))
                end
            end
        end
    end
end)
