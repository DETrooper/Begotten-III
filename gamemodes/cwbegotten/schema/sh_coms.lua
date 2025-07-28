--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local archPos;
local pillarPos;
local map = string.lower(game.GetMap());
local voltistSounds = {"npc/scanner/scanner_siren2.wav", "npc/scanner/scanner_pain2.wav", "npc/stalker/go_alert2.wav"};

if map == "rp_begotten3" then
	archPos = Vector(9704, -13997, -1164);
	pillarPos = Vector(-11040, -2170, -1560);
elseif map == "rp_begotten_redux" then
	archPos = Vector(2819, -8179, 40);
	pillarPos = Vector(-5798, 9422, 723);
elseif map == "rp_scraptown" then
	archPos = Vector(5040, 10213, 357);
	pillarPos = Vector(9386, -9070, 610);
elseif map == "rp_district21" then
	archPos = Vector(5292, -14361, -406); -- church
	pillarPos = Vector(11376, -2410, -192);
end

if (map == "rp_begotten3") then
	Schema.MapLocations = {
		["castle"] = Vector(-12972, -12901, -1529),
		["city"] = Vector(-357, -4365, -1870),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_gore"] = Vector(-12067, -12392, 12062),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["duel_wasteland"] = Vector(14075, -5952, -2306),
		["gore"] = Vector(510, -8873, 11710),
		["goredocks"] = Vector(-2509, -468, 11688),
		["gorewatch"] = Vector(9700, 11140, -1177),
		["hell"] = Vector(-1430, -9129, -6537),
		["scrapfactory"] = Vector(-1182, -11728, -1263),
		["sea_calm"] = Vector(-208, 9115, -6089),
		["sea_rough"] = Vector(10191, 9536, -5824),
		["sea_styx"] = Vector(-9911, 9171, -6033),
		["ship"] = Vector(-10612, 4328, -1702),
		["toothboy"] = Vector(12646, -12983, -1074),
		["tower"] = Vector(-84, 11626, -1081),
	}
elseif (map == "rp_begotten_redux") then
	Schema.MapLocations = {
		["church"] = Vector(-13184, -8123, 163),
		["city"] = Vector(-6317, -8067, 709),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["hell"] = Vector(-1430, -9129, -6537),
		["old_manor"] = Vector(12306, 11391, 918),
		["pillars"] = Vector(-5675, 8253, 1454),
		["town"] = Vector(-9805, -8128, 463),
	}
elseif (map == "rp_scraptown") then
	Schema.MapLocations = {
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["hell"] = Vector(-1430, -9129, -6537),
		["pillars"] = Vector(8867.856445, -8418.77832, 613),
		["scrapfactory"] = Vector(-5816.024414, -7112.630859, -787.41449),
		["scraptown"] = Vector(-4161.598633, -3384.802979, 571),
	}
elseif (map == "rp_district21") then
	Schema.MapLocations = {
		["church"] = Vector(5299, -13730, -496),
		["docks"] = Vector(-12920, -12259, -862),
		["duel_bridge"] = Vector(11855, -12557, -6132),
		["duel_hell"] = Vector(-11684, -8681, -12481),
		["duel_gore"] = Vector(-12067, -12392, 12062),
		["duel_silenthill"] = Vector(8966, -12703, -6185),
		["duel_wasteland"] = Vector(14075, -5952, -2306),
		["gasstation"] = Vector(-11849, 3627, -752),
		["gore"] = Vector(510, -8873, 11710),
		["goredocks"] = Vector(-2509, -468, 11688),
		["hell"] = Vector(-1430, -9129, -6537),
		["hill"] = Vector(-7131, 11049, 172),
		["pillars"] = Vector(10794, -2413, -248),
		["ruins"] = Vector(9866, 9898, -508),
		["scrapfactory"] = Vector(8264, 14075, -1054),
		["sea_calm"] = Vector(-208, 9115, -6089),
		["sea_rough"] = Vector(10191, 9536, -5824),
		["sea_styx"] = Vector(-9911, 9171, -6033),
		["ship"] = Vector(-10612, 4328, -1702),
		["voltbunker"] = Vector(-12934, -3154, -512),
		["gorewatch"] = Vector(-8927, -8286, -68),
	}
else
	Schema.MapLocations = {};
end

if (Schema.MapLocations) then
	local mapString = {}
		for k, v in pairs (Schema.MapLocations) do
			mapString[#mapString + 1] = k
		end
	local mapString = table.concat(mapString, ", ")

	local COMMAND = Clockwork.command:New("MapLocation")
		COMMAND.tip = "Teleport to a map location. Available locations: "..mapString
		COMMAND.text = "<string Name>"
		COMMAND.access = "o"
		COMMAND.arguments = 1

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			if (arguments[1]) then
				local location = string.lower(tostring(arguments[1]))
				
				if (Schema.MapLocations[location]) then
					player:SetPos(Schema.MapLocations[location])
				else
					Schema:EasyText(player, "darkgrey", location.." is not a valid location!")
				end
			else
				Schema:EasyText(player, "darkgrey", location.." is not a valid location!")
			end
		end
	COMMAND:Register()
end

local COMMAND = Clockwork.command:New("Discord");
	COMMAND.tip = "Open a redirect to the server's Discord.";
	COMMAND.important = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:SendLua([[gui.OpenURL(config.Get("discord_url"):Get())]]);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Warhorn");
	COMMAND.tip = "Sound a signal from your warhorn or death whistle.";
	COMMAND.text = "[string Signal]";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local warhornStr = "warhorn";
		local faction = player:GetFaction();
	
		if player:GetFaction() == "Children of Satan" then
			if player:HasItemByID("death_whistle") then
				warhornStr = "death_whistle";
			end
		end

		if !player:HasItemByID(warhornStr) then
			Schema:EasyText(player, "darkgrey", "You do not possess a warhorn item!")
		
			return;
		end
		
		local warhornItemTable = Clockwork.item:FindByID(warhornStr);
		
		if warhornItemTable then
			local signalStr = string.lower(table.concat(arguments, " "));
			
			for i, v in ipairs(warhornItemTable.customFunctions) do
				if string.find(string.lower(v), signalStr, 1, true) then
					warhornItemTable:OnCustomFunction(player, v);
				
					return;
				end
			end
			
			Schema:EasyText(player, "darkgrey", "The signal you entered is invalid!");
		else
			Schema:EasyText(player, "darkgrey", "The warhorn item does not exist!");
		end
	end
COMMAND:Register();

local COMMAND = Clockwork.command:New("Enlist")
	COMMAND.tip = "Enlist a character into your faction or a specified faction. This will only work if you are a rank of authority."
	COMMAND.text = "[string Faction] [string Subfaction]"
	COMMAND.flags = CMD_DEFAULT;
	--COMMAND.access = "o"
	COMMAND.optionalArguments = 2;
	COMMAND.alias = {"PlyEnlist", "CharEnlist", "Recruit", "PlyRecruit", "CharRecruit"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
		
		if (target and target:Alive()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				local playerFaction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
				local playerFactionTable = Clockwork.faction:GetStored()[playerFaction];
				local targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
				local enlistFaction = arguments[1] or playerFaction;
				local enlistFactionTable = Clockwork.faction:GetStored()[enlistFaction];
				
				if !enlistFactionTable then
					Schema:EasyText(player, "firebrick", enlistFaction.." is not a valid faction!");
					
					return;
				end
				
				if !enlistFactionTable.enlist then
					Schema:EasyText(player, "firebrick", "Characters cannot be enlisted into the "..enlistFaction.." faction!");
					
					return;
				end
				
				local isMasterFaction = (enlistFactionTable.masterfactions and table.HasValue(enlistFactionTable.masterfactions, playerFaction));
			
				if player:IsAdmin() or (enlistFaction == playerFaction and enlistFactionTable and enlistFactionTable.enlist and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or isMasterFaction then
					if targetFaction == enlistFaction then
						Schema:EasyText(player, "grey", target:Name().." is already a "..enlistFaction.."!");

						return;
					end
					
					if !Clockwork.faction:IsGenderValid(enlistFaction, target:GetGender()) then
						Schema:EasyText(player, "firebrick", target:Name().." is not the correct gender for the "..enlistFaction.." faction!");
						
						return;
					end;
					
					if player:InTower() then
						if !Schema.towerSafeZoneEnabled then
							Schema:EasyText(player, "firebrick", "The safezone must be enabled in order to run this commmand!");
							
							return;
						end
					else
						Schema:EasyText(player, "firebrick", "You must do this inside a safezone!");
						
						return;
					end
					
					local subfaction;
					local factionSubfactions = enlistFactionTable.subfactions;
					
					if enlistFactionTable then
						subfaction = arguments[2];
					
						for i, v in ipairs(factionSubfactions) do
							if i == 1 and !subfaction then
								subfaction = v;
								
								break;
							elseif v.name == subfaction then
								subfaction = v;
								
								break;
							end
						end
					end
					
					if playerFactionTable.CanEnlist and playerFactionTable:CanEnlist(player, target, enlistFaction, subfaction) == false then
						return;
					end
				
					if !subfaction or istable(subfaction) then
						if targetFaction == "Wanderer" or (enlistFaction ~= "Children of Satan" and targetFaction == "Children of Satan" and target:GetSubfaction() == "Kinisger") then
							local playerName = player:Name();
						
							Clockwork.dermaRequest:RequestConfirmation(target, enlistFaction.." Enlistment", playerName.." has invited you to enlist into the "..enlistFaction.." faction!", function()
								targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
								
								if (targetFaction == "Wanderer" or (enlistFaction ~= "Children of Satan" and targetFaction == "Children of Satan" and target:GetSubfaction() == "Kinisger")) and target:Alive() and Clockwork.faction:IsGenderValid(enlistFaction, target:GetGender()) then
									local bSuccess, fault = Clockwork.faction:GetStored()[enlistFaction]:OnTransferred(target, Clockwork.faction:GetStored()[targetFaction]);
									
									if (bSuccess != false) then
										if target:GetFaction() ~= "Children of Satan" then
											target:SetCharacterData("Faction", enlistFaction, true);
											
											if subfaction then
												target:SetCharacterData("Subfaction", subfaction.name, true);
												
												if cwBeliefs then
													-- Remove any subfaction locked beliefs.
													local beliefsTab = cwBeliefs:GetBeliefs();
													local targetBeliefs = target:GetCharacterData("beliefs");
													local targetEpiphanies = target:GetCharacterData("points", 0);
													
													for k, v in pairs(beliefsTab) do
														if v.lockedSubfactions and table.HasValue(v.lockedSubfactions, subfaction) then
															if targetBeliefs[k] then
																targetBeliefs[k] = false;
																
																targetEpiphanies = targetEpiphanies + 1;
																
																local beliefTree = cwBeliefs:FindBeliefTreeByBelief(k);
																
																if beliefTree.hasFinisher and targetBeliefs[beliefTree.uniqueID.."_finisher"] then
																	targetBeliefs[beliefTree.uniqueID.."_finisher"] = false;
																end
															end
														end
													end
													
													target:SetCharacterData("beliefs", targetBeliefs);
													target:SetLocalVar("points", targetEpiphanies);
													target:SetCharacterData("points", targetEpiphanies);
													
													--local max_poise = target:GetMaxPoise();
													--local poise = target:GetNWInt("meleeStamina");
													local max_stamina = target:GetMaxStamina();
													local max_stability = target:GetMaxStability();
													local stamina = target:GetNWInt("Stamina", 100);
													
													target:SetMaxHealth(target:GetMaxHealth());
													target:SetLocalVar("maxStability", max_stability);
													--target:SetLocalVar("maxMeleeStamina", max_poise);
													--target:SetNWInt("meleeStamina", math.min(poise, max_poise));
													target:SetLocalVar("Max_Stamina", max_stamina);
													target:SetCharacterData("Max_Stamina", max_stamina);
													target:SetNWInt("Stamina", math.min(stamina, max_stamina));
													target:SetCharacterData("Stamina", math.min(stamina, max_stamina));
													
													hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true)
													
													target:NetworkBeliefs();
												end
											end
										else
											target:SetCharacterData("kinisgerOverride", enlistFaction);
											target:SetNetVar("kinisgerOverride", enlistFaction);
											
											if subfaction then
												target:SetCharacterData("kinisgerOverrideSubfaction", subfaction.name);
												target:SetNetVar("kinisgerOverrideSubfaction", subfaction.name);
											end
										end
										
										if subfaction then
											for i, v in ipairs(enlistFactionTable.subfactions) do
												if v.name == subfaction then
													if v.startingRank then
														target:SetCharacterData("rank", v.startingRank);
													end
													
													break;
												end
											end
										end
										
										local targetAngles = target:EyeAngles();
										local targetPos = target:GetPos();
										
										Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
										
										target:SetPos(targetPos);
										target:SetEyeAngles(targetAngles);
										
										Clockwork.player:NotifyAll(playerName.." has enlisted "..target:Name().." into the "..enlistFaction.." faction!");
									end;
								end
							end)
							
							Schema:EasyText(player, "green", "You have invited "..target:Name().." to enlist into the "..enlistFaction.." faction!");
							Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has invited "..target:Name().." to join the "..enlistFaction.." faction!");
						elseif targetFaction == "Children of Satan" then
							-- Bogus text to prevent metagame.
							Schema:EasyText(target, "red", player:Name().." has tried to enlist you into the "..enlistFaction.." faction, but as a Child of Satan you are unable to accept! They have been sent a fake message saying you were invited.");
							Schema:EasyText(player, "green", "You have invited "..target:Name().." to enlist into the "..enlistFaction.." faction!");
						else
							Schema:EasyText(player, "firebrick", target:Name().." is not the right faction to be enlisted into this faction!");
						end
					else
						Schema:EasyText(player, "firebrick", subfaction.." is not a valid subfaction for this faction!");
					end
				else
					Schema:EasyText(player, "firebrick", "You do not have permissions to enlist "..target:Name().."!");
				end;
			else
				Schema:EasyText(player, "firebrick", "This character is too far away!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("Initiate")
	COMMAND.tip = "Initiate an aspirant into the Children of Satan."
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"PlyInitiate", "CharInitiate"};
	COMMAND.faction = "Children of Satan";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() ~= "Children of Satan" then
			Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");

			return false;
		end
	
		local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
		
		if (target and target:Alive()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				local faction = "Children of Satan";
				local factionTable = Clockwork.faction:GetStored()[faction];
				local targetFaction = target:GetFaction();
				
				if player:IsAdmin() or (player:GetFaction() == faction and factionTable and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) >= 3) then
					local lastZone = player:GetCharacterData("LastZone");
					
					if targetFaction == faction then
						Schema:EasyText(player, "grey", target:Name().." is already a Child of Satan!");

						return;
					end
					
					if target:GetFaith() ~= "Faith of the Dark" then
						Schema:EasyText(player, "firebrick", target:Name().." does not worship the Dark Lord!");

						return;
					end
					
					if lastZone ~= "hell" and lastZone ~= "manor" then
						Schema:EasyText(player, "firebrick", "You must do this in hell!");
						
						return;
					end
				
					if targetFaction == "Wanderer" then
						local playerName = player:Name();
					
						Clockwork.dermaRequest:RequestConfirmation(target, "A Dark Invitation", playerName.." has extended an invitation into the Children of Satan!", function()
							targetFaction = target:GetFaction();
							
							if (targetFaction == "Wanderer" and target:Alive() and target:GetFaith() == "Faith of the Dark") then
								local bSuccess, fault = Clockwork.faction:GetStored()[faction]:OnTransferred(target, Clockwork.faction:GetStored()[targetFaction]);
								
								if (bSuccess != false) then
									target:SetCharacterData("Faction", faction, true);
									target:SetCharacterData("Subfaction", "", true);
									target:SetCharacterData("rank", 10); -- Aspirant
									target:SetCharacterData("rankOverride", nil);
									
									if cwBeliefs then
										--local max_poise = target:GetMaxPoise();
										--local poise = target:GetNWInt("meleeStamina");
										local max_stamina = target:GetMaxStamina();
										local max_stability = target:GetMaxStability();
										local stamina = target:GetNWInt("Stamina", 100);
										
										target:SetMaxHealth(target:GetMaxHealth());
										target:SetLocalVar("maxStability", max_stability);
										--target:SetLocalVar("maxMeleeStamina", max_poise);
										--target:SetNWInt("meleeStamina", math.min(poise, max_poise));
										target:SetLocalVar("Max_Stamina", max_stamina);
										target:SetCharacterData("Max_Stamina", max_stamina);
										target:SetNWInt("Stamina", math.min(stamina, max_stamina));
										target:SetCharacterData("Stamina", math.min(stamina, max_stamina));
										
										hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true);
									end
									
									local targetAngles = target:EyeAngles();
									local targetPos = target:GetPos();
									
									Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
									
									target:SetPos(targetPos);
									target:SetEyeAngles(targetAngles);
									
									Clockwork.player:NotifyAll(playerName.." has initiated "..target:Name().." into the Children of Satan!");
								end;
							end
						end)
						
						Schema:EasyText(player, "green", "You have extended an invitation to "..target:Name().." to join he Children of Satan!");
						Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has invited "..target:Name().." to join the Children of Satan!");
					else
						Schema:EasyText(player, "firebrick", target:Name().." is not the right faction to be initiated into this faction!");
					end
				else
					Schema:EasyText(player, "firebrick", "You do not have permissions to enlist "..target:Name().."!");
				end;
			else
				Schema:EasyText(player, "firebrick", "This character is too far away!");
			end;
		else
			Schema:EasyText(player, "firebrick", "You must look at a character!");
		end
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("SetCustomRank")
	COMMAND.tip = "Set a character's custom rank. If blank, it will be reset. The optional rank index should correspond to what their actual rank would be (i.e. 2 for Acolyte)."
	COMMAND.text = "<string Character> [string Rank] [number RankIndex]"
	COMMAND.access = "o"
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharSetCustomRank", "PlySetCustomRank", "PromoteCustom", "SetRankOverride", "SetRankCustom"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local rankOverride = arguments[2];
		local rank;
		
		if arguments[3] then
			rank = string.lower(tostring(arguments[3]));
		end
		
		if (target) then
			local faction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
			local factionTable = Clockwork.faction:FindByID(faction);
			local playerFaction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
			local isMasterFaction = (factionTable and factionTable.masterfactions and table.HasValue(factionTable.masterfactions, playerFaction));
		
			if player:IsAdmin() or ((playerFaction == faction and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or isMasterFaction) then
				local name = target:Name();
				local ranks = Schema.Ranks;

				if (!ranks[faction]) then
					Schema:EasyText(player, "darkgrey", target:Name().." does not belong to a faction with ranks!");
					return;
				end;
				
				if rank then
					for k, v in pairs (ranks[faction]) do
						if (string.lower(v) == tostring(rank) or k == tonumber(rank)) then
							rank = k;
						end;
					end;
				end;

				if !rank or ranks[faction][rank] then
					if !isMasterFaction and Schema:GetRankTier(faction, rank) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().."!");
							
							return false;
						end
					end
					
					if !isMasterFaction and Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().."!");
							
							return false;
						end
					end
					
					if factionTable.CanPromote and factionTable:CanPromote(player, target, faction, targetSubfaction) == false then
						Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().."!");
					
						return false;
					end
					
					if factionTable.RanksToSubfaction and !factionTable.promoteAcrossSubfactions then
						local subfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetSubfaction();
						
						if Schema.RanksToSubfaction[faction][ranks[faction][rank]] and Schema.RanksToSubfaction[faction][ranks[faction][rank]] ~= subfaction then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to this rank as it is not valid for their subfaction!");
						
							return false;
						end
					end
				
					if rank then
						target:SetCharacterData("rank", rank);
					end
					
					target:SetCharacterData("rankOverride", rankOverride);
					hook.Run("PlayerChangedRanks", target);
					
					if Schema.RanksToSubfaction and Schema.RanksToSubfaction[faction] then
						local subfaction = Schema.RanksToSubfaction[faction][ranks[faction][rank]];
						
						if subfaction then
							if target:GetNetVar("kinisgerOverride") then
								target:SetCharacterData("kinisgerOverrideSubfaction", subfaction);
								target:SetNetVar("kinisgerOverrideSubfaction", subfaction);
							else
								target:SetCharacterData("Subfaction", subfaction, true);
								
								if cwBeliefs then
									-- Remove any subfaction locked beliefs.
									local beliefsTab = cwBeliefs:GetBeliefs();
									local targetBeliefs = target:GetCharacterData("beliefs");
									local targetEpiphanies = target:GetCharacterData("points", 0);
									
									for k, v in pairs(beliefsTab) do
										if v.lockedSubfactions and table.HasValue(v.lockedSubfactions, subfaction) then
											if targetBeliefs[k] then
												targetBeliefs[k] = false;
												
												targetEpiphanies = targetEpiphanies + 1;
												
												local beliefTree = cwBeliefs:FindBeliefTreeByBelief(k);
												
												if beliefTree.hasFinisher and targetBeliefs[beliefTree.uniqueID.."_finisher"] then
													targetBeliefs[beliefTree.uniqueID.."_finisher"] = false;
												end
											end
										end
									end
									
									target:SetCharacterData("beliefs", targetBeliefs);
									target:SetLocalVar("points", targetEpiphanies);
									target:SetCharacterData("points", targetEpiphanies);
									
									--local max_poise = target:GetMaxPoise();
									--local poise = target:GetNWInt("meleeStamina");
									local max_stamina = target:GetMaxStamina();
									local max_stability = target:GetMaxStability();
									local stamina = target:GetNWInt("Stamina", 100);
									
									target:SetMaxHealth(target:GetMaxHealth());
									target:SetLocalVar("maxStability", max_stability);
									--target:SetLocalVar("maxMeleeStamina", max_poise);
									--target:SetNWInt("meleeStamina", math.min(poise, max_poise));
									target:SetLocalVar("Max_Stamina", max_stamina);
									target:SetCharacterData("Max_Stamina", max_stamina);
									target:SetNWInt("Stamina", math.min(stamina, max_stamina));
									target:SetCharacterData("Stamina", math.min(stamina, max_stamina));
									
									hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true)
									
									target:NetworkBeliefs();
								end
							end
							
							local targetAngles = target:EyeAngles();
							local targetPos = target:GetPos();
							
							Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
							
							target:SetPos(targetPos);
							target:SetEyeAngles(targetAngles);
						end
					end
					
					local notifyTarget = true;
					
					if (target == player) then
						name = "yourself";
						notifyTarget = false;
					end;
					
					if rankOverride then
						if (notifyTarget) then
							Schema:EasyText(target, "olivedrab", "You have been promoted to the rank of \""..rankOverride.."\".")
						end;
						
						Schema:EasyText(player, "cornflowerblue", "You have promoted "..name.." to the rank of \""..rankOverride.."\".");
						
						if target == player then
							Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has promoted themself to the custom rank of \""..rankOverride.."\".");
						else
							Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has promoted "..name.." to the custom rank of \""..rankOverride.."\".");
						end
					end
				else
					Schema:EasyText(player, "darkgrey", "The rank index specified is not valid!");
				end;
			else
				Schema:EasyText(player, "grey", "You do not have permissions to change the rank of "..target:Name().."!");
			end;
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("Promote")
	COMMAND.tip = "Promote a character if they belong to a faction with ranks. Optional 2nd argument allows you to directly set the rank, otherwise they will be automatically promoted to the next rank available for their subfaction."
	COMMAND.text = "<string Character> [string Rank]"
	--COMMAND.access = "o"
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.types = {"Player", "Rank"}
	COMMAND.important = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local rank;
		
		if arguments[2] then
			rank = string.lower(tostring(arguments[2]));
		end
		
		if (target) then
			local faction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
			local factionTable = Clockwork.faction:FindByID(faction);
			local targetSubfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetSubfaction();
			local playerFaction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
			local targetCurrentRank = target:GetCharacterData("rank", 1);
			local isMasterFaction = (factionTable and factionTable.masterfactions and table.HasValue(factionTable.masterfactions, playerFaction));
		
			if player:IsAdmin() or ((playerFaction == faction and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or isMasterFaction) then
				local name = target:Name();
				local ranks = Schema.Ranks;

				if (!ranks[faction]) then
					Schema:EasyText(player, "darkgrey", target:Name().." does not belong to a faction with ranks!");
					return;
				end;

				if rank then
					for k, v in pairs(ranks[faction]) do
						if (string.lower(v) == tostring(rank) or k == tonumber(rank)) then
							rank = k;
						end;
					end;
				else
					local rankTier = Schema:GetRankTier(faction, targetCurrentRank);
					local nextTierRanks = Schema.RankTiers[faction][rankTier + 1];
					
					if nextTierRanks then
						local defaultRank;
						local ranksToSubfactions = Schema.RanksToSubfaction[faction];
						
						for i, v in ipairs(nextTierRanks) do
							if !ranksToSubfactions[v] then
								if !defaultRank then
									defaultRank = table.KeyFromValue(ranks[faction], v);
								end
							elseif ranksToSubfactions[v] == targetSubfaction then
								rank = table.KeyFromValue(ranks[faction], v);
								
								break;
							end
							
							if i == #nextTierRanks then
								if defaultRank then
									rank = defaultRank;
								else
									rank = table.KeyFromValue(ranks[faction], nextTierRanks[1]);
								end
							end
						end
					end
					
					if !rank then
						rank = math.Clamp(target:GetCharacterData("rank", 1) + 1, 1, #ranks[faction]);
					end
				end;

				if (ranks[faction][rank]) then
					if rank == target:GetCharacterData("rank", 1) then
						Schema:EasyText(player, "grey", target:Name().." already holds the rank of "..ranks[faction][rank].."!");
						
						return false;
					end
				
					if !isMasterFaction and Schema:GetRankTier(faction, rank) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to "..ranks[faction][rank].."!");
							
							return false;
						end
					end
					
					if !isMasterFaction and Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to "..ranks[faction][rank].."!");
							
							return false;
						end
					end
					
					if factionTable.CanPromote and factionTable:CanPromote(player, target, faction, targetSubfaction) == false then
						Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().."!");
					
						return false;
					end
					
					if factionTable.RanksToSubfaction and !factionTable.promoteAcrossSubfactions then
						local subfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetSubfaction();
						
						if Schema.RanksToSubfaction[faction][ranks[faction][rank]] and Schema.RanksToSubfaction[faction][ranks[faction][rank]] ~= subfaction then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to this rank as it is not valid for their subfaction!");
						
							return false;
						end
					end
					
					target:SetCharacterData("rank", rank);
					hook.Run("PlayerChangedRanks", target);
					
					if Schema.RanksToSubfaction and Schema.RanksToSubfaction[faction] then
						local subfaction = Schema.RanksToSubfaction[faction][ranks[faction][rank]];
						
						if subfaction then
							if target:GetNetVar("kinisgerOverride") then
								target:SetCharacterData("kinisgerOverrideSubfaction", subfaction);
								target:SetNetVar("kinisgerOverrideSubfaction", subfaction);
							else
								target:SetCharacterData("Subfaction", subfaction, true);
								
								if cwBeliefs then
									-- Remove any subfaction locked beliefs.
									local beliefsTab = cwBeliefs:GetBeliefs();
									local targetBeliefs = target:GetCharacterData("beliefs");
									local targetEpiphanies = target:GetCharacterData("points", 0);
									
									for k, v in pairs(beliefsTab) do
										if v.lockedSubfactions and table.HasValue(v.lockedSubfactions, subfaction) then
											if targetBeliefs[k] then
												targetBeliefs[k] = false;
												
												targetEpiphanies = targetEpiphanies + 1;
												
												local beliefTree = cwBeliefs:FindBeliefTreeByBelief(k);
												
												if beliefTree.hasFinisher and targetBeliefs[beliefTree.uniqueID.."_finisher"] then
													targetBeliefs[beliefTree.uniqueID.."_finisher"] = false;
												end
											end
										end
									end
									
									target:SetCharacterData("beliefs", targetBeliefs);
									target:SetLocalVar("points", targetEpiphanies);
									target:SetCharacterData("points", targetEpiphanies);
									
									target:NetworkBeliefs();
								end
							end
							
							local targetAngles = target:EyeAngles();
							local targetPos = target:GetPos();
							
							Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
							
							target:SetPos(targetPos);
							target:SetEyeAngles(targetAngles);
						end
					end
	
					--local max_poise = target:GetMaxPoise();
					--local poise = target:GetNWInt("meleeStamina");
					local max_stamina = target:GetMaxStamina();
					local max_stability = target:GetMaxStability();
					local stamina = target:GetNWInt("Stamina", 100);
					
					target:SetMaxHealth(target:GetMaxHealth());
					target:SetLocalVar("maxStability", max_stability);
					--target:SetLocalVar("maxMeleeStamina", max_poise);
					--target:SetNWInt("meleeStamina", math.min(poise, max_poise));
					target:SetLocalVar("Max_Stamina", max_stamina);
					target:SetCharacterData("Max_Stamina", max_stamina);
					target:SetNWInt("Stamina", math.min(stamina, max_stamina));
					target:SetCharacterData("Stamina", math.min(stamina, max_stamina));
					
					hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true)
					
					local notifyTarget = true;
					
					if (target == player) then
						name = "yourself";
						notifyTarget = false;
					end;
					
					if (notifyTarget) then
						Schema:EasyText(target, "olivedrab", "You have been promoted to the rank of \""..ranks[faction][rank].."\".")
					end;
					
					Schema:EasyText(player, "cornflowerblue", "You have promoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
					
					if target == player then
						Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has promoted themself to the rank of \""..ranks[faction][rank].."\".");
					else
						Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has promoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
					end
				else
					Schema:EasyText(player, "darkgrey", "The rank specified is not valid!");
				end;
			else
				Schema:EasyText(player, "grey", "You do not have permissions to change the rank of "..target:Name().."!");
			end;
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("Demote")
	COMMAND.tip = "Demote a character if they belong to a faction with ranks."
	COMMAND.text = "<string Character>"
	--COMMAND.access = "o"
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (target) then
			local faction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
			local factionTable = Clockwork.faction:FindByID(faction);
			local targetSubfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetSubfaction();
			local playerFaction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
			local targetCurrentRank = target:GetCharacterData("rank", 1);
			local isMasterFaction = (factionTable and factionTable.masterfactions and table.HasValue(factionTable.masterfactions, playerFaction));
		
			if player:IsAdmin() or ((playerFaction == faction and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or isMasterFaction) then
				local name = target:Name();
				local ranks = Schema.Ranks;
				
				if (!ranks[faction]) then
					Schema:EasyText(player, "darkgrey", target:Name().." does not belong to a faction with ranks!");
					return;
				end;
				
				if !isMasterFaction and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) <= Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) then
					if !player:IsAdmin() then
						Schema:EasyText(player, "grey", "You cannot demote "..target:Name().."!");
						
						return false;
					end
				end
				
				if factionTable.CanDemote and factionTable:CanDemote(player, target, faction, targetSubfaction) == false then
					Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().."!");
				
					return false;
				end

				local rankTier = Schema:GetRankTier(faction, targetCurrentRank);
				
				if rankTier == 1 then
					Schema:EasyText(player, "grey", target:Name().." cannot be demoted any further!");
				
					return false;
				end
				
				local rank;
				local rankTier = Schema:GetRankTier(faction, targetCurrentRank);
				local prevTierRanks = Schema.RankTiers[faction][rankTier - 1];
				
				if prevTierRanks then
					local defaultRank;
					local ranksToSubfactions = Schema.RanksToSubfaction[faction];
					
					for i, v in ipairs(prevTierRanks) do
						if !ranksToSubfactions[v] then
							if !defaultRank then
								defaultRank = table.KeyFromValue(ranks[faction], v);
							end
						elseif ranksToSubfactions[v] == targetSubfaction then
							rank = table.KeyFromValue(ranks[faction], v);
							
							break;
						end
						
						if i == #prevTierRanks then
							if defaultRank then
								rank = defaultRank;
							else
								rank = table.KeyFromValue(ranks[faction], prevTierRanks[1]);
							end
						end
					end
				end
				
				if !rank then
					rank = math.Clamp(target:GetCharacterData("rank", 1) - 1, 1, #ranks[faction]);
				end
				
				if rank == targetCurrentRank then
					Schema:EasyText(player, "grey", target:Name().." cannot be demoted any further!");
				
					return false;
				end
				
				if factionTable.RanksToSubfaction and !factionTable.promoteAcrossSubfactions then
					local subfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetSubfaction();
					
					if Schema.RanksToSubfaction[faction][ranks[faction][rank]] and Schema.RanksToSubfaction[faction][ranks[faction][rank]] ~= subfaction then
						Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to this rank as it is not valid for their subfaction!");
					
						return false;
					end
				end
				
				target:SetCharacterData("rank", rank);
				hook.Run("PlayerChangedRanks", target);
				
				if Schema.RanksToSubfaction and Schema.RanksToSubfaction[faction] then
					local subfaction = Schema.RanksToSubfaction[faction][ranks[faction][rank]];
					
					if subfaction then
						if target:GetNetVar("kinisgerOverride") then
							target:SetCharacterData("kinisgerOverrideSubfaction", subfaction);
							target:SetNetVar("kinisgerOverrideSubfaction", subfaction);
						else
							target:SetCharacterData("Subfaction", subfaction, true);
							
							-- Remove any subfaction locked beliefs.
							local beliefsTab = cwBeliefs:GetBeliefs();
							local targetBeliefs = target:GetCharacterData("beliefs");
							local targetEpiphanies = target:GetCharacterData("points", 0);
							
							for k, v in pairs(beliefsTab) do
								if v.lockedSubfactions and table.HasValue(v.lockedSubfactions, subfaction) then
									if targetBeliefs[k] then
										targetBeliefs[k] = false;
										
										targetEpiphanies = targetEpiphanies + 1;
										
										local beliefTree = cwBeliefs:FindBeliefTreeByBelief(k);
										
										if beliefTree.hasFinisher and targetBeliefs[beliefTree.uniqueID.."_finisher"] then
											targetBeliefs[beliefTree.uniqueID.."_finisher"] = false;
										end
									end
								end
							end
							
							target:SetCharacterData("beliefs", targetBeliefs);
							target:SetLocalVar("points", targetEpiphanies);
							target:SetCharacterData("points", targetEpiphanies);
							
							hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true)
							
							target:NetworkBeliefs();
						end
						
						local targetAngles = target:EyeAngles();
						local targetPos = target:GetPos();
						
						Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
						
						target:SetPos(targetPos);
						target:SetEyeAngles(targetAngles);
					end
				end
					
				--local max_poise = target:GetMaxPoise();
				--local poise = target:GetNWInt("meleeStamina");
				local max_stamina = target:GetMaxStamina();
				local max_stability = target:GetMaxStability();
				local stamina = target:GetNWInt("Stamina", 100);
				
				target:SetMaxHealth(target:GetMaxHealth());
				target:SetLocalVar("maxStability", max_stability);
				--target:SetLocalVar("maxMeleeStamina", max_poise);
				--target:SetNWInt("meleeStamina", math.min(poise, max_poise));
				target:SetLocalVar("Max_Stamina", max_stamina);
				target:SetCharacterData("Max_Stamina", max_stamina);
				target:SetNWInt("Stamina", math.min(stamina, max_stamina));
				target:SetCharacterData("Stamina", math.min(stamina, max_stamina));
				
				hook.Run("RunModifyPlayerSpeed", target, target.cwInfoTable, true)
				
				if (target == player) then
					name = "yourself";
				end;

				Schema:EasyText(player, "cornflowerblue", "You have demoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
				
				if target == player then
					Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has demoted themself to the rank of \""..ranks[faction][rank].."\".");
				else
					Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has promoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
				end
			else
				Schema:EasyText(player, "grey", "You do not have permissions to change the rank of "..target:Name().."!");
			end
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("Vector")
	COMMAND.tip = "Get the vector of the position at your cursor."
	COMMAND.access = "o"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local position = player:GetEyeTraceNoCursor().HitPos
		local x, y, z = position.x, position.y, position.z
		
		if (!arguments[1]) then
			x, y, z = math.Round(x), math.Round(y), math.Round(z)
		else
			local decimal = arguments[1] or 0
			decimal = math.Clamp(tonumber(decimal), 0, 5)
			x, y, z = math.Round(x, decimal), math.Round(y, decimal), math.Round(z, decimal)
		end
		
		local vectorString = "Vector("..x..", "..y..", "..z..")"
		Schema:EasyText(player, "blue", vectorString)
		netstream.Start(player, "cwClipboardText", vectorString)
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("CharSearch");
	COMMAND.tip = "Search a character if they are tied.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
		
		if (target) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				if (player:GetNetVar("tied") == 0) then
					if (target:GetNetVar("tied") != 0) then
						if (target:GetVelocity():Length() == 0) then
							if (!player.searching) then
								target.beingSearched = true;
								player.searching = target;
								
								if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
									Schema:OpenSound(target, player);
									
									for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
										if v:IsPlayer() then
											Clockwork.chatBox:Add(v, player, "me", "starts searching "..Clockwork.player:FormatRecognisedText(v, "%s", target)..".");
										end
									end
								end
								
								Clockwork.storage:Open(player, {
									name = Clockwork.player:FormatRecognisedText(player, "%s", target),
									weight = target:GetMaxWeight(),
									entity = target,
									distance = 192,
									cash = target:GetCash(),
									inventory = target:GetInventory(),
									OnClose = function(player, storageTable, entity)
										player.searching = nil;
										
										if (IsValid(entity)) then
											entity.beingSearched = nil;
										end;
									end,
									OnTakeItem = function(player, storageTable, itemTable)
									end,
									OnGiveItem = function(player, storageTable, itemTable)
									end
								});
							else
								Schema:EasyText(player, "peru", "You are already searching a character!");
							end;
						else
							Schema:EasyText(player, "peru", "You cannot search a moving character!");
						end;
					else
						Schema:EasyText(player, "peru", "This character is not tied!");
					end;
				else
					Schema:EasyText(player, "peru", "You don't have permission to do this right now!");
				end;
			else
				Schema:EasyText(player, "firebrick", "This character is too far away!");
			end;
		else
			Schema:EasyText(player, "peru", "You must look at a character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharPermaKill");
	COMMAND.tip = "Permanently kill a character.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (!target:GetCharacterData("permakilled")) then
				Schema:PermaKillPlayer(target, target:GetRagdollEntity());
			else
				Schema:EasyText(player, "darkgrey", "This character is already permanently killed!");
				
				return;
			end;
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." permanently killed the character '"..target:Name().."'.")
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnPermakill");
	COMMAND.tip = "Un-permanently kill a character. Be very sure their name is exact or you might end up unpermakilling someone else in the database.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyUnPermakill", "UnPermakill"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (target:GetCharacterData("permakilled")) then
				Schema:UnPermaKillPlayer(target, target:GetRagdollEntity());
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..target:SteamName().."'s character \""..target:Name().."\"!");
				
				return;
			else
				Schema:EasyText(player, "darkgrey", "This character is not permanently killed!");
				
				return;
			end;
		end;
		
		for _, target in _player.Iterator() do
			if target.cwCharacterList then
				for k, character in pairs(target.cwCharacterList) do
					if character.name == arguments[1] then
						if character.data["permakilled"] then
							character.data["permakilled"] = false;

							Clockwork.player:SaveCharacter(target);
							
							for k2, v in pairs(target.cwCharacterList) do
								Clockwork.player:CharacterScreenAdd(target, v);
							end
							
							Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..target:SteamName().."'s character \""..character.name.."\"!");
							
							return;
						end
					end
				end
			end
		end
		
		local charactersTable = config.Get("mysql_characters_table"):Get();
		local schemaFolder = Clockwork.kernel:GetSchemaFolder()
		local charName = arguments[1];
		
		local queryObj = Clockwork.database:Select(charactersTable);
			queryObj:Callback(function(result)
				if (Clockwork.database:IsResult(result)) then
					for k2, v2 in pairs(result) do
						if v2._Data then
							local data = Clockwork.player:ConvertDataString(nil, v2._Data);
							
							if data and data["permakilled"] then
								data["permakilled"] = false;
								
								local queryObj = Clockwork.database:Update(charactersTable);
									queryObj:Update("_Data", util.TableToJSON(data))
									queryObj:Where("_Name", charName);
								queryObj:Execute();
								
								Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..tostring(v2._SteamName).."'s character '"..tostring(v2._Name).."' from the database.");
							end
						end
					end
				else
					Schema:EasyText(player, "grey", arguments[1].." is not a valid character in the database!");
				end;
			end);
			
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Where("_Name", charName);
		queryObj:Execute()
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnPermakillStay");
	COMMAND.tip = "Un-permanently kill a character and teleport them to where they died.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyUnPermakillStay", "UnPermakillStay"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (target:GetCharacterData("permakilled")) then
				local targetPos = target:GetPos();
				
				Schema:UnPermaKillPlayer(target, target:GetRagdollEntity());
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..target:SteamName().."'s character \""..target:Name().."\"!");
				
				target:SetPos(targetPos + Vector(0, 0, 16));
				
				return;
			else
				Schema:EasyText(player, "darkgrey", "This character is not permanently killed!");
				
				return;
			end;
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character that can be respawned!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnPermakillAll");
	COMMAND.tip = "Unpermakill all players on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyUnPermakillAll", "UnPermakillAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if (v:GetCharacterData("permakilled")) then
				Schema:UnPermaKillPlayer(v, v:GetRagdollEntity());
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has unpermakilled all players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("EventLocal");
	COMMAND.tip = "Send an event to characters around you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.isChatCommand = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.chatBox:AddInRadius(player, "localevent",  table.concat(arguments, " "), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 4);
	end;
COMMAND:Register();

local zoneEventClasses = {
	["gore"] = {"gore", "gore_tree", "gore_hallway", "supragore"},
	["wasteland"] = {"wasteland", "suprawasteland"},
	["tower"] = {"tower"},
	["hell"] = {"hell", "manor", "suprahell"},
	["caves"] = {"caves"},
};

local COMMAND = Clockwork.command:New("EventZone");
	COMMAND.tip = "Send an event to characters in a specific suprazone (suprawasteland will play for both wasteland and tower for example, or suprahell and supragore) or zone (i.e. wasteland, tower, caves, hell, gore).";
	COMMAND.text = "<string Zone> <string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local valid_zones = {};
		local zone = string.lower(arguments[1]);
		
		table.insert(valid_zones, zones.cwDefaultZone.uniqueID);
		
		for k, v in pairs(zones:GetAll()) do
			table.insert(valid_zones, k);
		end
		
		for k, v in pairs(zones.supraZones) do
			table.insert(valid_zones, k);
		end
		
		local eventClass = "localevent";
		
		for k, v in pairs(zoneEventClasses) do
			if table.HasValue(v, zone) then
				eventClass = k.."event";
				
				break;
			end
		end
		
		if table.HasValue(valid_zones, zone) then
			if zones:IsSupraZone(zone) then
				for _, v in _player.Iterator() do
					if v:HasInitialized() then
						local vSupraZone = zones:GetPlayerSupraZone(v);
							
						if vSupraZone == zone then
							Clockwork.chatBox:Add(v, nil, eventClass,  table.concat(arguments, " ", 2));
						end
					end
				end
			else
				for _, v in _player.Iterator() do
					if v:HasInitialized() then
						local vZone = v:GetCharacterData("LastZone", "wasteland");
							
						if vZone == zone then
							Clockwork.chatBox:Add(v, nil, eventClass,  table.concat(arguments, " ", 2));
						end
					end
				end
			end
		else
			Schema:EasyText(player, "grey", "You must specify a valid zone!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlaySoundZone");
	COMMAND.tip = "Play a sound to all players in a specific suprazone (suprawasteland will play for both wasteland and tower for example, or suprahell and supragore) or zone (i.e. wasteland, tower, caves, hell, gore).";
	COMMAND.text = "<string Zone> <string SoundName> [int Level] [int Pitch]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local valid_zones = {};
		local zone = string.lower(arguments[1]);
		
		table.insert(valid_zones, zones.cwDefaultZone.uniqueID);
		
		for k, v in pairs(zones:GetAll()) do
			table.insert(valid_zones, k);
		end
		
		for k, v in pairs(zones.supraZones) do
			table.insert(valid_zones, k);
		end
		
		if (arguments[2]) then
			local info = {name = arguments[2], pitch = 100, level = 75};
			local translate = {[3] = "level", [4] = "pitch"};
			local startingIndex = 4;
			
			if table.HasValue(valid_zones, zone) then
				for i = 3, 4 do
					if (tonumber(arguments[i]) == nil) then
						if (string.len(tostring(arguments[i])) > 0) then
							startingIndex = startingIndex - 1;
						end;
					else
						info[translate[i]] = tonumber(arguments[i]);
					end;
				end;
				
				local plyTab = {};
				
				if zones:IsSupraZone(zone) then
					for i, v in ipairs(_player.GetAll()) do
						if v:HasInitialized() then
							local vSupraZone = zones:GetPlayerSupraZone(v);
							
							if vSupraZone == zone then
								table.insert(plyTab, v);
							end
						end
					end;
				else
					for i, v in ipairs(_player.GetAll()) do
						if v:HasInitialized() then
							local vZone = v:GetCharacterData("LastZone", "wasteland");
							
							if vZone == zone then
								table.insert(plyTab, v);
							end
						end
					end;
				end;
				
				netstream.Start(plyTab, "EmitSound", info);
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has played the sound sound \""..arguments[2].."\" in zone \""..zone.."\".");
			else
				Schema:EasyText(player, "grey", "You must specify a valid zone!");
			end
		else
			Schema:EasyText(player, "grey", "You must specify a valid sound!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StopSoundZone");
	COMMAND.tip = "Stop all sounds for all players in a specified zone.";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local valid_zones = {};
		local zone = string.lower(arguments[1]);
		
		table.insert(valid_zones, zones.cwDefaultZone.uniqueID);
		
		for k, v in pairs(zones:GetAll()) do
			table.insert(valid_zones, k);
		end
		
		for k, v in pairs(zones.supraZones) do
			table.insert(valid_zones, k);
		end
		
		if table.HasValue(valid_zones, zone) then
			if zones:IsSupraZone(zone) then
				for _, v in _player.Iterator() do
					if v:HasInitialized() then
						local vSupraZone = zones:GetPlayerSupraZone(v);
						
						if vSupraZone == zone then
							v:SendLua([[RunConsoleCommand("stopsound")]]);
						end
					end
				end;
			else
				for _, v in _player.Iterator() do
					if v:HasInitialized() then
						local vZone = v:GetCharacterData("LastZone", "wasteland");
						
						if vZone == zone then
							v:SendLua([[RunConsoleCommand("stopsound")]]);
						end
					end
				end;
			end;
		else
			Schema:EasyText(player, "grey", "You must specify a valid zone!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyStrip");
	COMMAND.tip = "Strip all of a player's weapons.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			target:StripWeapons();
			Schema:EasyText(player, "cornflowerblue", "You stripped all of "..target:Name().."'s weapons.");
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyStripAll");
	COMMAND.tip = "Strip all players' weapons.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			if IsValid(v) then
				v:StripWeapons();
			end
		end;
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has stripped the weapons of all players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGiveWeapon");
	COMMAND.tip = "Give a player a specificed weapon.";
	COMMAND.text = "<string Name> <string Class Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target and arguments[2] and istable(weapons.Get(arguments[2]))) then
			target:Give(arguments[2]);
			Schema:EasyText(player, "cornflowerblue", "You gave "..target:Name().." the "..arguments[2].." weapon.");
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGiveWeaponAll");
	COMMAND.tip = "Strip all players' weapons.";
	COMMAND.text = "<string Class Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and istable(weapons.Get(arguments[1])) then
			for _, v in _player.Iterator() do
				if IsValid(v) then
					v:Give(arguments[1]);
				end
			end;
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has given the weapon "..arguments[1].." to all players.", nil);
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid weapon!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("BlowWarhorn");
	COMMAND.tip = "Blow a warhorn in your current area (wasteland/tower or gore forest).";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.faction = "Goreic Warrior";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local curTime = CurTime();
	
		if !player:IsAdmin() and !(player:GetFaction() == "Goreic Warrior" and Schema:GetRankTier("Goreic Warrior", player:GetCharacterData("rank", 1)) >= 5) then
			Schema:EasyText(player, "peru", "Only the Gore King may use this command!");
		
			return false;
		end
		
		if (!player.blowWarhornCooldown or curTime > player.blowWarhornCooldown) then
			player.blowWarhornCooldown = curTime + 600;
		
			-- Prevent the bell sound and warhorn sound from playing over eachother.
			if cwDayNight and cwDayNight.currentCycle == "day" then
				cwDayNight:ModifyCycleTimeLeft(30);
			end
			
			local lastZone = player:GetCharacterData("LastZone");
			
			if lastZone == "wasteland" or lastZone == "tower" or lastZone == "hotspring" then
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() then
						local vLastZone = v:GetCharacterData("LastZone");
						
						if vLastZone == "wasteland" or vLastZone == "tower" or vLastZone == "hotspring" then
							if v:GetFaction() == "Goreic Warrior" then
								if cwStamina then
									v:HandleStamina(25);
								end
								
								v.lastWarCry = nil;
							end
							
							Clockwork.chatBox:Add(v, nil, "event", "The ground quakes as the terrifying sound of a Goreic Warfighter horn pierces the sky.");
							netstream.Start(v, "GoreWarhorn");
						end
					end
				end
			elseif lastZone == "gore" or lastZone == "gore_hallway" or lastZone == "gore_tree" then
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() then
						local vLastZone = v:GetCharacterData("LastZone");
						
						if vLastZone == "gore" or vLastZone == "gore_hallway" or vLastZone == "gore_tree" then
							if v:GetFaction() == "Goreic Warrior" then
								if cwStamina then
									v:HandleStamina(25);
								end
								
								v.lastWarCry = nil;
							end
						
							Clockwork.chatBox:Add(v, nil, "event", "The ground quakes as the sound of a Goreic Warfighter horn pierces the sky.");
							netstream.Start(v, "GoreWarhorn");
						end
					end
				end
			elseif lastZone == "hell" or LastZone == "manor" then
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() then
						local vLastZone = v:GetCharacterData("LastZone");
						
						if vLastZone == "hell" or vLastZone == "manor" then
							if v:GetFaction() == "Goreic Warrior" then
								if cwStamina then
									v:HandleStamina(25);
								end
								
								v.lastWarCry = nil;
							end
						
							Clockwork.chatBox:Add(v, nil, "event", "The cacophony of tormented screams and suffering in Hell is temporarily broken by the overpowering sound of a Goreic Warfighter horn.");
							netstream.Start(v, "GoreWarhorn");
						end
					end
				end
			else
				Schema:EasyText(player, "peru", "This command cannot be used in this area!");
			end
		else
			Schema:EasyText(player, "firebrick", "You cannot blow the gore warhorn again for another "..math.ceil(player.blowWarhornCooldown - curTime).." seconds!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GoreicHornSummonAll");
	COMMAND.tip = "Summon all Goreic warriors to the village center using the Goreic Gathering Horn. Utilize discretion before doing so.";

	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if entity:GetClass() == "cw_gorevillagehorn" then
				local faction = player:GetFaction();
				local subfaction = player:GetSubfaction();
				
				if faction == "Goreic Warrior" then
					local curTime = CurTime();
				
					if player.nextWarHorn and player.nextWarHorn > curTime then
						Schema:EasyText(player, "chocolate", "You must wait another "..-math.ceil(curTime - player.nextWarHorn).." seconds before blowing the gathering horn again!");
						
						return false;
					end
					
					player.nextWarHorn = curTime + 30;
					
					for _, v in _player.Iterator() do
						local lastZone = v:GetCharacterData("LastZone");
						if (lastZone == "gore" or lastZone == "gore_tree" or lastZone == "gore_hallway") then
							if v:GetFaction() == "Goreic Warrior" then
								Clockwork.chatBox:Add(v, nil, "event", "A familiar call of "..subfaction.." echoes throughout the forest. All Goreic warriors have been summoned to the village center.");
							else
								Clockwork.chatBox:Add(v, nil, "event", "The sound of a warhorn echoes throughout the forest, but you do not know its meaning!");
							end
							
							v:SendLua([[Clockwork.Client:EmitSound("warhorns/summonhorn.mp3", 60, 100)]]);
							util.ScreenShake(v:GetPos(), 1, 5, 10, 1024);
						end
					end
				else
					Schema:EasyText(player, "firebrick", "You are not the correct faction to blow the Goreic Gathering Horn!");
				end
			else
				Schema:EasyText(player, "firebrick", "You must be looking at a Goreic Gathering Horn to do this!");
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GoreicHornSummonRaid");
	COMMAND.tip = "Summon all Goreic warriors to the village center to organize for a raid.";

	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if entity:GetClass() == "cw_gorevillagehorn" then
				local faction = player:GetFaction();
				local subfaction = player:GetSubfaction();
				
				if faction == "Goreic Warrior" then
					local curTime = CurTime();
				
					if player.nextWarHorn and player.nextWarHorn > curTime then
						Schema:EasyText(player, "chocolate", "You must wait another "..-math.ceil(curTime - player.nextWarHorn).." seconds before blowing the gathering horn again!");
						
						return false;
					end
					
					player.nextWarHorn = curTime + 30;
				
					for _, v in _player.Iterator() do
						local lastZone = v:GetCharacterData("LastZone");
						if (lastZone == "gore" or lastZone == "gore_tree" or lastZone == "gore_hallway") then
							if v:GetFaction() == "Goreic Warrior" then
								Clockwork.chatBox:Add(v, nil, "event", "A familiar call of "..subfaction.." echoes throughout the forest. A raiding party has been requested to organize at the village center.");
							else
								Clockwork.chatBox:Add(v, nil, "event", "The sound of a warhorn echoes throughout the forest, but you do not know its meaning!");
							end
							
							v:SendLua([[Clockwork.Client:EmitSound("warhorns/raidhorn.mp3", 60, 100)]]);
							util.ScreenShake(v:GetPos(), 1, 5, 11, 1024);
						end
					end
				else
					Schema:EasyText(player, "firebrick", "You are not the correct faction to blow the Goreic Gathering Horn!");
				end
			else
				Schema:EasyText(player, "firebrick", "You must be looking at a Goreic Gathering Horn to do this!");
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CallCongregation");
	COMMAND.tip = "Call a congregation to the Tower of Light church.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		-- Prevent the bells from playing over eachother.
		if cwDayNight and cwDayNight.currentCycle == "day" then
			cwDayNight:ModifyCycleTimeLeft(120);
		end
		
		local close_players = {};
		local far_players = {};
		
		for _, v in _player.Iterator() do
			if IsValid(v) and v:HasInitialized() then
				local lastZone = v:GetCharacterData("LastZone");
				
				if lastZone == "wasteland" then
					table.insert(far_players, v);
					Clockwork.chatBox:Add(v, nil, "event", "The church bell tolls and the holy word is spread: A congregation has been called, and all beings high and lowly are required to attend... or else risk being marked for corpsing.");
					netstream.Start(v, "FadeAmbientMusic");
				elseif lastZone == "tower" or lastZone == "theater" or lastZone == "hillbunker" then
					table.insert(close_players, v);
					Clockwork.chatBox:Add(v, nil, "event", "The church bell tolls and the holy word is spread: A congregation has been called, and all beings high and lowly are required to attend... or else risk being marked for corpsing.");
					netstream.Start(v, "FadeAmbientMusic");
				end
			end
		end
		
		netstream.Start(close_players, "EmitSound", {name = "cosmicrupture/bellsclose.wav", pitch = 90, level = 60});
		netstream.Start(far_players, "EmitSound", {name = "cosmicrupture/bellsdistant.wav", pitch = 100, level = 75});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FuckerJoeAlarm");
	COMMAND.tip = "Sound the Fucker Joe alarm. Fucker Joe is coming!!!! This disables charswapping for alive non-admins. Re-enable by using /ToggleCharSwapping.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		-- Prevent the bell sound and alarm sound from playing over eachother.
		if cwDayNight and cwDayNight.currentCycle == "day" then
			cwDayNight:ModifyCycleTimeLeft(120);
		end
		
		for _, v in _player.Iterator() do
			if IsValid(v) and v:HasInitialized() then
				local lastZone = v:GetCharacterData("LastZone");
				
				if lastZone == "wasteland" or lastZone == "tower" or lastZone == "theater" then
					Clockwork.chatBox:Add(v, nil, "event", "Is it...? No, it cannot be... The alarms sound, for Fucker Joe comes...");
					netstream.Start(v, "FadeAmbientMusic");
					netstream.Start(v, "EmitSound", {name = "warhorns/fuckerjoealarm.mp3", pitch = 90, level = 60});
				end
			end
		end
		
		Schema.fuckerJoeActive = true;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Proclaim");
	COMMAND.tip = "Proclaim your words with the attention they deserve if you are sufficiently noble stature.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;
	COMMAND.important = true;
	COMMAND.isChatCommand = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		if hook.Run("PlayerCanSayIC", player, text) then 
			if (Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) >= 3) or faction == "Holy Hierarchy" or player:IsAdmin() or Clockwork.player:HasFlags(player, "P") then
				Clockwork.chatBox:SetMultiplier(1.35);
				
				if player.victim and IsValid(player.victim) then
					Clockwork.chatBox:AddInRadius(player.victim, "proclaim", text, player.victim:GetPos(), config.Get("talk_radius"):Get() * 4);
					
					if player.victim:GetModel() == "models/begotten/satanists/darklanderimmortal.mdl" then
						player.victim:EmitSound("piggysqueals/yell/wretch_tunnels_amb_alert_0"..math.random(1, 3)..".ogg", 90, math.random(95, 110))
					elseif player.victim:GetSubfaith() == "Voltism" then
						if cwBeliefs and (player.victim:HasBelief("the_storm") or player.victim:HasBelief("the_paradox_riddle_equation")) then
							if !Clockwork.player:HasFlags(player.victim, "T") then
								player.victim:EmitSound(voltistSounds[math.random(1, #voltistSounds)], 90, 150);
							end
						end
					end
					
					if cwZombies then
						cwZombies:GiveAwayPosition(player.victim, 900);
					end
				elseif player.possessor and IsValid(player.possessor) then
					-- do nothing lol
				else
					Clockwork.chatBox:AddInRadius(player, "proclaim", text, player:GetPos(), config.Get("talk_radius"):Get() * 4);
					
					if player:GetModel() == "models/begotten/satanists/darklanderimmortal.mdl" then
						player:EmitSound("piggysqueals/yell/wretch_tunnels_amb_alert_0"..math.random(1, 3)..".ogg", 90, math.random(95, 110))
					elseif player:GetSubfaith() == "Voltism" then
						if cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
							if !Clockwork.player:HasFlags(player, "T") then
								player:EmitSound(voltistSounds[math.random(1, #voltistSounds)], 90, 150);
							end
						end
					end
					
					if cwZombies then
						cwZombies:GiveAwayPosition(player, 900);
					end
				end
				
				--Clockwork.chatBox:AddInRadius(player, "proclaim", arguments[1], player:GetPos(), config.Get("talk_radius"):Get() * 4);
			else
				Schema:EasyText(player, "peru", "You are not important enough to do this!");
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RavenSpeak");
COMMAND.tip = "Speak through your familiar, a Raven, to another Goreic Warrior.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;
COMMAND.alias = {"RS"};
COMMAND.isChatCommand = true;
COMMAND.subfaction = "Clan Crast";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" then
			local targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
			
			if targetFaction == "Goreic Warrior" then
				if player:HasBelief("watchful_raven") then
					local message = "\""..table.concat(arguments, " ", 2).."\"";

					Clockwork.chatBox:Add(player, player, "ravenspeak", message);
					Clockwork.chatBox:Add(target, player, "ravenspeak", message);
					player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
					target:SendLua([[Clockwork.Client:EmitSound("crow"..math.random(3, 4)..".wav", 90, 100)]]);
					
					netstream.Start(player, "TriggerCrows");
					netstream.Start(target, "TriggerCrows");
					
					target.lastRavenSpeaker = player;
				else
					Schema:EasyText(player, "firebrick", "You must have the 'Watchful is the Raven' belief to do this!");
				end
			else
				Schema:EasyText(player, "firebrick", target:Name().." is not a Goreic Warrior!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct subfaction to do this!");
		end
	else
		Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("RavenSpeakClan");
	COMMAND.tip = "Speak through your familiar, a Raven, to other members of Clan Crast.";
	COMMAND.text = "<string Message>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.alias = {"RSC"};
	COMMAND.isChatCommand = true;
	COMMAND.subfaction = "Clan Crast";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" then
			if player:HasBelief("watchful_raven") then
				local message = "\""..table.concat(arguments, " ", 1).."\"";
				
				player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
				netstream.Start(player, "TriggerCrows");

				for _, v in _player.Iterator() do
					if v:HasInitialized() and v:Alive() and (v:GetSubfaction() == "Clan Crast" or Clockwork.player:HasFlags(v, "L")) then
						Clockwork.chatBox:Add(v, player, "ravenspeakclan", message);
						v:SendLua([[Clockwork.Client:EmitSound("crow"..math.random(3, 4)..".wav", 90, 100)]]);
						netstream.Start(v, "TriggerCrows");
					end;
				end;
			else
				Schema:EasyText(player, "firebrick", "You must have the 'Watchful is the Raven' belief to do this!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct subfaction to do this!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RavenSpeakFaction");
	COMMAND.tip = "Speak through your familiar, a Raven, to all members of the Goreic Warriors.";
	--COMMAND.tip = "Speak through your familiar, a Raven, to all members of the Goreic Warriors. You must be near the Great Tree in order to do this.";
	COMMAND.text = "<string Message>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.alias = {"RSF"};
	COMMAND.isChatCommand = true;
	COMMAND.faction = "Goreic Warrior";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local isKing = (player:GetFaction() == "Goreic Warrior" and Schema:GetRankTier("Goreic Warrior", player:GetCharacterData("rank", 1)) >= 5);
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" or isKing or player:IsAdmin() then
			if player:HasBelief("watchful_raven") or isKing or player:IsAdmin() then
				--if player:GetPos():WithinAABox(Vector(11622, -6836, 12500), Vector(8744, -10586, 11180)) then
					local message = "\""..table.concat(arguments, " ", 1).."\"";
					
					player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
					netstream.Start(player, "TriggerCrows");

					for _, v in _player.Iterator() do
						if v:HasInitialized() and v:Alive() then
							local vFaction = v:GetNetVar("kinisgerOverride") or v:GetFaction();
							local vLastZone = v:GetCharacterData("LastZone");
							
							if (vFaction == "Goreic Warrior" and vLastZone ~= "hell" and vLastZone ~= "manor") or Clockwork.player:HasFlags(v, "L") then
								Clockwork.chatBox:Add(v, player, "ravenspeakfaction", message);
								v:SendLua([[Clockwork.Client:EmitSound("crow"..math.random(3, 4)..".wav", 90, 100)]]);
								netstream.Start(v, "TriggerCrows");
							end;
						end;
					end;
				--else
					--Schema:EasyText(player, "firebrick", "You must be near the Great Tree to send more ravens!");
				--end
			else
				Schema:EasyText(player, "firebrick", "You must have the 'Watchful is the Raven' belief to do this!");
			end
		else
			Schema:EasyText(player, "firebrick", "You are not the correct subfaction to do this!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RavenReply");
COMMAND.tip = "Speak to the Ravens to deliver a message back to the Clan Crast member who last spoke to you directly.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"RR"};
COMMAND.isChatCommand = true;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if IsValid(player.lastRavenSpeaker) then
		local message = "\""..table.concat(arguments, " ", 1).."\"";

		Clockwork.chatBox:Add(player, player, "ravenspeakreply", message);
		Clockwork.chatBox:Add(player.lastRavenSpeaker, player, "ravenspeakreply", message);
		
		player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
		player.lastRavenSpeaker:SendLua([[Clockwork.Client:EmitSound("crow"..math.random(3, 4)..".wav", 90, 100)]]);
		
		netstream.Start(player, "TriggerCrows");
		netstream.Start(player.lastRavenSpeaker, "TriggerCrows");
	else
		Schema:EasyText(player, "firebrick", "There is no ravenspeak to reply to!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Speaker");
	COMMAND.tip = "Announce something over the tower's PA system.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;
	COMMAND.access = "s";
	COMMAND.isChatCommand = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and (player:IsAdmin() or (player:GetSubfaction() == "Ministry" or player:GetSubfaction() == "Low Ministry")) then
			Schema:SpeakerTalk(player, table.concat(arguments, " "));
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpeakerSound");
	COMMAND.tip = "Emit a sound from all speaker entities in the tower.";
	COMMAND.text = "<string Sound> [int Level] [int Pitch]";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and player:IsAdmin() then
			Schema:EmitSoundFromSpeakersDSP(arguments[1], arguments[2] or 75, arguments[3] or 100);
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpeakerSoundStop");
	COMMAND.tip = "Stop all currently playing speaker sounds.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		netstream.Start(nil, "SpeakerStop");
	end;
COMMAND:Register();

if (SERVER) then
	function Schema:EmitSoundFromSpeakersDSP(sound, level, pitch)
		local listeners = nil --{};
		--[[for _, v in _player.Iterator() do
			if (Schema:InSpeakerZone(v)) then
				listeners[#listeners + 1] = v;
			end;
		end;--]]
		
		for k, v in pairs (Schema:GetPopeSpeakers()) do
			if (IsValid(v)) then
				v:SetNWBool("PopeSpeaker", true);
			end;
		end;
		
		netstream.Start(listeners, "DSPSpeaker", sound, level, pitch);
	end;
else
	netstream.Hook("SpeakerStop", function()
		for k, v in pairs (ents.GetAll()) do
			if (v:GetNWBool("PopeSpeaker", false) == true) then
				if (v.CurSound and v.CurSound:IsPlaying()) then
					v.CurSound:Stop();
					v.CurSound = nil;
				end;
				
				v.CurSound = nil;
			end;
		end;
	end);
	
	netstream.Hook("DSPSpeaker", function(sound, level, pitch)
		for k, v in pairs (ents.GetAll()) do
			if (v:GetNWBool("PopeSpeaker", false) == true) then
				if (v.CurSound and v.CurSound:IsPlaying()) then
					v.CurSound:Stop();
					v.CurSound = nil;
				end;
				
				v.CurSound = CreateSound(v, sound)
				v.CurSound:SetDSP(57)
				v.CurSound:PlayEx(level * 0.01, pitch);
			end;
		end;
	end);
end;

local COMMAND = Clockwork.command:New("ProclaimMe");
	COMMAND.tip = "Proclaim your gestures with the attention they deserve if you are sufficiently noble stature.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;
	COMMAND.alias = {"MeProclaim"};
	COMMAND.important = true;
	COMMAND.isChatCommand = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		local text = table.concat(arguments, " ");
		
		if !text or (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
	
		if hook.Run("PlayerCanSayIC", player, text) then 
			if Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) >= 3 or faction == "Holy Hierarchy" or player:IsAdmin() or Clockwork.player:HasFlags(player, "P") then
				Clockwork.chatBox:SetMultiplier(1.35);
				
				if player.victim and IsValid(player.victim) then
					Clockwork.chatBox:AddInRadius(player.victim, "meproclaim", text, player.victim:GetPos(), config.Get("talk_radius"):Get() * 4);
				elseif player.possessor and IsValid(player.possessor) then
					-- do nothing lol
				else
					Clockwork.chatBox:AddInRadius(player, "meproclaim", text, player:GetPos(), config.Get("talk_radius"):Get() * 4);
				end
				
				--Clockwork.chatBox:AddInRadius(player, "meproclaim", text, player:GetPos(), config.Get("talk_radius"):Get() * 4);
			else
				Schema:EasyText(player, "peru", "You are not important enough to do this!");
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpeakerIt");
	COMMAND.tip = "Describe an action happening over the tower's PA system.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;
	COMMAND.access = "s";
	COMMAND.isChatCommand = true;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and player:IsAdmin() then
			Schema:SpeakerPerform(player, table.concat(arguments, " "));
		end
	end;
COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("CharSetCustomClass");
	COMMAND.tip = "Set a character's custom class.";
	COMMAND.text = "<string Name> <string Class>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			target:SetCharacterData("customclass", arguments[2]);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." set "..target:Name().."'s custom class to "..arguments[2]..".")
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharTakeCustomClass");
	COMMAND.tip = "Take a character's custom class.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			target:SetCharacterData("customclass", nil);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." took "..target:Name().."'s custom class.")
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("InvTie");
	COMMAND.tip = "Use bindings from your inventory to restrain a character that is looking away from you.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"InvZipTie", "InvBind", "InvRestrain"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local itemTable = player:FindItemByID("bindings");
		
		if (!itemTable) then
			Schema:EasyText(player, "chocolate", "You have nothing to tie with!");
			
			return;
		end;

		Clockwork.player:InventoryAction(player, itemTable, "use");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ForceTie");
	COMMAND.tip = "Force tie a player.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyForceTie", "CharForceTie"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			Schema:TiePlayer(target, true, nil);
			Schema:EasyText(player, "cornflowerblue", "You have tied "..target:Name().."!");
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ForceUntie");
	COMMAND.tip = "Force untie a player.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyForceUntie", "CharForceUntie"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if target:GetNetVar("tied") ~= 1 then
				Schema:EasyText(player, "cornflowerblue", target:Name().." is not tied!");
			
				return;
			end
			
			if target.possessor and target:GetNetVar("tied") != 0 then
				Clockwork.chatBox:AddInTargetRadius(target, "me", "'s bindings suddenly drop to the ground as they are removed by some unseen force!", target:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			end
		
			Schema:TiePlayer(target, false, nil);
			Schema:EasyText(player, "cornflowerblue", "You have untied "..target:Name().."!");
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveAllBelongings");
	COMMAND.tip = "Clear all belongings entities on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"ClearBelongings", "RemoveBelongings"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local items_removed = 0;
		
		for k, v in pairs (ents.FindByClass("cw_belongings")) do
			items_removed = items_removed + 1;
			v:Remove();
		end;
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all belongings entities on the map for a total of "..tostring(items_removed).." entities.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveAllItems");
	COMMAND.tip = "Clear all non-decoy items on the map. Optional arguments for deleting items: 1 - Item Spawner Items | 2 - Non-Item Spawner Items | 3 - Decoy Items.";
	COMMAND.access = "s";
	COMMAND.alias = {"ClearItems", "RemoveItems"};
	COMMAND.optionalArguments = 1;
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local items_removed = 0;
		local selection = arguments[1];
		
		if selection and (selection == "1" or selection == "2" or selection == "3") then
			for k, v in pairs (ents.FindByClass("cw_item")) do
				if selection == "1" and v.lifeTime then
					items_removed = items_removed + 1;
					v:Remove();
				elseif selection == "2" and not v.lifeTime and not v.IsTrapItem then
					items_removed = items_removed + 1;
					v:Remove();
				elseif selection == "3" and v.IsTrapItem then
					items_removed = items_removed + 1;
					v:Remove();
				end
			end;
			
			if selection == "1" then
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all item spawned items on the map for a total of "..tostring(items_removed).." items.", nil);
			elseif selection == "2" then
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all non-item spawned items on the map for a total of "..tostring(items_removed).." items.", nil);
			elseif selection == "3" then
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all decoy items on the map for a total of "..tostring(items_removed).." items.", nil);
			end
		else
			for k, v in pairs (ents.FindByClass("cw_item")) do
				if !v.IsTrapItem then
					items_removed = items_removed + 1;
					v:Remove();
				end
			end
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all non-decoy items on the map for a total of "..tostring(items_removed).." items.", nil);
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveItemsRadius");
	COMMAND.tip = "Clear all items in a specified or 512 unit radius of yourself.";
	COMMAND.text = "<int Radius>";
	COMMAND.access = "s";
	COMMAND.alias = {"ClearItemsRadius", "RemoveItemsInRadius"};
	COMMAND.arguments = 1;
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local items_removed = 0;
		local radius = 512;
		
		if arguments then
			radius = arguments[1] or 512;
		end
		
		for k, v in pairs (ents.FindInSphere(player:GetEyeTrace().HitPos, radius)) do
			if (v:GetClass() == "cw_item") then
				items_removed = items_removed + 1;
				v:Remove();
			end;
		end;
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all items in a 512 unit radius of themselves for a total of "..tostring(items_removed).." items.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveAllRagdolls");
	COMMAND.tip = "Clear all items on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"ClearRagdolls", "RemoveRagdolls"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local ragdolls_removed = 0;
		
		for k, v in pairs (ents.FindByClass("prop_ragdoll")) do
			if Clockwork.entity:IsPlayerRagdoll(v) then
				local player = Clockwork.entity:GetPlayer(v);
				
				if not player:Alive() then
					ragdolls_removed = ragdolls_removed + 1;
					v:Remove();
				end
			else
				ragdolls_removed = ragdolls_removed + 1;
				v:Remove();
			end
		end;
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has removed all ragdolls on the map for a total of "..tostring(ragdolls_removed).." ragdolls.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyHealFull");
	COMMAND.tip = "Clear all of a player's injuries and set their HP, limb HP, blood, hunger, thirst, corruption, and sanity to max.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"HealFull", "CharHealFull"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			target = player;
		end;
		
		local name = target:Name();
		
		if (target == player) then
			name = "themself";
		end;
		
		--local max_poise = target:GetMaxPoise();
		local max_sanity = 100;
		local max_stability = target:GetMaxStability();
		local max_stamina = target:GetMaxStamina();
		
		if target:HasTrait("insane") then
			max_sanity = 40;
		end

		target:Extinguish();
		target:ResetInjuries();
		target:TakeAllDiseases();
		target:SetHealth(target:GetMaxHealth() or 100);
		target:SetNeed("thirst", 0);
		target:SetNeed("hunger", 0);
		target:SetNeed("corruption", 0);
		target:SetNeed("sleep", 0);
		target:SetNetVar("sanity", max_sanity);
		target:SetCharacterData("sanity", max_sanity);
		target:SetCharacterData("Stamina", max_stamina);
		target:SetNWInt("Stamina", max_stamina);
		target:SetCharacterData("stability", max_stability);
		target:SetNWInt("stability", max_stability);
		--target:SetCharacterData("meleeStamina", max_poise);
		--target:SetNWInt("meleeStamina", max_poise);
		target:SetLocalVar("freeze", 0);
		target:SetBloodLevel(5000);
		target:StopAllBleeding();
		Clockwork.limb:HealBody(target, 100);
		Clockwork.player:SetAction(target, "die", false);
		Clockwork.player:SetAction(target, "die_bleedout", false);
		
		if target:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
			Clockwork.player:SetRagdollState(target, RAGDOLL_FALLENOVER);
		end
		
		hook.Run("PlayerHealedFull", target);
		
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has fully healed "..name..".");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyHealFullAll");
	COMMAND.tip = "Clear every player on the server's injuries and set their HP, limb HP, blood, hunger, thirst, corruption, and sanity to max.";
	COMMAND.text = "[bool AffectDuelists]";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"HealFullAll", "CharHealFullAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local affect_duelists = false;
		
		if arguments and arguments[1] and tobool(arguments[1]) == true then
			affect_duelists = true;
		end
	
		for _, v in _player.Iterator() do
			if IsValid(v) and v:HasInitialized() and v:Alive() then
				if !v.opponent or (v.opponent and affect_duelists) then
					--local max_poise = v:GetMaxPoise();
					local max_sanity = 100;
					local max_stability = v:GetMaxStability();
					local max_stamina = v:GetMaxStamina();
					
					if v:HasTrait("insane") then
						max_sanity = 40;
					end
					
					v:Extinguish();
					v:ResetInjuries();
					v:TakeAllDiseases();
					v:SetHealth(v:GetMaxHealth() or 100);
					v:SetNeed("thirst", 0);
					v:SetNeed("hunger", 0);
					v:SetNeed("corruption", 0);
					v:SetNeed("sleep", 0);
					v:SetNetVar("sanity", max_sanity);
					v:SetCharacterData("sanity", max_sanity);
					v:SetCharacterData("Stamina", max_stamina);
					v:SetNWInt("Stamina", max_stamina);
					v:SetCharacterData("stability", max_stability);
					v:SetNWInt("stability", max_stability);
					--v:SetCharacterData("meleeStamina", max_poise);
					--v:SetNWInt("meleeStamina", max_poise);
					v:SetLocalVar("freeze", 0);
					v:SetBloodLevel(5000);
					v:StopAllBleeding();
					Clockwork.limb:HealBody(v, 100);
					Clockwork.player:SetAction(v, "die", false);
					Clockwork.player:SetAction(v, "die_bleedout", false);
					
					hook.Run("PlayerHealedFull", v);
					
					if v:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
						Clockwork.player:SetRagdollState(v, RAGDOLL_FALLENOVER);
					end
				end;
			end;
		end;
		
		if affect_duelists then
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has fully healed all players on the server, including duelists.");
		else
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has fully healed all players on the server.");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetStability");
COMMAND.tip = "Set a players Stability level.";
COMMAND.text = "<string Name> [number Amount]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local amount = arguments[2];
		local max_stability = target:GetMaxStability();
		
		if (!amount) then
			amount = 0;
		else
			amount = math.Clamp(tonumber(amount), 0, max_stability);
		end;

		target:SetCharacterData("stability", amount);
		target:SetNWInt("stability", amount);

		if (player != target)	then
			Schema:EasyText(player, "cornflowerblue", "You have set "..target:Name().."'s stability to "..amount..".");
		else
			Schema:EasyText(player, "cornflowerblue", "You have set your own stability to "..amount..".");
		end;
	else
		Schema:EasyText(player, "grey", arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetWeaponCondition");
COMMAND.tip = "Set a character's weapon condition. Defaults to 100% condition if no argument is provided.";
COMMAND.text = "<string Name> [number Condition]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"SetWeaponCondition", "PlySetWeaponCondition"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local condition = arguments[2];
		
		if (!condition) then
			condition = 100;
		else
			condition = math.Clamp(tonumber(condition), 0, 100);
		end;

		local activeWeapon = target:GetActiveWeapon()
		
		if activeWeapon:IsValid() then
			local weaponItem = item.GetByWeapon(activeWeapon);
		
			if (weaponItem) then
				weaponItem:SetCondition(condition, true);
				
				for k, v in pairs(player.equipmentSlots) do
					if v:IsTheSameAs(weaponItem) then
						local offhandItem = player.equipmentSlots[k.."Offhand"];
						
						if offhandItem then
							offhandItem:SetCondition(condition, true);
						end
					
						break;
					end
				end

				if (player != target)	then
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set "..target:Name().."'s weapon item condition to "..condition..".");
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own weapon item condition to "..condition..".");
				end;
			else
				Schema:EasyText(player, "firebrick", "["..self.name.."] "..target:Name().." does not have a valid weapon equipped!");
			end
		else
			Schema:EasyText(player, "firebrick", "["..self.name.."] "..target:Name().." does not have a valid weapon!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleAutoTie");
COMMAND.tip = "Toggle the auto-tie system.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if Schema.autoTieEnabled then
		Schema.autoTieEnabled = false;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled the auto-tie system.");
	else
		Schema.autoTieEnabled = true;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled the auto-tie system, all players who spawn will be tied.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("AddNPCSpawn")
	COMMAND.tip = "Add an npc spawn location at your cursor. (Valid types: animal, thrall)"
	COMMAND.text = "<string Category>"
	COMMAND.access = "s"
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Schema:AddNPCSpawn(player:GetEyeTrace().HitPos, arguments[1], player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveNPCSpawn")
	COMMAND.tip = "Remove an npc spawn location at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Distance]"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Schema:RemoveNPCSpawn(player:GetEyeTrace().HitPos, tonumber(arguments[1]) or 64, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("ToggleNPCSpawns");
COMMAND.tip = "Toggle the automatic NPC spawning system.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if Schema.npcSpawnsEnabled ~= false then
		Schema.npcSpawnsEnabled = false;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled automatic NPC spawning.");
	else
		Schema.npcSpawnsEnabled = true;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled automatic NPC spawning.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleHellJaunting");
COMMAND.tip = "Toggle whether helljaunting is enabled.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.faction = "Children of Satan";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isAdmin = player:IsAdmin();
	local isHellBaron = (player:GetFaction() == "Children of Satan" and Schema:GetRankTier("Children of Satan", player:GetCharacterData("rank", 1)) > 3);

	if isAdmin or isHellBaron then
		if !Schema.hellJauntDisabled then
			Schema.hellJauntDisabled = true;
			
			if isHellBaron and !player.cwObserverMode then
				local pronoun = "his";
				
				if player:GetGender() == GENDER_FEMALE then
					pronoun = "her";
				end
			
				for i, v in ipairs(_player.GetAll()) do
					if (v:Alive() and v:GetFaction() == "Children of Satan") then
						v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)]]);
						Clockwork.chatBox:SetMultiplier(1.35);
						Clockwork.chatBox:Add(v, nil, "darkwhisperevent", player:Name().." has arrogantly halted the power of jaunting, thus freeing your mind of cowardly thoughts of routing. Will "..pronoun.." tyranny know no end?!");
					end
				end
			end
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled helljaunting.");
		else
			Schema.hellJauntDisabled = false;
			
			if isHellBaron and !player.cwObserverMode then
				local pronoun = "his";
				
				if player:GetGender() == GENDER_FEMALE then
					pronoun = "her";
				end
			
				for i, v in ipairs(_player.GetAll()) do
					if (v:Alive() and v:GetFaction() == "Children of Satan") then
						v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)]]);
						Clockwork.chatBox:SetMultiplier(1.35);
						Clockwork.chatBox:Add(v, nil, "darkwhisperevent", player:Name().." has benevolently returned your power of jaunting, thus giving you the warm comfort of safe ventures. Praise "..pronoun.." name!");
					end
				end
			end
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled helljaunting.");
		end
	end
end;

COMMAND:Register()

local COMMAND = Clockwork.command:New("ToggleHearMe")
COMMAND.tip = "Toggle whether or not Children of Satan can use the Hear Me ritual, Hell Baron excluded."
COMMAND.flags = CMD_DEFAULT
COMMAND.faction = "Children of Satan"
COMMAND.text = "[bool Include Hell Baron]"
COMMAND.optionalArguments = 1

HEARME_ENABLED = 1
HEARME_ADMINENFORCED = 2
HEARME_INCLUDEHELLBARON = 4

Schema.hearMeFlags = Schema.hearMeFlags or HEARME_ENABLED

function COMMAND:OnRun(player, arguments)
	local isAdmin = player:IsAdmin()
	local isHellBaron = (player:GetFaction() == "Children of Satan" and Schema:GetRankTier("Children of Satan", player:GetCharacterData("rank", 1)) > 3)

	if(!isAdmin and !isHellBaron) then Schema:EasyText(player, "peru", "You are not the Hell Baron.") return end
	if(!isAdmin and bit.band(Schema.hearMeFlags, HEARME_ADMINENFORCED) > 0) then Schema:EasyText(player, "peru", "A higher power has already made this decision for you.") return end
	
	local name = player:Name()

	if(bit.band(Schema.hearMeFlags, HEARME_ENABLED) > 0) then Schema.hearMeFlags = bit.band(Schema.hearMeFlags, bit.bnot(HEARME_ENABLED))
	else Schema.hearMeFlags = bit.bor(Schema.hearMeFlags, HEARME_ENABLED) end

	local hearMeEnabled = bit.band(Schema.hearMeFlags, HEARME_ENABLED) > 0

	if(isAdmin and !hearMeEnabled) then Schema.hearMeFlags = bit.bor(Schema.hearMeFlags, HEARME_ADMINENFORCED)
	elseif(isAdmin) then Schema.hearMeFlags = bit.band(Schema.hearMeFlags, bit.bnot(HEARME_ADMINENFORCED)) end

	if(!hearMeEnabled and arguments[1]) then Schema.hearMeFlags = bit.bor(Schema.hearMeFlags, HEARME_INCLUDEHELLBARON)
	else Schema.hearMeFlags = bit.band(Schema.hearMeFlags, bit.bnot(HEARME_INCLUDEHELLBARON)) end

	local hellBaronIncluded = (bit.band(Schema.hearMeFlags, HEARME_ENABLED) <= 0 and bit.band(Schema.hearMeFlags, HEARME_INCLUDEHELLBARON) > 0)
	Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", name.." has "..(hearMeEnabled and "enabled" or "disabled").." the Hear Me ritual"..(hellBaronIncluded and ", including the Hell Baron." or "."))

	if(!isHellBaron) then return end
	local pronoun = (player:GetGender() == GENDER_FEMALE and "her" or "his")

	local message = (hearMeEnabled and name.." has graciously restored your connection to the Dark Lord, allowing you to perform the Hear Me ritual once again. Praise "..pronoun.." name!" or name.." has selfishly cut off your connection to the Dark Lord, witholding your ability to perform the Hear Me ritual. Will "..pronoun.." tyranny know no end?!")

	for i, v in _player.Iterator() do
		if(!v:Alive() or v:GetFaction() != "Children of Satan") then continue end

		v:ReadSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)

		Clockwork.chatBox:SetMultiplier(1.35)
		Clockwork.chatBox:Add(v, nil, "darkwhisperevent", message)
	
	end

end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ToggleHellTeleporting");
COMMAND.tip = "Toggle whether teleporting to Hell is enabled.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if !Schema.hellTeleportDisabled then
		Schema.hellTeleportDisabled = true;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled teleporting to Hell.");
	else
		Schema.hellTeleportDisabled = false;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled teleporting to Hell.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleTowerSafeZone");
COMMAND.tip = "Toggle the Tower of Light's safe zone status.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if Schema.towerSafeZoneEnabled then
		Schema.towerSafeZoneEnabled = false;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled the Tower of Light safe zone.");
	else
		Schema.towerSafeZoneEnabled = true;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled the Tower of Light safe zone.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleFalloverEnabled");
COMMAND.tip = "Toggle whether /charfallover is enabled for players.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if Schema.falloverDisabled then
		Schema.falloverDisabled = false;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled falling over for players.");
	else
		Schema.falloverDisabled = true;
		Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled falling over for players.");
	end
end;

COMMAND:Register();

local NAME_CASH = Clockwork.option:GetKey("name_cash");
local COMMAND = Clockwork.command:New("CoinslotCollect");
	COMMAND.tip = "Collect from the Coinslot.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		
		if --[[(faction == "Holy Hierarchy" and player:GetSubfaction() == "Minister") or ]]player:IsAdmin() then
			local trace = player:GetEyeTrace();

			if (trace.Entity) then
				local entity = trace.Entity;

				if (entity:GetClass() == "cw_coinslot") then
					if arguments[1] and tonumber(arguments[1]) then
						local cash = math.floor(tonumber(arguments[1]));
						
						if Schema.towerTreasury >= cash and cash > 0 then
							Clockwork.player:GiveCash(player, cash, nil, true);
							Schema:ModifyTowerTreasury(-cash);
							
							Schema:EasyText(Schema:GetAdmins(), color, player:Name().." has collected "..cash.." coin from the treasury.");
							Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has collected "..cash.." coin from the coinslot. The treasury now sits at "..Schema.towerTreasury..".");
							
							return;
						else
							Schema:EasyText(player, "firebrick", "There is not enough coin in the treasury to collect this amount!");
							return;
						end
					end
				end;
			end;
		else
			Schema:EasyText(player, "peru", "You must be of noble stature to collect coin!");
			return;
		end
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to collect coin!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotTax");
	COMMAND.tip = "Set the Tower of Light's tax rate.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		
		if (faction == "Holy Hierarchy" and player:GetSubfaction() == "Minister") or player:IsAdmin() then
			local trace = player:GetEyeTrace();

			if (trace.Entity) then
				local entity = trace.Entity;

				if (entity:GetClass() == "cw_coinslot") then
					if arguments[1] and tonumber(arguments[1]) then
						local taxRate = math.floor(tonumber(arguments[1]));
						
						if taxRate > 0 and taxRate < 100 then
							Schema.towerTax = (taxRate / 100);
							
							Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has set the tax rate in the Tower of Light to "..tostring(taxRate).."%.");
							Schema:EasyText(Schema:GetAdmins(), "gold", player:Name().." has set the tax rate in the Tower of Light to "..tostring(taxRate).."%.");
							
							return;
						else
							Schema:EasyText(player, "firebrick", "This is an invalid tax rate!");
							return;
						end
					end
				end;
			end;
		else
			Schema:EasyText(player, "peru", "You must be of noble stature to set the tax rate!");
			return;
		end
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to set the tax rate!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotDonate");
	COMMAND.tip = "Offer your coin to the Coinslot.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if arguments[1] and tonumber(arguments[1]) then
					local cash = math.floor(tonumber(arguments[1]));
					
					if arguments[2] and player:IsAdmin() then
						Schema:ModifyTowerTreasury(cash);
						
						local color = "green";
						
						if cash < 0 then
							color = "red";
						end
						
						Schema:EasyText(Schema:GetAdmins(), color, player:Name().." has modified the Tower treasury by "..cash.." coin.");
						Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has modified the Tower treasury by "..cash.." coin. The treasury now sits at "..Schema.towerTreasury..".");
					
						return;
					end
						
					if (cash and Clockwork.player:CanAfford(player, cash)) then
						if cash < 1 then
							Schema:EasyText(player, "darkgrey", "You need to enter a positive value to donate coin!");
							return;
						end
						
						Clockwork.player:GiveCash(player, -cash, nil, true);
						Schema:ModifyTowerTreasury(cash);
						
						if cwBeliefs then
							if player:GetFaction() == "Gatekeeper" then
								if player:HasBelief("hard_glazed") then
									if cash >= 2 then
										player:HandleXP(cash / 2);
									end
								elseif player:HasBelief("sol_orthodoxy") then
									if cash >= 4 then
										player:HandleXP(cash / 4);
									end
								end
							elseif player:HasBelief("hard_glazed") then
								if cash >= 2 then
									player:HandleXP(cash / 2);
								end
							end
						end
						
						Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has donated "..cash.." coin to the coinslot. The treasury now sits at "..Schema.towerTreasury..".");
						
						if cash >= 500 then
							Schema:EasyText(Schema:GetAdmins(), "green", player:Name().." has made a large donation to the coinslot: "..cash.." coin.", nil);
						end
						
						entity:EmitSound("ambient/levels/labs/coinslot1.wav");
						return;
					else
						Schema:EasyText(player, "darkgrey", "You do not have enough coin to donate this amount!");
						return;
					end;
				else
					Schema:EasyText(player, "darkgrey", "You need to enter a valid value to donate coin!");
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to donate coin!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FireplaceAddFuel");
	COMMAND.tip = "Add an item to a fireplace as fuel.";
	COMMAND.text = "<string uniqueID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;
	COMMAND.alias = {"CampfireAddFuel"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) and player:GetPos():Distance(trace.Entity:GetPos()) < 256 then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_fireplace") then
				if arguments[1] then
					local itemTable;
					local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
					
					for k, v in pairs(itemList) do
						if v.uniqueID == arguments[1] then
							itemTable = v;
							break;
						end
					end
					
					if (itemTable and itemTable.fireplaceFuel) then
						entity:AddFuel(itemTable);
						player:TakeItem(itemTable);
						return;
					else
						Schema:EasyText(player, "grey", "This is not a valid item to add to the campfire, or you do not have it!");
						return;
					end;
				else
					Schema:EasyText(player, "darkgrey", "You need to enter a valid item uniqueID to add fuel!");
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at a fireplace to add fuel to!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ArchivesAdd");
	COMMAND.tip = "Add a scripture to the Grand Archives.";
	COMMAND.text = "<string uniqueID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_archives") then
				if arguments[1] then
					local itemTable;
					local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
					
					for k, v in pairs (itemList) do
						if v.uniqueID == arguments[1] then
							itemTable = v;
							break;
						end
					end
					
					if (itemTable and itemTable.category == "Scripture") then
						Schema:AddBookTowerArchives(player, itemTable);
						return;
					else
						Schema:EasyText(player, "grey", "This is not a valid item to add to the archives, or you do not have it!");
						return;
					end;
				else
					Schema:EasyText(player, "darkgrey", "You need to enter a valid item uniqueID to donate scriptures!");
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Grand Archives to donate scriptures!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ArchivesTake");
	COMMAND.tip = "Take a scripture from the Grand Archives.";
	COMMAND.text = "<string uniqueID>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_archives") then
				if arguments[1] then
					Schema:TakeBookTowerArchives(player, arguments[1]);
					return;
				else
					Schema:EasyText(player, "darkgrey", "You need to enter a valid item uniqueID to take scriptures!");
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Grand Archives to take scriptures!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("HellJaunt");
	COMMAND.tip = "Return to Hell using dark magic if you are a Child of Satan, although this act will leave you temporarily vulnerable to the influence of demons and will thus incur extreme corruption. Anyone held in your hands will also be teleported. You cannot helljaunt while overencumbered.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.important = true;
	COMMAND.faction = "Children of Satan";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() == "Children of Satan" then
			if player.caughtByCheaple then
				return false;
			end
			
			if player:GetCharacterData("rank") == 10 and !player:GetCharacterData("kinisgerOverride") then -- Aspirants cannot helljaunt.
				Schema:EasyText(player, "peru", "Aspirants cannot helljaunt!");
				
				return false;
			end
		
			if Schema.hellJauntDisabled or (map ~= "rp_begotten3" and map ~= "rp_begotten_redux" and map ~= "rp_district21") then
				Schema:EasyText(player, "peru", "Your connection with Hell appears to be severed and you cannot helljaunt!");
				
				return false;
			end
			
			if player.OverEncumbered then
				Schema:EasyText(player, "peru", "You cannot helljaunt while overencumbered!");
				
				return false;
			end
			
			if player:GetNetVar("Parried") == true then
				Schema:EasyText(player, "peru", "You are too discombobulated to helljaunt right now!");
				
				return false;
			end
			
			if player:GetNWBool("bliz_frozen") then
				Schema:EasyText(player, "peru", "You cannot helljaunt while frozen solid!");
				
				return false;
			end
			
			local action = Clockwork.player:GetAction(player);
			
			if action == "pickupobject" then
				Schema:EasyText(player, "peru", "You cannot helljaunt while in the process of picking up an object!");
				
				return false;
			elseif action == "pickupragdoll" then
				Schema:EasyText(player, "peru", "You cannot helljaunt while in the process of picking up a ragdoll!");
				
				return false;
			end
			
			local holdingEnt = player.cwHoldingEnt;
			
			if IsValid(holdingEnt) and holdingEnt:GetClass() == "prop_ragdoll" then
				local ragdollPlayer = Clockwork.entity:GetPlayer(holdingEnt);
				
				if ragdollPlayer and ragdollPlayer:GetFaction() == "Children of Satan" and ragdollPlayer:Alive() and ragdollPlayer.OverEncumbered then
					Schema:EasyText(player, "peru", "You cannot helljaunt while holding another overencumbered Child of Satan!");
					
					return false;
				end
			end
			
			if not player.opponent and not player:IsRagdolled() and player:GetNetVar("tied") == 0 then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone ~= "hell" and lastZone ~= "manor" then
					local nextTeleport = player:GetCharacterData("nextTeleport", 0);
					
					if nextTeleport <= 0 then
						for _, v in _player.Iterator() do
							if v:HasInitialized() and v:GetNetVar("yellowBanner") == true and v:Alive() then
								if v:GetMoveType() == MOVETYPE_WALK or v:IsRagdolled() or v:InVehicle() then
									if v:GetPos():Distance(player:GetPos()) <= 2048 then
										Schema:EasyText(player, "peru", "There is one with a yellow banner raised, chaining you to this mortal plane! Vanquish them or distance yourself greatly!");
										Schema:EasyText(v, "peru", "You feel your yellow banner pulsate with energy as the helljaunt of "..player:Name().." is foiled!");
										
										local damageInfo = DamageInfo();
										
										damageInfo:SetDamageType(DMG_BURN);
										damageInfo:SetInflictor(v);
										damageInfo:SetAttacker(v);
										damageInfo:SetDamage(3);
										
										player:TakeDamageInfo(damageInfo);
										
										return;
									end
								end
							end
						end
					
						local origin = player:GetPos();
						local chosenspot = math.random(1, #Schema.hellPortalTeleports["hell"]);
						local destination = Schema.hellPortalTeleports["hell"][chosenspot].pos;
						local angles = Schema.hellPortalTeleports["hell"][chosenspot].ang;
						
						ParticleEffect("teleport_fx", origin, Angle(0,0,0), player);
						sound.Play("misc/summon.wav", origin, 100, 100);
						ParticleEffect("teleport_fx", destination, Angle(0,0,0));
						sound.Play("misc/summon.wav", destination, 100, 100);
						player.teleporting = true;
						
						timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
							if IsValid(player) then
								player.teleporting = false;
								
								if player.caughtByCheaple then
									return;
								end
								
								if player:Alive() then
									local target = player.cwHoldingEnt;
								
									Clockwork.player:SetSafePosition(player, destination);
									player:SetEyeAngles(angles);
									util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
									util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
									
									hook.Run("PlayerTeleported", player);

									if IsValid(target) then
										local destinationRaised = destination + Vector(0, 0, 32);
									
										if IsValid(player.cwHoldingGrab) then
											player.cwHoldingGrab:SetComputePosition(destinationRaised);
										end
									
										if target:GetClass() == "prop_ragdoll" then
											local targetPos = target:GetPos();
											local ragdollPlayer = Clockwork.entity:GetPlayer(target);
											
											if IsValid(ragdollPlayer) then
												ragdollPlayer:GodEnable();
											end
											
											for i = 0, target:GetPhysicsObjectCount() - 1 do
												local phys = target:GetPhysicsObjectNum(i);
												local newPos = target:GetPos();
												
												newPos:Sub(targetPos);
												newPos:Add(destinationRaised);
												phys:Wake()
												phys:SetPos(newPos)
											end
											
											timer.Simple(1, function()
												if IsValid(ragdollPlayer) then
													ragdollPlayer:GodDisable();
												end
											end);
										else
											target:SetPos(destinationRaised);
										end
										
										hook.Run("PlayerTeleported", target);
									end
								end
							end
						end);
						
						player:SetCharacterData("nextTeleport", 600);
						
						Schema:EasyText(player, "red", "You begin to helljaunt away!");
						
						timer.Simple(1, function()
							if IsValid(player) and player:Alive() then
								--if player:GetSubfaction() == "Philimaxio" then
									-- Philimaxio get their corruption doubled, but to double 50 would be lethal so I'm exempting helljaunt corruption.
									--player:HandleNeed("corruption", 25);
								--else
									player:HandleNeed("corruption", 50);
								--end
							end
						end);
					else
						Schema:EasyText(player, "peru", "You cannot helljaunt for another "..nextTeleport.." seconds!");
					end
				else
					Schema:EasyText(player, "peru", "You cannot helljaunt while in Hell!");
				end
			else
				Schema:EasyText(player, "peru", "You cannot helljaunt right now!");
			end
		else
			Schema:EasyText(player, "peru", "You are not the correct faction to do this!");
		end
	end;
	
	if CLIENT then
		Clockwork.ConVars.Binds.HELLJAUNT = Clockwork.kernel:CreateClientConVar("cwHelljauntBind", 0, true, true)
		Clockwork.setting:AddKeyBinding("Key Bindings", "Helljaunt: ", "cwHelljauntBind", "cwsay /helljaunt");
	end
COMMAND:Register();

local COMMAND = Clockwork.command:New("HellJauntAdmin");
	COMMAND.tip = "Return to Hell using dark magic with no consequences since you're an admin.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local origin = player:GetPos();
		local chosenspot = math.random(1, #Schema.hellPortalTeleports["hell"]);
		local destination = Schema.hellPortalTeleports["hell"][chosenspot].pos;
		local angles = Schema.hellPortalTeleports["hell"][chosenspot].ang;
		
		ParticleEffect("teleport_fx", origin, Angle(0,0,0), player);
		sound.Play("misc/summon.wav", origin, 100, 100);
		ParticleEffect("teleport_fx", destination, Angle(0,0,0));
		sound.Play("misc/summon.wav", destination, 100, 100);
		player.teleporting = true;
		
		timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
			if IsValid(player) then
				player.teleporting = false;
				
				if player:Alive() then
					local target = player.cwHoldingEnt;

					Clockwork.player:SetSafePosition(player, destination);
					player:SetEyeAngles(angles);
					util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
					util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
					
					hook.Run("PlayerTeleported", player);
					
					if IsValid(target) then
						local destinationRaised = destination + Vector(0, 0, 32);
					
						if IsValid(player.cwHoldingGrab) then
							player.cwHoldingGrab:SetComputePosition(destinationRaised);
						end
					
						if target:GetClass() == "prop_ragdoll" then
							local targetPos = target:GetPos();
							local ragdollPlayer = Clockwork.entity:GetPlayer(target);
							
							if IsValid(ragdollPlayer) then
								ragdollPlayer:GodEnable();
							end
							
							for i = 0, target:GetPhysicsObjectCount() - 1 do
								local phys = target:GetPhysicsObjectNum(i);
								local newPos = target:GetPos();
								
								newPos:Sub(targetPos);
								newPos:Add(destinationRaised);
								phys:Wake()
								phys:SetPos(newPos)
							end
							
							timer.Simple(1, function()
								if IsValid(ragdollPlayer) then
									ragdollPlayer:GodDisable();
								end
							end);
						else
							target:SetPos(destinationRaised);
						end
						
						hook.Run("PlayerTeleported", target);
					end
					
					--player:SetCharacterData("nextTeleport", 600);
				end
			end
		end);
		
		Schema:EasyText(player, "red", "You begin to helljaunt away!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("HellTeleport");
	COMMAND.tip = "Return to Hell using dark magic if you are a Child of Satan if you are near Arch of Perdition or the Pillars of Creation, though this will take time. Anyone close to you or held in your hands will also be teleported.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.important = true;
	COMMAND.faction = "Children of Satan";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() == "Children of Satan" then
			if player.caughtByCheaple then
				return false;
			end
		
			if Schema.hellTeleportDisabled or (!archPos and !pillarPos) then
				Schema:EasyText(player, "peru", "Your connection with Hell appears to be severed and you cannot teleport there!");
				
				return false;
			end
		
			if not player.opponent and not player:IsRagdolled() and player:GetNetVar("tied") == 0 then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone ~= "hell" and lastZone ~= "manor" then
					local origin = player:GetPos();
					
					if (archPos and origin:DistToSqr(archPos) <= (1600 * 1600)) or (pillarPos and origin:DistToSqr(pillarPos) <= (3000 * 3000)) then
						local nextTeleport = player:GetCharacterData("nextTeleport", 0);
						
						if nextTeleport <= 0 then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins conjuring dark magic as they prepare to teleport back to Hell!", origin, Clockwork.config:Get("talk_radius"):Get() * 2);
							
							Clockwork.player:SetAction(player, "hell_teleporting", 30, 2, function()
								if IsValid(player) then
									if not player.opponent and not player:IsRagdolled() and player:GetNetVar("tied") == 0 then
										local lastZone = player:GetCharacterData("LastZone");
										
										if lastZone ~= "hell" and lastZone ~= "manor" then
											local origin = player:GetPos();
											
											if (archPos and origin:DistToSqr(archPos) <= (1600 * 1600)) or (pillarPos and origin:DistToSqr(pillarPos) <= (3000 * 3000)) then
												local chosenspot = math.random(1, #Schema.hellPortalTeleports["hell"]);
												local destination = Schema.hellPortalTeleports["hell"][chosenspot].pos;
												local angles = Schema.hellPortalTeleports["hell"][chosenspot].ang;
												
												ParticleEffect("teleport_fx", origin, Angle(0,0,0), player);
												sound.Play("misc/summon.wav", origin, 100, 100);
												ParticleEffect("teleport_fx", destination, Angle(0,0,0));
												sound.Play("misc/summon.wav", destination, 100, 100);
												player.teleporting = true;
												
												timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
													if IsValid(player) then
														player.teleporting = false;
														
														if player.caughtByCheaple then
															return;
														end
													
														if player:Alive() then
															local target = player.cwHoldingEnt;
															
															if IsValid(target) then
																local destinationRaised = destination + Vector(0, 0, 32);
															
																if IsValid(player.cwHoldingGrab) then
																	player.cwHoldingGrab:SetComputePosition(destinationRaised);
																end
															
																if target:GetClass() == "prop_ragdoll" then
																	local targetPos = target:GetPos();
																	local ragdollPlayer = Clockwork.entity:GetPlayer(target);
																	
																	if IsValid(ragdollPlayer) then
																		ragdollPlayer:GodEnable();
																	end
																	
																	for i = 0, target:GetPhysicsObjectCount() - 1 do
																		local phys = target:GetPhysicsObjectNum(i);
																		local newPos = target:GetPos();
																		
																		newPos:Sub(targetPos);
																		newPos:Add(destinationRaised);
																		phys:Wake()
																		phys:SetPos(newPos)
																	end
																	
																	timer.Simple(1, function()
																		if IsValid(ragdollPlayer) then
																			ragdollPlayer:GodDisable();
																		end
																	end);
																else
																	target:SetPos(destinationRaised);
																end
																
																hook.Run("PlayerTeleported", target);
															end
														
															Clockwork.player:SetSafePosition(player, destination);
															player:SetEyeAngles(angles);
															util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
															util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
															
															hook.Run("PlayerTeleported", player);
															
															--player:SetCharacterData("nextTeleport", 1200);
															
															for k, v in pairs (ents.FindInSphere(player:GetPos(), 256)) do
																if v:IsPlayer() or Clockwork.entity:IsPlayerRagdoll(v) then
																	local chosenspot = math.random(1, #Schema.hellPortalTeleports["hell"]);
																	local destination = Schema.hellPortalTeleports["hell"][chosenspot].pos;
																	local angles = Schema.hellPortalTeleports["hell"][chosenspot].ang;
																	
																	if v:IsPlayer() then
																		Clockwork.player:SetSafePosition(v, destination);
																		v:SetEyeAngles(angles);
																	else
																		v:SetPos(destination + Vector(0, 0, 16));
																	end
																end
															end
														end
													end
												end);

												Schema:EasyText(player, "red", "You begin to teleport to Hell from an area protected by Satanic magic, thus sparing yourself any corruption!");
											else
												if game.GetMap() == "rp_district21" then
													Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Abandoned Church to teleport back to Hell!");
												else
													Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Pillars of Creation to teleport back to Hell!");
												end
											end
										else
											Schema:EasyText(player, "peru", "You cannot teleport to Hell while in Hell!");
										end
									else
										Schema:EasyText(player, "peru", "You cannot teleport to Hell right now!");
									end
								end
							end);
						else
							Schema:EasyText(player, "peru", "You cannot teleport back to Hell for another "..nextTeleport.." seconds!");
						end
					else
						if game.GetMap() == "rp_district21" then
							Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Abandoned Church to teleport back to Hell!");
						else
							Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Pillars of Creation to teleport back to Hell!");
						end
					end
				else
					Schema:EasyText(player, "peru", "You cannot teleport to Hell while in Hell!");
				end
			else
				Schema:EasyText(player, "peru", "You cannot teleport to Hell right now!");
			end
		else
			Schema:EasyText(player, "peru", "You are not the correct faction to do this!");
		end
	end;
	
	if CLIENT then
		Clockwork.ConVars.Binds.HELLTELEPORT = Clockwork.kernel:CreateClientConVar("cwHellteleportBind", 0, true, true)
		Clockwork.setting:AddKeyBinding("Key Bindings", "Hellteleport: ", "cwHellteleportBind", "cwsay /hellteleport");
	end
COMMAND:Register();

local COMMAND = Clockwork.command:New("AddBounty");
	COMMAND.tip = "Add a bounty to a character if you are at the bounty board.";
	COMMAND.text = "<string Name or Key> <int Price> <string Reason>";
	COMMAND.arguments = 3;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		
		if faction == "Holy Hierarchy" or faction == "Gatekeeper" or player:IsAdmin() then
			if not player:IsAdmin() and faction == "Gatekeeper" and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) < 3 then
				Schema:EasyText(player, "darkgrey", "You are not important enough to do this!");
			
				return;
			end
			
			local trace = player:GetEyeTrace();
			
			if (trace.Entity) and trace.Entity:GetClass() == "cw_bounty_board" then
				local price = tonumber(arguments[2]);
				
				if price and price > 0 then
					if Clockwork.player:CanAfford(player, price) then
						local reason = arguments[3];
						
						if reason then
							if string.len(reason) > 128 then
								Schema:EasyText(player, "peru", "The reason for this bounty is too long! It must be a maximum of 128 characters.");
								
								return;
							end
						end
						
						if tonumber(arguments[1]) then
							Schema:AddBounty(math.Truncate(tonumber(arguments[1])), price, reason, player);
						else
							local target = Clockwork.player:FindByID(arguments[1])
							
							if (target) then
								target:AddBounty(price, reason, player);
							else
								Schema:AddBounty(arguments[1], price, reason, player);
							end
						end
					else
						Schema:EasyText(player, "peru", "You do not have enough coin to place this bounty!");
					end
				else
					Schema:EasyText(player, "darkgrey", arguments[2].." is not a valid price!");
				end
			else
				Schema:EasyText(player, "firebrick", "You must be at the bounty board to add a bounty!");
			end
		else
			Schema:EasyText(player, "darkgrey", "You are not important enough to do this!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveBounty");
	COMMAND.tip = "Remove a bounty from a character if you are at the bounty board.";
	COMMAND.text = "<string Name>";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		
		if faction == "Holy Hierarchy" or faction == "Gatekeeper" or player:IsAdmin() then
			if not player:IsAdmin() and faction == "Gatekeeper" and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) < 3 then
				Schema:EasyText(player, "darkgrey", "You are not important enough to do this!");
			
				return;
			end
			
			local trace = player:GetEyeTrace();
			
			if (trace.Entity) and trace.Entity:GetClass() == "cw_bounty_board" then
				if tonumber(arguments[1]) then
					Schema:RemoveBounty(math.Truncate(tonumber(arguments[1])), player);
				else
					local target = Clockwork.player:FindByID(arguments[1])
					
					if (target) then
						target:RemoveBounty(player);
					else
						Schema:RemoveBounty(arguments[1], player);
					end
				end
			else
				Schema:EasyText(player, "firebrick", "You must be at the bounty board to remove a bounty!");
			end
		else
			Schema:EasyText(player, "darkgrey", "You are not important enough to do this!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("NoTarget");
	COMMAND.tip = "Toggles NPC observer targetting for yourself (for leading).";
	COMMAND.access = "o";
	COMMAND.alias = {"NPCTarget", "IgnoreObserver"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetCharacterData("IsObserverTarget")) then
			player:SetCharacterData("IsObserverTarget", false);
			Schema:EasyText(player, "cornflowerblue", "Toggled off NPC observer targetting. NPCs will now no longer target you in observer.");
		else
			player:SetCharacterData("IsObserverTarget", true);
			Schema:EasyText(player, "cornflowerblue", "Toggled on NPC observer targetting. NPCs will now target you in observer.");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SetFogDistance");
COMMAND.tip = "Manually set the fog distance of a zone for all players (use false for 2nd argument to reset a zone's distance).";
COMMAND.text = "<string Zone> <int FogDistance>"
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local zone = arguments[1];
	local fogDistance = arguments[2];
	
	if zone and (fogDistance or fogDistance == false) then
		if fogDistance == "false" then
			Schema:OverrideFogDistance(zone, false);
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has set the fog distance of the "..zone.." to its default value.");
		elseif tonumber(fogDistance) then
			Schema:OverrideFogDistance(zone, tonumber(fogDistance));
			
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has set the fog distance of the "..zone.." to "..tostring(fogDistance)..".");
		end
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PoisonedWineSequence")
	COMMAND.tip = "Make everyone who drank poisoned wine die."
	COMMAND.access = "s"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if Schema.poisonedWinePlayers then
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has started the poisoned wine sequence!");
			
			for i = 1, #Schema.poisonedWinePlayers do
				local player = Schema.poisonedWinePlayers[i];
				
				if IsValid(player) then
					player:SetCharacterData("permakilled", true);
					player.wineRepetitions = math.random(3, 5);
				
					timer.Create("PoisonedWine_"..player:EntIndex(), math.random(20, 40), player.wineRepetitions, function()
						if IsValid(player) and player:Alive() then
							local playerPos = player:GetPos();
							local boneIndex = player:LookupBone("ValveBiped.Bip01_Head1");
							local headPos, boneAng = player:GetBonePosition(boneIndex);
							local strings = {"suddenly throws blood up on the ground!", "vomits blood onto the ground!", "gags and then vomits blood all over the ground!"};
							
							player:ModifyBloodLevel(-25);
							player:Freeze(true);
							player:EmitSound("misc/splat.ogg", 60, math.random(80, 95));
							ParticleEffect("blood_advisor_puncture_withdraw", headPos + (player:GetForward() * 8) - Vector(0, 0, 1), Angle(180, 0, 0), player);
							util.Decal("BloodLarge", playerPos - Vector(0, 0, 2), playerPos + Vector(0, 0, 2));
							
							netstream.Start(player, "TriggerCrazyBob", 75);
							
							timer.Simple(3, function()
								if IsValid(player) then
									player:Freeze(false);
								end
							end);
							
							Clockwork.chatBox:AddInTargetRadius(player, "me", strings[math.random(1, #strings)], player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							
							if player.wineRepetitions then
								player.wineRepetitions = player.wineRepetitions - 1;
								
								if player.wineRepetitions <= 0 then
									timer.Simple(10, function()
										if IsValid(player) and player:Alive() then
											player:DeathCauseOverride("Died from poisoned Bloodwine.");
											player:Kill();
											
											player.wineRepetitions = nil;
										end
									end);
								end
							else
								timer.Simple(10, function()
									if IsValid(player) and player:Alive() then
										player:DeathCauseOverride("Died from poisoned Bloodwine.");
										player:Kill();
										
										player.wineRepetitions = nil;
									end
								end);
							end
						end
					end);
				end
			end
		else
			Schema:EasyText(player, "cornflowerblue", "Noone is currently poisoned!");
		end
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("CauldronInspect");
	COMMAND.tip = "Inspect the quality of the stew within the cauldron.";
	
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_cauldron") then
				local liquidity = Schema:GetCauldronLiquidity();
				local quality = Schema:GetCauldronQuality();
				local servings = Schema:GetCauldronServings();
				servings = math.floor(servings);
				local isPoisoned = Schema:GetPoisonedServings() > 0;
				local isDiseased = Schema:GetDiseasedServings() > 0;

				if liquidity > 0 and liquidity < 5 then
					Schema:EasyText(player, "lightslateblue", "The cauldron is getting low on liquid. A refill will soon be in order.");
				elseif liquidity > 5 then
					Schema:EasyText(player, "lightslateblue", "The cauldron contains an adequate amount of liquid.");
				elseif liquidity == 0 then
					Schema:EasyText(player, "lightslateblue", "The cauldron is devoid of any liquid.");
				end

				if servings > 0 then
					if quality >= 10 then
						Schema:EasyText(player, "lightslateblue", "The cauldron is full of fresh, high quality ingredients.");
					elseif quality < 10 and quality >= 0 then
						Schema:EasyText(player, "lightslateblue", "The cauldron is full of unremarkable, bland ingredients.");
					elseif quality < 0 then
						Schema:EasyText(player, "lightslateblue", "The cauldron is full of vile, inedible ingredients.");
					end

					Schema:EasyText(player, "lightslateblue", "There are approximately "..servings.." servings of stew remaining.");
				else
					Schema:EasyText(player, "lightslateblue", "The cauldron is out of ingredients.");
				end;

				if (isPoisoned or isDiseased) and player:HasBelief("culinarian") then
					Schema:EasyText(player, "olivedrab", "The stew doesn't smell quite right, even given its nature of being a bunch of random things thrown together.");
				end
			end;
		end;
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CauldronReset");
	COMMAND.tip = "Reset the cauldron entirely. Use this command carefully.";
	COMMAND.access = "s";
	
	function COMMAND:OnRun(player, arguments)
		Clockwork.player:NotifyAdmins(player:Name().." has reset the cauldron.");

		Schema:ResetCauldronLiquidity();
		Schema:ResetCauldronQuality();
		Schema:ResetCauldronServings();
		Schema:ResetDiseasedServings();
		Schema:ResetPoisonedServings();
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CauldronAddWater");
	COMMAND.tip = "Add water to the caulron.";
	COMMAND.arguments = 1;
	COMMAND.text = "<uniqueID>";
	
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;
			local uniqueID = arguments[1];

			if (entity:GetClass() == "cw_cauldron") then
				if player:HasItemByID(uniqueID) then

					if uniqueID == "purified_water_bucket" or uniqueID == "dirty_water_bucket" then
						Schema:ModifyCauldronLiquidity(10);
						player:GiveItem(Clockwork.item:CreateInstance("empty_bucket"));
					elseif uniqueID == "dirtywater" or uniqueID == "purified_water" then
						Schema:ModifyCauldronLiquidity(4);
						player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
					else
						return false;
					end

					local item = Clockwork.item:FindByID(uniqueID);
					
					if item.cauldronQuality then
						Schema:ModifyCauldronQuality(item.cauldronQuality);
					end

					player:EmitSound("apocalypse/cauldron/putin.mp3");
					player:TakeItem(player:FindItemByID(uniqueID));

					Clockwork.chatBox:AddInTargetRadius(player, "me", "pours water into the cauldron, filling it up.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				else
					Schema:EasyText(player, "firebrick", "You do not have water to add to the cauldron!");
				end
			end;
		end;
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CauldronDispense");
	COMMAND.tip = "Dispense some stew from the cauldron.";
	
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();
		local itemID;

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_cauldron") then
				local servings = Schema:GetCauldronServings();
				local liquidity = Schema:GetCauldronLiquidity();
				local quality = Schema:GetCauldronQuality();

				if servings > 0 and liquidity > 0 then
					if quality >= 10 then
						itemID = "finestew";
					elseif quality >= 0 and quality < 10 then
						itemID = "blandstew";
					elseif quality < 0 then
						itemID = "shitstew";
					end

					player:GiveItem(Clockwork.item:CreateInstance(itemID));

					local isPoisoned = Schema:GetPoisonedServings() > 0;
					if isPoisoned then
						local stew = player:FindItemByID(itemID);
						stew:SetData("isPoisoned", true);
						Schema:ModifyPoisonedServings(-1);
						Clockwork.player:NotifyAdmins("operator", player:Name().." has dispensed a serving of poisoned stew from the cauldron.");
					end

					local isDiseased = Schema:GetDiseasedServings() > 0;
					if isDiseased then
						local stew = player:FindItemByID(itemID);
						stew:SetData("isPlagued", true);
						Schema:ModifyDiseasedServings(-1);
						Clockwork.player:NotifyAdmins("operator", player:Name().." has dispensed a serving of plagued stew from the cauldron.");
					end

					Schema:ModifyCauldronServings(-1);
					Schema:ModifyCauldronLiquidity(-1);

					player:EmitSound("apocalypse/cauldron/foodget.mp3");

					Clockwork.chatBox:AddInTargetRadius(player, "me", "dispenses a serving of stew from the cauldron.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				else
					Schema:EasyText(player, "peru", "You try to dispense some stew from the cauldron, but nothing happens.");
				end;
			end;
		end;
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CauldronAddIngredient");
	COMMAND.tip = "Dispense some stew from the cauldron.";
	COMMAND.arguments = 1;
	COMMAND.text = "<uniqueID>";
	
	function COMMAND:OnRun(player, arguments)
		if arguments[1] then
			local itemID = arguments[1];
			local item = player:FindItemByID(itemID);

			if item and itemID then
				local trace = player:GetEyeTrace();

				if (trace.Entity) then
					local entity = trace.Entity;

					if (entity:GetClass() == "cw_cauldron") then
						local quality = item.cauldronQuality;

						Schema:ModifyCauldronQuality(quality);

						if item.cauldronLiquidity then
							Schema:ModifyCauldronLiquidity(1);
						else
							Schema:ModifyCauldronServings(1.5);
						end;

						if item.cauldronPoison then
							Schema:ModifyPoisonedServings(2);
							Clockwork.player:NotifyAdmins("operator", player:Name().." has poisoned the cauldron!")
						end

						if item.cauldronPlague then
							Schema:ModifyDiseasedServings(2);
							Clockwork.player:NotifyAdmins("operator", player:Name().." has plagued the cauldron!")
						end
						
						if cwBeliefs then
							if quality == 1 then
								player:HandleXP(15);
							elseif quality == 0 then
								player:HandleXP(8);
							end
						end

						Clockwork.chatBox:AddInTargetRadius(player, "me", "splashes an item into the cauldron.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

						player:TakeItem(player:FindItemByID(itemID));
					end;
				end;
			end;
		end
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CauldronDump");
	COMMAND.tip = "Dump the contents of the cauldron.";
	COMMAND.arguments = 0;
	
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_cauldron") then

				if Schema:GetCauldronServings() > 0 or Schema:GetCauldronLiquidity() > 0 then
					Schema:ResetCauldronLiquidity();
					Schema:ResetCauldronQuality();
					Schema:ResetCauldronServings();
					Schema:ResetDiseasedServings();
					Schema:ResetPoisonedServings();

					Clockwork.chatBox:AddInTargetRadius(player, "me", "dumps the contents of the cauldron onto the ground.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					Clockwork.player:NotifyAdmins("operator", player:Name().." has dumped the cauldron.");
				else
					Schema:EasyText(player, "firebrick", "There are no contents to dump!");
				end;
			end;
		end
	
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CheckRatio");
COMMAND.tip = "Check the ratio of players between different factions who are flagged up.";
COMMAND.text = "[bool Include Admins] [bool Include Subfactions]";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local factionCounts = {};

    for _, v in pairs(_player.GetAll()) do
        local faction = v:GetFaction();
        local subfaction = v:GetSubfaction();

		if(!tobool(arguments[1]) and v:IsAdmin()) then continue; end
		if(!faction) then continue; end

		local factionCount = factionCounts[faction];

		if(!factionCount) then
			factionCounts[faction] = {
				count = 0,
				subfactions = {},

			};

			factionCount = factionCounts[faction];

		end

		factionCount.count = factionCount.count + 1;

		if(subfaction and tobool(arguments[2])) then
			subfaction = subfaction == "" and "N/A" or subfaction;

			local subfactionCount = factionCount.subfactions[subfaction];
			factionCount.subfactions[subfaction] = subfactionCount and subfactionCount + 1 or 1;
			
		end

    end

	if tobool(arguments[1]) then Schema:EasyText(player, "cornflowerblue", "Including admins:"); end

	for i, v in pairs(factionCounts) do
		local playerLimit = Clockwork.faction:FindByID(i).playerLimit and Clockwork.faction:FindByID(i).playerLimit or 0;

    	Schema:EasyText(player, "cornflowerblue", (i..": "..tostring(v.count).."/"..tostring(playerLimit)));

		if(!tobool(arguments[2])) then continue; end

		for ii, vv in pairs(v.subfactions) do
			Schema:EasyText(player, "cornflowerblue", ("      "..ii..": "..tostring(vv)));

		end

	end
end
COMMAND:Register();

local COMMAND = Clockwork.command:New("HellPortalGaze");
	COMMAND.tip = "Gaze through the veil of the Hell Portal.";
	COMMAND.arguments = 1;
	COMMAND.text = "<name of location>";

	local GazeVectorTable = {
		["Arch"] = 
		{
			["rp_begotten3"] = 
			{
				Vector(6606.255859, -10780.157227, -1437.645752), -- box start
				Vector(11185.331055, -14702.863281, 472.348114) -- box end
			}
		},
		["Pillars"] = 
		{
			["rp_begotten3"] = 
			{
				Vector(-14141.288086, 2363.732666, -1726.485474), -- box start
				Vector(-4726.570312, -6574.257324, -952.406616) -- box end
			},
			["rp_district21"] = 
			{
				Vector(9687.704102, -7364.185547, -398.682037), -- box start
				Vector(15093.301758, 1914.199951, 1704.999023) -- box end
			}
		},
		["Church"] = 
		{
			["rp_district21"] = 
			{
				Vector(8241.556641, -11463.334961, -704.866455), -- box start
				Vector(1634.260498, -15241.533203, 1665.453247) -- box end
			}
		}
	}

	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();
		local count = 0;
		local banner = false;
		local map = game.GetMap();


		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_hellportal") then
				if player:GetFaction() ~= "Children of Satan" then
					Schema:EasyText(player, "olive", "You attempt to gaze through the Hell Portal, but you see nothing except a fiery veil.")
					return false;
				end

				if GazeVectorTable[arguments[1]][map] then
					local tab = GazeVectorTable[arguments[1]][map];
					for _,v in _player.Iterator() do
						if v:GetPos():WithinAABox(tab[1], tab[2]) and v:Alive() and not v.cwObserverMode then
							count = count + 1;

							if v:GetNetVar("yellowBanner", false) then
								banner = true;
							end
						end
					end

					if count == 0 then
						count = "no";
					end

					local message = "You gaze through the fiery veil of the portal and witness "..count.." other beings in the vicinity.";

					if banner then
						message = message.." One of the figures has a sickly yellow aura.";
					end

					Clockwork.chatBox:AddInTargetRadius(player, "me", "approaches the Hell Portal, their eyes staring deeply into the veil. Their pupils dilate rapidly for a brief moment.", player:GetPos(), config.Get("talk_radius"):Get() * 1.5);
					timer.Simple(1.5, function()
						Schema:EasyText(player, "olivedrab", message);
					end)
				end
			end;
		end;
	end;

COMMAND:Register();