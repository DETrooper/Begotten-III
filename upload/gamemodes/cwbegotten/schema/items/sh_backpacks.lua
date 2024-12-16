local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Small Backpack";
	ITEM.uniqueID = "backpack_small";
	ITEM.model = "models/fallout 3/backpack_1.mdl";
	ITEM.weight = 1;
	ITEM.invSpace = 8;
	ITEM.description = "An old, small backpack of Glazic manufacture that has somehow survived the wear of time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetAngles = Angle(90, 104, 5);
	ITEM.attachmentOffsetVector = Vector(-2, 3.54, -1.41);
	ITEM.attachmentShieldOffset = Vector(1, -0.5, 1);
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 600, bNoSupercrate = true};
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth", "cloth"}};
	ITEM.excludeFactions = {"Goreic Warrior"};
ITEM:Register();

local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Backpack";
	ITEM.uniqueID = "backpack";
	ITEM.model = "models/fallout 3/backpack_2.mdl";
	ITEM.weight = 2;
	ITEM.invSpace = 10;
	ITEM.description = "An old, medium-sized backpack of Glazic manufacture that has somehow survived the wear of time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetAngles = Angle(90, 101, 0);
	ITEM.attachmentOffsetVector = Vector(-2, 5, -1);
	ITEM.attachmentShieldOffset = Vector(1, -0.5, 1);
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 800};
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth", "cloth", "cloth"}};
	ITEM.excludeFactions = {"Goreic Warrior"};
ITEM:Register();

local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Backpack w/ Pouches";
	ITEM.uniqueID = "backpack_pouches";
	ITEM.model = "models/fallout 3/backpack_3.mdl";
	ITEM.weight = 3;
	ITEM.invSpace = 13;
	ITEM.description = "A medium-sized backpack with an assortment of pouches, it can probably fit a lot inside of it.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetAngles = Angle(90, 110, 0);
	ITEM.attachmentOffsetVector = Vector(-2, 9, -4);
	ITEM.attachmentShieldOffset = Vector(1, -0.5, 1);
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 1200};
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth", "cloth", "cloth", "cloth"}};
	ITEM.excludeFactions = {"Goreic Warrior"};
ITEM:Register();

local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Survivalist Backpack";
	ITEM.uniqueID = "backpack_survivalist";
	ITEM.model = "models/fallout 3/backpack_6.mdl";
	ITEM.weight = 4;
	ITEM.invSpace = 18;
	ITEM.description = "A large backpack with a huge amount of storage space.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetAngles = Angle(90, 101, 0);
	ITEM.attachmentOffsetVector = Vector(-2, 7.07, -2.83);
	ITEM.attachmentShieldOffset = Vector(1, -0.5, 1);
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 1500};
	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth", "cloth", "cloth", "cloth", "leather", "leather"}};
	ITEM.excludeFactions = {"Goreic Warrior"};
ITEM:Register();

local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Pouch";
	ITEM.uniqueID = "backpack_pouch";
	ITEM.model = "models/props_junk/garbage_bag001a.mdl";
	ITEM.weight = 0.5;
	ITEM.invSpace = 5;
	ITEM.description = "A small crafted pouch ideal for holding small things.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetAngles = Angle(270, 0, 180);
	ITEM.attachmentOffsetVector = Vector(0, 1.4, -7.5);
	ITEM.attachmentShieldOffset = Vector(1, -0.5, 1);
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 250, bNoSupercrate = true};
	ITEM.components = {breakdownType = "breakdown", items = {"cloth"}};
ITEM:Register();

local ITEM = Clockwork.item:New("backpack_base");
	ITEM.name = "Gore Pouch";
	ITEM.uniqueID = "gore_pouch";
	ITEM.model = "models/mosi/fallout4/props/junk/hidebundle.mdl";
	ITEM.weight = 3;
	ITEM.invSpace = 13;
	ITEM.description = "A pouch crafted using the hide of animals, it can fit a reasonable amount of stuff inside.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png"
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine4";
	ITEM.attachmentOffsetVector = Vector(0, -1.2, -6.36);
	ITEM.attachmentOffsetAngles = Angle(273.48, 164.09, 268);
	ITEM.attachmentShieldOffset = Vector(0, 5.5, 4);

	ITEM.components = {breakdownType = "breakdown", items = {"hide", "leather"}};
ITEM:Register();