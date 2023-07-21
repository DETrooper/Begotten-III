--[[
	Begotten III: Jesus Wept
--]]

-- Called when the top text is needed.
function cwPickupObjects:GetTopText(topText)
	local beingDragged = Clockwork.Client:GetNetVar("IsDragged");
	local beingPickedUp = Clockwork.Client:GetNetVar("IsBeingPickedUp");
	
	if (Clockwork.Client:IsRagdolled()) then
		if beingPickedUp then
			topText:Add("BEING_DRAGGED", "You are being picked up by someone.");
		elseif beingDragged then
			topText:Add("BEING_DRAGGED", "You are being dragged by someone.");
		end
	end;
end;

-- Called when the local player attempts to get up.
function cwPickupObjects:PlayerCanGetUp()
	local beingDragged = Clockwork.Client:GetNetVar("IsDragged");
	local beingPickedUp = Clockwork.Client:GetNetVar("IsBeingPickedUp");
	
	if (beingDragged) or (beingPickedUp) then
		return false;
	end;
end;

timer.Simple(1, function()
	local SWEP = weapons.GetStored("cw_hands");

	if (SWEP) then
		SWEP.Instructions = "Reload: Drop\n"..SWEP.Instructions;
		
		SWEP.Instructions = Clockwork.kernel:Replace(SWEP.Instructions, "Knock.", "Knock/Pickup.");
		SWEP.Instructions = Clockwork.kernel:Replace(SWEP.Instructions, "Punch.", "Punch/Throw.");
	end;
end);