if (CLIENT) then
	Clockwork.datastream:Hook("OpenOffsetHelper", function(data)
		Clockwork.Client.vohUniqueID = data.uniqueID;
		vgui.Create("vizOffsetHelper");
	end);
end;