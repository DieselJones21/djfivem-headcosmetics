Config.ReplaceSameCategory.plushie = true

local PLUSH_DICT = 'impexp_int-0'
local PLUSH_CLIP = 'mp_m_waremech_01_dual-0'
local PLUSH_BONE = 24817 -- SKEL_Spine3, same hug pose as the original plushie script

local function addPlush(name, tweaks)
    tweaks = tweaks or {}
    Config.Toys[name] = {
        model = tweaks.model or name,
        bone = tweaks.bone or PLUSH_BONE,
        x = tweaks.x or 0.0,
        y = tweaks.y or 0.4,
        z = tweaks.z or -0.02,
        xR = tweaks.xR or 180.0,
        yR = tweaks.yR or -90.0,
        zR = tweaks.zR or 0.0,
        animDict = PLUSH_DICT,
        animName = PLUSH_CLIP,
        category = 'plushie',
        label = tweaks.label,
    }
end

-- Handheld / hugged plushies. Stream these from your existing pelucias / alien / cow / duck resources.
local plushes = {
    -- Aliens
    'greenalien_plushie', 'angelalien_plushie', 'bunalien_plushie', 'cosmicalien_plushie',
    'lavaalien_plushie', 'marsalien_plushie', 'octoalien_plushie', 'voidalien_plushie',
    -- Cows
    'chococow_plushie', 'galaxycow_plushie', 'matchacow_plushie', 'raincow_plushie',
    'sakuracow_plushie', 'sunflowercow_plushie', 'highlandcow_plushie',
    -- Ducks
    'angelduck_plushie', 'devilduck_plushie', 'gamerduck_plushie', 'gardenerduck_plushie',
    'gothduck_plushie', 'sleepyduck_plushie', 'thugduck_plushie',
    -- Shop pack (pelucias_plushie_shop.ytyp)
    'abelha_plushie_shop',
    'banana_01_plushie_shop',
    'bear_01_plushie_shop', 'bear_02_plushie_shop', 'bear_03_plushie_shop',
    'bear_04_plushie_shop', 'bear_05_plushie_shop', 'bear_06_plushie_shop',
    'bear2_01_plushie_shop', 'bear3_01_plushie_shop', 'bear4_01_plushie_shop',
    'bear5_01_plushie_shop', 'bear6_01_plushie_shop', 'bear7_01_plushie_shop', 'bear8_01_plushie_shop',
    'bunny1_01_plushie_shop', 'bunny1_02_plushie_shop', 'bunny1_03_plushie_shop',
    'bunny1_04_plushie_shop', 'bunny1_05_plushie_shop', 'bunny1_06_plushie_shop', 'bunny1_07_plushie_shop',
    'bunny2_01_plushie_shop', 'bunny2_02_plushie_shop', 'bunny2_03_plushie_shop', 'bunny2_04_plushie_shop',
    'bunny2_05_plushie_shop', 'bunny2_06_plushie_shop', 'bunny2_07_plushie_shop', 'bunny2_08_plushie_shop',
    'bunny2_09_plushie_shop', 'bunny2_10_plushie_shop',
    'bunny3_01_plushie_shop', 'bunny3_02_plushie_shop', 'bunny3_03_plushie_shop', 'bunny3_04_plushie_shop',
    'bunny3_05_plushie_shop', 'bunny3_06_plushie_shop', 'bunny3_07_plushie_shop', 'bunny3_08_plushie_shop',
    'bunny3_09_plushie_shop', 'bunny3_10_plushie_shop',
    'bunny4_01_plushie_shop', 'bunny4_02_plushie_shop', 'bunny4_03_plushie_shop', 'bunny4_04_plushie_shop',
    'bunny4_05_plushie_shop', 'bunny4_06_plushie_shop', 'bunny4_07_plushie_shop', 'bunny4_08_plushie_shop',
    'capivara_plushie_shop',
    'cat_01_plushie_shop', 'cat_02_plushie_shop', 'cat_03_plushie_shop',
    'cat_04_plushie_shop', 'cat_05_plushie_shop', 'cat_06_plushie_shop',
    'coelho_plushie_shop', 'coelho2_plushie_shop',
    'dinossauro_plushie_shop',
    'dog_01_plushie_shop',
    'duck_01_plushie_shop', 'duck_02_plushie_shop', 'duck_03_plushie_shop',
    'duck_04_plushie_shop', 'duck_05_plushie_shop', 'duck_06_plushie_shop',
    'foxwitch_01_plushie_shop', 'foxwitch_02_plushie_shop', 'foxwitch_03_plushie_shop',
    'foxwitch_04_plushie_shop', 'foxwitch_05_plushie_shop', 'foxwitch_06_plushie_shop',
    'foxwitch_07_plushie_shop', 'foxwitch_08_plushie_shop', 'foxwitch_09_plushie_shop',
    'foxwitch_10_plushie_shop', 'foxwitch_11_plushie_shop',
    'frog_01_plushie_shop',
    'frog2_01_plushie_shop', 'frog2_02_plushie_shop', 'frog2_03_plushie_shop', 'frog2_04_plushie_shop',
    'frog2_05_plushie_shop', 'frog2_06_plushie_shop', 'frog2_07_plushie_shop',
    'gato_01_plushie_shop', 'gato_02_plushie_shop', 'gato_03_plushie_shop', 'gato_04_plushie_shop',
    'gato_05_plushie_shop', 'gato_06_plushie_shop', 'gato_07_plushie_shop', 'gato_08_plushie_shop',
    'jacare_plushie_shop',
    'monk_01_plushie_shop',
    'mouse_01_plushie_shop', 'mouse_02_plushie_shop', 'mouse_03_plushie_shop',
    'mouse_04_plushie_shop', 'mouse_05_plushie_shop', 'mouse_06_plushie_shop',
    'mouse2_01_plushie_shop', 'mouse2_02_plushie_shop', 'mouse2_03_plushie_shop',
    'mouse2_04_plushie_shop', 'mouse2_05_plushie_shop', 'mouse2_06_plushie_shop',
    'mouse3_01_plushie_shop', 'mouse3_02_plushie_shop', 'mouse3_03_plushie_shop', 'mouse3_04_plushie_shop',
    'mouse3_05_plushie_shop', 'mouse3_06_plushie_shop', 'mouse3_07_plushie_shop', 'mouse3_08_plushie_shop',
    'mushroom_01_plushie_shop', 'mushroom_02_plushie_shop', 'mushroom_03_plushie_shop',
    'mushroom_04_plushie_shop', 'mushroom_05_plushie_shop', 'mushroom_06_plushie_shop', 'mushroom_07_plushie_shop',
    'panda_plushie_shop',
    'pinguimrosa_plushie_shop',
    'pit_01_plushie_shop', 'pit2_01_plushie_shop', 'pit3_01_plushie_shop',
    'polvo_01_plushie_shop', 'polvo_02_plushie_shop', 'polvo_03_plushie_shop',
    'polvo_04_plushie_shop', 'polvo_05_plushie_shop', 'polvo_06_plushie_shop',
    'polvo_07_plushie_shop', 'polvo_08_plushie_shop', 'polvo_09_plushie_shop',
    'rinoceronte_plushie_shop', 'rinoceronte2_plushie_shop', 'rinoceronte3_plushie_shop', 'rinoceronte4_plushie_shop',
    'unicorn_01_plushie_shop',
    'ursinhocarinhoso_01_plushie_shop', 'ursinhocarinhoso_02_plushie_shop', 'ursinhocarinhoso_03_plushie_shop',
    'ursinhocarinhoso_04_plushie_shop', 'ursinhocarinhoso_05_plushie_shop', 'ursinhocarinhoso_06_plushie_shop',
    'ursinhocarinhoso_07_plushie_shop', 'ursinhocarinhoso_08_plushie_shop', 'ursinhocarinhoso_09_plushie_shop',
    'vaca_plushie_shop',
}

for i = 1, #plushes do
    addPlush(plushes[i])
end

-- Slightly different hug offsets from your original config
addPlush('banana_01_plushie_shop', { z = 0.00, xR = -180.0 })
addPlush('rinoceronte_plushie_shop', { z = 0.00, xR = -180.0 })

local function titleCase(name)
    return (name:gsub('[^_]+', function(word)
        return word:sub(1, 1):upper() .. word:sub(2)
    end):gsub('_', ' '))
end

local function plushLabel(name)
    local n = name:gsub('_plushie_shop$', ''):gsub('_plushie$', '')
    n = n:gsub('alien', ' alien'):gsub('cow', ' cow'):gsub('duck', ' duck')
    n = n:gsub('_+', ' ')
    local map = {
        abelha = 'Bee', capivara = 'Capybara', coelho = 'Rabbit', dinossauro = 'Dinosaur',
        foxwitch = 'Fox Witch', gato = 'Cat', jacare = 'Alligator', monk = 'Monkey',
        pinguimrosa = 'Pink Penguin', pit = 'Pitbull', polvo = 'Octopus',
        rinoceronte = 'Rhino', ursinhocarinhoso = 'Care Bear', vaca = 'Cow',
    }
    local key = n:match('^([%a]+)')
    if key and map[key] then
        n = map[key] .. n:sub(#key + 1)
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
    data.category = data.category or 'misc'
    if not data.label or data.label == '' then
        if data.category == 'plushie' then
            data.label = plushLabel(name)
        else
            data.label = titleCase(name)
        end
    end
end
