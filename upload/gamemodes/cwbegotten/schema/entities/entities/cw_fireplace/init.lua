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
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
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
	self.igniteTime = CurTime();
	
	local fire = ents.Create("env_fire")
	if not IsValid(fire) then return end

	fire:SetPos(self:GetPos() + Vector(0, 0, 4));
	--no glow + delete when out + start on + last forever
	fire:SetKeyValue("spawnflags", tostring(128 + 16 + 4 + 2 + 1))
	fire:SetKeyValue("firesize", 1)
	fire:SetKeyValue("fireattack", 1)
	fire:SetKeyValue("damagescale", "1") -- only neg. value prevents dmg

	fire:Spawn()
	fire:Activate()
	
	self:SetNWBool("Ignited", true);
	
	self.fire = fire;
end;

function ENT:Think()
	if self.igniteTime then
		if CurTime() - self.igniteTime >= 900 then
			self:Remove();
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

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:OnRemove()
	if IsValid(self.fire) then
		self.fire:Remove();
	end
end