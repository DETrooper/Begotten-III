
-- Convars --

local AllOmniscient = CreateConVar("drgbase_ai_omniscient", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Getters/setters --

function ENT:IsOmniscient()
  return AllOmniscient:GetBool() or self:GetNW2Bool("DrGBaseOmniscient")
end
function ENT:GetSpotDuration()
  return self:GetNW2Float("DrGBaseSpotDuration")
end

-- Hooks --

function ENT:OnSpotted() end
function ENT:OnLost() end

-- Handlers --

function ENT:_InitAwareness()
  if CLIENT then return end
  self._DrGBaseSpotted = {}
  self:SetOmniscient(self.Omniscient)
  self._DrGBaseLastTimeSpotted = {}
  self._DrGBaseLastKnownPos = {}
  self:SetSpotDuration(self.SpotDuration)
end

if SERVER then
  util.AddNetworkString("DrGBaseNextbotPlayerAwareness")

  -- Getters/setters --

  function ENT:SetOmniscient(omniscient)
    self:SetNW2Bool("DrGBaseOmniscient", omniscient)
  end
  function ENT:SetSpotDuration(duration)
    self:SetNW2Float("DrGBaseSpotDuration", duration)
  end

  function ENT:HasSpotted(ent, absolute)
    if not IsValid(ent) then return false end
    if ent == self then return true end
    if not absolute and self:IsOmniscient() then return true end
    return self._DrGBaseSpotted[ent] or false
  end
  function ENT:HasLost(ent, absolute)
    if not IsValid(ent) then return false end
    if ent == self then return false end
    if not absolute and self:IsOmniscient() then return false end
    return self._DrGBaseSpotted[ent] == false
  end

  local function NextAwareEntity(self, entities, j, spotted)
    local i = j+1
    local ent = entities[i]
    if ent == nil then return nil
    elseif not IsValid(ent) or
    (spotted and not self:HasSpotted(ent)) or
    (not spotted and not self:HasLost(ent)) then
      return NextAwareEntity(self, entities, i, spotted)
    else return i, ent end
  end
  function ENT:SpottedEntities()
    local entities = ents.GetAll()
    local i = 0
    return function()
      local j, ent = NextAwareEntity(self, entities, i, true)
      i = j
      return ent
    end
  end
  function ENT:LostEntities()
    local entities = ents.GetAll()
    local i = 0
    return function()
      local j, ent = NextAwareEntity(self, entities, i, false)
      i = j
      return ent
    end
  end
  function ENT:GetSpotted()
    local entities = {}
    for ent in self:SpottedEntities() do
      table.insert(entities, ent)
    end
    return entities
  end
  function ENT:GetLost()
    local entities = {}
    for ent in self:LostEntities() do
      table.insert(entities, ent)
    end
    return entities
  end

  function ENT:LastTimeSpotted(ent)
    return self._DrGBaseLastTimeSpotted[ent] or -1
  end
  function ENT:LastKnownPosition(ent)
    return self._DrGBaseLastKnownPos[ent]
  end
  function ENT:UpdateKnownPosition(ent, pos)
    pos = isvector(pos) and pos or ent:GetPos()
    self._DrGBaseLastKnownPos[ent] = pos
  end

  -- Functions --

  local function SpotTimerName(self, ent)
    return "DrGBaseNB"..self:GetCreationID().."SpotENT"..ent:GetCreationID()
  end
  function ENT:SpotEntity(ent)
    if not IsValid(ent) then return end
    if ent:IsPlayer() and not ent:Alive() then return end
    if ent:IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool() then return end
    if self:GetSpotDuration() == 0 then return end
    local spotted = self:HasSpotted(ent)
    self._DrGBaseLastTimeSpotted[ent] = CurTime()
    self._DrGBaseSpotted[ent] = true
    local disp = self:GetRelationship(ent, true)
    if disp == D_HT or disp == D_LI or disp == D_FR then
      self._DrGBaseRelationshipCachesSpotted[disp][ent] = true
    end
    self:UpdateKnownPosition(ent)
    if self._DrGBasePatrolSound and
    self._DrGBasePatrolSound:GetSound().Entity == ent then
      self:RemovePatrol(self._DrGBasePatrolSound)
    end
    if not spotted then
      self:OnSpotted(ent)
      if ent:IsPlayer() then
        net.Start("DrGBaseNextbotPlayerAwareness")
        net.WriteEntity(self)
        net.WriteBit(true)
        net.Send(ent)
      end
    end
    local timerName = SpotTimerName(self, ent)
    timer.Remove(timerName)
    if self:GetSpotDuration() <= 0 then return end
    timer.Create(timerName, self:GetSpotDuration(), 1, function()
      if not IsValid(self) or not IsValid(ent) then return end
      self:LoseEntity(ent)
    end)
  end
  function ENT:LoseEntity(ent)
    if not IsValid(ent) then return end
    if not self:HasSpotted(ent) then return end
    if self:HasLost(ent) then return end
    if ent:IsPlayer() then
      net.Start("DrGBaseNextbotPlayerAwareness")
      net.WriteEntity(self)
      net.WriteBit(false)
      net.Send(ent)
    end
    timer.Remove(SpotTimerName(self, ent))
    self._DrGBaseSpotted[ent] = false
    self._DrGBaseRelationshipCachesSpotted[D_LI][ent] = nil
    self._DrGBaseRelationshipCachesSpotted[D_HT][ent] = nil
    self._DrGBaseRelationshipCachesSpotted[D_FR][ent] = nil
    self:OnLost(ent)
  end

  function ENT:AlertAllies(ent, spotted)
    if not self:HasSpotted(ent) then return end
    local alerted = {}
    for ally in self:AllyIterator(spotted) do
      if not ally.IsDrGNextbot then continue end
      if not ally:HasSpotted(ent) then
        table.insert(alerted, ent)
        ally:OnAlerted(ent, self)
      else ally:SpotEntity(ent) end
    end
    if #alerted > 0 then
      self:OnAlert(ent, alerted)
    end
  end

  -- Hooks --

  function ENT:OnAlert(ent, alerted) end
  function ENT:OnAlerted(ent, alertedBy)
    self:SpotEntity(ent)
  end

  -- Handlers --

  cvars.AddChangeCallback("ai_ignoreplayers", function(name, old, new)
    for i, nextbot in ipairs(DrGBase.GetNextbots()) do
      if tobool(new) then
        for h, ply in ipairs(player.GetAll()) do
          nextbot:LoseEntity(ply)
        end
      end
      nextbot:UpdateAI()
    end
  end, "DrGBaseIgnorePlayers")

  hook.Add("PostPlayerDeath", "DrGBaseForgetPlayerDeath", function(ply)
    for i, nextbot in ipairs(DrGBase.GetNextbots()) do
      nextbot:LoseEntity(ply)
      nextbot:UpdateAI()
    end
  end)

else

  local function CallAwarenessHooks(self, spotted)
    local ply = LocalPlayer()
    if spotted then
      if isfunction(self.OnSpotted) then
        self._DrGBaseLastTimeSpotted = CurTime()
        self._DrGBaseLastKnownPosition = ply:GetPos()
        self:OnSpotted(ply)
      else
        timer.Simple(engine.TickInterval(), function()
          if IsValid(self) and IsValid(ply) then
            CallAwarenessHooks(self, spotted)
          end
        end)
      end
    elseif isfunction(self.OnLost) then
      self:OnLost(ply)
    else
      timer.Simple(engine.TickInterval(), function()
        if IsValid(self) and IsValid(ply) then
          CallAwarenessHooks(self, spotted)
        end
      end)
    end
  end
  net.Receive("DrGBaseNextbotPlayerAwareness", function()
    local nextbot = net.ReadEntity()
    local awareness = net.ReadBit()
    if IsValid(nextbot) then
      nextbot._DrGBaseLocalPlayerAwareness = awareness
      CallAwarenessHooks(nextbot, awareness == 1)
    end
  end)

  -- Getters/setters --

  function ENT:HasSpottedLocalPlayer()
    if self:IsOmniscient() then return true end
    return self._DrGBaseLocalPlayerAwareness == 1
  end
  function ENT:HasLostLocalPlayer()
    if self:IsOmniscient() then return false end
    return self._DrGBaseLocalPlayerAwareness == 0
  end

  function ENT:LastTimeSpotted()
    return self._DrGBaseLastTimeSpotted or -1
  end
  function ENT:LastKnownPosition()
    return self._DrGBaseLastKnownPosition
  end

end
