SWEP.Gun = ("begotten_sweeper") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Author				= "DETrooper"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Sweeper"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 89			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"	-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

--SWEP.Shotgun = true --Enable shotgun style reloading.

SWEP.ViewModel			= "models/weapons/v_nik_trenchy.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 70		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= false	-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.WorldModel = "models/weapons/w_nik_trenchy.mdl" -- Weapon world model path
SWEP.Base 				= "begotten_firearm_base"
SWEP.ShowWorldModel			= false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound 			= Sound("weapons/en/m3-1.wav")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.RPM				= 40		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 3.9					-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 2.6					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.4					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= 0.55 -- For shotguns, how long it takes to insert a shell.

SWEP.Primary.NumShots = 32;
SWEP.Primary.Damage = 8;
SWEP.Primary.Spread = .175;
SWEP.Primary.IronAccuracy = .175;
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(2.809, 0, 1.48)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-2.08, 1, 0.725)
SWEP.SightsAng = Vector(2.5, 0, -2.5)
SWEP.RunSightsPos = Vector(5, -1, -1)
SWEP.RunSightsAng = Vector(-7, 20, 5)

SWEP.IgnoresBulletResistance = true;

SWEP.AmmoTypes = {
	["Old World Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/nikm1987trench/trigger.wav");
		SWEP.Primary.NumShots = 32;
		SWEP.Primary.Damage = 8;
		SWEP.Primary.Spread = .175;
		SWEP.Primary.IronAccuracy = .175;
		SWEP.Primary.Ammo = "buckshot";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .075;
						SWEP.Primary.IronAccuracy = .075;
					else
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .125;
						SWEP.Primary.IronAccuracy = .125;
					else
						SWEP.Primary.Spread = .15;
						SWEP.Primary.IronAccuracy = .15;
					end
				end
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
				
				timer.Simple(0.25, function()
					if IsValid(self.Owner) and self.Owner:Alive() then
						self.Owner:EmitSound("weapons/nikm1987trench/pump.wav");
					end
				end);

				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1)
				--self:CheckWeaponsAndAmmo()
				--self.RicochetCoin = (math.random(1,4))
				
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

SWEP.WElements = {
	["w_sweeper"] = { type = "Model", model = "models/weapons/w_nik_trenchy.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1.5, 1.557), angle = Angle(-15.195, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}