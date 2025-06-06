
local entMETA = FindMetaTable("Entity")

if SERVER then

	local old_GetVelocity = entMETA.GetVelocity
	function entMETA:GetVelocity()
		if self.IsDrGProjectile then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				return phys:GetVelocity()
			else return old_GetVelocity(self) end
		else return old_GetVelocity(self) end
	end

	local old_SetVelocity = entMETA.SetVelocity
	function entMETA:SetVelocity(velocity)
		if self.IsDrGProjectile then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				return phys:SetVelocity(velocity)
			else return old_SetVelocity(self, velocity) end
		else return old_SetVelocity(self, velocity) end
	end

end
