local warmthTexts = {"Freezing to Death", "Really Cold", "Getting Cold", "Warm", "Temperature is a measure of one's exposure to the cold and body temperature. Becoming too cold will result in a variety of maluses such as reduced movement speed and increased hunger and fatigue gain, eventually leading to death."};

function cwWarmth:LerpColor(fraction, from, to)
    if(!IsColor(from) or !IsColor(to)) then return; end

    return Color(Lerp(fraction, from.r, to.r), Lerp(fraction, from.g, to.g), Lerp(fraction, from.b, to.b), (from.a) and Lerp(fraction, from.a, to.a) or nil);
end

cwWarmth.warmthColors = {
    max = Color(217, 107, 39),
    min = Color(52, 158, 235),
};

--[[function cwWarmth:GetBars(bars)
    if(!self.systemEnabled) then return; end

	local warmth = Clockwork.Client:GetLocalVar("warmth", 0);

    if (!warmth) then return; end

	local color = self:LerpColor(warmth/100, self.warmthColors.min, self.warmthColors.max);
	local barText = "Temperature";

    self.warmth = (self.warmth) and math.Approach(self.warmth, warmth, 1) or warmth;
	
	bars:Add("TEMPERATURE", color, barText, self.warmth, 100, self.warmth < 10);
end]]--

function cwWarmth:AddStatusIcons(iconFrame)
	iconFrame.iconTemperature = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", iconFrame));
	iconFrame.iconTemperature:SetSize(64, 64);
	iconFrame.iconTemperature:SetPos(36, 320);
	iconFrame.iconTemperature:SetImage("begotten/ui/othericons/thermometer.png");
	iconFrame.iconTemperature.text = vgui.Create("DLabel", iconFrame);
	iconFrame.iconTemperature.text:SetText("100%");
	iconFrame.iconTemperature.text:SetTextColor(Color(160, 145, 145));
	iconFrame.iconTemperature.text:SetFont("nov_IntroTextSmallDETrooper");
	iconFrame.iconTemperature.text:SetPos(100, 336);
	iconFrame.iconTemperature.text:SizeToContents();
	
	local x, y = iconFrame.iconTemperature:GetPos();
	
	iconFrame.iconTemperature:SetToolTipCallback(function(frame)
		cwWarmth:BuildTemperatureTooltip(x, y, frame:GetWide(), frame:GetTall(), frame);
	end);
	
	return x, y;
end

function cwWarmth:ModifyStatusEffects(tab)
	local warmth = Clockwork.Client:GetLocalVar("warmth", 100);
	
	if warmth <= 50 then
		table.insert(tab, {text = "(-) Hypothermia", color = Color(200, 40, 40)});
	end

	if(Clockwork.Client:GetLocalVar("hotSpringBuff", 0) >= CurTime() or Clockwork.Client:GetLocalVar("hotSpringTime", 0) >= 60) then
		table.insert(tab, {text = "(+) Refreshed", color = Color(0, 225, 0)});
	
	end

end

-- A function to get temperature's markup tooltip.
function cwWarmth:BuildTemperatureTooltip(x, y, width, height, frame)
	local warmth = Clockwork.Client:GetLocalVar("warmth", 100);
	
	local temperatureColor = self:LerpColor(warmth/100, self.warmthColors.min, self.warmthColors.max);
	local selectedText = math.Clamp(math.Round(warmth / 25), 1, 4);
	
	frame:AddText("Temperature", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
	frame:AddText(warmthTexts[5], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
	frame:AddBar(20, {{text = tostring(warmth).."%", percentage = warmth, color = temperatureColor, font = "DermaDefault", textless = true, noDisplay = true}}, warmthTexts[selectedText], temperatureColor);
end;

-- Called when the F1 Text is needed.
function cwWarmth:PostMainMenuRebuild(menu)
	if IsValid(menu) then
		local warmth = Clockwork.Client:GetLocalVar("warmth", 100);

		self.warmth = warmth

		if IsValid(menu.statusInfo) then
			local temperatureColor = self:LerpColor(warmth/100, self.warmthColors.min, self.warmthColors.max);
			
			menu.statusInfo.iconFrame.iconTemperature:SetColor(temperatureColor);
			menu.statusInfo.iconFrame.iconTemperature.text:SetTextColor(temperatureColor);
			menu.statusInfo.iconFrame.iconTemperature.text:SetText(tostring(math.Round(warmth)).."%");
			
			-- This is a lazy way to do this, but oh well. I don't feel like reworking how the side bar on the menu works right now.
			menu.statusInfo:SetSize(200, 939);
			menu.statusInfo:SetPos(ScrW() - 200, (ScrH() - 939) / 2);
			menu.statusInfo.iconFrame:SetSize(200, 384);
			menu.statusInfo.statusFrame:SetPos(0, 640);
		end
	end;
end

function cwWarmth:ClockworkInitialized()
	if cwBeliefs then
		local fortitudeTree = cwBeliefs.stored["fortitude"];
		
		if fortitudeTree and fortitudeTree.beliefs then
			if fortitudeTree.beliefs[4]["unyielding"] then
				fortitudeTree.beliefs[4]["unyielding"].description = fortitudeTree.beliefs[4]["unyielding"].description.." Increases your base insulation value by 20%.";
			end
		end
	end
end