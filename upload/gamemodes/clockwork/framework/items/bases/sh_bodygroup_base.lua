--[[
	© 2016 TeslaCloud Studios.
	Private code for Global Cooldown community.
	Stealing Lua cache is not nice lol.
	get a life kiddos.
--]]

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Bodygroup Base"
	ITEM.model = "models/tnb/items/shirt_citizen1.mdl"
	ITEM.skin = 1
	ITEM.weight = 1
	ITEM.useText = "Wear"
	ITEM.category = "Clothing"
	ITEM.description = "Default Bodygroup Clothing Item."
	ITEM.excludeFactions = {};
	ITEM.requireFaction = {};
	ITEM.requireFaith = {};
	ITEM.excludeSubfactions = {};
	ITEM.bodyGroup = -1
	ITEM.bodyGroupVal = -1
	ITEM.requiredBG = {-1, -1}
	ITEM.isCombine = false
	ITEM.repairItem = "armor_repair_kit";

	function ITEM:SetBodygroup(player, bg, val)
		if (bg <= player:GetNumBodyGroups()) then
			player:SetBodygroup(bg, val)

			return true
		else
			Schema:EasyText(player, "peru", "You cannot wear this!")

			return false
		end
	end

	function ITEM:ResetBodygroup(player, bg)
		player:SetBodygroup(bg, 0)
		return true
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local clothesData = player.bgClothesData or {}
		local clothesItem = player:GetClothesItem();
		local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		local subfaction = player:GetSharedVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
		
		if cwPowerArmor and player:IsWearingPowerArmor() then
			Schema:EasyText(player, "peru", "You cannot wear this while in power armor!");
			return false;
		end
		
		if self:IsBroken() then
			Schema:EasyText(player, "peru", "This helmet is broken and cannot be used!");
			return false;
		end
		
		if (table.HasValue(self.excludeFactions, faction)) then
			Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
			return false
		end
		
		if (table.HasValue(self.excludeSubfactions, subfaction)) then
			Schema:EasyText(player, "peru", "Your subfaction cannot wear this!")
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
				Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
				return false
			end
		end
		
		if clothesItem then
			if clothesItem.hasHelmet then
				Schema:EasyText(player, "peru", "You cannot wear this helmet, as your equipped armor already has one!")
				return false
			end
		end
		
		if (self.requiredBG[1] != -1) then
			local bgData = clothesData[self.requiredBG[1]]
			if (!bgData) then
				Schema:EasyText(player, "peru", "You cannot wear this!")
				return false
			end
		end

		if (self.bodyGroup != -1) then
			if (player:Alive() and !player:IsRagdolled()) then
				player:SetBodygroupClothes(self)
				return true
			end
		else
			Schema:EasyText(player, "peru", "You cannot wear this!")

			return false
		end
	end
	
	-- Called when a player repairs the item.
	function ITEM:OnRepair(player, itemEntity)
		return true;
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (self:HasPlayerEquipped(player) and self.bodyGroup != -1) then
			player:SetBodygroupClothes(self, true)
		end

		return true
	end

	-- Called when a player attempts to sell the item to salesman.
	function ITEM:CanSell(player)
		if (self:HasPlayerEquipped(player) and self.bodyGroup != -1) then
			player:SetBodygroupClothes(self, true)
		end

		return true
	end

	-- Called when a player attempts to give the item to storage.
	function ITEM:CanGiveStorage(player, storageTable)
		if (self:HasPlayerEquipped(player) and self.bodyGroup != -1) then
			player:SetBodygroupClothes(self, true)
		end

		return true
	end

	-- Called when a player changes clothes.
	function ITEM:OnChangeClothes(player, bIsWearing)
		if (bIsWearing) then
			self:SetBodygroup(player, self.bodyGroup, self.bodyGroupVal)
		else
			self:ResetBodygroup(player, self.bodyGroup)
		end
		
		if self.concealsFace == true then
			if bIsWearing then
				player:SetSharedVar("faceConcealed", true);
			else
				player:SetSharedVar("faceConcealed", false);
			end
		end

		if (self.OnChangedClothes) then
			self:OnChangedClothes(player, bIsWearing)
		end
	end

	-- Called to get whether a player has the item equipped.
	function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
		local clothesData = player.bgClothesData or {}

		if (CLIENT) then
			clothesData = Clockwork.Client.bgClothesData or {}
		end

		local bg = self.bodyGroup

		if (clothesData[bg] and clothesData[bg].val != nil and clothesData[bg].itemID == self.uniqueID.." "..self.itemID) then
			return true
		end

		return false
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		if self:HasPlayerEquipped(player) then
			player:SetBodygroupClothes(self, true)
			
			local useSound = self.useSound;
			
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
			
			if self.concealsFace == true then
				player:SetSharedVar("faceConcealed", false);
			end
		end
	end
	
	-- Called when a player has unequipped the item.
	function ITEM:OnTakeFromPlayer(player)
		if (player:IsWearingItem(self)) then
			player:SetBodygroupClothes(self, true)
			
			if self.concealsFace == true then
				player:SetSharedVar("faceConcealed", false);
			end
		end
	end
	
ITEM:Register();