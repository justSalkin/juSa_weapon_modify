game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'justSalkin'
description 'SN scratcher'
version '1.0'

client_scripts {
   'client.lua',
}

server_scripts {
   'server.lua',
}

shared_scripts {
    'config.lua',
}

dependencies {
    'vorp_core',
    'vorp_inventory'
}