--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

netstream.Hook("RunCommand", function(data)
	RunConsoleCommand(unpack(data))
end)

netstream.Hook("cwClipboardText", function(data)
	SetClipboardText(data)
end)

netstream.Hook("TraitSync", function(data)
	Clockwork.Client.cwTraits = {};

	--for k, v in pairs (data) do
		--Clockwork.Client.cwTraits[v] = true;
	--end;
	
	for i = 1, #data do
		Clockwork.Client.cwTraits[i] = data[i];
	end
end);

netstream.Hook("SharedTables", function(data)
	Clockwork.SharedTables = data
end)

netstream.Hook("SetSharedTableVar", function(data)
	Clockwork.SharedTables[data.sharedTable] = Clockwork.SharedTables[data.sharedTable] or {}
	Clockwork.SharedTables[data.sharedTable][data.key] = data.value
end)

netstream.Hook("HiddenCommands", function(data)
	for k, v in pairs(data) do
		for k2, v2 in pairs(Clockwork.command:GetAll()) do
			if (Clockwork.kernel:GetShortCRC(k2) == v) then
				Clockwork.command:SetHidden(k2, true)

				break
			end
		end
	end
end)

netstream.Hook("OrderTime", function(data)
	Clockwork.OrderCooldown = data

	local activePanel = Clockwork.menu:GetActivePanel()

	if (activePanel and activePanel:GetPanelName() == Clockwork.option:GetKey("name_business")) then
		activePanel:Rebuild()
	end
end)

netstream.Hook("CharacterInit", function(data)
	hook.Run("PlayerCharacterInitialized", data)
end)

netstream.Hook("Log", function(data)
	local logType = data.logType
	local text = data.text

	Clockwork.kernel:PrintColoredText(Clockwork.kernel:GetLogTypeColor(logType), text)
end)

netstream.Hook("StartSound", function(data)
	if (IsValid(Clockwork.Client)) then
		local uniqueID = data.uniqueID
		local sound = data.sound
		local volume = data.volume

		if (!Clockwork.ClientSounds) then
			Clockwork.ClientSounds = {}
		end

		if (Clockwork.ClientSounds[uniqueID]) then
			Clockwork.ClientSounds[uniqueID]:Stop()
		end

		Clockwork.ClientSounds[uniqueID] = CreateSound(Clockwork.Client, sound)
		Clockwork.ClientSounds[uniqueID]:PlayEx(volume, 100)
	end
end)

netstream.Hook("StopSound", function(data)
	local uniqueID = data.uniqueID
	local fadeOut = data.fadeOut

	if (!Clockwork.ClientSounds) then
		Clockwork.ClientSounds = {}
	end

	if (Clockwork.ClientSounds[uniqueID]) then
		if (fadeOut != 0) then
			Clockwork.ClientSounds[uniqueID]:FadeOut(fadeOut)
		else
			Clockwork.ClientSounds[uniqueID]:Stop()
		end

		Clockwork.ClientSounds[uniqueID] = nil
	end
end)

netstream.Hook("InfoToggle", function(data)
	if (IsValid(Clockwork.Client) and Clockwork.Client:HasInitialized()) then
		if (!Clockwork.InfoMenuOpen) then
			Clockwork.InfoMenuOpen = true
			Clockwork.kernel:RegisterBackgroundBlur("InfoMenu", SysTime())
		else
			Clockwork.kernel:RemoveBackgroundBlur("InfoMenu")
			Clockwork.kernel:CloseActiveDermaMenus()
			Clockwork.InfoMenuOpen = false
		end
	end
end)

netstream.Hook("PlaySound", function(data)
	surface.PlaySound(data)
end)

netstream.Hook("RequestCountryCode", function(data)
	netstream.Start("SendCountryCode", system.GetCountry());
end);

netstream.Hook("RadioState", function(data)
	Clockwork.Client.radioState = data or false;
end)

netstream.Hook("EmitSound", function(data)
	local name, pitch, level = data.name, data.pitch or 100, data.level or 75;

	if (name) then
		if (IsValid(data.entity) and type(data.entity) == "Entity" or type(data.entity) == "Player") then
			data.entity:EmitSound(name, level, pitch)
		elseif (type(data.entity) == "Vector") then
			sound.Play(name, data.entity, level, pitch);
		elseif (isstring(data.entity) or isnumber(data.entity)) then
			local index = data.entity;
			local entities = ents.GetAll();
			local entity;
			
			for i = 1, ents.GetCount() do
				if (entities[i]:EntIndex() == index) then
					entity = entities[i];
				end;
			end;
			
			if (entity != nil and IsValid(entity)) then
				entity:EmitSound(name, level, pitch)
			end;
		else
			Clockwork.Client:EmitSound(name, level, pitch)
		end;
	end;
end)

netstream.Hook("DataStreaming", function(data)
	netstream.Start("DataStreamInfoSent", true)
end)

netstream.Hook("DataStreamed", function(data)
	Clockwork.DataHasStreamed = true
end)

netstream.Hook("QuizCompleted", function(data)
	if (!data) then
		if (!Clockwork.quiz:GetCompleted()) then
			Clockwork.Client.Pending = true;
			gui.EnableScreenClicker(true)

			Clockwork.quiz.panel = vgui.Create("cwQuiz")
			Clockwork.quiz.panel:Populate()
			Clockwork.quiz.panel:MakePopup()
			
			Clockwork.Client.QuizMusic = CreateSound(Clockwork.Client, "begotten3soundtrack/quiz/bt-theivthcrusade.mp3");
			Clockwork.Client.QuizMusic:PlayEx(0.75, 100);
		end
	else
		local characterPanel = Clockwork.character:GetPanel()
		local quizPanel = Clockwork.quiz:GetPanel()
		
		if Clockwork.Client.QuizMusic then
			Clockwork.Client.QuizMusic:FadeOut(4);
		end

		if (quizPanel) then
			Clockwork.quiz:SetCompleted(true)
			Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 3, 1.1);
		
			quizPanel:Remove()
		end
	end
end)

netstream.Hook("RecogniseMenu", function(data)
	local menuPanel = Clockwork.kernel:AddMenuFromData(nil, {
		["All characters within whispering range."] = function()
			netstream.Start("RecogniseOption", "whisper")
		end,
		["All characters within yelling range."] = function()
			netstream.Start("RecogniseOption", "yell")
		end,
		["All characters within talking range."] = function()
			netstream.Start("RecogniseOption", "talk")
		end,
		["The character you are looking at."] = function()
			netstream.Start("RecogniseOption", "look")
		end
	})

	if (IsValid(menuPanel)) then
		menuPanel:SetPos(
			(ScrW() / 2) - (menuPanel:GetWide() / 2), (ScrH() / 2) - (menuPanel:GetTall() / 2)
		)
	end

	Clockwork.kernel:SetRecogniseMenu(menuPanel)
end)

netstream.Hook("ReloadMenu", function(data)
	local activeWeapon = Clockwork.Client:GetActiveWeapon();
	
	if !activeWeapon:IsValid() then return end;
	if activeWeapon.Base ~= "begotten_firearm_base" then return end;
	
	local weaponItem = item.GetByWeapon(activeWeapon);
	
	if !weaponItem then return end;
	
	local menuOptions = {};
	
	local ammo = weaponItem:GetData("Ammo");
	
	if ammo and #ammo > 0 then
		menuOptions["Unload"] = function()
			if weaponItem then
				Clockwork.inventory:InventoryAction("ammo", weaponItem.uniqueID, weaponItem.itemID);
			end
		end
	elseif weaponItem.ammoTypes then
		local inventory = Clockwork.inventory:GetClient();
	
		for i, v in ipairs(weaponItem.ammoTypes) do
			local ammoItemTable = item.FindByID(string.lower(v));
			
			if ammoItemTable then
				local itemInstances = inventory[ammoItemTable.uniqueID];
				
				if itemInstances and !table.IsEmpty(itemInstances) then
					local ammoItem = table.Random(itemInstances);
					
					menuOptions[v] = function()
						if weaponItem then
							netstream.Start("UseAmmo", {ammoItem.uniqueID, ammoItem.itemID, weaponItem("uniqueID"), weaponItem("itemID")});
						end
					end
				end
			end
		end
	end
	
	if !table.IsEmpty(menuOptions) then
		local menuPanel = Clockwork.kernel:AddMenuFromData(nil, menuOptions);

		if (IsValid(menuPanel)) then
			menuPanel:SetPos(
				(ScrW() / 2) - (menuPanel:GetWide() / 2), (ScrH() / 2) - (menuPanel:GetTall() / 2)
			)
			
			return;
		end
	end
	
	Schema:EasyText("chocolate", "No valid ammo could be found for this weapon!");
end)

netstream.Hook("ClockworkIntro", function(data)
	if (!Clockwork.ClockworkIntroFadeOut) then
		local introImage = Clockwork.option:GetKey("intro_image")
		local introSound = Clockwork.option:GetKey("intro_sound")
		local duration = 8
		local curTime = UnPredictedCurTime()

		if (introImage != "") then
			duration = 16
		end

		Clockwork.ClockworkIntroWhiteScreen = curTime + (FrameTime() * 8)
		Clockwork.ClockworkIntroFadeOut = curTime + duration
		Clockwork.ClockworkIntroSound = CreateSound(Clockwork.Client, introSound)
		Clockwork.ClockworkIntroSound:PlayEx(0.75, 100)

		timer.Simple(duration - 4, function()
			Clockwork.ClockworkIntroSound:FadeOut(4)
			Clockwork.ClockworkIntroSound = nil
		end)

		surface.PlaySound("buttons/button1.wav")
	end
end)

netstream.Hook("SharedVar", function(data)
	local key = data.key
	local sharedVars = Clockwork.kernel:GetNetVars():Player()

	if (sharedVars and sharedVars[key]) then
		local sharedVarData = sharedVars[key]

		if (sharedVarData) then
			sharedVarData.value = data.value
		end
	end
end)

netstream.Hook("HideCommand", function(data)
	local index = data.index

	for k, v in pairs(Clockwork.command:GetAll()) do
		if (Clockwork.kernel:GetShortCRC(k) == index) then
			Clockwork.command:SetHidden(k, data.hidden)

			break
		end
	end
end)

netstream.Hook("CfgListVars", function(data)
	Clockwork.Client:PrintMessage(2, "######## [Clockwork] Config ########\n")
		local sSearchData = data
		local tConfigRes = {}

		if (sSearchData) then
			sSearchData = string.lower(sSearchData)
		end

		for k, v in pairs(config.GetStored()) do
			if (type(v.value) != "table" and (!sSearchData or string.find(string.lower(k), sSearchData)) and !v.isStatic) then
				if (v.isPrivate) then
					tConfigRes[#tConfigRes + 1] = {
						k, string.rep("*", string.utf8len(tostring(v.value)))
					}
				else
					tConfigRes[#tConfigRes + 1] = {
						k, tostring(v.value)
					}
				end
			end
		end

		table.sort(tConfigRes, function(a, b)
			return a[1] < b[1]
		end)

		for k, v in pairs(tConfigRes) do
			local systemValues = config.GetFromSystem(v[1])

			if (systemValues) then
				Clockwork.Client:PrintMessage(2, "// "..systemValues.help.."\n")
			end

			Clockwork.Client:PrintMessage(2, v[1].." = \""..v[2].."\";\n")
		end
	Clockwork.Client:PrintMessage(2, "######## [Clockwork] Config ########\n")
end)

netstream.Hook("ClearRecognisedNames", function(data)
	Clockwork.RecognisedNames = {}
end)

netstream.Hook("RecognisedName", function(data)
	local key = data.key
	local status = data.status

	if (status > 0) then
		Clockwork.RecognisedNames[key] = status
	else
		Clockwork.RecognisedNames[key] = nil
	end
end)

netstream.Hook("ClearHints", function()
	Clockwork.kernel:ClearHints()
end)

netstream.Hook("Hint", function(data)
	if (istable(data)) then
		if (data.center) then
			Clockwork.kernel:AddCenterHint(
				Clockwork.kernel:ParseData(data.text), data.delay, data.color, data.noSound, data.showDuplicates
			)
		else
			Clockwork.kernel:AddTopHint(
				Clockwork.kernel:ParseData(data.text), data.delay, data.color, data.noSound, data.showDuplicates
			)
		end
	end
end)

netstream.Hook("WeaponItemData", function(data)
	local weapon = Entity(data.weapon)

	if (IsValid(weapon)) then
		weapon.cwItemTable = item.CreateInstance(
			data.definition.index, data.definition.itemID, data.definition.data
		)
	end
end)

netstream.Hook("CinematicText", function(data)
	if (istable(data)) then
		Clockwork.kernel:AddCinematicText(data.text, data.color, data.barLength, data.hangTime)
	end
end)

netstream.Hook("Notification", function(data)
	local text = data.text
	local class = data.class
	--[[local sound = "ambient/water/drip2.wav"

	if (class == 1) then
		sound = "buttons/button10.wav"
	elseif (class == 2) then
		sound = "buttons/button17.wav"
	elseif (class == 3) then
		sound = "buttons/bell1.wav"
	elseif (class == 4) then
		sound = "buttons/button15.wav"
	end]]--

	local info = {
		class = class,
		--sound = sound,
		text = text
	}

	if (hook.Run("NotificationAdjustInfo", info)) then
		Clockwork.kernel:AddNotify(info.text, info.class, 10)
			--surface.PlaySound(info.sound)
		print(info.text)
	end
end)

netstream.Hook("PrintWithColor", function(text, color)
	if (text and color) then
		MsgC(color, text.."\n");
	end;
end);

netstream.Hook("PrintTableWithColor", function(data)
	if (data and isstring(data) and string.len(data) > 0) then
		for k, v in pairs (pon.decode(data)) do
			MsgC(v, k.."\n");
		end;
	end;
end);