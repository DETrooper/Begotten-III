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
	if !player.equipmentSlots then
		return false;
	end

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
		for k, v in pairs(player.equipmentSlots) do
			if v.uniqueID == itemTable then
				return v;
			end
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
				local isOffhand = string.find(slot, "Offhand");
				
				if isOffhand then
					slot = string.gsub(slot, "Offhand", "");
				end
				
				for i, v in ipairs(itemTable.slots) do
					if v == slot then
						if isOffhand then
							equipmentData[i + 3] = GetDataFromItem(itemTable);
						else
							equipmentData[i] = GetDataFromItem(itemTable);
						end
					
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
					if !slot or slot == k then
						itemTable = v;
						slot = k;
						
						break;
					end
				end
			end

			if !slot then
				return false;
			end
		end
		
		if !slot then
			local canUseOffhand = itemTable.canUseOffhand;
			
			for i, v in ipairs(itemTable.slots) do
				local equipmentSlot = player.equipmentSlots[v];
				
				if equipmentSlot and equipmentSlot.itemID == itemTable.itemID then
					slot = v;
					
					break;
				end
				
				if canUseOffhand then
					equipmentSlot = player.equipmentSlots[v.."Offhand"];
					
					if equipmentSlot and equipmentSlot.itemID == itemTable.itemID then
						slot = v.."Offhand";
						
						break;
					end
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
		
		local players = _player.GetAll();
					
		-- Rearrange the slots.
		if slot ~= itemTable.slots[#itemTable.slots] then
			for i, v in ipairs(itemTable.slots) do
				if i > 1 and player.equipmentSlots[v] then
					local emptySlot = itemTable.slots[i - 1];
					
					if !player.equipmentSlots[emptySlot] then
						player.equipmentSlots[emptySlot] = table.Copy(player.equipmentSlots[v]);
						
						if player.equipmentSlots[v.."Offhand"] then
							player.equipmentSlots[emptySlot.."Offhand"] = table.Copy(player.equipmentSlots[v.."Offhand"]);
							player.equipmentSlots[v.."Offhand"] = nil;
						end
						
						player.equipmentSlots[v] = nil;
					end
				end
			end
		end
		
		-- Network the slots.
		for i, v in ipairs(itemTable.slots) do
			local itemTable = player.equipmentSlots[v];
			
			if itemTable then
				netstream.Start(players, "UpdateEquipment", {player, v, itemTable.itemID});
				
				if v == "Primary" or v == "Secondary" or v == "Tertiary" then
					local offhandItemTable = player.equipmentSlots[v.."Offhand"];
					
					if offhandItemTable then
						netstream.Start(players, "UpdateEquipment", {player, v.."Offhand", offhandItemTable.itemID});
					else
						netstream.Start(players, "UpdateEquipment", {player, v.."Offhand"});
					end
				end
			else
				netstream.Start(players, "UpdateEquipment", {player, v});
				
				if v == "Primary" or v == "Secondary" or v == "Tertiary" then
					netstream.Start(players, "UpdateEquipment", {player, v.."Offhand"});
				end
			end
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
					
					local offhandItemTable = player.equipmentSlots[v.."Offhand"];

					if offhandItemTable then
						local dataTab = {};
						
						dataTab.uniqueID = offhandItemTable.uniqueID;
						dataTab.itemID = offhandItemTable.itemID;
						
						equipmentData[i + #itemTable.slots] = dataTab;
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
		
			if v == player then
				continue;
			end
		
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

local weaponMeta = FindMetaTable("Weapon")

function weaponMeta:GetShield()
	local shield = self:GetNWString("activeShield");
	
	if shield and shield:len() > 0 then
		local shieldTable = GetTable(shield);
		
		if shieldTable then
			return shieldTable;
		end
	end
end


function weaponMeta:GetOffhand()
	local offhand = self:GetNWString("activeOffhand");
	
	if offhand and offhand:len() > 0 then
		local offhandWeapon = weapons.GetStored(offhand);
		
		if offhandWeapon then
			return offhandWeapon;
		end
	end
end

if SERVER then
	hook.Add("PlayerCharacterLoaded", "PlayerCharacterLoadedEquipment", function(player)
		if !player.equipmentSynced then
			Clockwork.equipment:SyncEquipment(player);
			
			player.equipmentSynced = true;
		end
	end)

	hook.Add("PlayerGiveWeapons", "PlayerGiveWeaponsEquipment", function(player)
		local charmData = player:GetCharacterData("charms");
		local weaponData = player:GetCharacterData("weapons");
	
		player.equipmentSlots = {
			["Helms"] = GetItemFromData(player, player:GetCharacterData("helmet")),
			["Armor"] = GetItemFromData(player, player:GetCharacterData("clothes")),
			["Backpacks"] = GetItemFromData(player, player:GetCharacterData("backpack")),
			["Charm1"] = GetItemFromData(player, charmData, 1),
			["Charm2"] = GetItemFromData(player, charmData, 2),
			["Primary"] = GetItemFromData(player, weaponData, 1),
			["PrimaryOffhand"] = GetItemFromData(player, weaponData, 4),
			["Secondary"] = GetItemFromData(player, weaponData, 2),
			["SecondaryOffhand"] = GetItemFromData(player, weaponData, 5),
			["Tertiary"] = GetItemFromData(player, weaponData, 3),
			["TertiaryOffhand"] = GetItemFromData(player, weaponData, 6),
		};
		
		local equipmentSlots = player.equipmentSlots;
		local primary = equipmentSlots["Primary"];
		local primaryOffhand = equipmentSlots["PrimaryOffhand"];
		local secondary = equipmentSlots["Secondary"];
		local secondaryOffhand = equipmentSlots["SecondaryOffhand"];
		local tertiary = equipmentSlots["Tertiary"];
		local tertiaryOffhand = equipmentSlots["TertiaryOffhand"];

		if primary and primary.weaponClass then
			local weapon = player:Give(primary.weaponClass, primary);
			
			if IsValid(weapon) and weapon.EquipOffhand and primaryOffhand and primaryOffhand.weaponClass then
				weapon:EquipOffhand(primaryOffhand.weaponClass);
			end
		end
		
		if secondary then 
			if secondary.weaponClass then
				local weapon = player:Give(secondary.weaponClass, secondary);
				
				if IsValid(weapon) and weapon.EquipOffhand and secondaryOffhand and secondaryOffhand.weaponClass then
					weapon:EquipOffhand(secondaryOffhand.weaponClass);
				end
			elseif secondary.category == "Shields" then
				if primary and primary.canUseShields and !primaryOffhand then
					local weapon = player:GetWeapon(primary.weaponClass);
					
					if IsValid(weapon) and weapon.EquipShield then
						weapon:EquipShield(secondary.uniqueID);
					end
				end
			end
		end
		
		if tertiary then 
			if tertiary.weaponClass then
				local weapon = player:Give(tertiary.weaponClass, tertiary);
				
				if IsValid(weapon) and weapon.EquipOffhand and tertiaryOffhand and tertiaryOffhand.weaponClass then
					weapon:EquipOffhand(tertiaryOffhand.weaponClass);
				end
			elseif tertiary.category == "Shields" then
				if primary and primary.canUseShields and !primaryOffhand then
					local weapon = player:GetWeapon(primary.weaponClass);
					
					if IsValid(weapon) and weapon.EquipShield then
						weapon:EquipShield(tertiary.uniqueID);
					end
				elseif secondary and secondary.canUseShields and !secondaryOffhand then
					local weapon = player:GetWeapon(secondary.weaponClass);
					
					if IsValid(weapon) and weapon.EquipShield then
						weapon:EquipShield(tertiary.uniqueID);
					end
				end
			end
		end
		
		local armorItem = equipmentSlots["Armor"];
		local helmetItem = equipmentSlots["Helms"];

		if armorItem and armorItem.OnWear then
			armorItem:OnWear(player);
		end
		
		if helmetItem and helmetItem.OnWear then
			helmetItem:OnWear(player);
		end
		
		hook.Run("PlayerSetHandsModel", player, player:GetHands());
		
		for i, v in ipairs(_player.GetAll()) do
			Clockwork.equipment:NetworkEquipmentToPlayer(player, v);
		end
	end);
else
	-- A function to get the entity's real position.
	local function GetRealPosition(entity, player, itemTable, bOffhand)
		local attachmentBone = itemTable.attachmentBone; 
		local offsetVector = itemTable.attachmentOffsetVector or Vector(0, 0, 0);
		local offsetAngle = itemTable.attachmentOffsetAngles or Angle(0, 0, 0);
		
		if bOffhand then
			if string.find(attachmentBone, "_L_") then
				attachmentBone = string.gsub(attachmentBone, "_L_", "_R_");
			else
				attachmentBone = string.gsub(attachmentBone, "_R_", "_L_");
			end
			
			offsetVector = Vector(-offsetVector.x, offsetVector.y, offsetVector.z);
			offsetAngle = Angle(-offsetAngle.pitch, offsetAngle.yaw, offsetAngle.roll);
		end
		
		local bone = player:LookupBone(attachmentBone);
		
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
			local plyTab = player:GetTable();
			
			plyTab.equipmentDrawnThisTick = false;
			
			if !plyTab.equipmentSlots then
				plyTab.equipmentSlots = {};
			end
			
			if player:IsRagdolled() then
				hook.Run("PostPlayerDraw", player);
			end
		end
	end);

	hook.Add("PostPlayerDraw", "PostPlayerDrawEquipment", function(player)
		if player:Alive() and player:GetMoveType() ~= MOVETYPE_OBSERVER and player:GetColor().a > 0 then
			local activeWeapon = player:GetActiveWeapon();
			local plyTab = player:GetTable();
			
			if !plyTab.equipmentSlotModels then
				plyTab.equipmentSlotModels = {};
			end

			for slot, itemTable in pairs(plyTab.equipmentSlots) do
				if itemTable and itemTable.isAttachment then
					local attachmentVisible = true;
					local equipmentModel = plyTab.equipmentSlotModels[itemTable.itemID];
				
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
						
						plyTab.equipmentSlotModels[itemTable.itemID] = equipmentModel;
					end
					
					local position, angles = GetRealPosition(equipmentModel, player, itemTable, string.find(slot, "Offhand"));

					if (position and angles) then
						equipmentModel:SetPos(position);
						equipmentModel:SetAngles(angles);
					end
					
					if attachmentVisible then
						if IsValid(activeWeapon) then
							if activeWeapon:GetClass() == itemTable.weaponClass or activeWeapon:GetNWString("activeShield") == itemTable.uniqueID or activeWeapon:GetNWString("activeOffhand") == itemTable.uniqueID then
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
			
			plyTab.equipmentDrawnThisTick = true;
		end
	end);
	
	hook.Add("Think", "ThinkEquipment", function()
		for _, player in pairs(_player.GetAll()) do
			local plyTab = player:GetTable();
		
			if plyTab.equipmentSlotModels and !plyTab.equipmentDrawnThisTick then
				for itemID, equipmentModel in pairs(plyTab.equipmentSlotModels) do
					if IsValid(equipmentModel) then
						equipmentModel:Remove();
					end
				end
				
				plyTab.equipmentSlotModels = nil;
			end
		end
	end);
	
	hook.Add("EntityRemoved", "EntityRemovedEquipment", function(entity)
		if Clockwork.entity:IsPlayerRagdoll(entity) then
			entity = entity:GetNWEntity("Player");
		end
	
		if entity:IsPlayer() then
			if entity.equipmentSlotModels then
				for itemID, equipmentModel in pairs(entity.equipmentSlotModels) do
					if IsValid(equipmentModel) then
						equipmentModel:Remove();
					end
				end
				
				entity.equipmentSlotModels = nil;
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
		
		local plyTab = player:GetTable();
		
		if plyTab.equipmentSlotModels and plyTab.equipmentSlots[slot] then
			for k, v in pairs(plyTab.equipmentSlotModels) do
				if k == plyTab.equipmentSlots[slot].itemID then
					v:Remove();
					
					plyTab.equipmentSlotModels[k] = nil;
					
					break;
				end
			end
		end
		
		plyTab.equipmentSlots[slot] = itemTable;
	end);
	
	netstream.Hook("SyncEquipment", function(data)
		local player = data[1];
		local equipmentSlots = data[2] or {};
		
		if !IsValid(player) then
			return;
		end
		
		local plyTab = player:GetTable();

		if plyTab.equipmentSlotModels then
			for slot, itemTable in pairs(plyTab.equipmentSlots) do
				for k, v in pairs(plyTab.equipmentSlotModels) do
					if k == itemTable.itemID then
						v:Remove();
						
						plyTab.equipmentSlotModels[k] = nil;
						
						break;
					end
				end
			end
		end
		
		for k, v in pairs(equipmentSlots) do
			equipmentSlots[k] = item.FindInstance(v);
		end
		
		plyTab.equipmentSlots = equipmentSlots;
	end);
end