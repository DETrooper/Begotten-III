local ITEM = Clockwork.item:New();
	ITEM.name = "Can of Beans";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Open & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "An old can of beans, it seems to still be sealed although its freshness remains questionable.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 10; -- Chance to give you a disease.
	ITEM.cauldronQuality = 1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 715};
	ITEM.needs = {hunger = 30, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		--player:GiveItem(Clockwork.item:CreateInstance("empty_can"));
		
		Schema:EasyText(player, "olivedrab", "Although long expired and slightly frothy, the beans are still perfectly palatable.");

		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Punctured Can of Beans";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Drink Slop";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A punctured tin can with what used to be beans inside. Now a soupy mix of maggots, mold and disease. Hey, at least it's something to fill your belly.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can_punctured.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 50; -- Chance to give you a disease.
	ITEM.poison = 6; -- Holdover from Begotten II, maybe we can use it.
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 350};
	ITEM.needs = {hunger = 25, thirst = 10};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)	
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You feel fucking disgusted that you just ate something so foul. As a result you begin feel emotionally and mentally unstable.");
			player:HandleSanity(-25);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Moldy Bread";
	ITEM.cost = 8;
	ITEM.model = "models/kali/miscstuff/stalker/food/bread.mdl";
	ITEM.weight = 0.2;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A small loaf of bread, interlaced with mold and dirt.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bread.png"
	ITEM.stackable = true;
	ITEM.infectchance = 15;
	ITEM.poison = 3;
	ITEM.cauldronQuality = 0;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 500};
	ITEM.needs = {hunger = 15};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "The bread is mushy and moldy but it's far better than some of the other food found in the wasteland.");
			player:HandleSanity(-5);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Canned Meal";
	ITEM.cost = 8;
	ITEM.model = "models/kali/miscstuff/stalker/food/tourist's breakfast.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Open & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A dented tin can that supposedly contains beans and sausage, yet it is still sealed, a miracle!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/canned_meal.png"
	ITEM.stackable = true;
	ITEM.cauldronQuality = 1;

	ITEM.itemSpawnerInfo = {category = "Food", rarity = 875};
	ITEM.needs = {hunger = 40, thirst = 10};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Bear Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Bear Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Raw meat harvested from a bear.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "bear_meat"
	ITEM.infectchance = 30;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 25, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begrudgingly consume raw meat.");
			player:HandleSanity(-5);
		end
			
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Bear Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Bear Meat";
	ITEM.useText = "Eat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked bear meat, very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_bear_meat"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 50, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:SetHealth(math.Clamp(player:Health() + 10, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Wolf Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Wolf Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Raw meat harvested from a wolf. It is not very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "wolf_meat"
	ITEM.infectchance = 30;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 5, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begrudgingly consume raw meat.");
			player:HandleSanity(-5);
		end
			
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Wolf Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Wolf Meat";
	ITEM.useText = "Eat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked wolf meat. It is not very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_wolf_meat"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 15, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Leopard Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Leopard Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Raw meat harvested from a leopard.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "leopard_meat"
	ITEM.infectchance = 30;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 25, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begrudgingly consume raw meat.");
			player:HandleSanity(-5);
		end
			
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Leopard Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Leopard Meat";
	ITEM.useText = "Eat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked leopard meat, very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_leopard_meat"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 50, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Deer Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Deer Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Raw meat harvested from a deer.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "deer_meat"
	ITEM.infectchance = 30;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 20, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begrudgingly consume raw meat.");
			player:HandleSanity(-5);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Deer Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Deer Meat";
	ITEM.useText = "Eat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked deer meat, very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_deer_meat"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 45, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Goat Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Goat Meat";
	ITEM.useText = "Eat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked goat meat, very nutritious.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_goat_meat"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 45, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:SetHealth(math.Clamp(player:Health() + 5, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Goat Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Goat Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Raw meat harvested from a goat.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "goat_meat"
	ITEM.infectchance = 30;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 20, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You begrudgingly consume raw meat.");
			player:HandleSanity(-5);
		end
	
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Gatekeeper Ration";
	ITEM.cost = 8;
	ITEM.model = "models/items/provisions/food_ratio/food_ratio02.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Unwrap & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A large chunk of pinkish meat, though well prepared and wrapped for portability. You feel comfortably ignorant of whatever it was previously part of.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gatekeeper_ration.png"
	ITEM.stackable = true;

	ITEM.needs = {hunger = 50, thirst = 15};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		player:HandleSanity(5);
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Raw Human Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Raw Human Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Mutilated bits and pieces from a slaughtered human.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "humanmeat"
	ITEM.infectchance = 50;
	ITEM.poison = 5;
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 35, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You engorge yourself on the fresh meat of another. You question your sanity.");
			player:HandleSanity(-20);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Fucked Meat";
	ITEM.model = "models/gibs/humans/mgib_07.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Fucked Meat";
	ITEM.useText = "Force Down Your Throat";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "This meat is fucked! Or maybe it's not. Could you risk a bite?";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/human_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "fuckedmeat"
	ITEM.infectchance = 50;
	ITEM.poison = 35;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 300};
	ITEM.needs = {hunger = 25, thirst = 0};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You eat the fucked meat and to your suprise, the meat is fucked! You spit out the worms and rot and are left with a sinking feeling of regret.");
			player:HandleSanity(-25);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Unfucked Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.3;
	ITEM.plural = "Unfucked Meat";
	ITEM.useText = "Devour";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Ambiguous meat, possibly some dead animal or worse. It has since been grilled and is somewhat safe to eat.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "unfuckedmeat"
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 40, thirst = 15};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olivedrab", "The meat is flavorful. You feel proud of such an honest meal.");
		player:HandleSanity(10);
		player:SetHealth(math.Clamp(player:Health() + 8, 0, player:GetMaxHealth()));
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Meatmeal";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.6;
	ITEM.useText = "Devour";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "A meal of boiled meat. It will have to do.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "meatmeal"
	
	ITEM.needs = {hunger = 80, thirst = 45};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olivedrab", "An honest meal!");
		player:HandleSanity(30);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
			
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	-- Called when the item entity has spawned.
	--[[function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/flesh");
	end;]]--
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Human Meat";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.35;
	ITEM.plural = "Cooked Human Meat";
	ITEM.useText = "Devour";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Cooked meat from a slaughtered human.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_human_meat"
	ITEM.infectchance = 5;
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 50, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if player:HasBelief("savage") then
			Schema:EasyText(player, "olivedrab", "You enjoy the savory taste of your fellow man.");
			player:HandleSanity(2);
			player:SetHealth(math.Clamp(player:Health() + 3, 0, player:GetMaxHealth()));
		else
			Schema:EasyText(player, "olivedrab", "This meat is prepared almost well enough to forget where it came from.");
			player:HandleSanity(-2);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Punctured Can of Soup";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Drink Slop";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A punctured tin can with what used to be mushroom soup inside. Now a soupy mix of maggots, mold and disease. Hey, at least it's something to fill your belly.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can_punctured.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 50;
	ITEM.poison = 6;
	ITEM.cauldronQuality = 0;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 350};
	ITEM.needs = {hunger = 15, thirst = 30};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "You feel fucking disgusted that you just ate something so foul. As a result you begin feel emotionally and mentally unstable.");
			player:HandleSanity(-25);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Kitty Candy";
	ITEM.cost = 8;
	ITEM.model = "models/kali/miscstuff/stalker/artifacts/eye.mdl";
	ITEM.weight = 0.25;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/kitty_candy.png"
	ITEM.description = "Heres some kitty candy. Hold on.";
	ITEM.stackable = true;
	ITEM.uniqueID = "kittycandy";
	ITEM.cauldronQuality = 0;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 1500};
	ITEM.needs = {hunger = 25};
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "Upon licking the candy, it suddenly morphs into a purifying stone which pulses, granting you great healing and rejuvenating your sanity while lowering your corruption!");
			player:HandleSanity(50);
			player:HandleNeed("corruption", -25);
			player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
			player:HandleXP(cwBeliefs.xpValues["food"]);
		elseif (math.random( 1, 4 ) == 1) then
			player:ScriptedDeath("Had their insides dissolved with acid.");
			Schema:EasyText(player, "olive", "You begin to lick on the Kitty Candy. After a couple licks you notice a foul taste in your mouth... Fuck! This Kitty Candy is acid! The acid begins to burn your fucking tongue and throat.");
			player:HandleSanity(-100);
		else
			Schema:EasyText(player, "lawngreen", "Mmmm! That was one tasty treat! I could go for another Kitty Candy!");
			player:HandleSanity(50);
			player:SetHealth(math.Clamp(player:Health() + 15, 0, player:GetMaxHealth()));
			player:HandleXP(cwBeliefs.xpValues["food"]);
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Canned Yummy Beans";
	ITEM.cost = 8;
	ITEM.model = "models/kali/miscstuff/stalker/food/tourist's breakfast.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "An open can with some decomposed beans and flesh-eating maggots inside. Looks yummy!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/canned_meal.png"
	ITEM.stackable = true;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 350};
	ITEM.needs = {hunger = 50};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
		
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You notice a glimmer of light inside the can, and are rejoiced to discover coins aplenty! Your sanity is restored! You are favored by the Gods!");
			player:HandleSanity(20);
			Clockwork.player:GiveCash(player, math.random(10, 30), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["food"]);
		elseif !player:HasBelief("savage_animal") and (math.random(1, 2) == 1) then
			--player:GiveItem(Clockwork.item:CreateInstance("empty_can"));
			player:ScriptedDeath("Was devoured by flesh eating maggots.");
			player:HandleSanity(-100);
			Schema:EasyText(player, "olive", "You pop open the can and indulge on what you think is good meat. Your fingers tremble as you shove the product in your mouth, and you quickly realise that the product is swarming with flesh eating maggots. You begin to slowly die, being eaten from the inside out.");
		else
			--player:GiveItem(Clockwork.item:CreateInstance("empty_can"));
			Schema:EasyText(player, "lawngreen", "You pop open the can and begin to dine on the Yummy Beans. And wow are they yummy!");
			
			if !player:HasBelief("savage_animal") then
				player:HandleSanity(-50);
			end
			
			player:HandleXP(cwBeliefs.xpValues["food"]);
		end;	
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Canned Yummy Meat";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Open & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A sealed and relatively undamaged tin can with a label that says 'Fresh Meat, Packed Today!'. Yeah, right.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 350};
	ITEM.needs = {hunger = 50};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		local playerPos = player:GetPos();

		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "You notice a glimmer of light inside the can, and are rejoiced to discover coins aplenty! Your sanity is restored! You are favored by the Gods!");
			player:HandleSanity(25);
			Clockwork.player:GiveCash(player, math.random(10, 30), "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["food"]);
		else
			player:ScriptedDeath("Became canned meat.");
			Schema:EasyText(player, "maroon", "You pop open the can, and suddenly a hand springs forth from inside and grabs you! It's pulling you inside and won't let go! FUCK!");
			
			timer.Simple(11, function()
				if IsValid(player) then
					Clockwork.chatBox:AddInTargetRadius(player, "me", "is suddenly grabbed by a hand extended from the can they are holding! They are violently forced inside, screaming as their body crunches sickeningly to fit inside the can! Holy shit!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					
					for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get())) do
						if v:IsPlayer() then
							if !v:HasBelief("savage_animal") then
								v:HandleSanity(-50);
							end
						end
					end
				end
			end);
			
			timer.Simple(11.5, function()
				if IsValid(player) then
					local ragdollEntity = player:GetRagdollEntity();
					
					if !player:Alive() and ragdollEntity then
						ragdollEntity:Remove();
					end
					
					Clockwork.entity:CreateItem(nil, "canned_fresh_meat", Vector(playerPos.x, playerPos.y, playerPos.z + 64));
					
					Schema:EasyText(Schema:GetAdmins(), "tomato", player:Name().." was taken by a can!", nil);
				end
			end);
		end;
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Canned Fresh Meat";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Open & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A sealed and relatively undamaged tin can with a label that says 'Fresh Meat, Packed Today!'. It is covered in blood and you can hear faint screaming eminating from inside.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.cauldronQuality = -1;
	
	ITEM.needs = {hunger = 50};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olivedrab", "The taste is a bit odd but the meat is certainly fresh.");
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Neat Yummy Meat";
	ITEM.cost = 8;
	ITEM.model = "models/kali/miscstuff/stalker/food/diet sausage.mdl";
	ITEM.weight = 0.2;
	ITEM.useText = "Devour";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A sliced slap of slop, looks real neat and juicy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/neat_yummy_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "neatmeat";
	ITEM.infectchance = 50;
	ITEM.poison = 10;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 350};
	ITEM.needs = {hunger = 25, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if player:HasBelief("favored") then
			Schema:EasyText(player, "lawngreen", "The neat yummy meat was indeed yummy. Furthermore, your sanity is rejuvenated and you cough up a few coins!");
			Clockwork.player:GiveCash(player, 12, "Blessed coins!");
			player:HandleXP(cwBeliefs.xpValues["food"]);
		else
			local DeathMethods = {
			"You bite down into the slop of meat, and directly after the surge of taste, you feel a striking pain as a rusty infected nail is impaled in the roof of your fucking mouth, expertly hidden in the meat itself. You're doomed to die from infection, if you don't bleed out from your mouth first.",
			"You sink your teeth into the yummy chunk of meat, and directly after the surge of taste, you feel a dreadful feeling as you realize a long strip of rusty, infected barbwire is cutting up your fucking mouth. There is blood everywhere, holy shit. You are doomed to die of an infection if you don't bleed out from your mouth first.",
			"You begin to chow down on the scrumptious hunk of meat, only something is not right. You begin to feel movement in your mouth as you realize a collection of flesh eating maggots are now eating their way out of your mouth. They begin to feast on your tongue and cheeks, as they burrow in and out of you. You are doomed to die from these little fuckers. Good job.",
			"You bite into the meat, and begin to savor its flavor before the sound of a loud crunch gets your attention. You then realize that you just bit into a fucking poisonous cockroach, and you are doomed to die of its toxins soon.",
			"You dig into your yummy meat, only to recoil and freeze at a sudden pain in your mouth. You then realize that a rusty, infected razorblade has made its way into your mouth and has cut off your fucking tongue! You're destined to die a slow and painful death by infection, if the loss of your tongue doesnt kill you first.",
			"You begin to chomp up the yummy meat before you begin to notice its foul fucking taste. You realize that this meat is tainted! And you are doomed to die a slow death via the toxins you have just ingested. Good job bud."
			}
	
			if !player:HasBelief("savage_animal") and math.random(1, 4) == 1 then
				player:ScriptedDeath("Bit off more than they could chew.");
				Schema:EasyText(player, "olive", DeathMethods[math.random(1, #DeathMethods)]);
				player:HandleSanity(-100);
			else
				Schema:EasyText(player, "olive", "Mmmmm. That was some good yummy meat!");
				player:HandleXP(cwBeliefs.xpValues["food"]);
			end;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Yummy Meat";
	ITEM.model = "models/kali/miscstuff/stalker/food/diet sausage.mdl";
	ITEM.weight = 0.2;
	ITEM.plural = "Cooked Yummy Meat";
	ITEM.useText = "Devour";
	ITEM.useSound = "npc/barnacle/barnacle_crunch3.wav";
	ITEM.category = "Food";
	ITEM.description = "Some indistinguishable meat that has recently been boiled in an attempt to get cleanse it of vile hosts.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/neat_yummy_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "cooked_yummy_meat"
	
	ITEM.needs = {hunger = 50, thirst = 10};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olive", "The meat did not taste good.");
		player:HandleXP(cwBeliefs.xpValues["food"]);
		player:SetHealth(math.Clamp(player:Health() + 3, 0, player:GetMaxHealth()));
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Cooked Canned Goodies";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "An opened can of recently cooked food. It smells appetising.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "masterclass_yummy_meal"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 90, thirst = 75};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "You consume the meal. It was an excellent cuisine!");
		player:HandleXP(cwBeliefs.xpValues["food"]);
		player:SetHealth(math.Clamp(player:Health() + 10, 0, player:GetMaxHealth()));
		player:HandleSanity(30);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "King's Meal";
	ITEM.model = "models/items/provisions/ham_dry/ham_dry.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "A proper meal befitting a King. It is composed of cooked meat from various hunted animals.";
	ITEM.iconoverride = "begotten/ui/itemicons/cooked_meat.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "kings_meal"
	ITEM.cauldronQuality = 1;
	
	ITEM.needs = {hunger = 100, thirst = 100};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "You consume the meal. It was excellent!");
		player:HandleXP(cwBeliefs.xpValues["food"]);
		player:HandleSanity(100);
		player:SetHealth(math.Clamp(player:Health() + 50, 0, player:GetMaxHealth()));
		player:HandleStamina(50);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Wanderer's Delight";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "To hell with the maggots and disease! The Wanderer makes do and finds excellent cuisine from a rotting world.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "wanderers_delight"
	
	ITEM.needs = {hunger = 70, thirst = 60};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "You consume the meal. It tasted decent!");
		player:HandleXP(cwBeliefs.xpValues["food"]);
		player:HandleSanity(80);
		player:SetHealth(math.Clamp(player:Health() + 25, 0, player:GetMaxHealth()));
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Crazy Can";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "A can of strange edibles. It tastes so good it'll drive you crazy!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can_punctured.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 50;
	ITEM.poison = 30;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 300};
	ITEM.needs = {hunger = 15, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)	
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "The contents of the can have left you emotionally scarred and mentally deranged.");
			player:HandleSanity(-95);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Pickle Surprise";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Open & Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "Where's the pickle?";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 10;
	ITEM.cauldronQuality = 0;
	
	--ITEM.itemSpawnerInfo = {category = "Food", rarity = 2500};
	ITEM.needs = {hunger = 50, thirst = 25};

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		--player:GiveItem(Clockwork.item:CreateInstance("empty_can"));
		
		Schema:EasyText(player, "olivedrab", "You eat the Pickle Surprise. It tasted good, but you're struck with fear as you realize there that there was no pickle.");
		Schema:EasyText(Schema:GetAdmins(), "tomato", player:Name().." has eaten a Pickle Surprise!", nil);

		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Scrapper Slop";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "A horrible combination of fungi, alcohol and boiled flesh. A meal fit for carrion.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "scrapper_slop"
	ITEM.cauldronQuality = 0;
	
	ITEM.needs = {hunger = 45, thirst = 35};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "You fucking devour the horrible slop. It turns out it wasn't as bad as advertised.");
		player:HandleXP(cwBeliefs.xpValues["food"]);
		player:HandleSanity(5);
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Shitstew";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "Disgusting in texture, flavor and smell. This horrid concoction is just barely considered 'food'. Your stomach growls.. do you truly wish to partake?.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "shitstew"
	ITEM.customFunctions = {"Smell Contents"};
	ITEM:AddData("isPlagued", false, true);
	ITEM:AddData("isPoisoned", false, true)
	
	ITEM.needs = {hunger = 20, thirst = 5};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olivedrab", "You fucking devour the horrible slop. Despite its horrid taste, it manages to fill your gut up a little.");
		player:HandleXP(cwBeliefs.xpValues["food"]);

		if self:GetData("isPoisoned") then
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a poisoned stew!");
			player:GiveDisease("poisoned");
		end

		if self:GetData("isPlagued") then
			player:GiveDisease("begotten_plague");
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a plagued stew!");
		end
	end

	function ITEM:OnCustomFunction(player, name)
		if name == "Smell Contents" then
			if (self:GetData("isPlagued") or self:GetData("isPoisoned")) and player:HasBelief('culinarian') then
				Schema:EasyText(player, "olive", "The stew doesn't smell quite right, even given its nature of being a bunch of random things thrown together...");
			else
				Schema:EasyText(player, "olivedrab", "The stew's repulsive odor violently attacks your nostrils.");
			end
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Blandstew";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "Adequate and warm. The bland taste is overwhelmingly neutral. Still, serviceable. Your stomach won't disagree or jump for joy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "blandstew"
	ITEM.customFunctions = {"Smell Contents"};
	ITEM:AddData("isPlagued", false, true);
	ITEM:AddData("isPoisoned", false, true)
	
	ITEM.needs = {hunger = 35, thirst = 15};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "olivedrab", "You devour the stew. It's completely unremarkable the whole way through.");
		player:HandleXP(cwBeliefs.xpValues["food"]);

		if self:GetData("isPoisoned") then
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a poisoned stew!");
			player:GiveDisease("poisoned");
		end

		if self:GetData("isPlagued") then
			player:GiveDisease("begotten_plague");
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a plagued stew!");
		end
	end

	function ITEM:OnCustomFunction(player, name)
		if name == "Smell Contents" then
			if (self:GetData("isPlagued") or self:GetData("isPoisoned")) and player:HasBelief('culinarian') then
				Schema:EasyText(player, "olive", "The stew doesn't smell quite right, even given its nature of being a bunch of random things thrown together...");
			else
				Schema:EasyText(player, "lightslateblue", "The stew doesn't have any remarkable smell to it at all.");
			end
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Finestew";
	ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.category = "Food";
	ITEM.description = "A warm and delectable assortment. This stew must taste divine, if the smell is anything to go by. It has your gut jumping for joy.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can.png"
	ITEM.stackable = true;
	ITEM.uniqueID = "finestew"
	ITEM.customFunctions = {"Smell Contents"};
	ITEM:AddData("isPlagued", false, true);
	ITEM:AddData("isPoisoned", false, true)
	
	ITEM.needs = {hunger = 60, thirst = 30};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		Schema:EasyText(player, "lawngreen", "You devour the stew. It is, by far, the greatest thing you ever have and ever will put in your mouth. Your stomach will thank you for days to come.");
		player:HandleXP(cwBeliefs.xpValues["food"]);

		if self:GetData("isPoisoned") then
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a poisoned stew!");
			player:GiveDisease("poisoned");
		end

		if self:GetData("isPlagued") then
			player:GiveDisease("begotten_plague");
			Clockwork.player:NotifyAdmins("operator", player:Name().." has eaten a plagued stew!");
		end
	end

	function ITEM:OnCustomFunction(player, name)
		if name == "Smell Contents" then
			if (self:GetData("isPlagued") or self:GetData("isPoisoned")) and player:HasBelief('culinarian') then
				Schema:EasyText(player, "olive", "The stew doesn't smell quite right, even given its nature of being a bunch of random things thrown together...");
			else
				Schema:EasyText(player, "lawngreen", "The stew smells delicious, and you can't wait to eat it!");
			end
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Anal Slop";
	ITEM.cost = 8;
	ITEM.model = "models/props_junk/garbage_metalcan002a.mdl";
	ITEM.weight = 0.8;
	ITEM.useText = "Eat";
	ITEM.category = "Food";
	ITEM.useSound = "npc/barnacle/barnacle_crunch2.wav";
	ITEM.description = "Awful, FUCKED BEANS! This horrible paste was likely created by Scrappers to be fed to their slaves. It is just enough to keep them alive.. or is it?";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/can_punctured.png"
	ITEM.stackable = true;
	ITEM.infectionchance = 15;
	ITEM.poison = 30;
	ITEM.cauldronQuality = -1;
	
	ITEM.itemSpawnerInfo = {category = "Food", rarity = 500};
	ITEM.needs = {hunger = 25, thirst = 25};
	
	if cwWarmth then
		ITEM:AddData("freezing", 0, true);
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local freezing = self:GetData("freezing");
		
		if freezing and freezing > 25 then
			Schema:EasyText(player, "lightslateblue", "This food is frozen solid and needs to be thawed before it can be consumed!");
		
			return false;
		end
	
		if !player:HasBelief("savage_animal") then
			Schema:EasyText(player, "olive", "The contents of the can were so awful that you feel physically abused - throatfucked with an aftertaste that will never go away.. You no longer crave, only starve.");
			player:HandleSanity(-15);
		end
		
		player:HandleXP(cwBeliefs.xpValues["food"]);
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();