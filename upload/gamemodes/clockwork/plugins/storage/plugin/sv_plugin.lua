--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

cwStorage.storage = cwStorage.storage or {}

netstream.Hook("ContainerPassword", function(player, data)
	local password = data[1]
	local entity = data[2]

	if (IsValid(entity) and Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel())

		if (cwStorage.containerList[model]) then
			local containerWeight = cwStorage.containerList[model][1]

			if (entity.cwPassword == password) then
				cwStorage:OpenContainer(player, entity, containerWeight)
				Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has opened the passworded container "..entity:GetNetworkedString("Name").." by using a password.");
			else
				Schema:EasyText(player, "peru", "The password you entered was incorrect!")
			end
		end
	end
end)

-- A function to get a random item.
function cwStorage:GetRandomItem(uniqueID)
	if (uniqueID) then
		uniqueID = string.lower(uniqueID)
	end

	if (#self.randomItems <= 0) then
		return
	end

	local randomItem = self.randomItems[
		math.random(1, #self.randomItems)
	]

	if (randomItem) then
		local itemTable = item.FindByID(randomItem[1])

		if (!uniqueID or string.find(string.lower(itemTable.category), uniqueID)) then
			return randomItem
		end
	end

	return self:GetRandomItem(uniqueID, runs)
end

function cwStorage:CategoryExists(uniqueID)
	if (uniqueID) then
		local uniqueID = string.lower(uniqueID)

		for i = 1, #self.randomItems do
			local itemTable = item.FindByID(self.randomItems[i][1])

			if (string.find(string.lower(itemTable.category), uniqueID)) then
				return true
			end
		end

		return false
	else
		return false
	end
end

-- Saving and loading are now handled by Static Entities plugin.
function cwStorage:SaveStorage()
	local storage = {};
	
	for k, v in pairs(self.storage) do
		if (IsValid(v)) then
			if (v.cwInventory and v.cwCash and (v.cwMessage or table.Count(v.cwInventory) > 0 or v.cwCash > 0 or v:GetNetworkedString("Name") != "") or v.cwLockType or v.cwPassword) then
				local physicsObject = v:GetPhysicsObject();
				local bMoveable = nil;
				local startPos = v:GetStartPosition();
				local containerTier = v.cwLockTier or 3;
				local model = v:GetModel();
				
				if (v:IsMapEntity() and startPos) then
					model = nil;
				end;
				
				if (IsValid(physicsObject)) then
					bMoveable = physicsObject:IsMoveable();
				end;
				
				local saveTab = {};
				
				saveTab = {
					name = v:GetNetworkedString("Name"),
					model = model,
					cash = v.cwCash,
					color = { v:GetColor() },
					angles = v:GetAngles(),
					position = v:GetPos(),
					message = v.cwMessage,
					password = v.cwPassword,
					lockType = v.cwLockType,
					lockTier = containerTier,
					startPos = startPos,
					inventory = Clockwork.inventory:ToSaveable(v.cwInventory or {}),
					isMoveable = bMoveable
				};
				
				hook.Run("ModifyStorageSaveTable", v, saveTab);
				
				storage[#storage + 1] = saveTab;
			end;
		end;
	end;

	Clockwork.kernel:SaveSchemaData("plugins/storage/"..game.GetMap(), storage);
end

function cwStorage:LoadStorage()
	local storage = Clockwork.kernel:RestoreSchemaData("plugins/storage/"..game.GetMap());
	self.storage = {};
	
	for k, v in pairs(storage) do
		if (!v.model) then
			local entity = ents.FindInSphere((v.startPos or v.position), 16)[1];
			
			if (IsValid(entity) and entity:IsMapEntity()) then
				self.storage[entity] = entity;
				
				entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
				entity.cwPassword = v.password;
				entity.cwMessage = v.message;
				entity.cwCash = v.cash;
				entity.cwLockType = v.lockType;
				
				if (IsValid(entity:GetPhysicsObject())) then
					if (!v.isMoveable) then
						entity:GetPhysicsObject():EnableMotion(false);
					else
						entity:GetPhysicsObject():EnableMotion(true);
					end;
				end;
				
				if (v.angles) then
					entity:SetAngles(v.angles);
					entity:SetPos(v.position);
				end;
				
				if (v.color) then
					entity:SetColor(unpack(v.color));
				end;
				
				if (v.name != "") then
					entity:SetNetworkedString("Name", v.name);
				end;
				
				if v.password then
					entity:SetNWBool("hasPassword", true);
					entity:SetNWBool("unlocked", false);
				end
				
				hook.Run("ModifyLoadStorageEntityTab", entity, v);
			end;
		else
			local entity = ents.Create("prop_physics");
			
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (IsValid(entity:GetPhysicsObject())) then
				if (!v.isMoveable) then
					entity:GetPhysicsObject():EnableMotion(false);
				end;
			end;
			
			if (v.color) then
				entity:SetColor(unpack(v.color));
			end;
			
			if (v.name != "") then
				entity:SetNetworkedString("Name", v.name);
			end;
			
			if v.password then
				entity:SetNWBool("hasPassword", true);
				entity:SetNWBool("unlocked", false);
			end
			
			self.storage[entity] = entity;
			
			entity.cwInventory = Clockwork.inventory:ToLoadable(v.inventory);
			entity.cwPassword = v.password;
			entity.cwMessage = v.message;
			entity.cwCash = v.cash;
			entity.cwLockType = v.lockType;
			
			if (v.lockTier) then
				entity.cwLockTier = v.lockTier;
			else
				entity.cwLockTier = 3;
			end;
			
			hook.Run("ModifyLoadStorageEntityTab", entity, v);
		end;
	end;
end

-- A function to open a container for a player.
function cwStorage:OpenContainer(player, entity, weight)
	local inventory
	local cash = 0
	local model = string.lower(entity:GetModel())
	local name = ""
	
	if (!entity.cwInventory) then
		self.storage[entity] = entity

		entity.cwInventory = {}
	end

	if (!entity.cwCash) then
		entity.cwCash = 0
	end

	if (self.containerList[model]) then
		name = self.containerList[model][2]
	else
		name = "Container"
	end

	inventory = entity.cwInventory
	cash = entity.cwCash

	if (!weight) then
		weight = 8
	end

	if (entity:GetNetworkedString("Name") != "") then
		name = entity:GetNetworkedString("Name")
	end
	
	if hook.Run("PlayerCanOpenContainer", player, entity) == false then
		return false;
	end
	
	hook.Run("PreOpenedContainer", player, entity);

	if (entity.cwMessage) then
		netstream.Start(player, "StorageMessage", {
			entity = entity, message = entity.cwMessage
		})
	end

	Clockwork.storage:Open(player, {
		name = name,
		weight = weight,
		entity = entity,
		distance = 192,
		cash = cash,
		inventory = inventory,
		OnGiveCash = function(player, storageTable, cash)
			storageTable.entity.cwCash = storageTable.cash
		end,
		OnTakeCash = function(player, storageTable, cash)
			storageTable.entity.cwCash = storageTable.cash
		end
	})
end

-- A function to start a lockpick minigame.
function cwStorage:StartLockpick(player)
	local entity = player.ActiveContainer;
	
	if (!IsValid(entity) or !entity.cwLockTier or entity:GetNWBool("unlocked", true) == true) then
		return;
	end;

	if (!entity.LockpickCooldown or CurTime() > entity.LockpickCooldown) then
		if (!player.LockpickCooldown or CurTime() > player.LockpickCooldown) then
			local lockstrength = entity.cwLockTier or 1;

			if (lockstrength == 4) then
				Schema:EasyText(player, "peru", "You cannot lockpick this lock!");
				return;
			end;
			
			if (!player:HasItemByID("lockpick")) then
				Schema:EasyText(player, "chocolate", "You have no lockpick!");
				return;
			end;
			
			if cwBeliefs and player.HasBelief then
				if (lockstrength == 3) and not player:HasBelief("safecracker") then
					Schema:EasyText(player, "chocolate", "You need the 'Safecracker' belief to pick Tier III locks!");
					return;
				elseif not player:HasBelief("sly_fidget") then
					Schema:EasyText(player, "chocolate", "You need the 'Sly Fidget' belief to pick Tier I and Tier II locks!");
					return;
				end
			end
			
			-- Added this to uncloak people who are cloaked and lockpicking, we can maybe do more with it.
			hook.Run("LockpickingStarted", player, entity);
			
			entity.LockpickingPlayer = player;
			player:Freeze(true);
			player.LockpickContainer = entity;
			player.Lockpicking = true;
			netstream.Start(player, "StartLockpick", {entity = entity, lockTier = lockstrength});
		else
			Schema:EasyText(player, "peru", "You cannot lockpick for another "..math.ceil(player.LockpickCooldown - CurTime()).." seconds!");
		end;
	else
		Schema:EasyText(player, "peru", "You cannot lockpick this container for another "..math.ceil(entity.LockpickCooldown - CurTime()).." seconds!");
	end;
end;

-- Called when a player fails a lockpick minigame.
function cwStorage:LockpickFail(player, timeout)
	local entity = player.ActiveContainer;
	local curTime = CurTime();

	player:Freeze(false);
	
	if IsValid(player.LockpickContainer) and player.LockpickContainer.LockpickingPlayer then
		player.LockpickContainer.LockpickingPlayer = nil;
	end
	
	player.LockpickContainer = nil;
	player.Lockpicking = nil;
	player.LockpickCooldown = curTime + 1;
	
	if (IsValid(entity)) then
		entity.LockpickCooldown = curTime + 1;
	else
		return;
	end;

	if (player:HasItemByID("lockpick")) then
		local bDidBreak = false;
		local message;
		
		if (timeout == true) then
			if entity.cwLockTier >= 3 and (math.random(1, 10) == 1) then
				message = "You fail to pick the lock, and in the process your lockpick breaks!";
				bDidBreak = true;
			else
				local itemTable = player:FindItemByID("lockpick");
				local quality = itemTable:GetCondition();
				
				if (quality <= 10) then
					message = "You fail to pick the lock, and in the process your lockpick breaks from overuse!";
					bDidBreak = true;
				else
					itemTable:TakeCondition(10);
					Schema:EasyText(player, "peru", "You fail to pick the lock!");
				end;
			end;
		end;
		
		if (bDidBreak and message) then
			player:EmitSound("physics/metal/metal_computer_impact_bullet1.wav");
			player:TakeItemByID("lockpick");
			Schema:EasyText(player, "peru", message);
		end;
		
		player:EmitSound("buttons/lever6.wav");
	end;
end;

-- A function to complete a player's lockpick minigame.
function cwStorage:FinishLockpick(player, entity)
	player:Freeze(false);
	
	if IsValid(player.LockpickContainer) and player.LockpickContainer.LockpickingPlayer then
		player.LockpickContainer.LockpickingPlayer = nil;
	end
	
	player.Lockpicking = nil;
	player:EmitSound("buttons/lever7.wav");
	
	if (!IsValid(entity)) then
		return;
	end;
	
	if (!IsValid(player.ActiveContainer) or !IsValid(player.LockpickContainer)) then
		return;
	end;
	
	if (player.LockpickContainer != entity or player.ActiveContainer != entity) then
		return; -- abuse
	end;
	
	if (!player:HasItemByID("lockpick")) then
		return;
	end;
	
	local model = string.lower(entity:GetModel());
	
	if (cwStorage.containerList[model]) then
		local containerWeight = cwStorage.containerList[model][1];
		
		Schema:EasyText(player, "olivedrab", "You successfully lockpick the container.");
		cwStorage:OpenContainer(player, entity, containerWeight);
		
		if entity.cwPassword then
			Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has opened the passworded container "..entity:GetNetworkedString("Name").." by lockpicking it!");
		end
		
		if entity.cwLockType == "none" then
			entity:SetNWBool("unlocked", true);
		end
	end;
	
	player.LockpickContainer = nil;

	hook.Run("LockpickFinished", player, entity);
end;

-- Called when a player attempts to use a key item.
function cwStorage:TryKey(player, itemTable, entity)
	local model = entity:GetModel();

	if (!cwStorage.containerList[model]) then
		Schema:EasyText(player, "firebrick", "You cannot unlock this object!");
		return;
	end;
	
	if (!entity.cwPassword) then
		Schema:EasyText(player, "peru", "This container does not have a lock!");
		return;
	end;
	
	if (entity.cwLockType != "key") then
		Schema:EasyText(player, "peru", "You cannot use a key on this type of lock!");
		return;
	end;
	
	local password = entity.cwPassword;
	local itemID = itemTable.itemID;
	
	if (tostring(itemID) == tostring(password)) then
		netstream.Start(player, "CloseMenu");
		local containerWeight = cwStorage.containerList[model][1];
		cwStorage:OpenContainer(player, entity, containerWeight);
		entity:EmitSound("buttons/lever6.wav", 70, 135)
	end;
end;

-- A function to apply a lock to a container.
function cwStorage:ApplyLock(player, itemTable, entity)
	if (!itemTable or !IsValid(entity)) then
		return;
	end;

	if (entity.cwPassword) then
		Schema:EasyText(player, "peru", "This container already has a lock on it!");
		return;
	end;
	
	local model = entity:GetModel();
	local lockType = itemTable.lockType;
	
	if (!cwStorage.containerList[model]) then
		Schema:EasyText(player, "peru", "You cannot apply a lock to this!");
		return;
	end;
	
	Clockwork.dermaRequest:RequestConfirmation(player, "Lock Confirmation", "Are you sure you want to put a "..string.lower(itemTable.name).." on this "..string.lower(cwStorage.containerList[model][2]).."?", function()
		if (lockType == "key") then
			local useSound = itemTable.useSound or "items/battery_pickup.wav";
			local lockTier = itemTable.lockTier;
			local uniqueID = itemTable.uniqueID;
			local itemId = itemTable.itemID;
			
			player:TakeItemByID(uniqueID, itemID);
			player:EmitSound(useSound);
			
			local keyItem = player:GiveItem(Clockwork.item:CreateInstance("key"), true);
			local keyItemID = keyItem.itemID;
			
			entity.cwPassword = tostring(keyItemID);
			entity.cwLockType = lockType;
			entity.cwLockTier = lockTier;
			
			Schema:EasyText(player, "indianred", "You lock the padlock with a key that came with it. You only have one key, so do not lose it.");
		else
			player.LockSet = true;
			player.ActiveContainer = entity;
			player.LockItem = itemTable;
			player.CurrentLockType = lockType;
			
			netstream.Start(player, "LockInteract", {lockType, true, entity});
		end;
	end);
	
	netstream.Start(player, "CloseMenu");
end;

-- A function to spawn a keycutting machine.
function cwStorage:AddKeyCuttingMachine(position)
	local machine = ents.Create("prop_physics");
	machine:SetPos(position);
	machine:SetAngles(Angle(0, 0, 0));
	machine:SetModel("models/props_lab/tpswitch.mdl");
	machine:Spawn();
	machine:SetNWBool("key_machine", true);
end;

-- A function to make a duplicate copy of a key.
function cwStorage:MakeKeyCopy(player, itemTable)
	local itemID = itemTable.itemID;
	local newKey = player:GiveItem(Clockwork.item:CreateInstance("key"), true);
	
	if (newKey) then
		newKey:SetData("KeyID", itemID);
		newKey:SetData("KeyName", string.sub(itemID, string.len(itemID) - 1, string.len(itemID)));
		newKey:SetData("bIsCopy", true);
		
		Schema:EasyText(player, "olivedrab", "You make a copy of the key.");
	end;
end;

-- A function to handle a container lock.
function cwStorage:HandleContainerLock(player, data)
	local entity = player.ActiveContainer;
	local lockType = data.lockType;

	if (!data.lockType) then
		return;
	end;
	
	if (!IsValid(entity)) then
		Schema:EasyText(player, "darkgrey", "You must select a valid lock to interact with!");
		return;
	end;

	if (data.set) then
		if (!player.LockSet) then
			--player:Kick("Tampering with datastreams. Admins have been notified of your abuse.");
			print(player:Name().." - HandleContainerLock without player.LockSet variable")
			return
		else
			player.LockSet = nil;
		end;
		
		local lockItem = player.LockItem;

		if (!lockItem) then
			return;
		end;
		
		if (!lockType or !player.CurrentLockType) then
			return;
		elseif (player.CurrentLockType != lockType) then
			return;
		end;
		
		if (lockType == "combo") then
			if (!data.one or !data.two or !data.three or !data.four) then
				Schema:EasyText(player, "peru", "You must specify a four digit combination!");
				return;
			end;
			
			local valueTable = {data.one, data.two, data.three, data.four};
			local password = table.concat(valueTable, "");
			
			entity.cwPassword = tostring(password);
			entity.cwLockType = lockType;

			Schema:EasyText(player, "indianred", "You have set a 4-digit passcode for this lock: "..password);
		elseif (lockType == "turn") then
			local valueTable = {data.one, data.two, data.three};
			local password = table.concat(valueTable, "");
			
			for k, value in pairs (valueTable) do
				if (value > 40 or value < 0) then
					Schema:EasyText(player, "peru", "Your combination must contain numbers between 0 and 40!");
					
					return;
				else
					valueTable[k] = math.Round(value);
				end;
			end;
			
			entity.cwPassword = tostring(password);
			entity.cwLockType = lockType;

			Schema:EasyText(player, "indianred", "You have set a 3 number passcode for this lock: "..(data.one.."-"..data.two.."-"..data.three));
		end;

		local useSound = lockItem.useSound or "items/battery_pickup.wav";
		local uniqueID = lockItem.uniqueID;
		local itemID = lockItem.itemID;
		
		player:TakeItemByID(uniqueID, itemID);
		player:EmitSound(useSound);
		entity:EmitSound("ambient/materials/clang1.wav", 100, 150);
	else
		if (lockType == "combo" or lockType == "turn") then
			if (!data.one or !data.two or !data.three) then
				Schema:EasyText(player, "peru", "You must specify a "..(string.find(lockType, "combo") and "four" or "three").." digit combination!");
				
				return;
			end;
			
			local valueTable = {data.one, data.two, data.three};
			
			if (lockType == "combo") then
				if (!data.four) then
					Schema:EasyText(player, "peru", "You must specify a four digit combination!");
					return;
				else
					valueTable[#valueTable + 1] = data.four;
				end;
			end;
			
			local model = entity:GetModel();
			local containerWeight = cwStorage.containerList[model][1];
			local password = table.concat(valueTable, "");

			if (tostring(password) == tostring(entity.cwPassword)) then
				cwStorage:OpenContainer(player, entity, containerWeight);
				entity:EmitSound("buttons/lever6.wav", 70, 135)
				
				if (data.unlock) then
					entity:SetNWBool("unlocked", true);
				end;
			else
				Schema:EasyText(player, "peru", "You have entered an incorrect combination!");
			end;
		elseif (lockType == "key") then
			local password = entity.cwPassword;
			local itemID = data.keyID;
			local uniqueID = data.uniqueID;

			if (tostring(password) == tostring(itemID)) then
				cwStorage:OpenContainer(player, entity, containerWeight);
				entity:EmitSound("buttons/lever6.wav", 70, 135)
				
				if (data.unlock) then
					entity:SetNWBool("unlocked", true);
				end;
			else
				Schema:EasyText(player, "peru", "This key does not fit the lock of this container!");
			end;
		end;
	end;
	
	player.ActiveContainer = nil;
	player.CurrentLockType = nil;
	player.LockItem = nil;
	player.LockSet = nil;
end;

netstream.Hook("StartLockpick", function(player, data)
	cwStorage:StartLockpick(player)
end);

netstream.Hook("LockpickFail", function(player, data)
	cwStorage:LockpickFail(player, data);
end);

netstream.Hook("SuccessfulPick", function(player, data)
	if (player.Lockpicking) then
		if player.LockpickContainer and player.LockpickContainer.cwPassword then
			player:EmitSound("weapons/357/357_reload"..table.Random({"1", "3", "4"})..".wav", 100);
		else
			player:EmitSound("weapons/357/357_reload"..table.Random({"1", "3", "4"})..".wav");
		end
	else
		print(player:Name().." - SuccessfulPick without player.Lockpicking variable")
		--player:Kick("Abusing datastreams");
		return
	end;
end);

netstream.Hook("AbortLockpick", function(player, data)
	player.LockpickCooldown = CurTime() + 1;
	player:Freeze(false);
	player.Lockpicking = nil;
	player.ActiveContainer = nil;
	
	if IsValid(player.LockpickContainer) and player.LockpickContainer.LockpickingPlayer then
		player.LockpickContainer.LockpickingPlayer = nil;
	end
	
	player.LockpickContainer = nil;
end);

netstream.Hook("FinishLockpick", function(player, data)
	cwStorage:FinishLockpick(player, data)
end);

netstream.Hook("LockCombo", function(player, data)
	cwStorage:HandleContainerLock(player, data);
end);

netstream.Hook("ContainerPassword", function(player, data)
	local password = data[1];
	local entity = data[2];
	
	if (IsValid(entity) and Clockwork.entity:IsPhysicsEntity(entity)) then
		local model = string.lower(entity:GetModel());
		
		if (cwStorage.containerList[model]) then
			local containerWeight = cwStorage.containerList[model][1];
			
			if (entity.cwPassword == password) then
				cwStorage:OpenContainer(player, entity, containerWeight);
				Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has opened the passworded container "..entity:GetNetworkedString("Name").." by using a password.");
			else
				Schema:EasyText(player, "peru", "You have entered an incorrect password!");
			end;
		end;
	end;
end);