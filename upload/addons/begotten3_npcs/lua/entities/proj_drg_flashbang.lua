if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "proj_drg_grenade"

-- Misc --
ENT.PrintName = "Flash Grenade"
ENT.Category = "DrGBase"
ENT.Models = {"models/weapons/w_eq_flashbang.mdl"}
ENT.Spawnable = true

-- Grenade --
ENT.Bounce = 1
ENT.OnBounceSounds = {"weapons/flashbang/grenade_hit1.wav"}

if SERVER then
  AddCSLuaFile()

  function ENT:CustomInitialize()
    self:SetRange(1000)
  end

  util.AddNetworkString("DrGBaseFlashGrenade")
  function ENT:OnDetonate()
    self:EmitSound("weapons/flashbang/flashbang_explode2.wav")
    net.Start("DrGBaseFlashGrenade")
    net.WriteInt(self:EntIndex(), 32)
    net.WriteVector(self:GetPos())
    net.WriteFloat(self:GetRange())
    net.Broadcast()
    local blind = DrGBase.Blind()
    blind:SetDuration(3)
    local owner = self:GetOwner()
    blind:SetAttacker(IsValid(owner) and owner or self)
    blind:SetInflictor(self)
    for i, ent in ipairs(ents.FindInSphere(self:GetPos(), self:GetRange())) do
      if ent:IsPlayer() and ent:Alive() then
        ent:ScreenFade(SCREENFADE.IN, nil, 3, 0)
      elseif ent.IsDrGNextbot then ent:Blind(blind) end
    end
  end

else

  net.Receive("DrGBaseFlashGrenade", function()
    local dlight = DynamicLight(net.ReadInt(32))
    dlight.pos = net.ReadVector()
    dlight.dieTime = CurTime() + 0.5
    dlight.decay = 2000
    dlight.size = net.ReadFloat()
    dlight.brightness = 10
    dlight.r = 1
    dlight.g = 1
    dlight.b = 1
  end)

end
