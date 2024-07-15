SWEP.IsDrGWeapon = true

-- Misc --
SWEP.PrintName = ""
SWEP.Category = ""
SWEP.Author = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions	= ""
SWEP.Spawnable = false
SWEP.AdminOnly = false

-- Looks --
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip = true
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelAngle = Angle(0, 0, 0)
SWEP.UseHands = false
SWEP.ViewModel = ""
SWEP.WorldModel	= ""
SWEP.CSMuzzleFlashes = false
SWEP.CSMuzzleX = false

DrGBase.IncludeFile("misc.lua")
DrGBase.IncludeFile("primary.lua")
DrGBase.IncludeFile("secondary.lua")

function SWEP:Initialize()
	if SERVER then
		self:SetHoldType(self.HoldType)
	end
	self:_BaseInitialize()
	self:CustomInitialize()
end
function SWEP:_BaseInitialize() end
function SWEP:CustomInitialize() end

function SWEP:Think()
	self:_BaseThink()
	self:CustomThink()
end
function SWEP:_BaseThink() end
function SWEP:CustomThink() end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

if CLIENT then

	function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
		local aimpos = pos +
		self.Owner:GetForward()*self.ViewModelOffset.x +
		self.Owner:GetUp()*self.ViewModelOffset.z
		if self.ViewModelFlip then
			aimpos = aimpos - self.Owner:GetRight()*self.ViewModelOffset.y
		else aimpos = aimpos + self.Owner:GetRight()*self.ViewModelOffset.y end
		local aimang = ang + self.ViewModelAngle
		return aimpos, aimang
	end

end
