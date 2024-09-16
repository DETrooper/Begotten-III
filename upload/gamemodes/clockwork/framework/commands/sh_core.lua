local COMMAND = Clockwork.command:New("StorageTakeItem");
	COMMAND.tip = "Take an item from storage.";
	COMMAND.text = "<string uniqueID> <string ItemID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local itemID = tonumber(arguments[2]);
		
		if (storageTable and IsValid(storageTable.entity)) then
			local itemTable = Clockwork.inventory:FindItemByID(
				storageTable.inventory, uniqueID, itemID
			);
			
			if (!itemTable) then
				Clockwork.player:Notify(player, "The storage does not contain an instance of this item!");
				return;
			end;
			
			Clockwork.storage:TakeFrom(player, itemTable);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageTakeItems");
	COMMAND.tip = "Take multiple items from storage. Not specifying an amount will take all items matching the specified uniqueID.";
	COMMAND.text = "<string UniqueID> [number Amount] [string Sort]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local amount = tonumber(arguments[2]);
		local sortString = arguments[3];
		
		if (storageTable and IsValid(storageTable.entity)) then
			local target = storageTable.entity;
			
			if (storageTable.isOneSided) then
				Clockwork.player:Notify(player, "You cannot give items to this container!");
				return;
			end;
			
			local items = Clockwork.inventory:GetItemsByID(storageTable.inventory, uniqueID);
			
			if !items or table.IsEmpty(items) then
				Clockwork.player:Notify(player, "The storage does not contain any items of this type!");
				return;
			end
			
			local sequentialItems = {};
			
			for k, v in pairs(items) do
				table.insert(sequentialItems, v);
			end
			
			items = nil;
			
			if sortString == "bestCondition" then
				table.sort(sequentialItems, function(a, b) return a:GetCondition() > b:GetCondition() end);
			elseif sortString == "worstCondition" then
				table.sort(sequentialItems, function(a, b) return a:GetCondition() < b:GetCondition() end);
			end
			
			local successfulItems = {};
			local playerInventory = player:GetInventory();
			
			for i = 1, math.min(amount or #sequentialItems, 250) do
				local itemTable = sequentialItems[i];
				local success = Clockwork.storage:TakeFrom(player, itemTable, true);
				local fault;
				
				if success then
					if (player:CanHoldWeight(itemTable.weight) and player:CanHoldSpace(itemTable.space)) then
						if (itemTable.OnGiveToPlayer) then
							itemTable:OnGiveToPlayer(player)
						end

						Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has gained a "..itemTable.name.." "..itemTable.itemID..".")

						Clockwork.inventory:AddInstance(playerInventory, itemTable);
					else
						success = false;
						fault = "You can only carry up to four times your non-overencumbered carrying capacity!";
					end
				end
				
				if !success then
					if fault then
						Schema:EasyText(player, "peru", fault);
					end
					
					if i == 1 then
						return;
					else
						break;
					end
				end
				
				hook.Run("PlayerTakeFromStorage", player, storageTable, itemTable)
				
				table.insert(successfulItems, itemTable);
			end
			
			local players = {}
			local inventory = Clockwork.storage:Query(player, "inventory");
				
			for _, v in _player.Iterator() do
				if (v:HasInitialized() and Clockwork.storage:Query(v, "inventory") == inventory) then
					players[#players + 1] = v
				end
			end
			
			local definitions = {};
			local signatures = {};
			local itemTable = sequentialItems[1];
			
			for i, v in ipairs(successfulItems) do
				local definition = item.GetDefinition(v, true)
				local signature = item.GetSignature(v);
				
				-- idk why this is needed when InvGive doesnt need it but whatever
				definition.index = v.uniqueID;
					
				table.insert(definitions, definition);
				table.insert(signatures, signature);
			end
			
			netstream.Start(player, "InvGiveItems", definitions);
			
			Clockwork.inventory:Rebuild(player);
			
			if (!target or !target:IsPlayer()) then
				for i, v in ipairs(successfulItems) do
					Clockwork.inventory:RemoveInstance(inventory, v);
				end
			else
				local targetInventory = target:GetInventory()
			
				for i, v in ipairs(successfulItems) do
					if (v.OnTakeFromPlayer) then
						v:OnTakeFromPlayer(target)
					end
					
					Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, target:Name().." has lost a "..v.name.." "..v.itemID..".")

					--hook.Run("PlayerItemTaken", target, v);
					
					Clockwork.kernel:ForceUnequipItem(target, v.uniqueID, v.itemID);
					Clockwork.inventory:RemoveInstance(targetInventory, v);
					--netstream.Start(target, "InvTake", {v.index, v.itemID});
				end
				
				netstream.Start(target, "InvTakeItems", signatures);
				
				Clockwork.inventory:Rebuild(target);
			end
				
			for _, v in _player.Iterator() do
				if (v:HasInitialized() and Clockwork.storage:Query(v, "inventory") == inventory) then
					players[#players + 1] = v
				end
			end
			
			netstream.Start(
				players, "StorageTake", {itemList = signatures}
			)

			if (storageTable.OnTakeItem and storageTable.OnTakeItem(player, storageTable, itemTable)) then
				Clockwork.storage:Close(player)
			end

			if (itemTable.OnStorageTake and itemTable:OnStorageTake(player, itemTable)) then
				Clockwork.storage:Close(player)
			end

			if (target:IsPlayer()) then
				Clockwork.storage:UpdateWeight(player, target:GetMaxWeight())
				Clockwork.storage:UpdateSpace(player, target:GetMaxSpace())
			end

			hook.Run("PostPlayerTakeFromStorage", player, storageTable, itemTable)
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Unequip");
	COMMAND.tip = "Unequip a weapon.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = arguments[1];
		
		for k, v in pairs (player:GetWeapons()) do
			if (string.lower(v:GetClass()) == string.lower(target)) then
				local itemTable = item.GetByWeapon(v);

				if (itemTable) then
					Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID)
				end;
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageTakeCash");
	COMMAND.tip = "Take some cash from storage.";
	COMMAND.text = "<number Cash>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			local target = storageTable.entity;
			local cash = math.floor(tonumber(arguments[1]));
			
			if (!IsValid(target) or !config.Get("cash_enabled"):Get()) then
				return;
			end;
			
			if (cash and cash > 1 and cash <= storageTable.cash) then
				if (!storageTable.CanTakeCash
				or (storageTable.CanTakeCash(player, storageTable, cash) != false)) then
					if (!target:IsPlayer()) then
						Clockwork.player:GiveCash(player, cash, nil, true);
						Clockwork.storage:UpdateCash(player, storageTable.cash - cash);
					else
						Clockwork.player:GiveCash(player, cash, nil, true);
						Clockwork.player:GiveCash(target, -cash, nil, true);
						Clockwork.storage:UpdateCash(player, target:GetCash());
					end;
					
					if (storageTable.OnTakeCash
					and storageTable.OnTakeCash(player, storageTable, cash)) then
						Clockwork.storage:Close(player);
					end;
				end;
			end;
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageGiveItem");
	COMMAND.tip = "Give an item to storage.";
	COMMAND.text = "<string UniqueID> <string ItemID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local itemID = tonumber(arguments[2]);
		
		if (storageTable and IsValid(storageTable.entity)) then
			local itemTable = player:FindItemByID(uniqueID, itemID);
			local target = storageTable.entity;
			
			if (!itemTable) then
				Clockwork.player:Notify(player, "You do not have an instance of this item!");
				return;
			end;
			
			if (storageTable.isOneSided) then
				Clockwork.player:Notify(player, "You cannot give items to this container!");
				return;
			end;
			
			Clockwork.storage:GiveTo(player, itemTable);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageGiveItems");
	COMMAND.tip = "Give multiple items to storage. Not specifying an amount will give all items matching the specified uniqueID.";
	COMMAND.text = "<string UniqueID> [number Amount] [string Sort]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		local uniqueID = arguments[1];
		local amount = tonumber(arguments[2]);
		local sortString = arguments[3];
		
		if (storageTable and IsValid(storageTable.entity)) then
			local target = storageTable.entity;
			
			if (storageTable.isOneSided) then
				Clockwork.player:Notify(player, "You cannot give items to this container!");
				return;
			end;
			
			local items = player:GetItemsByID(uniqueID);
			
			if !items or table.IsEmpty(items) then
				Clockwork.player:Notify(player, "You do not have any items of this type!");
				return;
			end
			
			local sequentialItems = {};
			
			for k, v in pairs(items) do
				table.insert(sequentialItems, v);
			end
			
			items = nil;
			
			if sortString == "bestCondition" then
				table.sort(sequentialItems, function(a, b) return a:GetCondition() > b:GetCondition() end);
			elseif sortString == "worstCondition" then
				table.sort(sequentialItems, function(a, b) return a:GetCondition() < b:GetCondition() end);
			end
			
			local successfulItems = {};
			
			for i = 1, math.min(amount or #sequentialItems, 250) do
				local itemTable = sequentialItems[i];
				local success = Clockwork.storage:GiveTo(player, itemTable, true);
				
				if !success then
					if i == 1 then
						return;
					else
						break;
					end
				end
				
				table.insert(successfulItems, itemTable);
			end
			
			local players = {}
			local inventory = Clockwork.storage:Query(player, "inventory");
				
			for _, v in _player.Iterator() do
				if (v:HasInitialized() and Clockwork.storage:Query(v, "inventory") == inventory) then
					players[#players + 1] = v
				end
			end
			
			local definitions = {};
			local signatures = {};
			local itemTable = sequentialItems[1];
			
			for i, v in ipairs(successfulItems) do
				local definition = item.GetDefinition(v, true)
				local signature = item.GetSignature(v);
				
				definition.index = nil
					
				table.insert(definitions, definition);
				table.insert(signatures, signature);
			end
			
			netstream.Start(
				players, "StorageGive", {index = itemTable.index, itemList = definitions}
			)
			
			local playerInventory = player:GetInventory();
			
			for i, v in ipairs(successfulItems) do
				if (v.OnTakeFromPlayer) then
					v:OnTakeFromPlayer(player)
				end
				
				Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has lost a "..v.name.." "..v.itemID..".")

				--hook.Run("PlayerItemTaken", player, v);
				
				Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
				Clockwork.inventory:RemoveInstance(playerInventory, v);
			end

			netstream.Start(player, "InvTakeItems", signatures);
			
			Clockwork.inventory:Rebuild(player);
			
			if (storageTable.OnGiveItem and storageTable.OnGiveItem(player, storageTable, itemTable)) then
				Clockwork.storage:Close(player)
			end

			if (itemTable.OnStorageGive and itemTable:OnStorageGive(player, storageTable)) then
				Clockwork.storage:Close(player)
			end

			if (target:IsPlayer()) then
				Clockwork.storage:UpdateWeight(player, target:GetMaxWeight())
				Clockwork.storage:UpdateSpace(player, target:GetMaxSpace())
			end

			hook.Run("PostPlayerGiveToStorage", player, storageTable, itemTable)
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local NAME_CASH = Clockwork.option:GetKey("name_cash");
local COMMAND = Clockwork.command:New("StorageGiveCash");
	COMMAND.tip = "Give some cash to storage.";
	COMMAND.text = "<number Cash>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			local target = storageTable.entity;
			local cash = math.floor(tonumber(arguments[1]));
			
			if (!IsValid(target) or !config.Get("cash_enabled"):Get()) then
				return;
			end;
				
			if (cash and cash > 1 and Clockwork.player:CanAfford(player, cash)) then
				if (!storageTable.CanGiveCash
				or (storageTable.CanGiveCash(player, storageTable, cash) != false)) then
					if (!target:IsPlayer()) then
						local cashWeight = config.Get("cash_weight"):Get();
						local myWeight = Clockwork.storage:GetWeight(player);

						local cashSpace = config.Get("cash_space"):Get();
						local mySpace = Clockwork.storage:GetSpace(player);
						
						if (myWeight + (cashWeight * cash) <= storageTable.weight and mySpace + (cashSpace * cash) <= storageTable.space) then
							Clockwork.player:GiveCash(player, -cash, nil, true);
							Clockwork.storage:UpdateCash(player, storageTable.cash + cash);
						end;
					else
						Clockwork.player:GiveCash(player, -cash, nil, true);
						Clockwork.player:GiveCash(target, cash, nil, true);
						Clockwork.storage:UpdateCash(player, target:GetCash());
					end;
					
					if (storageTable.OnGiveCash
					and storageTable.OnGiveCash(player, storageTable, cash)) then
						Clockwork.storage:Close(player);
					end;
				end;
			end;
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StorageClose");
	COMMAND.tip = "Close the active storage.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local storageTable = player:GetStorageTable();
		
		if (storageTable) then
			Clockwork.storage:Close(player, true);
		else
			Clockwork.player:Notify(player, "You do not have storage open!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SetClass");
	COMMAND.tip = "Set the class of your character.";
	COMMAND.text = "<string Class>";
	COMMAND.flags = CMD_HEAVY;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local class = Clockwork.class:FindByID(arguments[1]);
		
		if (player:InVehicle()) then
			Clockwork.player:Notify(player, "You cannot do this action at the moment!");
			return;
		end;
		
		if (class) then
			local limit = Clockwork.class:GetLimit(class.name);
			
			if (hook.Run("PlayerCanBypassClassLimit", player, class.index)) then
				limit = game.MaxPlayers();
			end;
			
			if (_team.NumPlayers(class.index) < limit) then
				local previousTeam = player:Team();
				
				if (player:Team() != class.index
				and Clockwork.kernel:HasObjectAccess(player, class)) then
					if (hook.Run("PlayerCanChangeClass", player, class)) then
						local bSuccess, fault = Clockwork.class:Set(player, class.index, nil, true);
						
						if (!bSuccess) then
							Clockwork.player:Notify(player, fault);
						end;
					end;
				else
					Clockwork.player:Notify(player, "You do not have access to this class!");
				end;
			else
				Clockwork.player:Notify(player, "There are too many characters with this class!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid class!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("OrderShipment");
	COMMAND.tip = "Order an item shipment at your target position.";
	COMMAND.text = "<string UniqueID>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local itemTable = item.FindByID(arguments[1]);
		
		if (!itemTable or !itemTable:CanBeOrdered()) then
			return false;
		end;
		
		itemTable = item.CreateInstance(itemTable.uniqueID);
		hook.Run("PlayerAdjustOrderItemTable", player, itemTable);
		
		if (!Clockwork.kernel:HasObjectAccess(player, itemTable)) then
			Clockwork.player:Notify(player, "You not have access to order this item!");
			return false;
		end;
		
		if (hook.Run("PlayerCanOrderShipment", player, itemTable) == false) then
			return false;
		end;
		
		if (Clockwork.player:CanAfford(player, itemTable.cost * itemTable.batch)) then
			local trace = player:GetEyeTraceNoCursor();
			local entity = nil;

			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				if (itemTable.CanOrder and itemTable:CanOrder(player, v) == false) then
					return false;
				end;
				
				if (itemTable.batch > 1) then
					Clockwork.player:GiveCash(player, -(itemTable.cost * itemTable.batch), itemTable.batch.." "..Clockwork.kernel:Pluralize(itemTable.name));
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable.batch.." "..Clockwork.kernel:Pluralize(itemTable.name)..".");
				else
					Clockwork.player:GiveCash(player, -(itemTable.cost * itemTable.batch), itemTable.batch.." "..itemTable.name);
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has ordered "..itemTable.batch.." "..itemTable.name..".");
				end;
				
				if (itemTable.OnCreateShipmentEntity) then
					entity = itemTable:OnCreateShipmentEntity(player, itemTable.batch, trace.HitPos);
				end;
				
				if (!IsValid(entity)) then
					if (itemTable.batch > 1) then
						entity = Clockwork.entity:CreateShipment(player, itemTable.uniqueID, itemTable.batch, trace.HitPos);
					else
						entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
					end;
				end;
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
				end;
				
				if (itemTable.OnOrder) then
					itemTable:OnOrder(player, entity);
				end;
				
				hook.Run("PlayerOrderShipment", player, itemTable, entity);
				player.cwNextOrderTime = CurTime() + (2 * itemTable.batch);
				
				netstream.Start(player, "OrderTime", player.cwNextOrderTime);
			else
				Clockwork.player:Notify(player, "You cannot order this item that far away!");
			end;
		else
			local amount = (itemTable.cost * itemTable.batch) - player:GetCash();
			Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GiveCoin");
COMMAND.tip = "Give coin to a target character.";
COMMAND.text = "<number Coin>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"GiveTokens", "GiveCash"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if arguments[1] and tonumber(arguments[1]) then
		local cash = math.floor(tonumber((arguments[1] or 0)));
		
		if (target and target:IsPlayer()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then			
				if (cash and cash >= 1) then
					if (Clockwork.player:CanAfford(player, cash)) then
						local playerName = player:Name();
						local targetName = target:Name();
						
						if (!Clockwork.player:DoesRecognise(player, target)) then
							targetName = Clockwork.player:GetUnrecognisedName(target, true);
						end;
						
						if (!Clockwork.player:DoesRecognise(target, player)) then
							playerName = Clockwork.player:GetUnrecognisedName(player, true);
						end;
						
						player:EmitSound("generic_ui/coin_0"..tostring(math.random(1, 3))..".wav");
						
						Clockwork.player:GiveCash(player, -cash);
						Clockwork.player:GiveCash(target, cash);
						
						Clockwork.player:Notify(player, "You have given "..Clockwork.kernel:FormatCash(cash, nil, true).." to "..targetName..".");
						Clockwork.player:Notify(target, "You were given "..Clockwork.kernel:FormatCash(cash, nil, true).." by "..playerName..".");
					else
						local amount = cash - player:GetCash();
						Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
					end;
				else
					Clockwork.player:Notify(player, "This is not a valid amount!");
				end;
			else
				Clockwork.player:Notify(player, "This character is too far away!");
			end;
		else
			Clockwork.player:Notify(player, "You must look at a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid amount!");
	end
end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropWeapon");
	COMMAND.tip = "Drop your weapon at your target position.";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			local weapon = player:GetActiveWeapon();
			
			if (IsValid(weapon)) then
				local class = weapon:GetClass();
				local itemTable = item.GetByWeapon(weapon);
				
				if (!itemTable) then
					Clockwork.player:Notify(player, "This is not a valid weapon!");
					return;
				end;
				
				if (hook.Run("PlayerCanDropWeapon", player, itemTable, weapon)) then
					local trace = player:GetEyeTraceNoCursor();
					
					if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
						local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
						
						if (IsValid(entity)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
							Clockwork.kernel:ForceUnequipItem(player, itemTable.uniqueID, itemTable.itemID);
							
							player:TakeItem(itemTable);
							player:StripWeapon(class);
							player:SelectWeapon("begotten_fists");
							
							hook.Run("PlayerDropWeapon", player, itemTable, entity, weapon);
						end;
					else
						Schema:EasyText(player, "peru", "You cannot drop your weapon that far away!");
					end;
				end;
			else
				Schema:EasyText(player, "peru", "This is not a valid weapon!");
			end;
		else
			Schema:EasyText(player, "peru", "You cannot perform this action while in a duel!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropShield");
	COMMAND.tip = "Drop your shield at your target position.";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			for k, v in pairs(player.equipmentSlots) do
				if v and v.category == "Shields" then
					if (hook.Run("PlayerCanDropWeapon", player, v)) then
						local trace = player:GetEyeTraceNoCursor();
						
						if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
							local entity = Clockwork.entity:CreateItem(player, v, trace.HitPos);
							
							if (IsValid(entity)) then
								if (v:HasPlayerEquipped(player)) then
									Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
									Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
									player:TakeItem(v);

									return;
								end
							end;
						else
							Schema:EasyText(player, "peru", "You cannot drop your shield that far away!");
						end;
					end
				end
			end;
			
			Schema:EasyText(player, "peru", "This is not a valid shield!");
		else
			Schema:EasyText(player, "peru", "You cannot perform this action while in a duel!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("DropCoin");
	COMMAND.tip = "Drop coin at your target position.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.alias = {"DropTokens", "DropCash"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if not player.opponent then
			local trace = player:GetEyeTraceNoCursor();
			local cash = tonumber(arguments[1]);
			
			if (cash and isnumber(cash) and cash > 1) then
				cash = math.floor(cash);
				
				if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
					if (Clockwork.player:CanAfford(player, cash)) then
						Clockwork.player:GiveCash(player, -cash, "Dropping "..Clockwork.option:GetKey("name_cash"));
						
						local entity = Clockwork.entity:CreateCash(player, cash, trace.HitPos);
						
						if (IsValid(entity)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
						end;
					else
						local amount = cash - player:GetCash();
						Clockwork.player:Notify(player, "You need another "..Clockwork.kernel:FormatCash(amount, nil, true).."!");
					end;
				else
					Clockwork.player:Notify(player, "You cannot drop "..string.lower(NAME_CASH).." that far away!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid amount!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot perform this action while in a duel!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharPhysDesc");
	COMMAND.tip = "Change your character's physical description.";
	COMMAND.text = "[string Text]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 0;
	COMMAND.alias = {"PhysDesc", "SetPhysDesc"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local minimumPhysDesc = config.Get("minimum_physdesc"):Get();

		if (arguments[1]) then
			local text = table.concat(arguments, " ");
			
			if (string.len(text) < minimumPhysDesc) then
				Clockwork.player:Notify(player, "The physical description must be at least "..minimumPhysDesc.." characters long!");
				return;
			end;
			
			player:SetCharacterData("PhysDesc", Clockwork.kernel:ModifyPhysDesc(text));
			player:SaveCharacter();
		else
			Clockwork.dermaRequest:RequestString(player, "Physical Description Change", "What do you want to change your physical description to?", player:GetCharacterData("PhysDesc"), function(result)
				player:RunClockworkCmd(self.name, result);
			end)
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetUp");
	COMMAND.tip = "Get your character up from the floor.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetRagdollState() == RAGDOLL_FALLENOVER and Clockwork.player:GetAction(player) != "unragdoll") then
			if (hook.Run("PlayerCanGetUp", player)) then
				local get_up_time = 5;
				
				if cwBeliefs and player:HasBelief("dexterity") then
					get_up_time = get_up_time * 0.67;
				end
				
				Clockwork.player:SetUnragdollTime(player, get_up_time);
				hook.Run("PlayerStartGetUp", player);
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharCancelGetUp");
	COMMAND.tip = "Stop your character from getting up.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetRagdollState() == RAGDOLL_FALLENOVER and Clockwork.player:GetAction(player) == "unragdoll") then
			if cwMelee and player.stabilityStunned then
				return false;
			end
			
			if (hook.Run("PlayerCanGetUp", player)) then
				Clockwork.player:SetUnragdollTime(player, nil);
				hook.Run("PlayerCancelGetUp", player);
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharFallOver");
	COMMAND.tip = "Make your character fall to the floor.";
	COMMAND.text = "[number Seconds]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"Fallover", "PlyFallover"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local curTime = CurTime();
		
		if (!player.cwNextFallTime or curTime >= player.cwNextFallTime) then
			player.cwNextFallTime = curTime + 5;
			
			if (!player:InVehicle() and !Clockwork.player:IsNoClipping(player) and hook.Run("PlayerCanFallover", player) ~= false) then
				local seconds = tonumber(arguments[1]);
				
				if (seconds) then
					seconds = math.Clamp(seconds, 2, 30);
				elseif (seconds == 0) then
					seconds = nil;
				end;
				
				if (!player:IsRagdolled()) then
					Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, seconds);
				end;
			else
				Clockwork.player:Notify(player, "You cannot do this action at the moment!");
			end;
		end;
	end;
COMMAND:Register();