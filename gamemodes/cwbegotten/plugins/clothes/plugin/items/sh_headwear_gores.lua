local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Shagalax Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm5.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_black_steel_helm.png"
	ITEM.weight = 2
	ITEM.uniqueID = "gore_black_steel_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 5
	ITEM.headSuffix = "_gore";
	ITEM.description = "A blackened steel helmet used by many Gores of Clan Shagalax. It provides exemplary protection."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Crast", "Clan Harald", "Clan Reaver"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreshagalaxhelm";
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 72
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Bastard Gore Spikehelm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm6.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_guardian_helm.png"
	ITEM.weight = 3
	ITEM.uniqueID = "bastard_gore_spikehelm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.headSuffix = "_gore";
	ITEM.description = "A spiked and horned steel helmet typically worn by the forgotten offspring of Gores who fight to be noticed by the Gods. It provides exemplary protection."
	--ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreguardianhelm";
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 57
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Seafarer Hood"
	ITEM.model = "models/begotten/headgroup_props/gore_hood1.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_hood.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "gore_hood"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 9
	ITEM.headSuffix = "_gore";
	ITEM.description = "A typical Spearfolk cloth hood decorated with the teeth of slain beasts. The cloth smells of salty sea water."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 15
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "cloth";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Warfighter Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm4.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_horned_helm.png"
	ITEM.weight = 2
	ITEM.uniqueID = "gore_horned_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_gore";
	ITEM.description = "A crudely made horned helmet commonly worn by the savage warriors of Clan Gore. It provides reasonable protection."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gorewarfighterhelm";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.insulation = 45; -- Adds 9% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Bastard Raider Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm2.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_raider_helm.png"
	ITEM.weight = 0.9
	ITEM.uniqueID = "bastard_raider_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_gore";
	ITEM.description = "A compact iron helmet with two small horns, commonly worn by aspiring slaves seeking a worthy death at the Great Tree."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 35
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.insulation = 45; -- Adds 9% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Ridge Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm1.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_ridge_helm.png"
	ITEM.weight = 1.2
	ITEM.uniqueID = "gore_ridge_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_gore";
	ITEM.description = "An iron ridge helm of Goreic origin, embellished with decorations."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreridgehelm";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 53
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.bulletScale = 0.85; -- reduces bullet damage by 15%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Dread Minotaur Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_mino1.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_skull_helm.png"
	ITEM.weight = 1.5
	ITEM.concealsFace = true;
	ITEM.uniqueID = "gore_skull_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 10
	ITEM.headSuffix = "_gore";
	ITEM.description = "The skull of a slain beast, decorated with horns and cursed tribal fetishes. This helm instills a sense of impending doom into your enemies."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.attributes = {"fear"};
	ITEM.overlay = "begotten/zomboverlay/new/goreminotaur";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 40
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.insulation = 70; -- Adds 14% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"hide", "hide", "cloth", "human_bone"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Twisted Minotaur Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_mino2.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_skull_helm2.png"
	ITEM.weight = 1.5
	ITEM.concealsFace = true;
	ITEM.uniqueID = "gore_skull_helm2"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 11
	ITEM.headSuffix = "_gore";
	ITEM.description = "The skull of a slain beast, decorated with twisted horns and boiled pelts. This helm strikes fear into your enemies."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.attributes = {"fear"};
	ITEM.overlay = "begotten/zomboverlay/new/goreminotaur";

	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 40
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.insulation = 70; -- Adds 14% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"hide", "hide", "cloth", "human_bone"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Bastard Reaver Helm"
	ITEM.model = "models/begotten/headgroup_props/gore_helm3.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_spiked_helm.png"
	ITEM.weight = 0.9
	ITEM.uniqueID = "bastard_reaver_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_gore";
	ITEM.description = "A spiked bronze helmet worn by aspiring bandits and murderers seeking a worthy death at the Great Tree."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 35
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.insulation = 45; -- Adds 9% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Champion Ridge Helm"
	ITEM.model = "models/begotten/headgroups_props/lamellarridgehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/lamellar_ridge_helm.png"
	ITEM.weight = 3
	ITEM.uniqueID = "gore_champion_ridge_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 7
	ITEM.headSuffix = "_gore";
	ITEM.description = "A steel ridge helm that has been proven in combat. Only a worthy Gore may wear it."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreridgehelm";
	ITEM.excludedSubfactions = {"Clan Grock"};
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 67
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.60; -- reduces bullet damage by 40%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore King's Chosen Helmet"
	ITEM.model = "models/begotten/headgroups_props/scalehelmet.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/chosenarmor_helmet.png"
	ITEM.weight = 2.5
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 12
	ITEM.headSuffix = "_gore";
	ITEM.description = "A Shagalaxian steel helmet decorated with brass Familial sigils."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gorekingschosenhelmet";
	ITEM.excludedSubfactions = {"Clan Grock"};
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 77
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
	ITEM.insulation = 50;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Reaver Despoiler Helm"
	ITEM.model = "models/begotten/headgroups_props/reaverplatehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/reaver_plate_helm.png"
	ITEM.weight = 4.5
	ITEM.uniqueID = "reaver_despoiler_helm"
	ITEM.category = "Helms"
	ITEM.attributes = {"fear"};
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 8
	ITEM.headSuffix = "_gore";
	ITEM.description = "A sadistic hellforged steel helm decorated by human bone and demon horns. It has been cursed with catalystic energy that prevents it from being worn by the meek."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goredespoilerhelm";
	ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Crast", "Clan Harald", "Clan Shagalax"};
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 72
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Reaver Marauder Helmet"
	ITEM.model = "models/begotten_apocalypse/items/reaver_marauder_helm.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/reaver_marauder_helm.png"
	ITEM.headReplacement = "models/begotten/heads/reaver_marauder_helmet.mdl";
	ITEM.weight = 2
	ITEM.uniqueID = "reaver_marauder_helm"
	ITEM.category = "Helms"
	ITEM.description = "A finely-crafted spangenhelm with a chainmail aventail underneath, it is feared amongst those in the wasteland for being the last thing they ever see before they're condemned to slavery."
	ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
	ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Crast", "Clan Harald", "Clan Shagalax"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/genericmask";
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 0.8 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 62
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 60;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Reaver Drottinn Helmet"
	ITEM.model = "models/begotten_apocalypse/items/reaverchiefhelmet.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/reaverchiefhelmet.png"
	ITEM.headReplacement = "models/begotten/heads/reaver_chief_helmet.mdl";
	ITEM.weight = 2.5
	ITEM.uniqueID = "reaver_drottinn_helm"
	ITEM.category = "Helms"
	ITEM.description = "Made of blackened hellforged steel, this helmet belongs to the twisted torturer clan of Clan Reaver."
	ITEM.requiredFactions = {"Goreic Warrior"};
	ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Crast", "Clan Harald", "Clan Shagalax"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/genericmask";
	
	ITEM.conditionScale = 0.8 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 67
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.65; -- reduces bullet damage by 35%
	ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
	ITEM.insulation = 65;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "leather"}};
ITEM:Register();

-- NEW SHIT

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Crast Shaman Helm"
	ITEM.model = "models/begotten/misc/gore_cla_germ_helm.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_cla_germ_helm.png"
	ITEM.weight = 1.4
	ITEM.uniqueID = "crast_feather_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 5
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "A light iron helmet adorned with feathers and incense. These types of helmets are typically worn by Clan Crast shamans who prefer a protective alternate to their skull helmets. Healers use the quills of their feathers to suture wounds, increasing the effectiveness of their medicine."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.requiredbeliefs = {"watchful_raven"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.attributes = {"practitioner"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 53
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.bulletScale = 0.85; -- reduces bullet damage by 15%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Wolf Headdress"
	ITEM.model = "models/begotten/misc/gore_cla_wolf_trofe.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/wolfpelt.png"
	ITEM.weight = 2
	ITEM.uniqueID = "gore_wolf_headdress"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "The tanned pelt of a direwolf, stitched and imbued with the Father's wrath to bless his children with unnatural healing."
	ITEM.requireSubfaction = {"Clan Gore"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.attributes = {"lesserlifeleech", "recklessfury"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 28
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "cloth";

	ITEM.bluntScale = 0.60; -- reduces blunt damage by 40%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"bearskin", "hide", "hide"}};
ITEM:Register();

-- REPLACEMENTS (?)

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Haralder Sealord Ridge Helm"
	ITEM.model = "models/begotten/misc/gore_ancient_nord_cum.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_ancient_nord_cum.png"
	ITEM.weight = 3
	ITEM.uniqueID = "haralder_sealord_ridge_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 9
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "An ornate steel ridge helm that has been proven in combat. It bears the curse of Clan Harald."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreridgehelm";
	ITEM.requiredbeliefs = {"hauberk", "old_son"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 70
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.65; -- reduces pierce damage by 35%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.60; -- reduces bullet damage by 40%
	ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
	ITEM.insulation = 65;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Guardian Helm"
	ITEM.model = "models/begotten/misc/gore_lord_helm_3.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_lord_helm_3.png"
	ITEM.weight = 3
	ITEM.uniqueID = "gore_guardian_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "A spiked steel helmet typically worn by the defenders of the Great Tree. It provides exemplary protection."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreguardianhelm";
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 57
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Haralder King's Chosen Helmet"
	ITEM.model = "models/begotten/misc/gore_lord_helm_2.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_lord_helm_2.png"
	ITEM.uniqueID = "haralder_kings_chosen_helmet"
	ITEM.weight = 2.5
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "A Shagalaxian steel helmet decorated with gold Familial sigils, its powerful design hailing from the east. Those of Clan Harald hold a proud history of being selected as King's Chosen, though given their curse, it is incredibly rare for a Haralder to become King."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gorekingschosenhelmet";
	ITEM.excludedSubfactions = {"Clan Grock"};
	ITEM.requiredbeliefs = {"hauberk"};
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 78
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.65; -- reduces pierce damage by 35%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
	ITEM.insulation = 50;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Leather Helm"
	ITEM.model = "models/begotten/misc/gore_eldenringhelm.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_eldenringhelm.png"
	ITEM.weight = 0.9
	ITEM.uniqueID = "gore_leather_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 10
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "A leather helmet fashioned by Shagalax tanners from Vancouver. It is cheap to craft and somewhat protective."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.overlay = "begotten/zomboverlay/new/goreridgehelm";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 33
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 45; -- Adds 9% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth"}};
ITEM:Register();
	
local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gore Earmuff Helm"
	ITEM.model = "models/begotten/misc/gore_earmuff_helmet.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/gore_earmuff_helmet.png"
	ITEM.weight = 1.2
	ITEM.uniqueID = "gore_earmuff_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_preludegore";
	ITEM.description = "A cheap helmet designed for the Vancouver Gores. Despite its cheap materials, it has been forged to protect as much of the head as possible without hampering vision."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	
	ITEM.conditionScale = 1.2 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.bulletScale = 0.95; -- reduces bullet damage by 5%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks"}};
ITEM:Register();
