local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Blackclaw";
	ITEM.model = "models/begotten/weapons/uniquegoresword.mdl";
	ITEM.weight = 3;
	ITEM.uniqueID = "begotten_unique_1h_blackclaw";
	ITEM.category = "Melee";
	ITEM.description = "A black Shagalaxian steel sword somehow forged in the fires of hell. It is cursed with the souls of its victims, thousands of fallen foes wandering a black void without heads. This weapon is clearly not meant to be held in your hands.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blackclaw.png"
	ITEM.meleeWeapon = true;
	ITEM.isAttachment = true;
	ITEM.isUnique = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine1";
	ITEM.attachmentOffsetAngles = Angle(273.48, 6.96, 251.6);
	ITEM.attachmentOffsetVector = Vector(-8.49, -12.02, -19.09);
	ITEM.shields = {"shieldunique1"};
ITEM:Register();

local ITEM = Clockwork.item:New("shield_base");
	ITEM.name = "Red Wolf Shield";
	ITEM.model = "models/begotten/weapons/uniquegoreshield.mdl";
	ITEM.weight = 6;
	ITEM.uniqueID = "shieldunique1";
	ITEM.description = "An unholy wall of black steel forged in the fires of hell. It is adorned with the dried flesh of flayed victims. A shield meant for the Red Wolves, a twisted warrior lodge of Clan Reaver.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/red_wolf_shield.png"
	ITEM.isAttachment = true;
	ITEM.isUnique = true;
	ITEM.attachmentBone = "ValveBiped.Bip01_Spine2";
	ITEM.attachmentOffsetAngles = Angle(90, 360, 0);
	ITEM.attachmentOffsetVector = Vector(0, 4.24, -4.95);
ITEM:Register();