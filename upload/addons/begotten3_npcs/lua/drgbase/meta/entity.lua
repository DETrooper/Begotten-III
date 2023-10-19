
local entMETA = FindMetaTable("Entity")

-- Misc --

function entMETA:DrG_IsSanic()
  return self:IsNextBot() and
  self.OnReloaded ~= nil and
  self.GetNearestTarget ~= nil and
  self.AttackNearbyTargets ~= nil and
  self.IsHidingSpotFull ~= nil and
  self.GetNearestUsableHidingSpot ~= nil and
  self.ClaimHidingSpot ~= nil and
  self.AttemptJumpAtTarget ~= nil and
  self.LastPathingInfraction ~= nil and
  self.RecomputeTargetPath ~= nil and
  self.UnstickFromCeiling ~= nil
end

local DOORS = {
  ["prop_door_rotating"] = true,
  ["func_door"] = true,
  ["func_door_rotating"] = true
}
function entMETA:DrG_IsDoor()
  return DOORS[self:GetClass()] or false
end

function entMETA:DrG_AddListener(name, callback)
  if not isfunction(callback) then return false end
  local old_function = self[name]
  if not isfunction(old_function) then return false end
  self[name] = function(...)
    local res = callback(...)
    if res ~= nil then return res
    else return old_function(...) end
  end
  return true
end

function entMETA:DrG_SearchBone(searchBone)
  local lookup = self:LookupBone(searchBone)
  if lookup then return lookup end
  for boneId = 0, (self:GetBoneCount()-1) do
    local boneName = self:GetBoneName(boneId)
    if not boneName then return end
    if boneName == "__INVALIDBONE__" then continue end
    if string.find(string.lower(boneName), string.lower(searchBone)) then
      return boneId
    end
  end
end

-- Traces --

function entMETA:DrG_TraceLine(vec, data)
  if not isvector(vec) then vec = Vector(0, 0, 0) end
  local trdata = {}
  data = data or {}
  local center = self:OBBCenter()
  trdata.start = data.start or self:GetPos() + center
  trdata.endpos = data.endpos or trdata.start + vec
  trdata.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
  if self.IsDrGNextbot then
    if SERVER then trdata.mask = data.mask or self:GetSolidMask() end
    trdata.filter = data.filter or {self, self:GetWeapon(), self:GetPossessor()}
  else trdata.filter = data.filter or self end
  return util.DrG_TraceLine(trdata)
end
function entMETA:DrG_TraceHull(vec, data)
  if not isvector(vec) then vec = Vector(0, 0, 0) end
  local bound1, bound2 = self:GetCollisionBounds()
  if bound1.z < bound2.z then
    local temp = bound1
    bound1 = bound2
    bound2 = temp
  end
  local trdata = {}
  data = data or {}
  if self.IsDrGNextbot and data.step then
    bound2.z = self.loco:GetStepHeight()
  end
  trdata.start = data.start or self:GetPos()
  trdata.endpos = data.endpos or trdata.start + vec
  trdata.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
  if self.IsDrGNextbot then
    if SERVER then trdata.mask = data.mask or self:GetSolidMask() end
    trdata.filter = data.filter or {self, self:GetWeapon(), self:GetPossessor()}
  else trdata.filter = data.filter or self end
  trdata.maxs = data.maxs or bound1
  trdata.mins = data.mins or bound2
  return util.DrG_TraceHull(trdata)
end
function entMETA:DrG_TraceLineRadial(distance, precision, data)
  local traces = {}
  for i = 1, precision do
    local normal = self:GetForward()*distance
    normal:Rotate(Angle(0, i*(360/precision), 0))
    table.insert(traces, self:TraceLine(normal, data))
  end
  table.sort(traces, function(tr1, tr2)
    return self:GetRangeSquaredTo(tr1.HitPos) < self:GetRangeSquaredTo(tr2.HitPos)
  end)
  return traces
end
function entMETA:DrG_TraceHullRadial(distance, precision, data)
  local traces = {}
  for i = 1, precision do
    local normal = self:GetForward()*distance
    normal:Rotate(Angle(0, i*(360/precision), 0))
    table.insert(traces, self:TraceHull(normal, data))
  end
  table.sort(traces, function(tr1, tr2)
    return self:GetRangeSquaredTo(tr1.HitPos) < self:GetRangeSquaredTo(tr2.HitPos)
  end)
  return traces
end

-- Timers --

function entMETA:DrG_Timer(duration, callback, ...)
  timer.DrG_Simple(duration, function(...)
    if IsValid(self) then callback(self, ...) end
  end, ...)
end
function entMETA:DrG_LoopTimer(delay, callback, ...)
  timer.DrG_Loop(delay, function(...)
    if not IsValid(self) then return false end
    return callback(self, ...)
  end, ...)
end

if SERVER then

  -- Misc --

  function entMETA:DrG_RandomPos(min, max)
    if isnumber(max) then
      local dir = Vector(math.random(-100, 100), math.random(-100, 100), 0)
      dir = dir:GetNormalized()*math.random(min, max)
      local pos = self:GetPos()+dir
      if navmesh.IsLoaded() then
        local area = navmesh.GetNearestNavArea(pos)
        if IsValid(area) then
          return self:DrG_TraceHull(nil, {
            start = area:GetCenter(),
            endpos = area:GetClosestPointOnArea(pos),
            collisiongroup = COLLISION_GROUP_WORLD,
            step = true
          }).HitPos
        elseif util.IsInWorld(pos) then
          return self:DrG_TraceHull(Vector(0, 0, -999999), {
            collisiongroup = COLLISION_GROUP_WORLD, start = pos
          }).HitPos
        else return self:DrG_RandomPos(0, min) end
      elseif util.IsInWorld(pos) then
        return self:DrG_TraceHull(Vector(0, 0, -999999), {
          collisiongroup = COLLISION_GROUP_WORLD, start = pos
        }).HitPos
      else return self:DrG_RandomPos(min, max) end
    else return self:DrG_RandomPos(0, min) end
  end

  function entMETA:DrG_Dissolve(type)
    if self:IsFlagSet(FL_DISSOLVING) then return end
    local dissolver = ents.Create("env_entity_dissolver")
    if not IsValid(dissolver) then return false end
    if self:GetName() == "" then
      self:SetName("ent_"..self:GetClass().."_"..self:EntIndex().."_dissolved")
    end
    dissolver:SetKeyValue("dissolvetype", tostring(type or 0))
    dissolver:Fire("dissolve", self:GetName())
    dissolver:Remove()
    return true
  end

  function entMETA:DrG_DeathNotice(attacker, inflictor)
    if self:IsPlayer() then
      hook.Run("PlayerDeath", self, inflictor, attacker)
    else hook.Run("OnNPCKilled", self, attacker, inflictor) end
  end

  function entMETA:DrG_CreateRagdoll(dmg)
    if not util.IsValidRagdoll(self:GetModel()) then return NULL end
    local ragdoll = ents.Create("prop_ragdoll")
    if IsValid(ragdoll) then
      if not dmg then dmg = DamageInfo() end
      ragdoll:SetPos(self:GetPos())
      ragdoll:SetAngles(self:GetAngles())
      ragdoll:SetModel(self:GetModel())
      ragdoll:SetSkin(self:GetSkin())
      ragdoll:SetColor(self:GetColor())
      ragdoll:SetModelScale(self:GetModelScale())
      ragdoll:SetBloodColor(self:GetBloodColor())	  	  ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
      for i = 1, #self:GetBodyGroups() do
        ragdoll:SetBodygroup(i-1, self:GetBodygroup(i-1))
      end
      ragdoll:Spawn()
      for i = 0, (ragdoll:GetPhysicsObjectCount()-1) do
        local bone = ragdoll:GetPhysicsObjectNum(i)
        if not IsValid(bone) then continue end
        local pos, angles = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
        bone:SetPos(pos)
        bone:SetAngles(angles)
      end
      local phys = ragdoll:GetPhysicsObject()
      phys:SetVelocity(self:GetVelocity())
      local force = dmg:GetDamageForce()
      local position = dmg:GetDamagePosition()
      if IsValid(phys) and isvector(force) and isvector(position) then
        phys:ApplyForceOffset(force, position)
      end
      if dmg:IsDamageType(DMG_DISSOLVE) then ragdoll:DrG_Dissolve()
      elseif self:IsOnFire() then ragdoll:Ignite(10) end
      local attacker = dmg:GetAttacker()
      if IsValid(attacker) and attacker.IsDrGNextbot then
        attacker:SpotEntity(ragdoll)
      end
      ragdoll.EntityClass = self:GetClass()
      return ragdoll
    else return NULL end
  end
  function entMETA:DrG_RagdollDeath(dmg)
    if self:IsPlayer() then
      if not self:Alive() then return NULL end
      self:KillSilent()
    else
      self:AddFlags(FL_TRANSRAGDOLL)
      self:Remove()
    end
    if dmg then self:DrG_DeathNotice(dmg:GetAttacker(), dmg:GetInflictor()) end
    local ragdoll = self:DrG_CreateRagdoll(dmg)
    if not self:IsPlayer() and IsValid(ragdoll) then
      undo.ReplaceEntity(self, ragdoll)
      cleanup.ReplaceEntity(self, ragdoll)
    end
    return ragdoll
  end

  function entMETA:DrG_AimAt(target, speed, feet)
    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end
    local dir, info = phys:DrG_AimAt(target, speed, feet)
    if dir:IsZero() then
      local owner = self:GetOwner()
      if IsValid(owner) then
        return self:DrG_AimAt(self:GetPos()+owner:GetForward()*speed, speed)
      else return self:DrG_AimAt(self:GetPos()+self:GetForward()*speed, speed) end
    else return dir, info end
  end
  function entMETA:DrG_ThrowAt(target, options, feet)
    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end
    local dir, info = phys:DrG_ThrowAt(target, options, feet)
    if dir:IsZero() then
      local speed = options.magnitude or 1000
      local owner = self:GetOwner()
      if IsValid(owner) then
        return self:DrG_ThrowAt(self:GetPos()+owner:GetForward()*speed, options)
      else return self:DrG_ThrowAt(self:GetPos()+self:GetForward()*speed, options) end
    else return dir, info end
  end

  -- Effects --

  function entMETA:DrG_ParticleEffect(effect, ...)
    local root = {parent = self}
    local args, n = table.DrG_Pack(...)
    if n > 0 then
      local data = root
      for i = 1, n do
        local arg = args[i]
        if i == 1 and isstring(arg) then
          root.attachment = arg
        elseif isentity(arg) and IsValid(arg) then
          data.cpoints = {{parent = arg}}
          if isstring(args[i+1]) then
            data.cpoints[1].attachment = args[i+1]
          end
          data = data.cpoints[1]
        elseif isvector(arg) then
          data.cpoints = {{pos = arg}}
          data = data.cpoints[1]
        else continue end
      end
      if data ~= root then
        data.active = false
      end
    end
    return DrGBase.ParticleEffect(effect, root)
  end

  function entMETA:DrG_DynamicLight(color, radius, brightness, style, attachment)
    if color == nil then color = Color(255, 255, 255) end
    if not isnumber(radius) then radius = 1000 end
    radius = math.Clamp(radius, 0, math.huge)
    if not isnumber(brightness) then brightness = 1 end
    brightness = math.Clamp(brightness, 0, math.huge)
    local light = ents.Create("light_dynamic")
  	light:SetKeyValue("brightness", tostring(brightness))
  	light:SetKeyValue("distance", tostring(radius))
    if isstring(style) then
      light:SetKeyValue("style", tostring(style))
    end
    light:Fire("Color", tostring(color.r).." "..tostring(color.g).." "..tostring(color.b))
  	light:SetLocalPos(self:GetPos())
  	light:SetParent(self)
    if isstring(attachment) then
      light:Fire("setparentattachment", attachment)
    end
  	light:Spawn()
  	light:Activate()
  	light:Fire("TurnOn", "", 0)
  	self:DeleteOnRemove(light)
    return light
  end

else

  -- Effects --

  function entMETA:DrG_DynamicLight(color, radius, brightness, style, attachment)
    if color == nil then color = Color(255, 255, 255) end
    if not isnumber(radius) then radius = 1000 end
    radius = math.Clamp(radius, 0, math.huge)
    if not isnumber(brightness) then brightness = 1 end
    brightness = math.Clamp(brightness, 0, math.huge)
    local light = DynamicLight(self:EntIndex())
    light.r = color.r
    light.g = color.g
    light.b = color.b
    light.size = radius
    light.brightness = brightness
    light.style = style
    light.dieTime = CurTime() + 1
    light.decay = 100000
    if attachment then
      if isstring(attachment) then
        attachment = self:LookupAttachment(attachment)
      end
      if isnumber(attachment) and attachment > 0 then
        light.pos = self:GetAttachment(attachment).Pos
      else light.pos = self:GetPos() end
    else light.pos = self:GetPos() end
    return light
  end

end
