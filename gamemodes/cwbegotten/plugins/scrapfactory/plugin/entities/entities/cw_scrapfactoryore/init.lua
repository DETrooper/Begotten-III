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
	self:SetModel("models/props_mining/rock_caves01.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	--self:SetColor(25, 25, 25, 255);
	self.instantPickupOverride = true;
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		--physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Think()
	local curTime = CurTime();
	
	if (!self.checkCooldown or self.checkCooldown < curTime) then
		self.checkCooldown = curTime + 3;
		
		if (!cwScrapFactory.coalBoxBounds) then
			return;
		end;
		
		if !cwScrapFactory.cycleInProgress then
			if self:GetPos():WithinAABox(cwScrapFactory.coalBoxBounds["lower"], cwScrapFactory.coalBoxBounds["upper"]) then
				cwScrapFactory:StartProcessing();
				self:Remove();
			end
		end
	end
end

function ENT:OnRemove()
	
end;