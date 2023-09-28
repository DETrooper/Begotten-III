local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Ballroom Mask"
	ITEM.model = "models/begotten/headgroup_props/ballroommask.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ballroom_mask.png"
	ITEM.concealsFace = true;
	ITEM.weight = 0.3
	ITEM.uniqueID = "ballroom_mask"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_satanist";
	ITEM.skin = 2
	ITEM.description = "A ballroom mask for the most important social event that the Children of Satan partake in: the masquerade."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A cushioned metal plate mask to be worn over the face. It is vaguely stylized to resemble a human skull. An imposing armor item found within the ranks of many dark cults. A haunting aura prevents you from wearing this if you are not worthy."
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/skullhelm";

	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	
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
	ITEM.requireFaction = {"Children of Satan"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 80
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hellplate Helmet"
	ITEM.model = "models/begotten/headgroup_props/hellplatehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hellplate_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "hellplate_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_glaze";
	ITEM.description = "Once the dignified helmet of the White Sentinels and the sigil of House Philimaxio, this helmet has since been reforged in hellfire many times, only barely resembling its original form. Its existence is a disgrace to the Gatekeeper Order and an outright mockery of the Light."
	ITEM.requireFaction = {"Children of Satan"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 1.5 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 75
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	
ITEM:Register();