-- Variables that are used on both client and server
SWEP.Gun = ("bb_colt")					-- must be the name of your swep
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
SWEP.PrintName				= "Colt"		-- Weapon name (Shown on HUD)	
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

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel = "models/weapons/doi/v_m1911.mdl" 
SWEP.WorldModel = "models/weapons/doi/w_1911.mdl"
SWEP.ShowWorldModel = true
SWEP.Base				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/m1911/m1911_fp.wav")
SWEP.Primary.Delay = 1                         
SWEP.Primary.RPM			= 300			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 7		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 5		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.IronFOV			= 50		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 60	-- Base damage per bullet
SWEP.Primary.Spread		= .02	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-1.841, -4.02, 0.439)
SWEP.IronSightsAng = Vector(0.703, 0, 5.627)
SWEP.SightsPos = Vector(-1.841, -4.02, 0.439)
SWEP.SightsAng = Vector(0.703, 0, 5.627)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-18.292, 0, 0)

SWEP.MisfireChance = 0;

SWEP.AmmoTypes = {
	["Old World Shot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/m1911/m1911_fp.wav");
		SWEP.Primary.FarSound = Sound("weapons/m1911/m1911_dist.mp3");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 60;
		SWEP.Primary.Spread = .02;
		SWEP.Primary.IronAccuracy = .01;
		SWEP.Primary.ClipSize = 1;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .0075;
						SWEP.Primary.IronAccuracy = .0025;
					else
						SWEP.Primary.Spread = .01;
						SWEP.Primary.IronAccuracy = .005;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .0125;
						SWEP.Primary.IronAccuracy = .0065;
					else
						SWEP.Primary.Spread = .015;
						SWEP.Primary.IronAccuracy = .0075;
					end
				end
			end
		end
		
		return true;
	end,
	["Old World Magazine"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/m1911/m1911_fp.wav");
		SWEP.Primary.FarSound = Sound("weapons/m1911/m1911_dist.mp3");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 60;
		SWEP.Primary.Spread = .02;
		SWEP.Primary.IronAccuracy = .01;
		SWEP.Primary.ClipSize = 7;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .0075;
						SWEP.Primary.IronAccuracy = .0025;
					else
						SWEP.Primary.Spread = .01;
						SWEP.Primary.IronAccuracy = .005;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .00125;
						SWEP.Primary.IronAccuracy = .0065;
					else
						SWEP.Primary.Spread = .0015;
						SWEP.Primary.IronAccuracy = .0075;
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
					
					self.Weapon:EmitSound(self.Primary.FarSound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
				else
					self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0);
				end

				local effect = EffectData();
				local Forward = self.Owner:GetForward()
				local Right = self.Owner:GetRight()
				
				effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
				effect:SetNormal( self.Owner:GetAimVector());

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
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