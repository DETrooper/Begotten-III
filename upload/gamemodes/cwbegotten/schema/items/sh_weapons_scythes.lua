local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Glaive";
	ITEM.model = "models/demonssouls/weapons/war scythe.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_scythe_glaive";
	ITEM.category = "Melee";
	ITEM.description = "A sharp blade attached to the end of a long pole, it could easily eviscerate anyone caught in its range.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/glaive.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isPolearm = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(88.51, 0, 351.05);
	ITEM.attachmentOffsetVector = Vector(1.41, 3, -9.9);

	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 850, supercrateOnly = true};
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood", "wood"}}; -- use "breakdown" for other type
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "War Scythe";
	ITEM.model = "models/props/begotten/melee/scythe.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_scythe_warscythe";
	ITEM.category = "Melee";
	ITEM.description = "A serf's tool for toiling turned into a weapon. A sight not uncommon in the Field of Tears, a land where slaves would work their bodies until death, and upon death their souls would continue to work forever more. This weapon is haunted by such souls, and it produces a mournful aura that would reduce any man to tears if prolonged.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/war_scythe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isPolearm = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(186.63, 194.21, 355.03);
	ITEM.attachmentOffsetVector = Vector(5.66, 1.5, -23.34);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 2000, bNoSupercrate = true};
ITEM:Register();
