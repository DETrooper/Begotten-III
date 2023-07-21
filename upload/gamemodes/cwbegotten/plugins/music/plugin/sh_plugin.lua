PLUGIN:SetGlobalAlias("cwMusic");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local COMMAND = Clockwork.command:New("DisableMusic");
	COMMAND.tip = "Disable all dynamic music. Optional argument for stopping all currently playing music for players.";
	COMMAND.text = "[bool Stop]";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"MusicDisable"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwMusic.enabled = false;
		
		for k, v in pairs (_player.GetAll()) do
			if arguments[1] then
				Clockwork.datastream:Start(v, "FadeAllMusic");
			end
			
			Clockwork.datastream:Start(v, "DisableDynamicMusic");
		end;
		
		if arguments[1] then
			Schema:EasyText(GetAdmins(), "icon16/sound_delete.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "red", "disabled", "lightslategrey", " and stopped all currently playing music!")
		else
			Schema:EasyText(GetAdmins(), "icon16/sound_delete.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "red", "disabled", "lightslategrey", " the dynamic music system!")
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyDisableMusic");
	COMMAND.tip = "Disable dynamic music for a player. Optional argument for stopping all currently playing music for players.";
	COMMAND.text = "<string Name> [bool Stop]";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"PlyMusicDisable"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if target then
			if arguments[2] then
				Clockwork.datastream:Start(target, "FadeAllMusic");
				
				Schema:EasyText(GetAdmins(), "icon16/sound_delete.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "red", "disabled", "lightslategrey", " all currently playing music for ", _team.GetColor(target:Team()), target:Name(), "lightslategrey", "!")
			else
				Schema:EasyText(GetAdmins(), "icon16/sound_delete.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "red", "disabled", "lightslategrey", " the dynamic music system for ", _team.GetColor(target:Team()), target:Name(), "lightslategrey", "!")
			end
			
			Clockwork.datastream:Start(target, "DisableDynamicMusic");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyEnableMusic");
	COMMAND.tip = "Enable dynamic music for a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.alias = {"PlyMusicEnable"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if target then
			Clockwork.datastream:Start(target, "EnableDynamicMusic");
			
			Schema:EasyText(GetAdmins(), "icon16/sound_add.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "lawngreen", "enabled", "lightslategrey", " the dynamic music system for ", _team.GetColor(target:Team()), target:Name(), "lightslategrey", "!")
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("EnableMusic");
	COMMAND.tip = "Enable all dynamic music.";
	COMMAND.access = "a";
	COMMAND.alias = {"MusicEnable"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwMusic.enabled = true;
		
		for k, v in pairs (_player.GetAll()) do
			Clockwork.datastream:Start(v, "EnableDynamicMusic");
		end;
		
		Schema:EasyText(GetAdmins(), "icon16/sound_add.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has ", "lawngreen", "enabled", "lightslategrey", " the dynamic music system!")
	end;
COMMAND:Register();

--ezrs "lightslategray" "Angle Grinder has " "red" "disabled" "lightslategray" " the dynamic music system!"

local COMMAND = Clockwork.command:New("StopMusic");
	COMMAND.tip = "Stop all dynamic music currently playing for players (does not disable the system, use /DisableMusic for that).";
	COMMAND.access = "a";
	COMMAND.alias = {"MusicStop"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for k, v in pairs (_player.GetAll()) do
			Clockwork.datastream:Start(v, "FadeAllMusic");
		end;

		Schema:EasyText(GetAdmins(), "icon16/sound_delete.png", _team.GetColor(player:Team()), player:Name().." ", "lightslategray", "has stopped all currently playing music!")
	end;
COMMAND:Register();