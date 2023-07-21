--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (CLIENT) then
	local SYSTEM = Clockwork.system:New("Manage Config")
	SYSTEM.toolTip = "An easier way of editing the Clockwork config."
	SYSTEM.doesCreateForm = false
	
	local textColor = Color(20, 20, 20);

	-- Called to get whether the local player has access to the system.
	function SYSTEM:HasAccess()
		local commandTable = Clockwork.command:FindByID("CfgSetVar")

		if (commandTable and Clockwork.player:HasFlags(Clockwork.Client, commandTable.access)) then
			return true
		else
			return false
		end
	end

	-- Called when the system should be displayed.
	function SYSTEM:OnDisplay(systemPanel, systemForm)
		self.adminValues = nil

		self.infoText = vgui.Create("cwInfoText", systemPanel)
			self.infoText:SetText("Click on a config key to begin editing the config value.")
			self.infoText:SetInfoColor("blue")
			self.infoText:SetTextColor(Color(255, 255, 255));
			self.infoText:DockMargin(0, 0, 0, 8)
		systemPanel.panelList:AddItem(self.infoText)

		self.configForm = vgui.Create("DForm", systemPanel)
			self.configForm:SetName("Config")
			self.configForm:SetPadding(4)
		systemPanel.panelList:AddItem(self.configForm)

		self.editForm = vgui.Create("DForm", systemPanel)
			self.editForm:SetName("")
			self.editForm:SetPadding(4)
			self.editForm:SetVisible(false)
		systemPanel.panelList:AddItem(self.editForm)

		if (!self.activeKey) then
			netstream.Start("SystemCfgKeys", true)
		end

		self.listView = vgui.Create("DListView")
			self.listView:AddColumn("Name")
			self.listView:AddColumn("Key")
			self.listView:AddColumn("Added By")
			self.listView:SetMultiSelect(false)
			self.listView:SetTall(256)
		self:PopulateComboBox()

		function self.listView.OnRowSelected(parent, lineID, line)
			netstream.Start("SystemCfgValue", line.key)
		end

		self.configForm:AddItem(self.listView)
	end

	function SYSTEM:PopulateConfigBox()
		self.editForm:Clear(true)

		if (self.activeKey) then
			self.adminValues = config.GetFromSystem(self.activeKey.name)

			self.infoText:SetText("Now you can start to edit the config value, or click another config key.")
		end

		if (self.editForm and !self.editForm:IsVisible()) then
			self.editForm:SetVisible(true)
		end

		if (self.adminValues) then
			for k, v in pairs(string.Explode("\n", self.adminValues.help)) do
				self.editForm:Help(v):SetTextColor(textColor)
			end

			self.editForm:SetName(self.activeKey.name)

			if (self.activeKey.value != nil) then
				local mapEntry, mapLabel = self.editForm:TextEntry("Map")
				mapLabel:SetTextColor(textColor)

				local valueType = type(self.activeKey.value)

				if (valueType == "string") then
					local textEntry, textLabel = self.editForm:TextEntry("Value")
						textLabel:SetTextColor(textColor)
						textEntry:SetValue(self.activeKey.value)
					local okayButton = self.editForm:Button("Okay")

					-- Called when the button is clicked.
					function okayButton.DoClick(okayButton)
						netstream.Start("SystemCfgSet", {
							key = self.activeKey.name,
							value = textEntry:GetValue(),
							useMap = mapEntry:GetValue()
						})
					end
				elseif (valueType == "number") then
					local numSlider = self.editForm:NumSlider("Value", nil, self.adminValues.minimum,
					self.adminValues.maximum, self.adminValues.decimals)
						numSlider.Label:SetTextColor(textColor)
						numSlider:SetValue(self.activeKey.value)
					local okayButton = self.editForm:Button("Okay")

					-- Called when the button is clicked.
					function okayButton.DoClick(okayButton)
						netstream.Start("SystemCfgSet", {
							key = self.activeKey.name,
							value = numSlider:GetValue(),
							useMap = mapEntry:GetValue()
						})
					end
				elseif (valueType == "boolean") then
					local checkBox = self.editForm:CheckBox("On")
						checkBox:SetValue(self.activeKey.value)
						checkBox:SetTextColor(textColor)
					local okayButton = self.editForm:Button("Okay")

					-- Called when the button is clicked.
					function okayButton.DoClick(okayButton)
						netstream.Start("SystemCfgSet", {
							key = self.activeKey.name,
							value = checkBox:GetChecked(),
							useMap = mapEntry:GetValue()
						})
					end
				end
			end
		end
	end

	-- A function to populate the system's combo box.
	function SYSTEM:PopulateComboBox()
		self.listView:Clear(true)

		if (self.configKeys) then
			local defaultConfigItem = nil

			for k, v in pairs(self.configKeys) do
				local adminValues = config.GetFromSystem(v)

				if (adminValues) then
					local comboBoxItem = self.listView:AddLine(adminValues.name, v, adminValues.category)
						comboBoxItem:SetTooltip(adminValues.help)
						comboBoxItem.key = v

					if (self.activeKey and self.activeKey.name == v) then
						defaultConfigItem = comboBoxItem
					end
				end
			end

			if (defaultConfigItem) then
				self.listView:SelectItem(defaultConfigItem, true)
			end

			self.listView:SortByColumn(1)
		end
	end

	SYSTEM:Register()

	netstream.Hook("SystemCfgKeys", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Config")

		if (systemTable) then
			systemTable.configKeys = data
			systemTable:PopulateComboBox()
		end
	end)

	netstream.Hook("SystemCfgValue", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Config")

		if (systemTable) then
			systemTable.activeKey = { name = data[1], value = data[2] }
			systemTable:PopulateConfigBox()
		end
	end)
else
	netstream.Hook("SystemCfgSet", function(player, data)
		local commandTable = Clockwork.command:FindByID("CfgSetVar")

		if (commandTable and Clockwork.player:HasFlags(player, commandTable.access)) then
			local configObject = config.Get(data.key)

			if (configObject:IsValid()) then
				local keyPrefix = ""
				local useMap = data.useMap

				if (useMap == "") then
					useMap = nil
				end

				if (useMap) then
					useMap = string.lower(Clockwork.kernel:Replace(useMap, ".bsp", ""))
					keyPrefix = useMap.."'s "

					if (!file.Exists("maps/"..useMap..".bsp", "GAME")) then
						Schema:EasyText(player, "darkgrey", useMap.." is not a valid map!")

						return
					end
				end

				if (!configObject("isStatic")) then
					value = configObject:Set(data.value, useMap)

					if (value != nil) then
						local printValue = tostring(value)

						if (configObject("isPrivate")) then
							if (configObject("needsRestart")) then
								Schema:EasyText(GetAdmins(), "skyblue", player:Name().." set "..keyPrefix..data.key.." to '"..string.rep("*", string.utf8len(printValue)).."' for the next restart.")
							else
								Schema:EasyText(GetAdmins(), "skyblue", player:Name().." set "..keyPrefix..data.key.." to '"..string.rep("*", string.utf8len(printValue)).."'.")
							end
						elseif (configObject("needsRestart")) then
							Schema:EasyText(GetAdmins(), "skyblue", player:Name().." set "..keyPrefix..data.key.." to '"..printValue.."' for the next restart.")
						else
							Schema:EasyText(GetAdmins(), "skyblue", player:Name().." set "..keyPrefix..data.key.." to '"..printValue.."'.")
						end

						netstream.Start(player, "SystemCfgValue", { data.key, configObject:Get() })
					else
						Schema:EasyText(player, "darkgrey", data.key.." was unable to be set!")
					end
				else
					Schema:EasyText(player, "darkgrey", data.key.." is a static config key!")
				end
			else
				Schema:EasyText(player, "darkgrey", data.key.." is not a valid config key!")
			end
		end
	end)

	netstream.Hook("SystemCfgKeys", function(player, data)
		local configKeys = {}

		for k, v in pairs(config.GetStored()) do
			if (!v.isStatic) then
				configKeys[#configKeys + 1] = k
			end
		end

		table.sort(configKeys, function(a, b)
			return a < b
		end)

		netstream.Start(player, "SystemCfgKeys", configKeys)
	end)

	netstream.Hook("SystemCfgValue", function(player, data)
		local configObject = config.Get(data)

		if (configObject:IsValid()) then
			if (type(configObject:Get()) == "string" and configObject("isPrivate")) then
				netstream.Start(player, "SystemCfgValue", {data, "****"})
			else
				netstream.Start(player, "SystemCfgValue", {
					data, configObject:GetNext(configObject:Get())
				})
			end
		end
	end)
end