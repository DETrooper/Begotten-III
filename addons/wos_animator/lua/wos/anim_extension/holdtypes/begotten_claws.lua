--=====================================================================
/*		My Custom Holdtype
			Created by thats sweet( STEAM_0:1:4916602 )*/
local DATA = {}
DATA.Name = "begotten_claws"
DATA.HoldType = "wos-begotten_claws"
DATA.BaseHoldType = "melee"
DATA.Translations = {} 


-- 		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
--		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
--		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
--		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
--		["run"] = {ACT_RUN, ACT_RUN},
--		["attack"] = ACT_MELEE_ATTACK_SWING

-- Crouching
DATA.Translations[ "crouch_aim_smg1" ] = {
	{ Sequence = "a_claws_crouch_idle", Weight = 1 },
}

DATA.Translations[ ACT_WALK_CROUCH ] = {
	{ Sequence = "a_claws_crouch_walk", Weight = 1 },
}

-- Idle
DATA.Translations[ ACT_IDLE_ANGRY_MELEE ] = {
	{ Sequence = "a_claws_unholstered_idle", Weight = 1 },
}

-- Walking
DATA.Translations[ ACT_WALK_AIM_RIFLE ] = {
	{ Sequence = "a_claws_unholstered_walk", Weight = 1 },
}

-- Running
DATA.Translations[ ACT_RUN_AIM_RIFLE_STIMULATED ] = {
	{ Sequence = "a_claws_unholstered_run", Weight = 1 },
}

-- Attack
DATA.Translations[ ACT_MELEE_ATTACK_SWING ] = {
	{ Sequence = "a_spear_2h_attack", Weight = 1 },
}

wOS.AnimExtension:RegisterHoldtype( DATA )
--=====================================================================