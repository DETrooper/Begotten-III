--[[
	Clockwork: Hyperboreal is developed and maintained by cash wednesday.
--]]

include("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize() end;

-- Called when the entity is drawn.
function ENT:Draw()
	local offsetAngles = self:GetNWAngle("OffsetAngle", Angle(0, 0, 0));
	local renderAngles = self:LocalToWorldAngles(offsetAngles);

	self:SetRenderAngles(renderAngles);
	self:DrawModel();
end;