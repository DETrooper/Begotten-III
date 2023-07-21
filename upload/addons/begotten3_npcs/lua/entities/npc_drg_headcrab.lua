if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Headcrab"
ENT.Category = "DrGBase"
ENT.Models = {"models/headcrabclassic.mdl"}
ENT.CollisionBounds = Vector(12, 12, 24)
ENT.BloodColor = BLOOD_COLOR_GREEN

-- Stats --
ENT.SpawnHealth = 40

-- Sounds --
ENT.OnIdleSounds = {"NPC_HeadCrab.Idle"}
ENT.OnDamageSounds = {"NPC_HeadCrab.Pain"}
ENT.OnDeathSounds = {"NPC_HeadCrab.Die"}

-- AI --
ENT.RangeAttackRange = 150
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 125
ENT.AvoidEnemyRange = 100

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Animations --
ENT.WalkAnimation = ACT_RUN
ENT.RunAnimation = ACT_RUN
ENT.IdleAnimation = ACT_IDLE
ENT.JumpAnimation = ACT_IDLE

-- Movements --
ENT.UseWalkframes = true

-- Detection --
ENT.EyeBone = "HeadcrabClassic.SpineControl"
ENT.EyeOffset = Vector(4, 0, 0)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionCrosshair = true
ENT.PossessionViews = {
  {
    offset = Vector(0, 10, 10),
    distance = 50
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
      self:HeadcrabLeap(self:PossessorTrace().HitPos)
    end
  }}
}

if SERVER then

  -- Headcrab --

  function ENT:HeadcrabLeap(pos)
    self:FaceTo(pos)
    self.OnIdleSounds = {}
    self:PlaySequence("jumpattack_broadcast")
    self:PauseCoroutine(0.5)
    self.CanBite = true
    self:EmitSound("NPC_Headcrab.Attack")
    self:Leap(pos, 400)
    self.CanBite = false
    self.OnIdleSounds = {"NPC_HeadCrab.Idle"}
  end

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
  end
  function ENT:CustomThink() end

  -- AI --

  function ENT:OnRangeAttack(enemy)
    self:HeadcrabLeap(enemy:EyePos()-Vector(0, 0, 10))
  end
  function ENT:OnContact(ent)
    if not IsValid(ent) then return end
    if self.CanBite and
    (self:IsPossessed() or ent == self:GetEnemy()) then
      self:EmitSound("NPC_HeadCrab.Bite")
      self.CanBite = false
      local dmg = DamageInfo()
      dmg:SetDamage(20)
      dmg:SetAttacker(self)
      dmg:SetInflictor(self)
      dmg:SetDamageType(DMG_SLASH)
      ent:TakeDamageInfo(dmg)
    end
  end

  function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7))
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Damage --

  function ENT:OnTakeDamage(dmg)
    local attacker = dmg:GetAttacker()
    if IsValid(attacker) and attacker:IsPlayer() then
      local weapon = attacker:GetActiveWeapon()
      if IsValid(weapon) and weapon:GetClass() == "weapon_crowbar" then
        return 2
      end
    end
  end

  -- Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound("NPC_HeadCrab.Alert")
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
