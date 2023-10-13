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
	self:SetModel("models/begotten/beartrap/beartrapopen.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;

	self:DoSolidCheck();
	self:SetNWString("state", "safe");
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- This is to prevent players from being launched into orbit when the entity becomes solid.
function ENT:DoSolidCheck()
	timer.Simple(1, function()
		if IsValid(self) then
			for i, v in ipairs(ents.FindInSphere(self:GetPos(), 32)) do
				if v:IsPlayer() then
					self:DoSolidCheck();
					
					return;
				end
			end

			self:SetCollisionGroup(COLLISION_GROUP_NONE);
		end
	end);
end

function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();
	
	if IsValid(player) and player:IsPlayer() then
		if self:GetNWString("state") ~= "safe" then
			self:SetSafe();
		end
	end
end

function ENT:Touch(entity)
	if self:GetNWString("state") == "trap" then
		if entity:IsPlayer() or entity:IsNPC() or entity:IsNextBot() then
			local damageInfo = DamageInfo();
			
			damageInfo:SetDamageType(DMG_SLASH);
			damageInfo:SetDamage(60);
			damageInfo:SetAttacker(self.owner or self);
			damageInfo:SetInflictor(self);
			damageInfo:SetDamagePosition(entity:GetPos());
			
			if string.find(entity:GetClass(), "npc_animal") then
				damageInfo:SetDamage(1000);
			elseif entity:IsPlayer() then
				Clockwork.chatBox:AddInTargetRadius(entity, "me", "steps on a bear trap, triggering it!", entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			
				if cwMelee then
					entity:TakeStability(100);
				end
				
				if cwMedicalSystem then
					cwMedicalSystem:PlayerLimbFallDamageTaken(entity, 60);
				end
			end
			
			entity:TakeDamageInfo(damageInfo);
			
			self.condition = math.max(0, self.condition - 20);
			self:SetSafe();
		else
			local class = entity:GetClass();
			
			if class == "prop_physics" or class == "cw_item" or class == "cw_belongings" or class == "prop_ragdoll" then
				self:SetSafe();
			end
		end
	end
end;


function ENT:SetTrap()
	self:SetModel("models/begotten/beartrap/beartrap.mdl");
	self:EmitSound("physics/metal/metal_solid_strain5.wav");
	self:SetNWString("state", "trap");
end

function ENT:SetSafe()
	self:SetModel("models/begotten/beartrap/beartrapopen.mdl");
	self:EmitSound("meleesounds/large-weapon-pullout.wav.mp3");
	self:SetNWString("state", "safe");
end