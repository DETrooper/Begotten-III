--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	y = Clockwork.kernel:DrawInfo("Breach", x, y, colorTargetID, alpha);
	y = Clockwork.kernel:DrawInfo("It can be directly charged.", x, y, colorWhite, alpha);
end;

-- Called when the entity should draw.
function ENT:Draw() self:DrawModel(); end;