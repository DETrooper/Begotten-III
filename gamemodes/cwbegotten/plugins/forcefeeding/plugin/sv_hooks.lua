--[[
	Begotten III: Jesus Wept
--]]

-- Called when a player presses a key.
function cwForceFeeding:KeyPress(player, key)
	if (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "force_feeding") then
			Clockwork.player:SetAction(player, nil);
		end
	end;
end;

function cwForceFeeding:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "force_feeding") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1;
		infoTable.jumpPower = 0;
	end
end
