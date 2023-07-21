--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;

local PANEL = {};

-- A function to add a text entry.
function PANEL:TextEntry(strLabel)
	local labelPanel = vgui.Create("DLabel", self);
	
	self:AddItem(labelPanel);
	
	labelPanel:SetText(strLabel);
	labelPanel:SetDark(true);
	
	local textEntryPanel = vgui.Create("DTextEntry", self);
	
	self:AddItem(textEntryPanel);

	return textEntryPanel, labelPanel;
end;

vgui.Register("cwForm", PANEL, "DForm");