local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Darklander Spice Guard Armor";
ITEM.model = "models/begotten/headgroups_props/spiceguard.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/darklander_spice_guard_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.75
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 62;
ITEM.weight = 7;
ITEM.weightclass = "Medium";
ITEM.type = "plate";
ITEM.description = "Cast in the most pure Hellforged steel and adorned with fine silk from the east, this armor set clearly once belonged to a member of the Spice Guard. These Darklander warriors protect trade routes and escort merchants.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.overlay = "begotten/zomboverlay/helmeyes";
ITEM.faction = "Children of Satan";

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.10, -- increases fall damage by 10%
}

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50; -- Adds 40% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/satanists/darklanderspiceguard.mdl";
	--else
		--return "models/begotten/satanists/darklanderspiceguard.mdl";
	--end;
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
ITEM.name = "Dread Armor";
ITEM.model = "models/begotten/headgroup_props/dreadarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/dread_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.75
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 80;
ITEM.weight = 9;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "A set of heavy armor forged in the fires of Hell, befitting only the most loyal followers of Satan. Its Hellforged steel composition offers supreme protection against all forms of damage.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.overlay = "begotten/zomboverlay/helmeyes";
ITEM.faction = "Children of Satan";

ITEM.requiredbeliefs = {"hauberk"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 50; -- Adds 40% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/satanists/dreadarmor.mdl";
	--else
		--return "models/begotten/satanists/dreadarmor.mdl";
	--end;
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
ITEM.name = "Elegant Robes";
ITEM.group = "satanists/elegantrobes";
ITEM.model = "models/begotten/headgroup_props/elegantrobes.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/elegant_robes.png"
ITEM.category = "Armor"
ITEM.conditionScale = 1.1
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 45
ITEM.type = "leather";
ITEM.weight = 2;
ITEM.weightclass = "Light";
ITEM.description = "Elegant robes that befit only the ornate followers of Satan. It is expertly designed with exotic fabrics that display supremacy and wealth as well as offering unmatched protection with no expense of grace or mobility.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.faction = "Children of Satan";

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.stabilityScale = 0.85; -- reduces stability damage by 15%
ITEM.insulation = 65; -- Adds 52% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "breakdown", items = {"fine_steel_chunks", "cloth", "cloth", "cloth", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM.runSound = {
	"armormovement/body-lobe-1.wav.mp3",
	"armormovement/body-lobe-2.wav.mp3",
	"armormovement/body-lobe-3.wav.mp3",
	"armormovement/body-lobe-4.wav.mp3",
	"armormovement/body-lobe-5.wav.mp3",
};

--[[ITEM.walkSound = {
	"armormovement/body-lobe-b1.wav.mp3",
	"armormovement/body-lobe-b2.wav.mp3",
};]]--

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Heavy Hellplate Armor";
ITEM.group = "satanists/hellplateheavy";
ITEM.model = "models/begotten/headgroup_props/hellplateheavyarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/heavy_hellplate_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.75
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 85;
ITEM.weight = 8;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Once the dignified armor of the White Sentinels and the sigil of House Philimaxio, this armor has since been reforged in hellfire many times, only barely resembling its original form. Its existence is a disgrace to the Gatekeeper Order and an outright mockery of the Light. This particular set has been reinforced with additional plates, making it highly protective at the cost of mobility and grace.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.faction = "Children of Satan";

ITEM.requiredbeliefs = {"hauberk"};

-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
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
	[DMG_FALL] = -0.15, -- increases fall damage by 15%
}

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 40; -- Adds 32% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks", "steel_chunks", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Hellplate Armor";
ITEM.group = "satanists/hellplatemedium";
ITEM.model = "models/begotten/headgroup_props/hellplatemediumarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/hellplate_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 65;
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.type = "plate";
ITEM.description = "Once the dignified armor of the White Sentinels and the sigil of House Philimaxio, this armor has since been reforged in hellfire many times, only barely resembling its original form. Its existence is a disgrace to the Gatekeeper Order and an outright mockery of the Light.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.faction = "Children of Satan";

-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
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
	[DMG_FALL] = -0.10, -- increases fall damage by 10%
}

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.75; -- reduces stability damage by 25%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 40; -- Adds 32% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Hellspike Armor";
ITEM.model = "models/begotten/headgroup_props/hellspikearmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/hellspike_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.75
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 75;
ITEM.weight = 8;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "A set of metal plate armor adorned with spikes, its design originally hailing from the Darklands. These eastern types of armor were once prized possessions in the collections of Glazic nobles, but they are now synonymous with the followers of the Dark Lord.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.overlay = "begotten/zomboverlay/helmeyes";
ITEM.faction = "Children of Satan";

ITEM.requiredbeliefs = {"hauberk"};

-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 50; -- Adds 40% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "iron_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/satanists/hellspike_armor.mdl";
	--else
		--return "models/begotten/satanists/hellspike_armor.mdl";
	--end;
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
ITEM.name = "Wraith Armor";
ITEM.model = "models/begotten/headgroup_props/wraitharmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/wraith_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.75
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 80;
ITEM.weight = 8;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Hellforged Steel armor said to contain the bones of many sacrifices within. It is shaped in the manner of a skeleton and is sure to terrify foes.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaith = {"Faith of the Dark"};
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.overlay = "begotten/zomboverlay/skullhelm";
ITEM.faction = "Children of Satan";

ITEM.attributes = {"fear"};
ITEM.requiredbeliefs = {"hauberk"};

-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 60; -- Adds 48% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "human_bone", "human_bone", "human_bone", "human_bone", "human_bone"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/satanists/wraitharmor.mdl";
	--else
		--return "models/begotten/satanists/hellspike_armor.mdl";
	--end;
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
ITEM.name = "Darklander Immortal Armor";
ITEM.model = "models/begotten/headgroups_props/darklanderimmortal.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/darklander_immortal_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.75
ITEM.hasHelmet = true;
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 85;
ITEM.weight = 11;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Heavy plate armor of Eastern Nigerii design. It is meant for the infamous Immortals, an elite band of warriors devoted to the Emperor. A dark magic prevents this armor from being worn by anyone not of the bloodline of the King of Kings.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Children of Satan"};
ITEM.overlay = "begotten/zomboverlay/skullhelm";
ITEM.faction = "Children of Satan";

ITEM.requiredbeliefs = {"hauberk"};
ITEM.requireSubfaction = {"Varazdat"};

-- specifies which hitgroups will be affected by blunt, slash, pierce and other damage type scaling.
ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_HEAD] = true,
	[HITGROUP_CHEST] = true,
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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.70; -- reduces bullet damage by 30%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 50; -- Adds 40% insulation. Armor only accounts for 80% of total insulation, helmets cover the rest of the 20%.

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "human_bone", "human_bone", "human_bone", "human_bone", "human_bone"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/satanists/darklanderimmortal.mdl";
	--else
		--return "models/begotten/satanists/hellspike_armor.mdl";
	--end;
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