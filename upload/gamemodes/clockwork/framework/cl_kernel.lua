--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--[[
	Derive from Sandbox, because we want the spawn menu and such!
	We also want the base Sandbox entities and weapons.
--]]
DeriveGamemode("sandbox")

local CreateClientConVar = CreateClientConVar
local CloseDermaMenus = CloseDermaMenus
local ChangeTooltip = ChangeTooltip
local ScreenScale = ScreenScale
local FrameTime = FrameTime
local DermaMenu = DermaMenu
local ScrW = ScrW
local ScrH = ScrH
local surface = surface
local render = render
local draw = draw
local vgui = vgui
local cam = cam
local gui = gui

COLOR_WHITE = Color(255, 255, 255)
COLOR_RED = Color(255, 0, 0)
COLOR_GREEN = Color(0, 255, 0)
COLOR_BLUE = Color(0, 0, 255)

do
	-- A function to get font widescreen scale.
	function ScaleToWideScreen(size)
		return math.min(math.max(ScreenScale(size / 2.62467192), math.min(size, 14)), size);
	end;

	-- A function to draw some rotated text.
	function surface.DrawRotatedText(text, font, x, y, angle, color) local matrix = Matrix();
		local pos = Vector(x + (GetFontWidth(font, text) / 2), y + (draw.GetFontHeight(font) / 2));
		
		matrix:Translate(pos);
		matrix:Rotate(Angle(0, angle, 0));
		matrix:Translate(-pos);
		
		cam.PushModelMatrix(matrix);
		surface.SetFont(font);
		surface.SetTextColor(color);
		surface.SetTextPos(x, y);
		surface.DrawText(text);
		cam.PopModelMatrix();
	end;

	-- A function to draw some scaled text.
	function surface.DrawScaledText(text, font, x, y, scale, color)
		local matrix = Matrix()
		local pos = Vector(x, y)

		matrix:Translate(pos)
		matrix:Scale(Vector(1, 1, 1) * scale)
		matrix:Translate(-pos)

		cam.PushModelMatrix(matrix)
			surface.SetFont(font)
			surface.SetTextColor(color)
			surface.SetTextPos(x, y)
			surface.DrawText(text)
		cam.PopModelMatrix()
	end

	-- A function to get if a variable is a vector.
	function IsVector(any)
		return isvector(any);
	end;
end;

do
	--[[
		This is a hack to display world tips correctly based on their owner.
	--]]

	local ClockworkAddWorldTip = Clockwork.AddWorldTip or AddWorldTip
	Clockwork.AddWorldTip = ClockworkAddWorldTip
	Clockwork.scratchTexture = Material("begotten/ui/penor.png")
	
	function AddWorldTip(entIndex, text, dieTime, position, entity)
		local weapon = Clockwork.Client:GetActiveWeapon()

		if (IsValid(weapon) and string.lower(weapon:GetClass()) == "gmod_tool") then
			if (IsValid(entity) and entity.GetPlayerName) then
				if (Clockwork.Client:Name() == entity:GetPlayerName()) then
					ClockworkAddWorldTip(entIndex, text, dieTime, position, entity)
				end
			end
		end
	end
end

timer.Destroy("HintSystem_OpeningMenu")
timer.Destroy("HintSystem_Annoy1")
timer.Destroy("HintSystem_Annoy2")

base64 = base64 or {}

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function base64.encode(data)
	return ((data:gsub('.', function(x)
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function base64.decode(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x != 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
	end))
end

do
	local cwOldRunConsoleCommand = RunConsoleCommand

	function RunConsoleCommand(...)
		local arguments = {...}

		if (arguments[1] == nil) then
			return
		end

		cwOldRunConsoleCommand(...)
	end
end

function surface.DrawScaledText(text, font, x, y, scale, color)
	local matrix = Matrix()
	local pos = Vector(x, y)

	matrix:Translate(pos)
	matrix:Scale(Vector(1, 1, 1) * scale)
	matrix:Translate(-pos)

	cam.PushModelMatrix(matrix)
		surface.SetFont(font)
		surface.SetTextColor(color)
		surface.SetTextPos(x, y)
		surface.DrawText(text)
	cam.PopModelMatrix()
end

function surface.DrawRotatedText(text, font, x, y, angle, color)
	local matrix = Matrix()
	local pos = Vector(x, y)

	matrix:Translate(pos)
	matrix:Rotate(Angle(0, angle, 0))
	matrix:Translate(-pos)

	cam.PushModelMatrix(matrix)
		surface.SetFont(font)
		surface.SetTextColor(color)
		surface.SetTextPos(x, y)
		surface.DrawText(text)
	cam.PopModelMatrix()
end

function surface.DrawScaled(x, y, scale, callback)
	local matrix = Matrix()
	local pos = Vector(x, y)

	matrix:Translate(pos)
	matrix:Scale(Vector(1, 1, 0) * scale)
	matrix:Rotate(Angle(0, 0, 0))
	matrix:Translate(-pos)

	cam.PushModelMatrix(matrix)
		if (callback) then
			Try("DrawScaled", callback, x, y, scale)
		end
	cam.PopModelMatrix()
end

function surface.DrawRotated(x, y, angle, callback)
	local matrix = Matrix()
	local pos = Vector(x, y)

	matrix:Translate(pos)
	matrix:Rotate(Angle(0, angle, 0))
	matrix:Translate(-pos)

	cam.PushModelMatrix(matrix)
		if (callback) then
			Try("DrawRotated", callback, x, y, angle)
		end
	cam.PopModelMatrix()
end

concommand.Add("cwSay", function(player, command, arguments)
	return netstream.Start("PlayerSay", table.concat(arguments, " "))
end)

concommand.Add("cwLua", function(player, command, arguments)
	if (player:IsSuperAdmin()) then
		RunString(table.concat(arguments, " "))
		return
	end

	print("You do not have access to this command, "..player:Name()..".");
end)

Clockwork.BackgroundBlurs = Clockwork.BackgroundBlurs or {}
Clockwork.RecognisedNames = Clockwork.RecognisedNames or {}
Clockwork.NetworkProxies = Clockwork.NetworkProxies or {}
Clockwork.InfoMenuOpen = Clockwork.InfoMenuOpen or false
Clockwork.ColorModify = Clockwork.ColorModify or {}
Clockwork.Cinematics = Clockwork.Cinematics or {}

Clockwork.kernel.CenterHints = Clockwork.kernel.CenterHints or {}
Clockwork.kernel.ESPInfo = Clockwork.kernel.ESPInfo or {}
Clockwork.kernel.Hints = Clockwork.kernel.Hints or {}

local countryTable = Clockwork.kernel.countries;
local flagPath = "materials/flags16/"

-- A function to get the client's country code.
function Clockwork.kernel:GetCountryCode(player)
	if (!player or player == Clockwork.Client) then
		return string.upper(system.GetCountry())
	else
		return string.upper(player:GetNetVar("CountryCode"))
	end;
end;

-- A function to get whether the client's country code is valid or not.
function Clockwork.kernel:IsValidCountry()
	local countryCode = self:GetCountryCode() or "IL";
		if (countryCode == "IL") then
			countryCode = "PS";
		end;
	local fileName = string.lower(flagPath..countryCode..".png");

	if (!_file.Exists(fileName)) then
		return false;
	end;
	
	if (!countryTable[countryCode]) then
		return false;
	end;
	
	return fileName;
end;

-- A function to get the client's country icon.
function Clockwork.kernel:GetCountryIcon(code)
	if (!code) then
		local flag = self:IsValidCountry();
		
		if (flag and flag != "") then
			return string.gsub(flag, "materials/", "");
		else
			return "debug/debugempty";
		end;
	else
		local code = string.lower(code);
			if (code == "il") then
				code = "ps";
			end;
		return "flags16/"..string.lower(code)..".png";
	end;
end;

-- A function to register a network proxy.
function Clockwork.kernel:RegisterNetworkProxy(entity, name, Callback)
	if (!Clockwork.NetworkProxies[entity]) then
		Clockwork.NetworkProxies[entity] = {}
	end

	Clockwork.NetworkProxies[entity][name] = {
		Callback = Callback,
		oldValue = nil
	}
end

-- A function to get whether the info menu is open.
function Clockwork.kernel:IsInfoMenuOpen()
	return Clockwork.InfoMenuOpen
end

-- A function to create a client ConVar.
function Clockwork.kernel:CreateClientConVar(name, value, save, userData, Callback)
	local conVar = CreateClientConVar(name, value, save, userData)

	cvars.AddChangeCallback(name, function(conVar, previousValue, newValue)
		hook.Run("ClockworkConVarChanged", conVar, previousValue, newValue)

		if (Callback) then
			Callback(conVar, previousValue, newValue)
		end
	end)

	return conVar
end

do
	local aspect = ScrW() / ScrH()

	function ScreenIsRatio(w, h)
		return (aspect == w / h)
	end
end

-- A function to scale a font size to the screen.
function Clockwork.kernel:FontScreenScale(size)
	size = size * 3

	if (ScreenIsRatio(16, 10)) then
		return size * (ScrH() / 1200)
	elseif (ScreenIsRatio(4, 3)) then
		return size * (ScrH() / 1024)
	end

	return size * (ScrH() / 1080)
end

-- A function to scale a font size to the screen without multiplying.
function Clockwork.kernel:HDFontScreenScale(size)
	if (ScreenIsRatio(16, 10)) then
		return size * (ScrH() / 1200)
	elseif (ScreenIsRatio(4, 3)) then
		return size * (ScrH() / 1024)
	end

	return size * (ScrH() / 1080)
end

function Clockwork.kernel:PlayerNameColor(player)
	if (IsValid(player)) then
		local playerTeam = player:Team();
		local color = _team.GetColor(playerTeam);
		local customColor = player:GetNetVar("CustomColor");
		--local override = plugin.Call("GetPlayerNameColor", player, color, playerTeam);
		local override = hook.Run("GetPlayerNameColor", player, color, playerTeam);

		if (customColor != nil) then
			color = util.JSONToTable(customColor);
		end;
		
		if (override != nil and IsColor(override)) then
			color = override;
		end;
		
		return Color(color.r, color.g, color.b, color.a);
	end;
end;

-- A function to get a material.
function Clockwork.kernel:GetMaterial(materialPath, pngParameters)
	if (typeof(materialPath) != "string") then
		return materialPath
	end

	self.CachedMaterial = self.CachedMaterial or {}

	if (!self.CachedMaterial[materialPath]) then
		self.CachedMaterial[materialPath] = Material(materialPath, pngParameters)
	end

	return self.CachedMaterial[materialPath]
end

-- A function to get the 3D font size.
function Clockwork.kernel:GetFontSize3D()
	return 128
end

-- A function to get the size of text.
function Clockwork.kernel:GetTextSize(font, text)
	local defaultWidth, defaultHeight = self:GetCachedTextSize(font, "U")
	local height = defaultHeight
	local width = 0
	local textLength = 0

	for i in string.gmatch(text, "([%z\1-\127\194-\244][\128-\191]*)") do
		local currentCharacter = textLength + 1
		local textWidth, textHeight = self:GetCachedTextSize(font, string.utf8sub(text, currentCharacter, currentCharacter))

		if (textWidth == 0) then
			textWidth = defaultWidth
		end

		if (textHeight > height) then
			height = textHeight
		end

		width = width + textWidth
		textLength = textLength + 1
	end

	return width, height
end

-- A function to calculate alpha from a distance.
function Clockwork.kernel:CalculateAlphaFromDistance(maximum, start, finish)
	if (type(start) == "Player") then
		start = start:GetShootPos()
	elseif (type(start) == "Entity") then
		start = start:GetPos()
	end

	if (type(finish) == "Player") then
		finish = finish:GetShootPos()
	elseif (type(finish) == "Entity") then
		finish = finish:GetPos()
	end

	return math.Clamp(255 - ((255 / maximum) * (start:Distance(finish))), 0, 255)
end

-- A function to wrap text into a table, using spaces to break up each line.
function Clockwork.kernel:WrapTextSpaced(text, font, maximumWidth, baseTable)
	if (maximumWidth <= 0 or !text or text == "") then
		return;
	end;
	
	local textTable = string.Explode(" ", text);
	local textPos = 1;
	
	for k,v in pairs(textTable) do
		local testString = baseTable[textPos].." "..v;
		local size = self:GetTextSize(font, testString)
		
		if (size > maximumWidth) then
			baseTable[textPos] = string.Trim(baseTable[textPos]);
				textPos = textPos + 1;
			baseTable[textPos] = (baseTable[textPos] or "")..v;
		else
			baseTable[textPos] = baseTable[textPos].." "..v;
		end;
	end;
end;

-- A function to wrap text into a table.
function Clockwork.kernel:WrapText(text, font, maximumWidth, baseTable)
	if (maximumWidth <= 0 or !text or text == "") then
		return
	end

	if (self:GetTextSize(font, text) > maximumWidth) then
		local currentWidth = 0
		local firstText = nil
		local secondText = nil

		for i = 0, #text do
			local currentCharacter = string.utf8sub(text, i, i)
			local currentSingleWidth = self:GetTextSize(font, currentCharacter)

			if ((currentWidth + currentSingleWidth) >= maximumWidth) then
				baseTable[#baseTable + 1] = string.utf8sub(text, 0, (i - 1))
				text = string.utf8sub(text, i)

				break
			else
				currentWidth = currentWidth + currentSingleWidth
			end
		end

		if (self:GetTextSize(font, text) > maximumWidth) then
			self:WrapText(text, font, maximumWidth, baseTable)
		else
			baseTable[#baseTable + 1] = text
		end
	else
		baseTable[#baseTable + 1] = text
	end
end

-- A function to handle an entity's menu.
function Clockwork.kernel:HandleEntityMenu(entity)
	if hook.Run("CanOpenEntityMenu") ~= false then
		local options = {}
		local itemTable = nil

		hook.Run("GetEntityMenuOptions", entity, options)

		if (entity:GetClass() == "cw_item") then
			-- Seems to be some weird lua error where sometimes this function doesn't exist right away. - DETrooper
			if !entity.GetItemTable then
				return;
			end
			
			itemTable = entity:GetItemTable()
			if (itemTable and itemTable:IsInstance() and itemTable.GetOptions) then
				local itemOptions = itemTable:GetOptions(entity)

				for k, v in pairs(itemOptions) do
					options[k] = {
						title = k,
						name = v,
						isOptionTable = true,
						isArgTable = true
					}
				end
			end
		end

		if (table.IsEmpty(options)) then return end

		if (self:GetEntityMenuType()) then
			local menuPanel = self:AddMenuFromData(nil, options, function(menuPanel, option, arguments)
				if (itemTable and type(arguments) == "table" and arguments.isOptionTable) then
					menuPanel:AddOption(arguments.title, function()
						if (itemTable.HandleOptions) then
							local transmit, data = itemTable:HandleOptions(arguments.name, nil, nil, entity)

							if (transmit) then
								netstream.Start("MenuOption", {
									option = arguments.name,
									data = data,
									item = itemTable.itemID,
									entity = entity
								})
							end
						end
					end)
				else
					menuPanel:AddOption(option, function()
						if (type(arguments) == "table" and arguments.isArgTable) then
							if (arguments.Callback) then
								arguments.Callback(function(arguments)
									Clockwork.entity:ForceMenuOption(
										entity, option, arguments
									)
								end)
							else
								Clockwork.entity:ForceMenuOption(
									entity, option, arguments.arguments
								)
							end
						else
							Clockwork.entity:ForceMenuOption(
								entity, option, arguments
							)
						end

						timer.Simple(FrameTime(), function()
							self:RemoveActiveToolTip()
						end)
					end)
				end

				menuPanel.Items = menuPanel:GetChildren()
				local panel = menuPanel.Items[#menuPanel.Items]

				if (IsValid(panel)) then
					if (type(arguments) == "table") then
						if (arguments.isOrdered) then
							menuPanel.Items[#menuPanel.Items] = nil
							table.insert(menuPanel.Items, 1, panel)
						end

						if (arguments.toolTip) then
							--self:CreateMarkupToolTip(panel)
							--panel:SetMarkupToolTip(arguments.toolTip)
							--REPLACE THIS
						end
					end
				end
			end)

			self:RegisterBackgroundBlur(menuPanel, SysTime())
			self:SetTitledMenu(menuPanel, "Interact")
			menuPanel.entity = entity

			return menuPanel
		end
	end
end

function draw.TexturedRect(x, y, w, h, material, color)
	if (!material) then return end

	color = (IsColor(color) and color) or Color(255, 255, 255)

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, w, h)
end

-- A function to get what type of entity menu to use.
function Clockwork.kernel:GetEntityMenuType()
	return true
end

-- A function to get the gradient texture.
function Clockwork.kernel:GetGradientTexture()
	return Clockwork.GradientTexture
end

-- A function to add a menu from data.
function Clockwork.kernel:AddMenuFromData(menuPanel, data, Callback, iMinimumWidth, bManualOpen)
	local bCreated = false
	local options = {}

	if (!menuPanel) then
		bCreated = true; menuPanel = DermaMenu()

		if (iMinimumWidth) then
			menuPanel:SetMinimumWidth(iMinimumWidth)
		end
	end

	for k, v in pairs(data) do
		options[#options + 1] = {k, v}
	end

	table.sort(options, function(a, b)
		return a[1] < b[1]
	end)

	for k, v in pairs(options) do
		if (type(v[2]) == "table" and !v[2].isArgTable) then
			if (!table.IsEmpty(v[2])) then
				self:AddMenuFromData(menuPanel:AddSubMenu(v[1]), v[2], Callback)
			end
		elseif (type(v[2]) == "function") then
			menuPanel:AddOption(v[1], v[2])
		elseif (Callback) then
			Callback(menuPanel, v[1], v[2])
		end
	end

	if (!bCreated) then return end

	if (!bManualOpen) then
		if (#options > 0) then
			menuPanel:Open()
		else
			menuPanel:Remove()
		end
	end

	return menuPanel
end

-- A function to adjust the width of text.
function Clockwork.kernel:AdjustMaximumWidth(font, text, width, addition, extra)
	local textString = tostring(self:Replace(text, "&", "U"))
	local textWidth = self:GetCachedTextSize(font, textString) + (extra or 0)

	if (textWidth > width) then
		width = textWidth + (addition or 0)
	end

	return width
end

--[[
	A function to add a top hint. If bNoSound is false then no
	sound will play, otherwise if it is a string then it will
	play that sound.
--]]
-- A function to add a top hint.
function Clockwork.kernel:AddTopHint(text, delay, color, noSound, showDuplicates, icon)
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (color) then
		if (type(color) == "string") then
			color = Clockwork.option:GetColor(color);
		end;
	else
		color = colorWhite;
	end;
	
	for k, v in ipairs(self.Hints) do
		if (v.text == text) then
			if (!showDuplicates) then
				return;
			end;
		end;
	end;
	
	if (table.Count(self.Hints) == 10) then
		table.remove(self.Hints, 10);
	end;
	
	--[[if (!noSound) then
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	end;]]--
	
	if (!icon) then
		icon = "";
	end;
	
	table.insert(self.Hints, 1, {
		targetAlpha = 255,
		alphaSpeed = 64,
		color = color,
		delay = delay,
		alpha = 0,
		text = text,
		icon = icon,
	});
end;

-- A function to clear the top hints.
function Clockwork.kernel:ClearHints()
	self.Hints = {};
end;

-- A function to calculate the top hints.
function Clockwork.kernel:CalculateHints()
	local frameTime = FrameTime();
	local curTime = UnPredictedCurTime();
	
	for k, v in pairs(self.Hints) do
		if (!v.nextChangeTarget or curTime >= v.nextChangeTarget) then
			v.alpha = math.Approach(v.alpha, v.targetAlpha, v.alphaSpeed * frameTime);
			
			if (v.alpha == v.targetAlpha) then
				if (v.targetAlpha == 0) then
					table.remove(self.Hints, k);
				else
					v.nextChangeTarget = curTime + v.delay;
					v.targetAlpha = 0;
					v.alphaSpeed = 16;
				end;
			end;
		end;
	end;
end;

do
	-- A function to draw the date and time.
	function Clockwork.kernel:DrawDateTime()
		local colorWhite = Clockwork.option:GetColor("white");
		local info = {width = ScrW() * 0.25, x = 8, y = 8};

		hook.Run("HUDPaintTopScreen", info)
		
		if (hook.Run("PlayerCanSeeDateTime")) then
			local dateTimeFont = Clockwork.option:GetFont("date_time_text");
			local dateString = Clockwork.date:GetString();
			local timeString = Clockwork.time:GetString();
			local dayName = Clockwork.time:GetDayName();
			local text = string.upper(dateString..". "..dayName..", "..timeString..".");
			
			self:OverrideMainFont(dateTimeFont);
				info.y = self:DrawInfo(text, info.x, info.y, colorWhite, 255, true);
			self:OverrideMainFont(false);
			
			local textWidth, textHeight = self:GetCachedTextSize(dateTimeFont, text);
			
			if (textWidth and textHeight) then
				--info.width = textWidth;
			end;
			
			info.y = info.y + 8;
		end;

		self:DrawBars(info);
		hook.Run("PostDrawDateTime", info);
	end;
end

-- A function to draw the top hints.
function Clockwork.kernel:DrawHints()
	local x = ScrW();
	local y = 8;

	if (hook.Run("PlayerCanSeeHints")) then
		for k, v in pairs(self.Hints) do
			self:OverrideMainFont(Clockwork.option:GetFont("hints_text"));
				y = self:DrawInfo(string.upper(v.text), x, y, v.color, v.alpha, true, function(x, y, width, height)
					if (v.icon != "") then
						surface.SetDrawColor(255, 255, 255, v.alpha);
						surface.SetMaterial(Material("icon32/hand_property.png"))
						surface.DrawTexturedRect(x - width - 44, y, 32, 32)
					end;
					
					return x - width - 8, y;
				end);
			self:OverrideMainFont(false);
		end;
	end;
end;

-- A function to draw the top bars.
function Clockwork.kernel:DrawBars(info, class)
	if (!Clockwork.Client.BarAlpha) then
		Clockwork.Client.BarAlpha = 0
	end
	
	local frameTime = FrameTime()

	if (hook.Run("PlayerCanSeeBars", class)) then
		if (Clockwork.Client.BarAlpha != 255) then
			Clockwork.Client.BarAlpha = math.Approach(Clockwork.Client.BarAlpha, 255, frameTime * 128)
		end
	else
		if (Clockwork.Client.BarAlpha != 0) then
			Clockwork.Client.BarAlpha = math.Approach(Clockwork.Client.BarAlpha, 0, frameTime * 256)
		end
	end
	
	if (Clockwork.Client.BarAlpha != 0) then
		local barTextFont = Clockwork.option:GetFont("bar_text")
		
		Clockwork.bars.width = info.width
		Clockwork.bars.height = 24
		Clockwork.bars.padding = 24
		Clockwork.bars.y = info.y
		
		if (class == "tab") then
			Clockwork.bars.x = info.x - (info.width / 2)
		else
			Clockwork.bars.x = info.x
		end
		
		local barNumber = #Clockwork.bars.stored
		local padding = 1
		
		if (barNumber > 1) then
			padding = (4 * barNumber) + 2
		end

		draw.RoundedBox(4, Clockwork.bars.x - 2, info.y - 4, info.width + 4, (Clockwork.bars.height * #Clockwork.bars.stored) + (padding + 6), Color(20, 20, 20, Clockwork.Client.BarAlpha / 2))

		Clockwork.option:SetFont("bar_text", Clockwork.option:GetFont("auto_bar_text"))
			for k, v in pairs(Clockwork.bars.stored) do
				Clockwork.bars.y = self:DrawBar(Clockwork.bars.x, Clockwork.bars.y, Clockwork.bars.width, Clockwork.bars.height, v.color, v.text, v.value, v.maximum, v.flash, {uniqueID = v.uniqueID}, true, true) + (Clockwork.bars.padding + 4)
			end
		Clockwork.option:SetFont("bar_text", barTextFont)
		
		info.y = Clockwork.bars.y
	end
end

-- A function to get the ESP info.
function Clockwork.kernel:GetESPInfo()
	return self.ESPInfo
end

do
	-- Called when extra player info is needed.
	function Clockwork.kernel:GetPlayerESPInfo(player, text)
		if (player:IsValid()) then
			local weapon = player:GetActiveWeapon();
			local health = player:Health();
			local armor = player:Armor();
			local colorWhite = Color(255, 255, 255, 255);
			local colorRed = Color(255, 0, 0, 255);
			local colorHealth = colorWhite;
			local colorArmor = colorWhite;
			local icon = player:GetChatIcon();
			local flag = player:GetFlag();
			
			if (flag != false and !Clockwork.icon:IsAdminIcon(icon)) then
				icon = flag;
			end;
			
			table.insert(text, {
				text = player:SteamName(), 
				color = Color(170, 170, 170, 255), 
				icon = icon
			});
			
			if (player:Alive() and health > 0) then
				table.insert(text, {
					text = "Health: ["..health.."]", 
					color = colorHealth, 
					bar = {
						value = health,
						max = player:GetMaxHealth()
					}
				});
				
				if cwMedicalSystem then
					local blood = player:GetNWInt("bloodLevel", 5000);
					
					table.insert(text, {
						text = "Blood: ["..blood.."]", 
						color = colorHealth, 
						bar = {
							value = blood,
							max = 5000
						},
						barColor = Color(200, 20, 20, 255)
					});
				end;
				
				if (cwSanity) then
					local sanity = math.Round(player:GetSanity() or 100, 1);
					local maxSanity = player:GetMaxSanity() or 100;

					if (sanity) then
						table.insert(text, {
							text = "Sanity: ["..sanity.."]",
							color = self:GetValueColor(sanity), 
							bar = {
								value = sanity,
								max = maxSanity
							}, 
							barColor = Color(50, 30, 20, 255)
						});
					end;
				end;
				
				if cwCharacterNeeds then
					local corruption = math.Round(player:GetSharedVar("corruption") or 0);
					
					if (corruption > 0) then
						table.insert(text, {
							text = "Corruption: ["..corruption.."]",
							color = self:GetValueColor(corruption), 
							bar = {
								value = corruption,
								max = 100
							}, 
							barColor = Color(100, 84, 82, 255)
						});
					end;
				end
				
				if (player:Armor() > 0) then
					table.insert(text, {
						text = "Armor: ["..armor.."]",
						color = colorArmor, 
						bar = {
							value = armor,
							max = player:GetMaxArmor()
						}, 
						barColor = Color(30, 65, 175, 255)
					});
				end;
				
				local subfaction = player:GetSharedVar("subfaction");
				
				if subfaction and subfaction ~= "" and subfaction ~= "N/A" then
					table.insert(text, {
						text = subfaction, 
						color = Color(0, 70, 100, 255)
					});
				end
				
				if (Schema.faiths) then
					local faith = player:GetSharedVar("faith");
					
					if faith then
						local faithText = faith;
						local faithTable = Schema.faiths:GetFaith(faith);
						local faithColor;
						
						if faithTable then
							faithColor = faithTable.color;
						end
						
						local subfaith = player:GetSharedVar("subfaith");
						
						if subfaith and subfaith ~= "N/A" then
							faithText = subfaith;
						end
						
						table.insert(text, {
							text = faithText, 
							color = faithColor or Color(255, 255, 255);
						});
					end
				end;
				
				if player:GetSharedVar("favored") then
					table.insert(text, {
						text = "*FAVORED*", 
						color = Color(0, 0, 255, 255);
					});
				end
				
				if player:GetSharedVar("followed") then
					table.insert(text, {
						text = "*FOLLOWED*", 
						color = Color(255, 0, 0, 255);
					});
				end
				
				--if player:HasTrait("marked") then
				if player:GetSharedVar("marked") then
					table.insert(text, {
						text = "*MARKED*", 
						color = Color(255, 0, 0, 255);
					});
				end
				
				--if player:HasTrait("possessed") then
				if player:GetSharedVar("possessed") then
					table.insert(text, {
						text = "*POSSESSED*", 
						color = Color(255, 0, 0, 255);
					});
				end
				
				if cwMedicalSystem then
					local diseases = player:GetSharedVar("diseases");
					
					if diseases and not table.IsEmpty(diseases) then
						for i = 1, #cwMedicalSystem.espDiseases do
							local disease = cwMedicalSystem.espDiseases[i];
							
							if table.HasValue(diseases, disease) then
								local diseaseTable = cwMedicalSystem:FindDiseaseByID(disease);
								
								table.insert(text, {
									text = "*"..string.upper(diseaseTable.name).."*",
									color = Color(255, 0, 0, 255);
								});
							end
						end
					end
				end

				if (weapon and IsValid(weapon)) then			
					local raised = Clockwork.player:GetWeaponRaised(player) or player:GetNWBool("senses") == true;
					local color = colorWhite;

					if (raised == true) then
						color = colorRed;
					end;
					
					if (weapon.GetPrintName) then
						local printName = weapon:GetPrintName();

						if (printName) then
							table.insert(text, {
								text = printName, 
								color = color
							});
						end;
					end;
				end;
			end;
		end;
	end;

	-- A function to get all ESP info.
	function Clockwork.kernel:GetAdminESPInfo(info)
		local players = _player.GetAll();
		
		for k, v in pairs(players) do
			if (IsValid(v) and v:HasInitialized()) then
				local physBone = v:LookupBone("ValveBiped.Bip01_Head1");
				local position = nil;

				if (physBone) then
					local bonePosition = v:GetBonePosition(physBone);

					if (bonePosition) then
						position = bonePosition + Vector(0, 0, 16);
					end;
				else
					position = v:GetPos() + Vector(0, 0, 80);
				end;

				local topText = {v:Name().." ("..v:GetSharedVar("level", 1)..")"};
					hook.Run("GetStatusInfo", v, topText);	
				local playerColor = Clockwork.kernel:PlayerNameColor(v);
				
				local text = {{
					text = table.concat(topText, " "), 
					color = playerColor
				}};

				Clockwork.kernel:GetPlayerESPInfo(v, text);

				table.insert(info, {
					position = position,
					text = text
				});
			end;
		end;
		
		local salesESP = CW_CONVAR_SALEESP:GetInt() == 1;
		local itemESP = CW_CONVAR_ITEMESP:GetInt() == 1;
		local allEnts = {};
		
		if (salesESP or itemESP) then
			allEnts = ents.GetAll();
		end;

		if (!table.IsEmpty(allEnts)) then
			for k, v in pairs (allEnts) do 
				if (!IsValid(v)) then
					continue;
				end;
				
				local class = v:GetClass();
				
				if (salesESP and class == "cw_salesman") then
					local position = v:GetPos() + Vector(0, 0, 80);
					local saleName = v:GetNetworkedString("Name");
					local color = Color(255, 150, 0, 255);
					
					table.insert(info, {
						position = position,
						text = {{
							text = "[Salesman]", 
							color = color
						}, {
							text = saleName, 
							color = color
						}}
					});
					
					continue;
				end;
				
				if (itemESP and class == "cw_item") then
					local position = v:GetPos();
					local itemTable = Clockwork.entity:FetchItemTable(v);
					
					if (itemTable) then
						local itemName = itemTable("name");
						local color = Color(0, 255, 255, 255);
						
						table.insert(info, {
							position = position,
							text = {{
								text = "[Item]",
								color = color
							}, {
								text = itemName,
								color = color
							}}
						});
					end;
				end;
			end;
		end;
	end;
	
	-- A function to get the color of a value from green to red.
	function Clockwork.kernel:GetValueColor(value)
		local red = math.floor(255 - (value * 2.55));
		local green = math.floor(value * 2.55);
		
		return Color(red, green, 0, 255);
	end;

	-- A function to draw the admin ESP.
	function Clockwork.kernel:DrawAdminESP()
		local colorWhite = Clockwork.option:GetColor("white");
		local curTime = UnPredictedCurTime();

		if (!self.NextGetESPInfo or curTime >= self.NextGetESPInfo) then
			self.NextGetESPInfo = curTime + (CW_CONVAR_ESPTIME:GetInt() or 1);
			self.ESPInfo = {};

			self:GetAdminESPInfo(self.ESPInfo)
			Clockwork.plugin:Call("GetAdminESPInfo", self.ESPInfo);
		end;

		for k, v in pairs(self.ESPInfo) do
			local position = v.position:ToScreen();
			local text, color, height;
			
			if (position) then
				if (type(v.text) == "string") then
					self:DrawSimpleText(v.text, position.x, position.y, v.color or colorWhite, 1, 1);
				else
					for k2, v2 in ipairs(v.text) do	
						local barValue;
						local maximum = 100;

						if (type(v2) == "string") then
							text = v2;
							color = v.color;
						else
							text = v2.text;
							color = v2.color;

							local barNumbers = v2.bar;

							if (type(barNumbers) == "table") then
								barValue = barNumbers.value;
								maximum = barNumbers.max;
								
								if barValue > maximum then
									barValue = maximum;
								end
							else
								barValue = barNumbers;
							end;
						end;
						
						local font = "TargetIDSmall"
						
						if (k2 > 1) then
							self:OverrideMainFont(font);
							height = draw.GetFontHeight(font);
						else
							self:OverrideMainFont(false);
							height = draw.GetFontHeight(Clockwork.option:GetFont("main_text"));
						end;

						if (v2.icon) then
							local icon = "icon16/exclamation.png";
							local width = surface.GetTextSize(text);
							local iconWidth = height;
							local iconHeight = height;
							local posX = position.x - (width * 0.40) - height
							local posY = position.y - height * 0.5;

							if (type(v2.icon == "string") and v2.icon != "") then
								icon = v2.icon;
							end;
							
							if (string.find(icon, "flags")) then
								iconWidth = height * 1.5;
								iconHeight = iconHeight - 2;
								posX = posX - (width / 6);
								posY = posY + 2;
							end;

							surface.SetDrawColor(255, 255, 255, 255);
							surface.SetMaterial(Clockwork.kernel:GetMaterial(icon));
							surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);
						end;

						if (barValue) then
							local barHeight = height * 0.80 + 2;
							local barColor = v2.barColor or self:GetValueColor(barValue);
							local grayColor = Color(10, 10, 10, 170);
							local progress = 100 * (barValue / maximum);

							if progress < 0 then
								progress = 0;
							end;
							
							draw.RoundedBox(0, position.x - 50 - 1, position.y - (barHeight * 0.45) - 1, math.floor(progress) + 2, barHeight + 4, Color(90, 90, 90));
							draw.RoundedBox(0, position.x - 50, position.y - (barHeight * 0.45), 100, barHeight + 2, grayColor);
							draw.RoundedBox(0, position.x - 50, position.y - (barHeight * 0.45), math.floor(progress), barHeight + 2, barColor);
						end;

						if (type(text) == "string") then
							self:DrawSimpleText(text, position.x, position.y, color or colorWhite, 1, 1);
						end;

						position.y = position.y + height + 4;
					end;
				end;			
			end;
		end;
	end;
end

-- A function to draw a bar with a value and a maximum.
function Clockwork.kernel:DrawBar(x, y, width, height, color, text, value, maximum, flash, barInfo, bBarText, bTopBar)
	if (!Clockwork.Client.BarAlpha) then
		return
	end
	
	local frameTime = FrameTime()
	local backgroundColor = Clockwork.option:GetColor("background")
	local progressWidth = math.Clamp(((width - 2) / maximum) * value, 0, width - 2)
	local colorWhite = Clockwork.option:GetColor("white")
	local newBarInfo = {
		progressWidth = progressWidth,
		drawBackground = true,
		drawGradient = true,
		drawProgress = true,
		cornerSize = 4,
		maximum = maximum,
		height = height,
		width = width,
		color = color,
		value = value,
		flash = flash,
		text = text,
		x = x,
		y = y
	}
	
	if (barInfo) then
		for k, v in pairs(newBarInfo) do
			if (!barInfo[k]) then
				barInfo[k] = v
			end
		end
	else
		barInfo = newBarInfo
	end

	local color = barInfo.color

	if (bTopBar) then
		color.a = Clockwork.Client.BarAlpha
	end

	barInfo.height = 24

	surface.SetDrawColor(255, 255, 255, (color.a / 2))
	surface.SetMaterial(Clockwork.scratchTexture)
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.width, barInfo.height)
	
	barInfo.drawBackground = false
	barInfo.drawProgress = false
	
	if (barInfo.text) then
		barInfo.text = string.upper(barInfo.text)
	end

	if (barInfo.drawGradient) then
		surface.SetDrawColor(100, 100, 100, (color.a / 2))
		surface.SetTexture(surface.GetTextureID("gui/gradient_up"))
		surface.DrawTexturedRect(barInfo.x + 2, barInfo.y + 2, barInfo.width - 4, barInfo.height - 4)
	end

	surface.SetDrawColor(barInfo.color.r, barInfo.color.g, barInfo.color.b, (color.a * 3))
	surface.SetMaterial(Clockwork.scratchTexture)
	surface.DrawTexturedRect(barInfo.x, barInfo.y, barInfo.progressWidth, barInfo.height)
	
	if (barInfo.text and barInfo.text != "") then
		local barTextX = barInfo.x + (barInfo.width / 2)
		local alignX = 1
		
		if (bBarText) then
			local boxWidth = self:GetCachedTextSize("Subtitle_Talk", "100/100")
			
			barTextX = barInfo.x + 8
			alignX = 0

			draw.RoundedBox(4, barInfo.x + barInfo.width + 4, barInfo.y, boxWidth + 8, barInfo.height, Color(20, 20, 20, color.a / 2))

			self:OverrideMainFont("Subtitle_Talk")
				self:DrawSimpleText(math.Round(barInfo.value).."/"..barInfo.maximum, barInfo.x + barInfo.width + (boxWidth / 2) + 8, barInfo.y + (barInfo.height / 2) + 1, color, 1, 1)
			self:OverrideMainFont(false)
		end

		self:OverrideMainFont("BarTextBegotten")
			self:DrawSimpleText(barInfo.text, barTextX, barInfo.y + (barInfo.height / 2) + 1, Color(255, 255, 255, color.a), alignX, 1)
		self:OverrideMainFont(false)
	end
	
	return barInfo.y
end

-- A function to set the recognise menu.
function Clockwork.kernel:SetRecogniseMenu(menuPanel)
	Clockwork.RecogniseMenu = menuPanel
	self:SetTitledMenu(menuPanel, "SELECT WHO CAN RECOGNISE YOU")
end

-- A function to get the recognise menu.
function Clockwork.kernel:GetRecogniseMenu(menuPanel)
	return Clockwork.RecogniseMenu
end

-- A function to override the main font.
function Clockwork.kernel:OverrideMainFont(font)
	if (font) then
		if (!Clockwork.PreviousMainFont) then
			Clockwork.PreviousMainFont = Clockwork.option:GetFont("main_text")
		end

		Clockwork.option:SetFont("main_text", font)
	elseif (Clockwork.PreviousMainFont) then
		Clockwork.option:SetFont("main_text", Clockwork.PreviousMainFont)
	end
end

-- A function to get the screen's center.
function Clockwork.kernel:GetScreenCenter()
	return ScrW() / 2, (ScrH() / 2) + 32;
end;

-- A function to scale a font to wide screen.
function Clockwork.kernel:ScaleToWideScreen(size)
	return math.min(math.max(ScreenScale(size / 2.62467192), math.min(size, 14)), size);
end;

-- A function to draw some simple text.
function Clockwork.kernel:DrawSimpleText(text, x, y, color, alignX, alignY, shadowless, shadowDepth)
	local mainTextFont = Clockwork.option:GetFont("main_text")
	local realX = math.Round(x)
	local realY = math.Round(y)

	if (!shadowless) then
		local outlineColor = Color(25, 25, 25, math.min(255, color.a))

		for i = 1, (shadowDepth or 1) do
			draw.SimpleText(text, mainTextFont, realX + -i, realY + -i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + -i, realY + i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + i, realY + -i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + i, realY + i, outlineColor, alignX, alignY)
		end
	end
	
	draw.SimpleText(text, mainTextFont, realX, realY, color, alignX, alignY)
	local width, height = self:GetCachedTextSize(mainTextFont, text)

	return realY + height + 2, width
end

-- A function to get the black fade alpha.
function Clockwork.kernel:GetBlackFadeAlpha()
	return Clockwork.BlackFadeIn or Clockwork.BlackFadeOut or 0
end

-- A function to get whether the screen is faded black.
function Clockwork.kernel:IsScreenFadedBlack()
	return (Clockwork.BlackFadeIn == 255)
end

--[[
	A function to print colored text to the console.
	Sure, it's hacky, but Garry is being a douche.
--]]
function Clockwork.kernel:PrintColoredText(...)
	local currentColor = nil
	local colorWhite = Clockwork.option:GetColor("white")
	
	local text = {}

	for k, v in ipairs({...}) do
		if v ~= "noTime" then
			if (type(v) == "Player") then
				text[#text + 1] = Clockwork.kernel:PlayerNameColor(v);
				text[#text + 1] = v:Name();
			elseif (type(v) == "table") then
				currentColor = v
			elseif (currentColor) then
				text[#text + 1] = currentColor
				text[#text + 1] = v
				currentColor = nil
			else
				text[#text + 1] = colorWhite
				text[#text + 1] = v
			end
		end
	end

	chat.ClockworkAddText(unpack(text));
end

-- A function to get whether a custom crosshair is used.
function Clockwork.kernel:UsingCustomCrosshair()
	return Clockwork.CustomCrosshair
end

-- A function to get a cached text size.
function Clockwork.kernel:GetCachedTextSize(font, text)
	if (!Clockwork.CachedTextSizes) then
		Clockwork.CachedTextSizes = {}
	end

	if (!Clockwork.CachedTextSizes[font]) then
		Clockwork.CachedTextSizes[font] = {}
	end

	if (!Clockwork.CachedTextSizes[font][text]) then
		surface.SetFont(font)

		Clockwork.CachedTextSizes[font][text] = { surface.GetTextSize(text) }
	end

	return Clockwork.CachedTextSizes[font][text][1], Clockwork.CachedTextSizes[font][text][2]
end

-- A function to draw scaled information at a position.
function Clockwork.kernel:DrawInfoScaled(scale, text, x, y, color, alpha, bAlignLeft, Callback, shadowDepth)
	local newFont = Clockwork.fonts:GetMultiplied("cwMainText", scale)
	local returnY = 0

	self:OverrideMainFont(newFont)

	returnY = self:DrawInfo(text, x, y, color, alpha, bAlignLeft, Callback, shadowDepth)

	self:OverrideMainFont(false)

	return returnY
end

-- A function to draw information at a position.
function Clockwork.kernel:DrawInfo(text, x, y, color, alpha, bAlignLeft, Callback, shadowDepth)
	local width, height = self:GetCachedTextSize(Clockwork.option:GetFont("main_text"), text)

	if (width and height) then
		if (!bAlignLeft) then
			x = x - (width / 2)
		end

		if (Callback) then
			x, y = Callback(x, y, width, height)
		end

		return self:DrawSimpleText(text, x, y, Color(color.r, color.g, color.b, alpha or color.a), nil, nil, nil, shadowDepth)
	end
end

-- A function to get the player info box.
function Clockwork.kernel:GetPlayerInfoBox()
	return Clockwork.PlayerInfoBox
end

-- A function to draw the local player's information.
function Clockwork.kernel:DrawPlayerInfo(info)
	if (!hook.Run("PlayerCanSeePlayerInfo")) then
		return
	end

	local foregroundColor = Clockwork.option:GetColor("foreground")
	local subInformation = Clockwork.PlayerInfoText.subText
	local information = Clockwork.PlayerInfoText.text
	local colorWhite = Clockwork.option:GetColor("white")
	local textWidth, textHeight = self:GetCachedTextSize(
		Clockwork.option:GetFont("player_info_text"), "U"
	)
	local width = Clockwork.PlayerInfoText.width

	if (width < info.width) then
		width = info.width
	elseif (width > width) then
		info.width = width
	end

	if (#information == 0 and #subInformation == 0) then
		return
	end

	local height = (textHeight * #information) + ((textHeight + 12) * #subInformation)
	local scrW = ScrW()
	local scrH = ScrH()

	if (#information > 0) then
		height = height + 8
	end

	local y = info.y + 8
	local x = info.x - (width / 2)

	local boxInfo = {
		subInformation = subInformation,
		drawBackground = true,
		information = information,
		textHeight = textHeight,
		cornerSize = 2,
		textWidth = textWidth,
		height = height,
		width = width,
		x = x,
		y = y
	}

	if (!hook.Run("PreDrawPlayerInfo", boxInfo, information, subInformation)) then
		self:OverrideMainFont(Clockwork.option:GetFont("player_info_text"))

		for k, v in pairs(subInformation) do
			x, y = self:DrawPlayerInfoSubBox(v.text, x, y, width, boxInfo)
		end

		if (#information > 0 and boxInfo.drawBackground) then
			Clockwork.kernel:DrawSimpleGradientBox(4, x, y, width, height - ((textHeight + 12) * #subInformation), Color(200, 200, 200))
		end

		if (#information > 0) then
			x = x + 8
			y = y + 4
		end

		for k, v in pairs(information) do
			self:DrawInfo(v.text, x, y - 1, colorWhite, 255, true)
			y = y + textHeight
		end

		self:OverrideMainFont(false)
	end

	hook.Run("PostDrawPlayerInfo", boxInfo, information, subInformation)
	info.y = info.y + boxInfo.height + 12

	return boxInfo
end

-- A function to get whether the info menu panel can be created.
function Clockwork.kernel:CanCreateInfoMenuPanel()
	return (!table.IsEmpty(Clockwork.quickmenu.stored) or !table.IsEmpty(Clockwork.quickmenu.categories))
end

-- A function to create the info menu panel.
function Clockwork.kernel:CreateInfoMenuPanel(x, y, iMinimumWidth)
	if (IsValid(Clockwork.InfoMenuPanel)) then return end

	local options = {}

	for k, v in pairs(Clockwork.quickmenu.categories) do
		options[k] = {}

		for k2, v2 in pairs(v) do
			local info = v2.GetInfo()

			if (type(info) == "table") then
				options[k][k2] = info
				options[k][k2].isArgTable = true
			end
		end
	end

	for k, v in pairs(Clockwork.quickmenu.stored) do
		local info = v.GetInfo()

		if (type(info) == "table") then
			options[k] = info
			options[k].isArgTable = true
		end
	end

	Clockwork.InfoMenuPanel = self:AddMenuFromData(nil, options, function(menuPanel, option, arguments)
		if (arguments.name) then
			option = arguments.name
		end

		if (arguments.options) then
			local subMenu = menuPanel:AddSubMenu(option)

			for k, v in pairs(arguments.options) do
				local name = v

				if (type(v) == "table") then
					name = v[1]
				end

				subMenu:AddOption(name, function()
					if (arguments.Callback) then
						if (type(v) == "table") then
							arguments.Callback(v[2])
						else
							arguments.Callback(v)
						end
					end

					self:RemoveActiveToolTip()
					self:CloseActiveDermaMenus()
				end)
			end

			if (IsValid(subMenu)) then
				if (arguments.toolTip) then
					subMenu:SetTooltip(arguments.toolTip)
				end
			end
		else
			menuPanel:AddOption(option, function()
				if (arguments.Callback) then
					arguments.Callback()
				end

				self:RemoveActiveToolTip()
				self:CloseActiveDermaMenus()
			end)

			menuPanel.Items = menuPanel:GetChildren()
			local panel = menuPanel.Items[#menuPanel.Items]

			if (IsValid(panel) and arguments.toolTip) then
				panel:SetTooltip(arguments.toolTip)
			end
		end
	end, iMinimumWidth)

	if (IsValid(Clockwork.InfoMenuPanel)) then
		Clockwork.InfoMenuPanel:SetVisible(false)
		Clockwork.InfoMenuPanel:SetSize(iMinimumWidth, Clockwork.InfoMenuPanel:GetTall())
		Clockwork.InfoMenuPanel:SetPos(x, y)
	end
end

-- A function to get the ragdoll eye angles.
function Clockwork.kernel:GetRagdollEyeAngles()
	if (!Clockwork.RagdollEyeAngles) then
		Clockwork.RagdollEyeAngles = Angle(0, 0, 0)
	end

	return Clockwork.RagdollEyeAngles
end

-- A function to draw a gradient.
function Clockwork.kernel:DrawGradient(gradientType, x, y, width, height, color)
	if (!Clockwork.Gradients or !Clockwork.Gradients[gradientType]) then
		return
	end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetTexture(Clockwork.Gradients[gradientType])
	surface.DrawTexturedRect(x, y, width, height)
end

function Clockwork.kernel:DrawGenericBackground(x, y, w, h, color)
	surface.SetDrawColor(color)
	surface.DrawRect(x, y, w, h)
end

-- A function to draw a simple gradient box.
function Clockwork.kernel:DrawSimpleGradientBox(cornerSize, x, y, width, height, color, maxAlpha)
	local gradientAlpha = math.min(color.a, maxAlpha or 100);
	draw.RoundedBox(cornerSize, x, y, width, height, Color(color.r, color.g, color.b, color.a * 0.75));
	
	if (x + cornerSize < x + width and y + cornerSize < y + height) then
		surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
		surface.SetTexture(Clockwork.DefaultGradient);
		surface.DrawTexturedRect(x + cornerSize, y + cornerSize, width - (cornerSize * 2), height - (cornerSize * 2));
	end;
end;

local gradientTexture = Material("begotten/ui/penor.png")

-- A function to draw a textured gradient.
function Clockwork.kernel:DrawTexturedGradientBox(cornerSize, x, y, width, height, color, maxAlpha)
	local gradientAlpha = math.min(color.a, maxAlpha or 100);
	draw.RoundedBox(cornerSize, x, y, width, height, Color(color.r, color.g, color.b, color.a * 0.75));
	
	if (x + cornerSize < x + width and y + cornerSize < y + height) then
		surface.SetDrawColor(gradientAlpha, gradientAlpha, gradientAlpha, gradientAlpha);
		surface.SetMaterial(gradientTexture);
		surface.DrawTexturedRect(x + cornerSize, y + cornerSize, width - (cornerSize * 2), height - (cornerSize * 2));
	end;
end;

-- A function to draw a player information sub box.
function Clockwork.kernel:DrawPlayerInfoSubBox(text, x, y, width, boxInfo)
	local foregroundColor = Clockwork.option:GetColor("foreground")
	local colorInfo = Clockwork.option:GetColor("information")
	local boxHeight = boxInfo.textHeight + 8

	if (boxInfo.drawBackground) then
		Clockwork.kernel:DrawSimpleGradientBox(4, x, y, width, boxHeight, foregroundColor)
	end

	self:DrawInfo(text, x + 8, y + (boxHeight / 2), colorInfo, 255, true,
		function(x, y, width, height)
			return x, y - (height / 2)
		end
	)

	return x, y + boxHeight + 4
end

-- A function to handle an item's spawn icon click.
function Clockwork.kernel:HandleItemSpawnIconClick(itemTable, spawnIcon, Callback)
	local customFunctions = itemTable.customFunctions
	local itemFunctions = {}
	local destroyName = Clockwork.option:GetKey("name_destroy")
	local dropName = Clockwork.option:GetKey("name_drop")
	local repairName = "Repair";
	local useName = Clockwork.option:GetKey("name_use")
	local equipName = "Equip";
	local examineName = "Examine";
	
	itemFunctions[#itemFunctions + 1] = examineName;

	if (itemTable.OnUse) then
		if not itemTable:IsBroken() then
			itemFunctions[#itemFunctions + 1] = (itemTable("useText") or useName)
		end
	end
	
	if (itemTable.OnRepair) and (itemTable.repairItem) and itemTable:GetCondition() then
		if itemTable:GetCondition() < 100 and (!itemTable:IsBroken() or (cwBeliefs and cwBeliefs:HasBelief("artisan"))) then
			if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), itemTable.repairItem) then
				itemFunctions[#itemFunctions + 1] = (itemTable.repairText or repairName);
			end
		end
	end
	
	if (itemTable.components) then
		if itemTable.components.breakdownType == "meltdown" then
			if !cwBeliefs or (cwBeliefs and cwBeliefs:HasBelief("smith")) then
				for i = 1, #cwRecipes.smithyLocations do
					if Clockwork.Client:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
						itemFunctions[#itemFunctions + 1] = ("Melt Down");
						break;
					end
				end
			end
		elseif itemTable.components.breakdownType == "breakdown" then
			if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "breakdown_kit") then
				itemFunctions[#itemFunctions + 1] = ("Break Down");
			end
		end
	end
	
	if itemTable.ammoCapacity then
		local ammo = itemTable:GetData("Ammo");
		
		if ammo and #ammo > 0 then
			if #ammo == 1 and !string.find(ammo[1], "Magazine") then
				if itemTable.usesMagazine then
					itemFunctions[#itemFunctions + 1] = ("Unload Chamber")
				else
					itemFunctions[#itemFunctions + 1] = ("Unload Shot")
				end
			elseif itemTable.usesMagazine then
				itemFunctions[#itemFunctions + 1] = ("Unload Magazine")
			else
				itemFunctions[#itemFunctions + 1] = ("Unload All Shot")
			end
		end
	end
	
	if itemTable.ammoMagazineSize then
		local ammo = itemTable:GetAmmoMagazine();
		
		if ammo and ammo > 0 then
			itemFunctions[#itemFunctions + 1] = ("Unload Shot");
		end
	end

	if (itemTable.OnDrop) then
		itemFunctions[#itemFunctions + 1] = (itemTable.dropText or dropName)
	end

	if (itemTable.OnDestroy) then
		itemFunctions[#itemFunctions + 1] = (itemTable.destroyText or destroyName)
	end
	
	if (itemTable.Equip) then
		itemFunctions[#itemFunctions + 1] = (itemTable.equipText or equipName)
	end

	if (customFunctions) then
		for k, v in pairs(customFunctions) do
			-- This is janky but whatever lol.
			
			if v == "Turn On" then
				local radioState = Clockwork.Client.radioState or false;
				
				if radioState then
					if tobool(radioState) == false then
						itemFunctions[#itemFunctions + 1] = v;
					end
				else
					itemFunctions[#itemFunctions + 1] = v;
				end
			elseif v == "Turn Off" then
				local radioState = Clockwork.Client.radioState or false;
				
				if radioState then
					if tobool(radioState) == true then
						itemFunctions[#itemFunctions + 1] = v;
					end
				end
			elseif v == "Engrave" then
				local engraving = itemTable:GetData("engraving");
				
				if !engraving or engraving == "" then
					if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "engraving_tool") then
						itemFunctions[#itemFunctions + 1] = v;
					end
				end
			elseif v == "Copy" then
				if Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "quill") and Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), "paper") then
					if !cwBeliefs or (cwBeliefs and cwBeliefs:HasBelief("scribe")) then
						itemFunctions[#itemFunctions + 1] = v;
					end
				end
			else
				itemFunctions[#itemFunctions + 1] = v;
			end
		end
	end

	if (itemTable.GetOptions) then
		local options = itemTable:GetOptions(nil, nil)
		for k, v in pairs(options) do
			itemFunctions[#itemFunctions + 1] = {title = k, name = v}
		end
	end

	if (itemTable.OnEditFunctions) then
		itemTable:OnEditFunctions(itemFunctions)
	end

	hook.Run("PlayerAdjustItemFunctions", itemTable, itemFunctions)
	self:ValidateTableKeys(itemFunctions)

	table.sort(itemFunctions, function(a, b) return ((type(a) == "table" and a.title) or a) < ((type(b) == "table" and b.title) or b) end)
	if (#itemFunctions == 0 and !Callback) then return end -- it returns here

	local options = {}

	if (itemTable.GetEntityMenuOptions) then
		itemTable:GetEntityMenuOptions(nil, options)
	end

	local itemMenu = self:AddMenuFromData(nil, options, function(menuPanel, option, arguments)
		if not string.find(option, "Unload") then
			menuPanel:AddOption(option, function()
				if (type(arguments) == "table" and arguments.isArgTable) then
					if (arguments.Callback) then
						arguments.Callback()
					end
				elseif (arguments == "function") then
					arguments()
				end

				timer.Simple(FrameTime(), function()
					self:RemoveActiveToolTip()
				end)
			end)

			menuPanel.Items = menuPanel:GetChildren()
			local panel = menuPanel.Items[#menuPanel.Items]

			if (IsValid(panel)) then
				if (type(arguments) == "table") then
					if (arguments.toolTip) then
						--self:CreateMarkupToolTip(panel)
						--panel:SetMarkupToolTip(arguments.toolTip)
						--REPLACE THIS
					end
				end
			end
		end
	end, nil, true)

	if (Callback) then Callback(itemMenu) end

	itemMenu:SetMinimumWidth(100)
	
	if (itemTable.AdjustItemMenu) then
		itemTable:AdjustItemMenu(itemMenu, itemFunctions);
	else
		hook.Run("PlayerAdjustItemMenu", itemTable, itemMenu, itemFunctions);
	end;

	for k, v in pairs(itemFunctions) do
		local useText = (itemTable("useText") or "Use")
		local dropText = (itemTable("dropText") or "Drop")
		local destroyText = (itemTable("destroyText") or "Destroy")
		local repairName = "Repair";

		if ((!useText and v == "Use") or (useText and v == useText)) then
			local subMenu;
		
			if itemTable and itemTable.canUseOffhand then
				if hook.Run("CanPlayerDualWield") ~= false then
					local equipmentSlots = Clockwork.Client.equipmentSlots;

					for i, slot in pairs(itemTable.slots) do
						local slotItem = equipmentSlots[slot];

						if slotItem and slotItem.canUseOffhand then
							if !equipmentSlots[slot.."Offhand"] then
								if !subMenu then
									subMenu = itemMenu:AddSubMenu("Equip", function()
										if (itemTable) then
											if (itemTable.OnHandleUse) then
												itemTable:OnHandleUse(function()
													Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
												end)
											else
												Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
											end
										end
									end);
								end
								
								subMenu:AddOption(slotItem.name, function()
									if (itemTable.OnHandleUse) then
										itemTable:OnHandleUse(function()
											Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID, slotItem.uniqueID, slotItem.itemID);
										end)
									else
										Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID, slotItem.uniqueID, slotItem.itemID);
									end
								end)
							end
						end
					end
				end
			end
			
			if !subMenu then
				itemMenu:AddOption(v, function()
					if (itemTable) then
						if (itemTable.OnHandleUse) then
							itemTable:OnHandleUse(function()
								Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
							end)
						else
							Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
						end
					end
				end)
			end
		elseif (v == "Examine") then
			itemMenu:AddOption(v, function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction("examine", itemTable.uniqueID, itemTable.itemID);
				end
			end)
		elseif ((!repairName and v == "Repair") or (repairName and v == repairName)) then
			itemMenu:AddOption(v, function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction("repair", itemTable.uniqueID, itemTable.itemID);
				end
			end)
		elseif ((v == "Break Down") or (v == "Melt Down")) then
			itemMenu:AddOption(v, function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction("breakdown", itemTable.uniqueID, itemTable.itemID);
				end
			end)
		elseif ((!dropText and v == "Drop") or (dropText and v == dropText)) then
			itemMenu:AddOption(v, function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction("drop", itemTable.uniqueID, itemTable.itemID);
				end
			end)
		elseif (!istable(v) and string.find(v, "Unload")) then
			itemMenu:AddOption(v, function()
				if (itemTable) then
					if itemTable.ammoMagazineSize then
						Clockwork.inventory:InventoryAction("magazineAmmo", itemTable.uniqueID, itemTable.itemID);
					else
						Clockwork.inventory:InventoryAction("ammo", itemTable.uniqueID, itemTable.itemID);
					end
				end
			end)
		elseif ((!destroyText and v == "Destroy") or (destroyText and v == destroyText)) then
			local subMenu = itemMenu:AddSubMenu(v)

			subMenu:AddOption("Yes", function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction("destroy", itemTable.uniqueID, itemTable.itemID);
				end
			end)

			subMenu:AddOption("No", function() end)
		elseif (type(v) == "table") then
			itemMenu:AddOption(v.title, function()
				local defaultAction = true

				if (itemTable.HandleOptions) then
					local transmit, data = itemTable:HandleOptions(v.name)

					if (transmit) then
						netstream.Start("MenuOption", {option = v.name, data = data, item = itemTable.itemID})
						defaultAction = false
					end
				end

				if (defaultAction) then
					Clockwork.inventory:InventoryAction(v.name, itemTable.uniqueID, itemTable.itemID);
				end
			end)
		else
			if (itemTable.OnCustomFunction) then
				itemTable:OnCustomFunction(v)
			end

			itemMenu:AddOption(v, function()
				if (itemTable) then
					Clockwork.inventory:InventoryAction(v, itemTable.uniqueID, itemTable.itemID);
				end
			end)
		end
	end

	itemMenu:Open()
	Clockwork.kernel.ActiveItemMenu = itemMenu;
end

-- A function to handle an item's spawn icon right click.
function Clockwork.kernel:HandleItemSpawnIconRightClick(itemTable, spawnIcon)
	if (itemTable.OnHandleRightClick) then
		local functionName = itemTable:OnHandleRightClick()

		if (functionName and functionName != "Use") then
			local customFunctions = itemTable.customFunctions

			if (customFunctions and table.HasValue(customFunctions, functionName)) then
				if (itemTable.OnCustomFunction) then
					itemTable:OnCustomFunction(v)
				end
			end

			Clockwork.inventory:InventoryAction(string.lower(functionName), itemTable.uniqueID, itemTable.itemID);
			
			return
		end
	end

	if (itemTable.OnUse) then
		if (itemTable.OnHandleUse) then
			itemTable:OnHandleUse(function()
				Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
			end)
		else
			Clockwork.inventory:InventoryAction("use", itemTable.uniqueID, itemTable.itemID);
		end
	end
end

-- A function to set a panel's perform layout callback.
function Clockwork.kernel:SetOnLayoutCallback(target, Callback)
	if (target.PerformLayout) then
		target.OldPerformLayout = target.PerformLayout

		-- Called when the panel's layout is performed.
		function target.PerformLayout()
			target:OldPerformLayout() Callback(target)
		end
	end
end

-- A function to set the active titled DMenu.
function Clockwork.kernel:SetTitledMenu(menuPanel, title)
	Clockwork.TitledMenu = {
		menuPanel = menuPanel,
		title = title
	}
end

--[[
-- A function to draw a markup tool tip.
function Clockwork.kernel:DrawMarkupToolTip(markupObject, x, y, alpha, text)
end;

-- A function to override a markup object's draw function.
function Clockwork.kernel:OverrideMarkupDraw(markupObject, sCustomFont)
end
--]]

-- A function to override a markup object's draw function.
function Clockwork.kernel:OverrideMarkupDraw(markupObject, sCustomFont)
	function markupObject:Draw(xOffset, yOffset, hAlign, vAlign, alphaOverride)
		for k, v in pairs(self.blocks) do
			if (!v.colour) then
				debug.Trace();
				return;
			end;
		
			local alpha = v.colour.a or 255;
			local y = yOffset + (v.height - v.thisY) + v.offset.y;
			local x = xOffset;
			
			if (hAlign == TEXT_ALIGN_CENTER) then
				x = x - (self.totalWidth / 2);
			elseif (hAlign == TEXT_ALIGN_RIGHT) then
				x = x - self.totalWidth;
			end;
			
			x = x + v.offset.x;
			
			if (hAlign == TEXT_ALIGN_CENTER) then
				y = y - (self.totalHeight / 2);
			elseif (hAlign == TEXT_ALIGN_BOTTOM) then
				y = y - self.totalHeight;
			end;
			
			if (alphaOverride) then
				alpha = alphaOverride;
			end;
			
			Clockwork.kernel:OverrideMainFont(sCustomFont or v.font);
				Clockwork.kernel:DrawSimpleText(v.text, x, y, Color(v.colour.r, v.colour.g, v.colour.b, alpha));
			Clockwork.kernel:OverrideMainFont(false);
		end;
	end;
end;

-- A function to get markup from a color.
function Clockwork.kernel:ColorToMarkup(color)
	return "<color="..math.ceil(color.r)..","..math.ceil(color.g)..","..math.ceil(color.b)..">"
end

-- A function to markup text with a color.
function Clockwork.kernel:MarkupTextWithColor(text, color, scale)
	local fontName = Clockwork.fonts:GetMultiplied("cwTooltip", scale or 1);
	local finalText = text;
	
	if (color) then
		finalText = self:ColorToMarkup(color)..text.."</color>";
	end;
	
	finalText = "<font="..fontName..">"..finalText.."</font>";
	
	return finalText;
end;

--[[
	cash 08/01/2020
	completely removed markup because fuck markup and fuck kurozael, we're using derma now.
	the following is here to deal with any residual shit left in clockwork plugins or future ports.
--]]
do
	local MARKUP_OBJECT = {__index = MARKUP_OBJECT, text = ""};

	-- A function to add new text to the markup object.
	function MARKUP_OBJECT:Add(text, color, scale, noNewLine)
		if (self.text != "" and !noNewLine) then
			self.text = self.text.."\n";
		end;
		
		self.text = self.text..Clockwork.kernel:MarkupTextWithColor(
			Clockwork.config:Parse(text), color, scale
		);
	end;

	-- A function to add a new title to the markup object.
	function MARKUP_OBJECT:Title(title, color, scale)
		self:Add(title, Clockwork.option:GetColor("information"), 1.2);
	end;

	-- A function to get the markup object's text.
	function MARKUP_OBJECT:GetText()
		return self.text;
	end;

	function Clockwork.kernel:GetMarkupObject()
		return Clockwork.kernel:NewMetaTable(MARKUP_OBJECT);
	end;

	function Clockwork.kernel:GetActiveDermaToolTip()
		return Clockwork.ActiveDermaToolTip
	end

	function Clockwork.kernel:AddMarkupLine(markupText, text, color)
		print("Clockwork.kernel:AddMarkupLine called with text: "..text);
	end;

	function Clockwork.kernel:GetActiveMarkupToolTip()
		return self:GetActiveDermaToolTip();
	end;

	function Clockwork.kernel:CreateMarkupToolTip(panel)
		return self:CreateDermaToolTip(panel)
	end;
end;

-- A function to create a derma tool tip.
function Clockwork.kernel:CreateDermaToolTip(panel)
	panel.OldCursorExited = panel.OnCursorExited
	panel.OldCursorEntered = panel.OnCursorEntered
	panel.OldDoClick = panel.DoClick
	panel.OldDoRightClick = panel.DoRightClick
	panel.OldOnRemove = panel.OnRemove

	-- A function to set the panel's associated item table.
	function panel.SetItemTable(panel, itemTable, bWeightless)
		if (itemTable and !table.IsEmpty(itemTable)) then
			panel.itemTable = itemTable
			panel.bWeightless = bWeightless or true;
		end;
	end;
	
	function panel.SetWeightless(bweightless)
		if (panel.itemTable and !table.IsEmpty(panel.itemTable)) then
			panel.bWeightless = bweightless or true;
		end;
	end;

	-- A function to get the panel's associated item table.
	function panel.GetItemTable(panel)
		return panel.itemTable;
	end;
	
	panel.IsToolTip = true;

	-- Called when the panel is removed.
	function panel.OnRemove(panel, ...)
		if (panel.OldOnRemove) then
			panel:OldOnRemove(...)
		end;

		if (IsValid(panel.tooltip)) then
			panel.tooltip:Remove();
			Clockwork.kernel:ClearToolTipPanel(panel)
		end;
	end;

	-- Called when the cursor enters the panel.
	function panel.DoRightClick(panel, ...)
		Clockwork.kernel:ClearToolTipPanel(panel)

		if (panel.OldDoRightClick) then
			panel:OldDoRightClick(...)
		end
	end
	
	panel.OldOnMousePressed = panel.OnMousePressed;
	function panel.OnMousePressed(panel, code)
		if (panel.OldOnMousePressed) then
			panel:OldOnMousePressed(code);
		end;
		
		if (code == MOUSE_LEFT) then
			if (IsValid(panel.tooltip)) then
				panel.tooltip:Open();
			end
		end;
	end;

	-- A function to set the panel's markup tool tip.
	function panel.SetMarkupToolTip(panel, text) end
	
	-- A function to set the panel's tool tip.
	function panel.SetToolTip(panel, toolTip) end
	
	-- A function to set the panel's callback.
	function panel:SetToolTipCallback(Callback)
		if (Callback and isfunction(Callback)) then
			panel.ToolTipCallback = Callback;
		end;
	end
	
	-- A function to allow the tooltip to be openable with left click.
	function panel:SetOpenable(Callback, openTitle)
		if (Callback and isfunction(Callback)) then
			panel.openable = true;
			panel.openCallback = Callback;
			panel.openTitle = openTitle;
		end;
	end;
	
	-- A function to set the panel's callback.
	function panel:SetToolTipTitle(title)
		if (title and isstring(title)) then
			panel.ToolTipTitle = title;
		end;
	end

	-- A function to get the panel's markup tool tip.
	function panel.GetMarkupToolTip(panel)
		return panel.DermaToolTip
	end

	return panel
end

-- A function to create a custom category panel.
function Clockwork.kernel:CreateCustomCategoryPanel(categoryName, parent)
	if (!parent.CategoryList) then
		parent.CategoryList = {}
	end

	local collapsibleCategory = vgui.Create("DCollapsibleCategory", parent)
		collapsibleCategory:SetExpanded(true)
		collapsibleCategory:SetPadding(2)
		collapsibleCategory:SetLabel(categoryName)
	parent.CategoryList[#parent.CategoryList + 1] = collapsibleCategory

	return collapsibleCategory
end

-- A function to draw the armor bar.
function Clockwork.kernel:DrawArmorBar()
	local armor = math.Clamp(Clockwork.Client:Armor(), 0, Clockwork.Client:GetMaxArmor())
	
	if (!self.armor) then
		self.armor = armor
	else
		if (self.armor != armor) then
			self.armor = math.Approach(self.armor, armor, 1)
		end
	end
	
	if (armor > 0) then
		Clockwork.bars:Add("ARMOR", Color(139, 174, 179, 255), "ARMOR", self.armor, Clockwork.Client:GetMaxArmor(), self.health < 10, 1)
	end
end

-- A function to draw the health bar.
function Clockwork.kernel:DrawHealthBar()
	local health = math.Clamp(Clockwork.Client:Health(), 0, Clockwork.Client:GetMaxHealth())
	
	if (!self.health) then
		self.health = health
	else
		if (self.health != health) then
			self.health = math.Approach(self.health, health, 1)
		end
	end
	
	if (health > 0) then
		Clockwork.bars:Add("HEALTH", Color(179, 46, 49, 255), "HEALTH", self.health, Clockwork.Client:GetMaxHealth(), self.health < 10, 2)
	end
end

-- A function to remove the active tool tip.
function Clockwork.kernel:RemoveActiveToolTip()
	ChangeTooltip()
end

-- A function to close active Derma menus.
function Clockwork.kernel:CloseActiveDermaMenus()
	CloseDermaMenus()
end

-- A function to register a background blur.
function Clockwork.kernel:RegisterBackgroundBlur(panel, fCreateTime)
	Clockwork.BackgroundBlurs[panel] = fCreateTime or SysTime()
end

-- A function to remove a background blur.
function Clockwork.kernel:RemoveBackgroundBlur(panel)
	Clockwork.BackgroundBlurs[panel] = nil
end

-- A function to draw the background blurs.
function Clockwork.kernel:DrawBackgroundBlurs()
	local scrH, scrW = ScrH(), ScrW()
	local sysTime = SysTime()

	if (!Clockwork.ScreenBlur) then
		Clockwork.ScreenBlur = Material("pp/blurscreen")
	end

	for k, v in pairs(Clockwork.BackgroundBlurs) do
		if (type(k) == "string" or (IsValid(k) and k:IsVisible())) then
			local fraction = math.Clamp((sysTime - v) / 1, 0, 1)
			local x, y = 0, 0

			surface.SetMaterial(Clockwork.ScreenBlur)
			surface.SetDrawColor(0, 0, 0, 255)

			for i = 0.33, 1, 0.33 do
				Clockwork.ScreenBlur:SetFloat("$blur", fraction * 5 * i)
				Clockwork.ScreenBlur:Recompute()

				if (render) then render.UpdateScreenEffectTexture()end

				surface.DrawTexturedRect(x, y, scrW, scrH)
			end

			surface.SetDrawColor(0, 0, 0, 200 * fraction)
			surface.DrawRect(x, y, scrW, scrH)
		end
	end
end

-- A function to get the notice panel.
function Clockwork.kernel:GetNoticePanel()
	if (IsValid(Clockwork.NoticePanel) and Clockwork.NoticePanel:IsVisible()) then
		return Clockwork.NoticePanel
	end
end

-- A function to set the notice panel.
function Clockwork.kernel:SetNoticePanel(noticePanel)
	Clockwork.NoticePanel = noticePanel
end

-- A function to add some cinematic text.
function Clockwork.kernel:AddCinematicText(text, color, barLength, hangTime, font, bThisOnly)
	local colorWhite = Clockwork.option:GetColor("white")
	local cinematicTable = {
		barLength = barLength or (ScrH() * 0.3),
		hangTime = hangTime or 3,
		color = color or colorWhite,
		font = font,
		text = text,
		add = 0
	}

	if (bThisOnly) then
		Clockwork.Cinematics[1] = cinematicTable
	else
		Clockwork.Cinematics[#Clockwork.Cinematics + 1] = cinematicTable
	end
end

-- A function to get whether the local player is using the tool gun.
function Clockwork.kernel:IsUsingTool()
	if (IsValid(Clockwork.Client:GetActiveWeapon())
	and Clockwork.Client:GetActiveWeapon():GetClass() == "gmod_tool") then
		return true
	else
		return false
	end
end

-- A function to get whether the local player is using the camera.
function Clockwork.kernel:IsUsingCamera()
	if (IsValid(Clockwork.Client:GetActiveWeapon())
	and Clockwork.Client:GetActiveWeapon():GetClass() == "gmod_camera") then
		return true
	else
		return false
	end
end

-- A function to get the target ID data.
function Clockwork.kernel:GetTargetIDData()
	return Clockwork.TargetIDData
end

-- A function to calculate the screen fading.
function Clockwork.kernel:CalculateScreenFading()
	if (hook.Run("ShouldPlayerScreenFadeBlack")) then
		if (!Clockwork.BlackFadeIn) then
			if (Clockwork.BlackFadeOut) then
				Clockwork.BlackFadeIn = Clockwork.BlackFadeOut
			else
				Clockwork.BlackFadeIn = 0
			end
		end

		Clockwork.BlackFadeIn = math.Clamp(Clockwork.BlackFadeIn + (FrameTime() * 20), 0, 255)
		Clockwork.BlackFadeOut = nil
		--self:DrawSimpleGradientBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, Clockwork.BlackFadeIn))
	else
		if (Clockwork.BlackFadeIn) then
			Clockwork.BlackFadeOut = Clockwork.BlackFadeIn
		end

		Clockwork.BlackFadeIn = nil

		if (Clockwork.BlackFadeOut) then
			Clockwork.BlackFadeOut = math.Clamp(Clockwork.BlackFadeOut - (FrameTime() * 40), 0, 255)
			--self:DrawSimpleGradientBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, Clockwork.BlackFadeOut))

			if (Clockwork.BlackFadeOut == 0) then
				Clockwork.BlackFadeOut = nil
			end
		end
	end
end

-- A function to draw a cinematic.
function Clockwork.kernel:DrawCinematic(cinematicTable, curTime)
	local maxBarLength = cinematicTable.barLength or (ScrH() / 13);
	local font = cinematicTable.font or Clockwork.option:GetFont("cinematic_text");
	
	if (cinematicTable.goBack and curTime > cinematicTable.goBack) then
		cinematicTable.add = math.Clamp(cinematicTable.add - 2, 0, maxBarLength);
		
		if (cinematicTable.add == 0) then
			table.remove(Clockwork.Cinematics, 1);
			cinematicTable = nil;
		end;
	else
		cinematicTable.add = math.Clamp(cinematicTable.add + 1, 0, maxBarLength);
		
		if (cinematicTable.add == maxBarLength and !cinematicTable.goBack) then
			cinematicTable.goBack = curTime + cinematicTable.hangTime;
		end;
	end;
	
	if (cinematicTable) then
		draw.RoundedBox(0, 0, -maxBarLength + cinematicTable.add, ScrW(), maxBarLength, Color(0, 0, 0, 255));
		draw.RoundedBox(0, 0, ScrH() - cinematicTable.add, ScrW(), maxBarLength, Color(0, 0, 0, 255));
		draw.SimpleText(cinematicTable.text, font, ScrW() / 2, cinematicTable.add - (maxBarLength / 2), cinematicTable.color, 1, 1);
	end
end;

-- A function to draw the cinematic introduction.
function Clockwork.kernel:DrawCinematicIntro(curTime)
	local cinematicInfo = hook.Run("GetCinematicIntroInfo");
	local colorWhite = Clockwork.option:GetColor("white");
	local colorInfo = Clockwork.option:GetColor("information");
	
	if (cinematicInfo) then
		if (Clockwork.CinematicScreenAlpha and Clockwork.CinematicScreenTarget) then
			Clockwork.CinematicScreenAlpha = math.Approach(Clockwork.CinematicScreenAlpha, Clockwork.CinematicScreenTarget, 1);
			
			if (Clockwork.CinematicScreenAlpha == Clockwork.CinematicScreenTarget) then
				if (Clockwork.CinematicScreenTarget == 255) then
					if (!Clockwork.CinematicScreenGoBack) then
						Clockwork.CinematicScreenGoBack = curTime + 2.5;
					end;
				else
					Clockwork.CinematicScreenDone = true;
				end;
			end;
			
			if (Clockwork.CinematicScreenGoBack and curTime >= Clockwork.CinematicScreenGoBack) then
				Clockwork.CinematicScreenGoBack = nil;
				Clockwork.CinematicScreenTarget = 0;
			end;
			
			if (!Clockwork.CinematicScreenDone and cinematicInfo.credits) then
				local font = Clockwork.option:GetFont("intro_text_tiny");
				local textWidth, textHeight = self:GetCachedTextSize(font, cinematicInfo.credits);
				local alpha = math.Clamp(Clockwork.CinematicScreenAlpha, 0, 255);
				
				self:OverrideMainFont(font);
					self:DrawSimpleText(cinematicInfo.credits, ScrW() / 8, ScrH() * 0.75, Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha));
				self:OverrideMainFont(false);
				
				if (cinematicInfo.subCredits) then
					self:OverrideMainFont(font);
						self:DrawSimpleText(cinematicInfo.subCredits, ScrW() / 8, ScrH() * 0.75 + 32, Color(colorInfo.r, colorInfo.g, colorInfo.b, alpha));
					self:OverrideMainFont(false);
				end;
			end;
		else
			Clockwork.CinematicScreenAlpha = 0;
			Clockwork.CinematicScreenTarget = 255;
		end;
	end;
end;

-- A function to draw the cinematic introduction bars.
function Clockwork.kernel:DrawCinematicIntroBars()
	if (config.Get("draw_intro_bars"):Get()) then
		local maxBarLength = ScrH() / 13;
		
		if (!Clockwork.CinematicBarsTarget and !Clockwork.CinematicBarsAlpha) then
			Clockwork.CinematicBarsAlpha = 0;
			Clockwork.CinematicBarsTarget = 255;
		end;
		
		Clockwork.CinematicBarsAlpha = math.Approach(Clockwork.CinematicBarsAlpha, Clockwork.CinematicBarsTarget, 1);
		
		if (Clockwork.CinematicScreenDone) then
			if (Clockwork.CinematicScreenBarLength != 0) then
				Clockwork.CinematicScreenBarLength = math.Clamp((maxBarLength / 255) * Clockwork.CinematicBarsAlpha, 0, maxBarLength);
			end;
			
			if (Clockwork.CinematicBarsTarget != 0) then
				Clockwork.CinematicBarsTarget = 0;
			end;
			
			if (Clockwork.CinematicBarsAlpha == 0) then
				Clockwork.CinematicBarsDrawn = true;
			end;
		elseif (Clockwork.CinematicScreenBarLength != maxBarLength) then
			if (!Clockwork.IntroBarsMultiplier) then
				Clockwork.IntroBarsMultiplier = 1;
			else
				Clockwork.IntroBarsMultiplier = math.Clamp(Clockwork.IntroBarsMultiplier + (FrameTime() * 8), 1, 12);
			end;
			
			Clockwork.CinematicScreenBarLength = math.Clamp((maxBarLength / 255) * math.Clamp(Clockwork.CinematicBarsAlpha * Clockwork.IntroBarsMultiplier, 0, 255), 0, maxBarLength);
		end;
		
		draw.RoundedBox(0, 0, 0, ScrW(), Clockwork.CinematicScreenBarLength, Color(0, 0, 0, 255));
		draw.RoundedBox(0, 0, ScrH() - Clockwork.CinematicScreenBarLength + 1, ScrW(), maxBarLength, Color(0, 0, 0, 255));
	end;
end;

-- A function to draw the cinematic info.
function Clockwork.kernel:DrawCinematicInfo()
	if (!Clockwork.CinematicInfoAlpha and !Clockwork.CinematicInfoSlide) then
		Clockwork.CinematicInfoAlpha = 255;
		Clockwork.CinematicInfoSlide = 0;
	end;
	
	Clockwork.CinematicInfoSlide = math.Approach(Clockwork.CinematicInfoSlide, 255, 1);
	
	if (Clockwork.CinematicScreenAlpha and Clockwork.CinematicScreenTarget) then
		Clockwork.CinematicInfoAlpha = math.Approach(Clockwork.CinematicInfoAlpha, 0, 1);
		
		if (Clockwork.CinematicInfoAlpha == 0) then
			Clockwork.CinematicInfoDrawn = true;
		end;
	end;
	
	local cinematicInfo = hook.Run("GetCinematicIntroInfo");
	local colorWhite = Clockwork.option:GetColor("white");
	local colorInfo = Clockwork.option:GetColor("information");
	
	local cinematicInfo = hook.Run("GetCinematicIntroInfo");
	local colorWhite = Clockwork.option:GetColor("white");
	local colorInfo = Clockwork.option:GetColor("information");
	
	if (cinematicInfo) then
		if (cinematicInfo.title) then
			local cinematicInfoTitle = string.upper(cinematicInfo.title);
			local introTextBigFont = Clockwork.option:GetFont("intro_text_big");
			local introTextSmallFont = Clockwork.option:GetFont("intro_text_small")
			local textWidth, textHeight = Clockwork.kernel:GetCachedTextSize(introTextBigFont, cinematicInfoTitle);
			
			draw.SimpleText(cinematicInfoTitle, introTextBigFont, ScrW() / 2, ScrH() / 2, Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha), 1, 1);
		
			if (cinematicInfo.text) then
				draw.SimpleText(string.upper(cinematicInfo.text), introTextSmallFont, (ScrW() / 2) - (textWidth / 2), (ScrH() / 2) + (textHeight / 2), Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha));
			end;
		elseif (cinematicInfo.text) then
			draw.SimpleText(string.upper(cinematicInfo.text), introTextSmallFont, ScrW() / 2, (ScrH() / 2) + 40, Color(colorWhite.r, colorWhite.g, colorWhite.b, alpha), 0, 1);
		end;
	end;
end;

-- A function to draw some door text.
function Clockwork.kernel:DrawDoorText(entity, eyePos, eyeAngles, font, nameColor, textColor)
	local entityColor = entity:GetColor()

	if (entityColor.a <= 0 or entity:IsEffectActive(EF_NODRAW)) then
		return
	end

	local doorData = Clockwork.entity:CalculateDoorTextPosition(entity)

	if (!doorData.hitWorld) then
		local frontY = -26
		local backY = -26
		local alpha = self:CalculateAlphaFromDistance(256, eyePos, entity:GetPos())

		if (alpha <= 0) then
			return
		end

		local name = hook.Run("GetDoorInfo", entity, DOOR_INFO_NAME)
		local text = hook.Run("GetDoorInfo", entity, DOOR_INFO_TEXT)

		if (name or text) then
			local nameWidth, nameHeight = self:GetCachedTextSize(font, name or "")
			local textWidth, textHeight = self:GetCachedTextSize(font, text or "")
			local boxAlpha = math.min(alpha, 255)

			if (textWidth > nameWidth) then
				nameWidth = textWidth
			end

			local scale = math.abs((doorData.width * 0.75) / nameWidth)
			local nameScale = math.min(scale, 0.05)
			local textScale = math.min(scale, 0.03)
			local longHeight = (nameHeight + textHeight + 8)
			local backX = -nameWidth / 2 - 32
			local blackCol = Color(0, 0, 0, math.Clamp(boxAlpha, 0, 130))
			local whiteCol = Color(220, 220, 220, boxAlpha)
			local boxWidth = nameWidth + 64

			nameWidth = math.Clamp(nameWidth, 0, 1500)

			cam.Start3D2D(doorData.position, doorData.angles, 0.03)
				draw.RoundedBox(0, backX, frontY - 5, boxWidth, longHeight + 14, blackCol)
				draw.RoundedBox(0, backX, frontY - 8, boxWidth, 3, whiteCol)
				draw.RoundedBox(0, backX, frontY + longHeight + 8, boxWidth, 3, whiteCol)
			cam.End3D2D()

			cam.Start3D2D(doorData.positionBack, doorData.anglesBack, 0.03)
				draw.RoundedBox(0, backX, frontY - 5, boxWidth, longHeight + 14, blackCol)
				draw.RoundedBox(0, backX, frontY - 8, boxWidth, 3, whiteCol)
				draw.RoundedBox(0, backX, frontY + longHeight + 8, boxWidth, 3, whiteCol)
			cam.End3D2D()

			if (name) then
				if (!text or text == "") then
					nameColor = textColor or nameColor
				end

				cam.Start3D2D(doorData.position, doorData.angles, nameScale)
					self:OverrideMainFont(font)
						frontY = self:DrawInfo(name, 0, frontY, nameColor, alpha, nil, nil, 3)
					self:OverrideMainFont(false)
				cam.End3D2D()

				cam.Start3D2D(doorData.positionBack, doorData.anglesBack, nameScale)
					self:OverrideMainFont(font)
						backY = self:DrawInfo(name, 0, backY, nameColor, alpha, nil, nil, 3)
					self:OverrideMainFont(false)
				cam.End3D2D()
			end

			if (text) then
				cam.Start3D2D(doorData.position, doorData.angles, textScale)
					self:OverrideMainFont(font)
						frontY = self:DrawInfo(text, 0, frontY, textColor, alpha, nil, nil, 3)
					self:OverrideMainFont(false)
				cam.End3D2D()

				cam.Start3D2D(doorData.positionBack, doorData.anglesBack, textScale)
					self:OverrideMainFont(font)
						backY = self:DrawInfo(text, 0, backY, textColor, alpha, nil, nil, 3)
					self:OverrideMainFont(false)
				cam.End3D2D()
			end
		end
	end
end

-- A function to get whether the local player's character screen is open.
function Clockwork.kernel:IsCharacterScreenOpen(isVisible)
	if (Clockwork.character:IsPanelOpen()) then
		local panel = Clockwork.character:GetPanel()

		if (isVisible) then
			if (panel) then
				return panel:IsVisible()
			end
		else
			return panel != nil
		end
	end
end

-- A function to save schema data.
function Clockwork.kernel:SaveSchemaData(fileName, data)
	if (type(data) != "table") then
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] The '"..fileName.."' schema data has failed to save.\nUnable to save type "..type(data)..", table required.\n")

		return
	end

	_file.Write("clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt", self:Serialize(data))
end

-- A function to delete schema data.
function Clockwork.kernel:DeleteSchemaData(fileName)
	_file.Delete("clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt")
end

-- A function to check if schema data exists.
function Clockwork.kernel:SchemaDataExists(fileName)
	return _file.Exists("clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt", "DATA")
end

-- A function to find schema data in a directory.
function Clockwork.kernel:FindSchemaDataInDir(directory)
	return _file.Find("clockwork/schemas/"..self:GetSchemaFolder().."/"..directory, "LUA", "namedesc")
end

-- A function to restore schema data.
function Clockwork.kernel:RestoreSchemaData(fileName, failSafe)
	if (!fileName) then return failSafe; end

	if (self:SchemaDataExists(fileName)) then
		local data = _file.Read("clockwork/schemas/"..self:GetSchemaFolder().."/"..fileName..".txt", "DATA")

		if (data) then
			local bSuccess, value = pcall(self.Deserialize, self, data)

			if (bSuccess and value != nil) then
				return value
			else
				if (value) then
					MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] '"..fileName.."' schema data has failed to restore.\n"..value.."\n")
				end

				self:DeleteSchemaData(fileName)
			end
		end
	end

	if (failSafe != nil) then
		return failSafe
	else
		return {}
	end
end

-- A function to restore Clockwork data.
function Clockwork.kernel:RestoreClockworkData(fileName, failSafe)
	if (self:ClockworkDataExists(fileName)) then
		local data = _file.Read("clockwork/"..fileName..".txt", "DATA")

		if (data) then
			local bSuccess, value = pcall(self.Deserialize, self, data)

			if (bSuccess and value != nil) then
				return value
			else
				MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] '"..fileName.."' clockwork data has failed to restore.\n"..value.."\n")

				self:DeleteClockworkData(fileName)
			end
		end
	end

	if (failSafe != nil) then
		return failSafe
	else
		return {}
	end
end

-- A function to save Clockwork data.
function Clockwork.kernel:SaveClockworkData(fileName, data)
	if (type(data) != "table") then
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] The '"..fileName.."' clockwork data has failed to save.\nUnable to save type "..type(data)..", table required.\n")

		return
	end

	_file.Write("clockwork/"..fileName..".txt", self:Serialize(data))
end

-- A function to check if Clockwork data exists.
function Clockwork.kernel:ClockworkDataExists(fileName)
	return _file.Exists("clockwork/"..fileName..".txt", "DATA")
end

-- A function to delete Clockwork data.
function Clockwork.kernel:DeleteClockworkData(fileName)
	_file.Delete("clockwork/"..fileName..".txt")
end

-- A function to run a Clockwork command.
function Clockwork.kernel:RunCommand(command, ...)
	RunConsoleCommand("cwCmd", command, ...)
end

-- A function to get whether the local player is choosing a character.
function Clockwork.kernel:IsChoosingCharacter()
	if (Clockwork.character:GetPanel()) then
		return Clockwork.character:IsPanelOpen()
	else
		return true
	end
end

-- A function to include the schema.
function Clockwork.kernel:IncludeSchema()
	local schemaFolder = self:GetSchemaFolder()

	if (schemaFolder and type(schemaFolder) == "string") then
		self:LoadSchema()
	end
end

do
	local cache = {}

	function surface.DrawCircle(x, y, radius, passes)
		if (!x or !y or !radius) then
			error("surface.DrawCircle - Too few arguments to function call (3 expected)")
		end

		-- In case no passes variable was passed, in which case we give a normal smooth circle.
		passes = passes or 100

		local id = x.."|"..y.."|"..radius.."|"..passes
		local info = cache[id]

		if (!info) then
			info = {}

			for i = 1, passes + 1 do
				local degInRad = i * math.pi / (passes * 0.5)

				info[i] = {
					x = x + math.cos(degInRad) * radius,
					y = y + math.sin(degInRad) * radius
				}
			end

			cache[id] = info
		end

		draw.NoTexture() -- Otherwise we draw a transparent circle.
		surface.DrawPoly(info)
	end


	local function scaleVertices(tblVertices, iScaleX, iScaleY)
		for k, v in pairs(tblVertices) do
			v.x = v.x * iScaleX
			v.y = v.y * iScaleY
		end
	end

	function surface.DrawPartialCircle(percentage, x, y, radius, passes)
		if (!percentage or !x or !y or !radius) then
			error("surface.DrawPartialCircle - Too few arguments to function call (4 expected)")
		end

		passes = passes or 360

		local id = percentage.."|"..x.."|"..y.."|"..radius.."|"..passes
		local info = cache[id]

		if (!info) then
			info = {}

			local startAngle, endAngle, step = -90, 360 / 100 * percentage - 90, 360 / passes

			if (math.abs(startAngle - endAngle) != 0) then
				table.insert(info, {x = 0, y = 0})
			end

			for i = startAngle, endAngle + step, step do
				i = math.Clamp(i, startAngle, endAngle)

				local rads = math.rad(i)
				local x = math.cos(rads)
				local y = math.sin(rads)

				table.insert(info, {x = x, y = y})
			end

			for k, v in ipairs(info) do
				v.x = v.x * radius + x
				v.y = v.y * radius + y
			end

			cache[id] = info
		end

		surface.DrawPoly(info)
	end

	function surface.DrawOutlinedCircle(x, y, radius, thickness, passes)
		render.ClearStencil()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(28)
			render.SetStencilFailOperation(STENCIL_REPLACE)

			render.SetStencilCompareFunction(STENCIL_EQUAL)
				surface.DrawCircle(x, y, radius - (thickness or 1), passes)
			render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
				surface.DrawCircle(x, y, radius, passes)
		render.SetStencilEnable(false)
		render.ClearStencil()
	end

	function surface.DrawPartialOutlinedCircle(percentage, x, y, radius, thickness, passes)
		render.ClearStencil()
		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)
			render.SetStencilReferenceValue(28)
			render.SetStencilFailOperation(STENCIL_REPLACE)

			render.SetStencilCompareFunction(STENCIL_EQUAL)
				surface.DrawPartialCircle(percentage, x, y, radius - (thickness or 1), passes)
			render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
				surface.DrawPartialCircle(percentage, x, y, radius, passes)
		render.SetStencilEnable(false)
		render.ClearStencil()
	end
end

function Derma_NumRequest(strTitle, strText, nDefaultValue, min, max, dec, fnEnter, fnCancel, strButtonText, strButtonCancelText)
	local Window = vgui.Create("DFrame")
	Window:SetTitle(strTitle or "Message Title (First Parameter)")
	Window:SetDraggable(false)
	Window:ShowCloseButton(false)
	Window:SetBackgroundBlur(true)
	Window:SetDrawOnTop(true)

	local InnerPanel = vgui.Create("DPanel", Window)
	InnerPanel:SetPaintBackground(false)

	local Text = vgui.Create("DLabel", InnerPanel)
	Text:SetText(strText or "Message Text (Second Parameter)")
	Text:SizeToContents()
	Text:SetContentAlignment(5)
	Text:SetTextColor(Color(255, 255, 255))

	local NumSlider = vgui.Create("DNumSlider", InnerPanel)
	NumSlider:SetValue(nDefaultValue or 0)
	NumSlider:SetMin(min or 0)
	NumSlider:SetMax(max or 256)
	NumSlider:SetDecimals(dec or 0)

	local ButtonPanel = vgui.Create("DPanel", Window)
	ButtonPanel:SetTall(30)
	ButtonPanel:SetPaintBackground(false)

	local Button = vgui.Create("DButton", ButtonPanel)
	Button:SetText(strButtonText or "OK")
	Button:SizeToContents()
	Button:SetTall(20)
	Button:SetWide(Button:GetWide() + 20)
	Button:SetPos(5, 5)
	Button.DoClick = function() Window:Close() fnEnter(NumSlider:GetValue()) end

	local ButtonCancel = vgui.Create("DButton", ButtonPanel)
	ButtonCancel:SetText(strButtonCancelText or "Cancel")
	ButtonCancel:SizeToContents()
	ButtonCancel:SetTall(20)
	ButtonCancel:SetWide(Button:GetWide() + 20)
	ButtonCancel:SetPos(5, 5)
	ButtonCancel.DoClick = function() Window:Close() if (fnCancel) then fnCancel(NumSlider:GetValue()) end end
	ButtonCancel:MoveRightOf(Button, 5)

	ButtonPanel:SetWide(Button:GetWide() + 5 + ButtonCancel:GetWide() + 10)

	local w, h = Text:GetSize()
	w = math.max(w, 400)

	Window:SetSize(w + 50, h + 25 + 75 + 10)
	Window:Center()

	InnerPanel:StretchToParent(5, 25, 5, 45)

	Text:StretchToParent(5, 5, 5, 35)

	NumSlider:StretchToParent(5, nil, 5, nil)
	NumSlider:AlignBottom(5)

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom(8)

	Window:MakePopup()
	Window:DoModal()

	return Window
end

local entityMeta = FindMetaTable("Entity")
local weaponMeta = FindMetaTable("Weapon")
local playerMeta = FindMetaTable("Player")

-- A function to get whether a player has a trait.
function playerMeta:HasTrait(uniqueID)
	if self.cwTraits then
		return table.HasValue(self.cwTraits, uniqueID);
	end
	
	return false;
end;

-- A function to get a player's country flag.
function playerMeta:GetFlag()
	if (self:IsBot()) then
		--return "vgui/titlebardisabledicon" -- Bots get a special flag.
	end;
	
	if (self:GetNetVar("CountryCode")) then
		return "flags16/"..string.lower(self:GetNetVar("CountryCode"))..".png";
	else
		return false; -- Return false to show the default flag.
	end;
end;

-- A function to get a player's country code.
function playerMeta:GetCountryCode()
	if (self == Clockwork.Client) then
		return system.GetCountry();
	else
		return string.upper(self:GetNetVar("CountryCode", "UNKNOWN"));
	end;
end;

entityMeta.ClockworkFireBullets = entityMeta.ClockworkFireBullets or entityMeta.FireBullets
weaponMeta.OldGetPrintName = weaponMeta.OldGetPrintName or weaponMeta.GetPrintName
playerMeta.SteamName = playerMeta.SteamName or playerMeta.Name

-- A function to make a player fire bullets.
function entityMeta:FireBullets(bulletInfo)
	if (self:IsPlayer()) then
		hook.Run("PlayerAdjustBulletInfo", self, bulletInfo)
	end

	hook.Run("EntityFireBullets", self, bulletInfo)
	return self:ClockworkFireBullets(bulletInfo)
end

-- A function to get a weapon's print name.
function weaponMeta:GetPrintName()
	local name;
	local itemTable = item.GetByWeapon(self);

	if (itemTable) then
		name = itemTable:GetName()
	else
		name = self:OldGetPrintName()
	end
	
	if self:GetNWString("activeShield"):len() > 0 then
		local shieldTable = GetTable(self:GetNWString("activeShield"));
		
		if shieldTable and shieldTable.name then
			return name.." & "..shieldTable.name;
		end
	elseif self:GetNWString("activeOffhand"):len() > 0 then
		local weaponTable = weapons.GetStored(self:GetNWString("activeOffhand"));

		if weaponTable and weaponTable.PrintName then
			if weaponTable.PrintName == self.PrintName then
				if self.DualNameOverride then
					return self.DualNameOverride;
				else
					return "Dual "..self.PrintName.."s";
				end
			else
				local tab = {self.PrintName, weaponTable.PrintName};
			
				table.sort(tab);
			
				return tab[1].." & "..tab[2];
			end
		end
	end
	
	return name;
end

-- A function to get a player's name.
function playerMeta:Name(bRealName)
	local name = (!bRealName and self:GetNetVar("NameOverride")) or self:GetDTString(STRING_NAME)

	if (!name or name == "") then
		return self:SteamName()
	else
		return name
	end
end

-- A function to get a player's playback rate.
function playerMeta:GetPlaybackRate()
	return self.cwPlaybackRate or 1
end

-- A function to get whether a player is noclipping.
function playerMeta:IsNoClipping()
	return Clockwork.player:IsNoClipping(self)
end

-- A function to get whether a player is running.
function playerMeta:IsRunning(bNoWalkSpeed)
	if (self:Alive() and !self:IsRagdolled() and !self:InVehicle() and !self:Crouching() and self:GetDTBool(BOOL_ISRUNNING)) then
		if (self:GetVelocity():Length() >= self:GetWalkSpeed() or bNoWalkSpeed) then
			if self == Clockwork.Client and !self:KeyDown(IN_SPEED) then
				return false;
			end
			
			return true
		end
	end

	return false
end

-- A function to get a player's forced animation.
function playerMeta:GetForcedAnimation()
	local forcedAnimation = self:GetNetVar("ForceAnim")

	if (forcedAnimation != 0) then
		return {
			animation = forcedAnimation,
		}
	end
end

-- A function to get whether a player is ragdolled.
function playerMeta:IsRagdolled(exception, entityless)
	return Clockwork.player:IsRagdolled(self, exception, entityless)
end

-- A function to set a shared variable for a player.
-- Can't set them on client at all.
function playerMeta:SetSharedVar(key, value) end

-- A function to get a player's shared variable.
function playerMeta:GetSharedVar(key, default)
	return self:GetNetVar(key, default)
end

-- A function to get whether a player has initialized.
function playerMeta:HasInitialized()
	if (IsValid(self)) then
		return self:GetNetVar("Initialized")
	end
end

-- A function to get a player's gender.
function playerMeta:GetGender()
	if (self:GetNetVar("Gender") == nil) then return GENDER_MALE; end

	if (self:GetNetVar("Gender") == 1) then
		return GENDER_FEMALE
	else
		return GENDER_MALE
	end
end

-- A function to get a player's faction.
function playerMeta:GetFaction()
	local index = self:GetNetVar("Faction")

	if (Clockwork.faction:FindByID(index)) then
		return Clockwork.faction:FindByID(index).name
	else
		return "Unknown"
	end
end

-- A function to get a player's wages name.
function playerMeta:GetWagesName()
	return Clockwork.player:GetWagesName(self)
end

-- A function to get a player's data.
function playerMeta:GetData(key, default)
	local playerData = Clockwork.player:GetPlayerData(key)

	if (playerData and (!playerData.playerOnly or self == Clockwork.Client)) then
		return self:GetNetVar(key)
	end

	return default
end

-- A function to get a player's character data.
function playerMeta:GetCharacterData(key, default)
	local characterData = Clockwork.player:GetCharacterData(key)

	if (characterData and (!characterData.playerOnly or self == Clockwork.Client)) then
		return self:GetNetVar(key)
	end

	return default
end

-- A function to get a player's maximum armor.
function playerMeta:GetMaxArmor(armor)
	local maxArmor = self:GetNetVar("MaxAP") or 100

	if (maxArmor > 0) then
		return maxArmor
	else
		return 100
	end
end

-- A function to get a player's maximum health.
function playerMeta:GetMaxHealth(health)
	local maxHealth = self:GetNetVar("MaxHP") or 100

	if (maxHealth > 0) then
		return maxHealth
	else
		return 100
	end
end

-- A function to get a player's ragdoll state.
function playerMeta:GetRagdollState()
	return self:GetDTInt(INT_RAGDOLLSTATE)
end

-- A function to get a player's ragdoll entity.
function playerMeta:GetRagdollEntity()
	return Clockwork.player:GetRagdollEntity(self)
end

-- A function to get a player's rank within their faction.
function playerMeta:GetFactionRank(character)
	return Clockwork.player:GetFactionRank(self, character)
end

-- A function to get a player's chat icon.
function playerMeta:GetChatIcon()
	return Clockwork.player:GetChatIcon(self)
end

playerMeta.GetName = playerMeta.Name
playerMeta.Nick = playerMeta.Name;