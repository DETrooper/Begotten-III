--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Called to get whether a player can perform a ritual or not.
function cwRituals:PlayerCanPerformRitual(player, uniqueID, bIgnoreItems, bIgnoreBeliefs)
	local ritualTable = self.rituals.stored[uniqueID];
	local requirements = ritualTable.requirements;
	
	if (table.IsEmpty(requirements)) and !bIgnoreItems then
		return;
	end;
	
	local inventory = player:GetInventory();
	local access = ritualTable.access;
	local hasBeliefs = false;
	local hasRequirements = true;
	local hasFlags = true;
	local requiredSubfaction = ritualTable.requiredSubfaction;
	local requiredBeliefsSubfactionOverride = ritualTable.requiredBeliefsSubfactionOverride;
	local onerequiredbelief = ritualTable.onerequiredbelief;
	local subfaction = player:GetSubfaction();
	local subfaith = player:GetNetVar("subfaith");
	
	if Clockwork.player:GetAction(player) or player:IsRagdolled() or !player:Alive() or player.opponent or (cwDueling and cwDueling:PlayerIsInMatchmaking(player)) or player:GetNetVar("tied") != 0 or player.possessor then
		Schema:EasyText(player, "peru", "Your character cannot perform a ritual at this moment!");
		return false;
	end
	
	if (access) then
		if (!Clockwork.player:HasFlags(player, access)) then
			hasFlags = false;
		end;
	end;
	
	if !bIgnoreBeliefs and cwBeliefs and player.HasBelief then
		if !subfaith or (subfaith and (subfaith == "" or subfaith == "N/A")) then
			Schema:EasyText(player, "chocolate", "You must have a subfaith in order to perform a ritual!");
			return false;
		end
		
		
		if requiredBeliefsSubfactionOverride then
			for k, v in pairs(requiredBeliefsSubfactionOverride) do
				if k == subfaction then
					for i = 1, #v do
						if player:HasBelief(v[i]) then
							hasBeliefs = true;
							break;
						end
					end
				end
				
				if hasBeliefs then
					break;
				end
			end
		end
		
		if !hasBeliefs and onerequiredbelief then
			for i = 1, #onerequiredbelief do
				if player:HasBelief(onerequiredbelief[i]) then
					hasBeliefs = true;
					break;
				end
			end
		else
			hasBeliefs = true;
		end
		
		if !hasBeliefs then
			Schema:EasyText(player, "chocolate", "You do not have the belief required to perform this ritual!");
			return false;
		end
	end
	
	if requiredSubfaction and subfaction then
		if not table.HasValue(requiredSubfaction, subfaction) then
			Schema:EasyText(player, "chocolate", "You are not the correct subfaction to perform this ritual!");
			return false;
		end
	end
	
	if !bIgnoreItems then
		local counts = {};
		
		for i = 1, #requirements do
			if counts[requirements[i]] then
				counts[requirements[i]] = counts[requirements[i]] + 1;
			else
				counts[requirements[i]] = 1;
			end
		end;

		for i = 1, #requirements do
			if (!Clockwork.inventory:HasItemCountByID(inventory, requirements[i], counts[requirements[i]])) then
				Schema:EasyText(player, "chocolate", "You do not have the items required to perform this ritual!");
				hasRequirements = false;

				break;
			end;
		end;
	end

	return hasFlags, hasRequirements;
end;

-- Called once the player finishes performing a ritual.
function cwRituals:PlayerFinishedRitual(player, ritualTable)
	if ritualTable.experience then
		if cwBeliefs and player.HasBelief and (player:HasBelief("mother") or player:HasBelief("satanism")) then
			player:HandleXP(ritualTable.experience * 2);
		else
			player:HandleXP(ritualTable.experience);
		end
	end
	
	if !ritualTable.isSilent then
		player:EmitSound("possession/spiritsting.wav");
	end
	
	Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID()..") has performed the "..ritualTable.name.." ritual.");
end;

-- Called when a player fails to perform a ritual.
function cwRituals:PlayerFailedRitual(player, uniqueID, ritualTable, bHasRequirements, bHasFlags)
	--[[if (bHasRequirements == false) then
		player:Notify("You do not have all the required material necessary to ritual this!")
	elseif (bHasFlags == false) then
		player:Notify("You do not have the proper skills to ritual this! Pick up a fucking book, idiot!")
	end;]]--

	--[[if (ritualTable.failSound and isstring(ritualTable.failSound)) then
		player:EmitSound(ritualTable.failSound, 70);
	end;]]--
	
	if (ritualTable.OnFail) then
		ritualTable:OnFail(player);
	end;
end;

-- A function used to peform a ritual.
function cwRituals:PerformRitual(player, uniqueID, itemIDs, bIgnoreItems, bIgnoreBeliefs)
	local curTime = CurTime();
	
	if (IsValid(player) and uniqueID and isstring(uniqueID)) then
		if (!player:GetNWInt("cwNextRitual") or player:GetNWInt("cwNextRitual")  < curTime) then
			player:SetNWInt("cwNextRitual", curTime + 10);
	
			local bHasFlags, bHasRequirements = hook.Run("PlayerCanPerformRitual", player, uniqueID, bIgnoreItems, bIgnoreBeliefs);
			local ritualTable = self.rituals.stored[uniqueID];

			if (ritualTable and bHasFlags != false and bHasRequirements != false) then
				if bIgnoreItems or self:PlayerMeetsRitualItemRequirements(player, ritualTable, itemIDs) then
					if (ritualTable.ritualTime) then
						if !ritualTable.isSilent then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins chanting a hymn.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
						end
						
						if (ritualTable.StartRitual) then
							if ritualTable:StartRitual(player) == false then
								return;
							end
						end;
						
						Clockwork.player:SetAction(player, "ritualing", ritualTable.ritualTime, 5, function()
							if (IsValid(player)) then
								if (ritualTable.EndRitual) then
									if ritualTable:EndRitual(player) == false then
										return;
									end
								end;
								
								ritualTable:PerformRitual(player, itemIDs, false, bIgnoreItems, bIgnoreBeliefs);
								
								if player:GetSubfaction() ~= "Rekh-khet-sa" then
									if ritualTable.corruptionCost then
										player:HandleNeed("corruption", ritualTable.corruptionCost);
									end
								end
							end;
						end);
						
						return true;
					else
						ritualTable:PerformRitual(player, itemIDs, true, bIgnoreItems, bIgnoreBeliefs);
						
						return true;
					end;
				end;
				
				return;
			elseif (!ritualTable) then
				return;
			end;
			
			hook.Run("PlayerFailedRitual", player, uniqueID, ritualTable, bHasRequirements, bHasFlags)
		else
			Schema:EasyText(player, "peru", "You must wait another "..-math.ceil(curTime - player:GetNWInt("cwNextRitual")).." seconds before attempting to perform a ritual again!")
		end;
	end;
end;

-- This function is expensive as FUCK. You can make a better one if you want cash.
function cwRituals:PlayerMeetsRitualItemRequirements(player, ritualTable, itemIDs, bTake)
	if !itemIDs or table.IsEmpty(itemIDs) then
		Schema:EasyText(player, "chocolate", "You have no items selected to perform a ritual with!");
		return false;
	end

	if isstring(ritualTable) then
		ritualTable = self.rituals.stored[ritualTable];
		
		if !ritualTable or isstring(ritualTable) then
			Schema:EasyText(player, "chocolate", "No valid ritual for this combination of items could be found!");
			return false;
		end
	end
	
	local inventory = player:GetInventory();
	local requirements = ritualTable.requirements;
	--[[local slottedItems = {};
	
	for i = 1, #itemIDs do
		local itemID = itemIDs[i];
		
		for k, v in pairs(inventory) do
			for k2, v2 in pairs(v) do
				if v2.itemID == itemID then
					local itemTable = Clockwork.inventory:FindItemByID(inventory, k, v2.itemID);
					
					table.insert(slottedItems, itemTable);
					break;
				end
			end
		end
	end
	
	local temptab = table.Copy(slottedItems);

	for i = 1, #requirements do
		if !temptab[i] or (temptab[i] ~= requirements[i]) then
			Schema:EasyText(player, "chocolate", "You do not meet the item requirements for this ritual!");
			return false;
		end
	end
	
	if #temptab > 0 then
		Schema:EasyText(player, "chocolate", "You do not meet the item requirements for this ritual!");
		return false;
	end]]--
	
	local counts = {};
	
	for i = 1, #requirements do
		if counts[requirements[i]] then
			counts[requirements[i]] = counts[requirements[i]] + 1;
		else
			counts[requirements[i]] = 1;
		end
	end;
	
	for i = 1, #requirements do
		if (!Clockwork.inventory:HasItemCountByID(inventory, requirements[i], counts[requirements[i]])) then
			Schema:EasyText(player, "chocolate", "You do not have the items required to perform this ritual!");
			return false;
		end;
	end;
	
	if bTake then
		for i = 1, #requirements do
			player:TakeItemByID(requirements[i]);
		end
	end
	
	return true;
end

function cwRituals:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if player:GetNetVar("enlightenmentActive") and !plyTab.opponent then
		if !plyTab.nextEnlightenmentTick or plyTab.nextEnlightenmentTick > curTime then
			plyTab.nextEnlightenmentTick = curTime + 5;
		
			for k, v in pairs(ents.FindInSphere(player:GetPos(), 666)) do
				if v:IsPlayer() and v:Alive() then
					if v:GetFaith() == "Faith of the Light" and v:GetSubfaith() ~= "Voltism" then
						if cwSanity then
							v:HandleSanity(2);
						end
					elseif v:GetSubfaction() == "Rekh-khet-sa" and !v.ritualOfShadow and !v.cwObserverMode and !v.cwWakingUp then
						local d = DamageInfo()
						d:SetDamage(3);
						d:SetDamageType(DMG_BURN);
						d:SetDamagePosition(v:GetPos() + Vector(0, 0, 48));
						d:SetAttacker(player);
						d:SetInflictor(player);
						
						v:TakeDamageInfo(d);
						v:EmitSound("player/pl_burnpain"..math.random(1, 3)..".wav");
						
						Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, v:Name().." has taken 3 damage from "..player:Name().."'s 'Enlightenment' ritual, leaving them at "..v:Health().." health.");
			
						netstream.Start(v, "Stunned", 3);
					end
				end
			end
		end
	end
end

-- Called when an item entity has taken damage (before armor damage is calculated).
function cwRituals:PreEntityTakeDamage(entity, damageInfo)
	if !entity.opponent then
		if entity.nobleStatureActive then
			if entity:GetVelocity():Length() == 0 then
				damageInfo:ScaleDamage(0.5);
			end
		end
		
		if damageInfo:IsDamageType(DMG_BULLET) or damageInfo:IsDamageType(DMG_BUCKSHOT) then
			local entPos = entity:GetPos();
			
			for _, v in _player.Iterator() do
				if v:GetNetVar("powderheelActive") and v:GetPos():Distance(entPos) <= config.Get("talk_radius"):Get() then
					damageInfo:ScaleDamage(0.5);
					
					break;
				end
			end
		end
	end
end

function cwRituals:PlayerCharacterLoaded(player)
	local charLastPlayed = player:QueryCharacter("LastPlayed");
	local entIndex = player:EntIndex();
	local subfaction = player:GetSubfaction();

	if charLastPlayed then
		if subfaction == "Kinisger" then
			local lastAppearanceChange = player:GetCharacterData("lastAppearanceChange");
		
			for _, v in _player.Iterator() do
				if IsValid(v) and v ~= player and v:HasInitialized() and v:GetFaction() ~= "Children of Satan" then
					local vCharLastPlayed = v:QueryCharacter("LastPlayed");

					if lastAppearanceChange and lastAppearanceChange > vCharLastPlayed then
						Clockwork.player:SetRecognises(v, player, false);
					end
				end
			end
		elseif player:GetFaction() ~= "Children of Satan" then
			for _, v in _player.Iterator() do
				if IsValid(v) and v ~= player and v:HasInitialized() and v:GetSubfaction() == "Kinisger" then
					local lastAppearanceChange = v:GetCharacterData("lastAppearanceChange");
					
					if lastAppearanceChange and lastAppearanceChange > charLastPlayed then
						Clockwork.player:SetRecognises(player, v, false);
					end
				end
			end
		end
	end
	
	if self.summonedNPCs then
		for i, v in ipairs(self.summonedNPCs) do
			if IsValid(v) and v.summonedFaith then
				if player:GetFaith() == v.summonedFaith then
					v:AddEntityRelationship(player, D_LI, 99);
				elseif v.summonedFaith == "Faith of the Family" then
					local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
					
					if faction == "Goreic Warrior" then
						v:AddEntityRelationship(player, D_LI, 99);
					else
						v:AddEntityRelationship(player,  D_HT, 99);
					end
				else
					v:AddEntityRelationship(player,  D_HT, 99);
				end
			end
		end
	end
	
	local kinisgerOverride = player:GetCharacterData("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetCharacterData("kinisgerOverrideSubfaction");
	
	if kinisgerOverride then
		player:SetNetVar("kinisgerOverride", kinisgerOverride);
	elseif player:GetNetVar("kinisgerOverride") then
		player:SetNetVar("kinisgerOverride", nil);
	end
	
	if kinisgerOverrideSubfaction then
		player:SetNetVar("kinisgerOverrideSubfaction", kinisgerOverrideSubfaction);
	elseif player:GetNetVar("kinisgerOverrideSubfaction") then
		player:SetNetVar("kinisgerOverrideSubfaction", nil);
	end
	
	if timer.Exists("auraMotherTimer_"..entIndex) then
		timer.Remove("auraMotherTimer_"..entIndex);
		
		player:SetNetVar("auraMotherActive", false);
	end
	
	if player:GetNetVar("blessingOfCoin") == true then
		player:SetNetVar("blessingOfCoin", false)
		
		if timer.Exists("BlessingOfCoinTimer_"..entIndex) then
			timer.Remove("BlessingOfCoinTimer_"..entIndex);
		end
	end

	if player.bloodHowlActive then
		player.bloodHowlActive = nil;
		
		if timer.Exists("BloodhowlTimer_"..entIndex) then
			timer.Remove("BloodhowlTimer_"..entIndex);
		end
	end
	
	if player.bloodWingsActive then
		player.bloodWingsActive = nil;
		
		if timer.Exists("BloodwingsTimer_"..entIndex) then
			timer.Remove("BloodwingsTimer_"..entIndex);
		end
	end
	
	if player.cloakBurningActive then
		player.cloakBurningActive = nil;
		
		if timer.Exists("CloakBurnTimer_"..entIndex) then
			timer.Remove("CloakBurnTimer_"..entIndex);
		end
	end
	
	if player.demonHunterActive then
		player.demonHunterActive = nil;
		player.thrallsToKill = nil;
		
		if timer.Exists("DemonHunterTimer_"..entIndex) then
			timer.Remove("DemonHunterTimer_"..entIndex);
		end
	end
	
	if player.drownedKingActive then
		player.drownedKingActive = nil;
		
		if timer.Exists("DrownedKingTimer_"..entIndex) then
			timer.Remove("DrownedKingTimer_"..entIndex);
		end
	end

	if timer.Exists("EmpoweredBloodTimer_"..entIndex) then
		timer.Remove("EmpoweredBloodTimer_"..entIndex);
	end
	
	if player.holyPowderkegActive then
		player.holyPowderkegActive = nil;
		
		if timer.Exists("HolyPowderTimer_"..entIndex) then
			timer.Remove("HolyPowderTimer_"..entIndex);
		end
	end
	
	if player:GetNetVar("kinisgerCloak") == true then
		player:SetNetVar("kinisgerCloak", false);
		
		if timer.Exists("kinisgerCloak_"..entIndex) then
			timer.Remove("kinisgerCloak_"..entIndex);
		end
	end

	if player.nobleStatureActive then
		player.nobleStatureActive = nil;
		
		if timer.Exists("NobleStatureTimer_"..entIndex) then
			timer.Remove("NobleStatureTimer_"..entIndex);
		end
	end
	
	if player.perseveranceActive then
		player.perseveranceActive = nil;
	
		if timer.Exists("PerseveranceTimer_"..entIndex) then
			timer.Remove("PerseveranceTimer_"..entIndex);
		end
	end
	
	if player:GetNetVar("princeOfThieves") == true then
		player:SetNetVar("princeOfThieves", false)
		
		if timer.Exists("PrinceOfThievesTimer_"..entIndex) then
			timer.Remove("PrinceOfThievesTimer_"..entIndex);
		end
	end
	
	if player.ritualOfShadow then
		player.ritualOfShadow = nil;
		
		if timer.Exists("RitualOfShadowTimer_"..entIndex) then
			timer.Remove("RitualOfShadowTimer_"..entIndex);
		end
	end
	
	if player.scornificationismActive then
		player.scornificationismActive = nil;
		
		if timer.Exists("ScornificationismTimer_"..entIndex) then
			timer.Remove("ScornificationismTimer_"..entIndex);
		end
	end

	if player.selectingRegrowthLimb then
		player.selectingRegrowthLimb = nil;
	end
	
	if player.soulscorchActive then
		player.soulscorchActive = nil;
		player:SetNetVar("soulscorchActive", false);
		
		if timer.Exists("SoulScorchTimer_"..entIndex) then
			timer.Remove("SoulScorchTimer_"..entIndex);
		end
	end
	
	if player:GetNetVar("steelWill") == true then
		player:SetNetVar("steelWill", false);
		
		if timer.Exists("SteelWillTimer_"..entIndex) then
			timer.Remove("SteelWillTimer_"..entIndex);
		end
	end
	
	if player.upstagedActive then
		player.upstagedActive = nil;
		
		if timer.Exists("UpstagedTimer_"..entIndex) then
			timer.Remove("UpstagedTimer_"..entIndex);
		end
	end
	
	if player:GetCharacterData("markedBySatanist") == true then
		player:SetNetVar("markedBySatanist", true);
	else
		if player:GetNetVar("markedBySatanist") == true then
			player:SetNetVar("markedBySatanist", false);
		end
	end
	
	if player:GetNetVar("yellowBanner") == true then
		player:SetNetVar("yellowBanner", false);
		
		if timer.Exists("YellowBannerTimer_"..entIndex) then
			timer.Remove("YellowBannerTimer_"..entIndex);
		end
	end
	
	if player:GetNetVar("powderheelActive") then
		player:SetNetVar("powderheelActive", false);
		
		if timer.Exists("PowderheelTimer_"..entIndex) then
			timer.Remove("PowderheelTimer_"..entIndex);
		end
	end
	
	if player:GetNetVar("enlightenmentActive") then
		player:SetNetVar("enlightenmentActive", false);
		
		if timer.Exists("EnlightenmentTimer_"..entIndex) then
			timer.Remove("EnlightenmentTimer_"..entIndex);
		end
	end
	
	netstream.Start(player, "LoadRitualBinds", player:GetCharacterData("BoundRitualsNew", {}));
end;

function cwRituals:EntityRemoved(entity)
	if entity:IsNPC() or entity:IsNextBot() then
		if self.summonedNPCs then
			for i, v in ipairs(self.summonedNPCs) do
				if v == entity then
					table.remove(self.summonedNPCs, i);
					
					break;
				end
			end
		end
	end
end

function cwRituals:FuckMyLife(entity, damageInfo)
	if !entity.opponent then
		if !entity:IsPlayer() then
			if entity:GetClass() == "prop_ragdoll" and Clockwork.entity:GetPlayer(entity) then
				entity = Clockwork.entity:GetPlayer(entity);
			else
				return;
			end
		end
		
		local attacker = damageInfo:GetAttacker();

		if IsValid(attacker) and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) then
			if entity.scornificationismActive and not entity.assassinated then
				--if damageInfo:GetDamage() >= (entity:Health() + 10) then
				if entity:Health() - damageInfo:GetDamage() <= 10 then
					damageInfo:SetDamage(math.max(entity:Health() - 10, 0));
										
					Clockwork.chatBox:Add(attacker, nil, "itnofake", "Your blow seemingly does not do fatal damage to "..entity:Name().."!");
					
					return true;
				end
			end
		end
	end
end
	
function cwRituals:DoPlayerDeath(player, attacker, damageInfo)
	if !player.opponent then
		if player:GetCharacterData("markedBySatanist") == true then
			if IsValid(attacker) and attacker:IsPlayer() and attacker:GetFaith() == "Faith of the Dark" then
				attacker:HandleXP(100);
				attacker:HandleNeed("corruption", -50);
				Clockwork.player:GiveCash(attacker, 300);
				
				Clockwork.chatBox:Add(attacker, nil, "itnofake", "As you strike down "..player:Name().." and fulfill the blood contract, you feel your pockets suddenly become heavier.");
				
				for _, v in _player.Iterator() do
					if v:HasInitialized() then
						if v == player or v:GetFaith() == "Faith of the Dark" then
							Clockwork.chatBox:Add(v, nil, "darkwhispernoprefix", "Death has been delivered to a marked one. "..player:Name().." has been dispatched and his soul now belongs to the Dark Lord.");
						end
					end
				end
			end
			
			player:SetCharacterData("markedBySatanist", false);
			player:SetNetVar("markedBySatanist", false);
		end
	end
end

function cwRituals:PlayerDeath(player)
	if !player.opponent then
		local entIndex = player:EntIndex();

		if player.soulscorchActive then
			local lastZone = player:GetCharacterData("LastZone");
			
			if (lastZone == "tower" or lastZone == "theater") and Schema.towerSafeZoneEnabled then
				Clockwork.chatBox:AddInTargetRadius(player, "me", "'s holy light sizzles out.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
			else
				local ragCorpse = player:GetRagdollEntity();
				local damage = 200;
				
				if cwBeliefs then
					damage = Lerp(math.min(player:GetCharacterData("level", 1), cwBeliefs.sacramentLevelCap) / (cwBeliefs.sacramentLevelCap), 60, 200);
				end
				
				Clockwork.chatBox:AddInTargetRadius(player, "me", "explodes in a holy purifying fireball!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				if IsValid(ragCorpse) then
					for i, v in ipairs(ents.FindInSphere(player:GetPos(), 196)) do
						local vPlayer;
						
						if v:IsPlayer() then
							vPlayer = v;
						elseif Clockwork.entity:IsPlayerRagdoll(v) then
							vPlayer = Clockwork.entity:GetPlayer(v);
						end
						
						if vPlayer then
							local faith = vPlayer:GetFaith();
							local subfaith = vPlayer:GetSubfaith();
							local damageInfo = DamageInfo();
				
							damageInfo:SetDamagePosition(vPlayer:GetPos() + Vector(0, 0, math.random(12, 64)));
							damageInfo:SetDamageForce(VectorRand() * 5);
							damageInfo:SetDamageType(DMG_BLAST);
							damageInfo:SetAttacker(player);
							
							if faith ~= "Faith of the Light" or (faith == "Faith of the Light" and subfaith == "Voltism") then
								damageInfo:SetDamage(damage);
							else
								damageInfo:SetDamage(damage / 2);
							end
							
							vPlayer:TakeDamageInfo(damageInfo);
						end;
					end;
					
					Clockwork.plugin:Call("SplatCorpse", ragCorpse, 60, VectorRand() * 5);
					
					local explosion = ents.Create("env_explosion");
					
					explosion:SetPos(player:GetPos());
					explosion:SetKeyValue("iMagnitude", "0");
					explosion:Spawn();
					explosion:Activate();
					explosion:Fire("Explode", "", 0);
				end
			end
		
			player.soulscorchActive = nil;
			player:SetNetVar("soulscorchActive", false);
			
			if timer.Exists("SoulScorchTimer_"..entIndex) then
				timer.Remove("SoulScorchTimer_"..entIndex);
			end
		end
		
		if timer.Exists("auraMotherTimer_"..entIndex) then
			timer.Remove("auraMotherTimer_"..entIndex);
			
			player:SetNetVar("auraMotherActive", false);
		end
		
		if timer.Exists("BlessingOfCoinTimer_"..entIndex) then
			timer.Remove("BlessingOfCoinTimer_"..entIndex);
			
			player:SetNetVar("blessingOfCoin", false);
		end
		
		if player.bloodHowlActive then
			player.bloodHowlActive = nil;
			
			if timer.Exists("BloodhowlTimer_"..entIndex) then
				timer.Remove("BloodhowlTimer_"..entIndex);
			end
		end
		
		if player.bloodWingsActive then
			player.bloodWingsActive = nil;
			
			if timer.Exists("BloodwingsTimer_"..entIndex) then
				timer.Remove("BloodwingsTimer_"..entIndex);
			end
		end
		
		if player.cloakBurningActive then
			player.cloakBurningActive = nil;
			
			if timer.Exists("CloakBurnTimer_"..entIndex) then
				timer.Remove("CloakBurnTimer_"..entIndex);
			end
		end
		
		if player.demonHunterActive then
			player.demonHunterActive = nil;
			player.thrallsToKill = nil;
			
			if timer.Exists("DemonHunterTimer_"..entIndex) then
				timer.Remove("DemonHunterTimer_"..entIndex);
			end
		end
		
		if player.drownedKingActive then
			player.drownedKingActive = nil;
			
			if timer.Exists("DrownedKingTimer_"..entIndex) then
				timer.Remove("DrownedKingTimer_"..entIndex);
			end
		end
		
		if player.holyPowderkegActive then
			player.holyPowderkegActive = nil;
			
			if timer.Exists("HolyPowderTimer_"..entIndex) then
				timer.Remove("HolyPowderTimer_"..entIndex);
			end
		end
		
		if player:GetNetVar("kinisgerCloak") == true then
			player:SetNetVar("kinisgerCloak", false);
			
			if timer.Exists("kinisgerCloak_"..entIndex) then
				timer.Remove("kinisgerCloak_"..entIndex);
			end
		end

		if player.nobleStatureActive then
			player.nobleStatureActive = nil;
			
			if timer.Exists("NobleStatureTimer_"..entIndex) then
				timer.Remove("NobleStatureTimer_"..entIndex);
			end
		end
		
		if player.perseveranceActive then
			player.perseveranceActive = nil;
		
			if timer.Exists("PerseveranceTimer_"..entIndex) then
				timer.Remove("PerseveranceTimer_"..entIndex);
			end
		end
		
		if player:GetNetVar("princeOfThieves") == true then
			player:SetNetVar("princeOfThieves", false)
			
			if timer.Exists("PrinceOfThievesTimer_"..entIndex) then
				timer.Remove("PrinceOfThievesTimer_"..entIndex);
			end
		end
		
		if player.ritualOfShadow then
			player.ritualOfShadow = nil;
			
			if timer.Exists("RitualOfShadowTimer_"..entIndex) then
				timer.Remove("RitualOfShadowTimer_"..entIndex);
			end
		end
		
		if player.scornificationismActive then
			player.scornificationismActive = nil;
			
			if timer.Exists("ScornificationismTimer_"..entIndex) then
				timer.Remove("ScornificationismTimer_"..entIndex);
			end
		end

		if player.selectingRegrowthLimb then
			player.selectingRegrowthLimb = nil;
		end
		
		if player:GetNetVar("steelWill") == true then
			player:SetNetVar("steelWill", false);
			
			if timer.Exists("SteelWillTimer_"..entIndex) then
				timer.Remove("SteelWillTimer_"..entIndex);
			end
		end

		if player.upstagedActive then
			player.upstagedActive = nil;
			
			if timer.Exists("UpstagedTimer_"..entIndex) then
				timer.Remove("UpstagedTimer_"..entIndex);
			end
		end
		
		if player:GetNetVar("yellowBanner") == true then
			player:SetNetVar("yellowBanner", false);
			
			if timer.Exists("YellowBannerTimer_"..entIndex) then
				timer.Remove("YellowBannerTimer_"..entIndex);
			end
		end
		
		if player:GetNetVar("powderheelActive") then
			player:SetNetVar("powderheelActive", false);
			
			if timer.Exists("PowderheelTimer_"..entIndex) then
				timer.Remove("PowderheelTimer_"..entIndex);
			end
		end
		
		if player:GetNetVar("enlightenmentActive") then
			player:SetNetVar("enlightenmentActive", false);
			
			if timer.Exists("EnlightenmentTimer_"..entIndex) then
				timer.Remove("EnlightenmentTimer_"..entIndex);
			end
		end
	end
end;

-- Called to check if a player does recognise another player.
function cwRituals:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	if player:GetFaith() == "Faith of the Dark" and target:GetNetVar("markedBySatanist") then
		return true;
	end
end;

function cwRituals:PlayerCanSwitchCharacter(player, character)
	if player.selectingNewAppearance or (Clockwork.player:GetAction(player) == "ritualing") then
		return false
	end
end;

-- Called when a player presses a key.
function cwRituals:KeyPress(player, key)
	if (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "ritualing" or action == "hell_teleporting" or action == "filling_bucket" or action == "filling_bottle") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

-- Called when a player has been ragdolled.
function cwRituals:PlayerRagdolled(player, state, ragdoll)
	local action = Clockwork.player:GetAction(player);
	
	if (action == "ritualing" or action == "hell_teleporting" or action == "filling_bucket" or action == "filling_bottle") then
		Clockwork.player:SetAction(player, nil);
	end
end;

function cwRituals:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "ritualing" or action == "hell_teleporting" or action == "filling_bucket" or action == "filling_bottle") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
	end
end

netstream.Hook("AppearanceAlterationMenu", function(player, data)
	if player.selectingNewAppearance then
		if data and data[1] and data[2] and data[3] and data[4] and data[5] then
			local blacklistedNames = {};
			
			if Schema.Ranks then
				for k, v in pairs(Schema.Ranks) do
					for i, v2 in ipairs(v) do
						if v2 ~= "" then
							table.insert(blacklistedNames, string.lower(v2));
						end
					end
				end
			end
			
			for i = 1, #blacklistedNames do
				local blacklistedName = blacklistedNames[i];
			
				if string.find(string.lower(data[1]), blacklistedName) then
					player.selectingNewAppearance = false;
				
					return;
				end
			end
			
			local selectedFaction = data[5];
			local factionTable = Clockwork.faction:FindByID(selectedFaction);
			local model_valid = false;
			
			if factionTable.models then
				for gender, v in pairs(factionTable.models) do
					for k2, v2 in pairs(v.heads) do
						local modelPath = "models/begotten/heads/"..v2.."_gore.mdl";
						
						if modelPath == data[2] and gender == string.lower(data[3]) then
							model_valid = true;
							
							break;
						end
					end
					
					if model_valid then
						break;
					end
				end
			end
			
			if !model_valid then
				player.selectingNewAppearance = false;
			
				return;
			end
			
			if (!Clockwork.faction:IsGenderValid(data[5] or "Wanderer", data[3])) then
				player.selectingNewAppearance = false;
			
				return;
			end;
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", "'s very flesh warps before your eyes, taking on the form of "..data[1]..".", player:GetPos(), config.Get("talk_radius"):Get() * 2);
			player:EmitSound("prototype/transform.mp3");
			
			timer.Simple(1, function()
				if !IsValid(player) then
					return;
				end
				
				local clothesItem = player:GetClothesEquipped();
				
				if clothesItem then
					clothesItem:OnPlayerUnequipped(player, nil, true);
				end
				
				local helmetItem = player:GetHelmetEquipped();
			
				if helmetItem then
					helmetItem:OnPlayerUnequipped(player, nil);
				end
				
				Clockwork.player:SetName(player, data[1]);
				Clockwork.player:SetDefaultModel(player);
				player:SetCharacterData("Model", data[2], true);
				player:SetCharacterData("Gender", data[3], true);
				player:SetCharacterData("PhysDesc", Clockwork.kernel:ModifyPhysDesc(data[4]));
				player:SetCharacterData("lastAppearanceChange", os.time());
				
				if cwShacks and cwShacks.shacks then
					local characterKey = player:GetCharacterKey();
					local shack = player:GetOwnedShack();
					
					if shack then
						cwShacks:ShackForeclosed(player, shack);
					end
					
					for k, v in pairs(cwShacks.shacks) do
						if v.coowners then
							for k2, v2 in pairs(v.coowners) do
								if k2 == characterKey then
									cwShacks:ShackCoownerRemoved(characterKey, k);
								
									break;
								end
							end
						end
					end
				end
				
				player:SetCharacterData("rankOverride", nil);
				
				if selectedFaction == "Wanderer" then
					player:SetCharacterData("kinisgerOverride", nil);
					player:SetNetVar("kinisgerOverride", nil);
					player:SetCharacterData("kinisgerOverrideSubfaction", nil);
					player:SetNetVar("kinisgerOverrideSubfaction", nil);
					player:SetCharacterData("rank", nil);
					player:OverrideName(nil);
				else
					if factionTable.imposters and !factionTable.disabled then
						player:SetCharacterData("kinisgerOverride", selectedFaction);
						player:SetNetVar("kinisgerOverride", selectedFaction);
						
						if factionTable.subfactions then
							local selectedSubfaction = data[6];
							
							if selectedSubfaction then
								for k, v in pairs(factionTable.subfactions) do
									if v.name == selectedSubfaction then
										player:SetCharacterData("kinisgerOverrideSubfaction", selectedSubfaction);
										player:SetNetVar("kinisgerOverrideSubfaction", selectedSubfaction);
										
										break;
									end
								end
							end
						end
						
						if Schema.Ranks then
							player:OverrideName(nil)
							
							if (Schema.Ranks[selectedFaction]) then
								local factionTable = Clockwork.faction:FindByID(selectedFaction);
								local subfaction = player:GetSubfaction();
								local subfactionRankFound = false;
								
								if subfaction and subfaction ~= "" and subfaction ~= "N/A" then
									if factionTable and factionTable.subfactions then
										for i = 1, #factionTable.subfactions do
											local isubfaction = factionTable.subfactions[i];
											
											if isubfaction.name == subfaction then
												if isubfaction.startingRank then
													player:SetCharacterData("rank", isubfaction.startingRank);
													subfactionRankFound = true;
													
													break;
												end
											end
										end
									end
								end
								
								if !subfactionRankFound then
									player:SetCharacterData("rank", 1);
								end

								local name = player:Name();
								local rank = math.Clamp(player:GetCharacterData("rank", 1), 1, #Schema.Ranks[selectedFaction]);
								
								if (rank and isnumber(rank) and Schema.Ranks[selectedFaction][rank]) then
									if Schema.Ranks[selectedFaction][rank] ~= "" then
										player:OverrideName(Schema.Ranks[selectedFaction][rank].." "..player:Name());
									end
								end;
							end;
						end
					end
				end
				
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() and v:GetFaction() ~= "Children of Satan" then
						Clockwork.player:SetRecognises(v, player, false);
					end
				end
				
				player:RemoveBounty();
				player:HandleNeed("corruption", 50);
				
				Clockwork.player:LoadCharacter(player, Clockwork.player:GetCharacterID(player));
			end);
		end;
		
		player.selectingNewAppearance = false;
	end
end)

netstream.Hook("ClosedAppearanceAlterationMenu", function(player, data)
	if player.selectingNewAppearance then
		-- Refund items from the Kinisger Appearance Alteration ritual.
		local ritualTable = cwRituals.rituals.stored["kinisger_appearance_alteration"];
		
		if ritualTable then
			if ritualTable.requirements then
				for i = 1, #ritualTable.requirements do
					player:GiveItem(item.CreateInstance(ritualTable.requirements[i]));
				end
			end
		end
		
		player.selectingNewAppearance = false;
	end
end)

netstream.Hook("DoRitual", function(player, data)
	if data and data[1] and data[2] then
		cwRituals:PerformRitual(player, data[1], data[2]);
	end
end)

netstream.Hook("RegrowthMenu", function(player, data)
	if player.selectingRegrowthLimb then
		if data and isnumber(data) then
			local hitGroup = data;
			
			Clockwork.limb:HealDamage(player, hitGroup, 100);
			player:RemoveInjury(data);
			player:SetHealth(math.min(player:Health() + 150, player:GetMaxHealth()));
			player:ModifyBloodLevel(1500);
			
			if player:GetCharacterData("BleedingLimbs", {})[data] then
				player:MakeLimbStopBleeding(data);
				Clockwork.hint:Send(player, "Your "..cwMedicalSystem.cwHitGroupToString[data].." stops bleeding...", 5, Color(100, 175, 100), true, true);
			end
			
			player:HandleNeed("corruption", 5);
			
			Clockwork.chatBox:Add(player, nil, "itnofake", "You feel your wounds heal as branches and leaves extend and retract into your flesh.");
		end
		
		player.selectingRegrowthLimb = false;
	end
end)

netstream.Hook("SaveRitualBinds", function(player, data)
	if data and istable(data) then
		player:SetCharacterData("BoundRitualsNew", data);
	end
end)