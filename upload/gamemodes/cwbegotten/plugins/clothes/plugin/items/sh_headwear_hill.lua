local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Watch Helm" -- Gatekeeper Helmet equivalent
	ITEM.model = "models/begotten_apocalypse/items/hill_acolyte_helm.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_acolyte_helm.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "hill_acolyte_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_hill";
	ITEM.description = "An iron helmet over an iron coif that evokes a barbaric visage, often worn by yeomen of the Watch."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 57
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.85; -- reduces bullet damage by 15%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 45; -- Adds 7% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hide Wrapcap"
	ITEM.model = "models/begotten_apocalypse/items/furhat.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/furhat.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "furhat"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.headSuffix = "_hill";
	ITEM.description = "A cap made of fur, held together by linen string and crude stitching. Warm yet barely protective."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 25
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 60; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Nasal Helm" -- Fine Gatekeeper Helmet equivalent
	ITEM.model = "models/begotten_apocalypse/items/hill_fine_coat_helmet.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_fine_coat_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "hill_fine_coat_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_hill";
	ITEM.description = "An opened face iron helmet allowing for greater visibility. Commonly seen used by veterans of the Watch."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 65
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 50; -- Adds 7% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Defender Helm" -- Ornate Gatekeeper Helmet equivalent
	ITEM.model = "models/begotten_apocalypse/items/hill_coat_helmet.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_coat_helmet.png"
	ITEM.weight = 2
	ITEM.uniqueID = "hill_coat_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_hill";
	ITEM.description = "An ornate helm with a serpent adornment sat atop, and a full-faced iron chain coif protecting the whole of the neck."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 75
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 60; -- Adds 4% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Heavy Helm" -- Wanderer Crude Plate Helm equivalent
	ITEM.model = "models/begotten_apocalypse/items/hill_heavy_helm.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_heavy_helm.png"
	ITEM.weight = 3
	ITEM.uniqueID = "hill_heavy_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_hill";
	ITEM.description = "A thick helmet with a split chain coif, padded and made of steel."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 60
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 60; -- Adds 4% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 4000};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Master-at-Arms Ridgehelm"
	ITEM.model = "models/begotten_apocalypse/items/hill_master_at_arms_helm.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_master_at_arms_helm.png"
	ITEM.weight = 3
	ITEM.uniqueID = "hill_master_at_arms_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 5
	ITEM.headSuffix = "_hill";
	ITEM.description = "A high ridged helm covered in runic emblems and sigils of the Gore-Glazic, with a split-coif design. A sign of the ultimate position a man of the Watch could attain."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 80
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.50; -- reduces blunt damage by 50%
	ITEM.pierceScale = 0.50; -- reduces pierce damage by 50%
	ITEM.slashScale = 0.50; -- reduces slash damage by 50%
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.35; -- reduces stability damage by 65%
	ITEM.insulation = 70; -- Adds 4% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Low Ministry Hat"
	ITEM.model = "models/begotten_apocalypse/items/clerichat.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/clerichat.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "ministryhat"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 7
	ITEM.headSuffix = "_hill";
	ITEM.description = "A linen coif with a wide-brimmed hat, dyed white. It protects the head from snow endemic to the North."
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";	
	ITEM.requireFaction = {"Holy Hierarchy"};
	
	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 30
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%	
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 55; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Low Ministry Scowling Helm" -- Fine Gatekeeper Helmet equivalent
	ITEM.model = "models/begotten_apocalypse/items/clerichelmet.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/clerichelmet.png"
	ITEM.weight = 1.5
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/clerichelmet.mdl";
	ITEM.description = "A scowling depiction of Saint Ragnar, an imposing face meant to strike fear into the heathen. It's grimace bear the sight of death and jubilation at the cleansing of the Hill's Forests; and, to the unfaithful, a scathing reminder of the complex majesty of the Gore-Glazic face. It is newly wrought to serve the new mysteries expounded by the Castigators in their fight against the dark."
	ITEM.requireFaction = {"Holy Hierarchy"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";
	ITEM.uniqueID = "ministryhelmet"

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 65
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 50; -- Adds 7% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 4000};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Foppish Hat"
	ITEM.model = "models/begotten_apocalypse/items/foulevil.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/foulevil.png"
	ITEM.weight = 4
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/foulevil.mdl";
	ITEM.description = "A churlish, foolish fucking thing. Those who dare to put it on will perhaps be rewarded greatly."
	ITEM.useSound = "jester/Vocaroo_04_Jan_2024_14_07_47_EST_1oLT9syHRyTq.ogg";
	
	ITEM.attributes = {"conditionless", "not_unequippable", "whimsy"};

	ITEM.conditionScale = 0

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 25
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%	
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 60; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
	
	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		Schema:EasyText(player, "peru", "This hat cannot be taken off... What the fuck?!");
		return false;
	end
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Orvilmet"
	ITEM.model = "models/begotten_apocalypse/items/wicked.mdl"
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/wicked.png"
	ITEM.weight = 0.4
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 8
	ITEM.headSuffix = "_hill";
	ITEM.description = "A beat-up depiction of a chicken. Something about this feels quite off."
	ITEM.useSound = "npc/headcrab/headbite.wav";	

	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 40
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%	
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 55; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.attributes = {"not_unequippable", "whimsy"};

	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
	
	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		Schema:EasyText(player, "peru", "Try as you might, you simply can't rip this off your head!");
		return false;
	end
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Northern Orthodoxist Ceremonial Helm"
	ITEM.model = "models/begotten/headgroups_props/anglo_helmet_world.mdl"
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/anglo_helmet_world.png"
	ITEM.weight = 2.5
	ITEM.uniqueID = "northern_orthodoxist_ceremonial_helm"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/sutton_hoo.mdl";
	ITEM.description = "A fine steel helm with elegant inlays. It boasts wealth, yet the wearer is a hateful soul. This infamous attire is associated with the Great Northern Orthodoxy, a band of fanatics who have pillaged and murdered pilgrims in the North in the name of atonement. It appears to be protected by a judgemental aura that brings great unease to sinners."
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/skullhelm";
	
	ITEM.attributes = {"fear"};
	ITEM.requiredbeliefs = {"repentant"};
	ITEM.kinisgerOverride = true;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 85
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
	ITEM.insulation = 50; -- Adds 8% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hillkeeper Helm"
	ITEM.model = "models/begotten_apocalypse/items/helmet1.mdl"
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/helmet1.png"
	ITEM.weight = 1
	ITEM.uniqueID = "hillkeeper_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 9
	ITEM.headSuffix = "_hill";
	ITEM.description = "An iron and leather helm used by men of the Hill. It protects well against the elements."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";
	
	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.80; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 35; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Armored Fur Helmet"
	ITEM.model = "models/begotten_apocalypse/items/armoredfurhelmet.mdl"
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/armoredfurhelmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "armored_fur_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 10
	ITEM.headSuffix = "_hill";
	ITEM.description = "A metal and leather helmet heavily cushioned with furs. Provides excellent protection and keeps you warm."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 50
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.80; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 65; -- Adds 10% insulation. Helmets account for 20% of total insulation. Body armor covers the other 80%.
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather", "iron_chunks"}};
ITEM:Register();