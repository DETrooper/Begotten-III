--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwItemSpawner");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local COMMAND = Clockwork.command:New("AddItemSpawn")
	COMMAND.tip = "Add an item spawn location."
	COMMAND.text = "<string Category>"
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments and arguments[1] then
			if !table.HasValue(cwItemSpawner.Categories, arguments[1]) then
				Schema:EasyText(player, "darkgrey", "You have specified an invalid category!");
				return false;
			end
		end
		
		cwItemSpawner:AddSpawn(player:GetEyeTrace().HitPos, arguments[1] or nil);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveItemSpawn")
	COMMAND.tip = "Remove an item spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Distance]"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwItemSpawner:RemoveSpawn(player:GetEyeTrace().HitPos, arguments[1] or 64, player);
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
			message = message.."\nSupercrate is on cooldown for "..tostring(math.Round(cwItemSpawner.nextSuperCrate - CurTime())).." more seconds!";
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
		Clockwork.datastream:Start(player, "ItemContsESPInfo", {cwItemSpawner.Containers, cwItemSpawner.SuperCrate});
		player.itemContainerSpawnESP = true;
	elseif cwItemSpawner.Containers then
		Clockwork.datastream:Start(player, "ItemContsESPInfo", {cwItemSpawner.Containers});
		player.itemContainerSpawnESP = true;
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ItemSpawnerToggleESP");
COMMAND.tip = "Toggles item spawnpoints on or off on the admin ESP.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player.itemSpawnESP == true) then
		player.itemSpawnESP = false;
	elseif cwItemSpawner.SpawnLocations then
		Clockwork.datastream:Start(player, "ItemSpawnsESPInfo", cwItemSpawner.SpawnLocations);
		player.itemSpawnESP = true;
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
					container.cwInventory = nil;
					container.cwCash = nil;
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
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has cleared all item spawner containers!");
	end;
COMMAND:Register();