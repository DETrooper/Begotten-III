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
	self:SetModel("models/objects/common/mission_board.mdl");
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
		local faction = caller:GetFaction();
		
		if faction ~= "Goreic Warrior" then
			local subfaction = caller:GetSubfaction();
			local state = "Wanderer";
			
			if faction == "Holy Hierarchy" or faction == "Aristocracy Of Light"  then
				--if subfaction == "Minister" then
					state = "Hierarchy";
				--else
					--state = "Gatekeeper";
				--end
			elseif faction == "Gatekeeper" or faction == "Hillkeeper" or faction == "Militant Orders of the Villa" then
				--state = "Gatekeeper";
				state = "Hierarchy";
			end
		
			netstream.Start(caller, "OpenBountyBoardMenu", state);
		end;
	end;
end;