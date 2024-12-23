-- Phoenix Project © 2016
SWEP.VElements = {
	["gatling"] = { type = "Model", model = "models/arxweapon/gatling.mdl", bone = "cgun1", rel = "", pos = Vector(-2.597, -1.558, -9.87), angle = Angle(-90, -90, -180), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 1, [2] = 1} },
	["stvol"] = { type = "Model", model = "models/arxweapon/gatling_dulo.mdl", bone = "BONE_BARRELS", rel = "", pos = Vector(-0, -5.715, -0.301), angle = Angle(1.169, -90, 0), size = Vector(0.629, 0.629, 0.629), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["gatling"] = { type = "Model", model = "models/arxweapon/gatling.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.026, 2.596, -3.636), angle = Angle(0, 0, 180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[2] = 1} }
}

SWEP.Gun = ("begotten_chainfucker") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Author				= "gabs"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Chainfucker"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 23			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType = "physgun"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SelectiveFire		= true

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel = "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"		-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = true
SWEP.noJam = true;

SWEP.Primary.Sound			= Sound("gatling/gatling_close_shot_4.mp3")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 1200			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 200		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 0		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 40	-- Base damage per bullet
SWEP.Primary.Spread		= .1	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .1 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-4.08, -4.02, -0.171)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0.6, 0, 2.68)
SWEP.RunSightsAng = Vector(-9.849, 9.848, 0)
SWEP.ViewModelBoneMods = {
	["bigfathand"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["handlemini"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["chainstuff"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cgun1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["main_body-"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["barrelbox"] = { scale = Vector(0.018, 0.018, 0.018), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["chain_pin"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["barrels"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Bone01"] = { scale = Vector(0.222, 0.222, 0.222), pos = Vector(1.296, -4.631, 2.407), angle = Angle(0, 0, 0) },
	["Bone_Lefthand"] = { scale = Vector(1, 1, 1), pos = Vector(3.519, 0.185, -6.481), angle = Angle(0, 0, 0) },
	["BONE_AMMO_CHAIN"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cgun2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["trigger"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["BONE_BARRELS"] = { scale = Vector(1, 1, 1), pos = Vector(-2.779, -10.556, 1.296), angle = Angle(0, 0, 0) }
}

function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if self.Owner:IsPlayer() then
		if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
			self:ShootBulletInformation()
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Weapon:EmitSound(self.Primary.Sound, 511, math.random(95, 102));
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:MuzzleFlash()
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		end
	end
end