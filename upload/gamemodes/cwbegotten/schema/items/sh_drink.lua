local ITEM = Clockwork.item:New();
	ITEM.name = "Carton of Milk";
	ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Get Milk";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A foul fucking carton of milk, completely fucked by age. It smells fucking disgusting and makes you want to kill yourself.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/milk.png"
	ITEM.stackable = true;
	ITEM.infectchance = 75;
	ITEM.poison = 15;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 800};
	ITEM.needs = {hunger = 10, thirst = 15};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:SetHealth( math.Clamp(player:Health() - 25, 0, 100));
		--player:GiveItem(Clockwork.item:CreateInstance("empty_milk_carton"));
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You feel fucking disgusted that you just drank something so foul. As a result you begin feel emotionally and mentally unstable.");
			player:HandleSanity(-25);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Willtan's Brew";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.6;
	ITEM.skin = 1;
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A glass bottle filled with a stale, frothy liquid. It reads 'Willtan's Brew'.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {hunger = 5, thirst = 15};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		Schema:EasyText(player, "olivedrab", "This drink has no taste, but it makes you feel very good.");
		player:HandleSanity(25);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Old Beer";
	ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
	ITEM.weight = 0.5;
	ITEM.description = "A brown colored bottle containing very old and stale beer. Still drinkable, though.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/beer.png"
	ITEM.infectchance = 5;
	ITEM.stackable = true;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 800};
	ITEM.needs = {hunger = 10, thirst = 30};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		Schema:EasyText(player, "olivedrab", "This drink tastes like shit, but it still makes you feel good! How weird!");
		player:HandleSanity(15);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Corpsebrew";
	ITEM.model = "models/kali/miscstuff/stalker/food/cossacks vodka.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Chug";
	ITEM.description = "An innocuous, polished bottle of a clear liquid. It has a very strong smell.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsebrew.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 500};
	ITEM.needs = {thirst = 50};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 60);
		Schema:EasyText(player, "maroon", "In some suicidal rage, you decide to chug the corpsebrew. You stop halfway, as you feel your insides melt and your throat ignite.");
		player:ScriptedDeath("Chugged some Corpsebrew and became a corpse.");
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Dirty Water";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A dust-covered bottle filled partially with dirty water.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "dirtywater"
	ITEM.infectchance = 60;
	ITEM.poison = 20;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 700};
	ITEM.needs = {thirst = 30};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:SetHealth( math.Clamp(player:Health() - 50, 0, 100));
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open the bottle and pour water down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begin to feel light headed and nauseous. You feel like you're gonna throw up.");
			player:HandleSanity(-25);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Finechug";
	ITEM.model = "models/kali/miscstuff/stalker/food/cossacks vodka.mdl";
	ITEM.weight = 0.5;
	ITEM.description = "A silver-coloured bottle, appearing extremely well preserved. Enticing white wine is kept within.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsebrew.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {hunger = 5, thirst = 60};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		Schema:EasyText(player, "lawngreen", "This drink tastes good! You feel really good too!");
		player:HandleSanity(40);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Soda";
	ITEM.model = "models/kali/miscstuff/stalker/food/energy drink.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An off-brand can of soda from the county districts. It would be unwise to consume this in the vicinity of Papa Pete.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/soda.png"
	ITEM.stackable = true;

	ITEM.infectchance = 10;
	ITEM.dysentery = 5;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 800};
	ITEM.needs = {hunger = 10, thirst = 30};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_soda_bottle"));
		Schema:EasyText(player, "lawngreen", "When you pop open the can, it still has a fizz. It tastes very sweet compared to anything else you've had before.");
		player:HandleSanity(10);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Purified Water";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "Can it be? A bottle of fresh water! Miracles do happen, it seems.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2000};
	ITEM.needs = {thirst = 80};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open the bottle and pour water down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
	
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		Schema:EasyText(player, "lawngreen", "As clean water enters your parched throat, you feel an immense satisfaction knowing that you will not die of disease today.");
		player:HandleSanity(20);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of an alien liquid, it feels ice cold and fresh though it lacks any sort of refrigeration. Its mere existance disturbs you on an existential level. Regardless, it tastes very good.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		player:HandleSanity(35);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Pop™, Prize Included!";
	ITEM.uniqueID = "papa_petes_ice_cold_pop_prize_included";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's® Ice Cold Pop™. It advertises a chance of winning a solid golden coin.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "maroon", "You slurp of some of Papa Pete's Ice Cold Pop, but as you do you feel a golden coin lodge itself in your throat! You've won the prize! But now you're about to choke to death.");
		player:ScriptedDeath("Won a prize from a Papa Pete's® Ice Cold Pop™!");
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();


local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Orange-Flavored Ice Cold Pop™";
	ITEM.uniqueID = "papa_petes_orange_flavored_ice_cold_pop";
	ITEM.cost = 15;
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle Papa Pete's® Ice Cold Pop™ with a citrus twist!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1350};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Orange-Flavored Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		player:HandleSanity(35);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Grape-Flavored Ice Cold Pop™";
	ITEM.uniqueID = "papa_petes_grape_flavored_ice_cold_pop";
	ITEM.cost = 15;
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle Papa Pete's® Ice Cold Pop™ with a grape flavor!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1350};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Grape-Flavored Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		player:HandleSanity(35);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Crazy Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_crazy_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's® Ice Cold Crazy Pop™. It advertises the fact that the taste of this Ice Cold Pop™ is so good that it will make you crazy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1250};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "olive", "You slurp of some of Papa Pete's® Ice Cold Crazy Pop™. You feel refreshed, though your sanity is savagely torn apart.");
		player:HandleSanity(-75);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Cream Pop™";
	ITEM.uniqueID = "papa_petes_cream_pop";
	ITEM.cost = 20;
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's cream. We all scream for Papa Pete's cream!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1900};
	ITEM.needs = {thirst = 75, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Cream Pop™. It is very creamy. You feel mentally and physically reinvigorated.");
		player:HandleSanity(55);
		player:SetHealth(math.Clamp(player:Health() + 50, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Meat Pop™";
	ITEM.uniqueID = "papa_petes_meat_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An unusual brand of Papa Pete's Cold Pop. It's filled with a pink slime.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2000};
	ITEM.needs = {hunger = 50};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Meat Pop™. The meaty taste comes as a surprise, but it fills your tummy up all the same.");
		player:HandleSanity(20);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Ice Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_ice_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An incredibly cold Papa Pete's Ice Cold Pop. This one comes with a warning that you might get a brain freeze.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Ice Cold Ice Pop™. It tastes good, but you're instantly frozen into a block of ice!");
		player:AddFreeze(100, player);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Pipin' Hot Pop™";
	ITEM.uniqueID = "papa_petes_pipin_hot_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A very hot bottle of Papa Pete's brand. It has red sizzling liquid. It must be very spicy!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Pipin' Hot Pop™. It tastes good, but you're engulfed in flames!");
		player:HandleSanity(-15);
		player:Ignite(20);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Silly Pop™";
	ITEM.uniqueID = "papa_petes_silly_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.business = true;
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A Papa Pete Cold Pop that states that this funny taste will make you silly!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1250};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Silly Pop™. It tastes good, but you're now tongue twisted from brain damage!");
		player:GiveTrait("imbecile");
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();
--]]

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Plague Pop™";
	ITEM.uniqueID = "papa_petes_plague_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.5;
	ITEM.business = true;
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A Papa Pete Cold Pop that states that claims it tastes so good it'll bring out the end of days for mortal men!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2000};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_water_bottle"));
		player:SetCharacterData("stamina", 100);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Plague Pop™. It tastes pretty good!");
		player:GiveDisease("begotten_plague");
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Yum Chug";
	ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Chug";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A bottle of yummy chug, it looks like white thick liquid, it must taste very good.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/yumchug.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 300};
	ITEM.needs = {hunger = 100, thirst = 100};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 60);
		player:HandleSanity(-100);
		player:ScriptedDeath("Chugged the Yum Chug.");
		Schema:EasyText(player, "maroon", "You begin to chug the yummy chug. You feel your throat burn and you lose all ability to taste. You begin to die choking. You fucking idiot.");
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." chugged the Yum Chug!", nil);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Holy Water";
	ITEM.model = "models/props_junk/glassjug01.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Purify Youself";
	ITEM.category = "Drinks"
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle5.wav";
	ITEM.description = "A glass bottle of blessed water. It is said to cleanse all impurities.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/laudanum.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {thirst = 20};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleNeed("corruption", -100);
		player:ScriptedDeath("Cleansed of impurities.");
		player:Ignite(8, 0);
		Schema:EasyText(player, "maroon", "As you chug the Holy Water and it begins to cleanse the impurities in your body, you suddenly realize that nobody in this forsaken world is pure, including yourself. Your very soul ignites and is engulfed in flames.");
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." drank holy water!", nil);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Finechug";
	ITEM.model = "models/kali/miscstuff/stalker/food/cossacks vodka.mdl";
	ITEM.weight = 0.5;
	ITEM.description = "A silver-coloured bottle, appearing extremely well preserved. Enticing white wine is kept within.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsebrew.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {hunger = 5, thirst = 60};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		Schema:EasyText(player, "lawngreen", "This drink tastes good! You feel really good too!");
		player:HandleSanity(40);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Varazdat Bloodwine";
	ITEM.model = "models/props/cs_militia/bottle02.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Drink";
	ITEM.category = "Alcohol";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of finely aged wine from the Darklands. It is apparently fermented with human blood, expensive spices, and delicious berries.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle02.png"
	ITEM.stackable = true;
	
	ITEM.needs = {hunger = 85, thirst = 100};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_soda_bottle"));
		Schema:EasyText(player, "lawngreen", "The wine tastes excellent! You are filled with a sense of elevated self-worth.");
		player:HandleSanity(100);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Varazdat Masterclass Bloodwine";
	ITEM.model = "models/props/cs_militia/bottle02.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Drink";
	ITEM.category = "Alcohol";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of exotic wine from the Darklands. It is apparently fermented with human blood, expensive spices, and delicious berries. This particular bottle is said to be spiced with the blood of virgin slave-whores and aged for over 300 years.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle02.png"
	ITEM.stackable = true;
	
	ITEM.needs = {hunger = 85, thirst = 100};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_soda_bottle"));
		Schema:EasyText(player, "lawngreen", "The wine tastes excellent! You are filled with a sense of elevated self-worth.");
		player:HandleSanity(100);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
		
		if !Schema.poisonedWinePlayers then
			Schema.poisonedWinePlayers = {};
			
			table.insert(Schema.poisonedWinePlayers, player);
		else
			if !table.HasValue(Schema.poisonedWinePlayers, player) then
				table.insert(Schema.poisonedWinePlayers, player);
			end
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Pissjug Chug";
	ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Chug";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A jug of piss - it has been filtered through faulty machines by the Scrappers. It will certainly fill you up, at a slight cost to your mental state..";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/yumchug.png"
	ITEM.stackable = true;
	ITEM.infectchance = 8;
	ITEM.poison = 10;
	
	ITEM.needs = {thirst = 100};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:SetHealth( math.Clamp(player:Health() - 50, 0, 100));
		--player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"));
		
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open jug and pour piss down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You chug the pissjug. It tastes of salt and misery.");
			player:HandleSanity(-8);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();