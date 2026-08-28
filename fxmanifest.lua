fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-headcosmetics'
author 'DieselJones'
description 'Wear crowns, halos, and hug plushies from inventory items'
version '1.1.0'

shared_scripts {
    'config.lua',
    'shared/plushes.lua',
}

client_scripts {
    'client/main.lua',
    'client/editor.lua',
}

server_scripts {
    'server/main.lua',
}

-- Models are streamed by your existing crown / halo / plushie resources.
-- Do not add DLC_ITYP_REQUEST here or the same .ydr files will load twice.

dependencies {
    '/onesync',
}
