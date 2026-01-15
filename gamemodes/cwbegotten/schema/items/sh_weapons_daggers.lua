local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Elegant Dagger";
	ITEM.model = "models/demonssouls/weapons/geri's geristiletto.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_elegantdagger";
	ITEM.category = "Melee";
	ITEM.description = "An elegant dagger of ancient manufacture, likely a prized relic from the Holy Hierarchy's collection.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/elegant_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 355.03, 0);
	ITEM.attachmentOffsetVector = Vector(-3.54, 0.71, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3; -- Affects speed of skinning and mutilating corpses as well as the condition of the hides and meat, 1 = terrible, 3 = great
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 666, supercrateOnly = true};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Hunting Dagger";
	ITEM.model = "models/demonssouls/weapons/secret dagger.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_gorehuntingdagger";
	ITEM.category = "Melee";
	ITEM.description = "An engraved iron dagger used for ceremonial hunts in the Goreic Forest.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_hunting_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(353.04, 86.52, 14.21);
	ITEM.attachmentOffsetVector = Vector(-3.54, 1.41, -2.12);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Clan Reaver Dagger";
	ITEM.model = "models/props_sr_weapons/ebony_dagger.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_clanreaverdagger";
	ITEM.category = "Melee";
	ITEM.description = "A ceremonial dagger of Clan Reaver designed for the torture and ritual killings of slaves in the Hall of Tears. The special runes of Clan Reaver open bloody wounds on the hands of those who were not born under the hateful glare of the Sister.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/Ebony_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(1.11, 180, 1.11);
	ITEM.attachmentOffsetVector = Vector(-3.433, 0.71, -3);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;
	
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2220, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
	ITEM.repairCostModifier = 0.3;
	ITEM.requiredSubfactions = {"Clan Reaver"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Dagger";
	ITEM.model = "models/demonssouls/weapons/dagger.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_irondagger";
	ITEM.category = "Melee";
	ITEM.description = "A cheaply made iron dagger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 355.03, 0);
	ITEM.attachmentOffsetVector = Vector(-3.54, 0.71, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 900, bNoSupercrate = true};
	ITEM.repairCostModifier = 0.8;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Bone Dagger";
	ITEM.model = "models/begotten/weapons/bonedagger.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "begotten_dagger_bonedagger";
	ITEM.category = "Melee";
	ITEM.description = "A sharpened bone, likely used by primeval savages.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bonedagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 355.03, 0);
	ITEM.attachmentOffsetVector = Vector(-3.54, 0.71, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 1;
	
	ITEM.components = {breakdownType = "breakdown", items = {"human_bone"}};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Knightsbane";
	ITEM.model = "models/demonssouls/weapons/mail breaker.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_knightsbane";
	ITEM.category = "Melee";
	ITEM.description = "A well-made dagger designed to puncture through armor at close range.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/knightsbane.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(335.14, 355.03, 0);
	ITEM.attachmentOffsetVector = Vector(-2.83, 1.69, -3.71);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 900, supercrateOnly = true};
	ITEM.repairCostModifier = 0.8;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Parrying Dagger";
	ITEM.model = "models/demonssouls/weapons/parrying dagger.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_parryingdagger";
	ITEM.category = "Melee";
	ITEM.description = "A small dagger designed to catch enemy blades and assist in parrying them.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/parrying_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasIncreasedDeflectionWindow = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(329.17, 355.03, 4.97);
	ITEM.attachmentOffsetVector = Vector(-2.83, 2.12, -3.54);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 550, supercrateOnly = true};
	ITEM.repairCostModifier = 0.8;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Quickshank";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/switchblade.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "begotten_dagger_quickshank";
	ITEM.category = "Melee";
	ITEM.description = "A rusty shiv, constructed of thrown together scrap found in the wasteland.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/quickshank.png"
	ITEM.meleeWeapon = true;
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 1;
	
	ITEM.attributes = {"concealable"};
	ITEM.components = {breakdownType = "breakdown", items = {"scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 100, bNoSupercrate = true};
	ITEM.repairCostModifier = 0.4;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "House Rekh-khet-sa Ancestral Dagger";
	ITEM.model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_houserekhkhetsaancestraldagger";
	ITEM.category = "Melee";
	ITEM.description = "A serpentine dagger belonging to an ancient bloodline. The metal makes a hissing sound when exposed to sunlight. A twisted magic prevents anyone not of the correct bloodline from wielding this dagger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/rekh_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(252.95, 2.98, 0.95);
	ITEM.attachmentOffsetVector = Vector(-3.54, 2, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2500, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	ITEM.requiredFaiths = {"Faith of the Dark"};
	ITEM.requiredSubfactions = {"Rekh-khet-sa"};
	ITEM.requiredFactions = {"Children of Satan"};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "House Varazdat Ancestral Dagger";
	ITEM.model = "models/items/weapons/daggers_shadow/daggers_shadow.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_housevarazdatancestraldagger";
	ITEM.category = "Melee";
	ITEM.description = "A Darklander dagger once used by a cult of flesh-eaters. A twisted magic prevents anyone not of the correct bloodline from wielding this dagger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/varazdat_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(252.95, 2.98, 0.95);
	ITEM.attachmentOffsetVector = Vector(-3.54, 2, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2500, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	ITEM.requiredFaiths = {"Faith of the Dark"};
	ITEM.requiredSubfactions = {"Varazdat"};
	ITEM.requiredFactions = {"Children of Satan"};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "House Philimaxio Ancestral Dagger";
	ITEM.model = "models/items/weapons/daggers/daggers.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_housephilimaxioancestraldagger";
	ITEM.category = "Melee";
	ITEM.description = "A Glazic nobleman's dagger that has fallen to temptation. A twisted magic prevents anyone not of the correct bloodline from wielding this dagger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/philimaxio_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(249.16, 2.84, 2.84);
	ITEM.attachmentOffsetVector = Vector(-3.54, 2.12, 1.41);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2500, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	ITEM.requiredFaiths = {"Faith of the Dark"};
	ITEM.requiredSubfactions = {"Philimaxio"};
	ITEM.requiredFactions = {"Children of Satan"};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "House Kinisger Ancestral Dagger";
	ITEM.model = "models/items/weapons/daggers_collector/daggers_collector.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_housekinisgerancestraldagger";
	ITEM.category = "Melee";
	ITEM.description = "A blackhat assassin's tool of murder. It has likely claimed many lives, from serfs to Emperors. A twisted magic prevents anyone not of the correct bloodline from wielding this dagger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/kinisger_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 3000, supercrateOnly = true};
	
	ITEM.attributes = {"concealable"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}};
	ITEM.requiredFaiths = {"Faith of the Dark"};
	ITEM.requiredSubfactions = {"Kinisger"};
	ITEM.requiredFactions = {"Children of Satan"};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hill Dagger";
	ITEM.model = "models/begotten_apocalypse/items/GuardDagger.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_hilldagger";
	ITEM.category = "Melee";
	ITEM.description = "A hunting blade made to skin and flay animals. The hilt has Gore-Glazic runes on it.";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/guarddagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(353.04, 179.05, 14.21);
	ITEM.attachmentOffsetVector = Vector(-3.54, 1.41, -2.12);
	ITEM.canUseOffhand = true;
	ITEM.huntingValue = 3;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.repairCostModifier = 0.3;
ITEM:Register();