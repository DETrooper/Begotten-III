--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

cwRecipes.pileLifetime = 1200; -- 20 Minutes.
cwRecipes.minPileItems = 4;
cwRecipes.maxPileItems = 10;

local map = string.lower(game.GetMap());

if map == "rp_begotten3" then
	cwRecipes.maxPiles = 12;
else
	cwRecipes.maxPiles = 10;
end

if not cwRecipes.pileLocations then
	cwRecipes.pileLocations = {};
	
	if map == "rp_begotten3" then
		cwRecipes.pileLocations = {
			["ore"] = {
				-- Mines
				{pos = Vector(-1996.78125, -132.09375, -2600.46875), angles = Angle(-4.268, 167.031, -18.902)},
				{pos = Vector(-155.21875, -490.65625, -2634.09375), angles = Angle(42.49, 83.71, 11.376)},
				{pos = Vector(-3734.3125, 1342.0625, -2130.6875), angles = Angle(-6.010, 87.385, -1.373)},
				{pos = Vector(567.906250, -374.531250, -2647.687500), angles = Angle(-5.438, -176.462, -23.242)},
				{pos = Vector(729.3125, 3404.21875, -2373.03125), angles = Angle(5.438, -58.672, -22.8193)},
				{pos = Vector(2507.53125, 6645.0625, -2322.59375), angles = Angle(-11.003, 45.956, -12.404)},
				{pos = Vector(-2377.125, 8145.09375, -2733.46875), angles = Angle(-9.756, 45.923, -19.874)},
				{pos = Vector(2133.53125, 7209.40625, -2279.1875), angles = Angle(-11.492, -170.513, -30.866)},
				{pos = Vector(2668.15625, -167.46875, -2539.25), angles = Angle(-2.791, -124.464, -2.911)},
				{pos = Vector(3451.5625, 4565, -2299.96875), angles = Angle(-3.466, 5.433, -14.145)},
				{pos = Vector(3040.90625, 3169.375, -2333.46875), angles = Angle(-2.043, 87.517, -22.368)},
				{pos = Vector(2911.71875, 1753.53125, -2378.25), angles = Angle(-15.276, -91.752, -26.411)},
				{pos = Vector(-2417.28125, -2903.53125, -2715.875), angles = Angle(-7.383, -80.041, -21.682)},
				{pos = Vector(-2445.03125, 2931.65625, -2744.03125), angles = Angle(-1, 98.256, -25.318)},
				{pos = Vector(-3000.1875, 8204.3125, -2746.6875), angles = Angle(-2.247, -23.286, -19.946)},
				-- Gore Forest
				--{pos = Vector(-7515.875, -5587.78125, 11908.6875), angles = Angle(0, -45, 0)},
				--{pos = Vector(-8620.25, -10288.03125, 11686.5), angles = Angle(-2.368, -144.042, -11.569)},
				--{pos = Vector(-5187.03125, -8608.5625, 11806.40625), angles = Angle(-5.202, 35.321, -5.839)},
			},
			["wood"] = {
				-- Wasteland Forest
				{pos = Vector(-7681.28125, -1304.125, -1638.59375), angles = Angle(0.143, -46.137, -0.308)},
				{pos = Vector(-8451.78125, -1862.15625, -1650.75), angles = Angle(-3.944, 70.137, -4.125)},
				{pos = Vector(-8690.75, -465.4375, -1668.46875), angles = Angle(-7.213, -46.703, -0.665)},
				{pos = Vector(-6205.9375, -2449.4375, -1609.90625), angles = Angle(-0.396, 12.7, -3.818)},
				{pos = Vector(-6419.28125, -5128.40625, -1553.1875), angles = Angle(-0.659, 155.555, -0.807)},
				{pos = Vector(-4674.625, -4045.5625, -1649.875), angles = Angle(0.461, -159.055, 6.949)},
				-- Gore Forest
				{pos = Vector(-2787.71875, -2973.5625, 11679.65625), angles = Angle(3.219, -32.305, 5.751)},
				{pos = Vector(-5854.03125, -2759.25, 11933.40625), angles = Angle(-0.055, 37.057, -5.488)},
				{pos = Vector(354, -2565.84375, 11778.4375), angles = Angle(5.532, 26.829, -1.615)},
				{pos = Vector(-4508.90625, -2796.4375, 11928.4375), angles = Angle(2.834, 39.315, -1.005)},
				{pos = Vector(-3815.90625, -6824.6875, 11730.1875), angles = Angle(16.732, 125.859, 2.296)},
				{pos = Vector(-5124.96875, -11144.65625, 11675.25), angles = Angle(22.231, 162.955, 0.681)},
				{pos = Vector(-9206.125, -12769.25, 11946.59375), angles = Angle(1.483, 152.243, -2.296)},
				{pos = Vector(-7522.40625, -9564.1875, 11592.34375), angles = Angle(-10.003, -50.526, -0.692)},
			}
		};
	elseif map == "rp_begotten_redux" then
		cwRecipes.pileLocations = {
			["ore"] = {
				-- Mines
				{pos = Vector(-12584.21875, -10444.4375, -206.8125), angles = Angle(-21.555, -5.312, -25.466)},
				{pos = Vector(-10502, -10035.28125, -205.25), angles = Angle(-6.531, 88.391, -19.281)},
				{pos = Vector(-11096.4375, -9939.1875, -227.34375), angles = Angle(-2.719, 173.496, -15.353)},
				{pos = Vector(-11646.8125, -10131.15625, -223.625), angles = Angle(-5.427, 11.382, -26.45)},
				{pos = Vector(-12321.96875, -9931.84375, -227.375), angles = Angle(-3.203, -173.639, -20.402)},
				{pos = Vector(-12603.15625, -9017.625, -222.59375), angles = Angle(-3.312, -176.957, -15.584)},
				{pos = Vector(-12620.5625, -10041.625, -224.5625), angles = Angle(-6.092 ,-91.544, -12.821)},
				
				-- Wasteland
				{pos = Vector(-9665.25, -1583.3125, 21.84375), angles = Angle(-1.23, -74.366, 8.998)},
				{pos = Vector(-11100.21875, -1577.15625, 23.71875), angles = Angle(-6.603, -87.418, 15.826)},
				{pos = Vector(-12794.5, -1141.78125, 22.6875), angles = Angle(-3.862, -25.378, 17.067)},
				{pos = Vector(-11602.46875, -286.875, 67.4375), angles = Angle(-3.873, -140.301, -3.565)},
			},
			["wood"] = {
				-- Wasteland Forest
				{pos = Vector(-10318, 8496.25, 784.25), angles = Angle(1.758, 81.508, -2.401)},
				{pos = Vector(-7890.71875, 6008.375, 768.8125), angles = Angle(-1.747, 175.391, -0.5)},
				{pos = Vector(-4062.75, 7244.21875, 705.4375), angles = Angle(-0.137, -172.365, 1.582)},
				{pos = Vector(-1586.125, 4383.28125, 767.34375), angles = Angle(0.236, -88.962, 0.489)},
				{pos = Vector(-1348.15625, 9540.125, 751.3125), angles = Angle(-0.813, -96.784, -2.807)},
				{pos = Vector(2753.4375, 9341.25, 684.53125), angles = Angle(0.033, 156.27, -0.104)},
				{pos = Vector(2483.875, 5350.71875, 684.5), angles = Angle(0.132, 163.872, -0.165)},
				{pos = Vector(2628.8125, 2622.78125, 682.28125), angles = Angle(3.032, -138.73, -1.714)},
				{pos = Vector(5870.4375, 12611.3125, 683.3125), angles = Angle(-0.472, -54.025, 0.648)},
			}
		};
	elseif map == "rp_scraptown" then
		cwRecipes.pileLocations = {
			["ore"] = {
				{pos = Vector(-5779.781250, -8817.656250, 784.500000), angles = Angle(0.000, -134.978, 0.000)},
				{pos = Vector(-5457.500000, -8720.812500, 788.875000), angles = Angle(-1.077, 171.101, -8.553)},
				{pos = Vector(-5126.812500, -8714.156250, 797.562500), angles = Angle(1.582, -153.638, -16.150)},
				{pos = Vector(-4619.093750, -9506.375000, 798.968750), angles = Angle(3.186, 67.225, -7.333)},
				{pos = Vector(-4769.218750, -9664.062500, 789.093750), angles = Angle(-6.597, 48.593, -4.345)},
				{pos = Vector(-5819.937500, -9104.250000, 809.531250), angles = Angle(0.807, -14.222, -10.909)},
				{pos = Vector(-6796.562500, 12259.281250, 408.187500), angles = Angle(-3.016, -156.940, -9.305)},
				{pos = Vector(-7646.875000, 11925.718750, 409.843750), angles = Angle(-4.246, 17.078, -16.979)},
				{pos = Vector(-8517.937500, 11813.031250, 453.187500), angles = Angle(6.471, 27.834, 1.285)},
				{pos = Vector(-8948.562500, 12684.281250, 523.125000), angles = Angle(-6.268, -89.363, -15.892)},
				{pos = Vector(-7808.593750, 12389.625000, 406.875000), angles = Angle(-3.571, 156.736, -4.460)},
				{pos = Vector(-6647.625000, 11416.125000, 408.156250), angles = Angle(0.983, 43.726, -6.894)},
			},
			["wood"] = {
				{pos = Vector(-2711.062500, 6134.437500, 901.656250), angles = Angle(2.873, 89.973, -0.890)},
				{pos = Vector(-2295.562500, 5768.093750, 951.593750), angles = Angle(6.141, 87.759, -4.664)},
				{pos = Vector(-2056.187500, 6498.062500, 930.531250), angles = Angle(-3.433, 19.473, -1.456)},
				{pos = Vector(817.062500, 7087.000000, 894.156250), angles = Angle(-1.560, -9.278, -4.521)},
				{pos = Vector(1254.000000, 4979.843750, 877.375000), angles = Angle(0.846, -168.618, -3.631)},
				{pos = Vector(9820.093750, -710.250000, 260.125000), angles = Angle(4.532, 8.168, -6.471)},
				{pos = Vector(8327.593750, -1025.406250, 238.937500), angles = Angle(-1.467, -123.766, -2.911)},
				{pos = Vector(10824.937500, -388.406250, 264.312500), angles = Angle(1.505, -87.045, 4.515)},
				{pos = Vector(11328.000000, 6137.781250, 386.343750), angles = Angle(3.966, -147.233, 5.114)},
				{pos = Vector(11794.062500, 6607.406250, 411.125000), angles = Angle(-0.417, -82.249, 1.945)},
				{pos = Vector(11995.593750, 7613.843750, 410.968750), angles = Angle(0.341, -111.962, 0.775)},
				{pos = Vector(11389.718750, 9090.375000, 255.156250), angles = Angle(-3.230, -101.151, 5.070)},
				{pos = Vector(11730.968750, 10221.03125, 391.3750000), angles = Angle(6.498, 172.546, -4.180)},
				{pos = Vector(11917.343750, 7230.781250, 409.437500), angles = Angle(-1.022, 73.163, -4.752)},
				{pos = Vector(10364.750000, -267.437500, 224.218750), angles = Angle(0.681, -113.373, 7.872)},
			}
		};
	end
end

-- Called just before a recipe table is registered.
-- please enlighten me as to why it was done this way, seems to be causing issues with autorefresh so im gonna comment it out for now - DETrooper
--[[function cwRecipes:ModifyRecipeTable(recipeTable)
	-- A function to craft the recipe.
	function recipeTable:Craft(player, itemIDs)
		if (!self.result or !self.requirements) then
			return;
		end;
		
		if !cwRecipes:PlayerMeetsCraftingItemRequirements(player, self, itemIDs, true) then
			return;
		end
		
		for k, v in pairs (self.result) do
			-- todo: condition
			player:UpdateInventory(k, math.abs(v.amount));
		end;
		
		if (self.finishSound) then
			player:EmitSound(self.finishSound, 70);
		end;
		
		if (self.OnCraft) then
			self:OnCraft(player);
		end;
		
		hook.Run("PlayerFinishedCrafting", player, self);
	end;
end;]]--

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
	local faith = player:GetSharedVar("faith");
	local subfaction = player:GetSharedVar("subfaction");
	local subfaith = player:GetSharedVar("subfaith");
	
	if Clockwork.player:GetAction(player) ~= "" or player:IsRagdolled() or !player:Alive() or player.opponent or (cwDueling and cwDueling:PlayerIsInMatchmaking(player)) or player:GetNetVar("tied") != 0 then
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
					
						Schema:EasyText(player, "lightslategrey", "You require the '"..recipeTable.requiredBeliefsNiceNames[i].."' belief to craft this recipe!");
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
							player:SetNWString("cwRecipesVerb", craftVerb);
							player:SetNWString("cwRecipesName", craftName);
							
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins "..craftVerb.." a "..craftName..".", player:GetPos(), config.Get("talk_radius"):Get() * 2);
						end;
						
						if (recipeTable.StartCraft) then
							recipeTable:StartCraft(player);
						end;
						
						Clockwork.player:SetAction(player, "crafting", recipeTable.craftTime, 5, function()
							if (IsValid(player)) then
								recipeTable:Craft(player, itemIDs, false, craftAmount);
								
								player:SetNWString("cwRecipesVerb", nil);
								player:SetNWString("cwRecipesName", nil);
								
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

	local playerCount = _player.GetCount();
	local players = _player.GetAll();

	for i = 1, playerCount do
		local v, k = players[i], i;
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
		
		if not self.spawnLocations then
			self.spawnLocations = {};
		end
		
		if not self.Piles then
			self.Piles = {};
		end
		
		local piles = self.Piles;
		
		for i = 1, #piles do
			local pileTable = piles[i];
			
			if pileTable.lifeTime then
				if pileTable.lifeTime < curTime then
					local pile = pileTable.pile;
					
					if IsValid(pile) then
						if !self.occupier and self:IsAreaClear(pileTable.position, true) then
							local posFound = false;
							
							for k, v in pairs(self.pileLocations) do
								if posFound then
									break;
								end
								
								for j = 1, #v do
									if v[j].occupier == pile:EntIndex() then
										posFound = true;
										v[j].occupier = nil;
										
										break;
									end
								end
							end
							
							pile:Remove();
							table.remove(self.Piles, i);
							break;
						else
							-- Move this pile to the back of the queue, we'll check it again after all the others.
							-- This has the added side effect of making sure camping doesn't pay off :)
							table.remove(self.Piles, i);
							table.insert(self.Piles, pileTable);
						end
					end
				end
			else
				local pile = pileTable.pile;
				
				if IsValid(pile) then
					if !self.occupier and self:IsAreaClear(pileTable.position, true) then
						local posFound = false;
						
						for k, v in pairs(self.pileLocations) do
							if posFound then
								break;
							end
							
							for j = 1, #v do
								if v[j].occupier == pile:EntIndex() then
									posFound = true;
									v[j].occupier = nil;
									
									break;
								end
							end
						end
						
						pile:Remove();
						table.remove(self.Piles, i);
						
						break;
					else
						-- Move this pile to the back of the queue, we'll check it again after all the others.
						-- This has the added side effect of making sure camping doesn't pay off :)
						table.remove(self.Piles, i);
						table.insert(self.Piles, pileTable);
					end
				else
					table.remove(self.Piles, i);
					break;
				end
			end
		end
		
		if self.Piles then
			local numPiles = #self.Piles;

			if numPiles < self.maxPiles then
				local categories = {"ore", "wood"};
				--local category = categories[math.random(1, #categories)];
				local category;
				local unoccupiedLocations = {};
				
				if math.random(1, 3) == 1 then
					category = "ore";
				else
					category = "wood";
				end
				
				if self.pileLocations[category] then
					for i = 1, #self.pileLocations[category] do
						local location = self.pileLocations[category][i];
						
						if not location.occupier then
							table.insert(unoccupiedLocations, location);
						end
					end
					
					if #unoccupiedLocations > 0 then
						local unoccupiedLocation = unoccupiedLocations[math.random(#unoccupiedLocations)]
						
						if self:IsAreaClear(unoccupiedLocation.pos, false) then
							local pile;
							
							if category == "ore" then
								pile = ents.Create("cw_ironorepile")
							elseif category == "wood" then
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
								
								table.insert(self.Piles, pileTable);
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