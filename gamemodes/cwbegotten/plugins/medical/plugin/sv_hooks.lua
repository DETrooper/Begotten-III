--[[
	Begotten III: Jesus Wept
--]]

cwMedicalSystem.bleedDamageThresholds = {
	[DMG_BULLET] = 5, -- bullets
	[DMG_BUCKSHOT] = 5, -- buckshot
	[DMG_CLUB] = 20, -- blunt
	[DMG_FALL] = 50, -- fall
	[DMG_SLASH] = 10, -- slash
	[DMG_VEHICLE] = 5, -- stab
};

-- Called when a player's character has loaded.
function cwMedicalSystem:PlayerCharacterLoaded(player)
	player.nextDiseaseCheck = CurTime() + math.random(120, 180);
	
	if player:HasTrait("leper") and not player:HasDisease("leprosy") then
		player:GiveDisease("leprosy");
	else
		-- Shit will already be networked if the leprosy disease is given.
		player:NetworkDiseases();
	end
end;

-- Called when a player opens their menu.
function cwMedicalSystem:PlayerOpenedMenu(player)
	local curTime = CurTime();
	
	if (!player.nextOpenMenu or curTime > player.nextOpenMenu) then
		player.nextOpenMenu = curTime + 3;
		self:NetworkInjuries(player);
		self:NetworkLimbs(player);
	end;
end;

-- Called when a player presses a key.
function cwMedicalSystem:KeyPress(player, key)
	if (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "heal" or action == "healing" or action == "performing_surgery" or action == "chloroform") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

-- Called at an interval while a player is connected.
function cwMedicalSystem:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (alive and initialized) then
		if (!plyTab.nextNetwork or curTime > plyTab.nextNetwork) then
			plyTab.nextNetwork = curTime + 5;
			self:NetworkInjuries(player);
			self:NetworkLimbs(player);
		end;
		
		if (Clockwork.player:HasFlags(player, "E")) then
			player:SetCharacterData("diseases", {});
			player:SetCharacterData("BloodLevel", self.maxBloodLevel);
		elseif (!plyTab.opponent and !plyTab.cwObserverMode) then
			if (!plyTab.nextBleedPoint or curTime >= plyTab.nextBleedPoint) then
				if !cwRituals or (cwRituals and !plyTab.scornificationismActive) then
					local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
					local bloodLevel = player:GetCharacterData("BloodLevel", self.maxBloodLevel);
					local injuries = self:GetInjuries(player);
					
					if plyTab.bleeding then
						local bloodLoss = 0;
						local bloodLossPerLimb = self.bloodLossPerLimb;
						local health = player:Health();
						
						if player:HasDisease("leprosy") then
							bloodLossPerLimb = bloodLossPerLimb * 1.5;
						end
						
						if player:HasBelief("plenty_to_spill") then
							bloodLossPerLimb = bloodLossPerLimb * 0.5;
						end
						
						if player.GetCharmEquipped and player:GetCharmEquipped("embalmed_heart") then
							bloodLossPerLimb = bloodLossPerLimb * 0.5;
						end
						
						for k, v in pairs(bleedingLimbs) do
							--printp(k..": "..tostring(v));
							if v == true then
								bloodLoss = bloodLoss + bloodLossPerLimb;
							end
						end

						for k, v in pairs(injuries) do
							for k2, v2 in pairs(v) do
								local injuryTable = self.cwInjuryTable[k2];
								
								if injuryTable.causesBleeding then
									bloodLoss = bloodLoss + bloodLossPerLimb * 0.5;
								end
							end
						end
						
						if bloodLoss == 0 then
							-- Seems player stopped bleeding but this wasn't caught?
							plyTab.bleeding = false;
						else
							self:DoBleedEffect(player);
							
							if math.random(1, 4) == 1 then
								if health > 1 then
									player:SetHealth(health - 1);
									
									Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken 1 damage from blood loss, leaving them at "..player:Health().." health!");
									
									local action =  Clockwork.player:GetAction(player);
									
									if player:Health() < 10 and action != "die" and action != "die_bleedout" then
										local dieTime = 60;
										
										if cwBeliefs and player:HasBelief("believers_perseverance") then
											dieTime = 240;
										end
										
										Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, dieTime + 1, nil);
										
										Clockwork.player:SetAction(player, "die", dieTime, 1, function()
											if (IsValid(player) and player:Alive()) then
												local bloodLevel = player:GetCharacterData("BloodLevel", self.maxBloodLevel);
												
												--if (bloodLevel <= self.lethalBloodLoss) then
													player:DeathCauseOverride("Bled out in a puddle of their own blood.");
													player:Kill();
													Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." has bled out!")
													--player:TakeDamage(99999, player, player);
													--player:SetCrouchedWalkSpeed(1);
												--[[else
													Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
													Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 180);
													--player:ConCommand("-duck");
													--player:SetCrouchedWalkSpeed(1);
												end;]]--
											end;
										end);
									end
								elseif not plyTab.scornificationismActive then
									player:DeathCauseOverride("Bled out in a puddle of their own blood.");
									player:TakeDamage(1, player, player);
								end
							end

							if bloodLevel <= self.maxBloodLevel - 250 and bloodLevel > self.maxBloodLevel - 750 then
								Clockwork.hint:Send(player, "You are suffering minor blood loss...", 5, Color(175, 100, 100));
							elseif bloodLevel <= self.maxBloodLevel - 750 and bloodLevel > self.maxBloodLevel - 1500 then
								Clockwork.hint:Send(player, "You are suffering blood loss...", 5, Color(175, 100, 100));
							elseif bloodLevel <= self.maxBloodLevel - 1500 and bloodLevel > self.lethalBloodLoss then
								Clockwork.hint:Send(player, "You are suffering severe blood loss...", 5, Color(175, 100, 100));
							elseif bloodLevel <= self.lethalBloodLoss then
								Clockwork.hint:Send(player, "You are suffering critical blood loss...", 5, Color(175, 100, 100));
							else
								Clockwork.hint:Send(player, "You are bleeding...", 5, Color(175, 100, 100));
							end

							player:ModifyBloodLevel(-bloodLoss);
						end
					else
						local health = player:Health();
						
						if !cwCharacterNeeds or (player:GetNeed("hunger") <= 50 and player:GetNeed("thirst") <= 50) then
							if health < player:GetMaxHealth() then
								local injuries = self:GetInjuries(player);
								local hasInjury = false;

								for k, v in pairs(injuries) do
									if istable(v) and not table.IsEmpty(v) then
										hasInjury = true;
										break;
									end
								end
								
								if not hasInjury then
									if math.random(1, 3) == 1 then
										player:SetHealth(health + 1);
									end
								end
							end
							
							if bloodLevel < self.maxBloodLevel then
								local bloodRegen = self.bloodPassiveRegen;
								
								if player.GetCharmEquipped and player:GetCharmEquipped("embalmed_heart") then
									bloodRegen = bloodRegen * 3;
								end
								
								player:ModifyBloodLevel(bloodRegen);
							end
						end
						
						-- HealDamage function checks if the limb can be healed (must have no injuries).
						local limbData = player:GetCharacterData("LimbData")

						if (limbData) then
							for k, v in pairs(limbData) do
								local limbHealth = Clockwork.limb:GetHealth(player, k);
								
								if limbHealth < health then
									Clockwork.limb:HealDamage(player, k, 1);
								end
							end
						end
					end
					
					if (!plyTab.nextBleedOut or curTime > plyTab.nextBleedOut) then
						if bloodLevel <= self.lethalBloodLoss then
							local action = Clockwork.player:GetAction(player);
							
							plyTab.nextBleedOut = curTime + 60;
							--Clockwork.hint:Send(player, "You are bleeding to death...", 10, Color(175, 100, 100));
							
							if (action != "die") and (action != "die_bleedout") then
								--[[player:ConCommand("+duck");
								player:SetCrouchedWalkSpeed(0.1);]]--

								local dieTime = 60;
								
								if cwBeliefs and player:HasBelief("believers_perseverance") then
									dieTime = 240;
								end
								
								Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, nil);
								
								Clockwork.player:SetAction(player, "die_bleedout", dieTime, 1, function()
									if (IsValid(player) and player:Alive()) then
										local bloodLevel = player:GetCharacterData("BloodLevel");
										
										if (bloodLevel <= self.lethalBloodLoss) then
											player:DeathCauseOverride("Bled out in a puddle of their own blood.");
											player:Kill();
											Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." has bled out!")
											--player:TakeDamage(99999, player, player);
											--player:SetCrouchedWalkSpeed(1);
										else
											Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 180);
											Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
											--player:ConCommand("-duck");
											--player:SetCrouchedWalkSpeed(1);
										end;
									end;
								end);
							end;

							return;
						end;
					end;
				end;
				
				plyTab.nextBleedPoint = curTime + math.random(10, 15);
			end;
			
			if (!plyTab.nextCritConditionCheck or curTime > plyTab.nextCritConditionCheck) then
				local action = Clockwork.player:GetAction(player);
				
				if (action == "die") then
					if player:Health() > 9 then
						Clockwork.player:SetAction(player, "die", false);
						Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 180);
						Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
					end
				
					--[[if (!plyTab.nextBleedOutDuck or curTime > plyTab.nextBleedOutDuck) then
						plyTab.nextBleedOutDuck = curTime + 0.5;
						
						if (!player:Crouching()) then
							player:ConCommand("+duck");
							player:SetCrouchedWalkSpeed(0.1);
							
							if (plyTab.crouchFix) then
								plyTab.crouchFix = nil;
							end;
						end;
					end;]]--
				elseif (action == "die_bleedout") then
					local bloodLevel = player:GetCharacterData("BloodLevel", self.maxBloodLevel);
					
					if bloodLevel > self.lethalBloodLoss then
						Clockwork.player:SetAction(player, "die_bleedout", false);
						Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 180);
						Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
					end
				--[[else
					if (!plyTab.crouchFix) then
						plyTab.crouchFix = true;
					end;]]--
				end;
				
				plyTab.nextCritConditionCheck = curTime + 1;
			end;
			
			if (!plyTab.nextDiseaseCheck or curTime > plyTab.nextDiseaseCheck) then
				local diseases = player:GetCharacterData("diseases", {});
				local diseaseNetworkStrings = {};
				local contagious_diseases = {};
				
				for i = 1, #diseases do
					local disease = diseases[i];
					
					if disease then
						local diseaseID = disease.uniqueID;
						local diseaseStage = disease.stage;
						local diseaseTable = cwMedicalSystem:FindDiseaseByID(diseaseID);
						local diseaseTimeContracted = disease.timeContracted or 0;
						
						if diseaseTable then
							if diseaseTable.contagious then
								table.insert(contagious_diseases, diseaseID);
							end
						
							if not diseaseTable.permanent then
								local stages = diseaseTable.stages;
								
								if stages and #stages > 1 then
									if stages[diseaseStage] then
										local progressionTime = stages[diseaseStage].progressionTime;
										
										if diseaseTimeContracted and progressionTime then
											if (diseaseTimeContracted + progressionTime) < player:CharPlayTime() then
												disease.stage = disease.stage + 1;
												
												if diseaseTable.advanceStage then
													diseaseTable.advanceStage(player, disease.stage);
												end
												
												-- Has the character gone through all stages of the disease?
												if disease.stage > #stages then
													if diseaseTable.deathChance then
														if math.random(1, 100) <= diseaseTable.deathChance then
															plyTab.dyingOfDisease = true;
															
															-- Todo: make a reverse wakeup sequence where you collapse and die.
															Clockwork.chatBox:Add(player, nil, "itnofake", "No... this can't be the end...");
															
															player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
															
															timer.Simple(5, function()
																if IsValid(player) then
																	plyTab.dyingOfDisease = false;
																	player:DeathCauseOverride("Died from complications of the "..diseaseTable.name..".");
																	player:Kill();
																	
																	Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." has died from the "..diseaseTable.name.."!");
																end
															end);
															
															diseases[i] = nil;
														end
													end
													
													if !plyTab.dyingOfDisease then
														Clockwork.chatBox:Add(player, nil, "itnofake", "You start to feel better, as though your disease has finally passed.");
														
														if diseaseTable.OnTake then
															diseaseTable.OnTake(player);
														end
														
														diseases[i] = nil;
													end
												end
											end
										end
									end
								end
							end
						
							-- If it hasn't been removed, compile a list of uniqueIDs for networking.
							if diseases[i] then
								table.insert(diseaseNetworkStrings, diseaseID);
							end
						else
							Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, "Invalid disease "..diseaseID.." for player "..player:Name()..", removing it from their character data.");
							diseases[i] = nil;
						end
					end
				end
				
				player:SetCharacterData("diseases", diseases);
				player:SetNetVar("diseases", diseaseNetworkStrings);
				player:SetNetVar("symptoms", player:GetSymptoms());
				
				if not plyTab.dyingOfDisease and not player:IsRagdolled() then
					-- Make the character do something related to their symptom.
					local symptoms = player:GetNetVar("symptoms", {});
					local valid_symptoms = {};
					
					for i = 1, #symptoms do
						local symptom = symptoms[i];
						
						if symptom == "Vomiting" or symptom == "Vomiting Blood" or symptom == "Coughing" or symptom == "Fatigue" then
							table.insert(valid_symptoms, symptom);
						end
					end
					
					if not table.IsEmpty(valid_symptoms) then
						local random_symptom = valid_symptoms[math.random(1, #valid_symptoms)];
						
						if random_symptom == "Vomiting" and not plyTab.iFrames then
							player:Vomit();
						elseif random_symptom == "Vomiting Blood" and not plyTab.iFrames then
							player:Vomit(true);
						elseif random_symptom == "Coughing" then
							local strings = {"coughs!", "hacks and wheezes!", "begins coughing loudly!"};
							
							if (player:GetGender() == GENDER_FEMALE) then
								player:EmitSound("ambient/voices/cough"..math.random(1, 3)..".wav", 65, math.random(140, 150));
							else
								player:EmitSound("ambient/voices/cough"..math.random(1, 3)..".wav", 65, math.random(85, 95));
							end
							
							if #contagious_diseases > 0 then
								for k, v in pairs (ents.FindInSphere(player:GetPos(), 256)) do
									if (v:IsPlayer() and not v.cwObserverMode) then
										player:InfectOtherPlayer(v, contagious_diseases, 20);
									end;
								end;
							end;
							
							Clockwork.chatBox:AddInTargetRadius(player, "me", strings[math.random(1, #strings)], player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);	
						elseif random_symptom == "Fatigue" then
							Clockwork.chatBox:Add(player, nil, "itnofake", "I don't feel so good...");
							
							if cwCharacterNeeds and player.HandleNeed then
								player:HandleNeed("sleep", 3);
							end
							
							timer.Simple(math.random(2, 5), function()
								if IsValid(player) and player:Alive() and not player:IsRagdolled() and not plyTab.iFrames and not plyTab.opponent then
									local gender = "his"

									if (player:GetGender() == GENDER_FEMALE) then
										gender = "her"
									end
									
									Clockwork.chatBox:AddInTargetRadius(player, "me", "goes weak at "..gender.." knees with exhaustion, collapsing onto the ground.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
									Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 10);
								end
							end);
						end
					end
				end
				
				plyTab.nextDiseaseCheck = curTime + math.random(60, 180);
			end
		end;
		
		if plyTab.playerPerformingSurgery then
			if IsValid(plyTab.playerPerformingSurgery) then
				local action = Clockwork.player:GetAction(plyTab.playerPerformingSurgery);
				
				if action == "performing_surgery" then
					local messupChance;
					
					if !plyTab.nextSurgeryCheck or plyTab.nextSurgeryCheck < curTime then
						if player:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT then
							messupChance = (messupChance or 0) + 30;
						end
						
						if player:GetNetVar("tied") ~= 0 then
							messupChance = (messupChance or 0) + 40;
						end
						
						if plyTab.playerPerformingSurgery:HasTrait("clumsy") or plyTab.playerPerformingSurgery:GetNetVar("IsDrunk") then
							messupChance = (messupChance or 0) + 40;
						end
						
						if messupChance then
							messupChance = math.min(messupChance, 90); -- There's always a 10% chance minimum to succeed.
						
							if math.random(1, 20) == 1 and player:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT then
								if !player:HasTrait("leper") and !player:GetNetVar("IsDrunk") then
									if cwSanity then
										player:HandleSanity(math.random(-5, -10));
									end
									
									Clockwork.chatBox:AddInTargetRadius(player, "me", "screams in pain!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								end
							elseif math.random(1, (100 - messupChance)) == 1 then
								local injuries = self:GetInjuries(player);
								
								for k, v in pairs(injuries) do
									for k2, v2 in pairs(v) do
										if v2 == true then
											if k == plyTab.limbUnderSurgery then
												local injury = self.cwInjuryTable[k2];
												local surgeryInfo = injury.surgeryInfo[plyTab.surgeryStage];
												
												if surgeryInfo then
													local messupsTab = surgeryInfo.messups;
													
													if messupsTab then
														if messupsTab.texts then
															local messupText = messupsTab.texts[math.random(1, #messupsTab.texts)];
															
															messupText = string.gsub(messupText, "NAME", player:Name());
															messupText = string.gsub(messupText, "LIMB", self.cwHitGroupToString[k]);
															
															Clockwork.chatBox:AddInTargetRadius(plyTab.playerPerformingSurgery, "me", messupText, plyTab.playerPerformingSurgery:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
														end
														
														if messupsTab.causesBleeding then
															self:StartBleeding(player, k)
														end								

														if messupsTab.damage then
															player:TakeDamage(messupsTab.damage);
														end
														
														Clockwork.player:SetAction(plyTab.playerPerformingSurgery, "performing_surgery", false);
													end
												end
											
												break;
											end
										end
									end
								end
							end
						end
							
						plyTab.nextSurgeryCheck = curTime + 0.5;
					end
				else
					plyTab.playerPerformingSurgery = nil;
				end
			end
		end
	end;
end;

-- Called after limb damage is calculated.
function cwMedicalSystem:PostCalculatePlayerDamage(player, hitGroup, damageInfo)
	if Clockwork.player:HasFlags(player, "I") then return end;
	
	local action = Clockwork.player:GetAction(player);
	local curTime = CurTime();
	local plyTab = player:GetTable();
	
	--[[if (player:GetCharacterData("painpills") and player:GetCharacterData("sanity") > 50) then
		damageInfo:ScaleDamage(0.75);
	end;]]--
	
	local attacker = damageInfo:GetAttacker();
	local damage = damageInfo:GetDamage() or 0;
	
	if (IsValid(attacker) and attacker:IsPlayer()) then
		local activeWeapon = attacker:GetActiveWeapon();
		
		if (activeWeapon:IsValid() and activeWeapon.Base == "sword_swepbase") then
			hitGroup = Clockwork.kernel:GetRagdollHitGroup(player, damageInfo:GetDamagePosition());
		end
	end

	if (self:IsLimbDisabled(player, hitGroup)) then
		return;
	end;
	
	local limbs = self:GetLimbs(player);
	local hitGroupStr = hitGroup;
	
	if (hitGroupStr and isnumber(hitGroupStr)) then
		hitGroupStr = self.cwHitGroupToString[hitGroupStr];
	end;
	
	if limbs and limbs[hitGroupStr] then
		local maxHealth = player:GetMaxHealth() or 100;
		local health = math.max(player:Health() or 100, maxHealth);
		
		limbs[hitGroupStr] = math.Clamp(limbs[hitGroupStr] + damage, 0, health);
	end
	
	hook.Run("PlayerLimbDamageTaken", player, hitGroup, damage, damageInfo);

	-- Make sure this doesn't happen in a duel.
	if !plyTab.opponent then
		if (player:Health() < 10) and !plyTab.scornificationismActive then
			if (action != "die") and (action != "die_bleedout") then
				--[[player:ConCommand("+duck");
				player:SetCrouchedWalkSpeed(0.1);]]--
				
				Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, nil);
				
				local dieTime = 60;
				
				if cwBeliefs and player:HasBelief("believers_perseverance") then
					dieTime = 240;
				end
				
				Clockwork.player:SetAction(player, "die", dieTime, 1, function()
					if (IsValid(player) and player:Alive()) then
						local bloodLevel = player:GetCharacterData("BloodLevel", self.maxBloodLevel);
						
						--if (bloodLevel <= self.lethalBloodLoss) then
							player:DeathCauseOverride("Bled out in a puddle of their own blood.");
							player:Kill();
							Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." has bled out!")
							--player:TakeDamage(99999, player, player);
							--player:SetCrouchedWalkSpeed(1);
						--[[else
							Clockwork.player:SetAction(player, "unragdoll", 180, 1, function() end);
							Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 180);
							--player:ConCommand("-duck");
							--player:SetCrouchedWalkSpeed(1);
						end;]]--
					end;
				end);
			end;
		end;
		
		if (!plyTab.nextHealWarn or plyTab.nextHealWarn < curTime) then
			if (player:Health() <= 50) then
				Clockwork.hint:Send(player, "You are seriously injured...", 10, Color(175, 100, 100));
			elseif (player:Health() <= 15) then
				Clockwork.hint:Send(player, "You are near death...", 10, Color(175, 100, 100));
			end;
			
			plyTab.nextHealWarn = curTime + 45;
		end;
		
		--local damageType = damageInfo:GetDamageType();
		local damageType;
		local damageTypes = {DMG_FALL, DMG_BULLET, DMG_BUCKSHOT, DMG_BURN, DMG_CLUB, DMG_SLASH, DMG_VEHICLE};
		local damage = damageInfo:GetDamage();
		local helmetItem = player:GetHelmetEquipped();
		
		for i = 1, #damageTypes do
			if damageInfo:IsDamageType(damageTypes[i]) then
				damageType = damageTypes[i];
				break;
			end
		end
		
		local bloodToll = (hitGroup == HITGROUP_HEAD and damage > 0 and helmetItem and helmetItem.attributes and table.HasValue(helmetItem.attributes, "bloodtoll"));
		
		if damageType or bloodToll then
			local damageThreshold = self.bleedDamageThresholds[damageType] or 10;

			if hitGroup == HITGROUP_GENERIC then
				hitGroup = math.random(1, 7);
			end
			
			if (damageThreshold and damage >= damageThreshold) and damageType ~= DMG_BURN then
				if damageType ~= DMG_CLUB then
					player:ModifyBloodLevel(-(damage + (100 - (damageThreshold * 2))));

					if damageType == DMG_FALL then
						local rand = math.random(1, 3);
						
						if rand == 1 then
							player:StartBleeding(HITGROUP_LEFTLEG);
						elseif rand == 2 then
							player:StartBleeding(HITGROUP_RIGHTLEG);
						else
							player:StartBleeding(HITGROUP_LEFTLEG);
							player:StartBleeding(HITGROUP_RIGHTLEG);
						end
					else
						player:StartBleeding(hitGroup);
						
						if bloodToll then
							player:EmitSound("ambient/machines/slicer"..math.random(1, 4)..".wav");
						end
					end
				end
				
				if (damageType == DMG_BULLET or damageType == DMG_BUCKSHOT) and damage >= 30 then
					local chance = 50;
					
					if player:HasBelief("hide_of_steel") then
						chance = math.max(0, chance - 25);
					end
					
					if player:HasBelief("watchful_raven") then
						chance = math.max(0, chance - 25);
					elseif player:HasBelief("enduring_bear") then
						chance = math.max(0, chance - 10);
					end
					
					if math.random(1, 100) <= chance then
						player:AddInjury(self.cwHitGroupToString[hitGroup], "gunshot_wound");
						player:StartBleeding(hitGroup);
					end
				elseif (damageType == DMG_CLUB and hitGroup < 8 and hitGroup > 3) or damageType == DMG_SLASH --[[or damageType == DMG_VEHICLE]] then
					local chance = 15;
					local limbHealth = Clockwork.limb:GetHealth(player, hitGroup, false)

					if (limbHealth <= 90) then
						if limbHealth <= 75 and limbHealth > 50 then
							chance = 25;
						elseif limbHealth <= 50 and limbHealth > 25 then
							chance = 50;
						elseif limbHealth <= 25 and limbHealth > 10 then
							chance = 75;
						else
							chance = 90;
							
							if hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_STOMACH then
								chance = 125;
							end
						end
					end
					
					local originalChance = chance;
					
					if player:HasBelief("hide_of_steel") then
						chance = math.max(0, chance - (originalChance * 0.5));
					end
					
					if player:HasBelief("watchful_raven") then
						chance = math.max(0, chance - (originalChance * 0.5));
					elseif player:HasBelief("enduring_bear") then
						chance = math.max(0, chance - (originalChance * 0.8));
					end
					
					if math.random(1, 100) <= chance then
						local injuries = self:GetInjuries(player);
					
						if damageType == DMG_CLUB then
							if !(injuries[hitGroup]["broken_bone"]) then
								player:AddInjury(self.cwHitGroupToString[hitGroup], "broken_bone");
								player:StartBleeding(hitGroup);
								
								Clockwork.chatBox:AddInTargetRadius(player, "me", "'s "..self.cwHitGroupToString[hitGroup].." audibly breaks with a horrifying snap!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

								player:EmitSound("misc/bone_fracture.wav", 75, math.random(95, 100));
							end;
						else
							if !IsValid(attacker) or attacker:IsPlayer() or ((attacker:IsNPC() or attacker:IsNextBot()) and math.random(1, 3) == 1) then
								if !(injuries[hitGroup]["gash"]) then
									player:AddInjury(self.cwHitGroupToString[hitGroup], "gash");
								end
							end
							
							player:StartBleeding(hitGroup);
						end
					end
				end
			elseif damageType == DMG_BURN then
				if cwBeliefs then
					if player:HasBelief("hide_of_steel") and player:HasBelief("watchful_raven") then
						return;
					elseif player:HasBelief("hide_of_steel") or player:HasBelief("watchful_raven") then
						if math.random(1, 2) == 1 then
							return;
						end
					elseif player:HasBelief("enduring_bear") then
						if math.random(1, 4) == 1 then
							return;
						end
					end
				end
			
				if IsValid(attacker) and attacker:GetClass() == "entityflame" then
					if math.random(1, 20) == 1 then
						player:AddInjury(self.cwHitGroupToString[hitGroup], "burn");
					end
				else
					if math.random(1, 3) == 1 then
						player:AddInjury(self.cwHitGroupToString[hitGroup], "burn");
					end
				end
			end
		end
	end
	
	if (player:Alive() and damageInfo:GetDamage() > 5) then
		for i = 1, math.random(1, 5) do
			netstream.Start(player, "ScreenBloodEffect");
		end;
	end;
end;

-- A function to scale damage by hit group.
-- I think this is kind of redundant, right? Gonna comment it out for now.
function cwMedicalSystem:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	--[[local curTime = CurTime();

	-- Make sure this doesn't happen in a duel.
	if !player.opponent and (!player._nextBleed or player._nextBleed <= curTime) then
		player._nextBleed = curTime + 1;
		
		local damage = damageInfo:GetDamage();
		local damageThreshold = self.bleedDamageThresholds[damageInfo:GetDamageType()];
		
		if damageThreshold and damage >= damageThreshold then
			player:ModifyBloodLevel(-(damage + (100 - (damageThreshold * 2))));
			player:StartBleeding(hitGroup);
		end
	end;]]--
end;

-- Called when a player's character data should be saved.
function cwMedicalSystem:PlayerSaveCharacterData(player, data)
	--[[if (data["bleeding"]) then
		data["bleeding"] = 0;
	end;]]--
	
	if (data["BloodLevel"]) then
		data["BloodLevel"] = math.Round(data["BloodLevel"]);
	end;
end;

-- Called when a player's character data should be restored.
function cwMedicalSystem:PlayerRestoreCharacterData(player, data)
	data["BloodLevel"] = data["BloodLevel"] or self.maxBloodLevel;
	data["BleedingLimbs"] = data["BleedingLimbs"] or {};
	data["Limbs"] = data["Limbs"] or {};
	data["Injuries"] = data["Injuries"] or {};
end;

-- Called when a player dies.
function cwMedicalSystem:PlayerDeath(player, inflictor, attacker, damageInfo)
	if not player.opponent then
		local diseases = player:GetCharacterData("diseases", {});
		local potential_diseases = {};
		local ragdoll = player:GetRagdollEntity();
		
		for i = 1, #diseases do
			local disease = diseases[i];
			
			if istable(disease) and disease.uniqueID then
				local diseaseTable = cwMedicalSystem:FindDiseaseByID(disease.uniqueID);
				
				if diseaseTable and diseaseTable.contagious then
					table.insert(potential_diseases, disease.uniqueID);
				end
			end
		end
		
		if #potential_diseases > 0 then
			ragdoll.disease = potential_diseases[math.random(1, #potential_diseases)];
		end
		
		Clockwork.player:SetAction(player, "die", false);
		Clockwork.player:SetAction(player, "die_bleedout", false);

		player:SetCharacterData("BloodLevel", self.maxBloodLevel);
		player:SetNWInt("BloodLevel", player:GetCharacterData("BloodLevel", self.maxBloodLevel));
		
		self:SetupPlayer(player);
		self:StopAllBleeding(player);
		
		--[[player:ConCommand("-duck");
		player:SetCrouchedWalkSpeed(1);]]--
	end
end;

-- Called when a player is given an injury.
function cwMedicalSystem:PlayerGivenInjury(player, uniqueID)
	local injuryTable = self.cwInjuryTable[uniqueID];

	if (injuryTable and injuryTable.OnReceive) then
		injuryTable:OnReceive(player);
	end;
	
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
end;

-- Called when an injury is taken from a player.
function cwMedicalSystem:PlayerInjuryTaken(player, uniqueID)
	local injuryTable = self.cwInjuryTable[uniqueID];
	
	if (injuryTable and injuryTable.OnTake) then
		injuryTable:OnTake(player);
	end;
	
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
end;

-- Called when a player's limb is healed.
function cwMedicalSystem:PlayerLimbHealed(player, hitGroup, amount)
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
end;

-- Called when a player's limb is damaged.
function cwMedicalSystem:PlayerLimbDamaged(player, hitGroup, amount)
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
end;

-- Called when a player's limb is damaged.
function cwMedicalSystem:PlayerLimbFallDamageTaken(player, amount)
	if player.opponent or (Clockwork.player:HasFlags(player, "E")) then
		return;
	end

	if amount >= 25 then
		if !player.GetCharmEquipped or !player:GetCharmEquipped("boot_contortionist") then
			local injuries = self:GetInjuries(player);
			local bone_broken;
			local both_bones_broken = false;
			local left_leg_chance = math.min(amount * 1.5, 100);
			local right_leg_chance = math.min(amount * 1.5, 100);
			
			if !injuries[HITGROUP_RIGHTLEG] then
				injuries[HITGROUP_RIGHTLEG] = {};
			end
			
			if !injuries[HITGROUP_LEFTLEG] then
				injuries[HITGROUP_LEFTLEG] = {};
			end
			
			if !(injuries[HITGROUP_RIGHTLEG]["broken_bone"]) and math.random(1, 100) < right_leg_chance then
				player:AddInjury(self.cwHitGroupToString[HITGROUP_RIGHTLEG], "broken_bone");
				player:StartBleeding(HITGROUP_RIGHTLEG);
				
				if !bone_broken then
					bone_broken = "right";
				else
					both_bones_broken = true;
				end
			end
			
			if !(injuries[HITGROUP_LEFTLEG]["broken_bone"]) and math.random(1, 100) < left_leg_chance then
				player:AddInjury(self.cwHitGroupToString[HITGROUP_LEFTLEG], "broken_bone");
				player:StartBleeding(HITGROUP_LEFTLEG);
				
				if !bone_broken then
					bone_broken = "left";
				else
					both_bones_broken = true;
				end
			end
			
			if bone_broken then
				if both_bones_broken then
					Clockwork.chatBox:AddInTargetRadius(player, "me", "'s legs audibly break with a horrifying snap!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				else
					Clockwork.chatBox:AddInTargetRadius(player, "me", "'s "..bone_broken.." leg audibly breaks with a horrifying snap!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				end
				
				player:EmitSound("misc/bone_fracture.wav", 75, math.random(95, 100));
			end;
		end;
	end;
end;

-- Called to check if a player's limb can heal.
function cwMedicalSystem:PlayerCanHealLimb(player, hitGroup)
	local injuries = self:GetInjuries(player);
	
	if (injuries[hitGroup]) then
		if #injuries[hitGroup] > 0 then
			return false;
		end
	end
end;

-- Called after a player has been healed.
function cwMedicalSystem:PlayerHealed(player, itemTable) end;

-- Called just after a player spawns.
function cwMedicalSystem:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	--Clockwork.player:SetAction(player, "die", false);
	--Clockwork.player:SetAction(player, "die_bleedout", false);
	
	--[[if (!lightSpawn) then
		player:SetCharacterData("BloodLevel", self.maxBloodLevel);
		player:SetNWInt("BloodLevel", player:GetCharacterData("BloodLevel", self.maxBloodLevel));
		
		self:SetupLimbs(player);
		self:ResetInjuries(player);
	end;]]--
	
	if firstSpawn then
		if !player:GetCharacterData("BloodType") then
			local bloodTypes = {};
			
			for k, v in pairs(self.bloodTypes) do
				table.insert(bloodTypes, k);
			end
			
			player:SetCharacterData("BloodType", bloodTypes[math.random(1, #bloodTypes)]);
		end
	end
	
	if (!lightSpawn) and !player.opponent then
		local bleeding = false;
		local bleedingLimbs = player:GetCharacterData("BleedingLimbs", {});
		
		for k, v in pairs(bleedingLimbs) do
			if v == true then
				bleeding = true;
				break;
			end
		end
		
		if !bleeding then
			local injuries = self:GetInjuries(player);
			
			for k, v in pairs(injuries) do
				for k2, v2 in pairs(v) do
					local injuryTable = self.cwInjuryTable[k2];
					
					if injuryTable.causesBleeding then
						bleeding = true;
						break;
					end
				end
			end
		end
		
		player.bleeding = bleeding;
		
		if !player:GetCharacterData("BloodLevel") then
			player:SetCharacterData("BloodLevel", self.maxBloodLevel);
		end
		
		player:SetNWInt("BloodLevel", player:GetCharacterData("BloodLevel", self.maxBloodLevel));
	end
	
	--[[player:ConCommand("-duck");
	player:SetCrouchedWalkSpeed(1);]]--
end;

-- Called when an entity takes damage.
--[[function cwMedicalSystem:EntityTakeDamage(entity, damageInfo)
	if (entity:GetClass() == "prop_ragdoll" and damageInfo:GetDamage() >= 30) then
		local ragdollPlayer = Clockwork.entity:GetPlayer(entity)
		
		if IsValid(ragdollPlayer) then
			local damage = damageInfo:GetDamage();
			local damageThreshold = self.bleedDamageThresholds[damageInfo:GetDamageType()];
			local limb = HITGROUP_CHEST; -- change later;

			if damageThreshold and damage >= damageThreshold then
				entity:ModifyBloodLevel(-(damage + (100 - (damageThreshold * 2))));
				entity:StartBleeding(hitGroup);
			end
		end;
	end;
end;]]--

function cwMedicalSystem:GetPlayerSkinOverride(player)
	if player:HasDisease("leprosy") then
		if string.find(player:GetModel() or "", "models/begotten/heads") then
			return player:SkinCount() - 1;
		end
	end
end

-- Called when a player has been unragdolled.
function cwMedicalSystem:PlayerUnragdolled(player, state, ragdoll)
	Clockwork.player:SetAction(player, "die", false);
	Clockwork.player:SetAction(player, "die_bleedout", false);
end;

-- Called when a player has been ragdolled.
function cwMedicalSystem:PlayerRagdolled(player, state, ragdoll)
	--Clockwork.player:SetAction(player, "die", false);
	--Clockwork.player:SetAction(player, "die_bleedout", false);
end;

-- Called when the local player attempts to get up.
function cwMedicalSystem:PlayerCanGetUp(player)
	local action = Clockwork.player:GetAction(player);
	
	if action == "die" or action == "die_bleedout" then
		return false;
	end
end;

-- Called when a player attempts to use an item.
function cwMedicalSystem:PlayerCanUseItem(player, itemTable, noMessage)
	local action = Clockwork.player:GetAction(player);
	
	if (action == "die") or (action == "die_bleedout") then
		Schema:EasyText(player, "firebrick", "You cannot use items while you are dying!");
		
		return false;
	end;
end;

-- Called when a player uses an item.
function cwMedicalSystem:PlayerUseItem(player, itemTable, itemEntity)
	-- For food/water items.
	if itemTable.infectchance then
		if !cwBeliefs or (cwBeliefs and !player:HasBelief("savage_animal")) then
			if cwBeliefs and player:HasBelief("sanitary") then
				player:HandleDiseaseChance("perishables", math.Round(itemTable.infectchance / 2));
			else
				player:HandleDiseaseChance("perishables", itemTable.infectchance);
			end
		end
	end
end;

function cwMedicalSystem:PreOpenedContainer(player, entity)
	if entity.disease and !player.cwObserverMode then
		if cwBeliefs and player:HasBelief("sanitary") then
			return;
		end
		
		if math.random(1, 100) <= 75 then
			if player:GiveDisease(entity.disease) then
				Schema:EasyText(Schema:GetAdmins(), "icon16/bug.png", "tomato", player:Name().." has been infected with "..entity.disease.." from looting a diseased corpse.");
				--Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has been infected with "..entity.disease.." from looting a diseased corpse.");
			end
		end
	end
end

function cwMedicalSystem:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "heal" or action == "healing" or action == "performing_surgery") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
		infoTable.jumpPower = 0;
	else
		local injuries = self:GetInjuries(player);
		
		if injuries and ((injuries[HITGROUP_LEFTLEG] and injuries[HITGROUP_LEFTLEG]["broken_bone"]) or (injuries[HITGROUP_RIGHTLEG] and injuries[HITGROUP_RIGHTLEG]["broken_bone"])) then
			infoTable.crouchedWalkSpeed = math.max(1, infoTable.crouchedWalkSpeed * 0.8);
			infoTable.walkSpeed = math.max(1, infoTable.walkSpeed * 0.5);
			infoTable.runSpeed = math.max(1, infoTable.walkSpeed);
			infoTable.jumpPower = 0;
		end
	end
end
