--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local camTable = {};
local subfactionCamTable = {};
local map = string.lower(game.GetMap());

if map == "rp_begotten3" then
	camTable = {
		["Wanderer"] = {
			camVector = Vector(-14977.675781, 12599.680664, -1175),
			camAngles = Angle(2.5, -177.732, 0),
			closeCamVector = Vector(-15000, 12599.680664, -1185),
			charVector = Vector(-15050.21875, 12597, -1235),
			charAngles = Angle(0, 0, 0),
			charModel = {clothes = "models/begotten/wanderers/wanderer_male.mdl", head = "models/begotten/heads/male_04_wanderer.mdl"},
			charBodygroup = {1, 2},
			zone = "wasteland"
		},
		["The Third Inquisition"] = {
			camVector = Vector(-14977.675781, 12599.680664, -1175),
			camAngles = Angle(2.5, -177.732, 0),
			closeCamVector = Vector(-15000, 12599.680664, -1185),
			charVector = Vector(-15050.21875, 12597, -1235),
			charAngles = Angle(0, 0, 0),
			charModel = {clothes = "models/begotten/wanderers/wanderer_male.mdl", head = "models/begotten/heads/male_04_wanderer.mdl"},
			charBodygroup = {1, 2},
			zone = "wasteland"
		},
		["Gatekeeper"] = {
			camVector = Vector(785, 12221.802734, -1025),
			camAngles = Angle(0, 0, 0),
			closeCamVector = Vector(808, 12221.802734, -1035),
			charVector = Vector(858.125, 12222, -1080.75),
			charAngles = Angle(0, 180, 0),
			charModel = {clothes = "models/begotten/gatekeepers/gatekeepermedium_male.mdl", head = "models/begotten/heads/male_02_glaze.mdl"},
			charBodygroup = {1, 4},
			zone = "tower"
		},
		["Holy Hierarchy"] = {
			camVector = Vector(2101.481935, 13680, 358),
			camAngles = Angle(2.5, 90, 0),
			closeCamVector = Vector(2101.481935, 13703, 350),
			charVector = Vector(2100.625, 13748.0625, 298.28125),
			charAngles = Angle(0, -90, 0),
			charModel = {clothes = "models/begotten/gatekeepers/minister_male.mdl", head = "models/begotten/heads/male_11_wanderer.mdl"},
			zone = "tower"
		},
		["Goreic Warrior"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4826, -11908, 12045),
			camAngles = Angle(0, -18.286, 0),
			closeCamVector = Vector(-4800, -11917.5, 12040),
			charVector = Vector(-4754.8125, -11932.0625, 11989),
			charAngles = Angle(0, 158, 0),
			charModel = {clothes = "models/begotten/goreicwarfighters/warfighter_male.mdl", head = "models/begotten/heads/male_91_gore.mdl"},
			charBodygroup = {1, 4},
			charLight = Vector(-4826, -11908, 12040),
			zone = "gore"
		},
		["Children of Satan"] = {
			camVector = Vector(-7369, -10177.395508, -6990),
			camAngles = Angle(0, -90, 0),
			closeCamVector = Vector(-7369, -10200, -6996),
			charVector = Vector(-7368.25, -10245, -7044.90625),
			charAngles = Angle(0, 90, 0),
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			charModelOverride = {clothes = "models/begotten/wanderers/wanderer_male.mdl", head = "models/begotten/heads/male_13_wanderer.mdl"},
			zone = "hell"
		},
	};

	subfactionCamTable = {
		["Varazdat"] = {
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Rekh-khet-sa"] = {
			charModel = "models/begotten/satanists/wraitharmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Philimaxio"] = {
			charModel = "models/begotten/satanists/hellspike_armor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Kinisger"] = {
			charModel = {clothes = "models/begotten/satanists/elegantrobes_male.mdl", head = "models/begotten/heads/male_07_satanist.mdl"},
			charBodygroup = {1, 1},
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Clan Gore"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Harald"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 1,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Reaver"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 2,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Shagalax"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 3,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Crast"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 4,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Grock"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 5,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Legionary"] = {
			charModel = {clothes = "models/begotten/gatekeepers/gatekeepermedium_male.mdl", head = "models/begotten/heads/male_02_glaze.mdl"},
			charBodygroup = {1, 4},
			camVector = Vector(804, 12202, -1033),
			camAngles = Angle(0, 0, 0),
		},
		["Auxiliary"] = {
			charModel = {clothes = "models/begotten/gatekeepers/gatekeeperlight_black_male.mdl", head = "models/begotten/heads/male_04_glaze.mdl"},
			camVector = Vector(804, 12202, -1033),
			camAngles = Angle(0, 0, 0),
		},
		["Praeventor"] = {
			charModel = {clothes = "models/begotten/wanderers/brigandine_male.mdl", head = "models/begotten/heads/male_04_wanderer.mdl"},
			charBodygroup = {1, 2},
			camVector = Vector(804, 12202, -1033),
			camAngles = Angle(0, 0, 0),
		},
		["Ministry"] = {
			charModel = {clothes = "models/begotten/gatekeepers/minister_male.mdl", head = "models/begotten/heads/male_11_wanderer.mdl"},
			camVector = Vector(2120, 13695, 350),
			camAngles = Angle(2.5, 90, 0),
		},
		["Inquisition"] = {
			charModel = {clothes = "models/begotten/gatekeepers/inquisitor_male.mdl", head = "models/begotten/heads/male_07_glaze.mdl"},
			charBodygroup = {1, 1},
			camVector = Vector(2120, 13695, 350),
			camAngles = Angle(2.5, 90, 0),
		},
		["Knights of Sol"] = {
			charModel = {clothes = "models/begotten/gatekeepers/knight_set.mdl", head = "models/begotten/heads/male_09_glaze.mdl"},
			camVector = Vector(2120, 13695, 350),
			camAngles = Angle(2.5, 90, 0),
		},
	};
elseif map == "rp_begotten_redux" then
	camTable = {
		["Wanderer"] = {
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
			closeCamVector = Vector(-1754, -4537.384277, 1013),
			charVector = Vector(-1707.96875, -4539.65625, 957.3125),
			charAngles = Angle(0, 177, 0),
			charModel = "models/begotten/wanderers/wanderer/male_04.mdl",
			charBodygroup = {1, 5},
			zone = "wasteland"
		},
		["Gatekeeper"] = {
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
			closeCamVector = Vector(-1754, -4537.384277, 1013),
			charVector = Vector(-1707.96875, -4539.65625, 957.3125),
			charAngles = Angle(0, 177, 0),
			charModel = "models/begotten/gatekeepers/gatekeepermedium/male_02.mdl",
			charBodygroup = {1, 6},
			zone = "tower"
		},
		["Pope Adyssa's Gatekeepers"] = {
			camVector = Vector(-13022.375000, -4546.860840, 539.218750),
			camAngles = Angle(10.583, -89.668, 0),
			closeCamVector = Vector(-13021.983398, -4559.194824, 530.259644),
			charVector = Vector(-13021.65625, -4603.75, 475.0625),
			charAngles = Angle(0, 90, 0),
			charModel = "models/srp/stalker_bandit_veteran2.mdl",
			zone = "wasteland"
		},
		["Holy Hierarchy"] = {
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
			closeCamVector = Vector(-1754, -4537.384277, 1013),
			charVector = Vector(-1707.96875, -4539.65625, 957.3125),
			charAngles = Angle(0, 177, 0),
			charModel = "models/begotten/gatekeepers/gatekeeperlight/male_07.mdl",
			zone = "tower"
		},
		["Goreic Warrior"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4826, -11908, 12045),
			camAngles = Angle(0, -18.286, 0),
			closeCamVector = Vector(-4800, -11917.5, 12040),
			charVector = Vector(-4754.8125, -11932.0625, 11989),
			charAngles = Angle(0, 158, 0),
			charModel = "models/begotten/goreicwarfighters/warfighter/male_91.mdl",
			charBodygroup = {1, 4},
			charLight = Vector(-4826, -11908, 12040),
			zone = "gore"
		},
		["Children of Satan"] = {
			camVector = Vector(-7369, -10177.395508, -6990),
			camAngles = Angle(0, -90, 0),
			closeCamVector = Vector(-7369, -10200, -6996),
			charVector = Vector(-7368.25, -10245, -7044.90625),
			charAngles = Angle(0, 90, 0),
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			zone = "hell"
		},
	};

	subfactionCamTable = {
		["Varazdat"] = {
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Rekh-khet-sa"] = {
			charModel = "models/begotten/satanists/wraitharmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Philimaxio"] = {
			charModel = "models/begotten/satanists/hellspike_armor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Kinisger"] = {
			charModel = "models/begotten/satanists/elegantrobes/male_07.mdl",
			charBodygroup = {1, 7},
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Clan Gore"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Harald"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 1,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Reaver"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 2,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Shagalax"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 3,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Crast"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 4,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Grock"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 5,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Ministry"] = {
			charModel = "models/begotten/gatekeepers/minister/male_11.mdl",
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
		["Inquisition"] = {
			charModel = "models/begotten/gatekeepers/inquisitor/male_07.mdl",
			charBodygroup = {1, 1},
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
		["Knights of Sol"] = {
			charModel = "models/begotten/gatekeepers/knight_set.mdl",
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
	};
elseif map == "rp_scraptown" then
	camTable = {
		["Wanderer"] = {
			camVector = Vector(-3218.550537, 11165.052734, 1328),
			camAngles = Angle(0, 90, 0),
			closeCamVector = Vector(-3217.906494, 11183.276367, 1320),
			charVector = Vector(-3218.34375, 11223.78125, 1266.03125),
			charAngles = Angle(0, -90, 0),
			charModel = "models/begotten/wanderers/wanderer/male_04.mdl",
			charBodygroup = {1, 5},
			charLight = Vector(-3217, 11149, 1325),
			zone = "wasteland"
		},
		["Gatekeeper"] = {
			camVector = Vector(-3218.550537, 11165.052734, 1328),
			camAngles = Angle(0, 90, 0),
			closeCamVector = Vector(-3217.906494, 11183.276367, 1320),
			charVector = Vector(-3218.34375, 11223.78125, 1266.03125),
			charAngles = Angle(0, -90, 0),
			charModel = "models/begotten/gatekeepers/gatekeepermedium/male_02.mdl",
			charBodygroup = {1, 6},
			zone = "tower"
		},
		["Smog City Pirate"] = {
			camVector = Vector(-4631.589355, -2668.765869, 999.081116),
			camAngles = Angle(0, -135, 0),
			closeCamVector = Vector(-4645.821777, -2682.774414, 991),
			charVector = Vector(-4673.09375, -2710.25, 936.25),
			charAngles = Angle(0, 45, 0),
			charModel = "models/begotten/wanderers/scrappergrunt/male_04.mdl",
			charLight = Vector(-4587, -2711, 1010),
			zone = "wasteland"
		},
		["The Third Inquisition"] = {
			camVector = Vector(-3218.550537, 11165.052734, 1328),
			camAngles = Angle(0, 90, 0),
			closeCamVector = Vector(-3217.906494, 11183.276367, 1320),
			charVector = Vector(-3218.34375, 11223.78125, 1266.03125),
			charAngles = Angle(0, -90, 0),
			charModel = "models/begotten/gatekeepers/minister/male_06.mdl",
			charLight = Vector(-3217, 11149, 1325),
			zone = "wasteland"
		},
		["Holy Hierarchy"] = {
			camVector = Vector(-3218.550537, 11165.052734, 1328),
			camAngles = Angle(0, 90, 0),
			closeCamVector = Vector(-3217.906494, 11183.276367, 1320),
			charVector = Vector(-3218.34375, 11223.78125, 1266.03125),
			charAngles = Angle(0, -90, 0),
			charModel = "models/begotten/gatekeepers/gatekeeperlight/male_07.mdl",
			charLight = Vector(-3217, 11149, 1325),
			zone = "tower"
		},
		["Goreic Warrior"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4826, -11908, 12045),
			camAngles = Angle(0, -18.286, 0),
			closeCamVector = Vector(-4800, -11917.5, 12040),
			charVector = Vector(-4754.8125, -11932.0625, 11989),
			charAngles = Angle(0, 158, 0),
			charModel = "models/begotten/goreicwarfighters/warfighter/male_91.mdl",
			charBodygroup = {1, 4},
			charLight = Vector(-4826, -11908, 12040),
			zone = "gore"
		},
		["Children of Satan"] = {
			camVector = Vector(-7369, -10177.395508, -6990),
			camAngles = Angle(0, -90, 0),
			closeCamVector = Vector(-7369, -10200, -6996),
			charVector = Vector(-7368.25, -10245, -7044.90625),
			charAngles = Angle(0, 90, 0),
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			zone = "hell"
		},
	};

	subfactionCamTable = {
		["Varazdat"] = {
			charModel = "models/begotten/satanists/dreadarmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Rekh-khet-sa"] = {
			charModel = "models/begotten/satanists/wraitharmor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Philimaxio"] = {
			charModel = "models/begotten/satanists/hellspike_armor.mdl",
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Kinisger"] = {
			charModel = "models/begotten/satanists/elegantrobes/male_07.mdl",
			charBodygroup = {1, 7},
			camVector = Vector(-7390, -10185, -6996),
			camAngles = Angle(0, -90, 0),
		},
		["Clan Gore"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 0,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Harald"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 1,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Reaver"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 2,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Shagalax"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 3,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Crast"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 4,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Clan Grock"] = {
			bannerAngles = Angle(0, 0, 0),
			bannerVector = Vector(-4640.78125, -11843.53125, 11978.96875),
			bannerModel = "models/begotten/misc/banner_b.mdl",
			bannerSkin = 5,
			camVector = Vector(-4720, -11900, 12044.962891),
			camAngles = Angle(-0.87, 1.681, 0),
		},
		["Ministry"] = {
			charModel = "models/begotten/gatekeepers/minister/male_11.mdl",
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
		["Inquisition"] = {
			charModel = "models/begotten/gatekeepers/inquisitor/male_07.mdl",
			charBodygroup = {1, 1},
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
		["Knights of Sol"] = {
			charModel = "models/begotten/gatekeepers/knight_set.mdl",
			camVector = Vector(-1771.079224, -4537.384277, 1021.419922),
			camAngles = Angle(8.638, -2.212, 0),
		},
		["Machinists"] = {
			charModel = "models/begotten/wanderers/scrappergrunt/male_04.mdl",
			camVector = Vector(-4645.47998, -2658.353027, 993.994873),
			camAngles = Angle(0, -135, 0),
		},
		["Voltists"] = {
			charModel = "models/begotten/wanderers/voltist_heavy.mdl",
			camVector = Vector(-4645.47998, -2658.353027, 993.994873),
			camAngles = Angle(0, -135, 0),
		},
	};
end

-- Called when the character background should be drawn.
function cwMapScene:ShouldDrawCharacterBackground()
	if (self.curStored) then return false end
end

-- Called when the view should be calculated.
function cwMapScene:CalcView(player, origin, angles, fov)
	if (Clockwork.kernel:IsChoosingCharacter()) then
		local curTime = CurTime();
		
		if (Clockwork.quiz:GetEnabled() and (!Clockwork.quiz:GetCompleted() or Clockwork.quiz.IntroTransition)) then
			if not Clockwork.Client.BlackDelay then
				Clockwork.Client.BlackDelay = curTime + 1;
				return;
			elseif Clockwork.Client.BlackDelay > curTime then
				return;
			end
			
			Clockwork.Client.MenuVector = Vector(-7640, -9132, -6845);
			Clockwork.Client.MenuAngles = Angle(0, 180, 0);
		
			return {
				vm_origin = Clockwork.Client.MenuVector + Vector(0, 0, 2048),
				vm_angles = Angle(0, 0, 0),
				origin = Clockwork.Client.MenuVector,
				angles = Clockwork.Client.MenuAngles,
				fov = 90
			}
		end
	
		local addAngles = Angle(0, 0, 0)
		local faction = Clockwork.Client.SelectedFaction;
		local subfaction = Clockwork.Client.SelectedSubfaction;

		if faction and camTable[faction] then
			local model_path = "";
			local head_path;
			
			if Clockwork.Client.ModelSelectionOpen and Clockwork.Client.SelectedModel then
				local charModel = camTable[faction].charModelOverride or camTable[faction].charModel;
				
				if istable(charModel) then
					model_path = charModel.clothes;
					
					if subfaction then
						local factionTable = Clockwork.faction:FindByID(faction);
						
						if factionTable and factionTable.subfactions then
							for i, v in ipairs(factionTable.subfactions) do
								if v.name == subfaction and v.models then
									model_path = v.models[string.lower(player:GetGender())].clothes;
								
									break;
								end
							end
						end
					end
					
					head_path = Clockwork.Client.SelectedModel;
				else
					model_path = charModel;
				end
			elseif subfaction and subfactionCamTable[subfaction] and subfactionCamTable[subfaction].charModel then
				local charModel = subfactionCamTable[subfaction].charModel;

				if istable(charModel) then
					model_path = charModel.clothes;
					head_path = charModel.head;
				else
					model_path = charModel;
				end
			else
				local charModel = camTable[faction].charModel;
				
				if istable(charModel) then
					model_path = charModel.clothes;
					head_path = charModel.head;
				else
					model_path = charModel;
				end
			end
			
			if camTable[faction].charLight and not IsValid(Clockwork.Client.CreationDynamicLight) then
				local dynamicLight = DynamicLight(1);

				if (dynamicLight) then
					dynamicLight.pos = camTable[faction].charLight;
					dynamicLight.r = 200;
					dynamicLight.g = 200;
					dynamicLight.b = 200;
					dynamicLight.brightness = 0.5;
					dynamicLight.Decay = 0;
					dynamicLight.Size = 100;
					dynamicLight.DieTime = curTime + 0.5;
				end;
				
				Clockwork.Client.CreationDynamicLight = dynamicLight;
			end
			
			if (!IsValid(Clockwork.Client.CharSelectionModel)) then
				local modelEnt = ClientsideModel(model_path, RENDERGROUP_OPAQUE);
				
				modelEnt:SetPos(camTable[faction].charVector);
				modelEnt:SetAngles(camTable[faction].charAngles);
				modelEnt:ResetSequence(modelEnt:LookupSequence("idle_subtle"));
				
				if head_path then
					modelEnt.HeadModel = ClientsideModel(head_path, RENDERGROUP_OPAQUE);
				
					modelEnt.HeadModel:SetParent(modelEnt);
					modelEnt.HeadModel:AddEffects(EF_BONEMERGE);
					modelEnt.HeadModel:SetEyeTarget(camTable[faction].camVector);
				else
					modelEnt:SetEyeTarget(camTable[faction].camVector);
				end
				
				if (!Clockwork.Client.ModelSelectionOpen) then
					if modelEnt.HeadModel then
						modelEnt.HeadModel:SetSkin(0);
					else
						modelEnt:SetSkin(0);
					end
				
					if subfaction and subfactionCamTable[subfaction] and subfactionCamTable[subfaction].charBodygroup then
						if modelEnt.HeadModel then
							modelEnt.HeadModel:SetBodygroup(subfactionCamTable[subfaction].charBodygroup[1], subfactionCamTable[subfaction].charBodygroup[2]);
						else
							modelEnt:SetBodygroup(subfactionCamTable[subfaction].charBodygroup[1], subfactionCamTable[subfaction].charBodygroup[2]);
						end
					elseif camTable[faction].charBodygroup then
						if modelEnt.HeadModel then
							modelEnt.HeadModel:SetBodygroup(camTable[faction].charBodygroup[1], camTable[faction].charBodygroup[2]);
						else
							modelEnt:SetBodygroup(camTable[faction].charBodygroup[1], camTable[faction].charBodygroup[2]);
						end
					end
				end
				
				Clockwork.Client.CharSelectionModel = modelEnt;
			elseif (subfaction and subfactionCamTable[subfaction] and subfactionCamTable[subfaction].charModel and (Clockwork.Client.CharSelectionModel:GetModel() != model_path or (head_path and (!IsValid(Clockwork.Client.CharSelectionModel.HeadModel) or Clockwork.Client.CharSelectionModel.HeadModel:GetModel() != head_path)))) or (Clockwork.Client.CharSelectionModel:GetModel() != model_path or (head_path and (!IsValid(Clockwork.Client.CharSelectionModel.HeadModel) or Clockwork.Client.CharSelectionModel.HeadModel:GetModel() != head_path))) then
				if IsValid(Clockwork.Client.CharSelectionModel.HeadModel) then
					Clockwork.Client.CharSelectionModel.HeadModel:Remove();
				end
				
				Clockwork.Client.CharSelectionModel:Remove();
				
				local modelEnt = ClientsideModel(model_path, RENDERGROUP_OPAQUE);
				
				modelEnt:SetPos(camTable[faction].charVector);
				modelEnt:SetAngles(camTable[faction].charAngles);
				modelEnt:ResetSequence(modelEnt:LookupSequence("idle_subtle"));
				
				local panel = Clockwork.character:GetActivePanel();
				
				if head_path then
					modelEnt.HeadModel = ClientsideModel(head_path, RENDERGROUP_OPAQUE);
				
					modelEnt.HeadModel:SetParent(modelEnt);
					modelEnt.HeadModel:AddEffects(EF_BONEMERGE);
					
					if panel.info and panel.info and table.HasValue(panel.info.traits, "leper") and faction ~= "Goreic Warrior" then
						modelEnt.HeadModel:SetSkin(modelEnt.HeadModel:SkinCount() - 1);
					end
				else
					modelEnt:SetEyeTarget(camTable[faction].camVector);
					
					if panel.info and panel.info and table.HasValue(panel.info.traits, "leper") and faction ~= "Goreic Warrior" then
						modelEnt:SetSkin(modelEnt:SkinCount() - 1);
					end
				end
				
				if (!Clockwork.Client.ModelSelectionOpen) then
					if modelEnt.HeadModel then
						modelEnt.HeadModel:SetSkin(0);
					else
						modelEnt:SetSkin(0);
					end
				
					if subfaction and subfactionCamTable[subfaction] and subfactionCamTable[subfaction].charBodygroup then
						if modelEnt.HeadModel then
							modelEnt.HeadModel:SetBodygroup(subfactionCamTable[subfaction].charBodygroup[1], subfactionCamTable[subfaction].charBodygroup[2]);
						else
							modelEnt:SetBodygroup(subfactionCamTable[subfaction].charBodygroup[1], subfactionCamTable[subfaction].charBodygroup[2]);
						end
					elseif camTable[faction].charBodygroup then
						if modelEnt.HeadModel then
							modelEnt.HeadModel:SetBodygroup(camTable[faction].charBodygroup[1], camTable[faction].charBodygroup[2]);
						else
							modelEnt:SetBodygroup(camTable[faction].charBodygroup[1], camTable[faction].charBodygroup[2]);
						end
					end
				end
				
				Clockwork.Client.CharSelectionModel = modelEnt;
			end;
			
			if camTable[faction].bannerModel and (!subfaction) then
				if (!IsValid(Clockwork.Client.CharSelectionBanner)) then
					local bannerEnt = ClientsideModel(camTable[faction].bannerModel, RENDERGROUP_OPAQUE);
					
					bannerEnt:SetPos(camTable[faction].bannerVector);
					bannerEnt:SetAngles(camTable[faction].bannerAngles);
					bannerEnt:SetSkin(camTable[faction].bannerSkin);
					
					Clockwork.Client.CharSelectionBanner = bannerEnt;
				elseif Clockwork.Client.CharSelectionBanner:GetSkin() ~= camTable[faction].bannerSkin then
					Clockwork.Client.CharSelectionBanner:SetSkin(camTable[faction].bannerSkin);
				end
			elseif subfactionCamTable[subfaction] and subfactionCamTable[subfaction].bannerModel then
				if (!IsValid(Clockwork.Client.CharSelectionBanner)) then
					local bannerEnt = ClientsideModel(subfactionCamTable[subfaction].bannerModel, RENDERGROUP_OPAQUE);
					
					bannerEnt:SetPos(subfactionCamTable[subfaction].bannerVector);
					bannerEnt:SetAngles(subfactionCamTable[subfaction].bannerAngles);
					bannerEnt:SetSkin(subfactionCamTable[subfaction].bannerSkin);
					
					Clockwork.Client.CharSelectionBanner = bannerEnt;
				elseif Clockwork.Client.CharSelectionBanner:GetSkin() ~= subfactionCamTable[subfaction].bannerSkin then
					Clockwork.Client.CharSelectionBanner:SetSkin(subfactionCamTable[subfaction].bannerSkin);
				end
			end

			local activePanel = Clockwork.character:GetActivePanel();
			local camAngles = nil;
			local camVector = nil;
			local frameTime = FrameTime();
			local uniqueID = nil;
			
			if (IsValid(activePanel)) then
				if (activePanel.uniqueID != "") then
					uniqueID = activePanel.uniqueID;
				end;
			end;

			if Clockwork.Client.ModelSelectionOpen then
				camAngles = camTable[faction].camAngles;
				camVector = camTable[faction].closeCamVector;
			elseif subfaction then
				if subfactionCamTable[subfaction] and subfactionCamTable[subfaction].camVector and subfactionCamTable[subfaction].camAngles then
					camAngles = subfactionCamTable[subfaction].camAngles;
					camVector = subfactionCamTable[subfaction].camVector;
				else
					camAngles = camTable[faction].camAngles;
					camVector = camTable[faction].closeCamVector;
				end
			else
				camAngles = camTable[faction].camAngles;
				camVector = camTable[faction].camVector;
			end
			
			if (!Clockwork.Client.MenuVector) then Clockwork.Client.MenuVector = Vector(camVector); end;
			if (!Clockwork.Client.MenuAngles) then Clockwork.Client.MenuAngles = Angle(camAngles); end;
			
			if (uniqueID and uniqueID ~= "cwCharacterStageOne") or Clockwork.Client.MenuCameraMoving then
				Clockwork.Client.MenuCameraMoving = true;
				Clockwork.Client.MenuVector = LerpVector(frameTime, Clockwork.Client.MenuVector, camVector);
				Clockwork.Client.MenuAngles = LerpAngle(frameTime, Clockwork.Client.MenuAngles, camAngles);
				
				if Clockwork.Client.MenuVector == camVector and Clockwork.ClientMenuAngles == camAngles then
					Clockwork.Client.MenuCameraMoving = false;
				end
			else
				Clockwork.Client.MenuVector = Vector(camVector);
				Clockwork.Client.MenuAngles = Angle(camAngles);
			end
			
			return {
				vm_origin = Clockwork.Client.MenuVector + Vector(0, 0, 2048),
				vm_angles = Angle(0, 0, 0),
				origin = Clockwork.Client.MenuVector,
				angles = Clockwork.Client.MenuAngles + addAngles,
				fov = 90
			}
		else
			if (IsValid(Clockwork.Client.CharSelectionModel)) then
				if IsValid(Clockwork.Client.CharSelectionModel.HeadModel) then
					Clockwork.Client.CharSelectionModel.HeadModel:Remove();
				end
				
				Clockwork.Client.CharSelectionModel:Remove();
			end;
			
			if self.curStored then
				if (self.curStored.shouldSpin) then
					addAngles = Angle(0, math.sin(curTime * 0.2) * 180, 0)
				end

				return {
					vm_origin = self.curStored.position + Vector(0, 0, 2048),
					vm_angles = Angle(0, 0, 0),
					origin = self.curStored.position,
					angles = self.curStored.angles + addAngles,
					fov = 90
				}
			end
		end
	end
end