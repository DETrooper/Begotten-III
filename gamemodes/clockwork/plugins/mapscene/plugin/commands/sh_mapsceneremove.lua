--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("MapSceneRemove")
COMMAND.tip = "Remove map scenes at your current position."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (#cwMapScene.storedList > 0) then
		local position = player:EyePos()
		local removed = 0

		for k, v in pairs(cwMapScene.storedList) do
			if (v.position:Distance(position) <= 256) then
				cwMapScene.storedList[k] = nil

				removed = removed + 1
			end
		end

		if (removed > 0) then
			if (removed == 1) then
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." map scene.")
			else
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." map scenes.")
			end
		else
			Schema:EasyText(player, "darkgrey", "["..self.name.."] There were no map scenes near this position.")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] There are no map scenes.")
	end
end

COMMAND:Register()