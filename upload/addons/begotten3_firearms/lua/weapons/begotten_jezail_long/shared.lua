-- Phoenix Project © 2016
SWEP.VMPos = Vector(0.5, -4, 0.5) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0, 0, 0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.

SWEP.ViewModelBoneMods = {
	["v_ee3_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["jezail"] = { type = "Model", model = "models/sw_battlefront/weapons/jazail_long.mdl", bone = "v_ee3_reference001", rel = "", pos = Vector(0.2, -2, 1.5), angle = Angle(0, 0, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["cycler"] = { type = "Model", model = "models/sw_battlefront/weapons/jazail_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -1.201), angle = Angle(180, 90, -8), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Gun = ("begotten_jezail_long") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Long Jezail"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 89			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"	-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/synbf3/c_ee3.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/synbf3/w_e11.mdl"	-- Weapon world model
SWEP.Base 				= "begotten_firearm_base"
SWEP.ShowWorldModel			= false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.UseHands 						= true

SWEP.Primary.Sound			= Sound("v51_"..math.random(1,4)..".ogg")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 32		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 15			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp				= 30				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.6	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "smg"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.ScopeZoom			= 30
SWEP.Secondary.IronFOV			= 25		-- How much you 'zoom' in. Less is more! 
SWEP.Secondary.UseSVD			= true

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.5
SWEP.ReticleScale 			= 0.75

SWEP.ShellTime			= .35

SWEP.Primary.NumShots	= 1		//how many bullets to shoot, use with shotguns
SWEP.Primary.Damage		= 105	//base damage, scaled by game
SWEP.Primary.Spread		= .1	//define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .035 // has to be the same as primary.spread
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-4.761, -11.658, 3.2)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.IronSightsPos = Vector(-4.761, -11.658, 3.2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, -0.801)
SWEP.RunSightsAng = Vector(-7.739, 33.064, -0.704)

SWEP.AmmoTypes = {
	["Longshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("v51_"..math.random(1,4)..".ogg");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 105;
		SWEP.Primary.Spread = .1;
		SWEP.Primary.IronAccuracy = .035;
		SWEP.Primary.Ammo = "smg";
		
		SWEP.Primary.KickUp				= 15		-- Maximum up recoil (rise)
		SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
		SWEP.Primary.KickHorizontal		= 1		-- Maximum up recoil (stock)
				
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .02;
						SWEP.Primary.IronAccuracy = .0050;
					else
						SWEP.Primary.Spread = .015;
						SWEP.Primary.IronAccuracy = .0075;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .035;
						SWEP.Primary.IronAccuracy = .015;
					else
						SWEP.Primary.Spread = .045;
						SWEP.Primary.IronAccuracy = .015;
					end
				end
			end
		end
		
		return true;
	end
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
				
				if SERVER then
					local filter = RecipientFilter();
					
					if zones then
						filter:AddPlayers(zones:GetPlayersInSupraZone(zones:GetPlayerSupraZone(self.Owner)));
					else
						filter:AddAllPlayers();
					end
					
					self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
				else
					self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0);
				end
				
				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());
				util.Effect("effect_awoi_smoke", effect);

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
				
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
	end
end