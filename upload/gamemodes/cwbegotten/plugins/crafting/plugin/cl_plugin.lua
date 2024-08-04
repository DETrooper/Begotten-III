--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

Clockwork.ConVars.CRAFTINGPILESPAWNESP = Clockwork.kernel:CreateClientConVar("cwCraftingPileSpawnESP", 0, false, true)

Clockwork.datastream:Hook("CraftingPileSpawnESPInfo", function(data)
	if data then
		if data[1] then
			cwRecipes.pileLocations = data[1];
		end
	end
end);

function cwRecipes:GetAdminESPInfo(info)
	if (Clockwork.ConVars.CRAFTINGPILESPAWNESP and Clockwork.ConVars.CRAFTINGPILESPAWNESP:GetInt() == 1) then
		if (self.pileLocations) then
			if (table.IsEmpty(self.pileLocations)) then
				self.pileLocations = nil;
				
				return;
			end;
			
			for k, v in pairs (self.pileLocations) do
				for i, v2 in ipairs(v) do
					if (!v2 or !isvector(v2.pos)) then
						self.pileLocations[k][i] = nil;
						
						continue;
					end;

					info[#info + 1] = {
						position = v2.pos,
						text = k;
						color = Color(200, 200, 200);
					};
				end
			end;
		end;
	end;
end

-- A function to build the default crafting tooltip.
function cwRecipes:BuildCraftingTooltip(frame, recipeTable)

end;

function cwRecipes:AttemptCraft(uniqueID, amount)
	local curTime = CurTime();
	
	if !self.nextCraftAttempt or self.nextCraftAttempt < curTime then
		if self.slottedItems then
			if table.IsEmpty(self.slottedItems) then
				Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You have no items selected to craft!");
				return;
			end
			
			local recipeTable = self.recipes.stored[uniqueID];
			
			if recipeTable then
				if self:PlayerMeetsCraftingItemRequirements(recipeTable, amount) then
					netstream.Start("Craft", recipeTable.uniqueID, self.slottedItems, amount);
					
					if (IsValid(Clockwork.Client.cwCraftingMenu)) then
						Clockwork.Client.cwCraftingMenu:Close()
						Clockwork.Client.cwCraftingMenu:Remove()
						Clockwork.Client.cwCraftingMenu = nil;
						return;
					end
				end
			else
				Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You must select a recipe to craft!");
			end
		else
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You have no items selected to craft!");
			self.slottedItems = {};
		end
		
		self.nextCraftAttempt = curTime + 2;
	end
end

-- Called when a player attempts to craft a recipe.
function cwRecipes:PlayerCanCraft(uniqueID)
	local recipeTable = self.recipes.stored[uniqueID];
	local access = recipeTable.access;
	local hasFlags = true;
	local requiredBeliefs = recipeTable.requiredBeliefs;
	local requiresHeatSource = recipeTable.requiresHeatSource;
	local requiresSmithy = recipeTable.requiresSmithy;
	local faction = Clockwork.Client:GetFaction();
	local faith = Clockwork.Client:GetNetVar("faith");
	local subfaction = Clockwork.Client:GetNetVar("subfaction");
	local subfaith = Clockwork.Client:GetNetVar("subfaith");
	
	if Clockwork.Client:IsRagdolled() or !Clockwork.Client:Alive() then
		Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "Your character cannot craft at this moment!");
		return false;
	end
	
	if (access) then
		if (!Clockwork.player:HasFlags(Clockwork.Client, access)) then
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
	
	if cwBeliefs and cwBeliefs.HasBelief then
		if !cwBeliefs:HasBelief("ingenious") then
			return false;
		else
			if requiredBeliefs then
				for i = 1, #requiredBeliefs do
					if !cwBeliefs:HasBelief(requiredBeliefs[i]) then
						-- this is messy but fuck it
						if requiredBeliefs[i] == "sorcerer" and uniqueID == "hellforged_steel_ingot" then
							if subfaction == "Rekh-khet-sa" then
								continue;
							end
						end
					
						Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You require the '"..cwBeliefs:GetBeliefName(recipeTable.requiredBeliefs[i]).."' belief to craft this recipe!");
						return false;
					end
				end
			end
		end
	end
	
	if requiresHeatSource then
		local fire_found = false;
		
		for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 128)) do
			if (v:GetClass() == "env_fire") then
				fire_found = true;
				break;
			end;
		end;
		
		if not fire_found then
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You must be standing next to a heat source to craft this recipe!");
			return false;
		end
	end
	
	if hasFlags and requiresSmithy then
		local valid_smithy_found = false;
		
		for i = 1, #self.smithyLocations do
			if Clockwork.Client:GetPos():DistToSqr(self.smithyLocations[i]) < (256 * 256) then
				valid_smithy_found = true;
				break;
			end
		end
		
		if valid_smithy_found == false then
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You must be standing next to a smithy to craft this recipe!");
			return false;
		end
	end

	return hasFlags;
end;

function cwRecipes:PlayerMeetsCraftingItemRequirements(recipeTable, craftAmount)
	if !cwRecipes.slottedItems or table.IsEmpty(cwRecipes.slottedItems) then
		Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You have no items selected to craft!");
		return false;
	end

	if isstring(recipeTable) then
		recipeTable = self.recipes.stored[recipeTable];
		
		if !recipeTable or isstring(recipeTable) then
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "No valid recipe for this combination of items could be found!");
			return false;
		end
	end
	
	local inventory = Clockwork.inventory:GetClient();
	local slottedItems = {};
	local requirements = recipeTable.requirements;
	
	for i = 1, #cwRecipes.slottedItems do
		local itemID = cwRecipes.slottedItems[i];
		
		for k, v in pairs(inventory) do
			for k2, v2 in pairs(v) do
				if v2.itemID == itemID then
					table.insert(slottedItems, Clockwork.inventory:FindItemByID(inventory, k, v2.itemID));
					break;
				end
			end
		end
	end
	
	local temptab = table.Copy(slottedItems);

	for i = 1, craftAmount do
		for k, v in pairs(requirements) do
			local amount = v.amount;

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
					Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "The items inputted for crafting do not match the selected recipe's requirements!");
					return false;
				end
			end
		end

	end
	
	if #temptab > 0 then
		Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "The items inputted for crafting do not match the selected recipe's requirements!");
		return false;
	end
	
	return true;
end

-- A function to get all the available recipes.
function cwRecipes:GetAvailable()
	local allRecipes = self:GetAll();
	local client = Clockwork.Client;
	local available = allRecipes;
	
	for k, v in pairs (allRecipes) do
		local access = v.access;
		
		if (!access) then
			continue;
		end;

		if (!Clockwork.player:HasFlags(client, access) and available[k]) then
			available[k] = nil; continue;
		end;
		
		if (hook.Run("PlayerCanCraft", k) == false) then
			available[k] = nil; continue;
		end;
	end;
	
	return available;
end;

Clockwork.setting:AddCheckBox("Admin ESP", "Show resource pile spawn points.", "cwCraftingPileSpawnESP", "Click to enable/disable the resource spawner ESP.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);