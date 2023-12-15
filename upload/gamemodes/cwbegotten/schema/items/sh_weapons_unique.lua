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
	ITEM.canUseShields = true;
ITEM:Register();