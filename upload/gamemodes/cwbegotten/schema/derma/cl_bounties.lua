--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (IsValid(Clockwork.Client.cwBountyMenu)) then
	Clockwork.Client.cwBountyMenu:Close()
	Clockwork.Client.cwBountyMenu:Remove()
	Clockwork.Client.cwBountyMenu = nil;
end

local PANEL = {};

AccessorFunc(PANEL, "m_bPaintBackground", "PaintBackground");
AccessorFunc(PANEL, "m_bgColor", "BackgroundColor");
AccessorFunc(PANEL, "m_bDisabled", "Disabled");

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("");
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(8);
 	self.panelList:SetSpacing(4);
 	self.panelList:StretchToParent(4, 16, 4, 4);
	self.panelList:EnableVerticalScrollbar();
	
	Clockwork.Client.cwBountyMenu = self;
	
	self:Center();
	self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear(true);
	
	local highestBounties = {};
	local bountyPlayers = {};
	
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized() and v:IsWanted()) then
			bountyPlayers[#bountyPlayers + 1] = {
				bounty = v:GetBounty(),
				player = v
			};
		end;
	end;
	
	table.sort(bountyPlayers, function(a, b)
		return a.bounty > b.bounty;
	end);
	
	for k, v in ipairs(bountyPlayers) do
		if (k <= 10) then
			highestBounties[#highestBounties + 1] = v;
		end;
	end;
	
	--[[local addForm = vgui.Create("cwBasicForm", self);
	addForm:SetPadding(4);
	addForm:SetSpacing(4);
	addForm:SetAutoSize(true);
	addForm:SetText("Add Bounty", nil, "basic_form_highlight");
	
	local textEntry = addForm:TextEntry("Name");
	textEntry:SetToolTip("Type part of the player's name here.");
	
	local bountyWang = addForm:NumberWang("Bounty", nil, 100, 10000, 0);
	bountyWang:SetValue(100);
	
	local okayButton = addForm:Button("Okay");
	
	-- Called when the button is clicked.
	function okayButton.DoClick(okayButton)
		Clockwork.datastream:Start("AddBounty", {
			name = textEntry:GetValue(),
			bounty = bountyWang:GetValue()
		});
	end;
	
	self.panelList:AddItem(addForm);]]--
	
	if (#highestBounties > 0) then
		local label = vgui.Create("cwInfoText", self);
			label:SetText("Those listed here have committed transgressions against the Glaze and must be corpsed.");
			label:SetInfoColor("blue");
		self.panelList:AddItem(label);
		
		local bountyForm = vgui.Create("cwBasicForm", self);
		bountyForm:SetPadding(4);
		bountyForm:SetSpacing(4);
		bountyForm:SetAutoSize(true);
		bountyForm:SetText("Top Ten Bounties", nil, "basic_form_highlight");
		
		local panelList = vgui.Create("DPanelList", self);
		
		for k, v in ipairs(highestBounties) do
			local label = vgui.Create("cwInfoText", self);
				label:SetText("("..v.bounty..") "..v.player:Name());
				--label:SetInfoColor(_team.GetColor(v.player:Team()));
			panelList:AddItem(label);
		end;
		
		panelList:SetAutoSize(true);
		panelList:SetPadding(4);
		panelList:SetSpacing(4);
		
		bountyForm:AddItem(panelList);
		
		self.panelList:AddItem(bountyForm);
	else
		local label = vgui.Create("cwInfoText", self);
			label:SetText("There are currently no active bounties, though there are yet enemies of the Glaze.");
			label:SetInfoColor("orange");
		self.panelList:AddItem(label);
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:GetActivePanel() == self) then
		self:Rebuild();
	end;
end;

function PANEL:OnCursorEntered()
	self.cursorInside = true;
end

function PANEL:OnCursorExited()
	self.cursorInside = false;
end

function PANEL:OnMousePressed(keyCode)
	print(self.cursorInside);
	print(keyCode);

	if self.cursorInside == false and keyCode == MOUSE_LEFT then
		self:Remove();
		self = nil;
	end
end

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	DFrame.PerformLayout(self);

	--self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwBountyMenu", PANEL, "DFrame");