local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Lord Vasso's Gothic Plate";
ITEM.model = "models/begotten/headgroup_props/hellspikearmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/lord_vasso_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0 -- item does not degrade
--ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.isUnique = true;
ITEM.protection = 90;
ITEM.weight = 6;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Lord Vasso's personal set of hell-forged armor, its style reminiscent of a time before the Empire of Light.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Children of Satan"};

ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	--[HITGROUP_HEAD] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.15, -- increases fall damage by 15%
}

ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
ITEM.pierceScale = 0.60; -- reduces pierce damage by 40%
ITEM.slashScale = 0.50; -- reduces slash damage by 50%
ITEM.bulletScale = 0.15; -- reduces bullet damage by 85%
ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM.insulation = 80;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
		return "models/begotten/satanists/lordvasso/male_56.mdl";
end;

ITEM.runSound = {
	"armormovement/body-armor-1.WAV.mp3",
	"armormovement/body-armor-2.WAV.mp3",
	"armormovement/body-armor-3.WAV.mp3",
	"armormovement/body-armor-4.WAV.mp3",
	"armormovement/body-armor-5.WAV.mp3",
	"armormovement/body-armor-6.WAV.mp3",
};

ITEM.walkSound = {
	"armormovement/body-armor-b4.WAV.mp3",
	"armormovement/body-armor-b5.WAV.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Bjornling's Red Wolf Plate";
ITEM.model = "models/begotten/headgroup_props/reaverplate.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/bjornling_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0 -- item does not degrade
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.isUnique = true;
ITEM.protection = 90;
ITEM.weight = 8;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Heavy armor made from hellforged black iron. Decorated with skulls and hides from man and demon alike, the Red Wolves of Clan Reaver make sure their presence is known.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Goreic Warrior"};

ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.25, -- increases fall damage by 25%
}

ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
ITEM.pierceScale = 0.60; -- reduces pierce damage by 40%
ITEM.slashScale = 0.50; -- reduces slash damage by 50%
ITEM.bulletScale = 0.15; -- reduces bullet damage by 85%
ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM.insulation = 80;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
		return "models/begotten/goreicwarfighters/bjornling.mdl";
end;

ITEM.runSound = {
	"armormovement/body-armor-1.WAV.mp3",
	"armormovement/body-armor-2.WAV.mp3",
	"armormovement/body-armor-3.WAV.mp3",
	"armormovement/body-armor-4.WAV.mp3",
	"armormovement/body-armor-5.WAV.mp3",
	"armormovement/body-armor-6.WAV.mp3",
};

ITEM.walkSound = {
	"armormovement/body-armor-b4.WAV.mp3",
	"armormovement/body-armor-b5.WAV.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Goreic Kingplate";
ITEM.model = "models/begotten/headgroup_props/housecarlarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/lord_vasso_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0 -- item does not degrade
--ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.isUnique = true;
ITEM.protection = 90;
ITEM.weight = 6;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Plate armor forged from supreme Shagalaxian Steel. It is meant for a King of the Bark Throne.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.requireRank = {"King"};
ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	--[HITGROUP_HEAD] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.15, -- increases fall damage by 15%
}

ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
ITEM.pierceScale = 0.60; -- reduces pierce damage by 40%
ITEM.slashScale = 0.50; -- reduces slash damage by 50%
ITEM.bulletScale = 0.15; -- reduces bullet damage by 85%
ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM.insulation = 80;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
		return "models/begotten/goreicwarfighters/goreking.mdl";
end;

ITEM.runSound = {
	"armormovement/body-armor-1.WAV.mp3",
	"armormovement/body-armor-2.WAV.mp3",
	"armormovement/body-armor-3.WAV.mp3",
	"armormovement/body-armor-4.WAV.mp3",
	"armormovement/body-armor-5.WAV.mp3",
	"armormovement/body-armor-6.WAV.mp3",
};

ITEM.walkSound = {
	"armormovement/body-armor-b4.WAV.mp3",
	"armormovement/body-armor-b5.WAV.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Shingar's Blackwolf Hauberk";
ITEM.model = "models/begotten/headgroup_props/housecarlarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/lord_vasso_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0 -- item does not degrade
--ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.isUnique = true;
ITEM.protection = 90;
ITEM.weight = 6;
ITEM.weightclass = "Heavy";
ITEM.type = "chainmail";
ITEM.description = "Shagalaxian chainmail, boiled leather and a bloody wolf's pelt. A brutish set of armor that gets the job done well.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.requireRank = {"King"};
ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	--[HITGROUP_HEAD] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.15, -- increases fall damage by 15%
}

ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
ITEM.pierceScale = 0.60; -- reduces pierce damage by 40%
ITEM.slashScale = 0.50; -- reduces slash damage by 50%
ITEM.bulletScale = 0.15; -- reduces bullet damage by 85%
ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM.insulation = 80;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
		return "models/begotten/goreicwarfighters/shingar.mdl";
end;

ITEM.runSound = {
	"armormovement/body-hauberk-1.wav.mp3",
	"armormovement/body-hauberk-2.wav.mp3",
	"armormovement/body-hauberk-3.wav.mp3",
	"armormovement/body-hauberk-4.wav.mp3",
	"armormovement/body-hauberk-5.wav.mp3",
};

ITEM.walkSound = {
	"armormovement/body-hauberk-b4.wav.mp3",
	"armormovement/body-hauberk-b5.wav.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Emperor Varazdat's Nigerii Hauberk";
ITEM.model = "models/begotten/headgroup_props/hellspikearmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/lord_vasso_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0 -- item does not degrade
--ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.isUnique = true;
ITEM.protection = 90;
ITEM.weight = 6;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Armor of the Emperor of the Eastern Nigerii Empire. It is obviously fitted for a portly figure.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Children of Satan"};

ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	--[HITGROUP_HEAD] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.15, -- increases fall damage by 15%
}

ITEM.bluntScale = 0.70; -- reduces blunt damage by 30%
ITEM.pierceScale = 0.60; -- reduces pierce damage by 40%
ITEM.slashScale = 0.50; -- reduces slash damage by 50%
ITEM.bulletScale = 0.15; -- reduces bullet damage by 85%
ITEM.stabilityScale = 0.20; -- reduces stability damage by 80%
ITEM.insulation = 80;

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
		return "models/begotten/satanists/emperorvarazdat.mdl";
end;

ITEM.runSound = {
	"armormovement/body-armor-1.WAV.mp3",
	"armormovement/body-armor-2.WAV.mp3",
	"armormovement/body-armor-3.WAV.mp3",
	"armormovement/body-armor-4.WAV.mp3",
	"armormovement/body-armor-5.WAV.mp3",
	"armormovement/body-armor-6.WAV.mp3",
};

ITEM.walkSound = {
	"armormovement/body-armor-b4.WAV.mp3",
	"armormovement/body-armor-b5.WAV.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Elder Druid Robes";
ITEM.model = "models/begotten/headgroups_props/elderdruid.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/elder_druid_robes.png"
ITEM.helmetIconOverride = "materials/begotten/ui/itemicons/gore_skull_helm.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 55
ITEM.type = "leather";
ITEM.hasHelmet = true;
ITEM.weight = 3.5;
ITEM.weightclass = "Light";
ITEM.description = "An original set of Blade Druid Robes somehow well kept over centuries. It is permanently attached to a Dread Minotaur Helm and is highly protected by the Maternal Aura. It appears that bullet projectiles are completely ineffective against this armor, as the aura protects from such cowardly means.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock", "Clan Gore", "Clan Shagalax", "Clan Harald", "Clan Reaver"};
ITEM.overlay = "begotten/zomboverlay/skullhelm";

ITEM.effectiveLimbs = {
	[HITGROUP_HEAD] = true,
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.25, -- increases fall damage by 25%
}

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
ITEM.bulletScale = 0.10; -- reduces bullet damage by 90%
ITEM.insulation = 70;

ITEM.attributes = {"mothers_blessing", "increased_regeneration", "fear"};
ITEM.components = {breakdownType = "breakdown", items = {"hide", "hide", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/goreicwarfighters/elderdruid.mdl";
	--else
		--return "models/begotten/satanists/lordvasso/male_56.mdl";
	--end;
end;

ITEM:Register();