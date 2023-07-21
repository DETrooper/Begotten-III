local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Bronze Ring of Protection";
	ITEM.model = "models/items/magic/ring_basic/ring_copper.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_protection_bronze";
	ITEM.description = "A ring with a mysterious aura, apparently made of bronze. Putting it on your finger makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all damage taken by 5%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 600, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Courier's Ring";
	ITEM.model = "models/items/magic/ring_basic/ring_silver.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_courier";
	ITEM.description = "A silver ring that once belonged to a courier that ran between the county districts. Putting it on your finger makes you feel as though you have more stamina.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ring_protection_silver.png";
	ITEM.charmEffects = "- Increases stamina by 25 points.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Crucifix";
	ITEM.model = "models/begotten/misc/crucifix.mdl";
	ITEM.weight = 0.25;
	ITEM.uniqueID = "crucifix";
	ITEM.description = "A wooden cross with a carved figure of a bearded prophet. Although a relic of a bygone era, you feel as though it still provides some protection from evil.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces any corruption taken by 25%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 350, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Distorted Ring";
	ITEM.model = "models/items/magic/ring_secondchance/ring_secondchance.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_distorted";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel luckier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Has a 5% chance of completely avoiding damage when taking damage from any source.\n- Will prevent your death when taking lethal damage from another player but will shatter beyond repair and become useless when this occurs. Note that this effect is not enabled in duels.\n- Stackable with the 'Lucky' belief.";

	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 900, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Earthing Effigy";
	ITEM.model = "models/begotten/misc/effigy2.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "effigy_earthing";
	ITEM.description = "A rare twig from the Great Tree. It makes you feel grounded and resolute; a reminder of the natural order.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces sanity loss by 25%.\n- Reduces stability loss by 25%.";
	
	ITEM.requiredFaiths = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Embalmed Heart";
	ITEM.model = "models/items/special/l08_momified_heart.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "embalmed_heart";
	ITEM.description = "A mummified heart, embalmed with special care by some ancient civilization.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces blood loss when bleeding by 25%.";
	ITEM.requiredFaiths = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Human Effigy";
	ITEM.model = "models/begotten/misc/effigy1.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "effigy_human";
	ITEM.description = "A bound collection of sticks in the shape of a human. There is a mysterious aura about it, and carrying it on your person makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all limb damage by 50%.";
	
	ITEM.requiredFaiths = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Pummeler's Ring";
	ITEM.model = "models/items/magic/ring_dexterity/ring_dexterity.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_pummeler";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes your strikes feel weightier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases poise damage of all melee weapons by 10%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 725, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Pugilist's Ring";
	ITEM.model = "models/items/magic/ring_strength/ring_strength.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_pugilist";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel significantly stronger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases the damage and poise damage of your fists to four times its original values and gives them 100% armor-piercing damage.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 725, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Gold Ring of Protection";
	ITEM.model = "models/items/magic/ring_basic/ring_gold.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_protection_gold";
	ITEM.description = "A ring with a mysterious aura, apparently made of gold. Putting it on your finger makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all damage taken by 15%.\n- Supersedes the bronze and silver versions of this ring.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 800, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Ring of Fire";
	ITEM.model = "models/items/magic/ring_protectfire/ring_protectfire.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_fire";
	ITEM.description = "A warm ring with a mysterious aura.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Has a 5% chance to set enemies on fire when hit with a melee weapon.\n- Stacks with fire sacrifical weapons for additional ignition time.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Ring of Penetration";
	ITEM.model = "models/items/magic/ring_dexterity/ring_dexterity.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_penetration";
	ITEM.description = "A sharp ring, it digs into your flesh as you put it onto your finger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ring_pummeler.png";
	ITEM.charmEffects = "- Increases armor-piercing damage by 15 points.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Ring of Vitality";
	ITEM.model = "models/items/magic/ring_regeneration/ring_regeneration.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_vitality";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel healthier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases maximum health by 25 points.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Silver Ring of Protection";
	ITEM.model = "models/items/magic/ring_basic/ring_silver.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_protection_silver";
	ITEM.description = "A ring with a mysterious aura, apparently made of silver. Putting it on your finger makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all damage taken by 10%.\n- Supersedes the bronze version of this ring.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1000, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of an Animal";
	ITEM.model = "models/begotten/misc/animalskull.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "skull_animal";
	ITEM.description = "The skull of a stag, likely kept by a Gore as a trophy or as a good luck charm.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Family.";
	ITEM.requiredFaiths = {"Faith of the Family"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of a Demon";
	ITEM.model = "models/items/jewels/cr_shadowskull.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "skull_demon";
	ITEM.description = "The skull of a slain demon, its evil still abounds.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Dark.";
	ITEM.requiredFaiths = {"Faith of the Dark"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of a Saint";
	ITEM.model = "models/begotten/misc/skull.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "skull_saint";
	ITEM.description = "A ritually engraved skull belonging to one of many ancient saints of the Holy Hierarchy. A good omen for those of the Faith of the Light indeed.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Light.";
	ITEM.requiredFaiths = {"Faith of the Light"};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Spine of a Soldier";
	ITEM.model = "models/Gibs/HGIBS_spine.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "spine_soldier";
	ITEM.description = "A fragment of bone from an old soldier with a mysterious aura of strength.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spine.png";
	ITEM.charmEffects = "- Increases your inventory capacity by 25%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1000, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base"); -- Make sure you can't equip this unless you already have any type of Inquisitor Armor equipped (unequipping inquisitor armor should de-equip this item as well). Should require Hard-Glazed subfaith specifically to equip as well. Make it set your 3rd bodygroup to 1 if it is equipped (and make sure it persists after swapping chars). "Moderately increases parry/deflection windows" should be the same bonuses as Impossibly Skilled for Satanists.
	ITEM.name = "Holy Sigils";
	ITEM.model = "models/begotten/misc/holysigils.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "holy_sigils";
	ITEM.description = "A decorated iron buckle with two scraps of scroll cloth torn from the Holy Book of Law, sealed and stamped by the Holy Hierarchy. Wearing these sigils of holy judgement grants supreme authority and righteous conviction to the Inquisitor who deserves it.";
	--ITEM.iconoverride = "materials/begotten/ui/itemicons/spine.png";
	ITEM.charmEffects = "- Requires Inquisitor Armor to be worn.\n- Increases faith gain by 15%.\n- Decreases sanity loss by 50%.\n- Decreases corruption gain by 50%.\n- Increases damage against all non-Hard-Glazed characters by 15%.\n- Moderately increases parry and deflection windows for all melee weapons.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/holy_sigils.png";
ITEM:Register();