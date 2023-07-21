
local physMETA = FindMetaTable("PhysObj")

local DebugTrajectories = CreateConVar("drgbase_debug_trajectories", "0")

local function DebugTrajectory(self, dir, info)
  if DebugTrajectories:GetFloat() <= 0 then return end
  debugoverlay.DrG_Trajectory(self:GetPos(), dir, DebugTrajectories:GetFloat(), function(t)
    if t < 0 then return DrGBase.CLR_GREEN
    elseif t > info.duration then return DrGBase.CLR_RED
    else return DrGBase.CLR_WHITE end
  end, false, info.ballistic and (info.duration == -1 and {
    from = math.min(0, info.highest), to = math.max(0, info.highest),
    ballistic = true
  } or {
    from = math.min(-info.duration, info.highest),
    to = math.max(info.duration*2, info.highest),
    ballistic = true
  }) or {
    from = -info.duration, to = info.duration*2,
    ballistic = false
  })
end
function physMETA:DrG_AimAt(target, speed, feet)
  if self:IsGravityEnabled() then
    if self:IsDragEnabled() then self:EnableDrag(false) end
    local dir, info = self:GetPos():DrG_CalcBallisticTrajectory(target, {
      magnitude = speed, recursive = true
    }, feet)
    if math.Round(dir:Length(), 1) > math.Round(speed, 1) then
      dir = dir:GetNormalized()*speed
      info.duration = -1
    end
    self:SetVelocity(dir)
    DebugTrajectory(self, dir, info)
    return dir, info
  else
    if self:IsDragEnabled() then self:EnableDrag(false) end
    local dir, info = self:GetPos():DrG_CalcLineTrajectory(target, speed, feet)
    self:SetVelocity(dir)
    DebugTrajectory(self, dir, info)
    return dir, info
  end
end
function physMETA:DrG_ThrowAt(target, options, feet)
  if self:IsDragEnabled() then self:EnableDrag(false) end
  local dir, info = self:GetPos():DrG_CalcBallisticTrajectory(target, options, feet)
  self:SetVelocity(dir)
  DebugTrajectory(self, dir, info)
  return dir, info
end
