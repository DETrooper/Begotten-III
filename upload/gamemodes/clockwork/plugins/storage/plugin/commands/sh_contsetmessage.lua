--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("ContSetMessage")
COMMAND.tip = "Set a container's message."
COMMAND.text = "<string Message>"
COMMAND.flags = CMD_DEFAULT
COMMAND.arguments = 1
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			trace.Entity.cwMessage = arguments[1]
			cwStorage:SaveStorage()

			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set this container's message.")
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()