--[[
	Begotten Code
--]]

local COMMAND = Clockwork.command:New();
	COMMAND.tip = "Barricade the door you're looking at.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:Alive()) then
			Clockwork.plugin:Call("AddPlankToDoor", player);
		end;
	end;
Clockwork.command:Register(COMMAND, "BarricadeDoor");