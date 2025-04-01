--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local PANEL = {};

function PANEL:Init()
    self.played = false;
    self:SetMouseInputEnabled(false);
end

function PANEL:Think()
    local parent = self:GetParent();

    if self.played or !self.url then return end;
	
    self.played = true;

    self:OpenURL(self.url);
end

function PANEL:SetURL(url)
	self.url = url;
end

vgui.Register("cwVideoPanel", PANEL, "DHTML");