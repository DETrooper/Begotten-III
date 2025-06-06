SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.556, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(16.666, 1.11, -12.223) },
	["v_ee3_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_blunderbuss"] = { type = "Model", model = "models/arxweapon/ashot.mdl", bone = "v_ee3_reference001", rel = "", pos = Vector(0, -0.519, 0.5), angle = Angle(1.169, -89, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["ashot"] = { type = "Model", model = "models/arxweapon/ashot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.5, -2.201), angle = Angle(-171.818, -176.495, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Gun = ("blunderbuss") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "Begotten"
SWEP.Author				= "gabs"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= "Click the trigger to fire, use the Right click to aim the sights."
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Blunderbuss"		-- Weapon name (Shown on HUD)	
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
SWEP.ViewModel				= "models/weapons/synbf3/c_ee3.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_airgun.mdl"	-- Weapon world model
SWEP.Base 				= "begotten_firearm_base"
SWEP.ShowWorldModel			= false
SWEP.UseHands 						= true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("musket/musket4.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 30		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp				= 8				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.8		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.6	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .35

SWEP.Primary.NumShots	= 24		//how many bullets to shoot, use with shotguns
SWEP.Primary.Damage		= 8	//base damage, scaled by game
SWEP.Primary.Spread		= .2	//define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .2 // has to be the same as primary.spread
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.52, -10.452, 3.64)
SWEP.SightsAng = Vector(-0.9, -0.95, 1)
SWEP.RunSightsPos = Vector(-0.44, 0, 0.36)
SWEP.RunSightsAng = Vector(-14.775, 33.064, -21.81)

SWEP.RaiseSpeed = 2

SWEP.AmmoTypes = {
	["Grapeshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("musket/musket4.wav");
		SWEP.Primary.FarSound = Sound("musket/musket4_distant.mp3");
		SWEP.Primary.NumShots = 24;
		SWEP.Primary.Damage = 8;
		SWEP.Primary.Spread = .2;
		SWEP.Primary.IronAccuracy = .2;
		SWEP.Primary.Ammo = "buckshot";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .1;
						SWEP.Primary.IronAccuracy = .1;
					else
						SWEP.Primary.Spread = .125;
						SWEP.Primary.IronAccuracy = .125;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .15;
						SWEP.Primary.IronAccuracy = .15;
					else
						SWEP.Primary.Spread = .175;
						SWEP.Primary.IronAccuracy = .175;
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
				
				--[[timer.Simple(0.6,function() if self:IsValid() then self.Owner:EmitSound("weapons/357/357_reload3.wav") end end)						
				timer.Simple(1.6,function() if self:IsValid() then self.Owner:EmitSound("physics/metal/metal_grenade_impact_hard1.wav") end end)
				timer.Simple(2,function() if self:IsValid() then self.Owner:EmitSound("weapons/357/357_reload4.wav") end end)]]--  

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