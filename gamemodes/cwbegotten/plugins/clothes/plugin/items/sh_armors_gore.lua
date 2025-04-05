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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock", "Clan Gore", "Clan Shagalax", "Clan Harald", "Clan Reaver"};

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
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock", "Clan Gore", "Clan Shagalax", "Clan Harald", "Clan Reaver"};

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.95; -- reduces pierce damage by 5%
ITEM.slashScale = 0.90; -- reduces slash damage by 10%
ITEM.stabilityScale = 0.90; -- reduces stability damage by 10%
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
ITEM.requireFaction = {"Goreic Warrior"};

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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Reaver"};

ITEM.effectiveLimbs = {
	[HITGROUP_HEAD] = true,
}

ITEM.bluntScale = 0.60; -- reduces blunt damage by 40%
ITEM.stabilityScale = 0.60; -- reduces stability damage by 40%
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
ITEM.requireFaction = {"Goreic Warrior", "Wanderer"};
ITEM.excludeSubfactions = {"Clan Grock"};

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
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock"};

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Reaver", "Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast"};
ITEM.overlay = "begotten/zomboverlay/skullhelm";

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
ITEM.stabilityScale = 0.80; -- reduces stability damage by 25%
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
ITEM.requireFaction = {"Goreic Warrior"};

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
ITEM.stabilityScale = 0.90; -- reduces stability damage by 10%
ITEM.insulation = 60;

ITEM.components = {breakdownType = "breakdown", items = {"leather", "leather", "cloth", "cloth"}};

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)

end;

ITEM:Register();

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Haralder Chainmail";
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
ITEM.description = "A sleeveless chainmail set over leather garb, stylized in Clan Haralder's fashion. The patchwork leather smells of the sea.";
ITEM.useSound = "armormovement/body-armor-b4.WAV.mp3";
ITEM.requireFaction = {"Goreic Warrior", "Wanderer"};
ITEM.excludeSubfactions = {"Clan Grock"};

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
ITEM.pierceScale = 0.80; -- reduces pierce damage by 20%
ITEM.slashScale = 0.75; -- reduces slash damage by 25%
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock"};

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.70; -- reduces pierce damage by 30%
ITEM.slashScale = 0.60; -- reduces slash damage by 40%
ITEM.bulletScale = 0.75; -- reduces bullet damage by 25%
ITEM.stabilityScale = 0.70; -- reduces stability damage by 30%
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
ITEM.requireFaction = {"Goreic Warrior", "Wanderer"};
ITEM.excludeSubfactions = {"Clan Grock"};

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
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Grock"};
ITEM.requireRank = {"King's Chosen"};

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
ITEM.stabilityScale = 0.75; -- reduces stability damage by 35%
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
ITEM.requireFaction = {"Goreic Warrior", "Wanderer"};
ITEM.excludeSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock"};

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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
ITEM.requireFaction = {"Goreic Warrior"};
ITEM.excludeSubfactions = {"Clan Harald", "Clan Gore", "Clan Shagalax", "Clan Crast", "Clan Grock"};

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

ITEM.bluntScale = 0.85; -- reduces blunt damage by 15%
ITEM.pierceScale = 0.85; -- reduces pierce damage by 15%
ITEM.slashScale = 0.70; -- reduces slash damage by 30%
ITEM.stabilityScale = 0.80; -- reduces stability damage by 20%
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