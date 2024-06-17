--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("CinematicTextTarget");
	COMMAND.tip = "Show a target a cinematic chat message. THIS IS NOT THE SAME AS CENTER TEXT! Your message will appear smaller, and lower down on the screen. This will show for you as well.";
	COMMAND.text = "<string Target> <string Text>";
	COMMAND.access = "a";
	COMMAND.arguments = 2;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		local text = table.concat(arguments, " ", 2);
		
		if (string.utf8len(string) > 3 and string.find(string.utf8sub(text, 0, 1), '"') or string.find(string.utf8sub(text, 0, -1), '"')) then
			Schema:EasyText(player, "firebrick", "You cannot include quotes at the beginning and end of your text!");
			
			return;
		end;
		
		if (target) then
			if (text != "") then
				if (SERVER) then
					Clockwork.datastream:Start(target, "cwPrintCinematicText", {text, 10});
					Clockwork.datastream:Start(player, "cwPrintCinematicText", {text, 10});
				end;
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] You must specify text!");
			end;
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();