--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());
	
	self.treeNode = vgui.Create("DTree", self);
	self.treeNode:SetPadding(2);
	self.htmlPanel = vgui.Create("HTML", self);
	
	Clockwork.directory.panel = self;
	Clockwork.directory.panel.categoryHistory = {};
	
	self:Rebuild();
end;

-- A function to show a directory category.
function PANEL:ShowCategory(category)
	if (!category) then
		local masterFormatting = Clockwork.directory:GetMasterFormatting();
		local finalCode = [[
			<div class="auraInfoTitle">SELECT A CATEGORY</div>
			<div class="auraInfoText">
				Some categories may only be available to users with special priviledges.
			</div>
		]];
		
		if (masterFormatting) then
			finalCode = Clockwork.kernel:Replace(masterFormatting, "{information}", finalCode);
		end;
		
		finalCode = Clockwork.kernel:Replace(finalCode, "[category]", "Directory");
		finalCode = Clockwork.kernel:Replace(finalCode, "{category}", "DIRECTORY");
		finalCode = Clockwork.kernel:ParseData(finalCode);
		
		self.htmlPanel:SetHTML(finalCode);
	else
		local categoryTable = Clockwork.directory:GetCategory(category);
		
		if (categoryTable) then
			if (!categoryTable.isHTML) then
				local newPageData = {};
				
				for k, v in pairs(categoryTable.pageData) do
					newPageData[#newPageData + 1] = v;
				end;
				
				local sorting = Clockwork.directory:GetCategorySorting(category);
				
				if (sorting) then
					table.sort(newPageData, sorting);
				end;
				
				if (table.Count(newPageData) > 0) then
					local masterFormatting = Clockwork.directory:GetMasterFormatting();
					local formatting = Clockwork.directory:GetCategoryFormatting(category);
					local firstKey = true;
					local finalCode = "";
				
					for k, v in pairs(newPageData) do
						local htmlCode = v.htmlCode;
						
						if (type(v.Callback) == "function") then
							htmlCode = v.Callback(htmlCode, v.sortData);
						end;
						
						if (htmlCode and htmlCode != "") then
							if (!firstKey) then
								if ((!formatting or !formatting.noLineBreaks) and !v.noLineBreak) then
									finalCode = finalCode.."<br>"..htmlCode;
								else
									finalCode = finalCode..htmlCode;
								end;
							else
								finalCode = htmlCode;
							end;
							
							firstKey = false;
						end;
					end;
					
					if (formatting) then
						finalCode = Clockwork.kernel:Replace(formatting.htmlCode, "{information}", finalCode);
					end;
					
					if (masterFormatting) then
						finalCode = Clockwork.kernel:Replace(masterFormatting, "{information}", finalCode);
					end;
					
					finalCode = Clockwork.kernel:Replace(finalCode, "[category]", category);
					finalCode = Clockwork.kernel:Replace(finalCode, "{category}", string.upper(category));
					finalCode = Clockwork.kernel:ParseData(finalCode);
					
					self.htmlPanel:SetHTML(finalCode);
				end;
			elseif (!categoryTable.isWebsite) then
				local masterFormatting = Clockwork.directory:GetMasterFormatting();
				local formatting = Clockwork.directory:GetCategoryFormatting(category);
				local finalCode = categoryTable.pageData;
				
				if (formatting) then
					finalCode = Clockwork.kernel:Replace(formatting.htmlCode, "{information}", finalCode);
				end;
				
				if (masterFormatting) then
					finalCode = Clockwork.kernel:Replace(masterFormatting, "{information}", finalCode);
				end;
				
				finalCode = Clockwork.kernel:Replace(finalCode, "[category]", category);
				finalCode = Clockwork.kernel:Replace(finalCode, "{category}", string.upper(category));
				finalCode = Clockwork.kernel:ParseData(finalCode);
				
				self.htmlPanel:SetHTML(finalCode);
			else
				self.htmlPanel:OpenURL(categoryTable.pageData);
			end;
		end;
	end;
end;

-- A function to clear the nodes.
function PANEL:ClearNodes()
	if (self.treeNode.Items) then
		for k, v in pairs(self.treeNode.Items) do
			if (IsValid(v)) then v:Remove(); end;
		end;
	end;
	
	self.treeNode.m_pSelectedItem = nil;
	self.treeNode.Items = {};
end;

local CW_REBUILDING_DIRECTORY;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	if (!CW_REBUILDING_DIRECTORY) then
		self:ClearNodes();
		
		CW_REBUILDING_DIRECTORY = true;
			Clockwork.plugin:Call("ClockworkDirectoryRebuilt", self);
		CW_REBUILDING_DIRECTORY = nil;
		
		Clockwork.kernel:ValidateTableKeys(Clockwork.directory.stored);
		
		table.sort(Clockwork.directory.stored, function(a, b)
			return a.category < b.category;
		end);
		
		local nodeTable = {};
		
		for k, v in pairs(Clockwork.directory.stored) do
			if (!v.parent) and (!v.adminOnly or Clockwork.Client:IsAdmin()) then
				nodeTable[v.category] = self.treeNode:AddNode(v.category);
				nodeTable[v.category]:SetExpanded(true, true);
			end;
		end;
		
		for k, v in pairs(Clockwork.directory.stored) do
			if (v.adminOnly and !Clockwork.Client:IsAdmin()) then continue end;
			
			if (v.parent and nodeTable[v.parent]) then
				nodeTable[v.category] = nodeTable[v.parent]:AddNode(v.category);
			elseif (!nodeTable[v.category]) then
				nodeTable[v.category] = self.treeNode:AddNode(v.category);
				nodeTable[v.category]:SetExpanded(true, true);
			end;
			
			if (!nodeTable[v.category].Initialized) then
				local friendlyName = Clockwork.directory:GetFriendlyName(v.category);
				local tip = Clockwork.directory:GetCategoryTip(v.category);
				
				if (tip) then
					nodeTable[v.category]:SetToolTip(tip);
				end;
				
				nodeTable[v.category].Initialized = true;
				nodeTable[v.category]:SetText(friendlyName);
				nodeTable[v.category].DoClick = function(node)
					for k2, v2 in pairs(Clockwork.directory.stored) do
						if (v2.category == v.category and (v2.isWebsite
						or v2.isHTML or #v2.pageData > 0)) then
							self.currentCategory = v.category;
							self:ShowCategory(self.currentCategory);
							
							break;
						end;
					end;
				end;
			end;
		end;
		
		self:ShowCategory(self.currentCategory);
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetSize(self:GetWide(), ScrH() * 0.75);
	self.treeNode:SetPos(4, 28);
	self.treeNode:SetSize(self:GetWide() * 0.2, self:GetTall() - 36);
	self.htmlPanel:SetPos((self:GetWide() * 0.2) + 8, 28);
	self.htmlPanel:SetSize((self:GetWide() * 0.8) - 16, self:GetTall() - 36);
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

vgui.Register("cwDirectory", PANEL, "EditablePanel");