
function ENT:IsWaiting()
  return self:GetNW2Bool("DrGBaseWaiting")
end
function ENT:IsJumping()
  return self:GetNW2Bool("DrGBaseJumping")
end
function ENT:IsLeaping()
  return self:GetNW2Bool("DrGBaseLeaping")
end
function ENT:IsGliding()
  return self:GetNW2Bool("DrGBaseGliding")
end

if SERVER then

  -- Misc --

  function ENT:Wait(duration, callback)
    if duration <= 0 then return end
    if callback == nil then callback = function() end end
    self:SetNW2Bool("DrGBaseWaiting", true)
    local delay = CurTime() + duration
    local targetdelay = 0
    local now = CurTime()
    while CurTime() < delay do
      if self:IsPossessed() then break end
      if self:HasEnemy() then break end
      if callback(CurTime() - now) then break end
      self:YieldCoroutine(true)
    end
    self:SetNW2Bool("DrGBaseWaiting", false)
  end

  -- Jumps --

  local function LocoJump(self)
    local seq = self:GetSequence()
    local cycle = self:GetCycle()
    self.loco:Jump()
    self:ResetSequence(seq)
    self:SetCycle(cycle)
  end
  local function LocoJumpGap(self, pos)
    local seq = self:GetSequence()
    local cycle = self:GetCycle()
    self.loco:JumpAcrossGap(pos, self:GetForward())
    self:ResetSequence(seq)
    self:SetCycle(cycle)
  end

  function ENT:LeaveGround()
    if not self:IsOnGround() then return end
    local jumpHeight = self.loco:GetJumpHeight()
    self.loco:SetJumpHeight(1)
    LocoJump(self)
    self.loco:SetJumpHeight(jumpHeight)
  end

  function ENT:Jump(height, callback)
    if not self:IsOnGround() then return end
    if isnumber(height) then
      local jumpHeight = self.loco:GetJumpHeight()
      self.loco:SetJumpHeight(height*self:GetScale())
      LocoJump(self)
      self.loco:SetJumpHeight(jumpHeight)
    elseif isvector(height) then
      LocoJumpGap(self, height)
    else return self:Jump(self.loco:GetJumpHeight(), callback) end
    if not coroutine.running() then return end
    self:SetNW2Bool("DrGBaseJumping", true)
    local now = CurTime()
    while not self:IsOnGround() do
      if isfunction(callback) and
      callback(self, CurTime()-now) then break end
      self:YieldCoroutine(true)
    end
    self:SetNW2Bool("DrGBaseJumping", false)
  end

  local function CalcTrajectory(self, pos, speed)
    local dir, info = self:GetPos():DrG_CalcBallisticTrajectory(pos, {
      speed = speed, recursive = true
    })
    if dir.z <= 0 then
      dir, info = self:GetPos():DrG_CalcBallisticTrajectory(pos, {
        speed = speed, recursive = true, highest = true
      })
    end
    return dir, info
  end

  function ENT:Leap(pos, speed, callback)
    if not self:IsOnGround() then return end
    if not coroutine.running() then return end
    if isentity(pos) then
      local dir, info = CalcTrajectory(self, pos:GetPos(), speed)
      return self:Leap(pos:GetPos()+pos:GetVelocity()*info.duration, speed, callback)
    elseif isvector(pos) then
      if not isfunction(callback) then callback = function()
        self:FaceTowards(self:GetPos()+self:GetVelocity())
      end end
      local dir, info = CalcTrajectory(self, pos, speed)
      if self:TraceHull(dir:GetNormalized()).Hit then return false end
      local collided = NULL
      local now = CurTime()
      self:LeaveGround()
      if self:IsOnGround() then return false end
      self:SetNW2Bool("DrGBaseLeaping", true)
      while not self:IsOnGround() do
        local time = CurTime() - now
        local left = info.duration - time
        local hasCollided = IsValid(collided) or collided:IsWorld()
        if callback(self, left, hasCollided, collided) then break end
        if not hasCollided then
          local pos, vel = info.Predict(time)
          collided = self:TraceHull(info.Predict(time+engine.TickInterval())-self:GetPos()).Entity
          hasCollided = IsValid(collided) or collided:IsWorld()
          if not hasCollided then
            self:SetPos(pos)
            self:SetVelocity(vel)
          end
        end
        self:YieldCoroutine(true)
      end
      self:SetNW2Bool("DrGBaseLeaping", false)
      return not collided
    end
  end

  function ENT:Glide(dist, options, callback)
    if not coroutine.running() then return end
    options = options or {}
    options.speed = options.speed or self:GetSpeed()
    options.pitch = options.pitch or 15
    LocoJumpGap(self, self:GetPos() + self:GetForward()*dist)
    self:SetNW2Bool("DrGBaseGliding", true)
    local now = CurTime()
    while not self:IsOnGround() do
      if isfunction(callback) and
      callback(self, CurTime()-now) then break
      elseif self:GetVelocity().z <= 0 then
        local forward = self:GetForward()
        forward.z = -math.tan(math.rad(options.pitch))
        forward:Normalize()
        self.loco:SetVelocity(forward*options.speed*self:GetScale())
      end
      self:YieldCoroutine(true)
    end
    self:SetNW2Bool("DrGBaseGliding", false)
  end

end
