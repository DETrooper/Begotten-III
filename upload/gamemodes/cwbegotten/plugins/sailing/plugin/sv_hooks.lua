--[[
	Begotten III: Jesus Wept
--]]

local longshipXP = 300;

function cwSailing:EntityTakeDamageNew(entity, damageInfo)
	if (entity:GetClass() == "cw_longship") then
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


-- Called when a player uses an unknown item function.
function cwSailing:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if !SHIP_LOCATIONS then
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
		
		if (action == "burn_longship" or action == "extinguish_longship" or action == "repair_longship") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

function cwSailing:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "burn_longship" or action == "extinguish_longship" or action == "repair_longship") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
	end
end

function cwSailing:SetupMove(player, moveData)
	if (player.disableMovement) then
		moveData:SetVelocity(Vector(0, 0, 0));
	end;
end;