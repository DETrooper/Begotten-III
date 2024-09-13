if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Bear"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animals/bear.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(18, 18, 65)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = false
ENT.SightFOV = 300
ENT.SightRange = 800

-- Sounds --
ENT.OnDamageSounds = {"bear/attack1.wav"}
ENT.OnIdleSounds = {"bear/idle1.wav", "bear/idle2.wav"}
ENT.IdleSoundDelay = 240

-- Stats --
ENT.ArmorPiercing = 55;
ENT.SpawnHealth = 400;
ENT.StaminaDamage = 55;
ENT.XPValue = 70;
ENT.MaxMultiHit = 2;

-- Regen --

ENT.HealthRegen = 1

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 120
ENT.ReachEnemyRange = 80
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_DEER","FACTION_FORESTHERBIVORES","FACTION_BROWNBEAR", "FACTION_SNOWLEOPARD"}

-- Movements/animations --
ENT.IdleAnimation = "idle"
ENT.RunAnimation = "run"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 300
ENT.WalkSpeed = 30
ENT.JumpAnimation = "idle"
ENT.Flinching = false

ENT.Acceleration = 300
ENT.Deceleration = 300

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
    offset = Vector(0, 10, 15),
    distance = 130
  }
}
ENT.MaxYawRate = 150
ENT.PossessionBinds = {
  [IN_WALK] = {{
    coroutine = true,
    onkeydown = function(self)
          self:PlaySequenceAndMove("shake")
      end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
			  local att = math.random(2)	
  if att == 1 then
   self:Attack1()	
   self:PlaySequenceAndMove("attack1", 1, self.PossessionFaceForward)
end
  if att == 2 then
   self:Attack1()	
   self:PlaySequenceAndMove("attack2", 1, self.PossessionFaceForward)
end
end
  }}
}

if SERVER then

function ENT:OnDeath(dmg, delay, hitgroup)
	local gib = ents.Create( "prop_physics" )
	gib:SetModel( "models/animals/bear.mdl" )
	gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	
	timer.Simple(600, function()
		if IsValid(gib) then
			gib:Remove();
		end
	end);
end

 -- Afraid --

 --[[
function ENT:OnTakeDamage(dmg)
if math.random(1,2) == 1 and self.Flinching == false and (dmg:GetDamage() > 100 or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_SLASH) or dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_CRUSH)) then
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
 --]]

  -- Init/Think --

function ENT:CustomInitialize()
self:SetDefaultRelationship(D_HT)
self:SequenceEvent("walk",0/2,self.Step)
self:SequenceEvent("walk",0.4/2,self.Step)
self:SequenceEvent("walk",0.8/2,self.Step)
self:SequenceEvent("walk",1.5/2,self.Step)
self:SequenceEvent("run",0/2,self.Step)
self:SequenceEvent("run",1/2,self.Step)
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
		local att = math.random(2)	
    if att == 1 then
    self:Attack1()	
    self:PlaySequenceAndMove("attack1", 1, self.FaceEnemy)
    end
    if att == 2 then
    self:Attack1()	
    self:PlaySequenceAndMove("attack2", 1, self.FaceEnemy)
    end
  end
end
end

 -- Patrol --

  function ENT:OnReachedPatrol()
  self:PlaySequenceAndMove("shake")
  self:Wait(4)
  self:SetDefaultRelationship(D_HT)
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1000))
  end

  -- Animations/Sounds --

  function ENT:Attack1()
      self:Attack({
        damage = 50,
        range = 160,
        delay = 0.6,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0),
      }, function(self, hit)
        force = Vector(1000, 1000, 1000)
        if #hit > 0 then
			self:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 2)..".wav", 90)
		else 
			self:EmitSound("bear/woosh1.wav", 80) end
      end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)