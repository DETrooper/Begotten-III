--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local Color = Color;
local surface = surface;
local vgui = vgui;

local PANEL = {};

-- Called when the panel should be painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "PanelList", self, w, h);
end;

vgui.Register("cwPanelList", PANEL, "DPanelList");