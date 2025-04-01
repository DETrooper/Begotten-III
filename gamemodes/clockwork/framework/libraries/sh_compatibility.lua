--[[
	Backwards compatibility library for ease in porting plugins and schemas from Clockwork.
	Also features fixes for porting from older versions of gmod.
--]]

if (!plugin) then include("sh_plugin.lua") end
if (!config) then include("sh_config.lua") end
if (!item) then include("sh_item.lua") end

Clockwork.datastream = {};
Clockwork.item = {};
Clockwork.config = {};
Clockwork.plugin = {};

if (pon and pon.encode and pon.decode) then
	von = {};
	von.encode = pon.encode;
	von.decode = pon.decode;
end;

if (netstream) then
	do
		function Clockwork.datastream:Split(data)
			return netstream.Split(data)
		end;

		function Clockwork.datastream:Hook(name, Callback)
			return netstream.Hook(name, Callback)
		end;

		if (SERVER) then
			function Clockwork.datastream:Start(player, name, ...)
				return netstream.Start(player, name, ...)
			end;

			function Clockwork.datastream:Heavy(player, name, ...)
				return netstream.Heavy(player, name, ...)
			end;

			function Clockwork.datastream:Listen(name, Callback)
				return netstream.Listen(name, Callback)
			end;
		elseif (CLIENT) then
			function Clockwork.datastream:Start(name, ...)
				return netstream.Start(name, ...)
			end;

			function Clockwork.datastream:Heavy(name, ...)
				return netstream.Heavy(name, ...)
			end;

			function Clockwork.datastream:Request(name, data, Callback)
				return netstream.Request(name, data, Callback)
			end;
		end;
	end;
end;

do
	function Clockwork.item:IncludeItems(directory)
		return item.IncludeItems(directory)
	end;

	function Clockwork.item:GetStored()
		return item.GetStored()
	end;

	function Clockwork.item:GetBuffer()
		return item.GetBuffer()
	end;

	function Clockwork.item:GetWeapons()
		return item.GetWeapons()
	end;

	function Clockwork.item:GetInstances()
		return item.GetInstances()
	end;

	function Clockwork.item:HasSameDataAs(itemTable)
		return item.HasSameDataAs(itemTable)
	end;

	function Clockwork.item:GetAll()
		return item.GetAll()
	end;

	function Clockwork.item:New(baseItem, isBaseItem)
		return item.New(baseItem, isBaseItem)
	end;

	function Clockwork.item:Register(itemTable)
		return item.Register(itemTable)
	end;

	function Clockwork.item:CreateCopy(itemTable)
		return item.CreateCopy(itemTable)
	end;

	function Clockwork.item:IsWeapon(itemTable)
		return item.IsWeapon(itemTable)
	end;

	function Clockwork.item:GetByWeapon(weapon)
		return item.GetByWeapon(weapon)
	end;

	function Clockwork.item:CreateInstance(uniqueID, itemID, data, customData)
		return item.CreateInstance(uniqueID, itemID, data, customData)
	end;

	function Clockwork.item:GenerateID()
		return item.GenerateID()
	end;

	function Clockwork.item:FindInstance(itemID)
		return item.FindInstance(itemID)
	end;

	function Clockwork.item:GetDefinition(itemTable, bNetworkData)
		return item.GetDefinition(itemTable, bNetworkData)
	end;

	function Clockwork.item:GetSignature(itemTable)
		return item.GetSignature(itemTable)
	end;

	function Clockwork.item:FindByID(identifier, bShouldValidate)
		return item.FindByID(identifier, bShouldValidate)
	end;

	function Clockwork.item:Merge(itemTable, baseItem, bTemporary)
		return item.Merge(itemTable, baseItem, bTemporary)
	end;

	function Clockwork.item:Initialize()
		return item.Initialize()
	end;
	
	if (CLIENT) then
		function Clockwork.item:GetIconInfo(itemTable)
			return item.GetIconInfo(itemTable)
		end;
	elseif (SERVER) then
		function Clockwork.item:Use(player, itemTable, bNoSound)
			return item.Use(player, itemTable, bNoSound)
		end;
		
		function Clockwork.item:Drop(player, itemTable, position, bNoSound, bNoTake)
			return item.Drop(player, itemTable, position, bNoSound, bNoTake)
		end;
		
		function Clockwork.item:Destroy(player, itemTable, bNoSound)
			return item.Destroy(player, itemTable, bNoSound)
		end;
		
		function Clockwork.item:RemoveItemEntity(entity)
			return item.RemoveItemEntity(entity)
		end;
		
		function Clockwork.item:AddItemEntity(entity, itemTable)
			return item.AddItemEntity(entity, itemTable)
		end;
		
		function Clockwork.item:FindEntityByInstance(itemTable)
			return item.FindEntityByInstance(itemTable)
		end;
		
		function Clockwork.item:SendToPlayer(player, itemTable)
			return item.SendToPlayer(player, itemTable)
		end;
	end;
end;

do
	function Clockwork.config:SetInitialized(bInitalized)
		return config.SetInitialized(bInitalized)
	end;

	function Clockwork.config:HasInitialized()
		return config.HasInitialized()
	end;

	function Clockwork.config:IsValidValue(value)
		return config.IsValidValue(value)
	end;

	function Clockwork.config:ShareKey(key)
		return config.ShareKey(key)
	end;

	function Clockwork.config:GetStored()
		return config.GetStored()
	end;

	function Clockwork.config:Import(fileName)
		return config.Import(fileName)
	end;

	function Clockwork.config:LoadINI(fileName, bFromGame, bStripQuotes)
		return config.LoadINI(fileName, bFromGame, bStripQuotes)
	end;

	function Clockwork.config:Parse(text)
		return config.Parse(text)
	end;

	function Clockwork.config:Get(key)
		return config.Get(key)
	end;

	function Clockwork.config:GetVal(key, failSafe)
		return config.GetVal(key, failSafe)
	end;

	if (SERVER) then
		function Clockwork.config:Save(fileName, configTable)
			return config.Save(fileName, configTable)
		end;
		
		function Clockwork.config:Send(player, key)
			return config.Send(player, key)
		end;
		
		function Clockwork.config:Load(fileName, loadGlobal)
			return config.Load(fileName, loadGlobal)
		end;
		
		function Clockwork.config:Add(key, value, isShared, isGlobal, isStatic, isPrivate, needsRestart)
			return config.Add(key, value, isShared, isGlobal, isStatic, isPrivate, needsRestart)
		end;
	elseif (CLIENT) then
		function Clockwork.config:SetSentInitialized(sentInitialized)
			return config.SetSentInitialized(sentInitialized)
		end;
		
		function Clockwork.config:HasSentInitialized()
			return config.HasSentInitialized()
		end;
		
		function Clockwork.config:AddToSystem(name, key, help, minimum, maximum, decimals, category)
			return config.AddToSystem(name, key, help, minimum, maximum, decimals, category)
		end;
		
		function Clockwork.config:GetFromSystem(key)
			return config.GetFromSystem(key)
		end;
		
		function Clockwork.config:Add(key, value)
			return config.Add(key, value)
		end;
	end;
end;

do
	function Clockwork.plugin:GetStored()
		return plugin.GetStored()
	end;

	function Clockwork.plugin:GetModules()
		return plugin.GetModules()
	end;

	function Clockwork.plugin:GetUnloaded()
		return plugin.GetUnloaded()
	end;

	function Clockwork.plugin:GetExtras()
		return plugin.GetExtras()
	end;

	function Clockwork.plugin:GetCache()
		return plugin.GetCache()
	end;

	function Clockwork.plugin:DebugPrintCache()
		return plugin.DebugPrintCache()
	end;

	function Clockwork.plugin:ClearCache()
		return plugin.ClearCache()
	end;

	function Clockwork.plugin:SetInitialized(bInitialized)
		return plugin.SetInitialized(bInitialized)
	end;

	function Clockwork.plugin:HasInitialized()
		return plugin.HasInitialized()
	end;

	function Clockwork.plugin:Initialize()
		return plugin.Initialize()
	end;

	function Clockwork.plugin:Register(pluginTable)
		return plugin.Register(pluginTable)
	end;

	function Clockwork.plugin:FindByID(identifier)
		return plugin.FindByID(identifier)
	end;

	function Clockwork.plugin:Include(directory)
		return plugin.Include(directory)
	end;

	function Clockwork.plugin:New()
		return plugin.New()
	end;

	function Clockwork.plugin:CacheFunctions(obj, id)
		return plugin.CacheFunctions(obj, id)
	end;

	function Clockwork.plugin:RemoveFromCache(id)
		return plugin.RemoveFromCache(id)
	end;

	function Clockwork.plugin:Remove(name)
		return plugin.Remove(name)
	end;

	function Clockwork.plugin:Add(name, moduleTable, hookOrder)
		return plugin.Add(name, moduleTable, hookOrder)
	end;

	function Clockwork.plugin:IncludeEntities(folder)
		return plugin.IncludeEntities(folder)
	end;

	function Clockwork.plugin:IncludePlugins(directory)
		return plugin.IncludePlugins(directory)
	end;

	function Clockwork.plugin:AddExtra(folderName)
		return plugin.AddExtra(folderName)
	end;

	function Clockwork.plugin:IncludeExtras(directory)
		return plugin.IncludeExtras(directory)
	end;

	function Clockwork.plugin:Call(name, ...)
		return hook.Run(name, ...)
	end;

	if (CLIENT) then
		function Clockwork.plugin:SetUnloaded(name, isUnloaded)
			return plugin.SetUnloaded(name, isUnloaded)
		end;

		function Clockwork.plugin:IsDisabled(name, bFolder)
			return plugin.IsDisabled(name, bFolder)
		end;

		function Clockwork.plugin:IsUnloaded(name, bFolder)
			return plugin.IsUnloaded(name, bFolder)
		end;
	else
		function Clockwork.plugin:SetUnloaded(name, isUnloaded)
			return plugin.SetUnloaded(name, isUnloaded)
		end;

		function Clockwork.plugin:IsDisabled(name, bFolder)
			return plugin.IsDisabled(name, bFolder)
		end;

		function Clockwork.plugin:IsUnloaded(name, bFolder)
			return plugin.IsUnloaded(name, bFolder)
		end;
	end;
end;
local entityMeta = FindMetaTable("Entity");
local playerMeta = FindMetaTable("Player");

function entityMeta:GetAngle()
	return entityMeta:GetAngles();
end;

function entityMeta:SetAngle(angle)
	return entityMeta:SetAngles(angle)
end;

function playerMeta:GetCursorAimVector()
	return self:GetAimVector();
end;

function WorldSound(name, pos, level, pitch, volume)
	return sound.Play(name, pos, level, pitch, volume)
end;

function GetWorldEntity()
	return game.GetWorld();
end;

function isDedicatedServer()
	return game.IsDedicated();
end;

function SinglePlayer()
	return game.SinglePlayer();
end;

function MaxPlayers()
	return game.MaxPlayers();
end;

function ValidEntity(entity)
	return IsValid(entity);
end;

function math.Rad2Deg(radians)
	return math.deg(radians)
end;

function math.Deg2Rad(degrees)
	return math.rad(degrees)
end;

function timer.IsTimer(uniqueID)
	return timer.Exists(uniqueID);
end;

function KeyValuesToTable(tab)
	return util.KeyValuesToTable(tab);
end;

function TableToKeyValues(tab)
	return util.TableToKeyValues(tab);
end;

if (CLIENT) then
	function SetMaterialOverride(material)
		return render.MaterialOverride(material);
	end;
	
	function cam.StartMaterialOverride(material)
		return render.MaterialOverride(material);
	end;
end;