--[[
	cwdamation created & developed by cash wednesday
--]]

ENT.Type = "anim";
ENT.Base = "base_anim";
ENT.PrintName = "";
ENT.Author = "";
ENT.AutomaticFrameAdvance = true;
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

function ENT:SetupDataTables()
	self:DTVar("Int", 1, "bonenum");
	self:DTVar("Int", 2, "scale");
	self:DTVar("Entity", 1, "ply");
	self:DTVar("Angle", 1, "angle");
	self:DTVar("Vector", 1, "offset");
	self:DTVar("Bool", 1, "visible");
	self:DTVar("Bool", 2, "bonemerge");
	
	--self:NetworkVar("Int", 4, "scale")
	self.sCarez = self:GetNWInt("scale", 1);
end;