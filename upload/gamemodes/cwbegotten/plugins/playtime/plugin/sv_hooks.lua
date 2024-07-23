local PLUGIN = PLUGIN;
local playerMeta = FindMetaTable("Player")

-- Called when a player's character screen info should be adjusted.
function PLUGIN:PlayerAdjustCharacterScreenInfo(player, character, info)
	info.timesurvived = character.data["charPlayTime"] or 0;
end

function PLUGIN:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if !plyTab.nextPlayTime or plyTab.nextPlayTime < curTime then
		local playTime = player:GetData("playTime", 0);
	
		if (playTime) then
			player:SetData("playTime", 0)
		else
			player:SetData("playTime", playTime + 5);
		end
		
		if plyTab.cwCharacter then
			local charPlayTime = player:GetCharacterData("charPlayTime", 0);
		
			if (!charPlayTime) then
				player:SetCharacterData("charPlayTime", 0)
			else
				if alive then
					player:SetCharacterData("charPlayTime", charPlayTime + 5);
				end;
			end
		end
		
		plyTab.nextPlayTime = curTime + 5;
	end
end

function playerMeta:PlayTime()
	return self:GetData("playTime") or 0
end

function playerMeta:CharPlayTime()
	if self.cwCharacter then
		return self:GetCharacterData("charPlayTime") or 0
	else
		return false
	end
end

-- Called when a player's shared variables should be set.
--[[function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("characterPlayTime", player:GetCharacterData("charPlayTime"));
end;]]--

function ConvertSecondsToMultiples(seconds)
	local days = math.floor(seconds/(60*60*24))
	seconds = seconds - days*24*60*60
	local hours = math.floor(seconds/(60*60))
	seconds = seconds - hours*60*60
	local minutes = math.floor(seconds/60)
	seconds = seconds - minutes*60
	seconds = math.floor(seconds)

	local data = {
		days = days,
		hours = hours,
		minutes = minutes,
		seconds = seconds
	}

	return data
end