--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local BRUTALITY = cwBeliefs.beliefTrees:New("brutality")
	BRUTALITY.name = "Brutality";
	BRUTALITY.color = Color(150, 20, 20);
	BRUTALITY.order = 2;
	BRUTALITY.size = {w = 258, h = 407};
	BRUTALITY.textures = {"brutality", "brutalityarrows"};
	BRUTALITY.tooltip = {
		{"Brutality", BRUTALITY.color, "Civ5ToolTip4"},
		{"Brutality is a measure of your character's depravity and hatred of man, primarily affecting your character's survival ability and unlocking abilities such as cannibalism and bone harvesting. Fully upgrading Brutality will make your character far more survivable while increasing your combat ability while insane.", Color(225, 200, 200)},
		{"\n\"There will be no exile for the laggards. They will feel my wrath. I will impale a pitchfork through their foul, satanic flesh and harvest it for the cow.\"", Color(128, 90, 90, 240)},
		{"\nBelief Tree Completion Bonus: Killing another character instantly restores 3% of your Health, Stamina, and Stability per sacrament level of the character.", Color(50, 255, 50)}
	};
	BRUTALITY.columnPositions = {
		[1] = (BRUTALITY.size.w - 4) * 0.3,
		[2] = (BRUTALITY.size.w - 4) * 0.5,
		[3] = (BRUTALITY.size.w - 4) * 0.7,
	};
	BRUTALITY.rowPositions = {
		[1] = (BRUTALITY.size.h - 4) * 0.3,
		[2] = (BRUTALITY.size.h - 4) * 0.5,
		[3] = (BRUTALITY.size.h - 4) * 0.7,
		[4] = (BRUTALITY.size.h - 4) * 0.9,
	};
	
	BRUTALITY.hasFinisher = true;
	BRUTALITY.lockedTraits = {"pacifist"};
	
	-- First index is column.
	BRUTALITY.beliefs = {
		[1] = {
			["primeval"] = {
				name = "Primeval",
				description = "Unlocks the 'Harvesting' mechanic, allowing you to harvest bones from corpses for use in crafting. Unlocks the ability to craft skin-based healing items.",
				requirements = {"savage"},
				row = 2,
			},
			["headtaker"] = {
				name = "Headtaker",
				description = "Deal 25% more limb damage with all damage types. Unlocks the ability to decapitate characters via killing blows to the head with a slash weapon that exceed 30 damage. Decapitating characters will grant 20% increased melee damage for 30 seconds.",
				iconOverride = "begotten/ui/belieficons/brutality.png",
				requirements = {"savage", "primeval"},
				row = 3,
			},
		},
		[2] = {
			["savage"] = {
				name = "Savage",
				description = "Unlocks the 'Cannibalism' mechanic. Meat from corpses can be harvested for sustenance. Gain sanity from consuming cooked human meat.",
				row = 1,
			},
			["savage_animal"] = {
				name = "Savage Animal",
				description = "Eating uncooked or spoiled food or drinking dirty water no longer has any negative effects. Also removes sanity loss for eating hearts.",
				quote = "\"Fear the one who will rip out your heart, eat your flesh, and wear your bones. For they are the predator, and we the prey!\"",
				requirements = {"savage", "primeval", "headtaker", "heart_eater", "bestial"},
				row = 4,
			},
		},
		[3] = {
			["heart_eater"] = {
				name = "Heart Eater",
				description = "Unlocks the ability to rip out someone's heart and eat it to restore thirst.",
				iconOverride = "begotten/ui/belieficons/persistent_urges.png",
				requirements = {"savage"},
				row = 2,
			},
			["bestial"] = {
				name = "Bestial",
				description = "While at or below 40% sanity, deal 10% more damage with all melee weapons.",
				requirements = {"savage", "heart_eater"},
				row = 3,
			},
		},
	};
cwBeliefs.beliefTrees:Register(BRUTALITY)