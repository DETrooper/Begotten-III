--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwScrapFactory");

game.AddParticles("particles/steampuff.pcf");
PrecacheParticleSystem("steam_jet_80_steam");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");