if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Chaser"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/Zombie/Fast.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/brute/attack_claw01.mp3", "begotten/npc/brute/attack_claw02.mp3", "begotten/npc/brute/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/brute/amb_idle_scratch01.mp3", "begotten/npc/brute/amb_idle_scratch02.mp3", "begotten/npc/brute/amb_idle_scratch03.mp3", "begotten/npc/brute/amb_idle_scratch04.mp3"}
ENT.PainSounds = {"begotten/npc/brute/attack_launch01.mp3", "begotten/npc/brute/attack_launch02.mp3", "begotten/npc/brute/attack_launch03.mp3"};
-- Stats --
ENT.SpawnHealth = 200
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 1
ENT.SightFOV = 360
ENT.SightRange = 1500
ENT.XPValue = 125;
-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}
-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_RUN
ENT.JumpAnimation = "climbmount"
ENT.RunAnimRate = 0
-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 300
ENT.ClimbLadders = true
ENT.ClimbSpeed = 100
ENT.ClimbUpAnimation = "climbloop"--ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.ArmorPiercing = 25;
ENT.Damage = 20;
ENT.MaxMultiHit = 1;
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
			self:SetVelocity(self:GetVelocity() + Vector(0,0,700) + self:GetForward() * 500);

			self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)

		end

	}},

	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			if(self.nextMeleeAttack and self.nextMeleeAttack > CurTime()) then return; end
						self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
		end
	}}
}
if (CLIENT) then
	function ENT:Think()
		local t = DynamicLight(self:EntIndex())
		if (t) then
			t.pos = self:GetBonePosition(16);
			t.r = 255
			t.g = 0
			t.b = 0
			t.brightness = 2
			t.Decay = 1000
			t.size = 64
			t.DieTime = CurTime() + 0.1
		end;
		
		local tf = DynamicLight(self:EntIndex().."2")
		if (tf) then
			tf.pos = self:GetBonePosition(1);
			tf.r = 255
			tf.g = 127
			tf.b = 0
			tf.brightness = 2
			tf.Decay = 1000
			tf.size = 64
			tf.DieTime = CurTime() + 0.1
		end;
		
	end;
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

		local rand = math.random(1,3);
		local direction = (rand == 1 and self:GetRight() or rand == 2 and (self:GetRight() * -1) or (self:GetForward() * -1));
		local distance = math.random(200,250);

		timer.Simple(0.1, function()
			if IsValid(self) then
				self:ResetSequence(ACT_WALK);
				self:Jump(40);
				self:SetVelocity(self:GetVelocity() + direction * distance);
				self:EmitSound(self.OnDamageSounds[math.random(#self.OnDamageSounds)], 100, self.pitch + math.random(5,15));
				self:EmitSound("Zombie.AttackMiss");
			end
		end);

	end
	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
		self:SetMaterial("models/barnacle/barnacle_sheet");
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
	ENT.pitch = 140
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
	
	function ENT:OnChaseEnemy(enemy)
		local curTime = CurTime();

		if(!self.nextGateCheck or self.nextGateCheck < curTime) then
			self.nextGateCheck = curTime + 5;

			local data = {}
			data.start = self:GetPos() + Vector(0,0,45);
			data.endpos = data.start + self:GetForward() * 50;
			data.filter = self;

			local facing = util.TraceLine(data).Entity;
			
			if(IsValid(facing) and facing.GetName and facing:GetName() == "gate_door") then
				self:MoveBackward(150);
				self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, self.pitch);
				self:EmitSound("Zombie.AttackMiss");
				self:Jump(400, function() self:SetVelocity(self:GetVelocity() + self:GetForward() * 50); end);

			end

		end

		if(self:GetPos():DistToSqr(enemy:GetPos()) > 122500 and self:IsOnGround()) then
			if(!self.nextJump or self.nextJump < curTime) then
				self.nextJump = curTime + math.random(2,4);
			
				local ang = (self:GetPos() - enemy:GetPos()):Angle()
				self:SetAngles(Angle(0, ang.y + 180, 0))

				self:LeaveGround();
				self:SetVelocity(self:GetVelocity() + Vector(0,0,700) + self:GetForward() * 500);

				self:EmitSound("begotten/npc/brute/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)

			end

		end

		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + math.random(7, 15)
			self:EmitSound("begotten/npc/brute/amb_hunt0"..math.random(1,3)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnLandedOnGround()
	end;
	function ENT:OnAnimEvent()
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