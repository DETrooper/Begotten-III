--[[
	Begotten III: Jesus Wept
--]]

local longshipXP = 300;

function cwSailing:EntityTakeDamageNew(entity, damageInfo)
	local class = entity:GetClass();
	
	if (class == "cw_longship" or class == "cw_steam_engine") then
		local attacker = damageInfo:GetAttacker();
		local damageType = damageInfo:GetDamageType();
		local damageAmount = damageInfo:GetDamage();
		
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
				
				if class == "cw_steam_engine" then
					entity:EmitSound("physics/metal/metal_box_strain"..tostring(math.random(1, 4))..".wav");
				else
					entity:EmitSound("physics/wood/wood_strain"..tostring(math.random(2, 4))..".wav");
				end
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
				
				if class == "cw_steam_engine" then
					entity:EmitSound("physics/metal/metal_box_strain"..tostring(math.random(1, 4))..".wav");
				else
					entity:EmitSound("physics/wood/wood_strain"..tostring(math.random(2, 4))..".wav");
				end
			end
		end
	end
end

-- Called when a player uses an unknown item function.
function cwSailing:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if !self.shipLocations then
		return;
	end;
	
	if itemFunction == "dock" or itemFunction == "undock" or itemFunction == "rename" then
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