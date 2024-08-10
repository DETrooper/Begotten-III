--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

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

netstream.Hook("ShackInfo", function(data)
	if data then
		cwShacks.shacks = data;
	end
end);