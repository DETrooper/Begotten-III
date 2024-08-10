--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local UnPredictedCurTime = UnPredictedCurTime;
local RunConsoleCommand = RunConsoleCommand;
local Material = Material;
local IsValid = IsValid;
local unpack = unpack;
local Color = Color;
local pairs = pairs;
local type = type;
local ScrH = ScrH;
local ScrW = ScrW;
local surface = surface;
local string = string;
local input = input;
local table = table;
local hook = hook;
local math = math;
local vgui = vgui;

library.New("chatBox", Clockwork)

Clockwork.chatBox.classes = Clockwork.chatBox.classes or {};
Clockwork.chatBox.defaultClasses = Clockwork.chatBox.defaultClasses or {}
Clockwork.chatBox.messages = Clockwork.chatBox.messages or {};
Clockwork.chatBox.historyPos = Clockwork.chatBox.historyPos or 0;
Clockwork.chatBox.historyMsgs = Clockwork.chatBox.historyMsgs or {};
Clockwork.chatBox.spaceWidths = Clockwork.chatBox.spaceWidths or {};

if (!chat.ClockworkAddText) then
	chat.ClockworkAddText = chat.AddText;
end;

-- A function to add text to the chat box.
function chat.AddText(...)
	local curColor = nil;
	local text = {};
	
	for k, v in pairs({...}) do
		if (type(v) == "Player") then
			text[#text + 1] = Clockwork.kernel:PlayerNameColor(v);
			text[#text + 1] = v:Name();
		elseif (type(v) == "table") then
			curColor = v;
		elseif (curColor) then
			text[#text + 1] = curColor;
			text[#text + 1] = v;
		else
			text[#text + 1] = v;
		end;
	end;

	Clockwork.chatBox:Add(nil, nil, unpack(text));
end;

-- A function to register a chat box class.
function Clockwork.chatBox:RegisterClass(class, filter, Callback)
	self.classes[class] = {
		Callback = Callback,
		filter = filter
	};
end;

-- A function to register a default chat box class.
function Clockwork.chatBox:RegisterDefaultClass(class, filter, Callback)
	self.defaultClasses[class] = {
		Callback = Callback,
		filter = filter
	};
end;

-- A function to get all the registered types of text, returns default ones or not based on bool argument.
function Clockwork.chatBox:GetClasses(bDefault)
	if (bDefault) then
		return self.defaultClasses;
	else
		return self.classes;
	end;
end;

-- A function to get a chatbox class by identifier to modify.
function Clockwork.chatBox:FindByID(id)
	return self:GetClasses()[id] or self:GetClasses(true)[id];
end;

-- A function to set the chat box's custom position.
function Clockwork.chatBox:SetCustomPosition(x, y)
	self.position = {
		x = x,
		y = y
	};
end;

-- A function to get the chat box's custom position.
function Clockwork.chatBox:GetCustomPosition()
	return self.position or {};
end;

-- A function to reset the chat box's custom position.
function Clockwork.chatBox:ResetCustomPosition()
	self.position = nil;
end;

-- A function to get the position of the chat area.
function Clockwork.chatBox:GetPosition(addX, addY)
	local customPosition = self:GetCustomPosition();
	local scrH = ScrH();
	local x = 8;
	--local y = ScrH() - 40;
	local y = scrH - math.Round(scrH / 27); -- This is better for non-1080p resolutions - DETrooper

	if (customPosition.x) then
		x = customPosition.x;
	end;

	if (customPosition.y) then
		y = customPosition.y;
	end;

	return x + (addX or 0), y + (addY or 0);
end;

-- A function to get the chat box panel.
function Clockwork.chatBox:GetPanel()
	if (IsValid(self.panel)) then
		return self.panel;
	end;
end;

-- A function to get the x position of the chat area.
function Clockwork.chatBox:GetX()
	local x, y = Clockwork.chatBox:GetPosition();
	return x;
end;

-- A function to get the y position of the chat area.
function Clockwork.chatBox:GetY()
	local x, y = Clockwork.chatBox:GetPosition();
	return y;
end;

-- A function to get the current text.
function Clockwork.chatBox:GetCurrentText()
	local textEntry = self.textEntry;
	
	if (textEntry:IsVisible() and Clockwork.chatBox:IsOpen()) then
		return textEntry:GetValue();
	else
		return "";
	end;
end;

-- A function to get whether the player is typing a command.
function Clockwork.chatBox:IsTypingCommand()
	local currentText = Clockwork.chatBox:GetCurrentText();
	local prefix = config.Get("command_prefix"):Get();

	if (string.find(currentText, prefix) == 1) then
		return true;
	end;

	return false;
end;

-- A function to get the spacing between messages.
function Clockwork.chatBox:GetSpacing(fontName)
	local chatBoxTextFont = fontName or Clockwork.option:GetFont("chat_box_text");
	local textWidth, textHeight = Clockwork.kernel:GetCachedTextSize(chatBoxTextFont, "U");
	
	if (textWidth and textHeight) then
		return textHeight + 4;
	end;
end;

-- A function to create all of the derma.
function Clockwork.chatBox:CreateDermaAll()
	Clockwork.chatBox:CreateDermaPanel();
	Clockwork.chatBox:CreateDermaTextEntry();

	self.panel:Hide();
end;

-- A function to create a derma text entry.
function Clockwork.chatBox:CreateDermaTextEntry()
	if (Clockwork.Client.OptionMenuOpen) then
		return;
	end;
	
	if (!self.textEntry) then
		self.textEntry = vgui.Create("DTextEntry", self.panel);
		self.textEntry:SetPos(34, 4);
		self.textEntry:SetTabPosition(1);
		self.textEntry:SetAllowNonAsciiCharacters(true);
		
		-- Called each frame.
		self.textEntry.Think = function(textEntry)
			local maxChatLength = config.Get("max_chat_length"):Get();
			local text = textEntry:GetValue();
			
			if (text and text != "") then
				if (string.utf8len(text) > maxChatLength) then
					textEntry:SetRealValue(string.utf8sub(text, 0, maxChatLength));
					Clockwork.option:PlaySound("tick");
				elseif (self:IsOpen()) then
					if (text != textEntry.previousText) then
						hook.Run("ChatBoxTextChanged", textEntry.previousText or "", text);
					end;
				end;
			end;
			
			textEntry.previousText = text;
		end;
		
		-- Called when enter has been pressed.
		self.textEntry.OnEnter = function(textEntry)
			local text = textEntry:GetValue();
			
			if (text and text != "") then
				self.historyPos = #self.historyMsgs;

				netstream.Start("PlayerSay", text);
				
				ChatBoxTextTyped(text);
				textEntry:SetRealValue("");
			end;
			
			if (text and text != "") then
				self.panel:Hide(true);
			else
				self.panel:Hide();
			end;
		end;
		
		-- A function to set the text entry's real value.
		self.textEntry.SetRealValue = function(textEntry, text, limit)
			textEntry:SetText(text);
			
			if (text and text != "") then
				if (limit) then
					if (textEntry:GetCaretPos() > string.utf8len(text)) then
						textEntry:SetCaretPos(string.utf8len(text));
					end;
				else
					textEntry:SetCaretPos(string.utf8len(text));
				end;
			end;
		end;
		
		-- Called when a key code has been typed.
		self.textEntry.OnKeyCodeTyped = function(textEntry, code)
			if (code == KEY_ENTER and !textEntry:IsMultiline() and textEntry:GetEnterAllowed()) then
				textEntry:FocusNext();
				textEntry:OnEnter();
			elseif (code == KEY_TAB) then
				local text = textEntry:GetValue();
				local prefix = config.Get("command_prefix"):Get();
				
				if (string.utf8sub(text, 1, string.utf8len(prefix)) == prefix) then
					local exploded = string.Explode(" ", text);
					
					if (!exploded[2]) then
						local commands = Clockwork.kernel:GetSortedCommands();
						local bUseNext = false;
						local firstCmd = nil;
						local command = string.utf8sub(exploded[1], string.utf8len(prefix) + 1);
						
						command = string.lower(command);
						
						for k, v in pairs(commands) do
							v = string.lower(v);
							
							if (!firstCmd) then
								firstCmd = v;
							end;
							
							if ((string.utf8len(command) < string.utf8len(v)
							and string.find(v, command) == 1) or bUseNext) then
								textEntry:SetRealValue(prefix..v);
								return;
							elseif (v == string.lower(command)) then
								bUseNext = true;
							end
						end
						
						if (bUseNext and firstCmd) then
							textEntry:SetRealValue(prefix..firstCmd);
							return;
						end
					end;
				end;
				
				text = hook.Run("OnChatTab", text);
				
				if (text and type(text) == "string") then
					textEntry:SetRealValue(text)
				end;
			else
				local text = ChatBoxKeyCodeTyped(code, textEntry:GetValue())
				
				if (text and type(text) == "string") then
					textEntry:SetRealValue(text)
				end;
			end;
		end;
	end;
end;

-- A function to create the derma panel.
function Clockwork.chatBox:CreateDermaPanel()
	if (Clockwork.Client.OptionMenuOpen) then
		return;
	end;
	
	if (!self.panel) then
		self.panel = vgui.Create("EditablePanel");
		
		-- A function to show the chat panel.
		self.panel.Show = function(editablePanel)
			editablePanel:SetKeyboardInputEnabled(true);
			editablePanel:SetMouseInputEnabled(true);
			editablePanel:SetVisible(true);
			editablePanel:MakePopup();
			
			self.textEntry:RequestFocus();
			self.scroll:SetVisible(true);
			self.historyPos = #self.historyMsgs;
			
			if (IsValid(Clockwork.Client)) then
				hook.Run("ChatBoxOpened");
			end;
		end;
		
		-- A function to hide the chat panel.
		self.panel.Hide = function(editablePanel, textTyped)
			editablePanel:SetKeyboardInputEnabled(false);
			editablePanel:SetMouseInputEnabled(false);
			editablePanel:SetVisible(false);
			
			self.textEntry:SetText("");
			self.scroll:SetVisible(false);
			
			if (IsValid(Clockwork.Client)) then
				hook.Run("ChatBoxClosed", textTyped);
			end;
		end;
		
		-- Called each time the panel should be painted.
		self.panel.Paint = function(editablePanel)
			Clockwork.kernel:DrawSimpleGradientBox(2, 0, 0, editablePanel:GetWide(), editablePanel:GetTall(), Clockwork.option:GetColor("background"));
		end;
		
		-- Called every frame.
		self.panel.Think = function(editablePanel)
			local panelWidth = ScrW() / 4;
			local x, y = self:GetPosition();
			
			editablePanel:SetPos(x, y + 6);
			editablePanel:SetSize(panelWidth + 8, 24);
			self.textEntry:SetPos(4, 4);
			self.textEntry:SetSize(panelWidth, 16);
			
			if (editablePanel:IsVisible() and input.IsKeyDown(KEY_ESCAPE)) then
				editablePanel:Hide();
			end;
		end;
		
		self.scroll = vgui.Create("Panel");
		self.scroll:SetPos(0, 0);
		self.scroll:SetSize(0, 0);
		self.scroll:SetMouseInputEnabled(true);
		
		-- Called when the panel is scrolled with the mouse wheel.
		self.scroll.OnMouseWheeled = function(panel, delta)
			local bIsOpen = self:IsOpen();
			--local maximumLines = math.Clamp(Clockwork.ConVars.MAXCHATLINES:GetInt(), 1, 10);
			local maximumLines = 10;
			
			if (bIsOpen) then
				if (delta > 0) then
					delta = math.Clamp(delta, 1, maximumLines);
					
					if (self.historyMsgs[self.historyPos - maximumLines]) then
						self.historyPos = self.historyPos - delta;
					end;
				else
					if (!self.historyMsgs[self.historyPos - delta]) then
						delta = -1;
					end;
					
					if (self.historyMsgs[self.historyPos - delta]) then
						self.historyPos = self.historyPos - delta;
					end;
				end;
			end;
		end;
	end;
end;

-- A function to get whether the chat box is open.
function Clockwork.chatBox:IsOpen()
	return self.panel and self.panel:IsVisible();
end;

-- A function to decode a message.
function Clockwork.chatBox:Decode(speaker, name, text, data, class, multiplier)
	local filtered = nil;
	local filter = nil;
	local icon = nil;
	
	if (!IsValid(Clockwork.Client)) then
		return;
	end;
	
	if (self.classes[class]) then
		filter = self.classes[class].filter;
	elseif (self.defaultClasses[class]) then
		filter = self.defaultClasses[class].filter;
	end;

	--[[if (filter == "ic") then
		filtered = (Clockwork.ConVars.SHOWIC:GetInt() == 0);
	else
		filtered = (Clockwork.ConVars.SHOWOOC:GetInt() == 0);
	end;]]--
	
	if (isstring(text)) then
		text = Clockwork.kernel:Replace(text, " ' ", "'");
	end;
	
	if (IsValid(speaker)) then
		if (!Clockwork.kernel:IsChoosingCharacter() and !Clockwork.Client.LoadingText) then
			if (speaker:Name() != "") then
				local unrecognised = false;
				local focusedOn = false;
				local fontOverride;
				
				icon = speaker:GetChatIcon();
				
				if (!Clockwork.player:DoesRecognise(speaker, RECOGNISE_TOTAL) and filter == "ic") then
					unrecognised = true;
				end;
				
				local trace = Clockwork.player:GetRealTrace(Clockwork.Client);
				
				if (trace and trace.Entity and IsValid(trace.Entity) and trace.Entity == speaker) then
					focusedOn = true;
				end;
				
				local faction = speaker:GetSharedVar("kinisgerOverride") or speaker:GetFaction();

				if speaker:GetSharedVar("beliefFont") == "Voltism" then
					fontOverride = "Voltism";
				elseif faction == "Goreic Warrior" then
					fontOverride = "Gore";
				end
				
				local info = {
					unrecognised = unrecognised,
					shouldHear = Clockwork.player:CanHearPlayer(Clockwork.Client, speaker),
					multiplier = multiplier,
					focusedOn = focusedOn,
					filtered = filtered,
					speaker = speaker,
					visible = true;
					filter = filter,
					class = class,
					icon = icon,
					name = name,
					text = text,
					font = fontOverride,
					data = data
				};
				
				hook.Run("ChatBoxAdjustInfo", info);

				if (config.Get("chat_multiplier"):Get()) then
					Clockwork.chatBox:SetMultiplier(info.multiplier);
				end;
				
				if (info.visible) then
					if (info.filter == "ic") then
						if (!Clockwork.Client:Alive() and Clockwork.Client:GetMoveType() ~= MOVETYPE_NOCLIP) then
							return;
						end;
					end;
					
					if (info.unrecognised) then
						local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(info.speaker);
						
						if (usedPhysDesc and string.utf8len(unrecognisedName) > 24) then
							unrecognisedName = string.utf8sub(unrecognisedName, 1, 21).."...";
						end;
						
						info.name = "["..unrecognisedName.."]";
					end;
					
					if (self.classes[info.class]) then
						self.classes[info.class].Callback(info);
					elseif (self.defaultClasses[info.class]) then
						self.defaultClasses[info.class].Callback(info);					
					end;
				end;
			end;
		end;
	else
		if (name == "Console" and class == "chat") then
			icon = "icon16/shield.png";
		end;
		
		local info = {
			multiplier = multiplier,
			filtered = filtered,
			visible = true;
			filter = filter,
			class = class,
			icon = icon,
			name = name,
			text = text,
			data = data
		};
		
		hook.Run("ChatBoxAdjustInfo", info);
		Clockwork.chatBox:SetMultiplier(info.multiplier);
		
		if (!info.visible) then return; end;
		
		if (self.classes[info.class]) then
			self.classes[info.class].Callback(info);
		elseif (self.defaultClasses[info.class]) then
			self.defaultClasses[info.class].Callback(info);		
		else
			local yellowColor = Color(255, 255, 150, 255);
			local filtered = --[[(Clockwork.ConVars.SHOWSERVER:GetInt() == 0) or]]info.filtered;
			
			Clockwork.chatBox:Add(filtered, nil, yellowColor, info.text);
		end;
	end;
end;

-- A function to add and wrap text to a message.
function Clockwork.chatBox:WrappedText(newLine, message, color, text, OnHover)
	local chatBoxTextFont = Clockwork.option:GetFont("chat_box_text");
	local width, height = Clockwork.kernel:GetTextSize(chatBoxTextFont, text);
	local maximumWidth = ScrW() * 0.6;
	
	if (width > maximumWidth) then
		local currentWidth = 0;
		local firstText = nil;
		local secondText = nil;
		
		for i = 0, #text do
			local currentCharacter = string.utf8sub(text, i, i);
			local currentSingleWidth = Clockwork.kernel:GetTextSize(chatBoxTextFont, currentCharacter);
			
			if ((currentWidth + currentSingleWidth) >= maximumWidth) then
				secondText = string.utf8sub(text, i);
				firstText = string.utf8sub(text, 0, (i - 1));
				
				break;
			else
				currentWidth = currentWidth + currentSingleWidth;
			end;
		end;
		
		if (firstText and firstText != "") then
			Clockwork.chatBox:WrappedText(true, message, color, firstText, OnHover);
		end;
		
		if (secondText and secondText != "") then
			Clockwork.chatBox:WrappedText(nil, message, color, secondText, OnHover);
		end;
	else
		message.text[#message.text + 1] = {
			newLine = newLine,
			OnHover = OnHover,
			height = height,
			width = width,
			color = color,
			text = text
		};
		
		if (newLine) then
			message.lines = message.lines + 1;
		end;
	end;
end;

-- A function to paint the chat box.
function Clockwork.chatBox:Paint()
	if (Clockwork.Client.OptionMenuOpen) then
		return;
	end;
	
	local chatBoxSyntaxFont = Clockwork.option:GetFont("chat_box_syntax");
	local chatBoxTextFont = Clockwork.option:GetFont("chat_box_text");
	local chatBoxTextGoreFont = Clockwork.option:GetFont("chat_box_text_gore");
	local chatBoxTextVoltistFont = Clockwork.option:GetFont("chat_box_text_voltist");
	local bIsOpen = Clockwork.chatBox:IsOpen();
--[[
	if (bIsOpen) then
		local backgroundColor = Clockwork.option:GetColor("background");
		local panelHeight = self.scroll:GetTall();
		local panelWidth = self.scroll:GetWide();
		local cornerSize = 4;
		local panelY = ScrH() * 0.72962963--self.scroll.y;
		local panelX = self.scroll.x;
	--	print(panelY);
		local maxWidth = ScrW() * 0.5;
		--self.textEntry:GetWide()
		local maxHeight = ScrW() / 7.5;
		--print(panelHeight)
		
		--if (panelWidth > 8 or panelHeight > 8) then
			local maxw = ScrW() - 16;
			local otw = maxw - maxWidth 
			local otx = panelX + maxWidth;
			--Clockwork.kernel:DrawSimpleGradientBox(0, panelX, panelY, maxWidth, maxHeight, Color(0, 0, 255));
			surface.SetMaterial(Material("begotten/ui/icos.png"));
			surface.SetDrawColor(255, 255, 255);
			surface.DrawTexturedRect(panelX, panelY, maxWidth, maxHeight)
			Clockwork.kernel:DrawSimpleGradientBox(0, otx, panelY, otw, maxHeight, Color(0, 255, 0));
			local sexheight = (ScrH() - (panelY + maxHeight + 8));
			--print(sexheight)
			local wi = self.textEntry:GetWide() + 8;
			local trawi = maxw - (wi) - 4
			local trax = panelX + wi + 4;
			draw.RoundedBox(0, panelX, panelY + (maxHeight), maxw, sexheight, Color(255, 255, 0, 255))
			draw.RoundedBox(0, trax, panelY + (maxHeight), trawi, sexheight, Color(255, 0, 150))
	--	end;
	end;
	
-]]
	Clockwork.kernel:OverrideMainFont(chatBoxTextFont);
	
	if (!self.spaceWidths[chatBoxTextFont]) then
		self.spaceWidths[chatBoxTextFont] = Clockwork.kernel:GetTextSize(chatBoxTextFont, " ");
	end;
	
	local bIsTypingCommand = Clockwork.chatBox:IsTypingCommand();
	local chatBoxSpacing = Clockwork.chatBox:GetSpacing();
	--local maximumLines = math.Clamp(Clockwork.ConVars.MAXCHATLINES:GetInt(), 1, 10);
	local maximumLines = 10;
	local origX, origY = Clockwork.chatBox:GetPosition(4);
	local onHoverData = nil;
	local spaceWidth = self.spaceWidths[chatBoxTextFont];
	local fontHeight = chatBoxSpacing - 4;
	local messages = self.messages;
	local x, y = origX, origY;
	local box = {width = 0, height = 0};

	if (!bIsOpen) then
		if (#self.historyMsgs > 100) then
			local amount = #self.historyMsgs - 100;
			
			for i = 1, amount do
				table.remove(self.historyMsgs, 1);
			end;
		end;
	else
		messages = {};
		
		for i = 0, (maximumLines - 1) do
			messages[#messages + 1] = self.historyMsgs[self.historyPos - i];
		end;
	end;
	
	for k, v in pairs(messages) do
		local fontName = Clockwork.fonts:GetMultiplied(chatBoxTextFont, v.multiplier or 1);

		if v.font then
			if v.font == "Voltism" then
				fontName = Clockwork.fonts:GetMultiplied(chatBoxTextVoltistFont, v.multiplier or 1)
			elseif v.font == "Gore" then
				fontName = Clockwork.fonts:GetMultiplied(chatBoxTextGoreFont, v.multiplier or 1)
			end
		end
		
		Clockwork.kernel:OverrideMainFont(fontName);
		
		if (!self.spaceWidths[fontName]) then
			self.spaceWidths[fontName] = Clockwork.kernel:GetTextSize(fontName, " ");
		end;

		chatBoxSpacing = Clockwork.chatBox:GetSpacing(fontName);
		spaceWidth = self.spaceWidths[fontName];
		
		if (messages[k - 1]) then
			y = y - messages[k - 1].spacing;
		end;
		
		if (!bIsOpen and k == 1) then
			y = y - ((chatBoxSpacing + v.spacing) * (v.lines - 1)) + 14;
		else
			y = y - ((chatBoxSpacing + v.spacing) * v.lines);
			
			if (k == 1) then
				y = y + 2;
			end;
		end;

		local messageX = x;
		local messageY = y;
		local alpha = v.alpha;
		--messageX = messageX + 4
		
		if (bIsTypingCommand) then
			alpha = 10;
		elseif (bIsOpen) then
			alpha = 255;
		end;
		
		if (v.icon) then
			local messageIcon = Clockwork.kernel:GetMaterial(v.icon);
			local bFlag = false;
			
			if (string.find(v.icon, "flags16")) then
				bFlag = true;
			end;
			
			local width, height = 16, 16;
			
			if (bFlag) then
				width = width * 1.5;
			end;

			surface.SetMaterial(messageIcon);
			surface.SetDrawColor(255, 255, 255, alpha);
			surface.DrawTexturedRect(messageX, messageY + (fontHeight / 2) - 8, width, height);
			
			messageX = messageX + width + spaceWidth;
		end;
		
		local mouseX = gui.MouseX();
		local mouseY = gui.MouseY();
		
		for k2, v2 in pairs(v.text) do
			local textColor = Color(v2.color.r, v2.color.g, v2.color.b, alpha);
			local newLine = false;
			
			if (mouseX > messageX and mouseY > messageY
			and mouseX < messageX + v2.width
			and mouseY < messageY + v2.height) then
				if (v2.OnHover) then
					onHoverData = v2;
				end;
			end;
			
			Clockwork.kernel:DrawSimpleText(v2.text, messageX, messageY, textColor);
			messageX = messageX + v2.width;
			
			if (origY - y > box.height) then
				box.height = origY - y;
			end;
			
			if (messageX - 8 > box.width) then
				box.width = messageX - 8;
			end;
			
			if (v2.newLine) then
				messageY = messageY + chatBoxSpacing + v.spacing;
				messageX = origX;
			end;
		end;
	end;
	
	Clockwork.kernel:OverrideMainFont(false);
	
	if (bIsTypingCommand) then
		local colorInformation = Clockwork.option:GetColor("information");
		local currentText = Clockwork.chatBox:GetCurrentText();
		local colorWhite = Clockwork.option:GetColor("white");
		local splitTable = string.Explode(" ", string.utf8sub(currentText, 2));
		local commands = {};
		local oX, oY = origX, origY;
		local command = splitTable[1];
		local prefix = config.Get("command_prefix"):Get();
		
		if (command and command != "") then
			for k, v in pairs(Clockwork.command:GetAlias()) do
				local commandLen = string.utf8len(command);

				if (commandLen == 0) then
					commandLen = 1;
				end;

				if (string.utf8sub(k, 1, commandLen) == string.lower(command)
				and (!splitTable[2] or string.lower(command) == k)) then
					local cmdTable = Clockwork.command:FindByAlias(v);
 					
 					if (cmdTable and Clockwork.player:HasFlags(Clockwork.Client, cmdTable.access)) then
 						local bShouldAdd = true;
 
 						-- It can so happen that multiple alias for the same command begin with the same string.
 						-- We don't want to display the same command multiple times, so we check for that.
 						for k, v in pairs(commands) do
 							if (v == cmdTable) then
 								bShouldAdd = false;
 							end;
 						end;
 
 						if (bShouldAdd) then
 							commands[#commands + 1] = cmdTable;
 						end;
 					end;
				end;
				
				if (#commands == 8) then
					break;
				end;
			end;
			
			Clockwork.kernel:OverrideMainFont(chatBoxSyntaxFont);
			
			if (#commands > 0) then
				local bSingleCommand = (#commands == 1);
				
				for k, v in pairs(commands) do
					local totalText = prefix..v.name;
					
					if (bSingleCommand) then
						totalText = totalText.." "..v.text;
					end;
					
					local tWidth, tHeight = Clockwork.kernel:GetCachedTextSize(
						chatBoxSyntaxFont, totalText
					);
					
					if (k == 1) then
						oY = oY - tHeight;
					end;
					
					Clockwork.kernel:DrawSimpleText(prefix..v.name, oX, oY, colorInformation);
					
					if (bSingleCommand) then
						local pWidth = Clockwork.kernel:GetCachedTextSize(
							chatBoxSyntaxFont, prefix..v.name
						);
						
						if (v.tip and v.tip != "") then
							if (!v.wrappedTable) then
								local wrappedTable = {""};
									Clockwork.kernel:WrapTextSpaced(v.tip, chatBoxSyntaxFont, ScrW() * 0.8, wrappedTable)
								v.wrappedTable = wrappedTable;
								
								for k2, v2 in pairs (v.wrappedTable) do
									v.wrappedTable[k2] = string.Trim(v2);
								end;
							end;
							
							local infoColor = Clockwork.option:GetColor("information")
							local backgroundColor = Clockwork.option:GetColor("background")
							backgroundColor.a = 200;
							
							if (self.LastX and self.LastY and self.LastWidth and self.LastHeight) then
								Clockwork.kernel:DrawSimpleGradientBox(0, self.LastX, self.LastY, self.LastWidth, self.LastHeight, Color(0, 0, 0, 225))
								
								draw.RoundedBox(0, self.LastX, self.LastY, 2, self.LastHeight, backgroundColor);
								draw.RoundedBox(0, self.LastX + 2, self.LastY, self.LastWidth - 4, 2, backgroundColor);
								draw.RoundedBox(0, self.LastX + (self.LastWidth - 2), self.LastY, 2, self.LastHeight, backgroundColor);
								draw.RoundedBox(0, self.LastX + 2, self.LastY + (self.LastHeight - 2), self.LastWidth - 4, 2, backgroundColor);
							end;

							if (v.wrappedTable) then
								local lines = #v.wrappedTable;
								local originalY = ((oY - tHeight) - (lines * (tHeight))) - 16;

								for k2, v2 in pairs (v.wrappedTable) do
									Clockwork.kernel:DrawSimpleText(v2, oX + 8, originalY + (k2 * (tHeight + 4)), infoColor:Darken(0 + (k2 * 10)));
								end;
								
								local wrappedTableCopy = table.Copy(v.wrappedTable);

								table.sort(wrappedTableCopy, function(a, b)
									return string.len(a) > string.len(b);
								end);
								
								local width, height = Clockwork.kernel:GetCachedTextSize(chatBoxSyntaxFont, wrappedTableCopy[1]);
								
								self.LastWidth = width + 16;
								self.LastHeight = #v.wrappedTable * (tHeight + 4) + 4;
								self.LastX = oX;
								self.LastY = originalY + tHeight;
							else
								Clockwork.kernel:DrawSimpleText(v.tip, oX, oY - tHeight - 16, infoColor);
							end;
						end;
						
						Clockwork.kernel:DrawSimpleText(" "..v.text, oX + pWidth, oY, colorWhite);
					end;
					
					if (k < #commands) then oY = oY - tHeight; end;
					if (oY < y) then y = oY; end;
					
					if (origY - oY > box.height) then
						box.height = origY - oY;
					end;
					
					if (origX + tWidth - 8 > box.width) then
						box.width = origX + tWidth - 8;
					end;
				end;
			end;
			
			Clockwork.kernel:OverrideMainFont(false);
		end;
	end;
	
	self.scroll:SetSize(box.width + 8, box.height + 8);
	self.scroll:SetPos(x - 4, y - 4);
	
	if (onHoverData) then
		onHoverData.OnHover(onHoverData);
	end;
end;

-- A function to set the size (multiplier) of the next message.
function Clockwork.chatBox:SetMultiplier(multiplier)
	self.multiplier = multiplier;
end;

-- A function to add a message to the chat box.
function Clockwork.chatBox:Add(filtered, icon, ...)
	if (ScrW() == 160 or ScrH() == 27) then
		return;
	end;
	
	if (!filtered) then
		--local maximumLines = math.Clamp(Clockwork.ConVars.MAXCHATLINES:GetInt(), 1, 10);
		local maximumLines = 10;
		local colorWhite = Clockwork.option:GetColor("white");
		local curTime = UnPredictedCurTime();
		local message = {
			timeFinish = curTime + 11,
			timeStart = curTime,
			timeFade = curTime + 10,
			spacing = 0,
			alpha = 255,
			lines = 1,
			icon = icon
		};
		
		if (self.multiplier) then
			message.multiplier = self.multiplier;
			self.multiplier = nil;
		end;
		
		local curOnHover = nil;
		local curColor = nil;
		local text = {...};
		
		--[[if (Clockwork.ConVars.SHOWTIMESTAMPS:GetInt() == 1) then
			local timeInfo = "("..os.date("%H:%M")..") ";
			local color = Color(150, 150, 150, 255);
			
			if (Clockwork.ConVars.TWELVEHOURCLOCK:GetInt() == 1) then
				timeInfo = "("..string.lower(os.date("%I:%M%p"))..") ";
			end;
			
			if (text) then
				table.insert(text, 1, color);
				table.insert(text, 2, timeInfo);
			else
				text = {timeInfo, color};
			end;
		end;]]--
		
		if (text) then
			message.text = {};
			
			for k, v in pairs(text) do
				if v == "Voltism" then
					message.font = "Voltism";
				elseif v == "Gore" then
					message.font = "Gore";
				elseif v == "noTime" then
					message.noTime = true;
				elseif (type(v) == "string" or type(v) == "number" or type(v) == "boolean") then
					Clockwork.chatBox:WrappedText(
						nil, message, curColor or colorWhite, tostring(v), curOnHover
					);
					curColor = nil;
					curOnHover = nil;
				elseif (type(v) == "function") then
					curOnHover = v;
				elseif (type(v) == "Player") then
					Clockwork.chatBox:WrappedText(
						nil, message, Clockwork.kernel:PlayerNameColor(v), v:Name(), curOnHover
					);
					curColor = nil;
					curOnHover = nil;
				elseif (type(v) == "table") then
					curColor = Color(v.r or 255, v.g or 255, v.b or 255);
				end;
			end;
		end;
		
		if (self.historyPos == #self.historyMsgs) then
			self.historyPos = #self.historyMsgs + 1;
		end;
		
		self.historyMsgs[#self.historyMsgs + 1] = message;
		
		if (message.noTime) then
			if cwCinematicText and Clockwork.ConVars.SHOWCINEMATICS:GetInt() == 1 then
				message.timeFinish = curTime;
				message.timeFade = curTime;
				
				Clockwork.option:PlaySound("tick");
				Clockwork.kernel:PrintColoredText(...);
				
				return;
			end
		end
		
		if (#self.messages == maximumLines) then
			table.remove(self.messages, maximumLines);
		end;
		
		table.insert(self.messages, 1, message);
		
		Clockwork.option:PlaySound("tick");
		Clockwork.kernel:PrintColoredText(...);
	end;
end;

Clockwork.chatBox:RegisterDefaultClass("ic", "ic", function(info)
	if (info.shouldHear) then
		local color = Color(255, 255, 150, 255);
							
		if (info.focusedOn) then
			color = Color(175, 255, 150, 255);
		end;
		
		local lastChar = string.sub(info.text, string.len(info.text));
		local sayText = "says";
		
		if lastChar == "?" then
			sayText = "asks";
		elseif lastChar == "!" then
			sayText = "exclaims";
		end
		
		if info.font then
			if info.font == "Voltism" then
				sayText = "chirps";
				
				if lastChar == "?" then
					sayText = "queries";
				elseif lastChar == "!" then
					sayText = "emits";
				end
			end
			
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." "..sayText.." \""..info.text.."\"", info.font, "noTime");
		else
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." "..sayText.." \""..info.text.."\"", "noTime");
		end
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("me", "ic", function(info)
	local color = Color(255, 255, 175, 255);
						
	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	if (string.utf8sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "*** "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "*** "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("mec", "ic", function(info)
	local color = Color(255, 255, 150, 255);

	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	if (string.utf8sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "* "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "* "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("mel", "ic", function(info)
	local color = Color(255, 255, 150, 255);

	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	if (string.utf8sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, color, "***** "..info.name..info.text);
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, "***** "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("it", "ic", function(info)
	local color = Color(255, 255, 175, 255);
						
	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	Clockwork.chatBox:Add(info.filtered, nil, color, "***' "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("itnofake", "ic", function(info)
	local color = Color(255, 255, 175, 255);
						
	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	Clockwork.chatBox:Add(info.filtered, nil, color, "*** "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("itl", "ic", function(info)
	local color = Color(255, 255, 150, 255);

	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	Clockwork.chatBox:Add(info.filtered, nil, color, "*' "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("itl", "ic", function(info)
	local color = Color(255, 255, 150, 255);

	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;
						
	Clockwork.chatBox:Add(info.filtered, nil, color, "*****' "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("yell", "ic", function(info)
	local color = Color(255, 255, 175, 255);
					
	if (info.focusedOn) then
		color = Color(175, 255, 175, 255);
	end;

	if info.font then
		if info.font == "Voltism" then
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." shrieks \""..info.text.."\"", info.font, "noTime");
		else
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." yells \""..info.text.."\"", info.font, "noTime");
		end
	else
		Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." yells \""..info.text.."\"", "noTime");
	end
end);

Clockwork.chatBox:RegisterDefaultClass("whisper", "ic", function(info)
	if (info.shouldHear) then
		local color = Color(255, 255, 175, 255);
							
		if (info.focusedOn) then
			color = Color(175, 255, 175, 255);
		end;

		if info.font then
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." whispers \""..info.text.."\"", info.font, "noTime");
		else
			Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." whispers \""..info.text.."\"", "noTime");
		end;
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("radio", "ic", function(info)
	if info.text == "<STATIC>" then
		surface.PlaySound( "ambient/levels/prison/radio_random"..math.random(1,15)..".wav" )
		Clockwork.chatBox:Add(info.filtered, nil, Color(75, 150, 50, 255), "The radio lets out an electric squeal, what sounds like garbled words, and static.", info.font);
	else
		Clockwork.chatBox:Add(info.filtered, nil, Color(75, 150, 50, 255), info.name.." radios in \""..info.text.."\"", info.font);
	end
end);

Clockwork.chatBox:RegisterDefaultClass("radiospy", "ic", function(info)
	if info.text == "<STATIC>" then
		surface.PlaySound( "ambient/levels/prison/radio_random"..math.random(1,15)..".wav" )
		Clockwork.chatBox:Add(info.filtered, nil, Color(75, 150, 50, 255), "The radio lets out an electric squeal, what sounds like garbled words, and static.", info.font);
	else
		Clockwork.chatBox:Add(info.filtered, nil, Color(75, 150, 50, 255), info.name..info.text, info.font);
	end
end);

Clockwork.chatBox:RegisterDefaultClass("radio_eavesdrop", "ic", function(info)
	if (info.shouldHear) then
		local color = Color(255, 255, 175, 255);
							
		if (info.focusedOn) then
			color = Color(175, 255, 175, 255);
		end;
						
		Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." radios in \""..info.text.."\"", info.font);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("goreevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(GORE FOREST) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("hellevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(HELL) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("towerevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(TOWER) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("wastelandevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(WASTELAND) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("cavesevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(MINES) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("localevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), "(LOCAL) "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("event", "ic", function(info)		
	Clockwork.chatBox:Add(info.filtered, nil, Color(200, 100, 50, 255), info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("proclaim", "ic", function(info)		
	Clockwork.chatBox:Add(info.filtered, nil, Color(255, 255, 102, 255), info.name.." proclaims \""..info.text.."\"", info.font);
end);

Clockwork.chatBox:RegisterDefaultClass("meproclaim", "ic", function(info)				
	if (string.utf8sub(info.text, 1, 1) == "'") then
		Clockwork.chatBox:Add(info.filtered, nil, Color(255, 255, 102, 255), "*** "..info.name..info.text, info.font);
	else
		Clockwork.chatBox:Add(info.filtered, nil, Color(255, 255, 102, 255), "*** "..info.name.." "..info.text, info.font);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("looc", "ooc", function(info)
	if (!config.Get("enable_looc_icons"):Get()) then
		info.icon = nil;
	end;

	Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[LOOC] ", Color(255, 255, 150, 255), info.name..": "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("loocnoicon", "ooc", function(info)
	if (!config.Get("enable_looc_icons"):Get()) then
		info.icon = nil;
	else
		local faction = info.speaker:GetFaction()
		local icon = "icon16/user_gray.png"
		
		if (info.speaker:GetGender() == GENDER_FEMALE) then
			icon = "icon16/user_red.png"
		end;

		if (faction and Clockwork.faction:GetStored()[faction]) then
			if (Clockwork.faction:GetStored()[faction].whitelist) then
				icon = "icon16/add.png"
			end
		end
		
		info.icon = icon;
	end

	Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[LOOC] ", Color(255, 255, 150, 255), info.name..": "..info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("priv", "ooc", function(info)
	local classColor = Clockwork.kernel:PlayerNameColor(info.speaker);
	local colors = {
		["operator"] = Color(100, 150, 200);
		["admin"] = Color(200, 200, 100);
		["superadmin"] = Color(200, 100, 50);
	}

	Clockwork.chatBox:Add(info.filtered, nil, colors[info.data.userGroup], "["..info.data.userGroup.."] ", classColor, "("..info.speaker:SteamName()..") "..info.name, ": ", info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("roll", "ooc", function(info)
	if (info.shouldHear) then
		Clockwork.chatBox:Add(info.filtered, nil, Color(150, 75, 75, 255), "** "..info.name.." "..info.text);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("ooc", "ooc", function(info)
	Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", Color(255, 180, 0, 255), info.speaker:SteamName(), ": ", info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("pm", "ooc", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, "[PM] ", Color(125, 150, 75, 255), "("..info.speaker:SteamName()..") "..info.name..": "..info.text);
	surface.PlaySound("hl1/fvox/bell.wav");
end);

Clockwork.chatBox:RegisterDefaultClass("disconnect", "ooc", function(info)
	local filtered = --[[(Clockwork.ConVars.SHOWAURA:GetInt() == 0) or]]info.filtered;
			
	Clockwork.chatBox:Add(filtered, "icon16/user_delete.png", Color(200, 150, 200, 255), info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("notify_all", "ooc", function(info)
	if (Clockwork.kernel:GetNoticePanel()) then
		Clockwork.kernel:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
	end;

	local filtered = --[[(Clockwork.ConVars.SHOWAURA:GetInt() == 0) or ]]info.filtered;
	local icon = info.data.icon or "comment";
	local color = Color(125, 150, 175, 255);

	if (string.utf8sub(info.text, -1) == "!") then
		icon = info.data.icon or "error";
		color = Color(200, 175, 200, 255);
	end;

	Clockwork.chatBox:Add(filtered, "icon16/"..icon..".png", color, info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("notify", "ooc", function(info)
	if (Clockwork.kernel:GetNoticePanel()) then
		Clockwork.kernel:AddCinematicText(info.text, Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
	end;
			
	local filtered = --[[(Clockwork.ConVars.SHOWAURA:GetInt() == 0) or ]]info.filtered;
	local icon = info.data.icon or "comment";
	local color = Color(175, 200, 255, 255);

	if (string.utf8sub(info.text, -1) == "!") then
		icon = info.data.icon or "error";
		color = Color(200, 175, 200, 255);
	end;

	Clockwork.chatBox:Add(filtered, "icon16/"..icon..".png", color, info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("connect", "ooc", function(info)
	local filtered = --[[(Clockwork.ConVars.SHOWAURA:GetInt() == 0) or ]]info.filtered;
	Clockwork.chatBox:Add(filtered, "icon16/user_add.png", Color(150, 150, 200, 255), info.text);
end);

Clockwork.chatBox:RegisterDefaultClass("connect_country", "ooc", function(info)
	local filtered = --[[(Clockwork.ConVars.SHOWAURA:GetInt() == 0) or ]]info.filtered;
	local flag = string.lower(info.data.countryIcon)..".png";
	local split = string.Split(info.text, " from ");
	local plystring = split[1]..".";
	
	if (plystring and !Clockwork.player:IsAdmin(Clockwork.Client)) then
		Clockwork.chatBox:Add(filtered, "icon16/user_add.png", Color(150, 150, 200, 255), plystring);
	else
		if (!flag) then flag = "ps.png" end;
		local flagstring = "materials/flags16/"..flag;
		Clockwork.chatBox:Add(filtered, flagstring, Color(150, 150, 200, 255), info.text);
	end;
end);

Clockwork.chatBox:RegisterDefaultClass("chat", "ooc", function(info)
	local speaker = info.speaker;

	if (speaker) then
		local classColor = Clockwork.kernel:PlayerNameColor(speaker);

		Clockwork.chatBox:Add(info.filtered, nil, classColor, info.name, ": ", info.text, nil, info.filtered);
	else
		Clockwork.chatBox:Add(info.filtered, info.icon, Color(225, 50, 50, 255), "[OOC] ", Color(150, 150, 150, 255), name, ": ", info.text);
	end;	
end);

hook.Add("PlayerBindPress", "Clockwork.chatBox:PlayerBindPress", function(player, bind, bPress)
	if ((string.find(bind, "messagemode") or string.find(bind, "messagemode2")) and bPress) then
		if (!IsValid(Clockwork.Client)) then
			return
		end;
		
		if (Clockwork.Client:HasInitialized() and !Clockwork.Client.LoadingText) then
			Clockwork.chatBox.panel:Show();
		end;
		
		return true;
	end;
end);

hook.Add("Think", "Clockwork.chatBox:Think", function()
	local curTime = UnPredictedCurTime();
	
	for k, v in pairs(Clockwork.chatBox.messages) do
		if (curTime >= v.timeFade) then
			local fadeTime = v.timeFinish - v.timeFade;
			local timeLeft = v.timeFinish - curTime;
			local alpha = math.Clamp((255 / fadeTime) * timeLeft, 0, 255);
			
			if (alpha == 0) then
				table.remove(Clockwork.chatBox.messages, k);
			else
				v.alpha = alpha;
			end;
		end;
	end;
end);

netstream.Hook("ChatBoxDeathCode", function(data)
	local iDeathCode = data;
	
	if (Clockwork.chatBox:IsOpen()) then
		local text = Clockwork.chatBox.textEntry:GetValue();
		
		if (text != "" and string.utf8sub(text, 1, 2) != "//" and string.utf8sub(text, 1, 3) != ".//"
		and string.utf8sub(text, 1, 2) != "[[") then
			RunConsoleCommand("cwDeathCode", iDeathCode);
				Clockwork.chatBox.textEntry:SetRealValue(string.utf8sub(text, 0, string.utf8len(text) - 1).."-");
			Clockwork.chatBox.textEntry:OnEnter();
		end;
	end;
end);

netstream.Hook("ChatBoxPlayerMessage", function(data)
	if (data.speaker:IsPlayer()) then
		Clockwork.chatBox:Decode(data.speaker, data.speaker:Name(), data.text, data.data, data.class, data.multiplier);
	end;
end);

netstream.Hook("ChatBoxColorMessage", function(data)
	chat.AddText(unpack(data));
end);

netstream.Hook("ChatBoxMessage", function(data)
	if (data and type(data) == "table" and Clockwork.Client and Clockwork.Client.Name) then
		Clockwork.chatBox:Decode(Clockwork.Client, Clockwork.Client:Name(), data.text, data.data, data.class, data.multiplier);
	end;
end);