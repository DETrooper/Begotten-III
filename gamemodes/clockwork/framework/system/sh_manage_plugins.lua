--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (CLIENT) then
	local SYSTEM = Clockwork.system:New("Manage Plugins")
	SYSTEM.toolTip = "You can load and unload plugins from here."
	SYSTEM.doesCreateForm = false

	-- Called to get whether the local player has access to the system.
	function SYSTEM:HasAccess()
		local unloadTable = Clockwork.command:FindByID("PluginUnload")
		local loadTable = Clockwork.command:FindByID("PluginLoad")

		if (loadTable and unloadTable) then
			if (Clockwork.player:HasFlags(Clockwork.Client, loadTable.access)
			or Clockwork.player:HasFlags(Clockwork.Client, unloadTable.access)) then
				return true
			end
		end

		return false
	end

	-- Called when the system should be displayed.
	function SYSTEM:OnDisplay(systemPanel, systemForm)
		pluginButtons = {}

		local donePlugins = {}
		local categories = {}
		local mainPlugins = {}

		for k, v in pairs(plugin.GetStored()) do
			if (v != Schema) then
				categories[v.author] = categories[v.author] or {}
				categories[v.author][#categories[v.author] + 1] = v
			end
		end

		for k, v in pairs(categories) do
			table.sort(v, function(a, b)
				return a.name < b.name
			end)

			mainPlugins[#mainPlugins + 1] = {
				category = k,
				plugins = v
			}
		end

		table.sort(mainPlugins, function(a, b)
			return a.category < b.category
		end)

		netstream.Start("SystemPluginGet", true)

		if (#mainPlugins > 0) then
			local label = vgui.Create("cwInfoText", systemPanel)
				label:SetText("Red plugins are unloaded, green ones are loaded, and orange are disabled.")
				label:SetInfoColor("blue")
				label:DockMargin(0, 0, 0, 8)
			systemPanel.panelList:AddItem(label)

			for k, v in pairs(mainPlugins) do
				local pluginForm = vgui.Create("DForm", systemPanel)
				local panelList = vgui.Create("DPanelList", systemPanel)

				for k2, v2 in pairs(v.plugins) do
					pluginButtons[v2.name] = vgui.Create("cwInfoText", systemPanel)
						pluginButtons[v2.name]:SetText(v2.name)
						pluginButtons[v2.name]:SetButton(true)
						pluginButtons[v2.name]:SetTooltip(v2.description)
					panelList:AddItem(pluginButtons[v2.name])

					if (plugin.IsDisabled(v2.name)) then
						pluginButtons[v2.name]:SetInfoColor("orange")
						pluginButtons[v2.name]:SetButton(false)
					elseif (plugin.IsUnloaded(v2.name)) then
						pluginButtons[v2.name]:SetInfoColor("red")
					else
						pluginButtons[v2.name]:SetInfoColor("green")
					end

					-- Called when the button is clicked.
					pluginButtons[v2.name].DoClick = function(button)
						if (!plugin.IsDisabled(v2.name)) then
							if (plugin.IsUnloaded(v2.name)) then
								netstream.Start("SystemPluginSet", {v2.name, false})
							else
								netstream.Start("SystemPluginSet", {v2.name, true})
							end
						end
					end
				end

				systemPanel.panelList:AddItem(pluginForm)

				panelList:SetAutoSize(true)
				panelList:SetPadding(4)
				panelList:SetSpacing(4)

				pluginForm:SetName(v.category)
				pluginForm:AddItem(panelList)
				pluginForm:SetPadding(4)
			end
		else
			local label = vgui.Create("cwInfoText", systemPanel)
				label:SetText("There are no plugins installed on the server.")
				label:SetInfoColor("red")
			systemPanel.panelList:AddItem(label)
		end
	end

	-- A function to update the plugin buttons.
	function SYSTEM:UpdatePluginButtons()
		for k, v in pairs(pluginButtons) do
			if (plugin.IsDisabled(k)) then
				v:SetInfoColor("orange")
				v:SetButton(false)
			elseif (plugin.IsUnloaded(k)) then
				v:SetInfoColor("red")
				v:SetButton(true)
			else
				v:SetInfoColor("green")
				v:SetButton(true)
			end
		end
	end

	SYSTEM:Register()

	netstream.Hook("SystemPluginGet", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Plugins")
		local unloaded = data

		for k, v in pairs(plugin.GetStored()) do
			if (unloaded[v.folderName]) then
				plugin.SetUnloaded(v.name, true)
			else
				plugin.SetUnloaded(v.name, false)
			end
		end

		if (systemTable and systemTable:IsActive()) then
			systemTable:UpdatePluginButtons()
		end
	end)

	netstream.Hook("SystemPluginSet", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Plugins")
		local pluginTable = plugin.FindByID(data[1])

		if (pluginTable) then
			plugin.SetUnloaded(pluginTable.name, (data[2] == true))
		end

		if (systemTable and systemTable:IsActive()) then
			systemTable:UpdatePluginButtons()
		end
	end)
else
	netstream.Hook("SystemPluginGet", function(player, data)
		netstream.Start(player, "SystemPluginGet", plugin.GetUnloaded())
	end)

	netstream.Hook("SystemPluginSet", function(player, data)
		local unloadTable = Clockwork.command:FindByID("PluginLoad")
		local loadTable = Clockwork.command:FindByID("PluginLoad")

		if (data[2] == true and (!loadTable or !Clockwork.player:HasFlags(player, loadTable.access))) then
			return
		elseif (data[2] == false and (!unloadTable or !Clockwork.player:HasFlags(player, unloadTable.access))) then
			return
		elseif (type(data[2]) != "boolean") then
			return
		end

		local pluginTable = plugin.FindByID(data[1])

		if (!pluginTable) then
			Schema:EasyText(player, "grey", "This plugin is not valid!")
			return
		end

		if (!plugin.IsDisabled(pluginTable.name)) then
			local bSuccess = plugin.SetUnloaded(pluginTable.name, data[2])
			local recipients = {}

			if (bSuccess) then
				if (data[2]) then
					Schema:EasyText(Schema:GetAdmins(), "skyblue", player:Name().." has unloaded the "..pluginTable.name.." plugin for the next restart.")
				else
					Schema:EasyText(Schema:GetAdmins(), "skyblue", player:Name().." has loaded the "..pluginTable.name.." plugin for the next restart.")
				end

				for _, v in _player.Iterator() do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v
						end
					end
				end

				if (#recipients > 0) then
					netstream.Start(recipients, "SystemPluginSet", { pluginTable.name, data[2] })
				end
			elseif (data[2]) then
				Schema:EasyText(player, "grey", "This plugin could not be unloaded!")
			else
				Schema:EasyText(player, "grey", "This plugin could not be loaded!")
			end
		else
			Schema:EasyText(player, "darkgrey", "This plugin depends on another plugin!")
		end
	end)
end