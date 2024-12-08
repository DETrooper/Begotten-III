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
	player:GiveItem(Clockwork.item:CreateInstance("cooked_goat_meat"), true);
	player:GiveItem(Clockwork.item:CreateInstance("moldy_bread"), true);
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