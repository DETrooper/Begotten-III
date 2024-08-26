--[[
	B3 Jessu Weep
--]]

PLUGIN:SetGlobalAlias("cwCooking");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sh_items.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

FOOD_FULL = 0
FOOD_ALMOST_FULL = 1
FOOD_THREE_QUARTERS = 2
FOOD_UNDER_THREE_QUARTERS = 3
FOOD_OVER_HALF = 4
FOOD_HALF = 5
FOOD_UNDER_HALF = 6
FOOD_QUARTER = 7
FOOD_UNDER_QUARTER = 8
FOOD_ALMOST_EMPTY = 9
FOOD_EMPTY = 10;

-- Called when the player's move data should be manipulated.
--function cwCooking:Move(player, moveData)
	--[[local hidden = player:GetNetVar("hidden");
	
	if (hidden) then
		return true;
	end;
	
	local action, percentage = Clockwork.player:GetAction(player, true);
	
	if (action == "hide") then
		return true;
	end;--]]
--end;

--[[
local COMMAND = Clockwork.command:New("CharForceOut");
	COMMAND.tip = "Force a player out of the container they are in. Use 'true' as a second argument to make them quietly exit.";
	COMMAND.text = "<string Name> <bool Quiet>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharForceExitContainer", "ForceExitContainer", "PlyForceExitContainer", "ForceOut", "PlyForceOut"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetOut");
	COMMAND.tip = "Get out of a container you are in.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"GetOut", "PlyGetOut", "CharExitContainer", "ExitContainer", "PlyExitContainer"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
	end;
COMMAND:Register();
--]]