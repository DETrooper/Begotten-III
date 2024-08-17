if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Deer"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animals/deer1.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(18, 18, 50)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = false

-- Sounds --
ENT.OnDamageSounds = {"deer/idle1.wav"}
--ENT.OnIdleSounds = {"deer/idle1.wav"}

-- Stats --
ENT.ArmorPiercing = 5;
ENT.SpawnHealth = 70
ENT.XPValue = 35;

-- Regen --

ENT.HealthRegen = 1

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 4000
ENT.AvoidAfraidOfRange = 4000
ENT.WatchAfraidOfRange = 3500

-- Relationships --
ENT.Factions = {"FACTION_DEER","FACTION_FORESTHERBIVORES","FACTION_BROWNBEAR", "FACTION_SNOWLEOPARD"}

-- Movements/animations --
ENT.IdleAnimation = "idle"
ENT.RunAnimation = "run"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 400
ENT.WalkSpeed = 50
ENT.JumpAnimation = "idle"

ENT.Acceleration = 300
ENT.Deceleration = 300

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 5, 25),
    distance = 100
  }
}
ENT.MaxYawRate = 260
ENT.PossessionBinds = {
  [IN_JUMP] = {{
    coroutine = true,
    onkeydown = function(self)
          self:Jump(200)
      end
  }},
  [IN_ATTACK] = {{
    coroutine = true,
    onkeydown = function(self)
			  local att = math.random(1)	
  if att == 1 then
   self:Hit1()	
end
end
  }}
}

if SERVER then

function ENT:OnDeath(dmg, delay, hitgroup)	
	local gib = ents.Create( "prop_ragdoll" )
	gib:SetModel( "models/animals/deer1.mdl" )
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
self:SetDefaultRelationship(D_FR)
self:SequenceEvent("walk",0/2,self.Step)
self:SequenceEvent("walk",1/2,self.Step)
self:SequenceEvent("run",0/2,self.Step)
self:SequenceEvent("run",1/2,self.Step)
end
function ENT:Step()
self:EmitFootstep()
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
   self:Hit1()
end
end
end

 -- Patrol --

  function ENT:OnReachedPatrol()
  self:Wait(8)
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1000))
  end

  -- Stuff --

function ENT:Hit1()
	if not self:GetCooldown("Stuff") then return end
	if self:GetCooldown("Stuff") == 0 then
	self:SetCooldown("Stuff", 0.6)
	local terma2 = math.random(1)
  if terma2 == 1 then		
   self:Hit2()
 end
 end
end

  -- Animations/Sounds --

  function ENT:Hit2()
      self:Attack({
        damage = 14,
        range = 60,
        delay = 0,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0),
      }, function(self, hit)
        if #hit > 0 then
			self:PushEntity(hit, Vector(100,100,100))
			self:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 2)..".wav", 90)
		else 
			self:EmitSound("bear/woosh1.wav", 80) end
      end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)