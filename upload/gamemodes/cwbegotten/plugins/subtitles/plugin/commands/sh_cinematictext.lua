--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("CinematicText");
	COMMAND.tip = "Show everyone a cinematic chat message. THIS IS NOT THE SAME AS CENTER TEXT! Your message will appear smaller, and lower down on the screen.";
	COMMAND.text = "<string Text>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (text != "") then
			if (SERVER) then
				Clockwork.datastream:Start(nil, "cwPrintCinematicText", {text, 10});
			end;
		else
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You must specify text!")
		end;
	end;
COMMAND:Register();