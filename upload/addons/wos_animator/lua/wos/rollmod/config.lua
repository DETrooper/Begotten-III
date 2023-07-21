
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

-- How many seconds does the player have to put that second tap in for double-tap rolling
wOS.RollMod.Sensitivity = 0.3

--Speed you go when you are rolling
wOS.RollMod.RollSpeed = 200

--These are the damage types you can dodge while rolling. 
--Set them to true so they are dodgeable, false for the opposite
wOS.RollMod.Dodgeables = {}
wOS.RollMod.Dodgeables[ DMG_GENERIC ] = false
wOS.RollMod.Dodgeables[ DMG_CRUSH ] = false
wOS.RollMod.Dodgeables[ DMG_BULLET ] = false
wOS.RollMod.Dodgeables[ DMG_SLASH ] = true
wOS.RollMod.Dodgeables[ DMG_CLUB ] = true
wOS.RollMod.Dodgeables[ DMG_VEHICLE ] = true
wOS.RollMod.Dodgeables[ DMG_BURN ] = false
wOS.RollMod.Dodgeables[ DMG_BLAST ] = false
wOS.RollMod.Dodgeables[ DMG_SHOCK ] = false
wOS.RollMod.Dodgeables[ DMG_SONIC ] = false
wOS.RollMod.Dodgeables[ DMG_ENERGYBEAM ] = false
wOS.RollMod.Dodgeables[ DMG_BUCKSHOT ] = false

wOS.RollMod.Animations = {}
wOS.RollMod.Animations[2] = "begotten_roll_forward"
wOS.RollMod.Animations[3] = "begotten_roll_back"
wOS.RollMod.Animations[4] = "begotten_roll_left"
wOS.RollMod.Animations[5] = "begotten_roll_right"
wOS.RollMod.Animations[6] = "begotten_flip_forward"
wOS.RollMod.Animations[7] = "begotten_flip_back"
wOS.RollMod.Animations[8] = "begotten_flip_left"
wOS.RollMod.Animations[9] = "begotten_flip_right"