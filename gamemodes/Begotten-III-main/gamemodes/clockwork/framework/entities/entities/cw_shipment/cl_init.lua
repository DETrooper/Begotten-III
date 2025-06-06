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
	local itemTable = self:GetItemTable()

	if (itemTable) then
		y = Clockwork.kernel:DrawInfo("Shipment w/ rations", x, y, colorTargetID, alpha)
		y = Clockwork.kernel:DrawInfo(itemTable.name, x, y, colorWhite, alpha)
	end
end

-- Called when the entity should draw.
function ENT:Draw()
	if (hook.Run("ShipmentEntityDraw", self) != false) then
		self:DrawModel()
	end
end