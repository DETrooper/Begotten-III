--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.config:AddToSystem("Error logging", "clockwork_log_errors", "Whether or not to log errors to disk");

function GM:OnUndo(name, customText)
	if (!customText) then
		customText = "UNDONE "..name;
	end;
	Clockwork.kernel:AddTopHint(customText, 3, Color(200, 200, 255), true, true, "icon32/hand_property.png");
	surface.PlaySound("begotten/ui/buttonrollover.wav")
end;

-- Called when derma skin's name is needed.
function GM:ForceDermaSkin()
	return "Begotten";
end

function GM:HUDWeaponPickedUp(...) end
function GM:HUDItemPickedUp(...) end
function GM:HUDAmmoPickedUp(...) end

function GM:OnContextMenuOpen()
	if (Clockwork.player:IsAdmin(Clockwork.Client)) then
		return self.BaseClass:OnContextMenuOpen(self)
	else
		gui.EnableScreenClicker(true)
	end
end

function GM:OnContextMenuClose()
	if (Clockwork.player:IsAdmin(Clockwork.Client)) then
		return self.BaseClass:OnContextMenuClose(self)
	else
		gui.EnableScreenClicker(false)
	end
end

function GM:SpawnMenuOpen()
	if (Clockwork.player:IsAdmin(Clockwork.Client)) then
		return true;
	else
		return false;
	end
end

--[[
	@codebase Client
	@details Called when the directory is rebuilt.
	@param <DPanel> The directory panel.
--]]
function GM:ClockworkDirectoryRebuilt(panel)

end

function GM:DirectoryOpenPage(panel, ...)
	local args = {...};
	local pageName = args[1];
	
	if pageName then
		local colBlack = Color(0, 0, 0, 225);
		local colRed = Color(200, 0, 0);
		local colGreen = Color(0, 200, 0);
		local panelList = panel.panelList;
		local width = panelList:GetWide() - panelList:GetSpacing();
	
		if pageName == "Factions" then
			for k, v in SortedPairsByMemberValue(Clockwork.faction.stored, "name") do
				if !v.hidden and !v.disabled then
					local factionInfo = vgui.Create("DPanel", panel);
					local factionLogo = vgui.Create("DImage", factionInfo);
					local factionTitle = vgui.Create("DLabel", factionInfo);
					local factionDescriptionList = vgui.Create("DPanelList", factionInfo);
					local factionDescription = vgui.Create("DLabel", factionInfo);
					local subfactionText;
					
					factionInfo:SetSize(width, 180);
					factionLogo:SetImage("begotten/ui/charactermenu/"..string.lower(v.name)..".png");
					factionLogo:SetSize(170, 170);
					factionLogo:SetPos(4, 4);
					factionTitle:SetPos(172, 4);
					factionTitle:SetFont("manifestoContentHeader");
					factionTitle:SetText(v.name);
					factionTitle:SetTextColor(colRed);
					factionTitle:SizeToContents();
					factionDescription:SetFont("manifestoContent");
					factionDescription:SetText(string.gsub(v.description, "[\n\r]", ""));
					factionDescription:SetWide(width - 200);
					factionDescription:SetWrap(true);
					factionDescription:SetAutoStretchVertical(true);
					factionDescriptionList:SetPaintBackground(false);
					factionDescriptionList:SetPos(176, 34);
					factionDescriptionList:SetSize(width - 204, 110);
					factionDescriptionList:AddItem(factionDescription);
					factionDescriptionList:EnableVerticalScrollbar();
					
					if v.subfactions then
						subfactionText = vgui.Create("RichText", factionInfo);
						subfactionText:SetPos(172, factionDescriptionList:GetY() + factionDescriptionList:GetTall());
						subfactionText:SetWide(width - 204);
						subfactionText:SetVerticalScrollbarEnabled(false);
						
						subfactionText:InsertColorChange(220, 220, 220, 255)
						subfactionText:AppendText("Subfactions: ");
						
						for i, subfactionTable in ipairs(v.subfactions) do
							if subfactionTable.maps and !table.HasValue(subfactionTable.maps, game.GetMap()) then
								continue;
							end
							
							if i > 1 then
								subfactionText:InsertColorChange(220, 220, 220, 255)
								subfactionText:AppendText(", ");
							end
							
							subfactionText:InsertColorChange(255, 20, 20, 255)
							subfactionText:InsertClickableTextStart(v.name.."_subfaction_"..subfactionTable.name);
							subfactionText:AppendText(subfactionTable.name);
							subfactionText:InsertClickableTextEnd();
						end
						
						function subfactionText:PerformLayout()
							self:SetUnderlineFont("manifestoContent");
							self:SetFontInternal("manifestoContent");
						end
						
						function subfactionText:OnTextClicked(id)
							Clockwork.directory.panel:OpenPage(id);
						end
						
						subfactionText:SetHeight(40);
					end
					
					factionInfo.Paint = function(panel, w, h)
						draw.RoundedBox(8, 0, 0, w, h, Color(32, 0, 0, 245));
					end
					
					panelList:AddItem(factionInfo);
				end
			end
		elseif pageName == "Commands" then
			local importantCommandList = vgui.Create("DPanelList", panel);
			local adminCommandList;
			local commandList = vgui.Create("DPanelList", panel);
			
			importantCommandList:HideScrollbar();
			importantCommandList:SetPaintBackground(false);
			commandList:SetPaintBackground(false);
			
			if Clockwork.Client:IsAdmin() then
				adminCommandList = vgui.Create("DPanelList", panel);
				adminCommandList:SetPaintBackground(false);
				adminCommandList:HideScrollbar();
			end
			
			commandList:HideScrollbar();
			
			local height = 0;
			local height2 = 0;
			local height3 = 0;
			
			for k, v in SortedPairs(Clockwork.command.stored) do
				local commandHolder = vgui.Create("DPanel", panel);
				
				commandHolder:SetWide(width);
				
				commandHolder.Paint = function(panel, w, h)
					draw.RoundedBox(2, 0, 0, w, h, colBlack);
				end
				
				local commandTitle = vgui.Create("DLabel", commandHolder);
				local commandDescription = vgui.Create("DLabel", commandHolder);
				
				commandTitle:SetWrap(true);
				commandTitle:SetAutoStretchVertical(true);
				commandTitle:SetWide(width - 8);
				commandTitle:SetFont("manifestoContentSubtitle");
				commandTitle:SetTextColor(colRed);
				commandDescription:SetWide(width - 8);
				commandDescription:SetWrap(true);
				commandDescription:SetAutoStretchVertical(true);
				commandDescription:SetFont("manifestoContent");
				
				if v.alias then
					commandTitle:SetText("/"..v.name.." (/"..table.concat(v.alias, ", /")..")");
				else
					commandTitle:SetText("/"..v.name);
				end
				
				commandTitle:SetX(4);
				commandDescription:SetText(v.tip);
				commandDescription:SetPos(4, commandTitle:GetY() + commandTitle:GetTall() + 2);
				commandHolder:SetHeight(commandTitle:GetTall() + commandDescription:GetTall() + 2);
				
				if v.important then
					importantCommandList:AddItem(commandHolder);
					
					height = height + commandHolder:GetTall();
				elseif v.access ~= "b" then
					if Clockwork.player:HasFlags(Clockwork.Client, v.access) then
						adminCommandList:AddItem(commandHolder);
						
						height2 = height2 + commandHolder:GetTall();
					end
				else
					commandList:AddItem(commandHolder);
					
					height3 = height3 + commandHolder:GetTall();
				end
			end

			local importantCommandLabel = vgui.Create("DLabel", panel);
			local adminCommandLabel;
			local commandLabel = vgui.Create("DLabel", panel);
			
			importantCommandLabel:SetText("Important Commands");
			importantCommandLabel:SetFont("manifestoContentHeader");

			if Clockwork.Client:IsAdmin() then
				adminCommandLabel = vgui.Create("DLabel", panel);
				adminCommandLabel:SetText("Admin Commands");
				adminCommandLabel:SetFont("manifestoContentHeader");
			end
			
			commandLabel:SetText("Other Commands");
			commandLabel:SetFont("manifestoContentHeader");
			
			panelList:AddItem(importantCommandLabel);
			panelList:AddItem(importantCommandList);
			importantCommandList:SetSize(width, height);
			
			if Clockwork.Client:IsAdmin() then
				panelList:AddItem(adminCommandLabel);
				panelList:AddItem(adminCommandList);
				adminCommandList:SetSize(width, height2);
			end
			
			panelList:AddItem(commandLabel);
			panelList:AddItem(commandList);
			commandList:SetSize(width, height3);
			
			panelList:Rebuild();
		elseif pageName == "Flags" then
			for k, v in SortedPairs(Clockwork.flag.stored) do
				local flagHolder = vgui.Create("DPanel", panel);
				
				flagHolder:SetWide(width);
				
				flagHolder.Paint = function(panel, w, h)
					draw.RoundedBox(2, 0, 0, w, h, colBlack);
				end
				
				local flagTitle = vgui.Create("DLabel", flagHolder);
				local flagDescription = vgui.Create("DLabel", flagHolder);
				
				flagTitle:SetWrap(true);
				flagTitle:SetAutoStretchVertical(true);
				flagTitle:SetWide(width - 8);
				flagTitle:SetFont("manifestoContentSubtitle");
				
				if Clockwork.player:HasFlags(Clockwork.Client, k) then
					flagTitle:SetTextColor(colGreen);
				else
					flagTitle:SetTextColor(colRed);
				end
				
				flagDescription:SetWide(width - 8);
				flagDescription:SetWrap(true);
				flagDescription:SetAutoStretchVertical(true);
				flagDescription:SetFont("manifestoContent");
				
				flagTitle:SetText("("..k..") "..v.name);
				flagTitle:SetX(4);
				flagDescription:SetText(v.details);
				flagDescription:SetPos(4, flagTitle:GetY() + flagTitle:GetTall() + 2);
				flagHolder:SetHeight(flagTitle:GetTall() + flagDescription:GetTall() + 2);
				
				panelList:AddItem(flagHolder);
			end
			
			panelList:Rebuild();
		end
	end
end

--[[
	@codebase Client
	@details Called when the local player is given an item.
	@param Table The table of the item that was given.
--]]
function GM:PlayerItemGiven(itemTable)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.storage:GetPanel():Rebuild()
	end

	if (IsValid(Clockwork.inventory.panel)) then
		Clockwork.inventory.panel:Rebuild()
	end
end

--[[
	@codebase Client
	@details Called when the local player has an item taken from them.
	@param Table The table of the item that was taken.
--]]
function GM:PlayerItemTaken(itemTable)
	if (Clockwork.storage:IsStorageOpen()) then
		Clockwork.storage:GetPanel():Rebuild()
	end

	if (IsValid(Clockwork.inventory.panel)) then
		Clockwork.inventory.panel:Rebuild()
	end
end

--[[
	@codebase Client
	@details Called when clockwork's config is initialized.
	@param String The name of the config key.
	@param String The value relating to the key in the table.
--]]
function GM:ClockworkConfigInitialized(key, value)
	if (key == "cash_enabled" and !value) then
		for k, v in pairs(item.GetAll()) do
			v.cost = 0
		end
	end
end

--[[
	@codebase Client
	@details Called when one of the client's console variables have been changed.
	@param String The name of the convar that was changed.
	@param String The previous value of the convar.
	@param String The new value of the convar.
--]]
function GM:ClockworkConVarChanged(name, previousValue, newValue) end

--[[
	@codebase Client
	@details Called when an entity's menu options are needed.
	@param Entity The entity that is being checked for menu options.
	@param Table The table of options for the entity.
--]]
function GM:GetEntityMenuOptions(entity, options)
	local class = entity:GetClass()

	if (class == "cw_item") then
		local itemTable = nil

		if (entity.GetItemTable) then
			itemTable = entity:GetItemTable()
		else
			debug.Trace()
		end

		if (itemTable) then
			local repairText = itemTable("repairText") or "Repair"
			local useText = itemTable("useText") or "Use"

			if (itemTable.OnUse) then
				if not itemTable:IsBroken() then
					options[useText] = "cwItemUse"
				end
			end
			
			if (itemTable.OnRepair) and (itemTable.repairItem) and itemTable:GetCondition() then
				if itemTable:GetCondition() < 100 and !itemTable:IsBroken() then
					if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), itemTable.repairItem) then
						options[repairText] = "cwItemRepair"
					end
				end
			end

			if (itemTable.GetEntityMenuOptions) then
				itemTable:GetEntityMenuOptions(entity, options)
			end

			options["Take"] = "cwItemTake"
			options["Examine"] = "cwItemExamine"
		end
	elseif (class == "cw_belongings") then
		options["Open"] = "cwBelongingsOpen"
	elseif (class == "cw_shipment") then
		options["Open"] = "cwShipmentOpen"
	elseif (class == "cw_cash") then
		options["Take"] = "cwCashTake"
	end
end

--[[
	@codebase Client
	@details Called when the GUI mouse has been released.
--]]
function GM:GUIMouseReleased(code)
	if (!config.Get("use_opens_entity_menus"):Get()
	and vgui.CursorVisible()) then
		local trace = Clockwork.Client:GetEyeTrace()

		if (IsValid(trace.Entity) and trace.HitPos:Distance(Clockwork.Client:GetShootPos()) <= 80) then
			Clockwork.EntityMenu = Clockwork.kernel:HandleEntityMenu(trace.Entity)

			if (IsValid(Clockwork.EntityMenu)) then
				Clockwork.EntityMenu:SetPos(gui.MouseX() - (Clockwork.EntityMenu:GetWide() / 2), gui.MouseY() - (Clockwork.EntityMenu:GetTall() / 2))
			end
		end
	end
end

local last_use;

function GM:KeyPress(player, key)
	if (config.Get("use_opens_entity_menus"):Get()) then
		if (key == IN_USE) then
			local activeWeapon = player:GetActiveWeapon()

			if (activeWeapon:IsValid() and activeWeapon:GetClass() == "weapon_physgun") then
				if (player:KeyDown(IN_ATTACK)) then
					return
				end
			end
			
			local trace = Clockwork.Client:GetEyeTraceNoCursor();
			
			if (IsValid(trace.Entity) and trace.HitPos:Distance(Clockwork.Client:GetShootPos()) <= 80) then
				if trace.Entity:GetClass() == "cw_item" then
					if !timer.Exists("ClockworkQuickUseTimer") then
						last_use = CurTime();
						
						timer.Create("ClockworkQuickUseTimer", 0.25, 1, function()
							local trace = Clockwork.Client:GetEyeTraceNoCursor();
							
							if (IsValid(trace.Entity) and trace.HitPos:Distance(Clockwork.Client:GetShootPos()) <= 80) then
								if trace.Entity:GetClass() == "cw_item" then
									Clockwork.entity:ForceMenuOption(trace.Entity, "Take", "cwItemTake");
								end
							end
						end)
					end
				end
			end
		end
	end
end

--[[
	@codebase Client
	@details Called when a key has been released.
	@param Player The player releasing a key.
	@param Key The key that is being released.
--]]
function GM:KeyRelease(player, key)
	if (config.Get("use_opens_entity_menus"):Get()) then
		if (key == IN_USE) then
			local activeWeapon = player:GetActiveWeapon()

			if (activeWeapon:IsValid() and activeWeapon:GetClass() == "weapon_physgun") then
				if (player:KeyDown(IN_ATTACK)) then
					return
				end
			end
			
			if last_use then 
				last_use = nil;
			
				return 
			end;
			
			if timer.Exists("ClockworkQuickUseTimer") then
				timer.Remove("ClockworkQuickUseTimer");
			end
			
			local trace = Clockwork.Client:GetEyeTraceNoCursor()

			if (IsValid(trace.Entity) and trace.HitPos:Distance(Clockwork.Client:GetShootPos()) <= 80) then
				Clockwork.EntityMenu = Clockwork.kernel:HandleEntityMenu(trace.Entity)

				if (IsValid(Clockwork.EntityMenu)) then
					Clockwork.EntityMenu:SetPos(
						(ScrW() / 2) - (Clockwork.EntityMenu:GetWide() / 2), (ScrH() / 2) - (Clockwork.EntityMenu:GetTall() / 2)
					)
				end
			end
		end
	end
end

function GM:PlayerButtonDown(player, button)
	if IsFirstTimePredicted() then
		if (!Clockwork.Client.nextBind or Clockwork.Client.nextBind < CurTime()) and hook.Run("BegottenPlayerCanUseBind", player, button) then
			for k, v in pairs(Clockwork.ConVars.Binds) do
				local value = v:GetInt();
				
				if value ~= 0 and value == button then
					local bindedConVar = Clockwork.setting.stored[v:GetName()].bindedConVar;
					
					if bindedConVar then
						player:ConCommand(bindedConVar);
					end
				end
			end
		end
	end
end

function GM:PreDrawHalos() end

function GM:PreDrawPlayerHands(ent, viewModel, player, weapon)
	if Clockwork.kernel:IsChoosingCharacter() then
		return true;
	end
end

--[[
	@codebase Client
	@details Called when the local player has been created.
--]]
function GM:LocalPlayerCreated()
	Clockwork.kernel:RegisterNetworkProxy(Clockwork.Client, "faceConcealed", function(entity, name, oldValue, newValue)
		if (oldValue != newValue) then
			Clockwork.inventory:Rebuild();
		end;
	end);

	timer.Simple(1, function()
		netstream.Start("LocalPlayerCreated", true)
	end)
end

--[[
	@codebase Client
	@details Called when the client initializes.
--]]
function GM:Initialize()
	--Clockwork.ConVars.TWELVEHOURCLOCK = Clockwork.kernel:CreateClientConVar("cwTwelveHourClock", 0, true, true)
	--Clockwork.ConVars.HEADBOBSCALE = Clockwork.kernel:CreateClientConVar("cwHeadbobScale", 1, true, true)
	--Clockwork.ConVars.SHOWAURA = Clockwork.kernel:CreateClientConVar("cwShowCW", 1, true, true)
	Clockwork.ConVars.SHOWLOG = Clockwork.kernel:CreateClientConVar("cwShowLog", 1, true, true)
	--Clockwork.ConVars.SHOWHINTS = Clockwork.kernel:CreateClientConVar("cwShowHints", 1, true, true)
	--Clockwork.ConVars.VIGNETTE = Clockwork.kernel:CreateClientConVar("cwShowVignette", 1, true, true)

	Clockwork.ConVars.ESPTIME = Clockwork.kernel:CreateClientConVar("cwESPTime", 1, true, true)
	Clockwork.ConVars.ADMINESP = Clockwork.kernel:CreateClientConVar("cwAdminESP", 0, true, true)
	Clockwork.ConVars.ITEMESP = Clockwork.kernel:CreateClientConVar("cwItemESP", 0, false, true)
	Clockwork.ConVars.PROPESP = Clockwork.kernel:CreateClientConVar("cwPropESP", 0, false, true)
	Clockwork.ConVars.SPAWNESP = Clockwork.kernel:CreateClientConVar("cwSpawnESP", 0, false, true)
	Clockwork.ConVars.SALEESP = Clockwork.kernel:CreateClientConVar("cwSaleESP", 0, false, true)
	Clockwork.ConVars.NPCESP = Clockwork.kernel:CreateClientConVar("cwNPCESP", 0, false, true)
	Clockwork.ConVars.PEEK_ESP = Clockwork.kernel:CreateClientConVar("cwESPPeek", 1, true, true)
	Clockwork.ConVars.PHYSDESCINSPECT = Clockwork.kernel:CreateClientConVar("cwPhysdescKey", 1, true, true);
	Clockwork.ConVars.Binds.PHYSDESCINSPECT = Clockwork.kernel:CreateClientConVar("cwPhysdescBind", KEY_X, true, true);
	Clockwork.ConVars.TOOLTIPFOLLOW = Clockwork.kernel:CreateClientConVar("cwTooltipFollow", 1, true, true)

	--Clockwork.ConVars.SHOWTIMESTAMPS = Clockwork.kernel:CreateClientConVar("cwShowTimeStamps", 0, true, true);
	--Clockwork.ConVars.MAXCHATLINES = Clockwork.kernel:CreateClientConVar("cwMaxChatLines", 10, true, true);
	--Clockwork.ConVars.SHOWOOC = Clockwork.kernel:CreateClientConVar("cwShowOOC", 1, true, true);
	--Clockwork.ConVars.SHOWIC = Clockwork.kernel:CreateClientConVar("cwShowIC", 1, true, true);
	Clockwork.ConVars.SHOWSERVER = Clockwork.kernel:CreateClientConVar("cwShowServer", 1, true, true);
	--Clockwork.ConVars.SHOWAURA = Clockwork.kernel:CreateClientConVar("cwShowClockwork", 1, true, true);

	if (file.Exists("cwavatars.txt", "DATA")) then
		Clockwork.AvatarsData = pon.decode(file.Read("cwavatars.txt", "DATA")) or {}
	else
		Clockwork.AvatarsData = {}
	end

	item.Initialize()
	
	--[[Clockwork.ConVars.DATETIME = Clockwork.kernel:CreateClientConVar("cwDateTime", 1, true, true)

	if (!Clockwork.option:GetKey("top_bars")) then
		Clockwork.ConVars.TOPBARS = Clockwork.kernel:CreateClientConVar("cwTopBars", 1, true, true)
	else
		Clockwork.setting:RemoveByConVar("cwTopBars")
	end]]--

	hook.Run("ClockworkInitialized")

	if (!Clockwork.chatBox.panel) then
		Clockwork.chatBox:CreateDermaAll();
	end;
end

--[[
	@codebase Client
	@details Called when Clockwork has initialized.
--]]
function GM:ClockworkInitialized()
	local logoFile = "clockwork/logo/002.png"

	--Clockwork.SpawnIconMaterial = Clockwork.kernel:GetMaterial("vgui/spawnmenu/hover")
	Clockwork.DefaultGradient = surface.GetTextureID("gui/gradient_down")
	Clockwork.GradientTexture = Clockwork.kernel:GetMaterial(Clockwork.option:GetKey("gradient")..".png")
	Clockwork.ClockworkSplash = Clockwork.kernel:GetMaterial(logoFile)
	Clockwork.FishEyeTexture = Clockwork.kernel:GetMaterial("models/props_c17/fisheyelens")
	Clockwork.GradientCenter = surface.GetTextureID("gui/center_gradient")
	Clockwork.GradientRight = surface.GetTextureID("gui/gradient")
	Clockwork.GradientUp = surface.GetTextureID("gui/gradient_up")
	Clockwork.ScreenBlur = Clockwork.kernel:GetMaterial("pp/blurscreen")
	Clockwork.SettingsDark = false
	Clockwork.Gradients = {
		[GRADIENT_CENTER] = Clockwork.GradientCenter,
		[GRADIENT_RIGHT] = Clockwork.GradientRight,
		[GRADIENT_DOWN] = Clockwork.DefaultGradient,
		[GRADIENT_UP] = Clockwork.GradientUp
	}

	Clockwork.setting:AddSettings()

	Clockwork.directory:AddCategory("Flags", "Character flags can be enabled to provide special effects.", true)
	Clockwork.directory:AddCategory("Commands", "Commands are used to execute specific actions.")
	Clockwork.directory:AddCategory("Factions", "Factions are an integral part of gameplay, your presence or absence in one will greatly affect your playstyle and experience.")
	Clockwork.directory:AddCategory("Items", "Items have a large variety of uses. Some items can be equipped, others used as tools or in crafting, or otherwise consumed to provide some benefit.")

	_G["ClockworkClientsideBooted"] = true
end

--[[
	@codebase Client
	@details Called when the tool menu needs to be populated.
--]]
function GM:PopulateToolMenu() end

--[[
	@codebase Client
	@details Called when a player's door access name is needed.
--]]
function GM:GetPlayerDoorAccessName(player, door, owner)
	return player:Name()
end

--[[
	@codebase Client
	@details Called when a player should show on the door access list.
--]]
function GM:PlayerShouldShowOnDoorAccessList(player, door, owner)
	return true
end

--[[
	@codebase Client
	@details Called when a player should show on the scoreboard.
--]]
function GM:PlayerShouldShowOnScoreboard(player)
	return true
end

--[[
	@codebase Client
	@details Called when the local player attempts to zoom.
--]]
function GM:PlayerCanZoom()
	return true
end

-- Called when the local player attempts to see a business item.
function GM:PlayerCanSeeBusinessItem(itemTable) return true end

function GM:PlayerCanSeeCommand(commandTable)
	if commandTable.faction then
		if istable(commandTable.faction) and !table.HasValue(commandTable.faction, Clockwork.Client:GetFaction()) then
			return false;
		elseif isstring(commandTable.faction) then
			if Clockwork.Client:GetFaction() ~= commandTable.faction then
				return false;
			end
		end
	end
	
	if commandTable.subfaction then
		if istable(commandTable.subfaction) and !table.HasValue(commandTable.subfaction, Clockwork.Client:GetSubfaction()) then
			return false;
		elseif isstring(commandTable.subfaction) then
			if Clockwork.Client:GetSubfaction() ~= commandTable.subfaction then
				return false;
			end
		end
	end
end

function GM:PlayerBindPress(player, bind, bPress)
	if (string.find(bind, "+reload")) then
		if (Clockwork.player:GetAction(Clockwork.Client) == "raise") then
			return true;
		end;
	end;
	
	if (string.find(bind, "toggle_zoom")) then
		return true
	elseif (string.find(bind, "+zoom")) then
		if (!hook.Run("PlayerCanZoom")) then
			return true
		end
	end

	if (!player:IsNoClipping() and !Clockwork.player:HasFlags(player, "B") and bind:find("+jump")) then
		if (player:GetNWInt("Stamina", 100) < 2) and !player:IsRagdolled() then
			return true
		end
	end

	if (string.find(bind, "+attack") or string.find(bind, "+attack2")) then
		if (Clockwork.storage:IsStorageOpen()) then
			return true
		end
		
		-- Handling this using SetNextPrimaryFire and SetNextSecondaryFire instead.
		--[[if (Clockwork.player:GetAction(Clockwork.Client) == "raise") then
			return true;
		end;]]--
	end

	local bindText = string.lower(bind)

	--[[if (config.GetVal("block_inv_binds")) then
		if (bindText:find(config.Get("command_prefix"):Get().."invaction") or bindText:find("cwcmd invaction")) then
			return true
		end
	end]]--

	if (config.GetVal("block_cash_binds")) then
		if (bindText:find("cash") or bindText:find("cwcmd cash") or
		bindText:find("tokens") or bindText:find("droptokens")) then
			return true
		end
	end

	if (config.GetVal("block_fallover_binds")) then
		if (bindText:find("fallover") or bindText:find("cwcmd fallover") or bindText:find("charfallover")) then
			return true
		end
	end

	local override = hook.Run("TopLevelPlayerBindPress", player, bind, bPress)

	if (!override) then
		-- Prevent weird stack overflow error.
		if (self.BaseClass.PlayerBindPress != self.PlayerBindPress) then
			return self.BaseClass.PlayerBindPress(self, player, bind, bPress, true)
		end
	end

	return override
end

function GM:TopLevelPlayerBindPress(player, bind, bPress)
	if (player:GetRagdollState() == RAGDOLL_FALLENOVER and string.find(bind, "+jump")) then
		if (Clockwork.player:GetAction(player) == "unragdoll") then
			Clockwork.kernel:RunCommand("CharCancelGetUp");
		else
			Clockwork.kernel:RunCommand("CharGetUp");
		end;
	end;
end;

-- Called when the local player attempts to see while unconscious.
function GM:PlayerCanSeeUnconscious()
	if Clockwork.player:IsNoClipping(Clockwork.Client) then
		return true;
	end;
	
	return false
end

-- Called when the local player's move data is created.
function GM:CreateMove(userCmd)
	local ragdollEyeAngles = Clockwork.kernel:GetRagdollEyeAngles()

	if (ragdollEyeAngles and IsValid(Clockwork.Client)) then
		local defaultSensitivity = 0.05
		local sensitivity = defaultSensitivity * (hook.Run("AdjustMouseSensitivity", defaultSensitivity) or defaultSensitivity)

		if (sensitivity <= 0) then
			sensitivity = defaultSensitivity
		end

		if (Clockwork.Client:IsRagdolled()) then
			ragdollEyeAngles.p = math.Clamp(ragdollEyeAngles.p + (userCmd:GetMouseY() * sensitivity), -48, 48)
			ragdollEyeAngles.y = math.Clamp(ragdollEyeAngles.y - (userCmd:GetMouseX() * sensitivity), -48, 48)
		else
			ragdollEyeAngles.p = math.Clamp(ragdollEyeAngles.p + (userCmd:GetMouseY() * sensitivity), -90, 90)
			ragdollEyeAngles.y = math.Clamp(ragdollEyeAngles.y - (userCmd:GetMouseX() * sensitivity), -90, 90)
		end
	end
end

local LAST_RAISED_TARGET = 0

local playerMeta = FindMetaTable("Player");

function playerMeta:CanSeeCalcView()
	return true;
end;

-- Called when the view should be calculated.
function GM:CalcView(player, origin, angles, fov)

end;

--[[
function GM:CalcView(player, origin, angles, fov)
	local frameTime = FrameTime();
	local curTime = CurTime();
	
	if (Clockwork.Client:IsRagdolled()) then
		local ragdollEntity = Clockwork.Client:GetRagdollEntity();
		local ragdollState = Clockwork.Client:GetRagdollState();
		
		if (self.BlackFadeIn == 255) then
			return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov};
		else
			local eyes = ragdollEntity:GetAttachment(ragdollEntity:LookupAttachment("eyes"));
			
			if (eyes) then
				local ragdollEyeAngles = eyes.Ang + Clockwork.kernel:GetRagdollEyeAngles();
				local physicsObject = ragdollEntity:GetPhysicsObject();
				
				if (IsValid(physicsObject)) then
					local velocity = physicsObject:GetVelocity().z;

					if (velocity <= -1000 and Clockwork.Client:GetMoveType() == MOVETYPE_WALK) then
						ragdollEyeAngles.p = ragdollEyeAngles.p + math.sin(UnPredictedCurTime()) * math.abs((velocity + 1000) - 16);
					end;
				end;

				return {origin = eyes.Pos, angles = ragdollEyeAngles, fov = fov};
			else
				return self.BaseClass:CalcView(player, origin, angles, fov);
			end;
		end;
	elseif (!Clockwork.Client:Alive()) then
		return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov};
	end;

	local view = {angles = angles, origin = origin, fov = fov};
		hook.Run("CalcViewAdjustTable", view);
	return view;
end;
--]]

-- Called when the view model view should be calculated.
function GM:CalcViewModelView(weapon, viewModel, oldEyePos, oldEyeAngles, eyePos, eyeAngles)
	if (IsValid(weapon)) then
		local bWeaponRaised = LocalPlayer():IsWeaponRaised(weapon);
		
		if (!LocalPlayer():HasInitialized() or !Clockwork.config:HasInitialized() or LocalPlayer():GetMoveType() == MOVETYPE_OBSERVER) then
			bWeaponRaised = nil;
		end;
		
		local targetValue = 100;
		
		if (bWeaponRaised) then
			targetValue = 0;
		end;
		
		local fraction = (Clockwork.Client.cwRaisedFraction or 100) / 100;
		local itemTable = Clockwork.item:GetByWeapon(weapon);
		local originMod = Vector(-3.0451, -1.6419, -0.5771);
		local anglesMod = Angle(-12.9015, -47.2118, 5.1173);
		
		if (itemTable and itemTable("loweredAngles")) then
			anglesMod = itemTable("loweredAngles");
		elseif (weapon.LoweredAngles) then
			anglesMod = weapon.LoweredAngles;
		end;
		
		if (itemTable and itemTable("loweredOrigin")) then
			originMod = itemTable("loweredOrigin");
		elseif (weapon.LoweredOrigin) then
			originMod = weapon.LoweredOrigin;
		end;
		
		anglesMod = Angle(0, 0, -25)
		
		local viewInfo = {
			origin = originMod,
			angles = anglesMod
		};
		
		eyeAngles:RotateAroundAxis(eyeAngles:Up(), viewInfo.angles.p * fraction);
		eyeAngles:RotateAroundAxis(eyeAngles:Forward(), viewInfo.angles.y * fraction);
		eyeAngles:RotateAroundAxis(eyeAngles:Right(), viewInfo.angles.r * fraction);
		oldEyePos = oldEyePos + ((eyeAngles:Forward() * viewInfo.origin.y) + (eyeAngles:Right() * viewInfo.origin.x) + (eyeAngles:Up() * viewInfo.origin.z)) * fraction;
		Clockwork.Client.cwRaisedFraction = Lerp(FrameTime() * 2, Clockwork.Client.cwRaisedFraction or 100, targetValue)
		
		if (weapon.CalcViewModelView) then
			local position, angles = weapon:CalcViewModelView(viewModel, oldEyePos, oldEyeAngles, eyePos, eyeAngles);
			oldEyePos = position or oldEyePos; eyeAngles = angles or eyeAngles;
		end;
		
		if (weapon.GetViewModelPosition) then
			local position, angles = weapon:GetViewModelPosition(eyePos, eyeAngles);
			oldEyePos = position or oldEyePos; eyeAngles = angles or eyeAngles;
		end;
		
		return oldEyePos, eyeAngles;
	end;
end;

-- Called when a weapon's lowered view info is needed.
function GM:GetWeaponLoweredViewInfo(itemTable, weapon, viewInfo) end

local blockedElements = {
	CHudSecondaryAmmo = true,
	CHudVoiceStatus = true,
	CHudSuitPower = true,
	CHudBattery = true,
	CHudHealth = true,
	CHudAmmo = true,
	CHudChat = true
}

-- Called when a HUD element should be drawn.
function GM:HUDShouldDraw(name)
	if (!IsValid(Clockwork.Client) or !Clockwork.Client:HasInitialized() or Clockwork.kernel:IsChoosingCharacter()) then
		if (name != "CHudGMod") then
			return false
		end
	elseif (name == "CHudCrosshair") then
		local wep = Clockwork.Client:GetActiveWeapon()
		
		if IsValid(wep) then
			local class = wep:GetClass();

			if (class:find("gmod_") or class == "weapon_physgun") then
				return true
			else
				return false
			end
		end
	elseif (blockedElements[name]) then
		return false
	end

	return self.BaseClass:HUDShouldDraw(name)
end

-- Called when the menu is opened.
function GM:MenuOpened()
	RunConsoleCommand("OpenMenu");
	for k, v in pairs(Clockwork.menu:GetItems()) do
		if (v.panel.OnMenuOpened) then
			v.panel:OnMenuOpened()
		end
	end
end

-- Called when the menu is closed.
function GM:MenuClosed()
	RunConsoleCommand("CloseMenu");
	for k, v in pairs(Clockwork.menu:GetItems()) do
		if (v.panel.OnMenuClosed) then
			v.panel:OnMenuClosed()
		end
	end

	Clockwork.kernel:ClearToolTipPanels()
	Clockwork.kernel:RemoveActiveToolTip()
	Clockwork.kernel:CloseActiveDermaMenus()
end

-- Called when the character screen's faction characters should be sorted.
function GM:CharacterScreenSortFactionCharacters(faction, a, b)
	return a.name < b.name
end

-- Called when the scoreboard's class players should be sorted.
function GM:ScoreboardSortClassPlayers(class, a, b)
	local recogniseA = Clockwork.player:DoesRecognise(a)
	local recogniseB = Clockwork.player:DoesRecognise(b)

	if (recogniseA and recogniseB) then
		return a:Team() < b:Team()
	elseif (recogniseA) then
		return true
	else
		return false
	end
end

-- Called when the scoreboard's player info should be adjusted.
function GM:ScoreboardAdjustPlayerInfo(info) end

-- Called when the menu's items should be adjusted.
function GM:MenuItemsAdd(menuItems)
	--local attributesName = Clockwork.option:GetKey("name_attributes")
	local systemName = Clockwork.option:GetKey("name_system")
	local settingsName = Clockwork.option:GetKey("name_settings")
	local scoreboardName = Clockwork.option:GetKey("name_scoreboard")
	local directoryName = Clockwork.option:GetKey("name_directory")
	--local inventoryName = Clockwork.option:GetKey("name_inventory")

	menuItems:Add("Inventory", "cwInventory", "Manage your inventory.")
	menuItems:Add("Settings", "cwSettings", "Configure the way CW works for you.")
	menuItems:Add("System", "cwSystem", "Customize server settings.")
	menuItems:Add("Scoreboard", "cwScoreboard", "See who's playing on the server.")
	menuItems:Add(directoryName, "cwDirectory", Clockwork.option:GetKey("description_directory"))
	--menuItems:Add("Crafting", "DPanel", "Craft.", nil, nil)
	--menuItems:Add("Rituals", "DPanel", "Do some twisted shit.", nil, nil)
	--menuItems:Add("Attributes", "cwAttributes", "See your progress on skills.", nil, nil)
end

-- Called when the menu's items should be destroyed.
function GM:MenuItemsDestroy(menuItems) end

function GM:HalfSecond()
	--[[local realCurTime = CurTime()
	local curTime = UnPredictedCurTime()

	if (!Clockwork.NextHandleAttributeBoosts or realCurTime >= Clockwork.NextHandleAttributeBoosts) then
		Clockwork.NextHandleAttributeBoosts = realCurTime + 3

		for k, v in pairs(Clockwork.attributes.boosts) do
			for k2, v2 in pairs(v) do
				if (v2.duration and v2.endTime) then
					if (realCurTime > v2.endTime) then
						Clockwork.attributes.boosts[k][k2] = nil
					else
						local timeLeft = v2.endTime - realCurTime

						if (timeLeft >= 0) then
							if (v2.default < 0) then
								v2.amount = math.min((v2.default / v2.duration) * timeLeft, 0)
							else
								v2.amount = math.max((v2.default / v2.duration) * timeLeft, 0)
							end
						end
					end
				end
			end
		end
	end]]--
end

-- Called each tick.
function GM:Tick()
	local curTime = CurTime();
	local font = Clockwork.option:GetFont("player_info_text")

	if (Clockwork.character:IsPanelPolling()) then
		local panel = Clockwork.character:GetPanel()

		if (!panel and hook.Run("ShouldCharacterMenuBeCreated")) then
			Clockwork.character:SetPanelPolling(false)
			Clockwork.character.isOpen = true
			Clockwork.character.panel = vgui.Create("cwCharacterMenu")
			Clockwork.character.panel:MakePopup()
			Clockwork.character.panel:ReturnToMainMenu()

			hook.Run("PlayerCharacterScreenCreated", Clockwork.character.panel)
		end
	end

	if (IsValid(Clockwork.Client) and !Clockwork.kernel:IsChoosingCharacter()) then
		Clockwork.bars.stored = {}
		--Clockwork.PlayerInfoText.text = {}
		--Clockwork.PlayerInfoText.width = ScrW() * 0.15
		--Clockwork.PlayerInfoText.subText = {}

		Clockwork.kernel:DrawHealthBar()
		--Clockwork.kernel:DrawArmorBar()

		hook.Run("GetBars", Clockwork.bars)
		hook.Run("DestroyBars", Clockwork.bars)
		--hook.Run("GetPlayerInfoText", Clockwork.PlayerInfoText)
		--hook.Run("DestroyPlayerInfoText", Clockwork.PlayerInfoText)

		table.sort(Clockwork.bars.stored, function(a, b)
			if (a.text == "" and b.text == "") then
				return a.priority > b.priority
			elseif (a.text == "") then
				return true
			else
				return a.priority > b.priority
			end
		end)

		--[[table.sort(Clockwork.PlayerInfoText.subText, function(a, b)
			return a.priority > b.priority
		end)

		for k, v in pairs(Clockwork.PlayerInfoText.text) do
			Clockwork.PlayerInfoText.width = Clockwork.kernel:AdjustMaximumWidth(font, v.text, Clockwork.PlayerInfoText.width)
		end

		for k, v in pairs(Clockwork.PlayerInfoText.subText) do
			Clockwork.PlayerInfoText.width = Clockwork.kernel:AdjustMaximumWidth(font, v.text, Clockwork.PlayerInfoText.width)
		end

		Clockwork.PlayerInfoText.width = Clockwork.PlayerInfoText.width + 16]]--

		--if (config.Get("fade_dead_npcs"):Get()) then
			if !Clockwork.Client.nextRagdollDecayCheck or Clockwork.Client.nextRagdollDecayCheck < curTime then
				Clockwork.Client.nextRagdollDecayCheck = curTime + 15;
				
				for k, v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
					if (!Clockwork.entity:IsDecaying(v)) then
						Clockwork.entity:Decay(v, 300)
					end
				end
			end
		--end

		local playedHeartbeatSound = false

		if (Clockwork.Client:Alive() and config.Get("enable_heartbeat"):Get()) then
			local maxHealth = Clockwork.Client:GetMaxHealth()
			local health = Clockwork.Client:Health()

			if (health <= (maxHealth * 0.4)) then
				if (!Clockwork.HeartbeatSound) then
					Clockwork.HeartbeatSound = CreateSound(Clockwork.Client, "player/heartbeat1.wav")
				end

				if (!Clockwork.NextHeartbeat or curTime >= Clockwork.NextHeartbeat) then
					Clockwork.NextHeartbeat = curTime + (0.75 + ((1.25 / maxHealth) * health))
					Clockwork.HeartbeatSound:PlayEx(0.75 - ((0.7 / maxHealth) * health), 100)
				end

				playedHeartbeatSound = true
			end
		end

		if (!playedHeartbeatSound and Clockwork.HeartbeatSound) then
			Clockwork.HeartbeatSound:Stop()
		end
	end

	local worldEntity = game.GetWorld()

	for k, v in pairs(Clockwork.NetworkProxies) do
		if (IsValid(k) or k == worldEntity) then
			for k2, v2 in pairs(v) do
				local value = nil

				if (k == worldEntity) then
					value = netvars.GetNetVar(k2)
				else
					value = k:GetNetVar(k2)
				end

				if (value != v2.oldValue) then
					v2.Callback(k, k2, v2.oldValue, value)
					v2.oldValue = value
				end
			end
		else
			Clockwork.NetworkProxies[k] = nil
		end
	end
end

function GM:InitPostEntity()
	Clockwork.Client = LocalPlayer()

	if (IsValid(Clockwork.Client)) then
		hook.Run("LocalPlayerCreated")
	end

	for _, v in _player.Iterator() do
		hook.Run("PlayerModelChanged", v, v:GetModel())
	end

	hook.Run("ClockworkInitPostEntity")
end

function GM:PlayerCharacterInitialized(data)
	local armor = math.Clamp(Clockwork.Client:Armor(), 0, Clockwork.Client:GetMaxArmor());
	local health = math.Clamp(Clockwork.Client:Health(), 0, Clockwork.Client:GetMaxHealth());
	
	Clockwork.kernel.armor = armor;
	Clockwork.kernel.health = health;
end

-- Called each frame.
function GM:Think()
	Clockwork.kernel:CalculateHints()

	if (Clockwork.kernel:IsCharacterScreenOpen()) then
		local panel = Clockwork.character:GetPanel()

		if (panel) then
			panel:SetVisible(hook.Run("GetPlayerCharacterScreenVisible", panel))

			if (panel:IsVisible()) then
				Clockwork.HasCharacterMenuBeenVisible = true
			end
		end
	end
end

-- Called when a player's move data is set up.
function GM:SetupMove(player, moveData)
	local plyTab = player:GetTable();

	if player:IsRunning() and !plyTab.accelerationFinished then
		local curTime = CurTime();
		local run_speed = player:GetRunSpeed()
		local walk_speed = player:GetWalkSpeed();
		local final_speed = run_speed;
		
		if !plyTab.startAcceleration then
			plyTab.startAcceleration = curTime;
		end
		
		final_speed = Lerp(curTime - plyTab.startAcceleration, walk_speed, run_speed);
		
		moveData:SetMaxClientSpeed(final_speed);
		
		if run_speed <= final_speed then
			plyTab.accelerationFinished = true;
			plyTab.startAcceleration = nil;
		end
		
		plyTab.decelerationFinished = false;
		plyTab.startDeceleration = nil;
	elseif !player:IsRunning() then
		if plyTab.decelerationFinished == false then
			local curTime = CurTime();
			local run_speed = player:GetRunSpeed()
			local walk_speed = player:GetWalkSpeed();
			local final_speed = walk_speed;
			
			if !plyTab.startDeceleration then
				plyTab.startDeceleration = curTime;
			end
			
			final_speed = Lerp(curTime - plyTab.startDeceleration, run_speed, walk_speed);
			
			moveData:SetMaxClientSpeed(final_speed);
			
			if run_speed >= final_speed then
				plyTab.decelerationFinished = true;
				plyTab.startDeceleration = nil;
			end
			
			plyTab.accelerationFinished = false;
			plyTab.startAcceleration = nil;
		else
			moveData:SetMaxClientSpeed(player:GetWalkSpeed());
		end
	end
end

local SCREEN_DAMAGE_OVERLAY = Clockwork.kernel:GetMaterial("clockwork/screendamage.png")
local VIGNETTE_OVERLAY = Clockwork.kernel:GetMaterial("begotten/vignette.png")

local vignetteExists = _file.Exists("materials/begotten/vignette.png", "GAME");
local damageScreenExists = _file.Exists("materials/clockwork/screendamage.png", "GAME");

-- Called when the local player's screen damage should be drawn.
function GM:DrawPlayerScreenDamage(damageFraction)
	if (damageScreenExists != true) then
		return false;
	end;
	
	--if GetConVar("devnewbars"):GetFloat() == 0 then return end
	
	surface.SetDrawColor(255, 255, 255, math.Clamp(255 * damageFraction, 0, 150))
	surface.SetMaterial(SCREEN_DAMAGE_OVERLAY)
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

--[[
	Called when the entity outlines should be added.
	The "outlines" parameter is a reference to Clockwork.outline.
--]]
function GM:AddEntityOutlines(outlines) end

-- Called when the local player's vignette should be drawn.
function GM:DrawPlayerVignette()

end

-- Called when the foreground HUD should be painted.
function GM:HUDPaintForeground()
	local backgroundColor = Clockwork.option:GetColor("background")
	local colorWhite = Clockwork.option:GetColor("white")
	local info = hook.Run("GetProgressBarInfo")
	local scrW, scrH = ScrW(), ScrH()
	local curTime = CurTime()

	if (LocalPlayer().ErrorBoxTime and LocalPlayer().ErrorBoxTime > (curTime)) then
		draw.RoundedBox(2, scrW - 300, 8, 292, 24, Color(math.Clamp(255 * (math.sin(curTime)), 150, 255), 90, 90))
		draw.SimpleText("Something is creating hook errors!", Clockwork.fonts:GetSize(Clockwork.option:GetFont("menu_text_small"), 18), scrW - 292, 10, Color(255, 255, 255))
	end

	if (info) then
		local scrW = ScrW();
		local scrH = ScrH();
		local width = (scrW / 2) - 64;
		local height = 16;
		local x, y = Clockwork.kernel:GetScreenCenter();
		x = x - (scrW / 4);
		y = scrH - (scrH * 0.15);
		
		Clockwork.kernel:DrawBar(x, y, width, height, Color(102, 0, 0, 200), info.text or "Progress Bar", info.percentage or 100, 100, info.flash);
	end;

	if (Clockwork.player:IsAdmin(Clockwork.Client)) then
		if (hook.Run("PlayerCanSeeAdminESP") or input.IsKeyDown(KEY_C) and Clockwork.ConVars.PEEK_ESP:GetInt() == 1) then
			Clockwork.kernel:DrawAdminESP()
		end
	end

	local screenTextInfo;

	if hook.Run("CanGetScreenTextInfo") ~= false then
		screenTextInfo = hook.Run("GetScreenTextInfo");
	end
	
	if (screenTextInfo) then
		local alpha = screenTextInfo.alpha or 255;
		local y = (scrH / 2) - 128;
		local x = scrW / 2;
		
		if (screenTextInfo.x) then
			x = screenTextInfo.x;
		end;
		
		if (screenTextInfo.y) then
			y = screenTextInfo.y;
		end;
		
		if (screenTextInfo.title) then
			Clockwork.kernel:OverrideMainFont(Clockwork.option:GetFont("menu_text_small"));
				y = Clockwork.kernel:DrawInfo(screenTextInfo.title, x, y, colorWhite, alpha);
			Clockwork.kernel:OverrideMainFont(false);
		end;
		
		if (screenTextInfo.text) then
			Clockwork.kernel:OverrideMainFont(Clockwork.option:GetFont("menu_text_tiny"));
				y = Clockwork.kernel:DrawInfo(screenTextInfo.text, x, y, colorWhite, alpha);
			Clockwork.kernel:OverrideMainFont(false);
		end;
	end;

	Clockwork.kernel:DrawDateTime();
	if (hook.Run("CanPaintChatbox")) then
		Clockwork.chatBox:Paint();
	end;
end

function GM:CanPaintChatbox()
	return true;
end;

-- Called when an item's network data has been updated.
function GM:ItemNetworkDataUpdated(itemTable, newData)
	if (itemTable.OnNetworkDataUpdated) then
		itemTable:OnNetworkDataUpdated(newData)
	end
end

local function TooltipRecurse(panel, panelToFind)
	local children = panel:GetChildren();
	
	if !children or table.IsEmpty(children) then return end;

	for k, v in pairs(children) do
		if v == panelToFind then return v end;
	
		return TooltipRecurse(v);
	end
end

local function IsChildOfTooltipRecurse(panel)
	local parent = panel:GetParent();
	
	if !parent then return end;
	
	if parent.isTooltip then return parent end;
	
	return IsChildOfTooltipRecurse(parent);
end

-- Called after the VGUI has been rendered.
function GM:PostRenderVGUI()
	local cinematic = Clockwork.Cinematics[1];
	local curTime = CurTime();

	if (cinematic) then
		Clockwork.kernel:DrawCinematic(cinematic, curTime)
	end
	
	local hoveredPanel = vgui.GetHoveredPanel();
	
	if !IsValid(hoveredPanel) then return end;
	
	-- A lot of this is probably unoptimized but whatever.
	if (!hoveredPanel.DermaToolTip and !hoveredPanel.isTooltip) then
		if !table.IsEmpty(Clockwork.ActiveDermaToolTips) then
			local panelToCheck = hoveredPanel;
			local tooltipFound = false;
			
			while !tooltipFound do
				if panelToCheck.isTooltip then
					tooltipFound = true;
					
					break;
				end
				
				panelToCheck = panelToCheck.parent or panelToCheck:GetParent();
				
				if !panelToCheck then
					break;
				end
			end
		
			if !tooltipFound then
				Clockwork.kernel:ClearToolTipPanels();
				
				return;
			end
			
			if !Clockwork.ActiveDermaToolTips[#Clockwork.ActiveDermaToolTips].frozen then
				Clockwork.kernel:ClearToolTipPanel(Clockwork.ActiveDermaToolTips[#Clockwork.ActiveDermaToolTips]);
			end
		end
	end;
	
	if #Clockwork.ActiveDermaToolTips > 1 and !hoveredPanel.DermaToolTip then
		for i, v in ipairs(Clockwork.ActiveDermaToolTips) do
			if i < #Clockwork.ActiveDermaToolTips then
				if IsChildOfTooltipRecurse(hoveredPanel) == v then
					Clockwork.kernel:ClearToolTipPanel(Clockwork.ActiveDermaToolTips[i + 1]);
					
					break;
				end
			end
		end
	end

	if (Clockwork.kernel.TooltipCooldown and Clockwork.kernel.TooltipCooldown > curTime) then
		return;
	end;

	if hoveredPanel.GetMarkupToolTip and !hoveredPanel.DermaToolTip then
		if (!hoveredPanel.preDelay) then
			hoveredPanel.preDelay = curTime + 0.5;
		elseif (hoveredPanel.preDelay < curTime) then
			hoveredPanel.preDelay = curTime + 0.5;
			hoveredPanel.DermaToolTip = Clockwork.kernel:SetupDermaToolTip(hoveredPanel);
			
			if #Clockwork.ActiveDermaToolTips > 1 then
				for i = 1, #Clockwork.ActiveDermaToolTips do
					local tooltip = Clockwork.ActiveDermaToolTips[#Clockwork.ActiveDermaToolTips - (i - 1)];
					
					if IsValid(tooltip) then
						if !TooltipRecurse(tooltip, hoveredPanel.DermaToolTip) then
							Clockwork.kernel:ClearToolTipPanel(tooltip);
							
							break;
						end
					end
				end
			end
			
			table.insert(Clockwork.ActiveDermaToolTips, hoveredPanel.DermaToolTip);
		end;
	end;
end

-- A function to clear a specific derma tooltip and its nested children.
function Clockwork.kernel:ClearToolTipPanel(panel)
	Clockwork.kernel.TooltipCooldown = CurTime() + 0.5;
	
	local found = false;
	
	for i, v in ipairs(Clockwork.ActiveDermaToolTips) do
		if v == panel then
			local parent = panel.parent;

			if IsValid(parent) and parent.DermaToolTip then
				parent.DermaToolTip = nil;
			end
			
			panel:Remove();
			
			if !found then
				found = i;
			end
			
			break;
		end
	end
	
	if found then
		for i = found, #Clockwork.ActiveDermaToolTips do
			Clockwork.ActiveDermaToolTips[i] = nil;
		end
	end
end;

-- A function to clear all active derma tooltips.
function Clockwork.kernel:ClearToolTipPanels()
	Clockwork.kernel.TooltipCooldown = CurTime() + 0.5;

	for i, panel in ipairs(Clockwork.ActiveDermaToolTips) do
		if IsValid(panel) then
			local parent = panel.parent;

			if IsValid(parent) and parent.DermaToolTip then
				parent.DermaToolTip = nil;
			end

			panel:Remove();
		end;
	end
	
	Clockwork.ActiveDermaToolTips = {};
end;

-- A function to get a text's width.
function GetFontWidth(font, text)
	if (!font or !text) then
		return;
	end;
	
	surface.SetFont(tostring(font));
		local textWidth, textHeight = surface.GetTextSize(tostring(text));
	return textWidth;
end;

-- A function to get a text's height.
function GetFontHeight(font, text)
	if (!font or !text) then
		return;
	end;
	
	surface.SetFont(tostring(font));
		local textWidth, textHeight = surface.GetTextSize(tostring(text));
	return textHeight;
end;

if (Clockwork.kernel.toolTips) then
	for k, v in pairs (Clockwork.kernel.toolTips) do
		if (IsValid(Clockwork.kernel.toolTips[k])) then
			Clockwork.kernel.toolTips[k]:Remove();
			Clockwork.kernel.toolTips[k] = nil;
		end;
	end;
end;

-- A function to set up a tool tip.
function Clockwork.kernel:SetupDermaToolTip(parent)
	if (!self.toolTips) then
		self.toolTips = {};
	end;
	
	if (IsValid(Clockwork.kernel.ActiveItemMenu)) then
		return;
	end;

	local toolTipThinkCallback = parent.ToolTipThinkCallback;
	local toolTipCallback = parent.ToolTipCallback;
	local titleColor = Color(255, 255, 255);
	local scrW, scrH = ScrW(), ScrH();
	
	local frame = vgui.Create("DFrame");
	frame:ShowCloseButton(false);
	frame:SetSize(scrW * 0.18, 500);
	frame:SetTitle("");
	frame:MakePopup();
	frame:SetDrawOnTop(true);
	frame.parent = parent;
	frame.openable = parent.openable or false;
	frame.isTooltip = true;

	parent.tooltip = frame;
	
	self.toolTips[#self.toolTips + 1] = frame;
	
	if (parent.ToolTipTitle) then
		frame:SetTitle(tostring(parent.ToolTipTitle));
	end;
	
	-- A function to fade out the tool tip.
	function frame:FadeOut()
		self.fadingOut = true; self.fadingIn = false;
	end;
	
	-- A function to fade out the tool tip.
	function frame:FadeIn()
		self.fadingOut = false; self.fadingIn = true;
	end;
	
	-- A function to get the tool tip's title color.
	function frame:GetTitleColor()
		return;
	end;
	
	-- A function to close the tooltip.
	function frame:CloseTooltip()
		if (self.parent.ToolTipTitle == "") then
			self.parent.ToolTipTitle = nil;
		end;
		
		self:Close();
		self:Remove();
		Clockwork.kernel:ClearToolTipPanel(parent);
	end;
	
	function frame:Open()
		if (self.openable and !self.open) then
			self:CreateCloseButton();
			self:SetDraggable(true);
			self.open = true;
			self.parent.ToolTipTitle = ""

			if (IsValid(self.closebutton)) then
				local x, y = self.closebutton:GetPos();
				local smallLabel = vgui.Create("DLabel", self)
				smallLabel:SetText("[Opened]")
				smallLabel:SetFont("Default");
				smallLabel:SetTextColor(Color(220, 220, 220));
				smallLabel:SetPos(x - (GetFontWidth("Default", "[Opened]") + 4), (GetFontHeight("Default", "[Opened]") / 2));
				smallLabel:SizeToContents()
			end;
			
			if (self.parent.openCallback) then
				self.parent:openCallback(self);
			end;
		end;
	end;
	
	function frame:CreateCloseButton()
		local closebutton = vgui.Create("DButton", self)
		closebutton:SetText("X");
		closebutton:SetPos(self:GetWide() - 20, 4)
		closebutton:SetSize(16, 16);
		
		function closebutton.DoClick()
			self:CloseTooltip()
		end;
		self.closebutton = closebutton;
	end;
	
	-- Called when the frame is painted.
	function frame:Paint(width, height)
		derma.SkinHook("Paint", "Frame", self, width, height);

		return true;
	end;
	
	function frame:PaintOver(width, height)
		local curTime = CurTime();
		
		draw.NoTexture() -- Otherwise we draw a transparent circle.
		
		local x = width - 21;
		local y = 21;
		
		if self:GetTitle() and self:GetTitle() ~= "" then
			x = width - 12;
			y = 12;
		end
		
		if !self.frozen then
			if !self.frozenTime then
				self.frozenTime = curTime + 3;
			end
			
			local timeLeft = (self.frozenTime - curTime) / 3;

			surface.SetDrawColor(10, 10, 10);
			surface.DrawPartialOutlinedCircle(math.min((1 - timeLeft) * 100, 100), x, y, 11, 7);
			surface.SetDrawColor(150, 20, 20);
			surface.DrawPartialOutlinedCircle(math.min((1 - timeLeft) * 100, 100), x, y, 10, 4);
			
			--surface.SetDrawColor(20, 20, 20, 150);
			--surface.DrawOutlinedRect(0, 0, width, height, 4);

			if timeLeft <= 0 then
				self.frozen = true;
			end
		else
			if !self.circleAlpha then
				self.circleAlpha = 255;
			end
			
			self.circleAlpha = math.max(0, self.circleAlpha - (FrameTime() * 666));
			
			surface.SetDrawColor(10, 10, 10, self.circleAlpha);
			surface.DrawOutlinedCircle(x, y, 11, 7);
			surface.SetDrawColor(150, 20, 20, self.circleAlpha);
			surface.DrawOutlinedCircle(x, y, 10, 4);
		end
	end
	
	-- Called every frame while the panel is active.
	function frame:Think()
		local activeToolTips = Clockwork.kernel:GetActiveDermaToolTips();
		local parent = self.parent;
		
		if !IsValid(parent) or (parent.isTooltip and !table.HasValue(activeToolTips, parent)) then
			Clockwork.kernel:ClearToolTipPanel(parent);
			return;
		end;
		
		local titleColor = self:GetTitleColor() or titleColor;
		local frameTime = FrameTime();
		local curTime = CurTime();
		local interval = 796;
		local maxAlpha = 240;
		
		if (IsValid(self.lblTitle)) then
			self.lblTitle:SetTextColor(titleColor);
		end;
		
		if (!self.alpha) then
			self.setAlphaTime = (curTime + 0.15) + (frameTime * 8);
			self.alpha = 0;
			self:FadeIn();
		elseif (self.fadingOut and self.alpha <= 0) then
			self:CloseTooltip();
		end;

		if (self.fadingIn and self.alpha != maxAlpha and self.setAlphaTime < curTime) then
			self.alpha = math.Approach(self.alpha, maxAlpha, frameTime * interval)
		elseif (self.fadingOut and self.alpha != 0 and self.setAlphaTime < curTime) then
			self.alpha = math.Approach(self.alpha, 0, frameTime * interval)
		end;

		self:SetAlpha(self.alpha);
		
		local width, height = self:GetWide(), self:GetTall();
		local x, y;
		
		if Clockwork.ConVars.TOOLTIPFOLLOW:GetInt() == 1 then
			if self.frozen then
				x, y = self:GetPos();
			else
				x, y = gui.MouseX() + 8, gui.MouseY() + 8;
			end
		else
			x, y = parent:LocalToScreen(0, 0);
			x = x + parent:GetWide();
		end

		if (y + height > scrH) then
			y = math.Clamp(y - ((y + height) - scrH), 16, scrH) - 16;
		end;
		
		if (x + width > scrW) then
			x = math.Clamp(x - ((x + width) - scrW), 16, scrW) - 16;
		end;
		
		if (!self.open) then
			self:SetPos(x, y);
		end;
		
		local offset = 4;
		
		if (parent.ToolTipTitle) then
			offset = 27;
		end;
		
		self:SetSize(self:GetWide(), self.panelList.pnlCanvas:GetTall() + offset)
		
		if (toolTipThinkCallback) then
			toolTipThinkCallback(self);
		end;
	end;
	
	local frameWidth, frameHeight = frame:GetWide(), frame:GetTall();
	
	if (!IsValid(frame.panelList)) then
		frame.panelList = vgui.Create("DPanelList", frame);
		frame.panelList:SetSize(frameWidth - 8, (frameHeight - 28) + 1)
		frame.panelList:SetPadding(4);
		frame.panelList:SetSpacing(4);
		frame.panelList.m_bBackground = false;
		
		-- Called every frame while the panel is active.
		function frame.panelList:Think()
			local y = 4;
			
			if (parent.ToolTipTitle) then
				y = 23;
			end;

			self:SetPos(4, y)
			self:SetTall(self.pnlCanvas:GetTall());
		end;
		
		-- Called when the panel is painted.
		function frame.panelList:Paint(width, height)
			draw.RoundedBox(0, 0, 0, width, height, Color(20, 20, 20, 200))
		end;
	end;

	-- A function to add text to the panel list.
	function frame:AddText(text, color, font, multiplier, PaintCallback)
		local font = Clockwork.fonts:GetMultiplied(font, multiplier or 1) or Clockwork.fonts:GetMultiplied("cwTooltip", multiplier or 1);
		local color = color or Color(255, 255, 255)

		if (text and color) then
			local label = vgui.Create("DLabel", self);
				label:SetText(text);
				label:SetFont(font);
				label:SetTextColor(color);
				label:SetWrap(true);
				label:SetAutoStretchVertical(true);
				label:SizeToContents();
				
				if (PaintCallback) then
					label.Paint = PaintCallback;
				end;
			self.panelList:AddItem(label);
		end;
	end;
	
	-- A function to add a blank panel.
	function frame:AddBlankSpace(height, color, material, width, cornerSize, parent)
		local container;
		
		if (!parent) then
			local containerPanel = vgui.Create("DPanelList", self)
			containerPanel:SetPadding(2);
			containerPanel:SetSpacing(2);
			containerPanel:EnableHorizontal(true);
			containerPanel.m_bBackground = false;
			containerPanel:SetTall(height + 4)
			
			function containerPanel:Paint(width, height)
				return;
			end;
			
			container = containerPanel;
		end;

		local panel = vgui.Create("Panel", self);
		panel:SetSize(frameWidth, height)
		panel.color = color;
		panel.cornerSize = cornerSize or 0;
		
		if (material) then
			if (isstring(material)) then
				panel.material = Material(material);
			else
				panel.material = material;
			end;
		end;
		
		if (width) then
			panel:SetWide(width);
		end;
		
		-- Called when the panel is painted.
		function panel:Paint(width, height)
			if (self.material) then
				surface.SetDrawColor(Color(255, 255, 255));
				surface.SetMaterial(self.material);
				surface.DrawTexturedRect(0, 0, width, height);
			elseif (self.color) then
				draw.RoundedBox(self.cornerSize, 0, 0, width, height, self.color);
			end;
		end;
		
		if (container) then
			container:AddItem(panel);
				self.panelList:AddItem(container);
			return panel, container;
		else
			parent:AddItem(panel);
		end;
		
		return panel;
	end;
	
	-- A function to add a blank panel.
	function frame:AddSpacer(height, color, material, width, cornerSize, parent)
		return self:AddBlankSpace(height, color, material, width, cornerSize, parent)
	end;

	-- A function to add a model panel.
	function frame:AddModelPanel(model, width)
		if (!width) then
			width = frameWidth;
		end;
	
		local container = vgui.Create("DPanelList", self);
		container:SetSize(width, width)
		container:SetPadding(4);
		container:SetSpacing(4);
		container:EnableHorizontal(true);
		
		-- Called when the panel is painted.
		function container:Paint(width, height)
			Clockwork.kernel:DrawWithTexture("begotten/ui/generic_scratch.png", 1, 0, 0, width, height, Color(0, 0, 0, 255));
		end;

		local modelPanel = vgui.Create("DModelPanel", self);
		modelPanel:SetModel(model);
		modelPanel:SetPos(0, 0);
		modelPanel:SetSize(width, width);

		local entity = modelPanel:GetEntity();
		local position = entity:GetPos();
		local spawnIconPosition = PositionSpawnIcon(entity, position, true);

		if (spawnIconPosition) then
			modelPanel:SetCamPos(spawnIconPosition.origin + Vector(0, 0, 0));
			modelPanel:SetFOV(spawnIconPosition.fov);
			modelPanel:SetLookAng(spawnIconPosition.angles);
		end;
		
		modelPanel:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255));
		modelPanel:SetDirectionalLight(BOX_BACK, Color(51, 51, 51));
		modelPanel:SetDirectionalLight(BOX_RIGHT, Color(51, 51, 51));
		modelPanel:SetDirectionalLight(BOX_LEFT, Color(51, 51, 51));
		modelPanel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255));
		modelPanel:SetDirectionalLight(BOX_BOTTOM, Color(25, 25, 25));
		modelPanel:SetAmbientLight(Color(76, 76, 76));
		
		-- Called every frame while the panel is valid.
		function modelPanel.Think(panel)
			if (self.setAlphaTime and self.setAlphaTime < CurTime()) then
				if (!panel.alpha) then
					panel.alpha = 0;
				elseif (panel.alpha != 255) then
					panel.alpha = math.Approach(panel.alpha, 255, FrameTime() * 1024)
				end;

				panel:SetAlpha(panel.alpha);
			else
				panel:SetAlpha(0);
			end;
		end;

		container:AddItem(modelPanel);
			self.panelList:AddItem(container);
		return modelPanel, container;
	end;

	-- A function to add an infobox.
	function frame:AddInfoBox(infoTable, paintCallback, parent)
		local infoBox = vgui.Create("DPanelList", self);
		infoBox:SetWide(frameWidth)
		infoBox:SetTall(128)
		infoBox:SetPadding(4);
		infoBox:SetSpacing(4);

		function infoBox:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height);
			else
				Clockwork.kernel:DrawWithTexture("begotten/ui/generic_dirty.png", 0, 0, 0, width, height, Color(40, 40, 40, 175));
			end;
			
			self:SetTall(self.pnlCanvas:GetTall());
		end;

		for k, v in ipairs (infoTable) do
			local color = Color(255, 255, 255);
			local font = "DermaDefault";
		
			if (istable(v)) then
				if (v.color) then
					color = v.color;
				end;
				
				if (v.font) then
					font = v.font;
				end;
			end;
			
			local text = v.text;
			
			if (v.indent) then
				if (isstring(v.indent)) then
					text = v.indent.." "..text;
				else
					text = "- "..text;
				end;
			end;

			local label = vgui.Create("DLabel", self);
				label:SetText(v.text)
				label:SetTextColor(color);
				label:SetFont(font);
				label:SizeToContents();
				label:SetWrap(true);
				label:SetAutoStretchVertical(true)
			infoBox:AddItem(label)
		end;
		
		if (!parent) then
			parent = self.panelList
		end;	
		
		self.panelList:AddItem(infoBox);
	end;
	
	-- A function to add a bar with multiple stages.
	function frame:AddBar(height, barTable, title, titleColor, toolTip, bHalf)
		local height = math.max(height, 12);
		local oX, oY = 4, 0;
		local yOffset = 4;
		local newWidth = frameWidth;
		
		if bHalf then
			if !self.barList then
				self.barList = vgui.Create("DPanelList", self);
				self.barList:SetWide(frameWidth);
				self.barList:SetSpacing(4);
				self.barList:EnableHorizontal(true);
				self.barList:SetAutoSize(true);
				self.barList.m_bBackground = false;
				
				self.panelList:AddItem(self.barList);
			end
		
			newWidth = (frameWidth / 2) - 10;
		end

		if (title) then
			height = height + 18;
			oY = 18;
			yOffset = 22;
		end;
		
		local barBox = vgui.Create("DPanelList", self);
		barBox:SetWide(newWidth);
		barBox:SetPadding(0);
		barBox:SetSpacing(0);

		-- Called when the panel is painted.
		function barBox:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height);
			else
				--Clockwork.kernel:DrawWithTexture("begotten/ui/collapsible3-full.png", 0, 0, 0, width, height, Color(0, 0, 0, 255));
			end;

			self:SetTall(self.pnlCanvas:GetTall());
		end;
		
		local barBackground = vgui.Create("DPanelList", self);
		barBackground:SetSize(newWidth, height);
		barBackground:SetPadding(0);
		barBackground:SetSpacing(0);
		barBackground:EnableHorizontal(false)
		
		-- Called when the panel is painted.
		function barBackground:Paint(width, panelHeight)
			width = newWidth; -- for some reason the width isn't correct
		
			if (title) then
				--surface.SetMaterial(Material("begotten/ui/formtop3.png"))
				--surface.SetDrawColor(255, 255, 255, 255);
				--surface.DrawTexturedRect(0, 0, width, 16)
				
				draw.SimpleText(title, "Default", 2, 1, titleColor or Color(255, 255, 255))
			end;
			
			draw.RoundedBox(0, 0, oY, width, height, Color(40, 40, 40));
			surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
			surface.SetDrawColor(40, 40, 40, 255);
			surface.DrawTexturedRect(2, oY + 2, width - 4, height - yOffset)
			
			self:SetTall(height)
		end;
		
		barBox:AddItem(barBackground);
		
		local overflow = {};
		local barMaxSize = barBackground:GetWide() - 4;

		for k, v in ipairs (barTable) do
			if (!v.color) then
				v.color = Color(255, 255, 255);
			end;
			
			if (!v.font) then
				v.font = "Default";
			end;
			
			local fontWidth, fontHeight = GetFontWidth(v.font, v.text) + 4, GetFontHeight(v.font, v.text) + 4;
			local width = math.Round((v.percentage / 100) * barMaxSize);
			local color = v.color;
			
			local barPortion = vgui.Create("Panel", barBackground);
			barPortion:SetSize(width, height - 4);
			barPortion:SetPos(oX - 2, oY + 2);

			if !v.textless then
				overflow[k] = v;
			end;
			
			-- Called when the panel is painted.
			function barPortion:Paint(width, height)
				local widthDifference = 0;
				local xDifference = 0;
				
				if (k > 1) then
					xDifference = -2;
					widthDifference = 4
				end;
				
				if (barTable[k + 1]) then
					widthDifference = 4
				elseif (k != #barTable) then
					widthDifference = 2;
				else
					widthDifference = 0;
				end;
				
				local sex = 0;
				local OMFG = 0;
				if (title) then
					sex = 0
					OMFG = 18;
				end;
				
				local oY = sex
				
				draw.RoundedBox(0, 0, oY, width, height - OMFG, v.color);
				surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
				surface.SetDrawColor(v.color.r, v.color.g, v.color.b, 255);
				surface.DrawTexturedRect(2 + xDifference, oY + 2, width - 2 + widthDifference, height - yOffset)
				
				--[[if (fontWidth < width) then
					if (!v.textless) then
						local textX = width - (fontWidth + 2);
						
						if (v.leftTextAlign) then
							textX = 4;
						end;
						
						draw.SimpleText(v.text, v.font, textX, height - fontHeight - OMFG, Color(255, 255, 255));
					end;
				end;]]--
			end;
			
			if (!v.noDisplay and !overflow[k]) then
				overflow[k] = v;
			end;

			oX = oX + width;
		end;

		if (!table.IsEmpty(overflow) and !multibar) then
			for k, v in ipairs (overflow) do
				local label = vgui.Create("DLabel", self);
				local newPercentage = math.Round(v.percentage);
				local showPercentage = v.showPercentage or false;
				
				if (showPercentage) then
					if (v.description) then
						label:SetText(v.description.." - "..newPercentage.."%");
					else
						label:SetText(v.text.." - "..newPercentage.."%");
					end;
				else
					if (v.description) then
						label:SetText(v.description);
					else
						label:SetText(v.text);
					end;
				end;
				
				label:SetFont(v.font);
				label:SetTextColor(v.color);
				label:SetTextInset(2, 0);
				label:SizeToContents();
				barBox:AddItem(label);
			end;
		end;
		
		if toolTip then
			local tooltipPanel = vgui.Create("Panel", barBox);
			
			tooltipPanel:SetSize(barBox:GetSize());
			tooltipPanel.Paint = function() end;
			
			if isfunction(toolTip) then
				Clockwork.kernel:CreateDermaToolTip(tooltipPanel);

				tooltipPanel:SetToolTipCallback(toolTip)
			else
				tooltipPanel:SetTooltip(toolTip);
			end
		end

		if bHalf then
			self.barList:AddItem(barBox);
		else
			self.panelList:AddItem(barBox);
		end
	end;

	-- A function to add a row of square icons.
	function frame:AddIconRow(iconTable, height, paintCallback)
		local height = height or 32;
		local iconBox = vgui.Create("DPanelList", self);
		iconBox:SetSize(frameWidth, height);
		iconBox:SetPadding(4);
		iconBox:SetSpacing(4);
		iconBox:EnableHorizontal(true);
		
		-- Called when the panel is painted.
		function iconBox:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height);
			else
				--Clockwork.kernel:DrawWithTexture("begotten/ui/butt24.png", 0, 0, 0, width, height, Color(0, 0, 0, 255));
			end;

			self:SetTall(self.pnlCanvas:GetTall());
		end;
		
		for i, v in ipairs(iconTable) do
			local icon;
			
			if v.itemTable then
				local itemTable = v.itemTable;
				
				if itemTable.iconoverride then
					icon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DImageButton", self));
					
					icon:SetImage(itemTable.iconoverride);
					icon:SetSize(48, 48);
					icon.isSpawnIcon = false;
					icon:SetItemTable(itemTable);
				else
					local model, skin = Clockwork.item:GetIconInfo(itemTable);
					
					icon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
					
					icon:SetModel(model, skin);
					icon:SetSize(48, 48);
					icon.isSpawnIcon = true;
					icon:SetItemTable(itemTable);
				end
				
				icon:SetItemTable(itemTable);
			else
				if v.button and isfunction(v.button) then
					icon = vgui.Create("DImageButton", self);
					
					icon.DoClick = v.button
					icon.DoRightClick = icon.DoClick;
				else
					icon = vgui.Create("DImage", self);
				end
				
				icon:SetSize(height, height);
				icon:SetImage(v.icon);
				
				if v.tooltip and isfunction(v.tooltip) then
					Clockwork.kernel:CreateDermaToolTip(icon);

					icon:SetToolTipCallback(v.tooltip);
				end
			end
			
			iconBox:AddItem(icon);
		end;
		
		self.panelList:AddItem(iconBox);
	end;
	
	-- A function to add an infobox with icon support.
	function frame:AddInfoBoxIcons(infoTable)
		local infoBox = vgui.Create("DPanelList", self);
		infoBox:SetWide(frameWidth)
		infoBox:SetTall(128)
		infoBox:SetPadding(4);
		infoBox:SetSpacing(4);
		infoBox.panels = {};
		function infoBox:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height);
			else
				Clockwork.kernel:DrawWithTexture("begotten/ui/generic_dirty.png", 0, 0, 0, width, height, Color(40, 40, 40, 175));
			end;
			local penal = self.pnlCanvas:GetTall();
			for k, v in pairs (self.panels) do
				penal = penal + v:GetTall();
			end;
			self:SetTall(penal);
		end;
		for k, v in ipairs (infoTable) do
			local cuHeight = 0;
			for k2, v2 in pairs (infoBox.panels) do
				cuHeight = cuHeight + (v2:GetTall() + 8)
			end;
			local icon = Material(v.icon);
			local iconWidth = v.iconWidth or (icon:Width() + 4);
			local ico = vgui.Create("Panel", infoBox);
			ico:SetPos(4, cuHeight + 4);
			ico:SetSize(iconWidth - 4, iconWidth - 4);
			function ico:Paint(width, height)
				surface.SetMaterial(icon);
				surface.SetDrawColor(255, 255, 255);
				surface.DrawTexturedRect(0, 0, width, height);
			end;
			local entryBox = vgui.Create("DPanelList", infoBox);
			entryBox:SetPos(iconWidth, cuHeight);
			entryBox:SetPadding(4);
			entryBox:SetSpacing(0);
			entryBox:SetWide(self:GetWide() - iconWidth - 8);
			function entryBox:Paint(width, height)
				self:SetTall(math.max(self.pnlCanvas:GetTall(), iconWidth));
			end;
			local label = vgui.Create("DLabel", self);
				label:SetText(v.text)
				label:SetTextColor(v.color);
				label:SetFont(v.font);
				label:SizeToContents();
				label:SetWrap(true);
				label:SetAutoStretchVertical(true)
			entryBox:AddItem(label)
			infoBox.panels[#infoBox.panels + 1] = entryBox
		end;
		self.panelList:AddItem(infoBox);
	end;
	
	-- A function to quickly add multiple individual bars.
	function frame:AddMultiBar(height, barTable, paintCallback)
		local height = math.max(height, 20) or 24
		local container = vgui.Create("DPanelList", self);
		container:SetPadding(2);
		container:SetSpacing(4);
		function container:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height);
			else
				Clockwork.kernel:DrawWithTexture("begotten/ui/collapsible3-full.png", 0, 0, 0, width, height, Color(0, 0, 0, 255));
			end;
			self:SetTall(self.pnlCanvas:GetTall());
		end;
		for k, v in ipairs (barTable) do
			local barColor = v.color or Color(50, 50, 150);
			local barBackground = vgui.Create("Panel", self);
			barBackground:SetSize(self:GetWide() - 8, height);
			function barBackground:Paint(width, height)
				draw.RoundedBox(0, 0, 0, width, height, Color(40, 40, 40));
				surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
				surface.SetDrawColor(40, 40, 40, 255);
				surface.DrawTexturedRect(0, 0, width, height)
			end;
			local width = barBackground:GetWide() - 16;
			local progress = (width * (v.percentage / 100))
			local barProgress = vgui.Create("Panel", barBackground);
			barProgress:SetPos(0, 0);
			barProgress:SetSize(progress + 1, height- 1);
			function barProgress:Paint(width, height)
				draw.RoundedBox(0, 2, 2, width, height - 4, barColor);
				surface.SetMaterial(Material("begotten/ui/infotextsquash.png"))
				surface.SetDrawColor(barColor.r, barColor.g, barColor.b, 255);
				surface.DrawTexturedRect(2, 2, width, height - 4)
			end;
			local textHeight = GetFontHeight("Default", v.text);
			local barLabel = vgui.Create("DLabel", barBackground);
			barLabel:SetPos(6, (height / 2) - (textHeight / 2));
			barLabel:SetFont("Default");
			barLabel:SetText(v.text);
			barLabel:SetTextColor(v.textColor or Color(0, 0, 0))
			barLabel:SizeToContents();
			container:AddItem(barBackground);
		end;
		self.panelList:AddItem(container)
	end;

	function frame:AddMarkupObject(t, paintCallback)
		local container = vgui.Create("DPanelList", self);
		container:SetPadding(0);
		container:SetSpacing(0);

		function container:Paint(width, height)
			if (paintCallback) then
				paintCallback(width, height)
			end;
			
			if (!self.markupObject) then
				self.markupObject = markup.Parse(t, width);
				Clockwork.kernel:OverrideMarkupDraw(self.markupObject)
			end;
			
			self.markupObject:Draw(2, 2, nil, nil, 255)
			local width, height = self.markupObject:Size()
			self:SetTall(height + 4);
		end;

		self.panelList:AddItem(container);
	end;
	
	function frame:AddButton(name, color, height, Callback, bTopInsert)
		if (!frame.buttons) then
			frame.buttons = {};
		elseif (frame.buttons[tostring(name)]) then
			return;
		end;
		
		local button = vgui.Create("DButton", self)
		button:SetText(tostring(name));
		button:SetTextColor(color)
		button:SetHeight(height)
		
		function button:DoClick()
			if (Callback and isfunction(Callback)) then
				Callback();
			end;
		end;
		
		if (bTopInsert) then
			self.panelList:InsertAtTop(button);
		else
			self.panelList:AddItem(button);
		end;
		frame.buttons[tostring(name)] = true;
	end;

	if parent.GetItemTable then
		local itemTable = parent:GetItemTable();

		if (itemTable) then
			frame.itemTable = itemTable;
		
			local bShowWeight = !parent.bWeightless or true;
			
			if (!itemTable.bDisplayWeight) then
				bShowWeight = false;
			end;
			
			local category = itemTable("category", "Other");
			
			item.BuildTooltip(category, itemTable, x, y, frame:GetWide(), frame:GetTall(), frame, bShowWeight);
			
			if (itemTable.SetUpTooltip) then
				itemTable:SetUpTooltip(x, y, frame:GetWide(), frame:GetTall(), frame)
			end;
			
			if (itemTable.modelPreview) then
				frame:AddModelPanel(itemTable.model, frameWidth)
			end;
		end
	end;

	if (toolTipCallback) then
		toolTipCallback(frame);
	end;

	return frame;
end;

-- Called to get whether the local player can see the admin ESP.
function GM:PlayerCanSeeAdminESP()
	return (Clockwork.ConVars.ADMINESP:GetInt() == 1);
end

-- Called when the local player attempts to get up.
function GM:PlayerCanGetUp()
	return true
end

-- Called when the local player attempts to see the top bars.
function GM:PlayerCanSeeBars(class)
	if (!Clockwork.Client:Alive() or Clockwork.Client.LoadingText) then
		return
	end
	
	--return tobool(Clockwork.ConVars.TOPBARS:GetInt())
	return true
end

-- Called when the local player attempts to see the top hints.
function GM:PlayerCanSeeHints()
	return true
end

-- Called when the local player attempts to see the center hints.
function GM:PlayerCanSeeCenterHints()
	return true
end

-- Called when the local player attempts to see the date and time.
function GM:PlayerCanSeeDateTime()
	--return tobool(Clockwork.ConVars.DATETIME:GetInt());
	
	return false
end

-- Called when the local player attempts to see a class.
function GM:PlayerCanSeeClass(class)
	return true
end

-- Called when the local player attempts to see the player info.
function GM:PlayerCanSeePlayerInfo()
	return Clockwork.menu:GetOpen();
end

-- A function to add a hint.
function GM:AddHint(name, delay)
	return false
end

-- A function to notify the local player.
function GM:AddNotify(text, class, length)
	return false
end

-- Called when the target ID HUD should be drawn.
function GM:HUDDrawTargetID()
	if (IsValid(Clockwork.Client) and Clockwork.Client:Alive() and !IsValid(Clockwork.EntityMenu)) then
		if (!Clockwork.Client:IsRagdolled(RAGDOLL_FALLENOVER)) then
			local trace = Clockwork.player:GetRealTrace(Clockwork.Client)
			local traceEntity = trace.Entity
			local fadeDistance = 1024;
			
			fadeDistance = hook.Run("ModifyTargetIDDistance", fadeDistance) or fadeDistance; 
			
			local curTime = UnPredictedCurTime()
			
			if (!self.TargetEntities) then
				self.TargetEntities = {}
			end

			if (IsValid(traceEntity) and !traceEntity:IsEffectActive(EF_NODRAW) and traceEntity:GetColor().a > 0) then
				if (!self.TargetEntities[traceEntity]) then
					if (traceEntity.WrappedTable) then
						traceEntity.WrappedTable = nil;
					end;
					
					if (traceEntity.physDescTable) then
						traceEntity.physDescTable = nil;
					end;

					self.TargetEntities[traceEntity] = 1
					traceEntity.grace = curTime + 2
				end
			end
			
			local targetIDTextFont = Clockwork.option:GetFont("target_id_text")
			local shootPosition = Clockwork.Client:GetShootPos()
			local frameTime = FrameTime()
			
			Clockwork.kernel:OverrideMainFont(targetIDTextFont)
			
			for k, v in pairs (self.TargetEntities) do
				local alpha = self.TargetEntities[k]
				local entity = k
				
				if (!IsValid(entity) or alpha == 0 and self.TargetEntities[k]) then
					self.TargetEntities[k] = nil
					continue
				end

				local entityPosition = entity:GetPos()
				local class = entity:GetClass()
				local distance = shootPosition:Distance(entityPosition)
				local screenPosition = (entityPosition + Vector(0, 0, 20)):ToScreen()
				local x, y = screenPosition.x, screenPosition.y
				local fade = false

				if (distance >= fadeDistance) then
					fade = true
				elseif (traceEntity != entity) then
					fade = true
				end
				
				if (fade) then
					if (alpha != 0) then
						self.TargetEntities[k] = math.Approach(alpha, 0, frameTime * 256)
					else
						self.TargetEntities[k] = nil continue
					end
				else
					if (alpha != 255) then
						self.TargetEntities[k] = math.Approach(alpha, 255, frameTime * 256)
					end
				end
				
				local distanceAlpha = Clockwork.kernel:CalculateAlphaFromDistance(fadeDistance, shootPosition, entityPosition)
				alpha = math.min(distanceAlpha, alpha)

				if alpha > 0 then
					local player = Clockwork.entity:GetPlayer(entity)
					
					if (player and player:GetSharedVar("isThrall")) then return; end

					if (player and Clockwork.Client != player) then
						if (Clockwork.plugin:Call("ShouldDrawPlayerTargetID", player)) then
							if (!Clockwork.player:IsNoClipping(player)) then
								--[[if (Clockwork.nextCheckRecognises and Clockwork.nextCheckRecognises[2] != player) then
									Clockwork.Client:SetNetVar("TargetKnows", true)
								end]]--
								
								local playerEntity = entity;
								local position = Clockwork.plugin:Call("GetPlayerTypingDisplayPosition", player)

								if (!position) then
									local boneID;
									
									if entity:GetClass() == "prop_ragdoll" then
										boneID = playerEntity:LookupBone("ValveBiped.Bip01_Spine1") or playerEntity:LookupBone("ValveBiped.Bip01_Spine") or playerEntity:LookupBone("ValveBiped.Bip01_Pelvis");
									else
										boneID = playerEntity:LookupBone("ValveBiped.Bip01_Head1") or playerEntity:LookupBone("ValveBiped.Head");
									end

									if (boneID) then
										local bonePosition = playerEntity:GetBonePosition(boneID)
										
										if (!bonePosition) then
											local ragdolled = playerEntity:IsRagdolled()
											local vehicle = playerEntity:InVehicle()
											local add = 80

											if (vehicle) then
												add = 128
											elseif (ragdolled) then
												add = 16
											elseif (crouching) then
												add = 64
											end
											
											position = entityPosition + Vector(0, 0, add)
										else
											position = bonePosition + Vector(0, 0, 18)
										end
									end
									
									if (!position) then
										position = entityPosition
									end
								end
								
								local screenPosition = position:ToScreen()
								local x, y = screenPosition.x, screenPosition.y
								local teamColor = _team.GetColor(player:Team());
								
								if (Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
									local text = string.Explode("\n", hook.Run("GetTargetPlayerName", player) or player:Name())
									local newY
									
									teamColor = hook.Run("OverrideTeamColor", player, true) or teamColor;
									
									for k, v in pairs(text) do
										newY = Clockwork.kernel:DrawInfo(v, x, y, teamColor, alpha)

										if (newY) then
											y = newY
										end
									end
								else
									local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(player)
									local wrappedTable = {unrecognisedName}
									
									teamColor = hook.Run("OverrideTeamColor", player) or teamColor;
									
									local result;
									local newY;

									if Clockwork.ConVars.PHYSDESCINSPECT:GetInt() == 0 or input.IsKeyDown(Clockwork.ConVars.Binds["PHYSDESCINSPECT"]:GetInt()) then
										result = Clockwork.plugin:Call("PlayerCanShowUnrecognised", player, x, y, unrecognisedName, teamColor, alpha)
									else
										--[[local key = input.GetKeyName(Clockwork.ConVars.Binds["PHYSDESCINSPECT"]:GetInt()) or "NOT BOUND";
										
										result = "Press <"..key:upper().."> to inspect this character.";]]--
									end
									
									if result then
										if (type(result) == "string") then
											wrappedTable = {""}
											Clockwork.kernel:WrapTextSpaced(result, targetIDTextFont, math.max(math.Round(ScrW() / 3.75), 512), wrappedTable)
										elseif (usedPhysDesc) then
											wrappedTable = {""}
											Clockwork.kernel:WrapTextSpaced(unrecognisedName, targetIDTextFont, math.max(math.Round(ScrW() / 3.75), 512), wrappedTable)
										end

										if (result == true or type(result) == "string") then
											if (wrappedTable) then
												for k, v in pairs(wrappedTable) do
													newY = Clockwork.kernel:DrawInfo(v, x, y, teamColor, alpha)

													if (newY) then
														y = newY
													end
												end
											end;
										elseif (tonumber(result)) then
											y = result
										end
									end
								end
								
								local colorWhite = Color(255, 255, 255)
								
								if Clockwork.ConVars.PHYSDESCINSPECT:GetInt() == 0 or input.IsKeyDown(Clockwork.ConVars.Binds["PHYSDESCINSPECT"]:GetInt()) then
									Clockwork.TargetPlayerText.stored = {}
									
									Clockwork.plugin:Call("GetTargetPlayerText", player, Clockwork.TargetPlayerText)
									Clockwork.plugin:Call("DestroyTargetPlayerText", player, Clockwork.TargetPlayerText)
									
									y = Clockwork.plugin:Call("DrawTargetPlayerStatus", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerSubfaction", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerLevel", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerMarked", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetPlayerSymptoms", player, alpha, x, y) or y
									y = Clockwork.plugin:Call("DrawTargetSanityLevel", player, alpha, x, y) or y
									
									for k, v in pairs(Clockwork.TargetPlayerText.stored) do
										if (v.scale) then
											y = Clockwork.kernel:DrawInfoScaled(v.scale, v.text, x, y, v.color or colorWhite, alpha)
										else
											y = Clockwork.kernel:DrawInfo(v.text, x, y, v.color or colorWhite, alpha)
										end
									end
								else
									if !(Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
										Clockwork.TargetPlayerText.stored = {}
									
										Clockwork.plugin:Call("GetTargetPlayerText", player, Clockwork.TargetPlayerText)
										Clockwork.plugin:Call("DestroyTargetPlayerText", player, Clockwork.TargetPlayerText)
										
										for k, v in pairs(Clockwork.TargetPlayerText.stored) do
											if (v.scale) then
												y = Clockwork.kernel:DrawInfoScaled(v.scale, v.text, x, y, v.color or colorWhite, alpha)
											else
												y = Clockwork.kernel:DrawInfo(v.text, x, y, v.color or colorWhite, alpha)
											end
										end
									end
									
									y = Clockwork.plugin:Call("DrawTargetPlayerStatus", player, alpha, x, y) or y
									
									local key = input.GetKeyName(Clockwork.ConVars.Binds["PHYSDESCINSPECT"]:GetInt()) or "NOT BOUND";
									
									y = Clockwork.kernel:DrawInfo("Press <"..key:upper().."> to inspect this character.", x, y, colorWhite, alpha)
								end
								
								--[[if (!Clockwork.nextCheckRecognises or curTime >= Clockwork.nextCheckRecognises[1] or Clockwork.nextCheckRecognises[2] != player) then
									netstream.Start("GetTargetRecognises", player)
									
									Clockwork.nextCheckRecognises = {curTime + 2, player}
								end]]--
							end
						end
					--[[elseif (Clockwork.generator and Clockwork.generator:FindByID(class)) then
						local generator = Clockwork.generator:FindByID(class)
						local power = trace.Entity:GetPower()
						local name = generator.name

						y = Clockwork.kernel:DrawInfo(name, x, y, Color(150, 150, 100, 255), alpha)
						
						local info = {
							showPower = true,
							generator = generator,
							x = x,
							y = y
						}
						
						Clockwork.plugin:Call("DrawGeneratorTargetID", trace.Entity, info)
						
						if (info.showPower) then
							if (power == 0) then
								info.y = Clockwork.kernel:DrawInfo("Press Use to re-supply", info.x, info.y, Color(255, 255, 255, 255), alpha)
							else
								info.y = Clockwork.kernel:DrawBar(
									info.x - 80, info.y, 160, 16, Clockwork.option:GetColor("information"), generator.powerPlural,
									power, generator.power, power < (generator.power / 5), {uniqueID = class}
								)
							end
						end
					elseif (entity:IsWeapon()) then
						local inactive = !IsValid(entity:GetParent())
						
						if (inactive) then
							y = Clockwork.kernel:DrawInfo(entity:GetPrintName(), x, y, Color(200, 100, 50, 255), alpha)
							y = Clockwork.kernel:DrawInfo("Press use to equip.", x, y, Color(255, 255, 255), alpha)
						end]]--
					elseif (entity.HUDPaintTargetID) then
						entity:HUDPaintTargetID(x, y, alpha)
					else
						hook.Call("HUDPaintEntityTargetID", Clockwork, entity, {
							alpha = alpha,
							x = x,
							y = y,
						})
					end
				end
			end
			
			Clockwork.kernel:OverrideMainFont(false)
		end
	end
end

-- Called when the target's status should be drawn.
function GM:DrawTargetPlayerStatus(target, alpha, x, y)
	local informationColor = Clockwork.option:GetColor("information")
	local gender = "He"

	if (target:GetGender() == GENDER_FEMALE) then
		gender = "She"
	end

	if(target:GetSharedVar("isThrall")) then return; end

	if (!target:Alive()) then
		return Clockwork.kernel:DrawInfo(gender.." is clearly deceased.", x, y, informationColor, alpha)
	else
		return y
	end
end

-- Called when the character panel tool tip is needed.
function GM:GetCharacterPanelToolTip(panel, character)
	if (table.Count(Clockwork.faction:GetAll()) > 1) then
		local numPlayers = #Clockwork.faction:GetPlayers(character.faction)
		local numLimit = Clockwork.faction:GetLimit(character.faction)
		return "There are "..numPlayers.."/"..numLimit.." characters with this faction."
	end
end

-- Called when a player's status info is needed.
function GM:GetStatusInfo(player, text)
	local action = Clockwork.player:GetAction(player, true)

	if (action) then
		if (!player:IsRagdolled()) then
			if (action == "lock") then
				table.insert(text, "[Locking]")
			elseif (action == "unlock") then
				table.insert(text, "[Unlocking]")
			end
		elseif (action == "unragdoll") then
			if (player:GetRagdollState() == RAGDOLL_FALLENOVER) then
				table.insert(text, "[Getting Up]")
			else
				table.insert(text, "[Unconscious]")
			end
		elseif (!player:Alive()) then
			table.insert(text, "[Dead]")
		else
			table.insert(text, "[Performing '"..action.."']")
		end
	end

	if (player:GetRagdollState() == RAGDOLL_FALLENOVER) then
		local fallenOver = player:GetDTBool(BOOL_FALLENOVER)

		if (fallenOver) then
			table.insert(text, "[Fallen Over]")
		end
	end
end

--[[
	@codebase Client
	@details This function is called to figure out the text, percentage and flash of the current progress bar.
	@class Clockwork
	@returns Table The text, flash, and percentage of the progress bar.
--]]

function GM:GetProgressBarInfo()
	--[[local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true)

	if (!Clockwork.Client:Alive() and action == "spawn") then
		return {text = "You will be respawned shortly.", percentage = percentage, flash = percentage < 10}
	else]]
	
	if Clockwork.Client:Alive() then
		local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true)
		local ragdolled = Clockwork.Client:IsRagdolled();
		
		if ragdolled then
			if (action == "unragdoll") then
				if (Clockwork.Client:GetRagdollState() == RAGDOLL_FALLENOVER) then
					return {text = "You are regaining stability.", percentage = percentage, flash = percentage < 10}
				else
					return {text = "You are regaining consciousness.", percentage = percentage, flash = percentage < 10}
				end
			else
				local info = hook.Run("GetProgressBarInfoAction", action, percentage);
				
				if info then return info end;
			
				if (action != "unragdoll" and hook.Run("PlayerCanGetUp", action)) then
					return {text = "Press 'jump' to get up.", percentage = 100}
				end
			end
		elseif action then
			local info = hook.Run("GetProgressBarInfoAction", action, percentage);
			
			if info then return info end;
			
			if (action == "lock") then
				return {text = "The door is being locked.", percentage = percentage, flash = percentage < 10}
			elseif (action == "unlock") then
				return {text = "The door is being unlocked.", percentage = percentage, flash = percentage < 10}
			end;
			
			return {text = "You are performing an action.", percentage = percentage};
		end;
	end;
end

-- Called just before the local player's information is drawn.
function GM:PreDrawPlayerInfo(boxInfo, information, subInformation) end

-- Called just after the local player's information is drawn.
function GM:PostDrawPlayerInfo(boxInfo, information, subInformation) end

-- Called just after the date time box is drawn.
function GM:PostDrawDateTimeBox(info) end

--[[
	@codebase Client
	@details Called after the view model is drawn.
	@param Entity The viewmodel being drawn.
	@param Player The player drawing the viewmodel.
	@param Weapon The weapon table for the viewmodel.

function GM:PostDrawViewModel(viewModel, player, weapon)
		 if ((weapon.UseHands or !weapon:IsScripted()) and !weapon.IsSXBASEWeapon) then
		local hands = Clockwork.Client:GetHands()

			if IsValid(hands) then
				hands:DrawModel()
			end
		 end
end
--]]
--[[
	@codebase Client
	@details This function is called when local player info text is needed and adds onto it (F1 menu).
	@class Clockwork
	@param Table The current table of player info text to add onto.
--]]
function GM:GetPlayerInfoText(playerInfoText)
	local cash = Clockwork.player:GetCash() or 0
	local wages = Clockwork.player:GetWages() or 0

	if (config.Get("cash_enabled"):Get()) then
		if (cash > 0) then
			playerInfoText:Add("CASH", Clockwork.option:GetKey("name_cash")..": "..Clockwork.kernel:FormatCash(cash, true))
		end

		if (wages > 0) then
			playerInfoText:Add("WAGES", Clockwork.Client:GetWagesName()..": "..Clockwork.kernel:FormatCash(wages))
		end
	end

	playerInfoText:AddSub("NAME", Clockwork.Client:Name(), 2)
	playerInfoText:AddSub("CLASS", _team.GetName(Clockwork.Client:Team()), 1)
end

--[[
	@codebase Client
	@details This function is called when the player's fade distance is needed for their target text (when you look at them).
	@class Clockwork
	@param Table The player we are finding the distance for.
	@returns Int The fade distance, defaulted at 4096.
--]]
function GM:GetTargetPlayerFadeDistance(player)
	return 4096
end

-- Called when the player info text should be destroyed.
function GM:DestroyPlayerInfoText(playerInfoText) end

--[[
	@codebase Client
	@details This function is called when the targeted player's target text is needed.
	@class Clockwork
	@param Table The player we are finding the distance for.
	@param Table The player's current target text.
--]]
function GM:GetTargetPlayerText(player, targetPlayerText)
	local targetIDTextFont = Clockwork.option:GetFont("target_id_text")
	local physDescTable = {}
	local thirdPerson = "him"

	if (player:GetGender() == GENDER_FEMALE) then
		thirdPerson = "her"
	end

	if (Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
		local plyTab = player:GetTable();
		
		if (!plyTab.physDescTable) then
			plyTab.physDescTable = {};
			Clockwork.kernel:WrapText(Clockwork.player:GetPhysDesc(player), targetIDTextFont, math.max(math.Round(ScrW() / 3.75), 512), physDescTable)
			plyTab.physDescTable = table.Copy(physDescTable);
		end;
		
		if (plyTab.physDescTable) then
			for k, v in pairs(plyTab.physDescTable) do
				targetPlayerText:Add("PHYSDESC_"..k, v)
			end
		end;
	elseif (player:Alive()) then
		targetPlayerText:Add("PHYSDESC", "You do not recognize "..thirdPerson..".")
	end
end

-- Called when the target player's text should be destroyed.
function GM:DestroyTargetPlayerText(player, targetPlayerText) end

-- Called when a player's scoreboard text is needed.
function GM:GetPlayerScoreboardText(player)
	local thirdPerson = "him"

	if (player:GetGender() == GENDER_FEMALE) then
		thirdPerson = "her"
	end

	if (Clockwork.player:DoesRecognise(player, RECOGNISE_PARTIAL)) then
		local physDesc = Clockwork.player:GetPhysDesc(player)

		if (string.utf8len(physDesc) > 64) then
			return string.utf8sub(physDesc, 1, 61).."..."
		else
			return physDesc
		end
	else
		return "You do not recognize "..thirdPerson..".";
	end
end

-- Called when the local player's character screen faction is needed.
function GM:GetPlayerCharacterScreenFaction(character)
	return character.faction
end

-- Called to get whether the local player's character screen is visible.
function GM:GetPlayerCharacterScreenVisible(panel)
	if (!Clockwork.quiz:GetEnabled() or Clockwork.quiz:GetCompleted()) then
		return true
	else
		return false
	end
end

-- Called to get whether the character menu should be created.
function GM:ShouldCharacterMenuBeCreated()
	if (Clockwork.ClockworkIntroFadeOut) then
		return false
	end

	return true
end

-- Called when the local player's character screen is created.
function GM:PlayerCharacterScreenCreated(panel)
	if (Clockwork.quiz:GetEnabled()) then
		netstream.Start("GetQuizStatus", true)
	end
end

-- Called when a player's scoreboard class is needed.
function GM:GetPlayerScoreboardClass(player)
	return _team.GetName(player:Team())
end

-- Called when a player's scoreboard options are needed.
function GM:GetPlayerScoreboardOptions(player, options, menu)
	local charTakeFlags = Clockwork.command:FindByID("CharTakeFlags")
	local charGiveFlags = Clockwork.command:FindByID("CharGiveFlags")
	local charGiveItem = Clockwork.command:FindByID("CharGiveItem")
	local charSetName = Clockwork.command:FindByID("CharSetName")
	local CharAddExperience = Clockwork.command:FindByID("CharAddExperience")
	local CharSetSacramentLevel = Clockwork.command:FindByID("CharSetSacramentLevel")
	local CharOpenBeliefTree = Clockwork.command:FindByID("CharOpenBeliefTree")
	local plySetGroup = Clockwork.command:FindByID("PlySetGroup")
	local plyDemote = Clockwork.command:FindByID("PlyDemote")
	local plyKick = Clockwork.command:FindByID("PlyKick")
	local plyBan = Clockwork.command:FindByID("PlyBan")
	local plyBring = Clockwork.command:FindByID("PlyTeleport")
	local plyBringFreeze = Clockwork.command:FindByID("PlyTeleportFreeze")
	local plyFreeze = Clockwork.command:FindByID("PlyFreeze")
	local plySummon = Clockwork.command:FindByID("SummonPlayer")

	if (plyKick and Clockwork.player:HasFlags(Clockwork.Client, plyKick.access)) then
		options["Kick Player"] = function()
			Derma_StringRequest(player:Name(), "What is your reason for kicking them?", nil, function(text)
				Clockwork.kernel:RunCommand("PlyKick", player:Name(), text)
			end)
		end
	end

	if (plyBan and Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("PlyBan").access)) then
		options["Ban Player"] = function()
			Derma_StringRequest(player:Name(), "How many minutes would you like to ban them for?", nil, function(minutes)
				Derma_StringRequest(player:Name(), "What is your reason for banning them?", nil, function(reason)
					Clockwork.kernel:RunCommand("PlyBan", player:Name(), minutes, reason)
				end)
			end)
		end
	end
	
	if (plyBring and Clockwork.player:HasFlags(Clockwork.Client, plyBring.access)) then
		options["Bring"] = function()
			Clockwork.kernel:RunCommand("PlyTeleport", player:Name(), text)
		end
	end
	
	if (plyBringFreeze and Clockwork.player:HasFlags(Clockwork.Client, plyBringFreeze.access)) then
		options["Bring & Freeze"] = function()
			Clockwork.kernel:RunCommand("PlyTeleportFreeze", player:Name(), text)
		end
	end
	
	if (plyFreeze and Clockwork.player:HasFlags(Clockwork.Client, plyFreeze.access)) then
		options["Freeze/Unfreeze"] = function()
			Clockwork.kernel:RunCommand("PlyFreeze", player:Name(), text)
		end
	end

	if (charGiveFlags and Clockwork.player:HasFlags(Clockwork.Client, charGiveFlags.access)) then
		options["Give Flags"] = function()
			Derma_StringRequest(player:Name(), "What flags would you like to give them?", nil, function(text)
				Clockwork.kernel:RunCommand("CharGiveFlags", player:Name(), text)
			end)
		end
	end

	if (charTakeFlags and Clockwork.player:HasFlags(Clockwork.Client,charTakeFlags.access)) then
		options["Take Flags"] = function()
			Derma_StringRequest(player:Name(), "What flags would you like to take from them?", player:GetDTString(STRING_FLAGS), function(text)
				Clockwork.kernel:RunCommand("CharTakeFlags", player:Name(), text)
			end)
		end
	end

	if (charSetName and Clockwork.player:HasFlags(Clockwork.Client, charSetName.access)) then
		options["Set Name"] = function()
			Derma_StringRequest(player:Name(), "What would you like to set their name to?", player:Name(), function(text)
				Clockwork.kernel:RunCommand("CharSetName", player:Name(), text)
			end)
		end
	end

	if (charGiveItem and Clockwork.player:HasFlags(Clockwork.Client, charGiveItem.access)) then
		options["Give Item"] = function()
			Derma_StringRequest(player:Name(), "What item would you like to give them?", nil, function(text)
				Clockwork.kernel:RunCommand("CharGiveItem", player:Name(), text)
			end)
		end
	end

	if (plySetGroup and Clockwork.player:HasFlags(Clockwork.Client, plySetGroup.access)) then
		options["Set Group"] = {}
		options["Set Group"]["Super Admin"] = function()
			Clockwork.kernel:RunCommand("PlySetGroup", player:Name(), "superadmin")
		end
		options["Set Group"]["Admin"] = function()
			Clockwork.kernel:RunCommand("PlySetGroup", player:Name(), "admin")
		end
		options["Set Group"]["Operator"] = function()
			Clockwork.kernel:RunCommand("PlySetGroup", player:Name(), "operator")
		end
	end

	if (plyDemote and Clockwork.player:HasFlags(Clockwork.Client, plyDemote.access)) then
		options["Demote"] = function()
			Clockwork.kernel:RunCommand("PlyDemote", player:Name())
		end
	end
	
	if (CharOpenBeliefTree and Clockwork.player:HasFlags(Clockwork.Client, CharOpenBeliefTree.access)) then
		options["Open Belief Tree"] = function()
			Clockwork.kernel:RunCommand("CharOpenBeliefTree", player:Name())
		end
	end
	
	if (CharSetSacramentLevel and Clockwork.player:HasFlags(Clockwork.Client, CharSetSacramentLevel.access)) then
		options["Set Level"] = function()
			Derma_StringRequest(player:Name(), "What level would you like to set them to? (Max: 30)", nil, function(level)
				Clockwork.kernel:RunCommand("CharSetSacramentLevel", player:Name(), level)
			end)
		end
	end
	
	if (CharAddExperience and Clockwork.player:HasFlags(Clockwork.Client, CharAddExperience.access)) then
		options["Add Faith (XP)"] = function()
			Derma_StringRequest(player:Name(), "How much faith (xp) would you like to add?", nil, function(xp)
				Clockwork.kernel:RunCommand("CharAddExperience", player:Name(), xp)
			end)
		end
	end
	
	if (plySummon and Clockwork.player:HasFlags(Clockwork.Client, plySummon.access)) then
		options["Summon"] = function()
			Clockwork.kernel:RunCommand("SummonPlayer", player:Name(), text)
		end
	end

	local canUwhitelist = false
	local canWhitelist = false
	local unwhitelist = Clockwork.command:FindByID("PlyUnwhitelist")
	local whitelist = Clockwork.command:FindByID("PlyWhitelist")

	if (whitelist and Clockwork.player:HasFlags(Clockwork.Client, whitelist.access)) then
		canWhitelist = true
	end

	if (unwhitelist and Clockwork.player:HasFlags(Clockwork.Client, unwhitelist.access)) then
		canUnwhitelist = true
	end

	if (canWhitelist or canUwhitelist) then
		local areWhitelistFactions = false

		for k, v in pairs(Clockwork.faction:GetAll()) do
			if (v.whitelist) then
				areWhitelistFactions = true
			end
		end

		if (areWhitelistFactions) then
			if (canWhitelist) then
				options["Whitelist"] = {}
			end

			if (canUwhitelist) then
				options["Unwhitelist"] = {}
			end

			for k, v in pairs(Clockwork.faction:GetAll()) do
				if (v.whitelist) then
					if (options["Whitelist"]) then
						options["Whitelist"][k] = function()
							Clockwork.kernel:RunCommand("PlyWhitelist", player:Name(), k)
						end
					end

					if (options["Unwhitelist"]) then
						options["Unwhitelist"][k] = function()
							Clockwork.kernel:RunCommand("PlyUnwhitelist", player:Name(), k)
						end
					end
				end
			end
		end
	end
end

-- Called when information about a door is needed.
--[[function GM:GetDoorInfo(door, information)
	local doorCost = config.Get("door_cost"):Get()
	local owner = Clockwork.entity:GetOwner(door)
	local text = Clockwork.entity:GetDoorText(door)
	local name = Clockwork.entity:GetDoorName(door)

	if (information == DOOR_INFO_NAME) then
		if (Clockwork.entity:IsDoorHidden(door) or Clockwork.entity:IsDoorFalse(door)) then
			return false
		elseif (name == "") then
			return "Door"
		else
			return name
		end
	elseif (information == DOOR_INFO_TEXT) then
		if (Clockwork.entity:IsDoorUnownable(door)) then
			if (!Clockwork.entity:IsDoorHidden(door)
			and !Clockwork.entity:IsDoorFalse(door)) then
				if (text == "") then
					return "This door is unownable."
				else
					return text
				end
			else
				return false
			end
		elseif (text != "") then
			if (!IsValid(owner)) then
				if (doorCost > 0) then
					return "This door can be purchased."
				else
					return "This door can be owned."
				end
			else
				return text
			end
		elseif (IsValid(owner)) then
			if (doorCost > 0) then
				return "This door has been purchased."
			else
				return "This door has been owned."
			end
		elseif (doorCost > 0) then
			return "This door can be purchased."
		else
			return "This door can be owned."
		end
	end
end]]--

-- Called to get whether or not a post process is permitted.
function GM:PostProcessPermitted(class)
	return false
end

-- Called just after the translucent renderables have been drawn.
function GM:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	--[[if (bDrawingSkybox or bDrawingDepth) then return end
	
	if (!Clockwork.kernel:IsChoosingCharacter()) then
		local eyePos = EyePos()
		local entities = ents.FindInSphere(eyePos, 256)

		if (#entities > 0) then
			local colorWhite = Clockwork.option:GetColor("white")
			local colorInfo = Clockwork.option:GetColor("information")
			local doorFont = Clockwork.option:GetFont("large_3d_2d")
			local eyeAngles = EyeAngles()

			for k, v in ipairs(entities) do
				if (Clockwork.entity:IsDoor(v)) then
					Clockwork.kernel:DrawDoorText(v, eyePos, eyeAngles, doorFont, colorInfo, colorWhite)
				end
			end
		end
	end]]--
end

-- Called when screen space effects should be rendered.
function GM:RenderScreenspaceEffects()
	if (IsValid(Clockwork.Client)) then
		local frameTime = FrameTime()
		local motionBlurs = {
			enabled = true,
			blurTable = {}
		}
		local color = 1

		if (!Clockwork.kernel:IsChoosingCharacter()) then
			if (Clockwork.Client:Alive()) then
				color = math.Clamp(color - ((Clockwork.Client:GetMaxHealth() - Clockwork.Client:Health()) * 0.01), 0, color)
				
				if cwLimbs then
					local headHealth = Clockwork.limb:GetHealth(HITGROUP_HEAD, false);
					
					if headHealth then
						if headHealth <= 75 and headHealth > 50 then
							motionBlurs.blurTable["health"] = 0.1;
						elseif headHealth <= 50 and headHealth > 25 then
							motionBlurs.blurTable["health"] = 0.3;
						elseif headHealth <= 25 and headHealth > 10 then
							motionBlurs.blurTable["health"] = 0.6;
						elseif headHealth < 10 then
							motionBlurs.blurTable["health"] = 0.9;
						end
					end
				end
			else
				color = 0
			end
		end

		Clockwork.ColorModify["$pp_colour_brightness"] = 0
		Clockwork.ColorModify["$pp_colour_contrast"] = 1
		Clockwork.ColorModify["$pp_colour_colour"] = color
		Clockwork.ColorModify["$pp_colour_addr"] = 0
		Clockwork.ColorModify["$pp_colour_addg"] = 0
		Clockwork.ColorModify["$pp_colour_addb"] = 0
		Clockwork.ColorModify["$pp_colour_mulr"] = 0
		Clockwork.ColorModify["$pp_colour_mulg"] = 0
		Clockwork.ColorModify["$pp_colour_mulb"] = 0

		local systemTable = Clockwork.system:FindByID("Color Modify")
		local overrideColorMod

		if (systemTable) then
			overrideColorMod = systemTable:GetModifyTable()
		end

		if (overrideColorMod and overrideColorMod.enabled) then
			Clockwork.ColorModify["$pp_colour_brightness"] = overrideColorMod.brightness
			Clockwork.ColorModify["$pp_colour_contrast"] = overrideColorMod.contrast
			Clockwork.ColorModify["$pp_colour_colour"] = overrideColorMod.color
			Clockwork.ColorModify["$pp_colour_addr"] = overrideColorMod.addr * 0.025
			Clockwork.ColorModify["$pp_colour_addg"] = overrideColorMod.addg * 0.025
			Clockwork.ColorModify["$pp_colour_addb"] = overrideColorMod.addg * 0.025
			Clockwork.ColorModify["$pp_colour_mulr"] = overrideColorMod.mulr * 0.1
			Clockwork.ColorModify["$pp_colour_mulg"] = overrideColorMod.mulg * 0.1
			Clockwork.ColorModify["$pp_colour_mulb"] = overrideColorMod.mulb * 0.1
		else
			hook.Run("PlayerSetDefaultColorModify", Clockwork.ColorModify)
		end

		hook.Run("PlayerAdjustColorModify", Clockwork.ColorModify)
		hook.Run("PlayerAdjustMotionBlurs", motionBlurs)

		if (motionBlurs.enabled) then
			local addAlpha = nil

			for k, v in pairs(motionBlurs.blurTable) do
				if (!addAlpha or v < addAlpha) then
					addAlpha = v
				end
			end

			if (addAlpha) then
				DrawMotionBlur(math.Clamp(addAlpha, 0.1, 1), 1, 0)
			end
		end

		--[[
			Hotfix for ColorModify issues on OS X.
		--]]
		if (system.IsOSX()) then
			Clockwork.ColorModify["$pp_colour_brightness"] = 0
			Clockwork.ColorModify["$pp_colour_contrast"] = 1
		end

		DrawColorModify(Clockwork.ColorModify)
	end
end

-- Called when the chat box is opened.
function GM:ChatBoxOpened() end

-- Called when the chat box is closed.
function GM:ChatBoxClosed(textTyped)
	Clockwork.Client.nextBind = CurTime() + 0.25;
end

-- Called when the chat box text has been typed.
function ChatBoxTextTyped(text)
	if (Clockwork.LastChatBoxText) then
		if (Clockwork.LastChatBoxText[1] == text) then
			return;
		end;
		
		if (#Clockwork.LastChatBoxText >= 25) then
			table.remove(Clockwork.LastChatBoxText, 25);
		end;
	else
		Clockwork.LastChatBoxText = {};
	end;

	table.insert(Clockwork.LastChatBoxText, 1, text);
end;

-- Called when the calc view table should be adjusted.
function GM:CalcViewAdjustTable(view) end

-- Called when the chat box info should be adjusted.
function GM:ChatBoxAdjustInfo(info) end

-- Called when the chat box text has changed.
function GM:ChatBoxTextChanged(previousText, newText) end

-- Called when the chat box has had a key code typed in.
function ChatBoxKeyCodeTyped(code, text)
	if (code == KEY_UP) then
		if (Clockwork.LastChatBoxText) then
			for k, v in pairs(Clockwork.LastChatBoxText) do
				if (v == text and Clockwork.LastChatBoxText[k + 1]) then
					return Clockwork.LastChatBoxText[k + 1];
				end;
			end;
			
			if (Clockwork.LastChatBoxText[1]) then
				return Clockwork.LastChatBoxText[1];
			end;
		end;
	elseif (code == KEY_DOWN) then
		if (Clockwork.LastChatBoxText) then
			for k, v in pairs(Clockwork.LastChatBoxText) do
				if (v == text and Clockwork.LastChatBoxText[k - 1]) then
					return Clockwork.LastChatBoxText[k - 1];
				end;
			end;
			
			if (#Clockwork.LastChatBoxText > 0) then
				return Clockwork.LastChatBoxText[#Clockwork.LastChatBoxText];
			end;
		end;
	end;
end;

-- Called when a notification should be adjusted.
function GM:NotificationAdjustInfo(info)
	return true
end

-- Called when the local player's business item should be adjusted.
function GM:PlayerAdjustBusinessItemTable(itemTable) end

-- Called when the local player's class model info should be adjusted.
function GM:PlayerAdjustClassModelInfo(class, info) end

-- Called when the local player's headbob info should be adjusted.
function GM:PlayerAdjustHeadbobInfo(info)
	local bisDrunk = Clockwork.player:GetDrunk()
	local scale

	--[[if (Clockwork.ConVars.HEADBOBSCALE) then
		scale = math.Clamp(Clockwork.ConVars.HEADBOBSCALE:GetFloat(),0,1) or 1
	else]]--
		scale = 1
	--end

	if (Clockwork.Client:IsRunning()) then
		info.speed = (info.speed * 4) * scale
		info.roll = (info.roll * 2) * scale
	elseif (Clockwork.Client:GetVelocity():Length() > 0) then
		info.speed = (info.speed * 3) * scale
		info.roll = (info.roll * 1) * scale
	else
		info.roll = info.roll * scale
	end

	if (isDrunk) then
		info.speed = info.speed * math.min(isDrunk * 0.25, 4)
		info.yaw = info.yaw * math.min(isDrunk, 4)
	end
end

-- Called when the local player's motion blurs should be adjusted.
function GM:PlayerAdjustMotionBlurs(motionBlurs) end

-- Called when the local player's item menu should be adjusted.
function GM:PlayerAdjustMenuFunctions(itemTable, menuPanel, itemFunctions) end

-- Called when the local player's item functions should be adjusted.
function GM:PlayerAdjustItemFunctions(itemTable, itemFunctions) end

-- Called when the local player's default colorify should be set.
function GM:PlayerSetDefaultColorModify(colorModify) end

-- Called when the local player's colorify should be adjusted.
function GM:PlayerAdjustColorModify(colorModify) end

-- Called to get whether a player's target ID should be drawn.
function GM:ShouldDrawPlayerTargetID(player)
	if player:GetColor() == Color(255, 255, 255, 0) then
		return false;
	end
	
	return true;
end

-- Called to get whether the local player's screen should fade black.
function GM:ShouldPlayerScreenFadeBlack()
	if (!Clockwork.Client:Alive() or Clockwork.Client:IsRagdolled(RAGDOLL_FALLENOVER)) then
		if (!hook.Run("PlayerCanSeeUnconscious")) then
			local introTextSmallFont = Clockwork.option:GetFont("intro_text_small");
			local scrH, scrW = ScrH(), ScrW();
			
			draw.RoundedBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, 255));
			
			if !Clockwork.Client:Alive() then
				draw.SimpleText("You have been corpsed.", introTextSmallFont, scrW / 2, scrH / 2, Color(170, 0, 0, 255), 1, 1);
			end
		
			return true;
		end
	end

	return false
end

-- Called when the menu background blur should be drawn.
function GM:ShouldDrawMenuBackgroundBlur()
	return true
end

-- Called when the character background blur should be drawn.
function GM:ShouldDrawCharacterBackgroundBlur()
	return false
end

-- Called when the character background should be drawn.
function GM:ShouldDrawCharacterBackground()
	return true
end

-- Called when the character fault should be drawn.
function GM:ShouldDrawCharacterFault(fault)
	return true
end

-- Called when the score board should be drawn.
function GM:HUDDrawScoreBoard()
	self.BaseClass:HUDDrawScoreBoard(player);
	
	local drawPendingScreenBlack = nil;
	local drawCharacterLoading = nil;
	local hasClientInitialized = Clockwork.Client:HasInitialized();
	local introTextSmallFont = Clockwork.option:GetFont("intro_text_small");
	local colorWhite = Clockwork.option:GetColor("white");
	local curTime = UnPredictedCurTime();
	local scrH = ScrH();
	local scrW = ScrW();

	if (hasClientInitialized) then
		if (!Clockwork.kernel:IsChoosingCharacter()) then
			Clockwork.kernel:CalculateScreenFading();
			
			if (!Clockwork.kernel:IsUsingCamera()) then
				Clockwork.plugin:Call("HUDPaintForeground");
			end;
			
			Clockwork.plugin:Call("HUDPaintImportant");
		end;

		if (!Clockwork.Client.InitializedCall) then
			Clockwork.Client.InitializedCall = true;
			Clockwork.plugin:Call("PostClientInitialized")
		end;
	end;
	
	if (Clockwork.plugin:Call("ShouldDrawBackgroundBlurs")) then
		Clockwork.kernel:DrawBackgroundBlurs();
	end;
	
	if (!Clockwork.player:HasDataStreamed()) then
		if (!self.DataStreamedAlpha) then
			self.DataStreamedAlpha = 255;
		end;
		
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255));
		
		if (!_file.Exists("papapete.txt", "DATA")) then
			_file.Write("papapete.txt", "pop open a fresh cold pop straight from the cooler");
			Clockwork.Client.EpilepsyWarning = true;
		end;
		
		if (Clockwork.Client.EpilepsyWarning) then
			draw.SimpleText("[EPILEPSY WARNING]", introTextSmallFont, ScrW() * 0.5, ScrH() * 0.5, Color(170, 0, 0), 1, 1);
		else
			draw.SimpleText("BEGOTTEN PRESENTS...", introTextSmallFont, ScrW() * 0.5, ScrH() * 0.5, Color(170, 0, 0), 1, 1);
		end;
	elseif (self.DataStreamedAlpha) then
		self.DataStreamedAlpha = 0;
		
		if (self.DataStreamedAlpha <= 0) then
			self.DataStreamedAlpha = nil;
		end;
	end;
	
	if (netvars.GetNetVar("NoMySQL") and netvars.GetNetVar("NoMySQL") != "") then
		draw.SimpleText(netvars.GetNetVar("NoMySQL"), introTextSmallFont, scrW / 2, scrH / 2, Color(179, 46, 49, 255), 1, 1)
	elseif (self.DataStreamedAlpha and self.DataStreamedAlpha > 0) then
		local textString = "Please wait while Begotten III initializes.";
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, self.DataStreamedAlpha));
		draw.SimpleText(textString, introTextSmallFont, scrW / 2, scrH / 2, Color(170, 0, 0, self.DataStreamedAlpha), 1, 1);
		bDrawPendingScreenBlack = nil;
	end;

	if (bDrawPendingScreenBlack) then
		Clockwork.kernel:DrawTexturedGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, 255));
	end;

	hook.Run("PostDrawBackgroundBlurs");
end;

-- Called when the score board should be drawn.
--[[function GM:HUDDrawScoreBoard()
	self.BaseClass:HUDDrawScoreBoard(player)

	local drawPendingScreenBlack = nil
	local drawCharacterLoading = nil
	local hasClientInitialized = Clockwork.Client:HasInitialized()
	local introTextSmallFont = Clockwork.option:GetFont("intro_text_small")
	local colorWhite = Clockwork.option:GetColor("white")
	local curTime = UnPredictedCurTime()
	local scrH = ScrH()
	local scrW = ScrW()

	if (Clockwork.kernel:IsChoosingCharacter()) then
		if (hook.Run("ShouldDrawCharacterBackground")) then
			Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, 255))
		end

		hook.Run("HUDPaintCharacterSelection")
	elseif (!hasClientInitialized) then
		if (!Clockwork.HasCharacterMenuBeenVisible and hook.Run("ShouldDrawCharacterBackground")) then
			drawPendingScreenBlack = true
		end
	end

	if (hasClientInitialized) then
		if (!Clockwork.LastChatBoxCheck) then
			local loadingTime = hook.Run("GetCharacterLoadingTime")
			Clockwork.CharacterLoadingDelay = loadingTime
			Clockwork.LastChatBoxCheck = curTime + loadingTime
		end

		if (!Clockwork.kernel:IsChoosingCharacter()) then
			Clockwork.kernel:CalculateScreenFading()

			if (!Clockwork.kernel:IsUsingCamera()) then
				hook.Run("HUDPaintForeground")
			end

			hook.Run("HUDPaintImportant")
		end

		if (Clockwork.LastChatBoxCheck > curTime) then
			drawCharacterLoading = true
		elseif (!Clockwork.CinematicScreenDone) then
			Clockwork.kernel:DrawCinematicIntro(curTime)
			Clockwork.kernel:DrawCinematicIntroBars()
		end
	end

	if (hook.Run("ShouldDrawBackgroundBlurs")) then
		Clockwork.kernel:DrawBackgroundBlurs()
	end

	if (!Clockwork.player:HasDataStreamed()) then
		if (!Clockwork.DataStreamedAlpha) then
			Clockwork.DataStreamedAlpha = 255
		end
	elseif (Clockwork.DataStreamedAlpha) then
		Clockwork.DataStreamedAlpha = math.Approach(Clockwork.DataStreamedAlpha, 0, FrameTime() * 100)

		if (Clockwork.DataStreamedAlpha <= 0) then
			Clockwork.DataStreamedAlpha = nil
		end
	end

	if (Clockwork.ClockworkIntroFadeOut) then
		local duration = 8
		local introImage = Clockwork.option:GetKey("intro_image")

		if (introImage != "") then
			duration = 16
		end

		local timeLeft = math.Clamp(Clockwork.ClockworkIntroFadeOut - curTime, 0, duration)
		local material = Clockwork.ClockworkIntroOverrideImage or Clockwork.ClockworkSplash
		local sineWave = math.sin(curTime)
		local height = 256
		local width = 512;
		local alpha = 384

		if (!Clockwork.ClockworkIntroOverrideImage) then
			if (introImage != "" and timeLeft <= 8) then
				Clockwork.ClockworkIntroWhiteScreen = curTime + (FrameTime() * 8)
				Clockwork.ClockworkIntroOverrideImage = Clockwork.kernel:GetMaterial(introImage..".png")
				surface.PlaySound("buttons/combine_button5.wav")
			end
		end

		if (timeLeft <= 3) then
			alpha = (255 / 3) * timeLeft
		end

		if (timeLeft == 0) then
			Clockwork.ClockworkIntroFadeOut = nil
			Clockwork.ClockworkIntroOverrideImage = nil
		end

		if (sineWave > 0) then
			width = width - (sineWave * 16)
			height = height - (sineWave * 4)
		end

		if (curTime <= Clockwork.ClockworkIntroWhiteScreen) then
			Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(255, 255, 255, alpha))
		else
			local x, y = (scrW / 2) - (width / 2), (scrH * 0.3) - (height / 2)

			Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, alpha))
			Clockwork.kernel:DrawGradient(
				GRADIENT_CENTER, 0, y - 8, scrW, height + 16, Color(100, 100, 100, math.min(alpha, 150))
			)

			material:SetFloat("$alpha", alpha / 255)

			surface.SetDrawColor(255, 255, 255, alpha)
				surface.SetMaterial(material)
			surface.DrawTexturedRect(x, y, width, height)
		end

		drawPendingScreenBlack = nil
	end

	if (netvars.GetNetVar("NoMySQL") and netvars.GetNetVar("NoMySQL") != "") then
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, 255))
		draw.SimpleText(netvars.GetNetVar("NoMySQL"), introTextSmallFont, scrW / 2, scrH / 2, Color(179, 46, 49, 255), 1, 1)
	elseif (Clockwork.DataStreamedAlpha and Clockwork.DataStreamedAlpha > 0) then
		local textString = "LOADING..."

		if (_file.Exists("materials/clockwork/logo/002.png", "GAME")) then
			surface.SetDrawColor(255, 255, 255, Clockwork.DataStreamedAlpha)
			surface.SetMaterial(Clockwork.kernel:GetMaterial("materials/clockwork/logo/002.png"))
			surface.DrawTexturedRect(scrW / 2 - 1, scrH / 2 - 1, 2, 2)
		end

		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, Clockwork.DataStreamedAlpha))
		draw.SimpleText(textString, introTextSmallFont, scrW / 2, scrH * 0.75, Color(colorWhite.r, colorWhite.g, colorWhite.b, Clockwork.DataStreamedAlpha), 1, 1)

		drawPendingScreenBlack = nil
	end

	if (drawCharacterLoading) then
		hook.Run("HUDPaintCharacterLoading", math.Clamp((255 / Clockwork.CharacterLoadingDelay) * (Clockwork.LastChatBoxCheck - curTime), 0, 255))
	elseif (drawPendingScreenBlack) then
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, 255))
	end

	if (Clockwork.LastChatBoxCheck) then
		if (!Clockwork.CinematicInfoDrawn) then
			Clockwork.kernel:DrawCinematicInfo()
		end

		if (!Clockwork.CinematicBarsDrawn) then
			Clockwork.kernel:DrawCinematicIntroBars()
		end
	end

	hook.Run("PostDrawBackgroundBlurs")
end--]]

-- Called when the background blurs should be drawn.
function GM:ShouldDrawBackgroundBlurs()
	return true
end

-- Called just after the background blurs have been drawn.
function GM:PostDrawBackgroundBlurs()
	local introTextSmallFont = Clockwork.option:GetFont("intro_text_small")	
	local backgroundColor = Clockwork.option:GetColor("background")
	local colorWhite = Clockwork.option:GetColor("white")
	local panelInfo = Clockwork.CurrentFactionSelected
	local menuPanel = Clockwork.kernel:GetRecogniseMenu()

	--[[if (panelInfo and IsValid(panelInfo[1]) and panelInfo[1]:IsVisible()) then
		local factionTable = Clockwork.faction:FindByID(panelInfo[2])

		if (factionTable and factionTable.material) then
			if (_file.Exists("materials/"..factionTable.material..".png", "GAME")) then
				if (!panelInfo[3]) then
					panelInfo[3] = Clockwork.kernel:GetMaterial(factionTable.material..".png")
				end

				if (Clockwork.kernel:IsCharacterScreenOpen(true)) then
					surface.SetDrawColor(255, 255, 255, panelInfo[1]:GetAlpha())
					surface.SetMaterial(panelInfo[3])
					surface.DrawTexturedRect(panelInfo[1].x, panelInfo[1].y + panelInfo[1]:GetTall() + 16, 512, 256)
				end
			end
		end
	end]]--

	if (Clockwork.TitledMenu and IsValid(Clockwork.TitledMenu.menuPanel)) then
		local menuTextTiny = Clockwork.option:GetFont("menu_text_tiny")
		local menuPanel = Clockwork.TitledMenu.menuPanel
		local menuTitle = Clockwork.TitledMenu.title or ""

		Clockwork.kernel:DrawSimpleGradientBox(2, menuPanel.x - 4, menuPanel.y - 4, menuPanel:GetWide() + 8, menuPanel:GetTall() + 8, backgroundColor)
		Clockwork.kernel:OverrideMainFont(menuTextTiny)
			Clockwork.kernel:DrawInfo(menuTitle, menuPanel.x, menuPanel.y, colorWhite, 255, true, function(x, y, width, height)
				return x, y - height - 4
			end)
		Clockwork.kernel:OverrideMainFont(false)
	end
end

-- Called just before a bar is drawn.
function GM:PreDrawBar(barInfo) end

-- Called just after a bar is drawn.
function GM:PostDrawBar(barInfo) end

-- Called when the top bars are needed.
function GM:GetBars(bars) end

-- Called when the top bars should be destroyed.
function GM:DestroyBars(bars) end

-- Called when the cinematic intro info is needed.
function GM:GetCinematicIntroInfo()
	return {
		credits = "A roleplaying game designed by "..Schema:GetAuthor()..".",
		title = Schema:GetName(),
		text = Schema:GetDescription()
	}
end

-- Called when the character loading time is needed.
function GM:GetCharacterLoadingTime() return 8; end

-- Called when a player's HUD should be painted.
function GM:HUDPaintPlayer(player) end

-- Called when the HUD should be painted.
function GM:HUDPaint()
	if (!Clockwork.kernel:IsChoosingCharacter() and !Clockwork.kernel:IsUsingCamera()) then
		if (Clockwork.Client:Alive()) then
			local maxHealth = Clockwork.Client:GetMaxHealth()
			local health = Clockwork.Client:Health()

			if (health < maxHealth * 0.5) then
				--plugin.Call("DrawPlayerScreenDamage", 1 - ((1 / maxHealth) * health))
				hook.Run("DrawPlayerScreenDamage", 1 - ((1 / maxHealth) * health))
			end
		end

		if (config.GetVal("enable_vignette") --[[and Clockwork.ConVars.VIGNETTE:GetInt() == 1]]) then
			hook.Run("DrawPlayerVignette")
		end

		self.BaseClass:HUDPaint()

		if (!Clockwork.kernel:IsUsingTool()) then
			Clockwork.kernel:DrawHints()
		end

		local weapon = Clockwork.Client:GetActiveWeapon()

		if (hook.Run("CanDrawCrosshair", weapon)) then
			local info = {
				color = Color(255, 255, 255, 255),
				x = ScrW() / 2,
				y = ScrH() / 2
			}

			hook.Run("GetPlayerCrosshairInfo", info)

			Clockwork.CustomCrosshair = hook.Run("DrawPlayerCrosshair", info.x, info.y, info.color)
		else
			Clockwork.CustomCrosshair = false
		end
	end
end

function GM:CanDrawCrosshair(weapon)
	if IsValid(weapon) then
		local class = weapon:GetClass();

		if (class:find("gmod_") or class == "weapon_physgun") then
			return true
		else
			return false
		end
	end
end

-- Called when the local player's crosshair info is needed.
function GM:GetPlayerCrosshairInfo(info)
	if (config.GetVal("use_free_aiming")) then
		-- Thanks to BlackOps7799 for this open source example.

		local traceLine = util.TraceLine({
			start = Clockwork.Client:EyePos(),
			endpos = Clockwork.Client:EyePos() + (Clockwork.Client:GetAimVector() * 1024 * 1024),
			filter = Clockwork.Client
		})

		local screenPos = traceLine.HitPos:ToScreen()

		info.x = screenPos.x
		info.y = screenPos.y
	end
end

-- Called when the local player's crosshair should be drawn.
function GM:DrawPlayerCrosshair(x, y, color)
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.DrawRect(x, y, 2, 2)
	surface.DrawRect(x, y + 9, 2, 2)
	surface.DrawRect(x, y - 9, 2, 2)
	surface.DrawRect(x + 9, y, 2, 2)
	surface.DrawRect(x - 9, y, 2, 2)

	return true
end

-- Called when a player starts using voice.
--[[function GM:PlayerStartVoice(player)
	if (config.Get("local_voice"):Get()) then
		if (player:GetRagdollState() == RAGDOLL_KNOCKEDOUT or !player:Alive()) then
			return
		end
	end

	if (self.BaseClass and self.BaseClass.PlayerStartVoice) then
		self.BaseClass:PlayerStartVoice(player)
	end
end]]--

-- Called to check if a player does have an flag.
function GM:PlayerDoesHaveFlag(player, flag)
	if (string.find(config.GetVal("default_flags"), flag)) then
		return true
	end
end

-- Called to check if a player does recognise another player.
function GM:PlayerDoesRecognisePlayer(player, status, isAccurate, realValue)
	--[[if player:GetNetVar("faceConcealed") then
		return false;
	end]]--
	
	return realValue
end

-- Called when a player's name should be shown as unrecognised.
function GM:PlayerCanShowUnrecognised(player, x, y, color, alpha, flashAlpha)
	--[[if player:GetNetVar("faceConcealed") then
		return "This character's face is concealed.";
	end]]--
	
	return true
end

-- Called when a player begins typing.
function GM:StartChat(team)
	return true
end

-- Called when a player says something.
function GM:OnPlayerChat(player, text, teamOnly, playerIsDead)
	if (IsValid(player)) then
		Clockwork.chatBox:Decode(player, player:Name(), text, {}, "none");
	else
		Clockwork.chatBox:Decode(nil, "Console", text, {}, "chat");
	end;
	
	return true;
end;

-- Called when chat text is received from the server
function GM:ChatText(index, name, text, class)
	if (class == "none") then
		Clockwork.chatBox:Decode(_player.GetByID(index), name, text, {}, "none");
	end;
	
	return true;
end;

-- Called when the scoreboard should be created.
function GM:CreateScoreboard() end

-- Called when the scoreboard should be shown.
function GM:ScoreboardShow()
	if (--[[input.IsKeyDown(KEY_TAB) and ]]Clockwork.Client:HasInitialized()) then
		if (hook.Run("CanShowTabMenu")) then
			Clockwork.menu:Create()
			Clockwork.menu:SetOpen(true)
			Clockwork.menu.holdTime = UnPredictedCurTime() + 0.5
		end
	end
end

-- Called when the scoreboard should be hidden.
function GM:ScoreboardHide()
	if (Clockwork.Client:HasInitialized() and Clockwork.menu.holdTime) then
		if (UnPredictedCurTime() >= Clockwork.menu.holdTime) then
			if (hook.Run("CanShowTabMenu")) then
				Clockwork.menu:SetOpen(false)
			end
		end
	end
end

-- Called before the tab menu is shown.
function GM:CanShowTabMenu()
	if Clockwork.Client.LoadingText or Clockwork.Client.possessor or Clockwork.Client.victim then
		return false;
	end
	
	return true 
 end

-- Overriding Garry's "grab ear" animation.
function GM:GrabEarAnimation(player) end

-- Called before the item entity's target ID is drawn. Return false to stop default draw.
function GM:PaintItemTargetID(x, y, alpha, itemTable) return true end

function GM:OnHookError(name, isGM, message)
	LocalPlayer().ErrorBoxTime = CurTime() + 3
end

function GM:get_tabmenu_pos()
	return 200, Clockwork.bars.y + 32
end
