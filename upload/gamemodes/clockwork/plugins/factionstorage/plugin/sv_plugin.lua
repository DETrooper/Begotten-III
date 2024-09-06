--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

netstream.Hook("FactionStorageAdd", function(player, data)
	if (player.cwFactionStorageSetup) then
		local varTypes = {
			["factions"] = "table",
			["subfactions"] = "table",
			["ranks"] = "table",
			["subfaiths"] = "table",
		}
		
		for k, v in pairs(varTypes) do
			if data[k] and type(data[k]) != v then
				return;
			end
		end
		
		local entity = player.cwFactionStorageEditing;

		if IsValid(entity) then
			local cwFactionLock = {};
			
			cwFactionLock.factions = data.factions
			cwFactionLock.subfactions = data.subfactions
			
			if Schema.Ranks then
				cwFactionLock.ranks = data.ranks
			end
			
			if Schema.faiths then
				cwFactionLock.subfaiths = data.subfaiths
			end
			
			if !table.IsEmpty(data.factions) or !table.IsEmpty(data.subfactions) or !table.IsEmpty(data.ranks) or !table.IsEmpty(data.subfaiths) then
				entity.cwFactionLock = cwFactionLock;
				entity.cwLockTier = 3;
				entity:SetNWBool("unlocked", false);
			else
				entity.cwFactionLock = nil;
				entity.cwLockTier = nil;
				entity:SetNWBool("unlocked", true);
			end
			
			cwStorage:SaveStorage()
		end
	end

	player.cwFactionStorageSetup = nil;
	player.cwFactionStorageEditing = nil;
end)