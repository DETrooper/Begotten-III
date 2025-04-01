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
	self:SetModel("models/begotten/wanderers/scrapperking.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self:ResetSequence(self:LookupSequence("idle_reference"));
	
	if cwPowerArmor then
		if !cwPowerArmor.powerArmors then
			cwPowerArmor.powerArmors = {};
		end
		
		if !cwPowerArmor.powerArmors[self] then
			cwPowerArmor.powerArmors[self] = self;
		end
	end
	
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

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		--[[local faction = caller:GetFaction();
		
		--if faction == "Holy Hierarchy" then
			local subfaction = caller:GetSubfaction();

			if subfaction ~= "Inquisition" then]]--
				netstream.Start(caller, "OpenPowerArmorMenu");
			--[[end
		end;]]--
	end;
end;