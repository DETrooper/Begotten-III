--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwDueling");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local COMMAND = Clockwork.command:New("GetDuelDebug");
	COMMAND.tip = "Get debug information about active duels and matchmaking.";
	COMMAND.access = "a";
	COMMAND.alias = {"DuelDebug"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		print("----- MATCHMAKING QUEUE ("..tostring(#cwDueling.playersInMatchmaking)..") -----")
		
		for i = 1, #cwDueling.playersInMatchmaking do
			if IsValid(cwDueling.playersInMatchmaking[i]) then
				print(tostring(i)..") "..cwDueling.playersInMatchmaking[i]:Name().." | Statue: "..tostring(cwDueling.playersInMatchmaking[i].duelData.duelStatue));
			end
		end
		
		print(" ");
		print("----- DUEL ARENAS -----")
		
		for k, v in pairs(cwDueling.arenas) do
			printp("DUEL ARENA: "..k);
		
			if v.duelingPlayer1 and IsValid(v.duelingPlayer1) then
				print("Dueling Player 1: "..v.duelingPlayer1:Name());
			else
				print("Dueling Player 1: Empty");
			end
			
			if v.duelingPlayer2 and IsValid(v.duelingPlayer2) then
				print("Dueling Player 2: "..v.duelingPlayer2:Name());
			else
				print("Dueling Player 2: Empty");
			end
			
			print(" ");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharForceEnterMatchmaking")
	COMMAND.tip = "Force a character to enter duel matchmaking. Useful for debugging with bots."
	COMMAND.text = "<string Name>"
	COMMAND.access = "s"
	COMMAND.arguments = 1
	COMMAND.alias = {"ForceEnterMatchmaking", "PlyEnterMatchmaking"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			Clockwork.player:Notify(player, target:Name().." has been forcibly added to duel matchmaking!");
			cwDueling:PlayerEntersMatchmaking(target);
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end
	end
COMMAND:Register()

