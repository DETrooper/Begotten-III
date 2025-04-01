--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle(cwFactionStorage.activeName or "Container")
	self:SetBackgroundBlur(true)
	self:SetDeleteOnClose(false)

	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		CloseDermaMenus()
		self:Close() self:Remove()

		netstream.Start("FactionStorageAdd", {
			factions = cwFactionStorage.factions,
			subfactions = cwFactionStorage.subfactions,
			subfaiths = cwFactionStorage.subfaiths,
			ranks = cwFactionStorage.ranks,
		})

		cwFactionStorage.factions = nil
		cwFactionStorage.subfactions = nil
		cwFactionStorage.subfaiths = nil
		cwFactionStorage.ranks = nil

		gui.EnableScreenClicker(false)
	end

	self.settingsPanel = vgui.Create("cwPanelList")
 	self.settingsPanel:SetPadding(2)
 	self.settingsPanel:SetSpacing(3)
 	self.settingsPanel:SizeToContents()
	self.settingsPanel:EnableVerticalScrollbar()
	self.settingsPanel.Paint = function(sp, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200))
	end

	self.settingsForm = vgui.Create("cwForm")
	self.settingsForm:SetPadding(4)
	self.settingsForm:SetName("Settings")

	self.settingsPanel:AddItem(self.settingsForm)

	self.factionsForm = vgui.Create("DForm");
	self.factionsForm:SetPadding(4);
	self.factionsForm:SetName("Factions");
	self.factionsForm:Help("Leave these unchecked to allow all factions to open the container.");
	self.settingsForm:AddItem(self.factionsForm);
	
	self.subfactionsForm = vgui.Create("DForm");
	self.subfactionsForm:SetPadding(4);
	self.subfactionsForm:SetName("Subfactions");
	self.subfactionsForm:Help("Leave these unchecked to allow all subfactions to open the container.");
	self.settingsForm:AddItem(self.subfactionsForm);

	self.factionBoxes = {}
	self.subfactionBoxes = {}
	
	if Schema.Ranks then
		self.ranksForm = vgui.Create("DForm");
		self.ranksForm:SetPadding(4);
		self.ranksForm:SetName("Ranks");
		self.ranksForm:Help("Leave these unchecked to allow all ranks to open the container.");
		self.settingsForm:AddItem(self.ranksForm);
		
		self.rankBoxes = {};
	end
	
	if Schema.faiths then
		self.subfaithsForm = vgui.Create("DForm");
		self.subfaithsForm:SetPadding(4);
		self.subfaithsForm:SetName("Subfaiths");
		self.subfaithsForm:Help("Leave these unchecked to allow all subfaiths to open the container.");
		self.settingsForm:AddItem(self.subfaithsForm);
	
		self.subfaithBoxes = {}
	end

	for k, v in SortedPairs(Clockwork.faction:GetStored()) do
		self.factionBoxes[k] = self.factionsForm:CheckBox(v.name)
		self.factionBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				cwFactionStorage.factions[k] = true
			else
				cwFactionStorage.factions[k] = nil
			end
		end

		if (cwFactionStorage.factions[k]) then
			self.factionBoxes[k]:SetValue(true)
		end
		
		local subfactions = v.subfactions;
		
		if subfactions then
			for i, v2 in ipairs(subfactions) do
				self.subfactionBoxes[v2.name] = self.subfactionsForm:CheckBox(v2.name);
				self.subfactionBoxes[v2.name].OnChange = function(checkBox)
					if (checkBox:GetChecked()) then
						cwFactionStorage.subfactions[v2.name] = true
					else
						cwFactionStorage.subfactions[v2.name] = nil
					end
				end
				
				if (cwFactionStorage.subfactions[v2.name]) then
					self.subfactionBoxes[v2.name]:SetValue(true)
				end
			end
		end
		
		if Schema.Ranks then
			local ranks = Schema.Ranks[v.name];
			
			if ranks then
				for i, v2 in ipairs(ranks) do
					self.rankBoxes[v2] = self.ranksForm:CheckBox(v2);
					self.rankBoxes[v2].OnChange = function(checkBox)
						if (checkBox:GetChecked()) then
							cwFactionStorage.ranks[v2] = true
						else
							cwFactionStorage.ranks[v2] = nil
						end
					end
					
					if (cwFactionStorage.ranks[v2]) then
						self.rankBoxes[v2]:SetValue(true)
					end
				end
			end
		end
	end
	
	if Schema.faiths then
		for k, v in pairs(Schema.faiths:GetFaiths()) do
			if v.subfaiths then
				for i, subfaith in ipairs(v.subfaiths) do
					self.subfaithBoxes[subfaith] = self.subfaithsForm:CheckBox(subfaith);
					self.subfaithBoxes[subfaith].OnChange = function(checkBox)
						if (checkBox:GetChecked()) then
							cwFactionStorage.subfaiths[subfaith] = true
						else
							cwFactionStorage.subfaiths[subfaith] = nil
						end
					end
					
					if (cwFactionStorage.subfaiths[subfaith]) then
						self.subfaithBoxes[subfaith]:SetValue(true)
					end
				end
			end
		end
	end

	self.propertySheet = vgui.Create("DPropertySheet", self);
		self.propertySheet:SetPadding(4);
		self.propertySheet:AddSheet("Settings", self.settingsPanel, "icon16/tick.png");
	Clockwork.kernel:SetNoticePanel(self);
end

-- Called each frame.
function PANEL:Think()
	self:SetSize(ScrW() * 0.5, ScrH() * 0.75)
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))
end

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self)

	if (self.propertySheet) then
		self.propertySheet:StretchToParent(4, 28, 4, 4)
	end
end

vgui.Register("cwFactionStorage", PANEL, "DFrame")