if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Grunt"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/zombie/zombie_soldier.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false;

-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/grunt/attack_claw01.mp3", "begotten/npc/grunt/attack_claw02.mp3", "begotten/npc/grunt/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/grunt/amb_idle_scratch01.mp3", "begotten/npc/grunt/amb_idle_scratch02.mp3", "begotten/npc/grunt/amb_idle_scratch03.mp3"}
ENT.PainSounds = {"begotten/npc/grunt/attack_launch01.mp3", "begotten/npc/grunt/attack_launch02.mp3"};

-- Stats --
ENT.SpawnHealth = 500
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 80
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 60;

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
ENT.Damage = 40;

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
      self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
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
		self:EmitSound("begotten/npc/grunt/enabled0"..math.random(1, 4)..".mp3", 100, self.pitch)
	end;
--	self:Jump(100)
end
function ENT:OnLost()
	local curTime = CurTime();
	if (!self.nextLo or self.nextLo < curTime) then
		self.nextLo = curTime + 20
		self:EmitSound("begotten/npc/grunt/amb_alert0"..math.random(1, 3)..".mp3", 100, self.pitch)
	end;
end


  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
	self:SetModel("models/zombie/zombie_soldier.mdl")
	
	cwParts:HandleClothing(self, "models/undead/poison.mdl", 1, 0, true);
	cwParts:HandleClothing(self, "models/skeleton/skeleton_torso.mdl", 8, 2, true);
	cwParts:HandleClothing(self, "models/Zombie/Fast.mdl", 3, 0, true);
	cwParts:HandleClothing(self, "models/Zombie/Poison.mdl", 4, 0, true);
	
	cwGear:HandleGear(self, "models/props_c17/TrapPropeller_Engine.mdl", "chest", Vector(4, -4, 0), Angle(0, 90, 90), 0.8);
	cwGear:HandleGear(self, "models/props_junk/sawblade001a.mdl", "right hand", Vector(0, 0, -2), Angle(0, 90, 0), 0.6);
	
	self:SetMaterial("effects/water_warp01");
	self:EmitSound("begotten/npc/grunt/enabled0"..math.random(1, 4)..".mp3");

	hook.Add("EntityRemoved", self, function()
		if (self.cwChainsawSound) then
			self.cwChainsawSound:Stop();
			self.cwChainsawSound = nil;
		end;
	end);
  end

  -- AI --

  function ENT:OnMeleeAttack(enemy)
    self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
    self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
	local curTime = CurTime();
	if (!self.nextId or self.nextId < curTime) then
		self.nextId = curTime + 10
		self:EmitSound("begotten/npc/grunt/amb_idle0"..math.random(1, 5)..".mp3", 100, self.pitch)
	end;
  end

  -- Damage --

  function ENT:OnDeath(dmg, delay, hitgroup)
  end
  function ENT:Makeup()

  end;
  ENT.ModelScale = 1
  ENT.pitch = 100
  
  function ENT:CustomThink()
	local entity = self;
	
	if (!entity.cwChainsawSound) then
		entity.cwChainsawSound = CreateSound(entity, "vehicles/v8/v8_start_loop1.wav");
		entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
	end;
	
	if (!entity.sawasd) then
		entity.sawasd = 0;
	end;
	
	if (!entity.trta) then
		entity.trta = false;
	end;
	
	if (!entity.trta) then
		if (self:HasEnemy()) then
			entity.sawasd = 1
			entity.trta = true
		else
			entity.sawasd = 0
			entity.trta = true;
		end;
		
		if (entity.cwChainsawSound) then
			entity.cwChainsawSound:Stop();
			entity.cwChainsawSound = nil;
		end;
	end;
	
	if (entity.sawasd == 1) then
		entity.trta = true;
		if (!entity.cwChainsawSound) then
			entity.cwChainsawSound = CreateSound(entity, "vehicles/junker/jnk_turbo_on_loop1.wav");
			entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
		end;
	else
		if (!entity.cwChainsawSound) then
			entity.cwChainsawSound = CreateSound(entity, "vehicles/v8/v8_start_loop1.wav");
			entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
		end;
		entity.trta = true
	end;
  
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

   function ENT:OnRagdoll(ragdoll,dmg)
	self:SetModel("models/zombie/zombie_soldier.mdl")
	
	cwParts:HandleClothing(self, "models/undead/poison.mdl", 1, 0, true);
	cwParts:HandleClothing(self, "models/skeleton/skeleton_torso.mdl", 8, 2, true);
	cwParts:HandleClothing(self, "models/Zombie/Fast.mdl", 3, 0, true);
	cwParts:HandleClothing(self, "models/Zombie/Poison.mdl", 4, 0, true);
	
	cwGear:HandleGear(self, "models/props_c17/TrapPropeller_Engine.mdl", "chest", Vector(4, -4, 0), Angle(0, 90, 90), 0.8);
	cwGear:HandleGear(self, "models/props_junk/sawblade001a.mdl", "right hand", Vector(0, 0, -2), Angle(0, 90, 0), 0.6);
	
	self:SetMaterial("effects/water_warp01");
   end;

  -- Animations/Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound("begotten/npc/grunt/notice0"..math.random(1,4)..".mp3", 100, self.pitch)
  end
  
  function ENT:OnChaseEnemy()
	local curTime = CurTime();
	if (!self.nextId or self.nextId < curTime) then
		self.nextId = curTime + math.random(7, 15)
		self:EmitSound("begotten/npc/grunt/amb_hunt0"..math.random(1,4)..".mp3", 100, self.pitch)
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
          self:EmitSound("begotten/npc/grunt/attack_claw_hit0"..math.random(1,3)..".mp3", 100, self.pitch)
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
