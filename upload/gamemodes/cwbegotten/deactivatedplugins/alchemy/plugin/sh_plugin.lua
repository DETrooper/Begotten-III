--[[

	Begotten 3

	Created by cash wednesday, gabs, DETrooper and alyousha35

--]]





PLUGIN:SetGlobalAlias("cwAlchemy");



cwAlchemy.Debug = false



--Clockwork.kernel:IncludePrefixed("cl_plugin.lua");

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

Clockwork.kernel:IncludePrefixed("sh_alchemyItems.lua");

Clockwork.kernel:IncludePrefixed("sh_throwable_base.lua");



-- units are in milliliters 

-- effect traits are based on damage/effect ratio per liter

-- cwAlchemy.mixes = {

	-- ["yum_chug"] = {

		-- name = "Yum Chug",

		-- ratio = {

			-- ["water"] = 90,

			-- ["chlorine"] = 10

		-- },

		-- tolerance = 9

	-- }

-- }



-- local COMMAND = Clockwork.command:New("PatOutFire");

-- COMMAND.tip = "Pat out a fire on your body.";

-- COMMAND.alias = {"PatOut", "PatFire"};



-- -- Called when the command has been run.

-- function COMMAND:OnRun(player, arguments)

	-- chems = player:GetCharacterData("cwAlchemyExposure")

	-- flames = cwAlchemy:ProcessFire(player, chems)

	-- if flames > 0 then

		-- flames = cwAlchemy:ProcessFire(player, chems, math.random(-20,-5))

		-- if flames == 0 then

			-- Clockwork.chatBox:AddInTargetRadius(player, "me", "manages to pat out the flames.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

		-- else

			-- Clockwork.chatBox:AddInTargetRadius(player, "me", "frantically pats at the flames engulfing their body!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

		-- end

	-- else

		-- Clockwork.chatBox:AddInTargetRadius(player, "me", "pats their body as if it's on fire, like some sort of idiot.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

	-- end;

-- end;



-- COMMAND:Register();







cwAlchemy.chemicals = {

	["water"] = {

		name = "Water",

		simplename = "colorless liquid",

		density = 1,

		desc = "Clear fluid necessary for life.",

		color = Color(150, 200, 255),

		stats = {

			biohazard = 0,

			chemhazard = 0,

			quench = 0.06

		},

		taste = "clear",

		tastestr = 0.01,

		solvent = 1

	},

	["chlorine"] = {

		name = "Chlorine",

		simplename = "colorless liquid",

		density = 1.11,

		desc = "Liquified chlorine gas. Fairly toxic.",

		color = Color(225, 200, 180),

		stats = {

			biohazard = -0.1,

			chemhazard = 0.02,

			quench = -0.05

		},

		explosive = 1,

		reactions =

		{

			["chemgas"] = {

				reactants = {

					["ammonia"] = 1

				},

				power = 0.1

			}

		},

		taste = "bitter and metallic",

		tastestr = 0.5

	},

	["ammonia"] = {

		name = "Ammonia",

		simplename = "colorless liquid",

		density = 0.97,

		desc = "The active ingredient in piss. Smells exactly like it.",

		color = Color(255,200,100),

		stats = {

			biohazard = 0,

			chemhazard = 0.01,

			quench = -0.05

		},

		taste = "piss",

		tastestr = 0.3

	},

	["codeine"] = { -- Codeine phosphate

		name = "Codeine",

		simplename = "purple-black stuff",

		density = 4,

		desc = "Opiate, can ease pain.",

		color = Color(180,50,150),

		stats = {

			biohazard = 0,

			chemhazard = 100,

			sanity = 1,

			quench = -0.1

		},

		flammable = 1,

		taste = "bitter",

		tastestr = 0.9

	},

	["iodine"] = {

		name = "Iodine",

		simplename = "purple-black stuff",

		density = 4.93,

		desc = "A chemical with mostly medical uses.",

		color = Color(129,255,0),

		stats = {

			biohazard = -0.5,

			chemhazard = 0.1,

			quench = -0.07

		},

		taste = "metallic, antiseptic",

		tastestr = 1

	},

	["ethanol"] = {

		name = "Ethanol",

		simplename = "colorless liquid",

		density = 0.78,

		desc = "A solvent. Useful for sterilizing things, or getting drunk.",

		color = Color(255,255,255),

		stats = {

			biohazard = -0.5,

			chemhazard = 0.05,

			drunk = 0.05,

			quench = -0.01

		},

		taste = "sweet, burning",

		flammable = 2,

		tastestr = 0.08,

		solvent = 0.8

	},

	["potassium_hydroxide"] = { -- Can be made with the ashes of wood fires

		name = "Potassium Hydroxide",

		simplename = "chunks of white powder",

		density = 2.12,

		desc = "Powdery compound, somewhat corrosive.",

		color = Color(200,200,200),

		stats = {

			biohazard = 0,

			chemhazard = 1,

			quench = -0.1

		},

		reactions =

		{

			["boil"] = {

				reactants = {

					["water"] = 1,

				},

				power = 1,

				anyreact = true,

			},

			["make"] = {

				reactants = {

					["acetic_acid"] = 1

				},

				catalysts = {

					["water"] = 0.5

				},

				power = 0.1,

				result = "potassium_acetate"

			}

		},

		taste = "bitter",

		tastestr = 2

	},

	["potassium_acetate"] = { -- Can be made with the ashes of wood fires

		name = "Potassium Acetate",

		simplename = "a white powder",

		density = 1.57,

		desc = "The rarest chemical in the wasteland. Soap.",

		color = Color(200,200,200),

		stats = {

			biohazard = 0,

			chemhazard = 0.5,

			quench = -0.1

		},

		taste = "salty",

		tastestr = 2

	},

	["nitric_acid"] = {

		name = "Nitric Acid",

		simplename = "colorless liquid",

		density = 1.51,

		desc = "Mineral acid. Mostly useless on its own.",

		color = Color(255,200,100),

		stats = {

			biohazard = -0.5,

			chemhazard = 10,

			quench = -0.2

		},

		taste = "bitter and acidic",

		tastestr = 0.1

	},

	["sulfuric_acid"] = {

		name = "Sulfuric Acid",

		simplename = "colorless liquid",

		density = 1.83,

		desc = "Hazardous acid. Has some industrial uses.",

		color = Color(201,212,76),

		stats = {

			biohazard = -1,

			chemhazard = 50,

			quench = -5

		},

		reactions =

		{

			["boilacid"] = {

				reactants = {

					["ethanol"] = 1,

					["water"] = 1

				},

				power = 1,

				anyreact = true,

			},

			["make"] = {

				reactants = {

					["nitric_acid"] = 1

				},

				catalysts = {

					["water"] = 0.5

				},

				power = 0.5,

				result = "nitroglycerin"

			}

		},

		taste = "sour and acidic",

		tastestr = 0.5

	},

	["acetic_acid"] = {

		name = "Acetic Acid",

		density = 1.83,

		desc = "The active ingredient in vinegar. Highly corrosive in pure form.",

		color = Color(205,186,153),

		stats = {

			biohazard = -1,

			chemhazard = 5,

			quench = -1

		},

		reactions =

		{

			["boil"] = {

				reactants = {

					["sulfuric_acidf"] = 1

				},

				catalysts = {

					["water"] = 1

				},

				power = 1

			}

		},

		taste = "sour and acidic",

		tastestr = 0.5

	},

	["plague_bile"] = {

		name = "Dark Bile",

		density = 4.5,

		desc = "An oozing, black goo.",

		color = Color(70,70,70),

		stats = {

			biohazard = 1,

			chemhazard = 0,

			plague = 0.5

		},

		taste = "slimy and rotten",

		flammable = 0.5,

		tastestr = 0.3

	},

	["dark_fungus"] = {

		name = "Black Fungus",

		density = 1.5,

		desc = "Pitch black fungus that pulsates steadily.",

		color = Color(70,70,70),

		stats = {

			biohazard = 2,

			chemhazard = 0,

			plague = 0.5

		},

		taste = "slimy and rotten",

		flammable = 0.5,

		tastestr = 0.2

	},

	["waste"] = {

		name = "Waste",

		density = 4.5,

		desc = "A disgusting mix of various wastes, mostly shit.",

		color = Color(0,51,8),

		stats = {

			biohazard = 0.1,

			chemhazard = 0

		},

		taste = "literal shit",

		tastestr = 0.5

	},

	["potassium_cyanide"] = {

		name = "Cyanide",

		density = 1.52,

		desc = "Chemically proven to be your only way out.",

		color = Color(0,255,200),

		stats = {

			biohazard = 0,

			chemhazard = 200

		},

		taste = "bitter almond",

		tastestr = 0.2

	},

	["dirt"] = {

		name = "Dirt",

		density = 1.33,

		desc = "Dust, grime, and mud.",

		color = Color(155,118,88),

		stats = {

			biohazard = 0.01,

			chemhazard = 0,

			quench = -0.05

		},

		taste = "grimy",

		tastestr = 1

	},

	["clay"] = {

		name = "Clay",

		density = 1.7,

		desc = "Fine-grained, wet mix of mineral-rich earth.",

		color = Color(127,95,63),

		stats = {

			biohazard = 0,

			chemhazard = 0,

			quench = -0.05

		},

		unstable = -150,

		explosive = 0,

		taste = "earthy",

		tastestr = 1

	},

	["regfire"] = {

		name = "Fire",

		density = 0.01,

		desc = "Fire. You probably have more important things to handle than reading this.",

		color = Color(226,88,34),

		stats = {

			biohazard = -1,

			chemhazard = -1,

			quench = -1

		},

		reactions =

		{

			["null"] = {

				reactants = {

					["water"] = 1

				},

				power = 1

			},

			["ignite"] = {

				reactants = {

					["ethanol"] = 1

				},

				power = 1

			},

			["ignite"] = {

				reactants = {

					["nitric_acid"] = 0.1

				},

				power = 5

			},

			["explodefire"] = {

				reactants = {

					["iodine"] = 1,

					["dimethylcadmium"] = 1

				},

				power = 1,

				anyreact = true

			}

		},

		taste = "smoke and burning flesh",

		tastestr = 5

	},

	["dimethylcadmium"] = {

		name = "Dimethylcadmium",

		density = 1.985,

		desc = "A mostly-experimental compound, infamous for its lethality. How it got here is a mystery.",

		color = Color(155,118,88),

		stats = {

			biohazard = 0,

			chemhazard = 100,

			quench = 0

		},

		unstable = 1000,

		explosive = 10,

		reactions =

		{

			["explodefire"] = {

				reactants = {

					["water"] = 1

				},

				power = 10

			}

		},

		taste = "metallic",

		tastestr = 0.2

	},

	["nitroglycerin"] = {

		name = "Nitroglycerin",

		density = 1.985,

		desc = "A highly unstable, explosive compound.",

		color = Color(155,118,88),

		stats = {

			biohazard = 0,

			chemhazard = 100,

			quench = 0

		},

		unstable = 75,

		explosive = 1,

		taste = "oily and sweet",

		tastestr = 0.2

	}

};



-- Generate debug jerry cans

for k, v in pairs(cwAlchemy.chemicals) do

	local ITEM = Clockwork.item:New("container_base");

	ITEM.name = "Jerry Can";

	ITEM.uniqueID = "jerrycan_debug_"..k;

	ITEM.model = "models/props_junk/metalgascan.mdl";

	ITEM.description = "The label reads: "..v.name;

	ITEM.baseWeight = 1;

	ITEM.chemcontents = {

	[k]=20000

	};

	ITEM.capacity = 20000;

	ITEM:Register();

end



function cwAlchemy:GenerateTaste(composition, total)

	local composition = composition or {};

	local taste = ""

	local thelist = {

	}

	local words = {

		["entirely"] = {

			"entirely",

			"completely",

			"totally"

		},

		["mostly"] = {

			"mostly",

			"largely",

			"chiefly",

			"primarily",

			"almost completely"

		},

		["partly"] = {

			"partly",

			"partially",

			"moderately"

		},

		["barely"] = {

			"barely",

			"mildly"

		},

		["mild"] = {

			"light",

			"mild",

			"weak"

		},

		["strong"] = {

			"heavy",

			"strong",

			"powerful"

		}

	}

	local function randsynonym(term)

		ans = ""

		if istable(words[term]) then

			length = table.Count( words[term] )

			ans = words[term][math.random(1,length)]

		end

		return ans;

	end

	local totaltaste = 0

	local lasttaste = 0

	for chem, volume in pairs(composition) do

		tastestr = cwAlchemy:GetLiquid(chem).tastestr or 0;

		tastetype = cwAlchemy:GetLiquid(chem).taste or "tasteless"

		tastepower = (volume*tastestr);

		totaltaste = totaltaste + tastepower;

		if tastepower > lasttaste then

			table.insert(thelist, 1, {power=tastepower,desc=tastetype})

		else

			table.insert(thelist, {power=tastepower,desc=tastetype})

		end

		lasttaste = volume;

	end

	

	if (SERVER and cwAlchemy.Debug) then

		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Total Odor: "..totaltaste);

		PrintTable(composition)

	end

	

	if istable(thelist[1]) then

		smellperc = (thelist[1].power/totaltaste) * 100;

		if smellperc == 100 then

			trm = "entirely"

		elseif smellperc > 70 then

			trm = randsynonym("mostly")

		else

			trm = randsynonym("partly")

		end

		taste = trm.." "..thelist[1].desc

		str = thelist[1].desc or "tasteless"

		if istable(thelist[2]) then

			smellperc = (thelist[2].power/totaltaste) * 100;

			

			if smellperc > 35 then

				trm = randsynonym("partly")

			else

				trm = randsynonym("barely")

			end

			taste = taste.." and "..trm.." "..thelist[2].desc

			if istable(thelist[3]) then

				smellperc = (thelist[3].power/totaltaste) * 100;

				if smellperc > 10 then

					trm = randsynonym("strong")

				else

					trm = randsynonym("mild")

				end

				taste = taste..", with a "..trm.." "..thelist[3].desc.." aftertaste"

			end

		end

	end

	

	if (SERVER and cwAlchemy.Debug) then

		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Tastestr: "..taste);

	end

	return taste;

end;



--Detect and trigger chemical reactions. Returns tables with data about the reaction and updated contents.

function cwAlchemy:CalcExplosiveStats(contents, shock)

	local contents = contents or {};

	local explodepower=0;

	local totalinstability=0;

	local volume = 0;

	local explosives = {};

	if table.Count( contents ) > 0 then

		if (SERVER and cwAlchemy.Debug) then

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Checking Destabilizations:");

		end

		for chem, ml in pairs( contents ) do

			local chemical = cwAlchemy:GetLiquid( chem );

			if (SERVER and cwAlchemy.Debug) then

				Clockwork.kernel:PrintLog(LOGTYPE_MINOR, chem..":"..cwAlchemy:ConvertUnits(ml));

			end

			if istable(chemical) then

				if not table.IsEmpty(chemical) then

					volume = volume + ml

					local instability = chemical.unstable or 0;

					local kaboom = chemical.explosive or 0;

					kaboom = kaboom*50

					if instability ~= 0 then

						totalinstability = totalinstability + ((instability/100) * ml)

						explodepower = explodepower + ((kaboom/100) * ml)

					end

				end

			else

				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "ALCHEMY ERROR: Invalid chemical found!");

			end

		end;

	end;

	totalinstability = math.Clamp((totalinstability/volume)*100,0,100)

	local canExplode = (totalinstability > 0);

	local doesExplode = (shock > totalinstability) and canExplode;

	local output = { explode = doesExplode, unstable = totalinstability, boompower = explodepower }

	return output;

end



--Return a mix's total amount of solvent/sticky points.

function cwAlchemy:GetSolventRating(contents)

	local contents = contents or {};

	local eluentstrength=0;

	local stickstrength=0;

	local volume = 0;

	if table.Count( contents ) > 0 then

		for chem, ml in pairs( contents ) do

			local chemical = cwAlchemy:GetLiquid( chem );

			if not table.IsEmpty(chemical) then

				volume = volume + ml

				local strength = chemical.solvent or 0;

				local stick = chemical.sticky or 0;

				eluentstrength = eluentstrength + (strength*ml);

				stickstrength = stickstrength + (stick*ml);

			end

		end;

	end;

	return {solvent=eluentstrength,sticky=stickstrength, total=eluentstrength-stickstrength};

end



--Detect and trigger chemical reactions. Returns tables with data about the reaction and updated contents.

function cwAlchemy:DoReactions(contents)

	local contents = contents or {};

	if table.Count( contents ) > 0 then

		if (SERVER and cwAlchemy.Debug) then

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Checking Chemical Reactions:");

		end

		for chem, ml in pairs( contents ) do

			local chemical = cwAlchemy:GetLiquid( chem );

			if (SERVER and cwAlchemy.Debug) then

				Clockwork.kernel:PrintLog(LOGTYPE_MINOR, chem..":"..cwAlchemy:ConvertUnits(ml));

			end

			if istable(chemical) then

				local reactTable = chemical.reactions or {};

				for reactiontype, data in pairs(reactTable) do

					if (SERVER and cwAlchemy.Debug) then

						Clockwork.kernel:PrintLog(LOGTYPE_MINOR, reactiontype);

					end

					local isReact = true;

					local reactmass = ml;

					local buffer = {};

					local cata = (data.catalysts) or {}

					for cchem, ratio in pairs(cata) do

						if isReact then

							local tcchem = contents[cchem] or 0;

							if tcchem > 0 then

								reactmass = math.min(reactmass,(tcchem/ratio))

								if (SERVER and cwAlchemy.Debug) then

									Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Catalyst: "..cchem..": "..ratio.." ratio");

								end

							else

								isReact = false;

							end

						end

					end

					if isReact then

						local anyaccept = data.anyreact or false;

						local found = false

						for rchem, ratio in pairs(data.reactants) do

							local trchem = contents[rchem] or 0;

							if trchem > 0 then

								reactmass = math.min(reactmass,(trchem/ratio))

								buffer[rchem] = ratio;

								if (SERVER and cwAlchemy.Debug) then

									Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Ingredient: "..rchem..": "..ratio.." ratio");

								end

								found = true

								if anyaccept then

									isReact = true;

								end

							elseif not found then

								isReact = false;

							end

						end

					end

					if (SERVER and cwAlchemy.Debug) then

						Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Reactive Mass: "..reactmass);

					end

					if isReact then

						buffer[chem] = 1;

						totalused = 0

						for mat, volume in pairs(buffer) do

							used = (reactmass * buffer[mat])

							totalused = totalused + used

							contents[mat] =  math.Clamp(contents[mat] - used,0,contents[mat])

							if (SERVER and cwAlchemy.Debug) then

								Clockwork.kernel:PrintLog(LOGTYPE_MINOR, mat..": "..cwAlchemy:ConvertUnits(used).." used");

							end

						end

						if reactiontype == "make" then

							if cwAlchemy:GetLiquid( data.result ) then

								if (SERVER and cwAlchemy.Debug) then

									Clockwork.kernel:PrintLog(LOGTYPE_MINOR, data.result..": "..cwAlchemy:ConvertUnits(used).." created");

								end

								contents[data.result] = contents[data.result] or 0

								contents[data.result] = contents[data.result] + totalused

							end

						end

						local output = { class = reactionType, mats = contents, energy = (data.power)*reactmass }

						if (SERVER and cwAlchemy.Debug) then

							Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Triggered Chemical Reaction:");

							PrintTable(output)

						end

						return output;

					end

				end;

			else

				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "ALCHEMY ERROR: Invalid chemical found!");

			end

		end;

	end;

	

	local output = { class = "none", mats = contents, energy = 0 }

	return output;

end



--Add up all the base stats of a chemical mix.

function cwAlchemy:GetChemStats(contents)

	local total = {

		volume = 0,

		mass = 0

	};

	local buffer = {};

	if table.Count( contents ) > 0 then

		for chem, ml in pairs(contents) do

			local chemical = cwAlchemy:GetLiquid(chem);

			local statTable = chemical.stats or {};

			for k, v in pairs(statTable) do

				buffer[k] = buffer[k] or 0;

				buffer[k] = buffer[k] + (v*ml)

			end;

		end;

	end;

	if (SERVER and cwAlchemy.Debug) then

		PrintTable(buffer)

	end

	return buffer;

end







--Get an ingredient data.

function cwAlchemy:GetLiquid(liquid)

	if cwAlchemy.chemicals[liquid] then

		return cwAlchemy.chemicals[liquid];

	else

		return {}

	end

end



-- A function to get a contenttable's total liquid value.

function cwAlchemy:GetTotalLiquidData(input)

	local total = {

		volume = 0,

		mass = 0

	};

	local contents = input or {}

	if table.Count( contents ) > 0 then

		for k, v in pairs(contents) do

			if !table.IsEmpty( cwAlchemy:GetLiquid(k) ) then

				if isnumber( v ) then

					if (v > 0) then

						local data = cwAlchemy:GetLiquid(k).density or 1;

						total.volume = total.volume + v;

						total.mass = total.mass + (v * (data/1000));

					end;

				else

					v = nil

				end

			else

				v = nil

			end

		end;

	end;

	return total;

end;



-- A function to trigger the effects for when drunk by a player.

function cwAlchemy:DrinkChem(player,buffer)

	if (!player:Alive() or player:IsRagdolled()) then

		return

	end

	contents = buffer.output or {};

	total = buffer.total or {};

	local effects = cwAlchemy:GetChemStats(contents)

	local taste = cwAlchemy:GenerateTaste(contents, total)

	if effects.quench then

		player:HandleNeed("thirst", effects.quench*-1);

	end	

	Clockwork.player:Notify(player, "It tastes "..taste..".");

end;



-- A function to trigger the effects when physically applied to a player.

function cwAlchemy:SplashChem(player,buffer)

	if (!player:Alive() or player:IsRagdolled()) then

		return

	end

	contents = buffer.output or {};

	total = buffer.total or {};

	local effects = cwAlchemy:GetChemStats(contents)

	cwAlchemy:ChemExposure(player, contents, total)

end;



-- Trigger effects and chemical reactions whenever a container is handled. The "shock" value is either the number of liters or how hard the container was affected.

function cwAlchemy:DisturbContainer(player, containerTable, shock)

	local contents = containerTable:GetData("ChemContents") or {};

	local reactions = cwAlchemy:DoReactions(contents)

	cwAlchemy:SetContents(containerTable, reactions.mats)

	if istable(reactions) then

		cwAlchemy:TriggerChemReaction(player, reactions.class, containerTable, reactions.energy, reactions.mats);

	end

	local destable = cwAlchemy:CalcExplosiveStats(reactions.mats, shock)

	if (SERVER and cwAlchemy.Debug) then

		PrintTable(destable)

	end

	if destable.explode then

		cwAlchemy:TriggerChemReaction(player, "explode", containerTable, destable.boompower, reactions.mats);

	end

	return destable.explode;

end



function cwAlchemy:InvFire(entity, item, chemicals, overridefire)

	local contents = chemicals or {}

	local obj = item or {}

	local override = overridefire or false;

	contents["regfire"] = contents["regfire"] or 0;

	local total = 0;

	local capacity = 2;

	local blastenergy = 0;

	local kaboom = false;

	if not table.IsEmpty(obj) then

		if contents["regfire"] > 0 then

			capacity = obj.capacity

			

			for k, v in pairs (contents) do

				local chem = cwAlchemy:GetLiquid(k)

				if not table.IsEmpty(chem) then

					total = total + v

					local flamm = chem.flammable or 0

					local expl = chem.explosive or 0

					if flamm ~= 0 then

						if override then

							local burn = v*flamm;

							v = 0;

							contents["regfire"] = math.max(contents["regfire"] + burn,0);

						else

							local burn = contents["regfire"]*flamm;

							v = math.Clamp(v-contents["regfire"],0,v);

							contents["regfire"] = math.max(contents["regfire"] + burn,0);

						end

						if expl ~= 0 then

							if contents["regfire"] > 0 then

								blastenergy = blastenergy + (expl * v);

								v = 0;

							end

						end

					end;

				end;

			end;

		end;

	end;

	local fireoverflow = math.max(total-capacity,0);

	cwAlchemy:SetContents(item, chemicals)

	

	if (fireoverflow > 0) or (blastenergy > 0) then

		local blastpower = blastenergy + fireoverflow;

		cwAlchemy:TriggerChemReaction(entity, "explode", item, blastpower, chemicals);

	end

end;



function cwAlchemy:ProcessFire(player, chemicals, ignitepower)

	flames = chemicals["regfire"] or 0;

	firewas = flames;

	if flames > 0 then

		alter = ignitepower or 0

		if ((flames == 0) and ((player:IsOnFire()) and (alter == 0))) then

			flames = 3

		elseif flames > 0 then

			flames = math.Clamp(flames - 50,0,10000)

		end

		flames = math.Clamp(flames + alter,0,10000);

		if flames > 0 then

			if firewas == 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "screams as a fire engulfs their body!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

			end

			player:Ignite( 2, flames )

		else

			if firewas > 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "exhales with relief as the fire goes out.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

			end

			player:Extinguish()

		end

	end

	chemicals["regfire"] = flames;

	return chemicals["regfire"];

end;



-- Expose a player to chemicals.

function cwAlchemy:ChemExposure(player, chemicals, amount, notSilent)

	local amount = amount or 0;

	local chemicals = chemicals or {};

	local notSilent = notSilent or false;

	local plycontents = player:GetCharacterData("cwAlchemyExposure") or {};

	local data = cwAlchemy:GetTotalLiquidData(plycontents)

	plycontents = cwAlchemy:AddToContents(plycontents, chemicals, amount, {})

	local reactions = cwAlchemy:DoReactions(plycontents.output)

	player:SetCharacterData("cwAlchemyExposure",reactions.mats)

	if istable(reactions) then

		cwAlchemy:TriggerChemReaction(player, reactions.class, player, reactions.energy, chemicals);

	end

	

end



-- A function to transfer the contents of one container to another, triggering any chemical reactions along the way.

function cwAlchemy:Transfer(player,uniqueid1,itemid1,uniqueid2,itemid2)

	if (!player:Alive() or player:IsRagdolled()) then

		return

	end

	

	-- get and properly define the specific item instances

	local containerfrom = player:FindItemByID(uniqueid1, itemid1);

	local containerto = player:FindItemByID(uniqueid2, itemid2);



	if (containerfrom and containerto) then

		-- get the chemical contents and various bits of data about them and their containers

		local contents = containerfrom:GetData("ChemContents")

		local targetcontents = containerto:GetData("ChemContents")

		local data = cwAlchemy:GetTotalLiquidData(contents)

		local targetdata = cwAlchemy:GetTotalLiquidData(targetcontents)

		local capacity = containerfrom.capacity;

		local targetcapacity = containerto.capacity;

		local name = containerfrom.name or "container"

		local targetname = containerto.name or "other container"

		local transleft = (targetcapacity-targetdata.volume)

		

		-- figure out how much liquid we can transfer

		local amounttopour = math.Clamp(data.volume,0,transleft);

		-- remove a proportional amount of each liquid and output it to this variable

		local transfer = cwAlchemy:SubtractFromContents(contents, amounttopour, containerfrom);

		local buffer = cwAlchemy:AddToContents(targetcontents, transfer.output, transfer.total, containerto);

		

		if transleft > 0 then

			if amounttopour > 0 then

				local danger = cwAlchemy:CalcExplosiveStats(buffer.output, 0)

				if danger.unstable > 0 then

					Clockwork.chatBox:AddInTargetRadius(player, "me", "very carefully starts transferring the contents of their "..string.utf8lower(name).." to a "..string.lower(targetname).."...", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				else

					Clockwork.chatBox:AddInTargetRadius(player, "me", "starts transferring the contents of their "..string.utf8lower(name).." to a "..string.utf8lower(targetname).."...", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				end

				Clockwork.player:Notify(player, "Transferring "..cwAlchemy:ConvertUnits(amounttopour).."...");

				Clockwork.player:SetAction(player, "transferring_contents_container", transfer.total/200, 5, function()

					if cwAlchemy:DisturbContainer(player, containerto, buffer.total/1000) then

						Clockwork.player:Notify(player, "Your container explodes!");

					else

						-- add the amount removed from the first container to the second

						cwAlchemy:SetContents(containerfrom, transfer.remaining)

						cwAlchemy:SetContents(containerto, buffer.output)

						local transferred = cwAlchemy:ConvertUnits(buffer.total)

						Clockwork.player:Notify(player, "Transferred "..transferred..".");

						Clockwork.chatBox:AddInTargetRadius(player, "me", "finishes transferring contents to their "..string.utf8lower(targetname)..".", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

						--the container has been handled, trigger DisturbContainer with the shock argument being the number of liters transferred

					end

				end);

			else

				Clockwork.player:Notify(player, "The container is empty.");

			end

		else

			Clockwork.player:Notify(player, "This container is full.");

		end

	end

end;



-- A function to transfer the contents of a dissolvable item to a container.

function cwAlchemy:Dissolve(player,uniqueid1,itemid1,uniqueid2,itemid2)

	if (!player:Alive() or player:IsRagdolled()) then

		return

	end

	

	-- get and properly define the specific item instances

	local dissolve = player:FindItemByID(uniqueid1, itemid1);

	local containerto = player:FindItemByID(uniqueid2, itemid2);



	if (dissolve and containerto) then

		-- get the chemical contents and various bits of data about them and their containers

		local contents = dissolve:GetData("ChemContents")

		local targetcontents = containerto:GetData("ChemContents")

		local data = cwAlchemy:GetTotalLiquidData(contents)

		local targetdata = cwAlchemy:GetTotalLiquidData(targetcontents)

		local capacity = dissolve.capacity;

		local targetcapacity = containerto.capacity;

		local name = dissolve.name or "container"

		local targetname = containerto.name or "other container"

		local transleft = (targetcapacity-targetdata.volume)

		

		-- figure out how much liquid we can transfer

		local amounttopour = math.Clamp(data.volume,0,(targetcapacity-targetdata.volume));



		-- remove a proportional amount of each liquid and output it to this variable

		local transfer = cwAlchemy:SubtractFromContents(contents, amounttopour, dissolve);

		local buffer = cwAlchemy:AddToContents(targetcontents, transfer.output, transfer.total, containerto);

		if transleft > 0 then

			Clockwork.player:Notify(player, "Dissolving "..cwAlchemy:ConvertUnits(amounttopour).."...");

			local danger = cwAlchemy:CalcExplosiveStats(buffer.output, 0)

			if danger.unstable > 0 then

				Clockwork.chatBox:AddInTargetRadius(player, "me", "very carefully puts a "..string.utf8lower(name).." in their "..string.utf8lower(targetname).." and watches it dissolve...", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

			else

				Clockwork.chatBox:AddInTargetRadius(player, "me", "puts a "..string.utf8lower(name).." in their "..string.utf8lower(targetname).." and watches it dissolve...", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

			end

			Clockwork.player:SetAction(player, "transferring_contents_container", transfer.total/200, 5, function()

				-- add the amount removed from the first container to the second

				player:TakeItem(dissolve)

				cwAlchemy:SetContents(containerto, buffer.output)

				local transferred = cwAlchemy:ConvertUnits(buffer.total)

				Clockwork.player:Notify(player, "Dissolved a "..transferred..".");

				Clockwork.chatBox:AddInTargetRadius(player, "me", "finishes dissolving a "..string.utf8lower(name)..".", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

				--the container has been handled, trigger DisturbContainer with the shock argument being the number of liters transferred

				cwAlchemy:DisturbContainer(player, containerto, buffer.total/1000)

			end);

		else

			Clockwork.player:Notify(player, "This container is full.");

		end

	end

end;



--Check to see if an argument is an item table.

function cwAlchemy:IsItemTable(arg)

	if istable(arg) then

		if arg.uniqueID then

			return true;

		end

	end

	return false;

end





-- Set the a container or player's contents.

function cwAlchemy:SetContents(arg, input)

	local input = input or {};

	local isPlayer = false;

	if istable(input) then

		if IsEntity(arg) then

			if ent:IsPlayer() then

				arg:SetCharacterData("cwAlchemyExposure",input)

			end

		elseif (istable(arg.chemcontents)) then

			arg:SetData("ChemContents", input);

			arg:ModifyContainerWeight();

		end

	end

end;



-- Add the contents of a content table to another one.

function cwAlchemy:AddToContents(table1, table2, amount, item)

	local contents = table1;

	local input = table2;

	

	local amount = amount or 0;

	local item = item or {};

	local data = cwAlchemy:GetTotalLiquidData(contents)

	local capacity = item.capacity or 1.5;

	local capleft = capacity - data.volume;

	local amountmulti = 1

	

	if (amount >= capleft) then

		amountmulti = capleft/amount;

		amount = capleft

	end;

	

	local added = 0

	

	for k, v in pairs (input) do

		contents[k] = contents[k] or 0;

		contents[k] = contents[k] + (input[k]*amountmulti);

		added = added + input[k]

	end;

	

	return {total=added,output=contents};

end;



-- A subtract a set volume the mix from the container. Returns what was successfully subtracted as a table.

function cwAlchemy:SubtractFromContents(conts, amount, item)

	local contents = conts

	amount = tonumber(amount) or 0;

	local bufferout = {}

	local data = cwAlchemy:GetTotalLiquidData(contents)

	local capacity = item.capacity or 1.5;

	local amountmulti = amount/data.volume;

	local emptyout = false

	

	if (data.volume <= amount) then

		emptyout = true

		amount = data.volume

	end

	

	for k, v in pairs (contents) do

		if emptyout then

			bufferout[k] = math.Round(contents[k]);

			contents[k] = 0;

		else

			bufferout[k] = math.Round(contents[k] * amountmulti)

			contents[k] = math.Clamp(contents[k] - bufferout[k], 0, capacity)

		end

		if (SERVER and cwAlchemy.Debug) then

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Subtracting "..cwAlchemy:ConvertUnits(bufferout[k]));

		end

	end;

	

	return {total=amount,output=bufferout,remaining=contents};

end;



-- A subtract a set volume the mix from the container. Returns what was successfully subtracted as a table.

function cwAlchemy:ErodeContents(player, conts, amount, solventpower)

	local contents = conts

	amount = tonumber(amount) or 0;

	local bufferout = {}

	local data = cwAlchemy:GetTotalLiquidData(contents)

	local amountmulti = amount/data.volume;

	local emptyout = false

	local selfsolvent = cwAlchemy:GetSolventRating(contents) or {};

	local stickpower = selfsolvent.sticky or 0;

	stickpower = stickpower - solventpower;

	

	if (data.volume <= amount) then

		amount = data.volume

	end

	

	for k, v in pairs (contents) do

		chemdata = cwAlchemy:GetLiquid(k) or {}

		

		if not table.IsEmpty(chemdata) then

			bufferout[k] = math.Clamp(math.Round(contents[k] * amountmulti)-stickpower, 0, v) 

			v = math.max(v - bufferout[k], 0)

			if (SERVER and cwAlchemy.Debug) then

				Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Eroding "..cwAlchemy:ConvertUnits(bufferout[k]).." of "..chemdata.name..".");

			end

			--end

		else

			contents[k] = nil;

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Invalid chem found in "..player:Name().."'s inventory: "..tostring(k)..". Removing.");

		end

	end;

	

	return {total=amount,output=bufferout,remaining=contents};

end;



function cwAlchemy:IgniteItemContents(owner, item)

	for k, v in pairs (contents) do

		if emptyout then

			bufferout[k] = math.Round(contents[k]);

			contents[k] = 0;

		else

			bufferout[k] = math.Round(contents[k] * amountmulti)

			contents[k] = math.Clamp(contents[k] - bufferout[k], 0, capacity)

		end

		if (SERVER and cwAlchemy.Debug) then

			Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Subtracting "..cwAlchemy:ConvertUnits(bufferout[k]));

		end

	end;

end



function cwAlchemy:TriggerChemReaction(target, class, item, power, contents, flashignite)

	local destroyitem = false;

	local message = "fizzles";

	local name;

	local isPlayer;

	local effectdata = EffectData()

	local damagetype = DMG_GENERIC

	local effecttype = ""

	local targetpos = target:GetPos();

	local contents = contents or {};

	effectdata:SetOrigin( targetpos )

	if class == "none" then

		return false

	end

	if IsEntity(item) then

		if item:IsPlayer() then

			isPlayer = true

			name = "clothing"

		else

			name = item:GetName()

		end

	else

		name = item.name or "container"

	end

	if class == "explode" then

		if power < 1 then

			message = "bubbles and hisses";

		elseif power < 10 then

			message = "explodes violently";

			destroyitem = true

		elseif power < 100 then

			message = "goes up in a huge blast";

			destroyitem = true

		else

			message = "detonates in a massive explosion";

			destroyitem = true

		end

		effecttype = "Explosion"

		damagetype = DMG_BLAST

	elseif class == "explodefire" then

		if power < 1 then

			message = "bubbles and hisses";

		elseif power < 10 then

			message = "explodes violently";

			destroyitem = true

		elseif power < 100 then

			message = "goes up in a huge fireball";

			destroyitem = true

		end

		effecttype = "Explosion"

		damagetype = DMG_BURN

	elseif class == "flashignite" then

		if power < 1 then

			message = "bubbles and hisses";

		elseif power < 10 then

			message = "detonates in a blinding, burning light";

			destroyitem = true

		elseif power < 100 then

			message = "is vaporized in a blinding blast of cleansing fire";

			destroyitem = true

		end

		effecttype = "HelicopterMegaBomb"

		damagetype = DMG_BURN

	elseif class == "chemgas" then

		if power < 1 then

			message = "bubbles, releasing a whiff of noxious fumes";

		elseif power < 10 then

			message = "bubbles violently, releasing a wave of chemical gas";

		elseif power < 100 then

			message = "goes up in a huge plume of poisonous gas";

		end

		game.AddParticles( "particles/gmod_effects.pcf" )

		PrecacheParticleSystem( "generic_smoke" )

		ParticleEffectAttach( "generic_smoke", 1, target, 1 )

	end

	if destroyitem then

		effectdata:SetDamageType( damagetype )

		effectdata:SetRadius( power )

		effectdata:SetMagnitude( power )

		util.Effect( effecttype, effectdata )

		util.BlastDamage( target, target, targetpos, power, power )

		if target:IsPlayer() then

			target:TakeItem(item, true)

		else

			target:Remove()

		end

		--Handle AoE splashing of chems on players.

		local splash = cwAlchemy:GetTotalLiquidData(contents);

		local left = data.volume;

		local maxperc = 0.3;

		for ind, ply in pairs(ents.FindInSphere( targetpos, power )) do

			if !ply.cwObserverMode then

				if class == "flashignite" then

					ply:Ignite()

				end

				if ply:IsPlayer() then

					local tr = util.TraceLine( {

						start = targetpos,

						endpos = ply:GetPos(),

						filter =  {}

					} )

					if !tr.HitWorld then

						impact = (power - target:Distance( ply ))/power

						percto = maxperc*impact

						local transfer = cwAlchemy:SubtractFromContents(contents, left*percto, item);

						left = transfer.remaining;

						cwAlchemy:ChemExposure(player, transfer.output, transfer.total);

					end

				end

			end

		end

	end

	

	if target:IsPlayer() then

		Clockwork.chatBox:AddInTargetRadius(target, "me", "'s "..name.." "..message.."!", target:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

	end	

end



function cwAlchemy:CreateBarTable(container)

	local barTable = {};

	local contents = container:GetData("ChemContents") or {};

	local data = cwAlchemy:GetTotalLiquidData(contents);

	local total = 0

	local destable = cwAlchemy:CalcExplosiveStats(contents, 0)

	local booming = destable.boompower or 0;

	local unstable = destable.unstable or 0;

	if unstable > 0 then

		barTable[#barTable + 1] = {text = "Warning", percentage = 0, color = Color(255,0,0), font = "Default", showPercentage = false, description = "DANGER: UNSTABLE! ("..math.Round(unstable,2).."%)"};

	end

	if booming > 0 then

		barTable[#barTable + 1] = {text = "Warning", percentage = 0, color = Color(255,120,0), font = "Default", showPercentage = false, description = "CAUTION: EXPLOSIVE ( STRENGTH: "..math.Round(booming,2).." )"};

	end

	barTable[#barTable + 1] = {text = "Capacity", percentage = 0, color = Color(255,255,255), font = "Default", showPercentage = false, description = "Total Capacity: "..cwAlchemy:ConvertUnits(container.capacity)};

	if table.Count(contents) > 0 then

		for k, v in pairs (contents) do

			if (v > 0) then

				chemdata = cwAlchemy:GetLiquid(chem) or {}

				if not table.IsEmpty(chemdata) then

					colors = chemdata.color or Color(255,255,255)

					desc = chemdata.desc or "UNKNOWN"

					perc = ((v / data.volume) * 100)

					barTable[#barTable + 1] = {text = k, percentage = ((v / container.capacity) * 100), color = colors, font = "Default", showPercentage = false, description = chemdata.name.." - "..desc};

					barTable[#barTable + 1] = {text = "    ", percentage = 0, color = colors, font = "Default", showPercentage = false, description = cwAlchemy:ConvertUnits(v).." - "..math.Round(perc,1).."% of mix"};

				end

			end;

		end;

	end;

	local left = (container.capacity - data.volume);

	if left > 0 then

		barTable[#barTable + 1] = {text = "EMPTY", percentage = ((left / container.capacity) * 100), color = Color(180,180,180), font = "Default", showPercentage = false, description = "Empty Space - "..cwAlchemy:ConvertUnits(left)};

	end

	return barTable;

end



function cwAlchemy:ConvertUnits(amount)

	output = ""

	if amount > 1000 then

		local liters = math.Round(amount/1000,2)

		unit = "Liter"

		if liters > 1 then

			unit = "Liters"

		end

		output = tostring(liters).." "..unit

	else

		output = tostring(amount).." mL"

	end

	return output;

end



netstream.Hook("MergeAlchemyContainers", function(player, data)

    if data and data[1] and data[2] and data[3] and data[4] then

        local fromUniqueID = data[1]

        local fromItemID = data[2]

        local toUniqueID = data[3]

        local toItemID = data[4]

		cwAlchemy:Transfer(player,fromUniqueID,fromItemID,toUniqueID,toItemID)

    end

end)



netstream.Hook("DissolveObject", function(player, data)

    if data and data[1] and data[2] and data[3] and data[4] then

        local fromUniqueID = data[1]

        local fromItemID = data[2]

        local toUniqueID = data[3]

        local toItemID = data[4]

		cwAlchemy:Transfer(player,fromUniqueID,fromItemID,toUniqueID,toItemID)

    end

end)