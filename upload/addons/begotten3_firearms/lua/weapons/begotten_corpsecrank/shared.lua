SWEP.Gun = ("begotten_repeatingmusket2") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Author				= "gabs"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Corpsecrank"		-- Weapon name (Shown on HUD)
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

SWEP.ViewModel			= "models/weapons/v_shot_enforcer.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 69		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true	-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.WorldModel = "models/weapons/w_shot_enforcer.mdl" -- Weapon world model path
SWEP.Base 				= "begotten_firearm_base"
SWEP.ShowWorldModel			= false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound 			= Sound("weapons/en/m3-1.wav")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.RPM				= 45		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp			= 4.70					-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 0.31					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.04					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.ScopeZoom			= 30
SWEP.Secondary.UseClosedSight = true;
SWEP.Secondary.IronFOV			= 30		-- How much you 'zoom' in. Less is more! 
SWEP.ScopeScale 			= 0.6

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= 0.55 -- For shotguns, how long it takes to insert a shell.

SWEP.Primary.NumShots = 32;
SWEP.Primary.Damage = 8;
SWEP.Primary.Spread = .18;
SWEP.Primary.IronAccuracy = .18;
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(4.679, -4.459, 1.799)
SWEP.SightsAng = Vector(-0.352, -0.383, 0)
SWEP.RunSightsPos = Vector(-0.731, -3.787, -0.224)
SWEP.RunSightsAng = Vector(-2.599, -33.813, 0)

SWEP.AmmoTypes = {
	["Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/en/m3-1.wav");
		SWEP.Primary.NumShots = 32;
		SWEP.Primary.Damage = 8;
		SWEP.Primary.Spread = .18;
		SWEP.Primary.IronAccuracy = .18;
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

				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());
				util.Effect( "effect_awoi_smoke_pistol", effect );

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1)
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

SWEP.WElements = {
	["w_corpsecrank"] = { type = "Model", model = "models/weapons/w_shot_enforcer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1.5, 1.557), angle = Angle(-15.195, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}