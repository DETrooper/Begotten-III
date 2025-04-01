--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_c17/trappropeller_engine.mdl");
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

function ENT:OnTakeDamage(damageInfo)
	if self:GetNWBool("broken") ~= true then
		local attacker = damageInfo:GetAttacker();
		
		if IsValid(attacker) and attacker:IsPlayer() then
			if damageInfo:GetDamage() >= 25 then
				self:SetNWBool("broken", true);
				self:EmitSound("physics/metal/metal_box_break2.wav");
				self:EmitSound("ambient/energy/zap9.wav");
				
				Clockwork.chatBox:AddInRadius(nil, "itnofake", "The gorewatch alarm system breaks under the weight of an attack, ceasing its function!", self:GetPos(), config.Get("talk_radius"):Get() * 2);
			end
		end
	end
end

function ENT:Use(activator, caller)
	netstream.Start(caller, "OpenAlarmMenu", self);
end;