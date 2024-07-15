if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "proj_drg_default"

-- Misc --
ENT.PrintName = "Plasma Ball"
ENT.Category = "DrGBase"
ENT.AdminOnly = true
ENT.Spawnable = true

-- Physics --
ENT.Gravity = false
ENT.Physgun = false
ENT.Gravgun = true

-- Contact --
ENT.OnContactDecals = {"Scorch"}

-- Sounds --
ENT.LoopSounds = {}
ENT.OnContactSounds = {"weapons/stunstick/stunstick_fleshhit1.wav"}
ENT.OnRemoveSounds = {}

-- Effects --
ENT.AttachEffects = {"drg_plasma_ball"}
ENT.OnContactEffects = {}
ENT.OnRemoveEffects = {}

if SERVER then
	AddCSLuaFile()

	function ENT:CustomInitialize()
		self:DynamicLight(Color(150, 255, 0), 300, 0.1)
	end

	function ENT:CustomThink()
		if not self:GetPhysicsObject():IsGravityEnabled() then
			local velocity = self:GetVelocity()
			self:SetVelocity(velocity:GetNormalized()*500)
		end
	end

	function ENT:OnContact(ent)
		if ent:GetClass() == self:GetClass() then
			self:Remove()
			ent:Remove()
		else self:DealDamage(ent, ent:Health(), DMG_SHOCK + DMG_DISSOLVE) end
		if self:GetPhysicsObject():IsGravityEnabled() then self:Remove() end
	end

end
