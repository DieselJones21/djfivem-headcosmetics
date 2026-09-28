Config = Config or {}

--[[
    Framework / inventory are auto-detected.
    Override only if detection picks the wrong one.
]]
Config.Framework = 'auto' -- 'auto' | 'qb' | 'qbx' | 'esx' | 'standalone'
Config.Inventory = 'auto' -- 'auto' | 'ox' | 'qb' | 'esx' | 'qs'

-- Printed once if a model fails to load and this resource is not started.
-- Set to '' when the .ydr files live in several packs instead of one resource.
Config.StreamResource = 'cosmetics'

-- One equipped item per category. Different categories can be worn together.
Config.ReplaceSameCategory = {
    crown = true,
    halo = true,
    plushie = true,
    wings = true,
    shoulder = true,
    leg = true,
}

-- Hide bulky cosmetics inside vehicles and while dead so they do not clip.
Config.HideInVehicle = {
    crown = false,
    halo = false,
    wings = true,
    shoulder = true,
    plushie = true,
    leg = true,
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

-- Item table is built in shared/props.lua. Key = item name = streamed model name.
Config.Toys = {}
