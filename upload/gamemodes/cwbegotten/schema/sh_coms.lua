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

local COMMAND = Clockwork.command:New("Enlist")
	COMMAND.tip = "Enlist a character into the ranks of the Gatekeepers. This will only work if you are an Emissary or higher."
	COMMAND.text = "[string Subfaction]"
	COMMAND.flags = CMD_DEFAULT;
	--COMMAND.access = "o"
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"PlyEnlist", "CharEnlist", "Recruit", "PlyRecruit", "CharRecruit"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
		
		if (target and target:Alive()) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				local playerFaction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
				local targetFaction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
			
				if player:IsAdmin() or (playerFaction == "Gatekeeper" and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or playerFaction == "Holy Hierarchy" then
					if targetFaction == "Gatekeeper" then
						Schema:EasyText(player, "grey", target:Name().." is already a Gatekeeper!");

						return;
					end
					
					if (!Clockwork.faction:IsGenderValid("Gatekeeper", target:GetGender())) then
						Schema:EasyText(player, "firebrick", target:Name().." is not the correct gender for the Gatekeeper faction!");
						
						return;
					end;
					
					if player:InTower() then
						if !Schema.towerSafeZoneEnabled then
							Schema:EasyText(player, "firebrick", "The tower safezone must be enabled in order to run this commmand!");
							
							return;
						end
					else
						Schema:EasyText(player, "firebrick", "You must do this inside the Tower of Light!");
						
						return;
					end
					
					local subfaction = arguments[1] or "Legionary";
					local factionSubfactions = Clockwork.faction:GetStored()["Gatekeeper"].subfactions;
					
					for i, v in ipairs(factionSubfactions) do
						if v.name == subfaction then
							subfaction = v;
							
							break;
						end
					end
				
					if istable(subfaction) then
						if targetFaction == "Wanderer" or (targetFaction == "Children of Satan" and target:GetSubfaction() == "Kinisger") then
							Clockwork.dermaRequest:RequestConfirmation(target, "Gatekeeper Enlistment", player:Name().." has invited you to enlist in the Gatekeepers!", function()
								targetFaction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
								
								if (targetFaction == "Wanderer" or (targetFaction == "Children of Satan" and target:GetSubfaction() == "Kinisger")) and target:Alive() and Clockwork.faction:IsGenderValid("Gatekeeper", target:GetGender()) then
									local bSuccess, fault = Clockwork.faction:GetStored()["Gatekeeper"]:OnTransferred(target, Clockwork.faction:GetStored()[targetFaction]);
									
									if (bSuccess != false) then
										if target:GetFaction() ~= "Children of Satan" then
											target:SetCharacterData("Faction", "Gatekeeper", true);
											target:SetCharacterData("Subfaction", subfaction.name, true);
										else
											target:SetCharacterData("kinisgerOverride", "Gatekeeper");
											target:SetSharedVar("kinisgerOverride", "Gatekeeper");
											target:SetCharacterData("kinisgerOverrideSubfaction", subfaction.name);
											target:SetSharedVar("kinisgerOverrideSubfaction", subfaction.name);
										end
										
										if subfaction.name == "Praeventor" then
											target:SetCharacterData("rank", 12);
										end
										
										Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
										Clockwork.player:NotifyAll(player:Name().." has enlisted "..target:Name().." into the Gatekeepers.");
									end;
								end
							end)
							
							Schema:EasyText(player, "green", "You have invited "..target:Name().." to enlist into the Gatekeepers!");
							Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has invited "..target:Name().." to join the Gatekeepers!");
						else
							Schema:EasyText(player, "firebrick", target:Name().." is not the right faction to be enlisted into the Gatekeepers!");
						end
					else
						Schema:EasyText(player, "firebrick", subfaction.." is not a valid subfaction for the Gatekeepers!");
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

local COMMAND = Clockwork.command:New("Promote")
	COMMAND.tip = "Promote a character if they belong to a faction with ranks. 2nd argument allows you to directly set the rank."
	COMMAND.text = "<string Character> <string Rank> [bool NotifyTarget]"
	--COMMAND.access = "o"
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local rank = string.lower(tostring(arguments[2]));
		
		if (target) then
			local faction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
			local playerFaction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		
			if player:IsAdmin() or ((playerFaction == faction and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or playerFaction == "Holy Hierarchy") then
				local name = target:Name();
				local ranks = Schema.Ranks;

				if (!ranks[faction]) then
					Schema:EasyText(player, "darkgrey", target:Name().." does not belong to a faction with ranks!");
					return;
				end;
				
				if (rank != nil) then
						for k, v in pairs (ranks[faction]) do
							if (string.lower(v) == tostring(rank) or k == tonumber(rank)) then
								rank = k;
							end;
						end;
				else
					rank = math.Clamp(target:GetCharacterData("rank", 1) + 1, 1, #ranks[faction]);
				end;

				if (ranks[faction][rank]) then
					if rank == target:GetCharacterData("rank", 1) then
						Schema:EasyText(player, "grey", target:Name().." already holds the rank of "..ranks[faction][rank].."!");
						
						return false;
					end
				
					if playerFaction ~= "Holy Hierarchy" and Schema:GetRankTier(faction, rank) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to "..ranks[faction][rank].."!");
							
							return false;
						end
					end
					
					if playerFaction ~= "Holy Hierarchy" and Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) >= Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) then
						if !player:IsAdmin() then
							Schema:EasyText(player, "grey", "You cannot change the rank of "..target:Name().." to "..ranks[faction][rank].."!");
							
							return false;
						end
					end
					
					target:SetCharacterData("rank", rank);
					hook.Run("PlayerChangedRanks", target);
					local notifyTarget = tobool(arguments[3]);
					
					local subfaction = Schema.RanksToSubfaction[faction][ranks[faction][rank]];
					
					if subfaction then
						if target:GetSharedVar("kinisgerOverride") then
							target:SetCharacterData("kinisgerOverrideSubfaction", subfaction);
							target:SetSharedVar("kinisgerOverrideSubfaction", subfaction);
						else
							target:SetCharacterData("Subfaction", subfaction, true);
						end
						
						Clockwork.player:LoadCharacter(target, Clockwork.player:GetCharacterID(target));
					end
					
					if (target == player) then
						name = "yourself";
						notifyTarget = false;
					end;
					
					if (notifyTarget) then
						Schema:EasyText(target, "olivedrab", "You have been promoted to the rank of \""..ranks[faction][rank].."\".")
					end;
					
					Schema:EasyText(player, "cornflowerblue", "You have promoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
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
			local faction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
			local playerFaction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();

			if player:IsAdmin() or ((playerFaction == faction and Schema:GetRankTier(playerFaction, player:GetCharacterData("rank", 1)) >= 3) or playerFaction == "Holy Hierarchy") then
				local name = target:Name();
				local ranks = Schema.Ranks;
				
				if (!ranks[faction]) then
					Schema:EasyText(player, "darkgrey", target:Name().." does not belong to a faction with ranks!");
					return;
				end;
				
				if playerFaction ~= "Holy Hierarchy" and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) <= Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) then
					if !player:IsAdmin() then
						Schema:EasyText(player, "grey", "You cannot demote "..target:Name().."!");
						
						return false;
					end
				end

				local rankTier = Schema:GetRankTier(faction, target:GetCharacterData("rank", 1));
				
				if rankTier == 1 then
					Schema:EasyText(player, "grey", target:Name().." cannot be demoted any further!");
				
					return false;
				end
				
				local rank = table.KeyFromValue(Schema.Ranks[faction], Schema.RankTiers[faction][math.max(1, rankTier - 1)][1]);
				target:SetCharacterData("rank", rank);
				hook.Run("PlayerChangedRanks", target);
				
				if (target == player) then
					name = "yourself";
				end;

				Schema:EasyText(player, "cornflowerblue", "You have demoted "..name.." to the rank of \""..ranks[faction][rank].."\".");
			else
				Schema:EasyText(player, "grey", "You do not have permissions to change the rank of "..target:Name().."!");
			end
		else
			Schema:EasyText(player, "grey", target.." is not a valid character!");
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
		Clockwork.datastream:Start(player, "cwClipboardText", vectorString)
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
			
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." permanently killed the character '"..target:Name().."'.")
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
				Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..target:SteamName().."'s character \""..target:Name().."\"!");
				
				return;
			else
				Schema:EasyText(player, "darkgrey", "This character is not permanently killed!");
				
				return;
			end;
		end;
		
		for i, target in ipairs(_player.GetAll()) do
			if target.cwCharacterList then
				for k, character in pairs(target.cwCharacterList) do
					if character.name == arguments[1] then
						if character.data["permakilled"] then
							character.data["permakilled"] = false;

							Clockwork.player:SaveCharacter(target);
							
							for k2, v in pairs(target.cwCharacterList) do
								Clockwork.player:CharacterScreenAdd(target, v);
							end
							
							Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..target:SteamName().."'s character \""..character.name.."\"!");
							
							return;
						end
					end
				end
			end
		end
		
		local charactersTable = config.Get("mysql_characters_table"):Get();
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
								
								Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." un-permanently killed "..tostring(v2._SteamName).."'s character '"..tostring(v2._Name).."' from the database.");
							end
						end
					end
				else
					Schema:EasyText(player, "grey", arguments[1].." is not a valid character in the database!");
				end;
			end);
			queryObj:Where("_Name", charName);
		queryObj:Execute()
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnPermakillAll");
	COMMAND.tip = "Unpermakill all players on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyUnPermakillAll", "UnPermakillAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.chatBox:AddInRadius(player, "localevent",  table.concat(arguments, " "), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 4);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("EventZone");
	COMMAND.tip = "Send an event to characters in a specified zone (wasteland, tower, gore, hell).";
	COMMAND.text = "<string Zone> <string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local valid_zones = {"wasteland", "tower", "gore", "hell"};
		local zone = string.lower(arguments[1]);
		
		if table.HasValue(valid_zones, zone) then
			for k, v in pairs (_player.GetAll()) do
				if v:HasInitialized() then
					local lastZone = v:GetCharacterData("LastZone");
					
					if lastZone == zone or (zone == "gore" and (lastZone == "gore_tree" or lastZone == "gore_hallway") or (zone == "hell" and lastZone == "manor") or (zone == "tower" and lastZone == "theater")) or v == player then
						Clockwork.chatBox:Add(v, nil, zone.."event",  table.concat(arguments, " ", 2));
					end
				end
			end
		else
			Schema:EasyText(player, "grey", "You must specify a valid zone!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlaySoundZone");
	COMMAND.tip = "Play a sound to all players in a specific zone.";
	COMMAND.text = "<string Zone> <string SoundName> [int Level] [int Pitch]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local valid_zones = {"wasteland", "tower", "gore", "hell"};
		local zone = string.lower(arguments[1]);
		
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
				
				local playerTable = _player.GetAll();
				
				for k, v in pairs (playerTable) do
					if v:HasInitialized() then
						local lastZone = v:GetCharacterData("LastZone");
						
						if lastZone == zone or (zone == "gore" and (lastZone == "gore_tree" or lastZone == "gore_hallway") or (zone == "hell" and lastZone == "manor") or (zone == "tower" and lastZone == "theater")) or v == player then
							-- nothing
						else
							playerTable[k] = nil;
						end
					end
				end;
				
				netstream.Start(playerTable, "EmitSound", info);
				Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has played the sound sound \""..arguments[2].."\" in zone \""..zone.."\".");
			else
				Schema:EasyText(player, "grey", "You must specify a valid zone!");
			end
		else
			Schema:EasyText(player, "grey", "You must specify a valid sound!");
		end;
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
		for k, v in pairs (_player.GetAll()) do
			if IsValid(v) then
				v:StripWeapons();
			end
		end;
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has stripped the weapons of all players.", nil);
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
			for k, v in pairs (_player.GetAll()) do
				if IsValid(v) then
					v:Give(arguments[1]);
				end
			end;
			
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has given the weapon "..arguments[1].." to all players.", nil);
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid weapon!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("BlowWarhorn");
	COMMAND.tip = "Blow a warhorn in your current area (wasteland/tower or gore forest).";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		-- Prevent the bell sound and warhorn sound from playing over eachother.
		if cwDayNight and cwDayNight.currentCycle == "day" then
			cwDayNight:ModifyCycleTimeLeft(120);
		end
		
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "wasteland" or lastZone == "tower" or lastZone == "theater" then
			local players = _player.GetAll()
			
			for k, v in pairs(players) do
				if IsValid(v) and v:HasInitialized() then
					local vLastZone = v:GetCharacterData("LastZone");
					
					if vLastZone == "wasteland" or vLastZone == "tower" or vLastZone == "theater" then
						Clockwork.chatBox:Add(v, nil, "event", "The ground quakes as the terrifying sound of a Goreic Warfighter horn pierces the sky.");
						--Clockwork.datastream:Start(v, "FadeAmbientMusic");
						--Clockwork.datastream:Start(v, "EmitSound", {name = "warhorns/warhorn_gore.mp3", pitch = 100, level = 75});
						Clockwork.datastream:Start(v, "GoreWarhorn");
					end
				end
			end
		elseif lastZone == "gore" or lastZone == "gore_hallway" or lastZone == "gore_tree" then
			local players = _player.GetAll()
			
			for k, v in pairs(players) do
				if IsValid(v) and v:HasInitialized() then
					local vLastZone = v:GetCharacterData("LastZone");
					
					if vLastZone == "gore" or vLastZone == "gore_hallway" or vLastZone == "gore_tree" then
						Clockwork.chatBox:Add(v, nil, "event", "The ground quakes as the sound of a Goreic Warfighter horn pierces the sky.");
						--Clockwork.datastream:Start(v, "FadeAmbientMusic");
						--Clockwork.datastream:Start(v, "EmitSound", {name = "warhorns/warhorn_gore.mp3", pitch = 100, level = 75});
						Clockwork.datastream:Start(v, "GoreWarhorn");
					end
				end
			end
		else
			Schema:EasyText(player, "peru", "This command cannot be used in this area!");
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
		
		local players = _player.GetAll()
		local close_players = {};
		local far_players = {};
		
		for i = 1, _player.GetCount() do
			local player = players[i];
		
			if IsValid(player) and player:HasInitialized() then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone == "wasteland" then
					table.insert(far_players, player);
					Clockwork.chatBox:Add(player, nil, "event", "The church bell tolls and the holy word is spread: A congregation has been called, and all beings high and lowly are required to attend... or else risk being marked for corpsing.");
					Clockwork.datastream:Start(player, "FadeAmbientMusic");
				elseif lastZone == "tower" or lastZone == "theater" then
					table.insert(close_players, player);
					Clockwork.chatBox:Add(player, nil, "event", "The church bell tolls and the holy word is spread: A congregation has been called, and all beings high and lowly are required to attend... or else risk being marked for corpsing.");
					Clockwork.datastream:Start(player, "FadeAmbientMusic");
				end
			end
		end
		
		Clockwork.datastream:Start(close_players, "EmitSound", {name = "cosmicrupture/bellsclose.wav", pitch = 90, level = 60});
		Clockwork.datastream:Start(far_players, "EmitSound", {name = "cosmicrupture/bellsdistant.wav", pitch = 100, level = 75});
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FuckerJoeAlarm");
	COMMAND.tip = "Sound the Fucker Joe alarm. Fucker Joe is coming!!!! This disables charswapping for alive non-admins for 10 minutes.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		-- Prevent the bell sound and alarm sound from playing over eachother.
		if cwDayNight and cwDayNight.currentCycle == "day" then
			cwDayNight:ModifyCycleTimeLeft(120);
		end
		
		local players = _player.GetAll()
		
		for i = 1, _player.GetCount() do
			local player = players[i];
		
			if IsValid(player) and player:HasInitialized() then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone == "wasteland" or lastZone == "tower" or lastZone == "theater" then
					Clockwork.chatBox:Add(player, nil, "event", "Is it...? No, it cannot be... The alarms sound, for Fucker Joe comes...");
					Clockwork.datastream:Start(player, "FadeAmbientMusic");
					Clockwork.datastream:Start(player, "EmitSound", {name = "warhorns/fuckerjoealarm.mp3", pitch = 90, level = 60});
				end
			end
		end
		
		Schema.fuckerJoeActive = true;
		
		timer.Create("FuckerJoeAlarm", 600, 1, function()
			Schema.fuckerJoeActive = nil;
		end);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Proclaim");
	COMMAND.tip = "Proclaim your words with the attention they deserve if you are sufficiently noble stature.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
	
		if (faction == "Gatekeeper" and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) >= 3) or faction == "Holy Hierarchy" or player:IsAdmin() or Clockwork.player:HasFlags(player, "P") then
			Clockwork.chatBox:SetMultiplier(1.35);
			
			if player.victim and IsValid(player.victim) then
				Clockwork.chatBox:AddInRadius(player.victim, "proclaim", text, player.victim:GetPos(), config.Get("talk_radius"):Get() * 4);
				
				if player.victim:GetSubfaith() == "Voltism" then
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
				
				if player:GetSubfaith() == "Voltism" then
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
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("RavenSpeak");
COMMAND.tip = "Speak through your familiar, a Raven, to another Goreic Warrior.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 2;
COMMAND.alias = {"RS"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" then
			local targetFaction = target:GetSharedVar("kinisgerOverride") or target:GetFaction();
			
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" then
			if player:HasBelief("watchful_raven") then
				local message = "\""..table.concat(arguments, " ", 1).."\"";
				
				player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
				netstream.Start(player, "TriggerCrows");

				for k, v in pairs (_player.GetAll()) do
					if v:HasInitialized() and v:Alive() and (v:GetSubfaction() == "Clan Crast") then
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Clan Crast" or player:IsAdmin() then
			if player:HasBelief("watchful_raven") or player:IsAdmin() then
				--if player:GetPos():WithinAABox(Vector(11622, -6836, 12500), Vector(8744, -10586, 11180)) then
					local message = "\""..table.concat(arguments, " ", 1).."\"";
					
					player:SendLua([[Clockwork.Client:EmitSound("npc/crow/die"..math.random(1, 2)..".wav", 70, 100)]]);
					netstream.Start(player, "TriggerCrows");

					for k, v in pairs (_player.GetAll()) do
						if v:HasInitialized() and v:Alive() then
							local vFaction = v:GetSharedVar("kinisgerOverride") or v:GetFaction();
							local vLastZone = v:GetCharacterData("LastZone");
							
							if vFaction == "Goreic Warrior" and vLastZone ~= "hell" and vLastZone ~= "manor" then
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and player:IsAdmin() then
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
		--[[for k, v in pairs (_player.GetAll()) do
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local faction = player:GetFaction();
		local text = table.concat(arguments, " ");
		
		if !text or (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
	
		if (faction == "Gatekeeper" and Schema:GetRankTier(faction, player:GetCharacterData("rank", 1)) >= 3) or faction == "Holy Hierarchy" or player:IsAdmin() or Clockwork.player:HasFlags(player, "P") then
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
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpeakerIt");
	COMMAND.tip = "Describe an action happening over the tower's PA system.";
	COMMAND.text = "<string Text>";
	COMMAND.arguments = 1;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if arguments[1] and player:IsAdmin() then
			Schema:SpeakerPerform(player, table.concat(arguments, " "));
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetCustomClass");
	COMMAND.tip = "Set a character's custom class.";
	COMMAND.text = "<string Name> <string Class>";
	COMMAND.access = "o";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			target:SetCharacterData("customclass", arguments[2]);
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." set "..target:Name().."'s custom class to "..arguments[2]..".")
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
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." took "..target:Name().."'s custom class.")
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("InvZipTie");
	COMMAND.tip = "Use a zip tie from your inventory.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local curTime = CurTime();
		
		if !player.nextZipTie or player.nextZipTie < curTime then
			local itemTable = player:FindItemByID("bindings");
			
			if (!itemTable) then
				Schema:EasyText(player, "chocolate", "You have nothing to tie with!");
				
				return;
			end;

			Clockwork.player:InventoryAction(player, "use", itemTable.uniqueID, itemTable.itemID);
		else
			Schema:EasyText(player, "peru", "You must wait another "..-math.ceil(curTime - player.nextZipTie).." seconds before attempting to tie someone again!");
		end
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
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all belongings entities on the map for a total of "..tostring(items_removed).." entities.", nil);
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
				Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all item spawned items on the map for a total of "..tostring(items_removed).." items.", nil);
			elseif selection == "2" then
				Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all non-item spawned items on the map for a total of "..tostring(items_removed).." items.", nil);
			elseif selection == "3" then
				Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all decoy items on the map for a total of "..tostring(items_removed).." items.", nil);
			end
		else
			for k, v in pairs (ents.FindByClass("cw_item")) do
				if !v.IsTrapItem then
					items_removed = items_removed + 1;
					v:Remove();
				end
			end
			
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all non-decoy items on the map for a total of "..tostring(items_removed).." items.", nil);
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
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all items in a 512 unit radius of themselves for a total of "..tostring(items_removed).." items.", nil);
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
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has removed all ragdolls on the map for a total of "..tostring(ragdolls_removed).." ragdolls.", nil);
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
		
		local max_poise = target:GetMaxPoise();
		local max_sanity = 100;
		local max_stability = target:GetMaxStability();
		local max_stamina = target:GetMaxStamina();
		
		if target:HasTrait("insane") then
			max_sanity = 40;
		end

		target:ResetInjuries();
		target:TakeAllDiseases();
		target:SetHealth(target:GetMaxHealth() or 100);
		target:SetNeed("thirst", 0);
		target:SetNeed("hunger", 0);
		target:SetNeed("corruption", 0);
		target:SetNeed("sleep", 0);
		target:SetSharedVar("sanity", max_sanity);
		target:SetCharacterData("sanity", max_sanity);
		target:SetCharacterData("Stamina", max_stamina);
		target:SetNWInt("Stamina", max_stamina);
		target:SetCharacterData("stability", max_stability);
		target:SetNWInt("stability", max_stability);
		--target:SetCharacterData("meleeStamina", max_poise);
		target:SetNWInt("meleeStamina", max_poise);
		target:SetNWInt("freeze", 0);
		target:SetBloodLevel(5000);
		target:StopAllBleeding();
		Clockwork.limb:HealBody(target, 100);
		Clockwork.player:SetAction(target, "die", false);
		Clockwork.player:SetAction(target, "die_bleedout", false);
		
		if target:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
			Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
		end
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has fully healed "..name..".");
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
	
		for k, v in pairs (_player.GetAll()) do
			if IsValid(v) and v:HasInitialized() and v:Alive() then
				if !v.opponent or (v.opponent and affect_duelists) then
					local max_poise = v:GetMaxPoise();
					local max_sanity = 100;
					local max_stability = v:GetMaxStability();
					local max_stamina = v:GetMaxStamina();
					
					if v:HasTrait("insane") then
						max_sanity = 40;
					end
					
					v:ResetInjuries();
					v:TakeAllDiseases();
					v:SetHealth(v:GetMaxHealth() or 100);
					v:SetNeed("thirst", 0);
					v:SetNeed("hunger", 0);
					v:SetNeed("corruption", 0);
					v:SetNeed("sleep", 0);
					v:SetSharedVar("sanity", max_sanity);
					v:SetCharacterData("sanity", max_sanity);
					v:SetCharacterData("Stamina", max_stamina);
					v:SetNWInt("Stamina", max_stamina);
					v:SetCharacterData("stability", max_stability);
					v:SetNWInt("stability", max_stability);
					--v:SetCharacterData("meleeStamina", max_poise);
					v:SetNWInt("meleeStamina", max_poise);
					v:SetNWInt("freeze", 0);
					v:SetBloodLevel(5000);
					v:StopAllBleeding();
					Clockwork.limb:HealBody(v, 100);
					Clockwork.player:SetAction(v, "die", false);
					Clockwork.player:SetAction(v, "die_bleedout", false);
					
					if v:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
						Clockwork.player:SetRagdollState(v, RAGDOLL_NONE);
					end
				end;
			end;
		end;
		
		if affect_duelists then
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has fully healed all players on the server, including duelists.");
		else
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has fully healed all players on the server.");
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
		
		if IsValid(activeWeapon) then
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
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled the auto-tie system.");
	else
		Schema.autoTieEnabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled the auto-tie system, all players who spawn will be tied.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleNPCSpawns");
COMMAND.tip = "Toggle the automatic NPC spawning system.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if Schema.npcSpawnsEnabled ~= false then
		Schema.npcSpawnsEnabled = false;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled automatic NPC spawning.");
	else
		Schema.npcSpawnsEnabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled automatic NPC spawning.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleHellJaunting");
COMMAND.tip = "Toggle whether helljaunting is enabled.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if !Schema.hellJauntDisabled then
		Schema.hellJauntDisabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled helljaunting.");
	else
		Schema.hellJauntDisabled = false;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled helljaunting.");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleHellTeleporting");
COMMAND.tip = "Toggle whether teleporting to Hell is enabled.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if !Schema.hellTeleportDisabled then
		Schema.hellTeleportDisabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled teleporting to Hell.");
	else
		Schema.hellTeleportDisabled = false;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled teleporting to Hell.");
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
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled the Tower of Light safe zone.");
	else
		Schema.towerSafeZoneEnabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled the Tower of Light safe zone.");
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
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled falling over for players.");
	else
		Schema.falloverDisabled = true;
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled falling over for players.");
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

local COMMAND = Clockwork.command:New("CoinslotDonate");
	COMMAND.tip = "Offer your coin to the Coinslot.";
	COMMAND.text = "<number Coin>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if arguments[1] and tonumber(arguments[1]) then
					local cash = math.floor(tonumber(arguments[1]));
						
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
							Schema:EasyText(GetAdmins(), "green", player:Name().." has made a large donation to the coinslot: "..cash.." coin.", nil);
						end
						
						entity:EmitSound("ambient/levels/labs/coinslot1.wav");
						return;
					else
						Schema:EasyText(player, "darkgrey", "You need to enter a valid value to donate coin!");
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() == "Children of Satan" then
			if player.caughtByCheaple then
				return false;
			end
		
			if Schema.hellJauntDisabled or (map ~= "rp_begotten3" and map ~= "rp_begotten_redux") then
				Schema:EasyText(player, "peru", "Your connection with Hell appears to be severed and you cannot helljaunt!");
				
				return false;
			end
			
			if player.OverEncumbered then
				Schema:EasyText(player, "peru", "You cannot helljaunt while overencumbered!");
				
				return false;
			end
			
			if player:GetNWBool("Parried") == true then
				Schema:EasyText(player, "peru", "You are too discombobulated to helljaunt right now!");
				
				return false;
			end
			
			if not player.opponent and not player:IsRagdolled() and player:GetSharedVar("tied") == 0 then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone ~= "hell" and lastZone ~= "manor" then
					local nextTeleport = player:GetCharacterData("nextTeleport", 0);
					
					if nextTeleport <= 0 then
						for k, v in pairs(_player.GetAll()) do
							if v:HasInitialized() and v:GetSharedVar("yellowBanner") == true and v:Alive() then
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

									if IsValid(target) then
										local destinationRaised = destination + Vector(0, 0, 32);
									
										if IsValid(player.cwHoldingGrab) then
											player.cwHoldingGrab:SetComputePosition(destinationRaised);
										end
									
										if target:GetClass() == "prop_ragdoll" then
											local targetPos = target:GetPos();
											
											for i = 0, target:GetPhysicsObjectCount() - 1 do
												local phys = target:GetPhysicsObjectNum(i);
												local newPos = target:GetPos();
												
												newPos:Sub(targetPos);
												newPos:Add(destinationRaised);
												phys:Wake()
												phys:SetPos(newPos)
											end
										else
											target:SetPos(destinationRaised);
										end
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
					
					if IsValid(target) then
						local destinationRaised = destination + Vector(0, 0, 32);
					
						if IsValid(player.cwHoldingGrab) then
							player.cwHoldingGrab:SetComputePosition(destinationRaised);
						end
					
						if target:GetClass() == "prop_ragdoll" then
							local targetPos = target:GetPos();
							
							for i = 0, target:GetPhysicsObjectCount() - 1 do
								local phys = target:GetPhysicsObjectNum(i);
								local newPos = target:GetPos();
								
								newPos:Sub(targetPos);
								newPos:Add(destinationRaised);
								phys:Wake()
								phys:SetPos(newPos)
							end
						else
							target:SetPos(destinationRaised);
						end
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

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() == "Children of Satan" then
			if player.caughtByCheaple then
				return false;
			end
		
			if Schema.hellTeleportDisabled or !archPos or !pillarPos then
				Schema:EasyText(player, "peru", "Your connection with Hell appears to be severed and you cannot teleport there!");
				
				return false;
			end
		
			if not player.opponent and not player:IsRagdolled() and player:GetSharedVar("tied") == 0 then
				local lastZone = player:GetCharacterData("LastZone");
				
				if lastZone ~= "hell" and lastZone ~= "manor" then
					local origin = player:GetPos();
					
					if origin:DistToSqr(archPos) <= (1600 * 1600) or origin:DistToSqr(pillarPos) <= (3000 * 3000) then
						local nextTeleport = player:GetCharacterData("nextTeleport", 0);
						
						if nextTeleport <= 0 then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "begins conjuring dark magic as they prepare to teleport back to Hell!", origin, Clockwork.config:Get("talk_radius"):Get() * 2);
							
							Clockwork.player:SetAction(player, "hell_teleporting", 30, 2, function()
								if IsValid(player) then
									if not player.opponent and not player:IsRagdolled() and player:GetSharedVar("tied") == 0 then
										local lastZone = player:GetCharacterData("LastZone");
										
										if lastZone ~= "hell" and lastZone ~= "manor" then
											local origin = player:GetPos();
											
											if origin:DistToSqr(archPos) <= (1600 * 1600) or origin:DistToSqr(pillarPos) <= (3000 * 3000) then
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
																target:GetPhysicsObject():EnableMotion(false);
															
																timer.Simple(0.1, function()
																	if IsValid(target) then
																		target:GetPhysicsObject():EnableMotion(true);
																		
																		if target:GetClass() == "prop_ragdoll" then
																			target:GetPhysicsObject():SetPos(destination + Vector(0, 0, 16), true);
																		else
																			target:SetPos(destination + Vector(0, 0, 16));
																		end
																	end
																end);
															end
														
															Clockwork.player:SetSafePosition(player, destination);
															player:SetEyeAngles(angles);
															util.Decal("PentagramBurn", destination, destination + Vector(0, 0, -256));
															util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
															
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
												Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Pillars of Creation to teleport back to Hell!");
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
						Schema:EasyText(player, "peru", "You must be near the Arch of Perdition or the Pillars of Creation to teleport back to Hell!");
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
			
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has set the fog distance of the "..zone.." to its default value.");
		elseif tonumber(fogDistance) then
			Schema:OverrideFogDistance(zone, tonumber(fogDistance));
			
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has set the fog distance of the "..zone.." to "..tostring(fogDistance)..".");
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
			Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has started the poisoned wine sequence!");
			
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
							
							Clockwork.datastream:Start(player, "TriggerCrazyBob", 75);
							
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