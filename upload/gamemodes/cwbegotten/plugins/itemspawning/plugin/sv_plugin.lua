--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

cwItemSpawner.Categories = {"city", "industrial", "mines", "rituals", "supermarket"};
cwItemSpawner.ContainerLifetime = 1200; -- 20 Minutes.
cwItemSpawner.ItemLifetime = 1800; -- 30 Minutes.
cwItemSpawner.MaxContainers = 50;
cwItemSpawner.MaxGroundSpawns = 100;
cwItemSpawner.MaxSuperCrates = 1;
cwItemSpawner.SuperCrateCooldown = 3600; -- 1 Hour.

cwItemSpawner.LocationsToCategories = {
	["city"] = {"Armor", "Charms", "City Junk", "Communication", "Drinks", "Firearms", "Food", "Helms", "Junk", "Medical", "Melee", "Rituals", "Shot"},
	["industrial"] = {"Communication", "Crafting Materials", "Industrial Junk", "Junk", "Medical", "Repair Kits"},
	["mines"] =  {"Crafting Materials", "Industrial Junk", "Mine Rituals", "Rituals"},
	["rituals"] = {"Rituals"},
	["supermarket"] = {"City Junk", "Drinks", "Food", "Medical"}
};

if (game.GetMap() == "rp_begotten3") then
	if not cwItemSpawner.ContainerLocations then
		cwItemSpawner.ContainerLocations = {
			["city"] = {
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-4186.96875, 1680.53125, -1508.34375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-4030.9375, 1322.09375, -1538.15625), angles = Angle(0, 66, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(1136.15625, -3447.65625, -1796.625), angles = Angle(-28.982, -6.119, 13.079)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1597.03125, -5208.9375, -1697.28125), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1599.4375, -5845.96875, -1505.125), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1713.96875, -5497.84375, -1313.09375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1276, -5664.0625, -1120.875), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1483.28125, -5364.90625, -929.09375), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1536.46875, -5209.0625, -737.09375), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1714.03125, -5721.53125, -545.125), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1605.25, -5845.96875, -353.125), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1366.625, -5845.96875, -161.15625), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(1283.09375, -5569, -169.65625), angles = Angle(0, -22.434, -0.044)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(1291.65625, -5229.40625, -190.96875), angles = Angle(-0.033, -90.132, 0.170)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(1715.125, -5557, -1127.90625), angles = Angle(0.165, -179.775, -20.012)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(13237.4375, 7450.34375, -1947.8125), angles = Angle(0, 90, 0)}, -- Sunken Airplane
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3927.9375, -7540.6875, -1359.09375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3927.9375, -7540.6875, -1231.15625), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3927.9375, -7540.6875, -1103.09375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3381.96875, -7531.875, -1359.09375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3381.96875, -7531.875, -1231.15625), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3381.96875, -7531.875, -1103.09375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3813.96875, -7632.3125, -1103.59375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-4321.3125, -7101.53125, -1370.28125), angles = Angle(2.571, -45.005, 8.899)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-2803.09375, -5457.8125, -2043.03125), angles = Angle(-78.415, 165.322, -95.554)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-2684.40625, -5145.34375, -2032.84375), angles = Angle(-2.972, 118.691, 37.82)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3020.75, -3715.3125, -1899.375), angles = Angle(6.779, -23.329, -6.932)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-471.8125, -2786.125, -1610.15625), angles = Angle(0, -135, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-961.03125, -3274.28125, -1589.8125), angles = Angle(-0.56, 22.906, 1.373)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-469.0625, -3248.625, -1581.59375), angles = Angle(0, -180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-769.09375, -2933.125, -1849.03125), angles = Angle(-24.725, 122.141, 11.733)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(636.90625, -3451.90625, -1849.25), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(655.34375, -2840.78125, -1725.65625), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(1115.875, -3206.96875, -1597.75), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1116.96875, -3078.21875, -1717.125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(1442.875, -3517.375, -1837.25), angles = Angle(4.433, 81.76, -20.319)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1425.0625, -2982.53125, -1849.09375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(918, -3400.90625, -1873.375), angles = Angle(-33.799, -160.208, -0.961)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-403.03125, -2856.375, -1886.84375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3280.84375, 1337.59375, -1674.15625), angles = Angle(0, 113.725, -90.044)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-3583.625, 1510.34375, -1672.09375), angles = Angle(0.016, 105.09, -0.027)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-4101.5, 1866, -1786.78125), angles = Angle(-4.839, -3.038, -3.549)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3531.53125, 1538.34375, -1778.09375), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-4184.1875, 1653.15625, -1786.75), angles = Angle(-0.016, 12.025, -0.022)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-3835.71875, 2069.84375, -1806.21875), angles = Angle(0, 90, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-3657.875, -1782.3125, -1857.40625), angles = Angle(0, 180, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-3657.375, -419.03125, -1857.4375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-19.1875, -5930.5, -1759.25), angles = Angle(-5.674, -177.984, -3.730)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(1484.90625, -5628.03125, -1513.78125), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(3167.0625, -4640.875, -1952.625), angles = Angle(7.581, 175.847, -9.673)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-5034.9375, -14043.03125, -720.1875), angles = Angle(0, 90, 0)}, -- Papa Pete's Shack
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(468.5, 133, -1843), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(467.1875, -679.125, -1889.75), angles = Angle(-77.596, 66.561, 38.013)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(209.34375, -1462.1875, -1893.625), angles = Angle(-85.995, 116.785, 61.337)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(3058.8125, -5104.4375, -2034.75), angles = Angle(4.197, 93.19,2 -0.066)},
			},
			["industrial"] = {
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6010.84375, 8679.8125, -1452.6875), angles = Angle(1.417, -151.414, 12.508)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6109.5, 10321.90625, -1726.53125), angles = Angle(3.115, -145.168, -0.489)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6084.125, -10381, -1018.96875), angles = Angle(14.656, 102.107, 4.653)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(7893, -10465.25, -933.875), angles = Angle(-4.642, -87.056, 3.235)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11212, 2750, -1172), angles = Angle(28.19, 167.97, 0)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10155.65625, 3068.59375, -1213.625), angles = Angle(19.913, 62.183, 1.143)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11512.875, 6623.5625, -1870.40625), angles = Angle(-1.780, 84.836, 31.685)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(12650.875, 5802.21875, -1898.1875), angles = Angle(8.536, -153.402, 15.853)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(9371.40625, 1140.15625, -1207.21875), angles = Angle(13.414, -0.483, -9.437)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(10417.25, 430.40625, -1194.875), angles = Angle(2.021, 90.731, 0.297)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(9020.625, -195.5, -1197.15625), angles = Angle(0.165, 21.385, 0.247)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(6182.5625, -1907.3125, -1140.09375), angles = Angle(1, -90.049, -1.176)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8278.71875, -6743.6875, -1175.96875), angles = Angle(16.013, -172.985, 6.031)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6042.375, -7549.5, -956.59375), angles = Angle(9.701, 60.002, -6.180)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8587.90625, -2789.21875, -1190.59375), angles = Angle(3.087, -174.941, 10.212)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7751.46875, -1992.125, -1170.90625), angles = Angle(-3.724, 82.469, -0.709)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6852.71875, -572.0625, -1197.0625), angles = Angle(32.36, 108.528, 0.654)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6912.21875, -2157.4375, -1194.34375), angles = Angle(8.339, 67.808, -3.345)},
				{model = "models/props_wasteland/controlroom_storagecloset001a.mdl", pos = Vector(6710.9375, -4408.5625, -1127.09375), angles = Angle(0.022, 0.022, -1.511)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7561.9375, -3074, -1257.4375), angles = Angle(1.28, -86.951, -3.032)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8641.875, -4467.21875, -1103.34375), angles = Angle(1.258, 108.259, 5.202)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7519.40625, -4655.71875, -805.875), angles = Angle(13.574, 39.26, 2.258)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8577.84375, -266.9375, -818.5625), angles = Angle(0, 0, 0)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6366.84375, 6711.5, -1401.65625), angles = Angle(17.271, 117.861, -19.479)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7494.71875, 6059.75, -1215.34375), angles = Angle(1.401, 4.175, 1.879)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-7830.09375, 5111.03125, -1308.9375), angles = Angle(4.274, 73.707, 18.501)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-5950.0625, 6073.90625, -1271.4375), angles = Angle(4.587, -96.883, -7.454)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-10931.53125, 3358.59375, -1720.90625), angles = Angle(28.251, -57.343, -9.163)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-10877.375, 5484.21875, -1706.5), angles = Angle(17.276, 21.923, -7.339)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11152.15625, 5515.71875, -1702.34375), angles = Angle(25.142, 136.582, 4.482)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11599.625, 3427.59375, -1709.96875), angles = Angle(-6.048, -177.446, 19.16)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-12348.65625, 4378.0625, -1709.8125), angles = Angle(-2.813, -68.467, 1.868)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11221.4375, 4056.28125, -1436.90625), angles = Angle(5.471, 82.178, 0.324)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(73, 1277, -1892), angles = Angle(0, 0, 0)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8362.75, -1202.5625, -1153.03125), angles = Angle(15.359, -65.374, 1.357)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7255.0625, -912.3125, -1171.4375), angles = Angle(11.86, 77.569, -4.993)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7441.46875, -2490.46875, -1178.78125), angles = Angle(6.927, -92.626, -1.588)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(7787.03125, -3598.875, -1163.25), angles = Angle(-7.3, 75.602, -5.949)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(7214.65625, -2291.875, -818.40625), angles = Angle(0, 0, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(8189.375, -1651.625, -818.28125), angles = Angle(0, 0, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(8189.375, -2931.84375, -818.40625), angles = Angle(0, 0, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(8318.71875, -4105.625, -818.40625), angles = Angle(0, -35, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(7162.3125, -1331.65625, -643.84375), angles = Angle(0, 0, 0)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11140.46875, 5174.9375, -1703.9375), angles = Angle(-5.724, 67.176, 2.291)},
			},
			["supermarket"] = {
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3501.34375, -2328, -1839.125), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3093.9375, -2111.90625, -1839.125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3136.03125, -1463.5625, -1839.25), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3148.28125, -1735.09735, -1847.75), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3171.53125, -1735.09735, -1847.75), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3194.71875, -1735.09375, -1847.75), angles = Angle(0, 90, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-3272.0625, -1373.53125, -1845.59375), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3136, -737.6875, -1837.5), angles = Angle(0, -180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3228.375, -77.9375, -1839.09375), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3094.03125, -460.375, -1839.1875), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3605.90625, -1952.21875, -1839.15625), angles = Angle(0, 0, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-3143.65625, -1165.625, -1882.3125), angles = Angle(0, 180, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-3166.875, -971.8125, -1882.40625), angles = Angle(0, -140, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-3199.90625, -1293.40625, -1882.375), angles = Angle(0, 140, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-2668.46875, -499.59375, -1882.375), angles = Angle(0, 118, 0)},
				{model = "models/props_c17/furnitureStove001a.mdl", pos = Vector(-3230.75, -1384.90625, -1862.5), angles = Angle(0, -90, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-2925.84375, -1176.125, -1845.8125), angles = Angle(0, 90, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-2925.84375, -1407.84375, -1845.8125), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3215.8125, -2532, -1839.15625), angles = Angle(0, 90, 0)},
			}
		};
	end

	if not cwItemSpawner.SuperCrates then
		cwItemSpawner.SuperCrates = {
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(1679.5, -5791.59375, -12.5), angles = Angle(0.011, 155.83, -0.016)}, -- Top of Tower of Power
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(13203.21875, 8104.75, -1983), angles = Angle(0, -93.2, 0)}, -- Sunken Airplane
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(2241.3125, 6874.21875, -2404), angles = Angle(0.775, -166.454, -3.708)}, -- Mines
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(793.71875, 4120.9375, -2405), angles = Angle(0, -70, 0)}, -- Mines
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-2303.25, 8397, -2734), angles = Angle(10.3, -169.964, -3.246)}, -- Mines
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-12455.5625, -7709.34375, -1233), angles = Angle(0, -45, 0)}, -- Abandoned Chapel
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-11652.8125, 1245.90625, -16695), angles = Angle(-0.214, 34.568, 0.862)}, -- Parkour Island (by Ship)
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-9946.40625, -6106.8125, -1676), angles = Angle(4.378, -160.862, -4.092)}, -- Parkour Island (by Abandoned Church)
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-2724.28125, -5275.5, -2042), angles = Angle(3.746, -2.379, 2.747)}, -- Sunken Building
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-13847.40625, -12274.625, -1670), angles = Angle(0.022, 179.973, -0.209)}, -- Behind the Castle
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-3017.875, -7172.3125, -1010.5625), angles = Angle(0, -90, 0)}, -- Top of Outercanals Building
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-4841.875, -13985.53125, -762.65625), angles = Angle(-0.566, -89.149, 14.881)}, -- Behind Papa Pete's Shack
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(4282.75, -14285.375, 135.78125), angles = Angle(26.955, -69.033, 7.108)}, -- Behind Scrapper Rock Formation
		};
	end
elseif (game.GetMap() == "rp_begotten_redux") then
	if not cwItemSpawner.ContainerLocations then
		cwItemSpawner.ContainerLocations = {
			["city"] = {
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7293.03125, -8613.125, 274.78125), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7092.96875, -8330.25, 274.84375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7296.03125, -8495.90625, 266.25), angles = Angle(0, 135, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7345, -8598.1875, 381.5), angles = Angle(-64.946, -61.381, -56.580)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6575.90625, -8608.96875, 511.09375), angles = Angle(0, 180, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-7045.40625, -8621.5625, 504.375), angles = Angle(0, 0, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-7111.5625, -8927.4375, 358.25), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7220.5625, -9176.96875, 364.8125), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-7598.65625, -8806.75, 338.78125), angles = Angle(0, -45, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7911.40625, -8806.78125, 228.1875), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7888.15625, -8806.78125, 228.1875), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7864.875, -8806.78125, 228.1875), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7945.59375, -9241.25, 208.34375), angles = Angle(0, 35, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7782.90625, -9314.75, -37.1875), angles = Angle(-38.232, -177.742, -2.582)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7325.34375, -7944.09375, 74.78125), angles = Angle(-25.972, 41.309, 6.652)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-5674.75, -7630.5625, 192.1250), angles = Angle(-22.549, -20.934, -2.373)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-5681.40625, -7694.34375, 194.3125), angles = Angle(-17.205, 21.945, -1.516)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-5776.15625, -8442.0625, 112.125), angles = Angle(0, 0, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-6524.8125, -10058.90625, 96.21875), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-7398.5, -6464.4375, 348.4375), angles = Angle(0, -45, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6946.34375, -6458.1875, 376.6875), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-6914.84375, -6942.90625, 368.1875), angles = Angle(0, 135, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7481.78125, -6562.65625, 75.6875), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6884.34375, -6319.5, 109.53125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6938.625, -5937.90625, 241.5625), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7345.21875, -6311.75, 127.65625), angles = Angle(-25.928, 40.128, -1.895)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-6876.96875, -5936.84375, 360.90625), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7276.40625, -5787.9375, 241.53125), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6706.25, -5505, 241.40625), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7275.15625, -5787.03125, 119.21875), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7189.5, -5628.625, 101.03125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7189.5, -5605.5, 101.03125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7189.5, -5582.25, 101.03125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7363.96875, -3260.15625, 75.8125), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7343.8125, -3384.3125, 67.21875), angles = Angle(0, -135, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6707.9375, -3400.15625, 345.5625), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-6877.9375, -3040.84375, 315.84375), angles = Angle(0, -75, 0)},
				{model = "models/props_wasteland/controlroom_filecabinet001a.mdl", pos = Vector(-6786.53125, -3589.28125, 68.34375), angles = Angle(-3.032, -177.654, 1.681)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-7547.15625, -4095.59375, 151.5), angles = Angle(-3.494, -90.038, -89.995)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-3783.65625, -8526.8125, 69.3125), angles = Angle(-4.675, -134.05, -0.527)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-2855.34375, -9254.53125, 68.84375), angles = Angle(-0.61, 132.66, -0.456)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-2771.5, -9381.25, 67.71875), angles = Angle(0.335, -27.103, -0.082)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-2916.1875, -9822.03125, 92.09375), angles = Angle(0.709, 131.677, 7.191)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7846.0625, -1861.6875, 90.625), angles = Angle(0, 180, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7845.5, -462.34375, 90.6875), angles = Angle(0, 180, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7052.21875, -5399.375, 134.09375), angles = Angle(3.604, 91.461, 3.274)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-4563.625, -8888.125, 90.625), angles = Angle(0, 180, 0)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-4562.46875, -8968.59375, 90.59375), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-246.03125, 1697.875, 124.875), angles = Angle(0, 0, 0)},
			},
			["industrial"] = {
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-8530.03125, -3314.25, 62.96875), angles = Angle(-5.746, 128.04, -12.085)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6212.53125, -7070.28125, 98.25), angles = Angle(-6.943, 106.106, 1.258)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-1686.0625, -9394.03125, 77.1875), angles = Angle(6.801, 165.718, -20.533)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(291.03125, -11179.25, 445.25), angles = Angle(-10.997, 103.903, 1.219)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(983, -470.34375, 108.78125), angles = Angle(-9.47, -66.78, -5.872)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-4241.90625, -4211.1875, 179.40625), angles = Angle(2.823, 133.352, -4.669)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-12052.75, 13083.46875, 768.21875), angles = Angle(-5.191, -133.819, -14.052)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-7412.4375, 7843.09375, 765.90625), angles = Angle(-0.324, -153.083, 0.104)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-2154.65625, 5009.09375, 692.875), angles = Angle(-10.157, 154.468, -10.706)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10457.75, 4867.25, 125.96875), angles = Angle(-0.176, -34.909, -5.378)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-5090.78125, -7499.96875, 128.15625), angles = Angle(6.531, -6.218, -4.988)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(512.5625, 1584.21875, 65.4375), angles = Angle(0.242, -118.433, -0.225)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11982.9375, 1221.25, 117.40625), angles = Angle(8.333, -85.067, -4.774)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-8077.1875, -5883, -67.5), angles = Angle(-6.91, 42.665, -0.516)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-7809, -8112.1875, -70.9375), angles = Angle(0.604, -28.323, -3.290)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-7959.46875, -9571.5625, -60.5), angles = Angle(6.663, -161.724, -0.956)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-3178.53125, 12417.03125, 688.5625), angles = Angle(5.971, 74.603, -9.717)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-9766.25, 1318.59375, 264.125), angles = Angle(16.21, -76.075, -0.928)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10389.4375, -3498.53125, 64.3125), angles = Angle(5.878, -3.653, -0.807)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10224.375, -3855.375, 65.4375), angles = Angle(0.126, -78.305, -0.077)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(9757.375, -6723.375, -57.5625), angles = Angle(3.384, -28.779, -1.351)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8345.5625, -11377.8125, 390.4375), angles = Angle(-0.807, 63.331, 4.477)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-4063.84375, 1762.5625, 65.34375), angles = Angle(0, 87.133, -0.077)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-7327.53125, -9178.8125, 321.34375), angles = Angle(0.049, 32.36, 0.016)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6709.78125, -5464.84375, 62.59375), angles = Angle(-6.663, 155.369, -3.307)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6888.09375, -3042.21875, 296.34375), angles = Angle(3.609, -101.080, -7.1637)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(140.71875, 1845.375, 57.9375), angles = Angle(2.576, 64.764, -0.104)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(2778.625, -9978, -68.90625), angles = Angle(2.895, 72.669, 4.779)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-3194.4375, -9968.09375, 115.0625), angles = Angle(18.929, 61.622, 168.349)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(13224.75, -10976.6875, 63.375), angles = Angle(1.285, 170.195, -0.033)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-8643.71875, -8725.34375, -284.5625), angles = Angle(0.016, -144.448, -0.461)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-13781.9375, -5574.8125, -142.125), angles = Angle(0, -81.041, 0)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-13672.125, -8386.3125, -139.5), angles = Angle(0.055, 125.123, 0.038)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11070.625, -8619.65625, -139.5), angles = Angle(-0.159, 164.691, 0.038)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-8638.1875, -8594.78125, -288.218750), angles = Angle(-6.888, -172.112, 0.374)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-13661.125, 3556.375, 638.1875), angles = Angle(-0.978, -66.912, -22.736)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-11331.5625, 8514.5, 779.03125), angles = Angle(1.835, 85.144, -0.291)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-9594, -9087.03125, -217.15625), angles = Angle(0, 90, 0)},
			},
			["supermarket"] = {
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-7379.4375, -1089, 65.6875), angles = Angle(0, 140, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-7371.21875, -1391.4375, 65.59375), angles = Angle(0, 150, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-7359.53125, -829.5, 67.6875), angles = Angle(0, 180, 0)},
				{model = "models/props/de_nuke/crate_extrasmall.mdl", pos = Vector(-6869.40625, -585.59375, 65.65625), angles = Angle(0, 135, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7281.9375, -568.3125, 108.78125), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7324.0625, -285.96875, 108.84375), angles = Angle(0, 180, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-7313.59375, -1688.25, 102.34375), angles = Angle(0, 180, 0)},
				{model = "models/props_c17/furnitureStove001a.mdl", pos = Vector(-7324.3125, -1647.625, 85.71875), angles = Angle(0, 180, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7401.96875, -2642, 108.84375), angles = Angle(0, 90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7794, -2538.71875, 108.875), angles = Angle(0, 0, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7281.9375, -2222.78125, 108.875), angles = Angle(0, 0, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-7112.875, -1514.9375, 102.125), angles = Angle(0, -90, 0)},
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(-7114.21875, -1292.28125, 102.4375), angles = Angle(0, 90, 0)},
				-- Inside house.
				{model = "models/props_c17/FurnitureFridge001a.mdl", pos = Vector(151.0625, 1734.25, 101.34375), angles = Angle(0, 180, 0)},
				{model = "models/props_c17/furnitureStove001a.mdl", pos = Vector(162.40625, 1774.71875, 118.15625), angles = Angle(0, 180, 0)},
			}
		};
	end

	if not cwItemSpawner.SuperCrates then
		cwItemSpawner.SuperCrates = {
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-11259.59375, -3676.34375, 0.46875), angles = Angle(0.016, 133.731, 0)}, -- Inside Car Tunnel
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-9815.03125, -9060.09375, -284.5625), angles = Angle(0, 75, 0)}, -- Inside Tunnels
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-7884.3125, -9426.3125, -63.125), angles = Angle(0, 180, 0)}, -- Building By Bus
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-5911.21875, 7653.40625, 543.625), angles = Angle(2.296, 105.112, -4.9)}, -- Underwater Near Pillars
		};
	end
elseif (game.GetMap() == "rp_scraptown") then
	if not cwItemSpawner.ContainerLocations then
		cwItemSpawner.ContainerLocations = {
			["city"] = {
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-2596.156250, 10506.343750, 574.312500), angles = Angle(0.011, -0.022, 0.033)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-2596.125000, 10483.218750, 574.312500), angles = Angle(0.000, -0.198, 0.060)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-2596.250000, 10459.937500, 574.218750), angles = Angle(0.027, 0.132, 0.093)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(3230.875000, 9934.156250, 289.468750), angles = Angle(-58.530, 5.674, 0.335)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(5877.906250, 7176.125000, 411.281250), angles = Angle(0.000, -90.187, -0.011)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(5901.093750, 7176.281250, 411.250000), angles = Angle(0.000, -89.951, -0.016)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(5924.218750, 7175.968750, 411.187500), angles = Angle(0.044, -89.973, -0.022)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(6664.062500, 5671.718750, 912.343750), angles = Angle(-70.708, 178.105, 13.337)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(4785.843750, 1999.093750, 1183.781250), angles = Angle(-17.111, -173.853, -2.219)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(7884.531250, 1239.593750, 1163.187500), angles = Angle(0.253, -28.889, 0.016 )},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(8400.468750, 1041.593750, 1163.250000), angles = Angle(0.225, 116.911, 0.253)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(7879.718750, 1513.625000, 1027.343750), angles = Angle(0.000, 0.060, -0.011)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(7882.562500, 1036.187500, 1027.218750), angles = Angle(-0.016, 88.028, 0.104)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(11386.281250, -3984.281250, 565.343750), angles = Angle(0.000, -152.666, 0.000)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-5790.437500, -8653.312500, 817.531250), angles = Angle(-10.118, -26.884, -3.713)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-3257.093750, -8002.437500, 172.437500), angles = Angle(-66.385, 17.441, 3.235)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(-4277.156250, -7089.687500, 169.312500), angles = Angle(-1.346, 50.400, 9.492)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(10886.937500, -200.000000, 333.281250), angles = Angle(0.242, 89.868, 0.000)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(11211.093750, 2592.812500, 103.375000), angles = Angle(-80.530, -27.345, -116.483)},
				{model = "models/props_wasteland/controlroom_filecabinet002a.mdl", pos = Vector(5438.843750, 9870.468750, 144.812500), angles = Angle(-56.146, -112.050, -15.859)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-5716.531250, -9020.906250, 800.000000), angles = Angle(1.208, 61.474, -0.335)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-4910.062500, -9491.593750, 794.656250), angles = Angle(-0.077, -31.207, 2.994)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-2753.531250, -8288.250000, 247.750000), angles = Angle(-19.660, 136.005, -3.296)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-3888.531250, -7924.781250, 187.937500), angles = Angle(-2.543, 75.125, -9.003)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-100.906250, 674.375000, 57.281250), angles = Angle(-11.283, 149.458, 0.439)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7431.718750, 7243.843750, -0.593750), angles = Angle(5.416, 125.695, 0.027)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-6361.937500, 2755.343750, -19.406250), angles = Angle(6.872, -149.590, 6.735)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-6562.687500, 12355.312500, 416.781250), angles = Angle(0.335, -110.380, -0.060)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-8872.500000, 11680.093750, 519.375000), angles = Angle(-4.653, 96.663, 2.730)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-7731.843750, 11846.406250, 428.093750), angles = Angle(0.000, 135.637, 0.000)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(-2833.250000, 10422.062500, 554.781250), angles = Angle(-4.625, -90.137, 0.538)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(3217.906250, 10043.875000, 287.500000), angles = Angle(-3.433, 19.968, 0.989)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(6659.406250, 10300.937500, 479.468750), angles = Angle(-3.444, 92.560, -0.341)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(6021.531250, 6868.500000, 401.531250), angles = Angle(0.000, -163.224, 0.000)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(8980.718750, 8802.500000, 1041.906250), angles = Angle(-4.076, 16.040, 4.482)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(11462.968750, 3437.656250, 321.093750), angles = Angle(2.675, -128.837, -7.322)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(7215.968750, -1434.093750, 94.468750), angles = Angle(-9.690, -106.392, -6.021)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(988.125000, -10831.468750, 637.531250), angles = Angle(-0.275, -74.828, -0.143)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(4556.812500, -9647.312500, 1227.718750), angles = Angle(-4.268, 59.117, 0.055)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(11537.125000, -10139.906250, 173.343750), angles = Angle(-9.124, -56.025, 2.598)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(11531.843750, -4223.687500, 506.125000), angles = Angle(3.642, -137.274, -5.510)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(11367.187500, -5645.156250, 449.718750), angles = Angle(2.126, 109.869, -8.619)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(10902.281250, -256.156250, 287.968750), angles = Angle(-6.850, -89.258, -1.060)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(7827.343750, 1154.531250, 973.187500), angles = Angle(-0.247, -176.600, 1.219)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(8261.437500, 1046.562500, 1017.687500), angles = Angle(0.060, 90.000, 0.033)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(1178.125000, 5711.906250, 1001.281250), angles = Angle(0.000, 179.797, 0.214)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(1178.218750, 5688.687500, 1001.375000), angles = Angle(0.000, 179.780, 0.176)},
				{model = "models/props_junk/TrashDumpster01a.mdl", pos = Vector(1178.031250, 5665.562500, 1001.375000), angles = Angle(-0.016, 179.687, 0.159)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-2462.875000, 10490.000000, 582.718750), angles = Angle(-0.011, -179.995, 0.016)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-2860.968750, 10631.375000, 582.812500), angles = Angle(0.110, 0.022, -0.016)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(6470.750000, 7644.000000, 419.468750), angles = Angle(0, -90, 0)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(6186.156250, 6924.906250, 419.781250), angles = Angle(0.022, 89.934, 0.170)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(6040.968750, 7041.875000, 419.875000), angles = Angle(0.000, -179.835, -0.011)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1062.937500, 5696.500000, 1009.750000), angles = Angle(-0.033, -0.022, 0.011)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(846.312500, 5660.000000, 1009.843750), angles = Angle(-0.066, 90.027, 0.000)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-6965.343750, 7316.562500, 86.656250), angles = Angle(-4.933, 112.445, -9.701)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-9483.187500, 12442.218750, 576.156250), angles = Angle(-1.577, 2.615, -0.604)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-7890.000000, 11978.718750, 419.937500), angles = Angle(-88.341, 44.341, 56.799)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(1198.031250, -4544.312500, 341.750000), angles = Angle(-30.569, 22.808, 0.895)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(11220.531250, -3876.375000, 573.812500), angles = Angle(-0.071, -56.129, -0.099)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(10786.906250, 114.625000, 341.843750), angles = Angle(0.060, 0.016, -0.022)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(9089.906250, 3954.218750, 384.062500), angles = Angle(-66.006, -9.750, 5.603)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(574.500000, 8746.187500, -242.875000), angles = Angle(-81.771, -7.740, 82.403)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(-3787.437500, -7743.656250, 182.156250), angles = Angle(-18.710, 38.090, 0.417)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(790.187500, -10957.531250, 655.812500), angles = Angle(0.016, -155.528, -0.154)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(732.906250, -10542.343750, 655.875000), angles = Angle(0.000, 149.623, -0.038)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(887.187500, -10581.375000, 655.875000), angles = Angle(-0.044, -74.954, -0.022)},
				{model = "models/props_wasteland/controlroom_storagecloset001b.mdl", pos = Vector(393.531250, -10975.843750, 655.781250), angles = Angle(-0.044, 165.333, 0.082)},
			},
			["industrial"] = {
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6974.9375, 7705.8125, 74), angles = Angle(-2.813, -152.913, 0.824)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-2437.84375, 3491.21875, 694.03125), angles = Angle(1.785, 46.884, -5.46)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-1720.40625, 6318.65625, 937.1875), angles = Angle(28.85, 155.654, -0.269)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(2811.6875, 5145.8125, 1061.71875), angles = Angle(-7.388, 53.344, -8.075)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(3652.15625, 7116.90625, 219.625), angles = Angle(-16.144, 56.788, -17.781)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(2359.03125, 9705.09375, 219.0625), angles = Angle(16.908, -119.465, 0.165)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(842.46875, 10352.5625, 189.9375), angles = Angle(-43.945, -113.214, -7.57)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(906.90625, 8756, -334.125), angles = Angle(9.014, -16.183, -3.664)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-523.1875, 8315.21875, -349.9375), angles = Angle(15.474, -11.569, -10.042)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-1573.53125, 8505.625, -379.21875), angles = Angle(11.437, 75.245, -5.460)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-387.09375, 9301.03125, -162.6875), angles = Angle(5.345, 140.625, -3.483)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-9465.875, 12216.15625, 517.78125), angles = Angle(11.464, 31.937, 1.901)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-6962.21875, 4487.65625, 703), angles = Angle(-2.461, 128.32, -3.268)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-8162.9375, 1842.75, 31.6875), angles = Angle(26.96, 21.951, -18.012)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(-5688.687500, -8482.656250, 789.000000), angles = Angle(6.949, -89.978, -11.316)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(747.437500, -11252.843750, 601.156250), angles = Angle(8.696, 115.922, -0.571)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(786.281250, -10436.625000, 610.062500), angles = Angle(4.653, 39.732, 2.038)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(2615.375000, -9195.125000, 996.531250), angles = Angle(-23.115, -178.149, 50.147)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(8179.156250, -10319.843750, 610.718750), angles = Angle(9.767, -151.227, -1.577)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11484.906250, -9828.000000, 140.468750), angles = Angle(10.690, 123.805, -4.642)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10222.375000, -7955.093750, 523.343750), angles = Angle(12.766, -57.744, -3.109)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11926.406250, -7073.718750, 638.125000), angles = Angle(28.905, 174.122, 6.191)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11303.531250, -5374.375000, 402.625000), angles = Angle(30.218, 167.179, -79.332)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11731.812500, -4869.500000, 441.500000), angles = Angle(-5.092, 99.311, -0.873)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10371.218750, -4217.968750, 616.093750), angles = Angle(16.337, 52.399, -16.474)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11176.687500, -3848.906250, 516.875000), angles = Angle(11.019, -172.018, -3.246)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10333.625000, -3619.718750, 540.937500), angles = Angle(2.505, -13.870, -12.744)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(9344.718750, -1033.625000, 215.062500), angles = Angle(-12.783, 114.324, -5.850)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10437.281250, 698.937500, 166.156250), angles = Angle(16.655, -126.151, 7.207)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(10877.625000, 6902.218750, 172.843750), angles = Angle(-10.025, -118.531, -4.730)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(11624.375000, 8627.750000, 318.500000), angles = Angle(5.960, -11.931, 8.608)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6827.750000, 10372.843750, 427.906250), angles = Angle(-16.798, 1.549, -1.912)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(5346.406250, 9739.843750, 102.593750), angles = Angle(5.026, -138.505, -9.212)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6240.156250, 5967.781250, 757.500000), angles = Angle(-17.144, 135.621, -1.840)},
				{model = "models/props_c17/oildrum001.mdl", pos = Vector(6397.125000, 7474.968750, 319.750000), angles = Angle(-1.642, -58.629, -1.813)},
			},
		};
	end

	if not cwItemSpawner.SuperCrates then
		cwItemSpawner.SuperCrates = {
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-790.437500, 8712.218750, -325.312500), angles = Angle(-0.093, 89.083, -1.637)},
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(-469.625000, -9528.468750, 900.156250), angles = Angle(0.071, -162.263, 0.049)},
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(12014.000000, -5078.625000, 489.000000), angles = Angle(-9.998, -42.061, -4.471)},
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(7554.281250, 1529.937500, 1264.375000), angles = Angle(0, 0, 0)},
			{model = "models/props/de_prodigy/ammo_can_01.mdl", pos = Vector(12178.093750, 6231.687500, 412.437500), angles = Angle(0.143, 138.538, 0.044)},
		};
	end
end

if not cwItemSpawner.SpawnLocations then
	cwItemSpawner.SpawnLocations = {};
end

-- A function to select a random item to spawn.
function cwItemSpawner:SelectItem(location, bIsSupercrate, bIsContainer)
	local spawnable = self:GetSpawnableItems(true);
	local itemPool = {};
	local uniqueID = nil;
	
	for i = 1, #spawnable do
		local itemTable = spawnable[i];
		
		if itemTable.itemSpawnerInfo and !itemTable.isBaseItem then
			local rarity = itemTable.itemSpawnerInfo.rarity;
			local valid = true;
			
			if location and valid then
				if !table.HasValue(self.LocationsToCategories[location], itemTable.itemSpawnerInfo.category) then
					valid = false;
				end
			end
			
			if !bIsSupercrate and valid then
				if itemTable.itemSpawnerInfo.supercrateOnly then
					valid = false;
				end
			elseif valid then
				-- Make sure low quality items don't appear in supercrates (exemption for ammo).
				if rarity < 150 and itemTable.category ~= "Shot" then
					valid = false;
				end
				
				rarity = rarity / 2;
			end
			
			if !bIsContainer and valid then
				if itemTable.itemSpawnerInfo.onGround == false then
					valid = false;
				end
			end
			
			if valid then
				if math.random(1, rarity) == 1 then
					table.insert(itemPool, itemTable);
				end;
			end
		end
	end;
	
	if (#itemPool > 0) then
		uniqueID = itemPool[math.random(1, #itemPool)].uniqueID;
	else
		--uniqueID = spawnable[math.random(1, #spawnable)].uniqueID;
	end;

	return uniqueID;
end;

-- A function to get all spawnable items in the game.
function cwItemSpawner:GetSpawnableItems(sequential)
	local items = {};
	
	for k, v in pairs (Clockwork.item:GetAll()) do
		if v.itemSpawnerInfo then
			if (!sequential) then
				items[k] = v;
			else
				items[#items + 1] = v;
			end;
		end;
	end;
	
	return items;
end;

-- A function to get whether a position is clear of players and other items.
function cwItemSpawner:IsAreaClear(position, bContainer)
	--if (!bContainer) then
		for k, v in pairs (ents.FindInSphere(position, 512)) do
			if (v:IsPlayer()) then
				--print("Returning false for position: "..tostring(position));
				--print("Player found is: "..v:Name());
				return false;
			end;
		end;
	--end;
	
	--[[local players = _player.GetAll();

	for k, v in pairs(players) do
		if (v:IsAdmin() or !v:Alive()) then
			continue;
		end;
		
		if (Clockwork.entity:CanSeePosition(v, position)) then
			return false;
		end;
	end;]]--
	
	return true;
end;

-- A function to get a random spawn position.
function cwItemSpawner:GetSpawnPosition(category)
	local positions = {};
	
	for k, v in pairs (self.SpawnLocations) do
		if v.category == "supermarket" then
			if math.random(1, 3) < 3 then
				continue;
			end
		end
	
		if category then
			if v.category == category then
				table.insert(positions, v);
			end
		else
			table.insert(positions, v);
		end;
	end;
	
	if #positions > 0 then
		local position = positions[math.random(1, #positions)];
	
		if (self:IsAreaClear(position.position)) then
			return position;
		end
	end;
	
	return false;
end;

-- A function to get all valid spawn containers.
function cwItemSpawner:GetContainers()
	--[[local containers = {};
	
	for k, v in pairs (ents.FindByClass("prop_physics")) do
		local model = v:GetModel();
		
		if (!v.cwPassword and v.cwInventory and cwStorage.containerList[model]) then
			if (Clockwork.inventory:CalculateSpace(v.cwInventory) > (cwStorage.containerList[model][1] * 0.6)) then
				continue;
			end;
			
			if (Schema:IsInBox(Vector(2900, 15147, -2778), Vector(-2532, 11748, 2048), v)) then
				continue;
			end;
			
			if (!self:IsAreaClear(v:GetPos(), true)) then
				continue;
			end;
			
			containers[#containers + 1] = v;
		end;
	end;
	
	return containers;]]--
	
	return self.containers;
end;

-- A function to add an item spawn.
function cwItemSpawner:AddSpawn(position, category)
	table.insert(self.SpawnLocations, {position = position, category = category});
	
	Clockwork.datastream:Start(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
	
	self:SaveItemSpawns();
end;

-- A function to remove an item spawn.
function cwItemSpawner:RemoveSpawn(position, distance, player)
	if (position) then
		local count = 0;
		
		for k, v in pairs (self.SpawnLocations) do
			if (v.position:Distance(position) < distance) then
				table.remove(self.SpawnLocations, k);
				count = count + 1;
			end;
		end;

		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed "..count.." item spawns at your cursor position.");
		end;
		
		self:SaveItemSpawns();
	end;
end;

-- A function to load all the trash spawns.
function cwItemSpawner:LoadItemSpawns()
	self.SpawnLocations = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/itemspawn/"..game.GetMap()));
	
	Clockwork.datastream:Start(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
end;

-- A function to save all the trash spawns.
function cwItemSpawner:SaveItemSpawns()
	local itemspawns = {};
	
	for k, v in pairs(self.SpawnLocations) do
		itemspawns[#itemspawns + 1] = v;
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/itemspawn/"..game.GetMap(), itemspawns);
	Clockwork.datastream:Start(Schema:GetAdmins(), "ItemSpawnESPInfo", {self.SpawnLocations});
end;

-- Spawns the maximum amount of containers, should only really be called at server start.
function cwItemSpawner:SetupContainers()
	if !self.ContainerLocations then
		return;
	end
	
	if not self.Containers then
		self.Containers = {};
	end
	
	local numContainers = #self.Containers;
	local curTime = CurTime();
	
	for k, v in pairs(self.ContainerLocations) do
		if k == "supermarket" then
			if math.random(1, 4) < 4 then
				continue;
			end
		end
	
		if numContainers < self.MaxContainers then
			for i = 1, #v do
				if numContainers < self.MaxContainers and !v[i].occupier then
					if math.random(1, 2) == 1 then
						local container = ents.Create("prop_physics")

						container:SetAngles(v[i].angles);
						container:SetModel(v[i].model);
						container:SetPos(v[i].pos);
						container:Spawn();
						
						v[i].occupier = container:EntIndex();
						
						local physicsObject = container:GetPhysicsObject();
						
						if (IsValid(physicsObject)) then
							physicsObject:EnableMotion(false);
						end;
						
						numContainers = numContainers + 1;
						
						local containerTable = {
							container = container,
							lifeTime = curTime + self.ContainerLifetime
						};
						
						table.insert(self.Containers, containerTable);
						
						local lockChance = math.random(1, 100);
						
						if lockChance <= 5 then
							container.cwLockType = "none";
							container.cwLockTier = 3;
							container:SetNWBool("unlocked", false);
						elseif lockChance <= 15 then
							container.cwLockType = "none";
							container.cwLockTier = 2;
							container:SetNWBool("unlocked", false);
						elseif lockChance <= 25 then
							container.cwLockType = "none";
							container.cwLockTier = 1;
							container:SetNWBool("unlocked", false);
						end
						
						if not container.cwInventory then
							container.cwInventory = {};
						end
						
						local itemIncrease = (container.cwLockTier or 0) * 2
						
						for i = 1, math.random(3 + itemIncrease, 6 + itemIncrease) do
							local randomItem = self:SelectItem(containerCategory, false, true);
							
							if randomItem then
								local itemInstance = item.CreateInstance(randomItem);
								
								if itemInstance then
									local category = itemInstance.category;
									
									if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
										-- 75% chance for these items to spawn with less than 100% condition.
										if math.random(1, 4) ~= 1 then
											itemInstance:TakeCondition(math.random(0, 75));
										end
									elseif itemInstance.category == "Shot" and itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
										itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
									end
									
									Clockwork.inventory:AddInstance(container.cwInventory, itemInstance, 1);
								end
							end
						end
						
						if (container.cwLockTier and container.cwLockTier >= 1) or math.random(1, 10) == 1 then
							container.cwCash = math.random(10, 50);
							
							if math.random(1, 5) == 1 then
								container.cwCash = math.random(50, 100);
							end
						end
					end
				else
					return;
				end
			end
		else
			return;
		end
	end
end;

-- Eventually this should have its own high value loot table.
function cwItemSpawner:SpawnSupercrate()
	if !self.SuperCrates then
		return;
	end
	
	if not self.SuperCrate then
		local superCratePos = cwItemSpawner.SuperCrates[math.random(1, #cwItemSpawner.SuperCrates)];
		
		if self:IsAreaClear(superCratePos.pos, true) then
			local supercrate = ents.Create("prop_physics")

			supercrate:SetAngles(superCratePos.angles);
			supercrate:SetModel(superCratePos.model);
			supercrate:SetPos(superCratePos.pos);
			supercrate:Spawn();
			
			supercrate:SetNetworkedString("Name", "Supercrate");
			
			local physicsObject = supercrate:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
			
			local supercrateTable = {
				supercrate = supercrate,
				lifeTime = CurTime() + self.ContainerLifetime
			};

			supercrate.cwLockType = "none";
			supercrate.cwLockTier = 3;
			supercrate:SetNWBool("unlocked", false);
			
			if not supercrate.cwInventory then
				supercrate.cwInventory = {};
			end
			
			for i = 1, math.random(8, 10) do
				local randomItem = self:SelectItem(nil, true);
				
				if randomItem then
					local itemInstance = item.CreateInstance(randomItem);
					
					-- If it is a magazine, make it full of ammo. If it is a normal ammo, spawn a bunch of duplicates.
					if itemInstance.category == "Shot" then
						if itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
							itemInstance:SetAmmoMagazine(itemInstance.ammoMagazineSize);
						else
							Clockwork.inventory:AddInstance(supercrate.cwInventory, itemInstance, math.random(4, 10));
							continue;
						end
					elseif itemInstance.name == "Colt" then
						for j = 1, 2 do
							local magazineItemInstance = item.CreateInstance("old_world_magazine");
							
							if magazineItemInstance and magazineItemInstance.ammoMagazineSize and magazineItemInstance.SetAmmoMagazine then
								magazineItemInstance:SetAmmoMagazine(magazineItemInstance.ammoMagazineSize);
							
								Clockwork.inventory:AddInstance(supercrate.cwInventory, magazineItemInstance);
							end
						end
					elseif itemInstance.name == "Springer" then
						for j = 1, math.random(5, 10) do
							local ammoItemInstance = item.CreateInstance("old_world_longshot");
							
							if ammoItemInstance then
								Clockwork.inventory:AddInstance(supercrate.cwInventory, ammoItemInstance);
							end
						end
					end
					
					-- Supercrate items will have perfect condition.
					Clockwork.inventory:AddInstance(supercrate.cwInventory, itemInstance, 1);
				end
			end
			
			supercrate.cwCash = math.random(500, 1000);
			
			self.SuperCrate = supercrateTable;
		end
	end
end