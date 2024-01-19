local PLUGIN = PLUGIN;

-- Called when a player's character screen info should be adjusted.
function PLUGIN:PlayerAdjustCharacterScreenInfo(character, info)
	info.timesurvived = character.timesurvived or 0;
end