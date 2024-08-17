--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local salesmenuName = Clockwork.salesmenu:GetName()

	self:SetTitle(salesmenuName)
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(false)

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus()
		self:Close() self:Remove()

		netstream.Start("SalesmanDone", Clockwork.salesmenu.entity)
			Clockwork.salesmenu.buyInShipments = nil
			Clockwork.salesmenu.priceScale = nil
			Clockwork.salesmenu.factions = nil
			Clockwork.salesmenu.buyRate = nil
			Clockwork.salesmenu.classes = nil
			Clockwork.salesmenu.entity = nil
			Clockwork.salesmenu.stock = nil
			Clockwork.salesmenu.sells = nil
			Clockwork.salesmenu.cash = nil
			Clockwork.salesmenu.text = nil
			Clockwork.salesmenu.buys = nil
			Clockwork.salesmenu.name = nil
			Clockwork.salesmenu.flags = nil
		gui.EnableScreenClicker(false)
	end

	self.propertySheet = vgui.Create("DPropertySheet", self)
	self.propertySheet:SetPadding(4)

	if (table.Count(Clockwork.salesmenu:GetSells()) > 0) then
		self.sellsPanel = vgui.Create("cwPanelList")
		self.sellsPanel:SetPadding(2)
		self.sellsPanel:SetSpacing(3)
		self.sellsPanel:SizeToContents()
		self.sellsPanel:EnableVerticalScrollbar()

		self.propertySheet:AddSheet("Sells", self.sellsPanel, "icon16/box.png", nil, nil, "View items that "..salesmenuName.." sells.")
	end

	if (table.Count(Clockwork.salesmenu:GetBuys()) > 0) then
		self.buysPanel = vgui.Create("cwPanelList")
		self.buysPanel:SetPadding(2)
		self.buysPanel:SetSpacing(3)
		self.buysPanel:SizeToContents()
		self.buysPanel:EnableVerticalScrollbar()

		self.propertySheet:AddSheet("Buys", self.buysPanel, "icon16/add.png", nil, nil, "View items that "..salesmenuName.." buys.")
	end

	Clockwork.kernel:SetNoticePanel(self)
end

-- A function to rebuild a panel.
function PANEL:RebuildPanel(typeName, panelList, inventory)
	panelList:Clear(true)
	panelList.inventory = inventory

	if (config.Get("cash_enabled"):Get()) then
		local totalCash = Clockwork.salesmenu:GetCash()

		if (totalCash > -1) then
			local cashForm = vgui.Create("DForm", panelList)
				cashForm:SetName(Clockwork.option:GetKey("name_cash"))
				cashForm:SetPadding(4)
			panelList:AddItem(cashForm)

			--[[cashForm:Help(
				Clockwork.salesmenu:GetName().." has "..Clockwork.kernel:FormatCash(totalCash, nil, true).." to their name."
			)]]--
		end
	end

	local categories = {}
	local items = {}

	for k, v in SortedPairs(panelList.inventory) do
		if (typeName == "Sells") then
			local itemTable = item.FindByID(k)

			if (itemTable) then
				local itemCategory = itemTable.category

				if (itemCategory) then
					items[itemCategory] = items[itemCategory] or {}
					items[itemCategory][#items[itemCategory] + 1] = {k, v}
				end
			end
		else
			local itemsList = Clockwork.inventory:GetItemsByID(
				Clockwork.inventory:GetClient(), k
			)

			if (itemsList) then
				for k2, v2 in SortedPairs(itemsList) do
					local itemCategory = v2.category

					if (itemCategory) then
						items[itemCategory] = items[itemCategory] or {}
						items[itemCategory][#items[itemCategory] + 1] = v2
					end
				end
			end
		end
	end

	for k, v in SortedPairs(items) do
		categories[#categories + 1] = {
			category = k,
			items = v
		}
	end

	if (table.Count(categories) > 0) then
		for k, v in SortedPairs(categories) do
			local collapsibleCategory = Clockwork.kernel:CreateCustomCategoryPanel(v.category, panelList)
				collapsibleCategory:SetCookieName("Salesmenu"..typeName..v.category)
			panelList:AddItem(collapsibleCategory)

			local categoryList = vgui.Create("DPanelList", collapsibleCategory)
				categoryList:EnableHorizontal(true)
				categoryList:SetAutoSize(true)
				categoryList:SetPadding(4)
				categoryList:SetSpacing(4)
			collapsibleCategory:SetContents(categoryList)

			if (typeName == "Sells") then
				table.sort(v.items, function(a, b)
					local itemTableA = item.FindByID(a[1])
					local itemTableB = item.FindByID(b[1])

					if (itemTableA.cost == itemTableB.cost) then
						return itemTableA.name < itemTableB.name
					else
						return itemTableA.cost > itemTableB.cost
					end
				end)

				for k2, v2 in SortedPairs(v.items) do
					CURRENT_ITEM_DATA = {
						itemTable = item.FindByID(v2[1]),
						typeName = typeName
					}

					categoryList:AddItem(
						vgui.Create("cwSalesmenuItem", categoryList)
					)
				end
			else
				table.sort(v.items, function(a, b)
					if (a.cost == b.cost) then
						return a.name < b.name
					else
						return a.cost > b.cost
					end
				end)

				for k2, v2 in SortedPairs(v.items) do
					CURRENT_ITEM_DATA = {
						itemTable = v2,
						typeName = typeName
					}

					categoryList:AddItem(
						vgui.Create("cwSalesmenuItem", categoryList)
					)
				end
			end
		end
	end
end

-- A function to rebuild the panel.
function PANEL:Rebuild()
	if (IsValid(self.sellsPanel)) then
		self:RebuildPanel("Sells", self.sellsPanel, Clockwork.salesmenu:GetSells())
	end

	if (IsValid(self.buysPanel)) then
		self:RebuildPanel("Buys", self.buysPanel, Clockwork.salesmenu:GetBuys())
	end
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW()
	local scrH = ScrH()

	self:SetSize(scrW * 0.5, scrH * 0.75)
	self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2))
	
	if !IsValid(Clockwork.salesmenu.entity) or Clockwork.Client:GetPos():Distance(Clockwork.salesmenu.entity:GetPos()) >= 196 or Clockwork.Client:IsRagdolled() or Clockwork.Client:GetNetVar("tied") != 0 then
		CloseDermaMenus()
		self:Close() self:Remove()

		netstream.Start("SalesmanDone", Clockwork.salesmenu.entity)
			Clockwork.salesmenu.buyInShipments = nil
			Clockwork.salesmenu.priceScale = nil
			Clockwork.salesmenu.factions = nil
			Clockwork.salesmenu.buyRate = nil
			Clockwork.salesmenu.classes = nil
			Clockwork.salesmenu.entity = nil
			Clockwork.salesmenu.stock = nil
			Clockwork.salesmenu.sells = nil
			Clockwork.salesmenu.cash = nil
			Clockwork.salesmenu.text = nil
			Clockwork.salesmenu.buys = nil
			Clockwork.salesmenu.name = nil
			Clockwork.salesmenu.flags = nil
		gui.EnableScreenClicker(false)
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self)

	self.propertySheet:StretchToParent(4, 28, 4, 4)
end

vgui.Register("cwSalesmenu", PANEL, "DFrame")

local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData or CURRENT_ITEM_DATA
	self.itemTable = itemData.itemTable
	self.typeName = itemData.typeName
	
	local model, skin = item.GetIconInfo(self.itemTable)
	
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
		local entity = Clockwork.salesmenu:GetEntity()

		if (IsValid(entity)) then
			netstream.Start("Salesmenu", {
				tradeType = self.typeName,
				uniqueID = self.itemTable.uniqueID,
				itemID = self.itemTable.itemID,
				entity = entity
			})
		end
	end

	self.spawnIcon:SetModel(model, skin)
	--self.spawnIcon:SetTooltip("")
	self.spawnIcon:SetSize(64, 64)
end

-- Called each frame.
function PANEL:Think()
	local function DisplayCallback(displayInfo)
		local priceScale = 1
		local amount = 0

		if (Clockwork.salesmenu:BuyInShipments()) then
			amount = self.itemTable.batch
		else
			amount = 1
		end

		if (self.typeName == "Sells") then
			priceScale = Clockwork.salesmenu:GetPriceScale()
		elseif (self.typeName == "Buys") then
			priceScale = Clockwork.salesmenu:GetBuyRate() / 100
		end

		if (config.Get("cash_enabled"):Get()) then
			if (self.itemTable.cost != 0) then
				displayInfo.weight = Clockwork.kernel:FormatCash(
					(self.itemTable.cost * priceScale) * math.max(amount, 1)
				)
			else
				displayInfo.weight = "Free"
			end

			local overrideCash = Clockwork.salesmenu.sells[self.itemTable.uniqueID]

			if (self.typeName == "Buys") then
				overrideCash = Clockwork.salesmenu.buys[self.itemTable.uniqueID]
			end

			if (type(overrideCash) == "number") then
				displayInfo.weight = Clockwork.kernel:FormatCash(overrideCash * math.max(amount, 1))
			end
		end

		local name = self.itemTable.name

		if (amount > 1) then
			displayInfo.name = amount.." "..Clockwork.kernel:Pluralize(name)
		else
			displayInfo.name = name
		end

		if (Clockwork.salesmenu.stock) then
			local iStockLeft = Clockwork.salesmenu.stock[self.itemTable.uniqueID]

			if (self.typeName == "Sells" and iStockLeft) then
				displayInfo.itemTitle = "["..iStockLeft.."] ["..displayInfo.name..", "..displayInfo.weight.."]"
			end
		end
	end
	
	if Clockwork.salesmenu.sells then
		local overrideCash = Clockwork.salesmenu.sells[self.itemTable.uniqueID];
		
		if self.typeName == "Buys" then
			overrideCash = Clockwork.salesmenu.buys[self.itemTable.uniqueID];
			
			local condition = self.itemTable:GetCondition();
			
			if condition and condition < 100 then
				overrideCash = math.max(1, math.Round(overrideCash * Lerp(condition / 100, 0.15, 1)));
			
				if condition <= 0 then
					self.spawnIcon.brokenOverlay = vgui.Create("DImage", self.spawnIcon);
					self.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
					self.spawnIcon.brokenOverlay:SetSize(64, 64);
				else
					self.spawnIcon.conditionBar = vgui.Create("DImage", self.spawnIcon);
					self.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
					self.spawnIcon.conditionBar:SetPos(4, 56);
					self.spawnIcon.conditionBar:SetSize(56, 6);
					self.spawnIcon.conditionBar.fill = vgui.Create("DShape", self.spawnIcon.conditionBar);
					self.spawnIcon.conditionBar.fill:SetType("Rect");
					self.spawnIcon.conditionBar.fill:SetPos(2, 2);
					self.spawnIcon.conditionBar.fill:SetSize(52 * (condition / 100), 2);
					self.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - condition), 1 * condition, 0, 225));
				end
			end
		elseif cwBeliefs and cwBeliefs:HasBelief("fortune_finisher") then
			overrideCash = math.max(1, math.Round(overrideCash * 0.9));
		end
		
		if overrideCash and (type(overrideCash) == "number") and overrideCash > 0 then
			if !IsValid(self.spawnIcon.cost) then
				self.spawnIcon.cost = vgui.Create("DLabel", self.spawnIcon);
			end
			
			self.spawnIcon.cost:SetText("₵"..overrideCash);
			self.spawnIcon.cost:SetFont("Decay_FormText");
			
			if self.typeName == "Sells" then
				if overrideCash > Clockwork.player:GetCash() then
					self.spawnIcon.cost:SetTextColor(Color(200, 0, 0));
				else
					self.spawnIcon.cost:SetTextColor(Color(0, 200, 0));
				end
			elseif self.typeName == "Buys" then
				--[[if (Clockwork.salesmenu:GetCash() ~= -1) and overrideCash > Clockwork.salesmenu:GetCash() then
					self.spawnIcon.cost:SetTextColor(Color(200, 0, 0));
				else]]
					self.spawnIcon.cost:SetTextColor(Color(0, 200, 0));
				--end
			end
			
			self.spawnIcon.cost:SizeToContents();
			
			if self.spawnIcon.conditionBar then
				self.spawnIcon.cost:SetPos(4, 38);
			else
				self.spawnIcon.cost:SetPos(4, 46);
			end
		elseif self.spawnIcon and self.spawnIcon.cost then
			self.spawnIcon.cost:Remove();
		end
	end
	
	--[[self.spawnIcon:SetMarkupToolTip(
		item.GetMarkupToolTip(self.itemTable, true, DisplayCallback)
	)]]--
	--self.spawnIcon:SetColor(self.itemTable.color)
end

vgui.Register("cwSalesmenuItem", PANEL, "DPanel")