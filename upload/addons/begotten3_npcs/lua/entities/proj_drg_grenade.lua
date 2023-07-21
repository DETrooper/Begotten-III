if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "proj_drg_default"
ENT.IsDrGGrenade = true

-- Misc --
ENT.PrintName = "HE Grenade"
ENT.Category = "DrGBase"
ENT.Models = {"models/weapons/w_eq_fraggrenade.mdl"}
ENT.Spawnable = true

-- Physics --
ENT.Physgun = true
ENT.Gravgun = true

-- Grenade --
ENT.Bounce = 0.75
ENT.OnBounceSounds = {"weapons/hegrenade/he_bounce-1.wav"}

function ENT:GetDamage()
  return math.Clamp(self:GetNW2Float("DrGBaseDamage", 250), 0, math.huge)
end
function ENT:GetRange()
  return math.Clamp(self:GetNW2Float("DrGBaseRange", 250), 0, math.huge)
end
function ENT:GetDelay()
  return math.Clamp(self:GetNW2Float("DrGBaseDelay", 3), 0, math.huge)
end

function ENT:IsUnpined()
  return self:GetNW2Bool("DrGBaseUnpined")
end
function ENT:HasDetonated()
  return self:GetNW2Bool("DrGBaseDetonated")
end

if SERVER then
  AddCSLuaFile()

  function ENT:_BaseInitialize()
    self._DrGBaseBounceSoundDelay = 0
  end
  function ENT:OnContact(ent)
    if self:GetVelocity():IsZero() then return end
    self:Timer(0, function()
      self:SetVelocity(self:GetVelocity()*self.Bounce)
    end)
    if CurTime() < self._DrGBaseBounceSoundDelay then return end
    if istable(self.OnBounceSounds) and #self.OnBounceSounds > 0 then
      self._DrGBaseBounceSoundDelay = CurTime() + 0.25
      self:EmitSound(self.OnBounceSounds[math.random(#self.OnBounceSounds)])
    end
  end

  function ENT:Use()
    self:Unpin()
  end
  function ENT:OnTakeDamage()
    self:Timer(0.1, self.Detonate)
  end

  -- Grenade --

  function ENT:SetDamage(damage)
    self:SetNW2Float("DrGBaseDamage", damage)
  end
  function ENT:SetRange(range)
    self:SetNW2Float("DrGBaseRange", range)
  end
  function ENT:SetDelay(delay)
    self:SetNW2Float("DrGBaseDelay", delay)
  end

  function ENT:Unpin(mute)
    if self:IsUnpined() then return end
    if not mute then self:EmitSound("weapons/pinpull.wav") end
    self:SetNW2Bool("DrGBaseUnpined", true)
    self:Timer(self:GetDelay(), self.Detonate)
  end

  function ENT:Detonate()
    if self:HasDetonated() then return end
    self:SetNW2Bool("DrGBaseDetonated", true)
    if not self:OnDetonate() then self:Remove() end
  end
  function ENT:OnDetonate()
    self:Explosion(self:GetDamage(), self:GetRange())
  end

end
