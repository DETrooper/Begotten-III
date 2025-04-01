--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_wasteland/prison_padlock001a.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to create a dummy breach.
function ENT:CreateDummyBreach()
	local entity = ents.Create("prop_physics");
	
	entity:SetCollisionGroup(COLLISION_GROUP_WORLD);
	entity:SetAngles(self:GetAngles());
	entity:SetModel("models/props_wasteland/prison_padlock001b.mdl");
	entity:SetPos(self:GetPos());
	
	entity:Spawn();
	
	if (IsValid(entity)) then
		Clockwork.entity:Decay(entity, 30);
	end;
end;

-- A function to set the entity's breach entity.
function ENT:SetBreachEntity(entity, trace)
	local position = trace.HitPos;
	local angles = trace.HitNormal:Angle();
	
	self.entity = entity;
	self.entity:DeleteOnRemove(self);
	
	self:SetPos(position);
	self:SetAngles(angles);
	self:SetParent(entity);
	
	entity.breach = self; self:SetHealth(5);
end;

-- A function to open the entity.
function ENT:BreachEntity(activator)
	self:Explode(); self:Remove();
	
	Clockwork.plugin:Call("EntityBreached", self.entity, activator);
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);
	
	util.Effect("GlassImpact", effectData, true, true);
	
	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth(math.max(self:Health() - damageInfo:GetDamage(), 0));
	
	if (self:Health() <= 0) then
		self:CreateDummyBreach();
		self:BreachEntity(damageInfo:GetAttacker());
	end;
end;