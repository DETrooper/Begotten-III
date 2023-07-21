--[[
	Begotten III: Jesus Wept
--]]

Clockwork.datastream:Hook("SurfaceTexts", function(data)
	cwSurfaceTexts.storedList = data;
end);

Clockwork.datastream:Hook("SurfaceTextAdd", function(data)
	cwSurfaceTexts.storedList[#cwSurfaceTexts.storedList + 1] = data;
end);

Clockwork.datastream:Hook("SurfaceTextRemove", function(data)
	for k, v in pairs(cwSurfaceTexts.storedList) do
		if (v.position == data) then
			cwSurfaceTexts.storedList[k] = nil;
		end;
	end;
end);