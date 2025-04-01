--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local playerMeta = FindMetaTable("Player");

function playerMeta:DeathCauseOverride(deathCause)
	if deathCause then
		cwDeathCauses:DeathCauseOverride(self, deathCause);
	end
end

function playerMeta:WipeDeathCauseOverride()
	cwDeathCauses:WipeDeathCauseOverride(self);
end

-- Also adding kill tracking shit for the Necropolis because I'm too lazy to make another plugin for it.

function playerMeta:GetKills()
	return cwDeathCauses:GetKills(self);
end

function playerMeta:SetKills(kills)
	if kills then
		cwDeathCauses:SetKills(self, kills);
	end
end

function playerMeta:ResetKills()
	cwDeathCauses:ResetKills(self);
end