--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("Radio");
COMMAND.tip = "Send a radio message out to other characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;
COMMAND.alias = {"R"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.player:SayRadio(player, table.concat(arguments, " "), true);
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ProclaimRadio");
COMMAND.tip = "Send a radio message out to other characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;
COMMAND.alias = {"RadioProclaim"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if arguments and (faction == "Gatekeeper" and Schema.RanksOfAuthority[faction][player:GetCharacterData("rank", 1)]) or faction == "Holy Hierarchy" or player:IsAdmin() or Clockwork.player:HasFlags(player, "P") then
		Clockwork.player:SayRadio(player, table.concat(arguments, " "), true, nil, true);
	else
		Schema:EasyText(player, "peru", "You are not important enough to do this!");
	end
end;

COMMAND:Register();