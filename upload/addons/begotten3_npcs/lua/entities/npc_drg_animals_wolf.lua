if not DrGBase then -- return if DrGBase isn't installed
  return
end

ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Wolf"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/creatures/wolf.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(15, 15, 40)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = false
ENT.SightRange = 1200
ENT.HearingCoefficient = 0.8
ENT.Skins = {0, 1, 2}
-- Sounds --
ENT.OnDamageSounds = {"apocalypse/wolves/pseudodog/pdog_hurt_0.ogg", "apocalypse/wolves/pseudodog/pdog_hurt_1.ogg"}
--ENT.OnIdleSounds = {"leopard/idle1.wav"}
-- Stats --
ENT.ArmorPiercing = 35
ENT.SpawnHealth = 100
ENT.StaminaDamage = 25;
ENT.XPValue = 65
ENT.MaxMultiHit = 1;
-- Regen --
ENT.HealthRegen = 1
-- AI --
ENT.RangeAttackRange = 700
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 0
-- Relationships --
ENT.Factions = {"FACTION_WOLF"}
-- Movements/animations --
ENT.IdleAnimation = "mtidle"
ENT.RunAnimation = "H2hfastforward"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 400
ENT.WalkSpeed = 50
ENT.JumpAnimation = "mtidle"
ENT.Flinching = false
ENT.Acceleration = 400
ENT.Deceleration = 400
-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 300
ENT.ClimbLadders = true
ENT.ClimbSpeed = 90
ENT.ClimbUpAnimation = "walk"
ENT.ClimbOffset = Vector(-14, 0, 0)
-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 3, 18),
    distance = 100
  }
}

ENT.MaxYawRate = 200
ENT.PossessionBinds = {
  [IN_ATTACK] = {
    {
      coroutine = true,
      onkeydown = function(self)
        local att = math.random(3)
        if att == 1 then
          self:Attack1()
          self:PlaySequenceAndMove("h2hattackright", 1, self.PossessionFaceForward)
        end

        if att == 2 then
          self:Attack1()
          self:PlaySequenceAndMove("h2hattackleft", 1, self.PossessionFaceForward)
        end

        if att == 3 then
          self:Attack1()
          self:PlaySequenceAndMove("h2hattackpower", 1, self.PossessionFaceForward)
        end
      end
    }
  }
}

if SERVER then
  function ENT:OnDeath(dmg, delay, hitgroup)
    local gib = ents.Create("prop_ragdoll")
    gib:SetModel("models/begotten/creatures/wolf.mdl")
    gib:SetSkin(self:GetSkin())
    gib:SetPos(self:LocalToWorld(Vector(0, 0, 0))) -- The Postion the model spawns
    gib:SetAngles(self:GetAngles())
	gib:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
    gib:Spawn()
    timer.Simple(600, function() if IsValid(gib) then gib:Remove() end end)
  end

  -- Afraid --
  --[[
function ENT:OnTakeDamage(dmg)
if math.random(1,2) == 1 and self.Flinching == false and (dmg:GetDamage() > 50 or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_SLASH) or dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_CRUSH)) then
self.Flinching = true
if self.Charging == true then
self:StopCharge()
end
self:CallInCoroutine(function(self, delay)
if math.random(2) == 1 then
self:SetDefaultRelationship(D_FR)

elseif math.random(2) == 2 then
self:SetDefaultRelationship(D_FR)

end
if not self.Flinching then return true end
self.Flinching = false
end)
end
end
]]
  -- Init/Think --
  function ENT:CustomInitialize()
	self:SetSolidMask(MASK_PLAYERSOLID)
    self:SetDefaultRelationship(D_HT)
    self:SequenceEvent("walk", 0 / 2, self.Step)
    self:SequenceEvent("walk", 0.5 / 2, self.Step)
    self:SequenceEvent("walk", 1 / 2, self.Step)
    self:SequenceEvent("walk", 1.5 / 2, self.Step)
    self:SequenceEvent("H2hfastforward", 0 / 2, self.Step)
    self:SequenceEvent("H2hfastforward", 1 / 2, self.Step)
    self:SequenceEvent("h2hattackright", 0.5 / 2, self.Step)
    self:SequenceEvent("h2hattackright", 1.5 / 2, self.Step)
    self:SequenceEvent("h2hattackleft", 0.5 / 2, self.Step)
    self:SequenceEvent("h2hattackleft", 1.5 / 2, self.Step)
    self:SequenceEvent("h2hattackpower", 1 / 2, self.Step)
    self:SequenceEvent("h2hattackpower", 1.5 / 2, self.Step)
    self:SetPlaybackRate(1)
  end

  function ENT:Step()
    self:EmitFootstep()
  end

  -- AI --
  function ENT:OnParried()
    self.nextMeleeAttack = CurTime() + 2
  end

  function ENT:OnMeleeAttack(enemy)
    local att = math.random(1, 3)
    if not self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
      if att == 1 then
        self:Attack1()
        self:PlaySequenceAndMove("h2hattackright", 1, self.FaceEnemy)
      end

      if att == 2 then
        self:Attack1()
        self:PlaySequenceAndMove("h2hattackleft", 1, self.FaceEnemy)
      end

      if att == 3 then
        self:Attack1()
        self:PlaySequenceAndMove("h2hattackpower", 1, self.FaceEnemy)
      end
    end
  end
end

-- Patrol --
function ENT:OnReachedPatrol()
  self:Wait(6)
  self:SetDefaultRelationship(D_HT)
  self:PlaySequenceAndMove("mtidle")
  self:SetPlaybackRate(1)
end

function ENT:OnIdle()
  self:AddPatrolPos(self:RandomPos(1000))
  self:SetPlaybackRate(1)
end

function ENT:OnNewEnemy() 
	if self.pack then
		for i, v in ipairs(self.pack) do
			if IsValid(v) then
				if !IsValid(v:GetEnemy()) then
					v:SetEnemy(self:GetEnemy());
				end
			end
		end
	end
end

-- Animations/Sounds --
function ENT:Attack1()
  self:Attack({
    damage = 20,
    range = 100,
    delay = 0.6,
    type = DMG_SLASH,
    viewpunch = Angle(20, math.random(-10, 10), 0),
  }, function(self, hit)
    force = Vector(1000, 1000, 1000)
    if #hit > 0 then
      self:EmitSound("apocalypse/wolves/pseudodog/pdog_aggression_0.ogg", 90)
    else
      self:EmitSound("apocalypse/wolves/dog/bdog_die_2.ogg", 80)
    end
  end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)