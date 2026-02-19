local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Club";
	ITEM.model = "models/demonssouls/weapons/club.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "begotten_2h_great_club";
	ITEM.category = "Melee";
	ITEM.description = "A simple and brutish weapon, a wooden club. It is just as capable of cracking skulls now as it was ten thousand years ago.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/club.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 14.92, 0);
	ITEM.attachmentOffsetVector = Vector(-2.83, 4.95, -10.61);
	ITEM.fireplaceFuel = 180;
	
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "wood", "wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 300, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Steel Longsword";
	ITEM.model = "models/begotten/weapons/templarsword.mdl";
	ITEM.skin = 2;
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_exileknightsword";
	ITEM.category = "Melee";
	ITEM.description = "A darkened fine steel longsword of Glazic design. Once infamously used by exiled Knights of the Holy Hierarchy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/exile_knight_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(172.04, 74.59, 261.55);
	ITEM.attachmentOffsetVector = Vector(8.49, 1.9, 26.87);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "steel_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Inquisitor Sword";
	ITEM.model = "models/demonssouls/weapons/blueblood sword.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_inquisitorsword";
	ITEM.category = "Melee";
	ITEM.description = "The legendary swords of the Second Inquisition. Easily identified by their star-shaped hilts, these weapons are forged from only the finest steel. They carry holy judgement, much to the dismay of witches and Glazic nobility alike.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(92.49, 183.98, 10.94);
	ITEM.attachmentOffsetVector = Vector(-0.71, 2.69, 3.54);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Longsword";
	ITEM.model = "models/demonssouls/weapons/long sword.mdl";
	ITEM.skin = 2;
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_longsword";
	ITEM.category = "Melee";
	ITEM.description = "A formidable iron longsword formerly used in the ranks of the Gatekeepers.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/longsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(280, 180, 10.94);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.4, 16.51);	
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 7000, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pickaxe";
	ITEM.model = "models/begotten/weapons/serfpickaxe.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_great_pickaxe";
	ITEM.category = "Melee";
	ITEM.description = "A mining tool designed to crush rock, it can easily crush armor and flesh as well.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pickaxe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(280, 268.11, 140.22);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2.12, 8.49);
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "iron_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 225, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Sledge";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/sledgehammer.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_sledge";
	ITEM.category = "Melee";
	ITEM.description = "A great heavy sledgehammer that can be used to crush skulls.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/sledge.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(269.5, 267, 174.03);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2, -16.27);
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "iron_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 425, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Voltsledge";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/sledgehammer.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_great_voltsledge";
	ITEM.category = "Melee";
	ITEM.description = "A sledgehammer that has been fitted with unholy gizmos that amplify its electrical might.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/voltsledge.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(269.5, 267, 174.03);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2, -16.27);
	ITEM.bodygroup1 = 3;
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "tech", "wood"}};
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Training Longsword";
	ITEM.model = "models/begotten/weapons/training_2h.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_2h_traininglongsword";
	ITEM.category = "Melee";
	ITEM.description = "A wooden longsword that can be used for low-risk two-handed combat training.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/training_longsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(360, 76.57, 92.49);
	ITEM.attachmentOffsetVector = Vector(-4.24, 2.83, 14.85);
	ITEM.fireplaceFuel = 120;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Unholy Sigil Sword";
	ITEM.model = "models/props/begotten/melee/smelter_sword.mdl";
	ITEM.skin = 2;
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_2h_unholysigilsword";
	ITEM.category = "Melee";
	ITEM.description = "A scarred black iron sigil sword forged in the fires of hell. Its iron unnerves you; dark whispers compel you to empower it with unholy energy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/unholy_sigil_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 185.97, 92.49);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2.83, -35.36);
	ITEM.attachmentSkin = 2;

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1250, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}};
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requiredFaiths = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Quarterstaff";
	ITEM.model = "models/begotten/weapons/quarterstaff.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_2h_quarterstaff";
	ITEM.category = "Melee";
	ITEM.description = "A wooden staff to be used as a combat implement.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/quarterstaff.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(183.98, 100.44, 130.28);
	ITEM.attachmentOffsetVector = Vector(-1.41, 3, 4.24);
	ITEM.fireplaceFuel = 180;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Longsword";
	ITEM.model = "models/skyrim/draugr/greatsword/w_draugrgreatsword.mdl";
	ITEM.weight = 2.6;
	ITEM.uniqueID = "begotten_2h_sataniclongsword";
	ITEM.category = "Melee";
	ITEM.description = "A black steel sword of twisted design. It excels at taking heads and various other limbs with skillful cleaves.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanic_longsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(187.96, 63.47, 0.95);
	ITEM.attachmentOffsetVector = Vector(5.66, 3, 16.51);
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredFaiths = {"Faith of the Dark"};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1000, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "The Samurai Sword";
	ITEM.model = "models/demonssouls/weapons/blueblood sword.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_eventsword";
	ITEM.category = "Melee";
	ITEM.description = "A fucking torch, or a bat, or the noose, or the rat.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/inquisitor_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = false;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(92.49, 183.98, 10.94);
	ITEM.attachmentOffsetVector = Vector(-0.71, 2.69, 3.54);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Gore Falx";
	ITEM.model = "models/begotten/goreweapons/falx2.mdl";
	ITEM.weight = 3.5;
	ITEM.uniqueID = "begotten_2h_great_falx";
	ITEM.category = "Melee";
	ITEM.description = "A steel blade curved inwards for penetrating power. It can punch holes in metal and bone with each devastating strike. The handle of this weapon is engraved with Goreic runes that burns the hands of weaklings.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/falx.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(6.46, 273.48, 90);
	ITEM.attachmentOffsetVector = Vector(0, 2.9, 9.09);
	
	ITEM.attributes = {"shieldbreaker"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1000, supercrateOnly = true};
	ITEM.requiredFaiths = {"Faith of the Family"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Skyfallen Sword";
	ITEM.model = "models/bloodborne/weapons/skyfeller.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_skyfallensword";
	ITEM.category = "Melee";
	ITEM.description = "Skylight supersteel reforged with familial runes and masterwork smithing. A sword befitting a King.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skyfallen_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(360, 281.37, 84.32);
	ITEM.attachmentOffsetVector = Vector(5.66, 3.4, 14.14);	
	
	ITEM.requiredFaiths = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Voltlongsword";
	ITEM.model = "models/begotten/weapons/shishkebab.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_voltlongsword";
	ITEM.category = "Melee";
	ITEM.description = "A long scrap blade attached to a crude contraption with an internal battery.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_longsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(280, 180, 10.94);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.4, 16.51);	
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "scrap", "scrap", "tech", "tech", "tech", "tech"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hill Yeoman Longsword";
	ITEM.model = "models/begotten_apocalypse/items/IronClaymore.mdl";
	ITEM.skin = 2;
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_2h_hilllongsword";
	ITEM.category = "Melee";
	ITEM.description = "A staple of landowners in the north alongside the venerable musket; a sign of wealth. The blade is adorned with Gore-Glazic runes.";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/IronClaymore.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(280, 180, 191.93);
	ITEM.attachmentOffsetVector = Vector(3.54, 4.95, 16.97);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
ITEM:Register();