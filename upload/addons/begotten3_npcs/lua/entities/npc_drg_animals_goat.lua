if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Goat"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animals/goat.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(15, 15, 40)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = false

-- Sounds --
ENT.OnDamageSounds = {"goat/idle1.wav"}
--ENT.OnIdleSounds = {"goat/idle1.wav"}

-- Stats --
ENT.ArmorPiercing = 10;
ENT.SpawnHealth = 60
ENT.XPValue = 25;

-- Regen --

ENT.HealthRegen = 1

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 30
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_DEER","FACTION_FORESTHERBIVORES","FACTION_BROWNBEAR", "FACTION_SNOWLEOPARD"}

-- Movements/animations --
ENT.IdleAnimation = "idle"
ENT.RunAnimation = "run"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 200
ENT.WalkSpeed = 30
ENT.JumpAnimation = "idle"

ENT.Acceleration = 360
ENT.Deceleration = 360

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 5, 25),
    distance = 100
  }
}
ENT.MaxYawRate = 150
ENT.PossessionBinds = {
  [IN_JUMP] = {{
    coroutine = true,
    onkeydown = function(self)
          self:Jump(100)
      end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
			  local att = math.random(1)	
  if att == 1 then
   self:Attack1()	
   self:PlaySequenceAndMove("attack1", 1, self.PossessionFaceForward)
end
end
  }}
}

if SERVER then

function ENT:OnDeath(dmg, delay, hitgroup)	
	local gib = ents.Create( "prop_ragdoll" )
	gib:SetModel( "models/animals/goat.mdl" )
	gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	
	timer.Simple(600, function()
		if IsValid(gib) then
			gib:Remove();
		end
	end);
end

  -- Init/Think --

function ENT:CustomInitialize()
self:SetModelScale(0.8)
self:SetDefaultRelationship(D_FR)
self:SequenceEvent("walk",0/2,self.Step)
self:SequenceEvent("walk",1/2,self.Step)
self:SequenceEvent("run",0/2,self.Step)
self:SequenceEvent("run",1/2,self.Step)
end
function ENT:Step()
self:EmitFootstep()
self:EmitSound("Etc/Hoove1.mp3", 55)
end
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
   self:PlaySequenceAndMove("attack1", 1, self.FaceEnemy)
end
end
end

 -- Patrol --

  function ENT:OnReachedPatrol()
  self:Wait(4)
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1000))
  end

  -- Animations/Sounds --

  function ENT:Attack1()
      self:Attack({
        damage = 10,
        range = 40,
        delay = 1,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0),
      }, function(self, hit)
        force = Vector(500, 500, 500)
        if #hit > 0 then
			self:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 2)..".wav", 90)
		else 
			self:EmitSound("bear/woosh1.wav", 80) end
      end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)