local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Backpack Base";
ITEM.uniqueID = "backpack_base";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 2; -- The real, actual weight of the item (as opposed to the perceived weight)
ITEM.invSpace = 4; -- The amount of additional space this item gives when equipped
ITEM.useText = "Equip";
ITEM.category = "Backpacks";
ITEM.description = "A nice black backpack that can hold stuff.";
ITEM.excludeFactions = {};
ITEM.requireFaction = {};
ITEM.requireSubfaction = {};
ITEM.requireFaith = {};
ITEM.excludeSubfactions = {};
ITEM.slots = {"Backpacks"};
ITEM.equipmentSaveString = "backpack";

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	if Clockwork.equipment:UnequipItem(player, self) then
		local maxWeight = player:GetMaxWeight();
		local useSound = self.useSound;
			
		player.cwInfoTable.inventoryWeight = maxWeight;
		player.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		player.maxWeight = maxWeight;
		
		player:SetNetVar("InvWeight", math.ceil(player.cwInfoTable.inventoryWeight))
		
		if player.cwInfoTable.inventorySpace then
			player:SetNetVar("InvSpace", math.ceil(player.cwInfoTable.inventorySpace))
		end
		
		if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
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
		
		return true;
	end
	
	return false;
end

function ITEM:HasPlayerEquipped(player)
	return player:GetBackpackEquipped(self);
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (self:HasPlayerEquipped(player)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "You cannot drop an item you're currently wearing.")
		end
		
		return false
	end
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetSharedVar("kinisgerOverrideSubfaction");

	if (self:HasPlayerEquipped(player)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "You cannot equip an item you're already using.")
		end
		
		return false
	end

	if self.requiredFaiths and not (table.HasValue(self.requiredFaiths, player:GetFaith())) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "You are not of the correct faith to wear this!")
		end
		
		return false
	end
	
	if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
		end
			
		return false
	end
	
	if (table.HasValue(self.excludeSubfactions, kinisgerOverrideSubfaction or subfaction)) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "Your subfaction cannot wear this!")
		end
		
		return false
	end
	
	if #self.requireFaith > 0 then
		if (!table.HasValue(self.requireFaith, player:GetFaith())) then
			if !player.spawning then
				Schema:EasyText(player, "chocolate", "You are not the correct faith for this item!")
			end

			return false
		end
	end
	
	if #self.requireFaction > 0 then
		if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
			end
			
			return false
		end
	end
	
	if #self.requireSubfaction > 0 then
		if (!table.HasValue(self.requireSubfaction, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requireSubfaction, kinisgerOverrideSubfaction))) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You are not the correct subfaction to wear this!")
			end
			
			return false
		end
	end

	if (player:Alive()) then
		local backpack = player:GetBackpackEquipped();
		
		if backpack and backpack.uniqueID == self.uniqueID then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You already have a backpack of this type equipped!")
			end
			
			return false
		end
		
		local maxWeight = player:GetMaxWeight();
			
		player.cwInfoTable.inventoryWeight = maxWeight;
		player.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		player.maxWeight = maxWeight;
		
		player:SetNetVar("InvWeight", math.ceil(player.cwInfoTable.inventoryWeight))
		
		if player.cwInfoTable.inventorySpace then
			player:SetNetVar("InvSpace", math.ceil(player.cwInfoTable.inventorySpace))
		end
		
		Clockwork.equipment:EquipItem(player, self, "Backpacks")

		return true
	else
		if !player.spawning then
			Schema:EasyText(player, "peru", "You cannot do this action at this moment.")
		end
	end

	return false
end

function ITEM:OnInstantiated()
	-- why is this here?
	--printp("FUCKED")
end;

ITEM:Register();