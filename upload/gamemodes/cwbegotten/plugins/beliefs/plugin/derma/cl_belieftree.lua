--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

if (IsValid(Clockwork.Client.cwBeliefPanel)) then
	Clockwork.Client.cwBeliefPanel:Close()
	Clockwork.Client.cwBeliefPanel:Remove()
end

local gradientDown = surface.GetTextureID("gui/gradient_down")
local topBackground = Material("begotten/ui/oilcanvas.png")
local topFrame = Material("begotten/ui/panelframe.png")
local bottomBackground = Material("begotten/ui/collapsible3-1-10.png")
local bottomFrame = Material("begotten/ui/panelframe88.png")

local HardLocked = Color(100, 100, 100, 150) -- i.e. locked via trait
local Locked = Color(160, 100, 100, 235)
local Unlockable = Color(160, 120, 90, 230)
local Unlocked = Color(180, 175, 150, 250)

local PANEL = {}

-- ROMAN NUMERAL SHIT MOVE TO ANOTHER FILE LATER

local map = { 
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100, 
    D = 500, 
    M = 1000,
}
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

local RomanNumerals = {
    map = {
        [1000] = "M",
        [900] = "CM",
        [500] = "D",
        [400] = "CD",
        [100] = "C",
        [90] = "XC",
        [50] = "L",
        [40] = "XL",
        [10] = "X",
        [9] = "IX",
        [5] = "V",
        [4] = "IV",
        [1] = "I"
    }
}

function RomanNumerals.ToRomanNumerals(s)
    s = tonumber(s)
    if not s or s ~= s then error "Unable to convert to number" end
    if s == math.huge then error "Unable to convert infinity" end
    s = math.floor(s)

    local ret = ""
    for num, char in pairs(RomanNumerals.map) do
        while s >= num do
            ret = ret .. char
            s = s - num
        end
    end

    return ret
end

function RomanNumerals.ToNumber(s)
    local map = {
        I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000,
    }

    s = s:upper()
    local ret = 0
    local prevValue = 0

    for i = #s, 1, -1 do -- Traverse the string from right to left
        local c = s:sub(i, i)
        local m = map[c]

        if not m then
            error("Unknown Roman Numeral '" .. c .. "'")
        end

        if m < prevValue then
            ret = ret - m
        else
            ret = ret + m
            prevValue = m
        end
    end

    return ret
end

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
	local DRAW_BAR = true
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
	
	if (!self.beliefTable) then
		return
	end

	if (DRAW_BAR) then
		if (!self.barValuesSet) then
			local closeButtonWide = self.closeButton:GetWide()
			local closeButtonTall = self.closeButton:GetTall()

			self.barX = 14 + closeButtonWide + 8
			self.barY = 928 - (8 + closeButtonTall)
			
			if self.level < cwBeliefs.localLevelCap then
				self.barWidth = math.Remap(math.Clamp(self.experience, 0, cwBeliefs.sacramentCosts[self.level + 1] or 666), 0, cwBeliefs.sacramentCosts[self.level + 1] or 666, 0, 512)
			else
				self.barWidth = 512;
			end
			
			self.barValuesSet = true
		end
		
		local DRAW_BARBACKGROUND = true
		local DRAW_BARFOREGROUND = true
		
		if (DRAW_BARBACKGROUND) then
			draw.RoundedBox(4, self.barX, self.barY, 512, 32, Color(30, 30, 30))
			surface.SetDrawColor(15, 5, 0, 200)
			surface.SetTexture(gradientDown)
			surface.DrawTexturedRect(self.barX + 2, self.barY + 2, 508, 28)
		end
		
		if (DRAW_BARFOREGROUND) then
			draw.RoundedBox(4, (self.barX) + 4, (self.barY) + 4, self.barWidth - 8, 24, Color(140, 0, 0))
			surface.SetDrawColor(75, 0, 0, 255)
			surface.SetTexture(gradientDown)
			surface.DrawTexturedRect((self.barX) + 4, (self.barY) + 4, self.barWidth - 8, 24)
		end
		
		if (!self.levelNumeral) then
			self.levelNumeral = RomanNumerals.ToRomanNumerals(self.level)
		end
		
		--[[if (self.experience < (cwBeliefs.sacramentCosts[self.level + 1] or 666) / 2) then
			draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barWidth + (self.barX) + 4 + 4, ((self.barY) + 4), Color(200, 0, 0))
			draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barWidth + (self.barX) + 6 + 4, ((self.barY) + 4) + 2, Color(0, 0, 0, 150))
		else
			draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", (256 - 8) + (self.barX) + 6 + 4, ((self.barY) + 4) + 2, Color(150, 0, 0, 200))
			draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", (256 - 8) + (self.barX) + 4 + 4, ((self.barY) + 4), Color(0, 0, 0, 255))
		end]]--
		
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barX + 8, self.barY + 4, Color(200, 0, 0))
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barX + 10, self.barY + 6, Color(0, 0, 0, 150))
		
		if (self.points <= 0) then
			draw.SimpleText("YOU HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("YOU HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		else
			local epiphany = "EPIPHANY"
			
			if (self.points > 1) then
				epiphany = "EPIPHANIES"
			end

			draw.SimpleText("YOU HAVE "..self.points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("YOU HAVE "..self.points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		end	
		
		if (!self.sacramentCost) then
			self.sacramentCost = cwBeliefs.sacramentCosts[self.level + 1] or 666;
		end

		draw.SimpleText("Faith Concentrated: "..math.floor(self.experience), "Civ5Tooltip1",(self.barX) + 4 + 16 + 512, ((self.barY) + 3), Color(200, 0, 0, 255))
		draw.SimpleText("Faith Concentrated: "..math.floor(self.experience), "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 5), Color(0, 0, 0, 127))
		
		if self.level < cwBeliefs.localLevelCap then
			draw.SimpleText("Faith Required For Next Epiphany: "..self.sacramentCost, "Civ5Tooltip1", (self.barX) + 4 + 16 + 512, ((self.barY) + 4 + 32), Color(200, 0, 0, 255))
			draw.SimpleText("Faith Required For Next Epiphany: "..self.sacramentCost, "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 6 + 32), Color(0, 0, 0, 127))
		else
			draw.SimpleText("You Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 4 + 16 + 512, ((self.barY) + 4 + 32), Color(200, 0, 0, 255))
			draw.SimpleText("You Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 6 + 32), Color(0, 0, 0, 127))
		end
	end
end

-- A function to add an icon somewhere on the tree.
function PANEL:AddIcon(iconData)
	if (!iconData or type(iconData) != "table") then
		return
	end
	
	local parent = iconData.parent
	
	if (!IsValid(parent)) then
		return
	else
		if (!parent.buttons) then
			parent.buttons = {}
		end
	end

	local beliefs = self.beliefTable
	local uniqueID = iconData.uniqueID
	local texture = iconData.texture or "begotten/ui/belieficons/"..uniqueID..".png";
	local x = iconData.x
	local y = iconData.y
	local width = iconData.width
	local height = iconData.height
	local requirements = iconData.requirements
	local requirementsNiceNames = iconData.requirementsNiceNames
	local lockedsubfactions = iconData.lockedsubfactions
	local lockedfactions = iconData.lockedfactions
	local locked = iconData.locked
	local description = iconData.description
	local quote = iconData.quote;
	local niceName = iconData.niceName
	local disabled = iconData.disabled
	local clickSound = iconData.clickSound or "buttons/button15.wav"
	local errorSound = iconData.errorSound or "buttons/button10.wav"
	
	if (!requirements) then
		requirements = {}
	end
	
	local icon = vgui.Create("DImageButton", parent)
	icon:SetPos(x, y)
	icon:SetSize(width, height)
	icon:SetImage(texture)
	icon:SetColor(Locked)
	icon.trait = uniqueID
	icon.niceName = niceName
	icon.subfaith = iconData.subfaith;
	icon.lockedsubfactions = lockedsubfactions;
	icon.lockedfactions = lockedfactions;
	icon.locked = locked;
	icon.disabled = disabled
	parent.buttons[uniqueID] = icon
	
	local parentUniqueID = parent.uniqueID or "UNDEFINED";
	local parentBeliefs = parent.buttons
	local hasRequirements = table.Count(requirements) > 0
	local subfaith = Clockwork.Client:GetSharedVar("subfaith");
	local hasLoremaster = cwBeliefs:HasBelief("loremaster");
	local hasJack = cwBeliefs:HasBelief("jack_of_all_trades");
	
	-- Called when the button is clicked.
	function icon.DoClick()
		if (beliefs[icon.trait]) then
			--surface.PlaySound(errorSound)
			return
		elseif parent.locked == true or icon.disabled or (parent.lockedsubfactions and table.HasValue(parent.lockedsubfactions, Clockwork.Client:GetSharedVar("subfaction"))) or (icon.lockedsubfactions and table.HasValue(icon.lockedsubfactions, Clockwork.Client:GetSharedVar("subfaction"))) or (icon.lockedfactions and table.HasValue(icon.lockedfactions, Clockwork.Client:GetFaction())) or icon.locked or (parent.uniqueID == "religion" and subfaith and subfaith ~= "" and subfaith ~= "N/A" and icon.subfaith ~= subfaith) then
			return
		elseif parentUniqueID == "prowess" and hasLoremaster or hasJack and table.HasValue(cwBeliefs.tier4Beliefs, uniqueID) then
			return
		end
		
		local meetsRequirements = false;
		
		if self.points > 0 then
			meetsRequirements = true;
		end
		
		if (hasRequirements) then
			for k, v in pairs (requirements) do
				if (beliefs[v]) then
					continue
				else
					meetsRequirements = false
					break
				end
			end
		end
		
		if (meetsRequirements) then
			local hasFinished = true
			
			for k, v in pairs (parent.buttons) do
				if (!beliefs[k]) then
					hasFinished = false;
					
					break;
				end
			end
			
			if (hasFinished) then
				if (parent.finisherUniqueID and parent.finisherNiceName) then
					netstream.Start("TakeBelief", {parent.finisherUniqueID, parent.finisherNiceName})
				end
			end

			netstream.Start("TakeBelief", {icon.trait, icon.niceName, parentUniqueID})
			--surface.PlaySound(clickSound)
	
			--[[local level = Clockwork.Client:GetCharacterData("level", 1)
			local experience = Clockwork.Client:GetCharacterData("experience", 0)
			local points = Clockwork.Client:GetCharacterData("points", 0)]]--
			
			beliefs[icon.trait] = true;
			
			--self:Rebuild(self.level, self.experience, beliefs, self.points - 1);

			--[[if (IsValid(parent.parent)) then
				self:Close()
				self:Remove()
			end]]--
		end
	end
	
	local selectedBad = Color(255, 50, 50, 255);
	local selectedGood = Color(50, 255, 50, 255);
	local selectedNeutral = Color(200, 200, 200, 255);
	
	local canTake = "\nYou can take this belief!"
	local canTakeColor = selectedGood;
	local canUnlock = true
	
	if (beliefs[icon.trait]) then
		canTake = "\nYou already follow this belief!"
		canTakeColor = selectedNeutral;
		icon:SetColor(Unlocked)
	else
		if parent.locked == true or icon.locked then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief tree is locked due to a trait you took!"
			canTakeColor = selectedBad;
		elseif icon.disabled then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief is temporarily disabled until it can be implemented!"
			canTakeColor = selectedBad;
		elseif parentUniqueID == "prowess" and hasLoremaster or hasJack and table.HasValue(cwBeliefs.tier4Beliefs, uniqueID) then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief is locked due to a belief you took!"
			canTakeColor = selectedBad;
		elseif parent.lockedsubfactions and table.HasValue(parent.lockedsubfactions, Clockwork.Client:GetSharedVar("subfaction")) then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief tree is locked due to the subfaction you took!"
			canTakeColor = selectedBad;
		elseif icon.lockedsubfactions and table.HasValue(icon.lockedsubfactions, Clockwork.Client:GetSharedVar("subfaction")) then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief is locked due to the subfaction you took!"
			canTakeColor = selectedBad;
		elseif icon.lockedfactions and table.HasValue(icon.lockedfactions, Clockwork.Client:GetFaction()) then
			icon:SetColor(HardLocked)
			canTake = "\nThis belief is locked due to the faction you took!"
			canTakeColor = selectedBad;
		elseif parent.uniqueID == "religion" and subfaith and subfaith ~= "" and subfaith ~= "N/A" and icon.subfaith ~= subfaith then
			icon:SetColor(HardLocked)
			canTake = "\nYou have already selected a subfaith!"
			canTakeColor = selectedBad;
		elseif (hasRequirements) then
			for k, v in pairs (requirements) do
				if (!beliefs[v]) then
					canUnlock = false
					break
				end
			end
			
			if (canUnlock) then
				if (self.points <= 0) then
					canTake = "\nYou do not have any epiphanies to spend on this belief!"
					canTakeColor = selectedBad;
					icon:SetColor(Locked)
				else
					icon:SetColor(Unlockable)
				end
			else
				if (self.points <= 0) then
					canTake = "\nYou have no epiphanies and do not meet the requirements for this belief!"
				else
					canTake = "\nYou do not meet the requirements for this belief!"
				end
				
				canTakeColor = selectedBad;
				icon:SetColor(Locked)
			end
		else
			if (self.points <= 0) then
				canTake = "\nYou do not have any epiphanies to spend on this belief!"
				canTakeColor = selectedBad;
				icon:SetColor(Locked)
			else
				icon:SetColor(Unlockable)
			end
		end
	end
	
	Clockwork.kernel:CreateDermaToolTip(icon)
	
	local tooltip = function(frame)
		frame:AddText(niceName, parent.color, "Civ5ToolTi3");
		frame:AddText(description, Color(225, 200, 200));
		
		if requirementsNiceNames and #requirementsNiceNames > 0 then
			local requirementString = "Requirements: ";
			
			for i = 1, #requirementsNiceNames do
				requirementString = requirementString..requirementsNiceNames[i];
				
				if i ~= #requirementsNiceNames then
					requirementString = requirementString..", ";
				end
			end
			
			frame:AddText(requirementString, Color(225, 200, 200));
		end
		
		if quote then
			frame:AddText("\n"..quote, Color(128, 90, 90, 240));
		end
		
		frame:AddText(canTake, canTakeColor);
	end
	
	if (tooltip and isfunction(tooltip)) then
		icon:SetToolTipCallback(tooltip)
	end;
end

-- A function to add a tree header title.
function PANEL:AddHeader(headerData)
	local name = headerData.name or ""
	local parent = headerData.parent or nil
	local tooltip = headerData.tooltip;
	local color = headerData.color or Color(255, 255, 255)
	local font = headerData.font or ""
	
	if (font == "" or !IsValid(parent)) then
		return
	end
	
	local width, height = parent:GetWide(), parent:GetTall()

	if (tooltip and isfunction(tooltip) and name and name != "") then
		local fontWidth = GetFontWidth(font, name)
		local fontHeight = GetFontHeight(font, name)
		local textPosition = (width * 0.5) - (fontWidth / 2)
		
		local backPanel = Clockwork.kernel:CreateDermaToolTip(vgui.Create("Panel", parent))
		backPanel:SetPos(textPosition - 8, 10)
		backPanel:SetSize(fontWidth + 16, fontHeight + 4)
		backPanel:SetToolTipCallback(tooltip)
		
		-- Called when the panel is painted.
		--[[function backPanel.Paint(self, width, height)
			draw.RoundedBox(4, 0, 0, width, height, Color(0, 0, 0, 150))
		end]]--
		
		local mainText = vgui.Create("DLabel", parent)
		mainText:SetText(name)
		mainText:SetFont(font)
		mainText:SetPos(textPosition, 12)
		mainText:SetTextColor(color)
		mainText:SizeToContents()
		
		local shadowText = vgui.Create("DLabel", parent)
		shadowText:SetText(name)
		shadowText:SetFont(font)
		shadowText:SetPos(textPosition + 2, 12 + 2)
		shadowText:SetTextColor(Color(0, 0, 0, 150))
		shadowText:SizeToContents()
	end
end

-- A function to rebuild the panel.
function PANEL:Rebuild(level, experience, beliefs, points, faith)
	--cwBeliefs:RegisterBackgroundBlur(self, SysTime())
	
	local subfaction = Clockwork.Client:GetSharedVar("subfaction");
	
	self.experience = experience
	self.beliefTable = beliefs
	self.points = points
	self.level = level
	self.panels = {}

	local scrW, scrH = ScrW(), ScrH()
	local sizeW, sizeH = 1555, 864;
	local centerW, centerH = scrW * 0.5, scrH * 0.45

	self:SetSize(sizeW, sizeH + 64)
	self:SetPos(centerW - (sizeW / 2), centerH - (sizeH / 2))
	
	local treeSizeW, treeSizeH = 299, sizeH * 0.4625 + 8
	local width, height = self:GetSize()
	local x, y = 9, 8
	
	local prowessHeight = 816
	local prowessWidth = 378

	if (IsValid(self.prowess)) then
		self.prowess:Remove();
	end
	
	self.prowess = vgui.Create("Panel", self)
	self.prowess:SetPos(x, y)
	self.prowess:SetSize(prowessWidth, treeSizeH)
	self.prowess.texture = "menu/prowess"
	self.prowess.buttons = {}
	self.prowess.uniqueID = "prowess"
	self.prowess.finisherUniqueID = "prowess_finisher"
	self.prowess.finisherNiceName = "Prowess Finisher"
	self.prowess.color = Color(150, 50, 20);
	self.prowess.locked = (Clockwork.Client:HasTrait("weak") == true);
	
	self.prowess.arrows = vgui.Create("DImage", self.prowess)
	self.prowess.arrows:SetSize(prowessWidth, treeSizeH)
	self.prowess.arrows:SetImage("begotten/ui/menu/prowessarrows.png");

	local treeWidth, treeHeight = self.prowess:GetWide(), self.prowess:GetTall()

	self:AddHeader({
		name = "Prowess",
		parent = self.prowess,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Prowess", self.prowess.color, "Civ5ToolTi3");
			frame:AddText("Prowess is a measure of your character's physical strength, primarily affecting your character's melee combat effectiveness, as well as inventory capacity.", Color(225, 200, 200));
			frame:AddText("\n\"But then he visited the Dark Kingdom, and this was the point of no return. He felt in his wrist a tremble that manifested into a quake. His fibers were now thorns, his liquids boiled. He felt he would lose sight of the truth, and that he did...\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: +50% Inventory Capacity and +25% Melee Damage (Stacks w/ Other Buffs)", Color(50, 255, 50));
		end,
		color = self.prowess.color;
	})
	
	-- Called when the panel is painted.
	function self.prowess:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self.panels[self.prowess.texture] = self.prowess
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Main Column
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "fighter",
			niceName = "Fighter",
			description = "Maximum poise is now increased by 10 points.",
			quote = "\"Pick up that spear, boy! You'll be fighting in the Lord's army now.\"",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		-- Column A
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "halfsword_sway",
			niceName = "Halfsword and Sway",
			description = "Unlocks the ability to change weapon stance for all weapons.",
			quote = "\"Don't you hack at that plate with your sword like some fucker joe! Stab at the joints and gaps you unenlightened fucklets!\"",
			x = column[1],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fighter"},
			requirementsNiceNames = {"Fighter"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "blademaster",
			niceName = "Blademaster",
			description = "All one handed slashing weapons, dual-wielded weapons, and claws now deal 20% more damage.",
			texture = "begotten/ui/belieficons/swordsman.png",
			x = column[1],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fighter", "halfsword_sway"},
			requirementsNiceNames = {"Fighter", "Halfsword and Sway"},
			lockedsubfactions = {"Auxiliary"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "billman",
			niceName = "Billman",
			description = "Polearms, scythes, spears, rapiers, and javelins now deal 10% more damage and armor piercing damage.",
			quote = "The honest soldier keeps his distance from the bloodthirsty fools who seek his demise.",
			x = column[1],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"fighter", "halfsword_sway", "blademaster"},
			requirementsNiceNames = {"Fighter", "Halfsword and Sway", "Blademaster"},
			lockedsubfactions = {"Auxiliary"},
		})
		
		-- Column B
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "parrying",
			niceName = "Parrying",
			description = "Unlocks the 'Parry' ability for melee, which allows you to counter enemy blows and deal additional damage.",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fighter"},
			requirementsNiceNames = {"Fighter"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "repulsive_riposte",
			niceName = "Repulsive Riposte",
			description = "Riposte attack damage from successful parries is increased from 200% to 300%.";
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fighter", "parrying"},
			requirementsNiceNames = {"Fighter", "Parrying"},
			lockedsubfactions = {"Auxiliary"},
		})

		-- Column C
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "wrestle_subdue",
			niceName = "Wrestle and Subdue",
			description = "Unlocks the ability to pick up foes who have been knocked over in combat, even while they are getting up.",
			quote = "\"Lose your footing and fall? I will smother you into the dirt.\"",
			x = column[3],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fighter"},
			requirementsNiceNames = {"Fighter"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "warrior",
			niceName = "Warrior",
			description = "Maximum poise is now increased by an additional 10 points.",
			x = column[3],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fighter", "wrestle_subdue"},
			requirementsNiceNames = {"Fighter", "Wrestle and Subdue"},
			lockedsubfactions = {"Auxiliary"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "master_at_arms",
			niceName = "Master at Arms",
			description = "Maximum poise is now increased by an additional 15 points.",
			x = column[3],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"fighter", "wrestle_subdue", "warrior"},
			requirementsNiceNames = {"Fighter", "Wrestle and Subdue", "Warrior"},
			lockedsubfactions = {"Auxiliary"},
		})

		-- Column D
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "deflection",
			niceName = "Deflection",
			description = "Successful deflections (perfect blocks) now restore +15 additional points of poise and stability, as well as prevent enemy attacks for 1 second.",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fighter"},
			requirementsNiceNames = {"Fighter"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "sidestep",
			niceName = "Sidestep",
			description = "Successful deflections now restore +10 more points of poise and stability and prevents enemy attacks for an additional second.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fighter", "deflection"},
			requirementsNiceNames = {"Fighter", "Deflection"},
			lockedsubfactions = {"Auxiliary"},
		})

		-- Column E
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "strength",
			niceName = "Strength",
			description = "Unlocks the ability to use great weapons.",
			x = column[5],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fighter"},
			requirementsNiceNames = {"Fighter"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "might",
			niceName = "Might",
			description = "Increased inventory capacity by 50%. Fists and fisted weapons now deal 20% more damage.",
			quote = "\"I smash you now!\"",
			x = column[5],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fighter", "strength"},
			requirementsNiceNames = {"Fighter", "Strength"},
			lockedsubfactions = {"Auxiliary"},
		})
		
		self:AddIcon({
			parent = self.prowess,
			uniqueID = "unrelenting",
			niceName = "Unrelenting",
			description = "Great weapons and two handed weapons now deal 25% more poise damage and 10% more damage.",
			x = column[5],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"fighter", "strength", "might"},
			requirementsNiceNames = {"Fighter", "Strength", "Might"},
			lockedsubfactions = {"Auxiliary"},
		})
	end
	
	if (IsValid(self.fortitude)) then
		self.fortitude:Remove();
	end
	
	self.fortitude = vgui.Create("Panel", self)
	self.fortitude:SetPos(x, self.prowess:GetTall() + 10)
	self.fortitude:SetSize(prowessWidth, treeSizeH)
	self.fortitude.texture = "menu/fortitude"
	self.fortitude.buttons = {}
	self.fortitude.uniqueID = "fortitude"
	self.fortitude.color = Color(150, 80, 60);
	
	self.fortitude.arrows = vgui.Create("DImage", self.fortitude)
	self.fortitude.arrows:SetSize(prowessWidth, treeSizeH)
	self.fortitude.arrows:SetImage("begotten/ui/menu/fortitudearrows.png");

	local treeWidth, treeHeight = self.fortitude:GetWide(), self.fortitude:GetTall()
	
	self:AddHeader({
		name = "Fortitude",
		parent = self.fortitude,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Fortitude", self.fortitude.color, "Civ5ToolTi3");
			frame:AddText("Fortitude is a measure of your character's mental and physical resilence, primarily affecting your character's resistance to insanity as well as improving your character's combat ability due to increased pain tolerance.", Color(225, 200, 200));
			frame:AddText("\n\"I am the creator of all this light and now I fall to pieces without recognition. Dying without glorification is sinful nature, yet God does not reside in the light. The light resides in the dark. Souls begin through flesh. The mind ponders inside of shells that cannot withstand a lie which does nothing but misinterpret all that we have achieved.\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: +25% Poise Damage Resistance, +25% Stability Damage Resistance, Resistance to Explosion Fallover", Color(50, 255, 50));
		end,
		color = self.fortitude.color
	})
	
	-- Called when the panel is painted.
	function self.fortitude:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self.panels[self.fortitude.texture] = self.fortitude
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Column A
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "asceticism",
			niceName = "Asceticism",
			description = "Hunger and thirst now drain 35% slower. This will also affect fatigue (energy) if you are a Voltist with the 'Yellow and Black' belief.",
			x = column[1],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "outlasting",
			niceName = "Outlasting",
			description = "Maximum stamina is increased by 25 points.",
			x = column[1],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"asceticism"},
			requirementsNiceNames = {"Asceticism"},
			locked = (Clockwork.Client:HasTrait("winded") == true),
		})
		
		-- Column B
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "prudence",
			niceName = "Prudence",
			description = "Sanity now drains 25% slower and certain events affect your sanity less.",
			x = column[2],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "saintly_composure",
			niceName = "Saintly Composure",
			description = "The effects of low sanity are greatly reduced.",
			quote = "\"By divine steed and noble stature, these begotten thoughts will tempt me not.\"",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"prudence"},
			requirementsNiceNames = {"Prudence"},
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "lunar_repudiation",
			niceName = "Lunar Repudiation",
			description = "Grants immunity to the lethal effects of the Blood Moon and halves residual nighttime sanity loss.",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"prudence", "saintly_composure"},
			requirementsNiceNames = {"Prudence", "Saintly Composure"},
		})

		-- Column C
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "defender",
			niceName = "Defender",
			description = "Unlocks the ability to equip great shields.",
			quote = "The savages trembled before the advancing wall of steel.",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "warden",
			niceName = "Warden",
			description = "All melee weapons now have an additional 15% poise damage resistance.",
			x = column[3],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"defender"},
			requirementsNiceNames = {"Defender"},
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "hauberk",
			niceName = "Hauberk",
			description = "Unlocks the ability to wear heavy armor.",
			x = column[3],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"defender", "warden"},
			requirementsNiceNames = {"Defender", "Warden"},
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "unburdened",
			niceName = "Unburdened",
			description = "Significantly reduces the movement penalty for medium and heavy armor, including rolling.",
			x = column[3],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"defender", "warden", "hauberk"},
			requirementsNiceNames = {"Defender", "Warden", "Hauberk"},
		})

		-- Column D
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "believers_perseverance",
			niceName = "The Believer's Perseverance",
			description = "Increases critical condition duration by 300%.",
			quote = "\"Suffer in silence and do not step into the light; there are more foes yet to kill!\"",
			x = column[4],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "plenty_to_spill",
			niceName = "Plenty to Spill",
			description = "Reduces the rate of blood loss while bleeding by 50%.",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"believers_perseverance"},
			requirementsNiceNames = {"The Believer's Perseverance"},
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "unyielding",
			niceName = "Unyielding",
			description = "Increases your maximum HP by 25 points.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"believers_perseverance", "plenty_to_spill"},
			requirementsNiceNames = {"The Believer's Perseverance", "Plenty to Spill"},
		})

		-- Column E
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "hide_of_steel",
			niceName = "Hide of Steel",
			description = "Reduces the chance of receiving injuries by 50%.",
			x = column[5],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortitude,
			uniqueID = "iron_bones",
			niceName = "Iron Bones",
			description = "Reduces all damage to your limbs by 25%.",
			x = column[5],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"hide_of_steel"},
			requirementsNiceNames = {"Hide of Steel"},
		})
	end;

	x, y = self.prowess:GetPos()
	x = x + self.prowess:GetWide() + 2

	if (IsValid(self.brutality)) then
		self.brutality:Remove();
	end
	
	self.brutality = vgui.Create("Panel", self)
	self.brutality:SetPos(x, y)
	self.brutality:SetSize(260 - 2, treeSizeH)
	self.brutality.texture = "menu/brutality"
	self.brutality.buttons = {}
	self.brutality.uniqueID = "brutality"
	self.brutality.color = Color(150, 20, 20);
	self.brutality.locked = (Clockwork.Client:HasTrait("pacifist") == true);
	
	self.brutality.arrows = vgui.Create("DImage", self.brutality)
	self.brutality.arrows:SetSize(260 - 2, treeSizeH)
	self.brutality.arrows:SetImage("begotten/ui/menu/brutalityarrows.png");
	
	local treeWidth, treeHeight = self.brutality:GetWide(), self.brutality:GetTall()
	
	-- Called when the panel is painted.
	function self.brutality:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "Brutality",
		parent = self.brutality,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Brutality", self.brutality.color, "Civ5ToolTi3");
			frame:AddText("Brutality is a measure of your character's depravity and hatred of man, primarily affecting your character's survival ability and unlocking abilities such as cannibalism and bone harvesting. Fully upgrading Brutality will make your character far more survivable while increasing your combat ability while insane.", Color(225, 200, 200));
			frame:AddText("\n\"There will be no exile for the laggards. They will feel my wrath. I will impale a pitchfork through their foul, satanic flesh and harvest it for the cow.\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: Killing a player instantly restores you to full Health, Stability, Stamina, and Poise.", Color(50, 255, 50));
		end,
		color = self.brutality.color
	})
	
	self.panels[self.brutality.texture] = self.brutality
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Main Column
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "savage",
			niceName = "Savage",
			description = "Unlocks the 'Cannibalism' mechanic. Meat from corpses can be harvested for sustenance.",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "savage_animal",
			niceName = "Savage Animal",
			description = "Eating uncooked or spoiled food or drinking dirty water no longer has any negative effects.",
			quote = "\"Fear the one who will rip out your heart, eat your flesh, and wear your bones. For they are the predator, and we the prey!\"",
			x = column[3],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"savage", "primeval", "headtaker", "heart_eater", "bestial"},
			requirementsNiceNames = {"Savage", "Primeval", "Headtaker", "Heart Eater", "Bestial"},
		})
		
		-- Column A
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "primeval",
			niceName = "Primeval",
			description = "Unlocks the 'Harvesting' mechanic, allowing you to harvest bones from corpses for use in crafting.",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"savage"},
			requirementsNiceNames = {"Savage"},
		})
		
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "headtaker",
			niceName = "Headtaker",
			description = "Deal 15% more limb damage with all damage types.",
			texture = "begotten/ui/belieficons/brutality.png",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"savage", "primeval"},
			requirementsNiceNames = {"Savage", "Primeval"},
		})

		-- Column B
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "heart_eater",
			niceName = "Heart Eater",
			description = "Unlocks the ability to rip out someone's heart and eat it to restore thirst.",
			texture = "begotten/ui/belieficons/persistent_urges.png",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"savage"},
			requirementsNiceNames = {"Savage"},
		})
		
		self:AddIcon({
			parent = self.brutality,
			uniqueID = "bestial",
			niceName = "Bestial",
			description = "While at or below 40% sanity, deal 15% more damage with all melee weapons.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"savage", "heart_eater"},
			requirementsNiceNames = {"Savage", "Heart Eater"},
		})
	end;
	
	x, y = self.brutality:GetPos()
	x = x + self.brutality:GetWide()
	
	if (IsValid(self.fortune)) then
		self.fortune:Remove();
	end
	
	self.fortune = vgui.Create("Panel", self)
	self.fortune:SetPos(x + 2, y)
	self.fortune:SetSize(260 - 2, treeSizeH)
	self.fortune.texture = "menu/fortune"
	self.fortune.buttons = {}
	self.fortune.uniqueID = "fortune"
	self.fortune.color = Color(60, 69, 72);
	self.fortune.locked = (Clockwork.Client:HasTrait("marked") == true);
	
	self.fortune.arrows = vgui.Create("DImage", self.fortune)
	self.fortune.arrows:SetSize(260 - 2, treeSizeH)
	self.fortune.arrows:SetImage("begotten/ui/menu/fortunearrows.png");
	
	local treeWidth, treeHeight = self.fortune:GetWide(), self.fortune:GetTall()
	
	-- Called when the panel is painted.
	function self.fortune:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "Fortune",
		parent = self.fortune,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Fortune", self.fortune.color, "Civ5ToolTi3");
			frame:AddText("Fortune is a measure of your character's luck. Neglecting this belief tree for others may contribute to your character's demise, while upgrading it may improve your character's chances of escaping perilous situations as well improving as your character's scavenging ability.", Color(225, 200, 200));
			frame:AddText("\n\"Practice the coin in your only hand. Your other fell off in rot...\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: Increases the chance of finding exceedingly rare items.", Color(50, 255, 50));
		end,
		color = self.fortune.color
	})
	
	self.panels[self.fortune.texture] = self.fortune
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Column A
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "fortunate",
			niceName = "Fortunate",
			description = "You now have a chance of finding slightly better items while scavenging.",
			x = column[2],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "lucky",
			niceName = "Lucky",
			description = "10% chance of completely avoiding damage when taking damage from any source.",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"fortunate"},
			requirementsNiceNames = {"Fortunate"},
		})
		
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "favored",
			niceName = "Favored",
			description = "An other-worldly power, be they blessed or unholy, looks down upon you with favor. Your prayers have a higher chance of being heard, and malevolent forces will no longer target you. You will no longer die from consuming certain food or drink items, and those items that were once lethal may now have hidden value.",
			quote = "\"The Gods favor this one.\"",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"fortunate", "lucky"},
			requirementsNiceNames = {"Fortunate", "Lucky"},
		})

		-- Column B
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "talented",
			niceName = "Talented",
			description = "Increases faith gain from all activities by 15%.",
			quote = "\"A natural at everything. Are they a prodigy from the heavens, or descended from noble stature?\"",
			x = column[4],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "gifted",
			niceName = "Gifted",
			description = "Additional 10% faith gain increase from all activities.",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"talented"},
			requirementsNiceNames = {"Talented"},
		})
		
		self:AddIcon({
			parent = self.fortune,
			uniqueID = "jack_of_all_trades",
			niceName = "Jack of All Trades",
			description = "Instantly gain six faith levels but all non-subfaith tier 4 beliefs are locked (excluding sub-faith beliefs). Any epiphanies invested in the locked beliefs will be refunded. Note that this will not increase your maximum sacrament level, so if you are already at the maximum level then this belief will do nothing.",
			quote = "\"..and master of none.\"",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"talented", "gifted"},
			requirementsNiceNames = {"Talented", "Gifted"},
		})
	end;
	
	x, y = self.fortune:GetPos()
	x = x + self.fortune:GetWide()
	
	if (IsValid(self.litheness)) then
		self.litheness:Remove();
	end
	
	self.litheness = vgui.Create("Panel", self)
	self.litheness:SetPos(x + 2, y)
	self.litheness:SetSize(260 - 2, treeSizeH)
	self.litheness.texture = "menu/litheness"
	self.litheness.buttons = {}
	self.litheness.uniqueID = "litheness"
	self.litheness.color = Color(100, 70, 70);
	
	self.litheness.arrows = vgui.Create("DImage", self.litheness)
	self.litheness.arrows:SetSize(260 - 2, treeSizeH)
	self.litheness.arrows:SetImage("begotten/ui/menu/lithenessarrows.png");

	local treeWidth, treeHeight = self.litheness:GetWide(), self.litheness:GetTall()
	
	-- Called when the panel is painted.
	function self.litheness:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "Litheness",
		parent = self.litheness,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Litheness", self.litheness.color, "Civ5ToolTi3");
			frame:AddText("Litheness is a measurement of the indirection and deviousness of your character, as well as their flexibility and speed. Upgrading this belief tree will allow your character to become a master of stealth, thievery, and trickery, as well as increasing sprint speed and unlocking dodges.", Color(225, 200, 200));
			frame:AddText("\n\"Flay the fool who falters in their step. Let them run naked, flesh unsheathed, while shadowy eyes cast judgement to their sluggish speed.\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: +5% sprint speed and +25 maximum stability points.", Color(50, 255, 50));
		end,
		color = self.litheness.color
	})
	
	self.panels[self.litheness.texture] = self.litheness
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Main Column
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "nimble",
			niceName = "Nimble",
			description = "Movement while crouched is now silent and speedy.",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		-- Column A
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "sly_fidget",
			niceName = "Sly Fidget",
			description = "Unlocks the 'Lockpicking' mechanic.",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"nimble"},
			requirementsNiceNames = {"Nimble"},
		})
		
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "safecracker",
			niceName = "Safecracker",
			description = "You can now lockpick Tier III locks.",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"nimble", "sly_fidget"},
			requirementsNiceNames = {"Nimble", "Sly Fidget"},
		})
		
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "thief",
			niceName = "Thief",
			description = "Lockpicking is now easier.",
			quote = "A serf toils, a thief collects.",
			x = column[2],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"nimble", "sly_fidget", "safecracker"},
			requirementsNiceNames = {"Nimble", "Sly Fidget", "Safecracker"},
		})

		-- Column B
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "dexterity",
			niceName = "Dexterity",
			description = "All progress bar actions including raising weapons, reloading, and standing up now complete 33% faster.",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"nimble"},
			requirementsNiceNames = {"Nimble"},
		})
		
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "swift",
			niceName = "Swift",
			description = "Sprinting is now 10% faster.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"nimble", "dexterity"},
			requirementsNiceNames = {"Nimble", "Dexterity"},
		})
		
		self:AddIcon({
			parent = self.litheness,
			uniqueID = "evasion",
			niceName = "Evasion",
			description = "Unlocks the 'Combat Roll' ability. Combat rolling grants invincibility frames based on the weight of armor worn and can also put out fires.",
			x = column[4],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"nimble", "dexterity", "swift"},
			requirementsNiceNames = {"Nimble", "Dexterity", "Swift"},
		})
	end;
	
	x, y = self.litheness:GetPos()
	x = x + self.litheness:GetWide()
	
	if (IsValid(self.ingenuity)) then
		self.ingenuity:Remove();
	end
	
	self.ingenuity = vgui.Create("Panel", self)
	self.ingenuity:SetPos(x + 2, y)
	self.ingenuity:SetSize(prowessWidth - 1, treeSizeH)
	self.ingenuity.texture = "menu/ingenuity"
	self.ingenuity.buttons = {}
	self.ingenuity.uniqueID = "ingenuity"
	self.ingenuity.color = Color(80, 70, 50)
	
	self.ingenuity.arrows = vgui.Create("DImage", self.ingenuity)
	self.ingenuity.arrows:SetSize(prowessWidth - 1, treeSizeH)
	self.ingenuity.arrows:SetImage("begotten/ui/menu/ingenuityarrows.png");
	
	local treeWidth, treeHeight = self.ingenuity:GetWide(), self.ingenuity:GetTall()
	
	-- Called when the panel is painted.
	function self.ingenuity:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "Ingenuity",
		parent = self.ingenuity,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Ingenuity", self.ingenuity.color, "Civ5ToolTi3");
			frame:AddText("Ingenuity is a measure of your character's craftiness, primarily affecting your character's effectiveness at Crafting. Upgrading this belief set will progressively unlock more crafting options. More Crafting options may become available if this belief set is paired with aptitude.", Color(225, 200, 200));
			frame:AddText("\n\"Bobby all proud 'an cool with that 'ol apparatus back in the truck that laid him out with sweet social status, far from junior status. It be the saddest machine but nice with molasses in the power gauge, as well as the mathematics and administrative tactics.\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: Armor and weapon condition will no longer decay.", Color(50, 255, 50));
		end,
		color = self.ingenuity.color
	})
	
	self.panels[self.ingenuity.texture] = self.ingenuity
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Main Column
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "ingenious",
			niceName = "Ingenious",
			description = "Unlocks the 'Crafting' mechanic.",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		-- Column A
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "cookist",
			niceName = "Cookist",
			description = "Unlocks the crafting of cookable items.",
			x = column[1],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"ingenious"},
			requirementsNiceNames = {"Ingenious"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "culinarian",
			niceName = "Culinarian",
			description = "Unlocks master cooking recipes.",
			x = column[1],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"ingenious", "cookist"},
			requirementsNiceNames = {"Ingenious", "Cookist"},
		})
		
		-- Column B
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "powder_and_steel",
			niceName = "Powder and Steel",
			description = "Unlocks the ability to load firearms.",
			quote = "\"Almighty creator, deity, holiness, idol of mine. Give me power, spirit, allegiance with those who have disbanded from my ordnance of an army. Divine overseer, universal forces be with me. And for those demons, fight back in means to protect Hard-Glaze and society from its inevitable destruction. Dump the spiritual trophies for now, and unload the ammunitions to purify these unfaithful sinners of the land. Stockpile the explosives, magazine the rifles, warehouse the vehicles, but most of all, plant the inflorescence of Hard-Glaze society inside the dirt for future generations to come.\" - Lord Maximus XII";
			texture = "begotten/ui/belieficons/blessed_powder.png",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"ingenious"},
			requirementsNiceNames = {"Ingenious"},
			lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "pistolier",
			niceName = "Pistolier ",
			description = "Massively reduces misfire chance for all firearms and prevents them from exploding.",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"ingenious", "powder_and_steel"},
			requirementsNiceNames = {"Ingenious", "Powder and Steel"},
			lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "marksman",
			niceName = "Marksman",
			description = "Greatly increases accuracy while standing still for all firearms.",
			x = column[2],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"ingenious", "powder_and_steel", "pistolier"},
			requirementsNiceNames = {"Ingenious", "Powder and Steel", "Pistolier"},
			lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
		})

		-- Column C
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "craftsman",
			niceName = "Craftsman",
			description = "Unlocks Tier II of crafting.",
			x = column[3],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"ingenious"},
			requirementsNiceNames = {"Ingenious"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "mechanic",
			niceName = "Mechanic",
			description = "Unlocks Tier III of crafting. Unlocks the ability to repair non-broken items by merging them in the inventory menu.",
			x = column[3],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"ingenious", "craftsman"},
			requirementsNiceNames = {"Ingenious", "Craftsman"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "artisan",
			niceName = "Artisan",
			description = "Unlocks the crafting of masterworks. Also unlocks the ability to repair broken items.",
			x = column[3],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"ingenious", "craftsman", "mechanic"},
			requirementsNiceNames = {"Ingenious", "Craftsman", "Mechanic"},
		})

		-- Column D
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "smith",
			niceName = "Smith",
			description = "Unlocks the ability to smelt Iron via crafting. Also unlocks the ability to melt down metal items at forges.",
			texture = "begotten/ui/belieficons/blacksmith.png",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"ingenious"},
			requirementsNiceNames = {"Ingenious"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "blacksmith",
			niceName = "Blacksmith",
			description = "Unlocks the ability to smelt Steel and Gold via crafting.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"ingenious", "smith"},
			requirementsNiceNames = {"Ingenious", "Smith"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "master_blacksmith",
			niceName = "Master Blacksmith",
			description = "Unlocks the ability to smelt Fine Steel via crafting.",
			texture = "begotten/ui/belieficons/blacksmith.png",
			x = column[4],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"ingenious", "smith", "blacksmith"},
			requirementsNiceNames = {"Ingenious", "Smith", "Blacksmith"},
		})

		-- Column E
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "scour_the_rust",
			niceName = "Scour the Rust",
			description = "Reduces armor and weapon condition decay by 50%.",
			x = column[5],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"ingenious"},
			requirementsNiceNames = {"Ingenious"},
		})
		
		self:AddIcon({
			parent = self.ingenuity,
			uniqueID = "fortify_the_plate",
			niceName = "Fortify the Plate",
			description = "Increases the protection value of all armor by 10%.",
			texture = "begotten/ui/belieficons/hauberk.png",
			x = column[5],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"ingenious", "scour_the_rust"},
			requirementsNiceNames = {"Ingenious", "Scour the Rust"},
		})
	end;
		
	x, y = self.ingenuity:GetPos()
	x = x + self.ingenuity:GetWide()
	
	if (IsValid(self.religion)) then
		self.religion:Remove();
	end
	
	local x, y = self.fortitude:GetPos()
	
	self.religion = vgui.Create("Panel", self)
	self.religion:SetPos(x + 384, y)
	self.religion:SetSize(771, 407);
	self.religion.texture = "menu/light"
	self.religion.buttons = {}
	self.religion.parent = self
	self.religion.uniqueID = "religion"
	self.religion.color = Color(255, 215, 0, 255)
	self.religion.lockedsubfactions = {"Clan Grock"};
	
	local treeWidth, treeHeight = self.religion:GetWide(), self.religion:GetTall()
	
	-- Called when the panel is painted.
	function self.religion:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "",
		parent = self.religion,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText(faith, self.religion.color, "Civ5ToolTi3");
			frame:AddText("\"The holy city of Glaze in Hell's domain. These are my dual swords to be crossed, indeed over her chest in resolution to a final cause. In a beating heart of shields.\"", Color(225, 200, 200));
			frame:AddText("\nEach faith has a unique skill set, unlocking character abilities, rituals, and generally improving stats overall. One may also branch into subfaiths, though openly practicing these subfaiths may see your character deemed a heretic by the relevant religious authorities.", Color(255, 255, 255));
			--frame:AddText("\nBelief Tree Completion Bonus: ", Color(50, 255, 50));
		end,
		color = self.religion.color
	})
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON = true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	if faith == "Faith of the Family" then
		self.religion.color = Color(163, 153, 143, 255);
		self.religion.texture = "menu/family";
		self.religion.arrows = vgui.Create("DImage", self.religion)
		self.religion.arrows:SetSize(771, 407)
		self.religion.arrows:SetPos(0, -1);
		self.religion.arrows:SetImage("begotten/ui/menu/faithfamilyarrows.png");
		
		local column = {
			[1] = actualWidth * 0.1,
			[2] = actualWidth * 0.3,
			[3] = actualWidth * 0.5,
			[4] = actualWidth * 0.7,
			[5] = actualWidth * 0.9,
		};

		local row = {
			[1] = actualHeight * 0.3,
			[2] = actualHeight * 0.5,
			[3] = actualHeight * 0.7,
			[4] = actualHeight * 0.9,
		};
		
		for k, v in pairs (column) do
			column[k] = (v - iconHalf) + treeX - 2
		end;
		
		for k, v in pairs (row) do
			row[k] = (v - iconHalf) + treeY - 2
		end;
		
		if (CREATE_ICON) then 	
			-- Column A
			self:AddIcon({
				parent = self.religion,
				uniqueID = "father",
				niceName = "Strength of the Father",
				subfaith = "Faith of the Father",
				description = "Selects the 'Faith of the Father' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Gain double faith gain from killing foes who have a higher sacrament level than you.",
				quote = "The Father is the Patriarch, the manifestation of conflict and struggle. He makes sure his children are fit to survive at all costs. The followers of the Father may be bloodthirsty and otherwise brutish, but they possess a sense of strength and honor unmatched by all.",
				x = column[1],
				y = row[1],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "honor_the_gods",
				niceName = "Honor the Gods",
				subfaith = "Faith of the Father",
				description = "Unlocks Tier I Faith of the Family Rituals.",
				x = column[1],
				y = row[2],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast", "Clan Grock"},
				requirements = {"father"},
				requirementsNiceNames = {"Strength of the Father"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "man_become_beast",
				niceName = "Man Become Beast",
				subfaith = "Faith of the Father",
				description = "Unlocks the ability to equip dual-wielded weapons. Unlocks the ability to equip claws. Increases maximum poise by 10 points. Increases maximum HP by 40 points. Unlocks Tier II Familial Rituals.",
				x = column[1],
				y = row[3],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast", "Clan Grock"},
				requirements = {"father", "honor_the_gods"},
				requirementsNiceNames = {"Strength of the Father", "Honor the Gods"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "fearsome_wolf",
				niceName = "Fearsome is the Wolf",
				subfaith = "Faith of the Father",
				description = "Upgrades the 'Warcry' ability: all nearby foes will be highlighted in red for 20 seconds. You will deal 25% more damage and 15% more poise damage against highlighted foes, as well as sprint 10% faster for a 20 second duration.",
				quote = "\"DEATH TO THE GLAZE AND RISE TO THE GAY GORE!!!\"",
				x = column[1],
				y = row[4],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast", "Clan Grock"},
				requirements = {"father", "honor_the_gods", "man_become_beast"},
				requirementsNiceNames = {"Strength of the Father", "Honor the Gods", "Man Become Beast"},
			})
			
			-- Column B
			self:AddIcon({
				parent = self.religion,
				uniqueID = "mother",
				niceName = "Mercy of the Mother",
				subfaith = "Faith of the Mother",
				description = "Selects the 'Faith of the Mother' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Increased faith gain from performing rituals and alchemy.",
				quote = "The Mother is the Matriarch, the architect of nature and the cycle of life and death. From her womb came all life, and under her watch they will all one day die. The followers of the Mother are outcasts of Gore society, deformed and stunted men, and sickly slave women. Their goal is to heal the corpse world that they inhabit, and give death to the blighted ones who gnaw at its roots.",
				x = column[2],
				y = row[1],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "one_with_the_druids",
				niceName = "One With the Druids",
				subfaith = "Faith of the Mother",
				description = "Unlocks Tier I and Tier II Familial Rituals.",
				x = column[2],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"mother"},
				requirementsNiceNames = {"Mercy of the Mother"},
				lockedsubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "gift_great_tree",
				niceName = "Gift of the Great Tree",
				subfaith = "Faith of the Mother",
				description = "You will now passively regenerate health over time, irrespective of your wounds. This is separate from normal health regeneration and much faster. Increases your maximum HP by 25 points.",
				quote = "\"The caretakers of the Great Tree are in turn blessed with unnatural abilities. Wounds mend with their touch, dead soil sprout life with each step. All will be repaid in full when their lives end and their bodies are consumed by the Earth once more.\"",
				x = column[2],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"mother", "one_with_the_druids"},
				requirementsNiceNames = {"Mercy of the Mother", "One With the Druids"},
				lockedsubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "watchful_raven",
				niceName = "Watchful is the Raven",
				subfaith = "Faith of the Mother",
				description = "Unlocks Tier III Familial Rituals. Unlocks the ability to Ravenspeak if you are a Clan Crast Goreic Warrior. Unlocks unique alchemy recipes.",
				x = column[2],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"mother", "one_with_the_druids", "gift_great_tree"},
				requirementsNiceNames = {"Mercy of the Mother", "One With the Druids", "Gift of the Great Tree"},
				lockedsubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			-- Column C
			self:AddIcon({
				parent = self.religion,
				uniqueID = "old_son",
				niceName = "Wisdom of the Old Son",
				subfaith = "Faith of the Old Son",
				description = "Selects the 'Faith of the Old Son' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Increased residual faith gain.",
				quote = "The Old Son is the bringer of war, the deity of conquest and the manifestation of the endless sea. Those born under Him are restless souls, always seeking to better themselves and laugh in the face of unbeatable odds. The old and tested Haralder Clan have sailed the world, conquering hellish landscapes and returning with mighty spoils. They are the challengers, the demon slayers, the adventurers, and the inheritors of fortune. Yet perhaps they could be much more, for the Old Son stirs in the endless depths, and his wakening could bring about a flood that would drown civilization and the burden of humanity with it.",
				x = column[3],
				y = row[1],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "the_black_sea",
				niceName = "The Black Sea",
				subfaith = "Faith of the Old Son",
				description = "Significantly increases the effectiveness of senses and allows it to be used when not equipped, also meaning they must manually be toggled. Greatly decreases oxygen loss, allowing you to stay underwater for three times longer. Unlocks Tier I Familial Rituals.",
				x = column[3],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"old_son"},
				requirementsNiceNames = {"Wisdom of the Old Son"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "taste_of_blood",
				niceName = "Taste of Blood",
				subfaith = "Faith of the Old Son",
				description = "Increases your maximum HP by 35 points. Upon dealing damage to a character, they will be highlighted in red for 3 minutes. During this time you will deal 15% additional damage to them. You may only track one person at a time.",
				quote = "\"I taste your blood. It is a good taste! Run, flee, and I hunt. Your bones will be buried in these woods.\"",
				x = column[3],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"old_son", "the_black_sea"},
				requirementsNiceNames = {"Wisdom of the Old Son", "The Black Sea"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "daring_trout",
				niceName = "Daring is the Trout",
				subfaith = "Faith of the Old Son",
				description = "Upgrades the 'Warcry' ability: all nearby foes will be highlighted in white for 10 seconds and will be slowed down by 15%. Unlocks Tier II Familial Rituals.",
				quote = "\"We have sailed to this foreign land to murder and rape! Will you not fight us, cowards? Will you not join the corpse pile?\"",
				x = column[3],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"old_son", "the_black_sea", "taste_of_blood"},
				requirementsNiceNames = {"Wisdom of the Old Son", "The Black Sea", "Taste of Blood"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax", "Clan Grock"},
			})
			
			-- Column D
			self:AddIcon({
				parent = self.religion,
				uniqueID = "young_son",
				niceName = "Ingenuity of the Young Son",
				subfaith = "Faith of the Young Son",
				description = "Selects the 'Faith of the Young Son' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Increased faith gain from crafting.",
				quote = "The Young Son is the deity of innovation, the source of all metal and fire, and the defiler of natural law. Those who follow the Young Son are seen as stoic, stubborn men who keep to themselves. They are also known to have molten iron in their blood, which tempers their steel as they forge mighty weapons. The Father, in his constant disapproval of his youngest offspring, places the Young Son on a path towards familial turmoil in an effort to prove the strength of his ingenuity. He beckons his human followers - whom he has shown much appreciation for in spite of the other deities - to aid him on his path to kill the Father and complete the prophecy of ruination and rebirth.",
				x = column[4],
				y = row[1],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "taste_of_iron",
				niceName = "Taste of Iron",
				subfaith = "Faith of the Young Son",
				description = "All crafted items will be in perfect condition, regardless of the condition of component parts. Increases burn damage resistance by 50%. Also negates all damage from environmental fires.",
				quote = "\"You cannot burn that which is boiling.\"",
				x = column[4],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"young_son"},
				requirementsNiceNames = {"Ingenuity of the Young Son"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "shieldwall",
				niceName = "Shieldwall",
				subfaith = "Faith of the Young Son",
				description = "Increases maximum HP by 25 points. Reduces weapon damage penalty from using shields by 60%. Increases poise resistance of all shields by 15%.",
				quote = "\"The Shagalaxians believe that the only thing that separates man from beast is the metal in their hands. When a man tosses aside their iron, they are little more than game to be hunted.\"",
				x = column[4],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"young_son", "taste_of_iron"},
				requirementsNiceNames = {"Ingenuity of the Young Son", "Taste of Iron"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "enduring_bear",
				niceName = "Enduring is the Bear",
				subfaith = "Faith of the Young Son",
				description = "Unlocks the ability to smelt Shagalaxian steel (if Master Blacksmith is unlocked). Increases maximum stability by 25 points. Decreases chance of injury by 20%. Decreases fatigue gain by 50%.",
				quote = "\"I will not rest until the sky is darkened in grey fog: when our engines are built, when our steel titans groan, when all is crushed under our rolling wheels. A new god! Tempered in hellfire and quenched in blood! Shag-a-lax! Shag-a-lax!\"",
				texture = "begotten/ui/belieficons/bestial.png",
				x = column[4],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"young_son", "taste_of_iron", "shieldwall"},
				requirementsNiceNames = {"Ingenuity of the Young Son", "Taste of Iron", "Shieldwall"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Grock"},
			})
			
			-- Column E
			self:AddIcon({
				parent = self.religion,
				uniqueID = "sister",
				niceName = "Cunning of the Sister",
				subfaith = "Faith of the Sister",
				description = "Selects the 'Faith of the Sister' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Gain increased faith gain from killing foes who have a lower faith level than you.",
				quote = "The Sister is the daughter of ambition, the trickster goddess of cunning and schemes. Her followers are hateful and malcontent, always seeking to usurp power wherever possible. Clan Reaver, the chosen Clan of the Sister, is said to have an impenetrable fortress deep in the Goreic Kingdoms where men are tortured and flayed to empower their goddess. The other Clans see Her followers as an ill omen, their coming being the final ruination of the world and the destruction of the Family as a whole. Many suspect that the Sister is not actually a member of the Family but a twisted proxy idol of the Dark Prince. It is unlikely that their assumptions are incorrect.",
				x = column[5],
				y = row[1],
				width = 48,
				height = 48,
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "witch_druid",
				niceName = "Witch Druid",
				subfaith = "Faith of the Sister",
				description = "Unlocks the ability to equip dual-wielded weapons. Unlocks the ability to equip claws. Unlocks Tier I Faith of the Family and Faith of the Dark rituals.",
				quote = "\"Beware the wicker man.\"",
				x = column[5],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"sister"},
				requirementsNiceNames = {"Cunning of the Sister"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "shedskin",
				niceName = "Shedskin",
				subfaith = "Faith of the Sister",
				description = "Increases maximum health by 25 points. Increases protection value of all armor by 15%. Unlocks Tier II Faith of the Family and Faith of the Dark rituals.",
				quote = "\"Under their black iron plates they are cushioned with the hides of flayed men. If we are to kill these brutes, you must thrust deep!\"",
				x = column[5],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"sister", "witch_druid"},
				requirementsNiceNames = {"Cunning of the Sister", "Witch Druid"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Grock"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "deceitful_snake",
				niceName = "Deceitful is the Snake",
				subfaith = "Faith of the Sister",
				description = "If someone deals 15 or more points of damage to you in a single blow, they will be highlighted in red and receive 40% more damage from you for 40 seconds. Also unlocks the ability to smelt Hellforged Steel (only if 'Master Blacksmith' is also unlocked).",
				quote = "\"You will scream, and then you will have no tongue. You will gurgle and then choke. From a tree you will be hung, and your flesh will be made into a cloak.\"",
				x = column[5],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"sister", "witch_druid", "shedskin"},
				requirementsNiceNames = {"Cunning of the Sister", "Witch Druid", "Shedskin"},
				lockedsubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Grock"},
			})
		end
	elseif faith == "Faith of the Dark" then
		self.religion.color = Color(137, 0, 0, 255);
		self.religion.texture = "menu/dark"
		self.religion.arrows = vgui.Create("DImage", self.religion)
		self.religion.arrows:SetSize(771, 407)
		self.religion.arrows:SetImage("begotten/ui/menu/faithdarkarrows.png");
		
		local column = {
			[1] = actualWidth * 0.1,
			[2] = actualWidth * 0.2,
			[3] = actualWidth * 0.3,
			[4] = actualWidth * 0.5,
			[5] = actualWidth * 0.55,
			[6] = actualWidth * 0.6,
			[7] = actualWidth * 0.7,
			[8] = actualWidth * 0.80,
			[9] = actualWidth * 0.85,
			[10] = actualWidth * 0.90,
		};

		local row = {
			[1] = actualHeight * 0.3,
			[2] = actualHeight * 0.5,
			[3] = actualHeight * 0.7,
			[4] = actualHeight * 0.9,
		};
		
		for k, v in pairs (column) do
			column[k] = (v - iconHalf) + treeX - 2
		end;
		
		for k, v in pairs (row) do
			row[k] = (v - iconHalf) + treeY - 2
		end;
		
		if (CREATE_ICON) then 	
			-- Column A
			self:AddIcon({
				parent = self.religion,
				uniqueID = "embrace_the_darkness",
				niceName = "Embrace the Darkness",
				subfaith = "Primevalism",
				description = "Enables the 'Cloaking' mechanic for use with Senses in the Wasteland at night. Also unlocks unlocks Tier III 'Faith of the Dark' rituals if you are of the 'House Rekh-khet-sa' bloodline.",
				quote = "\"Look into the blackness of the night and something will stare back into you.\"",
				x = column[1],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				requirementsNiceNames = {"Primevalism", "Creature of the Dark", "Soothsayer"},
			})
				
			-- Column B
			self:AddIcon({
				parent = self.religion,
				uniqueID = "primevalism",
				niceName = "Primevalism",
				subfaith = "Primevalism",
				description = "Selects 'Primevalism' as your subfaith. Unlocks the ability to pray. Gain double the residual faith gain when outside in the Wasteland at night.",
				quote = "\"Since the dawn of time, men have looked into the darkness of the night and saw gods where there was not. From torturous jungles to ashen woods and vast deserts, these primitives have created tens of thousands of deities to explain away the unknowns of life. These lesser men were indeed focused merely on survival; they did not seek out full truths as the platitudes of their mythology and harsh, distant gods kept them content. In the times of the Begotten they continue still, creating effigies of bone and performing primeval sacrifices to their many gods. Unknown to them, these thousands of deities all share the same face - proxies to gather the power of the masses, as their blind faith keeps the demons of the night indeed satisfied.\"",
				x = column[2],
				y = row[1],
				width = 48,
				height = 48,
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "creature_of_the_dark",
				niceName = "Creature of the Dark",
				subfaith = "Primevalism",
				description = "Increases the effective range of Senses significantly and allows it to be used when not equipped, also meaning they must manually be toggled.",
				quote = "\"Those who seek warmth in the light and fire are not fit to live here. In the jungle, you will be our prey.\"",
				x = column[2],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"primevalism"},
				requirementsNiceNames = {"Primevalism"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "soothsayer",
				niceName = "Soothsayer",
				subfaith = "Primevalism",
				description = "Unlocks Tier I and Tier II 'Faith of the Dark' Rituals.",
				quote = "\"Markings in the mud. A house of skulls in the jungle. A child's figure bound by bamboo sticks, face eaten out by carnivorous ants. The devil lives here - we need to leave this place!\"",
				x = column[2],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"primevalism", "creature_of_the_dark"},
				requirementsNiceNames = {"Primevalism", "Creature of the Dark"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "survivalist",
				niceName = "Survivalist",
				subfaith = "Primevalism",
				description = "All pierce weapons now apply poison which lowers the target's movement speed and slowly drains health.",
				quote = "\"The tribals rub their spears in vile herbs and ivies. One jab and you'll be feeling it.\"",
				x = column[2],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				requirementsNiceNames = {"Primevalism", "Creature of the Dark", "Soothsayer"},
			})
			
			-- Column C
			self:AddIcon({
				parent = self.religion,
				uniqueID = "thirst_blood_moon",
				niceName = "Thirst of the Blood Moon",
				subfaith = "Primevalism",
				description = "While outside in the Wasteland at night, 50% of damage dealt will be returned as health. Also provides a small chance of healing injuries or stopping bleeding if the damage dealt is above 25. Unlocks unique 'Primevalism' Rituals",
				quote = "\"The guardsman heard howling and could not discern if it were a man or beast. In truth, it did not matter.\"",
				texture = "begotten/ui/belieficons/lunar_repudiation.png",
				x = column[3],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				requirementsNiceNames = {"Primevalism", "Creature of the Dark", "Soothsayer"},
			})
			
			-- Column D
			self:AddIcon({
				parent = self.religion,
				uniqueID = "unending_dance",
				niceName = "The Unending Dance",
				subfaith = "Satanism",
				description = "You will now deal more damage against characters the lower their sanity is. Starting at under 70% enemy Sanity you will deal 10% more damage which maxes at 80% damage at 10 enemy sanity.",
				quote = "\"At first the crowd was aghast when the performing Darklander swordsman turned his twin blades against the audience. Many screamed and ran, scrambling to find an exit to the ampitheatre. Many more began to simply applaud at the art, boasting their standing ovations as dozens had their heads expertly hacked off in a dazzling display of skill and passion. The master swordsman was beset in a fit of laughter as he continued his work, the audience eagerly awaiting their fate as they cheered him on. Survivors of the tragedy recall the event with an almost nostalgic flare; emoting a sincere forlorn regret for not having joined the countless dead in the apocalyptic dance of death.\"",
				x = column[4],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"satanism", "murder_artform", "flamboyance"},
				requirementsNiceNames = {"Satanism", "Murder as an Artform", "Flamboyance"},
			})
			
			
			-- Column E
			self:AddIcon({
				parent = self.religion,
				uniqueID = "flamboyance",
				niceName = "Flamboyance",
				subfaith = "Satanism",
				description = "All melee weapons now have 10% faster attack speeds.",
				quote = "\"Gloriosity at its finest\"",
				x = column[5],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"satanism", "murder_artform"},
				requirementsNiceNames = {"Satanism", "Murder as an Artform"},
			})
			
			-- Column F
			self:AddIcon({
				parent = self.religion,
				uniqueID = "murder_artform",
				niceName = "Murder as an Artform",
				subfaith = "Satanism",
				description = "Unlocks the ability to equip Satanic sacrificial weapons. Also unlocks the ability to equip dual-wielded weapons.",
				x = column[6],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"satanism"},
				requirementsNiceNames = {"Satanism"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "impossibly_skilled",
				niceName = "Impossibly Skilled",
				subfaith = "Satanism",
				description = "Dual Weapons now block bullets and javelins. Unlocks the ability to parry or deflect javelin projectiles to redirect them at your foe. Moderately increases parry and deflection windows for all melee weapons. Requires 'Blademaster' to also be unlocked.",
				quote = "\"The heretics claim that the immortals of Hell have spent centuries refining their reflexes and skill with blades to the point that they can effortlessly slice through bullets and projectiles in mid air. Perhaps this is a skill you could learn?\"",
				x = column[6],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"satanism", "murder_artform", "flamboyance", "blademaster"},
				requirementsNiceNames = {"Satanism", "Murder as an Artform", "Flamboyance", "Blademaster"},
			})
			
			-- Column G
			self:AddIcon({
				parent = self.religion,
				uniqueID = "satanism",
				niceName = "Satanism",
				subfaith = "Satanism",
				description = "Selects 'Satanism' as your subfaith. Unlocks the ability to pray. Gain double the faith gain from completing rituals.",
				quote = "Satanism is the name given to the truest belief of all. Mankind made the choice to bar themselves of pleasure for the hope of something more, a sort of justification behind their misery. They made the mistake of following the Light, something that exists only to draw men astray from their true desires. Those men pray to a god that never listens, a god that is dead in more ways than one. They believe that they should suffer a life of misery and pain for an afterlife of bliss and ignorance. Satanism is the inverse of that belief. Those who seek out the forbidden pages open their eyes to the full truths of the human plight. They understand that they must take matters into their own hands, harness the energies from every passionate delight and tortured agony. For that reason Satanists are considered selfish, often unpredictable creatures who do not hide their true desires as the chastised do.",
				x = column[7],
				y = row[1],
				width = 48,
				height = 48,
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "witch",
				niceName = "Witch",
				subfaith = "Satanism",
				description = "Unlocks Tier I 'Faith of the Dark' Rituals.",
				x = column[7],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"satanism"},
				requirementsNiceNames = {"Satanism"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "heretic",
				niceName = "Heretic",
				subfaith = "Satanism",
				description = "Unlocks Tier II 'Faith of the Dark' Rituals. Also unlocks the ability to darkwhisper.",
				x = column[7],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"satanism", "witch"},
				requirementsNiceNames = {"Satanism", "Witch"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "sorcerer",
				niceName = "Sorcerer",
				subfaith = "Satanism",
				description = "Unlocks Tier III 'Faith of the Dark' Rituals and increases your sacrament level cap by 5. Also unlocks the ability to smelt Hellforged Steel (only if 'Master Blacksmith' is also unlocked).",
				x = column[7],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"satanism", "witch", "heretic"},
				requirementsNiceNames = {"Satanism", "Witch", "Heretic"},
			})
			
			-- Column H
			self:AddIcon({
				parent = self.religion,
				uniqueID = "blank_stare",
				niceName = "A Blank Stare",
				subfaith = "Satanism",
				description = "Your very presence now residually lowers the sanity of all non-Faith of the Dark characters standing near you.",
				x = column[8],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"satanism"},
				requirementsNiceNames = {"Satanism"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "assassin",
				niceName = "Assassin",
				subfaith = "Satanism",
				description = "Stabbing someone with a dagger who is below 25% of their max health or who is fallen over will instantly kill them. Characters affected by such damage bonuses will be highlighted in red. The backstab bonus for daggers is increased from +200% to +300%. Requires 'Swift' to also be unlocked.",
				quote = "\"Beware the black-fingered deceiver!\"",
				texture = "begotten/ui/belieficons/wrestle_subdue.png",
				x = column[8],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"satanism", "blank_stare", "encore", "swift"},
				requirementsNiceNames = {"Satanism", "A Blank Stare", "Encore", "Swift"},
			})
			
			-- Column I
			self:AddIcon({
				parent = self.religion,
				uniqueID = "encore",
				niceName = "Encore",
				subfaith = "Satanism",
				description = "The attack and block delay of being parried is now reduced by 50%, allowing you to recover far sooner. You also now have 50% less of a chance to be disarmed following a high poise attack.",
				x = column[9],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"satanism", "blank_stare"},
				requirementsNiceNames = {"Satanism", "A Blank Stare"},
			})
			
			-- Column J
			self:AddIcon({
				parent = self.religion,
				uniqueID = "sadism",
				niceName = "Sadism",
				subfaith = "Satanism",
				description = "Unlocks the 'Twisted Warcry' ability, allowing you to mimic the tortured screams of your victims to severely reduce the sanity of all non-Faith of the Dark characters within yelling distance. Note that performing this will cost 5 Sanity.",
				quote = "\"The torturesmith has a certain grace in his vocal abilities. He found his passion for delivering pain was amplified when he sang along to his victims, altering his pitch to match the agonized screams of the trembling accused... Quite a silly man!\"",
				x = column[10],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"satanism", "blank_stare", "encore"},
				requirementsNiceNames = {"Satanism", "A Blank Stare", "Encore"},
			})
			
		end
	else
		self.religion.arrows = vgui.Create("DImage", self.religion)
		self.religion.arrows:SetSize(771, 407)
		self.religion.arrows:SetPos(0, -1);
		self.religion.arrows:SetImage("begotten/ui/menu/faithlightarrows.png");
		
		local column = {
			[1] = actualWidth * 0.133,
			[2] = actualWidth * 0.2,
			[3] = actualWidth * 0.266,
			[4] = actualWidth * 0.433,
			[5] = actualWidth * 0.5,
			[6] = actualWidth * 0.566,
			[7] = actualWidth * 0.733,
			[8] = actualWidth * 0.8,
			[9] = actualWidth * 0.866,
		};

		local row = {
			[1] = actualHeight * 0.3,
			[2] = actualHeight * 0.5,
			[3] = actualHeight * 0.7,
			[4] = actualHeight * 0.9,
		};
		
		for k, v in pairs (column) do
			column[k] = (v - iconHalf) + treeX - 2
		end;
		
		for k, v in pairs (row) do
			row[k] = (v - iconHalf) + treeY - 2
		end;
		
		if (CREATE_ICON) then 
			-- Main Column (Sol Orthodoxy)
			self:AddIcon({
				parent = self.religion,
				uniqueID = "sol_orthodoxy",
				niceName = "Sol Orthodoxy",
				subfaith = "Sol Orthodoxy",
				description = "Selects 'Sol Orthodoxy' as your subfaith. Unlocks the ability to pray. Unlocks the ability to commit suicide. Unlocks faith gain for each point of damage inflicted upon you. Faith gain from all sources will be increased slightly if your hunger or thirst values are below 40%.",
				quote = "Sol Orthodoxy is a corruption of the traditional Glazic beliefs. It dictates that no mortal being will ever achieve enlightenment as long as they still draw breath. Men are encouraged to repent for the terrible sinful nature they exhibit, through flagellation and even suicide. The Glaze of Sol will shine again, but only when there are no living eyes to see it.",
				texture = "begotten/ui/belieficons/faith-traditionalist.png",
				x = column[2],
				y = row[1],
				width = 48,
				height = 48,
				lockedfactions = {"Holy Hierarchy"},
				lockedsubfactions = {"Praeventor"},
			})
			
			-- Column A
			self:AddIcon({
				parent = self.religion,
				uniqueID = "repentant",
				niceName = "Repentant",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier I 'Faith of the Light' Rituals.",
				x = column[1],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy"},
				requirementsNiceNames = {"Sol Orthodoxy"},
				lockedfactions = {"Holy Hierarchy"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "flagellant",
				niceName = "Flagellant",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier II 'Faith of the Light' Rituals. Unlocks the ability to self-flagellate.",
				x = column[1],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy", "repentant"},
				requirementsNiceNames = {"Sol Orthodoxy", "Repentant"},
				lockedfactions = {"Holy Hierarchy"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "extinctionist",
				niceName = "Extinctionist",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier III 'Faith of the Light' Rituals and unique Sol Orthodoxy Rituals.",
				x = column[1],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy", "repentant", "flagellant"},
				requirementsNiceNames = {"Sol Orthodoxy", "Repentant", "Flagellant"},
				lockedfactions = {"Holy Hierarchy"},
			})

			-- Column B
			self:AddIcon({
				parent = self.religion,
				uniqueID = "prison_of_flesh",
				niceName = "This Prison of Flesh",
				subfaith = "Sol Orthodoxy",
				description = "Taking damage from any damage source, starting at a minimum of 10 damage, will reduce Corruption by half of the amount of damage taken.",
				quote = "\"Let the demons come to this prison of flesh! I will punish them, show them agony, and never will I give in to their desires!\"",
				x = column[3],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy"},
				requirementsNiceNames = {"Sol Orthodoxy"},
				lockedfactions = {"Holy Hierarchy"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "purity_afloat",
				niceName = "Purity Afloat",
				subfaith = "Sol Orthodoxy",
				description = "Increases movement speed by a maximum of 20% (at 25% health) the lower your health is, but only when not wearing heavy armor.",
				--description = "Increases movement speed by a maximum of 15% (at 25% health) the lower your health is, but only when not wearing medium or heavy armor. Holding a large amount of coin will progressively cancel out these buffs.",
				quote = "\"Unburden the shackles of the material. Strike yourself naked and true. Relinquish and be set purity afloat.\"",
				x = column[3],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy", "prison_of_flesh"},
				requirementsNiceNames = {"Sol Orthodoxy", "This Prison of Flesh"},
				lockedfactions = {"Holy Hierarchy"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "fanaticism",
				niceName = "Fanaticism",
				subfaith = "Sol Orthodoxy",
				description = "Increases melee, poise, and stability damage by a maximum of 60% (at 10% health) the lower your health is.",
				quote = "\"PURITY THROUGH PAIN! EXTINCTION THROUGH SACRIFICE! THE BELLS TOLL FOR ALL!\"",
				x = column[3],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"sol_orthodoxy", "prison_of_flesh", "purity_afloat"},
				requirementsNiceNames = {"Sol Orthodoxy", "This Prison of Flesh", "Purity Afloat"},
				lockedfactions = {"Holy Hierarchy"},
			})
			
			-- Main Column (Hard-Glazed)
			self:AddIcon({
				parent = self.religion,
				uniqueID = "hard_glazed",
				niceName = "Hard-Glazed",
				subfaith = "Hard-Glazed",
				description = "Selects 'Hard-Glazed' as your subfaith. Unlocks the ability to pray. Faith gained from making large donations of Coin to the Church.",
				quote = "Chastity and almsgiving are the core principles of the Hard-Glazed ideology. All is forfeit to the Holy Hierarchy, and one must expect only a dull life fraught with toiling to thy Minister. Yet those in the Hierarchy follow the Manifesto, and hidden in its pages lies the key to heavenly ascension.",
				texture = "begotten/ui/belieficons/faith-glaze.png",
				x = column[5],
				y = row[1],
				width = 48,
				height = 48,
			})
			
			-- Column A
			self:AddIcon({
				parent = self.religion,
				uniqueID = "disciple",
				niceName = "Disciple",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier I 'Faith of the Light' Rituals.",
				x = column[4],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"hard_glazed"},
				requirementsNiceNames = {"Hard-Glazed"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "acolyte",
				niceName = "Acolyte",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier II 'Faith of the Light' Rituals.",
				x = column[4],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"hard_glazed", "disciple"},
				requirementsNiceNames = {"Hard-Glazed", "Disciple"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "emissary",
				niceName = "Emissary",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier III 'Faith of the Light' Rituals and unique Hard-Glazed Rituals. Also unlocks the ability to smelt Maximilian Steel (only if 'Master Blacksmith' is also unlocked).",
				x = column[4],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"hard_glazed", "disciple", "acolyte"},
				requirementsNiceNames = {"Hard-Glazed", "Disciple", "Acolyte"},
			})

			-- Column B
			self:AddIcon({
				parent = self.religion,
				uniqueID = "the_light",
				niceName = "The Light",
				subfaith = "Hard-Glazed",
				description = "Unlocks the ability to equip certain 'Faith of the Light' sacrificial weapons. All melee and throwable weapons now deal 20% more armor-piercing damage.",
				quote = "\"The Glaze is the light... it is the truth - you cannot see it in perspective as it is you; your foolishness, greatness, your power...\"",
				x = column[6],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"hard_glazed"},
				requirementsNiceNames = {"Hard-Glazed"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "blessed_powder",
				niceName = "Blessed Powder",
				subfaith = "Hard-Glazed",
				description = "All firearms now deal 25% more damage.",
				quote = "Lord Maximus shouted with his thunderous voice \"Give them the steel\", and so, the steel was given.",
				texture = "begotten/ui/belieficons/blessed_powder2.png",
				x = column[6],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"hard_glazed", "the_light"},
				requirementsNiceNames = {"Hard-Glazed", "The Light"},
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "manifesto",
				niceName = "All Links to the Manifesto",
				subfaith = "Hard-Glazed",
				description = "You now deal 25% more damage against characters of another Faith, but deal 15% less damage against those of the same Faith.",
				quote = "\"There is only Glaze. Corpse the fucklets indeed!\"",
				texture = "begotten/ui/belieficons/loremaster.png",
				x = column[6],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"hard_glazed", "the_light", "blessed_powder"},
				requirementsNiceNames = {"Hard-Glazed", "The Light", "Blessed Powder"},
			})
			
			-- Main Column (Voltism)
			self:AddIcon({
				parent = self.religion,
				uniqueID = "voltism",
				niceName = "Voltism",
				subfaith = "Voltism",
				description = "Selects 'Voltism' as your subfaith. Unlocks the ability to pray. Unlocks the 'Self-Electrocution' ability to gain sanity. Gain increased faith gain from killing characters of the 'Hard-Glazed' or 'Sol Orthodoxy' subfaiths.",
				quote = "An infestation seeking to consume the Light from within is how ministers of the Holy Hierarchy would describe Voltism. A major cult with no chain of command who seek technology and enlightenment through transhumanism. They gradually replace more of their body with machine and stimulate their minds with electrical shocks. Their true motives, or their leader, remain unknown.",
				texture = "begotten/ui/belieficons/faith-volt.png",
				x = column[8],
				y = row[1],
				width = 48,
				height = 48,
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
			
			-- Column A
			self:AddIcon({
				parent = self.religion,
				uniqueID = "wire_therapy",
				niceName = "Wire Therapy",
				subfaith = "Voltism",
				description = "Unlocks Tier I 'Voltism' crafting recipes.",
				quote = "Looks like Shaye needs to spend more time on the wires.",
				texture = "begotten/ui/belieficons/wire_therapy.png",
				x = column[7],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"voltism"},
				requirementsNiceNames = {"Voltism"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "jacobs_ladder",
				niceName = "Jacob's Ladder",
				subfaith = "Voltism",
				description = "Unlocks Tier II 'Voltism' crafting recipes. Unlocks the ability to consume 'Tech' items, which will decrease corruption and increase your energy, as well as providing a substantial amount of faith (XP). Benefits from consuming 'Tech' items scale with the condition of the item. Lowers maximum health by 5 points.",
				texture = "begotten/ui/belieficons/jacobs_ladder.png",
				x = column[7],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"voltism", "wire_therapy"},
				requirementsNiceNames = {"Voltism", "Wire Therapy"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "the_paradox_riddle_equation",
				niceName = "The Paradox Riddle Equation",
				subfaith = "Voltism",
				description = "Unlocks Tier III 'Voltism' crafting recipes. At this point, you will not be able to communicate regularly as your voice will forever be altered. Unlocks the ability to apply 'Tech' items to limbs to fully heal them of injuries. Grants immunity to all diseases. Standing in any body of water or ingesting water will now deal a great amount of electric damage to you. Lowers maximum health by 5 points.",
				quote = "\"The Paradox Riddle Equation, or the Brainfucker Paradox, refers to a terrible event in Holy Hierarchy history. A disease of the mind that originated as a simple set of questions and mathematical equations spread through the noble households and wreaked havoc across the Districts for a six-year period in recent memory. It is noted that the marble palaces of District One were covered in red splotches as a result of noble stature slamming their heads on the walls out of frustration and utter confusion. This is perhaps the only 'plague' in Holy Hierarchy history that had only affected the upper classes, as the common folk were blissfully unaware of the far-reaching indications that came with the Riddle Equation, as of course they were too simple-minded to understand it. The Paradox Riddle Equation has since been scrubbed from Glazic memory by authorities, but it has recently been given new light by the Voltists who claim to have found the answer - at the cost of their humanity.\"",
				texture = "begotten/ui/belieficons/the_paradox_riddle_equation.png",
				x = column[7],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"voltism", "wire_therapy", "jacobs_ladder"},
				requirementsNiceNames = {"Voltism", "Wire Therapy", "Jacob's Ladder"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})

			-- Column B
			self:AddIcon({
				parent = self.religion,
				uniqueID = "wriggle_fucking_eel",
				niceName = "Wriggle Like a Fucking Eel",
				subfaith = "Voltism",
				description = "Self-Electrocution now cauterizes bleeding and decreases fatigue and corruption. Unlocks the ability to use Voltist weaponry.",
				texture = "begotten/ui/belieficons/wriggle_fucking_eel.png",
				x = column[9],
				y = row[2],
				width = 48,
				height = 48,
				requirements = {"voltism"},
				requirementsNiceNames = {"Voltism"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "yellow_and_black",
				niceName = "Yellow and Black",
				subfaith = "Voltism",
				description = "Unlocks the ability to equip Voltist armor. You are no longer affected by hunger and thirst. Instead, your fatigue value will begin to damage you if left unchecked. You can only decrease fatigue through electrocution or the consumption of Tech items. Lowers maximum health by 5 points. ",
				quote = "\"Can you hear the hum? P-Press your face into the barbs! Take notice of the yellow and black banner...\"",
				texture = "begotten/ui/belieficons/yellow_and_black.png",
				x = column[9],
				y = row[3],
				width = 48,
				height = 48,
				requirements = {"voltism", "wriggle_fucking_eel"},
				requirementsNiceNames = {"Voltism", "Wriggle Like a Fucking Eel"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
			
			self:AddIcon({
				parent = self.religion,
				uniqueID = "the_storm",
				niceName = "The Storm",
				subfaith = "Voltism",
				description = "Unlocks the ability to Relay to send messages to all other Voltists globally. At this point, you will not be able to communicate regularly as your voice will forever be altered. Electric damage attacks from Voltist weapons now deal increased damage and stability damage against enemies in metallic armor, with more damage being dealt the heavier the armor. Standing in any body of water or ingesting water will now deal a great amount of electric damage to you. Lowers maximum health by 5 points.",
				quote = "\"THE ELECTRIC ONE WILL RETURN FOR US!\"",
				texture = "begotten/ui/belieficons/the_storm.png",
				x = column[9],
				y = row[4],
				width = 48,
				height = 48,
				requirements = {"voltism", "wriggle_fucking_eel", "yellow_and_black"},
				requirementsNiceNames = {"Voltism", "Wriggle Like a Fucking Eel", "Yellow and Black"},
				lockedfactions = {"Gatekeeper", "Holy Hierarchy"},
				lockedsubfactions = {"Machinist"};
			})
		end;
	end
	
	if (!IsValid(self.religion.title)) then
		local font = "nov_IntroTextSmallaaafaa"
		local fontWidth = GetFontWidth(font, faith)
		
		self.religion.title = vgui.Create("DLabel", self.religion)
		self.religion.title:SetText(faith)
		self.religion.title:SetFont(font)
		self.religion.title:SetPos(self.religion:GetWide() * 0.5 - (fontWidth / 2), 14)
		self.religion.title:SizeToContents()
		self.religion.title:SetTextColor(self.religion.color)
	end
	
	self.panels[self.religion.texture] = self.religion
	
	if (IsValid(self.aptitude)) then
		self.aptitude:Remove();
	end
	
	local x, y = self.religion:GetPos()
	self.aptitude = vgui.Create("Panel", self)
	self.aptitude:SetPos(x + 776, self.prowess:GetTall() + 10)
	self.aptitude:SetSize(prowessWidth - 1, treeSizeH)
	self.aptitude.texture = "menu/aptitude"
	self.aptitude.buttons = {}
	self.aptitude.uniqueID = "aptitude"
	self.aptitude.color = Color(107, 92, 77)
	
	self.aptitude.arrows = vgui.Create("DImage", self.aptitude)
	self.aptitude.arrows:SetSize(prowessWidth - 1, treeSizeH)
	self.aptitude.arrows:SetImage("begotten/ui/menu/aptitudearrows.png");

	local treeWidth, treeHeight = self.aptitude:GetWide(), self.aptitude:GetTall()
	
	-- Called when the panel is painted.
	function self.aptitude:Paint(w, h)
		cwBeliefs:DrawTreeBackground(0, 0, treeWidth, treeHeight, self)
	end
	
	self:AddHeader({
		name = "Aptitude",
		parent = self.aptitude,
		font = "nov_IntroTextSmallaaaaa",
		tooltip = function(frame)
			frame:AddText("Aptitude", self.aptitude.color, "Civ5ToolTi3");
			frame:AddText("Aptitude is a measure of your character's intellect, affecting your character's literacy, effectiveness at alchemy, and effectiveness as a healer. Upgrading this belief set will unlock new ways to learn and adapt, become a skilled doctor or alchemist, as well as unlocking the ability to read.", Color(225, 200, 200));
			frame:AddText("\n\"Do not taint the legacy of Hard-Glaze if you cannot bear to sustain code.\"\nHer voice was no murmur, but a bold challenge to all who opposed.\n\"Was that the final testimony? Transcendence has brought me closer, resonating in a ray of almighty God's newfound hope.\"", Color(128, 90, 90, 240));
			frame:AddText("\nBelief Tree Completion Bonus: +75% Faith gain from all sources.", Color(50, 255, 50));
		end,
		color = self.aptitude.color
	})
	
	self.panels[self.aptitude.texture] = self.aptitude
	
	local actualWidth, actualHeight = treeWidth - 4, treeHeight - 4;
	local treeX, treeY = 4, 4;
	
	local CREATE_ICON= true;
	local iconSize = 48;
	local iconHalf = (iconSize / 2)
	
	local column = {
		[1] = actualWidth * 0.1,
		[2] = actualWidth * 0.3,
		[3] = actualWidth * 0.5,
		[4] = actualWidth * 0.7,
		[5] = actualWidth * 0.9,
	};

	local row = {
		[1] = actualHeight * 0.3,
		[2] = actualHeight * 0.5,
		[3] = actualHeight * 0.7,
		[4] = actualHeight * 0.9,
	};
	
	for k, v in pairs (column) do
		column[k] = (v - iconHalf) + treeX - 2
	end;
	
	for k, v in pairs (row) do
		row[k] = (v - iconHalf) + treeY - 2
	end;
	
	if (CREATE_ICON) then 
		-- Main Column
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "literacy",
			niceName = "Literacy",
			description = "Unlocks the ability to read.",
			x = column[3],
			y = row[1],
			width = 48,
			height = 48,
		})
		
		-- Column A
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "precise_measurements",
			niceName = "Precise Measurements ",
			description = "It is now impossible to fail a concoction.",
			x = column[1],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"literacy", "alchemist"},
			requirementsNiceNames = {"Literacy", "Alchemist"},
			disabled = true,
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "blood_nectar",
			niceName = "Blood Nectar",
			description = "Your concoctions are now significantly more potent.",
			x = column[1],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"literacy", "alchemist", "precise_measurements"},
			requirementsNiceNames = {"Literacy", "Alchemist", "Precise Measurements"},
			disabled = true,
		})
		
		-- Column B
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "alchemist",
			niceName = "Alchemist",
			description = "Unlocks the 'Alchemy' mechanic.",
			x = column[2],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"literacy"},
			requirementsNiceNames = {"Literacy"},
			disabled = true,
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "chemist",
			niceName = "Chemist",
			description = "Unlocks Tier II concoctions.",
			x = column[2],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"literacy", "alchemist"},
			requirementsNiceNames = {"Literacy", "Alchemist"},
			disabled = true,
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "scientist",
			niceName = "Scientist",
			description = "Unlocks Tier III concoctions.",
			x = column[2],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"literacy", "alchemist", "chemist"},
			requirementsNiceNames = {"Literacy", "Alchemist", "Chemist"},
			disabled = true,
		})
		
		-- Column C
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "scribe",
			niceName = "Scribe",
			description = "Unlocks the ability to copy scriptures. Gain faith for each unique scripture read and even more faith for every scripture copied.",
			x = column[3],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"literacy"},
			requirementsNiceNames = {"Literacy"},
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "anthropologist",
			niceName = "Anthropologist",
			description = "Unlocks the ability to read Runic and Darklander texts.",
			x = column[3],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"literacy", "scribe"},
			requirementsNiceNames = {"Literacy", "Scribe"},
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "loremaster",
			niceName = "Loremaster",
			description = "Increases your sacrament level cap by 10 but locks the 'Prowess' tree. Any epiphanies invested in 'Prowess' will be refunded.",
			quote = "Throw away your desires. Toss aside your warrior spirit. You are a beacon of knowledge. Let the young fools squabble and die. Become all-knowing, and wisdom will be your weapon.",
			x = column[3],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"literacy", "scribe", "anthropologist"},
			requirementsNiceNames = {"Literacy", "Scribe", "Anthropologist"},
		})
		
		-- Column D
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "sanitary",
			niceName = "Sanitary",
			description = "Significantly reduces the chances of catching a disease or infection.",
			quote = "Insanitation of the mind is the root cause of insanity; insanitation of the body is the root cause of affliction.",
			x = column[4],
			y = row[2],
			width = 48,
			height = 48,
			requirements = {"literacy"},
			requirementsNiceNames = {"Literacy"},
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "doctor",
			niceName = "Doctor",
			description = "Unlocks the ability to diagnose a patient's injuries.",
			x = column[4],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"literacy", "sanitary"},
			requirementsNiceNames = {"Literacy", "Sanitary"},
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "surgeon",
			niceName = "Surgeon",
			description = "Unlocks the ability to perform operations to treat advanced injuries.",
			x = column[4],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"literacy", "sanitary", "doctor"},
			requirementsNiceNames = {"Literacy", "Sanitary", "Doctor"},
		})
		
		-- Column E
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "medicine_man",
			niceName = "Medicine Man",
			description = "Triples the effectiveness of healing items.",
			x = column[5],
			y = row[3],
			width = 48,
			height = 48,
			requirements = {"literacy", "sanitary"},
			requirementsNiceNames = {"Literacy", "Sanitary"},
		})
		
		self:AddIcon({
			parent = self.aptitude,
			uniqueID = "plague_doctor",
			niceName = "Plague Doctor",
			description = "Unlocks the ability to create a cure for the Begotten Plague. Also unlocks the ability to craft Plague Doctor Outfit and wear it.",
			x = column[5],
			y = row[4],
			width = 48,
			height = 48,
			requirements = {"literacy", "sanitary", "medicine_man"},
			requirementsNiceNames = {"Literacy", "Sanitary", "Medicine Man"},
		})
	end;

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
				self:Remove()
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

	self:ShowCloseButton(false)
end

-- Called when the panel is closed.
function PANEL:OnClose()
	--cwBeliefs:RemoveBackgroundBlur(self)
end

vgui.Register("cwBeliefTree", PANEL, "DFrame")