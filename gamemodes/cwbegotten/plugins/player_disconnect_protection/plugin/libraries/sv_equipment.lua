
function Clockwork.equipment:GetItemEquipped2(equipmentSlots, itemTable, category)
	if !equipmentSlots then
		return false;
	end

	if !itemTable and category then
		for k, v in pairs(equipmentSlots) do
			if istable(category) then
				if table.HasValue(category, v.category) or (v.meleeWeapon and table.HasValue(category, "Weapons")) then
					return v;
				end
			elseif v.category == category or (v.meleeWeapon and category == "Weapons") then
				return v;
			end
		end
	end

	if isstring(itemTable) then
		for k, v in pairs(equipmentSlots) do
			if v.uniqueID == itemTable then
				return v;
			end
		end
	end

	if !itemTable then
		return false;
	end

	if !itemTable.slots then return false end;

	for k, v in pairs(equipmentSlots) do
		if v and v.uniqueID == itemTable.uniqueID and (!v.itemID or v.itemID == itemTable.itemID) then
			return v;
		end
	end
end