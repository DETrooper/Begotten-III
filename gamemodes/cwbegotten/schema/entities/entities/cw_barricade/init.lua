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
	self:SetModel("models/begotten/misc/goredoor_left.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.BreakSounds = {"physics/wood/wood_strain2.wav", "physics/wood/wood_strain3.wav", "physics/wood/wood_strain4.wav"};
	
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
	local player = damageInfo:GetAttacker();
	
	if IsValid(player) and player:IsPlayer() then
		if !self.strikesRequired then
			self.strikesRequired = 30;
		end
		
		if damageInfo:GetDamage() >= 15 then
			self:EmitSound(self.BreakSounds[math.random(1, #self.BreakSounds)]);
			
			self.strikesRequired = self.strikesRequired - 1;
			
			if self.strikesRequired <= 0 then
				Clockwork.chatBox:AddInTargetRadius(player, "it", "The barricade finally gives way and breaks into several pieces!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				self:EmitSound("physics/wood/wood_plank_break3.wav");
				self:Remove();
			end
		end
	end
end

function ENT:OnRemove()

end