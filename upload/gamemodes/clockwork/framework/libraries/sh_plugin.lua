--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--[[ The plugin library is already defined! --]]
if (plugin) then return end

library.New("plugin", _G)

--[[
	We do local variables instead of global ones for performance increase.
	Most CW libraries use functions to return their tables anyways.
--]]
local stored = {}
local modules = {}
local unloaded = {}
local extras = {}
local hooksCache = {}

--[[
	@codebase Shared
	@details A function to get the local stored table that contains all registered plugins.
	@returns Table The local stored plugin table.
--]]
function plugin.GetStored()
	return stored
end

--[[
	@codebase Shared
	@details A function to get the local plugin module table that contains all registered plugin modules.
	@returns Table The local plugin module table.
--]]
function plugin.GetModules()
	return modules
end

--[[
	@codebase Shared
	@details A function to get the local unloaded table that contains all unloaded plugins.
	@returns Table The local stored unloaded plugin table.
--]]
function plugin.GetUnloaded()
	return unloaded
end

--[[
	@codebase Shared
	@details A function to get the extras that will be included in each plugin.
	@returns Table The local table of extras to be searched for in plugins.
--]]
function plugin.GetExtras()
	return extras
end

--[[
	@codebase Shared
	@details A function to get the local plugin hook cache.
	@returns Table The local plugin hook cache table.
--]]
function plugin.GetCache()
	return hooksCache
end

function plugin.DebugPrintCache()
	PrintTable(hooksCache)
end

PLUGIN_META = {__index = PLUGIN_META}
PLUGIN_META.description = "An undescribed plugin or schema."
PLUGIN_META.hookOrder = 0
PLUGIN_META.version = 1.0
PLUGIN_META.author = "Unknown"
PLUGIN_META.name = "Unknown"

PLUGIN_META.SetGlobalAlias = function(PLUGIN_META, aliasName)
	_G[aliasName] = PLUGIN_META
	PLUGIN_META.alias = aliasName
end	

PLUGIN_META.GetDescription = function(PLUGIN_META)
	return PLUGIN_META.description
end

PLUGIN_META.GetBaseDir = function(PLUGIN_META)
	return PLUGIN_META.baseDir
end

PLUGIN_META.GetHookOrder = function(PLUGIN_META)
	return PLUGIN_META.hookOrder
end

PLUGIN_META.GetVersion = function(PLUGIN_META)
	return PLUGIN_META.version
end

PLUGIN_META.GetAuthor = function(PLUGIN_META)
	return PLUGIN_META.author
end

PLUGIN_META.GetName = function(PLUGIN_META)
	return PLUGIN_META.name
end

PLUGIN_META.GetCRC = function(PLUGIN_META)
	return PLUGIN_META.__crc
end

PLUGIN_META.IsSingleFile = function(PLUGIN_META)
	return PLUGIN_META.__singlefile
end

PLUGIN_META.Register = function(PLUGIN_META)
	plugin.Register(PLUGIN_META)
end

PLUGIN_META.__tostring = function(PLUGIN_META)
	return "Plugin ["..PLUGIN_META.name.."]"
end

if (SERVER) then
	function plugin.SetUnloaded(name, isUnloaded)
		local pluginTable = plugin.FindByID(name)

		if (pluginTable and pluginTable != Schema) then
			if (isUnloaded) then
				unloaded[pluginTable.folderName] = true
			else
				unloaded[pluginTable.folderName] = nil
			end

			Clockwork.kernel:SaveSchemaData("plugins", unloaded)
			return true
		end

		return false
	end

	-- A function to get whether a plugin is disabled.
	function plugin.IsDisabled(name, bFolder)
		if (!bFolder) then
			local pluginTable = plugin.FindByID(name)

			if (pluginTable and pluginTable != Schema) then
				for k, v in pairs(unloaded) do
					local unloaded = plugin.FindByID(k)

					if (unloaded and unloaded != Schema
					and pluginTable.folderName != unloaded.folderName) then
						if (table.HasValue(unloaded.plugins, pluginTable.folderName)) then
							return true
						end
					end
				end
			end
		else
			for k, v in pairs(unloaded) do
				local unloaded = plugin.FindByID(k)

				if (unloaded and unloaded != Schema and name != unloaded.folderName) then
					if (table.HasValue(unloaded.plugins, name)) then
						return true
					end
				end
			end
		end

		return false
	end

	-- A function to get whether a plugin is unloaded.
	function plugin.IsUnloaded(name, bFolder)
		if (!bFolder) then
			local pluginTable = plugin.FindByID(name)

			if (pluginTable and pluginTable != Schema) then
				return (unloaded[pluginTable.folderName] == true)
			end
		else
			return (unloaded[name] == true)
		end

		return false
	end
else
	plugin.override = plugin.override or {}

	-- A function to set whether a plugin is unloaded.
	function plugin.SetUnloaded(name, isUnloaded)
		local pluginTable = plugin.FindByID(name)

		if (pluginTable) then
			plugin.override[pluginTable.folderName] = isUnloaded
		end
	end

	-- A function to get whether a plugin is disabled.
	function plugin.IsDisabled(name, bFolder)
		if (!bFolder) then
			local pluginTable = plugin.FindByID(name)

			if (pluginTable and pluginTable != Schema) then
				for k, v in pairs(unloaded) do
					local unloaded = plugin.FindByID(k)

					if (unloaded and unloaded != Schema
					and pluginTable.folderName != unloaded.folderName) then
						if (table.HasValue(unloaded.plugins, pluginTable.folderName)) then
							return true
						end
					end
				end
			end
		else
			for k, v in pairs(unloaded) do
				local unloaded = plugin.FindByID(k)

				if (unloaded and unloaded != Schema
				and name != unloaded.folderName) then
					if (table.HasValue(unloaded.plugins, name)) then
						return true
					end
				end
			end
		end

		return false
	end

	-- A function to get whether a plugin is unloaded.
	function plugin.IsUnloaded(name, bFolder)
		if (!bFolder) then
			local pluginTable = plugin.FindByID(name)

			if (pluginTable and pluginTable != Schema) then
				if (plugin.override[pluginTable.folderName] != nil) then
					return plugin.override[pluginTable.folderName]
				end

				return (unloaded[pluginTable.folderName] == true)
			end
		else
			if (plugin.override[name] != nil) then
				return plugin.override[name]
			end

			return (unloaded[name] == true)
		end

		return false
	end
end

function plugin.ClearCache()
	hooksCache = {}
end

-- A function to set if the plugin system is initialized.
function plugin.SetInitialized(bInitialized)
	plugin.cwInitialized = bInitialized
end

-- A function to get whether the config has initialized.
function plugin.HasInitialized()
	return plugin.cwInitialized
end

-- A function to initialize the plugin system.
function plugin.Initialize()
	if (plugin.HasInitialized()) then
		return
	end

	if (SERVER) then
		unloaded = Clockwork.kernel:RestoreSchemaData("plugins")
	end

	plugin.SetInitialized(true)
end

-- A function to register a new plugin.
function plugin.Register(pluginTable)
	local newBaseDir = Clockwork.kernel:RemoveTextFromEnd(pluginTable.baseDir, "/schema")
	local files, pluginFolders = _file.Find(newBaseDir.."/plugins/*", "LUA", "namedesc")
	local isUnloaded = plugin.IsUnloaded(pluginTable.folderName)

	if (!isUnloaded) then
		plugin.CacheFunctions(pluginTable)
	end

	stored[pluginTable.name] = pluginTable
	stored[pluginTable.name].plugins = {}

	if (!pluginTable:IsSingleFile()) then
		for k, v in ipairs(pluginFolders) do
			if (v != ".." and v != ".") then
				table.insert(stored[pluginTable.name].plugins, v)
			end
		end
	else
		if (SERVER) then
			local pathCRC = pluginTable:GetCRC() or "ERROR"

			CW_SCRIPT_SHARED.plugins[pathCRC] = CW_SCRIPT_SHARED.plugins[pathCRC] or {}
			CW_SCRIPT_SHARED.plugins[pathCRC].name = pluginTable.name
			CW_SCRIPT_SHARED.plugins[pathCRC].description = pluginTable.description
			CW_SCRIPT_SHARED.plugins[pathCRC].author = pluginTable.author
			CW_SCRIPT_SHARED.plugins[pathCRC].compatibility = pluginTable.compatibility
		end
	end

	if (!isUnloaded) then
		plugin.IncludeExtras(pluginTable:GetBaseDir())
		
		util.IncludeAllSubfolders(pluginTable:GetBaseDir().."/commands/");

		if (CLIENT and Schema != pluginTable) then
			pluginTable.helpID = Clockwork.directory:AddCode("Plugins", [[
				<div class="cwTitleSeperator">
					]]..string.upper(pluginTable:GetName())..[[
				</div>
				<div class="cwContentText">
					<div class="cwCodeText">
						developed by ]]..pluginTable:GetAuthor()..[[
					</div>
					]]..pluginTable:GetDescription()..[[
				</div>
			]], true, pluginTable:GetAuthor());
		end
	end

	if (!pluginTable:IsSingleFile()) then
		plugin.IncludePlugins(newBaseDir)
	end
end

-- A function to find a plugin by an ID.
function plugin.FindByID(identifier)
	return stored[identifier]
end

-- A function to include a plugin.
function plugin.Include(directory)
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local explodeDir = string.Explode("/", directory)
	local folderName = explodeDir[#explodeDir - 1]
	local pathCRC = util.CRC(directory)
	local isFilePlugin = directory:EndsWith(".lua")

	PLUGIN_BASE_DIR = directory
	PLUGIN_FOLDERNAME = folderName

	PLUGIN = plugin.New()

	if (SERVER) then
		if (!isFilePlugin) then
			local iniDir = "gamemodes/"..Clockwork.kernel:RemoveTextFromEnd(directory, "/plugin")
			local iniTable = config.LoadINI(iniDir.."/plugin.ini", true, true)

			if (iniTable) then
				if (iniTable["Plugin"]) then
					iniTable = iniTable["Plugin"]
					iniTable.isUnloaded = plugin.IsUnloaded(PLUGIN_FOLDERNAME, true)
						table.Merge(PLUGIN, iniTable)
					CW_SCRIPT_SHARED.plugins[pathCRC] = iniTable
				else
					--MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The "..PLUGIN_FOLDERNAME.." plugin has no plugin.ini!\n")
				end
			end
		else
			PLUGIN.__crc = pathCRC
			PLUGIN.__singlefile = true

			CW_SCRIPT_SHARED.plugins[pathCRC] = {
				isUnloaded = plugin.IsUnloaded(PLUGIN_FOLDERNAME, true)
			}
		end
	else
		local iniTable = CW_SCRIPT_SHARED.plugins[pathCRC]

		if (iniTable) then
			table.Merge(PLUGIN, iniTable)

			if (iniTable.isUnloaded) then
				unloaded[PLUGIN_FOLDERNAME] = true
			end
		else
			--MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Plugin] The "..PLUGIN_FOLDERNAME.." plugin has no plugin.ini!\n")
		end
	end

	if (stored[PLUGIN.name]) then
		PLUGIN = stored[PLUGIN.name] -- Restore plugin's data on refresh.
	end

	local isUnloaded = plugin.IsUnloaded(PLUGIN_FOLDERNAME, true)
	local isDisabled = plugin.IsDisabled(PLUGIN_FOLDERNAME, true)
	local shPluginDir = (!isFilePlugin and directory.."/sh_plugin.lua") or directory
	local addCSLua = true

	if (!isUnloaded and !isDisabled) then
		if (_file.Exists(shPluginDir, "LUA")) then
			util.Include(shPluginDir)
		end

		addCSLua = false
	end

	if (SERVER and addCSLua) then
		AddCSLuaFile(shPluginDir)
	end

	PLUGIN:Register()
	PLUGIN = nil
end

-- A function to create a new plugin.
function plugin.New()
	local pluginTable = Clockwork.kernel:NewMetaTable(PLUGIN_META)
	pluginTable.baseDir = PLUGIN_BASE_DIR
	pluginTable.folderName = PLUGIN_FOLDERNAME

	return pluginTable
end

-- A function to cache obj's functions.
function plugin.CacheFunctions(obj, id)
	for k, v in pairs(obj) do
		if (isfunction(v)) then
			hooksCache[k] = hooksCache[k] or {}
			table.insert(hooksCache[k], {v, obj, id = id})
		end
	end
end

-- A function to unhook a plugin from cache.
function plugin.RemoveFromCache(id)
	local pluginTable = (istable(id) and id) or plugin.FindByID(id)

	-- Awful lot of if's and end's.
	if (pluginTable) then
		for k, v in pairs(pluginTable) do
			if (isfunction(v) and hooksCache[k]) then
				for index, tab in ipairs(hooksCache[k]) do
					if (tab[2] == pluginTable) then
						table.remove(hooksCache[k], index)

						break
					end
				end
			end
		end
	end
end

-- A function to remove a module by name.
function plugin.Remove(name)
	plugin.RemoveFromCache(modules[name])

	modules[name] = nil
end

-- A function to add a table as a module.
function plugin.Add(name, moduleTable, hookOrder)
	if (!moduleTable.name) then
		moduleTable.name = name
	end

	moduleTable.hookOrder = hookOrder or 0

	modules[name] = moduleTable

	plugin.CacheFunctions(modules[name], name)
end

do
	local entData = {
		weapons = {
			table = "SWEP",
			func = weapons.Register,
			defaultData = {
				Primary = {},
				Secondary = {},
				Base = "weapon_base"
			}
		},
		entities = {
			table = "ENT",
			func = scripted_ents.Register,
			defaultData = {
				Type = "anim",
				Base = "base_gmodentity",
				Spawnable = true
			}
		},
		effects = {
			table = "EFFECT",
			func = effects and effects.Register,
			clientside = true
		}
	}

	function plugin.IncludeEntities(folder)
		folder = Clockwork.kernel:RemoveTextFromEnd(folder, "/")

		local _, dirs = file.Find(folder.."/*", "LUA")

		for k, v in ipairs(dirs) do
			if (!entData[v]) then continue end

			local dir = folder.."/"..v
			local data = entData[v]
			local files, folders = file.Find(dir.."/*", "LUA")

			for k, v in ipairs(folders) do
				local path = dir.."/"..v
				local uniqueID = (string.GetFileFromFilename(path) or ""):Replace(".lua", ""):MakeID()
				local register = false
				local var = data.table

				_G[var] = table.Copy(data.defaultData or {})
				_G[var].ClassName = uniqueID

				if (file.Exists(path.."/shared.lua", "LUA")) then
					util.Include(path.."/shared.lua")

					register = true
				end

				if (file.Exists(path.."/init.lua", "LUA")) then
					util.Include(path.."/init.lua")

					register = true
				end

				if (file.Exists(path.."/cl_init.lua", "LUA")) then
					util.Include(path.."/cl_init.lua")

					register = true
				end

				if (register) then
					if (data.clientside and !CLIENT) then _G[var] = nil continue end

					data.func(_G[var], uniqueID)
				end

				_G[var] = nil
			end

			for k, v in ipairs(files) do
				local path = dir.."/"..v
				local uniqueID = (string.GetFileFromFilename(path) or ""):Replace(".lua", ""):MakeID()
				local var = data.table

				_G[var] = table.Copy(data.defaultData)
				_G[var].ClassName = uniqueID

				util.Include(path)

				if (data.clientside and !CLIENT) then _G[var] = nil continue end

				data.func(_G[var], uniqueID)

				_G[var] = nil
			end
		end
	end
end

-- A function to include a plugin's plugins.
function plugin.IncludePlugins(directory)
	local files, pluginFolders = _file.Find(directory.."/plugins/*", "LUA", "namedesc")

	if (!plugin.HasInitialized()) then
		plugin.Initialize()
	end

	for k, v in ipairs(files) do
		if (v:EndsWith(".lua")) then
			plugin.Include(directory.."/plugins/"..v)
		end
	end

	for k, v in ipairs(pluginFolders) do
		plugin.Include(directory.."/plugins/"..v.."/plugin")
	end
end

-- A function to add an extra folder to include for plugins.
function plugin.AddExtra(folderName)
	table.insert(extras, folderName)
end

-- A function to include a plugin's extras.
function plugin.IncludeExtras(directory)
	local files, folders = _file.Find(directory.."/*", "LUA", "namedesc")

	if (table.HasValue(folders, "entities")) then
		plugin.IncludeEntities(directory.."/entities")
	end

	for k, v in ipairs(extras) do
		if (table.HasValue(folders, v)) then
			if (v == "items") then
				item.IncludeItems(directory.."/"..v.."/")
			else
				util.IncludeDirectory(directory.."/"..v.."/")
			end
		end
	end
end

plugin.AddExtra("libraries")
plugin.AddExtra("directory")
plugin.AddExtra("system")
plugin.AddExtra("factions")
plugin.AddExtra("classes")
plugin.AddExtra("attributes")
plugin.AddExtra("items")
plugin.AddExtra("derma")
plugin.AddExtra("commands")
plugin.AddExtra("traits")
plugin.AddExtra("language")
plugin.AddExtra("config")
plugin.AddExtra("tools")

--[[ This table will hold the plugin info, if it doesn't already exist. --]]
CW_SCRIPT_SHARED.plugins = CW_SCRIPT_SHARED.plugins or {}

do
	local oldHookCall = hook.ClockworkCall or hook.Call
	hook.ClockworkCall = oldHookCall

	if (Clockwork.DebugMode) then
		function hook.Call(name, gamemode, ...)
			if (hooksCache[name]) then
				for k, v in ipairs(hooksCache[name]) do
					if (v != nil) then
						local success, a, b, c, d, e, f = pcall(v[1], v[2], ...)

						if (!success) then
							MsgC(Color(255, 100, 0, 255), "\n[Clockwork:"..(v.id or v[2]:GetName()).."]\nThe '"..name.."' hook has failed to run.\n")
							MsgC(Color(255, 100, 0), tostring(a), "\n")

							hook.Run("OnHookError", name, bGamemode, a)
						elseif (a != nil) then
							return a, b, c, d, e, f
						end
					end
				end
			end

			return oldHookCall(name, gamemode, ...)
		end
	else
		function hook.Call(name, gamemode, ...)
			if (hooksCache[name]) then
				for k, v in ipairs(hooksCache[name]) do
					if (v != nil) then
						local a, b, c, d, e, f = v[1](v[2], ...)

						if (a != nil) then
							return a, b, c, d, e, f
						end
					end
				end
			end

			return oldHookCall(name, gamemode, ...)
		end
	end

	-- A function to call a function for all plugins.
	function plugin.Call(name, ...)
		return hook.Call(name, nil, ...)
	end
end