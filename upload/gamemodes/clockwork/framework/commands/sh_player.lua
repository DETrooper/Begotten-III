--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("PlaySoundGlobal");
	COMMAND.tip = "Play a sound on all player's clients. All arguments after the first may be player names, which the sound WILL NOT play on.";
	COMMAND.text = "<string SoundName> [int Level] [int Pitch] [varargs RecipientFilter]";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (arguments[1]) then
			local info = {name = arguments[1], pitch = 100, level = 75};
			local translate = {[2] = "level", [3] = "pitch"};
			local startingIndex = 4;
			local filter, names = {}, {};
			
			for i = 2, 3 do
				if (tonumber(arguments[i]) == nil) then
					if (string.len(tostring(arguments[i])) > 0) then
						startingIndex = startingIndex - 1;
					end;
				else
					info[translate[i]] = tonumber(arguments[i]);
				end;
			end;
			
			for i = startingIndex, #arguments do
				if (arguments[i] and isstring(arguments[i])) then
					local target = Clockwork.player:FindByID(arguments[i]);
					
					if (istable(target)) then
						target = target[1];
					end;
					
					if (target and target:IsPlayer()) then
						filter[target] = true;
						names[#names + 1] = target:Name();
					end;
				end;
			end;
			
			local playerTable = _player.GetAll();
			
			if (!table.IsEmpty(filter)) then
				for k, v in pairs (playerTable) do
					if (filter[v]) then
						playerTable[k] = nil;
					end;
				end;
			end;
			
			local addon = ".";
			
			if (!table.IsEmpty(names)) then
				addon = " - Recipient Filter: "..table.concat(names, ", ")..".";
			end;
			
			netstream.Start(playerTable, "EmitSound", info);
			Clockwork.player:Notify(player, "Playing Sound Globally: "..arguments[1]..addon);
		else
			Clockwork.player:Notify(player, "You must specify a valid sound!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlaySound");
	COMMAND.tip = "Play a sound for a player. If a fifth argument is specified, the sound will not play for you.";
	COMMAND.text = "<string Name> <string SoundName> [int Level 0-511] [int Pitch 30-255] [bool NoEavesdrop]";
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 3;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (arguments[2]) then
				local info = {
					name = arguments[2],
					level = 75,
					pitch = 100,
				};
				
				if (arguments[3]) then info.level = tonumber(arguments[3]); end;
				if (arguments[4]) then info.pitch = tonumber(arguments[4]); end;
				
				netstream.Start(target, "EmitSound", info);
				
				if (target != player and !arguments[4]) then
					netstream.Start(player, "EmitSound", info);
				end;
			else
				Clockwork.player:Notify(player, "You must specify a valid sound!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("EmitSound");
	COMMAND.tip = "Emit a sound. Specifying a fourth argument attaches the sound to you. Specifying a fifth argument will search for a player to attach the sound to. If no fourth or fifth argument is specified, the sound will be emitted from your cursor. If your cursor hits an entity, the entity will emit the sound.";
	COMMAND.text = "<string SoundName> [int Level 0-511] [int Pitch 30-255] [bool Attach] [string PlayerName]";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 4;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (arguments[1]) then
			local trace = player:GetEyeTraceNoCursor();
			local entity = trace.Entity;
			local hitPos = trace.HitPos;
			local info = {
				name = arguments[1],
				level = 75,
				pitch = 100,
				entity = hitPos,
			};
			
			if (IsValid(entity) and !entity:IsWorld()) then
				info.entity = entity;
			end;
			
			if (arguments[2]) then info.level = tonumber(arguments[2]); end;
			if (arguments[3]) then info.pitch = tonumber(arguments[3]); end;
			
			if (arguments[4] and tobool(arguments[4]) == true) then
				local target = player;
				
				if (arguments[5]) then
					local plyTarget = Clockwork.player:FindByID(arguments[5]);
					
					if (plyTarget) then
						if (istable(plyTarget)) then
							plyTarget = plyTarget[1];
						end;
						
						target = plyTarget;
					end;
				end;
				
				info.entity = target;
			end;
			
			netstream.Start(nil, "EmitSound", info);
		else
			Clockwork.player:Notify(player, "You must specify a valid sound!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyBan");
	COMMAND.tip = "Ban a player from the server.";
	COMMAND.text = "<string Name|SteamID|IPAddress> <number Minutes> [string Reason]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 2;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local duration = tonumber(arguments[2]);
		local reason = table.concat(arguments, " ", 3);
		
		if (!reason or reason == "") then
			reason = nil;
		end;
		
		if (!Clockwork.player:IsProtected(arguments[1])) then
			if (duration) then
				Clockwork.bans:Add(arguments[1], duration * 60, reason, function(steamName, duration, reason)
					if (IsValid(player)) then
						if (steamName) then
							if (duration > 0) then
								local hours = math.Round(duration / 3600);
								
								if (hours >= 1) then
									Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").");
								else
									Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").");
								end;
							else
								Clockwork.player:NotifyAll(player:Name().." has banned '"..steamName.."' permanently ("..reason..").");
							end;
						else
							Clockwork.player:Notify(player, "This is not a valid identifier!");
						end;
					end;
				end);
			else
				Clockwork.player:Notify(player, "This is not a valid duration!");
			end;
		else
			local target = Clockwork.player:FindByID(arguments[1]);
			
			if (target) then
				Clockwork.player:Notify(player, target:Name().." is protected!");
			else
				Clockwork.player:Notify(player, "This player is protected!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGiveFlags");
	COMMAND.tip = "Give flags to a player. These flags will persist across characters.";
	COMMAND.text = "<string Name> <string Flag(s)>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (istable(target)) then
			Clockwork.player:Notify(player, "Too many players with the identifier '"..arguments[1].."' were found. Re-enter the command with a specific player's name!");
			return;
		end;
		
		if (target) then
			if (string.find(arguments[2], "a") or string.find(arguments[2], "s") or string.find(arguments[2], "o")) then
				if (!Clockwork.player:IsProtected(player)) then
					Clockwork.player:Notify(player, "You cannot give 'o', 'a' or 's' flags!");
					return;
				end
			end;
			
			Clockwork.player:GivePlayerFlags(target, arguments[2]);
			Clockwork.player:NotifyAll(player:Name().." gave "..target:Name().." '"..arguments[2].."' player flags.");
			target:SaveCharacter();
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMute");
	COMMAND.tip = "Mute a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharMute", "Mute", "Gag", "PlyGag", "CharGag"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			
			target:SetMuted(true);
			
			Clockwork.player:NotifyAdmins("operator", player:Name().." has muted "..name..".");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnmute");
	COMMAND.tip = "Unmute a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharUnmute", "Unmute", "Ungag", "PlyUngag", "CharUngag"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			
			target:SetMuted(false);
			
			Clockwork.player:NotifyAdmins("operator", player:Name().." has unmuted "..name..".");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMuteAll");
	COMMAND.tip = "Mute a player.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharMuteAll", "MuteAll", "GagAll", "PlyGagAll", "CharGagAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if (!Clockwork.player:IsAdmin(v)) then
				v:SetMuted(true);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has muted all players.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnmuteAll");
	COMMAND.tip = "Unmute a player.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharUnmuteAll", "UnmuteAll", "UngagAll", "PlyUngagAll", "CharUngagAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if (!Clockwork.player:IsAdmin(v)) then
				v:SetMuted(false);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has unmuted all players.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyFreeze");
	COMMAND.tip = "Toggle freeze a player.";
	COMMAND.text = "<string Name> [bool Freeze 0-1] [bool Force 0-1]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharFreeze"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local name = target:Name();
			local isFrozen = target:IsFrozen();
			local freeze = arguments[2];
			local didFreeze;
			
			if (freeze != nil) then
				freeze = tobool(freeze);
				
				if (!arguments[3]) then
					if (freeze == true and isFrozen) then
						Clockwork.player:Notify(player, name.." is already frozen!");
						return;
					elseif (freeze == false and !isFrozen) then
						Clockwork.player:Notify(player, name.." is not frozen!");
						return;
					end;
				end;
				
				target:Freeze(freeze);

				if (freeze != true) then
					didFreeze = "unfrozen";
				else
					didFreeze = "frozen";
				end;
			elseif (isFrozen) then
				didFreeze = "unfrozen";
				target:Freeze(false);
			else
				didFreeze = "frozen";
				target:Freeze(true);
			end;
			
			if (didFreeze != nil) then
				Clockwork.player:Notify(player, "You have "..didFreeze.." "..name..".");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("FreezeAll");
	COMMAND.tip = "Freeze all non-admins on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyFreezeAll", "CharFreezeAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if (!Clockwork.player:IsAdmin(v)) then
				v:Freeze(true);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has frozen all non-admin players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("UnFreezeAll");
	COMMAND.tip = "Unfreeze all non-admins on the map.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyUnFreezeAll", "CharUnFreezeAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if (!Clockwork.player:IsAdmin(v)) then
				v:Freeze(false);
			end;
		end;
		
		Clockwork.player:NotifyAdmins("operator", player:Name().." has unfrozen all non-admin players.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawn");
	COMMAND.tip = "Respawn a player at their default spawnpoint.";
	COMMAND.text = "<string Name> [bool Bring] [bool Freeze]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])

		if (target) then
			if (istable(target)) then
				for k, v in pairs (target) do
					if (v:Alive() and #target > 1) then
						target[k] = nil;
					end;
				end;
				
				target = table.FindNext(target)
			end;
		
			local maxHealth = target:GetMaxHealth();
			local bring = arguments[2];
			local freeze = arguments[3];
			local name = target:Name();

			target:Spawn();
			target:SetHealth(maxHealth);
			
			if (bring != nil) then
				if (tobool(bring) == true) then
					local trace = player:GetEyeTraceNoCursor();
					local hitNormal = trace.HitNormal;
					local position = trace.HitPos + (hitNormal * 16);
					local playerAngles = player:GetAngles();
					
					target:SetPos(position);
					target:SetEyeAngles(Angle(0, -playerAngles.y, 0));
				end;
			end;
			
			if (freeze != nil) then
				target:Freeze(true);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnBring");
	COMMAND.tip = "Respawn a player and bring them to your crosshair position.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawn", arguments[1], "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnBringFreeze");
	COMMAND.tip = "Respawn a player and bring them to your crosshair position, as well as freeze them.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawn", arguments[1], "1", "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStay");
	COMMAND.tip = "Respawn a player at their last place of death.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (istable(target)) then
			for k, v in pairs (target) do
				if (v:Alive() and #target > 1) then
					target[k] = nil;
				end;
			end;
			
			target = table.FindNext(target)
		end;
		
		if (target) then
			local maxHealth = target:GetMaxHealth();
			local name = target:Name();
			local freeze = arguments[2];

			target:Spawn();
			target:SetHealth(maxHealth);
			
			if (target.cwDeathPosition) then
				target:SetPos(target.cwDeathPosition + Vector(0, 0, 0));
			end;
			
			if (target.cwDeathAngles) then
				target:SetEyeAngles(target.cwDeathAngles);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStayFreeze");
	COMMAND.tip = "Respawn a player at their last place of death and freeze them.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		player:RunClockworkCmd("PlyRespawnStay", arguments[1], "1");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyRespawnStayAll");
	COMMAND.tip = "Respawn all dead players at the position where they died. You may specify individual names to exempt from the mass-respawn.";
	COMMAND.text = "<vararg Ignore>";
	COMMAND.access = "s";
	COMMAND.optionalArgument = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local respawned = {};
		local arguments = arguments[1];
		local exempt = {};
		
		for k, v in pairs(string.Split(arguments, " ")) do
			local target = Clockwork.player:FindByID(v);
			
			if (target) then
				exempt[target] = true;
			end;
		end;
		
		for i, v in ipairs(_player.GetAll()) do
			if (exempt[v] or v:Alive() or !v.cwDeathPosition) then
				continue;
			end;
			
			local name = v:Name();
				player:RunClockworkCmd("PlyRespawnStay", name, false);
			respawned[#respawned + 1] = name;
		end;
		
		if (#respawned > 0) then
			Clockwork.player:Notify(player, "You respawned the following players: "..table.concat(respawned, ", ")..".");
		else
			Clockwork.player:Notify(player, "There were no dead players to respawn!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GetFlags");
	COMMAND.tip = "Get the important flags (petcrnCW). You may specify the name of a player to give these flags to. Second argument makes flags persist across characters.";
	COMMAND.text = "<string Name> <bool PlayerFlags>";
	COMMAND.access = "s";
	COMMAND.optionalArguments = 2;
	COMMAND.alias = {"GiveFlags"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = player;
		local command = "CharGiveFlags";
		local playerFlags = arguments[2];
		
		if (arguments[1]) then
			local plyTarget = Clockwork.player:FindByID(arguments[1]);
			
			if (istable(plyTarget)) then
				Clockwork.player:Notify(player, "Too many players with the identifier '"..arguments[1].."' were found. Re-enter the command with a specific player's name!");
				return;
			end;
		
			if (plyTarget) then
				target = plyTarget;
			end;
		end;
		
		if (playerFlags != nil) then
			command = "PlyGiveFlags";
		end;
		
		local playerName = player:Name();
		local name = target:Name();
		--local flagString = "";
		
		--[[for k, v in pairs (Clockwork.flag.stored) do
			flagString = flagString..k;
		end;]]--
		
		local flagString = "petcrnCW";
		
		if (string.len(flagString) > 0) then
			player:RunClockworkCmd(command, name, flagString);
		else
			Clockwork.player:Notify(player, "No flags were found!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySlay");
	COMMAND.tip = "Slay a player. Using \"silent slay\" will instantly respawn the player at a spawnpoint. \"Bring\" argument is only used when silent slay is true.";
	COMMAND.text = "<string Name> [bool Silent] [bool Bring]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 2;
	COMMAND.alias = {"CharSlay", "PlyKill", "CharKill"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local targetIsPlayer = false;

			if (istable(target)) then
				for k, v in pairs (target) do
					if (!v:Alive() and #target > 1) then
						target[k] = nil;
					end;
				end;
				
				target = table.FindNext(target)
			end;
			
			if (target and target:IsPlayer()) then
				local name = target:Name();
				local message = "";
				
				if (target == player) then
					targetIsPlayer = true;
					name = "yourself";
				end;
				
				if (target:Alive()) then
					if (tobool(arguments[2]) == true) then
						target:KillSilent();
						
						local addon = ".";

						if (tobool(arguments[3]) == true and !targetIsPlayer) then
							local frameTime = FrameTime();
							local gender = target:GetGender();
							local thirdPerson = {
								["Male"] = "him",
								["Female"] = "her",
							};

							addon = " and brought "..thirdPerson[gender].." to your cursor.";
							
							timer.Simple(frameTime * 2, function()
								local trace = player:GetEyeTraceNoCursor();
								local hitNormal = trace.HitNormal;
								local position = trace.HitPos + (hitNormal * 16);
								local playerAngles = player:GetAngles();
								
								target:SetPos(position);
								target:SetEyeAngles(Angle(0, -playerAngles.y, 0));
							end);
						end;
						
						message = "You have silently slain "..name..addon;
					else
						target:Kill();
						message = "You have slain "..name..".";
					end;
				else
					message = name.." is already dead!";
				end;
				
				if (message) then
					Clockwork.player:Notify(player, message);
				end;
			else
				Clockwork.player:Notify(player, "No players alive found with the identifier '"..string.gsub(arguments[1], "^.", string.upper).."'!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyDemote");
	COMMAND.tip = "Demote a player from their user group.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (!Clockwork.player:IsProtected(player)) then
				local userGroup = target:GetClockworkUserGroup();
				
				Clockwork.player:NotifyAll(player:Name().." has attempted to demote "..target:Name().." from "..userGroup.." to user, but he doesn't have fucking permission to do that!!!");

				return false;
			end
			
			if (!Clockwork.player:IsProtected(target)) then
				local userGroup = target:GetClockworkUserGroup();
				
				if (userGroup != "user") then
					Clockwork.player:NotifyAll(player:Name().." has demoted "..target:Name().." from "..userGroup.." to user.");
						target:SetClockworkUserGroup("user");
					Clockwork.player:LightSpawn(target, true, true);
				else
					Clockwork.player:Notify(player, "This player is only a user and cannot be demoted!");
				end;
			else
				Clockwork.player:Notify(player, target:Name().." is protected!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyGoto");
	COMMAND.tip = "Goto a player's location.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			Clockwork.player:SetSafePosition(player, target:GetPos());
			Clockwork.player:NotifyAll(player:Name().." has gone to "..target:Name().."'s location.");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySearch");
	COMMAND.tip = "Search a players inventory.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (!target.cwBeingSearched) then
				if (!player.cwSearching) then
					target.cwBeingSearched = true;
					player.cwSearching = target;
					
					Clockwork.storage:Open(player, {
						name = target:Name(),
						cash = target:GetCash(),
						weight = target:GetMaxWeight(),
						space = target:GetMaxSpace(),
						entity = target,
						inventory = target:GetInventory(),
						OnClose = function(player, storageTable, entity)
							player.cwSearching = nil;
							
							if (IsValid(entity)) then
								entity.cwBeingSearched = nil;
							end;
						end,
						OnTakeItem = function(player, storageTable, itemTable)
						end,
						OnGiveItem = function(player, storageTable, itemTable)
						end
					});
				else
					Clockwork.player:Notify(player, "You are already searching a character!");
				end;
			else
				Clockwork.player:Notify(player, target:Name().." is already being searched!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyKick");
	COMMAND.tip = "Kick a player from the server.";
	COMMAND.text = "<string Name> <string Reason>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local reason = table.concat(arguments, " ", 2);
		
		if (!reason or reason == "") then
			reason = "reason not specified";
		end;
		
		if (target) then
			if (!Clockwork.player:IsProtected(arguments[1])) then
				Clockwork.player:NotifyAll(player:Name().." has kicked '"..target:Name().."' ("..reason..").");
					target:Kick(reason);
				target.kicked = true;
			else
				Clockwork.player:Notify(player, target:Name().." is protected!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySetGroup");
	COMMAND.tip = "Set a player's user group.";
	COMMAND.text = "<string Name> <string UserGroup>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local userGroup = arguments[2];
		
		if (userGroup != "superadmin" and userGroup != "admin"
		and userGroup != "operator") then
			Clockwork.player:Notify(player, "The user group must be superadmin, admin or operator!");
			
			return;
		end;
		
		if (target) then
			if (!Clockwork.player:IsProtected(target)) then
				Clockwork.player:NotifyAll(player:Name().." has set "..target:Name().."'s user group to "..userGroup..".");
					target:SetClockworkUserGroup(userGroup);
				Clockwork.player:LightSpawn(target, true, true);
			else
				Clockwork.player:Notify(player, target:Name().." is protected!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTeleport");
	COMMAND.tip = "Teleport a player to your target location.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyBring", "CharTeleport", "CharBring"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if target:IsRagdolled() then
				Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
			end
			
			Clockwork.player:SetSafePosition(target, player:GetEyeTraceNoCursor().HitPos);
			Clockwork.player:NotifyAll(player:Name().." has teleported "..target:Name().." to their target location.");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTeleportFreeze");
	COMMAND.tip = "Teleport a player to your target location.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyBringFreeze", "CharTeleportFreeze", "CharBringFreeze"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if target:IsRagdolled() then
				Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
			end
		
			Clockwork.player:SetSafePosition(target, player:GetEyeTraceNoCursor().HitPos);
			Clockwork.player:NotifyAll(player:Name().." has teleported "..target:Name().." to their target location.");
			
			if (!target:IsFrozen()) then
				target:Freeze(true);
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnban");
	COMMAND.tip = "Unban a Steam ID from the server.";
	COMMAND.text = "<string SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local playersTable = config.Get("mysql_players_table"):Get();
		local schemaFolder = Clockwork.kernel:GetSchemaFolder();
		local identifier = string.upper(arguments[1]);
		
		if (Clockwork.bans.stored[identifier]) then
			Clockwork.player:NotifyAll(player:Name().." has unbanned '"..Clockwork.bans.stored[identifier].steamName.."'.");
			Clockwork.bans:Remove(identifier);
		else
			Clockwork.player:Notify(player, "There are no banned players with the '"..identifier.."' identifier!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnwhitelist");
	COMMAND.tip = "Remove a player from a faction whitelist.";
	COMMAND.text = "<string Name> <string Faction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 2));
			
			if (factionTable) then
				if (factionTable.whitelist) then
					if (Clockwork.player:IsWhitelisted(target, factionTable.name)) then
						Clockwork.player:SetWhitelisted(target, factionTable.name, false);
						Clockwork.player:SaveCharacter(target);
						
						Clockwork.player:Notify(target, "You have been removed from the "..factionTable.name.." whitelist.");
						Clockwork.player:Notify(player, player:Name().." has removed "..target:Name().." from the "..factionTable.name.." whitelist.");
						--Clockwork.player:NotifyAll(player:Name().." has removed "..target:Name().." from the "..factionTable.name.." whitelist.");
					else
						Clockwork.player:Notify(player, target:Name().." is not on the "..factionTable.name.." whitelist!");
					end;
				else
					Clockwork.player:Notify(player, factionTable.name.." does not have a whitelist!");
				end;
			else
				Clockwork.player:Notify(player, factionTable.name.." is not a valid faction!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnwhitelistSubfaction");
	COMMAND.tip = "Remove a player from a subfaction whitelist.";
	COMMAND.text = "<string Name> <string Subfaction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local subfaction = table.concat(arguments, " ", 2);
		
			for k, v in pairs(Clockwork.faction:GetAll()) do
				local factionTable = v;
				
				if (factionTable) then
					if (factionTable.subfactions) then
						for k2, v2 in pairs(factionTable.subfactions) do
							if v2.name == subfaction then
								if v2.whitelist then
									if (Clockwork.player:IsWhitelistedSubfaction(target, subfaction)) then
										Clockwork.player:SetWhitelistedSubfaction(target, subfaction, false);
										Clockwork.player:SaveCharacter(target);
										
										Clockwork.player:Notify(target, "You have been removed from the "..subfaction.." subfaction whitelist.");
										Clockwork.player:Notify(player, player:Name().." has removed "..target:Name().." from the "..subfaction.." subfaction whitelist.");
										--Clockwork.player:NotifyAll(player:Name().." has removed "..target:Name().." from the "..subfaction.." subfaction whitelist.");
										return;
									else
										Clockwork.player:Notify(player, target:Name().." is not on the "..subfaction.." subfaction whitelist!");
										return;
									end;
								else
									Clockwork.player:Notify(player, subfaction.." does not have a whitelist!");
									return;
								end
							end;
						end;
					end;
				end
			end
			
			Clockwork.player:Notify(player, subfaction.." is not a valid subfaction!");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyVoiceBan");
	COMMAND.tip = "Ban a player from using voice on the server.";
	COMMAND.text = "<string Name|SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (IsValid(target)) then
			if (!target:GetData("VoiceBan")) then
				target:SetData("VoiceBan", true);
			else
				Clockwork.player:Notify(player, target:Name().." is already banned from using voice!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyVoiceUnban");
	COMMAND.tip = "Unban a player from using voice on the server.";
	COMMAND.text = "<string Name|SteamID|IPAddress>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (IsValid(target)) then
			if (target:GetData("VoiceBan")) then
				target:SetData("VoiceBan", false);
			else
				Clockwork.player:Notify(player, target:Name().." is not banned from using voice!");
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWhitelist");
	COMMAND.tip = "Whitelist a player for a faction.";
	COMMAND.text = "<string Name> <string Faction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		if (target) then
			local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 2));
			if (factionTable) then
				if (factionTable.whitelist) then
					if (!Clockwork.player:IsWhitelisted(target, factionTable.name)) then
						Clockwork.player:SetWhitelisted(target, factionTable.name, true);
						Clockwork.player:SaveCharacter(target);
						
						Clockwork.player:Notify(target, "You have been added to the "..factionTable.name.." whitelist.");
						Clockwork.player:Notify(player, player:Name().." has added "..target:Name().." to the "..factionTable.name.." whitelist.");
						--Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the "..factionTable.name.." whitelist.");
					else
						Clockwork.player:Notify(player, target:Name().." is already on the "..factionTable.name.." whitelist!");
					end;
				else
					Clockwork.player:Notify(player, factionTable.name.." does not have a whitelist!");
				end;
			else
				Clockwork.player:Notify(player, table.concat(arguments, " ", 2).." is not a valid faction!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWhitelistSubfaction");
	COMMAND.tip = "Whitelist a player for a subfaction.";
	COMMAND.text = "<string Name> <string Subfaction>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			local subfaction = table.concat(arguments, " ", 2);
		
			for k, v in pairs(Clockwork.faction:GetAll()) do
				local factionTable = v;
				
				if (factionTable) then
					if (factionTable.subfactions) then
						for k2, v2 in pairs(factionTable.subfactions) do
							if v2.name == subfaction then
								if v2.whitelist then
									if (!Clockwork.player:IsWhitelistedSubfaction(target, subfaction)) then
										Clockwork.player:SetWhitelistedSubfaction(target, subfaction, true);
										Clockwork.player:SaveCharacter(target);
										
										Clockwork.player:Notify(target, "You have been added to the "..subfaction.." subfaction whitelist.");
										Clockwork.player:Notify(player, player:Name().." has added "..target:Name().." to the "..subfaction.." subfaction whitelist.");
										--Clockwork.player:NotifyAll(player:Name().." has added "..target:Name().." to the "..subfaction.." whitelist.");
										return;
									else
										Clockwork.player:Notify(player, target:Name().." is already on the "..subfaction.." subfaction whitelist!");
										return;
									end;
								else
									Clockwork.player:Notify(player, subfaction.." does not have a whitelist!");
									return;
								end
							end;
						end;
					end;
				end
			end
			
			Clockwork.player:Notify(player, subfaction.." is not a valid subfaction!");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

-- Properties
properties.Add("ban", {
	MenuLabel = "Ban",
	Order = 50,
	MenuIcon = "icon16/cancel.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Derma_StringRequest(ent:Name(), "How many minutes would you like to ban them for?", nil, function(minutes)
				if IsValid(ent) then
					Derma_StringRequest(ent:Name(), "What is your reason for banning them?", nil, function(reason)
						if IsValid(ent) then
							Clockwork.kernel:RunCommand("PlyBan", ent:Name(), minutes, reason)
						end
					end)
				end
			end)
		end
	end,
});

properties.Add("freeze", {
	MenuLabel = "Freeze",
	Order = 60,
	MenuIcon = "icon16/weather_snow.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then return false end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			Clockwork.kernel:RunCommand("PlyFreeze", ent:Name())
		end
	end,
});

properties.Add("kick", {
	MenuLabel = "Kick",
	Order = 70,
	MenuIcon = "icon16/disconnect.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
		
			Derma_StringRequest(ent:Name(), "What is your reason for kicking them?", nil, function(reason)
				if IsValid(ent) then
					Clockwork.kernel:RunCommand("PlyKick", ent:Name(), reason)
				end
			end)
		end
	end,
});

properties.Add("search", {
	MenuLabel = "Search",
	Order = 80,
	MenuIcon = "icon16/zoom.png",
	Filter = function(self, ent, ply)
		if !IsValid(ent) or !IsValid(ply) or !ply:IsAdmin() then return false end
		if !ent:IsPlayer() then
			if Clockwork.entity:IsPlayerRagdoll(ent) then
				ent = Clockwork.entity:GetPlayer(ent);
			else
				return false;
			end
		end

		return true
	end,
	Action = function(self, ent)
		if IsValid(ent) then
			if !ent:IsPlayer() then
				if Clockwork.entity:IsPlayerRagdoll(ent) then
					ent = Clockwork.entity:GetPlayer(ent);
				else
					return false;
				end
			end
			
			Clockwork.kernel:RunCommand("PlySearch", ent:Name())
		end
	end,
});