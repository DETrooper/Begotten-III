--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local FORTITUDE = cwBeliefs.beliefTrees:New("fortitude")
	FORTITUDE.name = "Fortitude";
	FORTITUDE.color = Color(150, 80, 60);
	FORTITUDE.order = 6;
	FORTITUDE.size = {w = 378, h = 407};
	FORTITUDE.textures = {"fortitude", "fortitudearrows"};
	FORTITUDE.tooltip = {
		{"Fortitude", FORTITUDE.color, "Civ5ToolTip4"},
		{"Fortitude is a measure of your character's mental and physical resilence, primarily affecting your character's resistance to insanity as well as improving your character's combat ability due to increased pain tolerance.", Color(225, 200, 200)},
		{"\n\"I am the creator of all this light and now I fall to pieces without recognition. Dying without glorification is sinful nature, yet God does not reside in the light. The light resides in the dark. Souls begin through flesh. The mind ponders inside of shells that cannot withstand a lie which does nothing but misinterpret all that we have achieved.\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: +15 maximum HP, +25% Stamina Damage Resistance, +15% Stability Damage Resistance. Grants resistance to explosion knockdown. Otherwise lethal attacks will now always put you into critical condition.", Color(50, 255, 50)},
	};
	FORTITUDE.columnPositions = {
		[1] = (FORTITUDE.size.w - 4) * 0.1,
		[2] = (FORTITUDE.size.w - 4) * 0.3,
		[3] = (FORTITUDE.size.w - 4) * 0.5,
		[4] = (FORTITUDE.size.w - 4) * 0.7,
		[5] = (FORTITUDE.size.w - 4) * 0.9,
	};
	FORTITUDE.rowPositions = {
		[1] = (FORTITUDE.size.h - 4) * 0.3,
		[2] = (FORTITUDE.size.h - 4) * 0.5,
		[3] = (FORTITUDE.size.h - 4) * 0.7,
		[4] = (FORTITUDE.size.h - 4) * 0.9,
	};
	
	FORTITUDE.hasFinisher = true;

	-- First index is column.
	FORTITUDE.beliefs = {
		[1] = {
			["asceticism"] = {
				name = "Asceticism",
				description = "Hunger and thirst now drain 35% slower. This will also affect fatigue (energy) if you are a Voltist with the 'Yellow and Black' belief.",
				row = 1,
			},
			["outlasting"] = {
				name = "Outlasting",
				description = "Reduces stamina drain when sprinting by 25%.",
				lockedTraits = {"winded"},
				requirements = {"asceticism"},
				row = 2,
			},
		},
		[2] = {
			["prudence"] = {
				name = "Prudence",
				description = "Sanity now drains 25% slower and certain events affect your sanity less. The sanity effect of enemy warcries is reduced by 50%.",
				row = 1,
			},
			["saintly_composure"] = {
				name = "Saintly Composure",
				description = "The effects of low sanity are greatly reduced, and the effect of enemy warcries on your vision is also greatly reduced.",
				quote = "\"By divine steed and noble stature, these begotten thoughts will tempt me not.\"",
				requirements = {"prudence"},
				row = 2,
			},
			["lunar_repudiation"] = {
				name = "Lunar Repudiation",
				description = "Grants immunity to all effects of the Blood Moon and halves residual nighttime sanity loss. Significantly reduces the effects of fear from thralls and enemy armors.",
				requirements = {"prudence", "saintly_composure"},
				row = 3,
			},
		},
		[3] = {
			["hauberk"] = {
				name = "Hauberk",
				description = "Unlocks the ability to wear heavy armor.",
				row = 1,
			},
			["defender"] = {
				name = "Defender",
				description = "Unlocks the ability to equip great shields.",
				quote = "The savages trembled before the advancing wall of steel.",
				requirements = {"hauberk"},
				row = 2,
			},
			["warden"] = {
				name = "Warden",
				description = "All melee weapons and shields now have an additional 15% stamina damage resistance.",
				requirements = {"hauberk", "defender"},
				row = 3,
			},
			["unburdened"] = {
				name = "Unburdened",
				description = "Significantly reduces the movement penalty for medium and heavy armor, including rolling.",
				requirements = {"hauberk", "defender", "warden"},
				row = 4,
			},
		},
		[4] = {
			["believers_perseverance"] = {
				name = "The Believer's Perseverance",
				description = "Increases critical condition duration by 300%.",
				quote = "\"Suffer in silence and do not step into the light; there are more foes yet to kill!\"",
				row = 1,
			},
			["plenty_to_spill"] = {
				name = "Plenty to Spill",
				description = "Reduces the rate of blood loss while bleeding by 50%.",
				requirements = {"believers_perseverance"},
				row = 2,
			},
			["unyielding"] = {
				name = "Unyielding",
				description = "Increases your maximum HP by 25 points.",
				requirements = {"believers_perseverance", "plenty_to_spill"},
				row = 3,
			},
		},
		[5] = {
			["hide_of_steel"] = {
				name = "Hide of Steel",
				description = "Reduces the chance of receiving injuries by 50%.",
				row = 1,
			},
			["iron_bones"] = {
				name = "Iron Bones",
				description = "Reduces damage taken to limbs by 33%.",
				requirements = {"hide_of_steel"},
				row = 2,
			},
		},
	};
cwBeliefs.beliefTrees:Register(FORTITUDE)