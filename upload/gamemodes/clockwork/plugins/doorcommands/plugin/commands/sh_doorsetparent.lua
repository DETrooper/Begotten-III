--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorSetParent")
COMMAND.tip = "Set the active parent door to your target."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity

	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		cwDoorCmds.infoTable = cwDoorCmds.infoTable or {}

		player.cwParentDoor = door
		cwDoorCmds.infoTable.Parent = door

		for k, parent in pairs(cwDoorCmds.parentData) do
			if (parent == door) then
				table.insert(cwDoorCmds.infoTable, k)
			end
		end

		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set the active parent door to this. The parent has been highlighted orange, and its children blue.")

		if (cwDoorCmds.infoTable != {}) then
			netstream.Start(player, "doorParentESP", cwDoorCmds.infoTable)
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid door!")
	end
end

COMMAND:Register()