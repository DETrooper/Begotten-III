local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Abandoned Doll";
	ITEM.model = "models/props_c17/doll01.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "abandoned_doll";
	ITEM.description = "An old child's toy from an age of prosperity long gone. It has seen considerable wear and tear, and yet even still can provide some comfort in these darker times.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces sanity loss by 50%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 600};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Bronze Ring of Protection";
	ITEM.model = "models/items/magic/ring_basic/ring_copper.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_protection_bronze";
	ITEM.description = "A ring with a mysterious aura, apparently made of bronze. Putting it on your finger makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all damage taken by 5%.";
	ITEM.mutuallyExclusive = {"ring_protection_gold", "ring_protection_silver"};
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 600, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Contortionist's Boot";
	ITEM.model = "models/props_junk/Shoe001a.mdl";
	ITEM.weight = 0.35;
	ITEM.uniqueID = "boot_contortionist";
	ITEM.description = "A leather boot that surprisingly has not yet been eaten. Judging by its inscription, it evidently used to belong to an ancient gymnast.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Grants immunity to breaking your legs.\n- Reduces fall damage taken by 50%.\n- Reduces stamina consumption from combat rolling by 25%.\n- Reduces stamina consumption from jumping by 66.6%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 750};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Courier's Ring";
	ITEM.model = "models/items/magic/ring_basic/ring_silver.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_courier";
	ITEM.description = "A silver ring that once belonged to a courier that ran between the county districts. Putting it on your finger makes you feel as though you have more stamina.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ring_courier.png";
	ITEM.charmEffects = "- Reduces stamina drain when sprinting by 25%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Crucifix";
	ITEM.model = "models/begotten/misc/crucifix.mdl";
	ITEM.weight = 0.25;
	ITEM.uniqueID = "crucifix";
	ITEM.description = "A wooden cross with a carved figure of a bearded prophet. Although a relic of a bygone era, you feel as though it still provides some protection from evil.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces any corruption taken by 25%.\n- Reduces corruption taken from sacrificial weapons by 50%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Distorted Ring";
	ITEM.model = "models/items/magic/ring_secondchance/ring_secondchance.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_distorted";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel luckier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Has a 5% chance of completely avoiding damage when taking damage from any source, stackable with the 'Lucky' belief.\n- Will prevent your death when taking lethal damage from another player but will shatter beyond repair and become useless when this occurs.";

	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1500, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Earthing Effigy";
	ITEM.model = "models/begotten/misc/effigy2.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "effigy_earthing";
	ITEM.description = "A rare twig from the Great Tree. It makes you feel grounded and resolute; a reminder of the natural order.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces sanity loss by 25%.\n- Reduces stability loss by 25%.";
	
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Embalmed Heart";
	ITEM.model = "models/items/special/l08_momified_heart.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "embalmed_heart";
	ITEM.description = "A mummified heart, embalmed with special care by some ancient civilization.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces blood loss when bleeding by 50%.\n- Triples the rate of blood regeneration.";
	
	--ITEM.requireFaith = {"Faith of the Dark"};
	--ITEM.kinisgerOverride = true;
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1000};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Evil Eye";
	ITEM.model = "models/mosi/fnv/props/gore/gorehead03.mdl";
	ITEM.weight = 0.1;
	ITEM.uniqueID = "evil_eye";
	ITEM.description = "The detached eyeball of a Begotten thrall. Evil energy radiates from its iris.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases damage against Begotten thralls by 50%.";
	
	--ITEM.requireFaith = {"Faith of the Dark"};
	--ITEM.kinisgerOverride = true;
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Human Effigy";
	ITEM.model = "models/begotten/misc/effigy1.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "effigy_human";
	ITEM.description = "A bound collection of sticks in the shape of a human. There is a mysterious aura about it, and carrying it on your person makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all limb damage by 50%.";
	
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.kinisgerOverride = true;
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Hurler's Talisman";
	ITEM.model = "models/demonssouls/weapons/talisman of beasts.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "hurlers_talisman";
	ITEM.description = "A pointed bronze charm at the end of a chain, reminiscent of the slings of yore.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases throwable and crossbow weapon projectile speed and range by 35%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Lesser Ring of Vitality";
	ITEM.model = "models/items/magic/ring_regeneration/ring_regeneration_lesser.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_vitality_lesser";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel healthier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases maximum health by 15 points.";
	ITEM.mutuallyExclusive = {"ring_vitality"};
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Pummeler's Ring";
	ITEM.model = "models/items/magic/ring_dexterity/ring_dexterity.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_pummeler";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes your strikes feel weightier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases stamina damage of all melee weapons by 15%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1000, onGround = false};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Pugilist's Ring";
	ITEM.model = "models/items/magic/ring_strength/ring_strength.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_pugilist";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel significantly stronger.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases the damage and stamina damage of your fists to four times its original values and gives them 100% armor-piercing damage. Also allows you to parry with your fists.";
	
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
	ITEM.mutuallyExclusive = {"ring_protection_bronze", "ring_protection_silver"};
	
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
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ring_penetration.png";
	ITEM.charmEffects = "- Increases armor-piercing damage by 10 points.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Ring of Vitality";
	ITEM.model = "models/items/magic/ring_regeneration/ring_regeneration.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_vitality";
	ITEM.description = "A ring with a mysterious aura. Putting it on your finger makes you feel healthier.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases maximum health by 25 points. Supersedes the lesser version of this ring.";
	ITEM.mutuallyExclusive = {"ring_vitality_lesser"};
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 700, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Satchel of Denial";
	ITEM.model = "models/props_c17/briefcase001a.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "satchel_denial";
	ITEM.description = "A locked briefcase that appears to be in mint condition. It is warm to the touch.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Upon death your body will evaporate, taking all of your loot with it save for any weapons you have equipped.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 800};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Silver Ring of Protection";
	ITEM.model = "models/items/magic/ring_basic/ring_silver.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "ring_protection_silver";
	ITEM.description = "A ring with a mysterious aura, apparently made of silver. Putting it on your finger makes you feel safer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces all damage taken by 10%.\n- Supersedes the bronze version of this ring.";
	ITEM.mutuallyExclusive = {"ring_protection_bronze", "ring_protection_gold"};
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1000, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of an Animal";
	ITEM.model = "models/begotten/misc/animalskull.mdl";
	ITEM.weight = 0.35;
	ITEM.uniqueID = "skull_animal";
	ITEM.description = "The skull of a stag, likely kept by a Gore as a trophy or as a good luck charm.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Family.";
	ITEM.requireFaith = {"Faith of the Family"};
	ITEM.kinisgerOverride = true;
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of a Demon";
	ITEM.model = "models/items/jewels/cr_shadowskull.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "skull_demon";
	ITEM.description = "The skull of a slain demon, its evil still abounds.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Dark.";
	ITEM.requireFaith = {"Faith of the Dark"};
	ITEM.kinisgerOverride = true;
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Skull of a Saint";
	ITEM.model = "models/begotten/misc/skull.mdl";
	ITEM.weight = 0.35;
	ITEM.uniqueID = "skull_saint";
	ITEM.description = "A ritually engraved skull belonging to one of many ancient saints of the Holy Hierarchy. A good omen for those of the Faith of the Light indeed.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases all faith gain by 25% if you are of the Faith of the Light.";
	ITEM.requireFaith = {"Faith of the Light"};
	ITEM.kinisgerOverride = true;
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Smoldering Head";
	ITEM.model = "models/gibs/gibhead.mdl";
	ITEM.weight = 0.6;
	ITEM.uniqueID = "smoldering_head";
	ITEM.description = "The burned head of a person accused of witchcraft. You can feel it still smoldering in your hands.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Increases burn damage resistance by 50%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 900, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Spine of a Soldier";
	ITEM.model = "models/Gibs/HGIBS_spine.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "spine_soldier";
	ITEM.description = "A fragment of bone from an old soldier with a mysterious aura of strength.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/spine.png";
	ITEM.charmEffects = "- Increases your inventory capacity by 25%.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 900, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Warding Talisman";
	ITEM.model = "models/demonssouls/weapons/talisman of god.mdl";
	ITEM.weight = 0.4;
	ITEM.uniqueID = "warding_talisman";
	ITEM.description = "A talisman inscribed with holy runes, casting a powerful aura that wards off evil spirits.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Reduces corruption gain and sanity loss by 50%.\n- Removes corruption gain from sacrificial weapons entirely.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 350, supercrateOnly = true}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Thermal Implant";
	ITEM.model = "models/gibs/shield_scanner_gib1.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "thermal_implant";
	ITEM.description = "An elegant piece of technology crudely inserted into the occipital lobe, granting technologically enhanced sight.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/thermal_implant.png";
	ITEM.charmEffects = "- Allows the use of thermal and night vision via your Senses.";
	ITEM.requiredSubfaiths = {"Voltism"};
	ITEM.permanent = true;
	
	function ITEM:OnPlayerUnequipped(player, extraData)
		if player:GetSubfaith() == "Voltism" and extraData != "force_unequip" then
			Schema:EasyText(player, "peru", "This implant is fused into your occipital lobe and cannot be unequipped!");
			return false;
		end
		
		if Clockwork.equipment:UnequipItem(player, self) then
			local useSound = self.useSound;
			
			if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				if (useSound) then
					if (type(useSound) == "table") then
						player:EmitSound(useSound[math.random(1, #useSound)]);
					else
						player:EmitSound(useSound);
					end;
				elseif (useSound != false) then
					player:EmitSound("begotten/items/first_aid.wav");
				end;
			end
		end
	end
	
	ITEM.attributes = {"not_unequippable"};
	ITEM.components = {breakdownType = "meltdown", items = {"tech", "tech"}};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Thief's Hand";
	ITEM.model = "models/gibs/pgib_p1.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "thiefs_hand";
	ITEM.description = "The severed hand of a thief, cut to punish their stealing.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Slightly increases the chance of finding loot in containers.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 900, onGround = false}
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Urn of Silence";
	ITEM.model = "models/props_c17/lamp001a.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "urn_silence";
	ITEM.description = "An urn carrying the ashes of a once-great assassin.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Silences all footsteps, some inventory sounds, and the sound of looting containers (but not lockpicking).";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 1250, supercrateOnly = true};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Wrench";
	ITEM.model = "models/props_c17/tools_wrench01a.mdl";
	ITEM.weight = 0.5;
	ITEM.uniqueID = "wrench";
	ITEM.description = "A simple wrench, it can probably be used for something.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.charmEffects = "- Turn valves at the scrap factory 80% faster.";
	
	ITEM.itemSpawnerInfo = {category = "Charms", rarity = 800};
ITEM:Register();

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Holy Sigils";
	ITEM.model = "models/begotten/misc/holysigils.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "holy_sigils";
	ITEM.description = "A decorated iron buckle with two scraps of scroll cloth torn from the Holy Book of Law, sealed and stamped by the Holy Hierarchy. Wearing these sigils of holy judgement grants supreme authority and righteous conviction to the Inquisitor who deserves it.";
	ITEM.charmEffects = "- Requires Inquisitor Armor to be worn.\n- Increases faith gain by 15%.\n- Decreases sanity loss by 50%.\n- Decreases corruption gain by 50%.\n- Increases damage against all non-Hard-Glazed characters by 15%.\n- Moderately increases parry and deflection windows for all melee weapons.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/holy_sigils.png";
	ITEM.kinisgerOverride = true;
	ITEM.requiredSubfaiths = {"Hard-Glazed"};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (self:HasPlayerEquipped(player)) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You already have a charm of this type equipped!")
			end
			
			return false
		end
		
		if self.requiredSubfaiths and not (table.HasValue(self.requiredSubfaiths, player:GetSubfaith())) then
			if !player.spawning then
				Schema:EasyText(player, "chocolate", "You are not of the correct subfaith to wear this!")
			end
			
			return false
		end

		if (player:Alive()) then
			local clothesItem = player:GetClothesEquipped();
			
			if !clothesItem or !clothesItem.bodygroupCharms or !clothesItem.bodygroupCharms[self.uniqueID] then
				Schema:EasyText(player, "peru", "This charm cannot be worn without inquisitor armor!")
				
				return false;
			end
		
			for i, v in ipairs(self.slots) do
				if !player.equipmentSlots[v] then
					Clockwork.equipment:EquipItem(player, self, v);

					return true
				end
			end
	
			if !player.spawning then
				Schema:EasyText(player, "peru", "You do not have an open slot to equip this charm in!")
			end
			
			return false;
		else
			if !player.spawning then
				Schema:EasyText(player, "peru", "You cannot do this action at this moment.")
			end
		end

		return false
	end
	
	function ITEM:OnBodygroupItemUnequipped(player, itemTable)
		if itemTable.bodygroupCharms[self.uniqueID] then
			Clockwork.kernel:ForceUnequipItem(player, self.uniqueID, self.itemID);
		end
	end
	
	function ITEM:OnPlayerUnequipped(player, extraData)
		if Clockwork.equipment:UnequipItem(player, self) then
			local useSound = self.useSound;
			
			if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				if (useSound) then
					if (type(useSound) == "table") then
						player:EmitSound(useSound[math.random(1, #useSound)]);
					else
						player:EmitSound(useSound);
					end;
				elseif (useSound != false) then
					player:EmitSound("begotten/items/first_aid.wav");
				end;
			end
		end
	end
ITEM:Register();

-- Hill shit (charms)

local ITEM = Clockwork.item:New("enchanted_base");
	ITEM.name = "Codex Solis";
	ITEM.model = "models/props_clutter/book_mg03.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "codex_solis";
	ITEM.description = "A gilded leather-bound book with a clasp made of steel. Contained within is an assortment of long forgotten Hard-Glaze canon with the accompanied footnotes and the crazed ramblings of hundreds of ministers prior. Worn visibly on the hip with zeal, one would not wield the righteous authority to preach or chastise the common man without it.";
	ITEM.charmEffects = "- Requires Low Ministry Vestments to be worn.\n- Increases faith gain by 15%.\n- Decreases sanity loss by 50%.\n- Decreases corruption gain by 50%.\n- Increases damage against all non-Hard-Glazed characters by 15%.\n- Moderately increases parry and deflection windows for all melee weapons.\n The Glaze Sees All...";
	ITEM.iconoverride = "materials/begotten_apocalypse/ui/itemicons/book_mg03.png";
	ITEM.kinisgerOverride = true;
	ITEM.requiredSubfaiths = {"Hard-Glazed"};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (self:HasPlayerEquipped(player)) then
			if !player.spawning then
				Schema:EasyText(player, "peru", "You already have a charm of this type equipped!")
			end
			
			return false
		end
		
		if self.requiredSubfaiths and not (table.HasValue(self.requiredSubfaiths, player:GetSubfaith())) then
			if !player.spawning then
				Schema:EasyText(player, "chocolate", "You are not of the correct subfaith to wear this!")
			end
			
			return false
		end

		if (player:Alive()) then
			local clothesItem = player:GetClothesEquipped();
			
			if !clothesItem or !clothesItem.bodygroupCharms or !clothesItem.bodygroupCharms[self.uniqueID] then
				Schema:EasyText(player, "peru", "This charm cannot be worn without Low Ministry garb!")
				
				return false;
			end
		
			for i, v in ipairs(self.slots) do
				if !player.equipmentSlots[v] then
					Clockwork.equipment:EquipItem(player, self, v);

					return true
				end
			end
	
			if !player.spawning then
				Schema:EasyText(player, "peru", "You do not have an open slot to equip this charm in!")
			end
			
			return false;
		else
			if !player.spawning then
				Schema:EasyText(player, "peru", "You cannot do this action at this moment.")
			end
		end

		return false
	end
	
	function ITEM:OnBodygroupItemUnequipped(player, itemTable)
		if itemTable.bodygroupCharms[self.uniqueID] then
			Clockwork.kernel:ForceUnequipItem(player, self.uniqueID, self.itemID);
		end
	end
	
	function ITEM:OnPlayerUnequipped(player, extraData)
		if Clockwork.equipment:UnequipItem(player, self) then
			local useSound = self.useSound;
			
			if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				if (useSound) then
					if (type(useSound) == "table") then
						player:EmitSound(useSound[math.random(1, #useSound)]);
					else
						player:EmitSound(useSound);
					end;
				elseif (useSound != false) then
					player:EmitSound("begotten/items/first_aid.wav");
				end;
			end
		end
	end
ITEM:Register();