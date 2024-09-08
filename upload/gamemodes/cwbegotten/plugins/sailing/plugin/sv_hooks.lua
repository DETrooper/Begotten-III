--[[
	Begotten III: Jesus Wept
--]]

local longshipXP = 300;

-- Called when Clockwork has loaded all of the entities.
function cwSailing:ClockworkInitPostEntity()
	self:LoadLongships();
end

-- Called just after data should be saved.
function cwSailing:PostSaveData()
	self:SaveLongships();
end

function cwSailing:EntityTakeDamageNew(entity, damageInfo)
	local class = entity:GetClass();
	
	if (class == "cw_longship") then
		local attacker = damageInfo:GetAttacker();
		local curTime = CurTime();
		local damageType = damageInfo:GetDamageType();
		local damageAmount = damageInfo:GetDamage();
		local owner = entity.owner;
		
		if entity.health <= 700 and IsValid(owner) and owner:GetSubfaction() == "Clan Harald" and owner:Alive() and owner:HasBelief("daring_trout") and (!owner.nextShipDamageNotif or curTime > owner.nextShipDamageNotif) then
			owner.nextShipDamageNotif = curTime + 60;
			Schema:EasyText(owner, "icon16/anchor.png", "red", "A raven lands on your shoulder, clutching a torn piece of your longship's sail in its beak! Your longship is being damaged and may soon be destroyed if you do not act!");
		end
		
		if damageAmount >= 20 then
			if damageType == 4 then -- SLASH
				local damageDealt = math.ceil(damageAmount / 20);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
				end
				
				if IsValid(attacker) and attacker:IsPlayer() then
					if attacker:GetFaction() ~= "Goreic Warrior" then
						local damagePercentage = math.min(damageDealt / 500, 1);
							
						attacker:HandleXP(math.Round(longshipXP * damagePercentage)); 
					end
				end
				
				entity:EmitSound("physics/wood/wood_strain"..tostring(math.random(2, 4))..".wav");
			elseif damageType == 128 then -- BLUNT
				local damageDealt = math.ceil(damageAmount / 12);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
				end
				
				if IsValid(attacker) and attacker:IsPlayer() then
					if attacker:GetFaction() ~= "Goreic Warrior" then
						local damagePercentage = math.min(damageDealt / 500, 1);
							
						attacker:HandleXP(math.Round(longshipXP * damagePercentage)); 
					end
				end
				
				entity:EmitSound("physics/wood/wood_strain"..tostring(math.random(2, 4))..".wav");
			end
		end
	end
end

function cwSailing:CanPlayerMoveLongship(longshipEnt, caller)
	local owner = longshipEnt.owner;
	
	if !IsValid(owner) then
		if caller:GetCharacterKey() == longshipEnt.ownerID then
			owner = caller;
		end
	elseif longshipEnt.owner == caller and caller:GetCharacterKey() ~= longshipEnt.ownerID then
		owner = nil;
		
		longshipEnt.owner = nil;
	end

	if longshipEnt:GetNWBool("freeSailing") then return true end;

	if IsValid(owner) and owner:Alive() and ((owner:GetNetVar("tied", 0) ~= 0 and !owner:IsRagdolled()) or zones:IsPlayerInSupraZone(owner, "supragore")) then
		if owner == caller then
			return true;
		end
	elseif caller:GetFaction() == "Goreic Warrior" or caller:GetNetVar("kinisgerOverride") == "Goreic Warrior" then
		return true;
	end
	
	if caller:IsAdmin() and caller.cwObserverMode then
		return true;
	end
	
	return false;
end

-- Called when a player's character has been loaded.
function cwSailing:PlayerCharacterLoaded(player)
	if player:GetFaction() == "Goreic Warrior" then
		local characterID = player:GetCharacterKey();
		
		if !characterID then return end;
		
		for i, v in ipairs(ents.FindByClass("cw_longship*")) do
			if v.ownerID == characterID then
				v.owner = player;
			end
		end
	end
end

-- Called when a player uses an unknown item function.
function cwSailing:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if !self.shipLocations then
		return;
	end;
	
	if --[[itemFunction == "dock" or]] itemFunction == "undock" or itemFunction == "rename" then
		if itemTable.OnUseCustom then
			itemTable:OnUseCustom(player, itemTable, itemFunction);
		end
	end;
end;

-- Called when a player presses a key.
function cwSailing:KeyPress(player, key)
	if (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "burn_longship" or action == "extinguish_longship" or action == "repair_longship" or action == "repair_alarm" or action == "repair_ironclad" or action == "refuel_ironclad") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

function cwSailing:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "burn_longship" or action == "extinguish_longship" or action == "repair_longship" or action == "repair_alarm" or action == "repair_ironclad" or action == "refuel_ironclad") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
	end
end

function cwSailing:GetShouldntThrallDropCatalyst(thrall)
	if zones and zones.stored then
		local zoneStyx = zones.stored["sea_styx"];
		
		if zoneStyx then
			local boundsTable = zoneStyx.bounds;
			
			return Schema:IsInBox(boundsTable.min, boundsTable.max, thrall:GetPos());
		end
	end
end

function cwSailing:IsEntityClimbable(class)
	if string.find(class, "cw_longship") then
		return true;
	end;
end

-- Called when an NPC has been killed.
function cwSailing:OnNPCKilled(npc)
	if IsValid(npc) then
		for i, longshipEnt in ipairs(ents.FindByClass("cw_longship*")) do
			if IsValid(longshipEnt) and longshipEnt.spawnedNPCs then
				for i2, v in ipairs(longshipEnt.spawnedNPCs) do
					if v == npc:EntIndex() then
						table.remove(longshipEnt.spawnedNPCs, i);
						break;
					end
				end
			end
		end
	end
end;

function cwSailing:EntityRemoved(npc)
	if IsValid(npc) and (npc:IsNPC() or npc:IsNextBot()) then
		for i, longshipEnt in ipairs(ents.FindByClass("cw_longship*")) do
			if IsValid(longshipEnt) and longshipEnt.spawnedNPCs then
				for i2, v in ipairs(longshipEnt.spawnedNPCs) do
					if v == npc:EntIndex() then
						table.remove(longshipEnt.spawnedNPCs, i);
						break;
					end
				end
			end
		end
	end
end