
--[[-------------------------------------------------------------------
	Roll Mod:
		Dodge, duck, dip, dive and... roll!
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
----------------------------------------------------------------------[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
-------------------------- Copyright 2017, David "King David" Wiltos ]]--

wOS = wOS or {}
wOS.RollMod = wOS.RollMod or {}

if SERVER then

	AddCSLuaFile( "wos/rollmod/config.lua" )
	AddCSLuaFile( "wos/rollmod/sh_anim.lua" )
	AddCSLuaFile( "wos/rollmod/cl_init.lua" )
	include( "wos/rollmod/sv_init.lua" )
	
else

	include( "wos/rollmod/cl_init.lua" )

end

include( "wos/rollmod/config.lua" )
include( "wos/rollmod/sh_anim.lua" )
