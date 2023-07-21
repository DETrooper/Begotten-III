if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Antlion"
ENT.Category = "DrGBase"
ENT.Models = {"models/Antlion.mdl"}
ENT.Skins = {0, 1, 2, 3}
ENT.CollisionBounds = Vector(30, 30, 60)
ENT.BloodColor = BLOOD_COLOR_YELLOW

-- Sounds --
ENT.OnDamageSounds = {"NPC_Antlion.Pain"}

-- Stats --
ENT.SpawnHealth = 40

-- AI --
ENT.RangeAttackRange = 750
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0
ENT.FollowPlayers = true

-- Relationships --
ENT.Factions = {FACTION_ANTLIONS}

-- Movements/animations --
ENT.UseWalkframes = true
ENT.JumpAnimation = ACT_GLIDE

-- Detection --
ENT.EyeBone = "Antlion.Head_Bone"
ENT.EyeOffset = Vector(7.5, 0, 5)
ENT.EyeAngle = Angle(0, 0, 0)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionCrosshair = true
ENT.PossessionViews = {
  {
    offset = Vector(0, 40, 0),
    distance = 125
  },
  {
    offset = Vector(7.5, 0, 10),
    distance = 0,
    eyepos = true
  }
}
ENT.PossessionBinds = {
  [IN_JUMP] = {{
    coroutine = false,
    onkeypressed = function(self)
      if not self:IsOnGround() then return end
      self:LeaveGround()
      self:SetVelocity(self:PossessorNormal()*1500)
    end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
      self:PlaySequenceAndMove("attack"..math.random(6), 1, self.PossessionFaceForward)
    end
  }},
  [IN_ATTACK2] = {{
    coroutine = true,
    onkeydown = function(self)
      self:BurrowTo(self:PossessorTrace().HitPos)
    end
  }}
}

if SERVER then

  -- Antlion --

  function ENT:BurrowTo(pos)
    self:PlaySequenceAndMove("digin")
    if navmesh.IsLoaded() then
      pos = navmesh.GetNearestNavArea(pos):GetClosestPointOnArea(pos) or pos
    end
    self:SetPos(pos)
    self:DropToFloor()
    self:PlaySequenceAndMove("digout")
  end

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
  end

  -- AI --

  function ENT:OnRangeAttack(enemy)
    if not self:IsInRange(enemy, 500) then
      self:Leap(enemy, 1000)
      self:PauseCoroutine(0.25)
    end
  end
  function ENT:OnMeleeAttack(enemy)
    self:PlaySequenceAndMove("attack"..math.random(6), 1, self.FaceEnemy)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Animations/Sounds --

  function ENT:OnLeaveGround()
    self:SetBodygroup(1, 1)
    self:PlayActivity(ACT_JUMP)
    self.WingsOpen = self:StartLoopingSound("NPC_Antlion.WingsOpen")
  end
  function ENT:OnLandOnGround()
    self:SetBodygroup(1, 0)
    if isnumber(self.WingsOpen) then
      self:StopLoopingSound(self.WingsOpen)
      self:EmitSlotSound("Landing", 1, "NPC_Antlion.Land")
    end
  end

  function ENT:OnAnimEvent()
    if self:IsAttacking() then
      if self:GetCycle() > 0.3 then
        self:Attack({
          damage = 5,
          range = 50,
          type = DMG_SLASH,
          viewpunch = Angle(10, 0, 0)
        }, function(self, hit)
          if #hit > 0 then self:EmitSound("NPC_Antlion.MeleeAttack") end
        end)
      else self:EmitSound("NPC_Antlion.MeleeAttackSingle") end
    elseif self:IsOnGround() then
      self:EmitSound("NPC_Antlion.Footstep")
    end
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
