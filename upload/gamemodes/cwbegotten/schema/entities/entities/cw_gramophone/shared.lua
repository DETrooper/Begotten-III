--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "DETrooper";
ENT.PrintName = "Gramophone";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "Begotten";

ENT.tracks = {
	{track = "begotten3soundtrack/hellmanor/forgottennow.mp3", length = 200, volume = 100},
	{track = "begotten3soundtrack/hellmanor/goodnight.mp3", length = 175, volume = 100},
	{track = "begotten3soundtrack/hellmanor/heartaches.mp3", length = 211, volume = 100},
	{track = "begotten3soundtrack/hellmanor/home.mp3", length = 192, volume = 100},
	{track = "begotten3soundtrack/hellmanor/masquerade.mp3", length = 193, volume = 100},
	{track = "begotten3soundtrack/hellmanor/midnight.mp3", length = 206, volume = 100},
	{track = "begotten3soundtrack/hellmanor/moonlight.mp3", length = 120, volume = 100},
	{track = "begotten3soundtrack/hellmanor/anytime.mp3", length = 170, volume = 100},
	{track = "begotten3soundtrack/hellmanor/coquette.mp3", length = 162, volume = 100},
	{track = "begotten3soundtrack/hellmanor/lullaby.mp3", length = 191, volume = 100},
	{track = "begotten3soundtrack/hellmanor/romance.mp3", length = 184, volume = 100},
	{track = "begotten3soundtrack/hellmanor/painteddoll.mp3", length = 161, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_clairdelune.mp3", length = 291, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_pasdeduex.mp3", length = 304, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_symphony.mp3", length = 525, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_thievingmagpie.mp3", length = 358, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_waltz.mp3", length = 451, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_danse.mp3", length = 430, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_sonata.mp3", length = 986, volume = 100},
	{track = "begotten3soundtrack/hellmanor/orchestral_requiem.mp3", length = 536, volume = 100},
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
