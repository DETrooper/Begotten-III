--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local IsValid = IsValid;
local Color = Color;
local type = type;
local table = table;
local gui = gui;
local vgui = vgui;

--[[
	@codebase Client
	@details Provides an interface to the client-side character system.
	@field stored A table containing a list of stored characters.
	@field whitelisted A table containing a list of whitelisted factions.
	@field creationPanels A table containing a list of creation panels.
--]]
library.New("character", Clockwork);
Clockwork.character.stored = Clockwork.character.stored or {};
Clockwork.character.whitelisted = Clockwork.character.whitelisted or {};
Clockwork.character.whitelistedSubfactions = Clockwork.character.whitelistedSubfactions or {};
--Clockwork.character.creationPanels = Clockwork.character.creationPanels or {};
Clockwork.character.creationPanels = {};

--[[
	@codebase Client
	@details Register a new creation panel.
	@param String The friendly name of the creation process.
	@param String The name of the VGUI panel to use.
	@param Function A callback to get the visibility of the process. Return false to hide.
--]]
function Clockwork.character:RegisterCreationPanel(friendlyName, vguiName, Condition)
	local newIndex = #Clockwork.character.creationPanels + 1;
	
	Clockwork.character.creationPanels[newIndex] = {};
	Clockwork.character.creationPanels[newIndex].index = newIndex;
	Clockwork.character.creationPanels[newIndex].vguiName = vguiName;
	Clockwork.character.creationPanels[newIndex].Condition = Condition;
	Clockwork.character.creationPanels[newIndex].friendlyName = friendlyName;
end;

--[[
	@codebase Client
	@details Get the previous creation panel.
	@returns Table The previous creation panel info.
--]]
function Clockwork.character:GetPreviousCreationPanel()
	local info = self:GetCreationInfo();
	local index = info.index - 1;
	
	while (self.creationPanels[index]) do
		local panelInfo = self.creationPanels[index];
		
		if (!panelInfo.Condition
		or panelInfo.Condition(info)) then
			return panelInfo;
		end;
		
		index = index - 1;
	end;
end;

--[[
	@codebase Client
	@details Get the next creation panel.
	@returns Table The next creation panel info.
--]]
function Clockwork.character:GetNextCreationPanel()
	local info = self:GetCreationInfo();
	local index = info.index + 1;
	
	while (self.creationPanels[index]) do
		local panelInfo = self.creationPanels[index];
		
		if (!panelInfo.Condition
		or panelInfo.Condition(info)) then
			return panelInfo;
		end;
		
		index = index + 1;
	end;
end;

--[[
	@codebase Client
	@details Reset the active character creation info.
--]]
function Clockwork.character:ResetCreationInfo()
	self:GetPanel().info = {index = 0};
end;

--[[
	@codebase Client
	@details Get the active character creation info.
	@returns Table The active character creation info.
--]]
function Clockwork.character:GetCreationInfo()
	return self:GetPanel().info;
end;

--[[
	@codebase Client
	@details Get the creation progress as a percentage.
	@returns Float A percentage of the creation progress.
--]]
function Clockwork.character:GetCreationProgress()
	return (100 / #self.creationPanels) * self:GetCreationInfo().index;
end;

-- A function to get whether the creation process is active.
function Clockwork.character:IsCreationProcessActive()
	local activePanel = self:GetActivePanel();
	
	if (activePanel and activePanel.bIsCreationProcess) then
		return true;
	else
		return false;
	end;
end;

-- A function to open the previous character creation panel.
function Clockwork.character:OpenPreviousCreationPanel()
	local previousPanel = self:GetPreviousCreationPanel();
	local activePanel = self:GetActivePanel();
	local panel = self:GetPanel();
	local info = self:GetCreationInfo();
	
	if (info.index > 0 and activePanel and activePanel.OnPrevious and activePanel:OnPrevious() == false) then
		return;
	end;
	
	if (previousPanel) then
		info.index = previousPanel.index;
		panel:OpenPanel(previousPanel.vguiName, info);
	end;
end;

-- A function to open the next character creation panel.
function Clockwork.character:OpenNextCreationPanel()
	local activePanel = self:GetActivePanel();
	local nextPanel = self:GetNextCreationPanel();
	local panel = self:GetPanel();
	local info = self:GetCreationInfo();
	
	if (info.index > 0 and activePanel and activePanel.OnNext
	and activePanel:OnNext() == false) then
		return;
	end;
	
	if (!nextPanel) then
		Clockwork.plugin:Call(
			"PlayerAdjustCharacterCreationInfo", self:GetActivePanel(), info
		);
		
		netstream.Start("CreateCharacter", info);
	else
		info.index = nextPanel.index;
		panel:OpenPanel(nextPanel.vguiName, info);
	end;
end;

-- A function to get the creation panels.
function Clockwork.character:GetCreationPanels()
	return self.creationPanels;
end;

-- A function to get the active panel.
function Clockwork.character:GetActivePanel()
	if (IsValid(self.activePanel)) then
		return self.activePanel;
	end;
end;

-- A function to set whether the character panel is loading.
function Clockwork.character:SetPanelLoading(loading)
	self.loading = loading;
end;

-- A function to get whether the character panel is loading.
function Clockwork.character:IsPanelLoading()
	return self.isLoading;
end;

-- A function to get the character panel list.
function Clockwork.character:GetPanelList()
	local panel = self:GetActivePanel();
	
	if (panel and panel.isCharacterList) then
		return panel;
	end;
end;

-- A function to get the whitelisted factions.
function Clockwork.character:GetWhitelisted()
	return self.whitelisted;
end;

-- A function to get the whitelisted factions.
function Clockwork.character:GetWhitelistedSubfactions()
	return self.whitelistedSubfactions;
end;

-- A function to get whether the local player is whitelisted for a faction.
function Clockwork.character:IsWhitelisted(faction)
	return table.HasValue(self:GetWhitelisted(), faction);
end;

-- A function to get whether the local player is whitelisted for a faction.
function Clockwork.character:IsWhitelistedSubfaction(subfaction)
	return table.HasValue(self:GetWhitelistedSubfactions(), subfaction);
end;

-- A function to get the local player's characters.
function Clockwork.character:GetAll()
	return self.stored;
end;

-- A function to get the character fault.
function Clockwork.character:GetFault()
	return self.fault;
end;

-- A function to set the character fault.
function Clockwork.character:SetFault(fault)
	if (type(fault) == "string") then
		Clockwork.kernel:AddCinematicText(
			fault, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true
		);
	end;
	
	self.fault = fault;
end;

-- A function to get the character panel.
function Clockwork.character:GetPanel()
	return self.panel;
end;

-- A function to fade in the navigation.
function Clockwork.character:FadeInNavigation()
	if (IsValid(self.panel)) then
		self.panel:FadeInNavigation();
	end;
end;

-- A function to fade in the navigation.
function Clockwork.character:FadeInCancel()
	if (IsValid(self.panel)) then
		self.panel:FadeInCancel();
	end;
end;

-- A function to fade in the navigation.
function Clockwork.character:FadeOutAll()
	if (IsValid(self.panel)) then
		self.panel:FadeOutAll();
	end;
end;

-- A function to refresh the character panel list.
function Clockwork.character:RefreshPanelList()
	local availableFactions = {};
	local factions = {};
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local fonts = {tinyTextFont, smallTextFont};
	local panel = self:GetPanelList();

	if (panel) then
		panel.panelList:Clear();
		
		for k, v in pairs(self:GetAll()) do
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
		
		panel.label = vgui.Create("DLabel", panel);
		panel.label:SetText("SELECT YOUR VESSEL...");
		panel.label:SetTextColor(Color(255, 255, 255));
		panel.label:SetFont("nov_IntroTextSmallaaafaa");
		panel.label:SizeToContents();
		panel.label:CenterHorizontal();
		panel.panelList:AddItem(panel.label);
		
		panel.characterScroller = vgui.Create("DHorizontalScroller", panel.panelList);
		panel.panelList:AddItem(panel.characterScroller);
	
		panel.characterList = vgui.Create("DPanelList", panel.characterScroller);
		panel.characterList:SetDrawBackground(false);
		panel.characterList:EnableHorizontal(true);
		panel.characterList:SetSpacing(10);
		panel.characterScroller:AddPanel(panel.characterList);
		
		for i = 1, #factions do
			for k, v in pairs(factions[i].characters) do
				if !v.permakilled then
					-- todo: make a hook that makes this cleaner instead of doing everything here
					panel.customData = {
						name = v.name,
						model = v.model,
						gender = v.gender,
						weapons = v.weapons,
						skin = tonumber(v.skin) or 0,
						banned = v.banned,
						faction = v.faction,
						subfaction = v.subfaction,
						details = v.details,
						characterID = v.characterID,
						characterTable = v,
						charTable = v,
					};
					
					hook.Run("PlayerAdjustCharacterScreenInfo", v, panel.customData);

					v.panel = vgui.Create("cwCharacterPanel", panel);
					
					table.insert(panel.characterForms, v.panel);
					
					if (IsValid(v.panel)) then
						panel.characterList:AddItem(v.panel);
					end;
				end
			end;
		end
		
		local smallTextFont = Clockwork.option:GetFont("menu_text_small");
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "RETURN");
		
		panel.cancelButton = vgui.Create("cwLabelButton", panel);
		panel.cancelButton:SetFont(smallTextFont);
		panel.cancelButton:SetText("RETURN");
		panel.cancelButton:SetCallback(function(panel)
			Clockwork.character:GetPanel():ReturnToMainMenu();
		end);
		panel.cancelButton:SizeToContents();
		panel.cancelButton:SetPos(ScrW() * 0.25 - (panel.cancelButton:GetWide() / 2), ScrH() * 0.925);
		panel.cancelButton:SetMouseInputEnabled(true);
		panel.cancelButton.bStartFaded = true;
		
		function panel.cancelButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"RETURN", "rEtUrN", "ReTuRn"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		panel.necropolisButton = vgui.Create("cwLabelButton", panel);
		panel.necropolisButton:SetFont(smallTextFont);
		panel.necropolisButton:SetText("NECROPOLIS");
		panel.necropolisButton:SetCallback(function(panel)
			self:GetPanel():OpenPanel("cwNecropolis", nil);
		end);
		panel.necropolisButton:SizeToContents();
		panel.necropolisButton:SetPos(ScrW() * 0.5 - (panel.necropolisButton:GetWide() / 2), ScrH() * 0.925);
		panel.necropolisButton:SetMouseInputEnabled(true);
		panel.necropolisButton.bStartFaded = true;
		
		function panel.necropolisButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"NECROPOLIS", "nEcRoPoLiS", "NeCrOpOlIs"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		panel.enterHellButton = vgui.Create("cwLabelButton", panel);
		panel.enterHellButton:SetFont(smallTextFont);
		panel.enterHellButton:SetText("ENTER HELL");
		panel.enterHellButton:SetCallback(function(panel)
			local valid_characters = {};
			local name = Clockwork.Client:Name(true);
			
			for i, v in ipairs(Clockwork.character:GetAll()) do
				if !v.permakilled and v.name ~= name then
					table.insert(valid_characters, i);
				end
			end
			
			if !table.IsEmpty(valid_characters) then
				local random_character = valid_characters[math.random(1, #valid_characters)];
				
				if random_character then
					netstream.Start("InteractCharacter", {
						characterID = random_character, action = "use"}
					);
					
					surface.PlaySound("begotten/ui/buttonclick.wav");
				end
			end
		end);
		panel.enterHellButton:SizeToContents();
		panel.enterHellButton:SetPos(ScrW() * 0.75 - (panel.enterHellButton:GetWide() / 2), ScrH() * 0.925);
		panel.enterHellButton:SetMouseInputEnabled(true);
		panel.enterHellButton.bStartFaded = true;
		
		function panel.enterHellButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"ENTER HELL", "eNtEr HeLl", "EnTeR hElL"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		
		local listSize = #panel.characterList:GetItems() * 383;
		
		if listSize > ScrW() then
			listSize = ScrW();
		end
		
		panel.characterScroller:SetSize(listSize, 654);
		panel.characterList:SetSize(#panel.characterList:GetItems() * 383, 654);
	end;
end;

Clockwork.character.listWidth = 0;

-- A function to set the list width.
function Clockwork.character:SetListWidth(listWidth, force)
	if ((listWidth > Clockwork.character:GetListWidth()) or force) then
		Clockwork.character.listWidth = listWidth;
	end;
end;

-- A function to get the list width.
function Clockwork.character:GetListWidth(realWidth)
	return math.max(Clockwork.character.listWidth, ScrW() / 6);
end;

-- A function to get whether the character panel is open.
function Clockwork.character:IsPanelOpen()
	return self.isOpen;
end;

-- A function to set the character panel to the main menu.
function Clockwork.character:SetPanelMainMenu()
	local panel = self:GetPanel();
	
	if (panel) then
		panel:ReturnToMainMenu();
	end;
end;

-- A function to set whether the character panel is polling.
function Clockwork.character:SetPanelPolling(polling)
	self.isPolling = polling;
end;

-- A function to get whether the character panel is polling.
function Clockwork.character:IsPanelPolling()
	return self.isPolling;
end;

-- A function to set whether the character panel is open.
function Clockwork.character:SetPanelOpen(open, bReset)
	local panel = self:GetPanel();
	
	Clockwork.Client.SelectedFaction = nil;
	
	if (!open) then
		if (!bReset) then
			self.isOpen = false;
		else
			self.isOpen = true;
		end;
		
		if (panel) then
			panel:ReturnToMainMenu();
			panel:SetVisible(self:IsPanelOpen());
		end;
		
		hook.Run("CharacterPanelClosed");
	elseif (panel) then
		panel:SetVisible(true);
		panel.createTime = SysTime();
		self.isOpen = true;
	else
		self:SetPanelPolling(true);
	end;
	
	gui.EnableScreenClicker(self:IsPanelOpen());
end;

-- A function to add a character.
function Clockwork.character:Add(characterID, data)
	self.stored[characterID] = data;
end;