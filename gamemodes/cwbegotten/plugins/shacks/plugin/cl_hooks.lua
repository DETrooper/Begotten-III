--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

if game.GetMap() == "rp_begotten3" then
	cwShacks.shackData = {
		["market"] = {
			["M1"] = {name = "Shack M1", floor = 0, price = 700},
			["M2"] = {name = "Shack M2", floor = 0, price = 700},
			["M3"] = {name = "Shack M3", floor = 0, price = 700},
			["M4"] = {name = "Shack M4", floor = 0, price = 700},
		},
		["floor1"] = {
			["A1"] = {name = "Shack A1", floor = 1, price = 500},
			["A2"] = {name = "Shack A2", floor = 1, price = 500},
			["A3"] = {name = "Shack A3", floor = 1, price = 500},
			["A4"] = {name = "Shack A4", floor = 1, price = 500},
		},
		["floor2"] = {
			["B1"] = {name = "Shack B1", floor = 2, price = 350},
			["B2"] = {name = "Shack B2", floor = 2, price = 350},
			["B3"] = {name = "Shack B3", floor = 2, price = 350},
			["B4"] = {name = "Shack B4", floor = 2, price = 350},
			["B5"] = {name = "Shack B5", floor = 2, price = 350},
			["B6"] = {name = "Shack B6", floor = 2, price = 350},
			["B7"] = {name = "Shack B7", floor = 2, price = 350},
			["B8"] = {name = "Shack B8", floor = 2, price = 350},
			["B9"] = {name = "Hotel Room B1", floor = 2, price = 1000},
			["B10"] = {name = "Hotel Room B2", floor = 2, price = 1000},
			["B11"] = {name = "Hotel Room B3", floor = 2, price = 1000},
			["B12"] = {name = "Hotel Room B4", floor = 2, price = 1000},
		},
		["floor3"] = {
			["C2"] = {name = "Hotel Room C2", floor = 3, price = 1000},
			["C3"] = {name = "Hotel Room C3", floor = 3, price = 1000},
			["C4"] = {name = "Hotel Room C4", floor = 3, price = 1000},
		},
		["floor4"] = {
			["D1"] = {name = "Shack D1", floor = 4, price = 600},
			["D2"] = {name = "Hotel Room D1", floor = 4, price = 1000},
		},
	};
elseif game.GetMap() == "rp_district21" then
	cwShacks.shackData = {
		["shacks"] = {
			["S1"] = {name = "Shack S1", floor = 0, price = 500},
			["S2"] = {name = "Shack S2", floor = 0, price = 500},
			["S3"] = {name = "Shack S3", floor = 0, price = 500},
			["S4"] = {name = "Shack S4", floor = 0, price = 500},
			["S5"] = {name = "Shack S5", floor = 0, price = 500},
			["S6"] = {name = "Shack S6", floor = 0, price = 700},
			["S7"] = {name = "Shack S7", floor = 0, price = 500},
		},
	};
elseif game.GetMap() == "bg_district34" then
	cwShacks.shackData = {
		["outside"] = {
			["S1"] = {name = "Shack S1", floor = 0, price = 75},
			["S2"] = {name = "Shack S2", floor = 0, price = 75},
			["S3"] = {name = "Shack S3", floor = 0, price = 75},
			["S4"] = {name = "Shack S4", floor = 0, price = 75},
			["S5"] = {name = "Shack S5", floor = 0, price = 75},
			["S8"] = {name = "Shack S6", floor = 0, price = 75},
			["S9"] = {name = "Shack S7", floor = 0, price = 75},
		},
		["market"] = {
			["M1"] = {name = "Shack M1", floor = 0, price = 225},
			["M2"] = {name = "Shack M2", floor = 0, price = 225},
			["M3"] = {name = "Shack M3", floor = 0, price = 225},
		},
		["floor1v"] = {
			["R3"] = {name = "Room 3", floor = 1, price = 500},
			["R4"] = {name = "Room 4", floor = 1, price = 500},
			["R5"] = {name = "Room 5", floor = 1, price = 1000},
			["R6"] = {name = "Room 6", floor = 1, price = 1000},
			["R7"] = {name = "Room 7", floor = 1, price = 1000},
			["R8"] = {name = "Room 8", floor = 1, price = 1000},
			["S6"] = {name = "Shack", floor = 1, price = 225},
			["R9"] = {name = "Room 9", floor = 1, price = 500},
s		},
		["floor2"] = {
			["R11"] = {name = "Room 11", floor = 2, price = 500},
			["R12"] = {name = "Room 12", floor = 2, price = 500},
			["S7"] = {name = "Shack", floor = 2, price = 225},
			["R15"] = {name = "Room 15", floor = 2, price = 1000},
			["R16"] = {name = "Room 16", floor = 2, price = 1000},
			["R18"] = {name = "Room 18", floor = 2, price = 1000},
			["R19"] = {name = "Room 19", floor = 2, price = 500},
			["R20"] = {name = "Room 20", floor = 2, price = 500},
		},
		["floor3"] = {
			["R21"] = {name = "Room 21", floor = 3, price = 500},
			["R22"] = {name = "Room 22", floor = 3, price = 500},
		},
		["floor3penthouses"] = {
			["R23"] = {name = "Room 23", floor = 3, price = 5000},
			["R24"] = {name = "Room 24", floor = 3, price = 5000},
		},
	};
else
	cwShacks.shackData = {};
end

netstream.Hook("ShackInfo", function(data)
	if data then
		cwShacks.shacks = data;
	end
end);