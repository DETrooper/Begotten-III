--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("Observer")
COMMAND.tip = "Enter or exit observer mode."
COMMAND.access = "o"
COMMAND.logless = true;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (!player.cwObserverReset) then
		if (player:GetMoveType(player) == MOVETYPE_NOCLIP) then
			cwObserverMode:MakePlayerExitObserverMode(player)
		else
			cwObserverMode:MakePlayerEnterObserverMode(player)
		end
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ClientsideObserver")
COMMAND.tip = "Enter or exit clientside observer mode."
COMMAND.access = "s"
COMMAND.logless = true;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (!player.cwObserverReset) then
		netstream.Start(player, "ToggleClientsideObserver");
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("MakeSpectate");
	COMMAND.tip = "Make a player enter or exit spectator mode.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyMakeSpectate", "MakeObserver", "MakeNoclip"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if target.opponent then
				Schema:EasyText(player, "darkgrey", "["..self.name.."] "..target:Name().." is in a duel currently and cannot be put into spectator mode!");
				return false;
			end
			
			if (target:Alive() and !target:IsRagdolled() and !target.cwObserverReset) then
				if (target:GetMoveType(target) == MOVETYPE_NOCLIP) then
					cwObserverMode:MakePlayerExitObserverMode(target);
					Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has made "..target:Name().." exit spectator mode.", nil);
				else
					cwObserverMode:MakePlayerEnterObserverMode(target);
					Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has made "..target:Name().." enter spectator mode.", nil);
				end
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("MakeSpectateAll")
	COMMAND.tip = "Make all non-admins enter spectator mode.";
	COMMAND.access = "s";
	COMMAND.alias = {"SpectateAll", "ObserverAll", "NoclipAll"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if not v:IsAdmin() then
				if v.opponent then
					return false;
				end
				
				cwObserverMode:MakePlayerEnterObserverMode(v)
				Schema:EasyText(v, "cornflowerblue", "You have entered spectator mode!");
				v:StripWeapons();
			end
		end
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has made all non-admins exit spectator mode.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("MakeUnSpectateAll");
	COMMAND.tip = "Make all non-admins exit spectator mode, optional argument for un-pking.";
	COMMAND.text = "[bool Unpermakill]";
	COMMAND.access = "s";
	COMMAND.optionalarguments = 1;
	COMMAND.alias = {"UnSpectateAll", "UnObserverAll", "UnNoclipAll"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			if not v:IsAdmin() and v.cwObserverMode then
				cwObserverMode:MakePlayerExitObserverMode(v);
				Schema:EasyText(v, "cornflowerblue", "You have exited spectator mode!");
			end
			
			if arguments and arguments[1] then
				if (v:GetCharacterData("permakilled")) then
					Schema:UnPermaKillPlayer(v, v:GetRagdollEntity());
				end;
			end
		end
		
		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has made all non-admins exit spectator mode.", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTeleportSpectators");
	COMMAND.tip = "Teleport all spectating player to your target location.";
	COMMAND.access = "s";
	COMMAND.alias = {"PlyBringSpectators", "CharTeleportSpectators", "CharBringSpectators"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local hitPos = player:GetEyeTraceNoCursor().HitPos;
		
		for k, v in pairs (_player.GetAll()) do
			if not v:IsAdmin() and v.cwObserverMode then
				Clockwork.player:SetSafePosition(v, hitPos);
			end
		end
		
		Clockwork.player:NotifyAll(player:Name().." has teleported all spectators to their target location.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Spectate")
COMMAND.tip = "Enter or exit spectator mode if spectator mode is enabled and you are dead."
COMMAND.logless = true;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if cwObserverMode.spectatorMode then
		if (!player.cwObserverReset) then
			if player.opponent then
				Schema:EasyText(player, "darkgrey", "You cannot enter spectate mode while in a duel!");
				return false;
			end
			
			if !player:Alive() then
				if (player:GetMoveType(player) == MOVETYPE_NOCLIP) then
					cwObserverMode:MakePlayerExitObserverMode(player)
					Schema:EasyText(player, "cornflowerblue", "You have exited spectator mode!");
				else
					cwObserverMode:MakePlayerEnterObserverMode(player)
					Schema:EasyText(player, "cornflowerblue", "You have entered spectator mode!");
					player:StripWeapons();
				end
			else
				Schema:EasyText(player, "darkgrey", "You must be dead in order to manually trigger spectate mode!");
			end
		end
	else
		Schema:EasyText(player, "grey", "Spectator mode is not currently enabled!");
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("SpectatorModeOn");
	COMMAND.tip = "Turn spectator mode on.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwObserverMode.spectatorMode = true;

		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has turned spectator mode on!", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpectatorModeOff");
	COMMAND.tip = "Turn spectator mode off.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwObserverMode.spectatorMode = false;

		Schema:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has turned off spectator mode!", nil);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SpectatorModeStatus");
	COMMAND.tip = "Print whether spectator mode is on, and if so, who is in it.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if cwObserverMode.spectatorMode then
			local namesInObserver = {};
			
			for k, v in pairs (_player.GetAll()) do
				if !v:IsAdmin() and v:GetMoveType() == MOVETYPE_NOCLIP then
					table.insert(namesInObserver, v:Name());
				end
			end
			
			local notifyString = "Spectator mode is on! There are "..tostring(#namesInObserver).." players in observer:"
			
			for i = 1, #namesInObserver do
				if i == #namesInObserver and i > 1 then
					notifyString = notifyString.." and "..namesInObserver[i]..".";
				else
					notifyString = notifyString.." "..namesInObserver[i]..",";
				end
			end
			
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..notifyString);
		else
			Schema:EasyText(player, "grey", "["..self.name.."] Spectator mode is off!");
		end
	end;
COMMAND:Register();