--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when the foreground HUD should be painted.
function cwCenterText:HUDPaint()
	local colorWhite = Clockwork.option:GetColor("white");
	local frameTime = FrameTime();
	local curTime = CurTime();
	local scrW = ScrW();
	local scrH = ScrH();
	local x, y = scrW / 2, scrH * 0.5 + 128;
	
	if (!self.centerTexts) then 
		return;
	end;
	
	if (table.Count(self.centerTexts) > 1) then
		table.remove(self.centerTexts, 1);
	end;
	
	local centerText = self.centerTexts[1];
	
	if (!centerText) then
		return;
	end;

	if (!centerText.fadeBack or curTime >= centerText.fadeBack) then
		centerText.alpha = math.Approach(centerText.alpha, centerText.targetAlpha, frameTime * centerText.fadeTime);
	end;

	if (centerText.targetAlpha == 0 and centerText.alpha == 0) then
		table.remove(self.centerTexts, 1); return;
	elseif (centerText.targetAlpha == 255 and centerText.alpha == 255 and !centerText.fadeBack) then
		centerText.targetAlpha = 0;
		centerText.fadeBack = curTime + centerText.delay;
	end;
	
	for k, v in ipairs (centerText.text) do
		Clockwork.kernel:OverrideMainFont("AHintHeader");
			y = Clockwork.kernel:DrawInfo(v, x, y, centerText.color, centerText.alpha, nil, nil, 1);
		Clockwork.kernel:OverrideMainFont(false);
	end;
end;