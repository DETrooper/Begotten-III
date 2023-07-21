ENT.Base = "drgbase_nextbot"
ENT.IsDrGNextbotHuman = true

-- AI --
ENT.BehaviourType = AI_BEHAV_HUMAN
ENT.RangeAttackRange = 1500
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 1000
ENT.AvoidEnemyRange = 750
ENT.AvoidAfraidOfRange = 500
ENT.WatchAfraidOfRange = 750

-- Movements/animations --
DrGBase.IncludeFile("animations.lua")
DrGBase.IncludeFile("movements.lua")

-- Climbing --
ENT.ClimbLadders = true
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_ZOMBIE_CLIMB_UP
ENT.ClimbOffset = Vector(-14, 0, 0)

-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Head1"
ENT.EyeOffset = Vector(5, 0, 2.5)

-- Weapons --
ENT.UseWeapons = true
ENT.Weapons = {}
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = true

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 30, 20),
    distance = 100
  },
  {
    offset = Vector(7.5, 0, 2.5),
    distance = 0,
    eyepos = true
  }
}
ENT.PossessionBinds = {
  [IN_DUCK] = {{
    coroutine = false,
    onkeypressed = function(self)
      self:SetCrouching(not self:IsCrouching())
    end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
      self:PrimaryFire()
    end
  }},
  [IN_ATTACK2] = {{
    coroutine = true,
    onkeydown = function(self)
      self:SecondaryFire()
    end
  }},
  [IN_RELOAD] = {{
    coroutine = true,
    onkeydown = function(self)
      self:Reload()
    end
  }}
}

if SERVER then
  AddCSLuaFile()

  -- Init/Think --

  function ENT:_BaseThink()
    if self:HasWeapon() then
      if self:IsPossessed() then
        local lockedOn = self:PossessionGetLockedOn()
        if not IsValid(lockedOn) then
          self:AimAt(self:PossessorTrace().HitPos)
        else self:AimAt(lockedOn) end
      elseif self:HasEnemy() and self:Visible(self:GetEnemy()) then
        self:AimAt(self:GetEnemy())
      else self:AimAt() end
    else self:AimAt() end
  end

  -- AI --

  function ENT:OnLastEnemy()
    if self:HasWeapon() and not self:IsWeaponFull() then self:Reload() end
  end

  -- Weapons --

  function ENT:PrimaryFire()
    if not self:HasWeapon() then return end
    return self:WeaponPrimaryFire(self:GetShootAnimation())
  end
  function ENT:SecondaryFire()
    if not self:HasWeapon() then return end
    return self:WeaponSecondaryFire(self:GetShootAnimation())
  end
  function ENT:Reload()
    if not self:HasWeapon() then return end
    return self:WeaponReload(self:GetReloadAnimation())
  end

  -- Hooks --

  function ENT:OnLandOnGround()
    self:EmitFootstep()
  end

  function ENT:OnAnimEvent(event)
    if event == "PlayerStep" then
      self:EmitFootstep()
    end
  end

end
