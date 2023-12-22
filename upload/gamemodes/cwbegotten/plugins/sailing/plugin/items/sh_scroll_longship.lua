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
	ITEM:AddData("customName", "", true);
	
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
			local longshipEnt = cwSailing:LongshipExists(self.itemID);
			
			if longshipEnt then
				longshipEnt:Remove();
			else
				Schema:EasyText(player, "peru", "This longship is already docked!");
			end
		elseif itemFunction == "undock" then
			if cwSailing:LongshipExists(self.itemID) then
				Schema:EasyText(player, "peru", "This longship is already undocked!");
				return false;
			end
			
			local longshipEnt = cwSailing:SpawnLongship(player, "docks", self);
			
			if longshipEnt then
				if self:GetData("customName") and self:GetData("customName") ~= "" then
					longshipEnt:SetNWString("name", self:GetData("customName"));
				end
				
				--[[if player:GetSubfaction() == "Clan Harald" then
					longshipEnt.health = self:GetData("health", 1000);
				else
					longshipEnt.health = self:GetData("health", 500);
				end]]--
			end
		elseif itemFunction == "rename" then
			Clockwork.dermaRequest:RequestString(player, "Rename Longship", "What would you like to rename this Longship to?", "", function(result)
				if result and result:len() > 0 then
					local longshipEnt = cwSailing:LongshipExists(self.itemID);
				
					if IsValid(longshipEnt) then
						longshipEnt:SetNWString("name", result);
					end
					
					self:SetData("customName", result); 
				end
			end);
		end

		return false; -- Prevent this item from being used, it should be permanent.
	end
	
	function ITEM:GetCustomName()
		local customName = self:GetData("customName");
		
		if customName and customName ~= "" then
			return "Scroll of '"..customName.."'";
		else
			return self.name;
		end
	end

	--[[function ITEM:CanTakeStorage(player, storageTable)
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
	end;]]--
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;

Clockwork.item:Register(ITEM);