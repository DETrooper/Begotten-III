if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Giant"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/thralls/brute.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/brute/attack_claw01.mp3", "begotten/npc/brute/attack_claw02.mp3", "begotten/npc/brute/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/brute/amb_idle_scratch01.mp3", "begotten/npc/brute/amb_idle_scratch02.mp3", "begotten/npc/brute/amb_idle_scratch03.mp3", "begotten/npc/brute/amb_idle_scratch04.mp3"}
ENT.PainSounds = {"begotten/npc/brute/attack_launch01.mp3", "begotten/npc/brute/attack_launch02.mp3", "begotten/npc/brute/attack_launch03.mp3"};
-- Stats --
ENT.SpawnHealth = 2500
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 300
ENT.ReachEnemyRange = 200
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 500;
-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}
-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_WALK
ENT.JumpAnimation = "releasecrab"
ENT.RunAnimRate = 0
-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 10000
ENT.ClimbLadders = true
ENT.ClimbSpeed = 100
ENT.ClimbUpAnimation = "run_all_grenade"--ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.ArmorPiercing = 80;
ENT.Damage = 150;
-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)
-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
		offset = Vector(0, 30, 20),
		distance = 100
	},
	{
		offset = Vector(7.5, 0, 0),
		distance = 0,
		eyepos = true
	}
}
ENT.PossessionBinds = {
	[IN_JUMP] = {{
		coroutine = true,
		onkeydown = function(self)
			if(!self:IsOnGround()) then return; end

			self:LeaveGround();
			self:SetVelocity(self:GetVelocity() + Vector(0,0,1200) + self:GetForward() * 100);

			self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)

		end

	}},

	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			if(self.nextMeleeAttack and self.nextMeleeAttack > CurTime()) then return; end
						self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
		end
	}}
}
if (CLIENT) then
	
end;
if SERVER then
	function ENT:OnSpotted()
		local curTime = CurTime();
		if (!self.nextNotice or self.nextNotice < curTime) then
			self.nextNotice = curTime + 20
			self:EmitSound("begotten/npc/brute/enabled0"..math.random(1, 4)..".mp3", 100, self.pitch)
		end;
		--	self:Jump(100)
	end
	function ENT:OnLost()
		local curTime = CurTime();
		if (!self.nextLo or self.nextLo < curTime) then
			self.nextLo = curTime + 20
			self:EmitSound("begotten/npc/brute/amb_alert0"..math.random(1, 3)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnParried()
		self.nextMeleeAttack = CurTime() + 2;
	end
	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
	end
	-- AI --
	function ENT:OnMeleeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
			self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
		end
	end
	function ENT:OnReachedPatrol()
		self:Wait(math.random(3, 7))
	end
	function ENT:ShouldIgnore(ent)
		if ent:IsPlayer() and (ent.possessor or ent.victim) then
			return true;
		end
	end
	function ENT:WhilePatrolling()
		self:OnIdle()
	end
	
	function ENT:OnIdle()
		local curTime = CurTime();
		
		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + 10
			self:EmitSound("begotten/npc/brute/amb_idle0"..math.random(1, 4)..".mp3", 100, self.pitch)
			self:AddPatrolPos(self:RandomPos(1500))
		end;
	end
	-- Damage --
	function ENT:OnDeath(dmg, delay, hitgroup)
	end
	function ENT:OnRagdoll(dmg)
		local ragdoll = self;
		
		if IsValid(ragdoll) then
			ParticleEffectAttach("doom_dissolve", PATTACH_POINT_FOLLOW, ragdoll, 0);
			
			timer.Simple(1.6, function() 
				if IsValid(ragdoll) then
					ParticleEffectAttach("doom_dissolve_flameburst", PATTACH_POINT_FOLLOW, ragdoll, 0);
					ragdoll:Fire("fadeandremove", 1);
					ragdoll:EmitSound("begotten/npc/burn.wav");
					
					if cwRituals and cwItemSpawner and !hook.Run("GetShouldntThrallDropCatalyst", ragdoll) then
						for i = 1, 10 do
							local randomItem;
							local spawnable = cwItemSpawner:GetSpawnableItems(true);
							local lootPool = {};
							
							for _, itemTable in ipairs(spawnable) do
								if itemTable.category == "Catalysts" then
									if itemTable.itemSpawnerInfo then
										table.insert(lootPool, itemTable);
									end
								end
							end
							
							randomItem = lootPool[math.random(1, #lootPool)];
							
							if randomItem then
								local itemInstance = item.CreateInstance(randomItem.uniqueID);
								
								if itemInstance then
									local entity = Clockwork.entity:CreateItem(nil, itemInstance, ragdoll:GetPos() + Vector(0, 0, 64) + (VectorRand() * 32));
									
									entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
									
									table.insert(cwItemSpawner.ItemsSpawned, entity);
								end
							end
						end
					end
				end;
			end)
			
			return true;
		end
	end
	function ENT:Makeup()
	end;
	ENT.ModelScale = 4.5
	ENT.pitch = 80
	function ENT:CustomThink()
		if (!self.lastStuck and self:IsStuck()) then
			self.lastStuck = CurTime() + 9;
		end;
		
		if (self.lastStuck and self.lastStuck < CurTime()) then
			if (self:IsStuck()) then
				self:Jump(500)
				--self:MoveForward(5000, function() return true end)
			end;
			
			self.lastStuck = nil
		end;
	end
	
	-- Animations/Sounds --
	function ENT:OnNewEnemy()
		self:EmitSound("begotten/npc/brute/notice0"..math.random(1,2)..".mp3", 100, self.pitch)
	end
	
	function ENT:OnChaseEnemy()
		local curTime = CurTime();
		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + math.random(7, 15)
			self:EmitSound("begotten/npc/brute/amb_hunt0"..math.random(1,3)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnLandedOnGround()
		--
		ParticleEffect("dust_bridge_crack", self:GetPos(), Angle(0, 0, 0), self)
		self:EmitSound("physics/concrete/concrete_break"..math.random(2, 3)..".wav", 100)
		self:PlayAnimationAndMove("pullgrenade")
		local  shakeeffect = ents.Create("env_shake") -- Shake from the explosion
		shakeeffect:SetKeyValue("amplitude", 30)
		shakeeffect:SetKeyValue("spawnflags",4 + 8 + 16)
		shakeeffect:SetKeyValue("frequency", 150)
		shakeeffect:SetKeyValue("duration", 4)
		shakeeffect:SetKeyValue("radius", 800)
		shakeeffect:Spawn()
		shakeeffect:SetPos(self:GetPos())
		shakeeffect:Fire("StartShake","",0)
		shakeeffect:Fire("Kill","",4)
		
		for k, v in pairs (ents.FindInSphere(self:GetPos(), 320)) do
			if (v:IsPlayer() and v:Alive()) then
				v:TakeDamage(20)
			end;
		end;
	end;
	function ENT:OnAnimEvent()
		local sha = false
		if self:IsAttacking() and self:GetCycle() > 0.3 then
			self:Attack({
				damage = self.Damage,
				type = DMG_SLASH,
				viewpunch = Angle(20, math.random(-10, 10), 0)
			}, function(self, hit)
				if #hit > 0 then
					self:EmitSound("begotten/npc/brute/attack_claw_hit0"..math.random(1,3)..".mp3", 100, self.pitch)
				else self:EmitSound("Zombie.AttackMiss") end
			end)
		elseif math.random(2) == 1 then
			self:EmitSound("npc/antlion_guard/foot_heavy1.wav", 500, 70) sha = true
			self:EmitSound("begotten/ambient/hits/wall_stomp"..math.random(1, 5)..".mp3")
			if (!self:IsStuck()) then
				ParticleEffect("dust_bridgefall", self:LocalToWorld(Vector(45, 60, 0)), Angle(0, 0, 0), self)
			end;
		else
			self:EmitSound("npc/antlion_guard/foot_heavy2.wav", 500, 70) sha = true
			self:EmitSound("begotten/ambient/hits/wall_stomp"..math.random(1, 5)..".mp3")
			if (!self:IsStuck()) then
				ParticleEffect("dust_bridgefall", self:LocalToWorld(Vector(50, -60, 0)), Angle(0, 0, 0), self)
			end;
		end
		if (sha) then
			local  shakeeffect = ents.Create("env_shake") -- Shake from the explosion
			shakeeffect:SetKeyValue("amplitude", 16)
			shakeeffect:SetKeyValue("spawnflags",4 + 8 + 16)
			shakeeffect:SetKeyValue("frequency", 20)
			shakeeffect:SetKeyValue("duration", 1)
			shakeeffect:SetKeyValue("radius", 800)
			shakeeffect:Spawn()
			shakeeffect:SetPos(self:GetPos())
			shakeeffect:Fire("StartShake","",0)
			shakeeffect:Fire("Kill","",4)
			--   ParticleEffect("dust_bridgefall", self:GetPos() + self:LocalToWorld(Vector(0, 0, 0)), Angle(0, 0, 0), self)
			-- ParticleEffect("dust_bridgefall", self:LocalToWorld(Vector(45, 65, 0)), Angle(0, 0, 0), self)
			
		end;
	end
end
--[[
local ff = .0
local am = 
if args[1] then
	am = tonumber(am)
	
end
local ssa =  
if args[4] then
	ff = tonumber(args[4])
end
if args[5] then
	ssa = tonumber(args[5])
end
local dd = 4
if args[3] then
	dd = tonumber(args[3])
end
if args[2] then
	ff = tonumber(args[2])
end
--]]
-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)