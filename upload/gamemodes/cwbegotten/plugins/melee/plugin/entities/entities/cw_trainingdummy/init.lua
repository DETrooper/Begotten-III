--[[
	© CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwMelee = cwMelee;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props/tools/humans/training_dummy/training_dummy.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:CreateBoneFollowers();
	self.isTrainingDummy = true;
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Think()
	self:UpdateBoneFollowers();
end

function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();
	
	if IsValid(player) and player:IsPlayer() and player:Alive() then
		Clockwork.chatBox:Add(player, nil, "itnofake", "You hit the training dummy for "..tostring(damageInfo:GetDamage() or 0).." damage!");
	end
end

function ENT:OnRemove()
	self:DestroyBoneFollowers();
end