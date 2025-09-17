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
	self:SetModel("models/props_c17/cashregister01a.mdl");
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

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		local faction = caller:GetNetVar("kinisgerOverride") or caller:GetFaction();
		
		if faction ~= "Goreic Warrior" then
			local subfaction = caller:GetSubfaction();
			local state = "Wanderer";
			
			if faction == "Holy Hierarchy" then
				if subfaction == "Minister" then
					state = "Hierarchy";
				else
					-- Inquisition/Knights can get salary from Coinslot the same as Gatekeepers.
					state = "Gatekeeper";
				end
			elseif faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers" or faction == "Hillkeeper" or faction == "Militant Orders of the Villa" then
				state = "Gatekeeper";
			end
			elseif faction == "Aristocracy Of Light" then
				if subfaction == "Ministry" then
					state = "Hierarchy";
				else
					-- Inquisition/Knights can get salary from Coinslot the same as Gatekeepers.
					state = "Gatekeeper";
				end
			netstream.Start(caller, "OpenCoinslotMenu", state);
		end;
	end;
end;