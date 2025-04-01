--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

netstream.Hook("ContainerHeartbeat", function(data)
	if (data) then
		heartBeat = CreateSound(Clockwork.Client, "player/heartbeat1.wav");

		if (!heartBeat:IsPlaying()) then
			heartBeat:PlayEx(0.5, 100);
		end;
	else
		if (heartBeat) then
			heartBeat:FadeOut(2);
		end;
	end;
end);