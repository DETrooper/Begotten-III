--[[
	Begotten III: Jesus Wept
--]]

--[[
	You don't have to do this, but I think it's nicer.
	Alternatively, you can simply use the PLUGIN variable.
--]]
PLUGIN:SetGlobalAlias("cwPickupObjects");

--[[ You don't have to do this either, but I prefer to seperate the functions. --]]
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");

function cwPickupObjects:Move(player, moveData)
	if (player:GetNWBool("PickingUpRagdoll", false) == true) then
		moveData:SetVelocity(Vector(0, 0, moveData:GetVelocity().z or 0));
	end;
end;