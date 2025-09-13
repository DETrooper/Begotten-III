--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Purifying Stone";
ITEM.model = "models/srp/items/art_flash.mdl";
ITEM.iconoverride = "materials/begotten/ui/itemicons/purifying_stone.png";
ITEM.weight = 0.1;
ITEM.category = "Catalysts";
ITEM.description = "A highly luminescent stone that has various purifying properties.";
ITEM.stackable = true;

ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};

-- Called when a player uses the item.
function ITEM:OnUse(player, position)
	if (player:Alive() and !player:IsRagdolled()) then
		netstream.Start(player, "Stunned", 7);
		netstream.Start(player, "PlaySound", "begotten/ui/sanity_gain.mp3");
		
		if cwSanity then
			player:HandleNeed("sanity", -20); -- instead of HandleSanity, now consistent
		end
		
		player:HandleNeed("corruption", -30);

		-- If Crypt Walker, restore sleep by reducing need
		if player:GetSubfaction() == "Crypt Walkers" then
			player:HandleNeed("sleep", -50);
			Clockwork.chatBox:Add(player, nil, "itnofake", "The purifying stone floods you with unnatural energy, staving off your exhaustion.");
		else
			Clockwork.chatBox:Add(player, nil, "itnofake", "You crush the purifying stone in your hand and can immediately feel the corruption leaving your body.");
		end
	else
		Schema:EasyText(player, "firebrick", "You cannot do this action at this moment.")
	end
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();


-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();


local ITEM = Clockwork.item:New();
	ITEM.name = "Up Catalyst";
	ITEM.model = "models/srp/items/spezzy/art_poonlight.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/up_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A large luminescent stone. Barely-visible glyphs appear to be inscribed within.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 75};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Tortured Spirit";
	ITEM.model = "models/srp/items/art_zoonlight.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/tortured_spirit.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A glass orb with billowing hot fumes writhing within. Occasionally, the fumes will take the appearance of a screaming face.";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 400, supercrateOnly = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Belphegor Catalyst";
	ITEM.model = "models/srp/items/art_fireball.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/belphegor_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A rounded piece of volcanic rock that is warm to the touch. Pulsating magma can be seen within, forming Satanic signets.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 100};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Xolotl Catalyst";
	ITEM.model = "models/srp/items/art_battery.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/xolotl_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A large piece of coiled rock. It appears electrically charged.";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 400, supercrateOnly = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Down Catalyst";
	ITEM.model = "models/srp/items/art_crystalthorn.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/down_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A rounded, crater-covered stone. Large luminescent bolts protrude from different angles, all with barely-visible glyphs within.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 75};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Elysian Catalyst";
	ITEM.model = "models/srp/items/art_sparkler.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/elysian_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A small piece of coiled rock. It appears electrically charged.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 75, bNoSupercrate = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Familial Catalyst";
	ITEM.model = "models/srp/items/art_bubble.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/familial_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A chalky sedimentary rock with striking green-red hues. Northern glyphs have been inscribed on it.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 100};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Ice Catalyst";
	ITEM.model = "models/srp/items/spezzy/art_vrchen.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ice_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A cold orb surrounded by small icicles.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 150};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Light Catalyst";
	ITEM.model = "models/srp/items/art_gravi.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/light_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A deformed gold-tinted stone. It is inscribed with glyphs of Light.";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 100};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Pantheistic Catalyst";
	ITEM.model = "models/srp/items/art_kolobok.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pantheistic_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A waxy round orb, an energized crystal forming a Northern signet.";
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 100};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Pentagram Catalyst";
	ITEM.model = "models/srp/items/art_crystal.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/pentagram_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A glowing red crystal formation, with numerous Satanic signets inscribed within.";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 400, supercrateOnly = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Holy Spirit";
	ITEM.model = "models/srp/items/art_moonlight.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/holy_spirit.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A glass orb with white-hot billowing fumes writhing within. Occasionally, the fumes form the face of a majestic man.";
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 400, supercrateOnly = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
		
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Trinity Catalyst";
	ITEM.model = "models/srp/items/art_jellyfish.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/trinity_catalyst.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A deformed gold-tinted stone, with a large hollowed centre surrounded by thin tendrils. It is inscribed with glyphs of Light.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 95, bNoSupercrate = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Judgemental Sigil Stone";
	ITEM.model = "models/srp/items/spezzy/art_ftoneflower.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_ftoneflower.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone that makes you feel guilty for simply being alive when held in your hand.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Fire Sigil Stone";
	ITEM.model = "models/srp/items/art_stoneblood.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_stoneblood.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone that burns furiously in your hand.";
	ITEM.stackable = true;	
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Ice Sigil Stone";
	ITEM.model = "models/srp/items/spezzy/art_moldfish.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_moldfish.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone that saps the air with an unbearable chill.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Glazic Sigil Stone";
	ITEM.model = "models/srp/items/art_mammasbeads.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_mammasbeads.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone that bedazzles onlookers with a strong sense of envy and awe.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 700, supercrateOnly = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Unholy Sigil Stone";
	ITEM.model = "models/srp/items/art_slug.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_slug.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone that is utterly repulsive to anyone with even the slightest notion of purity.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Vengeful Sigil Stone";
	ITEM.model = "models/srp/items/art_firefly.mdl";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/art_firefly.png";
	ITEM.weight = 0.1;
	ITEM.category = "Catalysts";
	ITEM.description = "A sigil stone made from aspects of vengeance.";
	ITEM.stackable = true;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	ITEM.itemSpawnerInfo = {category = "Rituals", rarity = 600, supercrateOnly = true};
	
ITEM:Register();
