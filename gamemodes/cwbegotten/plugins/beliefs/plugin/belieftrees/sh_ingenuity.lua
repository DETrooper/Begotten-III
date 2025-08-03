--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local INGENUITY = cwBeliefs.beliefTrees:New("ingenuity")
	INGENUITY.name = "Ingenuity";
	INGENUITY.color = Color(80, 70, 50);
	INGENUITY.order = 5;
	INGENUITY.size = {w = 378, h = 407};
	INGENUITY.textures = {"ingenuity", "ingenuityarrows"};
	INGENUITY.tooltip = {
		{"Ingenuity", INGENUITY.color, "Civ5ToolTip4"},
		{"Ingenuity is a measure of your character's craftiness, primarily affecting your character's effectiveness at Crafting. Upgrading this belief set will progressively unlock more crafting options. More Crafting options may become available if this belief set is paired with aptitude. As your sacrament level increases, your crafted equipment will have increased condition.", Color(225, 200, 200)},
		{"\n\"Bobby all proud 'an cool with that 'ol apparatus back in the truck that laid him out with sweet social status, far from junior status. It be the saddest machine but nice with molasses in the power gauge, as well as the mathematics and administrative tactics.\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: Reduces armor and weapon condition decay by a further 45%. Increases the protection value of all armor by 5 points.", Color(50, 255, 50)}
	};
	INGENUITY.columnPositions = {
		[1] = (INGENUITY.size.w - 4) * 0.1,
		[2] = (INGENUITY.size.w - 4) * 0.3,
		[3] = (INGENUITY.size.w - 4) * 0.5,
		[4] = (INGENUITY.size.w - 4) * 0.7,
		[5] = (INGENUITY.size.w - 4) * 0.9,
	};
	INGENUITY.rowPositions = {
		[1] = (INGENUITY.size.h - 4) * 0.3,
		[2] = (INGENUITY.size.h - 4) * 0.5,
		[3] = (INGENUITY.size.h - 4) * 0.7,
		[4] = (INGENUITY.size.h - 4) * 0.9,
	};
	
	INGENUITY.hasFinisher = true;
	
	-- First index is column.
	INGENUITY.beliefs = {
		[1] = {
			["cookist"] = {
				name = "Cookist",
				description = "Unlocks the crafting of cookable items.",
				requirements = {"ingenious"},
				row = 2,
			},
			["culinarian"] = {
				name = "Culinarian",
				description = "Unlocks master cooking recipes.",
				requirements = {"ingenious", "cookist"},
				row = 3,
			},
		},
		[2] = {
			["powder_and_steel"] = {
				name = "Powder and Steel",
				description = "Unlocks the ability to load firearms.",
				quote = "\"Almighty creator, deity, holiness, idol of mine. Give me power, spirit, allegiance with those who have disbanded from my ordnance of an army. Divine overseer, universal forces be with me. And for those demons, fight back in means to protect Hard-Glaze and society from its inevitable destruction. Dump the spiritual trophies for now, and unload the ammunitions to purify these unfaithful sinners of the land. Stockpile the explosives, magazine the rifles, warehouse the vehicles, but most of all, plant the inflorescence of Hard-Glaze society inside the dirt for future generations to come.\" - Lord Maximus XII",
				iconOverride = "begotten/ui/belieficons/blessed_powder.png",
				lockedSubfactions = {"Knights of Sol", "Clan Gore", "Clan Reaver", "Clan Harald", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"},
				requirements = {"ingenious"},
				row = 2,
			},
			["pistolier"] = {
				name = "Pistolier",
				description = "Massively reduces misfire chance for all firearms and prevents them from exploding.",
				lockedSubfactions = {"Knights of Sol", "Clan Gore","Clan Reaver", "Clan Harald", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"},
				requirements = {"ingenious", "powder_and_steel"},
				row = 3,
			},
			["marksman"] = {
				name = "Marksman",
				description = "Greatly increases accuracy while standing still for all crossbows and firearms.",
				lockedSubfactions = {"Knights of Sol", "Clan Gore", "Clan Reaver", "Clan Harald", "Clan Grock", "Clan Gotnarh", "Clan Ghorst"},
				requirements = {"ingenious", "powder_and_steel", "pistolier"},
				row = 4,
			},
		},
		[3] = {
			["ingenious"] = {
				name = "Ingenious",
				description = "Unlocks the 'Crafting' mechanic and the ability to interact with traps. Unlocks the ability to utilize equipped lanterns as a light source on your hip.",
				row = 1,
			},
			["craftsman"] = {
				name = "Craftsman",
				description = "Unlocks Tier II of crafting.",
				requirements = {"ingenious"},
				row = 2,
			},
			["mechanic"] = {
				name = "Mechanic",
				description = "Unlocks Tier III of crafting. Unlocks the ability to repair non-broken items by merging them in the inventory menu.",
				requirements = {"ingenious", "craftsman"},
				row = 3,
			},
			["artisan"] = {
				name = "Artisan",
				description = "Unlocks the crafting of masterworks. Also unlocks the ability to repair broken items.",
				requirements = {"ingenious", "craftsman", "mechanic"},
				row = 4,
			},
		},
		[4] = {
			["smith"] = {
				name = "Smith",
				description = "Unlocks the ability to smelt Iron via crafting. Also unlocks the ability to melt down metal items at forges.",
				iconOverride = "begotten/ui/belieficons/blacksmith.png",
				requirements = {"ingenious"},
				row = 2,
			},
			["blacksmith"] = {
				name = "Blacksmith",
				description = "Unlocks the ability to smelt Steel and Gold via crafting.",
				requirements = {"ingenious", "smith"},
				row = 3,
			},
			["master_blacksmith"] = {
				name = "Master Blacksmith",
				description = "Unlocks the ability to smelt Fine Steel via crafting.",
				iconOverride = "begotten/ui/belieficons/blacksmith.png",
				requirements = {"ingenious", "smith", "blacksmith"},
				row = 4,
			},
		},
		[5] = {
			["fortify_the_plate"] = {
				name = "Fortify the Plate",
				description = "Increases the protection value of all armor by 5 points.",
				iconOverride = "begotten/ui/belieficons/hauberk.png",
				requirements = {"ingenious"},
				row = 2,
			},
			["scour_the_rust"] = {
				name = "Scour the Rust",
				description = "Reduces armor and weapon condition decay by 35%.",
				requirements = {"ingenious", "fortify_the_plate"},
				row = 3,
			},
		},
	};
cwBeliefs.beliefTrees:Register(INGENUITY)
