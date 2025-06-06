--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

PLUGIN:SetGlobalAlias("cwLimbs");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

if (SERVER) then
	config.Add("limb_damage_system", true, true)
else
	config.AddToSystem("Limb Damage System Enabled", "limb_damage_system", "Whether or not limb damage is enabled.");
end;

config.ShareKey("limb_damage_system")