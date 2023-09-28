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
	local uniqueID = itemTable.uniqueID
	return (inventory[uniqueID] and inventory[uniqueID][itemTable.itemID] != nil)
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
		end
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
end