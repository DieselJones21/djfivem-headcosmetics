fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-headcosmetics'
author 'DieselJones'
description 'Wear crowns, halos, wings, shoulder pets, leg wraps, and plushies from inventory items'
version '1.3.0'

shared_scripts {
    'config.lua',
    'shared/props.lua',
}

client_scripts {
    'client/main.lua',
    'client/editor.lua',
}

server_scripts {
    'server/main.lua',
}

-- Models are streamed by the cosmetics resource, or by your existing prop packs.
-- Do not add DLC_ITYP_REQUEST here or the same .ydr files will load twice.

dependencies {
    '/onesync',
}
