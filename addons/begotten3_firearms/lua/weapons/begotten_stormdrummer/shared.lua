SWEP.WElements = {
	["stormdrummer"] = { type = "Model", model = "models/begotten/weapons/w_shagalaxlmg.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, 1, 2.849), angle = Angle(-8.183, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Variables that are used on both client and server
SWEP.Gun = ("bb_stormdrummer")					-- must be the name of your swep
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
SWEP.PrintName				= "Storm Drummer"		-- Weapon name (Shown on HUD)	
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
SWEP.ViewModel				= "models/begotten/weapons/c_shagalaxlmg.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/begotten/weapons/w_shagalaxlmg.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands 						= true

	-- Weapon world model
SWEP.Base				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("begotten/scraplmg/fire"..math.random(1,3)..".ogg")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 550			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 15		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 1.5		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.5		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 15	-- Base damage per bullet
SWEP.Primary.Spread		= .08	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .07 -- Ironsight accuracy, should be the same for shotguns

SWEP.SelectiveFire		= false
SWEP.RaiseSpeed = 3;

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.56, -4.02, 0.72)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-0.401, 0, -5.08)
SWEP.RunSightsAng = Vector(-8.443, 48.542, -42.916)

SWEP.AmmoTypes = {
	["Scrapshot"] = function(SWEP) -- Single chambered round.
		SWEP.Primary.Sound = Sound("begotten/scraplmg/fire"..math.random(1,3)..".ogg");
		SWEP.Primary.FarSound = Sound("begotten/scraplmg/fire"..math.random(1,3).."_distant.mp3");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 20;
		SWEP.Primary.Spread = .08;
		SWEP.Primary.IronAccuracy = .07;
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
	["Shagalax Bullet Box Magazine"] = function(SWEP)
		SWEP.Primary.Sound = Sound("begotten/scraplmg/fire"..math.random(1,3)..".ogg");
		SWEP.Primary.FarSound = Sound("begotten/scraplmg/fire"..math.random(1,3).."_distant.mp3");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 15;
		SWEP.Primary.Spread = .08;
		SWEP.Primary.IronAccuracy = .07;
		SWEP.Primary.ClipSize = 100;
		
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
};

function SWEP:PrimaryAttack()
	local curTime = CurTime();
	
	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if self:CanPrimaryAttack() then
		return 
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
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
					
					self.Owner:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
					
					filter = RecipientFilter();
					
					-- Far sound.
					for i, v in ipairs(farPlayers) do
						filter:AddPlayer(v);
					end
					
					self.Owner:EmitSound(self.Primary.FarSound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
				else
					self.Owner:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0);
				end
				
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
	elseif self:CanPrimaryAttack() and !self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		--self.Owner:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
		--self.RicochetCoin = (math.random(1,4))
	end
end
