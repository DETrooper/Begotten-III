--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id")
	local colorWhite = Clockwork.option:GetColor("white")
	local amount = self:GetDTInt(0)

	y = Clockwork.kernel:DrawInfo(Clockwork.option:GetKey("name_cash"), x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo(Clockwork.kernel:FormatCash(amount), x, y, colorWhite, alpha)
end

-- Called when the entity should draw.
function ENT:Draw()
	if (hook.Run("CashEntityDraw", self) != false) then
		self:DrawModel()
	end
end