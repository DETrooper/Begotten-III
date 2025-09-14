local ITEM = Clockwork.item:New();
	ITEM.name = "Gatekeeper Standard Issue";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "gatekeeper_standard_issue";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A duffel bag containing equipment standard to that of the Gatekeeper Order.";
	ITEM.weight = 5;
	ITEM.randomWeapons = {"begotten_1h_brokensword", "begotten_1h_pipemace", "begotten_1h_spikedbat", "begotten_1h_spikedboard", "begotten_spear_pitchfork"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local subfaction = player:GetSubfaction();

	Clockwork.player:GiveCash(player, 200, "Gatekeeper Allowance");
	player:GiveItem(Clockwork.item:CreateInstance("gatekeeper_ration"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("gatekeeper_ration"), true);
	player:GiveItem(Clockwork.item:CreateInstance("purified_water"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("purified_water"), true);
	
	if subfaction == "Auxiliary" then
		--player:GiveItem(Clockwork.item:CreateInstance("antibiotic_paste"), true);
		player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_pipemace"), true);
		player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
		player:GiveItem(Clockwork.item:CreateInstance("auxiliary_gambeson"), true);
		--player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"), true);
		--player:GiveItem(Clockwork.item:CreateInstance("laudanum"), true);
		--player:GiveItem(Clockwork.item:CreateInstance("splint"), true);
	elseif subfaction == "Praeventor" then
		player:GiveItem(Clockwork.item:CreateInstance("backpack_small"), true);
		player:GiveItem(Clockwork.item:CreateInstance("begotten_spear_scrapspear"), true);
		player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"), true);
		player:GiveItem(Clockwork.item:CreateInstance("wanderer_cap"), true);
		player:GiveItem(Clockwork.item:CreateInstance("praeventor_gambeson"), true);
		player:GiveItem(Clockwork.item:CreateInstance("shield5"), true);
		player:GiveItem(Clockwork.item:CreateInstance("lockpick"), true);
	else
		player:GiveItem(Clockwork.item:CreateInstance(self.randomWeapons[math.random(1, #self.randomWeapons)]), true);
		player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_pilum"), true);
		player:GiveItem(Clockwork.item:CreateInstance("gatekeeper_gambeson"), true);
		player:GiveItem(Clockwork.item:CreateInstance("shield5"), true);
		player:GiveItem(Clockwork.item:CreateInstance("bindings"), true);
	end
	
	--player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_glazicus"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("shield11"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("mail_coif"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Renegade Gatekeeper Standard Issue";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "renegade_gatekeeper_standard_issue";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A duffel bag containing equipment standard to that of Pope Adyssa's Gatekeeper Order.";
	ITEM.weight = 5;
	ITEM.randomWeapons = {"begotten_1h_pipemace", "begotten_1h_scrapblade", "begotten_spear_scrapspear", "begotten_1h_bladedbat", "begotten_2h_great_sledge"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	Clockwork.player:GiveCash(player, 200, "Gatekeeper Allowance");
	player:GiveItem(Clockwork.item:CreateInstance("moldy_bread"), true);
	player:GiveItem(Clockwork.item:CreateInstance("moldy_bread"), true);
	player:GiveItem(Clockwork.item:CreateInstance("dirtywater"), true);
	player:GiveItem(Clockwork.item:CreateInstance("dirtywater"), true);
	player:GiveItem(Clockwork.item:CreateInstance("renegade_disciple_robes"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_peppershot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("pop-a-shot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("pop-a-shot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("pop-a-shot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("pop-a-shot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_2h_great_sledge"), true);
	player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Hillkeeper Standard Issue";
	ITEM.model = "models/mosi/fallout4/props/junk/hidebundle.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "hillkeeper_standard_issue";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A thinly sewn pouch containing equipment standard to that of the Hillkeepers.";
	ITEM.weight = 5;
	ITEM.randomWeapons = {"begotten_1h_brokensword", "begotten_1h_pipemace", "begotten_1h_spikedbat", "begotten_1h_spikedboard", "begotten_spear_pitchfork"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local subfaction = player:GetSubfaction();

	Clockwork.player:GiveCash(player, 200, "Hillkeeper Allowance");
	--player:GiveItem(Clockwork.item:CreateInstance("cooked_goat_meat"), true);
	--player:GiveItem(Clockwork.item:CreateInstance("moldy_bread"), true);
	player:GiveItem(Clockwork.item:CreateInstance("purified_water"), true);
	
	if subfaction == "Servus" then
		player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_pipemace"), true);
		player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
		player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
		player:GiveItem(Clockwork.item:CreateInstance("hillkeeper_aketon"), true);
	elseif subfaction == "Outrider" then
		player:GiveItem(Clockwork.item:CreateInstance("backpack_small"), true);
		player:GiveItem(Clockwork.item:CreateInstance("begotten_spear_scrapspear"), true);
		player:GiveItem(Clockwork.item:CreateInstance("handheld_radio"), true);
		player:GiveItem(Clockwork.item:CreateInstance("wanderer_cap"), true);
		player:GiveItem(Clockwork.item:CreateInstance("hillkeeper_aketon"), true);
		player:GiveItem(Clockwork.item:CreateInstance("shield5"), true);
		player:GiveItem(Clockwork.item:CreateInstance("lockpick"), true);
	else
		player:GiveItem(Clockwork.item:CreateInstance(self.randomWeapons[math.random(1, #self.randomWeapons)]), true);
		player:GiveItem(Clockwork.item:CreateInstance("hillkeeper_aketon"), true);
		player:GiveItem(Clockwork.item:CreateInstance("shield5"), true);
		player:GiveItem(Clockwork.item:CreateInstance("bindings"), true);
		if math.random(1, 3) == 1 then
			player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_pilum"), true)
		else
			player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_axehill"), true)
			player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_axehill"), true)
		end
	end
end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Scrapper Grunt Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "scrapper_grunt_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A duffel bag containing equipment standard to the lower ranks of the Scrappers.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("scrapper_grunt_plate"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_helmet"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_spear_scrapspear"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield1"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_scrapbow"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrap_bolt"), true);
	player:GiveItem(Clockwork.item:CreateInstance("bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Scrapper Machinist Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "scrapper_machinist_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A duffel bag containing equipment used by Scrapper Machinists.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("scrapper_machinist_plate"), true);
	player:GiveItem(Clockwork.item:CreateInstance("scrapper_machinist_plate_helmet"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_scrapaxe"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield3"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_2h_great_scraphammer"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Oppressor Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "oppressor_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "Oppressor Kit.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("wanderer_oppressor_armor"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_battleaxe"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield6"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_musket"), true);
	player:GiveItem(Clockwork.item:CreateInstance("longshot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("longshot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("longshot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("longshot"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Wastelord Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "wastelord_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag Containing the Kit of a Wastelord.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("wastelord_helm"), true);
	player:GiveItem(Clockwork.item:CreateInstance("wastelord_armor"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_2h_longsword"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_ironflail"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield6"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bastard Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "bastard_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag Containing the Kit of a Fucking Bastard.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("bastard_gore_spikehelm"), true);
	player:GiveItem(Clockwork.item:CreateInstance("faithling_mail"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_goreshortsword"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_2h_great_heavybattleaxe"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_axe"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_axe"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Peasant Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "peasant_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag Containing the Kit What Little it Provides.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("wanderer_cap"), true);
	player:GiveItem(Clockwork.item:CreateInstance("padded_coat"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_spear_pitchfork"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield5"), true);
	player:GiveItem(Clockwork.item:CreateInstance("stone"), true);
	player:GiveItem(Clockwork.item:CreateInstance("stone"), true);
	player:GiveItem(Clockwork.item:CreateInstance("stone"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Aspirant Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "aspirant_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag Containing the Kit of an Aspirant Satanist.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("skullshield"), true);
	player:GiveItem(Clockwork.item:CreateInstance("elegant_robes"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_scimitar"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield17"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_dagger_irondagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_dagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_dagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_dagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_dagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_javelin_throwing_dagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cannibal Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "cannibal_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag Containing the Kit of a Cannibal.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("skintape_mask"), true);
	player:GiveItem(Clockwork.item:CreateInstance("flayed_fuck_armor"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_machete"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield17"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_2h_quarterstaff"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_dagger_bonedagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("skingauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("skingauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("cooked_human_meat"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Voltist Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "voltist_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "Voltist Kit fuck yeah.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:GiveItem(Clockwork.item:CreateInstance("voltist_exoskeleton"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_voltprod"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield15"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_voltist_railgun"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("volt_projectile"), true);
	player:GiveItem(Clockwork.item:CreateInstance("tech"), true);
	player:GiveItem(Clockwork.item:CreateInstance("tech"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_pouches"), true);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "VillaKeeper Upper Ranks Kit";
	ITEM.model = "models/vj_props/duffle_bag.mdl";
	ITEM.useText = "Open";
	ITEM.uniqueID = "villakeeper_upper_ranks_kit";
	ITEM.useSound = "npc/combine_soldier/zipline_hitground1.wav";
	ITEM.category = "Other";
	ITEM.description = "A Duffel Bag containing equipment for the Prefecture.";
	ITEM.weight = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	Clockwork.player:GiveCash(player, 500, "Prefect Allowance");
	player:GiveItem(Clockwork.item:CreateInstance("fine_gatekeeper_plate"), true);
	player:GiveItem(Clockwork.item:CreateInstance("fine_gatekeeper_helmet"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_1h_spatha"), true);
	player:GiveItem(Clockwork.item:CreateInstance("shield16"), true);
	player:GiveItem(Clockwork.item:CreateInstance("begotten_dagger_irondagger"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("crafted_bandage"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gauze"), true);
	player:GiveItem(Clockwork.item:CreateInstance("gatekeeper_ration"), true);
	player:GiveItem(Clockwork.item:CreateInstance("purified_water"), true);
	player:GiveItem(Clockwork.item:CreateInstance("backpack_small"), true);
end;
-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();