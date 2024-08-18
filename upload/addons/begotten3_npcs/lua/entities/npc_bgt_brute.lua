if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Brute"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/thralls/brute.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/brute/attack_claw01.mp3", "begotten/npc/brute/attack_claw02.mp3", "begotten/npc/brute/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/brute/amb_idle_scratch01.mp3", "begotten/npc/brute/amb_idle_scratch02.mp3", "begotten/npc/brute/amb_idle_scratch03.mp3", "begotten/npc/brute/amb_idle_scratch04.mp3"}
ENT.PainSounds = {"begotten/npc/brute/attack_launch01.mp3", "begotten/npc/brute/attack_launch02.mp3", "begotten/npc/brute/attack_launch03.mp3"};
-- Stats --
ENT.SpawnHealth = 300
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 120
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 50;
-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}
-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_RUN
ENT.JumpAnimation = "releasecrab"
ENT.RunAnimRate = 0
-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 300
ENT.ClimbLadders = true
ENT.ClimbSpeed = 100
ENT.ClimbUpAnimation = "run_all_grenade"--ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.ArmorPiercing = 50;
ENT.Damage = 45;
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
	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
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
		self:ResetSequence(ACT_IDLE);
	end
	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
		
		self:EmitSound("begotten/npc/brute/enabled0"..math.random(1, 4)..".mp3", 100)
	end
	-- AI --
	function ENT:OnMeleeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
			self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1.25, self.FaceEnemy)
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
						local randomItem;
						local spawnable = cwItemSpawner:GetSpawnableItems(true);
						local lootPool = {};
						
						for _, itemTable in ipairs(spawnable) do
							if itemTable.category == "Catalysts" then
								if itemTable.itemSpawnerInfo and !itemTable.itemSpawnerInfo.supercrateOnly then
									table.insert(lootPool, itemTable);
								end
							end
						end
						
						randomItem = lootPool[math.random(1, #lootPool)];
						
						if randomItem then
							local itemInstance = item.CreateInstance(randomItem.uniqueID);
							
							if itemInstance then
								local entity = Clockwork.entity:CreateItem(nil, itemInstance, ragdoll:GetPos() + Vector(0, 0, 16));
								
								entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
								
								table.insert(cwItemSpawner.ItemsSpawned, entity);
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
	ENT.ModelScale = 1
	ENT.pitch = 100
	function ENT:CustomThink()
		if (!self.lastStuck and self:IsStuck()) then
			self.lastStuck = CurTime() + 2;
		end;
		
		if (self.lastStuck and self.lastStuck < CurTime()) then
			if (self:IsStuck()) then
				--self:Jump(500)
				self:MoveForward(5000, function() return true end)
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
			--[[elseif math.random(2) == 1 then
			self:EmitSound("npc/zombie_poison/pz_right_foot1.wav")
		else
			self:EmitSound("npc/zombie_poison/pz_left_foot1.wav")]]--
		end
	end
end
-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)