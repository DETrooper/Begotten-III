local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Harpoon";
	ITEM.model = "models/props_junk/harpoon002a.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_spear_harpoon";
	ITEM.category = "Melee";
	ITEM.description = "A pointy thing with a hook on its end. Though heavy, it can be reliably used as a spear. Favored by peasants along coastal regions for its versatility.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/harpoon.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 10.94);
	ITEM.attachmentOffsetVector = Vector(0, 3, 0);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 200};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Iron Spear";
	ITEM.model = "models/demonssouls/weapons/short spear.mdl";
	ITEM.weight = 2;
	ITEM.uniqueID = "begotten_spear_ironspear";
	ITEM.category = "Melee";
	ITEM.description = "A long wooden rod with an iron spearhead. A spear is a deadly weapon, famed for its speed and long reach. Best used by soldiers in a war, no task is too great for an honest spear formation to handle.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/iron_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 8.95);
	ITEM.attachmentOffsetVector = Vector(-2.83, 3, -23.24);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 600};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Pitchfork";
	ITEM.model = "models/begotten/weapons/serfpitchfork.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_spear_pitchfork";
	ITEM.category = "Melee";
	ITEM.description = "An old serf's tool, not normally used as a weapon, but deadly nonetheless.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pitchfork.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 279.45, 0);
	ITEM.attachmentOffsetVector = Vector(-4.24, 3, -24.75);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 125};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Satanic Spear";
	ITEM.model = "models/demonssouls/weapons/scraping spear.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_spear_satanicspear";
	ITEM.category = "Melee";
	ITEM.description = "An unholy weapon forged in the fires of Hell. It finds its use in the Legions of Lucifer, the human fighters who each serve the Dark Prince for their own selfish desires. This particular spear is known for being able to pierce through enemy defenses, scraping against the flesh as it is retracted for another thrust.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/satanic_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 8.95, 0);
	ITEM.attachmentOffsetVector = Vector(0, 3, -17.85);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.requireFaith = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Scrap Spear";
	ITEM.model = "models/mosi/fallout4/props/weapons/melee/poolcue.mdl";
	ITEM.bodygroup1 = 4;
	ITEM.weight = 1.3;
	ITEM.uniqueID = "begotten_spear_scrapspear";
	ITEM.category = "Melee";
	ITEM.description = "A wooden stick with a blade attached to its end, forming a spear. It is not nearly as long nor as durable as a normal spear, but it is swift.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scrap_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 279.45, 0);
	ITEM.attachmentOffsetVector = Vector(-4.24, 3, -24.75);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "breakdown", items = {"scrap", "wood", "wood"}};
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 250, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Training Spear";
	ITEM.model = "models/begotten/weapons/training_spear.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "begotten_spear_trainingspear";
	ITEM.category = "Melee";
	ITEM.description = "A wooden pole that can be used for low-risk spear combat training.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/training_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(0, 279.45, 0);
	ITEM.attachmentOffsetVector = Vector(-4.24, 3, -24.75);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "breakdown", items = {"wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Voltspear";
	ITEM.model = "models/begotten/weapons/voltspear.mdl";
	ITEM.weight = 2.5;
	ITEM.uniqueID = "begotten_spear_voltspear";
	ITEM.category = "Melee";
	ITEM.description = "An electrified voltprod mounted on a wooden shaft to increase its range.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/volt_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 8.95);
	ITEM.attachmentOffsetVector = Vector(-2.83, 3, -23.24);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "wood", "wood", "scrap", "scrap", "scrap", "scrap", "tech", "tech"}};
	ITEM.requiredbeliefs = {"wriggle_fucking_eel"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Winged Spear";
	ITEM.model = "models/demonssouls/weapons/winged spear.mdl";
	ITEM.weight = 2.3;
	ITEM.uniqueID = "begotten_spear_wingedspear";
	ITEM.category = "Melee";
	ITEM.description = "A refined steel spear, commonly forged by the Holy Hierarchy. It features a wing at the end, good for catching enemy blades.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/winged_spear.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.hasMinimumRange = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 0, 10.94);
	ITEM.attachmentOffsetVector = Vector(-2.12, 3, -18.39);
	ITEM.canUseShields = true;
	
	ITEM.attributes = {"grounded"};
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks", "wood", "wood"}}; -- use "breakdown" for other type
	ITEM.itemSpawnerInfo = {category = "Melee", rarity = 1000, supercrateOnly = true};
ITEM:Register();