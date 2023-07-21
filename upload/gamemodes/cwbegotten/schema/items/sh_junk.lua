--[[
	junk items be here
--]]

-- Junk
-- Industrial Junk
-- Crafting Materials
-- City Junk

--[[local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Rubbish";
	ITEM.description = "Just some rubbish.";
	ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
	ITEM.uniqueID = "junk_base";
	ITEM.category = "Junk";
	ITEM.isBaseItem = true;
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 50};
	ITEM.weight = 0.2;
	
	-- Called when the item is dropped.
	function ITEM:OnDrop(player, itemEntity)
		return;
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Old Soaked Newspaper";
	ITEM.description = "An old soaked newspaper.. lettering worn through. I can't read this...";
	ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
	ITEM.weight = 0.1;
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 30};
ITEM:Register();

for i = 1, 6 do
	local ITEM = Clockwork.item:New("junk_base")
		ITEM.name = "Metal Scrap";
		ITEM.description = "A large chunk of scrap metal.";
		ITEM.model = "models/props/cs_militia/vent01_break_0"..tostring(i)..".mdl";
		ITEM.weight = 0.5 + (i * (0.25));
		ITEM.itemSpawnerInfo = {category = "Industrial Junk", rarity = 30};
		ITEM.category = "Crafting Materials";
	ITEM:Register();
end;

for i = 2, 7 do
	if (i == 5) then
		continue;
	end;
	
	local ITEM = Clockwork.item:New("junk_base")
		ITEM.name = "Wooden Pole";
		ITEM.description = "A wooden pole.";
		ITEM.model = "models/props/cs_militia/roofholeboards_p"..tostring(i)..".mdl";
		ITEM.weight = 0.1 + (i * (0.1));
		ITEM.itemSpawnerInfo = {category = "Junk", rarity = 60};
	ITEM:Register();
end;

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Broken Bottle";
	ITEM.description = "A broken bottle.. Shards of glass..";
	ITEM.model = "models/props/cs_militia/bottle01_breaka.mdl";
	ITEM.weight = 0.1;
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Empty Bottle";
	ITEM.description = "An intact bottle.. It's empty..";
	ITEM.model = "models/props/cs_militia/bottle01.mdl";
	ITEM.weight = 0.15;
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 25};
ITEM:Register();

for i = 2, 6 do
	local ITEM = Clockwork.item:New("junk_base")
		ITEM.name = "Ceramic Chunk";
		ITEM.description = "A chunk of broken ceramic.";
		ITEM.model = "models/props/cs_office/plant01_p"..tostring(i)..".mdl";
		ITEM.weight = 0.2;
		ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 40};
	ITEM:Register();
end;

for i = 3, 8 do
	if (i == 3 or i == 8) then
		local ITEM = Clockwork.item:New("junk_base")
			ITEM.name = "Wood Plank";
			ITEM.description = "A chewed up plank of wood. It has several nails stuck in it.";
			ITEM.model = "models/props/de_prodigy/wood_pallet_debris_0"..tostring(i)..".mdl";
			ITEM.weight = 1.2;
			ITEM.itemSpawnerInfo = {category = "Junk", rarity = 30};
		ITEM:Register();
	end;
end;

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Empty Bottle";
	ITEM.description = "An intact bottle.. It's empty..";
	ITEM.model = "models/props/cs_militia/bottle01.mdl";
	ITEM.weight = 0.15;
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Pliers";
	ITEM.description = "A rusty pair of pliers..";
	ITEM.model = "models/props_c17/tools_pliers01a.mdl";
	ITEM.weight = 0.15;
	ITEM.itemSpawnerInfo = {category = "Industrial Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Wrench";
	ITEM.description = "A rusty wrench..";
	ITEM.model = "models/props_c17/tools_wrench01a.mdl";
	ITEM.weight = 0.15;
	ITEM.itemSpawnerInfo = {category = "Industrial Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Traffic Light";
	ITEM.description = "A giant fucking traffic light.. How did this get here...?";
	ITEM.model = "models/props_c17/traffic_light001a.mdl";
	ITEM.weight = 6.8;
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 100};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Broken Television";
	ITEM.description = "A broken up television..";
	ITEM.model = "models/props_c17/tv_monitor01.mdl";
	ITEM.weight = 2.2;
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Junk Engine";
	ITEM.description = "A broken up television..";
	ITEM.model = "models/props_c17/trappropeller_engine.mdl";
	ITEM.weight = 17.2;
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 25};
ITEM:Register();

local ITEM = Clockwork.item:New("junk_base")
	ITEM.name = "Junk Engine";
	ITEM.description = "A broken up television..";
	ITEM.model = "models/props_c17/trappropeller_engine.mdl";
	ITEM.weight = 7.2;
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 25};
ITEM:Register();]]--

--[[
local ITEM = {};
ITEM.base = "junk_base";
ITEM.name = "Tattered Shoe";
ITEM.worth = 1;
ITEM.model = "models/props_junk/shoe001a.mdl";
ITEM.weight = 0.1
ITEM.description = "A smelly old shoe.";
nexus.item.Register(ITEM);
--]]

--[[
models/props_c17/utilityconnecter002.mdl
models/props_c17/utilityconnecter006.mdl
models/props_c17/utilityconnecter003.mdl
models/props_c17/utilityconnecter005.mdl
models/props_c17/utilityconducter001.mdl
--]]
--[[








] models/props_c17/streetsign001c.mdl
] models/props_c17/streetsign002b.mdl
] models/props_c17/streetsign003b.mdl
] models/props_c17/streetsign004e.mdl
] models/props_c17/streetsign004f.mdl
] models/props_c17/streetsign005b.mdl
] models/props_c17/streetsign005c.mdl
] models/props_c17/streetsign005d.mdl
models/props_c17/light_cagelight01_off.mdl
models/props_c17/lampshade001a.mdl
models/props_c17/light_cagelight02_off.mdl
] models/props_c17/metalpot001a.mdl
] models/props_c17/metalpot002a.mdl
] models/props_c17/lamp001a.mdl
] models/props_c17/lamp_bell_on.mdl
] models/props_c17/lamp_standard_off01.mdl
models/props_c17/gaspipes003a.mdl
models/props_c17/gaspipes002a.mdl
models/props_c17/gaspipes006a.mdl
models/props_c17/grinderclamp01a.mdl
models/props_c17/furnituredrawer001a_chunk04.mdl
models/props_c17/furnitureshelf001b.mdl
models/props_c17/furnituredrawer001a_chunk02.mdl
models/props_c17/furnituredrawer001a_chunk01.mdl
models/props_c17/furnituredrawer001a_chunk03.mdl
models/props_c17/furniturechair001a_chunk01.mdl
models/props_c17/doll01.mdl
models/props_c17/consolebox05a.mdl
models/props_c17/consolebox03a.mdl
models/props_c17/consolebox01a.mdl
models/props_c17/computer01_keyboard.mdl
models/props_c17/clock01.mdl
models/props_canal/boat001b_chunk03.mdl
models/props_debris/concrete_cynderblock001.mdl
models/props_interiors/pot01a.mdl
models/props_interiors/pot02a.mdl
models/props_junk/garbage_glassbottle003a_chunk01.mdl
models/props_junk/garbage_glassbottle003a_chunk02.mdl
models/props_junk/garbage_glassbottle003a_chunk03.mdl
models/props_junk/garbage_coffeemug001a_chunk01.mdl
models/props_junk/garbage_coffeemug001a_chunk02.mdl
models/props_junk/garbage_coffeemug001a_chunk03.mdl
models/props_junk/garbage_glassbottle001a_chunk01.mdl
models/props_junk/garbage_glassbottle001a_chunk02.mdl
models/props_junk/garbage_glassbottle001a_chunk03.mdl
models/props_junk/garbage_glassbottle001a_chunk04.mdl
models/props_junk/garbage_glassbottle002a_chunk01.mdl
models/props_junk/garbage_glassbottle002a_chunk02.mdl
models/props_junk/garbage_metalcan001a.mdl
models/props_junk/garbage_metalcan002a.mdl
models/props_junk/glassbottle01a_chunk01a.mdl
models/props_junk/glassbottle01a_chunk02a.mdl
models/props_junk/glassjug01_chunk01.mdl
models/props_junk/glassjug01_chunk02.mdl
models/props_junk/glassjug01_chunk03.mdl
models/props_junk/shoe001a.mdl
models/props_junk/vent001_chunk4.mdl
models/props_junk/vent001_chunk5.mdl
models/props_junk/vent001_chunk6.mdl
models/props_junk/vent001_chunk7.mdl
--]]
