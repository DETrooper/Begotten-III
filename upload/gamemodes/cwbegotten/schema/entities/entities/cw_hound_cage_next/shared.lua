--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Bokser";
ENT.PrintName = "War Hound Cage";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "Begotten";
if CLIENT then
	function ENT:HUDPaintTargetID(x, y, alpha)
		y = Clockwork.kernel:DrawInfo("A cage used to transport war hounds.", x, y, Clockwork.option:GetColor("white"), alpha);
	end;
end