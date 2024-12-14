--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local setmetatable = setmetatable;
local tonumber = tonumber;
local IsValid = IsValid;
local pairs = pairs;
local type = type;
local string = string;
local util = util;
local os = os;

library.New("item", _G)

item.stored = item.stored or {}

local buffer = item.buffer or {}
item.buffer = buffer

local weapons = item.weapons or {}
item.weapons = weapons

local instances = item.instances or {}
item.instances = instances

function item.GetStored()
	return item.stored
end

function item.GetBuffer()
	return buffer
end

function item.GetWeapons()
	return weapons
end

function item.GetInstances()
	return instances
end

--[[
	Begin defining the item class base for other item's to inherit from.
--]]

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE};

CLASS_TABLE.name = "Item Base";
CLASS_TABLE.skin = 0;
CLASS_TABLE.bodygroup0 = 0;
CLASS_TABLE.bodygroup1 = 0;
CLASS_TABLE.bodygroup2 = 0;
CLASS_TABLE.bodygroup3 = 0;
CLASS_TABLE.cost = 0;
CLASS_TABLE.batch = 5;
CLASS_TABLE.model = "models/error.mdl";
CLASS_TABLE.weight = 1;
CLASS_TABLE.space = 1;
CLASS_TABLE.itemID = 0;
CLASS_TABLE.business = false;
CLASS_TABLE.category = "Other";
CLASS_TABLE.description = "An item with no description.";
CLASS_TABLE.defaultValue = 10;

CLASS_TABLE.itemWeaponClass = "a_defaultweapon";
CLASS_TABLE.soundMaterial = "Wood";
CLASS_TABLE.equippable = true;
CLASS_TABLE.attackTable = {};
CLASS_TABLE.blockTable = {};
CLASS_TABLE.bDisplayWeight = true;

--[[
	Called when the item is invoked as a function.
	Whenever getting a value from an itemTable you
	should always do itemTable("varName") instead of
	itemTable.varName so that the query system is used.
	
	Note: it would be advised not to use itemTable("varName")
	during a query proxy or a stack overflow may be caused.
--]]
function CLASS_TABLE:__call(varName, failSafe)
	if (self.queryProxies[varName]) then
		local bNotDefault = self.queryProxies[varName].bNotDefault;
		local dataName = self.queryProxies[varName].dataName;
		
		if (type(dataName) != "function") then
			local defaultValue = self.defaultData[dataName];
			local currentValue = self.data[dataName];
			
			if (defaultValue != nil and currentValue != nil
			and (defaultValue != currentValue or !bNotDefault)) then
				return self.data[dataName];
			end;
		else
			local returnValue = dataName(self);
			if (returnValue != nil) then
				return returnValue;
			end;
		end;
	end;
	
	--[[
		Check data first. We may be overriding this value
		or simply want to return it instead.
	--]]
	if (self.data[varName] != nil) then
		return self.data[varName];
	end;
	
	return (self[varName] != nil and self[varName] or failSafe);
end;

function CLASS_TABLE:IsFakeWeapon()
	return self.isFakeWeapon or false;
end;

function CLASS_TABLE:GetName()
	local engraving = self:GetData("engraving");
	
	if engraving and engraving ~= "" then
		return engraving.." ("..self.name..")";
	elseif self.name then
		return self.name;
	else
		return "Invalid Item Name";
	end
end;

function CLASS_TABLE:GetVar(var, replacement)
	return self(var, replacement);
end;

-- Called when the item is converted to a string.
function CLASS_TABLE:__tostring()
	return "ITEM["..self("itemID").."]";
end;

--[[
	A function to override an item's base data. This is
	just a nicer way to set a value to go along with
	the method of querying.
--]]
function CLASS_TABLE:Override(varName, value)
	self[varName] = value;
end;

-- A function to add data to an item.
function CLASS_TABLE:AddData(dataName, value, bNetworked)
	self.data[dataName] = value;
	self.defaultData[dataName] = value;
	self.networkData[dataName] = bNetworked;
end;

-- A function to remove data from an item.
function CLASS_TABLE:RemoveData(dataName)
	self.data[dataName] = nil;
	self.defaultData[dataName] = nil;
	self.networkData[dataName] = nil;
end;

-- A function to get whether an item has the same data as another.
function item.HasSameDataAs(itemTable)
    --return Clockwork.kernel:AreTablesEqual(item.data, itemTable.data);
end;

-- A function to get whether the item is an instance.
function CLASS_TABLE:IsInstance()
	return (self("itemID") != 0);
end;

--[[
	A function to add a query proxy. This allows us
	to replace any queries for a variable name with
	the data variable value of our choice.
	
	Note: if a function is supplied for the dataName
	then the value that the function returns will be
	used.
	
	bNotDefault does not apply when using callbacks,
	but otherwise will only replace the query if the
	data variable is different from its default value.
--]]
function CLASS_TABLE:AddQueryProxy(varName, dataName, bNotDefault)
	self.queryProxies[varName] = {
		dataName = dataName,
		bNotDefault = bNotDefault
	};
end;

-- A function to remove a query proxy.
function CLASS_TABLE:RemoveQueryProxy(varName)
	self.queryProxies[varName] = nil;
end;

-- A function to get whether the item is based from another.
function CLASS_TABLE:IsBasedFrom(uniqueID)
	local itemTable = self;
	
	if (itemTable("unique") == uniqueID) then
		return true;
	end;

	while (itemTable and itemTable("baseItem")) do
		if (itemTable("baseItem") == uniqueID) then
			return true;
		end;
		
		itemTable = item.FindByID(
			itemTable("baseItem")
		);
	end;
	
	return false;
end;

-- A function to get a base class table from the item.
function CLASS_TABLE:GetBaseClass(uniqueID)
	return item.FindByID(uniqueID);
end;

-- A function to get whether the item can be ordered.
function CLASS_TABLE:CanBeOrdered()
	return (!self("isBaseItem") and self("business"));
end;

-- A function to get data from the item.
function CLASS_TABLE:GetData(dataName)
	-- Ghetto code to fix copies of itemTables having desynced item data with the actual instance.
	if self:IsInstance() then
		local instance = item.FindInstance(self.itemID);
		
		if instance then
			return instance.data[dataName];
		end
	end
	
	return self.data[dataName];
end;

-- A function to get whether two items are the same.
function CLASS_TABLE:IsTheSameAs(itemTable)
	if (itemTable) then
		return (itemTable("uniqueID") == self("uniqueID")
		and itemTable("itemID") == self("itemID"));
	else
		return false;
	end;
end;

-- A function to get whether data is networked.
function CLASS_TABLE:IsDataNetworked(key)
	return (self.networkData[key] == true);
end;

-- A function to get the item's current condition value.
function CLASS_TABLE:GetCondition()
	return self:GetData("condition")
end;

-- A function to get the item's current condition value.
function CLASS_TABLE:IsBroken()
	return (self:GetData("condition") <= 0);
end;

-- A function to get the item's current value.
function CLASS_TABLE:GetValue()
	if (self:GetData("value")) then
		return self:GetData("value");
	elseif (self.value) then
		return self.value;
	end;
	
	return self.defaultValue;
end;

if (SERVER) then
	-- A function to update an item's value.
	function CLASS_TABLE:UpdateValue(value)
		local value = value or (self:GetValue() or self.defaultValue);
		
		if (!self:GetData("lowestValue") and value) then
			self:SetData("lowestValue", math.Clamp(value * 0.2, 0, value));
		end;
		
		local floor = self.lowestValue or self:GetData("lowestValue");
		local condition = self:GetCondition() or 100;
		local newValue = value * (condition / 100);
		
		if (self.OnValueChanged) then
			local callbackValue = self:OnValueChanged(value, newValue, condition, floor);
			
			if (isnumber(callbackValue)) then
				newValue = callbackValue;
			end;
		end;
		
		self:SetData("value", value);
	end;
	
	-- A function to override the item's value.
	function CLASS_TABLE:SetValue(value)
		self:UpdateValue(value);
	end;
	
	-- Called when the value of the item changes.
	function CLASS_TABLE:OnValueChanged(oldValue, newValue, condition, floor) end;
end;

-- A function to get the item's weapon class.
function CLASS_TABLE:GetWeaponClass()
	local weaponClass = self.itemWeaponClass;
	
	if (self.baseItem == "weapon_base" or self.baseItem == "firearm_base") then
		return self.uniqueID;
	end;
	
	return self.itemWeaponClass;
end;

-- Called when a player has unequipped the item.
function CLASS_TABLE:OnTakeFromPlayer(player)
	if (self.baseItem == "weapon_base" or self.baseItem == "firearm_base") then
		local slots = {"Primary", "Secondary", "Tertiary"};
		local weaponID = self.uniqueID;
		local weapon = player:GetWeapon(weaponID);
		
		if IsValid(weapon) then
			for k, v in pairs(player.equipmentSlots) do
				if v and v.category == "Shields" then
					-- Old code for 1 weapon per shield.
					--[[if weapon:GetNW2String("activeShield") == v.uniqueID then
						local weaponItemTable = item.GetByWeapon(weapon);
						
						if weaponItemTable and weaponItemTable:IsTheSameAs(self) then
							Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
						end
						
						break;
					end]]--
					
					-- New code.
					local other_melee_found = false;
					
					for k2, v2 in pairs(player.equipmentSlots) do
						if v2.canUseShields and !v2:IsTheSameAs(v) then
							other_melee_found = true;
							
							break;
						end
					end
					
					if !other_melee_found then
						Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
					end
					
					break;
				end
			end
		end
	end
end

-- Called to get whether a player has the item equipped.
function CLASS_TABLE:HasPlayerEquipped(player, bIsValidWeapon, bMelee)
	if !self.slots then return false end;
	
	return Clockwork.equipment:GetItemEquipped(player, self);
end

-- Called when the player unequips the item weapon.
function CLASS_TABLE:OnPlayerUnequipped(player, extraData)
	Clockwork.equipment:UnequipItem(player, self);
end;

-- A function to handle unequipping.
function CLASS_TABLE:OnHandleUnequip(Callback)
	if (self.equippable) then
		local menu = DermaMenu()
			menu:SetMinimumWidth(100)
			
			local slot;
			local unequipMenu;
			
			for k, v in pairs(Clockwork.Client.equipmentSlots) do
				if v:IsTheSameAs(self) and (string.find(k, "Offhand") or Clockwork.Client.equipmentSlots[k.."Offhand"]) then
					slot = string.gsub(k, "Offhand", "");
					
					local mainSlot = Clockwork.Client.equipmentSlots[slot];
					local offhandSlot = Clockwork.Client.equipmentSlots[slot.."Offhand"];
					
					unequipMenu = menu:AddSubMenu("Unequip", function()
						if offhandSlot then
							netstream.Start("UnequipItem", {offhandSlot("uniqueID"), offhandSlot("itemID")});
						end
					
						if mainSlot then
							netstream.Start("UnequipItem", {mainSlot("uniqueID"), mainSlot("itemID")});
						end
					end)
					
					--[[if mainSlot then
						unequipMenu:AddOption(mainSlot.name, function()
							if mainSlot then
								netstream.Start("UnequipItem", {mainSlot("uniqueID"), mainSlot("itemID")});
							end
						end)
					end]]--
					
					if offhandSlot then
						unequipMenu:AddOption(offhandSlot.name.." (Offhand)", function()
							if offhandSlot then
								netstream.Start("UnequipItem", {offhandSlot("uniqueID"), offhandSlot("itemID")});
							end
						end)
					end
					
					break;
				end
			end
			
			if !unequipMenu then
				unequipMenu = menu:AddOption("Unequip", function()
					Callback("holster")
				end)
			end

			if self.category == "Firearms" or self.category == "Crossbows" then
				local ammo = self:GetData("Ammo");
				
				if ammo and #ammo > 0 then
					local unloadText = "Unload Shot";
									
					if self.ammoCapacity == 1 or (#ammo == 1 and !string.find(ammo[1], "Magazine")) then
						if self.usesMagazine then
							unloadText = "Unload Chamber";
						end
					elseif self.isRevolver then
						unloadText = "Unload All Shot";
					elseif self.usesMagazine then
						unloadText = "Unload Magazine";
					end
					
					menu:AddOption(unloadText, function()
						Callback("unload")
					end)
				end
			end
			
			menu:AddOption("Drop", function()
				Callback("drop")
			end)
		menu:Open()
		
		function menu:Think()
			self:MoveToFront()
		end;
	end;
end;

-- A function to get whether the player can equip the item or not.
function CLASS_TABLE:CanEquip(player)
	if self:IsBroken() then
		Schema:EasyText(player, "peru", "This item is broken and cannot be equipped!");
		return false;
	end
	
	return true;
end;

if (SERVER) then
	-- A function to get the player with the item in their inventory.
	function CLASS_TABLE:GetHolder()
		local holder = nil;
		
		for _, player in _player.Iterator() do
			if (IsValid(player) and player:HasInitialized()) then
				local inventory = player:GetInventory();
				
				if (Clockwork.inventory:HasItemInstance(inventory, self)) then
					holder = player;
					break;
				end;
			end;
		end;

		if (holder and IsValid(holder)) then
			return holder;
		end;
		
		return false;
	end;

	-- A function to equip the item as a melee weapon.
	function CLASS_TABLE:Equip(player)
		if (self:CanEquip(player)) then
			player:Give(self.itemWeaponClass, self);
			local weapon = player:GetWeapon(self.itemWeaponClass);
			
			if (self.attackTable) then
				weapon:UpdateAttackTable(self.attackTable);
			end;

			if (self.blockTable) then
				weapon:UpdateBlockTable(self.blockTable);
			end;
		end;
	end;
	
	-- A function to set an item's condition.
	function CLASS_TABLE:SetCondition(condition, force)
		local scale = self.conditionGainScale;
			if (condition <= 0) then
				scale = self.conditionDrainScale;
			end;
		local condition = math.Clamp(condition, 0, 100);
			if (!force and scale) then
				condition = condition * math.Clamp(scale, 0.01, 1);
			end;
		self:SetData("condition", math.Clamp(condition, 0, 100));
		
		local condition = self:GetData("condition");
		
		if (condition <= 0 and self.breakable) then
			self:Break()
		end;
		
		self:UpdateValue()
	end;
	
	-- A function to take from an item's condition.
	function CLASS_TABLE:TakeCondition(amount, force)
		local scale = self.conditionDrainScale;
		local condition = self:GetCondition();
			if (!force and amount and scale) then
				amount = amount * math.Clamp(scale, 0, 1);
			end;
		self:SetData("condition", math.Clamp(condition + -math.abs(amount), 0, 100));
		
		local condition = self:GetData("condition");
		
		if (condition <= 0 and self.breakable) then
			self:Break()
		end;
		
		self:UpdateValue()
	end;
	
	-- A function to add to an item's condition.
	function CLASS_TABLE:GiveCondition(amount, force)
		local scale = self.conditionGainScale;
		local condition = self:GetCondition();
			if (!force and amount and scale) then
				amount = amount * math.Clamp(scale, 0, 1);
			end;
		self:SetData("condition", math.Clamp(condition + math.abs(amount), 0, 100));
		
		local condition = self:GetData("condition");
		
		if (condition <= 0 and self.breakable) then
			self:Break()
		end;
		
		self:UpdateValue()
	end;
	
	-- A function to break the item.
	function CLASS_TABLE:Break(take)
		local itemEntity = item.FindEntityByInstance(self);
		
		if (take) then
			if (!IsValid(itemEntity)) then
				local holder = nil;
				
				for _, player in _player.Iterator() do
					if (IsValid(player) and player:HasInitialized()) then
						local inventory = player:GetInventory();
						
						if (Clockwork.inventory:HasItemInstance(inventory, self)) then
							holder = player;
							break;
						end;
					end;
				end;
				
				if (IsValid(holder)) then
					if (self.brokenItems and !table.IsEmpty(self.brokenItems)) then
						for k, v in pairs (self.brokenItems) do
							holder:UpdateInventory(k, v);
						end;
					end;
					
					if (self.breakMessage) then
						--holder:Notify(self.breakMessage);
						Clockwork.chatBox:AddInTargetRadius(holder, "me", "'s "..self.name..self.breakMessage, holder:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					end;
					
					holder:TakeItem(self, true);
				end;
			else
				itemEntity:Explode()
				itemEntity:Remove();
			end;
		else
			if (!IsValid(itemEntity)) then
				local holder = nil;
				
				for _, player in _player.Iterator() do
					if (IsValid(player) and player:HasInitialized()) then
						local inventory = player:GetInventory();
						
						if (Clockwork.inventory:HasItemInstance(inventory, self)) then
							holder = player;
							break;
						end;
					end;
				end;
				
				if (IsValid(holder)) then
					if (self.breakMessage) then
						--holder:Notify(self.breakMessage);
						Clockwork.chatBox:AddInTargetRadius(holder, "me", "'s "..self.name..self.breakMessage, holder:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					end;
						
					Clockwork.kernel:ForceUnequipItem(holder, self.uniqueID, self.itemID)
				end
			end
		end;
	end;
	
	-- Called to get whether a player can repair an item or not.
	function CLASS_TABLE:CanRepair(player, itemTable, amount, degradation)
		if (self.unrepairable) then
			return false;
		end;
		
		if (hook.Run("PlayerCanRepairItem", player, self, itemTable, amount, degradation) == true) then
			return false;
		end;
		
		return true;
	end;
	
	-- A function to repair an item with another item.
	function CLASS_TABLE:Repair(itemTable, amount, degradation)
		if (!itemTable or !itemTable:istable()) then
			return;
		end;
		
		local amount = math.Clamp(amount, 0, 100) or 5;
		local degradation = math.Clamp(degradation, 0, 100) or 5;
		local holder = self:GetHolder() and IsValid(holder) and holder:IsPlayer();
		
		if (holder and !holder:HasItemInstance(itemTable)) then
			return;
		end;

		if (self:CanRepair(holder, itemTable, amount, degradation)) then
			itemTable:TakeCondition(degradation, true);
			self:GiveCondition(amount, true);
			hook.Run("PlayerRepairedItem", player, self, itemTable, amount);
			
			if (self.OnRepaired) then
				self.OnRepaired(player, itemTable, amount, degradation);
			end;
		elseif (holder) then
			Schema:EasyText(holder, "peru", "You cannot repair this item!");
		end;
	end;
	
	-- Called every second that the item's entity is valid.
	--[[function CLASS_TABLE:OnEntityThink(entity)
		if (self.decayRate and self.decayAmount) then
			local curTime = CurTime();
			
			if (!self.nextDecay or self.nextDecay < curTime) then
				self.nextDecay = curTime + self.decayRate;
				self:TakeCondition(self.decayAmount, nil, nil);
			end;
		end;
	end;]]--

	-- A function to deduct necessary funds from a player after ordering.
	function CLASS_TABLE:DeductFunds(player)
		if (#self.recipes > 0) then
			for k, v in pairs(self.recipes) do
				if (Clockwork.kernel:HasObjectAccess(player, v)) then
					local hasIngredients = true;
					
					for k2, v2 in pairs(v.ingredients) do
						if (table.Count(player:GetItemsByID(k2)) < v2) then
							hasIngredients = false;
						end;
					end;
					
					if (hasIngredients) then
						for k2, v2 in pairs(v.ingredients) do
							for i = 1, v2 do
								player:TakeItemByID(k2);
							end;
						end;
						
						break;
					end;
				end;
			end;
		end;
		
		if (self("cost") == 0) then
			return;
		end;
		
		if (self("batch") > 1) then
			Clockwork.player:GiveCash(player, -(self("cost") * self("batch")), self("batch").." "..Clockwork.kernel:Pluralize(self("name")));
			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..self("batch").." "..Clockwork.kernel:Pluralize(self("name"))..".");
		else
			Clockwork.player:GiveCash(player, -(self("cost") * self("batch")), self("batch").." "..self("name"));
			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..self("batch").." "..self("name")..".");
		end;
	end;
	
	-- A function to get whether a player can afford to order the item.
	function CLASS_TABLE:CanPlayerAfford(player)
		if (!Clockwork.player:CanAfford(player, self("cost") * self("batch"))) then
			return false;
		end;

		return true;
	end;
end;

-- A function to register a new item.
function CLASS_TABLE:Register()
	return item.Register(self);
end;

if (SERVER) then
	function CLASS_TABLE:SetData(dataName, value)
		local itemTable = self;
	
		-- Ghetto code to fix copies of itemTables having desynced item data with the actual instance.
		if self:IsInstance() then
			local instance = item.FindInstance(self.itemID);
			
			if instance then
				itemTable = instance;
			end
		end
		
		if (itemTable:IsInstance() and itemTable.data[dataName] != nil and (itemTable.data[dataName] != value or istable(itemTable.data[dataName]) or dataName == "Ammo")) then
			itemTable.data[dataName] = value;
			
			if itemTable ~= self then
				self.data[dataName] = value;
			end
			
			if (itemTable:IsDataNetworked(dataName)) then
				itemTable.networkQueue[dataName] = value;
				itemTable:NetworkData();
			end;
		end;
	end;

	-- A function to network the item data.
	function CLASS_TABLE:NetworkData()
		local timerName = "NetworkItem"..self("itemID");

		if (timer.Exists(timerName)) then
			return;
		end;

		timer.Create(timerName, FrameTime(), 1, function()
			item.SendUpdate(self, self.networkQueue);
			self.networkQueue = {};
		end);
	end;
else
	function CLASS_TABLE:SubmitOption(option, data, entity)
		netstream.Start("MenuOption", {option = option, data = data, item = self("itemID"), entity = entity});
	end;
end;

-- A function to get the item buffer.
function item.GetBuffer()
	return item.buffer;
end;

-- A function to get all items.
function item.GetAll()
	return item.stored;
end;

-- A function to get a new item.
function item.New(baseItem, bIsBaseItem)
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE);
		object.networkQueue = {};
		object.networkData = {};
		object.defaultData = {};
		object.recipes = {};
		object.queryProxies = {};
		object.isBaseItem = bIsBaseItem;
		object.baseItem = baseItem;
		object.data = {};
	return object;
end;

-- A function to register a new item.
function item.Register(itemTable)
	itemTable.uniqueID = string.lower(string.gsub(itemTable.uniqueID or string.gsub(itemTable.name, "%s", "_"), "['%.]", ""));

	local index = Clockwork.kernel:GetShortCRC(itemTable.uniqueID);
	local bufferEntry = item.buffer[index];
	
	if bufferEntry and bufferEntry.uniqueID ~= itemTable.uniqueID then
		index = index + 1;
	end
	
	itemTable.index = index;
	
	item.stored[itemTable.uniqueID] = itemTable;
	item.buffer[itemTable.index] = itemTable;
	
	-- Precache item materials and models.
	if itemTable.iconoverride then
		Material(itemTable.iconoverride);
	end
	
	if itemTable.hasHelmet then
		local helmetImage;
		
		if itemTable.helmetIconOverride then
			helmetImage = itemTable.helmetIconOverride;
		else
			helmetImage = string.gsub(itemTable.iconoverride, ".png", "").."_helmet.png";
		end
		
		Material(helmetImage);
	end
	
	if (itemTable.model) then
		util.PrecacheModel(itemTable.model);
	end;
	
	if (itemTable.attachmentModel) then
		util.PrecacheModel(itemTable.attachmentModel);
	end;
	
	if (itemTable.replacement) then
		util.PrecacheModel(itemTable.replacement);
	end;
	
	if (itemTable.group) then
		if itemTable.genderless then
			util.PrecacheModel("models/begotten/"..itemTable.group..".mdl");
		else
			util.PrecacheModel("models/begotten/"..itemTable.group.."_female.mdl");
			util.PrecacheModel("models/begotten/"..itemTable.group.."_male.mdl");
		end
	end
end;

-- A function to create a copy of an item instance.
function item.CreateCopy(itemTable)
	return item.CreateInstance(
		itemTable("uniqueID"), nil, itemTable("data")
	);
end;

-- A function to get whether an item is a weapon.
function item.IsWeapon(itemTable)
	if (itemTable and (itemTable:IsBasedFrom("weapon_base") or itemTable:IsBasedFrom("firearm_base"))) then
		return true;
	end;
	
	return false;
end;

-- A function to get a weapon instance by its object.
function item.GetByWeapon(weapon)
	if (IsValid(weapon)) then
		local itemID = weapon:GetNWInt("ItemID");
		
		if (itemID and itemID != 0) then
			local itemInstance = item.FindInstance(itemID);
			
			if itemInstance then
				return itemInstance;
			end
			
			local cwItemTable = weapon.cwItemTable;
			
			if cwItemTable then
				return item.CreateInstance(cwItemTable.uniqueID, cwItemTable.itemID, cwItemTable.data);
			end
		end;
		
		local owner = weapon.Owner;
		
		if IsValid(owner) and owner:IsPlayer() and owner.equipmentSlots then
			for i, v in ipairs(weapon.Owner:GetWeaponsEquipped()) do
				local weaponClass = weapon:GetClass();
				
				if v.weaponClass == weaponClass or v.uniqueID == weaponClass then
					return item.CreateInstance(v.uniqueID, v.itemID, v.data);
				end
			end
		end
	end;
end;

local function ItemDataMerge(oldData, newData)
	for k, v in pairs(newData) do
		if (istable(v) and istable(oldData[k])) then
			if table.IsEmpty(v) then
				oldData[k] = {};
			else
				ItemDataMerge(oldData[k], v)
			end
		else
			oldData[k] = v
		end
	end
end

-- A function to create an instance of an item.
function item.CreateInstance(uniqueID, itemID, data, bNoGenerate)
	local itemTable = item.FindByID(uniqueID);
	if (itemID) then itemID = tonumber(itemID); end;
	
	local generated = false;
	
	--print("Creating instance: "..itemTable.uniqueID);
	
	if (itemTable) then
		if (!itemID) then
			itemID = item.GenerateID();
			
			if !bNoGenerate then
				generated = true;
			end
		end;
		
		--print("Item ID: "..itemID);
		
		--[[if (!item.instances[itemID]) then
			item.instances[itemID] = table.Copy(itemTable);
				item.instances[itemID].itemID = itemID;
			setmetatable(item.instances[itemID], CLASS_TABLE);
		end;]]--
	
		item.instances[itemID] = table.Copy(itemTable);
			item.instances[itemID].itemID = itemID;
		setmetatable(item.instances[itemID], CLASS_TABLE);
		
		if (data) then
			ItemDataMerge(item.instances[itemID].data, data);
		end;
		
		if generated then
			if (item.instances[itemID].OnGenerated) then
				item.instances[itemID]:OnGenerated();
			end;
		end
		
		if (item.instances[itemID].AdjustAttackTable) then
			item.instances[itemID]:AdjustAttackTable(item.instances[itemID].attackTable);
		end;
		
		if (item.instances[itemID].AdjustBlockTable) then
			item.instances[itemID]:AdjustBlockTable(item.instances[itemID].blockTable);
		end;
		
		if not item.instances[itemID]:GetData("condition") then
			local defaultCondition = item.instances[itemID].defaultCondition or 100;
			
			if (defaultCondition and istable(defaultCondition)) then
				defaultCondition = math.random(defaultCondition[1], defaultCondition[2]);
			end;
			
			if (item.instances[itemID].GetDefaultCondition) then
				defaultCondition = item.instances[itemID]:GetDefaultCondition();
			end;
			
			item.instances[itemID]:AddData("condition", defaultCondition, true);
		else
			-- force this shit to network properly
			item.instances[itemID]:AddData("condition", item.instances[itemID]:GetData("condition"), true);
		end
		
		if item.category == "Firearms" or item.category == "Crossbows" then
			if not item.instances[itemID]:GetData("Ammo") then
				item.instances[itemID]:AddData("Ammo", {}, true);
			else
				item.instances[itemID]:AddData("Ammo", item.instances[itemID]:GetData("Ammo"), true);
			end
		end
		
		if (!item.instances[itemID]:GetData("value")) then
			item.instances[itemID]:AddData("value", item.instances[itemID]:GetValue(), true);
		else
			item.instances[itemID]:AddData("value", item.instances[itemID]:GetData("value"), true)
		end;
		
		if (item.instances[itemID].OnInstantiated) then
			item.instances[itemID]:OnInstantiated();
		end;
		
		return item.instances[itemID];
	end;
end;

function item.RemoveInstance(itemID, bInstant)
	if istable(itemID) then
		itemID = itemID.itemID;
	end
	
	--[[if CLIENT then
		print("[CLIENT] Removing item instance: "..tostring(item.instances[itemID] or "NIL"));
	else
		print("[SERVER] Removing item instance: "..tostring(item.instances[itemID] or "NIL"));
	end]]--
	
	if itemID then
		if bInstant then
			item.instances[itemID] = nil;
		else
			timer.Simple(FrameTime(), function()
				item.instances[itemID] = nil;
			end);
		end
	end
end

-- this is shit lol

--[[local ITEM_INDEX = 0;

-- A function to generate an item ID.
function item.GenerateID()
	ITEM_INDEX = ITEM_INDEX + 1;
	return os.time() + ITEM_INDEX;
end;]]--

ITEM_INDEX = ITEM_INDEX or Clockwork.kernel:RestoreSchemaData("itemIndex")[1] or 0;

--A function to generate an item ID.
function item.GenerateID()
	ITEM_INDEX = ITEM_INDEX + 1;
	return ITEM_INDEX;
end;

-- A function to find an instance of an item.
function item.FindInstance(itemID)
	return item.instances[tonumber(itemID)];
end;

-- A function to get an item definition.
function item.GetDefinition(itemTable, bNetworkData)
	local definition = {
		itemID = itemTable("itemID"),
		index = itemTable("index"),
		data = {}
	};
	
	if (bNetworkData) then
		for k, v in pairs(itemTable("networkData")) do
			definition.data[k] = itemTable:GetData(k);
		end;
	end;
	
	return definition;
end;

-- A function to get an item signature.
function item.GetSignature(itemTable)
	return {uniqueID = itemTable("uniqueID"), itemID = itemTable("itemID")};
end;

-- A function to get an item by its name.
function item.FindByID(identifier)
	if (identifier and identifier ~= 0 and type(identifier) ~= "boolean") then
		if (item.buffer[identifier]) then
			return item.buffer[identifier];
		elseif (item.stored[identifier]) then
			return item.stored[identifier];
		elseif (item.weapons[identifier]) then
			return item.weapons[identifier];
		end;
		
		local lowerName = string.lower(tostring(identifier));
		local itemTable = nil;
		
		for k, v in pairs(item.stored) do
			local itemName = v("name");
			
			if (string.find(string.lower(itemName), lowerName)
			and (!itemTable or string.utf8len(itemName) < string.utf8len(itemTable("name")))) then
				itemTable = v;
			end;
		end;
		
		return itemTable;
	end;
end;

-- A function to merge an item with a base item.
function item.Merge(itemTable, baseItem, bTemporary)
	local baseTable = item.FindByID(baseItem);
	local isBaseItem = itemTable("isBaseItem");
	
	if (baseTable and baseTable != itemTable) then
		local baseTableCopy = table.Copy(baseTable);
		
		if (baseTableCopy.baseItem) then
			baseTableCopy = item.Merge(
				baseTableCopy,
				baseTableCopy.baseItem,
				true
			);
			
			if (!baseTableCopy) then
				return;
			end;
		end;
		
		table.Merge(baseTableCopy, itemTable);
		
		if (!bTemporary) then
			baseTableCopy.baseClass = baseTable;
			baseTableCopy.isBaseItem = isBaseItem;
			item.Register(baseTableCopy);
		end;
		
		return baseTableCopy;
	end;
end;

function item.Initialize()
	local itemsTable = item.GetAll();

	for k, v in pairs(itemsTable) do
		if (v.baseItem and !item.Merge(v, v.baseItem)) then
			itemsTable[k] = nil;
		end;
	end;

	for k, v in pairs(itemsTable) do
		if (v.OnSetup) then v:OnSetup(); end;
		
		if (item.IsWeapon(v)) then
			item.weapons[v.weaponClass] = v;
		end;
		
		hook.Run("ClockworkItemInitialized", v);
	end;
	
	hook.Run("ClockworkPostItemsInitialized", itemsTable);
end;

if (SERVER) then
	item.entities = {};
	
	-- A function to use an item for a player.
	function item.Use(player, itemTable, bNoSound, interactItemTable)	
		local itemEntity = player:GetItemEntity();
		
		if (player:HasItemInstance(itemTable)) then
			--[[if (itemTable.HasPlayerEquipped and itemTable:HasPlayerEquipped(player)) then
				Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID)
			end;]]--
			
			if (itemTable.OnUse) then
				if (itemEntity and itemEntity.cwItemTable == itemTable) then
					player:SetItemEntity(nil);
				end;
				
				local onUse = itemTable:OnUse(player, itemEntity, interactItemTable);
				
				if (onUse == nil) then
					player:TakeItem(itemTable, true);
				elseif (onUse == false) then
					return false;
				end;
				
				if (!bNoSound) then
					if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
						local useSound = itemTable("useSound");
						
						if (useSound) then
							if (type(useSound) == "table") then
								player:EmitSound(useSound[math.random(1, #useSound)]);
							else
								player:EmitSound(useSound);
							end;
						elseif (useSound != false) then
							player:EmitSound("begotten/items/first_aid.wav");
						end;
					end;
				end;
				
				hook.Run("PlayerUseItem", player, itemTable, itemEntity, interactItemTable);
				
				return true;
			end;
		end;
	end;
	
	-- A function to drop an item from a player.
	function item.Drop(player, itemTable, position, bNoSound, bNoTake)
		if (itemTable and (bNoTake or player:HasItemInstance(itemTable))) then
			local traceLine = nil;
			local entity = nil;
			
			--[[if (itemTable.HasPlayerEquipped and itemTable:HasPlayerEquipped(player)) then
				Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID)
			end;]]--
			
			if (itemTable.OnDrop) then
				if (!position) then
					traceLine = player:GetEyeTraceNoCursor();
					position = traceLine.HitPos
				end;
				
				position = Vector(position.x, position.y, position.z + 16);
				
				if (itemTable:OnDrop(player, position) == false) then
					return false;
				end;
				
				if (itemTable.OnCreateDropEntity) then
					entity = itemTable:OnCreateDropEntity(player, position);
				end;
				
				if (!IsValid(entity)) then
					entity = Clockwork.entity:CreateItem(player, itemTable, position);
				end;
				
				if (IsValid(entity)) then
					if (traceLine and traceLine.HitNormal) then
						Clockwork.entity:MakeFlushToGround(entity, position, traceLine.HitNormal);
					end;
				end;
				
				if (!bNoTake) then
					player:TakeItem(itemTable);
				end;
				
				if (!bNoSound) then
					if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
						local dropSound = itemTable("dropSound");
						
						if (dropSound) then
							if (type(dropSound) == "table") then
								player:EmitSound(dropSound[math.random(1, #dropSound)]);
							else
								player:EmitSound(dropSound);
							end;
						elseif (dropSound != false) then
							player:EmitSound("generic_ui/Generic_0"..math.random(4, 5)..".wav");
						end;
					end;
				end;
				
				hook.Run("PlayerDropItem", player, itemTable, position, entity);
				
				return true;
			end;
		end;
	end;
	
	-- A function to destroy a player's item.
	function item.Destroy(player, itemTable, bNoSound)
		if (player:HasItemInstance(itemTable) and itemTable.OnDestroy) then
			if (itemTable:OnDestroy(player) == false) then
				return false;
			end;
			
			player:TakeItem(itemTable, true);
			
			if (!bNoSound) then
				if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
					local destroySound = itemTable("destroySound");
					
					if (destroySound) then
						if (type(destroySound) == "table") then
							player:EmitSound(destroySound[math.random(1, #destroySound)]);
						else
							player:EmitSound(destroySound);
						end;
					elseif (destroySound != false) then
						player:EmitSound("generic_ui/Generic_0"..math.random(4, 5)..".wav");
					end;
				end;
			end;
			
			hook.Run("PlayerDestroyItem", player, itemTable);
			
			return true;
		end;
	end;
	
	-- A function to remove an item entity.
	function item.RemoveItemEntity(entity)
		local itemTable = entity:GetItemTable();
		item.entities[itemTable("itemID")] = nil;
	end;
	
	-- A function to add an item entity.
	function item.AddItemEntity(entity, itemTable)
		item.entities[itemTable("itemID")] = entity;
	end;
	
	-- A function to find an entity by an instance.
	function item.FindEntityByInstance(itemTable)
		local entity = item.entities[itemTable("itemID")];
		
		if (IsValid(entity)) then
			return entity;
		end;
	end;

	--[[
		@codebase Server
		@details A function to send an item to a player.
	--]]
	function item.SendToPlayer(player, itemTable)
		if (itemTable) then
			netstream.Start(
				player, "ItemData", item.GetDefinition(itemTable, true)
			);
		end;
	end;
	
	--[[
		@codebase Server
		@details A function to send an item update to it's observers.
		@returns Table The table of observers.
	--]]
	function item.SendUpdate(itemTable, data)
		if (itemTable) then
			local itemID = itemTable("itemID");

			netstream.Start(nil, "InvNetwork", {
				itemID = itemID,
				data = data
			});
		end;
	end;	
else
	function item.GetIconInfo(itemTable)
		local model = itemTable("iconModel", itemTable("model"));
		local skin = itemTable("iconSkin", itemTable("skin"));
		
		if (itemTable.GetClientSideModel) then
			model = itemTable:GetClientSideModel();
		end;
		
		if (itemTable.GetClientSideSkin) then
			skin = itemTable:GetClientSideSkin();
		end;
		
		if (not model) then
			model = "models/props_c17/oildrum001.mdl";
		end;
		
		return model, skin;
	end;
	
	function item.GetMarkupToolTip(itemTable) end;
	
	-- A function to get an item's markup tooltip.
	function item.BuildTooltip(category, itemTable, x, y, width, height, frame, bShowWeight)
		local maximumWeight = Clockwork.inventory:CalculateWeight(Clockwork.inventory:GetClient());
		local weight = itemTable("weight");
		local condition = itemTable:GetCondition() or 100;
		local freezing = itemTable:GetData("freezing");
		local percentage = (weight / maximumWeight);
		local name = itemTable:GetName();
		
		if maximumWeight == 0 then
			percentage = 1;
		end
		
		if freezing and freezing > 25 then
			name = "Frozen "..name;
		elseif condition and condition <= 0 then
			name = "Broken "..name;
		end
		
		if !hook.Run("ModifyItemMarkupTooltip", category, maximumWeight, weight, condition, percentage, name, itemTable, x, y, width, height, frame, bShowWeight) then
			frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
			
			if (bShowWeight) then
				frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			end;
		end
	end;
	
	netstream.Hook("ItemData", function(data)
		item.CreateInstance(
			data.index, data.itemID, data.data
		);
	end);
end;

function item.IncludeItems(directory)
	if (!directory:EndsWith("/")) then
		directory = directory.."/"
	end

	local files, dirs = _file.Find(directory.."*", "LUA", "namedesc")

	for k, v in ipairs(files) do
		util.Include(directory..v)
	end
end