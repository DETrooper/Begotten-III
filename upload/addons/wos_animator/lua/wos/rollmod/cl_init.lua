
--[[-------------------------------------------------------------------
	Roll Mod:
		Dodge, duck, dip, dive and... roll!
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------------------------------------------------[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
-------------------------- Copyright 2017, David "King David" Wiltos ]]--

hook.Add("ClockworkInitialized", "wOS.RollMod.SetupConvars", function()
	if Clockwork then
		Clockwork.ConVars.DOUBLETAPROLLING = Clockwork.kernel:CreateClientConVar("cwDoubleTapRolling", 1, true, true)
		
		Clockwork.setting:AddCheckBox("Movement", "Enable double tapping movement keys for rolling. (If not enabled, bind begotten_roll to a key instead)", "cwDoubleTapRolling", "Click to enable/disable double-tap rolling.");
	end
end);

hook.Add("CreateMove", "wOS.RollMod.PreventMovement", function( cmd )
	if LocalPlayer():wOSIsRolling() then
		cmd:ClearButtons()
		cmd:ClearMovement()
		
		if LocalPlayer():GetRollTime() >= CurTime() + 0.1 then
			if (Clockwork and Clockwork.player and Clockwork.player.HasFlags and !Clockwork.player:HasFlags(Clockwork.Client, "4")) then
				cmd:SetButtons( IN_DUCK )
			end;
		end
	end
end)

--Credit to Stalker for this thing, super handy.
net.Receive("wOS.RollMod.CallRestart", function()
	local ply = net.ReadEntity()
	
	if IsValid( ply ) then
		ply:AnimRestartMainSequence()
	end
end)