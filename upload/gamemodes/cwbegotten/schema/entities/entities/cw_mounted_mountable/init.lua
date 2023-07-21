--[[
	Clockwork: Hyperboreal is developed and maintained by cash wednesday.
--]]

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Called before the entity initializes.
function ENT:PreInitialize()
	self.NextUse = CurTime();
end;

-- A function to get if the input player should be able to use the turret or not.
function ENT:IsValidGunner(player)
	if (!IsValid(player) or !player:Alive()) then
		return false;
	end;
	
	local offsetPosition = self:GetOffsetPos();
	local eyePos = player:EyePos();
	local distance = offsetPosition:Distance(eyePos);
	local aimVector = player:GetAimVector();
	local angles = self.Mount:GetAngles();
	local forward = angles:Forward();
	local dot = aimVector:Dot(forward)

	if (distance > 100 or dot < -0.6) then 
		return false;
	end;
	
	return true;
end;

-- Called when a player uses the entity.
function ENT:Use(activator, caller) 
	if (caller:InVehicle()) then
		return;
	end;
	
	local curTime = CurTime();
	
	if (self.NextUse > curTime) then
		return;
	end;
	
	self.NextUse = curTime + 0.2;

	if (!IsValid(caller) or !caller:Alive()) then
		return;
	end;

	if (caller == self.Gunner) then -- Dismount the activator if he is already gunning the turret
		if (IsValid(self.Gunner)) then
			self.Gunner:SetSharedVar("mountedGun", nil);
			self:RemoveGunner();
		end;
	elseif (self:IsValidGunner(caller)) then
		if (!IsValid(self.Gunner)) then
			self:SetGunner(caller);
		end;
	end;
end;

-- A function to restrict the orientation angle of the turret.
function ENT:RestrictAngle(targetAngle)
	targetAngle.p = math.Clamp(targetAngle.p, -55, 55);
	targetAngle.y = math.Clamp(targetAngle.y, -80,  80);
	targetAngle.r = 0;

	return targetAngle;
end;