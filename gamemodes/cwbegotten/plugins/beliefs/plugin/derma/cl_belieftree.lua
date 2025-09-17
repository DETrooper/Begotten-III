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

local RomanNumerals = { }

function RomanNumerals.ToRomanNumerals(s)
    --s = tostring(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function RomanNumerals.ToNumber(s)
    s = s:upper()
    local ret = 0
    local i = 1
    while i <= s:len() do
    --for i = 1, s:len() do
        local c = s:sub(i, i)
        if c ~= " " then -- allow spaces
            local m = map[c] or error("Unknown Roman Numeral '" .. c .. "'")
            
            local next = s:sub(i + 1, i + 1)
            local nextm = map[next]
            
            if next and nextm then
                if nextm > m then 
                -- if string[i] < string[i + 1] then result += string[i + 1] - string[i]
                -- This is used instead of programming in IV = 4, IX = 9, etc, because it is
                -- more flexible and possibly more efficient
                    ret = ret + (nextm - m)
                    i = i + 1
                else
                    ret = ret + m
                end
            else
                ret = ret + m
            end
        end
        i = i + 1
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
	local x, y = 0, 0
	
	local beliefs;
	
	if self.player == Clockwork.Client then
		beliefs = self.player:GetBeliefs() or self.beliefTable or {};
	else
		beliefs = self.beliefTable or {};
	end
	
	local level = self.player:GetNetVar("level") or self.level or 1;
	local experience = self.player:GetNetVar("experience") or self.experience or 0;
	local points = self.player:GetNetVar("points") or self.points or 0;
	
	if (!IsValid(self.closeButton)) then
		return
	end
	
	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(topBackground)
	surface.DrawTexturedRect(x + 4, y + 4, width - 8, (height - 96) - 8)

	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(bottomBackground)
	surface.DrawTexturedRect(x, height - 88, width, 88)

	draw.RoundedBox(0, 0, 0, width, height, Color(0, 0, 0, 200))

	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(topFrame)
	surface.DrawTexturedRect(x, y, width, height - 96)

	surface.SetDrawColor(255, 255, 255, 200)
	surface.SetMaterial(bottomFrame)
	surface.DrawTexturedRect(x, height - 88, width, 88)
	
	if (!beliefs) then
		return
	end
	
	self.localLevelCap = cwBeliefs.sacramentLevelCap;
	
	if self.player:HasBelief("loremaster") then
		self.localLevelCap = self.localLevelCap + 10;
	end
	
	if self.player:HasBelief("sorcerer") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if self.player:HasBelief("paradox_riddle_equation") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if self.player:GetNetVar("subfaction") == "Rekh-khet-sa" or self.player:GetNetVar("subfaction") == "Crypt Walkers" then
		self.localLevelCap = self.localLevelCap + 666;
	end

	if (!self.barValuesSet) then
		local closeButtonWide = self.closeButton:GetWide()
		local closeButtonTall = self.closeButton:GetTall()

		self.barX = 14 + closeButtonWide + 8
		self.barY = 928 - (8 + closeButtonTall)
		
		if level < self.localLevelCap then
			self.barWidth = math.Remap(math.Clamp(experience, 0, cwBeliefs.sacramentCosts[level + 1] or 666), 0, cwBeliefs.sacramentCosts[level + 1] or 666, 0, 512)
		else
			self.barWidth = 512;
		end
		
		self.barValuesSet = true
	end

	draw.RoundedBox(4, self.barX, self.barY, 512, 32, Color(30, 30, 30))
	surface.SetDrawColor(15, 5, 0, 200)
	surface.SetTexture(gradientDown)
	surface.DrawTexturedRect(self.barX + 2, self.barY + 2, 508, 28)

	draw.RoundedBox(4, (self.barX) + 4, (self.barY) + 4, self.barWidth - 8, 24, Color(140, 0, 0))
	surface.SetDrawColor(75, 0, 0, 255)
	surface.SetTexture(gradientDown)
	surface.DrawTexturedRect((self.barX) + 4, (self.barY) + 4, self.barWidth - 8, 24)
	
	self.levelNumeral = RomanNumerals.ToRomanNumerals(level)
	
	--[[if (experience < (cwBeliefs.sacramentCosts[level + 1] or 666) / 2) then
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barWidth + (self.barX) + 4 + 4, ((self.barY) + 4), Color(200, 0, 0))
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barWidth + (self.barX) + 6 + 4, ((self.barY) + 4) + 2, Color(0, 0, 0, 150))
	else
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", (256 - 8) + (self.barX) + 6 + 4, ((self.barY) + 4) + 2, Color(150, 0, 0, 200))
		draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", (256 - 8) + (self.barX) + 4 + 4, ((self.barY) + 4), Color(0, 0, 0, 255))
	end]]--
	
	draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barX + 8, self.barY + 4, Color(200, 0, 0))
	draw.SimpleText("SACRAMENT LEVEL: "..self.levelNumeral, "Civ5Tooltip1", self.barX + 10, self.barY + 6, Color(0, 0, 0, 150))
	
	if self.player == Clockwork.Client then
		if (points <= 0) then
			draw.SimpleText("YOU HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("YOU HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		else
			local epiphany = "EPIPHANY"
			
			if (points > 1) then
				epiphany = "EPIPHANIES"
			end

			draw.SimpleText("YOU HAVE "..points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("YOU HAVE "..points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		end
	else
		if (points <= 0) then
			draw.SimpleText("THEY HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("THEY HAVE NO EPIPHANIES!", "Civ5Tooltip1", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		else
			local epiphany = "EPIPHANY"
			
			if (points > 1) then
				epiphany = "EPIPHANIES"
			end

			draw.SimpleText("THEY HAVE "..points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 6, ((self.barY) + 4) + 1 + 32, Color(200, 0, 0))
			draw.SimpleText("THEY HAVE "..points.." "..epiphany.." TO INVEST!", "Civ5ToolTi3", (self.barX) + 4, ((self.barY) + 4) - 1 + 32, Color(0, 0, 0, 150))
		end
	end
	
	self.sacramentCost = cwBeliefs.sacramentCosts[level + 1] or 666;

	draw.SimpleText("Faith Concentrated: "..math.floor(experience), "Civ5Tooltip1",(self.barX) + 4 + 16 + 512, ((self.barY) + 3), Color(200, 0, 0, 255))
	draw.SimpleText("Faith Concentrated: "..math.floor(experience), "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 5), Color(0, 0, 0, 127))
	
	if level < self.localLevelCap then
		draw.SimpleText("Faith Required For Next Epiphany: "..self.sacramentCost, "Civ5Tooltip1", (self.barX) + 4 + 16 + 512, ((self.barY) + 4 + 32), Color(200, 0, 0, 255))
		draw.SimpleText("Faith Required For Next Epiphany: "..self.sacramentCost, "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 6 + 32), Color(0, 0, 0, 127))
	else
		if self.player == Clockwork.Client then
			draw.SimpleText("You Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 4 + 16 + 512, ((self.barY) + 4 + 32), Color(200, 0, 0, 255))
			draw.SimpleText("You Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 6 + 32), Color(0, 0, 0, 127))
		else
			draw.SimpleText("They Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 4 + 16 + 512, ((self.barY) + 4 + 32), Color(200, 0, 0, 255))
			draw.SimpleText("They Are At The Maximum Sacrament Level!", "Civ5Tooltip1", (self.barX) + 6 + 16 + 512, ((self.barY) + 6 + 32), Color(0, 0, 0, 127))
		end
	end
end

function PANEL:PaintOver(width, height)
	if self.highlightAlpha then
		if self.highlightAlpha < 220 then
			self.highlightAlpha = math.max(0, self.highlightAlpha - (FrameTime() * 200));
		end
	
		surface.SetDrawColor(10, 10, 10, self.highlightAlpha);
		surface.DrawRect(4, 4, width - 8, (height - 96) - 8);
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

	local beliefs = self.beliefTable;
	local uniqueID = iconData.uniqueID
	local texture = iconData.iconOverride or "begotten/ui/belieficons/"..uniqueID..".png";
	local x = iconData.x
	local y = iconData.y
	local width = iconData.width
	local height = iconData.height
	local requirements = iconData.requirements
	local requirementsNiceNames = iconData.requirementsNiceNames
	local lockedSubfactions = iconData.lockedSubfactions
	local lockedFactions = iconData.lockedFactions
	local lockedTraits = iconData.lockedTraits;
	local lockedBeliefs = iconData.lockedBeliefs;
	local description = iconData.description
	local quote = iconData.quote;
	local name = iconData.name
	local disabled = iconData.disabled
	local row = iconData.row
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
	icon.uniqueID = uniqueID
	icon.name = name
	icon.subfaith = iconData.subfaith;
	icon.lockedSubfactions = lockedSubfactions;
	icon.lockedFactions = lockedFactions;
	icon.lockedTraits = lockedTraits;
	icon.lockedBeliefs = lockedBeliefs;
	icon.locked = locked;
	icon.disabled = disabled;
	icon.row = row;
	parent.buttons[uniqueID] = icon
	
	local parentUniqueID = parent.uniqueID or "UNDEFINED";
	local parentBeliefs = parent.buttons
	
	-- Called when the button is clicked.
	function icon.DoClick()
		local beliefPanel = Clockwork.Client.cwBeliefPanel;
		
		if beliefPanel.player ~= Clockwork.Client then
			return;
		end
		
		local subfaction = Clockwork.Client:GetNetVar("subfaction");
		local subfaith = Clockwork.Client:GetNetVar("subfaith");
		local faction = Clockwork.Client:GetFaction();
		local traits = Clockwork.Client.cwTraits;
		local points = Clockwork.Client:GetNetVar("points", 0);
		local beliefs = Clockwork.Client:GetBeliefs();
	
		if (beliefs[icon.uniqueID]) then
			--surface.PlaySound(errorSound)
			return
		elseif parent.locked or icon.disabled or (parent.lockedSubfactions and table.HasValue(parent.lockedSubfactions, subfaction)) or (icon.lockedSubfactions and table.HasValue(icon.lockedSubfactions, subfaction)) or (parent.lockedFactions and table.HasValue(parent.lockedFactions, faction)) or (icon.lockedFactions and table.HasValue(icon.lockedFactions, faction)) or icon.locked or (icon.subfaith and subfaith and subfaith ~= "" and subfaith ~= "N/A" and icon.subfaith ~= subfaith) then
			return
		end
		
		if cwBeliefs:HasBelief("jack_of_all_trades") then
			if icon.row >= 4 and !icon.subfaith then
				return;
			end
		end
		
		if parent.lockedTraits then
			for i, v in ipairs(parent.lockedTraits) do
				if table.HasValue(traits, v) then
					return;
				end
			end
		end
		
		if icon.lockedTraits then
			for i, v in ipairs(icon.lockedTraits) do
				if table.HasValue(traits, v) then
					return;
				end
			end
		end
		
		if parent.lockedBeliefs then
			for i, v in ipairs(parent.lockedBeliefs) do
				if beliefs[v] then
					return;
				end
			end
		end
		
		if icon.lockedBeliefs then
			PrintTable(icon.lockedBeliefs);
			for i, v in ipairs(icon.lockedBeliefs) do
				if beliefs[v] then
					return;
				end
			end
		end
		
		local meetsRequirements = false;
		
		if points > 0 then
			meetsRequirements = true;
		end
		
		if (table.Count(requirements) > 0) then
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
			netstream.Start("TakeBelief", {icon.uniqueID, icon.name, parentUniqueID})
		end
	end
	
	function icon.Think(icon)
		local curTime = UnPredictedCurTime();
	
		if !icon.nextThink or icon.nextThink < curTime then
			icon.nextThink = curTime + 1;
		
			local selectedBad = Color(255, 50, 50, 255);
			local selectedGood = Color(50, 255, 50, 255);
			local selectedNeutral = Color(200, 200, 200, 255);
			
			local canTake = "You can take this belief!"
			local canTakeColor = selectedGood;
			local canUnlock = true
			
			local beliefPanel = Clockwork.Client.cwBeliefPanel;
			local points = beliefPanel.player:GetNetVar("points") or beliefPanel.points or 0;
			local beliefs;

			if beliefPanel.player == Clockwork.Client then
				beliefs = beliefPanel.player:GetBeliefs() or beliefPanel.beliefTable or {};
			else
				beliefs = beliefPanel.beliefTable or {};
			end
			
			if (beliefs[icon.uniqueID]) then
				canTake = "You already follow this belief!"
				canTakeColor = selectedNeutral;
				icon:SetColor(Unlocked)
			else
				local traits = Clockwork.Client.cwTraits;
				
				if parent.lockedTraits then
					for i, v in ipairs(parent.lockedTraits) do
						if table.HasValue(traits, v) then
							icon:SetColor(HardLocked)
							canTake = "This belief tree is locked due to a trait you took!"
							canTakeColor = selectedBad;
							canUnlock = false;
							
							break;
						end
					end
				end
				
				if icon.lockedTraits then
					for i, v in ipairs(icon.lockedTraits) do
						if table.HasValue(traits, v) then
							icon:SetColor(HardLocked)
							canTake = "This belief is locked due to a trait you took!"
							canTakeColor = selectedBad;
							canUnlock = false;
							
							break;
						end
					end
				end
				
				if parent.lockedBeliefs then
					for i, v in ipairs(parent.lockedBeliefs) do
						if beliefs[v] then
							icon:SetColor(HardLocked)
							canTake = "This belief tree is locked due to a belief you took!"
							canTakeColor = selectedBad;
							canUnlock = false;
							
							break;
						end
					end
				end
				
				if icon.lockedBeliefs then
					for i, v in ipairs(icon.lockedBeliefs) do
						if beliefs[v] then
							icon:SetColor(HardLocked)
							canTake = "This belief is locked due to a belief you took!"
							canTakeColor = selectedBad;
							canUnlock = false;
							
							break;
						end
					end
				end
			
				if canUnlock then
					if parent.disabled then
						icon:SetColor(HardLocked)
						canTake = "This belief tree is temporarily disabled until it can be implemented!"
						canTakeColor = selectedBad;
					elseif icon.disabled then
						icon:SetColor(HardLocked)
						canTake = "This belief is temporarily disabled until it can be implemented!"
						canTakeColor = selectedBad;
					elseif (cwBeliefs:HasBelief("jack_of_all_trades") and icon.row >= 4 and !icon.subfaith) then
						icon:SetColor(HardLocked)
						canTake = "This belief is locked due to a belief you took!"
						canTakeColor = selectedBad;
					elseif parent.lockedSubfactions and table.HasValue(parent.lockedSubfactions, beliefPanel.player:GetNetVar("subfaction")) then
						icon:SetColor(HardLocked)
						canTake = "This belief tree is locked due to the subfaction you took!"
						canTakeColor = selectedBad;
					elseif icon.lockedSubfactions and table.HasValue(icon.lockedSubfactions, beliefPanel.player:GetNetVar("subfaction")) then
						icon:SetColor(HardLocked)
						canTake = "This belief is locked due to the subfaction you took!"
						canTakeColor = selectedBad;
					elseif parent.lockedFactions and table.HasValue(parent.lockedFactions, beliefPanel.player:GetFaction()) then
						icon:SetColor(HardLocked)
						canTake = "This belief tree locked due to the faction you took!"
						canTakeColor = selectedBad;
					elseif icon.lockedFactions and table.HasValue(icon.lockedFactions, beliefPanel.player:GetFaction()) then
						icon:SetColor(HardLocked)
						canTake = "This belief is locked due to the faction you took!"
						canTakeColor = selectedBad;
					elseif icon.subfaith and beliefPanel.player:GetNetVar("subfaith") and beliefPanel.player:GetNetVar("subfaith") ~= "" and beliefPanel.player:GetNetVar("subfaith") ~= "N/A" and icon.subfaith ~= beliefPanel.player:GetNetVar("subfaith") then
						icon:SetColor(HardLocked)
						canTake = "You have already selected a subfaith!"
						canTakeColor = selectedBad;
					elseif (table.Count(requirements) > 0) then
						for k, v in pairs (requirements) do
							if (!beliefs[v]) then
								canUnlock = false
								break
							end
						end
						
						if (canUnlock) then
							if (points <= 0) then
								canTake = "You do not have any epiphanies to spend on this belief!"
								canTakeColor = selectedBad;
								icon:SetColor(Locked)
							else
								icon:SetColor(Unlockable)
							end
						else
							if (points <= 0) then
								canTake = "You have no epiphanies and do not meet the requirements for this belief!"
							else
								canTake = "You do not meet the requirements for this belief!"
							end
							
							canTakeColor = selectedBad;
							icon:SetColor(Locked)
						end
					else
						if (points <= 0) then
							canTake = "You do not have any epiphanies to spend on this belief!"
							canTakeColor = selectedBad;
							icon:SetColor(Locked)
						else
							icon:SetColor(Unlockable)
						end
					end
				end
			end
				
			local tooltip = function(frame)
				frame:AddText(name, parent.color, "Civ5ToolTip4");
				frame:AddText(description.."\n", Color(225, 200, 200));
				
				if quote then
					frame:AddText(quote.."\n", Color(128, 90, 90, 240));
				end
				
				if requirementsNiceNames and #requirementsNiceNames > 0 then
					local requirementString = "Requirements: "..table.concat(requirementsNiceNames, ", ");
					
					frame:AddText(requirementString, Color(225, 200, 200));
				end
				
				frame:AddText(canTake, canTakeColor);
			end
			
			if (tooltip and isfunction(tooltip)) then
				icon:SetToolTipCallback(tooltip)
			end;
		end
	end
	
	Clockwork.kernel:CreateDermaToolTip(icon)
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
		
		if parent.noShadow then
			local mainText = vgui.Create("DLabel", parent)
			mainText:SetText(name)
			mainText:SetFont(font)
			mainText:SetPos(textPosition, 16)
			mainText:SetTextColor(color)
			mainText:SizeToContents()
		else
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
end

-- A function to rebuild the panel.
function PANEL:Rebuild(player, level, experience, beliefs, points, faith, highlightBelief)
	--cwBeliefs:RegisterBackgroundBlur(self, SysTime())

	self.player = player;
	self.experience = experience
	self.beliefTable = beliefs
	self.points = points
	self.level = level
	self.faith = faith
	
	self.localLevelCap = cwBeliefs.sacramentLevelCap;

	if player:HasBelief("loremaster") then
		self.localLevelCap = self.localLevelCap + 10;
	end
	
	if player:HasBelief("sorcerer") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if player:HasBelief("paradox_riddle_equation") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if player:GetNetVar("subfaction") == "Rekh-khet-sa" then
		self.localLevelCap = self.localLevelCap + 666;
	end

	local scrW, scrH = ScrW(), ScrH()
	local sizeW, sizeH = 1555, 928;
	local centerW, centerH = scrW * 0.5, scrH * 0.5

	self:SetSize(sizeW, sizeH)
	self:SetPos(centerW - (sizeW / 2), centerH - (sizeH / 2))

	local x, y = 9, 8;
	
	if (!self.panelList) then
		self.panelList = vgui.Create("DPanelList", self);
		self.panelList:EnableHorizontal(true);
		self.panelList:EnableVerticalScrollbar();
		self.panelList:HideScrollbar();
		self.panelList:SetPos(x, y);
		self.panelList:SetSize(1538, 816);
		self.panelList:SetPadding(0);
		self.panelList:SetSpacing(2);
		self.panelList:SetPaintBackground(false);
	end

	if (!self.closeButton) then
		self.closeButton = vgui.Create("DButton", self)
		self.closeButton:SetText("CLOSE")
		self.closeButton:SetSize(252, 67)
		self.closeButton:SetPos(14, (sizeH) - (67 + 8) - 2)
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
	
	self:RebuildBeliefTrees();
	
	if highlightBelief then
		for k, v in pairs(self.panelList:GetItems()) do
			if v.buttons then
				for k2, v2 in pairs(v.buttons) do
					if v2.uniqueID == highlightBelief then
						v2.highlightAlpha = 220;
						v2:SetDrawOnTop(true);
						Clockwork.Client.cwBeliefPanel.highlightAlpha = 220;
					
						v2.PaintOver = function(panel, w, h)
							if panel.highlightAlpha < 220 then
								panel.highlightAlpha = math.max(0, panel.highlightAlpha - (FrameTime() * 200));
							end
							
							surface.SetDrawColor(Color(200, 150, 10, panel.highlightAlpha));
							surface.DrawOutlinedRect(0, 0, w, h, 2);
						end

						timer.Simple(3, function()
							if IsValid(v2) then
								Clockwork.Client.cwBeliefPanel.highlightAlpha = Clockwork.Client.cwBeliefPanel.highlightAlpha - (FrameTime() * 200);
								v2.highlightAlpha = (v2.highlightAlpha - (FrameTime() * 200));
								
								timer.Simple(2, function()
									if IsValid(v2) then
										Clockwork.Client.cwBeliefPanel.highlightAlpha = nil;
										v2:SetDrawOnTop(false);
										v2.PaintOver = nil;
									end
								end);
							end	
						end);
					
						break;
					end
				end
			end
		end
	end	

	self:ShowCloseButton(false)
end

function PANEL:RebuildBeliefTrees()
	self.panelList:Clear();

	local faith = self.player:GetNetVar("faith");

	for k, v in SortedPairsByMemberValue(cwBeliefs:GetBeliefTrees(), "order") do
		if v.requiredFaiths and !table.HasValue(v.requiredFaiths, faith) then
			continue;
		end
		
		local beliefTreePanel = vgui.Create("Panel", self)
		
		-- Some manual centering for the bottom row, can't think of a better way to do this right now.
		if v.order == 6 then
			beliefTreePanel:SetSize(v.size.w + 3, v.size.h)
		elseif v.order == 7 then
			beliefTreePanel:SetSize(v.size.w + 4, v.size.h)
		else
			beliefTreePanel:SetSize(v.size.w, v.size.h)
		end
		
		beliefTreePanel.texture = v.textures[1];
		beliefTreePanel.buttons = {}
		beliefTreePanel.uniqueID = v.uniqueID;
		beliefTreePanel.color = v.color;
		
		beliefTreePanel.arrows = vgui.Create("DImage", beliefTreePanel)
		beliefTreePanel.arrows:SetSize(v.size.w, v.size.h)
		beliefTreePanel.arrows:SetImage("begotten/ui/menu/"..v.textures[2]..".png");
		
		-- Called when the panel is painted.
		function beliefTreePanel:Paint(w, h)
			cwBeliefs:DrawTreeBackground(0, 0, v.size.w, v.size.h, self);
		end

		local font = v.headerFontOverride or "nov_IntroTextSmallaaaaa";
		
		if v.headerFontOverride then
			beliefTreePanel.noShadow = true;
		end
		
		self:AddHeader({
			name = v.name,
			parent = beliefTreePanel,
			font = font,
			tooltip = function(frame)
				frame:AddText(v.tooltip[1][1], v.tooltip[1][2], v.tooltip[1][3]);
				frame:AddText(v.tooltip[2][1], v.tooltip[2][2]);
				frame:AddText(v.tooltip[3][1], v.tooltip[3][2]);
				frame:AddText(v.tooltip[4][1], v.tooltip[4][2]);
			end,
			color = v.color;
		})
		
		local columnPositions = v.columnPositions;
		local rowPositions = v.rowPositions;
		
		if v.disabled then
			beliefTreePanel.disabled = v.disabled;
		end
		
		if v.lockedFactions then
			beliefTreePanel.lockedFactions = v.lockedFactions;
		end
		
		if v.lockedSubfactions then
			beliefTreePanel.lockedSubfactions = v.lockedSubfactions;
		end
		
		if v.lockedTraits then
			beliefTreePanel.lockedTraits = v.lockedTraits;
		end
		
		if v.lockedBeliefs then
			beliefTreePanel.lockedBeliefs = v.lockedBeliefs;
		end
		
		for i, v2 in ipairs(v.beliefs) do
			for uniqueID, belief in pairs(v2) do
				local iconTable = {};
				
				iconTable.parent = beliefTreePanel;
				iconTable.uniqueID = uniqueID;
				iconTable.name = belief.name;
				iconTable.description = belief.description;
				iconTable.quote = belief.quote;
				iconTable.row = belief.row;
				iconTable.x = columnPositions[i] - 22;
				iconTable.y = rowPositions[belief.row] - 22;
				iconTable.width = 48;
				iconTable.height = 48;
				
				if belief.iconOverride then
					iconTable.iconOverride = belief.iconOverride;
				end
				
				if belief.requirements then
					iconTable.requirements = belief.requirements;
					iconTable.requirementsNiceNames = {};
					
					for i2, v3 in ipairs(iconTable.requirements) do
						table.insert(iconTable.requirementsNiceNames, cwBeliefs:GetBeliefName(v3, k));
					end
				end
				
				if belief.subfaith then
					iconTable.subfaith = belief.subfaith;
				end
				
				if belief.disabled then
					iconTable.disabled = true;
				end
				
				if belief.lockedFactions then
					iconTable.lockedFactions = belief.lockedFactions;
				end
				
				if belief.lockedSubfactions then
					iconTable.lockedSubfactions = belief.lockedSubfactions;
				end
				
				if belief.lockedTraits then
					iconTable.lockedTraits = belief.lockedTraits;
				end
				
				if belief.lockedBeliefs then
					iconTable.lockedBeliefs = belief.lockedBeliefs;
				end
			
				self:AddIcon(iconTable);
			end
		end
		
		self.panelList:AddItem(beliefTreePanel);
	end
end

-- Called when the panel is closed.
function PANEL:OnClose()
	--cwBeliefs:RemoveBackgroundBlur(self)
end

vgui.Register("cwBeliefTree", PANEL, "DFrame")
