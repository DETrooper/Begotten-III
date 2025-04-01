--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

-- Called when the entity is created.
function ENT:Initialize()
	self.Entity:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES));
	self:SetSolid(SOLID_NONE);
	self:SetNotSolid(true);
	self:SetMoveType(MOVETYPE_NONE);
	self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY);
	self:SetCollisionBounds(Vector(0, 0, 0), Vector(0, 0, 0));
	
	local physObj = self:GetPhysicsObject();
	
	if (IsValid(physObj)) then
		physObj:AddGameFlag(PLAYER_HELD);
	end;
end;

-- Called when the entity is taking damage.
function ENT:OnTakeDamage() end;

-- Called when the entity collides with anything.
function ENT:PhysicsCollide() end;