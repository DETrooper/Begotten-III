--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Clockwork.ConVars.ITEMCONTAINERESP = Clockwork.kernel:CreateClientConVar("cwItemContainerESP", 0, false, true)
Clockwork.ConVars.ITEMSPAWNERESP = Clockwork.kernel:CreateClientConVar("cwItemSpawnerESP", 0, false, true)
Clockwork.ConVars.ITEMCONTAINERSPAWNERESP = Clockwork.kernel:CreateClientConVar("cwItemContainerSpawnerESP", 0, false, true)
Clockwork.ConVars.SUPERCRATESPAWNERESP = Clockwork.kernel:CreateClientConVar("cwSupercrateSpawnerESP", 0, false, true)

netstream.Hook("ItemContsESPInfo", function(data)
	if data then
		cwItemSpawner.itemContainers = data[1];
		cwItemSpawner.superCrate = data[2];
	end
end);

netstream.Hook("ItemSpawnESPInfo", function(data)
	if data then
		if data[1] then
			cwItemSpawner.SpawnLocations = data[1];
		end
	end
end);

netstream.Hook("ContainerSpawnESPInfo", function(data)
	if data then
		if data[1] then
			cwItemSpawner.ContainerLocations = data[1];
		end
	end
end);

netstream.Hook("SupercrateSpawnESPInfo", function(data)
	if data then
		if data[1] then
			cwItemSpawner.SupercrateLocations = data[1];
		end
	end
end);

-- Called when the local player's item menu should be adjusted.
function cwItemSpawner:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	if (itemTable.breakdownItems) then
		if (!itemTable.breakdownTools) then
			menuPanel:AddOption("Breakdown", function()
				Clockwork.inventory:InventoryAction("breakdown", itemTable.uniqueID, itemTable.itemID, toolItem.uniqueID, toolItem.itemID);
			end);
		else
			local subMenu = nil;
			local tools = {};
			
			for k, v in pairs (itemTable.breakdownTools) do
				local toolItem = item.FindByID(k);
				
				if (toolItem and Clockwork.Client:HasItemByID(k)) then
					if (!subMenu) then
						subMenu = menuPanel:AddSubMenu("Breakdown using...");
					end;
					
					local optionPanel = subMenu:AddOption(toolItem.name, function()
						Clockwork.inventory:InventoryAction("breakdown", itemTable.uniqueID, itemTable.itemID, toolItem.uniqueID, toolItem.itemID);
					end);
					
					Clockwork.kernel:CreateDermaToolTip(optionPanel);
					optionPanel:SetItemTable(toolItem);
				end;
			end;
		end;
	end;
end;

function cwItemSpawner:GetAdminESPInfo(info)
	if (Clockwork.ConVars.ITEMCONTAINERESP and Clockwork.ConVars.ITEMCONTAINERESP:GetInt() == 1) then
		if (self.itemContainers) then
			local curTime = CurTime();
			
			for i = 1, #self.itemContainers do
				local container = self.itemContainers[i].container;

				if IsValid(container) then
					info[#info + 1] = {
						position = container:GetPos(),
						text = "Item Spawn Container - Time Left: "..tostring(math.Round(self.itemContainers[i].lifeTime - curTime));
					};
				end
			end;
		end;
		
		if (self.superCrate) then
			local curTime = CurTime();
			
			if IsValid(self.superCrate.supercrate) then
				info[#info + 1] = {
					position = self.superCrate.supercrate:GetPos(),
					text = "Supercrate - Time Left: "..tostring(math.Round(self.superCrate.lifeTime - curTime));
					color = Color(255, 215, 0);
				};
			end
		end;
	end;
	
	if (Clockwork.ConVars.ITEMSPAWNERESP and Clockwork.ConVars.ITEMSPAWNERESP:GetInt() == 1) then
		if (self.SpawnLocations) then
			if (table.IsEmpty(self.SpawnLocations)) then
				self.SpawnLocations = nil;
				
				return;
			end;
			
			for k, v in pairs (self.SpawnLocations) do
				if (!v or !isvector(v.position)) then
					self.SpawnLocations[k] = nil;
					
					continue;
				end;

				local position = v.position;
				local name = "Item Spawn";
				
				if (v.category) then
					name = name.." ("..v.category..")";
				end;
				
				--draw.RoundedBox(4, position.x, position.y, 4, 4, Color(255, 255, 255))
				--draw.SimpleText(name, "Default", position.x, position.y + 4, Color(200, 200, 255), 1);
				
				info[#info + 1] = {
					position = position,
					text = name;
					color = Color(200, 200, 255);
				};
			end;
		end;
	end;
	
	if (Clockwork.ConVars.ITEMCONTAINERSPAWNERESP and Clockwork.ConVars.ITEMCONTAINERSPAWNERESP:GetInt() == 1) then
		if (self.ContainerLocations) then
			if (table.IsEmpty(self.ContainerLocations)) then
				self.ContainerLocations = nil;
				
				return;
			end;
			
			for k, v in pairs (self.ContainerLocations) do
				for i, v2 in ipairs(v) do
					if (!v2 or !isvector(v2.pos)) then
						self.ContainerLocations[k][i] = nil;
						
						continue;
					end;

					local position = v2.pos;
					local name = "Item Container Spawn ".."("..k..")";

					--draw.RoundedBox(4, position.x, position.y, 4, 4, Color(255, 255, 255))
					--draw.SimpleText(name, "Default", position.x, position.y + 4, Color(200, 200, 255), 1);
					
					info[#info + 1] = {
						position = position,
						text = name;
						color = Color(200, 100, 255);
					};
				end;
			end;
		end;
	end;
	
	if (Clockwork.ConVars.SUPERCRATESPAWNERESP and Clockwork.ConVars.SUPERCRATESPAWNERESP:GetInt() == 1) then
		if (self.SupercrateLocations) then
			if (table.IsEmpty(self.SupercrateLocations)) then
				self.SupercrateLocations = nil;
				
				return;
			end;
			
			for k, v in pairs (self.SupercrateLocations) do
				if (!v or !isvector(v.pos)) then
					self.SupercrateLocations[k] = nil;
					
					continue;
				end;

				local position = v.pos;
				local name = "Supercrate Spawn";
				
				--draw.RoundedBox(4, position.x, position.y, 4, 4, Color(255, 255, 255))
				--draw.SimpleText(name, "Default", position.x, position.y + 4, Color(200, 200, 255), 1);
				
				info[#info + 1] = {
					position = position,
					text = name;
					color = Color(200, 100, 255);
				};
			end;
		end;
	end;
end;

function cwItemSpawner:ClockworkConVarChanged(name, previousValue, newValue)
	local curTime = CurTime();
	
	if (!Clockwork.Client.FuckCooldown or Clockwork.Client.FuckCooldown < curTime) then
		Clockwork.Client.FuckCooldown = curTime + 0.1;
		
		if Clockwork.Client:IsAdmin() then
			if name == "cwItemContainerESP" then
				if newValue == "1" then
					Clockwork.kernel:RunCommand("ItemSpawnerContainerToggleESP");
				elseif newValue == "0" then
					Clockwork.kernel:RunCommand("ItemSpawnerContainerToggleESP");
				end
			end
		end
	end
end

Clockwork.setting:AddCheckBox("Admin ESP - Spawn Points", "Show active item spawner containers.", "cwItemContainerESP", "Click to toggle the item spawner container ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Admin ESP - Spawn Points", "Show item container spawn points.", "cwItemContainerSpawnerESP", "Click to toggle the item spawner ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Admin ESP - Spawn Points", "Show item ground spawn points.", "cwItemSpawnerESP", "Click to toggle the item spawner ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Admin ESP - Spawn Points", "Show supercrate spawn points.", "cwSupercrateSpawnerESP", "Click to toggle the item spawner ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);