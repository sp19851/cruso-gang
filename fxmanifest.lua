fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Cruso'
description 'Sale of illegal goods'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
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
    'ox_lib'
}
