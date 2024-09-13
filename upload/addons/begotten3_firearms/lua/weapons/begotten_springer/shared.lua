SWEP.Gun = ("begotten_springer")					-- must be the name of your swep
SWEP.Category				= "Begotten"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Springer"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 53		-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_snip_m1903.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_snip_m1903.mdl"	-- Weapon world model
SWEP.ShowWorldModel = false
SWEP.Base 				= "begotten_firearm_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true


SWEP.Primary.Sound			= ("weapons_moth/p90-1.wav")
SWEP.Primary.RPM				= 40		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 5		-- Size of a clip
SWEP.Primary.DefaultClip			= 0	-- Bullets you start with
SWEP.Primary.KickUp			= 1				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 1		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"

SWEP.Secondary.ScopeZoom			= 15
SWEP.Secondary.UseMilDot		= true		
SWEP.Secondary.IronFOV			= 15		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.7

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 85	--base damage per bullet
SWEP.Primary.Spread		= .02	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .004 -- ironsight accuracy, should be the same for shotguns
SWEP.BoltAction	=	true;

SWEP.MisfireChance = 0;
SWEP.IgnoresBulletResistance = true;

SWEP.AmmoTypes = {
	["Old World Longshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("gmodtower/pvpbattle/sniper/sniperfire.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 85;
		SWEP.Primary.Spread = .05;
		SWEP.Primary.IronAccuracy = .05;
		SWEP.Primary.ClipSize = 1;
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .001;
						SWEP.Primary.IronAccuracy = .0001;
					else
						SWEP.Primary.Spread = .005;
						SWEP.Primary.IronAccuracy = .0025;
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
				self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
				
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
				--util.Effect( "effect_awoi_smoke_pistol", effect );

				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self.Owner:MuzzleFlash()
				self.Weapon:SetNextPrimaryFire(curTime + 1)
				--self:CheckWeaponsAndAmmo()
				--self.RicochetCoin = (math.random(1,4))
				
				self:BoltBack();
				
				timer.Simple(1, function()
					if IsValid(self) and self.Weapon then
						self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
					end
				end);
				
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

-- enter iron sight info and bone mod info below

SWEP.SightsPos = Vector(-5, -8, 3.1)
SWEP.SightsAng = Vector(0, -3, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-5.299, 20.017, -5.953)

function SWEP:BoltBack()
	local canCycleBolt = true;

	--[[if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if !ammo or table.IsEmpty(ammo) then
				canCycleBolt = false;
			end
		end
	end]]--

	if canCycleBolt then
		timer.Simple(.25, function()
			if SERVER and self.Weapon != nil then 
				--self.Weapon:SetNWBool("Reloading", true);
				
				if self.Weapon:GetClass() == self.Gun then
					if(self:GetIronsights() == true) then
						self.Owner:SetFOV( 0, 0.3 )
						self:SetIronsights(false)
						self.Owner:DrawViewModel(true)
					end
					
					timer.Simple(0.2, function()
						if IsValid(self) and IsValid(self.Owner) then
							self.Owner:EmitSound("weapons/request day of defeat/m1903 springfield boltback 1.wav");
							
							timer.Simple(0.55, function()
								if IsValid(self) and IsValid(self.Owner) then
									self.Owner:EmitSound("weapons/request day of defeat/m1903 springfield boltforward 2.wav");
								end
							end);
						end
					end);
					
					local boltactiontime = (self.Owner:GetViewModel():SequenceDuration())
					
					timer.Simple(boltactiontime + .1, 
						function() if SERVER and self.Weapon != nil then
							--self.Weapon:SetNWBool("Reloading", false);
							
							if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then 
								self.Owner:SetFOV( 75/self.Secondary.ScopeZoom, 0.15 )                      		
								self.IronSightsPos = self.SightsPos					-- Bring it up
								self.IronSightsAng = self.SightsAng					-- Bring it up
								self.DrawCrosshair = false
								self:SetIronsights(true, self.Owner)
								self.Owner:DrawViewModel(false)
							end
						end 
					end)
				end
			else 
				return 
			end 
		end)
	end	
end

SWEP.WElements = {
	["springer"] = { type = "Model", model = "models/weapons/w_snip_m1903.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 1.299, -0.519), angle = Angle(-7.5, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}