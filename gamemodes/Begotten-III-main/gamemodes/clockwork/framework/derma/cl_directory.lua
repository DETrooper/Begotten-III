--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

surface.CreateFont("manifestoLogoFont", {
	font		= "Immortal",
	size		= 24,
	weight		= 600,
	antialiase	= true,
	additive 	= false
});

surface.CreateFont("manifestoCategoryFont", {
	font		= "Dominican Small Caps",
	size		= 24,
	weight		= 100,
	antialias 	= true,
	shadow 		= false
});

surface.CreateFont("manifestoBreadcrumbs", {
	font		= "Day Roman",
	size		= 24,
	weight		= 500,
	antialias 	= true,
	shadow 		= true
});

surface.CreateFont("manifestoBreadcrumbsURL", {
	font		= "Day Roman",
	size		= 24,
	weight		= 500,
	antialias 	= true,
	shadow 		= true,
	underline = true,
});

Clockwork.fonts:Add("manifestoContentHeader", {
	font		= "Day Roman",
	size		= 32,
	weight		= 600,
	antialiase	= true,
	additive 	= false,
	extended 	= true
});

Clockwork.fonts:Add("manifestoContentSubtitle", {
	font		= "Day Roman",
	size		= 24,
	weight		= 600,
	antialiase	= true,
	additive 	= false,
	extended 	= true
});

Clockwork.fonts:Add("manifestoContent", {
	font		= "Day Roman",
	size		= 18,
	weight		= 600,
	antialiase	= true,
	additive 	= false,
	extended 	= true
});

local PANEL = {};
local bgImage = Material("begotten/ui/oilcanvas.png")

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());

	local manifestoPanel = vgui.Create("DPanel", self);
	
	manifestoPanel:SetSize(self:GetWide() - 8, self:GetTall() - 7);
	manifestoPanel:SetPos(4, 0);
	
	self.manifestoPanel = manifestoPanel;
	
	local header = vgui.Create("DPanel", manifestoPanel);
	
	header:SetSize(manifestoPanel:GetWide(), 150);
	
	header.Paint = function(panel, w, h)
		surface.SetDrawColor(0, 0, 0, 252);
		surface.DrawRect(0, 0, w, h);
	end
	
	local logoHolder = vgui.Create("DPanel", header);
	logoHolder:SetSize(250, 100);
	logoHolder:CenterHorizontal();
	logoHolder:CenterVertical(0.48);
	
	local manifestoLogo = vgui.Create("DImage", logoHolder);
	
	manifestoLogo:SetSize(250, 65);
	manifestoLogo:SetImage("begotten/ui/manifesto/Site-logo.png");
	manifestoLogo:CenterHorizontal();
	
	local manifestoTitle = vgui.Create("DLabel", logoHolder);
	
	manifestoTitle:SetText("Manifesto");
	manifestoTitle:SetFont("manifestoLogoFont");
	manifestoTitle:SetTextColor(Color(190, 57, 64));
	manifestoTitle:SizeToContents();
	manifestoTitle:CenterHorizontal();
	manifestoTitle:SetY(66);
	
	local logoButton = vgui.Create("DButton", header);
	
	logoButton:SetSize(logoHolder:GetWide(), logoHolder:GetTall());
	logoButton:SetPos(logoHolder:GetX(), logoHolder:GetY());
	logoButton:SetAlpha(0);
	
	logoButton.DoClick = function()
		Clockwork.directory.panel:OpenPage(nil); -- Open the home page.
	end
	
	local headerButtonList = vgui.Create("DPanelList", header);
	local width = 0;
	
	headerButtonList:EnableHorizontal(true);
	headerButtonList:SetSpacing(16);
	headerButtonList:SetY(header:GetTall() - 32);
	headerButtonList:SetPaintBackground(false);

	for k, v in SortedPairs(Clockwork.directory.stored) do
		if !v.adminOnly or Clockwork.Client:IsAdmin() then
			local button = vgui.Create("cwLabelButton", header);
			
			button:SetFont("manifestoCategoryFont");
			button:SetText(k);
			button:SizeToContents();
			
			button.DoClick = function()
				Clockwork.directory.panel:OpenPage(button:GetText());
			end
			
			width = width + button:GetWide() + 16;
			
			headerButtonList:AddItem(button);
		end
	end
	
	headerButtonList:SetWide(width);
	headerButtonList:SetTall(30);
	headerButtonList:CenterHorizontal();
	
	self.header = header;
	
	local body = vgui.Create("DPanel", self);
	
	body:SetSize(self:GetWide(), self:GetTall() - header:GetTall());
	body:SetY(header:GetTall());
	
	local bodyList = vgui.Create("DPanelList", body);
	
	bodyList:SetSpacing(4);
	bodyList:SetPadding(8);
	bodyList:SetSize(body:GetWide(), body:GetTall());
	bodyList:SetPaintBackground(false);
	bodyList:EnableHorizontal(false);
	bodyList:EnableVerticalScrollbar(true);
	
	body.panelList = bodyList;
	
	--[[local mainMenuPanelList = vgui.Create("DPanelList", body);
	local width = 0;
	
	for i, v in ipairs(buttonList) do
		local button = vgui.Create("DImageButton", body);
		
		button:SetImage("begotten/ui/charactermenu/characterframe.png");
		button:SetSize(160, 256);
		
		width = width + button:GetWide() + 30;
		
		mainMenuPanelList:AddItem(button);
	end
	
	mainMenuPanelList:EnableHorizontal(true);
	mainMenuPanelList:EnableHorizontalScrollbar();
	mainMenuPanelList:SetSpacing(30);
	mainMenuPanelList:SetSize(730, 266);
	mainMenuPanelList:CenterHorizontal();
	mainMenuPanelList:SetY(24);
	mainMenuPanelList:SetPaintBackground(false);]]--
	
	self.body = body;
	
	local hbar = vgui.Create("DImage", manifestoPanel);
	hbar:SetPos(0, header:GetTall() - 1);
	hbar:SetSize(manifestoPanel:GetWide(), 3);
	hbar:SetImage("begotten/ui/hbar.png");
	
	self:OpenPage(nil); -- Open the home page.
	
	Clockwork.directory.panel = self
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h);
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(bgImage)
	surface.DrawTexturedRect(4, 4, w - 8, h - 8)
	
	return true;
end;

function PANEL:OpenPage(...)
	local args = {...};

	for k, panel in pairs(self.body.panelList.Items) do
		panel:Remove();
	end
	
	self.body.panelList:CleanList();
	
	if !args[1] or args[1] == "" then
		Schema:DirectoryOpenHomePage(self.body);
	else
		local pathText = vgui.Create("RichText", self.body);
		
		pathText:SetWide(self.body.panelList:GetWide() - self.body.panelList:GetPadding());
		pathText:SetVerticalScrollbarEnabled(false);
		
		pathText:InsertColorChange(255, 20, 20, 255)
		pathText:InsertClickableTextStart("");
		pathText:AppendText("Home")
		pathText:InsertClickableTextEnd();
		
		pathText:InsertColorChange(220, 220, 220, 255)
		pathText:AppendText(" > ");
		pathText:AppendText(args[1]);
		
		function pathText:PerformLayout()
			self:SetUnderlineFont("manifestoBreadcrumbsURL");
			self:SetFontInternal("manifestoBreadcrumbs");
		end
		
		function pathText:OnTextClicked(id)
			Clockwork.directory.panel:OpenPage(id);
		end
		
		pathText:SizeToContentsY();
		
		self.body.panelList:AddItem(pathText);
		
		hook.Run("DirectoryOpenPage", self.body, ...);
	end
end

vgui.Register("cwDirectory", PANEL, "EditablePanel");