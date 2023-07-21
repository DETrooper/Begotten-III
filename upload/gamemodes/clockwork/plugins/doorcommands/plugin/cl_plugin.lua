--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

config.AddToSystem("Doors Default Hidden", "default_doors_hidden", "Set whether doors are hidden and unownable by default.")
config.AddToSystem("Doors Save State", "doors_save_state", "Set whether or not doors will save being open or closed and locked.")

-- Called to sync the ESP data.
netstream.Hook("doorParentESP", function(data)
	cwDoorCmds.doorHalos = data
end)

-- Called before halos need to be rendered.
function cwDoorCmds:PreDrawHalos()
end