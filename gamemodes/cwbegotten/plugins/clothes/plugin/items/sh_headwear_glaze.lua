local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gatekeeper Helmet"
	ITEM.model = "models/begotten/headgroup_props/headgroup_gatekeeper_medhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gatekeeper_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "gatekeeper_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_glaze";
	ITEM.description = "An iron helmet mass-produced in an ancient era, now commonly used by the Holy Order of the Gatekeepers."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gatekeeperhelmet";
	ITEM.faction = "Gatekeeper";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 52
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.85; -- reduces bullet damage by 15%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 30;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Helm of Atonement"
	ITEM.model = "models/begotten/headgroups_props/sol_bellhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/helm_of_atonement.png"
	ITEM.weight = 3.5
	ITEM.uniqueID = "helm_of_atonement"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/sol_bellhelm.mdl";
	ITEM.description = "A holy iron bell to be permanently fitted around a flagellant's head. Once a technique of torture and humiliation; the bell would be repeatedly struck, deafening and disorienting the victim. Now the Orthodoxy wears this helm willingly, striking fear into the hearts of the sane."
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/genericmask";
	
	ITEM.attributes = {"conditionless", "not_unequippable", "deathknell", "fear"};
	ITEM.requiredbeliefs = {"repentant"};
	ITEM.kinisgerOverride = true;
	ITEM.permanent = true;

	ITEM.conditionScale = 0
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 82
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Helm of Repentance"
	ITEM.model = "models/begotten/headgroups_props/sol_ironcladhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/helm_of_repentance.png"
	ITEM.weight = 3.5
	ITEM.uniqueID = "helm_of_repentance"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/sol_ironcladhelm.mdl";
	ITEM.description = "An ironclad torture device that is bolted into the flayed faces of the accused. Inside the helm are various bloodied screws that can be further tightened to increase agony. It is now used by the flagellants of the Orthodoxy, who wear this torturous instrument to ensure their continued suffering."
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/genericmask";
	
	ITEM.attributes = {"conditionless", "not_unequippable", "bloodtoll", "fear"};
	ITEM.requiredbeliefs = {"repentant"};
	ITEM.kinisgerOverride = true;
	ITEM.permanent = true;

	ITEM.conditionScale = 0

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 87
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.insulation = 30;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Old Soldier Helm"
	ITEM.model = "models/begotten/headgroups_props/morion.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/old_soldier_helm.png"
	ITEM.weight = 1
	ITEM.uniqueID = "old_soldier_helm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 8
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A rusty iron helmet that was famous in its time as the symbol of Lord Maximus' conquests, and perhaps even in times before that. Its sloping surfaces provide excellent protection by deflecting blows."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 2000};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Wanderer Crude Plate Helm"
	ITEM.model = "models/begotten/headgroups_props/crudeplate_helmet.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/crude_plate_helm.png"
	ITEM.weight = 1.5
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/crudeplate_helmet.mdl";
	ITEM.description = "A crudely constructed steel helmet, its design obviously inspired by older Empire of Light designs."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/crudeplatehelmet";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	ITEM.insulation = 40;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 4000};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hood"
	ITEM.model = "models/begotten/headgroup_props/headgroup_wanderer_hood.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hood.png"
	ITEM.weight = 0.4
	ITEM.uniqueID = "hood"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A ragged hood commonly worn by those who inhabit the Wasteland to protect themselves from the elements."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 300, bNoSupercrate = true};	
	ITEM.conditionScale = 2 -- item degrades 2x faster with damage related condition loss
	ITEM.repairCostModifier = 0.2;
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 8
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 40;
		
	ITEM.components = {breakdownType = "breakdown", items = {"cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Masked Hood"
	ITEM.model = "models/begotten/headgroup_props/headgroup_wanderer_hood2.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hood_mask.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "hood_mask"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A ragged hood and bandana commonly worn by those who inhabit the Wasteland to protect themselves from the elements."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 800, bNoSupercrate = true};
	ITEM.conditionScale = 2 -- item degrades 2x faster with damage related condition loss
	ITEM.repairCostModifier = 0.2;
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 12
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 60;
	
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Skintape Mask"
	ITEM.model = "models/begotten/headgroups_props/skintape_helmet.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skintape_mask.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "skintape_mask"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/skintape_helmet.mdl";
	ITEM.description = "The horrifying creation of a twisted mind, this mask is made from the face of a cannibalized victim. Although it has very little protective value, it is sure to strike fear into the hearts of the wearer's future meals."
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.conditionScale = 2 -- item degrades 2x faster with damage related condition loss
	ITEM.repairCostModifier = 0.2;
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 18;
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	ITEM.insulation = 40;
		
	ITEM.attributes = {"fear"};
	ITEM.components = {breakdownType = "breakdown", items = {"skingauze", "skintape", "skintape", "cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "County District Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_01.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_1.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_1"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A tall leather watchtower hat embroidered with the markings of the Second Inquisition."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 350, bNoSupercrate = true};
	
	ITEM.insulation = 20;
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Inquisitorial Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_02.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_2.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_2"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A slouch hat used by some members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Inquisitorial Hat (Black)"
	ITEM.model = "models/begotten/headgroups_props/headgroup_emp_witch_hunter_hat_02_black.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_2_black.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_2_black"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A slouch hat used by some members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Inquisitorial Hat (White)"
	ITEM.model = "models/begotten/headgroups_props/headgroup_emp_witch_hunter_hat_02_white.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_2_white.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_2_white"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 8
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A slouch hat used by some members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Exquisite County District Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_03.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_3.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_3"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_glaze";
	ITEM.description = "An ornate watchtower hat used by distinguished members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Exquisite County District Hat (Black)"
	ITEM.model = "models/begotten/headgroups_props/headgroup_emp_witch_hunter_hat_03_black.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_3_black.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_3_black"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 7
	ITEM.headSuffix = "_glaze";
	ITEM.description = "An ornate watchtower hat used by distinguished members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Exquisite County District Hat (White)"
	ITEM.model = "models/begotten/headgroups_props/headgroup_emp_witch_hunter_hat_03_white.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_3_white.png"
	ITEM.weight = 0.3
	ITEM.uniqueID = "inquisitor_hat_3_white"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 9
	ITEM.headSuffix = "_glaze";
	ITEM.description = "An ornate watchtower hat used by distinguished members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.insulation = 20;
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Scrap Helmet"
	ITEM.model = "models/begotten/headgroup_props/scrapperhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_helmet.png"
	ITEM.weight = 1
	ITEM.uniqueID = "scrap_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A makeshift helmet made of various scrap found from the Wasteland."
	ITEM.excludeSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/scraphelmet";
	
	ITEM.conditionScale = 1 -- item degrades 1x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 35
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.insulation = 45;
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Wanderer Cap"
	ITEM.model = "models/begotten/headgroup_props/wanderercap.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/wanderer_cap.png"
	ITEM.weight = 0.4
	ITEM.uniqueID = "wanderer_cap"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A leather hood used in past times as a coif by Knights of Sol, but now more commonly used by Wanderers."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
	ITEM.conditionScale = 1.1 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;
	
	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 30
	ITEM.hitParticle = "GlassImpact";
	ITEM.type = "leather";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
	ITEM.slashScale = 0.90; -- reduces slash damage by 10%
	ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Mail Coif"
	ITEM.model = "models/begotten/headgroup_props/mailcoif.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/mail_coif.png"
	ITEM.weight = 1
	ITEM.uniqueID = "mail_coif"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A chainmail coif that provides some protection to the sides of the face."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 1 -- item degrades 1x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 45
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "chainmail";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 30;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Plate Helmet & Mail Coif"
	ITEM.model = "models/begotten/headgroup_props/platehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/plate_helmet_mail_coif.png"
	ITEM.weight = 2
	ITEM.uniqueID = "plate_helmet_mail_coif"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 5
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "An iron helmet atop a mail coif. It provides good protection except for the face."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0.75 -- item degrades 0.5x faster with damage related condition loss
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
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 40;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Spangenhelm"
	ITEM.model = "models/begotten/headgroups_props/spangenhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spangenhelm.png"
	ITEM.weight = 2
	ITEM.uniqueID = "spangenhelm"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 7
	ITEM.headSuffix = "_wanderer";
	ITEM.description = "A reinforced steel helmet with a nose guard, noted for its ease of production relative to its effectiveness."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0.75 -- item degrades 0.5x faster with damage related condition loss
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
	ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 45;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Fine Gatekeeper Helmet"
	ITEM.model = "models/begotten/headgroup_props/gatekeeperfinehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_gatekeeper_helmet.png"
	ITEM.weight = 2
	ITEM.uniqueID = "fine_gatekeeper_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 5
	ITEM.headSuffix = "_glaze";
	ITEM.description = "A more robust variant of the Gatekeeper Helmet made with fine steel."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gatekeeperhelmet";
	ITEM.faction = "Gatekeeper";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
	ITEM.insulation = 30;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Ornate Gatekeeper Helmet"
	ITEM.model = "models/begotten/items/gatekeeper_ornatehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ornate_gatekeeper_helmet.png"
	ITEM.weight = 2
	ITEM.uniqueID = "ornate_gatekeeper_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 10
	ITEM.headSuffix = "_glaze";
	ITEM.description = "An expertly crafted maximilian steel helmet. It is adorned with a glorious plume which denotes rank and status among the Gatekeeper Legion. Catalysts prevent anyone who opposes the Light to wear this."
	ITEM.requireFaith = {"Faith of the Light"};
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/gatekeeperhelmet";
	ITEM.faction = "Gatekeeper";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "cloth"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Knight Helmet"
	ITEM.model = "models/begotten/headgroups_props/knight_helmet.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/knight_plate_helmet.png"
	ITEM.weight = 2
	ITEM.uniqueID = "knight_helmet"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/knight_helmet.mdl";
	ITEM.description = "A Gothic helmet for use with the rest of a Knight's armor."
	ITEM.requireFaction = {"Holy Hierarchy"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/knighthelmet";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 72
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.60; -- reduces slash damage by 40%
	ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
	ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Knight Justicar Helmet"
	ITEM.model = "models/begotten/headgroups_props/knight_justicar_helmet.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/knight_justicar_plate_helmet.png"
	ITEM.weight = 2
	ITEM.uniqueID = "knight_justicar_helmet"
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/knight_justicar_helmet.mdl";
	ITEM.description = "Elite blackened steel adorned with the colors of a noble household."
	ITEM.requireFaction = {"Holy Hierarchy"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/knighthelmet";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss
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
	ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Scrapper Machinist Plate Helmet"
	ITEM.model = "models/begotten/headgroups_props/scraphead.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/scrap_gasmask.png"
	ITEM.weight = 3.5
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/scraphead.mdl";
	ITEM.description = "A burdensome scrap metal contraption to be fitted uncomfortably around one's skull. It has been painted with sigils supposedly meant to instill the wearer with power."
	ITEM.excludeSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/machinistplatehelmet";

	ITEM.conditionScale = 1 -- item degrades 1x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 55
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.75; -- reduces pierce damage by 25%
	ITEM.slashScale = 0.65; -- reduces slash damage by 35%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 35;
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "scrap", "scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Scrapper Smog Priest Helmet"
	ITEM.model = "models/begotten/headgroups_props/scrapperhelmet.mdl"
	ITEM.iconoverride = "begotten/ui/itemicons/scrapface.png"
	ITEM.weight = 2.5
	ITEM.category = "Helms"
	ITEM.headReplacement = "models/begotten/heads/scrapface.mdl";
	ITEM.description = "A bolted rusty steel plate helm and gasmask cowled under a leather hood. An exhaust pipe feeds the holy fumes of diesel into the wearer's lungs."
	ITEM.excludeSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Crast", "Clan Grock"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/new/smogpriesthelmet";

	ITEM.conditionScale = 0.85 -- item degrades 1x faster with damage related condition loss
	ITEM.repairCostModifier = 0.5;

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 55
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
	ITEM.slashScale = 0.70; -- reduces slash damage by 30%
	ITEM.bulletScale = 0.65; -- reduces bullet damage by 35%
	ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
	ITEM.insulation = 50;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "leather", "cloth", "scrap", "scrap", "scrap"}};
ITEM:Register();
