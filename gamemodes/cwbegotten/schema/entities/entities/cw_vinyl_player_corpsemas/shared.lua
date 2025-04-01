--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "DETrooper";
ENT.PrintName = "Vinyl Player (Corpsemas)";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "Begotten";

ENT.tracks = {
	{track = "twistmas/christmasland.mp3", length = 148, volume = 100},
	{track = "twistmas/deckthehalls.mp3", length = 70, volume = 100},
	{track = "twistmas/jingebellrock.mp3", length = 133, volume = 100},
	{track = "twistmas/letitsnow.mp3", length = 159, volume = 100},
	{track = "twistmas/looklikechristmas.mp3", length = 170, volume = 100},
	{track = "twistmas/oholynight.mp3", length = 220, volume = 100},
	{track = "twistmas/thefirstnoel.mp3", length = 190, volume = 100},
	{track = "twistmas/whitechristmas.mp3", length = 188, volume = 100},
};

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "off");
	self:DTVar("String", 1, "");
	self:DTVar("Float", 2, 0);
end;

-- A function to get whether the entity is off.
function ENT:IsOff()
	return self:GetDTBool(0);
end;
