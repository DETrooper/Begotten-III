--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New();
COMMAND.tip = "Jam a radio frequency if you have an ECW radio.";
COMMAND.text = "[bool TurnOn]"
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if !player:HasItemByID("ecw_radio") then
		Clockwork.player:Notify(player, "You must have an ECW radio in order to use this command!");
		
		return false;
	end

	if arguments[1] then
		local gender = player:GetGender();
		local activate = (arguments[1] == "true")
		local term = "off"
		local active = player:GetCharacterData("radioJamming", false)
		
		if active == activate then
			if active then
				term = "on"
			end
			Clockwork.player:Notify(player, "This device is already "..term.."!");
			return false
		end
		
		if arguments[1] == "true" then
			player:SetCharacterData("radioJamming", true);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns on a strange device.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			
			netstream.Start(player, "radioJamming", true);
		else
			player:SetCharacterData("radioJamming", false);
			player:EmitSound("buttons/lightswitch2.wav", 70, 90, 0.4);
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub("turns off a strange device.", "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			
			netstream.Start(player, "radioJamming", false);
		end
	else
		Clockwork.player:Notify(player, "You must specify true or false!");
	end
end;

Clockwork.command:Register(COMMAND, "SetECWJamming");