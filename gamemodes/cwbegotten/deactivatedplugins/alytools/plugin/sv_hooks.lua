--[[
	Script written by Aly for Begotten III: Jesus Wept
	Unauthorized tampering will result in immediate corpsing
--]]

-- vvv Ensure loyalty scores are updated when necessary. vvv

-- Called when attempts to use a command.
function cwAlyTools:PlayerCharacterLoaded(player)
	player:CalcLoyaltyScore();
	if player:GetCharacterData("isDemon", false) then
		cwAlyTools:SetStatMultiplier(player)
	end
end;

-- Called just after a player spawns.
function cwAlyTools:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (player:IsAdmin() or player:IsUserGroup("operator")) then
		netstream.Start(player, "AlyToolsTeleporters", {self.SpawnLocations});
	end;
end;

-- Called when a player dies.
function cwAlyTools:PlayerDeath(player, inflictor, attacker, damageInfo)
	player:CalcLoyaltyScore();
end;

-- Called when a player disconnects
function cwAlyTools:PlayerDisconnected(player)
	player:CalcLoyaltyScore();
end;

-- Done with loyalty score updating.

-- Called when Clockwork has loaded all of the entities.
function cwAlyTools:ClockworkInitPostEntity()
	self:LoadTeleporters()
	self:LoadPowerCores()
end

function cwAlyTools:GetMaxStamina(player, max_stamina)
	local new_stamina = max_stamina;
	local boost = player:GetNetVar("loyaltypoints", 0)
	if boost > 0 then
		new_stamina = new_stamina + boost;
	end
	
	max_stamina = new_stamina;
end

