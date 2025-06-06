COMMAND = Clockwork.command:New("PACEditor")
COMMAND.tip = "Opens the PAC editor."

-- Called when the command has been run.
function COMMAND:OnRun(player)
	if !Clockwork.player:HasFlags(player, "W") then
		Clockwork.player:Notify(player, "You don't have the permission to use PAC!")
	else
		player:ConCommand("pac_editor")
	end
end



COMMAND:Register(COMMAND, "PACEditor")