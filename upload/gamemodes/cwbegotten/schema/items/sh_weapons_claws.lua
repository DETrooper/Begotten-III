local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Savage Claws";
	ITEM.model = "models/demonssouls/weapons/claws.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "begotten_claws_savageclaws";
	ITEM.category = "Melee";
	ITEM.description = "Iron blades shaped in the image of a bear's claws. The distinctive Goreic ritual weapon of the now extinct Clan Ursa.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/savage_claws.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(285.41, 319.23, 265.52);
	ITEM.attachmentOffsetVector = Vector(0, 4.24, 0);
	ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks"}}; -- use "breakdown" for other type

	ITEM.onerequiredbelief = {"man_become_beast", "witch_druid"};
ITEM:Register();

local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Steel Claws";
	ITEM.model = "models/props/begotten/melee/claws.mdl";
	ITEM.weight = 0.6;
	ITEM.uniqueID = "begotten_claws_steelclaws";
	ITEM.category = "Melee";
	ITEM.description = "Shagalaxian steel claws, terrifyingly crafted for the purpose of shredding men at the hands of the bloodthirsty ravenous Berzerkers of Clan Gore.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/steel_claws.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_R_Thigh";
	ITEM.attachmentOffsetAngles = Angle(319.23, 168.07, 265.52);
	ITEM.attachmentOffsetVector = Vector(0.71, 2.83, -4.95);
	ITEM.components = {breakdownType = "meltdown", items = {"steel_chunks"}}; -- use "breakdown" for other type
	
	ITEM.onerequiredbelief = {"man_become_beast", "witch_druid"};
ITEM:Register();