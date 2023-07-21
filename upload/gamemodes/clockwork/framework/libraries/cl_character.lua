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
		
		Clockwork.datastream:Start("CreateCharacter", info);
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
					panel.customData = {
						name = v.name,
						model = v.model,
						clothes = v.clothes,
						helmet = v.helmet,
						shield = v.shield,
						weapons = v.weapons,
						skin = tonumber(v.skin) or 0,
						banned = v.banned,
						faction = v.faction,
						subfaction = v.subfaction,
						faith = v.faith,
						subfaith = v.subfaith,
						level = v.level or 1,
						location = v.location,
						timesurvived = v.timesurvived,
						details = v.details,
						characterID = v.characterID,
						characterTable = v,
						charTable = v,
					};

					v.panel = vgui.Create("cwCharacterPanel", panel);
					
					table.insert(panel.characterForms, v.panel);
					
					if (IsValid(v.panel)) then
						panel.characterList:AddItem(v.panel);
					end;
				end
			end;
		end
		
		local smallTextFont = Clockwork.option:GetFont("menu_text_small");
		local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "SUFFER");
		
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
			Clockwork.character:GetPanel():ReturnToMainMenu();
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

-- A function to get whether the character menu is reset.
function Clockwork.character:IsMenuReset()
	return self.isMenuReset;
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

-- Names for random name selection.
FORENAMES_GLAZIC = {
	["male"] = {"Abraham", "Aaron", "Adam", "Alan", "Albert", "Alfred", "Alexander", "Atticus", "Andrew", "Anthony", "Angus", "Allen", "Alvin", "Albert", "Ambrose", "Arnold", "Arthur", "Buford", "Benjamin", "Benedict", "Bernard", "Brigham", "Braxton", "Barnabas", "Boxer", "Charles", "Christopher", "Clarence", "Clark", "Clayton", "Calvin", "Chester", "Cornelius", "David", "Donald", "Daniel", "Duncan", "Elias", "Eric", "Eugene", "Eustace", "Ernest", "Edward", "Earl", "Francis", "George", "Gregory", "Gerald", "Grover", "Gordon", "Hector", "Harold", "Horatio", "Henry", "Isaac", "Ian", "Joseph", "Jeffrey", "John", "Jonathan", "Jebediah", "James", "Jacob", "Julius", "Julian", "Justin", "Josiah", "Joshua", "Karmine", "Leonard", "Louis", "Lawrence", "Leland", "Lucas", "Lionel", "Lamont", "Lyman", "Magnus", "Moses", "Michael", "Michelangelo", "Marcus", "Martin", "Milton", "Nathaniel", "Noah", "Nicholas", "Oliver", "Obadiah", "Odysseus", "Orville", "Owen", "Philip", "Peter", "Paul", "Patrick", "Reginald", "Robert", "Richard", "Ronald", "Rufus", "Rhett", "Samuel", "Scott", "Stephen", "Sampson", "Sylvester", "Theodore", "Thomas", "Timothy", "Upton", "Ulysses", "Victor", "Vincent", "William", "Walter", "Wilbur", "Wallace", "Wyatt", "Zachary"},
	["female"] = {"Adela", "Adriana", "Alice", "Amelia", "Anna", "Audrey", "Autumn", "Aveline", "Beatrice", "Caroline", "Catherine", "Cecilia", "Daisy", "Dawn", "Ella", "Eleanor", "Elizabeth", "Emma", "Gloria", "Grace", "Heather", "Helen", "Isabel", "Isabella", "Jennifer", "Joan", "Joanna", "Julia", "Juliana", "Laura", "Livia", "Madeline", "Margaret", "Maria", "Mary", "Olympia", "Scarlett", "Sarah", "Silvia", "Sophia", "Susanna", "Sybilla", "Theodora", "Victoria", "Virginia", "Valeria", "Zelda"}
};

SURNAMES_GLAZIC = {
	"Abriallias", "Aelius", "Anderson", "Antonius", "Appius", "Arcadius", "Armstrong", "Armistead", "Aetius", "Aurelius", "Bateman", "Barclay", "Brutus", "Buchanan", "Caecilius", "Carrinas", "Cassius", "Clemens", "Cornelius", "Chamberlain", "Cranston", "Crassus", "Crawford", "Decimius", "Dilworth", "Domitius", "Fabius", "Flavius", "Franklin", "Fulvius", "Galerius", "Hamilton", "Harris", "Harvus", "Honorius", "Horatius", "Julius", "Jupiter", "Koulius", "Krammy", "Labienus", "Lincoln", "Marius", "Morgan", "Morris", "Nasennius", "Oswald", "Opimius", "Patrobius", "Parker", "Petronius", "Philadelphus", "Pompeius", "Quinctius", "Randolph", "Roberts", "Rufinius", "Septimius", "Severus", "Simmons", "Sheridan", "Stevens", "Stuart", "Sullivan", "Suetonius", "Taylor", "Temple", "Thompson", "Titus", "Tullius", "Tyler", "Valerius", "Vorenus", "Wales", "Wilkes"
};

FORENAMES_GOREIC = {
	["male"] = {"Ale", "Alfr", "Alfgeir", "Anders", "Anlaufr", "Anundr", "Arnbjörn", "Arngrimr", "Arni", "Arnfast", "Asbjörn", "Bagge", "Baldr", "Barid", "Bengt", "Bersi", "Bertil", "Birger", "Björn", "Bo", "Borkvard", "Botulfr", "Bragi", "Buðli", "Dag", "Dan", "Dyre", "Eilif", "Egill", "Emund", "Einarr", "Eirikr", "Eskild", "Falki", "Faste", "Filip", "Fredrik", "Frirek", "Froði", "Freyr", "Folki", "Gandalfr", "Geirr", "Georg", "Gnupa", "Gorm", "Greger", "Grimr", "Guðfrið", "Guðmundr", "Guðröðr", "Gunnarr", "Hakon", "Halsten", "Haraldr", "Haukr", "Helgi", "Hemming", "Holmger", "Hrafn", "Hrolfr", "Hrane", "Hæsteinn", "Hjalmar", "Hroðgar", "Hroðulfr", "Hrörekr", "Hysing", "Ingólfr", "Ingemar", "Ingjald", "Ivar", "Jedvard", "Jon", "Karl", "Kettil", "Kettilmund", "Kjartan", "Klas", "Knut", "Kol", "Kolbjörn", "Magnus", "Markus", "Magni", "Mats", "Nils", "Niklas", "Oddr", "Ofeig", "Olafr", "Ormr", "Ottarr", "Refr", "Refil", "Ragnarr", "Rikulfr", "Rögnvaldr", "Skuli", "Snorri", "Sigbjörn", "Sigtrygg", "Sigurðr", "Starkaðr", "Steinn", "Sturla", "Styrbjörn", "Styrkar", "Sumarliði", "Suni", "Sveinn", "Sverker", "Sæmundr", "Sölvi", "Sörkver", "Tjudmund", "Toke", "Tolir", "Þorbjörn", "Þorfinn", "Þorbrandr", "Þordr", "Þorgil", "Þorsteinn", "Þorolfr", "Toste", "Totil", "Tryggve", "Tyke", "Ulfr", "Vagn", "Valdemar", "Åke", "Yngvar", "Örvar", "Öysteinn"},
	["female"] = {"Aleta", "Alfhildr", "Alfrið", "Alvör", "Anna", "Asa", "Aslaug", "Asta", "Astrid", "Beata", "Birgitta", "Björg", "Bodil", "Bothildr", "Cecilia", "Edla", "Elin", "Elisabet", "Freyja", "Gerðr", "Gloð", "Grima", "Gunnhildr", "Gurli", "Guðrun", "Gyla", "Gyrið", "Gyða", "Hafrid", "Halla", "Helena", "Holmfrid", "Iliana", "Inga", "Ingfrid", "Ingibjörg", "Ingjerðr", "Ingrid", "Karin", "Katarina", "Kraka", "Kristina", "Linda", "Maer", "Malmfrið", "Margareta", "Maria", "Rikissa", "Rögnfrið", "Rögnhildr", "Saga", "Sara", "Sif", "Sigrid", "Skuld", "Sofia", "Svanhildr", "Ulfhildr", "Vigdis", "Ylva", "Yrsa"}
};

SURNAMES_GOREIC = {
	"Askelsson", "Axel", "Bengtsson", "Björnsson", "Borgesson", "Bundersson", "Ericsson", "Erling", "Eskelsson", "Estensson", "Fredriksson", "Glazkill", "Gustavsson", "Guttormsson", "Haldorsson", "Haralder", "Helgasson", "Helvig", "Heskin", "Hexum", "Hohlt", "Jostad", "Junge", "Kaase", "Karsten", "Klingenberg", "Knudtson", "Krogh", "Leif", "Lorensson", "Mathiesson", "Nygaard", "Nylund", "Ohlsson", "Olafsson", "Skau", "Thostensson", "Torgrimsson", "Tostensson", "Westergaard"
};