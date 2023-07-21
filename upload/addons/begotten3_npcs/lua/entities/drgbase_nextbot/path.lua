if CLIENT then return end

-- Handlers --

function ENT:_InitPath()
  self._DrGBaseNavAreaBlacklist = {}
end

-- Getters/setters --

function ENT:GetPath()
  if not self._DrGBasePath then
    self._DrGBasePath = Path("Follow")
    self._DrGBasePath:SetMinLookAheadDistance(300)
    return self._DrGBasePath
  else return self._DrGBasePath end
end

function ENT:LastComputeSuccess()
  return self._DrGBaseLastComputeSuccess or false
end
function ENT:LastComputeTime()
  local path = self:GetPath()
  if not IsValid(path) then return -1 end
  return CurTime()-path:GetAge()
end

-- Functions --

function ENT:InvalidatePath()
  local path = self:GetPath()
  if not IsValid(path) then return end
  return path:Invalidate()
end

function ENT:DrawPath()
  local path = self:GetPath()
  if not IsValid(path) then return end
  return path:Draw()
end

function ENT:UpdatePath()
  local path = self:GetPath()
  if not IsValid(path) then return end
  return path:Update(self)
end

function ENT:ComputePath(pos, generator)
  local path = self:GetPath()
  if not IsValid(path) then return end
  return path:Compute(self, pos, generator)
end

function ENT:RefreshPath(generator)
  local path = self:GetPath()
  if not IsValid(path) then return end
  return path:Compute(self, path:GetEnd(), generator)
end

function ENT:BlacklistNavArea(area, blacklist)
  self._DrGBaseNavAreaBlacklist[area:GetID()] = tobool(blacklist)
end
function ENT:IsNavAreaBlacklisted(area)
  return self._DrGBaseNavAreaBlacklist[area:GetID()] or false
end
function ENT:BlacklistedNavAreas()
  local areas = {}
  for id, blacklisted in pairs(self._DrGBaseNavAreaBlacklist) do
    if blacklisted then table.insert(areas, navmesh.GetNavAreaByID(id)) end
  end
  return areas
end

local ENABLE_JUMPING = false
function ENT:GetPathGenerator()
  return function(area, fromArea, ladder, elevator, length)
    if not IsValid(fromArea) then return 0 end
    if self:IsNavAreaBlacklisted(area) then return -1 end
    if not self.loco:IsAreaTraversable(area) then return -1 end
    local dist = 0
    if IsValid(ladder) then
      if not self.ClimbLadders then return -1 end
      dist = ladder:GetLength()
    elseif length > 0 then dist = length
    else dist = fromArea:GetCenter():Distance(area:GetCenter()) end
    local cost = fromArea:GetCostSoFar() + dist
    local height = fromArea:ComputeAdjacentConnectionHeightChange(area)
    if height > 0 then
      if IsValid(ladder) then
        if not self.ClimbLaddersUp then return -1 end
        if height < self.ClimbLaddersUpMinHeight then return -1 end
        if height > self.ClimbLaddersUpMaxHeight then return -1 end
        local res = self:OnComputePathLadderUp(fromArea, area, ladder)
        if res >= 0 then cost = cost + dist*res else return -1 end
      elseif height < self.loco:GetStepHeight() then
        local res = self:OnComputePathStep(fromArea, area, height)
        if res >= 0 then cost = cost + dist*res else return -1 end
      elseif ENABLE_JUMPING and height < self.loco:GetJumpHeight() then
        local res = self:OnComputePathJump(fromArea, area, height)
        if res >= 0 then cost = cost + dist*res else return -1 end
      elseif self.ClimbLedges then
        if height < self.ClimbLedgesMinHeight then return -1 end
        if height > self.ClimbLedgesMaxHeight then return -1 end
        local res = self:OnComputePathLedge(fromArea, area, height)
        if res >= 0 then cost = cost + dist*res else return -1 end
      else return -1 end
    elseif height < 0 then
      local drop = -height
      if IsValid(ladder) then
        if not self.ClimbLaddersDown then return -1 end
        if drop < self.ClimbLaddersDownMinHeight then return -1 end
        if drop > self.ClimbLaddersDownMaxHeight then return -1 end
        local res = self:OnComputePathLadderDown(fromArea, area, ladder)
        if res >= 0 then cost = cost + dist*res else return -1 end
      elseif drop < self.loco:GetDeathDropHeight() then
        local res = self:OnComputePathDrop(fromArea, area, drop)
        if res >= 0 then cost = cost + dist*res else return -1 end
      else return -1 end
    else
      local res = self:OnComputePathFlat(fromArea, area)
      if res >= 0 then cost = cost + dist*res else return -1 end
    end
    if area:IsUnderwater() then
      local res = self:OnComputePathUnderwater(fromArea, area)
      if res >= 0 then cost = cost + dist*res else return -1 end
    end
    local res = self:OnComputePath(fromArea, area)
    if res >= 0 then return cost + dist*res else return -1 end
  end
end

-- Hooks --

function ENT:OnComputePath(from, to) return 0 end
function ENT:OnComputePathLadderUp(from, to, ladder) return 1 end
function ENT:OnComputePathLadderDown(from, to, ladder) return 1 end
function ENT:OnComputePathLedge(from, to, height) return 1 end
function ENT:OnComputePathStep(from, to, height) return 0 end
function ENT:OnComputePathJump(from, to, height) return 1 end
function ENT:OnComputePathDrop(from, to, drop) return 1 end
function ENT:OnComputePathFlat(from, to) return 0 end
function ENT:OnComputePathUnderwater(from, to) return 1 end

-- Meta --

local pathMETA = FindMetaTable("PathFollower")

DrGBase.OLD_Compute = DrGBase.OLD_Compute or pathMETA.Compute
function pathMETA:Compute(nextbot, pos, generator)
  if nextbot.IsDrGNextbot then
    --print(nextbot, "=> compute", CurTime())
    if not isfunction(generator) then generator = nextbot:GetPathGenerator() end
    nextbot._DrGBaseLastComputeSuccess = DrGBase.OLD_Compute(self, nextbot, pos, generator)
    return nextbot._DrGBaseLastComputeSuccess
  else return DrGBase.OLD_Compute(self, nextbot, pos, generator) end
end
