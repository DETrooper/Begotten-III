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
				if (Clockwork.entity:CanSeeNPC(entity, v)) and !entity.killed then
					netstream.Start(v, "Stunned", 2);
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

-- A function to get if a player can open a container.
function cwZombies:PlayerCanOpenContainer(player, container)
	if player:HasTrait("marked") and not player:IsNoClipping() and container.lootContainer and !container.looted and string.find(container:GetModel(), "closet") then
		if math.random(1, 20) == 1 then
			local thrall = cwZombies:SpawnThrall(table.Random({"npc_bgt_brute", "npc_bgt_eddie"}), container:GetPos(), Angle(0, -player:GetAngles().y, 0));
			
			if IsValid(thrall) then
				container:SetCollisionGroup(COLLISION_GROUP_WEAPON);

				Clockwork.chatBox:AddInRadius(nil, "itnofake", "A thrall suddenly bursts out of the fucking closet!", container:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				local entitiesInSphere = ents.FindInSphere(container:GetPos(), 512);
				
				for k, v in pairs (entitiesInSphere) do	
					if (IsValid(v) and v:IsPlayer()) then
						if v:HasInitialized() and v:Alive() then
							if Clockwork.player:CanSeeEntity(v, container) then
								netstream.Start(v, "PlaySound", "begotten/score5.mp3");
							end
						end
					end
				end
			
				local physObj = container:GetPhysicsObject();
				
				if (IsValid(physObj)) then
					local material = physObj:GetMaterial();
					
					if (string.find(material, "wood")) then
						container:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 70);
					elseif (string.find(material, "metal")) then
						container:EmitSound("physics/metal/metal_box_break"..math.random(1, 2)..".wav", 70);
					end;
				end;
				
				if cwPossession then
					timer.Simple(2, function()
						if IsValid(container) then
							container:EmitSound(cwPossession.laughs[math.random(1, #cwPossession.laughs)]);
						end
					end);
				end
				
				table.insert(Schema.spawnedNPCs["thrall"], thrall:EntIndex());
			
				return false;
			end
		end
	end
end

-- Called when an NPC is killed.
function cwZombies:OnNPCKilled(npc, attacker, inflictor, attackers)
	-- Some addons call this hook, so to prevent multiple XP payouts I've assigned a variable to track whether or not it's already been killed.
	if npc.killed then
		return;
	end

	--if (attacker:IsPlayer()) then
		--if (table.HasValue(self.zombieNPCS, npc:GetClass())) then
			local attackers;
			
			if npc.attackers then
				attackers = {};
			end
		
			for k, v in pairs (ents.FindInSphere(npc:GetPos(), 800)) do
				if (v:IsPlayer() and v:Alive()) then
					--[[if npc:IsZombie() and Clockwork.entity:CanSeeEntity(npc, v) then
						netstream.Start(v, "Stunned", 1);
					end]]--

					if npc.attackers and table.HasValue(npc.attackers, v:GetCharacterKey()) then
						if !npc.summonedFaith or v:GetFaith() ~= npc.summonedFaith then
							table.insert(attackers, v);
						end
					end
				end;
			end;
		
			if attackers then
				local numAttackers = #attackers;
			
				if npc.XPValue then
					for i = 1, #attackers do
						local iAttacker = attackers[i];
						local class = npc:GetClass();
						
						if IsValid(iAttacker) then
							if cwBeliefs and iAttacker:HasBelief("father") then
								if npc:IsZombie() or string.find(class, "bear") then
									iAttacker:HandleXP(math.Round((npc.XPValue * 2) / numAttackers));
									
									continue;
								end
							end
						
							iAttacker:HandleXP(math.Round(npc.XPValue / numAttackers));
						end
					end
				else
					for i = 1, #attackers do
						local iAttacker = attackers[i];
						
						if IsValid(iAttacker) then
							if cwBeliefs and iAttacker:HasBelief("father") then
								if npc:IsZombie() or string.find(class, "bear") then
									iAttacker:HandleXP(math.Round(50 / numAttackers));
									
									continue;
								end
							end
						
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
	
	-- Mark it as having been killed.
	npc.killed = true;
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
					
					if attacker:GetCharmEquipped("evil_eye") then
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
			
			if !entity.summonedFaith or attacker:GetFaith() ~= entity.summonedFaith then
				if !table.HasValue(entity.attackers, attacker:GetCharacterKey()) then
					table.insert(entity.attackers, attacker:GetCharacterKey());
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
		end
		
		Clockwork.kernel:CreateBloodEffects(damagePosition, 1, entity, damageForce);
	end
end;