--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwDayNight");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local COMMAND = Clockwork.command:New("SetCycle");
	COMMAND.tip = "Set whether it should be day or night. \"Force\" argument skips the transitionary period. \"Notify\" argument determines if a /event is automatically made.";
	COMMAND.text = "<string Cycle> [bool Force] [bool Notify]";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local arg_1 = arguments[1];
		
		if arg_1 == "day" or arg_1 == "night" then
			if (SERVER) then
				local notify = true;
				
				if arguments[3] then
					notify = tobool(arguments[3]);
				end
				
				if tobool(arguments[2]) == true then
					cwDayNight:ChangeCycle(arg_1, notify);
				else
					if arg_1 == "day" then
						cwDayNight:ChangeCycle("nighttoday", notify);
					else
						cwDayNight:ChangeCycle("daytonight", notify);
					end
				end
			end;
		else
			Schema:EasyText(player, "darkgrey", "This is not a valid cycle! The valid cycles are \"day\" and \"night\".");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ChangeCycleLength");
	COMMAND.tip = "Append or subtract from a cycle's length.";
	COMMAND.text = "<number Seconds>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local seconds = tonumber(arguments[1] or 0);
		
		if seconds then
			cwDayNight:ModifyCycleTimeLeft(seconds);
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] ".."The time left for "..cwDayNight:GetCurrentCycle().." is now "..tostring(cwDayNight:GetCycleTimeLeft()).." seconds!");
		else
			Schema:EasyText(player, "darkgrey", "This is not a valid amount!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GetCycle");
	COMMAND.tip = "Get the current cycle of the day/night cycle.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] ".."The current time of day is: "..cwDayNight:GetCurrentCycle().." with "..tostring(cwDayNight:GetCycleTimeLeft()).." seconds left!");
	end;
COMMAND:Register();