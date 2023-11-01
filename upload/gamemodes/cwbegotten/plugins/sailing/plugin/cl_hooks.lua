--[[
	Begotten III: Jesus Wept
--]]

local cwSailing = cwSailing;

-- Called when the local player's item menu should be adjusted.
function cwSailing:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	if (itemTable.uniqueID == "scroll_longship") then
		if Clockwork.Client:GetFaction() == "Goreic Warrior" and Clockwork.Client:GetZone() == "gore" then
			if (game.GetMap() != "rp_begotten3") then
				return;
			end;
			
			menuPanel:AddOption("Dock", function()
				Clockwork.inventory:InventoryAction("dock", itemTable.uniqueID, itemTable.itemID);
			end);

			menuPanel:AddOption("Undock", function()
				Clockwork.inventory:InventoryAction("undock", itemTable.uniqueID, itemTable.itemID);
			end);
		end
	end
end;

function cwSailing:CreateMenu(ignitable, ignited, repairable, sailable, destination, cargoholdopenable)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
	local isAdmin = Clockwork.Client:IsAdmin();
	local zone = Clockwork.Client:GetZone();
		
	menu:SetMinimumWidth(150);
	
	--[[if ignitable then
		if ignited == false and destination == false then
			--if (!FACTION_GOREIC) then
				menu:AddOption("Burn", function() Clockwork.Client:ConCommand("cw_BurnShip") end);
			--end
		end
	end]]--
	
	if isAdmin or cargoholdopenable then
		menu:AddOption("Cargo Hold", function() Clockwork.Client:ConCommand("cw_CargoHold") end);
	end
	
	menu:AddOption("Examine", function() Clockwork.Client:ConCommand("cw_CheckShipStatus") end);
	
	if ignited then
		menu:AddOption("Extinguish", function() Clockwork.Client:ConCommand("cw_ExtinguishShip") end);
	end
	
	--if (FACTION_GOREIC) then
		if repairable then
			menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_RepairShip") end);
		end
	--end
	
	if sailable or (isAdmin and !destination) then
		local submenu = menu:AddSubMenu("Sail", function() end);
			
		if zone ~= "gore" then
			submenu:AddOption("Sail through the High Seas to the Goreic Forest", function() Clockwork.Client:ConCommand("cw_MoveShipGoreForest") end);
		end
			
		if zone ~= "wasteland" then
			submenu:AddOption("Sail through the High Seas to the Glazic Wasteland", function() Clockwork.Client:ConCommand("cw_MoveShipWasteland") end);
			submenu:AddOption("Sail through the River Styx to the Pillars of Creation", function() Clockwork.Client:ConCommand("cw_MoveShipPillars") end);
		end
			
		if zone ~= "hell" then
			submenu:AddOption("Sail through the River Styx to Hell", function() Clockwork.Client:ConCommand("cw_MoveShipHell") end);
		end
	end
	
	if isAdmin then
		menu:AddOption("(ADMIN) Toggle Hell Enchantment", function() Clockwork.Client:ConCommand("cw_ShipToggleEnchantment") end);
	
		if zone == "sea_calm" or zone == "sea_rough" or zone == "sea_styx" then
			menu:AddOption("(ADMIN) Speed to Destination", function() Clockwork.Client:ConCommand("cw_ShipTimerSpeed") end);
			menu:AddOption("(ADMIN) Toggle Timer", function() Clockwork.Client:ConCommand("cw_ShipTimerPause") end);
		end
	end
	
	menu:Open();
	
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

Clockwork.datastream:Hook("OpenLongshipMenu", function(ignitable, ignited, repairable, sailable, destination, cargoholdopenable)
	cwSailing:CreateMenu(ignitable, ignited, repairable, sailable, destination, cargoholdopenable);
end);

Clockwork.datastream:Hook("DrowningCutscene", function(data)
	CreateSound(Clockwork.Client, "begotten/score5.mp3"):PlayEx(1, 100);
end);