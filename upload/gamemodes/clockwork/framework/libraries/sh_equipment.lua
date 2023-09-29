--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("equipment", Clockwork);

local function GetDataFromItem(itemTable)
	if itemTable then
		return {["uniqueID"] = itemTable.uniqueID, ["itemID"] = itemTable.itemID};
	end
end

local function GetItemFromData(player, data, index)
	if data then
		if index then
			if data[index] then
				return Clockwork.inventory:FindItemByID(player:GetInventory(), data[index].uniqueID, data[index].itemID);
			end
		else
			return Clockwork.inventory:FindItemByID(player:GetInventory(), data.uniqueID, data.itemID);
		end
	end
end

function Clockwork.equipment:GetItemEquipped(player, itemTable, category)
	if !itemTable then
		if category then
			for k, v in pairs(player.equipmentSlots) do
				if istable(category) then
					if table.HasValue(category, v.category) or (v.meleeWeapon and table.HasValue(category, "Weapons")) then
						return v;
					end
				elseif v.category == category or (v.meleeWeapon and category == "Weapons") then
					return v;
				end
			end
		end
	end
	
	if isstring(itemTable) then
		if SERVER then
			itemTable = Clockwork.inventory:FindItemByID(player:GetInventory(), itemTable);
		else
			itemTable = Clockwork.inventory:FindItemByID(Clockwork.inventory.client, itemTable);
		end
	end
	
	if !itemTable then
		return false;
	end

	for k, v in pairs(player.equipmentSlots) do
		if v and v.uniqueID == itemTable.uniqueID and (!v.itemID or v.itemID == itemTable.itemID) then
			return v;
		end
	end
end

if SERVER then
	function Clockwork.equipment:EquipItem(player, itemTable, slot)
		if !itemTable then
			return false;
		end
	
		if isstring(itemTable) then
			for k, v in pairs(player.equipmentSlots) do
				if v and v.uniqueID == itemTable then
					itemTable = v;
					slot = k;
					
					break;
				end
			end
			
			if !slot then
				return false;
			end
		end
		
		if !slot then
			for i, v in ipairs(itemTable.slots) do
				if !player.equipmentSlots[v] then
					slot = v;
				end
			end
			
			if !slot then
				return false;
			end
		end
		
		player.equipmentSlots[slot] = itemTable;
		
		item.SendToPlayer(_player.GetAll(), itemTable);
		netstream.Start(_player.GetAll(), "UpdateEquipment", {player, slot, itemTable.itemID});
		
		if itemTable.equipmentSaveString then
			if #itemTable.slots > 1 then
				local equipmentData = player:GetCharacterData(itemTable.equipmentSaveString, {});
				
				for i, v in ipairs(itemTable.slots) do
					if v == slot then
						equipmentData[i] = GetDataFromItem(itemTable);
					
						break;
					end
				end
				
				player:SetCharacterData(itemTable.equipmentSaveString, equipmentData);
			else
				player:SetCharacterData(itemTable.equipmentSaveString, GetDataFromItem(itemTable));
			end
		end
	end

	function Clockwork.equipment:UnequipItem(player, itemTable, slot, bNoRemove)
		if !itemTable then
			return false;
		end
	
		if isstring(itemTable) then
			for k, v in pairs(player.equipmentSlots) do
				if v and v.uniqueID == itemTable then
					itemTable = v;
					slot = k;
					
					break;
				end
			end

			if !slot then
				return false;
			end
		end
		
		if !slot then
			for i, v in ipairs(itemTable.slots) do
				local equipmentSlot = player.equipmentSlots[v];
				
				if equipmentSlot and equipmentSlot.itemID == itemTable.itemID then
					slot = v;
					
					break;
				end
			end
			
			if !slot then
				return false;
			end
		elseif !player.equipmentSlots[slot] then
			return false;
		end
		
		if bNoRemove then
			return true;
		end
		
		player.equipmentSlots[slot] = nil;
					
		-- Rearrange the slots.
		if slot ~= itemTable.slots[#itemTable.slots] then
			for i, v in ipairs(itemTable.slots) do
				if i > 1 and player.equipmentSlots[v] then
					if !player.equipmentSlots[itemTable.slots[i - 1]] then
						player.equipmentSlots[itemTable.slots[i - 1]] = table.Copy(player.equipmentSlots[v]);
						
						player.equipmentSlots[v] = nil;
					end
				end
			end
			
			for i, v in ipairs(itemTable.slots) do
				local itemTable = player.equipmentSlots[v];
				
				if itemTable then
					netstream.Start(_player.GetAll(), "UpdateEquipment", {player, v, itemTable.itemID});
				else
					netstream.Start(_player.GetAll(), "UpdateEquipment", {player, v});
				end
			end
		else
			netstream.Start(_player.GetAll(), "UpdateEquipment", {player, slot});
		end
		
		if itemTable.equipmentSaveString then
			if #itemTable.slots > 1 then
				--local equipmentData = player:GetCharacterData(itemTable.equipmentSaveString, {});
				local equipmentData = {};
				
				for i, v in ipairs(itemTable.slots) do
					--[[if v == slot then
						equipmentData[i] = nil;
					
						break;
					end]]--
					
					local equipmentItemTable = player.equipmentSlots[v];
					
					if equipmentItemTable then
						local dataTab = {};
						
						dataTab.uniqueID = equipmentItemTable.uniqueID;
						dataTab.itemID = equipmentItemTable.itemID;
						
						equipmentData[i] = dataTab;
					end
				end
				
				player:SetCharacterData(itemTable.equipmentSaveString, equipmentData);
			else
				player:SetCharacterData(itemTable.equipmentSaveString, nil);
			end
		end
		
		return true;
	end
	
	function Clockwork.equipment:NetworkEquipmentToPlayer(target, player)
		if !target.equipmentSlots then
			target.equipmentSlots = {};
		end;
		
		local equipmentSlots = {};
		
		for k, v in pairs(target.equipmentSlots) do
			if v then
				equipmentSlots[k] = v.itemID;
				item.SendToPlayer(player, v);
			end
		end
	
		netstream.Heavy(player, "SyncEquipment", {target, equipmentSlots});
	end
	
	function Clockwork.equipment:SyncEquipment(player)
		for i, v in ipairs(_player.GetAll()) do
			if !v.equipmentSlots then
				v.equipmentSlots = {};
			end;
		
			local equipmentSlots = {};
			
			for k2, v2 in pairs(v.equipmentSlots) do
				if v2 then
					equipmentSlots[k2] = v2.itemID;
					item.SendToPlayer(player, v2);
				end
			end
			
			netstream.Heavy(player, "SyncEquipment", {v, equipmentSlots});
		end
	end
end

local playerMeta = FindMetaTable("Player");

-- Supplying an item table to these functions will return whether or not they are equipped, otherwise it will return the item table of the equipped item (if it exists).
function playerMeta:GetItemEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable);
end

function playerMeta:GetHelmetEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, "Helms");
end

function playerMeta:GetClothesEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, "Armor");
end

function playerMeta:GetBackpackEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, "Backpacks");
end

function playerMeta:GetCharmEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, "Charms");
end

function playerMeta:GetShieldEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, "Shields");
end

function playerMeta:GetWeaponEquipped(itemTable)
	return Clockwork.equipment:GetItemEquipped(self, itemTable, {"Firearms", "Weapons"});
end

function playerMeta:GetWeaponsEquipped()
	local weaponsTab = {};
	
	for k, v in pairs(self.equipmentSlots) do
		if v.category == "Firearms" or v.meleeWeapon then
			table.insert(weaponsTab, v);
		end
	end
	
	return weaponsTab;
end

if SERVER then
	hook.Add("PlayerInitialSpawn", "PlayerInitialSpawnEquipment", function(player)
		Clockwork.equipment:SyncEquipment(player);
	end)

	hook.Add("PlayerGiveWeapons", "PlayerGiveWeaponsEquipment", function(player)
		player.equipmentSlots = {
			["Helms"] = GetItemFromData(player, player:GetCharacterData("helmet")),
			["Armor"] = GetItemFromData(player, player:GetCharacterData("clothes")),
			["Backpacks"] = GetItemFromData(player, player:GetCharacterData("backpack")),
			["Charm1"] = GetItemFromData(player, player:GetCharacterData("charms"), 1),
			["Charm2"] = GetItemFromData(player, player:GetCharacterData("charms"), 2),
			["Primary"] = GetItemFromData(player, player:GetCharacterData("weapons"), 1),
			["Secondary"] = GetItemFromData(player, player:GetCharacterData("weapons"), 2),
			["Tertiary"] = GetItemFromData(player, player:GetCharacterData("weapons"), 3),
		};
		
		local primary = player.equipmentSlots["Primary"]
		local secondary = player.equipmentSlots["Secondary"];
		local tertiary = player.equipmentSlots["Tertiary"];

		if primary and primary.weaponClass then
			player:Give(primary.weaponClass, primary);
		end
		
		if secondary then 
			if secondary.weaponClass then
				player:Give(secondary.weaponClass, secondary);
			elseif secondary.category == "Shields" then
				if primary and primary.canUseShields then
					local weapon = player:GetWeapon(primary.weaponClass);
					
					if IsValid(weapon) then
						weapon:EquipShield(secondary.uniqueID);
					end
				end
			end
		end
		
		if tertiary then 
			if tertiary.weaponClass then
				player:Give(tertiary.weaponClass, tertiary);
			elseif tertiary.category == "Shields" then
				if primary and primary.canUseShields then
					local weapon = player:GetWeapon(primary.weaponClass);
					
					if IsValid(weapon) then
						weapon:EquipShield(tertiary.uniqueID);
					end
				elseif secondary and secondary.canUseShields then
					local weapon = player:GetWeapon(secondary.weaponClass);
					
					if IsValid(weapon) then
						weapon:EquipShield(tertiary.uniqueID);
					end
				end
			end
		end
		
		local armorItem = player.equipmentSlots["Armor"];
		local helmetItem = player.equipmentSlots["Helms"];

		if armorItem then
			armorItem:OnWear(player);
		end
		
		if helmetItem then
			helmetItem:OnWear(player);
		end
		
		hook.Run("PlayerSetHandsModel", player, player:GetHands());
		
		for i, v in ipairs(_player.GetAll()) do
			Clockwork.equipment:NetworkEquipmentToPlayer(v, player);
		end
	end);
else
	-- A function to get the entity's real position.
	local function GetRealPosition(entity, player, itemTable)
		local offsetVector = itemTable.attachmentOffsetVector or Vector(0, 0, 0);
		local offsetAngle = itemTable.attachmentOffsetAngles or Angle(0, 0, 0);
		local bone = player:LookupBone(itemTable.attachmentBone);
		
		if (offsetVector and offsetAngle and bone) then
			if itemTable.category == "Shields" then
				local backpackItem = player:GetBackpackEquipped();

				if backpackItem and backpackItem.attachmentOffsetVector then
					if backpackItem.shieldOffsetVector then
						offsetVector = offsetVector + backpackItem.attachmentOffsetVector + backpackItem.shieldOffsetVector;
					else
						offsetVector = offsetVector + backpackItem.attachmentOffsetVector;
					end	
				end
			end
		
			local position, angles = player:GetBonePosition(bone)
			local ragdollEntity = player:GetRagdollEntity()

			if IsValid(ragdollEntity) then
				position, angles = ragdollEntity:GetBonePosition(bone)
			end

			local x = angles:Up() * offsetVector.x
			local y = angles:Right() * offsetVector.y
			local z = angles:Forward() * offsetVector.z

			angles:RotateAroundAxis(angles:Forward(), offsetAngle.p)
			angles:RotateAroundAxis(angles:Right(), offsetAngle.y)
			angles:RotateAroundAxis(angles:Up(), offsetAngle.r)

			return position + x + y + z, angles
		end
	end
	
	hook.Add("Tick", "TickEquipment", function()
		for _, player in pairs(_player.GetAll()) do
			player.equipmentDrawnThisTick = false;
			
			if !player.equipmentSlots then
				player.equipmentSlots = {};
			end
			
			if player:IsRagdolled() then
				hook.Run("PostPlayerDraw", player);
			end
		end
	end);

	hook.Add("PostPlayerDraw", "PostPlayerDrawEquipment", function(player)
		if IsValid(player) then
			if !player.equipmentSlotModels then
				player.equipmentSlotModels = {};
			end
			
			local shouldBeVisible = player:Alive() and ((player:GetMoveType() == MOVETYPE_WALK and player:GetColor().a > 0) or player:IsRagdolled() or player:InVehicle());

			for slot, itemTable in pairs(player.equipmentSlots) do
				if itemTable and itemTable.isAttachment then
					local attachmentVisible = shouldBeVisible;
					local equipmentModel = player.equipmentSlotModels[itemTable.itemID];
				
					if !IsValid(equipmentModel) then
						equipmentModel = ClientsideModel(itemTable.model, RENDERGROUP_BOTH);
						
						local modelScale = itemTable.attachmentModelScale or Vector(1, 1, 1);

						if (itemTable.GetAttachmentModelScale) then
							modelScale = itemTable:GetAttachmentModelScale(player, equipmentModel) or modelScale;
						end
						
						if itemTable.attachmentSkin then
							equipmentModel:SetSkin(itemTable.attachmentSkin);
						end
						
						if itemTable.bodygroup0 then
							equipmentModel:SetBodygroup(0, itemTable.bodygroup0 - 1);
						end
						
						if itemTable.bodygroup1 then
							equipmentModel:SetBodygroup(0, itemTable.bodygroup1 - 1);
						end
						
						if itemTable.bodygroup2 then
							equipmentModel:SetBodygroup(1, itemTable.bodygroup2 - 1);
						end
						
						if itemTable.bodygroup3 then
							equipmentModel:SetBodygroup(2, itemTable.bodygroup3 - 1);
						end

						local entityMatrix = Matrix();
						
						entityMatrix:Scale(modelScale);
						equipmentModel:EnableMatrix("RenderMultiply", entityMatrix);
						
						player.equipmentSlotModels[itemTable.itemID] = equipmentModel;
					end
					
					local position, angles = GetRealPosition(equipmentModel, player, itemTable);

					if (position and angles) then
						equipmentModel:SetPos(position);
						equipmentModel:SetAngles(angles);
					end
					
					if attachmentVisible then
						local activeWeapon = player:GetActiveWeapon();
						
						if IsValid(activeWeapon) then
							if activeWeapon:GetClass() == itemTable.weaponClass or activeWeapon:GetNWString("activeShield") == itemTable.uniqueID then
								attachmentVisible = false;
							end
						end
					end
					
					if !attachmentVisible then
						equipmentModel:SetNoDraw(true);
					elseif equipmentModel:GetNoDraw() then
						equipmentModel:SetNoDraw(false);
					end
				end
			end
		end
		
		player.equipmentDrawnThisTick = true;
	end);
	
	hook.Add("Think", "ThinkEquipment", function()
		for _, player in pairs(_player.GetAll()) do
			if player.equipmentSlotModels and !player.equipmentDrawnThisTick then
				for itemID, equipmentModel in pairs(player.equipmentSlotModels) do
					if IsValid(equipmentModel) then
						equipmentModel:Remove();
					end
				end
				
				player.equipmentSlotModels = nil;
			end
		end
	end);

	netstream.Hook("UpdateEquipment", function(data)
		local player = data[1];
		local slot = data[2];
		local itemTable = item.FindInstance(data[3]);
		
		if !IsValid(player) then
			return;
		end
		
		if player.equipmentSlotModels and player.equipmentSlots[slot] then
			for k, v in pairs(player.equipmentSlotModels) do
				if k == player.equipmentSlots[slot].itemID then
					v:Remove();
					
					player.equipmentSlotModels[k] = nil;
					
					break;
				end
			end
		end
		
		player.equipmentSlots[slot] = itemTable;
	end);
	
	netstream.Hook("SyncEquipment", function(data)
		local player = data[1];
		local equipmentSlots = data[2] or {};
		
		if !IsValid(player) then
			return;
		end

		if player.equipmentSlotModels then
			for slot, itemTable in pairs(player.equipmentSlots) do
				for k, v in pairs(player.equipmentSlotModels) do
					if k == itemTable.itemID then
						v:Remove();
						
						player.equipmentSlotModels[k] = nil;
						
						break;
					end
				end
			end
		end
		
		for k, v in pairs(equipmentSlots) do
			equipmentSlots[k] = item.FindInstance(v);
		end
		
		player.equipmentSlots = equipmentSlots;
	end);
end