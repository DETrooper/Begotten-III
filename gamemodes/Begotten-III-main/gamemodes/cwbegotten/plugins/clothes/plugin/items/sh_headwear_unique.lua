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
	ITEM.insulation = 100;
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Helm of the Father"
	ITEM.model = "models/begotten/headgroup_props/gore_helm4.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_horned_helm.png"
	ITEM.concealsFace = true;
	ITEM.weight = 1.5
	ITEM.uniqueID = "helm_of_the_father"
	ITEM.category = "Helms"
	ITEM.attributes = {"fear"};
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_gore";
	ITEM.description = "A terrifying Shagalaxian steel helm shaped in the image of the Father. It is imposing enough to make any man feel that they are in the presence of a God."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 100
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.15; -- reduces bullet damage by 75%
	ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Shingar's Ridge Helm"
	ITEM.model = "models/begotten/headgroups_props/shingarhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_ridge_helm.png"
	ITEM.concealsFace = true;
	ITEM.weight = 1.5
	ITEM.uniqueID = "shingar_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_gore";
	ITEM.description = "A practical plated helm that has survived many battles. It is custom fitted to that of the Chosen Son Singar."
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 100
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.15; -- reduces bullet damage by 75%
	ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
	ITEM.insulation = 40; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
ITEM:Register();