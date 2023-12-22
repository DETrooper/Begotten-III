--[[
	Begotten III: Jesus Wept
--]]

-- 5th is description.
local needTexts = {
	["corruption"] = {"Untainted", "Tainted", "Corrupted", "No Hope Remains", "Corruption represents the effect of various demonic and unholy forces on your character. It is usually increased by partaking in unholy acts or through lack of prayer. Corruption negatively impacts faith gain, and high levels of corruption can lead to demonic possession or suspicion and execution by the clergy."},
	["hunger"] = {"Sated", "Hungry", "Very Hungry", "Starved", "Hunger is a measure of your character's nourishment. To survive, you must acquire food on a regular basis. Hunger will also affect the rate of blood regeneration."},
	["thirst"] = {"Sated", "Thirsty", "Very Thirsty", "Dehydrated", "Thirst is a measure of your character's hydration. To survive, you must acquire water on a regular basis. Thirst will also affect the rate of blood regeneration and will slow stamina regeneration when low."},
	["sleep"] = {"Rested", "Drowsy", "Tired", "Exhausted", "Fatigue is a measure of your character's exhaustion, primarily accrued over time spent awake, although other factors can influence it. Fatigue can be reduced through sleeping or via certain consumables, and when low will adversely affect stamina regeneration."},
	["sleepVoltist"] = {"Fully Operational", "Operational", "Low Battery", "Systems Shutting Down", "For Voltists with the 'Yellow and Black' belief, fatigue is instead a measure of one's energy. It is decreased over time or by using exoskeleton abilities, and can be replenished by consuming tech or self-electrocuting."},
};

local needsInverted = {"hunger", "thirst"};

-- Called when the F1 Text is needed.
function cwCharacterNeeds:PostMainMenuRebuild(menu)
	if IsValid(menu) then
		local hunger = tonumber(Clockwork.Client:GetSharedVar("hunger"));
		local thirst = tonumber(Clockwork.Client:GetSharedVar("thirst"));
		local corruption = tonumber(Clockwork.Client:GetSharedVar("corruption"));
		local sleep = tonumber(Clockwork.Client:GetSharedVar("sleep"));

		self.hunger = math.Round(hunger);
		self.thirst = math.Round(thirst);
		self.corruption = math.Round(corruption);
		self.sleep = math.Round(sleep);

		if IsValid(menu.statusInfo) then
			local hungerColor = Color(50 + hunger, 100 - hunger, 0, 225);
			local thirstColor = Color(50 + thirst, 100 - thirst, 0, 225);
			local corruptionColor = Color(50 + corruption, 100 - corruption, 0, 225);
			local sleepColor = Color(50 + sleep, 100 - sleep, 0, 225);
		
			menu.statusInfo.iconFrame.iconHunger:SetColor(hungerColor);
			menu.statusInfo.iconFrame.iconHunger.text:SetTextColor(hungerColor);
			menu.statusInfo.iconFrame.iconHunger.text:SetText(tostring(100 - self.hunger).."%");
			
			menu.statusInfo.iconFrame.iconThirst:SetColor(thirstColor);
			menu.statusInfo.iconFrame.iconThirst.text:SetTextColor(thirstColor);
			menu.statusInfo.iconFrame.iconThirst.text:SetText(tostring(100 - self.thirst).."%");
			
			menu.statusInfo.iconFrame.iconCorruption:SetColor(corruptionColor);
			menu.statusInfo.iconFrame.iconCorruption.text:SetTextColor(corruptionColor);
			menu.statusInfo.iconFrame.iconCorruption.text:SetText(tostring(self.corruption).."%");
			
			menu.statusInfo.iconFrame.iconSleep:SetColor(sleepColor);
			menu.statusInfo.iconFrame.iconSleep.text:SetTextColor(sleepColor);
			menu.statusInfo.iconFrame.iconSleep.text:SetText(tostring(self.sleep).."%");
		end
	end;
end

-- A function to get a need's markup tooltip.
function cwCharacterNeeds:BuildNeedTooltip(need, x, y, width, height, frame)
	local needNumber = tonumber(Clockwork.Client:GetSharedVar(need));
	local needTextTable = needTexts[need];
	
	if need == "sleep" and cwBeliefs and cwBeliefs:HasBelief("yellow_and_black") then
		needTextTable = needTexts["sleepVoltist"];
	end
	
	if needNumber and needTextTable then
		if table.HasValue(needsInverted, need) then
			local needColor = Color(needNumber, 100 - needNumber, 0, 225);
			local needName = string.upper(string.sub(need, 1, 1))..string.sub(need, 2, #need);
			local selectedText = math.Clamp(math.Round(needNumber / 25), 1, 4);
			
			frame:AddText(needName, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddText(needTextTable[5], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
			frame:AddBar(20, {{text = tostring(needNumber).."%", percentage = 100 - needNumber, color = needColor, font = "DermaDefault", textless = true, noDisplay = true}}, needTextTable[selectedText], needColor);
		else
			local needColor = Color(needNumber, 100 - needNumber, 0, 225);
			local needName = string.upper(string.sub(need, 1, 1))..string.sub(need, 2, #need);
			local selectedText = math.Clamp(math.Round(needNumber / 25), 1, 4);
			
			if needName == "Sleep" then
				if cwBeliefs and cwBeliefs:HasBelief("yellow_and_black") then 
					needName = "Energy";
				else
					needName = "Fatigue";
				end
			end
			
			frame:AddText(needName, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddText(needTextTable[5], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
			frame:AddBar(20, {{text = tostring(needNumber).."%", percentage = needNumber, color = needColor, font = "DermaDefault", textless = true, noDisplay = true}}, needTextTable[selectedText], needColor);
		end
	end
end;

function cwCharacterNeeds:ModifyStatusEffects(tab)
	local hunger = tonumber(Clockwork.Client:GetSharedVar("hunger"));
	local thirst = tonumber(Clockwork.Client:GetSharedVar("thirst"));
	local corruption = tonumber(Clockwork.Client:GetSharedVar("corruption"));
	local sleep = tonumber(Clockwork.Client:GetSharedVar("sleep"));
	
	if hunger >= 75 then
		table.insert(tab, {text = "(-) Starvation", color = Color(200, 40, 40)});
	end
	
	if thirst >= 75 then
		table.insert(tab, {text = "(-) Dehydration", color = Color(200, 40, 40)});
	end
	
	if corruption >= 75 then
		table.insert(tab, {text = "(-) Corrupted", color = Color(200, 40, 40)});
	end
	
	if sleep >= 75 then
		if cwBeliefs and cwBeliefs:HasBelief("yellow_and_black") then
			table.insert(tab, {text = "(-) Low Battery", color = Color(200, 40, 40)});
		else
			table.insert(tab, {text = "(-) Exhausted", color = Color(200, 40, 40)});
		end
	end
end

-- Called when the screenspace effects are rendered.
function cwCharacterNeeds:RenderScreenspaceEffects()
	if Clockwork.Client:HasInitialized() then
		local hunger = tonumber(Clockwork.Client:GetSharedVar("hunger", 0));
		local thirst = tonumber(Clockwork.Client:GetSharedVar("thirst", 0));
		
		if hunger > 90 or thirst > 90 then
			DrawMotionBlur(0.05, 1.5, 0.01)
		end;
	end
end;