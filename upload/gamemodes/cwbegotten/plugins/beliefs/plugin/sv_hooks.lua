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
	player:SetSharedVar("level", data["level"]);
end

-- Called when a player's character screen info should be adjusted.
function cwBeliefs:PlayerAdjustCharacterScreenInfo(player, character, info)
	info.level = character.data["level"];
end

-- Called at an interval while the player is connected to the server.
function cwBeliefs:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if initialized and alive then
		if (!plyTab.residualXPCheck or plyTab.residualXPCheck < curTime) then
			plyTab.residualXPCheck = curTime + 60;
			
			local lastZone = player:GetCharacterData("LastZone");
			local playerFaction = player:GetFaction();
			
			if not plyTab.opponent and (table.HasValue(self.residualXPZones, lastZone) or (lastZone == "tower" and ((playerFaction == "Gatekeeper" or playerFaction == "Holy Hierarchy") or residualXPInSafezone == true))) then
				local residualXP = self.xpValues["residual"] or 5;
				
				if playerFaction == "Goreic Warrior" and (lastZone == "wasteland" or lastZone == "tower" or lastZone == "caves" or lastZone == "scrapper") then
					residualXP = residualXP * 2;
				end
				
				if (cwDayNight and cwDayNight.currentCycle == "night" and player:HasBelief("primevalism") and lastZone == "wasteland") or player:HasBelief("old_son") or (lastZone != "tower" and (playerFaction == "Gatekeeper" or playerFaction == "Pope Adyssa's Gatekeepers" or playerFaction == "Holy Hierarchy")) then
					residualXP = residualXP * 2;
				end
				
				if playerFaction == "Gatekeeper" and game.GetMap() == "rp_begotten3" and player:GetPos():WithinAABox(Vector(9422, 11862, -1210), Vector(10055, 10389, -770)) then
					residualXP = residualXP * 2;
				end

				player:HandleXP(residualXP);
			end
		end
		
		if plyTab.cloaked then
			if (!plyTab.cloakedCheck or plyTab.cloakedCheck < curTime) then
				plyTab.cloakedCheck = curTime + 0.5;
				
				local lastZone = player:GetCharacterData("LastZone");
				local valid_zones = {"scrapper", "caves", "wasteland"};
				
				if !player:Crouching() or !player:GetActiveWeapon():GetClass() == "cw_senses" or (!player:GetNetVar("kinisgerCloak") and not table.HasValue(valid_zones, lastZone)) then
					player:Uncloak();
				else
					local playerPos = player:GetPos();
					
					for i, v in ipairs(_player.GetAll()) do
						if v:GetSharedVar("yellowBanner") then
							if (v:GetPos():Distance(playerPos) <= config.Get("talk_radius"):Get()) then
								Schema:EasyText(player, "peru", "There is one with a yellow banner raised, dispelling your dark magic! Vanquish them or distance yourself!");
								Schema:EasyText(v, "peru", "You feel your yellow banner pulsate with energy as the dark magic of "..player:Name().." is foiled and they are uncloaked for all to see!");
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
							
							for i, v in ipairs(_player.GetAll()) do
								if v:GetSharedVar("yellowBanner") then
									if (v:GetPos():Distance(playerPos) <= config.Get("talk_radius"):Get()) then
										blockedCloak = true;
									
										break;
									end
								end
							end
						
							if !blockedCloak then
								player:Cloak();
							end
						else
							Schema:EasyText(self.Owner, "chocolate", "You are covered in black powder and cannot cloak for "..math.Round(plyTab.cloakCooldown - curTime).." seconds!");
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

						if (health > 0 and health < maxHealth) then
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
					if !beliefs[k2] then
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
			local character = player:GetCharacter();
			
			character.subfaith = beliefTable.subfaith;
			player:SetSharedVar("subfaith", beliefTable.subfaith);
			
			player:SaveCharacter();
		end
	end
	
	local lockedBeliefFound = false;
	
	for k, v in pairs(self.beliefTrees.stored) do
		if v.lockedBeliefs then
			for i, v2 in ipairs(v.lockedBeliefs) do
				if beliefs[v2] then
					lockedBeliefFound = true;

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
						if beliefs[k3] then
							lockedBeliefFound = true;
							beliefs[k3] = false;
							points = points + 1;
						end
					end
					
					break;
				end
			end
		end
	end
	
	if lockedBeliefFound then
		player:SetCharacterData("points", points);
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
					player:HandleXP(self.sacramentCosts[i] or 666);
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
		end
	elseif uniqueID == "scribe" then
		Clockwork.player:GiveFlags(player, "J");
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
		local players = _player.GetAll()
		
		for i = 1, _player.GetCount() do
			local player = players[i];
			
			if IsValid(player) then
				if player.cloaked and player:GetCharacterData("LastZone") ~= "caves" then
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
				
				if IsValid(activeWeapon) then
					offhandWeapon = activeWeapon:GetOffhand();
				end
				
				if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
					if (!entity.mutilated or entity.mutilated < 3) then
						local model = entity:GetModel();
						
						if model == "models/animals/deer1.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the stag before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
							Clockwork.player:SetAction(player, "mutilating", 10, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + 1;
											
											local instance = Clockwork.item:CreateInstance("deer_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
													weaponItemTable:TakeCondition(1);
												end
											end
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif model == "models/animals/goat.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the goat before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", 10, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + 1;
											
											local instance = Clockwork.item:CreateInstance("goat_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
													weaponItemTable:TakeCondition(1);
												end
											end
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the leopard before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", 10, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + 1;
											
											local instance = Clockwork.item:CreateInstance("leopard_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
													weaponItemTable:TakeCondition(1);
												end
											end
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif model == "models/animals/bear.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the bear before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", 10, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + 1;
											
											local instance = Clockwork.item:CreateInstance("bear_meat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
													weaponItemTable:TakeCondition(1);
												end
											end
										else
											Clockwork.player:Notify(player, "This corpse has no meat left to mutilate!");
										end
									end
								end
							end);
						elseif entity:GetNWEntity("Player"):IsPlayer() or entity:GetNWEntity("Player") == game.GetWorld() then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting the flesh of the body before them, harvesting its meat.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						
							Clockwork.player:SetAction(player, "mutilating", 10, 5, function()
								if IsValid(player) and IsValid(entity) then
									local activeWeapon = player:GetActiveWeapon();
									local offhandWeapon;
									
									if IsValid(activeWeapon) then
										offhandWeapon = activeWeapon:GetOffhand();
									end
									
									if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
										if (!entity.mutilated or entity.mutilated < 3) then
											entity.mutilated = (entity.mutilated or 0) + 1;
											
											local instance = Clockwork.item:CreateInstance("humanmeat");

											player:GiveItem(instance, true);
											player:HandleXP(self.xpValues["mutilate"]);
											player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
											Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
											
											local weaponItemTable = item.GetByWeapon(activeWeapon);
											
											if weaponItemTable then
												if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
													weaponItemTable:TakeCondition(1);
												end
											end
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
				
				if entity:GetNWEntity("Player"):IsPlayer() or entity:GetNWEntity("Player") == game.GetWorld() or table.HasValue(animalModels, model) then
					local activeWeapon = player:GetActiveWeapon();
					local offhandWeapon;
					
					if IsValid(activeWeapon) then
						offhandWeapon = activeWeapon:GetOffhand();
					end
					
					if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
						if (!entity.bones or entity.bones < 5) then
							entity.bones = (entity.bones or 0) + 1;
							
							local instance = Clockwork.item:CreateInstance("human_bone");

							player:GiveItem(instance, true);
							player:HandleXP(math.Round(self.xpValues["mutilate"] / 2));
							
							if model == "models/animals/deer1.mdl" then
								Clockwork.chatBox:AddInTargetRadius(player, "me", "strips the flesh of the stag before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							elseif model == "models/animals/goat.mdl" then
								Clockwork.chatBox:AddInTargetRadius(player, "me", "strips the flesh of the goat before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
								Clockwork.chatBox:AddInTargetRadius(player, "me", "strips the flesh of the leopard before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							elseif model == "models/animals/bear.mdl" then
								Clockwork.chatBox:AddInTargetRadius(player, "me", "strips the flesh of the bear before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							else
								Clockwork.chatBox:AddInTargetRadius(player, "me", "strips the flesh of the body before them, harvesting its bones.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							end
							
							player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
							Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
							
							local weaponItemTable = item.GetByWeapon(activeWeapon);
							
							if weaponItemTable then
								if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
									weaponItemTable:TakeCondition(0.5);
								end
							end
						else
							Clockwork.player:Notify(player, "This corpse has already been harvested of all its bones!");
						end;
					else
						Clockwork.player:Notify(player, "You must have a dagger equipped in order to harvest the bones of this corpse!");
					end;
				end;
			end;
		elseif (arguments == "cwCorpseSkin") then
			if table.HasValue(animalModels, entity:GetModel()) then
				local activeWeapon = player:GetActiveWeapon();
				local offhandWeapon;
				
				if IsValid(activeWeapon) then
					offhandWeapon = activeWeapon:GetOffhand();
				end 
				 
				if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
					if (!entity.skinned or entity.skinned < 1) then					
						local model = entity:GetModel();
						local uniqueID = "hide"
						
						if model == "models/animals/deer1.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the stag before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/goat.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the goat before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animal_ragd/piratecat_leopard.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the leopard before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						elseif model == "models/animals/bear.mdl" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins flaying the skin of the bear before them, harvesting its fur and hide.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
							uniqueID = "bearskin";
						end
						
						Clockwork.player:SetAction(player, "skinning", 10, 5, function()
							if IsValid(player) and IsValid(entity) then
								local activeWeapon = player:GetActiveWeapon();
								local offhandWeapon;
								
								if IsValid(activeWeapon) then
									offhandWeapon = activeWeapon:GetOffhand();
								end
								
								if IsValid(activeWeapon) and activeWeapon.Category and string.find(activeWeapon.Category, "Dagger") or offhandWeapon and offhandWeapon.Category and string.find(offhandWeapon.Category, "Dagger") then
									if (!entity.skinned or entity.skinned < 1) then
										entity.skinned = (entity.skinned or 0) + 1;
										
										local instance = Clockwork.item:CreateInstance(uniqueID);

										player:GiveItem(instance, true);
										player:HandleXP(self.xpValues["mutilate"] * 2);
										player:EmitSound("npc/barnacle/barnacle_crunch"..math.random(2, 3)..".wav");
										Clockwork.kernel:CreateBloodEffects(entity:NearestPoint(trace.HitPos), 1, entity);
										entity:SetMaterial("models/flesh");
										
										local weaponItemTable = item.GetByWeapon(activeWeapon);
										
										if weaponItemTable then
											if cwBeliefs and not player:HasBelief("ingenuity_finisher") then
												weaponItemTable:TakeCondition(1);
											end
										end
									else
										Clockwork.player:Notify(player, "This corpse has already been skinned!");
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
				player:HandleXP(100);
			elseif entity.cwLockTier == 1 then
				player:HandleXP(5);
			elseif entity.cwLockTier == 2 then
				player:HandleXP(10);
			elseif entity.cwLockTier == 3 then
				player:HandleXP(25);
			end
		end
	end
end

-- Called when a player should take damage.
function cwBeliefs:PlayerShouldTakeDamage(player, attacker, inflictor, damageInfo)
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
		
		local attacker = damageInfo:GetAttacker();
		
		if (attacker:IsPlayer()) then
			local attackerWeapon = damageInfo:GetInflictor();
			
			if !attackerWeapon then
				attackerWeapon = attacker:GetActiveWeapon();
			end
			
			if attackerWeapon then
				if attackerWeapon.Base == "sword_swepbase" then -- Melee
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
					
					if attacker:HasBelief("bestial") then
						if attacker:Sanity() <= 40 then
							newDamage = newDamage + (originalDamage * 0.15);
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
							
							if sanity <= 70 then
								if sanity <= 10 then
									newDamage = newDamage + (originalDamage * 0.80);
								else
									local modifier = 70 - (sanity + 10);
									local bonus = 0.01 * modifier;
									
									newDamage = newDamage + (originalDamage * bonus);
								end
							end
						end
					end
				
					if attacker:HasBelief("blademaster") then
						local attackTable = GetTable(attackerWeapon.AttackTable);
						
						if (string.find(attackerWeapon.Category, "One Handed") and attackTable.dmgtype == 4) or string.find(attackerWeapon.Category, "Claws") then
							newDamage = newDamage + (originalDamage * 0.2);
						end
					end
					
					if damageInfo:IsDamageType(16) then
						if entity:IsPlayer() and entity:Alive() and attacker:HasBelief("survivalist") then
							if originalDamage > 0 then
								entity.poisonTicks = math.random(5, 7);
								entity.poisoner = attacker;
								entity.poisoninflictor = inflictor;
							end
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
					end
					
					if attacker:HasBelief("prowess_finisher") then
						newDamage = newDamage + (newDamage * 0.25);
					end
					
					if attacker.decapitationBuff then
						newDamage = newDamage + (newDamage * 0.2);
					end
					
					if entity:IsPlayer() and entity:Alive() and attacker:HasBelief("assassin") then
						if not entity.assassinated then
							if string.find(attackerWeapon.Category, "Dagger") then
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

											for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
												if v:IsPlayer() then
													Clockwork.chatBox:Add(v, attacker, "me", "efficiently strikes out at a pressure point of "..Clockwork.player:FormatRecognisedText(v, "%s", entity)..", but their hatred is so strong that they simply refuse to die!");
												end
											end
											
											if cwMedicalSystem then
												entity.nextBleedPoint = CurTime() + 180;
											end
											
											if entity.poisonTicks then
												entity.poisonTicks = nil;
											end
											
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
												else
													timer.Simple(0.5, function()
														if IsValid(entity) then
															entity.distortedRingFired = nil;
														end
													end);
												end
												
												entity:EmitSound("physics/metal/metal_grate_impact_hard3.wav");
												entity:Extinguish();
												
												for k, v in pairs(ents.FindInSphere(entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
													if v:IsPlayer() then
														Clockwork.chatBox:Add(v, attacker, "me", "efficiently strikes out at a pressure point of "..Clockwork.player:FormatRecognisedText(v, "%s", entity)..", but their dagger is deflected at the last moment by an invisible force!");
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
									
									if entity.soulscorchActive then
										Clockwork.chatBox:AddInTargetRadius(attacker, "me", "efficiently strikes out at a pressure point of "..entity:Name()..", snuffing out their Holy Light with dark magic and killing them instantly!", attacker:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
										
										entity.soulscorchActive = nil;
										entity:SetSharedVar("soulscorchActive", false);
										
										if timer.Exists("SoulScorchTimer_"..entity:EntIndex()) then
											timer.Remove("SoulScorchTimer_"..entity:EntIndex());
										end
									else
										Clockwork.chatBox:AddInTargetRadius(attacker, "me", "efficiently strikes out at a pressure point of "..entity:Name()..", killing them instantly!", attacker:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
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
				elseif attackerWeapon.Base == "begotten_firearm_base" then -- Firearm
					if attacker:HasBelief("blessed_powder") then
						newDamage = newDamage + (originalDamage * 0.25);
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
					end
				end
			end
			
			if entity:IsPlayer() then
				if attacker:HasBelief("manifesto") then
					if entity:GetFaith() == attacker:GetFaith() then
						newDamage = newDamage - (originalDamage * 0.15);
					else
						newDamage = newDamage + (originalDamage * 0.25);
					end
				end
				
				if attacker:GetCharmEquipped("holy_sigils") then
					if entity:GetFaith() ~= attacker:GetFaith() then
						newDamage = newDamage + (originalDamage * 0.15);
					end
				end
				
				if attacker:HasBelief("taste_of_blood") then
					if attacker.tasteOfBloodVictim then
						if timer.Exists("tasteOfBloodTimer") then
							timer.Destroy("tasteOfBloodTimer");
						end
					
						if attacker.tasteOfBloodVictim == entity then
							newDamage = newDamage + (originalDamage * 0.15);
						end
					end
					
					attacker.tasteOfBloodVictim = entity;
					
					timer.Create("tasteOfBloodTimer", 180, 1, function()
						if IsValid(attacker) then
							attacker.tasteOfBloodVictim = nil;
						end
					end);
					
					netstream.Start(attacker, "TasteofBloodHighlight", entity);
				end
				
				if attacker.warCryVictims then
					if table.HasValue(attacker.warCryVictims, entity) then
						if entity:HasBelief("deceitful_snake") then
							newDamage = newDamage + (originalDamage * 0.5);
						else
							newDamage = newDamage + (originalDamage * 0.25);
						end
					end
				end
			end
			
			if attacker:HasBelief("thirst_blood_moon") then
				if (entity:IsPlayer() and entity:Alive()) then
					local lastZone = attacker:GetCharacterData("LastZone");
					
					if cwDayNight and cwDayNight.currentCycle == "night" and lastZone == "wasteland" then
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
				newDamage = newDamage - (originalDamage * 0.15);
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
			
			if not attacker.opponent and entity:CharPlayTime() > 1800 and attacker ~= entity then
				if !cwRituals or (cwRituals and !entTab.scornificationismActive) then
					local attackerFaction = attacker:GetFaction();
					local attackerFactionTable = Clockwork.faction:FindByID(attackerFaction);
					
					if attackerFactionTable then
						local playerFaction = entity:GetFaction();
						local kinisgerOverride = entity:GetSharedVar("kinisgerOverride");
						
						if kinisgerOverride and attackerFaction ~= "Children of Satan" then
							playerFaction = kinisgerOverride;
						end
						
						-- Make sure players can't get XP from damaging the same faction as them!
						if (attackerFaction ~= playerFaction and (!attackerFactionTable.alliedfactions or !table.HasValue(attackerFactionTable.alliedfactions, playerFaction))) or attackerFaction == "Wanderer" then
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
							
							if attacker:GetFaction() == "Gatekeeper" and subfaction == "Legionary" then
								damageXP = damageXP * 2;
							end
						
							attacker:HandleXP(damageXP);
						end
					end
				end
			end
		elseif entity:IsNPC() then
			attacker:HandleXP(math.min(damage, entity:Health()) * (self.xpValues["damage"] * 4));
		end
	end
	
	if damage > 1 and damage < entity:Health() then
		if entity:IsPlayer() and !entTab.opponent and entity:GetSubfaith() == "Sol Orthodoxy" then
			if !cwRituals or (cwRituals and !entTab.scornificationismActive) then
				entity:HandleXP(damage / 2);
			end
		end
	end
	
	if entity:IsPlayer() and not entTab.opponent and damage >= 10 then
		if cwCharacterNeeds then
			if entity:HasBelief("prison_of_flesh") then
				if entity:HasTrait("possessed") then
					local corruption = entity:GetNeed("corruption");
					local reduction = math.max(-(damage / 2), -(math.max(corruption, 50) - 50));

					entity:HandleNeed("corruption", reduction);
				else
					entity:HandleNeed("corruption", -(damage / 2));
				end
			end
		end
	end
	
	local attacker = damageInfo:GetAttacker();
	local damage = damageInfo:GetDamage();
	
	if damage > 0 then
		--[[if IsValid(attacker) and attacker:IsPlayer() and not attacker.cwWakingUp then
			local clothesItem = attacker:GetClothesEquipped();
			
			if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "solblessed") then
				local hatred = math.min(attacker:GetNetVar("Hatred", 0) + (math.min(entity:Health(), math.Round(damage / 2))), 100);
				
				if !attacker.opponent then
					attacker:SetCharacterData("Hatred", hatred);
				end
				
				attacker:SetLocalVar("Hatred", hatred);
			end
		end]]--
		
		if entity:IsPlayer() and not entTab.cwWakingUp then
			local clothesItem = entity:GetClothesEquipped();
			
			if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "solblessed") then
				local hatred = math.min(entity:GetNetVar("Hatred", 0) + (math.min(entity:Health(), math.Round(damage / 2))), 100);
				
				if !entTab.opponent then
					entity:SetCharacterData("Hatred", hatred);
				end
				
				entity:SetLocalVar("Hatred", hatred);
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
					else
						timer.Simple(0.5, function()
							if IsValid(entity) then
								entity.distortedRingFired = nil;
							end
						end);
					end
					
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
					
					damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
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
						
						if IsValid(ragdollEntity) then
							ragdollEntity:SetModel("models/begotten/heads/female_gorecap.mdl");
						end
					else
						player:SetModel("models/begotten/heads/male_gorecap.mdl");
						
						if IsValid(ragdollEntity) then
							ragdollEntity:SetModel("models/begotten/heads/male_gorecap.mdl");
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
end

function cwBeliefs:PostPlayerCharacterLoaded(player)
	local playerBeliefsSetup = player:GetCharacterData("beliefsSetup");
	local playerLevel = player:GetCharacterData("level", 1);
	
	player:SetSharedVar("level", playerLevel);

	if playerBeliefsSetup ~= true then
		local level = 1;
		--local points = 0;
		local faction = player:GetFaction();
		local subfaction = player:GetSubfaction();
		
		if faction == "Children of Satan" then
			if subfaction == "Kinisger" or subfaction == "Philimaxio" then
				level = level + 6;
			elseif subfaction == "Varazdat" then
				level = level + 5;
				self:ForceTakeBelief(player, "savage");
				self:ForceTakeBelief(player, "heart_eater");
			elseif subfaction == "Rekh-khet-sa" then
				level = level + 16;
				self:ForceTakeBelief(player, "primevalism");
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
			if subfaction == "Clan Gore" or subfaction == "Clan Shagalax" then
				level = level + 7;
				
				if subfaction == "Clan Shagalax" then
					self:ForceTakeBelief(player, "ingenious");
					self:ForceTakeBelief(player, "craftsman");
					self:ForceTakeBelief(player, "smith");
				end
			elseif subfaction == "Clan Crast" then
				level = level + 11;
			elseif subfaction == "Clan Reaver" or subfaction == "Clan Harald" then
				level = level + 5;
			elseif subfaction == "Clan Grock" then
				level = level + 7;
			end
		elseif faction == "Pope Adyssa's Gatekeepers" then
			level = level + 15;
		elseif faction == "Holy Hierarchy" then
			level = level + 10;
		elseif faction == "The Third Inquisition" then
			level = level + 19;
		elseif faction == "Smog City Pirate" then
			if subfaction == "Machinists" then
				level = level + 7;
			elseif subfaction == "Voltists" then
				level = level + 10;
				self:ForceTakeBelief(player, "voltism");
			end
		end
		
		if (player:HasTrait("criminal")) then
			level = level + 3;
			self:ForceTakeBelief(player, "nimble");
			self:ForceTakeBelief(player, "sly_fidget");
			self:ForceTakeBelief(player, "safecracker");
			
			local inventory = player:GetInventory();
			
			Clockwork.inventory:AddInstance(inventory, item.CreateInstance("lockpick"));
			Clockwork.inventory:AddInstance(inventory, item.CreateInstance("lockpick"));
		end
		
		if (player:HasTrait("favored")) then
			level = level + 3;
			self:ForceTakeBelief(player, "fortunate");
			self:ForceTakeBelief(player, "lucky");
			self:ForceTakeBelief(player, "favored");
		end
		
		if (player:HasTrait("nimble")) then
			level = level + 3;
			self:ForceTakeBelief(player, "nimble");
			self:ForceTakeBelief(player, "dexterity");
			self:ForceTakeBelief(player, "swift");
		end;
		
		if (player:HasTrait("brawny")) then
			level = level + 3;
			self:ForceTakeBelief(player, "fighter");
			self:ForceTakeBelief(player, "strength");
			self:ForceTakeBelief(player, "might");
		end;
		
		if player:HasTrait("duelist") then
			level = level + 3;
			self:ForceTakeBelief(player, "fighter");
			self:ForceTakeBelief(player, "parrying");
			self:ForceTakeBelief(player, "deflection");
		end
		
		if player:HasTrait("vigorous") then
			level = level + 3;
			self:ForceTakeBelief(player, "believers_perseverance");
			self:ForceTakeBelief(player, "plenty_to_spill");
			self:ForceTakeBelief(player, "unyielding");
			
			player:SetHealth(player:Health() + 25);
		end
		
		if (player:HasTrait("cannibal")) then
			level = level + 1;
			self:ForceTakeBelief(player, "savage");
		end;
		
		if player:HasTrait("shrewd") then
			level = level + 3;
			self:ForceTakeBelief(player, "ingenious");
			self:ForceTakeBelief(player, "craftsman");
			self:ForceTakeBelief(player, "mechanic");
		end
		
		if player:HasTrait("scribe") then
			level = level + 2;
			self:ForceTakeBelief(player, "literacy");
			self:ForceTakeBelief(player, "scribe");
		elseif player:HasTrait("literate") then
			level = level + 1;
			self:ForceTakeBelief(player, "literacy");
		end
		
		if player:HasTrait("gunslinger") then
			level = level + 3;
			self:ForceTakeBelief(player, "ingenious");
			self:ForceTakeBelief(player, "powder_and_steel");
			
			local inventory = player:GetInventory();
			local random_ammos = {--[["grapeshot",]] "pop-a-shot"};
			
			local peppershot = Clockwork.item:CreateInstance("begotten_peppershot");
				
			if peppershot then
				peppershot:SetCondition(math.random(60, 80));
				
				Clockwork.inventory:AddInstance(inventory, peppershot);
			end
			
			for i = 1, math.random(3, 4) do
				Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance(random_ammos[math.random(1, #random_ammos)]));
			end
		end
		
		if player:HasTrait("escapee") then
			timer.Simple(0.1, function()
				if IsValid(player) then
					Schema:TiePlayer(player, true);
				end
			end);
		end
		
		if (player:HasTrait("survivalist")) then
			level = level + 5;
			
			local inventory = player:GetInventory();
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
		
		if player:HasTrait("veteran") then
			level = level + 4;
			self:ForceTakeBelief(player, "fighter");
			self:ForceTakeBelief(player, "halfsword_sway");
			self:ForceTakeBelief(player, "blademaster");
			self:ForceTakeBelief(player, "billman");
			
			local inventory = player:GetInventory();
			--local random_armors = {};
			local random_melees = {};
			local random_shields = {};
			
			if faction == "Goreic Warrior" then
				--random_armors = {"gore_chainmail", "gore_warfighter_armor"};
				random_melees = {"begotten_spear_ironspear", "begotten_1h_goremace", "begotten_1h_goreshortsword", "begotten_1h_ironarmingsword", "begotten_1h_ironshortsword"}
				random_shields = {"shield5"};
			else
				--random_armors = {"light_brigandine_armor", "wanderer_mail"};
				random_melees = {"begotten_spear_ironspear", "begotten_1h_ironarmingsword", "begotten_1h_ironshortsword", "begotten_1h_morningstar", "begotten_1h_scrapblade"};
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
		
		if (player:HasTrait("scavenger")) then
			local inventory = player:GetInventory();
		
			Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance("breakdown_kit"));
		end
		
		if (player:HasTrait("miner")) then
			local inventory = player:GetInventory();
			local pickaxe = Clockwork.item:CreateInstance("begotten_2h_great_pickaxe");
			local lantern = Clockwork.item:CreateInstance("cw_lantern");
		
			pickaxe:SetCondition(math.random(40, 70));
			lantern:SetData("oil", 60);
		
			Clockwork.inventory:AddInstance(inventory, pickaxe);
			Clockwork.inventory:AddInstance(inventory, lantern);
			--Clockwork.inventory:AddInstance(inventory, Clockwork.item:CreateInstance("large_oil"));
		end
		
		if (player:HasTrait("logger")) then
			local inventory = player:GetInventory();
			local hatchet = Clockwork.item:CreateInstance("begotten_1h_hatchet");
			
			hatchet:SetCondition(math.random(40, 70));
		
			Clockwork.inventory:AddInstance(inventory, hatchet);
		end
		
		if player:HasTrait("pious") then
			level = level + 1;
		end
		
		if (player:HasTrait("zealous")) then
			level = level + 5;
			--points = points + 3;
			self:ForceTakeBelief(player, "prudence");
			self:ForceTakeBelief(player, "saintly_composure");
		end;
		
		if cwCharacterNeeds and player:HasTrait("exhausted") then
			player:SetNeed("hunger", math.random(50, 80));
			player:SetNeed("sleep", math.random(50, 80));
			player:SetNeed("thirst", math.random(50, 80));
		end
		
		if cwMedicalSystem and player:HasTrait("wounded") then
			local hp = player:Health();
			local wound_applied = false;
			
			for i = 1, 7 do
				if math.random(1, 4) == 1 or (i == 7 and !wound_applied) then
					if (i < 8 and i > 3) and math.random(1, 6) == 1 then
						player:AddInjury(i, "broken_bone")
					elseif math.random(1, 4) == 1 then
						player:AddInjury(i, "burn");
					else
						player:AddInjury(i, "gash");
						player:StartBleeding(i);
					end
					
					Clockwork.limb:TakeDamage(player, i, math.random(40, 75));
					
					wound_applied = true;
				end
			end
			
			player:SetHealth(math.max(player:Health() - math.random(25, 40), 1));
		end
		
		-- FOR MELEE TEST ONLY
		if melee_test_enabled == true then
			if not player:HasBelief("fighter") then
				self:ForceTakeBelief(player, "fighter");
				self:ForceTakeBelief(player, "halfsword_sway");
				self:ForceTakeBelief(player, "parrying");
				self:ForceTakeBelief(player, "deflection");
				self:ForceTakeBelief(player, "strength");
				
				level = level + 5;
			else
				self:ForceTakeBelief(player, "halfsword_sway");
				self:ForceTakeBelief(player, "parrying");
				self:ForceTakeBelief(player, "deflection");
				
				level = level + 3;
			end
			
			self:ForceTakeBelief(player, "defender");
			--self:ForceTakeBelief(player, "warden");
			self:ForceTakeBelief(player, "hauberk");
			
			level = level + 2;
		end
		
		if level > 1 then
			player:SetSacramentLevel(level);
		end
		
		player:SetCharacterData("beliefsSetup", true);
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

	player:NetworkBeliefs();
end;

function cwBeliefs:PlayerDeath(player, inflictor, attacker, damageInfo)
	if IsValid(attacker) and attacker:IsPlayer() and not player.opponent and not attacker.opponent then
		if attacker:HasBelief("brutality_finisher") then
			attacker:SetHealth(attacker:GetMaxHealth());
			attacker:SetCharacterData("Stamina", attacker:GetMaxStamina());
			--attacker:SetNWInt("meleeStamina", attacker:GetMaxPoise());
			attacker:SetNWInt("stability", attacker:GetMaxStability());
			
			attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
			
			timer.Simple(0.2, function()
				if IsValid(attacker) then
					attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
				end
			end);
		end
		
		if player:CharPlayTime() > 1800 then
			local attackerFaction = attacker:GetFaction();
			local attackerFactionTable = Clockwork.faction:FindByID(attackerFaction);
			
			if attackerFactionTable then
				local playerFaction = player:GetFaction();
				local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
				
				if kinisgerOverride and attackerFaction ~= "Children of Satan" then
					playerFaction = kinisgerOverride;
				end
				
				-- Make sure players can't get XP from damaging the same faction as them!
				if (attackerFaction ~= playerFaction and (!attackerFactionTable.alliedfactions or !table.HasValue(attackerFactionTable.alliedfactions, playerFaction))) or attackerFaction == "Wanderer" then
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

-- A function to get the maximum weight a player can carry.
function cwBeliefs:PlayerAdjustMaxWeight(player, weight)
	local new_weight = weight;
	
	if player:HasBelief("might") then
		new_weight = new_weight + (weight * 0.5);
	end
	
	if player:HasBelief("prowess_finisher") then
		new_weight = new_weight + (weight * 0.5);
	end
	
	if player.GetCharmEquipped and player:GetCharmEquipped("spine_soldier") then
		new_weight = new_weight + (weight * 0.25);
	end
	
	weight = math.Round(new_weight);
	
	return weight;
end

-- Called when a player attempts to use an item.
function cwBeliefs:PlayerCanUseItem(player, itemTable, noMessage)
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
		if not clothesItem or (clothesItem and (clothesItem.weightclass ~= "Heavy")) then
			local cash = player:GetCash();
			local health = player:Health();
			local maxHealth = player:GetMaxHealth();
			local lowerBound = maxHealth * 0.25;
			local modifier = math.Clamp(-(((health - lowerBound) / (maxHealth - lowerBound)) - 1), 0, 1);
			local bonus = 0.2 * modifier;
			
			--[[
			if cash >= 100 and cash < 250 then
				bonus = bonus * 0.75;
			elseif cash >= 250 and cash < 500 then
				bonus = bonus * 0.5;
			elseif cash >= 500 and cash < 1000 then
				bonus = bonus * 0.25;
			elseif cash >= 1000 then
				bonus = 0;
			end
			--]]

			infoTable.runSpeed = infoTable.runSpeed + (infoTable.runSpeed * bonus);
			infoTable.walkSpeed = infoTable.walkSpeed + (infoTable.walkSpeed * bonus);
		end
	end
	
	if player.warcrySlowSpeed then
		if player.warcrySlowSpeed > curTime then
			infoTable.runSpeed = infoTable.runSpeed * 0.85;
			infoTable.walkSpeed = infoTable.walkSpeed * 0.85;
		else
			player.warcrySlowSpeed = nil;
		end
	elseif player.fearsomeSpeed then
		infoTable.runSpeed = infoTable.runSpeed * 1.1;
	end
end