local COMMAND = Clockwork.command:New();
COMMAND.tip = "Turn your handheld radio on or off.";
COMMAND.text = "[bool TurnOn]"
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if arguments[1] then
		local gender = player:GetGender();
		
		if arguments[1] == "true" then
			local text
			player:SetCharacterData("radioState", true);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			if (gender == GENDER_MALE) then
				text = "turns on his handheld radio.";
			else
				text = "turns on her handheld radio.";
			end;
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			Clockwork.datastream:Start(player, "RadioState", true);
		else
			local text
			player:SetCharacterData("radioState", false);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			if (gender == GENDER_MALE) then
				text = "turns off his handheld radio."
			else
				text = "turns off her handheld radio."
			end;
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			Clockwork.datastream:Start(player, "RadioState", false);
		end
	else
		Clockwork.player:Notify(player, "You must specify true or false!");
	end
end;

Clockwork.command:Register(COMMAND, "SetRadioState");