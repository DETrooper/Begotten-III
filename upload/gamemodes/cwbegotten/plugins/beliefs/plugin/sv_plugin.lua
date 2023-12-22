--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

cwBeliefs.xpValues = {
	["breakdown"] = 1, -- 1 xp per item broken down.
	["copy"] = 200, -- 200 xp per book copied by those with the 'Scribe' belief.
	["damage"] = 0.1, -- 0.1 xp per point of damage dealt per level.
	["drink"] = 3, -- 3 xp per drink consumed.
	["food"] = 5, -- 5 xp per food consumed.
	["kill"] = 2.5, -- 2.5 xp per killing blow per level.
	["meltdown"] = 2, -- 2 xp per item melted down.
	["mutilate"] = 2, -- 2 xp per mutiliation of a corpse. Also includes other stuff like eating hearts or harvesting bones.
	["residual"] = 1, -- 1 xp per minute survived in non-safezones.
	["read"] = 50, -- 50 xp for every unique scripture read.
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
	-- Dual wield beliefs.
	["man_become_beast"] = "You can now dual-wield weapons by combining them in the inventory tab. Only one-handed weapons and daggers can be dual-wielded. You will only be able to thrust attack if both weapons are capable of alternate attacks.",
	["murder_artform"] = "You can now dual-wield weapons by combining them in the inventory tab. Only one-handed weapons and daggers can be dual-wielded. You will only be able to thrust attack if both weapons are capable of alternate attacks.",
	["repentant"] = "You can now dual-wield weapons by combining them in the inventory tab. Only one-handed weapons and daggers can be dual-wielded. You will only be able to thrust attack if both weapons are capable of alternate attacks.",
	["witch_druid"] = "You can now dual-wield weapons by combining them in the inventory tab. Only one-handed weapons and daggers can be dual-wielded. You will only be able to thrust attack if both weapons are capable of alternate attacks.",
};

cwBeliefs.residualXPZones = {"wasteland", "caves", "gore", "sea_styx", "sea_rough", "sea_calm", "toothboy", "scrapper"};

-- A function to level a player up.
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
			player:SetLocalVar("experience", newExperience);
			player:SetCharacterData("points", points);
			player:SetLocalVar("points", points);
			player:SetCharacterData("level", newLevel);
			player:SetSharedVar("level", newLevel);
			Clockwork.plugin:Call("PlayerLevelUp", player, newLevel, points);
		end
	end
end

-- A function to give a new belief to a player.
function cwBeliefs:TakeBelief(player, uniqueID, niceName, category)
	if (!player:GetCharacterData("beliefs")) then
		player:SetCharacterData("beliefs", {});
	end;
	
	local points = player:GetCharacterData("points", 0)
	
	if (points <= 0) then
		Schema:EasyText(player, "chocolate", "You do not have enough faith to follow this belief!")
		return false
	end;
	
	local beliefs = player:GetCharacterData("beliefs");
	local takeBelief = Clockwork.plugin:Call("ResolveBelief", player, uniqueID, category, beliefs);
	
	if (takeBelief and !beliefs[uniqueID]) then
		beliefs[uniqueID] = true
		player:SetCharacterData("beliefs", beliefs)
		player:SetCharacterData("points", math.Clamp(points - 1, 0, 100))
		player:SetLocalVar("points", player:GetCharacterData("points", 0));
		player:Notify("You have taken the \""..niceName.."\" belief.")
		player:SendLua([[Clockwork.Client:EmitSound("ambient/fire/ignite.wav", 40)]]);
		
		hook.Run("BeliefTaken", player, uniqueID, category);
	end;
end;

function cwBeliefs:ForceTakeBelief(player, uniqueID)
	local beliefs = player:GetCharacterData("beliefs", {});
	
	if !beliefs[uniqueID] then
		local beliefTree = self:FindBeliefTreeByBelief(uniqueID);
		local category;

		if beliefTree then
			category = beliefTree.uniqueID;
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
		local beliefTree = self:FindBeliefTreeByBelief(uniqueID);
		local category;

		if beliefTree then
			category = beliefTree.uniqueID;
		end
		
		local beliefTable = self:FindBeliefByID(uniqueID, category)
		
		if beliefTable and beliefTable.subfaith and beliefTable.row == 1 then
			player:SetSharedVar("subfaith", nil);
			player:GetCharacter().subfaith = nil;
		end
		
		beliefs[uniqueID] = false;
		
		if bRemoveDependencies then
			local requirements = beliefTable.requirements; 

			for k, v in pairs(requirements) do
				local requirementTable = self:FindBeliefByID(v, category)
				
				if requirementTable and requirementTable.subfaith and requirementTable.row == 1 then
					player:SetSharedVar("subfaith", nil);
					player:GetCharacter().subfaith = nil;
				end
			
				beliefs[v] = false;
				levels_to_remove = levels_to_remove + 1;
			end;
		end
		
		beliefs[uniqueID] = false;
		
		--local max_poise = player:GetMaxPoise();
		--local poise = player:GetNWInt("meleeStamina");
		local max_stamina = player:GetMaxStamina();
		local max_stability = player:GetMaxStability();
		local stamina = player:GetNWInt("Stamina", 100);
		
		player:SetMaxHealth(player:GetMaxHealth());
		player:SetLocalVar("maxStability", max_stability);
		--player:SetLocalVar("maxMeleeStamina", max_poise);
		--player:SetNWInt("meleeStamina", math.min(poise, max_poise));
		player:SetLocalVar("Max_Stamina", max_stamina);
		player:SetCharacterData("Max_Stamina", max_stamina);
		player:SetNWInt("Stamina", math.min(stamina, max_stamina));
		player:SetCharacterData("Stamina", math.min(stamina, max_stamina));
		
		hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)
		
		player:SetCharacterData("beliefs", beliefs);
		player:SetCharacterData("level", math.max(player:GetCharacterData("level", 1) - levels_to_remove, 1));
		player:SetSharedVar("level", player:GetCharacterData("level", 1));
		player:NetworkBeliefs();
		player:SaveCharacter();
	end
end

function cwBeliefs:SetSacramentLevel(player, level)
	local beliefs = player:GetCharacterData("beliefs", {});
	local oldLevel = player:GetCharacterData("level", 1);
	local numBeliefs = 0;
	
	for k, v in pairs(beliefs) do
		numBeliefs = numBeliefs + 1;
	end
	
	local points = math.Clamp(level - numBeliefs - 1, 0, level - 1);
	
	player:SetCharacterData("experience", 0);
	player:SetLocalVar("experience", 0);
	player:SetCharacterData("points", points);
	player:SetLocalVar("points", points);
	player:SetCharacterData("points", points);
	player:SetCharacterData("level", level);
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