--[[
	Begotten III: Jesus Wept
--]]

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Ampoule";
	ITEM.useText = "Inject";
	ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
	ITEM.weight = 0.15;
	ITEM.description = "A glass vial filled with a mysterious clear liquid that can be injected into someone for a burst of energy...";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/syringe.png"
	ITEM.useSound = "begotten/items/meat_inject.mp3";
	ITEM.uniqueID = "ampoule"
	
	ITEM.applicable = true;
	ITEM.healAmount = 10;
	ITEM.healDelay = 5;
	ITEM.healRepetition = 5;
	ITEM.canSave = false; -- Behavior overriden in OnUsed.
	ITEM.restoresBlood = 1000;
	ITEM.useXP = 10;
	ITEM.useTime = 1;

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 1200};
	ITEM.limbs = "all";
	
	-- Called when the player uses the item.
	function ITEM:OnUsed(player, itemEntity)
		--local action = Clockwork.player:GetAction(player);
		--[[local curTime = CurTime();
		
		player:SetCharacterData("painpills", curTime + 60);]]--
		player:HandleStamina(100);
		--player:GivePoise(player:GetMaxPoise());
		player:HandleSanity(25);
		netstream.Start(player, "Stunned", 1);
		netstream.Start(player, "MorphineDream", 60);
		
		--if action == "die" or action == "die_bleedout" then
		if player:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
			if player:Health() < 10 then
				player:SetHealth(10);
			end
			
			Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER);
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", "jolts awake!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		end
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Black Syringe";
	ITEM.useText = "Inject";
	ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
	ITEM.weight = 0.15;
	ITEM.description = "A syringe that hosts something...";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blacksyringe.png"
	ITEM.useSound = "begotten/items/meat_inject.mp3";
	ITEM.uniqueID = "blacksyringe"
	
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 2000, supercrateOnly = true};
		
	-- Called when the player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local health = player:Health();
		local curTime = CurTime();
		
		player:GiveDisease("begotten_plague");
		player:HandleStamina(40);
		player:HandleSanity(25);
		Schema:EasyText(player, "olivedrab","It's been done. The plight will take hold in due time.");
		netstream.Start(player, "Stunned", 1);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Antibiotic Paste";
	ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Apply";
	ITEM.useSound = "begotten/ui/sanity_gain.mp3";
	ITEM.description = "An old tube of paste that can be used to stop infections.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ampoule.png"
	ITEM.uniqueID = "antibiotic_paste"
	
	ITEM.applicable = true;

	ITEM.curesInjuries = {"infection", "minor_infection"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 675};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
	ITEM.useXP = 25;
	
	function ITEM:OnUsed(player, itemEntity)
		Schema:EasyText(player, "olivedrab","You apply the antibiotic paste to your wound.");
		netstream.Start(self, "Stunned", 2);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Antibiotics";
	ITEM.model = "models/healthvial_nmrih.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Drink";
	ITEM.useSound = "npc/barnacle/barnacle_gulp1.wav";
	ITEM.description = "A rarity indeed! These ancient capsules are renowned for their ability to stop most diseases or cure infections.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/antibiotics.png"
	ITEM.uniqueID = "antibiotics"

	ITEM.ingestible = {orally = true, anally = false};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 800};
	ITEM.useXP = 50;
	
	function ITEM:OnUsed(player, itemEntity)
		if player:Alive() and !player:IsRagdolled() then
			Schema:EasyText(player, "olivedrab","You swallow what few pills remain in the bottle, hoping it will cure your ailments.");
			
			if player:HasDisease("common_cold") or player:HasDisease("flu") then
				player:TakeDisease("common_cold");
				player:TakeDisease("flu");
			end
			
			Clockwork.player:SetMenuOpen(player, false);
			
			if cwBeliefs then
				player:HandleXP(self.useXP);
			end
			
			player:HandleSanity(10);
			player:EmitSound(self.useSound);
			player:TakeItem(self, true);
		end
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Black Remedy";
	ITEM.model = "models/weapons/w_oil.mdl";
	ITEM.weight = 0.2;
	ITEM.useText = "Drink";
	ITEM.useSound = "npc/barnacle/barnacle_gulp1.wav";
	ITEM.description = "A nasty soupy mix in a black jar. Could it be a cure to the Plague?";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/small_oil.png";
	ITEM.uniqueID = "black_remedy"

	ITEM.ingestible = {orally = true, anally = false};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 1500, supercrateOnly = true};
	ITEM.useXP = 100;
	
	function ITEM:OnUsed(player, itemEntity)
		if player:Alive() and !player:IsRagdolled() then
			Schema:EasyText(player, "olivedrab","You slurp the disgusting drink, hoping that it will remove what plagues you. After a short time, you feel your mind clear and your skin lighten.");
			
			if player:HasDisease("begotten_plague") then
				player:TakeDisease("begotten_plague");
			end
			
			Clockwork.player:SetMenuOpen(player, false);
			
			if cwBeliefs then
				player:HandleXP(self.useXP);
			end
			
			player:HandleSanity(100);
			player:EmitSound(self.useSound);
			player:TakeItem(self, true);
		end
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Bloody Fucked Bandage";
	ITEM.model = "models/kali/miscstuff/stalker/aid/bandage.mdl";
	ITEM.weight = 0.1;
	ITEM.useText = "Apply";
	ITEM.useSound = "ambient/voices/citizen_beaten4.wav";
	ITEM.description = "This bandage roll is fucked. It's bloody, stained, and likely to give you an infection.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bandage.png"
	ITEM.uniqueID = "bandage"
	
	ITEM.applicable = true;
	ITEM.healAmount = 2;
	ITEM.healDelay = 2;
	ITEM.healRepetition = 5;
	ITEM.stopsBleeding = true;
	ITEM.infectionChance = 80;

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 70};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Gauze";
	ITEM.model = "models/healthvial_gauze.mdl";
	ITEM.weight = 0.2;
	ITEM.useText = "Apply";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A roll of heavy-duty gauze which can be wrapped around wounds, it can be used to treat gashes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/gauze.png"
	ITEM.uniqueID = "gauze"
	
	ITEM.applicable = true;
	ITEM.healAmount = 4;
	ITEM.healDelay = 2;
	ITEM.healRepetition = 5;
	ITEM.stopsBleeding = true;
	ITEM.infectionChance = 30;
	ITEM.useXP = 15;
	ITEM.useTime = 10;

	ITEM.curesInjuries = {"gash"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 225};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Skingauze";
	ITEM.model = "models/mosi/fnv/props/gore/gorehead01.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Apply";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A roll of thick skin wrapped around a human spine. It can be used to treat gashes, but at what cost?";
	ITEM.iconoverride = "begotten/ui/itemicons/skingauze.png"
	ITEM.uniqueID = "skingauze"
	
	ITEM.applicable = true;
	ITEM.healAmount = 4;
	ITEM.healDelay = 2;
	ITEM.healRepetition = 5;
	ITEM.stopsBleeding = true;
	ITEM.infectionChance = 50;
	ITEM.useXP = 15;
	ITEM.useTime = 10;

	ITEM.curesInjuries = {"gash"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 300};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};

	-- Called when a player uses the item.
	function ITEM:OnUsed(player, itemEntity)
		Schema:EasyText(player, "olive","The damp skin of another is wrapped around your wounds. There is something deeply disturbing about this act, which troubles your sanity.");
		player:HandleSanity(-10);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Laudanum";
	ITEM.model = "models/props_junk/glassjug01.mdl";
	ITEM.weight = 0.3;
	ITEM.useText = "Drink";
	ITEM.description = "A bottle of laudanum. This will clear one's mind, giving them a better grasp of reality.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/laudanum.png"
	ITEM.uniqueID = "laudanum";
	ITEM.useSound = "begotten/ui/sanity_gain.mp3";

	ITEM.healAmount = 5;
	ITEM.healDelay = 4;
	ITEM.healRepetition = 5;
	
	ITEM.ingestible = {orally = true, anally = false};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 250};
	ITEM.useXP = 25;
	
	function ITEM:OnUsed(player, itemEntity)
		if player:Alive() and !player:IsRagdolled() then
			Clockwork.player:SetMenuOpen(player, false);
			
			if cwBeliefs then
				player:HandleXP(self.useXP);
			end
			
			player:HandleSanity(100);
			player:EmitSound(self.useSound);
			player:TakeItem(self, true);
			
			netstream.Start(player, "Stunned", 3);
		end
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Crafted Bandage";
	ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl";
	ITEM.weight = 0.1;
	ITEM.useText = "Apply";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A makeshift bandage created with stitched-together pieces of scavenged cloth. It isn't much but it can help stop bleeding and is less likely to infect wounds compared to many alternatives.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skintape.png"
	ITEM.uniqueID = "crafted_bandage"
	
	ITEM.applicable = true;
	ITEM.healAmount = 3;
	ITEM.healDelay = 2;
	ITEM.healRepetition = 5;
	ITEM.stopsBleeding = true;
	ITEM.infectionChance = 15;
	ITEM.useXP = 8;

	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Ointment";
	ITEM.model = "models/mosi/fallout4/props/junk/components/adhesive.mdl";
	ITEM.weight = 0.5;
	ITEM.useText = "Apply";
	ITEM.useSound = "begotten/ui/sanity_gain.mp3";
	ITEM.description = "A bottle of old ointment for use in treating burn injuries.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ointment.png"
	ITEM.uniqueID = "ointment"
	
	ITEM.applicable = true;
	ITEM.healAmount = 5;
	ITEM.healDelay = 4;
	ITEM.healRepetition = 2;
	ITEM.infectionChance = 25;
	ITEM.useXP = 15;

	ITEM.curesInjuries = {"burn", "frostbite"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 700, bNoSupercrate = true};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
	
	function ITEM:OnUsed(player, itemEntity)
		Schema:EasyText(player, "olivedrab","The ointment is applied to your skin. It stings like hell, but hopefully it will work.");
		netstream.Start(self, "Stunned", 2);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Skintape";
	ITEM.model = "models/cofprops/skintape.mdl";
	ITEM.weight = 0.2;
	ITEM.access = "v";
	ITEM.useText = "Mend";
	ITEM.useSound = "begotten/items/skintape.ogg";
	ITEM.description = "A packet of skin that can be used to replace dead flesh and patch up bleeding wounds.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skintape2.png"
	ITEM.uniqueID = "skintape";
	
	ITEM.applicable = true;
	ITEM.healAmount = 4;
	ITEM.healDelay = 4;
	ITEM.healRepetition = 5;
	ITEM.infectionChance = 50;
	ITEM.stopsBleeding = true;
	ITEM.useXP = 5;
	
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 200};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};

	-- Called when a player uses the item.
	function ITEM:OnUsed(player, itemEntity)
		Schema:EasyText(player, "olive","The damp skin of another is applied to your wounds. There is something deeply disturbing about this act, which troubles your sanity.");
		player:HandleSanity(-10);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Makeshift Splint";
	ITEM.model = "models/Gibs/wood_gib01b.mdl"; -- find a good model later
	ITEM.weight = 1;
	ITEM.useText = "Place";
	ITEM.useSound = "begotten/items/first_aid.wav";
	ITEM.description = "A makeshift splint made using a plank of wood and some lengths wire.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/splint.png"
	ITEM.uniqueID = "splint"
	
	ITEM.applicable = true;
	ITEM.useXP = 5;

	ITEM.curesInjuries = {"broken_bone"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 125};
	ITEM.limbs = {HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Survival Pack";
	ITEM.model = "models/items/healthkit_nmrih.mdl";
	ITEM.weight = 3;
	ITEM.access = "v";
	ITEM.useText = "Heal";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "An unopened pack full of medical supplies. Is it too good to be true?!";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/survival_pack.png"
	ITEM.uniqueID = "survivalpack"
	
	ITEM.applicable = true;
	ITEM.healAmount = 25;
	ITEM.healDelay = 8;
	ITEM.healRepetition = 8;
	ITEM.stopsBleeding = true;
	ITEM.canSave = true;
	ITEM.useXP = 50;
	ITEM.useTime = 30;

	ITEM.curesInjuries = {"burn", "frostbite", "gash", "gunshot_wound", "minor_infection"};
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 4500};
	ITEM.limbs = "all";
	
	-- Called when a player uses the item.
	function ITEM:OnUsed(player, itemEntity)
		Schema:EasyText(player, "olivedrab","The medical supplies in this pouch are bountiful, you are clearly divinely favored this day! You are able to heal all of your wounds.");
		player:HandleSanity(10);
	end;
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Scalpel";
	ITEM.model = "models/gibs/metal_gib4.mdl";
	ITEM.weight = 0.25;
	ITEM.access = "v";
	ITEM.useText = "Cut";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A rusty scalpel for surgical incisions.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scalpel.png"
	ITEM.uniqueID = "scalpel"
	
	ITEM.applicable = true;
	ITEM.useOnSelf = false;
	ITEM.isSurgeryItem = true;

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 600, bNoSupercrate = true};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Forceps";
	ITEM.model = "models/downpour/scissors01_m0_ah.mdl";
	ITEM.weight = 0.25;
	ITEM.access = "v";
	ITEM.useText = "Clamp";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A rusty pair of forceps that can be used to remove objects from the site of an incision.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/forceps.png"
	ITEM.uniqueID = "forceps"
	
	ITEM.applicable = true;
	ITEM.useOnSelf = false;
	ITEM.isSurgeryItem = true;

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 600, bNoSupercrate = true};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New("medical_base");
	ITEM.name = "Suture";
	ITEM.model = "models/props_junk/cardboard_box004a.mdl";
	ITEM.weight = 0.25;
	ITEM.access = "v";
	ITEM.useText = "Stitch";
	ITEM.useSound = "bandaging_1.wav";
	ITEM.description = "A box containing thread and a needle for stiching up wounds.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/box.png"
	ITEM.uniqueID = "suture"
	
	ITEM.applicable = true;
	ITEM.useOnSelf = false;
	ITEM.isSurgeryItem = true;

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 900, bNoSupercrate = true};
	ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Chloroform";
	ITEM.model = "models/props_junk/garbage_newspaper001a.mdl";
	ITEM.weight = 0.1;
	ITEM.useText = "Knock Out";
	ITEM.category = "Medical";
	ITEM.description = "Using this on somebody will knock them out cold for a few minutes.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/chloroform.png"
	ITEM.stackable = true;

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player.isChloroforming) then
			Schema:EasyText(player, "peru", "You are already tying a character!");
			
			return false;
		else
			local trace = player:GetEyeTraceNoCursor();
			local target = Clockwork.entity:GetPlayer(trace.Entity);
			
			if (target and target:Alive()) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					local canChloroform = (target:GetAimVector():DotProduct(player:GetAimVector()) > 0);
					local chloroformTime = 5;
					
					if cwBeliefs and player:HasBelief("doctor") then
						chloroformTime = 2.5;
					end
					
					if (canChloroform or target:IsRagdolled()) then
						Clockwork.player:SetAction(player, "chloroform", chloroformTime);
						
						target:SetNetVar("beingChloro", true);
						
						Clockwork.player:EntityConditionTimer(player, target, trace.Entity, chloroformTime, 192, function()
							local canChloroform = (target:GetAimVector():DotProduct(player:GetAimVector()) > 0);
							
							if ((canChloroform or target:IsRagdolled()) and player:Alive() and !player:IsRagdolled()) then
								return true;
							end;
						end, function(success)
							if (success) then
								player.isChloroforming = nil;
								
								Clockwork.player:SetRagdollState(target, RAGDOLL_KNOCKEDOUT, 240);
								
								player:TakeItem(self, true);
							else
								player.isChloroforming = nil;
							end;
							
							Clockwork.player:SetAction(player, "chloroform", false);
							
							if (IsValid(target)) then
								target:SetNetVar("beingChloro", false);
							end;
						end);
					else
						Schema:EasyText(player, "firebrick", "You cannot use chloroform characters that are facing you!");
						
						return false;
					end;
					
					Clockwork.player:SetMenuOpen(player, false);
					
					player.isChloroforming = true;
					
					return false;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
					
					return false;
				end;
			else
				Schema:EasyText(player, "grey","That is not a valid character!");
				
				return false;
			end;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 1000, bNoSupercrate = true};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Tech";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/mosi/fallout4/props/junk/components/circuitry.mdl";
	ITEM.weight = 0.2;
	ITEM.uniqueID = "tech";
	ITEM.description = "Ancient circuitry from machines which have long surpassed their purpose. This is of great value to Voltists.";
	ITEM.useSound = "physics/plastic/plastic_barrel_break1.wav";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 55};
	
	if cwMedicalSystem then
		ITEM.useText = "Apply";
		ITEM.applicable = true;
		ITEM.isMedical = true;
		ITEM.useOnSelf = true; -- Can use on self.
		ITEM.limbs = {HITGROUP_CHEST, HITGROUP_HEAD, HITGROUP_STOMACH, HITGROUP_LEFTARM, HITGROUP_RIGHTARM, HITGROUP_LEFTLEG, HITGROUP_RIGHTLEG};
		ITEM.curesInjuries = {"burn", "gash", "gunshot_wound"};
		
		ITEM.canSave = true; -- Can save people in critical condition.
		ITEM.healAmount = 5; -- Amount of HP healed per repetition.
		ITEM.healDelay = 2; -- Delay between repetitions.
		ITEM.healRepetition = 5; -- # of repetitions.
		ITEM.morphine = false; -- Has morphine effects.
		ITEM.stopsBleeding = true; -- Stops bleeding.
		ITEM.isSurgeryItem = false; -- Is it a surgery item?
		
		-- Called when a player uses the item.
		function ITEM:OnUseCustom(player, itemEntity, hitGroup)
			if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false and self.useOnSelf ~= false then
				if player:HasBelief("the_paradox_riddle_equation") then
					local action = Clockwork.player:GetAction(player);
						
					if (action == "heal") then
						Schema:EasyText(player, "peru", "Your character is already healing!");
						
						return false;
					elseif (action == "healing") then
						Schema:EasyText(player, "peru", "You are already healing somebody!");
						
						return false;
					elseif (action == "performing_surgery") then
						Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
						
						return false;
					else
						Clockwork.player:SetMenuOpen(player, false);
						
						cwMedicalSystem:PlayerUseMedical(player, self, hitGroup);
						--Clockwork.plugin:Call("PlayerUseMedical", player, self, hitGroup);
					end;
				else
					local d = DamageInfo()
					d:SetDamage(5 * math.Rand(0.5, 1));
					d:SetAttacker(player);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 48));
					
					player:TakeDamageInfo(d);
					
					player:TakeItem(self, true);
					
					Schema:EasyText(player, "olive", "You stab yourself with the circuitry!");
				end
			end;
		end;
		
		-- Called when a player uses the item.
		function ITEM:OnUseTarget(player, target, itemEntity, hitGroup)
			if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false then
				if target:HasBelief("the_paradox_riddle_equation") then
					local action = Clockwork.player:GetAction(player);
						
					if (action == "heal") then
						Schema:EasyText(player, "peru", "Your character is already healing!");
						
						return false;
					elseif (action == "healing") then
						Schema:EasyText(player, "peru", "You are already healing somebody!");
						
						return false;
					elseif (action == "performing_surgery") then
						Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
						
						return false;
					else
						Clockwork.player:SetMenuOpen(player, false);
						
						if !self.isSurgeryItem then
							cwMedicalSystem:HealPlayer(player, target, self, hitGroup);
							--Clockwork.plugin:Call("HealPlayer", player, target, self, hitGroup);
						else
							cwMedicalSystem:PerformSurgeryOnPlayer(player, target, self, hitGroup);
						end
					end;
				end;
			end;
		end;
		
		-- Called when a player drops the item.
		function ITEM:OnDrop(player, position)
			local action = Clockwork.player:GetAction(player);
				
			if (action == "heal") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while healing!");
				
				return false;
			elseif (action == "healing") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while healing somebody!");
				
				return false;
			elseif (action == "performing_surgery") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while performing surgery on someone!");
				
				return false;
			end;
		end;
	end
	
	if ITEM.customFunctions then
		table.insert(ITEM.customFunctions, "Consume");
	else
		ITEM.customFunctions = {"Consume"};
	end
	
	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			if (name == "Consume") then
				if player:HasBelief("jacobs_ladder") then
					local condition = self:GetCondition() or 100;
					local malus = condition / 100;
					
					player:HandleNeed("sleep", -50 * malus);
					player:HandleNeed("corruption", -40 * malus);
					player:HandleXP(80 * malus);
					player:TakeItem(self, true);
					player:EmitSound("physics/plastic/plastic_barrel_break1.wav");
				else
					local d = DamageInfo()
					d:SetDamage(10 * math.Rand(0.5, 1));
					d:SetAttacker(player);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 64));
					
					player:TakeDamageInfo(d);
					player:TakeItem(self, true);
					
					Schema:EasyText(player, "olive", "You shove the circuitry in your mouth and fuck up your teeth!");
				end
			end;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Technocraft";
	ITEM.category = "Crafting Materials";
	ITEM.model = "models/props/cs_office/computer_caseb_p7a.mdl";
	ITEM.weight = 1;
	ITEM.uniqueID = "technocraft";
	ITEM.description = "An amalgamation of ancient technology thrown together.";
	ITEM.useSound = "physics/plastic/plastic_barrel_break1.wav";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/"..ITEM.uniqueID..".png";
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Crafting Materials", rarity = 700, supercrateOnly = true};
	
	if cwMedicalSystem then
		ITEM.useText = "Apply";
		ITEM.applicable = true;
		ITEM.isMedical = true;
		ITEM.useOnSelf = true; -- Can use on self.
		ITEM.limbs = "all";
		ITEM.curesInjuries = {"burn", "gash", "gunshot_wound"};
		
		ITEM.canSave = true; -- Can save people in critical condition.
		ITEM.healAmount = 25; -- Amount of HP healed per repetition.
		ITEM.healDelay = 8; -- Delay between repetitions.
		ITEM.healRepetition = 8; -- # of repetitions.
		ITEM.morphine = false; -- Has morphine effects.
		ITEM.stopsBleeding = true; -- Stops bleeding.
		ITEM.isSurgeryItem = false; -- Is it a surgery item?
		
		-- Called when a player uses the item.
		function ITEM:OnUseCustom(player, itemEntity, hitGroup)
			if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false and self.useOnSelf ~= false then
				if player:HasBelief("the_paradox_riddle_equation") then
					local action = Clockwork.player:GetAction(player);
						
					if (action == "heal") then
						Schema:EasyText(player, "peru", "Your character is already healing!");
						
						return false;
					elseif (action == "healing") then
						Schema:EasyText(player, "peru", "You are already healing somebody!");
						
						return false;
					elseif (action == "performing_surgery") then
						Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
						
						return false;
					else
						Clockwork.player:SetMenuOpen(player, false);
						
						cwMedicalSystem:PlayerUseMedical(player, self, hitGroup);
						--Clockwork.plugin:Call("PlayerUseMedical", player, self, hitGroup);
					end;
				else
					local d = DamageInfo()
					d:SetDamage(5 * math.Rand(0.5, 1));
					d:SetAttacker(player);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 48));
					
					player:TakeDamageInfo(d);
					
					Schema:EasyText(player, "olive", "You stab yourself with the circuitry!");
				end
			end;
		end;
		
		-- Called when a player uses the item.
		function ITEM:OnUseTarget(player, target, itemEntity, hitGroup)
			if (Clockwork.plugin:Call("PlayerCanUseMedical", player, self)) ~= false then
				if target:HasBelief("the_paradox_riddle_equation") then
					local action = Clockwork.player:GetAction(player);
						
					if (action == "heal") then
						Schema:EasyText(player, "peru", "Your character is already healing!");
						
						return false;
					elseif (action == "healing") then
						Schema:EasyText(player, "peru", "You are already healing somebody!");
						
						return false;
					elseif (action == "performing_surgery") then
						Schema:EasyText(player, "peru", "You are already performing surgery on someone!");
						
						return false;
					else
						Clockwork.player:SetMenuOpen(player, false);
						
						if !self.isSurgeryItem then
							cwMedicalSystem:HealPlayer(player, target, self, hitGroup);
							--Clockwork.plugin:Call("HealPlayer", player, target, self, hitGroup);
						else
							cwMedicalSystem:PerformSurgeryOnPlayer(player, target, self, hitGroup);
						end
					end;
				end
			end;
		end;
		
		-- Called when a player drops the item.
		function ITEM:OnDrop(player, position)
			local action = Clockwork.player:GetAction(player);
				
			if (action == "heal") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while healing!");
				
				return false;
			elseif (action == "healing") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while healing somebody!");
				
				return false;
			elseif (action == "performing_surgery") then
				Schema:EasyText(player, "firebrick", "You cannot drop this while performing surgery on someone!");
				
				return false;
			end;
		end;
	end
	
	if ITEM.customFunctions then
		table.insert(ITEM.customFunctions, "Consume");
	else
		ITEM.customFunctions = {"Consume"};
	end
	
	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			if (name == "Consume") then
				if player:HasBelief("jacobs_ladder") then
					local condition = self:GetCondition() or 100;
					local malus = condition / 100;
					
					player:HandleNeed("sleep", -200 * malus);
					player:HandleNeed("corruption", -200 * malus);
					player:HandleXP(500 * malus);
					player:TakeItem(self, true);
					player:EmitSound("physics/plastic/plastic_barrel_break1.wav");
				else
					local d = DamageInfo()
					d:SetDamage(10 * math.Rand(0.5, 1));
					d:SetAttacker(player);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 64));
					
					player:TakeDamageInfo(d);
					player:TakeItem(self, true);
					
					Schema:EasyText(player, "olive", "You shove the circuitry in your mouth and fuck up your teeth!");
				end
			end;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
ITEM:Register();
