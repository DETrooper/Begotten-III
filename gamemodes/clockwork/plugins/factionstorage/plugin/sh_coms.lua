--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local COMMAND = Clockwork.command:New("ContSetFactionLock")
COMMAND.tip = "Set a container's faction lock."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if (!trace.Entity.cwInventory) then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.cwInventory = {}
				end
				
				player.cwFactionStorageSetup = true;
				player.cwFactionStorageEditing = trace.Entity;
				
				local data = trace.Entity.cwFactionLock or {};
				
				netstream.Start(player, "FactionStorageAdd", {
					name = trace.Entity:GetNetworkedString("Name") or "Container",
					factions = data.factions or {},
					subfactions = data.subfactions or {},
					ranks = data.ranks or {},
					subfaiths = data.subfaiths or {},
				});
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContTakeFactionLock")
COMMAND.tip = "Reset a container's faction lock."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if !trace.Entity.cwFactionLock then
					Schema:EasyText(player, "grey", "["..self.name.."] This container does not have a faction lock!")
				
					return;
				end
				
				if (!trace.Entity.cwInventory) then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.cwInventory = {}
				end
				
				trace.Entity.cwFactionLock = nil;

				if !trace.Entity.cwPassword then
					trace.Entity.cwLockTier = nil;
					trace.Entity:SetNWBool("unlocked", true);
				end
				
				cwStorage:SaveStorage();

				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] This container's faction lock has been removed.")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
			end	
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContCopyFactionLock")
COMMAND.tip = "Copy a container's faction lock. Paste with ContPasteFactionLock."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.alias = {"CopyFactionLock"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if !trace.Entity.cwFactionLock then
					Schema:EasyText(player, "grey", "["..self.name.."] This container does not have a faction lock!")
				
					return;
				end
				
				if (!trace.Entity.cwInventory) then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.cwInventory = {}
				end
				
				player.cwFactionLockCopy = table.Copy(trace.Entity.cwFactionLock);

				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] This container's faction lock has been copied!")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
			end	
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContPasteFactionLock")
COMMAND.tip = "Paste a copied container's faction lock onto another container."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.alias = {"PasteFactionLock"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if (!trace.Entity.cwInventory) then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.cwInventory = {}
				end
				
				local data = player.cwFactionLockCopy;
				
				if !data then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You do not have a faction lock copied!")
				
					return false;
				end

				if !table.IsEmpty(data.factions) or !table.IsEmpty(data.subfactions) or !table.IsEmpty(data.ranks) or !table.IsEmpty(data.subfaiths) then
					trace.Entity.cwFactionLock = table.Copy(data);
					trace.Entity.cwLockTier = 3;
					trace.Entity:SetNWBool("unlocked", false);
					trace.Entity:SetNWBool("hasPassword", true);
				else
					trace.Entity.cwFactionLock = nil;
					trace.Entity.cwLockTier = nil;
					trace.Entity:SetNWBool("unlocked", true);
					
					if !trace.Entity.cwPassword then
						trace.Entity:SetNWBool("hasPassword", false);
					end
				end
				
				cwStorage:SaveStorage();

				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] This container's faction lock has been pasted!")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
			end	
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()
