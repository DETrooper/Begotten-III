--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("CenterTextTarget");
COMMAND.tip = "Show a target a center text. This will display the centertext for you as well.";
COMMAND.text = "<string Target> <string Text>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local text = table.concat(arguments, " ", 2);
	
	if (target) then
		if (text != "") then
			if (SERVER) then
				--local finalText = string.Replace(text, "[NAME]", target:FirstName());
				local finalText = text;
				
				Clockwork.datastream:Start(target, "cwPrintTextCenter", {finalText});
				Clockwork.datastream:Start(player, "cwPrintTextCenter", {finalText});
			end;
		else
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You must specify text!");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();