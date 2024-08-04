--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Clockwork.ConVars.ITEMCONTAINERESP = Clockwork.kernel:CreateClientConVar("cwItemContainerESP", 0, false, true)
Clockwork.ConVars.ITEMSPAWNERESP = Clockwork.kernel:CreateClientConVar("cwItemSpawnerESP", 0, false, true)

Clockwork.datastream:Hook("ItemContsESPInfo", function(data)
	if data then
		cwItemSpawner.itemContainers = data[1];
		cwItemSpawner.superCrate = data[2];
	end
end);

Clockwork.datastream:Hook("ItemSpawnESPInfo", function(data)
	if data then
		if data[1] then
			cwItemSpawner.SpawnLocations = data[1];
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
end;

-- Called when the HUD is painted.
--[[function cwItemSpawner:HUDPaint()
	if (self.SpawnLocations) then
		if (table.IsEmpty(self.SpawnLocations)) then
			self.SpawnLocations = nil;
			
			return;
		end;
		
		for k, v in pairs (self.SpawnLocations) do
			if (!v or !isvector(v)) then
				self.SpawnLocations[k] = nil;
			end;

			local position = v.position;
			local name = "Item Spawn";
			
			if (v.category) then
				name = name.." ("..v.category..")";
			end;
			
			draw.RoundedBox(4, position.x, position.y, 4, 4, Color(255, 255, 255))
			draw.SimpleText(name, "Default", position.x, position.y + 4, Color(200, 200, 255), 1);
		end;
	end;
end;]]--

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
			elseif name == "cwItemSpawnerESP" then
				if newValue == "1" then
					Clockwork.kernel:RunCommand("ItemSpawnerToggleESP");
				elseif newValue == "0" then
					Clockwork.kernel:RunCommand("ItemSpawnerToggleESP");
				end
			end
		end
	end
end

Clockwork.setting:AddCheckBox("Admin ESP", "Show item spawn points.", "cwItemSpawnerESP", "Click to enable/disable the item spawner ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Admin ESP", "Show item spawner containers.", "cwItemContainerESP", "Click to enable/disable the item spawner container ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);