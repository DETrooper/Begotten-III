--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwSailing");

game.AddParticles("particles/fire_01.pcf");
PrecacheParticleSystem("env_fire_large");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");