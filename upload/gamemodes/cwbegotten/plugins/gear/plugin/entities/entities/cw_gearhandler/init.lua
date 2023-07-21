--[[
	cwdamation created & developed by cash wednesday
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	local boneMerge = self:GetDTBool(2);
	
	if (boneMerge) then
		self.Entity:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL));
	end;
	
	self.Entity:AddEffects(EF_PARENT_ANIMATES);
	self:SetSolid(SOLID_NONE);
	self:SetNotSolid(true);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0));
	--BroadcastLua("SCales = "..self.SCales)
end;

-- Called every tick.
function ENT:Think()
	if (self.Entity:GetParent().cwObserverMode == true) then
		if (!self.noDrawn) then
			self:SetNoDraw(true);
			
			self.noDrawn = true;
		end;
	else
		if (self.noDrawn) then
			self:SetNoDraw(false);
			
			self.noDrawn = false;
		end;
	end;
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage() end;

-- Called when the entity collides with a physics object.
function ENT:PhysicsCollide() end;