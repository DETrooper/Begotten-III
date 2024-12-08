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
	["althitbody"] = {"weapons/Punch_01.wav", "weapons/Punch_02.wav", "weapons/Punch_03.wav", "weapons/Punch_04.wav"},
	["hitworld"] = {"physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.MetalFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.LeatherFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Blunt_01.wav", "weapons/Blunt_02.wav", "weapons/Blunt_03.wav", "weapons/Blunt_04.wav", "weapons/Blunt_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
};

AttackSoundTables.MetalSpikeFistedAttackSoundTable = {
	["primarysound"] = {"weapons/Small_01.wav", "weapons/Small_02.wav", "weapons/Small_03.wav", "weapons/Small_04.wav", "weapons/Small_05.wav", "weapons/Small_06.wav"},
	["altsound"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
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

AttackSoundTables.BluntMetalJavelinMeleeAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
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

AttackSoundTables.MetalJavelinMeleeAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["hitworld"] = {"weapons/PierceStone_01.wav", "weapons/PierceStone_02.wav", "weapons/PierceStone_03.wav", "weapons/PierceStone_04.wav"},
	["criticalswing"] = {"meleesounds/swing-sword2.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"draw/skyrim_bow_draw.mp3"},
};

AttackSoundTables.WoodenDaggerAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"vo/k_lab/kl_fiddlesticks.wav"},
	["hitworld"] = {"weapons/wooden_to_wooden_01.wav", "weapons/wooden_to_wooden_02.wav", "weapons/wooden_to_wooden_03.wav", "weapons/wooden_to_wooden_04.wav"},
	["criticalswing"] = {"meleesounds/swing-throw.wav.mp3"},
	["parryswing"] = {"weapons/Medium_01.wav", "weapons/Medium_02.wav", "weapons/Medium_03.wav", "weapons/Medium_04.wav", "weapons/Medium_05.wav"},
	["drawsound"] = {"weapons/knife/knife_draw_x.mp3"},
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

AttackSoundTables.MetalThrowingDaggerMeleeAttackSoundTable = {
	["primarysound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["altsound"] = {"weapons/Pierce_01.wav", "weapons/Pierce_03.wav", "weapons/Pierce_05.wav"},
	["hitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
	["althitbody"] = {"weapons/Pierce_02.wav", "weapons/Pierce_04.wav", "weapons/Pierce_06.wav", "weapons/Pierce_07.wav", "weapons/Pierce_08.wav", "weapons/Pierce_09.wav"},
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
AddSoundTable("MetalJavelinMeleeAttackSoundTable", AttackSoundTables.MetalJavelinMeleeAttackSoundTable)
AddSoundTable("WoodenDaggerAttackSoundTable", AttackSoundTables.WoodenDaggerAttackSoundTable)
AddSoundTable("MetalDaggerAttackSoundTable", AttackSoundTables.MetalDaggerAttackSoundTable)
AddSoundTable("MetalThrowingDaggerMeleeAttackSoundTable", AttackSoundTables.MetalThrowingDaggerMeleeAttackSoundTable)
AddSoundTable("MetalClawsAttackSoundTable", AttackSoundTables.MetalClawsAttackSoundTable)
AddSoundTable("DualSwordsAttackSoundTable", AttackSoundTables.DualSwordsAttackSoundTable)
AddSoundTable("BellHammerAttackSoundTable", AttackSoundTables.BellHammerAttackSoundTable)
AddSoundTable("HeavyStoneAttackSoundTable", AttackSoundTables.HeavyStoneAttackSoundTable)
AddSoundTable("BluntMetalSpearAttackSoundTable", AttackSoundTables.BluntMetalSpearAttackSoundTable)
AddSoundTable("BluntMetalJavelinMeleeAttackSoundTable", AttackSoundTables.BluntMetalJavelinMeleeAttackSoundTable)
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
	
	--print("Invalid GetTable uniqueID: "..tostring(uniqueID));
	
	return {};
end;

function GetDualTable(uniqueID, offhandID)
	local mergedTable = {};
	local offhandTable;
	local weaponTable;

	if (istable(uniqueID)) then
		weaponTable = uniqueID;
	elseif (uniqueID) then
		weaponTable = tabs[uniqueID];
	end
	
	if weaponTable then
		local mergedTable = {};
		local offhandTable;

		if (istable(offhandID)) then
			offhandTable = offhandID;
		elseif offhandID then
			offhandTable = tabs[offhandID];
		end
		
		if offhandTable then
			mergedTable = table.FullCopy(weaponTable);
		
			if (isstring(uniqueID) and string.find(string.lower(uniqueID), "blocktable")) or uniqueID.poiseresistance then
				mergedTable["guardblockamount"] = math.max(mergedTable["guardblockamount"], offhandTable["guardblockamount"]);
				mergedTable["blockcone"] = math.max(mergedTable["blockcone"], offhandTable["blockcone"]);
				mergedTable["poiseresistance"] = math.min(math.max(mergedTable["poiseresistance"], offhandTable["poiseresistance"]) + 1, 100);
				mergedTable["parrydifficulty"] = math.min(math.max(mergedTable["parrydifficulty"], offhandTable["parrydifficulty"]) * 0.85, 100);
				mergedTable["parrytakestamina"] = math.min(mergedTable["parrytakestamina"], offhandTable["parrytakestamina"]);
				
				for i, v in ipairs(offhandTable["blockdamagetypes"]) do
					if !table.HasValue(mergedTable, v) then
						table.insert(mergedTable, v);
					end
				end
				
				if offhandTable["canparry"] then
					mergedTable["canparry"] = true;
				end
				
				if offhandTable["candeflect"] then
					mergedTable["candeflect"] = true;
				end

				if offhandTable["partialbulletblock"] then
					mergedTable["partialbulletblock"] = true;
				end
			else
				mergedTable["delay"] = math.max(mergedTable["delay"], offhandTable["delay"]) * 0.98;
			end
			
			return mergedTable;
		end
		
		--print("Invalid GetDualTable offhandID: "..tostring(uniqueID));
	end
	
	--print("Invalid GetDualTable uniqueID: "..tostring(uniqueID));
	
	return mergedTable;
end

local AttackTables = {};

-- Categorized (mostly) by animations and striketime speed

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
	["meleearc"] = 25, -- Melee arc
	["meleerange"] = 500, -- Weapon reach
	["punchstrength"] = Angle(0,1,0), -- Viewpunch when swinging
};

-- Projectiles
AttackTables.IronJavelinAttackTable = {
	["primarydamage"] = 35, -- For projectile weapons, primary damage = melee damage
	["mimimumdistancedamage"] = 25,
	["maximumdistancedamage"] = 200,
	["dmgtype"] = DMG_VEHICLE,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.1,
	["altattackstabilitydamagemodifier"] = 0,
	["altmeleearc"] = 15,
	["altmeleerange"] = 1050,
	["alttakeammo"] = 3,
	["armorpiercing"] = 50,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["minimumdistancestabilitydamage"] = 25,
	["maximumdistancestabilitydamage"] = 100,
	["takeammo"] = 25,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.PilumAttackTable = {
	["primarydamage"] = 30,
	["mimimumdistancedamage"] = 25,
	["maximumdistancedamage"] = 135,
	["dmgtype"] = DMG_VEHICLE,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.05,
	["altattackstabilitydamagemodifier"] = 0,
	["altmeleearc"] = 15,
	["altmeleerange"] = 1200,
	["alttakeammo"] = 3,
	["armorpiercing"] = 75,
	["poisedamage"] = 125,
	["stabilitydamage"] = 75,
	["minimumdistancestabilitydamage"] = 35,
	["maximumdistancestabilitydamage"] = 150,
	["takeammo"] = 30,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingJavelinAttackTable = {
	["primarydamage"] = 10,
	["mimimumdistancedamage"] = 10,
	["maximumdistancedamage"] = 35,
	["dmgtype"] = 128,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.4,
	["altmeleearc"] = 15,
	["altmeleerange"] = 1300,
	["alttakeammo"] = 5,
	["armorpiercing"] = 0,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["minimumdistancestabilitydamage"] = 25,
	["maximumdistancestabilitydamage"] = 100,
	["takeammo"] = 15,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ThrowingAxeAttackTable = {
	["primarydamage"] = 45,
	["mimimumdistancedamage"] = 45,
	["maximumdistancedamage"] = 135,
	["dmgtype"] = DMG_SLASH,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.5,
	["altattackstabilitydamagemodifier"] = 0,
	["altmeleearc"] = 35,
	["altmeleerange"] = 625,
	["alttakeammo"] = 3,
	["armorpiercing"] = 40,
	["poisedamage"] = 40,
	["stabilitydamage"] = 40,
	["minimumdistancestabilitydamage"] = 20,
	["maximumdistancestabilitydamage"] = 80,
	["takeammo"] = 8,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ThrowingDaggerAttackTable = {
	["primarydamage"] = 9,
	["mimimumdistancedamage"] = 15,
	["maximumdistancedamage"] = 50,	
	["dmgtype"] = DMG_VEHICLE,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0,
	["altattackstabilitydamagemodifier"] = 0,
	["altmeleearc"] = 15,
	["altmeleerange"] = 450,
	["alttakeammo"] = 3,
	["armorpiercing"] = 60,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["minimumdistancestabilitydamage"] = 0,
	["maximumdistancestabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ThrowingStoneAttackTable = {
	["primarydamage"] = 10,
	["mimimumdistancedamage"] = 10,
	["maximumdistancedamage"] = 40,
	["dmgtype"] = 128,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.2,
	["altmeleearc"] = 15,
	["altmeleerange"] = 600,
	["alttakeammo"] = 3,
	["armorpiercing"] = 25,
	["poisedamage"] = 35,
	["stabilitydamage"] = 30,
	["minimumdistancestabilitydamage"] = 25,
	["maximumdistancestabilitydamage"] = 65,
	["takeammo"] = 8,
	["delay"] = 0.9,
	["striketime"] = 0.4,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.IronBoltAttackTable = {
	["mimimumdistancedamage"] = 50,
	["maximumdistancedamage"] = 120,
	["dmgtype"] = DMG_VEHICLE,
	["armorpiercing"] = 65,
	["poisedamage"] = 35,
	["stabilitydamage"] = 40,
	["minimumdistancestabilitydamage"] = 20,
	["maximumdistancestabilitydamage"] = 80,
	["takeammo"] = 0,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.ScrapBoltAttackTable = {
	["mimimumdistancedamage"] = 35,
	["maximumdistancedamage"] = 90,
	["dmgtype"] = DMG_VEHICLE,
	["armorpiercing"] = 50,
	["poisedamage"] = 30,
	["stabilitydamage"] = 35,
	["minimumdistancestabilitydamage"] = 18,
	["maximumdistancestabilitydamage"] = 70,
	["takeammo"] = 0,
	["punchstrength"] = Angle(0,2,0),
};

-- Fisted

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
	["stabilitydamage"] = 15,
	["takeammo"] = 1,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 20,
	["meleerange"] = 525,
	["punchstrength"] = Angle(0,2,0),
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
	["stabilitydamage"] = 30,
	["takeammo"] = 1,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 20,
	["meleerange"] = 555,
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
	["stabilitydamage"] = 30,
	["takeammo"] = 1,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 20,
	["meleerange"] = 555,
	["punchstrength"] = Angle(0,2,0),
};

AttackTables.CaestusAttackTable = {
	["primarydamage"] = 12,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = 0,
	["altattackpoisedamagemodifier"] = 0,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 35,
	["stabilitydamage"] = 35,
	["takeammo"] = 2,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 20,
	["meleerange"] = 555,
	["punchstrength"] = Angle(0,2,0),
};

-- Shortswords

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
	["meleearc"] = 15,
	["meleerange"] = 715,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.MacheteAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 690,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TwistedMacheteAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 690,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ShortswordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltswordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 7,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 795,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlazicusAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.OrnateGlazicusAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 765,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DruidSwordAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.85,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 760,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BlessedDruidSwordAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 760,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreShortswordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 760,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreSeaxAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 720,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.FamilialSwordAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicShortswordAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ElegantEpeeAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = nil,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.75,
	["striketime"] = 0.3,
	["meleearc"] = 15,
	["meleerange"] = 740,
	["punchstrength"] = Angle(0,1,0),
};

-- Short polearms

AttackTables.BillhookAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.9,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = 60,
	["poisedamage"] = 20,
	["stabilitydamage"] = 25,
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.45,
	["meleearc"] = 45,
	["meleerange"] = 1110,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.LucerneAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.3,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 5,
	["delay"] = 1.3,
	["striketime"] = 0.45,
	["meleearc"] = 45,
	["meleerange"] = 1115,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.GatekeeperPoleaxeAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 25,
	["stabilitydamage"] = 15,
	["takeammo"] = 4,
	["delay"] = 1.2,
	["striketime"] = 0.45,
	["meleearc"] = 45,
	["meleerange"] = 1125,
	["punchstrength"] = Angle(1,3,1),
};

-- Long polearms

AttackTables.PolehammerAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.25,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 52,
	["stabilitydamage"] = 52,
	["takeammo"] = 7,
	["delay"] = 1.45,
	["striketime"] = 0.55,
	["meleearc"] = 50,
	["meleerange"] = 1410,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.PikeAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.3,
	["altattackpoisedamagemodifier"] = 3,
	["altmeleearc"] = 45,
	["armorpiercing"] = 40,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.3,
	["striketime"] = 0.55,
	["meleearc"] = 15,
	["meleerange"] = 1900,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.WarSpearAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 16,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.3,
	["altattackpoisedamagemodifier"] = 2.5,
	["altmeleearc"] = 45,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.25,
	["striketime"] = 0.55,
	["meleearc"] = 15,
	["meleerange"] = 1600,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.HalberdAttackTable = {
	["primarydamage"] = 80,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 35,
	["stabilitydamage"] = 20,
	["takeammo"] = 6,
	["delay"] = 1.4,
	["striketime"] = 0.55,
	["meleearc"] = 50,
	["meleerange"] = 1375,
	["punchstrength"] = Angle(1,3,1),
};

AttackTables.GlazicBannerAttackTable = {
	["primarydamage"] = 15,
	["dmgtype"] = 128,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.5,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 25,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.55,
	["meleearc"] = 60,
	["meleerange"] = 1680,
	["punchstrength"] = Angle(1,3,1),
};

-- Arming Swords

AttackTables.IronArmingSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 835,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SteelArmingSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SpathaAttackTable = {
	["primarydamage"] = 52,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.3,
	["altmeleearc"] = 15,
	["armorpiercing"] = 22,
	["altarmorpiercing"] = 33,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 890,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BrokenSwordAttackTable = {
	["primarydamage"] = 22,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.6,
	["altmeleearc"] = 15,
	["armorpiercing"] = 10,
	["altarmorpiercing"] = 25,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingSwordAttackTable = {
	["primarydamage"] = 1,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.5,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 20,
	["stabilitydamage"] = 20,
	["takeammo"] = 3,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 835,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScimitarAttackTable = {
	["primarydamage"] = 52,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 18,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 835,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ShardAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 55,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.85,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicSwordAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WarpedSwordAttackTable = {
	["primarydamage"] = 60,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.55,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 18,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 17,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 805,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlazicSwordAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.5,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.9,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BlackclawAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 865,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapBladeAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.5,
	["altmeleearc"] = 15,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 30,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.85,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreFalchionAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.6,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 18,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 18,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 805,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HellfireSwordAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 18,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 18,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 805,
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
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.35,
	["meleearc"] = 35,
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
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.35,
	["meleearc"] = 35,
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
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 735,
	["punchstrength"] = Angle(0,1,0),
};

-- Longswords

AttackTables.LongswordAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1035,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingLongswordAttackTable = {
	["primarydamage"] = 1,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.5,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = 0,
	["poisedamage"] = 25,
	["stabilitydamage"] = 25,
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1120,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.EnchantedLongswordAttackTable = {
	["primarydamage"] = 65,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1095,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicLongswordAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 35,
	["meleerange"] = 1095,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ClaymoreAttackTable = {
	["primarydamage"] = 80,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 35,
	["stabilitydamage"] = 0,
	["takeammo"] = 7,
	["delay"] = 1.4,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1140,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltlongswordAttackTable = {
	["primarydamage"] = 65,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.75,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1035,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ExileKnightSwordAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.25,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1080,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.InquisitorSwordAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.05,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1095,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SkylightSwordAttackTable = {
	["primarydamage"] = 190,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = 90,
	["poisedamage"] = 55,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleearc"] = 55,
	["meleerange"] = 1120,
	["punchstrength"] = Angle(0,1,0),
	["isadminweapon"] = true,
};

AttackTables.UnholySigilSwordAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 45,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.25,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1035,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.UnholySigilSword_Fire_AttackTable = {
	["primarydamage"] = 60,
	["dmgtype"] = 4,
	["attacktype"] = "fire_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 45,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.25,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1035,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.UnholySigilSword_Ice_AttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 45,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.25,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 1035,
	["punchstrength"] = Angle(0,1,0),
};

-- Axes

AttackTables.BattleAxeAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 33,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreBattleAxeAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 25,
	["stabilitydamage"] = 0,
	["takeammo"] = 6,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 45,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ReaverBattleAxeAttackTable = {
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
	["takeammo"] = 6,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 665,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SteelGoreBattleAxeAttackTable = {
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
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleearc"] = 45,
	["meleerange"] = 625,
	["punchstrength"] = Angle(0,1,0),
};

-- Maces

AttackTables.FlangedMaceAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.45,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 45,
	["stabilitydamage"] = 45,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreMaceAttackTable = {
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
	["takeammo"] = 7,
	["delay"] = 1.32,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 630,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicMaceAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 7,
	["delay"] = 1.3,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 635,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.MorningStarAttackTable = {
	["primarydamage"] = 23,
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
	["meleearc"] = 35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BoneMaceAttackTable = {
	["primarydamage"] = 9,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 25,
	["takeammo"] = 2,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 570,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TwistedClubAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 1.2,
	["altattackpoisedamagemodifier"] = 0.4,
	["altmeleearc"] = 15,
	["armorpiercing"] = 65,
	["altarmorpiercing"] = 37,
	["poisedamage"] = 30,
	["stabilitydamage"] = 40,
	["takeammo"] = 5,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 635,
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
	["meleearc"] = 35,
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
	["meleearc"] = 35,
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
	["meleearc"] = 35,
	["meleerange"] = 660,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WarHammerAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 35,
	["stabilitydamage"] = 35,
	["takeammo"] = 4,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 35,
	["meleerange"] = 635,
	["punchstrength"] = Angle(0,1,0),
};

-- Short Maces

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
	["meleearc"] = 35,
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
	["meleearc"] = 35,
	["meleerange"] = 535,
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
	["meleearc"] = 35,
	["meleerange"] = 545,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapAxeAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 550,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltprodAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 35,
	["takeammo"] = 2,
	["delay"] = 0.8,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 635,
	["punchstrength"] = Angle(0,1,0),
};

-- Claws

AttackTables.SavageClawsAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.65,
	["striketime"] = 0.3,
	["meleearc"] = 35,
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
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 0.7,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 630,
	["punchstrength"] = Angle(0,1,0),
};

-- Daggers

AttackTables.IronDaggerAttackTable = {
	["primarydamage"] = 12,
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
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 460,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.BoneDaggerAttackTable = {
	["primarydamage"] = 10,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 23,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 450,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreHuntingDaggerAttackTable = {
	["primarydamage"] = 15,
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
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
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
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ParryingDaggerAttackTable = {
	["primarydamage"] = 13,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.KnightsbaneAttackTable = {
	["primarydamage"] = 14,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
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
	["meleearc"] = 15,
	["meleerange"] = 490,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DarkIceDaggerAttackTable = {
	["primarydamage"] = 18,
	["dmgtype"] = 16,
	["attacktype"] = "ice_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 485,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DarkFireDaggerAttackTable = {
	["primarydamage"] = 18,
	["dmgtype"] = 16,
	["attacktype"] = "fire_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 485,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Rekh_AttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.7,
	["striketime"] = 0.2,
	["meleearc"] = 15,
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
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 0,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.6,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Philimaxio_AttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 2,
	["delay"] = 0.65,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.Ancestraldagger_Kinisger_AttackTable = {
	["primarydamage"] = 22,
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
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

-- Short Spears

AttackTables.IronShortSpearAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.85,
	["striketime"] = 0.35,
	["meleearc"] = 15,
	["meleerange"] = 920,
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
	["meleearc"] = 15,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScrapSpearAttackTable = {
	["primarydamage"] = 32,
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
	["meleearc"] = 15,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

-- Spears

AttackTables.IronSpearAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 5,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 15,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.TrainingSpearAttackTable = {
	["primarydamage"] = 1,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 0,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 25,
	["takeammo"] = 4,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleearc"] = 15,
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
	["armorpiercing"] = 27,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1,
	["striketime"] = 0.4,
	["meleearc"] = 15,
	["meleerange"] = 1000,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltspearAttackTable = {
	["primarydamage"] = 45,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 8,
	["stabilitydamage"] = 10,
	["takeammo"] = 4,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleearc"] = 15,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicSpearAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 1.1,
	["striketime"] = 0.4,
	["meleearc"] = 15,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WingedSpearAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 16,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 10,
	["stabilitydamage"] = 0,
	["takeammo"] = 4,
	["delay"] = 1.05,
	["striketime"] = 0.4,
	["meleearc"] = 15,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

-- Scythes

AttackTables.WarScytheAttackTable = {
	["primarydamage"] = 80,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 20,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.6,
	["meleearc"] = 60,
	["meleerange"] = 1200,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GlaiveAttackTable = {
	["primarydamage"] = 90,
	["dmgtype"] = 4,
	["attacktype"] = "polearm_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.55,
	["striketime"] = 0.6,
	["meleearc"] = 60,
	["meleerange"] = 1350,
	["punchstrength"] = Angle(0,1,0),
};

-- War Axes

AttackTables.GoreCleaverAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 30,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleearc"] = 50,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreWarAxeAttackTable = {
	["primarydamage"] = 90,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 40,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.55,
	["striketime"] = 0.65,
	["meleearc"] = 45,
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
	["poisedamage"] = 35,
	["stabilitydamage"] = 0,
	["takeammo"] = 7,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HaralderWarAxeAttackTable = {
	["primarydamage"] = 85,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 45,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 0,
	["takeammo"] = 7,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
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
	["poisedamage"] = 35,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleearc"] = 35,
	["meleerange"] = 800,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GoreFalxAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 55,
	["stabilitydamage"] = 20,
	["takeammo"] = 8,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 800,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.DarklanderBardicheAttackTable = {
	["primarydamage"] = 55,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 55,
	["stabilitydamage"] = 20,
	["takeammo"] = 8,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.FrozenFatherlandAxeAttackTable = {
	["primarydamage"] = 70,
	["dmgtype"] = 4,
	["attacktype"] = "ice_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleearc"] = 50,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

-- Mauls

AttackTables.ClubAttackTable = {
	["primarydamage"] = 20,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 45,
	["takeammo"] = 7,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.WarClubAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 10,
	["delay"] = 1.7,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
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
	["poisedamage"] = 50,
	["stabilitydamage"] = 50,
	["takeammo"] = 8,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SatanicMaulAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 62,
	["stabilitydamage"] = 62,
	["takeammo"] = 9,
	["delay"] = 1.6,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 925,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.ScraphammerAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 60,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 45,
	["takeammo"] = 7,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
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
	["stabilitydamage"] = 60,
	["takeammo"] = 8,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.VoltsledgeAttackTable = {
	["primarydamage"] = 25,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 45,
	["takeammo"] = 7,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 700,
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
	["takeammo"] = 7,
	["delay"] = 1.4,
	["striketime"] = 0.65,
	["meleearc"] = 45,
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
	["poisedamage"] = 30,
	["stabilitydamage"] = 30,
	["takeammo"] = 8,
	["delay"] = 1.55,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 700,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.EveningStarAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 60,
	["stabilitydamage"] = 60,
	["takeammo"] = 8,
	["delay"] = 1.35,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 825,
	["punchstrength"] = Angle(0,1,0),
};

-- Great Mauls

AttackTables.BellHammerAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 82,
	["stabilitydamage"] = 82,
	["takeammo"] = 15,
	["delay"] = 2.4,
	["striketime"] = 0.95,
	["meleearc"] = 50,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,8,0),
};

AttackTables.GrocklingStoneMaulAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 70,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 65,
	["stabilitydamage"] = 65,
	["takeammo"] = 11,
	["delay"] = 2,
	["striketime"] = 0.95,
	["meleearc"] = 45,
	["meleerange"] = 925,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.GrocklingSacredStoneMaulAttackTable = {
	["primarydamage"] = 30,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 75,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 68,
	["stabilitydamage"] = 68,
	["takeammo"] = 12,
	["delay"] = 2.1,
	["striketime"] = 0.95,
	["meleearc"] = 45,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
};

-- Great Axes

AttackTables.DemonSlayerAxeAttackTable = {
	["primarydamage"] = 95,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 40,
	["takeammo"] = 15,
	["delay"] = 2.4,
	["striketime"] = 0.95,
	["meleearc"] = 55,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,7,0),
};

AttackTables.DreadaxeAttackTable = {
	["primarydamage"] = 95,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 55,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 45,
	["stabilitydamage"] = 40,
	["takeammo"] = 15,
	["delay"] = 2.4,
	["striketime"] = 0.95,
	["meleearc"] = 55,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,7,0),
};

-- Special

AttackTables.QuarterstaffAttackTable = {
	["primarydamage"] = 5,
	["dmgtype"] = 128,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nill,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 30,
	["takeammo"] = 3,
	["delay"] = 1.05,
	["striketime"] = 0.45,
	["meleearc"] = 45,
	["meleerange"] = 900,
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
	["meleearc"] = 35,
	["meleerange"] = 575,
	["punchstrength"] = Angle(0,1,0),
};

-- Admin

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
	["meleearc"] = 45,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SamuraiSwordAttackTable = {
	["primarydamage"] = 100,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 25,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 13,
	["stabilitydamage"] = 0,
	["takeammo"] = 0,
	["delay"] = 1,
	["striketime"] = 0.6,
	["meleearc"] = 60,
	["meleerange"] = 5000,
	["punchstrength"] = Angle(0,0,0),
	["isadminweapon"] = true,
};

AttackTables.AdminTwistedMacheteAttackTable = {
	["primarydamage"] = 28,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.7,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 15,
	["altarmorpiercing"] = 35,
	["poisedamage"] = 9,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.2,
	["striketime"] = 0.7,
	["meleearc"] = 35,
	["meleerange"] = 5000,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.SkyfallenSwordAttackTable = {
	["primarydamage"] = 165,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.1,
	["altmeleearc"] = 15,
	["armorpiercing"] = 50,
	["altarmorpiercing"] = 85,
	["poisedamage"] = 30,
	["stabilitydamage"] = 25,
	["takeammo"] = 6,
	["delay"] = 1.5,
	["striketime"] = 0.6,
	["meleearc"] = 50,
	["meleerange"] = 950,
	["punchstrength"] = Angle(0,1,0),
	["isadminweapon"] = true,
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
	["meleearc"] = 55,
	["meleerange"] = 900,
	["punchstrength"] = Angle(0,1,0),
	["isadminweapon"] = true,
};

-- Hill shit (weapons)

AttackTables.HillGlazicusAttackTable = {
	["primarydamage"] = 35,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.85,
	["altattackpoisedamagemodifier"] = 0.3,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 40,
	["poisedamage"] = 12,
	["stabilitydamage"] = 0,
	["takeammo"] = 3,
	["delay"] = 0.72,
	["striketime"] = 0.3,
	["meleearc"] = 35,
	["meleerange"] = 650,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillSteelArmingSwordAttackTable = {
	["primarydamage"] = 40,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.3,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 50,
	["poisedamage"] = 15,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.8,
	["striketime"] = 0.35,
	["meleearc"] = 35,
	["meleerange"] = 750,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillBattleAxeAttackTable = {
	["primarydamage"] = 50,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 42,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 22,
	["stabilitydamage"] = 0,
	["takeammo"] = 5,
	["delay"] = 0.95,
	["striketime"] = 0.4,
	["meleearc"] = 45,
	["meleerange"] = 625,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillLongswordAttackTable = {
	["primarydamage"] = 75,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = true,
	["altattackdamagemodifier"] = 0.8,
	["altattackpoisedamagemodifier"] = 0.25,
	["altmeleearc"] = 15,
	["armorpiercing"] = 25,
	["altarmorpiercing"] = 45,
	["poisedamage"] = 20,
	["stabilitydamage"] = 0,
	["takeammo"] = 8,
	["delay"] = 1.2,
	["striketime"] = 0.6,
	["meleearc"] = 45,
	["meleerange"] = 915,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillHeavyBattleAxeAttackTable = {
	["primarydamage"] = 85,
	["dmgtype"] = 4,
	["attacktype"] = "reg_swing",
	["canaltattack"] = false,
	["altattackdamagemodifier"] = nil,
	["altattackpoisedamagemodifier"] = nil,
	["armorpiercing"] = 35,
	["altarmorpiercing"] = nil,
	["poisedamage"] = 30,
	["stabilitydamage"] = 0,
	["takeammo"] = 7,
	["delay"] = 1.5,
	["striketime"] = 0.65,
	["meleearc"] = 45,
	["meleerange"] = 885,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillGoreHuntingDaggerAttackTable = {
	["primarydamage"] = 15,
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
	["delay"] = 0.62,
	["striketime"] = 0.2,
	["meleearc"] = 15,
	["meleerange"] = 475,
	["punchstrength"] = Angle(0,1,0),
};

AttackTables.HillThrowingAxeAttackTable = {
	["primarydamage"] = 55,
	["mimimumdistancedamage"] = 45,
	["maximumdistancedamage"] = 135,
	["dmgtype"] = DMG_SLASH,
	["canaltattack"] = true,
	["altattackpoisedamagemodifier"] = 0.5,
	["altattackstabilitydamagemodifier"] = 0,
	["altmeleearc"] = 35,
	["altmeleerange"] = 625,
	["alttakeammo"] = 3,
	["armorpiercing"] = 60,
	["poisedamage"] = 40,
	["stabilitydamage"] = 40,
	["minimumdistancestabilitydamage"] = 20,
	["maximumdistancestabilitydamage"] = 80,
	["takeammo"] = 12,
	["delay"] = 0.5,
	["striketime"] = 0.6,
	["punchstrength"] = Angle(0,4,0),
};

AttackTables.OrdainedGorefellerAttackTable = {
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
	["takeammo"] = 12,
	["delay"] = 2.3,
	["striketime"] = 0.955,
	["meleearc"] = 55,
	["meleerange"] = 1100,
	["punchstrength"] = Angle(0,7,0),
};

AddTable("DefaultAttackTable", AttackTables.DefaultAttackTable) 
AddTable("FistAttackTable", AttackTables.FistAttackTable) 
AddTable("IronJavelinAttackTable", AttackTables.IronJavelinAttackTable)
AddTable("PilumAttackTable", AttackTables.PilumAttackTable)
AddTable("TrainingJavelinAttackTable", AttackTables.TrainingJavelinAttackTable)
AddTable("ThrowingAxeAttackTable", AttackTables.ThrowingAxeAttackTable)
AddTable("ThrowingDaggerAttackTable", AttackTables.ThrowingDaggerAttackTable)
AddTable("ThrowingStoneAttackTable", AttackTables.ThrowingStoneAttackTable)
AddTable("IronBoltAttackTable", AttackTables.IronBoltAttackTable)
AddTable("ScrapBoltAttackTable", AttackTables.ScrapBoltAttackTable)
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
AddTable("BoneDaggerAttackTable", AttackTables.BoneDaggerAttackTable) 
AddTable("HarpoonAttackTable", AttackTables.HarpoonAttackTable) 
AddTable("IronSpearAttackTable", AttackTables.IronSpearAttackTable) 
AddTable("IronShortSpearAttackTable", AttackTables.IronShortSpearAttackTable) 
AddTable("VoltspearAttackTable", AttackTables.VoltspearAttackTable) 
AddTable("SatanicSpearAttackTable", AttackTables.SatanicSpearAttackTable) 
AddTable("ScrapSpearAttackTable", AttackTables.ScrapSpearAttackTable) 
AddTable("WingedSpearAttackTable", AttackTables.WingedSpearAttackTable) 
AddTable("WarScytheAttackTable", AttackTables.WarScytheAttackTable) 
AddTable("GlazicusAttackTable", AttackTables.GlazicusAttackTable)
AddTable("OrnateGlazicusAttackTable", AttackTables.OrnateGlazicusAttackTable)
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
AddTable("SteelGoreBattleAxeAttackTable", AttackTables.SteelGoreBattleAxeAttackTable)  
AddTable("PolehammerAttackTable", AttackTables.PolehammerAttackTable)
AddTable("IronRapierAttackTable", AttackTables.IronRapierAttackTable)    
AddTable("ElegantEpeeAttackTable", AttackTables.ElegantEpeeAttackTable) 
AddTable("FlangedMaceAttackTable", AttackTables.FlangedMaceAttackTable)       
AddTable("MorningStarAttackTable", AttackTables.MorningStarAttackTable)  
AddTable("BoneMaceAttackTable", AttackTables.BoneMaceAttackTable)          
AddTable("GoreHuntingDaggerAttackTable", AttackTables.GoreHuntingDaggerAttackTable)
AddTable("QuickshankAttackTable", AttackTables.QuickshankAttackTable)    
AddTable("ParryingDaggerAttackTable", AttackTables.ParryingDaggerAttackTable)
AddTable("KnightsbaneAttackTable", AttackTables.KnightsbaneAttackTable)  
AddTable("ElegantDaggerAttackTable", AttackTables.ElegantDaggerAttackTable)    
AddTable("GoreShortswordAttackTable", AttackTables.GoreShortswordAttackTable)  
AddTable("IronArmingSwordAttackTable", AttackTables.IronArmingSwordAttackTable)  
AddTable("LongswordAttackTable", AttackTables.LongswordAttackTable)  
AddTable("VoltlongswordAttackTable", AttackTables.VoltlongswordAttackTable)  
AddTable("ExileKnightSwordAttackTable", AttackTables.ExileKnightSwordAttackTable)       
AddTable("GlaiveAttackTable", AttackTables.GlaiveAttackTable)      
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
AddTable("SpathaAttackTable", AttackTables.SpathaAttackTable)
AddTable("SatanicShortswordAttackTable", AttackTables.SatanicShortswordAttackTable)
AddTable("Ancestraldagger_Rekh_AttackTable", AttackTables.Ancestraldagger_Rekh_AttackTable)
AddTable("Ancestraldagger_Varazdat_AttackTable", AttackTables.Ancestraldagger_Varazdat_AttackTable)
AddTable("Ancestraldagger_Philimaxio_AttackTable", AttackTables.Ancestraldagger_Philimaxio_AttackTable)
AddTable("Ancestraldagger_Kinisger_AttackTable", AttackTables.Ancestraldagger_Kinisger_AttackTable)
AddTable("DarklanderBardicheAttackTable", AttackTables.DarklanderBardicheAttackTable)
AddTable("EveningStarAttackTable", AttackTables.EveningStarAttackTable)
AddTable("WarHammerAttackTable", AttackTables.WarHammerAttackTable)
AddTable("HillGlazicusAttackTable", AttackTables.HillGlazicusAttackTable)
AddTable("HillSteelArmingSwordAttackTable", AttackTables.HillSteelArmingSwordAttackTable)
AddTable("HillBattleAxeAttackTable", AttackTables.HillBattleAxeAttackTable) 
AddTable("HillLongswordAttackTable", AttackTables.HillLongswordAttackTable)  
AddTable("HillHeavyBattleAxeAttackTable", AttackTables.HillHeavyBattleAxeAttackTable) 
AddTable("HillGoreHuntingDaggerAttackTable", AttackTables.HillGoreHuntingDaggerAttackTable)
AddTable("HillThrowingAxeAttackTable", AttackTables.HillThrowingAxeAttackTable)
AddTable("OrdainedGorefellerAttackTable", AttackTables.OrdainedGorefellerAttackTable)

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
	["poiseresistance"] = 25,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 18,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 25,
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
	["isadminweapon"] = true,
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
	["isadminweapon"] = true,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 20,
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

BlockTables.BoneDaggerBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
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
	["poiseresistance"] = 10,
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
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VoltspearBlockTable = {
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 10,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.IronShortSpearBlockTable = {
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
	["parrydifficulty"] = 0.25,
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
	["poiseresistance"] = 15,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
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
	["poiseresistance"] = 20,
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

BlockTables.OrnateGlazicusBlockTable = {
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
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 20,
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

BlockTables.SteelGoreBattleAxeBlockTable = {
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 25,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
};

BlockTables.VoltlongswordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
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
	["poiseresistance"] = 25,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
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
	["poiseresistance"] = 20,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
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
	["parrytakestamina"] = 12,
	["canparry"] = true,
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
	["parrytakestamina"] = 12,
	["canparry"] = true,
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
	["parrytakestamina"] = 12,
	["canparry"] = true,
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
	["poiseresistance"] = 25,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 18,
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
	["poiseresistance"] = 18,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 25,
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
	["poiseresistance"] = 20,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
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

BlockTables.SatanicSwordBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
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
	["poiseresistance"] = 30,
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
	["poiseresistance"] = 25,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
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
	["poiseresistance"] = 20,
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
	["poiseresistance"] = 25,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 15,
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
	["poiseresistance"] = 20,
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
	["isadminweapon"] = true,
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
	["poiseresistance"] = 25,
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
	["isadminweapon"] = true,
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

BlockTables.BoneMaceBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
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

BlockTables.SpathaBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 15,
	["blockeffectpos"] = (Vector(0, 0, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 20,
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

BlockTables.DarklanderBardicheBlockTable = {
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

BlockTables.EveningStarBlockTable = {
	["guardblockamount"] = 10,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 65)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["partialbulletblock"] = false,
	["poiseresistance"] = 30,
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

BlockTables.HillGlazicusBlockTable = {
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

BlockTables.HillSteelArmingSwordBlockTable = {
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

BlockTables.HillBattleAxeBlockTable = {
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

BlockTables.HillLongswordBlockTable = {
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

BlockTables.HillHeavyBattleAxeBlockTable = {
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

BlockTables.HillGoreHuntingDaggerBlockTable = {
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

BlockTables.OrdainedGorefellerBlockTable = {
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
AddTable("BoneDaggerBlockTable", BlockTables.BoneDaggerBlockTable) 
AddTable("HarpoonBlockTable", BlockTables.HarpoonBlockTable) 
AddTable("IronSpearBlockTable", BlockTables.IronSpearBlockTable) 
AddTable("VoltspearBlockTable", BlockTables.VoltspearBlockTable) 
AddTable("SatanicSpearBlockTable", BlockTables.SatanicSpearBlockTable) 
AddTable("ScrapSpearBlockTable", BlockTables.ScrapSpearBlockTable) 
AddTable("IronShortSpearBlockTable", BlockTables.IronShortSpearBlockTable) 
AddTable("WingedSpearBlockTable", BlockTables.WingedSpearBlockTable) 
AddTable("WarScytheBlockTable", BlockTables.WarScytheBlockTable)  
AddTable("GlazicusBlockTable", BlockTables.GlazicusBlockTable)  
AddTable("OrnateGlazicusBlockTable", BlockTables.OrnateGlazicusBlockTable)  
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
AddTable("SteelGoreBattleAxeBlockTable", BlockTables.SteelGoreBattleAxeBlockTable)  
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
AddTable("VoltlongswordBlockTable", BlockTables.LongswordBlockTable)        
AddTable("ExileKnightSwordBlockTable", BlockTables.ExileKnightSwordBlockTable)  
AddTable("GlaiveBlockTable", BlockTables.GlaiveBlockTable) 
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
AddTable("BoneMaceBlockTable", BlockTables.BoneMaceBlockTable)
AddTable("TireIronBlockTable", BlockTables.TireIronBlockTable)
AddTable("ScrapAxeBlockTable", BlockTables.ScrapAxeBlockTable)
AddTable("SteelArmingSwordBlockTable", BlockTables.SteelArmingSwordBlockTable)
AddTable("SpathaBlockTable", BlockTables.SpathaBlockTable)
AddTable("SatanicShortswordBlockTable", BlockTables.SatanicShortswordBlockTable)
AddTable("Ancestraldagger_Rekh_BlockTable", BlockTables.Ancestraldagger_Rekh_BlockTable)
AddTable("Ancestraldagger_Varazdat_BlockTable", BlockTables.Ancestraldagger_Varazdat_BlockTable)
AddTable("Ancestraldagger_Philimaxio_BlockTable", BlockTables.Ancestraldagger_Philimaxio_BlockTable)
AddTable("Ancestraldagger_Kinisger_BlockTable", BlockTables.Ancestraldagger_Kinisger_BlockTable)
AddTable("DarklanderBardicheBlockTable", BlockTables.DarklanderBardicheBlockTable)
AddTable("EveningStarBlockTable", BlockTables.EveningStarBlockTable)
AddTable("WarHammerBlockTable", BlockTables.WarHammerBlockTable)
AddTable("HillGlazicusBlockTable", BlockTables.HillGlazicusBlockTable)
AddTable("HillSteelArmingSwordBlockTable", BlockTables.HillSteelArmingSwordBlockTable)
AddTable("HillBattleAxeBlockTable", BlockTables.HillBattleAxeBlockTable)
AddTable("HillLongswordBlockTable", BlockTables.HillLongswordBlockTable)        
AddTable("HillHeavyBattleAxeBlockTable", BlockTables.HillHeavyBattleAxeBlockTable)        
AddTable("HillGoreHuntingDaggerBlockTable", BlockTables.HillGoreHuntingDaggerBlockTable)  
AddTable("OrdainedGorefellerBlockTable", BlockTables.OrdainedGorefellerBlockTable)

-- Shield Stat Tables

BlockTables.shield1 = { -- Scrap Shield
	["name"] = "Scrap Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_twindragon",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.8,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 25,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(5.44, -8, 2), ang = Vector(2.5, -8.443, -14.775)},
		["models/v_begottenknife.mdl"] = {pos = Vector(-1.241, -8.844, 2.2), ang = Vector(-1.5, -40.102, 4.221)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(19.639, -4.02, 3.67), ang = Vector(3.517, 0, -4)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_bebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.792, -2.597, 4), angle = Angle(146.104, -1.17, -138), size = Vector(0.6, 0.6, 0.6), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_bebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, -6, 10), angle = Angle(-85.325, 47.922, 0), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_bebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(2, -16.105, 4), angle = Angle(26.881, -127.403, -62), size = Vector(1.4, 1.4, 1.4), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield1"] = { type = "Model", model = "models/props_bebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(9, -4.677, -1.558), angle = Angle(-5, 50, 276), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield2 = { -- Slaveshield
	["name"] = "Slaveshield",
	["guardblockamount"] = 10,
	["damagereduction"] = 0.95,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 35)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 12,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 8,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(8.119, -1.609, 2.359), ang = Vector(2.111, -8.443, 9.145)},
		["models/v_begottenknife.mdl"] = {pos = Vector(7.4, -10.051, 5.079), ang = Vector(5.627, -6.332, -11.256)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(4.199, -5.026, 4.719), ang = Vector(0, -4.926, -13.367)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield2"] = { type = "Model", model = "models/demonssouls/shields/slave's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-5.715, -19.222, 10.909), angle = Angle(-47.923, 118.052, -38.571), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield2"] = { type = "Model", model = "models/demonssouls/shields/slave's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, -7.792, 5.714), angle = Angle(169.481, -139.092, 160.13), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield2"] = { type = "Model", model = "models/demonssouls/shields/slave's shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(18.181, 8.831, 4.675), angle = Angle(66.623, 90, -29.222), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield2"] = { type = "Model", model = "models/demonssouls/shields/slave's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.635, 1.557, 0), angle = Angle(101.688, 66.623, 0), size = Vector(1.299, 1.299, 1.299), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield3 = { -- Car Door Shield
	["name"] = "Car Door Shield",
	["guardblockamount"] = 3,
	["damagereduction"] = 0.75,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(-5, -15, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_cardoor",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 55,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 50,
	["canparry"] = false,
	["candeflect"] = false,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(16.04, -7.237, 0.639), ang = Vector(0, 11.96, 25.326)},
		["models/v_begottenknife.mdl"] = {pos = Vector(15.079, -7.639, 11.279), ang = Vector(-14.07, -3.518, 56.985)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(10, -4, 5), ang = Vector(0, 0, 30)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield3"] = { type = "Model", model = "models/props_vehicles/carparts_door01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0.518, -19.222, 2.596), angle = Angle(-136.754, 68.96, -19.871), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield3"] = { type = "Model", model = "models/props_vehicles/carparts_door01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, -2.597, 2.596), angle = Angle(176.494, 80.649, -71.3), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield3"] = { type = "Model", model = "models/props_vehicles/carparts_door01a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(16, 2, 4), angle = Angle(-5, 140.779, 5.843), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield3"] = { type = "Model", model = "models/props_vehicles/carparts_door01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-2.597, -5.715, -1.558), angle = Angle(-64.287, -26.883, -160.131), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield4 = { -- Buckler
	["name"] = "Buckler",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.95,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25, 
	["blockeffectpos"] = (Vector(0, -5, 40)),
	["blockcone"] = 180,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 15,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.3,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
	["deflectionwindow"] = 0.25,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(10.039, -10.051, 9.159), ang = Vector(-1.407, -4.222, -18.996)},
		["models/v_begottenknife.mdl"] = {pos = Vector(7, -6.433, 5.119), ang = Vector(-3.518, -3.518, -13.367)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(0.959, -4.222, 2.68), ang = Vector(0, -7.035, -16.181)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield4"] = { type = "Model", model = "models/demonssouls/shields/buckler.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -15.065, 0.518), angle = Angle(-129.741, 68.96, -104.027), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield4"] = { type = "Model", model = "models/demonssouls/shields/buckler.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 4.675), angle = Angle(-139.092, -57.273, -174.157), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield4"] = { type = "Model", model = "models/demonssouls/shields/buckler.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(19.221, 5.714, 1.557), angle = Angle(71.299, 90, -24.546), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield4"] = { type = "Model", model = "models/demonssouls/shields/buckler.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.899, 1.899, 0.5), angle = Angle(87.662, 66.623, 5.842), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield5 = { -- Wooden Shield
	["name"] = "Wooden Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.9,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 20,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(11.96, -7.035, 5.4), ang = Vector(-3.518, 1.406, 0.703)},
		["models/v_begottenknife.mdl"] = {pos = Vector(8.96, -7.639, 2.279), ang = Vector(-4.222, -1.407, -4.926)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(2.68, -9.849, 3.17), ang = Vector(5.627, -2.112, -15.478)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield5"] = { type = "Model", model = "models/skyrim/shield_stormcloaks.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-146.105, 71.299, -106.364), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield5"] = { type = "Model", model = "models/skyrim/shield_stormcloaks.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 4.675), angle = Angle(-139.092, -45.584, 178.83), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield5"] = { type = "Model", model = "models/skyrim/shield_stormcloaks.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(18.181, 1.557, -0.519), angle = Angle(-68.961, -101.689, 5.843), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield5"] = { type = "Model", model = "models/skyrim/shield_stormcloaks.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.635, 0.518, 0), angle = Angle(100, 53.9, 0), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield6 = { -- Iron Shield
	["name"] = "Iron Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.56, -8.242, 6.199), ang = Vector(-1.407, -5.628, -3.518)},
		["models/v_begottenknife.mdl"] = {pos = Vector(2.96, -5.428, 3.72), ang = Vector(-5.628, -16.181, -4.926)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(4.88, -9.447, 4.039), ang = Vector(0, 1.406, -14.775)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-146.105, 71.299, -106.364), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 8.831), angle = Angle(-155.456, -47.923, 180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -0.519, -0.519), angle = Angle(61.948, 80.649, -15.195), size = Vector(1.299, 1.299, 1.299), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.5, 1.5, 0), angle = Angle(100, 67.5, 0), size = Vector(1.299, 1.299, 1.299), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield7 = { -- Knight's Shield
	["name"] = "Knight's Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 5,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.159, -9.849, 7.88), ang = Vector(-6.332, -3.518, -8.443)},
		["models/v_begottenknife.mdl"] = {pos = Vector(3.24, -7.437, 3.079), ang = Vector(-3, -15, -3.901)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.519, -8.844, 3.16), ang = Vector(4.925, -1.407, -11.256)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield7"] = { type = "Model", model = "models/demonssouls/shields/knight's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-45.584, 106.363, -26.883), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield7"] = { type = "Model", model = "models/demonssouls/shields/knight's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 8.831), angle = Angle(-155.456, -47.923, -170), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield7"] = { type = "Model", model = "models/demonssouls/shields/knight's shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -0.519, -1.558), angle = Angle(64.286, 92.337, -22.209), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield7"] = { type = "Model", model = "models/demonssouls/shields/knight's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(-94.676, -106.364, 40), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield8 = { -- Spiked Shield
	["name"] = "Spiked Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 30,
	["raisespeed"] = 1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["spiked"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.8, -9.247, 3.68), ang = Vector(6.331, 0, -7.739)},
		["models/v_begottenknife.mdl"] = {pos = Vector(3.559, -6.433, 3.839), ang = Vector(-6, -14, -3.79)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(4.36, -8.643, 4.28), ang = Vector(0, 2.813, -15.478)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield8"] = { type = "Model", model = "models/demonssouls/shields/spiked shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-45.584, 106.363, -26.883), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield8"] = { type = "Model", model = "models/demonssouls/shields/spiked shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 8.831), angle = Angle(-155.456, -47.923, -157.793), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield8"] = { type = "Model", model = "models/demonssouls/shields/spiked shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -0.519, -0.519), angle = Angle(61.948, 80.649, -15.195), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield8"] = { type = "Model", model = "models/demonssouls/shields/spiked shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.5, 1.5, 0), angle = Angle(101.688, 70, -3.507), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield9 = { -- Sol Sentinel Shield
	["name"] = "Sol Sentinel Shield",
	["guardblockamount"] = 2,
	["damagereduction"] = 0.7,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 999,
	["raisespeed"] = 2.2,
	["instantraise"] = false,
	["parrydifficulty"] = nil,
	["parrytakestamina"] = nil,
	["canparry"] = false,
	["candeflect"] = false,
	["sensitivityoverride"] = {guarded = 0.25, unguarded = 0.5},
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(14, -10.051, 5.88), ang = Vector(1.406, 0, -2.112)},
		["models/v_begottenknife.mdl"] = {pos = Vector(5.079, -7.035, 5), ang = Vector(-2.814, -16.885, -4.222)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(2.279, -4.422, 1.44), ang = Vector(0, -5.628, -9.146)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield9"] = { type = "Model", model = "models/demonssouls/shields/tower shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-8.832, -3.636, -6.753), angle = Angle(-52.598, 108.7, -31.559), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield9"] = { type = "Model", model = "models/demonssouls/shields/tower shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-8.832, 1.557, 8.831), angle = Angle(-155.456, -47.923, -157.793), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield9"] = { type = "Model", model = "models/demonssouls/shields/tower shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(11.947, 5.714, 0.518), angle = Angle(64.286, 101.688, -22.209), size = Vector(0.6, 0.6, 0.6), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield9"] = { type = "Model", model = "models/demonssouls/shields/tower shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 1.5, 0), angle = Angle(82.986, -101.689, 180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield10 = { -- Gore Guardian Shield
	["name"] = "Gore Guardian Shield",
	["guardblockamount"] = 2,
	["damagereduction"] = 0.7,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 999,
	["raisespeed"] = 2.2,
	["instantraise"] = false,
	["parrydifficulty"] = nil,
	["parrytakestamina"] = nil,
	["canparry"] = false,
	["candeflect"] = false,
	["sensitivityoverride"] = {guarded = 0.25, unguarded = 0.5},
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(-2.481, -6.231, 1.24), ang = Vector(3.517, -27.57, -12.9)},
		["models/v_begottenknife.mdl"] = {pos = Vector(5.079, -3.82, -0.361), ang = Vector(8.442, -0.704, -12.664)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(2.64, -8.242, -0.08), ang = Vector(9.848, 0.703, -16.181)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield10"] = { type = "Model", model = "models/demonssouls/shields/large brushwood shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-11.948, 8.831, -4.676), angle = Angle(26.882, -54.936, 73.636), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield10"] = { type = "Model", model = "models/demonssouls/shields/large brushwood shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-4.676, -0.519, 5.714), angle = Angle(-139.092, -57.273, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield10"] = { type = "Model", model = "models/demonssouls/shields/large brushwood shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -0.519, -0.519), angle = Angle(61.948, 80.649, -15.195), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield10"] = { type = "Model", model = "models/demonssouls/shields/large brushwood shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.789, 1.2, -0.9), angle = Angle(-85.325, -180, -26.883), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield11 = { -- Gatekeeper Shield
	["name"] = "Gatekeeper Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_twindragon",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 35,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(8.039, -7.237, 2.411), ang = Vector(0, -16.181, 0)},
		["models/v_begottenknife.mdl"] = {pos = Vector(10.8, -8.643, 4.159), ang = Vector(0, 0, -2)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.68, -6.835, 0.479), ang = Vector(2.111, -26.031, -4.222)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield11"] = { type = "Model", model = "models/props/begotten/melee/twin_dragon_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-10.91, 6.752, -4.676), angle = Angle(35, 73.636, 134.416), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield11"] = { type = "Model", model = "models/props/begotten/melee/twin_dragon_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-5.715, 1.557, 4.675), angle = Angle(178.83, -132.079, -36.235), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield11"] = { type = "Model", model = "models/props/begotten/melee/twin_dragon_greatshield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12, 4, 2), angle = Angle(20, -30, -90), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield11"] = { type = "Model", model = "models/props/begotten/melee/twin_dragon_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 2.596, -0.519), angle = Angle(5.843, 146.104, 87.662), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield12 = { -- Warfighter Shield
	["name"] = "Warfighter Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 30,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 40,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(10.6, -3.217, -0.32), ang = Vector(0, 0, -2.112)},
		["models/v_begottenknife.mdl"] = {pos = Vector(9, -8.04, 0.68), ang = Vector(0, -7.035, -7.739)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(9.8, 0, 4.8), ang = Vector(-10.554, -12.664, 13.366)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield12"] = { type = "Model", model = "models/props/begotten/melee/pursuer_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-10.91, 4.675, -1.558), angle = Angle(-31.559, -106.364, -115.714), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield12"] = { type = "Model", model = "models/props/begotten/melee/pursuer_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0.518, -6.753, 2.596), angle = Angle(178.83, -132.079, -36.235), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield12"] = { type = "Model", model = "models/props/begotten/melee/pursuer_greatshield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12, 7, 5), angle = Angle(-140, -30, -80), size = Vector(0.6, 0.6, 0.6), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield12"] = { type = "Model", model = "models/props/begotten/melee/pursuer_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0.518, 2, 0.518), angle = Angle(-180, -40, -100), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield13 = { -- Dreadshield
	["name"] = "Dreadshield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 40,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 15,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(6.639, -9.046, -0.08), ang = Vector(7.5, -2, -7)},
		["models/v_begottenknife.mdl"] = {pos = Vector(6, -8.04, 2.68), ang = Vector(0, -9.146, -6.332)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.559, -6.031, 1.279), ang = Vector(0, -27.438, -5.628)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield13"] = { type = "Model", model = "models/props/begotten/melee/drakekeeper_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-8.832, 10.909, -5.715), angle = Angle(143.766, -106.364, -71.3), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield13"] = { type = "Model", model = "models/props/begotten/melee/drakekeeper_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.792, 3.635, 4.675), angle = Angle(176.494, -136.754, -36.235), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield13"] = { type = "Model", model = "models/props/begotten/melee/drakekeeper_greatshield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(10, 2, 2), angle = Angle(20, -30, -90), size = Vector(0.75, 0.75, 0.75), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield13"] = { type = "Model", model = "models/props/begotten/melee/drakekeeper_greatshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(174.156, -33.896, -90), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield14 = { -- Clan Shield
	["name"] = "Clan Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.9,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 30,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.72, -1.005, 5.92), ang = Vector(-4.926, -6.332, -9.146)},
		["models/v_begottenknife.mdl"] = {pos = Vector(8.079, -5.428, 1.6), ang = Vector(3.517, -10.9, -6.332)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(9.479, -5.628, 4.639), ang = Vector(-2.112, 1.406, -0.704)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield14"] = { type = "Model", model = "models/begotten/weapons/goreroundshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-4.676, -14.027, 0.518), angle = Angle(-141.43, 68.96, -29.222), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield14"] = { type = "Model", model = "models/begotten/weapons/goreroundshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -7.792, 5.714), angle = Angle(174.156, -136.754, -122.727), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield14"] = { type = "Model", model = "models/begotten/weapons/goreroundshield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -2.901, -0.519), angle = Angle(153.117, 150.779, -26.883), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield14"] = { type = "Model", model = "models/begotten/weapons/goreroundshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.635, 0.99, 0), angle = Angle(-1.17, -36.235, -167.144), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield15 = { -- Voltshield
	["name"] = "Voltshield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 55)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_twindragon",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.8,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 25,
	["canparry"] = true,
	["candeflect"] = true,
	["electrified"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(5.44, -8, 2), ang = Vector(2.5, -8.443, -14.775)},
		["models/v_begottenknife.mdl"] = {pos = Vector(-1.241, -8.844, 2.2), ang = Vector(-1.5, -40.102, 4.221)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(19.639, -4.02, 3.67), ang = Vector(3.517, 0, -4)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_vebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.792, -2.597, 4), angle = Angle(146.104, -1.17, -138), size = Vector(0.6, 0.6, 0.6), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_vebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, -6, 10), angle = Angle(-85.325, 47.922, 0), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield1"] = { type = "Model", model = "models/props_vebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(2, -16.105, 4), angle = Angle(26.881, -127.403, -62), size = Vector(1.4, 1.4, 1.4), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield1"] = { type = "Model", model = "models/props_vebris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(9, -4.677, -1.558), angle = Angle(-5, 50, 276), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield16 = { -- Steel Tower Shield
	["name"] = "Steel Tower Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 35,
	["raisespeed"] = 1.7,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 30,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(6.639, -9.046, -0.08), ang = Vector(7.5, -2, -7)},
		["models/v_begottenknife.mdl"] = {pos = Vector(6, -8.04, 2.68), ang = Vector(0, -9.146, -6.332)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.559, -6.031, 1.279), ang = Vector(0, -27.438, -5.628)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/pate_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-6, 2.5, 0), angle = Angle(-32, -120, 60), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/pate_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-2, -6, 10), angle = Angle(0, -135, 40), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/pate_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(14.5, 6, 3.5), angle = Angle(200, -30, 90), size = Vector(0.75, 0.75, 0.75), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield16"] = { type = "Model", model = "models/props/begotten/melee/pate_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(-6.156, -33.896, 90), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield17 = { -- Leather Shield
	["name"] = "Leather Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.9,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.25,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(11.96, -7.035, 5.4), ang = Vector(-3.518, 1.406, 0.703)},
		["models/v_begottenknife.mdl"] = {pos = Vector(8.96, -7.639, 2.279), ang = Vector(-4.222, -1.407, -4.926)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(2.68, -9.849, 3.17), ang = Vector(5.627, -2.112, -15.478)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield17"] = { type = "Model", model = "models/props/begotten/melee/large_leather_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-146.105, 71.299, -106.364), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield17"] = { type = "Model", model = "models/props/begotten/melee/large_leather_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 4.675), angle = Angle(178.83, 42, -139.092), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield17"] = { type = "Model", model = "models/props/begotten/melee/large_leather_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(18.181, 0, -0.519), angle = Angle(-15, 160, -60), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield17"] = { type = "Model", model = "models/props/begotten/melee/large_leather_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2, 2, 0), angle = Angle(0, 143.9, -100), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield18 = { -- Steel Gatekeeper Shield
	["name"] = "Steel Gatekeeper Shield",
	["guardblockamount"] = 3,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 70,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 40,
	["canparry"] = true,
	["candeflect"] = false,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(6.639, -9.046, -0.08), ang = Vector(7.5, -2, -7)},
		["models/v_begottenknife.mdl"] = {pos = Vector(6, -8.04, 2.68), ang = Vector(0, -9.146, -6.332)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.559, -6.031, 1.279), ang = Vector(0, -27.438, -5.628)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/tower_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-12, 5, 0), angle = Angle(-32, -120, 60), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/tower_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-9, 3.635, 7), angle = Angle(176.494, -136.754, -216.235), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield18"] = { type = "Model", model = "models/props/begotten/melee/tower_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12, 8, 3.5), angle = Angle(200, -30, 90), size = Vector(0.75, 0.75, 0.75), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield18"] = { type = "Model", model = "models/props/begotten/melee/tower_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(-5.844, -33.896, 90), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield19 = { -- Rusted Kite Shield
	["name"] = "Rusted Kite Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.159, -9.849, 7.88), ang = Vector(-6.332, -3.518, -8.443)},
		["models/v_begottenknife.mdl"] = {pos = Vector(3.24, -7.437, 3.079), ang = Vector(-3, -15, -3.901)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.519, -8.844, 3.16), ang = Vector(4.925, -1.407, -11.256)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield19"] = { type = "Model", model = "models/props/begotten/melee/red_rust_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, -11, -2), angle = Angle(-135, 90, -115), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield19"] = { type = "Model", model = "models/props/begotten/melee/red_rust_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 8.831), angle = Angle(-160, 60, -145), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield19"] = { type = "Model", model = "models/props/begotten/melee/red_rust_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(13, 5, 4), angle = Angle(-15, 160, -60), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield19"] = { type = "Model", model = "models/props/begotten/melee/red_rust_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(-0.676, -35.364, 90), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shield20 = { -- Old Soldier Shield
	["name"] = "Old Soldier Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(-5, -10, 45)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 25,
	["raisespeed"] = 1.1,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(9.159, -9.849, 7.88), ang = Vector(-6.332, -3.518, -8.443)},
		["models/v_begottenknife.mdl"] = {pos = Vector(3.24, -7.437, 3.079), ang = Vector(-3, -15, -3.901)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.519, -8.844, 3.16), ang = Vector(4.925, -1.407, -11.256)},
	},
	["ViewModelBoneMods"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
		},
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["shield20"] = { type = "Model", model = "models/begotten/thralls/skellyshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, -11, 2), angle = Angle(40, 66, -33), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["shield20"] = { type = "Model", model = "models/begotten/thralls/skellyshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.675, -7.792, 8.831), angle = Angle(0, 45, -13), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["shield20"] = { type = "Model", model = "models/begotten/thralls/skellyshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5, 0, 0), angle = Angle(15, 30, -40), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} },
		},
	},
	["WElements"] = {
		["shield20"] = { type = "Model", model = "models/begotten/thralls/skellyshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, -3.5, 0), angle = Angle(180, -35, 90), size = Vector(1.1, 1.1, 1.1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shieldunique1 = { -- Red Wolf Skinshield (Unique)
	["name"] = "Red Wolf Skinshield",
	["guardblockamount"] = 3,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_pursuer",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 999,
	["raisespeed"] = 2,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 40,
	["canparry"] = true,
	["candeflect"] = false,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(5, -9.849, -3.481), ang = Vector(4.221, -16.885, 4.221)},
		["models/v_begottenknife.mdl"] = {pos = Vector(8.199, -4.222, -3.04), ang = Vector(0, -19.698, 4.925)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(9.96, -5.428, -2.8), ang = Vector(5.627, -20.403, 5.627)},
	},
		["VElements"] = {
			["models/v_onehandedbegotten.mdl"] = {
				["shield_red_wolf"] = { type = "Model", model = "models/begotten/weapons/uniquegoreshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-3.636, 11.947, -6.753), angle = Angle(35, 73.636, 134.416), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
			},
			["models/v_begottenknife.mdl"] = {
				["shield_red_wolf"] = { type = "Model", model = "models/begotten/weapons/uniquegoreshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-17.143, 7.791, 3.635), angle = Angle(0, 50, 160.13), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
			},
			["models/weapons/cstrike/c_knife_t.mdl"] = {
				["shield_red_wolf"] = { type = "Model", model = "models/begotten/weapons/uniquegoreshield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(5.714, -7.792, -1.558), angle = Angle(24.545, -31.559, -87.663), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["shield_red_wolf"] = { type = "Model", model = "models/begotten/weapons/uniquegoreshield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.557, -3.636, 0.518), angle = Angle(3.506, 143.766, 82.986), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shieldunique2 = { -- Sol Shield (Unique)
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 35,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["partialbulletblock"] = false,
	["poiseresistance"] = 35,
	["raisespeed"] = 0.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.25,
	["parrytakestamina"] = 10,
	["canparry"] = true,
	["candeflect"] = true,
};

-- Hill shit (shields)

BlockTables.shieldhill = { -- Hillkeeper Shield
	["name"] = "Hillkeeper Shield",
	["guardblockamount"] = 5,
	["damagereduction"] = 0.8,
	["specialeffect"] = false,
	["blockeffect"] = "GlassImpact",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_twindragon",
	["blocksoundtable"] = "WoodenShieldSoundTable",
	["partialbulletblock"] = true,
	["poiseresistance"] = 35,
	["raisespeed"] = 1.75,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 35,
	["canparry"] = true,
	["candeflect"] = true,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(8.039, -7.237, 2.411), ang = Vector(0, -16.181, 0)},
		["models/v_begottenknife.mdl"] = {pos = Vector(10.8, -8.643, 4.159), ang = Vector(0, 0, -2)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.68, -6.835, 0.479), ang = Vector(2.111, -26.031, -4.222)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["hillshield"] = { type = "Model", model = "models/begotten_apocalypse/items/hill_kite_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-10.91, 3.5, 0), angle = Angle(35, 73.636, 134.416), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["hillshield"] = { type = "Model", model = "models/begotten_apocalypse/items/hill_kite_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-5.715, -4.557, 8), angle = Angle(178.83, -132.079, -36.235), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["hillshield"] = { type = "Model", model = "models/begotten_apocalypse/items/hill_kite_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(16, 4, 4), angle = Angle(20, -30, -90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["hillshield"] = { type = "Model", model = "models/begotten_apocalypse/items/hill_kite_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 3, 0), angle = Angle(5.843, 146.104, 87.662), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
};

BlockTables.shieldhillsteel = { -- Steel Hillkeeper Shield
	["name"] = "Steel Hillkeeper Shield",
	["guardblockamount"] = 3,
	["damagereduction"] = 0.75,
	["specialeffect"] = false,
	["blockeffect"] = "MetalSpark",
	["blockeffectforward"] = 25,
	["blockeffectpos"] = (Vector(0, -10, 50)),
	["blockcone"] = 220,
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE, DMG_BULLET, DMG_BUCKSHOT},
	["blockanim"] = "a_sword_shield_block_drakekeeper",
	["blocksoundtable"] = "MetalShieldSoundTable",
	["partialbulletblock"] = false,
	["poiseresistance"] = 70,
	["raisespeed"] = 1.9,
	["instantraise"] = false,
	["parrydifficulty"] = 0.2,
	["parrytakestamina"] = 50,
	["canparry"] = true,
	["candeflect"] = false,
	["ironsights"] = {
		["models/v_onehandedbegotten.mdl"] = {pos = Vector(6.639, -9.046, -0.08), ang = Vector(7.5, -2, -7)},
		["models/v_begottenknife.mdl"] = {pos = Vector(6, -8.04, 2.68), ang = Vector(0, -9.146, -6.332)},
		["models/weapons/cstrike/c_knife_t.mdl"] = {pos = Vector(3.559, -6.031, 1.279), ang = Vector(0, -27.438, -5.628)},
	},
	["ViewModelBoneMods"] = {
		["models/v_begottenknife.mdl"] = {
			["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(6.852, -9.815, -3.149), angle = Angle(0, 0, 0) }
		},
	},
	["VElements"] = {
		["models/v_onehandedbegotten.mdl"] = {
			["hillsteelshield"] = { type = "Model", model = "models/props/begotten/melee/defender_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-12, 5, 0), angle = Angle(-212, -120, 120), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		},
		["models/v_begottenknife.mdl"] = {
			["hillsteelshield"] = { type = "Model", model = "models/props/begotten/melee/defender_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-3, -.4, 5), angle = Angle(176.494, -136.754, -216.235), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		},
		["models/weapons/cstrike/c_knife_t.mdl"] = {
			["hillsteelshield"] = { type = "Model", model = "models/props/begotten/melee/defender_shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(13, 8, 3.5), angle = Angle(20, -30, 90), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
		},
	},
	["WElements"] = {
		["hillsteelshield"] = { type = "Model", model = "models/props/begotten/melee/defender_shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(180.844, -33.896, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	},
};

AddTable("shield1", BlockTables.shield1)
AddTable("shield2", BlockTables.shield2)
AddTable("shield3", BlockTables.shield3)
AddTable("shield4", BlockTables.shield4)
AddTable("shield5", BlockTables.shield5)
AddTable("shield6", BlockTables.shield6)
AddTable("shield7", BlockTables.shield7)
AddTable("shield8", BlockTables.shield8)
AddTable("shield9", BlockTables.shield9)
AddTable("shield10", BlockTables.shield10)
AddTable("shield11", BlockTables.shield11)
AddTable("shield12", BlockTables.shield12)
AddTable("shield13", BlockTables.shield13)
AddTable("shield14", BlockTables.shield14)
AddTable("shield15", BlockTables.shield15)
AddTable("shield16", BlockTables.shield16)
AddTable("shield17", BlockTables.shield17)
AddTable("shield18", BlockTables.shield18)
AddTable("shield19", BlockTables.shield19)
AddTable("shield20", BlockTables.shield20)
AddTable("shieldunique1", BlockTables.shieldunique1)
AddTable("shieldunique2", BlockTables.shieldunique2)
AddTable("shieldhill", BlockTables.shieldhill)
AddTable("shieldhillsteel", BlockTables.shieldhillsteel)

-- Dummy tables for use with tooltips that have the min/max values.
local meleemax = {};
local meleemin = {};

for k, v in pairs(AttackTables) do
	if v.isadminweapon then continue end;

	for k2, v2 in pairs(v) do
		if isnumber(v2) then
			if !meleemax[k2] then
				meleemax[k2] = v2;
			end
			
			if !meleemin[k2] then
				meleemin[k2] = v2;
			end
		
			if v2 > meleemax[k2] then
				meleemax[k2] = v2;
			end
			
			if v2 < meleemin[k2] then
				meleemin[k2] = v2;
			end
		end
	end
end

AddTable("meleemax", meleemax)
AddTable("meleemin", meleemin)

local shieldmax = {};
local shieldmin = {};

for k, v in pairs(BlockTables) do
	if v.isadminweapon then continue end;
	
	for k2, v2 in pairs(v) do
		if isnumber(v2) then
			if !shieldmax[k2] then
				shieldmax[k2] = v2;
			end
			
			if !shieldmin[k2] then
				shieldmin[k2] = v2;
			end
		
			if v2 > shieldmax[k2] then
				shieldmax[k2] = v2;
			end
			
			if v2 < shieldmin[k2] then
				shieldmin[k2] = v2;
			end
		end
	end
end

AddTable("shieldmax", shieldmax)
AddTable("shieldmin", shieldmin)

print "Melee Tables Loaded"
