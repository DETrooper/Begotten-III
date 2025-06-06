hook.Add("ClockworkInitialized", "ClockworkInitializedD21", function()
	local RECIPE = cwRecipes.recipes:New("hillkeeper_hauberk");
		RECIPE.name = "Hillkeeper Hauberk";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["leather"] = {amount = 2},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["hillkeeper_hauberk"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hillkeeper_fine_brigandine");
		RECIPE.name = "Hillkeeper Fine Brigandine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 4},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["hillkeeper_fine_brigandine"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hillkeeper_defender_plate");
		RECIPE.name = "Hillkeeper Defender Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["leather"] = {amount = 3},
			["cloth"] = {amount = 2},
			["steel_ingot"] = {amount = 3},
			["hillkeeper_fine_brigandine"] = {amount = 1},
		};
		RECIPE.result = {
			["hillkeeper_defender_plate"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_master-at-arms_harness");
		RECIPE.name = "Hillkeeper Master-at-Arms Harness";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["leather"] = {amount = 3},
			["glazic_sigil_stone"] = {amount = 1},
			["hillkeeper_defender_plate"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["hillkeeper_master-at-arms_harness"] = {amount = 1},
			
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 375;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_signifer_plate");
		RECIPE.name = "Hillkeeper Signifer Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hide"] = {amount = 5},
			["fine_steel_ingot"] = {amount = 2},
			["hillkeeper_defender_plate"] = {amount = 1},
		};
		RECIPE.result = {
			["hillkeeper_signifer_plate"] = {amount = 1},
		};
		RECIPE.category = "Armor"
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_heavy_coat_of_plates");
		RECIPE.name = "Hillkeeper Heavy Coat of Plate & Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 4},
			["hillkeeper_hauberk"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_heavy_helm"] = {amount = 1},
			["hillkeeper_heavy_coat_of_plates"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hide_parka");
		RECIPE.name = "Hide Parka";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 2},
			["hide"] = {amount = 2},
		};
		RECIPE.result = {
			["hide_parka"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hide_parka_upgrade_furvest");
		RECIPE.name = "(Upgrade) Hide Parka";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["fur_vest"] = {amount = 1},
			["leather"] = {amount = 1},
			["hide"] = {amount = 1},
		};
		RECIPE.result = {
			["hide_parka"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
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

	RECIPE = cwRecipes.recipes:New("bearhide_parka");
		RECIPE.name = "Bearhide Parka";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 4},
			["leather"] = {amount = 2},
			["bearskin"] = {amount = 1},
		};
		RECIPE.result = {
			["bearhide_parka"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_aketon");
		RECIPE.name = "Hillkeeper Aketon";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 3},
			["iron_ingot"] = {amount = 1},
		};
		RECIPE.result = {
			["hillkeeper_aketon"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("low_ministry_vestments");
		RECIPE.name = "Low Ministry Vestments";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["cloth"] = {amount = 5},
			["leather"] = {amount = 3},
		};
		RECIPE.result = {
			["low_ministry_vestments"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("low_ministry_cuirass");
		RECIPE.name = "Low Ministry Cuirass";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["steel_ingot"] = {amount = 3},
			["low_ministry_vestments"] = {amount = 1},
		};
		RECIPE.result = {
			["low_ministry_cuirass"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("footpad_wrappings");
		RECIPE.name = "Footpad Wrappings";
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["cloth"] = {amount = 3},
			["leather"] = {amount = 3},
		};
		RECIPE.result = {
			["footpad_wrappings"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("northern_orthodoxist_battle_monk_robes");
		RECIPE.name = "Northern Orthodoxist Battle Monk Robes";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["leather"] = {amount = 4},
			["steel_ingot"] = {amount = 3},
			["judgemental_sigil_stone"] = {amount = 1},
		};
		RECIPE.result = {
			["northern_orthodoxist_battle_monk_robes"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_low_brigandine_upgrade_aketon");
		RECIPE.name = "Hillkeeper Low Brigandine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hillkeeper_aketon"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["hillkeeper_low_brigandine"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_mailed_brigandine_upgrade_low_brigandine");
		RECIPE.name = "Hillkeeper Mailed Brigandine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hillkeeper_low_brigandine"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["hillkeeper_mailed_brigandine"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_hauberk_upgrade_low_brigandine");
		RECIPE.name = "(Upgrade) Hillkeeper Hauberk";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hillkeeper_low_brigandine"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["hillkeeper_hauberk"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_fine_brigandine_upgrade_mailed_brigandine");
		RECIPE.name = "(Upgrade) Hillkeeper Fine Brigandine";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hillkeeper_mailed_brigandine"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["hillkeeper_fine_brigandine"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_defender_plate_upgrade_heavy_coat");
		RECIPE.name = "(Upgrade) Hillkeeper Defender Plate";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hillkeeper_heavy_coat_of_plates"] = {amount = 1},
			["steel_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["hillkeeper_defender_plate"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("armored_furs");
		RECIPE.name = "Armored Furs";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["leather"] = {amount = 2},
			["hide"] = {amount = 2},
			["iron_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["armored_furs"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("armored_furs_upgrade_hideparka");
		RECIPE.name = "(Upgrade) Armored Furs";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["hide_parka"] = {amount = 1},
			["iron_ingot"] = {amount = 4},
		};
		RECIPE.result = {
			["armored_furs"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
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

	RECIPE = cwRecipes.recipes:New("armored_furs_upgrade_bearhideparka");
		RECIPE.name = "(Upgrade) Armored Furs";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["bearhide_parka"] = {amount = 1},
			["iron_ingot"] = {amount = 3},
		};
		RECIPE.result = {
			["armored_furs"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
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

	RECIPE = cwRecipes.recipes:New("fur_vest");
		RECIPE.name = "Fur Vest";
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["cloth"] = {amount = 5},
			["hide"] = {amount = 1},
		};
		RECIPE.result = {
			["fur_vest"] = {amount = 1},
		};
		RECIPE.category = "Armor"
		RECIPE.finishSound = "begotten/items/first_aid.wav";
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

	RECIPE = cwRecipes.recipes:New("flayed_fuck_armor");
		RECIPE.name = "Flayed Fuck Armor";
		RECIPE.requiredBeliefs = {"primeval"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["humanmeat"] = {amount = 8},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["flayed_fuck_armor"] = {amount = 1},
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

	-- Hill shit (recipes for helmets)

	RECIPE = cwRecipes.recipes:New("furhat");
		RECIPE.name = "Hide Wrapcap";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["leather"] = {amount = 1},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["furhat"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hill_acolyte_helm_upgrade_helm");
		RECIPE.name = "(Upgrade) Hillkeeper Watch Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["hillkeeper_helm"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_acolyte_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
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

	RECIPE = cwRecipes.recipes:New("hill_acolyte_helm");
		RECIPE.name = "Hillkeeper Watch Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 3},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["hill_acolyte_helm"] = {amount = 1},
		};
		RECIPE.category = "Armor"
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
	
	RECIPE = cwRecipes.recipes:New("hill_fine_coat_helmet");
		RECIPE.name = "Hillkeeper Nasal Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_fine_coat_helmet"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hill_fine_coat_helmet_upgrade_watch_helm");
		RECIPE.name = "(Upgrade) Hillkeeper Nasal Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["hill_acolyte_helm"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_fine_coat_helmet"] = {amount = 1},
		};
		RECIPE.category = "Armor"
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

	RECIPE = cwRecipes.recipes:New("hill_coat_helmet");
		RECIPE.name = "Hillkeeper Defender Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 1},
			["hide"] = {amount = 1},
			["light_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_coat_helmet"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hill_master_at_arms_helm");
		RECIPE.name = "Hillkeeper Master-at-Arms Ridgehelm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hill_coat_helmet"] = {amount = 1},
			["maximilian_steel_ingot"] = {amount = 2},
			["hide"] = {amount = 2},
			["light_catalyst"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_master_at_arms_helm"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hill_coat_helmet_upgrade_nasalhelm");
		RECIPE.name = "(Upgrade) Hillkeeper Defender Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hill_fine_coat_helmet"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 1},
			["steel_ingot"] = {amount = 1},
			["hide"] = {amount = 1},
		};
		RECIPE.result = {
			["hill_coat_helmet"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("hill_coat_helmet_upgrade_heavy_helm");
		RECIPE.name = "(Upgrade) Hillkeeper Defender Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["hill_heavy_helm"] = {amount = 1},
			["fine_steel_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["hill_coat_helmet"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("ministryhat");
		RECIPE.name = "Low Ministry Hat";
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["leather"] = {amount = 2},
			["cloth"] = {amount = 2},
		};
		RECIPE.result = {
			["ministryhat"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("ministryhelmet");
		RECIPE.name = "Low Ministry Scowling Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 1},
			["ministryhat"] = {amount = 1},
		};
		RECIPE.result = {
			["ministryhelmet"] = {amount = 1},
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
	
		RECIPE = cwRecipes.recipes:New("northern_orthodoxist_ceremonial_helm");
		RECIPE.name = "Northern Orthodoxist Ceremonial Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredSubfaiths = {"Sol Orthodoxy", "Hard-Glazed"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 3},
			["gold_ingot"] = {amount = 1},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["northern_orthodoxist_ceremonial_helm"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("hillkeeper_helm");
		RECIPE.name = "Hillkeeper Helm";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["leather"] = {amount = 2},
		};
		RECIPE.result = {
			["hillkeeper_helm"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("armored_fur_helmet");
		RECIPE.name = "Armored Fur Helmet";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.excludedFactions = {"Goreic Warrior"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
			["leather"] = {amount = 2},
			["hide"] = {amount = 1},
		};
		RECIPE.result = {
			["armored_fur_helmet"] = {amount = 1},
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

	-- Hill shit (recipes for weapons)

	RECIPE = cwRecipes.recipes:New("begotten_1h_hillshortsword");
		RECIPE.name = "Hill Shortsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_hillshortsword"] = {amount = 1},
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
		
	RECIPE = cwRecipes.recipes:New("begotten_1h_hillarmingsword");
		RECIPE.name = "Hill Spatha";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["leather"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_1h_hillarmingsword"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("begotten_2h_hilllongsword");
		RECIPE.name = "Hill Yeoman Longsword";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 3},
			["fine_steel_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_2h_hilllongsword"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("begotten_2h_great_hilllongaxe");
		RECIPE.name = "Hill Long Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["leather"] = {amount = 1},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_2h_great_hilllongaxe"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("begotten_1h_hillcrackaxe");
		RECIPE.name = "Hill Crackaxe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 2},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_1h_hillcrackaxe"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("begotten_dagger_hilldagger");
		RECIPE.name = "Hill Dagger";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_dagger_hilldagger"] = {amount = 1},
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

	RECIPE = cwRecipes.recipes:New("begotten_hillkeeper_axmusket");
		RECIPE.name = "Hillkeeper Axmusket";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["fine_steel_ingot"] = {amount = 2},
			["wood"] = {amount = 3},
		};
		RECIPE.result = {
			["begotten_hillkeeper_axmusket"] = {amount = 1},
		};
		RECIPE.category = "Munitions"
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

	-- Hill shit (recipes for shields)

	RECIPE = cwRecipes.recipes:New("shieldhill");
		RECIPE.name = "Hillkeeper Kite Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["wood"] = {amount = 5},
		};
		RECIPE.result = {
			["shieldhill"] = {amount = 1},
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
	
	RECIPE = cwRecipes.recipes:New("shieldhillsteel");
		RECIPE.name = "Steel Hillkeeper Shield";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["shieldhill"] = {amount = 1},
			["steel_ingot"] = {amount = 8},
		};
		RECIPE.result = {
			["shieldhillsteel"] = {amount = 1},
		};
		RECIPE.category = "Weapons"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 8
		RECIPE.craftVerb = "smithing"
		RECIPE.experience = 120;
		
		function RECIPE:OnCraft(player)
		end;
		function RECIPE:OnFail(player)
		end;
		function RECIPE:StartCraft(player)
		end;
		function RECIPE:EndCraft(player)
		end;
	RECIPE:Register()
	
	RECIPE = cwRecipes.recipes:New("begotten_javelin_axehill");
		RECIPE.name = "(2x) Hill Throwing Axe";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"mechanic"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 1},
			["wood"] = {amount = 2},
		};
		RECIPE.result = {
			["begotten_javelin_axehill"] = {amount = 2},
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
	
	RECIPE = cwRecipes.recipes:New("purified_water_bucket");
		RECIPE.name = "Bucket of Purified Water";
		RECIPE.requiresHeatSource = true;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["dirty_water_bucket"] = {amount = 1},
			["cloth"] = {amount = 1},
		};
		RECIPE.result = {
			["purified_water_bucket"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 10
		RECIPE.craftVerb = "boiling"
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

	RECIPE = cwRecipes.recipes:New("empty_bucket");
		RECIPE.name = "Empty Bucket";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"craftsman"};
		RECIPE.requirements = {
			["iron_ingot"] = {amount = 2},
		};
		RECIPE.result = {
			["empty_bucket"] = {amount = 1},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "generic_ui/smelt_success_02.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 10
		RECIPE.craftVerb = "forging"
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

	RECIPE = cwRecipes.recipes:New("three_purified_water");
		RECIPE.name = "(3x) Purified Water";
		RECIPE.requiresSmithy = false;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["empty_bottle"] = {amount = 3},
			["purified_water_bucket"] = {amount = 1},
		};
		RECIPE.result = {
			["empty_bucket"] = {amount = 1},
			["purified_water"] = {amount = 3},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 20
		RECIPE.craftVerb = "pouring"
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

	RECIPE = cwRecipes.recipes:New("three_dirty_water");
		RECIPE.name = "(3x) Dirty Water";
		RECIPE.requiresSmithy = false;
		RECIPE.requiredBeliefs = {"ingenious"};
		RECIPE.requirements = {
			["empty_bottle"] = {amount = 3},
			["dirty_water_bucket"] = {amount = 1},
		};
		RECIPE.result = {
			["empty_bucket"] = {amount = 1},
			["dirtywater"] = {amount = 3},
		};
		RECIPE.category = "Cooking"
		RECIPE.finishSound = "ambient/fire/mtov_flame2.wav";
		RECIPE.failSound = "buttons/button2.wav"
		RECIPE.craftTime = 20
		RECIPE.craftVerb = "pouring"
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
	
	RECIPE = cwRecipes.recipes:New("begotten_polearm_hillkeepersignum");
		RECIPE.name = "Hillkeeper Signum";
		RECIPE.requiresSmithy = true;
		RECIPE.requiredBeliefs = {"artisan"};
		RECIPE.requiredFactions = {"Hillkeeper"};
		RECIPE.requirements = {
			["steel_ingot"] = {amount = 1},
			["iron_ingot"] = {amount = 1},
			["leather"] = {amount = 2},
			["holy_spirit"] = {amount = 1},
		};
		RECIPE.result = {
			["begotten_polearm_hillkeepersignum"] = {amount = 1},
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
end);