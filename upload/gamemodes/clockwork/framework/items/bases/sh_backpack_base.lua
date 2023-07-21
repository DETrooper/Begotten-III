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

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	local backpackData = player.bgBackpackData or {}

	if (CLIENT) then
		backpackData = Clockwork.Client.bgBackpackData or {}
	end

	if (backpackData[1] and (backpackData[1].itemID == self.uniqueID.." "..self.itemID or backpackData[1].itemID == self.itemID)) then
		return true
	end

	return false
end

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	local backpackData = player.bgBackpackData or {}
	local useSound = self.useSound;

	if (CLIENT) then
		backpackData = Clockwork.Client.bgBackpackData or {}
	end

	if (backpackData[1] and (backpackData[1].itemID == self.uniqueID.." "..self.itemID or backpackData[1].itemID == self.itemID)) then
		backpackData[1] = nil;
	end

	player.bgBackpackData = backpackData;
	Clockwork.datastream:Start(player, "BGBackpackData", backpackData);

	local temptab = {};

	if backpackData[1] then
		temptab[1] = {["uniqueID"] = backpackData[1].uniqueID, ["itemID"] = backpackData[1].itemID};
	end
	
	if table.IsEmpty(temptab) then
		player:SetCharacterData("backpacks", nil);
		player:SetNetVar("backpacks", 0);
	else
		player:SetCharacterData("backpacks", temptab);
		player:SetNetVar("backpacks", temptab);
	end
	
	local maxWeight = player:GetMaxWeight();
		
	player.cwInfoTable.inventoryWeight = maxWeight;
	player.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
	player.maxWeight = maxWeight;
	
	player:SetNetVar("InvWeight", math.ceil(player.cwInfoTable.inventoryWeight))
	
	if player.cwInfoTable.inventorySpace then
		player:SetNetVar("InvSpace", math.ceil(player.cwInfoTable.inventorySpace))
	end
	
	if player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle() then
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
	
	if (Clockwork.player:GetGear(player, "Backpack")) then
		Clockwork.player:RemoveGear(player, "Backpack");
	end
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
	
	if (table.HasValue(self.excludeFactions, player:GetFaction())) then
		if !player.spawning then
			Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
		end
			
		return false
	end
	
	if (table.HasValue(self.excludeSubfactions, player:GetSubfaction())) then
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
		if (!table.HasValue(self.requireFaction, player:GetFaction())) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
			end
			
			return false
		end
	end
	
	if #self.requireSubfaction > 0 then
		if (!table.HasValue(self.requireSubfaction, player:GetSubfaction())) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You are not the correct subfaction to wear this!")
			end
			
			return false
		end
	end

	if (player:Alive()) then
		local backpackData = player.bgBackpackData or {}
		local empty_slot_found = false;
		
		if (CLIENT) then
			backpackData = Clockwork.Client.bgBackpackData or {}
		end
		
		for i = 1, #backpackData do
			if backpackData[i] then
				if backpackData[i].uniqueID == self.uniqueID then
					if !player.spawning then
						Schema:EasyText(player, "peru", "You already have a backpack of this type equipped!")
					end
					
					return false
				end
			end
		end
		
		if (!backpackData[1]) then
			backpackData[1] = {};
			backpackData[1].uniqueID = self.uniqueID;
			backpackData[1].itemID = self.itemID;
			empty_slot_found = true;
		end
		
		if not empty_slot_found then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You do not have an open slot to equip this backpack in!")
			end
			
			return false;
		end
		
		player.bgBackpackData = backpackData;
		Clockwork.datastream:Start(player, "BGBackpackData", backpackData);

		local temptab = {};
		
		if backpackData[1] then
			temptab[1] = {["uniqueID"] = backpackData[1].uniqueID, ["itemID"] = backpackData[1].itemID};
		end
	
		if table.IsEmpty(temptab) then
			player:SetCharacterData("backpacks", nil);
			player:SetNetVar("backpacks", 0);
		else
			player:SetCharacterData("backpacks", temptab);
			player:SetNetVar("backpacks", temptab);
		end
		
		local maxWeight = player:GetMaxWeight();
			
		player.cwInfoTable.inventoryWeight = maxWeight;
		player.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		player.maxWeight = maxWeight;
		
		player:SetNetVar("InvWeight", math.ceil(player.cwInfoTable.inventoryWeight))
		
		if player.cwInfoTable.inventorySpace then
			player:SetNetVar("InvSpace", math.ceil(player.cwInfoTable.inventorySpace))
		end
		
		if (!Clockwork.player:GetGear(player, "Backpack")) then
			Clockwork.player:CreateGear(player, "Backpack", self);
		end

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

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return end

		if (Clockwork.player:IsWearingItem(self)) then
			return "Is wearing? Yes."
		else
			return "Is wearing? No."
		end
	end
end

ITEM:Register();

Clockwork.datastream:Hook("BGBackpackData", function(data)
	Clockwork.Client.bgBackpackData = data;
end);