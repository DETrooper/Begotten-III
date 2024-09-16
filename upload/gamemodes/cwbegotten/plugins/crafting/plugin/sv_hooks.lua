--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

cwRecipes.pileLifetime = 1200; -- 20 Minutes.
cwRecipes.minPileItems = 4;
cwRecipes.maxPileItems = 10;
cwRecipes.maxPiles = {
	["ore"] = 8,
	["wood"] = 8,
	["gorewood"] = 6,
};

local map = string.lower(game.GetMap());

function cwRecipes:LoadPileEnts()
	local pileEnts = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/crafting/piles/"..map));
	
	self.pileLocations = pileEnts;
	
	netstream.Heavy(Schema:GetAdmins(), "CraftingPileSpawnESPInfo", {self.pileLocations});
end

function cwRecipes:SavePileEnts()
	if self.pileLocations then
		local saveTab = table.Copy(self.pileLocations);
		
		for k, v in pairs(saveTab) do
			for i, v in ipairs(v) do
				if v.occupier then v.occupier = nil end;
			end
		end
		
		Clockwork.kernel:SaveSchemaData("plugins/crafting/piles/"..map, saveTab);
	end
end

-- Called when Clockwork has loaded all of the entities.
function cwRecipes:ClockworkInitPostEntity()
	self:LoadPileEnts();
end

function cwRecipes:AddPileSpawn(pileEntity, pileType, player)
	if !IsValid(pileEntity) or (pileEntity:GetClass() ~= "cw_woodpile" and pileEntity:GetClass() ~= "cw_ironorepile") then
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You are using an invalid entity!");
		end;
		
		return;
	end

	if pileType == "ore" or pileType == "wood" or pileType == "gorewood" then
		if !self.pileLocations[pileType] then
			self.pileLocations[pileType] = {};
		end

		table.insert(self.pileLocations[pileType], {pos = pileEntity:GetPos(), angles = pileEntity:GetAngles()});
		
		netstream.Heavy(Schema:GetAdmins(), "CraftingPileSpawnESPInfo", {self.pileLocations});
		
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have added a "..pileType.." resource spawn at your cursor position.");
		end;
		
		self:SavePileEnts();
	else
		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You have specified an invalid category!");
		end;
	end
end

function cwRecipes:RemovePileSpawn(position, distance, player)
	for pileType, v in pairs(self.pileLocations) do
		for i, v2 in ipairs(v) do
			if (v2.pos:Distance(position) < distance) then
				table.remove(self.pileLocations[pileType], i);
				
				if (player and player:IsPlayer()) then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed a resource spawn at your cursor position.");
				end;
				
				netstream.Heavy(Schema:GetAdmins(), "CraftingPileSpawnESPInfo", {self.pileLocations});
				
				self:SavePileEnts();
				
				return;
			end;
		end
	end;
end

-- Called just after a player spawns.
function cwRecipes:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (player:IsAdmin() or player:IsUserGroup("operator")) then
		netstream.Heavy(player, "CraftingPileSpawnESPInfo", {self.pileLocations});
	end;
end;

-- Called to get whether a player can craft a recipe or not.
function cwRecipes:PlayerCanCraft(player, uniqueID, craftAmount)
	local recipeTable = self.recipes.stored[uniqueID];
	local requirements = recipeTable.requirements;
	
	if (table.IsEmpty(requirements)) then
		return;
	end;
	
	local inventory = player:GetInventory();
	local access = recipeTable.access;
	local hasRequirements = true;
	local hasFlags = true;
	local requiredBeliefs = recipeTable.requiredBeliefs;
	local requiresHeatSource = recipeTable.requiresHeatSource;
	local requiresSmithy = recipeTable.requiresSmithy;
	local faction = player:GetFaction();
	local faith = player:GetNetVar("faith");
	local subfaction = player:GetNetVar("subfaction");
	local subfaith = player:GetNetVar("subfaith");
	
	if Clockwork.player:GetAction(player) or player:IsRagdolled() or !player:Alive() or player.opponent or (cwDueling and cwDueling:PlayerIsInMatchmaking(player)) or player:GetNetVar("tied") != 0 then
		Schema:EasyText(player, "lightslategrey", "Your character cannot craft at this moment!");
		return false;
	end
	
	if (access) then
		if (!Clockwork.player:HasFlags(player, access)) then
			hasFlags = false;
		end;
	end;
	
	if recipeTable.requiredFactions then
		if not table.HasValue(recipeTable.requiredFactions, faction) then
			return false;
		end
	elseif recipeTable.excludedFactions then
		if table.HasValue(recipeTable.excludedFactions, faction) then
			return false;
		end
	end
	
	if recipeTable.requiredFaiths then
		if not table.HasValue(recipeTable.requiredFaiths, faith) then
			return false;
		end
	elseif recipeTable.excludedFaiths then
		if table.HasValue(recipeTable.excludedFaiths, faith) then
			return false;
		end
	end
	
	if recipeTable.requiredSubfactions then
		if not table.HasValue(recipeTable.requiredSubfactions, subfaction) then
			return false;
		end
	elseif recipeTable.excludedSubfactions then
		if table.HasValue(recipeTable.excludedSubfactions, subfaction) then
			return false;
		end
	end
	
	if recipeTable.requiredSubfaiths then
		if not table.HasValue(recipeTable.requiredSubfaiths, subfaith) then
			return false;
		end
	elseif recipeTable.excludedSubfaiths then
		if table.HasValue(recipeTable.excludedSubfaiths, subfaith) then
			return false;
		end
	end
	
	if cwBeliefs and player.HasBelief then
		if !player:HasBelief("ingenious") then
			return false;
		else
			if requiredBeliefs then
				for i = 1, #requiredBeliefs do
					if !player:HasBelief(requiredBeliefs[i]) then
						-- this is messy but fuck it
						if requiredBeliefs[i] == "sorcerer" and uniqueID == "hellforged_steel_ingot" then
							if subfaction == "Rekh-khet-sa" then
								continue;
							end
						end
					
						Schema:EasyText(player, "lightslategrey", "You require the '"..cwBeliefs:GetBeliefName(recipeTable.requiredBeliefs[i]).."' belief to craft this recipe!");
						return false;
					end
				end
			end
		end
	end
	
	if requiresHeatSource then
		local fire_found = false;
		
		for k, v in pairs (ents.FindInSphere(player:GetPos(), 128)) do
			if (v:GetClass() == "env_fire") then
				fire_found = true;
				break;
			end;
		end;
		
		if not fire_found then
			Schema:EasyText(player, "firebrick", "You must be standing next to a heat source to craft this recipe!");
			return false;
		end
	end
	
	if requiresSmithy then
		local valid_smithy_found = false;
		
		for i = 1, #self.smithyLocations do
			if player:GetPos():DistToSqr(self.smithyLocations[i]) < (256 * 256) then
				valid_smithy_found = true;
				break;
			end
		end
		
		if not valid_smithy_found then
			Schema:EasyText(player, "firebrick", "You must be standing next to a smithy to craft this recipe!");
			return false;
		end
	end
	
	local successRate = 100;

	for k, v in pairs(requirements) do
		local amount = v.amount;

		amount = amount * craftAmount;
		
		if (!Clockwork.inventory:HasItemCountByID(inventory, k, amount)) then
			if v.substitute ~= nil then
				if (!Clockwork.inventory:HasItemCountByID(inventory, v.substitute, amount)) then
					hasRequirements = false;
					break;
				else
					break;
				end
			end

			hasRequirements = false;
			break;
		end;
	end;

	return hasFlags, hasRequirements;
end;

-- Called once the player finishes crafting an item.
function cwRecipes:PlayerFinishedCrafting(player, recipeTable, craftAmount)
	if recipeTable.experience then
		if cwBeliefs and player.HasBelief and player:HasBelief("young_son") then
			player:HandleXP((recipeTable.experience * craftAmount) * 2);
		else
			player:HandleXP(recipeTable.experience * craftAmount);
		end
	end
	
	if craftAmount > 1 then
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID()..") has crafted "..recipeTable.name.." (x"..tostring(craftAmount)..")"..".");
	else
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID()..") has crafted a "..recipeTable.name..".");
	end
end;

-- Called when a player fails to craft a recipe.
function cwRecipes:PlayerFailedRecipe(player, uniqueID, recipeTable, bHasRequirements, bHasFlags)
	--[[if (bHasRequirements == false) then
		player:Notify("You do not have all the required material necessary to craft this!")
	elseif (bHasFlags == false) then
		player:Notify("You do not have the proper skills to craft this! Pick up a fucking book, idiot!")
	end;]]--

	--[[if (recipeTable.failSound and isstring(recipeTable.failSound)) then
		player:EmitSound(recipeTable.failSound, 70);
	end;]]--
	
	if (recipeTable.OnFail) then
		recipeTable:OnFail(player);
	end;
end;

-- A function used to craft a recipe.
function cwRecipes:Craft(player, uniqueID, itemIDs, craftAmount)
	local curTime = CurTime();
	
	if (IsValid(player) and uniqueID and isstring(uniqueID)) then
		if (!player.cwNextCraft or player.cwNextCraft < curTime) then
			player.cwNextCraft = curTime + 10;

			local bHasFlags, bHasRequirements = hook.Run("PlayerCanCraft", player, uniqueID, craftAmount);
			local recipeTable = self.recipes.stored[uniqueID];

			if (recipeTable and bHasFlags != false and bHasRequirements != false) then
				if self:PlayerMeetsCraftingItemRequirements(player, recipeTable, itemIDs, false, craftAmount) then
					if (recipeTable.craftTime) then
						local craftVerb = recipeTable.craftVerb or "";
						local craftName = recipeTable.name..(craftAmount > 1 and " ("..craftAmount.."x)" or "");
						
						if (craftVerb != "") then
							player:SetLocalVar("cwProgressBarVerb", craftVerb);
							player:SetLocalVar("cwProgressBarItem", craftName);
							
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins "..craftVerb.." a "..craftName..".", player:GetPos(), config.Get("talk_radius"):Get() * 2);
						end;
						
						if (recipeTable.StartCraft) then
							recipeTable:StartCraft(player);
						end;
						
						Clockwork.player:SetAction(player, "crafting", recipeTable.craftTime, 5, function()
							if (IsValid(player)) then
								recipeTable:Craft(player, itemIDs, false, craftAmount);
								
								player:SetLocalVar("cwProgressBarVerb", nil);
								player:SetLocalVar("cwProgressBarItem", nil);
								
								if cwCharacterNeeds then
									player:HandleNeed("hunger", 0.5 * craftAmount);
									player:HandleNeed("thirst", 1 * craftAmount);
									player:HandleNeed("sleep", 0.5 * craftAmount);
								end
								
								if (recipeTable.EndCraft) then
									recipeTable:EndCraft(player);
								end;
							end;
						end);
					else
						recipeTable:Craft(player, itemIDs, true, craftAmount);
					end;
				end;
				
				return;
			elseif (!recipeTable) then
				return;
			end;
			
			hook.Run("PlayerFailedRecipe", player, uniqueID, recipeTable, bHasRequirements, bHasFlags)
		else
			player:Notify("You must wait another "..-math.ceil(curTime - player.cwNextCraft).." seconds before attempting to craft again!");
		end;
	end
end;

-- This function is expensive as FUCK. You can make a better one if you want cash.
function cwRecipes:PlayerMeetsCraftingItemRequirements(player, recipeTable, itemIDs, bTake, craftAmount)
	if !itemIDs or table.IsEmpty(itemIDs) then
		Schema:EasyText(player, "lightslategrey", "You have no items selected to craft!");
		return false;
	end

	if isstring(recipeTable) then
		recipeTable = self.recipes.stored[recipeTable];
		
		if !recipeTable or isstring(recipeTable) then
			Schema:EasyText(player, "lightslategrey", "No valid recipe for this combination of items could be found!");
			return false;
		end
	end
	
	local conditions = {};
	local conditionAverage = 0;
	local inventory = player:GetInventory();
	local slottedItems = {};
	local requirements = recipeTable.requirements;
	
	for i = 1, #itemIDs do
		local itemID = itemIDs[i];
		
		for k, v in pairs(inventory) do
			for k2, v2 in pairs(v) do
				if v2.itemID == itemID then
					local itemTable = Clockwork.inventory:FindItemByID(inventory, k, v2.itemID);
					local condition = itemTable:GetCondition() or 100;
					
					conditionAverage = conditionAverage + condition;
					
					table.insert(slottedItems, itemTable);
					table.insert(conditions, condition);
					break;
				end
			end
		end
	end
	
	local temptab = table.Copy(slottedItems);

	for i = 1, craftAmount do
		for k, v in pairs(requirements) do
			local amount = v.amount or 1;

			for i = 1, amount do
				local goods_found = false;

				for j = 1, #temptab do
					if temptab[j].uniqueID == k or temptab[j].uniqueID == v.substitute then
						table.remove(temptab, j);
						goods_found = true;
						break;
					end
				end

				if not goods_found then
					Schema:EasyText(player, "lightslategrey", "The items inputted for crafting do not match the selected recipe's requirements!");
					return false;
				end
			end
		end
	end
	
	if #temptab > 0 then
		Schema:EasyText(player, "lightslategrey", "The items inputted for crafting do not match the selected recipe's requirements!");
		return false;
	end
	
	if bTake then
		for i = 1, #slottedItems do
			player:TakeItem(slottedItems[i], true);
		end
	end
	
	if player:HasBelief("taste_of_iron") then
		player.conditionAverage = 100;
	else
		player.conditionAverage = conditionAverage / #conditions;
	end
	
	return true;
end

-- Called when a player presses a key.
function cwRecipes:KeyPress(player, key)
	if (key == IN_ATTACK) then
		if (Clockwork.player:GetAction(player) == "crafting") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

-- Called when a player has been ragdolled.
function cwRecipes:PlayerRagdolled(player, state, ragdoll)
	if (Clockwork.player:GetAction(player) == "crafting") then
		Clockwork.player:SetAction(player, nil);
	end
end;

function cwRecipes:ModifyPlayerSpeed(player, infoTable, action)
	if action == "crafting" then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
	end
end

-- A function to get whether a position is clear of players and other piles.
function cwRecipes:IsAreaClear(position, bPile)
	if (!bPile) then
		for k, v in pairs (ents.FindInSphere(position, 128)) do
			local class = v:GetClass();
			
			if (class == "cw_ironorepile") or (class == "cw_woodpile") then
				return false;
			end;
		end;
	end;
	
	for _, v in _player.Iterator() do
		if (v:IsAdmin() or !v:Alive()) then
			continue;
		end;
		
		if (Clockwork.entity:CanSeePosition(v, position)) then
			return false;
		end;
	end;
	
	return true;
end;

-- A function to get a random spawn position for an ore pile or wood pile.
function cwRecipes:GetSpawnPosition(category)
	local positions = {};
	
	for k, v in pairs (self.pileLocations) do
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

-- Called every tick.
function cwRecipes:Think()
	local curTime = CurTime();
	
	if (!self.nextPileCheck or self.nextPileCheck < curTime) then
		self.nextPileCheck = curTime + 8;
		
		if not self.pileLocations then
			self.pileLocations = {};
		end
		
		if not self.Piles then
			self.Piles = {
				["gorewood"] = {},
				["ore"] = {},
				["wood"] = {},
			};
		end
		
		for category, v in pairs(self.Piles) do
			for i, pileTable in ipairs(v) do
				local pile = pileTable.pile;
				
				if !IsValid(pile) then
					table.remove(self.Piles[category], i);
					break;
				end
				
				if pileTable.lifeTime then
					if pileTable.lifeTime < curTime then
						if self:IsAreaClear(pileTable.position, true) then
							local posFound = false;
							
							for k, location in pairs(self.pileLocations) do
								if posFound then
									break;
								end
								
								for j = 1, #location do
									if location[j].occupier == pile:EntIndex() then
										posFound = true;
										location[j].occupier = nil;
										
										break;
									end
								end
							end
							
							pile:Remove();
							break;
						else
							-- Move this pile to the back of the queue, we'll check it again after all the others.
							-- This has the added side effect of making sure camping doesn't pay off :)
							table.remove(self.Piles[category], i);
							table.insert(self.Piles[category], pileTable);
						end
					end
				else
					if self:IsAreaClear(pileTable.position, true) then
						local posFound = false;
						
						for k, location in pairs(self.pileLocations) do
							if posFound then
								break;
							end
							
							for j = 1, #location do
								if location[j].occupier == pile:EntIndex() then
									posFound = true;
									location[j].occupier = nil;
									
									break;
								end
							end
						end
						
						pile:Remove();
						break;
					else
						-- Move this pile to the back of the queue, we'll check it again after all the others.
						-- This has the added side effect of making sure camping doesn't pay off :)
						table.remove(self.Piles[category], i);
						table.insert(self.Piles[category], pileTable);
					end
				end
			end
		end
		
		if self.Piles then
			local categories = {"gorewood", "ore", "wood"};
			local category = categories[math.random(1, #categories)];
			local numPiles = #self.Piles[category];

			if numPiles < self.maxPiles[category] then
				local unoccupiedLocations = {};
				
				if self.pileLocations[category] then
					for i, location in ipairs(self.pileLocations[category]) do
						if !location.occupier or !IsValid(Entity(location.occupier)) then
							table.insert(unoccupiedLocations, location);
						end
					end
					
					if #unoccupiedLocations > 0 then
						local unoccupiedLocation = unoccupiedLocations[math.random(#unoccupiedLocations)]
						
						if self:IsAreaClear(unoccupiedLocation.pos, false) then
							local pile;
							
							if category == "ore" then
								pile = ents.Create("cw_ironorepile")
							elseif category == "wood" or category == "gorewood" then
								pile = ents.Create("cw_woodpile")
							end
							
							if IsValid(pile) then
								pile:SetAngles(unoccupiedLocation.angles);
								pile:SetPos(unoccupiedLocation.pos);
								pile:Spawn();
								
								unoccupiedLocation.occupier = pile:EntIndex();
								
								local physicsObject = pile:GetPhysicsObject();
								
								if (IsValid(physicsObject)) then
									physicsObject:EnableMotion(false);
								end;
								
								numPiles = numPiles + 1;
								
								local pileTable = {
									pile = pile,
									lifeTime = curTime + self.pileLifetime
								};
								
								table.insert(self.Piles[category], pileTable);
							end
						end
					end
				end
			end
		end
	end
end;

function cwRecipes:InitPostEntity()
	if map == "rp_begotten3" then
		local fire = ents.Create("env_fire")
		if not IsValid(fire) then return end

		fire:SetPos(Vector(14508, -12308, -1160))
		--no glow + delete when out + start on + last forever
		fire:SetKeyValue("spawnflags", tostring(128 + 16 + 4 + 2 + 1))
		fire:SetKeyValue("firesize", 1)
		fire:SetKeyValue("fireattack", 1)
		fire:SetKeyValue("damagescale", "1") -- only neg. value prevents dmg

		fire:Spawn()
		fire:Activate()
	end
end

netstream.Hook("Craft", function(player, uniqueID, itemIDs, craftAmount)
	cwRecipes:Craft(player, uniqueID, itemIDs, craftAmount);
end);