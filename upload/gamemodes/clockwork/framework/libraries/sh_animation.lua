local Clockwork = Clockwork;
local type = type;
local string = string;
local math = math;

library.New("animation", Clockwork);
Clockwork.animation.sequences = Clockwork.animation.sequences or {};
Clockwork.animation.override = Clockwork.animation.override  or {};
Clockwork.animation.models = Clockwork.animation.models or {};
Clockwork.animation.stored = Clockwork.animation.stored or {};
Clockwork.animation.stored.combineOverwatch = {
	["normal"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {"idle_unarmed", ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE}
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SHOTGUN},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_SHOTGUN},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_SHOTGUN}
	},
	["grenade"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE}
	},
	["melee"] = {
		["idle"] = {"idle_unarmed", "man_gun"},
		["idle_crouch"] = {"crouchidle", "crouchidle"},
		["walk"] = {"walkunarmed_all", ACT_WALK_RIFLE},
		["walk_crouch"] = {"crouch_walkall", "crouch_walkall"},
		["run"] = {"runall", ACT_RUN_AIM_RIFLE},
		["attack"] = ACT_MELEE_ATTACK_SWING_GESTURE
	}
};

Clockwork.animation.stored.civilProtection = {
	["normal"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["glide"] = ACT_GLIDE
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK_PISTOL, ACT_WALK_AIM_PISTOL},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_PISTOL, ACT_RUN_AIM_PISTOL},
		["attack"] = ACT_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE}
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SMG1, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_SMG1_LOW, ACT_COVER_SMG1_LOW},
		["walk"] = {ACT_WALK_RIFLE, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN_RIFLE, ACT_RUN_AIM_RIFLE_STIMULATED}
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_ANGRY},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_COMBINE_THROW_GRENADE
	},
	["melee"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
		["idle_crouch"] = {ACT_COVER_PISTOL_LOW, ACT_COVER_PISTOL_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_ANGRY},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING_GESTURE
	}
};

Clockwork.animation.stored.femaleHuman = {
	["normal"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["glide"] = ACT_JUMP
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE_PISTOL, ACT_IDLE_ANGRY_PISTOL},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_PISTOL},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN_AIM_PISTOL},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_RANGE_ATTACK_THROW
	},
	["melee"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_spear_2h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_spear_1h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_spear_1h_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_fists"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_2h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_2h_great"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_1h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_1h_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
    ["wos-begotten_claws"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
    ["wos-begotten_dual"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_javelin"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_javelin_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	}
};


Clockwork.animation.stored.maleHuman = {
	["normal"] = {
		["idle"] = {ACT_IDLE_ANGRY, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["glide"] = ACT_JUMP,
	},
	["pistol"] = {
		["idle"] = {ACT_IDLE, "shootp1"},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_PISTOL,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["smg"] = {
		["idle"] = {ACT_IDLE_SMG1_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SMG1,
		["reload"] = ACT_GESTURE_RELOAD_SMG1
	},
	["shotgun"] = {
		["idle"] = {ACT_IDLE_SHOTGUN_RELAXED, ACT_IDLE_ANGRY_SMG1},
		["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
		["walk"] = {ACT_WALK_RIFLE_RELAXED, ACT_WALK_AIM_RIFLE_STIMULATED},
		["walk_crouch"] = {ACT_WALK_CROUCH_RIFLE, ACT_WALK_CROUCH_AIM_RIFLE},
		["run"] = {ACT_RUN_RIFLE_RELAXED, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_GESTURE_RANGE_ATTACK_SHOTGUN
	},
	["grenade"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
		["attack"] = ACT_RANGE_ATTACK_THROW
	},
	["melee"] = {
		["idle"] = {ACT_IDLE, ACT_IDLE_MANNEDGUN},
		["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
		["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		["run"] = {ACT_RUN, ACT_RUN},
		["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_spear_2h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_spear_1h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_spear_1h_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_fists"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH_AIM_RIFLE},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_2h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_2h_great"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_1h"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_1h_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
    ["wos-begotten_claws"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, "crouch_aim_smg1"},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
    ["wos-begotten_dual"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
    },
	["wos-begotten_javelin"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	},
	["wos-begotten_javelin_shield"] = {
        ["idle"] = {ACT_IDLE, ACT_IDLE_ANGRY_MELEE},
        ["idle_crouch"] = {ACT_COVER_LOW, ACT_COVER_LOW},
        ["walk"] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
        ["walk_crouch"] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
        ["run"] = {ACT_RUN, ACT_RUN_AIM_RIFLE_STIMULATED},
        ["attack"] = ACT_MELEE_ATTACK_SWING
	}
};

-- A function to set a model's menu sequence.
function Clockwork.animation:SetMenuSequence(model, sequence)
	self.sequences[string.lower(model)] = sequence;
end;

-- A function to get a model's menu sequence.
function Clockwork.animation:GetMenuSequence(model, bRandom)
	local lowerModel = string.lower(model);
	local sequence = self.sequences[lowerModel];
	
	if (sequence) then
		if (type(sequence) == "table") then
			if (bRandom) then
				return sequence[math.random(1, #sequence)];
			else
				return sequence;
			end;
		else
			return sequence;
		end;
	end;
end;

-- A function to add a model.
function Clockwork.animation:AddModel(class, model)
	local lowerModel = string.lower(model);
		self.models[lowerModel] = class;
	return lowerModel;
end;

-- A function to add an override.
function Clockwork.animation:AddOverride(model, key, value)
	local lowerModel = string.lower(model);
	
	if (!self.override[lowerModel]) then
		self.override[lowerModel] = {};
	end;
	
	self.override[lowerModel][key] = value;
end;

-- A function to get an animation for a model.
function Clockwork.animation:GetForModel(model, holdType, key, bNoFallbacks)
	if (!model) then
		debug.Trace();
		
		return false;
	end;

	local lowerModel = string.lower(model);
	local animTable = self:GetTable(lowerModel);
	local overrideTable = self.override[lowerModel];

	if (!bNoFallbacks) then
		if (!animTable[holdType]) then
			holdType = "normal";
		end;

		if (!animTable[holdType][key]) then
			key = "idle";
		end;
	end;

	local finalAnimation = animTable[holdType][key];
	
	if (overrideTable and overrideTable[holdType] and overrideTable[holdType][key]) then
		finalAnimation = overrideTable[holdType][key];
	end;
	
	return finalAnimation;
end;

-- A function to get a model's class.
function Clockwork.animation:GetModelClass(model, alwaysReal)
	local modelClass = self.models[string.lower(model)];
	
	if (!modelClass) then
		if (!alwaysReal) then
			return "maleHuman";
		end;
	else
		return modelClass;
	end;
end;

-- A function to add a Combine Overwatch model.
function Clockwork.animation:AddCombineOverwatchModel(model)
	return self:AddModel("combineOverwatch", model);
end;

-- A function to add a Civil Protection model.
function Clockwork.animation:AddCivilProtectionModel(model)
	return self:AddModel("civilProtection", model);
end;

-- A function to add a female human model.
function Clockwork.animation:AddFemaleHumanModel(model)
	return self:AddModel("femaleHuman", model);
end;

-- A function to add a male human model.
function Clockwork.animation:AddMaleHumanModel(model)
	return self:AddModel("maleHuman", model);
end;

--[[local translateHoldTypes = {
	["melee2"] = "melee",
	["fist"] = "melee",
	["knife"] = "melee",
	["ar2"] = "smg",
	["physgun"] = "smg",
	["crossbow"] = "smg",
	["slam"] = "grenade",
	["passive"] = "normal",
	["rpg"] = "shotgun",
};

local weaponHoldTypes = {
	["weapon_ar2"] = "smg",
	["weapon_smg1"] = "smg",
	["weapon_physgun"] = "smg",
	["weapon_crossbow"] = "smg",
	["weapon_physcannon"] = "smg",
	["weapon_crowbar"] = "melee",
	["weapon_bugbait"] = "melee",
	["weapon_stunstick"] = "melee",
	["weapon_stunstick"] = "melee",
	["gmod_tool"] = "pistol",
	["weapon_357"] = "pistol",
	["weapon_pistol"] = "pistol",
	["weapon_frag"] = "grenade",
	["weapon_slam"] = "grenade",
	["weapon_rpg"] = "shotgun",
	["weapon_shotgun"] = "shotgun",
	["weapon_annabelle"] = "shotgun"
};]]--

-- A function to get a weapon's hold type.
function Clockwork.animation:GetWeaponHoldType(player, weapon)
	--local class = string.lower(weapon:GetClass());
	local holdType = weapon:GetHoldType() or "normal";
	
	--[[if (weaponHoldTypes[class]) then
		holdType = weaponHoldTypes[class];
	elseif (translateHoldTypes[holdType]) then
		holdType = translateHoldTypes[holdType];
	end;]]--
	
	--return string.lower(holdType);
	return holdType;
end;

-- A function to get an animation table.
function Clockwork.animation:GetTable(model)
	local lowerModel = string.lower(model);
	local class = self.models[lowerModel];
	
	if (class and self.stored[class]) then
		return self.stored[class];
	elseif (string.find(lowerModel, "female")) then
		return self.stored.femaleHuman;
	else
		return self.stored.maleHuman;
	end;
end;

local function ADD_CITIZEN_MODELS(prefix)
	for k, v in pairs(file.Find("models/humans/group01/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group01/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group02/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group02/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group03/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group03/"..v);
	end;

	for k, v in pairs(file.Find("models/humans/group03m/"..prefix.."_*.mdl", "GAME")) do
		Clockwork.animation:AddModel(prefix.."Human", "models/humans/group03m/"..v);
	end;
end;

Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier_prisonguard.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_super_soldier.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier.mdl");

Clockwork.animation:AddCivilProtectionModel("models/police.mdl");

ADD_CITIZEN_MODELS("male"); 
ADD_CITIZEN_MODELS("female");

Clockwork.animation.models = Clockwork.animation.models or {};

-- A function to add a model.
function Clockwork.animation:AddModel(class, model)
	local lowerModel = string.lower(model);
		self.models[lowerModel] = class;
	return lowerModel;
end;

-- A function to add a vortigaunt model.
function Clockwork.animation:AddVortigauntModel(model)
	return self:AddModel("vortigaunt", model);
end;

-- A function to add a Combine Overwatch model.
function Clockwork.animation:AddCombineOverwatchModel(model)
	return self:AddModel("combineOverwatch", model);
end;

-- A function to add a Civil Protection model.
function Clockwork.animation:AddCivilProtectionModel(model)
	return self:AddModel("civilProtection", model);
end;

-- A function to add a female human model.
function Clockwork.animation:AddFemaleHumanModel(model)
	return self:AddModel("femaleHuman", model);
end;

-- A function to add a male human model.
function Clockwork.animation:AddMaleHumanModel(model)
	return self:AddModel("maleHuman", model);
end;

local handsModels = {};
local blackModels = {};

-- A function to add viewmodel c_arms info to a model.
function Clockwork.animation:AddHandsModel(model, hands)
	handsModels[string.lower(model)] = hands;
end;

-- A function to make a model use the black skin for hands viewmodels.
function Clockwork.animation:AddBlackModel(model)
	blackModels[string.lower(model)] = true;
end;

-- A function to make a model use the zombie skin for citizen hands.
function Clockwork.animation:AddZombieHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_citizen.mdl",
		skin = 2
	});
end;

-- A function to make a model use the HL2 HEV viewmodel hands.
function Clockwork.animation:AddHEVHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_hev.mdl",
		skin = 0
	});
end;

-- A function to make a model use the combine viewmodel hands.
function Clockwork.animation:AddCombineHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_combine.mdl",
		skin = 0
	});
end;

-- A function to make a model use the CSS viewmodel hands.
function Clockwork.animation:AddCSSHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_cstrike.mdl",
		skin = 0
	});
end;

-- A function to make a model use the refugee viewmodel hands.
function Clockwork.animation:AddRefugeeHands(model)
	self:AddHandsModel(model, {
		body = 01,
		model = "models/weapons/c_arms_refugee.mdl",
		skin = 0
	});
end;

-- a function to make a model use the refugee viewmodel hands with a zombie skin.
function Clockwork.animation:AddZombieRefugeeHands(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/weapons/c_arms_refugee.mdl",
		skin = 2
	});
end;

-- Custom hands.
function Clockwork.animation:AddWandererArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_wandererhands.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGatekeeperLightArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gatekeeperlightarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGatekeeperMediumArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gatekeepermediumarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGatekeeperHeavyArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gatekeeperheavyarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddInquisitorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_inquisitorarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddBlackInquisitorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_inquisitorarms_black.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddWhiteInquisitorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_inquisitorarms_white.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddDistrictOneArmorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/districtonearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddDreadArmorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_dreadarmorarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddHellspikeArmorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_hellspikearmorarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddWraithArmorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_wraitharms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddWarfighterArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_warfighterarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreTribalArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_goretribalarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreChieftanArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gorechieftanarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddBjornlingArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_bjornlingarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddVassoArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_lordvasso_arms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreChainMail1Arms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gorechainmail1arms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreChainMail2Arms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gorechainmail2arms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreHouseCarlArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gorehousecarlarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreBladeDruidArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_bladedruidarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddVoltistArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_voltistarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddElegantRobesArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_elegantrobes_arms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddHellplateHeavyArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_hellplate_heavyarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddHellplateMediumArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_hellplate_mediumarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddExileKnightArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/exileknightarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddKnightArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/knightarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGatekeeperFineArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gatekeeperfinearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGatekeeperOrnateArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_gatekeeperornatearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddMinisterArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_ministerarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddScrapperArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_scrapperarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddScribeArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_scribearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddMerchantArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_merchantarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddBrigandineArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_brigandinearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddBrigandineLightArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_brigandinelightarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddLeatherArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_leatherarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddPlagueDocArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_plaguedocarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddWandererMailArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_wanderermailarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddSpiceGuardArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_spiceguardarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddWandererOppressorArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_wandereroppressorarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddShingarArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_arms_shingar.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddKnightJusticarArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/justicararms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddLamellarArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_lamellararms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddTechnoHeavyArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_technoheavyarms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddMagistrateArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/begotten/arms/c_magistratearms.mdl",
		skin = 0
	});
end;

function Clockwork.animation:AddGoreScaleArms(model)
	self:AddHandsModel(model, {
		body = 0000000,
		model = "models/arms/c_gorescalearms.mdl",
		skin = 0
	});
end;

-- A function to check for stored hands info by model.
function Clockwork.animation:CheckHands(model, animTable)
	local info = animTable.hands or {
		body = 0000000,
		model = "models/weapons/c_arms_citizen.mdl",
		skin = 0
	};

	for k, v in pairs(handsModels) do
		if (string.find(model, k)) then
			info = v;

			break;
		end;
	end;

	self:AdjustHandsInfo(model, info);

	return info;
end;

-- A function to adjust the hands info with checks for if a model is set to use the black skin.
function Clockwork.animation:AdjustHandsInfo(model, info)
	if (info.model == "models/weapons/c_arms_citizen.mdl" or info.model == "models/weapons/c_arms_refugee.mdl") then
		for k, v in pairs(blackModels) do
			if (string.find(model, k)) then
				info.skin = 1;

				break;
			elseif (info.skin == 1) then
				info.skin = 0;
			end;
		end;
	end;

	hook.Run("AdjustCModelHandsInfo", model, info);
end;

-- A function to get the c_model hands based on model.
function Clockwork.animation:GetHandsInfo(model)
	local animTable = self:GetTable(model);

	return self:CheckHands(string.lower(model), animTable);
end;

/*
Clockwork.animation:AddBlackModel("/male_01.mdl");
Clockwork.animation:AddBlackModel("/male_03.mdl");
Clockwork.animation:AddBlackModel("/female_03.mdl");
*/

Clockwork.animation:AddRefugeeHands("/group03/");
Clockwork.animation:AddRefugeeHands("/group03m/");

Clockwork.animation:AddZombieRefugeeHands("/Zombie/");

Clockwork.animation:AddWandererArms("models/begotten/wanderers/wanderer/");

Clockwork.animation:AddGatekeeperLightArms("models/begotten/gatekeepers/gatekeeperlight/");

Clockwork.animation:AddGatekeeperMediumArms("models/begotten/gatekeepers/gatekeepermedium/");

Clockwork.animation:AddGatekeeperFineArms("models/begotten/gatekeepers/gatekeeperfine/");

Clockwork.animation:AddLamellarArms("models/begotten/goreicwarfighters/gorelamellar/");

Clockwork.animation:AddGatekeeperOrnateArms("models/begotten/gatekeepers/gatekeeperornate/");
Clockwork.animation:AddGatekeeperOrnateArms("begotten/gatekeepers/vexi.mdl");

Clockwork.animation:AddMinisterArms("models/begotten/gatekeepers/minister/");

Clockwork.animation:AddGatekeeperHeavyArms("models/begotten/gatekeepers/highgatekeeper01.mdl");
Clockwork.animation:AddGatekeeperHeavyArms("models/begotten/gatekeepers/highgatekeeper02.mdl");
Clockwork.animation:AddGatekeeperHeavyArms("models/begotten/gatekeepers/masteratarms.mdl");
Clockwork.animation:AddGatekeeperHeavyArms("models/begotten/satanists/emperorvarazdat.mdl");

Clockwork.animation:AddInquisitorArms("models/begotten/gatekeepers/inquisitor/");

Clockwork.animation:AddBlackInquisitorArms("models/begotten/gatekeepers/blackinquisitor/");

Clockwork.animation:AddWhiteInquisitorArms("models/begotten/gatekeepers/grandinquisitor.mdl");
Clockwork.animation:AddWhiteInquisitorArms("models/begotten/gatekeepers/whiteinquisitor/");

Clockwork.animation:AddDistrictOneArmorArms("models/begotten/gatekeepers/districtonearmor.mdl");

Clockwork.animation:AddMagistrateArms("models/begotten/gatekeepers/magistratearmor.mdl");
Clockwork.animation:AddMagistrateArms("models/begotten/gatekeepers/adyssa.mdl");

Clockwork.animation:AddDreadArmorArms("models/begotten/satanists/dreadarmor.mdl");

Clockwork.animation:AddHellspikeArmorArms("models/begotten/satanists/hellspike_armor.mdl");

Clockwork.animation:AddSpiceGuardArms("models/begotten/satanists/darklanderspiceguard.mdl");

Clockwork.animation:AddWraithArmorArms("begotten/satanists/wraitharmor.mdl");

Clockwork.animation:AddVassoArms("models/begotten/satanists/lordvasso/");

Clockwork.animation:AddWarfighterArms("models/begotten/goreicwarfighters/warfighter/");

Clockwork.animation:AddGoreChainMail1Arms("models/begotten/goreicwarfighters/haralderchainmail/");

Clockwork.animation:AddGoreChainMail2Arms("models/begotten/goreicwarfighters/gorechainmail/");

Clockwork.animation:AddGoreHouseCarlArms("models/begotten/goreicwarfighters/gorehousecarl/");

Clockwork.animation:AddGoreBladeDruidArms("models/begotten/goreicwarfighters/bladedruid/");
Clockwork.animation:AddGoreBladeDruidArms("models/begotten/goreicwarfighters/elderdruid.mdl");

Clockwork.animation:AddGoreTribalArms("models/begotten/goreicwarfighters/goretribal/");
Clockwork.animation:AddGoreTribalArms("models/begotten/goreicwarfighters/goreseafarer/");
Clockwork.animation:AddGoreTribalArms("models/begotten/goreicwarfighters/goreberzerker/");

Clockwork.animation:AddGoreChieftanArms("models/begotten/goreicwarfighters/gorechieftan.mdl");

Clockwork.animation:AddGoreScaleArms("models/begotten/goreicwarfighters/gorescale/");

Clockwork.animation:AddBjornlingArms("models/begotten/goreicwarfighters/bjornling.mdl");
Clockwork.animation:AddBjornlingArms("models/begotten/goreicwarfighters/reaverplate/");

Clockwork.animation:AddVoltistArms("models/begotten/wanderers/voltist_heavy.mdl");
Clockwork.animation:AddVoltistArms("models/begotten/wanderers/voltist_medium.mdl");
Clockwork.animation:AddVoltistArms("models/begotten/wanderers/voltistpowerarmor.mdl");

Clockwork.animation:AddElegantRobesArms("models/begotten/satanists/elegantrobes/");

Clockwork.animation:AddHellplateHeavyArms("models/begotten/satanists/hellplateheavy/");
Clockwork.animation:AddHellplateHeavyArms("models/begotten/satanists/darklanderimmortal.mdl");

Clockwork.animation:AddHellplateMediumArms("models/begotten/satanists/hellplatemedium/");

Clockwork.animation:AddKnightArms("models/begotten/gatekeepers/knight_set.mdl");
Clockwork.animation:AddKnightArms("models/begotten/gatekeepers/grandknight.mdl");
Clockwork.animation:AddKnightArms("models/begotten/goreicwarfighters/goreking.mdl");

Clockwork.animation:AddExileKnightArms("models/begotten/wanderers/exileknight.mdl");

Clockwork.animation:AddScrapperArms("models/begotten/wanderers/scrapper/");
Clockwork.animation:AddScrapperArms("models/begotten/wanderers/scrappergrunt/");
Clockwork.animation:AddScrapperArms("models/begotten/wanderers/scrapperking.mdl");

Clockwork.animation:AddScribeArms("models/begotten/wanderers/scribe/");

Clockwork.animation:AddMerchantArms("models/begotten/wanderers/merchant/");

Clockwork.animation:AddBrigandineArms("models/begotten/wanderers/brigandine/");

Clockwork.animation:AddBrigandineLightArms("models/begotten/wanderers/brigandinelight/");
Clockwork.animation:AddBrigandineLightArms("models/begotten/gatekeepers/renegadeacolyte.mdl");
Clockwork.animation:AddBrigandineLightArms("models/begotten/gatekeepers/renegadedisciple.mdl");

Clockwork.animation:AddLeatherArms("models/begotten/wanderers/leather/");

Clockwork.animation:AddWandererMailArms("models/begotten/wanderers/wanderermail/");

Clockwork.animation:AddWandererOppressorArms("models/begotten/wanderers/wandereroppressor.mdl");

Clockwork.animation:AddPlagueDocArms("models/begotten/wanderers/plaguedoc.mdl");

Clockwork.animation:AddShingarArms("models/begotten/goreicwarfighters/shingar.mdl");

Clockwork.animation:AddKnightJusticarArms("models/begotten/gatekeepers/knight_justicar.mdl");

Clockwork.animation:AddTechnoHeavyArms("models/begotten/wanderers/voltist_technoheavy.mdl");

Clockwork.animation:AddVortigauntModel("models/vortigaunt.mdl");
Clockwork.animation:AddVortigauntModel("models/vortigaunt_slave.mdl");
Clockwork.animation:AddVortigauntModel("models/vortigaunt_doctor.mdl");

Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier_prisonguard.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_super_soldier.mdl");
Clockwork.animation:AddCombineOverwatchModel("models/combine_soldier.mdl");

Clockwork.animation:AddCivilProtectionModel("models/police.mdl");