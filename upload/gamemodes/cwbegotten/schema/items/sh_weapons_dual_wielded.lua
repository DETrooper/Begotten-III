local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dual Shards";
	ITEM.model = "models/items/weapons/sword_souldrinker/dual_shards.mdl";
	ITEM.weight = 2.7;
	ITEM.uniqueID = "begotten_dual_shards";
	ITEM.category = "Melee";
	ITEM.description = "Twin hellforged blades empowered by demonic energy. Skilled bladesmen use these to dance through battlefields, expertly flencing flesh with each sadistic twirl and flick of magestic glowing shard.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dual_shards.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(6, 0, 178.01);
	ITEM.attachmentOffsetVector = Vector(-5.66, 3, 16.97);

	ITEM.components = {breakdownType = "breakdown", items = {"begotten_1h_shard", "begotten_1h_shard"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform", "witch_druid"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Axe & Falchion";
	ITEM.model = "models/begotten/weapons/axeandfalchion.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_dual_goreaxe_gorefalchion";
	ITEM.category = "Melee";
	ITEM.description = "An iron falchion of Goreic origin and an accompanying handaxe. Only a particularly skilled berzerker could unleash these blades with efficiency.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_axe_falchion.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 267.51, 0);
	ITEM.attachmentOffsetVector = Vector(0, 3, -11.31);
	
	ITEM.components = {breakdownType = "breakdown", items = {"begotten_1h_reaverbattleaxe", "begotten_1h_gorefalchion"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform", "witch_druid"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dual Axes";
	ITEM.model = "models/begotten/weapons/dual_axes1.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_dual_axes";
	ITEM.category = "Melee";
	ITEM.description = "Twin axes joined together for the mutual interest of slaughter. The iconic choice of a Gore berzerker.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dual_axes.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 271.49, 0);
	ITEM.attachmentOffsetVector = Vector(0, 3, 4.38);
	
	ITEM.components = {breakdownType = "breakdown", items = {"begotten_1h_gorebattleaxe", "begotten_1h_gorebattleaxe"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform", "witch_druid"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dual Scimitars";
	ITEM.model = "models/begotten/weapons/dual_scimitars.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "begotten_dual_scimitars";
	ITEM.category = "Melee";
	ITEM.description = "An iconic duo of Darklander steel, typically used by the skilled swordmasters from the Far East.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dual_scimitars.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 271.49, 183.98);
	ITEM.attachmentOffsetVector = Vector(0, 3, 1.41);
	
	ITEM.components = {breakdownType = "breakdown", items = {"begotten_1h_scimitar", "begotten_1h_scimitar"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform", "witch_druid"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dual Scrap Blades";
	ITEM.model = "models/begotten/weapons/dual_shishkebab.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_dual_scrapblades";
	ITEM.category = "Melee";
	ITEM.description = "Two Scrapper blades for double the murder.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dual_shishkebab.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 271.49, 183.98);
	ITEM.attachmentOffsetVector = Vector(-0.5, 2.5, -3.54);
	
	ITEM.components = {breakdownType = "breakdown", items = {"begotten_1h_scrapblade", "begotten_1h_scrapblade"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform", "witch_druid"};
ITEM:Register();