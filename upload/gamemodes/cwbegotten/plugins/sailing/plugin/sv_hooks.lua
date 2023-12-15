--[[
	Begotten III: Jesus Wept
--]]

local longshipXP = 1000;

function cwSailing:EntityTakeDamageNew(entity, damageInfo)
	if (entity:GetClass() == "cw_longship") then
		local attacker = damageInfo:GetAttacker();
		local damageType = damageInfo:GetDamageType();
		local damageAmount = damageInfo:GetDamage();
		
		if damageAmount > 30 then
			if damageType == 4 then -- SLASH
				local damageDealt = math.floor(damageAmount / 30);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
				end
				
				if IsValid(attacker) and attacker:IsPlayer() then
					if attacker:GetFaction() ~= "Goreic Warrior" then
						local damagePercentage = math.min(damageAmount / 500, 1);
							
						attacker:HandleXP(math.Round(longshipXP * damagePercentage)); 
					end
				end
				
				self:EmitSound(self.creaksounds[math.random(1, #self.creaksounds)]);
			elseif damageType == 128 then -- BLUNT
				local damageDealt = math.floor(damageAmount / 16);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
				end
				
				if IsValid(attacker) and attacker:IsPlayer() then
					if attacker:GetFaction() ~= "Goreic Warrior" then
						local damagePercentage = math.min(damageAmount / 500, 1);
							
						attacker:HandleXP(math.Round(longshipXP * damagePercentage)); 
					end
				end
				
				self:EmitSound(self.creaksounds[math.random(1, #self.creaksounds)]);
			end
		end
	end
end


-- Called when a player uses an unknown item function.
function cwSailing:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (game.GetMap() != "rp_begotten3") then
		return;
	end;
	
	if itemFunction == "dock" or itemFunction == "undock" then
		if itemTable.OnUseCustom then
			itemTable:OnUseCustom(player, itemTable, itemFunction);
		end
	end;
end;

function cwSailing:SetupMove(player, moveData)
	if (player.disableMovement) then
		moveData:SetVelocity(Vector(0, 0, 0));
	end;
end;