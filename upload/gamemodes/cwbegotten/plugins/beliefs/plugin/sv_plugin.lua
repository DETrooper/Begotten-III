--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

cwBeliefs.xpValues = {
	["copy"] = 200, -- 200 xp per book copied by those with the 'Scribe' belief.
	["damage"] = 0.1, -- 0.1 xp per point of damage dealt (10 xp for 100 hp of damage).
	["drink"] = 3, -- 3 xp per drink consumed.
	["food"] = 5, -- 5 xp per food consumed.
	["kill"] = 10, -- 10 xp per killing blow (per level).
	["mutilate"] = 2, -- 2 xp per mutiliation of a corpse. Also includes other stuff like eating hearts or harvesting bones.
	["residual"] = 1, -- 1 xp per minute survived in non-safezones.
	["read"] = 50, -- 50 xp for every unique scripture read.
};

cwBeliefs.beliefTable = {
	["prowess"] = {
		["fighter"] = {},
		["halfsword_sway"] = {"fighter"},
		["blademaster"] = {"fighter", "halfsword_sway"},
		["billman"] = {"fighter", "halfsword_sway", "blademaster"},
		["parrying"] = {"fighter"},
		["repulsive_riposte"] = {"fighter", "parrying"},
		["wrestle_subdue"] = {"fighter"},
		["warrior"] = {"fighter", "wrestle_subdue"},
		["master_at_arms"] = {"fighter", "wrestle_subdue", "warrior"},
		["deflection"] = {"fighter"},
		["sidestep"] = {"fighter", "deflection"},
		["strength"] = {"fighter"},
		["might"] = {"fighter", "strength"},
		["unrelenting"] = {"fighter", "strength", "might"},
	},
	["fortitude"] = {
		["asceticism"] = {},
		["outlasting"] = {"asceticism"},
		["prudence"] = {},
		["saintly_composure"] = {"prudence"},
		["lunar_repudiation"] = {"prudence", "saintly_composure"},
		["defender"] = {},
		["warden"] = {"defender"},
		["hauberk"] = {"defender", "warden"},
		["unburdened"] = {"defender", "warden", "hauberk"},
		["believers_perseverance"] = {},
		["plenty_to_spill"] = {"believers_perseverance"},
		["unyielding"] = {"believers_perseverance", "plenty_to_spill"},
		["hide_of_steel"] = {},
		["iron_bones"] = {"hide_of_steel"},
	},
	["brutality"] = {
		["savage"] = {},
		["savage_animal"] = {"savage", "primeval", "headtaker", "heart_eater", "bestial"},
		["primeval"] = {"savage"},
		["headtaker"] = {"savage", "primeval"},
		["heart_eater"] = {"savage"},
		["bestial"] =  {"savage", "heart_eater"},
	},
	["fortune"] = {
		["fortunate"] = {},
		["lucky"] = {"fortunate"},
		["favored"] = {"fortunate", "lucky"},
		["talented"] = {},
		["gifted"] = {"talented"},
		["jack_of_all_trades"] =  {"talented", "gifted"},
	},
	["litheness"] = {
		["nimble"] = {},
		["sly_fidget"] = {"nimble"},
		["safecracker"] = {"nimble", "sly_fidget"},
		["thief"] = {"nimble", "sly_fidget", "safecracker"},
		["dexterity"] = {"nimble"},
		["swift"] = {"nimble", "dexterity"},
		["evasion"] = {"nimble", "dexterity", "swift"},
	},
	["ingenuity"] = {
		["ingenious"] = {},
		["cookist"] = {"ingenious"},
		["culinarian"] = {"ingenious", "cookist"},
		["powder_and_steel"] = {"ingenious"},
		["pistolier"] = {"ingenious", "powder_and_steel"},
		["marksman"] = {"ingenious", "powder_and_steel", "pistolier"},
		["craftsman"] = {"ingenious"},
		["mechanic"] = {"ingenious", "craftsman"},
		["artisan"] = {"ingenious", "craftsman", "mechanic"},
		["smith"] = {"ingenious"},
		["blacksmith"] = {"ingenious", "smith"},
		["master_blacksmith"] = {"ingenious", "smith", "blacksmith"},
		["scour_the_rust"] = {"ingenious"},
		["fortify_the_plate"] = {"ingenious", "scour_the_rust"},
	},
	["aptitude"] = {
		["literacy"] = {},
		--[[["blood_nectar"] = {"literacy", "alchemist", "precise_measurements"},
		["scientist"] = {"literacy", "alchemist", "chemist"},
		["alchemist"] = {"literacy"},
		["chemist"] = {"literacy", "alchemist"},
		["precise_measurements"] = {"literacy", "alchemist"},]]--
		["scribe"] = {"literacy"},
		["anthropologist"] = {"literacy", "scribe"},
		["loremaster"] = {"literacy", "scribe", "anthropologist"},
		["sanitary"] = {"literacy"},
		["medicine_man"] = {"literacy", "sanitary"},
		["surgeon"] = {"literacy", "sanitary", "doctor"},
		["doctor"] = {"literacy", "sanitary"},
		["plague_doctor"] = {"literacy", "sanitary", "medicine_man"},
	},
	["religion"] = {
		["sol_orthodoxy"] = {},
		["repentant"] = {"sol_orthodoxy"},
		["flagellant"] = {"sol_orthodoxy", "repentant"},
		["extinctionist"] = {"sol_orthodoxy", "repentant", "flagellant"},
		["prison_of_flesh"] = {"sol_orthodoxy"},
		["purity_afloat"] = {"sol_orthodoxy", "prison_of_flesh"},
		["fanaticism"] = {"sol_orthodoxy", "prison_of_flesh", "purity_afloat"},
		["hard_glazed"] = {},
		["disciple"] = {"hard_glazed"},
		["acolyte"] = {"hard_glazed", "disciple"},
		["emissary"] = {"hard_glazed", "disciple", "acolyte"},
		["the_light"] = {"hard_glazed"},
		["blessed_powder"] = {"hard_glazed", "the_light"},
		["manifesto"] = {"hard_glazed", "the_light", "blessed_powder"},
		["voltism"] = {},
		["wire_therapy"] = {"voltism"},
		["jacobs_ladder"] = {"voltism", "wire_therapy"},
		["the_paradox_riddle_equation"] = {"voltism", "wire_therapy", "jacobs_ladder"},
		["wriggle_fucking_eel"] = {"voltism"},
		["yellow_and_black"] = {"voltism", "wriggle_fucking_eel"},
		["the_storm"] =	{"voltism", "wriggle_fucking_eel", "yellow_and_black"},
		["primevalism"] = {},
		["embrace_the_darkness"] = {"primevalism", "creature_of_the_dark", "soothsayer"},
		["creature_of_the_dark"] = {"primevalism"},
		["soothsayer"] = {"primevalism", "creature_of_the_dark"},
		["survivalist"] = {"primevalism", "creature_of_the_dark", "soothsayer"},
		["thirst_blood_moon"] = {"primevalism", "creature_of_the_dark", "soothsayer"},
		["satanism"] = {},
		["flamboyance"] = {"satanism", "murder_artform"},
		["unending_dance"] = {"satanism", "murder_artform", "flamboyance"},
		["murder_artform"] = {"satanism"},
		["impossibly_skilled"] = {"satanism", "murder_artform", "flamboyance", "blademaster"},
		["witch"] = {"satanism"},
		["heretic"] = {"satanism", "witch"},
		["sorcerer"] = {"satanism", "witch", "heretic"},
		["blank_stare"] = {"satanism"},
		["assassin"] = {"satanism", "blank_stare", "encore", "swift"},
		["encore"] = {"satanism", "blank_stare"},
		["sadism"] = {"satanism", "blank_stare", "encore"},
		["father"] = {},
		["honor_the_gods"] = {"father"},
		["man_become_beast"] =	{"father", "honor_the_gods"},
		["fearsome_wolf"] = {"father", "honor_the_gods", "man_become_beast"},
		["mother"] = {},
		["one_with_the_druids"] = {"mother"},
		["gift_great_tree"] =	{"mother", "one_with_the_druids"},
		["watchful_raven"] = {"mother", "one_with_the_druids", "gift_great_tree"},
		["old_son"] = {},
		["the_black_sea"] = {"old_son"},
		["taste_of_blood"] =	{"old_son", "the_black_sea"},
		["daring_trout"] = {"old_son", "the_black_sea", "taste_of_blood"},
		["sister"] = {},
		["witch_druid"] = {"sister"},
		["shedskin"] =	{"sister", "witch_druid"},
		["deceitful_snake"] = {"sister", "witch_druid", "shedskin"},
		["young_son"] = {},
		["taste_of_iron"] = {"young_son"},
		["shieldwall"] =	{"young_son", "taste_of_iron"},
		["enduring_bear"] = {"young_son", "taste_of_iron", "shieldwall"},
	},
};

cwBeliefs.beliefsToSubfaiths = {
	["father"] = "Faith of the Father",
	["hard_glazed"] = "Hard-Glazed",
	["mother"] = "Faith of the Mother",
	["old_son"] = "Faith of the Old Son",
	["primevalism"] = "Primevalism",
	["satanism"] = "Satanism",
	["sister"] = "Faith of the Sister",
	["sol_orthodoxy"] = "Sol Orthodoxy",
	["voltism"] = "Voltism",
	["young_son"] = "Faith of the Young Son",
};

cwBeliefs.traitLocks = {
	["aptitude"] = {"blind"},
	["brutality"] = {"pacifist"},
	["prowess"] = {"weak"},
	["fortune"] = {"marked"},
};

cwBeliefs.beliefNotifications = {
	["embrace_the_darkness"] = "You can now right click with Senses equipped in order to toggle invisibility while outside in the Wasteland at night, though you must remain crouched with your Senses equipped.",
	["evasion"] = "You can now roll by double-tapping your movement keys (toggled in the Clockwork Settings menu), or by binding a key to 'begotten_roll' and pressing it while moving. Rolling grants invincibility frames and can also put out fires.",
	["father"] = "You can now pray to the Gods by typing '/pray' in the chatbox. You can also now warcry by typing '/warcry' in chat, which will temporarily disorient and lower the sanity of nearby enemy players.",
	["flagellant"] = "You can now scourge your own flesh by typing '/flagellate' in the chatbox.",
	["halfsword_sway"] = "You can now change stances with certain weapons by using E + Right Click!",
	["hard_glazed"] = "You can now pray to the Gods by typing '/pray' in the chatbox.",
	["mother"] = "You can now pray to the Gods by typing '/pray' in the chatbox.",
	["old_son"] = "You can now pray to the Gods by typing '/pray' in the chatbox. You can also now warcry by typing '/warcry' in chat, which will temporarily disorient and lower the sanity of nearby enemy players.",
	["parrying"] = "You can now parry with melee weapons by using your reload key!",
	["primevalism"] = "You can now pray to the Gods by typing '/pray' in the chatbox.",
	["satanism"] = "You can now pray to the Gods by typing '/pray' in the chatbox.",
	["sister"] = "You can now pray to the Gods by typing '/pray' in the chatbox.",
	["sol_orthodoxy"] = "You can now pray to the Gods by typing '/pray' in the chatbox. You can also now end your miserable fucking existence by typing '/suicide'.",
	["voltism"] = "You can now pray to the Gods by typing '/pray' in the chatbox. You can also now electrocute yourself by typing '/electrocute'.",
	--["deflection"] = "You can now deflect when blocking with melee weapons by performing timed blocks!",
	["wrestle_subdue"] = "You can now hold down enemies who have been knocked over by switching to your Hands and using Right Click!",
	["young_son"] = "You can now pray to the Gods by typing '/pray' in the chatbox. You can also now warcry by typing '/warcry' in chat, which will temporarily disorient and lower the sanity of nearby enemy players.",
};

cwBeliefs.residualXPZones = {"wasteland", "caves", "gore", "sea_styx", "sea_rough", "sea_calm", "toothboy", "scrapper"};

-- Add finishers to the beliefs table.
for k, v in pairs (cwBeliefs.beliefTable) do
	if (cwBeliefs.beliefTable[k][k.."_finisher"]) then
		continue;
	end;
	
	local categoryBeliefs = {};
	
	for k2, v2 in pairs (cwBeliefs.beliefTable[k]) do
		categoryBeliefs[#categoryBeliefs + 1] = k2;
	end;
	
	cwBeliefs.beliefTable[k][k.."_finisher"] = categoryBeliefs;
end;

-- A function to level a player up (remade by DETrooper).
function cwBeliefs:LevelUp(player)
	if IsValid(player) then
		local experience = player:GetCharacterData("experience", 0);
		local newExperience = experience;
		local level = player:GetCharacterData("level", 1);
		local levelCap = self.sacramentLevelCap;
		local newLevel = level;
		local points = player:GetCharacterData("points", 0);
		local subfaction = player:GetSubfaction();
		
		if player:HasBelief("loremaster") then
			levelCap = levelCap + 10;
		end
		
		if player:HasBelief("sorcerer") then
			levelCap = levelCap + 5;
		end
		
		if subfaction == "Rekh-khet-sa" then
			levelCap = levelCap + 666;
		end
		
		if level < levelCap then
			for i = level, levelCap - 1 do
				if (newExperience >= (self.sacramentCosts[newLevel + 1] or 666)) then
					newExperience = newExperience - (self.sacramentCosts[newLevel + 1] or 666);
					newLevel = newLevel + 1;
					points = points + 1;
					
					if newLevel == levelCap then
						points = points + 1;
					end
				else
					break;
				end
			end
				
			player:SetCharacterData("experience", newExperience);
			player:SetCharacterData("points", points);
			player:SetCharacterData("level", newLevel);
			player:SetSharedVar("level", newLevel);
			Clockwork.plugin:Call("PlayerLevelUp", player, newLevel, points);
		end
	end
end

-- A function to get if a belief actually exists.
function cwBeliefs:BeliefIsValid(uniqueID)
	for k, v in pairs(self.beliefTable) do
		if v[uniqueID] or uniqueID == k.."_finisher" then
			return true
		end
	end
	
	return false;
end

-- A function to get if a player has the requirements for a belief or not.
function cwBeliefs:ResolveBelief(player, uniqueID, category, beliefs)
	if (!uniqueID or !category or !beliefs) then
		return;
	end;
	
	if (beliefs[uniqueID]) then
		return false;
	end;
	
	local category = self.beliefTable[category] or {};
	local subfaith = player:GetSubfaith();
	
	if self.traitLocks[category] then
		for i = 1, #self.traitLocks[category] do
			if player:HasTrait(self.traitLocks[category][i]) then
				return false
			end
		end
	end
	
	if self.beliefsToSubfaiths[uniqueID] and subfaith and subfaith ~= "N/A" then
		return false;
	end
	
	if category == "prowess" and player:HasBelief("loremaster") then
		return false;
	end
	
	if player:HasBelief("jack_of_all_trades") and table.HasValue(self.tier4Beliefs, uniqueID) then
		return false;
	end
	
	local requirements = category[uniqueID]; 

	for k, v in pairs (requirements) do
		if (!beliefs[v]) then
			return false
		end;
	end;
	
	return true;
end;

-- A function to give a new belief to a player.
function cwBeliefs:TakeBelief(player, uniqueID, niceName, category)
	if (!player:GetCharacterData("beliefs")) then
		player:SetCharacterData("beliefs", {});
	end;
	
	local points = player:GetCharacterData("points", 0)
	local finisher = tobool(string.find(uniqueID, "finisher"));
	
	if (points <= 0 and !finisher) then
		Schema:EasyText(player, "chocolate", "You do not have enough faith to follow this belief!")
		return false
	end;
	
	local beliefs = player:GetCharacterData("beliefs");
	local takeBelief = Clockwork.plugin:Call("ResolveBelief", player, uniqueID, category, beliefs);
	
	if (takeBelief and !beliefs[uniqueID]) then
		beliefs[uniqueID] = true
		player:SetCharacterData("beliefs", beliefs)
		
		if (!finisher) then
			player:SetCharacterData("points", math.Clamp(points - 1, 0, 100))
			player:Notify("You have taken the \""..niceName.."\" belief.")
			player:SendLua([[Clockwork.Client:EmitSound("ambient/fire/ignite.wav", 40)]]);
		end;
		
		hook.Run("BeliefTaken", player, uniqueID, category);
	else
		if (!beliefs[uniqueID]) then
			for k, v in pairs (_player.GetAll()) do
				if (v:IsAdmin()) then
					v:Notify(player:Name().." has attempted to send a phony TakeBelief datastream! UniqueID: "..uniqueID.." / Category: "..category..".");
				end;
			end;
		end;
	end;
end;

function cwBeliefs:ForceTakeBelief(player, uniqueID)
	local beliefs = player:GetCharacterData("beliefs");
	
	if !beliefs[uniqueID] then
		local category;

		for k, v in pairs(self.beliefTable) do
			for k2, v2 in pairs(v) do
				if k2 == uniqueID then
					category = k;
					break;
				end
			end
		end
		
		beliefs[uniqueID] = true
		player:SetCharacterData("beliefs", beliefs);
		
		hook.Run("BeliefTaken", player, uniqueID, category);
	end
end

function cwBeliefs:ForceRemoveBelief(player, uniqueID, bRemoveDependencies)
	local beliefs = player:GetCharacterData("beliefs");
	local levels_to_remove = 1;
	
	if beliefs[uniqueID] then
		local category;

		for k, v in pairs(self.beliefTable) do
			for k2, v2 in pairs(v) do
				if k2 == uniqueID then
					category = k;
					break;
				end
			end
		end
		
		if self.beliefsToSubfaiths[uniqueID] then
			--player:SetCharacterData("subfaith", nil);
			player:SetSharedVar("subfaith", nil);
			player:GetCharacter().subfaith = nil;
		end
		
		beliefs[uniqueID] = false;
		
		if bRemoveDependencies and category then
			local requirements = self.beliefTable[category]; 

			for k, v in pairs (requirements) do
				if (table.HasValue(v, uniqueID)) then
					if self.beliefsToSubfaiths[k] then
						--player:SetCharacterData("subfaith", nil);
						player:SetSharedVar("subfaith", nil);
						player:GetCharacter().subfaith = nil;
					end
				
					beliefs[k] = false;
					levels_to_remove = levels_to_remove + 1;
				end;
			end;
		end
		
		local max_poise = player:GetMaxPoise();
		local poise = player:GetNWInt("meleeStamina");
		local max_stamina = player:GetMaxStamina();
		local max_stability = player:GetMaxStability();
		local stamina = player:GetNWInt("Stamina", 100);
		
		player:SetMaxHealth(player:GetMaxHealth());
		player:SetLocalVar("maxStability", max_stability);
		player:SetLocalVar("maxMeleeStamina", max_poise);
		player:SetNWInt("meleeStamina", math.min(poise, max_poise));
		player:SetLocalVar("Max_Stamina", max_stamina);
		player:SetCharacterData("Max_Stamina", max_stamina);
		player:SetNWInt("Stamina", math.min(stamina, max_stamina));
		player:SetCharacterData("Stamina", math.min(stamina, max_stamina));
		cwBeliefs:ResetBeliefSharedVars(player);
		
		hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
		
		player:SetCharacterData("beliefs", beliefs);
		player:SetCharacterData("level", math.max(player:GetCharacterData("level", 1) - levels_to_remove, 1));
		player:SaveCharacter();
	end
end

function cwBeliefs:SetSacramentLevel(player, level)
	local beliefs = player:GetCharacterData("beliefs");
	local oldLevel = player:GetCharacterData("level", 1);
	local numBeliefs = 0;
	
	for k, v in pairs(beliefs) do
		numBeliefs = numBeliefs + 1;
	end
	
	local points = math.Clamp(level - numBeliefs - 1, 0, level - 1);
	
	player:SetCharacterData("level", level);
	player:SetCharacterData("points", points);
	player:SetSharedVar("level", level);
	
	if oldLevel < level then
		Clockwork.plugin:Call("PlayerLevelUp", player, level, points);
	end
end

function cwBeliefs:ResetBeliefSharedVars(player)
	if player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation") then
		player:SetSharedVar("beliefFont", "Voltism");
	elseif player:GetSharedVar("beliefFont") then
		player:SetSharedVar("beliefFont", nil);
	end
	
	if player:HasBelief("nimble") then
		player:SetSharedVar("hasNimble", true);
	elseif player:GetSharedVar("nimble") then
		player:SetSharedVar("hasNimble", nil);
	end
	
	if player:HasBelief("favored") then
		player:SetSharedVar("favored", true);
	elseif player:GetSharedVar("favored") then
		player:SetSharedVar("favored", nil);
	end
end;

netstream.Hook("TakeBelief", function(player, data)
	cwBeliefs:TakeBelief(player, data[1], data[2], data[3]);
end)

concommand.Add("listbeliefs", function(player)
	if (player:IsAdmin()) then
		local beliefs = cwBeliefs.beliefTable;
		
		if beliefs then
			for k, v in pairs (beliefs) do
				for k2, v2 in pairs(v) do
					print(k2);
				end
			end;
		end;
	end;
end)