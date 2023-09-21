local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Shield Base";
ITEM.useText = "Equip";
ITEM.useSound = false;
ITEM.category = "Shields";
ITEM.useInVehicle = false;
ITEM.excludeFactions = {};
ITEM.requireFaction = {};
ITEM.requireFaith = {};
ITEM.breakable = true;
ITEM.breakMessage = " shatters into pieces!";
ITEM.repairItem = "weapon_repair_kit";
ITEM.customFunctions = {"Engrave"};

ITEM:AddData("engraving", "", true);

function ITEM:Engrave(player, text, engravingItemTable)
	local nospaces = string.gsub(text,"%s+","")
	
	if string.len(text) > 32 then
		Schema:EasyText(player, "chocolate", "This name is too long!");
	elseif #nospaces == 0 then
		Schema:EasyText(player, "peru", "You can't leave this blank!");
	else
		self:SetData("engraving", text);
		player:TakeItem(engravingItemTable, true);
		Schema:EasyText(player, "olivedrab", "You engrave \'"..text.."\' into the side of your shield.");
		Clockwork.inventory:Rebuild(player);
	end;
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Engrave") then
			if self:GetData("engraving") != "" then
				Schema:EasyText(player, "peru", "This weapon has already been engraved!");
			else
				local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
				local engravingItemTable;

				for k, v in pairs (itemList) do
					if v.uniqueID == "engraving_tool" then
						engravingItemTable = v;
						break;
					end
				end
	
				if engravingItemTable then
					Clockwork.dermaRequest:RequestString(player, "Engrave Weapon", "What would you like to etch on this item?", "", function(result)
						self:Engrave(player, result, engravingItemTable);
					end);
				else
					Schema:EasyText(player, "chocolate", "You do not have an item you can engrave this item with!");
					return false;
				end
			end;
		end;
	end;
end;

function ITEM:GetEngraving()
	local engraving = self.name;
	
	if self:GetData("engraving") != "" then
		engraving = self:GetData("engraving");
	end;
	
	return engraving;
end;

ITEM:AddQueryProxy("name", ITEM.GetEngraving);

-- Called when a player attempts to holster the weapon.
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	local shieldData = player.bgShieldData or {}

	Clockwork.datastream:Start(player, "BGShieldData", nil);
	Clockwork.player:SaveGear(player);
	
	player.bgShieldData = {};

	for k, v in pairs(player:GetWeapons()) do
		if v:GetNWString("activeShield"):len() > 0 then
			v:HolsterShield();
		end
	end
	
	local gearPrimary = Clockwork.player:GetGear(player, "Primary");
	local gearSecondary = Clockwork.player:GetGear(player, "Secondary");
	local gearTertiary = Clockwork.player:GetGear(player, "Tertiary");
	
	if IsValid(gearPrimary) and gearPrimary:GetItemTable().uniqueID == self.uniqueID then
		Clockwork.player:RemoveGear(player, "Primary");
	elseif IsValid(gearSecondary) and gearSecondary:GetItemTable().uniqueID == self.uniqueID then
		Clockwork.player:RemoveGear(player, "Secondary");
	elseif IsValid(gearTertiary) and gearTertiary:GetItemTable().uniqueID == self.uniqueID then
		Clockwork.player:RemoveGear(player, "Tertiary");
	end

	return true
end;

function ITEM:OnEquip(player)
	if self:IsBroken() then
		Schema:EasyText(player, "olive", "This shield is broken and cannot be used!");
		return false;
	end

	local slots = {"Primary", "Secondary", "Tertiary"};
	
	for i = 1, #slots do
		if (!Clockwork.player:GetGear(player, slots[i])) then
			Clockwork.player:CreateGear(player, slots[i], self);
			
			return true;
		end
	end
	
	Schema:EasyText(player, "peru", "You do not have an open slot to equip this shield in!")
	return false;
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();

	if (table.HasValue(self.excludeFactions, faction)) then
		Schema:EasyText(player, "chocolate", "You are not the correct faction for this item!")
		return false
	end
	
	if #self.requireFaith > 0 then
		if (!table.HasValue(self.requireFaith, player:GetFaith())) then
			Schema:EasyText(player, "chocolate", "You are not the correct faith for this item!")
			return false
		end
	end
	
	if #self.requireFaction > 0 then
		if (!table.HasValue(self.requireFaction, faction)) then
			Schema:EasyText(player, "chocolate", "You are not the correct faction for this item!")
			return false
		end
	end
	
	local shieldData = player.bgShieldData or {}
	local gearPrimary = Clockwork.player:GetGear(player, "Primary");
	local gearSecondary = Clockwork.player:GetGear(player, "Secondary");
	local gearTertiary = Clockwork.player:GetGear(player, "Tertiary");
	local suitable_melee = nil;
	
	if (self:HasPlayerEquipped(player)) or (IsValid(gearPrimary) and gearPrimary:GetItemTable().category == "Shields") or (IsValid(gearSecondary) and gearSecondary:GetItemTable().category == "Shields") or (IsValid(gearTertiary) and gearTertiary:GetItemTable().category == "Shields") then
		Schema:EasyText(player, "peru", "You already have a shield equipped!")
		return false;
	end
	
	if (!IsValid(gearPrimary) and !IsValid(gearSecondary) and !IsValid(gearTertiary)) then
		Schema:EasyText(player, "chocolate", "You must equip a suitable weapon to use with this shield!");
		return false;
	else
		-- The first found suitable weapon will be the one considered the weapon that will be given a shield.
		
		if IsValid(gearPrimary) then
			local gearPrimaryItem = gearPrimary:GetItemTable();

			if gearPrimaryItem and gearPrimaryItem.canUseShields then
				suitable_melee = gearPrimaryItem.itemID;
			end
		end
		
		if not suitable_melee then
			if IsValid(gearSecondary) then
				local gearSecondaryItem = gearSecondary:GetItemTable();

				if gearSecondaryItem and gearSecondaryItem.canUseShields then
					suitable_melee = gearSecondaryItem.itemID;
				end
			end
		end
		
		if not suitable_melee then
			if IsValid(gearTertiary) then
				local gearTertiaryItem = gearTertiary:GetItemTable();
					
				if gearTertiaryItem and gearTertiaryItem.canUseShields then
					suitable_melee = gearTertiaryItem.itemID;
				end
			end
		end
		
		if not suitable_melee then
			Schema:EasyText(player, "chocolate", "You do not have a suitable melee weapon equipped for use with this shield!");
			return false;
		end
	end

	local weaponItemFound = false;
	
	for k, v in pairs(player:GetWeapons()) do
		local itemTable = item.GetByWeapon(v)

		if itemTable then
			if itemTable.itemID == suitable_melee then
				weaponItemFound = true;
				
				if itemTable.canUseShields then
					if (self.OnEquip) then
						if self:OnEquip(player) == false then
							return false;
						end
					end;
				
					shieldData.itemID = self.uniqueID.." "..self.itemID
					shieldData.uniqueID = self.uniqueID
					shieldData.realID = self.itemID
					
					Clockwork.datastream:Start(player, "BGShieldData", shieldData)

					player.bgShieldData = shieldData;
					
					--player:StripWeapon(itemTable.uniqueID);
					--player:Give(itemTable("weaponClass").."_"..self.uniqueID, itemTable);
					
					v:EquipShield(self.uniqueID);
					
					if not player.cwWakingUp then
						--player:SelectWeapon(itemTable("weaponClass").."_"..self.uniqueID);
						player:SelectWeapon(itemTable("weaponClass"));
					end
					
					Clockwork.player:SaveGear(player);
					
					return true;
				end
			end
		end
	end
	
	if not weaponItemFound then
		-- Search again for any suitable weapon.
		for k, v in pairs(player:GetWeapons()) do
			local itemTable = item.GetByWeapon(v)

			if itemTable then
				weaponItemFound = true;
				
				if itemTable.canUseShields then
					if (self.OnEquip) then
						if self:OnEquip(player) == false then
							return false;
						end
					end;
					
					shieldData.itemID = self.uniqueID.." "..self.itemID
					shieldData.uniqueID = self.uniqueID
					shieldData.realID = self.itemID
					
					Clockwork.datastream:Start(player, "BGShieldData", shieldData)
					
					player.bgShieldData = shieldData;
					
					--player:StripWeapon(itemTable.uniqueID);
					--player:Give(itemTable("weaponClass").."_"..self.uniqueID, itemTable);
					
					if not player.cwWakingUp then
						--player:SelectWeapon(itemTable("weaponClass").."_"..self.uniqueID);
						player:SelectWeapon(itemTable("weaponClass"));
					end
					
					Clockwork.player:SaveGear(player);
					
					return true;
				end
			end
		end
	
		if not weaponItemFound then
			Schema:EasyText(player, "peru", "Your currently equipped weapons cannot be used with this shield!");
		else
			Schema:EasyText(player, "chocolate", "You must equip a suitable weapon to use with this shield!");
		end
	else
		Schema:EasyText(player, "chocolate", "You must equip a suitable weapon to use with this shield!");
	end
	
	return false;
end;

-- Called when a player repairs the item.
function ITEM:OnRepair(player, itemEntity)
	return true;
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	local shieldData = player.bgShieldData or {}

	if (self:HasPlayerEquipped(player)) then
		Clockwork.datastream:Start(player, "BGShieldData", nil);
		Clockwork.player:SaveGear(player);

		player.bgShieldData = {};
	end
	
	return true
end;

-- Called when a player attempts to sell the item to salesman.
function ITEM:CanSell(player)
	local shieldData = player.bgShieldData or {}

	if (self:HasPlayerEquipped(player)) then
		Clockwork.datastream:Start(player, "BGShieldData", nil);
		Clockwork.player:SaveGear(player);

		player.bgShieldData = {};
	end

	return true
end

-- Called when a player attempts to give the item to storage.
function ITEM:CanGiveStorage(player, storageTable)
	local shieldData = player.bgShieldData or {}

	if (self:HasPlayerEquipped(player)) then
		Clockwork.datastream:Start(player, "BGShieldData", nil);
		Clockwork.player:SaveGear(player);

		player.bgShieldData = {};
	end

	return true
end

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) end

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	--[[local shieldData = player.bgShieldData or {}

	if (CLIENT) then
		shieldData = Clockwork.Client.bgshieldData or {}
	end

	if (shieldData and shieldData.uniqueID == self.uniqueID) then
		return true
	end]]--
	
	local slots = {"Primary", "Secondary", "Tertiary"};
	
	if (CLIENT) then
		for i = 1, #slots do
			if Clockwork.player:GetGear(slots[i]) == self.itemID then
				return true;
			end
		end
	else
		for i = 1, #slots do
			if Clockwork.player:GetGear(player, slots[i]) then
				if Clockwork.player:GetGear(player, slots[i]):GetItemTable().itemID == self.itemID then
					return true;
				end
			end
		end
	end

	return false
end

Clockwork.item:Register(ITEM);