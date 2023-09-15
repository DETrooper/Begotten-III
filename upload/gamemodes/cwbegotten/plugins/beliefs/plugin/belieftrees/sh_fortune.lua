--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local FORTUNE = cwBeliefs.beliefTrees:New("fortune")
	FORTUNE.name = "Fortune";
	FORTUNE.color = Color(60, 69, 72);
	FORTUNE.order = 3;
	FORTUNE.size = {w = 258, h = 407};
	FORTUNE.textures = {"fortune", "fortunearrows"};
	FORTUNE.tooltip = {
		{"Fortune", FORTUNE.color, "Civ5ToolTi3"},
		{"Fortune is a measure of your character's luck. Neglecting this belief tree for others may contribute to your character's demise, while upgrading it may improve your character's chances of escaping perilous situations as well improving as your character's scavenging ability.", Color(225, 200, 200)},
		{"\n\"Practice the coin in your only hand. Your other fell off in rot...\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: Increases the chance of finding exceedingly rare items.", Color(50, 255, 50)}
	};
	FORTUNE.columnPositions = {
		[1] = (FORTUNE.size.w - 4) * 0.3,
		[2] = (FORTUNE.size.w - 4) * 0.5,
		[3] = (FORTUNE.size.w - 4) * 0.7,
	};
	FORTUNE.rowPositions = {
		[1] = (FORTUNE.size.h - 4) * 0.3,
		[2] = (FORTUNE.size.h - 4) * 0.5,
		[3] = (FORTUNE.size.h - 4) * 0.7,
		[4] = (FORTUNE.size.h - 4) * 0.9,
	};
	
	FORTUNE.hasFinisher = true;
	FORTUNE.lockedTraits = {"marked"};
	
	-- First index is column.
	FORTUNE.beliefs = {
		[1] = {
			["fortunate"] = {
				name = "Fortunate",
				description = "You now have a chance of finding slightly better items while scavenging.",
				quote = "\"Fortune favors the bold.\"",
				row = 1,
			},
			["lucky"] = {
				name = "Lucky",
				description = "10% chance of completely avoiding damage when taking damage from any source.",
				requirements = {"fortunate"},
				row = 2,
			},
			["favored"] = {
				name = "Favored",
				description = "An other-worldly power, be they blessed or unholy, looks down upon you with favor. Your prayers have a higher chance of being heard, and malevolent forces will no longer target you. You will no longer die from consuming certain food or drink items, and those items that were once lethal may now have hidden value.",
				quote = "\"The Gods favor this one.\"",
				requirements = {"fortunate", "lucky"},
				row = 3,
			},
		},
		[2] = {},
		[3] = {
			["talented"] = {
				name = "Talented",
				description = "Increases faith gain from all activities by 15%.",
				quote = "\"A natural at everything. Are they a prodigy from the heavens, or descended from noble stature?\"",
				row = 1,
			},
			["gifted"] = {
				name = "Gifted",
				description = "Additional 10% faith gain increase from all activities.",
				requirements = {"talented"},
				row = 2,
			},
			["jack_of_all_trades"] = {
				name = "Jack of All Trades",
				description = "Instantly gain six faith levels but all non-subfaith tier 4 beliefs are locked (excluding sub-faith beliefs). Any epiphanies invested in the locked beliefs will be refunded. Note that this will not increase your maximum sacrament level, so if you are already at the maximum level then this belief will do nothing.",
				quote = "\"..and master of none.\"",
				requirements = {"talented", "gifted"},
				row = 3,
			},
		},
	};
cwBeliefs.beliefTrees:Register(FORTUNE)