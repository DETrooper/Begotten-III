--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorSetAllOwnable")
COMMAND.tip = "Set all doors ownable."
COMMAND.text = "<string Name>"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	good_doors = 0
	for k,v in pairs(ents.GetAll()) do
		if(IsValid(v) and Clockwork.entity:IsDoor(v)) then
			local data = {
				customName = true,
				position = v:GetPos(),
				entity = v,
				name = table.concat(arguments or {}, " ") or ""
			}
			Clockwork.entity:SetDoorUnownable(data.entity, false)
			Clockwork.entity:SetDoorText(data.entity, false)
			Clockwork.entity:SetDoorName(data.entity, data.name)

			cwDoorCmds.doorData[data.entity] = data
			cwDoorCmds:SaveDoorData()
			good_doors = good_doors + 1
		end
	end

	Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..good_doors.." doors have been set ownable.")
end

COMMAND:Register()