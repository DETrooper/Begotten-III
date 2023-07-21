
-- Convars --

local DebugAnims = CreateConVar("drgbase_debug_animations", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Getters/setters --

function ENT:GetAnimInfoSequence(seq)
  if isstring(seq) then seq = self:LookupSequence(seq)
  elseif not isnumber(seq) then return {} end
  if seq == -1 then return {} end
  local seqName = self:GetSequenceName(seq)
  local seqInfo = self:GetSequenceInfo(seq)
  for i, anim in ipairs(seqInfo.anims) do
    local info = self:GetAnimInfo(anim)
    if info.label == "@"..seqName or info.label == "a_"..seqName then
      return info
    end
  end
end

function ENT:GetActivityIDFromName(name)
  if isnumber(self._DrGBaseActIDsFromNames[name]) then
    return self._DrGBaseActIDsFromNames[name]
  else
    for i in pairs(self:GetSequenceList()) do
      if self:GetSequenceActivityName(i) == name then
        local id = self:GetSequenceActivity(i)
        self._DrGBaseActIDsFromNames[name] = id
        return id
      end
    end
    self._DrGBaseActIDsFromNames[name] = ACT_INVALID
    return ACT_INVALID
  end
end

-- Functions --

function ENT:SelectRandomSequence(anim)
  return self:SelectWeightedSequenceSeeded(anim, math.random(0, 255))
end

function ENT:SequenceEvent(seq, cycles, callback, ...)
  if istable(seq) then
    for i, se in ipairs(seq) do
      self:SequenceEvent(se, cycles, callback)
    end
  elseif isstring(seq) then seq = self:LookupSequence(seq)
  elseif not isnumber(seq) then return end
  if seq == -1 then return end
  self._DrGBaseSequenceEvents[seq] = self._DrGBaseSequenceEvents[seq] or {}
  local event = self._DrGBaseSequenceEvents[seq]
  if isnumber(cycles) then cycles = {cycles} end
  local args, n = table.DrG_Pack(...)
  for i, cycle in ipairs(cycles) do
    event[cycle] = event[cycle] or {}
    table.insert(event[cycle], {
      callback = callback, args = args, n = n
    })
  end
end
function ENT:ClearSequenceEvents(seq)
  if istable(seq) then
    for i, se in ipairs(seq) do self:ClearSequenceEvents(se) end
  elseif isstring(seq) or isnumber(seq) then
    if isstring(seq) then seq = self:LookupSequence(seq)
    elseif not isnumber(seq) then return end
    self._DrGBaseSequenceEvents[seq] = nil
  else self._DrGBaseSequenceEvents = {} end
end

function ENT:AddAnimEvent(seq, frames, event)
  if istable(seq) then
    for i, se in ipairs(seq) do self:AddAnimEvent(se, frames, event) end
  elseif isstring(seq) then seq = self:LookupSequence(seq)
  elseif not isnumber(seq) then return end
  if seq == -1 then return end
  local info = self:GetAnimInfoSequence(seq)
  if not isnumber(info.numframes) then return end
  if not istable(frames) then frames = {frames} end
  for i, frame in ipairs(frames) do
    self:SequenceEvent(seq, frame/(info.numframes-1), function(self)
      self:OnAnimEvent(event, -1, self:GetPos(), self:GetAngles())
    end)
  end
end

function ENT:DirectPoseParametersAt(pos, pitch, yaw, center)
  if not isstring(yaw) then
    return self:DirectPoseParametersAt(pos, pitch.."_pitch", pitch.."_yaw", yaw)
  elseif isentity(pos) then pos = pos:WorldSpaceCenter() end
  if isvector(pos) then
    center = center or self:WorldSpaceCenter()
    local angle = (pos - center):Angle()
    self:SetPoseParameter(pitch, math.AngleDifference(angle.p, self:GetAngles().p))
    self:SetPoseParameter(yaw, math.AngleDifference(angle.y, self:GetAngles().y))
  else
    self:SetPoseParameter(pitch, 0)
    self:SetPoseParameter(yaw, 0)
  end
end

-- Hooks --

function ENT:OnAnimEvent() end

-- Handlers --

function ENT:_InitAnimations()
  if SERVER then
    self._DrGBaseCurrentGestures = {}
    self._DrGBasePoseParameters = {}
    for i = 0, (self:GetNumPoseParameters()-1) do
    	self._DrGBasePoseParameters[self:GetPoseParameterName(i)] = true
    end
  end
  self._DrGBaseActIDsFromNames = {}
  self._DrGBasePreviousSequence = self:GetSequence()
  self._DrGBaseLastAnimCycle = 0
  self._DrGBaseSequenceEvents = {}
end

function ENT:_HandleAnimations()
  local current = self:GetSequence()
  if self:GetSequence() ~= self._DrGBasePreviousSequence then
    self._DrGBasePreviousSequence = current
    self._DrGBaseLastAnimCycle = 0
    self:_PlaySequenceEvents(current, 0, 0)
  else self:_PlaySequenceEvents(current, self:GetCycle(), self._DrGBaseLastAnimCycle) end
  self._DrGBaseLastAnimCycle = self:GetCycle()
end

function ENT:_PlaySequenceEvents(seq, currCycle)
  local events = self._DrGBaseSequenceEvents[seq]
  for cycle, event in pairs(istable(events) and events or {}) do
    if (currCycle > cycle and self._DrGBaseLastAnimCycle <= cycle) or
    (currCycle < self._DrGBaseLastAnimCycle and currCycle >= cycle) or
    (currCycle < self._DrGBaseLastAnimCycle and self._DrGBaseLastAnimCycle <= cycle) then
      for _, todo in ipairs(event) do todo.callback(self, table.DrG_Unpack(todo.args, todo.n)) end
    end
  end
end

if SERVER then

  local function SeqHasTurningWalkframes(self, seq)
    local success, _, angles = self:GetSequenceMovement(seq, 0, 1)
    return success and angles.y ~= 0
  end

  local function CallOnAnimChange(self, old, new)
    return self:OnAnimChange(self:GetSequenceName(old), self:GetSequenceName(new))
  end
  local function CallOnAnimChanged(self, old, new)
    if not isfunction(self.OnAnimChanged) then return end
    self:ReactInCoroutine(function(self)
      self:OnAnimChanged(self:GetSequenceName(old), self:GetSequenceName(new), delay)
    end)
  end

  local function ResetSequence(self, seq)
    local len = self:SetSequence(seq)
    self:ResetSequenceInfo()
    self:SetCycle(0)
    return len
  end

  -- Getters/setters --

  function ENT:IsPlayingAnimation()
    return isnumber(self._DrGBasePlayingAnimation)
  end

  function ENT:IsPlayingSequence(seq)
    if isstring(seq) then seq = self:LookupSequence(seq)
    elseif not isnumber(seq) then return false end
    if seq == -1 then return false end
    if self._DrGBasePlayingAnimation == seq then return true end
    if self._DrGBaseCurrentGestures[seq] then return true end
    return false
  end

  function ENT:IsPlayingActivity(act)
    if not isnumber(self._DrGBasePlayingAnimation) then return false end
    return self:GetSequenceActivity(self._DrGBasePlayingAnimation) == act
  end

  -- Functions --

  function ENT:PlaySequenceAndWait(seq, rate, callback)
    if self._DrGBaseDisablePSAW then return end
    if isstring(seq) then seq = self:LookupSequence(seq)
    elseif not isnumber(seq) then return end
    if seq == -1 then return end
    local current = self:GetSequence()
    if seq == self:GetSequence() or CallOnAnimChange(self, current, seq) ~= false then
      self._DrGBasePlayingAnimation = seq
      ResetSequence(self, seq)
      self:SetPlaybackRate(rate or 1)
      local now = CurTime()
      local lastCycle = -1
      while seq == self:GetSequence() do
        local cycle = self:GetCycle()
        if lastCycle > cycle then break end
        if lastCycle == cycle and cycle == 1 then break end
        lastCycle = cycle
        if isfunction(callback) then
          self._DrGBaseDisablePSAW = true
          local res = callback(self, cycle)
          self._DrGBaseDisablePSAW = false
          if res then break end
        end
        self:YieldCoroutine(false)
      end
      self._DrGBasePlayingAnimation = nil
      self:Timer(0, function()
        self:UpdateAnimation()
        self:UpdateSpeed()
      end)
      return CurTime() - now
    end
  end
  function ENT:PlayActivityAndWait(act, rate, callback)
    local seq = self:SelectRandomSequence(act)
    return self:PlaySequenceAndWait(seq, rate, callback)
  end
  function ENT:PlayAnimationAndWait(anim, rate, callback)
    if isstring(anim) then return self:PlaySequenceAndWait(anim, rate, callback)
    elseif isnumber(anim) then return self:PlayActivityAndWait(anim, rate, callback) end
  end

  function ENT:PlaySequenceAndMove(seq, options, callback)
    if isstring(seq) then seq = self:LookupSequence(seq)
    elseif not isnumber(seq) then return end
    if seq == -1 then return end
    if isnumber(options) then options = {rate = options}
    elseif not istable(options) then options = {} end
    if options.gravity == nil then options.gravity = true end
    if options.collisions == nil then options.collisions = true end
    local previousCycle = 0
    local previousPos = self:GetPos()
    local res = self:PlaySequenceAndWait(seq, options.rate, function(self, cycle)
      local success, vec, angles = self:GetSequenceMovement(seq, previousCycle, cycle)
      if success then
        if isvector(options.multiply) then
          vec = Vector(vec.x*options.multiply.x, vec.y*options.multiply.y, vec.z*options.multiply.z)
        end
        vec:Rotate(self:GetAngles() + angles)
        self:SetAngles(self:LocalToWorldAngles(angles))
        if not options.collisions or not self:TraceHull(vec, {step = self:IsOnGround()}).Hit then
          if not options.gravity then
            previousPos = previousPos + vec*self:GetModelScale()
            self:SetPos(previousPos)
          elseif not vec:IsZero() then
            previousPos = self:GetPos() + vec*self:GetModelScale()
            self:SetPos(previousPos)
          else previousPos = self:GetPos() end
        elseif options.stoponcollide then return true
        elseif not options.gravity then
          self:SetPos(previousPos)
        end
      end
      previousCycle = cycle
      if isfunction(callback) then return callback(self, cycle) end
    end)
    if not options.gravity then
      self:SetPos(previousPos)
      self:SetVelocity(Vector(0, 0, 0))
    end
    return res
  end
  function ENT:PlayActivityAndMove(act, options, callback)
    local seq = self:SelectRandomSequence(act)
    return self:PlaySequenceAndMove(seq, options, callback)
  end
  function ENT:PlayAnimationAndMove(anim, options, callback)
    if isstring(anim) then return self:PlaySequenceAndMove(anim, options, callback)
    elseif isnumber(anim) then return self:PlayActivityAndMove(anim, options, callback) end
  end

  function ENT:PlaySequenceAndMoveAbsolute(seq, options, callback)
    if isnumber(options) then
      return self:PlaySequenceAndMove(seq, {
        rate = options, gravity = false, collisions = false
      }, callback)
    else
      options = options or {}
      options.gravity = false
      options.collisions = false
      return self:PlaySequenceAndMove(seq, options, callback)
    end
  end
  function ENT:PlayActivityAndMoveAbsolute(act, options, callback)
    local seq = self:SelectRandomSequence(act)
    return self:PlaySequenceAndMoveAbsolute(seq, options, callback)
  end
  function ENT:PlayAnimationAndMoveAbsolute(anim, options, callback)
    if isstring(anim) then return self:PlaySequenceAndMoveAbsolute(anim, options, callback)
    elseif isnumber(anim) then return self:PlayActivityAndMoveAbsolute(anim, options, callback) end
  end

  function ENT:PlaySequence(seq, rate, callback)
    if isstring(seq) then seq = self:LookupSequence(seq)
    elseif not isnumber(seq) then return end
    if seq == -1 then return end
    rate = isnumber(rate) and rate or 1
    if self._DrGBaseCurrentGestures[seq] then return end
    local duration = self:SequenceDuration(seq)/rate
    local layerID = self:AddGestureSequence(seq)
    if layerID == -1 then return 0 end
    self._DrGBaseCurrentGestures[seq] = true
    self:SetLayerPlaybackRate(layerID, rate)
    coroutine.DrG_Create(function()
      local lastCycle = 0
      while IsValid(self) do
        local cycle = self:GetLayerCycle(layerID)
        if cycle < lastCycle then break end
        --if cycle == lastCycle and cycle == 1 then break end
        self:_PlaySequenceEvents(seq, cycle, lastCycle)
        if not isfunction(callback) or
        not callback(self, cycle, layerID) then
          lastCycle = cycle
          coroutine.yield()
        else break end
      end
      if IsValid(self) then
        self._DrGBaseCurrentGestures[seq] = nil
      end
    end)
    return duration
  end
  function ENT:PlayActivity(act, rate, callback)
    local seq = self:SelectRandomSequence(act)
    return self:PlaySequence(seq, rate, callback)
  end
  function ENT:PlayAnimation(anim, rate, callback)
    if isstring(anim) then return self:PlaySequence(anim, rate, callback)
    elseif isnumber(anim) then return self:PlayActivity(anim, rate, callback) end
  end

  local function PlayClosestClimbSequence(self, seqs, height, rate, callback)
    local climbs = {}
    for _, seq in ipairs(seqs) do
      if isstring(seq) then seq = self:LookupSequence(seq)
      elseif not isnumber(seq) then continue end
      if seq == -1 then continue end
      local success, vec = self:GetSequenceMovement(seq, 0, 1)
      if not success then continue end
      table.insert(climbs, {seq = seq, height = vec.z})
    end
    table.sort(climbs, function(climb1, climb2)
      return climb1.height < climb2.height
    end)
    height = height/self:GetModelScale()
    for i, climb in ipairs(climbs) do
      local prior = climbs[i-1]
      if height < climb.height then
        return self:PlayClimbSequence(climb.seq, height*self:GetModelScale(), rate, callback)
      elseif prior ~= nil and math.Clamp(height, prior.height, climb.height) == height then
        local avg = (prior.height + climb.height)/2
        if height < avg then
          return self:PlayClimbSequence(prior.seq, height*self:GetModelScale(), rate, callback)
        else return self:PlayClimbSequence(climb.seq, height*self:GetModelScale(), rate, callback) end
      elseif climbs[i+1] == nil then
        return self:PlayClimbSequence(climb.seq, height*self:GetModelScale(), rate, callback)
      end
    end
  end
  function ENT:PlayClimbSequence(seq, height, rate, callback)
    if not istable(seq) then
      if isstring(seq) then seq = self:LookupSequence(seq)
      elseif not isnumber(seq) then return end
      if seq == -1 then return end
      local success, vec = self:GetSequenceMovement(seq, 0, 1)
      if not success then return end
      return self:PlaySequenceAndMoveAbsolute(seq, {
        rate = rate,
        multiply = Vector(1, 1, height/vec.z/self:GetModelScale()),
      }, function(self, cycle)
        if not self:TraceHull(self:GetForward()*self.LedgeDetectionDistance*2).Hit then return true end
        if isfunction(callback) then return callback(self, cycle) end
      end)
    else return PlayClosestClimbSequence(self, seq, height, rate, callback) end
  end
  function ENT:PlayClimbActivity(act, height, rate, callback)
    local seq = self:SelectRandomSequence(act)
    return self:PlayClimbSequence(seq, height, rate, callback)
  end
  function ENT:PlayClimbAnimation(anim, height, rate, callback)
    if isstring(anim) then self:PlayClimbSequence(anim, height, rate, callback)
    elseif isnumber(anim) then self:PlayClimbActivity(anim, height, rate, callback) end
  end

  -- Update --

  function ENT:UpdateAnimation()
    if self:IsPlayingAnimation() then return end
    if self:IsAIDisabled() and
    not self:IsPossessed() and
    DebugAnims:GetBool() then return end
    local anim, rate = self:OnUpdateAnimation()
    if isstring(anim) and string.StartWith(anim, "ACT_") then
      anim = self:GetActivityIDFromName(anim)
    end
    local current = self:GetSequence()
    local validAnim = false
    if isnumber(anim) then
      local seq = self:SelectRandomSequence(anim)
      validAnim = seq ~= -1
      local activity = self:GetSequenceActivity(current)
      if validAnim and (self:GetCycle() == 1 or anim ~= activity) then
        if CallOnAnimChange(self, current, seq) ~= false then
          CallOnAnimChanged(self, current, seq)
          ResetSequence(self, seq)
        end
      end
    elseif isstring(anim) then
      local seq = self:LookupSequence(anim)
      validAnim = seq ~= -1
      if validAnim and (self:GetCycle() == 1 or seq ~= current) then
        if CallOnAnimChange(self, current, seq) ~= false then
          CallOnAnimChanged(self, current, seq)
          ResetSequence(self, seq)
        end
      end
    end
    if validAnim and
    ((not self:IsMoving() or self:GetSequenceGroundSpeed(self:GetSequence()) == 0) and
    (not self:IsTurning() or not SeqHasTurningWalkframes(self, self:GetSequence()))) then
      self:SetPlaybackRate(rate or 1)
    end
  end
  function ENT:OnUpdateAnimation()
    if self:IsDown() or self:IsDead() then return end
    if self:IsClimbingUp() then return self.ClimbUpAnimation, self.ClimbAnimRate
    elseif self:IsClimbingDown() then return self.ClimbDownAnimation, self.ClimbAnimRate
    elseif not self:IsOnGround() then return self.JumpAnimation, self.JumpAnimRate
    elseif self:IsRunning() then return self.RunAnimation, self.RunAnimRate
    elseif self:IsMoving() then return self.WalkAnimation, self.WalkAnimRate
    else return self.IdleAnimation, self.IdleAnimRate end
  end

  -- Hooks

  function ENT:OnAnimChange() end
  --function ENT:OnAnimChanged() end

  function ENT:BodyUpdate()
    self:BodyMoveXY()
  end

  function ENT:HandleAnimEvent(event, _, _, _, options)
    self:OnAnimEvent(options, event, self:GetPos(), self:GetAngles())
  end

  -- Handlers --

  -- Meta --

  local nextbotMETA = FindMetaTable("NextBot")

  local old_BodyMoveXY = nextbotMETA.BodyMoveXY
  function nextbotMETA:BodyMoveXY(options)
    if self.IsDrGNextbot then
      if self.IsDrGNextbotSprite then return end
      options = options or {}
      if options.rate == nil then options.rate = true end
      if options.direction == nil then options.direction = true end
      if options.frameadvance ~= false then self:FrameAdvance() end
      local seq = self:GetSequence()
      if not self:IsPlayingAnimation() and
      (self:IsMoving() or (self:IsTurning() and SeqHasTurningWalkframes(self, seq))) then
        if options.direction and self:IsMoving() then
          if self._DrGBasePoseParameters["move_x"] or
          self._DrGBasePoseParameters["move_y"] then
            local movement = self:GetMovement(true)
            self:SetPoseParameter("move_x", movement.x)
            self:SetPoseParameter("move_y", movement.y)
          end
          if self._DrGBasePoseParameters["move_yaw"] then
            local forward = self:GetForward()
            local velocity = self:GetVelocity()
            forward.z = 0
            velocity.z = 0
            local forwardAng = forward:Angle()
            local velocityAng = velocity:Angle()
            self:SetPoseParameter("move_yaw", math.AngleDifference(velocityAng.y, forwardAng.y))
          end
        end
        if options.rate and not self:IsPlayingAnimation() and
        self:IsOnGround() and not self:IsClimbing() then
          local velocity = self:GetVelocity()
          velocity.z = 0
          if not velocity:IsZero() then
            local speed = velocity:Length()
            local seqspeed = self:GetSequenceGroundSpeed(seq)
            if seqspeed ~= 0 then self:SetPlaybackRate(speed/seqspeed) end
          elseif self:IsTurning() then
            local success, _, angles = self:GetSequenceMovement(seq, 0, 1)
            if success and angles.y ~= 0 then
              local seqspeed = math.abs(angles.y)/self:SequenceDuration(seq)
              local turnspeed = math.abs(self:GetAngles().y-self._DrGBaseLastAngle.y)/0.1
              if seqspeed ~= 0 then self:SetPlaybackRate(turnspeed/seqspeed) end
            end
          end
        end
      end
    else return old_BodyMoveXY(self) end
  end

  local old_GetActivity = nextbotMETA.GetActivity
  function nextbotMETA:GetActivity()
    if self.IsDrGNextbot then
      return self:GetSequenceActivity(self:GetSequence())
    else return old_GetActivity(self) end
  end

  local old_StartActivity = nextbotMETA.StartActivity
  function nextbotMETA:StartActivity(act)
    if self.IsDrGNextbot then
      local seq = self:SelectRandomSequence(act)
      if seq == -1 then return false end
      self:ResetSequence(seq)
      return true
    else return old_StartActivity(self, act) end
  end

else

  -- Getters/setters --

  -- Functions --

  -- Hooks --

  function ENT:FireAnimationEvent(pos, angle, event, name)
    self:OnAnimEvent(name, event, pos, angle)
  end

  -- Handlers --

end
