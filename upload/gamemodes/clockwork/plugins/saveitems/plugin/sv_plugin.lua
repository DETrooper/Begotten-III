--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- A function to load the shipments.
function cwSaveItems:LoadShipments()
	local shipments = Clockwork.kernel:RestoreSchemaData("plugins/shipments/"..game.GetMap())

	for k, v in pairs(shipments) do
		if (item.GetStored()[v.item]) then
			local entity = Clockwork.entity:CreateShipment(
				{key = v.key, uniqueID = v.uniqueID}, v.item, v.amount, v.position, v.angles
			)

			if (IsValid(entity) and !v.isMoveable) then
				local physicsObject = entity:GetPhysicsObject()

				if (IsValid(physicsObject)) then
					physicsObject:EnableMotion(false)
				end
			end
		end
	end
end

-- A function to save the shipments.
function cwSaveItems:SaveShipments()
	local shipments = {}

	for k, v in pairs(ents.FindByClass("cw_shipment")) do
		local physicsObject = v:GetPhysicsObject()
		local itemTable = v:GetItemTable()
		local bMoveable = nil

		if (IsValid(physicsObject)) then
			bMoveable = physicsObject:IsMoveable()
		end

		shipments[#shipments + 1] = {
			key = Clockwork.entity:QueryProperty(v, "key"),
			item = itemTable.uniqueID,
			angles = v:GetAngles(),
			amount = table.Count(v.cwInventory[itemTable.uniqueID]),
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			isMoveable = bMoveable
		}
	end

	Clockwork.kernel:SaveSchemaData("plugins/shipments/"..game.GetMap(), shipments)
end

-- A function to load the items.
function cwSaveItems:LoadItems()
	local items = Clockwork.kernel:RestoreSchemaData("plugins/items/"..game.GetMap())

	for k, v in pairs(items) do
		local itemTable = item.CreateInstance(v.item, v.itemID, v.data)

		if (itemTable) then
			local entity = Clockwork.entity:CreateItem(
				{key = v.key, uniqueID = v.uniqueID}, itemTable, v.position, v.angles
			)

			if (IsValid(entity)) then
				if !v.isMoveable then
					local physicsObject = entity:GetPhysicsObject()

					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false)
					end
				end
				
				if v.IsTrapItem then
					entity.IsTrapItem = true;
					entity:SetCollisionGroup(COLLISION_GROUP_WORLD);
				end
			end
		end
	end
end

-- A function to save the items.
function cwSaveItems:SaveItems()
	local items = {}

	for k, v in pairs(ents.FindByClass("cw_item")) do
		--[[if (v.IsTrapItem) then
			continue;
		end;]]--
		
		-- Don't save temporary items!
		if not v.lifeTime and not v.noSave and not v:IsBroken() then
			local physicsObject = v:GetPhysicsObject()
			local itemTable = v:GetItemTable()
			local bMoveable = false

			if (IsValid(physicsObject)) then
				bMoveable = physicsObject:IsMoveable()
			end

			if (itemTable) then
				items[#items + 1] = {
					key = Clockwork.entity:QueryProperty(v, "key"),
					item = itemTable.uniqueID,
					data = itemTable.data,
					itemID = itemTable.itemID,
					angles = v:GetAngles(),
					uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
					position = v:GetPos(),
					isMoveable = bMoveable,
					IsTrapItem = v.IsTrapItem
				}
			end
		end
	end

	Clockwork.kernel:SaveSchemaData("plugins/items/"..game.GetMap(), items)
end