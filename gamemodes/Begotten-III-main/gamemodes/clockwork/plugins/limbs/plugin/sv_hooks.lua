--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when a player has spawned.
--[[function cwLimbs:PostPlayerDeath(player)
	if (player:HasInitialized() and not player.opponent) then
		Clockwork.limb:ResetDamage(player);
	end
end]]--

-- Called when a player's character has been loaded.
function cwLimbs:PlayerCharacterLoaded(player)
	netstream.Start(player, "ReceiveLimbDamage", player:GetCharacterData("LimbData", {}))
end

-- Called when a player's character data should be saved.
function cwLimbs:PlayerSaveCharacterData(player, data) end;

-- Called when a player's character data should be restored.
function cwLimbs:PlayerRestoreCharacterData(player, data)
	if (!data["LimbData"]) then
		data["LimbData"] = {}
	end
end

-- Called at an interval while the player is connected to the server.
--[[function cwLimbs:PlayerThink(player, curTime, infoTable)
	if !player.limbSpeedCheck or player.limbSpeedCheck < curTime then
		local leftLeg = Clockwork.limb:GetDamage(player, HITGROUP_LEFTLEG, true)
		local rightLeg = Clockwork.limb:GetDamage(player, HITGROUP_RIGHTLEG, true)
		local legDamage = math.max(leftLeg, rightLeg)

		if (legDamage > 0) then
			player:SetJumpPower(infoTable.jumpPower / (1 + legDamage), true)
			player:SetRunSpeed(infoTable.runSpeed / (1 + legDamage), true)
			player:SetWalkSpeed(infoTable.walkSpeed / (1 + legDamage), true)
		else
			player:SetJumpPower(infoTable.jumpPower, true)
			player:SetRunSpeed(infoTable.runSpeed, true)
			player:SetWalkSpeed(infoTable.walkSpeed, true)
		end
		
		player.limbSpeedCheck = curTime + 1;
	end
end]]--

-- Called when a player's health is set.
function cwLimbs:PlayerHealthSet(player, newHealth, oldHealth)
	--[[local maxHealth = player:GetMaxHealth()
	
	if (newHealth > oldHealth) then
		Clockwork.limb:HealBody(player, (newHealth - oldHealth) / 2)
	end

	if (newHealth >= maxHealth) then
		Clockwork.limb:HealBody(player, 100)
	end]]--
end

-- A function to calculate player damage.
function cwLimbs:CalculatePlayerDamage(player, hitGroup, damageInfo)
	if Clockwork.player:HasFlags(player, "I") then return end;

	if --[[not player.opponent and ]](damageInfo) then
		--local bulletDamage, clubDamage, slashDamage = damageInfo:IsBulletDamage(), damageInfo:IsDamageType(DMG_CLUB), damageInfo:IsDamageType(DMG_SLASH)
		--local bDamageIsValid = bulletDamage or clubDamage or slashDamage
		--local bHitGroupIsValid = true
		--local armorChestOnly = config.GetVal("armor_chest_only")
		--local armor = player:Armor()
		local attacker = damageInfo:GetAttacker();
		local damage = damageInfo:GetDamage()
		local bFallDamage = damageInfo:IsFallDamage()
		
		--[[if (armorChestOnly) then
			if (hitGroup != HITGROUP_CHEST and hitGroup != HITGROUP_GENERIC) then
				bHitGroupIsValid = nil
			end
		end]]--
		
		if IsValid(attacker) and attacker:IsPlayer() then
			if attacker:HasBelief("headtaker") then
				damage = damage * 1.25;
			end
		end
		
		local newDamage = damage;
		
		if player:HasBelief("iron_bones") then
			newDamage = newDamage - (damage * 0.3334);
		end
		
		if player.GetCharmEquipped and player:GetCharmEquipped("effigy_human") then
			newDamage = newDamage - (damage * 0.5);
		end
		
		newDamage = math.max(newDamage, 0);
		
		if (bFallDamage) then
			Clockwork.limb:TakeDamage(player, HITGROUP_RIGHTLEG, newDamage)
			Clockwork.limb:TakeDamage(player, HITGROUP_LEFTLEG, newDamage)
			
			hook.Run("PlayerLimbFallDamageTaken", player, newDamage)
			return;
		end

		--[[if (armor > 0 and bDamageIsValid and bHitGroupIsValid) then
			local armor = armor - newDamage
			
			if (armor < 0) then
				Clockwork.limb:TakeDamage(player, hitGroup, newDamage)
			end
		else]]
			Clockwork.limb:TakeDamage(player, hitGroup, newDamage)
		--end
		
		--[[if (bDamageIsValid and bHitGroupIsValid) then
			Clockwork.limb:TakeDamage(player, hitGroup, newDamage);
		end]]--
	end;
end

-- Called when a player's limb damage is bIsHealed.
function cwLimbs:PlayerLimbDamageHealed(player, hitGroup, amount)
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
end

-- Called when a player's limb takes damage.
function cwLimbs:PlayerLimbTakeDamage(player, hitGroup, damage)
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
end

-- Called when a player's limb damage is reset.
function cwLimbs:PlayerLimbDamageReset(player)
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
end

function cwLimbs:ModifyPlayerSpeed(player, infoTable)
	local leftLeg = Clockwork.limb:GetHealth(player, HITGROUP_LEFTLEG, false)
	local rightLeg = Clockwork.limb:GetHealth(player, HITGROUP_RIGHTLEG, false)
	local legDamage = math.min(leftLeg, rightLeg)

	if (legDamage <= 90) then
		if cwPossession and player.possessor then
			return;
		end
	
		if legDamage > 75 then
			return;
		elseif legDamage <= 75 and legDamage > 50 then
			infoTable.jumpPower = math.max(1, infoTable.jumpPower * 0.85);
			infoTable.runSpeed = math.max(1, infoTable.runSpeed * 0.85);
		elseif legDamage <= 50 and legDamage > 25 then
			infoTable.jumpPower = math.max(1, infoTable.jumpPower * 0.5);
			infoTable.runSpeed = math.max(1, infoTable.runSpeed * 0.5);
		elseif legDamage <= 25 and legDamage > 10 then
			infoTable.jumpPower = 0;
			infoTable.walkSpeed = math.max(1, infoTable.walkSpeed * 0.6);
			infoTable.runSpeed = math.max(1, infoTable.walkSpeed);
		else
			infoTable.jumpPower = 0;
			infoTable.crouchedWalkSpeed = math.max(1, infoTable.crouchedWalkSpeed * 0.5);
			infoTable.walkSpeed = math.max(1, infoTable.walkSpeed * 0.1);
			infoTable.runSpeed = math.max(1, infoTable.walkSpeed);
		end
	end
end