local cwSailing = cwSailing;

local COMMAND = Clockwork.command:New("SpawnShipsDebug");
COMMAND.tip = "Spawns ships in all locations in the sea zones.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for i = 1, #SHIP_LOCATIONS["calm"] do
		cwSailing:SpawnLongship(player, "calm");
	end
	
	for i = 1, #SHIP_LOCATIONS["rough"] do
		cwSailing:SpawnLongship(player, "rough");
	end
	
	for i = 1, #SHIP_LOCATIONS["styx"] do
		cwSailing:SpawnLongship(player, "styx");
	end
end;

COMMAND:Register();