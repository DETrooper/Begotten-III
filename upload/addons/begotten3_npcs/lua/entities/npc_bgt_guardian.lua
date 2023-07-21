if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Guardian"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/AntLion.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = false;

local clawSounds = {"begotten/npc/brute/attack_claw_hit01.mp3", "begotten/npc/brute/attack_claw_hit02.mp3", "begotten/npc/brute/attack_claw_hit03.mp3"};
local painSounds = {"npc/zombie_poison/pz_warn1.wav", "npc/zombie_poison/pz_warn2.wav"};
local deathSounds = {"npc/zombie_poison/pz_pain1.wav", "npc/zombie_poison/pz_pain2.wav", "npc/zombie_poison/pz_pain3.wav"};
local tauntSounds = {"npc/ichthyosaur/attack_growl1.wav", "npc/ichthyosaur/attack_growl2.wav", "npc/ichthyosaur/attack_growl3.wav"};
local attackSounds = {"npc/ichthyosaur/attack_growl1.wav", "npc/ichthyosaur/attack_growl2.wav", "npc/ichthyosaur/attack_growl3.wav"};
local enabledSounds = {"npc/ichthyosaur/water_growl5.wav"};
local alertedSounds = {"npc/ichthyosaur/attack_growl1.wav", "npc/ichthyosaur/attack_growl2.wav", "npc/ichthyosaur/attack_growl3.wav"};

-- Sounds --
ENT.OnDamageSounds = painSounds
ENT.OnDeathSounds = deathSounds
ENT.PainSounds = painSounds;

-- Stats --
ENT.SpawnHealth = 300
ENT.SpotDuration = 20
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 60;

-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}

-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_RUN
ENT.JumpAnimation = "jump_glide"
ENT.RunAnimRate = 0
-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 10000
ENT.ClimbLadders = true
ENT.ClimbSpeed = 150
ENT.ClimbUpAnimation = "run_all_grenade"--ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.Damage = 30;

-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 30, 20),
    distance = 100
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
      self:EmitSound(table.Random(attackSounds), 100, self.pitch)
      self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
    end
  }}
}

if (CLIENT) then
	function ENT:CustomInitialize()
	local boneTable = {
		[1] = {"Antlion.WingL_Bone", Vector(0, 0, 0)},
		[2] = {"Antlion.WingR_Bone", Vector(0, 0, 0)},
		[3] = {"Antlion.Head_Bone", Vector(0.6, 0.2, 0.2)},
		[4] = {"Antlion.Back_Bone", Vector(0.6, 0.2, 0.3)}
	};
	
	self:AddCallback("BuildBonePositions", function(entity, numbones)
		for k, v in pairs (boneTable) do
			entity:ManipulateBoneScale(entity:LookupBone(v[1]), v[2]);
		end;
	end);
	end;
end;

if SERVER then



function ENT:OnSpotted()
	local curTime = CurTime();
	if (!self.nextNotice or self.nextNotice < curTime) then
		self.nextNotice = curTime + 20
		self:EmitSound(table.Random(enabledSounds), 100, self.pitch)
	end;
--	self:Jump(100)
end
function ENT:OnLost()
	local curTime = CurTime();
	if (!self.nextLo or self.nextLo < curTime) then
		self.nextLo = curTime + 20
		self:EmitSound(table.Random(alertedSounds), 100, self.pitch)
	end;
end


  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
			self:SetMaterial("models/zombie_fast/fast_zombie_sheet");
  end

  -- AI --

  function ENT:OnMeleeAttack(enemy)
    self:EmitSound(table.Random(tauntSounds), 100, self.pitch)
    self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
  end

  function ENT:OnReachedPatrol()
    self:Wait(math.random(3, 7))
  end
  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
	local curTime = CurTime();
	if (!self.nextId or self.nextId < curTime) then
		self.nextId = curTime + 10
		--self:EmitSound(, 100, self.pitch)
	end;
  end

  -- Damage --

  function ENT:OnDeath(dmg, delay, hitgroup)
  end
  function ENT:Makeup()

  end;
  ENT.ModelScale = 1
  ENT.pitch = 100
  function ENT:CustomThink()
		if (!self.lastStuck and self:IsStuck()) then
			self.lastStuck = CurTime() + 2;
		end;
		
		if (self.lastStuck and self.lastStuck < CurTime()) then
			if (self:IsStuck()) then
				self:Jump(100)
				--self:MoveForward(5000, function() return true end)
			end;
			
			self.lastStuck = nil
		end;
  end
  

   function ENT:OnRagdoll(ragdoll,dmg)
			self:SetMaterial("models/zombie_fast/fast_zombie_sheet");
   end;

  -- Animations/Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound(table.Random(enabledSounds), 100, self.pitch)
  end
  
  function ENT:OnChaseEnemy()
	local curTime = CurTime();
	if (!self.nextId or self.nextId < curTime) then
		self.nextId = curTime + math.random(7, 15)
		self:EmitSound(table.Random(tauntSounds), 100, self.pitch)
	end;
  end
  function ENT:OnLandedOnGround()
  end;
  function ENT:OnAnimEvent()
	local sha = false
    if self:IsAttacking() and self:GetCycle() > 0.3 then
      self:Attack({
        damage = self.Damage,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0)
      }, function(self, hit)
        if #hit > 0 then
          self:EmitSound(table.Random(clawSounds), 100, self.pitch)
        else self:EmitSound("Zombie.AttackMiss") end
      end)
    else
		self:EmitSound("npc/headcrab_poison/ph_step"..math.random(1, 4)..".wav")
		end
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
