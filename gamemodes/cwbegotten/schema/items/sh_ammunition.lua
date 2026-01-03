local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Grapeshot";
	ITEM.model = "models/kali/weapons/metro 2033/magazines/12 gauge shotgun shell.mdl";
	ITEM.weight = 0.25;
	ITEM.stackable = true;
	ITEM.description = "A single shell of Grapeshot.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/grapeshot.png"
	
	ITEM.ammoType = "Grapeshot";
	ITEM.ammoName = "Grapeshot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 1150, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Grapeshot";
	ITEM.model = "models/kali/weapons/metro 2033/magazines/12 gauge shotgun shell.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "An ancient Grapeshot shell, pre-dating even the Empire of Light.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/grapeshot.png"
	
	ITEM.ammoType = "Old World Grapeshot";
	ITEM.ammoName = "Old World Grapeshot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 500, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Pop-a-Shot";
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of black powder and small rusty balls that act as a bullet.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Pop-a-Shot";
	ITEM.ammoName = "Pop-a-Shot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 100, onGround = false, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Longshot";
	ITEM.model = "models/shells/shell_338mag.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "A single rusty round that can be fitted into a musket. It packs a punch.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/longshot.png"
	
	ITEM.ammoType = "Longshot";
	ITEM.ammoName = "Longshot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 1000, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Magazine";
	ITEM.model = "models/uzi megazine 20.mdl";
	ITEM.weight = 0.8;
	ITEM.description = "A magazine containing ammunition from days long past, a rare find indeed!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_magazine.png"
	
	ITEM.ammoType = "Old World Magazine";
	ITEM.ammoName = "Old World Shot";
	ITEM.ammoMagazineSize = 7;
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 800, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Large Magazine";
	ITEM.model = "models/uzi megazine 32.mdl";
	ITEM.weight = 1.2;
	ITEM.description = "A large magazine containing ammunition from days long past, a rare find indeed!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_large_magazine.png"
	
	ITEM.ammoType = "Old World Large Magazine";
	ITEM.ammoName = "Old World Shot";
	ITEM.ammoMagazineSize = 30;
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 2000, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Longshot";
	ITEM.model = "models/kali/weapons/metro 2033/magazines/12_7mm round.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of ancient manufacture, it surely outclasses anything fielded in this dark time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/old_world_longshot.png"
	
	ITEM.ammoType = "Old World Longshot";
	ITEM.ammoName = "Old World Longshot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 500, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Old World Shot";
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.stackable = true;
	ITEM.description = "A single cartridge of ancient manufacture, it surely outclasses anything fielded in this dark time.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Old World Shot";
	ITEM.ammoName = "Old World Shot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Firearms", rarity = 250, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scavenger Gun Magazine";
	ITEM.model = "models/uzi megazine 20.mdl";
	ITEM.weight = 0.8;
	ITEM.description = "A magazine that can fit 15 Scrapshot caliber rounds, for use in the ubiquitous Scavenger Gun.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_magazine.png"
	
	ITEM.ammoType = "Scavenger Gun Magazine";
	ITEM.ammoName = "Scrapshot";
	ITEM.ammoMagazineSize = 15;
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}};
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 1500, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scavenger Gun Large Magazine";
	ITEM.model = "models/uzi megazine 32.mdl";
	ITEM.weight = 1.2;
	ITEM.description = "An extended magazine that can fit 25 Scrapshot caliber rounds, for use in the ubiquitous Scavenger Gun.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scavenger_gun_large_magazine.png"
	
	ITEM.ammoType = "Scavenger Gun Large Magazine";
	ITEM.ammoName = "Scrapshot";
	ITEM.ammoMagazineSize = 25;
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scrapshot";
	ITEM.model = "models/bullets/w_pbullet1.mdl";
	ITEM.weight = 0.1;
	ITEM.stackable = true;
	ITEM.description = "A very small cartridge made of scrap metal and black powder.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pop-a-shot.png"
	
	ITEM.ammoType = "Scrapshot";
	ITEM.ammoName = "Scrapshot";
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 85, onGround = false, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Volt Projectile";
	ITEM.model = "models/items/librounds.mdl";
	ITEM.weight = 0.25;
	ITEM.stackable = true;
	ITEM.description = "A large, dense projectile launched by Voltist railguns.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_projectile.png"
	
	ITEM.ammoType = "Volt Projectile";
	ITEM.ammoName = "Volt Projectile";
	ITEM.requiredReloadBelief = "powder_and_steel";
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Iron Bolt";
	ITEM.model = "models/begotten/items/bolt.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "An iron-tipped wooden crossbow bolt of good aerodynamic quality. It can punch holes through almost any armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_bolt.png"
	
	ITEM.ammoType = "Iron Bolt";
	ITEM.ammoName = "Iron Bolt";
	ITEM.requiredReloadBelief = "strength";
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Iron Bolt (Incendiary)";
	ITEM.model = "models/begotten/items/bolt.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "An iron-tipped wooden crossbow bolt of good aerodynamic quality. It has been coated with oil that will ignite upon firing, sacrificing armor-piercing potential for setting targets alight upon contact.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_bolt_incendiary.png"
	ITEM.uniqueID = "iron_bolt_incendiary";
	
	ITEM.ammoType = "Iron Bolt (Incendiary)";
	ITEM.ammoName = "Iron Bolt (Incendiary)";
	ITEM.requiredReloadBelief = "strength";
	
	ITEM.attributes = {"fire"};
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Scrap Bolt";
	ITEM.model = "models/begotten/items/rebar.mdl";
	ITEM.weight = 0.2;
	ITEM.stackable = true;
	ITEM.description = "A crudely constructed crossbow bolt made of scrap rebar found in the Wasteland.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_bolt.png"
	
	ITEM.ammoType = "Scrap Bolt";
	ITEM.ammoName = "Scrap Bolt";
	ITEM.requiredReloadBelief = "strength";
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap"}};
	ITEM.itemSpawnerInfo = {category = "Shot", rarity = 300, onGround = false, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Shagalax Bullet Box Magazine";
	ITEM.model = "models/begotten/items/shagalaxlmgammobox.mdl";
	ITEM.weight = 1.5;
	ITEM.description = "Beaten scrap formed into a box for Scrapshot belts. Commonly stockpiled by Scrapper bosses for use in terrifying assaults or oppressive defensives.";
	ITEM.iconoverride = "begotten/ui/itemicons/shagalaxlmgammobox.png"
	
	ITEM.ammoType = "Shagalax Bullet Box Magazine";
	ITEM.ammoName = "Scrapshot";
	ITEM.ammoMagazineSize = 100;
	ITEM.requiredReloadBelief = "powder_and_steel";
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "scrap", "scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New("shot_base");
	ITEM.name = "Volt Bolt";
	ITEM.model = "models/begotten/items/rebar.mdl";
	ITEM.weight = 0.25;
	ITEM.stackable = true;
	ITEM.description = "An electrified scrap bolt used by Voltist Assassins to silently dispatch their targets.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_bolt.png"
	
	ITEM.ammoType = "Volt Bolt";
	ITEM.ammoName = "Volt Bolt";
	ITEM.requiredReloadBelief = {"strength", "wriggle_fucking_eel"};
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap"}};
ITEM:Register();