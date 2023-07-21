if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_sprite" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Test 2D Nextbot"
ENT.Category = "DrGBase"
ENT.CollisionBounds = Vector(10, 10, 100)

-- AI --
ENT.RangeAttackRange = 200
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 200
ENT.AvoidEnemyRange = 0

-- Animations --
ENT.SpriteFolder = "drgbase/stick_boi"
ENT.FramesPerSecond = 6
ENT.WalkAnimation = "walk"
ENT.WalkAnimRate = 0.5
ENT.RunAnimation = "walk"
ENT.IdleAnimation = "idle"
ENT.JumpAnimation = "jump"

-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLadders = true
ENT.ClimbLaddersUp = true
ENT.ClimbLaddersDown = true
ENT.ClimbUpAnimation = "climb"
ENT.ClimbDownAnimation = "climb"
ENT.ClimbAnimRate = 0.5

-- Detection --
ENT.EyeOffset = Vector(0, 0, 30)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 30, 20),
    distance = 100
  },
  {
    offset = Vector(5, 0, 0),
    distance = 0,
    eyepos = true
  }
}
ENT.PossessionBinds = {
  [IN_JUMP] = {{
    coroutine = false,
    onkeypressed = function(self)
      if not self:IsOnGround() then return end
      self:EmitFootstep()
      self:Jump()
    end
  }}
}

if SERVER then

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetSelfClassRelationship(D_HT)
    self:SetDefaultRelationship(D_HT, 2)
    self:SetPlayersRelationship(D_HT, 3)
    self:SpriteAnimEvent("walk", {1, 2}, function(self, frame)
      self:EmitFootstep()
    end)
    self:SpriteAnimEvent("climb", {1, 2}, function(self, frame)
      if self:IsClimbingLadder() then self:EmitSound("player/footsteps/ladder"..math.random(4)..".wav") end
    end)
    self:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
  end

  -- AI --

  function ENT:OnRangeAttack(enemy)
    self:PauseCoroutine(0.5)
    self:EmitFootstep()
    self:Jump()
  end
  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Sounds --

  function ENT:OnLandOnGround()
    self:EmitFootstep()
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
