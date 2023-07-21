--[[
	Begotten III: Jesus Wept
--]]

function cwSailing:EntityTakeDamageNew(entity, damageInfo)
	if (entity:GetClass() == "cw_longship") then
		local damageType = damageInfo:GetDamageType();
		local damageAmount = damageInfo:GetDamage();
		
		if damageType == 4 then -- SLASH
			if damageAmount > 50 then
				local damageDealt = math.floor(damageAmount/50);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
				end
				
				self:EmitSound(self.creaksounds[math.random(1, #self.creaksounds)]);
			end
		elseif damageType == 128 then -- BLUNT
			if damageAmount > 50 then
				local damageDealt = math.floor(damageAmount/16);
				
				if entity.health then
					entity:SetHP(entity.health - damageDealt);
				else
					entity.health = 500 - damageDealt;
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