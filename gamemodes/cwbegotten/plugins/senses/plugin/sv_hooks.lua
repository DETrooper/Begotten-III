--[[
	Begotten III: Jesus Wept
--]]

-- Called when a player's weapons should be given.
function cwSenses:PlayerGiveWeapons(player)
	if !player:HasWeapon("cw_senses") then
		Clockwork.player:GiveSpawnWeapon(player, "cw_senses");
	end
end;

-- Called when a player switches weapons.
function cwSenses:PlayerSwitchWeapon(player, oldWeapon, newWeapon)
	--[[if player.spawning then
		return;
	end
	
	if !(cwBeliefs and (player:HasBelief("creature_of_the_dark") or player:HasBelief("the_black_sea"))) and !player:GetNetVar("hasThermal") and !player:GetNetVar("hasNV") then
		if IsValid(newWeapon) and (newWeapon:GetClass() == "cw_senses") then
			local clothesItem = player:GetClothesEquipped();
			
			if !clothesItem or (clothesItem and !clothesItem.attributes) or (clothesItem and clothesItem.attributes and !table.HasValue(clothesItem.attributes, "thermal_vision")) then
				player:SensesOn()
			end
		elseif (player.sensesOn) then
			player:SensesOff()
		end;
	end]]--
	
	-- This breaks senses for primevalists, also seems to be completely redundant to me unless I'm missing something? - DETrooper
	--[[if (IsValid(oldWeapon) and IsValid(newWeapon) and oldWeapon:GetClass() == "cw_senses" and newWeapon:GetClass() != "cw_senses") then
		player:SensesOff()
	end;]]--
end;

-- Called when a player dies.
function cwSenses:PlayerDeath(player, inflictor, attacker)
	player:SensesOff()
end;

-- Called just after a player spawns.
function cwSenses:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if player:GetNetVar("senses") then
		player:SetLocalVar("senses", false);
		player:SetDSP(0);
	end
	
	if player:GetNetVar("hasThermal") then
		player:SetLocalVar("hasThermal", false);
	end
	
	if player:GetNetVar("hasNV") then
		player:SetLocalVar("hasNV", false);
	end
	
	player.sensesOn = nil;
end;