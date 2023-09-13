local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Bat";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl";
	ITEM.skin = 3;
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_bat";
	ITEM.category = "Melee";
	ITEM.description = "A simple wooden bat.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bat.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(4.24, -1.41, 31.12);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 75};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Spiked Bat";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl";
	ITEM.skin = 3;
	ITEM.bodygroup1 = 6;
	ITEM.bodygroup2 = 2;
	ITEM.weight = 1.1;
	ITEM.uniqueID = "begotten_1h_spikedbat";
	ITEM.category = "Melee";
	ITEM.description = "A wooden bat with nails hammered in for added brutality.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spiked_bat.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(4.24, -1.41, 31.12);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Bladed Bat";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/baseballbat.mdl";
	ITEM.skin = 3;
	ITEM.bodygroup1 = 10;
	ITEM.bodygroup2 = 2;
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_bladedbat";
	ITEM.category = "Melee";
	ITEM.description = "A wooden bat that has been fitted with dual sawblades. It is now a primitive slashing weapon.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bladed_bat.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(4.24, -1.41, 31.12);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Battle Axe";
	ITEM.model = "models/demonssouls/weapons/battle axe.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_1h_battleaxe";
	ITEM.category = "Melee";
	ITEM.description = "A bulky black iron double-sided axe. A crude weapon for crude men.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/battle_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(20.88, 0, 180);
	ITEM.attachmentOffsetVector = Vector(3.54, 1.41, 26.87);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Board";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/board.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_board";
	ITEM.category = "Melee";
	ITEM.description = "A wooden board, a common implement of war in the Wasteland.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/board.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(291.38, 269.5, 156.13);
	ITEM.attachmentOffsetVector = Vector(1.41, 2.83, -27.58);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 50};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Spiked Board";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/board.mdl";
	ITEM.bodygroup1 = 2;
	ITEM.weight = 1.1;
	ITEM.uniqueID = "begotten_1h_spikedboard";
	ITEM.category = "Melee";
	ITEM.description = "A wooden board with nails hammered in for added brutality.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spiked_board.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(291.38, 269.5, 156.13);
	ITEM.attachmentOffsetVector = Vector(1.41, 2.83, -27.58);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Bladed Board";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/board.mdl";
	ITEM.bodygroup1 = 4;
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_bladedboard";
	ITEM.category = "Melee";
	ITEM.description = "A wooden board that has been fitted with dual sawblades. It is now a primitive slashing weapon.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bladed_board.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(291.38, 269.5, 156.13);
	ITEM.attachmentOffsetVector = Vector(1.41, 2.83, -27.58);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Broken Sword";
	ITEM.model = "models/demonssouls/weapons/broken sword.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_1h_brokensword";
	ITEM.category = "Melee";
	ITEM.description = "A horrible excuse for a sword, rusted almost beyond use and with its blade broken in half. Something is better than nothing, however...";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/broken_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(14.92, 0, 20.88);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 50};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Voltsword";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/chineeseofficersword.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_1h_voltsword";
	ITEM.category = "Melee";
	ITEM.description = "An ancient military sword that has been fitted with voltist prongs and pylons. It is capable of dealing considerable damage to armored fools, if you're capable of handling it without electrifying yourself.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/voltsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(279.47, 285.16, 264.32);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, -6.36);
	ITEM.bodygroup1 = 5;
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "scrap", "scrap", "tech"}};
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Voltprod";
	ITEM.model = "models/newvegasprops/voltprod.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_voltprod";
	ITEM.category = "Melee";
	ITEM.description = "A prod that was once used on cattle, now re-charged with technoheretical gizmos to deliver near fatal electrifying blows to the flesh-afflicted who unrightfully seek protection from metal plate.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_prod.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 4.97, 189.94);
	ITEM.attachmentOffsetVector = Vector(3.54, 2.12, 4.95);
	ITEM.bodygroup1 = 5;
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "scrap", "scrap", "tech", "tech"}};
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Druid Sword";
	ITEM.model = "models/begotten/weapons/sword1.mdl";
	ITEM.weight = 0.7;
	ITEM.uniqueID = "begotten_1h_druidsword";
	ITEM.category = "Melee";
	ITEM.description = "A crude iron blade engraved with various Goreic glyphs.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/druid_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(294.63, 288.95, 0);
	ITEM.attachmentOffsetVector = Vector(2.83, 3, 0);	
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Familial Sword";
	ITEM.model = "models/begotten/weapons/sword2_unique.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_familialsword";
	ITEM.category = "Melee";
	ITEM.description = "A finely crafted steel shortsword made in honor of the Family.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/familial_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(98.45, 252.95, 18.9);
	ITEM.attachmentOffsetVector = Vector(3.54, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Flanged Mace";
	ITEM.model = "models/demonssouls/weapons/mace.mdl";	
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_flangedmace";
	ITEM.category = "Melee";
	ITEM.description = "A heavy steel mace with a spike at its end. Expertly designed to pierce armor, no matter its resilience.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/flanged_mace.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 180, 349.06);
	ITEM.attachmentOffsetVector = Vector(3.71, -3.54, 27.58);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Glazicus";
	ITEM.model = "models/demonssouls/weapons/broad sword.mdl";
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_1h_glazicus";
	ITEM.category = "Melee";
	ITEM.description = "A common Glazic shortsword made from a cheap iron.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/glazicus.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(14.92, 0, 20.88);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	--ITEM.itemSpawnerInfo = {category = "Melee", rarity = 400, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Shortsword";
	ITEM.model = "models/aoc_weapon/w_shortsword_evil.mdl";
	ITEM.weight = 0.7;
	ITEM.uniqueID = "begotten_1h_satanicshortsword";
	ITEM.category = "Melee";
	ITEM.description = "A hellish shortsword that expresses the supremacy of bloody expression. It is exceptionally nimble, and capable of piercing armor with deadly close range successive thrust attacks.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanicshortsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(285.41, 225.75, 0);
	ITEM.attachmentOffsetVector = Vector(3, 1.41, 2.12);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Battle Axe";
	ITEM.model = "models/begotten/weapons/axe1.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_gorebattleaxe";
	ITEM.category = "Melee";
	ITEM.description = "A well crafted battle axe. The markings of Clan Gore are carved into its handle.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_battle_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(94.48, 68.62, 180);
	ITEM.attachmentOffsetVector = Vector(3.54, -2, 22.63);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Falchion";
	ITEM.model = "models/begotten/weapons/sword4.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_gorefalchion";
	ITEM.category = "Melee";
	ITEM.description = "A steel chopping blade on a finely carved Goreic hilt. A warrior's weapon, excellent for its ability to hack off limbs.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_falchion.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(98.45, 252.95, 18.9);
	ITEM.attachmentOffsetVector = Vector(3.54, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Mace";
	ITEM.model = "models/begotten/weapons/mace2.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_goremace";
	ITEM.category = "Melee";
	ITEM.description = "A spiked wooden club with a heavy stone head, crude in construction yet effective in combat.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_mace.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(98.45, 80.55, 6.96);
	ITEM.attachmentOffsetVector = Vector(3.54, -0.71, 21.22);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"stone", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Seax";
	ITEM.model = "models/begotten/weapons/sword3.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_goreseax";
	ITEM.category = "Melee";
	ITEM.description = "A steel blade with a curved end, engraved with various Goreic runes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_seax.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(92.49, 255.58, 6.96);
	ITEM.attachmentOffsetVector = Vector(3.54, 1.41, 4.24);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "cloth"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Shortsword";
	ITEM.model = "models/begotten/weapons/sword2.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_goreshortsword";
	ITEM.category = "Melee";
	ITEM.description = "A short iron blade equally suited to slashing or stabbing, decorated with Goreic motifs.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_shortsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(98.45, 252.95, 18.9);
	ITEM.attachmentOffsetVector = Vector(3.54, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Arming Sword";
	ITEM.model = "models/demonssouls/weapons/knight sword.mdl";	
	ITEM.weight = 1.1;
	ITEM.uniqueID = "begotten_1h_ironarmingsword";
	ITEM.category = "Melee";
	ITEM.description = "A crudely made yet robust iron sword, equally suited to slashing or stabbing.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_arming_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(14.92, 360, 22.87);
	ITEM.attachmentOffsetVector = Vector(2.12, 5.66, -3.54);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 300, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Steel Arming Sword";
	ITEM.model = "models/aoc_weapon/sword_01_static.mdl";	
	ITEM.weight = 1.2;
	ITEM.uniqueID = "begotten_1h_steelarmingsword";
	ITEM.category = "Melee";
	ITEM.description = "A well balanced steel arming sword, equally suited to slashing or stabbing.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/steelarmingsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(110.39, 150.63, 0);
	ITEM.attachmentOffsetVector = Vector(3, 2.12, 4);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 500, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Shortsword";
	ITEM.model = "models/demonssouls/weapons/short sword.mdl";
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_1h_ironshortsword";
	ITEM.category = "Melee";
	ITEM.description = "A common shortsword made from a cheap iron.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_shortsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(14.92, 0, 20.88);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, 0);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 250, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Machete";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/machete.mdl";	
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_machete";
	ITEM.category = "Melee";
	ITEM.description = "A large rusty blade that can cut through flesh with ease.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/machete.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(289.39, 291.38, 273.48);
	ITEM.attachmentOffsetVector = Vector(2, 6.36, -4.24);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 150};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Morning Star";
	ITEM.model = "models/demonssouls/weapons/morning star.mdl";	
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_morningstar";
	ITEM.category = "Melee";
	ITEM.description = "A heavy iron ball covered in spikes, mounted on a wood and metal shaft; this weapon ascertains a deadly combination of blunt force and armor-piercing capability.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/morningstar.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 180, 349.06);
	ITEM.attachmentOffsetVector = Vector(3.71, -3.54, 27.58);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 400, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pipe";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl";
	ITEM.bodygroup1 = 1;
	ITEM.weight = 0.6;
	ITEM.uniqueID = "begotten_1h_pipe";
	ITEM.category = "Melee";
	ITEM.description = "A small but weighty section of lead pipe, perfect for use as a club.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pipe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(3.71, 0.34, 13.81);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 60};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pipe Mace";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl";
	ITEM.bodygroup1 = 2;
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_1h_pipemace";
	ITEM.category = "Melee";
	ITEM.description = "A lead pipe fitted with scrap bolts. A primitive mace, frequently used by County District peacekeeping forces and delinquents alike.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pipe_mace.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(3.71, 0.34, 13.81);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Tire Iron";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/tireiron.mdl";
	ITEM.weight = 0.6;
	ITEM.uniqueID = "begotten_1h_tireiron";
	ITEM.category = "Melee";
	ITEM.description = "An ancient tool of rusted scrap metal. It's a decent weapon for striking foes on the head.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/tireiron.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(3.71, 0.34, 13.81);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 70};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scrap Axe";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/tireiron.mdl";
	ITEM.bodygroup1 = 2;
	ITEM.weight = 0.9;
	ITEM.uniqueID = "begotten_1h_scrapaxe";
	ITEM.category = "Melee";
	ITEM.description = "A tire iron welded with a scrap axehead. A typical weapon of a Wasteland bandit.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/tire_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(100.44, 80.55, 90);
	ITEM.attachmentOffsetVector = Vector(3.71, 0.34, 13.81);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Reaver Battle Axe";
	ITEM.model = "models/begotten/weapons/axe3.mdl";
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_reaverbattleaxe";
	ITEM.category = "Melee";
	ITEM.description = "A one-handed iron battle axe with a broad head. It is commonly used by Gores of Clan Reaver for its head-taking ability.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/reaver_battle_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetVector = Vector(4.4, 0.71, 22.63);
	ITEM.attachmentOffsetAngles = Angle(303.31, 98.45, 16.91);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scimitar";
	ITEM.model = "models/demonssouls/weapons/scimitar.mdl";
	ITEM.weight = 0.9;
	ITEM.uniqueID = "begotten_1h_scimitar";
	ITEM.category = "Melee";
	ITEM.description = "A curved steel sword inspired by designs from the far eastern Darklands brought back by campaigning soldiers under Lord Maximus. This type of sword excels at cutting.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scimitar.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(187.96, 360, 335.14);
	ITEM.attachmentOffsetVector = Vector(2.83, 2.12, -0.71);	
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Warped Sword";
	ITEM.model = "models/props/begotten/melee/warped_sword.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_warpedsword";
	ITEM.category = "Melee";
	ITEM.description = "An unholy oddity of a sword. Its metal has been warped by a sadistic demon with a morbid sense of humor. It excels at carving flesh at the expense of armor-piercing.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/warped_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(283.43, 30.83, 84.53);
	ITEM.attachmentOffsetVector = Vector(2.83, 2.12, -0.71);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}};
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1000, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Twisted Club";
	ITEM.model = "models/props/begotten/melee/barbed_club.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_twistedclub";
	ITEM.category = "Melee";
	ITEM.description = "A club that has been twisted by demonic energy. It excels at punishing armored foes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/barbed_club.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(187.96, 360, 166.08);
	ITEM.attachmentOffsetVector = Vector(3.54, -0.71, 13.44);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"wrought_iron_ingot", "wood", "wood"}};
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scrap Blade";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_scrapblade";
	ITEM.category = "Melee";
	ITEM.description = "A tossed-together amalgamation of scrap metal resembling a sword. It may be more dangerous for the wielder than its intended target.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_blade.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(360, 269.5, 24.86);
	ITEM.attachmentOffsetVector = Vector(2.83, 2.83, 0.71);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 900, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hatchet";
	ITEM.model = "models/begotten/weapons/serfhatchet.mdl";
	ITEM.weight = 1.2;
	ITEM.uniqueID = "begotten_1h_hatchet";
	ITEM.category = "Melee";
	ITEM.description = "A small hatchet that excels at cutting wood. It also excels at cutting flesh...";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hatchet.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(215.05, 88.11, 31.26);
	ITEM.attachmentOffsetVector = Vector(2.83, 2.83, 3.54);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 200};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Training Sword";
	ITEM.model = "models/begotten/weapons/training_1h.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_trainingsword";
	ITEM.category = "Melee";
	ITEM.description = "A wooden sword that can be used for low-risk one-handed combat training.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/training_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(283.26, 287.4, 84.53);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, -4.24);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Twisted Machete";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/machete.mdl";	
	ITEM.weight = 0.9;
	ITEM.bodygroup2 = 3;
	ITEM.uniqueID = "begotten_1h_twistedmachete";
	ITEM.category = "Melee";
	ITEM.description = "A curved machete-like blade, used by many followers of the Dark Lord for their sacrifices.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/twisted_machete.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(289.39, 291.38, 273.48);
	ITEM.attachmentOffsetVector = Vector(2, 6.36, -4.24);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Mace";
	ITEM.model = "models/skyrim/daedric/mace/w_daedricmace.mdl";	
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_1h_satanicmace";
	ITEM.category = "Melee";
	ITEM.description = "A black steel mace of twisted design. It excels at punishing plated fools and bringing foes to heel.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanic_mace.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(118.34, 66.63, 360);
	ITEM.attachmentOffsetVector = Vector(5, -2, 13.44);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Sword";
	ITEM.model = "models/skyrim/daedric/sword/w_daedricsword.mdl";	
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_1h_satanicsword";
	ITEM.category = "Melee";
	ITEM.description = "A black steel sword of twisted design. It excels at flencing flesh and cutting bone.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanic_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(277.46, 287.4, 360);
	ITEM.attachmentOffsetVector = Vector(3.54, 2.12, 0.71);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1000, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Shard";
	ITEM.model = "models/items/weapons/sword_souldrinker/sword_souldrinker.mdl";	
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_1h_shard";
	ITEM.category = "Melee";
	ITEM.description = "A glowing shard of unholy design. It flashes red when it hungers for flesh.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/shard.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(269.5, 28.84, 347.07);
	ITEM.attachmentOffsetVector = Vector(1.41, 4.24, -1.41);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "War Hammer";
	ITEM.model = "models/begotten/weapons/warhammer.mdl";	
	ITEM.weight = 1.2;
	ITEM.uniqueID = "begotten_1h_warhammer";
	ITEM.category = "Melee";
	ITEM.description = "A steel hammerhead and spike on a wooden handle. An excellent weapon against armored foes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/warhammer.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(287.4, 102.43, 187.96);
	ITEM.attachmentOffsetVector = Vector(3.54, 0, 12.02);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood", "leather"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 300, supercrateOnly = true};
ITEM:Register();