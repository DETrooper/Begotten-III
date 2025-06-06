--[[	Begotten III: Jesus Wept	Training Dummy Entity	By: DETrooper--]]
Clockwork.kernel:IncludePrefixed("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
local cwMelee = cwMelee;
-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props/tools/humans/training_dummy/training_dummy.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:CreateBoneFollowers();
	self.isTrainingDummy = true;
	local physicsObject = self:GetPhysicsObject();
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;
-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;function ENT:Use(activator, caller)	if IsValid(caller) and caller:IsPlayer() then		netstream.Start(caller, "OpenDummyMenu", self);	endend
function ENT:Think()
	self:UpdateBoneFollowers();
end
function ENT:OnTakeDamage(damageInfo)
	local player = damageInfo:GetAttacker();
	if IsValid(player) and player:IsPlayer() and player:Alive() then		local hitGroup = Clockwork.kernel:GetRagdollHitGroup(self, damageInfo:GetDamagePosition());				if cwMedicalSystem then			hitGroup = cwMedicalSystem.cwHitGroupToString[hitGroup];		end	
		Clockwork.chatBox:Add(player, nil, "itnofake", "You hit the training dummy in the "..hitGroup.." for "..tostring(damageInfo:GetDamage() or 0).." damage!");
	end
end
function ENT:OnRemove()
	self:DestroyBoneFollowers();		local armorEntity;	local helmetEntity;		if self.armor then		if (self.armor.OnCreateDropEntity) then			armorEntity = self.armor:OnCreateDropEntity(nil, self:GetPos() + Vector(0, 0, 32));		end;				if (!IsValid(armorEntity)) then			armorEntity = Clockwork.entity:CreateItem(nil, self.armor, self:GetPos() + Vector(0, 0, 54));		end;				self.armor = nil;	end		if self.helmet then		if (self.helmet.OnCreateDropEntity) then			helmetEntity = self.helmet:OnCreateDropEntity(nil, self:GetPos() + Vector(0, 0, 32));		end;				if (!IsValid(armorEntity)) then			helmetEntity = Clockwork.entity:CreateItem(nil, self.helmet, self:GetPos() + Vector(0, 0, 54));		end;				self.helmet = nil;	end
endfunction ENT:SetArmorItem(itemTable)	self.armor = itemTable;		if itemTable and itemTable.model then		self:SetNWString("armorModel", itemTable.model);	else		self:SetNWString("armorModel", "");	endendfunction ENT:GetArmorItem()	return self.armor;endfunction ENT:SetHelmetItem(itemTable)	self.helmet = itemTable;		if itemTable and itemTable.model then		self:SetNWString("helmetModel", itemTable.model);	else		self:SetNWString("helmetModel", "");	endendfunction ENT:GetHelmetItem()	return self.helmet;end