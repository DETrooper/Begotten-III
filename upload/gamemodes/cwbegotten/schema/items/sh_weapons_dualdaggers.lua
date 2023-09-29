local ITEM = Clockwork.item:New("weapon_base");
	ITEM.name = "Dual Kinisger Daggers";
	ITEM.model = "models/items/weapons/daggers_collector/daggers_collector.mdl";
	ITEM.weight = 1.5;
	ITEM.uniqueID = "begotten_dualdagger_kinisger";
	ITEM.category = "Melee";
	ITEM.description = "A blackhat assassin's twin tools of visceral murder. It has likely claimed many lives, from serfs to Emperors. A twisted magic prevents anyone not of the correct bloodline from wielding these daggers.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/kinisger_dagger_dual.png"
	ITEM.meleeWeapon = true;

	ITEM.components = {breakdownType = "breakdown", items = {"begotten_dagger_housekinisgerancestraldagger", "begotten_dagger_housekinisgerancestraldagger"}}; -- use "breakdown" for other type
	
	ITEM.attributes = {"concealable"};
	ITEM.onerequiredbelief = {"man_become_beast", "murder_artform"};
	ITEM.requireSubfaction = {"Kinisger"};
ITEM:Register();