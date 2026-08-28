Config = Config or {}

--[[
    Framework / inventory are auto-detected.
    Override only if detection picks the wrong one.
]]
Config.Framework = 'auto' -- 'auto' | 'qb' | 'qbx' | 'esx' | 'standalone'
Config.Inventory = 'auto' -- 'auto' | 'ox' | 'qb' | 'esx' | 'qs'

-- One equipped item per category. A crown and a halo can be worn together.
Config.ReplaceSameCategory = {
    crown = true,
    halo = true,
    plushie = true,
}

Config.Persist = true
Config.UnequipIfItemMissing = true
Config.MissingItemCheckMs = 8000

Config.Notify = true
Config.DebugCommands = true -- /wearcosmetic [item], /clearcosmetics
Config.EditorCommand = 'adjustcosmetic'
Config.EditorAce = nil -- e.g. 'group.admin'; nil = allow everyone

Config.StateBag = 'headCosmetics'

--[[
    Placement from the n93_halos script.
    Bone 31086 = SKEL_Head (sits on hair and hats, not a clothing slot).

    Fine-tune live: /adjustcosmetic black_blue_crown
]]
Config.Toys = {
    ['black_blue_crown'] = { model = 'black_blue_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_cyan_crown'] = { model = 'black_cyan_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_gold_crown'] = { model = 'black_gold_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_green_crown'] = { model = 'black_green_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_pink_crown'] = { model = 'black_pink_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_purple_crown'] = { model = 'black_purple_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_red_crown'] = { model = 'black_red_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_white_crown'] = { model = 'black_white_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['black_yellow_crown'] = { model = 'black_yellow_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_blue_crown'] = { model = 'gold_blue_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_cyan_crown'] = { model = 'gold_cyan_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_green_crown'] = { model = 'gold_green_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_pink_crown'] = { model = 'gold_pink_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_purple_crown'] = { model = 'gold_purple_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_red_crown'] = { model = 'gold_red_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['gold_white_crown'] = { model = 'gold_white_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_blue_crown'] = { model = 'silver_blue_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_cyan_crown'] = { model = 'silver_cyan_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_gold_crown'] = { model = 'silver_gold_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_green_crown'] = { model = 'silver_green_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_pink_crown'] = { model = 'silver_pink_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_purple_crown'] = { model = 'silver_purple_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_red_crown'] = { model = 'silver_red_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['silver_yellow_crown'] = { model = 'silver_yellow_crown', bone = 31086, x = -0.63, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_black'] = { model = 'halo_black', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_blue'] = { model = 'halo_blue', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_gold'] = { model = 'halo_gold', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_green'] = { model = 'halo_green', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_pink'] = { model = 'halo_pink', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_purple'] = { model = 'halo_purple', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_red'] = { model = 'halo_red', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
    ['halo_white'] = { model = 'halo_white', bone = 31086, x = -0.6, y = 0.0, z = 0.0, xR = 90.0, yR = 0.0, zR = 90.0 },
}

local function titleCase(name)
    return (name:gsub('[^_]+', function(word)
        return word:sub(1, 1):upper() .. word:sub(2)
    end):gsub('_', ' '))
end

local function inferCategory(name)
    if name:find('plushie', 1, true) then return 'plushie' end
    if name:find('halo', 1, true) then return 'halo' end
    if name:find('crown', 1, true) then return 'crown' end
    return 'misc'
end

local PLUSH_LABELS = {
    abelha = 'Bee',
    capivara = 'Capybara',
    coelho = 'Rabbit',
    dinossauro = 'Dinosaur',
    foxwitch = 'Fox Witch',
    gato = 'Cat',
    jacare = 'Alligator',
    monk = 'Monkey',
    pinguimrosa = 'Pink Penguin',
    pit = 'Pitbull',
    polvo = 'Octopus',
    rinoceronte = 'Rhino',
    ursinhocarinhoso = 'Care Bear',
    vaca = 'Cow',
}

local function nicerPlushLabel(name)
    local n = name:gsub('_plushie_shop$', ''):gsub('_plushie$', '')
    n = n:gsub('alien', ' alien'):gsub('cow', ' cow'):gsub('duck', ' duck')
    n = n:gsub('_+', ' '):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
    local key = n:match('^([%a]+)')
    if key and PLUSH_LABELS[key] then
        local rest = n:sub(#key + 1)
        n = PLUSH_LABELS[key] .. rest
    end
    return titleCase(n) .. ' Plushie'
end

for name, data in pairs(Config.Toys) do
    data.model = data.model or name
    data.bone = data.bone or 31086
    data.x = data.x or 0.0
    data.y = data.y or 0.0
    data.z = data.z or 0.0
    data.xR = data.xR or 0.0
    data.yR = data.yR or 0.0
    data.zR = data.zR or 0.0
    data.category = data.category or inferCategory(name)
    if not data.label or data.label == '' then
        if data.category == 'plushie' then
            data.label = nicerPlushLabel(name)
        else
            data.label = titleCase(name)
        end
    end
end
