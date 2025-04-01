--[[-------------------------------------------------------------------
	wiltOS Prone Compatability:
		Fixes hold types for Prone Mod
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
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
		
----------------------------------------]]--

wOS.AnimExtension.HoldTypes = wOS.AnimExtension.HoldTypes or {}

hook.Add("prone.Initialized", "wOS.AnimExtension.AddProneTypes", function()
	for holdtype, data in pairs( wOS.AnimExtension.HoldTypes ) do
		local iseq = prone.GetIdleAnimation( data.BaseHoldType ) 
		local mseq = prone.GetMovingAnimation( data.BaseHoldType ) 
		prone.AddNewHoldTypeAnimation( holdtype, mseq, iseq )
	end
end )

