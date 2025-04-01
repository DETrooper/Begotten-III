--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local APTITUDE = cwBeliefs.beliefTrees:New("aptitude")
	APTITUDE.name = "Aptitude";
	APTITUDE.color = Color(107, 92, 77)
	APTITUDE.order = 8;
	APTITUDE.size = {w = 378, h = 407};
	APTITUDE.textures = {"aptitude", "aptitudearrows"};
	APTITUDE.tooltip = {
		{"Aptitude", APTITUDE.color, "Civ5ToolTip4"},
		{"Aptitude is a measure of your character's intellect, affecting your character's literacy, effectiveness at alchemy, and effectiveness as a healer. Upgrading this belief set will unlock new ways to learn and adapt, become a skilled doctor or alchemist, as well as unlocking the ability to read.", Color(225, 200, 200)},
		{"\n\"Do not taint the legacy of Hard-Glaze if you cannot bear to sustain code.\"\nHer voice was no murmur, but a bold challenge to all who opposed.\n\"Was that the final testimony? Transcendence has brought me closer, resonating in a ray of almighty God's newfound hope.\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: +75% Faith gain from all sources.", Color(50, 255, 50)},
	};
	APTITUDE.columnPositions = {
		[1] = (APTITUDE.size.w - 4) * 0.1,
		[2] = (APTITUDE.size.w - 4) * 0.3,
		[3] = (APTITUDE.size.w - 4) * 0.5,
		[4] = (APTITUDE.size.w - 4) * 0.7,
		[5] = (APTITUDE.size.w - 4) * 0.9,
	};
	APTITUDE.rowPositions = {
		[1] = (APTITUDE.size.h - 4) * 0.3,
		[2] = (APTITUDE.size.h - 4) * 0.5,
		[3] = (APTITUDE.size.h - 4) * 0.7,
		[4] = (APTITUDE.size.h - 4) * 0.9,
	};
	
	APTITUDE.hasFinisher = true;
	APTITUDE.lockedTraits = {"blind"};
	
	-- First index is column.
	APTITUDE.beliefs = {
		[1] = {
			["precise_measurements"] = {
				name =  "Precise Measurements",
				description = "It is now impossible to fail a concoction.",
				requirements = {"literacy", "alchemist"},
				row = 3,
				disabled = true,
			},
			["blood_nectar"] = {
				name = "Blood Nectar",
				description = "Your concoctions are now significantly more potent.",
				requirements = {"literacy", "alchemist", "precise_measurements"},
				row = 4,
				disabled = true,
			},
		},
		[2] = {
			["alchemist"] = {
				name = "Alchemist",
				description = "Unlocks the 'Alchemy' mechanic.",
				requirements = {"literacy"},
				row = 2,
				disabled = true,
			},
			["chemist"] = {
				name = "Chemist",
				description = "Unlocks Tier II concoctions.",
				requirements = {"literacy", "alchemist"},
				row = 3,
				disabled = true,
			},
			["scientist"] = {
				name = "Scientist",
				description = "Unlocks Tier III concoctions.",
				requirements = {"literacy", "alchemist", "chemist"},
				row = 4,
				disabled = true,
			},
		},
		[3] = {
			["literacy"] = {
				name = "Literacy",
				description = "Unlocks the ability to read. Gain a moderate amount of faith for each unique scripture read (up to a maximum of 8).",
				row = 1,
			},
			["scribe"] = {
				name = "Scribe",
				description = "Unlocks the ability to copy scriptures. Gain an abundance of faith for every unique scripture copied (halved for subsequent copies).",
				requirements = {"literacy"},
				row = 2,
			},
			["anthropologist"] = {
				name = "Anthropologist",
				description = "Unlocks the ability to read and copy Runic and Darklander texts.",
				requirements = {"literacy", "scribe"},
				row = 3,
			},
			["loremaster"] = {
				name = "Loremaster",
				--description = "Increases your sacrament level cap by 10 but locks the 'Prowess' tree. Any epiphanies invested in 'Prowess' will be refunded.",
				description = "Increases your sacrament level cap by 10 but locks the Tier III and IV beliefs of the 'Prowess' tree. Any epiphanies invested in these will be refunded.",
				quote = "Throw away your desires. Toss aside your warrior spirit. You are a beacon of knowledge. Let the young fools squabble and die. Become all-knowing, and wisdom will be your weapon.",
				requirements = {"literacy", "scribe", "anthropologist"},
				row = 4,
			},
		},
		[4] = {
			["sanitary"] = {
				name = "Sanitary",
				description = "Significantly reduces the chances of catching a disease or infection, and entirely eliminates the risk of catching diseases from handling corpses.",
				quote = "Insanitation of the mind is the root cause of insanity; insanitation of the body is the root cause of affliction.",
				requirements = {"literacy"},
				row = 2,
			},
			["doctor"] = {
				name = "Doctor",
				description = "Unlocks the ability to diagnose a patient's injuries. Doubles the speed of healing other characters as well as the speed of applying chloroform.",
				requirements = {"literacy", "sanitary"},
				row = 3,
			},
			["surgeon"] = {
				name = "Surgeon",
				description = "Unlocks the ability to perform operations to treat advanced injuries.",
				requirements = {"literacy", "sanitary", "doctor"},
				row = 4,
			},
		},
		[5] = {
			["medicine_man"] = {
				name = "Medicine Man",
				description = "Triples the effectiveness of healing items when used on other characters. Increases the effectiveness of healing items on yourself by 70%.",
				requirements = {"literacy", "sanitary"},
				row = 3,
			},
			["plague_doctor"] = {
				name = "Plague Doctor",
				description = "Unlocks the ability to create a cure for the Begotten Plague. Also unlocks the ability to craft Plague Doctor Outfit and wear it.",
				requirements = {"literacy", "sanitary", "medicine_man"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(APTITUDE)