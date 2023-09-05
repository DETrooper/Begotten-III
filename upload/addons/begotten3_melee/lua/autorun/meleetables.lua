local MeleeSoundTable = {}
-- OPTIMIZE NOTE: all of this stuff should be ordered better, not really for optimization but for general readability

local ent = nil;

function AddSoundTable(weaponName, newTable)
	MeleeSoundTable[weaponName] = table.Copy(newTable);
end;

function GetSound(weaponName, soundKey)
	if (MeleeSoundTable[weaponName] and MeleeSoundTable[weaponName][soundKey]) then
		local sound = MeleeSoundTable[weaponName][soundKey];
		if (type(sound) == "table") then
			sound = table.Random(sound)
		end; 
		return sound
	end;
end;

function GetSoundTable(weaponName)
	if (MeleeSoundTable[weaponName]) then
		return MeleeSoundTable[weaponName]
	end;
	--print("GetSoundTable - invalid key "..tostring(weaponName).."!")
end;

-- Shield Damage Reduction Table

function GetShieldString(class)
	if (class and isstring(class)) then
		local tas = string.find(class, "shield")
		if (!tas) then return end;
		local ta = string.ToTable(class);
		local neta = {};
		
		for i = 1, #ta do 
			if (i >= tas) then
				neta[#neta + 1] = ta[i];
			end;
		end;
		
		return table.concat(neta, "");
	end;
end;

function GetShieldReduction(shieldType)
	if (shieldType) then
		local shieldType = string.lower(shieldType);
		
		if (string.find(shieldType, "shield")) then
			if (ShieldDamageReductionTable[shieldType]) then
				return ShieldDamageReductionTable[shieldType];
			end;
		end;
	end;
	
	return 1
end;

ShieldDamageReductionTable = {
	["shield1"] = 0.8, -- Scrap Shield
	["shield2"] = 0.95, -- Slaveshield
	["shield3"] = 0.75, -- Car Door Shield
	["shield4"] = 0.95, -- Buckler
	["shield5"] = 0.9, -- Wooden Shield
	["shield6"] = 0.8, -- Iron Shield
	["shield7"] = 0.8, -- Knight's Shield
	["shield8"] = 0.8, -- Spiked Shield
	["shield9"] = 0.7, -- Sol Sentinel Shield
	["shield10"] = 0.7, -- Gore Guardian Shield
	["shield11"] = 0.8, -- Gatekeeper Shield
	["shield12"] = 0.8, -- Warfighter Shield
	["shield13"] = 0.8, -- Dreadshield
	["shield14"] = 0.9, -- Clan Shield
	["shieldunique1"] = 0.8, -- Red Wolf Skinshield (Unique)
	["shieldunique2"] = 0.8, -- Sol Shield (Unique)
};

-- Attack Sound Tables

local AttackSoundTables = {};

AttackSoundTables.DefaultAttackSoundTable = {
	["primarysound"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Swing sound
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Alternate attack swing sound (thrust/swipe/etc)
	["hitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Impact sound against player/NPC
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Alternate attack impact sound against player/NPC (thrust/swipe/etc)
	["hitworld"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Impact sound against world
	["criticalswing"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Sound of a riposte attack after a successful parry
	["parryswing"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Sound of a parry swing (pressing R)
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"}, -- Plays when selecting the weapon
};

AttackSoundTables.PunchAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Punch_01.wav", "weapons/Punch_02.wav", "weapons/Punch_03.wav", "weapons/Punch_04.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav", "weapons/Medium_06.wav", "weapons/Medium_07.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.MetalFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["parryswing"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.LeatherFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav", "weapons/Medium_06.wav", "weapons/Medium_07.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.MetalSpikeFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["parryswing"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.MetalSpikeAttackSoundTable = {
	["primarysound"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.HeavyWoodenAttackSoundTable = {
	["primarysound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/wooden_to_wooden_01.wav", "weapons/wooden_to_wooden_02.wav", "weapons/wooden_to_wooden_03.wav", "weapons/wooden_to_wooden_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.MediumWoodenAttackSoundTable = {
	["primarysound"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["hitworld"] = {"weapons/wooden_to_wooden_01.wav", "weapons/wooden_to_wooden_02.wav", "weapons/wooden_to_wooden_03.wav", "weapons/wooden_to_wooden_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.HeavyMetalAttackSoundTable = {
	["primarysound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"armor/cut_01.wav", "armor/cut_02.wav", "armor/cut_03.wav", "armor/cut_04.wav", "armor/cut_05.wav", "armor/cut_06.wav", "armor/cut_07.wav", "armor/cut_08.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-sword-large.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_axe_draw1.mp3"},
};

AttackSoundTables.MediumMetalAttackSoundTable = {
	["primarysound"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"armor/cut_01.wav", "armor/cut_02.wav", "armor/cut_03.wav", "armor/cut_04.wav", "armor/cut_05.wav", "armor/cut_06.wav", "armor/cut_07.wav", "armor/cut_08.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-sword.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_waraxe_draw1.mp3"},
};

AttackSoundTables.SmallMetalAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"armor/cut_01.wav", "armor/cut_02.wav", "armor/cut_03.wav", "armor/cut_04.wav", "armor/cut_05.wav", "armor/cut_06.wav", "armor/cut_07.wav", "armor/cut_08.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-sword.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_mace_draw1.mp3"},
};

AttackSoundTables.MetalPolearmAttackSoundTable = {
	["primarysound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"armor/cut_01.wav", "armor/cut_02.wav", "armor/cut_03.wav", "armor/cut_04.wav", "armor/cut_05.wav", "armor/cut_06.wav", "armor/cut_07.wav", "armor/cut_08.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_mace_draw1.mp3"},
};

AttackSoundTables.MetalBluntPolearmAttackSoundTable = {
	["primarysound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_mace_draw1.mp3"},
};

AttackSoundTables.MaximusWrathAttackSoundTable = {
	["primarysound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/stunstick/alyx_stunner1.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"buttons/button19.wav"},
};

AttackSoundTables.MediumMetalBluntAttackSoundTable = {
	["primarysound"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_mace_draw1.mp3"},
};

AttackSoundTables.SmallMetalBluntAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/swing-sword.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_mace_draw1.mp3"},
};

AttackSoundTables.BluntMetalSpearAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-sword2.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.MetalSpearAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-sword2.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.MetalDaggerAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-sword2.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_waraxe_draw1.mp3"},
};

AttackSoundTables.MetalClawsAttackSoundTable = {
	["primarysound"] = {"weapons/imbrokeru_knife/knife_slash1.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"armor/cut_01.wav", "armor/cut_02.wav", "armor/cut_03.wav", "armor/cut_04.wav", "armor/cut_05.wav", "armor/cut_06.wav", "armor/cut_07.wav", "armor/cut_08.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/comboattack4.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"weapons/knife/knife_deploy1.wav"},
};

AttackSoundTables.DualSwordsAttackSoundTable = {
	["primarysound"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"meleesounds/kill1.wav.mp3", "meleesounds/kill2.wav.mp3"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/metal_weapon_to_ground_01.wav", "weapons/metal_weapon_to_ground_02.wav", "weapons/metal_weapon_to_ground_03.wav", "weapons/metal_weapon_to_ground_04.wav", "weapons/metal_weapon_to_ground_05.wav"},
	["criticalswing"] = {"meleesounds/comboattack1.wav.mp3"},
	["parryswing"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["drawsound"] = {"draw/skyrim_waraxe_draw1.mp3"},
};

AttackSoundTables.BellHammerAttackSoundTable = {
	["primarysound"] = {"meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"meleesounds/DS2HammerHeavySwing.mp3"},
	["criticalswing"] = {"meleesounds/DS2HammerLightSwing.mp3"},
	["parryswing"] = {"weapons/Large_01.wav", "weapons/Large_02.wav", "weapons/Large_03.wav", "weapons/Large_04.wav", "weapons/Large_05.wav", "weapons/Large_06.wav", "weapons/Large_07.wav", "weapons/Large_08.wav", "weapons/Large_09.wav", "weapons/Large_10.wav"},
	["drawsound"] = {"draw/skyrim_warhammer_draw1.mp3"},
};

AttackSoundTables.HeavyStoneAttackSoundTable = {
	["primarysound"] = {"meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3", "meleesounds/DS2HammerLightSwing.mp3"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"physics/concrete/concrete_block_impact_hard1.wav", "physics/concrete/concrete_block_impact_hard2.wav", "physics/concrete/concrete_block_impact_hard3.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AddSoundTable("DefaultAttackSoundTable", AttackSoundTables.DefaultAttackSoundTable)
AddSoundTable("HeavyWoodenAttackSoundTable", AttackSoundTables.HeavyWoodenAttackSoundTable)
AddSoundTable("MediumWoodenAttackSoundTable", AttackSoundTables.MediumWoodenAttackSoundTable)
AddSoundTable("PunchAttackSoundTable", AttackSoundTables.PunchAttackSoundTable)
AddSoundTable("MetalFistedAttackSoundTable", AttackSoundTables.MetalFistedAttackSoundTable)
AddSoundTable("MetalSpikeFistedAttackSoundTable", AttackSoundTables.MetalSpikeFistedAttackSoundTable)
AddSoundTable("MetalSpikeAttackSoundTable", AttackSoundTables.MetalSpikeAttackSoundTable)
AddSoundTable("LeatherFistedAttackSoundTable", AttackSoundTables.LeatherFistedAttackSoundTable)
AddSoundTable("HeavyMetalAttackSoundTable", AttackSoundTables.HeavyMetalAttackSoundTable)
AddSoundTable("MediumMetalAttackSoundTable", AttackSoundTables.MediumMetalAttackSoundTable)
AddSoundTable("SmallMetalAttackSoundTable", AttackSoundTables.SmallMetalAttackSoundTable)
AddSoundTable("MetalPolearmAttackSoundTable", AttackSoundTables.MetalPolearmAttackSoundTable)
AddSoundTable("MetalBluntPolearmAttackSoundTable", AttackSoundTables.MetalBluntPolearmAttackSoundTable)
AddSoundTable("MediumMetalBluntAttackSoundTable", AttackSoundTables.MediumMetalBluntAttackSoundTable)
AddSoundTable("SmallMetalBluntAttackSoundTable", AttackSoundTables.SmallMetalBluntAttackSoundTable)
AddSoundTable("MetalSpearAttackSoundTable", AttackSoundTables.MetalSpearAttackSoundTable)
AddSoundTable("MetalDaggerAttackSoundTable", AttackSoundTables.MetalDaggerAttackSoundTable)
AddSoundTable("MetalClawsAttackSoundTable", AttackSoundTables.MetalClawsAttackSoundTable)
AddSoundTable("DualSwordsAttackSoundTable", AttackSoundTables.DualSwordsAttackSoundTable)
AddSoundTable("BellHammerAttackSoundTable", AttackSoundTables.BellHammerAttackSoundTable)
AddSoundTable("HeavyStoneAttackSoundTable", AttackSoundTables.HeavyStoneAttackSoundTable)
AddSoundTable("BluntMetalSpearAttackSoundTable", AttackSoundTables.BluntMetalSpearAttackSoundTable)
AddSoundTable("MaximusWrathAttackSoundTable", AttackSoundTables.MaximusWrathAttackSoundTable)

-- Block Sound Tables

local BlockSoundTables = {};

BlockSoundTables.DefaultBlockSoundTable = {
	["blocksound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["deflectsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["blockmetal"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["deflectmetal"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["blockwood"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["deflectwood"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["blockmetalpierce"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["deflectmetalpierce"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["blockpunch"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["deflectpunch"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["blockmissile"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["guardsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

BlockSoundTables.FistBlockSoundTable = {
	["blocksound"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectsound"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockmetal"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectmetal"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockwood"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectwood"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockmetalpierce"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectmetalpierce"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockpunch"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectpunch"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockmissile"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["guardsound"] = {"generic_ui/Generic_04.wav", "generic_ui/Generic_05.wav"},
};

BlockSoundTables.MetalBlockSoundTable = {
	["blocksound"] = {"weapons/Metal_Metal_01.wav", "weapons/Metal_Metal_02.wav", "weapons/Metal_Metal_03.wav", "weapons/Metal_Metal_04.wav", "weapons/Metal_Metal_05.wav", "weapons/Metal_Metal_06.wav", "weapons/Metal_Metal_07.wav", "weapons/Metal_Metal_08.wav", "weapons/Metal_Metal_09.wav", "weapons/Metal_Metal_10.wav", "weapons/Metal_Metal_11.wav", "weapons/Metal_Metal_12.wav", "weapons/Metal_Metal_13.wav", "weapons/Metal_Metal_14.wav"},
	["deflectsound"] = {"weapons/Metal_Metal_active_01.wav", "weapons/Metal_Metal_active_02.wav", "weapons/Metal_Metal_active_03.wav", "weapons/Metal_Metal_active_04.wav"},
	["blockmetal"] = {"weapons/Metal_Metal_01.wav", "weapons/Metal_Metal_02.wav", "weapons/Metal_Metal_03.wav", "weapons/Metal_Metal_04.wav", "weapons/Metal_Metal_05.wav", "weapons/Metal_Metal_06.wav", "weapons/Metal_Metal_07.wav", "weapons/Metal_Metal_08.wav", "weapons/Metal_Metal_09.wav", "weapons/Metal_Metal_10.wav", "weapons/Metal_Metal_11.wav", "weapons/Metal_Metal_12.wav", "weapons/Metal_Metal_13.wav", "weapons/Metal_Metal_14.wav"},
	["deflectmetal"] = {"weapons/Metal_Metal_active_01.wav", "weapons/Metal_Metal_active_02.wav", "weapons/Metal_Metal_active_03.wav", "weapons/Metal_Metal_active_04.wav"},
	["blockwood"] = {"weapons/wood_to_metal_01.wav", "weapons/wood_to_metal_02.wav", "weapons/wood_to_metal_03.wav", "weapons/wood_to_metal_04.wav"},
	["deflectwood"] = {"weapons/wooden_to_wooden_active_05.wav", "weapons/wooden_to_wooden_active_06.wav", "weapons/wooden_to_wooden_active_07.wav", "weapons/wooden_to_wooden_active_08.wav"},
	["blockmetalpierce"] = {"weapons/Metal_Metal_01.wav", "weapons/Metal_Metal_02.wav", "weapons/Metal_Metal_03.wav", "weapons/Metal_Metal_04.wav", "weapons/Metal_Metal_05.wav", "weapons/Metal_Metal_06.wav", "weapons/Metal_Metal_07.wav", "weapons/Metal_Metal_08.wav", "weapons/Metal_Metal_09.wav", "weapons/Metal_Metal_10.wav", "weapons/Metal_Metal_11.wav", "weapons/Metal_Metal_12.wav", "weapons/Metal_Metal_13.wav", "weapons/Metal_Metal_14.wav"},
	["deflectmetalpierce"] = {"weapons/Metal_Metal_active_01.wav", "weapons/Metal_Metal_active_02.wav", "weapons/Metal_Metal_active_03.wav", "weapons/Metal_Metal_active_04.wav"},
	["blockpunch"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["deflectpunch"] = {"weapons/punch_wood_01.wav", "weapons/punch_wood_02.wav", "weapons/punch_wood_03.wav"},
	["blockmissile"] = {"weapons/missile_to_metal_shield_01.wav", "weapons/missile_to_metal_shield_02.wav", "weapons/missile_to_metal_shield_03.wav", "weapons/missile_to_metal_shield_04.wav" },
	["guardsound"] = {"generic_ui/Generic_04.wav", "generic_ui/Generic_05.wav"},
};

BlockSoundTables.WoodenBlockSoundTable = {
	["blocksound"] = {"weapons/wooden_to_wooden_01.wav", "weapons/wooden_to_wooden_02.wav", "weapons/wooden_to_wooden_03.wav", "weapons/wooden_to_wooden_04.wav"},
	["deflectsound"] = {"weapons/metal_to_wood_active_01.wav", "weapons/metal_to_wood_active_02.wav", "weapons/metal_to_wood_active_03.wav", "weapons/metal_to_wood_active_04.wav", "weapons/metal_to_wood_active_05.wav", "weapons/metal_to_wood_active_06.wav"},
	["blockmetal"] = {"weapons/metal_to_wood_01.wav", "weapons/metal_to_wood_02.wav", "weapons/metal_to_wood_03.wav", "weapons/metal_to_wood_04.wav"},
	["deflectmetal"] = {"weapons/metal_to_wood_active_01.wav", "weapons/metal_to_wood_active_02.wav", "weapons/metal_to_wood_active_03.wav", "weapons/metal_to_wood_active_04.wav", "weapons/metal_to_wood_active_05.wav", "weapons/metal_to_wood_active_06.wav"},
	["blockwood"] = {"weapons/wooden_to_wooden_01.wav", "weapons/wooden_to_wooden_02.wav", "weapons/wooden_to_wooden_03.wav", "weapons/wooden_to_wooden_04.wav"},
	["deflectwood"] = {"weapons/wooden_to_wooden_active_05.wav", "weapons/wooden_to_wooden_active_06.wav", "weapons/wooden_to_wooden_active_07.wav", "weapons/wooden_to_wooden_active_08.wav"},
	["blockmetalpierce"] = {"weapons/PierceWood_01.wav", "weapons/PierceWood_02.wav", "weapons/PierceWood_03.wav", "weapons/PierceWood_04.wav"},
	["deflectmetalpierce"] = {"weapons/metal_to_wood_active_01.wav", "weapons/metal_to_wood_active_02.wav", "weapons/metal_to_wood_active_03.wav", "weapons/metal_to_wood_active_04.wav", "weapons/metal_to_wood_active_05.wav", "weapons/metal_to_wood_active_06.wav"},
	["blockpunch"] = {"weapons/punch_wood_01.wav", "weapons/punch_wood_02.wav", "weapons/punch_wood_03.wav"},
	["deflectpunch"] = {"weapons/punch_wood_01.wav", "weapons/punch_wood_02.wav", "weapons/punch_wood_03.wav"},
	["blockmissile"] = {"weapons/arrow_to_shield_01.wav", "weapons/arrow_to_shield_02.wav", "weapons/arrow_to_shield_03.wav", "weapons/arrow_to_shield_04.wav" },
	["guardsound"] = {"generic_ui/Generic_04.wav", "generic_ui/Generic_05.wav"},
};

BlockSoundTables.WoodenShieldSoundTable = {
	["blocksound"] = {"weapons/wooden_weapon_to_shield_01.wav", "weapons/wooden_weapon_to_shield_02.wav", "weapons/wooden_weapon_to_shield_03.wav", "weapons/wooden_weapon_to_shield_04.wav"},
	["deflectsound"] = {"weapons/wood_shield_active_01.wav", "weapons/wood_shield_active_02.wav", "weapons/wood_shield_active_03.wav"},
	["blockmetal"] = {"weapons/Wood_Shield_01.wav", "weapons/Wood_Shield_02.wav", "weapons/Wood_Shield_03.wav", "weapons/Wood_Shield_04.wav", "weapons/Wood_Shield_05.wav", "weapons/Wood_Shield_06.wav", "weapons/Wood_Shield_07.wav"},
	["deflectmetal"] = {"weapons/wood_shield_active_01.wav", "weapons/wood_shield_active_02.wav", "weapons/wood_shield_active_03.wav"},
	["blockwood"] = {"weapons/wooden_weapon_to_shield_01.wav", "weapons/wooden_weapon_to_shield_02.wav", "weapons/wooden_weapon_to_shield_03.wav", "weapons/wooden_weapon_to_shield_04.wav"},
	["deflectwood"] = {"weapons/wooden_weapon_to_shield_active_01.wav", "weapons/wooden_weapon_to_shield_active_02.wav", "weapons/wooden_weapon_to_shield_active_03.wav"},
	["blockmetalpierce"] = {"weapons/PierceWood_01.wav", "weapons/PierceWood_02.wav", "weapons/PierceWood_03.wav", "weapons/PierceWood_04.wav"},
	["deflectmetalpierce"] = {"weapons/wood_shield_active_01.wav", "weapons/wood_shield_active_02.wav", "weapons/wood_shield_active_03.wav"},
	["blockpunch"] = {"weapons/punch_shield_01.wav", "weapons/punch_shield_02.wav"},
	["deflectpunch"] = {"weapons/punch_wood_01.wav", "weapons/punch_wood_02.wav", "weapons/punch_wood_03.wav"},
	["blockmissile"] = {"weapons/arrow_to_shield_01.wav", "weapons/arrow_to_shield_02.wav", "weapons/arrow_to_shield_03.wav", "weapons/arrow_to_shield_04.wav" },
	["guardsound"] = {"physics/wood/wood_solid_impact_hard1.wav", "physics/wood/wood_solid_impact_hard2.wav", "physics/wood/wood_solid_impact_hard3.wav"},
};

BlockSoundTables.MetalShieldSoundTable = {
	["blocksound"] = {"weapons/metal_weapon_to_metal_shield_01.wav", "weapons/metal_weapon_to_metal_shield_02.wav", "weapons/metal_weapon_to_metal_shield_03.wav", "weapons/metal_weapon_to_metal_shield_04.wav"},
	["deflectsound"] = {"weapons/scrape_to_metal_shield_01.wav", "weapons/scrape_to_metal_shield_02.wav", "weapons/scrape_to_metal_shield_03.wav"},
	["blockmetal"] = {"weapons/metal_weapon_to_metal_shield_01.wav", "weapons/metal_weapon_to_metal_shield_02.wav", "weapons/metal_weapon_to_metal_shield_03.wav", "weapons/metal_weapon_to_metal_shield_04.wav"},
	["deflectmetal"] = {"weapons/scrape_to_metal_shield_01.wav", "weapons/scrape_to_metal_shield_02.wav", "weapons/scrape_to_metal_shield_03.wav"},
	["blockwood"] = {"weapons/wood_weapon_to_metal_shield_01.wav", "weapons/wood_weapon_to_metal_shield_02.wav", "weapons/wood_weapon_to_metal_shield_03.wav", "weapons/wood_weapon_to_metal_shield_04.wav"},
	["deflectwood"] = {"weapons/wooden_weapon_to_shield_active_01.wav", "weapons/wooden_weapon_to_shield_active_02.wav", "weapons/wooden_weapon_to_shield_active_03.wav"},
	["blockmetalpierce"] = {"weapons/metal_weapon_to_metal_shield_01.wav", "weapons/metal_weapon_to_metal_shield_02.wav", "weapons/metal_weapon_to_metal_shield_03.wav", "weapons/metal_weapon_to_metal_shield_04.wav"},
	["deflectmetalpierce"] = {"weapons/Metal_Metal_active_01.wav", "weapons/Metal_Metal_active_02.wav", "weapons/Metal_Metal_active_03.wav", "weapons/Metal_Metal_active_04.wav"},
	["blockpunch"] = {"weapons/bash_to_metal_shield_01.wav", "weapons/bash_to_metal_shield_02.wav", "weapons/bash_to_metal_shield_03.wav", "weapons/bash_to_metal_shield_04.wav"},
	["deflectpunch"] = {"weapons/punch_block_01.wav", "weapons/punch_block_02.wav", "weapons/punch_block_03.wav", "weapons/punch_block_04.wav", "weapons/punch_block_05.wav", "weapons/punch_block_06.wav", "weapons/punch_block_07.wav"},
	["blockmissile"] = {"weapons/missile_to_metal_shield_01.wav", "weapons/missile_to_metal_shield_02.wav", "weapons/missile_to_metal_shield_03.wav", "weapons/missile_to_metal_shield_04.wav" },
	["guardsound"] = {"physics/metal/metal_canister_impact_soft1.wav", "physics/metal/metal_canister_impact_soft2.wav", "physics/metal/metal_canister_impact_soft3.wav"},
};

AddSoundTable("DefaultBlockSoundTable", BlockSoundTables.DefaultBlockSoundTable)
AddSoundTable("FistBlockSoundTable", BlockSoundTables.FistBlockSoundTable)
AddSoundTable("WoodenBlockSoundTable", BlockSoundTables.WoodenBlockSoundTable) 
AddSoundTable("MetalBlockSoundTable", BlockSoundTables.MetalBlockSoundTable) 
AddSoundTable("WoodenShieldSoundTable", BlockSoundTables.WoodenShieldSoundTable) 
AddSoundTable("MetalShieldSoundTable", BlockSoundTables.MetalShieldSoundTable) 

-- Melee Stat Tables 

tabs = {};

function AddTable(uniqueID, tabl)
	if (uniqueID and tabl) then
		tabs[uniqueID] = table.Copy(tabl);
	end;
end;

function GetTable(uniqueID)
	if (istable(uniqueID)) then
		return uniqueID;
	end;
	if (uniqueID) then
		return tabs[uniqueID]
	end;
	
	--printp("Invalid GetTable uniqueID: "..tostring(uniqueID));
	
	return {};
end;

local AttackTables = {};

AttackTables.DefaultAttackTable = {
	["primarydamage"] = 10, -- Base damage before multipliers
	["dmgtype"] = 128, -- 4 for Slash, 128 for Blunt, 16 for Pierce
	["attacktype"] = "reg_swing", -- Damage entity that is spawned after a swing. For special weapon types only
	["canaltattack"] = false, -- Alternate attack stance, such as thrust or swipe
	["altattackdamagemodifier"] = 1, -- Modifies damage of alt attack
	["altattackpoisedamagemodifier"] = 0.5, -- Modifies poise damage of alt attack
	["armorpiercing"] = 0, -- Damage multiplier against armored foes 0-100
	["altarmorpiercing"] = 0, -- Damage multiplier against armored foes (for alt attack) 0-100
	["poisedamage"] = 0, -- Poise damage against blockers
	["stabilitydamage"] = 0, -- For knocking people down
	["takeammo"] = 3, -- Poise cost for each swing
	["delay"] = 1, -- Weapon attack delay
	["striketime"] = 0.4, -- Weapon attack speed
	["meleerange"] = 500, -- Weapon reach
	["punchstrength"] = Angle(0,1,0), -- Viewpunch when swinging
};

AttackTables.FistAttackTable = {
	["primarydamage"] = 5,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = 0,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 0,
	["stabilitydamage"] = 10,
	["takeammo"] = 1,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 525,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.IronJavelinAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 1073741824,
	["armorpiercing"] = 50,
	["poisedamage"] = 50,
	["stabilitydamage"] = 60,
	["takeammo"] = 20,
	["delay"] = 0.5,
	["striketime"] = 0.6,
	["punchstrength"] = Angle(0,4,0),
};

AttackTables.PilumAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 1073741824,
	["armorpiercing"] = 80,
	["poisedamage"] = 125,
	["stabilitydamage"] = 75,
	["takeammo"] = 25,
	["delay"] = 0.5,
	["striketime"] = 0.6,
	["punchstrength"] = Angle(0,4,0),
};

AttackTables.TrainingJavelinAttackTable = {
	["primarydamage"] = 15,
	["dmgtype"] = 128,
	["armorpiercing"] = 0,
	["poisedamage"] = 50,
	["stabilitydamage"] = 35,
	["takeammo"] = 20,
	["delay"] = 0.5,
	["striketime"] = 0.6,
	["punchstrength"] = Angle(0,4,0),
};

AttackTables.ClaymoreAttackTable = {
	["primarydamage"] = 80,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.35,
	["striketime"] = 0.6,
	["meleerange"] = 990,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HaralderWarAxeAttackTable = {
	["primarydamage"] = 85,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.45,
	["striketime"] = 0.65,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ClubAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 28,
	["stabilitydamage"] = 45,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HeavyBattleAxeAttackTable = {
	["primarydamage"] = 90,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 800,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WarClubAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 45,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.InquisitorSwordAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 18,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleerange"] = 950,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SamuraiSwordAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 13,
	["stabilitydamage"] = 0,
	["takeammo"] = 0,
	["delay"] = 1,
	["striketime"] = 0.6,
	["meleerange"] = 5000,
	["punchstrength"] = Angle(0,0,0),
};

AttackTables.SkylightSwordAttackTable = {
	["primarydamage"] = 190,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = 90,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.5,
	["striketime"] = 0.6,
	["meleerange"] = 975,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.UnholySigilSwordAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 30,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.6,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.UnholySigilSword_Fire_AttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 30,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.6,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.UnholySigilSword_Ice_AttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 30,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.6,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HellfireSwordAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.35,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BattleAxeAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GatekeeperPoleaxeAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 25,
	["stabilitydamage"] = 15,
	["takeammo"] = 4,
	["delay"] = 1.3,
	["striketime"] = 0.55,
	["meleerange"] = 1000,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.HalberdAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 30,
	["stabilitydamage"] = 20,
	["takeammo"] = 6,
	["delay"] = 1.45,
	["striketime"] = 0.55,
	["meleerange"] = 1250,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.PikeAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.3,
	["altattackpoisedamagemodifier"] = 2,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = 60,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.3,
	["striketime"] = 0.55,
	["meleerange"] = 1500,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.WarSpearAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.3,
	["altattackpoisedamagemodifier"] = 2,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = 60,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.4,
	["striketime"] = 0.55,
	["meleerange"] = 1500,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.SavageClawsAttackTable = {
	["primarydamage"] = 65,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.3,
	["meleerange"] = 625,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SteelClawsAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 17,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.3,
	["meleerange"] = 630,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.IronDaggerAttackTable = {
	["primarydamage"] = 10,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleerange"] = 460,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HarpoonAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.85,
	["striketime"] = 0.35,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.IronSpearAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicSpearAttackTable = {
	["primarydamage"] = 47,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapSpearAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.35,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WingedSpearAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DualShardsAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.8,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(1,2,1),
};

AttackTables.WarScytheAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.7,
	["striketime"] = 0.6,
	["meleerange"] = 1200,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlazicusAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 17,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BlackclawAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapBladeAttackTable = {
	["primarydamage"] = 33,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BellHammerAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 75,
	["stabilitydamage"] = 75,
	["takeammo"] = 12,
	["delay"] = 2.5,
	["striketime"] = 0.9,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,8,0),
};

AttackTables.GoreCleaverAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreClubAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 45,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GrocklingStoneMaulAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 55,
	["stabilitydamage"] = 60,
	["takeammo"] = 10,
	["delay"] = 2.2,
	["striketime"] = 0.9,
	["meleerange"] = 925,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GrocklingSacredStoneMaulAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 60,
	["stabilitydamage"] = 65,
	["takeammo"] = 10,
	["delay"] = 2.3,
	["striketime"] = 0.9,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreWarAxeAttackTable = {
	["primarydamage"] = 90,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 32,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.55,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ReaverWarAxeAttackTable = {
	["primarydamage"] = 80,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 7,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreFalchionAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.5,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreBattleAxeAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PolehammerAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.3,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 35,
	["stabilitydamage"] = 40,
	["takeammo"] = 6,
	["delay"] = 1.55,
	["striketime"] = 0.55,
	["meleerange"] = 1280,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.IronRapierAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = nil,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 725,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ElegantEpeeAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = nil,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleerange"] = 740,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.FlangedMaceAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.2,
	["altattackpoisedamagemodifier"] = 0.4,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 40,
	["stabilitydamage"] = 45,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.MorningStarAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 40,
	["stabilitydamage"] = 45,
	["takeammo"] = 5,
	["delay"] = 1.2,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreHuntingDaggerAttackTable = {
	["primarydamage"] = 14,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.QuickshankAttackTable = {
	["primarydamage"] = 10,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.55,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ParryingDaggerAttackTable = {
	["primarydamage"] = 12,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.KnightsbaneAttackTable = {
	["primarydamage"] = 12,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 480,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ElegantDaggerAttackTable = {
	["primarydamage"] = 18,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 490,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreShortswordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 13,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.IronArmingSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 725,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.LongswordAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ExileKnightSwordAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 22,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleerange"] = 950,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlaiveAttackTable = {
	["primarydamage"] = 85,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.55,
	["striketime"] = 0.6,
	["meleerange"] = 1250,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreAxeandFalchionAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(1,2,1),
};

AttackTables.IronKnucklesAttackTable = {
	["primarydamage"] = 10,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = 0,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 25,
	["stabilitydamage"] = 35,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 550,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.SpikedKnucklesAttackTable = {
	["primarydamage"] = 17,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = 0,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 20,
	["stabilitydamage"] = 20,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 550,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.CaestusAttackTable = {
	["primarydamage"] = 12,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = 0,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 30,
	["stabilitydamage"] = 35,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 550,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.ShortswordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BatAttackTable = {
	["primarydamage"] = 9,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 15,
	["takeammo"] = 3,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SpikedBatAttackTable = {
	["primarydamage"] = 16,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 10,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BladedBatAttackTable = {
	["primarydamage"] = 27,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BoardAttackTable = {
	["primarydamage"] = 10,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 13,
	["stabilitydamage"] = 15,
	["takeammo"] = 5,
	["delay"] = 1,
	["striketime"] = 0.35,
	["meleerange"] = 735,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SpikedBoardAttackTable = {
	["primarydamage"] = 15,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 7,
	["stabilitydamage"] = 10,
	["takeammo"] = 5,
	["delay"] = 1,
	["striketime"] = 0.35,
	["meleerange"] = 735,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BladedBoardAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.35,
	["meleerange"] = 735,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PipeAttackTable = {
	["primarydamage"] = 6,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 7,
	["stabilitydamage"] = 20,
	["takeammo"] = 2,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 535,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PipeMaceAttackTable = {
	["primarydamage"] = 9,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 12,
	["stabilitydamage"] = 27,
	["takeammo"] = 2,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 535,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.MacheteAttackTable = {
	["primarydamage"] = 23,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 7,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 600,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TwistedMacheteAttackTable = {
	["primarydamage"] = 28,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 600,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.AdminTwistedMacheteAttackTable = {
	["primarydamage"] = 28,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.2,
	["striketime"] = 0.7,
	["meleerange"] = 5000,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScraphammerAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 45,
	["takeammo"] = 8,
	["delay"] = 1.85,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VolthammerAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 80,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 60,
	["stabilitydamage"] = 55,
	["takeammo"] = 8,
	["delay"] = 1.85,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SledgeAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 37,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PickaxeAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 20,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.75,
	["striketime"] = 0.65,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingLongswordAttackTable = {
	["primarydamage"] = 0,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.5,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 20,
	["stabilitydamage"] = 15,
	["takeammo"] = 8,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleerange"] = 975,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.QuarterstaffAttackTable = {
	["primarydamage"] = 5,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nill,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 35,
	["takeammo"] = 3,
	["delay"] = 1.3,
	["striketime"] = 0.55,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingSpearAttackTable = {
	["primarydamage"] = 0,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 20,
	["takeammo"] = 3,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["meleerange"] = 1300,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PitchforkAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleerange"] = 1000,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingSwordAttackTable = {
	["primarydamage"] = 0,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.5,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 20,
	["stabilitydamage"] = 10,
	["takeammo"] = 3,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleerange"] = 725,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HatchetAttackTable = {
	["primarydamage"] = 15,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 9,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 575,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DarkIceDaggerAttackTable = {
	["primarydamage"] = 8,
	["dmgtype"] = 16,
	["attacktype"] = "ice_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 485,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DarkFireDaggerAttackTable = {
	["primarydamage"] = 8,
	["dmgtype"] = 16,
	["attacktype"] = "fire_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 485,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.EnchantedLongswordAttackTable = {
	["primarydamage"] = 60,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.5,
	["striketime"] = 0.6,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlazicSwordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DemonSlayerAxeAttackTable = {
	["primarydamage"] = 125,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 10,
	["delay"] = 2.3,
	["striketime"] = 0.9,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,7,0),
};

AttackTables.ScimitarAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 17,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 17,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BrokenSwordAttackTable = {
	["primarydamage"] = 22,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.6,
	["armorpiercing"] = 10,
	["altarmorpiercing"] = 25,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DemonClawsAttackTable = {
	["primarydamage"] = 65,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 50,
	["takeammo"] = 3,
	["delay"] = 0.65,
	["striketime"] = 0.3,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ReaverBattleAxeAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 23,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.96,
	["striketime"] = 0.4,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreSeaxAttackTable = {
	["primarydamage"] = 32,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.65,
	["striketime"] = 0.3,
	["meleerange"] = 625,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.FamilialSwordAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DruidSwordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 17,
	["altarmorpiercing"] = 27,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BlessedDruidSwordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreMaceAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 40,
	["stabilitydamage"] = 45,
	["takeammo"] = 5,
	["delay"] = 1.3,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ShardAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 18,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 14,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 725,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicMaceAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 40,
	["stabilitydamage"] = 45,
	["takeammo"] = 5,
	["delay"] = 1.25,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DualAxesAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1,
	["striketime"] = 0.35,
	["meleerange"] = 725,
	["punchstrength"] = Angle(1,2,1),
};

AttackTables.DualScimitarsAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 22,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.93,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(1,2,1),
};

AttackTables.SatanicSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 725,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicMaulAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 925,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicLongswordAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleerange"] = 935,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlazicBannerAttackTable = {
	["primarydamage"] = 15,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.5,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleerange"] = 1680,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.DreadaxeAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 40,
	["takeammo"] = 10,
	["delay"] = 2.2,
	["striketime"] = 0.9,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,7,0),
};

AttackTables.WarpedSwordAttackTable = {
	["primarydamage"] = 60,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TwistedClubAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 40,
	["takeammo"] = 5,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltsledgeAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 45,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltswordAttackTable = {
	["primarydamage"] = 32,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.85,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 17,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 7,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 690,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BillhookAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 20,
	["stabilitydamage"] = 25,
	["takeammo"] = 4,
	["delay"] = 1.25,
	["striketime"] = 0.55,
	["meleerange"] = 965,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.LucerneAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.3,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 80,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 40,
	["stabilitydamage"] = 45,
	["takeammo"] = 4,
	["delay"] = 1.3,
	["striketime"] = 0.55,
	["meleerange"] = 970,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.GoreFalxAttackTable = {
	["primarydamage"] = 60,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 15,
	["takeammo"] = 8,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleerange"] = 800,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SkyfallenSwordAttackTable = {
	["primarydamage"] = 165,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = 85,
	["poisedamage"] = 30,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleerange"] = 950,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.FrozenFatherlandAxeAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.55,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.MaximusWrathAttackTable = {
	["primarydamage"] = 666666,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 100,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 75,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltprodAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 20,
	["stabilitydamage"] = 35,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TireIronAttackTable = {
	["primarydamage"] = 5,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 7,
	["stabilitydamage"] = 12,
	["takeammo"] = 2,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleerange"] = 545,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapAxeAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 20,
	["takeammo"] = 2,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleerange"] = 550,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SteelArmingSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicShortswordAttackTable = {
	["primarydamage"] = 32,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.3,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Rekh_AttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Varazdat_AttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Philimaxio_AttackTable = {
	["primarydamage"] = 22,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Kinisger_AttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DualKinisgerDaggersAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.85,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 65,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.35,
	["meleerange"] = 535,
	["punchstrength"] = Angle(1,2,1),
};

AttackTables.DarklanderBardicheAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 40,
	["stabilitydamage"] = 15,
	["takeammo"] = 8,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.EveningStarAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 8,
	["delay"] = 1.45,
	["striketime"] = 0.65,
	["meleerange"] = 800,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WarHammerAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 80,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 35,
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleerange"] = 675,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DualScrapBladesAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.5,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleerange"] = 725,
	["punchstrength"] = Angle(1,2,1),
};

AddTable("DefaultAttackTable", AttackTables.DefaultAttackTable) 
AddTable("FistAttackTable", AttackTables.FistAttackTable) 
AddTable("IronJavelinAttackTable", AttackTables.IronJavelinAttackTable)
AddTable("PilumAttackTable", AttackTables.PilumAttackTable)
AddTable("TrainingJavelinAttackTable", AttackTables.TrainingJavelinAttackTable)
AddTable("ClaymoreAttackTable", AttackTables.ClaymoreAttackTable) 
AddTable("HaralderWarAxeAttackTable", AttackTables.HaralderWarAxeAttackTable) 
AddTable("ClubAttackTable", AttackTables.ClubAttackTable) 
AddTable("HeavyBattleAxeAttackTable", AttackTables.HeavyBattleAxeAttackTable) 
AddTable("WarClubAttackTable", AttackTables.WarClubAttackTable) 
AddTable("InquisitorSwordAttackTable", AttackTables.InquisitorSwordAttackTable) 
AddTable("SamuraiSwordAttackTable", AttackTables.SamuraiSwordAttackTable)
AddTable("SkylightSwordAttackTable", AttackTables.SkylightSwordAttackTable) 
AddTable("UnholySigilSwordAttackTable", AttackTables.UnholySigilSwordAttackTable) 
AddTable("UnholySigilSword_Fire_AttackTable", AttackTables.UnholySigilSword_Fire_AttackTable) 
AddTable("UnholySigilSword_Ice_AttackTable", AttackTables.UnholySigilSword_Ice_AttackTable) 
AddTable("HellfireSwordAttackTable", AttackTables.HellfireSwordAttackTable) 
AddTable("BattleAxeAttackTable", AttackTables.BattleAxeAttackTable) 
AddTable("GatekeeperPoleaxeAttackTable", AttackTables.GatekeeperPoleaxeAttackTable) 
AddTable("HalberdAttackTable", AttackTables.HalberdAttackTable) 
AddTable("PikeAttackTable", AttackTables.PikeAttackTable) 
AddTable("WarSpearAttackTable", AttackTables.WarSpearAttackTable) 
AddTable("SavageClawsAttackTable", AttackTables.SavageClawsAttackTable) 
AddTable("SteelClawsAttackTable", AttackTables.SteelClawsAttackTable) 
AddTable("IronDaggerAttackTable", AttackTables.IronDaggerAttackTable) 
AddTable("HarpoonAttackTable", AttackTables.HarpoonAttackTable) 
AddTable("IronSpearAttackTable", AttackTables.IronSpearAttackTable) 
AddTable("SatanicSpearAttackTable", AttackTables.SatanicSpearAttackTable) 
AddTable("ScrapSpearAttackTable", AttackTables.ScrapSpearAttackTable) 
AddTable("WingedSpearAttackTable", AttackTables.WingedSpearAttackTable) 
AddTable("DualShardsAttackTable", AttackTables.DualShardsAttackTable) 
AddTable("WarScytheAttackTable", AttackTables.WarScytheAttackTable) 
AddTable("GlazicusAttackTable", AttackTables.GlazicusAttackTable)
AddTable("BlackclawAttackTable", AttackTables.BlackclawAttackTable)  
AddTable("ScrapBladeAttackTable", AttackTables.ScrapBladeAttackTable)  
AddTable("BellHammerAttackTable", AttackTables.BellHammerAttackTable)  
AddTable("GoreCleaverAttackTable", AttackTables.GoreCleaverAttackTable)  
AddTable("GoreClubAttackTable", AttackTables.GoreClubAttackTable)  
AddTable("GrocklingStoneMaulAttackTable", AttackTables.GrocklingStoneMaulAttackTable)  
AddTable("GrocklingSacredStoneMaulAttackTable", AttackTables.GrocklingSacredStoneMaulAttackTable)  
AddTable("GoreWarAxeAttackTable", AttackTables.GoreWarAxeAttackTable)  
AddTable("ReaverWarAxeAttackTable", AttackTables.ReaverWarAxeAttackTable)  
AddTable("GoreFalchionAttackTable", AttackTables.GoreFalchionAttackTable)  
AddTable("GoreBattleAxeAttackTable", AttackTables.GoreBattleAxeAttackTable)  
AddTable("PolehammerAttackTable", AttackTables.PolehammerAttackTable)
AddTable("IronRapierAttackTable", AttackTables.IronRapierAttackTable)    
AddTable("ElegantEpeeAttackTable", AttackTables.ElegantEpeeAttackTable) 
AddTable("FlangedMaceAttackTable", AttackTables.FlangedMaceAttackTable)       
AddTable("MorningStarAttackTable", AttackTables.MorningStarAttackTable)      
AddTable("GoreHuntingDaggerAttackTable", AttackTables.GoreHuntingDaggerAttackTable)
AddTable("QuickshankAttackTable", AttackTables.QuickshankAttackTable)    
AddTable("ParryingDaggerAttackTable", AttackTables.ParryingDaggerAttackTable)
AddTable("KnightsbaneAttackTable", AttackTables.KnightsbaneAttackTable)  
AddTable("ElegantDaggerAttackTable", AttackTables.ElegantDaggerAttackTable)    
AddTable("GoreShortswordAttackTable", AttackTables.GoreShortswordAttackTable)  
AddTable("IronArmingSwordAttackTable", AttackTables.IronArmingSwordAttackTable)  
AddTable("LongswordAttackTable", AttackTables.LongswordAttackTable)  
AddTable("ExileKnightSwordAttackTable", AttackTables.ExileKnightSwordAttackTable)       
AddTable("GlaiveAttackTable", AttackTables.GlaiveAttackTable)      
AddTable("GoreAxeandFalchionAttackTable", AttackTables.GoreAxeandFalchionAttackTable) 
AddTable("IronKnucklesAttackTable", AttackTables.IronKnucklesAttackTable)  
AddTable("SpikedKnucklesAttackTable", AttackTables.SpikedKnucklesAttackTable)       
AddTable("CaestusAttackTable", AttackTables.CaestusAttackTable)
AddTable("ShortswordAttackTable", AttackTables.ShortswordAttackTable)
AddTable("BatAttackTable", AttackTables.BatAttackTable)
AddTable("SpikedBatAttackTable", AttackTables.SpikedBatAttackTable)
AddTable("BladedBatAttackTable", AttackTables.BladedBatAttackTable)
AddTable("BoardAttackTable", AttackTables.BoardAttackTable)
AddTable("SpikedBoardAttackTable", AttackTables.SpikedBoardAttackTable)
AddTable("BladedBoardAttackTable", AttackTables.BladedBoardAttackTable)
AddTable("PipeAttackTable", AttackTables.PipeAttackTable)
AddTable("PipeMaceAttackTable", AttackTables.PipeMaceAttackTable)
AddTable("MacheteAttackTable", AttackTables.MacheteAttackTable)
AddTable("TwistedMacheteAttackTable", AttackTables.TwistedMacheteAttackTable)
AddTable("AdminTwistedMacheteAttackTable", AttackTables.AdminTwistedMacheteAttackTable)
AddTable("ScraphammerAttackTable", AttackTables.ScraphammerAttackTable)
AddTable("VolthammerAttackTable", AttackTables.VolthammerAttackTable)
AddTable("SledgeAttackTable", AttackTables.SledgeAttackTable)
AddTable("PickaxeAttackTable", AttackTables.PickaxeAttackTable)
AddTable("TrainingLongswordAttackTable", AttackTables.TrainingLongswordAttackTable)
AddTable("QuarterstaffAttackTable", AttackTables.QuarterstaffAttackTable)
AddTable("TrainingSpearAttackTable", AttackTables.TrainingSpearAttackTable)
AddTable("PitchforkAttackTable", AttackTables.PitchforkAttackTable)
AddTable("TrainingSwordAttackTable", AttackTables.TrainingSwordAttackTable)
AddTable("HatchetAttackTable", AttackTables.HatchetAttackTable)
AddTable("DarkIceDaggerAttackTable", AttackTables.DarkIceDaggerAttackTable)
AddTable("DarkFireDaggerAttackTable", AttackTables.DarkFireDaggerAttackTable)
AddTable("EnchantedLongswordAttackTable", AttackTables.EnchantedLongswordAttackTable)
AddTable("GlazicSwordAttackTable", AttackTables.GlazicSwordAttackTable)
AddTable("DemonSlayerAxeAttackTable", AttackTables.DemonSlayerAxeAttackTable)
AddTable("ScimitarAttackTable", AttackTables.ScimitarAttackTable)
AddTable("BrokenSwordAttackTable", AttackTables.BrokenSwordAttackTable)
AddTable("DemonClawsAttackTable", AttackTables.DemonClawsAttackTable)
AddTable("ReaverBattleAxeAttackTable", AttackTables.ReaverBattleAxeAttackTable)
AddTable("GoreSeaxAttackTable", AttackTables.GoreSeaxAttackTable)
AddTable("FamilialSwordAttackTable", AttackTables.FamilialSwordAttackTable)
AddTable("DruidSwordAttackTable", AttackTables.DruidSwordAttackTable)
AddTable("BlessedDruidSwordAttackTable", AttackTables.BlessedDruidSwordAttackTable)
AddTable("GoreMaceAttackTable", AttackTables.GoreMaceAttackTable)
AddTable("ShardAttackTable", AttackTables.ShardAttackTable)
AddTable("SatanicMaceAttackTable", AttackTables.SatanicMaceAttackTable)
AddTable("DualAxesAttackTable", AttackTables.DualAxesAttackTable)
AddTable("DualScimitarsAttackTable", AttackTables.DualScimitarsAttackTable)
AddTable("SatanicSwordAttackTable", AttackTables.SatanicSwordAttackTable)
AddTable("SatanicMaulAttackTable", AttackTables.SatanicMaulAttackTable)
AddTable("SatanicLongswordAttackTable", AttackTables.SatanicLongswordAttackTable)
AddTable("GlazicBannerAttackTable", AttackTables.GlazicBannerAttackTable)
AddTable("DreadaxeAttackTable", AttackTables.DreadaxeAttackTable)
AddTable("WarpedSwordAttackTable", AttackTables.WarpedSwordAttackTable)
AddTable("TwistedClubAttackTable", AttackTables.TwistedClubAttackTable)
AddTable("VoltsledgeAttackTable", AttackTables.VoltsledgeAttackTable)
AddTable("VoltswordAttackTable", AttackTables.VoltswordAttackTable)
AddTable("BillhookAttackTable", AttackTables.BillhookAttackTable)
AddTable("LucerneAttackTable", AttackTables.LucerneAttackTable)
AddTable("GoreFalxAttackTable", AttackTables.GoreFalxAttackTable)
AddTable("SkyfallenSwordAttackTable", AttackTables.SkyfallenSwordAttackTable)
AddTable("FrozenFatherlandAxeAttackTable", AttackTables.FrozenFatherlandAxeAttackTable)
AddTable("MaximusWrathAttackTable", AttackTables.MaximusWrathAttackTable)
AddTable("VoltprodAttackTable", AttackTables.VoltprodAttackTable)
AddTable("TireIronAttackTable", AttackTables.TireIronAttackTable)
AddTable("ScrapAxeAttackTable", AttackTables.ScrapAxeAttackTable)
AddTable("SteelArmingSwordAttackTable", AttackTables.SteelArmingSwordAttackTable)
AddTable("SatanicShortswordAttackTable", AttackTables.SatanicShortswordAttackTable)
AddTable("Ancestraldagger_Rekh_AttackTable", AttackTables.Ancestraldagger_Rekh_AttackTable)
AddTable("Ancestraldagger_Varazdat_AttackTable", AttackTables.Ancestraldagger_Varazdat_AttackTable)
AddTable("Ancestraldagger_Philimaxio_AttackTable", AttackTables.Ancestraldagger_Philimaxio_AttackTable)
AddTable("Ancestraldagger_Kinisger_AttackTable", AttackTables.Ancestraldagger_Kinisger_AttackTable)
AddTable("DualKinisgerDaggersAttackTable", AttackTables.DualKinisgerDaggersAttackTable)
AddTable("DarklanderBardicheAttackTable", AttackTables.DarklanderBardicheAttackTable)
AddTable("EveningStarAttackTable", AttackTables.EveningStarAttackTable)
AddTable("WarHammerAttackTable", AttackTables.WarHammerAttackTable)
AddTable("DualScrapBladesAttackTable", AttackTables.DualScrapBladesAttackTable)

-- Block Stat Tables

local BlockTables = {};

BlockTables.DefaultBlockTable = {
	["guardblockamount"] = 10, -- Minimum poise taken after blocking
	["specialeffect"] = false, -- Special effect for sacrifical weapons
	["blockeffect"] = "MetalSpark", -- Draws an effect upon blocking
	["blockeffectforward"] = 25, -- How far out the block particle is from the player 
	["blockeffectpos"] = (Vector(0, -5, 65)), -- Position that the block particle appears when hit 
	["blockcone"] = 135, -- Blocks damage in degrees around your eyecursor
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE}, -- Will block these damge types
	["partialbulletblock"] = false, -- Whether or not to block 70% damage from bullets. Make sure DMG_BULLET is not listed above if true.
	["poiseresistance"] = 15, -- Poise damage deducted from enemy attacks
	["raisespeed"] = 1.25, -- Time it takes to raise/lower weapon
	["instantraise"] = false, -- Whether or not the weapon can be raised/lowered instantly (overrides raisespeed)
	["parrydifficulty"] = 0.2, -- Parry frames, more means parrying is easier
	["parrytakestamina"] = 15, -- Poise cost for parrying
	["canparry"] = true, -- Whether or not you can parry
	["candeflect"] = true,
};

BlockTables.FistBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_CLUB},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = false,
	["candeflect"] = true,
};

BlockTables.ClaymoreBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HaralderWarAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ClubBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HeavyBattleAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WarClubBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.InquisitorSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SamuraiSwordBlockTable = {
	["guardblockamount"] = 1,
	["specialeffect"] = true,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 360,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = true,
	["poiseresistance"] = 100,
	["raisespeed"] = 0.1,
	["instantraise"] = true,
	["parrydifficulty"] = 0.05,
	["parrytakestamina"] = 0,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SkylightSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 35,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.UnholySigilSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.UnholySigilSword_Fire_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = true,
	["blockeffect"] = "fire_jet_01_flame",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.UnholySigilSword_Ice_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = true,
	["blockeffect"] = "steam_jet_50_steam",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HellfireSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = true,
	["blockeffect"] = "fire_jet_01_flame",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BattleAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GatekeeperPoleaxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HalberdBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PikeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WarSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SavageClawsBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 0.5,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SteelClawsBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 0.5,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HarpoonBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ScrapSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WingedSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DualShardsBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WarScytheBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GlazicusBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BlackclawBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ScrapBladeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BellHammerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreCleaverBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreClubBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GrocklingStoneMaulBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 25,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GrocklingSacredStoneMaulBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreWarAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ReaverWarAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreFalchionBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 6,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreBattleAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PolehammerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronRapierBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 4,
	["raisespeed"] = 0.5,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ElegantEpeeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 7,
	["raisespeed"] = 0.5,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.FlangedMaceBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.MorningStarBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreHuntingDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.QuickshankBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ParryingDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.KnightsbaneBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ElegantDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreShortswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronArmingSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.LongswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ExileKnightSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GlaiveBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 18,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreAxeandFalchionBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronKnucklesBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = false,
	["candeflect"] = true,
};

BlockTables.SpikedKnucklesBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = false,
	["candeflect"] = true,
};

BlockTables.CaestusBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = false,
	["candeflect"] = true,
};

BlockTables.ShortswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 9,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BatBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SpikedBatBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BladedBatBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BoardBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SpikedBoardBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BladedBoardBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PipeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 55)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PipeMaceBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 55)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.MacheteBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 6,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TwistedMacheteBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.AdminTwistedMacheteBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 360,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 100,
	["raisespeed"] = 0.1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.05,
	["parrytakestamina"] = 0,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ScraphammerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VolthammerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SledgeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PickaxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TrainingLongswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.QuarterstaffBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TrainingSpearBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.PitchforkBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 6,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TrainingSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.HatchetBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 55)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DarkIceDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "steam_jet_50_steam",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DarkFireDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "fire_jet_01_flame",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.EnchantedLongswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = true,
	["blockeffect"] = "steam_jet_50_steam",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DemonSlayerAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ScimitarBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BrokenSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DemonClawsBlockTable = {
	["guardblockamount"] = 2,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 90,
	["raisespeed"] = 0.5,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ReaverBattleAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreSeaxBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.FamilialSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DruidSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BlessedDruidSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = true,
	["blockeffect"] = "fire_jet_01_flame",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 7,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreMaceBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ShardBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 17,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicMaceBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DualAxesBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DualScimitarsBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 16,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.17,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicMaulBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 17,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicLongswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GlazicBannerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 13,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DreadaxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WarpedSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 22,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TwistedClubBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VoltsledgeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VoltswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 9,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.BillhookBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.LucerneBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, 0, 50)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.GoreFalxBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SkyfallenSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 35,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.FrozenFatherlandAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.MaximusWrathBlockTable = {
	["guardblockamount"] = 2,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 50,
	["raisespeed"] = 1.7,
	["instantraise"] = false,
	["parrydifficulty"] = 1,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VoltprodBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 10,
	["blockeffectpos"] = (Vector(0, 0, 60)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.TireIronBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 55)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 3,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.ScrapAxeBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 55)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SteelArmingSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 17,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.SatanicShortswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Ancestraldagger_Rekh_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Ancestraldagger_Varazdat_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Ancestraldagger_Philimaxio_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 8,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Ancestraldagger_Kinisger_BlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(5, 0, 60)),
	["blockcone"] = 135,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 0,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 2,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DualKinisgerDaggersBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 5,
	["raisespeed"] = 1.25,
	["instantraise"] = true,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DarklanderBardicheBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.EveningStarBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 20,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.WarHammerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.DualScrapBladesBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 55)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.17,
	["parrytakestamina"] = 12,
	["canparry"] = true,
	["candeflect"] = true,
};

AddTable("DefaultBlockTable", BlockTables.DefaultBlockTable) 
AddTable("AdminTwistedMacheteBlockTable", BlockTables.AdminTwistedMacheteBlockTable)
AddTable("FistBlockTable", BlockTables.FistBlockTable) 
AddTable("ClaymoreBlockTable", BlockTables.ClaymoreBlockTable) 
AddTable("HaralderWarAxeBlockTable", BlockTables.HaralderWarAxeBlockTable) 
AddTable("ClubBlockTable", BlockTables.ClubBlockTable) 
AddTable("HeavyBattleAxeBlockTable", BlockTables.HeavyBattleAxeBlockTable) 
AddTable("WarClubBlockTable", BlockTables.WarClubBlockTable) 
AddTable("InquisitorSwordBlockTable", BlockTables.InquisitorSwordBlockTable)
AddTable("SamuraiSwordBlockTable", BlockTables.SamuraiSwordBlockTable)
AddTable("SkylightSwordBlockTable", BlockTables.SkylightSwordBlockTable) 
AddTable("UnholySigilSwordBlockTable", BlockTables.UnholySigilSwordBlockTable) 
AddTable("UnholySigilSword_Fire_BlockTable", BlockTables.UnholySigilSword_Fire_BlockTable) 
AddTable("UnholySigilSword_Ice_BlockTable", BlockTables.UnholySigilSword_Ice_BlockTable) 
AddTable("HellfireSwordBlockTable", BlockTables.HellfireSwordBlockTable) 
AddTable("BattleAxeBlockTable", BlockTables.BattleAxeBlockTable) 
AddTable("GatekeeperPoleaxeBlockTable", BlockTables.GatekeeperPoleaxeBlockTable) 
AddTable("HalberdBlockTable", BlockTables.HalberdBlockTable) 
AddTable("PikeBlockTable", BlockTables.PikeBlockTable) 
AddTable("WarSpearBlockTable", BlockTables.WarSpearBlockTable) 
AddTable("SavageClawsBlockTable", BlockTables.SavageClawsBlockTable) 
AddTable("SteelClawsBlockTable", BlockTables.SteelClawsBlockTable) 
AddTable("IronDaggerBlockTable", BlockTables.IronDaggerBlockTable) 
AddTable("HarpoonBlockTable", BlockTables.HarpoonBlockTable) 
AddTable("IronSpearBlockTable", BlockTables.IronSpearBlockTable) 
AddTable("SatanicSpearBlockTable", BlockTables.SatanicSpearBlockTable) 
AddTable("ScrapSpearBlockTable", BlockTables.ScrapSpearBlockTable) 
AddTable("WingedSpearBlockTable", BlockTables.WingedSpearBlockTable) 
AddTable("DualShardsBlockTable", BlockTables.DualShardsBlockTable)
AddTable("WarScytheBlockTable", BlockTables.WarScytheBlockTable)  
AddTable("GlazicusBlockTable", BlockTables.GlazicusBlockTable)  
AddTable("BlackclawBlockTable", BlockTables.BlackclawBlockTable)  
AddTable("ScrapBladeBlockTable", BlockTables.ScrapBladeBlockTable)  
AddTable("BellHammerBlockTable", BlockTables.BellHammerBlockTable)  
AddTable("GoreCleaverBlockTable", BlockTables.GoreCleaverBlockTable)  
AddTable("GoreClubBlockTable", BlockTables.GoreClubBlockTable)  
AddTable("GrocklingStoneMaulBlockTable", BlockTables.GrocklingStoneMaulBlockTable)  
AddTable("GrocklingSacredStoneMaulBlockTable", BlockTables.GrocklingSacredStoneMaulBlockTable)  
AddTable("GoreWarAxeBlockTable", BlockTables.GoreWarAxeBlockTable)  
AddTable("ReaverWarAxeBlockTable", BlockTables.ReaverWarAxeBlockTable)  
AddTable("GoreFalchionBlockTable", BlockTables.GoreFalchionBlockTable)  
AddTable("GoreBattleAxeBlockTable", BlockTables.GoreBattleAxeBlockTable)  
AddTable("PolehammerBlockTable", BlockTables.PolehammerBlockTable)  
AddTable("IronRapierBlockTable", BlockTables.IronRapierBlockTable)  
AddTable("ElegantEpeeBlockTable", BlockTables.ElegantEpeeBlockTable) 
AddTable("FlangedMaceBlockTable", BlockTables.FlangedMaceBlockTable)  
AddTable("MorningStarBlockTable", BlockTables.MorningStarBlockTable)    
AddTable("GoreHuntingDaggerBlockTable", BlockTables.GoreHuntingDaggerBlockTable)    
AddTable("QuickshankBlockTable", BlockTables.QuickshankBlockTable)    
AddTable("ParryingDaggerBlockTable", BlockTables.ParryingDaggerBlockTable) 
AddTable("KnightsbaneBlockTable", BlockTables.KnightsbaneBlockTable)   
AddTable("ElegantDaggerBlockTable", BlockTables.ElegantDaggerBlockTable)    
AddTable("GoreShortswordBlockTable", BlockTables.GoreShortswordBlockTable)  
AddTable("IronArmingSwordBlockTable", BlockTables.IronArmingSwordBlockTable)   
AddTable("LongswordBlockTable", BlockTables.LongswordBlockTable)        
AddTable("ExileKnightSwordBlockTable", BlockTables.ExileKnightSwordBlockTable)  
AddTable("GlaiveBlockTable", BlockTables.GlaiveBlockTable) 
AddTable("GoreAxeandFalchionBlockTable", BlockTables.GoreAxeandFalchionBlockTable)   
AddTable("IronKnucklesBlockTable", BlockTables.IronKnucklesBlockTable)
AddTable("SpikedKnucklesBlockTable", BlockTables.SpikedKnucklesBlockTable)    
AddTable("CaestusBlockTable", BlockTables.CaestusBlockTable)  
AddTable("ShortswordBlockTable", BlockTables.ShortswordBlockTable)
AddTable("BatBlockTable", BlockTables.BatBlockTable)
AddTable("SpikedBatBlockTable", BlockTables.SpikedBatBlockTable)
AddTable("BladedBatBlockTable", BlockTables.BladedBatBlockTable)
AddTable("BoardBlockTable", BlockTables.BoardBlockTable)
AddTable("SpikedBoardBlockTable", BlockTables.SpikedBoardBlockTable)
AddTable("BladedBoardBlockTable", BlockTables.BladedBoardBlockTable)
AddTable("PipeBlockTable", BlockTables.PipeBlockTable)
AddTable("PipeMaceBlockTable", BlockTables.PipeMaceBlockTable)
AddTable("MacheteBlockTable", BlockTables.MacheteBlockTable)
AddTable("TwistedMacheteBlockTable", BlockTables.TwistedMacheteBlockTable)
AddTable("ScraphammerBlockTable", BlockTables.ScraphammerBlockTable)
AddTable("VolthammerBlockTable", BlockTables.VolthammerBlockTable)
AddTable("SledgeBlockTable", BlockTables.SledgeBlockTable)
AddTable("PickaxeBlockTable", BlockTables.PickaxeBlockTable)
AddTable("TrainingLongswordBlockTable", BlockTables.TrainingLongswordBlockTable)
AddTable("QuarterstaffBlockTable", BlockTables.QuarterstaffBlockTable)
AddTable("TrainingSpearBlockTable", BlockTables.TrainingSpearBlockTable)
AddTable("PitchforkBlockTable", BlockTables.PitchforkBlockTable)
AddTable("TrainingSwordBlockTable", BlockTables.TrainingSwordBlockTable)
AddTable("HatchetBlockTable", BlockTables.HatchetBlockTable)
AddTable("DarkIceDaggerBlockTable", BlockTables.DarkIceDaggerBlockTable)
AddTable("DarkFireDaggerBlockTable", BlockTables.DarkFireDaggerBlockTable)
AddTable("EnchantedLongswordBlockTable", BlockTables.EnchantedLongswordBlockTable)
AddTable("DemonSlayerAxeBlockTable", BlockTables.DemonSlayerAxeBlockTable)
AddTable("ScimitarBlockTable", BlockTables.ScimitarBlockTable)
AddTable("BrokenSwordBlockTable", BlockTables.BrokenSwordBlockTable)
AddTable("DemonClawsBlockTable", BlockTables.DemonClawsBlockTable)
AddTable("ReaverBattleAxeBlockTable", BlockTables.ReaverBattleAxeBlockTable)
AddTable("GoreSeaxBlockTable", BlockTables.GoreSeaxBlockTable)
AddTable("FamilialSwordBlockTable", BlockTables.FamilialSwordBlockTable)
AddTable("DruidSwordBlockTable", BlockTables.DruidSwordBlockTable)
AddTable("BlessedDruidSwordBlockTable", BlockTables.BlessedDruidSwordBlockTable)
AddTable("GoreMaceBlockTable", BlockTables.GoreMaceBlockTable)
AddTable("ShardBlockTable", BlockTables.ShardBlockTable)
AddTable("SatanicMaceBlockTable", BlockTables.SatanicMaceBlockTable)
AddTable("DualAxesBlockTable", BlockTables.DualAxesBlockTable)
AddTable("DualScimitarsBlockTable", BlockTables.DualScimitarsBlockTable)
AddTable("SatanicSwordBlockTable", BlockTables.SatanicSwordBlockTable)
AddTable("SatanicMaulBlockTable", BlockTables.SatanicMaulBlockTable)
AddTable("SatanicLongswordBlockTable", BlockTables.SatanicLongswordBlockTable)
AddTable("GlazicBannerBlockTable", BlockTables.GlazicBannerBlockTable)
AddTable("DreadaxeBlockTable", BlockTables.DreadaxeBlockTable)
AddTable("WarpedSwordBlockTable", BlockTables.WarpedSwordBlockTable)
AddTable("TwistedClubBlockTable", BlockTables.TwistedClubBlockTable)
AddTable("VoltsledgeBlockTable", BlockTables.VoltsledgeBlockTable)
AddTable("VoltswordBlockTable", BlockTables.VoltswordBlockTable)
AddTable("BillhookBlockTable", BlockTables.BillhookBlockTable)
AddTable("LucerneBlockTable", BlockTables.LucerneBlockTable)
AddTable("GoreFalxBlockTable", BlockTables.GoreFalxBlockTable)
AddTable("SkyfallenSwordBlockTable", BlockTables.SkyfallenSwordBlockTable)
AddTable("FrozenFatherlandAxeBlockTable", BlockTables.FrozenFatherlandAxeBlockTable)
AddTable("MaximusWrathBlockTable", BlockTables.MaximusWrathBlockTable)
AddTable("VoltprodBlockTable", BlockTables.VoltprodBlockTable)
AddTable("TireIronBlockTable", BlockTables.TireIronBlockTable)
AddTable("ScrapAxeBlockTable", BlockTables.ScrapAxeBlockTable)
AddTable("SteelArmingSwordBlockTable", BlockTables.SteelArmingSwordBlockTable)
AddTable("SatanicShortswordBlockTable", BlockTables.SatanicShortswordBlockTable)
AddTable("Ancestraldagger_Rekh_BlockTable", BlockTables.Ancestraldagger_Rekh_BlockTable)
AddTable("Ancestraldagger_Varazdat_BlockTable", BlockTables.Ancestraldagger_Varazdat_BlockTable)
AddTable("Ancestraldagger_Philimaxio_BlockTable", BlockTables.Ancestraldagger_Philimaxio_BlockTable)
AddTable("Ancestraldagger_Kinisger_BlockTable", BlockTables.Ancestraldagger_Kinisger_BlockTable)
AddTable("DualKinisgerDaggersBlockTable", BlockTables.DualKinisgerDaggersBlockTable)
AddTable("DarklanderBardicheBlockTable", BlockTables.DarklanderBardicheBlockTable)
AddTable("EveningStarBlockTable", BlockTables.EveningStarBlockTable)
AddTable("WarHammerBlockTable", BlockTables.WarHammerBlockTable)
AddTable("DualScrapBladesBlockTable", BlockTables.DualScrapBladesBlockTable)

-- Shield Stat Tables

BlockTables.Shield_1_BlockTable = { -- Scrap Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = true,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.8,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 25,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_2_BlockTable = { -- Slaveshield
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 35)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 10,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_3_BlockTable = { -- Car Door Shield
	["guardblockamount"] = 3,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(-5, -15, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 55,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 50,
	["canparry"] = false,
	["candeflect"] = false,
};

BlockTables.Shield_4_BlockTable = { -- Buckler
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25, 
	["blockeffectpos"] = (Vector(0, -5, 40)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_5_BlockTable = { -- Wooden Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = true,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_6_BlockTable = { -- Iron Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_7_BlockTable = { -- Knight's Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_8_BlockTable = { -- Spiked Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 30,
	["raisespeed"] = 1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_9_BlockTable = { -- Sol Sentinel Shield
	["guardblockamount"] = 2,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 999,
	["raisespeed"] = 2.2,
	["instantraise"] = false,
	["parrydifficulty"] = nil,
	["parrytakestamina"] = nil,
	["canparry"] = false,
	["candeflect"] = false,
};

BlockTables.Shield_10_BlockTable = { -- Gore Guardian Shield
	["guardblockamount"] = 2,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 999,
	["raisespeed"] = 2.2,
	["instantraise"] = false,
	["parrydifficulty"] = nil,
	["parrytakestamina"] = nil,
	["canparry"] = false,
	["candeflect"] = false,
};

BlockTables.Shield_11_BlockTable = { -- Gatekeeper Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = true,
	["poiseresistance"] = 30,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_12_BlockTable = { -- Warfighter Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 40,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_13_BlockTable = { -- Dreadshield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 40,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_14_BlockTable = { -- Clan Shield
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = true,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 12,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_Unique_Skinshield = { -- Red Wolf Skinshield (Unique)
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 50,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.Shield_Unique_SolShield = { -- Sol Shield (Unique)
	["guardblockamount"] = 5,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_SNIPER, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 35,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

AddTable("Shield_1_BlockTable", BlockTables.Shield_1_BlockTable) 
AddTable("Shield_2_BlockTable", BlockTables.Shield_2_BlockTable) 
AddTable("Shield_3_BlockTable", BlockTables.Shield_3_BlockTable) 
AddTable("Shield_4_BlockTable", BlockTables.Shield_4_BlockTable) 
AddTable("Shield_5_BlockTable", BlockTables.Shield_5_BlockTable) 
AddTable("Shield_6_BlockTable", BlockTables.Shield_6_BlockTable) 
AddTable("Shield_7_BlockTable", BlockTables.Shield_7_BlockTable) 
AddTable("Shield_8_BlockTable", BlockTables.Shield_8_BlockTable) 
AddTable("Shield_9_BlockTable", BlockTables.Shield_9_BlockTable) 
AddTable("Shield_10_BlockTable", BlockTables.Shield_10_BlockTable) 
AddTable("Shield_11_BlockTable", BlockTables.Shield_11_BlockTable) 
AddTable("Shield_12_BlockTable", BlockTables.Shield_12_BlockTable) 
AddTable("Shield_13_BlockTable", BlockTables.Shield_13_BlockTable) 
AddTable("Shield_14_BlockTable", BlockTables.Shield_14_BlockTable) 
AddTable("Shield_Unique_Skinshield", BlockTables.Shield_Unique_Skinshield) 
AddTable("Shield_Unique_SolShield", BlockTables.Shield_Unique_SolShield) 

print "Melee Tables Loaded"