-- //Variables that are used on both client and server
SWEP.Category                           = ""
SWEP.Gun                                        = ""
SWEP.Author                             = "gabs & DETrooper"
SWEP.Contact                            = ""
SWEP.Purpose                            = ""
SWEP.Instructions                               = ""
SWEP.MuzzleAttachment                   = "1"           -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.DrawCrosshair                      = true          -- Hell no, crosshairs r 4 nubz!
SWEP.ViewModelFOV                       = 65            -- How big the gun will look
SWEP.ViewModelFlip                      = true          -- True for CSS models, False for HL2 models
 
SWEP.Spawnable                          = false
SWEP.AdminSpawnable                     = false
 
SWEP.Primary.Sound                      = Sound("")                             -- Sound of the gun
SWEP.Primary.Round                      = ("")                                  -- What kind of bullet?
SWEP.Primary.Cone                       = 0.2                                   -- Accuracy of NPCs
SWEP.Primary.Recoil             = 10
SWEP.Primary.Damage             = 10
SWEP.Primary.Spread             = .01                                   --define from-the-hip accuracy (1 is terrible, .0001 is exact)
SWEP.Primary.NumShots   = 1
SWEP.Primary.RPM                                = 0                                     -- This is in Rounds Per Minute
SWEP.Primary.ClipSize                   = 0                                     -- Size of a clip
SWEP.Primary.DefaultClip                        = 0                                     -- Default number of bullets in a clip
SWEP.Primary.KickUp                     = 0                                     -- Maximum up recoil (rise)
SWEP.Primary.KickDown                   = 0                                     -- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal                     = 0                                     -- Maximum side recoil (koolaid)
SWEP.Primary.Automatic                  = true                                  -- Automatic/Semi Auto
SWEP.Primary.Ammo                       = "none"                                        -- What kind of ammo
 
-- SWEP.Secondary.ClipSize                 = 0                                     -- Size of a clip
-- SWEP.Secondary.DefaultClip                      = 0                                     -- Default number of bullets in a clip
-- SWEP.Secondary.Automatic                        = false                                 -- Automatic/Semi Auto
SWEP.Secondary.Ammo                     = ""
--//HAHA! GOTCHA, YA BASTARD!

-- SWEP.Secondary.IronFOV                  = 0                                     -- How much you 'zoom' in. Less is more!
 
SWEP.BoltAction                 = false
SWEP.Scoped                             = false
SWEP.ShellTime                  = .35
SWEP.Tracer                             = 0    
SWEP.OrigCrossHair = true
SWEP.MisfireChance = 5;
SWEP.ScopeScale 			= 0.5
SWEP.ReticleScale 			= 0.5
 
SWEP.IronSightsPos = Vector (2.4537, 1.0923, 0.2696)
SWEP.IronSightsAng = Vector (0.0186, -0.0547, 0)
 
SWEP.VElements = {}
SWEP.WElements = {}

local rndr = render
local mth = math
local srface = surface
local inpat = input
 
function SWEP:Initialize()
	self.Reloadaftershoot = 0                               -- Can't reload when firing
	self:SetHoldType(self.HoldType)
	self.OrigCrossHair = self.DrawCrosshair
	
	if SERVER and self.Owner:IsNPC() then
		self:SetNPCMinBurst(3)                 
		self:SetNPCMaxBurst(10)                 -- None of this really matters but you need it here anyway
		self:SetNPCFireRate(1/(self.Primary.RPM/60))   
		-- //self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
	
	if CLIENT then
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		-- Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.w = iScreenHeight/self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight/self.ReticleTable.hdivider

		self.FilterTable = {}
		self.FilterTable.wdivider = 3.125
		self.FilterTable.hdivider = 1.7579/1.35	
		self.FilterTable.x = (iScreenWidth/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.y = (iScreenHeight/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.w = iScreenHeight/self.FilterTable.hdivider
		self.FilterTable.h = iScreenHeight/self.FilterTable.hdivider
	end
   
	if CLIENT then
			-- // Create a new table for every weapon instance
			self.VElements = table.FullCopy( self.VElements )
			self.WElements = table.FullCopy( self.WElements )
			self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

			if LocalPlayer() == self.Owner then
				self:CreateModels(self.VElements) -- create viewmodels
			end
			
			self:CreateModels(self.WElements) -- create worldmodels
		   
			-- // init view model bone build function
			if IsValid(self.Owner) and self.Owner:IsPlayer() then
			if self.Owner:Alive() then
					local vm = self.Owner:GetViewModel()
					if IsValid(vm) then
							self:ResetBonePositions(vm)
							-- // Init viewmodel visibility
							if (self.ShowViewModel == nil or self.ShowViewModel) then
									vm:SetColor(Color(255,255,255,255))
							else
									-- // however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
									vm:SetMaterial("Debug/hsv")                    
							end
					end
				   
			end
			end
		   
	end
   
	if CLIENT then
			local oldpath = "vgui/hud/name" -- the path goes here
			local newpath = string.gsub(oldpath, "name", self.Gun)
			self.WepSelectIcon = surface.GetTextureID(newpath)
	end
end
 
function SWEP:Equip()
	self:SetHoldType(self.HoldType)
end
 
function SWEP:Deploy()
	--if CLIENT then
		self:SetIronsights(false, self.Owner)
	--end
	
	self:SetHoldType(self.HoldType)

	--self.Weapon:SetNWBool("Reloading", false)
   
	if !self.Owner:IsNPC() and self.Owner != nil then
		if self.ResetSights and self.Owner:GetViewModel() != nil then
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
	end
	
	return true
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:OnDrop()
	self:OnRemove();
end
 
function SWEP:Holster()
	if IsValid(self.Owner) and self.Owner:IsPlayer() then
		if CLIENT then
			local vm = self.Owner:GetViewModel()
			
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		else
			self.Owner:SetFOV(0, 0.5);
		end
	end
	
	if self.OnHolster then
		self:OnHolster();
	end
	
	if CLIENT then
		self:RemoveModels();
	end
   
	return true
end
 
function SWEP:OnRemove()
	self:Holster();
end

function SWEP:RemoveModels()
	if self.vRenderOrder then
		for k, name in ipairs( self.vRenderOrder ) do
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			
			local model = v.modelEnt;
			
			if (v.type == "Model" and IsValid(model)) then
				model:Remove();
			end
		end
	end
	
	if self.wRenderOrder then
		for k, name in pairs( self.wRenderOrder ) do
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local model = v.modelEnt;

			if (v.type == "Model" and IsValid(model)) then
				model:Remove();
			end
		end
	end
end
 
function SWEP:GetCapabilities()
		return CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1
end
 
function SWEP:Precache()
		util.PrecacheSound(self.Primary.Sound)
		util.PrecacheModel(self.ViewModel)
		util.PrecacheModel(self.WorldModel)
end

-- By DETrooper
function SWEP:AdjustFireBegotten()
	if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				local ammoType = ammo[1];
				
				if self.AmmoTypes[ammoType] then
					if !self.notPowder then
						local forceJam = false;
					
						--[[
						if cwRituals then
							local ownerPos = self.Owner:GetPos();
							
							for _, v in _player.Iterator() do
								if v:GetNetVar("powderheelActive") then
									if v:GetPos():Distance(ownerPos) <= config.Get("talk_radius"):Get() then
										forceJam = true;
										
										break;
									end
								end
							end
						end
						--]]
					
						if !self.noJam or forceJam then
							local hasPistolier = cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("pistolier");
							local hasFavored = self.Owner:GetNetVar("favored");
							local hasMarked = self.Owner:GetNetVar("marked");
							
							local misfireChance = self.MisfireChance;
							local itemCondition = itemTable:GetCondition();

							if itemCondition < 90 then
								misfireChance = misfireChance + math.Round(((100 - itemCondition) / 5));
							end
							
							if hasPistolier then
								misfireChance = math.Round(misfireChance / 5);
							end
							
							if hasFavored then
								misfireChance = math.Round(misfireChance / 2);
							end
							
							if hasMarked then
								misfireChance = math.Round(misfireChance * 1.5);
							end
						
							--if math.random(1, 100) <= misfireChance then
							if forceJam or util.SharedRandom("misfire_"..self.Owner:EntIndex(), 1, 100) <= misfireChance then -- acceptable risk of people being able to hack this on the client
								self:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
								
								-- 10% chance on misfire for the gun to fucking explode.
								if !hasPistolier and !forceJam and ((!hasMarked and math.random(1, 100) <= 10) or (hasMarked and math.random(1, 100) <= 20)) then
									if SERVER then
										local position = self.Owner:GetPos();
										
										Clockwork.chatBox:AddInTargetRadius(self.Owner, "me", "pulls the trigger on their "..self.PrintName.." and it suddenly explodes!", position, config.Get("talk_radius"):Get() * 2);
										
										Schema:EasyText(Schema:GetAdmins(), "icon16/bomb.png", "tomato", self.Owner:Name().."'s "..self.PrintName.." exploded!");
									
										local effectData = EffectData();
										effectData:SetStart(position);
										effectData:SetOrigin(position);
										effectData:SetScale(256);
										effectData:SetRadius(256);
										effectData:SetMagnitude(50);

										util.BlastDamage(self, self, position, 300, 75);
										util.Effect("Explosion", effectData, true, true);
									end
									
									if itemTable.SetCondition then
										itemTable:SetCondition(0, true);
									end
								else
									if SERVER then
										self.Owner:EmitSound("vj_weapons/dryfire_revolver.wav");
										
										if forceJam then
											Clockwork.chatBox:Add(self.Owner, nil, "it", "Some magical force prevents your firearm from firing, jamming it in the process!")
										else
											Clockwork.chatBox:Add(self.Owner, nil, "it", "Your firearm was loaded with a dud round and misfires!")
										end
									end
									
									self:SetNextPrimaryFire(CurTime() + 2);
								end
							
								return false;
							end
						end
					end
					
					self.AmmoTypes[ammoType](self); -- Execute the function that modifies the weapon behavior based on ammo type.
					return true;
				else
					-- Shouldn't really be possible but maybe we can do something with this later like making it explode the weapon.
					printp("Invalid ammo loaded!");
					return false;
				end
			end
		end
	end
end

function SWEP:CanFireBegotten()
	if Clockwork then
		if Schema and (Schema.towerSafeZoneEnabled) then
			if self.Owner.GetFaction and self.Owner.InTower and self.Owner:InTower() and not self.Owner:IsAdmin() then
				local faction = self.Owner:GetFaction();
			
				if faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy" and faction ~= "Pope Adyssa's Gatekeepers" and faction ~= "Hillkeeper" then
					if SERVER then
						Clockwork.player:Notify(self.Owner, "You cannot attack in this holy place!");
					end
					
					return false;
				end
			end
		end
	
		if self.Owner:GetNW2Bool("Cloaked", false) == true then
			return false;
		end
	
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				return true;
			else
				return false;
			end
		end
	end
	
	return true;
end

function SWEP:TakeAmmoBegotten(amount)
	if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			local magazine;
			
			if itemTable.usesMagazine then
				if ammo and #ammo > 0 then
					local round = ammo[1];
					
					if string.find(round, "Magazine") then
						magazine = round;
					end
				end
			end
			
			if ammo and #ammo > amount then
				for i = 1, amount do
					table.remove(ammo, amount - (i - 1));
				end
			else
				ammo = {};
			end
			
			if SERVER then
				if table.IsEmpty(ammo) and magazine then
					if IsValid(self.Owner) and self.Owner:IsPlayer() then
						local magazineItemID = string.gsub(string.lower(magazine), " ", "_");
						local magazineItem = item.CreateInstance(magazineItemID);
						
						if magazineItem and magazineItem.SetAmmoMagazine then
							magazineItem:SetAmmoMagazine(0);
							
							self.Owner:GiveItem(magazineItem);
						end
					end
				end
			end
			
			if itemTable.SetData then
				itemTable:SetData("Ammo", ammo);
			end
			
			-- Also handle weapon item condition here.
			if itemTable.TakeCondition then
				local conditionLoss = math.max((((1000 - self.Primary.RPM) / 1000) * amount), 0.5);
				
				if !itemTable.unrepairable then
					if IsValid(self.Owner) and self.Owner:IsPlayer() then
						if self.Owner.HasBelief then
							if self.Owner:HasBelief("ingenuity_finisher") then
								return;
							elseif self.Owner:HasBelief("scour_the_rust") then
								conditionLoss = conditionLoss / 1.55;
							end
						end
					end
				end
				
				itemTable:TakeCondition(conditionLoss);
			end
		end
	end
end

-- End DETrooper
 
function SWEP:PrimaryAttack()
	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
		if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then
			self:ShootBulletInformation()
			self.Weapon:TakePrimaryAmmo(1)
   
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetOrigin(self.Owner:GetShootPos())
			fx:SetNormal(self.Owner:GetAimVector())
			fx:SetAttachment(self.MuzzleAttachment)

			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:MuzzleFlash()
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
			self:CheckWeaponsAndAmmo()
			
			if SERVER then
				self.Owner.cloakCooldown = CurTime() + 30;
			end
		end
	elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
		self:ShootBulletInformation()
		self.Weapon:TakePrimaryAmmo(1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
	end
end
 
function SWEP:CheckWeaponsAndAmmo()

end
 
/*---------------------------------------------------------
   Name: SWEP:ShootBulletInformation()
   Desc: This func add the damage, the recoil, the number of shots and the cone on the bullet.
-----------------------------------------------------*/
function SWEP:ShootBulletInformation()
	local CurrentDamage
	local CurrentRecoil
	local CurrentCone
	local basedamage
   
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		CurrentCone = self.Primary.IronAccuracy
	else
		CurrentCone = self.Primary.Spread
	end
	
	if Clockwork and IsValid(self.Owner) then
		local stamina = self.Owner:GetNWInt("Stamina", 100);
		
		if stamina < 50 then
			CurrentCone = CurrentCone + (CurrentCone - (CurrentCone * (0.01 * (stamina * 2))));
		end
		
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local itemCondition = itemTable:GetCondition();

			if itemCondition and itemCondition < 100 then
				CurrentCone = CurrentCone * Lerp(itemCondition / 90, 1.5, 1);
			end
		end
	end
	
	--local damagedice = math.Rand(.85,1.3)
   
	--basedamage = self.Primary.Damage
	--CurrentDamage = basedamage * damagedice
	CurrentDamage = self.Primary.Damage;
	CurrentRecoil = self.Primary.Recoil
   
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		self:ShootBullet(CurrentDamage, CurrentRecoil / 6, self.Primary.NumShots, CurrentCone)
	else
		if IsValid(self) then
			if IsValid(self.Weapon) then
				if IsValid(self.Owner) then
					self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
				end
			end
		end	
	end
end
 
/*---------------------------------------------------------
   Name: SWEP:ShootBullet()
   Desc: A convenience func to shoot bullets.
-----------------------------------------------------*/
local TracerName = "Tracer"
 
function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)
 
		num_bullets             = num_bullets or 1
		aimcone                         = aimcone or 0
 
		self:ShootEffects()
 
		if self.Tracer == 1 then
				TracerName = "Ar2Tracer"
		elseif self.Tracer == 2 then
				TracerName = "AirboatGunHeavyTracer"
		else
				TracerName = "Tracer"
		end
	   
		local bullet = {}
		bullet.Num              = num_bullets
		bullet.Src              = self.Owner:GetShootPos()                      -- Source
		bullet.Dir              = self.Owner:GetAimVector()                     -- Dir of bullet
		bullet.Spread   = Vector(aimcone, aimcone, 0)                   -- Aim Cone
		bullet.Tracer   = 3                                                     -- Show a tracer on every x bullets
		bullet.TracerName = TracerName
		bullet.Force    = damage * 0.25                                 -- Amount of force to give to phys objects
		bullet.Damage   = damage
		bullet.Callback = function(attacker, tracedata, dmginfo)
			dmginfo:SetInflictor(self);
		end
						  
		if self.Primary.Ammo == "buckshot" then
			bullet.AmmoType = "Buckshot";
		else
			bullet.AmmoType = "SMG1";
		end
		
		if IsValid(self) then
			if IsValid(self.Weapon) then
				if IsValid(self.Owner) then
					self.Owner:FireBullets(bullet)
				end
			end
		end

		local angle = Angle(-self.Primary.KickUp, 0, 0);

		self.Owner:ViewPunch(angle);
		
		-- This is ghetto as fuck rofl.
		timer.Simple(0.15, function()
			if IsValid(self) and IsValid(self.Owner) then
				local eyes = self.Owner:EyeAngles();
			
				eyes.pitch = eyes.pitch - self.Primary.KickUp;

				self.Owner:SetEyeAngles(eyes);
			end
		end);
end

function SWEP:DrawHUD()
	if  self.Owner:KeyDown(IN_ATTACK2) and (self:GetIronsights() == true) and (!self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_USE)) then
		if self.Secondary.UseACOG then
		-- Draw the FAKE SCOPE THANG
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)

		-- Draw the CHEVRON
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_acogchevron"))
		surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

		-- Draw the ACOG REFERENCE LINES
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_acogcross"))
		surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
		end

		if self.Secondary.UseMilDot then
		-- Draw the MIL DOT SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_scopesight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end

		if self.Secondary.UseSVD then
		-- Draw the SVD SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_svdsight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end

		if self.Secondary.UseParabolic then
		-- Draw the PARABOLIC SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_parabolicsight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end

		if self.Secondary.UseElcan then
		-- Draw the RETICLE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_elcanreticle"))
		surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
		
		-- Draw the ELCAN SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_elcansight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end

		if self.Secondary.UseGreenDuplex then
		-- Draw the RETICLE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_nvgilluminatedduplex"))
		surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

		-- Draw the SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end
		
		if self.Secondary.UseAimpoint then
		-- Draw the RETICLE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/aimpoint"))
		surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

		-- Draw the SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
		surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		
		end
		
		if self.Secondary.UseMatador then
		
		-- Draw the SCOPE
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(surface.GetTextureID("scope/rocketscope"))
		surface.DrawTexturedRect(self.LensTable.x-1, self.LensTable.y, self.LensTable.w, self.LensTable.h)

		end
		
		if self.Secondary.UseClosedSight then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
		end
	end
end
 
 
function SWEP:SecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end
 
--[[

function SWEP:Reload()
		if not IsValid(self) then return end if not IsValid(self.Owner) then return end
	   
		if self.Owner:IsNPC() then
				self.Weapon:DefaultReload(ACT_VM_RELOAD)
		return end
	   	   
		if !self.Owner:IsNPC() then
				if self.Owner:GetViewModel() == nil then self.ResetSights = CurTime() + 3 else
				self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
				end
		end
	   
		if SERVER and self.Weapon != nil then
		if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
		-- //When the current clip < full clip and the rest of your ammo > 0, then
				self.Owner:SetFOV( 0, 0.3 )
				-- //Zoom = 0
				self:SetIronsights(false)
				-- //Set the ironsight to false
				self.Weapon:SetNWBool("Reloading", true)
		end
		local waitdammit = (self.Owner:GetViewModel():SequenceDuration())
		timer.Simple(waitdammit + .1,
				function()
				if self.Weapon == nil then return end
				self.Weapon:SetNWBool("Reloading", false)
				if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
						if CLIENT then return end
						if self.Scoped == false then
								self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
								self.IronSightsPos = self.SightsPos                                     -- Bring it up
								self.IronSightsAng = self.SightsAng                                     -- Bring it up
								self:SetIronsights(true, self.Owner)
								self.DrawCrosshair = false
						else return end
				elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
						if self.Weapon:GetNextPrimaryFire() <= (CurTime() + .03) then
								self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                   -- Make it so you can't shoot for another quarter second
						end
						self.IronSightsPos = self.RunSightsPos                                  -- Hold it down
						self.IronSightsAng = self.RunSightsAng                                  -- Hold it down
						self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
						self.Owner:SetFOV( 0, 0.3 )
				else return end
				end)
		end
end
 
function SWEP:PostReloadScopeCheck()
		if self.Weapon == nil then return end
		self.Weapon:SetNWBool("Reloading", false)
		if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then
				if CLIENT then return end
				if self.Scoped == false then
						self.Owner:SetFOV( self.Secondary.IronFOV, 0.3 )
						self.IronSightsPos = self.SightsPos                                     -- Bring it up
						self.IronSightsAng = self.SightsAng                                     -- Bring it up
						self:SetIronsights(true, self.Owner)
						self.DrawCrosshair = false
				else return end
		elseif self.Owner:KeyDown(IN_SPEED) and self.Weapon:GetClass() == self.Gun then
				if self.Weapon:GetNextPrimaryFire() <= (CurTime() + .03) then
						self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                           -- Make it so you can't shoot for another quarter second
				end
				self.IronSightsPos = self.RunSightsPos                                  -- Hold it down
				self.IronSightsAng = self.RunSightsAng                                  -- Hold it down
				self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
				self.Owner:SetFOV( 0, 0.3 )
		else return end
end

--]] 
 
/*---------------------------------------------------------
IronSight
-----------------------------------------------------*/
function SWEP:IronSight()
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	
	if !self.Owner:IsWeaponRaised(self) then
		return;
	end

	if !self.Owner:IsNPC() then
		if self.ResetSights and CurTime() >= self.ResetSights then
			self.ResetSights = nil
		end
	end
	
	local bIron = self:GetIronsights();
   
	if self.Owner:KeyPressed(IN_SPEED) --[[and not (self.Weapon:GetNWBool("Reloading"))]] then
		if self.Weapon:GetNextPrimaryFire() <= (CurTime()+0.3) then
			self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                           -- Make it so you can't shoot for another quarter second
		end
		
		self.IronSightsPos = self.RunSightsPos                                  -- Hold it down
		self.IronSightsAng = self.RunSightsAng                                  -- Hold it down
		self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = false
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end
	end                                                            
 
	if self.Owner:KeyReleased(IN_SPEED) then
		self:SetIronsights(false, self.Owner)                        -- Set the ironsight true
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = self.OrigCrossHair
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end
	end

	if !self.Owner:KeyDown(IN_SPEED) then
		if self.Owner:KeyPressed(IN_ATTACK2) --[[and not (self.Weapon:GetNWBool("Reloading"))]] then
			self.Owner:SetFOV(self.Secondary.IronFOV, 0.5);
			self.IronSightsPos = self.SightsPos                                     -- Bring it up
			self.IronSightsAng = self.SightsAng                                     -- Bring it up
			self:SetIronsights(true, self.Owner)
			self.DrawCrosshair = false
			
			if CLIENT then return end
			
			if self.Secondary.ScopeZoom then
				self.Owner:DrawViewModel(false)
			end

			return
		end
	end

	if self.Owner:KeyReleased(IN_ATTACK2) and !self.Owner:KeyDown(IN_SPEED) then
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = self.OrigCrossHair
		self:SetIronsights(false, self.Owner)
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end

		return
	end
	
	if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_SPEED) then
		self.SwayScale  = 0.05
		self.BobScale   = 0.05
	else
		self.SwayScale  = 1.0
		self.BobScale   = 1.0
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() and !self.Owner:KeyDown(IN_SPEED) then
		return 0.25;
	end
end

 
/*---------------------------------------------------------
Think
-----------------------------------------------------*/
function SWEP:Think()
	if SERVER then
		local curTime = CurTime();
		local player = self.Owner;
		
		if !self.notPowder and (!self.waterCheck or self.waterCheck <= curTime) then
			self.waterCheck = curTime + 0.5;
			
			if IsValid(player) and player:IsPlayer() then
				if self.Owner:WaterLevel() >= 3 then
					if !self.Owner.cwObserverMode then
						if Clockwork then
							local itemTable = item.GetByWeapon(self);
							
							if itemTable then
								local ammo = itemTable:GetData("Ammo");
								
								if ammo and #ammo > 0 and !itemTable.usesMagazine then
									itemTable:SetData("Ammo", {});
									
									Clockwork.player:Notify(self.Owner, "Your weapon fills with water and your powder charge is ruined!");
								end
							end
						end
					end
				end
			end
		end
		
		-- Last ditch effort to fix the clientside itemtable desync.
		if !self.nextItemSend or self.nextItemSend <= curTime then
			if IsValid(player) and player:IsPlayer() then
				local itemTable = item.GetByWeapon(self);
					
				if itemTable then
					netstream.Start(player, "WeaponItemData", {
						definition = item.GetDefinition(itemTable, true),
						weapon = self:EntIndex()
					})

					if self:GetNWInt("ItemID") ~= itemTable.itemID then
						self:SetNWInt("ItemID", itemTable.itemID)
					end
					
					self.cwItemTable = itemTable
				end
			end
			
			self.nextItemSend = curTime + math.random(1, 5);
		end
	--elseif CLIENT then
		--self:IronSight();
	end
	
	self:IronSight();
end
 
/*---------------------------------------------------------
GetViewModelPosition
-----------------------------------------------------*/
local IRONSIGHT_TIME = 0.3
-- //Time to enter in the ironsight mod
 
function SWEP:GetViewModelPosition(pos, ang)
 
		if (not self.IronSightsPos) then return pos, ang end
 
		local bIron = self.Weapon:GetNWBool("M9K_Ironsights")
 
		if (bIron != self.bLastIron) then
				self.bLastIron = bIron
				self.fIronTime = CurTime()
 
		end
 
		local fIronTime = self.fIronTime or 0
 
		if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
				return pos, ang
		end
 
		local Mul = 1.0
 
		if (fIronTime > CurTime() - IRONSIGHT_TIME) then
				Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
 
				if not bIron then Mul = 1 - Mul end
		end
 
		local Offset    = self.IronSightsPos
 
		if (self.IronSightsAng) then
				ang = ang * 1
				ang:RotateAroundAxis(ang:Right(),               self.IronSightsAng.x * Mul)
				ang:RotateAroundAxis(ang:Up(),          self.IronSightsAng.y * Mul)
				ang:RotateAroundAxis(ang:Forward(),     self.IronSightsAng.z * Mul)
		end
 
		local Right     = ang:Right()
		local Up                = ang:Up()
		local Forward   = ang:Forward()
 
		pos = pos + Offset.x * Right * Mul
		pos = pos + Offset.y * Forward * Mul
		pos = pos + Offset.z * Up * Mul
 
		return pos, ang
end
 
/*---------------------------------------------------------
SetIronsights
-----------------------------------------------------*/
function SWEP:SetIronsights(b)
	self.Weapon:SetNWBool("M9K_Ironsights", b)
end
 
function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("M9K_Ironsights")
end
 
if CLIENT then
		SWEP.vRenderOrder = nil
		function SWEP:ViewModelDrawn(vm)
			local vm = self.Owner:GetViewModel()
			self:UpdateBonePositions(vm)
			
			if !IsValid(vm) then return end
			
			if (!self.VElements) then return end

			if (!self.vRenderOrder) then
				self.vRenderOrder = {}

				for k, v in pairs( self.VElements ) do
					if (v.type == "Model") then
						table.insert(self.vRenderOrder, 1, k)
					elseif (v.type == "Sprite" or v.type == "Quad") then
						table.insert(self.vRenderOrder, k)
					end
				end
			end

			for k, name in ipairs( self.vRenderOrder ) do
				local v = self.VElements[name]
				if (!v) then self.vRenderOrder = nil break end
				
				if (!v.bone) then continue end
				
				local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
				
				if (!pos) then continue end
				
				if (v.type == "Model") then
					local model = v.modelEnt
					
					if !IsValid(model) then
						self:CreateModels(self.VElements);
						
						return;
					end

					model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)

					model:SetAngles(ang)
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
					
					if (v.material == "") then
						model:SetMaterial("")
					elseif (model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
					
					if (v.skin and v.skin != model:GetSkin()) then
						model:SetSkin(v.skin)
					end
					
					if (v.bodygroup) then
						for k, v in pairs( v.bodygroup ) do
							if (model:GetBodygroup(k) != v) then
								model:SetBodygroup(k, v)
							end
						end
					end
					
					if (v.surpresslightning) then
						rndr.SuppressEngineLighting(true)
					end
					
					local color = v.color;
					
					if color then
						rndr.SetColorModulation(color.r/255, color.g/255, color.b/255)
						rndr.SetBlend(color.a/255)
						model:DrawModel()
						rndr.SetBlend(1)
						rndr.SetColorModulation(1, 1, 1)
					else
						model:DrawModel()
					end
					
					if (v.surpresslightning) then
						rndr.SuppressEngineLighting(false)
					end
				elseif (v.type == "Sprite" and sprite) then
					local sprite = v.spriteMaterial
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					rndr.SetMaterial(sprite)
					rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
					
				elseif (v.type == "Quad" and v.draw_func) then
					
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
					
					cam.Start3D2D(drawpos, ang, v.size)
						v.draw_func( self )
					cam.End3D2D()
				end
			end
		end

		SWEP.wRenderOrder = nil
		function SWEP:DrawWorldModel()
			local wepTab = self:GetTable()

			if (wepTab.ShowWorldModel ~= false) then
				self:DrawModel()
			end
			
			if (!wepTab.WElements) then return end
			
			if (!wepTab.wRenderOrder) or table.IsEmpty(wepTab.wRenderOrder) then
				wepTab.wRenderOrder = {}

				for k, v in pairs(wepTab.WElements) do
					if (v.type == "Model") then
						table.insert(wepTab.wRenderOrder, 1, k)
					elseif (v.type == "Sprite" or v.type == "Quad") then
						table.insert(wepTab.wRenderOrder, k)
					end
				end
			end
			
			for k, name in pairs(wepTab.wRenderOrder) do
				local v = wepTab.WElements[name]
				
				if (!v) then wepTab.wRenderOrder = nil break end
				
				if (v.type == "Model") then
					local model = v.modelEnt
					
					if !IsValid(model) or model:GetParent() ~= self.Owner and IsValid(self.Owner) then
						self:CreateModels(wepTab.WElements);
						
						return;
					end
				
					--[[ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
					model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
					model:SetAngles(ang)
					
					if v.size then
						local matrix = Matrix()
						matrix:Scale(v.size)
						model:EnableMatrix( "RenderMultiply", matrix )
					end
					
					if (v.material and model:GetMaterial() != v.material) then
						model:SetMaterial( v.material )
					end
					
					if (v.skin and v.skin != model:GetSkin()) then
						model:SetSkin(v.skin)
					end
					
					if (v.bodygroup) then
						for k, v in pairs( v.bodygroup ) do
							if (model:GetBodygroup(k) != v) then
								model:SetBodygroup(k, v)
							end
						end
					end]]--
					
					if (v.surpresslightning) then
						rndr.SuppressEngineLighting(true)
					end
					
					local color = v.color;
					
					if color then
						rndr.SetColorModulation(color.r/255, color.g/255, color.b/255)
						rndr.SetBlend(color.a/255)
						model:DrawModel()
						rndr.SetBlend(1)
						rndr.SetColorModulation(1, 1, 1)
					else
						model:DrawModel()
					end
					
					if (v.surpresslightning) then
						rndr.SuppressEngineLighting(false)
					end
				elseif (v.type == "Sprite" and sprite) then
					local sprite = v.spriteMaterial
					local pos, ang
					
					if (v.bone) then
						pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
					else
						pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
					end
					
					if (!pos) then continue end
					
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					rndr.SetMaterial(sprite)
					rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				elseif (v.type == "Quad" and v.draw_func) then
					local pos, ang
					
					if (v.bone) then
						pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
					else
						pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
					end
					
					if (!pos) then continue end
					
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
					
					cam.Start3D2D(drawpos, ang, v.size)
						v.draw_func( self )
					cam.End3D2D()
				end
			end
		end
 
		function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
			local bone, pos, ang
			
			if (tab.rel and tab.rel != "") then
				local v = basetab[tab.rel]
				
				if (!v) then return end

				pos, ang = self:GetBoneOrientation( basetab, v, ent )
				
				if (!pos) then return end
				
				pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			else
				bone = ent:LookupBone(bone_override or tab.bone)

				if (!bone) then return end
				
				if basetab == self.VElements then
					local m = ent:GetBoneMatrix(bone)
					
					if (m) then
						pos, ang = m:GetTranslation(), m:GetAngles();
					end
				end

				if !pos and !ang then
					pos = ent:GetPos();
					ang = ent:GetAngles();
				end
				
				if (IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel()) then
					if self.ViewModelFlip then
						ang.r = -ang.r 
					end
				end
			end
			
			return pos, ang, bone;
		end

		function SWEP:CreateModels( tab )
			if (!tab) then return end

			for k, v in pairs( tab ) do
				if IsValid(v.modelEnt) then
					v.modelEnt:Remove();
				end
			
				if (v.type == "Model" and v.model and v.model != "" and !IsValid(v.modelEnt) and 
					string.find(v.model, ".mdl") and file.Exists(v.model, "GAME")) then
					
					local modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
					
					if (IsValid(modelEnt)) then
						--[[modelEnt:SetPos(self:GetPos())
						modelEnt:SetAngles(self:GetAngles())
						modelEnt:SetParent(self)]]--
						modelEnt:SetNoDraw(true)
						
						local pos, ang, bone;
						
						if tab == self.VElements then
							pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner:GetViewModel())
						else
							if (v.bone) then
								pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner or self)
							else
								pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
							end
						end
						
						if pos and ang and bone then
							modelEnt:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z);
							ang:RotateAroundAxis(ang:Up(), v.angle.y)
							ang:RotateAroundAxis(ang:Right(), v.angle.p)
							ang:RotateAroundAxis(ang:Forward(), v.angle.r)
							modelEnt:SetAngles(ang)
							
							if tab == self.VElements then
								--modelEnt:FollowBone(self.Owner:GetViewModel(), bone);
							else
								modelEnt:FollowBone(self.Owner, bone);
							end
							
							if v.size then
								local matrix = Matrix()
								matrix:Scale(v.size)
								modelEnt:EnableMatrix( "RenderMultiply", matrix )
							end
							
							if (v.material and modelEnt:GetMaterial() != v.material) then
								modelEnt:SetMaterial(v.material)
							end
							
							if (v.skin and v.skin != modelEnt:GetSkin()) then
								modelEnt:SetSkin(v.skin)
							end
							
							if (v.bodygroup) then
								for k, v in pairs( v.bodygroup ) do
									if (modelEnt:GetBodygroup(k) != v) then
										modelEnt:SetBodygroup(k, v)
									end
								end
							end
						end
						
						v.modelEnt = modelEnt;
					else
						v.modelEnt = nil
					end
				elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
					and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
					
					local name = v.sprite.."-"
					local params = { ["$basetexture"] = v.sprite }
					local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
					for i, j in pairs( tocheck ) do
						if (v[j]) then
							params["$"..j] = 1
							name = name.."1"
						else
							name = name.."0"
						end
					end

					v.createdSprite = v.sprite
					v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				end
			end
		end
	   
		local allbones
		local hasGarryFixedBoneScalingYet = false
 
		function SWEP:UpdateBonePositions(vm)
			   
				if self.ViewModelBoneMods then
					   
						if (!vm:GetBoneCount()) then return end
					   
						-- // !! WORKAROUND !! --//
						-- // We need to check all model names :/
						local loopthrough = self.ViewModelBoneMods
						if (!hasGarryFixedBoneScalingYet) then
								allbones = {}
								for i=0, vm:GetBoneCount() do
										local bonename = vm:GetBoneName(i)
										if (self.ViewModelBoneMods[bonename]) then
												allbones[bonename] = self.ViewModelBoneMods[bonename]
										else
												allbones[bonename] = {
														scale = Vector(1,1,1),
														pos = Vector(0,0,0),
														angle = Angle(0,0,0)
												}
										end
								end
							   
								loopthrough = allbones
						end
						//!! ----------- !! --
					   
						for k, v in pairs( loopthrough ) do
								local bone = vm:LookupBone(k)
								if (!bone) then continue end
							   
								-- // !! WORKAROUND !! --//
								local s = Vector(v.scale.x,v.scale.y,v.scale.z)
								local p = Vector(v.pos.x,v.pos.y,v.pos.z)
								local ms = Vector(1,1,1)
								if (!hasGarryFixedBoneScalingYet) then
										local cur = vm:GetBoneParent(bone)
										while(cur >= 0) do
												local pscale = loopthrough[vm:GetBoneName(cur)].scale
												ms = ms * pscale
												cur = vm:GetBoneParent(cur)
										end
								end
							   
								s = s * ms
								//!! ----------- !! --
							   
								if vm:GetManipulateBoneScale(bone) != s then
										vm:ManipulateBoneScale( bone, s )
								end
								if vm:GetManipulateBoneAngles(bone) != v.angle then
										vm:ManipulateBoneAngles( bone, v.angle )
								end
								if vm:GetManipulateBonePosition(bone) != p then
										vm:ManipulateBonePosition( bone, p )
								end
						end
				else
						self:ResetBonePositions(vm)
				end
				   
		end
		 
		function SWEP:ResetBonePositions(vm)
			   
				if (!vm:GetBoneCount()) then return end
				for i=0, vm:GetBoneCount() do
						vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
						vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
						vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
				end
			   
		end
 
		/**************************
				Global utility code
		**************************/
 
		-- // Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
		-- // Does not copy entities of course, only copies their reference.
		-- // WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
		function table.FullCopy( tab )
 
				if (!tab) then return nil end
			   
				local res = {}
				for k, v in pairs( tab ) do
						if (type(v) == "table") then
								res[k] = table.FullCopy(v) --// recursion ho!
						elseif (type(v) == "Vector") then
								res[k] = Vector(v.x, v.y, v.z)
						elseif (type(v) == "Angle") then
								res[k] = Angle(v.p, v.y, v.r)
						else
								res[k] = v
						end
				end
			   
				return res
			   
		end
	   
end

print "Begotten Firearms Base Loaded"