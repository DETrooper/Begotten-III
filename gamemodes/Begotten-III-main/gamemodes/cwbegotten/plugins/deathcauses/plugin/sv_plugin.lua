--[[
	Begotten III: Jesus Wept
--]]

function cwDeathCauses:DeathCauseOverride(player, deathCause)
	if player then
		player.deathCauseOverriden = true;
		player:SetCharacterData("deathcause", deathCause);
	end
end

function cwDeathCauses:WipeDeathCauseOverride(player)
	if player then
		player.deathCauseOverriden = false;
	end
end

-- Also adding kill tracking shit for the Necropolis because I'm too lazy to make another plugin for it.

function cwDeathCauses:GetKills(player)
	return player:GetCharacterData("kills") or 0;
end

function cwDeathCauses:SetKills(player, kills)
	player:SetCharacterData("kills", kills);
end

function cwDeathCauses:ResetKills(player)
	player:SetCharacterData("kills", 0);
end