--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorResetParent")
COMMAND.tip = "Reset the player's active parent door."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	cwDoorCmds.infoTable = cwDoorCmds.infoTable or {}

	if (IsValid(player.cwParentDoor)) then
		player.cwParentDoor = nil
		cwDoorCmds.infoTable = {}

		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have cleared your active parent door.")
		netstream.Start(player, "doorParentESP", cwDoorCmds.infoTable)
	else
		Schema:EasyText(player, "grey", "["..self.name.."] You do not have an active parent door.")
	end
end

COMMAND:Register()