if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Snow Leopard"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animal_ragd/piratecat_leopard.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(15, 15, 40)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = true
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.HearingCoefficient = 0.5

-- Sounds --
--ENT.OnDamageSounds = {"leopard/attack.wav"}
--ENT.OnIdleSounds = {"leopard/idle1.wav"}

-- Stats --
ENT.ArmorPiercing = 50;
ENT.SpawnHealth = 275;
ENT.StaminaDamage = 35;
ENT.XPValue = 75;
ENT.MaxMultiHit = 1;

-- Regen --

ENT.HealthRegen = 1

-- AI --
ENT.RangeAttackRange = 700
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_DEER","FACTION_FORESTHERBIVORES","FACTION_BROWNBEAR", "FACTION_SNOWLEOPARD"}

-- Movements/animations --
ENT.IdleAnimation = "idle"
ENT.RunAnimation = "run"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 700
ENT.WalkSpeed = 20
ENT.JumpAnimation = "leap"
ENT.Flinching = false

ENT.Acceleration = 1000
ENT.Deceleration = 1000

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
    offset = Vector(0, 5, 20),
    distance = 120
  }
}
ENT.MaxYawRate = 200
ENT.PossessionBinds = {
  [IN_WALK] = {{
    coroutine = true,
    onkeydown = function(self)
          self:PlaySequenceAndMove("idle_inactive")
      end
  }},
  [IN_JUMP] = {{
    coroutine = true,
    onkeydown = function(self)
          self:Jump(250)
      end
  }},
  [IN_ATTACK2] = {{
    coroutine = true,
    onkeydown = function(self)
          self:OnRangeAttack()
      end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
			  local att = math.random(1)	
  if att == 1 then
   self:Attack1()	
   self:PlaySequenceAndMove("attack1", 2, self.PossessionFaceForward)
end
end
  }}
}

if SERVER then

function ENT:OnDeath(dmg, delay, hitgroup)	
  local gib = ents.Create( "prop_ragdoll" )
  gib:SetModel( "models/animal_ragd/piratecat_leopard.mdl" )
  gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
  gib:SetAngles( self:GetAngles() )
  gib:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
  gib:Spawn()
  
  timer.Simple(600, function()
    if IsValid(gib) then
      gib:Remove();
    end
  end);
end  

 -- Leap --

function ENT:OnRangeAttack()
if not self:GetCooldown("Leap") then return end
if self:GetCooldown("Leap") == 0 then
self:SetCooldown("Leap", 8)
self:SetVelocity(self:GetUp()*100)
self:SetVelocity(self:GetForward()*600)
self:Jump(100)
self:EmitSound("leopard/idle1.wav", 80)
end
end

 -- Afraid --

function ENT:OnTakeDamage(dmg)
if math.random(1,2) == 1 and self.Flinching == false and (dmg:GetDamage() > 20 or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_SLASH) or dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_CRUSH)) then
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

  -- Init/Think --

function ENT:CustomInitialize()
self:SetSolidMask(MASK_PLAYERSOLID)
self:SetDefaultRelationship(D_HT)
self:SequenceEvent("walk",0/2,self.Step)
self:SequenceEvent("walk",0.4/2,self.Step)
self:SequenceEvent("walk",0.8/2,self.Step)
self:SequenceEvent("walk",1.5/2,self.Step)
self:SequenceEvent("run",0/2,self.Step)
self:SequenceEvent("run",1/2,self.Step)
self:SequenceEvent("idle_inactive",0.3/2,self.Step)
self:SequenceEvent("idle_inactive",0.4/2,self.Step)
self:SequenceEvent("idle_inactive",0.5/2,self.Step)
self:SequenceEvent("idle_inactive",0.65/2,self.Step)
self:SequenceEvent("idle_inactive",0.75/2,self.Step)
self:SequenceEvent("idle_inactive",0.8/2,self.Step)
self:SequenceEvent("idle_inactive",1.7/2,self.Step)
self:SequenceEvent("idle_inactive",1.9/2,self.Step)
self:SequenceEvent("idle_inactive",1.8/2,self.Step)
end

function ENT:Step()
self:EmitFootstep()
end

  -- AI --

  function ENT:OnParried()
    self.nextMeleeAttack = CurTime() + 2;
	self:ResetSequence(ACT_IDLE);
  end

  function ENT:OnMeleeAttack(enemy)
    if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
			  local att = math.random(1)	
  if att == 1 then
   self:Attack1()	
   self:PlaySequenceAndMove("attack1", 2, self.FaceEnemy)
end
end
end
end

 -- Patrol --

  function ENT:OnReachedPatrol()
  self:Wait(6)
  self:SetDefaultRelationship(D_HT)
  self:PlaySequenceAndMove("idle_inactive")
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1000))
  end

  -- Animations/Sounds --

  function ENT:Attack1()
      self:Attack({
        damage = 40,
        range = 150,
	      delay = 0.8,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0),
      }, function(self, hit)
        force = Vector(1000, 1000, 1000)
        if #hit > 0 then
					self:EmitSound("leopard/attack1.wav", 90)
				else self:EmitSound("bear/woosh1.wav", 80) end
      end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)