--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Junk Base";
	ITEM.uniqueID = "junk_base";
	ITEM.model = "models/props_c17/doll01.mdl";
	ITEM.category = "Junk";
	ITEM.weight = 1;
	ITEM.description = "A piece of junk.";
	ITEM.junkTypes = {["city"] = "City Junk", ["industrial"] = "Industrial Junk"};
	
	ITEM.breakdownItems = {
		["scrap"] = 3,
	};
	ITEM.breakdownTools = {
		["hammer"] = true,
		["rock"] = true,
	}
	
	ITEM.junkType = "city";
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 10};

	-- Called when the item is dropped.
	function ITEM:OnDrop(player)
		return;
	end;
	
	-- Called when the item is instantiated.
	function ITEM:OnInstantiated()
		if (self.junkType and self.junkTypes[self.junkType]) then
			self.itemSpawnerInfo.category = self.junkTypes[self.junkType];
		end;
	end;
ITEM:Register();