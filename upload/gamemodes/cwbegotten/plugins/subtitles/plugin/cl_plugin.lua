--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.setting:AddCheckBox("Chat Box", "Enable subtitles for chat.", "cwShowCinematics", "Toggle subtitles for chat.");

-- A function to print text to the center of the screen.
function cwCinematicText:PrintTextCenter(text, delay, color, font)
	local centerTextFont = Clockwork.option:GetFont("auto_bar_text");
	local wrappedTable = {""};
	local scrW = ScrW();
	
	if font then
		if font == "Gore" then
			centerTextFont = Clockwork.option:GetFont("chat_box_text_gore");
		elseif font == "Voltism" then
			centerTextFont = Clockwork.option:GetFont("chat_box_text_voltist");
		end
	end

	Clockwork.kernel:WrapTextSpaced(text, centerTextFont, math.max(scrW * 0.4, 450), wrappedTable);

	self.cinematicTexts[#self.cinematicTexts + 1] = {
		targetAlpha = 255,
		alpha = 255,
		delay = delay,
		color = color,
		offset = math.random(-5, 5);
		font = centerTextFont,
		text = wrappedTable
	};
end;

Clockwork.datastream:Hook("cwPrintCinematicText", function(data)
	local text = data[1] or "Unknown...."
	local delay = data[2] or 5;
	local color = data[3] or Color(255, 255, 255, 255);
	
	cwCinematicText:PrintTextCenter("\""..text.."\"", delay, color);
	
	surface.PlaySound("common/talk.wav");
end);