COMMAND = Clockwork.command:New("WearPAC")
COMMAND.tip = "Wears your PAC creation."

-- Called when the command has been run.
function COMMAND:OnRun(player)
	if !Clockwork.player:HasFlags(player, "W") then
		Clockwork.player:Notify(player, "You don't have the permission to use PAC!")
	else
		player:ConCommand("pac_wear_parts")
	end
end



COMMAND:Register(COMMAND, "WearPAC")