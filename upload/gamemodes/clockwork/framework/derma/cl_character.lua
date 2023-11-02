--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local pairs = pairs;
local RunConsoleCommand = RunConsoleCommand;
local SysTime = SysTime;
local ScrH = ScrH;
local ScrW = ScrW;
local table = table;
local string = string;
local vgui = vgui;
local math = math;

local smallTextFont = Clockwork.option:GetFont("menu_text_small");
local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
local hugeTextFont = Clockwork.option:GetFont("menu_text_huge");
local fonts = {tinyTextFont, smallTextFont};

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (!hook.Run("PreCharacterMenuInit", self)) then
		local scrH = ScrH();
		local scrW = ScrW();
		
		self:SetPos(0, 0);
		self:SetSize(scrW, scrH);
		self:SetDrawOnTop(false);
		self:SetPaintBackground(false);
		self:SetMouseInputEnabled(true);
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "NEW VICTIM");
		
		self.createButton = vgui.Create("cwLabelButton", self);
		self.createButton:SetFont(smallTextFont);
		self.createButton:SetText("NEW VICTIM");
		self.createButton.originalText = "NEW VICTIM";
		self.createButton:FadeIn(0.5);
		self.createButton:SetCallback(function(panel)
			if (table.Count(Clockwork.character:GetAll()) >= Clockwork.player:GetMaximumCharacters()) then
				return Clockwork.character:SetFault("You cannot create any more characters!");
			end;
			
			Clockwork.character:ResetCreationInfo();
			Clockwork.character:OpenNextCreationPanel();
			
			--surface.PlaySound("begotten/ui/buttonclick.wav");
		end);
		self.createButton:SizeToContents();
		self.createButton:SetMouseInputEnabled(true);
		self.createButton:SetPos(ScrW() * 0.25 - (newsizew / 2), ScrH() * 0.925);
		
		function self.createButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"NEW VICTIM", "nEw ViCtIm", "NeW vIcTiM"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "VICTIMS");
		
		self.loadButton = vgui.Create("cwLabelButton", self);
		self.loadButton:SetFont(smallTextFont);
		self.loadButton:SetText("VICTIMS");
		self.loadButton.originalText = "VICTIMS";
		self.loadButton:FadeIn(0.5);
		self.loadButton:SetCallback(function(panel)
			self:OpenPanel("cwCharacterList", nil, function(panel)
				Clockwork.character:RefreshPanelList();
			end);
			
			surface.PlaySound("begotten/ui/buttonclick.wav");
		end);
		self.loadButton:SizeToContents();
		self.loadButton:SetMouseInputEnabled(true);
		self.loadButton:SetPos(ScrW() * 0.75 - (newsizew / 2), ScrH() * 0.925);
		
		function self.loadButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"VICTIMS", "vIcTiMs", "ViCtImS"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "RUN IN FEAR");
		
		self.disconnectButton = vgui.Create("cwLabelButton", self);
		self.disconnectButton:SetFont(smallTextFont);
		self.disconnectButton:SetText("RUN IN FEAR");
		self.disconnectButton:FadeIn(0.5);
		self.disconnectButton:SetCallback(function(panel)
			if (Clockwork.Client:HasInitialized() and !Clockwork.character:IsMenuReset()) then
				Clockwork.character:SetPanelMainMenu();
				Clockwork.character:SetPanelOpen(false);
			else
				Derma_Query("Are you sure you want to disconnect?", "Disconnect", "Yes", function()
					Derma_Query("Are you really sure?", "Disconnect", "No, I would like to stay for longer.", function() end, "Yes, disconnect now.", function()
						Derma_Query("Are you sure you don't want to stay?", "Disconnect", "No, I would like to leave now.", function()
							print("okay, bye then!!! bye bye!!!");
							RunConsoleCommand("disconnect");
						end, "Yes, I will stay.", function() end);
					end);
				end, "No", function() end);
			end;
			
			surface.PlaySound("begotten/ui/buttonclick.wav");
		end);
		self.disconnectButton:SizeToContents();
		self.disconnectButton:SetPos((ScrW() / 2) - (newsizew / 2), ScrH() * 0.925);
		self.disconnectButton:SetMouseInputEnabled(true);
		self.disconnectButton.originalText = "RUN IN FEAR";
		
		function self.disconnectButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"RUN IN FEAR", "rUn In FeAr", "RuN iN fEaR"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "PREVIOUS");
		self.previousButton = vgui.Create("cwLabelButton", self);
		self.previousButton:SetFont(smallTextFont);
		self.previousButton:SetText("PREVIOUS");
		self.previousButton:SetCallback(function(panel)
			if (!Clockwork.character:IsCreationProcessActive()) then
				local activePanel = Clockwork.character:GetActivePanel();
				
				if (activePanel and activePanel.OnPrevious) then
					activePanel:OnPrevious();
				end;
			else
				Clockwork.character:OpenPreviousCreationPanel()
			end;
		end);
		self.previousButton:SizeToContents();
		self.previousButton:SetMouseInputEnabled(true);
		self.previousButton:SetPos(ScrW() * 0.25 - (newsizew / 2), ScrH() * 0.925);
		self.previousButton.bStartFaded = true;
		--self.previousButton:SetEnabled(false);
		
		function self.previousButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"PrEvIoUs", "pReViOuS"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "SUFFER");
		self.cancelButton = vgui.Create("cwLabelButton", self);
		self.cancelButton:SetFont(smallTextFont);
		self.cancelButton:SetText("SUFFER");
		self.cancelButton:SetCallback(function(panel)
			Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 1, 1.2);
			
			timer.Simple(1, function()
				if self then
					local activePanel = Clockwork.character:GetActivePanel();
					
					if activePanel then
						activePanel:FadeOut(0.5);
					end
					
					self:ReturnToMainMenu();
					
					timer.Simple(1, function()
						Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 1, 0);
					end);
				end
			end);
		end);
		self.cancelButton:SizeToContents();
		self.cancelButton:SetMouseInputEnabled(true);
		self.cancelButton:SetPos((ScrW() / 2) - (newsizew / 2), ScrH() * 0.925);
		self.cancelButton.bStartFaded = true;
		
		function self.cancelButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"sUfFeR", "SuFfEr"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "NEXT");
		self.nextButton = vgui.Create("cwLabelButton", self);
		self.nextButton:SetFont(smallTextFont);
		self.nextButton:SetText("NEXT");
		
		function self.nextButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"NeXt", "nExT"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;

		self.nextButton:SetCallback(function(panel)
			if (!Clockwork.character:IsCreationProcessActive()) then
				local activePanel = Clockwork.character:GetActivePanel();
				
				if (activePanel and activePanel.OnNext) then
					activePanel:OnNext();
				end;
			else
				Clockwork.character:OpenNextCreationPanel()
			end;
			
			panel.bCooldown = true;
			
			timer.Simple(0.5, function()
				if IsValid(panel) then
					panel.bCooldown = false;
				end
			end);
		end);
		self.nextButton:SizeToContents();
		self.nextButton:SetMouseInputEnabled(true);
		self.nextButton:SetPos(ScrW() * 0.75 - (newsizew / 2), ScrH() * 0.925);
		self.nextButton.bStartFaded = true;
		self.nextButton:SetEnabled(false);
		
		self.characterModel = vgui.Create("cwCharacterModel", self);
		self.characterModel:SetSize(512, 512);
		self.characterModel:SetAlpha(0);
		self.characterModel:SetModel("models/error.mdl");
		self.createTime = SysTime();
		
		hook.Run("PostCharacterMenuInit", self)
	end;
end;

-- A function to fade in the model panel.
function PANEL:FadeInModelPanel(model)
	if (ScrH() < 768) then
		return true;
	end;

	local panel = Clockwork.character:GetActivePanel();
	local x, y = ScrW() - self.characterModel:GetWide() - 8, 16;
	
	if (panel) then
		x, y = panel.x + panel:GetWide() - 16, panel.y - 80;
	end;
	
	self.characterModel:SetPos(x, y);
	
	if (self.characterModel:FadeIn(0.5)) then
		self:SetModelPanelModel(model);
		return true;
	else
		return false;
	end;
end;

-- A function to fade out the model panel.
function PANEL:FadeOutModelPanel()
	self.characterModel:FadeOut(0.5);
end;

-- A function to set the model panel's model.
function PANEL:SetModelPanelModel(model)
	if (self.characterModel.currentModel != model) then
		self.characterModel.currentModel = model;
		self.characterModel:SetModel(model);
	end;
	
	local modelPanel = self.characterModel;
	local weaponModel = Clockwork.plugin:Call(
		"GetModelSelectWeaponModel", model
	);
	local sequence = Clockwork.plugin:Call(
		"GetModelSelectSequence", modelPanel.Entity, model
	);
	
	--[[if (weaponModel) then
		self.characterModel:SetWeaponModel(weaponModel);
	else
		self.characterModel:SetWeaponModel(false);
	end;]]--
	
	if (sequence) then
		modelPanel.Entity:ResetSequence(sequence);
	end;
end;

-- A function to return to the main menu.
function PANEL:ReturnToMainMenu()
	local panel = Clockwork.character:GetActivePanel();

	if (panel) then
		panel:FadeOut(0.5, function()
			Clockwork.character.activePanel = nil;
				panel:Remove();
			self:FadeInTitle();
		end);
	else
		self:FadeInTitle();
	end;
	
	self:FadeOutModelPanel();
	self:FadeOutNavigation();
	
	Clockwork.Client.CurrentGender = GENDER_MALE;
	Clockwork.Client.MenuAngles = nil;
	Clockwork.Client.MenuVector = nil;
	Clockwork.Client.MenuCameraMoving = false;
	Clockwork.Client.ModelSelectionOpen = false;
	Clockwork.Client.SelectedFaction = nil;
	Clockwork.Client.SelectedFaith = nil;
	Clockwork.Client.SelectedSubfaction = nil;
	Clockwork.Client.SelectedModel = nil;
	
	if IsValid(Clockwork.Client.CharSelectionBanner) then
		Clockwork.Client.CharSelectionBanner:Remove();
	end
end;

-- A function to fade out the navigation.
function PANEL:FadeOutNavigation()
	self.previousButton:FadeOut(0.5);
	self.cancelButton:FadeOut(0.5);
	self.nextButton:FadeOut(0.5);

	timer.Simple(0.5, function()
		self.loadButton:FadeIn(0.5);
		self.disconnectButton:FadeIn(0.5);
		self.createButton:FadeIn(0.5);
	end);
end;

-- A function to fade in the navigation.
function PANEL:FadeInNavigation()
	self.createButton:FadeOut(0.5);
	self.disconnectButton:FadeOut(0.5);
	self.loadButton:FadeOut(0.5);

	timer.Simple(0.5, function()
		self.previousButton:FadeIn(0.5);
		self.cancelButton:FadeIn(0.5);
		self.nextButton:FadeIn(0.5);
	end);
end;

-- A function to fade in the navigation.
function PANEL:FadeInCancel()
	self.createButton:FadeOut(0.5);
	self.disconnectButton:FadeOut(0.5);
	self.loadButton:FadeOut(0.5);

	timer.Simple(0.5, function()
		self.previousButton:FadeIn(0.5);
		self.cancelButton:FadeIn(0.5);
		self.nextButton:FadeIn(0.5);
	end);
end;

-- A function to fade in the navigation.
function PANEL:FadeOutAll()
	self.createButton:FadeOut(0.5);
	self.disconnectButton:FadeOut(0.5);
	self.loadButton:FadeOut(0.5);
	self.previousButton:FadeOut(0.5);
	self.cancelButton:FadeOut(0.5);
	self.nextButton:FadeOut(0.5);
end;

-- A function to fade out the title.
function PANEL:FadeOutTitle() end;

-- A function to fade in the title.
function PANEL:FadeInTitle() end;

-- A function to open a panel.
function PANEL:OpenPanel(vguiName, childData, Callback)
	if (!hook.Run("PreCharacterMenuOpenPanel", self, vguiName, childData, Callback)) then
		local panel = Clockwork.character:GetActivePanel();
		
		--local x, y = ScrW() * 0.2, ScrH() * 0.2;
		local x, y = 128 + 64, ScrH() * 0.2;
		
		--if (vguiName == "cwCharacterList") then
			--x, y = ScrW() * 0.3, ScrH() * 0.2;
			--x, y = 128 + 64, ScrH() * 0.2;
		--end;
		
		if (panel) then
			panel:FadeOut(0.5, function()
				panel:Remove(); self.childData = childData;
				
				Clockwork.character.activePanel = vgui.Create(vguiName, self);
				Clockwork.character.activePanel:SetAlpha(0);
				Clockwork.character.activePanel:FadeIn(0.5);
				Clockwork.character.activePanel:MakePopup();

				Clockwork.character.activePanel:SetPos(x, y);
				
				if (Callback) then
					Callback(Clockwork.character.activePanel);
				end;
				
				if (childData) then
					Clockwork.character.activePanel.bIsCreationProcess = true;
					Clockwork.character:FadeInNavigation();
				end;
			end);
		else
			self.childData = childData;
			self:FadeOutTitle();
			
			Clockwork.character.activePanel = vgui.Create(vguiName, self);
			Clockwork.character.activePanel:SetAlpha(0);
			
			--if vguiName ~= "cwCharacterList" then
				--[[timer.Simple(2, function()
					if (Clockwork.character.activePanel) then
						Clockwork.character.activePanel:FadeIn(0.5);
					end
				end);]]--
			--else
				Clockwork.character.activePanel:FadeIn(0.5);
			--end
				
			Clockwork.character.activePanel:MakePopup();
			Clockwork.character.activePanel:SetPos(x, y);
			
			if (Callback) then
				Callback(Clockwork.character.activePanel);
			end;
			
			if (childData) then
				Clockwork.character.activePanel.bIsCreationProcess = true;
				Clockwork.character:FadeInNavigation();
			end;
		end;
		
		--[[ Fade out the model panel, we probably don't need it now! --]]
		self:FadeOutModelPanel();
		
		hook.Run("PostCharacterMenuOpenPanel", self);
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	if (!hook.Run("PreCharacterMenuPaint", self)) then
		hook.Run("PostCharacterMenuPaint", self)
	end;
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	if (!hook.Run("PreCharacterMenuThink", self)) then
		local characters = table.Count(Clockwork.character:GetAll());
		local bIsLoading = Clockwork.character:IsPanelLoading();
		local schemaLogo = Clockwork.option:GetKey("schema_logo");
		local activePanel = Clockwork.character:GetActivePanel();
		local fault = Clockwork.character:GetFault();

		if (self.characterModel) then
			if (!self.characterModel.currentModel
			or self.characterModel.currentModel == "models/error.mdl") then
				self.characterModel:SetAlpha(0);
			end;
		end;
		
		if (!Clockwork.character:IsCreationProcessActive()) then
			if (activePanel) then
				if (activePanel.GetNextDisabled
				and activePanel:GetNextDisabled()) then
					self.nextButton:SetDisabled(true);
				else
					self.nextButton:SetDisabled(false);
				end;
				
				--[[if (activePanel.GetPreviousDisabled and activePanel:GetPreviousDisabled()) then
					self.previousButton:SetDisabled(true);
				else
					self.previousButton:SetDisabled(false);
				end;]]--
			end;
		else
			local previousPanelInfo = Clockwork.character:GetPreviousCreationPanel();
			
			--[[if (previousPanelInfo) then
				self.previousButton:SetDisabled(false);
			else
				self.previousButton:SetDisabled(true);
			end;]]--
			
			if self.nextButton.bCooldown then
				self.nextButton:SetDisabled(true);
			else
				self.nextButton:SetDisabled(false);
			end
		end;

		if (IsValid(self.loadButton)) then
			if (characters == 0 or bIsLoading) then
				self.loadButton:SetDisabled(true);
			else
				self.loadButton:SetDisabled(false);
			end;
		end;
		
		if (IsValid(self.createButton)) then
			if (--[[characters >= Clockwork.player:GetMaximumCharacters() or ]]Clockwork.character:IsPanelLoading()) then
				self.createButton:SetDisabled(true);
			else
				self.createButton:SetDisabled(false);
			end;
		end;
		
		if (IsValid(self.disconnectButton)) then
			local smallTextFont = Clockwork.option:GetFont("menu_text_small");
			
			if (Clockwork.Client:HasInitialized() and !Clockwork.character:IsMenuReset()) then
				self.disconnectButton:SetText("SUFFER");
				local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "SUFFER");
				self.disconnectButton:SetPos((ScrW() / 2) - (newsizew / 2), ScrH() * 0.925);
				self.disconnectButton:SizeToContents();
			else
				self.disconnectButton:SetText("RUN IN FEAR");
				local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "RUN IN FEAR");
				self.disconnectButton:SetPos((ScrW() / 2) - (newsizew / 2), ScrH() * 0.925);
				self.disconnectButton:SizeToContents();
			end;
		end;
		
		if (self.animation) then
			self.animation:Run();
		end;
		
		self:SetSize(ScrW(), ScrH());
		
		hook.Run("PostCharacterMenuThink", self)
	end;
end;

vgui.Register("cwCharacterMenu", PANEL, "DPanel");

--[[
	Add a hook to control clicking outside of the active panel.
--]]

hook.Add("VGUIMousePressed", "Clockwork.character:VGUIMousePressed", function(panel, code)
	local characterPanel = Clockwork.character:GetPanel();
	local activePanel = Clockwork.character:GetActivePanel();
	
	if (Clockwork.character:IsPanelOpen() and activePanel
	and characterPanel == panel) then
		activePanel:MakePopup();
	end;
end);

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	Clockwork.character:FadeOutAll();
	
	self.uniqueID = "cwCharacterList";
	self.characterForms = {};
	self.isCharacterList = true;
	
	self:SetTitle("");
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
 	self.panelList:SetDrawBackground(false);
	self.panelList:SetNoSizing(true);
	--self.panelList:EnableHorizontal(true);
	--self.panelList:EnableVerticalScrollbar();
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h) end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			--[[for i = 1, #self.characterForms do
				self.characterForms[i].characterModel.modelPanel:SetColor(Color(255, 255, 255, 255 - (delta * 255)));
			end]]--
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
	elseif (Callback) then
		Callback();
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(delta * 255);
			
			--[[for i = 1, #self.characterForms do
				self.characterForms[i].characterModel.modelPanel:SetColor(Color(255, 255, 255, delta * 255));
			end]]--
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
	elseif (Callback) then
		Callback();
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	--self:SetSize(math.min(Clockwork.character:GetListWidth(), ScrW() - 32), math.min(self.panelList:GetTall() + 8, ScrH() * 0.6));
	self:SetSize(ScrW(), ScrH());
	self:SetPos(0, 0);
	self.panelList:SetSize(ScrW(), 750);
	self.panelList:SetPos(0, (ScrH() / 2) - 375);
end;

vgui.Register("cwCharacterList", PANEL, "DFrame");


local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.customData = self:GetParent().customData;
	local factionTable = Clockwork.faction:FindByID(self.customData.faction);
	local bodygroup = 0;
	local bodygroupVal = 0;
	local model = self.customData.model;
	local headModel;
	local faithText = self.customData.faith;
	local subfaith = self.customData.subfaith;
	local clothes = self.customData.clothes;
	local helmet = self.customData.helmet;
	local weapons = self.customData.weapons;
	local attachments = {};
	
	if clothes then
		if clothes.uniqueID and clothes.itemID then
			local item = Clockwork.item:FindByID(clothes.uniqueID, clothes.itemID);
			
			if item and item.GetClientSideModel then
				local newModel = item:GetClientSideModel(model, self.customData.gender);
				
				if newModel then
					model = newModel;
				end
			end
		end
	end
	
	if string.find(model, "models/begotten/heads") then
		headModel = model;
		
		if clothes then
			if clothes.uniqueID and clothes.itemID then
				local item = Clockwork.item:FindByID(clothes.uniqueID, clothes.itemID);
				
				if item and item.group then
					if item.genderless then
						model = "models/begotten/"..item.group..".mdl";
					else
						model = "models/begotten/"..item.group.."_"..string.lower(self.customData.gender)..".mdl";
					end
				end
			end
		else
			local factionTableOverride = factionTable;
			
			if self.customData.kinisgerOverride then
				factionTableOverride = Clockwork.faction:FindByID(self.customData.kinisgerOverride);
			end
			
			if factionTableOverride then
				model = factionTableOverride.models[string.lower(self.customData.gender)].clothes;
			
				local subfaction = self.customData.kinisgerOverrideSubfaction or self.customData.subfaction;
				
				if subfaction and factionTableOverride.subfactions then
					for i, v in ipairs(factionTableOverride.subfactions) do
						if v.models and v.name == subfaction then
							model = v.models[string.lower(self.customData.gender)].clothes;
							
							break;
						end
					end
				end
			end
		end
	end
	
	if helmet then
		if helmet.uniqueID and helmet.itemID then
			local item = Clockwork.item:FindByID(helmet.uniqueID, helmet.itemID);
			
			if item and item.bodyGroup and item.bodyGroupVal then
				bodygroup = item.bodyGroup;
				bodygroupVal = item.bodyGroupVal;
			end
		end
	end

	if weapons and not table.IsEmpty(weapons) then
		for i = 1, 6 do
			local weapon = weapons[i];

			if weapon and weapon.uniqueID and weapon.itemID then
				local item = Clockwork.item:FindByID(weapon.uniqueID, weapon.itemID);
				
				if item and item.isAttachment then
					local attachment = {};
					local attachmentBone = item.attachmentBone;
					local offsetAngle = item.attachmentOffsetAngles;
					local offsetVector = item.attachmentOffsetVector;
					
					if item.slots and i > #item.slots then
						-- Offhand
						if string.find(attachmentBone, "_L_") then
							attachmentBone = string.gsub(attachmentBone, "_L_", "_R_");
						else
							attachmentBone = string.gsub(attachmentBone, "_R_", "_L_");
						end
						
						offsetVector = Vector(-offsetVector.x, offsetVector.y, offsetVector.z);
						offsetAngle = Angle(-offsetAngle.pitch, offsetAngle.yaw, offsetAngle.roll);
					end
				
					attachment.attachmentInfo = {};
					attachment.attachmentInfo.attachmentModel = item.model;
					attachment.attachmentInfo.attachmentBone = attachmentBone;
					attachment.attachmentInfo.attachmentOffsetAngles = offsetAngle;
					attachment.attachmentInfo.attachmentOffsetVector = offsetVector;
					attachment.attachmentInfo.attachmentSkin = item.attachmentSkin;
					attachment.attachmentInfo.bodygroup0 = item.bodygroup0;
					attachment.attachmentInfo.bodygroup1 = item.bodygroup1;
					attachment.attachmentInfo.bodygroup2 = item.bodygroup2;
					attachment.attachmentInfo.bodygroup3 = item.bodygroup3;
					
					table.insert(attachments, attachment);
				end
			end
		end
	end
	
	if subfaith and subfaith ~= "" and subfaith ~= "N/A" then
		faithText = subfaith;
	end

	self:SetSize(374, 654);
	self.buttonPanels = {};
	
	self.characterFrame = vgui.Create("DImage", self);
	self.characterFrame:SetImage("begotten/ui/charactermenu/characterframe.png");
	self.characterFrame:SetSize(374, 600);
	
	self.characterFrameBanner = vgui.Create("DImage", self);
	self.characterFrameBanner:SetImage("begotten/ui/charactermenu/characterframebanner.png");
	self.characterFrameBanner:SetSize(374, 600);
	
	if factionTable.color then
		self.characterFrameBanner:SetImageColor(factionTable.color);
	else
		self.characterFrameBanner:SetImageColor(Color(255, 255, 255));
	end
	
	self.characterFrameFactionLogo = vgui.Create("DImage", self);
	self.characterFrameFactionLogo:SetImage("begotten/ui/charactermenu/"..self.customData.faction..".png");
	self.characterFrameFactionLogo:SetSize(200, 200);
	self.characterFrameFactionLogo:SetPos(80, 96);
	
	self.characterModel = vgui.Create("cwCharacterModel", self);
	self.characterModel:SetPos(4, 70);
	self.characterModel:SetSize(366, 526);

	self.characterModel.attachments = attachments;
	self.characterModel:SetModelNew(model);
	
	if IsValid(self.characterModel.modelPanel.Entity) then
		if headModel then
			self.characterModel.modelPanel.headModel = ClientsideModel(headModel, RENDERGROUP_OPAQUE);
			
			if IsValid(self.characterModel.modelPanel.headModel) then
				self.characterModel.modelPanel.headModel.noDelete = true;
				self.characterModel.modelPanel.headModel:SetParent(self.characterModel.modelPanel.Entity);
				self.characterModel.modelPanel.headModel:AddEffects(EF_BONEMERGE);
				self.characterModel.modelPanel.headModel:SetBodygroup(bodygroup, bodygroupVal);
				self.characterModel.modelPanel.headModel:SetSkin(self.customData.skin or 0);
			end
		else
			self.characterModel.modelPanel.Entity:SetBodygroup(bodygroup, bodygroupVal);
			self.characterModel.modelPanel.Entity:SetSkin(self.customData.skin or 0);
		end
	end
	
	local charName = self.customData.name or "Unknown Name";
	local ranks = Schema.Ranks;
	
	if ranks then
		if (ranks[factionTable.name]) then
			local charRank = self.customData.charTable.rank;
			
			if !charRank then
				local factionTable = Clockwork.faction:FindByID(self.customData.faction);
				local subfaction = self.customData.subfaction;
				local subfactionRankFound = false;
				
				if subfaction and subfaction ~= "" and subfaction ~= "N/A" then
					if factionTable and factionTable.subfactions then
						for i = 1, #factionTable.subfactions do
							local isubfaction = factionTable.subfactions[i];
							
							if isubfaction.name == subfaction then
								if isubfaction.startingRank then
									charRank = isubfaction.startingRank;
									subfactionRankFound = true;
									
									break;
								end
							end
						end
					end
				end
				
				if !subfactionRankFound then
					charRank = 1;
				end
			end
			
			local rankText = ranks[factionTable.name][charRank];
			
			if rankText then
				charName = rankText.." "..charName;
			end
		end
	end
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetText(charName);
	self.nameLabel:SetTextColor(Color(200, 20, 20));
	self.nameLabel:SetFont("nov_IntroTextSmallDETrooper");
	self.nameLabel:SizeToContents();
	self.nameLabel:SetPos(187 - (self.nameLabel:GetWide() / 2), 2);
	
	self.faithLabel = vgui.Create("DLabel", self);
	self.faithLabel:SetText("Faith: "..faithText);
	self.faithLabel:SetTextColor(Color(160, 145, 145));
	self.faithLabel:SetFont("Decay_FormText");
	self.faithLabel:SetPos(16, 26);
	self.faithLabel:SetSize(180, 18);
	
	self.locationLabel = vgui.Create("DLabel", self);
	self.locationLabel:SetTextColor(Color(160, 145, 145));
	self.locationLabel:SetFont("Decay_FormText");
	self.locationLabel:SetPos(16, 48);
	self.locationLabel:SetSize(180, 18);
	
	if self.customData then
		local zones_to_names = {
			["caves"] = "Mines",
			["gore"] = "Gore Forest",
			["gore_tree"] = "Gore Forest",
			["gore_hallway"] = "Gore Forest",
			["hell"] = "Hell",
			["manor"] = "Hell",
			["scrapper"] = "Scrap Factory",
			["toothboy"] = "His Chamber",
			["tower"] = "Tower of Light",
			["wasteland"] = "Wasteland"
		};
		
		local zoneName = zones_to_names[self.customData.location] or "Unknown";
		
		self.locationLabel:SetText("Location: "..zoneName);
	else
		self.locationLabel:SetText("Location: Unknown");
	end
	
	self.sacramentsLabel = vgui.Create("DLabel", self);
	self.sacramentsLabel:SetText("Sacrament Level: "..self.customData.level);
	self.sacramentsLabel:SetTextColor(Color(160, 145, 145));
	self.sacramentsLabel:SetFont("Decay_FormText");
	self.sacramentsLabel:SetPos(196, 26);
	self.sacramentsLabel:SetSize(180, 18);
	
	self.timeSurvivedLabel = vgui.Create("DLabel", self);
	self.timeSurvivedLabel:SetTextColor(Color(160, 145, 145));
	self.timeSurvivedLabel:SetFont("Decay_FormText");
	self.timeSurvivedLabel:SetPos(196, 48);
	self.timeSurvivedLabel:SetSize(180, 18);
	
	if self.customData.timesurvived then
		--self.timeSurvivedLabel:SetText("Time Survived: "..tostring(os.date("!%X", self.customData.timesurvived)));
		--self.timeSurvivedLabel:SetText("Time Survived: "..string.FormattedTime(self.customData.timesurvived, "%02i:%02i:%02i"));
		self.timeSurvivedLabel:SetText("Time Survived: "..FormattedPlayTime(self.customData.timesurvived, "%02i:%02i:%02i"));
	else
		self.timeSurvivedLabel:SetText("Time Survived: 00:00:00");
	end
	
	local buttonMaterial = Material("begotten/ui/buttonrecolored.png")
	
	self.useButton = vgui.Create("DButton", self);
	self.useButton:SetSize(185, 50);
	self.useButton:SetPos(1, 602);
	self.useButton:SetText("Possess");
	self.useButton:SetTextColor(Color(70, 80, 45));
	self.useButton:SetFont("nov_IntroTextSmallfaaaaa")
	--self.useButton:SetFont("nov_IntroTextSmallaaafaa")
	
	self.deleteButton = vgui.Create("DButton", self);
	self.deleteButton:SetSize(185, 50);
	self.deleteButton:SetPos(188, 602);
	self.deleteButton:SetText("Sacrifice");
	self.deleteButton:SetTextColor(Color(100, 25, 25));
	self.deleteButton:SetFont("nov_IntroTextSmallfaaaaa")
	--self.deleteButton:SetFont("nov_IntroTextSmallaaafaa")

	Clockwork.plugin:Call(
		"GetCustomCharacterButtons", self.customData.charTable, buttonsList
	);
	
	-- Called when the button is clicked.
	function self.useButton.DoClick()
		Clockwork.datastream:Start("InteractCharacter", {
			characterID = self.customData.characterID, action = "use"}
		);
		
		surface.PlaySound("begotten/ui/buttonclick.wav");
	end;
	
	function self.useButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(buttonMaterial);
		surface.DrawTexturedRect(0, 0, 185, 50);
	end
	
	-- Called when the button is clicked.
	function self.deleteButton.DoClick()
		Clockwork.kernel:AddMenuFromData(nil, {
			["Yes"] = function()
				Clockwork.datastream:Start("InteractCharacter", {
					characterID = self.customData.characterID, action = "delete"}
				);
			end,
			["No"] = function() end
		});
		
		surface.PlaySound("begotten/ui/buttonclick.wav");
	end;
	
	function self.deleteButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(buttonMaterial);
		surface.DrawTexturedRect(0, 0, 185, 50);
	end
end;

vgui.Register("cwCharacterPanel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetPaintBackground(false);
	
	self.modelPanel = vgui.Create("DModelPanel", self);
	self.modelPanel:SetAmbientLight(Color(0, 0, 0, 0));
	self.modelPanel:SetDirectionalLight(BOX_TOP, Color(250, 220, 220))
	self.modelPanel:SetDirectionalLight(BOX_FRONT, Color(250, 220, 220))
	self.modelPanel:SetMouseInputEnabled(false);
		
	function self.modelPanel.DrawModel(modelPanel)
		local modelPanelParent = modelPanel:GetParent();
		local curparent = modelPanel;
		local rightx = modelPanel:GetWide();
		local leftx = 0;
		local topy = 0;
		local bottomy = modelPanel:GetTall();
		local previous = curparent;
		
		while( curparent:GetParent() != nil ) do
			curparent = curparent:GetParent()
			local x, y = previous:GetPos()
			topy = math.Max( y, topy + y )
			leftx = math.Max( x, leftx + x )
			bottomy = math.Min( y + previous:GetTall(), bottomy + y )
			rightx = math.Min( x + previous:GetWide(), rightx + x )
			previous = curparent
		end
		
		render.SetScissorRect( leftx, topy, rightx, bottomy, true )
		modelPanel.Entity:DrawModel();
		
		if modelPanel.headModel and IsValid(modelPanel.headModel) then
			modelPanel.headModel:DrawModel();
		end
		
		if modelPanelParent.attachmentEntities then
			for i, v in ipairs(modelPanelParent.attachmentEntities) do 
				if IsValid(v) then
					v:DrawModel();
				end
			end
		end
		
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
	
	-- Called when the entity should be laid out.
	function self.modelPanel.LayoutEntity(modelPanel, entity)
		local modelPanelParent = modelPanel:GetParent();
		
		modelPanel:RunAnimation();

		if modelPanelParent.attachments then
			for i, v in ipairs(modelPanelParent.attachments) do 
				local attachmentInfo = v.attachmentInfo;
				
				if attachmentInfo then
					local bone = modelPanel.Entity:LookupBone(attachmentInfo.attachmentBone);
					
					if bone then
						local position, angles = modelPanel.Entity:GetBonePosition(bone);
						
						local x = angles:Up() * attachmentInfo.attachmentOffsetVector.x
						local y = angles:Right() * attachmentInfo.attachmentOffsetVector.y
						local z = angles:Forward() * attachmentInfo.attachmentOffsetVector.z

						angles:RotateAroundAxis(angles:Forward(), attachmentInfo.attachmentOffsetAngles.p)
						angles:RotateAroundAxis(angles:Right(), attachmentInfo.attachmentOffsetAngles.y)
						angles:RotateAroundAxis(angles:Up(), attachmentInfo.attachmentOffsetAngles.r)
						
						local attachmentEnt = modelPanelParent.attachmentEntities[i];
						
						if IsValid(attachmentEnt) then
							attachmentEnt:SetPos(position + x + y + z);
							attachmentEnt:SetAngles(angles);
						end
					end
				end
			end
		end
	end;
end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
				
				if panel.modelPanel and IsValid(panel.modelPanel.Entity) then
					panel.modelPanel.Entity:Remove();
				end
				
				if panel.modelPanel and IsValid(panel.modelPanel.headModel) then
					panel.modelPanel.headModel:Remove();
				end
				
				if self.attachmentEntities then
					for i, v in ipairs(panel.attachmentEntities) do
						if IsValid(v) then
							v:Remove();
						end;
					end
				end
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		--surface.PlaySound("begotten/ui/buttonrollover.wav");
		
		return true;
	else
		self:SetAlpha(0);
		self:SetVisible(false);
		
		if self.modelPanel and IsValid(self.modelPanel.Entity) then
			self.modelPanel.Entity:Remove();
		end
		
		if self.modelPanel and IsValid(self.modelPanel.headModel) then
			self.modelPanel.headModel:Remove();
		end
		
		if self.attachmentEntities then
			for i, v in ipairs(self.attachmentEntities) do
				if IsValid(v) then
					v:Remove();
				end;
			end;
		end
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		--surface.PlaySound("begotten/ui/buttonclickrelease.wav");
		self:SetVisible(true);
		
		return true;
	else
		self:SetVisible(true);
		self:SetAlpha(255); 
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to set the alpha of the panel.
function PANEL:SetAlpha(alpha)
	local color = self.modelPanel:GetColor();
	self.modelPanel:SetColor(Color(color.r, color.g, color.b, alpha));
end;

-- A function to get the alpha of the panel.
function PANEL:GetAlpha(alpha)
	local color = self.modelPanel:GetColor();
	
	return color.a;
end;

-- Called each frame.
function PANEL:Think()
	local entity = self.modelPanel.Entity;
	
	if (IsValid(entity)) then
		entity:SetPos(Vector(0, 0, 0));
	end;
	
	if (self.animation) then
		self.animation:Run();
	end;
	
	if (IsValid(entity)) then
		entity:ClearPoseParameters();
	end
	
	self:InvalidateLayout(true);
end;

-- A function to get the panel's model panel.
function PANEL:GetModelPanel()
	return self.modelPanel;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.modelPanel:SetSize(w, h);
end;

function PANEL:OnRemove()
	if self.modelPanel and IsValid(self.modelPanel.Entity) then
		self.modelPanel.Entity:Remove();
	end
	
	if self.modelPanel and IsValid(self.modelPanel.headModel) then
		self.modelPanel.headModel:Remove();
	end

	for i, v in ipairs(self.attachmentEntities) do
		if IsValid(v) then
			v:Remove();
		end;
	end;
end

-- A function to set the model details.
function PANEL:SetDetails(details)
	self.modelPanel:SetMarkupToolTip(details);
end;

-- A function to set the model weapon.
--[[function PANEL:SetWeaponModel(weaponModel)
	if (!weaponModel and IsValid(self.weaponEntity)) then
		self.weaponEntity:Remove();
		return;
	end;
	
	if (!weaponModel and !IsValid(self.weaponEntity)
	or IsValid(self.weaponEntity) and self.weaponEntity:GetModel() == weaponModel) then
		return;
	end;
	
	if (IsValid(self.weaponEntity)) then
		self.weaponEntity:Remove();
	end;
	
	self.weaponEntity = ClientsideModel(weaponModel, RENDER_GROUP_OPAQUE_ENTITY);
	self.weaponEntity:SetParent(self.modelPanel.Entity);
	self.weaponEntity:AddEffects(EF_BONEMERGE);
end;]]--

-- A function to set the model.
function PANEL:SetModel(model)
	self.modelPanel:SetModel(model);
	
	local entity = ents.CreateClientProp("models/error.mdl");
		entity:SetAngles(Angle(0, 0, 0));
		entity:SetPos(Vector(0, 0, 0));
		entity:SetModel(model);
		entity:Spawn();
		entity:Activate();
	entity:PhysicsInit(SOLID_VPHYSICS);
	
	local obbCenter = entity:OBBCenter();
		obbCenter.z = obbCenter.z * 1.09;
	local distance = entity:BoundingRadius() * 1.2;
	
	self.modelPanel:SetFOV(90)
	
	self.modelPanel:SetLookAt(obbCenter)
	self.modelPanel:SetCamPos(obbCenter + Vector(distance * 1.56, distance * 0.31, distance * 0.4));
	
	entity:Remove();
	
	if (IsValid(self.modelPanel.Entity)) then
		local sequence = self.modelPanel.Entity:LookupSequence("idle");
		local menuSequence = Clockwork.animation:GetMenuSequence(model, true);
		local leanBackAnims = {"LineIdle01", "LineIdle02", "LineIdle03"};
		local leanBackAnim = self.modelPanel.Entity:LookupSequence(
			leanBackAnims[math.random(1, #leanBackAnims)]
		);
		
		if (leanBackAnim > 0) then
			sequence = leanBackAnim;
		end;
		
		if (menuSequence) then
			menuSequence = self.modelPanel.Entity:LookupSequence(menuSequence);
			
			if (menuSequence > 0) then
				sequence = menuSequence;
			end;
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("idle_unarmed");
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("idle1");
		end;
		
		if (sequence <= 0) then
			sequence = self.modelPanel.Entity:LookupSequence("walk_all");
		end;
		
		self.modelPanel.Entity:ResetSequence(sequence);
	end;
end;

function PANEL:SetModelNew(model, skin)
	self.modelPanel:SetModel(model);
	
	if IsValid(self.modelPanel.Entity) then
		if skin then
			self.modelPanel.Entity:SetSkin(skin);
		end
		
		self.modelPanel.Entity:SetRenderMode(1)
	end

	local obbCenter = Vector(-6, 0, 40);
	
	self.modelPanel:SetFOV(42)
	self.modelPanel:SetLookAt(obbCenter)
	self.modelPanel:SetCamPos(obbCenter + Vector(92, 0, 0));
	--self.modelPanel:SetAmbientLight(Color(255,255,255,50))
	
	if (IsValid(self.modelPanel.Entity)) then
		local sequence = self.modelPanel.Entity:LookupSequence("idle_angry");
		
		self.modelPanel.Entity:ResetSequence(sequence);
		self.modelPanel.Entity:SetCycle(math.Rand(0, 1)); -- Desynchronize animations so all the chars don't sway the same way.
		self.modelPanel.Entity.noDelete = true;
		
		if !self.attachmentEntities then
			self.attachmentEntities = {};
		end
		
		for i, v in ipairs(self.attachmentEntities) do
			if IsValid(v) then
				v:Remove();
			end;
		end;
			
		if self.attachments then
			for i, v in ipairs(self.attachments) do
				local attachmentInfo = v.attachmentInfo;
				
				if attachmentInfo then
					local attachmentEntity = ClientsideModel(attachmentInfo.attachmentModel, RENDER_GROUP_OPAQUE_ENTITY);
					
					if IsValid(attachmentEntity) then
						attachmentEntity:SetParent(self.modelPanel.Entity);
						attachmentEntity:AddEffects(EF_BONEMERGE);
						attachmentEntity:SetNoDraw(true);
						attachmentEntity.noDelete = true;
						
						if attachmentInfo.attachmentSkin then
							attachmentEntity:SetSkin(attachmentInfo.attachmentSkin);
						end
						
						if attachmentInfo.bodygroup0 then
							attachmentEntity:SetBodygroup(0, attachmentInfo.bodygroup0 - 1);
						end
						
						if attachmentInfo.bodygroup1 then
							attachmentEntity:SetBodygroup(0, attachmentInfo.bodygroup1 - 1);
						end
						
						if attachmentInfo.bodygroup2 then
							attachmentEntity:SetBodygroup(1, attachmentInfo.bodygroup2 - 1);
						end
						
						if attachmentInfo.bodygroup3 then
							attachmentEntity:SetBodygroup(2, attachmentInfo.bodygroup3 - 1);
						end
						
						self.attachmentEntities[i] = attachmentEntity;
					end
				end
			end
		end
	end;
end
	
vgui.Register("cwCharacterModel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local parent = self:GetParent();
	self.customData = parent.customData;
	local factionTable = Clockwork.faction:FindByID(self.customData.faction);
	
	local model = self.customData.model;
	local skin = self.customData.skin;
	local bodygroup1;
	local bodygroup2;
	local necropolisData = self.customData.charTable.necropolisData;
	
	if necropolisData then
		model = necropolisData.model or model;
		skin = necropolisData.skin or skin;
		bodygroup1 = necropolisData.playerBodygroups[1];
		bodygroup2 = necropolisData.playerBodygroups[2];
	end

	self:SetSize(666, 150);
	self.buttonPanels = {};
	
	self.characterFrame = vgui.Create("DImage", self);
	self.characterFrame:SetImage("begotten/ui/charactermenu/necropolisframe.png");
	self.characterFrame:SetSize(666, 150);
	
	self.charImage = vgui.Create("ModelImage", self);
	self.charImage:SetModel(model, skin, tostring(bodygroup1 or 0)..tostring(bodygroup2 or 0).."0000000");
	self.charImage:SetSize(80, 80);
	self.charImage:SetPos(24, 24);
	
	self.charImageFrame = vgui.Create("DImage", self);
	self.charImageFrame:SetImage("begotten/ui/charactermenu/necropolischaracterframe.png");
	self.charImageFrame:SetSize(86, 86);
	self.charImageFrame:SetPos(21, 21);
	
	local charName = self.customData.name or "Unknown Name";
	local ranks = Schema.Ranks;
	
	if ranks then
		if (ranks[factionTable.name]) then
			local charRank = self.customData.charTable.rank or 1;
			local rankText = ranks[factionTable.name][charRank];
			
			if rankText then
				charName = rankText.." "..charName;
			end
		end
	end
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetText(charName);
	self.nameLabel:SetTextColor(Color(200, 20, 20));
	self.nameLabel:SetFont("nov_IntroTextSmallDETrooper");
	self.nameLabel:SizeToContents();
	self.nameLabel:SetPos(128, 12);
	
	self.factionLabel = vgui.Create("DLabel", self);
	self.factionLabel:SetText("Faction: "..self.customData.faction);
	self.factionLabel:SetTextColor(Color(160, 145, 145));
	self.factionLabel:SetFont("Decay_FormText");
	self.factionLabel:SetPos(128, 36);
	self.factionLabel:SetSize(180, 18);
	
	self.subfactionLabel = vgui.Create("DLabel", self);
	self.subfactionLabel:SetText("Subfaction: "..self.customData.subfaction);
	self.subfactionLabel:SetTextColor(Color(160, 145, 145));
	self.subfactionLabel:SetFont("Decay_FormText");
	self.subfactionLabel:SetPos(128, 58);
	self.subfactionLabel:SetSize(180, 18);
	
	self.faithLabel = vgui.Create("DLabel", self);
	self.faithLabel:SetText("Faith: "..self.customData.faith);
	self.faithLabel:SetTextColor(Color(160, 145, 145));
	self.faithLabel:SetFont("Decay_FormText");
	self.faithLabel:SetPos(128, 80);
	self.faithLabel:SetSize(180, 18);

	self.sacramentsLabel = vgui.Create("DLabel", self);
	self.sacramentsLabel:SetText("Sacrament Level: 1");
	self.sacramentsLabel:SetTextColor(Color(160, 145, 145));
	self.sacramentsLabel:SetFont("Decay_FormText");
	self.sacramentsLabel:SetPos(348, 36);
	self.sacramentsLabel:SetSize(180, 18);
	self.sacramentsLabel:SetText("Sacrament Level: "..self.customData.level);
	
	self.timeSurvivedLabel = vgui.Create("DLabel", self);
	self.timeSurvivedLabel:SetTextColor(Color(160, 145, 145));
	self.timeSurvivedLabel:SetFont("Decay_FormText");
	self.timeSurvivedLabel:SetPos(348, 58);
	self.timeSurvivedLabel:SetSize(180, 18);
	
	if self.customData.timesurvived then
		--self.timeSurvivedLabel:SetText("Time Survived: "..tostring(os.date("!%X", self.customData.timesurvived)));
		--self.timeSurvivedLabel:SetText("Time Survived: "..string.FormattedTime(self.customData.timesurvived, "%02i:%02i:%02i"));
		self.timeSurvivedLabel:SetText("Time Survived: "..FormattedPlayTime(self.customData.timesurvived, "%02i:%02i:%02i"));
	else
		self.timeSurvivedLabel:SetText("Time Survived: 00:00:00");
	end
	
	self.killsLabel = vgui.Create("DLabel", self);
	self.killsLabel:SetText("Kills: "..self.customData.kills);
	self.killsLabel:SetTextColor(Color(160, 145, 145));
	self.killsLabel:SetFont("Decay_FormText");
	self.killsLabel:SetPos(348, 80);
	self.killsLabel:SetSize(180, 18);
	
	self.deathCauseLabel = vgui.Create("DLabel", self);
	
	if self.customData.deathcause and self.customData.deathcause ~= "" then
		self.deathCauseLabel:SetText(self.customData.deathcause);
	else
		self.deathCauseLabel:SetText("Died under mysterious circumstances.");
	end
	
	self.deathCauseLabel:SetTextColor(Color(200, 150, 150));
	self.deathCauseLabel:SetFont("Decay_FormText");
	self.deathCauseLabel:SizeToContents();
	self.deathCauseLabel:SetPos((self.characterFrame:GetWide() / 2) - self.deathCauseLabel:GetWide() / 2, 117);
	
	local buttonMaterial = Material("begotten/ui/buttonrecolored.png")
	
	if Clockwork.Client:IsAdmin() then
		self.unPermakillButton = vgui.Create("DButton", self);
		self.unPermakillButton:SetSize(120, 50);
		self.unPermakillButton:SetPos(542, 23);
		self.unPermakillButton:SetText("Restore");
		self.unPermakillButton:SetTextColor(Color(70, 80, 45));
		self.unPermakillButton:SetFont("nov_IntroTextSmallaaafaa")
		
		-- Called when the button is clicked.
		function self.unPermakillButton.DoClick()
			Clockwork.datastream:Start("UnpermakillCharacter", {
				characterID = self.customData.characterID}
			);
			
			--[[timer.Simple(0.5, function()
				if IsValid(parent) then
					parent:Clear();
					parent:Rebuild();
				end
			end)]]--
			
			Clockwork.character:GetPanel():OpenPanel("cwCharacterList", nil, function(panel)
				Clockwork.character:RefreshPanelList();
			end);
			
			surface.PlaySound("begotten/ui/buttonclick.wav");
		end;
		
		function self.unPermakillButton.Paint()
			surface.SetDrawColor(255, 255, 255, 255);
			surface.SetMaterial(buttonMaterial);
			surface.DrawTexturedRect(0, 0, 185, 50);
		end
	end
	
	local y = 50;
	
	if Clockwork.Client:IsAdmin() then
		y = 77;
	end
	
	self.deleteButton = vgui.Create("DButton", self);
	self.deleteButton:SetSize(120, 50);
	self.deleteButton:SetPos(542, y);
	self.deleteButton:SetText("Delete");
	self.deleteButton:SetTextColor(Color(100, 25, 25));
	self.deleteButton:SetFont("nov_IntroTextSmallaaafaa")
	
	-- Called when the button is clicked.
	function self.deleteButton.DoClick()
		local cData = self.customData;
		
		Clockwork.datastream:Start("InteractCharacter", {
			characterID = cData.characterID, action = "delete"}
		);
		
		--[[timer.Simple(0.5, function()
			if IsValid(parent) then
				parent:Clear();
				parent:Rebuild();
			end
		end)]]--
		
		Clockwork.character:GetPanel():OpenPanel("cwCharacterList", nil, function(panel)
			Clockwork.character:RefreshPanelList();
		end);
		
		surface.PlaySound("begotten/ui/buttonclick.wav");
	end;
	
	function self.deleteButton.Paint()
		surface.SetDrawColor(255, 255, 255, 255);
		surface.SetMaterial(buttonMaterial);
		surface.DrawTexturedRect(0, 0, 185, 50);
	end
end;

vgui.Register("cwNecropolisPanel", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	Clockwork.character:FadeOutAll();
	
	self.uniqueID = "cwNecropolis";
	self:Rebuild();
end;

function PANEL:Rebuild()
	--self.characterForms = {};
	
	self:SetTitle("");
	self:SetSizable(false);
	self:SetDraggable(false);
	self:ShowCloseButton(false);
	
	self.panelList = vgui.Create("DPanelList", self);
 	self.panelList:SetDrawBackground(false);
	self.panelList:SetNoSizing(true);
	self.panelList:SetSpacing(4);
	self.panelList:EnableVerticalScrollbar();
	
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local fonts = {tinyTextFont, smallTextFont};
	
	local availableFactions = {};
	local factions = {};
	self.characterFound = false;
	
	for k, v in pairs(Clockwork.character:GetAll()) do
		local faction = Clockwork.plugin:Call("GetPlayerCharacterScreenFaction", v);
		
		if (!availableFactions[faction]) then
			availableFactions[faction] = {};
		end;
		
		availableFactions[faction][#availableFactions[faction] + 1] = v;
	end;
	
	for k, v in pairs(availableFactions) do
		table.sort(v, function(a, b)
			return Clockwork.plugin:Call("CharacterScreenSortFactionCharacters", k, a, b);
		end);
		
		factions[#factions + 1] = {name = k, characters = v};
	end;
	
	table.sort(factions, function(a, b)
		return a.name < b.name;
	end);
	
	for i = 1, #factions do
		for k, v in pairs(factions[i].characters) do
			if v.permakilled then
				self.characterFound = true;
				
				local subfaction_override = v.subfaction;
				
				if (!v.subfaction) or v.subfaction == "" then 
					subfaction_override = "N/A";
				end
				
				self.customData = {
					name = v.name,
					model = v.model,
					skin = tonumber(v.skin) or 0,
					gender = v.gender,
					banned = v.banned,
					--clothes = v.clothes,
					faction = v.faction,
					subfaction = subfaction_override,
					kinisgerOverride = v.kinisgerOverride,
					kinisgerOverrideSubfaction = v.kinisgerOverrideSubfaction,
					rank = v.rank,
					faith = v.faith,
					kills = v.kills,
					level = v.level or 1,
					location = v.location,
					timesurvived = v.timesurvived,
					deathcause = v.deathcause,
					details = v.details,
					characterID = v.characterID,
					characterTable = v,
					charTable = v,
				};

				v.panel = vgui.Create("cwNecropolisPanel", self);
				
				if (IsValid(v.panel)) then
					self.panelList:AddItem(v.panel);
				end;
			end
		end;
	end
	
	self.cancelButton = vgui.Create("cwLabelButton", self);
	self.cancelButton:SetFont(smallTextFont);
	self.cancelButton:SetText("RETURN");
	self.cancelButton:SetCallback(function(self)
		Clockwork.character:GetPanel():OpenPanel("cwCharacterList", nil, function(panel)
			Clockwork.character:RefreshPanelList();
		end);
	end);
	self.cancelButton:SizeToContents();
	self.cancelButton:SetPos(ScrW() * 0.5 - (self.cancelButton:GetWide() / 2), ScrH() * 0.925);
	self.cancelButton:SetMouseInputEnabled(true);
	self.cancelButton.bStartFaded = true;
	
	function self.cancelButton:Paint(w, h)
		if (self:GetHovered()) then
			local texts = {"RETURN", "rEtUrN", "ReTuRn"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	local introTextSmallFont = Clockwork.option:GetFont("intro_text_small")
	local scrW = ScrW();
	local scrH = ScrH();

	if !self.characterFound then
		draw.SimpleText("The Necropolis lies empty, but not for long...", introTextSmallFont, scrW * 0.5 - 1, scrH * 0.5 - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText("The Necropolis lies empty, but not for long...", introTextSmallFont, scrW * 0.5 + 1, scrH * 0.5 + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText("The Necropolis lies empty, but not for long...", introTextSmallFont, scrW * 0.5 + 1, scrH * 0.5 - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText("The Necropolis lies empty, but not for long...", introTextSmallFont, scrW * 0.5 - 1, scrH * 0.5 + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText("The Necropolis lies empty, but not for long...", introTextSmallFont, scrW * 0.5, scrH * 0.5, Color(160, 0, 0), 1, 1);
	end
 end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
	elseif (Callback) then
		Callback();
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
	elseif (Callback) then
		Callback();
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetSize(ScrW(), ScrH());
	self:SetPos(0, 0);
	
	if IsValid(self.panelList) then
		self.panelList:SetSize(666, 750);
		self.panelList:CenterHorizontal(0.5);
		--self.panelList:SetPos(ScrW() / 2 - 333, ScrH() / 2 - 375);
	end
end;

vgui.Register("cwNecropolis", PANEL, "DFrame");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.info = Clockwork.character:GetCreationInfo();
	self.uniqueID = "cwCharacterStageThree";
	
	self.classesForm = vgui.Create("DForm");
	self.classesForm:SetName("Classes");
	self.classesForm:SetPadding(4);
	
	self.categoryList = vgui.Create("DCategoryList", self);
 	self.categoryList:SetPadding(2);
 	self.categoryList:SizeToContents();
	
	for k, v in pairs(Clockwork.class:GetAll()) do
		if (v.isOnCharScreen and (v.factions and table.HasValue(v.factions, self.info.faction))) then
			self.classTable = v;
			self.overrideData = {
				information = "Select this to make it your character's default class.",
				Callback = function()
					self.info.class = v.index;
				end
			};
			self.classForm:AddItem(vgui.Create("cwClassesItem", self));
		end;
	end;
	
	self.categoryList:AddItem(self.classForm);
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h) end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonclickrelease.wav");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (!self.info.class or !Clockwork.class:FindByID(self.info.class)) then
		Clockwork.character:SetFault("You did not choose a class, or the class that you chose is not valid!");
		return false;
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.categoryList:StretchToParent(0, 0, 0, 0);
	self:SetSize(512, math.min(self.categoryList.pnlCanvas:GetTall() + 8, ScrH() * 0.6));
end;

vgui.Register("cwCharacterStageThree", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	Clockwork.Client.ModelSelectionOpen = true;	

	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local gender = GENDER_MALE;
	local factionTable = Clockwork.faction:FindByID(Clockwork.Client.SelectedFaction);
	local panel = Clockwork.character:GetPanel();
	
	self.categoryList = vgui.Create("DCategoryList", self);
 	self.categoryList:SetPadding(8);
 	self.categoryList:SizeToContents();
	
	function self.categoryList:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall() - 8, Color(0, 0, 0, 100))
	end;
	
	self.overrideModel = nil;
	self.bSelectModel = nil;
	self.bPhysDesc = (Clockwork.command:FindByID("CharPhysDesc") != nil);
	self.bBackstory = false;
	self.bFaiths = true;
	self.bTraits = true;
	self.info = Clockwork.character:GetCreationInfo();
	self.info.gender = GENDER_MALE;
	self.info.skin = 0;
	self.uniqueID = "cwCharacterStageTwo";
	
	Clockwork.Client.CurrentGender = GENDER_MALE;
	
	panel.nextButton:SetText("CREATE");
	panel.nextButton:SizeToContents();
	panel.nextButton.Paint = function(panel, w, h)
		if (panel:GetHovered()) then
			local texts = {"CrEaTe", "cReAtE"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetModel) then
		self.bSelectModel = true;
	end;
	
	if !Schema.faiths or table.IsEmpty(Schema.faiths.stored) then
		self.availableFaiths = {};
		self.bFaiths = false;
	else
		if factionTable.subfactionsToAvailableFaiths and factionTable.subfactionsToAvailableFaiths[Clockwork.Client.SelectedSubfaction] then
			self.availableFaiths = factionTable.subfactionsToAvailableFaiths[Clockwork.Client.SelectedSubfaction];
		elseif factionTable.availablefaiths then
			self.availableFaiths = factionTable.availablefaiths;
		end
	
		if (!self.availableFaiths) then
			self.availableFaiths = {};
			self.bFaiths = false;
		elseif #self.availableFaiths == 1 then
			self.bFaiths = false;

			Clockwork.Client.SelectedFaith = self.availableFaiths[1];
			self.info.faith = self.availableFaiths[1];
		else
			Clockwork.Client.SelectedFaith = self.availableFaiths[1];
			self.info.faith = self.availableFaiths[1];
		end
	end
	
	local genderModels = Clockwork.faction.stored[self.info.faction].models[string.lower(gender)].heads;
	local modelSelected = 1;
	
	if Clockwork.Client.SelectedSubfaction then
		local factionTable = Clockwork.faction:FindByID(self.info.faction);
		
		if factionTable.subfactions then
			for i = 1, #factionTable.subfactions do
				if factionTable.subfactions[i].name == Clockwork.Client.SelectedSubfaction then
					if factionTable.subfactions[i].models then
						genderModels = factionTable.subfactions[i].models[string.lower(gender)].heads;
						
						break;
					end
				end
			end;
		end
	end
	
	if IsValid(Clockwork.Client.CharSelectionModel) then
		Clockwork.Client.CharSelectionModel:SetBodygroup(0, 0);
		Clockwork.Client.CharSelectionModel:SetBodygroup(1, 0);
	
		local clientsideModel = Clockwork.Client.CharSelectionModel:GetModel();
		
		if IsValid(Clockwork.Client.CharSelectionModel.HeadModel) then
			clientsideModel = Clockwork.Client.CharSelectionModel.HeadModel:GetModel();
		end
		
		for i, v in ipairs(genderModels) do
			if string.find(clientsideModel, v) then
				modelSelected = i;
				
				break;
			end
		end
		
		Clockwork.Client.SelectedModel = "models/begotten/heads/"..genderModels[modelSelected].."_gore.mdl";
	end
	
	if (genderModels and #genderModels == 1) then
		self.bSelectModel = false;
		self.overrideModel = genderModels[1];
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		self.nameForm = vgui.Create("DForm", self);
		self.nameForm:SetPadding(8);
		self.nameForm:SetName("");
		
		self.nameFormTitle = vgui.Create("DLabel", self.nameForm);
		self.nameFormTitle:SetText("Name");
		self.nameFormTitle:SetPos(6, 2)
		self.nameFormTitle:SetFont("Decay_FormText")
		self.nameFormTitle:SizeToContents();
		self.nameFormTitle:SetColor(Color(255, 255, 255));
		
		if (Clockwork.faction.stored[self.info.faction].useFullName) then
			self.fullNameTextEntry = self.nameForm:TextEntry("Full Name");
			self.fullNameTextEntry:SetAllowNonAsciiCharacters(true);
		else
			self.forenameTextEntry = self.nameForm:TextEntry("Forename");
			self.forenameTextEntry:SetAllowNonAsciiCharacters(true);
			self.forenameRandomButton = vgui.Create("DImageButton", self.nameForm);
			
			self.forenameRandomButton:SetSize(24, 24);
			self.forenameRandomButton:SetImage("begotten/ui/bgtbtnrandom.png");
			self.forenameRandomButton:SetPos(82, 30);
			
			-- Called when an option is selected.
			self.forenameRandomButton.DoClick = function()
				if RANDOM_FORENAMES and Clockwork.faction.stored[self.info.faction].names then
					local random_forename = "";
					
					random_forename = table.Random(RANDOM_FORENAMES[Clockwork.faction.stored[self.info.faction].names][string.lower(Clockwork.Client.CurrentGender)]);
					
					self.forenameTextEntry:SetValue(random_forename);
				end
			end;
			
			self.surnameTextEntry = self.nameForm:TextEntry("Surname");
			self.surnameTextEntry:SetAllowNonAsciiCharacters(true);
			self.surnameRandomButton = vgui.Create("DImageButton", self.nameForm);
			
			self.surnameRandomButton:SetSize(24, 24);
			self.surnameRandomButton:SetImage("begotten/ui/bgtbtnrandom.png");
			self.surnameRandomButton:SetPos(82, 60);
			
			-- Called when an option is selected.
			self.surnameRandomButton.DoClick = function()
				if RANDOM_SURNAMES and Clockwork.faction.stored[self.info.faction].names then
					local random_surname = "";

					random_surname = table.Random(RANDOM_SURNAMES[Clockwork.faction.stored[self.info.faction].names]);
					
					self.surnameTextEntry:SetValue(random_surname);
				end
			end;
		end;
	end;
	
	if (self.bSelectModel or self.bPhysDesc) then
		self.appearanceForm = vgui.Create("DForm", self);
		self.appearanceForm:SetPadding(8);
		self.appearanceForm:SetName("");
		
		self.appearanceFormTitle = vgui.Create("DLabel", self.appearanceForm);
		self.appearanceFormTitle:SetText("Appearance");
		self.appearanceFormTitle:SetPos(6, 2)
		self.appearanceFormTitle:SetFont("Decay_FormText")
		self.appearanceFormTitle:SizeToContents();
		self.appearanceFormTitle:SetColor(Color(255, 255, 255));
		
		if (!Clockwork.faction.stored[self.info.faction].singleGender) then
			self.maleButton = vgui.Create("DImageButton", self)
			self.maleButton:SetSize(71, 72);
			self.maleButton:SetImage("begotten/ui/bgtbtnmale.png");
			self.maleButton:SetColor(Color(255, 255, 255, 240));
			
			self.maleButton.DoClick = function()
				if Clockwork.Client.CurrentGender ~= GENDER_MALE then
					Clockwork.Client.CurrentGender = GENDER_MALE;
					self.info.gender = GENDER_MALE;

					if (self.bSelectModel) then
						genderModels = Clockwork.faction.stored[Clockwork.Client.SelectedFaction].models[string.lower(GENDER_MALE)].heads;
						modelSelected = math.random(1, #genderModels);
						
						if Clockwork.Client.SelectedSubfaction then						
							if factionTable.subfactions then
								for i = 1, #factionTable.subfactions do
									if factionTable.subfactions[i].name == Clockwork.Client.SelectedSubfaction then
										if factionTable.subfactions[i].models then
											genderModels = factionTable.subfactions[i].models[string.lower(GENDER_MALE)].heads;
										end
									end
								end;
							end
						end
						
						Clockwork.Client.SelectedModel = "models/begotten/heads/"..genderModels[modelSelected].."_gore.mdl";
					end
					
					self.forenameTextEntry:SetValue("");
				end
				
				surface.PlaySound("begotten/ui/buttonclick.wav");
			end;
			
			self.femaleButton = vgui.Create("DImageButton", self)
			self.femaleButton:SetSize(71, 72);
			self.femaleButton:SetImage("begotten/ui/bgtbtnfemale.png");
			self.femaleButton:SetColor(Color(255, 255, 255, 240));
			
			self.femaleButton.DoClick = function()
				if Clockwork.Client.CurrentGender ~= GENDER_FEMALE then
					Clockwork.Client.CurrentGender = GENDER_FEMALE;
					self.info.gender = GENDER_FEMALE;

					if (self.bSelectModel) then
						genderModels = Clockwork.faction.stored[Clockwork.Client.SelectedFaction].models[string.lower(GENDER_FEMALE)].heads;
						modelSelected = math.random(1, #genderModels);
						
						if Clockwork.Client.SelectedSubfaction then				
							if factionTable.subfactions then
								for i = 1, #factionTable.subfactions do
									if factionTable.subfactions[i].name == Clockwork.Client.SelectedSubfaction then
										if factionTable.subfactions[i].models then
											genderModels = factionTable.subfactions[i].models[string.lower(GENDER_FEMALE)].heads;
										end
									end
								end;
							end
						end
						
						Clockwork.Client.SelectedModel = "models/begotten/heads/"..genderModels[modelSelected].."_gore.mdl";
					end
					
					self.forenameTextEntry:SetValue("");
				end
				
				surface.PlaySound("begotten/ui/buttonclick.wav");
			end;
		end
		
		if (self.bPhysDesc) then
			self.appearanceFormHelp = self.appearanceForm:Help("Write a physical description for your character.");
			self.physDescTextEntry = self.appearanceForm:TextEntry("Description");
			self.physDescTextEntry:SetAllowNonAsciiCharacters(true);
		end;

		if (self.bSelectModel) then
			self.skinButton = vgui.Create("DButton", self.appearanceForm);
			self.appearanceForm:AddItem(self.skinButton);

			self.skinButton:SetVisible(true);
			self.skinButton:SetText("Select Skin");
			self.skinButton.DoClick = function()
				if IsValid(Clockwork.Client.CharSelectionModel) then
					local skinCount = Clockwork.Client.CharSelectionModel:SkinCount() - 1;
				
					if IsValid(Clockwork.Client.CharSelectionModel.HeadModel) then
						skinCount = Clockwork.Client.CharSelectionModel.HeadModel:SkinCount() - 1;
					end
					
					if (skinCount > 0) then
						local options = {};

						for i = 0, skinCount do
							options[tostring(i)] = function()
								if IsValid(Clockwork.Client.CharSelectionModel.HeadModel) then
									Clockwork.Client.CharSelectionModel.HeadModel:SetSkin(i);
								else
									Clockwork.Client.CharSelectionModel:SetSkin(i);
								end
								
								self.info.skin = i;
							end;
						end;

						local menuPanel = Clockwork.kernel:AddMenuFromData(nil, options, function(menuPanel, option, arguments) end);
					else
						local options = {["No Skins Available"] = function() end};
						local menuPanel = Clockwork.kernel:AddMenuFromData(nil, options, function(menuPanel, option, arguments) end);
					end;
				end;
			end;
		
			self.leftModelButton = vgui.Create("DImageButton", self)
			self.leftModelButton:SetSize(72, 71);
			self.leftModelButton:SetImage("begotten/ui/bgtbtnarrowleft.png");
			self.leftModelButton:SetColor(Color(255, 255, 255, 240));
			
			self.leftModelButton.DoClick = function()	
				if modelSelected <= 1 then
					modelSelected = #genderModels;
				else
					modelSelected = modelSelected - 1;
				end
				
				Clockwork.Client.SelectedModel = "models/begotten/heads/"..genderModels[modelSelected].."_gore.mdl";
			end;
			
			self.rightModelButton = vgui.Create("DImageButton", self)
			self.rightModelButton:SetSize(72, 71);
			self.rightModelButton:SetImage("begotten/ui/bgtbtnarrowright.png");
			self.rightModelButton:SetColor(Color(255, 255, 255, 240));
			
			self.rightModelButton.DoClick = function()	
				if modelSelected >= #genderModels then
					modelSelected = 1;
				else
					modelSelected = modelSelected + 1;
				end
				
				Clockwork.Client.SelectedModel = "models/begotten/heads/"..genderModels[modelSelected].."_gore.mdl";
			end;
		end;

		if (self.bBackstory) then
			self.backstoryForm = vgui.Create("DForm", self);
			self.backstoryForm:SetPadding(8);
			self.backstoryForm:SetName("");
			
			self.backstoryFormTitle = vgui.Create("DLabel", self.backstoryForm);
			self.backstoryFormTitle:SetText("Backstory");
			self.backstoryFormTitle:SetPos(6, 2)
			self.backstoryFormTitle:SetFont("Decay_FormText")
			self.backstoryFormTitle:SizeToContents();
			self.backstoryFormTitle:SetColor(Color(255, 255, 255));

			self.backstoryForm:Help("You may write a brief backstory for your character. This is optional.");
			self.backstoryTextEntry = vgui.Create("DTextEntry", self);
			self.backstoryTextEntry:SetAllowNonAsciiCharacters(true);
			self.backstoryTextEntry:SetMultiline(true);
			self.backstoryTextEntry:SetHeight(96);
			self.backstoryForm:AddItem(self.backstoryTextEntry);
		end;
	end;
	
	if (self.bTraits) then
		self.traitsForm = vgui.Create("DForm");
		self.traitsForm:SetName("");
		self.traitsForm:SetPadding(4);
		
		self.traitsFormTitle = vgui.Create("DLabel", self.traitsForm);
		self.traitsFormTitle:SetText("Traits");
		self.traitsFormTitle:SetPos(6, 2)
		self.traitsFormTitle:SetFont("Decay_FormText")
		self.traitsFormTitle:SizeToContents();
		self.traitsFormTitle:SetColor(Color(255, 255, 255));
		
		self.maximumPoints = Clockwork.config:Get("max_trait_points"):Get();
		self.selectedTraits = {};
		
		if Clockwork.Client.SelectedSubfaction == "Clan Crast" then
			self.maximumPoints = self.maximumPoints - 4;
		elseif Clockwork.Client.SelectedSubfaction == "Kinisger" then
			self.maximumPoints = self.maximumPoints - 3;
		end
		
		self.info.traits = {};
		
		self.helpText = self.traitsForm:Help("Points remaining: "..self.maximumPoints);
		
		local traitsLabel = vgui.Create("DLabel", self.traitsForm);
		traitsLabel:SetSize(480, 12);
		traitsLabel:SetTextInset(64, 0);
		traitsLabel:SetText("Available Traits                                   Selected Traits");
		traitsLabel:SetDrawBackground(false);
		traitsLabel:SetFont("Decay_FormText");
		traitsLabel:SetColor(Color(255, 20, 20));
		
		self.traitsList = vgui.Create("DPanelList", self.traitsForm);
		self.traitsList:SetAutoSize(true);
		self.traitsList:EnableHorizontal(true);
		self.traitsList:SetDrawBackground(false);
		
		self.traitItemsList = vgui.Create("DPanelList", self.traitsList);
		self.traitItemsList:SetPadding(4);
		self.traitItemsList:SetSpacing(1);
		--self.traitItemsList:SetAutoSize(true);
		self.traitItemsList:SetSize(240, 276);
		self.traitItemsList:EnableHorizontal(true);
		self.traitItemsList:EnableVerticalScrollbar(true);
		self.traitItemsList:SetDrawBackground(false);
		self.traitItemsList:HideScrollbar();
		
		self.chosenTraitItemsList = vgui.Create("DPanelList", self.traitsList);
		self.chosenTraitItemsList:SetPadding(4);
		self.chosenTraitItemsList:SetSpacing(1);
		--self.chosenTraitItemsList:SetAutoSize(true);
		self.chosenTraitItemsList:SetSize(240, 276);
		self.chosenTraitItemsList:EnableHorizontal(true);
		self.chosenTraitItemsList:EnableVerticalScrollbar(true);
		self.chosenTraitItemsList:SetDrawBackground(false);
		self.chosenTraitItemsList:HideScrollbar();
		
		self.traitsForm:AddItem(traitsLabel);
		self.traitsList:AddItem(self.traitItemsList);
		self.traitsList:AddItem(self.chosenTraitItemsList);
		self.traitsForm:AddItem(self.traitsList);
		
		TRAITBUTTONS = {};
	
		local selectedBad = Color(255, 50, 50, 255);
		local selectedGood = Color(50, 255, 50, 255);
		local informationColor = Clockwork.option:GetColor("information");
	
		for k, v in SortedPairsByMemberValue(Clockwork.trait:GetAll(), "points") do
			local traitTable = v;
			local traitButton = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DColorButton", self))
			traitButton:SetText(v.name);
			traitButton:SetTextInset(36, 0);
			traitButton:SetColor(Color(41, 26, 0), true);
			traitButton:SetSize(228, 24);
			traitButton:SetToolTipTitle(v.name);
			traitButton:SetTooltip("");
			
			traitButton.uniqueID = v.uniqueID;
			
			local traitButtonPointsIcon = vgui.Create("DImage", traitButton);
			traitButtonPointsIcon:SetImage("begotten/ui/traitpoints.png");
			traitButtonPointsIcon:SetSize(29, 19);
			traitButtonPointsIcon:SetPos(2, 3);
			
			local traitButtonPointsLabel = vgui.Create("DLabel", traitButton);
			traitButtonPointsLabel:SetSize(29, 19);
			traitButtonPointsLabel:SetPos(2, 3);
			traitButtonPointsLabel:SetTextInset(12, 0);
			traitButtonPointsLabel:SetDrawBackground(false);
			
			if (v.points < 0) then
				traitButtonPointsLabel:SetText(string.gsub(v.points, "-", ""));
				traitButtonPointsLabel:SetTextColor(selectedGood);
				
				if math.abs(v.points) > 9 then
					traitButtonPointsLabel:SetTextInset(9, 0);
				end
			else
				traitButtonPointsLabel:SetText("-"..v.points);
				traitButtonPointsLabel:SetTextColor(selectedBad);
				
				if math.abs(v.points) < 10 then
					traitButtonPointsLabel:SetTextInset(9, 0);
				else
					traitButtonPointsLabel:SetTextInset(6, 0);
				end
			end;
			
			if v.disables then
				traitButton.disableTable = v.disables;
			end
			
			if v.eventlocked then
				traitButton.eventlocked = true;
				traitButton:SetColor(Color(74, 26, 0), true);
				traitButton:SetDisabled(true);
			else
				if v.excludedfactions then
					traitButton.excludedfactions = v.excludedfactions;
					
					if traitButton.excludedfactions then
						local faction = Clockwork.Client.SelectedFaction;
						
						if Clockwork.Client.SelectedFaction then
							if table.HasValue(traitButton.excludedfactions, faction) then
								--printp("Disabling: "..traitButton.uniqueID);
								traitButton:SetColor(Color(74, 26, 0), true);
								traitButton:SetDisabled(true);
							end
						end
					end
				end
			
				if v.excludedsubfactions then
					traitButton.excludedsubfactions = v.excludedsubfactions;
					
					if traitButton.excludedsubfactions then
						local subfaction = Clockwork.Client.SelectedSubfaction;
						
						if Clockwork.Client.SelectedSubfaction then
							if table.HasValue(traitButton.excludedsubfactions, subfaction) then
								--printp("Disabling: "..traitButton.uniqueID);
								traitButton:SetColor(Color(74, 26, 0), true);
								traitButton:SetDisabled(true);
							end
						end
					end
				end
				
				if v.requiredfactions then
					traitButton.requiredfactions = v.requiredfactions;
					
					if traitButton.requiredfactions then
						local faction = Clockwork.Client.SelectedFaction;
						
						if Clockwork.Client.SelectedFaction then
							if !table.HasValue(traitButton.requiredfactions, faction) then
								--printp("Disabling: "..traitButton.uniqueID);
								traitButton:SetColor(Color(74, 26, 0), true);
								traitButton:SetDisabled(true);
							end
						end
					end
				end
			end
			
			-- Called when the spawn icon is clicked.
			function traitButton.DoClick(spawnIcon)
				if (table.HasValue(self.selectedTraits, traitTable)) then
					table.RemoveByValue(self.selectedTraits, traitTable);
					table.RemoveByValue(self.info.traits, traitTable.uniqueID);

					if traitButton.disableTable then
						for i = 1, #TRAITBUTTONS do		
							if IsValid(TRAITBUTTONS[i]) then
								if table.HasValue(traitButton.disableTable, TRAITBUTTONS[i].uniqueID) then
									if TRAITBUTTONS[i].factions or TRAITBUTTONS[i].excludedsubfactions or TRAITBUTTONS[i].requiredfactions then
										if TRAITBUTTONS[i].excludedfactions then
											if not table.HasValue(TRAITBUTTONS[i].excludedfactions, Clockwork.Client.SelectedFaction) then
												--printp("Enabling: "..TRAITBUTTONS[i].uniqueID);
												TRAITBUTTONS[i]:SetColor(Color(41, 26, 0), true);
												TRAITBUTTONS[i]:SetDisabled(false);
											end
										end
									
										if TRAITBUTTONS[i].excludedsubfactions then
											if not table.HasValue(TRAITBUTTONS[i].excludedsubfactions, Clockwork.Client.SelectedSubfaction) then
												--printp("Enabling: "..TRAITBUTTONS[i].uniqueID);
												TRAITBUTTONS[i]:SetColor(Color(41, 26, 0), true);
												TRAITBUTTONS[i]:SetDisabled(false);
											end
										end
										
										if TRAITBUTTONS[i].requiredfactions then
											if table.HasValue(TRAITBUTTONS[i].requiredfactions, Clockwork.Client.SelectedFaction) then
												--printp("Enabling: "..TRAITBUTTONS[i].uniqueID);
												TRAITBUTTONS[i]:SetColor(Color(41, 26, 0), true);
												TRAITBUTTONS[i]:SetDisabled(false);
											end
										end
									else
										--printp("Enabling: "..TRAITBUTTONS[i].uniqueID);
										TRAITBUTTONS[i]:SetColor(Color(41, 26, 0), true);
										TRAITBUTTONS[i]:SetDisabled(false);
									end
								end;
							end;
						end;
					end;
					
					self.traitItemsList:AddItem(traitButton);
				else
					table.insert(self.selectedTraits, traitTable);
					table.insert(self.info.traits, traitTable.uniqueID);
					
					if traitButton.disableTable then
						for i = 1, #TRAITBUTTONS do
							if IsValid(TRAITBUTTONS[i]) then
								if table.HasValue(traitButton.disableTable, TRAITBUTTONS[i].uniqueID) then
									--printp("Disabling: "..TRAITBUTTONS[i].uniqueID);
									TRAITBUTTONS[i]:SetColor(Color(74, 26, 0), true);
									TRAITBUTTONS[i]:SetDisabled(true);
								end;
							end
						end;
					end;
					
					self.chosenTraitItemsList:AddItem(traitButton);
				end;

				--[[if self.disableTable then
					for k, v in pairs(self.disableTable) do
						for k2, v2 in pairs(TRAITBUTTONS) do
							if (string.find(v, v2.uniqueID)) then
								temptable[k2]:SetDisabled(true);
							end;
						end;
					end;
				end;]]--
				
				--surface.PlaySound("common/talk.wav");
			end;
			
			traitButton:SetToolTipCallback(function(frame)
				if frame then
					frame:AddText(v.description, Color(225, 200, 200));
					
					if (v.points < 0) then
						if v.points == -1 then
							frame:AddText("Gives "..string.gsub(v.points, "-", "").." point", selectedGood);
						else
							frame:AddText("Gives "..string.gsub(v.points, "-", "").." points", selectedGood);
						end
					else
						if v.points == 1 then
							frame:AddText("Costs "..v.points.." point", selectedBad);
						else
							frame:AddText("Costs "..v.points.." points", selectedBad);
						end
					end;
					
					if traitButton.disableTable then
						local disabledTraitsText = "Disables ";
						
						for i = 1, #traitButton.disableTable do
							disabledTraitsText = disabledTraitsText.."'"..Clockwork.trait:FindByID(traitButton.disableTable[i]).name.."'";
							
							if i == #traitButton.disableTable - 1 then
								disabledTraitsText = disabledTraitsText..", and ";
							elseif i < #traitButton.disableTable then
								disabledTraitsText = disabledTraitsText..", ";
							end
						end
						
						frame:AddText(disabledTraitsText, selectedBad);
					end
					
					if traitButton.eventlocked then
						frame:AddText("This trait is locked for this event!", selectedBad);
					elseif traitButton.excludedfactions and Clockwork.Client.SelectedFaction and table.HasValue(traitButton.excludedfactions, Clockwork.Client.SelectedFaction) then
						frame:AddText("This trait is locked for your selected faction!", selectedBad);
					elseif traitButton.excludedsubfactions and Clockwork.Client.SelectedSubfaction and table.HasValue(traitButton.excludedsubfactions, Clockwork.Client.SelectedSubfaction) then
						frame:AddText("This trait is locked for your selected subfaction!", selectedBad);
					elseif traitButton.requiredfactions and Clockwork.Client.SelectedFaction and !table.HasValue(traitButton.requiredfactions, Clockwork.Client.SelectedFaction) then
						frame:AddText("This trait is locked for your selected faction!", selectedBad);
					end
				end
			end);
			
			self.traitItemsList:AddItem(traitButton);
			table.insert(TRAITBUTTONS, traitButton);
		end;
	end
	
	if (self.bFaiths) then
		self.faithList = vgui.Create("DCategoryList", self);
		self.faithList:SetPadding(8);
		self.faithList:SizeToContents();

		function self.faithList:Paint()
			draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall() - 8, Color(0, 0, 0, 100))
		end;
		
		self.info.faith = nil;
	
		self.faithForm = vgui.Create("DForm", self);
		self.faithForm:SetPadding(4);
		self.faithForm:SetName("");
		
		self.faithFormTitle = vgui.Create("DLabel", self.faithForm);
		self.faithFormTitle:SetText("Faith");
		self.faithFormTitle:SetPos(6, 2)
		self.faithFormTitle:SetFont("Decay_FormText")
		self.faithFormTitle:SizeToContents();
		self.faithFormTitle:SetColor(Color(255, 255, 255));
		
		for i, v in ipairs(self.availableFaiths) do
			local faithTable = Schema.faiths:GetFaith(v);
			
			if faithTable then
				local faithButton = vgui.Create("DImageButton", self.faithForm)
				
				faithButton:SetSize(480, 150);
				faithButton:SetImage(faithTable.image);
				faithButton.faith = faithTable.name;

				timer.Simple(0.1, function()
					if IsValid(faithButton) then
						if faithButton.faith == Clockwork.Client.SelectedFaith then
							faithButton.DoClick();
						end
					end
				end);
				
				timer.Simple(0.5, function()
					if IsValid(faithButton) then
						faithButton.sound = "begotten/ui/buttonclick.wav";
					end
				end);
				
				faithButton.DoClick = function()
					if SELECTED_FAITH_ICON and IsValid(SELECTED_FAITH_ICON) then
						SELECTED_FAITH_ICON:SetColor(Color(255, 255, 255, 255));
					end
					
					SELECTED_FAITH_ICON = faithButton;
					
					Clockwork.Client.SelectedFaith = faithButton.faith;
					self.info.faith = faithButton.faith;
					
					faithButton:SetColor(Color(255, 150, 150, 255));
					self.faithTitle:SetText(faithTable.name);
					self.faithTitle:SizeToContents();
					self.faithTitle:SetPos(245 - (self.faithTitle:GetWide() / 2), 0);
					self.faithDescription:SetText(faithTable.description);
					
					if faithButton.sound then
						surface.PlaySound(faithButton.sound);
					end
				end;
			
				self.faithForm:AddItem(faithButton);
			end
		end

		self.faithInformation = vgui.Create("DPanel", self.faithForm)
		self.faithInformation:SetSize(500, 270);
		
		self.faithTitle = vgui.Create("DLabel", self.faithInformation);
		self.faithTitle:SetText("");
		self.faithTitle:SetFont("Decay_FormText");
		self.faithTitle:SetColor(Color(255, 20, 20));
		
		self.faithDescription = vgui.Create("DTextEntry", self.faithInformation);
		self.faithDescription:SetTextColor(Color(255, 215, 215, 240));
		self.faithDescription:SetSize(490, 240);
		self.faithDescription:SetPos(0, 27);
		self.faithDescription:SetDisabled(true);
		self.faithDescription:SetDrawBackground(false);
		self.faithDescription:SetMultiline(true);
		self.faithDescription:SetText("");

		self.faithForm:AddItem(self.faithInformation);
	end

	if (self.nameForm) then
		self.categoryList:AddItem(self.nameForm);
	end;
	
	if (self.appearanceForm) then
		self.categoryList:AddItem(self.appearanceForm);
		self.categoryList:AddItem(self.skinButton);
	end;
	
	if (self.traitsForm) then
		self.categoryList:AddItem(self.traitsForm);
	end
	
	if (self.backstoryForm) then
		self.categoryList:AddItem(self.backstoryForm);
	end;
	
	if (self.faithForm) then
		self.faithList:AddItem(self.faithForm);
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if self.maleButton and self.femaleButton then
		local faction = self.forcedFaction;
		
		for k, v in pairs(Clockwork.faction.stored) do
			if (v.name == faction) then
				if (Clockwork.faction:IsGenderValid(faction, Clockwork.Client.CurrentGender)) then
					self.info.gender = Clockwork.Client.CurrentGender;
				else
					return false;
				end;
			end;
		end;
	elseif Clockwork.faction.stored[self.info.faction].singleGender then
		self.info.gender = Clockwork.faction.stored[self.info.faction].singleGender;
	else
		self.info.gender = GENDER_MALE;
	end;

	if (self.overrideModel) then
		self.info.model = self.overrideModel;
	else
		self.info.model = Clockwork.Client.SelectedModel;
	end;
	
	if (!Clockwork.faction.stored[self.info.faction].GetName) then
		if (IsValid(self.fullNameTextEntry)) then
			self.info.fullName = self.fullNameTextEntry:GetValue();
			
			if (self.info.fullName == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;

			if (string.len(self.info.fullName) < 4) then
				Clockwork.character:SetFault("Your name must be at least 4 characters long!");
				return false;
			end;

			if (string.len(self.info.fullName) > 32) then
				Clockwork.character:SetFault("Your name must not be greater than 32 characters long!");
				return false;
			end;
		else
			self.info.forename = self.forenameTextEntry:GetValue();
			self.info.surname = self.surnameTextEntry:GetValue();
			
			if (self.info.forename == "" or self.info.surname == "") then
				Clockwork.character:SetFault("You did not choose a name, or the name that you chose is not valid!");
				return false;
			end;
			
			--[[
			if (string.find(self.info.forename, "[%p%s%d]") or string.find(self.info.surname, "[%p%s%d]")) then
				Clockwork.character:SetFault("Your forename and surname must not contain punctuation, spaces or digits!");
				return false;
			end;
			--]]
			--[[if (!string.find(self.info.forename, "[aeiou]") or !string.find(self.info.surname, "[aeiou]")) then
				Clockwork.character:SetFault("Your forename and surname must both contain at least one vowel!");
				return false;
			end;]]--
			
			if (string.len(self.info.forename) < 2 or string.len(self.info.surname) < 2) then
				Clockwork.character:SetFault("Your forename and surname must both be at least 2 characters long!");
				return false;
			end;
			
			if (string.len(self.info.forename) > 16 or string.len(self.info.surname) > 16) then
				Clockwork.character:SetFault("Your forename and surname must not be greater than 16 characters long!");
				return false;
			end;
		end;
	end;
	
	if (self.bSelectModel and !self.info.model) then
		Clockwork.character:SetFault("You did not choose a model, or the model that you chose is not valid!");
		return false;
	end;
	
	if (self.bPhysDesc) then
		local minimumPhysDesc = Clockwork.config:Get("minimum_physdesc"):Get();
			self.info.physDesc = self.physDescTextEntry:GetValue();
		if (string.len(self.info.physDesc) < minimumPhysDesc) then
			Clockwork.character:SetFault("The physical description must be at least "..minimumPhysDesc.." characters long!");
			return false;
		end;
		
		if (IsValid(self.backstoryTextEntry)) then
			self.info.backstory = self.backstoryTextEntry:GetValue();
			
			if (string.len(self.info.backstory) >= 512) then
				Clockwork.character:SetFault("Your backstory must be shorter than or equal to 512 characters!");
				return false;
			end;
		end;
	end;
	
	if (self.bFaiths) then
		if not self.info.faith then
			Clockwork.character:SetFault("You did not choose a faith!");
			return false;
		end
	end
	
	if (self.bTraits) then
		local points = self:GetPointsLeft();
		
		if points < 0 then
			Clockwork.character:SetFault("You do not have enough points for the traits you have selected!");
			return false;
		end
	end

	self.info.attributes = {};
end;

-- Called when the previous button is pressed.
function PANEL:OnPrevious()
	Clockwork.Client.CurrentGender = GENDER_MALE;
	Clockwork.Client.ModelSelectionOpen = false;
	Clockwork.Client.SelectedFaith = nil;
	Clockwork.Client.SelectedModel = nil;
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h) end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonclickrelease.wav");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

function PANEL:GetPointsLeft()
	local pointsLeft = self.maximumPoints;

	if self.selectedTraits then
		for k, v in pairs(self.selectedTraits) do
			pointsLeft = pointsLeft - v.points;
		end;
	end
	
	return pointsLeft;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.bTraits) then
		local addon = "s.";
		local points = self:GetPointsLeft();
		
		if points then
			if points == 1 or points == -1 then
				addon = "."
			end;
			
			local selectedBad = Color(255, 50, 50, 255);
			local selectedGood = Color(50, 255, 50, 255);
			local selectedNeutral = Color(255, 255, 50, 255);
			local color = selectedGood;
			
			if (points < 0) then
				color = selectedBad;
			elseif (points == 0) then
				color = selectedNeutral;
			end;
			
			if (self.helpText) then
				if (points > 0) then
					self.helpText:SetText("You can spend "..points.." more point"..addon);
				elseif(points < 0) then
					self.helpText:SetText("You have spent too many points! To proceed, you must gain "..math.abs(points).." more point"..addon);
				else
					self.helpText:SetText("You are out of points to spend.");
				end
				self.helpText:SetColor(color);
			end;
		end
	end
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	if (IsValid(self.modelItemsList)) then
		self.modelItemsList:SetTall(256);
	end;
	
	self:SetPos(0, 0);
	self:SetSize(ScrW(), ScrH() * 0.925);
	
	self.categoryList:SetSize(512, math.min(self.categoryList.pnlCanvas:GetTall() + 8, ScrH()));
	self.categoryList:SetPos(25, ScrH() / 10);
	
	if self.faithList then
		self.faithList:SizeToContents();
		self.faithList:SetWide(512);
		self.faithList:SetPos(ScrW() - 25 - self.faithList:GetWide(), ScrH() / 10);
	end
	
	if self.maleButton then
		self.maleButton:SetPos((ScrW() / 2) - 73, ScrH() - (ScrH() / 6));
	end
	
	if self.femaleButton then
		self.femaleButton:SetPos((ScrW() / 2) + 2, ScrH() - (ScrH() / 6));
	end
	
	if self.leftModelButton and self.rightModelButton then
		self.leftModelButton:SetPos((ScrW() / 2) - (ScrW() / 8) - 71, ScrH() / 4.8);
		self.rightModelButton:SetPos((ScrW() / 2) + (ScrW() / 8), ScrH() / 4.8);
	end
end;

vgui.Register("cwCharacterStageTwo", PANEL, "EditablePanel");

local PANEL = {};
local SELECTED_FACTION_ICON = nil;

-- Called when the panel is initialized.
function PANEL:Init()
	local mainTextFont = Clockwork.option:GetFont("main_text")
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local factions = {};
	local panel = Clockwork.character:GetPanel();
	
	for k, v in pairs(Clockwork.faction.stored) do
		--if (!v.whitelist or Clockwork.character:IsWhitelisted(v.name)) then
			if !v.hidden then
				if (!Clockwork.faction:HasReachedMaximum(k)) then
					factions[#factions + 1] = v.name;
				end;
			end
		--end;
	end;
	
	--[[table.sort(factions, function(a, b)
		return a < b;
	end);]]--
	
	local factionWidth = (200 * #factions) + (14 * (#factions + 3));
	local factionHeight = 216;
	
	self.info = Clockwork.character:GetCreationInfo();
	self.uniqueID = "cwCharacterStageOne";
	
	panel.nextButton:SetText("NEXT");
	panel.nextButton:SizeToContents();
	panel.nextButton.Paint = function(panel, w, h)
		if (panel:GetHovered()) then
			local texts = {"NeXt", "nExT"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
	
	if Clockwork.Client.SelectedFaction then
		local factionTable = Clockwork.faction:FindByID(Clockwork.Client.SelectedFaction);

		self.forcedFaction = Clockwork.Client.SelectedFaction;
		self.factionName = Clockwork.Client.SelectedFaction;
		self.factionDescription = factionTable.description;

		local faiths = "";
		
		for i = 1, #factionTable.availablefaiths do
			if i == 1 then
				faiths = factionTable.availablefaiths[i];
			else
				faiths = faiths..", "..factionTable.availablefaiths[i];
			end
		end
		
		self.faithDescription = "Available faiths: "..faiths;
	else
		self.factionName = "";
		self.factionDescription = "";
		self.faithDescription = "";	
	end
	
	self.factionSelection = vgui.Create("DPanelList", self);
	self.factionSelection:SetSize(factionWidth, factionHeight);
	--self.factionSelection:SetPadding(8);
	self.factionSelection:SetSpacing(16);
	self.factionSelection:EnableVerticalScrollbar(false);
	self.factionSelection:EnableHorizontal(true);
	self.factionSelection:HideScrollbar();
	
	self.factionIconSelected = false;
	
	function self.factionSelection:Paint(width, height)
		--draw.RoundedBox(0, 0, 0, factionWidth, factionHeight, Color(50, 50, 50, 220))
		--surface.SetMaterial(Material("begotten/ui/collapsible3-1-5.png"));
		surface.SetDrawColor(Color(0, 0, 0, 0));
		--surface.DrawTexturedRect(0, 0, factionWidth, factionHeight);
	end;
	
	if (#factions > 1) then
		if (self.factionSelection) then
			for i = 1, #factions do
				local factionTable = Clockwork.faction:FindByID(factions[i]);
				
				local icon = vgui.Create("DImageButton", self.factionSelection)
				icon:SetSize(200, 200);
				self.factionSelection:AddItem(icon);
				icon:SetImage(factionTable.material..".png");
				icon.faction = factions[i];
				
				timer.Simple(0.1, function()
					if IsValid(icon) then
						icon.sound = "begotten/ui/buttonclick.wav";
					end
				end);
				
				if icon.faction == Clockwork.Client.SelectedFaction then
					SELECTED_FACTION_ICON = icon;
					icon:SetColor(Color(255, 150, 150, 255));
					self.forcedFaction = icon.faction;
				end
				
				if !factionTable.disabled and (!factionTable.whitelist or Clockwork.character:IsWhitelisted(icon.faction)) then
					-- Called when an option is selected.
					icon.DoClick = function()
						if (!self.factionIconSelected) and self.forcedFaction ~= icon.faction then
							if SELECTED_FACTION_ICON and IsValid(SELECTED_FACTION_ICON) then
								SELECTED_FACTION_ICON:SetColor(Color(255, 255, 255, 255));
							end
							
							SELECTED_FACTION_ICON = icon;
							self.forcedFaction = icon.faction;
							--self.factionIconSelected = true;
							self.info.faction = icon.faction;
							
							icon:SetColor(Color(255, 150, 150, 255));
							
							self.factionName = "";
							self.factionDescription = "";
							self.faithDescription = "";
							
							Clockwork.CurrentFactionSelected = {self, icon.faction};
							
							if timer.Exists("FactionSelectionTimer1") then
								timer.Destroy("FactionSelectionTimer1");
							end
							
							if timer.Exists("FactionSelectionTimer2") then
								Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 0.1, 2.1);
								timer.Destroy("FactionSelectionTimer2");
							else
								Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 1, 1.2);
							end
							
							if timer.Exists("FactionSelectionTimer3") then
								timer.Destroy("FactionSelectionTimer3");
							end
								
							timer.Create("FactionSelectionTimer1", 1, 1, function()
								if IsValid(icon) then
									Clockwork.Client.SelectedFaction = icon.faction;
								end
							
								timer.Create("FactionSelectionTimer2", 1, 1, function()
									Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 1, 0);
									
									Clockwork.Client.MenuCameraMoving = false;
									
									timer.Create("FactionSelectionTimer3", 0.5, 1, function()
										if IsValid(icon) then
											--self.factionIconSelected = false;
											self.factionName = icon.faction;
											self.factionDescription = factionTable.description;
											
											local faiths = "";
											
											for i = 1, #factionTable.availablefaiths do
												if i == 1 then
													faiths = factionTable.availablefaiths[i];
												else
													faiths = faiths..", "..factionTable.availablefaiths[i];
												end
											end
											
											self.faithDescription = "Available faiths: "..faiths;
										end
									end);
								end);
							end);
						end
						
						if icon.sound then
							surface.PlaySound(icon.sound);
						end
					end;
				elseif factionTable.disabled then
					icon:SetColor(Color(256, 128, 128, 128));
				else
					icon:SetColor(Color(128, 128, 128, 128));
				end
				
				if i == 1 then
					if !Clockwork.Client.SelectedFaction then
						icon.DoClick();
					end
				end
			end;
		end;
	elseif (#factions == 1) then
		for k, v in pairs(Clockwork.faction.stored) do
			if (v.name == factions[1]) then				
				Clockwork.CurrentFactionSelected = {self, v.name};
				self.forcedFaction = v.name;
				
				break;
			end;
		end;
	end;
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if self.forcedFaction then
		local faction = self.forcedFaction;
		
		for k, v in pairs(Clockwork.faction.stored) do
			if (v.name == faction) then
				self.info.faction = faction;
				Clockwork.Client.SelectedFaction = faction
				break;
			end;
		end;	
	
		Clockwork.Client.MenuCameraMoving = false;
	
		return true;
	end
	
	Clockwork.character:SetFault("You did not choose a faction or the one you have chosen is not valid!");
	return false;
end;

function PANEL:OnPrevious()
	Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 1, 1.2);
	
	timer.Simple(1, function()
		if self then
			local activePanel = Clockwork.character:GetActivePanel();
			
			if activePanel then
				activePanel:FadeOut(0.5);
			end
			
			Clockwork.character:GetPanel():ReturnToMainMenu();
			
			timer.Simple(1, function()
				Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 1, 0);
			end);
		end
	end);
end

-- Called when the panel is painted.
function PANEL:Paint(w, h) 
	local introTextBigFont = Clockwork.option:GetFont("intro_text_big");
	local introTextSmallFont = Clockwork.option:GetFont("intro_text_small")
	local mainTextFont = Clockwork.option:GetFont("main_text")
	local scrW = ScrW();
	local scrH = ScrH();
	
	if self.forcedFaction then
		draw.SimpleText(self.factionName, introTextBigFont, scrW * 0.5 - 1, scrH * 0.6 - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.factionName, introTextBigFont, scrW * 0.5 + 1, scrH * 0.6 + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.factionName, introTextBigFont, scrW * 0.5 + 1, scrH * 0.6 - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.factionName, introTextBigFont, scrW * 0.5 - 1, scrH * 0.6 + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.factionName, introTextBigFont, scrW * 0.5, scrH * 0.6, Color(160, 0, 0), 1, 1);
		draw.DrawText(self.factionDescription, mainTextFont, scrW * 0.5 - 1, (scrH * 0.6) + (scrH / 33.75) - 1, Color(10, 10, 10), 1);
		draw.DrawText(self.factionDescription, mainTextFont, scrW * 0.5 + 1, (scrH * 0.6) + (scrH / 33.75) + 1, Color(10, 10, 10), 1);
		draw.DrawText(self.factionDescription, mainTextFont, scrW * 0.5 + 1, (scrH * 0.6) + (scrH / 33.75) - 1, Color(10, 10, 10), 1);
		draw.DrawText(self.factionDescription, mainTextFont, scrW * 0.5 - 1, (scrH * 0.6) + (scrH / 33.75) + 1, Color(10, 10, 10), 1);
		draw.DrawText(self.factionDescription, mainTextFont, scrW * 0.5, (scrH * 0.6) + (scrH / 33.75), Color(160, 0, 0), 1);
		draw.SimpleText(self.faithDescription, introTextSmallFont, scrW * 0.5 - 1, (scrH * 0.6) + (scrH / 6.75) - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.faithDescription, introTextSmallFont, scrW * 0.5 + 1, (scrH * 0.6) + (scrH / 6.75) + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.faithDescription, introTextSmallFont, scrW * 0.5 + 1, (scrH * 0.6) + (scrH / 6.75) - 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.faithDescription, introTextSmallFont, scrW * 0.5 - 1, (scrH * 0.6) + (scrH / 6.75) + 1, Color(10, 10, 10), 1, 1);
		draw.SimpleText(self.faithDescription, introTextSmallFont, scrW * 0.5, (scrH * 0.6) + (scrH / 6.75), Color(160, 0, 0), 1, 1);
	end
end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonclickrelease.wav");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
	
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self:SetPos(0, 0);
	self:SetSize(ScrW(), ScrH() * 0.85);
	
	local factions = {};
	
	for k, v in pairs(Clockwork.faction.stored) do
		if !v.hidden then
			--if (!v.whitelist or Clockwork.character:IsWhitelisted(v.name)) then
				if (!Clockwork.faction:HasReachedMaximum(k)) then
					factions[#factions + 1] = v.name;
				end;
			--end;
		end;
	end;
	
	local factionWidth = (200 * #factions) + (14 * (#factions + 3));
	
	if self.factionSelection then
		self.factionSelection:SetPos(ScrW() / 2 - (factionWidth / 2), 10);
	end
end;

vgui.Register("cwCharacterStageOne", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local panel = Clockwork.character:GetPanel();

	self.categoryList = vgui.Create("DCategoryList", self);
 	self.categoryList:SetPadding(8);
 	self.categoryList:SizeToContents();
	
	function self.categoryList:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall() - 8, Color(0, 0, 0, 100))
	end;
	
	self.informationList = vgui.Create("DCategoryList", self);
 	self.informationList:SetPadding(8);
 	self.informationList:SizeToContents();
	
	function self.informationList:Paint()
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall() - 8, Color(0, 0, 0, 100))
	end;

	self.info = Clockwork.character:GetCreationInfo();
	self.uniqueID = "cwCharacterStageSubfaction";
	self.curFaction = nil;
	self.info.subfaction = nil;
	
	panel.nextButton:SetText("NEXT");
	panel.nextButton:SizeToContents();
	panel.nextButton.Paint = function(panel, w, h)
		if (panel:GetHovered()) then
			local texts = {"NeXt", "nExT"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
	
	for k, v in pairs(Clockwork.faction.stored) do
		if (v.name == self.info.faction) then
			self.curFaction = v.name;
		end;
	end;
	
	self.informationForm = vgui.Create("DForm", self);
	self.informationForm:SetPadding(8);
	self.informationForm:SetName("");
	
	self.subfactionForm = vgui.Create("DForm", self);
	self.subfactionForm:SetPadding(8);
	
	if self.curFaction == "Goreic Warrior" then
		self.subfactionForm:SetName("Clans");
	elseif self.curFaction == "Gatekeeper" then
		self.subfactionForm:SetName("Troops");
	elseif self.curFaction == "Holy Hierarchy" then
		self.subfactionForm:SetName("Orders");
	elseif self.curFaction == "Children of Satan" then
		self.subfactionForm:SetName("Bloodlines");
	end
	
	self.subfactionList = vgui.Create("DPanelList", self.subfactionForm);
	self.subfactionList:SetSize(260, 430);
	self.subfactionList:SetPos(0, 21);
	self.subfactionList:SetSpacing(2);
	self.subfactionList:EnableVerticalScrollbar(false);
	self.subfactionList:EnableHorizontal(true);
	self.subfactionList:HideScrollbar();
	
	self.subfactionDescriptionList = vgui.Create("DPanelList", self.informationForm);
	self.subfactionDescriptionList:SetSize(450, 300);
	self.subfactionDescriptionList:SetPaintBackground(false);
	self.subfactionDescriptionList:EnableVerticalScrollbar(false);
	self.subfactionDescriptionList:EnableHorizontal(true);
	self.subfactionDescriptionList:HideScrollbar();
	self.informationForm:AddItem(self.subfactionDescriptionList);

	self.subfactionAttributesList = vgui.Create("DPanelList", self.informationForm);
	self.subfactionAttributesList:SetSize(450, 111);
	self.subfactionAttributesList:SetPaintBackground(false);
	self.subfactionAttributesList:SetSpacing(2);
	self.subfactionAttributesList:EnableVerticalScrollbar(false);
	self.subfactionAttributesList:EnableHorizontal(true);
	self.subfactionAttributesList:HideScrollbar();
	self.informationForm:AddItem(self.subfactionAttributesList);
	
	if (self.subfactionList) and (self.curFaction) then
		local factionTable = Clockwork.faction:FindByID(self.curFaction);
		
		if (factionTable.subfactions) then -- If there isn't something has gone wrong.
			for i = 1, #factionTable.subfactions do
				local button = vgui.Create("DButton", self.subfactionList)
				button:SetSize(256, 70);
				self.subfactionList:AddItem(button);
				button.subfaction = factionTable.subfactions[i].name;
				button.locked = factionTable.subfactions[i].locked;
				button:SetText(button.subfaction);
				button:SetTextColor(Color(81, 81, 81));
				button:SetFont("nov_IntroTextSmallfaaaaa");
				
				local width, height = button:GetWide(), button:GetTall()
				local buttonMaterial = Material("begotten/ui/butt24.png")
				
				timer.Simple(0.1, function()
					if IsValid(button) then
						button.sound = "begotten/ui/buttonclick.wav";
					end
				end);
				
				-- Called when an option is selected.
				button.DoClick = function()
					if SELECTED_SUBFACTION_ICON and IsValid(SELECTED_SUBFACTION_ICON) then
						SELECTED_SUBFACTION_ICON:SetColor(Color(255, 255, 255));
						SELECTED_SUBFACTION_ICON:SetTextColor(Color(81, 81, 81));
					end
					
					SELECTED_SUBFACTION_ICON = button;
					
					button:SetColor(Color(200, 20, 20));
					
					Clockwork.Client.SelectedSubfaction = button.subfaction;
					Clockwork.CurrentSubfactionSelected = {self, button.subfaction};
					self.info.subfaction = button.subfaction;
					
					self.informationForm:SetName(button.subfaction);
					
					self.subfactionDescriptionList:Clear();
					self.subfactionAttributesList:Clear();
					
					if factionTable.subfactions[i].subtitle then
						local subfactionSubtitleText = vgui.Create("DTextEntry", self.subfactionDescriptionList);
						subfactionSubtitleText:SetSize(450, 16);
						subfactionSubtitleText:SetDisabled(true);
						subfactionSubtitleText:SetDrawBackground(false);
						subfactionSubtitleText:Dock(TOP);
						self.subfactionDescriptionList:AddItem(subfactionSubtitleText);
						
						subfactionSubtitleText:SetText(factionTable.subfactions[i].subtitle);
						subfactionSubtitleText:SetTextColor(Color(200, 20, 20));
						subfactionSubtitleText:SetFont("Decay_FormText");
					end
					
					if factionTable.subfactions[i].description then
						local spacer = "";
						local y = 330;
						
						if factionTable.subfactions[i].subtitle then
							spacer = "\n\n";
							y = 316;
						end
						
						local subfactionDescriptionText = vgui.Create("DTextEntry", self.subfactionDescriptionList);
						subfactionDescriptionText:SetTextColor(Color(255, 215, 215, 240));
						subfactionDescriptionText:SetSize(450, y);
						subfactionDescriptionText:SetDisabled(true);
						subfactionDescriptionText:SetDrawBackground(false);
						subfactionDescriptionText:SetMultiline(true);
						subfactionDescriptionText:Dock(TOP);
						self.subfactionDescriptionList:AddItem(subfactionDescriptionText);
						
						subfactionDescriptionText:SetText(spacer..factionTable.subfactions[i].description);
					end
					
					if factionTable.subfactions[i].rivalry then
						local subfactionRivalryText = vgui.Create("DTextEntry", self.subfactionAttributesList);
						subfactionRivalryText:SetSize(450, 16);
						subfactionRivalryText:SetDisabled(true);
						subfactionRivalryText:SetDrawBackground(false);
						--subfactionRivalryText:SetMultiline(true);
						self.subfactionAttributesList:AddItem(subfactionRivalryText);
						
						local subfactionRivalry = factionTable.subfactions[i].rivalry;
						
						subfactionRivalryText:SetTextColor(Color(180, 0, 0));
						subfactionRivalryText:SetText("Rivalry with "..subfactionRivalry);
						subfactionRivalryText:SetFont("Decay_FormText");
					end					
					
					if factionTable.subfactions[i].attributes then
						for j = 1, #factionTable.subfactions[i].attributes do
							local subfactionAttributeText = vgui.Create("DTextEntry", self.subfactionAttributesList);
							subfactionAttributeText:SetSize(450, 16);
							subfactionAttributeText:SetDisabled(true);
							subfactionAttributeText:SetDrawBackground(false);
							self.subfactionAttributesList:AddItem(subfactionAttributeText);
							
							local subfactionAttribute = factionTable.subfactions[i].attributes[j];
							
							subfactionAttributeText:SetTextColor(subfactionAttribute[1]);
							subfactionAttributeText:SetText(subfactionAttribute[2]);
							subfactionAttributeText:SetFont("Decay_FormText");
						end
					end
					
					if button.sound then
						surface.PlaySound(button.sound);
					end
				end;
				
				function button.Paint()
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(buttonMaterial)
					surface.DrawTexturedRect(0, 0, width, height)
				end
				
				if i == 1 then
					button.DoClick();
				end
			end
		end
	end

	if (self.subfactionForm) then
		self.categoryList:AddItem(self.subfactionForm);
	end
	
	if (self.informationForm) then
		self.informationList:AddItem(self.informationForm);
	end
end;

-- Called when the next button is pressed.
function PANEL:OnNext()
	if (self.subfactionList) and (self.curFaction) then
		local factionTable = Clockwork.faction:FindByID(self.curFaction);
		
		if (factionTable.subfactions) then -- If there isn't something has gone wrong.
			for i = 1, #factionTable.subfactions do
				local subfaction = factionTable.subfactions[i];
			
				if subfaction.name == Clockwork.Client.SelectedSubfaction then
					if subfaction.locked then
						Clockwork.character:SetFault("This subfaction is locked and cannot be selected!");
						return false;
					elseif subfaction.whitelist and !Clockwork.character:IsWhitelistedSubfaction(subfaction.name) then
						Clockwork.character:SetFault("You are not whitelisted for this subfaction!");
						return false;
					end
				end
			end
		end
	end
end;

-- Called when the previous button is pressed.
function PANEL:OnPrevious()
	self.info.subfaction = nil;
	Clockwork.Client.SelectedSubfaction = nil;
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h) end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	if (self:GetAlpha() > 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	else
		self:SetVisible(false);
		self:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	if (self:GetAlpha() == 0 and (!self.animation or !self.animation:Active())) then
		self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.animation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.animation) then
			self.animation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonclickrelease.wav");
	else
		self:SetVisible(true);
		self:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);

	if (self.animation) then
		self.animation:Run();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self:SetSize(ScrW(), ScrH() * 0.85);
	self:SetPos(0, 0);
	
	self.categoryList:SetSize(260, 463);
	self.categoryList:SetPos((ScrW() / 1.05) - self.categoryList:GetWide() - self.informationList:GetWide() - 5, (ScrH() / 2) - 232);
	self.informationList:SetSize(475, 463);
	self.informationList:SetPos((ScrW() / 1.05) - self.informationList:GetWide(), (ScrH() / 2 ) - 232);
end;

vgui.Register("cwCharacterStageSubfaction", PANEL, "EditablePanel");

Clockwork.datastream:Hook("CharacterRemove", function(data)
	local characters = Clockwork.character:GetAll();
	local characterID = data;
	
	if (table.Count(characters) == 0) then
		return;
	end;
	
		
	if (!characters[characterID]) then
		return;
	end;
	
	characters[characterID] = nil;
	
	if (!Clockwork.character:IsPanelLoading()) then
		Clockwork.character:RefreshPanelList();
	end;
	
	if (Clockwork.character:GetPanelList()) then
		if (table.Count(characters) == 0) then
			Clockwork.character:GetPanel():ReturnToMainMenu();
		end;
	end;
end);

Clockwork.datastream:Hook("SetWhitelisted", function(data)
	local whitelisted = Clockwork.character:GetWhitelisted();
	
	for k, v in pairs(whitelisted) do
		if (v == data[1]) then
			if (!data[2]) then
				whitelisted[k] = nil;
				
				return;
			end;
		end;
	end;
	
	if (data[2]) then
		whitelisted[#whitelisted + 1] = data[1];
	end;
end);

Clockwork.datastream:Hook("SetWhitelistedSubfaction", function(data)
	local whitelisted = Clockwork.character:GetWhitelistedSubfactions();
	
	for k, v in pairs(whitelisted) do
		if (v == data[1]) then
			if (!data[2]) then
				whitelisted[k] = nil;
				
				return;
			end;
		end;
	end;
	
	if (data[2]) then
		whitelisted[#whitelisted + 1] = data[1];
	end;
end);

Clockwork.datastream:Hook("CharacterAdd", function(data)
	Clockwork.character:Add(data.characterID, data);
	
	if (!Clockwork.character:IsPanelLoading()) then
		Clockwork.character:RefreshPanelList();
	end;
end);

Clockwork.datastream:Hook("CharacterMenu", function(data)
	local menuState = data;

	if (menuState == CHARACTER_MENU_LOADED) then
		if (Clockwork.character:GetPanel()) then
			Clockwork.character:SetPanelLoading(false);
			Clockwork.character:RefreshPanelList();
		end;
	elseif (menuState == CHARACTER_MENU_CLOSE) then
		Clockwork.character:SetPanelOpen(false, true);
		Clockwork.character:SetPanelOpen(false);
	elseif (menuState == CHARACTER_MENU_OPEN) then
		Clockwork.character:SetPanelOpen(true);
	end;
end);

Clockwork.datastream:Hook("CharacterOpen", function(data)
	Clockwork.character:SetPanelOpen(true);
	
	if (data) then
		Clockwork.character.isMenuReset = true;
	end;
end);

Clockwork.datastream:Hook("CharacterFinish", function(data)
	if (data.bSuccess) then
		Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 0.1, 1.2);
		
		timer.Simple(0.2, function()
			Clockwork.Client.CurrentGender = GENDER_MALE;
			Clockwork.Client.MenuAngles = nil;
			Clockwork.Client.MenuVector = nil;
			Clockwork.Client.MenuCameraMoving = false;
			Clockwork.Client.ModelSelectionOpen = false;
			Clockwork.Client.SelectedFaction = nil;
			Clockwork.Client.SelectedFaith = nil;
			Clockwork.Client.SelectedSubfaction = nil;
			Clockwork.Client.SelectedModel = nil;
			
			if IsValid(Clockwork.Client.CharSelectionBanner) then
				Clockwork.Client.CharSelectionBanner:Remove();
			end
			
			Clockwork.character:GetPanel():OpenPanel("cwCharacterList", nil, function(panel)
				Clockwork.character:RefreshPanelList();
			end);
			
			Clockwork.character:SetFault(nil);
		end);
		
		timer.Simple(1.2, function()
			Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 1, 0);
		end);
	else
		Clockwork.character:SetFault(data.fault);
	end;
end);

Clockwork.character:RegisterCreationPanel("Faction", "cwCharacterStageOne");
Clockwork.character:RegisterCreationPanel("Subfaction", "cwCharacterStageSubfaction", function(info)
	if info.faction then
		local factionTable = Clockwork.faction:FindByID(info.faction);
		
		if factionTable and factionTable.subfactions then
			return true;
		end
	end;

	return false;
end);
Clockwork.character:RegisterCreationPanel("Information", "cwCharacterStageTwo");
--[[Clockwork.character:RegisterCreationPanel("Class", "cwCharacterStageThree",
	function(info)
		local classTable = Clockwork.class:GetAll();
		
		if (table.Count(classTable) > 0) then
			for k, v in pairs(classTable) do
				if (v.isOnCharScreen and (v.factions
				and table.HasValue(v.factions, info.faction))) then
					return true;
				end;
			end;
		end;
		
		return false;
	end
);]]--
--[[Clockwork.character:RegisterCreationPanel("Traits", "cwCharacterStageFive", nil, function(info)
		local maximumPoints = Clockwork.config:Get("max_trait_points"):Get();
		
		if (maximumPoints == 0) then
			return false;
		end;
	
		local traitTable = Clockwork.trait:GetAll();
		
		if (table.Count(traitTable) > 0) then
			for k, v in pairs(traitTable) do
				if (!v.factions or table.HasValue(v.factions, info.faction)) then
					return true;
				end;
			end;
		end;
		
		return false;
	end
);]]--