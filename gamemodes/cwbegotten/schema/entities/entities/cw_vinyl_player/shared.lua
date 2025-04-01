--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "DETrooper";
ENT.PrintName = "Vinyl Player";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "Begotten";

ENT.tracks = {
	{track = "apocalypse_ost/asleepinthedeep.ogg", length = 171, volume = 100},
	{track = "apocalypse_ost/butterandeggman.ogg", length = 221, volume = 100},
	{track = "apocalypse_ost/chimesblues.ogg", length = 199, volume = 100},
	{track = "apocalypse_ost/drjazz.ogg", length = 157, volume = 100},
	{track = "apocalypse_ost/goodbyeblues.ogg", length = 158, volume = 100},
	{track = "apocalypse_ost/hottimeintheoldtown.ogg", length = 209, volume = 100},
	{track = "apocalypse_ost/javajive.ogg", length = 185, volume = 100},
	{track = "apocalypse_ost/kidnamedjoe.ogg", length = 181, volume = 100},
	{track = "apocalypse_ost/kisstobuildadreamon.ogg", length = 271, volume = 100},
	{track = "apocalypse_ost/longaboutmidnight.ogg", length = 167, volume = 100},
	{track = "apocalypse_ost/mywalkingstick.ogg", length = 159, volume = 100},
	{track = "apocalypse_ost/oldkentuckyhome.ogg", length = 270, volume = 100},
	{track = "apocalypse_ost/panamarag.ogg", length = 240, volume = 100},
	{track = "apocalypse_ost/personality.ogg", length = 167, volume = 100},
	{track = "apocalypse_ost/putyourheadonmyshoulder.ogg", length = 162, volume = 100},
	{track = "apocalypse_ost/sidekickjoe.ogg", length = 157, volume = 100},
	{track = "apocalypse_ost/stjamesinfirmary.ogg", length = 286, volume = 100},
	{track = "apocalypse_ost/thelambethwalk.ogg", length = 162, volume = 100},
	{track = "apocalypse_ost/wellmeetagain.ogg", length = 198, volume = 100},
	{track = "apocalypse_ost/whisperinggrass.ogg", length = 166, volume = 100},
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
