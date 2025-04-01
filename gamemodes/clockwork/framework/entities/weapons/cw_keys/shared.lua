--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.Slot = 5
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Keys"
end

SWEP.Instructions 			= "Primary Fire: Lock.\nSecondary Fire: Unlock."
SWEP.Purpose 				= "Locking and unlocking entities that you have access to."
SWEP.Contact 				= "Cloudsixteen.com"
SWEP.Author					= "Cloudsixteen"

SWEP.WorldModel 			= ""
SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.HoldType 				= "fist"

SWEP.AdminSpawnable 		= false
SWEP.Spawnable 				= false

SWEP.Primary.DefaultClip 	= 0
SWEP.Primary.Automatic 		= true
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.Damage 		= 1
SWEP.Primary.Ammo 			= ""

SWEP.Secondary.DefaultClip 	= 0
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.Ammo			= ""

SWEP.NoIronSightFovChange 	= true
SWEP.NoIronSightAttack 		= true
SWEP.IronSightPos 			= Vector(0, 0, 0)
SWEP.IronSightAng 			= Vector(0, 0, 0)
SWEP.NeverRaised 			= true
SWEP.LoweredAngles 			= Angle(0.000, 0.000, -22.000)

--[[Bunch of key functionality bullshit.]]--

-- Called when the SWEP is deployed.
--[[function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))

	return true
end

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER)
	return true
end]]--

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)

	if (SERVER) then
		local action = Clockwork.player:GetAction(self.Owner)
		local trace = self.Owner:GetEyeTraceNoCursor()

		if (self.Owner:GetPos():Distance(trace.HitPos) > 192
		or !IsValid(trace.Entity)) then
			return
		end

		local info = hook.Run("PlayerGetLockInfo", self.Owner, trace.Entity)

		if (info and hook.Run("PlayerCanLockEntity", self.Owner, trace.Entity)) then
			local isNotUnlocking = (action != "unlock")
			local isNotLocking = (action != "lock")

			if (isNotLocking or isNotUnlocking) then
				Clockwork.player:SetAction(self.Owner, "lock", info.duration)
				Clockwork.player:EntityConditionTimer(self.Owner, trace.Entity, nil, info.duration, 192,
					function()
						return (hook.Run("PlayerCanLockEntity", self.Owner, trace.Entity)
						and self.Owner:Alive() and !self.Owner:IsRagdolled() and self.Owner:IsUsingKeys())
					end,
					function(success)
						if (success) then
							info.Callback(self.Owner, trace.Entity)

							if (!info.noSound) then
								self.Owner:EmitSound("doors/door_latch3.wav")
							end
						else
							Clockwork.player:SetAction(self.Owner, "lock", false)
						end
					end
				)
			end
		end
	end
end

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)

	if (SERVER) then
		local action = Clockwork.player:GetAction(self.Owner)
		local trace = self.Owner:GetEyeTraceNoCursor()

		if (self.Owner:GetPos():Distance(trace.HitPos) > 192
		or !IsValid(trace.Entity)) then
			return
		end

		local info = hook.Run("PlayerGetUnlockInfo", self.Owner, trace.Entity)

		if (info and hook.Run("PlayerCanUnlockEntity", self.Owner, trace.Entity)) then
			local isNotUnlocking = (action != "unlock")
			local isNotLocking = (action != "lock")

			if (isNotLocking or isNotUnlocking) then
				Clockwork.player:SetAction(self.Owner, "unlock", info.duration)
				Clockwork.player:EntityConditionTimer(self.Owner, trace.Entity, nil, info.duration, 192,
					function()
						return (hook.Run("PlayerCanUnlockEntity", self.Owner, trace.Entity)
						and self.Owner:Alive() and !self.Owner:IsRagdolled() and self.Owner:IsUsingKeys())
					end,
					function(success)
						if (success) then
							info.Callback(self.Owner, trace.Entity)

							if (!info.noSound) then
								self.Owner:EmitSound("doors/door_latch3.wav")
							end
						else
							Clockwork.player:SetAction(self.Owner, "unlock", false)
						end
					end
				)
			end
		end
	end
end