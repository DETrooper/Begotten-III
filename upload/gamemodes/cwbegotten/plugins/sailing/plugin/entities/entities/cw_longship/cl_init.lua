--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local name = self:GetNWString("name");
	
	if !name or name:len() == 0 then
		y = Clockwork.kernel:DrawInfo("A large and formidable Goreic warship.", x, y, Clockwork.option:GetColor("white"), alpha);
	else
		y = Clockwork.kernel:DrawInfo("A large and formidable Goreic warship. The name '"..name.."' is chiselled onto its side in Goreic script.", x, y, Clockwork.option:GetColor("white"), alpha);
	end
	
	y = Clockwork.kernel:DrawInfo("A large and formidable Goreic warship.", x, y, Clockwork.option:GetColor("white"), alpha);
end;