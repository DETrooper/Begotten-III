--[[
	Begotten III: Jesus Wept
--]]

local cwScrapFactory = cwScrapFactory;

function cwScrapFactory:GetProgressBarInfoAction(action, percentage)
	if (action == "turn_scrapfactory_valve") then
		return {text = "You are turning the valve.", percentage = percentage, flash = percentage < 10};
	end
end

function cwScrapFactory:CreateMenu()
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);
	
	menu:AddOption("Turn Valve", function() Clockwork.Client:ConCommand("cw_TurnScrapFactoryValve") end);
	
	menu:Open();
	
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenScrapFactoryValveMenu", function(data)
	cwScrapFactory:CreateMenu();
end);

netstream.Hook("StartScrapFactoryAlarm", function(data)
	if Clockwork.Client:GetZone() == "scrapper" then
		Clockwork.Client.scrapAlarmSound = CreateSound(Clockwork.Client, "ambient/alarms/siren.wav");
		Clockwork.Client.scrapAlarmSound:PlayEx(0.5, 100);
	end
end);

netstream.Hook("StopScrapFactoryAlarm", function(data)
	if Clockwork.Client.scrapAlarmSound then
		Clockwork.Client.scrapAlarmSound:FadeOut(3);
	end
end);


netstream.Hook("ScrapFactoryExplosion", function(data)
	if Clockwork.Client:GetZone() == "scrapper" then
		surface.PlaySound("ambient/explosions/explode_3.wav");
	end
end);