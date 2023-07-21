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

--[[
local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's Ice Cold Pop";
	ITEM.cost = 10;
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.business = true;
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of an alien liquid, it feels ice cold and fresh though it lacks any sort of refrigeration. Its mere existance disturbs you on an existential level. Regardless, it tastes very good.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Drinks", rarity = 75};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();
--]]