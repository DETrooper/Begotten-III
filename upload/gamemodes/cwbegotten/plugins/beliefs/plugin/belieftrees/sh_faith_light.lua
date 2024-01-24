--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local LIGHT = cwBeliefs.beliefTrees:New("light")
	LIGHT.name = "Faith of the Light";
	LIGHT.color = Color(255, 215, 0);
	LIGHT.order = 7;
	LIGHT.size = {w = 771, h = 407};
	LIGHT.textures = {"light", "faithlightarrows"};
	LIGHT.headerFontOverride = "nov_IntroTextSmallaaafaa";
	LIGHT.tooltip = {
		{"Faith of the Light", LIGHT.color, "Civ5ToolTip4"},
		{"Each faith has a unique skill set, unlocking character abilities, rituals, and generally improving stats overall. One may also branch into subfaiths, though openly practicing these subfaiths may see your character deemed a heretic by the relevant religious authorities.", Color(225, 200, 200)},
		{"\n\"The holy city of Glaze in Hell's domain. These are my dual swords to be crossed, indeed over her chest in resolution to a final cause. In a beating heart of shields.\"", Color(128, 90, 90, 240)},
		{"", Color(50, 255, 50)}
	};
	LIGHT.columnPositions = {
		[1] = (LIGHT.size.w - 4) * 0.133,
		[2] = (LIGHT.size.w - 4) * 0.2,
		[3] = (LIGHT.size.w - 4) * 0.266,
		[4] = (LIGHT.size.w - 4) * 0.433,
		[5] = (LIGHT.size.w - 4) * 0.5,
		[6] = (LIGHT.size.w - 4) * 0.566,
		[7] = (LIGHT.size.w - 4) * 0.733,
		[8] = (LIGHT.size.w - 4) * 0.8,
		[9] = (LIGHT.size.w - 4) * 0.866,
	};
	LIGHT.rowPositions = {
		[1] = (LIGHT.size.h - 4) * 0.3,
		[2] = (LIGHT.size.h - 4) * 0.5,
		[3] = (LIGHT.size.h - 4) * 0.7,
		[4] = (LIGHT.size.h - 4) * 0.9,
	};
	
	LIGHT.lockedSubfactions = {"Clan Grock"};
	LIGHT.requiredFaiths = {"Faith of the Light"};
	
	-- First index is column.
	LIGHT.beliefs = {
		[1] = {
			["repentant"] = {
				name = "Repentant",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier I 'Faith of the Light' Rituals. Unlocks the ability to equip Sol Orthodoxy armors and sacrificial weapons, as well as the ability to dual-wield one-handed weapons.",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy"},
				row = 2,
			},
			["flagellant"] = {
				name = "Flagellant",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier II 'Faith of the Light' Rituals. Unlocks the ability to self-flagellate.",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy", "repentant"},
				row = 3,
			},
			["extinctionist"] = {
				name = "Extinctionist",
				subfaith = "Sol Orthodoxy",
				description = "Unlocks Tier III 'Faith of the Light' Rituals and unique Sol Orthodoxy Rituals. While on fire, your melee attacks will ignite any hit enemy even if they are blocking (not counting deflections/parries).",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy", "repentant", "flagellant"},
				row = 4,
			},
		},
		[2] = {
			["sol_orthodoxy"] = {
				name = "Sol Orthodoxy",
				subfaith = "Sol Orthodoxy",
				description = "Selects 'Sol Orthodoxy' as your subfaith. Unlocks the ability to pray. Unlocks the ability to commit suicide. Unlocks faith gain for each point of damage inflicted upon you. Faith gain from all sources will be increased slightly if your hunger or thirst values are below 40%, moreso if both are.",
				quote = "Sol Orthodoxy is a corruption of the traditional Glazic beliefs. It dictates that no mortal being will ever achieve enlightenment as long as they still draw breath. Men are encouraged to repent for the terrible sinful nature they exhibit, through flagellation and even suicide. The Glaze of Sol will shine again, but only when there are no living eyes to see it.",
				iconOverride = "begotten/ui/belieficons/faith-traditionalist.png",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				row = 1,
			},
		},
		[3] = {
			["prison_of_flesh"] = {
				name = "This Prison of Flesh",
				subfaith = "Sol Orthodoxy",
				description = "Taking damage from any damage source, starting at a minimum of 10 damage, will reduce Corruption by half of the amount of damage taken. If possessed, corruption will not be reduced until it is above 50%.",
				quote = "\"Let the demons come to this prison of flesh! I will punish them, show them agony, and never will I give in to their desires!\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy"},
				row = 2,
			},
			["purity_afloat"] = {
				name = "Purity Afloat",
				subfaith = "Sol Orthodoxy",
				description = "Increases movement speed by a maximum of 20% (at 25% health) the lower your health is, but only when not wearing heavy armor.",
				quote = "\"Unburden the shackles of the material. Strike yourself naked and true. Relinquish and be set purity afloat.\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy", "prison_of_flesh"},
				row = 3,
			},
			["fanaticism"] = {
				name = "Fanaticism",
				subfaith = "Sol Orthodoxy",
				description = "Increases melee, stamina, and stability damage by a maximum of 50% (at 10% health) the lower your health is.",
				quote = "\"PURITY THROUGH PAIN! EXTINCTION THROUGH SACRIFICE! THE BELLS TOLL FOR ALL!\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Holy Hierarchy"},
				lockedSubfactions = {"Praeventor"},
				requirements = {"sol_orthodoxy", "prison_of_flesh", "purity_afloat"},
				row = 4,
			},
		},
		[4] = {
			["disciple"] = {
				name = "Disciple",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier I 'Faith of the Light' Rituals.",
				requirements = {"hard_glazed"},
				row = 2,
			},
			["acolyte"] = {
				name = "Acolyte",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier II 'Faith of the Light' Rituals.",
				requirements = {"hard_glazed", "disciple"},
				row = 3,
			},
			["emissary"] = {
				name = "Emissary",
				subfaith = "Hard-Glazed",
				description = "Unlocks Tier III 'Faith of the Light' Rituals and unique Hard-Glazed Rituals. Also unlocks the ability to smelt Maximilian Steel (only if 'Master Blacksmith' is also unlocked).",
				requirements = {"hard_glazed", "disciple", "acolyte"},
				row = 4,
			},
		},
		[5] = {
			["hard_glazed"] = {
				name = "Hard-Glazed",
				subfaith = "Hard-Glazed",
				description = "Selects 'Hard-Glazed' as your subfaith. Unlocks the ability to pray. Faith gained from making large donations of Coin to the Church.",
				quote = "Chastity and almsgiving are the core principles of the Hard-Glazed ideology. All is forfeit to the Holy Hierarchy, and one must expect only a dull life fraught with toiling to thy Minister. Yet those in the Hierarchy follow the Manifesto, and hidden in its pages lies the key to heavenly ascension.",
				iconOverride = "begotten/ui/belieficons/faith-glaze.png",
				row = 1,
			},
		},
		[6] = {
			["the_light"] = {
				name = "The Light",
				subfaith = "Hard-Glazed",
				description = "Unlocks the ability to equip certain 'Faith of the Light' sacrificial weapons. All melee and throwable weapons now deal 15% more armor-piercing damage.",
				quote = "\"The Glaze is the light... it is the truth - you cannot see it in perspective as it is you; your foolishness, greatness, your power...\"",
				requirements = {"hard_glazed"},
				row = 2,
			},
			["blessed_powder"] = {
				name = "Blessed Powder",
				subfaith = "Hard-Glazed",
				description = "All firearms now deal 25% more damage.",
				quote = "Lord Maximus shouted with his thunderous voice \"Give them the steel\", and so, the steel was given.",
				iconOverride = "begotten/ui/belieficons/blessed_powder2.png",
				requirements = {"hard_glazed", "the_light"},
				row = 3,
			},
			["manifesto"] = {
				name = "All Links to the Manifesto",
				subfaith = "Hard-Glazed",
				description = "You now deal 25% more damage against characters of another Faith, but deal 15% less damage against those of the same Faith. Replaces the effect of the 'Grounded' attribute on melee weapons to do 60% less melee damage while sprinting instead of disallowing melee attacks while sprinting outright.",
				quote = "\"There is only Glaze. Corpse the fucklets indeed!\"",
				iconOverride = "begotten/ui/belieficons/loremaster.png",
				requirements = {"hard_glazed", "the_light", "blessed_powder"},
				row = 4,
			},
		},
		[7] = {
			["wire_therapy"] = {
				name = "Wire Therapy",
				subfaith = "Voltism",
				description = "Unlocks the ability to Relay to send messages to all other Voltists globally. Unlocks Tier I 'Voltism' crafting recipes.",
				quote = "Looks like Shaye needs to spend more time on the wires.",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism"},
				row = 2,
			},
			["jacobs_ladder"] = {
				name = "Jacob's Ladder",
				subfaith = "Voltism",
				description = "Unlocks Tier II 'Voltism' crafting recipes. Unlocks the ability to consume 'Tech' items, which will decrease corruption and increase your energy, as well as providing a substantial amount of faith (XP). Benefits from consuming 'Tech' items scale with the condition of the item. Lowers maximum health by 5 points.",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism", "wire_therapy"},
				row = 3,
			},
			["the_paradox_riddle_equation"] = {
				name = "The Paradox Riddle Equation",
				subfaith = "Voltism",
				description = "Unlocks Tier III 'Voltism' crafting recipes. At this point, you will not be able to communicate regularly as your voice will forever be altered. Unlocks the ability to apply 'Tech' items to limbs to fully heal them of injuries. Grants immunity to all diseases. Standing in any body of water or ingesting water will now deal a great amount of electric damage to you. Lowers maximum health by 5 points.",
				quote = "\"The Paradox Riddle Equation, or the Brainfucker Paradox, refers to a terrible event in Holy Hierarchy history. A disease of the mind that originated as a simple set of questions and mathematical equations spread through the noble households and wreaked havoc across the Districts for a six-year period in recent memory. It is noted that the marble palaces of District One were covered in red splotches as a result of noble stature slamming their heads on the walls out of frustration and utter confusion. This is perhaps the only 'plague' in Holy Hierarchy history that had only affected the upper classes, as the common folk were blissfully unaware of the far-reaching indications that came with the Riddle Equation, as of course they were too simple-minded to understand it. The Paradox Riddle Equation has since been scrubbed from Glazic memory by authorities, but it has recently been given new light by the Voltists who claim to have found the answer - at the cost of their humanity.\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism", "wire_therapy", "jacobs_ladder"},
				row = 4,
			},
		},
		[8] = {
			["voltism"] = {
				name = "Voltism",
				subfaith = "Voltism",
				description = "Selects 'Voltism' as your subfaith. Unlocks the ability to pray. Unlocks the 'Self-Electrocution' ability to gain sanity. Gain increased faith gain from killing characters of the 'Hard-Glazed' or 'Sol Orthodoxy' subfaiths.",
				quote = "An infestation seeking to consume the Light from within is how ministers of the Holy Hierarchy would describe Voltism. A major cult with no chain of command who seek technology and enlightenment through transhumanism. They gradually replace more of their body with machine and stimulate their minds with electrical shocks. Their true motives, or their leader, remain unknown.",
				iconOverride = "begotten/ui/belieficons/faith-volt.png",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				row = 1,
			},
		},
		[9] = {
			["wriggle_fucking_eel"] = {
				name = "Wriggle Like a Fucking Eel",
				subfaith = "Voltism",
				description = "Self-Electrocution now cauterizes bleeding and decreases fatigue and corruption. Unlocks the ability to use Voltist weaponry.",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism"},
				row = 2,
			},
			["yellow_and_black"] = {
				name = "Yellow and Black",
				subfaith = "Voltism",
				description = "Unlocks the ability to equip Voltist weaponry and exoskeletons. You are no longer affected by hunger and thirst. Instead, your fatigue value will begin to damage you if left unchecked. You can only decrease fatigue through electrocution or the consumption of Tech items. Lowers maximum health by 5 points. ",
				quote = "\"Can you hear the hum? P-Press your face into the barbs! Take notice of the yellow and black banner...\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism", "wriggle_fucking_eel"},
				row = 3,
			},
			["the_storm"] = {
				name = "The Storm",
				subfaith = "Voltism",
				description = "At this point, you will not be able to communicate regularly as your voice will forever be altered. Electric damage attacks from Voltist weapons now deal increased damage and stability damage against enemies in metallic armor, with more damage being dealt the heavier the armor. Standing in any body of water or ingesting water will now deal a great amount of electric damage to you. Lowers maximum health by 5 points.",
				quote = "\"THE ELECTRIC ONE WILL RETURN FOR US!\"",
				lockedFactions = {"Pope Adyssa's Gatekeepers", "Gatekeeper", "Holy Hierarchy"},
				lockedSubfactions = {"Machinist"};
				requirements = {"voltism", "wriggle_fucking_eel", "yellow_and_black"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(LIGHT)