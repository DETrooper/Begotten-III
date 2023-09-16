--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

game.AddParticles("particles/fire_01.pcf");
PrecacheParticleSystem("env_fire_large");

local map = string.lower(game.GetMap());

Schema.maxNPCS = 8;
Schema.towerTax = 0.1; -- 10% of all salesman sales go to the treasury.

if !Schema.towerSafeZoneEnabled then
	Schema.towerSafeZoneEnabled = true;
end

if !Schema.spawnedNPCS then
	Schema.spawnedNPCS = {};
end

Schema.zones = {
	["wasteland"] = true,
	["tower"] = true,
	["gore"] = true,
	["scrapper"] = true,
	["toothboy"] = true,
	["hell"] = true,
	["manor"] = true,
	["caves"] = true,
	["gore_tree"] = true,
	["gore_hallway"] = true,
};

Schema.RotModels = {
	[1] = "models/Humans/corpse1.mdl",
	[2] = "models/Humans/Charple01.mdl",
	[3] = "models/Humans/Charple02.mdl",
	[4] = "models/Humans/Charple04.mdl",
	[5] = "models/Humans/Charple03.mdl"
};

Schema.cwExplodePropDamages = {
	[DMG_BLAST] = true,
	[DMG_BULLET] = true,
	[DMG_BUCKSHOT] = true,
	[DMG_SLASH] = true,
};

Schema.cwExplodeProps = {
	["models/props_junk/gascan001a.mdl"] = true,
	
	["models/props_junk/propanecanister001a.mdl"] = {true, function(entity)
		entity:EmitSound("physics/destruction/explosivegasleak.wav", 500);
		
		timer.Simple(2, function()
			Schema:FireyExplosion(entity, attacker, true);
		end);
	end},
	
	["models/props_junk/propane_tank001a.mdl"] = {true, function(entity)
		entity:EmitSound("physics/destruction/explosivegasleak.wav", 500);
		
		timer.Simple(2, function()
			Schema:FireyExplosion(entity, attacker, true);
		end);
	end},
};

Schema.StorageSounds = {
	["controlroom"] = {
		["open"] = {"doors/door_screen_move1.wav"},
		["close"] = {"doors/door_metal_thin_open1.wav", "doors/door_metal_thin_close2.wav"},
	},
	["models/props_junk/trashdumpster01a.mdl"] = {
		["open"] = {"doors/door_screen_move1.wav"},
		["close"] = {"doors/door_metal_thin_open1.wav", "doors/door_metal_thin_close2.wav"},
		["openfunction"] = function(player, entity) end,
		["closefunction"] = function(player, entity) end,
	},
	["models/props_c17/furniturefridge001a.mdl"] = {
		["open"] = "doors/handle_pushbar_locked1.wav",
		["close"] = "doors/door1_stop.wav"
	},
	["models/props_c17/oildrum001.mdl"] = {
		["open"] = {"physics/metal/metal_barrel_impact_soft1.wav", "physics/metal/metal_barrel_impact_soft2.wav", "physics/metal/metal_barrel_impact_soft3.wav"},
		["close"] = {"physics/metal/metal_barrel_impact_hard1.wav", "physics/metal/metal_barrel_impact_hard2.wav", "physics/metal/metal_barrel_impact_hard3.wav", "physics/metal/metal_barrel_impact_hard7.wav"},
	},
	["models/props_c17/furnituredresser001a.mdl"]  = {
		["open"] = {"physics/wood/wood_box_impact_hard1.wav", "physics/wood/wood_box_impact_hard2.wav", "physics/wood/wood_box_impact_hard3.wav"},
		["close"] = {"physics/wood/wood_crate_break1.wav", "physics/wood/wood_crate_break2.wav", "physics/wood/wood_crate_break3.wav", "physics/wood/wood_crate_break4.wav"}
	},
	["wood_crate"] = {
		["open"] = {"physics/wood/wood_crate_break1.wav", "physics/wood/wood_crate_break2.wav", "physics/wood/wood_crate_break3.wav", "physics/wood/wood_crate_break4.wav"},
		["close"] = {"physics/wood/wood_box_impact_hard1.wav", "physics/wood/wood_box_impact_hard2.wav", "physics/wood/wood_box_impact_hard3.wav"}
	},
	["furniture"] = {
		["open"] = {"physics/wood/wood_box_impact_hard4.wav", "physics/wood/wood_box_impact_hard6.wav", "physics/wood/wood_box_impact_hard5.wav"},
		["close"] = {"physics/wood/wood_box_impact_hard4.wav", "physics/wood/wood_box_impact_hard6.wav", "physics/wood/wood_box_impact_hard5.wav"}
	},
	["supercrate"] = {
		["open"] = {"physics/metal/metal_box_strain4.wav"},
		["close"] = {"physics/metal/metal_box_impact_soft3.wav", "physics/metal/metal_box_impact_hard3.wav"},
	},
};

Schema.LockTypes = {
	["models/props_wasteland/controlroom_storagecloset001a.mdl"] = "metal_cabinet",
	["models/props_wasteland/controlroom_storagecloset001b.mdl"] = "metal_cabinet",
	["models/props_wasteland/controlroom_filecabinet001a.mdl"] = "small_metal_cabinet",
	["models/props_wasteland/controlroom_filecabinet002a.mdl"] = "metal_cabinet",
	["models/props_c17/suitcase_passenger_physics.mdl"] = "small_container",
	["models/props_junk/wood_crate001a_damagedmax.mdl"] = "box",
	["models/props_junk/wood_crate001a_damaged.mdl"] = "box",
	["models/props_interiors/furniture_desk01a.mdl"] = "furniture",
	["models/props_c17/furnituredresser001a.mdl"] = "furniture",
	["models/props_c17/furnituredrawer001a.mdl"] = "small_furniture",
	["models/props_c17/furnituredrawer002a.mdl"] = "small_furniture",
	["models/props_c17/furniturefridge001a.mdl"] = "small_metal_cabinet",
	["models/props_c17/furnituredrawer003a.mdl"] = "small_furniture",
	["models/weapons/w_suitcase_passenger.mdl"] = "small_container",
	["models/props_junk/trashdumpster01a.mdl"] = "trunk",
	["models/props_junk/wood_crate001a.mdl"] = "box",
	["models/props_junk/wood_crate002a.mdl"] = "box_large",
	["models/items/ammocrate_rockets.mdl"] = "trunk",
	["models/props_lab/filecabinet02.mdl"] = "small_metal_cabinet",
	["models/items/ammocrate_grenade.mdl"] = "trunk",
	["models/props_junk/trashbin01a.mdl"] = "small_container",
	["models/props_c17/suitcase001a.mdl"] = "small_container",
	["models/items/item_item_crate.mdl"] = "box",
	["models/props_c17/oildrum001.mdl"] = "barrel",
	["models/items/ammocrate_smg1.mdl"] = "trunk",
	["models/items/ammocrate_ar2.mdl"] = "trunk",
	["models/props/de_prodigy/ammo_can_01.mdl"] = "supercrate",
	["models/props/de_prodigy/ammo_can_02.mdl"] = "supercrate",
	["models/props/de_prodigy/ammo_can_03.mdl"] = "supercrate",
};

Schema.Tools = {
	["box"] = {{"axe", 2.5}, {"prybar", 3.5}, {"hatchet", 5}},
	["box_large"] = {{"axe", 3}, {"prybar", 4}, {"hatchet", 7}},
	["dumpster"] = {{"prybar", 4}},
	["barrel"] = {{"prybar", 3}},
	["furniture"] = {{"axe", 2}, {"prybar", 3}, {"hatchet", 4.5}},
	["small_furniture"] = {{"axe", 0.5}, {"hatchet", 2}, {"prybar", 3}},
	["trunk"] = {{"prybar", 8}},
	["metal_cabinet"] = {{"prybar", 6}},
	["small_metal_cabinet"] = {{"prybar", 4}},
	["small_container"] = {{"prybar", 2.5}, {"hunting_knife", 5}},
	["generic"] = {{"axe", 5}, {"hatchet", 5}, {"prybar", 5}, {"hunting_knife", 5}}
};

Schema.GibModels = {
	["crate"] = {"wood_reclaimed_", 5},
	["models/props_junk/wood_pallet001a.mdl"] = {"wood_reclaimed_", 5},
};

Schema.cheapleMessages = {
	"I can't fucking sleep... not when that thing is after me...",
	"N-no... it's too close... I've gotta go...",
	"If I don't keep moving I'm dead...",
	"There's no time for this... gotta keep moving...",
	"Come on... time to get up, before it catches me...",
	"Where is it!? Fuck, I've gotta keep moving...",
};

Schema.hellPortalTeleports = {};
Schema.npcSpawns = {};

if map == "rp_begotten3" then
	Schema.hellPortalTeleports = {
		["arch"] = {
			{pos = Vector(10106.985352, -14075.929688, -1203.471191), ang = Angle(0, 90, 0)},
			{pos = Vector(9988.100586, -14065.476563, -1201.754272), ang = Angle(0, 90, 0)},
			{pos = Vector(9840.530273, -14052.500000, -1195.489868), ang = Angle(0, 90, 0)},
			{pos = Vector(9690.040039, -14039.265625, -1199.206055), ang = Angle(0, 90, 0)},
			{pos = Vector(9564.098633, -14028.193359, -1199.958008), ang = Angle(0, 90, 0)},
			{pos = Vector(9411.407227, -14014.765625, -1204.968750), ang = Angle(0, 90, 0)},
			{pos = Vector(9216.617188, -13993.677734, -1203.199341), ang = Angle(0, 90, 0)},
		},
		["hell"] = {
			{pos = Vector(-8189.942871, -9051.384766, -7228.304688), ang = Angle(0, 0, 0)},
			{pos = Vector(-8188.711914, -9110.074219, -7227.193848), ang = Angle(0, 0, 0)},
			{pos = Vector(-8187.417480, -9171.792969, -7222.851074), ang = Angle(0, 0, 0)},
			{pos = Vector(-8186.472168, -9216.850586, -7220.369141), ang = Angle(0, 0, 0)},
		},
		["pillars"] = {
			{pos = Vector(-11110.820313, -3147.920654, -1676.352417), ang = Angle(0, 0, 0)},
			{pos = Vector(-11399.195313, -2988.402832, -1693.327148), ang = Angle(0, 0, 0)},
			{pos = Vector(-11466.902344, -2345.775635, -1685.092285), ang = Angle(0, 0, 0)},
			{pos = Vector(-11366.947266, -1473.669067, -1672.462036), ang = Angle(0, 0, 0)},
			{pos = Vector(-11618.375000, -604.629456, -1672.181030), ang = Angle(0, 0, 0)},
			{pos = Vector(-10641.942383, -666.103333, -1684.018555), ang = Angle(0, 0, 0)},
		},
	};

	Schema.npcSpawns = {
		["wasteland"] = {
			Vector(-10967.089844, -1220.767578, -1662.459106),
			Vector(-5509.368652, -3200.522949, -1669.600708),
			Vector(-1479.009888, -2197.274170, -1868.734497),
			Vector(-60.515240, -4684.832520, -1867.231201),
			Vector(-2441.085693, 1114.810425, -1804.695068),
			Vector(1207.390625, 421.858704, -1849.007324),
			Vector(1566.186035, -2591.648682, -1872.157715),
			Vector(7980.462402, -3335.651123, -1194),
			Vector(10192.621094, 1354.364258, -1204.581421),
			Vector(-7206.690430, 6050.651367, -1236),
			Vector(-11883.016602, 4312.245605, -1704.805054),
			Vector(-11372.455078, -8726.710938, -1263.614502),
			Vector(-5881.680176, -13524.884766, -1005.169006),
			Vector(5071.107910, -7160.854004, -927.867126),
			Vector(-2789.909912, 199.311493, -1878.907104),
			Vector(-2380.191895, -271.307190, -2606.263916),
			Vector(2785.046875, -484.878540, -2551.071289),
			Vector(2890.712158, 4798.735352, -2318.283203),
		},
		["gore"] = {
			Vector(-4635.546387, -6457.277832, 11577.454102),
			Vector(-6177.558594, -9151.410156, 11758.606445),
			Vector(-8018.354980, -10673.566406, 11657.213867),
			Vector(-7668.017578, -2788.391357, 11890.031250),
			Vector(-4762.075195, -3816.625732, 11990.207031),
			Vector(-2285.218994, -2696.021484, 11728.489258),
			Vector(23.739820, -4092.130615, 12048.193359),
			Vector(-3731.094482, -5929.901855, 11640.273438),
			Vector(-5768.370117, -10758.532227, 11612.263672),
			Vector(-6478.125000, -11312.333008, 11610.715820),
			Vector(-7766.898438, -12075.287109, 11612.863281),
		},
	};
elseif map == "rp_begotten_redux" then
	Schema.hellPortalTeleports = {
		["arch"] = {
			{pos = Vector(2848.578857, -8131.865723, 68.031250), ang = Angle(0, 180, 0)},
			{pos = Vector(2851.818848, -8034.101563, 68.031250), ang = Angle(0, 180, 0)},
			{pos = Vector(2857.660645, -7857.797852, 65.031242), ang = Angle(0, 180, 0)},
			{pos = Vector(2863.516602, -7681.075195, 65.031242), ang = Angle(0, 180, 0)},
			{pos = Vector(2859.004639, -8347.691406, 64.845985), ang = Angle(0, 180, 0)},
			{pos = Vector(2858.937500, -8484.280273, 64.910439), ang = Angle(0, 180, 0)},
			{pos = Vector(2855.492432, -8611.885742, 64.957924), ang = Angle(0, 180, 0)},
		},
		["hell"] = {
			{pos = Vector(-8189.942871, -9051.384766, -7228.304688), ang = Angle(0, 0, 0)},
			{pos = Vector(-8188.711914, -9110.074219, -7227.193848), ang = Angle(0, 0, 0)},
			{pos = Vector(-8187.417480, -9171.792969, -7222.851074), ang = Angle(0, 0, 0)},
			{pos = Vector(-8186.472168, -9216.850586, -7220.369141), ang = Angle(0, 0, 0)},
		},
		["pillars"] = {
			{pos = Vector(-6452.297363, 9054.192383, 735.883789), ang = Angle(0, -90, 0)},
			{pos = Vector(-6469.817871, 9720.629883, 739.778320), ang = Angle(0, -90, 0)},
			{pos = Vector(-5696.424805, 10054.203125, 828.917847), ang = Angle(0, -90, 0)},
			{pos = Vector(-4861.987793, 9926.257813, 845.016418), ang = Angle(0, -90, 0)},
			{pos = Vector(-5099.730957, 9140.251953, 784.462952), ang = Angle(0, -90, 0)},
			{pos = Vector(-5824.885742, 8773.998047, 750.561707), ang = Angle(0, -90, 0)},
		},
	};
elseif map == "rp_scraptown" then
	Schema.hellPortalTeleports = {
		["arch"] = {
			{pos = Vector(5601.377441, 10217.037109, 362.462128), ang = Angle(0, -90, 0)},
			{pos = Vector(5458.273926, 10224.010742, 380.723083), ang = Angle(0, -90, 0)},
			{pos = Vector(5089.302734, 10289.466797, 374.498108), ang = Angle(0, -90, 0)},
			{pos = Vector(4800.678711, 10220.552734, 364.852570), ang = Angle(0, -90, 0)},
			{pos = Vector(4523.676758, 10199.279297, 377.466492), ang = Angle(0, -90, 0)},
		},
		["hell"] = {
			{pos = Vector(-8189.942871, -9051.384766, -7228.304688), ang = Angle(0, 0, 0)},
			{pos = Vector(-8188.711914, -9110.074219, -7227.193848), ang = Angle(0, 0, 0)},
			{pos = Vector(-8187.417480, -9171.792969, -7222.851074), ang = Angle(0, 0, 0)},
			{pos = Vector(-8186.472168, -9216.850586, -7220.369141), ang = Angle(0, 0, 0)},
		},
		["pillars"] = {
			{pos = Vector(10591.803711, -9910.349609, 201.188080), ang = Angle(0, 90, 0)},
			{pos = Vector(10017.263672, -10401.229492, 244.087067), ang = Angle(0, 90, 0)},
			{pos = Vector(9276.095703, -9935.737305, 588.446533), ang = Angle(0, 90, 0)},
			{pos = Vector(9572.210938, -8873.043945, 588.662537), ang = Angle(0, 90, 0)},
			{pos = Vector(10513.347656, -8684.458008, 289.911560), ang = Angle(0, 90, 0)},
		},
	};
end

Schema.towerDoors = {
    "churchgate1",
    "churchgate2",
    "cubbyblastdoor",
    "frontblastdoor",
    "sidedoorblastdoor",
    "gatekeeperdoor",
    "gatekeeperdoor2",
    "armorydoor",
    "alchemy_lab_blastdoor",
    "alchemy_lab_blastdoorwindw1",
    "alchemy_lab_blastdoorwindw2",
    "sidedoorblastdoor2",
};

Schema.smithyDoors = {
    "alchemy_lab_blastdoor",
    "alchemy_lab_blastdoorwindw1",
    "alchemy_lab_blastdoorwindw2",
};

local models_to_precache = {
	--[["models/begotten/gatekeepers/districtonearmor.mdl",
	"models/begotten/gatekeepers/grandinquisitor.mdl",
	"models/begotten/gatekeepers/grandknight.mdl",
	"models/begotten/gatekeepers/highgatekeeper01.mdl",
	"models/begotten/gatekeepers/highgatekeeper02.mdl",
	"models/begotten/gatekeepers/knight_set.mdl",
	"models/begotten/gatekeepers/masteratarms.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_01.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_02.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_04.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_05.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_06.mdl",
	"models/begotten/gatekeepers/blackinquisitor/female_32.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_01.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_02.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_03.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_04.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_05.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_06.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_07.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_08.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_09.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_11.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_12.mdl",
	"models/begotten/gatekeepers/blackinquisitor/male_16.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_01.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_02.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_04.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_05.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_06.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/female_32.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_01.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_02.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_03.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_04.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_05.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_06.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_07.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_08.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_09.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_11.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_12.mdl",
	"models/begotten/gatekeepers/gatekeeperfine/male_16.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_01.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_02.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_04.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_05.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_06.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/female_32.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_01.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_02.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_03.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_04.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_05.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_06.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_07.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_08.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_09.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_11.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_12.mdl",
	"models/begotten/gatekeepers/gatekeeperlight/male_16.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_01.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_02.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_04.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_05.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_06.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/female_32.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_01.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_02.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_03.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_04.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_05.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_06.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_07.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_08.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_09.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_11.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_12.mdl",
	"models/begotten/gatekeepers/gatekeepermedium/male_16.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_01.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_02.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_04.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_05.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_06.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/female_32.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_01.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_02.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_03.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_04.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_05.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_06.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_07.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_08.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_09.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_11.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_12.mdl",
	"models/begotten/gatekeepers/gatekeeperornate/male_16.mdl",
	"models/begotten/gatekeepers/inquisitor/female_01.mdl",
	"models/begotten/gatekeepers/inquisitor/female_02.mdl",
	"models/begotten/gatekeepers/inquisitor/female_04.mdl",
	"models/begotten/gatekeepers/inquisitor/female_05.mdl",
	"models/begotten/gatekeepers/inquisitor/female_06.mdl",
	"models/begotten/gatekeepers/inquisitor/female_32.mdl",
	"models/begotten/gatekeepers/inquisitor/male_01.mdl",
	"models/begotten/gatekeepers/inquisitor/male_02.mdl",
	"models/begotten/gatekeepers/inquisitor/male_03.mdl",
	"models/begotten/gatekeepers/inquisitor/male_04.mdl",
	"models/begotten/gatekeepers/inquisitor/male_05.mdl",
	"models/begotten/gatekeepers/inquisitor/male_06.mdl",
	"models/begotten/gatekeepers/inquisitor/male_07.mdl",
	"models/begotten/gatekeepers/inquisitor/male_08.mdl",
	"models/begotten/gatekeepers/inquisitor/male_09.mdl",
	"models/begotten/gatekeepers/inquisitor/male_11.mdl",
	"models/begotten/gatekeepers/inquisitor/male_12.mdl",
	"models/begotten/gatekeepers/inquisitor/male_16.mdl",
	"models/begotten/gatekeepers/minister/female_01.mdl",
	"models/begotten/gatekeepers/minister/female_02.mdl",
	"models/begotten/gatekeepers/minister/female_04.mdl",
	"models/begotten/gatekeepers/minister/female_05.mdl",
	"models/begotten/gatekeepers/minister/female_06.mdl",
	"models/begotten/gatekeepers/minister/female_32.mdl",
	"models/begotten/gatekeepers/minister/male_01.mdl",
	"models/begotten/gatekeepers/minister/male_02.mdl",
	"models/begotten/gatekeepers/minister/male_03.mdl",
	"models/begotten/gatekeepers/minister/male_04.mdl",
	"models/begotten/gatekeepers/minister/male_05.mdl",
	"models/begotten/gatekeepers/minister/male_06.mdl",
	"models/begotten/gatekeepers/minister/male_07.mdl",
	"models/begotten/gatekeepers/minister/male_08.mdl",
	"models/begotten/gatekeepers/minister/male_09.mdl",
	"models/begotten/gatekeepers/minister/male_11.mdl",
	"models/begotten/gatekeepers/minister/male_12.mdl",
	"models/begotten/gatekeepers/minister/male_16.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_01.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_02.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_04.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_05.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_06.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/female_32.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_01.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_02.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_03.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_04.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_05.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_06.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_07.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_08.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_09.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_11.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_12.mdl",
	"models/begotten/gatekeepers/whiteinquisitor/male_16.mdl",
	"models/begotten/goreicwarfighters/gorechieftan.mdl",
	"models/begotten/goreicwarfighters/goreking.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_90.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_91.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_92.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_93.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_94.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_95.mdl",
	"models/begotten/goreicwarfighters/bladedruid/male_96.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_90.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_91.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_92.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_93.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_94.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_95.mdl",
	"models/begotten/goreicwarfighters/goreberzerker/male_96.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_90.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_91.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_92.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_93.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_94.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_95.mdl",
	"models/begotten/goreicwarfighters/gorechainmail/male_96.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_90.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_91.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_92.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_93.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_94.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_95.mdl",
	"models/begotten/goreicwarfighters/gorehousecarl/male_96.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_90.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_91.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_92.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_93.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_94.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_95.mdl",
	"models/begotten/goreicwarfighters/goreseafarer/male_96.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_90.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_91.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_92.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_93.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_94.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_95.mdl",
	"models/begotten/goreicwarfighters/goretribal/male_96.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_90.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_91.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_92.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_93.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_94.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_95.mdl",
	"models/begotten/goreicwarfighters/haralderchainmail/male_96.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_90.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_91.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_92.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_93.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_94.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_95.mdl",
	"models/begotten/goreicwarfighters/reaverplate/male_96.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_90.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_91.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_92.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_93.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_94.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_95.mdl",
	"models/begotten/goreicwarfighters/warfighter/male_96.mdl",
	"models/begotten/satanists/dreadarmor.mdl",
	"models/begotten/satanists/hellspike_armor.mdl",
	"models/begotten/satanists/wraitharmor.mdl",
	"models/begotten/satanists/elegantrobes/female_01.mdl",
	"models/begotten/satanists/elegantrobes/female_02.mdl",
	"models/begotten/satanists/elegantrobes/female_04.mdl",
	"models/begotten/satanists/elegantrobes/female_05.mdl",
	"models/begotten/satanists/elegantrobes/female_06.mdl",
	"models/begotten/satanists/elegantrobes/female_32.mdl",
	"models/begotten/satanists/elegantrobes/male_01.mdl",
	"models/begotten/satanists/elegantrobes/male_02.mdl",
	"models/begotten/satanists/elegantrobes/male_03.mdl",
	"models/begotten/satanists/elegantrobes/male_04.mdl",
	"models/begotten/satanists/elegantrobes/male_05.mdl",
	"models/begotten/satanists/elegantrobes/male_06.mdl",
	"models/begotten/satanists/elegantrobes/male_07.mdl",
	"models/begotten/satanists/elegantrobes/male_08.mdl",
	"models/begotten/satanists/elegantrobes/male_09.mdl",
	"models/begotten/satanists/elegantrobes/male_11.mdl",
	"models/begotten/satanists/elegantrobes/male_12.mdl",
	"models/begotten/satanists/elegantrobes/male_13.mdl",
	"models/begotten/satanists/elegantrobes/male_16.mdl",
	"models/begotten/satanists/elegantrobes/male_22.mdl",
	"models/begotten/satanists/elegantrobes/male_56.mdl",
	"models/begotten/satanists/hellplateheavy/female_01.mdl",
	"models/begotten/satanists/hellplateheavy/female_02.mdl",
	"models/begotten/satanists/hellplateheavy/female_04.mdl",
	"models/begotten/satanists/hellplateheavy/female_05.mdl",
	"models/begotten/satanists/hellplateheavy/female_06.mdl",
	"models/begotten/satanists/hellplateheavy/female_32.mdl",
	"models/begotten/satanists/hellplateheavy/male_01.mdl",
	"models/begotten/satanists/hellplateheavy/male_02.mdl",
	"models/begotten/satanists/hellplateheavy/male_03.mdl",
	"models/begotten/satanists/hellplateheavy/male_04.mdl",
	"models/begotten/satanists/hellplateheavy/male_05.mdl",
	"models/begotten/satanists/hellplateheavy/male_06.mdl",
	"models/begotten/satanists/hellplateheavy/male_07.mdl",
	"models/begotten/satanists/hellplateheavy/male_08.mdl",
	"models/begotten/satanists/hellplateheavy/male_09.mdl",
	"models/begotten/satanists/hellplateheavy/male_11.mdl",
	"models/begotten/satanists/hellplateheavy/male_12.mdl",
	"models/begotten/satanists/hellplateheavy/male_13.mdl",
	"models/begotten/satanists/hellplateheavy/male_16.mdl",
	"models/begotten/satanists/hellplateheavy/male_22.mdl",
	"models/begotten/satanists/hellplateheavy/male_56.mdl",
	"models/begotten/satanists/hellplatemedium/female_01.mdl",
	"models/begotten/satanists/hellplatemedium/female_02.mdl",
	"models/begotten/satanists/hellplatemedium/female_04.mdl",
	"models/begotten/satanists/hellplatemedium/female_05.mdl",
	"models/begotten/satanists/hellplatemedium/female_06.mdl",
	"models/begotten/satanists/hellplatemedium/female_32.mdl",
	"models/begotten/satanists/hellplatemedium/male_01.mdl",
	"models/begotten/satanists/hellplatemedium/male_02.mdl",
	"models/begotten/satanists/hellplatemedium/male_03.mdl",
	"models/begotten/satanists/hellplatemedium/male_04.mdl",
	"models/begotten/satanists/hellplatemedium/male_05.mdl",
	"models/begotten/satanists/hellplatemedium/male_06.mdl",
	"models/begotten/satanists/hellplatemedium/male_07.mdl",
	"models/begotten/satanists/hellplatemedium/male_08.mdl",
	"models/begotten/satanists/hellplatemedium/male_09.mdl",
	"models/begotten/satanists/hellplatemedium/male_11.mdl",
	"models/begotten/satanists/hellplatemedium/male_12.mdl",
	"models/begotten/satanists/hellplatemedium/male_13.mdl",
	"models/begotten/satanists/hellplatemedium/male_16.mdl",
	"models/begotten/satanists/hellplatemedium/male_22.mdl",
	"models/begotten/satanists/hellplatemedium/male_56.mdl",
	"models/begotten/wanderers/exileknight.mdl",
	"models/begotten/wanderers/plaguedoc.mdl",
	"models/begotten/wanderers/voltist_heavy.mdl",
	"models/begotten/wanderers/voltist_medium.mdl",
	"models/begotten/wanderers/brigandine/female_01.mdl",
	"models/begotten/wanderers/brigandine/female_02.mdl",
	"models/begotten/wanderers/brigandine/female_04.mdl",
	"models/begotten/wanderers/brigandine/female_05.mdl",
	"models/begotten/wanderers/brigandine/female_06.mdl",
	"models/begotten/wanderers/brigandine/female_32.mdl",
	"models/begotten/wanderers/brigandine/male_01.mdl",
	"models/begotten/wanderers/brigandine/male_02.mdl",
	"models/begotten/wanderers/brigandine/male_03.mdl",
	"models/begotten/wanderers/brigandine/male_04.mdl",
	"models/begotten/wanderers/brigandine/male_05.mdl",
	"models/begotten/wanderers/brigandine/male_06.mdl",
	"models/begotten/wanderers/brigandine/male_07.mdl",
	"models/begotten/wanderers/brigandine/male_08.mdl",
	"models/begotten/wanderers/brigandine/male_09.mdl",
	"models/begotten/wanderers/brigandine/male_11.mdl",
	"models/begotten/wanderers/brigandine/male_12.mdl",
	"models/begotten/wanderers/brigandine/male_13.mdl",
	"models/begotten/wanderers/brigandine/male_16.mdl",
	"models/begotten/wanderers/brigandine/male_22.mdl",
	"models/begotten/wanderers/brigandine/male_56.mdl",
	"models/begotten/wanderers/brigandinelight/female_01.mdl",
	"models/begotten/wanderers/brigandinelight/female_02.mdl",
	"models/begotten/wanderers/brigandinelight/female_04.mdl",
	"models/begotten/wanderers/brigandinelight/female_05.mdl",
	"models/begotten/wanderers/brigandinelight/female_06.mdl",
	"models/begotten/wanderers/brigandinelight/female_32.mdl",
	"models/begotten/wanderers/brigandinelight/male_01.mdl",
	"models/begotten/wanderers/brigandinelight/male_02.mdl",
	"models/begotten/wanderers/brigandinelight/male_03.mdl",
	"models/begotten/wanderers/brigandinelight/male_04.mdl",
	"models/begotten/wanderers/brigandinelight/male_05.mdl",
	"models/begotten/wanderers/brigandinelight/male_06.mdl",
	"models/begotten/wanderers/brigandinelight/male_07.mdl",
	"models/begotten/wanderers/brigandinelight/male_08.mdl",
	"models/begotten/wanderers/brigandinelight/male_09.mdl",
	"models/begotten/wanderers/brigandinelight/male_11.mdl",
	"models/begotten/wanderers/brigandinelight/male_12.mdl",
	"models/begotten/wanderers/brigandinelight/male_13.mdl",
	"models/begotten/wanderers/brigandinelight/male_16.mdl",
	"models/begotten/wanderers/brigandinelight/male_22.mdl",
	"models/begotten/wanderers/brigandinelight/male_56.mdl",
	"models/begotten/wanderers/leather/female_01.mdl",
	"models/begotten/wanderers/leather/female_02.mdl",
	"models/begotten/wanderers/leather/female_04.mdl",
	"models/begotten/wanderers/leather/female_05.mdl",
	"models/begotten/wanderers/leather/female_06.mdl",
	"models/begotten/wanderers/leather/female_32.mdl",
	"models/begotten/wanderers/leather/male_01.mdl",
	"models/begotten/wanderers/leather/male_02.mdl",
	"models/begotten/wanderers/leather/male_03.mdl",
	"models/begotten/wanderers/leather/male_04.mdl",
	"models/begotten/wanderers/leather/male_05.mdl",
	"models/begotten/wanderers/leather/male_06.mdl",
	"models/begotten/wanderers/leather/male_07.mdl",
	"models/begotten/wanderers/leather/male_08.mdl",
	"models/begotten/wanderers/leather/male_09.mdl",
	"models/begotten/wanderers/leather/male_11.mdl",
	"models/begotten/wanderers/leather/male_12.mdl",
	"models/begotten/wanderers/leather/male_13.mdl",
	"models/begotten/wanderers/leather/male_16.mdl",
	"models/begotten/wanderers/leather/male_22.mdl",
	"models/begotten/wanderers/leather/male_56.mdl",
	"models/begotten/wanderers/merchant/female_01.mdl",
	"models/begotten/wanderers/merchant/female_02.mdl",
	"models/begotten/wanderers/merchant/female_04.mdl",
	"models/begotten/wanderers/merchant/female_05.mdl",
	"models/begotten/wanderers/merchant/female_06.mdl",
	"models/begotten/wanderers/merchant/female_32.mdl",
	"models/begotten/wanderers/merchant/male_01.mdl",
	"models/begotten/wanderers/merchant/male_02.mdl",
	"models/begotten/wanderers/merchant/male_03.mdl",
	"models/begotten/wanderers/merchant/male_04.mdl",
	"models/begotten/wanderers/merchant/male_05.mdl",
	"models/begotten/wanderers/merchant/male_06.mdl",
	"models/begotten/wanderers/merchant/male_07.mdl",
	"models/begotten/wanderers/merchant/male_08.mdl",
	"models/begotten/wanderers/merchant/male_09.mdl",
	"models/begotten/wanderers/merchant/male_11.mdl",
	"models/begotten/wanderers/merchant/male_12.mdl",
	"models/begotten/wanderers/merchant/male_13.mdl",
	"models/begotten/wanderers/merchant/male_16.mdl",
	"models/begotten/wanderers/merchant/male_22.mdl",
	"models/begotten/wanderers/merchant/male_56.mdl",
	"models/begotten/wanderers/scrapper/female_01.mdl",
	"models/begotten/wanderers/scrapper/female_02.mdl",
	"models/begotten/wanderers/scrapper/female_04.mdl",
	"models/begotten/wanderers/scrapper/female_05.mdl",
	"models/begotten/wanderers/scrapper/female_06.mdl",
	"models/begotten/wanderers/scrapper/female_32.mdl",
	"models/begotten/wanderers/scrapper/male_01.mdl",
	"models/begotten/wanderers/scrapper/male_02.mdl",
	"models/begotten/wanderers/scrapper/male_03.mdl",
	"models/begotten/wanderers/scrapper/male_04.mdl",
	"models/begotten/wanderers/scrapper/male_05.mdl",
	"models/begotten/wanderers/scrapper/male_06.mdl",
	"models/begotten/wanderers/scrapper/male_07.mdl",
	"models/begotten/wanderers/scrapper/male_08.mdl",
	"models/begotten/wanderers/scrapper/male_09.mdl",
	"models/begotten/wanderers/scrapper/male_11.mdl",
	"models/begotten/wanderers/scrapper/male_12.mdl",
	"models/begotten/wanderers/scrapper/male_13.mdl",
	"models/begotten/wanderers/scrapper/male_16.mdl",
	"models/begotten/wanderers/scrapper/male_22.mdl",
	"models/begotten/wanderers/scrapper/male_56.mdl",
	"models/begotten/wanderers/scrappergrunt/female_01.mdl",
	"models/begotten/wanderers/scrappergrunt/female_02.mdl",
	"models/begotten/wanderers/scrappergrunt/female_04.mdl",
	"models/begotten/wanderers/scrappergrunt/female_05.mdl",
	"models/begotten/wanderers/scrappergrunt/female_06.mdl",
	"models/begotten/wanderers/scrappergrunt/female_32.mdl",
	"models/begotten/wanderers/scrappergrunt/male_01.mdl",
	"models/begotten/wanderers/scrappergrunt/male_02.mdl",
	"models/begotten/wanderers/scrappergrunt/male_03.mdl",
	"models/begotten/wanderers/scrappergrunt/male_04.mdl",
	"models/begotten/wanderers/scrappergrunt/male_05.mdl",
	"models/begotten/wanderers/scrappergrunt/male_06.mdl",
	"models/begotten/wanderers/scrappergrunt/male_07.mdl",
	"models/begotten/wanderers/scrappergrunt/male_08.mdl",
	"models/begotten/wanderers/scrappergrunt/male_09.mdl",
	"models/begotten/wanderers/scrappergrunt/male_11.mdl",
	"models/begotten/wanderers/scrappergrunt/male_12.mdl",
	"models/begotten/wanderers/scrappergrunt/male_13.mdl",
	"models/begotten/wanderers/scrappergrunt/male_16.mdl",
	"models/begotten/wanderers/scrappergrunt/male_22.mdl",
	"models/begotten/wanderers/scrappergrunt/male_56.mdl",
	"models/begotten/wanderers/scribe/female_01.mdl",
	"models/begotten/wanderers/scribe/female_02.mdl",
	"models/begotten/wanderers/scribe/female_04.mdl",
	"models/begotten/wanderers/scribe/female_05.mdl",
	"models/begotten/wanderers/scribe/female_06.mdl",
	"models/begotten/wanderers/scribe/female_32.mdl",
	"models/begotten/wanderers/scribe/male_01.mdl",
	"models/begotten/wanderers/scribe/male_02.mdl",
	"models/begotten/wanderers/scribe/male_03.mdl",
	"models/begotten/wanderers/scribe/male_04.mdl",
	"models/begotten/wanderers/scribe/male_05.mdl",
	"models/begotten/wanderers/scribe/male_06.mdl",
	"models/begotten/wanderers/scribe/male_07.mdl",
	"models/begotten/wanderers/scribe/male_08.mdl",
	"models/begotten/wanderers/scribe/male_09.mdl",
	"models/begotten/wanderers/scribe/male_11.mdl",
	"models/begotten/wanderers/scribe/male_12.mdl",
	"models/begotten/wanderers/scribe/male_13.mdl",
	"models/begotten/wanderers/scribe/male_16.mdl",
	"models/begotten/wanderers/scribe/male_22.mdl",
	"models/begotten/wanderers/scribe/male_56.mdl",]]--
	"models/begotten/wanderers/wanderer/female_01.mdl",
	"models/begotten/wanderers/wanderer/female_02.mdl",
	"models/begotten/wanderers/wanderer/female_04.mdl",
	"models/begotten/wanderers/wanderer/female_05.mdl",
	"models/begotten/wanderers/wanderer/female_06.mdl",
	"models/begotten/wanderers/wanderer/female_32.mdl",
	"models/begotten/wanderers/wanderer/male_01.mdl",
	"models/begotten/wanderers/wanderer/male_02.mdl",
	"models/begotten/wanderers/wanderer/male_03.mdl",
	"models/begotten/wanderers/wanderer/male_04.mdl",
	"models/begotten/wanderers/wanderer/male_05.mdl",
	"models/begotten/wanderers/wanderer/male_06.mdl",
	"models/begotten/wanderers/wanderer/male_07.mdl",
	"models/begotten/wanderers/wanderer/male_08.mdl",
	"models/begotten/wanderers/wanderer/male_09.mdl",
	"models/begotten/wanderers/wanderer/male_11.mdl",
	"models/begotten/wanderers/wanderer/male_12.mdl",
	"models/begotten/wanderers/wanderer/male_13.mdl",
	"models/begotten/wanderers/wanderer/male_16.mdl",
	"models/begotten/wanderers/wanderer/male_22.mdl",
	"models/begotten/wanderers/wanderer/male_56.mdl",
};

--[[for i = 1, #models_to_precache do
	util.PrecacheModel(models_to_precache[i]);
end]]--

Clockwork.config:Add("gore_charlimit", 1, true);
Clockwork.config:Add("satanist_charlimit", 1, true);
Clockwork.config:Add("enable_charlimit", true, true);

Clockwork.config:Add("intro_text_small", "fuck you", true);
Clockwork.config:Add("intro_text_big", "fuck you", true);
Clockwork.config:Get("enable_gravgun_punt"):Set(false);
Clockwork.config:Get("default_inv_weight"):Set(20);
Clockwork.config:Get("enable_crosshair"):Set(false);
Clockwork.config:Get("disable_sprays"):Set(true);
Clockwork.config:Get("prop_cost_scale"):Set(0);
Clockwork.config:Get("door_cost"):Set(0);
Clockwork.config:Get("stamina_drain_scale"):Set(0.15);

Schema.fogDistance = {}
table.CopyFromTo(Schema.zones, Schema.fogDistance);

for k, v in pairs (Schema.fogDistance) do
	Schema.fogDistance[k] = false;
end;

Schema.TurretTypes = {
	[1] = {
		name = "M249",
		mdl = "models/weapons/w_mach_m249para.mdl", 
		muzzlePos = Vector(33.5719, -0.0056, 5.5),
		offsetPos = Vector(14.5, 0, -1.5),
		offsetAng = Angle(-2.164, 0.130, 0),
		delay = 0.08,
		auto = 1,
		recoil = 0.01,
		damage = 2.5,
		num = 1,
		cone = 0.07
	},
};

-- A function to spawn a mountable turret.
function Schema:MakeMountableTurret(player, position, angles, turretData)
	local turret = ents.Create("cw_mounted_mountable")
	
	if (!IsValid(turret)) then
		return false;
	end;
	
	turret:SetPos(position);
	turret:SetAngles(angles);
	turret:Spawn();
	
	if (turretData) then
		table.Merge(turret, turretData);
	end;
	
	turret.player = player;
	turret:ForceInit();
	
	undo.Create("turret");
	undo.SetPlayer(player);
	undo.AddEntity(turret);
	undo.Finish();
	
	return turret;
end;

-- A function to spawn a turret.
function Schema:SpawnTurret(player, turretType)
	if (!IsValid(player) or !player:IsAdmin()) then
		return;
	end;
	
	local turretType = turretType or 1;
	local turretInfo = self.TurretTypes[tonumber(turretType)];
	local turretData = {
		Model = turretInfo.mdl,
		TurnSpeed = 5,
		ShootSound = turretInfo.sound or "Weapon_M249.Single",
		Delay = turretInfo.delay or 0.05,
		Automatic = turretInfo.auto,
		Recoil = turretInfo.recoil,
		MuzzleEffect = "turret_mzl_mg",
		MuzzlePos = turretInfo.muzzlePos,
		OffsetPos = turretInfo.offsetPos,
		OffsetAngle = turretInfo.offsetAng,
		Bullet = {
			Num = turretInfo.num,
			Spread = Vector(turretInfo.cone, turretInfo.cone, 0),
			Tracer = 1,
			TracerName = turretInfo.tracer or "Tracer",
			Force = 100000,
			Damage = turretInfo.damage or 11,
			Attacker = player,
			Callback = nil
		}
	};

	local hitPos = player:GetEyeTrace().HitPos
	local angles = player:GetAngles();
	local hitPos = Vector(hitPos.x, hitPos.y, hitPos.z);
	local turret = self:MakeMountableTurret(player, hitPos, angles, turretData);
	
	turret.Mount.Prop:Fire("disablemotion");
end;

concommand.Add("spawnturret", function(player, cmd, args)
	if (ads and ads[player:SteamID()]) then
		Schema:SpawnTurret(player);
	end;
end);

-- A function to override the default fog distance of a zone.
function Schema:OverrideFogDistance(zone, distance)
	if (zone and isstring(zone) and self.zones[zone]) then
		if (distance == false) then
			self.fogDistance[zone] = false;
		else
			self.fogDistance[zone] = distance;
		end;
		
		Clockwork.datastream:Start(_player.GetAll(), "OverrideFogDistance", {zone = zone, fogEnd = self.fogDistance[zone]});
	end;
end;

-- A function to sync the current custom fog distance with a player.
function Schema:SyncFogDistance(player, uniqueID)
	if (self.fogDistance[uniqueID]) then
		Clockwork.datastream:Start(player, "OverrideFogDistance", {zone = uniqueID, fogEnd = self.fogDistance[uniqueID]});
	end;
end;

-- A function to strip the rank of a player's name.
function Schema:StripRank(name, rank)
	if (name and rank and isstring(name) and isstring(rank)) then
		return string.gsub(name, rank, "");
	end;
end;

-- A function to print chatbox text without using RGB color.
function Schema:EasyText(listeners, ...)
	local varargs = {...};

	if listeners and (istable(listeners) or listeners:IsPlayer()) then
		Clockwork.datastream:Start(listeners, "EasyText", varargs)
	end;
end;

-- A function to get all the online admins.
function Schema:GetAdmins()
	local admins = {};
	
	local playerCount = _player.GetCount();
	local players = _player.GetAll();

	for i = 1, playerCount do
		local v, k = players[i], i;
		if (v:IsAdmin() or v:IsUserGroup("operator")) then
			admins[#admins + 1] = v;
		end;
	end;
	
	return admins;
end;

-- A function to get an entity's lock type.
function Schema:GetLockType(entity)
	local lockType = nil;
	local toolTable = {};
	local model = entity:GetModel();

	if (self.LockTypes[model]) then
		lockType = self.LockTypes[model];
		toolTable = self.Tools[lockType];
	else
		lockType = "generic";
		toolTable = self.Tools[lockType];
	end;

	if (lockType and toolTable) then
		return lockType, toolTable;
	end;
end;

-- A function to get an entity's required tool type.
function Schema:GetRequiredTool(entity)
	local lockType, toolTable = self:GetLockType(entity);
	
	if (lockType and toolTable and #toolTable > 0) then
		return toolTable;
	end;
end;

-- A function to make a player break a prop down.
function Schema:BreakObject(player, entity, bDidBreak)
	if (!bDidBreak) then
		self:Slow(player, 0)
		
		local toolTable = self:GetRequiredTool(entity);
		local hasTool = nil;
		local delay = nil;
		
		for k, v in pairs (toolTable) do
			local requiredTool = v[1];
			local toolDelay = v[2];
			
			if (player:HasItemByID(requiredTool)) then
				hasTool = requiredTool;
				delay = toolDelay;
				
				break;
			end;
		end;
		
		if (hasTool and delay) then
			local physObj = entity:GetPhysicsObject();
			local model = entity:GetModel();
			local motionEnabled = true;

			if (IsValid(physObj)) then
				motionEnabled = physObj:IsMotionEnabled();
				physObj:EnableMotion(false);
			end;
			
			timer.Create(entity:EntIndex().."_BreakSounds", math.Rand(0.25, (delay / 2)), math.Round(delay / 1), function()
				if (IsValid(entity) and IsValid(player)) then
					self:OpenSound(entity, player);
				else
					timer.Destroy(entity:EntIndex().."_BreakSounds");
				end;
			end);
		
			Clockwork.player:SetAction(player, "breakcontainer", delay, nil, function()
				if (IsValid(entity) and IsValid(player)) then
					self:BreakObject(player, entity, true);
					self:Slow(player)
					
					if (IsValid(physObj)) then
						physObj:EnableMotion(motionEnabled);
					end;
				end;
			end);
		end;
	else
		local gibs = nil;
		
		for k, v in pairs (self.GibModels) do
			local model = entity:GetModel();

			if (k == model or string.find(model, k)) then
				gibs = self.GibModels[k];
				break;
			end;
		end;
		
		local position = entity:GetPos();
		
		if (gibs) then
			local uniqueID = gibs[1];
			local count = gibs[2];
			
			local function CreateGibItem(uniqueID, index)
				local gib = Clockwork.item:FindByID(uniqueID..index);
				local itemTable = Clockwork.item:CreateInstance(gib("uniqueID"));
				local randomVector = VectorRand();
				local randomPosition = position + randomVector * 50;
				local center = entity:OBBCenter();
				randomPosition.z = (position.z + center.z + 8);
				local itemEntity = Clockwork.entity:CreateItem(player, itemTable, randomPosition);
				
				return itemEntity
			end;
			
			for i = 1, count do
				CreateGibItem(uniqueID, i);
			end;
			
			self:RespawnProp(entity);
			self:OpenSound(entity, player);
			entity:Remove();
		end;
	end;
end;

-- A function to play the opening sound for a container.
function Schema:OpenSound(entity, player)
	local model = entity:GetModel();
	local soundTable = nil;
	
	if entity:IsPlayer() then
		entity:EmitSound("physics/cardboard/cardboard_box_break1.wav");
		return;
	end
	
	for k, v in pairs (self.StorageSounds) do
		if (k == model or string.find(model, k)) then
			soundTable = self.StorageSounds[k];
			
			break;
		end;
	end;

	if (!soundTable) then
		soundTable = self.StorageSounds["wood_crate"];
	end;
	
	if (soundTable["open"]) then
		local openSound = soundTable["open"];
		
		if (soundTable["openfunction"]) then
			soundTable["openfunction"](player, entity)
		end;

		if (type(openSound) == "table") then
			openSound = table.Random(soundTable["open"]);
		end;
		
		entity:EmitSound(openSound, 70, math.random(80, 120));
	end;
end;

-- A function to play the closing sound for a container.
function Schema:CloseSound(entity, player)
	if entity:GetClass() == "prop_ragdoll" then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		return;
	elseif entity:IsPlayer() and player:GetMoveType() == MOVETYPE_WALK then
		entity:EmitSound("physics/body/body_medium_impact_soft4.wav");
		return;
	elseif entity:GetClass() == "cw_belongings" then
		entity:EmitSound("physics/cardboard/cardboard_box_impact_hard6.wav");
		return;
	end
	
	local model = entity:GetModel();
	local soundTable = nil;
	
	for k, v in pairs (self.StorageSounds) do
		if (k == model or string.find(model, k)) then
			soundTable = self.StorageSounds[k];
			
			break;
		end;
	end;

	if (!soundTable) then
		soundTable = self.StorageSounds["wood_crate"];
	end;
	
	if (soundTable["close"]) then
		local closeSound = soundTable["close"];
		
		if (soundTable["closefunction"]) then
			soundTable["closefunction"](player, entity)
		end;

		if (type(closeSound) == "table") then
			closeSound = table.Random(soundTable["close"]);
		end;
		
		entity:EmitSound(closeSound, 70, math.random(80, 120));
	end;
end;

-- A function to make a prop go up in a firey explosion.
function Schema:FireyExplosion(entity, attacker, bExplode)
	local position = entity:GetPos();
	local angles = entity:GetAngles();
	local physObj = entity:GetPhysicsObject();
	
	if (IsValid(physObj)) then
		physObj:SetMass(7);
	end;
	
	entity:EmitSound("ambient/fire/gascan_ignite1.wav", 500);
	
	local effectData = EffectData();
		effectData:SetOrigin(position);
		effectData:SetEntity(entity);
	util.Effect("HelicopterMegaBomb", effectData);
	
	if (!IsValid(entity.fireTrail)) then
		entity.fireTrail = ents.Create("env_fire_trail");
		entity.fireTrail:SetAngles(angles);
		entity.fireTrail:SetPos(position);
		entity.fireTrail:SetParent(entity);
		entity.fireTrail:Spawn();
		entity.fireTrail:Activate();
		
		timer.Simple(20, function()
			if (IsValid(entity) and IsValid(entity.fireTrail)) then
				entity.fireTrail:Remove();
			end;
		end);
	end;
	
	local trace = {};
		trace.start = position;
		trace.endpos = position + Vector(0, 0, -50);
		trace.filter = {entity};
	local traceLine = util.TraceLine(trace);
	
	if (IsValid(attacker)) then
		self:StartFires(traceLine.HitPos, 10, 20, false, attacker);
	else
		self:StartFires(traceLine.HitPos, 10, 20, false, nil);
	end;
	
	if (bExplode) then
		entity:EmitSound("ambient/explosions/explode_4.wav", 500);
		entity:EmitSound("ambient/explosions/explode_2.wav", 500);
	end;
end;

-- A function to start a group of fires at a specified position.
function Schema:StartFires(position, count, lifeTime, explode, damageOwner)
	StartFires(position, count, lifeTime, explode, damageOwner);
end;

-- A function to ignite an entity for a specified amount of time.
function Schema:Ignite(entity, seconds, player, sound)
	if (!IsValid(entity) or !seconds) then
		return;
	end;
	
	if (entity.OnFire) then
		return;
	end;
	
	local curTime = CurTime();
	local sound = sound or true;
	local player = player or nil;
	local seconds = tonumber(seconds);
	local position = entity:GetPos();
	local boundingRadius = entity:BoundingRadius();
	local size = (boundingRadius * math.Rand(3, 3.5));
	
	entity.FireChild = SpawnFire(position, size, 0, 999, player, entity);
	entity.OnFire = true;
	
	if (sound) then
		entity.FireSound = CreateSound(entity, "ambient/fire/firebig.wav");
		entity.FireSound:Play();
	end;

	timer.Simple(seconds, function()
		if (IsValid(entity.FireChild)) then
			local entIndex = entity:EntIndex();
			
			entity.FireChild:Remove();
			entity.OnFire = false;
			
			if (timer.Exists(entIndex.."_SpreadCheck")) then
				timer.Destroy(entIndex.."_SpreadCheck");
			end;
			
			if (sound and entity.FireSound) then
				entity.FireSound:Stop();
				entity.FireSound = nil;
			end;
		end;
	end);
end;

-- A function to get if an entity is on fire or not.
function Schema:IsOnFire(entity)
	if (!entity.OnFire) then
		return false;
	end;
	
	return true;
end;

-- A function to slow a players motion by a specified scale.
function Schema:Slow(player, scale)
	if (!IsValid(player)) then
		return;
	end;
	
	local scale = tonumber(scale) or 1;
	player:SetLaggedMovementValue(scale);
end;

-- A function to clear all the items out of a container.
function Schema:ClearAllItems(entity)
	--printp("ClearAllItems: "..entity:GetClass());
	
	if (!IsValid(entity)) then
		local containerTable = {};
		
		for k, v in pairs (ents.FindByClass("prop_physics")) do
			local model = v:GetModel();
			
			if (cwStorage.containerList[model]) then
				if (!v.cwPassword) then
					containerTable[#containerTable + 1] = v;
				end;
			end;
		end;
		
		for k, v in pairs (containerTable) do
			local position = v:GetPos();
			local model = v:GetModel();
			
			for k2, v2 in pairs (ents.FindInSphere(position, 768)) do
				if (v2:IsPlayer() and v2:Alive() and v2:HasInitialized() and v2:GetMoveType() != MOVETYPE_NOCLIP) then
					continue;
				end;
				
				if (v.cwInventory and !v.cwPassword) then
					v.cwInventory = {};
				end;
			end;
		end;
	else
		if (entity.cwInventory and !entity.cwPassword) then
			entity.cwInventory = {};
		end;
	end;
end;

-- A function to create a blood particle effect.
function Schema:BloodEffect(entity, position, effect)
	if (!IsValid(entity) or !position) then
		return;
	end;
	
	local effect = effect or "blood_advisor_puncture_withdraw";
	local bloodPatch = ents.Create("prop_physics");
		bloodPatch:SetModel("models/hunter/blocks/cube025x025x025.mdl");
		bloodPatch:SetPos(position);
		bloodPatch:SetAngles(Angle(0, 0, 0));
		bloodPatch:Spawn();
		bloodPatch:SetCollisionGroup(COLLISION_GROUP_WORLD);
		bloodPatch:SetParent(entity);
		bloodPatch:SetRenderMode(RENDERMODE_TRANSALPHA);
		bloodPatch:SetColor(Color(255, 255, 255, 0));
	ParticleEffectAttach(effect, PATTACH_ABSORIGIN_FOLLOW, bloodPatch, 0)
	
	timer.Simple(4, function()
		if (IsValid(bloodPatch)) then
			bloodPatch:Remove();
		end;
	end);
end;

-- A function to do a spark effect on an entity or at a specified position.
function Schema:DoSpark(entity)
	local effectData = EffectData();
	
	if (type(entity) == "Entity") then
		effectData:SetOrigin(entity:GetPos());
		entity:EmitSound("ambient/energy/spark"..math.random(1, 6)..".wav");
	else
		effectData:SetOrigin(entity);
		sound.Play("ambient/energy/spark"..math.random(1, 6)..".wav", entity, 100, 100);
	end;
	
	effectData:SetMagnitude(2);
	effectData:SetScale(1);
	util.Effect("Sparks", effectData);
end;

-- A function to do a tesla effect on an entity.
function Schema:DoTesla(entity, bDamage, attacker)
	local effectData = EffectData()
	
	if (IsValid(entity)) then
		effectData:SetOrigin(entity:GetPos());
		entity:EmitSound("ambient/energy/spark"..math.random(1, 6)..".wav");
		
		if (bDamage) then 
			local damage = math.random(5, 10);
			
			if entity:WaterLevel() > 0 then
				damage = damage * 4;
			end
			
			local damageInfo = DamageInfo();
			damageInfo:SetDamage(damage);
			damageInfo:SetDamageType(DMG_SHOCK);
			
			if IsValid(attacker) then
				damageInfo:SetAttacker(attacker);
				
				if attacker.GetActiveWeapon then
					local weapon = attacker:GetActiveWeapon();
					
					if attacker:GetActiveWeapon() then
						damageInfo:SetInflictor(weapon);
					end
				end
			end
			
			entity:TakeDamageInfo(damageInfo);
		end;
		
		effectData:SetEntity(entity);
	else
		--effectData:SetOrigin(entity);
		--sound.Play("ambient/energy/spark"..math.random(1, 6)..".wav", entity, 100, 100);
	end;
	
	effectData:SetMagnitude(4);
	effectData:SetScale(3);
	util.Effect("TeslaHitBoxes", effectData);
end;

-- A function to load the training dummies.
function Schema:LoadDummies()
	local dummies = Clockwork.kernel:RestoreSchemaData("plugins/dummies/"..game.GetMap())

	for k, v in pairs(dummies) do
		local dummy = ents.Create("cw_trainingdummy")

		dummy:SetPos(v.position)
		dummy:SetModel(v.model)
		dummy:SetAngles(v.angles)
		dummy:Spawn()
		
		if v.armor then
			local instance = item.CreateInstance(v.armor.uniqueID, v.armor.itemID, v.armor);

			if (instance and (!instance.OnLoaded or instance:OnLoaded() != false)) then
				dummy:SetArmorItem(instance);
			end
		end

		if v.helmet then
			local instance = item.CreateInstance(v.helmet.uniqueID, v.helmet.itemID, v.helmet);

			if (instance and (!instance.OnLoaded or instance:OnLoaded() != false)) then
				dummy:SetHelmetItem(instance);
			end
		end

		Clockwork.entity:MakeSafe(dummy, true, true)
	end
end

function Schema:SaveDummies()
	local dummies = {}

	for k, v in pairs (ents.FindByClass("cw_trainingdummy")) do
		if (IsValid(v)) then
			local armorTable;
			local helmetTable;
		
			if v.armor and v.armor.IsInstance and v.armor:IsInstance() then
				armorTable = {};
			
				local defaultData = v.armor.defaultData
				local newData = {}

				for k2, v2 in pairs(v.armor.data) do
					if (defaultData[k2] != v2) then
						newData[k2] = v2
					end
				end
				
				newData.uniqueID = v.armor.uniqueID;
				newData.itemID = v.armor.itemID;

				if (!v.armor.OnSaved or v.armor:OnSaved(newData) != false) then
					armorTable = newData
				end
			end
		
			if v.helmet and v.helmet.IsInstance and v.helmet:IsInstance() then
				helmetTable = {};
			
				local defaultData = v.helmet.defaultData
				local newData = {}

				for k2, v2 in pairs(v.helmet.data) do
					if (defaultData[k2] != v2) then
						newData[k2] = v2
					end
				end
				
				newData.uniqueID = v.helmet.uniqueID;
				newData.itemID = v.helmet.itemID;

				if (!v.helmet.OnSaved or v.helmet:OnSaved(newData) != false) then
					helmetTable = newData
				end
			end
		
			dummies[#dummies + 1] = {
				model = v:GetModel(),
				angles = v:GetAngles(),
				position = v:GetPos(),
				armor = armorTable,
				helmet = helmetTable,
			};
		end
	end

	Clockwork.kernel:SaveSchemaData("plugins/dummies/"..game.GetMap(), dummies)
end

-- A function to load the NPCs.
function Schema:LoadNPCs()
	local npcs = Clockwork.kernel:RestoreSchemaData("plugins/npcs/"..game.GetMap());
	
	for k, v in pairs(npcs) do
		local entity = ents.Create(v.class);
		
		if (IsValid(entity)) then
			entity:SetKeyValue("spawnflags", v.spawnFlags or 0);
			entity:SetKeyValue("additionalequipment", v.equipment or "");
			entity:SetAngles(v.angles);
			entity:SetModel(v.model);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (IsValid(entity)) then
				entity:Activate();
				
				entity:SetNetworkedString("cw_Name", v.name);
				entity:SetNetworkedString("cw_Title", v.title);
			end;
		end;
	end;
end;

-- A function to save the NPCs.
function Schema:SaveNPCs()
	local npcs = {};
	
	for k, v in pairs(ents.FindByClass("npc_*")) do
		local name = v:GetNetworkedString("cw_Name");
		local title = v:GetNetworkedString("cw_Title");
		
		if (name != "" and title != "") then
			local keyValues = table.LowerKeyNames(v:GetKeyValues());
			
			npcs[#npcs + 1] = {
				spawnFlags = keyValues["spawnflags"],
				equipment = keyValues["additionequipment"],
				position = v:GetPos(),
				angles = v:GetAngles(),
				model = v:GetModel(),
				title = title,
				class = v:GetClass(),
				name = name
			};
		end;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/npcs/"..game.GetMap(), npcs);
end;

-- A function to load the radios.
function Schema:LoadRadios()
	local radios = Clockwork.kernel:RestoreSchemaData("plugins/radios/"..game.GetMap());
	
	for k, v in pairs(radios) do
		local entity = ents.Create("cw_radio");
		
		Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetFrequency(v.frequency);
			entity:SetOff(v.off);
			entity:SetStatic(v.static);
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the radios.
function Schema:SaveRadios()
	local radios = {};
	
	for k, v in pairs(ents.FindByClass("cw_radio")) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = Clockwork.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetFrequency(),
			static = v:IsStatic()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/radios/"..game.GetMap(), radios);
end;

-- A function to load the radios.
function Schema:SpawnBegottenEntities()
	if map == "rp_begotten3" then
		local bountyBoardEnt = ents.Create("cw_bounty_board");
		local coinslotBase = ents.Create("prop_dynamic");
		local coinslotEnt = ents.Create("cw_coinslot");
		local cinderblockPileEnt = ents.Create("cw_cinderblock_pile");
		local gramophoneBase = ents.Create("prop_dynamic");
		local gramophoneEnt = ents.Create("cw_gramophone");
		local hellPortalEnt = ents.Create("cw_hellportal");
		local sacrificialAltarEnt = ents.Create("cw_sacrifical_altar");
		local archiveEnts = {
			{pos = Vector(2060.40625, 12925.03125, -1009.78125), ang = Angle(0, 180, 90)},
			{pos = Vector(2060.40625, 12796.03125, -1009.78125), ang = Angle(0, 180, 90)},
			{pos = Vector(2060.40625, 12668.875, -1009.78125), ang = Angle(0, 180, 90)},
			{pos = Vector(2060.40625, 12539.6875, -1009.78125), ang = Angle(0, 180, 90)},
		};
		
		bountyBoardEnt:SetPos(Vector(-817.84375, 12163.75, -1103.84375));
		bountyBoardEnt:SetAngles(Angle(0, 0, 0));
		bountyBoardEnt:Spawn();
		coinslotBase:SetModel("models/props/de_inferno/confessional.mdl")
		coinslotBase:SetPos(Vector(6.15625, 13281.5625, -1082.96875));
		coinslotBase:SetAngles(Angle(0, 0, 0));
		coinslotBase:SetMoveType(MOVETYPE_VPHYSICS);
		coinslotBase:PhysicsInit(SOLID_VPHYSICS);
		coinslotBase:SetSolid(SOLID_VPHYSICS);
		coinslotBase:Spawn();
		
		local physObject = coinslotBase:GetPhysicsObject();
		
		if IsValid(physObject) then
			coinslotBase:GetPhysicsObject():Wake();
			coinslotBase:GetPhysicsObject():EnableMotion(false);
		end
		
		coinslotEnt:SetPos(Vector(8.9375, 13292.5, -1031.28125));
		coinslotEnt:SetAngles(Angle(0, 180, 0));
		coinslotEnt:Spawn();
		cinderblockPileEnt:SetPos(Vector(798, 12316, -1080));
		cinderblockPileEnt:SetAngles(Angle(0, 0, 0));
		cinderblockPileEnt:Spawn();
		gramophoneBase:SetModel("models/props/furnitures/humans/l10/l10_bedsidetable.mdl")
		gramophoneBase:SetPos(Vector(-394.28125, -9214.9375, -6466.71875));
		gramophoneBase:SetAngles(Angle(0, 90, 0));
		gramophoneBase:SetMoveType(MOVETYPE_VPHYSICS);
		gramophoneBase:PhysicsInit(SOLID_VPHYSICS);
		gramophoneBase:SetSolid(SOLID_VPHYSICS);
		--gramophoneBase:SetHealth(0);
		gramophoneBase:Spawn();
		gramophoneEnt:SetPos(Vector(-393.1875, -9214.90625, -6426.65625));
		gramophoneEnt:SetAngles(Angle(0, 180, 0));
		gramophoneEnt:Spawn();
		hellPortalEnt:SetPos(Vector(-8246.09375, -9135.40625, -7182.28125));
		hellPortalEnt:SetAngles(Angle(90, 180, 180));
		hellPortalEnt:Spawn();
		sacrificialAltarEnt:SetPos(Vector(-2653.78125, -9140.3125, -6581.71875));
		sacrificialAltarEnt:SetAngles(Angle(0, 180, 0));
		sacrificialAltarEnt:Spawn();
		
		for i = 1, #archiveEnts do
			local archiveEnt = ents.Create("cw_archives");
			
			archiveEnt:SetPos(archiveEnts[i].pos);
			archiveEnt:SetAngles(archiveEnts[i].ang);
			archiveEnt:Spawn();
		end
		
		self.sacrificialAltarEnt = sacrificialAltarEnt;
	elseif map == "rp_begotten_redux" or map == "rp_scraptown" then
		local gramophoneBase = ents.Create("prop_dynamic");
		local gramophoneEnt = ents.Create("cw_gramophone");
		local hellPortalEnt = ents.Create("cw_hellportal");
		local sacrificialAltarEnt = ents.Create("cw_sacrifical_altar");
		
		gramophoneBase:SetModel("models/props/furnitures/humans/l10/l10_bedsidetable.mdl")
		gramophoneBase:SetPos(Vector(-394.28125, -9214.9375, -6466.71875));
		gramophoneBase:SetAngles(Angle(0, 90, 0));
		gramophoneBase:SetMoveType(MOVETYPE_VPHYSICS);
		gramophoneBase:PhysicsInit(SOLID_VPHYSICS);
		gramophoneBase:SetSolid(SOLID_VPHYSICS);
		--gramophoneBase:SetHealth(0);
		gramophoneBase:Spawn();
		gramophoneEnt:SetPos(Vector(-393.1875, -9214.90625, -6426.65625));
		gramophoneEnt:SetAngles(Angle(0, 180, 0));
		gramophoneEnt:Spawn();
		hellPortalEnt:SetPos(Vector(-8246.09375, -9135.40625, -7182.28125));
		hellPortalEnt:SetAngles(Angle(90, 180, 180));
		hellPortalEnt:Spawn();
		sacrificialAltarEnt:SetPos(Vector(-2653.78125, -9140.3125, -6581.71875));
		sacrificialAltarEnt:SetAngles(Angle(0, 180, 0));
		sacrificialAltarEnt:Spawn();
		
		self.sacrificialAltarEnt = sacrificialAltarEnt;
	end
end;

-- A function to get whether an entity is inside the tower of light.
function Schema:InTower(entity)
	if map == "rp_begotten3" then
		return entity:GetPos():WithinAABox(Vector(2400, 15147, -2778), Vector(-2532, 11748, 2048));
	elseif map == "rp_begotten_redux" then
		return entity:GetPos():WithinAABox(Vector(-8896, -10801, 69), Vector(-13525, -3070, 914));
	elseif map == "rp_scraptown" then
		return entity:GetPos():WithinAABox(Vector(-2446, -7, -262), Vector(-8792, -8935, 2110));
	end
end;

-- A function to get a player's location.
function Schema:PlayerGetLocation(player) end;

-- A function to get a player's heal amount.
function Schema:GetHealAmount(player, scale) end;

-- A function to get a player's dexterity time.
function Schema:GetDexterityTime(player) end;

-- A function to make a player wear clothes.
function Schema:PlayerWearClothes(player, itemTable, noMessage)
	local clothes = player:GetCharacterData("clothes");
	
	if (itemTable) then
		local model = Clockwork.class:GetAppropriateModel(player:Team(), player, true);
		
		if (!model) then
			itemTable:OnChangeClothes(player, true);
			
			player:SetCharacterData("clothes", itemTable.index);
			player:SetNetVar("clothes", itemTable.index);
		end;
	else
		itemTable = Clockwork.item:FindByID(clothes);
		
		if (itemTable) then
			itemTable:OnChangeClothes(player, false);
			
			player:SetCharacterData("clothes", nil);
			player:SetNetVar("clothes", 0);
		end;
	end;
end;

-- A function to bust down a door.
function Schema:BustDownDoor(player, door, force)
	door.bustedDown = true;
	
	door:SetNotSolid(true);
	door:DrawShadow(false);
	door:SetNoDraw(true);
	door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
	door:Fire("Unlock", "", 0);

	if (IsValid(door.breach)) then
		door.breach:BreachEntity();
	end;
	
	local fakeDoor = ents.Create("prop_physics");
	
	fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD);
	fakeDoor:SetAngles(door:GetAngles());
	fakeDoor:SetModel(door:GetModel());
	fakeDoor:SetSkin(door:GetSkin());
	fakeDoor:SetPos(door:GetPos());
	fakeDoor:Spawn();
	
	local physicsObject = fakeDoor:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		if (!force) then
			if (IsValid(player)) then
				physicsObject:ApplyForceCenter((door:GetPos() - player:GetPos()):GetNormal() * 10000);
			end;
		else
			physicsObject:ApplyForceCenter(force);
		end;
	end;
	
	Clockwork.entity:Decay(fakeDoor, 300);
	
	Clockwork.kernel:CreateTimer("reset_door_"..door:EntIndex(), 300, 1, function()
		if (IsValid(door)) then
			door.bustedDown = nil;
			door:SetNotSolid(false);
			door:DrawShadow(true);
			door:SetNoDraw(false);
		end;
	end);
end;

-- A function to permanently kill a player.
function Schema:PermaKillPlayer(player, ragdoll, bSilent)
	if player then
		--[[if (player:Alive()) then
			player:Kill(); ragdoll = player:GetRagdollEntity();
		end;]]--
		
		if (!player:GetCharacterData("permakilled")) then
			player:SetCharacterData("permakilled", true);
		end
		
		local inventory = player:GetInventory();
		local copy = Clockwork.inventory:CreateDuplicate(inventory);
		local cash = player:GetCash();
		local info = {};
		
		info.inventory = copy;
		info.cash = cash;
		
		Clockwork.plugin:Call("PlayerAdjustPermaKillInfo", player, info);
		
		for k, v in pairs(info.inventory) do
			local itemTable = Clockwork.item:FindByID(k);
			
			if (itemTable and itemTable.allowStorage == false) then
				info.inventory[k] = nil;
			end;
		end;
		
		for k, v in pairs(inventory) do
			for k2,v2 in pairs(v) do
				player:TakeItem(v2);
			end
		end
		
		player.bgBackpackData = nil;
		player.bgCharmData = nil;
		player:SetCharacterData("permakilled", true);
		player:SetCharacterData("Cash", 0, true);
		player:SetCharacterData("backpacks", nil);
		player:SetCharacterData("charms", nil);
		player:SetCharacterData("helmet", nil);
		player:SetSharedVar("Cash", 0);
		player:SetNetVar("backpacks", 0);
		player:SetNetVar("charms", 0);
		player:SetNetVar("helmet", 0);
		player:SetBodygroup(0, 0);
		player:SetBodygroup(1, 0);
		
		Clockwork.datastream:Start(player, "BGBackpackData", {});
		Clockwork.datastream:Start(player, "BGCharmData", {});
		Clockwork.datastream:Start(player, "BGClothes", {});
		
		if !ragdoll then
			ragdoll = player:GetRagdollEntity();
		end
		
		if (!IsValid(ragdoll)) then
			info.entity = ents.Create("cw_belongings");

			if (!table.IsEmpty(info.inventory) or info.cash > 0) then
				info.entity:SetData(info.inventory, info.cash);
				info.entity:SetPos(player:GetPos() + Vector(0, 0, 48));
				info.entity:Spawn();
			else
				info.entity:Remove();
			end;
		else
			ragdoll.isBelongings = true;
			ragdoll.cwInventory = info.inventory;
			ragdoll.cwCash = info.cash;
			
			local bounty = player:GetCharacterData("bounty", 0);
		
			if bounty > 0 then
				ragdoll:SetNWInt("bountyKey", player:GetCharacterKey());
			end
		end;
		
		Clockwork.player:StripGear(player);
		Clockwork.player:SaveCharacter(player);
	end
end;

-- A function to un-permanently kill a player.
function Schema:UnPermaKillPlayer(player)
	if (!player:Alive()) then
		player:Spawn();
	end;
	
	if (player:GetMoveType(player) == MOVETYPE_NOCLIP) then
		cwObserverMode:MakePlayerExitObserverMode(player);
	end
	
	local info = {};
	
	if (player:GetCharacterData("permakilled")) then
		player:SetCharacterData("permakilled", false);
		
		--Clockwork.limb:HealBody(player, 100);
		Clockwork.limb:ResetDamage(player);
		Clockwork.player:SaveCharacter(player);
	end;
end;

-- For the 'Followed' trait.
function Schema:CheapleCaughtPlayer(player)
	if IsValid(player) and player:Alive() then
		local playerCount = _player.GetCount();
		local players = _player.GetAll();
		local listeners = {};
		local radius = config.Get("talk_radius"):Get() * 2;
		local playerPos = player:GetPos();

		for i = 1, playerCount do
			local v, k = players[i], i;
			
			if v ~= player and (playerPos:DistToSqr(v:GetPos()) <= (radius * radius)) then
				listeners[#listeners + 1] = v;
			end;
		end
	
		Clockwork.chatBox:Add(listeners, player, "me", "suddenly blinks out of existence, as though they were never there at all!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		
		player:DeathCauseOverride("Had their curse catch up with them.");
		
		if game.GetMap() == "rp_begotten3" then
			player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
			player:SensesOff();
			Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
			Clockwork.player:SetAction(player, false);
			Clockwork.player:SetSafePosition(player, Vector(222, 4992, -11075));
			player:SetEyeAngles(Angle(0, 180, 0));
			player:Freeze(true);
			player.scriptedDying = true;
			player.caughtByCheaple = true;

			timer.Simple(9, function()
				player:Freeze(false);
				player.scriptedDying = false;
				player.caughtByCheaple = false;
				player:SetCharacterData("CheaplePos", nil);
				player:KillSilent();
				Schema:PermaKillPlayer(player, nil, true);
			end);
		else
			player:KillSilent();
			Schema:PermaKillPlayer(player, nil, true);
		end
		
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." was caught by a cheaple!", nil);
		netstream.Start(player, "CheapleCutscene");
	end
end

-- A function to blood test a player for their faith.
function Schema:BloodTestPlayer(player, bFalsePositives, bDetectImposters)
	local faith = player:GetFaith();
	local subfaith = player:GetSubfaith();
	local subfaction = player:GetSubfaction();
	
	if (faith ~= "Faith of the Light" and ((!bDetectImposters and subfaction ~= "Kinisger") or bDetectImposters)) or subfaith == "Voltism" or (bFalsePositives and math.random(1, 20) == 1 and not player:HasBelief("favored")) then
		Clockwork.chatBox:AddInTargetRadius(player, "it", "The blood test comes up red.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		player:EmitSound("ambient/alarms/klaxon1.wav");
		
		return;
	elseif cwCharacterNeeds and player:GetNeed("corruption", 0) >= 50 then
		Clockwork.chatBox:AddInTargetRadius(player, "it", "The blood test comes up red.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		player:EmitSound("ambient/alarms/klaxon1.wav");
		
		return;
	else
		Clockwork.chatBox:AddInTargetRadius(player, "it", "The blood test comes up green.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		player:EmitSound("plats/elevbell1.wav");
		
		return;
	end
end;

-- A function to tie or untie a player.
function Schema:TiePlayer(player, isTied, reset)
	if (isTied) then
		player:SetNetVar("tied", 1);
	else
		player:SetNetVar("tied", 0);
	end;
	
	if (isTied) then
		--Clockwork.player:DropWeapons(player);
		player:UnequipWeapons();
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has been tied.");
		
		player:Flashlight(false);
		player:StripWeapons();
	elseif (!reset) then
		if (player:Alive()) then 
			if !player:IsRagdolled() then
				Clockwork.player:LightSpawn(player, true, true);
			else
				hook.Run("PlayerLoadout", player);
			end
		end;
		
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has been untied.");
	end;
end;

netstream.Hook("ContentBypass", function(player, data)
	if data then
		Schema:EasyText(GetAdmins(), "indianred", player:Name().." has skipped content verification due to a scripting error! They will be playing with missing content!")
	else
		Schema:EasyText(GetAdmins(), "indianred", player:Name().." has skipped content verification! They will be playing with missing content!")
	end
end);

netstream.Hook("CheapleCaught", function(player, data)
	Schema:CheapleCaughtPlayer(player);
end);

netstream.Hook("SaveCheaplePos", function(player, data)
	if data and isvector(data) then
		player:SetCharacterData("CheaplePos", {x = data.x, y = data.y, z = data.z});
	end
end);

netstream.Hook("ObjectPhysDesc", function(player, data)
	if (type(data) == "table" and type(data[1]) == "string") then
		if (player.objectPhysDesc == data[2]) then
			local physDesc = data[1];
			
			if (string.len(physDesc) > 80) then
				physDesc = string.sub(physDesc, 1, 80).."...";
			end;
			
			data[2]:SetNetworkedString("physDesc", physDesc);
		end;
	end;
end);

netstream.Hook("EnteredZone", function(player, uniqueID)
	--print("EnteredZone for "..player:Name()..": "..tostring(uniqueID));

	if (Schema.zones[uniqueID]) then
		--print("Setting new zone in chardata!");
		player:SetCharacterData("LastZone", uniqueID);
		hook.Run("PlayerChangedZones", player, uniqueID);
	else
		--print("Zone not valid, setting to nil!");
		player:SetCharacterData("LastZone", nil);
	end;
end);

netstream.Hook("UpdateLightColor", function(player, red, green, blue)
	if (!red or !green or !blue) then
		return;
	end;
	
	player.LightColor = Color(red, green, blue);
	player:SetNWVector("LightColor", Vector(red, green, blue));
end);

netstream.Hook("QueryBountyBoard", function(player, state)
	if cwBeliefs and !player:HasBelief("literacy") then
		Schema:EasyText(player, "chocolate", "You gaze upon the funny pictures on the bounty board, but as you are not literate you cannot read anything on it!");
	else
		local tab = {};

		for k, v in pairs(Schema.bountyData) do
			if v then
				tab[k] = v;
			end
		end

		netstream.Heavy(player, "OpenBountyList", tab, state);
	end
end);

local playerMeta = FindMetaTable("Player");
local entityMeta = FindMetaTable("Entity");

function playerMeta:GetBounty()
	return self:GetCharacterData("bounty");
end;

function playerMeta:IsWanted()
	return self:GetCharacterData("bounty", 0) > 0;
end;

function playerMeta:AddBounty(bounty, reason, poster)
	if IsValid(poster) and poster:IsPlayer() then
		local faction = self:GetSharedVar("kinisgerOverride") or self:GetFaction()
		
		if (faction  == "Gatekeeper" or faction  == "Holy Hierarchy") and !poster:IsAdmin() then
			Schema:EasyText(poster, "cornflowerblue", "You cannot place a bounty on "..self:Name().."!");
			
			return;
		end
	end
	
	if self:GetCharacterData("permakilled") or !self:Alive() then
		if IsValid(poster) and poster:IsPlayer() then
			Schema:EasyText(poster, "peru", self:Name().." is permakilled and cannot have a bounty placed on them!");
		end
		
		return;
	end
	
	self:SetCharacterData("bounty", self:GetCharacterData("bounty", 0) + bounty);
	self:SetSharedVar("bounty", self:GetCharacterData("bounty", 0));
	
	local characterKey = self:GetCharacterKey();
	local bountyData = Schema.bountyData[characterKey];
	local tab = {};
	
	tab.bounty = self:GetCharacterData("bounty", 0);
	tab.name = self:Name(true);
	tab.model = self:GetModel();
	tab.bodygroup1 = self:GetBodygroup(0);
	tab.bodygroup2 = self:GetBodygroup(1);
	tab.skin = self:GetSkin();
	
	local physDesc = self:GetCharacterData("PhysDesc", "Wearing dirty clothes and a small satchel");
	
	if string.len(physDesc) > 128 then
		physDesc = string.Left(physDesc, 129);
	end
	
	tab.physDesc = physDesc;
	
	if reason then
		tab.reason = reason;
	elseif bountyData and bountyData.reason then
		tab.reason = bountyData.reason;
	end
	
	if IsValid(poster) and poster:IsPlayer() then
		tab.poster = poster:Name();
		
		Clockwork.player:GiveCash(poster, -bounty, "Placing a Bounty", true);
	end

	Schema.bountyData[characterKey] = tab;
	Clockwork.kernel:SaveSchemaData("bountyData", Schema.bountyData);
	
	if IsValid(poster) and poster:IsPlayer() then
		Schema:EasyText(poster, "cornflowerblue", "You have placed a "..tostring(tab.bounty).." coin bounty on "..tab.name.."!");
	
		if tab.bounty == bounty then
			Schema:EasyText(GetAdmins(), "green", poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."!");
			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."!");
		else
			Schema:EasyText(GetAdmins(), "green", poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."! Their total bounty now stands at "..tostring(tab.bounty).." coin!");
			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."! Their total bounty now stands at "..tostring(tab.bounty).." coin!");
		end
	end
end;

function playerMeta:RemoveBounty(remover)
	if self:GetCharacterData("bounty", 0) > 0 then
		self:SetCharacterData("bounty", 0);
		self:SetSharedVar("bounty", 0);
	end
	
	local characterKey = self:GetCharacterKey();
	local bountyData = Schema.bountyData;
	
	if characterKey and bountyData[characterKey] then
		bountyData = bountyData[characterKey];
		
		if bountyData and IsValid(remover) and remover:IsPlayer() then
			if bountyData.bounty then
				Clockwork.player:GiveCash(remover, bountyData.bounty, "Renouncing a Bounty", true);
			end
		end
		
		Schema.bountyData[characterKey] = nil;
		Clockwork.kernel:SaveSchemaData("bountyData", Schema.bountyData);
		
		if IsValid(remover) and remover:IsPlayer() then
			Schema:EasyText(remover, "cornflowerblue", "You have removed the bounty for "..self:Name().."!");
			Schema:EasyText(GetAdmins(), "tomato", remover:Name().." has removed the bounty for "..self:Name().."!");
			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, remover:Name().." has removed the bounty for "..self:Name().."!");
		end
	end
	
	Schema:EasyText(remover, "peru", self:Name().." does not have a bounty!");
end;

function Schema:AddBounty(key, bounty, reason, poster)
	local charactersTable = config.Get("mysql_characters_table"):Get();
	local queryObj = Clockwork.database:Select(charactersTable)
		queryObj:Callback(function(result)
			if (Clockwork.database:IsResult(result)) then
				for k, v in pairs(result) do
					local permakilled = false;
					local data;
					local faction;
					
					if v._Data then
						data = Clockwork.player:ConvertDataString(player, v._Data);
						
						if data then
							permakilled = data["permakilled"];
							faction = data["kinisgerOverride"];
						end
					end
					
					if not faction then
						faction = v._Faction;
					end
					
					if IsValid(poster) and poster:IsPlayer() and faction then
						if (faction  == "Gatekeeper" or faction  == "Holy Hierarchy") and !poster:IsAdmin() then
							Schema:EasyText(poster, "cornflowerblue", "You cannot place a bounty on "..v._Name.."!");
							
							return;
						end
					end
					
					if data and permakilled ~= true then
						local bountyData = Schema.bountyData[v._Key];
						local tab = {};
						
						tab.bounty = (data["bounty"] or 0) + bounty;
						tab.name = v._Name or "Unknown Name";
						tab.model = v._Model or "models/humans/group01/male_cheaple.mdl";
						tab.skin = v._Skin or 0;
						
						local helmet = data["helmet"];
						local bodygroup;
						local bodygroupVal;

						if helmet then
							if helmet.uniqueID and helmet.itemID then
								local item = Clockwork.item:FindByID(helmet.uniqueID, helmet.itemID);
								
								if item and item.bodyGroup and item.bodyGroupVal then
									bodygroup = item.bodyGroup;
									bodygroupVal = item.bodyGroupVal;
								end
							end
						end
						
						if bodygroup then
							if bodygroupVal == 0 then
								tab.bodygroup1 = bodygroup;
							else
								tab.bodygroup2 = bodygroup;
							end
						end
						
						local physDesc = data["PhysDesc"] or "Wearing dirty clothes and a small satchel";
						
						if string.len(physDesc) > 128 then
							physDesc = string.Left(physDesc, 129);
						end
						
						tab.physDesc = physDesc;
						
						if reason then
							tab.reason = reason;
						elseif bountyData and bountyData.reason then
							tab.reason = bountyData.reason;
						end
						
						if IsValid(poster) and poster:IsPlayer() then
							tab.poster = poster:Name();
							
							Clockwork.player:GiveCash(poster, -bounty, "Placing a Bounty", true);
						end
						
						Schema.bountyData[v._Key] = tab;
						Clockwork.kernel:SaveSchemaData("bountyData", Schema.bountyData);

						if IsValid(poster) and poster:IsPlayer() then
							Schema:EasyText(poster, "cornflowerblue", "You have placed a "..tostring(tab.bounty).." coin bounty on "..tab.name.."!");
						
							if tab.bounty == bounty then
								Schema:EasyText(GetAdmins(), "green", poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."!");
								Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."!");
							else
								Schema:EasyText(GetAdmins(), "green", poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."! Their total bounty now stands at "..tostring(tab.bounty).." coin!");
								Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, poster:Name().." has placed a "..tostring(bounty).." coin bounty on "..tab.name.."! Their total bounty now stands at "..tostring(tab.bounty).." coin!");
							end
						end
						
						return;
					else
						if IsValid(poster) and poster:IsPlayer() then
							Schema:EasyText(poster, "peru", v._Name.." is permakilled and cannot have a bounty placed on them!");
						end
						
						return;
					end
				end
			end
			
			if IsValid(poster) and poster:IsPlayer() then
				Schema:EasyText(poster, "peru", "The character "..tostring(key).." could not be located!");
			end
		end);

		if tonumber(key) then
			queryObj:Where("_Key", tonumber(key))
		else
			queryObj:Where("_Name", key)
		end
	queryObj:Execute()
end

function Schema:RemoveBounty(key, remover)
	local charactersTable = config.Get("mysql_characters_table"):Get();
	local queryObj = Clockwork.database:Select(charactersTable)
		queryObj:Callback(function(result)
			if (Clockwork.database:IsResult(result)) then
				for k, v in pairs(result) do
					if Schema.bountyData[v._Key] then
						if v._Data then
							local data = Clockwork.player:ConvertDataString(player, v._Data)
							
							if data and data["bounty"] then
								if IsValid(remover) and remover:IsPlayer() then
									Clockwork.player:GiveCash(remover, data["bounty"], "Renouncing a Bounty", true);
								end
							end
						end

						Schema.bountyData[v._Key] = nil;
						Clockwork.kernel:SaveSchemaData("bountyData", Schema.bountyData);
						
						if IsValid(remover) and remover:IsPlayer() then
							Schema:EasyText(remover, "cornflowerblue", "You have removed the bounty for "..v._Name.."!");
							Schema:EasyText(GetAdmins(), "tomato", remover:Name().." has removed the bounty for "..v._Name.."!");
							Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, remover:Name().." has removed the bounty for "..v._Name.."!");
						end
						
						return;
					end
				end
			end
			
			if IsValid(remover) and remover:IsPlayer() then
				Schema:EasyText(remover, "peru", "The character "..tostring(key).." could not be located or does not have a bounty!");
			end
		end);

		if tonumber(key) then
			queryObj:Where("_Key", tonumber(key))
		else
			queryObj:Where("_Name", key)
		end
	queryObj:Execute()
end

-- A function to get a player's light color.
function playerMeta:GetLightColor()
	if (self.LightColor) then
		return self.LightColor
	end;
	
	return false;
end;

function playerMeta:HasCharmEquipped(uniqueID)
	if self.bgCharmData then
		for i = 1, #self.bgCharmData do
			if self.bgCharmData[i] and self.bgCharmData[i].uniqueID == uniqueID then
				return true;
			end
		end
	end
	
	return false;
end

-- A function to get whether a player is inside the tower of light.
function playerMeta:InTower(bIgnoreAdmins)
	return Schema:InTower(self, bIgnoreAdmins);
end;

-- A function that makes managing inventory items easier.
function playerMeta:UpdateInventory(uniqueID, count)
	local count = tonumber(count) or 1;
	
	if (uniqueID) then
		if (count > 0) then
			for i = 1, count do
				self:GiveItem(Clockwork.item:CreateInstance(uniqueID), true);
			end;
		else
			if (self:HasItemByID(uniqueID)) then
				local inventory = self:GetInventory();
				local itemCount = Clockwork.inventory:GetItemCountByID(inventory, uniqueID);
				local count = math.Clamp(math.abs(count), 0, itemCount);

				for i = 1, count do
					self:TakeItem(self:FindItemByID(uniqueID));
				end;
			end;
		end;
	end;
end;

-- A function to force the player to unequip their clothing item.
function playerMeta:UnequipClothes()
	local itemTable = self:GetClothesItem();

	if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
		if (itemTable:HasPlayerEquipped(self, nil)) then
			itemTable:OnPlayerUnequipped(self, nil);
			self:RebuildInventory();
		end;
	end;
end;

-- A function to force the player to unequip their weapon items.
function playerMeta:UnequipWeapons()
	for k, v in pairs (self:GetWeapons()) do
		local itemTable = Clockwork.item:GetByWeapon(v);
		
		if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then

			if (itemTable:HasPlayerEquipped(self, nil)) then
				itemTable:OnPlayerUnequipped(self, nil);
				self:RebuildInventory();
			end;
		end;
	end;
end;

function Schema:PlayerCommitSuicide(player)
	local thirdPerson = "him";
	local gender = "He";
	local genderlc = "he";
	local possessive = "his";
	local selfless = "himself";
	local madman = "madman";

	if (player:GetGender() == GENDER_FEMALE) then
		thirdPerson = "her";
		gender = "She";
		genderlc = "she";
		possessive = "her";
		selfless = "herself";
		madman = "madwoman";
	end;
	
	local SuicideMethods = 
	{
		"pulls a makeshift shiv out of "..possessive.." pocket and sticks it in "..possessive.." fucking neck.",
		"pulls a makeshift shiv out of "..possessive.." pocket and gouges it into both of "..possessive.." fucking eyes.",
		"pulls a makeshift shiv out of "..possessive.." pocket and plunges it deep into "..possessive.." god damn stomach.",
		"places "..possessive.." hands on "..possessive.." neck and twists it until it fucking snaps.",
		"pulls out a knife and cuts out "..possessive.." tongue. "..gender.." would then stuff it down "..possessive.." fucking throat, and would quickly suffocate "..selfless.." before falling over and dying.",
		"picks up a chunk of rubble off the ground. "..gender.." would then smash it into "..possessive.." fucking head, falling over and dying within a couple strikes.",
		"screams like a "..madman.." and jams "..possessive.." thumbs into "..possessive.." eyes, reeling in pain as blood gushes all over the fucking place before finally collapsing, dead.",
		"gets a mad look in "..possessive.." eyes and digs out "..possessive.." fucking throat with "..possessive.." nails, blood gushing from the wound everywhere.",
		"rips off "..possessive.." nose with his bare hands, shoving it down "..possessive.." fucking throat, choking to death.",
		"digs out "..possessive.." wrist arteries with "..possessive.." nails, screaming in agony as "..genderlc.." bleeds out.",
		"pulls out a knife and fucking cuts open "..possessive.." stomach, digging inside with "..possessive.." and disemboweling himself with "..possessive.." bare hands.",
		"gets on all fours and bangs "..possessive.." head repeatedly against the ground, shattering "..possessive.." skull after several successive hits.",
		"starts fucking choking "..selfless.." with "..possessive.." own two hands! Holy shit! Eventually "..genderlc.." turns blue and collapses, dead. What a twisted fuck!",
		"puts both "..possessive.." hands into "..possessive.." mouth, and violently fucking rips "..possessive.." jaw off! Jesus Christ! "..gender.." then would scream in agony for a split second before snapping "..possessive.." neck!",
		"starts cutting "..possessive.." face into ribbons with "..possessive.." god damn nails. What a twisted fucking psychopath!",
		"abruptly does a backflip, landing on "..possessive.." neck and breaking "..possessive.." skull against the floor with a sickening crunch of bone and cartilage as brain matter spews everywhere.",
		"pulls out a knife and starts fucking flaying "..selfless.." alive! Holy shit! Layers upon layers of skin find themselves on the ground before "..genderlc.." finally collapses in a pool of blood.",
		"suddenly plunges "..possessive.." fucking hand into "..possessive.." throat, driving "..possessive.." arm deep inside. "..gender.." then painfully pulls out "..possessive.." own god damn intestines! Holy fucking shit! "..gender.." would then collapsed in a pool of blood.",
		"suddenly begins tightening "..possessive.." fists, clenching every muscle in "..possessive.." body. As "..genderlc.." does this, "..possessive.." face and knuckles begin to turn a bright red as "..possessive.." limbs tremble back and forth, increasing in magnitude until "..possessive.." epidermal layer is a bright lobster red. Abruptly, "..possessive.." entire fucking body rips apart, exploding in a massive cloud of red blood and bodyparts, viscera spilling everywhere! What the fuck happened?!?"
	}

	player:Freeze(true);
	
	local suicideMethod = table.Random(SuicideMethods);
	
	Clockwork.chatBox:AddInTargetRadius(player, "me", suicideMethod, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	
	timer.Simple(3, function()
		if IsValid(player) then
			player:Kill();
			player:DeathCauseOverride("Went fucking insane and brutally killed "..selfless..".");
			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." has committed fucking suicide.");
			
			if string.find(suicideMethod, "exploding") then
				if (player:GetRagdollEntity()) then
					cwGore:SplatCorpse(player:GetRagdollEntity(), 60);
				end;
			end
		end
	end);
end

-- A function to force the player to fucking kill themself.
function playerMeta:CommitSuicide()
	Schema:PlayerCommitSuicide(self);
end;

function Schema:ScriptedDeath(player, deathcause)
	local stingers = {"begotten/score5.mp3", "begotten/score6.mp3"};
	
	player.scriptedDying = true;
	player:Freeze(true);
	player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
	Clockwork.datastream:Start(player, "FadeAllMusic");
	
	timer.Simple(3, function()
		if IsValid(player) and player.scriptedDying then
			Clockwork.datastream:Start(player, "Stunned", 2);
			Clockwork.player:PlaySound(player, stingers[math.random(1, #stingers)]);
			
			timer.Simple(8, function()
				if IsValid(player) and player.scriptedDying then
					player:Kill();
					player:Freeze(false);
					
					-- it should become false when the player dies but let's just make sure anyway
					player.scriptedDying = false;
					
					if deathcause then
						player:DeathCauseOverride(deathcause);
					end
				end
			end);
		end
	end);
end

function playerMeta:ScriptedDeath(deathcause)
	Schema:ScriptedDeath(self, deathcause);
end

-- A function to get whether an entity is inside the tower of light.
function entityMeta:InTower(bIgnoreAdmins)
	return Schema:InTower(self, bIgnoreAdmins);
end;

function Schema:PlayerWakeup(player)
	player.cwWakingUp = true;

	netstream.Start(player, "WakeupSequence");
	
	timer.Simple(0.5, function()
		if IsValid(player) and player.cwWakingUp then
			player:Freeze(true);
		end
	end);
	
	timer.Simple(21, function()
		if IsValid(player) and player.cwWakingUp then
			player:PlayStepSound(1);
		end
	end);
	
	timer.Simple(23, function()
		if IsValid(player) and player.cwWakingUp then
			player:PlayStepSound(1);
		end
	end);
	
	timer.Simple(25, function()
		if IsValid(player) and player.cwWakingUp then
			player:PlayStepSound(1);
		end
	end);
	
	timer.Simple(35, function()
		if IsValid(player) and player.cwWakingUp then
			-- Wakeup sequence likely didn't end on its own so we should force it to.
			self:PlayerFinishWakeup(player);
		end
	end);
end;

function Schema:PlayerFinishWakeup(player)
	player.cwWakingUp = false;
	player:Freeze(false);
	
	netstream.Start(player, "ForceEndWakeupSequence");
	
	timer.Simple(5, function()
		if player then
			netstream.Start(player, "StartAmbientMusic");
		end
	end);
end

function Schema:ModifyTowerTreasury(amount)
	if !self.towerTreasury then
		Schema:EasyText(GetAdmins(), "red", "The tower treasury was not initialized properly!", nil);
		self.towerTreasury = 0;
	end
	
	self.towerTreasury = self.towerTreasury + amount;
end

function Schema:AddBookTowerArchives(player, itemTable)
	if !self.archivesBookList then
		self.archivesBookList = {};
	end
	
	local uniqueID = itemTable.uniqueID;
	
	if self.archivesBookList[uniqueID] and isnumber(self.archivesBookList[uniqueID]) then
		self.archivesBookList[uniqueID] = self.archivesBookList[uniqueID] + 1;
	else
		self.archivesBookList[uniqueID] = 1;
	end
	
	local playerCount = _player.GetCount();
	local players = _player.GetAll();

	for i = 1, playerCount do
		local v, k = players[i], i;
		if (v:HasInitialized()) then
			netstream.Start(v, "Archives", self.archivesBookList);
		end
	end
	
	player:TakeItem(itemTable, true);
	Schema:EasyText(player, "olivedrab", "You have added a copy of '"..itemTable.name.."' to the archives.");
end

function Schema:TakeBookTowerArchives(player, uniqueID)
	if !self.archivesBookList then
		self.archivesBookList = {};
		return;
	end
	
	if self.archivesBookList[uniqueID] and isnumber(self.archivesBookList[uniqueID]) then
		local itemTable = item.CreateInstance(uniqueID);
		local bSuccess, fault = player:GiveItem(itemTable, true);
		
		if (bSuccess) then
			self.archivesBookList[uniqueID] = self.archivesBookList[uniqueID] - 1;
			
			if self.archivesBookList[uniqueID] == 0 then
				self.archivesBookList[uniqueID] = nil
			end
		
			Schema:EasyText(player, "olivedrab", "You have taken a copy of '"..itemTable.name.."' from the archives.");
			
			local playerCount = _player.GetCount();
			local players = _player.GetAll();

			for i = 1, playerCount do
				local v, k = players[i], i;
				if (v:HasInitialized()) then
					netstream.Start(v, "Archives", self.archivesBookList);
				end
			end
		end
	else
		Schema:EasyText(player, "peru", "This book does not exist in the archives!");
		self.archivesBookList[uniqueID] = nil
	end
end

function Schema:SacrificePlayer(player, sacrificer, method, bShared)
	local playerName = player:Name();
	local playerGender = player:GetGender();
	local playerMarked = player:GetCharacterData("markedBySatanist");
	local sacrificerName = sacrificer:Name();
	local sacrifice_strings = {
		["disembowel"] = {"disembowels "..playerName, "guts "..playerName.." like a pig"},
		["dismember"] = {"cuts off each one of "..playerName.."'s limbs one by one"},
		["flay"] = {"slowly fillets the skin of "..playerName..", drawing out the pain as much as possible"},
	};
	local chosenString = sacrifice_strings[method][math.random(1, #sacrifice_strings[method])];
	
	player:DeathCauseOverride("Was sacrificed before an altar in Hell by "..sacrificerName..".");
	player:SetCharacterData("permakilled", true); -- In case the player tries to d/c to avoid their fate.
	player.beingSacrificed = true;
	sacrificer.sacrificing = true;
	sacrificer:Freeze(true);
	sacrificer:SetKills(sacrificer:GetKills() + 1);
	Clockwork.chatBox:AddInTargetRadius(sacrificer, "me", chosenString.." as the altar before them absorbs their life force.", sacrificer:GetPos(), config.Get("talk_radius"):Get() * 2);
	
	local killXP;
	local faithModifiers;
	local faithModifier;
	
	if cwBeliefs then
		killXP = (cwBeliefs.xpValues["kill"] * 4) or 10;
		faithModifiers = {
			["Faith of the Light"] = 4,
			["Faith of the Family"] = 2,
			["Faith of the Dark"] = 1,
		};
		faithModifier = faithModifiers[player:GetFaith()] or 2;
		
		if player:GetSubfaith() == "Faith of the Sister" then
			faithModifier = 1;
		end
		
		killXP = killXP * math.Clamp(player:GetCharacterData("level", 1), 1, 40);
		killXP = killXP * faithModifier;
	end
	
	local sacrificeSound = "sanitysounds/torture1.mp3";
	local sacrificeTimer = 40;
	
	if playerGender == GENDER_FEMALE then
		sacrificeSound = "sanitysounds/torture_female.mp3";
		sacrificeTimer = 20;
	end
	
	player:EmitSound(sacrificeSound);
	
	timer.Simple(sacrificeTimer, function()
		if IsValid(sacrificer) then
			sacrificer.sacrificing = false;
			sacrificer:Freeze(false);
			
			if playerMarked == true then
				killXP = killXP + 100;
				Clockwork.player:GiveCash(sacrificer, 666, "Marked Sacrifice");
				sacrificer:HandleNeed("corruption", -50);
				
				Clockwork.chatBox:Add(sacrificer, nil, "itnofake", "As you sacrifice "..playerName.." and fulfill the blood contract fully, you feel your pockets suddenly become much heavier.");
			end
			
			if cwBeliefs then
				if bShared then
					local valid_players = {};
					
					for k, v in pairs(ents.FindInSphere(sacrificer:GetPos(), 666)) do
						if v:IsPlayer() and v:GetFaction() == "Children of Satan" and !v.cwObserverMode then
							table.insert(valid_players, v);
						end
					end
					
					if #valid_players < 2 then
						sacrificer:HandleXP(killXP);
					else
						local xpPerPlayer = math.Round(killXP / #valid_players);
						
						for i = 1, #valid_players do
							valid_players[i]:HandleXP(xpPerPlayer);
							
							if cwCharacterNeeds then
								valid_players[i]:HandleNeed("corruption", -math.Round(killXP / 10));
							end
						end
					end
				else
					sacrificer:HandleXP(killXP);
				end
			end
			
			if cwCharacterNeeds then
				sacrificer:HandleNeed("corruption", -math.Round(killXP / 10));
			end
		end
		
		if IsValid(player) then
			if IsValid(sacrificer) then
				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." was sacrificed by "..sacrificer:Name().."!");
			else
				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, player:Name().." was sacrificed by a disconnected player!");
			end
			
			player.beingSacrificed = false;
			player:Kill();
		end
		
		if IsValid(self.sacrificialAltarEnt) then
			sound.Play("ambient/fire/ignite.wav", self.sacrificialAltarEnt:GetPos(), 80, 95, 1);
			
			local x = ents.Create("prop_physics");
			
			x:SetModel("models/hunter/blocks/cube025x025x025.mdl");
			x:SetRenderMode(RENDERMODE_TRANSALPHA);
			x:SetPos(self.sacrificialAltarEnt:GetPos() + Vector(0, 0, 24));
			x:SetModelScale(0, 0);
			x:SetColor(Color(255, 255, 255, 0));
			ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN, x, 0);
			
			timer.Simple(5, function()
				if IsValid(x) then
					x:Remove();
				end
			end);
		end
	end);
end

-- A function to add a static prop with an use callback.
function Schema:AddDyn(uniqueID, class, model, position, angles, Callback)
	if (!UNIQUE_DYN_PROPS) then
		UNIQUE_DYN_PROPS = {}
	elseif (IsValid(UNIQUE_DYN_PROPS[uniqueID])) then
		UNIQUE_DYN_PROPS[uniqueID]:Remove()
	end
	
	local entity = ents.Create(class)
	entity:SetModel(model)
	entity:SetPos(position)
	entity:SetAngles(angles)
	entity.OnUse = Callback
	entity:Spawn()
	
	if (IsValid(entity:GetPhysicsObject())) then
		entity:GetPhysicsObject():EnableMotion(false)
	end
	
	UNIQUE_DYN_PROPS[uniqueID] = entity
	return UNIQUE_DYN_PROPS[uniqueID]
end

netstream.Hook("FinishWakeup", function(player)
	if (player.cwWakingUp) then
		Schema:PlayerFinishWakeup(player);
	end;
end);

local coinslotSounds = {"buttons/lever1.wav", "buttons/lever4.wav"};

concommand.Add("cw_CoinslotSalaryCheck", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_coinslot") then
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			
			if (faction == "Gatekeeper" or faction == "Holy Hierarchy") then
				local collectableWages = player:GetCharacterData("collectableWages", 0);
				local coin = player.cwInfoTable.coinslotWages * collectableWages;
				
				Schema:EasyText(player, "olive", "You pull the lever to check your salary. According to the Coinslot's mechanical display, you have "..collectableWages.." collectible salaries, for a total of "..coin.." coin.");
				--Schema:EasyText(player, "lightslateblue", "You have "..collectableWages.." collectible salaries, for a total of "..coin.." coin.");
				entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
			end
		end
	end;
end);

concommand.Add("cw_CoinslotSalary", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_coinslot") then
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			
			if (faction == "Gatekeeper" or faction == "Holy Hierarchy") then
				local collectableWages = player:GetCharacterData("collectableWages", 0);
				local coin = player.cwInfoTable.coinslotWages * collectableWages
				
				if coin <= 0 then
					Schema:EasyText(player, "olive", "You pull the lever to dispense your salary, but you have none available at present.");
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					
					return;
				end
				
				if Schema.towerTreasury >= coin then
					Clockwork.player:GiveCash(player, coin, "Coinslot Salary", true);
					Schema:ModifyTowerTreasury(-coin);
					player:SetCharacterData("collectableWages", 0);
					
					Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has collected their salary of "..coin.." coin from the coinslot. The treasury now sits at "..Schema.towerTreasury..".");
					Schema:EasyText(player, "olivedrab", "You pull the lever to dispense your salary, gaining "..coin.." coin.");
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					
					timer.Simple(0.5, function()
						if IsValid(entity) then
							entity:EmitSound("ambient/levels/labs/coinslot1.wav");
						end
					end);
				else
					Schema:EasyText(player, "olive", "Try as you might, the coinslot won't dispense your salary. How odd.");
					Schema:EasyText(GetAdmins(), "tomato", player:Name().." has attempted to collect his salary, but the treasury is bankrupt!", nil);
				end
			end
		end
	end;
end);

local famine = false;

concommand.Add("cw_CoinslotRation", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_coinslot") then
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			
			if (faction ~= "Goreic Warrior") then
				local unixTime = os.time();
				
				if (unixTime >= player:GetCharacterData("nextration", 0)) then
					if (Schema.towerTreasury and Schema.towerTreasury <= 250) or famine then
						Schema:EasyText(player, "olive", "You pull the ration lever but one is not dispensed, yet you feel as though it has been long enough. How odd.");
						entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
						
						return;
					end
				
					if faction == "Gatekeeper" or faction == "Holy Hierarchy" then
						player:GiveItem(item.CreateInstance("gatekeeper_ration"), true);
						player:GiveItem(item.CreateInstance("purified_water"), true);
						Schema:EasyText(player, "olivedrab", "The machine dispenses a Gatekeeper ration and a bottle of purified water.");
						entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					else
						player:GiveItem(item.CreateInstance("moldy_bread"), true);
						player:GiveItem(item.CreateInstance("dirtywater"), true);
						Schema:EasyText(player, "olivedrab", "The machine dispenses half of a loaf of moldy bread and a bottle of dirty water.");
						entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					end
					
					player:SetCharacterData("nextration", unixTime + 7200);
				else
					Schema:EasyText(player, "olive", "You pull the ration lever but one is not dispensed. You must wait for now.");
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
				end;
			end
		end
	end;
end);

concommand.Add("cw_CoinslotGear", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_coinslot") then
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			
			if (faction == "Gatekeeper") then
				local collectedGear = player:GetCharacterData("collectedGear", false);
				
				if !collectedGear then
					if (Schema.towerTreasury and Schema.towerTreasury <= 250) then
						Schema:EasyText(player, "olive", "You pull the lever to dispense your standard issue Gatekeeper kit, but one is not dispensed. How odd.");
						entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
						
						return;
					end
					
					player:GiveItem(item.CreateInstance("gatekeeper_standard_issue"), true);
					Schema:EasyText(player, "olive", "You pull the lever to dispense your standard issue Gatekeeper kit. A receptacle beneath the machine opens and a crude duffel bag dispenses.");
					entity:EmitSound(coinslotSounds[math.random(#coinslotSounds)]);
					
					timer.Simple(0.5, function()
						if IsValid(entity) then
							entity:EmitSound("physics/cardboard/cardboard_box_impact_soft6.wav");
						end
					end);
					
					player:SetCharacterData("collectedGear", true);
					player:SetLocalVar("collectedGear", true);
				end;
			end
		end
	end;
end);

concommand.Add("cw_CoinslotTreasury", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_coinslot") then
			local faction = player:GetFaction();
			
			if (faction == "Holy Hierarchy" and player:GetSubfaction() == "Minister") or player:IsAdmin() then
				Schema:EasyText(player, "lightslateblue", "The treasury currently sits at "..Schema.towerTreasury.." coin.");
			end
		end
	end;
end);

concommand.Add("cw_HellPortalArch", function(player, cmd, args)
	if not player.teleporting then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_hellportal") then
				local nextTeleport = player:GetCharacterData("nextTeleport", 0);
				
				if nextTeleport <= 0 then
					local origin = player:GetPos();
					local chosenspot = math.random(1, #Schema.hellPortalTeleports["arch"]);
					local destination = Schema.hellPortalTeleports["arch"][chosenspot].pos;
					local angles = Schema.hellPortalTeleports["arch"][chosenspot].ang;
					
					ParticleEffect("teleport_fx", origin, Angle(0,0,0), player);
					sound.Play("misc/summon.wav", origin, 100, 100);
					ParticleEffect("teleport_fx", destination, Angle(0,0,0));
					sound.Play("misc/summon.wav", destination, 100, 100);
					player.teleporting = true;
					
					timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
						if IsValid(player) then
							player.teleporting = false;
							
							if player:Alive() then
								Clockwork.player:SetSafePosition(player, destination);
								player:SetEyeAngles(angles);
								util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
								util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
								
								--player:SetCharacterData("nextTeleport", 1200);
							end
						end
					end);
				else
					Schema:EasyText(player, "peru", "You cannot use the Hellportal for another "..nextTeleport.." seconds!");
				end
			end
		end;
	end;
end);

concommand.Add("cw_HellPortalPillars", function(player, cmd, args)
	if not player.teleporting then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_hellportal") then
				local nextTeleport = player:GetCharacterData("nextTeleport", 0);
				
				if nextTeleport <= 0 then
					local origin = player:GetPos();
					local chosenspot = math.random(1, #Schema.hellPortalTeleports["pillars"]);
					local destination = Schema.hellPortalTeleports["pillars"][chosenspot].pos;
					local angles = Schema.hellPortalTeleports["pillars"][chosenspot].ang;
					
					ParticleEffect("teleport_fx", origin, Angle(0,0,0), player);
					sound.Play("misc/summon.wav", origin, 100, 100);
					ParticleEffect("teleport_fx", destination, Angle(0,0,0));
					sound.Play("misc/summon.wav", destination, 100, 100);
					player.teleporting = true;
					
					timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
						if IsValid(player) then
							player.teleporting = false;
							
							if player:Alive() then
								Clockwork.player:SetSafePosition(player, destination);
								player:SetEyeAngles(angles);
								util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
								util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
								
								--player:SetCharacterData("nextTeleport", 1200);
							end
						end
					end);
				else
					Schema:EasyText(player, "peru", "You cannot use the Hellportal for another "..nextTeleport.." seconds!");
				end
			end
		end;
	end;
end);

concommand.Add("cw_AltarDisembowel", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "disembowel");
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

concommand.Add("cw_AltarDisembowelShared", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "disembowel", true);
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

concommand.Add("cw_AltarDismember", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "dismember");
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

concommand.Add("cw_AltarDismemberShared", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "dismember", true);
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

concommand.Add("cw_AltarFlay", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "flay");
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

concommand.Add("cw_AltarFlayShared", function(player, cmd, args)
	local trace = player:GetEyeTrace();
	
	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_sacrifical_altar") then
			if player:GetFaction() == "Children of Satan" then
				local target = player:GetHoldingEntity();
				local ragdollPlayer;
				
				if IsValid(target) then
					ragdollPlayer = Clockwork.entity:GetPlayer(target);
				end
				
				if IsValid(ragdollPlayer) and ragdollPlayer:IsPlayer() --[[and ragdollPlayer:GetNetVar("tied") == 1]] then
					if !player.sacrificing then
						Schema:SacrificePlayer(ragdollPlayer, player, "flay", true);
					else
						Schema:EasyText(player, "peru", "You are already sacrificing someone!");
					end
				else
					Schema:EasyText(player, "chocolate", "You must be holding a character to sacrifice them!");
				end
			else
				Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
			end
		end
	end
end);

--[[
-- Called when a player drops an item.
function Schema:InvActionExternal(player, arguments)
	local itemAction = string.lower(arguments[1]);
	local itemTable = player:FindItemByID(arguments[2]);

	if (itemAction == "combine") then
		local inventory = player:GetInventory();
		local itemOne = itemTable;
		local itemTwo = player:FindItemByID(arguments[4]);
		local itemOneCount = Clockwork.inventory:GetItemCountByID(inventory, arguments[2]);
		local itemTwoCount = Clockwork.inventory:GetItemCountByID(inventory, arguments[4]);
		
		self:AttemptCombineItems(player, itemOne, itemTwo, itemOneCount, itemTwoCount, itemAction);
		
		return;
	end;

	if (itemTable) then
		local customFunctions = itemTable("customFunctions");
		
		if (customFunctions) then
			for k, v in pairs(customFunctions) do
				if (string.lower(v) == itemAction) then
					if (itemTable.OnCustomFunction) then
						itemTable:OnCustomFunction(player, v);
						return;
					end;
				end;
			end;
		end;
		
		if (itemAction == "destroy") then
			if (Clockwork.plugin:Call("PlayerCanDestroyItem", player, itemTable)) then
				Clockwork.item:Destroy(player, itemTable);
			end;
		elseif (itemAction == "drop") then
			if (itemTable("noDrop")) then
				Schema:EasyText(player, "white", "You cannot drop this!");
				
				return;
			end;
			
			local position = player:GetEyeTraceNoCursor();
			local hitPos = position.HitPos;
			local shootPos = player:GetShootPos();
			local eyeTrace = player:GetEyeTrace();--
			local hitEntity = eyeTrace.Entity;
			local curTime = CurTime();
			local distance = hitPos:Distance(shootPos);
			local playerPosition = player:GetPos();
			local forward = player:GetForward();
			local right = player:GetRight();
			local aimVector = player:GetAimVector();
			
			if (!hitEntity:IsWorld() and IsValid(hitEntity) and hitEntity:IsPlayer() and distance < 100 and (!player.nextUse or player.nextUse < curTime)) then
				player.nextUse = curTime + 0.5;
			
				local uniqueID = itemTable("uniqueID");
				local model = itemTable("model");
				local fakeItem = ents.Create("prop_physics");
				fakeItem:SetModel(model);
				fakeItem:SetPos(playerPosition + Vector(0, 0, 50) + (forward * 20) + (right * 5));
				fakeItem:Spawn();
				fakeItem:SetCollisionGroup(COLLISION_GROUP_WORLD);
				
				local physObj = fakeItem:GetPhysicsObject();
				
				if (IsValid(physObj)) then
					physObj:EnableGravity(false);
					physObj:ApplyForceCenter((aimVector + Vector(0, 0, 0.7)) * 1000);
				end;
				
				fakeItem:Fire("kill", 0.4, 0.4, 0.4);
				player:UpdateInventory(uniqueID, -1);
				player:ViewPunch(Angle(-3, 0, 0));
			
				timer.Simple(0.5, function()
					if (IsValid(hitEntity) and hitEntity:IsPlayer()) then
						hitEntity:UpdateInventory(uniqueID, 1);
						hitEntity:EmitSound("items/ammopickup.wav", 70);
					else
						player:UpdateInventory(uniqueID, 1);
					end;
				end);
			elseif (shootPos:Distance(hitPos) <= 96) or itemTable.OnCreateDropEntity then
				if (Clockwork.plugin:Call("PlayerCanDropItem", player, itemTable, hitPos)) then
					Clockwork.item:Drop(player, itemTable);
				end;
			else
				if (Clockwork.plugin:Call("PlayerCanDropItem", player, itemTable, hitPos)) then
					local bDidDrop, itemEntity = Clockwork.item:Drop(player, itemTable);
					
					if (IsValid(itemEntity)) then
						itemEntity:SetPos(playerPosition + Vector(0, 0, 50) + (forward * 20) + (right * 5));
						
						local strength = Clockwork.attributes:Fraction(player, ATB_STRENGTH, 100);
						local eyeAngles = player:EyeAngles();
						local pitch = eyeAngles.p;
						local force = 1000;
						local z = 0.4;

						if (pitch < -10) then
							force = 1000 + (((90 + strength + pitch) * 10));
						elseif (pitch < 6) then
							force = 500 + (((90 + strength + pitch) * 20)); z = 0;
						end
						
						local physObj = itemEntity:GetPhysicsObject();
						
						if (IsValid(physObj)) then
							physObj:ApplyForceCenter((aimVector + Vector(0, 0, z)) * force);
							player:ViewPunch(Angle(-3, 0, 0));
						end;
					end;
				end;
			end;
		elseif (itemAction == "use") then
			local uniqueID = itemTable("uniqueID");
			local category = itemTable("category");
			local useText = itemTable("useText");
			local name = itemTable("name");
			
			if (player:InVehicle() and itemTable("useInVehicle") == false) then
				Schema:EasyText(player, "white", "You cannot use this item in a vehicle!");
				
				return;
			end;

			if (Clockwork.plugin:Call("PlayerCanUseItem", player, itemTable)) then
				return Clockwork.item:Use(player, itemTable);
			end;
		else
			Clockwork.plugin:Call("PlayerUseUnknownItemFunction", player, itemTable, itemAction);
		end;
	else
		Schema:EasyText(player, "white", "You do not own this item!");
	end;
end;
--]]

concommand.Add("listtraits", function(player)
	if (player:IsAdmin()) then
		local traits = Clockwork.trait:GetAll();
		
		if traits then
			for k, v in pairs (traits) do
				print(k);
			end;
		end;
	end;
end)

--[[for k, v in pairs (ents.GetAll()) do
	if (v.PopeSpeaker) then
		v:Remove();
	end;
end;]]--

Schema.PopeSpeakers = {};
Schema.PopeSpeas = {}

if map == "rp_begotten3" then
	Schema.PopeSpeakers = {
		[1] = {pos = Vector(3.3865439891815, 13294.454101562, -897.51489257812), angles = Angle(-3.2587754109775e-12, -90, 0)},
		[2] = {pos = Vector(-808.76165771484, 12164.58984375, -916.09478759766), angles = Angle(7.2446475901655e-12, -2.1701662262785e-06, 0)},
		[3] = {pos = Vector(-1675.3829345703, 12738.047851562, -914.50402832031), angles = Angle(9.5423404692253e-14, -90, 0)},
		[4] = {pos = Vector(600.44647216797, 12556.758789062, -911.71374511719), angles = Angle(-1.6913425954918e-12, -179.82398986816, 1.52587890625e-05)},
		[5] = {pos = Vector(296.17782592773, 12044.626953125, -911.26635742188), angles = Angle(-1.8273721713581e-17, 90, 0)},
		[6] = {pos = Vector(414.15954589844, 11986.188476562, -915.75244140625), angles = Angle(-5.0500840175174e-16, -134.99964904785, 0)},
		[7] = {pos = Vector(-145.64234924316, 12005.95703125, -917.85662841797), angles = Angle(-2.0930956452503e-06, -90.813941955566, 0)},
		[8] = {pos = Vector(1164.8011474609, 12974.739257812, -914.8076171875), angles = Angle(-1.6792856168124e-12, -90, 0)},
		[9] = {pos = Vector(660.83575439453, 14286.05078125, -971.38537597656), angles = Angle(-8.9436574465807e-13, 90.132041931152, 1.52587890625e-05)},
		[10] = {invisi = true, pos = Vector(-209, 10440, -1017), angles = Angle(0, 0, 0)},
		[11] = {invisi = true, pos = Vector(1798, 11153, -1011), angles = Angle(0, 0, 0)},
		[12] = {invisi = true, pos = Vector(522.658630, 10280.277344, -1256.043457), angles = Angle(0.000, 44.995, 0.000)},
		[13] = {invisi = true, pos = Vector(-2051.974609, 10736.583008, -1096.105469), angles = Angle(0.000, 90.000, 0.000)},
		[14] = {pos = Vector(291.401428, 11712.586914, -923.662231), angles = Angle(0.000, -90.000, 0.000)},
	};
elseif map == "rp_begotten_redux" then
	Schema.PopeSpeakers = {
		[1] = {invisi = true, pos = Vector(-9321, -8423, 433), angles = Angle(0, 0, 0)},
		[2] = {pos = Vector(-13101, -8014, 349), angles = Angle(0, -90, 0)},
		[3] = {pos = Vector(-13587, -8244, -1561), angles = Angle(0, 0, 0)},
		[4] = {pos = Vector(-10592, -9099, 419), angles = Angle(0, 90, 0)},
		[5] = {pos = Vector(-9911.9375, -6918.59375, 345), angles = Angle(0, 45, 0)},
		[6] = {pos = Vector(-11960.25, -3801.125, 618.8125), angles = Angle(0, 135, 0)},
		[7] = {pos = Vector(-12863.3125, -4181, 611.21875), angles = Angle(0, 90, 0)},
	};
elseif map == "rp_scraptown" then
	Schema.PopeSpeakers = {
		[1] = {pos = Vector(-3052.375, -3200.6875, 782.5), angles = Angle(0, 0, 0)},
		[2] = {pos = Vector(-6291.65625, -7075.59375, 436.40625), angles = Angle(0, 180, 0)},
		[3] = {pos = Vector(-3679.96875, -3204.34375, 299.5), angles = Angle(0, 90, 0)},
		[4] = {pos = Vector(-4515.59375, -3717.9375, 756.53125), angles = Angle(0, 180, 0)},
		[5] = {pos = Vector(-4681.53125, -584.875, 289.40625), angles = Angle(0, 180, 0)},
		[6] = {pos = Vector(-4681.59375, -1443.4375, 292.09375), angles = Angle(0, 180, 0)},
		[7] = {pos = Vector(-5337.5625, -1440.875, 297.5), angles = Angle(0, 180, 0)},
		[8] = {pos = Vector(-5337.6875, -583.75, 295.71875), angles = Angle(0, 180, 0)},
		[9] = {pos = Vector(-7500.15625, -1347.65625, 331.0625), angles = Angle(0, -90, 0)},
		[10] = {pos = Vector(-5979.59375, -641.5625, 325.4375), angles = Angle(0, 180, 0)},
		[11] = {pos = Vector(-2699.59375, -1188.09375, 556.625), angles = Angle(0, 180, 0)},
		[12] = {pos = Vector(-5513.625, -6700.34375, 1013.5), angles = Angle(0, 90, 0)},
		[13] = {pos = Vector(-2835.65625, -5897.3125, 357.84375), angles = Angle(0, 180, 0)},
		[14] = {pos = Vector(-3505.53125, -4947.625, 384.625), angles = Angle(0, -90, 0)},
		[15] = {pos = Vector(-5583.21875, -2887.65625, 314.625), angles = Angle(0, 90, 0)},
	};
end

function Schema:LoadPopeSpeakers()
	table.Empty(self.PopeSpeas)
	
	for i = 1, #self.PopeSpeakers do
		local v = self.PopeSpeakers[i];
	
		for k, v in pairs (ents.FindInSphere(v.pos, 32)) do
			if (v:GetModel() != "models/props_wasteland/speakercluster01a.mdl") then
				continue
			end;
			v:Remove();
		end;
	
		local speaker = ents.Create("prop_physics");
		speaker:SetPos(v.pos);
		speaker:SetAngles(v.angles);
		speaker:SetModel("models/props_wasteland/speakercluster01a.mdl");
		speaker.PopeSpeaker = true;
		speaker:Spawn();
		speaker:SetRenderMode(RENDERMODE_TRANSALPHA);
		
		if (v.invisi) then
			speaker:SetColor(Color(0, 0, 0, 0));
		end;

		local physObj = speaker:GetPhysicsObject();
		
		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
		end;
		
		self.PopeSpeas[#self.PopeSpeas + 1] = speaker;
	end;
end;
Schema:LoadPopeSpeakers()
function Schema:GetPopeSpeakers()
	return self.PopeSpeas;
end;

function Schema:EmitSoundFromSpeakers(sound, level, pitch)
	for k, v in pairs (self.PopeSpeas) do
		v:EmitSound(sound, level, pitch);
	end;
end;

function Schema:SpeakerTalk(player, text)
	for k, v in pairs (_player.GetAll()) do
		if (self:InSpeakerZone(v)) then
			Clockwork.chatBox:SetMultiplier(1.35);
			Clockwork.chatBox:Add(v, player, "speaker", text);
		end;
	end;
	
	self:EmitSoundFromSpeakers("damnation/apocalypt/speaker"..math.random(1, 5)..".mp3", 100, math.random(80, 120))
end;

-- A function to get whether an entity is inside the tower of light.
function Schema:InSpeakerZone(entity)
	if map == "rp_begotten3" then
		return entity:GetPos():WithinAABox(Vector(2400, 15147, -2778), Vector(-2426, 9867, 960));
	elseif map == "rp_begotten_redux" or map == "rp_scraptown" then
		return entity:InTower();
	end
end;

function Schema:SpeakerPerform(player, text)
	for k, v in pairs (_player.GetAll()) do
		if (self:InSpeakerZone(v)) then
			Clockwork.chatBox:SetMultiplier(1.35);
			Clockwork.chatBox:Add(v, player, "speakerit", text);
		end;
	end;
	
	self:EmitSoundFromSpeakers("damnation/apocalypt/speaker"..math.random(1, 5)..".mp3", 100, math.random(80, 120))
end;