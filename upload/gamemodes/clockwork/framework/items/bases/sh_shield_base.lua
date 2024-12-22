local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Shield Base";
ITEM.useText = "Equip";
ITEM.useSound = false;
ITEM.category = "Shields";
ITEM.useInVehicle = false;
ITEM.excludeFactions = {};
ITEM.requireFaction = {};
ITEM.requireSubfaction = {};
ITEM.requireFaith = {};
ITEM.breakable = true;
ITEM.breakMessage = " shatters into pieces!";
ITEM.repairItem = "weapon_repair_kit";
ITEM.customFunctions = {"Engrave"};
ITEM.slots = {"Primary", "Secondary", "Tertiary"};
ITEM.equipmentSaveString = "weapons";

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
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has engraved a "..self.name.." "..self.itemID.." to "..text)
		Clockwork.inventory:Rebuild(player);
	end;
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Engrave") then
			if self:GetData("engraving") != "" then
				Schema:EasyText(player, "peru", "This weapon has already been engraved!");
			elseif cwBeliefs and !player:HasBelief("literacy") then
				Schema:EasyText(player, "chocolate", "You are not literate!");
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
	if (extraData != "drop") then
		if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
			local useSound = self("useSound");
			
			if (useSound) then
				if (type(useSound) == "table") then
					player:EmitSound(useSound[math.random(1, #useSound)]);
				else
					player:EmitSound(useSound);
				end;
			elseif (useSound != false) then
				player:EmitSound("begotten/items/first_aid.wav");
			end;
		end
		
		for k, v in pairs(player:GetWeapons()) do
			if v:GetNW2String("activeShield"):len() > 0 then
				v:HolsterShield();
			end
		end
		
		return Clockwork.equipment:UnequipItem(player, self);
	elseif (hook.Run("PlayerCanDropWeapon", player, self)) then
		local trace = player:GetEyeTraceNoCursor()

		if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
			local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
			
			if (IsValid(entity)) then
				if (self:HasPlayerEquipped(player)) then
					for k, v in pairs(player:GetWeapons()) do
						if v:GetNW2String("activeShield"):len() > 0 then
							v:HolsterShield();
						end
					end
				
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					player:TakeItem(self);
					
					return Clockwork.equipment:UnequipItem(player, self);
				end
			end;
		else
			Schema:EasyText(player, "peru", "You cannot drop your shield that far away!");
		end;
	end
end;

function ITEM:HasPlayerEquipped(player)
	return player:GetShieldEquipped(self);
end

function ITEM:OnEquip(player)
	if self:IsBroken() then
		Schema:EasyText(player, "olive", "This shield is broken and cannot be used!");
		return false;
	end
	
	if player:GetShieldEquipped() then
		Schema:EasyText(player, "olive", "You cannot equip more than one shield!");
		return false;
	end
	
	local slot;

	for i, v in ipairs(self.slots) do
		if !player.equipmentSlots[v] then
			slot = v;
			break;
		end
		
		if i == #self.slots then
			Schema:EasyText(player, "peru", "You do not have an open slot to equip this shield in!")
			return false;
		end
	end
	
	-- New code for multiple one-handed weapons per shield.
	for i, v in ipairs(self.slots) do
		local meleeItem = player.equipmentSlots[v];
		
		if meleeItem and meleeItem.canUseShields then
			-- Check to make sure the weapon isn't being dual-wielded.
			if !player.equipmentSlots[v.."Offhand"] then
				local weapon = player:GetWeapon(meleeItem.weaponClass or meleeItem.uniqueID);
				
				if IsValid(weapon) then
					local bSuccess = Clockwork.equipment:EquipItem(player, self, slot);
					
					if bSuccess then
						weapon:EquipShield(self.uniqueID);
					
						return true;
					end
				end
			end
		end
	end
	
	Schema:EasyText(player, "chocolate", "You do not have a suitable melee weapon equipped for use with this shield!");
	return false;
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetNetVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetNetVar("kinisgerOverrideSubfaction");
	local suitable_melee;

	if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
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
		if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
			Schema:EasyText(player, "chocolate", "You are not the correct faction for this item!")
			return false
		end
	end
	
	if #self.requireSubfaction > 0 then
		if (!table.HasValue(self.requireSubfaction, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requireSubfaction, kinisgerOverrideSubfaction))) then
			Schema:EasyText(player, "peru", "You are not the correct subfaction to wear this!")
			
			return false
		end
	end
	
	if (self:HasPlayerEquipped(player)) then
		Schema:EasyText(player, "peru", "You already have a shield equipped!")
		return false;
	end
	
	if (self.OnEquip) then
		if self:OnEquip(player) then
			return true;
		end
	end;

	return false;
end;

-- Called when a player repairs the item.
function ITEM:OnRepair(player, itemEntity)
	return true;
end

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) end

function ITEM:OnDrop(player, position) end

Clockwork.item:Register(ITEM);