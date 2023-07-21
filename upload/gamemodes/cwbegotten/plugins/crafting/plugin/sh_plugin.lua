--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwRecipes");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Certain recipes won't load until after the items have been initialized, so they need to be required manually to ensure the correct order.
Clockwork.kernel:IncludePrefixed("sh_crafting_materials.lua");
Clockwork.kernel:IncludePrefixed("sh_recipes.lua");

cwRecipes.smithyLocations = {};

if (game.GetMap() == "rp_begotten3") then
	cwRecipes.smithyLocations = {
		Vector(-3725, -11744, -1262),
		Vector(-90, 14176, -1021),
		Vector(-13507, -13422, -1619),
		Vector(-228, -9635, -6436),
		Vector(-704, -7617, 11902),
		Vector(14487, -12316, -1182),
	};
elseif (game.GetMap() == "rp_begotten_redux") then
	cwRecipes.smithyLocations = {
		Vector(-12687, -6497, 85),
		Vector(13505, 10557, 695),
		Vector(-228, -9635, -6436),
	};
elseif (game.GetMap() == "rp_scraptown") then
	cwRecipes.smithyLocations = {
		Vector(-3025, -5089., 203),
		Vector(7605, 8609, 1054),
		Vector(-228, -9635, -6436),
	};
else
	cwRecipes.smithyLocations = {};
end;
