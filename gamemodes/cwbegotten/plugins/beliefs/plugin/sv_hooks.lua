--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local residualXPInSafezone = game.GetMap() == "rp_scraptown";
local melee_test_enabled = false; -- Automatically gives some melee-related beliefs.

-- Called when the player's character data is restored.
function cwBeliefs:PlayerRestoreCharacterData(player, data)
	if (!data["experience"]) then
		data["experience"] = 0
	end
	
	if (!data["beliefs"]) then
		data["beliefs"] = {}
	end
	
	if (!data["points"]) then
		data["points"] = 0
	end
	
	if (!data["level"]) then
		data["level"] = 1
	end
	
	player:SetLocalVar("experience", data["experience"]);
	player:SetLocalVar("points", data["points"]);
	player:SetNetVar("level", data["level"]);
end

-- Called when a player's character screen info should be adjusted.
function cwBeliefs:PlayerAdjustCharacterScreenInfo(player, character, info)
	info.level = character.data["level"];
end

-- Called at an interval while the player is connected to the server.
function cwBeliefs:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if initialized and alive then
		if plyTab.deceitfulLastDamages then
			for i, v in ipairs(plyTab.deceitfulLastDamages) do
				if v.damageTime < (curTime - 2) then
					table.remove(plyTab.deceitfulLastDamages, i);
				end
			end
			
			if table.IsEmpty(plyTab.deceitfulLastDamages) then
				plyTab.deceitfulLastDamages = nil;
			end
		end
	
		if (!plyTab.residualXPCheck or plyTab.residualXPCheck < curTime) then
			local residualCooldown = 60
			
			local lastZone = player:GetCharacterData("LastZone");
			local playerFaction = player:GetFaction();
			
			if not plyTab.opponent and (table.HasValue(self.residualXPZones, lastZone) or (lastZone == "tower" and ((playerFaction == "Gatekeeper" or playerFaction == "Pope Adyssa's Gatekeepers" or playerFaction == "Hillkeeper" or playerFaction == "Holy Hierarchy") or residualXPInSafezone == true))) then
				local residualXP = self.xpValues["residual"] or 1;
				
				if playerFaction == "Goreic Warrior" and (lastZone == "wasteland" or lastZone == "tower" or lastZone == "caves" or lastZone == "scrapper") then
					residualCooldown = residualCooldown * 0.5
				end
				
				if (cwDayNight and cwDayNight.currentCycle == "night" and player:HasBelief("primevalism") and lastZone == "wasteland") or player:HasBelief("old_son") or (lastZone != "tower" and (playerFaction == "Gatekeeper" or playerFaction == "Pope Adyssa's Gatekeepers" or playerFaction == "Hillkeeper" or playerFaction == "Holy Hierarchy")) then
					residualCooldown = residualCooldown * 0.5
				end
				
				local factionTable = Clockwork.faction:FindByID(playerFaction);
				
				if factionTable and factionTable.residualXPZones then
					local residualXPZones = factionTable.residualXPZones[game.GetMap()];
					
					if residualXPZones then
						local playerPos = player:GetPos();
						
						for i, v in ipairs(residualXPZones) do
							if playerPos:WithinAABox(v.pos1, v.pos2) then
								local modifier = v.modifier or 0.5;
								
								if cwDayNight and v.nightModifier and cwDayNight.currentCycle == "night" then
									modifier = v.nightModifier or 0.25;
								end
								
								residualCooldown = residualCooldown * modifier
							
								break;
							end
						end
					end
				end

				plyTab.residualXPCheck = curTime + residualCooldown

				player:HandleXP(residualXP);
			end
		end
		
		if !plyTab.bucketCheck or plyTab.bucketCheck < curTime then
			plyTab.bucketCheck = curTime + 2;

			if !player:HasBelief("dexterity") and (player:HasItemByID("dirty_water_bucket") or player:HasItemByID("purified_water_bucket")) and !player.cwObserverMode then
				if player:IsRunning() then
					Clockwork.chatBox:AddInTargetRadius(player, "me", "drops a bucket of water as they run, spilling it all over themselves like a fucking idiot!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					player:EmitSound("apocalypse/cauldron/dropping.mp3");
					player:HandleTemperature(-20);

					if player:HasItemByID("dirty_water_bucket") then
						player:TakeItem(player:FindItemByID("dirty_water_bucket"));
					else
						player:TakeItem(player:FindItemByID("purified_water_bucket"));
					end

					player:GiveItem(Clockwork.item:CreateInstance("empty_bucket"), true);
				end
			end
		end
		
		if plyTab.cloaked then
			if (!plyTab.cloakedCheck or plyTab.cloakedCheck < curTime) then
				plyTab.cloakedCheck = curTime + 0.5;
				
				local lastZone = player:GetCharacterData("LastZone");
				local valid_zones = {"scrapper", "caves", "wasteland"};
				
				if !player:Crouching() or !player:GetActiveWeapon():GetClass() == "cw_senses" or (!player:GetNetVar("kinisgerCloak") and (!table.HasValue(valid_zones, lastZone) or cwDayNight and cwDayNight.currentCycle ~= "night" and lastZone ~= "caves" and (!cwWeather or cwWeather.weather ~= "bloodstorm"))) then
					player:Uncloak();
				else
					local playerPos = player:GetPos();
					
					for _, v in _player.Iterator() do
						if v:GetNetVar("yellowBanner") then
							if (v:GetPos():Distance(playerPos) <= config.Get("talk_radius"):Get()) then
								Schema:EasyText(player, "peru", "There is one with a yellow banner raised, dispelling your dark magic! Vanquish them or distance yourself!");
								Schema:EasyText(v, "peru", "You feel your yellow banner pulsate with energy as the dark magic of "..player:Name().." is foiled and they are uncloaked for all to see!");
								player:Uncloak();
							
								break;
							end
						elseif v:GetCharmEquipped("holy_sigils") or v:GetCharmEquipped("codex_solis") then
							if (v:GetPos():Distance(playerPos) <= (config.Get("talk_radius"):Get() * 0.75)) then
								Schema:EasyText(player, "peru", "There is one with a holy relic, dispelling your dark magic! Vanquish them or distance yourself!");
								Schema:EasyText(v, "peru", "You feel your equipped charm pulsate with energy as the dark magic of "..player:Name().." is foiled and they are uncloaked for all to see!");
								player:Uncloak();
							
								break;
							end
						end
					end
				end
			end
		elseif player:GetSubfaction() == "Kinisger" then
			if (!plyTab.cloakedCheck or plyTab.cloakedCheck < curTime) then
				plyTab.cloakedCheck = curTime + 0.5;
				
				if player:Crouching() and player:GetNetVar("kinisgerCloak") == true and !plyTab.cwObserverMode then
					if !player.wOSIsRolling or !player:wOSIsRolling() then
						if !plyTab.cloakCooldown or plyTab.cloakCooldown <= curTime then
							local playerPos = player:GetPos();
							local blockedCloak;
							
							for _, v in _player.Iterator() do
								if v:GetNetVar("yellowBanner") then
									if (v:GetPos():Distance(playerPos) <= config.Get("talk_radius"):Get()) then
										blockedCloak = true;
									
										break;
									end
								end
							end
						
							if !blockedCloak then
								player:Cloak();
							end
						elseif (plyTab.cloakCooldown - curTime) > 5 then
							Schema:EasyText(self.Owner, "chocolate", "You are covered in black powder and cannot cloak for another "..math.ceil(plyTab.cloakCooldown - curTime).." seconds!");
						else
							Schema:EasyText(self.Owner, "chocolate", "You cannot cloak for another "..math.ceil(plyTab.cloakCooldown - curTime).." seconds!");
						end
					end
				end
			end
		end
		
		if (!plyTab.poisonCheck or plyTab.poisonCheck < curTime) then
			if plyTab.poisonTicks and plyTab.poisonTicks > 0 then
				plyTab.poisonTicks = plyTab.poisonTicks - 1;
				
				if alive then
					local damageInfo = DamageInfo();
					
					damageInfo:SetDamage(2);
					damageInfo:SetDamageType(DMG_POISON);
					damageInfo:SetDamagePosition(player:GetPos() + Vector(0, 0, 32));
					damageInfo:SetAttacker(plyTab.poisoner or player);
					damageInfo:SetInflictor(plyTab.poisoner or player);
					
					player:TakeDamageInfo(damageInfo);
				end
				
				if plyTab.poisonTicks == 0 then
					plyTab.poisonTicks = nil;
					plyTab.poisoninflictor = nil;
					plyTab.poisoner = nil;
				end
			end
			
			plyTab.poisonCheck = curTime + 0.5;
		end
		
		if (!plyTab.regenCheck or plyTab.regenCheck < curTime) then
			plyTab.regenCheck = curTime + 5;
			
			if player:GetFaith() == "Faith of the Family" then
				if player:HasBelief("gift_great_tree") then
					if hook.Run("PlayerShouldHealthRegenerate", player) then
						local maxHealth = player:GetMaxHealth()
						local health = player:Health()
						local clothesItem = player:GetClothesEquipped();

						if (health > 0 and health < maxHealth) then
							if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "increased_regeneration") then
								player:SetHealth(math.Clamp(
									health + 3, 0, maxHealth)
								);
							else
								player:SetHealth(math.Clamp(
									health + 1, 0, maxHealth)
								);
							end
						end
					end
				end
			end
		end
	end
end

-- Called just after a player has taken a belief.
function cwBeliefs:BeliefTaken(player, uniqueID, category)
	local beliefs = player:GetCharacterData("beliefs");
	local points = player:GetCharacterData("points", 0);
	local beliefTree = self:FindBeliefTreeByID(category);
	local beliefTable = self:FindBeliefByID(uniqueID, category);
	
	if beliefTree then
		if beliefTree and beliefTree.hasFinisher then
			local category_finished = true;
			
			for k, v in pairs(beliefTree.beliefs) do
				for k2, v2 in pairs(v) do
					if !v2.disabled and !beliefs[k2] then
						category_finished = false;
						
						break;
					end
				end
				
				if !category_finished then
					break;
				end
			end
					
			if category_finished then
				beliefs[category.."_finisher"] = true;
				player:SetCharacterData("beliefs", beliefs);
			end
		end
	end
	
	if beliefTable then
		if beliefTable.subfaith and beliefTable.row == 1 then
			local character = player.cwCharacter;
			
			character.subfaith = beliefTable.subfaith;
			player:SetNetVar("subfaith", beliefTable.subfaith);
			
			player:SaveCharacter();
		end
	end
	
	local lockedBeliefFound = false;
	
	for k, v in pairs(self.beliefTrees.stored) do
		if v.lockedBeliefs then
			for i, v2 in ipairs(v.lockedBeliefs) do
				if beliefs[v2] then
					lockedBeliefFound = true;
					
					if v.hasFinisher then
						if beliefs[v.uniqueID.."_finisher"] then
							beliefs[v.uniqueID.."_finisher"] = false;
						end
					end

					for k2, v3 in pairs(v.beliefs) do
						for k3, v4 in pairs(v3) do
							if beliefs[k3] then
								beliefs[k3] = false;
								points = points + 1;
							end
						end
					end
					
					break;
				end
			end
		end
		
		for k2, v2 in pairs(v.beliefs) do
			for k3, v3 in pairs(v2) do
				if v3.lockedBeliefs then
					for i, v4 in ipairs(v3.lockedBeliefs) do
						if beliefs[k3] and beliefs[v4] then
							beliefs[k3] = false;
							points = points + 1;
							
							if !lockedBeliefFound and v.hasFinisher then
								if beliefs[v.uniqueID.."_finisher"] then
									beliefs[v.uniqueID.."_finisher"] = false;
								end
							end
							
							lockedBeliefFound = true;
						end
					end
				end
			end
		end
	end
	
	if lockedBeliefFound then
		player:SetCharacterData("points", points);
		player:SetLocalVar("points", points);
		player:SetCharacterData("beliefs", beliefs);
	end
	
	if uniqueID == "jack_of_all_trades" then
		for k, v in pairs(cwBeliefs:GetBeliefs()) do
			if (v.row and v.row >= 4 and !v.subfaith) or v.isFinisher then
				if beliefs[k] then
					beliefs[k] = false;
					points = points + 1;
				end
			end
		end
		
		player:SetCharacterData("points", points);
		player:SetLocalVar("points", points);
		player:SetCharacterData("beliefs", beliefs);
		
		local level = player:GetCharacterData("level", 1);
		local levelCap = self.sacramentLevelCap;
		
		if level < levelCap --[[or subfaction == "Rekh-khet-sa"]] then
			--[[if subfaction == "Rekh-khet-sa" then
				for i = level, 6 do
					player:HandleXP(self.sacramentCosts[i] or 666);
				end
			else]]--
				for i = level, math.min(level + 6, levelCap) do
					player:HandleXP(self.sacramentCosts[i] or 666, true);
				end
			--end
		end
		
		--self:LevelUp(player);
	elseif uniqueID == "yellow_and_black" then
		if cwCharacterNeeds then
			player:SetNeed("hunger", 0);
			player:SetNeed("thirst", 0);
		end
	elseif uniqueID == "the_paradox_riddle_equation" then
		if cwMedicalSystem then
			player:TakeAllDiseases();
		end;
	end

	--local max_poise = player:GetMaxPoise();
	local max_stamina = player:GetMaxStamina();
	local max_stability = player:GetMaxStability();
	local max_health = player:GetMaxHealth();
	
	player:SetLocalVar("maxStability", max_stability);
	--player:SetLocalVar("maxMeleeStamina", max_poise);
	player:SetLocalVar("Max_Stamina", max_stamina);
	player:SetCharacterData("Max_Stamina", max_stamina);
	player:NetworkBeliefs();

	player:SetMaxHealth(max_health);
	
	if player:Health() > max_health then
		player:SetHealth(max_health);
	end
	
	if self.beliefNotifications[uniqueID] then
		Clockwork.player:Notify(player, self.beliefNotifications[uniqueID]);
	end
end

-- Called when the day/night cycle changes.
function cwBeliefs:DayNightCycleChanged(cycle)
	if cycle ~= "night" then
		for _, player in _player.Iterator() do
			if IsValid(player) then
				if player.cloaked and player:GetCharacterData("LastZone") ~= "caves" and (!cwWeather or cwWeather.weather ~= "bloodstorm") then
					if !player:GetNetVar("kinisgerCloak") then
						player:Uncloak();
					end
				end
			end
		end
	end
end

-- Called just after a player levels up.
function cwBeliefs:PlayerLevelUp(player, level, points)
	Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." just leveled up to sacrament level "..tostring(level or player:GetCharacterData("level")).."! They still have "..tostring(points).." epiphanies to spend.");
	
	-- Grock HP/Size scales with level.
	if player:GetSubfaction() == "Clan Grock" then
		player:SetMaxHealth(player:GetMaxHealth());
		
		--local scale = math.min(player:GetCharacterData("level", 1), self.sacramentLevelCap);
		local scale = math.min(player:GetCharacterData("level", 1), 40);
	
		player:SetModelScale(1 + (scale * 0.005), FrameTime());
		player:SetViewOffset(Vector(0, 0, 64 + scale / 4));
		player:SetViewOffsetDucked(Vector(0, 0, 28 + (scale / 8)));
	end
end

-- Called when a player attempts to switch to a character.
function cwBeliefs:PlayerCanSwitchCharacter(player, character)
	if (player.cloaked) then
		return "You cannot switch characters while you are cloaked!";
	end;
end;

function cwBeliefs:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if player.cloaked then
		player:Uncloak();
	end
end;

local animalModels = {
	"models/animals/deer1.mdl",
	"models/animals/goat.mdl",
	"models/animals/bear.mdl",
	"models/animal_ragd/piratecat_leopard.mdl",
	"models/begotten/creatures/wolf.mdl",
};

function cwBeliefs:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (arguments == "cwDiagnose") then
		Clockwork.player:RunClockworkCommand(player, "CharDiagnose");
	elseif (class == "prop_ragdoll" or class == "prop_physics") then
		local entityPlayer = Clockwork.entity:GetPlayer(entity);
		local trace = player:GetEyeTraceNoCursor();
		
		if (arguments == "cwCorpseMutilate") then
			if (!entityPlayer or !entityPlayer:Alive()) then
				local activeWeapon = player:GetActiveWeapon();
				local offhandWeapon;
				local weaponItemTable
				
				if activeWeapon:IsValid() then
					offhandWeapon = activeWeapon:GetOffhand();
					weaponItemTable = item.GetByWeapon(activeWeapon);
				end

				local huntingDaggerStrength
				local mutilationValue
				local conditionLoss
				local mutilationTime
				
				if weaponItemTable then
					local huntingValue = weaponItemTable.huntingValue
					if huntingValue == 1 then
						huntingDaggerStrength = 1
						mutilationValue = 1.5
						conditionLoss = 9
						mutilationTime = 15
					elseif huntingValue == 2 then
						huntingDaggerStrength = 2
						mutilationValue = 1
						conditionLoss = 4
						mutilationTime = 8
					else
						huntingDaggerStrength = 3
						mutilationValue = 1
						conditionLoss = 2
						mutilationTime = 5
					end
				end
				
				if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
					if (!entity.mutilated or entity.mutilated < 3) then
						local model = entity:GetModel();
						
						if model == "models/animals/deer1.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the stag before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if activeWeapon:IsValid() then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if huntingDaggerStrength > 1 then
											if (!entity.mutilated or entity.mutilated < 3) then
												entity.mutilated = (entity.mutilated or 0) + mutilationValue;
												
												local instance = Clockwork.item:CreateInstance("deer_meat");

												player:GiveItem(instance, true);
												player:HandleXP(self.xpValues["mutilate"]);
												player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
												Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);

												weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
											else
												Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
											end
										else
											Clockwork.player:Notify(player, "Your dagger is not strong enough to effectively mutilate this corpse!");
										end
									end
								end
							end);
						elseif model == "models/animals/goat.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the goat before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if activeWeapon:IsValid() then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + mutilationValue;
											
											local instance = Clockwork.item:CreateInstance("goat_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);

											weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the leopard before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if activeWeapon:IsValid() then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if huntingDaggerStrength > 1 then
											if (!entity.mutilated or entity.mutilated < 3) then
												entity.mutilated = (entity.mutilated or 0) + mutilationValue;
												
												local instance = Clockwork.item:CreateInstance("leopard_meat");

												player:GiveItem(instance, true);
												player:HandleXP(self.xpValues["mutilate"]);
												player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
												Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);

												weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
											else
												Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
											end
										else
											Clockwork.player:Notify(player, "Your dagger is not strong enough to effectively mutilate this corpse!");
										end
									end
								end
							end);
						elseif model == "models/begotten/creatures/wolf.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the wolf before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + mutilationValue;
											
											local instance = Clockwork.item:CreateInstance("wolf_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);

											weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif model == "models/animals/bear.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the bear before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if activeWeapon:IsValid() then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if huntingDaggerStrength >= 3 then
											if (!entity.mutilated or entity.mutilated < 3) then
												entity.mutilated = (entity.mutilated or 0) + mutilationValue;
												
												local instance = Clockwork.item:CreateInstance("bear_meat");

												player:GiveItem(instance, true);
												player:HandleXP(self.xpValues["mutilate"]);
												player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
												Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
																							
												weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
											else
												Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
											end
										else
											Clockwork.player:Notify(player, "Your dagger is not strong enough to effectively mutilate this corpse!");
										end
									end
								end
							end);
						elseif entity:GetNWEntity("Player"):IsPlayer() or entity:GetNWEntity("Player") == game.GetWorld() then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the body before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", mutilationTime, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if activeWeapon:IsValid() then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + mutilationValue;
											
											local instance = Clockwork.item:CreateInstance("humanmeat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
																						
											weaponItemTable:TakeConditionByPlayer(player, conditionLoss, true);
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						end
					else
						Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
					end;
				else
					Clockwork.player:Notify(player, "You must have a dagger equipped in order to mutilate corpses!");
				end;
			end;
		elseif (arguments == "cwEatHeart") then
			if (!entityPlayer or !entityPlayer:Alive()) then
				local model = entity:GetModel();
			
				if entity:GetNWEntity("Player"):IsPlayer() or entity:GetNWEntity("Player") == game.GetWorld() or table.HasValue(animalModels, model) then
					if (!entity.hearteaten) then
						entity.hearteaten = true;
						
						player:HandleNeed("thirst", -30);
						
						if !player:HasBelief("savage_animal") then
							player:HandleSanity(-10);
						end
						
						player:HandleXP(self.xpValues["mutilate"]);
						
						if model == "models/animals/deer1.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the stag before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/goat.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the goat before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the leopard before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/bear.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the bear before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/begotten/creatures/wolf.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the wolf before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						else
							Clockwork.chatBox:AddInTargetRadius(player, "me", "plunges their hand into the chest of the body before them, ripping out its heart and devouring it whole.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						end
						
						player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
						Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
					else
						Clockwork.player:Notify(player, "This corpse's heart has already been devoured!");
					end;
				end;
			end;
		elseif (arguments == "cwHarvestBones") then
			if (!entityPlayer or !entityPlayer:Alive()) then
				local model = entity:GetModel();
								
				if (!entity.bones or entity.bones < 4) then
					entity.bones = (entity.bones or 0) + 1;
					
					local instance = Clockwork.item:CreateInstance("human_bone");

					player:GiveItem(instance, true);
					player:HandleXP(math.Round(self.xpValues["mutilate"] / 2));
					
					if model == "models/animals/deer1.mdl" then
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the stag before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					elseif model == "models/animals/goat.mdl" then
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the goat before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the leopard before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					elseif model == "models/animals/bear.mdl" then
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the bear before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					elseif model == "models/begotten/creatures/wolf.mdl" then
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the wolf before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					else
						Clockwork.chatBox:AddInTargetRadius(player, "me", "uses their hands to dig into the flesh of the body before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					end
					
					player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
					Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
				else
					Clockwork.player:Notify(player, "This corpse has already been harvested of all its bones!");
				end;
			end;
		elseif (arguments == "cwCorpseSkin") then
			if table.HasValue(animalModels, entity:GetModel()) then
				local activeWeapon = player:GetActiveWeapon();
				local offhandWeapon;
				local weaponItemTable
				
				if activeWeapon:IsValid() then
					offhandWeapon = activeWeapon:GetOffhand();
					weaponItemTable = item.GetByWeapon(activeWeapon);
				end

				local huntingDaggerStrength
				local skinningValue
				local skinningConditionLoss
				local skinningTime
				
				if weaponItemTable then
					local huntingValue = weaponItemTable.huntingValue
					if huntingValue == 1 then
						huntingDaggerStrength = 1
						skinningValue = 40
						skinningConditionLoss = 12
						skinningTime = 15
					elseif huntingValue == 2 then
						huntingDaggerStrength = 2
						skinningValue = 75
						skinningConditionLoss = 6
						skinningTime = 8
					else
						huntingDaggerStrength = 3
						skinningValue = 100
						skinningConditionLoss = 4
						skinningTime = 5
					end
				end
				 
				if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger and weaponItemTable then
					if (!entity.skinned or entity.skinned < 1) then
						local model = entity:GetModel();
						local uniqueID = "hide"
						local requiredDaggerStrength
						
						if model == "models/animals/deer1.mdl" then
							requiredDaggerStrength = 2
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the stag before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/goat.mdl" then
							requiredDaggerStrength = 1
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the goat before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
							requiredDaggerStrength = 2
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the leopard before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/begotten/creatures/wolf.mdl" then
							requiredDaggerStrength = 1
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the wolf before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/bear.mdl" then
							requiredDaggerStrength = 3	
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the bear before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							uniqueID = "bearskin";
						end
						
						Clockwork.player:SetAction(player, "skinning", skinningTime, 5, function()
							if IsValid(player) and IsValid(entity) then
								local activeWeapon = player:GetActiveWeapon();
								local offhandWeapon;
								
								if activeWeapon:IsValid() then
									offhandWeapon = activeWeapon:GetOffhand();
								end
								
								if activeWeapon:IsValid() and activeWeapon.isDagger or offhandWeapon and offhandWeapon.isDagger then
									if requiredDaggerStrength <= huntingDaggerStrength then
										if (!entity.skinned or entity.skinned < 1) then
											entity.skinned = (entity.skinned or 0) + 1;
																					
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												local instance = Clockwork.item:CreateInstance(uniqueID);
												local daggerCondition = weaponItemTable:GetCondition()
												
												if daggerCondition <= 90 then
													instance:SetCondition(skinningValue - ((math.abs(daggerCondition - 100)) * 0.7))
												else
													instance:SetCondition(skinningValue)
												end

												player:GiveItem(instance, true);
												player:HandleXP(self.xpValues["mutilate"] * 2);
												player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
												Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
												entity:SetMaterial("models/flesh");
												
												weaponItemTable:TakeConditionByPlayer(player, skinningConditionLoss, true);
											end
										else
											Clockwork.player:Notify(player, "This corpse has already been skinned!");
										end
									else
										Clockwork.player:Notify(player, "Your dagger is not strong enough to pierce this creature's hide!");
									end
								end
							end
						end);
					else
						Clockwork.player:Notify(player, "This corpse has already been skinned!");
					end;
				else
					Clockwork.player:Notify(player, "You must have a dagger equipped in order to skin this animal!");
				end;
			end;
		end
	end;
end;

function cwBeliefs:LockpickFinished(player, entity)
	if IsValid(player) and IsValid(entity) then
		if entity.cwLockTier and !entity.cwPassword then
			if cwItemSpawner and cwItemSpawner.SuperCrate and entity == cwItemSpawner.SuperCrate.supercrate then
				player:HandleXP(150);
			elseif entity.cwLockTier == 1 then
				player:HandleXP(8);
			elseif entity.cwLockTier == 2 then
				player:HandleXP(15);
			elseif entity.cwLockTier == 3 then
				player:HandleXP(35);
			end
		end
	end
end

-- Called when a player should take damage.
function cwBeliefs:PlayerShouldTakeDamage(player, attacker)
	if (player.distortedRingFired) then
		return false;
	end;
end

-- Called when an entity has taken damage.
function cwBeliefs:EntityTakeDamageNew(entity, damageInfo)
	-- I'm also putting the code for charm effects in here because I'm lazy.
	if (Clockwork.entity:IsPlayerRagdoll(entity)) then
		entity = Clockwork.entity:GetPlayer(entity);
	end;

	if entity:IsPlayer() or entity:IsNPC() or entity:IsNextBot() or entity.isTrainingDummy then
		local entTab = entity:GetTable();
		local originalDamage = damageInfo:GetDamage() or 0;
		
		if originalDamage == 0 then
			return;
		end
		
		local newDamage = originalDamage;
		
		if entity:IsPlayer() and entity:Alive() and !entity.flagellating then
			local chance = 0;
			
			if entity:HasBelief("lucky") then
				chance = chance + 5;
			end
			
			if entity.GetCharmEquipped and entity:GetCharmEquipped("ring_distorted") then
				chance = chance + 5;
			end
			
			if chance > 0 then
				if math.random(1, math.Round(100 / chance)) == 1 then
					if !entity.iFrames then
						if IsValid(attacker) and attacker:IsPlayer() then
							for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
								if v:IsPlayer() then
									Clockwork.chatBox:Add(v, attacker, "me", "'s blow against "..Clockwork.player:FormatRecognisedText(v, "%s", entity).." is deflected at the last moment by an invisible force!");
								end
							end
						else
							for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
								if v:IsPlayer() then
									Clockwork.chatBox:Add(v, entity, "me", "'s damage is deflected at the last moment by an invisible force!");
								end
							end
						end

						entity:EmitSound("meleesounds/comboattack3.wav.mp3");
						damageInfo:SetDamage(0);
						return true;
					end
				end
			end
		end
		
		if entity.ravenBuff and !entity.iconoclastBuff then
			newDamage = newDamage * 0.9
		end
		
		if entity.iconoclastBuff then
			newDamage = newDamage * 0.75
		end
		
		local attacker = damageInfo:GetAttacker();
		
		if (attacker:IsPlayer()) then
			local attackerWeapon = damageInfo:GetInflictor();
			
			if !attackerWeapon then
				attackerWeapon = attacker:GetActiveWeapon();
			end
			
			if attackerWeapon then
				if damageInfo:GetInflictor().isJavelin then
					if damageInfo:GetInflictor():GetClass() == "begotten_javelin_throwing_axe_thrown" or damageInfo:GetInflictor():GetClass() == "begotten_javelin_axehill_thrown" then
						if attacker:HasBelief("daring_trout") then
							newDamage = newDamage * 1.25;
						elseif attacker:HasBelief("fearsome_wolf") then
							newDamage = newDamage * 1.15;
						end
					end
				end
				
				if entity:IsPlayer() and entity:Alive() and attacker:HasBelief("assassin") then
					if not entity.assassinated then
						if attackerWeapon.isDagger then
							if entity:Alive() and entity:Health() < entity:GetMaxHealth() / 4 or entity:GetRagdollState() == RAGDOLL_FALLENOVER and originalDamage > 0 then
								newDamage = 666;
								
								if entity:Health() - newDamage < 10 then
									local hatred = entity:GetNetVar("Hatred");
									
									if hatred and hatred >= 100 then
										if !entity.opponent then
											entity:SetCharacterData("Hatred", 0);
										end
										
										entity:SetLocalVar("Hatred", 0);
										entity:Extinguish();
										
										local strikeText = "efficiently strikes out at";
										
										if attackerWeapon.isJavelin and attackerWeapon.Base ~= "sword_swepbase" then
											strikeText = "efficiently throws a dagger at";
										end

										for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
											if v:IsPlayer() then
												Clockwork.chatBox:Add(v, attacker, "me", strikeText.." a pressure point of "..Clockwork.player:FormatRecognisedText(v, "%s", entity)..", but their hatred is so strong that they simply refuse to die!");
												if entity:GetGender() == GENDER_MALE then
													entity:EmitSound("misc/attack_01.ogg", 90, math.random(55,70))
												else
													entity:EmitSound("misc/attack_01.ogg", 90, math.random(100,120))
												end	
											end
										end
										
										if cwMedicalSystem then
											entity.nextBleedPoint = CurTime() + 180;
										end
										
										if entity.poisonTicks then
											entity.poisonTicks = nil;
										end
										
										-- Add a 1 second delay to taking more damage.
										entTab.distortedRingFired = true;
										
										timer.Create("DistortedRingTimer_"..entity:EntIndex(), 1, 1, function()
											if IsValid(entity) then
												entity.distortedRingFired = nil;
											end
										end);
										
										damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
										return;
									end
								
									local itemTable = entity:GetCharmEquipped("ring_distorted");
									
									if itemTable and !entTab.distortedRingFiredDuel then
										if !cwRituals or (cwRituals and !entTab.scornificationismActive) or (!attacker:IsNPC() and !attacker:IsNextBot() and !attacker:IsPlayer()) then
											if !entTab.opponent then
												itemTable:OnPlayerUnequipped(entity);
												entity:TakeItem(itemTable, true);
											end
											
											entTab.distortedRingFired = true;
											
											if entTab.opponent then
												entTab.distortedRingFiredDuel = true;
											end
											
											timer.Create("DistortedRingTimer_"..entity:EntIndex(), 1, 1, function()
												if IsValid(entity) then
													entity.distortedRingFired = nil;
												end
											end);
											
											entity:EmitSound("physics/metal/metal_grate_impact_hard3.wav");
											entity:Extinguish();
											
											local strikeText = "efficiently strikes out at";
											
											if attackerWeapon.isJavelin then
												strikeText = "efficiently throws a dagger at";
											end
											
											for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
												if v:IsPlayer() then
													Clockwork.chatBox:Add(v, attacker, "me", strikeText.." a pressure point of "..Clockwork.player:FormatRecognisedText(v, "%s", entity)..", but their dagger is deflected at the last moment by an invisible force!");
												end
											end
											
											Clockwork.player:Notify(entity, "Your Distorted Ring shatters and releases a tremendous amount of energy, giving you one last chance at life!");
											
											if cwMedicalSystem then
												entTab.nextBleedPoint = CurTime() + 180;
											end
											
											if entTab.poisonTicks then
												entTab.poisonTicks = nil;
											end
											
											damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
											return;
										end
									end
								end

								entity:EmitSound("meleesounds/kill"..math.random(1, 2)..".wav.mp3");
								
								local strikeText = "efficiently strikes out at";
								
								if attackerWeapon.isJavelin then
									strikeText = "efficiently throws a dagger at";
								end
								
								if entity.soulscorchActive then
									Clockwork.chatBox:AddInTargetRadius(attacker, "me", strikeText.." a pressure point of "..entity:Name()..", snuffing out their Holy Light with dark magic and killing them instantly!", attacker:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
									
									entity.soulscorchActive = nil;
									entity:SetNetVar("soulscorchActive", false);
									
									if timer.Exists("SoulScorchTimer_"..entity:EntIndex()) then
										timer.Remove("SoulScorchTimer_"..entity:EntIndex());
									end
								else
									Clockwork.chatBox:AddInTargetRadius(attacker, "me", strikeText.." a pressure point of "..entity:Name()..", killing them instantly!", attacker:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								end
								
								-- According to gabs the /me can play twice for some reason, so I'm just making sure it doesn't.
								entity.assassinated = true;

								timer.Simple(1, function()
									if IsValid(entity) then
										entity.assassinated = false;
									end
								end);
							end
						end
					end
				end
				
				local isMelee = (attackerWeapon.Base == "sword_swepbase" or (attackerWeapon.Base == "begotten_firearm_base" and attackerWeapon.isMeleeFirearm and attacker:GetNetVar("ThrustStance")));
				
				if isMelee or attackerWeapon.isJavelin then
					if damageInfo:IsDamageType(16) then
						if entity:IsPlayer() and entity:Alive() and attacker:HasBelief("survivalist") then
							if originalDamage > 0 then
								entity.poisonTicks = math.random(5, 7);
								entity.poisoner = attacker;
								entity.poisoninflictor = inflictor;
							end
						end
					end
				end
			
				if isMelee then
					if attacker:GetCharmEquipped() then
						if attackerWeapon:GetClass() == "begotten_fists" then
							if IsValid(damageInfo:GetInflictor()) and damageInfo:GetInflictor().isJavelin then
								-- nothing
							else
								if attacker:GetCharmEquipped("ring_pugilist") then
									-- AP handled in clothes sv_plugin
									newDamage = newDamage + (originalDamage * 3);
								end
							end
						end
						
						if attacker:GetCharmEquipped("ring_fire") then
							if math.random(1, 20) == 1 then
								if originalDamage > 0 and !entity.poisonTicks then
									local ignition_time = 3;
									
									entity:Ignite(ignition_time);
									
									-- Failsafe to ensure the fire goes out.
									timer.Simple(ignition_time, function()
										if IsValid(entity) then
											entity:Extinguish();
										end
									end);
								end
							end
						end
					end
					
					local clothesItem = attacker:GetClothesEquipped();
					
					if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "godless") then
						local enemywep = attacker:GetActiveWeapon();
						
						if attacker:Sanity() <= 40 and enemywep:GetNW2String("activeShield"):len() <= 0 then
							newDamage = newDamage + (originalDamage * 0.25);
						end
					end
					
					if attacker:HasBelief("bestial") then
						if attacker:Sanity() <= 40 then
							newDamage = newDamage + (originalDamage * 0.1);
						end
					end
					
					if attacker:HasBelief("fanaticism") then
						local health = attacker:Health();
						local maxHealth = attacker:GetMaxHealth();
						local lowerBound = maxHealth * 0.1;
						local modifier = math.Clamp(-(((health - lowerBound) / (maxHealth - lowerBound)) - 1), 0, 1);
						local bonus = 0.5 * modifier;
						
						newDamage = newDamage + (originalDamage * bonus);
					end
					
					if attacker:HasBelief("unending_dance") then
						if entity:IsPlayer() then
							local sanity = entity:Sanity();
							
							if sanity <= 90 then
								if sanity <= 10 then
									newDamage = newDamage + (originalDamage * 0.70);
								else
									local modifier = 90 - (sanity + 10);
									local bonus = 0.01 * modifier;
									
									newDamage = newDamage + (originalDamage * bonus);
								end
							end
						end
					end
				
					if attacker:HasBelief("blademaster") then
						local attackTable = GetTable(attackerWeapon.AttackTable);
						
						if (string.find(attackerWeapon.Category, "One Handed") and attackTable.dmgtype == 4) or string.find(attackerWeapon.Category, "Claws") then
							newDamage = newDamage + (originalDamage * 0.15);
						end
					end
					
					if attacker:HasBelief("unrelenting") then
						if string.find(attackerWeapon.Category, "Two Handed") or string.find(attackerWeapon.Category, "Great Weapon") or string.find(attackerWeapon.Category, "Scythe") then
							newDamage = newDamage + (originalDamage * 0.10);
						end
					end
					
					if attacker:HasBelief("might") then
						if string.find(attackerWeapon.Category, "Fisted") then
							newDamage = newDamage + (originalDamage * 0.20);
						end
					end
					
					if entity:IsPlayer() and (attackerWeapon.isElectric or (attackerWeapon.isVoltistWeapon and attacker:HasBelief("the_storm"))) then
						local clothesItem = entity:GetClothesEquipped();
						
						if clothesItem and (clothesItem.type == "chainmail" or clothesItem.type == "plate") then
							if clothesItem.weightclass == "Light" then
								newDamage = newDamage + (originalDamage * 0.4);
								entity:TakeStability(5);
							elseif clothesItem.weightclass == "Medium" then
								newDamage = newDamage + (originalDamage * 0.6);
								entity:TakeStability(15);
							else
								newDamage = newDamage + originalDamage;
								entity:TakeStability(25);
							end
							
							Schema:DoTesla(entity, false);
						end
						
						if cwWeather and cwWeather.weather == "rainstorm" or cwWeather.weather == "bloodstorm" or cwWeather.weather == "acidrain" then
							local lastZone = entity:GetCharacterData("LastZone");
							local zoneTable = zones:FindByID(lastZone);
							
							if zoneTable and zoneTable.hasWeather then
								if cwWeather:IsOutside(entity:EyePos()) then
									newDamage = newDamage + (originalDamage * 0.5);
								
									Schema:DoTesla(entity, false);
								end
							end
						end
					end
					
					if attacker.decapitationBuff then
						newDamage = newDamage + (newDamage * 0.2);
					end
					
					if attacker:GetNetVar("druidStaffActive") then
						if attacker:GetActiveWeapon():GetClass() == "begotten_2h_quarterstaff" then
							newDamage = newDamage + 25;
						end
					end
					
				elseif attackerWeapon.Base == "begotten_firearm_base" or (attackerWeapon.isMeleeFirearm and !attacker:GetNetVar("ThrustStance")) then -- Firearm
					if !attackerWeapon.notPowder and attacker:HasBelief("blessed_powder") then
						newDamage = newDamage + (originalDamage * 0.30);
					end
					
					if entity:IsPlayer() and (attackerWeapon.isElectric or (attackerWeapon.isVoltistWeapon and attacker:HasBelief("the_storm"))) then
						local clothesItem = entity:GetClothesEquipped();
						
						if clothesItem and (clothesItem.type == "chainmail" or clothesItem.type == "plate") then
							if clothesItem.weightclass == "Light" then
								newDamage = newDamage + (originalDamage * 0.4);
								entity:TakeStability(5);
							elseif clothesItem.weightclass == "Medium" then
								newDamage = newDamage + (originalDamage * 0.6);
								entity:TakeStability(15);
							else
								newDamage = newDamage + originalDamage;
								entity:TakeStability(25);
							end
							
							Schema:DoTesla(entity, false);
						end
						
						if cwWeather and cwWeather.weather == "rainstorm" or cwWeather.weather == "bloodstorm" or cwWeather.weather == "acidrain" then
							local lastZone = entity:GetCharacterData("LastZone");
							local zoneTable = zones:FindByID(lastZone);
							
							if zoneTable and zoneTable.hasWeather then
								if cwWeather:IsOutside(entity:EyePos()) then
									newDamage = newDamage + (originalDamage * 0.5);
								
									Schema:DoTesla(entity, false);
								end
							end
						end
					end
				end
			end
			
			if entity:IsPlayer() then
				if attackerWeapon then
					if attacker:HasBelief("manifesto") then
						if entity:GetFaith() == attacker:GetFaith() then
							newDamage = newDamage - (originalDamage * 0.1);
						elseif attackerWeapon.Base ~= "begotten_firearm_base" or (attackerWeapon.isMeleeFirearm and player:GetNetVar("ThrustStance")) or attackerWeapon.notPowder then
							newDamage = newDamage + (originalDamage * 0.2);
						end
					end
				end

				if attacker:GetCharmEquipped("holy_sigils") or attacker:GetCharmEquipped("codex_solis") then
					if entity:GetFaith() ~= attacker:GetFaith() then
						newDamage = newDamage + (originalDamage * 0.15);
					end
				end
				
				if attacker:HasBelief("taste_of_blood") then
					if attacker.tasteOfBloodVictim then
						if timer.Exists("tasteOfBloodTimer"..tostring(attacker:EntIndex())) then
							timer.Destroy("tasteOfBloodTimer"..tostring(attacker:EntIndex()));
						end
					
						if attacker.tasteOfBloodVictim == entity then
							newDamage = newDamage + (originalDamage * 0.15);
						end
					end
					
					attacker.tasteOfBloodVictim = entity;
					
					timer.Create("tasteOfBloodTimer"..tostring(attacker:EntIndex()), 180, 1, function()
						if IsValid(attacker) then
							attacker.tasteOfBloodVictim = nil;
						end
					end);
					
					netstream.Start(attacker, "TasteofBloodHighlight", entity);
				end
				
				if attacker.warCryVictims and table.HasValue(attacker.warCryVictims, entity) then
					if attacker:HasBelief("deceitful_snake") then
						newDamage = newDamage + (originalDamage * 0.25);
					elseif attacker:HasBelief("fearsome_wolf") then
						newDamage = newDamage + (originalDamage * 0.2);
					end
				end
			elseif entity:IsNextBot() or entity:IsNPC() then
				if attacker.warCryVictims and table.HasValue(attacker.warCryVictims, entity) then
					if attacker:HasBelief("fearsome_wolf") then
						newDamage = newDamage + (originalDamage * 0.2);
					end
				end
			end
			
			if attacker:HasBelief("thirst_blood_moon") then
				if (entity:IsPlayer() and entity:Alive()) then
					local lastZone = attacker:GetCharacterData("LastZone");
					
					if lastZone == "wasteland" and ((cwDayNight and cwDayNight.currentCycle == "night") or (cwWeather and cwWeather.weather == "bloodstorm")) then
						if cwMedicalSystem and newDamage >= 25 then
							local rand = math.random(1, 5);
							
							if rand == 1 then
								attacker:StopAllBleeding();
								Clockwork.player:Notify(attacker, "You feel the power of the Blood Moon flow through your very soul! Your mortal vessel suddenly stops bleeding.");
							elseif rand == 5 then
								attacker:ResetInjuries();
								Clockwork.player:Notify(attacker, "You feel the power of the Blood Moon flow through your very soul! Your mortal vessel suddenly heals of its injuries.");
							end
						end
					end
				end
			end
		end;
		
		if entity:IsPlayer() then
			if damageInfo:IsDamageType(DMG_BURN) then
				if IsValid(attacker) and attacker:GetClass() == "entityflame" then
					if !entity:HasBelief("taste_of_iron") then
						newDamage = newDamage + originalDamage;
					end
				else
					if entity:HasBelief("taste_of_iron") then
						newDamage = newDamage - (originalDamage * 0.5);
					end
				end
				
				if entity:GetCharmEquipped("smoldering_head") then
					newDamage = newDamage - (originalDamage * 0.5);
				end
				
				if entity:HasBelief("extinctionist") then
					newDamage = newDamage * 0.5;
				end
			end
		
			if entity:GetCharmEquipped("ring_protection_gold") then
				newDamage = newDamage - (originalDamage * 0.18);
			elseif entity:GetCharmEquipped("ring_protection_silver") then
				newDamage = newDamage - (originalDamage * 0.10);
			elseif entity:GetCharmEquipped("ring_protection_bronze") then
				newDamage = newDamage - (originalDamage * 0.05);
			end
		end
		
		newDamage = math.max(newDamage, 0);
		
		damageInfo:SetDamage(newDamage);
	end;
end;

-- Called after all armor and melee effects have been created.
function cwBeliefs:FuckMyLife(entity, damageInfo)
	local attacker = damageInfo:GetAttacker();
	local damage = damageInfo:GetDamage() or 0;
	local entTab = entity:GetTable();
	
	if (attacker:IsPlayer()) then
		if entity:IsPlayer() and not entTab.cwWakingUp then
			if damage > 0 then
				if attacker:IsOnFire() and attacker:HasBelief("extinctionist") then
					local inflictor = damageInfo:GetInflictor();
					
					if IsValid(inflictor) and inflictor.IsABegottenMelee then
						entity:Ignite(4);
					end
				end
			end
		
			if damage >= 10 then
				if entity:HasBelief("deceitful_snake") then
					if !entTab.warCryVictims then
						entTab.warCryVictims = {};
					end
					
					if not table.HasValue(entTab.warCryVictims, attacker) then
						table.insert(entTab.warCryVictims, attacker);
					end
				
					netstream.Start(entity, "DeceitfulHighlight", attacker);
					
					if timer.Exists("deceitfulSnakeTimer_"..attacker:EntIndex()..entity:EntIndex()) then
						timer.Destroy("deceitfulSnakeTimer_"..attacker:EntIndex()..entity:EntIndex());
					end
					
					timer.Create("deceitfulSnakeTimer_"..attacker:EntIndex()..entity:EntIndex(), 40.5, 1, function()
						if IsValid(entity) then
							if entTab.warCryVictims then
								if table.HasValue(entTab.warCryVictims, attacker) then
									table.RemoveByValue(entTab.warCryVictims, attacker);
								end
								
								if table.IsEmpty(entTab.warCryVictims) then
									entTab.warCryVictims = nil;
								end
							end
						end
					end);
				end
			end
			
			if not attacker.opponent and (entity:CharPlayTime() > config.GetVal("min_xp_charplaytime") or entity:IsAdmin()) and attacker ~= entity then
				if !cwRituals or (cwRituals and !entTab.scornificationismActive) then
					local attackerFaction = attacker:GetFaction();
					local attackerFactionTable = Clockwork.faction:FindByID(attackerFaction);
					
					if attackerFactionTable then
						local playerFaction = entity:GetFaction();
						local kinisgerOverride = entity:GetNetVar("kinisgerOverride");
						
						if kinisgerOverride and attackerFaction ~= "Children of Satan" then
							playerFaction = kinisgerOverride;
						end
						
						-- Make sure players can't get XP from damaging the same faction as them!
						if ((attackerFaction ~= playerFaction and (!attackerFactionTable.alliedfactions or !table.HasValue(attackerFactionTable.alliedfactions, playerFaction))) or attackerFaction == "Wanderer") and (attacker:GetSubfaith() ~= "Voltism" or entity:GetSubfaith() ~= "Voltism") then
							local subfaction = attacker:GetSubfaction();
							local damageXP = math.min(damage, entity:Health()) * self.xpValues["damage"];
							
							damageXP = damageXP * math.Clamp(entity:GetCharacterData("level", 1), 1, 40);
							
							if attacker:HasBelief("father") then
								if attacker:GetCharacterData("level", 1) < entity:GetCharacterData("level", 1) then
									damageXP = damageXP * 2;
								end
							elseif attacker:HasBelief("sister") then
								if attacker:GetCharacterData("level", 1) > entity:GetCharacterData("level", 1) then
									damageXP = damageXP * 2;
								end
							end
							
							if (attacker:GetFaction() == "Gatekeeper" and subfaction == "Legionary") or (attacker:GetFaction() == "Hillkeeper" and subfaction == "Watchman") or (attacker:GetFaction() == "Children Of Satan" and subfaction == "Crypt Walkers") then
								damageXP = damageXP * 2;
							end
						
							attacker:HandleXP(damageXP);
						end
					end
				end
			end
		end
	end
	
	if damage > 1 and damage < entity:Health() then
		if entity:IsPlayer() and !entTab.opponent and entity:GetSubfaith() == "Sol Orthodoxy" then
			if !cwRituals or (cwRituals and !entTab.scornificationismActive) then
				entity:HandleXP(damage / 2);
				
				if cwStamina and entity.flagellating then
					local activeWeapon = entity:GetActiveWeapon();
					
					if activeWeapon:IsValid() and (activeWeapon:GetClass() == "begotten_1h_ironflail" or activeWeapon:GetClass() == "begotten_1h_solflail" or activeWeapon:GetClass() == "begotten_2h_great_eveningstar") then -- Punisher attribute
						entity:HandleStamina(damage * 4);
					else
						entity:HandleStamina(damage * 2);
					end
				end
			end
		end
	end
	
	if entity:IsPlayer() and damage > 0 then
		if entity:HasBelief("deceitful_snake") then
			if !entity.deceitfulLastDamages then
				entity.deceitfulLastDamages = {};
			end
			
			table.insert(entity.deceitfulLastDamages, {damageTime = CurTime(), damage = damage});
		end
		
		if not entTab.opponent and damageInfo:IsDamageType(DMG_BURN) then
			if cwCharacterNeeds then
				if entity:HasBelief("prison_of_flesh") then
					if entity:HasTrait("possessed") then
						local corruption = entity:GetNeed("corruption");
						local reduction = math.max(-damage, -(math.max(corruption, 50) - 50));

						entity:HandleNeed("corruption", reduction);
					else
						entity:HandleNeed("corruption", -damage);
					end
				end
			end
		end
	end
	
	if damage > 0 then
		if entity:IsPlayer() and not entTab.cwWakingUp then
			local clothesItem = entity:GetClothesEquipped();
			if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "solblessed") then
				local hatred = math.min(entity:GetNetVar("Hatred", 0) + (math.min(entity:Health(), math.Round(damage / 1.5))), 100);
				
				if !entTab.opponent then
					entity:SetCharacterData("Hatred", hatred);
				end
				
				entity:SetLocalVar("Hatred", hatred);
			end
		end
		
		if IsValid(attacker) and attacker:IsPlayer() then
				local enemywep = attacker:GetActiveWeapon();
			
				local helmetItem = attacker:GetHelmetEquipped();
				-- If a beserker or a member of House Varazdat, gain HP back via lifeleech.
				if attacker:GetSubfaction() == "Varazdat" or (helmetItem and helmetItem.attributes and table.HasValue(helmetItem.attributes, "lesserlifeleech") and IsValid(enemywep) and enemywep:GetNW2String("activeShield"):len() <= 0) then
					if IsValid(enemywep) and enemywep.IsABegottenMelee then
						local clothesItem = attacker:GetClothesEquipped();
						local modifier = 1.45;

						if clothesItem then
							if clothesItem.weightclass == "Medium" then
								modifier = 2;
							elseif clothesItem.weightclass == "Heavy" then
								modifier = 3.25;
							end
						end
						
						attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + (damageInfo:GetDamage() / modifier)), 0, attacker:GetMaxHealth()));
						
						attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(attacker) then
								attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				else
					if IsValid(enemywep) and enemywep.IsABegottenMelee and enemywep:GetNW2String("activeShield"):len() <= 0 then
						local clothesItem = attacker:GetClothesEquipped();
						
						if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "lifeleech") then
							attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + damageInfo:GetDamage()), 0, attacker:GetMaxHealth()));
							
							attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
							
							timer.Simple(0.2, function()
								if IsValid(attacker) then
									attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
								end
							end);
						end
					end
				end
				
				if attacker:HasBelief("thirst_blood_moon") and !attacker.opponent then
					local lastZone = attacker:GetCharacterData("LastZone");
					
					if (lastZone == "wasteland" and ((cwDayNight and cwDayNight.currentCycle == "night") or (cwWeather and cwWeather.weather == "bloodstorm"))) or lastZone == "caves"  then
						attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + (damageInfo:GetDamage() / 2)), 0, attacker:GetMaxHealth()));
						
						attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(attacker) then
								attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				end
			end
		
		local action = Clockwork.player:GetAction(entity);
		
		if action == "reloading" or action == "heal" or action == "healing" then
			Clockwork.player:ExtendAction(entity, math.max(0.5, damage / 10));
		elseif action == "pickupragdoll" or action == "pickupobject" then
			Clockwork.player:SetAction(entity, false);
		end
		
		local holdingEnt = entity:GetHoldingEntity();

		if IsValid(holdingEnt) then
			if holdingEnt:GetClass() ~= "prop_ragdoll" or !entity:HasBelief("prowess_finisher") then
				cwPickupObjects:ForceDropEntity(entity);
			end
		end
	end

	if entity:Alive() then
		if entity:Health() - damage < 10 then
			local hatred = entity:GetNetVar("Hatred");
			
			if hatred and hatred >= 100 then
				if !cwRituals or (cwRituals and !entTab.scornificationismActive) or (!attacker:IsNPC() and !attacker:IsNextBot() and !attacker:IsPlayer()) then
					if !entTab.opponent then
						entity:SetCharacterData("Hatred", 0);
					end
					
					entity:SetLocalVar("Hatred", 0);
					entity:Extinguish();

					Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s hatred is so strong that they simply refuse to die yet!", entity:GetPos(), config.Get("talk_radius"):Get() * 2);
					if entity:GetGender() == GENDER_MALE then
						entity:EmitSound("misc/attack_01.ogg", 90, math.random(55,70))
					else
						entity:EmitSound("misc/attack_01.ogg", 90, math.random(100,120))
					end
					
					if cwMedicalSystem then
						entTab.nextBleedPoint = CurTime() + 180;
					end
					
					if entTab.poisonTicks then
						entTab.poisonTicks = nil;
					end
					
					-- Add a 1 second delay to taking more damage.
					entTab.distortedRingFired = true;
					
					timer.Create("DistortedRingTimer_"..entity:EntIndex(), 1, 1, function()
						if IsValid(entity) then
							entity.distortedRingFired = nil;
						end
					end);
					
					damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
					return;
				end
			end
		end
		
		if entity:Health() - damage < 10 then
			local itemTable = entity:GetCharmEquipped("ring_distorted");
			
			if itemTable and !entTab.distortedRingFiredDuel then
				if !cwRituals or (cwRituals and !entTab.scornificationismActive) or (!attacker:IsNPC() and !attacker:IsNextBot() and !attacker:IsPlayer()) then
					if !entTab.opponent then
						itemTable:OnPlayerUnequipped(entity);
						entity:TakeItem(itemTable, true);
					end
					
					entTab.distortedRingFired = true;
					
					if entTab.opponent then
						entTab.distortedRingFiredDuel = true;
					end
					
					timer.Create("DistortedRingTimer_"..entity:EntIndex(), 1, 1, function()
						if IsValid(entity) then
							entity.distortedRingFired = nil;
						end
					end);

					entity:EmitSound("physics/metal/metal_grate_impact_hard3.wav");
					entity:Extinguish();
					
					Clockwork.player:Notify(entity, "Your Distorted Ring shatters and releases a tremendous amount of energy, giving you one last chance at life!");
					
					if cwMedicalSystem then
						entTab.nextBleedPoint = CurTime() + 180;
					end
					
					if entTab.poisonTicks then
						entTab.poisonTicks = nil;
					end
					
					damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
					return;
				end
			end

			if !entTab.scornificationismActive and !entTab.opponent and entity:HasBelief("fortitude_finisher") then
				local action = Clockwork.player:GetAction(entity);
			
				if (action != "die") and (action != "die_bleedout") then
					--[[entity:ConCommand("+duck");
					entity:SetCrouchedWalkSpeed(0.1);]]--
					
					Clockwork.player:SetRagdollState(entity, RAGDOLL_KNOCKEDOUT, nil, nil);

					-- Character already has believer's perseverance if they have the fortitude finisher.
					Clockwork.player:SetAction(entity, "die", 240, 1, function()
						if (IsValid(entity) and entity:Alive()) then
							local bloodLevel = entity:GetCharacterData("BloodLevel", self.maxBloodLevel);
							
							--if (bloodLevel <= self.lethalBloodLoss) then
								entity:DeathCauseOverride("Bled out in a puddle of their own blood.");
								entity:Kill();
								
								Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, entity:Name().." has bled out!")
								--entity:TakeDamage(99999, entity, entity);
								--entity:SetCrouchedWalkSpeed(1);
							--[[else
								Clockwork.player:SetAction(entity, "unragdoll", 180, 1, function() end);
								Clockwork.player:SetRagdollState(entity, RAGDOLL_KNOCKEDOUT, nil, 180);
								--entity:ConCommand("-duck");
								--entity:SetCrouchedWalkSpeed(1);
							end;]]--
						end;
					end);
					
					damageInfo:SetDamage(math.max(entity:Health() - 5, 0));
					return;
				end;
			end;
		end
	end
end

local decapitationStrings = {
	"violently decapitates",
	"beheads",
	"takes the head of",
	"chops off the head of",
};

local decapitationSuffixes = {
	"sending their head flying off in an arc",
	"sending their head up in the air",
	"leaving nothing but a bloody stump",
};

function cwBeliefs:DoPlayerDeathPreDeathSound(player, attacker, damageInfo)
	if(player:GetCharacterData("isThrall")) then return; end
	
	if IsValid(attacker) and attacker:IsPlayer() and attacker:HasBelief("headtaker") then
		local ragdollEntity = player:GetRagdollEntity();
		
		if (IsValid(ragdollEntity) and Clockwork.kernel:GetRagdollHitGroup(ragdollEntity, damageInfo:GetDamagePosition()) == HITGROUP_HEAD)
		or Clockwork.kernel:GetRagdollHitGroup(player, damageInfo:GetDamagePosition()) == HITGROUP_HEAD then
			if damageInfo:GetDamage() >= 30 and damageInfo:GetDamageType() == DMG_SLASH then
				local defaultModel = player:GetDefaultModel();
				
				if string.find(defaultModel, "models/begotten/heads") then
					local head_suffixes = {"_glaze", "_gore", "_satanist", "_wanderer"};
					local headModel = defaultModel;
					
					for i, v in ipairs(head_suffixes) do
						headModel = string.gsub(headModel, v, "_decapitated");
					end

					local headEnt = ents.Create("prop_physics");
					
					if IsValid(ragdollEntity) then
						local headBone = ragdollEntity:LookupBone("ValveBiped.Bip01_Head1");
						local headBonePos, headBoneAng;
						
						if (headBone) then
							headBonePos, headBoneAng = ragdollEntity:GetBonePosition(headBone);
						end
						
						if headBonePos and headBoneAng then
							headEnt:SetPos(headBonePos + Vector(0, 0, 8));
							headEnt:SetAngles(headBoneAng);
						else
							headEnt:SetPos(player:EyePos());
							headEnt:SetAngles(player:EyeAngles());
						end
					else
						headEnt:SetPos(player:EyePos());
						headEnt:SetAngles(player:EyeAngles());
					end
					
					headEnt:SetModel(headModel);
					headEnt:SetSkin(player:GetSkin());
					headEnt:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
					headEnt:Spawn();

					local physicsObject = headEnt:GetPhysicsObject();
					
					if IsValid(physicsObject) then
						physicsObject:SetVelocity(player:GetVelocity() + (player:GetUp() * 250));
						physicsObject:SetAngleVelocity(VectorRand() * 66);
					end
					
					if !player.opponent then
						local helmetItem = player:GetHelmetEquipped();
						
						if helmetItem then
							if hook.Run("PlayerCanDropWeapon", player, helmetItem, NULL, true) then
								if !helmetItem.attributes or !table.HasValue(helmetItem.attributes, "not_unequippable") then
									helmetItem:TakeCondition(math.random(20, 40));
								end
							
								local entity = Clockwork.entity:CreateItem(player, helmetItem, headEnt:GetPos() + Vector(0, 0, 16), headEnt:GetAngles());

								if (IsValid(entity)) then
									local helmetPhysObject = entity:GetPhysicsObject();
									
									if IsValid(helmetPhysObject) then
										helmetPhysObject:SetVelocity(physicsObject:GetVelocity());
										helmetPhysObject:SetAngleVelocity(physicsObject:GetAngleVelocity());
									end
								
									player:TakeItem(helmetItem);
								end
							end
						end
					end
					
					Clockwork.entity:Decay(headEnt, 600);
					
					local gender = player:GetGender();
					
					if gender == GENDER_FEMALE then
						player:SetModel("models/begotten/heads/female_gorecap.mdl");
						player:SetBodygroup(0, 0);
						
						if IsValid(ragdollEntity) then
							ragdollEntity:SetModel("models/begotten/heads/female_gorecap.mdl");
							ragdollEntity:SetBodygroup(0, 0);
						end
					else
						player:SetModel("models/begotten/heads/male_gorecap.mdl");
						player:SetBodygroup(0, 0);
						
						if IsValid(ragdollEntity) then
							ragdollEntity:SetModel("models/begotten/heads/male_gorecap.mdl");
							ragdollEntity:SetBodygroup(0, 0);
						end
					end
					
					for k, v in pairs(ents.FindInSphere(attacker:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
						if v:IsPlayer() then
							Clockwork.chatBox:Add(v, attacker, "me", decapitationStrings[math.random(1, #decapitationStrings)].." "..Clockwork.player:FormatRecognisedText(v, "%s", player)..", "..decapitationSuffixes[math.random(1, #decapitationSuffixes)].."!");
						end
					end
					
					player:EmitSound("nhzombie_headexplode.wav");
					headEnt:EmitSound("nhzombie_headexplode_jet.wav");
					
					timer.Simple(FrameTime(), function()
						if IsValid(headEnt) then
							--ParticleEffect("blood_advisor_pierce_spray", headEnt:GetPos(), -headEnt:GetUp():Angle(), headEnt);
							ParticleEffectAttach("blood_advisor_pierce_spray", PATTACH_POINT_FOLLOW, headEnt, 0);
						end
					end);
					
					attacker.decapitationBuff = true;
					
					local entIndex = attacker:EntIndex();
					
					if timer.Exists("DecapitationBuffTimer_"..entIndex) then
						timer.Remove("DecapitationBuffTimer_"..entIndex);
					end
					
					timer.Create("DecapitationBuffTimer_"..entIndex, 20, 1, function()
						if IsValid(attacker) then
							if attacker.decapitationBuff then
								attacker.decapitationBuff = false;
								
								Clockwork.hint:Send(attacker, "The decapitation melee damage buff has worn off...", 10, Color(175, 100, 100), true, true);
							end
						end
					end);
					
					return false;
				end
			end
		end
	end
end

function cwBeliefs:PlayerEnteredDuel(player)
	if player.decapitationBuff then
		player.decapitationBuff = false;
	end
end

function cwBeliefs:PlayerExitedDuel(player)
	if player.decapitationBuff then
		player.decapitationBuff = false;
	end
	
	if player.distortedRingFiredDuel then
		player.distortedRingFiredDuel = false;
	end
	
	player.lastWarCry = nil;
end

function cwBeliefs:PreMakePlayerEnterObserverMode(player)
	if player.cloaked then
		player.cloaked = false; -- So there's no message.
		player:Uncloak();
	end
end

function cwBeliefs:PrePlayerCharacterCreated(player, character)
	local data = character.data or {};
	local inventory = character.inventory;
	local faction = character.faction;
	local subfaction = character.subfaction;
	local traits = data["Traits"] or {};
	local level = 1;
	
	data["beliefs"] = {};
	
	if faction == "Children of Satan" then
		if subfaction == "Kinisger" or subfaction == "Philimaxio" then
			level = level + 6;
		elseif subfaction == "Varazdat" then
			level = level + 5;
			data["beliefs"]["savage"] = true;
			data["beliefs"]["heart_eater"] = true;
		elseif subfaction == "Rekh-khet-sa" then
			level = level + 16;
			data["beliefs"]["primevalism"] = true;
			character.subfaith = "Primevalism";
		elseif subfaction == "Crypt Walkers" then
			level = level + 14
			data["beliefs"]["primevalism"] = true;
			character.subfaith = "Primevalism";
		end
	elseif faction == "Gatekeeper" then
		if subfaction == "Auxiliary" then
			level = level + 11;
		elseif subfaction == "Praeventor" then
			level = level + 7;
		else
			level = level + 5;
		end
	elseif faction == "Goreic Warrior" then
		if subfaction == "Clan Gore" or subfaction == "Clan Shagalax" or subfaction == "Clan Ghorst" then
			level = level + 7;
			
			if subfaction == "Clan Shagalax" then
				data["beliefs"]["ingenious"] = true;
				data["beliefs"]["craftsman"] = true;
				data["beliefs"]["smith"] = true;
			end
		elseif subfaction == "Clan Crast" then
			level = level + 11;
		elseif subfaction == "Clan Reaver" or subfaction == "Clan Harald" then
			level = level + 5;
		elseif subfaction == "Clan Grock" or subfaction == "Clan Grock" then
			level = level + 7;
		end
	elseif faction == "Pope Adyssa's Gatekeepers" then
		level = level + 15;
	elseif faction == "Holy Hierarchy" then
		level = level + 10;

		if subfaction == "Low Ministry" then
			data["beliefs"]["literate"] = true;
		end
	elseif faction == "The Third Inquisition" then
		level = level + 19;
	elseif faction == "Smog City Pirate" then
		if subfaction == "Machinists" then
			level = level + 7;
		elseif subfaction == "Voltists" then
			level = level + 10;
			data["beliefs"]["voltism"] = true;
			character.subfaith = "Voltism";
		end
	elseif faction == "Hillkeeper" then
		if subfaction == "Servus" then
			level = level + 11;
		elseif subfaction == "Outrider" then
			level = level + 7;
		else
			level = level + 5;
		end
	end
	
	if (table.HasValue(traits, "criminal")) then
		level = level + 3;
		data["beliefs"]["nimble"] = true;
		data["beliefs"]["sly_fidget"] = true;
		data["beliefs"]["safecracker"] = true;

		Clockwork.inventory:AddInstance(inventory, item.CreateInstance("lockpick"));
		Clockwork.inventory:AddInstance(inventory, item.CreateInstance("lockpick"));
	end
	
	if (table.HasValue(traits, "favored")) then
		level = level + 3;
		data["beliefs"]["fortunate"] = true;
		data["beliefs"]["lucky"] = true;
		data["beliefs"]["favored"] = true;
	end
	
	if (table.HasValue(traits, "nimble")) then
		level = level + 3;
		data["beliefs"]["nimble"] = true;
		data["beliefs"]["evasion"] = true;
		data["beliefs"]["dexterity"] = true;
	end;
	
	if (table.HasValue(traits, "brawny")) then
		level = level + 3;
		data["beliefs"]["fighter"] = true;
		data["beliefs"]["strength"] = true;
		data["beliefs"]["might"] = true;
	end;
	
	if table.HasValue(traits, "duelist") then
		level = level + 3;
		data["beliefs"]["fighter"] = true;
		data["beliefs"]["parrying"] = true;
		data["beliefs"]["deflection"] = true;
	end
	
	if table.HasValue(traits, "vigorous") then
		level = level + 3;
		data["beliefs"]["believers_perseverance"] = true;
		data["beliefs"]["plenty_to_spill"] = true;
		data["beliefs"]["unyielding"] = true;
	end
	
	if (table.HasValue(traits, "cannibal")) then
		level = level + 1;
		data["beliefs"]["savage"] = true;
	end;
	
	if table.HasValue(traits, "shrewd") then
		level = level + 3;
		data["beliefs"]["ingenious"] = true;
		data["beliefs"]["craftsman"] = true;
		data["beliefs"]["mechanic"] = true;
	end
	
	if table.HasValue(traits, "scribe") then
		level = level + 2;
		data["beliefs"]["literacy"] = true;
		data["beliefs"]["scribe"] = true;
	elseif table.HasValue(traits, "literate") then
		level = level + 1;
		data["beliefs"]["literacy"] = true;
	end
	
	if table.HasValue(traits, "gunslinger") then
		level = level + 2;
		data["beliefs"]["ingenious"] = true;
		data["beliefs"]["powder_and_steel"] = true;
		
		--local random_ammos = {"pop-a-shot"};
		--[[local peppershot = Clockwork.item:CreateInstance("begotten_peppershot");
			
		if peppershot then
			peppershot:SetCondition(math.random(60, 80));
			
			Clockwork.inventory:AddInstance(inventory, peppershot);
		end
		
		for i = 1, math.random(3, 4) do
			Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance(random_ammos[math.random(1, #random_ammos)]));
		end]]--
	end
	
	if table.HasValue(traits, "escapee") then
		data["tied"] = true;
	end
	
	if (table.HasValue(traits, "survivalist")) then
		level = level + 5;
		
		local random_consumables = {};
		local random_melees = {};
		
		if faction == "Goreic Warrior" then
			random_consumables = {"cooked_deer_meat", "cooked_goat_meat", "crafted_bandage"};
			random_melees = {"begotten_1h_goremace", "begotten_dagger_gorehuntingdagger", "begotten_spear_harpoon", "begotten_2h_great_club"};
		else
			random_consumables = {"skintape", "can_of_beans", "moldy_bread", "dirtywater", "crafted_bandage"};
			random_melees = {"begotten_1h_bat", "begotten_1h_board", "begotten_1h_brokensword", "begotten_spear_harpoon", "begotten_2h_great_club", "begotten_2h_quarterstaff", "begotten_dagger_quickshank", "begotten_1h_pipe"};
		end
		
		local random_melee = Clockwork.item:CreateInstance(random_melees[math.random(1, #random_melees)]);
			
		if random_melee then
			random_melee:SetCondition(math.random(40, 70));
			
			Clockwork.inventory:AddInstance(inventory, random_melee);
		end
		
		for i = 1, math.random(2, 4) do
			Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance(random_consumables[math.random(1, #random_consumables)]));
		end
	end;
	
	if table.HasValue(traits, "veteran") then
		level = level + 4;
		data["beliefs"]["fighter"] = true;
		data["beliefs"]["halfsword_sway"] = true;
		data["beliefs"]["blademaster"] = true;
		data["beliefs"]["billman"] = true;
		
		--local random_armors = {};
		local random_melees = {};
		local random_shields = {};
		
		if faction == "Goreic Warrior" then
			--random_armors = {"gore_chainmail", "gore_warfighter_armor"};
			random_melees = {"begotten_spear_ironshortspear", "begotten_1h_goremace", "begotten_1h_goreshortsword"}
			random_shields = {"shield5"};
		else
			--random_armors = {"light_brigandine_armor", "wanderer_mail"};
			random_melees = {"begotten_spear_ironshortspear", "begotten_1h_scrapaxe", "begotten_1h_scrapblade"};
			random_shields = {"shield1", "shield5"};
		end
		
		--local random_armor = Clockwork.item:CreateInstance(random_armors[math.random(1, #random_armors)]);
		local random_melee = Clockwork.item:CreateInstance(random_melees[math.random(1, #random_melees)]);
		local random_shield = Clockwork.item:CreateInstance(random_shields[math.random(1, #random_shields)]);
			
		--[[if random_armor then
			random_armor:SetCondition(math.random(40, 60));
			
			Clockwork.inventory:AddInstance(inventory, random_armor);
		end]]--
			
		if random_melee then
			random_melee:SetCondition(math.random(40, 60));
			
			Clockwork.inventory:AddInstance(inventory, random_melee);
		end
		
		if random_shield then
			random_shield:SetCondition(math.random(40, 60));
			
			Clockwork.inventory:AddInstance(inventory, random_shield);
		end
	end
	
	if (table.HasValue(traits, "scavenger")) then
		Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance("breakdown_kit"));
	end
	
	if (table.HasValue(traits, "miner")) then
		local pickaxe = Clockwork.item:CreateInstance("begotten_2h_great_pickaxe");
		local lantern = Clockwork.item:CreateInstance("cw_lantern");
	
		pickaxe:SetCondition(math.random(40, 70));
		lantern:SetData("oil", 60);
	
		Clockwork.inventory:AddInstance(inventory, pickaxe);
		Clockwork.inventory:AddInstance(inventory, lantern);
		--Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance("large_oil"));
	end
	
	if (table.HasValue(traits, "logger")) then
		local hatchet = Clockwork.item:CreateInstance("begotten_1h_hatchet");
		
		hatchet:SetCondition(math.random(40, 70));
	
		Clockwork.inventory:AddInstance(inventory, hatchet);
	end
	
	if table.HasValue(traits, "pious") then
		level = level + 1;
	end
	
	if (table.HasValue(traits, "zealous")) then
		level = level + 5;
		--points = points + 3;
		data["beliefs"]["prudence"] = true;
		data["beliefs"]["saintly_composure"] = true;
	end;
	
	if cwCharacterNeeds and table.HasValue(traits, "exhausted") then
		data["hunger"] = math.random(50, 70);
		data["sleep"] = math.random(50, 70);
		data["thirst"] = math.random(50, 70);
	end
	
	if cwMedicalSystem and table.HasValue(traits, "wounded") then
		local wound_applied = false;
		
		if !data["Injuries"] then
			data["Injuries"] = {};
		end
		
		if !data["BleedingLimbs"] then
			data["BleedingLimbs"] = {};
		end
		
		for i = 1, 7 do
			if !data["Injuries"][i] then
				data["Injuries"][i] = {};
			end
			
			if math.random(1, 4) == 1 or (i == 7 and !wound_applied) then
				if (i < 8 and i > 3) and math.random(1, 6) == 1 then
					data["Injuries"][i]["broken_bone"] = true;
				elseif math.random(1, 4) == 1 then
					data["Injuries"][i]["burn"] = true;
				else
					data["Injuries"][i]["gash"] = true;
					
					data["BleedingLimbs"][Clockwork.limb.hitgroupToString[i]] = true;
				end
				
				if !data["LimbData"] then
					data["LimbData"] = {};
				end
				
				data["LimbData"][i] = math.random(25, 60);
				
				wound_applied = true;
			end
		end
		
		data["Health"] = math.random(50, 75);
	end
	
	-- FOR MELEE TEST ONLY
	if melee_test_enabled == true then
		if not player:HasBelief("fighter") then
			data["beliefs"]["fighter"] = true;
			data["beliefs"]["halfsword_sway"] = true;
			data["beliefs"]["parrying"] = true;
			data["beliefs"]["deflection"] = true;
			data["beliefs"]["strength"] = true;
			
			level = level + 5;
		else
			data["beliefs"]["halfsword_sway"] = true;
			data["beliefs"]["parrying"] = true;
			data["beliefs"]["deflection"] = true;
			
			level = level + 3;
		end
		
		data["beliefs"]["defender"] = true;
		data["beliefs"]["hauberk"] = true;
		
		level = level + 2;
	end
	
	local points = level - 1;
	
	for k, v in pairs(data["beliefs"]) do
		if v then points = points - 1 end;
	end
	
	data["points"] = points;
	data["level"] = level;
end

function cwBeliefs:PostPlayerCharacterLoaded(player)
	local playerLevel = player:GetCharacterData("level", 1);
	
	player:SetNetVar("level", playerLevel);
	
	if player.poisonTicks then
		player.poisonTicks = nil;
	end
	
	if player.decapitationBuff then
		local entIndex = player:EntIndex();
		
		player.decapitationBuff = false;
		
		if timer.Exists("DecapitationBuffTimer_"..entIndex) then
			timer.Remove("DecapitationBuffTimer_"..entIndex);
		end
	end
	
	-- Remove taste of blood effect.
	for _, v in _player.Iterator() do
		if v.tasteOfBloodVictim and v.tasteOfBloodVictim == player then
			v.tasteOfBloodVictim = nil;
			
			netstream.Start(v, "TasteofBloodHighlight", nil);
		end
	end

	player:NetworkBeliefs();
end;

function cwBeliefs:PlayerDeath(player, inflictor, attacker, damageInfo)
	if IsValid(attacker) and attacker:IsPlayer() and not player.opponent and not attacker.opponent then
		if attacker:HasBelief("brutality_finisher") then
			local playerLevel = player:GetCharacterData("level", 1);
			local refundPerLevel = 0.025;
			local maxHealth = attacker:GetMaxHealth();
			local maxStamina = attacker:GetMaxStamina();
			--local maxPoise = attacker:GetMaxPoise();
			
			attacker:SetHealth(math.min(maxHealth, attacker:Health() + ((maxHealth * refundPerLevel) * playerLevel)));
			attacker:SetCharacterData("Stamina", math.min(maxStamina, attacker:GetCharacterData("Stamina", 90) + ((maxStamina * refundPerLevel) * playerLevel)));
			--attacker:SetNWInt("meleeStamina", math.min(maxPoise, attacker:GetNWInt("meleeStamina", 90) + ((maxPoise * refundPerLevel) * playerLevel)));
			
			if cwMelee then
				local maxStability = attacker:GetMaxStability();
				
				cwMelee:HandleStability(attacker, (maxStability * refundPerLevel) * playerLevel);
			end
			
			attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
			
			timer.Simple(0.2, function()
				if IsValid(attacker) then
					attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
				end
			end);
		end
		
		if player:CharPlayTime() > config.GetVal("min_xp_charplaytime") or player:IsAdmin() then
			local attackerFaction = attacker:GetFaction();
			local attackerFactionTable = Clockwork.faction:FindByID(attackerFaction);
			
			if attackerFactionTable then
				local playerFaction = player:GetFaction();
				local kinisgerOverride = player:GetNetVar("kinisgerOverride");
				
				if kinisgerOverride and attackerFaction ~= "Children of Satan" then
					playerFaction = kinisgerOverride;
				end
				
				-- Make sure players can't get XP from damaging the same faction as them!
				if ((attackerFaction ~= playerFaction and (!attackerFactionTable.alliedfactions or !table.HasValue(attackerFactionTable.alliedfactions, playerFaction))) or attackerFaction == "Wanderer") and (attacker:GetSubfaith() ~= "Voltism" or player:GetSubfaith() ~= "Voltism") then
					local killXP = self.xpValues["kill"];
					
					killXP = killXP * math.Clamp(player:GetCharacterData("level", 1), 1, 40);
					
					if attacker:HasBelief("father") then
						if attacker:GetCharacterData("level", 1) < player:GetCharacterData("level", 1) then
							killXP = killXP * 2;
						end
					elseif attacker:HasBelief("sister") then
						if attacker:GetCharacterData("level", 1) > player:GetCharacterData("level", 1) then
							killXP = killXP * 2;
						end
					end

					attacker:HandleXP(killXP);
				end
			end
		end
	end
	
	if player.cloaked then
		player:Uncloak();
	end
	
	if player.poisonTicks then
		player.poisonTicks = nil;
	end
	
	if player.decapitationBuff then
		local entIndex = player:EntIndex();
		
		player.decapitationBuff = false;
		
		if timer.Exists("DecapitationBuffTimer_"..entIndex) then
			timer.Remove("DecapitationBuffTimer_"..entIndex);
		end
	end
end

function cwBeliefs:PlayerDisconnected(player)
	if player.warCryVictims then
		for i, victim in ipairs(player.warCryVictims) do
			if IsValid(victim) then
				hook.Run("RunModifyPlayerSpeed", victim, victim.cwInfoTable, true);
			end
		end
	end
end

function cwBeliefs:GetMaxStamina(player, max_stamina)
	local new_stamina = max_stamina;
	
	if player:GetCharacterData("isDemon", false) then
		new_stamina = 1000
	else
		if player:HasTrait("winded") then
			new_stamina = new_stamina - 25;
		--[[elseif player:HasBelief("outlasting") then
			new_stamina = new_stamina + 25;]]--
		end
		
		--[[if player:GetCharmEquipped("ring_courier") then
			new_stamina = new_stamina + 25;
		end]]--
	end
	
	return new_stamina;
end

function cwBeliefs:ModifyStaminaDrain(player, drainTab)
	if player:GetCharmEquipped("ring_courier") then
		drainTab.decrease = drainTab.decrease * 0.75;
	end
	
	if player:HasBelief("outlasting") then
		drainTab.decrease = drainTab.decrease * 0.75;
	end
end

function cwBeliefs:ModifyPlayerItemConditionLoss(player, amountTab)
	local modifier = 1;

	if player:HasBelief("scour_the_rust") then
		modifier = math.max(0, modifier - 0.35);
	end
	
	if player:HasBelief("ingenuity_finisher") then
		modifier = math.max(0, modifier - 0.45);
	end
	
	amountTab.amount = amountTab.amount * modifier;
end

-- Called when a player attempts to use an item.
function cwBeliefs:PlayerCanUseItem(player, itemTable, noMessage)
	if Clockwork.player:HasFlags(player, "S") then
		return;
	end

	if itemTable.requiredbeliefs then
		for i = 1, #itemTable.requiredbeliefs do
			local belief = itemTable.requiredbeliefs[i];
			
			if !player:HasBelief(belief) then
				if !itemTable.kinisgerOverride or itemTable.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
					Clockwork.player:Notify(player, "You cannot equip this item as you lack the belief required to do so!");
					return false;
				end
			end;
		end;
	end;
	
	-- For items that require only one belief out of several.
	if itemTable.onerequiredbelief then
		local has_needed_belief = false;
		
		for i = 1, #itemTable.onerequiredbelief do
			local belief = itemTable.onerequiredbelief[i];
			
			if player:HasBelief(belief) then
				has_needed_belief = true;
				break;
			end;
		end;
		
		if not has_needed_belief then
			if !itemTable.kinisgerOverride or itemTable.kinisgerOverride and !player:GetCharacterData("apostle_of_many_faces") then
				Clockwork.player:Notify(player, "You cannot equip this item as you lack one of the beliefs required to do so!");
				return false;
			end
		end
	end
end;

-- Called when a player starts lockpicking a container.
function cwBeliefs:LockpickingStarted(player, container)
	if player.cloaked then
		player:Uncloak();
	end
end

function cwBeliefs:ModifyPlayerSpeed(player, infoTable)
	local clothesItem = player:GetClothesEquipped();
	local curTime = CurTime();
	
	-- If poisioned give movement debuffs.
	if player.poisonTicks and player.poisonTicks > 0 then
		infoTable.runSpeed = infoTable.runSpeed * 0.7;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.7;
		return;
	end

	if player:HasBelief("swift") then
		infoTable.runSpeed = infoTable.runSpeed * 1.10;
	end
	
	if player:HasBelief("litheness_finisher") then
		infoTable.runSpeed = infoTable.runSpeed * 1.05;
	end
	
	if player:HasBelief("purity_afloat") then
			local health = player:Health();
			local maxHealth = player:GetMaxHealth();
			local lowerBound = maxHealth * 0.25;
			local modifier = math.Clamp(-(((health - lowerBound) / (maxHealth - lowerBound)) - 1), 0, 1);
		if not clothesItem or (clothesItem and (clothesItem.weightclass ~= "Heavy")) then
			local bonus = 0.2 * modifier;
			infoTable.runSpeed = infoTable.runSpeed + (infoTable.runSpeed * bonus);
			infoTable.walkSpeed = infoTable.walkSpeed + (infoTable.walkSpeed * bonus);
		elseif clothesItem.weightclass == "Heavy" then
			local bonus = 0.15 * modifier;
			infoTable.runSpeed = infoTable.runSpeed + (infoTable.runSpeed * bonus);
			infoTable.walkSpeed = infoTable.walkSpeed + (infoTable.walkSpeed * bonus);
		end
		
	end
	
	if player.fearsomeSpeed then
		infoTable.runSpeed = infoTable.runSpeed * 1.1;
	elseif player.iconoclastBuff then
		infoTable.runSpeed = infoTable.runSpeed * 1.15;
	end
end
