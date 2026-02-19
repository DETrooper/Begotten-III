--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

config.Add("loot_container_lifetime", 1200); -- 20 Minutes.
config.Add("loot_item_lifetime", 1800); -- 30 Minutes.
config.Add("loot_player_ratio", 0.75); -- Percentage of players active for when loot spawns will be maxxed (75% is 60 out of 80).
config.Add("loot_population_scaling_enabled", true); -- Whether the ratio system is enabled at all. If not, loot will always max out.
config.Add("loot_min_containers", 40); -- Containers at low population.
config.Add("loot_max_containers", 80); -- Containers at high population.
config.Add("loot_min_ground_spawns", 50); -- Ground spawns at low population.
config.Add("loot_max_ground_spawns", 100); -- Ground spawns at high population.
config.Add("loot_spawner_enabled", true); -- Whether or not the loot spawner is enabled.

cwItemSpawner.MaxSuperCrates = 1;
cwItemSpawner.SuperCrateCooldown = {min = 5400, max = 10800}; -- 1.5-3 Hours.
cwItemSpawner.SuperCrateNumItems = {min = 14, max = 18};
cwItemSpawner.ItemsSpawned = cwItemSpawner.ItemsSpawned or {};
cwItemSpawner.ContainerLocations = cwItemSpawner.ContainerLocations or {};
cwItemSpawner.SpawnLocations = cwItemSpawner.SpawnLocations or {};
cwItemSpawner.SupercrateLocations = cwItemSpawner.SupercrateLocations or {};

cwItemSpawner.LocationsToCategories = {
	["city"] = {"Armor", "Charms", "City Junk", "Communication", "Drinks", "Firearms", "Food", "Helms", "Junk", "Medical", "Melee", "Shot"},
	["industrial"] = {"Communication", "Crafting Materials", "Industrial Junk", "Junk", "Medical", "Repair Kits"},
	["mines"] =  {"Crafting Materials", "Industrial Junk", "Mine Rituals", "Rituals"},
	["rituals"] = {"Rituals"},
	["supermarket"] = {"City Junk", "Drinks", "Food", "Medical"}
};

-- A function to select a random item to spawn.
function cwItemSpawner:SelectItem(location, bIsSupercrate, bIsContainer)
	local spawnable = self:GetSpawnableItems();
	local itemPool = {};
	local uniqueID = nil;
	local fullWeight = 0;
	
	for _, itemTable in ipairs(spawnable) do
		if itemTable.itemSpawnerInfo and !itemTable.isBaseItem then
			local rarity = itemTable.itemSpawnerInfo.rarity;
			
			if config.GetVal("enable_famine") then
				if itemTable.category == "Food" or itemTable.category == "Drinks" or itemTable.category == "Alcohol" then
					rarity = math.Round(rarity * 2.5);
				end
			end
			
			if location then
				if !table.HasValue(self.LocationsToCategories[location], itemTable.itemSpawnerInfo.category) then
					continue;
				end
			end
			
			if !bIsSupercrate then
				if itemTable.itemSpawnerInfo.supercrateOnly then
					continue;
				end
			else
				if itemTable.itemSpawnerInfo.bNoSupercrate then
					continue;
				else
					-- Make sure low quality items don't appear in supercrates (exemption for ammo).
					if (rarity < 250 and !itemTable.itemSpawnerInfo.supercrateOnly and itemTable.category ~= "Shot") or (rarity < 500 and (itemTable.category == "Food" or itemTable.category == "Drinks")) then
						continue;
					end
					
					--rarity = math.Round(rarity * 0.25);
				end
			end
			
			if !bIsContainer and !bIsSupercrate then
				if itemTable.itemSpawnerInfo.onGround == false then
					continue;
				end
			end
			
			local weight = 1 / math.max(rarity, 1)
			fullWeight = fullWeight + weight
			
			table.insert(itemPool, itemTable)

		end
	end;
	
	if fullWeight == 0 or #itemPool == 0 then
		return nil
	end

	local rand = math.random() * fullWeight
	local spinthewheel = 0

	for _, item in ipairs(itemPool) do
		spinthewheel = spinthewheel + (1 / math.max(item.itemSpawnerInfo.rarity, 1))
		if rand <= spinthewheel then
			return item.uniqueID
		end
	end

	return nil;
end;

local spawnable_items_cache = {};

-- A function to get all spawnable items in the game.
function cwItemSpawner:GetSpawnableItems()
	if #spawnable_items_cache > 0 then
		return spawnable_items_cache;
	end

	for k, v in pairs(Clockwork.item:GetAll()) do
		if v.itemSpawnerInfo then
			spawnable_items_cache[#spawnable_items_cache + 1] = v;
		end;
	end;
	
	return spawnable_items_cache;
end;

-- A function to get whether a position is clear of players and other items.
function cwItemSpawner:IsAreaClear(position, bContainer)
	--if (!bContainer) then
		for k, v in pairs (ents.FindInSphere(position, 512)) do
			if (v:IsPlayer()) then
				--print("Returning false for position: "..tostring(position));
				--print("Player found is: "..v:Name());
				return false;
			end;
		end;
	--end;
	
	--[[local players = PlayerCache or _player.GetAll();

	for k, v in pairs(players) do
		if (v:IsAdmin() or !v:Alive()) then
			continue;
		end;
		
		if (Clockwork.entity:CanSeePosition(v, position)) then
			return false;
		end;
	end;]]--
	
	return true;
end;

-- A function to get a random spawn position.
function cwItemSpawner:GetSpawnPosition(category)
	local positions = {};
	
	for k, v in pairs(self.SpawnLocations) do
		if v.category == "supermarket" then
			if math.random(1, 3) < 3 then
				continue;
			end
		end
	
		if category then
			if v.category == category then
				table.insert(positions, v);
			end
		else
			table.insert(positions, v);
		end;
	end;
	
	if #positions > 0 then
		local position = positions[math.random(1, #positions)];
	
		if (self:IsAreaClear(position.position)) then
			return position;
		end
	end;
	
	return false;
end;

-- A function to get all valid spawn containers.
function cwItemSpawner:GetContainers()
	return self.containers;
end;

function cwItemSpawner:AddContainerSpawn(containerEntity, category, player)
	if !IsValid(containerEntity) then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You are using an invalid entity!");
		end;
		
		return;
	end
	
	if !cwStorage.containerList[containerEntity:GetModel()] then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] This entity does not have a storage model!");
		end;
		
		return;
	end
	
	if !category or !table.HasValue(self.Categories, category) then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You have specified an invalid category!");
		end;
		
		return false;
	end

	if !self.ContainerLocations[category] then
		self.ContainerLocations[category] = {};
	end

	table.insert(self.ContainerLocations[category], {model = containerEntity:GetModel(), pos = containerEntity:GetPos(), angles = containerEntity:GetAngles()});
	
	netstream.Heavy(Schema:GetAdmins(), "ContainerSpawnESPInfo", {self.ContainerLocations});
	
	if (player and player:IsPlayer()) then
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have added a "..category.." container spawn at your cursor position.");
	end;
	
	self:SaveContainerSpawns();
end

function cwItemSpawner:RemoveContainerSpawn(position, distance, player)
	for category, v in pairs(self.ContainerLocations) do
		for i, v2 in ipairs(v) do
			if (v2.pos:Distance(position) < distance) then
				table.remove(self.ContainerLocations[category], i);
				
				if (player and player:IsPlayer()) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed a container spawn at your cursor position.");
				end;
				
				netstream.Heavy(Schema:GetAdmins(), "ContainerSpawnESPInfo", {self.ContainerLocations});
				
				self:SaveContainerSpawns();
				
				return;
			end;
		end
	end;
end

-- A function to add an item spawn.
function cwItemSpawner:AddItemSpawn(position, category)
	table.insert(self.SpawnLocations, {position = position, category = category});
	
	netstream.Heavy(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
	
	self:SaveItemSpawns();
end;

-- A function to remove an item spawn.
function cwItemSpawner:RemoveItemSpawn(position, distance, player)
	if (position) then
		local count = 0;
		
		for k, v in pairs (self.SpawnLocations) do
			if (v.position:Distance(position) < distance) then
				table.remove(self.SpawnLocations, k);
				count = count + 1;
			end;
		end;

		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed "..count.." item spawns at your cursor position.");
		end;
		
		netstream.Heavy(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
		
		self:SaveItemSpawns();
	end;
end;

function cwItemSpawner:AddSupercrateSpawn(supercrateEntity, player)
	if !IsValid(supercrateEntity) then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You are using an invalid entity!");
		end;
		
		return;
	end
	
	if !cwStorage.containerList[supercrateEntity:GetModel()] then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] This entity does not have a storage model!");
		end;
		
		return;
	end

	table.insert(self.SupercrateLocations, {pos = supercrateEntity:GetPos(), angles = supercrateEntity:GetAngles()});
	
	netstream.Heavy(Schema:GetAdmins(), "SupercrateSpawnESPInfo", {self.SupercrateLocations});
	
	if (player and player:IsPlayer()) then
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have added a supercrate spawn at your cursor position.");
	end;
	
	self:SaveSupercrateSpawns();
end

function cwItemSpawner:RemoveSupercrateSpawn(position, distance, player)
	for k, v in ipairs(self.SupercrateLocations) do
		if (v.pos:Distance(position) < distance) then
			table.remove(self.SupercrateLocations, k)
			
			if (player and player:IsPlayer()) then
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed a supercrate spawn at your cursor position.");
			end;
			
			netstream.Heavy(Schema:GetAdmins(), "SupercrateSpawnESPInfo", {self.SupercrateLocations});
			
			self:SaveSupercrateSpawns();
			
			return;
		end;
	end
end

local map = string.lower(game.GetMap());

-- A function to load all the item spawns.
function cwItemSpawner:LoadItemSpawns()
	self.SpawnLocations = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/itemspawn/"..game.GetMap()));
	
	netstream.Heavy(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
end;

-- A function to save all the item spawns.
function cwItemSpawner:SaveItemSpawns()
	local itemspawns = {};
	
	for k, v in pairs(self.SpawnLocations) do
		itemspawns[#itemspawns + 1] = v;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/itemspawn/"..game.GetMap(), itemspawns);
end;

-- A function to load all the item container spawns.
function cwItemSpawner:LoadContainerSpawns()
	local containerSpawns = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/itemspawn/containers/"..map));
	
	self.ContainerLocations = containerSpawns;
	
	netstream.Heavy(Schema:GetAdmins(), "ContainerSpawnESPInfo", {containerSpawns});
end

-- A function to save all the item container spawns.
function cwItemSpawner:SaveContainerSpawns()
	if self.ContainerLocations then
		local saveTab = table.Copy(self.ContainerLocations);
		
		for k, v in pairs(saveTab) do
			for i, v in ipairs(v) do
				if v.occupier then v.occupier = nil end;
			end
		end
		
		Clockwork.kernel:SaveSchemaData("plugins/itemspawn/containers/"..map, saveTab);
		
		netstream.Heavy(Schema:GetAdmins(), "SupercrateSpawnESPInfo", {saveTab});
	end
end

function cwItemSpawner:LoadSupercrateSpawns()
	local supercrateSpawns = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/itemspawn/supercrates/"..map));
	
	self.SupercrateLocations = supercrateSpawns;
	
	netstream.Heavy(Schema:GetAdmins(), "SupercrateSpawnESPInfo", {supercrateSpawns});
end

-- A function to save all the supercrate spawns.
function cwItemSpawner:SaveSupercrateSpawns()
	if self.SupercrateLocations then
		Clockwork.kernel:SaveSchemaData("plugins/itemspawn/supercrates/"..map, self.SupercrateLocations);
	
		netstream.Heavy(Schema:GetAdmins(), "SupercrateSpawnESPInfo", {self.SupercrateLocations});
	end
end

-- Spawns the maximum amount of containers, should only really be called at server start.
function cwItemSpawner:SetupContainers()
	if !self.ContainerLocations then
		return;
	end
	
	if not self.Containers then
		self.Containers = {};
	end
	
	local curTime = CurTime();
	local numContainers = #self.Containers;
	local maxContainers = config.GetVal("loot_max_containers");
	
	if config.GetVal("loot_population_scaling_enabled") then
		maxContainers = Lerp(player.GetCount() / (game.MaxPlayers() * config.GetVal("loot_player_ratio")), config.GetVal("loot_min_containers"), maxContainers);
	end
	
	for k, v in RandomPairs(self.ContainerLocations) do
		if k == "supermarket" then
			if math.random(1, 4) < 4 then
				continue;
			end
		end
	
		if numContainers < maxContainers then
			for i = 1, #v do
				if numContainers < maxContainers and !v[i].occupier then
					if math.random(1, 2) == 1 then
						local container = ents.Create("prop_physics")

						container:SetAngles(v[i].angles);
						container:SetModel(v[i].model);
						container:SetPos(v[i].pos);
						container:Spawn();
						
						v[i].occupier = container:EntIndex();
						
						local physicsObject = container:GetPhysicsObject();
						
						if (IsValid(physicsObject)) then
							physicsObject:EnableMotion(false);
						end;
						
						numContainers = numContainers + 1
						
						local lockChance = math.random(1, 100);
						
						if lockChance <= 5 then
							container.cwLockType = "none";
							container.cwLockTier = 3;
							container:SetNWBool("unlocked", false);
						elseif lockChance <= 15 then
							container.cwLockType = "none";
							container.cwLockTier = 2;
							container:SetNWBool("unlocked", false);
						elseif lockChance <= 25 then
							container.cwLockType = "none";
							container.cwLockTier = 1;
							container:SetNWBool("unlocked", false);
						end
						
						if not container.cwInventory then
							container.cwInventory = {};
						end
						
						local itemIncrease = (container.cwLockTier or 0) * 2
						
						for i = 1, math.random(3 + itemIncrease, 6 + itemIncrease) do
							if i > 1 and math.random() < 0.666 then -- 1/3 chance to not spawn an item after the first item
								local randomItem = self:SelectItem(k, false, true);
								
								if randomItem then
									local itemInstance = item.CreateInstance(randomItem);
									
									if itemInstance then
										local category = itemInstance.category;
										
										if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
											-- 75% chance for these items to spawn with less than 100% condition.
											if math.random(1, 4) ~= 1 then
												itemInstance:SetCondition(math.random(15, 99), true);
											end
										elseif itemInstance.category == "Shot" and itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
											itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
										end
										
										if itemInstance:GetData("freezing") then
											itemInstance:SetData("freezing", 100);
										end
										
										Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, 1);
									end;
								end
							end
						end
						
						if (container.cwLockTier and container.cwLockTier >= 1) or math.random(1, 10) == 1 then
							container.cwCash = math.random(10, 50);
							
							if math.random(1, 5) == 1 then
								container.cwCash = math.random(50, 100);
							end
						end
						
						container.lootCategory = k;
						container.lootContainer = true;
						
						local containerTable = {
							container = container,
							lifeTime = curTime + config.GetVal("loot_container_lifetime")
						};
						
						table.insert(self.Containers, containerTable);
					end
				else
					return;
				end
			end
		else
			return;
		end
	end
end;

-- Eventually this should have its own high value loot table.
function cwItemSpawner:SpawnSupercrate()
	if !cwItemSpawner.SupercrateLocations or #cwItemSpawner.SupercrateLocations <= 0 then
		return;
	end
	
	if not self.SuperCrate then
		local superCratePos = cwItemSpawner.SupercrateLocations[math.random(1, #cwItemSpawner.SupercrateLocations)];
		
		if self:IsAreaClear(superCratePos.pos, true) then
			local supercrate = ents.Create("prop_physics")

			supercrate:SetAngles(superCratePos.angles);
			supercrate:SetModel(superCratePos.model);
			supercrate:SetPos(superCratePos.pos);
			supercrate:Spawn();
			
			supercrate:SetNetworkedString("Name", "Supercrate");
			
			local physicsObject = supercrate:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
			
			local supercrateTable = {
				supercrate = supercrate,
				lifeTime = CurTime() + config.GetVal("loot_container_lifetime")
			};

			supercrate.cwLockType = "none";
			supercrate.cwLockTier = 3;
			supercrate:SetNWBool("unlocked", false);
			
			if not supercrate.cwInventory then
				supercrate.cwInventory = {};
			end
			
			for i = 1, math.random(self.SuperCrateNumItems.min, self.SuperCrateNumItems.max) do
				local randomItem = self:SelectItem(nil, true);
				
				if randomItem then
					local itemInstance = item.CreateInstance(randomItem);
					
					if itemInstance then
						-- If it is a magazine, make it full of ammo. If it is a normal ammo, spawn a bunch of duplicates.
						if itemInstance.category == "Shot" then
							if itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
								itemInstance:SetAmmoMagazine(itemInstance.ammoMagazineSize);
							else
								Clockwork.inventory:AddInstance(supercrate.cwInventory, itemInstance, math.random(4, 10));
							end
						end
						
						if itemInstance:GetData("freezing") then
							itemInstance:SetData("freezing", 100);
						end
						
						if itemInstance.itemSpawnerInfo.supercrateItems then
							for k, v in pairs(itemInstance.itemSpawnerInfo.supercrateItems) do
								for j = 1, math.random(v.min, v.max) do
									local subItem = item.CreateInstance(k);
								
									if subItem then
										if subItem.ammoMagazineSize and subItem.SetAmmoMagazine then
											subItem:SetAmmoMagazine(subItem.ammoMagazineSize);
										end
										
										if subItem:GetData("freezing") then
											subItem:SetData("freezing", 100);
										end
										
										Clockwork.inventory:AddInstance(supercrate.cwInventory, subItem, 1);
									end
								end
							end
						end

						-- Supercrate items will have perfect condition.
						Clockwork.inventory:AddInstance(supercrate.cwInventory, itemInstance, 1);
					end
				end
			end
			
			supercrate.cwCash = math.random(500, 1000);
			supercrate.lootContainer = true;
			
			self.SuperCrate = supercrateTable;
			
			return supercrateTable;
		end
	end
end