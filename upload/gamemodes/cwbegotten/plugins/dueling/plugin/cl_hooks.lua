--[[
	Begotten III: Jesus Wept
--]]

Clockwork.datastream:Hook("SetPlayerDueling", function(dueling)
	Clockwork.Client.dueling = dueling;
end);

function cwDueling:CanOpenEntityMenu()
	if Clockwork.Client.dueling then
		local curTime = CurTime();
		
		if !cwDueling.nextInteractMessage or cwDueling.nextInteractMessage < curTime then
			cwDueling.nextInteractMessage = curTime + 5;
			
			Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You cannot interact with entities while in a duel!");
		end
		
		return false;
	end
end

function cwDueling:CanPlayAmbientMusic()
	if Clockwork.Client.dueling then
		return false;
	end
end

function cwDueling:CanPlayBattleMusic()
	if (CW_CONVAR_BATTLEMUSIC and CW_CONVAR_BATTLEMUSIC:GetInt() < 2) then
		if !Clockwork.Client.dueling then
			return false
		end
	end
end