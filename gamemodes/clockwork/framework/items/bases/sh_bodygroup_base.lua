--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local head_suffixes = {"_glaze", "_gore", "_satanist", "_wanderer", "_hill", "_preludegore", "_kinggore"};

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Bodygroup Base"
	ITEM.model = "models/tnb/items/shirt_citizen1.mdl"
	ITEM.skin = 1
	ITEM.weight = 1
	ITEM.useText = "Wear"
	ITEM.category = "Clothing"
	ITEM.description = "Default Bodygroup Clothing Item."
	ITEM.bodyGroup = -1
	ITEM.bodyGroupVal = -1
	ITEM.repairItem = "armor_repair_kit";
	ITEM.slots = {"Helms"};
	ITEM.equipmentSaveString = "helmet";

	function ITEM:SetBodygroup(player, bg, val)
		if val ~= 0 and self.headSuffix then
			local model = player:GetDefaultModel();
			
			if model and string.find(model, "models/begotten/heads") then
				for i, v in ipairs(head_suffixes) do
					if v ~= self.headSuffix then
						model = string.gsub(model, v, self.headSuffix);
					end
				end
				
				if model ~= player:GetDefaultModel() then
					player:SetCharacterData("Model", model, true);
				end
				
				if model ~= player:GetModel() then
					player:SetModel(model);
				end
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
		player:SetBodygroup(bg or 0, 0)
		
		if player:Alive() then
			local ragdollEntity = player:GetRagdollEntity();
			
			if IsValid(ragdollEntity) then
				ragdollEntity:SetBodygroup(bg or 0, 0)
			end
		end
		
		if self.headReplacement then
			local model = player:GetDefaultModel();
			
			player:SetModel(model);
			
			if player:Alive() then
				local ragdollEntity = player:GetRagdollEntity();
				
				if IsValid(ragdollEntity) then
					ragdollEntity:SetModel(model);
				end
			end
		end
		
		return true
	end
	
	function ITEM:OnWear(player)
		if self.headReplacement then
			player:SetBodygroup(0, 0);
			player:SetBodygroup(1, 0);
			player:SetModel(self.headReplacement);
			
			if player:Alive() then
				local ragdollEntity = player:GetRagdollEntity();
				
				if IsValid(ragdollEntity) then
					ragdollEntity:SetBodygroup(0, 0)
					ragdollEntity:SetBodygroup(1, 0)
					ragdollEntity:SetModel(self.headReplacement);
				end
			end
		else
			self:SetBodygroup(player, self.bodyGroup, self.bodyGroupVal)
		end

		if self.concealsFace == true then
			player:SetNetVar("faceConcealed", true);
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
		
		local clothesItem = player:GetClothesEquipped();
		local helmetItem = player:GetHelmetEquipped();
		
		if !Clockwork.player:HasFlags(player, "S") then
			local faction = player:GetFaction();
			local subfaction = player:GetSubfaction();
			local kinisgerOverride = player:GetNetVar("kinisgerOverride");
			local kinisgerOverrideSubfaction = player:GetNetVar("kinisgerOverrideSubfaction");
			
			if cwPowerArmor and player:IsWearingPowerArmor() then
				Schema:EasyText(player, "peru", "You cannot wear this while in power armor!");
				return false;
			end
			
			if self:IsBroken() then
				Schema:EasyText(player, "peru", "This helmet is broken and cannot be used!");
				return false;
			end
			
			if self.excludedFactions and #self.excludedFactions > 0 then
				if (table.HasValue(self.excludedFactions, kinisgerOverride or faction)) then
					if !self.includedSubfactions or #self.includedSubfactions < 1 or !table.HasValue(self.includedSubfactions, kinisgerOverrideSubfaction or subfaction) then
						if !player.spawning then
							Schema:EasyText(player, "chocolate", "You are not the correct faction to equip this helmet!")
						end
						
						return false
					end
				end
			end
			
			if self.excludedSubfactions and #self.excludedSubfactions > 0 then
				if (table.HasValue(self.excludedSubfactions, kinisgerOverrideSubfaction or subfaction)) then
					if !player.spawning then
						Schema:EasyText(player, "chocolate", "You are not the correct subfaction to equip this helmet!")
					end
					
					return false
				end
			end
			
			if self.requiredFaiths and #self.requiredFaiths > 0 then
				if (!table.HasValue(self.requiredFaiths, player:GetFaith())) then
					if !self.kinisgerOverride or self.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
						if !player.spawning then
							Schema:EasyText(player, "chocolate", "You are not the correct faith to equip this helmet!")
						end
						
						return false
					end
				end
			end
			
			if self.requiredSubfaiths and #self.requiredSubfaiths > 0 then
				if (!table.HasValue(self.requiredSubfaiths, player:GetSubfaith())) then
					if !self.kinisgerOverride or self.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
						if !player.spawning then
							Schema:EasyText(player, "chocolate", "You are not the correct subfaith to equip this helmet!")
						end
						
						return false
					end
				end
			end
			
			if self.requiredFactions and #self.requiredFactions > 0 then
				if (!table.HasValue(self.requiredFactions, faction) and (!kinisgerOverride or !table.HasValue(self.requiredFactions, kinisgerOverride))) then
					if !player.spawning then
						Schema:EasyText(player, "chocolate", "You are not the correct faction to equip this helmet!")
					end
					
					return false
				end
			end
			
			if self.requiredSubfactions and #self.requiredSubfactions > 0 then
				if (!table.HasValue(self.requiredSubfactions, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requiredSubfactions, kinisgerOverrideSubfaction))) then
					if !player.spawning then
						Schema:EasyText(player, "peru", "You are not the correct subfaction to equip this helmet!")
					end
					
					return false
				end
			end
			
			if self.requiredRanks and #self.requiredRanks > 0 then
				local rank = player:GetCharacterData("rank", 1);
				
				if Schema.Ranks[faction] then
					local rankString = Schema.Ranks[faction][rank];
					
					if rankString then
						if (!table.HasValue(self.requiredRanks, rankString)) then
							if !player.spawning then
								Schema:EasyText(player, "peru", "You are not the correct rank to wear this!")
							
								return false;
							end
						end
					end
				end
			end
		end
		
		if clothesItem then
			if clothesItem.hasHelmet then
				Schema:EasyText(player, "peru", "You cannot wear this helmet, as your equipped armor already has one!")
				return false
			end
		end
		
		if helmetItem then
			if helmetItem.attributes and table.HasValue(helmetItem.attributes, "not_unequippable") then
				if !self.attributes or !table.HasValue(self.attributes, "not_unequippable") then
					Schema:EasyText(player, "peru", "You cannot wear this, as your current helmet is grafted into your skin and fused with your flesh, and cannot be unequipped!");
					return false;
				end
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
		if self.permanent then
			Schema:EasyText(player, "peru", "This helmet is grafted into your skin and fused with your flesh, and cannot be unequipped!");
			return false;
		end
	
		if Clockwork.equipment:UnequipItem(player, self) then
			if extraData == "drop" then
				local trace = player:GetEyeTraceNoCursor()

				if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
					if hook.Run("PlayerCanDropItem", player, self, trace.HitPos) then
						local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
						
						if (IsValid(entity)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
							player:TakeItem(self);
						end
					end
				else
					Clockwork.player:Notify(player, "You cannot drop the item that far away!");
				end
			end
		
			local useSound = self.useSound;
			
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
			
			if self.concealsFace == true then
				player:SetNetVar("faceConcealed", false);
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
		if (player:GetHelmetEquipped() == self) then
			if player:Alive() and self.permanent then
				Schema:EasyText(player, "peru", "This helmet is grafted into this character's skin and fused with their flesh, and cannot be unequipped!");
				return false;
			end
		
			if self.concealsFace == true then
				player:SetNetVar("faceConcealed", false);
			end
			
			self:ResetBodygroup(player, self.bodyGroup);
		end
	end
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player:GetHelmetEquipped() == self) then
			if self.permanent then
				Schema:EasyText(player, "peru", "This helmet is grafted into your skin and fused with your flesh, and cannot be unequipped!");
				return false;
			end
		end
	end
ITEM:Register();