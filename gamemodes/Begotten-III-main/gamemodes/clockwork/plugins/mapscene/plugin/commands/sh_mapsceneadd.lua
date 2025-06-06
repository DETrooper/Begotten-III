--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("MapSceneAdd")
COMMAND.tip = "Add a map scene at your current position."
COMMAND.text = "<bool ShouldSpin>"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.optionalArguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local data = {
		shouldSpin = Clockwork.kernel:ToBool(arguments[1]),
		position = player:EyePos(),
		angles = player:EyeAngles()
	}

	cwMapScene.storedList[#cwMapScene.storedList + 1] = data
	cwMapScene:SaveMapScenes()

	Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have added a map scene.")
end

COMMAND:Register()