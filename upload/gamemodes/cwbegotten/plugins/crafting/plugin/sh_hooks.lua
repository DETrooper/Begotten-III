--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

library.New("recipes", cwRecipes);
cwRecipes.recipes.stored = cwRecipes.recipes.stored or {};
local RECIPE_TABLE = {__index = RECIPE_TABLE};

-- Called when the item is converted to a string.
function RECIPE_TABLE:__tostring()
	return self.uniqueID;
end;

-- Called when the item is invoked as a function.
function RECIPE_TABLE:__call(varName, failSafe)
	return self[varName] or failSafe;
end;

-- A function to register a recipe table.
function RECIPE_TABLE:Register()
	cwRecipes.recipes:Register(self);
end;

-- A function to get a new recipe.
function cwRecipes.recipes:New(uniqueID)
	if (!uniqueID) then
		return;
	end;
	
	local object = Clockwork.kernel:NewMetaTable(RECIPE_TABLE);
		object.uniqueID = cwRecipes:SafeName(uniqueID);
	return object;
end;

-- A function to register a recipe.
function cwRecipes.recipes:Register(recipe)
	if (recipe) then
		local bInvalid = false;
		
		if (!recipe.uniqueID or !recipe.requirements) then
			return;
		else
			recipe.uniqueID = cwRecipes:SafeName(recipe.uniqueID);
			recipe.category = recipe.category or "Other";
			
			for k, v in pairs (recipe.requirements) do
				local itemTable = item.FindByID(k)
				
				if (!itemTable) then
					bInvalid = true; break;
				end;
				
				if (!v.take) then
					v.take = false;
				end;
			end;
		end;

		if (bInvalid) then
			return;
		end;
		
		if (SERVER) then
			--hook.Run("ModifyRecipeTable", recipe);
			
			function recipe:Craft(player, itemIDs, bMetRequirements)
				if (!self.result or !self.requirements) then
					return;
				end;
				
				if !bMetRequirements then
					local bHasFlags, bHasRequirements = hook.Run("PlayerCanCraft", player, self.uniqueID);
				
					if bHasFlags == false or bHasRequirements == false then
						return;
					end
					
					if !cwRecipes:PlayerMeetsCraftingItemRequirements(player, self, itemIDs, true) then
						return;
					end
				end
				
				--[[for k, v in pairs (self.requirements) do
					if (v.take != true) then
						continue;
					end;
					
					player:UpdateInventory(k, -math.abs(v.amount));
				end;]]--
				
				local conditionAverage = player.conditionAverage or 100;
				
				for k, v in pairs (self.result) do
					if conditionAverage < 100 then				
						for i = 1, math.abs(v.amount) do
							local item = Clockwork.item:CreateInstance(k);
							
							if !item.attributes or (item.attributes and !table.HasValue(item.attributes, "conditionless")) then
								local condition = math.Clamp(math.random(conditionAverage - 10, conditionAverage), 0, 100);
							
								item:SetCondition(condition, true);
							end
							
							if item.category == "Shot" then
								item:SetData("Rounds", 0)
							end
							
							player:GiveItem(item, true);
						end
					else
						for i = 1, math.abs(v.amount) do
							local item = Clockwork.item:CreateInstance(k);
							
							if item.category == "Shot" then
								item:SetData("Rounds", 0)
							end
							
							player:GiveItem(item, true);
						end
					end
					
					--player:UpdateInventory(k, math.abs(v.amount));
				end;
				
				if (self.finishSound) then
					player:EmitSound(self.finishSound, 70);
				end;
				
				if (self.OnCraft) then
					self:OnCraft(player);
				end;
				
				hook.Run("PlayerFinishedCrafting", player, self);
			end;
		end;
		
		self.stored[recipe.uniqueID] = recipe;
	end;
end;

-- A function to convert a string to a uniqueID.
function cwRecipes:SafeName(uniqueID)
	return string.lower(string.gsub(uniqueID, "['%.]", ""));
end;

-- A function to get all of the recipes on the server.
function cwRecipes:GetAll()
	return self.recipes.stored;
end;

-- A function to find a specific recipe.
function cwRecipes:FindByID(identifier)
	if (self.recipes.stored[identifier]) then
		return self.recipes.stored[identifier];
	else
		for k, v in pairs (self.recipes.stored) do
			if (string.lower(v.name) == string.lower(identifier)) then
				return self.recipes.stored[k];
			end;
		end;
	end;
end;