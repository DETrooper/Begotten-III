--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local COMMAND = Clockwork.command:New("W");
	COMMAND.tip = "Whisper to characters near you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;
	COMMAND.alias = {"Whisper"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local talkRadius = math.min(config.Get("talk_radius"):Get() / 3, 80);
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		if hook.Run("PlayerCanSayIC", player, text) then		
			Clockwork.chatBox:SetMultiplier(0.75);
			
			if player.victim and IsValid(player.victim) then
				Clockwork.chatBox:AddInRadius(player.victim, "whisper", text, player.victim:GetPos(), talkRadius);
			elseif player.possessor and IsValid(player.possessor) then
				Clockwork.chatBox:Add({player, player.possessor}, player, "demonhosttalk", text);
			else
				Clockwork.chatBox:AddInRadius(player, "whisper", text, player:GetPos(), talkRadius);
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Y");
	COMMAND.tip = "Yell to characters near you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;
	COMMAND.alias = {"Yell", "Shout"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		if hook.Run("PlayerCanSayIC", player, text) then
			Clockwork.chatBox:SetMultiplier(1.25);
			
			if player.victim and IsValid(player.victim) then
				Clockwork.chatBox:AddInRadius(player.victim, "yell", text, player.victim:GetPos(), config.Get("talk_radius"):Get() * 2.5);
				
				hook.Run("PlayerYellEmitSound", player.victim);
				
				if cwZombies then
					cwZombies:GiveAwayPosition(player.victim, 900);
				end
			elseif player.possessor and IsValid(player.possessor) then
				Clockwork.chatBox:Add({player, player.possessor}, player, "demonhosttalk", text);
			else
				Clockwork.chatBox:AddInRadius(player, "yell", text, player:GetPos(), config.Get("talk_radius"):Get() * 2.5);
				
				hook.Run("PlayerYellEmitSound", player);
				
				if cwZombies then
					cwZombies:GiveAwayPosition(player, 900);
				end
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Su");
	COMMAND.tip = "Send a private message to all superadmins.";
	COMMAND.text = "<string Msg>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local listeners = {};
		
		for _, v in _player.Iterator() do
			
			if (ads and ads[v:SteamID()]) then
				listeners[#listeners + 1] = v;
			end;
		end;
		
		Clockwork.chatBox:Add(
			listeners, player, "priv", table.concat(arguments, " "), {userGroup = "superadmin"}
		);
	end;
COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("SetVoicemail");
	COMMAND.tip = "Set your personal message voicemail.";
	COMMAND.text = "[string Text]";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (arguments[1] == "none") then
			player:SetCharacterData("Voicemail", nil);
			Clockwork.player:Notify(player, "You have removed your voicemail.");
		else
			player:SetCharacterData("Voicemail", arguments[1]);
			Clockwork.player:Notify(player, "You have set your voicemail to '"..arguments[1].."'.");
		end;
	end;
COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("Roll");
	COMMAND.tip = "Roll a number between 0 and the specified number.";
	COMMAND.text = "[number Range]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player.possessor and IsValid(player.possessor) then
			Clockwork.player:Notify(player, "You cannot perform this action!");
			
			return;
		end
	
		local number = math.Clamp(tonumber(arguments[1]) or 100, 0, 1000000000);
		
		Clockwork.chatBox:AddInRadius(player, "roll", "has rolled "..math.random(0, number).." out of "..number..".",
			player:GetPos(), config.Get("talk_radius"):Get());
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PM");
	COMMAND.tip = "Send a private message to an admin.";
	COMMAND.text = "<string Name> <string Text>";
	--COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (player:IsUserGroup("operator") or player:IsAdmin() or player:IsSuperAdmin()) or (target:IsUserGroup("operator") or target:IsAdmin() or target:IsSuperAdmin()) then
				--local voicemail = target:GetCharacterData("Voicemail");
				
				--[[if (voicemail and voicemail != "") then
					Clockwork.chatBox:Add(player, target, "pm", voicemail);
				else]]--
					Clockwork.chatBox:Add({player, target}, player, "pm", table.concat(arguments, " ", 2));
				--end;
			else
				Clockwork.player:Notify(player, "You can only privately message admins!");
			end
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("Op");
	COMMAND.tip = "Send a private message to all operators and above.";
	COMMAND.text = "<string Msg>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local listeners = {};
		
		for _, v in _player.Iterator() do
			if (v:IsUserGroup("operator") or v:IsAdmin()
			or v:IsSuperAdmin()) then
				listeners[#listeners + 1] = v;
			end;
		end;
		
		Clockwork.chatBox:Add(
			listeners, player, "priv", table.concat(arguments, " "), {userGroup = "operator"}
		);
	end;
COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("Me");
	COMMAND.tip = "Speak in third person to others around you.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE);
	COMMAND.arguments = 1;
	COMMAND.alias = {"Perform"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;

		if hook.Run("PlayerCanSayIC", player, text) then 
			if player.victim and IsValid(player.victim) then
				Clockwork.chatBox:AddInTargetRadius(player.victim, "me", string.gsub(text, "^.", string.lower), player.victim:GetPos(), config.Get("talk_radius"):Get() * 2);
			elseif player.possessor and IsValid(player.possessor) then
				Clockwork.player:Notify(player, "You cannot perform this action!");
				
				return;
			else
				Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(text, "^.", string.lower), player:GetPos(), config.Get("talk_radius"):Get() * 2);
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("It");
	COMMAND.tip = "Describe a local action or event.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (string.len(text) < 8) then
			Clockwork.player:Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		if player.possessor and IsValid(player.possessor) then
			Clockwork.player:Notify(player, "You cannot perform this action!");
			
			return;
		end
		
		if hook.Run("PlayerCanSayIC", player, text) then 
			Clockwork.chatBox:AddInTargetRadius(player, "it", text, player:GetPos(), config.Get("talk_radius"):Get() * 2);
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Event");
	COMMAND.tip = "Send an event to all characters.";
	COMMAND.text = "<string Text>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "o";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.chatBox:Add(nil, player, "event", table.concat(arguments, " "));
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("AdminChat");
	COMMAND.tip = "Communicate with other admins.";
	COMMAND.text = "<string Text>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.alias = {"Ad", "Op"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local listeners = {};
		
		for _, v in _player.Iterator() do
			if (v:IsUserGroup("operator") or v:IsAdmin() or v:IsSuperAdmin()) then
				listeners[#listeners + 1] = v;
			end;
		end;
		
		Clockwork.chatBox:Add(
			listeners, player, "priv", table.concat(arguments, " "), {userGroup = "admin"}
		);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("AdminHelp");
COMMAND.tip = "Send a message to the admins.";
COMMAND.text = "<string Message>";
--COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;
COMMAND.alias = {"aHelp", "help"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local message = table.concat(arguments, " ", 1)

    for _, v in _player.Iterator() do
		if (Clockwork.player:IsAdmin(v)) then
            Clockwork.player:Notify(v, "[ADMINHELP] "..player:Name()..": "..message);
        end;
    end;
	
	if not Clockwork.player:IsAdmin(player) then
		Clockwork.player:Notify(player, "[ADMINHELP] "..player:Name()..": "..message);
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("AdminReply");
COMMAND.tip = "Send a message to a player as an adminhelp reply.";
COMMAND.text = "<string Name> <string Message>";
--COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local message = "\""..table.concat(arguments, " ", 2).."\"";
		
		Clockwork.player:Notify(target, "[ADMINHELP RESPONSE] "..message);
		Clockwork.player:Notify(Schema:GetAdmins(), "[ADMINHELP RESPONSE] "..player:Name().." to "..target:Name()..": "..message);
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();