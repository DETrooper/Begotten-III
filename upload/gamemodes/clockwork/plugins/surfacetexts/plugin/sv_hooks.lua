--[[
	Begotten III: Jesus Wept
--]]

-- Called when Clockwork has loaded all of the entities.
function cwSurfaceTexts:ClockworkInitPostEntity() self:LoadSurfaceTexts(); end;

-- Called when a player's data stream info should be sent.
function cwSurfaceTexts:PlayerSendDataStreamInfo(player)
	Clockwork.datastream:Start(player, "SurfaceTexts", self.storedList);
end;