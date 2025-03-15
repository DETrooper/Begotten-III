--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local IsValid = IsValid;
local pairs = pairs;
local ScrH = ScrH;
local ScrW = ScrW;
local table = table;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(2);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear();
	
	local availableCategories = {};
	local categories = {};
	
	for k, v in pairs(Clockwork.setting.stored) do
		if (!v.Condition or v.Condition()) then
			local category = v.category;
			
			if (!availableCategories[category]) then
				availableCategories[category] = {};
			end;
			
			availableCategories[category][#availableCategories[category] + 1] = v;
		end;
	end;
	
	for k, v in pairs(availableCategories) do
		table.sort(v, function(a, b)
			if (a.class == b.class) then
				return a.text < b.text;
			else
				return a.class < b.class;
			end;
		end);
		
		categories[#categories + 1] = {category = k, settings = v};
	end;
	
	table.sort(categories, function(a, b)
		return a.category < b.category;
	end);
	
	if (table.Count(categories) > 0) then
		--[[local label = vgui.Create("cwInfoText", self);
			label:SetText("These settings are client-side to help you personalise Clockwork.");
			label:SetInfoColor("blue");
		self.panelList:AddItem(label);]]
		
		for k, v in pairs(categories) do
			local form = vgui.Create("DForm");
				self.panelList:AddItem(form);
			form:SetName(v.category);
			form:SetPadding(4);
			
			for k2, v2 in pairs(v.settings) do
				local panel;
			
				if (v2.class == "numberSlider") then
					panel = form:NumSlider(v2.text, v2.conVar, v2.minimum, v2.maximum, v2.decimals);
					panel.Label:SetFont("begotsettingsfont2")
					panel:SetTall(25)
				elseif (v2.class == "multiChoice") then
					panel = form:Help(v2.text);
					panel:SetFont("begotsettingsfont2")
					panel.convar = v2.conVar;
					panel.options = {};
					panel.Think = function(panel)
						for i, v in ipairs(panel.options) do
							local numValue = GetConVarNumber(v.Button.m_strConVar)
							
							if v.index == numValue then
								if !v:GetChecked() then
									v:SetChecked(true);
								end
							elseif v:GetChecked() then
								v:SetChecked(false);
								v:OnChange(false);
								v:SetCookie("checked", false);
							end
						end
					end
					
					for i, v3 in ipairs(v2.options) do
						local checkBox = form:CheckBox(v3[1], v2.conVar);
						
						checkBox.index = i - 1;
						checkBox:SetFont("begotsettingsfont2");
						checkBox.Button:SetToolTip(v3[2]);
						checkBox.Button.SetValue = function(button, val)
							if (tonumber(val) == 0) then val = 0 end -- Tobool bugs out with "0.00"
							val = tobool(val)

							button:SetChecked(val)
							button.m_bValue = val

							button:OnChange(val)

							if (val) then val = "1" else val = "0" end
							
							if val == "1" then
								button:ConVarChanged(tostring(button:GetParent().index));
							else
								button:ConVarChanged("0");
							end
							
							button:SetCookie("checked", val)
						end
						
						checkBox.Button.ConVarStringThink = function()

						end

						checkBox.Button.ConVarNumberThink = function()

						end
						
						checkBox:SetIndent(16);
						
						table.insert(panel.options, checkBox);
					end;
					
					--[[panel = form:ComboBox(v2.text, v2.conVar);
					
					for k3, v3 in pairs(v2.options) do
						panel:AddChoice(v3);
					end;]]--
				elseif (v2.class == "numberWang") then
					panel = form:NumberWang(v2.text, v2.conVar, v2.minimum, v2.maximum, v2.decimals);
				elseif (v2.class == "textEntry") then
					panel = form:TextEntry(v2.text, v2.conVar);
				elseif (v2.class == "checkBox") then
					panel = form:CheckBox(v2.text, v2.conVar);
					panel:SetFont("begotsettingsfont2")
				elseif (v2.class == "bind") then
					local bindPanel = vgui.Create("DPanel");
					
					bindPanel:SetSize(500, 24);
					
					local bindLabel = vgui.Create("DLabel", bindPanel);
					bindLabel:SetText(v2.text);
					bindLabel:SetFont("begotsettingsfont2");
					bindLabel:SizeToContents();
					bindLabel:CenterVertical();
					
					local binder = vgui.Create("DBinder", bindPanel);
					binder:SetX(bindLabel:GetWide() + 2);
					binder:SetSize(100, 24);
					binder.conVar = v2.conVar;
					
					local conVar = GetConVar(v2.conVar);
					
					if conVar and conVar:GetInt() ~= 0 then
						binder:SetValue(conVar:GetInt());
					end
					
					function binder:OnChange(num)
						local conVar = GetConVar(self.conVar);
						
						if conVar then
							conVar:SetInt(num);
						end
					end
					
					bindPanel:SetWide(bindLabel:GetWide() + binder:GetWide() + 4);
					
					panel = form:AddItem(bindPanel);
				else
					local classPanel = vgui.Create(v2.class);
					
					if classPanel then
						hook.Run("SetupSettingsCustomPanel", v.category, v2.text, classPanel);
					
						panel = form:AddItem(classPanel);
					end
				end;
				
				if (IsValid(panel)) then
					if (v2.class == "checkBox") then
						panel.Button:SetToolTip(v2.toolTip);
					else
						panel:SetToolTip(v2.toolTip);
					end;
				end;
			end;
		end;
	else
		local label = vgui.Create("cwInfoText", self);
			label:SetText("You do not have access to any settings!");
			label:SetInfoColor("red");
		self.panelList:AddItem(label);
	end;
	
	self.panelList:InvalidateLayout(true);
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:IsPanelActive(self)) then
		self:Rebuild();
	end;
end;

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.panelList:StretchToParent(4, 28, 4, 4);
	self:SetSize(w, math.min(self.panelList.pnlCanvas:GetTall() + 32, ScrH() * 0.75));
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h);
	
	return true;
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwSettings", PANEL, "EditablePanel");