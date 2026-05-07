--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

function ENT:Draw()
	if (!self:GetNWBool("primeval")) then
		self:DrawModel()

		return
	end

    render.SetBlend(0.3)
	render.SetColorModulation(0, 0, 0)

	self:SetMaterial("models/debug/debugwhite")
    self:DrawModel()

    render.SetBlend(1)
	render.SetColorModulation(1, 1, 1)

    self:SetMaterial("models/effects/muzzleflash/blurmuzzle")
    self:DrawModel()
    self:DrawModel()
end