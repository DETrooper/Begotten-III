--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Called when Clockwork has loaded all of the entities.
function cwItemSpawner:ClockworkInitPostEntity()
	self:LoadContainerSpawns();
	self:LoadItemSpawns();
	self:LoadSupercrateSpawns();
	
	if config.GetVal("loot_spawner_enabled") then
		--self:SetupContainers(); -- Potentially glitched.
	end
end

-- Called every tick.
function cwItemSpawner:Think()
	local curTime = CurTime();
	
	if (!self.nextContainerCheck or self.nextContainerCheck < curTime) then
		self.nextContainerCheck = curTime + 8;
		
		if config.GetVal("loot_spawner_enabled") ~= true then
			return;
		end
			
		if !self.ContainerLocations then
			return;
		end;
		
		local containers = self.Containers;
		
		if not containers then
			self.Containers = {};
			
			containers = self.Containers;
		end
		
		for i = 1, #containers do
			local containerTable = containers[i];
			
			if containerTable.lifeTime then
				if containerTable.lifeTime < curTime then
					local container = containerTable.container;
					
					if IsValid(container) then
						if !self.occupier and self:IsAreaClear(container:GetPos(), true) then
							local posFound = false;
							
							for k, v in pairs(self.ContainerLocations) do
								if posFound then
									break;
								end
								
								for j = 1, #v do
									if v[j].occupier == container:EntIndex() then
										posFound = true;
										v[j].occupier = nil;
										
										break;
									end
								end
							end
							
							container.cwInventory = nil;
							container.cwCash = nil;
							container:Remove();
							table.remove(self.Containers, i);
							
							break;
						else
							-- Move this container to the back of the queue, we'll check it again after all the others.
							-- This has the added side effect of making sure camping doesn't pay off :)
							table.remove(self.Containers, i);
							table.insert(self.Containers, containerTable);
							
							break;
						end
					else
						table.remove(self.Containers, i);
						break;
					end
				end
			else
				local container = containerTable.container;
				
				if IsValid(container) then
					if !self.occupier and self:IsAreaClear(container:GetPos(), true) then
						local posFound = false;
						
						for k, v in pairs(self.ContainerLocations) do
							if posFound then
								break;
							end
							
							for j = 1, #v do
								if v[j].occupier == container:EntIndex() then
									posFound = true;
									v[j].occupier = nil;
									
									break;
								end
							end
						end
						
						container.cwInventory = nil;
						container.cwCash = nil;
						container:Remove();
						table.remove(self.Containers, i);
						
						break;
					else
						-- Move this container to the back of the queue, we'll check it again after all the others.
						-- This has the added side effect of making sure camping doesn't pay off :)
						table.remove(self.Containers, i);
						table.insert(self.Containers, containerTable);
						
						break;
					end
				else
					table.remove(self.Containers, i);
					break;
				end
			end
		end
		
		if self.Containers then
			local numContainers = #self.Containers;
			local maxContainers = config.GetVal("loot_max_containers");
			
			if config.GetVal("loot_population_scaling_enabled") then
				maxContainers = Lerp(player.GetCount() / (game.MaxPlayers() * config.GetVal("loot_player_ratio")), config.GetVal("loot_min_containers"), maxContainers);
			end

			if numContainers < maxContainers then
				local containerCategory = self.Categories[math.random(#self.Categories)];
				local unoccupiedLocations = {};
				
				if containerCategory == "supermarket" then
					if math.random(1, 3) < 3 then
						containerCategory = "city";
					end
				end
				
				if self.ContainerLocations[containerCategory] then
					for i = 1, #self.ContainerLocations[containerCategory] do
						local location = self.ContainerLocations[containerCategory][i];
						
						if not location.occupier then
							table.insert(unoccupiedLocations, location);
						end
					end
					
					if #unoccupiedLocations > 0 then
						local unoccupiedLocation = unoccupiedLocations[math.random(#unoccupiedLocations)]
						
						if self:IsAreaClear(unoccupiedLocation.pos, true) then
							local container = ents.Create("prop_physics")

							container:SetAngles(unoccupiedLocation.angles);
							container:SetModel(unoccupiedLocation.model);
							container:SetPos(unoccupiedLocation.pos);
							container:Spawn();
							
							unoccupiedLocation.occupier = container:EntIndex();
							
							local physicsObject = container:GetPhysicsObject();
							
							if (IsValid(physicsObject)) then
								physicsObject:EnableMotion(false);
							end;
							
							numContainers = numContainers + 1;
							
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
								local randomItem = self:SelectItem(containerCategory, false, true);
								
								if randomItem then
									local itemInstance = item.CreateInstance(randomItem);
									
									if itemInstance then
										local category = itemInstance.category;
										
										if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
											-- 86% chance for these items to spawn with less than 100% condition.
											if math.random(1, 6) ~= 1 then
												itemInstance:SetCondition(math.random(15, 99), true);
											end
										elseif itemInstance.category == "Shot" and itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
											itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
										end
											
										if itemInstance:GetData("freezing") then
											itemInstance:SetData("freezing", 100);
										end
										
										Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, 1);
									end
								end
							end
							
							if (container.cwLockTier and container.cwLockTier >= 1) or math.random(1, 10) == 1 then
								container.cwCash = math.random(10, 50);
								
								if math.random(1, 5) == 1 then
									container.cwCash = math.random(50, 100);
								end
							end
							
							container.lootCategory = containerCategory;
							container.lootContainer = true;
							
							local containerTable = {
								container = container,
								lifeTime = curTime + config.GetVal("loot_container_lifetime")
							};
							
							table.insert(self.Containers, containerTable);
						end
					end
				end
			end
		end
		
		if self.SuperCrate then
			local supercrate = self.SuperCrate.supercrate;
			
			if IsValid(supercrate) and self.SuperCrate.lifeTime < curTime then
				if self:IsAreaClear(supercrate:GetPos(), true) then
					if IsValid(supercrate) then
						supercrate.cwInventory = nil;
						supercrate.cwCash = nil;
						supercrate:Remove();
					end

					self.SuperCrate = nil;
					self.nextSuperCrate = curTime + math.random(self.SuperCrateCooldown.min, self.SuperCrateCooldown.max);
				end
			elseif !IsValid(supercrate) then
				self.SuperCrate = nil;
				self.nextSuperCrate = curTime + math.random(self.SuperCrateCooldown.min, self.SuperCrateCooldown.max);
			end
		end

		if self.Containers then
			for _, v in _player.Iterator() do
				if v:IsAdmin() then
					if v.itemContainerSpawnESP then
						netstream.Heavy(v, "ItemContsESPInfo",  {self.Containers, self.SuperCrate});
					end
				end
			end
		end
	end
	
	if (!self.nextItemSpawn or self.nextItemSpawn < curTime) then
		self.nextItemSpawn = curTime + 5;
		
		if config.GetVal("loot_spawner_enabled") ~= true then
			return;
		end
		
		if not self.nextSuperCrate then
			-- 1 hour between supercrates.
			self.nextSuperCrate = curTime + math.random(self.SuperCrateCooldown.min, self.SuperCrateCooldown.max);
		end
		
		if not self.SuperCrate and self.nextSuperCrate < curTime then
			self:SpawnSupercrate();
		end
		
		for i = 1, #self.ItemsSpawned do
			local itemEnt = self.ItemsSpawned[i];
			
			if IsValid(itemEnt) then
				if itemEnt.lifeTime < curTime then
					if self:IsAreaClear(itemEnt:GetPos(), true) then
						itemEnt:Remove();
						table.remove(self.ItemsSpawned, i);
						break;
					end
				end
			else
				table.remove(self.ItemsSpawned, i);
				break;
			end
		end
		
		local maxGroundSpawns = config.GetVal("loot_max_ground_spawns");
		
		if config.GetVal("loot_population_scaling_enabled") then
			maxGroundSpawns = Lerp(player.GetCount() / (game.MaxPlayers() * config.GetVal("loot_player_ratio")), config.GetVal("loot_min_ground_spawns"), maxGroundSpawns);
		end
		
		if #self.ItemsSpawned < maxGroundSpawns then
			local itemCategory = self.Categories[math.random(#self.Categories)];
			
			if cwWeather and cwWeather.weather == "bloodstorm" then
				if math.random(1, 3) == 1 then
					itemCategory = "rituals";
				end
			end
			
			local randomItem = self:SelectItem(itemCategory);

			if (!randomItem) then
				return;
			end;

			local spawnPosition = self:GetSpawnPosition(itemCategory);

			if (spawnPosition and isvector(spawnPosition.position)) then
				local entity = Clockwork.entity:CreateItem(nil, randomItem, Vector(spawnPosition.position.x, spawnPosition.position.y, spawnPosition.position.z + 16));
				local itemTable = entity:GetItemTable();
				
				entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
				
				if itemTable.category == "Helms" or itemTable.category == "Armor" or itemTable.category == "Melee" then
					-- 86% chance for these items to spawn with less than 100% condition.
					if math.random(1, 6) ~= 1 then
						itemTable:SetCondition(math.random(15, 99), true);
					end
				elseif itemTable.category == "Shot" and itemTable.ammoMagazineSize and itemTable.SetAmmoMagazine then
					itemTable:SetAmmoMagazine(math.random(1, itemTable.ammoMagazineSize));
				end
				
				table.insert(self.ItemsSpawned, entity);
			end;
		end
	end;
end;

-- Called just after a player spawns.
function cwItemSpawner:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (player:IsAdmin() or player:IsUserGroup("operator")) then
		netstream.Heavy(player, "ContainerSpawnESPInfo", {self.ContainerLocations});
		netstream.Heavy(player, "ItemSpawnESPInfo", {self.SpawnLocations});
		netstream.Heavy(player, "SupercrateSpawnESPInfo", {self.SupercrateLocations});
	end;
end;

-- Called when a player uses an unknown item function.
function cwItemSpawner:PlayerUseUnknownItemFunction(player, itemTable, itemFunction, toolUniqueID, toolItemID)
	if (itemTable.breakdownItems) then
		if (itemFunction == "breakdown" and toolUniqueID and toolItemID) then
			local toolItem = player:FindItemByID(toolUniqueID, toolItemID);
			
			if (toolItem) then
				self:Breakdown(player, itemTable, toolItem);
			end;
		elseif (itemFunction == "breakdown") then
			self:Breakdown(player, itemTable);
		end;
	end;
end;

-- Called right before a container is opened.
function cwItemSpawner:PreOpenedContainer(player, container)
	if container.lootContainer and !container.looted then
		local chance = 0;
		
		if player:HasTrait("scavenger") then
			chance = chance + 5;
		end
		
		if player.GetCharmEquipped and player:GetCharmEquipped("thiefs_hand") then
			chance = chance + 5;
		end
		
		if cwRituals then
			if player:GetNetVar("princeOfThieves", false) then
				if container.cwLockTier and container.cwLockTier >= 1 then
					chance = chance + 10;
				end
			end
			
			if player:GetNetVar("blessingOfCoin", false) then
				if math.random(1, 2) == 1 then
					local amount;

					amount = math.random(25, 150);
				
					if container.cwCash then
						container.cwCash = container.cwCash + amount;
					else
						container.cwCash = amount;
					end
					
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." had "..tostring(amount).." coin added to their loot container from the 'Blessing of Coin' ritual!");
				end
			end
		end
		
		if cwBeliefs then
			if player:HasBelief("disciple") then
				if math.random(1, 10) == 1 then
					local amount;

					if player:HasBelief("fortunate") then
						amount = math.random(25, 100);
					else
						amount = math.random(10, 50);
					end
				
					if container.cwCash then
						container.cwCash = container.cwCash + amount;
					else
						container.cwCash = amount;
					end
					
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." had "..tostring(amount).." coin added to their loot container from the 'Disciple' belief!");
				end
			end
		
			if player:HasBelief("fortunate") then
				chance = chance + 10;
			end
			
			if player:HasBelief("fortune_finisher") then
				if math.random(1, 100) == 1 then
					local randomItem = self:SelectItem(nil, true);
					
					if randomItem then
						local itemInstance = item.CreateInstance(randomItem);
						
						if itemInstance then
							-- If it is a magazine, make it full of ammo. If it is a normal ammo, spawn a bunch of duplicates.
							if itemInstance.category == "Shot" then
								if itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
									itemInstance:SetAmmoMagazine(itemInstance.ammoMagazineSize);
								else
									Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, math.random(4, 10));
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
											
											Clockwork.inventory:AddInstance(container.cwInventory, subItem, 1);
										end
									end
								end
							end
							
							-- Fortune finisher items will have perfect condition.
							Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, 1);
							
							Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." had a "..itemInstance.name.." added to their loot container from the 'Fortune' belief tree finisher bonus");
							
							Clockwork.chatBox:Add(player, nil, "it", "You feel very fortunate indeed!");
						end
					end
				end
			end
		end
		
		if math.random(1, 100) <= chance then
			local bIsSuperCrate = self.SuperCrate and self.SuperCrate.supercrate == container;
			local randomItem;
			
			if bIsSuperCrate then
				randomItem = self:SelectItem(nil, true);
			else
				randomItem = self:SelectItem(container.lootCategory, false, true);
			end
				
			if randomItem then
				local itemInstance = item.CreateInstance(randomItem);
				
				if itemInstance then
					local category = itemInstance.category;
					
					if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
						if !bIsSuperCrate then
							-- 75% chance for these items to spawn with less than 100% condition.
							if math.random(1, 4) ~= 1 then
								itemInstance:SetCondition(math.random(15, 99), true);
							end
						end
					elseif itemInstance.category == "Shot" then
						if itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
							if bIsSuperCrate then
								itemInstance:SetAmmoMagazine(itemInstance.ammoMagazineSize);
							else
								itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
							end
						elseif bIsSuperCrate then
							Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, math.random(4, 10));
						end
					end
					
					if itemInstance:GetData("freezing") then
						itemInstance:SetData("freezing", 100);
					end
					
					if bIsSuperCrate then
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
										
										Clockwork.inventory:AddInstance(container.cwInventory, subItem, 1);
									end
								end
							end
						end
					end
					
					Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, 1);
					
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." had a "..itemInstance.name.." added to their loot container from a belief, trait, or charm!");
					
					Clockwork.chatBox:Add(player, nil, "it", "You feel lucky.");
				end
			end
		end
		
		container.looted = true;
	end
end
	
-- A function to break an item and give it's parts to the player.
function cwItemSpawner:Breakdown(player, itemTable, toolItem)
	for k, v in pairs (itemTable.breakdownItems) do
		player:UpdateInventory(k, v);
	end;
	
	if (itemTable.OnBreakdown) then
		itemTable:OnBreakdown(player, toolItem);
	end;
	
	if (toolItem) then
		toolItem:TakeCondition(math.random(1, 2));
	end;
end;

-- Called when Clockwork config has changed.
function cwItemSpawner:ClockworkConfigChanged(key, data, previousValue, newValue)
	if key == "loot_spawner_enabled" and newValue == false then
		for k, v in pairs (ents.FindByClass("cw_item")) do
			if v.lifeTime then
				v:Remove();
			end
		end;
		
		local containers = self.Containers;
		
		if containers then
			for i = 1, #containers do
				local containerTable = containers[i];
				local container = containerTable.container;
				
				if IsValid(container) then
					container:Remove();
				end
			end
		end

		for k, v in pairs(self.ContainerLocations) do
			for i = 1, #v do
				v[i].occupier = nil;
			end
		end
		
		self.Containers = {};
		
		if self.SuperCrate and IsValid(self.SuperCrate.supercrate) then
			self.SuperCrate.supercrate:Remove();
			self.SuperCrate = nil;
		end
	end
end