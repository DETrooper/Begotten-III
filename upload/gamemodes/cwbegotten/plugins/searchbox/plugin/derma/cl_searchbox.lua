local PANEL = {};

function PANEL:Init()
	self:SetFont("nov_IntroTextSmallDETrooper");
	self:SetTall(30);
	self:SetUpdateOnType(true);
	self:SetTextColor(Color(255,255,255));
	self:SetPaintBackground(false);
	self:SetPlaceholderText("Enter a search term...");

end

DEFINE_BASECLASS("DTextEntry");
function PANEL:Paint(w,h)
	surface.SetDrawColor(255,255,255);
	surface.SetMaterial(Material("begotten/ui/generic_scratch.png"));
	surface.DrawTexturedRect(0,0,w,h);
	BaseClass.Paint(self,w,h);

end

vgui.Register("cwSearchBox", PANEL, "DTextEntry");