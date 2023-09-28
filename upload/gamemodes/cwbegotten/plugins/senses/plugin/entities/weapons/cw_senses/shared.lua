--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

if (CLIENT) then
	SWEP.Slot = 1;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Senses";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: Toggle";
SWEP.Purpose = "If you are in a dark area and cannot see, you can use your senses to navigate.";
SWEP.Contact = "";
SWEP.Author	= "";

SWEP.WorldModel = "";
SWEP.ViewModel = "models/weapons/c_arms.mdl";
SWEP.HoldType = "fist";
SWEP.Weight = 1

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Ammo = "";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);
SWEP.NeverRaised = true;
SWEP.LoweredAngles = Angle(0.000, 0.000, -22.000);

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + 0.25);
	self:SetNextSecondaryFire(CurTime() + 0.25);
	
	if SERVER then
		local player = self.Owner;
	
		if player.spawning then
			return;
		end
		
		if !(cwBeliefs and (player:HasBelief("creature_of_the_dark") or player:HasBelief("the_black_sea"))) and !player:GetNWBool("hasThermal") and !player:GetNWBool("hasNV") then
			local clothesItem = player:GetClothesEquipped();
			
			if !clothesItem or (clothesItem and !clothesItem.attributes) or (clothesItem and clothesItem.attributes and !table.HasValue(clothesItem.attributes, "thermal_vision")) then
				player:SensesOn()
			end
		end
	end
end

function SWEP:Holster(newWeapon)
	if SERVER then
		local player = self.Owner;
		
		if !(cwBeliefs and (player:HasBelief("creature_of_the_dark") or player:HasBelief("the_black_sea"))) and !player:GetNWBool("hasThermal") and !player:GetNWBool("hasNV") then
			if newWeapon:GetClass() ~= "cw_senses" then
				self.Owner:SensesOff();
			end
		end
	end
	
	return true;
end

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	if SERVER then
		local clothesItem;
		
		if self.Owner.GetClothesEquipped then
			clothesItem = self.Owner:GetClothesEquipped();
		end
				
		if (cwBeliefs and self.Owner.HasBelief and (self.Owner:HasBelief("creature_of_the_dark") or self.Owner:HasBelief("the_black_sea"))) or (clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "thermal_vision")) then
			if !self.Owner.sensesOn then
				self.Owner:SensesOn();
			else
				self.Owner:SensesOff();
			end
		end
		
		self:SetNextPrimaryFire(CurTime() + 2);
		
		return false;
	end
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	if SERVER then
		local clothesItem;
		
		if self.Owner.GetClothesEquipped then
			clothesItem = self.Owner:GetClothesEquipped();
		end
		
		if (clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "night_vision")) then
			if !self.Owner.sensesOn then
				self.Owner:SensesOn(true);
			else
				self.Owner:SensesOff();
			end
			
			self:SetNextSecondaryFire(CurTime() + 2);
		elseif cwBeliefs and self.Owner.HasBelief and (self.Owner:HasBelief("embrace_the_darkness")) and !self.Owner.opponent then
			local lastZone = self.Owner:GetCharacterData("LastZone");
			local valid_zones = {"scrapper", "caves", "wasteland"};
			
			if cwDayNight and cwDayNight.currentCycle == "night" and table.HasValue(valid_zones, lastZone) then
				if self.Owner:Crouching() then
					if !self.Owner.cloaked then
						local curTime = CurTime();

						if !self.Owner.cloakCooldown or self.Owner.cloakCooldown <= curTime then
							self.Owner:Cloak();
						else
							Schema:EasyText(self.Owner, "chocolate", "You are covered in black powder and cannot cloak for "..math.Round(self.Owner.cloakCooldown - curTime).." seconds!");
						end
					else
						self.Owner:Uncloak();
					end
				else
					Schema:EasyText(self.Owner, "chocolate", "You must be crouching in order to toggle cloaking.");
				end
			else
				Schema:EasyText(self.Owner, "peru", "You must be in the wasteland and it must be nighttime in order to toggle cloaking.");
			end
			
			self:SetNextSecondaryFire(CurTime() + 2);
		end
	end
	
	return false;
end;