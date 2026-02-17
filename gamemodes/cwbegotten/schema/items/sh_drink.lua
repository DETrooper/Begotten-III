local ITEM = Clockwork.item:New();
	ITEM.name = "Carton of Milk";
	ITEM.model = "models/props_junk/garbage_milkcarton002a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Get Milk";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A foul fucking carton of milk, completely fucked by age. It smells fucking disgusting and makes you want to kill yourself.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/milk.png"
	ITEM.stackable = true;
	ITEM.infectchance = 75;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 300, bNoSupercrate = true};
	ITEM.needs = {hunger = 4, thirst = 12};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)		
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You feel fucking disgusted that you just drank something so foul. As a result you begin feel emotionally and mentally unstable.");
			player:HandleSanity(-25);
		end
		
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Willtan's Brew";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.35;
	ITEM.skin = 1;
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A glass bottle filled with a stale, frothy liquid. It reads 'Willtan's Brew'.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;
	ITEM.expireTime = 120;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 600, bNoSupercrate = true};
	ITEM.needs = {thirst = 8};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "olivedrab", "This drink has no taste, but it makes you feel very good.");
		Clockwork.player:SetDrunk(player, self.expireTime)
		player:HandleSanity(5);
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
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;
	ITEM.expireTime = 120;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 600, bNoSupercrate = true};
	ITEM.needs = {thirst = 10};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "olivedrab", "This drink tastes like shit, but it still makes you feel good! How weird!");
		Clockwork.player:SetDrunk(player, self.expireTime)
		player:HandleSanity(10);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Corpsebrew";
	ITEM.model = "models/kali/miscstuff/stalker/food/cossacks vodka.mdl";
	ITEM.weight = 0.35;
	ITEM.useText = "Chug";
	ITEM.description = "An innocuous, polished bottle of a clear liquid. It has a very strong smell.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsebrew.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;
	ITEM.cauldronPoison = true;
	ITEM.expireTime = 30;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 675, bNoSupercrate = true};
	ITEM.needs = {thirst = 35};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "To your merry surprise (or disappointment), the contents of this corpsebrew were actually quite delicious! Furthermore, you feel extra coinage in your pockets! You are truly blessed by the Gods!");
			player:HandleSanity(15);
			Clockwork.player:GiveCash(player, math.random(10, 50), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "maroon", "In some suicidal rage, you decide to chug the corpsebrew. You stop halfway, as you feel your insides melt and your throat ignite.");
			player:ScriptedDeath("Chugged some Corpsebrew and became a corpse.");
		end
		
		Clockwork.player:SetDrunk(player, self.expireTime)
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Dirty Water";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A dust-covered bottle filled partially with dirty water.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle_1.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "dirtywater"
	ITEM.infectchance = 60;
	ITEM.cauldronQuality = -2;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 675, bNoSupercrate = true};
	ITEM.needs = {thirst = 15};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)	
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"), true);
	
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open the bottle and pour water down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);			
			return;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begin to feel light headed and nauseous. You feel like you're gonna throw up.");
			player:HandleSanity(-25);
		end
		
		--player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New("alcohol_base");
	ITEM.name = "Finechug";
	ITEM.model = "models/kali/miscstuff/stalker/food/cossacks vodka.mdl";
	ITEM.weight = 0.35;
	ITEM.description = "A silver-coloured bottle, appearing extremely well preserved. Enticing white wine is kept within.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/corpsebrew.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;
	ITEM.expireTime = 240;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1250};
	ITEM.needs = {hunger = 3, thirst = 35};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "This drink tastes good! You feel really good too!");
		Clockwork.player:SetDrunk(player, self.expireTime)
		player:HandleSanity(20);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Soda";
	ITEM.model = "models/kali/miscstuff/stalker/food/energy drink.mdl";
	ITEM.weight = 0.35;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An off-brand can of soda from the county districts. It would be unwise to consume this in the vicinity of Papa Pete.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/soda.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 0;

	ITEM.infectchance = 10;
	ITEM.dysentery = 5;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 600, bNoSupercrate = true};
	ITEM.needs = {thirst = 12, sleep = 8};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "When you pop open the can, it still has a fizz. It tastes very sweet compared to anything else you've had before. You also feel more energized.");
		player:HandleSanity(2);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Purified Water";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "Can it be? A bottle of fresh water! Miracles do happen, it seems.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 30};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"), true);
	
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open the bottle and pour water down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
	
		Schema:EasyText(player, "lawngreen", "As clean water enters your parched throat, you feel an immense satisfaction knowing that you will not die of disease today.");
		player:HandleSanity(8);
		--player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of an alien liquid, it feels ice cold and fresh though it lacks any sort of refrigeration. Its mere existance disturbs you on an existential level. Regardless, it tastes very good.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1000};
	ITEM.needs = {thirst = 30, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		player:HandleSanity(10);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Pop™, Prize Included!";
	ITEM.uniqueID = "papa_petes_ice_cold_pop_prize_included";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's® Ice Cold Pop™. It advertises a chance of winning a solid golden coin.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 700, bNoSupercrate = true};
	ITEM.needs = {thirst = 35, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You slurp up another classic Papa Pete's Ice Cold Pop! Once you are finished, the bottle starts gushing coins all over! You've hit the jackpot!");
			player:HandleSanity(10);
			Clockwork.player:GiveCash(player, math.random(50, 300), "You win the prize!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "maroon", "You slurp of some of Papa Pete's Ice Cold Pop, but as you do you feel a golden coin lodge itself in your throat! You've won the prize! But now you're about to choke to death.");
			player:ScriptedDeath("Won a prize from a Papa Pete's® Ice Cold Pop™!");
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();


local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Orange-Flavored Ice Cold Pop™";
	ITEM.uniqueID = "papa_petes_orange_flavored_ice_cold_pop";
	ITEM.cost = 15;
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle Papa Pete's® Ice Cold Pop™ with a citrus twist!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1150, bNoSupercrate = true};
	ITEM.needs = {thirst = 30, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Orange-Flavored Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		player:HandleSanity(10);
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
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle Papa Pete's® Ice Cold Pop™ with a grape flavor!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1150, bNoSupercrate = true};
	ITEM.needs = {thirst = 30, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasTrait("marked") and math.random(1, 3) == 1 then
			Clockwork.chatBox:AddInTargetRadius(player, "me", "pops open a bottle of Papa Pete's® Grape-Flavored Ice Cold Pop™, only to have a rigged grapeshot shell explode in their face!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
			Schema:EasyText(Schema:GetAdmins(), "icon16/bomb.png", "tomato", player:Name().." got graped by Papa Pete!");
			
			local filter = RecipientFilter();
			
			if zones then
				filter:AddPlayers(zones:GetPlayersInSupraZone(zones:GetPlayerSupraZone(player)));
			else
				filter:AddAllPlayers();
			end
			
			player:EmitSound("musket/musket4.wav", 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
			local effect = EffectData();
			local Forward = player:GetForward()
			local Right = player:GetRight()
			
			effect:SetOrigin(player:GetShootPos() - (Forward * 65) + (Right * 5));
			effect:SetNormal(-player:GetAimVector());
			util.Effect( "effect_awoi_smoke_pistol", effect );
		
			player:DeathCauseOverride("Got graped by Papa Pete.");
			player:Kill();
			
			if cwGore then
				if (player:GetRagdollEntity()) then
					cwGore:SplatCorpse(player:GetRagdollEntity(), 60);
				end;
			end
			
			return;
		elseif player:HasBelief("favored") then
			player:GiveItem(Clockwork.item:CreateInstance("grapeshot"));
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Grape-Flavored Ice Cold Pop™. Interestingly, you find a loose grapeshot shell inside the bottle. You feel mentally and physically reinvigorated.");
		else
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Grape-Flavored Ice Cold Pop™. You feel mentally and physically reinvigorated.");
		end
		
		player:HandleSanity(10);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Crazy Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_crazy_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's® Ice Cold Crazy Pop™. It advertises the fact that the taste of this Ice Cold Pop™ is so good that it will make you crazy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1150, bNoSupercrate = true};
	ITEM.needs = {thirst = 30, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleStamina(50);

		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You slurp of some of Papa Pete's® Ice Cold Crazy Pop™. You feel refreshed, though your sanity is savagely torn apart.");
			player:HandleSanity(-75);
		end

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
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of Papa Pete's cream. We all scream for Papa Pete's cream!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2000};
	ITEM.needs = {thirst = 35, sleep = 15};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleStamina(80);
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Cream Pop™. It is very creamy and delicious. You feel mentally and physically reinvigorated, and you feel a renewed sense of energy!");
		player:HandleSanity(15);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Meat Pop™";
	ITEM.uniqueID = "papa_petes_meat_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An unusual brand of Papa Pete's Cold Pop. It's filled with a pink slime.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1500};
	ITEM.needs = {hunger = 25, thirst = 20};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Meat Pop™. The meaty taste comes as a surprise, but it fills your tummy up all the same.");
		player:HandleSanity(5);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Ice Cold Ice Pop™";
	ITEM.uniqueID = "papa_petes_ice_cold_ice_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "An incredibly cold Papa Pete's Ice Cold Pop. This one comes with a warning that you might get a brain freeze.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1300, bNoSupercrate = true};
	ITEM.needs = {thirst = 30, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Ice Cold Ice Pop™. Aside from a minor brain freeze, you feel really good!");
			player:AddFreeze(25, player);
			player:HandleSanity(2);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "olive", "You slurp of some of Papa Pete's® Ice Cold Ice Pop™. It tastes good, but you're instantly frozen into a block of ice!");
			player:AddFreeze(100, player);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Pipin' Hot Pop™";
	ITEM.uniqueID = "papa_petes_pipin_hot_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A very hot bottle of Papa Pete's brand. It has red sizzling liquid. It must be very spicy!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1300, bNoSupercrate = true};
	ITEM.needs = {thirst = 40, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleStamina(100);

		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Pipin' Hot Pop™! It has a spicy aftertaste. After you're done drinking, some coins spill out the bottle!");
			player:HandleSanity(10);
			Clockwork.player:GiveCash(player, math.random(25, 100), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "olive", "You slurp of some of Papa Pete's® Pipin' Hot Pop™. It tastes good, but you're engulfed in flames!");
			player:HandleSanity(-15);
			player:Ignite(20);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Silly Pop™";
	ITEM.uniqueID = "papa_petes_silly_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A Papa Pete Cold Pop that states that this funny taste will make you silly!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1750, bNoSupercrate = true};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleStamina(100);

		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Silly Pop™. It tastes alright, and it makes you burst into a fit of laughter afterwards! Your sanity is greatly restored!");
			player:HandleSanity(60);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "olive", "You slurp of some of Papa Pete's® Silly Pop™. It tastes good, but you're now tongue twisted from brain damage!");
			player:GiveTrait("imbecile");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();
--]]

 local ITEM = Clockwork.item:New();
	ITEM.name = "Papa Pete's® Plague Pop™";
	ITEM.uniqueID = "papa_petes_plague_pop";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A Papa Pete Cold Pop that states that claims it tastes so good it'll bring out the end of days for mortal men!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;
	ITEM.cauldronPlague = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {thirst = 60, sleep = 5};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:HandleStamina(100);

		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Plague Pop™. It didn't taste very good, but you feel your pockets grow heavier with coins! The Gods have blessed you!");
			player:HandleSanity(5);
			Clockwork.player:GiveCash(player, math.random(50, 250), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			Schema:EasyText(player, "lawngreen", "You slurp of some of Papa Pete's® Plague Pop™. It tastes pretty good, but you can't help but notice a sore throat as you finish the bottle.");
			player:GiveDisease("begotten_plague", 1, true);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Yum Chug";
	ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
	ITEM.weight = 0.65;
	ITEM.useText = "Chug";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A bottle of yummy chug, it looks like white thick liquid, it must taste very good.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/yumchug.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;
	ITEM.cauldronPoison = true;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 300, bNoSupercrate = true};
	ITEM.needs = {hunger = 0, thirst = 0};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, 60);
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "Instead of chugging the bleach like a moron, you carefully look inside the container and discover a deposit of coinage! How fortunate!");
			player:HandleSanity(5);
			Clockwork.player:GiveCash(player, math.random(5, 40), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			player:HandleSanity(-100);
			player:ScriptedDeath("Chugged the Yum Chug.");
			Schema:EasyText(player, "maroon", "You begin to chug the yummy chug. You feel your throat burn and you lose all ability to taste. You begin to die choking. You fucking idiot.");
			Schema:EasyText(Schema:GetAdmins(), "tomato", player:Name().." chugged the Yum Chug!", nil);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Holy Water";
	ITEM.model = "models/props_junk/glassjug01.mdl";
	ITEM.weight = 0.3;
	ITEM.useText = "Purify Youself";
	ITEM.category = "Drinks"
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle5.wav";
	ITEM.description = "A glass bottle of blessed water. It is said to cleanse all impurities.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/laudanum.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 666, bNoSupercrate = true};
	ITEM.needs = {thirst = 20};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)

		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You drink the contents of the glass bottle. Alas, it is not actually holy water but a hidden flavor of Papa Pete's Ice Cold Pop™! You feel rejuvenated! Also, there's coins too!");
			player:HandleSanity(15);
			Clockwork.player:GiveCash(player, math.random(5, 50), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		else
			player:HandleNeed("corruption", -100);
			player:ScriptedDeath("Cleansed of impurities.");
			player:Ignite(8, 0);
			Schema:EasyText(player, "maroon", "As you chug the Holy Water and it begins to cleanse the impurities in your body, you suddenly realize that nobody in this forsaken world is pure, including yourself. Your very soul ignites and is engulfed in flames.");
			Schema:EasyText(Schema:GetAdmins(), "tomato", player:Name().." drank holy water!", nil);
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Varazdat Bloodwine";
	ITEM.model = "models/props/cs_militia/bottle02.mdl";
	ITEM.weight = 0.3;
	ITEM.useText = "Drink";
	ITEM.category = "Alcohol";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of finely aged wine from the Darklands. It is apparently fermented with human blood, expensive spices, and delicious berries.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle02.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 30, thirst = 50};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "The wine tastes excellent! You are filled with a sense of elevated self-worth.");
		player:HandleSanity(30);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Varazdat Masterclass Bloodwine";
	ITEM.model = "models/props/cs_militia/bottle02.mdl";
	ITEM.weight = 0.3;
	ITEM.useText = "Drink";
	ITEM.category = "Alcohol";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of exotic wine from the Darklands. It is apparently fermented with human blood, expensive spices, and delicious berries. This particular bottle is said to be spiced with the blood of virgin slave-whores and aged for over 300 years.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle02.png"
	ITEM.stackable = true;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 40, thirst = 65};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		Schema:EasyText(player, "lawngreen", "The wine tastes excellent! You are filled with a sense of elevated self-worth.");
		player:HandleSanity(50);
		player:HandleXP(cwBeliefs.xpValues["drink"]);
		
		if !player:HasBelief("favored") then
			if !Schema.poisonedWinePlayers then
				Schema.poisonedWinePlayers = {};
				
				table.insert(Schema.poisonedWinePlayers, player);
			else
				if !table.HasValue(Schema.poisonedWinePlayers, player) then
					table.insert(Schema.poisonedWinePlayers, player);
				end
			end
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Pissjug Chug";
	ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Chug";
	ITEM.category = "Drinks";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A jug of piss - it has been filtered through faulty machines by the Scrappers. It will certainly fill you up, at a slight cost to your mental state..";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/yumchug.png"
	ITEM.stackable = true;
	ITEM.infectchance = 8;
	ITEM.cauldronLiquidity = 1;
	ITEM.cauldronQuality = -1;
	
	ITEM.needs = {thirst = 50};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)	
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open jug and pour piss down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You chug the pissjug. It tastes of salt and misery.");
			player:HandleSanity(-8);
		end
		
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bucket of Purified Water";
	ITEM.model = "models/props_junk/MetalBucket01a.mdl";
	ITEM.weight = 3;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bucket filled with purified water.";
	ITEM.stackable = false;
	ITEM.needs = {thirst = 70};
	ITEM.uniqueID = "purified_water_bucket";
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/bucket.png"
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Clockwork.chatBox:AddInTargetRadius(player, "me", "brings a bucket of water up to their face, chugging its entire contents uninterrupted.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		
		player:GiveItem(Clockwork.item:CreateInstance("empty_bucket"), true);

		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You pour water down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			--player:TakeDamage(25);
			
			return;
		end
	
		Schema:EasyText(player, "lawngreen", "As clean water enters your parched throat, you feel an immense satisfaction knowing that you will not die of disease today.");
		player:HandleSanity(20);
		--player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bucket of Dirty Water";
	ITEM.model = "models/props_junk/MetalBucket01a.mdl";
	ITEM.weight = 3.2;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bucket filled with dirty water.";
	ITEM.stackable = false;
	ITEM.needs = {thirst = 30};
	ITEM.uniqueID = "dirty_water_bucket";
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/bucket.png"
	ITEM.infectchance = 60;
	ITEM.cauldronQuality = -3;
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Clockwork.chatBox:AddInTargetRadius(player, "me", "brings a bucket of water up to their face, chugging its entire contents uninterrupted.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		
		player:GiveItem(Clockwork.item:CreateInstance("empty_bucket"), true);
		
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You chug the bucket of dirty water, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);
			return;
		end

		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "Cold, vile water from the freezing wasteland travels through your gullet and into your stomach. You feel like you could throw up.");
			player:HandleSanity(-25);
		end
			--player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Blood Bottle";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Drink";
	ITEM.category = "Drinks";
	ITEM.useSound = "ambient/levels/canals/toxic_slime_gurgle4.wav";
	ITEM.description = "A bottle of blood appraised by flesh cultists and bizarros.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bottle_2.png"
	ITEM.stackable = true;
	ITEM.infectchance = 30;
	ITEM.cauldronQuality = -4;
	
	ITEM.needs = {thirst = 25};
	
	function ITEM:OnSetup()
		if cwWarmth and cwWarmth.systemEnabled then
			ITEM:AddData("freezing", 0, true);
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)	
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This drink is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:GiveItem(Clockwork.item:CreateInstance("empty_bottle"), true);
	
		if player:HasBelief("the_paradox_riddle_equation") or player:HasBelief("the_storm") then
			Schema:EasyText(player, "maroon", "You open the bottle and pour blood down your receptacle, but it begins to short-circuit your insides!");
			Schema:DoTesla(player, true);	
			player:HandleSanity(-5);			
			return;
		end
		
		if !player:HasBelief("heart_eater") then
			Schema:EasyText(player, "olive", "The blood oozes out the bottle and down your throat.. You feel repulsed, both physically and spiritually..");
			player:HandleSanity(-50);
			player:HandleXP(cwBeliefs.xpValues["drink"]);
		elseif player:HasBelief("heart_eater") and !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olivedrab", "The blood oozes out the bottle and down your throat.. Even as an experienced drinker of blood, you find the taste and consistency disturbing.");
			player:HandleSanity(-15);
		else
			Schema:EasyText(player, "lawngreen", "The blood oozes out the bottle and down your throat.. Delicious!");
		end
		
		player:HandleXP(cwBeliefs.xpValues["drink"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();