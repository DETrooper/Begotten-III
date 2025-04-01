COMMAND = Clockwork.command:New("ClearPAC")
COMMAND.tip = "Clears your current PAC."

-- Called when the command has been run.
function COMMAND:OnRun(player)
	if !Clockwork.player:HasFlags(player, "W") then
		Clockwork.player:Notify(player, "You don't have the permission to use PAC!")
	else
		player:ConCommand("pac_clear_parts")
	end
end



COMMAND:Register(COMMAND, "ClearPAC")