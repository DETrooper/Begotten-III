--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwIntroduction");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local map = game.GetMap();

local customIntros = {
    ["rp_district21"] = true,
};

if	(customIntros[map]) then
    Clockwork.kernel:IncludePrefixed("cl_hooks_"..map..".lua");
    return;

end

Clockwork.kernel:IncludePrefixed("cl_hooks_begotten.lua");