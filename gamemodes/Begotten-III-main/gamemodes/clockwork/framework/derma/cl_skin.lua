--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

function ScaleToWideScreen(size)
	return math.min(math.max( ScreenScale(size / 2.62467192), math.min(size, 14) ), size);
end;

local gradma = Material("begotten/ui/generic_bg_gradient.png")

local SKIN = {
	DermaVersion = 1,
	PrintName = "Begotten",
	Author = "cash wednesday & DETrooper"
}

-- A function to draw a generic background.
function SKIN:DrawGenericBackground(x, y, w, h, color, maxAlpha)
	Clockwork.kernel:DrawTexturedGradientBox(2, x, y, w, h, color, maxAlpha or 100);
end;

-- A function to draw a rounded gradient.
function Clockwork.kernel:DrawWithTexture(texture, cornerSize, x, y, width, height, color, maxAlpha, boxOverride ,ca)
	if (!texture) then
		return;
	end;
	
	local gradientAlpha = maxAlpha or 100;
	local gradientTexture = nil
	if (type(texture) == "IMaterial") then
		gradientTexture = texture;
	else
		gradientTexture = Clockwork.kernel:GetMaterial(texture);
	end;

	if (!gradientTexture) then
		return;
	end;
	
	draw.RoundedBox(cornerSize, x, y, width, height, color);

	if (x + 2 < x + width and y + 2 < y + height) then
		surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
		surface.SetMaterial(gradientTexture);
		surface.DrawTexturedRect(x + 2, y + 2, width - 4, height - 4);
	end;
end;

-- A function to draw a rounded gradient.
function Clockwork.kernel:DrawWithTexturae(texture, cornerSize, x, y, width, height, color, maxAlpha, boxOverride ,ca)
	if (!texture) then
		return;
	end;
	
	local gradientAlpha = maxAlpha or 100;
	local gradientTexture = Clockwork.kernel:GetMaterial(texture);

	surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
	surface.SetMaterial(gradientTexture);
	surface.DrawTexturedRect(x + 2, y + 2, width - 4, height - 4);
end;

local scra = Material("begotten/ui/generic_scratch.png")
local dirt = Material("begotten/ui/generic_dirty.png")
-- Called when a frame is painted.
function SKIN:PaintFrame(panel)
	if (!panel.afa and panel.lblTitle) then
		panel.lblTitle:SetFont("atatatwaa");
		panel.lblTitle:SetTextColor(Color(165, 155, 155));
		panel.lblTitle:SetExpensiveShadow(2, Color(0, 0, 0));
		panel.afa = true
	end;
	
	if (panel.taa) then
		if (!panel.asdad) then
			panel.asdad = true;
			panel.taa:SetFont("atatatwaasdad");
			panel.taa:SetTextColor(Color(165, 155, 155));
			panel.taa:SetExpensiveShadow(2, Color(0, 0, 0));
		end;
	end;
	
	Clockwork.kernel:DrawWithTexture(scra, 4, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0), 255);
	Clockwork.kernel:DrawWithTexture(gradma, 4, 1, 1, panel:GetWide() - 2, panel:GetTall() - 2, Color(0, 0, 0), 255);
	
	if (IsValid(panel.parent)) then
		if (panel.parent.ToolTipTitle) then
			Clockwork.kernel:DrawWithTexture(dirt, 4, 2, 21, panel:GetWide() - 4, panel:GetTall() - 23, Color(0, 0, 0), 255);
		end;
	else
		Clockwork.kernel:DrawWithTexture(dirt, 4, 2, 21, panel:GetWide() - 4, panel:GetTall() - 23, Color(0, 0, 0), 255);
	end;
end;

-- Called when a button is painted.
function SKIN:PaintButton(panel)
	local w, h = panel:GetSize();

	if (panel.m_bBackground) then
		local color = Color(40, 40, 40, 255);
		
		if (panel:GetDisabled()) then
			color = Color(30, 30, 30, 255);
		elseif (panel.Depressed) then
			color = Color(70, 0, 0, 255);
		elseif (panel.Hovered) then
			color = Color(70, 20, 20, 255);
		end;

		self:DrawGenericBackground(0, 0, w, h, Color(0, 0, 0, 230));
		self:DrawGenericBackground(1, 1, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
		self:DrawGenericBackground(2, 2, w - 4, h - 4, color);
		self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40));
		
		panel:SetFGColor(200, 200, 200, 255)
	end;
end;

-- Called when a panel is painted.
function SKIN:PaintPanel(panel)
	if (panel.m_bPaintBackground) then
		local w, h = panel:GetSize();
		
		self:DrawGenericBackground(0, 0, w, h, Color(0, 255, 255));
	end;
end;

function SKIN:PaintHScrollBar(panel, w, h)
	--self.tex.Scroller.TrackH( 0, 0, w, h )
	self:DrawGenericBackground(0, 0, w, h, Color(25, 20, 20));
end

function SKIN:PaintVScrollBar(panel, w, h)
	--self.tex.Scroller.TrackV( 0, 0, w, h )
	self:DrawGenericBackground(0, 0, w, h, Color(20, 20, 20));
end

-- Called when a scroll bar grip is painted.
function SKIN:PaintScrollBarGrip(panel, w, h)
	local color = Color(20, 20, 20);

	if (panel.Depressed and panel.Hovered) then
		color = Color(70, 0, 0, 255);
	elseif (panel.Hovered) then
		color = Color(70, 20, 20, 255);
	end;

	self:DrawGenericBackground(0, 0, w, h, Color(0, 0, 0, 230));
	self:DrawGenericBackground(1, 1, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
	self:DrawGenericBackground(2, 2, w - 4, h - 4, color);
	self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 25));
end;

surface.CreateFont("begotsettingsfont", {
	font		= "Dominican Small Caps",
	size		= ScaleToWideScreen(22),
	weight		= 100,
	antialias 	= true,
	shadow 		= false
});

surface.CreateFont("atatatwaa", {
	font		= "Dominican Small Caps",
	size		= ScaleToWideScreen(20),
	weight		= 100,
	antialias 	= true,
	shadow 		= false
});

surface.CreateFont("atatatwaasdad", {
	font		= "Day Roman",
	size		= ScaleToWideScreen(18),
	weight		= 700,
	antialias 	= true,
	shadow 		= false
});

surface.CreateFont("begotsettingsfont2", {
	font		= "Day Roman",
	size		= ScaleToWideScreen(18),
	weight		= 500,
	antialias 	= true,
	shadow 		= true
});

local formtsop = {"formtop3","formtop2","formtop3"};

function RARWS(panel)
	local tall = panel:GetTall();

	if (!panel.fora) then
		if (!USED) then
			USED = 1;
		end;
		
		panel.fora = formtsop[USED];
		USED = math.Clamp(USED + 1, 1, #formtsop + 1);
		if (USED == (#formtsop + 1)) then
			USED = nil;
		end;
		panel.Header:SetFont("begotsettingsfont");

		if (USED == 2) then
			panel.Header:SetTextColor(Color(200, 0, 0));
		else
			panel.Header:SetTextColor(Color(200, 0, 0));
		end;
	end;
	
	if (tall > 21) then
		local tex = "begotten/ui/collapsible3-full.png";
		Clockwork.kernel:DrawWithTexture(tex, 0, 0, 0, panel:GetWide(), panel:GetTall(), Color(0, 0, 0, 200), 200);
		Clockwork.kernel:DrawWithTexture("begotten/ui/"..panel.fora..".png", 0, 0, 0, panel:GetWide(), 21, Color(0, 0, 0, 200), 200);

		return
	end;
	
	Clockwork.kernel:DrawWithTexture("begotten/ui/"..panel.fora..".png", 0, 0, 0, panel:GetWide(), 21, Color(70, 0, 0, 200), 200);
end;

local function PaintNotches( x, y, w, h, num )
	if ( !num ) then
		return
	end

	local space = w / num

	for i=0, num do
		surface.DrawRect( x + i * space, y + 4, 1, 5 )
	end
end

function SKIN:PaintNumSlider( panel, w, h )
	surface.SetDrawColor( Color( 255, 0, 0, 150 ) )
	surface.DrawRect( 8, h / 2 - 1, w - 15, 1 )

	PaintNotches( 8, h / 2 - 1, w - 16, 1, panel.m_iNotches )
end

function DCheckBox:OnChange(val)
	DEFINE_BASECLASS("DCheckBox");

	surface.PlaySound("begotten/ui/buttonclick.wav");

	BaseClass.OnChange(self, val);
end

function SKIN:PaintCheckBox( panel, w, h )
	--draw.RoundedBox(4, 0, 0, w, h, Color(21,21,21,200))

	Clockwork.kernel:DrawWithTexture("begotten/ui/collapsible3-full.png", 4, 0, 0, w, h, Color(100,0,0,200), 200)

	if !panel.flashlerp then 
		panel.flashlerp = 0
	end

	if panel:GetChecked() then 
		panel.flashlerp = math.Approach(panel.flashlerp, 0, FrameTime()*250)
		draw.RoundedBox(2, 2.5, 2.5, w - 6, h - 6, Color(175 + panel.flashlerp,panel.flashlerp,panel.flashlerp,100))
	else 
		panel.flashlerp = 255
	end

	--[[surface.SetDrawColor( Color( 255, 0, 0, 150 ) )
	surface.DrawRect( 0, 0, w, h )]]
end

-- Called when a collapsible category is painted.
function SKIN:PaintCollapsibleCategory(panel)
	RARWS(panel, self)
end;

-- Called when a panel list is painted.
function SKIN:PaintPanelList(panel)
	if (panel.m_bBackground) then
		Clockwork.kernel:DrawWithTexture(gradma, 4, 2, 21, panel:GetWide() - 4, panel:GetTall() - 23, Color(0, 0, 0), 255);
	end;
end;

-- Called when a property sheet is painted.
function SKIN:PaintPropertySheet(panel)
	local activeTab = panel:GetActiveTab();
	local offset = 0;
	
	if (activeTab) then
		offset = activeTab:GetTall();
	end;
	if (!panel.paff) then
		Clockwork.kernel:DrawWithTexture(gradma, 0, 8, offset - 15, panel:GetWide(), panel:GetTall() - offset + 15, Color(40, 40, 40), 200);
	else
		Clockwork.kernel:DrawWithTexture(gradma, 0, 0, -4, panel:GetWide(), panel:GetTall() - offset, Color(40, 40, 40), 200);
	end;
end;

-- Called when a menu is painted.
function SKIN:PaintMenu(panel)
	local w, h = panel:GetSize()
	self:DrawGenericBackground(0, 0, w, h, Color(40, 40, 40, 255), 100);
end;

-- Called when a menu option is painted.
function SKIN:PaintMenuOption(panel)
	if (panel.m_bBackground) then
		local w, h = panel:GetSize();
		local color = Color(60, 60, 60, 255);

		if (panel.Depressed) then
			color = Color(140, 0, 0, 255)
		elseif (panel.Hovered) then
			color = Color(70, 0, 0, 255)
		end;

		self:DrawGenericBackground(0, 1, w, h, Color(0, 0, 0, 230));
		self:DrawGenericBackground(1, 2, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
		self:DrawGenericBackground(2, 3, w - 4, h - 4, color);
		self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40), 0);
		panel:SetFGColor(Color(175, 175, 175))
	end;
end;

-- Called when a tab is painted.
function SKIN:PaintTab(panel)
	local w, h = panel:GetWide(), panel:GetTall();

	if (panel:GetPropertySheet():GetActiveTab() == panel) then
		local color = Color(70, 0, 0, 255)
		self:DrawGenericBackground(0, 1, w, h, Color(0, 0, 0, 230));
		self:DrawGenericBackground(1, 2, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
		self:DrawGenericBackground(2, 3, w - 4, h - 4, color);
		self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40));
	else
		local color = Color(60, 60, 60, 255);
		self:DrawGenericBackground(0, 1, w, h, Color(0, 0, 0, 230));
		self:DrawGenericBackground(1, 2, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
		self:DrawGenericBackground(2, 3, w - 4, h - 4, color);
		self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40));
	end;
end;

-- Called when a tree is painted.
function SKIN:PaintTree(panel)
	if (panel.m_bBackground) then
		local color = Color(75, 75, 75, 255);
		local w, h = panel:GetWide(), panel:GetTall();
		self:DrawGenericBackground(0, 0, w, h, Color(0, 0, 0, 230));
		self:DrawGenericBackground(1, 2, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
		self:DrawGenericBackground(2, 3, w - 4, h - 4, color);
		self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40));
	end;
end;

function SKIN:PaintCategoryList( panel, w, h )
	local color = Color(60, 60, 60, 255);
	self:DrawGenericBackground(0, 0, w, h, Color(0, 0, 0, 230));
	self:DrawGenericBackground(1, 1, w - 2, h - 2, Color(color.r + 30, color.g + 30, color.b + 30));
	self:DrawGenericBackground(2, 2, w - 4, h - 4, color);
	self:DrawGenericBackground(3, h * 0.5, w - 6, h - h * 0.5 - 2, Color(0, 0, 0, 40));
end;

-- Called when a tree node button is painted.
function SKIN:PaintTreeNodeButton(panel)
	panel:SetFGColor(Color(225, 225, 225));
	if (panel.m_bSelected) then
		surface.SetDrawColor(70, 0, 0, 200);
		panel:DrawFilledRect();
		panel:SetFGColor(Color(255, 255, 255));
	elseif (panel.Hovered) then
		surface.SetDrawColor(255, 255, 255, 200);
		panel:DrawFilledRect();
		panel:SetFGColor(Color(40, 0, 0));
	end;
end;

-- Called when a tiny button is painted.
function SKIN:PaintTinyButton(panel)
	if (panel.m_bBackground) then
		surface.SetDrawColor(255, 255, 255, 255);
		panel:DrawFilledRect();
	end;
	
	if (panel.m_bBorder) then
		surface.SetDrawColor(0, 0, 0, 255);
		panel:DrawOutlinedRect();
	end;
end;
-- Called when a list view is painted.
function SKIN:PaintListView(panel)
	if (panel.m_bBackground) then
		surface.SetDrawColor(255, 255, 255, 255);
		panel:DrawFilledRect();
	end;
end;

RunConsoleCommand("tooltip_delay", "0")

function SKIN:PaintTooltip(panel, w, h)
	local w, h = panel:GetSize();
			
	DisableClipping(true);
		for i = 1, 4 do
			local borderSize = i * 2;
			local bgColor = Color(0, 0, 0, (255 / i) * 0.3);
			self:DrawGenericBackground(borderSize, borderSize, w, h, bgColor);
			self:DrawGenericBackground(-borderSize, borderSize, w, h, bgColor);
			self:DrawGenericBackground(borderSize, -borderSize, w, h, bgColor);
			self:DrawGenericBackground(-borderSize, -borderSize, w, h, bgColor);
		end;

		draw.RoundedBox(4, 0, 0, w, h, Color(200,0,0, 50));
		panel:SetTextColor(Color(255, 255, 255, 255));
		panel:SetExpensiveShadow(1, Color(0, 0, 0, 200));
	DisableClipping(false);
end;

derma.DefineSkin("Begotten", "Made for the Begotten framework.", SKIN);