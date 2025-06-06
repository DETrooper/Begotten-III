--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("DoorLock")
COMMAND.tip = "Lock a door."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "o"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local door = player:GetEyeTraceNoCursor().Entity

	if (IsValid(door) and Clockwork.entity:IsDoor(door)) then
		--door:EmitSound("doors/door_latch3.wav")
		door:Fire("lock", "", 0)

		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have locked the target door.")
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid door!")
	end
end

COMMAND:Register()