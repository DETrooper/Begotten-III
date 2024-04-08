--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local PROWESS = cwBeliefs.beliefTrees:New("prowess")
	PROWESS.name = "Prowess";
	PROWESS.color = Color(150, 50, 20);
	PROWESS.order = 1;
	PROWESS.size = {w = 378, h = 407};
	PROWESS.textures = {"prowess", "prowessarrows"};
	PROWESS.tooltip = {
		{"Prowess", PROWESS.color, "Civ5ToolTip4"},
		{"Prowess is a measure of your character's physical strength, primarily affecting your character's melee combat effectiveness, as well as inventory capacity.", Color(225, 200, 200)},
		{"\n\"But then he visited the Dark Kingdom, and this was the point of no return. He felt in his wrist a tremble that manifested into a quake. His fibers were now thorns, his liquids boiled. He felt he would lose sight of the truth, and that he did...\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: +50% Inventory Capacity and +10% Melee Damage (Stacks w/ Other Buffs)", Color(50, 255, 50)}
	};
	PROWESS.columnPositions = {
		[1] = (PROWESS.size.w - 4) * 0.1,
		[2] = (PROWESS.size.w - 4) * 0.3,
		[3] = (PROWESS.size.w - 4) * 0.5,
		[4] = (PROWESS.size.w - 4) * 0.7,
		[5] = (PROWESS.size.w - 4) * 0.9,
	};
	PROWESS.rowPositions = {
		[1] = (PROWESS.size.h - 4) * 0.3,
		[2] = (PROWESS.size.h - 4) * 0.5,
		[3] = (PROWESS.size.h - 4) * 0.7,
		[4] = (PROWESS.size.h - 4) * 0.9,
	};
	
	PROWESS.hasFinisher = true;
	PROWESS.lockedBeliefs = {"loremaster"};
	PROWESS.lockedTraits = {"weak"};
	
	-- First index is column.
	PROWESS.beliefs = {
		[1] = {
			["halfsword_sway"] = {
				name = "Halfsword and Sway",
				description = "Unlocks the ability to change weapon stance for all weapons.",
				quote = "\"Don't you hack at that plate with your sword like some fucker joe! Stab at the joints and gaps you unenlightened fucklets!\"",
				requirements = {"fighter"},
				row = 2,
			},
			["blademaster"] = {
				name = "Blademaster",
				description = "All one handed slashing weapons and claws now deal 15% more damage.",
				iconOverride = "begotten/ui/belieficons/swordsman.png",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "halfsword_sway"},
				row = 3,
			},
			["billman"] = {
				name = "Billman",
				description = "Polearms, spears, rapiers, crossbow bolts, and javelins now deal 20% more armor piercing damage.",
				quote = "The honest soldier keeps his distance from the bloodthirsty fools who seek his demise.",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "halfsword_sway", "blademaster"},
				row = 4,
			},
		},
		[2] = {
			["parrying"] = {
				name = "Parrying",
				description = "Unlocks the 'Parry' ability for melee, which allows you to counter enemy blows and deal additional damage.",
				requirements = {"fighter"},
				row = 2,
			},
			["repulsive_riposte"] = {
				name = "Repulsive Riposte",
				description = "Riposte attack damage from successful parries is increased from 200% to 300%.";
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "parrying"},
				row = 3,
			},
		},
		[3] = {
			["fighter"] = {
				name = "Fighter",
				description = "Maximum stamina is now increased by 10 points.",
				quote = "\"Pick up that spear, boy! You'll be fighting in the Lord's army now.\"",
				row = 1,
			},
			["wrestle_subdue"] = {
				name = "Wrestle and Subdue",
				description = "Unlocks the ability to pick up foes who have been knocked over in combat, even while they are getting up.",
				quote = "\"Lose your footing and fall? I will smother you into the dirt.\"",
				requirements = {"fighter"},
				row = 2,
			},
			["warrior"] = {
				name = "Warrior",
				description = "Maximum stamina is now increased by an additional 10 points.",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "wrestle_subdue"},
				row = 3,
			},
			["master_at_arms"] = {
				name = "Master at Arms",
				description = "Maximum stamina is now increased by an additional 15 points.",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "wrestle_subdue", "warrior"},
				row = 4,
			},
		},
		[4] = {
			["deflection"] = {
				name = "Deflection",
				description = "Successful deflections (perfect blocks) now restore +15 additional points of stamina and +5 more points of stability, as well as prevent enemy attacks for 1 second.",
				requirements = {"fighter"},
				row = 2,
			},
			["sidestep"] = {
				name = "Sidestep",
				description = "Successful deflections now restore +10 more points of stamina and +5 more points of stability, and also prevents enemy attacks for an additional second.",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "deflection"},
				row = 3,
			},
		},
		[5] = {
			["strength"] = {
				name = "Strength",
				description = "Unlocks the ability to use great weapons. Also unlocks the ability to reload crossbows.",
				requirements = {"fighter"},
				row = 2,
			},
			["might"] = {
				name = "Might",
				description = "Increased inventory capacity by 50%. Deal 15% more stability damage with all melee weapons. Fists and fisted weapons now deal 20% more damage.",
				quote = "\"I smash you now!\"",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "strength"},
				row = 3,
			},
			["unrelenting"] = {
				name = "Unrelenting",
				description = "Great weapons, scythes, and two handed weapons now deal 10% more damage. All melee weapons now deal 25% more stamina damage. Removes the damage penalty for hitting multiple targets with a single swing.",
				lockedSubfactions = {"Auxiliary"},
				requirements = {"fighter", "strength", "might"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(PROWESS)