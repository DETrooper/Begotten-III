Clockwork.kernel:IncludePrefixed("shared.lua")
-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	y = Clockwork.kernel:DrawInfo("An old training dummy in the shape of a man, made of straw.", x, y, Clockwork.option:GetColor("white"), alpha);
end;