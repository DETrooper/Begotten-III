--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local playerMeta = FindMetaTable("Player")

function PLUGIN:PlayerThink(player, curTime)
	player.hitThisTick = false;
end

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["Hatred"]) then
		data["Hatred"] = math.Round(data["Hatred"]);
	end;
end;

-- Called just after a player spawns.
function PLUGIN:PostPlayerCharacterInitialized(player)
	local hatred = player:GetCharacterData("Hatred");
	
	if hatred then
		player:SetLocalVar("Hatred", hatred);
	elseif player:GetNetVar("Hatred") then
		player:SetLocalVar("Hatred", nil);
	end
end;

-- Called to get whether a player can give an item to storage.
function PLUGIN:PlayerCanGiveToStorage(player, storageTable, itemTable)
	if itemTable.attributes and table.HasValue(itemTable.attributes, "not_unequippable") then
		if itemTable:HasPlayerEquipped(player) then
			return false;
		end
	end
end

-- Called to get whether a player can take an item from storage.
function PLUGIN:PlayerCanTakeFromStorage(player, storageTable, itemTable)
	if itemTable.attributes and table.HasValue(itemTable.attributes, "not_unequippable") then
		if IsValid(storageTable.entity) and storageTable.entity:IsPlayer() then
			if itemTable:HasPlayerEquipped(storageTable.entity) then
				return false;
			end
		end
	end
end

function PLUGIN:DoPlayerDeath(player, attacker, damageInfo)
	-- Make sure player is not dueling.
	if not player.opponent then
		local clothesItem = player:GetClothesEquipped();
		local helmetItem = player:GetHelmetEquipped();
		
		if (clothesItem) then
			if !clothesItem.attributes or !table.HasValue(clothesItem.attributes, "not_unequippable") then
				clothesItem:TakeCondition(math.random(20, 40));
			end
		end;
		
		if (helmetItem) then
			if !helmetItem.attributes or !table.HasValue(helmetItem.attributes, "not_unequippable") then
				helmetItem:TakeCondition(math.random(20, 40));
			end
		end;
		
		if player:GetCharacterData("Hatred") then
			player:SetCharacterData("Hatred", nil);
			player:SetLocalVar("Hatred", nil);
		end
	end;
end;

function PLUGIN:EntityTakeDamageArmor(player, damageInfo)
	if damageInfo:IsDamageType(DMG_BLAST) then
		return;
	end
	
	local damagePosition;
	local hitGroup;
	
	if (Clockwork.entity:IsPlayerRagdoll(player)) then
		damagePosition = damageInfo:GetDamagePosition() or Vector(0, 0, 0);
		hitGroup = Clockwork.kernel:GetRagdollHitGroup(player, damagePosition)
		player = Clockwork.entity:GetPlayer(player);
	end;
	
	local attacker = damageInfo:GetAttacker();
	local originalDamage = damageInfo:GetDamage();
	
	if ((player:IsPlayer() or player.isTrainingDummy or (player:IsNextBot() and player.Armor)) and attacker and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot())) then
		local damageType = damageInfo:GetDamageType();
		local damageTypes = {DMG_BULLET, DMG_BUCKSHOT, DMG_CLUB, DMG_FALL, DMG_SLASH, DMG_VEHICLE};
		
		if !damagePosition then
			damagePosition = damageInfo:GetDamagePosition() or Vector(0, 0, 0);
		end
		
		if !hitGroup and player:IsPlayer() then
			hitGroup = player:LastHitGroup();
			
			if IsValid(attacker) then
				--local activeWeapon = attacker:GetActiveWeapon();
				
				--if IsValid(activeWeapon) and activeWeapon.Base == "sword_swepbase" then
					hitGroup = Clockwork.kernel:GetRagdollHitGroup(player, damagePosition);
				--end
			end
		end
		
		for i = 1, #damageTypes do
			if damageInfo:IsDamageType(damageTypes[i]) then
				damageType = damageTypes[i];
				break;
			end
		end

		if !table.HasValue(damageTypes, damageType) then
			return;
		end
		
		if (hitGroup == 0) then
			if attacker:IsNPC() or attacker:IsNextBot() then
				hitGroup = math.random(1, 7);
			else
				return 
			end;
		end
		
		if player:IsNextBot() and (damageType ~= DMG_BULLET and damageType ~= DMG_BUCKSHOT) then
			if attacker:IsPlayer() then
				local attackTable;
				local inflictor = damageInfo:GetInflictor()
				
				if IsValid(inflictor) and inflictor.AttackTable then
					attackTable = GetTable(inflictor.AttackTable);
				end
						
				if attackTable then
					local armorPiercing = 0;
					
					if attacker:GetNWBool("ThrustStance") and (!IsValid(inflictor) or (IsValid(inflictor) and !inflictor.isJavelin)) then
						armorPiercing = attackTable["altarmorpiercing"] or 0;
					else
						armorPiercing = attackTable["armorpiercing"] or 0;
					end
					
					if attacker:GetCharmEquipped("ring_penetration") then
						armorPiercing = armorPiercing + 10;
					end
					
					if (inflictor.Base == "sword_swepbase" or inflictor.isJavelin) and attacker:HasBelief("the_light") then
						armorPiercing = armorPiercing + (armorPiercing * 0.15);
					end
					
					if attacker:HasBelief("billman") then
						if (inflictor.Category and (string.find(inflictor.Category, "Polearm") or string.find(inflictor.Category, "Spear") or string.find(inflictor.Category, "Rapier"))) or inflictor.isJavelin then
							armorPiercing = armorPiercing + (armorPiercing * 0.2);
						end
					end
					
					local damage = damageInfo:GetDamage();
					
					if IsValid(inflictor) then
						if !inflictor.isJavelin then
							if string.find(inflictor:GetClass(), "begotten_dagger_") then
								armorPiercing = 100;
							elseif inflictor:GetClass() == "begotten_fists" then
								if attacker.GetCharmEquipped and attacker:GetCharmEquipped("ring_pugilist") then
									armorPiercing = 100;
								end
							end
						end
					end
					
					if inflictor.Base == "sword_swepbase" then
						local activeWeaponItemTable = item.GetByWeapon(inflictor);
						
						if activeWeaponItemTable then
							local activeWeaponCondition = activeWeaponItemTable:GetCondition() or 100;
							
							if damageType == DMG_CLUB then
								armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.7, 1));
							else
								armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.5, 1));
							end
						end
					end

					local effectiveness;
					
					if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
						effectiveness = damage;
					else
						effectiveness = math.Clamp(damage / (player.Armor / armorPiercing), 0, damage);
					end
					
					damageInfo:SetDamage(effectiveness);
				end;
			end;
		else
			local armorItem;
			local isTrainingDummy = player.isTrainingDummy;
			
			if !player:IsPlayer() and !isTrainingDummy then
				return;
			end
			
			if hitGroup == HITGROUP_HEAD then
				if isTrainingDummy then
					armorItem = player.helmet;
				else
					armorItem = player:GetHelmetEquipped();
				end
			end

			if !armorItem then
				if isTrainingDummy then
					armorItem = player.armor;
				else
					armorItem = player:GetClothesEquipped();
				end
			end
			
			if (armorItem and !table.IsEmpty(armorItem)) then
				--print("Checking Armor Item: "..armorItem.uniqueID);
				local effectiveLimbs = armorItem.effectiveLimbs or {};
				
				if (effectiveLimbs[hitGroup]) then
					--print("Armor Item Hit!");
					local damageTypeScales = armorItem.damageTypeScales;
					local pierceScale = armorItem.pierceScale;
					local bluntScale = armorItem.bluntScale;
					local slashScale = armorItem.slashScale;
					local armorPiercing = 0;
					local condition = armorItem:GetCondition() or 100;
					local damage = damageInfo:GetDamage();
					local inflictor = damageInfo:GetInflictor();
					--print("Damage: "..tostring(damage));
					
					if armorItem.attributes and table.HasValue(armorItem.attributes, "deathknell") then
						-- Bellhammer radius disorient
						for k, v in pairs(ents.FindInSphere(player:GetPos(), 200)) do
							if v:IsPlayer() then
								v:Disorient(1)
							end
						end
						
						player:EmitSound("meleesounds/bell.mp3");
					end
					
					if attacker:IsPlayer() and IsValid(inflictor) and (inflictor.isJavelin or inflictor:IsWeapon()) then
						local attackTable;

						if inflictor.AttackTable then
							attackTable = GetTable(inflictor.AttackTable);
						end
								
						--print("Attack table found for weapon!");
						if attackTable then
							if attacker:GetNWBool("ThrustStance") and (!IsValid(inflictor) or (IsValid(inflictor) and !inflictor.isJavelin)) then
								armorPiercing = attackTable["altarmorpiercing"] or 0;
								--print("Thrust stance.");
							else
								armorPiercing = attackTable["armorpiercing"] or 0;
								--print("Not thrust stance.");
							end
							
							if attacker:GetCharmEquipped("ring_penetration") then
								armorPiercing = armorPiercing + 10;
							end
							
							if (inflictor.Base == "sword_swepbase" or inflictor.isJavelin) and attacker:HasBelief("the_light") then
								armorPiercing = armorPiercing + (armorPiercing * 0.15);
							end
							
							if attacker:HasBelief("billman") then
								if (inflictor.Category and (string.find(inflictor.Category, "Polearm") or string.find(inflictor.Category, "Spear") or string.find(inflictor.Category, "Rapier"))) or inflictor.isJavelin then
									armorPiercing = armorPiercing + (armorPiercing * 0.2);
								end
							end
							
							--print("AP Value: "..tostring(armorPiercing));
							
							if IsValid(inflictor) then
								if !inflictor.isJavelin then
									if string.find(inflictor:GetClass(), "begotten_dagger_") then
										armorPiercing = 100;
										--print("Weapon is dagger, increasing AP value to 100.");
									elseif inflictor:GetClass() == "begotten_fists" then
										if attacker.GetCharmEquipped and attacker:GetCharmEquipped("ring_pugilist") then
											armorPiercing = 100;
										end
									end
								end
							end
							
							if inflictor.Base == "sword_swepbase" then
								local activeWeaponItemTable = item.GetByWeapon(inflictor);
								
								if activeWeaponItemTable then
									local activeWeaponCondition = activeWeaponItemTable:GetCondition() or 100;
									
									if damageType == DMG_CLUB then
										armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.7, 1));
									else
										armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.5, 1));
									end
								end
							end
						end;
					else
						armorPiercing = inflictor.ArmorPiercing or attacker.ArmorPiercing or 40;
					end;
					
					--print("Armor piercing: "..tostring(armorPiercing));
					
					local protection = armorItem.protection;
					
					-- If full suit of armor, give minor debuff for head armor.
					if hitGroup == HITGROUP_HEAD and armorItem.baseItem == "clothes_base" then
						protection = math.max(0, protection - 10);
					end
					
					if !isTrainingDummy then
						if player:GetSubfaction() == "Philimaxio" then
							protection = protection + (protection * 0.15);
						end
						
						if player:HasBelief("fortify_the_plate") then
							protection = protection + 10;
						end
						
						if player:HasBelief("shedskin") then
							protection = protection + (protection * 0.15);
						end
					end
					
					if (condition < 90) then
						--print("Reducing protection due to condition (ORIGINAL: "..tostring(protection)..")");
						protection = protection * (condition / 100);
					end;
					
					-- Make sure protection does not exceed maximum value of 95.
					protection = math.min(math.Round(protection), 95);
					
					--print("Armor protection value: "..tostring(protection));
					local effectiveness;
					
					if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
						effectiveness = damage;
					else
						effectiveness = math.Clamp(damage / (protection / armorPiercing), 0, damage);
					end
					
					damageInfo:SetDamage(effectiveness);
					--print("Setting damage from effectiveness to: "..tostring(damageInfo:GetDamage()));
					
					if (damageTypeScales and !table.IsEmpty(damageTypeScales)) then
						for k, v in pairs (damageTypeScales) do
							if (k == DMG_CLUB or k == DMG_SLASH or k == DMG_VEHICLE) then
								damageTypeScales[k] = nil;
							end;
						end;
						
						if (damageTypeScales[damageType] and isnumber(damageTypeScales[damageType])) then
							damageInfo:ScaleDamage(damageTypeScales[damageType])
							--print("Scaling damage by type "..damageType..": "..tostring(damageTypeScales[damageType]));
						end;
					end;
					
					if (armorItem.bluntScale and damageType == DMG_CLUB) then
						local dmgScale = 1 - ((1 - armorItem.bluntScale) * (condition / 100));
						
						damageInfo:ScaleDamage(dmgScale);
						--print("Scaling blunt damage: "..tostring(dmgScale));
					elseif (armorItem.slashScale and damageType == DMG_SLASH) then
						local dmgScale = 1 - ((1 - armorItem.slashScale) * (condition / 100));
						
						damageInfo:ScaleDamage(dmgScale);
						--print("Scaling slash damage: "..tostring(dmgScale));
					elseif (armorItem.pierceScale and (damageType == DMG_VEHICLE)) then
						local dmgScale = 1 - ((1 - armorItem.pierceScale) * (condition / 100));
					
						damageInfo:ScaleDamage(dmgScale);
						--print("Scaling pierce damage: "..tostring(dmgScale));
					elseif (armorItem.bulletScale and (damageType == DMG_BULLET or damageType == DMG_BUCKSHOT)) then
						if attacker:IsPlayer() then
							local activeWeapon = attacker:GetActiveWeapon();

							if (IsValid(activeWeapon) and !activeWeapon.IgnoresBulletResistance) then
								local dmgScale = 1 - ((1 - armorItem.bulletScale) * (condition / 100));
						
								damageInfo:ScaleDamage(dmgScale);
								--print("Scaling pierce damage: "..tostring(dmgScale));
							end
						else
							local dmgScale = 1 - ((1 - armorItem.bulletScale) * (condition / 100));
					
							damageInfo:ScaleDamage(dmgScale);
							--print("Scaling pierce damage: "..tostring(dmgScale));
						end
					end;
					
					--print("Final armor damage: "..tostring(damageInfo:GetDamage()));
					
					if not player.opponent then
						--print("Armor condition value: "..tostring(condition));
						local conditionLoss = math.Clamp(damageInfo:GetDamage() * 0.1, 0, 5) * (armorItem.conditionScale or 1);
						
						if !isTrainingDummy then
							if player:HasBelief("ingenuity_finisher") then
								conditionLoss = 0;
							else							
								if player:GetSubfaction() == "Philimaxio" then
									conditionLoss = conditionLoss / 2;
								end
								
								if player:HasBelief("scour_the_rust") then
									conditionLoss = conditionLoss / 2;
								end
							end
						end
						
						if not player.ignoreConditionLoss then
							armorItem:TakeCondition(conditionLoss);
							--print("Armor condition loss: "..tostring(conditionLoss));
							--print("New armor condition value: "..tostring(condition));
						end
					end
				end;
			end;
		end;
	end;

	if (player:IsPlayer() or player:IsNPC() or player:IsNextBot()) then
		if attacker then
			if (attacker:IsPlayer()) then
				-- This is required because of some stupid fucking ragdoll shit.
				if player:IsPlayer() then
					if !player.hitThisTick then
						player.hitThisTick = true;
						hook.Run("DoMeleeHitEffects", player, attacker, damageInfo:GetInflictor(), damageInfo:GetDamagePosition(), originalDamage, damageInfo);
					end
				else
					hook.Run("DoMeleeHitEffects", player, attacker, damageInfo:GetInflictor(), damageInfo:GetDamagePosition(), originalDamage, damageInfo);
				end
			elseif (attacker:IsNPC() or attacker:IsNextBot()) then
				if player:IsPlayer() then
					if !player.hitThisTick then
						player.hitThisTick = true;
						hook.Run("DoMeleeHitEffects", player, attacker, nil, damageInfo:GetDamagePosition(), originalDamage, damageInfo);
					end
				else
					hook.Run("DoMeleeHitEffects", player, attacker, nil, damageInfo:GetDamagePosition(), originalDamage, damageInfo);
				end
			end;
		end
	end;
end

function PLUGIN:PlayerCharacterUnloaded(player)
	for i = 0, player:GetNumBodyGroups() - 1 do
		player:SetBodygroup(i, 0)
	end

	player:SetSkin(0)
end

function PLUGIN:ModifyPlayerSpeed(player, infoTable)
	local clothesItem = player:GetClothesEquipped()

	if (clothesItem) then
		if clothesItem.weightclass == "Heavy" then
			if player:HasBelief("unburdened") then
				infoTable.runSpeed = infoTable.runSpeed * 0.85;
			else
				infoTable.runSpeed = infoTable.runSpeed * 0.75;
			end
			
			infoTable.jumpPower = infoTable.jumpPower * 0.75;
		elseif clothesItem.weightclass == "Medium" then
			if player:HasBelief("unburdened") then
				infoTable.runSpeed = infoTable.runSpeed * 0.95;
			else
				infoTable.runSpeed = infoTable.runSpeed * 0.85;
			end
			
			infoTable.jumpPower = infoTable.jumpPower * 0.9;
		end
		
		if clothesItem.attributes and table.HasValue(clothesItem.attributes, "rage") then
			if not player:GetShieldEquipped() then
				infoTable.runSpeed = infoTable.runSpeed * 1.07;
				infoTable.walkSpeed = infoTable.walkSpeed * 1.07;
			end
		end
	end
end

function PLUGIN:GetRollSound(player)
	local clothesItem = player:GetClothesEquipped()
	
	if (clothesItem) then
		if clothesItem.type == "plate" then
			return "armormovement/body-armor-rolling.wav.mp3";
		elseif clothesItem.type == "chainmail" then
			return "armormovement/body-hauberk-rolling.mp3";
		end
	end
	
	local model = player:GetModel();
	
	if (model == "models/begotten/gatekeepers/districtonearmor.mdl" or model == "models/begotten/wanderers/scrapperking.mdl") then
		return "npc/dog/dog_rollover_servos1.wav";
	end
end

function PLUGIN:GetRollTime(player)
	local clothesItem = player:GetClothesEquipped()
	
	if (clothesItem) then
		if clothesItem.weightclass == "Heavy" then
			if player:HasBelief("unburdened") then
				return 1;
			end
			
			return 1.1;
		elseif clothesItem.weightclass == "Medium" then
			if player:HasBelief("unburdened") then
				return 0.9;
			end
			
			return 1;
		end
	end
	
	local model = player:GetModel();
	
	if (model == "models/begotten/gatekeepers/districtonearmor.mdl" or model == "models/begotten/wanderers/scrapperking.mdl") then
		return 1.1;
	end
	
	return 0.9;
end