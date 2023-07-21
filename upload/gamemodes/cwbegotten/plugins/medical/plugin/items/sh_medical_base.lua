--[[
	Begotten III: Jesus Wept
--]]

local hitgroupToString = {
	[HITGROUP_CHEST] = "chest",
	[HITGROUP_HEAD] = "head",
	[HITGROUP_STOMACH] = "stomach",
	[HITGROUP_LEFTARM] = "left arm",
	[HITGROUP_RIGHTARM] = "right arm",
	[HITGROUP_LEFTLEG] = "left leg",
	[HITGROUP_RIGHTLEG] = "right leg",
	[HITGROUP_GENERIC] = "generic",
}

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Medical Base"
	ITEM.uniqueID = "medical_base";
	ITEM.description = "Medical Base"
	ITEM.model = "models/Items/HealthKit.mdl";
	ITEM.category = "Medical"
	ITEM.business = true;
	ITEM.weight = 1;
	ITEM.customFunctions = {"Give"};
	
	ITEM.applicable = nil;
	ITEM.isMedical = true;
	ITEM.limbs = {};
	ITEM.ingestible = nil;
	ITEM.stackable = true;
	ITEM.useOnSelf = true; -- Can use on self.

	ITEM.canSave = false; -- Can save people in critical condition.
	ITEM.healAmount = nil; -- Amount of HP healed per repetition.
	ITEM.healDelay = nil; -- Delay between repetitions.
	ITEM.healRepetition = nil; -- # of repetitions.
	ITEM.morphine = false; -- Has morphine effects.
	ITEM.stopsBleeding = false; -- Stops bleeding.
	ITEM.isSurgeryItem = false; -- Is it a surgery item?
	
	ITEM.customFunctions = {};
	
	-- Called when a player uses the item.
	function ITEM:OnUseCustom(player, itemEntity, hitGroup)
		if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false and self.useOnSelf ~= false then
			local action = Clockwork.player:GetAction(player);
				
			if (action == "heal") then
				Schema:EasyText(player, "peru","Your character is already healing!");
				
				return false;
			elseif (action == "healing") then
				Schema:EasyText(player, "peru", "You are already healing somebody!");
				
				return false;
			elseif (action == "performing_surgery") then
				Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
				
				return false;
			else
				Clockwork.player:SetMenuOpen(player, false);
				
				cwMedicalSystem:PlayerUseMedical(player, self, hitGroup);
				--Clockwork.plugin:Call("PlayerUseMedical", player, self, hitGroup);
				
				player:TakeItem(self);
			end;
		end;
	end;
	
	-- Called when a player uses the item.
	function ITEM:OnUseTarget(player, target, itemEntity, hitGroup)
		if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false then
			local action = Clockwork.player:GetAction(player);
				
			if (action == "heal") then
				Schema:EasyText(player, "peru","Your character is already healing!");
				
				return false;
			elseif (action == "healing") then
				Schema:EasyText(player, "peru", "You are already healing somebody!");
				
				return false;
			elseif (action == "performing_surgery") then
				Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
				
				return false;
			else
				Clockwork.player:SetMenuOpen(player, false);
				
				if !self.isSurgeryItem then
					cwMedicalSystem:HealPlayer(player, target, self, hitGroup);
					--Clockwork.plugin:Call("HealPlayer", player, target, self, hitGroup);
					
					player:TakeItem(self);
				else
					cwMedicalSystem:PerformSurgeryOnPlayer(player, target, self, hitGroup);
				end
			end;
		end;
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		local action = Clockwork.player:GetAction(player);
			
		if (action == "heal") then
			Schema:EasyText(player, "firebrick", "You cannot drop this while healing!");
			
			return false;
		elseif (action == "healing") then
			Schema:EasyText(player, "firebrick", "You cannot drop this while healing somebody!");
			
			return false;
		elseif (action == "performing_surgery") then
			Schema:EasyText(player, "firebrick", "You cannot drop this while performing surgery on someone!");
			
			return false;
		end;
	end;
	
	--[[function ITEM:OnInstantiated()
		if table.IsEmpty(self.customFunctions) then
			if self.ingestible then
				for k, v in pairs(self.ingestible) do
					local functionName = string.gsub("ingest_"..hitgroupToString[k], " ", "_");
					
					table.insert(self.customFunctions, functionName);
				end;
			elseif self.applicable then
				if self.limbs == "all" then
					table.insert(self.customFunctions, "apply_all");
					table.insert(self.customFunctions, "give_all");
				else
					for i = 1, #self.limbs do
						local limb = self.limbs[i];
						local functionName = string.gsub("apply_"..hitgroupToString[limb], " ", "_");
							
						table.insert(self.customFunctions, functionName);
						
						functionName = string.gsub("give_"..hitgroupToString[limb], " ", "_");
						
						table.insert(self.customFunctions, functionName);
					end;
				end
			end;
		end;
	end;]]--

	--[[if (SERVER) then
		function ITEM:OnCustomFunction(player, name)

		end;
	end;]]--
ITEM:Register();