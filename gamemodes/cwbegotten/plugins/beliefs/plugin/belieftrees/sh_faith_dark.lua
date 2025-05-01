--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local DARK = cwBeliefs.beliefTrees:New("dark")
	DARK.name = "Faith of the Dark";
	DARK.color = Color(137, 0, 0, 255);
	DARK.order = 7;
	DARK.size = {w = 771, h = 407};
	DARK.textures = {"dark", "faithdarkarrows"};
	DARK.headerFontOverride = "nov_IntroTextSmallaaafaa";
	DARK.tooltip = {
		{"Faith of the Dark", DARK.color, "Civ5ToolTip4"},
		{"Each faith has a unique skill set, unlocking character abilities, rituals, and generally improving stats overall. One may also branch into subfaiths, though openly practicing these subfaiths may see your character deemed a heretic by the relevant religious authorities.", Color(225, 200, 200)},
		{"\n\"The holy city of Glaze in Hell's domain. These are my dual swords to be crossed, indeed over her chest in resolution to a final cause. In a beating heart of shields.\"", Color(128, 90, 90, 240)},
		{"", Color(50, 255, 50)}
	};
	DARK.columnPositions = {
		[1] = (DARK.size.w - 4) * 0.1,
		[2] = (DARK.size.w - 4) * 0.2,
		[3] = (DARK.size.w - 4) * 0.3,
		[4] = (DARK.size.w - 4) * 0.5,
		[5] = (DARK.size.w - 4) * 0.55,
		[6] = (DARK.size.w - 4) * 0.6,
		[7] = (DARK.size.w - 4) * 0.7,
		[8] = (DARK.size.w - 4) * 0.8,
		[9] = (DARK.size.w - 4) * 0.85,
		[10] = (DARK.size.w - 4) * 0.9,
	};
	DARK.rowPositions = {
		[1] = (DARK.size.h - 4) * 0.3,
		[2] = (DARK.size.h - 4) * 0.5,
		[3] = (DARK.size.h - 4) * 0.7,
		[4] = (DARK.size.h - 4) * 0.9,
	};
	
	DARK.lockedSubfactions = {"Clan Grock"};
	DARK.requiredFaiths = {"Faith of the Dark"};
	
	-- First index is column.
	DARK.beliefs = {
		[1] = {
			["embrace_the_darkness"] = {
				name = "Embrace the Darkness",
				subfaith = "Primevalism",
				description = "Enables the 'Cloaking' mechanic for use with Senses in the Wasteland at night, during bloodstorms, or while in the mines. Reduces sanity loss in the mines. Also unlocks Tier III 'Faith of the Dark' rituals if you are of the 'House Rekh-khet-sa' bloodline.",
				quote = "\"Look into the blackness of the night and something will stare back into you.\"",
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				row = 3,
			},
		},
		[2] = {
			["primevalism"] = {
				name = "Primevalism",
				subfaith = "Primevalism",
				description = "Selects 'Primevalism' as your subfaith. Unlocks the ability to pray. Gain double the residual faith gain when outside in the Wasteland at night.",
				quote = "\"Since the dawn of time, men have looked into the darkness of the night and saw gods where there was not. From torturous jungles to ashen woods and vast deserts, these primitives have created tens of thousands of deities to explain away the unknowns of life. These lesser men were indeed focused merely on survival; they did not seek out full truths as the platitudes of their mythology and harsh, distant gods kept them content. In the times of the Begotten they continue still, creating effigies of bone and performing primeval sacrifices to their many gods. Unknown to them, these thousands of deities all share the same face - proxies to gather the power of the masses, as their blind faith keeps the demons of the night indeed satisfied.\"",
				row = 1,
			},
			["creature_of_the_dark"] = {
				name = "Creature of the Dark",
				subfaith = "Primevalism",
				description = "Increases the effective range of Senses significantly and allows it to be used when not equipped, also meaning they must manually be toggled.",
				quote = "\"Those who seek warmth in the light and fire are not fit to live here. In the jungle, you will be our prey.\"",
				requirements = {"primevalism"},
				row = 2,
			},
			["soothsayer"] = {
				name = "Soothsayer",
				subfaith = "Primevalism",
				description = "Unlocks Tier I and Tier II 'Faith of the Dark' Rituals. Also unlocks the ability to darkwhisper.",
				quote = "\"Markings in the mud. A house of skulls in the jungle. A child's figure bound by bamboo sticks, face eaten out by carnivorous ants. The devil lives here - we need to leave this place!\"",
				requirements = {"primevalism", "creature_of_the_dark"},
				row = 3,
			},
			["survivalist"] = {
				name = "Survivalist",
				subfaith = "Primevalism",
				description = "All pierce melee weapons and throwables as well as crossbow bolts now apply poison which lowers the target's movement speed and slowly drains health.",
				quote = "\"The tribals rub their spears in vile herbs and ivies. One jab and you'll be feeling it.\"",
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				row = 4,
			},
		},
		[3] = {
			["thirst_blood_moon"] = {
				name = "Thirst of the Blood Moon",
				subfaith = "Primevalism",
				description = "While outside in the Wasteland at night or during bloodstorms, or while in the mines, 50% of damage dealt will be returned as health. Also provides a small chance of healing injuries or stopping bleeding if the damage dealt is above 25. Halves residual nighttime/bloodstorm sanity loss. Unlocks unique 'Primevalism' Rituals.",
				quote = "\"The guardsman heard howling and could not discern if it were a man or beast. In truth, it did not matter.\"",
				iconOverride = "begotten/ui/belieficons/lunar_repudiation.png",
				requirements = {"primevalism", "creature_of_the_dark", "soothsayer"},
				row = 3,
			},
		},
		[4] = {
			["unending_dance"] = {
				name = "The Unending Dance",
				subfaith = "Satanism",
				description = "You will now deal more damage against characters the lower their sanity is. Starting at under 90% enemy Sanity you will deal 10% more damage which maxes at 70% damage at 10 enemy sanity.",
				quote = "\"At first the crowd was aghast when the performing Darklander swordsman turned his twin blades against the audience. Many screamed and ran, scrambling to find an exit to the ampitheatre. Many more began to simply applaud at the art, boasting their standing ovations as dozens had their heads expertly hacked off in a dazzling display of skill and passion. The master swordsman was beset in a fit of laughter as he continued his work, the audience eagerly awaiting their fate as they cheered him on. Survivors of the tragedy recall the event with an almost nostalgic flare; emoting a sincere forlorn regret for not having joined the countless dead in the apocalyptic dance of death.\"",
				requirements = {"satanism", "murder_artform", "flamboyance"},
				row = 4,
			},
		},
		[5] = {
			["flamboyance"] = {
				name = "Flamboyance",
				subfaith = "Satanism",
				description = "All melee weapons now have 10% less delay before the next attack.",
				quote = "\"Gloriosity at its finest\"",
				requirements = {"satanism", "murder_artform"},
				row = 3,
			},
		},
		[6] = {
			["murder_artform"] = {
				name = "Murder as an Artform",
				subfaith = "Satanism",
				description = "Unlocks the ability to equip Satanic sacrificial weapons. Also unlocks the ability to dual-wield one-handed weapons.",
				requirements = {"satanism"},
				row = 2,
			},
			["impossibly_skilled"] = {
				name = "Impossibly Skilled",
				subfaith = "Satanism",
				description = "Dual Weapons and longswords now block bullets, crossbow bolts, and throwables. Unlocks the ability to parry or deflect bolts and throwables to redirect them at your foe. Moderately increases parry and deflection windows for all melee weapons. Requires 'Blademaster' to also be unlocked.",
				quote = "\"The heretics claim that the immortals of Hell have spent centuries refining their reflexes and skill with blades to the point that they can effortlessly slice through bullets and projectiles in mid air. Perhaps this is a skill you could learn?\"",
				requirements = {"satanism", "murder_artform", "flamboyance", "blademaster"},
				row = 4,
			},
		},
		[7] = {
			["satanism"] = {
				name = "Satanism",
				subfaith = "Satanism",
				description = "Selects 'Satanism' as your subfaith. Unlocks the ability to pray. Gain double the faith gain from completing rituals.",
				quote = "Satanism is the name given to the truest belief of all. Mankind made the choice to bar themselves of pleasure for the hope of something more, a sort of justification behind their misery. They made the mistake of following the Light, something that exists only to draw men astray from their true desires. Those men pray to a god that never listens, a god that is dead in more ways than one. They believe that they should suffer a life of misery and pain for an afterlife of bliss and ignorance. Satanism is the inverse of that belief. Those who seek out the forbidden pages open their eyes to the full truths of the human plight. They understand that they must take matters into their own hands, harness the energies from every passionate delight and tortured agony. For that reason Satanists are considered selfish, often unpredictable creatures who do not hide their true desires as the chastised do.",
				row = 1,
			},
			["witch"] = {
				name = "Witch",
				subfaith = "Satanism",
				description = "Unlocks Tier I 'Faith of the Dark' Rituals. Also unlocks the ability to darkwhisper.",
				requirements = {"satanism"},
				row = 2,
			},
			["heretic"] = {
				name = "Heretic",
				subfaith = "Satanism",
				description = "Unlocks Tier II 'Faith of the Dark' Rituals.",
				requirements = {"satanism", "witch"},
				row = 3,
			},
			["sorcerer"] = {
				name = "Sorcerer",
				subfaith = "Satanism",
				description = "Unlocks Tier III 'Faith of the Dark' Rituals and increases your sacrament level cap by 5. Also unlocks the ability to smelt Hellforged Steel (only if 'Master Blacksmith' is also unlocked).",
				requirements = {"satanism", "witch", "heretic"},
				row = 4,
			},
		},
		[8] = {
			["blank_stare"] = {
				name = "A Blank Stare",
				subfaith = "Satanism",
				description = "Unlocks the ability to roughly determine the sanity level of inspected characters.",
				requirements = {"satanism"},
				row = 2,
			},
			["assassin"] = {
				name = "Assassin",
				subfaith = "Satanism",
				description = "Stabbing someone with a dagger who is below 25% of their max health or who is fallen over will instantly kill them. Throwing daggers will also trigger this effect. Characters affected by such damage bonuses will be highlighted in red. The backstab bonus for daggers is increased from +200% to +300%. Also extinguishes 'Soulscorch'. Requires 'Swift' to also be unlocked.",
				quote = "\"Beware the black-fingered deceiver!\"",
				iconOverride = "begotten/ui/belieficons/wrestle_subdue.png",
				requirements = {"satanism", "blank_stare", "encore", "swift"},
				row = 4,
			},
		},
		[9] = {
			["encore"] = {
				name = "Encore",
				subfaith = "Satanism",
				description = "The attack and block delay of being parried is now reduced by 50%, allowing you to recover far sooner. You also now have 50% less of a chance to be disarmed following a high stamina damage attack.",
				requirements = {"satanism", "blank_stare"},
				row = 3,
			},
		},
		[10] = {
			["sadism"] = {
				name = "Sadism",
				subfaith = "Satanism",
				description = "Unlocks the 'Twisted Warcry' ability, allowing you to mimic the tortured screams of your victims to severely reduce the sanity of all non-Faith of the Dark characters within yelling distance. Note that performing this will cost 5 Sanity.",
				quote = "\"The torturesmith has a certain grace in his vocal abilities. He found his passion for delivering pain was amplified when he sang along to his victims, altering his pitch to match the agonized screams of the trembling accused... Quite a silly man!\"",
				requirements = {"satanism", "blank_stare", "encore"},
				row = 4,
			},
		},
	};
cwBeliefs.beliefTrees:Register(DARK)