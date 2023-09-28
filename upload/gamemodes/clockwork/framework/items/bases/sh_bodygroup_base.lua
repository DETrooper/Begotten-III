--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local head_suffixes = {"_glaze", "_gore", "_satanist", "_wanderer"};

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
	ITEM.repairItem = "armor_repair_kit";
	ITEM.slots = {"Helms"};
	ITEM.equipmentSaveString = "helmet";

	function ITEM:SetBodygroup(player, bg, val)
		if val ~= 0 and self.headSuffix then
			local model = player:GetModel();
			
			if model then
				for i, v in ipairs(head_suffixes) do
					if v ~= self.headSuffix then
						model = string.gsub(model, v, self.headSuffix);
					end
				end
				
				player:SetCharacterData("Model", model, true);
				player:SetModel(model);
			end
			
			player:SetBodygroup(bg, val)
			
			if player:Alive() then
				local ragdollEntity = player:GetRagdollEntity();
				
				if IsValid(ragdollEntity) then
					ragdollEntity:SetModel(model);
					ragdollEntity:SetBodygroup(bg, val)
				end
			end
		else
			if (bg <= player:GetNumBodyGroups()) then
				player:SetBodygroup(bg, val)

				return true
			else
				Schema:EasyText(player, "peru", "You cannot wear this!")

				return false
			end
		end
	end

	function ITEM:ResetBodygroup(player, bg)
		player:SetBodygroup(bg, 0)
		
		if self.headReplacement then
			player:SetModel(player:GetDefaultModel());
			
			if player:Alive() then
				if IsValid(ragdollEntity) then
					ragdollEntity:SetModel(player:GetDefaultModel());
					ragdollEntity:SetBodygroup(bg, 0)
				end
			end
		end
		
		return true
	end
	
	function ITEM:OnWear(player)
		if self.headReplacement then
			player:SetModel(self.headReplacement);
		else
			self:SetBodygroup(player, self.bodyGroup, self.bodyGroupVal)
		end

		if self.concealsFace == true then
			player:SetSharedVar("faceConcealed", true);
		end
	end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local clothesItem = player:GetClothesEquipped();
		local faction = player:GetFaction();
		local subfaction = player:GetSubfaction();
		local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
		local kinisgerOverrideSubfaction = player:GetSharedVar("kinisgerOverrideSubfaction");
		
		if cwPowerArmor and player:IsWearingPowerArmor() then
			Schema:EasyText(player, "peru", "You cannot wear this while in power armor!");
			return false;
		end
		
		if self:IsBroken() then
			Schema:EasyText(player, "peru", "This helmet is broken and cannot be used!");
			return false;
		end
		
		if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
			Schema:EasyText(player, "peru", "You are not the correct faction to wear this!")
			return false
		end
		
		if (table.HasValue(self.excludeSubfactions, kinisgerOverrideSubfaction or subfaction)) then
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
			if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
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

		if (self.bodyGroup != -1) or self.headReplacement then
			if (player:Alive() and !player:IsRagdolled()) then
				self:OnWear(player);
				Clockwork.equipment:EquipItem(player, self, "Helms");
				
				hook.Run("PlayerUseItem", player, self, itemEntity);
				
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

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		if Clockwork.equipment:UnequipItem(player, self) then
			local useSound = self.useSound;
			
			if (player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle()) and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
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
			
			self:ResetBodygroup(player, self.bodyGroup);
			
			return true;
		end
		
		return false;
	end
	
	function ITEM:HasPlayerEquipped(player)
		return player:GetHelmetEquipped(self);
	end
	
	-- Called when a player has unequipped the item.
	function ITEM:OnTakeFromPlayer(player)
		if (player:GetClothesEquipped() == self) then
			if self.concealsFace == true then
				player:SetSharedVar("faceConcealed", false);
			end
			
			self:ResetBodygroup(player, self.bodyGroup);
		end
	end
ITEM:Register();