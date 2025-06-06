util.Include("cl_plugin.lua")
util.Include("cl_hooks.lua")
util.Include("cl_types.lua")


--[[
local COMMAND = Clockwork.command:New("example");
	COMMAND.tip = ":0";
	COMMAND.text = "args desc here";
	COMMAND.access = "o";
	COMMAND.arguments = 3;
	COMMAND.optionalArguments = 1;
	COMMAND.types = {"Player", "Weather", "Player", "Weather"}
	COMMAND.alias = {"aliasexample", "examplealias"};
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		print(arguments[1], arguments[2], arguments[3], arguments[4])
	end;
COMMAND:Register();

]]