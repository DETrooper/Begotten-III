--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "kurozael"
ENT.PrintName = "Shipment"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.UsableInVehicle = true

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Index")
end

-- A function to get the entity's item table.
function ENT:GetItemTable()
	if (CLIENT) then
		local index = self:GetDTInt(0)

		if (index != 0) then
			return item.FindByID(index)
		end
	end

	return self.cwItemTable
end