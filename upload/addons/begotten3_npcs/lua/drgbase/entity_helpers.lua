if not istable(ENT) then return end

-- Print --

function ENT:PrintPoseParameters()
  for i = 0, (self:GetNumPoseParameters()-1) do
  	local min, max = self:GetPoseParameterRange(i)
  	print(self:GetPoseParameterName(i).." "..min.." / "..max)
  end
end
function ENT:PrintAnimations()
  for i, seq in pairs(self:GetSequenceList()) do
    local act = self:GetSequenceActivity(i)
    if act ~= -1 then
      print(i.." => "..seq.." / "..act.." => "..self:GetSequenceActivityName(i))
    else
      print(i.." => "..seq.." / -1")
    end
  end
end
function ENT:PrintBones()
  for i = 0, (self:GetBoneCount()-1) do
    local bonename = self:GetBoneName(i)
    if bonename == nil then continue end
    print(i.." => "..bonename)
  end
end
function ENT:PrintAttachments()
  for i, attach in ipairs(self:GetAttachments()) do
    print(attach.id.." => "..attach.name)
  end
end
function ENT:PrintBodygroups()
  for i, group in ipairs(self:GetBodyGroups()) do
    print(group.id.." => "..group.name.." ("..group.num.." subgroups)")
  end
end

-- Timers --

function ENT:Timer(...)
  return self:DrG_Timer(...)
end
function ENT:LoopTimer(...)
  return self:DrG_LoopTimer(...)
end

-- Traces --

function ENT:TraceLine(vec, data)
  return self:DrG_TraceLine(vec, data)
end
function ENT:TraceHull(vec, data)
  return self:DrG_TraceHull(vec, data)
end
function ENT:TraceLineRadial(distance, precision, data)
  return self:DrG_TraceLineRadial(distance, precision, data)
end
function ENT:TraceHullRadial(distance, precision, data)
  return self:DrG_TraceHullRadial(distance, precision, data)
end

-- Misc --

function ENT:ScreenShake(amplitude, frequency, duration, radius)
  return util.ScreenShake(self:GetPos(), amplitude, frequency, duration, radius)
end

function ENT:GetCooldown(name)
  local delay = self:GetNW2Float("DrGBaseCooldowns/"..tostring(name), false)
  if delay ~= false then
    return math.Clamp(delay - CurTime(), 0, math.huge)
  else return 0 end
end

--[[function ENT:GetScale()
  return self:GetModelScale()
end
function ENT:SetScale(scale)
  return self:SetModelScale(scale)
end
function ENT:Scale(scale)
  return self:SetModelScale(self:GetModelScale()*scale)
end]]

-- Net --

function ENT:NetMessage(name, ...)
  return net.DrG_Send("DrGBaseEntMessage", name, self, ...)
end
function ENT:_HandleNetMessage() end
function ENT:OnNetMessage() end

if SERVER then
  AddCSLuaFile()

  -- Misc --

  function ENT:RandomPos(min, max)
    return self:DrG_RandomPos(min, max)
  end

  function ENT:SetCooldown(name, delay)
    self:SetNW2Float("DrGBaseCooldowns/"..tostring(name), CurTime() + delay)
  end

  function ENT:PushEntity(ent, force)
    if istable(ent) then
      local vecs = {}
      for i, en in ipairs(ent) do
        if not IsValid(en) then continue end
        vecs[en:EntIndex()] = self:PushEntity(en, force)
      end
      return vecs
    elseif isentity(ent) and IsValid(ent) then
      local direction = self:GetPos():DrG_Direction(ent:GetPos())
      local forward = direction
      forward.z = 0
      forward:Normalize()
      local right = Vector()
      right:Set(forward)
      right:Rotate(Angle(0, -90, 0))
      local up = Vector(0, 0, 1)
      local vec = forward*force.x + right*force.y + up*force.z
      local phys = ent:GetPhysicsObject()
      if ent.IsDrGNextbot then
        ent:LeaveGround()
        ent:SetVelocity(ent:GetVelocity()+vec)
      elseif ent.Type == "nextbot" then
        local jumpHeight = ent.loco:GetJumpHeight()
        ent.loco:SetJumpHeight(1)
        ent.loco:Jump()
        ent.loco:SetJumpHeight(jumpHeight)
        ent.loco:SetVelocity(ent.loco:GetVelocity()+vec)
      elseif IsValid(phys) and not ent:IsPlayer() then
        phys:AddVelocity(vec)
      else ent:SetVelocity(ent:GetVelocity()+vec) end
      return vec
    end
  end

  -- Net --

  net.DrG_Receive("DrGBaseEntMessage", function(ply, name, self, ...)
    if not IsValid(self) then return end
    if not self.IsDrGEntity then return end
    if not self:_HandleNetMessage(name, ply, ...) then
      self:OnNetMessage(name, ply, ...)
    end
  end)
  function ENT:CallOnClient(name, ...)
    if not isstring(name) then return end
    return self:NetMessage("DrGBaseCallOnClient", name, ...)
  end

  function ENT:NetCallback(name, callback, ply, ...)
    if not isfunction(callback) then return end
    if not ply:IsPlayer() then return end
    return ply:DrG_NetCallback(name, function(...)
      if IsValid(self) then callback(self, ...) end
    end, self, ...)
  end

  -- Effects --

  function ENT:ParticleEffect(effect, ...)
    return self:DrG_ParticleEffect(effect, ...)
  end
  function ENT:DynamicLight(color, radius, brightness, style, attachment)
    return self:DrG_DynamicLight(color, radius, brightness, style, attachment)
  end

else

  -- Net --

  local function ReceiveMessage(name, self, ...)
    if not IsValid(self) then return end
    if isfunction(self._HandleNetMessage) and isfunction(self.OnNetMessage) then
      if name == "DrGBaseCallOnClient" then
        local args, n = table.DrG_Pack(...)
        local functionName = table.remove(args, 1)
        if isfunction(self[functionName]) then
          self[functionName](self, table.DrG_Unpack(args, n-1))
        end
      elseif not self:_HandleNetMessage(name, ...) then self:OnNetMessage(name, ...) end
    else timer.DrG_Simple(engine.TickInterval(), ReceiveMessage, name, self, ...) end
  end
  net.DrG_Receive("DrGBaseEntMessage", ReceiveMessage)
  function ENT:NetCallback(name, callback, ...)
    if not isfunction(callback) then return end
    return net.DrG_UseCallback(name, function(...)
      if IsValid(self) then callback(self, ...) end
    end, self, ...)
  end

  -- Effects --

  function ENT:DynamicLight(color, radius, brightness, style, attachment)
    return self:DrG_DynamicLight(color, radius, brightness, style, attachment)
  end

end
