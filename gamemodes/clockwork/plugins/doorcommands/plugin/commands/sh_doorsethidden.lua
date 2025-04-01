--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorSetHidden")
COMMAND.tip = "Set whether a door is hidden."
COMMAND.text = "<bool IsHidden>"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity

	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		if (Clockwork.kernel:ToBool(arguments[1])) then
			local data = {
				position = door:GetPos(),
				entity = door
			};				

			Clockwork.entity:SetDoorHidden(door, true)

			cwDoorCmds.doorData[data.entity] = {
				position = door:GetPos(),
				entity = door,
				text = "hidden",
				name = "hidden"
			}

			cwDoorCmds:SaveDoorData()

			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have hidden this door.")
		else
			Clockwork.entity:SetDoorHidden(door, false)

			cwDoorCmds.doorData[door] = nil
			cwDoorCmds:SaveDoorData()

			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have unhidden this door.")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid door!")
	end
end

COMMAND:Register()