
-- Shooting
SWEP.Primary.Damage = 1
SWEP.Primary.Bullets = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0
SWEP.Primary.Recoil = 0

-- Ammo
SWEP.Primary.Ammo	= "AR2"
SWEP.Primary.Cost = 1
SWEP.Primary.ClipSize	= 30
SWEP.Primary.DefaultClip = 90

-- Effects
SWEP.Primary.Sound = ""
SWEP.Primary.EmptySound = ""

function SWEP:CanPrimaryAttack()
	if self:GetPrimaryAmmoType() < 0 then return true end
	if self.Primary.ClipSize > 0 then
		return self.Weapon:Clip1() >= self.Primary.Cost
	else return self.Owner:GetAmmoCount(self.Primary.Ammo) >= self.Primary.Cost end
end
function SWEP:TriedToPrimaryAttack()
	self:EmitSound(self.Primary.EmptySound)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		if IsFirstTimePredicted() then
			self:TriedToPrimaryAttack()
		end
		return false
	end
	if IsFirstTimePredicted() and self:PrePrimaryAttack() == false then return false end
	if IsFirstTimePredicted() then self:FirePrimary() end
	self:EmitSound(self.Primary.Sound)
	if SERVER then
		self:TakePrimaryAmmo(self.Primary.Cost)
		if self.Owner:IsPlayer() then
			local eyeangles = self.Owner:EyeAngles()
			eyeangles.p = eyeangles.p - self.Primary.Recoil
			self.Owner:SetEyeAngles(eyeangles)
			self.Owner:ViewPunch(Angle(-self.Primary.Recoil/3, 0, 0))
		end
	end
	if IsFirstTimePredicted() then
		if self.Primary.Delay >= 0 then
			local delay = CurTime() + self.Primary.Delay
			self:SetNextPrimaryFire(delay)
			self:PostPrimaryAttack(delay)
		else self:PostPrimaryAttack(CurTime()) end
	end
	return true
end
function SWEP:PrePrimaryAttack() end
function SWEP:FirePrimary()
	self:ShootBullet(self.Primary.Damage, self.Primary.Bullets, self.Primary.Spread)
end
function SWEP:PostPrimaryAttack() end
