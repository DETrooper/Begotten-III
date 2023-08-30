--[[
	Clockwork: Hyperboreal is developed and maintained by cash wednesday.
--]]

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Changes the model of the turret (for use especially when it has already been spawned)
function ENT:ChangeModel(model)
	self:SetModel(model)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local physObj = self:GetPhysicsObject();
	
	if (physObj:IsValid() and util.IsValidProp(model)) then
		physObj:Wake();
	else
		local vectorMin = Vector() * -4;
		local vectorMax = Vector() * 4;
 	 
		self:PhysicsInitBox(vectorMin, vectorMax);
 	 
	 	local physObj = self:GetPhysicsObject();
		
	 	if (IsValid(physObj)) then
	 		physObj:Wake();
	 	end;

		self:SetCollisionBounds(vectorMin, vectorMax);
	end;

	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	self:StartMotionController()
	self:SetNWAngle("OffsetAngle", self.OffsetAngle)
	self:SetNWVector("MuzzlePos", self.MuzzlePos)
	
	if (self.Mount) then
		self:SetLocalPos(self:GetLocalPos() - self.Mount:WorldToLocal(self:GetOffsetPos()));
	end;
end;

-- A function to set the default characteristics of the turret.
function ENT:SetDefaultParameters()
	self.Model = "models/weapons/w_mach_m249para.mdl";
	self.TurnSpeed = 5;
	self.ShootSound = Sound("Weapon_M249.Single");
	self.Delay = 0.06;
	self.Automatic = true;
	self.Recoil = 0.01;
	self.MuzzleEffect = "turret_mzl_mg";
	self.MuzzlePos = Vector(30, 0, 4);
	self.OffsetPos = Vector(14.5, 0, -1.5);
	self.OffsetAngle = Angle(-2, 0, 0);
	self.Bullet = {
		Num = 1,
		Spread = Vector(0.02, 0.02, 0),
		Tracer = 1,
		TracerName = "Tracer",
		Force = 10,
		Damage = 15,
		Attacker = self.Gunner
	};
end;

-- Called just before the turret initializes.
function ENT:PreInitialize() end;

-- Called just af ter the turret initializes.
function ENT:PostInitialize() end;

-- A function to force the entity to initialize.
function ENT:ForceInit()
	self:PreInitialize();
	self:ChangeModel(self.Model);

	if (!IsValid(self.Mount)) then
		local position = self:GetPos();
		local angles = self:GetAngles();
		
		self.Mount = ents.Create("cw_mounted")
		self.Mount:SetPos(position);
		self.Mount:SetAngles(angles);
		self.Mount:Spawn();
		
		self:SetPos(self.Mount:LocalToWorld(-1 * self.OffsetPos));
		self:SetParent(self.Mount);
		self.Mount.Gun = self

		local mountProp = self:GetMountProp();
		mountProp.player = self.player;
		mountProp.Gun = self;
	end

	self.Gunner = NULL;
	self.RecoilOffset = Vector(0, 0, 0);
	self.NextShot = 0;
	self.Activated = false;
	self.Sleeping = true;
	self:PostInitialize();
end;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetDefaultParameters();
end;

-- Called when the entity is removed.
function ENT:OnRemove() 
	self:StopMotionController();
	self.Mount:Remove();
end;

-- Called when the player presses mouse one.
function ENT:FireShot()
	local curTime = CurTime();
	
	if (self.NextShot > curTime) then
		return;
	end;
	
	local model = self:GetModel();
	
	if (string.find(model, "sniper")) then
		timer.Simple(0.5, function()
			self:EmitSound("npc/sniper/reload1.wav")
		end);
	end;
	
	self.NextShot = curTime + self.Delay;
	self:EmitSound(self.ShootSound, 100, 100);

	local shootOrigin = self:GetMuzzlePos();
	local angles = self:GetAngles();
	local shootDirection = angles:Forward();

	self.Bullet.Src = shootOrigin;
	self.Bullet.Dir = shootDirection;
	self.Bullet.Attacker = self.Gunner;
	self:FireBullets(self.Bullet);

	local effectData = EffectData();
		effectData:SetOrigin(self.MuzzlePos);
		effectData:SetNormal(Vector(1, 0, 0));
		effectData:SetEntity(self);
	util.Effect(self.MuzzleEffect, effectData);
	
	local gunnerPosition = self.Gunner:GetPos();
	local randomVector = VectorRand();

	self.RecoilOffset = 0.8 * (self.RecoilOffset + randomVector * self.Recoil);
--	util.ScreenShake(gunnerPosition, self.Recoil * 25000, 5, 0.1, 100);
end;

-- A function to get if the turret can fire or not.
function ENT:CanFire()
	if (self.Automatic) then
		return self.Gunner:KeyDown(IN_ATTACK);
	end;
	
	return self.Gunner:KeyPressed(IN_ATTACK);
end;

-- A function to set the turret's gunner.
function ENT:SetGunner(player)
	player:SelectWeapon("cw_hands");
	player.MountedGun = self;
	
	self.Gunner = player;
	self:DisableGunnerWeapons();
	self.Activated = true;
	self.Sleeping = false;
	
	local physObj= self:GetPhysicsObject();
	
	if (IsValid(physObj)) then
		physObj:Wake();
	end;
	
	if (string.find(self:GetModel(), "sniper")) then
		self.Gunner:SetFOV(40, 0.3);
	end;
	
	local playerPosition = player:GetPos();
	local playerAngles = player:GetAngles();
	
	self.Gunner:SetSharedVar("mountedGun", self);
	player:SetForcedAnimation("ACT_IDLE_MANNEDGUN", 0)
	player:SetSharedVar("StancePos", playerPosition);
	player:SetSharedVar("StanceAng", playerAngles);
	player:SetSharedVar("StanceIdle", true);
end;

-- A function to remove the turret's active gunner.
function ENT:RemoveGunner()
	if (IsValid(self.Gunner)) then
		self.Gunner.MountedGun = nil;
		self.Gunner:SetSharedVar("mountedGun", nil);
		self.Gunner:SetForcedAnimation(false);
		self.Gunner:SetFOV(0, 0.3);
	end;
	
	if (IsValid(self.Gunner) and self.Gunner:Alive()) then
		self:EnableGunnerWeapons();
	end;
	
	self.Gunner = NULL;
	self.Activated = false;
end;

-- A function to prevent the player from seeing their default weawpons.
function ENT:DisableGunnerWeapons()
	local gunner = self.Gunner;
	local activeWeapon = gunner:GetActiveWeapon();
	
	if (IsValid(activeWeapon)) then
		local viewModel = gunner:GetViewModel();
		local curTime = CurTime();
		
		activeWeapon:SetNextPrimaryFire(curTime + 0.5);
		activeWeapon:SetNextSecondaryFire(curTime + 0.5);
		activeWeapon:SendWeaponAnim(ACT_VM_DRAW);
		
		viewModel:SetNoDraw(true);
	end;
end;

-- A function to re-enable the player's active weapons.
function ENT:EnableGunnerWeapons()
	local gunner = self.Gunner;
	local activeWeapon = self.Gunner:GetActiveWeapon();
	
	if (IsValid(activeWeapon)) then
		local viewModel = gunner:GetViewModel();
		local curTime = CurTime();
		
		activeWeapon:SetNextPrimaryFire(curTime + 0.65);
		activeWeapon:SetNextSecondaryFire(curTime + 0.65);
		activeWeapon:SendWeaponAnim(ACT_VM_DRAW);
		
		viewModel:SetNoDraw(false);
	end;
end;

-- A function to get whether the turret's gunner is valid or not.
function ENT:IsValidGunner(player)
	if (!IsValid(player) or !player:Alive()) then
		return false;
	end;
	
	return true;
end;

-- A function to restrict the orientation angle of the turret.
function ENT:RestrictAngle(targetAngle)
	targetAngle.r = 0;
	return targetAngle;
end;

-- A function to get the muzzle's position in the world.
function ENT:GetMuzzlePos()
	return self:LocalToWorld(self.MuzzlePos);
end;

-- A function to get the offset position in the world.
function ENT:GetOffsetPos()
	return self:LocalToWorld(self.OffsetPos);
end;

-- A function to get the entity that the turret is mounted on.
function ENT:GetMountProp()
	local prop = self.Mount.Prop;
	
	if (IsValid(prop)) then
		return prop;
	end;
	
	return NULL;
end;

-- Called every tick that the entity is valid.
function ENT:Think()
	if (!self.Activated) then
		return;
	end;
	
	if (!self:IsValidGunner(self.Gunner)) then
		self:RemoveGunner();
		return;
	end;

	self:DisableGunnerWeapons()
	
	if (self:CanFire()) then
		self:FireShot();
	else
		self.RecoilOffset = Vector(0, 0, 0);
	end;
	
	local curTime = CurTime();
		self:NextThink(curTime);
	return true;
end

-- Called from the Entity's motion controller to simulate physics. 
function ENT:PhysicsSimulate(phys, deltaTime) 
	if (self.Sleeping) then
		return SIM_NOTHING;
	end;

	local localAngles = self:GetLocalAngles();
	local targetAngle;
	local currentAngle;
	
	if (!self.Activated) then
		targetAngle = self.Mount:GetAngles();
		targetAngle = self.Mount:WorldToLocalAngles(targetAngle);
		currentAngle = LerpAngle(self.TurnSpeed * deltaTime, localAngles, targetAngle);

		if (math.abs(currentAngle.p) < 0.1 and math.abs(currentAngle.y) < 0.1) then
			phys:Sleep();
			self.Sleeping = true;
		end;
	else
		local playerShootPos = self.Gunner:GetShootPos();
		local playerAimVector = self.Gunner:GetAimVector();
		local muzzlePositon = self:GetMuzzlePos();
		
		local trace = {};
			trace.start = playerShootPos + playerAimVector * 120;
			trace.endpos = playerShootPos + playerAimVector * 8192;
			trace.filter = {self.Gunner, self, self.Mount};
		local trace = util.TraceLine(trace);

		local vector = trace.HitPos - muzzlePositon;
		vector:Normalize();
		vector = vector + self.RecoilOffset;
		targetAngle = vector:Angle();
		
		targetAngle = self.Mount:WorldToLocalAngles(targetAngle)
		currentAngle = LerpAngle(self.TurnSpeed * deltaTime, localAngles, targetAngle);
		currentAngle = self:RestrictAngle(currentAngle);
	end;
	
	phys:Wake();
	
	local offsetPosition = self:GetOffsetPos();
	local localPosition = self.Mount:WorldToLocal(offsetPosition);
	local localGunPos = self:GetLocalPos();
	
	self:SetLocalAngles(currentAngle);
	self:SetLocalPos(localGunPos - localPosition);
	return SIM_NOTHING;
end;