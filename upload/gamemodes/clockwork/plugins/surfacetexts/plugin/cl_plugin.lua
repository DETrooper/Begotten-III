--[[
	Begotten III: Jesus Wept
--]]

netstream.Hook("SurfaceTexts", function(data)
	cwSurfaceTexts.storedList = data;
end);

netstream.Hook("SurfaceTextAdd", function(data)
	cwSurfaceTexts.storedList[#cwSurfaceTexts.storedList + 1] = data;
end);

netstream.Hook("SurfaceTextRemove", function(data)
	for k, v in pairs(cwSurfaceTexts.storedList) do
		if (v.position == data) then
			cwSurfaceTexts.storedList[k] = nil;
		end;
	end;
end);