fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-headcosmetics'
author 'DieselJones'
description 'Wear crowns, halos, and other head props from inventory items'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'client/editor.lua',
}

server_scripts {
    'server/main.lua',
}

-- Registers the streamed crown/halo archetypes. Copy your .ydr + .ytyp files into stream/.
data_file 'DLC_ITYP_REQUEST' 'stream/crown_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/n93_halos.ytyp'

dependencies {
    '/onesync',
}
