if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "King Cobra"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animals/kingcobra.mdl"}
ENT.RagdollOnDeath = true
ENT.CollisionBounds = Vector(10, 10, 30)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.Frightening = true
ENT.SightFOV = 300
ENT.SightRange = 500

-- Sounds --
ENT.OnDamageSounds = {"snake/idle1.wav"}
ENT.OnIdleSounds = {"snake/idle1.wav"}

-- Stats --
ENT.ArmorPiercing = 50;
ENT.SpawnHealth = 40
ENT.StaminaDamage = 30;
ENT.XPValue = 50;

-- Regen --

ENT.HealthRegen = 1

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 40
ENT.ReachEnemyRange = 40
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_KINGCOBRA"}

-- Movements/animations --
ENT.IdleAnimation = "idle_inactive"
ENT.RunAnimation = "run"
ENT.WalkAnimation = "walk"
ENT.RunSpeed = 110
ENT.WalkSpeed = 15
ENT.JumpAnimation = "run"
ENT.Flinching = false

ENT.Acceleration = 110
ENT.Deceleration = 110

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
		offset = Vector(0, 5, 20),
		distance = 90
	}
}
ENT.MaxYawRate = 200
ENT.PossessionBinds = {
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
	
	-- Afraid --
	
	function ENT:OnTakeDamage(dmg)
		if math.random(1,2) == 1 and self.Flinching == false and (dmg:GetDamage() > 10 or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_SLASH) or dmg:IsDamageType(DMG_BULLET) or dmg:IsDamageType(DMG_CRUSH)) then
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
		self:SetModelScale(0.6)
		self:SetDefaultRelationship(D_HT)
	end
	
	-- AI --
	
	function ENT:OnMeleeAttack(enemy)
		local att = math.random(1)	
		if att == 1 then
			self:Attack1()	
			self:PlaySequenceAndMove("attack1", 1, self.FaceEnemy)
		end
	end
end

-- Patrol --

function ENT:OnReachedPatrol()
	self:Wait(9)
	self:SetDefaultRelationship(D_HT)
end
function ENT:OnIdle()
	self:AddPatrolPos(self:RandomPos(1000))
end

-- Animations/Sounds --

function ENT:Attack1()
	self:Attack({
		damage = 100,
		range = 50,
		delay = 1.2,
		type = DMG_SLASH,
		viewpunch = Angle(20, math.random(-10, 10), 0),
	}, function(self, hit)
		force = Vector(500, 500, 500)
	end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)