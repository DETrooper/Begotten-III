--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local icos = Material("begotten/ui/icos.png")
local squash = Material("begotten/ui/infotextsquash.png")
local Clockwork = Clockwork;
local CloseDermaMenus = CloseDermaMenus;
local IsValid = IsValid;
local pairs = pairs;
local ScrH = ScrH;
local ScrW = ScrW;
local string = string;
local table = table;
local vgui = vgui;
local math = math;
local gui = gui;

local PANEL = {};
if (IsValid(ASS)) then
	ASS:Remove() gui.EnableScreenClicker(false)
end;
local panelframe88 = Material("begotten/ui/panelframe88.png")
-- Called when the panel is initialized.
function PANEL:Init()
	alpg = nil alpt = nil
	ASS = self
	self:SetTitle("");
	self:SetDeleteOnClose(false);
	self:ShowCloseButton(false)
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
			self:Close(); self:Remove();
			gui.EnableScreenClicker(false);
		Clockwork.kernel:RunCommand("StorageClose");
	end;

	self.containerPanel = vgui.Create("cwPanelList", self);
 	self.containerPanel:SetPadding(4);
 	self.containerPanel:SetSpacing(4);
 	self.containerPanel:SizeToContents();
	
	-- Probably expensive but this fixes expanding item lists when a scrollbar isn't present.
	function self.containerPanel:Think()
		self:InvalidateLayout();
	end
	
	function self.containerPanel:OnScrollbarAppear()
		if (IsValid(self.VBar)) then
			--self.VBar:SetScroll(self.cachedScroll or 0);
			self.VBar.Scroll = math.Clamp(self.cachedScroll or 0, 0, self.VBar.CanvasSize);
			--self:HideScrollbar();
		end;
	end
	
 	self.containerPanel:EnableVerticalScrollbar();
	
	self.inventoryPanel = vgui.Create("cwPanelList", self);
	self.inventoryPanel:SetPadding(4);
	self.inventoryPanel:SetSpacing(4);
	self.inventoryPanel:SizeToContents();
	
	-- Probably expensive but this fixes expanding item lists when a scrollbar isn't present.
	function self.inventoryPanel:Think()
		self:InvalidateLayout();
	end
	
	function self.inventoryPanel:OnScrollbarAppear()
		if (IsValid(self.VBar)) then
			--self.VBar:SetScroll(self.cachedScroll or 0);
			self.VBar.Scroll = math.Clamp(self.cachedScroll or 0, 0, self.VBar.CanvasSize);
			--self:HideScrollbar();
		end;
	end
	
	self.inventoryPanel:EnableVerticalScrollbar();
	
	local font = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 2.25);
	self.cumfont = font;
	self.closeButton = vgui.Create("DButton", self);
	self.closeButton:SetText("Close");
	self.closeButton:SetFont(font)
	self.closeButton:SetTextColor(Color(170, 0, 0));
	local fw, fh = GetFontWidth(font,"Close"),GetFontHeight(font,"Close")
	
	function self.closeButton:Paint(w,h)
		--"begotten/ui/panelframe88.png"
		Clockwork.kernel:DrawWithTexture(panelframe88, 0, 0, 0, w, h, Color(0, 0, 0), 255);
		surface.SetDrawColor(Color(35, 35, 35, 255));
		surface.SetMaterial(squash);
		surface.DrawTexturedRect(6, 4, w - 12, h - 8)
		draw.SimpleText("Close", font, (w/2)-(fw/2)+2, (h/2)-(fh/2)-1, Color(0, 0, 0, 225));
	end;
	
	function self.closeButton.DoClick()
		if (IsValid(self)) then
			CloseDermaMenus();
				self:Close(); self:Remove();
				gui.EnableScreenClicker(false);
			Clockwork.kernel:RunCommand("StorageClose");
		end;
	end;

	Clockwork.kernel:SetNoticePanel(self);
end;

function Clockwork.storage:GetIsOneSided()
	return false
end;

local grad = Material("begotten/ui/collapsible3-full.png")
-- A function to rebuild a panel.
function PANEL:RebuildPanel(storagePanel, storageType, usedWeight, weight, usedSpace, space, cash, inventory, scroll)
	-- Cache which item stacks are expanded so they can be restored.
	self.expandCache = {};
	
	if IsValid(storagePanel.itemList) then
		for i, v in ipairs(storagePanel.itemList:GetItems()) do
			if IsValid(v.sublist) then
				if v.sublist:GetExpanded() then
					table.insert(self.expandCache, v.itemTable.uniqueID);
				end
			end
		end
	end

	storagePanel:Clear(true);
		storagePanel.cash = cash;
		storagePanel.weight = weight;
		storagePanel.usedWeight = usedWeight;
		storagePanel.space = space;
		storagePanel.usedSpace = usedSpace;
		storagePanel.inventory = inventory;
		storagePanel.storageType = storageType;
	Clockwork.plugin:Call("PlayerPreRebuildStorage", storagePanel);
	
	--local categories = {};
	local usedWeight = (cash * Clockwork.config:Get("cash_weight"):Get());
	local usedSpace = (cash * Clockwork.config:Get("cash_space"):Get());
	local itemsList = {};
	local expandFont = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 0.6);
	
	if (Clockwork.storage:GetNoCashWeight()) then
		usedWeight = 0;
	end;

	if (Clockwork.storage:GetNoCashSpace()) then
		usedSpace = 0;
	end;

	for k, v in pairs(storagePanel.inventory) do
		for k2, v2 in pairs(v) do
			if ((storageType == "Container" and Clockwork.storage:CanTakeFrom(v2)) or (storageType == "Inventory" and Clockwork.storage:CanGiveTo(v2))) then
				local itemCategory = v2("category");
				
				if (itemCategory) then
					--itemsList[itemCategory] = itemsList[itemCategory] or {};
					--itemsList[itemCategory][#itemsList[itemCategory] + 1] = v2;
					itemsList = itemsList or {};
					itemsList[#itemsList + 1] = v2;
					usedWeight = usedWeight + math.max(v2("storageWeight", v2("weight")), 0);
					usedSpace = usedSpace + math.max(v2("storageSpace", v2("space")), 0);
				end;
			end;
		end;
	end;
	
	--[[for k, v in pairs(itemsList) do
		categories[#categories + 1] = {
			itemsList = v,
			category = k
		};
	end;
	
	table.sort(categories, function(a, b)
		return a.category < b.category;
	end);]]--
	
	if (!storagePanel.usedWeight) then
		storagePanel.usedWeight = usedWeight;
	end;

	if (!storagePanel.usedSpace) then
		storagePanel.usedSpace = usedSpace;
	end;
	
	Clockwork.plugin:Call(
		"PlayerStorageRebuilt", storagePanel, categories
	);
	
	local player = Clockwork.storage.entity;

	if Clockwork.Client:IsAdmin() and IsValid(player) and player:IsPlayer() then
		if player.gearEnts then
			player.gearEnts = nil;
		end
	end
	
	local numberWang = nil;
	local cashForm = nil;
	local button = nil;
	
	if (Clockwork.config:Get("cash_enabled"):Get() and storagePanel.cash > 0) then
		numberWang = vgui.Create("DNumberWang", storagePanel);
		cashForm = vgui.Create("DForm", storagePanel);
		button = vgui.Create("DButton", storagePanel);
		
		button:SetText("Transfer");
		button.Stretch = true;
		
		-- Called when the button is clicked.
		function button.DoClick(button)
			local cashName = Clockwork.option:GetKey("name_cash");
			
			if (storageType == "Inventory") then
				Clockwork.kernel:RunCommand("StorageGiveCash", numberWang:GetValue());
			else
				Clockwork.kernel:RunCommand("StorageTakeCash", numberWang:GetValue());
			end;
		end;
		
		numberWang.Stretch = true;
		numberWang:SetDecimals(0);
		numberWang:SetMinMax(0, storagePanel.cash);
		numberWang:SetValue(storagePanel.cash);
		numberWang:SizeToContents();
				
		cashForm:SetPadding(4);
		cashForm:SetName("Coinage");
		cashForm:AddItem(numberWang);
		cashForm:AddItem(button);
		cashForm.Header:SetEnabled(false);
	end;
	
	if (storagePanel.usedWeight > 0) then
		local informationForm = vgui.Create("DForm", storagePanel);
			informationForm:SetPadding(4);
			informationForm:SetName("Weight");
			informationForm:AddItem(vgui.Create("cwStorageWeight", storagePanel));
			informationForm.Header:SetEnabled(false);
		storagePanel:AddItem(informationForm);
	end;

	if (Clockwork.inventory:UseSpaceSystem() and storagePanel.usedSpace > 0) then
		local informationForm = vgui.Create("DForm", storagePanel);
			informationForm:SetPadding(4);
			informationForm:SetName("Space");
			informationForm:AddItem(vgui.Create("cwStorageSpace", storagePanel));
			informationForm.Header:SetEnabled(false);
		storagePanel:AddItem(informationForm);
	end;
	
	if (cashForm) then
		storagePanel:AddItem(cashForm);
	end;
	
	local storageType = storagePanel.storageType;
	
	if (storageType == "Inventory") then
		storageType = "Sack"
	elseif (storageType == "Container" and Clockwork.storage:GetName()) then
		storageType = Clockwork.storage:GetName()
	end;
	
	storagePanel.inventoryForm = vgui.Create("DForm", self);
	storagePanel.inventoryForm:SetName(storageType);
	storagePanel.inventoryForm:SetSpacing(4);
	storagePanel.inventoryForm.Header:SetEnabled(false);

	storagePanel.itemList = vgui.Create("DPanelList", self);
	storagePanel.itemList:SizeToContents();
	storagePanel.itemList:EnableHorizontal(false);
	storagePanel.itemList:SetAutoSize(true);
	storagePanel.itemList:SetPadding(4);
	storagePanel.itemList:SetSpacing(4);
	storagePanel.itemList:SetPaintBackground(false);
		
	--for k, v in pairs(categories) do
		--[[table.sort(v.itemsList, function(a, b)
			return a("itemID") < b("itemID");
		end);]]--
		
		local items = {};
		
		for k2, v2 in SortedPairsByMemberValue(itemsList, "name") do
			if v2.stackable then
				if (!items[v2("uniqueID")]) then
					storagePanel.itemData = {
						itemTable = v2,
						storageType = storagePanel.storageType
					};
					
					storagePanel.itemData.amount = Clockwork.inventory:GetItemCountByID(storagePanel.inventory, storagePanel.itemData.itemTable("uniqueID"));
					
					local inventoryIcon = vgui.Create("cwStorageItem", storagePanel);
					
					if storagePanel.itemData.condition and storagePanel.itemData.condition < 100 then
						if storagePanel.itemData.condition <= 0 then
							inventoryIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", inventoryIcon.spawnIcon);
							inventoryIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
							inventoryIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
						else
							inventoryIcon.spawnIcon.conditionBar = vgui.Create("DImage", inventoryIcon.spawnIcon);
							inventoryIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
							inventoryIcon.spawnIcon.conditionBar:SetPos(4, 56);
							inventoryIcon.spawnIcon.conditionBar:SetSize(56, 6);
							inventoryIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", inventoryIcon.spawnIcon.conditionBar);
							inventoryIcon.spawnIcon.conditionBar.fill:SetType("Rect");
							inventoryIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
							inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (storagePanel.itemData.condition / 100), 2);
							inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - storagePanel.itemData.condition), 1 * storagePanel.itemData.condition, 0, 225));
						end
					end
					
					if storagePanel.itemData.amount > 1 then
						local expandButton = vgui.Create("DButton", inventoryIcon);

						expandButton:SetPos(3, 47);
						expandButton:SetSize(13, 13);
						expandButton:SetText("");
						
						function expandButton:DoClick()
							local parent = self:GetParent();
							
							if parent.sublist then
								if parent.sublist:GetExpanded() then
									parent.sublist:DoExpansion(false);
								else
									parent.sublist:DoExpansion(true);
								end
							end
						end
						
						function expandButton:PaintOver(w, h)
							local parent = self:GetParent();
							
							if parent.sublist then
								surface.SetFont(expandFont);
								surface.SetTextColor(200, 200, 200);
							
								if parent.sublist:GetExpanded() then
									surface.SetTextPos(4, -2);
									surface.DrawText("-");
								else
									surface.SetTextPos(3, -2);
									surface.DrawText("+");
								end
							end
						end
						
						inventoryIcon.expandButton = expandButton;
					end
					
					items[v2("uniqueID")] = inventoryIcon;
					
					storagePanel.itemList:AddItem(inventoryIcon);
				else
					local parent = items[v2("uniqueID")];
					
					if IsValid(parent) then
						storagePanel.itemData = {
							itemTable = v2,
							storageType = storagePanel.storageType
						};
					
						storagePanel.itemData.amount = 1;
					
						if !IsValid(parent.sublist) then
							local sublist = vgui.Create("DCollapsibleCategory");
							
							sublist:SetSize(storagePanel.itemList:GetWide(), 0);
							sublist:SetHeaderHeight(0);
							sublist.Header:SetVisible(false);
							
							if table.HasValue(self.expandCache, v2.uniqueID) then
								sublist:SetExpanded(true);
							else
								sublist:SetExpanded(false);
							end
							
							local categoryList = vgui.Create("DPanelList", sublist);
								categoryList:EnableHorizontal(false);
								categoryList:SetAutoSize(true);
							sublist:SetContents(categoryList);
							sublist.categoryList = categoryList;
							
							storagePanel.itemList:AddItem(sublist);
							parent.sublist = sublist;
						end
						
						local inventoryIcon = vgui.Create("cwStorageItem", storagePanel);
						
						if storagePanel.itemData.condition and storagePanel.itemData.condition < 100 then
							if storagePanel.itemData.condition <= 0 then
								inventoryIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", inventoryIcon.spawnIcon);
								inventoryIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
								inventoryIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
							else
								inventoryIcon.spawnIcon.conditionBar = vgui.Create("DImage", inventoryIcon.spawnIcon);
								inventoryIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
								inventoryIcon.spawnIcon.conditionBar:SetPos(4, 56);
								inventoryIcon.spawnIcon.conditionBar:SetSize(56, 6);
								inventoryIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", inventoryIcon.spawnIcon.conditionBar);
								inventoryIcon.spawnIcon.conditionBar.fill:SetType("Rect");
								inventoryIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
								inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (storagePanel.itemData.condition / 100), 2);
								inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - storagePanel.itemData.condition), 1 * storagePanel.itemData.condition, 0, 225));
							end
						end
						
						parent.sublist.categoryList:AddItem(inventoryIcon);
					end
				end;
			else
				storagePanel.itemData = {
					itemTable = v2,
					storageType = storagePanel.storageType
				};

				storagePanel.itemData.amount = 1;
				storagePanel.itemData.condition = v2:GetCondition();
				
				local inventoryIcon = vgui.Create("cwStorageItem", storagePanel);
				
				if storagePanel.itemData.condition and storagePanel.itemData.condition < 100 then
					if storagePanel.itemData.condition <= 0 then
						inventoryIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", inventoryIcon.spawnIcon);
						inventoryIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
						inventoryIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
					else
						inventoryIcon.spawnIcon.conditionBar = vgui.Create("DImage", inventoryIcon.spawnIcon);
						inventoryIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
						inventoryIcon.spawnIcon.conditionBar:SetPos(4, 56);
						inventoryIcon.spawnIcon.conditionBar:SetSize(56, 6);
						inventoryIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", inventoryIcon.spawnIcon.conditionBar);
						inventoryIcon.spawnIcon.conditionBar.fill:SetType("Rect");
						inventoryIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
						inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (storagePanel.itemData.condition / 100), 2);
						inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - storagePanel.itemData.condition), 1 * storagePanel.itemData.condition, 0, 225));
					end
				end
				
				storagePanel.itemList:AddItem(inventoryIcon);
			end;
		end;
	--end;
	
	storagePanel.inventoryForm:AddItem(storagePanel.itemList);
	storagePanel:AddItem(storagePanel.inventoryForm);
	local fo = self.cumfont
	local fgugta = storagePanel.inventoryForm;
	storagePanel.scrollza = false
	
	function storagePanel:Paint(w,h)
		local isEmpty = table.IsEmpty(storagePanel.inventory);
		local curTime = CurTime();
		
		if (!self.nextEmptyCheck or self.nextEmptyCheck < curTime) then
			self.nextEmptyCheck = curTime + 0.1;
			for k, v in pairs (storagePanel.inventory) do
				if (table.IsEmpty(storagePanel.inventory[k])) then
					storagePanel.inventory[k] = nil;
				end;
			end;
		end;
		
		if (!self.ALPG2 or !self.ALPG2d) then
			self.ALPG2 = 0;
			self.ALPG2d = 0
		end;

		if (!isEmpty) then
			self.ALPG2d = 0;
			if (self.hid) then
				fgugta:Show()
				self.hid = false
			end;
		else
			if (!self.hid) then
				fgugta:Hide()
				self.hid = true
			end;
			self.ALPG2d = 255;
		end;
		
		local frameTime = FrameTime();
		self.ALPG2 = math.Approach(self.ALPG2, self.ALPG2d, frameTime * 256);
		
		local x, y = 4, 48;
		local wid,hei = w - 8, h - (48 + 4)
		surface.SetDrawColor(150, 150, 150, self.ALPG2);
		surface.SetMaterial(grad);
		surface.DrawTexturedRect(x,y,wid,hei)
		draw.RoundedBox(4, x, y, wid, hei, Color(0, 0, 0, math.Clamp(255 - (self.ALPG2 / 2), 150, 100 + math.max(100, self.ALPG2 * 0.5))))
		local storagename = self.storageType;
		
		if (storagename == "Container") then
			storagename = "This "..string.lower(Clockwork.storage:GetName()).." is";
			local ent = Clockwork.storage:GetEntity()
			if (IsValid(ent) and ent:GetClass() == "prop_ragdoll" and Clockwork.entity:GetPlayer(ent)) then
				local ply = Clockwork.entity:GetPlayer(ent);
				local recognise = Clockwork.player:DoesRecognise(ply)
				if (recognise) then
					storagename = string.Split(ply:Name(), " ")[1].."'s pockets are"
				else
					local gender = ply:GetGender();
					local n = "His"
					if (gender == GENDER_FEMALE) then
						n = "Her"
					end;
					storagename = n.." pockets are";
				end;
			end;
		elseif (storagename == "Inventory") then
			storagename = "Your sack is"
		end;
		
		local tata = storagename.." empty...";
		
		draw.SimpleText(tata, fo, (w / 2), (h / 2), Color(170, 0, 0, self.ALPG2), 1, 1);
	end;
	
	if (IsValid(storagePanel.VBar)) then
		storagePanel.cachedScroll = scroll;
	
		--[[storagePanel.VBar:SetScroll(scroll or 0);
		storagePanel:HideScrollbar();]]--
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	local tap, tae = 0, 0
	
	if IsValid(self.containerPanel.VBar) then
		tap = self.containerPanel.VBar:GetScroll();
	end;
	
	if IsValid(self.inventoryPanel.VBar) then
		tae = self.inventoryPanel.VBar:GetScroll();
	end;
	
	self:RebuildPanel(self.containerPanel, "Container", nil,
		Clockwork.storage:GetWeight(),
		nil, Clockwork.storage:GetSpace(),
		Clockwork.storage:GetCash(),
		Clockwork.storage:GetInventory(), tap
	);
	
	if (!Clockwork.storage:GetIsOneSided()) then
		local inventory = Clockwork.inventory:GetClient();
		local maxWeight = Clockwork.player:GetMaxWeight();
		local weight = Clockwork.inventory:CalculateWeight(inventory);
		local maxSpace = Clockwork.player:GetMaxSpace();
		local space = Clockwork.inventory:CalculateSpace(inventory);
		local cash = Clockwork.player:GetCash();

		self:RebuildPanel(self.inventoryPanel, "Inventory",
			weight, maxWeight, space, maxSpace, cash, inventory, tae
		);
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:SetSize(ScrW() * 0.7, ScrH() * 0.65);
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
	
	if (IsValid(self.closeButton)) then
		self.closeButton:SetPos(6, self:GetTall() - 68);
		self.closeButton:SetSize(self:GetWide() - 12, 60);
	end;
	
	if (IsValid(self.inventoryPanel) and Clockwork.player:GetCash() != self.inventoryPanel.cash) then
		self:Rebuild();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self);

	self.inventoryPanel:StretchToParent((w * 0.5) + 2, 4, 4, 68)
	self.containerPanel:StretchToParent(4, 4, (w * 0.5) + 2, 68)
end;
local gradient = Material("begotten/ui/generic_bg_gradient.png")
local scratch = Material("begotten/ui/generic_scratch.png");
function PANEL:Paint(w, h)
	draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 150));
	Clockwork.kernel:DrawWithTexture(scratch, 4, 2, 2, w, h, Color(0, 0, 0), 255);
	Clockwork.kernel:DrawWithTexture(gradient, 4, 3, 3, w - 2, h - 2, Color(0, 0, 0), 255);
end;

vgui.Register("cwStorage", PANEL, "DFrame");

local PANEL = {};

gui.EnableScreenClicker(false)
local necropolisFrame = Material("begotten/ui/charactermenu/necropolisframe.png");
-- Called when the panel is initialized.
function PANEL:Init()
	local parent = self:GetParent();
	local itemData = self:GetParent().itemData;
	self.itemTable = itemData.itemTable;
	self.itemData = itemData;
	self.storageType = itemData.storageType;
	
	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);

	self:SetSize(64, 64);
	
	if self.itemTable.iconoverride then
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DImageButton", self));
		self.spawnIcon:SetImage(self.itemTable.iconoverride);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = false;
		
		function self.spawnIcon.DoRightClick(spawnIcon)
			if (itemData.OnPress) then
				itemData.OnPress();
				return;
			end;
			
			Clockwork.kernel:HandleItemSpawnIconRightClick(self.itemTable, spawnIcon);
		end;
	else
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
		self.spawnIcon:SetModel(model, skin);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = true;
	end
	
	self.spawnIcon:SetItemTable(self.itemTable);
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
			if (self.storageType == "Inventory") then
				Clockwork.kernel:RunCommand("StorageGiveItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			else
				Clockwork.kernel:RunCommand("StorageTakeItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			end;
			
			self.nextCanClick = CurTime() + 1;
		end;
	end;
	
	self.spawnIcon:SetModel(model, skin);
	--self.spawnIcon:SetToolTip("");
	self.spawnIcon:SetSize(64, 64);
	self.cachedInfo = {model = model, skin = skin};
	
	self.namePlate = vgui.Create("DPanel", self);
	self.namePlate:SetPos((self.spawnIcon:GetWide()) + 8, 6);
	self.namePlate:SetSize(self:GetWide() * 0.5, self:GetTall() - 12);

	local fontScale = 1;
	local font = "nov_IntroTextSmallDETrooper"
	local scaledFont = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", fontScale)
	local text = self.itemTable("name");
	local fontWidth = GetFontWidth(font, text);
	local fontHeight = GetFontHeight(font, text)
	
	function self.namePlate.Paint(panel, width, height)
		local wide = self:GetWide();
		local scale = (1 - (fontWidth / (wide * 8)))
		
		if (!self.namePlate.scale or self.namePlate.oldScale != scale) then
			self.namePlate.scale = scale
			self.namePlate.oldScale = scale;
			self.namePlate.font = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", scale)
			
			self.namePlate.fontHeight = GetFontHeight(self.namePlate.font, text)
			self.namePlate.fontWidth = GetFontWidth(self.namePlate.font, text)
		end;
		
		local frameTime = FrameTime();
		
		if (!alpg or !alpt) then
			alpg = 100;
			alpt = 255;
		end;
		
		if (alpg != alpt) then
			alpg = math.Approach(alpg, alpt, frameTime * 4);
		else
			if (alpt == 255) then
				alpt = 100;
			else
				alpt = 255;
			end;
		end;

		alpg = math.Approach(alpg, alpt, frameTime * 2);
		self.namePlate:SetWide((wide * 0.5) - self.spawnIcon:GetWide());
		local ras = Color(0, 0, 0, alpg);
		Clockwork.kernel:DrawWithTexture(necropolisFrame, 4, 0, 0, width, height, ras, 255);
		local x, y = (self.namePlate:GetWide() / 2) - (self.namePlate.fontWidth / 2), (self.namePlate:GetTall() / 2) - (self.namePlate.fontHeight / 2)
		draw.SimpleText(text, self.namePlate.font, x + (self.offsetX or 0), y + -(self.offsfetX or 0), ras)
		draw.SimpleText(text, self.namePlate.font, x - (self.offsetX or 0), y - -(self.offsfetX or 0), ras)
	end;

	self.itemName = vgui.Create("DLabel", self.namePlate);
	self.itemName:SetText(text);
	self.itemName:SetFont(font);
	self.itemName:SizeToContents();
	self.itemName:SetTextColor(Color(255, 255, 255))
	
	function self.itemName:Paint(width, height)
		local par = self:GetParent()
		self:SetFont(par.font)
		local x, y = (par:GetWide() / 2) - (par.fontWidth / 2), (par:GetTall() / 2) - (par.fontHeight / 2)
		self:SetPos(x, y)
	end;
	
	local namePlateX, namePlateY = self.namePlate:GetPos();
	
	self.infoPlate = vgui.Create("DPanel", self);

	function self.infoPlate.Paint(panel, width, height)
		self.infoPlate:SetPos(self.namePlate:GetPos() + self.namePlate:GetWide(), 6);
		self.infoPlate:SetSize((self:GetWide()) - (self.namePlate:GetWide() + self.spawnIcon:GetWide() + 16), self:GetTall() - 12);
		Clockwork.kernel:DrawWithTexture(necropolisframe, 4, 0, 0, width, height, Color(0, 0, 0), 255);
	end;
	
	local takeFont = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 0.8);
	local takeText = "Take"
	
	if (self.storageType == "Inventory") then
		takeText = "Give";
	end;
	
	self.takeButton = vgui.Create("DButton", self.infoPlate)
	self.takeButton:SetText(takeText)
	self.takeButton:SetFont(takeFont)
	
	if self.storageType == "Container" then
		local player = Clockwork.storage.entity;
	
		if Clockwork.Client:IsAdmin() and IsValid(player) and player:IsPlayer() then
			self.equipButton = vgui.Create("DButton", self.infoPlate)
			
			if player:GetItemEquipped(self.itemTable) then
				self.equipButton:SetText("Unequip");
				
				function self.equipButton.DoClick(panel)
					if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
						if IsValid(Clockwork.storage.entity) and Clockwork.storage.entity:IsPlayer() then
							Clockwork.kernel:RunCommand("CharUnequipItem", Clockwork.storage.entity:Name(), self.itemTable("uniqueID"), self.itemTable("itemID"));
						end
						
						self.nextCanClick = CurTime() + 1;
						
						CloseDermaMenus();
						Clockwork.storage.panel:Close();
						Clockwork.storage.panel:Remove();
						gui.EnableScreenClicker(false);
						Clockwork.kernel:RunCommand("StorageClose");
					end;
				end
			else
				self.equipButton:SetText("Equip");
				
				function self.equipButton.DoClick(panel)
					if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
						if IsValid(Clockwork.storage.entity) and Clockwork.storage.entity:IsPlayer() then
							Clockwork.kernel:RunCommand("CharUseItem", Clockwork.storage.entity:Name(), self.itemTable("uniqueID"), self.itemTable("itemID"));
						end
						
						self.nextCanClick = CurTime() + 1;
						
						CloseDermaMenus();
						Clockwork.storage.panel:Close();
						Clockwork.storage.panel:Remove();
						gui.EnableScreenClicker(false);
						Clockwork.kernel:RunCommand("StorageClose");
					end;
				end
			end
			
			self.equipButton:SetFont(takeFont);
			
			function self.equipButton.Think(panel)
				self.takeButton:SetSize(self.infoPlate:GetTall() - 8, (self.infoPlate:GetTall()) - 8)
				self.takeButton:SetPos(self.infoPlate:GetWide() - (self.takeButton:GetWide() + 4), 4);
				
				self.equipButton:SetSize(self.infoPlate:GetTall() - 8, (self.infoPlate:GetTall()) - 8)
				self.equipButton:SetPos(self.infoPlate:GetWide() - ((self.equipButton:GetWide() * 2) + 4), 4);
			end;
		end
	end
	
	--[[
	function self.takeButton.OnMouseWheeled(panel, scrollDelta)
		if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
			if (self.storageType == "Inventory" and scrollDelta == 1) then
				Clockwork.kernel:RunCommand("StorageGiveItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			elseif (self.storageType == "Container" and scrollDelta == -1) then
				Clockwork.kernel:RunCommand("StorageTakeItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			end;
			
			self.nextCanClick = CurTime() + 1;
		end;
	end;--]]
	
	local condition = math.Round(self.itemTable:GetCondition());
	
	function self.takeButton.DoClick(panel)
		if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
			if (self.storageType == "Inventory") then
				Clockwork.kernel:RunCommand("StorageGiveItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			else
				Clockwork.kernel:RunCommand("StorageTakeItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
			end;
			
			self.nextCanClick = CurTime() + 0.2;
		end;
	end;
	
	function self.takeButton.DoRightClick(panel)
		if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
			local amount = self.itemData.amount;

			if self.itemData.amount > 1 then
				local menu = DermaMenu();
				
				menu:SetMinimumWidth(60);
				
				if (self.storageType == "Inventory") then
					menu:AddOption("Give All", function()
						Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), tostring(amount));
					end);
				
					local amountMenu = menu:AddSubMenu("Give Amount...", function()
						Derma_StringRequest(self.itemTable("name"), "How many items of this type do you want to give?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), amount);
						end);
					end);
					
					local customMenu = amountMenu:AddSubMenu("Custom Amount", function()
						Derma_StringRequest(self.itemTable("name"), "How many items of this type do you want to give?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), amount);
						end);
					end);
					
					if amount >= 2 then
						amountMenu:AddOption("2", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "2");
						end);
					end
					
					if amount >= 5 then
						amountMenu:AddOption("5", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "5");
						end);
					end
					
					if amount >= 10 then
						amountMenu:AddOption("10", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "10");
						end);
					end
					
					if amount >= 25 then
						amountMenu:AddOption("25", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "25");
						end);
					end
					
					if amount >= 50 then
						amountMenu:AddOption("50", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "50");
						end);
					end
					
					if amount >= 100 then
						amountMenu:AddOption("100", function()
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), "100");
						end);
					end
					
					customMenu:AddOption("By Best Condition", function()
						Derma_StringRequest(self.itemTable("name").." (Best Condition)", "How many items of this type do you want to give?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), amount, "bestCondition");
						end);
					end);
					
					customMenu:AddOption("By Worst Condition", function()
						Derma_StringRequest(self.itemTable("name").." (Worst Condition)", "How many items of this type do you want to give?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageGiveItems", self.itemTable("uniqueID"), amount, "worstCondition");
						end);
					end);
				else
					menu:AddOption("Take All", function()
						Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), tostring(amount));
					end);
				
					local amountMenu = menu:AddSubMenu("Take Amount...", function()
						Derma_StringRequest(self.itemTable("name"), "How many items of this type do you want to take?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), amount);
						end);
					end);
					
					local customMenu = amountMenu:AddSubMenu("Custom Amount", function()
						Derma_StringRequest(self.itemTable("name"), "How many items of this type do you want to take?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), amount);
						end);
					end);
					
					if amount >= 2 then
						amountMenu:AddOption("2", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "2");
						end);
					end
					
					if amount >= 5 then
						amountMenu:AddOption("5", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "5");
						end);
					end
					
					if amount >= 10 then
						amountMenu:AddOption("10", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "10");
						end);
					end
					
					if amount >= 25 then
						amountMenu:AddOption("25", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "25");
						end);
					end
					
					if amount >= 50 then
						amountMenu:AddOption("50", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "50");
						end);
					end
					
					if amount >= 100 then
						amountMenu:AddOption("100", function()
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), "100");
						end);
					end
					
					customMenu:AddOption("By Best Condition", function()
						Derma_StringRequest(self.itemTable("name").." (Best Condition)", "How many items of this type do you want to take?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), amount, "bestCondition");
						end);
					end);
					
					customMenu:AddOption("By Worst Condition", function()
						Derma_StringRequest(self.itemTable("name").." (Worst Condition)", "How many items of this type do you want to take?", nil, function(amount)
							Clockwork.kernel:RunCommand("StorageTakeItems", self.itemTable("uniqueID"), amount, "worstCondition");
						end);
					end);
				end
				
				menu:Open()
				
				function menu:Think()
					self:MoveToFront()
				end;
			else
				if (self.storageType == "Inventory") then
					Clockwork.kernel:RunCommand("StorageGiveItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
				else
					Clockwork.kernel:RunCommand("StorageTakeItem", self.itemTable("uniqueID"), self.itemTable("itemID"));
				end;
			end
			
			self.nextCanClick = CurTime() + 0.2;
		end;
	end
	
	function self.takeButton.Think(panel)
		if !self.equipButton then
			self.takeButton:SetSize(self.infoPlate:GetTall() - 8, self.infoPlate:GetTall() - 8)
			self.takeButton:SetPos(self.infoPlate:GetWide() - (self.takeButton:GetWide() + 4), 4);
		end
	end;
	
	self.conditionBarBg = vgui.Create("DPanel", self.infoPlate);
	self.conditionBarBg:SetSize(32, 32);
	self.conditionBarBg:SetPos(8, 8);
	
	local storageWeight = Clockwork.storage:GetWeight()
	local weight = Clockwork.player:GetMaxWeight()
	local itemWeight = self.itemTable("weight");
	local inventory = Clockwork.storage:GetInventory()
	local cho = storageWeight
	
	if (self.storageType == "Inventory") then
		inventory = Clockwork.inventory:GetClient();
		cho = weight
	end;
	
	local assweight = Clockwork.inventory:CalculateWeight(inventory);
	local ast = math.max(cho, assweight)
	local amt = math.min(itemWeight / ast, 1)

	function self.conditionBarBg.Paint(paint, width, height)
		self.conditionBarBg:SetPos(6, 6);
		
		if self.equipButton then
			self.conditionBarBg:SetSize((self.infoPlate:GetWide()) - 100, 42);
		else
			self.conditionBarBg:SetSize((self.infoPlate:GetWide()) - 56, 42);
		end
		
		draw.RoundedBox(4, 0, 0, width, height, Color(22, 22, 22, 150))
		draw.RoundedBox(0, 1, 1, width - 2, height - 2, Color(11, 9, 7, 220))
		local frameTime = FrameTime();
		
		local tw, th = width - 2, (height - 2) / 2
		local progress = tw * math.min(condition / 100, 1);
		local prog2 = tw * amt
		local totalprog = tw*math.min(assweight/ast, 1)

		local r, g, b = 1 * (100 - condition), 1 * condition, 0
		
		-- WEIGHT BAR
		surface.SetDrawColor(150, 150, 200);
		surface.SetMaterial(icos);
		surface.DrawTexturedRect(0, 0, tw, th)

		-- inv weight
		surface.SetMaterial(squash);
		
		surface.SetDrawColor(Color(75, 100, 125, 255))
		surface.DrawTexturedRect(2, 2, totalprog - 4, (th) - 4)
		
		-- item weight
		surface.SetMaterial(squash);
		surface.SetDrawColor(200, 200, 255, 255)
		surface.DrawTexturedRect(2, 2, prog2 - 4, th - 4)
		
		-- overlay
		surface.SetDrawColor(255, 255, 255, 175);
		surface.SetMaterial(icos);
		surface.DrawTexturedRect(2, 2, totalprog - 4, (th) - 4)
		
		-- CONDITION BAR

		surface.SetDrawColor(Color(r/1.25,g/1.25,b/1.25));
		surface.SetMaterial(icos);
		surface.DrawTexturedRect(0, th, tw, th)
		
		surface.SetMaterial(squash);
		surface.SetDrawColor(r, g, b, 255)
		surface.DrawTexturedRect(2, th + 2, progress - 4, (th) - 4)

		if (!self.conditionBarBg.font) then
			self.conditionBarBg.font = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 0.8)
		end;
		
		if (!self.offsetX) then
			self.offsetX = math.random(-4,4);
			self.offsetXtarg = 12;
		elseif (self.offsetXtarg == self.offsetX) then
			if (self.offsetXtarg == 12) then
				self.offsetXtarg = -12;
			else
				self.offsetXtarg = 12
			end;
		end;

		if (!self.offsfetX) then
			self.offsfetX = math.random(-4,4);
			self.offseftXtarg = 12;
		elseif (self.offseftXtarg == self.offsfetX) then
			if (self.offseftXtarg == 12) then
				self.offseftXtarg = -12;
			else
				self.offseftXtarg = 12
			end;
		end;
		
		if (!self.conditionBarBg.sta) then
			self.conditionBarBg.sta = math.Rand(-4,8)
		end;
		
		if (!alpg or !alpt) then
			alpg = 0;
			alpt = 255;
		end;

		self.offsetX = math.Approach(self.offsetX, self.offsetXtarg, frameTime / self.conditionBarBg.sta);
		self.offsfetX = math.Approach(self.offsfetX, self.offseftXtarg, frameTime / self.conditionBarBg.sta);
		local spaghetti = "Condition: "..math.Round(condition).."%"
		local cot = self.conditionBarBg.font
		local bit = GetFontWidth(self.conditionBarBg.font, spaghetti);
		draw.SimpleText(spaghetti, cot, (tw - bit - 2) - self.offsetX, th + 1, Color(0, 0, 0, aalpg))
		draw.SimpleText(spaghetti, cot, tw - bit - 1, th + 3, Color(0, 0, 0, 200))
		draw.SimpleText(spaghetti, cot, tw - bit - 2, th + 2, Color(200 + (r/3), 200 + (g/3), 200, alpg * 2))
		local bro = "Weight: "..itemWeight.."kg/"..ast.."kg"
		draw.SimpleText(bro, cot, 4 + self.offsfetX, 0, Color(0, 0, 0, alpg))
		draw.SimpleText(bro, cot, 4+1, 0+1, Color(0, 0, 0, 200))
		draw.SimpleText(bro, cot, 4, 0, Color(200, 200, 255, alpg * 2))
	end;
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

local statuscontainer = Material("begotten/ui/statuscontainer.png");
function PANEL:Paint(width, height)
	draw.RoundedBox(4, 0, 0, width, height, Color(0, 0, 0, 150))
	draw.RoundedBox(0, 2, 2, width - 4, height - 4, Color(0, 0, 0, 150))
	
	local panel = self
	
	Clockwork.kernel:DrawWithTexture(statuscotnainer, 4, 0, 0, self.spawnIcon:GetWide(), self.spawnIcon:GetTall(), Color(0, 0, 0), 255);
	Clockwork.kernel:DrawWithTexture(panelframe88, 4, self.spawnIcon:GetWide() + 4, 0, self:GetWide() - (self.spawnIcon:GetWide() + 8), self:GetTall(), Color(0, 0, 0), 255);
end;

vgui.Register("cwStorageItem", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local colorWhite = Clockwork.option:GetColor("white");
	
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);
	self.panel = self:GetParent();
	
	self.weight = vgui.Create("DLabel", self);
	self.weight:SetText("N/A");
	self.weight:SetTextColor(colorWhite);
	self.weight:SizeToContents();
	self.weight:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	
	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsed)
		local maximumWeight = self.panel.weight or 0;
		local usedWeight = self.panel.usedWeight or 0;
		
		local color = Color(100, 100, 100, 255);
		local width = math.Clamp((spaceUsed:GetWide() / maximumWeight) * usedWeight, 0, spaceUsed:GetWide());
		local red = math.Clamp((255 / maximumWeight) * usedWeight, 0, 255) ;
		
		if (color) then
			color.r = math.min(color.r - 25, 255);
			color.g = math.min(color.g - 25, 255);
			color.b = math.min(color.b - 25, 255);
		end;
	
		surface.SetDrawColor(Color(150, 150, 150));
		surface.SetMaterial(icos);
		surface.DrawTexturedRect(0, 0, spaceUsed:GetWide(), spaceUsed:GetTall())
		
		surface.SetDrawColor(color);
		surface.SetMaterial(squash);
		surface.DrawTexturedRect(2, 2, spaceUsed:GetWide() - 4, spaceUsed:GetTall() - 4)
		
		surface.SetDrawColor(Color(139, 215, 113, 255));
		surface.SetMaterial(squash);
		surface.DrawTexturedRect(2, 2, width - 4, spaceUsed:GetTall() - 4)
	end;
end;

-- Called each frame.
function PANEL:Think()
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
	self.weight:SetText((self.panel.usedWeight or 0).."/"..(self.panel.weight or 0).."kg");
	self.weight:SetPos(self:GetWide() / 2 - self.weight:GetWide() / 2, self:GetTall() / 2 - self.weight:GetTall() / 2);
	self.weight:SizeToContents();
end;
	
vgui.Register("cwStorageWeight", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local colorWhite = Clockwork.option:GetColor("white");
	
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);
	self.panel = self:GetParent();
	
	self.space = vgui.Create("DLabel", self);
	self.space:SetText("N/A");
	self.space:SetTextColor(colorWhite);
	self.space:SizeToContents();
	self.space:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	
	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsed)
		local maximumSpace = self.panel.space or 0;
		local usedSpace = self.panel.usedSpace or 0;
		
		local color = Color(100, 100, 100, 255);
		local width = math.Clamp((spaceUsed:GetWide() / maximumSpace) * usedSpace, 0, spaceUsed:GetWide());
		local red = math.Clamp((255 / maximumSpace) * usedSpace, 0, 255) ;
		
		if (color) then
			color.r = math.min(color.r - 25, 255);
			color.g = math.min(color.g - 25, 255);
			color.b = math.min(color.b - 25, 255);
		end;
		
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, spaceUsed:GetWide(), spaceUsed:GetTall(), color);
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, width, spaceUsed:GetTall(), Color(139, 215, 113, 255));
	end;
end;

-- Called each frame.
function PANEL:Think()
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
	self.space:SetText((self.panel.usedSpace or 0).."/"..(self.panel.space or 0).."l");
	self.space:SetPos(self:GetWide() / 2 - self.space:GetWide() / 2, self:GetTall() / 2 - self.space:GetTall() / 2);
	self.space:SizeToContents();
end;
	
vgui.Register("cwStorageSpace", PANEL, "DPanel");

Clockwork.datastream:Hook("StorageStart", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		CloseDermaMenus();
		Clockwork.storage.panel:Close();
		Clockwork.storage.panel:Remove();
	end;
	
	gui.EnableScreenClicker(true);
	
	Clockwork.storage.noCashWeight = data.noCashWeight;
	Clockwork.storage.noCashSpace = data.noCashSpace;
	Clockwork.storage.isOneSided = data.isOneSided;
	Clockwork.storage.inventory = {};
	Clockwork.storage.weight = Clockwork.config:Get("default_inv_weight"):Get();
	Clockwork.storage.space = Clockwork.config:Get("default_inv_space"):Get();
	Clockwork.storage.entity = data.entity;
	Clockwork.storage.name = data.name;
	Clockwork.storage.cash = 0;
	
	local scrH, scrW = ScrH(), ScrW();
	
	Clockwork.storage.panel = vgui.Create("cwStorage");
	--Clockwork.storage.panel:Rebuild();
	--Clockwork.storage.panel:MakePopup();
	Clockwork.storage.panel:SetPos((scrW / 2) - Clockwork.storage.panel:GetWide(), (scrH / 2) - (Clockwork.storage.panel:GetTall() / 2));
	
	Clockwork.kernel:RegisterBackgroundBlur(Clockwork.storage:GetPanel(), SysTime());
end);

Clockwork.datastream:Hook("StorageRebuild", function(data)
	if IsValid(Clockwork.storage.panel) then
		Clockwork.storage.panel:Rebuild();
		Clockwork.storage.panel:MakePopup();
	end
end);

Clockwork.datastream:Hook("StorageCash", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		if istable(data) then
			Clockwork.storage.cash = data[1];
			
			if data[2] ~= false then
				Clockwork.storage:GetPanel():Rebuild();
			end
		else
			Clockwork.storage.cash = data;
			Clockwork.storage:GetPanel():Rebuild();
		end
	end;
end);

Clockwork.datastream:Hook("StorageWeight", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		if istable(data) then
			Clockwork.storage.weight = data[1];
			
			if data[2] ~= false then
				Clockwork.storage:GetPanel():Rebuild();
			end
		else
			Clockwork.storage.weight = data;
			Clockwork.storage:GetPanel():Rebuild();
		end
	end;
end);

Clockwork.datastream:Hook("StorageSpace", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		if istable(data) then
			Clockwork.storage.space = data[1];
			
			if data[2] ~= false then
				Clockwork.storage:GetPanel():Rebuild();
			end
		else
			Clockwork.storage.space = data;
			Clockwork.storage:GetPanel():Rebuild();
		end
	end;
end);

Clockwork.datastream:Hook("StorageClose", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.kernel:RemoveBackgroundBlur(Clockwork.storage:GetPanel());
	
		CloseDermaMenus();
		
		Clockwork.storage:GetPanel():Close();
		Clockwork.storage:GetPanel():Remove();
		
		gui.EnableScreenClicker(false);
	end
		
	if Clockwork.storage.inventory then
		for k, v in pairs(Clockwork.storage.inventory) do
			for k2, v2 in pairs(v) do
				item.RemoveInstance(k2, true);
			end
		end
	end
	
	Clockwork.storage.inventory = nil;
	Clockwork.storage.weight = nil;
	Clockwork.storage.space = nil;
	Clockwork.storage.entity = nil;
	Clockwork.storage.name = nil;
end);

Clockwork.datastream:Hook("StorageTake", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		if data.itemList then
			for k, v in pairs(data.itemList) do
				Clockwork.inventory:RemoveUniqueID(
					Clockwork.storage.inventory, v.uniqueID, v.itemID
				);
				
				item.RemoveInstance(v.itemID, true);
			end;
		else
			Clockwork.inventory:RemoveUniqueID(
				Clockwork.storage.inventory, data.uniqueID, data.itemID
			);
			
			item.RemoveInstance(data.itemID, true);
		end
		
		Clockwork.storage:GetPanel():Rebuild();
	end;
end);

Clockwork.datastream:Hook("StorageGive", function(data)
	if (Clockwork.storage:IsStorageOpen()) then
		local itemTable = Clockwork.item:FindByID(data.index);
		
		if (itemTable) then
			for k, v in pairs(data.itemList) do
				Clockwork.inventory:AddInstance(
					Clockwork.storage.inventory,
					Clockwork.item:CreateInstance(data.index, v.itemID, v.data)
				);
			end;
			
			if data.bRebuild ~= false then
				Clockwork.storage:GetPanel():Rebuild();
			end
		end;
	end;
end);
