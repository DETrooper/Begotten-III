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
	self:SetModel("models/props/de_nuke/cinderblock_stack.mdl");
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
		self.nextUse = CurTime() + 5;
		
		local faction = caller:GetFaction();
		
		if faction == "Holy Hierarchy" --[[or faction == "Gatekeeper"]] or caller:IsAdmin() then
			local position = self:GetPos()
			
			for k, v in pairs (ents.FindInSphere(position + self:OBBMaxs(), 48)) do
				if (v:GetClass() == "cw_item") and v.GetItemTable then
					local itemTable = v:GetItemTable()
					
					if (itemTable.uniqueID == "cinder_block") then
						v:Remove()
					end
				end
			end
			
			local cinderBlockPosition = Vector(795, 12324, -1044)
			local cinderBlock = Clockwork.entity:CreateItem(nil, Clockwork.item:CreateInstance("cinder_block"), cinderBlockPosition)
			
			if (IsValid(cinderBlock)) then
				cinderBlock:SetAngles(Angle(89.736, math.random(0, 360), 90.571))
				
				timer.Simple(0.05, function()
					cinderBlock:EmitSound("physics/concrete/concrete_block_impact_hard"..math.random(1, 3)..".wav", 60)
				end)
			end
			
			Schema:EasyText(Schema:GetAdmins(), "tomato", caller:Name().." has used the cinderblock pile.", nil);
		end;
	end;
end;