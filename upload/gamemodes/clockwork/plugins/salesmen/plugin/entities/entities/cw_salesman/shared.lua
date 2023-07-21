--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Author = "kurozael"
ENT.PrintName = "Salesman"
ENT.Spawnable = false
ENT.AdminSpawnable = false

-- Called when the entity is removed.
function ENT:OnRemove()
	if (SERVER and IsValid(self.cwChatBubble)) then
		self.cwChatBubble:Remove()
	end
end