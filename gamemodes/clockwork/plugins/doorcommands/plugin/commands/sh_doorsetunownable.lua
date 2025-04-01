--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorSetUnownable")
COMMAND.tip = "Set an unownable door."
COMMAND.text = "<string Name> [string Text]"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1
COMMAND.optionalArguments = true

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity

	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		local data = {
			position = door:GetPos(),
			entity = door,
			text = arguments[2],
			name = arguments[1]
		}

		Clockwork.entity:SetDoorName(data.entity, data.name)
		Clockwork.entity:SetDoorText(data.entity, data.text)
		Clockwork.entity:SetDoorUnownable(data.entity, true)

		cwDoorCmds.doorData[data.entity] = data
		cwDoorCmds:SaveDoorData()

		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set an unownable door.")
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid door!")
	end
end

COMMAND:Register()