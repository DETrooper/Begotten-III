--[[
	By: DETrooper
--]]

local cwSailing = cwSailing;

local ITEM = Clockwork.item:New();
	ITEM.name = "Scroll of a Goreic Longship";
	ITEM.uniqueID = "scroll_longship";
	ITEM.category = "Naval";
	ITEM.model = "models/items/magic/scrolls/scroll_open.mdl";
	ITEM.weight = 0.1;
	ITEM.description = "A scroll and some basic navigational equipment. It shows a detailed map to where a Goreic Longship is docked.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll_open.png";
	
	function ITEM:OnUseCustom(player, itemEntity, itemFunction)
		if (game.GetMap() != "rp_begotten3") then
			return;
		end;
	
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			Schema:EasyText(player, "chocolate", "You are not the correct faction to use this item!");
			return false;
		end;
		
		if player:GetCharacterData("LastZone") ~= "gore" then
			Schema:EasyText(player, "peru", "You must be in the Goreic forest to use this item!");
			return false;
		end
		
		if itemFunction == "dock" then
			if IsValid(player.longship) then
				--cwSailing:RemoveLongship(player.longship);
				player.longship:Remove();
			else
				Schema:EasyText(player, "peru", "You do not have a longship undocked!");
			end
		elseif itemFunction == "undock" then
			cwSailing:SpawnLongship(player, "docks");
		end

		return false; -- Prevent this item from being used, it should be permanent.
	end

	function ITEM:CanTakeStorage(player, storageTable)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;
	
	function ITEM:CanPickup(player, quickUse, itemEntity)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;

Clockwork.item:Register(ITEM);