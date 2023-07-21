--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local playerMeta = FindMetaTable("Player")
	
-- A function to get whether a player has an item by its uniqueID.
function playerMeta:HasItemByID(uniqueID)
	return Clockwork.inventory:HasItemByID(Clockwork.inventory:GetClient(), uniqueID);
end;