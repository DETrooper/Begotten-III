local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Javelin";
	ITEM.model = "models/demonssouls/weapons/cut javelin.mdl";
	ITEM.weight = 3.5;
	ITEM.uniqueID = "begotten_javelin_iron_javelin";
	ITEM.category = "Javelins";
	ITEM.description = "A robust iron javelin that excels in neutralizing shields.";
	ITEM.iconoverride = "begotten/ui/itemicons/iron_javelin.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(273.48, 178.01, 191.93);
	ITEM.attachmentOffsetVector = Vector(-6.36, 2.1, -16.27);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2000};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pilum";
	ITEM.model = "models/props/begotten/melee/heide_lance.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_javelin_pilum";
	ITEM.category = "Javelins";
	ITEM.description = "An ancient design, revived by learned members of the Holy Hierarchy for use amongst the Gatekeepers. It is famed for its armor-piercing and anti-shield capability.";
	ITEM.iconoverride = "begotten/ui/itemicons/pilum.png"
	ITEM.isAttachment = true;
	ITEM.isJavelin = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(170.06, 187.96, 181.99);
	ITEM.attachmentOffsetVector = Vector(0, 2.9, 0);	
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood"}}; -- use "breakdown" for other type
ITEM:Register();