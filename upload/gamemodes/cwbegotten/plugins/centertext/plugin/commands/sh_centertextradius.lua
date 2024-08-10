--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New("CenterTextRadius");
COMMAND.tip = "Show targets in a radius a center text.";
COMMAND.text = "[int Radius] <string Text>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local radius = tonumber(arguments[1]);
	local text = table.concat(arguments, " ", 2);

	if (text != "") then
		if (SERVER) then
			for k, v in pairs (ents.FindInSphere(player:GetEyeTrace().HitPos, radius or 1024)) do
				if v:IsPlayer() then
					netstream.Start(v, "cwPrintTextCenter", {text});
				end
			end;
		end;
	else
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You must specify text!");
	end;
end;

COMMAND:Register();