--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when storage is being loaded.
function cwFactionStorage:ModifyLoadStorageEntityTab(entity, loadTab)
	if loadTab.cwFactionLock then
		entity.cwFactionLock = loadTab.cwFactionLock;
		entity.cwLockTier = 3;
		entity:SetNWBool("hasPassword", true);
		entity:SetNWBool("unlocked", false);
	end
end

-- Called when storage is being saved.
function cwFactionStorage:ModifyStorageSaveTable(entity, saveTab)
	saveTab.cwFactionLock = entity.cwFactionLock;
end

function cwFactionStorage:PlayerCanOpenContainer(player, entity, bForce)
	if bForce then
		return;
	end

	local data = entity.cwFactionLock;
	
	if data then
		local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
		
		if data.factions and !table.IsEmpty(data.factions) then
			if !data.factions[faction] then
				if !data.factions["Children of Satan"] or data.factions["Children of Satan"] and player:GetSubfaction() ~= "Kinisger" then
					Schema:EasyText(player, "peru", "You are not the correct faction to open this container!");
					
					return false;
				end
			end
		end
	
		if data.subfactions and !table.IsEmpty(data.subfactions) then
			local subfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
			
			if !data.subfactions[subfaction] then
				if !data.subfactions["Kinisger"] or data.subfactions["Kinisger"] and player:GetSubfaction() ~= "Kinisger" then
					Schema:EasyText(player, "peru", "You are not the correct subfaction to open this container!");
			
					return false;
				end
			end
		end
		
		if Schema.faiths then
			if data.subfaiths and !table.IsEmpty(data.subfaiths) then
				local subfaith = player:GetSubfaith();
				
				if !data.subfaiths[subfaith] then
					Schema:EasyText(player, "peru", "You are not the correct subfaith to open this container!");
				
					return false;
				end
			end
		end
		
		if Schema.Ranks then
			if data.ranks and !table.IsEmpty(data.ranks) then
				local rank = player:GetCharacterData("rank", 1);
				
				if Schema.Ranks[faction] then
					local rankString = Schema.Ranks[faction][rank];

					if !rankString then
						Schema:EasyText(player, "peru", "You are not the correct rank to open this container!");
					
						return false;
					end
					
					if !data.ranks[rankString] then
						Schema:EasyText(player, "peru", "You are not the correct rank to open this container!");
					
						return false;
					end
				else
					Schema:EasyText(player, "peru", "You are not the correct rank to open this container!");
				
					return false;
				end
			end
		end
		
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." has opened the faction locked container "..entity:GetNetworkedString("Name")..".");
	end
end