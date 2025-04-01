--[[
	Created by cash wednesday.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	
	self:ShowCloseButton(false)
	self:SetSize(264, 320);
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2));
	self:SetDraggable(false);
	self:SetTitle("");

	local inventory = Clockwork.inventory:GetClient();
	local inventoryList = Clockwork.inventory:GetAsItemsList(inventory);
	
	self.keyCount = 0;
	
	for k, v in pairs (inventoryList) do
		if (v.category == "Keys") then
			self.keyCount = self.keyCount + 1;
		end;
	end;

	self.panelList = vgui.Create("DPanelList", self);
	
	if (self.keyCount == 0) then
		self.heightOverride = 128;
		self.widthOverride = 320;

	elseif (self.keyCount == 1) then
		self.panelList:SetPadding(0);
		self.panelList:SetSpacing(0);
	elseif (self.keyCount > 1) then
		self.panelList:EnableVerticalScrollbar();
		self.panelList:SetPadding(2);
		self.panelList:SetSpacing(3);
	end;
	
 	self.panelList:SizeToContents();
end;

-- A function to populate the panel.
function PANEL:Populate(itemTable)
	self.panelList:Clear();

	local inventory = Clockwork.inventory:GetClient();
	local inventoryList = Clockwork.inventory:GetAsItemsList(inventory);
	
	for k, v in pairs (inventoryList) do
		if (!v.category or string.lower(v.category) != "keys") then
			continue;
		end;	

		local keylist = vgui.Create("DPanel", self);
		keylist:SetSize(40, 40);
		
		-- Called when the panel is painted.
		function keylist.Paint()
			return true;
		end;
		
		local spawnIconBackpanel = vgui.Create("DPanel", keylist);
		spawnIconBackpanel:SetSize(40, 40);

		local infoBackpanel = vgui.Create("DPanel", keylist);
		infoBackpanel:SetPos(42, 0);
		infoBackpanel:SetSize(214, 40);

		local spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", keylist));
		spawnIcon:SetSize(38, 38);
		spawnIcon:SetPos(1, 1);
		spawnIcon:SetModel(v.model);
		spawnIcon:SetMarkupToolTip(Clockwork.item:GetMarkupToolTip(v));
		
		-- Called when the spawn icon is clicked.
		function spawnIcon.DoClick(spawnIcon)
			if (IsValid(self)) then
				self:Close();
				self:Remove();
			end;
			
			if (IsValid(Clockwork.Client.LockMenu)) then
				Clockwork.Client.LockMenu:ChangeItemTable(v);
			end;
		end;
		
		local itemName = vgui.Create("DLabel", keylist);
		itemName:SetText(v.name);
		itemName:SetPos(40 + 4 + 4, 2 + 2);
		itemName:SetTextColor(Color(255, 255, 255))
		itemName:SizeToContents();

		local itemDescription = vgui.Create("DLabel", keylist);
		itemDescription:SetText(string.sub(v.description, 0, 35).."...");
		itemDescription:SetPos(40 + 4 + 4, 22);
		itemDescription:SetTextColor(Color(255, 255, 255))
		itemDescription:SizeToContents();
		
		self.panelList:AddItem(keylist);
	end;
	
	if (!IsValid(self.panelTitle)) then
		self.panelTitle = vgui.Create("DLabel", self);
		self.panelTitle:SetPos(4, 4);
		self.panelTitle:SetText("Select a key from your keyring.");
		self.panelTitle:SetTextColor(Color(255, 255, 255));
		self.panelTitle:SizeToContents();
	end;
	
	if (!IsValid(self.closeButton)) then
		self.closeButton = vgui.Create("DButton", self);
		self.closeButton:SetText("X");
		self.closeButton:SetSize(18, 18); 
		self.closeButton:SetPos(self:GetWide() - 22, 4);
		
		-- Called when the button is clicked.
		function self.closeButton.DoClick()
			self:Close(); self:Remove();
			gui.EnableScreenClicker(false);
		end;
	end;
	
	if self.keycount and self.keycount <= 0 then
		if (IsValid(self.closeButton)) then
			self.closeButton:Remove();
		end;
		
		if (IsValid(self.panelTitle)) then
			self.panelTitle:SetVisible(false);
		end;
		
		local textWidth, textHeight = Clockwork.kernel:GetCachedTextSize("cwMainText", "You have no keys!");
		local width = self:GetWide();
		
		if (!IsValid(self.keyTitle)) then
			self.keyTitle = vgui.Create("DLabel", self);
			self.keyTitle:SetText("You have no keys!");
			self.keyTitle:SetTextColor(Color(220, 0, 0));
			self.keyTitle:SetFont("cwMainText");
			self.keyTitle:SetPos(width - (textWidth * 1.15), 28);
			self.keyTitle:SizeToContents();
		end;
		
		if (!IsValid(self.closeButton)) then
			local buttonWidth = width * 0.8;
			
			self.closeButton = vgui.Create("DButton", self);
			self.closeButton:SetText("CLOSE");
			self.closeButton:SetSize(buttonWidth, 40); 
			self.closeButton:SetPos(width - buttonWidth, textHeight + 36);
			self.closeButton.Large = true;
			
			-- Called when the button is clicked.
			function self.closeButton.DoClick()
				if (IsValid(Clockwork.Client.LockMenu)) then
					Clockwork.Client.LockMenu:Close();
					Clockwork.Client.LockMenu:Remove();
				end;
				
				self:Close(); self:Remove();
				gui.EnableScreenClicker(false);
			end;
		end;
	end;
	
	local height = self:GetTall();
	
	if (height < 100) then
		self.panelList:EnableVerticalScrollbar();
	end;
end;

-- Called every frame while the panel is active.
function PANEL:Think()
	local canvasTall = self.panelList.pnlCanvas:GetTall();
	local width = self:GetWide();
	local height = self:GetTall();
	local widthOverride;
	local heightOverride;
	local scrW = ScrW();
	local scrH = ScrH();
	
	if (self.widthOverride) then
		widthOverride = self.widthOverride;
	end;
	
	if (self.heightOverride) then
		heightOverride = self.heightOverride;
	end;
	
	local x = (scrW / 2) - (width / 2);
	local y = (scrH / 2) - (self:GetTall() / 2) + 16;
	
	self:SetSize(widthOverride or 264, heightOverride or (canvasTall + 32))
	self:SetPos(x, y);

	if (IsValid(self.closeButton) and !self.closeButton.Large) then
		local buttonWidth = self.closeButton:GetWide();
		self.closeButton:SetPos(width - (buttonWidth + 4), 4);
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.panelList:StretchToParent(4, 28, 4, 4);
	DFrame.PerformLayout(self);
end;

vgui.Register("cwKeyPanel", PANEL, "DFrame");