--=====================================================================
/*		My Custom Holdtype
			Created by thats sweet( STEAM_0:1:4916602 )*/
local DATA = {}
DATA.Name = "begotten_fists"
DATA.HoldType = "wos-begotten_fists"
DATA.BaseHoldType = "melee"
DATA.Translations = {} 


	--	["wos-begotten_fists"] = {
	--	["idle"] = {"idle_unarmed", ACT_IDLE_ANGRY_MELEE},
	--	["idle_crouch"] = {"crouchidle", ACT_COVER_LOW},
	--	["walk"] = {"walkunarmed_all", ACT_WALK_AIM_RIFLE},
	--	["walk_crouch"] = {"crouch_walkall", ACT_WALK_CROUCH},
	--	["run"] = {"runall", ACT_RUN_AIM_RIFLE_STIMULATED},
	--	["attack"] = ACT_MELEE_ATTACK_SWING

-- Crouching
DATA.Translations[ "crouch_aim_smg1" ] = {
	{ Sequence = "a_fists_crouch_idle", Weight = 1 },
}

DATA.Translations[ ACT_WALK_CROUCH_AIM_RIFLE ] = {
	{ Sequence = "a_fists_crouch_walk", Weight = 1 },
}

-- Idle
DATA.Translations[ ACT_IDLE_ANGRY_MELEE ] = {
	{ Sequence = "a_fists_unholstered_idle", Weight = 1 },
}

-- Walking
DATA.Translations[ ACT_WALK_AIM_RIFLE ] = {
	{ Sequence = "a_fists_unholstered_walk", Weight = 1 },
}

-- Running
DATA.Translations[ ACT_RUN_AIM_RIFLE_STIMULATED ] = {
	{ Sequence = "a_fists_unholstered_run", Weight = 1 },
}

-- Attack
DATA.Translations[ ACT_MELEE_ATTACK_SWING ] = {
	{ Sequence = "a_fists_attack1", Weight = 1 },
}

wOS.AnimExtension:RegisterHoldtype( DATA )
--=====================================================================
