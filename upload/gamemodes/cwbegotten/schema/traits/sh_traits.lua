--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local BLIND = Clockwork.trait:New()
	BLIND.uniqueID = "blind"
	BLIND.name = "Blind"
	BLIND.description = "Your character is totally blind, either from birth or due to trauma. You will be unable to see except when using 'Senses'. The 'Aptitude' belief tree will be locked and unable to be progressed."
	BLIND.points = -10
	BLIND.disables = {"crosseyed", "literate", "scribe"}
	BLIND.excludedfactions = {"Children of Satan"}
Clockwork.trait:Register(BLIND)

local BRAWNY = Clockwork.trait:New()
	BRAWNY.uniqueID = "brawny"
	BRAWNY.name = "Brawny"
	BRAWNY.description = "Your character is strong in their physique, allowing them to wield great weapons of war. This trait automatically unlocks the first 3 beliefs on the right side of the 'Prowess' tree: 'Fighter', 'Strength', and 'Might'."
	BRAWNY.points = 4
	BRAWNY.disables = {"weak", "winded"}
	BRAWNY.excludedsubfactions = {"Auxiliary", "Clan Crast"};
Clockwork.trait:Register(BRAWNY)

local DUELIST = Clockwork.trait:New()
	DUELIST.uniqueID = "duelist"
	DUELIST.name = "Duelist"
	DUELIST.description = "Your character is renowned for their skill in fighting, able to deflect blows with ease. This trait automatically unlocks the following 3 beliefs in the 'Prowess' tree: 'Fighter', 'Deflection', and 'Parrying'."
	DUELIST.points = 4
	DUELIST.disables = {"clumsy", "weak"}
	DUELIST.excludedsubfactions = {"Auxiliary", "Clan Crast"};
Clockwork.trait:Register(DUELIST)

local CANNIBAL = Clockwork.trait:New()
	CANNIBAL.uniqueID = "cannibal"
	CANNIBAL.name = "Cannibal"
	CANNIBAL.description = "Your character is a savage fucking cannibal, either out of necessity or twisted fucking psychopathy. This trait automatically unlocks the first belief of the 'Brutality' tree, which grants the ability to devour dead corpses for sustenance and health."
	CANNIBAL.points = 1
	CANNIBAL.excludedsubfactions = {"Varazdat"}
	CANNIBAL.disables = {"pacifist"}
Clockwork.trait:Register(CANNIBAL)

local CLUMSY = Clockwork.trait:New()
	CLUMSY.uniqueID = "clumsy"
	CLUMSY.name = "Clumsy"
	CLUMSY.description = "Your character is clumsy, a dolt, a fucking absent minded fool. While running, you will trip and fall over at random."
	CLUMSY.points = -6
	CLUMSY.excludedfactions = {"Children of Satan"}
	CLUMSY.disables = {"duelist"}
Clockwork.trait:Register(CLUMSY)

local CRIMINAL = Clockwork.trait:New()
	CRIMINAL.uniqueID = "criminal"
	CRIMINAL.name = "Criminal"
	CRIMINAL.description = "Your character is a common criminal, skilled in the art of lockpicking. This trait automatically unlocks the first 3 beliefs on the left side of the 'Litheness' tree: 'Nimble', 'Sly Fidget', and 'Safecracker', and also grants two starting lockpicks."
	CRIMINAL.points = 4
	CRIMINAL.excludedfactions = {"Holy Hierarchy"};
Clockwork.trait:Register(CRIMINAL)

local CROSSEYED = Clockwork.trait:New()
	CROSSEYED.uniqueID = "crosseyed"
	CROSSEYED.name = "Cross Eyed"
	CROSSEYED.description = "Your character is a cross eyed fuck. You look stupid and everyone can see it."
	CROSSEYED.points = -8
	CROSSEYED.disables = {"blind"}
	CROSSEYED.excludedfactions = {"Children of Satan"};
Clockwork.trait:Register(CROSSEYED)

local ESCAPEE = Clockwork.trait:New()
	ESCAPEE.uniqueID = "escapee"
	ESCAPEE.name = "Escapee"
	ESCAPEE.description = "Your character is an escapee from some slave camp or prison, but in your haste to escape you were not able to have your bindings removed. You will start tied up."
	ESCAPEE.points = -2
	ESCAPEE.disables = {"logger", "miner", "pilgrim", "scavenger", "survivalist", "veteran"}
	ESCAPEE.requiredfactions = {"Wanderer"}
Clockwork.trait:Register(ESCAPEE)

local EXHAUSTED = Clockwork.trait:New()
	EXHAUSTED.uniqueID = "exhausted"
	EXHAUSTED.name = "Exhausted"
	EXHAUSTED.description = "Your character has travelled long and far to reach the Tower of Light, leaving them exhausted. This trait starts your character with high hunger, thirst, and fatigue values."
	EXHAUSTED.points = -2
	EXHAUSTED.requiredfactions = {"Wanderer"}
Clockwork.trait:Register(EXHAUSTED)

local FAVORED = Clockwork.trait:New()
	FAVORED.uniqueID = "favored"
	FAVORED.name = "Favored"
	FAVORED.description = "By virtue or good fortune, your character has clearly been blessed with the favor of some divine power. This trait automatically unlocks the 3 beliefs on the left column of the 'Fortune' tree: 'Fortunate', 'Lucky', and 'Favored'."
	FAVORED.points = 4
	FAVORED.disables = {"marked", "possessed"}
Clockwork.trait:Register(FAVORED)

local FOLLOWED = Clockwork.trait:New()
	FOLLOWED.uniqueID = "followed"
	FOLLOWED.name = "Followed"
	FOLLOWED.description = "Long ago, your character made the blunder of ransacking an ancient tomb. Through their ignorance, they missed that it had been prophesied that those who would defile the tomb would be cursed to be hunted for all eternity..."
	FOLLOWED.disables = {"pilgrim", "shrewd"}
	FOLLOWED.points = -7
	FOLLOWED.excludedfactions = {"Gatekeeper", "Pope Adyssa's Gatekeepers"};
Clockwork.trait:Register(FOLLOWED)

local GLUTTONY = Clockwork.trait:New()
	GLUTTONY.uniqueID = "gluttony"
	GLUTTONY.name = "Gluttony"
	GLUTTONY.description = "Your character loves excess and can never get enough. Your hunger and thirst will drain twice as quickly. This will also affect fatigue (energy) if you are a Voltist with the 'Yellow and Black' belief."
	GLUTTONY.points = -4
Clockwork.trait:Register(GLUTTONY)

local GUNSLINGER = Clockwork.trait:New()
	GUNSLINGER.uniqueID = "gunslinger"
	GUNSLINGER.name = "Gunslinger"
	--GUNSLINGER.description = "What are people to your character other than moving targets? Your character will start with a Peppershot and a random assortment of ammunition, as well as two beliefs from the 'Ingenuity' tree: 'Ingenious' and 'Powder and Steel'."
	GUNSLINGER.description = "What are people to your character other than moving targets? Your character will start with two beliefs from the 'Ingenuity' tree: 'Ingenious' and 'Powder and Steel'."
	GUNSLINGER.disables = {"pilgrim"}
	--GUNSLINGER.points = 7
	GUNSLINGER.points = 3
	GUNSLINGER.excludedfactions = {"Children of Satan", "Gatekeeper", "Holy Hierarchy", "Pope Adyssa's Gatekeepers"}
	GUNSLINGER.excludedsubfactions = {"Clan Crast", "Clan Grock", "Clan Harald", "Clan Reaver", "Clan Gore"};
Clockwork.trait:Register(GUNSLINGER)

local IMBECILE = Clockwork.trait:New()
	IMBECILE.uniqueID = "imbecile"
	IMBECILE.name = "Imbecile"
	IMBECILE.description = "Your character is retarded and unable to form complete sentences. Blessed is the mind too small for doubt."
	IMBECILE.points = -3
	IMBECILE.disables = {"literate", "scribe"}
	IMBECILE.excludedfactions = {"Children of Satan"}
Clockwork.trait:Register(IMBECILE)

local INSANE = Clockwork.trait:New()
	INSANE.uniqueID = "insane"
	INSANE.name = "Insane"
	INSANE.description = "Your character is fucking insane. Your maximum sanity is permanently capped at 40%."
	INSANE.points = -7
	INSANE.disables = {"pacifist"}
	INSANE.excludedsubfactions = {"Rekh-khet-sa"}
Clockwork.trait:Register(INSANE)

local LEPER = Clockwork.trait:New()
	LEPER.uniqueID = "leper"
	LEPER.name = "Leper"
	LEPER.description = "Every waking moment of your character's very existence is hell, for they have been cursed to walk the Earth with a most unholy affliction: Leprosy. Their ravaged and deformed body leaves them a societal outcast and a target for persecution. Your character will suffer 50% more blood loss when bleeding and their repugnant affliction will be known to all who gaze upon them."
	LEPER.points = -5
	LEPER.disables = {"pilgrim"}
	LEPER.disablesSkins = true;
	LEPER.excludedfactions = {"Gatekeeper", "Goreic Warrior", "Holy Hierarchy", "Pope Adyssa's Gatekeepers"};
Clockwork.trait:Register(LEPER)

local LITERATE = Clockwork.trait:New()
	LITERATE.uniqueID = "literate"
	LITERATE.name = "Literate"
	LITERATE.description = "Your character is one of the rare few who have learned to read in these uncivilized times. This trait automatically unlocks the first belief of the 'Aptitude' tree: 'Literacy'."
	LITERATE.points = 1
	LITERATE.disables = {"blind", "imbecile", "scribe"}
	LITERATE.excludedfactions = {"Pope Adyssa's Gatekeepers"}
Clockwork.trait:Register(LITERATE)

local LOGGER = Clockwork.trait:New()
	LOGGER.uniqueID = "logger"
	LOGGER.name = "Logger"
	LOGGER.description = "Your character is a logger, chopping trees and limbs alike. This trait grants a starting hatchet."
	LOGGER.points = 4
	LOGGER.disables = {"escapee", "weak"}
	LOGGER.requiredfactions = {"Wanderer"}
	LOGGER.eventlocked = false;
Clockwork.trait:Register(LOGGER)

local MARKED = Clockwork.trait:New()
	MARKED.uniqueID = "marked"
	MARKED.name = "Marked"
	MARKED.description = "Either by angering some dark power or delving too far into the occult, your character has become marked for death. The consequences of this may be severe, and the 'Fortune' belief tree will be locked and unable to be progressed."
	MARKED.points = -4
	MARKED.disables = {"favored"}
Clockwork.trait:Register(MARKED)

local MINER = Clockwork.trait:New()
	MINER.uniqueID = "miner"
	MINER.name = "Miner"
	MINER.description = "Your character is a miner, spending much of their time deep under the earth. This trait grants a starting pickaxe for mining ore and a lantern to help you navigate the depths."
	MINER.points = 7
	MINER.disables = {"escapee", "weak"}
	MINER.requiredfactions = {"Wanderer"}
	MINER.eventlocked = false;
Clockwork.trait:Register(MINER)

local NIMBLE = Clockwork.trait:New()
	NIMBLE.uniqueID = "nimble"
	NIMBLE.name = "Nimble"
	NIMBLE.description = "Your character is quick on their feet, able to escape dangerous situations with relative ease. This trait automatically unlocks the first 3 beliefs on the right side of the 'Litheness' tree: 'Nimble', 'Evasion', and 'Dexterity'."
	NIMBLE.points = 4
	NIMBLE.disables = {"winded"}
Clockwork.trait:Register(NIMBLE)

local PACIFIST = Clockwork.trait:New()
	PACIFIST.uniqueID = "pacifist"
	PACIFIST.name = "Pacifist"
	PACIFIST.description = "Your character is a pacifist and detests the act of killing. Harming or killing other characters will negatively impact your sanity. The 'Brutality' belief tree will also be locked and unable to be progressed."
	PACIFIST.points = -4
	PACIFIST.disables = {"cannibal", "insane"}
	PACIFIST.excludedsubfactions = {"Legionary", "Clan Reaver", "Clan Gore"}
	PACIFIST.excludedfactions = {"Children of Satan", "Pope Adyssa's Gatekeepers"}
Clockwork.trait:Register(PACIFIST)

local PILGRIM = Clockwork.trait:New()
	PILGRIM.uniqueID = "pilgrim"
	PILGRIM.name = "Pilgrim"
	PILGRIM.description = "Your character has ventured far and wide to reach the Tower of Light, either in search of sanctuary or in pursuit of holy purpose. Your character will spawn inside the Tower of Light safezone."
	PILGRIM.points = 2
	PILGRIM.disables = {"escapee", "gunslinger", "leper"}
	PILGRIM.requiredfactions = {"Wanderer"}
Clockwork.trait:Register(PILGRIM)

local PIOUS = Clockwork.trait:New()
	PIOUS.uniqueID = "pious"
	PIOUS.name = "Pious"
	PIOUS.description = "Your character is pious and a firm believer in their faith. This trait grants a single free sacrament with an epiphany for use in the belief tree."
	PIOUS.points = 1
	PIOUS.excludedsubfactions = {"Clan Grock"};
Clockwork.trait:Register(PIOUS)

local PLACEBO = Clockwork.trait:New()
	PLACEBO.uniqueID = "placebo"
	PLACEBO.name = "Placebo"
	PLACEBO.description = "This trait might do something..."
	PLACEBO.points = 1
Clockwork.trait:Register(PLACEBO)

local POSSESSED = Clockwork.trait:New()
	POSSESSED.uniqueID = "possessed"
	POSSESSED.name = "Possessed"
	POSSESSED.description = "Your character is prone to possession by some demonic force, often speaking in tongues and unwillingly perpetrating extreme violence. Due to this malignant presence, your character will incur corruption passively up to 50%, at which point they will be able to be possessed."
	POSSESSED.points = -6
	POSSESSED.disables = {"favored", "zealous"}
	POSSESSED.excludedsubfactions = {"Rekh-khet-sa"}
Clockwork.trait:Register(POSSESSED)

local SCAVENGER = Clockwork.trait:New()
	SCAVENGER.uniqueID = "scavenger"
	SCAVENGER.name = "Scavenger"
	SCAVENGER.description = "Your character is an experienced scavenger and knows what to look for when searching. This trait slightly improves your chances of getting higher quality loot when searching containers, and also grants a starting breakdown kit for breaking down items into their component parts."
	SCAVENGER.points = 3
	SCAVENGER.disables = {"escapee"}
Clockwork.trait:Register(SCAVENGER)

local SCRIBE = Clockwork.trait:New()
	SCRIBE.uniqueID = "scribe"
	SCRIBE.name = "Scribe"
	SCRIBE.description = "Your character is not only one of few able to read, but also a learned scribe, a valuable quality indeed. This trait automatically unlocks the first 2 beliefs in the middle column of the 'Aptitude' tree: 'Literacy' and 'Scribe'."
	SCRIBE.points = 3
	SCRIBE.disables = {"blind", "literate", "imbecile"}
Clockwork.trait:Register(SCRIBE)

local SHREWD = Clockwork.trait:New()
	SHREWD.uniqueID = "shrewd"
	SHREWD.name = "Shrewd"
	SHREWD.description = "Your character is very clever, using their wits to survive otherwise inescapable situations. This trait automatically unlocks the first 3 beliefs in the middle of the 'Ingenuity' tree: 'Ingenious', 'Craftsman', and 'Mechanic'."
	SHREWD.points = 4
	SHREWD.disables = {"followed"};
	SHREWD.excludedsubfactions = {"Clan Shagalax"};
Clockwork.trait:Register(SHREWD)

local SURVIVALIST = Clockwork.trait:New()
	SURVIVALIST.uniqueID = "survivalist"
	SURVIVALIST.name = "Survivalist"
	SURVIVALIST.description = "Your character is a lone wolf, looking out only for themself at the expense of others. This trait grants a starting random melee weapon, a random assortment of consumable items, and grants five sacraments with their respective epiphanies for use in the belief tree."
	SURVIVALIST.points = 10
	SURVIVALIST.eventlocked = false;
	SURVIVALIST.disables = {"escapee"}
	SURVIVALIST.excludedfactions = {"Children of Satan", "Gatekeeper", "Holy Hierarchy", "Pope Adyssa's Gatekeepers"}
	SURVIVALIST.excludedsubfactions = {"Clan Crast", "Clan Grock"};
Clockwork.trait:Register(SURVIVALIST)

local VETERAN = Clockwork.trait:New()
	VETERAN.uniqueID = "veteran"
	VETERAN.name = "Veteran"
	VETERAN.description = "Your character is a veteran of several battles, having accrued some fighting experience and basic equipment. This trait grants a starting random melee weapon and shield, and automatically unlocks the 4 beliefs on the left side of the 'Prowess' tree: 'Fighter', 'Halfsword and Sway', 'Blademaster', and 'Billman'."
	VETERAN.points = 16
	VETERAN.eventlocked = false;
	VETERAN.disables = {"duelist", "escapee", "weak"}
	VETERAN.excludedfactions = {"Children of Satan", "Gatekeeper", "Holy Hierarchy", "Pope Adyssa's Gatekeepers"}
	VETERAN.excludedsubfactions = {"Clan Crast", "Clan Grock"};
Clockwork.trait:Register(VETERAN)

local VIGOROUS = Clockwork.trait:New()
	VIGOROUS.uniqueID = "vigorous"
	VIGOROUS.name = "Vigorous"
	VIGOROUS.description = "Your character is enduring and can take a beating. This trait automatically unlocks the 3 beliefs on the mid-right side of the 'Fortitude' tree: 'The Believer's Perseverance', 'Plenty to Spill', and 'Unyielding'."
	VIGOROUS.points = 4
	VIGOROUS.disables = {"weak", "winded"}
Clockwork.trait:Register(VIGOROUS)

local WEAK = Clockwork.trait:New()
	WEAK.uniqueID = "weak"
	WEAK.name = "Weak"
	WEAK.description = "Your character has a flimsy physique, and is unable to tolerate much pain. The 'Prowess' belief tree will be locked and unable to be progressed."
	WEAK.points = -5
	WEAK.disables = {"brawny", "duelist", "miner", "logger", "veteran", "vigorous"}
Clockwork.trait:Register(WEAK)

local WINDED = Clockwork.trait:New()
	WINDED.uniqueID = "winded"
	WINDED.name = "Winded"
	WINDED.description = "Your character is a poor runner and tires easily. This trait lowers your maximum stamina by 25 points and locks the 'Outlasting' belief in the 'Fortitude' belief tree."
	WINDED.points = -4
	WINDED.disables = {"brawny", "nimble", "vigorous"}
Clockwork.trait:Register(WINDED)

local WOUNDED = Clockwork.trait:New()
	WOUNDED.uniqueID = "wounded"
	WOUNDED.name = "Wounded"
	WOUNDED.description = "Your character was wounded during their arduous journey to their destination. This trait starts your character with a random assortment of wounds and missing health."
	WOUNDED.points = -2
	WOUNDED.requiredfactions = {"Wanderer"}
Clockwork.trait:Register(WOUNDED)

local ZEALOUS = Clockwork.trait:New()
	ZEALOUS.uniqueID = "zealous"
	ZEALOUS.name = "Zealous"
	ZEALOUS.description = "Through the sheer power of their faith, your character is able to resist unholy temptations, and withstand events that may otherwise shatter their sanity. This trait automatically unlocks the first 2 beliefs in the second column of the 'Fortitude' tree: 'Prudence' and 'Saintly Composure'. This trait also grants three sacraments with their respective epiphanies for use in the beliefs menu."
	ZEALOUS.points = 7
	ZEALOUS.disables = {"possessed"}
	ZEALOUS.excludedsubfactions = {"Clan Grock"}
Clockwork.trait:Register(ZEALOUS)