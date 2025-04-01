--[[	Begotten III: Jesus Wept	By: DETrooper, cash wednesday, gabs, alyousha35	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]
include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/items/grenadeammo.mdl");
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetHealth(50);
	self:SetSolid(SOLID_VPHYSICS);
	self.exploded = false;
	local physicsObject = self:GetPhysicsObject();
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;
-- A function to kill the entity.
function ENT:Kill()
	self:Remove();
end;
-- Called every tick.
function ENT:Think()
	local itemTable = self.itemTable;	
	if (itemTable and itemTable.GrenadeEntityThink) then
		itemTable:GrenadeEntityThink(self, self.player);
	end;
	self:NextThink(CurTime() + 0.1);
end;
-- A function to pass the grenade weapon's data to the entity.
function ENT:SetUpGrenade(player, itemTable)
	if (IsValid(player)) then
		self.player = player;
	end;	
	if (itemTable and istable(itemTable) and !table.IsEmpty(itemTable)) then
		self.itemTable = itemTable;
	end;
	if (itemTable and itemTable.GrenadeInitalized) then
		itemTable:GrenadeInitalized(self, self.player);
	end;
end;
-- Called when the entity is used.
function ENT:Use(activator, caller, useType, value)
	if (caller:IsPlayer()) then
		local itemTable = self.itemTable;
		if (itemTable and itemTable.PlayerUsedGrenade) then
			itemTable:PlayerUsedGrenade(self, caller);
		end;
	end;
end;
-- Called when the entity is removed.
function ENT:OnRemove()
	local itemTable = self.itemTable;
	if (itemTable and itemTable.GrenadeEntityRemoved) then
		itemTable:GrenadeEntityRemoved(self, self.player);
	end;
end;
-- A function to get whether the entity has exploded or not.
function ENT:HasExploded()
	return self.exploded;
end;
-- A function to explode the entity.
function ENT:Explode(agitator)
	local itemTable = self.itemTable;
	self.exploded = true;
	if (itemTable and itemTable.Explode) then
		itemTable:Explode(self, self.player, agitator)
	end;	
	self:Remove();
end;
-- Called when the entity collides with another physics object.
function ENT:PhysicsCollide(collisionData, collider)
	local curTime = CurTime();
	if (!self.nextCollide or curTime > self.nextCollide) then
		self.nextCollide = curTime + 0.05;		
		local itemTable = self.itemTable;
		if (itemTable and itemTable.PhysicsCollide) then
			itemTable:PhysicsCollide(self, collisionData, collisionData.HitObject);
		end;
	end;
end;
-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	local itemTable = self.itemTable;
	if (itemTable and itemTable.OnTakeDamage) then
		itemTable:OnTakeDamage(self, damageInfo, self.player);
	end;
end;