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
	ITEM.requireFaith = {};
	ITEM.excludeSubfactions = {};
	ITEM.repairItem = "armor_repair_kit";
	
	-- A function to get the model name.
	function ITEM:GetModelName(player, group, modelOverride)
		local modelName = nil

		if (!player) then
			player = Clockwork.Client
		end

		local defaultModelName = Clockwork.player:GetDefaultModel(player);
		
		if modelOverride then
			defaultModelName = modelOverride;
		end
		
		-- rofl this shit is awful - DETrooper
		--[[if (group) then
			modelName = string.gsub(string.lower(Clockwork.player:GetDefaultModel(player)), "^.-/.-/", "")
		else
			modelName = string.gsub(string.lower(Clockwork.player:GetDefaultModel(player)), "^.-/.-/.-/", "")
		end]]--

		if (!string.find(defaultModelName, "male") and !string.find(defaultModelName, "female")) then
			if (group) then
				group = "group05/"
			else
				group = ""
			end

			if (SERVER) then
				if (player:GetGender() == GENDER_FEMALE) then
					return group.."female_04.mdl"
				else
					return group.."male_05.mdl"
				end
			elseif (player:GetGender() == GENDER_FEMALE) then
				return group.."female_04.mdl"
			else
				return group.."male_05.mdl"
			end
		else
			-- much better
			local male_find = string.find(defaultModelName, "/male_");
			local female_find = string.find(defaultModelName, "/female_");
			
			if male_find then
				modelName = string.sub(defaultModelName, male_find + 1, string.len(defaultModelName));
			elseif female_find then
				modelName = string.sub(defaultModelName, female_find + 1, string.len(defaultModelName));
			end
				
			return modelName
		end
	end

	-- Called when the item's client side model is needed.
	function ITEM:GetClientSideModel(modelName, genderOverride)
		local newModelName = "";
		local gender = "";
	
		if !modelName then
			newModelName = self:GetModelName();
		else
			if (!string.find(modelName, "male") and !string.find(modelName, "female")) then
				if (group) then
					group = "group05/"
				else
					group = ""
				end
				
				if genderOverride then
					gender = genderOverride;
				elseif IsValid(player) then
					if (player:GetGender() == GENDER_FEMALE) then
						newModelName = group.."female_04.mdl";
					else
						newModelName = group.."male_05.mdl";
					end
				else
					newModelName = group.."male_05.mdl";
				end
			else
				local male_find = string.find(modelName, "/male_");
				local female_find = string.find(modelName, "/female_");
				
				if male_find then
					newModelName = string.sub(modelName, male_find + 1, string.len(modelName));
				elseif female_find then
					newModelName = string.sub(modelName, female_find + 1, string.len(modelName));
				end
			end
		end
		
		local replacement = nil

		if (self.GetReplacement) then
			replacement = self:GetReplacement(Clockwork.Client)
		end

		if (isstring(replacement)) then
			return replacement
		elseif (self.replacement) then
			return self.replacement
		elseif (self.group) then
			return "models/begotten/"..self.group.."/"..newModelName;
		end
	end

	-- Called when a player changes clothes.
	function ITEM:OnChangeClothes(player, bIsWearing)
		if (bIsWearing) then
			local replacement = nil

			if (self.GetReplacement) then
				replacement = self:GetReplacement(player)
			end

			if (isstring(replacement)) then
				player:SetModel(replacement)
			elseif (self.replacement) then
				player:SetModel(self.replacement)
			elseif (self.group) then
				player:SetModel("models/begotten/"..self.group.."/"..self:GetModelName(player))
			end
		else
			Clockwork.player:SetDefaultModel(player)
			Clockwork.player:SetDefaultSkin(player)
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
		if (CLIENT) then
			return Clockwork.player:IsWearingItem(self)
		else
			return player:IsWearingItem(self)
		end
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData, bSkipProgressBar)
		if self:HasPlayerEquipped(player) then
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
				player:RemoveClothes()
				
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

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player:IsWearingItem(self)) then
			Schema:EasyText(player, "peru", "You cannot drop an item you're currently wearing.")
			return false
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity, bSkipProgressBar)
		local action = Clockwork.player:GetAction(player);
		local faction = player:GetFaction();
		local subfaction = player:GetSubfaction();
		local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
		local kinisgerOverrideSubfaction = player:GetSharedVar("kinisgerOverrideSubfaction");
		
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
	
		if (self.whitelist and !table.HasValue(self.whitelist, player:GetFaction())) then
			Schema:EasyText(player, "peru", "Your faction cannot wear this.")
			return false
		end
		
		if self.hasHelmet then
			local helmetData = player:GetCharacterData("helmet");
			
			if helmetData and helmetData.uniqueID and helmetData.itemID then
				Schema:EasyText(player, "peru", "You cannot wear this, as this set of armor has a helmet and you already have a helmet equipped!")
				return false
			end
		end

		if (player:Alive() and !player:IsRagdolled()) then
			local clothesItem = player:GetClothesItem();
			
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
				
					if player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle() then
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
					
					player:SetClothesData(self);
					
					-- jank shit for clientside footsteps
					player:SetSharedVar("clothesString", self.uniqueID);
				
					hook.Run("PlayerUseItem", player, self, itemEntity);
					
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