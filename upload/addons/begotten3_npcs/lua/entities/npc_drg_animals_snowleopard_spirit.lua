if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Snow Leopard (Spirit)"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/animal_ragd/piratecat_leopard.mdl"}
ENT.RagdollOnDeath = false
ENT.CollisionBounds = Vector(15, 15, 40)
ENT.BloodColor = DONT_BLEED
ENT.Frightening = false
ENT.SightRange = 1000

-- Sounds --
ENT.OnDamageSounds = {"leopard/attack.wav"}
--ENT.OnIdleSounds = {"leopard/idle1.wav"}

-- Stats --
ENT.ArmorPiercing = 75;
ENT.SpawnHealth = 425;
ENT.StaminaDamage = 60;
ENT.XPValue = 250;

-- Regen --

ENT.HealthRegen = 0

-- AI --
ENT.RangeAttackRange = 700
ENT.MeleeAttackRange = 60
ENT.ReachEnemyRange = 60
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_SPIRIT_GORE"}

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
   self:PlaySequenceAndMove("attack1", 1, self.PossessionFaceForward)
end
end
  }}
}

if SERVER then
      
    function ENT:OnDeath(dmg)
        local gib = ents.Create( "prop_ragdoll" )
        gib:SetModel( "models/animal_ragd/piratecat_leopard.mdl" )
        gib:SetMaterial("models/props_combine/portalball001_sheet")  
        gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
        gib:SetAngles( self:GetAngles() )
        gib:Spawn()
          
          if IsValid(gib) then
              ParticleEffectAttach("doom_dissolve", PATTACH_POINT_FOLLOW, gib, 0);
              
              timer.Simple(1.6, function() 
                  if IsValid(gib) then
                      ParticleEffectAttach("doom_dissolve_flameburst", PATTACH_POINT_FOLLOW, gib, 0);
                      gib:Fire("fadeandremove", 1);
                      gib:EmitSound("begotten/npc/burn.wav");
                      
                      if cwRituals and cwItemSpawner and !hook.Run("GetShouldntThrallDropCatalyst", gib) then
                          local randomItem;
                          local spawnable = cwItemSpawner:GetSpawnableItems(true);
                          local lootPool = {};
                          
                          for _, itemTable in ipairs(spawnable) do
                              if itemTable.category == "Catalysts" then
                                  if itemTable.itemSpawnerInfo and !itemTable.itemSpawnerInfo.supercrateOnly then
                                      table.insert(lootPool, itemTable);
                                  end
                              end
                          end
                          
                          randomItem = lootPool[math.random(1, #lootPool)];
                          
                          if randomItem then
                              local itemInstance = item.CreateInstance(randomItem.uniqueID);
                              
                              if itemInstance then
                                  local entity = Clockwork.entity:CreateItem(nil, itemInstance, gib:GetPos() + Vector(0, 0, 16));
                                  
                                  entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
                                  
                                  table.insert(cwItemSpawner.ItemsSpawned, entity);
                              end
                          end
                      end
                  end;
              end)
              
              return true;
          end
      end

 -- Leap --

function ENT:OnRangeAttack()
if not self:GetCooldown("Leap") then return end
if self:GetCooldown("Leap") == 0 then
self:SetCooldown("Leap", 8)
self:SetVelocity(self:GetUp()*100)
self:SetVelocity(self:GetForward()*600)
self:Jump(100)
end
end

  -- Init/Think --

function ENT:CustomInitialize()
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
        damage = 50,
        range = 150,
	      delay = 0.8,
        type = DMG_SLASH,
        viewpunch = Angle(20, math.random(-10, 10), 0),
      }, function(self, hit)
        force = Vector(1000, 1000, 1000)
        if #hit > 0 then
					self:EmitSound("leopard/attack.wav", 90)
				else self:EmitSound("bear/woosh1.wav", 80) end
      end)
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
