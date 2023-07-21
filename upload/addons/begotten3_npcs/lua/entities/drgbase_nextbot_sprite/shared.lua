ENT.Base = "drgbase_nextbot"
ENT.IsDrGNextbotSprite = true

-- Misc --
ENT.Models = {"models/props_lab/blastdoor001a.mdl"}
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

-- Animations --
DrGBase.IncludeFile("animations.lua")
ENT.SpriteFolder = ""
ENT.FramesPerSecond = 10
ENT.WalkAnimation = "walk"
ENT.RunAnimation = "run"
ENT.IdleAnimation = "idle"
ENT.JumpAnimation = "jump"

-- Movements --
ENT.WalkSpeed = 100
ENT.RunSpeed = 200

-- Climbing --
ENT.ClimbUpAnimation = "climb"
ENT.ClimbDownAnimation = "climb"
ENT.ClimbOffset = Vector(-10, 0, 0)

-- Detection --
ENT.SightFOV = 360

-- Misc --

function ENT:IsAttack(anim)
  if self:GetNW2Bool("DrGBaseAnimAttacks/"..anim) then return true
  else return string.find(string.lower(anim), "attack") ~= nil end
end

if SERVER then
  AddCSLuaFile()

  -- Movements --

  function ENT:UpdateSpeed()
    local speed = self:OnUpdateSpeed()
    if isnumber(speed) then self:SetSpeed(math.Clamp(speed, 0, math.huge)) end
  end

  -- Misc --

  function ENT:IsAttacking()
    return self:IsAttack(self:GetSpriteAnim())
  end
  function ENT:SetAttack(anim, attack)
    self:SetNW2Bool("DrGBaseAnimAttacks/"..anim, attack)
  end

  function ENT:SequenceAttack() end
  function ENT:SpriteAnimAttack(anim, frame, attack, callback)
    if istable(anim) then
      for i, anim in ipairs(anim) do self:SetAttack(anim, true) end
    else self:SetAttack(anim, true) end
    self:SpriteAnimEvent(anim, frame, function(self)
      self:Attack(attack, callback)
    end)
  end

else

  local function DrawSprite(self, anim)
    local height = self:Height()
    local pos = self:GetPos() + Vector(0, 0, height/2)
    local sprite = self:GetSpriteFolder()..anim..self:GetSpriteFrame()..".png"
    render.DrG_DrawSprite(sprite, pos, height, {
      origin = self:IsPossessedByLocalPlayer() and self:GetPos()-self:PossessorForward(),
      color = self:GetColor(), lighting = true, flip = self:ShouldFlipSprite()
    })
  end
  function ENT:ShouldFlipSprite() return false end

  function ENT:DrawTranslucent()
    if DrGBase.INFO_TOOL.Viewcam then
      local selected = LocalPlayer():DrG_GetSelectedEntities()[1]
      if selected == self then return end
    end
    if self:ShouldDraw() then
      local anim = self:GetSpriteAnim()
      if anim ~= "" then
        if self:SpriteAnim8Dir(anim) then
          DrawSprite(self, string.lower(self:CalcPosDirection(EyePos(), true)).."_"..anim)
        elseif self:SpriteAnim4Dir(anim) then
          DrawSprite(self, string.lower(self:CalcPosDirection(EyePos(), false)).."_"..anim)
        else DrawSprite(self, anim) end
      end
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

end
