--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorUnparent")
COMMAND.tip = "Unparent the target door."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity

	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		cwDoorCmds.infoTable = cwDoorCmds.infoTable or {}

		if (cwDoorCmds.parentData[door] == player.cwParentDoor) then
			for k, v in pairs(cwDoorCmds.infoTable) do
				if (v == door) then
					table.remove(cwDoorCmds.infoTable, k)
				end
			end
		end

		netstream.Start(player, "doorParentESP", cwDoorCmds.infoTable)

		cwDoorCmds.parentData[door] = nil
		cwDoorCmds:SaveParentData()

		Clockwork.entity:SetDoorParent(door, false)

		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have unparented this door.")
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid door!")
	end
end

COMMAND:Register()