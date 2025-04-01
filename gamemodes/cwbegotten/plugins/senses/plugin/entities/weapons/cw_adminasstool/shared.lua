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
	SWEP.PrintName = "Sex Tool";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Primary Fire: Toggle";
SWEP.Purpose = "Sex.";
SWEP.Contact = "";
SWEP.Author	= "";

SWEP.WorldModel = "";
SWEP.ViewModel = "models/weapons/c_arms.mdl";
SWEP.HoldType = "fist";

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

function SWEP:CanPrimaryAttack()
	return true
end;

function SWEP:CanSecondaryAttack()
	return true
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	if (SERVER and cwAdminTool) then
		cwAdminTool:LeftClick(self.Owner)
	end;
	
	self:SetNextSecondaryFire(CurTime() + 0.1);
	return false
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	if (SERVER and cwAdminTool) then
		cwAdminTool:RightClick(self.Owner)
	end;
	
	self:SetNextPrimaryFire(CurTime() + 0.1);
	return false;
end;