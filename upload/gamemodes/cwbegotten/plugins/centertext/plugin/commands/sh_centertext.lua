--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("CenterTextGlobal");
COMMAND.tip = "Show everyone on the server a center text.";
COMMAND.text = "<string Text>";
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text != "") then
		if (SERVER) then
			Clockwork.datastream:Start(nil, "cwPrintTextCenter", {text});
		end;
	else
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You must specify text!")
	end;
end;

COMMAND:Register();