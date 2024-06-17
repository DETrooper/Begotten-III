--[[
	Created by cash wednesday.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetBackgroundBlur(false);
	self:SetDeleteOnClose(false);
	self:ShowCloseButton(false);
	self:SetDraggable(false);

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;

	self:SetSize(256 + 8, 72);
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
	self:SetTitle("")
end;

-- A function to populate the panel.
function PANEL:Populate(lockType, bSettingPassword, entity)
	self.title = "Please input a 4-digit combination.";
	self.lockType = lockType;
	self.itemTable = nil;

	if (bSettingPassword) then
		self.title = "Please input your desired 4-digit combination.";
	end;
	
	if (lockType == "combo" or lockType == "turn") then
		local onePos, twoPos, threePos, fourPos = 4, 38, 72, 106;
		local buttonX, buttonWidth = 138, 114;
		local width = 30;
		local max = 9;

		if (lockType == "turn") then
			self.title = "Please enter a 3 number combination."
			
			onePos, twoPos, threePos = 4, 48, 92;
			buttonX, buttonWidth = 136, 116;
			width = 40;
			max = 40;

			if (bSettingPassword) then
				self.title = "Please input your desired 3 number combination."
			end;
		end;

		if (!IsValid(self.valueOne)) then
			self.valueOne = vgui.Create("DNumberWang", self);
			self.valueOne:SetPos(onePos, 28);
			self.valueOne:SetSize(width, 50);
			self.valueOne:SetMin(0);
			self.valueOne:SetMax(max);
			self.valueOne:SetEnabled(false);
			
			-- Called when the value of the panel is changed.
			function self.valueOne.OnValueChanged(value)
				local curTime = CurTime();
				
				if (!Clockwork.Client.NextWangTick or curTime > Clockwork.Client.NextWangTick) then
					Clockwork.Client:EmitSound("buttons/lightswitch2.wav", 60, math.random(215, 235));
					
					Clockwork.Client.NextWangTick = curTime + 0.025;
				end;
			end;
		end;
		
		if (!IsValid(self.valueTwo)) then
			self.valueTwo = vgui.Create("DNumberWang", self);
			self.valueTwo:SetPos(twoPos, 28);
			self.valueTwo:SetSize(width, 50);
			self.valueTwo:SetMin(0);
			self.valueTwo:SetMax(max);
			self.valueTwo:SetEnabled(false);

			-- Called when the value of the panel is changed.
			function self.valueTwo.OnValueChanged(value)
				local curTime = CurTime();
				
				if (!Clockwork.Client.NextWangTick or curTime > Clockwork.Client.NextWangTick) then
					Clockwork.Client:EmitSound("buttons/lightswitch2.wav", 60, math.random(215, 235));
					
					Clockwork.Client.NextWangTick = curTime + 0.025;
				end;
			end;
		end;
		
		if (!IsValid(self.valueThree)) then
			self.valueThree = vgui.Create("DNumberWang", self);
			self.valueThree:SetPos(threePos, 28);
			self.valueThree:SetSize(width, 50);
			self.valueThree:SetMin(0);
			self.valueThree:SetMax(max);
			self.valueThree:SetEnabled(false);

			-- Called when the value of the panel is changed.
			function self.valueThree.OnValueChanged(value)
				local curTime = CurTime();
				
				if (!Clockwork.Client.NextWangTick or curTime > Clockwork.Client.NextWangTick) then
					Clockwork.Client:EmitSound("buttons/lightswitch2.wav", 60, math.random(215, 235));
					
					Clockwork.Client.NextWangTick = curTime + 0.025;
				end;
			end;
		end;

		if (lockType == "combo" and !IsValid(self.valueFour)) then
			self.valueFour = vgui.Create("DNumberWang", self);
			self.valueFour:SetPos(fourPos, 28);
			self.valueFour:SetSize(width, 40);
			self.valueFour:SetMin(0);
			self.valueFour:SetMax(max);
			self.valueFour:SetEnabled(false);
			
			-- Called when the value of the panel is changed.
			function self.valueFour.OnValueChanged(value)
				local curTime = CurTime();
				
				if (!Clockwork.Client.NextWangTick or curTime > Clockwork.Client.NextWangTick) then
					Clockwork.Client:EmitSound("buttons/lightswitch2.wav", 60, math.random(215, 235));
					
					Clockwork.Client.NextWangTick = curTime + 0.025;
				end;
			end;
		end;
		
		if (!IsValid(self.acceptButton)) then
			self.acceptButton = vgui.Create("DButton", self);
			self.acceptButton:SetText("Open");
			self.acceptButton:SetPos(buttonX, 28);
			self.acceptButton:SetSize(buttonWidth * 0.7, 40);
			
			-- Called when the button is clicked.
			function self.acceptButton.DoClick(button)
				local valueOne, valueTwo, valueThree, valueFour = self.valueOne:GetValue(), self.valueTwo:GetValue(), self.valueThree:GetValue(), nil;
				
				if (IsValid(self.valueFour)) then
					valueFour = self.valueFour:GetValue();
				end;
				
				self:SubmitCombination(valueOne, valueTwo, valueThree, valueFour, false, bSettingPassword);
					self:Close(); self:Remove();
				gui.EnableScreenClicker(false);
			end;
		end;

		if (!IsValid(self.acceptUnlockButton)) then
			self.acceptUnlockButton = vgui.Create("DButton", self);
			self.acceptUnlockButton:SetText(" Open\n Unlock");
			self.acceptUnlockButton:SetPos(buttonX + buttonWidth * 0.7 + 2, 28);
			self.acceptUnlockButton:SetSize(buttonWidth * 0.3 + 8, 40);
			
			-- Called when the button is clicked.
			function self.acceptUnlockButton.DoClick(button)
				local valueOne, valueTwo, valueThree, valueFour = self.valueOne:GetValue(), self.valueTwo:GetValue(), self.valueThree:GetValue(), nil;
				
				if (IsValid(self.valueFour)) then
					valueFour = self.valueFour:GetValue();
				end;

				self:SubmitCombination(valueOne, valueTwo, valueThree, valueFour, true, bSettingPassword);
					self:Close(); self:Remove();
				gui.EnableScreenClicker(false);
			end;
				
			if (bSettingPassword) then
				self.acceptUnlockButton:SetEnabled(false);
			end;
		end;
	elseif (lockType == "key") then
		self.title = "Select a key to use with the lock.";
		self:SetSize(264, 72);
		
		local width = self:GetWide();
		
		if (!IsValid(self.spawnIconBackpanel)) then
			self.spawnIconBackpanel = vgui.Create("DPanel", self);
			self.spawnIconBackpanel:SetPos(4, 28);
			self.spawnIconBackpanel:SetSize(40, 40);
		end;
		
		if (!IsValid(self.infoBackpanel)) then
			self.infoBackpanel = vgui.Create("DPanel", self);
			self.infoBackpanel:SetPos(46, 28);
			self.infoBackpanel:SetSize(172, 40);
		end;
		
		if (!IsValid(self.spawnIcon)) then
			self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self))
			self.spawnIcon:SetModel("models/props_junk/cardboard_box004a.mdl");
			self.spawnIcon:SetToolTip("Click here to pick a key from your keyring.");
			self.spawnIcon:SetSize(38, 38);
			self.spawnIcon:SetPos(5, 29);
			self.spawnIcon:SetEnabled(true);
			
			-- Called when the spawn icon is clicked.
			function self.spawnIcon.DoClick(spawnIcon)
				if (IsValid(self.lockpickButton)) then
					self.lockpickButton:SetDisabled(true);
				end;
			
				if (IsValid(Clockwork.Client.KeyPanel)) then
					Clockwork.Client.KeyPanel:Close();
					Clockwork.Client.KeyPanel:Remove();
				end;
				
				Clockwork.Client.KeyPanel = vgui.Create("cwKeyPanel", self);
				Clockwork.Client.KeyPanel:MakePopup();
				Clockwork.Client.KeyPanel:Populate();
				
				self.unlockButton:SetEnabled(false);
				self.spawnIcon:SetEnabled(false);
			end;
		end;
		
		if (!IsValid(self.itemName)) then
			self.itemName = vgui.Create("DLabel", self);
			self.itemName:SetText("Keyring");
			self.itemName:SetTextColor(Color(255, 255, 255));
			self.itemName:SetPos(52, 32);
			self.itemName:SizeToContents();
		end;
		
		if (!IsValid(self.itemDescription)) then
			self.itemDescription = vgui.Create("DLabel", self);
			self.itemDescription:SetText(string.utf8sub("Your collection of keys", 0, 24).."...");
			self.itemDescription:SetTextColor(Color(255, 255, 255));
			self.itemDescription:SetPos(52, 50);
			self.itemDescription:SizeToContents();
		end;

		if (IsValid(self.unlockButton)) then
			self.unlockButton = vgui.Create("DButton", self);
			self.unlockButton:SetText("Unlock");
			self.unlockButton:SetPos(width - 44, 28);
			self.unlockButton:SetSize(40, 40);
			self.unlockButton:SetEnabled(true);
			
			-- Called when the button is clicked.
			function self.unlockButton.DoClick(button)
				self.unlockButton:SetEnabled(false);
				self.spawnIcon:SetEnabled(false);
				
				local keyID = self.itemTable:GetData("KeyID");
				local uniqueID = self.itemTable.uniqueID;
				local itemID = self.itemTable.itemID;
				
				Clockwork.datastream:Start("LockCombo", {
					lockType = "key",
					set = false,
					uniqueID = uniqueID,
					itemID = itemID,
					keyID = keyID
				});
				
				self:Close(); self:Remove();
				gui.EnableScreenClicker(false);
			end;
		end;
	end;
	
	if (!IsValid(self.panelTitle)) then
		self.panelTitle = vgui.Create("DLabel", self);
		self.panelTitle:SetText(self.title);
		self.panelTitle:SetTextColor(Color(255, 255, 255));
		self.panelTitle:SetPos(4, 4);
		self.panelTitle:SizeToContents();
	end;
	
	if (IsValid(self.closeButton)) then
		self.closeButton = vgui.Create("DButton", self);
		self.closeButton:SetText("X");
		self.closeButton:SetSize(18, 18); 
		self.closeButton:SetPos(width - 22, 4);

		-- Called when the button is clicked.
		function closeButton.DoClick()
			self:Close(); self:Remove();
			gui.EnableScreenClicker(false);
		end;
	end;
	
	if (lockType == "key") then
		local x, y = self:GetPos();
		local width = self:GetWide();
		local height = self:GetTall();
		local scrH = ScrH();
		
		self.lockpickButton = vgui.Create("DButton");
		self.lockpickButton:SetText("PICK LOCK");
		self.lockpickButton:SetSize(width, 24); 
		self.lockpickButton:SetPos(x, (scrH / 2) - (height / 2) + 80);
		
		-- Called when the button is clicked.
		function self.lockpickButton.DoClick()
			Clockwork.datastream:Start("StartLockpick");
				self:Close(); self:Remove();
			gui.EnableScreenClicker(false);
		end;
	end;
end;

-- Called every frame that the panel is visible.
function PANEL:Think()
	if (IsValid(self.unlockButton)) then
		if (!self.itemTable) then
			self.unlockButton:SetEnabled(false);
		else
			self.unlockButton:SetEnabled(true);
		end;
	end;
end;

-- A function to change the panel's itemTable.
function PANEL:ChangeItemTable(itemTable)
	local toolTip = "";
	
	if (!itemTable or self.lockType != "key") then
		return;
	elseif (itemTable.description) then
		toolTip = Clockwork.config:Parse(itemTable.description);
	end;

	if (IsValid(self.spawnIcon)) then
		self.spawnIcon:Remove();
	end;
	
	self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
	self.spawnIcon:SetToolTip("Click here to pick a key from your keyring.");
	self.spawnIcon:SetPos(5, 29);
	self.spawnIcon:SetSize(38, 38);
	self.spawnIcon:SetToolTip(toolTip);
	self.spawnIcon:SetModel(itemTable.model);
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (IsValid(self.lockpickButton)) then
			self.lockpickButton:SetDisabled(true);
		end;
		
		if (IsValid(Clockwork.Client.KeyPanel)) then
			Clockwork.Client.KeyPanel:Close();
			Clockwork.Client.KeyPanel:Remove();
		end;
		
		Clockwork.Client.KeyPanel = vgui.Create("cwKeyPanel", self);
		Clockwork.Client.KeyPanel:MakePopup();
		Clockwork.Client.KeyPanel:Populate();
		
		self.unlockButton:SetEnabled(false);
		self.spawnIcon:SetEnabled(false);
	end;
	
	if (IsValid(self.itemName)) then
		self.itemName:SetText(itemTable.name)
		self.itemName:SizeToContents();
	end;
	
	if (IsValid(self.itemDescription)) then
		self.itemDescription:SetText(string.utf8sub(itemTable.description, 0, 24 + 4).."...");
		self.itemDescription:SizeToContents();
	end;
	
	if (IsValid(self.panelTitle)) then
		self.panelTitle:SetText("Click unlock to use this key.");
	end;
	
	local inventory = Clockwork.inventory:GetClient();
	local inventoryList = Clockwork.inventory:GetAsItemsList(inventory);
	local keyItems = 0;
	
	for k, v in pairs (inventoryList) do
		if (v.category == "Keys") then
			self.spawnIcon:SetEnabled(false);
			break;
		end;
	end;
	
	self.itemTable = itemTable;
	self.lockpickButton:SetDisabled(true);
end;

-- A function to send a combination to the server.
function PANEL:SubmitCombination(valueOne, valueTwo, valueThree, valueFour, bUnlock, bSettingPassword)
	local valueTable = {one = valueOne, two = valueTwo, three = valueThree};
	valueTable.lockType = self.lockType;
	
	if (self.lockType) then valueTable.lockType = self.lockType; end;
	if (bSettingPassword) then valueTable.set = true; end;
	if (valueFour) then valueTable.four = valueFour; end;
	if (bUnlock) then valueTable.unlock = true; end;
	
	Clockwork.datastream:Start("LockCombo", valueTable);
end;

-- Called when the panel is closed.
function PANEL:OnClose()
	if (IsValid(self.lockpickButton)) then
		self.lockpickButton:Remove();
	end;
end;

vgui.Register("cwCombinationPanel", PANEL, "DFrame");