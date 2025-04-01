local COMMAND = Clockwork.command:New("ScreenShake");
COMMAND.tip = "Shakes the screen of all players.";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.text = "<time Seconds> [Shake strength] [Shake frequency] [Vector x] [Vector y] [Vector z] [Radius]";
COMMAND.access = "s";
function COMMAND:OnRun(player, arguments)
	util.ScreenShake(Vector(arguments[4] or 0, arguments[5] or 0, arguments[6] or 0), arguments[2] or 5, arguments[3] or 5, arguments[1], arguments[7] or 50000000);
end;
COMMAND:Register();