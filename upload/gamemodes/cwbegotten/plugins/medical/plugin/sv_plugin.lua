--[[
	Begotten III: Jesus Wept
--]]

local playerMeta = FindMetaTable("Player");

-- A function to get whether a number is a hitgroup enum or if a string is a hitgroup.
function cwMedicalSystem:IsHitGroup(hitGroup)
	if isnumber(hitGroup) then
		return tobool(self.cwDefaultLimbs[hitGroup]);
	elseif isstring(hitGroup) then
		return tobool(self.cwStringToHitGroup[hitGroup]);
	end
end;

cwMedicalSystem.bloodLossPerLimb = 20;
cwMedicalSystem.lethalBloodLoss = 2500; -- Blood level required for critical condition.
cwMedicalSystem.maxBloodLevel = 5000; -- Maximum blood level.
cwMedicalSystem.bloodPassiveRegen = 5;

BLOODTYPE_O_NEGATIVE = 0;
BLOODTYPE_O_POSITIVE = 1;
BLOODTYPE_A_NEGATIVE = 2;
BLOODTYPE_A_POSITIVE = 3;
BLOODTYPE_B_NEGATIVE = 4;
BLOODTYPE_B_POSITIVE = 5;
BLOODTYPE_AB_NEGATIVE = 6;
BLOODTYPE_AB_POSITIVE = 7;

cwMedicalSystem.bloodTypes = {
	[BLOODTYPE_O_NEGATIVE] = {[BLOODTYPE_O_NEGATIVE] = true},
	[BLOODTYPE_O_POSITIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_O_POSITIVE] = true},
	[BLOODTYPE_A_NEGATIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_A_NEGATIVE] = true},
	[BLOODTYPE_A_POSITIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_O_POSITIVE] = true, [BLOODTYPE_A_NEGATIVE] = true, [BLOODTYPE_A_POSITIVE] = true},
	[BLOODTYPE_B_NEGATIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_B_NEGATIVE] = true},
	[BLOODTYPE_B_POSITIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_O_POSITIVE] = true, [BLOODTYPE_B_NEGATIVE] = true, [BLOODTYPE_B_POSITIVE] = true},
	[BLOODTYPE_AB_NEGATIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_A_NEGATIVE] = true, [BLOODTYPE_B_NEGATIVE] = true, [BLOODTYPE_AB_NEGATIVE] = true},
	[BLOODTYPE_AB_POSITIVE] = {[BLOODTYPE_O_NEGATIVE] = true, [BLOODTYPE_O_POSITIVE] = true, [BLOODTYPE_A_NEGATIVE] = true, [BLOODTYPE_A_POSITIVE] = true, [BLOODTYPE_B_NEGATIVE] = true, [BLOODTYPE_B_POSITIVE] = true, [BLOODTYPE_AB_NEGATIVE] = true, [BLOODTYPE_AB_POSITIVE] = true},
};

cwMedicalSystem.cwHitGroupToString = {
	[HITGROUP_CHEST] = "chest",
	[HITGROUP_HEAD] = "head",
	[HITGROUP_STOMACH] = "stomach",
	[HITGROUP_LEFTARM] = "left arm",
	[HITGROUP_RIGHTARM] = "right arm",
	[HITGROUP_LEFTLEG] = "left leg",
	[HITGROUP_RIGHTLEG] = "right leg",
	[HITGROUP_GENERIC] = "generic",
};

cwMedicalSystem.cwStringToHitGroup = {
	["chest"] = HITGROUP_CHEST,
	["head"] = HITGROUP_HEAD,
	["stomach"] = HITGROUP_STOMACH,
	["left arm"] = HITGROUP_LEFTARM,
	["right arm"] = HITGROUP_RIGHTARM,
	["left leg"] = HITGROUP_LEFTLEG,
	["right leg"] = HITGROUP_RIGHTLEG,
	["generic"] = HITGROUP_GENERIC,
};

cwMedicalSystem.cwDefaultLimbs = {
	[HITGROUP_CHEST] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GENERIC] = true,
};

-- A function to compare two bloodtypes to see if they are compatible.
function cwMedicalSystem:IsBloodCompatible(typeA, typeB)
	if (!typeA or !typeB) then
		return;
	end;
	
	if (self.bloodTypes[typeA] and self.bloodTypes[typeA][typeB]) then
		return true;
	end;
	
	return false;
end;

-- A function to translate a hitgroup enum to a string.
function cwMedicalSystem:HitgroupToString(hitGroup)
	if (isnumber(hitGroup) and self.cwDefaultLimbs[hitGroup]) then
		return self.cwHitGroupToString[hitGroup];
	elseif (self.cwStringToHitGroup[hitgroup]) then
		return hitGroup;
	end;
end;

-- A function to translate a string to a hitgroup enum.
function cwMedicalSystem:StringToHitGroup(str)
	if (isstring(hitGroup)) then
		return self.cwStringToHitGroup(str);
	elseif (self.cwDefaultLimbs[hitGroup]) then
		return hitGroup;
	end;
end;

-- Called when a player uses a medical item.
function cwMedicalSystem:PlayerUseMedical(player, itemTable, hitGroup)
	if (!IsValid(player) or !itemTable or !player:Alive()) then
		return;
	end;

	local action = Clockwork.player:GetAction(player);
	
	if (action != "heal" and action != "healing" and action != "performing_surgery") then
		local consumeTime = itemTable.useTime or 7;
		
		if player:HasBelief("dexterity") then
			consumeTime = (itemTable.useTime or 7) * 0.67;
		end
			
		Clockwork.player:SetAction(player, "heal", consumeTime, nil, function()
			if !IsValid(player) then
				return;
			end
		
			if (itemTable("morphine")) then
				Clockwork.datastream:Start(player, "Stunned", 1);
				Clockwork.datastream:Start(player, "MorphineDream", 60);
				
				player:HandleSanity(10);
			end;
			
			if (itemTable("stopsBleeding") and player.bleeding) then
				if itemTable.limbs and istable(itemTable.limbs) and #itemTable.limbs > 0 and hitGroup then
					if player:GetCharacterData("BleedingLimbs", {})[self:HitgroupToString(hitGroup)] and table.HasValue(itemTable.limbs, hitGroup) then
						player:MakeLimbStopBleeding(hitGroup);
						Clockwork.hint:Send(player, "Your "..self.cwHitGroupToString[hitGroup].." stops bleeding...", 5, Color(100, 175, 100), true, true);
					end
				elseif hitGroup == "all" or !itemTable.limbs then
					player:StopAllBleeding();
					Clockwork.hint:Send(player, "All of your bleeding has stopped...", 5, Color(100, 175, 100), true, true);
				end
			end;
			
			if (itemTable.OnUsed) then
				itemTable:OnUsed(player, itemTable);
			end;
			
			if itemTable.curesInjuries then
				if hitGroup == "all" then
					for i = 1, #itemTable.curesInjuries do
						local injury = itemTable.curesInjuries[i];
						local injuries = self:GetInjuries(player);
						
						for k, v in pairs(injuries) do							
							if v[injury] then
								local infectionChance = itemTable.infectionChance;
								
								player:RemoveInjury(k, injury);
								
								if infectionChance then
									if cwBeliefs and player:HasBelief("sanitary") then
										infectionChance = infectionChance / 2;
									end
									
									if math.random(1, 100) <= infectionChance then
										if itemTable.infectionChance > 40 then
											player:AddInjury(k, "infection");
										else
											player:AddInjury(k, "minor_infection");
										end
									end
								end
							end
						end
					end
				else
					for i = 1, #itemTable.curesInjuries do
						local injury = itemTable.curesInjuries[i];
						local injuries = self:GetInjuries(player);
						
						for k, v in pairs(injuries) do
							if k == hitGroup and v[injury] then
								local infectionChance = itemTable.infectionChance;
								
								player:RemoveInjury(k, injury);
								
								if infectionChance then
									if cwBeliefs and player:HasBelief("sanitary") then
										infectionChance = infectionChance / 2;
									end
									
									if math.random(1, 100) <= infectionChance then
										if itemTable.infectionChance > 40 then
											player:AddInjury(k, "infection");
										else
											player:AddInjury(k, "minor_infection");
										end
									end
								end
								
								break;
							end
						end
					end
				end
			end
			
			if itemTable.useSound and (player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle()) and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				player:EmitSound(itemTable.useSound);
			end

			if (itemTable("healAmount") and itemTable("healDelay") and itemTable("healRepetition")) then
				local playerIndex = player:EntIndex();
				local playerMaxHealth = player:GetMaxHealth();
				local healAmount = itemTable("healAmount");
				local healDelay = itemTable("healDelay");
				local healRepetition = itemTable("healRepetition");
				local timesHealed = 0;
				
				if cwBeliefs and player:HasBelief("medicine_man") then
					healAmount = healAmount * 3;
				end
				
				timer.Create(playerIndex.."_heal", healDelay, healRepetition, function()
					if (IsValid(player)) then
						local healAmount = math.Clamp(player:Health() + healAmount, 0, playerMaxHealth);

						player:SetHealth(healAmount);
						
						if hitGroup == "all" then
							local limbData = player:GetCharacterData("LimbData")

							if (limbData) then
								local newHealth = player:Health();
								
								for k, v in pairs(limbData) do
									local limbHealth = Clockwork.limb:GetHealth(player, k);
									
									if limbHealth < newHealth then
										Clockwork.limb:HealDamage(player, k, healAmount);
									end
								end
							end
						else
							Clockwork.limb:HealDamage(player, hitGroup, healAmount);
						end
					
						timesHealed = timesHealed + 1;
						
						if (timesHealed >= healRepetition) then
							timer.Destroy(playerIndex.."_heal");
							
							Clockwork.hint:Send(player, itemTable("name").." has worn off...", 5, Color(100, 175, 100), true, true);
							hook.Run("PlayerHealed", player, itemTable);
						end;
					else
						timer.Destroy(playerIndex.."_heal");
					end;
				end);
			end;
			
			if (itemTable("restoresBlood")) then
				player:ModifyBloodLevel(itemTable("restoresBlood"));
			end
		
			if cwBeliefs then
				player:HandleXP(itemTable.useXP or 5);
			end

			return true;
		end);
	else
		Schema:EasyText(player, "peru", "You are already healing!");
		
		return false;
	end;
end;

-- Called when a player attempts to heal a target.
function cwMedicalSystem:HealPlayer(player, target, itemTable, hitGroup)
	if (!IsValid(player) or !IsValid(target) or !itemTable or !player:Alive() or !target:Alive()) then
		return;
	end;
	
	local actionPlayer = Clockwork.player:GetAction(player);
	local actionTarget = Clockwork.player:GetAction(target);
	local consumeTime = itemTable.useTime or 7;
	
	if player:HasBelief("dexterity") then
		consumeTime = (itemTable.useTime or 7) * 0.67;
	end
	
	if (actionPlayer != "heal" and actionPlayer != "healing" and actionPlayer != "performing_surgery") then
		if (actionTarget != "heal" and actionTarget != "healing" and actionTarget != "performing_surgery") then
			Clockwork.player:SetAction(player, "healing", consumeTime, nil, function()
				if !IsValid(player) or !IsValid(target) then
					return;
				end
				
				if (itemTable("stopsBleeding") and target.bleeding) then
					if itemTable.limbs and istable(itemTable.limbs) and #itemTable.limbs > 0 and hitGroup then
						if target:GetCharacterData("BleedingLimbs", {})[self:HitgroupToString(hitGroup)] and table.HasValue(itemTable.limbs, hitGroup) then
							target:MakeLimbStopBleeding(hitGroup);
							Clockwork.hint:Send(target, "Your "..self.cwHitGroupToString[hitGroup].." stops bleeding...", 5, Color(100, 175, 100), true, true);
						end
					elseif hitGroup == "all" or !itemTable.limbs then
						target:StopAllBleeding();
						Clockwork.hint:Send(target, "All of your bleeding has stopped...", 5, Color(100, 175, 100), true, true);
					end
				end;
				
				if (itemTable.OnUsed) then
					itemTable:OnUsed(target, itemTable);
				end;
				
				if itemTable.curesInjuries then
					if hitGroup == "all" then
						for i = 1, #itemTable.curesInjuries do
							local injury = itemTable.curesInjuries[i];
							local injuries = self:GetInjuries(target);
							
							for k, v in pairs(injuries) do							
								if v[injury] then
									local infectionChance = itemTable.infectionChance;
									
									target:RemoveInjury(k, injury);
									
									if infectionChance then
										if cwBeliefs and (player:HasBelief("sanitary") or target:HasBelief("sanitary")) then
											infectionChance = infectionChance / 2;
										end
										
										if math.random(1, 100) <= infectionChance then
											if itemTable.infectionChance > 40 then
												target:AddInjury(k, "infection");
											else
												target:AddInjury(k, "minor_infection");
											end
										end
									end
								end
							end
						end
					else
						for i = 1, #itemTable.curesInjuries do
							local injury = itemTable.curesInjuries[i];
							local injuries = self:GetInjuries(target);
							
							for k, v in pairs(injuries) do
								if k == hitGroup and v[injury] then
									local infectionChance = itemTable.infectionChance;
									
									target:RemoveInjury(k, injury);
									
									if infectionChance then
										if cwBeliefs and (player:HasBelief("sanitary") or target:HasBelief("sanitary")) then
											infectionChance = infectionChance / 2;
										end
										
										if math.random(1, 100) <= infectionChance then
											if itemTable.infectionChance > 40 then
												target:AddInjury(k, "infection");
											else
												target:AddInjury(k, "minor_infection");
											end
										end
									end
									
									break;
								end
							end
						end
					end
				end
				
				if itemTable.useSound and (target:GetMoveType() == MOVETYPE_WALK or target:IsRagdolled() or target:InVehicle()) and (!target.GetCharmEquipped or !target:GetCharmEquipped("urn_silence")) then
					target:EmitSound(itemTable.useSound);
				end
				
				player:TakeItem(itemTable, true);
				
				if itemTable.canSave then
					if (actionTarget == "die") then
						player:FakePickup(target);
						Clockwork.player:SetAction(target, "die", false);
						Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, nil, 180);
						Clockwork.player:SetAction(target, "unragdoll", 180, 1, function() end);
					elseif (actionTarget == "die_bleedout") then
						player:FakePickup(target);
						self:PickupBleedout(target);
						
						--[[target:SetCrouchedWalkSpeed(1);
						target:ConCommand("-duck");]]--
					end;
				end;
				
				if (itemTable("healAmount") and itemTable("healDelay") and itemTable("healRepetition")) then
					local targetIndex = target:EntIndex();
					local targetMaxHealth = target:GetMaxHealth();
					local healAmount = itemTable("healAmount");
					local healDelay = itemTable("healDelay");
					local healRepetition = itemTable("healRepetition");
					local timesHealed = 0;
					
					if cwBeliefs and player:HasBelief("medicine_man") then
						healAmount = healAmount * 3;
					end
					
					timer.Create(targetIndex.."_heal", healDelay, healRepetition, function()
						if (IsValid(target)) then
							local healAmount = math.Clamp(target:Health() + healAmount, 0, targetMaxHealth);

							target:SetHealth(healAmount);
							
							if hitGroup == "all" then
								local limbData = target:GetCharacterData("LimbData")

								if (limbData) then
									local newHealth = target:Health();
									
									for k, v in pairs(limbData) do
										local limbHealth = Clockwork.limb:GetHealth(target, k);
										
										if limbHealth < newHealth then
											Clockwork.limb:HealDamage(target, k, healAmount);
										end
									end
								end
							else
								Clockwork.limb:HealDamage(target, hitGroup, healAmount);
							end

							timesHealed = timesHealed + 1;
							
							if (timesHealed >= healRepetition) then
								timer.Destroy(targetIndex.."_heal");
								
								Clockwork.hint:Send(target, itemTable("name").." has worn off...", 5, Color(100, 175, 100), true, true);
								hook.Run("PlayerHealed", target, itemTable);
							end;
						else
							timer.Destroy(targetIndex.."_heal");
						end;
					end);
				end;
				
				if (itemTable("restoresBlood")) then
					target:ModifyBloodLevel(itemTable("restoresBlood"));
				end

				hook.Run("PlayerHealed", target, itemTable);
				
				if cwBeliefs then
					local healXP = itemTable.useXP or 5;
				
					if player:HasBelief("mother") then
						healXP = healXP * 2;
					end
					
					player:HandleXP(healXP);
				end
			end);
		else
			Schema:EasyText(player, "peru","This player is already healing!");
		end;
	else
		Schema:EasyText(player, "peru", "You are already healing!");
	end;
end;

-- Called when a player attempts to perform surgery on another player.
function cwMedicalSystem:PerformSurgeryOnPlayer(player, target, itemTable, hitGroup)
	if (!IsValid(player) or !IsValid(target) or !itemTable or !player:Alive() or !target:Alive()) then
		return;
	end;
	
	if !player:HasBelief("surgeon") then
		Schema:EasyText(player, "chocolate","You need the 'Surgeon' belief in order to perform surgery on a player.");
	
		return;
	end
	
	local actionPlayer = Clockwork.player:GetAction(player);
	local actionTarget = Clockwork.player:GetAction(target);
	local surgeryTime = 20;
	
	if (actionPlayer != "heal" and actionPlayer != "healing" and actionPlayer != "performing_surgery") then
		if (actionTarget != "heal" and actionTarget != "healing" and actionTarget != "performing_surgery") then
			if !target:IsRagdolled() then
				Schema:EasyText(player, "chocolate","To perform surgery on someone, they must be fallen over.");
			
				return;
			end
			
			--[[if target:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT and target:GetSharedVar("tied") == 0 then
				Schema:EasyText(player, "chocolate","To perform surgery on someone, they must be unconscious or tied up.");
			
				return;
			end]]--
			
			local injury_surgery_table;
			
			if itemTable.limbs and #itemTable.limbs > 0 and hitGroup then
				local injuries = self:GetInjuries(target);
				
				for k, v in pairs(injuries) do
					if injury_surgery_table then
						break;
					end
					
					for k2, v2 in pairs(v) do
						if v2 == true then
							local injury = self.cwInjuryTable[k2];
						
							if injury and injury.surgeryInfo then
								injury_surgery_table = injury;
								
								break;
							end
						end
					end
				end
			end
			
			if not injury_surgery_table then
				Schema:EasyText(player, "peru","This limb does not have an injury that can be operated on!");

				return;
			end
			
			if target.limbUnderSurgery and target.limbUnderSurgery ~= hitGroup then
				Schema:EasyText(player, "firebrick", "You must finish the surgery started on their "..self.cwHitGroupToString[target.limbUnderSurgery].." before starting a new operation!");

				return;
			end
			
			if !target.surgeryStage then
				target.surgeryStage = 1;
			end
			
			if target.surgeryStage > #injury_surgery_table.surgeryInfo then
				Schema:EasyText(player, "peru","This limb does not have an injury that can be operated on!");
				
				target.playerPerformingSurgery = nil;
				target.limbUnderSurgery = nil;
				target.injuryUnderSurgery = nil;
				target.surgeryStage = nil;
				
				return;
			else
				if injury_surgery_table.surgeryInfo[target.surgeryStage].tool ~= itemTable.uniqueID then
					Schema:EasyText(player, "chocolate","This is the wrong tool for this stage of the operation!");
					
					return;
				end
			end
			
			local texts = injury_surgery_table.surgeryInfo[target.surgeryStage].texts;
			
			if texts then
				local surgeryText = texts[math.random(1, #texts)];
				
				surgeryText = string.gsub(surgeryText, "NAME", target:Name());
				surgeryText = string.gsub(surgeryText, "LIMB", self.cwHitGroupToString[hitGroup]);
				
				Clockwork.chatBox:AddInTargetRadius(player, "me", surgeryText, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			end
			
			target.limbUnderSurgery = hitGroup;
			target.injuryUnderSurgery = injury_surgery_table.uniqueID;
			target.playerPerformingSurgery = player;
		
			Clockwork.player:SetAction(player, "performing_surgery", surgeryTime, nil, function()
				if !IsValid(player) or !IsValid(target) then
					return;
				end
				
				if target:IsRagdolled() then		
					--[[if itemTable.useSound and (target:GetMoveType() == MOVETYPE_WALK or target:IsRagdolled() or target:InVehicle()) and (!target.GetCharmEquipped or !target:GetCharmEquipped("urn_silence")) then
						target:EmitSound(itemTable.useSound);
					end]]--
					
					if target.surgeryStage >= #injury_surgery_table.surgeryInfo then
						local infectionChance = 35;
						
						target:RemoveInjury(hitGroup, target.injuryUnderSurgery);
						
						if cwBeliefs and (player:HasBelief("sanitary") or target:HasBelief("sanitary")) then
							infectionChance = infectionChance / 2;
						end
						
						if math.random(1, 100) <= infectionChance then
							if math.random(1, 3) == 1 then
								target:AddInjury(hitGroup, "infection");
							else
								target:AddInjury(hitGroup, "minor_infection");
							end
						end
					
						target.playerPerformingSurgery = nil;
						target.limbUnderSurgery = nil;
						target.injuryUnderSurgery = nil;
						target.surgeryStage = nil;
					end
					
					if target.surgeryStage then
						target.surgeryStage = target.surgeryStage + 1;
					end
					
					if cwBeliefs then
						if player:HasBelief("mother") then
							player:HandleXP(200);
						else
							player:HandleXP(100);
						end
					end

					hook.Run("PlayerHealed", target, itemTable);
				else
					Schema:EasyText(player, "chocolate","To perform surgery on someone, they must be fallen over.");
				end
			end);
		else
			Schema:EasyText(player, "peru","This player is already healing or operating on someone!");
		end;
	else
		Schema:EasyText(player, "peru", "You are already healing or operating on someone!");
	end;
end;

-- A function to force a player out of the bleedout state.
function cwMedicalSystem:PickupBleedout(player)
	Clockwork.player:SetAction(player, "die_bleedout", false);
	Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 180);
	Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
	
	--[[player:SetCrouchedWalkSpeed(1);
	player:ConCommand("-duck");]]--
end;

-- A function to make some blood effects.
function cwMedicalSystem:DoBleedEffect(entity, bForce)
	if (!IsValid(entity) or !IsEntity(entity) or (!bForce and entity:GetMoveType() != MOVETYPE_WALK)) then
		return;
	end;

	local entityPos = nil;
	local repetitions = 3;
	
	if (IsEntity(entity)) then
		entityPos = entity:GetPos();
	else
		entityPos = entity;
	end;
	
	for i = 1, repetitions do
		timer.Simple((3 * (i - 1)) + 0.1, function()
			if IsValid(entity) and (entity.bleeding or bForce) then
				local jitter = VectorRand() * 50;
				local filterEntity = nil;
				
				if (IsEntity(entity)) then
					filterEntity = entity;
				else
					filterEntity = {};
				end;
				
				local traceLine = util.TraceLine({start = entityPos + jitter, endpos = (entityPos + Vector(0, 0, -256)), filter = filterEntity, mask = MASK_SOLID});
			
				util.Decal("Blood", traceLine.HitPos + traceLine.HitNormal, traceLine.HitPos - traceLine.HitNormal);
				
				if (IsEntity(entity) and entity:IsPlayer()) then
					if (math.random(1, 2) == 2) then
						Clockwork.datastream:Start(player, "ScreenBloodEffect");
					end;
				end;
			end;
		end);
	end;
end;

-- A function to make a player start bleeding.
function cwMedicalSystem:StartBleeding(player, hitGroup)
	if IsValid(player) and player:Alive() and hitGroup then
		if !player:IsLimbBleeding(hitGroup) then
			player:MakeLimbBleed(hitGroup);
			player.bleeding = true;
		end;
	end;
end;

-- A function to make a player stop bleeding.
function cwMedicalSystem:StopBleeding(player, hitGroup)
	if IsValid(player) and player:Alive() and hitGroup then
		if !player:IsLimbBleeding(hitGroup) then
			player:MakeLimbStopBleeding(hitGroup);
			
			if player.bleeding then
				local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
				local bleeding = false;
				
				for k, v in pairs(bleedingLimbs) do
					if v == true then
						bleeding = true;
						break;
					end
				end
				
				-- Player may still be bleeding if one of their limbs is still bleeding.
				player.bleeding = bleeding;
			end
		end;
	end;
end;

-- A function to make all of a player's limbs stop bleeding.
function cwMedicalSystem:StopAllBleeding(player)
	if IsValid(player) and player:HasInitialized() then
		player:SetCharacterData("BleedingLimbs", {});
		player.bleeding = false;
	end;
end;

-- A function to make a player's blood level change.
function cwMedicalSystem:ModifyBloodLevel(player, amount)
	local bloodAmount = player:GetCharacterData("BloodLevel", self.maxBloodLevel);
	local newAmount = math.Clamp(math.Round(bloodAmount + amount), 0, 5000);
	
	if newAmount > self.lethalBloodLoss then
		if Clockwork.player:GetAction(player) == "die_bleedout" then
			self:PickupBleedout(player);
		end
	end
	
	player:SetCharacterData("BloodLevel", newAmount);
	player:SetNWInt("BloodLevel", newAmount);
end;

-- A function to set a player's blood level.
function cwMedicalSystem:SetBloodLevel(player, amount)
	local newAmount = math.Clamp(amount, 0, 5000);
	
	if newAmount > self.lethalBloodLoss then
		if Clockwork.player:GetAction(player) == "die_bleedout" then
			self:PickupBleedout(player);
		end
	end
	
	player:SetCharacterData("BloodLevel", newAmount);
	player:SetNWInt("BloodLevel", newAmount);
end;

-- Called when a player uses an unknown item function.
function cwMedicalSystem:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (string.find(itemFunction, "apply_")) then
		if (itemFunction == "apply_all") then
			itemTable:OnUseCustom(player, itemTable, "all");
			
			return;
		end;
		
		local hitGroupString = string.gsub(string.gsub(itemFunction, "apply_", ""), "_", " ");
		local hitGroupEnum = self.cwStringToHitGroup[hitGroupString];

		if (hitGroupEnum and self:IsHitGroup(hitGroupEnum)) then
			itemTable:OnUseCustom(player, itemTable, hitGroupEnum);
		else
			printp("Fucked!");
		end
	elseif (string.find(itemFunction, "ingest_")) then
		itemTable:OnUsed(player);
	elseif (string.find(itemFunction, "give_")) then
		local entity = player:GetEyeTraceNoCursor().Entity;
		local target = Clockwork.entity:GetPlayer(entity);
		
		if (target) then
			if (itemFunction == "give_all") then
				itemTable:OnUseTarget(player, target, itemTable, "all");
				return;
			else
				local hitGroupString = string.gsub(string.gsub(itemFunction, "give_", ""), "_", " ");
				local hitGroupEnum = self.cwStringToHitGroup[hitGroupString];

				if (hitGroupEnum and self:IsHitGroup(hitGroupEnum)) then
					local shootPos = player:GetShootPos();
					local position = entity:GetPos();
					local distance = position:DistToSqr(shootPos);
					local reqDistance = 192;

					if (distance <= (reqDistance * reqDistance)) then
						itemTable:OnUseTarget(player, target, itemTable, hitGroupEnum);
					else
						Schema:EasyText(player, "firebrick", "This character is too far away!");
					end;
				else
					printp("Fucked!");
				end;
			end
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end;
	end;
end;

-- Called after all armor and melee effects have been created.
function cwMedicalSystem:FuckMyLife(player, damageInfo)
	if player:IsPlayer() then
		local attacker = damageInfo:GetAttacker();
		local hitGroup = player:LastHitGroup();
		
		if (IsValid(attacker) and attacker:IsPlayer()) then
			local activeWeapon = attacker:GetActiveWeapon();
			
			if (IsValid(activeWeapon) and activeWeapon.Base == "sword_swepbase") then
				hitGroup = Clockwork.kernel:GetRagdollHitGroup(player, damageInfo:GetDamagePosition());
			end
		end
		
		if (hitGroup and isnumber(hitGroup)) then
			hitGroup = self.cwHitGroupToString[hitGroup];
		end;

		if (self:IsLimbDisabled(player, hitGroup)) then
			return;
		end;
		
		local limbs = self:GetLimbs(player);
		
		if limbs and limbs[hitGroup] then
			local damage = damageInfo:GetDamage() or 0;
			local maxHealth = player:GetMaxHealth() or 100;
			local health = math.max(player:Health() or 100, maxHealth);
			
			limbs[hitGroup] = math.Clamp(limbs[hitGroup] + damage, 0, health);
		end
		
		hook.Run("PlayerLimbDamageTaken", player, hitGroup, damage, damageInfo);
	end
end;

-- Called when a player's limb is damaged from EntityTakeDamage.
function cwMedicalSystem:PlayerLimbDamageTaken(player, hitGroup, damage, damageInfo)
end;

-- A function to make a player's limb bleed.
function cwMedicalSystem:MakeLimbBleed(player, hitGroup)
	local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
	
	if (hitGroup == HITGROUP_GENERIC or hitGroup == "generic") then
		hitGroup = "chest";
	end;
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	if (hitGroup) then
		bleedingLimbs[hitGroup] = true;
	end
	
	player:SetCharacterData("BleedingLimbs", bleedingLimbs);
end;

-- A function to make a player's limb stop bleeding.
function cwMedicalSystem:MakeLimbStopBleeding(player, hitGroup)
	local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});

	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	if (hitGroup) then
		bleedingLimbs[hitGroup] = false;
	end	

	player:SetCharacterData("BleedingLimbs", bleedingLimbs);
end;

-- A function to enable a player's limb.
function cwMedicalSystem:EnableLimb(player, hitGroup)
	local disabledLimbs = player:GetCharacterData("DisabledLimbs", {});

	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	if (hitGroup) then
		disabledLimbs[hitGroup] = false;
	end

	player:SetCharacterData("DisabledLimbs", disabledLimbs);
end;

-- A function to disable a player's limb.
function cwMedicalSystem:DisableLimb(player, hitGroup)
	local disabledLimbs = player:GetCharacterData("DisabledLimbs", {});
	
	if (hitGroup == HITGROUP_GENERIC or hitGroup == "generic") then
		hitGroup = "chest";
	end;

	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	if (hitGroup) then
		disabledLimbs[hitGroup] = true;
	end
	
	player:SetCharacterData("DisabledLimbs", disabledLimbs);
end;

-- A function to heal a limb.
function cwMedicalSystem:HealLimb(player, hitGroup, amount)
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	local limbs = self:GetLimbs(player);
	local amount = math.Clamp(math.abs(amount or limbs[hitGroup]), 0, limbs[hitGroup]);
	local maxHealth = player:GetMaxHealth();
	local health = math.max(player:Health(), maxHealth);
	
	limbs[hitGroup] = math.Clamp(limbs[hitGroup] - amount, 0, health)
	hook.Run("PlayerLimbDamageHealed", player, hitGroup, amount);
end;

-- A function to damage a limb.
function cwMedicalSystem:DamageLimb(player, hitGroup, amount)
	local limbs = self:GetLimbs(player);
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;

	local amount = math.Clamp(math.abs(amount), 0, limbs[hitGroup]);
	local maxHealth = player:GetMaxHealth();
	local health = math.max(player:Health(), maxHealth);
	
	limbs[hitGroup] = math.Clamp(limbs[hitGroup] + amount, 0, health)
	hook.Run("PlayerLimbDamageHealed", player, hitGroup, amount);
end;

-- A function to get whether a player's limb is bleeding or not.
function cwMedicalSystem:IsLimbBleeding(player, hitGroup)
	local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	return tobool(bleedingLimbs[hitGroup]);
end;

-- A function to get whether a player's limb is disabled or not.
function cwMedicalSystem:IsLimbDisabled(player, hitGroup)
	local disabledLimbs = player:GetCharacterData("DisabledLimbs", {});
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;
	
	return tobool(disabledLimbs[hitGroup]);
end;

-- A function to restore a limb to full health.
function cwMedicalSystem:RestoreLimb(player, hitGroup)
	local limbs = self:GetLimbs(player);
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;

	self:HealLimb(player, hitGroup, limbs[hitGroup]);
end;

-- A function to get a player's limb health.
function cwMedicalSystem:GetLimbHealth(player, hitGroup)
	local limbs = self:GetLimbs(player);
	
	if (isnumber(hitGroup)) then
		hitGroup = self.cwHitGroupToString[hitGroup];
	end;

	return limbs[hitGroup];
end;

-- A function to add an injury to a player's injury table.
function cwMedicalSystem:AddInjury(player, limb, uniqueID)
	local limbstr;

	if isstring(limb) then
		limbstr = limb;
		limb = self.cwStringToHitGroup[limb];
	else
		limbstr = self.cwHitGroupToString[limb];
	end

	if (limb == HITGROUP_GENERIC) then
		limb = HITGROUP_CHEST;
		limbstr = "chest";
	end;
	
	if (!IsValid(player) or !player:IsPlayer() or !limb or !uniqueID) then
		return;
	end;
	
	if (self.cwInjuryTable and self.cwInjuryTable[uniqueID]) then
		local injury = self.cwInjuryTable[uniqueID];

		if (injury.limbs and !table.HasValue(injury.limbs, limb)) then
			printp(player:Name()..": limb ["..limbstr.."] not registered in injury limb table: "..uniqueID)
			return;
		end;
		
		local injuries = self:GetInjuries(player);

		if (injuries[limb][uniqueID]) then
			printp(player:Name()..": injury ["..uniqueID.."] already exists on limb: "..limbstr);
			return;
		else
			injuries[limb][uniqueID] = true;
			player:SetCharacterData("Injuries", injuries);
			hook.Run("PlayerGivenInjury", player, uniqueID);
		end;
	end;
end;

-- A function to remove an injury from a player's injury table.
function cwMedicalSystem:RemoveInjury(player, limb, uniqueID)
	local uniqueID = uniqueID;
	local all = false;
	
	if (isstring(limb)) then
		uniqueID = limb;
		all = true;
	elseif (isbool(limb)) then
		all = true;
	end;
	
	local injuries = self:GetInjuries(player);
	
	if uniqueID then
		if (all) then
			for k, limb in pairs (injuries) do
				if (limb[uniqueID]) then
					limb[uniqueID] = nil;
				end;
			end;
		elseif (isnumber(limb)) then
			if (injuries[limb] and injuries[limb][uniqueID]) then
				injuries[limb][uniqueID] = nil;
			end;
		end;
	else
		if (injuries[limb]) then
			injuries[limb] = nil;
		end
	end
	
	player:SetCharacterData("Injuries", injuries);
end;

function cwMedicalSystem:ResetInjuries(player)
	player:SetCharacterData("Injuries", {});
end

-- A function to get the player's limb damage tables.
function cwMedicalSystem:GetLimbs(player)
	local limbs = player:GetCharacterData("Limbs", {});
	
	if (!limbs or !istable(limbs) or table.IsEmpty(limbs)) then
		self:SetupPlayer(player, false);
	end;
	
	local bleedingLimbs = player:GetCharacterData("BleedingLimbs");
	local disabledLimbs = player:GetCharacterData("DisabledLimbs");

	return player:GetCharacterData("Limbs"), bleedingLimbs, disabledLimbs;
end;

-- A function to get the player's injury tables.
function cwMedicalSystem:GetInjuries(player)
	local injuries = player:GetCharacterData("Injuries",  {});
	
	if (!injuries or !istable(injuries) or table.IsEmpty(injuries)) then
		self:SetupPlayer(player, true);
	end;
	
	return player:GetCharacterData("Injuries");
end;

-- A function to set a player up with their default limb tables.
function cwMedicalSystem:SetupPlayer(player, bInjuries)
	local bInjuries = bInjuries;
	local bLimbs = true;
	
	if (bInjuries != nil and isbool(bInjuries)) then
		bLimbs = !bInjuries;
	else
		bInjuries = true;
	end;
	
	if (bLimbs) then
		local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
		local disabledLimbs = player:GetCharacterData("DisabledLimbs", {});
		local limbs = player:GetCharacterData("Limbs", {});

		for k, v in pairs (self.cwHitGroupToString) do
			local limbName = self.cwHitGroupToString[k];
			
			if bleedingLimbs[limbName] == nil then
				bleedingLimbs[limbName] = false;
			end
			
			if disabledLimbs[limbName] == nil  then
				disabledLimbs[limbName] = false;
			end
			
			if limbs[limbName] == nil then
				limbs[limbName] = 0;
			end
		end;
			
		player:SetCharacterData("BleedingLimbs", bleedingLimbs);
		player:SetCharacterData("DisabledLimbs", disabledLimbs);
		player:SetCharacterData("Limbs", limbs);
	end;
	
	if (bInjuries) then
		local injuries = table.Copy(self.cwDefaultLimbs);
		
		for k, v in pairs (injuries) do
			injuries[k] = {};
		end;
		
		player:SetCharacterData("Injuries", injuries);
	end;
end;

-- A function to make a player's blood level change.
function playerMeta:ModifyBloodLevel(amount)
	cwMedicalSystem:ModifyBloodLevel(self, amount);
end

-- A function to set a player's blood level.
function playerMeta:SetBloodLevel(amount)
	cwMedicalSystem:SetBloodLevel(self, amount);
end

-- A function to start a player's limb bleeding.
function playerMeta:StartBleeding(hitGroup)
	cwMedicalSystem:StartBleeding(self, hitGroup);
end;

-- A function to stop a player's limb bleeding.
function playerMeta:StopBleeding(hitGroup)
	cwMedicalSystem:StopBleeding(self, hitGroup);
end;

-- A function to stop all of a player's limbs bleeding.
function playerMeta:StopAllBleeding()
	cwMedicalSystem:StopAllBleeding(self);
end;

-- A function to make a player's limb bleed.
function playerMeta:MakeLimbBleed(hitGroup)
	cwMedicalSystem:MakeLimbBleed(self, hitGroup);
end;

-- A function to stop a player's limb bleeding.
function playerMeta:MakeLimbStopBleeding(hitGroup)
	cwMedicalSystem:MakeLimbStopBleeding(self, hitGroup);
end;

-- A function to disable a player's limb.
function playerMeta:DisableLimb(hitGroup)
	cwMedicalSystem:DisableLimb(self, hitGroup);
end;

-- A function to get if a player's limb is bleeding or not.
function playerMeta:IsLimbBleeding(hitGroup)
	return cwMedicalSystem:IsLimbBleeding(self, hitGroup);
end;

-- A function to get if a player's limb is disabled or not.
function playerMeta:IsLimbDisabled(hitGroup)
	return cwMedicalSystem:IsLimbDisabled(self, hitGroup);
end;

-- A function to heal a player's limb.
function playerMeta:DamageLimb(hitGroup)
	cwMedicalSystem:DamageLimb(self, hitGroup);
end;

-- A function to heal a player's limb.
function playerMeta:HealLimb(hitGroup)
	cwMedicalSystem:HealLimb(self, hitGroup);
end;

-- A function to restore a player's limb to full health.
function playerMeta:RestoreLimb(hitGroup)
	cwMedicalSystem:RestoreLimb(self, hitGroup);
end;

-- A function to get the health of a player's limb.
function playerMeta:GetLimbHealth(hitGroup)
	cwMedicalSystem:GetLimbHealth(self, hitGroup);
end;

-- A function to add an injury to the player's injury table.
function playerMeta:AddInjury(limb, uniqueID)
	cwMedicalSystem:AddInjury(self, limb, uniqueID);
end;

-- A function to remove an injury to the player's injury table.
function playerMeta:RemoveInjury(limb, uniqueID)
	cwMedicalSystem:RemoveInjury(self, limb, uniqueID);
end;

function playerMeta:ResetInjuries()
	cwMedicalSystem:ResetInjuries(self);
end

function playerMeta:HandleDiseaseChance(category, chance)
	local curTime = CurTime();
	
	if !self.nextDiseaseCooldown or self.nextDiseaseCooldown < curTime then
		if cwBeliefs and self:HasBelief("savage_animal") then
			return;
		end
	
		local possible_diseases = {};
		
		if category == "water" then
			for k, v in pairs(cwMedicalSystem.cwDiseaseTable) do
				if v.fromWater then
					if !v.rarity or v.rarity <= math.random(1, 100) then
						table.insert(possible_diseases, k);
					end
				end
			end
		elseif category == "perishables" then
			for k, v in pairs(cwMedicalSystem.cwDiseaseTable) do
				if v.inPerishables then
					if !v.rarity or v.rarity <= math.random(1, 100) then
						table.insert(possible_diseases, k);
					end
				end
			end
		end
		
		if !table.IsEmpty(possible_diseases) then
			if math.random(1, 100) <= chance then
				self:GiveDisease(possible_diseases[math.random(1, #possible_diseases)]);
				
				self.nextDiseaseCooldown = curTime + 120;
			end
		end
	end
end

function playerMeta:InfectOtherPlayer(otherPlayer, diseases, chance)
	local clothesItem = otherPlayer:GetClothesEquipped();
	
	if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "disease_resistance") then
		return;
	end

	if not chance then
		chance = 100;
	end
	
	if math.random(1, 100) <= chance then
		if istable(diseases) then
			local disease = diseases[math.random(1, #diseases)];
			
			if otherPlayer:GiveDisease(disease) then
				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, otherPlayer:Name().." has been infected with "..disease.." by "..self:Name()..".");
			end
		else
			if otherPlayer:GiveDisease(diseases) then
				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, otherPlayer:Name().." has been infected with "..diseases.." by "..self:Name()..".");
			end
		end
	end
end

-- Function to give a disease.
function playerMeta:GiveDisease(uniqueID, stage)
	if cwBeliefs and self:HasBelief("the_paradox_riddle_equation") then
		return false;
	end

	local diseaseTable = cwMedicalSystem:FindDiseaseByID(uniqueID);
	
	if diseaseTable then
		local diseases = self:GetCharacterData("diseases", {});
		local has_disease = false;
		
		for i = 1, #diseases do
			local disease = diseases[i];
			
			if istable(disease) and disease.uniqueID == uniqueID then
				has_disease = true;
				break;
			end
		end
		
		if !has_disease then
			local diseaseData = {};
			local diseaseSharedVar = self:GetSharedVar("diseases", {});
			
			diseaseData.uniqueID = uniqueID;
			diseaseData.stage = tonumber(stage) or 1;
			diseaseData.timeContracted = self:CharPlayTime();
			
			table.insert(diseases, diseaseData);
			
			if diseaseTable.OnReceive then
				diseaseTable.OnReceive(self);
			end
			
			if not table.HasValue(diseaseSharedVar, uniqueID) then
				table.insert(diseaseSharedVar, uniqueID);
			end
		
			self:SetCharacterData("diseases", diseases);
			self:SetSharedVar("diseases", diseaseSharedVar);
			self:SetSharedVar("symptoms", self:GetSymptoms());
			
			return true;
		end
	end
	
	return false;
end

function playerMeta:TakeDisease(uniqueID)
	local diseaseTable = cwMedicalSystem:FindDiseaseByID(uniqueID);
	
	if diseaseTable then
		local diseases = self:GetCharacterData("diseases", {});
		local diseaseSharedVar = self:GetSharedVar("diseases", {});
		
		for i = 1, #diseases do
			local disease = diseases[i];
			
			if istable(disease) and disease.uniqueID == uniqueID then
				table.remove(diseases, i);
				
				if diseaseTable.OnTake then
					diseaseTable.OnTake(self);
				end
				
				for j = 1, #diseaseSharedVar do
					if diseaseSharedVar[j] == uniqueID then
						table.remove(diseaseSharedVar, j);
						break;
					end
				end
				
				self:SetCharacterData("diseases", diseases);
				self:SetSharedVar("diseases", diseaseSharedVar);
				self:SetSharedVar("symptoms", self:GetSymptoms());
				
				return;
			end
		end
	end
end

function playerMeta:TakeAllDiseases()
	if self:HasTrait("leper") then
		local diseaseTable = cwMedicalSystem:FindDiseaseByID("leprosy");
		
		if diseaseTable then
			local diseases = {};
			local diseaseData = {};
			local diseaseSharedVar = {};
			
			diseaseData.uniqueID = "leprosy";
			diseaseData.stage = 1;
			diseaseData.timeContracted = self:CharPlayTime();
			
			table.insert(diseases, diseaseData);
			table.insert(diseaseSharedVar, "leprosy");
			
			if diseaseTable.OnReceive then
				diseaseTable.OnReceive(self);
			end
		
			self:SetCharacterData("diseases", diseases);
			self:SetSharedVar("diseases", diseaseSharedVar);
			self:SetSharedVar("symptoms", self:GetSymptoms());
		else
			self:SetCharacterData("diseases", {});
			self:SetSharedVar("diseases", nil);
			self:SetSharedVar("symptoms", nil);
		end
	else
		self:SetCharacterData("diseases", {});
		self:SetSharedVar("diseases", nil);
		self:SetSharedVar("symptoms", nil);
	end
end

function playerMeta:HasDisease(uniqueID, stage)
	local diseaseTable = cwMedicalSystem:FindDiseaseByID(uniqueID);
	
	if diseaseTable then
		local diseases = self:GetCharacterData("diseases", {});
		
		for i = 1, #diseases do
			local disease = diseases[i];
			
			if istable(disease) and disease.uniqueID == uniqueID then
				if !stage then
					return true;
				else
					if tonumber(disease.stage) == stage then
						return true;
					end
				end
			end
		end
	end
	
	return false;
end

function playerMeta:GetSymptoms()
	local diseases = self:GetCharacterData("diseases", {});
	local symptoms = {};
	
	for i = 1, #diseases do
		local disease = diseases[i];
		
		if istable(disease) and disease.uniqueID then
			local diseaseTable = cwMedicalSystem:FindDiseaseByID(disease.uniqueID);
			
			if diseaseTable then
				if disease.stage then
					local stage = tonumber(disease.stage);
					
					if stage and diseaseTable.stages and diseaseTable.stages[stage] then
						local diseaseSymptoms = diseaseTable.stages[stage].symptoms;
						
						if diseaseSymptoms then
							for j = 1, #diseaseSymptoms do
								local symptom = diseaseSymptoms[j];
								
								if not table.HasValue(symptoms, symptom) then
									table.insert(symptoms, symptom);
								end
							end
						end
					end
				end
			end
		end
	end
	
	return symptoms;
end

function playerMeta:NetworkDiseases()
	local diseases = self:GetCharacterData("diseases", {});
	local diseaseNetworkStrings = {};
	local symptoms = {};
	
	for i = 1, #diseases do
		local disease = diseases[i];
		
		if istable(disease) and disease.uniqueID then
			local diseaseTable = cwMedicalSystem:FindDiseaseByID(disease.uniqueID);
			
			if diseaseTable then
				if disease.stage then
					local stage = tonumber(disease.stage);
					
					if stage and diseaseTable.stages and diseaseTable.stages[stage] then
						local diseaseSymptoms = diseaseTable.stages[stage].symptoms;
						
						if diseaseSymptoms then
							for j = 1, #diseaseSymptoms do
								local symptom = diseaseSymptoms[j];
								
								if not table.HasValue(symptoms, symptom) then
									table.insert(symptoms, symptom);
								end
							end
						end
					end
				end
				
				table.insert(diseaseNetworkStrings, disease.uniqueID);
			end
		end
	end
	
	if !table.IsEmpty(diseaseNetworkStrings) then
		self:SetSharedVar("diseases", diseaseNetworkStrings);
	else
		self:SetSharedVar("diseases", nil);
	end
	
	if !table.IsEmpty(symptoms) then
		self:SetSharedVar("symptoms", symptoms);
	else
		self:SetSharedVar("symptoms", nil);
	end
end

-- COMMENT THIS OUT WHEN NOT TESTING, THIS RESETS INJURIES
for k, v in pairs (_player.GetAll()) do
	if (!v:IsBot()) then
		--v:Freeze(false)
	else
		v:Freeze(true)
	end;
	
	--cwMedicalSystem:SetupPlayer(v)
end;

-- A function to flatten a player's injury table and encode it for networking.
function cwMedicalSystem:FlattenInjuries(player)
	local injuries = table.Copy(self:GetInjuries(player));
	local networkTab = {};
	
	for k, v in pairs (injuries) do
		if (!networkTab[k]) then
			networkTab[k] = {};
		end;
		
		for k2, v2 in pairs (v) do
			table.insert(networkTab[k], k2);
		end;
	end;
	
	return pon.encode(networkTab);
end;

-- A function to flatten a player's limb tables and encode it for networking.
function cwMedicalSystem:FlattenLimbs(player)
	local limbs, bleedingLimbs, disabledLimbs = self:GetLimbs(player);
	local networkTab = {};
	
	for k, v in pairs (limbs) do
		local bleeding = false;
		local disabled = false;
		
		if (bleedingLimbs and bleedingLimbs[k] == true) then
			bleeding = true;
		end;
		
		if (disabledLimbs and disabledLimbs[k] == true) then
			disabled = true;
		end;
		
		networkTab[k] = {damage = v, bleeding = bleeding, disabled = disabled};
	end;
	
	return pon.encode(networkTab);
end;

-- A function to send a player's injury data to their client.
function cwMedicalSystem:NetworkInjuries(player)
	local injuries = self:FlattenInjuries(player);
		
	if (string.len(injuries) > 2) then
		Clockwork.datastream:Start(player, "NetworkInjuries", injuries);
	end;
end;

-- A function to send a player's injury data to their client.
function cwMedicalSystem:NetworkLimbs(player)
	local limbs = self:FlattenLimbs(player);

	if (string.len(limbs) > 2) then
		Clockwork.datastream:Start(player, "NetworkLimbs", limbs);
	end;
end;

concommand.Add("listdiseases", function(player)
	if (player:IsAdmin()) then
		local diseases = cwMedicalSystem.cwDiseaseTable;
		
		if diseases then
			for k, v in pairs (diseases) do
				print(k);
			end;
		end;
	end;
end)