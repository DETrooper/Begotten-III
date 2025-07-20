--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Names for random name selection.
RANDOM_FORENAMES = {
	["glazic"] = {
		["male"] = {"Abraham", "Aaron", "Adam", "Alan", "Albert", "Alfred", "Alexander", "Atticus", "Andrew", "Anthony", "Angus", "Allen", "Alvin", "Albert", "Ambrose", "Arnold", "Arthur", "Buford", "Benjamin", "Benedict", "Bernard", "Brigham", "Braxton", "Barnabas", "Boxer", "Charles", "Christopher", "Clarence", "Clark", "Clayton", "Calvin", "Chester", "Cornelius", "David", "Donald", "Daniel", "Duncan", "Elias", "Eric", "Eugene", "Eustace", "Ernest", "Edward", "Earl", "Francis", "George", "Gregory", "Gerald", "Grover", "Gordon", "Hector", "Harold", "Horatio", "Henry", "Isaac", "Ian", "Joseph", "Jeffrey", "John", "Jonathan", "Jebediah", "James", "Jacob", "Julius", "Julian", "Justin", "Josiah", "Joshua", "Karmine", "Leonard", "Louis", "Lawrence", "Leland", "Lucas", "Lionel", "Lamont", "Lyman", "Magnus", "Moses", "Michael", "Michelangelo", "Marcus", "Martin", "Milton", "Nathaniel", "Noah", "Nicholas", "Oliver", "Obadiah", "Odysseus", "Orville", "Owen", "Philip", "Peter", "Paul", "Patrick", "Reginald", "Robert", "Richard", "Ronald", "Rufus", "Rhett", "Samuel", "Scott", "Stephen", "Sampson", "Sylvester", "Theodore", "Thomas", "Timothy", "Upton", "Ulysses", "Victor", "Vincent", "William", "Walter", "Wilbur", "Wallace", "Wyatt", "Zachary"},
		["female"] = {"Adela", "Adriana", "Alice", "Amelia", "Anna", "Audrey", "Autumn", "Aveline", "Beatrice", "Caroline", "Catherine", "Cecilia", "Daisy", "Dawn", "Ella", "Eleanor", "Elizabeth", "Emma", "Gloria", "Grace", "Heather", "Helen", "Isabel", "Isabella", "Jennifer", "Joan", "Joanna", "Julia", "Juliana", "Laura", "Livia", "Madeline", "Margaret", "Maria", "Mary", "Olympia", "Scarlett", "Sarah", "Silvia", "Sophia", "Susanna", "Sybilla", "Theodora", "Victoria", "Virginia", "Valeria", "Zelda"}
	},
	["gore-glazic"] = {
        ["male"] = {"Ludovic", "Leofric", "Jasper", "Gawain", "Albert", "Alfred", "Robert", "Saewulf", "Lefwald", "Asher", "Angus", "Carling", "Heath", "Dunstan", "Hale", "Leighwen", "Wyot", "Arthur", "Royce", "Clifford", "Hereward", "Brigham", "Eadwig", "Selwine", "Boxer", "Daltenn", "Oswen", "Edraed", "Gledwin", "Cenric", "Presley", "Chester", "Riley", "Linton", "Kingsley", "Whitney", "Cynameer", "Kenelm", "Erik", "Cuthbert", "Winthrop", "Riley", "Edward", "Earl", "Cythrid", "George", "Deorwine", "Haywood", "Grover", "Upton", "Huxley", "Camdyn", "Heren", "Wulfwin", "Solomon", "Esbort", "Athel", "Athelstan", "Swithin", "Aslac", "Ulfi", "Adrien", "Fulk", "Joscelin", "Julian", "Aelnod", "Fitzher", "Sewel", "Karmine", "Drogo", "Dene", "Valen", "Barantyn", "Samwell", "Lionel", "Lamont", "Lyman", "Magnus", "Moses", "Michael", "Michelangelo", "Marcus", "Martin", "Milton", "Nathaniel", "Noah", "Nicholas", "Oliver", "Guy", "Odysseus", "Orville", "Owen", "Philip", "Peter", "Paul", "Patrick", "Akeman", "Algar", "Richard", "Ronald", "Rufus", "Thori", "Wicing", "Merewin", "Marmaduke", "Eynolde", "Stannard", "Odo", "Jodoc", "Timothy", "Upton", "Ulysses", "Bartholomew", "Geoffrey", "William", "Wulsi", "Griffin", "Wallace", "Wyatt", "Zachary"},
        ["female"] = {"Thomasine", "Odelina", "Kynburgh", "Maud", "Anna", "Joyceline", "Marjorie", "Aveline", "Beatrice", "Caroline", "Catherine", "Cecilia", "Ismenia", "Stanilde", "Alfleta", "Eleanor", "Elizabeth", "Emma", "Gloria", "Grace", "Heather", "Helen", "Isabel", "Isabella", "Jennifer", "Joan", "Joanna", "Julia", "Juliana", "Laura", "Livia", "Madeline", "Margaret", "Maria", "Mary", "Olympia", "Scarlett", "Sarah", "Silvia", "Sophia", "Susanna", "Sybilla", "Theodora", "Victoria", "Virginia", "Valeria", "Tiecia", "Goditha", "Ediva", "Emmaline", "Basilia", "Pleasance", "Joy", "Ysopa", "Rosamund", "Avis", "Cwenhild", "Agatha", "Helewis"}
	},
	["goreic"] = {
		["male"] = {"Ale", "Alfr", "Alfgeir", "Anders", "Anlaufr", "Anundr", "Arnbjörn", "Arngrimr", "Arni", "Arnfast", "Asbjörn", "Bagge", "Baldr", "Barid", "Bengt", "Bersi", "Bertil", "Birger", "Björn", "Bo", "Borkvard", "Botulfr", "Bragi", "Buðli", "Dag", "Dan", "Dyre", "Eilif", "Egill", "Emund", "Einarr", "Eirikr", "Eskild", "Falki", "Faste", "Filip", "Fredrik", "Frirek", "Froði", "Freyr", "Folki", "Gandalfr", "Geirr", "Georg", "Gnupa", "Gorm", "Greger", "Grimr", "Guðfrið", "Guðmundr", "Guðröðr", "Gunnarr", "Hakon", "Halsten", "Haraldr", "Haukr", "Helgi", "Hemming", "Holmger", "Hrafn", "Hrolfr", "Hrane", "Hæsteinn", "Hjalmar", "Hroðgar", "Hroðulfr", "Hrörekr", "Hysing", "Ingólfr", "Ingemar", "Ingjald", "Ivar", "Jedvard", "Jon", "Karl", "Kettil", "Kettilmund", "Kjartan", "Klas", "Knut", "Kol", "Kolbjörn", "Magnus", "Markus", "Magni", "Mats", "Nils", "Niklas", "Oddr", "Ofeig", "Olafr", "Ormr", "Ottarr", "Refr", "Refil", "Ragnarr", "Rikulfr", "Rögnvaldr", "Skuli", "Snorri", "Sigbjörn", "Sigtrygg", "Sigurðr", "Starkaðr", "Steinn", "Sturla", "Styrbjörn", "Styrkar", "Sumarliði", "Suni", "Sveinn", "Sverker", "Sæmundr", "Sölvi", "Sörkver", "Tjudmund", "Toke", "Tolir", "Þorbjörn", "Þorfinn", "Þorbrandr", "Þordr", "Þorgil", "Þorsteinn", "Þorolfr", "Toste", "Totil", "Tryggve", "Tyke", "Ulfr", "Vagn", "Valdemar", "Åke", "Yngvar", "Örvar", "Öysteinn"},
		["female"] = {"Aleta", "Alfhildr", "Alfrið", "Alvör", "Anna", "Asa", "Aslaug", "Asta", "Astrid", "Beata", "Birgitta", "Björg", "Bodil", "Bothildr", "Cecilia", "Edla", "Elin", "Elisabet", "Freyja", "Gerðr", "Gloð", "Grima", "Gunnhildr", "Gurli", "Guðrun", "Gyla", "Gyrið", "Gyða", "Hafrid", "Halla", "Helena", "Holmfrid", "Iliana", "Inga", "Ingfrid", "Ingibjörg", "Ingjerðr", "Ingrid", "Karin", "Katarina", "Kraka", "Kristina", "Linda", "Maer", "Malmfrið", "Margareta", "Maria", "Rikissa", "Rögnfrið", "Rögnhildr", "Saga", "Sara", "Sif", "Sigrid", "Skuld", "Sofia", "Svanhildr", "Ulfhildr", "Vigdis", "Ylva", "Yrsa"}
	}
};

RANDOM_SURNAMES = {
	["glazic"] = {
		"Abriallias", "Aelius", "Anderson", "Antonius", "Appius", "Arcadius", "Armstrong", "Armistead", "Aetius", "Aurelius", "Bateman", "Barclay", "Brutus", "Buchanan", "Caecilius", "Carrinas", "Cassius", "Clemens", "Cornelius", "Chamberlain", "Cranston", "Crassus", "Crawford", "Decimius", "Dilworth", "Domitius", "Fabius", "Flavius", "Franklin", "Fulvius", "Galerius", "Hamilton", "Harris", "Harvus", "Honorius", "Horatius", "Julius", "Jupiter", "Koulius", "Krammy", "Labienus", "Lincoln", "Marius", "Morgan", "Morris", "Nasennius", "Oswald", "Opimius", "Patrobius", "Parker", "Petronius", "Philadelphus", "Pompeius", "Quinctius", "Randolph", "Roberts", "Rufinius", "Septimius", "Severus", "Simmons", "Sheridan", "Stevens", "Stuart", "Sullivan", "Suetonius", "Taylor", "Temple", "Thompson", "Titus", "Tullius", "Tyler", "Valerius", "Vorenus", "Wales", "Wilkes"
	},
	["gore-glazic"] = {
        "Leveson", "Frilleck", "Stokes", "Holbrook", "Sayth", "Arderne", "Bewley", "Bost", "Blount", "Kent", "Makepiece", "Lichefield", "Wenmann", "Hertcombe", "Wilkins", "Carrinas", "Daggas", "Thomisson", "Pursglove", "Coultherst", "Battyl", "Henshawe", "Wything", "Brennyng", "Peltie", "Socksson", "Stokton", "Boltone", "Hamme", "Ledleye", "Maxwells", "Haytere", "Cocke", "Harlande", "Blakeslee", "Calidwalle", "Esburne", "Oldwood", "Helmwood", "Krammy", "Haige", "Hathiwey", "Raclyffe", "Deadmane", "Greymane", "Battleborn", "Gladwyne", "Hurst", "Aston", "Glaziere", "Parrywy", "Rayne", "Chestere", "Colee", "Ackerg", "Stune", "Westcotte", "Reever", "Arte", "Rey", "Stidolphe", "Blackburn", "Washennon", "Willough", "Townsend", "Kardene", "Blakisle", "Ekklesonne", "Wiccam", "Rode", "Kyrstone", "Bourke", "Heile", "Wilkiee", "Sawvers", "Albyne", "Fitsgeffrey", "Pennebrygg", "Morecote", "Fox", "Tegonwell", "Baldwin", "Bedgbery", "Sedrigg", "Swan", "Bridgeman"
	},
	["goreic"] = {
		"Askelsson", "Axel", "Bengtsson", "Björnsson", "Borgesson", "Bundersson", "Ericsson", "Erling", "Eskelsson", "Estensson", "Fredriksson", "Glazkill", "Gustavsson", "Guttormsson", "Haldorsson", "Haralder", "Helgasson", "Helvig", "Heskin", "Hexum", "Hohlt", "Jostad", "Junge", "Kaase", "Karsten", "Klingenberg", "Knudtson", "Krogh", "Leif", "Lorensson", "Mathiesson", "Nygaard", "Nylund", "Ohlsson", "Olafsson", "Skau", "Thostensson", "Torgrimsson", "Tostensson", "Westergaard"
	}
};

local FACTION = Clockwork.faction:New("Wanderer");
	FACTION.disabled = false; -- For events.
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_wanderers";
	FACTION.color = Color(160, 100, 15);
	FACTION.description = "The Wanderers are the carrion carcass eaters of the Wasteland. \nThey were the many lowly commoners of the County Districts, barely literate and ill-fed. \nTo survive as a Wanderer, one must be sharp and brutal, and choose their allegiance carefully. \nTheir weapons are their faith and fear, and their strife will be everlasting.";
	FACTION.availablefaiths = {"Faith of the Light", "Faith of the Family", "Faith of the Dark"};
	FACTION.subfactionsToAvailableFaiths = {["Northlander"] = {"Faith of the Light", "Faith of the Family"}};
	FACTION.imposters = true;
	FACTION.names = "glazic";
	
	if game.GetMap() == "rp_district21" then
		FACTION.subfactions = {
			{
				name = "Northlander", 
				namesOverride = "gore-glazic", 
				subtitle = "Blood of the North", 
				description = "The Gore-Glazic of the Hill are a simple, hardy folk. They have raised their blades and bats and hooks against the darkness for generations. They don't fight for coin, but for survival and family. All must pull together to survive in the empty cold. They have found purchase in their own niches, for they were once many things; farmers, shepherds, warriors. They have since become hunters and fighters, fighting tooth and nail to clutch on to any scrap of soil they still can claim ownership of. These woods are their home, and they will not see it fall to Gay-Goreic invaders, or even their Southern brothers, if given the opportunity. They are born of the union of border Gores and Glazics during the latter days of Maximus’ Conquests. They have faithfully served the Empire of Light and the Holy Hierarchy that followed ever since their inception, their people zealous to a fault - but, within them still flows the blood of the North, and the Family wishes to bring the misguided home. They are the last of their kind, a near extinct people.", 
				attributes = {
					{Color(255, 225, 0), "(~) Pagan by Blood: Can only pick the 'Hard-Glazed' or 'Family' faiths"},
				}, 
				models = {
					["male"] = {
						clothes = "models/begotten/wanderers/northwanderer_male.mdl",
						heads = DEFAULT_MODELS.male.heads,
					},
					["female"] = {
						clothes = "models/begotten/wanderers/northwanderer_female.mdl",
						heads = DEFAULT_MODELS.female.heads,
					},
				},
				default = true
			},
			{
				name = "Southlander", 
				subtitle = "Remnants of the South", 
				description = "Pilgrims from the southlands continually migrate north in spite of the harsh elements, seeking deliverance from the more corrupted lands of the south. They bring with them their strange traditions and heresies.", 
				models = {
					["male"] = {
						clothes = "models/begotten/wanderers/wanderer_male.mdl",
						heads = DEFAULT_MODELS.male.heads,
					},
					["female"] = {
						clothes = "models/begotten/wanderers/wanderer_female.mdl",
						heads = DEFAULT_MODELS.female.heads,
					},
				},
			},
		};
	end
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name == "Goreic Warrior") then
			return false;
		end;
	end;
FACTION_WANDERER = FACTION:Register();

local FACTION = Clockwork.faction:New("Gatekeeper");
	if game.GetMap() == "rp_district21" then
		FACTION.disabled = true;
		FACTION.hidden = true;
	else
		FACTION.disabled = false;
	end
	
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_gatekeepers";
	FACTION.color = Color(80, 100, 120);
	FACTION.description = "The Gatekeepers are the front line of defence against the countless unholy horrors that threaten the Glaze. \nTheir ranks swell with conscripted power-hungry commoners and fanatical flagellants. \nThey must serve the Holy Hierarchy diligently and without question, no matter how outrageous their demands may be. \nIll-trained and poorly equipped, these soldiers are expected to lay their lives down to protect the Light. \nAnd so they shall.";
	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.alliedfactions = {"Hillkeeper", "Holy Hierarchy"};
	FACTION.masterfactions = {"Holy Hierarchy"};
	FACTION.enlist = true;
	FACTION.promoteAcrossSubfactions = true;
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.3; -- 0.3 slots per player (9 at 30 players).
	--FACTION.imposters = true; -- Kinisgers should get enlisted through /enlist on Wanderer disguises.
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Legionary", subtitle = "Legionaries - Soldiers of the Church", description = "The Holy Order of the Gatekeepers has defended the Holy Hierarchy from unholy threats since time immemorial. They have seen many changes over the years and vary considerably in strength, equipment, and number from county district to county district, but nonetheless share a singular goal: to protect the Holy Hierarchy at all costs. Legionaries represent the rank and file of this Holy Order and know only the Glaze. These men are a mix of professional soldiers, conscripted wasteland filth, and religious zealots. They serve as frontline troops and guardsmen in service of the Holy Hierarchy, often taking considerable risks to advance their ministers' goals or to defend them.", attributes = {{Color(0, 225, 0), "(+) Constant Drilling: Starts with +15 maximum stamina"}, {Color(0, 225, 0), "(+) Nourishing Rations: Starts with +25 maximum health"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(0, 225, 0), "(+) Strength in Numbers: +100% faith gain from dealing damage"}, {Color(225, 0, 0), "(-) The 'Voltism' subfaith is locked"}}},
		{name = "Auxiliary", subtitle = "Auxilium - Smiths and Medici", description = "The backbone of the Holy Order and the purveyors of its superior ingenuity, auxiliaries uphold supply, maintain the troops, and act as reservists in combat. As Smiths they arm the ranks with superior weaponry, man the cannons and fortify defensive locations. As Medici they prevent outbreaks in the ranks and mend injuries taken from battle. They are still expected to fight if need be, though are not as often put into harm's way as their legionary kin.", attributes = {{Color(0, 225, 0), "(+) Men of Knowledge: +25% increased faith gain"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 12"}, {Color(0, 225, 0), "(+) Drilled & Nourished: Starts with +20 health and +10 stamina"}, {Color(0, 225, 0), "(+) Has +5kg extra weight capacity"}, {Color(225, 0, 0), "(-) Tier IV of the Prowess belief tree is locked"}, {Color(225, 0, 0), "(-) The 'Voltism' subfaith is locked"}}},
		{name = "Praeventor", startingRank = 12, whitelist = true, subtitle = "Praeventores - Scouts and Assassins", description = "Taking the name of a similar unit from ancient Roman times, the Praeventores serve as a small but elite cadre of scouts, hunters, and assassins for the Holy Order. Recruited from the most loyal and skilled followers of Hard-Glaze, the Praeventores lack any standardized gear to help them blend in whilst performing their duties in the wastes. These duties include: reporting on enemy movements, scavenging valuable artifacts or needed supplies, assassinating enemies of the Holy Hierarchy or sniping targets at long range, bringing in or dispatching the targets of bounties, and gathering information.", attributes = {{Color(0, 225, 0), "(+) Excursionists: -25% stamina drain and +5% sprint speed"}, {Color(0, 225, 0), "(+) Masters of Disguise: Recognising does not reveal your rank"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 8"}, {Color(225, 0, 0), "(-) The 'Sol Orthodoxy' and 'Voltism' subfaiths are locked"}}},
	};
	FACTION.residualXPZones = { -- Zones that boost residual XP gain for this faction.
		["rp_begotten3"] = {
			{pos1 = Vector(1390, 10153, -938), pos2 = Vector(-2370, 11254, -1690), modifier = 0.5, nightModifier = 0.25}, -- Gate
			{pos1 = Vector(10061, 10379, -1211), pos2 = Vector(9385, 11870, -670), modifier = 0.33, nightModifier = 0.2}, -- Gorewatch
			{pos1 = Vector(3458, 12655, -814), pos2 = Vector(3335, 12769, -685), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(2742, 10244, -1194), pos2 = Vector(2913, 10071, -1074), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(-1963, 10678, -1055), pos2 = Vector(-2144, 10886, -1194), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(-3468, 12985, -375), pos2 = Vector(-3591, 13103, -241), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
		},
		["rp_district21"] = {
			{pos1 = Vector(-4765, 9246, 838), pos2 = Vector(-8075, 10488, 489), modifier = 0.5, nightModifier = 0.25}, -- Hill
			{pos1 = Vector(-10637, 13043, 465), pos2 = Vector(-4664, 9210, 879), modifier = 0.5, nightModifier = 0.25}, -- Hill
			{pos1 = Vector(-9328, -8640, -146), pos2 = Vector(-8771, -8105, 686), modifier = 0.33, nightModifier = 0.2}, -- Gorewatch
		},
	};
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name != "Wanderer" and faction.name != "Holy Hierarchy") then
			if player:GetSubfaction() ~= "Kinisger" then
				return false;
			end
		end;
		
		-- It is the IC responsibility of Gatekeepers to bloodtest recruits.
		--[[if player:GetFaith() ~= "Faith of the Light" or player:GetSubfaith() == "Voltism" then
			return false;
		end]]--
		
		if (!Clockwork.player:IsWhitelisted(player, "Gatekeeper")) then
			Clockwork.player:SetWhitelisted(player, "Gatekeeper", true);
		end;
	end;
	
	if SERVER then
		function FACTION:CanPromote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
	end
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end
	
	if !Schema.RanksRestrictedWages then
		Schema.RanksRestrictedWages = {};
	end
	
	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	if !Schema.RanksToCoin then
		Schema.RanksToCoin = {};
	end
	
	Schema.Ranks["Gatekeeper"] = {
		[1] = "Disciple",
		[2] = "Acolyte",
		[3] = "Artificer",
		[4] = "Forgemaster",
		[5] = "Medicus",
		[6] = "Master Medicus",
		[7] = "Emissary",
		[8] = "Vexillifer",
		[9] = "Squire",
		[10] = "High Gatekeeper",
		[11] = "Master-At-Arms",
		[12] = "Scout",
		[13] = "Master Scout",
		[14] = "Acolyte-Evocatus",
	};
	
	Schema.RankTiers["Gatekeeper"] = {
		[1] = {"Disciple"},
		[2] = {"Acolyte", "Acolyte-Evocatus", "Artificer", "Medicus", "Scout"},
		[3] = {"Emissary", "Forgemaster", "Master Medicus", "Master Scout", "Vexillifer", "Squire"},
		[4] = {"High Gatekeeper"},
		[5] = {"Master-At-Arms"},
	};
	
	Schema.RanksToBuffs["Gatekeeper"] = {
		["Master-At-Arms"] = {health = 50, stamina = 50},
	};
	
	-- Do not grant wages to these ranks if they are inside the safezone.
	Schema.RanksRestrictedWages["Gatekeeper"] = {1, 2, 12, 13, 14};
	
	Schema.RanksToSubfaction["Gatekeeper"] = {
		["Artificer"] = "Auxiliary",
		["Forgemaster"] = "Auxiliary",
		["Medicus"] = "Auxiliary",
		["Master Medicus"] = "Auxiliary",
		["Scout"] = "Praeventor",
		["Master Scout"] = "Praeventor",
	};
	
	Schema.RanksToCoin["Gatekeeper"] = {
		[1] = 25,
		[2] = 35,
		[3] = 35,
		[4] = 50,
		[5] = 35,
		[6] = 50,
		[7] = 50,
		[8] = 50,
		[9] = 50,
		[10] = 100,
		[11] = 200, 
		[12] = 35,
		[13] = 50,
		[14] = 50,
	};
FACTION_GATEKEEPER = FACTION:Register();

local FACTION = Clockwork.faction:New("Holy Hierarchy");
	local ministerModels = {
		male = {
			clothes = "models/begotten/gatekeepers/minister_male.mdl",
			heads = {
				"male_01",
				"male_02",
				"male_03",
				"male_04",
				"male_05",
				"male_06",
				"male_07",
				"male_08",
				"male_09",
				"male_11",
				"male_12",
				"male_13",
				"male_16",
				"male_22",
				"male_56"
			},
		},
	};

	FACTION.disabled = false; -- For events.
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_hierarchy";
	FACTION.color = Color(225, 175, 0);
	FACTION.description = "The Holy Hierarchy upholds the ancient superiority of the enlightened few. \nAmongst the dark sea of bastard blood and uncivilized rabble, they are the adjudicators and administrators to enforce Holy Light. \nStill, many are corrupt, seeking self indulgence rather than directing rights. \nAfter all, from their high seats, there are none above them to look down in judgement."
	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.alliedfactions = {"Gatekeeper", "Hillkeeper"};
	FACTION.enlist = true;
	FACTION.ratio = 0.1; -- 0.1 slots per player (3 at 30 players).
	--FACTION.imposters = true;
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Ministry", startingRank = 3, whitelist = true, subtitle = "The Ministry - The Privileged Few Overseers of Glazic Supremacy", description = "The Holy Hierarchy is perhaps the only surviving institution of the old world and is the only known church of the Light remaining. Many view the Holy Hierarchy as the direct continuation of the Empire of Light, including the Holy Hierarchy themselves, who push this narrative to solidify their grasp on their subjects. Any who doubt its legitimacy are executed on the spot. Lording over most of the 'civilized' peasantry that wander the wasteland, the Holy Hierarchy strictly enforces its religious codes, which are ever-changing at the whim of the Pope. At the very top of the Hierarchy lies the Pope, supreme in power. He lives in a penthouse at the top of the hotel in absolute luxury in comparison to the shanties that the rabble share. Below him lies the cardinals, who serve as the Pope's council. Lower still are the Bishops, many of whom are now in open rebellion against the new Pope, with some even claiming his title as their own. Lastly, there are the priests, who are barely above commoner status and equal in rank to those in the Knights of Sol or Inquisition. A priest's duties often involve searching ancient texts held within the grand archives for any advantage that could be offered to the Hierarchy over their rivals, or for clues to decipher the ramblings of the machine that so many wanderers speak of.", models = ministerModels},
		{name = "Inquisition", startingRank = 2, whitelist = true, subtitle = "The Second Inquisition - Hunters, Judges, and Executioners", description = "The Holy Order of the Glaze's Inquisitors is an ancient institution, founded by Lord Maximus during his campaigns against the Black Hats and born of a need to destroy infilitrators and weed out heresy. Although disbanded after their task was completed, it would not be long before the Inquisition was re-instated, as enemies of the Glaze only grew in both numbers and ferocity. The coming of the Undergod and subsequent displacement of the Dark Lord from Hell only strengthened the need for the Inquisition, as unknown powers were now openly unleashed upon mankind. The Inquisition is the most important line of defense for the Holy Hierarchy, as they root out the hidden enemies of the Glaze and uphold religious doctrine. Inquisitors strictly abide by their 'Book of Law', which details their methodology and the rules by which all followers of the Glaze must adhere to. The inquisition also holds the unique ability to hold any member of Glazic society accountable to the 'Book of Law', including members of the Holy Hierarchy. Accusations of heresy are not taken lightly however, and being proved wrong after accusing someone in power may have disastrous consequences for the accuser.", attributes = {{Color(0, 225, 0), "(+) Pious: +50% increased faith gain"}, {Color(0, 225, 0), "(+) Starts with +50 maximum health"}, {Color(0, 225, 0), "(+) Has +5kg extra weight capacity"}}}, 
		{name = "Knights of Sol", startingRank = 1, whitelist = true, subtitle = "The Knights of Sol - The Most Devoted Order of the Glaze", description = "Only a few years ago Skylight fell to Earth in a blazing inferno, the last promise of a future for mankind careening into the ground alongside it. From its innumerable enlightened inhabitants only seventeen emerged: the Glorious Seventeen. Donning glorious white armor and wielding sword glowing bright, the Glorious Seventeen slaughtered every demon that fell upon them. Thousands fell by their blade before the demons retreated into the darkness, and it seemed that humanity would live for at least another day. Although the Glorious Seventeen no longer walk this Earth, their legacy lives on in the newly founded Holy Order of the Knights of Sol. These Knights of Sol consist of the very best of the Holy Hierarchy, unmatched in prowess and seen by many of the faithful as guardian angels incarnate. Knights are given the absolute best equipment available in the royal armories. Despite this, Knights are never seen with muskets or any other sort of firearm, believing them too cowardly for someone of such noble stature. Knights of Sol are also known to keep squires in their service, often recruited from the ranks of the Gatekeepers.", attributes = {{Color(0, 225, 0), "(+) Bullet damage is reduced by 50%"}, {Color(0, 225, 0), "(+) Bulwark: +25 stamina and +25 stability"}, {Color(0, 225, 0), "(+) Starts with +75 maximum health"}, {Color(225, 0, 0), "(-) Burdened: Run speed is decreased by 10%"}, {Color(225, 0, 0), "(-) Honor Bound: Cannot equip firearms."}}, models = ministerModels},
		{name = "Low Ministry", startingRank = 12, whitelist = true, maps = {"rp_district21"}, subtitle = "The Low Ministry - Defenders of the Glaze", description = "Within the North exists a unique section of the Hierarchy - the Low Ministry. While behind closed doors the lesser clergy of the South operate, on the now-empty streets of hamlets in the North did the Low Ministry walk and preach. Even now in the streets of the Hill the Low Ministry defends the faith with zealous abandon. They have authority over all Men of the Watch and Wanderers, bar the lowly Almsman who stands only at the authority of a Yeoman, and are entrusted with keeping the cohesion of the community intact; with a holy book in one hand and a cross in the other. If they fail in their duties, dire punishment is to be wrought.", attributes = {{Color(0, 225, 0), "(+) Quiet Piety: 15% Faith Gain Boost"}, {Color(0, 225, 0), "(+) Blood of Zealots: Starts with +30 maximum health"}, {Color(225, 0, 0), "(-) Tier III and IV of the Prowess belief tree are locked"}}, models = ministerModels, namesOverride = "gore-glazic"}
	};
	FACTION.singleGender = GENDER_MALE;
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		--if (faction.name != "Wanderer" and faction.name != "Gatekeeper") then
			--return false;
		--end;
		
		--[[if player:GetFaith() ~= "Faith of the Light" or player:GetSubfaith() == "Voltism" then
			return false;
		end]]--
		
		--[[if (!Clockwork.player:IsWhitelisted(player, "Holy Hierarchy")) then
			Clockwork.player:SetWhitelisted(player, "Holy Hierarchy", true);
		end;]]--
	end;
	
	if SERVER then
		function FACTION:CanEnlist(player, target, faction, subfaction)
			if !player:IsAdmin() then
				if faction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						if subfaction and subfaction.name ~= playerSubfaction then
							return false;
						end
					end
				end
			end
		end
		
		function FACTION:CanPromote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				if faction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						if subfaction and subfaction.name ~= playerSubfaction then
							return false;
						end
					end
				end
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				if faction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						if subfaction and subfaction.name ~= playerSubfaction then
							return false;
						end
					end
				end
			end
		end
	end
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end

	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	Schema.Ranks["Holy Hierarchy"] = {
		[1] = "Sir",
		[2] = "Apprentice",
		[3] = "Vicar",
		[4] = "Justicar",
		[5] = "Inquisitor",
		[6] = "Minister",
		[7] = "Grand Knight",
		[8] = "Ordinator",
		[9] = "Magistrate",
		[10] = "Grand Inquisitor",
		[11] = "Regent",
		[12] = "Almsman",
		[13] = "Pater",
		[14] = "Castigator",
		[15] = "Suffragan",
		[16] = "High Priest",
	};
	
	Schema.RankTiers["Holy Hierarchy"] = {
		[1] = {"Sir", "Apprentice", "Vicar", "Almsman"},
		[2] = {"Justicar", "Inquisitor", "Minister", "Pater", "Castigator"},
		[3] = {"Grand Knight", "Ordinator", "Magistrate", "Suffragan"},
		[4] = {"Grand Inquisitor", "Regent", "High Priest"},
	};
	
	Schema.RanksToSubfaction["Holy Hierarchy"] = {
		["Sir"] = "Knights of Sol",
		["Justicar"] = "Knights of Sol",
		["Grand Knight"] = "Knights of Sol",
		["Apprentice"] = "Inquisition",
		["Inquisitor"] = "Inquisition",
		["Ordinator"] = "Inquisition",
		["Grand Inquisitor"] = "Inquisition",
		["Almsman"] = "Low Ministry",
		["Pater"] = "Low Ministry",
		["Castigator"] = "Low Ministry",
		["Suffragan"] = "Low Ministry",
		["High Priest"] = "Low Ministry",
	};
FACTION_HIERARCHY = FACTION:Register();

local FACTION = Clockwork.faction:New("Goreic Warrior");
	FACTION.disabled = false; -- For events.
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_gores";
	FACTION.color = Color(100, 100, 100);
	FACTION.description = "The brutal spearfolk clansmen of the North, unmatched in their endurance and strength, have come together for the first time. \nAt the heart of their warcamp lies the Great Tree, that which has been scarred by the Holy Hierarchy and must be restored through bloodshed. \nThe Clans must put aside their differences and launch a godly raid upon the last remaining Glazic Lands, to seek vengeance and glory. \nIf their Great Tree suffers another catastrophe, their connection to the Five Gods will be forever cut and all the world will perish. \nFor that reason they must endure ever harder, for there are many more threats abroad than the shattered Hierarchy."
	FACTION.availablefaiths = {"Faith of the Family"};
	FACTION.subfactionsToAvailableFaiths = {["Clan Reaver"] = {"Faith of the Family", "Faith of the Dark"}};
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.2; -- 0.2 slots per player (6 at 30 players).
	FACTION.imposters = true;
	FACTION.names = "goreic";
	FACTION.subfactions = {
		{
			name = "Clan Gore",
			subtitle = "Followers of the Father - Warriors and Hunters",
			description = [[Clan Gore is currently known as the Crown Clan, a title given to the most powerful of all the Clans. Following the Father, Clan Gore was born by bloodshed and conquest. The previous Crown Clan and followers of the Father, Clan Ghorst, had a war chief who made the mistake of fathering a bastard child and leaving it to the wolves to be devoured. The boy was instead raised by these wolves and took on the name Reaper King Kalkaslash. With an army of skinwalkers and werewolves, Kalkaslash butchered his way into his father's long hall and shredded him into a bloody mess with his claws. From then on he seized his throne and forced the other Clans to kneel with his newly gained army of warrior men. For the next hundred years, Clan Gore would capture women by the thousands and breed new warriors to continue the cycle. The Father is harsh and unforgiving, but with his strength, empires will fall.]],
			rivalry = "Clan Grock",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +40 maximum health"},
				{Color(0, 225, 0), "(+) Skilled Hunters: Deal 50% more damage to animals"},
				{Color(0, 225, 0), "(+) Start at Sacrament Level 8"}
			}
		},
		{
			name = "Clan Harald",
			subtitle = "Followers of the Old Son - Sailors and Explorers",
			description = [[Clan Harald is the second oldest Clan belonging to the Goreic peoples, the oldest being Clan Grock. The salt of the sea runs through the blood of these men, and their home is whatever lies beyond. For the past several hundred years, Clan Harald has had no true chieftain, ever since it was cursed by the trickster god of The Sister. Any man who calls himself the Chieftain of the sea, and therefore head of Clan Harald, shall die by drowning. Instead, a council of the most experienced (and stubborn) sailors oversees their business. In these current dark times, the Haralders seek to end their curse and become the new Crown Clan. Unknown to the other Clans, the followers of the Old Son see their deity as a massive beast who lives in the deepest, darkest depths of the ocean. They plan to awaken it and watch their world submerge, while they thrive above with mighty sails.]],
			rivalry = "Clan Reaver",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +35 maximum health"},
				{Color(0, 225, 0), "(+) Access to greater Longships"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}
			}
		},
		{
			name = "Clan Reaver",
			startingRank = 7,
			subtitle = "Followers of the Sister - Slavers and Merchants",
			description = [[The most wealthy of all Clans, the Reavers uphold Goreic society and economy but are looked down upon by the others. Seen as weak and as tricksters, they are never trusted, and for good reason. The Goreic people are cursed to live in infertile lands, and thus survive through raiding. The Reavers follow The Sister and take joy in causing misery, even without reason. Their seat is the Hall of Tears — a terrifying place where people are suspended on the brink of death for amusement. They do not fight honorably but use curses and manipulation. Some believe the Sister and the Dark Prince may be the same deity.]],
			rivalry = "Clan Harald",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +25 maximum health"},
				{Color(0, 225, 0), "(+) Passive salary of Coins every hour"},
				{Color(0, 225, 0), "(+) Double Coin from selling slaves"},
				{Color(0, 225, 0), "(+) Can choose the Faith of the Dark"},
				{Color(0, 225, 0), "(+) Sorcerer and Survivalist beliefs from Faith of the Dark grant +25 max health"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}
			}
		},
		{
			name = "Clan Shagalax",
			subtitle = "Followers of the Young Son - Builders and Blacksmiths",
			description = [[A Shagalaxian is said to be born with steel skin and molten iron in their veins. Once the mightiest of Clans, their steam-belching tanks burned forests and conquered armies. Their downfall came after allying with a mechanical Titan-God during the Undergod’s invasion, only to be betrayed and destroyed. Some remain loyal to the Young Son, a deity of charity and ingenuity — but others still dream of the day their tanks return to turn the world to ash.]],
			rivalry = "Clan Crast",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +30 maximum health"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 8 with points in 'Ingenuity'"},
				{Color(0, 225, 0), "(+) Can craft and use firearms and crossbows"},
				{Color(0, 225, 0), "(+) +5kg extra weight capacity"}
			}
		},
		{
			name = "Clan Crast",
			startingRank = 3,
			subtitle = "Followers of the Mother - Shamans and Mystics",
			description = [[Once reviled as weak, followers of the Mother were allowed to live only by royal decree. Some became mystics with the Vision — a power to see into fate. Clan Crast now warns others of impending doom, having accurately predicted the fall of the Great Tree. They commune with the Earth and wield ancient weapons in hopes of restoring what was lost.]],
			rivalry = "Clan Shagalax",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +25 maximum health"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 12"},
				{Color(0, 225, 0), "(+) Can unlock Ravenspeak"},
				{Color(0, 225, 0), "(+) Can craft and use crossbows"},
				{Color(225, 0, 0), "(-) Start with -4 Trait Points"}
			}
		},
		{
			name = "Clan Grock",
			subtitle = "Followers of the Old Ways - Nomads",
			description = [[The oldest Gore tribe, Grocks follow no gods and trust only in their survival. Bestial and wild, they are mocked by other Clans, especially Clan Gore. Still, when their Great Tree is threatened, even the most cynical Gore will call upon the Grocks for defense. They do not rely on armor or structured society but endure regardless.]],
			rivalry = "Clan Gore",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +175 maximum health"},
				{Color(0, 225, 0), "(+) Warcries instantly restore 25 stamina"},
				{Color(0, 225, 0), "(+) Throwing stones deal 50% more stability damage; unlocks heavy runestone weapons"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 8"},
				{Color(0, 225, 0), "(+) +10kg extra weight capacity"},
				{Color(225, 0, 0), "(-) Cannot wear Medium or Heavy armor"},
				{Color(225, 0, 0), "(-) Subfaith Tree is locked and cannot be progressed"}
			}
		},
		{
			name = "Clan Gotnarh",
			subtitle = "Followers of the Old Ways - Towering Savages",
			description = "PENDING",
			rivalry = "Clan Ghorst",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +225 maximum health"},
				{Color(0, 225, 0), "(+) Warcries instantly restore 25 stamina"},
				{Color(0, 225, 0), "(+) Throwing stones deal 50% more stability damage; unlocks heavy runestone weapons"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 10"},
				{Color(0, 225, 0), "(+) +10kg extra weight capacity"},
				{Color(0, 225, 0), "(+) Able to harvest unique and default resource nodes by hand"},
				{Color(225, 0, 0), "(-) Cannot wear Medium or Heavy armor"},
				{Color(225, 0, 0), "(-) Subfaith Tree is locked"},
				{Color(225, 0, 0), "(-) Litheness Tree is locked"},
				{Color(225, 0, 0), "(-) Movement speed decreased by 20%"},
				{Color(225, 0, 0), "(-) Starts with the Gluttony trait enabled"}
			}
		},
		{
			name = "Clan Ghorst",
			subtitle = "Followers of the Father, and Old Son - Champions of a Lost Cause",
			description = "PENDING",
			rivalry = "Clan Gore, Clan Shagalax, Clan Gotnarh, Clan Grock",
			attributes = {
				{Color(0, 225, 0), "(+) Starts with +35 maximum health"},
				{Color(0, 225, 0), "(+) Conquerors: Access to Greater Longships"},
				{Color(0, 225, 0), "(+) Arbalests: Allows use of Crossbows"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 7"},
				{Color(0, 225, 0), "(+) Trappers: Deal 50% more damage to animals"},
				{Color(225, 0, 0), "(-) Bygone Favor: The Fortune tree is locked, and cannot be progressed"}
			}
		}
	}

	FACTION.models = {
		male = {
			clothes = "models/begotten/goreicwarfighters/goretribal_male.mdl",
			heads = {
				"male_90",
				"male_91",
				"male_92",
				"male_93",
				"male_94",
				"male_95",
				"male_96"
			},
		},
	};
	FACTION.singleGender = GENDER_MALE;
	
	if SERVER then
		function FACTION:CanPromote(player, target, faction, subfaction)
			if subfaction == "Clan Grock" or subfaction == "Clan Gotnarh" then
				return false;
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if subfaction == "Clan Grock" or subfaction == "Clan Gotnarh"  then
				return false;
			end
		end
	end
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end

	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	Schema.Ranks["Goreic Warrior"] = {
		[1] = "",
		[2] = "Housecarl",
		[3] = "Soothsayer",
		[4] = "Seer",
		[5] = "Admiral",
		[6] = "Ironborn",
		[7] = "Marauder",
		[8] = "Red Wolf",
		[9] = "Chieftain",
		[10] = "Elder",
		[11] = "Grand Admiral",
		[12] = "King's Chosen",
		[13] = "King",
	};
	
	Schema.RankTiers["Goreic Warrior"] = {
		[1] = {"", "Soothsayer", "Marauder"},
		[2] = {"Housecarl", "Seer", "Admiral", "Ironborn", "Red Wolf"},
		[3] = {"Chieftain", "Elder", "Grand Admiral"},
		[4] = {"King's Chosen"},
		[5] = {"King"},
	};
	
	Schema.RanksToBuffs["Goreic Warrior"] = {
		["King"] = {health = 50, stamina = 50},
	};
	
	Schema.RanksToSubfaction["Goreic Warrior"] = {
		["Admiral"] = "Clan Harald",
		["Grand Admiral"] = "Clan Harald",
		["Soothsayer"] = "Clan Crast",
		["Seer"] = "Clan Crast",
		["Elder"] = "Clan Crast",
		["Ironborn"] = "Clan Shagalax",
		["Marauder"] = "Clan Reaver",
		["Red Wolf"] = "Clan Reaver",
	};
FACTION_GOREIC = FACTION:Register();

local FACTION = Clockwork.faction:New("Children of Satan");
	FACTION.disabled = false; -- For events.
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_satanists";
	FACTION.color = Color(125, 10, 10);
	FACTION.description = "Those selected to join the Children of Satan are exceptional individuals, be they particularly twisted and cunning, or perhaps born with the blood of ancient royalty. \nFor this reason the Children are few in number compared to the other powers, but they make up for this with their unmatched skill and grace. \nThe average Child of Satan is centuries old, obsessed with higher forbidden knowledge and glorious works of art and passion, yet they still have very much to learn. \nFearing what becomes of their corrupted souls if they are to meet an unforseen fate before reaching Demonhood, a Child of Satan will rarely risk their life for a prize not satisfactory. \nThey are the unseen puppet masters; the Glaze and the Gore must be kept in the balance, for Satan desires more subjects in his war against the Undergod, and extinction will only result in His victory.";
	FACTION.availablefaiths = {"Faith of the Dark"};
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.1667; -- 0.1667 slots per player (5 at 30 players).
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Varazdat", subtitle = "House Varazdat - Master Swordsmen and Drinkers of Blood", description = "The Eastern Nigerii Empire is aptly known as the Land of a Thousand Princes for its infamous lust-crazed Emperors. Several of these Emperors held tremendous orgies in their palace grounds that led to many bastard children. Due to unclear laws of succession, this led to an unending stretch of wars hosted in the Far East for a throne soaked in blood. Among the thousands of claimants to the throne was the Varazdat child, one who had very little royal blood in him, but all the ambition in the world. While the other pretenders were propped up by wealthy spice merchants and noblemen, Varazdat was a gutter rat who began his climb by pickpocketing and throat slicing. He kidnapped other claimants and prepared their bodies into fine feasts, their tender meat spiced and roasted to perfection. For each would-be Prince he killed and cannibalized, he absorbed their power and birthright. At the end of his road he was positively bloated, his belly full of royalty, and his claim to the throne backed by millions of mercenaries. The Varazdat reign did not last very long, as most go, but it opened the way for future Emperors to seek powers from the Dark. Today those who share the blood of House Varazdat are feared as particularly ruthless schemers, and child-eaters.", attributes = {{Color(0, 225, 0), "(+) Bloodlust: +10% sprint speed when above 95% health"}, {Color(0, 225, 0), "(+) Lifeleech: 70% in Light Armor, 50% in Medium Armor, 30% in Heavy Armor"}, {Color(0, 225, 0), "(+) Eastern Warriors: +25 health and +15 stamina"}, {Color(0, 225, 0), "(+) Starts at sacrament level 5, with the 'Savage' and 'Heart Eater' beliefs unlocked"}, {Color(225, 0, 0), "(-) Can only gain sustenance from feeding on human flesh"}, {Color(225, 0, 0), "(-) Crazed Cannibals: Sanity loss is increased by 50%"}}},
		{name = "Rekh-khet-sa", subtitle = "House Rekh-khet-sa - Immortal Sorcerers of the Darkness", description = "The formation of the House of Rekh-khet-sa dates back to long before recorded history within \'Egypt\', a forgotten land. Ancient Egyptians were tainted by Lucifer to use dark magics in their horrific pursuits of absolute immortality in the name of their Pharaoh. Although all of their original members are deceased, their greed for attaining immortality still persists to this very day, with their ancient texts being the basis for the Rekh-khet-sa\'s modern day reformation. Many members of the House Rekh-khet-sa pursue the so-called Ancient One's quest for immortality, imbued with visions from the Dark Prince, and obsessed with collecting artifacts to help achieve their goals, with some being successful and being able to perform such magics as reversing age. Because of this, many older members of Rekh-khet-sa tend to be wiser than the other houses, able to gain a wealth of experience. Though each member of this bloodline may be hundreds of years old, they live eternally in darkness. When the light of Sol shines upon them, they shrivel up, their perfect skin rotting away, revealing the cost of eternal life.", attributes = {{Color(0, 225, 0), "(+) Ancient Sorcerers: Gain no corruption or sanity loss"}, {Color(0, 225, 0), "(+) Can craft 'Hellforged Steel' without the 'Sorcerer' belief"}, {Color(0, 225, 0), "(+) Infinite level cap & +25% increased faith gain"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 16, with 'Primevalism' unlocked"}, {Color(0, 225, 0), "(+) Has +5kg extra weight capacity"}, {Color(225, 0, 0), "(-) Sustain periodic damage if outside during daytime"}}},
		{name = "Philimaxio", subtitle = "House Philimaxio - Black Knights Sworn to the Dark Prince", description = "When the Undergod swept over the lands of Sol to bring ruination and purification, almost all the central Districts fell immediately. The White Sentinels of District Seventeen begged to differ. Their stronghold was ravaged time and time again by the hordes of the unliving thralls, and each time they fell onto the blades of the Sentinels. They were no mere guardsmen, but renowned nobles of the iron-fisted Philimaxio family. In the Holy Hierarchy, very few noble houses would ever stoop so low as to bear arms directly. The Philimaxios were martialists, stout and hardy, always ready for the time in which a great foe would rise against them. Indeed they held their District Seventeen until there was no longer any reason to do so, as the Empire of Light shattered around them and they were stranded. Realizing their predicament, the Philimaxios found themselves surrounded by dark temptations. The Dark Prince whispered in their ears, wearing down on their spiritual resolve until they found themselves turning against the Light. The White Sentinels turned crimson as they slaughtered every serf, noble, and citizen alike within District Seventeen. The Philimaxios were one of the first to join the Children of Satan, seeking out the haunted manor where they would become unholy guardsmen of a Satanic Dreadlord. Quiet, strong, dutiful and unmoving, the sons of the Philimaxio Bloodline will hold back all who dare threaten the followers of Darkness.", attributes = {{Color(0, 225, 0), "(+) Armored Wall: Armor is 10% more protective"}, {Color(0, 225, 0), "(+) Bullet damage is reduced by 50%"}, {Color(0, 225, 0), "(+) Warrior Nobles: +50% health, +15 stability, +15 stamina"}, {Color(0, 225, 0), "(+) Blacksteel: The effects of 'Impossibly Skilled' apply to Longswords as well"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(225, 0, 0), "(-) Honor Bound: Cannot equip firearms."}}},
		{name = "Kinisger", subtitle = "House Kinisger - Mutant Masters of Infiltration and Assassination", description = "Chaos, deception, and trickery. House Kinisger has existed since the The First Inquisition. When deception was high within the Empire of Light, Lord Maximus stepped forth and revealed the existence of the Black-Hats; black blooded mutants taking on the appearance of men of Faith who had infiltrated society to spread chaos. The Inquisition was then called to bring an end to the Black-Hats, with some having to use witchery to disguise their black blood to crimson red, and when the Inquisition had begun executing anyone they were mildly suspicious of they had to take to more extreme measures. This was the beginning of their pact, as they had used dark rituals to disguise their flesh into different appearances. Practically any Black-Hat who did not use this method was executed in the First Inquisition. Thus, the descendants of House Kinisger are all Black-Hats who still remain true to the Dark. Their members to this day have become experienced in the art of infiltrating society and have become excellent spies and ritual masters. Before turning to the Dark, the mutant amish of House Kinisger were the equivalent of cockroaches - willing to do anything to merely stay alive amongst men who sought their demise. They used their flesh sorcery to hide in plain sight, to live amongst the enemy. Now they have awoken to their true purpose, to sow chaos and doubt, to always seek to topple any great threat from within.", attributes = {{Color(0, 225, 0), "(+) Faceless: Unique Rituals to alter appearance or cloak"}, {Color(0, 225, 0), "(+) Assassin: Deal 25% more damage with daggers"}, {Color(0, 225, 0), "(+) Immune to blood tests (excluding false positives)"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(225, 0, 0), "(-) Mutant Blood: Start with -3 Trait Points"}}}
	};
	--FACTION.singleGender = GENDER_MALE;
	
	--[[if game.GetMap() == "rp_district21" then
		FACTION.models = {
			["male"] = {
				clothes = "models/begotten/wanderers/northwanderer_male.mdl",
				heads = DEFAULT_MODELS.male.heads,
			},
			["female"] = {
				clothes = "models/begotten/wanderers/northwanderer_female.mdl",
				heads = DEFAULT_MODELS.female.heads,
			},
		}
	end]]--
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if player:GetFaith() ~= "Faith of the Dark" then
			return false;
		end
		
		--[[if (!Clockwork.player:IsWhitelisted(player, "Children of Satan")) then
			Clockwork.player:SetWhitelisted(player, "Children of Satan", true);
		end;]]--
	end;
	
	function FACTION:CanPromote(player, target, faction, subfaction)
		if !player:IsAdmin() then
			-- Aspirants can't be manually promoted, they must use their ritual.
			if target:GetCharacterData("rank") == 10 then
				return false;
			end
		end
	end
	
	function FACTION:GetPlayerCount()
		local numPlayers = 0;

		for _, v in _player.Iterator() do
			if (v:HasInitialized()) then
				if (v:GetFaction() == "Children of Satan") then
					if v:GetCharacterData("rank") == 10 then
						numPlayers = numPlayers + 0.5; -- Aspirants only count for 0.5.
					else
						numPlayers = numPlayers + 1;
					end
				end
			end
		end
		
		return numPlayers;
	end
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end

	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	Schema.Ranks["Children of Satan"] = {
		[1] = "",
		[2] = "Dark Justicar",
		[3] = "Hierophant",
		[4] = "Sultan",
		[5] = "Black Finger",
		[6] = "Immortal",
		[7] = "Dreadlord",
		[8] = "Hell Baron",
		[9] = "Caretaker",
		[10] = "Aspirant",
	};
	
	Schema.RankTiers["Children of Satan"] = {
		[1] = {"", "Aspirant"},
		[2] = {"Dark Justicar", "Hierophant", "Sultan", "Black Finger", "Immortal"},
		[3] = {"Dreadlord"},
		[4] = {"Caretaker"},
		[5] = {"Hell Baron"},
	};
	
	Schema.RanksToBuffs["Children of Satan"] = {
		["Hell Baron"] = {health = 50, stamina = 50},
	};
	
	Schema.RanksToSubfaction["Children of Satan"] = {
		["Dark Justicar"] = "Philimaxio",
		["Hierophant"] = "Rekh-khet-sa",
		["Sultan"] = "Varazdat",
		["Black Finger"] = "Kinisger",
	};
FACTION_SATANIST = FACTION:Register();

----------------------
----------------------
--- Event Factions ---
----------------------
----------------------

-- For Begotten II Map Change Event.
local FACTION = Clockwork.faction:New("Pope Adyssa's Gatekeepers");
	FACTION.hidden = true;
	FACTION.disabled = true; -- For events.
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_gatekeepers_adyssa";
	FACTION.color = Color(20, 20, 20);
	FACTION.description = "The Gatekeepers are the front line of defence against the countless unholy horrors that threaten the Glaze. \nTheir ranks swell with conscripted power-hungry commoners and fanatical flagellants. \nThey must serve the Holy Hierarchy diligently and without question, no matter how outrageous their demands may be. \nIll-trained and poorly equipped, these soldiers are expected to lay their lives down to protect the Light. \nAnd so they shall.";
	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.enlist = true;
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.3; -- 0.3 slots per player (9 at 30 players).
	--FACTION.imposters = true;
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end
	
	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	if !Schema.RanksToCoin then
		Schema.RanksToCoin = {};
	end
	
	Schema.Ranks["Pope Adyssa's Gatekeepers"] = {
		[1] = "DISCIPLE",
		[2] = "ACOLYTE",
		[3] = "EMISSARY",
		[4] = "HIGH-EMISSARY",
		[5] = "MASTER-AT-ARMS",
	};
	
	Schema.RankTiers["Pope Adyssa's Gatekeepers"] = {
		[1] = {"DISCIPLE"},
		[2] = {"ACOLYTE"},
		[3] = {"EMISSARY"},
		[4] = {"HIGH-EMISSARY"},
		[5] = {"MASTER-AT-ARMS"},
	};
	
	Schema.RanksToBuffs["Pope Adyssa's Gatekeepers"] = {
		["MASTER-AT-ARMS"] = {health = 50, stamina = 50},
	};

	Schema.RanksToCoin["Pope Adyssa's Gatekeepers"] = {
		[1] = 25,
		[2] = 35,
		[3] = 50,
		[4] = 100,
		[5] = 200, 
	};
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name != "Wanderer" and faction.name != "Holy Hierarchy") then
			if player:GetSubfaction() ~= "Kinisger" then
				return false;
			end
		end;
		
		-- It is the IC responsibility of Gatekeepers to bloodtest recruits.
		--[[if player:GetFaith() ~= "Faith of the Light" or player:GetSubfaith() == "Voltism" then
			return false;
		end]]--
		
		if (!Clockwork.player:IsWhitelisted(player, "Pope Adyssa's Gatekeepers")) then
			Clockwork.player:SetWhitelisted(player, "Pope Adyssa's Gatekeepers", true);
		end;
	end;
	
	if SERVER then
		function FACTION:CanPromote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
	end
	
	-- Called when a player's name should be assigned for the faction.
	function FACTION:GetNameCharCreation(name, rank, rankOverride)
		if !rank then
			return "GATEKEEPER-DISCIPLE."..name;
		end

		if rankOverride then
			return "GATEKEEPER-"..rankOverride.."."..name;
		end

		return "GATEKEEPER-"..Schema.Ranks["Pope Adyssa's Gatekeepers"][rank or 1].."."..name;
	end;
	
	-- Called when a player's name should be assigned for the faction.
	function FACTION:GetName(player, bNew)
		if bNew or !player:GetCharacterData("rank") then
			return Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5);
		end
	
		local name = player:Name();
		local rankOverride = player:GetCharacterData("rankOverride");
		
		if !tonumber(name) then
			Clockwork.player:SetName(player, Clockwork.kernel:ZeroNumberToDigits(math.random(1, 99999), 5));
			name = player:Name();
		end

		if rankOverride then
			return "GATEKEEPER-"..rankOverride.."."..name;
		end
		
		local rank = math.Clamp(player:GetCharacterData("rank", 1), 1, #Schema.Ranks["Pope Adyssa's Gatekeepers"]);

		if (rank and isnumber(rank) and Schema.Ranks["Pope Adyssa's Gatekeepers"][rank]) then
			return "GATEKEEPER-"..Schema.Ranks["Pope Adyssa's Gatekeepers"][rank].."."..name;
		end;
	end;
FACTION_GATEKEEPER_ADYSSA = FACTION:Register();

-- For Scraptown Map Change Change Event.
local FACTION = Clockwork.faction:New("The Third Inquisition");
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.disabled = true; -- For events.
	FACTION.hidden = true;
	FACTION.material = "begotten/faction/faction_logo_gatekeepers_adyssa";
	FACTION.color = Color(225, 175, 0);
	FACTION.description = "From the ashes of the Town of Light comes a third Inquisition, loyal in memoriam to Pope Adyssa. \nTheir goal is to unseat the false pope Aratakrast and put an end to his court's decadence. \nThey seek to civilize the County Districts through holy powder and steel, and thus fight on. \nYet, it is unlikely that this junior insurrection will succeed against the raging inferno of barbarism and apocalypse.";
	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.names = "glazic";
	FACTION.imposters = true;
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name != "Wanderer" and faction.name != "Holy Hierarchy" and faction.name != "Gatekeeper") then
			return false;
		end;
		
		if player:GetFaith() ~= "Faith of the Light" or player:GetSubfaith() == "Voltism" then
			return false;
		end
		
		if (!Clockwork.player:IsWhitelisted(player, "The Third Inquisition")) then
			Clockwork.player:SetWhitelisted(player, "The Third Inquisition", true);
		end;
	end;
FACTION_THIRD_INQUISITION = FACTION:Register();

local FACTION = Clockwork.faction:New("Smog City Pirate");
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.disabled = true; -- For events.
	FACTION.hidden = true;
	FACTION.material = "begotten/faction/faction_logo_scrappers";
	FACTION.color = Color(92, 64, 51);
	FACTION.description = "The dreaded denizens of Smog City, a place of machines and misery. \nSworn to build a Mechanical God, the pirate slavers command a disposable workforce of Wanderers to construct this terrible titan. \nThe divided backgrounds and conflictions of faith bring forth infighting within the ranks of the Pirates. \nOnly under the iron fist of their King are the gangs put in line.";
	FACTION.availablefaiths = {"Faith of the Light", "Faith of the Family", "Faith of the Dark"};
	FACTION.subfactions = {
		{name = "Machinists", subtitle = "Brutal Scrappers and Slavers", description = "It it said that the foul stench of the scrapper machinists, that of rotting meat and gunpowder, can be smelled for miles around. The Scrappers align themselves with the most powerful and use faith as a means to become stronger than their peers. They are scavengers, slavers, and above all else, human cockroaches.", attributes = {{Color(0, 225, 0), "(+) Hardened Savages: +30 maximum health"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 8"}, {Color(225, 0, 0), "(-) The Voltist subfaith tree is locked and cannot be progressed!"}}},
		{name = "Voltists", subtitle = "Technological Fanatics & Transhumanists", description = "The Electrozombified of the Smog City Pirates think themselves above the struggle and desire that their brothers have fallen to. They see to the whims of the Program - a technological device above human understanding - and seek to combine its intelligence with the Mechanical God whence it is constructed.", attributes = {{Color(0, 225, 0), "(+) Starts at Sacrament Level 11, with 'Voltism' unlocked"}}},
	};
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.names = "glazic";
	FACTION.imposters = true;
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name ~= "Wanderer") then
			return false;
		end;
		
		if (!Clockwork.player:IsWhitelisted(player, "Smog City Pirate")) then
			Clockwork.player:SetWhitelisted(player, "Smog City Pirate", true);
		end;
	end;
FACTION_SMOG_CITY_PIRATES = FACTION:Register();

local FACTION = Clockwork.faction:New("Hillkeeper");
	local goreglazeModels = {
		male = {
			clothes = "models/begotten/wanderers/northwanderer_male.mdl",
			heads = {
				"male_02",
				"male_04",
				"male_06",
				"male_07",
				"male_08",
				"male_09",
				"male_11",
				"male_12",
				"male_16",
				"male_22",
				"male_56"
			},
		},
		female = {
			clothes = "models/begotten/wanderers/northwanderer_female.mdl",
			heads = {
				"female_01",
				"female_02",
			}
		}
	};
	
	if game.GetMap() == "rp_district21" then
		FACTION.disabled = false;
	else
		FACTION.disabled = true;
		FACTION.hidden = true;
	end

	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_hillkeepers";
	FACTION.color = Color(103, 142, 180);
	FACTION.description = "The Goreic-Glazemen of the Hill are a simple, hardy folk. They have raised their blades and bats and hooks against the darkness for generations. \nThey don't fight for coin, but for survival and family. All must pull together to survive in the empty cold. \nPagan heresy spreads once more through the ranks, but many still stand faithful and loyal to the Light no matter the cost. \nNow they must stand resolute against the coming darkness, even as the long night draws close. The Hill must not fall. \nGlory awaits the bold and daring.";	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.alliedfactions = {"Holy Hierarchy", "Gatekeeper"};
	FACTION.masterfactions = {"Holy Hierarchy"};
	FACTION.enlist = true;
	FACTION.promoteAcrossSubfactions = true;
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.3; -- 0.3 slots per player (9 at 30 players).
	--FACTION.imposters = true; -- Kinisgers should get enlisted through /enlist on Wanderer disguises.
	FACTION.names = "gore-glazic";
	FACTION.subfactions = {
		{
			name = "Watchman",
			subtitle = "Watchmen - Militiamen of the Hill",
			description = "Throughout much of the Hierarchy, each of the Districts found they required protection. This led to the introduction of the Lower Orders, the Gatekeepers, to hold their gates and defend their flagging settlements. In the harsh and cold north, where two men could live in the same area and never meet one another, the few district settlements that existed in the cold needed no organized standing force of soldiers. But when the Gores came, or thralls threatened their families, they organized fyrds and pressgangs, militias born of necessity. The Hill of Light expects every man of able body to serve in the Town Watch for at least a few years, and so this has made it the Hill's equivalent of the Lower Order; a gang of conscripts and peasants. These men have fought for generations for a multitude of reasons, always ready to take up arms to defend their home.",
			attributes = {
				{Color(0, 225, 0), "(+) Martial Ancestry: Starts with +10 maximum stamina"},
				{Color(0, 225, 0), "(+) Blood of the Gore: Starts with +30 maximum health."},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 6"},
				{Color(0, 225, 0), "(+) Boisterous: +100% faith gain from dealing damage"},
				{Color(0, 225, 0), "(+) Voice of the North: Able to Warcry"},
				{Color(225, 0, 0), "(-) Pious: Restricted to the 'Hard-Glaze' subfaith"},
				{Color(225, 0, 0), "(-) Burdened: Run speed is decreased by 5%"}
			},
			models = goreglazeModels
		},
		{
			name = "Servus",
			subtitle = "Servants - Stokers and Physicians",
			description = "There are few in the northern districts who can claim to know valuable skills beyond hunting or fighting, and the few who know how to read, tend wounds, or stoke the mighty forges are quickly taken under the Ministry's wing. The servus are the ones that serve the Watch of the Hill by authority of the Cardinal, the few learned men of the settlement that know how to stitch up bloody limbs or forge fine weapons. For their knowledge, they are not expected to bloody their blades. However, in the harsh empty of the north, there will always be a reason to fight alongside one's brothers.",
			attributes = {
				{Color(0, 225, 0), "(+) Learned Few: +25% increased faith gain"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 12"},
				{Color(0, 225, 0), "(+) Voice of the North: Able to Warcry"},
				{Color(0, 225, 0), "(+) Stoker's Might: Starts with +25 health and +5 stamina"},
				{Color(0, 225, 0), "(+) Has +5kg extra weight capacity"},
				{Color(225, 0, 0), "(-) Tier IV of the Prowess belief tree is locked"},
				{Color(225, 0, 0), "(-) The 'Voltism' subfaith is locked"}
			},
			models = goreglazeModels
		},
		{
			name = "Outrider",
			startingRank = 10,
			whitelist = true,
			subtitle = "Coachmen - Scouts and Thieves",
			description = "To waste a life in the north is to waste a set of hands that could be used for better things. To this end the Outriders serve a dual purpose in that they allow the criminals a chance to regain their honor and serve the Light before their death, and allow the wretched of society to provide for the community while still atoning for their sins. For their lawbreaking they are sent out into the wilds outside of the safety of the walls, to scout and scavenge for the Ministry. While not all of the Outriders are criminals, the vast majority tend to be; a life toiling is better than a life ended.",
			attributes = {
				{Color(0, 225, 0), "(+) Second Chance: -25% stamina drain and +5% sprint speed"},
				{Color(0, 225, 0), "(+) Voice of the North: Able to Warcry"},
				{Color(0, 225, 0), "(+) Starts at Sacrament Level 8"},
				{Color(225, 0, 0), "(-) The 'Sol Orthodoxy' and 'Voltism' subfaiths are locked"}
			},
			models = goreglazeModels
		},
	}
	FACTION.residualXPZones = { -- Zones that boost residual XP gain for this faction.
		["rp_begotten3"] = {
			{pos1 = Vector(1390, 10153, -938), pos2 = Vector(-2370, 11254, -1690), modifier = 0.5, nightModifier = 0.25}, -- Gate
			{pos1 = Vector(10061, 10379, -1211), pos2 = Vector(9385, 11870, -670), modifier = 0.33, nightModifier = 0.2}, -- Gorewatch
			{pos1 = Vector(3458, 12655, -814), pos2 = Vector(3335, 12769, -685), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(2742, 10244, -1194), pos2 = Vector(2913, 10071, -1074), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(-1963, 10678, -1055), pos2 = Vector(-2144, 10886, -1194), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
			{pos1 = Vector(-3468, 12985, -375), pos2 = Vector(-3591, 13103, -241), modifier = 0.5, nightModifier = 0.25}, -- Watchtower
		},
		["rp_district21"] = {
			{pos1 = Vector(-4765, 9246, 838), pos2 = Vector(-8075, 10488, 489), modifier = 0.5, nightModifier = 0.25}, -- Hill
			{pos1 = Vector(-10637, 13043, 465), pos2 = Vector(-4664, 9210, 879), modifier = 0.5, nightModifier = 0.25}, -- Hill
			{pos1 = Vector(-9328, -8640, -146), pos2 = Vector(-8771, -8105, 686), modifier = 0.33, nightModifier = 0.2}, -- Gorewatch
		},
	};
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name != "Wanderer" and faction.name != "Holy Hierarchy" and faction.name != "Gatekeeper") then
			if player:GetSubfaction() ~= "Kinisger" then
				return false;
			end
		end;
		
		-- It is the IC responsibility of Gatekeepers to bloodtest recruits.
		--[[if player:GetFaith() ~= "Faith of the Light" or player:GetSubfaith() == "Voltism" then
			return false;
		end]]--
		
		if (!Clockwork.player:IsWhitelisted(player, "Hillkeeper")) then
			Clockwork.player:SetWhitelisted(player, "Hillkeeper", true);
		end;
	end;
	
	if SERVER then
		function FACTION:CanPromote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if !player:IsAdmin() then
				local playerFaction = player:GetNetVar("kinisgerOverrideFaction") or player:GetFaction();
				
				if playerFaction == "Holy Hierarchy" then
					local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
					
					if playerSubfaction ~= "Ministry" then
						return false;
					end
				end
			end
		end
	end
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
	end
	
	if !Schema.RanksToBuffs then
		Schema.RanksToBuffs = {};
	end
	
	if !Schema.RanksToSubfaction then
		Schema.RanksToSubfaction = {};
	end
	
	if !Schema.RanksToCoin then
		Schema.RanksToCoin = {};
	end
	
	Schema.Ranks["Hillkeeper"] = {
        [1] = "Novice",
        [2] = "Yeoman",
        [3] = "Stoker",
        [4] = "Magnate",
        [5] = "Barber",
        [6] = "Surgeon",
        [7] = "Emissary",
        [8] = "High Emissary",
        [9] = "Master-At-Arms",
        [10] = "Footpad",
        [11] = "Highwayman",
        [12] = "Signifer",
		[13] = "Ealdorman",
		[14] = "Squire",
    };
	
	Schema.RankTiers["Hillkeeper"] = {
		[1] = {"Novice", "Footpad"},
		[2] = {"Yeoman", "Stoker", "Barber", "Highwayman", "Ealdorman"},
		[3] = {"Emissary", "Magnate", "Surgeon", "Signifer", "Squire"},
		[4] = {"High Emissary"},
		[5] = {"Master-At-Arms"},
	};
	
	Schema.RanksToBuffs["Hillkeeper"] = {
		["Master-At-Arms"] = {health = 50, stamina = 50},
	};
	
	Schema.RanksToSubfaction["Hillkeeper"] = {
		["Footpad"] = "Outrider",
		["Highwayman"] = "Outrider",
	};
	
	Schema.RanksToCoin["Hillkeeper"] = {
		[1] = 25,
		[2] = 35,
		[3] = 35,
		[4] = 50,
		[5] = 35,
		[6] = 50,
		[7] = 50,
		[8] = 100,
		[9] = 200,
		[10] = 35,
		[11] = 50,
		[12] = 50,
		[13] = 50,
	};

FACTION_HILLKEEPER = FACTION:Register();
