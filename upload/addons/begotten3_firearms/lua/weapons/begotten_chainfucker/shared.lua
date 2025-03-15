SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/arxweapon/gatling.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(14.321, 1.48, 10.369), angle = Angle(5.556, -10, -81.112), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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

SWEP.ShowViewModel = false;
SWEP.UseHands = true
SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"		-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base 				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = true
SWEP.noDisarm = true;
SWEP.noJam = true;

SWEP.Primary.Sound			= Sound("gatling/gatling_close_shot_4.mp3")		-- Script that calls the primary fire sound
SWEP.Primary.FarSound 		= Sound("gatling/gatling_close_shot_4_distant.mp3");
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

function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if self.Owner:IsPlayer() then
		if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
			local aimcone;
			
			if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
				aimcone = self.Primary.IronAccuracy
			else
				aimcone = self.Primary.Spread
			end
				
			local bullet = {}
			bullet.Num              = self.Primary.NumShots
			bullet.Src              = self.Owner:GetShootPos()                      -- Source
			bullet.Dir              = self.Owner:GetAimVector()                     -- Dir of bullet
			bullet.Spread   = Vector(aimcone, aimcone, 0)                   -- Aim Cone
			bullet.Tracer   = 3                                                     -- Show a tracer on every x bullets
			bullet.TracerName = "Tracer"
			bullet.AmmoType = "SMG1"
			bullet.Force    = self.Primary.Damage * 0.25                                 -- Amount of force to give to phys objects
			bullet.Damage   = self.Primary.Damage
			bullet.Callback = function(attacker, tracedata, dmginfo)
				dmginfo:SetInflictor(self);
			end
			
			if SERVER then
				local playerTab = {};
				local farPlayers = {};

				if zones then
					playerTab = zones:GetPlayersInSupraZone(zones:GetPlayerSupraZone(self.Owner));
				else
					playerTab = _player.GetAll();
				end
				
				local pos = self.Owner:GetPos();
				
				-- Close sound.
				local filter = RecipientFilter();
				
				for i, v in ipairs(playerTab) do
					if v:GetPos():Distance(pos) < 1600 then
						filter:AddPlayer(v);
					else
						table.insert(farPlayers, v);
					end
				end
				
				self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
				
				filter = RecipientFilter();
				
				-- Far sound.
				for i, v in ipairs(farPlayers) do
					filter:AddPlayer(v);
				end
				
				if math.random(1, 3) == 3 then -- this is ghetto
					self.Weapon:EmitSound(self.Primary.FarSound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
				end
			end

			self:ShootEffects()
			self.Owner:FireBullets(bullet)
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			--self.Weapon:EmitSound(self.Primary.Sound, 511, math.random(95, 102));
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:MuzzleFlash()
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		end
	end
end