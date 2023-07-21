
-- Disable 3D stuff --

function ENT:SequenceEvent() end
function ENT:DirectPoseParametersAt() end

-- Getters/setters --

function ENT:GetSpriteFolder()
  local str = self.SpriteFolder
  if #str == 0 then str = self.SpritesFolder or "" end
  local folder = self:GetNW2String("DrGBaseSpriteFolder", str)
  folder = string.Replace(folder, "\\", "/")
  if string.EndsWith(folder, "/") then return folder
  else return folder.."/" end
end

function ENT:GetSpriteAnim()
  return self:GetNW2String("DrGBaseSpriteAnim")
end
function ENT:GetSpriteFrame()
  return self:GetNW2Int("DrGBaseSpriteFrame", 1)
end
function ENT:GetFrameDuration()
  return (1/self:GetPlaybackRate())/self.FramesPerSecond
end

function ENT:SpriteAnimExists(anim)
  if self._DrGBaseSpriteAnimInfo[anim] == nil then
    self._DrGBaseSpriteAnimInfo[anim] = {
      ["8dir"] = file.Exists("materials/"..self:GetSpriteFolder().."ne_"..anim.."1.png", "GAME"),
      ["4dir"] = file.Exists("materials/"..self:GetSpriteFolder().."n_"..anim.."1.png", "GAME"),
      ["1dir"] = file.Exists("materials/"..self:GetSpriteFolder()..anim.."1.png", "GAME")
    }
    local info = self._DrGBaseSpriteAnimInfo[anim]
    if not info["4dir"] and not info["1dir"] then
      self._DrGBaseSpriteAnimInfo[anim] = false
      return false
    else return true end
  else return istable(self._DrGBaseSpriteAnimInfo[anim]) end
end
function ENT:SpriteAnim8Dir(anim)
  if not self:SpriteAnimExists(anim) then return false end
  return self._DrGBaseSpriteAnimInfo[anim]["8dir"]
end
function ENT:SpriteAnim4Dir(anim)
  if not self:SpriteAnimExists(anim) then return false end
  return self._DrGBaseSpriteAnimInfo[anim]["4dir"]
end
function ENT:SpriteAnim1Dir(anim)
  if not self:SpriteAnimExists(anim) then return false end
  return self._DrGBaseSpriteAnimInfo[anim]["1dir"]
end
function ENT:GetNumberOfFrames(anim)
  if not self:SpriteAnimExists(anim) then return 0 end
  if not isnumber(self._DrGBaseSpriteAnimInfo[anim].nb) then
    local i = 0
    if self._DrGBaseSpriteAnimInfo[anim]["4dir"] then
      while file.Exists("materials/"..self:GetSpriteFolder().."n_"..anim..tostring(i+1)..".png", "GAME") do
        i = i+1
      end
    else
      while file.Exists("materials/"..self:GetSpriteFolder()..anim..tostring(i+1)..".png", "GAME") do
        i = i+1
      end
    end
    self._DrGBaseSpriteAnimInfo[anim].nb = i
    return i
  else return self._DrGBaseSpriteAnimInfo[anim].nb end
end

-- Functions --

function ENT:SpriteAnimEvent(anim, frames, callback)
  if istable(anim) then
    for i, ani in ipairs(anim) do
      self:SequenceEvent(ani, frames, callback)
    end
  else
    self._DrGBaseSpriteAnimEvents[anim] = self._DrGBaseSpriteAnimEvents[anim] or {}
    local event = self._DrGBaseSpriteAnimEvents[anim]
    if isnumber(frames) then frames = {frames} end
    for i, frame in ipairs(frames) do
      event[frame] = event[frame] or {}
      table.insert(event[frame], callback)
    end
  end
end
function ENT:ClearSpriteAnimEvents(anim)
  if istable(anim) then
    for i, se in ipairs(anim) do self:ClearSpriteAnimEvents(ani) end
  elseif isstring(anim) then
    self._DrGBaseSpriteAnimEvents[anim] = nil
  else self._DrGBaseSpriteAnimEvents = {} end
end

-- Hooks --

-- Handlers --

function ENT:_InitAnimations()
  self._DrGBaseSpriteAnimInfo = {}
  self._DrGBaseSpriteAnimEvents = {}
  self:SetNW2VarProxy("DrGBaseSpriteFrame", function(self, name, prior, frame)
    if frame == 0 then return end
    local anim = self:GetSpriteAnim()
    local event = self._DrGBaseSpriteAnimEvents[anim]
    if not event then return end
    for i, callback in ipairs(istable(event[frame]) and event[frame] or {}) do
      callback(self, frame, false)
    end
  end)
  if SERVER then
    self._DrGBaseLastFrameChange = CurTime()
    self:LoopTimer(0.1, self.UpdateAnimation)
  end
end

function ENT:_HandleAnimations()
  if CLIENT then return end
  if CurTime() > self._DrGBaseLastFrameChange + self:GetFrameDuration() then
    self:NextSpriteFrame()
  end
end

if SERVER then

  -- Disable 3D stuff --

  function ENT:IsPlayingSequence() return false end
  function ENT:IsPlayingActivity() return false end

  function ENT:PlaySequenceAndWait() return 0 end
  function ENT:PlayActivityAndWait() return 0 end

  function ENT:PlaySequenceAndMove() return 0 end
  function ENT:PlayActivityAndMove() return 0 end

  function ENT:PlaySequenceAndMoveAbsolute() return 0 end
  function ENT:PlayActivityAndMoveAbsolute() return 0 end

  function ENT:PlaySequence() return 0 end
  function ENT:PlayActivity() return 0 end

  function ENT:PlayClimbSequence() return 0 end
  function ENT:PlayClimbActivity() return 0 end
  function ENT:PlayClimbAnimation() return 0 end

  -- Getters/setters --

  function ENT:IsPlayingAnimation()
    return isstring(self._DrGBasePlayingSpriteAnim)
  end
  function ENT:IsPlayingSpriteAnim(anim)
    if not isstring(anim) then return false end
    return self._DrGBasePlayingSpriteAnim == anim
  end

  function ENT:SetSpriteFolder(folder)
    self:SetNW2String("DrGBaseSpriteFolder", folder)
  end

  function ENT:SetSpriteAnim(anim)
    if self:GetSpriteAnim() ~= anim then self:ResetSpriteAnim(anim) end
  end
  function ENT:ResetSpriteAnim(anim)
    if not self:SpriteAnimExists(anim) then return end
    self:SetNW2Int("DrGBaseSpriteFrame", 0)
    self:SetSpriteFrame(1)
    self:SetNW2String("DrGBaseSpriteAnim", anim)
  end

  function ENT:SetSpriteFrame(frame)
    if not isnumber(frame) then return -1 end
    local nb = self:GetNumberOfFrames(self:GetSpriteAnim())
    if frame > nb then
      self:SetNW2Int("DrGBaseSpriteFrame", 1)
      self._DrGBaseLastFrameChange = CurTime()
      return 1
    elseif frame > 0 then
      self:SetNW2Int("DrGBaseSpriteFrame", frame)
      self._DrGBaseLastFrameChange = CurTime()
      return frame
    end
  end
  function ENT:NextSpriteFrame()
    return self:SetSpriteFrame(self:GetSpriteFrame()+1)
  end

  -- Functions --

  function ENT:PlaySpriteAnimAndWait(anim, rate, callback)
    if not self:SpriteAnimExists(anim) then return -1 end
    local oldPlayingAnim = self._DrGBasePlayingSpriteAnim
    self._DrGBasePlayingSpriteAnim = anim
    self:ResetSpriteAnim(anim)
    self:SetPlaybackRate(rate or 1)
    local now = CurTime()
    local lastFrame = -1
    while anim == self:GetSpriteAnim() do
      local frame = self:GetSpriteFrame()
      if lastFrame > frame then break end
      lastFrame = frame
      if isfunction(callback) and callback(self, frame) then break end
      self:YieldCoroutine(false)
    end
    self._DrGBasePlayingSpriteAnim = oldPlayingAnim
    self:Timer(0, function()
      self:UpdateAnimation()
      self:UpdateSpeed()
    end)
    return CurTime() - now
  end
  function ENT:PlayAnimationAndWait(anim, rate, callback)
    return self:PlaySpriteAnimAndWait(anim, rate, callback)
  end
  function ENT:PlayAnimationAndMove(anim, rate, callback)
    return self:PlaySpriteAnimAndWait(anim, rate, callback)
  end
  function ENT:PlayAnimationAndMoveAbsolute(anim, rate, callback)
    local pos = self:GetPos()
    return self:PlaySpriteAnimAndWait(anim, rate, function(self, frame)
      self:SetPos(pos)
    end)
  end

  function ENT:PlaySpriteAnim(anim, rate, callback)
    if not self:SpriteAnimExists(anim) then return -1 end
    coroutine.DrG_Create(function()
      self:PlaySpriteAnimAndWait(anim, rate, callback)
    end)
    return self:GetNumberOfFrames(anim)*self:GetFrameDuration()
  end
  function ENT:PlayAnimation(anim, rate, callback)
    return self:PlaySpriteAnim(anim, rate, callback)
  end

  -- Update --

  function ENT:UpdateAnimation()
    if self:IsPlayingAnimation() then return end
    local anim, rate = self:OnUpdateAnimation()
    if not isstring(anim) then return end
    if anim ~= self:GetSpriteAnim() then self:SetSpriteAnim(anim) end
    if rate ~= self:GetPlaybackRate() then
      self:SetPlaybackRate(rate or 1)
    end
  end

  -- Hooks --

  function ENT:BodyUpdate() end

  -- Handlers --

else

  -- Disable 3D stuff --

  -- Getters/setters --

  -- Functions --

  -- Hooks --

  -- Handlers --

end
