-- Phoenix Project © 2016
SWEP.VElements = {
	["ashot"] = { type = "Model", model = "models/arxweapon/ashot.mdl", bone = "doublebarr", rel = "", pos = Vector(-0.201, -0.519, 0.518), angle = Angle(90, -85.325, -8.183), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["ashot"] = { type = "Model", model = "models/arxweapon/ashot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.5, -2.201), angle = Angle(-171.818, -176.495, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Gun = ("guard_blunderbuss") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Author				= "gabs"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= "Click the trigger to fire, use the Right click to aim the sights."
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Guard Blunderbuss"		-- Weapon name (Shown on HUD)	
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

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/arxweapon/v_doublebarrl.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_airgun.mdl"	-- Weapon world model
SWEP.Base 				= "begotten_firearm_base"
SWEP.ShowWorldModel			= false
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Sound			= Sound("others/ubo_4.mp3")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 60		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 7			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp				= 0.2				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.2		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.2	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .35

SWEP.Primary.NumShots	= 22		//how many bullets to shoot, use with shotguns
SWEP.Primary.Damage		= 6	//base damage, scaled by game
SWEP.Primary.Spread		= .2	//define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .2 // has to be the same as primary.spread
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-2.8, -1.81, 1.84)
SWEP.SightsAng = Vector(-0.801, 0, 4.221)
SWEP.RunSightsPos = Vector(-0.201, 0, -0.04)
SWEP.RunSightsAng = Vector(-5.628, 32.361, 0)

SWEP.ViewModelBoneMods = {
	["barrels"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["doublebarr"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["shell"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["shells"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.AmmoTypes = {
	["Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("others/ubo_4.mp3");
		SWEP.Primary.NumShots = 22;
		SWEP.Primary.Damage = 20;
		SWEP.Primary.Spread = .1;
		SWEP.Primary.IronAccuracy = .1;
		SWEP.Primary.Ammo = "buckshot";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
					else
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
					else
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
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
		if self.Owner:IsPlayer() then
			if 1 + 1 == 2 then
				--if !self:AdjustFireBegotten() then
					--return;
				--end
				
				self:ShootBulletInformation();
			--	self.Weapon:TakeAmmo(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
				--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				self.Weapon:EmitSound(self.Primary.Sound)

				--[[timer.Simple(0.6,function() if self:IsValid() then self.Owner:EmitSound("weapons/357/357_reload3.wav") end end)						
				timer.Simple(1.6,function() if self:IsValid() then self.Owner:EmitSound("physics/metal/metal_grenade_impact_hard1.wav") end end)
				timer.Simple(2,function() if self:IsValid() then self.Owner:EmitSound("weapons/357/357_reload4.wav") end end)]]--  

				--local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
			--	effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
			--	effect:SetNormal( self.Owner:GetAimVector());
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