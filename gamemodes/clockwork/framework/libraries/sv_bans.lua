--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("bans", Clockwork)

local stored = Clockwork.bans.stored or {}
Clockwork.bans.stored = stored

--[[
	A local function to handle ban deletion.
	INTERNAL USE ONLY. DO NOT USE.
--]]
local function DELETE_BAN(identifier)
	stored[identifier] = nil

	local queryObj = Clockwork.database:Delete(bansTable)
		queryObj:Where("_Schema", schemaFolder)
		queryObj:Where("_Identifier", identifier)
	queryObj:Execute()
end

--[[
	A local function to handle the loading of bans.
	INTERNAL USE ONLY. DO NOT USE.
--]]
local function BANS_LOAD_CALLBACK(result)
	if (Clockwork.database:IsResult(result)) then
		stored = stored or {}

		for k, v in pairs(result)do
			stored[v._Identifier] = {
				unbanTime = tonumber(v._UnbanTime),
				steamName = v._SteamName,
				duration = tonumber(v._Duration),
				reason = v._Reason
			}
		end
	end
end

-- A function to load the bans.
function Clockwork.bans:Load()
	local bansTable = config.Get("mysql_bans_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()

	local queryObj = Clockwork.database:Select(bansTable)
		queryObj:Callback(BANS_LOAD_CALLBACK)
		queryObj:Where("_Schema", schemaFolder)
	queryObj:Execute()

	local unixTime = os.time()

	for k, v in pairs(stored) do
		if (type(v) == "table") then
			if (v.unbanTime > 0 and unixTime >= v.unbanTime) then
				self:Remove(k, true)
			end
		else
			DELETE_BAN(k)
		end
	end
end

-- A function to add a ban.
function Clockwork.bans:Add(identifier, duration, reason, Callback, bSaveless)
	local steamName = nil
	local playerGet = _player.Find(identifier)
	local bansTable = config.Get("mysql_bans_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()

	if (identifier) then
		identifier = string.upper(identifier)
	end

	for _, v in _player.Iterator() do
		local playerIP = v:IPAddress()
		local playerSteam = v:SteamID()

		if (playerSteam == identifier or playerIP == identifier or playerGet == v) then
			hook.Run("PlayerBanned", v, duration, reason)

			if (playerIP == identifier) then
				identifier = playerIP
			else
				identifier = playerSteam
			end

			steamName = v:SteamName()
			v:Kick(reason)
		end
	end

	if (!reason) then
		reason = "Banned for an unspecified reason."
	end

	if (steamName) then
		if (duration == 0) then
			stored[identifier] = {
				unbanTime = 0,
				steamName = steamName,
				duration = duration,
				reason = reason
			}
		else
			stored[identifier] = {
				unbanTime = os.time() + duration,
				steamName = steamName,
				duration = duration,
				reason = reason
			}
		end

		if (!bSaveless) then
			local queryObj = Clockwork.database:Insert(bansTable)
				queryObj:Insert("_Identifier", identifier)
				queryObj:Insert("_UnbanTime", stored[identifier].unbanTime)
				queryObj:Insert("_SteamName", stored[identifier].steamName)
				queryObj:Insert("_Duration", stored[identifier].duration)
				queryObj:Insert("_Reason", stored[identifier].reason)
				queryObj:Insert("_Schema", schemaFolder)
			queryObj:Execute()
		end

		if (Callback) then
			Callback(steamName, duration, reason)
		end

		return
	end

	local playersTable = config.Get("mysql_players_table"):Get()

	if (string.find(identifier, "STEAM_(%d+):(%d+):(%d+)")) then
		local queryObj = Clockwork.database:Select(playersTable)
			queryObj:Where("_SteamID", identifier)
			queryObj:Callback(function(result)
				local steamName = identifier

				if (Clockwork.database:IsResult(result)) then
					steamName = result[1]._SteamName
				end

				if (duration == 0) then
					stored[identifier] = {
						unbanTime = 0,
						steamName = steamName,
						duration = duration,
						reason = reason
					}
				else
					stored[identifier] = {
						unbanTime = os.time() + duration,
						steamName = steamName,
						duration = duration,
						reason = reason
					}
				end

				if (!bSaveless) then
					local insertObj = Clockwork.database:Insert(bansTable)
						insertObj:Insert("_Identifier", identifier)
						insertObj:Insert("_UnbanTime", stored[identifier].unbanTime)
						insertObj:Insert("_SteamName", stored[identifier].steamName)
						insertObj:Insert("_Duration", stored[identifier].duration)
						insertObj:Insert("_Reason", stored[identifier].reason)
						insertObj:Insert("_Schema", schemaFolder)
					insertObj:Execute()
				end

				if (Callback) then
					Callback(steamName, duration, reason)
				end
			end)
		queryObj:Execute()

		return
	end

	--[[ In this case we're banning them by their IP address. --]]
	if (string.find(identifier, "%d+%.%d+%.%d+%.%d+")) then
		local queryObj = Clockwork.database:Select(playersTable)	
			queryObj:Callback(function(result)
				local steamName = identifier

				if (Clockwork.database:IsResult(result)) then
					steamName = result[1]._SteamName
				end

				if (duration == 0) then
					stored[identifier] = {
						unbanTime = 0,
						steamName = steamName,
						duration = duration,
						reason = reason
					}
				else
					stored[identifier] = {
						unbanTime = os.time() + duration,
						steamName = steamName,
						duration = duration,
						reason = reason
					}
				end

				if (!bSaveless) then
					local insertObj = Clockwork.database:Insert(bansTable)
						insertObj:Insert("_Identifier", identifier)
						insertObj:Insert("_UnbanTime", stored[identifier].unbanTime)
						insertObj:Insert("_SteamName", stored[identifier].steamName)
						insertObj:Insert("_Duration", stored[identifier].duration)
						insertObj:Insert("_Reason", stored[identifier].reason)
						insertObj:Insert("_Schema", schemaFolder)
					insertObj:Push()
				end

				if (Callback) then
					Callback(steamName, duration, reason)
				end
			end)
			queryObj:Where("_IPAddress", identifier)
		queryObj:Execute()

		return
	end

	if (duration == 0) then
		stored[identifier] = {
			unbanTime = 0,
			steamName = steamName,
			duration = duration,
			reason = reason
		}
	else
		stored[identifier] = {
			unbanTime = os.time() + duration,
			steamName = steamName,
			duration = duration,
			reason = reason
		}
	end

	if (!bSaveless) then
		local queryObj = Clockwork.database:Insert(bansTable)
			queryObj:Insert("_Identifier", identifier)
			queryObj:Insert("_UnbanTime", stored[identifier].unbanTime)
			queryObj:Insert("_SteamName", stored[identifier].steamName)
			queryObj:Insert("_Duration", stored[identifier].duration)
			queryObj:Insert("_Reason", stored[identifier].reason)
			queryObj:Insert("_Schema", schemaFolder)
		queryObj:Execute()
	end

	if (Callback) then
		Callback(steamName, duration, reason)
	end
end

-- A function to remove a ban.
function Clockwork.bans:Remove(identifier, bSaveless)
	local bansTable = config.Get("mysql_bans_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()

	if (stored[identifier]) then
		hook.Run("PrePlayerUnbanned", identifier, table.Copy(stored[identifier]));
		stored[identifier] = nil

		if (!bSaveless) then
			local queryObj = Clockwork.database:Delete(bansTable)
				queryObj:Where("_Schema", schemaFolder)
				queryObj:Where("_Identifier", identifier)
			queryObj:Execute()
		end
	end
end