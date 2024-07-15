
SWEP.Secondary.Enabled = false

-- Shooting
SWEP.Secondary.Damage = 1
SWEP.Secondary.Bullets = 1
SWEP.Secondary.Spread = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0
SWEP.Secondary.Recoil = 0

-- Ammo
SWEP.Secondary.Ammo	= ""
SWEP.Secondary.Cost = 1
SWEP.Secondary.ClipSize	= 0
SWEP.Secondary.DefaultClip = 0

-- Effects
SWEP.Secondary.Sound = ""
SWEP.Secondary.EmptySound = ""

function SWEP:CanSecondaryAttack()
	if not self.Secondary.Enabled then return false end
	if self:GetSecondaryAmmoType() < 0 then return true end
	if self.Secondary.ClipSize > 0 then
		return self.Weapon:Clip2() >= self.Secondary.Cost
	else return self.Owner:GetAmmoCount(self.Secondary.Ammo) >= self.Secondary.Cost end
end
function SWEP:TriedToSecondaryAttack()
	self:EmitSound(self.Secondary.EmptySound)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end
function SWEP:SecondaryAttack()
	if not self.Secondary.Enabled then return false end
	if not self:CanSecondaryAttack() then
		if IsFirstTimePredicted() then
			self:TriedToSecondaryAttack()
		end
		return false
	end
	if IsFirstTimePredicted() and self:PreSecondaryAttack() == false then return false end
	if IsFirstTimePredicted() then self:FireSecondary() end
	self:EmitSound(self.Secondary.Sound)
	if SERVER then
		self:TakeSecondaryAmmo(self.Secondary.Cost)
		if self.Owner:IsPlayer() then
			local eyeangles = self.Owner:EyeAngles()
			eyeangles.p = eyeangles.p - self.Secondary.Recoil
			self.Owner:SetEyeAngles(eyeangles)
		end
	end
	if IsFirstTimePredicted() then
		if self.Secondary.Delay >= 0 then
			local delay = CurTime() + self.Secondary.Delay
			self:SetNextSecondaryFire(delay)
			self:PostSecondaryAttack(delay)
		else self:PostSecondaryAttack(CurTime()) end
	end
	return true
end
function SWEP:PreSecondaryAttack() end
function SWEP:FireSecondary()
	self:ShootBullet(self.Secondary.Damage, self.Secondary.Bullets, self.Secondary.Spread)
end
function SWEP:PostSecondaryAttack() end
