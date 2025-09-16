--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local FAMILY = cwBeliefs.beliefTrees:New("family")
	FAMILY.name = "Faith of the Family";
	FAMILY.color = Color(150, 50, 20);
	FAMILY.order = 7;
	FAMILY.size = {w = 771, h = 407};
	FAMILY.textures = {"family", "faithfamilyarrows"};
	FAMILY.headerFontOverride = "nov_IntroTextSmallaaafaa";
	FAMILY.tooltip = {
		{"Faith of the Family", FAMILY.color, "Civ5ToolTip4"},
		{"Each faith has a unique skill set, unlocking character abilities, rituals, and generally improving stats overall. One may also branch into subfaiths, though openly practicing these subfaiths may see your character deemed a heretic by the relevant religious authorities.", Color(225, 200, 200)},
		{"\n\"The holy city of Glaze in Hell's domain. These are my dual swords to be crossed, indeed over her chest in resolution to a final cause. In a beating heart of shields.\"", Color(128, 90, 90, 240)},
		{"", Color(50, 255, 50)}
	};
	FAMILY.columnPositions = {
		[1] = (FAMILY.size.w - 4) * 0.1,
		[2] = (FAMILY.size.w - 4) * 0.3,
		[3] = (FAMILY.size.w - 4) * 0.5,
		[4] = (FAMILY.size.w - 4) * 0.7,
		[5] = (FAMILY.size.w - 4) * 0.9,
	};
	FAMILY.rowPositions = {
		[1] = (FAMILY.size.h - 4) * 0.3,
		[2] = (FAMILY.size.h - 4) * 0.5,
		[3] = (FAMILY.size.h - 4) * 0.7,
		[4] = (FAMILY.size.h - 4) * 0.9,
	};
	
	FAMILY.lockedSubfactions = {"Clan Grock", "Clan Gotnarh"};
	FAMILY.requiredFaiths = {"Faith of the Family"};
	
	-- First index is column.
	FAMILY.beliefs = {
		[1] = {
			["father"] = {
				name = "Strength of the Father",
				subfaith = "Faith of the Father",
				description = "Selects the 'Faith of the Father' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Gain double faith gain from damaging and killing bears, thralls, and characters who have a higher sacrament level than you.",
				quote = "The Father is the Patriarch, the manifestation of conflict and struggle. He makes sure his children are fit to survive at all costs. The followers of the Father may be bloodthirsty and otherwise brutish, but they possess a sense of strength and honor unmatched by all.",
				lockedSubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast"},
				row = 1,
			},
			["honor_the_gods"] = {
				name = "Honor the Gods",
				subfaith = "Faith of the Father",
				description = "Unlocks Tier I Faith of the Family Rituals.",
				lockedSubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast"},
				requirements = {"father"},
				row = 2,
			},
			["man_become_beast"] = {
				name = "Man Become Beast",
				subfaith = "Faith of the Father",
				description = "Unlocks the ability to dual-wield one-handed weapons. Unlocks the ability to equip claws. Increases maximum stamina by 10 points. Increases maximum HP by 30 points. Unlocks Tier II Familial Rituals.",
				lockedSubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast"},
				requirements = {"father", "honor_the_gods"},
				row = 3,
			},
			["fearsome_wolf"] = {
				name = "Fearsome is the Wolf",
				subfaith = "Faith of the Father",
				--description = "Upgrades the 'Warcry' ability: all nearby foes will be highlighted in red for 20 seconds. You will deal 20% more damage and 15% more stamina damage against highlighted foes, as well as sprint 10% faster for a 20 second duration. Increases throwing axe damage by 15%.",
				description = "Upgrades the 'Warcry' ability: you will deal 20% more regular and stamina damage against all nearby players and NPCs, as well as sprint 10% faster for a 20 second duration. Also increases throwing axe damage by 15%.",
				quote = "\"DEATH TO THE GLAZE AND RISE TO THE GAY GORE!!!\"",
				lockedSubfactions = {"Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Crast"},
				requirements = {"father", "honor_the_gods", "man_become_beast"},
				row = 4,
			},
		},
		[2] = {
			["mother"] = {
				name = "Mercy of the Mother",
				subfaith = "Faith of the Mother",
				description = "Selects the 'Faith of the Mother' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Unlocks the ability to equip Blessed weaponry. Increased faith gain from performing rituals and healing other characters.",
				quote = "The Mother is the Matriarch, the architect of nature and the cycle of life and death. From her womb came all life, and under her watch they will all one day die. The followers of the Mother are outcasts of Gore society, deformed and stunted men, and sickly slave women. Their goal is to heal the corpse world that they inhabit, and give death to the blighted ones who gnaw at its roots.",
				lockedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Ghorst"},
				row = 1,
			},
			["one_with_the_druids"] = {
				name = "One With the Druids",
				subfaith = "Faith of the Mother",
				description = "Unlocks Tier I and Tier II Familial Rituals. Increases the effectiveness of healing items used on yourself and others by 50%.",
				lockedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Ghorst"},
				requirements = {"mother"},
				row = 2,
			},
			["gift_great_tree"] = {
				name = "Gift of the Great Tree",
				subfaith = "Faith of the Mother",
				description = "You will now passively regenerate health over time, irrespective of your wounds. This is separate from normal health regeneration and much faster. Increases your maximum HP by 25 points.",
				quote = "\"The caretakers of the Great Tree are in turn blessed with unnatural abilities. Wounds mend with their touch, dead soil sprout life with each step. All will be repaid in full when their lives end and their bodies are consumed by the Earth once more.\"",
				lockedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Ghorst"},
				requirements = {"mother", "one_with_the_druids"},
				row = 3,
			},
			["watchful_raven"] = {
				name = "Watchful is the Raven",
				subfaith = "Faith of the Mother",
				description = "Upgrades the 'Warcry' ability: Highlights all nearby friendlies (characters who recognise you) in green for 15 seconds and increases your own and their sanity and stamina by 5 points, as well as providing 10% damage resistance. Unlocks Tier III Familial Rituals and unique Mother rituals. Unlocks the ability to Ravenspeak if you are a Clan Crast Goreic Warrior. Reduces the chance of receiving injuries by 50%.",
				lockedSubfactions = {"Clan Gore", "Clan Harald", "Clan Reaver", "Clan Shagalax", "Clan Ghorst"},
				requirements = {"mother", "one_with_the_druids", "gift_great_tree"},
				row = 4,
			},
		},
		[3] = {
			["old_son"] = {
				name = "Wisdom of the Old Son",
				subfaith = "Faith of the Old Son",
				description = "Selects the 'Faith of the Old Son' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Increased residual faith gain. Gain +50% faith gain from killing thralls and bears.",
				quote = "The Old Son is the bringer of war, the deity of conquest and the manifestation of the endless sea. Those born under Him are restless souls, always seeking to better themselves and laugh in the face of unbeatable odds. The old and tested Haralder Clan have sailed the world, conquering hellish landscapes and returning with mighty spoils. They are the challengers, the demon slayers, the adventurers, and the inheritors of fortune. Yet perhaps they could be much more, for the Old Son stirs in the endless depths, and his wakening could bring about a flood that would drown civilization and the burden of humanity with it.",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax"},
				row = 1,
			},
			["the_black_sea"] = {
				name = "The Black Sea",
				subfaith = "Faith of the Old Son",
				description = "Significantly increases the effectiveness of senses and allows it to be used when not equipped, also meaning they must manually be toggled. Nearby traps will be highlighted when using senses. Greatly decreases oxygen loss, allowing you to stay underwater for three times longer. Unlocks Tier I Familial Rituals.",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax"},
				requirements = {"old_son"},
				row = 2,
			},
			["taste_of_blood"] = {
				name = "Taste of Blood",
				subfaith = "Faith of the Old Son",
				description = "Increases your maximum HP by 30 points. Upon dealing damage to a character, they will be highlighted in red for 3 minutes. During this time you will deal 15% additional damage to them. You may only track one person at a time.",
				quote = "\"I taste your blood. It is a good taste! Run, flee, and I hunt. Your bones will be buried in these woods.\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax"},
				requirements = {"old_son", "the_black_sea"},
				row = 3,
			},
			["daring_trout"] = {
				name = "Daring is the Trout",
				subfaith = "Faith of the Old Son",
				description = "Upgrades the 'Warcry' ability: increases your melee armor piercing damage by 10 points for 20 seconds. Increases throwing axe damage by 25%. Increases armor-piercing damage of throwables by 10%. Hitting enemies with throwable weapons will discombobulate them, preventing them from sprinting for 8 seconds. Unlocks Tier II Familial Rituals and unique Old Son rituals. If a member of Clan Harald, Ravens will now notify you if your Longship is under attack.",
				quote = "\"We have sailed to this foreign land to murder and pillage! Will you not fight us, cowards? Will you not join the corpse pile?\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Shagalax"},
				requirements = {"old_son", "the_black_sea", "taste_of_blood"},
				row = 4,
			},
		},
		[4] = {
			["young_son"] = {
				name = "Ingenuity of the Young Son",
				subfaith = "Faith of the Young Son",
				description = "Selects the 'Faith of the Young Son' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Increased faith gain from crafting.",
				quote = "The Young Son is the deity of innovation, the source of all metal and fire, and the defiler of natural law. Those who follow the Young Son are seen as stoic, stubborn men who keep to themselves. They are also known to have molten iron in their blood, which tempers their steel as they forge mighty weapons. The Father, in his constant disapproval of his youngest offspring, places the Young Son on a path towards familial turmoil in an effort to prove the strength of his ingenuity. He beckons his human followers - whom he has shown much appreciation for in spite of the other deities - to aid him on his path to kill the Father and complete the prophecy of ruination and rebirth.",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Ghorst"},
				row = 1,
			},
			["taste_of_iron"] = {
				name = "Taste of Iron",
				subfaith = "Faith of the Young Son",
				description = "All crafted items will be in perfect condition, regardless of the condition of component parts. Unlocks Tier I Familial Rituals. Increases burn damage resistance by 50%. Also negates all damage from environmental fires.",
				quote = "\"You cannot burn that which is boiling.\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Ghorst"},
				requirements = {"young_son"},
				row = 2,
			},
			["shieldwall"] = {
				name = "Shieldwall",
				subfaith = "Faith of the Young Son",
				description = "Increases maximum HP by 25 points. Removes weapon damage penalty from using shields entirely. Increases stamina resistance of all shields by 10 points.",
				quote = "\"The Shagalaxians believe that the only thing that separates man from beast is the metal in their hands. When a man tosses aside their iron, they are little more than game to be hunted.\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Ghorst"},
				requirements = {"young_son", "taste_of_iron"},
				row = 3,
			},
			["enduring_bear"] = {
				name = "Enduring is the Bear",
				subfaith = "Faith of the Young Son",
				description = "Unlocks the ability to smelt Shagalaxian steel (if Master Blacksmith is unlocked). Increases maximum stability by 25 points. Decreases chance of injury by 20%. Decreases fatigue gain by 50%.",
				quote = "\"I will not rest until the sky is darkened in grey fog: when our engines are built, when our steel titans groan, when all is crushed under our rolling wheels. A new god! Tempered in hellfire and quenched in blood! Shag-a-lax! Shag-a-lax!\"",
				iconOverride = "begotten/ui/belieficons/bestial.png",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Reaver", "Clan Harald", "Clan Ghorst"},
				requirements = {"young_son", "taste_of_iron", "shieldwall"},
				row = 4,
			},
		},
		[5] = {
			["sister"] = {
				name = "Cunning of the Sister",
				subfaith = "Faith of the Sister",
				description = "Selects the 'Faith of the Sister' as your subfaith. Unlocks the ability to pray. Unlocks the ability to warcry. Gain increased faith gain from damaging, killing, and selling into slavery characters who have a lower faith level than you.",
				quote = "The Sister is the daughter of ambition, the trickster goddess of cunning and schemes. Her followers are hateful and malcontent, always seeking to usurp power wherever possible. Clan Reaver, the chosen Clan of the Sister, is said to have an impenetrable fortress deep in the Goreic Kingdoms where men are tortured and flayed to empower their goddess. The other Clans see Her followers as an ill omen, their coming being the final ruination of the world and the destruction of the Family as a whole. Many suspect that the Sister is not actually a member of the Family but a twisted proxy idol of the Dark Prince. It is unlikely that their assumptions are incorrect.",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Ghorst"},
				row = 1,
			},
			["witch_druid"] = {
				name = "Witch Druid",
				subfaith = "Faith of the Sister",
				description = "Unlocks the ability to dual-wield one-handed weapons. Unlocks the ability to equip claws. Unlocks Tier I Faith of the Family and Faith of the Dark rituals.",
				quote = "\"Beware the wicker man.\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Ghorst"},
				requirements = {"sister"},
				row = 2,
			},
			["shedskin"] = {
				name = "Shedskin",
				subfaith = "Faith of the Sister",
				description = "Increases maximum health by 25 points. Increases protection value of all armor by 15%. Unlocks Tier II Faith of the Family and Faith of the Dark rituals, as well as unique Sister rituals. Also unlocks the ability to darkwhisper.",
				quote = "\"Under their black iron plates they are cushioned with the hides of flayed men. If we are to kill these brutes, you must thrust deep!\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Ghorst"},
				requirements = {"sister", "witch_druid"},
				row = 3,
			},
			["deceitful_snake"] = {
				name = "Deceitful is the Snake",
				subfaith = "Faith of the Sister",
				description = "Upgrades the 'Warcry' ability: restores 70% of all HP lost within the last 2 seconds. If someone deals 10 or more points of damage to you in a single blow, they will be highlighted in red and receive 25% more damage from you for 40 seconds. Also unlocks the ability to smelt Hellforged Steel (only if 'Master Blacksmith' is also unlocked).",
				quote = "\"You will scream, and then you will have no tongue. You will gurgle and then choke. From a tree you will be hung, and your flesh will be made into a cloak.\"",
				lockedSubfactions = {"Clan Gore", "Clan Crast", "Clan Shagalax", "Clan Harald", "Clan Ghorst"},
				requirements = {"sister", "witch_druid", "shedskin"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(FAMILY)
