local COMMAND = Clockwork.command:New("EnableDiscordLogs");
	COMMAND.tip = "Refresh and enable the discord logs.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwDiscordLog:Refresh();

	end;
COMMAND:Register();