if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Coinsucker"
ENT.Category = "Begotten DRG"

ENT.Models = {"models/begotten/thralls/coinsucker.mdl"}

ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true

-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/suitor/attack_launch01.mp3", "begotten/npc/suitor/attack_launch02.mp3"}

ENT.OnDeathSounds = {"begotten/npc/suitor/amb_idle_whimp01.mp3", "begotten/npc/suitor/amb_idle_whimp02.mp3"}

ENT.PainSounds = {"begotten/npc/suitor/attack_launch01.mp3", "begotten/npc/suitor/attack_launch02.mp3"}

-- Stats --
ENT.SpawnHealth = 400
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 90
ENT.ReachEnemyRange = 40
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 100;

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
ENT.ClimbUpAnimation = "run_all_grenade" --ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.ArmorPiercing = 25;
ENT.Damage = 20
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
	[IN_ATTACK] = {
		{
			coroutine = true,
			onkeydown = function(self)
				self:EmitSound("begotten/npc/grunt/attack_launch0" .. math.random(1, 3) .. ".mp3", 100, self.pitch)
				self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
			end
		}
	}
}

if CLIENT then end

if SERVER then
	function ENT:OnSpotted()
		local curTime = CurTime()
		
		if not self.nextNotice or self.nextNotice < curTime then
			self.nextNotice = curTime + 20
			self:EmitSound("begotten/npc/grunt/enabled0" .. math.random(1, 4) .. ".mp3", 100, self.pitch)
		end
		--	self:Jump(100)
	end
	
	function ENT:OnLost()
		local curTime = CurTime()
		
		if not self.nextLo or self.nextLo < curTime then
			self.nextLo = curTime + 20
			self:EmitSound("begotten/npc/grunt/amb_alert0" .. math.random(1, 3) .. ".mp3", 100, self.pitch)
		end
	end
	
	function ENT:OnParried()
		self.nextMeleeAttack = CurTime() + 2;
	end
	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT)
		self:EmitSound("begotten/npc/grunt/enabled0" .. math.random(1, 4) .. ".mp3")
		self.coin = math.random(200, 300);
	end
	
	-- AI --
	function ENT:OnMeleeAttack(enemy)
		self:EmitSound("begotten/npc/grunt/attack_launch0" .. math.random(1, 3) .. ".mp3", 100, self.pitch)
		self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
	end
	
	function ENT:OnReachedPatrol()
		self:Wait(math.random(3, 7))
	end
	
	function ENT:OnIdle()
		self:AddPatrolPos(self:RandomPos(1500))
		local curTime = CurTime()
		
		if not self.nextId or self.nextId < curTime then
			self.nextId = curTime + 10
			self:EmitSound("begotten/npc/grunt/amb_idle0" .. math.random(1, 5) .. ".mp3", 100, self.pitch)
		end
	end
	
	-- Damage --
	function ENT:OnDeath(dmg, delay, hitgroup)
		if self.coin and self.coin > 0 then
			local coin = self.coin;
			local pos = self:GetPos();
			
			timer.Simple(1.6, function() 
				local prop = ents.Create("prop_physics");
				
				prop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
				prop:SetModel("models/props_c17/cashregister01a.mdl");
				prop:SetPos(pos + Vector(0, 0, 24));
				prop:Spawn();
				
				prop.cwInventory = {};
				prop.cwCash = coin;
				
				Clockwork.entity:Decay(prop, 300);
			end);
		end
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
				end;
			end)
			
			return true;
		end
	end
	
	function ENT:Makeup()
	end
	
	ENT.ModelScale = 1
	ENT.pitch = 70
	
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
		self:EmitSound("begotten/npc/grunt/notice0" .. math.random(1, 4) .. ".mp3", 100, self.pitch)
	end
	
	function ENT:OnChaseEnemy()
		local curTime = CurTime()
		
		if not self.nextId or self.nextId < curTime then
			self.nextId = curTime + math.random(7, 15)
			self:EmitSound("begotten/npc/grunt/amb_hunt0" .. math.random(1, 4) .. ".mp3", 100, self.pitch)
		end
	end
	
	function ENT:OnLandedOnGround()
	end
	
	function ENT:OnAnimEvent()
		local sha = false
		
		if self:IsAttacking() and self:GetCycle() > 0.3 then
			self:Attack({
				damage = self.Damage,
				type = DMG_SLASH,
				viewpunch = Angle(20, math.random(-10, 10), 0)
			}, function(self, hit)
				if #hit > 0 then
					for k, v in pairs(hit) do
						if v:IsValid() and v:IsPlayer() then
							local cash = v:GetCash()
							
							if cash > 0 then
								local coin = math.Round(math.max(1, cash / 5));
								
								Clockwork.player:GiveCash(v, -coin, "Coinsucked!")
								
								self.coin = self.coin + coin;
							end
						end
					end
					
					self:EmitSound("begotten/npc/suitor/attack_claw_hit0" .. math.random(1, 3) .. ".mp3", 100, self.pitch)
					self:EmitSound("ambient/levels/labs/coinslot1.wav", 100, 80)
				else
					self:EmitSound("Zombie.AttackMiss")
				end
			end)
		elseif self:IsOnGround() == true then
			self:EmitSound("fiend/fiendjingle.wav", 4000, math.random(95, 105))
		end
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)