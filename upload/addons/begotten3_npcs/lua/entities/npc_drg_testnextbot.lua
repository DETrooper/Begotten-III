if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Test Sex Nextbot"
ENT.Category = "DrGBase"
ENT.Models = {"models/zombie/zombie_soldier.mdl"}

-- AI --
ENT.BehaviourType = AI_BEHAV_BASE
ENT.RangeAttackRange = 100
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 100
ENT.AvoidEnemyRange = 25

-- Relationships --
ENT.DefaultRelationship = D_HT
ENT.Factions = {FACTION_GMAN}

-- Animations --
ENT.WalkAnimation = ACT_HL2MP_WALK
ENT.RunAnimation = ACT_HL2MP_RUN_FAST
ENT.IdleAnimation = ACT_HL2MP_IDLE
ENT.JumpAnimation = ACT_HL2MP_JUMP_KNIFE

-- Movements --
ENT.WalkSpeed = -1
ENT.RunSpeed = 300

-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 300
ENT.ClimbLadders = true
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_ZOMBIE_CLIMB_UP
ENT.ClimbOffset = Vector(-14, 0, 0)

-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Head1"
ENT.EyeOffset = Vector(5, 0, 2.5)

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
    coroutine = false,
    onkeydown = function(self)
      self:Jump(100)
    end
  }},
  [IN_ATTACK] = {{
    coroutine = false,
    onkeydown = function(self)
      self:PlaySequence("gesture_wave")
    end
  }},
  [IN_ATTACK2] = {{
    coroutine = false,
    onkeydown = function(self)
      self:EmitSlotSound("riseandshine", 7, "DrGBase.RiseAndShine")
    end
  }}
}

if SERVER then

  sound.Add({
    name = "DrGBase.RiseAndShine",
    sound = "vo/gman_misc/gman_riseshine.wav",
    channel = CHAN_VOICE,
    level = 60
  })

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetSelfClassRelationship(D_LI)
    self:SetPlayersRelationship(D_HT, 2)
    self:SetModelRelationship("models/props_c17/doll01.mdl", D_FR)
    self:SetModelRelationship("models/props_borealis/bluebarrel001.mdl", D_HT)
    for i, walk in ipairs({
      self.RunAnimation,
      self.WalkAnimation
    }) do
      self:SequenceEvent(self:SelectRandomSequence(walk), {0.28, 0.78}, function(self)
        self:EmitFootstep()
      end)
    end
    self.Mode = 0
  end
  function ENT:Use()
    self.Mode = (self.Mode+1)%2
    if self.Mode == 0 then
      DrGBase.Print("Default mode", {chat = true, color = DrGBase.CLR_GREEN})
      self.RangeAttackRange = 100
      self.MeleeAttackRange = 0
      self.ReachEnemyRange = 100
      self.AvoidEnemyRange = 25
    elseif self.Mode == 1 then
      DrGBase.Print("Projectile mode", {chat = true, color = DrGBase.CLR_GREEN})
      self.RangeAttackRange = 5000
      self.MeleeAttackRange = 0
      self.ReachEnemyRange = 4900
      self.AvoidEnemyRange = 0
    end
  end

  -- AI --

  function ENT:OnRangeAttack(enemy)
    if self.Mode == 0 then
      if self:IsMoving() then return end
      self:FaceTowards(enemy)
      self:PlaySequence("gesture_wave")
      self:EmitSlotSound("riseandshine", 7, "DrGBase.RiseAndShine")
    elseif self.Mode == 1 then
      if self:GetCooldown("Throw") > 0 then return end
      self:SetCooldown("Throw", 0.5)
      local proj = self:CreateProp("models/props_junk/watermelon01.mdl")
      if not IsValid(proj) then return end
      proj:SetPos(self:GetPos() + Vector(0, 0, self:Height()*1.1))
      proj:GetPhysicsObject():EnableGravity(true)
      proj:DrG_AimAt(enemy, 3000)
    end
  end

  function ENT:OnReachedPatrol()
    self:PlaySequenceAndWait("menu_gman")
  end

  -- Damage --

  function ENT:OnTraceAttack() end
  function ENT:OnTakeDamage(dmg, hitgroup)
    local attacker = dmg:GetAttacker()
    if hitgroup == HITGROUP_HEAD then
      if not self:HasSpotted(attacker) then
        self:Kill(attacker, dmg:GetInflictor())
      end
    end
    self:SpotEntity(attacker)
  end
  function ENT:OnDeath(dmg, hitgroup)
    if self:IsClimbing() then return end
    if hitgroup ~= HITGROUP_HEAD then
      local deaths = {"death_01", "death_02", "death_03"}
      self:PlaySequenceAndWait(deaths[math.random(#deaths)])
    else self:PlaySequenceAndWait("death_04") end
  end

  -- Misc --

  function ENT:OnClimbing(ladder, left, down)
    if IsValid(ladder) then
      self:EmitSlotSound("DrGBaseLadderClimbing", 0.3, "player/footsteps/ladder"..math.random(4)..".wav")
    end
    return not down and left < 112.5
  end
  function ENT:OnStopClimbing(ladder, height, down)
    if down then return end
    local footstep = false
    self:PlayClimbActivity(ACT_ZOMBIE_CLIMB_END, height, self.ClimbAnimRate, function(self, cycle)
      if cycle >= 0.875 and not footstep then
        footstep = true
        self:EmitFootstep()
      end
      if cycle > 0.5 or not IsValid(ladder) then return end
      self:EmitSlotSound("DrGBaseLadderClimbing", 0.3, "player/footsteps/ladder"..math.random(4)..".wav")
    end)
  end

  function ENT:OnRemove()
    self:StopSound("DrGBase.RiseAndShine")
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
