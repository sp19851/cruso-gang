fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Cruso'
description 'Sale of illegal goods'
version '0.0.1'

shared_scripts {
    'config.lua'
    
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
dependency {
    'qb-core',
    'oxmysql',
    'qb-target'
    'ox_lib'
}