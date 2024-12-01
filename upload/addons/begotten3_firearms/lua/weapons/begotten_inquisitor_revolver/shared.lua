-- Phoenix Project © 2016
SWEP.VElements = {
	["sight"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.2, 5.9, 3.635), angle = Angle(1.169, -178.831, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "reduxweapon/weapons/wpn_helsing", skin = 0, bodygroup = {} },
	["hellsing"] = { type = "Model", model = "models/arxweapon/hellsing.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.059, 1.621, -3.008), angle = Angle(88.406, 92.004, -0.408), size = Vector(0.828, 0.828, 0.828), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 3, [1] = 8, [2] = 1} }
}

SWEP.WElements = {
	["hellsing"] = { type = "Model", model = "models/arxweapon/hellsing.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, 0.6, 0.4), angle = Angle(-162.469, 180, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 3, [1] = 8, [2] = 1} }
}

SWEP.Gun = ("begotten_inquisitor_revolver") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.PrintName				= "Inquisitor Revolver"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 28			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- Set false if you want no crosshair from hip
SWEP.Weight				= 30			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= false		-- Is this a bolt action rifle?
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_rif_ak47.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/arxweapon/hellsing.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 					= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 


SWEP.Primary.Sound			= Sound("musket/musket1.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 250		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8		-- Size of a clip
SWEP.Primary.DefaultClip			= 0	-- Bullets you start with
SWEP.Primary.KickUp				= 2				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= .6			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= .5		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "pistol"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets


SWEP.data 				= {}
SWEP.data.ironsights		= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 37	-- Base damage per bullet
SWEP.Primary.Spread		= .1	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .05 -- Ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(6.239, -3.016, 1.809)
SWEP.IronSightsAng = Vector(0, 0, 2.111)
SWEP.SightsPos = Vector (6.239, -3.016, 1.809)
SWEP.SightsAng = Vector (0, 0, 2.111)
SWEP.RunSightsPos = Vector(0, -18.894, -6.83)
SWEP.RunSightsAng = Vector(70, 1.406, 0.703)

SWEP.ViewModelBoneMods = {
	["v_weapon.AK47_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.AmmoTypes = {
	["Pop-a-Shot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("musket/musket1.wav");
		SWEP.Primary.SoundLevel = 400;
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 37;
		SWEP.Primary.Spread = .1;
		SWEP.Primary.IronAccuracy = .05;
		SWEP.Primary.Ammo = "pistol";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .02;
						SWEP.Primary.IronAccuracy = .0075;
					else
						SWEP.Primary.Spread = .025;
						SWEP.Primary.IronAccuracy = .01;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .045;
						SWEP.Primary.IronAccuracy = .0225;
					else
						SWEP.Primary.Spread = .05;
						SWEP.Primary.IronAccuracy = .025;
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
				util.Effect( "effect_awoi_smoke_pistol", effect );

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 0.5)
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


