--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

PLUGIN:SetGlobalAlias("cwCleanedMaps")

if (CLIENT) then
	config.AddToSystem("Remove Map Physics", "remove_map_physics", "Whether or not physics entities should be removed when the map is loaded.")
end;

util.Include("sv_plugin.lua")
util.Include("sv_hooks.lua")