--[[
	Begotten III: Jesus Wept
--]]

local requiredDistance = (256 * 256);
local sanity_interval = 60;
local map = game.GetMap();

cwSanity.DrainEntities = {
	--["cw_example"] = 1;
}

local sanitySafezones = {
	["gore"] = true,
	["tower"] = true,
	["gore_tree"] = true,
}

local sanitySubSafezones = {
	["wasteland"] = {
		{pos1 = Vector(-13813, -13472, -1546), pos2 = Vector(-13048, -12315, -1133)}, -- Castle 
		{pos1 = Vector(11278, -11108, -835), pos2 = Vector(14556, -13878, -1798)}, -- Caves
	},
};

local hellZones = {
	["hell"] = true,
	["manor"] = true,
}

-- Called at an interval while the player is connected to the server.
function cwSanity:PlayerThink(player, curTime, infoTable)
	if (!player.nextSanityDecay or player.nextSanityDecay <= curTime) then
		if (Clockwork.player:HasFlags(player, "E")) then
			player:HandleSanity(100);
			player.nextSanityDecay = curTime + sanity_interval;
			
			return;
		end
	
		local sanityDecay = -1;
	
		if (map != "rp_begotten3") then
			if (map == "rp_begotten_redux") or (map == "rp_scraptown") then
				if player:InTower() then
					player.nextSanityDecay = curTime + sanity_interval;
					
					local lastZone = player:GetCharacterData("LastZone");
					
					if (sanitySafezones[lastZone]) then
						sanityDecay = sanityDecay + 3.5;
					elseif !cwDayNight or cwDayNight.currentCycle ~= "night" then
						sanityDecay = sanityDecay + 2;
					end
				end
			else
				player.nextSanityDecay = curTime + 1000
				
				return;
			end
		end;

		if (!player:Alive() or player:GetMoveType() == MOVETYPE_NOCLIP or player.opponent or player:GetRagdollState() == RAGDOLL_KNOCKEDOUT or player.cwWakingUp or (player.possessor and IsValid(player.possessor)) or (player.victim and IsValid(player.victim))) then
			player.nextSanityDecay = curTime + sanity_interval;
			
			return;
		end;
		
		local lastZone = player:GetCharacterData("LastZone");
		
		if !lastZone or string.find(lastZone, "sea") then
			player.nextSanityDecay = curTime + sanity_interval;
		
			return;
		end
		
		if (lastZone == "hell" and self.hellZoneSanityDisabled) then
			player.nextSanityDecay = curTime + sanity_interval;
			
			return;
		end;
		
		local subfaction = player:GetSubfaction();
		
		if (subfaction == "Rekh-khet-sa") then
			player.nextSanityDecay = curTime + sanity_interval;
			
			return;
		end;

		local playerPos = player:GetPos();
		local drainEntities = self.DrainEntities;

		for i = 1, #entsGetAllThisPlayerTick do
			local entTab = entsGetAllThisPlayerTick[i];
			local entity = entTab.entity;
			local position = entTab.position;
			local distToSqr = position:DistToSqr(playerPos);

			if (distToSqr > requiredDistance) then
				continue
			end;
			
			local bIsPlayer = entTab.bIsPlayer;
			
			if (bIsPlayer and entity != player) then
				if !entity:Alive() then
					sanityDecay = sanityDecay - 1.5;
				end;
				
				if (player:GetFaith() != "Faith of the Dark" and entity:GetFaith() == "Faith of the Dark" and entity:HasBelief("blank_stare")) then
					local entityFaction = entity:GetFaction();
					local playerFaction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
					local kinisgerOverride = entity:GetSharedVar("kinisgerOverride");
					local factionTable = Clockwork.faction:FindByID(entityFaction);
					local alliedFactions = {};
					
					if factionTable.alliedfactions then
						alliedFactions = table.Copy(factionTable.alliedfactions);
					end
					
					-- Check faction twice in case player is disguised.
					if !kinisgerOverride and entityFaction ~= playerFaction and entityFaction ~= player:GetFaction() and !table.HasValue(alliedFactions, playerFaction) then
						sanityDecay = sanityDecay - 1.5;
					end
				end
			end;
			
			local class = entTab.class;
			local bRagdoll = (class == "prop_ragdoll");
			local bIsNPC = entTab.bIsNPC;
			local toothboy = entity == toothBoy;

			if (drainEntities[class] or bRagdoll or bIsNPC or toothboy) then
				local entity = entTab.entity;
				local isOnFire = entity:IsOnFire();
				
				if (!entity or !IsValid(entity) or entity:IsWorld()) then
					continue;
				end;
				
				if (drainEntities[class]) then
					sanityDecay = sanityDecay + drainEntities[class]; -- sanity loss for any other classes
				elseif (bRagdoll) then
					if (isOnFire) then
						sanityDecay = sanityDecay - 1; -- sanity loss from burning players and corpses
					end;
				elseif (toothboy) then
					sanityDecay = sanityDecay - 1; -- sanity loss from toothboy
				end;
			elseif (!bIsPlayer and !bRagdoll) then
				if (isOnFire or class == "env_fire") then
					sanityDecay = sanityDecay + 2; -- sanity gain from fires etc
				end;
			end;
		end;

		local activeWeapon = player:GetActiveWeapon()
		
		if (IsValid(activeWeapon)) then
			if (activeWeapon:GetClass() == "cw_lantern") then
				sanityDecay = sanityDecay + 2;
			end
		end
		
		local cycle = cwDayNight.currentCycle;
		local bNight = tobool(cycle == "night")
		local playerFaction = player:GetSharedVar("kinisgerOverride") or player:GetFaction()
		
		if (player.LightColor) then
			local requiredLight = 15;
			local lightColor = player.LightColor
			local r, g, b = lightColor.r, lightColor.g, lightColor.b

			if (r > requiredLight or g > requiredLight or b > requiredLight) then
				if (lastZone == "wasteland") then
					if sanityDecay < 0 then
						sanityDecay = math.Round(sanityDecay / 5); -- When by a fire or using a lantern you'll lose significantly less sanity.
					end
				end
			else
				sanityDecay = sanityDecay - 1; -- sanity loss from darkness
			end
		end
		
		if sanitySubSafezones[lastZone] then
			for i = 1, #sanitySubSafezones[lastZone] do
				local subSafezoneTab = sanitySubSafezones[lastZone][i];
				
				if playerPos:WithinAABox(subSafezoneTab.pos2, subSafezoneTab.pos1) then
					sanityDecay = sanityDecay + 3.5;

					break;
				end
			end
		elseif (sanitySafezones[lastZone]) or (string.find(lastZone, "gore") and playerFaction == "Goreic Warrior") then
			sanityDecay = sanityDecay + 3.5;
		elseif (lastZone == "wasteland" and bNight) then
			if (map == "rp_begotten_redux") or (map == "rp_scraptown") then
				if !player:InTower() then
					local decay = 3;
					
					if player:HasBelief("thirst_blood_moon") then
						decay = (decay - 1.5);
					end
				
					if player:HasBelief("lunar_repudiation") then
						decay = (decay - 1.5);
					end

					sanityDecay = (sanityDecay - decay);
				end
			else
				local decay = 3;
				
				if player:HasBelief("thirst_blood_moon") then
					decay = (decay - 1.5);
				end
			
				if player:HasBelief("lunar_repudiation") then
					decay = (decay - 1.5);
				end

				sanityDecay = (sanityDecay - decay);
			end
		elseif (lastZone == "caves") then
			sanityDecay = (sanityDecay - 2);
		end;

		if (hellZones[lastZone]) then
			if (player:GetFaith() ~= "Faith of the Dark") then
				sanityDecay = sanityDecay - 5;
			else
				sanityDecay = sanityDecay + 5;
			end;
		end;

		if player.banners then
			for k, v in pairs(player.banners) do
				if v == "glazic" then
					if playerFaction == "Gatekeeper" or playerFaction == "Holy Hierarchy" then
						sanityDecay = sanityDecay + 2;
					
						break;
					end
				end
			end
		end

		--print("Sanity decay for player "..player:Name()..": "..sanityDecay);
		
		player:HandleSanity(sanityDecay)

		if (player:HasBelief("prudence")) then
			player.nextSanityDecay = curTime + (sanity_interval * 1.25);
		else
			player.nextSanityDecay = curTime + sanity_interval;
		end;
	end
end

for k, v in pairs (_player.GetAll()) do
	v.nextSanityDecay = nil
end;

-- Called when the player looks at an entity.
function cwSanity:PlayerOnHit(player, entity) end

-- Called when an entity takes damage.
function cwSanity:EntityTakeDamageNew(entity, attacker, inflictor, hitGroup, damageInfo)
	if (entity:IsPlayer() and attacker:IsPlayer()) then
		local sanity = attacker:GetCharacterData("sanity")
		local damage = damageInfo:GetDamage()
		local curTime = CurTime()
		
		if (sanity >= 70) then
			attacker:HandleSanity(-0.15)
		end

		if (!entity.nextSanityDamage or entity.nextSanityDamage < curTime) then
			entity.nextSanityDamage = curTime + 10

			if (damage > 15) then
				local activeWeapon = attacker:GetActiveWeapon()
				local entityPosition = entity:GetPos()
				
				if (IsValid(activeWeapon) and activeWeapon:GetClass() != "begotten_fists") then
					for k, v in pairs (ents.FindInSphere(entityPosition, 768)) do
						if (!v:IsPlayer() or v == attacker or v == entity) then
							continue
						end
						
						local index = v:EntIndex()
						local enemies = entity.enemies
						
						if (!enemies) then
							enemies = {}
						end
						
						if (enemies[index]) then
							continue
						end

						if (Clockwork.entity:CanSeePlayer(entity, v)) then
							local sanity = v:GetCharacterData("sanity")
							
							if (sanity >= 50) then
								v:HandleSanity(-0.15)
							end
						end
					end
				end
			else
				local sanity = entity:GetCharacterData("sanity")
				
				if (sanity >= 50) then
					entity:HandleSanity(-0.25)
				end
			end
		end
	end
end

-- Called when a player is killed.
function cwSanity:PlayerDeath(player, inflictor, attacker)
	local curTime = CurTime()
	
	if (IsValid(attacker) and attacker:IsPlayer() and !attacker.opponent) then
		if (!attacker.nextSanityDeath or attacker.nextSanityDeath < curTime) then
			attacker.nextSanityDeath = curTime + 10
			
			local sanity = attacker:GetCharacterData("sanity", 100)
			
			if (attacker:HasTrait("pacifist")) and !attacker.possessor then
				attacker:HandleSanity(-40);
				Clockwork.chatBox:Add(attacker, nil, "itnofake", "You feel your sanity slipping as you take the life of another.");
			elseif (sanity >= 70) then
				attacker:HandleSanity(-1)
			end
			
			local position = player:GetPos()
			
			for k, v in pairs (ents.FindInSphere(position, 768)) do
				if (!v:IsPlayer() or v == player or v == attacker) then
					continue
				end
				
				local index = v:EntIndex()

				if (!player.enemies) then
					player.enemies = {}
				end
				
				if (player.enemies[index]) then
					continue
				end
				
				if (Clockwork.entity:CanSeePlayer(player, v)) then
					local vSanity = v:GetCharacterData("sanity", 100)
					
					if (vSanity >= 50) then
						v:HandleSanity(-0.75)
					end
				end
			end
		end
	end
	
	player:HandleSanity(100);
end

-- Called when the player spawns.
function cwSanity:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		if player:HasTrait("insane") then
			player:SetCharacterData("sanity", player:GetCharacterData("sanity") or 40);
		else
			player:SetCharacterData("sanity", player:GetCharacterData("sanity") or 100);
		end
	end
	
	if (player.enemies and #player.enemies > 0) then
		player.enemies = {}
	end
	
	player:SetSharedVar("sanity", player:GetCharacterData("sanity", 100));
end

function cwSanity:CanHearClass(listener, speaker, class)
	if listener:Sanity() <= 20 and (!cwBeliefs or !listener:HasBelief("saintly_composure")) then
		for k, v in pairs(self.deafClasses) do
			if k == class then
				if v == true and IsValid(speaker) then
					Clockwork.datastream:Start(listener, "SanitySpeech", speaker:GetPos());
				end
			
				return false;
			end
		end
	end
end

-- Called when the player's shared vars are set.
function cwSanity:OnePlayerHalfSecond(player)
	local sanity = math.Round(player:GetCharacterData("sanity", 100));
	
	if player:GetSharedVar("sanity", 100) < sanity then
		player:SetSharedVar("sanity", sanity);
	end
end

-- Called when the player's character data should be restored.
function cwSanity:PlayerRestoreCharacterData(player, data)
	local traits = data["Traits"];

	if traits and table.HasValue(traits, "insane") then
		data["sanity"] = data["sanity"] or 40
	else
		data["sanity"] = data["sanity"] or 100
	end
end

-- Called when the player's sanity degrades by any amount.
function cwSanity:SanityDegrade(player, oldSanity, newSanity, amount)
	local amount = math.abs(amount)
	
	if (amount >= 2) then
		--player:PlaySound("begotten/ui/sanity_damage.mp3", 100, 90)
		
		if (amount >= 5 and newSanity < 50) then
			--Clockwork.datastream:Start(player, "SanityZoom")
		end
	end
end

-- Called when the player's sanity is improved by any amount.
function cwSanity:SanityGain(player, oldSanity, newSanity, amount)
	--player:PlaySound("begotten/ui/sanity_gain.mp3", 100, 100)
end