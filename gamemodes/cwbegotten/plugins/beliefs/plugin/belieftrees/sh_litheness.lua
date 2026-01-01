--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local LITHENESS = cwBeliefs.beliefTrees:New("litheness")
	LITHENESS.name = "Litheness";
	LITHENESS.color = Color(100, 70, 70);
	LITHENESS.order = 4;
	LITHENESS.size = {w = 258, h = 407};
	LITHENESS.textures = {"litheness", "lithenessarrows"};
	LITHENESS.tooltip = {
		{"Litheness", LITHENESS.color, "Civ5ToolTip4"},
		{"Litheness is a measurement of the indirection and deviousness of your character, as well as their flexibility and speed. Upgrading this belief tree will allow your character to become a master of stealth, thievery, and trickery, as well as increasing sprint speed and unlocking dodges.", Color(225, 200, 200)},
		{"\n\"Flay the fool who falters in their step. Let them run naked, flesh unsheathed, while shadowy eyes cast judgement to their sluggish speed.\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: +5% sprint speed, +15 maximum stability points, and 20% increased stability regeneration rate.", Color(50, 255, 50)}
	};
	LITHENESS.columnPositions = {
		[1] = (LITHENESS.size.w - 4) * 0.3,
		[2] = (LITHENESS.size.w - 4) * 0.5,
		[3] = (LITHENESS.size.w - 4) * 0.7,
	};
	LITHENESS.rowPositions = {
		[1] = (LITHENESS.size.h - 4) * 0.3,
		[2] = (LITHENESS.size.h - 4) * 0.5,
		[3] = (LITHENESS.size.h - 4) * 0.7,
		[4] = (LITHENESS.size.h - 4) * 0.9,
	};
	
	LITHENESS.hasFinisher = true;
	
	-- First index is column.
	LITHENESS.beliefs = {
		[1] = {
			["sly_fidget"] = {
				name = "Sly Fidget",
				description = "Unlocks the 'Lockpicking' mechanic.",
				requirements = {"nimble"},
				row = 2,
			},
			["safecracker"] = {
				name = "Safecracker",
				description = "You can now lockpick Tier III locks.",
				requirements = {"nimble", "sly_fidget"},
				row = 3,
			},
			["thief"] = {
				name = "Thief",
				description = "Lockpicking is now easier.",
				quote = "A serf toils, a thief collects.",
				requirements = {"nimble", "sly_fidget", "safecracker"},
				row = 4,
			},
		},
		[2] = {
			["nimble"] = {
				name = "Nimble",
				description = "Movement while crouched is now silent and speedy. Reduces the range that thralls can see you when crouched.",
				row = 1,
			},
		},
		[3] = {
			["evasion"] = {
				name = "Evasion",
				description = "Unlocks the 'Combat Roll' ability. Combat rolling grants invincibility frames based on the weight of armor worn and can also put out fires.",
				requirements = {"nimble"},
				row = 2,
			},
			["dexterity"] = {
				name = "Dexterity",
				description = "All progress bar actions including raising weapons, reloading, and standing up now complete 33% faster. Doubles the speed at which you aim down sights with ranged weapons. Unlocks the abiility to run safely with a full bucket of liquid.",
				requirements = {"nimble", "evasion"},
				row = 3,
			},
			["swift"] = {
				name = "Swift",
				description = "Sprinting is now 10% faster.",
				requirements = {"nimble", "evasion", "dexterity"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(LITHENESS)