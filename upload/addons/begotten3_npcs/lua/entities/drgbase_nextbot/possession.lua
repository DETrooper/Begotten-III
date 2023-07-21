
-- Getters/setters --

function ENT:IsPossessionEnabled()
  --return self:GetNW2Bool("DrGBasePossessionEnabled")
  return self:GetNWBool("DrGBasePossessionEnabled")
end

function ENT:GetPossessor()
  return self:GetNW2Entity("DrGBasePossessor")
end
function ENT:IsPossessed()
  return IsValid(self:GetPossessor())
end
function ENT:IsPossessor(ent)
  if not self:IsPossessed() then return false
  else return self:GetPossessor() == ent end
end

function ENT:CurrentViewPreset()
  if not self:IsPossessed() then return -1 end
  if #self.PossessionViews == 0 then return -1 end
  local current = self:GetNW2Int("DrGBasePossessionView", 1)
  return current, self.PossessionViews[current]
end
function ENT:CycleViewPresets()
  if SERVER then
    local current = self:CurrentViewPreset()
    if current == -1 then return end
    current = current + 1
    if current > #self.PossessionViews then current = 1 end
    self:SetNW2Int("DrGBasePossessionView", current)
  elseif self:IsPossessedByLocalPlayer() then
    net.Start("DrGBasePossessionCycleViewPresets")
    net.WriteEntity(self)
    net.WriteEntity(LocalPlayer())
    net.SendToServer()
  end
end

function ENT:PossessionGetLockedOn()
  if not self:IsPossessed() then return NULL
  else return self:GetNW2Entity("DrGBasePossessionLockedOn") end
end

-- Functions --

function ENT:PossessorView()
  if not self:IsPossessed() then return end
  local current, preset = self:CurrentViewPreset()
  local offset = preset.offset or Vector(0, 0, 0)
  local center = self:WorldSpaceCenter()
  local eyes = self:GetPossessor():EyeAngles()
  local angles = Angle(-eyes.p, eyes.y + 180, 0)
  if current == -1 then
    return center, angles
  else
    if preset.invertpitch then
      angles.p = -angles.p
    end
    if preset.invertyaw then
      angles.y = -angles.y
    end
    if preset.eyepos then
      center = self:EyePos()
    elseif isstring(preset.bone) then
      local boneid = self:LookupBone(preset.bone)
      if boneid ~= nil then
        center = self:GetBonePosition(boneid)
      end
    end
    local offset = preset.offset or Vector(0, 0, 0)
    local forward = -Angle(0, angles.y, 0):Forward()
    local right = Angle(0, angles.y + 90, 0):Forward()
    local up = Vector(0, 0, 1)
    local origin = center +
    forward*offset.x*self:GetModelScale() +
    right*offset.y*self:GetModelScale() +
    up*offset.z*self:GetModelScale()
    local tr1 = util.TraceLine({
      start = center,
      endpos = origin,
      collisiongroup = COLLISION_GROUP_DEBRIS
    })
    if tr1.HitWorld then origin = tr1.HitPos + tr1.Normal*-10 end
    local distance = preset.distance or 1
    if distance < 1 then distance = 1 end
    local endpos = origin + angles:Forward()*distance*self:GetModelScale()
    local tr2 = util.TraceLine({
      start = origin,
      endpos = endpos,
      collisiongroup = COLLISION_GROUP_DEBRIS
    })
    if tr2.HitWorld then endpos = tr2.HitPos + tr2.Normal*-10 end
    local viewangle = (tr2.Normal*-1):Angle()
    return endpos, viewangle
  end
end
function ENT:PossessorTrace(options)
  if not self:IsPossessed() then return end
  local origin, angles = self:PossessorView()
  options = options or {}
  options.start = origin
  options.endpos = origin + angles:Forward()*999999999
  return self:TraceLine(nil, options)
end
function ENT:PossessorNormal()
  if not self:IsPossessed() then return end
  local origin, angles = self:PossessorView()
  return angles:Forward()
end
function ENT:PossessorForward()
  if not self:IsPossessed() then return end
  local lockedOn = self:PossessionGetLockedOn()
  if IsValid(lockedOn) then
    local dir = self:GetPos():DrG_Direction(lockedOn:GetPos())
    dir.z = 0
    return dir:GetNormalized()
  else
    local normal = self:PossessorNormal()
    normal.z = 0
    return normal:GetNormalized()
  end
end
function ENT:PossessorRight()
  if not self:IsPossessed() then return end
  local forward = self:PossessorForward()
  forward:Rotate(Angle(0, -90, 0))
  return forward
end
function ENT:PossessorUp()
  return Vector(0, 0, 1)
end

-- Hooks --

function ENT:OnPossessed() end
function ENT:OnDispossessed() end

-- Handlers --

function ENT:_InitPossession()
  if SERVER then
    self:SetPossessionEnabled(self.PossessionEnabled)
  else
    self:SetNW2VarProxy("DrGBasePossessor", function(self, name, old, new)
      if not IsValid(old) and IsValid(new) then self:OnPossessed(new)
      elseif IsValid(old) and not IsValid(new) then self:OnDispossessed(old) end
    end)
  end
end

function ENT:_HandlePossession(cor)
  if not self:IsPossessed() then return end
  local possessor = self:GetPossessor()
  if cor and self:OnPossession() then return end
  if cor then
    local f = possessor:KeyDown(IN_FORWARD)
    local b = possessor:KeyDown(IN_BACK)
    local l = possessor:KeyDown(IN_MOVELEFT)
    local r = possessor:KeyDown(IN_MOVERIGHT)
    local forward = f and not b
    local backward = b and not f
    local right = r and not l
    local left = l and not r
    if self.PossessionMovement == POSSESSION_MOVE_8DIR then
      self:PossessionFaceForward()
      if forward then self:PossessionMoveForward()
      elseif backward then self:PossessionMoveBackward() end
      if right then self:PossessionMoveRight()
      elseif left then self:PossessionMoveLeft() end
    elseif self.PossessionMovement == POSSESSION_MOVE_4DIR then
      self:PossessionFaceForward()
      local dir = self._DrGBasePossLast4DIR or ""
      if forward and (dir == "" or dir == "N") then
        self:PossessionMoveForward()
        self._DrGBasePossLast4DIR = "N"
      elseif backward and (dir == "" or dir == "S") then
        self:PossessionMoveBackward()
        self._DrGBasePossLast4DIR = "S"
      elseif right and (dir == "" or dir == "E") then
        self:PossessionMoveRight()
        self._DrGBasePossLast4DIR = "E"
      elseif left and (dir == "" or dir == "W") then
        self:PossessionMoveLeft()
        self._DrGBasePossLast4DIR = "W"
      else self._DrGBasePossLast4DIR = "" end
    elseif self.PossessionMovement == POSSESSION_MOVE_1DIR then
      local direction = self:GetPos()
      if forward then direction = direction + self:PossessorForward()
      elseif backward then direction = direction - self:PossessorForward() end
      if right then direction = direction + self:PossessorRight()
      elseif left then direction = direction - self:PossessorRight() end
      if direction ~= self:GetPos() then self:MoveTowards(direction)
      else self:PossessionFaceForward() end
    elseif self.PossessionMovement == POSSESSION_MOVE_CUSTOM then
      self:PossessionControls(forward, backward, right, left)
    end
    if possessor:DrG_ButtonDown(possessor:GetInfoNum("drgbase_possession_climb", KEY_C)) then
      if self.ClimbLadders and navmesh.IsLoaded() then
        local area = navmesh.GetNearestNavArea(self:GetPos())
        if IsValid(area) then
          local ladders = area:GetLadders()
          for i, ladder in ipairs(ladders) do
            if self.ClimbLadderUp then
              if self:GetHullRangeSquaredTo(ladder:GetBottom()) < self.LaddersUpDistance^2 then
                self:ClimbLadderUp(ladder)
                return
              end
            elseif self.ClimbLaddersDown then
              if self:GetHullRangeSquaredTo(ladder:GetTop()) < self.LaddersDownDistance^2 then
                self:ClimbLadderDown(ladder)
                return
              end
            end
          end
        end
      end
      local ledge = self:FindLedge()
      if isvector(ledge) then self:ClimbLedge(ledge) end
    end
  end
  for key, binds in pairs(self.PossessionBinds) do
    if isstring(key) then
      if CLIENT then
        local convar = GetConVar(key)
        if not convar then continue
        else key = convar:GetInt() end
      else
        key = possessor:GetInfoNum(key, BUTTON_CODE_INVALID)
        if key == BUTTON_CODE_INVALID then continue end
      end
    end
    for i, bind in ipairs(binds) do
      if CLIENT and not bind.client then continue end
      if SERVER and ((not cor and bind.coroutine) or (cor and not bind.coroutine)) then continue end
      if not isfunction(bind.onkeyup) then bind.onkeyup = function() end end
      if not isfunction(bind.onkeypressed) then bind.onkeypressed = function() end end
      if not isfunction(bind.onkeydown) then bind.onkeydown = function() end end
      if not isfunction(bind.onkeydownlast) then bind.onkeydownlast = function() end end
      if not isfunction(bind.onkeyreleased) then bind.onkeyreleased = function() end end
      if possessor:KeyPressed(key) then bind.onkeypressed(self, possessor) end
      if possessor:KeyDown(key) then bind.onkeydown(self, possessor) else bind.onkeyup(self, possessor) end
      if possessor:KeyDownLast(key) then bind.onkeydownlast(self, possessor) end
      if possessor:KeyReleased(key) then bind.onkeyreleased(self, possessor) end
      if not isfunction(bind.onbuttonup) then bind.onbuttonup = function() end end
      if not isfunction(bind.onbuttonpressed) then bind.onbuttonpressed = function() end end
      if not isfunction(bind.onbuttondown) then bind.onbuttondown = function() end end
      if not isfunction(bind.onbuttonreleased) then bind.onbuttonreleased = function() end end
      if possessor:DrG_ButtonUp(key) then bind.onbuttonup(self, possessor) end
      if possessor:DrG_ButtonPressed(key) then bind.onbuttonpressed(self, possessor) end
      if possessor:DrG_ButtonDown(key) then bind.onbuttondown(self, possessor) end
      if possessor:DrG_ButtonReleased(key) then bind.onbuttonreleased(self, possessor) end
    end
  end
end

if SERVER then
  util.AddNetworkString("DrGBasePossessionCycleViewPresets")

  -- Getters/setters --

  function ENT:SetPossessionEnabled(bool)
    --self:SetNW2Bool("DrGBasePossessionEnabled", bool)
    self:SetNWBool("DrGBasePossessionEnabled", bool)
    if not bool and self:IsPossessed() then self:Dispossess() end
  end

  function ENT:PossessionLockOn(ent)
    if not self:IsPossessed() then return end
    if IsValid(ent) then
      self:SetNW2Entity("DrGBasePossessionLockedOn", ent)
    else
      self:SetNW2Entity("DrGBasePossessionLockedOn", NULL)
    end
  end

  -- Functions --

  function ENT:Possess(ply)
    if not self:IsPossessionEnabled() then return "disabled" end
    if self:IsPossessed() then return "already possessed" end
    if not IsValid(ply) then return "invalid" end
    if not ply:IsPlayer() then return "not player" end
    if not ply:Alive() then return "not alive" end
    if ply:InVehicle() then return "in vehicle" end
    if ply:DrG_IsPossessing() then return "already possessing" end
    if not self:CanPossess(ply) then return "not allowed" end
    self:SetNW2Entity("DrGBasePossessor", ply)
    ply:SetNW2Entity("DrGBasePossessing", self)
    ply:SetNW2Vector("DrGBasePrePossessPos", ply:GetPos())
    ply:SetNW2Angle("DrGBasePrePossessAngle", ply:GetAngles())
    ply:SetNW2Angle("DrGBasePrePossessEyes", ply:EyeAngles())
    ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    ply:SetNoTarget(true)
    ply:SetNoDraw(true)
    ply:Flashlight(false)
    ply:AllowFlashlight(false)
    ply:SetEyeAngles(self:EyeAngles())
    self:UpdateEnemy()
    self:SetNW2Entity("DrGBasePossessionLockedOn", NULL)
    self:SetNW2Int("DrGBasePossessionView", 1)
    self:OnPossessed(ply)
    return "ok"
  end

  function ENT:Dispossess()
    if not self:IsPossessed() then return "not possessed" end
    local ply = self:GetPossessor()
    if not self:CanDispossess(ply) then return "not allowed" end
    if not tobool(ply:GetInfoNum("drgbase_possession_teleport", 0)) then
      ply:SetPos(ply:GetNW2Vector("DrGBasePrePossessPos"))
      ply:SetAngles(ply:GetNW2Angle("DrGBasePrePossessAngle"))
      ply:SetEyeAngles(ply:GetNW2Angle("DrGBasePrePossessEyes"))
    else ply:SetPos(ply:DrG_TraceHull(-self:PossessorForward()*self:Length()).HitPos) end
    self:SetNW2Entity("DrGBasePossessor", NULL)
    ply:SetNW2Entity("DrGBasePossessing", NULL)
    ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    ply:SetNoTarget(false)
    ply:SetNoDraw(false)
    ply:AllowFlashlight(true)
    self:UpdateEnemy()
    self:OnDispossessed(ply)
    return "ok"
  end

  function ENT:PossessionFaceForward()
    if not self:IsPossessed() then return end
    local lockedOn = self:PossessionGetLockedOn()
    if not IsValid(lockedOn) then
      self:FaceTowards(self:GetPos() + self:PossessorNormal())
    else self:FaceTowards(lockedOn) end
  end

  function ENT:PossessionMoveForward()
    return self:Approach(self:GetPos() + self:PossessorForward())
  end
  function ENT:PossessionMoveBackward()
    return self:Approach(self:GetPos() - self:PossessorForward())
  end
  function ENT:PossessionMoveRight()
    return self:Approach(self:GetPos() + self:PossessorRight())
  end
  function ENT:PossessionMoveLeft()
    return self:Approach(self:GetPos() - self:PossessorRight())
  end

  -- Hooks --

  function ENT:CanPossess() return true end
  function ENT:CanDispossess() return true end
  function ENT:OnPossession() end
  function ENT:PossessionControls(forward, backward, right, left) end
  function ENT:PossessionFetchLockOn()
    local closest = self:GetClosestHostile()
    if not IsValid(closest) then return end
    if self:Visible(closest) then return closest end
  end

  -- Handlers --

  local function MoveEnt(ply, ent)
    if not ply:DrG_IsPossessing() then return end
    local tr = ply:DrG_Possessing():PossessorTrace()
    ent:SetPos(tr.HitPos)
  end
  local function MoveEntModel(ply, model, ent)
    MoveEnt(ply, ent)
  end
  
  --[[hook.Add("PlayerSpawnedEffect", "DrGBasePlayerPossessingSpawnedEffect", MoveEntModel)
  hook.Add("PlayerSpawnedNPC", "DrGBasePlayerPossessingSpawnedNPC", MoveEnt)
  hook.Add("PlayerSpawnedProp", "DrGBasePlayerPossessingSpawnedProp", MoveEntModel)
  hook.Add("PlayerSpawnedRagdoll", "DrGBasePlayerPossessingSpawnedRagdoll", MoveEntModel)
  hook.Add("PlayerSpawnedSENT", "DrGBasePlayerPossessingSpawnedSENT", MoveEnt)
  hook.Add("PlayerSpawnedSWEP", "DrGBasePlayerPossessingSpawnedSWEP", MoveEnt)
  hook.Add("PlayerSpawnedVehicle", "DrGBasePlayerPossessingSpawnedVehicle", MoveEnt)]]--

  net.Receive("DrGBasePossessionCycleViewPresets", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    local ply = net.ReadEntity()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if ent:IsPossessed() and ent:GetPossessor() == ply then
      ent:CycleViewPresets()
    end
  end)

else

  -- Convars --

  CreateClientConVar("drgbase_possession_teleport", "0", true, true)

  -- Getters/setters --

  function ENT:IsPossessedByLocalPlayer()
    return self:IsPossessor(LocalPlayer())
  end

  -- Functions --

  -- Hooks --

  function ENT:PossessionHUD() end
  --[[hook.Add("HUDPaint", "DrGBasePossessionHUD", function()
    local ply = LocalPlayer()
    if not isfunction(ply.DrG_Possessing) then return end
    local possessing = ply:DrG_Possessing()
    if not IsValid(possessing) then return end
    local hookres = possessing:PossessionHUD()
    if hookres then return end
    DrGBase.DrawPossessionHUD(possessing)
  end)]]--

  function ENT:PossessionRender() end
	--[[hook.Add("RenderScreenspaceEffects", "DrGBasePossessionDraw", function()
    local ply = LocalPlayer()
    if not isfunction(ply.DrG_Possessing) then return end
    local possessing = ply:DrG_Possessing()
    if not IsValid(possessing) then return end
    possessing:PossessionRender()
  end)]]--

  function ENT:PossessionHalos() end
  --[[hook.Add("PreDrawHalos", "DrGBasePossessionHalos", function()
    local ply = LocalPlayer()
    if not isfunction(ply.DrG_Possessing) then return end
    local possessing = ply:DrG_Possessing()
    if not IsValid(possessing) then return end
    possessing:PossessionHalos()
  end)]]--

  -- Handlers --

end
