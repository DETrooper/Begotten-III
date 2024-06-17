--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when the F1 Text is needed.
function cwEncumberment:GetPlayerInfoText(playerInfoText)
	local clientInventory = Clockwork.inventory:GetClient();
	local inventoryWeight = Clockwork.inventory:CalculateWeight(clientInventory);
	local maximumWeight = Clockwork.player:GetMaxWeight();
	
	if (inventoryWeight > maximumWeight) then
		playerInfoText:Add("overencumbered", "You are over-encumbered!")
	end;
end;

-- Called when the top screen HUD should be painted.
function cwEncumberment:PreDateTimeDrawn(info)
	local clientInventory = Clockwork.inventory:GetClient();
	local inventoryWeight = Clockwork.inventory:CalculateWeight(clientInventory);
	local maximumWeight = Clockwork.player:GetMaxWeight();
	
	if (inventoryWeight > maximumWeight) then
		local encumberedFont = Clockwork.option:GetFont("hints_text");
		local colorRed = Clockwork.option:GetColor("negative_hint");
		
		local text = string.utf8upper("You are overencumbered!");

		Clockwork.kernel:OverrideMainFont(encumberedFont);
			info.y = Clockwork.kernel:DrawInfo(text, info.x, info.y, colorRed, 255, true);
		Clockwork.kernel:OverrideMainFont(false);
		
		return info;
	end;
end;