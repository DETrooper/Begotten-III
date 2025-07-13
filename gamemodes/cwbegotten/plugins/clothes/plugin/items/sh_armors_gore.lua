local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Armored Blade Druid Robes";
ITEM.group = "goreicwarfighters/armoredbladedruid";
ITEM.model = "models/begotten/headgroups_props/armoredbladedruid.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/armored_blade_druid_robes.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 55
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "Although traditionally regarded as weak, those born of the Mother do not find combat wanting, and as such are compelled to adorn their spiritual robes with armor. This set of armor has an enchantment to ward off the damage of firearms.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Shagalax", "Clan Harald", "Clan Reaver", "Clan Gotnarh", "Clan Ghorst"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.bulletScale = 0.5; -- reduces bullet damage by 50%
ITEM.insulation = 70;

ITEM.attributes = {"mothers_blessing", "increased_regeneration"};
ITEM.components = {breakdownType = "breakdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "hide", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Blade Druid Robes";
ITEM.group = "goreicwarfighters/bladedruid";
ITEM.model = "models/begotten/headgroup_props/bladedruidrobes.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/blade_druid_robes.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 25
ITEM.type = "leather";
ITEM.weight = 2;
ITEM.weightclass = "Light";
ITEM.description = "Layers of hide and etched cloth resembling mystic robes. Tailored in the image of the ancient Blade Druid order that were the founders of Gore society and religion. Only those born under the image of The Mother are said to be fit to wear such robes.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gore", "Clan Shagalax", "Clan Harald", "Clan Reaver", "Clan Gotnarh", "Clan Ghorst"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.insulation = 60;

ITEM.attributes = {"mothers_blessing", "increased_regeneration", "miracle_doctor"};
ITEM.components = {breakdownType = "breakdown", items = {"hide", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Gore Seafarer Garb";
ITEM.group = "goreicwarfighters/goreseafarer";
ITEM.model = "models/begotten/headgroup_props/seafarerarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_seafarer_garb.png"
ITEM.category = "Armor"
ITEM.weight = 1;
ITEM.description = "A fur cloak traditionally worn by Goreic seafaring raiders. It has no protective value.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requiredFactions = {"Goreic Warrior"};

ITEM.insulation = 25;

ITEM.attributes = {"seafarer"};
ITEM.components = {breakdownType = "breakdown", items = {"cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Gore Berserker Armor";
ITEM.uniqueID = "gore_beserker_armor"; -- due to typo in the old name
ITEM.group = "goreicwarfighters/goreberzerker";
ITEM.model = "models/begotten/headgroup_props/berzerkerarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_beserker_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hasHelmet = true;
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 25
ITEM.type = "leather";
ITEM.weight = 2;
ITEM.weightclass = "Light";
ITEM.description = "A bear pelt commonly worn by Gore Berserkers, the most fearsome and fearless warriors of the Gores.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.attributes = {"lifeleech", "rage"};
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Reaver", "Clan Gotnarh"};

ITEM.effectiveLimbs = {
	[HITGROUP_HEAD] = true,
}

ITEM.bluntScale = 0.55; -- reduces blunt damage by 45%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.insulation = 25;

ITEM.components = {breakdownType = "breakdown", items = {"hide", "hide", "bearskin", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Gore Chainmail";
ITEM.group = "goreicwarfighters/gorechainmail";
ITEM.model = "models/begotten/headgroup_props/gorechainmalarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_chainmail.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 50
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "A crude set of chainmail over leather and fur garb, it provides adequate protection from enemy weapons and the elements.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "cloth", "cloth", "leather", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Gore Housecarl Armor";
ITEM.group = "goreicwarfighters/gorehousecarl";
ITEM.model = "models/begotten/headgroup_props/housecarlarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_housecarl_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.75
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 75;
ITEM.weight = 8;
ITEM.weightclass = "Heavy";
ITEM.type = "chainmail";
ITEM.description = "The armor of a Goreic Housecarl: a combination of chainmail and shagalaxian scale armor, with ornate leather decorations.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.insulation = 60;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "steel_chunks", "leather", "leather", "leather", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Grockling Rattleshirt Armor";
ITEM.model = "models/begotten/headgroup_props/rattleshirtarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/grockling_rattleshirt_armor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.9
ITEM.hasHelmet = true;
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 35;
ITEM.weight = 3;
ITEM.weightclass = "Light";
ITEM.type = "leather";
ITEM.description = "A linked set of human and animal bones forming protective plates. A minotaur's head forming a terrifying war helm. The armor rattles as it moves, giving it a particularly terrifying presence. This armor is uniquely suited against blunt attacks.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.attributes = {"fear"};
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Ghorst"};
ITEM.overlay = "begotten/zomboverlay/new/goreminotaur";

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

ITEM.bluntScale = 0.60; -- reduces blunt damage by 40%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.insulation = 55;

ITEM.components = {breakdownType = "breakdown", items = {"human_bone", "human_bone", "human_bone", "human_bone", "human_bone", "human_bone", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	--if (player:GetGender() == GENDER_FEMALE) then
		return "models/begotten/goreicwarfighters/gorechieftan.mdl";
	--else
		--return "models/begotten/goreicwarfighters/gorechieftan.mdl";
	--end;
end;

ITEM.runSound = {
	"armormovement/rattle1.mp3",
	"armormovement/rattle2.mp3",
	"armormovement/rattle3.mp3",
	"armormovement/rattle4.mp3",
	"armormovement/rattle5.mp3",
	"armormovement/rattle6.mp3",
	"armormovement/rattle7.mp3",
	"armormovement/rattle8.mp3",
	"armormovement/rattle9.mp3",
};

ITEM.walkSound = {
	"armormovement/rattle1.mp3",
	"armormovement/rattle2.mp3",
	"armormovement/rattle3.mp3",
	"armormovement/rattle4.mp3",
	"armormovement/rattle5.mp3",
	"armormovement/rattle6.mp3",
	"armormovement/rattle7.mp3",
	"armormovement/rattle8.mp3",
	"armormovement/rattle9.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Gore Warfighter Armor";
ITEM.group = "goreicwarfighters/warfighter";
ITEM.model = "models/begotten/headgroup_props/warfighterarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/warfighter_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 33
ITEM.type = "leather";
ITEM.weight = 2;
ITEM.weightclass = "Light";
ITEM.description = "Leather armor commonly worn by warriors of Clan Gore. It provides a reasonable degree of protection while not compromising mobility.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requiredFactions = {"Goreic Warrior"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.insulation = 60;

ITEM.components = {breakdownType = "breakdown", items = {"leather", "leather", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Old Haralder Chainmail";
ITEM.group = "goreicwarfighters/haralderchainmail";
ITEM.model = "models/begotten/headgroup_props/haralderarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/haralder_chainmail.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 50
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "A sleeveless chainmail set over leather garb, stylized in Clan Haralder's fashion. The patchwork leather smells of the sea. This armor is old and forgotten.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.75; -- reduces slash damage by 25%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Red Wolf Plate";
ITEM.group = "goreicwarfighters/reaverplate";
ITEM.model = "models/begotten/headgroup_props/reaverplate.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/bjornling_armor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.75
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 80;
ITEM.weight = 11;
ITEM.weightclass = "Heavy";
ITEM.type = "plate";
ITEM.description = "Heavy armor made from hellforged black iron. Decorated with skulls and hides from man and demon alike, the Red Wolves of Clan Reaver make sure their presence is known.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.insulation = 70;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "iron_chunks", "iron_chunks", "human_bone", "human_bone"}};

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
ITEM.name = "Gore Lamellar";
ITEM.group = "goreicwarfighters/gorelamellar";
ITEM.model = "models/begotten/headgroups_props/gorelamellar.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/gore_lamellar.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 65
ITEM.type = "plate";
ITEM.weight = 6.5;
ITEM.weightclass = "Medium";
ITEM.description = "Steel plates arranged in a fishscale pattern upon a gambeson coat. It provides fine protection while not being too much of a hindrance to mobility.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "steel_chunks", "steel_chunks", "leather", "cloth", "cloth", "cloth"}};

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
ITEM.name = "Gore King's Chosen Armor";
ITEM.group = "goreicwarfighters/gorescale";
ITEM.model = "models/begotten/headgroups_props/gorescalearmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/chosenarmor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.75
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 85;
ITEM.weight = 9;
ITEM.weightclass = "Heavy";
ITEM.type = "chainmail";
ITEM.description = "Shagalaxian steel scale armor decorated with brass Familial sigils. It is armor that boasts the approval of both the Gods and the King.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};
ITEM.requiredRanks = {"King's Chosen"};

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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
ITEM.stabilityScale = 0.50; -- reduces stability damage by 50%
ITEM.insulation = 60;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "fine_steel_chunks", "leather", "leather", "leather", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Reaver Marauder Lamellar";
ITEM.group = "goreicwarfighters/reaver_marauder";
ITEM.model = "models/begotten/items/reaver_marauder_item.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/reaver_marauder_item.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.80
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 65;
ITEM.weight = 6.5;
ITEM.weightclass = "Medium";
ITEM.type = "plate";
ITEM.description = "A harness of lamellar and cold forged black iron. It is covered in sigils and runes of Clan Reaver, and even foreign symbols from far northern wastelands. Used widely in Goreic warbands for its strong protective metal plating.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.excludedSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true,
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.10, -- increases fall damage by 10%
}

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "iron_chunks", "iron_chunks", "human_bone", "human_bone"}, xp = 30};

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
ITEM.name = "Reaver Drottinn Lamellar";
ITEM.group = "goreicwarfighters/reaver_chief";
ITEM.model = "models/begotten/items/reaver_marauder_item.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/reaver_marauder_item.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.80
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 70;
ITEM.weight = 7.5;
ITEM.weightclass = "Medium";
ITEM.type = "plate";
ITEM.description = "A set of blackened lamellar used by the torturers, executioners, and commanders of the far-away Marauders. This armor was made to boast Goreic mastery over darkness; to wield its power without being made its subject.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"};

ITEM.effectiveLimbs = {
	[HITGROUP_GENERIC] = true,
	[HITGROUP_CHEST] = true,
	[HITGROUP_STOMACH] = true,
	[HITGROUP_LEFTARM] = true,
	[HITGROUP_RIGHTARM] = true,
	[HITGROUP_LEFTLEG] = true,
	[HITGROUP_RIGHTLEG] = true,
	[HITGROUP_GEAR] = true,
}

ITEM.damageTypeScales = {
	[DMG_FALL] = -0.10, -- increases fall damage by 10%
}

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
ITEM.insulation = 70;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "iron_chunks", "iron_chunks", "human_bone", "human_bone"}};

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
ITEM.name = "Shagalaxian Scalemail";
ITEM.group = "prelude_gores/scalegore";
ITEM.model = "models/begotten_prelude/items/scalegore.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/scalegore.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 50
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "An impressively smithed hauberk of scalemail, blackened using ancient shagalax forging methods. Layered with a special type of leather padding, this armor can help to dampen the blows from firearm.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.requiredSubfactions = {"Clan Shagalax"};

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
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.75; -- reduces slash damage by 25%
ITEM.bulletScale = 0.60; -- reduces bullet damage by 40%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Reaver Chainmail";
ITEM.group = "prelude_gores/chaingore2";
ITEM.model = "models/begotten_prelude/items/chaingore2.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/chaingore2.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 55
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "Goreic chainmail smithed in the style of the Eastern Reavers. Extra padding has been sewn under the chainmail to resist blunt attacks.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.onerequiredbelief = {"sister", "satanism", "primevalism"};

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

ITEM.bluntScale = 0.80; -- reduces blunt damage by 20%
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Goreic Kingplate";
ITEM.group = "body/seafarer_armor";
ITEM.model = "models/begotten/headgroup_props/haralderarmor.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/kingarmor.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.75
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 75
ITEM.type = "chainmail";
ITEM.weight = 6;
ITEM.weightclass = "Medium";
ITEM.description = "A brutish set of armor crafted by the finest minds Clan Shagalax could muster, and blessed thrice by Clan Crast. Utilizing techniques befitting ancient war tanks, this surprisingly nimble armor is capable of withstanding plenty of torment. It is almost perpetually covered in blood, a sign of its effectiveness in combat.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.requiredRanks = {"King"};
ITEM.faction = "Goreic Warrior";
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.attributes = {"rage"};
ITEM.bluntScale = 0.65; -- reduces blunt damage by 35%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.65; -- reduces slash damage by 35%
ITEM.bulletScale = 0.50; -- reduces bullet damage by 50%
ITEM.stabilityScale = 0.65; -- reduces stability damage by 35%
ITEM.insulation = 65;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "steel_chunks", "steel_chunks", "iron_chunks", "iron_chunks", "iron_chunks", "gold_ingot"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Frenzied Chainmail";
ITEM.group = "prelude_gores/battaniansash";
ITEM.model = "models/begotten_prelude/items/batttaniansash.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/batttaniansash.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 55
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "Sturdy chainmail that has been blessed by the Father, granting its user increased speed and vigor in battle. This style of armor is worn by aspiring warriors seeking to be remembered long after their death.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.requiredSubfactions = {"Clan Gore"};
ITEM.kinisgerOverride = true;

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
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.75; -- reduces slash damage by 25%
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.attributes = {"rage"};
ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "cloth", "cloth", "cloth"}};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Haralder Sealord Lamellar";
ITEM.group = "prelude_gores/fishscale";
ITEM.model = "models/begotten/headgroups_props/gorelamellar.mdl" -- Replace later
ITEM.uniqueID = "haralder_sealord_lamellar";
ITEM.iconoverride = "begotten/ui/itemicons/fishscale.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 70
ITEM.type = "plate";
ITEM.weight = 7.5;
ITEM.weightclass = "Medium";
ITEM.description = "Steel plates arranged in a fishscale pattern upon a gambeson coat. It provides fine protection while not being too much of a hindrance to mobility. This armor is affected by the curse of Clan Harald, and thus no others may wear it.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.requiredSubfactions = {"Clan Harald"};
ITEM.kinisgerOverride = true;

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.bulletScale = 0.80; -- reduces bullet damage by 20%
ITEM.insulation = 70;

ITEM.components = {breakdownType = "meltdown", items = {"fine_steel_chunks", "fine_steel_chunks", "iron_chunks", "iron_chunks", "iron_chunks"}};

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
ITEM.name = "Goreic Eastmen Armor";
ITEM.group = "prelude_gores/braveset";
ITEM.model = "models/begotten_prelude/items/braveset.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/braveset.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 38
ITEM.type = "leather";
ITEM.weight = 2;
ITEM.weightclass = "Light";
ITEM.description = "Brightly dyed leather armor from the Eastern Isles of the Gorelands. It provides a reasonable degree of protection while not compromising mobility.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.insulation = 60;

ITEM.components = {breakdownType = "breakdown", items = {"leather", "leather", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Haralder Chainmail";
ITEM.group = "prelude_gores/haraldnew";
ITEM.model = "models/begotten_prelude/items/chaingore4.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/chaingore4.png"
ITEM.uniqueID = "haralder_chainmail";
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 50
ITEM.type = "chainmail";
ITEM.weight = 4;
ITEM.weightclass = "Medium";
ITEM.description = "A sleeveless chainmail set over leather garb, stylized in Clan Haralder's fashion. The patchwork leather smells of the sea, and its design is clearly from the Eastern Isles, and comes with a sash.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.requiredSubfactions = {"Clan Harald"};
ITEM.kinisgerOverride = true;

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.75; -- reduces slash damage by 25%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.attributes = {"seafarer"};
ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "leather", "cloth", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Quebecois Gore Chainmail";
ITEM.group = "prelude_gores/chaingore3";
ITEM.model = "models/begotten_prelude/items/chaingore3.mdl"
ITEM.iconoverride = "begotten/ui/itemicons/chaingore3.png"
ITEM.category = "Armor"
ITEM.conditionScale = 0.9
ITEM.hitParticle = "MetalSpark";
ITEM.protection = 50
ITEM.type = "chainmail";
ITEM.weight = 5;
ITEM.weightclass = "Medium";
ITEM.description = "A crude set of chainmail over leather and fur garb, it provides adequate protection from enemy weapons and the elements. This particular style originates from the frozen lands of Vancouver.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requiredFactions = {"Goreic Warrior", "Wanderer"};
ITEM.excludedSubfactions = {"Clan Grock", "Clan Gotnarh"};

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

ITEM.bluntScale = 0.90; -- reduces blunt damage by 10%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.bulletScale = 0.90; -- reduces bullet damage by 10%
ITEM.insulation = 50;

ITEM.components = {breakdownType = "meltdown", items = {"iron_chunks", "iron_chunks", "iron_chunks", "cloth", "cloth", "leather", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

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
ITEM.name = "Grockling Godless Garb";
ITEM.model = "models/begotten/headgroup_props/groktribalarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/groktribalarmor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.9
ITEM.hasHelmet = true;
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 25;
ITEM.weight = 1.5;
ITEM.weightclass = "Light";
ITEM.type = "leather";
ITEM.description = "Some followers of the Old Ways use belief as they would use a tool, and they sharpen their belief with madness. The Godless reject the offerings of the Gods, instead worshipping dirt, leaves, bone and blood. When lost in the madness, they become their own gods.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.attributes = {"godless"};
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Ghorst"};
ITEM.overlay = "begotten/zomboverlay/new/goreminotaur";

ITEM.effectiveLimbs = {
	[HITGROUP_HEAD] = true,
}

ITEM.bluntScale = 0.55; -- reduces blunt damage by 45%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.insulation = 20;

ITEM.components = {breakdownType = "breakdown", items = {"human_bone", "human_bone", "human_bone", "human_bone"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	return "models/begotten/goreicwarfighters/groktribal.mdl";
end;

ITEM.runSound = {
	"armormovement/rattle1.mp3",
	"armormovement/rattle2.mp3",
	"armormovement/rattle3.mp3",
	"armormovement/rattle4.mp3",
	"armormovement/rattle5.mp3",
	"armormovement/rattle6.mp3",
	"armormovement/rattle7.mp3",
	"armormovement/rattle8.mp3",
	"armormovement/rattle9.mp3",
};

ITEM.walkSound = {
	"armormovement/rattle1.mp3",
	"armormovement/rattle2.mp3",
	"armormovement/rattle3.mp3",
	"armormovement/rattle4.mp3",
	"armormovement/rattle5.mp3",
	"armormovement/rattle6.mp3",
	"armormovement/rattle7.mp3",
	"armormovement/rattle8.mp3",
	"armormovement/rattle9.mp3",
};

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Grockling Iconoclast Garb";
ITEM.model = "models/begotten/headgroup_props/grokcrastarmor.mdl"
ITEM.iconoverride = "materials/begotten/ui/itemicons/grokcrastarmor.png"
ITEM.category = "Armor"
ITEM.concealsFace = true;
ITEM.conditionScale = 0.9
ITEM.hasHelmet = true;
ITEM.hitParticle = "GlassImpact";
ITEM.protection = 30;
ITEM.weight = 1.25;
ITEM.weightclass = "Light";
ITEM.type = "leather";
ITEM.description = "The Grockling Iconoclasts are fanatics of a different breed. They stand to mock those of Clan Crast in particular by wearing ancient and forbidden effigies. A Grockling Iconoclast is a truly terrifying sight, for they herald the coming of many more Grocklings who follow their leader into oblivion.";
ITEM.useSound = "npc/combine_soldier/zipline_clothing2.wav";
ITEM.attributes = {"godless", "iconoclast", "fear"};
ITEM.requiredFactions = {"Goreic Warrior"};
ITEM.excludedSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Ghorst"};
ITEM.overlay = "begotten/zomboverlay/new/goreminotaur";

ITEM.effectiveLimbs = {
	[HITGROUP_HEAD] = true,
}

ITEM.bluntScale = 0.55; -- reduces blunt damage by 45%
ITEM.stabilityScale = 0.55; -- reduces stability damage by 45%
ITEM.insulation = 30;

ITEM.components = {breakdownType = "breakdown", items = {"human_bone", "human_bone", "human_bone", "human_bone", "quill", "quill"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	return "models/begotten/goreicwarfighters/grokcrast.mdl";
end;

ITEM:Register();
