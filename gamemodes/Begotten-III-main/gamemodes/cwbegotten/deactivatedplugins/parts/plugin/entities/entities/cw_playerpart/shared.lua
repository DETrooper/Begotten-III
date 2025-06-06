--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

ENT.Type = "anim";
ENT.Base = "base_anim";
ENT.PrintName = "";
ENT.Author = "";
ENT.AutomaticFrameAdvance = true;
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the entity should set up its data tables. 
function ENT:SetupDataTables()
	self:DTVar("Int", 1, "type");
	self:DTVar("Int", 2, "index");
	self:DTVar("Int", 3, "headratio");
end;

-- Called every frame on the client and every tick on the server. 
function ENT:Think()
	local parent = self:GetParent();
	local parentIsPlayer = parent:IsPlayer();
	
	if (IsValid(parent) and parentIsPlayer) then
		if (parent.CalcIdeal) then
			self:SetSequence(parent.CalcIdeal);
		end;
	end;
end;