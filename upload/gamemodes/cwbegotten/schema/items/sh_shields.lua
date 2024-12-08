local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Buckler";
	ITEM.model = "models/demonssouls/shields/buckler.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "shield4";
	ITEM.description = "For its impressive metalwork, it is clear that this offensive shield was forged by the Holy Hierarchy long ago. A weapon once infamous for its use by Glazic mercenaries and thugs, for its ability to parry hits and stun opponents.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/buckler.png"
	ITEM.isAttachment = true;
	ITEM.hasIncreasedDeflectionWindow = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(287.4, 360, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 4.95);
	ITEM.bulletConditionScale = 0.4;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Car Door Shield";
	ITEM.model = "models/props_vehicles/carparts_door01a.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "shield3";
	ITEM.description = "A heavy metal part from an ancient machine. It should only be used by the most desperate of fighters, or the strongest of warriors.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/car_door_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(355.03, 229.72, 0.99);
	ITEM.attachmentOffsetVector = Vector(0, 2.12, 5.66);
	ITEM.bulletConditionScale = 0.25;
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1600, bNoSupercrate = true};
	ITEM.requiredbeliefs = {"defender"};	
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Clan Shield";
	ITEM.model = "models/begotten/weapons/goreroundshield.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "shield14";
	ITEM.description = "A sturdy shield made from abnormally strong wood from the Gore Forest. It is decorated and protected by Goreic clan sigils.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/clan_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(360, 309.28, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 0);
	ITEM.bulletConditionScale = 0.3;
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood", "wood", "wood"}};
	ITEM.requireFaith = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Dreadshield";
	ITEM.model = "models/props/begotten/melee/drakekeeper_greatshield.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "shield13";
	ITEM.description = "A shield forged from hellfire, though it is now icy cold to the touch. Being in the mere presence of this malevolent craft brings a sense of impending doom.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dreadshield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 359.01, 0);
	ITEM.attachmentOffsetVector = Vector(0, 2.12, -4.95);
	ITEM.bulletConditionScale = 0.15;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Gatekeeper Shield";
	ITEM.model = "models/props/begotten/melee/twin_dragon_greatshield.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "shield11";
	ITEM.description = "A well-crafted tower shield bearing an inscribed depiction of the Glaze.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gatekeeper_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 0);
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Gore Guardian Shield";
	ITEM.model = "models/demonssouls/shields/large brushwood shield.mdl";
	ITEM.weight = 9;
	ITEM.uniqueID = "shield10";
	ITEM.description = "An ancient thing, created by the Blade Druids long before the would-be Gores ever set foot near the Great Tree. It now serves the protectors of the natural order from the only thing that threatens it, mankind. The metalwork of the shield becomes stronger the closer it is to its source of power, the Great Tree.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_guardian_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(88.51, 201.79, 268.11);
	ITEM.attachmentOffsetVector = Vector(0, 0.71, -4.24);
	ITEM.bulletConditionScale = 0.1;
	
	ITEM.attributes = {"unbreakable"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.requiredbeliefs = {"defender"};
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.requireFaith = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Iron Shield";
	ITEM.model = "models/demonssouls/shields/soldier's shield.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "shield6";
	ITEM.description = "Scratched and scorched, this metal shield has served many soldiers before it found you.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(98.45, 181.99, 176.02);
	ITEM.attachmentOffsetVector = Vector(0, -1.41, 0);
	ITEM.bulletConditionScale = 0.3;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 900, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Knight's Shield";
	ITEM.model = "models/demonssouls/shields/knight's shield.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "shield7";
	ITEM.description = "A shield of purified metal that has been touched by Sol. Whoever is to hold this shield must serve it as much as it serves them, for its metal will burn the hand of anyone with a heretic's heart. If a true hero of the Glaze is to wield this shield, it will ignite in a great holy flame, but that is yet to be seen by the Knights of Sol.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/knights_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90.5, 201.88, 269.5);
	ITEM.attachmentOffsetVector = Vector(0, -0.71, 0);
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.requiredbeliefs = {"manifesto"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Leather Shield";
	ITEM.model = "models/props/begotten/melee/large_leather_shield.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "shield17";
	ITEM.description = "A circular shield of wooden construction, its face covered with leather.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/leather_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(270, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, 1.6, 0);
	ITEM.bulletConditionScale = 0.45;
	
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 750, bNoSupercrate = true};
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood", "wood", "leather", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Old Soldier Shield";
	ITEM.model = "models/begotten/thralls/skellyshield.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "shield20";
	ITEM.description = "Formerly used by the foot soldiers of the Empire of Light's armies, these shields now serve a more sinister purpose.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/old_soldier_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
	ITEM.attachmentOffsetVector = Vector(0, 2, 0);
	ITEM.bulletConditionScale = 0.25;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Rusted Kite Shield";
	ITEM.model = "models/props/begotten/melee/red_rust_shield.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "shield19";
	ITEM.description = "A battered and rusted shield that has obviously seen extensive use. A previous owner has tallied their kills on its face.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/rusted_kite_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
	ITEM.attachmentOffsetVector = Vector(0, 2, 0);
	ITEM.bulletConditionScale = 0.25;
	
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2500};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "leather"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Scrap Shield";
	ITEM.model = "models/props_bebris/metal_panel02a.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "shield1";
	ITEM.description = "A shield made of sheet metal, decorated by various fetishes depicting the wearer's faith.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_shield_new.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 275, 180.15);
	ITEM.attachmentOffsetVector = Vector(0, 3, -1);
	ITEM.bulletConditionScale = 0.4;
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Slaveshield";
	ITEM.model = "models/demonssouls/shields/slave's shield.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "shield2";
	ITEM.description = "A terrible wooden shield once used by a great army of slaves.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/slaveshield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(114.36, 183.98, 181.99);
	ITEM.attachmentOffsetVector = Vector(0, 0.71, 4.24);
	ITEM.bulletConditionScale = 0.6;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 80};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Sol Sentinel Shield";
	ITEM.model = "models/demonssouls/shields/tower shield.mdl";
	ITEM.weight = 10;
	ITEM.uniqueID = "shield9";
	ITEM.description = "A great shield that found its use by the personal bodyguard of Lord Maximus himself. A massive thing, it is now used by High Gatekeepers to defend the last remaining sanctuaries of Light.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/sol_sentinel_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90.5, 158.12, 88.51);
	ITEM.attachmentOffsetVector = Vector(0, -1.41, 0);
	ITEM.bulletConditionScale = 0.1;
	
	ITEM.attributes = {"unbreakable"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
	ITEM.requiredbeliefs = {"defender"};
	ITEM.requireFaith = {"Faith of the Light"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Spiked Shield";
	ITEM.model = "models/demonssouls/shields/spiked shield.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "shield8";
	ITEM.description = "A hateful thing of twisted metal and spikes. A thing forged in Hell itself, intended for human followers of the Dark Prince to enact their bloodthirsty desires. It seems that a terrible soul is trapped inside of the metal, taking lustful pleasure from each kill brought by its user. If the wielder is to disappoint or follow some god other than Lucifer himself, the metal will twist and contort around their hands and bleed them dry with its spikes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spiked_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(74.59, 183.98, 360);
	ITEM.attachmentOffsetVector = Vector(0, 0.34, 0);
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 800, supercrateOnly = true};
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Steel Gatekeeper Shield";
	ITEM.model = "models/props/begotten/melee/tower_shield.mdl";
	ITEM.weight = 8;
	ITEM.uniqueID = "shield18";
	ITEM.description = "A masterfully-crafted steel greatshield bearing a personification of the Glaze.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/steel_gatekeeper_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
	ITEM.attachmentOffsetVector = Vector(0, 2, 0);
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.requiredbeliefs = {"defender"};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Steel Tower Shield";
	ITEM.model = "models/props/begotten/melee/pate_shield.mdl";
	ITEM.weight = 6;
	ITEM.uniqueID = "shield16";
	ITEM.description = "A tall wooden shield plated with blackened steel plates; its design incorporates elements commonly found in Darklander equipment.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/steel_tower_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 0);
	ITEM.attachmentOffsetVector = Vector(0, 2, -1);
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Voltshield";
	ITEM.model = "models/props_vebris/metal_panel02a.mdl";
	ITEM.weight = 5.5;
	ITEM.uniqueID = "shield15";
	ITEM.description = "A scrap shield augmented by a salvaged car battery that feeds electricity into the shield. Any enemy who makes contact with this shield using a metal weapon shall indeed regret it.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 275, 180.15);
	ITEM.attachmentOffsetVector = Vector(0, 9, -4.95);
	ITEM.bulletConditionScale = 0.4;
	
	ITEM.attributes = {"electrified"};
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap", "scrap", "tech"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Warfighter Shield";
	ITEM.model = "models/props/begotten/melee/pursuer_greatshield.mdl";
	ITEM.weight = 6;
	ITEM.uniqueID = "shield12";
	ITEM.description = "An extremely heavy shield forged from Blade Druid steel. Meant for the purpose of protecting Warfighters from hails of cowardly gunfire by the Glazic decievers.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/warfighter_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 0);
	ITEM.bulletConditionScale = 0.1;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "iron_chunks", "iron_chunks"}};
	ITEM.requireFaction = {"Goreic Warrior"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Wooden Shield";
	ITEM.model = "models/skyrim/shield_stormcloaks.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "shield5";
	ITEM.description = "A standard shield that can take a fair few hits.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/wooden_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(273.48, 360, 90);
	ITEM.attachmentOffsetVector = Vector(0, 1.6, 0);
	ITEM.bulletConditionScale = 0.5;
	
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600, bNoSupercrate = true};
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Red Wolf Shield";
	ITEM.model = "models/begotten/weapons/uniquegoreshield.mdl";
	ITEM.weight = 9;
	ITEM.uniqueID = "shieldunique1";
	ITEM.description = "An unholy wall of black steel forged in the fires of hell. It is adorned with the dried flesh of flayed victims. A shield meant for the Red Wolves, a twisted warrior lodge of Clan Reaver.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/red_wolf_shield.png"
	ITEM.isAttachment = true;
	ITEM.isUnique = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 360, 0);
	ITEM.attachmentOffsetVector = Vector(0, 4.24, -4.95);

	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.attributes = {"unbreakable"};
	ITEM.requiredbeliefs = {"defender"};
	ITEM.requireFaction = {"Goreic Warrior"};
	ITEM.requireSubfaction = {"Clan Reaver"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Hillkeeper Kite Shield";
	ITEM.model = "models/begotten_apocalypse/items/hill_kite_shield.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "shieldhill";
	ITEM.description = "A well-crafted teardrop shield bearing a painted depiction of Sol, painted in the Hill's colors.";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/hill_kite_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, -2.3, 0);
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Steel Hillkeeper Shield";
	ITEM.model = "models/props/begotten/melee/defender_shield.mdl";
	ITEM.weight = 8;
	ITEM.uniqueID = "shieldhillsteel";
	ITEM.description = "A finely smithed steel shield, engraved with runic imagery of Glazic warriors and heroes upon its front.";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/defender_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 180, 180);
	ITEM.attachmentOffsetVector = Vector(0, -2, 0);
	ITEM.excludeFactions = {"Goreic Warrior"};
	ITEM.bulletConditionScale = 0.2;
	
	ITEM.requiredbeliefs = {"defender"};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks"}};
ITEM:Register();