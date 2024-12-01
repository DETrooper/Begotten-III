
-- Variables that are used on both client and server
SWEP.Gun = ("bb_pipeipistol")					-- must be the name of your swep
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
SWEP.PrintName				= "Peppershot"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 36			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel = "models/weapons/v_pist_pipe.mdl"      
SWEP.WorldModel = "models/weapons/w_airgun.mdl"
SWEP.ShowWorldModel = false
SWEP.Base				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons_pipegun/p228-1.wav")
SWEP.Primary.Delay = 1                         
SWEP.Primary.RPM			= 300			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 10		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 37	-- Base damage per bullet
SWEP.Primary.Spread		= .1	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .05 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-4.79, -1.005, 1.2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-4.79, -1.005, 1.2)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-2.345, -8.233, -5.493)
SWEP.RunSightsAng = Vector(70, 0, 0)

SWEP.AmmoTypes = {
	["Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("duplet/shotgun_close_2.mp3");
		SWEP.Primary.SoundLevel = 511;
		SWEP.Primary.NumShots = 24;
		SWEP.Primary.Damage = 7;
		SWEP.Primary.Spread = .45;
		SWEP.Primary.IronAccuracy = .45;
		SWEP.Primary.Ammo = "buckshot";
		
		SWEP.Primary.KickUp				= 125		-- Maximum up recoil (rise)
		SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
		SWEP.Primary.KickHorizontal		= 25		-- Maximum up recoil (stock)
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .22;
						SWEP.Primary.IronAccuracy = .22;
					else
						SWEP.Primary.Spread = .23;
						SWEP.Primary.IronAccuracy = .23;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .27;
						SWEP.Primary.IronAccuracy = .27;
					else
						SWEP.Primary.Spread = .3;
						SWEP.Primary.IronAccuracy = .3;
					end
				end
			end
		end
		
		return true;
	end,
	["Pop-a-Shot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons_pipegun/p228-1.wav");
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

SWEP.WElements = {
	["pipeshot"] = { type = "Model", model = "models/weapons/w_pist_piper.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.557, -0.519, 1.557), angle = Angle(-5.844, -15.195, 171.817), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

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

