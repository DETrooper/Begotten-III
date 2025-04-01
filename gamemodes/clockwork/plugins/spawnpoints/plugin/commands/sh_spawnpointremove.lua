--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("SpawnPointRemove")
COMMAND.tip = "Remove spawn points at your target position."
COMMAND.text = "<string Class|Faction|Default>"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faction = Clockwork.faction:FindByID(arguments[1])
	local class = Clockwork.class:FindByID(arguments[1])
	local name = nil

	if (class or faction) then
		if (faction) then
			name = faction.name
		else
			name = class.name
		end

		if (cwSpawnPoints.spawnPoints[name]) then
			local position = player:GetEyeTraceNoCursor().HitPos
			local removed = 0

			for k, v in pairs(cwSpawnPoints.spawnPoints[name]) do
				if (v.position:Distance(position) <= 256) then
					cwSpawnPoints.spawnPoints[name][k] = nil

					removed = removed + 1
				end
			end

			if (removed > 0) then
				if (removed == 1) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..name.." spawn point.")
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..name.." spawn points.")
				end
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] There were no "..name.." spawn points near this position.")
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] There are no "..name.." spawn points.")
		end

		cwSpawnPoints:SaveSpawnPoints()
	elseif (string.lower(arguments[1]) == "default") then
		if (cwSpawnPoints.spawnPoints["default"]) then
			local position = player:GetEyeTraceNoCursor().HitPos
			local removed = 0

			for k, v in pairs(cwSpawnPoints.spawnPoints["default"]) do
				if (v.position:Distance(position) <= 256) then
					cwSpawnPoints.spawnPoints["default"][k] = nil

					removed = removed + 1
				end
			end

			if (removed > 0) then
				if (removed == 1) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." default spawn point.")
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." default spawn points.")
				end
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] There were no default spawn points near this position.")
			end
		else
			Schema:EasyText(player, "darkgrey", "["..self.name.."] There are no default spawn points.")
		end

		cwSpawnPoints:SaveSpawnPoints()
	else
		if Clockwork.trait and Clockwork.trait:GetAll()[arguments[1]] then
			if (cwSpawnPoints.spawnPoints[arguments[1]]) then
				local position = player:GetEyeTraceNoCursor().HitPos
				local removed = 0

				for k, v in pairs(cwSpawnPoints.spawnPoints[arguments[1]]) do
					if (v.position:Distance(position) <= 256) then
						cwSpawnPoints.spawnPoints[arguments[1]][k] = nil

						removed = removed + 1
					end
				end

				if (removed > 0) then
					if (removed == 1) then
						Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..arguments[1].." trait spawn point.")
					else
						Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..arguments[1].." trait spawn points.")
					end
				else
					Schema:EasyText(player, "darkgrey", "["..self.name.."] There were no "..arguments[1].." trait spawn points near this position.")
				end
			else
				Schema:EasyText(player, "grey", "["..self.name.."] There are no "..arguments[1].." trait spawn points.")
			end

			cwSpawnPoints:SaveSpawnPoints()
			return;
		end
	
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid class or faction!")
	end
end

COMMAND:Register()