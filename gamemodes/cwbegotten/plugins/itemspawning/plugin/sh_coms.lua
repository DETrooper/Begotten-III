--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwItemSpawner");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local COMMAND = Clockwork.command:New("AddItemContainerSpawn")
	COMMAND.tip = "Add an item container spawn location using a spawned entity's positions and angles. (Valid categories: "..table.concat(cwItemSpawner.Categories, ", ")..")";
	COMMAND.text = "<string Category>"
	COMMAND.access = "s"
	COMMAND.arguments = 1
	COMMAND.alias = {"AddContainerSpawn"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:AddContainerSpawn(player:GetEyeTrace().Entity, arguments[1], player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveContainerSpawn")
	COMMAND.tip = "Remove an item container spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Radius]"
	COMMAND.types = {"Radius"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:RemoveContainerSpawn(player:GetEyeTrace().HitPos, tonumber(arguments[1]) or 64, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("AddSupercrateSpawn")
	COMMAND.tip = "Add a supercrate spawn location using a spawned entity's positions and angles."
	COMMAND.access = "s"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:AddSupercrateSpawn(player:GetEyeTrace().Entity, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveSupercrateSpawn")
	COMMAND.tip = "Remove a supercrate spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Radius]"
	COMMAND.types = {"Radius"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:RemoveSupercrateSpawn(player:GetEyeTrace().HitPos, tonumber(arguments[1]) or 64, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("AddItemSpawn")
	COMMAND.tip = "Add an item spawn location."
	COMMAND.text = "<string Category>"
	COMMAND.access = "s"
	COMMAND.arguments = 1

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments and arguments[1] then
			if table.HasValue(cwItemSpawner.Categories, arguments[1]) then
				cwItemSpawner:AddItemSpawn(player:GetEyeTrace().HitPos, arguments[1] or nil);
				return true;
			end
		end
		
		Schema:EasyText(player, "darkgrey", "You have specified an invalid category!");
		return false;
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveItemSpawn")
	COMMAND.tip = "Remove an item spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Radius]"
	COMMAND.types = {"Radius"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:RemoveItemSpawn(player:GetEyeTrace().HitPos, tonumber(arguments[1]) or 64, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("SpawnSupercrate")
	COMMAND.tip = "Add an item spawn location."
	COMMAND.text = "[bool TeleportTo]"
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if !cwItemSpawner.SupercrateLocations or #cwItemSpawner.SupercrateLocations <= 0 then
			Schema:EasyText(player, "tomato", "This map does not support supercrates!");
			
			return;
		end
		
		if config.GetVal("loot_spawner_enabled") ~= true then
			Schema:EasyText(player, "tomato", "Loot spawning is currently disabled in the server config!");
		
			return;
		end
		
		if cwItemSpawner.SuperCrate then
			local supercrate = cwItemSpawner.SuperCrate.supercrate;

			if IsValid(supercrate) then
				supercrate.cwInventory = nil;
				supercrate.cwCash = nil;
				supercrate:Remove();
				
				cwItemSpawner.SuperCrate = nil;
				
				Schema:EasyText(player, "lightslategrey", "You have removed the current supercrate.");
			end
		end
		
		local supercrateTab = cwItemSpawner:SpawnSupercrate();

		if supercrateTab then	
			local supercrate = supercrateTab.supercrate;
			
			if IsValid(supercrate) then
				local numItems = table.Count(supercrate.cwInventory);
				
				Schema:EasyText(player, "cornflowerblue", "You have spawned a supercrate with "..tostring(numItems).." items and "..tostring(supercrate.cwCash).." coin!");
		
				if arguments and arguments[1] then
					Clockwork.player:SetSafePosition(player, supercrate:GetPos());
				end
				
				return;
			end
		end
		
		Schema:EasyText(player, "tomato", "A supecrate could not be created for some reason!")
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("ItemSpawnerInfo")
	COMMAND.tip = "Get some debug data about the item spawning."
	COMMAND.access = "s"
	COMMAND.alias = {"GetItemSpawnerInfo"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local message = "Containers spawned: "..tostring(#cwItemSpawner.Containers).."\nItems spawned: "..tostring(#cwItemSpawner.ItemsSpawned);
		
		if cwItemSpawner.SuperCrate then
			message = message.."\nSupercrate currently exists!";
		elseif cwItemSpawner.nextSuperCrate then
			message = message.."\nSupercrate is on cooldown for "..tostring(math.ceil(cwItemSpawner.nextSuperCrate - CurTime())).." more seconds!";
		end
		
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..message);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("ItemSpawnerContainerToggleESP");
COMMAND.tip = "Toggles container spawns on or off on the admin ESP.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player.itemContainerSpawnESP == true) then
		player.itemContainerSpawnESP = false;
	elseif cwItemSpawner.Containers and cwItemSpawner.SuperCrate then
		netstream.Start(player, "ItemContsESPInfo", {cwItemSpawner.Containers, cwItemSpawner.SuperCrate});
		player.itemContainerSpawnESP = true;
	elseif cwItemSpawner.Containers then
		netstream.Start(player, "ItemContsESPInfo", {cwItemSpawner.Containers});
		player.itemContainerSpawnESP = true;
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveItemSpawnerStorage");
	COMMAND.tip = "Clear all item spawner storage containers on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"ClearItemSpawnerStorage", "RemoveItemSpawnerStorage"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local containers = cwItemSpawner.Containers;
		
		if containers then
			for i = 1, #containers do
				local containerTable = containers[i];
				local container = containerTable.container;
				
				if IsValid(container) then
					container:Remove();
				end
			end
		end

		for k, v in pairs(cwItemSpawner.ContainerLocations) do
			for i = 1, #v do
				v[i].occupier = nil;
			end
		end
		
		cwItemSpawner.Containers = {};
		cwItemSpawner.nextContainerCheck = CurTime() + 1;
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has cleared all item spawner containers!");
	end;
COMMAND:Register();