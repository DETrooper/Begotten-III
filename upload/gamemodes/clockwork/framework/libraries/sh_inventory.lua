--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("inventory", Clockwork)

-- A function to add an instance to a table.
function Clockwork.inventory:AddInstance(inventory, itemTable, quantity)
	quantity = quantity or 1

	if (itemTable == nil) then
		return false
	end

	if (!itemTable:IsInstance()) then
		debug.Trace()
		return false
	end

	if (!inventory[itemTable.uniqueID]) then
		inventory[itemTable.uniqueID] = {}
	end

	inventory[itemTable.uniqueID][itemTable.itemID] = itemTable

	if (quantity != 1) then
		self:AddInstance(inventory, item.CreateInstance(itemTable.uniqueID), quantity - 1)
	end

	return itemTable
end

-- A function to calculate the space of an inventory.
function Clockwork.inventory:CalculateSpace(inventory)
	local space = 0

	for k, v in pairs(self:GetAsItemsList(inventory)) do
		local spaceUsed = v.space
		if (spaceUsed) then space = space + spaceUsed; end
	end

	return space
end

-- A function to calculate the weight of an inventory.
function Clockwork.inventory:CalculateWeight(inventory)
	local weight = 0

	for k, v in pairs(self:GetAsItemsList(inventory)) do
		if (v.weight) then
			weight = weight + v.weight
		end
	end

	return weight
end

-- A function to create a duplicate of an inventory.
function Clockwork.inventory:CreateDuplicate(inventory)
	local duplicate = {}
	
	if inventory then
		for k, v in pairs(inventory) do
			duplicate[k] = {}
			for k2, v2 in pairs(v) do
				duplicate[k][k2] = v2
			end
		end
	end
	
	return duplicate
end

-- A function to find an item within an inventory by ID.
function Clockwork.inventory:FindItemByID(inventory, uniqueID, itemID)
	local itemTable = item.FindByID(uniqueID)

	if (!inventory) then
		debug.Trace()
		return
	end

	if (itemID) then
		itemID = tonumber(itemID)
	end

	if (!itemTable or !inventory[itemTable.uniqueID]) then
		return
	end

	local itemsList = inventory[itemTable.uniqueID]

	if (itemID) then
		if (itemsList) then
			return itemsList[itemID]
		end
	else
		local firstValue = table.GetFirstValue(itemsList)
		if (firstValue) then
			return itemsList[firstValue.itemID]
		end
	end
end

-- A function to find an item within an inventory by name.
function Clockwork.inventory:FindItemByName(inventory, uniqueID, name)
	local itemTable = item.FindByID(uniqueID)

	if (!itemTable or !inventory[itemTable.uniqueID]) then
		return
	end

	for k, v in pairs(inventory[itemTable.uniqueID]) do
		if (string.utf8lower(v.name) == string.utf8lower(name)) then
			return v
		end
	end
end

-- A function to get an inventory's items by unique ID.
function Clockwork.inventory:GetItemsByID(inventory, uniqueID)
	local itemTable = item.FindByID(uniqueID)

	if (itemTable) then
		return inventory[itemTable.uniqueID]
	else
		return {}
	end
end

-- A function to find an item within an inventory by name.
function Clockwork.inventory:FindItemsByName(inventory, uniqueID, name)
	local itemTable = item.FindByID(uniqueID)
	local itemsList = {}

	if (!itemTable or !inventory[itemTable.uniqueID]) then
		return
	end

	for k, v in pairs(inventory[itemTable.uniqueID]) do
		if (string.utf8lower(v.name) == string.utf8lower(name) or string.utf8lower(v.PrintName) == string.utf8lower(name)) then
			itemsList[#itemsList + 1] = v
		end
	end

	return itemsList
end

-- A function to get an inventory as an items list.
function Clockwork.inventory:GetAsItemsList(inventory)
	local itemsList = {}
		for k, v in pairs(inventory) do
			table.Add(itemsList, v)
		end
	return itemsList
end

function Clockwork.inventory:GetItemsAsList(inventory)
	local itemsList = {}
		for k, v in pairs(inventory) do
			table.Add(itemsList, v)
		end
	return itemsList
end

--[[
	@codebase Shared
	@details A function to get the amount of items an entity has in its inventory by ID.
	@param Table Inventory of the entity.
	@param Int ID of item looked up in the inventory to get the amount.
	@returns Int Number of items in the inventory that match the ID.
--]]
function Clockwork.inventory:GetItemCountByID(inventory, uniqueID)
	local itemTable = item.FindByID(uniqueID)

	if (inventory[itemTable.uniqueID]) then
		return table.Count(inventory[itemTable.uniqueID])
	else
		return 0
	end
end

-- A function to get whether an inventory has an item by ID.
function Clockwork.inventory:HasItemByID(inventory, uniqueID)
	local itemTable = item.FindByID(uniqueID)
	return (inventory[uniqueID or itemTable.uniqueID]
	and !table.IsEmpty(inventory[uniqueID or itemTable.uniqueID]));
	--and table.Count(inventory[uniqueID or itemTable.uniqueID]) > 0)
end

--[[
	@codebase Shared
	@details A function to get whether a player has a specific amount of items in their inventory by ID.
	@param Table Inventory of the entity.
	@param Int ID of the item being checked for its amount in the inventory.
	@param Int Amount of items the entity needs to have in order to return true.
	@returns Bool Whether the entity has a specific amount of items in its inventory or not.
--]]
function Clockwork.inventory:HasItemCountByID(inventory, uniqueID, amount)
	local amountInInventory = self:GetItemCountByID(inventory, uniqueID)

	if (amountInInventory >= amount) then
		return true
	else
		return false
	end
end

-- A function to get whether an inventory item instance.
function Clockwork.inventory:HasItemInstance(inventory, itemTable)
	if itemTable then
		local uniqueID = itemTable.uniqueID
		
		return (inventory[uniqueID] and inventory[uniqueID][itemTable.itemID] != nil)
	end
	
	return false;
end

-- A function to get whether an inventory is empty.
function Clockwork.inventory:IsEmpty(inventory)
	if (!inventory) then return true end
	local bEmpty = true

	for k, v in pairs(inventory) do
		if (!table.IsEmpty(v)) then
			return false
		end
	end

	return true
end

-- A function to remove an instance from a table.
function Clockwork.inventory:RemoveInstance(inventory, itemTable)
	if (!itemTable:IsInstance()) then
		debug.Trace()
		return false
	end

	if (inventory[itemTable.uniqueID]) then
		inventory[itemTable.uniqueID][itemTable.itemID] = nil
		return item.FindInstance(itemTable.itemID)
	end
end

-- A function to remove a uniquen ID from a table.
function Clockwork.inventory:RemoveUniqueID(inventory, uniqueID, itemID)
	local itemTable = item.FindByID(uniqueID)
	if (itemID) then itemID = tonumber(itemID) end

	if (itemTable and inventory[itemTable.uniqueID]) then
		if (!itemID) then
			local firstValue = table.GetFirstValue(inventory[itemTable.uniqueID])

			if (firstValue) then
				inventory[itemTable.uniqueID][firstValue.itemID] = nil
				return item.FindInstance(firstValue.itemID)
			end
		else
			inventory[itemTable.uniqueID][itemID] = nil
		end
	end
end

-- A function to make an inventory loadable.
function Clockwork.inventory:ToLoadable(inventory)
	local newTable = {}

	for k, v in pairs(inventory) do
		local itemTable = item.FindByID(k)

		if (itemTable) then
			local uniqueID = itemTable.uniqueID

			if (uniqueID != k) then
				continue
			end

			if (!newTable[uniqueID]) then
				newTable[uniqueID] = {}
			end

			for k2, v2 in pairs(v) do
				local itemID = tonumber(k2)
				local instance = item.CreateInstance(
					k, itemID, v2
				)

				if (instance and !instance.OnLoaded
				or instance:OnLoaded() != false) then
					newTable[uniqueID][itemID] = instance
				end
			end
		end
	end

	return newTable
end

-- A function to make an inventory saveable.
function Clockwork.inventory:ToSaveable(inventory)
	local newTable = {}

	for k, v in pairs(inventory) do
		local itemTable = item.FindByID(k)

		if (itemTable) then
			local defaultData = itemTable.defaultData
			local uniqueID = itemTable.uniqueID

			if (!newTable[uniqueID]) then
				newTable[uniqueID] = {}
			end

			for k2, v2 in pairs(v) do
				if (type(v2) == "table"
				and (v2.IsInstance and v2:IsInstance())) then
					local newData = {}
					local itemID = tostring(k2)

					for k3, v3 in pairs(v2.data) do
						if (defaultData[k3] != v3) then
							newData[k3] = v3
						end
					end

					if (!v2.OnSaved
					or v2:OnSaved(newData) != false) then
						newTable[uniqueID][itemID] = newData
					end
				end
			end
		end
	end

	return newTable
end

-- A function to get whether we should use the space system.
function Clockwork.inventory:UseSpaceSystem()
	return config.Get("enable_space_system"):Get()
end

if (CLIENT) then
	Clockwork.inventory.client = Clockwork.inventory.client or {}

	-- A function to get the local player's inventory.
	function Clockwork.inventory:GetClient()
		return self.client
	end

	-- A function to get the inventory panel.
	function Clockwork.inventory:GetPanel()
		return self.panel
	end

	-- A function to get whether the client has an item equipped.
	function Clockwork.inventory:HasEquipped(itemTable)
		if (itemTable.HasPlayerEquipped) then
			return (itemTable:HasPlayerEquipped(Clockwork.Client) == true)
		end

		return false
	end

	-- A function to rebuild the local player's inventory.
	function Clockwork.inventory:Rebuild(bForceRebuild)
		if (Clockwork.menu:IsPanelActive(self:GetPanel()) or bForceRebuild) then
			Clockwork.kernel:OnNextFrame("RebuildInv", function()
				if (IsValid(self:GetPanel())) then
					self:GetPanel():Rebuild()
				end
			end)
		end
		
		if cwRecipes and IsValid(cwRecipes.inventoryPanel) then
			cwRecipes.inventoryPanel:Rebuild();
		end
	end

	netstream.Hook("InvClear", function(data)
		Clockwork.inventory.client = {}
		Clockwork.inventory:Rebuild()
	end)

	netstream.Hook("InvGive", function(data)
		local itemTable = item.CreateInstance(
			data.index, data.itemID, data.data
		)

		Clockwork.inventory:AddInstance(
			Clockwork.inventory.client, itemTable
		)

		Clockwork.inventory:Rebuild()
		hook.Run("PlayerItemGiven", itemTable)
	end)
	
	netstream.Hook("InvGiveItems", function(data)
		for k, v in pairs(data) do
			local itemTable = item.CreateInstance(
				v.index, v.itemID, v.data
			)

			if (itemTable) then
				Clockwork.inventory:AddInstance(
					Clockwork.inventory.client, itemTable
				)
			end
		end

		Clockwork.inventory:Rebuild()
		hook.Run("PlayerItemGiven")
	end)

	netstream.Hook("InvNetwork", function(data)
		local itemTable = item.FindInstance(data.itemID)
		
		if (itemTable) then
			local bHasEquipped = Clockwork.inventory:HasEquipped(itemTable)
			
			table.Merge(itemTable.data, data.data)

			-- this is fucking shit but it wouldnt work any other way
			if itemTable.data["Ammo"] then
				if data.data["Ammo"] then
					if #data.data["Ammo"] == 0 then
						itemTable.data["Ammo"] = {};
					end
				end
			end
			
			hook.Run("ItemNetworkDataUpdated", itemTable, data.data)

			if (bHasEquipped != Clockwork.inventory:HasEquipped(itemTable)) then
				Clockwork.inventory:Rebuild(
					Clockwork.menu:GetOpen()
				)
			end
		end
	end)

	netstream.Hook("InvRebuild", function(data)
		Clockwork.inventory:Rebuild()
	end)

	netstream.Hook("InvTake", function(data)
		local itemTable = Clockwork.inventory:FindItemByID(
			Clockwork.inventory.client, data[1], data[2]
		)

		if (itemTable) then
			Clockwork.inventory:RemoveInstance(
				Clockwork.inventory.client, itemTable
			)

			Clockwork.inventory:Rebuild()
			hook.Run("PlayerItemTaken", itemTable)
			
			if data[3] then
				item.RemoveInstance(itemTable.itemID)
			end
		end
	end)
	
	netstream.Hook("InvTakeItems", function(data)
		for k, v in pairs(data) do
			local itemTable = Clockwork.inventory:FindItemByID(
				Clockwork.inventory.client, v.uniqueID, v.itemID
			)

			if (itemTable) then
				Clockwork.inventory:RemoveInstance(
					Clockwork.inventory.client, itemTable
				)
				
				item.RemoveInstance(itemTable.itemID)
			end
		end
		
		hook.Run("PlayerItemTaken");
		Clockwork.inventory:Rebuild();
	end)


	netstream.Hook("InvUpdate", function(data)
		for k, v in pairs(data) do
			local itemTable = item.CreateInstance(
				v.index, v.itemID, v.data
			)

			Clockwork.inventory:AddInstance(
				Clockwork.inventory.client, itemTable
			)
		end

		Clockwork.inventory:Rebuild()
	end)
	
	function Clockwork.inventory:InventoryAction(action, uniqueID, itemID, interactUniqueID, interactItemID)
		netstream.Start("InvAction", {action, uniqueID, itemID, interactUniqueID, interactItemID});
	end
else
	function Clockwork.inventory:SendUpdateByInstance(player, itemTable)
		if (itemTable) then
			netstream.Start(
				player, "InvUpdate", {item.GetDefinition(itemTable, true)}
			)
		end
	end

	function Clockwork.inventory:SendUpdateAll(player)
		local inventory = player:GetInventory()

		for k, v in pairs(inventory) do
			self:SendUpdateByID(player, k)
		end
	end

	function Clockwork.inventory:SendUpdateByID(player, uniqueID)
		local itemTables = self:GetItemsByID(player:GetInventory(), uniqueID)

		if (itemTables) then
			local definitions = {}

			for k, v in pairs(itemTables) do
				definitions[#definitions + 1] = item.GetDefinition(v, true)
			end

			netstream.Start(player, "InvUpdate", definitions)
		end
	end

	function Clockwork.inventory:Rebuild(player)
		Clockwork.kernel:OnNextFrame("RebuildInv"..player:UniqueID(), function()
			if (IsValid(player)) then
				netstream.Start(player, "InvRebuild")
			end
		end)
	end
	
	function Clockwork.inventory:InventoryAction(player, itemAction, uniqueID, itemID, interactUniqueID, interactItemID)
		hook.Run("PrePlayerInvAction", player, itemAction, uniqueID, itemID, interactUniqueID, interactItemID);

		if !player:Alive() or player:IsRagdolled() or player:GetNetVar("tied") != 0 then
			Clockwork.player:Notify(player, "You cannot use items right now!");
			
			return false;
		end
	
		local itemTable = player:FindItemByID(uniqueID, tonumber(itemID));
		local interactItemTable;
		
		if interactUniqueID and interactItemID then
			interactItemTable = player:FindItemByID(interactUniqueID, tonumber(interactItemID));
		end
		
		itemAction = string.lower(itemAction);
		
		if (itemTable) then
			local customFunctions = itemTable.customFunctions;
			
			if (customFunctions) then
				for k, v in pairs(customFunctions) do
					if (string.lower(v) == itemAction) then
						if (itemTable.OnCustomFunction) then
							itemTable:OnCustomFunction(player, v);
							return;
						end;
					end;
				end;
			end;

			if (itemAction == "repair") then
				local itemCondition = itemTable:GetCondition();
				
				if itemCondition <= 0 then
					if !cwBeliefs or !player:HasBelief("artisan") then
						Clockwork.player:Notify(player, "You cannot repair broken items!");
						return false;
					end
				end

				if itemCondition < 100 then
					if itemTable.repairItem then
						local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
						local repairItemTable;

						for k, v in pairs (itemList) do
							if v.uniqueID == itemTable.repairItem then
								repairItemTable = v;
								break;
							end
						end
			
						if (repairItemTable) then
							if repairItemTable then
								local conditionReplenishment = repairItemTable.conditionReplenishment or 100;
								local replenishment = (conditionReplenishment) - (((100 - repairItemTable:GetCondition()) * (itemTable.repairCostModifier or 1)) * (conditionReplenishment / 100));
								
								itemTable:GiveCondition(math.min(replenishment, 100));
								repairItemTable:TakeCondition((itemTable:GetCondition() - itemCondition) * (itemTable.repairCostModifier or 1) / (conditionReplenishment / 100));
								
								if repairItemTable:GetCondition() <= 0 then
									player:TakeItem(repairItemTable, true);
									
									player:EmitSound("generic_ui/randomize_0"..math.random(1, 2)..".wav")
									Schema:EasyText(player, "olivedrab", "You have repaired your "..itemTable.name.." to "..tostring(math.Round(itemTable:GetCondition(), 2))..", using the last of the repair kit's parts in the process.");
								else
									player:EmitSound("generic_ui/randomize_0"..math.random(1, 2)..".wav")
									Schema:EasyText(player, "green", "You have repaired your "..itemTable.name.." to "..tostring(math.Round(itemTable:GetCondition(), 2))..".");
									Clockwork.inventory:Rebuild(player);
								end
							else
								Schema:EasyText(player, "chocolate", "You do not have an item you can repair this item with!");
								return false;
							end
						end
					end
				else
					Clockwork.player:Notify(player, "This item is already in perfect condition and cannot be repaired.");
					return false;
				end
			elseif (itemAction == "breakdown") then
				if (itemTable.components) then
					if itemTable.components.breakdownType == "meltdown" then
						if (player:HasItemByID("charcoal")) then
							if !cwBeliefs or (cwBeliefs and player:HasBelief("smith")) then
								local smithy_found = false;
								
								for i = 1, #cwRecipes.smithyLocations do
									if player:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
										local itemCondition = itemTable:GetCondition();
										
										for j = 1, #itemTable.components.items do
											local componentItem = item.CreateInstance(itemTable.components.items[j]);
											local condition = itemCondition - math.random(15, 40);
											
											if condition > 0 then
												componentItem:SetCondition(condition, true);
												
												player:GiveItem(componentItem);
											end
										end
										
										Clockwork.player:Notify(player, "You have melted down your "..itemTable.name.." into its component pieces.");
										player:EmitSound("generic_ui/smelt_success_02.wav");
										
										if cwBeliefs then
											player:HandleXP(cwBeliefs.xpValues["meltdown"]);
										end
										
										local inventory = player:GetInventory();
										local coal;
										
										for k, v in pairs(inventory) do
											if k == "charcoal" then
												for k2, v2 in pairs(v) do
													if !coal or v2:GetCondition() < coal:GetCondition() then
														coal = v2;
													end
												end
											end
										end
										
										if coal then
											player:TakeItem(coal, true);
										end
										
										player:TakeItem(itemTable, true);
										smithy_found = true;
										break;
									end
								end
								
								if not smithy_found then
									Clockwork.player:Notify(player, "You must be standing near a smithy to melt down this item!");
									return false;
								end
							else
								Clockwork.player:Notify(player, "You must have the 'Smith' belief to melt down this item!");
								return false;
							end
						else
							Clockwork.player:Notify(player, "You need charcoal to melt down this item!");
						end
					elseif itemTable.components.breakdownType == "breakdown" then
						local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
						local breakdownItemTable;

						for k, v in pairs (itemList) do
							if v.uniqueID == "breakdown_kit" then
								breakdownItemTable = v;
								break;
							end
						end
						
						if breakdownItemTable then
							local conditionTaken = math.max(1, math.Round((itemTable.weight * 3)));
							local itemCondition = breakdownItemTable:GetCondition() or 100;
							
							--if conditionTaken <= itemCondition then
								for i = 1, #itemTable.components.items do
									local componentItem = item.CreateInstance(itemTable.components.items[i]);
									local condition = (componentItem:GetCondition() or 100) - math.random(15, 40);
									
									if condition > 0 then
										componentItem:SetCondition(condition, true);
										
										player:GiveItem(componentItem);
									end
								end
							
								Clockwork.player:Notify(player, "You have broken down your "..itemTable.name.." into its component pieces.");
								player:EmitSound("generic_ui/takeall_03.wav");
								
								if cwBeliefs then
									player:HandleXP(cwBeliefs.xpValues["breakdown"]);
								end
								
								breakdownItemTable:TakeCondition(conditionTaken);
								
								if breakdownItemTable:GetData("condition") <= 0 then
									player:TakeItem(breakdownItemTable, true);
								end
								
								player:TakeItem(itemTable, true);
							--else
								--Clockwork.player:Notify(player, "You do not have enough workable tools left in your breakdown kit to break down this item!");
							--end
						else
							Clockwork.player:Notify(player, "You do not have an item you can break down this item with!");
							return false;
						end
					end
				end
			elseif (itemAction == "destroy") then
				if (hook.Run("PlayerCanDestroyItem", player, itemTable)) then
					item.Destroy(player, itemTable);
				end;
			elseif (itemAction == "drop") then
				local position = player:GetEyeTraceNoCursor().HitPos;
				
				if (player:GetShootPos():Distance(position) <= 192) then
					if (hook.Run("PlayerCanDropItem", player, itemTable, position)) then
						item.Drop(player, itemTable, position);
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop the item that far away!");
				end;
			elseif (itemAction == "use") then
				if (player:InVehicle() and itemTable.useInVehicle == false) then
					Clockwork.player:Notify(player, "You cannot use this item in a vehicle!");
					
					return;
				end;

				if (hook.Run("PlayerCanUseItem", player, itemTable)) then
					return item.Use(player, itemTable, nil, interactItemTable);
				end;
			elseif (itemAction == "examine") then
				local itemCondition = itemTable:GetCondition();
				local examineText = itemTable.description
				local itemEngraving = itemTable:GetData("engraving");
				local conditionTextCategories = {"Armor", "Crossbows", "Firearms", "Helms", "Melee", "Shields", "Throwables"};

				if (itemTable.GetEntityExamineText) then
					examineText = itemTable:GetEntityExamineText(entity)
				end
				
				if itemEngraving and itemEngraving ~= "" then
					local itemKills = itemTable:GetData("kills");
					
					if itemKills and itemKills > 0 then
						examineText = examineText.." It has \'"..itemEngraving.."\' engraved into it, alongside a tally mark of "..tostring(itemKills).." kills.";
					else
						examineText = examineText.." It has \'"..itemEngraving.."\' engraved into it.";
					end
				end
				
				if table.HasValue(conditionTextCategories, itemTable.category) then
					if itemCondition >= 90 then
						examineText = examineText.." It appears to be in immaculate condition.";
					elseif itemCondition < 90 and itemCondition >= 60 then
						examineText = examineText.." It appears to be in a somewhat battered condition.";
					elseif itemCondition < 60 and itemCondition >= 30 then
						examineText = examineText.." It appears to be in very poor condition.";
					elseif itemCondition < 30 and itemCondition > 0 then
						examineText = examineText.." It appears to be on the verge of breaking.";
					elseif itemCondition <= 0 then
						if itemTable:IsBroken() then
							examineText = examineText.." It is completely destroyed and only worth its weight in scrap now.";
						else
							examineText = examineText.." It is broken yet still usable to some degree.";
						end
					end
				elseif itemTable.category == "Shot" and itemTable.ammoMagazineSize then
					local rounds = itemTable:GetAmmoMagazine();
					
					examineText = examineText.." The magazine has "..tostring(rounds).." "..itemTable.ammoName.." rounds loaded.";
				end

				Clockwork.player:Notify(player, examineText);
			elseif (itemAction == "ammo") then
				if (item.IsWeapon(itemTable)) then
					local ammo = itemTable:GetData("Ammo");
					
					if ammo and #ammo > 0 then
						if #ammo == 1 then
							if itemTable.usesMagazine and string.find(ammo[1], "Magazine") then
								local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
								local magazineItem = item.CreateInstance(ammoItemID);
								
								if magazineItem and magazineItem.SetAmmoMagazine then
									magazineItem:SetAmmoMagazine(1);
									
									player:GiveItem(magazineItem);
								end
							else
								local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
								
								player:GiveItem(item.CreateInstance(ammoItemID));
							end
						elseif itemTable.usesMagazine then
							local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
							
							local magazineItem = item.CreateInstance(ammoItemID);
							
							if magazineItem and magazineItem.SetAmmoMagazine then
								magazineItem:SetAmmoMagazine(#ammo);
								
								player:GiveItem(magazineItem);
							end
						else
							for i = 1, #ammo do
								local round = ammo[i];
								
								if round then
									local roundItemID = string.gsub(string.lower(round), " ", "_");
									local roundItemInstance = item.CreateInstance(roundItemID);
									
									player:GiveItem(roundItemInstance);
								end
							end
						end

						itemTable:SetData("Ammo", {});
					end
				end
			elseif (itemAction == "magazineammo") then
				if (itemTable.category == "Shot" and itemTable.ammoMagazineSize) then
					if itemTable.TakeFromMagazine then
						itemTable:TakeFromMagazine(player);
					end
				end
			else
				hook.Run("PlayerUseUnknownItemFunction", player, itemTable, itemAction, interactUniqueID, interactItemID);
			end;
		else
			Clockwork.player:Notify(player, "You do not own this item!");
		end;
	end
	
	netstream.Hook("InvAction", function(player, data)
		Clockwork.inventory:InventoryAction(player, data[1], data[2], data[3], data[4], data[5]);
	end)
end