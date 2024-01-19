--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

-- Called when a player's character screen info should be adjusted.
function cwDeathCauses:PlayerAdjustCharacterScreenInfo(character, info)
	info.deathcause = character.deathcause or "Died under mysterious circumstances.";
end