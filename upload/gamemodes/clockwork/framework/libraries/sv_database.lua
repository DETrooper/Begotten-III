--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.database = Clockwork.database or {}
Clockwork.database.connections = Clockwork.database.connections or {}

local QueueTable = {}
Clockwork.database.Module = Clockwork.database.Module or "sqlite"
local Connected = false

if (Clockwork.database.Module != "sqlite") then
	print("[Clockwork] Using "..Clockwork.database.Module.." as MySQL module...")

	require(Clockwork.database.Module)
end

local type = type
local tostring = tostring
local table = table

--[[
	Phrases
--]]

local MODULE_NOT_EXIST = "[Clockwork:Database] The %s module does not exist!\n"

--[[
	Begin Query Class.
--]]

local QUERY_CLASS = {}
QUERY_CLASS.__index = QUERY_CLASS

function QUERY_CLASS:New(tableName, queryType)
	local newObject = setmetatable({}, QUERY_CLASS)
		newObject.queryType = queryType
		newObject.tableName = tableName
		newObject.selectList = {}
		newObject.insertList = {}
		newObject.updateList = {}
		newObject.createList = {}
		newObject.whereList = {}
		newObject.orderByList = {}
	return newObject
end

function QUERY_CLASS:Escape(text)
	return Clockwork.database:Escape(tostring(text))
end

function QUERY_CLASS:ForTable(tableName)
	self.tableName = tableName
end

function QUERY_CLASS:Where(key, value)
	self:WhereEqual(key, value)
end

function QUERY_CLASS:WhereEqual(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` = \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereNotEqual(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` != \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereLike(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` LIKE \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereNotLike(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` NOT LIKE \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereGT(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` > \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereLT(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` < \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereGTE(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` >= \""..self:Escape(value).."\""
end

function QUERY_CLASS:WhereLTE(key, value)
	self.whereList[#self.whereList + 1] = "`"..key.."` <= \""..self:Escape(value).."\""
end

function QUERY_CLASS:OrderByDesc(key)
	self.orderByList[#self.orderByList + 1] = "`"..key.."` DESC"
end

function QUERY_CLASS:OrderByAsc(key)
	self.orderByList[#self.orderByList + 1] = "`"..key.."` ASC"
end

function QUERY_CLASS:Callback(queryCallback)
	self.callback = queryCallback
end

function QUERY_CLASS:Select(fieldName)
	self.selectList[#self.selectList + 1] = "`"..fieldName.."`"
end

function QUERY_CLASS:Insert(key, value)
	self.insertList[#self.insertList + 1] = {"`"..key.."`", "\""..self:Escape(value).."\""}
end

function QUERY_CLASS:Update(key, value)
	self.updateList[#self.updateList + 1] = {"`"..key.."`", "\""..self:Escape(value).."\""}
end

function QUERY_CLASS:Create(key, value)
	self.createList[#self.createList + 1] = {"`"..key.."`", value}
end

function QUERY_CLASS:PrimaryKey(key)
	self.primaryKey = "`"..key.."`"
end

function QUERY_CLASS:Limit(value)
	self.limit = value
end

function QUERY_CLASS:Offset(value)
	self.offset = value
end

local function BuildSelectQuery(queryObj)
	local queryString = {"SELECT"}

	if (!istable(queryObj.selectList) or #queryObj.selectList == 0) then
		queryString[#queryString + 1] = " *"
	else
		queryString[#queryString + 1] = " "..table.concat(queryObj.selectList, ", ")
	end

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " FROM `"..queryObj.tableName.."` "
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	if (istable(queryObj.whereList) and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE "
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ")
	end

	if (istable(queryObj.orderByList) and #queryObj.orderByList > 0) then
		queryString[#queryString + 1] = " ORDER BY "
		queryString[#queryString + 1] = table.concat(queryObj.orderByList, ", ")
	end

	if (isnumber(queryObj.limit)) then
		queryString[#queryString + 1] = " LIMIT "
		queryString[#queryString + 1] = queryObj.limit
	end

	return table.concat(queryString)
end

local function BuildInsertQuery(queryObj)
	local queryString = {"INSERT INTO"}
	local keyList = {}
	local valueList = {}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	for i = 1, #queryObj.insertList do
		keyList[#keyList + 1] = queryObj.insertList[i][1]
		valueList[#valueList + 1] = queryObj.insertList[i][2]
	end

	if (#keyList == 0) then
		return
	end

	queryString[#queryString + 1] = " ("..table.concat(keyList, ", ")..")"
	queryString[#queryString + 1] = " VALUES ("..table.concat(valueList, ", ")..")"

	return table.concat(queryString)
end

local function BuildUpdateQuery(queryObj)
	local queryString = {"UPDATE"}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	if (istable(queryObj.updateList) and #queryObj.updateList > 0) then
		local updateList = {}

		queryString[#queryString + 1] = " SET"

		for i = 1, #queryObj.updateList do
			updateList[#updateList + 1] = queryObj.updateList[i][1].." = "..queryObj.updateList[i][2]
		end

		queryString[#queryString + 1] = " "..table.concat(updateList, ", ")
	end

	if (istable(queryObj.whereList) and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE "
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ")
	end

	if (isnumber(queryObj.offset)) then
		queryString[#queryString + 1] = " OFFSET "
		queryString[#queryString + 1] = queryObj.offset
	end

	return table.concat(queryString)
end

local function BuildDeleteQuery(queryObj)
	local queryString = {"DELETE FROM"}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	if (istable(queryObj.whereList) and #queryObj.whereList > 0) then
		queryString[#queryString + 1] = " WHERE "
		queryString[#queryString + 1] = table.concat(queryObj.whereList, " AND ")
	end

	if (isnumber(queryObj.limit)) then
		queryString[#queryString + 1] = " LIMIT "
		queryString[#queryString + 1] = queryObj.limit
	end

	return table.concat(queryString)
end

local function BuildDropQuery(queryObj)
	local queryString = {"DROP TABLE"}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	return table.concat(queryString)
end

local function BuildTruncateQuery(queryObj)
	local queryString = {"TRUNCATE TABLE"}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	return table.concat(queryString)
end

local function BuildCreateQuery(queryObj)
	local queryString = {"CREATE TABLE IF NOT EXISTS"}

	if (isstring(queryObj.tableName)) then
		queryString[#queryString + 1] = " `"..queryObj.tableName.."`"
	else
		ErrorNoHalt("[Clockwork:Database] No table name specified!\n")
		return
	end

	queryString[#queryString + 1] = " ("

	if (istable(queryObj.createList) and #queryObj.createList > 0) then
		local createList = {}

		for i = 1, #queryObj.createList do
			if (Clockwork.database.Module == "sqlite") then
				createList[#createList + 1] = queryObj.createList[i][1].." "..string.gsub(string.gsub(string.gsub(queryObj.createList[i][2], "AUTO_INCREMENT", ""), "AUTOINCREMENT", ""), "INT ", "INTEGER ")
			else
				createList[#createList + 1] = queryObj.createList[i][1].." "..queryObj.createList[i][2]
			end
		end

		queryString[#queryString + 1] = " "..table.concat(createList, ", ")
	end

	if (isstring(queryObj.primaryKey)) then
		queryString[#queryString + 1] = ", PRIMARY KEY"
		queryString[#queryString + 1] = " ("..queryObj.primaryKey..")"
	end

	queryString[#queryString + 1] = " )"

	return table.concat(queryString)
end

function QUERY_CLASS:Execute(bQueueQuery)
	local queryString = nil
	local queryType = string.lower(self.queryType)

	if (queryType == "select") then
		queryString = BuildSelectQuery(self)
	elseif (queryType == "insert") then
		queryString = BuildInsertQuery(self)
	elseif (queryType == "update") then
		queryString = BuildUpdateQuery(self)
	elseif (queryType == "delete") then
		queryString = BuildDeleteQuery(self)
	elseif (queryType == "drop") then
		queryString = BuildDropQuery(self)
	elseif (queryType == "truncate") then
		queryString = BuildTruncateQuery(self)
	elseif (queryType == "create") then
		queryString = BuildCreateQuery(self)
	end

	if (isstring(queryString)) then
		if (!bQueueQuery) then
			return Clockwork.database:RawQuery(queryString, self.callback)
		else
			return Clockwork.database:Queue(queryString, self.callback)
		end
	end
end

--[[
	End Query Class.
--]]

function Clockwork.database:Select(tableName)
	return QUERY_CLASS:New(tableName, "SELECT")
end

function Clockwork.database:Insert(tableName)
	return QUERY_CLASS:New(tableName, "INSERT")
end

function Clockwork.database:Update(tableName)
	return QUERY_CLASS:New(tableName, "UPDATE")
end

function Clockwork.database:Delete(tableName)
	return QUERY_CLASS:New(tableName, "DELETE")
end

function Clockwork.database:Drop(tableName)
	return QUERY_CLASS:New(tableName, "DROP")
end

function Clockwork.database:Truncate(tableName)
	return QUERY_CLASS:New(tableName, "TRUNCATE")
end

function Clockwork.database:Create(tableName)
	return QUERY_CLASS:New(tableName, "CREATE")
end

function Clockwork.database:SetCurrentConnection(id)
	if (self.Module != "mysqloo") then
		id = "main"
	end

	if (self.connections[id]) then
		self.connection = self.connections[id]
		self.currentConnectionID = id
	else
		self.connection = self.connections["main"]
		self.currentConnectionID = "main"
	end
end

-- A function to connect to the MySQL database.
function Clockwork.database:Connect(host, username, password, database, port, socket, flags, id)
	if (!port) then
		port = 3306
	end

	if (!id) then
		id = self.currentConnectionID or "main"
	else
		print("[Clockwork:Database] Creating multi-connection with ID: "..id)
	end

	if (self.Module != "sqlite") then
		require(self.Module)

		if (self.Module == "tmysql4") then
			id = "main"
		end
	else
		self:OnConnected()

		return
	end

	if (self.Module == "tmysql4") then
		if (!istable(tmysql)) then
			require("tmysql4")
		end

		if (tmysql) then
			local errorText = nil

			self.connections[id], errorText = tmysql.initialize(host, username, password, database, port, socket, flags)

			if (!self.connections[id]) then
				self:OnConnectionFailed(errorText)
			else
				self:OnConnected()
			end
		else
			ErrorNoHalt(string.format(MODULE_NOT_EXIST, self.Module))
		end
	elseif (self.Module == "mysqloo") then
		if (!istable(mysqloo)) then
			require("mysqloo")
		end

		if (mysqloo) then
			local clientFlag = flags or 0

			if (!isstring(socket)) then
				self.connections[id] = mysqloo.connect(host, username, password, database, port)
			else
				self.connections[id] = mysqloo.connect(host, username, password, database, port, socket, clientFlag)
			end

			self.connections[id].onConnected = function(database)
				self:OnConnected()
			end

			self.connections[id].onConnectionFailed = function(database, errorText)
				self:OnConnectionFailed(errorText)
			end		

			self.connections[id]:connect()

			-- ping it every 30 seconds to make sure we're not losing connection
			timer.Create("Mysqloo#keep_alive", 30, 0, function()
				self.connections[id]:ping()
			end)
		else
			ErrorNoHalt(string.format(MODULE_NOT_EXIST, self.Module))
		end
	end

	self:SetCurrentConnection(id)
end

-- A function to query the MySQL database.
function Clockwork.database:RawQuery(query, callback, flags, ...)
	if (!self.connection and self.Module != "sqlite") then
		self:Queue(query)
	end

	if (self.Module == "tmysql4") then
		local queryFlag = flags or QUERY_FLAG_ASSOC

		self.connection:Query(query, function(result)
			local queryStatus = result[1]["status"]

			if (queryStatus) then
				if (isfunction(callback)) then
					local bStatus, value = pcall(callback, result[1]["data"], queryStatus, result[1]["lastid"])

					if (!bStatus) then
						ErrorNoHalt(string.format("[Clockwork:Database] MySQL Callback Error!\n%s\n", value))
					end
				end
			else
				ErrorNoHalt(string.format("[Clockwork:Database] MySQL Query Error!\nQuery: %s\n%s\n", query, result[1]["error"]))
			end
		end, queryFlag, ...)
	elseif (self.Module == "mysqloo") then
		local queryObj = self.connection:query(query)

		queryObj:setOption(mysqloo.OPTION_NAMED_FIELDS)

		queryObj.onSuccess = function(queryObj, result)
			if (callback) then
				-- FFFFFFFUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
				local bStatus, value = pcall(callback, result)//, queryObj:status(), queryObj:lastInsert())

				if (!bStatus) then
					ErrorNoHalt(string.format("[Clockwork:Database] MySQL Callback Error!\n%s\n", value))
				end
			end
		end

		queryObj.onError = function(queryObj, errorText)
			ErrorNoHalt(string.format("[Clockwork:Database] MySQL Query Error!\nQuery: %s\n%s\n", query, errorText))
		end

		queryObj:start()
	elseif (Clockwork.database.Module == "sqlite") then
		local result = sql.Query(query)

		if (result == false) then
			ErrorNoHalt(string.format("[Clockwork:Database] SQL Query Error!\nQuery: %s\n%s\n", query, sql.LastError()))
		else
			if (callback) then
				local bStatus, value = pcall(callback, result)

				if (!bStatus) then
					ErrorNoHalt(string.format("[Clockwork:Database] SQL Callback Error!\n%s\n", value))
				end
			end
		end
	else
		ErrorNoHalt(string.format("[Clockwork:Database] Unsupported module \"%s\"!\n", Clockwork.database.Module))
	end
end

-- A function to add a query to the queue.
function Clockwork.database:Queue(queryString, callback)
	if (isstring(queryString)) then
		QueueTable[#QueueTable + 1] = {queryString, callback}
	end
end

-- A function to escape a string for MySQL.
function Clockwork.database:Escape(text)
	if (self.connection) then
		if (Clockwork.database.Module == "tmysql4") then
			return self.connection:Escape(text)
		elseif (Clockwork.database.Module == "mysqloo") then
			return self.connection:escape(text)
		end
	else
		return sql.SQLStr(string.gsub(text, "\"", "'"), true)
	end
end

-- A function to disconnect from the MySQL database.
function Clockwork.database:Disconnect(id)
	if (self.connection) then
		if (self.Module == "tmysql4") then
			return self.connection:Disconnect()	
		end
	end

	Connected = false
end

function Clockwork.database:Think()
	if (#QueueTable > 0) then
		if (istable(QueueTable[1])) then
			local queueObj = QueueTable[1]
			local queryString = queueObj[1]
			local callback = queueObj[2]

			if (isstring(queryString)) then
				self:RawQuery(queryString, callback)
			end

			table.remove(QueueTable, 1)
		end
	end
end

-- A function to set the module that should be used.
function Clockwork.database:SetModule(moduleName)
	Clockwork.database.Module = moduleName
end

function Clockwork.database:IsResult(result)
	return (istable(result) and #result > 0)
end

-- Called when the database connects sucessfully.
function Clockwork.database:OnConnected()
	MsgC(Color(0, 0, 255), "[Clockwork]", Color(192, 192, 192), " Connected to the database using "..Clockwork.database.Module.."!\n")

	if (self.Module == "sqlite") then
		local queryObj = self:Create("bans")
			queryObj:Create("_Key", "INTEGER AUTOINCREMENT")
			queryObj:Create("_Identifier", "TEXT")
			queryObj:Create("_UnbanTime", "INTEGER")
			queryObj:Create("_SteamName", "TEXT")
			queryObj:Create("_Duration", "INTEGER")
			queryObj:Create("_Reason", "TEXT")
			queryObj:Create("_Schema", "TEXT")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()

		local queryObj = self:Create("players")
			queryObj:Create("_Key", "INTEGER AUTOINCREMENT")
			queryObj:Create("_Data", "TEXT")
			queryObj:Create("_Schema", "TEXT")
			queryObj:Create("_SteamID", "TEXT")
			queryObj:Create("_Donations", "TEXT")
			queryObj:Create("_UserGroup", "TEXT")
			queryObj:Create("_IPAddress", "TEXT")
			queryObj:Create("_LenderSteamID", "TEXT")
			queryObj:Create("_SteamName", "TEXT")
			queryObj:Create("_OnNextPlay", "TEXT")
			queryObj:Create("_LastPlayed", "INTEGER")
			queryObj:Create("_TimeJoined", "INTEGER")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()

		local queryObj = self:Create("characters")
			queryObj:Create("_Key", "INTEGER AUTOINCREMENT")
			queryObj:Create("_Data", "TEXT")
			queryObj:Create("_Name", "TEXT")
			queryObj:Create("_Ammo", "TEXT")
			queryObj:Create("_Cash", "INTEGER")
			queryObj:Create("_Model", "TEXT")
			queryObj:Create("_Skin", "INTEGER")
			queryObj:Create("_Flags", "TEXT")
			queryObj:Create("_Schema", "TEXT")
			queryObj:Create("_Gender", "TEXT")
			queryObj:Create("_Faction", "TEXT")
			queryObj:Create("_Subfaction", "TEXT")
			queryObj:Create("_Faith", "TEXT")
			queryObj:Create("_Subfaith", "TEXT")
			queryObj:Create("_SteamID", "TEXT")
			queryObj:Create("_SteamName", "TEXT")
			queryObj:Create("_Inventory", "TEXT")
			queryObj:Create("_OnNextLoad", "TEXT")
			queryObj:Create("_Attributes", "TEXT")
			queryObj:Create("_LastPlayed", "INTEGER")
			queryObj:Create("_TimeCreated", "INTEGER")
			queryObj:Create("_CharacterID", "INTEGER")
			queryObj:Create("_RecognisedNames", "TEXT")
			queryObj:Create("_Traits", "TEXT")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()
	else
		local queryObj = self:Create("bans")
			queryObj:Create("_Key", "int(11) NOT NULL AUTO_INCREMENT")
			queryObj:Create("_Identifier", "text NOT NULL")
			queryObj:Create("_UnbanTime", "int(11) NOT NULL")
			queryObj:Create("_SteamName", "varchar(150) NOT NULL")
			queryObj:Create("_Duration", "int(11) NOT NULL")
			queryObj:Create("_Reason", "text NOT NULL")
			queryObj:Create("_Schema", "text NOT NULL")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()

		local queryObj = self:Create("characters")
			queryObj:Create("_Key", "smallint(11) NOT NULL AUTO_INCREMENT")
			queryObj:Create("_Data", "text NOT NULL")
			queryObj:Create("_Name", "varchar(150) NOT NULL")
			queryObj:Create("_Ammo", "text NOT NULL")
			queryObj:Create("_Cash", "varchar(150) NOT NULL")
			queryObj:Create("_Model", "varchar(250) NOT NULL")
			queryObj:Create("_Skin", "varchar(50) NOT NULL")
			queryObj:Create("_Flags", "text NOT NULL")
			queryObj:Create("_Schema", "text NOT NULL")
			queryObj:Create("_Gender", "varchar(50) NOT NULL")
			queryObj:Create("_Faction", "varchar(50) NOT NULL")
			queryObj:Create("_Subfaction", "varchar(50) NOT NULL")
			queryObj:Create("_Faith", "varchar(50) NOT NULL")
			queryObj:Create("_Subfaith", "varchar(50) NOT NULL")
			queryObj:Create("_SteamID", "varchar(60) NOT NULL")
			queryObj:Create("_SteamName", "varchar(150) NOT NULL")
			queryObj:Create("_Inventory", "text NOT NULL")
			queryObj:Create("_OnNextLoad", "text NOT NULL")
			queryObj:Create("_Attributes", "text NOT NULL")
			queryObj:Create("_LastPlayed", "varchar(50) NOT NULL")
			queryObj:Create("_TimeCreated", "varchar(50) NOT NULL")
			queryObj:Create("_CharacterID", "varchar(50) NOT NULL")
			queryObj:Create("_RecognisedNames", "text NOT NULL")
			queryObj:Create("_Traits", "text NOT NULL")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()

		local queryObj = self:Create("players")
			queryObj:Create("_Key", "smallint(11) NOT NULL AUTO_INCREMENT")
			queryObj:Create("_Data", "text NOT NULL")
			queryObj:Create("_Schema", "text NOT NULL")
			queryObj:Create("_SteamID", "varchar(60) NOT NULL")
			queryObj:Create("_Donations", "text NOT NULL")
			queryObj:Create("_UserGroup", "text NOT NULL")
			queryObj:Create("_IPAddress", "varchar(50) NOT NULL")
			queryObj:Create("_LenderSteamID", "text NOT NULL")
			queryObj:Create("_SteamName", "varchar(150) NOT NULL")
			queryObj:Create("_OnNextPlay", "text NOT NULL")
			queryObj:Create("_LastPlayed", "varchar(50) NOT NULL")
			queryObj:Create("_TimeJoined", "varchar(50) NOT NULL")
			queryObj:PrimaryKey("_Key")
		queryObj:Execute()
	end

	Connected = true
	hook.Run("DatabaseConnected")
end

-- Called when the database connection fails.
function Clockwork.database:OnConnectionFailed(errorText)
	ErrorNoHalt("[Clockwork:Database] Unable to connect to the database!\n"..errorText.."\n")

	hook.Run("DatabaseConnectionFailed", errorText)
end

-- A function to check whether or not the module is connected to a database.
function Clockwork.database:IsConnected()
	return Connected
end

function Clockwork.database:EasyWrite(tableName, where, data)
	if (!data or !istable(data)) then
		ErrorNoHalt("[Clockwork] Easy MySQL error! Data has unexpected value type (table expected, got "..type(data)..")\n")

		return
	end

	if (!where) then
		ErrorNoHalt("[Clockwork] Easy MySQL error! 'where' table is malformed! ([1] = "..type(where[1])..", [2] = "..type(where[2])..")\n")

		return
	end

	local query = self:Select(tableName)
		if (istable(where[1])) then
			for k, v in pairs(where) do
				query:Where(v[1], v[2])
			end
		else
			query:Where(where[1], where[2])
		end

		query:Callback(function(result, status, lastID)
			if (istable(result) and #result > 0) then
				local updateObj = self:Update(tableName)

					for k, v in pairs(data) do
						updateObj:Update(k, v)
					end

					updateObj:Where(where[1], where[2])
					updateObj:Callback(function()
						fl.core:DevPrint("Easy MySQL updated data. ('"..tableName.."' WHERE "..where[1].." = "..where[2]..")")
					end)

				updateObj:Execute()
			else
				local insertObj = self:Insert(tableName)

					for k, v in pairs(data) do
						insertObj:Insert(k, v)
					end

					insertObj:Callback(function(result)
						if (!istable(where[1])) then
							fl.core:DevPrint("Easy MySQL inserted data into '"..tableName.."' WHERE "..where[1].." = "..where[2]..".")
						else
							local msg = "Easy MySQL inserted data into '"..tableName.."' WHERE "
							local i = 0

							for k, v in pairs(where) do
								i = i + 1
								msg = msg..v[1].." = "..v[2]

								if (table.Count(where) != i) then
									msg = msg.." AND "
								end
							end

							fl.core:DevPrint(msg)
						end
					end)

				insertObj:Execute()
			end
		end)

	query:Execute()
end

function Clockwork.database:EasyRead(tableName, where, callback)
	if (!where) then
		ErrorNoHalt("[Clockwork] Easy MySQL Read error! 'where' table is malformed! ([1] = "..type(where[1])..", [2] = "..type(where[2])..")\n")
		return false
	end

	local query = self:Select(tableName)
		if (istable(where[1])) then
			for k, v in pairs(where) do
				query:Where(v[1], v[2])
			end
		else
			query:Where(where[1], where[2])
		end

		query:Callback(function(result)
			fl.core:DevPrint("Easy MySQL has successfully read the data!")

			local success, value = pcall(callback, result, (istable(result) and #result > 0))

			if (!success) then
				ErrorNoHalt("[Clockwork:EasyRead Error] "..value.."\n")
			end
		end)

	query:Execute()
end

timer.Create("Clockwork.Database.Think", 1, 0, function()
	Clockwork.database:Think()
end)
