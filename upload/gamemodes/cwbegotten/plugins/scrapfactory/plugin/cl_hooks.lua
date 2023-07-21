--[[
	Begotten III: Jesus Wept
--]]

local cwScrapFactory = cwScrapFactory;

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

Clockwork.datastream:Hook("OpenScrapFactoryValveMenu", function(data)
	cwScrapFactory:CreateMenu();
end);

Clockwork.datastream:Hook("StartScrapFactoryAlarm", function(data)
	if Clockwork.Client:GetZone() == "scrapper" then
		Clockwork.Client.scrapAlarmSound = CreateSound(Clockwork.Client, "ambient/alarms/siren.wav"):PlayEx(0.5, 100);
	end
end);

Clockwork.datastream:Hook("StopScrapFactoryAlarm", function(data)
	if Clockwork.Client.scrapAlarmSound then
		Clockwork.Client.scrapAlarmSound:FadeOut(3);
	end
end);


Clockwork.datastream:Hook("ScrapFactoryExplosion", function(data)
	if Clockwork.Client:GetZone() == "scrapper" then
		CreateSound(Clockwork.Client, "ambient/explosions/explode_3.wav"):PlayEx(1, 100);
	end
end);