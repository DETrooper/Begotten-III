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
			player:SetCharacterData("radioState", true);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			if (gender == GENDER_MALE) then
				Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns on his handheld radio.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			else
				Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns on her handheld radio.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			end;
			
			netstream.Start(player, "RadioState", true);
		else
			player:SetCharacterData("radioState", false);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			if (gender == GENDER_MALE) then
				Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns off his handheld radio.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			else
				Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns off her handheld radio.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			end;
			
			netstream.Start(player, "RadioState", false);
		end
	else
		Clockwork.player:Notify(player, "You must specify true or false!");
	end
end;

Clockwork.command:Register(COMMAND, "SetRadioState");