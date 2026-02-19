--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

if (IsValid(Clockwork.Client.cwCraftingMenu)) then
	Clockwork.Client.cwCraftingMenu:Close()
	Clockwork.Client.cwCraftingMenu:Remove()
	Clockwork.Client.cwCraftingMenu = nil;
end

local gradientDown = surface.GetTextureID("gui/gradient_down")
local topBackground = Material("begotten/ui/oilcanvas.png")
local topFrame = Material("begotten/ui/panelframe.png")
local bottomBackground = Material("begotten/ui/collapsible3-1-10.png")
local bottomFrame = Material("begotten/ui/panelframe88.png")
local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetDeleteOnClose(false)
	self:SetTitle("")
	self:SetDraggable(false)
end

-- Called when the panel is painted.
function PANEL:Paint()
	local width, height = self:GetWide(), self:GetTall()
	local DRAW_BACKGROUND = true
	local DRAW_BOTTOM = true
	local DRAW_TOP = true
	local x, y = 0, 0
	
	if (!IsValid(self.closeButton)) then
		return
	end
	
	if (DRAW_BACKGROUND) then
		if (DRAW_TOP) then
			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(topBackground)
			surface.DrawTexturedRect(x + 4, y + 4, width - 8, (height - 96) - 8)

			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(bottomBackground)
			surface.DrawTexturedRect(x, height - 88, width, 88)
		end
		
		draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))
		
		if (DRAW_BOTTOM) then
			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(topFrame)
			surface.DrawTexturedRect(x, y, width, height - 96)

			surface.SetDrawColor(255, 255, 255, 200)
			surface.SetMaterial(bottomFrame)
			surface.DrawTexturedRect(x, height - 88, width, 88)
		end
	end
end

-- A function to add a recipe to the currently open list.
function PANEL:AddRecipe(recipeData)
	local recipePanel = vgui.Create("cwRecipePanel", self)
	
	recipePanel:SetRecipeData(recipeData);
	recipePanel:Rebuild();
	
	self.recipeList:AddItem(recipePanel);
end

-- A function to rebuild the panel.
function PANEL:Rebuild()
	local faction = Clockwork.Client:GetFaction();
	local faith = Clockwork.Client:GetNetVar("faith");
	local subfaction = Clockwork.Client:GetNetVar("subfaction");
	local subfaith = Clockwork.Client:GetNetVar("subfaith");
	self.fire_found = false;
	self.smithy_found = false;
	
	for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 128)) do
		if (v:GetClass() == "env_fire") then
			self.fire_found = true;
			break;
		end;
	end;
	
	for i = 1, #cwRecipes.smithyLocations do
		if Clockwork.Client:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
			self.smithy_found = true;
			break;
		end
	end
	
	local scrW, scrH = ScrW(), ScrH()
	local sizeW, sizeH = 1555, 864;
	local centerW, centerH = scrW * 0.5, scrH * 0.45

	self:SetSize(sizeW, sizeH + 64)
	self:SetPos(centerW - (sizeW / 2), centerH - (sizeH / 2))
	self:ShowCloseButton(false)
	
	surface.PlaySound("generic_ui/smelt_success_01.wav");
	
	local width, height = self:GetSize()
	
	if (!self.categoryList) then
		self.categoryList = vgui.Create("DPanelList", self);
		self.categoryList:SetPos(7, 6);
		self.categoryList:SetSize(1541, 70);
		self.categoryList:EnableHorizontal(true);
		self.categoryList:SetSpacing(1);
		self.categoryList:HideScrollbar();
		self.categoryList:SetDrawBackground(false);
		
		self.weaponButton = vgui.Create("DButton", self)
		self.weaponButton:SetText("Melees");
		self.weaponButton:SetSize(256, 70);
		self.weaponButton:SetTextColor(Color(160, 0, 0));
		self.weaponButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.weaponButton.category = "Weapons";
		
		local width, height = self.weaponButton:GetWide(), self.weaponButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.weaponButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Weapons" then
				self:BuildRecipeList("Weapons", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.weaponButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.munitionButton = vgui.Create("DButton", self)
		self.munitionButton:SetText("Munitions");
		self.munitionButton:SetSize(256, 70);
		self.munitionButton:SetTextColor(Color(160, 0, 0));
		self.munitionButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.munitionButton.category = "Munitions";
		
		local width, height = self.munitionButton:GetWide(), self.munitionButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.munitionButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Munitions" then
				self:BuildRecipeList("Munitions", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.munitionButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.armorButton = vgui.Create("DButton", self)
		self.armorButton:SetText("Armor");
		self.armorButton:SetSize(256, 70);
		self.armorButton:SetTextColor(Color(160, 0, 0));
		self.armorButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.armorButton.category = "Armor";
		
		local width, height = self.armorButton:GetWide(), self.armorButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.armorButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Armor" then
				self:BuildRecipeList("Armor", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.armorButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.cookingButton = vgui.Create("DButton", self)
		self.cookingButton:SetText("Cooking");
		self.cookingButton:SetSize(256, 70);
		self.cookingButton:SetTextColor(Color(160, 0, 0));
		self.cookingButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.cookingButton.category = "Cooking";
		
		local width, height = self.cookingButton:GetWide(), self.cookingButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.cookingButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Cooking" then
				self:BuildRecipeList("Cooking", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.cookingButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.medicalButton = vgui.Create("DButton", self)
		self.medicalButton:SetText("Medical");
		self.medicalButton:SetSize(256, 70);
		self.medicalButton:SetTextColor(Color(160, 0, 0));
		self.medicalButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.medicalButton.category = "Medical";
		
		local width, height = self.medicalButton:GetWide(), self.medicalButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.medicalButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Medical" then
				self:BuildRecipeList("Medical", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.medicalButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.otherButton = vgui.Create("DButton", self)
		self.otherButton:SetText("Other");
		self.otherButton:SetSize(256, 70);
		self.otherButton:SetTextColor(Color(160, 0, 0));
		self.otherButton:SetFont("nov_IntroTextSmallfaaaaa");
		self.otherButton.category = "Other";
		
		local width, height = self.otherButton:GetWide(), self.otherButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.otherButton.DoClick()
			surface.PlaySound("begotten/ui/buttonrollover.wav")
			
			if self.recipeListOpen ~= "Other" then
				self:BuildRecipeList("Other", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));
			end
		end
		
		-- Called when the panel is painted.
		function self.otherButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		self.categoryList:AddItem(self.weaponButton);
		self.categoryList:AddItem(self.munitionButton);
		self.categoryList:AddItem(self.armorButton);
		self.categoryList:AddItem(self.cookingButton);
		self.categoryList:AddItem(self.medicalButton);
		self.categoryList:AddItem(self.otherButton);
		
		self.categoryList.hbar = vgui.Create("DImage", self);
		self.categoryList.hbar:SetPos(6, 76);
		self.categoryList.hbar:SetSize(1543, 3);
		self.categoryList.hbar:SetImage("begotten/ui/hbar.png");
	end
	
	if (!self.recipeList) then
		self.recipeList = vgui.Create("DPanelList", self);
		self.recipeList:SetPos(7, 109);
		self.recipeList:SetSize(768, 738);
		self.recipeList:SetSpacing(1);
		self.recipeList:SetDrawBackground(false);
		self.recipeList:EnableVerticalScrollbar();
		--self.recipeList:HideScrollbar();
	else
		self.recipeList:Clear();
	end
	
	if (!self.vbar) then
		self.categoryList.vbar = vgui.Create("DImage", self);
		self.categoryList.vbar:SetPos(776, 78);
		self.categoryList.vbar:SetSize(3, 750);
		self.categoryList.vbar:SetImage("begotten/ui/vbar.png");
	end

	if (!self.closeButton) then
		self.closeButton = vgui.Create("DButton", self)
		self.closeButton:SetText("CLOSE")
		self.closeButton:SetSize(252, 67)
		self.closeButton:SetPos(14, (sizeH + 64) - (67 + 8) - 2)
		self.closeButton:SetTextColor(Color(160, 0, 0))
		self.closeButton:SetFont("nov_IntroTextSmallfaaaaa")
		
		local width, height = self.closeButton:GetWide(), self.closeButton:GetTall()
		local buttonMaterial = Material("begotten/ui/butt24.png")
		
		-- Called when the button is painted.
		function self.closeButton.DoClick()
			if (IsValid(self)) then
				self:Close()
				self:Remove();
				
				Clockwork.Client.cwCraftingMenu = nil;
			end
			
			surface.PlaySound("begotten/ui/buttonclick.wav")
		end
		
		-- Called when the panel is painted.
		function self.closeButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(buttonMaterial)
			surface.DrawTexturedRect(0, 0, width, height)
		end
	end
	
	if (!self.rightSide) then
		self.rightSide = vgui.Create("cwInventoryCrafting", self);
	end
	
	-- Default to weapons.
	self:BuildRecipeList("Weapons", faction, faith, subfaction, subfaith, (cwRecipes.recipeSearch and cwRecipes.recipeSearch or ""));

	if (!self.recipeSearch) then
		self.recipeSearch = self:Add("cwSearchBox");
		self.recipeSearch:SetPos(7,79);
		self.recipeSearch:SetWide(768);

		if(cwRecipes.recipeSearch) then
			self.recipeSearch:SetValue(cwRecipes.recipeSearch);
		end

		self.recipeSearch.OnChange = function()
			cwRecipes.recipeSearch = string.gsub(self.recipeSearch:GetText() or "", "[^%w%s%-]", "");

			self:BuildRecipeList(self.recipeListOpen, faction, faith, subfaction, subfaith, cwRecipes.recipeSearch);
		end
	end
end

function PANEL:BuildRecipeList(category, faction, faith, subfaction, subfaith, searchTerm)
	if IsValid(self.recipeList) then
		self.recipeList:Clear();
	
		local recipes = cwRecipes:GetAll();
		
		-- Todo later: sort recipes based on tier/quality?
		for k, v in SortedPairs(recipes) do
			if v.category == category then
				if v.requiredFactions then
					if not table.HasValue(v.requiredFactions, faction) then
						continue;
					end
				elseif v.excludedFactions then
					if table.HasValue(v.excludedFactions, faction) then
						continue;
					end
				end
				
				if v.requiredFaiths then
					if not table.HasValue(v.requiredFaiths, faith) then
						continue;
					end
				elseif v.excludedFaiths then
					if table.HasValue(v.excludedFaiths, faith) then
						continue;
					end
				end
				
				if v.requiredSubfactions then
					if not table.HasValue(v.requiredSubfactions, subfaction) then
						continue;
					end
				elseif v.excludedSubfactions then
					if table.HasValue(v.excludedSubfactions, subfaction) then
						continue;
					end
				end
				
				if v.requiredSubfaiths then
					if not table.HasValue(v.requiredSubfaiths, subfaith) then
						continue;
					end
				elseif v.excludedSubfaiths then
					if table.HasValue(v.excludedSubfaiths, subfaith) then
						continue;
					end
				end

				if (searchTerm and !string.find(string.lower(v.name), string.lower(searchTerm))) then
					continue;
				end
			
				self:AddRecipe(v);
			end
		end
		
		self.recipeListOpen = category;
		
		for k, v in pairs(self.categoryList:GetItems()) do
			if v.category == category then
				v:SetTextColor(Color(160, 150, 150));
			else
				v:SetTextColor(Color(160, 0, 0));
			end
		end
	end
end

function PANEL:UpdateSelectedRecipe(uniqueID)
	self.selectedRecipe = uniqueID;
	
	local recipeTable = cwRecipes.recipes.stored[uniqueID];
	
	self.rightSide.selectedRecipeLabel:SetText("Selected Recipe: "..recipeTable.name.." ("..self.rightSide.craftAmount.."x)");
	self.rightSide.selectedRecipeLabel:SizeToContents();
	self.rightSide.selectedRecipeLabel:SetPos(370 - (self.rightSide.selectedRecipeLabel:GetSize() / 2), 330);
end

-- Called when the panel is closed.
function PANEL:OnClose()
	--cwBeliefs:RemoveBackgroundBlur(self)
end

vgui.Register("cwCraftingMenu", PANEL, "DFrame")

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(769, 100);
end;

-- Called when the panel is initialized.
function PANEL:SetRecipeData(recipeData)
	self.recipeData = recipeData;
	
	for k, v in pairs(recipeData.result) do
		self.recipeData.primaryResultingItem = Clockwork.item:FindByID(k);
		self.recipeData.primaryResultingItemAmount = v.amount or 1;
		break;
	end
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	local recipeData = self.recipeData;
	local requiredBeliefs = recipeData.requiredBeliefs;
	
	self.characterFrame = vgui.Create("DImage", self);
	self.characterFrame:SetImage("begotten/ui/charactermenu/necropolisframe.png");
	self.characterFrame:SetSize(769, 100);
	
	self.itemData = {};
	self.itemData.itemTable = recipeData.primaryResultingItem;
	self.itemData.amount = recipeData.primaryResultingItemAmount;
	
	if self.itemData.itemTable then
		self.recipeImageFrame = vgui.Create("DImage", self);
		self.recipeImageFrame:SetImage("begotten/ui/recipeframe.png");
		self.recipeImageFrame:SetSize(72, 71);
		self.recipeImageFrame:SetPos(14, 15);
		
		self.recipeImage = vgui.Create("cwRecipeItem", self);
		self.recipeImage:SetSize(64, 64);
		self.recipeImage:SetPos(18, 18);
		self.recipeImage.mainItem = true;
		
		if recipeData.uniqueID == Clockwork.Client.cwCraftingMenu.selectedRecipe then
			self.recipeImage.spawnIcon:SetColor(Color(255, 150, 150, 255));
			self.recipeImageFrame:SetImageColor(Color(255, 150, 150, 255));
		end
	end
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetText(recipeData.name);
	self.nameLabel:SetTextColor(Color(200, 20, 20));
	self.nameLabel:SetFont("nov_IntroTextSmallDETrooper");
	self.nameLabel:SizeToContents();
	self.nameLabel:SetPos(100, 6);
	
	if recipeData.requiresHeatSource then
		self.heatSourceLabel = vgui.Create("DLabel", self);
		self.heatSourceLabel:SetText("Requires Heat Source");
		--self.heatSourceLabel:SetTextColor(Color(160, 145, 145));
		self.heatSourceLabel:SetFont("Decay_FormText");
		self.heatSourceLabel:SetPos(100, 52);
		self.heatSourceLabel:SizeToContents();
		
		if Clockwork.Client.cwCraftingMenu.fire_found then
			self.heatSourceLabel:SetTextColor(Color(25, 150, 25));
		else
			self.heatSourceLabel:SetTextColor(Color(200, 25, 25));
		end
	elseif recipeData.requiresSmithy then
		self.smithyLabel = vgui.Create("DLabel", self);
		self.smithyLabel:SetText("Requires Smithy");
		--self.smithyLabel:SetTextColor(Color(160, 145, 145));
		self.smithyLabel:SetFont("Decay_FormText");
		self.smithyLabel:SetPos(100, 52);
		self.smithyLabel:SizeToContents();
		
		if Clockwork.Client.cwCraftingMenu.smithy_found then
			self.smithyLabel:SetTextColor(Color(25, 150, 25));
		else
			self.smithyLabel:SetTextColor(Color(200, 25, 25));
		end
	end
	
	if cwBeliefs and requiredBeliefs then
		local beliefIcons = {};
		
		self.tierLabel = vgui.Create("DLabel", self);
		self.tierLabel:SetFont("Decay_FormText");
		self.tierLabel:SetText("Required Beliefs:");
		self.tierLabel:SetPos(100, 30);
		self.tierLabel:SizeToContents();
	
		for i, v in ipairs(requiredBeliefs) do
			local beliefTable = cwBeliefs:FindBeliefByID(v);
			
			if beliefTable then
				local tooltip = function(frame)
					frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
					
					if beliefTable.quote then
						frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
						frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
					else
						frame:AddText(beliefTable.description, Color(225, 200, 200));
					end
				end
				
				if beliefTable.iconOverride then
					table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
				else
					table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..v..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
				end
			end
		end

		if cwBeliefs:HasBelief(requiredBeliefs) then
			self.tierLabel:SetTextColor(Color(25, 150, 25));
		else
			self.tierLabel:SetTextColor(Color(200, 25, 25));
		end

		local width = self.tierLabel:GetX() + self.tierLabel:GetWide() + 6;
		
		if self.heatSourceLabel then
			local newWide = self.heatSourceLabel:GetX() + self.heatSourceLabel:GetWide() + 6;
			
			if newWide > width then
				width = newWide;
			end
		end
		
		if self.smithyLabel then
			local newWide = self.smithyLabel:GetX() + self.smithyLabel:GetWide() + 6;
			
			if newWide > width then
				width = newWide;
			end
		end
		
		local iconBox = vgui.Create("DPanelList", self);
		iconBox:SetSize(176, 40);
		iconBox:SetPos(width, self.tierLabel:GetY() + 2);
		iconBox:SetPadding(0);
		iconBox:SetSpacing(4);
		iconBox:EnableHorizontal(true);
		
		-- Called when the panel is painted.
		function iconBox:Paint(width, height)

		end;
		
		for i, v in ipairs(beliefIcons) do
			local icon;
			
			if v.button and isfunction(v.button) then
				icon = vgui.Create("DImageButton", self);
				
				icon.DoClick = v.button
				icon.DoRightClick = icon.DoClick;
			else
				icon = vgui.Create("DImage", self);
			end
			
			icon:SetSize(40, 40);
			icon:SetImage(v.icon);
			
			if v.tooltip and isfunction(v.tooltip) then
				Clockwork.kernel:CreateDermaToolTip(icon);

				icon:SetToolTipCallback(v.tooltip);
			end
			
			iconBox:AddItem(icon);
		end;
	end
	
	if recipeData.experience then
		self.xpLabel = vgui.Create("DLabel", self);
		self.xpLabel:SetText("Reward: "..tostring(recipeData.experience).." Faith");
		self.xpLabel:SetTextColor(Color(25, 150, 25));
		self.xpLabel:SetFont("Decay_FormText");
		self.xpLabel:SizeToContents();
		self.xpLabel:SetPos(100, 74);
	end
	
	-- Unique requirements for an items should probably not exceed 7.
	self.requirementsList = vgui.Create("DPanelList", self);
	--self.requirementsList:SetPos(300, 18);
	--self.requirementsList:SetSize(476, 64);
	self.requirementsList:EnableHorizontal(true);
	self.requirementsList:CenterHorizontal(0.5);
	self.requirementsList:SetSpacing(4);
	self.requirementsList:SetDrawBackground(false);
	
	for k, v in SortedPairs(recipeData.requirements) do
		self.itemData.itemTable = Clockwork.item:FindByID(k);

		self.itemData.amount = v.amount or 1;
		
		local requiredItem = vgui.Create("cwRecipeItem", self);
		
		requiredItem:SetSize(64, 64);
		
		self.requirementsList:AddItem(requiredItem);
	end
	
	--self.requirementsList:SizeToContents();
	self.requirementsList:SetSize(476, 64);
	--self.requirementsList:SetPos(300 + ((476 - self.requirementsList:GetSize()) / 2), 28);
	self.requirementsList:SetPos(300 + 224 - ((68 * #self.requirementsList:GetItems() / 2)), 28);
	
	self.requirementsLabel = vgui.Create("DLabel", self);
	self.requirementsLabel:SetText("Items Required:");
	self.requirementsLabel:SetTextColor(Color(160, 145, 145));
	self.requirementsLabel:SetFont("Decay_FormText");
	self.requirementsLabel:SizeToContents();
	--self.requirementsLabel:SetPos(300 + ((476 - self.requirementsList:GetSize()) / 2) - (self.requirementsLabel:GetSize() / 4), 6);
	self.requirementsLabel:SetPos(472, 6);
end;

vgui.Register("cwRecipePanel", PANEL, "DPanel");

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
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (!self.nextCanClick or CurTime() >= self.nextCanClick) then
			if self.mainItem then
				self:GetParent():GetParent():GetParent():GetParent().rightSide.craftAmount = 1;
				self:GetParent():GetParent():GetParent():GetParent():UpdateSelectedRecipe(self:GetParent().recipeData.uniqueID);

				for _, v in ipairs(self:GetParent():GetParent():GetChildren()) do
					if v.recipeData.uniqueID == Clockwork.Client.cwCraftingMenu.selectedRecipe then
						if v.recipeImage then
							v.recipeImage.spawnIcon:SetColor(Color(255, 150, 150, 255));
						end
					
						if v.recipeImageFrame then
							v.recipeImageFrame:SetImageColor(Color(255, 150, 150, 255));
						end
					else
						if v.recipeImage then
							v.recipeImage.spawnIcon:SetColor(Color(255, 255, 255, 255));
						end
					
						if v.recipeImageFrame then
							v.recipeImageFrame:SetImageColor(Color(255, 255, 255, 255));
						end
					end
				end
			end
			
			self.nextCanClick = CurTime() + 1;
		end;
	end;
	
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

	--if (self.itemTable.stackable) then
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
	--end;

	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	
	if (model != self.cachedInfo.model or skin != self.cachedInfo.skin) then
		spawnIcon:SetModel(model, skin);
		self.cachedInfo.model = model
		self.cachedInfo.skin = skin;
	end;
end;

vgui.Register("cwRecipeItem", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(740, 748);
	self:SetName("Inventory");
	self:Receiver("invdummy", nil);
	
	self.craftingSlotFrames = vgui.Create("DImage", self);
	self.craftingSlotFrames:SetSize(740, 328);
	self.craftingSlotFrames:SetPos(0, 20);
	self.craftingSlotFrames:SetImage("begotten/ui/craftinggrid.png");

	self.craftAmount = 1;
	
	self.craftingSlotLocations = {
		[1] = {x = 222, y = 41, receiver = nil, occupier = nil},
		[2] = {x = 339, y = 41, receiver = nil, occupier = nil},
		[3] = {x = 456, y = 41, receiver = nil, occupier = nil},
		[4] = {x = 222, y = 149, receiver = nil, occupier = nil},
		[5] = {x = 339, y = 149, receiver = nil, occupier = nil},
		[6] = {x = 456, y = 149, receiver = nil, occupier = nil},
		[7] = {x = 222, y = 257, receiver = nil, occupier = nil},
		[8] = {x = 339, y = 257, receiver = nil, occupier = nil},
		[9] = {x = 456, y = 257, receiver = nil, occupier = nil},
	};
	
	self.craftButton = vgui.Create("DButton", self)
	self.craftButton:SetText("Craft");
	self.craftButton:SetSize(256, 70);
	self.craftButton:SetPos(242, 356);
	self.craftButton:SetTextColor(Color(160, 0, 0));
	self.craftButton:SetFont("nov_IntroTextSmallfaaaaa");
	
	local width, height = self.craftButton:GetWide(), self.craftButton:GetTall()
	local buttonMaterial = Material("begotten/ui/butt24.png")

	local this = self;
	
	-- Called when the button is painted.
	function self.craftButton.DoClick()
		surface.PlaySound("begotten/ui/buttonclick.wav")
		
		cwRecipes:AttemptCraft(this:GetParent().selectedRecipe, this.craftAmount);
	end
	
	-- Called when the panel is painted.
	function self.craftButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(buttonMaterial)
		surface.DrawTexturedRect(0, 0, width, height)
	end

	self.amtButtonP = self:Add("DButton");
	self.amtButtonP:SetText("+");
	self.amtButtonP:SetTextInset(1, -5);
	self.amtButtonP:SetSize(32, 32);
	self.amtButtonP:SetPos(502, 356);
	self.amtButtonP:SetTextColor(Color(160, 0, 0));
	self.amtButtonP:SetFont("nov_IntroTextSmallfaaaaa");

	local width, height = self.amtButtonP:GetWide(), self.amtButtonP:GetTall();
	local buttonMaterial = Material("begotten/ui/bgtbtn1.png");
	
	-- Called when the button is painted.
	function self.amtButtonP.DoClick()
		surface.PlaySound("begotten/ui/buttonrollover.wav");

		if(!this:GetParent().selectedRecipe) then return; end

		local itemsNeeded = 0;

		for i, v in pairs(cwRecipes.recipes.stored[this:GetParent().selectedRecipe].requirements) do
			itemsNeeded = itemsNeeded + v.amount;

		end

		local targetCraftAmount = input.IsKeyDown(KEY_LSHIFT) and math.floor(9/itemsNeeded) or this.craftAmount+1;

		if(itemsNeeded*(targetCraftAmount) > 9) then return; end
		
		this.craftAmount = targetCraftAmount;

		this:GetParent():UpdateSelectedRecipe(this:GetParent().selectedRecipe);

	end
	
	-- Called when the panel is painted.
	function self.amtButtonP.Paint()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(buttonMaterial);
		surface.DrawTexturedRect(0, 0, width, height);
	end

	self.amtButtonM = self:Add("DButton");
	self.amtButtonM:SetText("-");
	self.amtButtonM:SetTextInset(1, -5);
	self.amtButtonM:SetSize(32, 32);
	self.amtButtonM:SetPos(502, 394);
	self.amtButtonM:SetTextColor(Color(160, 0, 0));
	self.amtButtonM:SetFont("nov_IntroTextSmallfaaaaa");

	local width, height = self.amtButtonM:GetWide(), self.amtButtonM:GetTall();
	local buttonMaterial = Material("begotten/ui/bgtbtn1.png");
	
	-- Called when the button is painted.
	function self.amtButtonM.DoClick()
		surface.PlaySound("begotten/ui/buttonrollover.wav");

		if(!this:GetParent().selectedRecipe) then return; end

		local itemsNeeded = 0;

		for i, v in pairs(cwRecipes.recipes.stored[this:GetParent().selectedRecipe].requirements) do
			itemsNeeded = itemsNeeded + v.amount;

		end

		local targetCraftAmount = input.IsKeyDown(KEY_LSHIFT) and 1 or this.craftAmount-1;

		if(itemsNeeded*(this.craftAmount-1) > 9) then return; end
		
		this.craftAmount = math.max(this.craftAmount - 1, 1);

		this:GetParent():UpdateSelectedRecipe(this:GetParent().selectedRecipe);

	end
	
	-- Called when the panel is painted.
	function self.amtButtonM.Paint()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(buttonMaterial);
		surface.DrawTexturedRect(0, 0, width, height);
	end
	
	if (!self.selectedRecipeLabel) then
		self.selectedRecipeLabel = vgui.Create("DLabel", self);
		
		if !self:GetParent().selectedRecipe then
			self.selectedRecipeLabel:SetText("You have no recipe selected!");
		else
			local recipeTable = cwRecipes.recipes.stored[self:GetParent().selectedRecipe];
			
			self.selectedRecipeLabel:SetText("Selected Recipe: "..recipeTable.name.." ("..self.craftAmount.."x)");
		end
		
		self.selectedRecipeLabel:SetTextColor(Color(200, 20, 20));
		self.selectedRecipeLabel:SetFont("nov_IntroTextSmallDETrooper");
		self.selectedRecipeLabel:SizeToContents();
		self.selectedRecipeLabel:SetPos(370 - (self.selectedRecipeLabel:GetSize() / 2), 330);
	end
	
	for i = 1, #self.craftingSlotLocations do
		local v = self.craftingSlotLocations[i];
		
		v.receiver = vgui.Create('DPanel', self);
	
		if v.receiver then
			v.receiver:SetSize(64, 64);
			v.receiver:SetPos(v.x, v.y);
			
			v.receiver:Receiver("craftingSlot", function(self, panels, dropped, menuIndex, x, y)
				if (dropped) then
					local panel = panels[1];
					
					if panel then
						local parent = panel:GetParent();

						if parent and parent.itemData and parent.itemTable then
							if !cwRecipes.slottedItems then
								cwRecipes.slottedItems = {};
							end
							
							-- Check to see if the itemID is already inserted. Lag can sometimes cause this.
							if table.HasValue(cwRecipes.slottedItems, parent.itemTable.itemID) then
								cwRecipes.inventoryPanel:Rebuild();
								return;
							end
						
							if !v.occupier then
								table.insert(cwRecipes.slottedItems, parent.itemTable.itemID);
								
								cwRecipes.inventoryPanel:Rebuild();
								return;
							else
								for i = 1, #cwRecipes.inventoryPanel.craftingSlotLocations do
									local v2 = cwRecipes.inventoryPanel.craftingSlotLocations[i];
									
									if !v2.occupier then
										table.insert(cwRecipes.slottedItems, parent.itemTable.itemID);
										
										cwRecipes.inventoryPanel:Rebuild();
										return;
									end
								end
							end
						end
					end
				end
			end);
		end
	end
	
	self.inventoryList = vgui.Create("DPanelList", self);
 	self.inventoryList:SetPadding(8);
 	self.inventoryList:SetSpacing(8);
	
	cwRecipes.slottedItems = {};
	cwRecipes.inventoryPanel = self;
	self:Rebuild();
	
	self.inventoryList:EnableVerticalScrollbar(true);
end;

function PANEL:DoDrop(self, panels, bDoDrop, Command, x, y)
	if (bDoDrop) then
		for k, v in pairs (panels) do
			self:AddItem(v);
		end
	end
end

-- Called to by the menu to get the width of the panel.
function PANEL:GetMenuWidth()
	return 740;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.inventoryList:Clear();
	
	if not self.slottedIconList then
		self.slottedIconList = {};
	end

	for k, v in pairs(self.slottedIconList) do
		v:Remove();
	end
	
	for k, v in pairs(self.craftingSlotLocations) do
		v.occupier = nil;
	end
	
	self.itemList = vgui.Create("DPanelList", self.inventoryList);
 	self.itemList:SetPadding(8);
 	self.itemList:SetSpacing(8);
	self.itemList:SetPaintBackground(false);
	
	self.inventoryList:Receiver("inventory", function(self, panels, dropped, menuIndex, x, y)
		if (dropped) then
			local panel = panels[1];
			
			if panel then
				local parent = panel:GetParent();

				if parent and parent.itemData and parent.itemTable then
					for i = 1, #cwRecipes.inventoryPanel.craftingSlotLocations do
						local v = cwRecipes.inventoryPanel.craftingSlotLocations[i];
						
						if v.occupier and v.occupier == parent then
							if !cwRecipes.slottedItems then
								cwRecipes.slottedItems = {};
							end
							
							for k = 1, #cwRecipes.slottedItems do
								if cwRecipes.slottedItems[k] == parent.itemTable.itemID then
									table.remove(cwRecipes.slottedItems, k);
									break;
								end
							end
							
							cwRecipes.inventoryPanel:Rebuild();
							return;
						end
					end
				end
			end
		end
	end);
	
	self.weightForm = vgui.Create("DForm", self);
	self.weightForm:SetPadding(4);
	self.weightForm:SetSpacing(4);
	self.weightForm:SetName("Weight");
	self.weightForm:AddItem(vgui.Create("cwInventoryWeight", self));

	if (Clockwork.inventory:UseSpaceSystem()) then
		self.spaceForm = vgui.Create("DForm", self);
		self.spaceForm:SetPadding(4);
		self.spaceForm:SetSpacing(4);
		self.spaceForm:SetName("Space");
		self.spaceForm:AddItem(vgui.Create("cwInventorySpace", self));
	end

	local itemsList = {inventory = {}, slotted = {}};
	local categories = {inventory = {}, slotted = {}};
	
	for k, v in pairs(Clockwork.inventory:GetClient()) do
		for k2, v2 in pairs(v) do
			local itemCategory = v2("category");
			
			if !cwRecipes.slottedItems then
				cwRecipes.slottedItems = {};
			end
			
			if v2.HasPlayerEquipped and v2:HasPlayerEquipped(Clockwork.Client, true) then
				continue;
			end
			
			if table.HasValue(cwRecipes.slottedItems, v2.itemID) then
				itemsList.slotted[itemCategory] = itemsList.slotted[itemCategory] or {};
				itemsList.slotted[itemCategory][#itemsList.slotted[itemCategory] + 1] = v2;
			else
				itemsList.inventory[itemCategory] = itemsList.inventory[itemCategory] or {};
				itemsList.inventory[itemCategory][#itemsList.inventory[itemCategory] + 1] = v2;
			end
		end;
	end;
	
	for k, v in pairs(itemsList.slotted) do
		categories.slotted[#categories.slotted + 1] = {
			itemsList = v,
			category = k
		};
	end;
	
	table.sort(categories.slotted, function(a, b)
		return a.category < b.category;
	end);
	
	for k, v in pairs(itemsList.inventory) do
		categories.inventory[#categories.inventory + 1] = {
			itemsList = v,
			category = k,
		};
	end;
	
	table.sort(categories.inventory, function(a, b)
		return a.category < b.category;
	end);
	
	--Clockwork.plugin:Call("PlayerInventoryRebuilt", self, categories);
	
	if (self.weightForm) then
		self.inventoryList:AddItem(self.weightForm);
	end;

	if (Clockwork.inventory:UseSpaceSystem() and self.spaceForm) then
		self.inventoryList:AddItem(self.spaceForm);
	end;
	
	self.inventoryList:AddItem(self.itemList);

	if (#categories.slotted > 0) then
		for k, v in pairs(categories.slotted) do
			for k2, v2 in SortedPairsByMemberValue(v.itemsList, "name") do
				local slottedPos;
				
				for i = 1, #self.craftingSlotLocations do
					local slot = self.craftingSlotLocations[i];
					
					if !slot.occupier then
						slottedPos = slot;
						break;
					end
				end
				
				if slottedPos then
					local itemData = {
						itemTable = v2, OnPress = function()
							for i = 1, #cwRecipes.slottedItems do
								if cwRecipes.slottedItems[i] == v2.itemID then
									table.remove(cwRecipes.slottedItems, i);
									break;
								end
							end
							
							self:Rebuild();
						end
					};

					self.itemData = itemData;
					self.itemData.condition = v2:GetCondition();
					
					local slottedIcon = vgui.Create("cwRecipeItem", self);
					
					if not table.HasValue(self.slottedIconList, slottedIcon) then
						table.insert(self.slottedIconList, slottedIcon);
					end
					
					if self.itemData.condition and self.itemData.condition < 100 then
						if self.itemData.condition <= 0 then
							slottedIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", slottedIcon.spawnIcon);
							slottedIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
							slottedIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
						else
							slottedIcon.spawnIcon.conditionBar = vgui.Create("DImage", slottedIcon.spawnIcon);
							slottedIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
							slottedIcon.spawnIcon.conditionBar:SetPos(4, 56);
							slottedIcon.spawnIcon.conditionBar:SetSize(56, 6);
							slottedIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", slottedIcon.spawnIcon.conditionBar);
							slottedIcon.spawnIcon.conditionBar.fill:SetType("Rect");
							slottedIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
							slottedIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
							slottedIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
						end
					end
					
					slottedPos.occupier = slottedIcon;
					
					slottedIcon:SetPos(slottedPos.x, slottedPos.y);
					slottedIcon.spawnIcon:Droppable("dropper");
					slottedIcon.spawnIcon:Droppable("inventory");
					slottedIcon.spawnIcon:Droppable("invdummy");
					
					function slottedIcon.spawnIcon.DoRightClick(spawnIcon)
						for i = 1, #cwRecipes.slottedItems do
							if cwRecipes.slottedItems[i] == slottedIcon.itemData.itemTable.itemID then
								table.remove(cwRecipes.slottedItems, i);
								break;
							end
						end
						
						cwRecipes.inventoryPanel:Rebuild();
						return;
					end
				end
			end;
		end;
	end;

	if (#categories.inventory > 0) then
		for k, v in pairs(categories.inventory) do
			local items = {};
			
			for k2, v2 in SortedPairsByMemberValue(v.itemsList, "name") do
				--[[if v2.stackable then
					local amount = Clockwork.inventory:GetItemCountByID(Clockwork.inventory:GetClient(), v2("uniqueID"));
					
					for i = 1, #cwRecipes.inventoryPanel.craftingSlotLocations do
						local slot = cwRecipes.inventoryPanel.craftingSlotLocations[i];
						
						if slot.occupier then
							if slot.occupier.itemData.itemTable.uniqueID == v2.uniqueID then
								amount = math.max(0, amount - 1);
							end
						end
					end
					
					if (!items[v2("uniqueID")]) and amount > 0 then
						local itemData = {
							itemTable = v2,
							amount = amount
						};
						
						self.itemData = itemData;
						--self.itemData.condition = v2:GetCondition(); -- Stackable items should not have condition.
						items[v2("uniqueID")] = true;
						
						local inventoryIcon = vgui.Create("cwRecipeItem", self);
						
						if self.itemData.condition and self.itemData.condition < 100 then
							if self.itemData.condition <= 0 then
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
								inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
								inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
							end
						end

						inventoryIcon.spawnIcon:Droppable("craftingSlot");
						inventoryIcon.spawnIcon:Droppable("dropper");
						inventoryIcon.spawnIcon:Droppable("invdummy");
						
						function inventoryIcon.spawnIcon.DoRightClick(spawnIcon)
							for i = 1, #cwRecipes.inventoryPanel.craftingSlotLocations do
								local slot = cwRecipes.inventoryPanel.craftingSlotLocations[i];
								
								if !slot.occupier then
									table.insert(cwRecipes.slottedItems, inventoryIcon.itemData.itemTable.itemID);
									
									cwRecipes.inventoryPanel:Rebuild();
									return;
								end
							end
						end
						
						self.itemList:AddItem(inventoryIcon);
					end;
				else]]--
					local itemData = {
						itemTable = v2
					};
					self.itemData = itemData;
					self.itemData.amount = 1;
					self.itemData.condition = v2:GetCondition();
					
					local inventoryIcon = vgui.Create("cwRecipeItem", self);
					
					if self.itemData.condition and self.itemData.condition < 100 then
						if self.itemData.condition <= 0 then
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
							inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
							inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
						end
					end
					
					inventoryIcon.spawnIcon:Droppable("craftingSlot");
					inventoryIcon.spawnIcon:Droppable("dropper");
					inventoryIcon.spawnIcon:Droppable("invdummy");
					
					function inventoryIcon.spawnIcon.DoRightClick(spawnIcon)
						for i = 1, #cwRecipes.inventoryPanel.craftingSlotLocations do
							local slot = cwRecipes.inventoryPanel.craftingSlotLocations[i];
							
							if !slot.occupier then
								-- Check to see if the itemID is already inserted. Lag can sometimes cause this.
								if !table.HasValue(cwRecipes.slottedItems, inventoryIcon.itemData.itemTable.itemID) then
									table.insert(cwRecipes.slottedItems, inventoryIcon.itemData.itemTable.itemID);
								end
								
								cwRecipes.inventoryPanel:Rebuild();
								return;
							end
						end
					end
					
					self.itemList:AddItem(inventoryIcon);
				--end;
			end;
			
			self.itemList:SizeToContents();
			self.itemList:EnableHorizontal(true);
			self.itemList:SetAutoSize(true);
			self.itemList:SetPadding(4);
			self.itemList:SetSpacing(4);
		end;
	end;

	self.inventoryList:InvalidateLayout(true);
	
	if Clockwork.menu:GetPanel() then
		hook.Run("PostMainMenuRebuild", Clockwork.menu:GetPanel());
	end
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self:SetSize(740, 748);
	self:SetPos(794, 76);
	self.inventoryList:SetSize(w, 320);
	self.inventoryList:SetPos(0, (self:GetTall() - self.inventoryList:GetTall()));
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwInventoryCrafting", PANEL, "EditablePanel");