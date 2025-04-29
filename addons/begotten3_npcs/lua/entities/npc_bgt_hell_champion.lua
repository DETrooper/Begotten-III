if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Hell Champion"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/thralls/skelly05.mdl", "models/begotten/thralls/skelly06.mdl"}
ENT.BloodColor = DONT_BLEED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {}
ENT.OnDeathSounds = {}
ENT.PainSounds = {"npc/stalker/stalker_pain1.wav", "npc/stalker/stalker_pain2.wav", "npc/stalker/stalker_pain3.wav"};
-- Stats --
ENT.SpawnHealth = math.random(225, 300)
ENT.SpotDuration = 20
ENT.bulletScale = 1.5
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 100
ENT.ReachEnemyRange = 35
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 85;
-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}
ENT.canSeeCloakers = true
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
ENT.ArmorPiercing = 20;
ENT.Damage = 30;
ENT.StaminaDamage = 15;
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
			self:SetVelocity(self:GetVelocity() + Vector(0,0,700) + self:GetForward() * 100);

			self:EmitSound("npc/stalker/stalker_alert"..math.random(1, 3).."b.wav", 100, self.pitch)

		end
	}},
	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			self:OnMeleeAttack();
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
			self:EmitSound("npc/stalker/stalker_scream"..math.random(1, 4)..".wav", 100, self.pitch, 0.6)
		end;
		--	self:Jump(100)
	end
	
	function ENT:OnLost()
		local curTime = CurTime();
		if (!self.nextLo or self.nextLo < curTime) then
			self.nextLo = curTime + 20
			self:EmitSound("npc/stalker/stalker_die"..math.random(1, 2)..".wav", 100, self.pitch)
		end;
	end
	
	function ENT:OnParried()
		self.nextMeleeAttack = CurTime() + 2;
		self:ResetSequence(ACT_FLINCH_PHYSICS);
		
		--[[if self.Shielded then
			if self:GetNetVar("Guardening") then
				self:SetLocalVar("Guardening", false);
			end
			
			timer.Create("GuardResetTimer_"..self:EntIndex(), 2, 1, function()
				if IsValid(self) then
					self:SetLocalVar("Guardening", true);
				end
			end);
		end]]--
	end
	
	function ENT:IsBlocking()
		if self.Shielded and self:GetActivity() == ACT_RUN then return true end;
	end
	
	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
		
		timer.Simple(FrameTime(), function()
			if !IsValid(self) then return end;
			
			local model = self:GetModel();
			
			if model == "models/begotten/thralls/skelly05.mdl" then
				self.Armor = 65;
				self.ArmorMaterial = "plate"
				self.BlockTable = "shield8";
				self.Shielded = true
				
				self.ArmorPiercing = 40;
				self.Damage = 60;
				self.DamageType = DMG_SLASH
				self.StaminaDamage = 20;
				
				self:GiveWeapon("begotten_1h_satanicsword");
			elseif model == "models/begotten/thralls/skelly06.mdl" then
				self.Armor = 65;
				self.ArmorMaterial = "plate"
				self.BlockTable = "shield8";
				self.Shielded = true
				
				self.ArmorPiercing = 70;
				self.Damage = 30;
				self.DamageType = DMG_CLUB
				self.StaminaDamage = 45;
				
				self:GiveWeapon("begotten_1h_satanicmace");
			end
		end);
	end
	-- AI --
	function ENT:OnMeleeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
			self:EmitSound("npc/stalker/stalker_alert"..math.random(1, 3).."b.wav", 100, self.pitch)
			
			if self:GetModel() == "models/begotten/thralls/skelly05.mdl" then
				self:PlaySequenceAndMove("fastattack", 0.6, self.FaceEnemy)
			elseif self:GetModel() == "models/begotten/thralls/skelly06.mdl" then
				self:PlaySequenceAndMove("fastattack", 0.4, self.FaceEnemy)
			end
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
					
					if cwItemSpawner and self.Shielded and math.random(1, 40) == 1 and !hook.Run("GetShouldntThrallDropCatalyst", ragdoll) then
						local itemInstance = item.CreateInstance("old_soldier_shield");
						
						if itemInstance then
							local entity = Clockwork.entity:CreateItem(nil, itemInstance, ragdoll:GetPos() + Vector(0, 0, 16));
							
							entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
							
							table.insert(cwItemSpawner.ItemsSpawned, entity);
						end
					end
				end;
			end)
			
			return true;
		end
	end
	function ENT:Makeup()
	end;
	ENT.ModelScale = 1.15
	ENT.pitch = math.random(80, 110)
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
		local laughs = {01, 03, 06, 09, 11, 12}
		self:EmitSound("possession/laugh_0"..laughs[math.random(1, #laughs)]..".wav", 80, self.pitch, 0.6)
	end
	
	function ENT:OnChaseEnemy()
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

		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + math.random(7, 15)
			self:EmitSound("npc/stalker/stalker_scream"..math.random(1,3)..".wav", 100, self.pitch, 0.6)
		end;
	end
	function ENT:OnLandedOnGround()
	end;
	function ENT:OnAnimEvent()
		if self:IsAttacking() and self:GetCycle() > 0.3 then
			self:Attack({
				damage = self.Damage,
				type = self.DamageType,
				viewpunch = Angle(20, math.random(-10, 10), 0)
			}, function(self, hit)
				if #hit > 0 then
					if self:GetModel() == "models/begotten/thralls/skelly06.mdl" then
						self:EmitSound("meleesounds/shield-iron2.wav.mp3", 100, self.pitch)
					elseif self:GetModel() == "models/begotten/thralls/skelly05.mdl" then
						self:EmitSound("begotten/npc/brute/attack_claw_hit0"..math.random(1,3)..".mp3", 80, self.pitch)
					end
				else self:EmitSound("Zombie.AttackMiss") end
			end)
		end
	end
end
-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)