
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Author = "LegAz"
ENT.PrintName = "Player Body"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Begotten"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Clothes")
	self:NetworkVarNotify("Clothes", self.OnNVarChanged)
end