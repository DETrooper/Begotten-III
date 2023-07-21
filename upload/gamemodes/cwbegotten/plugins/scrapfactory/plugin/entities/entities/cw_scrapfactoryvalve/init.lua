--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwScrapFactory = cwScrapFactory;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_pipes/valvewheel002a.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	
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

function ENT:StartOverheating()
	if self.overheating ~= true then
		self.overheating = true;
		self.sound = CreateSound(self, "ambient/gas/steam_loop1.wav", RecipientFilter():AddPVS(self:GetPos()));
		self.sound:PlayEx(1, 150);
		
		self.steam = ents.Create("prop_physics");
		self.steam:SetPos(self:GetPos());
		self.steam:SetModel("models/hunter/blocks/cube025x025x025.mdl");
		self.steam:Spawn();
		self.steam:SetCollisionGroup(COLLISION_GROUP_WORLD);
		self.steam:SetRenderMode(RENDERMODE_TRANSALPHA);
		self.steam:SetColor(Color(0, 0, 0, 0));
		self.steam:DrawShadow(false);
		
		local physicsObject = self.steam:GetPhysicsObject();
		
		if (IsValid(physicsObject)) then
			physicsObject:Wake();
			physicsObject:EnableMotion(false);
		end;
		
		ParticleEffect("steam_jet_80_steam", self.steam:GetPos(), self.steamAngles or self:GetAngles(), self.steam);
	end
end

function ENT:StopOverheating()
	self.overheating = false;
	
	if IsValid(self.steam) then
		self.steam:Remove();
	end
	
	if self.sound then
		self.sound:Stop();
	end
end

function ENT:Use(activator, caller)
	--[[if IsValid(caller) and caller:IsPlayer() then
		if self.overheating == true then
			Clockwork.datastream:Start(caller, "OpenScrapFactoryValveMenu");
		end
	end;]]--
end;

function ENT:OnRemove()
	if cwScrapFactory.valves then
		for i = 1, #cwScrapFactory.valves do
			if cwScrapFactory.valves[i] == self then
				table.remove(cwScrapFactory.valves, i);
				break;
			end
		end
	end

	if IsValid(self.steam) then
		self.steam:Remove();
	end
	
	if self.sound then
		self.sound:Stop();
	end
end;