--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local SYSTEM = Clockwork.system:New("Manage Players")
SYSTEM.toolTip = "Contains a set of useful commands to use players."
SYSTEM.doesCreateForm = false

-- Called to get whether the local player has access to the system.
function SYSTEM:HasAccess()
	return Clockwork.player:IsAdmin(Clockwork.Client)
end

-- Called when the system should be displayed.
function SYSTEM:OnDisplay(systemPanel, systemForm)
	local availableClasses = {}
	local classes = {}

	for _, v in _player.Iterator() do
		if (v:HasInitialized()) then
			local class = hook.Run("GetPlayerScoreboardClass", v)

			if (class) then
				if (!availableClasses[class]) then
					availableClasses[class] = {}
				end

				availableClasses[class][#availableClasses[class] + 1] = v
			end
		end
	end

	for k, v in pairs(availableClasses) do
		table.sort(v, function(a, b)
			return hook.Run("ScoreboardSortClassPlayers", k, a, b)
		end)

		if (#v > 0) then
			classes[#classes + 1] = {name = k, players = v}
		end
	end

	table.sort(classes, function(a, b)
		return a.name < b.name
	end)

	if (table.Count(classes) > 0) then
		local label = vgui.Create("cwInfoText", systemPanel)
			label:SetText("Clicking on a player will bring up all available commands.")
			label:SetInfoColor("blue")
			label:DockMargin(0, 0, 0, 8)
		systemPanel.panelList:AddItem(label)

		for k, v in pairs(classes) do
			local characterForm = vgui.Create("DForm", systemPanel)
			local panelList = vgui.Create("DPanelList", systemPanel)

			for k2, v2 in pairs(v.players) do
				local label = vgui.Create("cwInfoText", systemPanel)
					label:SetText(v2:Name())
					label:SetButton(true)
					label:SetTooltip("This player's name is "..v2:SteamName()..".\nThis player's Steam ID is "..v2:SteamID()..".")
					label:SetInfoColor(Clockwork.kernel:PlayerNameColor(v2))
				panelList:AddItem(label)

				-- Called when the button is clicked.
				function label.DoClick(button)
					if (IsValid(v2)) then
						local options = {}
							hook.Run("GetPlayerScoreboardOptions", v2, options)
						Clockwork.kernel:AddMenuFromData(nil, options)
					end
				end
			end

			systemPanel.panelList:AddItem(characterForm)

			panelList:SetAutoSize(true)
			panelList:SetPadding(4)
			panelList:SetSpacing(4)

			characterForm:SetName(v.name)
			characterForm:AddItem(panelList)
			characterForm:SetPadding(4)
		end
	else
		local label = vgui.Create("cwInfoText", systemPanel)
			label:SetText("There are no players to display.")
			label:SetInfoColor("orange")
		systemPanel.panelList:AddItem(label)
	end
end

SYSTEM:Register()