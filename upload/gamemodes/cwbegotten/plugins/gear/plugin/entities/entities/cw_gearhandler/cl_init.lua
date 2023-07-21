--[[
	cwdamation created & developed by cash wednesday
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

-- Called when the entity should be drawn.
function ENT:Draw()
	if (!self.Entity:GetDTBool(1)) then
		return;
	end;
	
	if (self.Entity:GetOwner():IsPlayer()) then
		if (GetViewEntity() == Clockwork.Client --[[and !Clockwork.Client:GetThirdPerson()]]) then
			return;
		end;
	end;

	self.Entity:DrawModel();
	self.Entity:DrawShadow(false);
end;

function ENT:Initialize() end;

-- Called every frame the entity is valid.
function ENT:Think()
	if (IsValid(self.Entity:GetParent()) and IsValid(self.Entity:GetDTEntity(1))) then
		local position, angles = self.Entity:GetDTEntity(1):GetBonePosition(self.Entity:GetDTInt(1));
		
		if position and angles then
			local newPosition, newAngles = LocalToWorld(self.Entity:GetDTVector(1), self.Entity:GetDTAngle(1), position, angles);
			
			self.Entity:SetPos(newPosition);
			self.Entity:SetAngles(newAngles);
			self.Entity:SetModelScale(self.Entity:GetNWInt("scale"));
		end
	end;
end;