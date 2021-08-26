fx_version 'adamant'
games { 'gta5' }

author 'Bob'
description 'Bobs Fruit Schnapps'
version '0.1'

client_scripts {
	'config.lua',
    'client/functions.lua',
    'client/main.lua',
	'client/sell.lua',
	'client/npc.lua'
}

server_scripts {
	'config.lua',
	'server/functions.lua',
    'server/main.lua',
	'server/sell.lua'
}