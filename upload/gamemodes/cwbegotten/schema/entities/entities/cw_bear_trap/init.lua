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
	self.unblockable = true;

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
		local damageInfo = DamageInfo();
		
		damageInfo:SetDamageType(DMG_VEHICLE);
		damageInfo:SetDamage(60);
		damageInfo:SetAttacker(self.owner or self);
		damageInfo:SetInflictor(self);
	
		if entity:IsPlayer() or entity:IsNPC() or entity:IsNextBot() or Clockwork.entity:IsPlayerRagdoll(entity) then
			if Clockwork.entity:IsPlayerRagdoll(entity) then
				entity = Clockwork.entity:GetPlayer(entity);
			end
			
			if entity:IsNPC() or entity:IsNextBot() then
				if string.find(entity:GetClass(), "npc_animal") then
					damageInfo:SetDamage(1000);
				end
				
				self.condition = math.max(0, self.condition - 20);
			elseif entity:IsPlayer() and entity:Alive() then
				Clockwork.chatBox:AddInTargetRadius(entity, "me", "steps on a bear trap, triggering it!", entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				
				if math.random(1, 2) == 1 then
					-- Left leg.
					local LFoot = entity:LookupBone("ValveBiped.Bip01_L_Foot");
					
					if LFoot then
						damageInfo:SetDamagePosition(entity:GetBonePosition(LFoot));
					else
						damageInfo:SetDamagePosition(entity:GetPos());
					end
					
					if cwMedicalSystem and (!cwPowerArmor or !entity:IsWearingPowerArmor()) then
						local injuries = cwMedicalSystem:GetInjuries(entity);
						
						if !(injuries[HITGROUP_LEFTLEG]["broken_bone"]) then
							entity:AddInjury(cwMedicalSystem.cwHitGroupToString[HITGROUP_LEFTLEG], "broken_bone");
							entity:StartBleeding(HITGROUP_LEFTLEG);
						end
						
						Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s left leg audibly breaks with a horrifying snap!", entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
						entity:EmitSound("misc/bone_fracture.wav", 75, math.random(95, 100));
					end
				else
					-- Right leg.
					local RFoot = entity:LookupBone("ValveBiped.Bip01_R_Foot");
					
					if RFoot then
						damageInfo:SetDamagePosition(entity:GetBonePosition(RFoot));
					else
						damageInfo:SetDamagePosition(entity:GetPos());
					end
					
					if cwMedicalSystem and (!cwPowerArmor or !entity:IsWearingPowerArmor()) then
						local injuries = cwMedicalSystem:GetInjuries(entity);
						
						if !(injuries[HITGROUP_RIGHTLEG]["broken_bone"]) then
							entity:AddInjury(cwMedicalSystem.cwHitGroupToString[HITGROUP_RIGHTLEG], "broken_bone");
							entity:StartBleeding(HITGROUP_RIGHTLEG);
						end
						
						Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s right leg audibly breaks with a horrifying snap!", entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
						entity:EmitSound("misc/bone_fracture.wav", 75, math.random(95, 100));
					end
				end
			
				if cwMelee then
					entity:TakeStability(100);
				end
				
				if entity.iFrames then
					entity.iFrames = false;
				end
			end

			self.condition = math.max(0, self.condition - 20);
		end
		
		entity:TakeDamageInfo(damageInfo);
		self:SetSafe();
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