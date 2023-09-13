local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Gatekeeper Helmet"
	ITEM.model = "models/begotten/headgroup_props/headgroup_gatekeeper_medhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gatekeeper_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "gatekeeper_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 6
	ITEM.description = "An iron helmet mass-produced in an ancient era, now commonly used by the Holy Order of the Gatekeepers."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";

	ITEM.conditionScale = 0.75 -- item degrades 1.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 55
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Hood"
	ITEM.model = "models/begotten/headgroup_props/headgroup_wanderer_hood.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hood.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "hood"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 4
	ITEM.description = "A ragged hood commonly worn by those who inhabit the Wasteland to protect themselves from the elements."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 55};
		
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
	ITEM.bodyGroupVal = 5
	ITEM.description = "A ragged hood and bandana commonly worn by those who inhabit the Wasteland to protect themselves from the elements."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 75};
		
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "County District Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_01.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_1.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "inquisitor_hat_1"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 1
	ITEM.description = "A tall leather watchtower hat embroidered with the markings of the Second Inquisition."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	ITEM.itemSpawnerInfo = {category = "Helms", rarity = 350, bNoSupercrate = true};
	
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Inquisitorial Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_02.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_2.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "inquisitor_hat_2"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 2
	ITEM.description = "A slouch hat used by some members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Exquisite County District Hat"
	ITEM.model = "models/begotten/headgroup_props/headgroup_emp_witch_hunter_hat_03.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_hat_3.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "inquisitor_hat_3"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 3
	ITEM.description = "An ornate watchtower hat used by distinguished members of the Holy Order of the Glaze's Inquisitors."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
		
	ITEM.components = {breakdownType = "breakdown", items = {"leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Scrap Helmet"
	ITEM.model = "models/begotten/headgroup_props/scrapperhelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_helmet.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "scrap_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 12
	ITEM.description = "A makeshift helmet made of various scrap found from the Wasteland."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";
	ITEM.overlay = "begotten/zomboverlay/gatekeep1";
	
	ITEM.conditionScale = 1 -- item degrades 1x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 35
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%	
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Wanderer Cap"
	ITEM.model = "models/begotten/headgroup_props/wanderercap.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/wanderer_cap.png"
	ITEM.weight = 0.5
	ITEM.uniqueID = "wanderer_cap"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 9
	ITEM.description = "A leather hood used in past times as a coif by Knights of Sol, but now more commonly used by Wanderers."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
	
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
	ITEM.bodyGroupVal = 10
	ITEM.description = "A chainmail coif that provides some protection to the sides of the face."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 1 -- item degrades 1x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 40
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "chainmail";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Plate Helmet & Mail Coif"
	ITEM.model = "models/begotten/headgroup_props/platehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/plate_helmet_mail_coif.png"
	ITEM.weight = 2
	ITEM.uniqueID = "plate_helmet_mail_coif"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 11
	ITEM.description = "An iron helmet atop a mail coif. It provides good protection except for the face."
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.useSound = "armor/plate_damage_02.wav";

	ITEM.conditionScale = 0.75 -- item degrades 0.5x faster with damage related condition loss

	ITEM.effectiveLimbs = {
		[HITGROUP_HEAD] = true,
	}

	ITEM.protection = 45
	ITEM.hitParticle = "MetalSpark";
	ITEM.type = "plate";

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "steel_chunks"}};
	
ITEM:Register();

local ITEM = Clockwork.item:New("bodygroup_base")
	ITEM.name = "Fine Gatekeeper Helmet"
	ITEM.model = "models/begotten/headgroup_props/gatekeeperfinehelm.mdl"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_gatekeeper_helmet.png"
	ITEM.weight = 1.5
	ITEM.uniqueID = "fine_gatekeeper_helmet"
	ITEM.category = "Helms"
	ITEM.bodyGroup = 1
	ITEM.bodyGroupVal = 13
	ITEM.description = "A more robust variant of the Gatekeeper Helmet made with fine steel."
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

	ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
	ITEM.pierceScale = 0.90; -- reduces pierce damage by 10%
	ITEM.slashScale = 0.75; -- reduces slash damage by 25%
	ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
	ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	
ITEM:Register();