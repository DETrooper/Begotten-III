--[[
	Begotten III: Jesus Wept
--]]

local cwSailing = cwSailing;

function cwSailing:GetProgressBarInfoAction(action, percentage)
	if (action == "burn_longship") then
		return {text = "You are setting the longship alight. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "extinguish_longship") then
		return {text = "You are trying to put out the flames. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "repair_longship") then
		return {text = "You are making repairs to the longship. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "repair_alarm") then
		return {text = "You are repairing the Gorewatch alarm. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "repair_steam_engine") then
		return {text = "You are repairing the steam engine. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "refuel_ironclad") then
		return {text = "You are adding Charcoal to the ironclad's steam engine. Click to cancel.", percentage = percentage, flash = percentage < 10};
	end
end

-- Called when the local player's item menu should be adjusted.
function cwSailing:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	if (itemTable.uniqueID == "scroll_longship" or itemTable.uniqueID == "scroll_ironclad") then
		if Clockwork.Client:GetFaction() == "Goreic Warrior" and Clockwork.Client:GetZone() == "gore" then
			if (game.GetMap() != "rp_begotten3" and game.GetMap() != "rp_district21" and game.GetMap() != "bg_district34") then
				return;
			end;
			
			--[[menuPanel:AddOption("Dock", function()
				Clockwork.inventory:InventoryAction("dock", itemTable.uniqueID, itemTable.itemID);
			end);]]--

			menuPanel:AddOption("Undock", function()
				Clockwork.inventory:InventoryAction("undock", itemTable.uniqueID, itemTable.itemID);
			end);
			
			menuPanel:AddOption("Rename", function()
				Clockwork.inventory:InventoryAction("rename", itemTable.uniqueID, itemTable.itemID);
			end);
		end
	end
end;

function cwSailing:SubModifyItemMarkupTooltip(category, maximumWeight, weight, condition, percentage, name, itemTable, x, y, width, height, frame, bShowWeight)
	if category == "Naval" then
		local health = itemTable:GetData("health");
		
		if health then
			if health > 0 then
				frame:AddText("Longship Health: "..tostring(health), Color(110, 30, 30), nil, 0.9);
			end
		end
	end
end

function cwSailing:CreateMenu(data)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
	local isAdmin = Clockwork.Client:IsAdmin();
	local zone = Clockwork.Client:GetZone();
	local map = game.GetMap();
		
	menu:SetMinimumWidth(150);
	
	if !data then
		data = {};
	end
	
	local entity = data.entity;
	
	if !IsValid(entity) then
		return;
	end
	
	local location = data.location;
	
	if data.ignitable then
		if !data.ignited and !data.destination then
			if Clockwork.Client:GetFaction() ~= "Goreic Warrior" then
				local activeWeapon = Clockwork.Client:GetActiveWeapon();
				
				if activeWeapon:IsValid() and activeWeapon:GetClass() == "cw_lantern" and Clockwork.Client:IsWeaponRaised(activeWeapon) then
					local oil = Clockwork.Client:GetNetVar("oil", 0);
				
					--if oil >= 75 then
					if oil >= 1 then
						menu:AddOption("Burn", function() Clockwork.Client:ConCommand("cw_BurnShip") end);
					end
				end
			end
		end
	end
	
	if isAdmin or data.cargoholdopenable then
		menu:AddOption("Cargo Hold", function() Clockwork.Client:ConCommand("cw_CargoHold") end);
	end
	
	menu:AddOption("Examine", function() Clockwork.Client:ConCommand("cw_CheckShipStatus") end);
	
	if data.ignited then
		menu:AddOption("Extinguish", function() Clockwork.Client:ConCommand("cw_ExtinguishShip") end);
	end
	
	if data.repairable then
		menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_RepairShip") end);
	end
	
	if data.destination and data.location and !string.find(zone, "sea_") then
		menu:AddOption("Abort Sailing", function() Clockwork.Client:ConCommand("cw_AbortSailing") end);
	end
	
	if data.isOwner then
		if data.entity:GetNWBool("freeSailing") then
			menu:AddOption("Disable Free Sailing", function() Clockwork.Client:ConCommand("cw_ShipToggleFreeSailing") end);
		else
			menu:AddOption("Enable Free Sailing", function() Clockwork.Client:ConCommand("cw_ShipToggleFreeSailing") end);
		end
		
		if data.location == "docks" then
			menu:AddOption("Dock", function() Clockwork.Client:ConCommand("cw_DockLongship") end);
		end
	end
	
	if data.sailable or (isAdmin and Clockwork.player:IsNoClipping(Clockwork.Client) and !data.destination) then
		local location = data.location;
		local submenu = menu:AddSubMenu("Sail", function() end);
			
		if location ~= "docks" then
			if location == "hell" or (location == "wastelandlava" and map == "rp_begotten3") or location == "styx" then
				submenu:AddOption("Sail through the River Styx to the Goreic Forest", function() Clockwork.Client:ConCommand("cw_MoveShipGoreForest") end);
			else
				submenu:AddOption("Sail through the High Seas to the Goreic Forest", function() Clockwork.Client:ConCommand("cw_MoveShipGoreForest") end);
			end
		end
			
		if zone ~= "wasteland" then
			if (location == "hell" or location == "styx") and map == "rp_begotten3" then
				submenu:AddOption("Sail through the River Styx to the Glazic Wasteland", function() Clockwork.Client:ConCommand("cw_MoveShipWasteland") end);
			else
				submenu:AddOption("Sail through the High Seas to the Glazic Wasteland", function() Clockwork.Client:ConCommand("cw_MoveShipWasteland") end);
			end
			
			if map == "rp_begotten3" then
				submenu:AddOption("Sail through the River Styx to the Lava Coast", function() Clockwork.Client:ConCommand("cw_MoveShipLava") end);
			end
		end
			
		if location ~= "hell" then
			submenu:AddOption("Sail through the River Styx to Hell", function() Clockwork.Client:ConCommand("cw_MoveShipHell") end);
		end
	end
	
	if isAdmin then
		menu:AddOption("(ADMIN) Toggle River Styx Enchantment", function() Clockwork.Client:ConCommand("cw_ShipToggleEnchantment") end);
	
		if location == "calm" or location == "rough" or location == "styx" then
			menu:AddOption("(ADMIN) Speed to Destination", function() Clockwork.Client:ConCommand("cw_ShipTimerSpeed") end);
			menu:AddOption("(ADMIN) Toggle Timer", function() Clockwork.Client:ConCommand("cw_ShipTimerPause") end);
		end
	end
	
	menu:Open();
	
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenAlarmMenu", function(alarmEnt)
	if IsValid(alarmEnt) then
		if (IsValid(menu)) then
			menu:Remove();
		end;
		
		local scrW = ScrW();
		local scrH = ScrH();
		local menu = DermaMenu();
		
		menu:SetMinimumWidth(150);
		
		menu:AddOption("Examine", function()
			Schema:EasyText("skyblue", "A jury-rigged alarm system with seismic sensors set to activate an alarm should a Goreic longship arrive. Note that the alarm is not powerful enough to be heard from the Tower of Light, and will only sound if Gorewatch has an occupying garrison.");
		end);
		
		if alarmEnt:GetNWBool("broken") then
			menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_RepairGorewatchAlarm") end);
		end
		
		menu:Open();
		menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
	end
end);

netstream.Hook("OpenLongshipMenu", function(data)
	cwSailing:CreateMenu(data);
end);

netstream.Hook("OpenSteamEngineMenu", function(steamEngineEnt)
	if IsValid(steamEngineEnt) then
		if (IsValid(menu)) then
			menu:Remove();
		end;
		
		local scrW = ScrW();
		local scrH = ScrH();
		local menu = DermaMenu();
		
		menu:SetMinimumWidth(150);
		
		menu:AddOption("Examine", function()
			if steamEngineEnt:GetNWBool("turnedOn") then
				Schema:EasyText("skyblue", "A salvaged steam engine restored to working order by Clan Shagalax. It powers the Ironclad Steamship to which it is bolted down. Spewing acrid smoke and deafening noise, it shakes violently and can be felt rattling the ship.");
			else
				Schema:EasyText("skyblue", "A salvaged steam engine restored to working order by Clan Shagalax. It powers the Ironclad Steamship to which it is bolted down, though it is not currently running.");
			end
		end);
		
		if steamEngineEnt:GetNWBool("broken") then
			menu:AddOption("Repair", function() Clockwork.Client:ConCommand("cw_SteamEngineRepair") end);
		else
			menu:AddOption("Add Fuel", function() Clockwork.Client:ConCommand("cw_SteamEngineFuel refuel") end);
			menu:AddOption("Check Fuel", function() Clockwork.Client:ConCommand("cw_SteamEngineFuel check") end);
		
			if steamEngineEnt:GetNWBool("turnedOn") then
				menu:AddOption("Turn Off Engine", function() Clockwork.Client:ConCommand("cw_SteamEngine off") end);
			else
				menu:AddOption("Turn On Engine", function() Clockwork.Client:ConCommand("cw_SteamEngine on") end);
			end
		end
		
		menu:Open();
		menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
	end
end);

netstream.Hook("DrowningCutscene", function(data)
	CreateSound(Clockwork.Client, "begotten/score5.mp3"):PlayEx(1, 100);
end);