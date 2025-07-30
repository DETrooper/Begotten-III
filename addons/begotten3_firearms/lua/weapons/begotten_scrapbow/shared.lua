-- Variables that are used on both client and server
SWEP.Gun = ("scrap_crossbow")					-- must be the name of your swep
SWEP.Category				= "Begotten"
SWEP.Author					= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.MuzzleAttachment		= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" 		-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Scrap Crossbow"	-- Weapon name (Shown on HUD)	
SWEP.Slot					= 2			-- Slot in the weapon selection menu
SWEP.SlotPos				= 79		-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 30		-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon

-- View Model
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/begotten/weapons/c_scrapbow.mdl"
SWEP.WorldModel				= "models/begotten/weapons/w_scrapbow.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true

-- World Model
SWEP.Base					= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater 		= true

SWEP.Primary.Sound			= Sound("weapons/cb4/cb4-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 25		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize		= 1		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Bullets you start with
SWEP.Primary.KickUp			= 30		-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 1			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 1			-- Maximum up recoil (stock)
SWEP.Primary.Automatic		= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg"

SWEP.Secondary.IronFOV		= 62.5		-- How much you 'zoom' in. Less is more! 	

SWEP.data 					= {}		-- The starting firemode
SWEP.data.ironsights		= 1

SWEP.Primary.NumShots		= 1			-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage			= 75		-- Base damage per bullet
SWEP.Primary.Spread			= .05		-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy 	= .02 		-- Ironsight accuracy, should be the same for shotguns

-- For the tooltips only, actual values are stored in meleetables
SWEP.Primary.MinimumDistanceDamage = 50;
SWEP.Primary.MaximumDistanceDamage = 120;
SWEP.Primary.StabilityDamage = 40;
SWEP.Primary.BoltRange = 160;

SWEP.SelectiveFire			= false

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-7, -5.026, 6.55)
SWEP.IronSightsAng = Vector(-4.222, -3.518, 2.111)
SWEP.SightsPos = Vector(-7, -5.026, 6.55)
SWEP.SightsAng = Vector(-4.222, -3.518, 2.111)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-9.146, 38.693, -15.478)

SWEP.noJam = true;
SWEP.notPowder = true;
SWEP.MisfireChance = 0;

SWEP.WElements = {
	["w_scrapcrossbow"] = { type = "Model", model = "models/begotten/weapons/w_scrapbow.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, -0.519), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.AmmoTypes = {
	["Iron Bolt"] = function(SWEP)
		SWEP.Primary.MinimumDistanceDamage = 50;
		SWEP.Primary.MaximumDistanceDamage = 120;
		SWEP.Primary.StabilityDamage = 80;
		SWEP.Primary.Sound = Sound("weapons/crossbow/bowgun-shot.wav.mp3");
		SWEP.Primary.Round = "begotten_iron_bolt";
		SWEP.AttackTable = "IronBoltAttackTable";
		SWEP.BoltModel = "models/begotten/items/bolt.mdl";
		SWEP.ConditionLoss = 50;
		SWEP.BodyGroup = 0;
		
		return true;
	end,
	["Iron Bolt (Incendiary)"] = function(SWEP)
		SWEP.Primary.MinimumDistanceDamage = 50;
		SWEP.Primary.MaximumDistanceDamage = 120;
		SWEP.Primary.StabilityDamage = 80;
		SWEP.Primary.Sound = Sound("weapons/crossbow/bowgun-shot.wav.mp3");
		SWEP.Primary.Round = "begotten_iron_bolt_incendiary";
		SWEP.AttackTable = "IronBoltIncendiaryAttackTable";
		SWEP.BoltModel = "models/begotten/items/bolt.mdl";
		SWEP.ConditionLoss = 50;
		SWEP.BodyGroup = 0;
		
		return true;
	end,
	["Scrap Bolt"] = function(SWEP)
		SWEP.Primary.MinimumDistanceDamage = 35;
		SWEP.Primary.MaximumDistanceDamage = 90;
		SWEP.Primary.StabilityDamage = 70;
		SWEP.Primary.Sound = Sound("weapons/crossbow/bowgun-shot.wav.mp3");
		SWEP.Primary.Round = "begotten_scrap_bolt";
		SWEP.AttackTable = "ScrapBoltAttackTable";
		SWEP.BoltModel = "models/begotten/items/rebar.mdl";
		SWEP.ConditionLoss = 50;
		SWEP.BodyGroup = 1;
		
		return true;
	end,
	
	["Volt Bolt"] =  function(SWEP)
		SWEP.Primary.MinimumDistanceDamage = 50;
		SWEP.Primary.MaximumDistanceDamage = 105;
		SWEP.Primary.StabilityDamage = 75;
		SWEP.Primary.Sound = Sound("weapons/crossbow/bowgun-shot.wav.mp3");
		SWEP.Primary.Round = "begotten_volt_bolt";
		SWEP.AttackTable = "VoltBoltAttackTable";
		SWEP.BoltModel = "models/begotten/items/rebar.mdl";
		SWEP.ConditionLoss = 50;
		SWEP.BodyGroup = 1;
		
		SWEP.isVoltistWeapon = true;
		
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
			if !self.Owner:KeyDown(IN_SPEED) then
				if !self:AdjustFireBegotten() then
					return;
				end
				
				local pos = self.Owner:GetShootPos();
				
				if SERVER then
					local bolt = ents.Create(self.Primary.Round)
					if !bolt:IsValid() then return false end
					
					bolt:SetModel(self.BoltModel);
					bolt:SetAngles(self.Owner:GetAimVector():Angle())
					bolt:SetPos(pos)
					bolt:SetOwner(self.Owner)
					bolt:Spawn()
					bolt.AttackTable = GetTable(self.AttackTable);
					bolt.Owner = self.Owner
					bolt.isVoltistWeapon = self.isVoltistWeapon
					bolt:Activate()
					
					local aimVector = self.Owner:GetAimVector() * 1350;
					local phys = bolt:GetPhysicsObject()
					local itemTable = item.GetByWeapon(self);
					local itemCondition = itemTable:GetCondition();
					
					if self.Owner:GetVelocity() ~= Vector(0, 0, 0) or !self.Owner.HasBelief or !self.Owner:HasBelief("marksman") then
						aimVector:Rotate(Angle(math.Rand(-1, 1), math.Rand(-1, 1), 0));
					end

					if itemCondition and itemCondition < 100 then
						aimVector = Lerp(itemCondition / 90, aimVector * 0.5, aimVector)
					end
					
					phys:SetVelocity(aimVector);
						
					if self.Owner:IsPlayer() then
						local anglo = Angle(0, -5, 0);
						
						self.Owner:ViewPunch(anglo)
					end
				end
				
				self.Weapon:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
				self.Weapon:EmitSound(self.Primary.Sound);

				self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				self.Owner:SetAnimation(PLAYER_ATTACK1);
				self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60));
				
				if SERVER then
					self.Owner.cloakCooldown = CurTime() + 5;
				end
			end
		end
	end
end

function SWEP:PreDrawViewModel(vm)
	local ammoType;

	if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				ammoType = self.AmmoTypes[ammo[1]];
				
				if ammoType then
					ammoType(self);
				end
			end
		end
	end

	if ammoType then
		vm:SetSequence(2);
		vm:SetBodygroup(1, self.BodyGroup or 0);
	else
		vm:SetSequence(3);
	end
end

--[[[0]	=	idle
[1]	=	idle_empty
[2]	=	draw
[3]	=	fire
[4]	=	reload
[5]	=	holster
[6]	=	idletolow
[7]	=	lowtoidle
[8]	=	lowidle
]]--