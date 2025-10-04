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
	self:SetModel("models/fallout3/jukebox.mdl");
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

-- Called each frame.
function ENT:Think()
	local curTime = CurTime();

	if !self:IsOff() and self:GetDTFloat(2) < curTime then
		local selected_track = self.tracks[math.random(1, #self.tracks)];
		
		self:SetDTString(1, selected_track.track);
		self:SetDTFloat(2, CurTime() + selected_track.length + 10);
	end
	
	self:NextThink(curTime + 1);
end

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)
	if IsValid(caller) and caller:IsPlayer() then
		local faction = caller:GetFaction();
		
		if faction == "Holy Hierarchy" or faction == "Aristocracy Of Light" or faction == "Children of Satan" then
			Clockwork.datastream:Start(caller, "OpenGramophoneMenu", state);
		end;
	end;
end;

-- A function to set whether the entity is off.
function ENT:SetOff(off)
	self:SetDTBool(0, off);
	
	if off then
		local selected_track = self.tracks[math.random(1, #self.tracks)];
				
		self:SetDTString(1, selected_track.track);
		self:SetDTFloat(2, CurTime() + selected_track.length);
	else
		self:SetDTString(1, "");
		self:SetDTFloat(2, 0);
	end
end;

-- A function to toggle whether the entity is off.
function ENT:Toggle()
	if (self:IsOff()) then
		self:SetOff(false);
	else
		self:SetOff(true);
	end;
end;
