--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

if (IsValid(Clockwork.Client.cwRitualsMenu)) then
	Clockwork.Client.cwRitualsMenu:Close()
	Clockwork.Client.cwRitualsMenu:Remove()
	Clockwork.Client.cwRitualsMenu = nil;
end

if (IsValid(Clockwork.Client.cwChangeAppearanceMenu)) then
	Clockwork.Client.cwChangeAppearanceMenu:Remove()
	Clockwork.Client.cwChangeAppearanceMenu = nil;
end

local matas = Material("begotten/ui/bgtbtnrit1.png")
local matsas = Material("begotten/ui/framesd.png")
local matsafs = Material("begotten/ui/hoss.png")
local bottomBackground = Material("begotten/ui/collapsible3-1-10.png")
local bottomFrame = Material("begotten/ui/panelframe88.png")
local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local scrW = ScrW()
	local scrH = ScrH()
	
	self:SetDeleteOnClose(false)
	self:SetTitle("")
	self:SetDraggable(false)

	self:SetSize(605 + 8, 666)
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) )
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close() self:Remove()
		
		gui.EnableScreenClicker(false)
	end
	
	Clockwork.Client:EmitSound("misc/tele2_fadeout2.wav", 25, 95);
	surface.PlaySound("begotten/ui/buttonclick.wav");
end

-- A function to rebuild the panel.
function PANEL:Rebuild()
	local availableRituals = cwRituals:GetAvailable();
	local width, height = ScrW(), ScrH()
	local sizeW, sizeH = 0.3, 0.5
	
	self.boxbackpane = vgui.Create("DPanel", self)
	self.boxbackpane:SetPos(4, 26)
	self.boxbackpane:SetSize(272, 114)
	
	self:ShowCloseButton(false)
	
	function self.boxbackpane:Paint()
		local width, height = self:GetSize()
		surface.SetDrawColor(255, 0, 0, 255)
		surface.SetMaterial(matsas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.buttonPeform = vgui.Create("DButton", self)
	self.buttonPeform:SetPos(280, 26)
	self.buttonPeform:SetSize(162, 114)
	self.buttonPeform:SetText("Perform")
	self.buttonPeform:SetTextColor(Color(200, 170, 170))
	--self.buttonPeform:SetFont("Ritual_Button")
	self.buttonPeform:SetFont("Ritual_Text")
	
	function self.buttonPeform:Paint()
		local width, height = self:GetSize()
		surface.SetDrawColor(255, 0, 0, 255)
		surface.SetMaterial(matsas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	function self.buttonPeform:DoClick()
		if (!Clockwork.Client.combinations) then
			Clockwork.Client.combinations = {}
		end
		
		if (#Clockwork.Client.combinations < 3) then
			if #Clockwork.Client.combinations == 0 then
				Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You have no items selected to perform a ritual with!");
			else
				Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You need three items selected to perform a ritual!");
			end
			
			return
		end
		
		--netstream.Start("DoRitual", {Clockwork.Client.combinations})
		cwRituals:AttemptRitual(cwRituals:FindRitualByItems(Clockwork.Client.combinations), Clockwork.Client.combinations);
		
		if (IsValid(Clockwork.Client.cwRitualsMenu)) then
			Clockwork.Client.cwRitualsMenu:Close()
			Clockwork.Client.cwRitualsMenu:Remove()
			Clockwork.Client.cwRitualsMenu = nil;
		end
	end
	
	self.buttonHotkey = vgui.Create("DButton", self)
	self.buttonHotkey:SetPos(446, 26)
	self.buttonHotkey:SetSize(163, 114)
	self.buttonHotkey:SetText("Bind")
	self.buttonHotkey:SetTextColor(Color(200, 170, 170))
	--self.buttonHotkey:SetFont("Ritual_Button")
	self.buttonHotkey:SetFont("Ritual_Text")
	
	function self.buttonHotkey:Paint()
		local width, height = self:GetSize()
		surface.SetDrawColor(255, 0, 0, 255)
		surface.SetMaterial(matsas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	function self.buttonHotkey:DoClick()
		if (IsValid(menu)) then
			menu:Remove();
		end;
		
		if (#Clockwork.Client.combinations == 3) then
			local scrW = ScrW();
			local scrH = ScrH();
			local menu = DermaMenu();
			local x, y = self:GetParent():GetPos();
				
			menu:SetMinimumWidth(150);
			
			menu:AddOption("(F1 Menu) Slot #1", function()
				if (#Clockwork.Client.combinations == 3) then
					cwRituals.hotkeyRituals[1] = table.Copy(Clockwork.Client.combinations);
					
					--Clockwork.kernel:SaveSchemaData("hotkeys", cwRituals.hotkeyRituals);
					netstream.Start("SaveRitualBinds", cwRituals.hotkeyRituals);
				end
			end);
			
			menu:AddOption("(F1 Menu) Slot #2", function()
				if (#Clockwork.Client.combinations == 3) then
					cwRituals.hotkeyRituals[2] = table.Copy(Clockwork.Client.combinations);
					
					--Clockwork.kernel:SaveSchemaData("hotkeys", cwRituals.hotkeyRituals);
					netstream.Start("SaveRitualBinds", cwRituals.hotkeyRituals);
				end
			end);
			
			menu:AddOption("(F1 Menu) Slot #3", function()
				if (#Clockwork.Client.combinations == 3) then
					cwRituals.hotkeyRituals[3] = table.Copy(Clockwork.Client.combinations);
					
					--Clockwork.kernel:SaveSchemaData("hotkeys", cwRituals.hotkeyRituals);
					netstream.Start("SaveRitualBinds", cwRituals.hotkeyRituals);
				end
			end);
			
			menu:Open();
			
			menu:SetPos(x + 453, y + 55);
		end
	end
	
	self.box1 = vgui.Create("DPanelList", self)
	self.box1:SetSpacing(0)
	self.box1:SetPadding(8)
	self.box1:SetSize(80, 80)
	self.box1:SetPos(16, 42)
	
	function self.box1:Paint(width, height)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(matas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.box1:EnableVerticalScrollbar(true)
	self.box1:EnableHorizontal(true)
	
	self.box2 = vgui.Create("DPanelList", self)
	self.box2:SetSpacing(0)
	self.box2:SetPadding(8)
	self.box2:SetSize(80, 80)
	self.box2:SetPos(4 + 12 + (88 - 4), 26 + 12 + 4)
	
	function self.box2:Paint(width, height)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(matas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.box2:EnableVerticalScrollbar(true)
	self.box2:EnableHorizontal(true)
	
	self.box3 = vgui.Create("DPanelList",self)
	self.box3:SetSpacing(0)
	self.box3:SetPadding(8)
	self.box3:SetSize(80, 80)
	self.box3:SetPos(4 + 12 + (176 -8 ), 26 + 12 + 4)
	
	function self.box3:Paint(width, height)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(matas)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.box3:EnableVerticalScrollbar(true)
	self.box3:EnableHorizontal(true)

	local boxes = {
		self.box1,
		self.box2,
		self.box3,
	}
	
	self.ritualbackpane = vgui.Create("DPanel", self)
	self.ritualbackpane:SetSize(605, 399)
	self.ritualbackpane:SetPos(4, 144)
	
	function self.ritualbackpane:Paint(width, height)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(matsafs)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	local pozasd, atwt = self.ritualbackpane:GetPos()
	self.ritualItems = vgui.Create("DPanelList", self)
	self.ritualItems:SetSpacing(5)
	self.ritualItems:SetPadding(3)
	self.ritualItems:SetPos(pozasd + 8, atwt + 64 + 8)
	self.ritualItems:SetSize(605 - 20, 399 - (64 + 8))
	
	function self.ritualItems:Paint() end
	
	self.ritualItems:EnableVerticalScrollbar(true)
	self.ritualItems:EnableHorizontal(true)
	
	local inventory = Clockwork.inventory:GetClient()
	local items = {}
	local itemcount = 0
	
	for k, v in pairs (inventory) do
		local itemTable = Clockwork.item:FindByID(k)
		if (itemTable) then
			local category = string.lower(itemTable("category"))

			if (string.find(category, "catalysts")) then
				for i = 1, Clockwork.inventory:GetItemCountByID(inventory, k) do
					itemcount = itemcount + 1
				end
				
				items[#items + 1] = itemTable
			end
		end
	end

	Clockwork.Client.combinations = {}
	self.itemData = {};
	
	if (#items > 0 and itemcount >= 3) then
		local backpanew, backpaneh = self.ritualbackpane:GetSize()
		local textw, texth = Clockwork.kernel:GetCachedTextSize("Ritual_Text", "SELECT THREE ITEMS TO PERFORM A RITUAL...")
		local warning = vgui.Create("DLabel", self.ritualbackpane)
		warning:SetText("SELECT THREE ITEMS TO PERFORM A RITUAL...")
		warning:SetFont("Ritual_Text")
		warning:SetTextColor(Color(170, 10, 10))
		warning:SetPos((backpanew / 2) - (textw / 2), (backpaneh / 2) - (texth / 2) - (128 + 32 + 4))
		warning:SizeToContents()
		
		for k, v in pairs (items) do
			local uniqueID = v("uniqueID")

			local itemCount = Clockwork.inventory:GetItemCountByID(inventory, uniqueID);
			
			for i = 1, itemCount do
				self.itemData.itemTable = v;
				local spawnIcon = vgui.Create("cwRitualItem", self);
				spawnIcon:SetSize(64, 64);
				
				spawnIcon.spawnIcon.DoRightClick = function()
					if (spawnIcon.inbox and IsValid(spawnIcon.box)) then
						self.ritualItems:AddItem(spawnIcon)
						spawnIcon.box:RemoveItem(spawnIcon)
						spawnIcon.box.filled = false
						spawnIcon.box.filledby = nil
						spawnIcon.inbox = nil
						spawnIcon.box = nil
						table.RemoveByValue(Clockwork.Client.combinations, uniqueID)
					else
						for k, v in pairs (boxes) do
							if (v.filled) then
								continue
							end
							
							v.filledby = spawnIcon
							v.filled = true
							spawnIcon.inbox = true
							spawnIcon.box = v
							
							v:AddItem(spawnIcon)
							self.ritualItems:RemoveItem(spawnIcon)
							Clockwork.Client.combinations[#Clockwork.Client.combinations + 1] = uniqueID
							break
						end
					end
				end
				
				self.ritualItems:AddItem(spawnIcon)
			end
		end
	else
		local backpanew, backpaneh = self.ritualbackpane:GetSize()
		local textw, texth = Clockwork.kernel:GetCachedTextSize("Ritual_Text", "YOU DO NOT HAVE ENOUGH RITUAL ITEMS...")
		local warning = vgui.Create("DLabel", self.ritualbackpane)
		warning:SetText("YOU DO NOT HAVE ENOUGH RITUAL ITEMS...")
		warning:SetFont("Ritual_Text")
		warning:SetTextColor(Color(200, 0, 0))
		warning:SetPos((backpanew / 2) - (textw / 2), (backpaneh / 2) - (texth / 2) - (128 + 32 + 4))
		warning:SizeToContents()
	end
	
	if (!self.ritualList) then
		self.ritualList = vgui.Create("DPanelList", self);
		self.ritualList:SetPos(2, 28);
		self.ritualList:SetSize(609, 517);
		self.ritualList:SetSpacing(1);
		self.ritualList:SetPadding(4);
		--self.ritualList:SetDrawBackground(false);
		self.ritualList:EnableVerticalScrollbar();
		self.ritualList:HideScrollbar();
	else
		self.ritualList:Clear();
	end
	
	if table.IsEmpty(availableRituals) then
		local ritualListW, ritualListH = self.ritualList:GetSize()
		local textw, texth = Clockwork.kernel:GetCachedTextSize("Ritual_Text", "YOU HAVE NOT DISCOVERED ANY RITUALS...")
		local warning = vgui.Create("DLabel", self.ritualList)
		
		warning:SetText("YOU HAVE NOT DISCOVERED ANY RITUALS...")
		warning:SetFont("Ritual_Text")
		warning:SetTextColor(Color(200, 0, 0))
		warning:SetPos((ritualListW / 2) - (textw / 2), (ritualListH / 2) - (texth / 2));
		warning:SizeToContents();
	else
		-- Todo later: sort recipes based on tier/quality?
		for k, v in SortedPairsByMemberValue(availableRituals, "name") do
			if v.category == category then
				self:AddRitual(v);
			end
		end
	end
	
	self.ritualList:SetVisible(false);
	
	self.closeButton = vgui.Create("DButton", self)
	self.closeButton:SetText("CLOSE")
	self.closeButton:SetSize(252, 67)
	self.closeButton:SetPos(35, 554)
	self.closeButton:SetTextColor(Color(160, 0, 0))
	self.closeButton:SetFont("nov_IntroTextSmallfaaaaa")
	
	local width, height = self.closeButton:GetWide(), self.closeButton:GetTall()
	local buttonMaterial = Material("begotten/ui/butt24.png")
	
	-- Called when the button is painted.
	function self.closeButton.DoClick()
		if (IsValid(self)) then
			self:Close()
			self:Remove();
			
			Clockwork.Client.cwRitualsMenu = nil;
		end
		
		surface.PlaySound("begotten/ui/buttonclick.wav")
	end
	
	-- Called when the panel is painted.
	function self.closeButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(buttonMaterial)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.listButton = vgui.Create("DButton", self)
	self.listButton:SetText("RITES")
	self.listButton:SetSize(252, 67)
	self.listButton:SetPos(325, 554)
	self.listButton:SetTextColor(Color(160, 0, 0))
	self.listButton:SetFont("nov_IntroTextSmallfaaaaa")
	self.toggled = false;
	
	local width, height = self.listButton:GetWide(), self.listButton:GetTall()
	local buttonMaterial = Material("begotten/ui/butt24.png")
	
	-- Called when the button is painted.
	function self.listButton.DoClick()
		surface.PlaySound("begotten/ui/buttonclick.wav")
		
		if not self.toggled then
			self.toggled = true;
			
			self.boxbackpane:SetVisible(false);
			self.buttonPeform:SetVisible(false);
			self.buttonHotkey:SetVisible(false);
			self.box1:SetVisible(false);
			self.box2:SetVisible(false);
			self.box3:SetVisible(false);
			self.ritualbackpane:SetVisible(false);
			self.ritualItems:SetVisible(false);
			self.ritualList:SetVisible(true);
		else
			self.toggled = false;
			
			self.boxbackpane:SetVisible(true);
			self.buttonPeform:SetVisible(true);
			self.buttonHotkey:SetVisible(true);
			self.box1:SetVisible(true);
			self.box2:SetVisible(true);
			self.box3:SetVisible(true);
			self.ritualbackpane:SetVisible(true);
			self.ritualItems:SetVisible(true);
			self.ritualList:SetVisible(false);
		end
	end
	
	-- Called when the panel is painted.
	function self.listButton.Paint()
		if not self.toggled then
			surface.SetDrawColor(255, 255, 255, 255)
		else
			surface.SetDrawColor(255, 150, 150, 255)
		end
		
		surface.SetMaterial(buttonMaterial)
		surface.DrawTexturedRect(0, 0, width, height)
	end
end

-- A function to add a ritual to the ritual list.
function PANEL:AddRitual(ritualTable)
	local ritualPanel = vgui.Create("cwRitualPanel", self)
	
	ritualPanel:SetRitualData(ritualTable);
	ritualPanel:Rebuild();
	
	self.ritualList:AddItem(ritualPanel);
end

-- Called when the panel is painted.
function PANEL:Paint()
	local width, height = self:GetWide(), self:GetTall()
	local DRAW_BOTTOM = true
	local x, y = 0, 0
	
	if (!IsValid(self.closeButton)) then
		return
	end

	if (DRAW_BOTTOM) then
		surface.SetDrawColor(150, 0, 0, 200)
		surface.SetMaterial(bottomBackground)
		surface.DrawTexturedRect(4, height - 120, 605, 84)
	
		surface.SetDrawColor(75, 75, 75, 200)
		surface.SetMaterial(bottomFrame)
		surface.DrawTexturedRect(4, height - 122, 605, 88)
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	DFrame.PerformLayout(self)
end

-- Called when the panel is closed.
function PANEL:OnClose() end

vgui.Register("cwRitualsMenu", PANEL, "DFrame")

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(769, 100);
end;

-- Called when the panel is initialized.
function PANEL:SetRitualData(ritualData)
	self.ritualData = ritualData;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	local w, h = self:GetSize()
	local ritualData = self.ritualData;
	local requiredBeliefs = ritualData.requiredBeliefs;
	local textw, texth = Clockwork.kernel:GetCachedTextSize("nov_IntroTextSmallDETrooper", ritualData.name)
	
	self.characterFrame = vgui.Create("DImage", self);
	self.characterFrame:SetImage("begotten/ui/charactermenu/necropolisframe.png");
	self.characterFrame:SetSize(600, 100);
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetText(ritualData.name);
	self.nameLabel:SetTextColor(Color(200, 20, 20));
	self.nameLabel:SetFont("nov_IntroTextSmallDETrooper");
	self.nameLabel:SizeToContents();
	--self.nameLabel:SetPos(20, 2);
	self.nameLabel:SetPos(200 - (textw / 2), 1);
	
	self.descriptionText = vgui.Create("DTextEntry", self);
	self.descriptionText:SetTextColor(Color(255, 215, 215, 240));
	self.descriptionText:SetPos(6, 21);
	self.descriptionText:SetSize(392, 76);
	self.descriptionText:SetDrawBackground(false);
	self.descriptionText:SetMultiline(true);
	self.descriptionText:SetText(ritualData.description);
	self.descriptionText:SetEditable(false);
	
	-- Unique requirements for an items should probably not exceed 7.
	self.requirementsList = vgui.Create("DPanelList", self);
	--self.requirementsList:SetPos(300, 18);
	--self.requirementsList:SetSize(476, 64);
	self.requirementsList:EnableHorizontal(true);
	self.requirementsList:CenterHorizontal(0.5);
	self.requirementsList:SetSpacing(4);
	self.requirementsList:SetDrawBackground(false);
	
	self.itemData = {};
	
	for i = 1, #ritualData.requirements do
		self.itemData.itemTable = Clockwork.item:FindByID(ritualData.requirements[i]);
		
		local requiredItem = vgui.Create("cwRitualItem", self);
		
		requiredItem:SetSize(64, 64);
		
		self.requirementsList:AddItem(requiredItem);
	end
	
	--self.requirementsList:SizeToContents();
	self.requirementsList:SetSize(476, 64);
	--self.requirementsList:SetPos(300 + ((476 - self.requirementsList:GetSize()) / 2), 28);
	self.requirementsList:SetPos(300 + 198 - ((68 * #self.requirementsList:GetItems() / 2)), 28);
	
	self.requirementsLabel = vgui.Create("DLabel", self);
	self.requirementsLabel:SetText("Items Required:");
	self.requirementsLabel:SetTextColor(Color(160, 145, 145));
	self.requirementsLabel:SetFont("Decay_FormText");
	self.requirementsLabel:SizeToContents();
	--self.requirementsLabel:SetPos(300 + ((476 - self.requirementsList:GetSize()) / 2) - (self.requirementsLabel:GetSize() / 4), 6);
	self.requirementsLabel:SetPos(446, 6);
end;

vgui.Register("cwRitualPanel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = table.Copy(self:GetParent().itemData);
	self.itemTable = itemData.itemTable;
	self.itemData = itemData;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);

	self:SetSize(64, 64);
	
	if self.itemTable.iconoverride then
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DImageButton", self));
		self.spawnIcon:SetImage(self.itemTable.iconoverride);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = false;
	else
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
		self.spawnIcon:SetModel(model, skin);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = true;
	end
	
	self.spawnIcon:SetItemTable(self.itemTable);
	self.spawnIcon.bWeightless = true;
	
	self.spawnIcon:SetModel(model, skin);
	--self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetSize(64, 64);
	self.cachedInfo = {model = model, skin = skin};
end;

-- Called each frame.
function PANEL:Think()
	local whiteColor = Color(255, 255, 255);
	local name = self.itemTable("name");
	local color = self.itemTable("color");
	local weight = self.itemTable("weight");
	local description = self.itemTable("description");
	local amount = self.itemData.amount or 0;
	local spawnIcon = self.spawnIcon;
	
	if (spawnIcon.isSpawnIcon) then
		spawnIcon:SetColor(color);
	end

	if (self.itemTable.stackable) then
		if (amount > 1) then
			if spawnIcon then
				if !IsValid(spawnIcon.amount) then
					spawnIcon.amount = vgui.Create("DLabel", spawnIcon);
				end
				
				spawnIcon.amount:SetText(amount);
				spawnIcon.amount:SetFont("Decay_FormText");
				spawnIcon.amount:SetTextColor(Color(160, 145, 145));
				spawnIcon.amount:SizeToContents();
				spawnIcon.amount:SetPos(64 - spawnIcon.amount:GetWide(), 46);
			end
			
			--[[local plural = self.itemTable("plural");
			
			if (!self.itemTable("plural")) then
				if (string.sub(name, -1) != "s") then
					plural = name.."s";
				else
					plural = name;
				end;
			end;
			
			name = amount.." "..plural;
			weight = weight * amount;
		elseif (amount == 1) then
			name = amount.." "..name]]--
		elseif spawnIcon and spawnIcon.amount then
			spawnIcon.amount:Remove();
		end;
	end;

	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	
	if (model != self.cachedInfo.model or skin != self.cachedInfo.skin) then
		spawnIcon:SetModel(model, skin);
		self.cachedInfo.model = model
		self.cachedInfo.skin = skin;
	end;
end;

vgui.Register("cwRitualItem", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (IsValid(Clockwork.Client.cwChangeAppearanceMenu)) then
		Clockwork.Client.cwChangeAppearanceMenu:Remove()
		Clockwork.Client.cwChangeAppearanceMenu = nil;
	end

	self.categoryList = vgui.Create("DCategoryList", self);
 	self.categoryList:SetPadding(2);
 	self.categoryList:SizeToContents();
	self.categoryList:SetPaintBackground(false);

	self.nameForm = vgui.Create("DForm", self);
	self.nameForm:SetName("Name & Faction");
	self.nameForm:SetPadding(4);
	self.fullNameTextEntry = self.nameForm:TextEntry("Full Name");
	self.fullNameTextEntry:SetAllowNonAsciiCharacters(true);
	
	local factions = {};
	
	self.selectedFaction = nil;
	self.selectedSubfaction = nil;
	
	for k, v in pairs(Clockwork.faction.stored) do
		if v.imposters and !v.disabled then
			factions[#factions + 1] = v.name;
		end
	end;
	
	table.sort(factions, function(a, b)
		return a < b;
	end);
	
	self.factionMultiChoice = self.nameForm:ComboBox("Faction");
	
	-- Called when an option is selected.
	self.factionMultiChoice.OnSelect = function(multiChoice, index, value, data)
		self.selectedFaction = value;
		self:RebuildModelList(value);
		
		local factionTable = Clockwork.faction:FindByID(value);
		
		if IsValid(self.subfactionMultiChoice) then
			self.subfactionMultiChoice:Clear();
		
			if factionTable.subfactions then
				for k, v in pairs(factionTable.subfactions) do
					self.subfactionMultiChoice:AddChoice(v.name);
				end
				
				self.subfactionMultiChoice:ChooseOptionID(1);
			else
				self.selectedSubfaction = nil;
			end
		end;
	end;
	
	self.subfactionMultiChoice = self.nameForm:ComboBox("Subfaction");
	
	-- Called when an option is selected.
	self.subfactionMultiChoice.OnSelect = function(multiChoice, index, value, data)
		self.selectedSubfaction = value;
	end;
	
	self.appearanceForm = vgui.Create("DForm");
	self.appearanceForm:SetPadding(4);
	self.appearanceForm:SetName("Appearance");
	self.appearanceForm:Help("Write a physical description for your character in full English, and select an appropriate model.");
	self.physDescTextEntry = self.appearanceForm:TextEntry("Description");
	self.physDescTextEntry:SetAllowNonAsciiCharacters(true);
	
	self.modelItemsList = vgui.Create("DPanelList", self);
		self.modelItemsList:SetPadding(4);
		self.modelItemsList:SetSpacing(16);
		self.modelItemsList:EnableHorizontal(true);
		self.modelItemsList:EnableVerticalScrollbar(true);
	self.appearanceForm:AddItem(self.modelItemsList);
	
	if (self.nameForm) then
		self.categoryList:AddItem(self.nameForm);
	end;
	
	if (self.appearanceForm) then
		self.categoryList:AddItem(self.appearanceForm);
	end;
	
	self.closeButton = vgui.Create("DButton", self)
	self.closeButton:SetText("CLOSE")
	self.closeButton:SetSize(252, 67)
	self.closeButton:SetPos(2, 441)
	self.closeButton:SetTextColor(Color(160, 0, 0))
	self.closeButton:SetFont("nov_IntroTextSmallfaaaaa")
	
	local width, height = self.closeButton:GetWide(), self.closeButton:GetTall()
	local buttonMaterial = Material("begotten/ui/butt24.png")
	
	-- Called when the button is painted.
	function self.closeButton.DoClick()
		if (IsValid(self)) then
			self:Remove();
			
			Clockwork.Client.cwChangeAppearanceMenu = nil;
			
			netstream.Start("ClosedAppearanceAlterationMenu");
		end
		
		surface.PlaySound("begotten/ui/buttonclick.wav")
	end
	
	-- Called when the panel is painted.
	function self.closeButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(buttonMaterial)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	self.changeButton = vgui.Create("DButton", self)
	self.changeButton:SetText("CHANGE")
	self.changeButton:SetSize(252, 67)
	self.changeButton:SetPos(257, 441)
	self.changeButton:SetTextColor(Color(160, 0, 0))
	self.changeButton:SetFont("nov_IntroTextSmallfaaaaa")
	
	local width, height = self.changeButton:GetWide(), self.changeButton:GetTall()
	local buttonMaterial = Material("begotten/ui/butt24.png")
	
	-- Called when the button is painted.
	function self.changeButton.DoClick()
		surface.PlaySound("begotten/ui/buttonclick.wav")
				
		if (IsValid(self.fullNameTextEntry)) then
			self.fullName = self.fullNameTextEntry:GetValue();
			
			if (self.fullName == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;

			if (string.len(self.fullName) < 4) then
				Clockwork.character:SetFault("Your name must be at least 4 characters long!");
				return false;
			end;

			if (string.len(self.fullName) > 32) then
				Clockwork.character:SetFault("Your name must not be greater than 32 characters long!");
				return false;
			end;
		
			local blacklistedNames = {};
			
			if Schema.Ranks then
				for k, v in pairs(Schema.Ranks) do
					for i, v2 in ipairs(v) do
						if v2 ~= "" then
							table.insert(blacklistedNames, string.lower(v2));
						end
					end
				end
			end
			
			for i = 1, #blacklistedNames do
				local blacklistedName = blacklistedNames[i];
			
				if string.find(string.lower(self.fullName), blacklistedName) then
					Clockwork.character:SetFault("Character's name must not contain any blacklisted phrases.");
					return false;
				end
			end
		end;
		
		if (!self.selectedModel) then
			Clockwork.character:SetFault("You did not choose a model, or the model that you chose is not valid!");
			return false;
		end;
		
		if (!Clockwork.faction:IsGenderValid(self.selectedFaction, self.selectedGender)) then
			Clockwork.character:SetFault(self.selectedGender.." is not the correct gender for the "..self.selectedFaction.." faction!");
			return false;
		end;
		
		local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
		
		self.physDesc = self.physDescTextEntry:GetValue();
		
		if (string.len(self.physDesc) < minimumPhysDesc) then
			Clockwork.character:SetFault("The physical description must be at least "..minimumPhysDesc.." characters long!");
			return false;
		end;
		
		netstream.Start("AppearanceAlterationMenu", {self.fullName, self.selectedModel, self.selectedGender, self.physDesc, self.selectedFaction, self.selectedSubfaction});
		
		if (IsValid(self)) then
			self:Remove();
			
			Clockwork.Client.cwChangeAppearanceMenu = nil;
		end
	end
	
	-- Called when the panel is painted.
	function self.changeButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(buttonMaterial)
		surface.DrawTexturedRect(0, 0, width, height)
	end
	
	if (self.factionMultiChoice) then
		for k, v in pairs(factions) do
			self.factionMultiChoice:AddChoice(v);
		end;
		
		-- Select Wanderer.
		for i, v in ipairs(self.factionMultiChoice.Choices) do
			if v == "Wanderer" then
				self.factionMultiChoice:ChooseOptionID(i);
				
				break;
			end
		end
	end;
	
	Clockwork.Client.cwChangeAppearanceMenu = self;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

function PANEL:Paint()

end;

function PANEL:RebuildModelList(faction)
	if IsValid(self.modelItemsList) then
		self.modelItemsList:Clear();
	else
		return;
	end
	
	local informationColor = Clockwork.option:GetColor("information");
	local lowerGender = string.lower(Clockwork.Client:GetGender());
	
	for k, v in pairs(Clockwork.faction.stored) do
		if (v.name == faction) then
			for gender, v2 in pairs(v.models) do
				for k3, v3 in pairs(v2.heads) do
					if v.singleGender and gender ~= string.lower(v.singleGender) then
						continue;
					end
					
					local modelPath = "models/begotten/heads/"..v3.."_gore.mdl";
				
					local spawnIcon = vgui.Create("cwSpawnIcon", self);
					spawnIcon:SetModel(modelPath);
					spawnIcon.model = modelPath;
					spawnIcon.gender = string.upper(gender[1])..string.sub(gender, 2, #gender);
					
					-- Called when the spawn icon is clicked.
					function spawnIcon:DoClick()
						if (Clockwork.Client.cwChangeAppearanceMenu.selectedSpawnIcon) then
							Clockwork.Client.cwChangeAppearanceMenu.selectedSpawnIcon:SetColor(nil);
						end;
						
						self:SetColor(informationColor);
						
						Clockwork.Client.cwChangeAppearanceMenu.selectedSpawnIcon = spawnIcon;
						Clockwork.Client.cwChangeAppearanceMenu.selectedModel = spawnIcon.model;
						Clockwork.Client.cwChangeAppearanceMenu.selectedGender = spawnIcon.gender;
					end;
					
					-- Called when the spawn icon is clicked.
					function spawnIcon:DoRightClick()
						self:DoClick();
					end;
					
					self.modelItemsList:AddItem(spawnIcon);
				end;
			end;
			
			break;
		end;
	end;
end

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.categoryList:StretchToParent(0, 0, 0, 0);
	
	if (IsValid(self.modelItemsList)) then
		self.modelItemsList:SetTall(256);
	end;
	
	self:SetSize(512, 510);
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
end;

vgui.Register("cwRitualAppearanceChange", PANEL, "EditablePanel");