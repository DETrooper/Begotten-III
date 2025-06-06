--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

netstream.Hook("StorageMessage", function(data)
	local entity = data.entity
	local message = data.message

	if (IsValid(entity)) then
		entity.cwMessage = message
	end
end)

netstream.Hook("ContainerPassword", function(data)
	local entity = data

	Derma_StringRequest("Password", "What would the password be?", nil, function(text)
		netstream.Start("ContainerPassword", {text, entity})
	end)
end)


netstream.Hook("LockInteract", function(data)
	if (IsValid(Clockwork.Client.LockMenu)) then
		Clockwork.Client.LockMenu:Close();
		Clockwork.Client.LockMenu:Remove();
	end;
	
	Clockwork.Client.LockMenu = vgui.Create("cwCombinationPanel");
	Clockwork.Client.LockMenu:MakePopup();
	Clockwork.Client.LockMenu:Populate(data[1], data[2], data[3]);
end);

netstream.Hook("CloseMenu", function(data)
	Clockwork.menu:SetOpen(false);
end);