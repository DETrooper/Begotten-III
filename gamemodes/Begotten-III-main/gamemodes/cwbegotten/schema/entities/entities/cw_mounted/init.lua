--[[
	Clockwork: Hyperboreal is developed and maintained by cash wednesday.
--]]

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	if (!self.Prop and !IsValid(self.Prop)) then
		self.Prop = ents.Create("prop_physics");
		self.Prop:SetModel("models/props_lab/tpplug.mdl");
		self.Prop:SetPos(self:LocalToWorld(Vector(0, 0, -8)));
		self.Prop:SetAngles(self:LocalToWorldAngles(Angle(-90, 0, 0)));
		self.Prop:Spawn();
		self.Prop:SetRenderMode(RENDERMODE_TRANSALPHA);
		self.Prop:SetColor(Color(100, 80, 0, 0));
		self:SetParent(self.Prop);
	end;
end;

-- Called when the entity is removed.
function ENT:OnRemove() 
	self.Prop:Remove();
end;