local COMMAND = Clockwork.command:New("TempSpawnPointAdd");
COMMAND.tip = "Add a temporary spawn point at your target position."
COMMAND.text = "<string Class|Faction|Default> [number Rotate]"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1
COMMAND.optionalArguments = 1
 
-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local faction = Clockwork.faction:FindByID(arguments[1])
	local class = Clockwork.class:FindByID(arguments[1])
	local name = nil
	local rotate = tonumber(arguments[2]) or nil

	if (class or faction) then
		if (faction) then
			name = faction.name
		else
			name = class.name
		end

		if not cwTempSpawns.spawnPoints then
			cwTempSpawns.spawnPoints = {};
		end
		
		cwTempSpawns.spawnPoints[name] = cwTempSpawns.spawnPoints[name] or {}
		cwTempSpawns.spawnPoints[name][#cwTempSpawns.spawnPoints[name] + 1] = {position = player:GetEyeTraceNoCursor().HitPos, rotate = rotate}

		Schema:EasyText(player, "cornflowerblue", "You have added a temporary spawn point for "..name..".")
	elseif (string.lower(arguments[1]) == "default") then
		cwTempSpawns.spawnPoints["default"] = cwTempSpawns.spawnPoints["default"] or {}
		cwTempSpawns.spawnPoints["default"][#cwTempSpawns.spawnPoints["default"] + 1] = {position = player:GetEyeTraceNoCursor().HitPos, rotate = rotate}
		
		Schema:EasyText(player, "cornflowerblue", "You have added a factionless temporary spawn point.")
	else
		Schema:EasyText(player, "grey", "This is not a valid class or faction!")
	end
end;
 
COMMAND:Register();

local COMMAND = Clockwork.command:New("TempSpawnPointRemove")
COMMAND.tip = "Remove temporary spawn points at your target position."
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
		
		if not cwTempSpawns.spawnPoints then
			cwTempSpawns.spawnPoints = {};
		end

		if (cwTempSpawns.spawnPoints[name]) then
			local position = player:GetEyeTraceNoCursor().HitPos
			local removed = 0

			for k, v in pairs(cwTempSpawns.spawnPoints[name]) do
				if (v.position:Distance(position) <= 256) then
					cwTempSpawns.spawnPoints[name][k] = nil

					removed = removed + 1
				end
			end

			if (removed > 0) then
				if (removed == 1) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..name.." temporary spawn point.")
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." "..name.." temporary spawn points.")
				end
			else
				Schema:EasyText(player, "cornflowerblue", "There were no "..name.." temporary spawn points near this position.")
			end
		else
			Schema:EasyText(player, "darkgrey", "There are no "..name.." temporary spawn points.")
		end
	elseif (string.lower(arguments[1]) == "default") then
		if (cwTempSpawns.spawnPoints["default"]) then
			local position = player:GetEyeTraceNoCursor().HitPos
			local removed = 0

			for k, v in pairs(cwTempSpawns.spawnPoints["default"]) do
				if (v.position:Distance(position) <= 256) then
					cwTempSpawns.spawnPoints["default"][k] = nil

					removed = removed + 1
				end
			end

			if (removed > 0) then
				if (removed == 1) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." factionless temporary spawn point.")
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..removed.." factionless temporary spawn points.")
				end
			else
				Schema:EasyText(player, "cornflowerblue", "There were no factionless temporary spawn points near this position.")
			end
		else
			Schema:EasyText(player, "darkgrey", "There are no factionless temporary spawn points.")
		end
	else
		Schema:EasyText(player, "grey", "This is not a valid class or faction!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ClearTempSpawnPoints")
COMMAND.tip = "Remove all temporary spawn points on the map."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.alias = {"TempSpawnPointRemoveAll"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	cwTempSpawns.spawnPoints = {};
end

COMMAND:Register()