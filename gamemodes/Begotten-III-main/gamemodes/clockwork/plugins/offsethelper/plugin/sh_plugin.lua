if (CLIENT) then
	netstream.Hook("OpenOffsetHelper", function(data)
		Clockwork.Client.vohUniqueID = data.uniqueID;
		vgui.Create("vizOffsetHelper");
	end);
end;