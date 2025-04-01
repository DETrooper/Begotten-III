--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "kurozael";
ENT.PrintName = "Radio";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "off");
	self:DTVar("Bool", 1, "crazy");
end;

-- A function to get the frequency.
function ENT:GetFrequency()
	return self:GetNetworkedString("frequency");
end;

-- A function to get if the radio is static.
function ENT:IsStatic()
	return tobool(self:GetNetworkedString("static"));
end;

-- A function to get whether the entity is off.
function ENT:IsOff()
	return self:GetDTBool(0);
end;

function ENT:IsCrazy()
	return self:GetDTBool(1);
end
