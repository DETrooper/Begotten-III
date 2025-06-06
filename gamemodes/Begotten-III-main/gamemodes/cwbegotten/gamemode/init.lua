--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DeriveGamemode("clockwork");

concommand.Add("clearinv", function(player)
	if (player:IsAdmin()) then
		local i = Clockwork.inventory:GetAsItemsList(player:GetInventory())
		for k, v in pairs (i) do
			printp("took "..v.uniqueID);
			for i = 1, Clockwork.inventory:GetItemCountByID(player:GetInventory(), v.uniqueID) do
				player:TakeItemByID(v.uniqueID)
			end;
		end;
	end;
end)