local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Elegant Epee";
	ITEM.model = "models/demonssouls/weapons/epee rapier.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_rapier_elegantepee";
	ITEM.category = "Melee";
	ITEM.description = "An expertly crafted Maximillian steel blade with an elegant golden hilt. It bears the engravings of a long forgotten Glazic Noble household.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/elegant_epee.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(8.95, 4.97, 38.78);
	ITEM.attachmentOffsetVector = Vector(2.12, 4.95, -1.41);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 900, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Rapier";
	ITEM.model = "models/demonssouls/weapons/rapier.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "begotten_rapier_ironrapier";
	ITEM.category = "Melee";
	ITEM.description = "A well-crafted and nimble weapon. It is exceptionally light and balanced, with a sharp and deadly point.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_rapier.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(0, 0, 16.91);
	ITEM.attachmentOffsetVector = Vector(3.5, 1, 1.68);
	ITEM.shields = {"shield1", "shield2", "shield3", "shield4", "shield5", "shield6", "shield7", "shield8", "shield9", "shield10", "shield11", "shield12", "shield13", "shield14"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 500};
ITEM:Register();