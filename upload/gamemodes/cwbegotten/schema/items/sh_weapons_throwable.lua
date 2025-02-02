local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Javelin";
	ITEM.model = "models/demonssouls/weapons/cut javelin.mdl";
	ITEM.weight = 2.3;
	ITEM.uniqueID = "begotten_javelin_iron_javelin";
	ITEM.category = "Throwables";
	ITEM.description = "A robust iron javelin that excels in impaling foes.";
	ITEM.iconoverride = "begotten/ui/itemicons/iron_javelin.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(273.48, 178.01, 191.93);
	ITEM.attachmentOffsetVector = Vector(-6.36, 2.1, -16.27);
	ITEM.canUseShields = true;
	ITEM.fireplaceFuel = 120;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2000};
	ITEM.repairCostModifier = 0.25;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pilum";
	ITEM.model = "models/props/begotten/melee/heide_lance.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_javelin_pilum";
	ITEM.category = "Throwables";
	ITEM.description = "An ancient design, revived by learned members of the Holy Hierarchy for use amongst the Gatekeepers. It is famed for its armor-piercing and anti-shield capabilities.";
	ITEM.iconoverride = "begotten/ui/itemicons/pilum.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(170.06, 187.96, 181.99);
	ITEM.attachmentOffsetVector = Vector(0, 2.9, 0);
	ITEM.canUseShields = true;
	ITEM.fireplaceFuel = 120;
	
	ITEM.attributes = {"malleable", "shieldbreaker"};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.repairCostModifier = 0.25;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Training Javelin";
	ITEM.model = "models/begotten/weapons/training_spear.mdl";
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_javelin_training_javelin";
	ITEM.category = "Throwables";
	ITEM.description = "A wooden pole that can be used for low-risk javelin throwing training.";
	ITEM.iconoverride = "begotten/ui/itemicons/training_javelin.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 279.45, 0);
	ITEM.attachmentOffsetVector = Vector(-4.24, 3, -24.75);
	ITEM.canUseShields = true;
	ITEM.fireplaceFuel = 120;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
	ITEM.repairCostModifier = 0.25;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Throwing Axe";
	ITEM.model = "models/demonssouls/weapons/cut throwing axe offset.mdl";
	ITEM.weight = 0.8;
	ITEM.uniqueID = "begotten_javelin_throwing_axe";
	ITEM.category = "Throwables";
	ITEM.description = "An axe with a curved handle made for one purpose: to sink into flesh.";
	ITEM.iconoverride = "begotten/ui/itemicons/throwing_axe.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 258.63, 0);
	ITEM.attachmentOffsetVector = Vector(7.78, 0.71, -4.24);
	ITEM.canUseShields = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.repairCostModifier = 0.25;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Throwing Dagger";
	ITEM.model = "models/demonssouls/weapons/cut throwing dagger offset.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "begotten_javelin_throwing_dagger";
	ITEM.category = "Throwables";
	ITEM.description = "A weighted blade affixed to a lightweight wooden grip. It can be quickly thrown with relative ease, allowing a prospective assassin to unleash a barrage of daggers in a short time.";
	ITEM.iconoverride = "begotten/ui/itemicons/throwing_dagger.png"
	ITEM.isJavelin = true;
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"concealable"};
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}}; -- use "breakdown" for other type
	ITEM.repairCostModifier = 0.1;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hillkeeper Throwing Axe";
	ITEM.model = "models/begotten_apocalypse/items/WinterholdAxe Thrown.mdl";
	ITEM.weight = 1.2;
	ITEM.uniqueID = "begotten_javelin_axehill";
	ITEM.category = "Throwables";
	ITEM.description = "An axehead of Gore-Glaze making on an oddly-curved and twisted wooden haft. It's shape is made for throwing.";
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/WinterholdAxe.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.canUseShields = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 258.63, 0);
	ITEM.attachmentOffsetVector = Vector(7.78, 0.71, -4.24);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.repairCostModifier = 0.25;
ITEM:Register();