Config = Config or {}

--[[
    Framework / inventory are auto-detected.
    Override only if detection picks the wrong one.
]]
Config.Framework = 'auto' -- 'auto' | 'qb' | 'qbx' | 'esx' | 'standalone'
Config.Inventory = 'auto' -- 'auto' | 'ox' | 'qb' | 'esx' | 'qs'

-- Streamed .ydr / .ytyp files live in this resource. Keep it started first.
Config.StreamResource = 'cosmetics'

-- One equipped item per category. A crown, halo, wings, and shoulder pet can be worn together.
Config.ReplaceSameCategory = {
    crown = true,
    halo = true,
    wings = true,
    shoulder = true,
    plushie = true,
    aura = true,
}

-- Hide bulky cosmetics inside vehicles / while dead so they do not clip the car.
Config.HideInVehicle = {
    crown = false,
    halo = false,
    wings = true,
    shoulder = true,
    plushie = true,
    aura = true,
}

Config.Persist = true
Config.UnequipIfItemMissing = true
Config.MissingItemCheckMs = 8000
Config.ToggleCooldownMs = 250

Config.Notify = true
Config.DebugCommands = true -- /wearcosmetic [item], /clearcosmetics
Config.EditorCommand = 'adjustcosmetic'
Config.EditorAce = nil -- e.g. 'group.admin'; nil = allow everyone

Config.StateBag = 'headCosmetics'

--[[
    Ped bones:
      31086 = SKEL_Head
      24817 = SKEL_Spine2 (chest, hug pose)
      24818 = SKEL_Spine3 (upper back)
      64729 = SKEL_L_Clavicle (left shoulder)

    Wings sit on the upper back (reference: wings spreading behind the shoulders).
    Shoulder pets perch on the left shoulder (reference: small companion on the player's left).

    Fine-tune one item live: /adjustcosmetic angelwings_blue
    Change a preset to move a whole category.
]]
Config.Bones = {
    head = 31086,
    spine2 = 24817,
    spine3 = 24818,
    leftClavicle = 64729,
}

Config.Presets = {
    crown = {
        bone = 31086,
        x = -0.63, y = 0.0, z = 0.0,
        xR = 90.0, yR = 0.0, zR = 90.0,
        category = 'crown',
    },
    halo = {
        bone = 31086,
        x = -0.60, y = 0.0, z = 0.0,
        xR = 90.0, yR = 0.0, zR = 90.0,
        category = 'halo',
    },
    -- Upper back, centered, slightly behind the shoulder blades.
    wings = {
        bone = 24818,
        x = 0.14, y = -0.16, z = 0.0,
        xR = 0.0, yR = 90.0, zR = 180.0,
        category = 'wings',
    },
    -- Player's left shoulder, sitting on top of the clavicle.
    shoulder = {
        bone = 64729,
        x = 0.14, y = 0.02, z = 0.13,
        xR = 0.0, yR = 0.0, zR = 180.0,
        category = 'shoulder',
    },
    plushie = {
        bone = 24817,
        x = 0.0, y = 0.40, z = -0.02,
        xR = 180.0, yR = -90.0, zR = 0.0,
        animDict = 'impexp_int-0',
        animName = 'mp_m_waremech_01_dual-0',
        category = 'plushie',
    },
    aura = {
        bone = 24818,
        x = 0.10, y = -0.12, z = 0.0,
        xR = 0.0, yR = 90.0, zR = 180.0,
        category = 'aura',
    },
}

-- Filled by shared/catalog.lua from the locked cosmetics prop list.
Config.Toys = {}
