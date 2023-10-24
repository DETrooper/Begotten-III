ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.IsDrGEntity = true
ENT.IsDrGNextbot = true

-- Misc --
ENT.PrintName = "Template"
ENT.Category = "Other"
ENT.Models = {"models/player/kleiner.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1
ENT.CollisionBounds = Vector(10, 10, 72)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true

-- Stats --
DrGBase.IncludeFile("status.lua")
ENT.SpawnHealth = 100
ENT.HealthRegen = 0
ENT.MinPhysDamage = 10
ENT.MinFallDamage = 10

-- AI --
DrGBase.IncludeFile("ai.lua")
DrGBase.IncludeFile("patrol.lua")
ENT.BehaviourType = AI_BEHAV_BASE
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0
ENT.AvoidAfraidOfRange = 500
ENT.WatchAfraidOfRange = 750

-- Relationships --
DrGBase.IncludeFile("relationships.lua")
ENT.DefaultRelationship = D_NU
ENT.Factions = {}
ENT.Frightening = false
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Detection --
DrGBase.IncludeFile("awareness.lua")
DrGBase.IncludeFile("detection.lua")
ENT.EyeBone = ""
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 150
ENT.SightRange = 15000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Locomotion --
DrGBase.IncludeFile("locomotion.lua")
DrGBase.IncludeFile("path.lua")
ENT.Acceleration = 1000
ENT.Deceleration = 1000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200

-- Movements --
DrGBase.IncludeFile("movements.lua")
ENT.UseWalkframes = false
ENT.WalkSpeed = 100
ENT.RunSpeed = 200

-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = false
ENT.ClimbLadders = false
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Animations --
DrGBase.IncludeFile("animations.lua")
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1

-- Sounds --
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {}
ENT.OnDownedSounds = {}
ENT.Footsteps = {}

-- Weapons --
DrGBase.IncludeFile("weapons.lua")
ENT.UseWeapons = false
ENT.Weapons = {}
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = true

-- Possession --
DrGBase.IncludeFile("possession.lua")
ENT.PossessionEnabled = false
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_1DIR
ENT.PossessionViews = {}
ENT.PossessionBinds = {}

-- Misc --
DrGBase.IncludeFile("drgbase/entity_helpers.lua")
DrGBase.IncludeFile("behaviours.lua")
DrGBase.IncludeFile("hooks.lua")
DrGBase.IncludeFile("misc.lua")

-- Convars --
local MultHealth = CreateConVar("drgbase_multiplier_health", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local EnablePatrol = CreateConVar("drgbase_ai_patrol", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Initialize --
function ENT:Initialize()
  if SERVER then
    if istable(self.Models) and #self.Models > 0 then
      self:SetModel(self.Models[math.random(#self.Models)])
    end
    if istable(self.ModelScale) and #self.ModelScale == 2 then
      self:SetModelScale(self.ModelScale[math.random(2)])
    elseif isnumber(self.ModelScale) then
      self:SetModelScale(self.ModelScale)
    end
    if istable(self.Skins) and #self.Skins > 0 then
      self:SetSkin(self.Skins[math.random(#self.Skins)])
    elseif isnumber(self.Skins) then
      self:SetSkin(self.Skins)
    end
    self:SetNW2Int("DrGBaseMaxHealth", self.SpawnHealth)
    self:SetNW2Int("DrGBaseHealth", self.SpawnHealth)
    self:SetMaxHealth(self.SpawnHealth)
    self:SetHealth(self.SpawnHealth)
    self:ScaleHealth(MultHealth:GetFloat())
    self:SetHealthRegen(self.HealthRegen)
    self:SetBloodColor(self.BloodColor)
    self:SetCollisionGroup(COLLISION_GROUP_NPC)
    if isvector(self.CollisionBounds) then
      self:SetCollisionBounds(
        Vector(self.CollisionBounds.x, self.CollisionBounds.y, self.CollisionBounds.z),
        Vector(-self.CollisionBounds.x, -self.CollisionBounds.y, 0)
      )
    else self:SetCollisionBounds(self:GetModelBounds()) end
    self:SetUseType(SIMPLE_USE)
    self.VJ_AddEntityToSNPCAttackList = true
    self.vFireIsCharacter = true
    self._DrGBaseCorReacts = {}
    self._DrGBaseCorCalls = {}
    self._DrGBaseWaterLevel = self:WaterLevel()
    self._DrGBaseDownSpeed = 0
    self:SetName("drgbase_nextbot_"..self:GetCreationID())
    self:PhysicsInitShadow()
    self:AddCallback("PhysicsCollide", function(self, data)
      self:_HandleCollide(data, self:GetPhysicsObject())
    end)
  else self:SetIK(true) end
  self:AddFlags(FL_OBJECT + FL_NPC)
  self._DrGBaseBaseThinkDelay = 0
  self._DrGBaseCustomThinkDelay = 0
  self._DrGBasePossessionThinkDelay = 0
  self._DrGBaseThinkDelayLong = 0
  self._DrGBaseThinkDelayMedium = 0
  self._DrGBaseThinkDelayShort = 0
  self:_InitModules()
  table.insert(DrGBase._SpawnedNextbots, self)
  self:CallOnRemove("DrGBaseCallOnRemove", function(self)
    table.RemoveByValue(DrGBase._SpawnedNextbots, self)
    if isstring(self._DrGBaseIdleSound) then self:StopSound(self._DrGBaseIdleSound) end
    if SERVER and self:IsPossessed() then self:Dispossess() end
  end)
  self:_BaseInitialize()
  self:CustomInitialize()
  if SERVER then
    self._DrGBaseRelationshipReady = true
    self:UpdateRelationships()
    self:UpdateAnimation()
    self:UpdateSpeed()
    self:UpdateAI()
  end
end
function ENT:_BaseInitialize() end
function ENT:CustomInitialize() end
function ENT:_InitModules()
  if SERVER then
    self:_InitLocomotion()
    self:_InitPath()
  end
  self:_InitHooks()
  self:_InitMisc()
  self:_InitAnimations()
  self:_InitMovements()
  self:_InitWeapons()
  self:_InitPossession()
  self:_InitRelationships()
  self:_InitAwareness()
  self:_InitDetection()
  self:_InitPatrol()
  self:_InitAI()
end

-- Think --
function ENT:Think()
  self:_HandleAnimations()
  self:_HandleMovements()
  if SERVER then
    -- long delays
    if CurTime() > self._DrGBaseThinkDelayLong then
      self._DrGBaseThinkDelayLong = CurTime() + 1
      self:_RegenHealth()
      self:UpdateAI()
    end
    -- medium delays
    if CurTime() > self._DrGBaseThinkDelayMedium then
      self._DrGBaseThinkDelayMedium = CurTime() + 0.1
      self:UpdateAnimation()
      self:UpdateSpeed()
      -- update phys obj
      local phys = self:GetPhysicsObject()
      if IsValid(phys) then
        if self:WaterLevel() == 0 then
          phys:SetPos(self:GetPos())
          phys:SetAngles(self:GetAngles())
        else
          phys:UpdateShadow(self:GetPos(), self:GetAngles(), 0)
        end
      end
    end
    -- short delays
    if CurTime() > self._DrGBaseThinkDelayShort then
      self._DrGBaseThinkDelayShort = CurTime() + 0.05
      -- water level
      local waterLevel = self:WaterLevel()
      if self._DrGBaseWaterLevel ~= waterLevel then
        self:OnWaterLevelChange(self._DrGBaseWaterLevel, waterLevel)
        self._DrGBaseWaterLevel = waterLevel
      end
      -- on fire
      if self._DrGBaseIsOnFire and not self:IsOnFire() then
        self:OnExtinguish()
      end
      self._DrGBaseIsOnFire = self:IsOnFire()
      -- update fall speed
      local speed = -self:GetVelocity().z
      self:Timer(0.1, function()
        self._DrGBaseDownSpeed = speed
      end)
    end
  end
  -- idle sounds
  if #self.OnIdleSounds > 0 then
    if (SERVER and not self.ClientIdleSounds) or
    (CLIENT and self.ClientIdleSounds) then
      local sound = self.OnIdleSounds[math.random(#self.OnIdleSounds)]
      if self:EmitSlotSound("DrGBaseIdleSounds", SoundDuration(sound) + self.IdleSoundDelay, sound) then
        self._DrGBaseIdleSound = sound
      end
    end
  end
  -- custom thinks
  if CurTime() > self._DrGBaseBaseThinkDelay then
    local delay = self:_BaseThink() or 0
    self._DrGBaseBaseThinkDelay = CurTime() + delay
  end
  if CurTime() > self._DrGBaseCustomThinkDelay then
    local delay = self:CustomThink() or 0
    self._DrGBaseCustomThinkDelay = CurTime() + delay
  end
  if self:IsPossessed() and (SERVER or self:IsPossessedByLocalPlayer()) then
    local possessor = self:GetPossessor()
    if SERVER then possessor:SetPos(self:GetPos()) end
    possessor:SetKeyValue("waterlevel", self:WaterLevel())
    self:_HandlePossession(false)
    if CurTime() > self._DrGBasePossessionThinkDelay then
      local delay = self:PossessionThink(possessor) or 0
      self._DrGBasePossessionThinkDelay = CurTime() + delay
    end
  end
end
function ENT:_BaseThink() end
function ENT:CustomThink() end
function ENT:PossessionThink() end

if SERVER then
  AddCSLuaFile()

  -- Sandbox support --

  hook.Add("PlayerSpawnedNPC", "DrGBasePlayerSpawnedNPC", function(ply, ent)
    if not ent.IsDrGNextbot then return end
    ent:SetCreator(ply)
    if ent:SpawnedBy(ply) ~= false then
      if not navmesh.IsLoaded() and tobool(ply:GetInfoNum("drgbase_navmesh_error", 1)) then
        local msg = "Nextbots need a navmesh to navigate around the map. "
        if game.SinglePlayer() then msg = msg.."You can generate a navmesh using the command 'nav_generate' in the console."
        else msg = msg.."If you are the server owner you can generate a navmesh using the command 'nav_generate' in the server console." end
        DrGBase.Error(msg.."\nSet 'drgbase_navmesh_error' to 0 to disable this message.", {player = ply, color = DrGBase.CLR_GREEN, chat = true})
      end
    else ent:Remove() end
  end)
  function ENT:SpawnedBy() end

  -- Coroutine --

  function ENT:ReactInCoroutine(callback, ...)
    local args, n = table.DrG_Pack(...)
    table.insert(self._DrGBaseCorReacts, function(self)
      callback(self, table.DrG_Unpack(args, n))
    end)
  end
  function ENT:CallInCoroutine(callback, ...)
    local args, n = table.DrG_Pack(...)
    if n > 0 then
      table.insert(self._DrGBaseCorCalls, function(self)
        callback(self, table.DrG_Unpack(args, n))
      end)
    else
      local now = CurTime()
      table.insert(self._DrGBaseCorCalls, function(self)
        callback(self, CurTime() - now)
      end)
    end
  end

  function ENT:YieldCoroutine(interrompt)
    if interrompt then
      repeat
        if not self._DrGBaseCorReacting then
          if #self._DrGBaseCorReacts > 0 then
            self._DrGBaseCorReacting = true
            while #self._DrGBaseCorReacts > 0 do
              table.remove(self._DrGBaseCorReacts, 1)(self)
            end
            self._DrGBaseCorReacting = false
          elseif #self._DrGBaseCorCalls > 0 and
          not self._DrGBaseCorCalling then
            self._DrGBaseCorCalling = true
            while #self._DrGBaseCorCalls > 0 do
              table.remove(self._DrGBaseCorCalls, 1)(self)
            end
            self._DrGBaseCorCalling = false
          end
        else self._DrGBaseCorReacts = {} end
        coroutine.yield()
      until not self:IsAIDisabled() or self:IsPossessed() or self._DrGBaseCorReacting
    else
      self._DrGBaseCorReacts = {}
      coroutine.yield()
    end
  end
  function ENT:PauseCoroutine(duration, interrompt)
    if isnumber(duration) then
      if duration <= 0 then return end
      local now = CurTime()
      while CurTime() < now + duration do
        self:YieldCoroutine(interrompt)
      end
    else
      self._DrGBaseResumeCoroutine = false
      while not self._DrGBaseResumeCoroutine do
        self:YieldCoroutine(interrompt)
      end
      self._DrGBaseResumeCoroutine = nil
    end
  end
  function ENT:ResumeCoroutine()
    if self._DrGBaseResumeCoroutine ~= false then return end
    self._DrGBaseResumeCoroutine = true
  end

  function ENT:BehaveStart()
    if self.BehaveThread then return end
    self.BehaveThread = coroutine.create(function()
      if not self._DrGBaseSpawned then
        self._DrGBaseSpawned = true
        if #self.OnSpawnSounds > 0 then
          self:EmitSound(self.OnSpawnSounds[math.random(#self.OnSpawnSounds)])
        end
        self:OnSpawn()
      end
      while true do
        if self:IsPossessed() then
          self:_HandlePossession(true)
        elseif not self:IsAIDisabled() then
          if self.BehaviourType ~= AI_BEHAV_CUSTOM then
            if self:HasEnemy() then self:HandleEnemy()
            elseif self:HadEnemy() then self:UpdateEnemy()
            elseif self:HasPatrol() then self:Patrol()
            else self:OnIdle() end
          else self:AIBehaviour() end
        end
        self:YieldCoroutine(true)
      end
    end)
  end
  function ENT:BehaveUpdate()
  	if not self.BehaveThread then return end
  	if coroutine.status(self.BehaveThread) ~= "dead" then
      local ok, args = coroutine.resume(self.BehaveThread)
    	if not ok then
    		self.BehaveThread = nil
        if not self:OnError(args) then
          ErrorNoHalt(self, " Error: ", args, "\n")
        else self:BehaveStart() end
    	end
  	else self.BehaveThread = nil end
  end

  -- Net --

  function ENT:_HandleNetMessage(name, ply, ...) end

  -- Hooks --

  function ENT:OnSpawn() end
  function ENT:OnError() end

  function ENT:OnHealthChange() end
  function ENT:OnExtinguish() end
  function ENT:OnWaterLevelChange() end

  -- SLVBase compatibility --
  if file.Exists("autorun/slvbase", "LUA") then
    function ENT:PercentageFrozen() return 0 end
  end

  -- AI Behaviour --

  function ENT:AIBehaviour() end

  function ENT:HandleEnemy()
    local enemy = self:GetEnemy()
    local relationship = self:GetRelationship(enemy)
    if relationship == D_HT then
      local visible = self:Visible(enemy)
      if not self:IsInRange(enemy, self.ReachEnemyRange) or not visible then
        if self:OnChaseEnemy(enemy) ~= true then
          if self:FollowPath(enemy) == "unreachable" then
            self:OnEnemyUnreachable(enemy)
          end
        end
      elseif self:IsInRange(enemy, self.AvoidEnemyRange) and visible and
      not self:IsInRange(enemy, self.ReachEnemyRange) then
        if self:OnAvoidEnemy(enemy) ~= true then
          self:FollowPath(self:GetPos():DrG_Away(enemy:GetPos()))
        end
      elseif self:OnIdleEnemy(enemy) ~= true then self:FaceTowards(enemy) end
      if IsValid(enemy) and self:Visible(enemy) then self:AttackEntity(enemy) end
    elseif relationship == D_FR then
      local visible = self:Visible(enemy)
      if self:IsInRange(enemy, self.AvoidAfraidOfRange) and visible then
        if self:OnAvoidAfraidOf(enemy) ~= true then
          self:FollowPath(self:GetPos():DrG_Away(enemy:GetPos()))
        end
      elseif self:OnIdleAfraidOf(enemy) ~= true then self:FaceTowards(enemy) end
      if IsValid(enemy) and self:Visible(enemy) then self:AttackEntity(enemy) end
    elseif relationship == D_LI then self:OnAllyEnemy(enemy)
    elseif relationship == D_NU then self:OnNeutralEnemy(enemy) end
  end

  function ENT:AttackEntity(ent)
    local weapon = self:GetWeapon()
    if self.BehaviourType == AI_BEHAV_HUMAN and self:HasWeapon() then
      if weapon.DrGBase_Melee or string.find(weapon:GetHoldType(), "melee") then
        if self:IsInRange(ent, self.ReachEnemyRange) then
          if self:OnMeleeAttack(ent, weapon) ~= true and self.IsDrGNextbotHuman then
            self:FaceTowards(ent)
            -- todo: melee code
          end
        end
      elseif self:IsInRange(ent, self.RangeAttackRange) then
        if self:OnRangeAttack(ent, weapon) ~= true and self.IsDrGNextbotHuman then
          if self:IsMoving() then
            self:FaceTowards(ent)
            self:FaceTowards(ent)
          end
          if self:IsWeaponPrimaryEmpty() then
            self:Reload()
          elseif self:IsInSight(ent) then
            local shootPos = self:GetShootPos()
            local tr = util.DrG_TraceHull({
              start = shootPos, endpos = shootPos + self:GetAimVector()*99999,
              mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 5),
              filter = {self, self:GetWeapon(), self:GetPossessor()}
            })
            if tr.Entity == ent then
              local class = weapon:GetClass()
              if class == "weapon_shotgun" and
              weapon:Clip1() >= 2 and math.random(3) == 1 then
                self:SecondaryFire()
              else self:PrimaryFire() end
            end
          end
        end
      end
    elseif self:IsInRange(ent, self.ReachEnemyRange) and !ent.cwObserverMode and
    self:OnMeleeAttack(ent, weapon) ~= false then
    elseif self:IsInRange(ent, self.RangeAttackRange) and !ent.cwObserverMode then
      self:OnRangeAttack(ent, weapon)
    end
  end

  function ENT:Patrol()
    if not EnablePatrol:GetBool() then return end
    if not self:HasPatrol() then return end
    local patrol = self:GetPatrol()
    local pos = patrol:FetchPos(self)
    local res = self:OnPatrolling(pos, patrol)
    if not isbool(res) then
      local follow = self:FollowPath(pos)
      if follow == "unreachable" then res = false
      elseif follow == "reached" then res = true end
    end
    if isbool(res) then
      self:RemovePatrol(patrol)
      if res then
        patrol:OnReached(self, pos)
        self:OnReachedPatrol(pos, patrol)
      else
        patrol:OnUnreachable(self, pos)
        self:OnPatrolUnreachable(pos, patrol)
      end
    end
  end

else

  local NavmeshMessage = CreateClientConVar("drgbase_navmesh_error", "1", true, true)

  -- Net --

  function ENT:_HandleNetMessage(name, ...)
    local args, n = table.DrG_Pack(...)
    if name == "DrGBasePickupWeapon" then
      local weapon = args[1]
      if not IsValid(weapon) then return end
      self._DrGBaseWeapons[weapon:GetClass()] = weapon
      self:OnPickupWeapon(weapon, weapon:GetClass())
      return true
    elseif name == "DrGBaseDropWeapon" then
      local class = args[1]
      self._DrGBaseWeapons[class] = nil
      self:OnDropWeapon(NULL, class)
      return true
    end
  end

  -- Draw --

  local DisplayCollisions = CreateClientConVar("drgbase_display_collisions", "0")
  local DisplaySight = CreateClientConVar("drgbase_display_sight", "0")

  function ENT:Draw()
    if DrGBase.INFO_TOOL and DrGBase.INFO_TOOL.Viewcam then
      local selected = LocalPlayer():DrG_GetSelectedEntities()[1]
      if selected == self then return end
    end
    if self:ShouldDraw() then
      self:DrawModel()
      self:_BaseDraw()
      self:CustomDraw()
    end
    self:_DrawDebug()
    if self:IsPossessedByLocalPlayer() then
      self:PossessionDraw()
    end
  end
  function ENT:_BaseDraw() end
  function ENT:CustomDraw() end
  function ENT:PossessionDraw() end
  function ENT:ShouldDraw() return true end

  function ENT:_DrawDebug()
    if not GetConVar("developer"):GetBool() then return end
    if DisplayCollisions:GetBool() then
      local bound1, bound2 = self:GetCollisionBounds()
      local center = self:GetPos() + self:OBBCenter()
      render.DrawWireframeBox(self:GetPos(), Angle(0, 0, 0), bound1, bound2, DrGBase.CLR_WHITE, false)
      render.DrawLine(center, center + self:GetVelocity(), DrGBase.CLR_ORANGE, false)
      render.DrawWireframeSphere(center, 2*self:GetScale(), 4, 4, DrGBase.CLR_ORANGE, false)
    end
    if DisplaySight:GetBool() then
       local eyepos = self:EyePos()
       local color = self:WasInSight(LocalPlayer()) and DrGBase.CLR_GREEN or DrGBase.CLR_RED
       if self:IsPossessedByLocalPlayer() then color = DrGBase.CLR_ORANGE end
       render.DrawWireframeSphere(eyepos, 2*self:GetScale(), 4, 4, color, false)
       render.DrawLine(eyepos, eyepos + self:EyeAngles():Forward()*15, color, false)
    end
  end

end
