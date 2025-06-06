--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("option", Clockwork)

local keys = Clockwork.option.keys or {}
Clockwork.option.keys = keys

local sounds = Clockwork.option.sounds or {}
Clockwork.option.sounds = sounds

-- A function to set a schema key.
function Clockwork.option:SetKey(key, value)
	keys[key] = value
end

-- A function to get a schema key.
function Clockwork.option:GetKey(key, lowerValue)
	local value = keys[key]

	if (lowerValue and isstring(value)) then
		return string.lower(value)
	else
		return value
	end
end

-- A function to set a schema sound.
function Clockwork.option:SetSound(name, sound)
	sounds[name] = sound
end

-- A function to get a schema sound.
function Clockwork.option:GetSound(name)
	return sounds[name]
end

-- A function to play a schema sound.
function Clockwork.option:PlaySound(name)
	local sound = self:GetSound(name)

	if (sound) then
		if (CLIENT) then
			surface.PlaySound(sound)
		else
			Clockwork.player:PlaySound(nil, sound)
		end
	end
end

Clockwork.option:SetKey("default_date", {month = 666, year = 666, day = 666});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1})
Clockwork.option:SetKey("default_days", {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"})
Clockwork.option:SetKey("description_business", "Order items for your business.")
Clockwork.option:SetKey("description_inventory", "Manage the items in your inventory.")
Clockwork.option:SetKey("description_directory", "All links to the manifesto.")
Clockwork.option:SetKey("description_system", "Access a variety of server-side options.")
Clockwork.option:SetKey("description_scoreboard", "See which players are on the server.")
Clockwork.option:SetKey("description_attributes", "Check the status of your attributes.")
Clockwork.option:SetKey("intro_background_url", "")
Clockwork.option:SetKey("intro_logo_url", "")
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl")
Clockwork.option:SetKey("model_cash", "models/items/jewels/purses/big_purse.mdl")
Clockwork.option:SetKey("format_singular_cash", "$%a")
Clockwork.option:SetKey("format_cash", "$%a")
Clockwork.option:SetKey("name_attributes", "Attributes")
Clockwork.option:SetKey("name_attribute", "Attribute")
Clockwork.option:SetKey("name_system", "System")
Clockwork.option:SetKey("name_scoreboard", "Scoreboard")
Clockwork.option:SetKey("name_directory", "Manifesto")
Clockwork.option:SetKey("name_inventory", "Inventory")
Clockwork.option:SetKey("name_business", "Business")
Clockwork.option:SetKey("name_destroy", "Destroy")
Clockwork.option:SetKey("schema_logo", "")
Clockwork.option:SetKey("intro_image", "")
Clockwork.option:SetKey("intro_sound", "music/HL2_song25_Teleporter.mp3")
Clockwork.option:SetKey("menu_music", "music/hl2_song32.mp3")
Clockwork.option:SetKey("name_cash", "Coin")
Clockwork.option:SetKey("name_drop", "Drop")
Clockwork.option:SetKey("top_bars", false)
Clockwork.option:SetKey("name_use", "Use")
Clockwork.option:SetKey("gradient", "gui/gradient_up")
Clockwork.option:SetKey("name_traits", "Traits");
Clockwork.option:SetKey("name_trait", "Trait");

Clockwork.option:SetSound("click_release", "begotten/ui/buttonclickrelease.wav")
Clockwork.option:SetSound("rollover", "begotten/ui/buttonrollover.wav")
Clockwork.option:SetSound("click", "begotten/ui/buttonclick.wav")
Clockwork.option:SetSound("tick", "common/talk.wav")

if (CLIENT) then
	Clockwork.option.fonts = Clockwork.option.fonts or {}
	Clockwork.option.colors = Clockwork.option.colors or {}

	-- A function to set a schema color.
	function Clockwork.option:SetColor(name, color)
		self.colors[name] = color
	end

	-- A function to get a schema color.
	function Clockwork.option:GetColor(name)
		return self.colors[name]
	end

	-- A function to set a schema font.
	function Clockwork.option:SetFont(name, font)
		self.fonts[name] = font
	end

	-- A function to get a schema font.
	function Clockwork.option:GetFont(name)
		return self.fonts[name]
	end

	Clockwork.option:SetColor("columnsheet_shadow_normal", Color(200, 200, 200, 255))
	Clockwork.option:SetColor("columnsheet_text_normal", Color(255, 255, 255, 255))
	Clockwork.option:SetColor("columnsheet_shadow_active", Color(150, 150, 150, 255))
	Clockwork.option:SetColor("columnsheet_text_active", Color(200, 200, 200, 255))

	Clockwork.option:SetColor("panel_background", Color(70, 70, 70, 255))
	Clockwork.option:SetColor("panel_outline", Color(0, 0, 0, 255))

	Clockwork.option:SetColor("basic_form_highlight", Color(0, 0, 0, 255))
	Clockwork.option:SetColor("basic_form_color", Color(0, 0, 0, 255))

	Clockwork.option:SetKey("icon_data_classes", {path = "tag", size = nil})
	Clockwork.option:SetKey("icon_data_settings", {path = "wrench", size = nil})
	Clockwork.option:SetKey("icon_data_system", {path = "cog", size = nil})
	Clockwork.option:SetKey("icon_data_scoreboard", {path = "list-alt", size = 3})
	Clockwork.option:SetKey("icon_data_inventory", {path = "inbox", size = nil})
	Clockwork.option:SetKey("icon_data_directory", {path = "book", size = nil})
	Clockwork.option:SetKey("icon_data_attributes", {path = "bar-chart", size = 2})
	Clockwork.option:SetKey("icon_data_business", {path = "briefcase", size = 2})
	Clockwork.option:SetKey("icon_data_traits", {path = "star", size = 2})

	Clockwork.option:SetKey("top_bar_width_scale", 0.3)

	Clockwork.option:SetKey("info_text_icon_size", 16)
	Clockwork.option:SetKey("info_text_red_icon", "icon16/exclamation.png")
	Clockwork.option:SetKey("info_text_green_icon", "icon16/tick.png")
	Clockwork.option:SetKey("info_text_orange_icon", "icon16/error.png")
	Clockwork.option:SetKey("info_text_blue_icon", "icon16/information.png")

	Clockwork.option:SetColor("scoreboard_name", Color(0, 0, 0, 255))
	Clockwork.option:SetColor("scoreboard_desc", Color(0, 0, 0, 255))

	Clockwork.option:SetColor("positive_hint", Color(100, 175, 100, 255))
	Clockwork.option:SetColor("negative_hint", Color(175, 100, 100, 255))
	Clockwork.option:SetColor("background", Color(0, 0, 0, 125))
	Clockwork.option:SetColor("foreground", Color(50, 50, 50, 125))
	Clockwork.option:SetColor("target_id", Color(50, 75, 100, 255))
	Clockwork.option:SetColor("white", Color(255, 255, 255, 255))

	Clockwork.option:SetColor("panel_primarycolor", Color(45, 45, 45, 255))
	Clockwork.option:SetColor("panel_primarycolor_blur", Color(45, 45, 45, 160))
	Clockwork.option:SetColor("panel_secondarycolor", Color(237, 97, 21))
	Clockwork.option:SetColor("panel_primarylight", Color(60, 60, 60, 255))
	Clockwork.option:SetColor("panel_primarylighter", Color(70, 70, 70, 255))
	Clockwork.option:SetColor("panel_primarylightest", Color(90, 90, 90, 255))
	Clockwork.option:SetColor("panel_primarydark", Color(39, 39, 39, 255))
	Clockwork.option:SetColor("panel_primarydarker", Color(22, 22, 22, 255))
	Clockwork.option:SetColor("panel_primarydarkest", Color(8, 8, 8, 255))
	Clockwork.option:SetColor("panel_textcolor", Color(240, 240, 240, 255))

	Clockwork.option:SetFont("schema_description", "cwMainText")
	Clockwork.option:SetFont("scoreboard_desc", "cwScoreboardDesc")
	Clockwork.option:SetFont("scoreboard_name", "cwScoreboardName")
	Clockwork.option:SetFont("player_info_text", "cwMainText")
	Clockwork.option:SetFont("intro_text_small", "cwIntroTextSmall")
	Clockwork.option:SetFont("intro_text_tiny", "cwIntroTextTiny")
	Clockwork.option:SetFont("menu_text_small", "Clockwork.menuTextSmall")
	Clockwork.option:SetFont("chat_box_syntax", "cwChatSyntax")
	Clockwork.option:SetFont("menu_text_huge", "Clockwork.menuTextHuge")
	Clockwork.option:SetFont("intro_text_big", "cwIntroTextBig")
	Clockwork.option:SetFont("info_text_font", "cwInfoTextFont")
	Clockwork.option:SetFont("menu_text_tiny", "Clockwork.menuTextTiny")
	Clockwork.option:SetFont("date_time_text", "Clockwork.menuTextSmall")
	Clockwork.option:SetFont("cinematic_text", "cwCinematicText")
	Clockwork.option:SetFont("target_id_text", "cwMainText")
	Clockwork.option:SetFont("auto_bar_text", "cwMainText")
	Clockwork.option:SetFont("menu_text_big", "Clockwork.menuTextBig")
	Clockwork.option:SetFont("chat_box_text", "cwChatSyntax")
	Clockwork.option:SetFont("large_3d_2d", "cwLarge3D2D")
	Clockwork.option:SetFont("hints_text", "cwIntroTextTiny")
	Clockwork.option:SetFont("main_text", "cwMainText")
	Clockwork.option:SetFont("bar_text", "cwMainText")
	Clockwork.option:SetFont("esp_text", "cwESPText")
	
	Clockwork.option:SetFont("chat_box_text_gore", "cwChatGore")
	Clockwork.option:SetFont("chat_box_text_voltist", "cwChatVoltist")
	Clockwork.option:SetFont("chat_box_text_mordred", "cwChatMordred")
end