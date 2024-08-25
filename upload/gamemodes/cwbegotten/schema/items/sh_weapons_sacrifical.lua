local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Hellfire Sword";
	ITEM.model = "models/items/weapons/sword_of_fire/sword_of_fire.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_sacrificial_hellfiresword";
	ITEM.category = "Melee";
	ITEM.description = "A ancient hellforged sword still empowered with a dark catalyst. It burns hot in your hand, and even hotter in the flesh of your enemy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/hellfire_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(110.39, 337.13, 2.98);
	ITEM.attachmentOffsetVector = Vector(2.12, 4.95, -0.71);
	ITEM.canUseShields = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"fire"};
	ITEM.requiredbeliefs = {"murder_artform"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Blessed Druid Sword";
	ITEM.model = "models/begotten/weapons/sword1_unique.mdl";
	ITEM.weight = 0.7;
	ITEM.uniqueID = "begotten_sacrificial_blesseddruidsword";
	ITEM.category = "Melee";
	ITEM.description = "A crude iron blade. It is engraved with various Goreic glyphs that make it glow hot with flame.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blessed_druid_sword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(294.63, 288.95, 0);
	ITEM.attachmentOffsetVector = Vector(2.83, 3, 0);	
	ITEM.canUseShields = true;
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"fire"};
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.requiredbeliefs = {"mother"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Unholy Sigil Sword (Fire)";
	ITEM.model = "models/props/begotten/melee/smelter_sword.mdl";
	ITEM.skin = 0;
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_sacrificial_unholysigilsword_fire";
	ITEM.category = "Melee";
	ITEM.description = "A scarred black iron sigil sword forged in the fires of hell. It is empowered by a dark catalyst that makes it rage in a hellish inferno.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/unholy_sigil_sword_fire.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 185.97, 92.49);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2.83, -35.36);
	ITEM.attachmentSkin = 0;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"fire"};
	ITEM.requiredbeliefs = {"murder_artform", "strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Unholy Sigil Sword (Ice)";
	ITEM.model = "models/props/begotten/melee/smelter_sword.mdl";
	ITEM.skin = 1;
	ITEM.weight = 4;
	ITEM.uniqueID = "begotten_sacrificial_unholysigilsword_ice";
	ITEM.category = "Melee";
	ITEM.description = "A scarred black iron sigil sword forged in the fires of hell. It is empowered by a dark catalyst that makes it squall with a freezing deathly chill.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/unholy_sigil_sword_ice.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 185.97, 92.49);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2.83, -35.36);
	ITEM.attachmentSkin = 1;
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"ice"};
	ITEM.requiredbeliefs = {"murder_artform", "strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Enchanted Longsword";
	ITEM.model = "models/begotten/weapons/irithyll_straight_sword.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_sacrificial_enchantedlongsword_ice";
	ITEM.category = "Melee";
	ITEM.description = "A longsword seemingly made of ice, it has a chilling grip.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/enchanted_longsword.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(176.02, 281.44, 88.51);
	ITEM.attachmentOffsetVector = Vector(-3.54, 2.9, 16.97);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"ice"};
	ITEM.requiredbeliefs = {"the_light"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dark Ice Dagger";
	ITEM.model = "models/items/weapons/dg_ash_hammer/daggers_ash_hammer_on.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_sacrificial_darkdagger_ice";
	ITEM.category = "Melee";
	ITEM.description = "A small dagger embued with the power of ice.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dark_ice_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(76.57, 355.03, 355.03);
	ITEM.attachmentOffsetVector = Vector(-2.9, 1.41, -3.54);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"ice"};
	ITEM.requiredbeliefs = {"murder_artform"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dark Fire Dagger";
	ITEM.model = "models/items/weapons/dg_ash_hammer/daggers_ash_hammer.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "begotten_dagger_sacrificial_darkdagger_fire";
	ITEM.category = "Melee";
	ITEM.description = "A small dagger embued with the power of fire.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/dark_fire_dagger.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(76.57, 355.03, 355.03);
	ITEM.attachmentOffsetVector = Vector(-2.9, 1.41, -3.54);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"fire"};
	ITEM.requiredbeliefs = {"murder_artform"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Glazic Sword + Sol Shield";
	ITEM.model = "models/demonssouls/weapons/rune sword.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "begotten_sacrificial_glazicsword_glazicshield";
	ITEM.category = "Melee";
	ITEM.description = "A golden Maximillian blade and star shield enchanted by fire and wealthy sigils.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/glazic_sword_sol_shield.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_L_Thigh";
	ITEM.attachmentOffsetAngles = Angle(14.92, 0, 20.88);
	ITEM.attachmentOffsetVector = Vector(2.83, 3.54, 0);
	
	ITEM.components = {breakdownType = "meltdown", items = {"gold_ingot"}}; -- use "breakdown" for other type
	ITEM.attributes = {"fire"};
	ITEM.requiredbeliefs = {"the_light"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Bell Hammer";
	ITEM.model = "models/props/begotten/melee/sacred_chime_hammer.mdl";
	ITEM.weight = 18;
	ITEM.uniqueID = "begotten_2h_great_bellhammer";
	ITEM.category = "Melee";
	ITEM.description = "A colossal cast-iron beast of holy judgement. It imbues the righteous with just enough strength to wield it without toppling over. A true strike will sound the church bell, signalling a congregation of holy wrath for all to hear.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bellhammer.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(287.4, 0, 347);
	ITEM.attachmentOffsetVector = Vector(-2.12, 1.41, -20.51);
	
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}}; -- use "breakdown" for other type
	ITEM.attributes = {"bell"};
	ITEM.requiredbeliefs = {"strength", "repentant"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Demonslayer Greataxe";
	ITEM.model = "models/props/begotten/melee/drakekeeper_great_axe.mdl";
	ITEM.weight = 8;
	ITEM.uniqueID = "begotten_2h_great_demonslayerhammer";
	ITEM.category = "Melee";
	ITEM.description = "A huge Shagalaxian steel greataxe, engraved with ancient Goreic runes that repel demonic influence. If wielded by a strong enough user, this weapon has the potential to shatter one's bones in only a single swing.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/demonslayer_greataxe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0.99, 339.12, 88.51);
	ITEM.attachmentOffsetVector = Vector(7.78, 2.83, -24.04);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"strength"};
	ITEM.requireFaith = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dreadaxe";
	ITEM.model = "models/props/begotten/melee/black_knight_greataxe.mdl";
	ITEM.weight = 7;
	ITEM.uniqueID = "begotten_2h_great_dreadaxe";
	ITEM.category = "Melee";
	ITEM.description = "A black steel greataxe of malevolent design. A weapon gifted to only the most talented executioners in the Children of Satan.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/black_knight_greataxe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0.99, 339.12, 88.51);
	ITEM.attachmentOffsetVector = Vector(7.78, 2.83, -24.04);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks"}}; -- use "breakdown" for other type
	ITEM.requiredbeliefs = {"murder_artform", "strength"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Frozen Fatherland Axe";
	ITEM.model = "models/begotten/weapons/gore_ice_axe.mdl";
	ITEM.weight = 5;
	ITEM.uniqueID = "begotten_sacrificial_frozenfatherlandaxe";
	ITEM.category = "Melee";
	ITEM.description = "A war axe that has been cursed by the gods with an unceasing icy grip. It seeks a worthy wielder to freeze the blood of the unworthy.";
	ITEM.iconoverride = "begotten/ui/itemicons/gore_ice_axe.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isSacrifical = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(360, 193.92, 94.48);
	ITEM.attachmentOffsetVector = Vector(-1.41, 2, -7.07);
	
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "ice_catalyst", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.attributes = {"ice"};
	ITEM.requiredbeliefs = {"strength"};
	ITEM.onerequiredbelief = {"father", "mother", "old_son", "young_son", "sister"};
	ITEM.requireFaith = {"Faith of the Family"};
ITEM:Register();