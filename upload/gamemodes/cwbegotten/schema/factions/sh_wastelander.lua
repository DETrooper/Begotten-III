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
	["goreic"] = {
		["male"] = {"Ale", "Alfr", "Alfgeir", "Anders", "Anlaufr", "Anundr", "Arnbjörn", "Arngrimr", "Arni", "Arnfast", "Asbjörn", "Bagge", "Baldr", "Barid", "Bengt", "Bersi", "Bertil", "Birger", "Björn", "Bo", "Borkvard", "Botulfr", "Bragi", "Buðli", "Dag", "Dan", "Dyre", "Eilif", "Egill", "Emund", "Einarr", "Eirikr", "Eskild", "Falki", "Faste", "Filip", "Fredrik", "Frirek", "Froði", "Freyr", "Folki", "Gandalfr", "Geirr", "Georg", "Gnupa", "Gorm", "Greger", "Grimr", "Guðfrið", "Guðmundr", "Guðröðr", "Gunnarr", "Hakon", "Halsten", "Haraldr", "Haukr", "Helgi", "Hemming", "Holmger", "Hrafn", "Hrolfr", "Hrane", "Hæsteinn", "Hjalmar", "Hroðgar", "Hroðulfr", "Hrörekr", "Hysing", "Ingólfr", "Ingemar", "Ingjald", "Ivar", "Jedvard", "Jon", "Karl", "Kettil", "Kettilmund", "Kjartan", "Klas", "Knut", "Kol", "Kolbjörn", "Magnus", "Markus", "Magni", "Mats", "Nils", "Niklas", "Oddr", "Ofeig", "Olafr", "Ormr", "Ottarr", "Refr", "Refil", "Ragnarr", "Rikulfr", "Rögnvaldr", "Skuli", "Snorri", "Sigbjörn", "Sigtrygg", "Sigurðr", "Starkaðr", "Steinn", "Sturla", "Styrbjörn", "Styrkar", "Sumarliði", "Suni", "Sveinn", "Sverker", "Sæmundr", "Sölvi", "Sörkver", "Tjudmund", "Toke", "Tolir", "Þorbjörn", "Þorfinn", "Þorbrandr", "Þordr", "Þorgil", "Þorsteinn", "Þorolfr", "Toste", "Totil", "Tryggve", "Tyke", "Ulfr", "Vagn", "Valdemar", "Åke", "Yngvar", "Örvar", "Öysteinn"},
		["female"] = {"Aleta", "Alfhildr", "Alfrið", "Alvör", "Anna", "Asa", "Aslaug", "Asta", "Astrid", "Beata", "Birgitta", "Björg", "Bodil", "Bothildr", "Cecilia", "Edla", "Elin", "Elisabet", "Freyja", "Gerðr", "Gloð", "Grima", "Gunnhildr", "Gurli", "Guðrun", "Gyla", "Gyrið", "Gyða", "Hafrid", "Halla", "Helena", "Holmfrid", "Iliana", "Inga", "Ingfrid", "Ingibjörg", "Ingjerðr", "Ingrid", "Karin", "Katarina", "Kraka", "Kristina", "Linda", "Maer", "Malmfrið", "Margareta", "Maria", "Rikissa", "Rögnfrið", "Rögnhildr", "Saga", "Sara", "Sif", "Sigrid", "Skuld", "Sofia", "Svanhildr", "Ulfhildr", "Vigdis", "Ylva", "Yrsa"}
	}
};

RANDOM_SURNAMES = {
	["glazic"] = {
		"Abriallias", "Aelius", "Anderson", "Antonius", "Appius", "Arcadius", "Armstrong", "Armistead", "Aetius", "Aurelius", "Bateman", "Barclay", "Brutus", "Buchanan", "Caecilius", "Carrinas", "Cassius", "Clemens", "Cornelius", "Chamberlain", "Cranston", "Crassus", "Crawford", "Decimius", "Dilworth", "Domitius", "Fabius", "Flavius", "Franklin", "Fulvius", "Galerius", "Hamilton", "Harris", "Harvus", "Honorius", "Horatius", "Julius", "Jupiter", "Koulius", "Krammy", "Labienus", "Lincoln", "Marius", "Morgan", "Morris", "Nasennius", "Oswald", "Opimius", "Patrobius", "Parker", "Petronius", "Philadelphus", "Pompeius", "Quinctius", "Randolph", "Roberts", "Rufinius", "Septimius", "Severus", "Simmons", "Sheridan", "Stevens", "Stuart", "Sullivan", "Suetonius", "Taylor", "Temple", "Thompson", "Titus", "Tullius", "Tyler", "Valerius", "Vorenus", "Wales", "Wilkes"
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
	FACTION.imposters = true;
	FACTION.names = "glazic";
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if (faction.name == "Goreic Warrior") then
			return false;
		end;
	end;
FACTION_WANDERER = FACTION:Register();

local FACTION = Clockwork.faction:New("Gatekeeper");
	FACTION.disabled = false; -- For events.
	FACTION.whitelist = true;
	FACTION.useFullName = false;
	FACTION.material = "begotten/faction/faction_logo_gatekeepers";
	FACTION.color = Color(80, 100, 120);
	FACTION.description = "The Gatekeepers are the front line of defence against the countless unholy horrors that threaten the Glaze. \nTheir ranks swell with conscripted power-hungry commoners and fanatical flagellants. \nThey must serve the Holy Hierarchy diligently and without question, no matter how outrageous their demands may be. \nIll-trained and poorly equipped, these soldiers are expected to lay their lives down to protect the Light. \nAnd so they shall.";
	FACTION.availablefaiths = {"Faith of the Light"};
	FACTION.alliedfactions = {"Holy Hierarchy"};
	FACTION.masterfactions = {"Holy Hierarchy"};
	FACTION.enlist = true;
	FACTION.singleGender = GENDER_MALE;
	FACTION.characterLimit = 1; -- # of characters of this faction a player can have.
	FACTION.ratio = 0.3; -- 0.3 slots per player (9 at 30 players).
	--FACTION.imposters = true; -- Kinisgers should get enlisted through /enlist on Wanderer disguises.
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Legionary", subtitle = "Legionaries - Soldiers of the Church", description = "The Holy Order of the Gatekeepers has defended the Holy Hierarchy from unholy threats since time immemorial. They have seen many changes over the years and vary considerably in strength, equipment, and number from county district to county district, but nonetheless share a singular goal: to protect the Holy Hierarchy at all costs. Legionaries represent the rank and file of this Holy Order and know only the Glaze. These men are a mix of professional soldiers, conscripted wasteland filth, and religious zealots. They serve as frontline troops and guardsmen in service of the Holy Hierarchy, often taking considerable risks to advance their ministers' goals or to defend them.", attributes = {{Color(0, 225, 0), "(+) Constant Drilling: Starts with +15 maximum stamina"}, {Color(0, 225, 0), "(+) Nourishing Rations: Starts with +25 maximum health"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(0, 225, 0), "(+) Strength in Numbers: +100% faith gain from dealing damage"}, {Color(225, 0, 0), "(-) The 'Voltism' subfaith is locked"}}},
		{name = "Auxiliary", subtitle = "Auxilium - Smiths and Medici", description = "The backbone of the Holy Order and the purveyors of its superior ingenuity, auxiliaries uphold supply, maintain the troops, and act as reservists in combat. As Smiths they arm the ranks with superior weaponry, man the cannons and fortify defensive locations. As Medici they prevent outbreaks in the ranks and mend injuries taken from battle. They are still expected to fight if need be, though are not as often put into harm's way as their legionary kin.", attributes = {{Color(0, 225, 0), "(+) Men of Knowledge: +25% increased faith gain"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 12"}, {Color(225, 0, 0), "(-) Tier IV of the Prowess belief tree is locked"}, {Color(225, 0, 0), "(-) The 'Voltism' subfaith is locked"}}},
		{name = "Praeventor", startingRank = 12, whitelist = true, subtitle = "Praeventores - Scouts and Assassins", description = "Taking the name of a similar unit from ancient Roman times, the Praeventores serve as a small but elite cadre of scouts, hunters, and assassins for the Holy Order. Recruited from the most loyal and skilled followers of Hard-Glaze, the Praeventores lack any standardized gear to help them blend in whilst performing their duties in the wastes. These duties include: reporting on enemy movements, scavenging valuable artifacts or needed supplies, assassinating enemies of the Holy Hierarchy or sniping targets at long range, bringing in or dispatching the targets of bounties, and gathering information.", attributes = {{Color(0, 225, 0), "(+) Excursionists: -25% stamina drain and +5% sprint speed"}, {Color(0, 225, 0), "(+) Masters of Disguise: Recognising does not reveal your rank"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 8"}, {Color(225, 0, 0), "(-) The 'Sol Orthodoxy' and 'Voltism' subfaiths are locked"}}},
	};
	FACTION.residualXPZones = { -- Zones that boost residual XP gain for this faction.
		["rp_begotten3"] = {
			{pos1 = Vector(1390, 10153, -938), pos2 = Vector(-2370, 11254, -1690), modifier = 2, nightModifier = 4}, -- Gate
			{pos1 = Vector(9422, 11862, -1210), pos2 = Vector(10055, 10389, -770), modifier = 3, nightModifier = 5}, -- Gorewatch
			{pos1 = Vector(3458, 12655 -814), pos2 = Vector(3335, 12769, -685), modifier = 2, nightModifier = 4}, -- Watchtower
			{pos1 = Vector(2742, 10244, -1194), pos2 = Vector(2913, 10071, -1074), modifier = 2, nightModifier = 4}, -- Watchtower
			{pos1 = Vector(-1963, 10678, -1055), pos2 = Vector(-2144, 10886, -1194), modifier = 2, nightModifier = 4}, -- Watchtower
			{pos1 = Vector(-3468, 12985, -375), pos2 = Vector(-3591, 13103, -241), modifier = 2, nightModifier = 4}, -- Watchtower
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
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
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
	FACTION.alliedfactions = {"Gatekeeper"};
	FACTION.enlist = true;
	FACTION.ratio = 0.1; -- 0.1 slots per player (3 at 30 players).
	--FACTION.imposters = true;
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Ministry", startingRank = 3, whitelist = true, subtitle = "The Ministry - The Privileged Few Overseers of Glazic Supremacy", description = "The Holy Hierarchy is perhaps the only surviving institution of the old world and is the only known church of the Light remaining. Many view the Holy Hierarchy as the direct continuation of the Empire of Light, including the Holy Hierarchy themselves, who push this narrative to solidify their grasp on their subjects. Any who doubt its legitimacy are executed on the spot. Lording over most of the 'civilized' peasantry that wander the wasteland, the Holy Hierarchy strictly enforces its religious codes, which are ever-changing at the whim of the Pope. At the very top of the Hierarchy lies the Pope, supreme in power. He lives in a penthouse at the top of the hotel in absolute luxury in comparison to the shanties that the rabble share. Below him lies the cardinals, who serve as the Pope's council. Lower still are the Bishops, many of whom are now in open rebellion against the new Pope, with some even claiming his title as their own. Lastly, there are the priests, who are barely above commoner status and equal in rank to those in the Knights of Sol or Inquisition. A priest's duties often involve searching ancient texts held within the grand archives for any advantage that could be offered to the Hierarchy over their rivals, or for clues to decipher the ramblings of the machine that so many wanderers speak of.", models = ministerModels},
		{name = "Inquisition", startingRank = 2, whitelist = true, subtitle = "The Second Inquisition - Hunters, Judges, and Executioners", description = "The Holy Order of the Glaze's Inquisitors is an ancient institution, founded by Lord Maximus during his campaigns against the Black Hats and born of a need to destroy infilitrators and weed out heresy. Although disbanded after their task was completed, it would not be long before the Inquisition was re-instated, as enemies of the Glaze only grew in both numbers and ferocity. The coming of the Undergod and subsequent displacement of the Dark Lord from Hell only strengthened the need for the Inquisition, as unknown powers were now openly unleashed upon mankind. The Inquisition is the most important line of defense for the Holy Hierarchy, as they root out the hidden enemies of the Glaze and uphold religious doctrine. Inquisitors strictly abide by their 'Book of Law', which details their methodology and the rules by which all followers of the Glaze must adhere to. The inquisition also holds the unique ability to hold any member of Glazic society accountable to the 'Book of Law', including members of the Holy Hierarchy. Accusations of heresy are not taken lightly however, and being proved wrong after accusing someone in power may have disastrous consequences for the accuser.", attributes = {{Color(0, 225, 0), "(+) Pious: +50% increased faith gain"}, {Color(0, 225, 0), "(+) Starts with +50 maximum health"}}}, 
		{name = "Knights of Sol", startingRank = 1, whitelist = true, subtitle = "The Knights of Sol - The Most Devoted Order of the Glaze", description = "Only a few years ago Skylight fell to Earth in a blazing inferno, the last promise of a future for mankind careening into the ground alongside it. From its innumerable enlightened inhabitants only seventeen emerged: the Glorious Seventeen. Donning glorious white armor and wielding sword glowing bright, the Glorious Seventeen slaughtered every demon that fell upon them. Thousands fell by their blade before the demons retreated into the darkness, and it seemed that humanity would live for at least another day. Although the Glorious Seventeen no longer walk this Earth, their legacy lives on in the newly founded Holy Order of the Knights of Sol. These Knights of Sol consist of the very best of the Holy Hierarchy, unmatched in prowess and seen by many of the faithful as guardian angels incarnate. Knights are given the absolute best equipment available in the royal armories. Despite this, Knights are never seen with muskets or any other sort of firearm, believing them too cowardly for someone of such noble stature. Knights of Sol are also known to keep squires in their service, often recruited from the ranks of the Gatekeepers.", attributes = {{Color(0, 225, 0), "(+) Bullet damage is reduced by 70%"}, {Color(0, 225, 0), "(+) Bulwark +25 stamina and +25 stability"}, {Color(0, 225, 0), "(+) Starts with +75 maximum health"}, {Color(225, 0, 0), "(-) Burdened: Run speed is decreased by 15%"}}, models = ministerModels}
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
			if faction == "Holy Hierarchy" then
				local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
				
				if playerSubfaction ~= "Ministry" then
					if subfaction and subfaction.name ~= playerSubfaction then
						return false;
					end
				end
			end
		end
		
		function FACTION:CanPromote(player, target, faction, subfaction)
			if faction == "Holy Hierarchy" then
				local playerSubfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
				
				if playerSubfaction ~= "Ministry" then
					if subfaction and subfaction.name ~= playerSubfaction then
						return false;
					end
				end
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
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
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
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
	};
	
	Schema.RankTiers["Holy Hierarchy"] = {
		[1] = {"Sir", "Apprentice", "Vicar"},
		[2] = {"Justicar", "Inquisitor", "Minister"},
		[3] = {"Grand Knight", "Ordinator", "Magistrate"},
		[4] = {"Grand Inquisitor", "Regent"},
	};
	
	Schema.RanksToSubfaction["Holy Hierarchy"] = {
		["Sir"] = "Knights of Sol",
		["Justicar"] = "Knights of Sol",
		["Grand Knight"] = "Knights of Sol",
		["Apprentice"] = "Inquisition",
		["Inquisitor"] = "Inquisition",
		["Ordinator"] = "Inquisition",
		["Grand Inquisitor"] = "Inquisition",
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
	FACTION.ratio = 0.25; -- 0.25 slots per player (8 at 30 players).
	FACTION.imposters = true;
	FACTION.names = "goreic";
	FACTION.subfactions = {
		{name = "Clan Gore", subtitle = "Followers of the Father - Warriors and Hunters", description = "Clan Gore is currently known as the Crown Clan, a title given to the most powerful of all the Clans. Following the Father, Clan Gore was born by bloodshed and conquest. The previous Crown Clan and followers of the Father, Clan Ghorst, had a war chief who made the mistake of fathering a bastard child and leaving it to the wolves to be devoured. The boy was instead raised by these wolves and took on the name Reaper King Kalkaslash. With an army of skinwalkers and werewolves, Kalkaslash butchered his way into his father's long hall, and shred him into a bloody mess with his claws. From then on he seized his throne, and forced the other Clans to kneel with his newly gained army of warrior men. For the next hundred years to follow, Clan Gore would capture women by the thousands and breed new warriors, for they would birth thousands more ruthless killers to continue the process. The Father is harsh and unforgiving, but with his strength empires will fall.", rivalry = "Clan Grock", attributes = {{Color(0, 225, 0), "(+) Starts with +50 maximum health"}, {Color(0, 225, 0), "(+) Skilled Hunters: Deal 50% more damage to animals"}, {Color(0, 225, 0), "(+) Start at Sacrament Level 8"}}}, 
		{name = "Clan Harald", subtitle = "Followers of the Old Son - Sailors and Explorers", description = "Clan Harald is the second oldest Clan belonging to the Goreic peoples, the oldest being Clan Grock. The salt of the sea runs through the blood of these men, and their home is whatever lies beyond. For the past several hundred years Clan Harald has had no true chieftain, ever since it was cursed by the trickster god of The Sister. Any man who calls themselves the Chieftain of the sea, and therefore head of Clan Harald, shall die by drowning. While there is never a head of Clan Harald, there always exists a council of the most experienced (and stubborn) sailors who oversee business. In these current dark times, the Haralders seek to end their curse and become the new Crown Clan, as they feel they were always meant to be. The Haralder sailors will always be at odds with the followers of The Sister, horrible tricksters who create storms that turn their longships into the burning sea. Unknown to all the other Clans, the followers of the Old Son see their deity as a massive beast who lives in the deepest darkest depths of the ocean, and soon they will wake it and watch their entire world submerge underneath the waters, while they thrive above with their mighty sails.", rivalry = "Clan Reaver", attributes = {{Color(0, 225, 0), "(+) Starts with +45 maximum health"}, {Color(0, 225, 0), "(+) Access to greater Longships"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}}}, 
		{name = "Clan Reaver", startingRank = 7, subtitle = "Followers of the Sister - Slavers and Merchants", description = "The most wealthy of all Clans, the Reavers are the upholders of Goreic society and economy, but are often looked down on by the others. Seen as weak and as tricksters, they are never trusted by the other Clans, and for good reason. The Goreic people are cursed to live in infertile lands, and for that reason they must survive by the raiding of weaker peoples. Yet the Reavers follow The Sister, and they see it as their right to cause misery to others, even when they have no practical reason for it. Their seat is that of the Hall of Tears, a terrifying place somewhere hidden in the woods, where people are suspended on the brink of death for as long as they provide amusement. Instead of meeting their enemies on an open field like their brutish brothers, the Reavers will cast curses upon their foes or even puppeteer entire factions to do their bidding. Some in the South presume that the followers of the Sister may actually be doing the work of the Dark Prince, though the Reavers might even suggest that both gods are one and the same.", rivalry = "Clan Harald", attributes = {{Color(0, 225, 0), "(+) Starts with +25 maximum health"}, {Color(0, 225, 0), "(+) Gain a passive salary of Coins every hour"}, {Color(0, 225, 0), "(+) Gain double the coin from selling slaves"}, {Color(0, 225, 0), "(+) Can choose the Faith of the Dark as a faith"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}}}, 
		{name = "Clan Shagalax", subtitle = "Followers of the Young Son - Builders and Blacksmiths", description = "It is said that a Shagalaxian is born with steel skin and molten iron flowing in their blood. Without their metal, the bloodthirsty Gores would be throwing sticks and stones instead of their mighty steel. There was a time long ago when the Shagalaxians were considered the mightiest of all Clans and all tribes united under their banner; when their steam belching tanks threw flames across valleys, turning armies and forests into ash. Pathetic arrows plinked off many plates of steel as their legions of tanks rolled over fields of terrified tribes and towns of the Glaze alike. It was only when the weaklings of Clan Crast foresaw Clan Shagalax's dealings with a mechanical Titan-God that their title of Crown Clan was in need of defiance. So it was that when the Undergod entered this world, the Shagalaxians took advantage and began their invasion of the ever-hated Empire of Light with the combined might of the Gore tribes. However, the Shagalaxians soon learned that the Undergod had no allies, and in their greatest moment of weakness their remnants were conquered by the followers of The Father at the behest of Clan Crast. It was then deemed that only The Father and by proxy Clan Gore may lord over the other Clans. Those Shagalaxians cut off from their brethren during the Undergod's invasion now comprise many of the scrapper warbands that plague the wasteland, but a small number of those still connected to the Great Tree yet remain among the great clans. Many Shagalaxians claim they are loyal to The Young Son, a deity of charity and ingenuity, though in secret it is said that there are those who follow a mechanical titan and wait patiently for the time when their legions of tanks are rebuilt so that they may turn this world into ash once more.", rivalry = "Clan Crast", attributes = {{Color(0, 225, 0), "(+) Starts with +30 maximum health"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 8, with points placed in \'Ingenuity\'"}, {Color(0, 225, 0), "(+) Can craft and use firearms and crossbows"}}}, 
		{name = "Clan Crast", startingRank = 3, subtitle = "Followers of the Mother - Shamans and Mystics", description = "While all followers of The Family respect The Mother's role and contribution to the rough but fair cycle of nature and death, those actually born under her are looked down upon as weak and pathetic. In those days the followers of The Mother would be thrown off high cliffs to splatter on the rocks below, as they would never grow to be great warriors like the followers of The Father would. Then it was decided by a more benevolent King of the Bark Throne that one in every tenth child born under the sign of The Mother would be permitted to live. As always these lucky children grew up to be queer and disfigured little things, but they did have gifts that made them useful. Some became bards, entertainers: a juggling dwarf or a two-headed giant. Others had The Vision, a way to see into the dark void of fate itself. With a new generation of mystic beings, a new Clan was formed, the first ever to follow The Mother. To this day Clan Crast thrives without bloodshed, as their great blinded seers look into the darkness to warn the others of their perils ahead. When a seer foresaw the killing of the Great Tree at the hands of the Holy Hierarchy's fire-breathing dragons, and no one believed him, the Gores learned to never mistrust the warnings of their Crasters again. The current line of Clan Crast are most in touch with the Blade Druids of old, and seek to use their ancient weapons forged by the Earth itself. A great ritual awaits Clan Crast, to restore their Great Tree, and the other Clans stand by to see this through.", rivalry = "Clan Shagalax", attributes = {{Color(0, 225, 0), "(+) Starts with +25 maximum health"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 12"}, {Color(0, 225, 0), "(+) Can unlock the ability to Ravenspeak"}, {Color(0, 225, 0), "(+) Can craft and use crossbows"}, {Color(225, 0, 0), "(-) Start with -4 Trait Points"}}}, 
		{name = "Clan Grock", subtitle = "Followers of the Old Ways - Nomads", description = "The first Gore tribe to come settle near the Great Tree. The oldest Clan of all Gores, and those who refused to follow the gods of The Family. While many followers of the Old Ways acknowledge the existence of The Family, they choose to instead go their own way and entrust in themselves to see their own path in life. All Gores believe they are fated to die and whatever they do cannot change that, and so those of the Old Ways agree that they will continue to struggle to survive until that day comes. The average Grock is much taller and stronger than their brothers, with a thick coat of black hair covering their unwashed bodies, giving them a bestial look. Clan Grock will never hold any power as their beliefs encourage a nomadic lifestyle, one free of society, laws and the reliance of other men. The only time they will ever be called in by the others is if their Great Tree is under attack, and then and only then will they charge forth to defend their home lands. Clan Grock is considered a joke to the other Clans, men who would rather lay with beasts than a good woman. The worst of them are Clan Gore, the arrogant Kings of Old who hosted 'Great Hunts' to slaughter as many Grocks as possible for glory and bragging rights. Still, when their great gods fail them, those of the Old Ways will always endure.", rivalry = "Clan Gore", attributes = {{Color(0, 225, 0), "(+) Starts with +175 maximum health"}, {Color(0, 225, 0), "(+) Savage: Warcries instantly restore 25 stamina"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 8"}, {Color(225, 0, 0), "(-) Cannot wear Medium or Heavy armor"}, {Color(225, 0, 0), "(-) The Subfaith Tree is locked and cannot be progressed"}}}
	};
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
			if subfaction == "Clan Grock" then
				return false;
			end
		end
		
		function FACTION:CanDemote(player, target, faction, subfaction)
			if subfaction == "Clan Grock" then
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
	FACTION.ratio = 0.134; -- 0.134 slots per player (4 at 30 players).
	FACTION.names = "glazic";
	FACTION.subfactions = {
		{name = "Varazdat", subtitle = "House Varazdat - Master Swordsmen and Drinkers of Blood", description = "The Eastern Nigerii Empire is aptly known as the Land of a Thousand Princes for its infamous lust-crazed Emperors. Several of these Emperors held tremendous orgies in their palace grounds that led to many bastard children. Due to unclear laws of succession, this led to an unending stretch of wars hosted in the Far East for a throne soaked in blood. Among the thousands of claimants to the throne was the Varazdat child, one who had very little royal blood in him, but all the ambition in the world. While the other pretenders were propped up by wealthy spice merchants and noblemen, Varazdat was a gutter rat who began his climb by pickpocketing and throat slicing. He kidnapped other claimants and prepared their bodies into fine feasts, their tender meat spiced and roasted to perfection. For each would-be Prince he killed and cannibalized, he absorbed their power and birthright. At the end of his road he was positively bloated, his belly full of royalty, and his claim to the throne backed by millions of mercenaries. The Varazdat reign did not last very long, as most go, but it opened the way for future Emperors to seek powers from the Dark. Today those who share the blood of House Varazdat are feared as particularly ruthless schemers, and child-eaters.", attributes = {{Color(0, 225, 0), "(+) Bloodlust: +10% sprint speed when above 95% health"}, {Color(0, 225, 0), "(+) Lifeleech: 50% damage dealt returned as health."}, {Color(0, 225, 0), "(+) Eastern Warriors: Starts with +25 maximum health and +15 maximum stamina"}, {Color(0, 225, 0), "(+) Starts with the 'Savage' and 'Heart Eater' beliefs unlocked"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 5"}, {Color(225, 0, 0), "(-) Can only gain sustenance from feeding on human flesh"}, {Color(225, 0, 0), "(-) Crazed Cannibals: Sanity loss is increased by 50%"}}},
		{name = "Rekh-khet-sa", subtitle = "House Rekh-khet-sa - Immortal Sorcerers of the Darkness", description = "The formation of the House of Rekh-khet-sa dates back to long before recorded history within \'Egypt\', a forgotten land. Ancient Egyptians were tainted by Lucifer to use dark magics in their horrific pursuits of absolute immortality in the name of their Pharaoh. Although all of their original members are deceased, their greed for attaining immortality still persists to this very day, with their ancient texts being the basis for the Rekh-khet-sa\'s modern day reformation. Many members of the House Rekh-khet-sa pursue the so-called Ancient One's quest for immortality, imbued with visions from the Dark Prince, and obsessed with collecting artifacts to help achieve their goals, with some being successful and being able to perform such magics as reversing age. Because of this, many older members of Rekh-khet-sa tend to be wiser than the other houses, able to gain a wealth of experience. Though each member of this bloodline may be hundreds of years old, they live eternally in darkness. When the light of Sol shines upon them, they shrivel up, their perfect skin rotting away, revealing the cost of eternal life.", attributes = {{Color(0, 225, 0), "(+) Ancient Sorcerers: Gain no corruption or sanity loss"}, {Color(0, 225, 0), "(+) Can craft 'Hellforged Steel' without the 'Sorcerer' belief"}, {Color(0, 225, 0), "(+) Infinite level cap & +25% increased faith gain"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 16, with 'Primevalism' unlocked"}, {Color(225, 0, 0), "(-) Sustain periodic damage if outside during daytime"}}},
		{name = "Philimaxio", subtitle = "House Philimaxio - Black Knights Sworn to the Dark Prince", description = "When the Undergod swept over the lands of Sol to bring ruination and purification, almost all the central Districts fell immediately. The White Sentinels of District Seventeen begged to differ. Their stronghold was ravaged time and time again by the hordes of the unliving thralls, and each time they fell onto the blades of the Sentinels. They were no mere guardsmen, but renowned nobles of the iron-fisted Philimaxio family. In the Holy Hierarchy, very few noble houses would ever stoop so low as to bear arms directly. The Philimaxios were martialists, stout and hardy, always ready for the time in which a great foe would rise against them. Indeed they held their District Seventeen until there was no longer any reason to do so, as the Empire of Light shattered around them and they were stranded. Realizing their predicament, the Philimaxios found themselves surrounded by dark temptations. The Dark Prince whispered in their ears, wearing down on their spiritual resolve until they found themselves turning against the Light. The White Sentinels turned crimson as they slaughtered every serf, noble, and citizen alike within District Seventeen. The Philimaxios were one of the first to join the Children of Satan, seeking out the haunted manor where they would become unholy guardsmen of a Satanic Dreadlord. Quiet, strong, dutiful and unmoving, the sons of the Philimaxio Bloodline will hold back all who dare threaten the followers of Darkness.", attributes = {{Color(0, 225, 0), "(+) Armored Wall: Heavy armor is 15% more protective"}, {Color(0, 225, 0), "(+) Armor condition deterioration is halved"}, {Color(0, 225, 0), "(+) Bullet damage is reduced by 70%"}, {Color(0, 225, 0), "(+) Warrior Nobles: +50% maximum health and +25 maximum stability"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(225, 0, 0), "(-) Burdened: Run speed is decreased by 15%"}}},
		{name = "Kinisger", subtitle = "House Kinisger - Mutant Masters of Infiltration and Assassination", description = "Chaos, deception, and trickery. House Kinisger has existed since the The First Inquisition. When deception was high within the Empire of Light, Lord Maximus stepped forth and revealed the existence of the Black-Hats; black blooded mutants taking on the appearance of men of Faith who had infiltrated society to spread chaos. The Inquisition was then called to bring an end to the Black-Hats, with some having to use witchery to disguise their black blood to crimson red, and when the Inquisition had begun executing anyone they were mildly suspicious of they had to take to more extreme measures. This was the beginning of their pact, as they had used dark rituals to disguise their flesh into different appearances. Practically any Black-Hat who did not use this method was executed in the First Inquisition. Thus, the descendants of House Kinisger are all Black-Hats who still remain true to the Dark. Their members to this day have become experienced in the art of infiltrating society and have become excellent spies and ritual masters. Before turning to the Dark, the mutant amish of House Kinisger were the equivalent of cockroaches - willing to do anything to merely stay alive amongst men who sought their demise. They used their flesh sorcery to hide in plain sight, to live amongst the enemy. Now they have awoken to their true purpose, to sow chaos and doubt, to always seek to topple any great threat from within.", attributes = {{Color(0, 225, 0), "(+) Faceless: Unique Rituals to alter appearance or cloak"}, {Color(0, 225, 0), "(+) Assassin: Deal 25% more damage with daggers"}, {Color(0, 225, 0), "(+) Immune to blood tests (excluding false positives)"}, {Color(0, 225, 0), "(+) Starts at Sacrament Level 6"}, {Color(225, 0, 0), "(-) Mutant Blood: Start with -3 Trait Points"}}}
	};
	--FACTION.singleGender = GENDER_MALE;
	
	-- Called when a player is transferred to the faction.
	function FACTION:OnTransferred(player, faction, name)
		if player:GetFaith() ~= "Faith of the Dark" then
			return false;
		end
		
		if (!Clockwork.player:IsWhitelisted(player, "Children of Satan")) then
			Clockwork.player:SetWhitelisted(player, "Children of Satan", true);
		end;
	end;
	
	if !Schema.Ranks then
		Schema.Ranks = {};
	end
	
	if !Schema.RankTiers then
		Schema.RankTiers = {};
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
	};
	
	Schema.RankTiers["Children of Satan"] = {
		[1] = {""},
		[2] = {"Dark Justicar", "Hierophant", "Sultan", "Black Finger", "Immortal"},
		[3] = {"Dreadlord"},
		[4] = {"Hell Baron", "Caretaker"},
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
