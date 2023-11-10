--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("storage", Clockwork)

-- A function to get a player's storage entity.
function Clockwork.storage:GetEntity(player)
	if (player:GetStorageTable()) then
		local entity = self:Query(player, "entity")

		if (entity and IsValid(entity)) then
			return entity
		end
	end
end

-- A function to get a player's storage table.
function Clockwork.storage:GetTable(player)
	return player.cwStorageTab
end

-- A function to get whether a player's storage has an item.
function Clockwork.storage:HasItem(player, itemTable)
	local inventory = self:Query(player, "inventory")

	if (inventory) then
		return Clockwork.inventory:HasItemInstance(
			inventory, itemTable
		)
	end

	return false
end

-- A function to query a player's storage.
function Clockwork.storage:Query(player, key, default)
	local storageTable = player:GetStorageTable()

	if (storageTable) then
		return storageTable[key] or default
	else
		return default
	end
end

-- A function to close storage for a player.
function Clockwork.storage:Close(player, bServer)
	local storageTable = player:GetStorageTable()
	local OnClose = self:Query(player, "OnClose")
	local entity = self:Query(player, "entity")

	if (storageTable and OnClose) then
		OnClose(player, storageTable, entity)
	end

	if (!bServer) then
		netstream.Start(player, "StorageClose", true)
	end

	player.cwStorageTab = nil
end

-- A function to get the weight of a player's storage.
function Clockwork.storage:GetWeight(player)
	if (player:GetStorageTable()) then
		local cash = self:Query(player, "cash")
		local weight = (cash * config.Get("cash_weight"):Get())
		local inventory = self:Query(player, "inventory")

		if (self:Query(player, "noCashWeight")) then
			weight = 0
		end

		for k, v in pairs(Clockwork.inventory:GetAsItemsList(inventory)) do		
			weight = weight + (math.max((v.storageWeight or v.weight), 0))
		end

		return weight
	else
		return 0
	end
end

-- A function to get the space of a player's storage.
function Clockwork.storage:GetSpace(player)
	if (player:GetStorageTable()) then
		local cash = self:Query(player, "cash")
		local space = (cash * config.Get("cash_space"):Get())
		local inventory = self:Query(player, "inventory")

		if (self:Query(player, "noCashSpace")) then
			space = 0
		end

		for k, v in pairs(Clockwork.inventory:GetAsItemsList(inventory)) do		
			space = space + (math.max((v.storageSpace or v.space), 0))
		end

		return space
	else
		return 0
	end
end

-- A function to open storage for a player.
function Clockwork.storage:Open(player, data)
	local storageTable = player:GetStorageTable()
	local OnClose = self:Query(player, "OnClose")

	if (storageTable and OnClose) then
		OnClose(player, storageTable, storageTable.entity)
	end

	if (!config.Get("cash_enabled"):Get()) then
		data.cash = nil
	end

	if (data.noCashWeight == nil) then
		data.noCashWeight = false
	end

	if (data.noCashSpace == nil) then
		data.noCashSpace = false
	end

	if (data.isOneSided == nil) then
		data.isOneSided = false
	end

	data.inventory = data.inventory or {}
	data.entity = data.entity == nil and player or data.entity
	data.weight = data.weight or config.Get("default_inv_weight"):Get()
	data.space = data.space or --[[config.Get("default_inv_space"):Get()]] 300;
	data.cash = data.cash or 0
	data.name = data.name or "Storage"

	player.cwStorageTab = data

	netstream.Start(player, "StorageStart", {noCashWeight = data.noCashWeight, noCashSpace = data.noCashSpace, isOneSided = data.isOneSided, entity = data.entity, name = data.name}, false)

	self:UpdateCash(player, {data.cash, false})
	self:UpdateWeight(player, {data.weight, false})
	self:UpdateSpace(player, {data.space, false})
	
	for k, v in pairs(data.inventory) do
		self:UpdateByID(player, k, false)
	end
	
	netstream.Start(player, "StorageRebuild");
end

-- A function to update a player's storage cash.
function Clockwork.storage:UpdateCash(player, cash)
	if (config.Get("cash_enabled"):Get()) then
		local storageTable = player:GetStorageTable()

		if (storageTable) then
			local inventory = self:Query(player, "inventory")

			for k, v in pairs(_player.GetAll()) do
				if (v:HasInitialized() and v:GetStorageTable()) then
					if (self:Query(v, "inventory") == inventory) then
						if istable(cash) then
							v.cwStorageTab.cash = cash[1];
						else
							v.cwStorageTab.cash = cash;
						end

						netstream.Start(v, "StorageCash", cash)
					end
				end
			end
		end
	end
end

-- A function to update a player's storage weight.
function Clockwork.storage:UpdateWeight(player, weight)
	if (player:GetStorageTable()) then
		local inventory = self:Query(player, "inventory")

		for k, v in pairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetStorageTable()) then
				if (self:Query(v, "inventory") == inventory) then
						if istable(weight) then
							v.cwStorageTab.weight = weight[1];
						else
							v.cwStorageTab.weight = weight;
						end

					netstream.Start(v, "StorageWeight", weight)
				end
			end
		end
	end
end

-- A function to update a player's storage space.
function Clockwork.storage:UpdateSpace(player, space)
	if (player:GetStorageTable()) then
		local inventory = self:Query(player, "inventory")

		for k, v in pairs(_player.GetAll()) do
			if (v:HasInitialized() and v:GetStorageTable()) then
				if (self:Query(v, "inventory") == inventory) then
						if istable(space) then
							v.cwStorageTab.space = space[1];
						else
							v.cwStorageTab.space = space;
						end

					netstream.Start(v, "StorageSpace", space)
				end
			end
		end
	end
end

-- A function to get whether a player can give to storage.
function Clockwork.storage:CanGiveTo(player, itemTable)
	local entity = self:Query(player, "entity")
	local isPlayer = (entity and entity:IsPlayer())

	if (itemTable) then
		local bAllowPlayerStorage = (!isPlayer or itemTable.allowPlayerStorage != false)
		local bAllowEntityStorage = (isPlayer or itemTable.allowEntityStorage != false)
		local bAllowPlayerGive = (!isPlayer or itemTable.allowPlayerGive != false)
		local bAllowEntityGive = (isPlayer or itemTable.allowEntityGive != false)
		local bAllowStorage = (itemTable.allowStorage != false)
		local bIsShipment = (entity and entity:GetClass() == "cw_shipment")
		local bAllowGive = (itemTable.allowGive != false)

		if (bIsShipment or (bAllowPlayerStorage and bAllowPlayerGive
		and bAllowEntityStorage and bAllowStorage and bAllowGive
		and bAllowEntityGive)) then
			return true
		end
	end
end

-- A function to get whether a player can take from storage.
function Clockwork.storage:CanTakeFrom(player, itemTable)
	local entity = self:Query(player, "entity")
	local isPlayer = (entity and entity:IsPlayer())

	if (itemTable) then
		local bAllowPlayerStorage = (!isPlayer or itemTable.allowPlayerStorage != false)
		local bAllowEntityStorage = (isPlayer or itemTable.allowEntityStorage != false)
		local bAllowPlayerTake = (!isPlayer or itemTable.allowPlayerTake != false)
		local bAllowEntityTake = (isPlayer or itemTable.allowEntityTake != false)
		local bAllowStorage = (itemTable.allowStorage != false)
		local bIsShipment = (entity and entity:GetClass() == "cw_shipment")
		local bAllowTake = (itemTable.allowTake != false)

		if (bIsShipment or (bAllowPlayerStorage and bAllowPlayerTake
		and bAllowEntityStorage and bAllowStorage and bAllowTake
		and bAllowEntityTake)) then
			return true
		end
	end
end

-- A function to sync a player's cash.
function Clockwork.storage:SyncCash(player)
	local recipients = {}
	local inventory = player:GetInventory()
	local cash = player:GetCash()

	if (config.Get("cash_enabled"):Get()) then
		for k, v in pairs(_player.GetAll()) do
			if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
				local storageTable = v:GetStorageTable()
					recipients[#recipients + 1] = v
				storageTable.cash = cash
			end
		end
	end

	netstream.Start(recipients, "StorageCash", cash)
end

-- A function to sync a player's item.
function Clockwork.storage:SyncItem(player, itemTable)
	local inventory = player:GetInventory();
	
	if (itemTable) then
		local definition = Clockwork.item:GetDefinition(itemTable, true);
			definition.index = nil;
		local players = {};
		
		for k, v in pairs(_player.GetAll()) do
			if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
				players[#players + 1] = v;
			end;
		end;
		
		if (player:HasItemInstance(itemTable)) then
			Clockwork.datastream:Start(players, "StorageGive", {index = itemTable("index"), itemList = {definition}});
		else
			Clockwork.datastream:Start(players, "StorageTake", Clockwork.item:GetSignature(itemTable));
		end;
	end;
end;


-- A function to give an item to a player's storage.
function Clockwork.storage:GiveTo(player, itemTable, bMultiple)
	local storageTable = player:GetStorageTable()
	if (!storageTable) then return false end

	local inventory = self:Query(player, "inventory")
	if (!self:CanGiveTo(player, itemTable)) then
		return false
	end

	if (!player:HasItemInstance(itemTable) or hook.Run("PlayerCanGiveToStorage", player, storageTable, itemTable) == false) then
		return false
	end

	if (!storageTable.entity or !storageTable.entity:IsPlayer()) then
		local weight = itemTable.storageWeight or itemTable.weight
		local space = itemTable.storageSpace or itemTable.space

		if ((self:GetWeight(player) + math.max(weight, 0) > storageTable.weight)
		or (self:GetSpace(player) + math.max(space, 0) > storageTable.space)) then
			return false
		end
	end

	local bCanGiveStorage = !itemTable.CanGiveStorage or itemTable:CanGiveStorage(player, storageTable)
	if (bCanGiveStorage == false) then return false end

	bCanGiveStorage = !storageTable.CanGiveItem or storageTable.CanGiveItem(player, storageTable, itemTable)
	if (bCanGiveStorage == false) then return false end

	if (storageTable.entity and storageTable.entity:IsPlayer() and !storageTable.entity:GiveItem(itemTable)) then
		return false
	end

	hook.Run("PlayerGiveToStorage", player, storageTable, itemTable)
	Clockwork.inventory:AddInstance(inventory, itemTable)

	if !bMultiple then
		local definition = item.GetDefinition(itemTable, true)
			definition.index = nil
		local players = {}
			
		for k, v in pairs(_player.GetAll()) do
			if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
				players[#players + 1] = v
			end
		end

		netstream.Start(
			players, "StorageGive", { index = itemTable.index, itemList = {definition}}
		)

		player:TakeItem(itemTable)

		if (storageTable.OnGiveItem and storageTable.OnGiveItem(player, storageTable, itemTable)) then
			self:Close(player)
		end

		if (itemTable.OnStorageGive and itemTable:OnStorageGive(player, storageTable)) then
			self:Close(player)
		end

		if (storageTable.entity and storageTable.entity:IsPlayer()) then
			self:UpdateWeight(player, storageTable.entity:GetMaxWeight())
			self:UpdateSpace(player, storageTable.entity:GetMaxSpace())
		end

		hook.Run("PostPlayerGiveToStorage", player, storageTable, itemTable)
	end

	return true
end

-- A function to take an item from a player's storage.
function Clockwork.storage:TakeFrom(player, itemTable, bMultiple)
	local storageTable = player:GetStorageTable()
	if (!storageTable) then return false end

	local inventory = self:Query(player, "inventory")
	local players = {}

	if (!self:CanTakeFrom(player, itemTable) or hook.Run("PlayerCanTakeFromStorage", player, storageTable, itemTable) == false) then
		return false
	end

	if (!Clockwork.inventory:HasItemInstance(inventory, itemTable)) then
		return false
	end

	local bCanTakeStorage = !itemTable.CanTakeStorage or itemTable:CanTakeStorage(player, storageTable)
	if (bCanTakeStorage == false) then return false end

	bCanTakeStorage = !storageTable.CanTakeItem or storageTable.CanTakeItem(player, storageTable, itemTable)
	if (bCanTakeStorage == false) then return false end

	local bSuccess, fault = player:GiveItem(itemTable)

	if (bSuccess) then
		hook.Run("PlayerTakeFromStorage", player, storageTable, itemTable)

		if !bMultiple then
			if (!storageTable.entity or !storageTable.entity:IsPlayer()) then
				Clockwork.inventory:RemoveInstance(inventory, itemTable)
			else
				storageTable.entity:TakeItem(itemTable)
			end
				
			for k, v in pairs(_player.GetAll()) do
				if (v:HasInitialized() and self:Query(v, "inventory") == inventory) then
					players[#players + 1] = v
				end
			end

			netstream.Start(
				players, "StorageTake", item.GetSignature(itemTable)
			)

			if (storageTable.OnTakeItem and storageTable.OnTakeItem(player, storageTable, itemTable)) then
				self:Close(player)
			end

			if (itemTable.OnStorageTake and itemTable:OnStorageTake(player, itemTable)) then
				self:Close(player)
			end

			if (storageTable.entity and storageTable.entity:IsPlayer()) then
				self:UpdateWeight(player, storageTable.entity:GetMaxWeight())
				self:UpdateSpace(player, storageTable.entity:GetMaxSpace())
			end

			hook.Run("PostPlayerTakeFromStorage", player, storageTable, itemTable)
		end

		return true
	else
		Schema:EasyText(player, "peru", fault)
	end
end

-- A function to update storage for a player.
function Clockwork.storage:UpdateByID(player, uniqueID, bRebuild)
	if (!player:GetStorageTable()) then return end

	local inventory = self:Query(player, "inventory")
	local itemTable = item.FindByID(uniqueID, true)

	if (itemTable and inventory[uniqueID]) then
		local itemList = {}

		for k, v in pairs(inventory[uniqueID]) do
			local definition = item.GetDefinition(v, true)

			itemList[#itemList + 1] = {
				itemID = definition.itemID,
				data = definition.data
			}
		end

		netstream.Start(player, "StorageGive", {index = itemTable.index, itemList = itemList, bRebuild = bRebuild})
	end
end