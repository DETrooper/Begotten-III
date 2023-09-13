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
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 200};
	ITEM.requiredbeliefs = {"defender"};	
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Clan Shield";
	ITEM.model = "models/begotten/weapons/goreroundshield.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "shield14";
	ITEM.description = "A sturdy shield made from abnormally strong wood from the Gore Forest. It is decorated in Goreic clan sigils.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/clan_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(360, 309.28, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 0);
	
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood", "wood", "wood"}};
	ITEM.requireFaction = {"Goreic Warrior"};
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
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 800, supercrateOnly = true};
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Gatekeeper Shield";
	ITEM.model = "models/props/begotten/melee/twin_dragon_greatshield.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "shield11";
	ITEM.description = "A well-crafted Tower Shield bearing an inscribed depiction of the Glaze.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gatekeeper_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 0);
	ITEM.attachmentOffsetVector = Vector(0, 0, 0);
	ITEM.excludeFactions = {"Goreic Warrior"};
	
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
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 800};
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
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.requiredbeliefs = {"manifesto"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Scrap Shield";
	ITEM.model = "models/props_debris/metal_panel02a.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "shield1";
	ITEM.description = "A shield made of sheet metal, decorated by various fetishes depicting the wearer's faith.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_shield.png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 265.52, 180.15);
	ITEM.attachmentOffsetVector = Vector(0, 3.54, -4.95);
	
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "scrap", "scrap", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 600, bNoSupercrate = true};
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
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 65};
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
	
	ITEM.attributes = {"unbreakable"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 800, supercrateOnly = true};
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
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "steel_chunks", "steel_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 800, supercrateOnly = true};
	ITEM.requireFaith = {"Faith of the Dark"};
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
	
	ITEM.itemSpawnerInfo = {category = "Shields", rarity = 650, bNoSupercrate = true};
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood", "wood", "wood"}};
ITEM:Register();