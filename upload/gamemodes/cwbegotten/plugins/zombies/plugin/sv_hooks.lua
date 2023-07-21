--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called at an interval while the player is connected to the server.
--[[function cwZombies:PlayerThink(player, curTime, infoTable)
	if (!player.nextSoundCheck or curTime > player.nextSoundCheck) then
		player.nextSoundCheck = curTime + 1;
		
		if (!player.soundTimer) then
			player.soundTimer = 0;
		else
			player:SetSharedVar("NextSound", curTime + (player.soundTimer));
			player.soundTimer = 0;
		end;
	end;
end;]]--

-- Called when an entity is removed.
function cwZombies:EntityRemoved(entity)
	if (table.HasValue(self.zombieNPCS, entity:GetClass())) then
		for k, v in pairs (ents.FindInSphere(entity:GetPos(), 750)) do
			if (IsValid(entity) and IsValid(v) and v:IsPlayer() and v:Alive() and v:HasInitialized()) then
				if (Clockwork.entity:CanSeeNPC(entity, v)) then
					Clockwork.datastream:Start(v, "Stunned", 2);
				end;
			end;
		end;
	end;
end;

-- Called when a players footstep sound needs to be played.
--[[function cwZombies:PlayerFootstep(player, position, foot, sound, volume)
	local curTime = CurTime();
	
	if (!player.nextFootstepSound or curTime > player.nextFootstepSound) then
		player.nextFootstepSound = curTime + 1;
		
		local croching = player:Crouching();
		local running = player:IsRunning();
		
		if (!croching) then
			player.soundTimer = player.soundTimer + 2;
			
			if (running) then
				player.soundTimer = player.soundTimer + 4;
			end;
		end;
	end;
	
	return true;
end;]]--

-- Called whenever the player presses a key.
--[[function cwZombies:KeyPress(player, key)
	if (key == IN_RELOAD) then
		local curTime = CurTime();
		
		if (!player.nextReloadGiveAway or curTime > player.nextReloadGiveAway) then
			local bWeaponRaised = Clockwork.player:GetWeaponRaised(player);
			local activeWeapon = player:GetActiveWeapon();
			local activeClass = activeWeapon:GetClass();
			
			if (bWeaponRaised) then
				if (string.find(activeClass, "damnation_")) then
					local maxClip = activeWeapon:GetMaxClip1();
					local activeClip = activeWeapon:Clip1();
					
					if (maxClip > activeClip) then
						player.soundTimer = player.soundTimer + 5;
					end;
				end;
			end;
			
			player.nextReloadGiveAway = curTime + 5;
		end;
	end;
end;]]--

-- Called when an entity fires bullets.
function cwZombies:EntityFireBullets(entity, dataTable)
	if (entity.cwObserverMode != true) then
		local curTime = CurTime();
		
		if (!entity.nextShootGiveAway or curTime > entity.nextShootGiveAway) then
			entity.nextShootGiveAway = curTime + 0.5;

			cwZombies:GiveAwayPosition(entity, 2500);
		end;
	end;
end;

-- Called when an NPC is killed.
function cwZombies:OnNPCKilled(npc, attacker, inflictor, attackers)
	--if (attacker:IsPlayer()) then
		--if (table.HasValue(self.zombieNPCS, npc:GetClass())) then
			local attackers;
			
			if npc.attackers then
				attackers = {};
			end
		
			for k, v in pairs (ents.FindInSphere(npc:GetPos(), 800)) do
				if (v:IsPlayer() and v:Alive() and Clockwork.entity:CanSeeEntity(npc, v)) then
					if npc:IsZombie() then
						Clockwork.datastream:Start(v, "Stunned", 1);
					end

					if npc.attackers and table.HasValue(npc.attackers, v:EntIndex()) then
						table.insert(attackers, v);
					end
				end;
			end;
		
			if attackers then
				local numAttackers = #attackers;
			
				if npc.XPValue then
					for i = 1, #attackers do
						local iAttacker = attackers[i];
						
						if IsValid(iAttacker) then
							iAttacker:HandleXP(math.Round(npc.XPValue / numAttackers));
						end
					end
				else
					for i = 1, #attackers do
						local iAttacker = attackers[i];
						
						if IsValid(iAttacker) then
							iAttacker:HandleXP(math.Round(25 / numAttackers));
						end
					end
				end
				
				if (table.HasValue(self.zombieNPCS, npc:GetClass())) then
					for i = 1, #attackers do
						local iAttacker = attackers[i];
					
						if IsValid(iAttacker) and iAttacker.demonHunterActive then
							if iAttacker.thrallsToKill then
								iAttacker.thrallsToKill = iAttacker.thrallsToKill - 1;

								if iAttacker.thrallsToKill == 0 then
									iAttacker:HandleXP(1000);
								
									iAttacker.demonHunterActive = nil;
									iAttacker.thrallsToKill = nil;
									
									Clockwork.hint:Send(iAttacker, "The 'Demon Hunter' ritual task has been successfully completed...", 10, Color(100, 175, 100), true, true);
								else
									Schema:EasyText(iAttacker, "goldenrod", "You must slay "..iAttacker.thrallsToKill.." more Begotten thralls for your reward...");
								end
							else
								iAttacker.demonHunterActive = nil;
							end
						end
					end
				end
			end
		--end;
	--end;
end;

-- Called when an entity takes damage.
function cwZombies:EntityTakeDamageAfter(entity, damageInfo)
	-- 1.5x damage bonus for firearms to NPCs.
	if (entity:IsNPC() or entity:IsNextBot()) then
		local attacker = damageInfo:GetAttacker();
		local inflictor = damageInfo:GetInflictor();
	
		if entity:IsZombie() then
			if entity.PainSounds then
				local painSound = table.Random(entity.PainSounds);
				
				if painSound then
					entity:EmitSound(painSound, 100, entity.pitch or 100);
				end
			end
			
			if IsValid(attacker) then
				if attacker:IsPlayer() then
					local activeWeapon = attacker:GetActiveWeapon();
					
					if IsValid(activeWeapon) and activeWeapon.Base == "begotten_firearm_base" then
						damageInfo:ScaleDamage(1.5);
					end
				elseif attacker:IsNPC() or attacker:IsNextBot() then
					entity:SetEnemy(attacker);
					
					if attacker:IsNPC() then
						entity:SetLastEnemy(attacker);
						entity:UpdateEnemyMemory(attacker, attacker:GetPos());
					end
				end
			end
		end
		
		local damagePosition = damageInfo:GetDamagePosition();
		local damageAmount = damageInfo:GetDamage();
		local damageForce = damageInfo:GetDamageForce();
		
		if IsValid(attacker) and attacker:IsPlayer() then
			if !entity.attackers then
				entity.attackers = {};
			end
			
			if !table.HasValue(entity.attackers, attacker:EntIndex()) then
				table.insert(entity.attackers, attacker:EntIndex());
			end
		
			if cwBeliefs then
				local damagePercentage = math.min(damageAmount / entity:GetMaxHealth(), 1);
				
				if entity.XPValue then
					attacker:HandleXP(math.Round(entity.XPValue * damagePercentage));
				else
					attacker:HandleXP(math.Round(25 * damagePercentage));
				end
			end
		end
		
		Clockwork.kernel:CreateBloodEffects(damagePosition, 1, entity, damageForce);
	end
end;