local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Grapeshot";
	ITEM.cost = 30;
	ITEM.model = "models/kali/weapons/metro 2033/magazines/12 gauge shotgun shell.mdl";
	ITEM.weight = 0.2;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A single shell of Grapeshot.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/grapeshot.png"
	
	ITEM.ammoType = "Grapeshot";
	ITEM.ammoName = "Grapeshot";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 150, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Pop-a-Shot";
	ITEM.cost = 15;
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of black powder and small rusty balls that act as a bullet.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Pop-a-Shot";
	ITEM.ammoName = "Pop-a-Shot";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 65, onGround = false, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Longshot";
	ITEM.cost = 30;
	ITEM.model = "models/shells/shell_338mag.mdl";
	ITEM.weight = 0.2;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A single rusty round that can be fitted into a musket. It packs a punch.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/longshot.png"
	
	ITEM.ammoType = "Longshot";
	ITEM.ammoName = "Longshot";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 120, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Magazine";
	ITEM.cost = 250;
	ITEM.model = "models/uzi megazine 20.mdl";
	ITEM.weight = 0.8;
	ITEM.business = true;
	ITEM.description = "A magazine containing ammunition from days long past, a rare find indeed!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_magazine.png"
	
	ITEM.ammoType = "Old World Magazine";
	ITEM.ammoName = "Old World Shot";
	ITEM.ammoMagazineSize = 7;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 800, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Large Magazine";
	ITEM.cost = 250;
	ITEM.model = "models/uzi megazine 32.mdl";
	ITEM.weight = 1.2;
	ITEM.business = true;
	ITEM.description = "A large magazine containing ammunition from days long past, a rare find indeed!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_large_magazine.png"
	
	ITEM.ammoType = "Old World Large Magazine";
	ITEM.ammoName = "Old World Shot";
	ITEM.ammoMagazineSize = 30;
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 2000, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Longshot";
	ITEM.cost = 100;
	ITEM.model = "models/kali/weapons/metro 2033/magazines/12_7mm round.mdl";
	ITEM.weight = 0.2;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of ancient manufacture, it surely outclasses anything fielded in this dark time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/old_world_longshot.png"
	
	ITEM.ammoType = "Old World Longshot";
	ITEM.ammoName = "Old World Longshot";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 500, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Shot";
	ITEM.cost = 30;
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of ancient manufacture, it surely outclasses anything fielded in this dark time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Old World Shot";
	ITEM.ammoName = "Old World Shot";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 250, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scavenger Gun Magazine";
	ITEM.cost = 75;
	ITEM.model = "models/uzi megazine 20.mdl";
	ITEM.weight = 0.8;
	ITEM.business = true;
	ITEM.description = "A magazine that can fit 15 Scrapshot caliber rounds, for use in the ubiquitous Scavenger Gun.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_magazine.png"
	
	ITEM.ammoType = "Scavenger Gun Magazine";
	ITEM.ammoName = "Scrapshot";
	ITEM.ammoMagazineSize = 15;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 350, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scavenger Gun Large Magazine";
	ITEM.cost = 125;
	ITEM.model = "models/uzi megazine 32.mdl";
	ITEM.weight = 1.2;
	ITEM.business = true;
	ITEM.description = "An extended magazine that can fit 25 Scrapshot caliber rounds, for use in the ubiquitous Scavenger Gun.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_large_magazine.png"
	
	ITEM.ammoType = "Scavenger Gun Large Magazine";
	ITEM.ammoName = "Scrapshot";
	ITEM.ammoMagazineSize = 25;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "scrap"}};
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 550, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scrapshot";
	ITEM.cost = 15;
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A very small cartridge made of scrap metal and black powder.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Scrapshot";
	ITEM.ammoName = "Scrapshot";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 90, onGround = false, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Volt Projectile";
	ITEM.cost = 20;
	ITEM.model = "models/items/librounds.mdl";
	ITEM.weight = 0.25;
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A large, dense projectile launched by Voltist railguns.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_projectile.png"
	
	ITEM.ammoType = "Volt Projectile";
	ITEM.ammoName = "Volt Projectile";
ITEM:Register();