local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Claymore";
	ITEM.model = "models/demonssouls/weapons/claymore.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_2h_claymore";
	ITEM.category = "Melee";
	ITEM.description = "A steel greatsword. Its hilt is engraved with Glazic markings of a long dead noble household.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/claymore.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90.5, 180, 347.07);
	ITEM.attachmentOffsetVector = Vector(5.66, 2.9, 17.68);

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1300, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Cleaver";
	ITEM.model = "models/begotten/weapons/2h_axe3.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_2h_great_gorecleaver";
	ITEM.category = "Melee";
	ITEM.description = "A particularly heavy and brutish weapon. A weapon favored by Gore Chieftains, for its ability to instill fear and take heads.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_cleaver.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 288.9, 0);
	ITEM.attachmentOffsetVector = Vector(-4.95, 2.83, -23.34);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Club";
	ITEM.model = "models/begotten/weapons/2h_mace1.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_goreclub";
	ITEM.category = "Melee";
	ITEM.description = "A hardy wooden club cut from Goreic Forest lumber. It is reinforced with iron braces and spikes for piercing plate.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_club.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(8.95, 287.05, 0);
	ITEM.attachmentOffsetVector = Vector(-5.66, 2.12, -21.22);
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood", "wood", "wood"}};
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore War Axe";
	ITEM.model = "models/begotten/weapons/2h_axe1.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_gorewaraxe";
	ITEM.category = "Melee";
	ITEM.description = "A heavy war axe made of a crude craft. It bears the distinctive markings of Clan Gore.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_war_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(22.87, 283.43, 339.12);
	ITEM.attachmentOffsetVector = Vector(-2.12, 1.41, -17.68);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Grockling Sacred Stone Maul";
	ITEM.model = "models/begotten/weapons/2h_mace3.mdl";
	ITEM.weight = 7;
	ITEM.uniqueID = "begotten_2h_great_grocklingsacredstonemaul";
	ITEM.category = "Melee";
	ITEM.description = "A blessed runestone, carved by the original Blade Druids with ancient knowledge. To use such a weapon is considered an insult by the other Gore Clans, as it is a disgrace to the Gods. Those of Clan Grock are the only ones who would dare risk the wrath of the Gods.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/grockling_sacred_stone_maul.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 283.26, 0);
	ITEM.attachmentOffsetVector = Vector(-4.95, 3.54, -21.22);
	
	ITEM.components = {breakdownType = "breakdown", items = {"stone", "stone", "stone", "wood", "wood"}};
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.excludeSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast"};
ITEM:Register(); 

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Grockling Stone Maul";
	ITEM.model = "models/begotten/weapons/2h_mace2.mdl";
	ITEM.weight = 6.5;
	ITEM.uniqueID = "begotten_2h_great_grocklingstonemaul";
	ITEM.category = "Melee";
	ITEM.description = "A stacked set of Goreic runestones hammered onto an engraved wooden club. A weapon typically used by the godless Grocklings, for its excellence at equalizing armored foes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/grockling_stone_maul.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 287.05, 0);
	ITEM.attachmentOffsetVector = Vector(-2.12, 2.83, -17.68);
	
	ITEM.components = {breakdownType = "breakdown", items = {"stone", "stone", "stone", "stone", "wood", "wood"}};
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.excludeSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Haralder War Axe";
	ITEM.model = "models/witcher2soldiers/tw2_bigaxe.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_2h_great_haralderwaraxe";
	ITEM.category = "Melee";
	ITEM.description = "An ornate war axe made from Shagalaxian steel. This axe is often used by the sea raiders of Clan Harald. An old curse prevents weaklings from firmly grasping its handle.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/haralder_war_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 281.37);
	ITEM.attachmentOffsetVector = Vector(-5.66, 2.83, -30.41);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Heavy Battle Axe";
	ITEM.model = "models/demonssouls/weapons/battle axe.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_2h_great_heavybattleaxe";
	ITEM.category = "Melee";
	ITEM.description = "A heavy black iron axe. A crude and brutal weapon. It is unclear what dark host this weapon was made for.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/battle_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 2.84, 21.79);
	ITEM.attachmentOffsetVector = Vector(-2.83, 2.12, -12.73);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Reaver War Axe";
	ITEM.model = "models/begotten/weapons/2h_axe2.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_2h_great_reaverwaraxe";
	ITEM.category = "Melee";
	ITEM.description = "A heavy jagged axe made for the wicked sea slavers of Clan Reaver. It is likely whoever crafted this weapon did so with spite and disdain.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/reaver_war_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 283.26, 0);
	ITEM.attachmentOffsetVector = Vector(-4.95, 2.83, -26.87);
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scraphammer";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/rockethammer.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_great_scraphammer";
	ITEM.category = "Melee";
	ITEM.description = "A makeshift sledgehammer, assembled from various pieces of Wasteland scrap.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scraphammer.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 291.38, 267.51);
	ITEM.attachmentOffsetVector = Vector(-4.24, 4.24, -9.19);
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap", "scrap"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Skylight Sword";
	ITEM.model = "models/doom/weapons/templar_sword.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_skylightsword";
	ITEM.category = "Melee";
	ITEM.description = "A technologically advanced piece of equipment. The sheer level of technical brilliance that went into the perfection of this weapon's other-worldly material qualities is breathtaking to behold. A weapon able to swiftly and elegantly cleave through countless horrors yet retain its razor-sharp edge in perfect form. There are only a few of these weapons left, remnants of the glorious District One at the heart of the Holy Hierarchy itself.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skylight_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 192.32, 0);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, 13.44);
	
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Volthammer";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/rockethammer.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_2h_great_volthammer";
	ITEM.category = "Melee";
	ITEM.description = "An electrically-charged makeshift sledgehammer, used by the Voltists for its anti-armor capabilities.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volthammer.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 291.38, 267.51);
	ITEM.attachmentOffsetVector = Vector(-4.24, 4.24, -9.19);
	ITEM.bodygroup1 = 4;
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "scrap", "scrap", "scrap", "tech", "tech"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength", "wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "War Club";
	ITEM.model = "models/demonssouls/weapons/great club.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_warclub";
	ITEM.category = "Melee";
	ITEM.description = "A large wooden club reinforced with iron braces and spikes. A simplistic design that has empowered many a warlord and tyrant through the ages.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/war_club.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 12.32, 0);
	ITEM.attachmentOffsetVector = Vector(0, 3.54, -12.02);
	ITEM.fireplaceFuel = 240;
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2500, bNoSupercrate = true};
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Maul";
	ITEM.model = "models/skyrim/daedric/warhammer/w_daedricwarhammer.mdl";
	ITEM.weight = 3.2;
	ITEM.uniqueID = "begotten_2h_great_satanicmaul";
	ITEM.category = "Melee";
	ITEM.description = "A black steel maul of twisted design. It excels at pummeling lambs into the dirt, armored or not.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanic_maul.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(10.42, 275.68, 353.37);
	ITEM.attachmentOffsetVector = Vector(0.71, 2.83, -9.19);

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "breakdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Maximus Wrath";
	ITEM.model = "models/begotten/weapons/maximus_wrath.mdl";
	ITEM.weight = 2.7;
	ITEM.uniqueID = "begotten_2h_great_maximuswrath";
	ITEM.category = "Melee";
	ITEM.description = "District One Supersteel charged with advanced technology; a glorious weapon befitting a demigod. BEHOLD! The Maximus Wrath!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/maximus_wrath.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 2.5, 269.5);
	ITEM.attachmentOffsetVector = Vector(0, 6.36, 12.02);	
	
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Darklander Bardiche";
	ITEM.model = "models/demonssouls/weapons/crescent axe.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_darklanderbardiche";
	ITEM.category = "Melee";
	ITEM.description = "A large crescent axe adorned with Darklander designs. An effective pole weapon, it excels at breaking shieldwalls.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bardiche.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(92.49, 0, 10.94);
	ITEM.attachmentOffsetVector = Vector(-2.83, 3.59, -24.75);

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
	
	ITEM.attributes = {"shieldbreaker"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Evening Star";
	ITEM.model = "models/begotten/weapons/eveningstar.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_eveningstar";
	ITEM.category = "Melee";
	ITEM.description = "A black steel ball of atonement fixed upon a braced wooden pole. It is incredibly top-heavy and delivers a brutal pounding to anyone who dares attempt to block its judgement. A weapon typically made by the self-hating Orthodoxy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/eveningstar.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(345.08, 265.52, 0);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2.9, -2.83);
	
	ITEM.components = {breakdownType = "breakdown", items = {"steel_chunks", "steel_chunks", "wood", "leather"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
ITEM:Register();

-- Hill shit

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hill Long Axe";
	ITEM.model = "models/begotten_apocalypse/items/2HAxe2.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_2h_great_hilllongaxe";
	ITEM.category = "Melee";
	ITEM.description = "A modified logging axe made to reach over shield walls. The blade is sharp, and now what once cut logs now cuts flesh. The wooden shaft has been thrice-blessed and it now burns the hands of heretics.";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/2HAxe2.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetVector = Vector(0.71, 2.83, -6.36);
	ITEM.attachmentOffsetAngles = Angle(90, 2.84, 201.79);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Light"};
	ITEM.kinisgerOverride = true;
ITEM:Register();