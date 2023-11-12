--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when Clockwork has loaded all of the entities.
function cwStorage:ClockworkInitPostEntity()
	self:LoadStorage();
end;

-- Called just after data should be saved.
function cwStorage:PostSaveData()
	self:SaveStorage();
end

-- Called when a player attempts to breach an entity.
function cwStorage:PlayerCanBreachEntity(player, entity)
	if (entity.cwInventory and entity.cwPassword) then
		return true
	end
end

-- Called when an entity attempts to be auto-removed.
function cwStorage:EntityCanAutoRemove(entity)
	if (self.storage[entity] or entity:GetNetworkedString("Name") != "") then
		return false
	end
end

-- Called when an entity's menu option should be handled.
function cwStorage:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	
	if (class == "cw_locker" and arguments == "cwContainerOpen") and (entity:GetNWBool("unlocked", true) == true) then
		self:OpenContainer(player, entity);
	elseif (arguments == "cwContainerOpen")	then
		if (Clockwork.entity:IsPhysicsEntity(entity)) then
			local model = string.lower(entity:GetModel());
			
			if (self.containerList[model]) then
				local containerWeight = self.containerList[model][1];
				
				if (!entity.cwPassword or entity.cwIsBreached or entity:GetNWBool("unlocked", true)) then
					if (player:GetCharacterData("hidden") == true) then
						Schema:EasyText(player, "firebrick", "You cannot do this right now!");
						
						return false;
					elseif IsValid(entity.occupier) and entity.occupier ~= player then
						cwContainerHiding:OpenedStorage(entity.occupier, entity);
					else
						self:OpenContainer(player, entity, containerWeight);
					end;
				else
					if (entity.cwLockType) then
						if (entity.cwLockType == "key" or entity.cwLockType == "combo" or entity.cwLockType == "turn") then
							if (!entity:GetNWBool("unlocked", true)) then
								entity:SetNWBool("unlocked", false);
							end;
							
							player.ActiveContainer = entity;
							Clockwork.datastream:Start(player, "LockInteract", {entity.cwLockType, false, entity});
						end;
					else
						Clockwork.datastream:Start(player, "ContainerPassword", entity);
					end;
				end;
			end;
		end;
	elseif (arguments == "cwContainerLockpick") then
		player.ActiveContainer = entity;
		self:StartLockpick(player);
	elseif (arguments == "cwContainerLock") then
		if (entity:GetNWBool("unlocked", true) == true) then
			entity:SetNWBool("unlocked", false);
			Schema:EasyText(player, "olivedrab", "You lock the container.")
		end;
	end;
end;

-- Called when an entity has been breached.
function cwStorage:EntityBreached(entity, activator)
	if (entity.cwInventory and entity.cwPassword) then
		entity.cwIsBreached = true

		timer.Create("ResetBreach"..entity:EntIndex(), 120, 1, function()
			if (IsValid(entity)) then
				entity.cwIsBreached = nil
			end
		end)
	end
end

-- Called when an entity is removed.
function cwStorage:EntityRemoved(entity)
	if (IsValid(entity) and !entity.cwIsBelongings) then
		if (hook.Run("ContainerCanDropItems", entity) != false) then 
			--Clockwork.entity:DropItemsAndCash(entity.cwInventory, entity.cwCash, entity:GetPos(), entity)
		end
		
		if entity.cwInventory then
			for k, v in pairs(entity.cwInventory) do
				for k2, v2 in pairs(v) do
					item.RemoveInstance(v2.itemID, true);
				end
			end
			
			entity.cwInventory = nil
		end
		
		if entity.cwCash then
			entity.cwCash = nil
		end
		
		local player = entity.LockpickingPlayer;

		if player and IsValid(player) then
			player.LockpickCooldown = CurTime() + 5;
			player:Freeze(false);
			player.Lockpicking = nil;
			player.ActiveContainer = nil;
			player.LockpickContainer = nil;
		end
	end
end

-- Called when a player's prop cost info should be adjusted.
function cwStorage:PlayerAdjustPropCostInfo(player, entity, info)
	local model = string.lower(entity:GetModel())

	if (self.containerList[model]) then
		info.name = self.containerList[model][2]
	end
end

-- Called to get whether a player can give an item to storage.
function cwStorage:PlayerCanGiveToStorage(player, storageTable, itemTable)
	if (storageTable.entity.cwPassword) then
		if (tostring(itemTable.itemID) == storageTable.entity.cwPassword) then
			Schema:EasyText(player, "peru", "You cannot lock the only key to this container inside it!")
			return false;
		end;
	end;
end;

-- Called when a player uses an unknown item function.
function cwStorage:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	if (string.lower(itemFunction) == "makekeycopy") then
		local uniqueID = itemTable.uniqueID;
		local itemID = itemTable.itemID;
		
		if (player:FindItemByID(uniqueID, itemID) and itemTable:GetData("KeyID") and itemTable:GetData("bIsCopy") != true) then
			Clockwork.player:SetAction(player, "keycutting", 7, 0, function()
				self:MakeKeyCopy(player, itemTable);
			end);
			
			Clockwork.datastream:Start(player, "CloseMenu");
		else
			Schema:EasyText(player, "peru", "You cannot make a copy of this key!")
		end;
	end;
end;

-- Called at an interval while the player is connected to the server.
--[[function cwStorage:PlayerThink(player, curTime, infoTable)
	local action = Clockwork.player:GetAction(player);
	
	if (action == "keycutting") then
		infoTable.walkSpeed = 0.1;
		infoTable.jumpPower = 0.1;
	end;
	
	if (player.Lockpicking) then
		infoTable.walkSpeed = 0.1;
		infoTable.jumpPower = 0.1;
	end;
end;]]--

--[[function cwStorage:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "keycutting") then
		infoTable.walkSpeed = 0.1;
		infoTable.jumpPower = 0.1;
	elseif (player.Lockpicking) then
		infoTable.walkSpeed = 0.1;
		infoTable.jumpPower = 0.1;
	end;
end]]--