--[[
	Begotten III: Jesus Wept
--]]

-- Tech and Technocraft have been moved to the medical plugin's items since they use the medical plugin and need to be registered after that plugin has initialized.

local ITEM = Clockwork.item:New();
	ITEM.name = "Breakdown Kit";
	ITEM.category = "Tools";
	ITEM.model = "models/mosi/fallout4/props/junk/modcrate.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "breakdown_kit";
	ITEM.description = "A kit of tools that can be used to break down items into their component pieces.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/breakdown_kit.png";
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Repair Kits", rarity = 300, bNoSupercrate = true};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cloth";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/cloth.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "cloth";
	ITEM.description = "A roll of pieced-together cloth, it can be used in the creation of clothing or bandages.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	ITEM.fireplaceFuel = 20;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 25};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Charcoal";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/begotten/misc/charcoal.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "charcoal";
	ITEM.description = "Burnt fragments of wood that can be used as a fuel source for crafting.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	ITEM.fireplaceFuel = 120;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Fertilizer";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/fertilizer.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "fertilizer";
	ITEM.description = "A jar containing sweet droppings.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 35};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Gunpowder";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props_lab/box01a.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "gunpowder";
	ITEM.description = "A box containing an explosive powdery substance that can be packed into munitions.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 95};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Wrought Iron Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/lead.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "wrought_iron_ingot";
	ITEM.description = "A low-quality ingot of iron that can be smelted to form superior metals.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Iron Chunks";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/lead.mdl";
	ITEM.weight = 0.1;
	ITEM.uniqueID = "iron_chunks";
	ITEM.description = "Melted down chunks of metal. It should be reclaimed into an ingot.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/crude_iron_ingot.png";
	ITEM.stackable = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"wrought_iron_ingot"}};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Steel Chunks";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/steel.mdl";
	ITEM.weight = 0.1;
	ITEM.uniqueID = "steel_chunks";
	ITEM.description = "Melted down chunks of metal. It should be reclaimed into an ingot.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/steel_ingot.png";
	ITEM.stackable = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_ingot"}};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Fine Steel Chunks";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/silver.mdl";
	ITEM.weight = 0.1;
	ITEM.uniqueID = "fine_steel_chunks";
	ITEM.description = "Melted down chunks of metal. It should be reclaimed into an ingot.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_steel_ingot.png";
	ITEM.stackable = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"steel_ingot"}};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();
	
local ITEM = Clockwork.item:New();
	ITEM.name = "Iron Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/lead.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "iron_ingot";
	ITEM.description = "A low-quality ingot of iron that can be further smithed into a weapon or into a set of armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/crude_iron_ingot.png";
	ITEM.stackable = true;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Steel Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/steel.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "steel_ingot";
	ITEM.description = "An ingot of steel that can be further smithed into a weapon or into a set of armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Fine Steel Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/silver.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "fine_steel_ingot";
	ITEM.description = "An ingot of refined, stronger steel that can be further smithed into a weapon or into a set of armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 650, supercrateOnly = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Hellforged Steel Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/silver.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "hellforged_steel_ingot";
	ITEM.description = "An ingot of black steel forged in the furnaces of Hell itself. It has supernatural durability and strength.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_steel_ingot.png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 800, supercrateOnly = true};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_ingot", "fine_steel_ingot"}};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Maximilian Steel Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/silver.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "maximilian_steel_ingot";
	ITEM.description = "Considered by those of the Faith of the Light to be a holy representation of Lord Maximus' might due to its strength and purity, the legendary Maximilian steel is the purest form of steel imaginable. Forged in an ancient era, it has many reputed mystical properties.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_steel_ingot.png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 800, supercrateOnly = true};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_ingot", "fine_steel_ingot"}};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Shagalaxian Steel Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/silver.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "shagalaxian_steel_ingot";
	ITEM.description = "Forged by the master blacksmiths of Clan Shagalax, Shagalaxian steel is of legendary quality and the strongest material available to the Gores. It has many reputed mystical properties.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/fine_steel_ingot.png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 800, supercrateOnly = true};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_ingot", "fine_steel_ingot"}};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Gold Ingot";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/gold.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "gold_ingot";
	ITEM.description = "An ingot of Gold, once considered to be of enormous value. While it may still be worth a great deal of coin if turned in to the Hierarchy, it may be more valuable for the smithing of ornate weapons and armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 800, supercrateOnly = true};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Hide";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/hide.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "hide";
	ITEM.description = "A rolled animal hide, useful for crafting items which might require furs or animal skins.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bone";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/Gibs/HGIBS_rib.mdl";
	ITEM.weight = 0.3;
	ITEM.uniqueID = "human_bone";
	ITEM.description = "A fragment of bone that can be used in the creation of weapons or armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Iron Ore";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props_junk/rock001a.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "iron_ore";
	ITEM.description = "A chunk of iron ore that needs to be refined before anything useful can be made with it.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Gold Ore";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props_junk/rock001a.mdl";
	ITEM.weight = 4;
	ITEM.uniqueID = "gold_ore";
	ITEM.description = "A chunk of rock that contain sparking nuggets of gold that catch the light. Could it truly be?";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

ITEM = Clockwork.item:New();
	ITEM.name = "Blood Diamond";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props_clutter/garnet_flawed.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "uncut_blood_diamond";
	ITEM.description = "A beautiful blood-red uncut gem. Its beauty entices the deepest senses of appreciation within you.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

ITEM = Clockwork.item:New();
	ITEM.name = "The Golden Phallus";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/begotten/thegoldenphallus.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "thegoldenphallus";
	ITEM.description = "A phallic object cast in pure gold. It is engraved with the markings of a long dead Darklander Emperor. By tradition, his perverted exploits continue on eternal.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = false;

	ITEM.components = {breakdownType = "meltdown", items = {"gold_ingot", "gold_ingot"}};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Leather";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/leather.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "leather";
	ITEM.description = "A patch of leather that can be used in the crafting of clothing or shields.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	ITEM.fireplaceFuel = 30;

	ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth"}};
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 65};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Scrap";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/modbox.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "scrap";
	ITEM.description = "A myriad of ancient technological components and scrap metal which can be used in the construction of many items.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 25};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Stone";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props_mining/rock_caves01b.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "stone";
	ITEM.description = "A chunk of stone that can be used in the crafting of blunt weapons, or as a blunt weapon.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	ITEM.weaponClass = "begotten_javelin_throwing_stone";
	ITEM.isJavelin = true;
	ITEM.canUseShields = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Wood";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/wood.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "wood";
	ITEM.description = "A collection of wood that can be used in the construction of weaponry or shields.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = true;
	ITEM.cauldronQuality = 0;
	ITEM.fireplaceFuel = 60;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 25};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Spice";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/items/magic/jewels/purses/big_purse.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "spice";
	ITEM.description = "A pouch of various spices. It was likely taken from a Darklander merchant host.";
	ITEM.iconoverride = "begotten/ui/itemicons/big_purse.png";
	ITEM.stackable = true;
	ITEM.cauldronQuality = 1;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 95};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bearskin";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/begotten/headgroup_props/bearskin.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "bearskin";
	ITEM.description = "Skin and fur removed from a great mutant beast. A trophy worthy of a supreme hunter.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bearskin.png";
	ITEM.stackable = true;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Familial Lifeseed";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/begotten/taproot.mdl";
	ITEM.weight = 0.6;
	ITEM.uniqueID = "lifeseed";
	ITEM.description = "A lifeseed of a Familial World Tree. It has been blessed (or tainted) by a paranormal alien magic. Capable of restarting civilization, or perhaps, with the right means, end all life.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/lifeseed.png";
	ITEM.stackable = true;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();
