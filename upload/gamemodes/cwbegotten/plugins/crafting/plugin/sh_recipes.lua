--
--
-- EXAMPLE RECIPE FOR GABS
--
--

--[[local RECIPE = cwRecipes.recipes:New("example");
	RECIPE.name = "Example"; -- I would suggest adding the output of the recipe as a number in parantheses like I did for iron ingots, i.e. (3x) Wrought Iron Ingot
	RECIPE.model = "models/props_combine/breenclock.mdl"; -- NOT USED CURRENTLY
	RECIPE.description = "Example description" -- NOT USED CURRENTLY
	RECIPE.requiresHeatSource = false; -- Primarily for cooking, you can just not include this instead of making it false and it will work the same.
	RECIPE.requiresSmithy = true; -- Primarily for smithing, you can just not include this instead of making it false and it will work the same.
	
	-- Use one or the other, not both. These hide the recipe from players who do not meet the faction/faith requirements.
	RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
	RECIPE.excludedFactions = {"Goreic Warrior"};
	
	-- Use one or the other, not both. These hide the recipe from players who do not meet the faction/faith requirements.
	RECIPE.requiredFaiths = {"Faith of the Light"};
	RECIPE.excludedFaiths = {"Faith of the Family"};
	
	-- There is also requiredSubfactions, excludedSubfactions, requiredSubfaiths, and excludedSubfaiths.
	
	RECIPE.requiredBeliefs = {"ingenious"};
	
	RECIPE.requirements = {
		["wrought_iron_ingot"] = {amount = 1},
		["engraving_tool"] = {amount = 1, noTake = true},
		["charcoal"] = {amount = 1, nonEssential = true, noTake = true}, -- I don't think nonEssential is currently used?
	};
	RECIPE.result = {
		["begotten_dagger_irondagger"] = {amount = 1},
	};
	RECIPE.category = "Weapons" -- Valid categories are Weapons, Munitions, Armor, Cooking, Medical, Other.
	RECIPE.finishSound = "ambient/creatures/teddy.wav"; -- Sound that plays when the crafting action finishes successfully.
	RECIPE.failSound = "buttons/button2.wav" -- NOT USED CURRENTLY
	RECIPE.craftTime = 8 -- Time it takes for the crafting action bar to complete.
	RECIPE.craftVerb = "smithing" -- Verb seen in /mes and the crafting action bar.
	RECIPE.experience = 2 -- XP gained from crafting the recipe.
	
	function RECIPE:SetUpTooltip(frame)
	end;
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()]]--

--
--
-- CRAFTING MATERIALS
--
--

function cwRecipes:ClockworkInitialized()
	local RECIPE = cwRecipes.recipes:New("charcoal");
		RECIPE.name = "(2x) Charcoal";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["charcoal"] = {amount = 2},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 4;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	 
	RECIPE = cwRecipes.recipes:New("leathercloth");
		RECIPE.name = "Leather";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
		};
		RECIPE.result = {
			["leather"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "stitching"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("leatherhide");
		RECIPE.name = "(2x) Leather";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["hide"] = {amount = 1},
		};
		RECIPE.result = {
			["leather"] = {amount = 2},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "stitching"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("hide");
		RECIPE.name = "(3x) Hide";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["bearskin"] = {amount = 1},
		};
		RECIPE.result = {
			["hide"] = {amount = 3},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "stitching"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("wrought_iron_ingot");
		RECIPE.name = "(4x) Wrought Iron Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"smith"};
		RECIPE.requirements = {
			["iron_ore"] = {amount = 1},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["wrought_iron_ingot"] = {amount = 4},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 5;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_ingot");
		RECIPE.name = "Iron Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"smith"};
		RECIPE.requirements = {
			["wrought_iron_ingot"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 5;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("iron_ingot_reclaimed");
		RECIPE.name = "(Reclaimed) Iron Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"smith"};
		RECIPE.requirements = {
			["iron_chunks"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 5;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("steel_ingot");
		RECIPE.name = "Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"blacksmith"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("steel_ingot_reclaimed");
		RECIPE.name = "(Reclaimed) Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"blacksmith"};
		RECIPE.requirements = {
			["steel_chunks"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gold_ingot");
		RECIPE.name = "Gold Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"blacksmith"};
		RECIPE.requirements = {
			["gold_ore"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["gold_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("fine_steel_ingot");
		RECIPE.name = "Fine Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["fine_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("fine_steel_ingot_reclaimed");
		RECIPE.name = "(Reclaimed) Fine Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith"};
		RECIPE.requirements = {
			["fine_steel_chunks"] = {amount = 2},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["fine_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hellforged_steel_ingot");
		RECIPE.name = "Hellforged Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith", "sorcerer"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["belphegor_catalyst"] = {amount = 1},
			["charcoal"] = {amount = 2},
		};
		RECIPE.result = {
			["hellforged_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("familial_hellforged_steel_ingot");
		RECIPE.name = "(Familial) Hellforged Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith", "deceitful_snake"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["belphegor_catalyst"] = {amount = 1},
			["charcoal"] = {amount = 2},
		};
		RECIPE.result = {
			["hellforged_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("maximilian_steel_ingot");
		RECIPE.name = "Maximilian Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith", "emissary"};
		RECIPE.requiredFaiths = {"Faith of the Light"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 3},
			["charcoal"] = {amount = 2},
		};
		RECIPE.result = {
			["maximilian_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("shagalaxian_steel_ingot");
		RECIPE.name = "Shagalaxian Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith", "enduring_bear"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 1},
			["charcoal"] = {amount = 2},
		};
		RECIPE.result = {
			["shagalaxian_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("transmuted_hellforged_steel_ingot");
		RECIPE.name = "(Transmuted) Hellforged Steel Ingot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"master_blacksmith", "enduring_bear"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 1},
			["belphegor_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["hellforged_steel_ingot"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("technocraft");
		RECIPE.name = "Technocraft";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"mechanic", "wire_therapy"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["tech"] = {amount = 5},
		};
		RECIPE.result = {
			["technocraft"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "soldering"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- COOKING
	--
	--

	RECIPE = cwRecipes.recipes:New("cooked_bear_meat");
		RECIPE.name = "Cooked Bear Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["bear_meat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_bear_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("cooked_leopard_meat");
		RECIPE.name = "Cooked Leopard Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["leopard_meat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_leopard_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("cooked_deer_meat");
		RECIPE.name = "Cooked Deer Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["deer_meat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_deer_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("cooked_goat_meat");
		RECIPE.name = "Cooked Goat Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["goat_meat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_goat_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("cooked_human_meat");
		RECIPE.name = "Cooked Human Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["humanmeat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_human_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("cooked_yummy_meat");
		RECIPE.name = "Cooked Yummy Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["neatmeat"] = {amount = 1},
		};
		RECIPE.result = {
			["cooked_yummy_meat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("kings_meal");
		RECIPE.name = "(2x) King's Meal";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"culinarian"};
		RECIPE.requirements = {
			["bear_meat"] = {amount = 1},
			["deer_meat"] = {amount = 1},
			["goat_meat"] = {amount = 1},
			["spice"] = {amount = 1},
		};
		RECIPE.result = {
			["kings_meal"] = {amount = 2},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("masterclass_yummy_meal");
		RECIPE.name = "(2x) Cooked Canned Goodies";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"culinarian"};
		RECIPE.requirements = {
			["canned_yummy_meat"] = {amount = 1},
			["canned_yummy_beans"] = {amount = 1},
		};
		RECIPE.result = {
			["masterclass_yummy_meal"] = {amount = 2},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("wanderers_delight");
		RECIPE.name = "(2x) Wanderer's Delight";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"culinarian"};
		RECIPE.requirements = {
			["punctured_can_of_beans"] = {amount = 1},
			["punctured_can_of_soup"] = {amount = 1},
		};
		RECIPE.result = {
			["wanderers_delight"] = {amount = 2},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("meatmeal");
		RECIPE.name = "(3x) Meatmeal";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"culinarian"};
		RECIPE.requirements = {
			["fuckedmeat"] = {amount = 2},
			["spice"] = {amount = 1},
		};
		RECIPE.result = {
			["meatmeal"] = {amount = 3},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("purified_water");
		RECIPE.name = "Purified Water";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["dirtywater"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["purified_water"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("unfuckedmeat");
		RECIPE.name = "Unfucked Meat";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["fuckedmeat"] = {amount = 1},
		};
		RECIPE.result = {
			["unfuckedmeat"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("canned_meal");
		RECIPE.name = "Canned Meal";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"cookist"};
		RECIPE.requirements = {
			["crazy_can"] = {amount = 1},
		};
		RECIPE.result = {
			["canned_meal"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "cooking"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("varazdat_bloodwine");
		RECIPE.name = "Varazdat Bloodwine";
		RECIPE.requiredBeliefs = {"culinarian"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["finechug"] = {amount = 1},
			["spice"] = {amount = 1},
			["humanmeat"] = {amount = 1},
		};
		RECIPE.result = {
			["varazdat_bloodwine"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "brewing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- MEDICAL
	--
	--

	RECIPE = cwRecipes.recipes:New("crafted_bandage");
		RECIPE.name = "Crafted Bandage";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["crafted_bandage"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 2;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("splint");
		RECIPE.name = "Makeshift Splint";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["splint"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 2;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gauze");
		RECIPE.name = "Gauze";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
		};
		RECIPE.result = {
			["gauze"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("skintape");
		RECIPE.name = "Skintape";
		RECIPE.requiredBeliefs = {"primeval"};
		RECIPE.requirements = {
			["humanmeat"] = {amount = 3},
		};
		RECIPE.result = {
			["skintape"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 3;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("skingauze");
		RECIPE.name = "Skingauze";
		RECIPE.requiredBeliefs = {"primeval"};
		RECIPE.requirements = {
			["humanmeat"] = {amount = 5},
			["human_bone"] = {amount = 4},
		};
		RECIPE.result = {
			["skingauze"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 12
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("black_remedy");
		RECIPE.name = "Black Remedy";
		RECIPE.requiredBeliefs = {"ingenious", "plague_doctor"};
		RECIPE.requirements = {
			["antibiotics"] = {amount = 2},
			["laudanum"] = {amount = 1},
			["purifying_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["black_remedy"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("survivalpack");
		RECIPE.name = "Survival Pack";
		RECIPE.requiredBeliefs = {"ingenious", "doctor"};
		RECIPE.requirements = {
			["antibiotic_paste"] = {amount = 1},
			["forceps"] = {amount = 1},
			["gauze"] = {amount = 4},
			["ointment"] = {amount = 1},
			["suture"] = {amount = 1},
		};
		RECIPE.result = {
			["survivalpack"] = {amount = 1},
		};
		RECIPE.category = "Medical"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	--
	--
	-- TOOLS
	--
	--
	
	RECIPE = cwRecipes.recipes:New("campfire_kit");
		RECIPE.name = "Campfire Kit";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["wood"] = {amount = 6},
			["stone"] = {amount = 3},
		};
		RECIPE.result = {
			["campfire_kit"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 6
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("siege_ladder");
		RECIPE.name = "Siege Ladder";
		RECIPE.requiredBeliefs = {"craftsman"};
	--	RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["wood"] = {amount = 9},
		};
		RECIPE.result = {
			["siege_ladder"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("bear_trap");
		RECIPE.name = "Bear Trap";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["bear_trap"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("engraving_tool");
		RECIPE.name = "Engraving Tool";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["wrought_iron_ingot"] = {amount = 1},
			["stone"] = {amount = 1},
		};
		RECIPE.result = {
			["engraving_tool"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 12;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("breakdown_kit");
		RECIPE.name = "Breakdown Kit";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["breakdown_kit"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("armor_repair_kit");
		RECIPE.name = "Armor Repair Kit";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["armor_repair_kit"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("weapon_repair_kit");
		RECIPE.name = "Melee Repair Kit";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["weapon_repair_kit"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("firearm_repair_kit");
		RECIPE.name = "Firearm Repair Kit";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["firearm_repair_kit"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 12;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("lockpick");
		RECIPE.name = "Lockpick";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["lockpick"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- STORAGE
	--
	--

	RECIPE = cwRecipes.recipes:New("backpack_pouch");
		RECIPE.name = "Pouch";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 5},
		};
		RECIPE.result = {
			["backpack_pouch"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("backpack_small");
		RECIPE.name = "Small Backpack";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["backpack_pouch"] = {amount = 1},
			["cloth"] = {amount = 3},
		};
		RECIPE.result = {
			["backpack_small"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("backpack");
		RECIPE.name = "Backpack";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["backpack_small"] = {amount = 1},
			["leather"] = {amount = 3},
		};
		RECIPE.result = {
			["backpack"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("backpack_pouches");
		RECIPE.name = "Backpack w/ Pouches";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["backpack_pouch"] = {amount = 2},
			["backpack"] = {amount = 1},
		};
		RECIPE.result = {
			["backpack_pouches"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("backpack_survivalist");
		RECIPE.name = "Survivalist Backpack";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["backpack_pouches"] = {amount = 1},
			["leather"] = {amount = 8},
		};
		RECIPE.result = {
			["backpack_survivalist"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_pouch");
		RECIPE.name = "Gore Pouch";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hide"] = {amount = 3},
		};
		RECIPE.result = {
			["gore_pouch"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- WEAPONS
	--
	--

	RECIPE = cwRecipes.recipes:New("savage_claws");
		RECIPE.name = "Savage Claws";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_claws_savageclaws"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("steel_claws");
		RECIPE.name = "Steel Claws";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_claws_steelclaws"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("elegant_dagger");
		RECIPE.name = "Elegant Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_elegantdagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_hunting_dagger");
		RECIPE.name = "Gore Hunting Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_gorehuntingdagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 19;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_dagger");
		RECIPE.name = "Iron Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_dagger_irondagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 18;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("knightsbane");
		RECIPE.name = "Knightsbane";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_knightsbane"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("parrying_dagger");
		RECIPE.name = "Parrying Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_parryingdagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("quickshank");
		RECIPE.name = "Quickshank";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_quickshank"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("caestus");
		RECIPE.name = "Caestus";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["leather"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_fists_caestus"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_knuckles");
		RECIPE.name = "Iron Knuckles";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_fists_ironknuckles"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("spiked_knuckles");
		RECIPE.name = "Spiked Knuckles";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_knuckles"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_fists_spikedknuckles"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("claymore");
		RECIPE.name = "Claymore";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_2h_claymore"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("steel_longsword");
		RECIPE.name = "Steel Longsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_2h_exileknightsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_cleaver");
		RECIPE.name = "Gore Cleaver";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_gorecleaver"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_club");
		RECIPE.name = "Gore Club";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_2h_great_goreclub"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_war_axe");
		RECIPE.name = "Gore War Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_gorewaraxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("grockling_stone_maul");
		RECIPE.name = "Grockling Stone Maul";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_chunks"] = {amount = 3},
			["stone"] = {amount = 3},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_grocklingstonemaul"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("grocklingsacredstonemaul");
		RECIPE.name = "Grockling Sacred Stone Maul";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_2h_great_grocklingstonemaul"] = {amount = 1},
			["stone"] = {amount = 3},
			["familial_catalyst"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_2h_great_grocklingsacredstonemaul"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("haralder_war_axe");
		RECIPE.name = "Haralder War Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_haralderwaraxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gorefalx");
		RECIPE.name = "Gore Falx";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 2},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_falx"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("darklanderbardiche");
		RECIPE.name = "Darklander Bardiche";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_2h_great_darklanderbardiche"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("heavy_battle_axe");
		RECIPE.name = "Heavy Battle Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_heavybattleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("reaver_war_axe");
		RECIPE.name = "Reaver War Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_reaverwaraxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("evening_star");
		RECIPE.name = "Evening Star";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_great_eveningstar"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scraphammer");
		RECIPE.name = "Scraphammer";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["scrap"] = {amount = 5},
		};
		RECIPE.result = {
			["begotten_2h_great_scraphammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("volthammer");
		RECIPE.name = "Volthammer";
		RECIPE.requiredBeliefs = {"artisan", "jacobs_ladder"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["begotten_2h_great_scraphammer"] = {amount = 1},
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_volthammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "beams/beamstart5.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltsledge");
		RECIPE.name = "Voltsledge";
		RECIPE.requiredBeliefs = {"craftsman", "wire_therapy"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["begotten_2h_great_sledge"] = {amount = 1},
			["scrap"] = {amount = 1},
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_voltsledge"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "beams/beamstart5.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltsword");
		RECIPE.name = "Voltsword";
		RECIPE.requiredBeliefs = {"craftsman", "jacobs_ladder"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["scrap"] = {amount = 2},
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_1h_voltsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltprod");
		RECIPE.name = "Voltprod";
		RECIPE.requiredBeliefs = {"craftsman", "jacobs_ladder"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["scrap"] = {amount = 4},
			["tech"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_1h_voltprod"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "beams/beamstart5.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("war_club");
		RECIPE.name = "War Club";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_warclub"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("spiked_bat");
		RECIPE.name = "Spiked Bat";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_bat"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_spikedbat"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("bladed_bat");
		RECIPE.name = "Bladed Bat";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_bat"] = {amount = 1},
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_bladedbat"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_battle_axe");
		RECIPE.name = "Iron Battle Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_battleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("spiked_board");
		RECIPE.name = "Spiked Board";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_board"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_spikedboard"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("bladed_board");
		RECIPE.name = "Bladed Board";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_board"] = {amount = 1},
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_bladedboard"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("flanged_mace");
		RECIPE.name = "Flanged Mace";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_1h_flangedmace"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("glazicus");
		RECIPE.name = "Glazicus";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_glazicus"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("ornateglazicus");
	RECIPE.name = "Ornate Glazicus";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
	RECIPE.requirements = {
		["fine_steel_ingot"] = {amount = 2},
		["gold_ingot"] = {amount = 1},
	};
	RECIPE.result = {
		["begotten_1h_ornateglazicus"] = {amount = 1},
	};
	RECIPE.category = "Weapons"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 75;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_gore_battle_axe");
		RECIPE.name = "Iron Gore Battle Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_gorebattleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("steel_gore_battle_axe");
		RECIPE.name = "Steel Gore Battle Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["wood"] = {amount = 1},
			["familial_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_steelgorebattleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("iron_reaver_battleaxe");
		RECIPE.name = "Iron Reaver Battle Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_reaverbattleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_falchion");
		RECIPE.name = "Gore Falchion";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_gorefalchion"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_shortsword");
		RECIPE.name = "Gore Shortsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_goreshortsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_seax");
		RECIPE.name = "Gore Seax";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_goreseax"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("goremace");
		RECIPE.name = "Gore Mace";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["wrought_iron_ingot"] = {amount = 2},
			["wood"] = {amount = 2},
			["stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_goremace"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("familialsword");
		RECIPE.name = "Familial Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["familial_catalyst"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_familialsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("druidsword");
		RECIPE.name = "Druid Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["familial_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_druidsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_shortsword");
		RECIPE.name = "Iron Shortsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_ironshortsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_arming_sword");
		RECIPE.name = "Iron Arming Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_ironarmingsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("steel_arming_sword");
		RECIPE.name = "Steel Arming Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_steelarmingsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("spatha");
		RECIPE.name = "Spatha";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 4},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_spatha"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("morning_star");
		RECIPE.name = "Morning Star";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_morningstar"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("war_hammer");
		RECIPE.name = "War Hammer";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_warhammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("pipe_mace");
		RECIPE.name = "Pipe Mace";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["begotten_1h_pipe"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_pipemace"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("bone_dagger");
		RECIPE.name = "Bone Dagger";
		RECIPE.requiredBeliefs = {"ingenious", "primeval"};
		RECIPE.requirements = {
			["human_bone"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_dagger_bonedagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 0;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("bone_mace");
		RECIPE.name = "Bone Mace";
		RECIPE.requiredBeliefs = {"ingenious", "primeval"};
		RECIPE.requirements = {
			["human_bone"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_1h_bonemace"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 2;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("scrap_axe");
		RECIPE.name = "Scrap Axe";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["begotten_1h_tireiron"] = {amount = 1},
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_scrapaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hatchet");
		RECIPE.name = "Hatchet";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_hatchet"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("pickaxe");
		RECIPE.name = "Pickaxe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_2h_great_pickaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scimitar");
		RECIPE.name = "Scimitar";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["scimitar"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("warpedsword");
		RECIPE.name = "Warped Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 1},
			["belphegor_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_warpedsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("twistedclub");
		RECIPE.name = "Twisted Club";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["wrought_iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
			["belphegor_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_twistedclub"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrap_blade");
		RECIPE.name = "Scrap Blade";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_1h_scrapblade"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("training_sword");
		RECIPE.name = "Training Sword";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_trainingsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("poleaxe");
		RECIPE.name = "Poleaxe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_polearm_gatekeeperpoleaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("billhook");
		RECIPE.name = "Billhook";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
			["wood"] = {amount = 2},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_polearm_billhook"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("lucerne");
		RECIPE.name = "Lucerne";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_polearm_lucerne"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("halberd");
		RECIPE.name = "Halberd";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_polearm_halberd"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("pike");
		RECIPE.name = "Pike";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["wood"] = {amount = 7},
		};
		RECIPE.result = {
			["begotten_polearm_pike"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("polehammer");
		RECIPE.name = "Polehammer";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 5},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_polearm_polehammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("quarterstaff");
		RECIPE.name = "Quarterstaff";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_quarterstaff"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("war_spear");
		RECIPE.name = "War Spear";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_polearm_warspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("glazic_banner");
		RECIPE.name = "Glazic Banner";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["cloth"] = {amount = 6},
			["holy_spirit"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_polearm_glazicbanner"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("elegant_epee");
		RECIPE.name = "Elegant Epee";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["gold_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_rapier_elegantepee"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_rapier");
		RECIPE.name = "Iron Rapier";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_rapier_ironrapier"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("glaive");
		RECIPE.name = "Glaive";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_scythe_glaive"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("war_scythe");
		RECIPE.name = "War Scythe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_scythe_warscythe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("harpoon");
		RECIPE.name = "Harpoon";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["wrought_iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_spear_harpoon"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_spear");
		RECIPE.name = "Iron Spear";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_spear_ironspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_spear_short");
		RECIPE.name = "Iron Short Spear";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_spear_ironshortspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("satanic_spear");
		RECIPE.name = "Satanic Spear";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_spear_satanicspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrap_spear");
		RECIPE.name = "Scrap Spear";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_spear_scrapspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("training_spear");
		RECIPE.name = "Training Spear";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_spear_trainingspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("training_javelin");
		RECIPE.name = "Training Javelin";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_javelin_training_javelin"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltspear");
		RECIPE.name = "Voltspear";
		RECIPE.requiredBeliefs = {"craftsman", "jacobs_ladder"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["begotten_spear_ironspear"] = {amount = 1},
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_spear_voltspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("steel_spear");
		RECIPE.name = "Steel Spear";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_spear_wingedspear"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_javelin");
		RECIPE.name = "Iron Javelin";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_javelin_iron_javelin"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("throwing_axe");
		RECIPE.name = "(2x) Throwing Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_javelin_throwing_axe"] = {amount = 2},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("throwing_dagger");
		RECIPE.name = "(3x) Throwing Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_javelin_throwing_dagger"] = {amount = 3},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("pilum");
		RECIPE.name = "Pilum";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_javelin_pilum"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("club");
		RECIPE.name = "Club";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["cloth"] = {amount = 1},
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["begotten_2h_great_club"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("inquisitor_sword");
		RECIPE.name = "Inquisitor Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Light"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 3},
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_inquisitorsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltlongsword");
		RECIPE.name = "Voltlongsword";
		RECIPE.requiredBeliefs = {"mechanic", "jacobs_ladder"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 3},
			["technocraft"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_voltlongsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "beams/beamstart5.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("longsword");
		RECIPE.name = "Longsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 4},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_longsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("training_longsword");
		RECIPE.name = "Training Longsword";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_2h_traininglongsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("satanicmace");
		RECIPE.name = "Satanic Mace";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
			["down_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_satanicmace"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("satanicsword");
		RECIPE.name = "Satanic Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["down_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_satanicsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("satanicshortsword");
		RECIPE.name = "Satanic Shortsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["down_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_satanicshortsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("sataniclongsword");
		RECIPE.name = "Satanic Longsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["down_catalyst"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_sataniclongsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("satanicmaul");
		RECIPE.name = "Satanic Maul";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
			["pentagram_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_great_satanicmaul"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("shard");
		RECIPE.name = "Shard";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["unholy_sigil_stone"] = {amount = 1},
			["hellforged_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_shard"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- SACRIFICIAL WEAPONS
	--
	--
	
	RECIPE = cwRecipes.recipes:New("hellfire_sword");
		RECIPE.name = "Hellfire Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 2},
			["fire_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_hellfiresword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("unholy_sigil_sword");
		RECIPE.name = "Unholy Sigil Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["unholy_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_unholysigilsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("dreadaxe");
		RECIPE.name = "Dreadaxe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 4},
			["unholy_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_great_dreadaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 130;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("unholy_sigil_sword_fire");
		RECIPE.name = "Unholy Sigil Sword (Fire)";
		RECIPE.requiresSmithy = false;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["begotten_2h_unholysigilsword"] = {amount = 1},
			["fire_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_unholysigilsword_fire"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "possession/spiritsting.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "imbueing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("unholy_sigil_sword_ice");
		RECIPE.name = "Unholy Sigil Sword (Ice)";
		RECIPE.requiresSmithy = false;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["begotten_2h_unholysigilsword"] = {amount = 1},
			["ice_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_unholysigilsword_ice"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "possession/spiritsting.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "imbueing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("bell_hammer");
		RECIPE.name = "Bell Hammer";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Light"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 8},
			["judgemental_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_great_bellhammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("demonslayer_greataxe");
		RECIPE.name = "Demonslayer Greataxe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 4},
			["vengeful_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_great_demonslayerhammer"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 130;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("frozenfatherlandaxe");
		RECIPE.name = "Frozen Fatherland Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 3},
			["wood"] = {amount = 3},
			["ice_sigil_stone"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_sacrificial_frozenfatherlandaxe"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 175;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("blesseddruidsword");
		RECIPE.name = "Blessed Druid Sword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_druidsword"] = {amount = 1},
			["fire_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_blesseddruidsword"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 90;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("enchanted_longsword");
		RECIPE.name = "Enchanted Longsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Light"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["maximilian_steel_ingot"] = {amount = 3},
			["ice_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_enchantedlongsword_ice"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 125;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("glazicsword_glazicshield");
		RECIPE.name = "Glazic Sword + Sol Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Light"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["gold_ingot"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 1},
			["fire_sigil_stone"] = {amount = 1},
			["glazic_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_sacrificial_glazicsword_glazicshield"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 125;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("dark_ice_dagger");
		RECIPE.name = "Dark Ice Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["ice_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_sacrificial_darkdagger_ice"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("dark_fire_dagger");
		RECIPE.name = "Dark Fire Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["fire_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_sacrificial_darkdagger_fire"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("house_rekh_ancestraldagger");
		RECIPE.name = "House Rekh-khet-sa Ancestral Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["pentagram_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_houserekhkhetsaancestraldagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("house_varazdat_ancestraldagger");
		RECIPE.name = "House Varazdat Ancestral Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["pentagram_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_housevarazdatancestraldagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("house_philimaxio_ancestraldagger");
		RECIPE.name = "House Philimaxio Ancestral Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["pentagram_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_housephilimaxioancestraldagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("house_kinisger_ancestraldagger");
		RECIPE.name = "House Kinisger Ancestral Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["pentagram_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_housekinisgerancestraldagger"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("twistedmachete");
		RECIPE.name = "Twisted Machete";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["begotten_1h_machete"] = {amount = 1},
			["belphegor_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_twistedmachete"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- SHIELDS
	--
	--

	RECIPE = cwRecipes.recipes:New("clan_shield");
		RECIPE.name = "Clan Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1};
			["wood"] = {amount = 4},
		};
		RECIPE.result = {
			["shield14"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("dreadshield");
		RECIPE.name = "Dreadshield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 6},
			["pentagram_catalyst"] = {amount = 1},
			["tortured_spirit"] = {amount = 1},
		};
		RECIPE.result = {
			["shield13"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("spiked_shield");
		RECIPE.name = "Spiked Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Dark"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
			["tortured_spirit"] = {amount = 2},
		};
		RECIPE.result = {
			["shield8"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_shield");
		RECIPE.name = "Gatekeeper Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 5},
		};
		RECIPE.result = {
			["shield11"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("steel_gatekeeper_shield");
		RECIPE.name = "Steel Gatekeeper Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["shield11"] = {amount = 1},
			["steel_ingot"] = {amount = 8},
		};
		RECIPE.result = {
			["shield18"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 180;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("sol_sentinel_shield");
		RECIPE.name = "Sol Sentinel Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["maximilian_steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 7},
		};
		RECIPE.result = {
			["shield9"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("iron_shield");
		RECIPE.name = "Iron Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["shield6"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("steel_tower_shield");
		RECIPE.name = "Steel Tower Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 5},
			["leather"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["shield16"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 130;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrap_shield");
		RECIPE.name = "Scrap Shield";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 5},
		};
		RECIPE.result = {
			["shield1"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("warfighter_shield");
		RECIPE.name = "Warfighter Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["shield12"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltshield");
		RECIPE.name = "Voltshield";
		RECIPE.requiredBeliefs = {"craftsman", "wire_therapy"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["shield1"] = {amount = 1},
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["shield15"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "beams/beamstart5.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_guardian_shield");
		RECIPE.name = "Gore Guardian Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 7},
		};
		RECIPE.result = {
			["shield10"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("red_wolf_shield");
		RECIPE.name = "Red Wolf Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFaiths = {"Faith of the Family"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 5},
		};
		RECIPE.result = {
			["shieldunique1"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("wooden_shield");
		RECIPE.name = "Wooden Shield";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["wood"] = {amount = 5},
		};
		RECIPE.result = {
			["shield5"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("leather_shield");
		RECIPE.name = "Leather Shield";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["shield5"] = {amount = 1},
			["wood"] = {amount = 1},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["shield17"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "physics/wood/wood_strain3.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("buckler");
		RECIPE.name = "Buckler";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["shield4"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- FIREARMS
	--
	--

	RECIPE = cwRecipes.recipes:New("blunderbuss");
		RECIPE.name = "Blunderbuss";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_blunderbuss"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("wooden_crossbow");
		RECIPE.name = "Wooden Crossbow";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Grock"};
		RECIPE.requirements = {
			["bindings"] = {amount = 1},
			["iron_ingot"] = {amount = 2},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_crossbow"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("scrap_crossbow");
		RECIPE.name = "Scrap Crossbow";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["bindings"] = {amount = 1},
			["scrap"] = {amount = 5},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_scrapbow"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("musket");
		RECIPE.name = "Musket";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_musket"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("peppershot");
		RECIPE.name = "Peppershot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 3},
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_peppershot"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scavenger_gun");
		RECIPE.name = "Scavenger Gun";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["scrap"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_scavenger_gun"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 75;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("jezail");
	RECIPE.name = "Jezail";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredFaiths = {"Faith of the Dark"};
	RECIPE.requirements = {
		["steel_ingot"] = {amount = 3},
		["wood"] = {amount = 2},
		["belphegor_catalyst"] = {amount = 1},
	};
	RECIPE.result = {
		["begotten_jezail_short"] = {amount = 1},
	};
	RECIPE.category = "Munitions"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 80;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("jezail_rifle");
	RECIPE.name = "Jezail Rifle";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredFaiths = {"Faith of the Dark"};
	RECIPE.requirements = {
		["begotten_jezail_short"] = {amount = 1},
		["fine_steel_ingot"] = {amount = 1},
	};
	RECIPE.result = {
		["begotten_jezail_long"] = {amount = 1},
	};
	RECIPE.category = "Munitions"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 60;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scavenger_gun_magazine");
		RECIPE.name = "Scavenger Gun Magazine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["scavenger_gun_magazine"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scavenger_gun_large_magazine");
		RECIPE.name = "Scavenger Gun Large Magazine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["scavenger_gun_magazine"] = {amount = 1},
		};
		RECIPE.result = {
			["scavenger_gun_large_magazine"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("voltist_railgun");
		RECIPE.name = "Voltist Railgun";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic", "the_paradox_riddle_equation"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["technocraft"] = {amount = 1},
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_voltist_railgun"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 125;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gunpowder");
		RECIPE.name = "Gunpowder";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["fertilizer"] = {amount = 1},
			["charcoal"] = {amount = 1},
		};
		RECIPE.result = {
			["gunpowder"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	--
	--
	-- ARMOR
	--
	--
	
	RECIPE = cwRecipes.recipes:New("armored_blade_druid_robes");
		RECIPE.name = "Armored Blade Druid Robes";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["blade_druid_robes"] = {amount = 1},
			["iron_ingot"] = {amount = 4},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["armored_blade_druid_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("blade_druid_robes");
		RECIPE.name = "Blade Druid Robes";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["familial_catalyst"] = {amount = 1},
			["hide"] = {amount = 3},
			["cloth"] = {amount = 3},
		};
		RECIPE.result = {
			["blade_druid_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_seafarer_garb");
		RECIPE.name = "Gore Seafarer Garb";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hide"] = {amount = 2},
			["bearskin"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_seafarer_garb"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_beserker_armor");
		RECIPE.name = "Gore Berserker Armor";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hide"] = {amount = 4},
			["bearskin"] = {amount = 2},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_beserker_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_chainmail");
		RECIPE.name = "Gore Chainmail";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 4},
			["leather"] = {amount = 2},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_chainmail"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_lamellar");
		RECIPE.name = "Gore Lamellar";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 4},
			["leather"] = {amount = 4},
		};
		RECIPE.result = {
			["gore_lamellar"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("marauder_lamellar");
	RECIPE.name = "Reaver Marauder Lamellar";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredBeliefsNiceNames = {"Artisan"};
	RECIPE.requiredFactions = {"Goreic Warrior"};
	RECIPE.requirements = {
		["fine_steel_ingot"] = {amount = 1},
		["steel_ingot"] = {amount = 4},
		["leather"] = {amount = 4},
	};
	RECIPE.result = {
		["reaver_marauder_lamellar"] = {amount = 1},
	};
	RECIPE.category = "Armor"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 100;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("marauder_drottin_lamellar");
	RECIPE.name = "Reaver Drottinn Lamellar";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredBeliefsNiceNames = {"Artisan"};
	RECIPE.requiredFactions = {"Goreic Warrior"};
	RECIPE.requirements = {
		["reaver_marauder_lamellar"] = {amount = 1},
		["hellforged_steel_ingot"] = {amount = 1},
	};
	RECIPE.result = {
		["reaver_drottinn_lamellar"] = {amount = 1},
	};
	RECIPE.category = "Armor"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 100;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

    RECIPE = cwRecipes.recipes:New("marauder_helm");
	RECIPE.name = "Reaver Marauder Helmet";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredBeliefsNiceNames = {"Artisan"};
	RECIPE.requiredFactions = {"Goreic Warrior"};
	RECIPE.requirements = {
		["fine_steel_ingot"] = {amount = 1},
		["steel_ingot"] = {amount = 1},
		["leather"] = {amount = 2},
	};
	RECIPE.result = {
		["reaver_marauder_helm"] = {amount = 1},
	};
	RECIPE.category = "Armor"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 60;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

    RECIPE = cwRecipes.recipes:New("marauder_drottin_helm");
	RECIPE.name = "Reaver Drottinn Helmet";
	RECIPE.requiresSmithy = true;
	RECIPE.requiredBeliefs = {"artisan"};
	RECIPE.requiredBeliefsNiceNames = {"Artisan"};
	RECIPE.requiredFactions = {"Goreic Warrior"};
	RECIPE.requirements = {
		["reaver_marauder_helm"] = {amount = 1},
		["fine_steel_ingot"] = {amount = 1},
		["steel_ingot"] = {amount = 1},
	};
	RECIPE.result = {
		["reaver_drottinn_helm"] = {amount = 1},
	};
	RECIPE.category = "Armor"
	RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
	RECIPE.failSound = "buttons/button2.wav"
	RECIPE.craftTime = 8
	RECIPE.craftVerb = "smithing"
	RECIPE.experience = 40;
	
	function RECIPE:OnCraft(player)
	end;
	function RECIPE:OnFail(player)
	end;
	function RECIPE:StartCraft(player)
	end;
	function RECIPE:EndCraft(player)
	end;
RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_housecarl_armor");
		RECIPE.name = "Gore Housecarl Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 5},
			["leather"] = {amount = 3},
		};
		RECIPE.result = {
			["gore_housecarl_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 185;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_king's_chosen_armor");
		RECIPE.name = "Gore King's Chosen Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["vengeful_sigil_stone"] = {amount = 2},
			["shagalaxian_steel_ingot"] = {amount = 4},
			["gore_housecarl_armor"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_kings_chosen_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 250;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_king's_chosen_helmet");
		RECIPE.name = "Gore King's Chosen Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 3},
			["familial_catalyst"] = {amount = 2},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_kings_chosen_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("grockling_rattleshirt_armor");
		RECIPE.name = "Grockling Rattleshirt Armor";
		RECIPE.requiredBeliefs = {"ingenious", "primeval"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requiredSubfactions = {"Clan Grock"};
		RECIPE.requirements = {
			["human_bone"] = {amount = 7},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["grockling_rattleshirt_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("haralder_chainmail");
		RECIPE.name = "Haralder Chainmail";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 4},
			["leather"] = {amount = 2},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["haralder_chainmail"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 65;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_warfighter_armor");
		RECIPE.name = "Gore Warfighter Armor";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["leather"] = {amount = 3},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["gore_warfighter_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("red_wolf_plate");
		RECIPE.name = "Red Wolf Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 5},
			["human_bone"] = {amount = 2},
		};
		RECIPE.result = {
			["red_wolf_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 225;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_shagalax_helm");
		RECIPE.name = "Gore Shagalax Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requiredSubfactions = {"Clan Shagalax"};
		RECIPE.requirements = {
			["shagalaxian_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["gore_black_steel_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_guardian_helm");
		RECIPE.name = "Gore Guardian Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["gore_guardian_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_seafarer_hood");
		RECIPE.name = "Gore Seafarer Hood";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hide"] = {amount = 2},
		};
		RECIPE.result = {
			["gore_hood"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_warfighter_helm");
		RECIPE.name = "Gore Warfighter Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["gore_horned_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_raider_helm");
		RECIPE.name = "Gore Raider Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["leather"] = {amount = 2},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_raider_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_ridge_helm");
		RECIPE.name = "Gore Ridge Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_ridge_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 50;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gore_champion_ridge_helm");
		RECIPE.name = "Gore Champion Ridge Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 3},
			["familial_catalyst"] = {amount = 1},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["gore_champion_ridge_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("reaver_despoiler_helm");
		RECIPE.name = "Reaver Despoiler Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 3},
			["belphegor_catalyst"] = {amount = 1},
			["human_bone"] = {amount = 3},
		};
		RECIPE.result = {
			["reaver_despoiler_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 100;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gore_reaver_helm");
		RECIPE.name = "Gore Reaver Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["leather"] = {amount = 2},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["gore_spiked_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("voltist_archangel_exoskeleton");
		RECIPE.name = "Voltist Archangel Exoskeleton";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["technocraft"] = {amount = 1},
			["scrap"] = {amount = 8},
		};
		RECIPE.result = {
			["voltist_archangel_exoskeleton"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 175;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("voltist_archangel_exoskeleton_upgrade");
		RECIPE.name = "(Upgrade) Voltist Archangel Exoskeleton";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["voltist_exoskeleton"] = {amount = 1},
			["tech"] = {amount = 2},
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["voltist_archangel_exoskeleton"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("voltist_stormchaser_exoskeleton_upgrade");
		RECIPE.name = "(Upgrade) Voltist Stormchaser Exoskeleton";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["voltist_exoskeleton"] = {amount = 1},
			["technocraft"] = {amount = 1},
			["tech"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["voltist_archangel_exoskeleton"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 350;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("voltist_stormchaser_exoskeleton");
		RECIPE.name = "Voltist Stormchaser Exoskeleton";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["technocraft"] = {amount = 2},
			["fine_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["voltist_stormchaser_exoskeleton"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 500;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("voltist_exoskeleton");
		RECIPE.name = "Voltist Exoskeleton";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["tech"] = {amount = 3},
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["voltist_exoskeleton"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_halfplate_upgrade_gambeson");
		RECIPE.name = "(Upgrade) Gatekeeper Halfplate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gatekeeper_gambeson"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["gatekeeper_halfplate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_halfplate_upgrade_auxiliary");
		RECIPE.name = "(Upgrade) Gatekeeper Halfplate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["auxiliary_gambeson"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["gatekeeper_halfplate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("gatekeeper_halfplate_upgrade_praeventor");
		RECIPE.name = "(Upgrade) Gatekeeper Halfplate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["praeventor_gambeson"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["gatekeeper_halfplate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_halfplate");
		RECIPE.name = "Gatekeeper Halfplate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 4},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["gatekeeper_halfplate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 70;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_plate_upgrade_halfplate");
		RECIPE.name = "(Upgrade) Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gatekeeper_halfplate"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_plate");
		RECIPE.name = "Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 7},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("fine_gatekeeper_plate");
		RECIPE.name = "Fine Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 5},
			["steel_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["fine_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 225;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("fine_gatekeeper_plate_upgrade");
		RECIPE.name = "(Upgrade) Fine Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gatekeeper_plate"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["fine_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("ornate_gatekeeper_plate");
		RECIPE.name = "Ornate Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gold_ingot"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
			["fine_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.result = {
			["ornate_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 300;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("vexillifer_gatekeeper_plate");
		RECIPE.name = "Vexillifer Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["hide"] = {amount = 5},
			["fine_steel_ingot"] = {amount = 2},
			["ornate_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.result = {
			["vexillifer_gatekeeper_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("knight_plate");
		RECIPE.name = "Knight Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["holy_spirit"] = {amount = 1},
			["steel_ingot"] = {amount = 5},
			["maximilian_steel_ingot"] = {amount = 1},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["knight_plate"] = {amount = 1},
			["knight_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 350;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("knight_justicar_plate");
		RECIPE.name = "Knight Justicar Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["knight_plate"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 2},
			["glazic_sigil_stone"] = {amount = 1},
			["cloth"] = {amount = 3},
		};
		RECIPE.result = {
			["knight_justicar_plate"] = {amount = 1},
			["knight_justicar_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 400;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("high_gatekeeper_reinforced_plate");
		RECIPE.name = "Heavy Gatekeeper Reinforced Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["high_gatekeeper_heavy_plate"] = {amount = 1},
		};
		RECIPE.result = {
			["high_gatekeeper_reinforced_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 70;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("high_gatekeeper_heavy_plate_upgrade");
		RECIPE.name = "(Upgrade) Heavy Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gatekeeper_plate"] = {amount = 1},
			["steel_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["high_gatekeeper_heavy_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("high_gatekeeper_heavy_plate");
		RECIPE.name = "Heavy Gatekeeper Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 7},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["high_gatekeeper_heavy_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("auxiliary_gambeson");
		RECIPE.name = "Auxiliary Gambeson";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 3},
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["auxiliary_gambeson"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_gambeson");
		RECIPE.name = "Gatekeeper Gambeson";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 3},
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["gatekeeper_gambeson"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("praeventor_gambeson");
		RECIPE.name = "Praeventor Gambeson";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 3},
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["praeventor_gambeson"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("exile_knight_armor");
		RECIPE.name = "Exile Knight Armor";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["knight_plate"] = {amount = 1},
			["down_catalyst"] = {amount = 3},
		};
		RECIPE.result = {
			["exile_knight_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "possession/spiritsting.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "imbueing"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("knight_plate_purify");
		RECIPE.name = "(Purify) Knight Plate";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["exile_knight_armor"] = {amount = 1},
			["light_catalyst"] = {amount = 3},
		};
		RECIPE.result = {
			["knight_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "possession/spiritsting.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "imbueing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("light_brigandine_armor");
		RECIPE.name = "Light Brigandine Armor";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 2},
			["leather"] = {amount = 3},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["light_brigandine_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 45;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("wanderer_mail");
		RECIPE.name = "Wanderer Mail";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["leather"] = {amount = 2},
			["iron_ingot"] = {amount = 6},
		};
		RECIPE.result = {
			["wanderer_mail"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("wanderer_crude_plate");
		RECIPE.name = "Wanderer Crude Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["iron_ingot"] = {amount = 2},
			["leather"] = {amount = 1},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["wanderer_crude_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 70;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("padded_coat");
		RECIPE.name = "Padded Coat";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 4},
			["leather"] = {amount = 5},
		};
		RECIPE.result = {
			["padded_coat"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("twisted_fuck_armor");
		RECIPE.name = "Twisted Fuck Armor";
		RECIPE.requiredBeliefs = {"primeval"};
		RECIPE.requirements = {
			["human_bone"] = {amount = 6},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["twisted_fuck_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("orthodoxist_monk_robes");
		RECIPE.name = "Orthodoxist Monk Robes";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["cloth"] = {amount = 4},
			["leather"] = {amount = 2},
			["judgemental_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["orthodoxist_monk_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("orthodoxist_battle_monk_robes");
		RECIPE.name = "Orthodoxist Battle Monk Robes";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["orthodoxist_monk_robes"] = {amount = 1},
			["iron_ingot"] = {amount = 5},
		};
		RECIPE.result = {
			["orthodoxist_battle_monk_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("brigandine_armor");
		RECIPE.name = "Brigandine Armor";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["light_brigandine_armor"] = {amount = 1},
			["leather"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["brigandine_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("plague_doctor_robes");
		RECIPE.name = "Plague Doctor Robes";
		RECIPE.requiredBeliefs = {"ingenious", "plague_doctor"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 8},
		};
		RECIPE.result = {
			["plague_doctor_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 55;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrapper_grunt_plate");
		RECIPE.name = "Scrapper Grunt Plate";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 6},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["scrapper_grunt_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 30;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrapper_machinist_plate");
		RECIPE.name = "Scrapper Machinist Plate";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrapper_grunt_plate"] = {amount = 1},
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["scrapper_machinist_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("wanderer_oppressor_armor");
		RECIPE.name = "Wanderer Oppressor Armor";
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 2},
			["leather"] = {amount = 4},
			["steel_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["wanderer_oppressor_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 85;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("gatekeeper_helmet");
		RECIPE.name = "Gatekeeper Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["gatekeeper_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("wanderer_crude_plate_helm");
		RECIPE.name = "Wanderer Crude Plate Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["wanderer_crude_plate_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("helm_of_atonement");
		RECIPE.name = "Helm of Atonement";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["steel_ingot"] = {amount = 2},
			["leather"] = {amount = 1},
			["judgemental_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["helm_of_atonement"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("helm_of_repentance");
		RECIPE.name = "Helm of Repentance";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 5},
			["steel_ingot"] = {amount = 3},
			["judgemental_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["helm_of_repentance"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hood");
		RECIPE.name = "Hood";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["hood"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hood_mask");
		RECIPE.name = "Masked Hood";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 1},
			["hood"] = {amount = 1},
		};
		RECIPE.result = {
			["hood_mask"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 8;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("skintape_mask");
		RECIPE.name = "Skintape Mask";
		RECIPE.requiredBeliefs = {"ingenious", "primeval"};
		RECIPE.requirements = {
			["skingauze"] = {amount = 2},
			["skintape"] = {amount = 2},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["skintape_mask"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 20;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrap_helmet");
		RECIPE.name = "Scrap Helmet";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 4},
		};
		RECIPE.result = {
			["scrap_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/refine_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("wanderer_cap");
		RECIPE.name = "Wanderer Cap";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["wanderer_cap"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 15;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("mail_coif");
		RECIPE.name = "Mail Coif";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["mail_coif"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("plate_helmet_mail_coif");
		RECIPE.name = "Plate Helmet & Mail Coif";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["mail_coif"] = {amount = 1},
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["plate_helmet_mail_coif"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("spangenhelm");
		RECIPE.name = "Spangenhelm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["leather"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["spangenhelm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("fine_gatekeeper_helmet");
		RECIPE.name = "Fine Gatekeeper Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["fine_gatekeeper_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("fine_gatekeeper_helmet_upgrade");
		RECIPE.name = "(Upgrade) Fine Gatekeeper Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["gatekeeper_helmet"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["fine_gatekeeper_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("ornate_gatekeeper_helmet");
		RECIPE.name = "Ornate Gatekeeper Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 1},
			["hide"] = {amount = 1},
			["light_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["ornate_gatekeeper_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("ornate_gatekeeper_helmet_upgrade");
		RECIPE.name = "(Upgrade) Ornate Gatekeeper Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Gatekeeper", "Holy Hierarchy"};
		RECIPE.requirements = {
			["fine_gatekeeper_helmet"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
			["hide"] = {amount = 1},
			["light_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["ornate_gatekeeper_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 60;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("dread_armor");
		RECIPE.name = "Dread Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 2},
			["iron_ingot"] = {amount = 5},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["dread_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 225;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("darklander_immortal_armor");
		RECIPE.name = "Darklander Immortal Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 4},
			["fine_steel_ingot"] = {amount = 2},
			["pentagram_catalyst"] = {amount = 2},
		};
		RECIPE.result = {
			["darklander_immortal_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 225;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("elegant_robes");
		RECIPE.name = "Elegant Robes";
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["cloth"] = {amount = 8},
		};
		RECIPE.result = {
			["elegant_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "assembling"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("heavy_hellplate_armor");
		RECIPE.name = "Heavy Hellplate Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 3},
			["leather"] = {amount = 1},
			["hellplate_armor"] = {amount = 1},
		};
		RECIPE.result = {
			["heavy_hellplate_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hellplate_armor");
		RECIPE.name = "Hellplate Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 4},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["hellplate_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 150;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hellspike_armor");
		RECIPE.name = "Hellspike Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 3},
			["iron_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["hellspike_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("wraith_armor");
		RECIPE.name = "Wraith Armor";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 4},
			["steel_ingot"] = {amount = 2},
			["human_bone"] = {amount = 3},
		};
		RECIPE.result = {
			["wraith_armor"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 200;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("skullshield");
		RECIPE.name = "Skullshield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["fune_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["skullshield"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 35;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("hellplate_helmet");
		RECIPE.name = "Hellplate Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Children of Satan"};
		RECIPE.requirements = {
			["hellforged_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["down_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["hellplate_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 80;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("pop_a_shot");
		RECIPE.name = "(10x) Pop-a-Shot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["gunpowder"] = {amount = 1},
		};
		RECIPE.result = {
			["pop-a-shot"] = {amount = 10},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("longshot");
		RECIPE.name = "(4x) Longshot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["gunpowder"] = {amount = 1},
		};
		RECIPE.result = {
			["longshot"] = {amount = 4},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("grapeshot");
		RECIPE.name = "(3x) Grapeshot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["gunpowder"] = {amount = 2},
		};
		RECIPE.result = {
			["grapeshot"] = {amount = 3},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("scrapshot");
		RECIPE.name = "(10x) Scrapshot";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 1},
			["gunpowder"] = {amount = 1},
		};
		RECIPE.result = {
			["scrapshot"] = {amount = 10},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()

	RECIPE = cwRecipes.recipes:New("volt_projectile");
		RECIPE.name = "Volt Projectile";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman", "wire_therapy"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["scrap"] = {amount = 1},
		};
		RECIPE.result = {
			["volt_projectile"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("iron_bolt");
		RECIPE.name = "(3x) Iron Bolt";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Grock"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["iron_bolt"] = {amount = 3},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 25;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("scrap_bolt");
		RECIPE.name = "Scrap Bolt";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Grock"};
		RECIPE.requirements = {
			["scrap"] = {amount = 2},
		};
		RECIPE.result = {
			["scrap_bolt"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 10;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("thermal_implant");
		RECIPE.name = "Thermal Implant";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic", "the_paradox_riddle_equation"};
		RECIPE.requiredSubfaiths = {"Voltism"};
		RECIPE.requirements = {
			["tech"] = {amount = 3},
		};
		RECIPE.result = {
			["thermal_implant"] = {amount = 1},
		};
		RECIPE.category = "Other"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 40;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
end;