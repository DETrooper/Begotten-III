--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Enchanted Base"
	ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl"
	ITEM.weight = 2
	ITEM.useText = "Equip"
	ITEM.category = "Charms"
	ITEM.description = "An enchanted item with a mysterious aura."
	ITEM.requiredFaiths = nil;

	-- Called to get whether a player has the item equipped.
	function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
		local charmData = player.bgCharmData or {}

		if (CLIENT) then
			charmData = Clockwork.Client.bgCharmData or {}
		end

		for i = 1, 2 do
			if (charmData[i] and (charmData[i].itemID == self.uniqueID.." "..self.itemID or charmData[i].itemID == self.itemID)) then
				return true
			end
		end

		return false
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		local charmData = player.bgCharmData or {}
		local useSound = self.useSound;

		if (CLIENT) then
			charmData = Clockwork.Client.bgCharmData or {}
		end

		for i = 1, 2 do
			if (charmData[i] and (charmData[i].itemID == self.uniqueID.." "..self.itemID or charmData[i].itemID == self.itemID)) then
				charmData[i] = nil;
				break;
			end
		end
		
		player.bgCharmData = charmData;
		Clockwork.datastream:Start(player, "BGCharmData", charmData);
		
		local charm_items_found = 0;
		local temptab = {};
		
		for i = 1, 2 do
			if charmData[i] then
				charm_items_found = charm_items_found + 1;
				temptab[charm_items_found] = {["uniqueID"] = charmData[i].uniqueID, ["itemID"] = charmData[i].itemID};
			end
		end
		
		if table.IsEmpty(temptab) then
			player:SetCharacterData("charms", nil);
			player:SetNetVar("charms", 0);
		else
			player:SetCharacterData("charms", temptab);
			player:SetNetVar("charms", temptab);
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
		
		-- kind of shit but oh well
		
		if self.uniqueID == "ring_vitality" then
			local max_health = player:GetMaxHealth();
			
			player:SetMaxHealth(player:GetMaxHealth());
			player:SetHealth(math.Clamp(player:Health(), 1, max_health));
		elseif self.uniqueID == "ring_courier" then
			local max_stamina = player:GetMaxStamina();
			local new_stamina = math.Clamp(player:GetCharacterData("Stamina", 100), 0, max_stamina);

			player:SetLocalVar("Max_Stamina", max_stamina);
			player:SetCharacterData("Max_Stamina", max_stamina);
			player:SetNWInt("Stamina", new_stamina);
			player:SetCharacterData("Stamina", new_stamina);
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
				Schema:EasyText(player, "chocolate", "You are not of the correct faith to wear this!")
			end
			
			return false
		end

		if (player:Alive()) then
			local charmData = player.bgCharmData or {}
			local empty_slot_found = false;
			
			if (CLIENT) then
				charmData = Clockwork.Client.bgCharmData or {}
			end
			
			for i = 1, #charmData do
				if charmData[i] then
					if charmData[i].uniqueID == self.uniqueID then
						if !player.spawning then
							Schema:EasyText(player, "peru", "You already have a charm of this type equipped!")
						end
						
						return false
					end
				end
			end
			
			for i = 1, 2 do
				if (!charmData[i]) then
					charmData[i] = {};
					charmData[i].uniqueID = self.uniqueID;
					charmData[i].itemID = self.itemID;
					empty_slot_found = true;
					
					break;
				end
			end
			
			if not empty_slot_found then
				if !player.spawning then
					Schema:EasyText(player, "peru", "You do not have an open slot to equip this charm in!")
				end
				
				return false;
			end
			
			player.bgCharmData = charmData;
			Clockwork.datastream:Start(player, "BGCharmData", charmData);

			local charm_items_found = 0;
			local temptab = {};
			
			for i = 1, 2 do
				if charmData[i] then
					charm_items_found = charm_items_found + 1;
					temptab[charm_items_found] = {["uniqueID"] = charmData[i].uniqueID, ["itemID"] = charmData[i].itemID};
				end
			end
			
			if table.IsEmpty(temptab) then
				player:SetCharacterData("charms", nil);
				player:SetNetVar("charms", 0);
			else
				player:SetCharacterData("charms", temptab);
				player:SetNetVar("charms", temptab);
			end
			
			local max_stamina = player:GetMaxStamina();
			
			player:SetMaxHealth(player:GetMaxHealth());
			player:SetLocalVar("Max_Stamina", max_stamina);
			player:SetCharacterData("Max_Stamina", max_stamina);

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

Clockwork.datastream:Hook("BGCharmData", function(data)
	Clockwork.Client.bgCharmData = data;
end);