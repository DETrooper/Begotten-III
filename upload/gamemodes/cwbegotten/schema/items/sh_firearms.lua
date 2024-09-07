--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Blunderbuss";
	ITEM.model = "models/arxweapon/ashot.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "begotten_blunderbuss";
	ITEM.description = "A clunky metal and wood weapon that can suprisingly withstand the power of pure Grapeshot. It unleashes hell all around you.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blunderbuss.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
	ITEM.attachmentOffsetAngles = Angle(0, 342, 6.96);
	ITEM.attachmentOffsetVector = Vector(0.71, 3, 7.07);

	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Grapeshot"};
	ITEM.firearmType = "Shotgun";
	ITEM.reloadTime = 10; -- Seconds
	ITEM.reloadSounds = {"musket/reload_musket01.wav", "musket/reload_musket02.wav", "musket/reload_musket03.wav", "musket/reload_musket04.wav", "musket/reload_musket05.wav", "musket/reload_musket06.wav", "musket/reload_musket07.wav", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 800, supercrateItems = {["grapeshot"] = {min = 10, max = 20}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Colt";
	ITEM.model = "models/weapons/doi/w_1911.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_colt";
	ITEM.description = "An impossible find! A working antique pistol from an age long past. It uses old world shot and can put fucklets down with ease.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/colt.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(68.62, 4.97, 355.03);
	ITEM.attachmentOffsetVector = Vector(-4.95, -4.24, 0.71);
	
	ITEM.ammoCapacity = 7;
	ITEM.ammoTypes = {"Old World Shot", "Old World Magazine"};
	ITEM.ammoTypesNice = {"Old World Shot"};
	ITEM.firearmType = "Handgun";
	ITEM.reloadTime = 5; -- Seconds (for magazine)
	ITEM.reloadSounds = {"weapons/m1911/handling/m1911_magrelease.wav", "weapons/m1911/handling/m1911_magout.wav", "weapons/m1911/handling/m1911_magin.wav", "weapons/m1911/handling/m1911_maghit.wav", "weapons/m1911/handling/m1911_boltback.wav", "weapons/m1911/handling/m1911_boltrelease.wav"};
	ITEM.usesMagazine = true;
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 2500, supercrateOnly = true, supercrateItems = {["old_world_magazine"] = {min = 2, max = 3}, ["old_world_shot"] = {min = 7, max = 14}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Corpsecrank";
	ITEM.model = "models/weapons/w_shot_enforcer.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_corpsecrank";
	ITEM.description = "A full metal machine that pops Grapeshot one crank at a time. A weapon of war designed to mass produce a valuable product: corpses.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsecrank.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(2, 2.84, 0);
	ITEM.attachmentOffsetVector = Vector(-4, 3.54, -6.36);
	
	ITEM.ammoCapacity = 6;
	ITEM.ammoTypes = {"Grapeshot"};
	ITEM.firearmType = "Repeating Shotgun";
	ITEM.isRevolver = true;
	ITEM.reloadTime = 2; -- Seconds (for one round)
	ITEM.reloadSounds = {"weapons/bulkcannon/draw.wav", "weapons/bulkcannon/insertshell.wav", "weapons/bulkcannon/lock.wav"};
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 2000, supercrateOnly = true, supercrateItems = {["grapeshot"] = {min = 15, max = 30}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Wooden Crossbow";
	ITEM.uniqueID = "begotten_crossbow";
	ITEM.category = "Crossbows";
	ITEM.model = "models/begotten/weapons/w_crossbow.mdl";
	ITEM.weight = 3.5;
	ITEM.description = "Commonly employed by poorly trained levies from the county districts, the crossbow is an ancient design long pre-dating the Empire of Light. It launches bolts at high speeds and features a locking mechanism so that a draw does not need to be maintained, though it still requires considerable strength to reload.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/crossbow.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 354.15, 0);
	ITEM.attachmentOffsetVector = Vector(-3.23, 1.39, -6.36);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Iron Bolt", "Scrap Bolt"};
	ITEM.attributes = {"variable_damage"};
	ITEM.firearmType = "Crossbow";
	ITEM.reloadTime = 5; -- Seconds (for one round)
	ITEM.reloadSounds = {"weapons/bulkcannon/draw.wav", "weapons/crossbow/bow-pre1.wav.mp3", "weapons/crossbow/bowgun-stance.wav.mp3"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 1650, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Scrap Crossbow";
	ITEM.uniqueID = "begotten_scrapbow";
	ITEM.category = "Crossbows";
	ITEM.model = "models/begotten/weapons/w_scrapbow.mdl";
	ITEM.weight = 4;
	ITEM.description = "A crossbow constructed from scrap metal and rotting wood.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrapbow.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 354.15, 0);
	ITEM.attachmentOffsetVector = Vector(-3.23, 1.39, -6.36);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Iron Bolt", "Scrap Bolt"};
	ITEM.attributes = {"variable_damage"};
	ITEM.firearmType = "Crossbow";
	ITEM.reloadTime = 8; -- Seconds (for one round)
	ITEM.reloadSounds = {"weapons/bulkcannon/draw.wav", "weapons/crossbow/bow-pre1.wav.mp3", "weapons/crossbow/bowgun-stance.wav.mp3"};
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Inquisitor Revolver";
	ITEM.model = "models/arxweapon/hellsing.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_inquisitor_revolver";
	ITEM.description = "A lighter variant of the repeating musket that fires Pop-a-Shot caliber rounds, commonly used by the Inquisition.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_revolver.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 339.12, 177.16);
	ITEM.attachmentOffsetVector = Vector(-5.66, 3.54, 9.19);	
	ITEM.bodygroup2 = 9;
	ITEM.bodygroup3 = 2;
	
	ITEM.ammoCapacity = 8;
	ITEM.ammoTypes = {"Pop-a-Shot"};
	ITEM.firearmType = "Repeater";
	ITEM.isRevolver = true;
	ITEM.reloadTime = 10; -- Seconds (for one round)
	ITEM.reloadSounds = {"musket/reload_musket01.wav", "musket/reload_musket02.wav", "musket/reload_musket03.wav", "musket/reload_musket04.wav", "musket/reload_musket05.wav", "musket/reload_musket06.wav", "musket/reload_musket07.wav", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Musket";
	ITEM.model = "models/weapons/w_snip_ele.mdl";
	ITEM.weight = 2
	ITEM.uniqueID = "begotten_musket";
	ITEM.description = "A long rusted pipe that can load large shots. A revered weapon of the County Districts.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/musket.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 355.03, 357.02);
	ITEM.attachmentOffsetVector = Vector(-2.83, 2.83, -7.78);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Longshot", "Grapeshot"};
	ITEM.firearmType = "Long Gun";
	ITEM.reloadTime = 10; -- Seconds
	ITEM.reloadSounds = {"musket/reload_musket01.wav", "musket/reload_musket02.wav", "musket/reload_musket03.wav", "musket/reload_musket04.wav", "musket/reload_musket05.wav", "musket/reload_musket06.wav", "musket/reload_musket07.wav", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 900, supercrateItems = {["longshot"] = {min = 10, max = 15}, ["grapeshot"] = {min = 3, max = 5}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Peppershot";
	ITEM.model = "models/weapons/w_pist_piper.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_peppershot";
	ITEM.description = "A pistol constructed of various scrap materials.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/peppershot.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(68.62, 0, 357.02);
	ITEM.attachmentOffsetVector = Vector(-4.24, 0, -5.66);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Pop-a-Shot", "Grapeshot"};
	ITEM.firearmType = "Handgun";
	ITEM.reloadTime = 10; -- Seconds
	ITEM.reloadSounds = {"musket/reload_musket01.wav", "musket/reload_musket02.wav", "musket/reload_musket03.wav", "musket/reload_musket04.wav", "musket/reload_musket05.wav", "musket/reload_musket06.wav", "musket/reload_musket07.wav", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 600, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Repeating Musket";
	ITEM.model = "models/weapons/w_bulkcannon.mdl";
	ITEM.weight = 3.5;
	ITEM.uniqueID = "begotten_musket_repeating";
	ITEM.description = "This weapon was originally created for the express purpose of executing demons, wielded only by a Grand Magistrate. In these darker times, it serves many additional purposes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repeating_musket.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 351.47, 90);
	ITEM.attachmentOffsetVector = Vector(-2.12, 3.54, -0.71);
	
	ITEM.ammoCapacity = 7;
	ITEM.ammoTypes = {"Longshot", "Grapeshot"};
	ITEM.firearmType = "Repeater";
	ITEM.isRevolver = true;
	ITEM.reloadTime = 10; -- Seconds (for one round)
	ITEM.reloadSounds = {"musket/reload_musket01.wav", "musket/reload_musket02.wav", "musket/reload_musket03.wav", "musket/reload_musket04.wav", "musket/reload_musket05.wav", "musket/reload_musket06.wav", "musket/reload_musket07.wav", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 1500, supercrateOnly = true, supercrateItems = {["longshot"] = {min = 10, max = 20}, ["grapeshot"] = {min = 5, max = 10}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Scavenger Gun";
	ITEM.model = "models/weapons/v_smg_mothgun.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_scavenger_gun";
	ITEM.description = "A worn out hand-made machine gun, it barely seems to be functioning. A rare find indeed.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 353.04, 357.02);
	ITEM.attachmentOffsetVector = Vector(-2.83, 2.83, -7.78);
	
	ITEM.ammoCapacity = 25;
	ITEM.ammoTypes = {"Scrapshot", "Scavenger Gun Magazine", "Scavenger Gun Large Magazine"};
	ITEM.ammoTypesNice = {"Scrapshot"};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "scrap", "scrap", "scrap"}};
	ITEM.firearmType = "Carbine";
	ITEM.reloadTime = 5; -- Seconds (for magazine)
	ITEM.reloadSounds = {"weapons/bulkcannon/draw.wav", "weapons/m1911/handling/m1911_boltback.wav", "weapons/m1911/handling/m1911_magout.wav", "weapons/m1911/handling/m1911_magin.wav", "weapons/m1911/handling/m1911_maghit.wav", "weapons/m1911/handling/m1911_boltrelease.wav"};
	ITEM.usesMagazine = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 1200, supercrateItems = {["scavenger_gun_large_magazine"] = {min = 2, max = 5}, ["scrapshot"] = {min = 15, max = 30}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Springer";
	ITEM.model = "models/weapons/w_snip_m1903.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_springer";
	ITEM.description = "An ancient high-powered rifle, pre-dating even the Empire of Light. It is powerful enough to kill almost anyone with one shot, though ammunition is scarce. It is common for those who acquire this weapon to have hitmen hired to take it from them.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/springer.png"
	ITEM.isAttachment = true;
	ITEM.loweredOrigin = Vector(39.50, -28.45, -20.17);
	ITEM.loweredAngles = Angle(39.50, -28.45, -20.17);
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
	ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
	ITEM.attachmentOffsetVector = Vector(-4, 4, 4);
	
	ITEM.ammoCapacity = 5;
	ITEM.ammoTypes = {"Old World Longshot"};
	ITEM.ammoTypesNice = {"Old World Longshot"};
	ITEM.attributes = {"sundering_shot"};
	ITEM.firearmType = "Rifle";
	ITEM.reloadTime = 5; -- Seconds
	ITEM.reloadSounds = {"weapons/request day of defeat/m1903 springfield boltback 1.wav", "weapons/request day of defeat/m1903 springfield clipin.wav", "weapons/request day of defeat/m1903 springfield boltforward 2.wav"};
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 5000, supercrateOnly = true, supercrateItems = {["old_world_longshot"] = {min = 10, max = 20}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Sweeper";
	ITEM.model = "models/weapons/w_nik_trenchy.mdl";
	ITEM.weight = 3.6;
	ITEM.uniqueID = "begotten_sweeper";
	ITEM.description = "An old machine of war, operated by pump and fed by Old World Grapeshot. It has seen much use over the years.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/sweeper.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(2, 2.84, 0);
	ITEM.attachmentOffsetVector = Vector(-4, 3.54, -6.36);
	
	ITEM.ammoCapacity = 6;
	ITEM.ammoTypes = {"Old World Grapeshot"};
	ITEM.attributes = {"sundering_shot_grapeshot"};
	ITEM.firearmType = "Repeating Shotgun";
	ITEM.reloadTime = 1; -- Seconds (for one round)
	ITEM.reloadSounds = {"weapons/nikm1987trench/shotgun_shell_00.wav"};
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 5000, supercrateOnly = true, supercrateItems = {["old_world_grapeshot"] = {min = 10, max = 20}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Thompson";
	ITEM.model = "models/_tails_ models/props/rust/thompson/thompson.mdl";
	ITEM.weight = 4.5;
	ITEM.uniqueID = "begotten_thompson";
	ITEM.description = "An ancient automatic submachinegun even pre-dating the Empire of Light. It appears to have been looted from an ancient museum and restored to working order with spare parts.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/thompson.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 347.07, 266.21);
	ITEM.attachmentOffsetVector = Vector(-1.41, 3.3, 2.83);
	
	ITEM.ammoCapacity = 30;
	ITEM.ammoTypes = {"Old World Shot", "Old World Large Magazine"};
	ITEM.ammoTypesNice = {"Old World Shot"};
	ITEM.firearmType = "Submachinegun";
	ITEM.reloadTime = 5; -- Seconds (for magazine)
	ITEM.reloadSounds = {"weapons/m1911/handling/m1911_magrelease.wav", "weapons/m1911/handling/m1911_magout.wav", "weapons/m1911/handling/m1911_magin.wav", "weapons/m1911/handling/m1911_maghit.wav", "weapons/m1911/handling/m1911_boltback.wav", "weapons/m1911/handling/m1911_boltrelease.wav"};
	ITEM.usesMagazine = true;
	ITEM.unrepairable = true;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 5000, supercrateOnly = true, supercrateItems = {["old_world_large_magazine"] = {min = 2, max = 3}, ["old_world_shot"] = {min = 20, max = 30}}};
ITEM:Register();

local ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Voltist Railgun";
	ITEM.model = "models/arxweapon/railgun.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_voltist_railgun";
	ITEM.description = "A makeshift electrically charged railgun of Voltist manufacture. It hurls heavy projectiles vast distances and excels at piercing armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/voltist_railgun.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 337.13, 0);
	ITEM.attachmentOffsetVector = Vector(1.01, 3.54, -7.78);
	 
	ITEM.bodygroup1 = 9
	ITEM.bodygroup2 = 1

	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Volt Projectile"};
	ITEM.firearmType = "Railgun";
	ITEM.reloadTime = 10; -- Seconds
	ITEM.reloadSounds = {"weapons/bulkcannon/draw.wav", "weapons/request day of defeat/m1903 springfield draw.wav", "weapons/request day of defeat/m1903 springfield boltback 1.wav", "weapons/m1911/handling/m1911_boltback.wav", "weapons/CB4/cb4-1_trigger.wav", "railgun/railgun_empty_sparks.mp3", "railgun/railgun_1s_recharge.mp3"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"tech", "tech", "scrap", "scrap", "scrap", "scrap", "wood"}};
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Jezail";
	ITEM.model = "models/sw_battlefront/weapons/jezail_short.mdl";
	ITEM.weight = 2
	ITEM.uniqueID = "begotten_jezail_short";
	ITEM.description = "A Darklander musket. It is fitted with a scope for more accurate fire. A blood red engraving burns the hand of anyone who does not follow the darkness.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/jezail_short.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 343.09, 90);
	ITEM.attachmentOffsetVector = Vector(3.54, 3.54, -9.9);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Longshot", "Pop-a-Shot"};
	ITEM.firearmType = "Long Gun";
	ITEM.reloadTime = 8; -- Seconds
	ITEM.reloadSounds = {"oneuse_deploy.ogg"};
	ITEM.requireFaith = {"Faith of the Dark"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"wood", "steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();

ITEM = Clockwork.item:New("firearm_base");
	ITEM.name = "Jezail Rifle";
	ITEM.model = "models/sw_battlefront/weapons/jazail_long.mdl";
	ITEM.weight = 6
	ITEM.uniqueID = "begotten_jezail_long";
	ITEM.description = "A Darklander rifle, infamously used by the Nigerii Janissaries. It is fitted with a scope for more accurate fire. Its barrel been elongated and rifled, making it excellent for sharpshooting. A blood red engraving burns the hand of anyone who does not follow the darkness.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/jazail_long.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 343.09, 90);
	ITEM.attachmentOffsetVector = Vector(3.54, 3.54, -9.9);
	
	ITEM.ammoCapacity = 1;
	ITEM.ammoTypes = {"Longshot"};
	ITEM.firearmType = "Long Gun";
	ITEM.reloadTime = 9; -- Seconds
	ITEM.reloadSounds = {"oneuse_deploy.ogg", "musket/reload_musket08.wav", "musket/reload_musket_cock.wav"};
	ITEM.requireFaith = {"Faith of the Dark"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"wood", "fine_steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();