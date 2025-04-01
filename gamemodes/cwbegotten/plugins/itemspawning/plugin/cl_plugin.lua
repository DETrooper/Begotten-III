--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local playerMeta = FindMetaTable("Player")
	
-- A function to get whether a player has an item by its uniqueID.
function playerMeta:HasItemByID(uniqueID)
	return Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), uniqueID);
end;

config.AddToSystem("Loot Container Lifetime", "loot_container_lifetime", "Lifetime of loot containers in seconds until they disappear.", 300, 3600);
config.AddToSystem("Loot Item Lifetime", "loot_item_lifetime", "Lifetime of loot ground spawns in seconds until they disappear.", 300, 3600);
config.AddToSystem("Loot Player Ratio", "loot_player_ratio", "Percentage of players active for when loot spawns will be maxxed (default value of 75% is 60 out of 80 for example).", 0.1, 1, 2);
config.AddToSystem("Loot Population Scaling Enabled", "loot_population_scaling_enabled", "Whether or not the loot population scaling system is enabled.");
config.AddToSystem("Loot Min Containers", "loot_min_containers", "Maximum loot containers at low population.", 20, 100);
config.AddToSystem("Loot Max Containers", "loot_max_containers", "Maximum loot containers at high population.", 20, 100);
config.AddToSystem("Loot Min Ground Spawns", "loot_min_ground_spawns", "Maximum loot ground spawns at low population.", 20, 200);
config.AddToSystem("Loot Max Ground Spawns", "loot_max_ground_spawns", "Maximum loot ground spawns at high population.", 20, 200);
config.AddToSystem("Loot Spawner Enabled", "loot_spawner_enabled", "Whether or not the loot spawner is enabled.");