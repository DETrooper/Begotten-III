--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

netstream.Hook("SelectWeapon", function(player, data)
	if (type(data) == "string") then
		if (player:HasWeapon(data)) then
			player:SelectWeapon(data);
		end;
	end;
end);

netstream.Hook("SelectWeaponVictim", function(player, data)
	if (type(data) == "string") then
		if IsValid(player.victim) then
			if (player.victim:HasWeapon(data)) then
				player.victim:SelectWeapon(data);
			end;
		end
	end;
end);