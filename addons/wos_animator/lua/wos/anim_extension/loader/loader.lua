--[[-------------------------------------------------------------------
	wiltOS Animation Register:
		A simple register to keep track of all wiltOS extensions installed
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
----------------------------------------]]--

wOS = wOS or {}
wOS.AnimExtension = wOS.AnimExtension or {}
wOS.AnimExtension.Mounted = wOS.AnimExtension.Mounted or {}

local string = string
local file = file

local function _AddCSLuaFile( lua )

	if SERVER then
		AddCSLuaFile( lua )
	end
	
end

local function _include( load_type, lua )

	if load_type then
		include( lua )
	end
	
end

function wOS.AnimExtension:Autoloader()
	
	for _,source in pairs( file.Find( "wos/anim_extension/extensions/*", "LUA"), true ) do
		local lua = "wos/anim_extension/extensions/" .. source
		_AddCSLuaFile( lua )
		_include( SERVER, lua )
		_include( CLIENT, lua )
	end
	
	_AddCSLuaFile( "wos/anim_extension/vgui/wiltos_anim_viewer.lua" )
	_include( CLIENT, "wos/anim_extension/vgui/wiltos_anim_viewer.lua" )
	
	_AddCSLuaFile( "wos/anim_extension/core/sh_metatable.lua" )
	_include( SERVER, "wos/anim_extension/core/sh_metatable.lua" )
	_include( CLIENT, "wos/anim_extension/core/sh_metatable.lua" )
	
	_AddCSLuaFile( "wos/anim_extension/core/sh_holdtypes.lua" )
	_include( SERVER, "wos/anim_extension/core/sh_holdtypes.lua" )
	_include( CLIENT, "wos/anim_extension/core/sh_holdtypes.lua" )

	_AddCSLuaFile( "wos/anim_extension/core/sh_prone_support.lua" )
	_include( SERVER, "wos/anim_extension/core/sh_prone_support.lua" )
	_include( CLIENT, "wos/anim_extension/core/sh_prone_support.lua" )
	
	for _,source in pairs( file.Find( "wos/anim_extension/holdtypes/*", "LUA"), true ) do
		local lua = "wos/anim_extension/holdtypes/" .. source
		_AddCSLuaFile( lua )
		_include( SERVER, lua )
		_include( CLIENT, lua )
	end
	
end

wOS.AnimExtension:Autoloader()