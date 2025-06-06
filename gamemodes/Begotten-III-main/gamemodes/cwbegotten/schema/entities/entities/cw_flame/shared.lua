if SERVER then
	AddCSLuaFile("shared.lua")
end

ENT.Type = "anim";
ENT.Model = Model("models/weapons/w_eq_flashbang_thrown.mdl");

ENT.FireChild = nil
ENT.FireParameters = {size = 120, growth = 1};
ENT.DieTime = 0
ENT.NextHurt = 0
ENT.HurtInterval = 1

-- Called when the entity should set up its data tables.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "Burning");
end;

-- Called when an entity initializes.
function ENT:Initialize()
	self.Entity:SetModel(self.Model);
	self.Entity:DrawShadow(false);
	self.Entity:SetNoDraw(true);

	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
	self.Entity:SetHealth(99999);

	self.NextHurt = CurTime() + self.HurtInterval + math.Rand(0, 3);
	self.Burning = false;
	
	if (self.DieTime <= 0) then
		self.DieTime = CurTime() + 20;
	end;
end;

-- Called every tick on the server and frame on the client.
function ENT:Think()
	if (CLIENT) then
		return;
	end;
	
	local curTime = CurTime();

	if (self.DieTime < curTime) then
		if (self.ExplodeOnDeath) then
			local success, err = pcall(self.Explode, self);

			if (!success) then
				ErrorNoHalt("ERROR CAUGHT: cw_flame: " .. err .. "\n");
			end;
		end;
		
		self:Remove();
		return;
	end;
	
	local position = self:GetPos();
	local velocity = self.Entity:GetVelocity();
	
	if (IsValid(self.FireChild)) then
		if self.NextHurt < curTime then
			local damageInfo = DamageInfo();
			damageInfo:SetDamageType(DMG_BURN);
			damageInfo:SetDamage(math.random(4, 6));
			
			if IsValid(self.DamageParent) then
				damageInfo:SetAttacker(self.DamageParent);
			else
				damageInfo:SetAttacker(self);
			end;
			
			damageInfo:SetInflictor(self.FireChild);
			self:RadiusDamage(damageInfo, position, 64, self);
			self.NextHurt = curTime + self.HurtInterval;
		end;
		
		return;
	elseif (velocity == Vector(0, 0, 0)) then
		self.FireChild = SpawnFire(position, self.FireParameters.size, self.FireParameters.growth, 999, self.DamageParent, self);
		self.Burning = true;
	end;
end;

-- A function to handle radius damage.
function ENT:RadiusDamage(damageInfo, position, radius, inflictor)
	local victims = ents.FindInSphere(position, radius);

	for k, v in pairs(victims) do
		if (IsValid(v) and inflictor:Visible(v)) then
			if (v:IsPlayer() and v:Alive()) then
				v:TakeDamageInfo(damageInfo);
			end;
		end;
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove()
	if (IsValid(self.FireChild)) then
		self.FireChild:Remove();
	end;
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage() end;

-- A function to make the entity explode.
function ENT:Explode()
	local position = self:GetPos();
	
	local effectData = EffectData();
	effectData:SetStart(position);
	effectData:SetOrigin(position);
	effectData:SetScale(256);
	effectData:SetRadius(256);
	effectData:SetMagnitude(50);

	util.Effect("Explosion", effectData, true, true);
	util.BlastDamage(self, self.DamageParent, position, 300, 40);
end;

-- A function to start a specified numbers of fires at a position.
function StartFires(position, count, lifeTime, bExplode, damageOwner)
	for i = 1, count do
		local angle = Angle(-math.Rand(0, 180), math.Rand(0, 360), math.Rand(0, 360));
		local flame = ents.Create("cw_flame");
		flame:SetPos(position);
		flame.DamageParent = damageOwner;
		flame:SetOwner(damageOwner);
		flame.DieTime = CurTime() + lifeTime + math.Rand(-2, 2);
		flame.ExplodeOnDeath = bExplode;
		flame:Spawn();
		flame:PhysWake();
		
		local physObj = flame:GetPhysicsObject();
		
		if (IsValid(physObj)) then
			local forward = angle:Forward();
			
			physObj:SetMass(2);
			physObj:ApplyForceCenter(forward * 500);
			physObj:AddAngleVelocity(Vector(angle.p, angle.r, angle.y));
		end;
	end;
end;

-- A function to spawn a fire entity.
function SpawnFire(position, size, attack, fuel, owner, parent)
	local fire = ents.Create("env_fire");
	
	if (!IsValid(fire) or !IsValid(parent)) then
		return;
	end;
	
	fire:SetParent(parent);
	fire:SetPos(position);
	
	if (owner) then
		fire:SetOwner(owner);
	end;

	fire:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1));
	fire:SetKeyValue("firesize", (size * math.Rand(0.7, 1.1)));
	fire:SetKeyValue("fireattack", attack);
	fire:SetKeyValue("health", fuel);
	fire:SetKeyValue("damagescale", "-10");
	fire:Spawn();
	fire:Activate();
	
	return fire;
end;