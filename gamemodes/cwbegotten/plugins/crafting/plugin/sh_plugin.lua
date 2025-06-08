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

local map = game.GetMap();

if (map == "rp_begotten3") then
	cwRecipes.smithyLocations = {
		Vector(-3725, -11744, -1262),
		Vector(-90, 14176, -1021),
		Vector(-13507, -13422, -1619),
		Vector(-228, -9635, -6436),
		Vector(-704, -7617, 11902),
		Vector(14487, -12316, -1182),
	};
elseif (map == "rp_begotten_redux") then
	cwRecipes.smithyLocations = {
		Vector(-12687, -6497, 85),
		Vector(13505, 10557, 695),
		Vector(-228, -9635, -6436),
	};
elseif (map == "rp_scraptown") then
	cwRecipes.smithyLocations = {
		Vector(-3025, -5089., 203),
		Vector(7605, 8609, 1054),
		Vector(-228, -9635, -6436),
	};
elseif (map == "rp_district21") then
	cwRecipes.smithyLocations = {
		Vector(-11430, 4139, -679),
		Vector(-5481, 12443, 189),
		Vector(6955, 13743, -199),
		Vector(-14131, -3835, -812),
		Vector(-704, -7617, 11902),
		Vector(-228, -9635, -6436),
	};
elseif (map == "bg_district34") then
	cwRecipes.smithyLocations = {
		Vector(1629, -8038, -3456),
		Vector(3935, -8171, 581),
		Vector(2270, 2148, 981), -- Village
		Vector(-1613, 3152, -131),
		Vector(-9798, 14130, 273), -- Scraptown
		Vector(-4249, -10501, 10538),
	}
	
	Clockwork.kernel:IncludePrefixed("sh_recipes_rp_district21.lua");
else
	cwRecipes.smithyLocations = {};
end;

local COMMAND = Clockwork.command:New("AddPileSpawn")
	COMMAND.tip = "Add a pile spawn location using a spawned entity's positions and angles. (Valid types: gorewood, ore, wood)"
	COMMAND.text = "<string Category>"
	COMMAND.access = "s"
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwRecipes:AddPileSpawn(player:GetEyeTrace().Entity, arguments[1], player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemovePileSpawn")
	COMMAND.tip = "Remove a pile spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Distance]"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwRecipes:RemovePileSpawn(player:GetEyeTrace().HitPos, tonumber(arguments[1]) or 64, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("PityOreSpawn")
	COMMAND.tip = "Force an ore pile to have its next drop be gold ore or a blood diamond. Use 'gold' or 'blooddiamond'."
	COMMAND.text = "<string dropType>"
	COMMAND.access = "s"
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local ent = player:GetEyeTrace().Entity;
		
		if IsValid(ent) and ent:GetClass() == "cw_ironorepile" then
			if arguments[1] == "blooddiamond" then
				ent.nextDropOverride = "blooddiamond";
			else
				ent.nextDropOverride = "gold";
			end
		end
	end
COMMAND:Register()