--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (config and !Clockwork.DebugMode) then return end

library.New("config", _G)
local indexes = config.indexes or {}
local stored = config.stored or {}
local cache = config.cache or {}
local map = config.map or {}
config.indexes = indexes
config.stored = stored
config.cache = cache
config.map = map

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE}

-- Called when the config is invoked as a function.
function CLASS_TABLE:__call(parameter, failSafe)
	return self:Query(parameter, failSafe)
end

-- Called when the config is converted to a string.
function CLASS_TABLE.__tostring()
	return "CONFIG["..self("key").."]"
end

-- A function to create a new config object.
function CLASS_TABLE:Create(key)
	local cfg = Clockwork.kernel:NewMetaTable(CLASS_TABLE)
		cfg.data = stored[key]
		cfg.key = key
	return cfg
end

-- A function to check if the config is valid.
function CLASS_TABLE:IsValid()
	return self.data != nil
end

-- A function to query the config.
function CLASS_TABLE:Query(key, failSafe)
	if (self.data and self.data[key] != nil) then
		return self.data[key]
	else
		return failSafe
	end
end

-- A function to get the config's value as a boolean.
function CLASS_TABLE:GetBoolean(failSafe)
	if (self.data) then
		return (self.data.value == true or self.data.value == "true"
		or self.data.value == "yes" or self.data.value == "1" or self.data.value == 1)
	elseif (failSafe != nil) then
		return failSafe
	else
		return false
	end
end

-- A function to get a config's value as a number.
function CLASS_TABLE:GetNumber(failSafe)
	if (self.data) then
		return tonumber(self.data.value) or failSafe or 0
	else
		return failSafe or 0
	end
end

-- A function to get a config's value as a string.
function CLASS_TABLE:GetString(failSafe)
	if (self.data) then
		return tostring(self.data.value)
	else
		return failSafe or ""
	end
end

-- A function to get a config's default value.
function CLASS_TABLE:GetDefault(failSafe)
	if (self.data) then
		return self.data.default
	else
		return failSafe
	end
end

-- A function to get the config's next value.
function CLASS_TABLE:GetNext(failSafe)
	if (self.data and self.data.nextValue != nil) then
		return self.data.nextValue
	else
		return failSafe
	end
end

-- A function to get the config's value.
function CLASS_TABLE:Get(failSafe)
	if (self.data and self.data.value != nil) then
		return self.data.value
	else
		return failSafe
	end
end

-- A function to set whether the config has initialized.
function config.SetInitialized(bInitalized)
	config.cwInitialized = bInitalized
end

-- A function to get whether the config has initialized.
function config.HasInitialized()
	return config.cwInitialized
end

-- A function to get whether a config value is valid.
function config.IsValidValue(value)
	return isstring(value) or isnumber(value) or isbool(value)
end

-- A function to share a config key.
function config.ShareKey(key)
	local shortCRC = Clockwork.kernel:GetShortCRC(key)

	if (SERVER) then
		indexes[key] = shortCRC
	else
		indexes[shortCRC] = key
	end
end

-- A function to get the stored config.
function config.GetStored()
	return stored
end

-- A function to import a config file.
function config.Import(fileName)
	local data = _file.Read(fileName, "GAME") or ""

	for k, v in pairs(string.Explode("\n", data)) do
		if (v != "" and !string.find(v, "^%s$")) then
			if (!string.find(v, "^%[.+%]$") and !string.find(v, "^//")) then
				local class, key, value = string.match(v, "^(.-)%s(.-)%s=%s(.+);")

				if (class and key and value) then
					if (string.find(class, "boolean")) then
						value = (value == "true" or value == "yes" or value == "1")
					elseif (string.find(class, "number")) then
						value = tonumber(value)
					end

					local forceSet = string.find(class, "force") != nil
					local isGlobal = string.find(class, "global") != nil
					local isShared = string.find(class, "shared") != nil
					local isStatic = string.find(class, "static") != nil
					local isPrivate = string.find(class, "private") != nil
					local needsRestart = string.find(class, "restart") != nil

					if (value) then
						local cfg = config.Get(key)

						if (!cfg:IsValid()) then
							config.Add(key, value, isShared, isGlobal, isStatic, isPrivate, needsRestart)
						else
							cfg:Set(value, nil, forceSet)
						end
					end
				end
			end
		end
	end
end

-- A function to load an INI file.
function config.LoadINI(fileName, bFromGame, bStripQuotes)
	local bSuccess, value = pcall(file.Read, fileName, (bFromGame and "GAME" or "DATA"))

	if (bSuccess and value != nil) then
		local explodedData = string.Explode("\n", value)
		local outputTable = {}
		local currentNode = ""

		local function StripComment(line)
			local startPos, endPos = line:find("[;#]")

			if (startPos) then
				line = line:sub(1, startPos - 1):Trim()
			end

			return line
		end

		local function StripQuotes(line)
			return line:gsub("[\"]", ""):Trim()
		end

		for k, v in pairs(explodedData) do
			local line = StripComment(v):gsub("\n", "")

			if (line != "") then
				if (bStripQuotes) then
					line = StripQuotes(line)
				end

				if (line:sub(1, 1) == "[") then
					local startPos, endPos = line:find("%]")

					if (startPos) then
						currentNode = line:sub(2, startPos - 1)

						if (!outputTable[currentNode]) then
							outputTable[currentNode] = {}
						end
					else
						return false
					end
				elseif (currentNode == "") then
					return false
				else
					local data = string.Explode("=", line)

					if (#data > 1) then
						local key = data[1]
						local value = table.concat(data, "=", 2)

						if (tonumber(value)) then
							outputTable[currentNode][key] = tonumber(value)
						elseif (value == "true" or value == "false") then
							outputTable[currentNode][key] = (value == "true")
						else
							outputTable[currentNode][key] = value
						end
					end
				end
			end
		end

		return outputTable
	end
end

-- A function to parse config keys.
function config.Parse(text)
	for key in string.gmatch(text, "%$(.-)%$") do
		local value = config.Get(key):Get()

		if (value != nil) then
			text = Clockwork.kernel:Replace(text, "$"..key.."$", tostring(value))
		end
	end

	return text
end

-- A function to get a config object.
function config.Get(key)
	if (!cache[key]) then
		local configObject = CLASS_TABLE:Create(key)

		if (configObject.data) then
			cache[key] = configObject
		end

		return configObject
	else
		return cache[key]
	end
end

function config.GetVal(key, failSafe)
	local configEntry = stored[key]

	if (configEntry) then
		return configEntry.value
	else
		return failSafe
	end
end

if (SERVER) then
	function config.Save(fileName, configTable)
		if (configTable) then
			local cfg = {global = {}, schema = {}}

			for k, v in pairs(configTable) do
				if (!v.map and !v.temporary and !string.find(k, "mysql_")) then
					local value = v.value

					if (v.nextValue != nil) then
						value = v.nextValue
					end

					if (value != v.default) then
						if (v.isGlobal) then
							cfg.global[k] = {
								value = value,
								default = v.default
							}
						else
							cfg.schema[k] = {
								value = value,
								default = v.default
							}
						end
					end
				end
			end

			Clockwork.kernel:SaveClockworkData(fileName, cfg.global)
			Clockwork.kernel:SaveSchemaData(fileName, cfg.schema)
		else
			Clockwork.kernel:DeleteClockworkData(fileName)
			Clockwork.kernel:DeleteSchemaData(fileName)
		end
	end

	-- A function to send the config to a player.
	function config.Send(player, key)
		if (player and player:IsBot()) then
			hook.Run("PlayerConfigInitialized", player)
				player.cwConfigInitialized = true
			return
		end

		if (!player) then
			player = _player.GetAll()
		else
			player = {player}
		end

		if (key) then
			if (stored[key]) then
				local value = stored[key].value

				if (stored[key].isShared) then
					if (indexes[key]) then
						key = indexes[key]
					end

					netstream.Start(player, "Config", { [key] = value })
				end
			end
		else
			local cfg = {}

			for k, v in pairs(stored) do
				if (v.isShared) then
					local index = indexes[k]

					if (index) then
						cfg[index] = v.value
					else
						cfg[k] = v.value
					end
				end
			end

			netstream.Start(player, "Config", cfg)
		end
	end

	-- A function to load config from a file.
	function config.Load(fileName, loadGlobal)
		if (!fileName) then
			local configClasses = {"default", "map"}
			local configTable
			local map = string.lower(game.GetMap())

			if (loadGlobal) then
				config.global = {
					default = config.Load("config", true),
					map = config.Load("config/"..map, true)
				}

				configTable = config.global
			else
				config.schema = {
					default = config.Load("config"),
					map = config.Load("config/"..map)
				}

				configTable = config.schema
			end

			for k, v in pairs(configClasses) do
				for k2, v2 in pairs(configTable[v]) do
					local configObject = config.Get(k2)

					if (configObject:IsValid()) then
						if (configObject("default") == v2.default) then
							if (v == "map") then
								configObject:Set(v2.value, map, true)
							else
								configObject:Set(v2.value, nil, true)
							end
						end
					end
				end
			end
		elseif (loadGlobal) then
			return Clockwork.kernel:RestoreClockworkData(fileName)
		else
			return Clockwork.kernel:RestoreSchemaData(fileName)
		end
	end

	-- A function to add a new config key.
	function config.Add(key, value, isShared, isGlobal, isStatic, isPrivate, needsRestart)
		if (config.IsValidValue(value)) then
			if (!stored[key]) then
				stored[key] = {
					category = PLUGIN and PLUGIN:GetName(),
					needsRestart = needsRestart,
					isPrivate = isPrivate,
					isShared = isShared,
					isStatic = isStatic,
					isGlobal = isGlobal,
					default = value,
					value = value
				}

				local configClasses = {"global", "schema"}
				local configObject = CLASS_TABLE:Create(key)

				if (!isGlobal) then
					table.remove(configClasses, 1)
				end

				for k, v in pairs(configClasses) do
					local configTable = config[v]
					local map = string.lower(game.GetMap())

					if (configTable and configTable.default and configTable.default[key]) then
						if (configObject("default") == configTable.default[key].default) then
							configObject:Set(configTable.default[key].value, nil, true)
						end
					end

					if (configTable and configTable.map and configTable.map[key]) then
						if (configObject("default") == configTable.map[key].default) then
							configObject:Set(configTable.map[key].value, map, true)
						end
					end
				end

				config.Send(nil, key)

				return configObject
			end
		end
	end

	-- A function to set the config's value.
	function CLASS_TABLE:Set(value, map, forceSet, temporary)
		if (map) then
			map = string.lower(map)
		end

		if (tostring(value) == "-1.#IND") then
			value = 0
		end

		if (self.data and config.IsValidValue(value)) then
			if (self.data.value != value) then
				local previousValue = self.data.value
				local default = (value == "!default")

				if (!default) then
					if (isnumber(self.data.value)) then
						value = tonumber(value) or self.data.value
					elseif (isbool(self.data.value)) then
						value = (value == true or value == "true"
						or value == "yes" or value == "1" or value == 1)
					end
				else
					value = self.data.default
				end

				if (!self.data.isStatic or forceSet) then
					if (!map or string.lower(game.GetMap()) == map) then
						if ((!config.HasInitialized() and self.data.value == self.data.default)
						or !self.data.needsRestart or forceSet) then
							self.data.value = value

							if (self.data.isShared) then
								config.Send(nil, self.key)
							end
						end
					end

					if (config.HasInitialized()) then
						self.data.temporary = temporary
						self.data.forceSet = forceSet
						self.data.map = map

						if (self.data.needsRestart) then
							if (self.data.forceSet) then
								self.data.nextValue = nil
							else
								self.data.nextValue = value
							end
						end

						if (!self.data.map and !self.data.temporary) then
							config.Save("config", stored)
						end

						if (self.data.map) then
							if (default) then
								if (map[self.data.map]) then
									map[self.data.map][self.key] = nil
								end
							else
								if (!map[self.data.map]) then
									map[self.data.map] = {}
								end

								map[self.data.map][self.key] = {
									default = self.data.default,
									global = self.data.isGlobal,
									value = value
								}
							end

							if (!self.data.temporary) then
								config.Save("config/"..self.data.map, map[self.data.map])
							end
						end
					end
				end

				if (self.data.value != previousValue and config.HasInitialized()) then
					hook.Run("ClockworkConfigChanged", self.key, self.data, previousValue, self.data.value)
				end
			end

			return value
		end
	end

	netstream.Hook("ConfigInitialized", function(player, data)
		if (!player:HasConfigInitialized()) then
			player:SetConfigInitialized(true)
			hook.Run("PlayerConfigInitialized", player)
		end
	end)
else
	config.system = config.system or {}

	netstream.Hook("Config", function(data)
		for k, v in pairs(data) do
			if (indexes[k]) then
				k = indexes[k]
			end

			if (!stored[k]) then
				config.Add(k, v)
			else
				config.Get(k):Set(v)
			end
		end

		if (!config.HasInitialized()) then
			config.SetInitialized(true)

			for k, v in pairs(stored) do
				hook.Run("ClockworkConfigInitialized", k, v.value)
			end

			if (IsValid(Clockwork.Client) and !config.HasSentInitialized()) then
				netstream.Start("ConfigInitialized", true)
				config.SetSentInitialized(true)
			end
		end
	end)

	-- A function to get whether the config has sent initialized.
	function config.SetSentInitialized(sentInitialized)
		config.sentInitialized = sentInitialized
	end

	-- A function to get whether the config has sent initialized.
	function config.HasSentInitialized()
		return config.sentInitialized
	end

	-- A function to add a config key entry to the system.
	function config.AddToSystem(name, key, help, minimum, maximum, decimals, category)
		category = PLUGIN and PLUGIN:GetName()

		config.system[key] = {
			name = name or key,
			decimals = tonumber(decimals) or 0,
			maximum = tonumber(maximum) or 100,
			minimum = tonumber(minimum) or 0,
			help = help or "No information was provided for this entry.",
			category = category or "Clockwork"
		}
	end

	-- A function to get a config key's system entry.
	function config.GetFromSystem(key)
		return config.system[key]
	end

	-- A function to add a new config key.
	function config.Add(key, value)
		if (config.IsValidValue(value)) then
			if (!stored[key]) then
				stored[key] = {
					default = value,
					value = value
				}

				return CLASS_TABLE:Create(key)
			end
		end
	end

	-- A function to set the config's value.
	function CLASS_TABLE:Set(value)
		if (tostring(value) == "-1.#IND") then
			value = 0
		end

		if (self.data and config.IsValidValue(value)) then
			if (self.data.value != value) then
				local previousValue = self.data.value
				local default = (value == "!default")

				if (!default) then
					if (type(self.data.value) == "number") then
						value = tonumber(value) or self.data.value
					elseif (type(self.data.value) == "boolean") then
						value = (value == true or value == "true"
						or value == "yes" or value == "1" or value == 1)
					elseif (type(self.data.value) != type(value)) then
						return
					end

					self.data.value = value
				else
					self.data.value = self.data.default
				end

				if (self.data.value != previousValue and config.HasInitialized()) then
					hook.Run("ClockworkConfigChanged", self.key, self.data, previousValue, self.data.value)
				end
			end

			return self.data.value
		end
	end
end