local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Ballroom Mask"
	ITEM.model = "models/begotten/headgroup_props/ballroommask.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ballroom_mask_plebian.png"
	ITEM.concealsFace = true;
	ITEM.weight = 0.3
	ITEM.uniqueID = "ballroom_mask"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_satanist";
	ITEM.skin = 1
	ITEM.description = "A ballroom mask for the most important social event that the Children of Satan partake in: the masquerade. This mask is plain and cracked, denoting a lack of social status."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.faction = "Children of Satan";
	
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Ornate Ballroom Mask"
	ITEM.model = "models/begotten/headgroup_props/ballroommask.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ballroom_mask.png"
	ITEM.concealsFace = true;
	ITEM.weight = 0.3
	ITEM.uniqueID = "ballroom_mask_ornate"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_satanist";
	ITEM.skin = 2
	ITEM.description = "A ballroom mask for the most important social event that the Children of Satan partake in: the masquerade. This mask is decorated with golden engravings, a sign of wealth and prestige."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.faction = "Children of Satan";
	
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Skullshield"
	ITEM.model = "models/begotten/headgroup_props/skullshield.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skullshield.png"
	ITEM.concealsFace = true;
	ITEM.weight = 1.5
	ITEM.uniqueID = "skullshield"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_satanist";
	ITEM.description = "A cushioned metal plate mask to be worn over the face. It is vaguely stylized to resemble a human skull. An imposing armor item found within the ranks of many dark cults. A haunting aura prevents you from wearing this if you are not worthy."
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/skullhelm";
	ITEM.faction = "Children of Satan";

	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gothic Plate Helmet"
	ITEM.model = "models/begotten/headgroup_props/vasso_helm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gothic_plate_helmet.png"
	ITEM.concealsFace = true;
	ITEM.weight = 1.5
	ITEM.uniqueID = "gothic_plate_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.description = "A Gothic plate helmet belonging to the one and only Lord Vasso."
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.faction = "Children of Satan";

	ITEM.conditionScale = 0 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 80
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
	ITEM.insulation = 100; -- Adds 20% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hellplate Helmet"
	ITEM.model = "models/begotten/headgroup_props/hellplatehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hellplate_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "hellplate_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_satanist";
	ITEM.description = "Once the dignified helmet of the White Sentinels and the sigil of House Philimaxio, this helmet has since been reforged in hellfire many times, only barely resembling its original form. Its existence is a disgrace to the Gatekeeper Order and an outright mockery of the Light."
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";
	ITEM.faction = "Children of Satan";

	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 75
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.75; -- reduces blunt damage by 25%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 50; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
ITEM:Register();