--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Clothes Base"
	ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl"
	ITEM.weight = 2
	ITEM.useText = "Wear"
	ITEM.category = "Clothing"
	ITEM.description = "A suitcase full of clothes."
	--ITEM.equippable = false; -- this blocks equipping the item as a melee weapon.
	ITEM.excludeFactions = {};
	ITEM.requireFaction = {};
	ITEM.requireSubfaction = {};
	ITEM.requireRank = {};
	ITEM.requireFaith = {};
	ITEM.excludeSubfactions = {};
	ITEM.repairItem = "armor_repair_kit";
	ITEM.slots = {"Armor"};
	ITEM.equipmentSaveString = "clothes";

	-- Called when the item's client side model is needed.
	function ITEM:GetClientSideModel(modelName, genderOverride)
		local replacement = nil

		if (self.GetReplacement) then
			replacement = self:GetReplacement(Clockwork.Client)
		end

		if (isstring(replacement)) then
			return replacement
		elseif (self.replacement) then
			return self.replacement
		end
	end
	
	function ITEM:OnWear(player)
		local replacement = nil

		if (self.GetReplacement) then
			replacement = self:GetReplacement(player)
		end

		if (isstring(replacement)) then
			player:SetModel(replacement)
		elseif (self.replacement) then
			player:SetModel(self.replacement)
		elseif (self.group) then
			local helmetItem = player:GetHelmetEquipped();
			
			if !helmetItem or !helmetItem.headReplacement then
				Clockwork.player:SetDefaultModel(player);
			end
		
			if player:IsRagdolled() then
				local ragdollEntity = player:GetRagdollEntity();
				
				if IsValid(ragdollEntity) and player:Alive() then
					local model;
					
					if self.genderless then
						model = "models/begotten/"..self.group..".mdl";
					else
						model = "models/begotten/"..self.group.."_"..string.lower(player:GetGender())..".mdl";
					end
					
					ragdollEntity:SetNW2String("clothes", model);
				end
			end
		end
		
		if self.concealsFace == true then
			if bIsWearing then
				player:SetNetVar("faceConcealed", true);
			else
				player:SetNetVar("faceConcealed", false);
			end
		end
		
		if self.attributes and table.HasValue(self.attributes, "solblessed") then
			if !player:GetCharacterData("Hatred") then
				player:SetCharacterData("Hatred", 0);
				player:SetLocalVar("Hatred", 0);
			end
		elseif player:GetCharacterData("Hatred") then
			player:SetCharacterData("Hatred", nil);
			player:SetLocalVar("Hatred", nil);
		end
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData, bSkipProgressBar)
		if self.permanent then
			Schema:EasyText(player, "peru", "This armor is grafted into your skin and fused with your flesh, and cannot be unequipped!");
			return false;
		end
	
		if !player:Alive() then
			bSkipProgressBar = true;
		end
	
		if extraData == "drop" then
			local trace = player:GetEyeTraceNoCursor()

			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				if !hook.Run("PlayerCanDropItem", player, self, trace.HitPos) then
					return false;
				end
			else
				Clockwork.player:Notify(player, "You cannot drop the item that far away!");
			end
		end
		
		if Clockwork.equipment:UnequipItem(player, self, nil, !bSkipProgressBar) then
			local action = Clockwork.player:GetAction(player);
			
			if action == "putting_on_armor" or action == "taking_off_armor" then
				Schema:EasyText(player, "peru", "You cannot take this armor off while already putting on or taking off armor!");
				return false;
			end
		
			if !bSkipProgressBar then
				local itemTable = self;
				local weightNum = 1;
				
				if self.weightclass == "Medium" then
					weightNum = 2;
				elseif self.weightclass == "Heavy" then
					weightNum = 3;
				end
				
				local actionTime = weightNum * 5;
				
				if cwBeliefs and player:HasBelief("dexterity") then
					actionTime = math.Round(actionTime * 0.66);
				end
				
				Clockwork.player:SetAction(player, "taking_off_armor", actionTime, 1, function()
					if IsValid(player) and itemTable then
						if self:HasPlayerEquipped(player) then
							self:OnPlayerUnequipped(player, extraData, true);
						end
					end
				end);
			else
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
				
				local helmetItem = player:GetHelmetEquipped();
				
				if !helmetItem or !helmetItem.headReplacement then
					Clockwork.player:SetDefaultModel(player);
				end
				
				Clockwork.player:SetDefaultSkin(player);
				hook.Run("PlayerSetHandsModel", player, player:GetHands());
				player:RebuildInventory();
				
				if player:IsRagdolled() then
					local ragdollEntity = player:GetRagdollEntity();
					
					if IsValid(ragdollEntity) and player:Alive() then
						if !helmetItem or !helmetItem.headReplacement then
							ragdollEntity:SetModel(Clockwork.player:GetDefaultModel(player));
							ragdollEntity:SetSkin(Clockwork.player:GetDefaultSkin(player));
						end

						local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
						local factionTable = Clockwork.faction:FindByID(faction);
						local model = player:GetModel();
						
						if factionTable then
							local subfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
							
							if subfaction and factionTable.subfactions then
								for i, v in ipairs(factionTable.subfactions) do
									if v.name == subfaction and v.models then
										model = v.models[string.lower(player:GetGender())].clothes;
									
										break;
									end
								end
							end
							
							if string.find(model, "models/begotten/heads") then
								model = factionTable.models[string.lower(player:GetGender())].clothes;
							end
						end

						ragdollEntity:SetNW2String("clothes", model);
					end
				end
				
				if player:GetCharacterData("Hatred") then
					player:SetCharacterData("Hatred", nil);
					player:SetLocalVar("Hatred", nil);
				end
			end
			
			return true;
		end
		
		return false;
	end
	
	function ITEM:HasPlayerEquipped(player)
		return player:GetClothesEquipped(self);
	end
	
	-- Called when a player has unequipped the item.
	function ITEM:OnTakeFromPlayer(player)
		if (player:GetClothesEquipped() == self) then
			if player:Alive() and self.permanent then
				Schema:EasyText(player, "peru", "This armor is grafted into this character's skin and fused with their flesh, and cannot be unequipped!");
				return false;
			end
		
			if self.concealsFace == true then
				player:SetNetVar("faceConcealed", false);
			end
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player:GetClothesEquipped() == self) then
			if self.permanent then
				Schema:EasyText(player, "peru", "This armor is grafted into your skin and fused with your flesh, and cannot be unequipped!");
				return false;
			end
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity, bSkipProgressBar)
		local action = Clockwork.player:GetAction(player);
		local faction = player:GetFaction();
		local subfaction = player:GetSubfaction();
		local kinisgerOverride = player:GetNetVar("kinisgerOverride");
		local kinisgerOverrideSubfaction = player:GetNetVar("kinisgerOverrideSubfaction");
		
		if action == "putting_on_armor" or action == "taking_off_armor" then
			Schema:EasyText(player, "peru", "You cannot wear this while already putting on or taking off armor!");
			return false;
		end
	
		if cwPowerArmor and player:IsWearingPowerArmor() then
			Schema:EasyText(player, "peru", "You cannot wear this while in power armor!");
			return false;
		end
	
		if self:IsBroken() then
			Schema:EasyText(player, "peru", "This set of armor is broken and cannot be used!");
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
		
		if #self.requireSubfaction > 0 then
			if (!table.HasValue(self.requireSubfaction, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requireSubfaction, kinisgerOverrideSubfaction))) then
				Schema:EasyText(player, "peru", "You are not the correct subfaction to wear this!")
				
				return false
			end
		end
		
		if #self.requireRank > 0 then
			local rank = player:GetCharacterData("rank", 1);
			
			if Schema.Ranks[faction] then
				local rankString = Schema.Ranks[faction][rank];
				
				if rankString then
					if (!table.HasValue(self.requireRank, rankString)) then
						Schema:EasyText(player, "peru", "You are not the correct rank to wear this!")
						
						return false;
					end
				end
			end
		end
	
		if (self.whitelist and !table.HasValue(self.whitelist, player:GetFaction())) then
			Schema:EasyText(player, "peru", "Your faction cannot wear this.")
			return false
		end
		
		if self.hasHelmet then
			local helmetItem = player:GetHelmetEquipped();
			
			if helmetItem then
				Schema:EasyText(player, "peru", "You cannot wear this, as this set of armor has a helmet and you already have a helmet equipped!")
				return false
			end
		end

		if (player:Alive() and !player:IsRagdolled()) then
			local clothesItem = player:GetClothesEquipped();
			
			if clothesItem then
				if clothesItem.attributes and table.HasValue(clothesItem.attributes, "not_unequippable") then
					if !self.attributes or !table.HasValue(self.attributes, "not_unequippable") then
						Schema:EasyText(player, "peru", "You cannot wear this, as your current armor is grafted into your skin and fused with your flesh, and cannot be unequipped!")
						return false;
					end
				end
			end
			
			if (!self.CanPlayerWear or self:CanPlayerWear(player, itemEntity) != false) then
				if itemEntity then
					if (Clockwork.entity:BelongsToAnotherCharacter(player, itemEntity)) then
						Schema:EasyText(player, "peru", "You cannot pick up items you've dropped on another character!");
						
						return false;
					end
				end

				if !bSkipProgressBar then
					local weightNum = 1;
					
					if self.weightclass == "Medium" then
						weightNum = 2;
					elseif self.weightclass == "Heavy" then
						weightNum = 3;
					end
					
					local actionTime = weightNum * 5;
					
					if cwBeliefs and player:HasBelief("dexterity") then
						actionTime = math.Round(actionTime * 0.66);
					end
					
					Clockwork.player:SetAction(player, "putting_on_armor", actionTime, 1, function()
						if IsValid(player) and self then
							if !itemEntity or itemEntity and IsValid(itemEntity) then
								if !self:HasPlayerEquipped(player) then
									self:OnUse(player, itemEntity, true);
								end
							else
								Schema:EasyText(player, "peru", "The item you are attempting to put on is no longer valid!");
							end
						end
					end);
					
					return false;
				else
					if itemEntity then
						player:SetItemEntity(itemEntity)
						player:GiveItem(self, true)
						
						itemEntity:Remove();
						player:SetItemEntity(nil);
					--elseif !player:HasItemByID(self.itemID) then
					elseif !Clockwork.inventory:HasItemInstance(player:GetInventory(), self) then
						Schema:EasyText(player, "peru", "The item you are attempting to put on is no longer valid!");
						
						return false;
					end
				
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
					end;
					
					if clothesItem and clothesItem ~= self then
						Clockwork.equipment:UnequipItem(player, clothesItem);
					end
					
					self:OnWear(player);
					Clockwork.equipment:EquipItem(player, self, "Armor");
					
					hook.Run("PlayerUseItem", player, self, itemEntity);
					hook.Run("PlayerSetHandsModel", player, player:GetHands());
					
					return true;
				end
			end
		else
			Schema:EasyText(player, "peru", "You cannot do this action at this moment.")
		end

		return false;
	end
		
	-- Called when a player repairs the item.
	function ITEM:OnRepair(player, itemEntity)
		return true;
	end
	
	function ITEM:OnInstantiated()
		-- why is this here?
	end;
ITEM:Register();