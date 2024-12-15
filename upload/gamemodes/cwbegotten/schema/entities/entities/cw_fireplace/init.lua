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
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	self:SetModel("models/begotten/misc/campfire_b.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;

	self:EmitSound("ambient/fire/mtov_flame2.wav", 60, 100);
	self.extinguishTime = CurTime() + 600;
	
	self:CreateFire(1);
end;

function ENT:CreateFire(size)
	if IsValid(self.fire) then self.fire:Remove() end;

	local fire = ents.Create("env_fire")
	if not IsValid(fire) then return end

	fire:SetPos(self:GetPos() + Vector(0, 0, 4));
	--no glow + delete when out + start on + last forever
	fire:SetKeyValue("spawnflags", tostring(128 + 16 + 4 + 2 + 1))
	fire:SetKeyValue("firesize", size or 1)
	fire:SetKeyValue("fireattack", 1)
	fire:SetKeyValue("damagescale", "1") -- only neg. value prevents dmg

	fire:Spawn()
	fire:Activate()
	
	self.fire = fire;
	self:SetNWFloat("firesize", size);
end

function ENT:AddFuel(itemTable)
	if itemTable and itemTable.fireplaceFuel then
		self.extinguishTime = (self.extinguishTime or CurTime()) + itemTable.fireplaceFuel;
		
		self:EmitSound("physics/wood/wood_strain3.wav");
		
		return true;
	end
end

function ENT:Think()
	if self.extinguishTime then
		local timeLeft = self.extinguishTime - CurTime();
	
		if IsValid(self.fire) then
			if timeLeft <= 60 then
				if self.fire:GetInternalVariable("firesize") ~= 0.2 then
					self:CreateFire(0.2);
				end
			elseif timeLeft <= 180 then
				if self.fire:GetInternalVariable("firesize") ~= 0.5 then
					self:CreateFire(0.5);
				end
			elseif timeLeft <= 300 then
				if self.fire:GetInternalVariable("firesize") ~= 0.7 then
					self:CreateFire(0.7);
				end
			elseif timeLeft <= 600 then
				if self.fire:GetInternalVariable("firesize") ~= 1 then
					self:CreateFire(1);
				end
			elseif timeLeft <= 1200 then
				if self.fire:GetInternalVariable("firesize") ~= 1.25 then
					self:CreateFire(1.25);
				end
			else
				if self.fire:GetInternalVariable("firesize") ~= 1.5 then
					self:CreateFire(1.5);
				end
			end
		end
		
		if timeLeft <= 0 then
			self:Remove();
			
			return;
		end
	end
	
	if cwWeather then
		local weather = cwWeather.weather;
		
		if weather == "acidrain" or weather == "bloodstorm" or weather == "thunderstorm" then
			local entPos = self:GetPos() + Vector(0, 0, 4);
			
			if cwWeather:IsOutside(entPos) then
				for k, v in pairs(zones.stored) do
					local boundsTable = v.bounds;
					
					if boundsTable then
						if entPos:WithinAABox(boundsTable.min, boundsTable.max) then
							if !v.hasWeather then return end;
						end
					end
				end
				
				if IsValid(self.fire) then
					self.fire:Remove();
					self:SetNWBool("Ignited", false);
				end
			end
		end
	end
end

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() and IsValid(self.fire) then
		netstream.Start(caller, "OpenFireplaceMenu");
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:OnRemove()
	if IsValid(self.fire) then
		self.fire:Remove();
	end
end