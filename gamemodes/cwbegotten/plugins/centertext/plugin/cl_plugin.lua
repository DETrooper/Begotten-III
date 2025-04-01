--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- A function to print text to the center of the screen.
function cwCenterText:PrintTextCenter(text, delay, color, class, heightOverride)
	local scrW = ScrW();
	local wrappedTable = {""};
	
	if (!self.centerTexts) then
		self.centerTexts = {};
	end;
	
	local fadeTime;
	
	if (class == "introduction") then
		fadeTime = 128;
	elseif (class == "exposition") then
		fadeTime = 96;
	else
		fadeTime = 64;
	end;

	--text = "\""..text.."\""
	
	Clockwork.kernel:WrapTextSpaced(text, "AHintHeader", heightOverride or scrW * 0.4, wrappedTable);

	if (!delay) then
		delay = 5;
	end;
	
	if (!color) then
		color = Color(255, 255, 255, 200);
	end;
	
	self.centerTexts[#self.centerTexts + 1] = {
		targetAlpha = 255,
		alpha = 0,
		delay = delay,
		color = color,
		text = wrappedTable,
		fadeTime = fadeTime,
	};
end;

netstream.Hook("cwPrintTextCenter", function(data)
	local text = data[1] or "Unknown...."
	local delay = data[2] or 5;
	local color = data[3] or Color(255, 255, 255, 255);
	local class = data[4] or "center";
	
	cwCenterText:PrintTextCenter(text, delay, color, class);
end);

surface.CreateFont("AHintHeader", {
	font		= "Times New Roman",
	size		= Clockwork.kernel:ScaleToWideScreen(24),
	weight		= 700,
	antialiase	= true,
	shadow 		= true
});

surface.CreateFont("AHintSubHeader", {
	font		= "Arial",
	size		= Clockwork.kernel:ScaleToWideScreen(16),
	weight		= 700,
	antialiase	= true,
	shadow 		= true
});
