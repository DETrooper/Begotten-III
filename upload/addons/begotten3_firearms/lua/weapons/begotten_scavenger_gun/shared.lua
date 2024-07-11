SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -20), angle = Angle(0, 0, 0) },
	["tag_view"] = { scale = Vector(1, 1, 1), pos = Vector(11.17, -2.59, 0.649), angle = Angle(0.5, 0.8, -3.5) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-2, 0, 0), angle = Angle(0, 0, 0) },
	["tag_weapon"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.556, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.556, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(2, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2, 0, -20), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.926, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_scavgun"] = { type = "Model", model = "models/weapons/v_smg_mothgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.676, 1, 2.596), angle = Angle(-0.95, -1.951, -174.157), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["mothgun"] = { type = "Model", model = "models/weapons/w_smg_mothgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.676, 0.518, 2.596), angle = Angle(-10.52, -1.17, -167.144), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Variables that are used on both client and server
SWEP.Gun = ("bb_scavgun")					-- must be the name of your swep
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "Begotten"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Scavenger Gun"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 79			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_rust_m1a1.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/doi/w_1911.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands 						= true

	-- Weapon world model
SWEP.Base				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons_moth/p90-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 650			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 15		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 2		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 30	-- Base damage per bullet
SWEP.Primary.Spread		= .2	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .15 -- Ironsight accuracy, should be the same for shotguns

SWEP.SelectiveFire		= false

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-4.341, -9.247, 2.869)
SWEP.SightsAng = Vector(-2.8, -2.201, 2.111)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-11.961, 34.472, -16.181)

SWEP.AmmoTypes = {
	["Scrapshot"] = function(SWEP) -- Single chambered round.
		SWEP.Primary.Sound = Sound("weapons_moth/p90-1.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 30;
		SWEP.Primary.Spread = .2;
		SWEP.Primary.IronAccuracy = .15;
		SWEP.Primary.ClipSize = 1;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .05;
						SWEP.Primary.IronAccuracy = .03;
					else
						SWEP.Primary.Spread = .075;
						SWEP.Primary.IronAccuracy = .065;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .085;
						SWEP.Primary.IronAccuracy = .07;
					else
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .085;

					end
				end
			end
		end
		
		return true;
	end,
	["Scavenger Gun Magazine"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons_moth/p90-1.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 27;
		SWEP.Primary.Spread = .15;
		SWEP.Primary.IronAccuracy = .09;
		SWEP.Primary.ClipSize = 15;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") and SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				SWEP.Primary.Spread = .07;
				SWEP.Primary.IronAccuracy = .06;
			end
		end
		
		return true;
	end,
	["Scavenger Gun Large Magazine"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons_moth/p90-1.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 27;
		SWEP.Primary.Spread = .15;
		SWEP.Primary.IronAccuracy = .09;
		SWEP.Primary.ClipSize = 25;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") and SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				SWEP.Primary.Spread = .07;
				SWEP.Primary.IronAccuracy = .06;
			end
		end
		
		return true;
	end,
};

function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if IsFirstTimePredicted() then
		if self.Owner:IsPlayer() and self:CanFireBegotten() then
			if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
				if !self:AdjustFireBegotten() then
					return;
				end
				
				self:ShootBulletInformation();
				self.Weapon:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
				--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Weapon:EmitSound(self.Primary.Sound)

				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());
				--util.Effect( "effect_awoi_smoke_pistol", effect );

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
				--self:CheckWeaponsAndAmmo()
				--self.RicochetCoin = (math.random(1,4))
				
				if self.BoltAction then 
					self:BoltBack() 
				end
				
				if SERVER then
					self.Owner.cloakCooldown = CurTime() + 30;
				end
			end
		end
	elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
		--self.RicochetCoin = (math.random(1,4))
	end
end