--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorWhite = Clockwork.option:GetColor("white");

	y = Clockwork.kernel:DrawInfo("Customer Service", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();
end;