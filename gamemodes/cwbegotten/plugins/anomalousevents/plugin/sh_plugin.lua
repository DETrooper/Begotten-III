PLUGIN:SetGlobalAlias("cwAnomalous")

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local COMMAND = Clockwork.command:New("cosmicrupture");
	COMMAND.tip = "Cause a Cosmic Rupture to occur in the Wasteland.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.chatBox:Add(nil, player, "event", "The ground abruptly begins to shake violently and the sky explodes with lightning as a torrent of cosmic energy sweeps over the Wasteland. Experienced survivors will know what this means...");
		
		for _, v in _player.Iterator() do
			if IsValid(v) then
				-- Maybe check to see if zone is wasteland/tower/scrap factory/toothboy?
				netstream.Start(v, "FadeAmbientMusic");
				netstream.Start(v, "FadeBattleMusic");
				netstream.Start(v, "CosmicRupture");
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("radiocrazy");
	COMMAND.tip = "Make the radio you're looking at go crazy.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = player:GetEyeTraceNoCursor().Entity;
		
		if IsValid(target) then
			if (target:GetClass() == "cw_radio") then
				if not target:IsCrazy() then
					cwAnomalous:MakeRadioCrazy(target);
				end
			end
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("tvhallucination");
	COMMAND.tip = "Trigger a TV hallucination for a player manually.";
	COMMAND.text = "<string Name> [bool TriggerOnSelf]"
	COMMAND.access = "s";
	COMMAND.arguments = 1
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			netstream.Start(target, "StartNearestTVHallucination");
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end
		
		if arguments[2] then
			netstream.Start(player, "StartNearestTVHallucination");
		end
	end;
COMMAND:Register();