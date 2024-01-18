--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local RITUAL = cwRituals.rituals:New("purifying_stone_rite");
	RITUAL.name = "(T2) Purifying Stone Rite";
	RITUAL.description = "Imbueing something with not only purity, but the ability to spread its purified nature to its surroundings is an act of faith practiced by few. Performing this ritual summons a Purifying Stone item. Removes 10 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin", "flagellant", "acolyte", "soothsayer", "heretic"}; -- Tier II Shared Ritual
	
	RITUAL.requirements = {"light_catalyst", "up_catalyst", "up_catalyst"};
	RITUAL.result = {
		["purifying_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = -10; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
		if cwSanity then
			player:HandleSanity(20);
		end
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("yellow_banner_of_quelling");
	RITUAL.name = "(T2) Yellow Banner of Quelling";
	RITUAL.description = "The children flee when they spot the invisible banner. Let the Satanic filth cower when they realize they are now chained to these mortal lands that they have blighted for so long. Performing this ritual prevents helljaunting in a large radius and cloaking in a smaller radius around you for 30 minutes. Be warned that the Children of Satan will be made aware of your presence! Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin", "flagellant", "acolyte"}; -- Tier II Light/Family Ritual
	
	RITUAL.requirements = {"purifying_stone", "xolotl_catalyst", "down_catalyst"};

	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("xolotl_catalyst");
	RITUAL.name = "(T2) Xolotl Catalyst Rite";
	RITUAL.description = "Energy harnessed into stone. It could be used for something greater. Performing this ritual summons a Xolotl Catalyst item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin", "flagellant", "acolyte", "soothsayer", "heretic"}; -- Tier II Shared Ritual
	
	RITUAL.requirements = {"down_catalyst", "up_catalyst", "ice_catalyst"};
	RITUAL.result = {
		["xolotl_catalyst"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("holy_spirit_rite");
	RITUAL.name = "(T2) Holy Spirit Rite";
	RITUAL.description = "Since the death of God, the spirits wander the lands of men. Capture one into stone before it is corrupted with impurity! Performing this ritual summons a Holy Spirit item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"flagellant", "acolyte"}; -- Tier II Faith of the Light Ritual
	
	RITUAL.requirements = {"light_catalyst", "trinity_catalyst", "light_catalyst"};
	RITUAL.result = {
		["holy_spirit"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("tortured_spirit_rite");
	RITUAL.name = "(T2) Tortured Spirit Rite";
	RITUAL.description = "Trap a bright spirit suffering its eternity of agony and utilize it as a source of forbidden power. Performing this ritual summons a Tortured Spirit item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"down_catalyst", "belphegor_catalyst", "belphegor_catalyst"};
	RITUAL.result = {
		["tortured_spirit"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("pentagram_catalyst_rite");
	RITUAL.name = "(T2) Pentagram Catalyst Rite";
	RITUAL.description = "Fear, pain, and the screams of the unhappy crystalized in your palm. Performing this ritual summons a Pentagram Catalyst item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"down_catalyst", "belphegor_catalyst", "down_catalyst"};
	RITUAL.result = {
		["pentagram_catalyst"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("judgement_sigil_rite");
	RITUAL.name = "(Unique) Judgemental Sigil Stone Rite";
	RITUAL.description = "Manifest your hatred and shame into a sigil stone. Performing this ritual summons a Judgemental Sigil Stone. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"extinctionist"}; -- Unique Sol Orthodoxy Ritual
	
	RITUAL.requirements = {"down_catalyst", "light_catalyst", "purifying_stone"};
	RITUAL.result = {
		["judgemental_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("judgement_sigil_vengeful");
	RITUAL.name = "(T3) Vengeful Sigil Stone Rite";
	RITUAL.description = "Manifest your wrath into a sigil stone. Performing this ritual summons a Vengeful Sigil Stone. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"familial_catalyst", "xolotl_catalyst", "purifying_stone"};
	RITUAL.result = {
		["vengeful_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("unholy_sigil_stone_rite");
	RITUAL.name = "(T2) Unholy Sigil Stone Rite";
	RITUAL.description = "You laugh in the face of all that is good and righteous. Performing this ritual summons an Unholy Sigil Stone item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual

	RITUAL.requirements = {"down_catalyst", "belphegor_catalyst", "pentagram_catalyst"};
	RITUAL.result = {
		["unholy_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("fire_sigil_stone_rite");
	RITUAL.name = "(T3) Fire Sigil Stone Rite";
	RITUAL.description = "Create a sigil of flame. Performing this ritual summons a Fire Sigil Stone item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"sorcerer", "watchful_raven", "emissary", "extinctionist"}; -- Tier III Shared Ritual
	
	RITUAL.requirements = {"light_catalyst", "belphegor_catalyst", "xolotl_catalyst"};
	RITUAL.result = {
		["fire_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("ice_sigil_stone_rite");
	RITUAL.name = "(T3) Ice Sigil Stone Rite";
	RITUAL.description = "Create a sigil of ice. Performing this ritual summons an Ice Sigil Stone item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"sorcerer", "watchful_raven", "emissary", "extinctionist"}; -- Tier III Shared Ritual
	
	RITUAL.requirements = {"ice_catalyst", "ice_catalyst", "xolotl_catalyst"};
	RITUAL.result = {
		["ice_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("glazic_sigil_stone_rite");
	RITUAL.name = "(T3) Glazic Sigil Stone Rite";
	RITUAL.description = "Create a sigil of majesty. Performing this ritual summons a Glazic Sigil Stone item. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"emissary"}; -- Hard-Glazed Unique Ritual
	
	RITUAL.requirements = {"holy_spirit", "xolotl_catalyst", "xolotl_catalyst"};
	RITUAL.result = {
		["glazic_sigil_stone"] = {amount = 1},
	};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("a_feast_of_ash_and_twig");
	RITUAL.name = "(T1) A Feast of Ash and Twig";
	RITUAL.description = "A popular rite befitting the peasant's plight. When the offering is made, one's appetite is expanded to include scraps of trash, dirt, or whatever may be found that was previously ill-nutritious indeed. Performing this ritual returns 80% hunger and thirst, as well as 80% blood level. Removes 5 corruption.";
	RITUAL.onerequiredbelief = {"repentant", "disciple"}; -- Tier I Faith of the Light Ritual
	
	RITUAL.requirements = {"up_catalyst", "up_catalyst", "trinity_catalyst"};
	RITUAL.corruptionCost = -5;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;
	
	function RITUAL:OnPerformed(player)
		player:HandleNeed("hunger", -80);
		player:HandleNeed("thirst", -80);
		player:ModifyBloodLevel(4000);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("aura_of_the_mother");
	RITUAL.name = "(T3) Aura of the Mother";
	RITUAL.description = "The Druids can harness their healing powers and extend them to those around them. With each warrior reinvigorated, the war against the root-gnawers rages on. Performing this ritual will passively heal any Faith of the Family characters within talking distance for the next 10 minutes. Incurs 20 corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"familial_catalyst", "pantheistic_catalyst", "purifying_stone"};
	RITUAL.corruptionCost = 20;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 75;

	function RITUAL:OnPerformed(player)
		timer.Create("auraMotherTimer_"..player:EntIndex(), 5, 120, function() 
			if IsValid(player) then
				for k, v in pairs (ents.FindInSphere(player:GetPos(), config.Get("talk_radius"):Get())) do
					if (v:IsPlayer() and v:GetFaith() == "Faith of the Family") then
						v:SetHealth(math.min(v:Health() + 6, v:GetMaxHealth()));
						v:ModifyBloodLevel(150);
					end
				end
			end
		end);

	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("blessing_of_coin");
	RITUAL.name = "(T1) Blessing of Coin";
	RITUAL.description = "Is it truly a favor from the Glaze, or a statistical illusion? It surely won't stop you from offering alms for a bountiful harvest. Performing this ritual increases the amount of coin found in containers for 40 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"repentant", "disciple"}; -- Tier I Faith of the Light Ritual
	
	RITUAL.requirements = {"trinity_catalyst", "up_catalyst", "light_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("bloodhowl");
	RITUAL.name = "(T2) Bloodhowl";
	RITUAL.description = "The thrill of battle empowers you! Performing this ritual will make your war cries restore 90 points of stamina for 40 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin"}; -- Tier II Faith of the Family Ritual
	
	RITUAL.requirements = {"down_catalyst", "familial_catalyst", "pantheistic_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("bloodwings");
	RITUAL.name = "(T3) Bloodwings";
	RITUAL.description = "The skies bleed when the angels flap their wings. Performing this ritual grants the ability to double-jump at the cost of 15 blood for the next 30 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"sorcerer"}; -- Tier III Faith of the Dark Ritual
	RITUAL.requiredBeliefsSubfactionOverride = {["Rekh-khet-sa"] = {"embrace_the_darkness"}}; -- Tier III Faith of the Dark Ritual
	
	RITUAL.requirements = {"belphegor_catalyst", "up_catalyst", "up_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("call_of_the_blood_moon");
	RITUAL.name = "(Unique) Call of the Blood Moon";
	RITUAL.description = "As any primevalist knows, the Blood Moon requires regular sacrifice so that it may be appeased. For those willing to kill for it, the Blood Moon's power over the wasteland can be extended by some time. Performing this ritual will extend the night cycle by fifteen minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"thirst_blood_moon"}; -- Primevalist Unique Ritual
	
	RITUAL.requirements = {"tortured_spirit", "down_catalyst", "pentagram_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 100;
	
	function RITUAL:OnPerformed(player)
		if cwDayNight then
			if cwDayNight.currentCycle == "night" then
				Clockwork.chatBox:Add(player, nil, "event", "You feel the Blood Moon's radiance pulsating, as though it were drawing power from something.");
				Clockwork.datastream:Start(player, "PlaySound", "begotten/ui/sanity_touch.mp3");
			
				for i, v in ipairs(_player.GetAll()) do
					if IsValid(v) and v:HasInitialized() then
						local lastZone = v:GetCharacterData("LastZone");

						if lastZone == "wasteland" or lastZone == "tower" then
							if v ~= player then
								Clockwork.chatBox:Add(v, nil, "event", "You feel the Blood Moon's radiance pulsating, as though it were drawing power from something.");
								Clockwork.datastream:Start(v, "PlaySound", "begotten/ambient/hits/wall_stomp5.mp3");
							end
							
							v:Disorient(3);
							
							for i = 1, 5 do
								timer.Simple(i * 3, function()
									if IsValid(v) then
										Clockwork.datastream:Start(v, "PlaySound", "begotten/ambient/hits/wall_stomp"..tostring(i)..".mp3");
										v:Disorient(3);
									end
								end);
							end
						end
					end
				end
				
				cwDayNight:ModifyCycleTimeLeft(900);
				return true;
			end
		end
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		if cwDayNight then
			if cwDayNight.currentCycle == "night" then
				if cwDayNight.nextCycleTime - CurTime() <= 10 then
					-- Add enough time to complete the ritual!
					cwDayNight:ModifyCycleTimeLeft(10);
				end
				
				return true;
			else
				Schema:EasyText(player, "peru", "The Blood Moon must be out in order for you to perform this ritual!");
				
				return false;
			end
		end
		
		return false;
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("call_to_darkness");
	RITUAL.name = "(T2) Call to Darkness";
	RITUAL.description = "To open oneself whole to a dark host is the ultimate sign of dedication to one's masters. Dark powers commonly use mortals as temporary vessels to more directly carry out their will. Performing this ritual will invite one to use your body as a vessel, and force it to heed your commands. Incurs 40 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"down_catalyst", "down_catalyst", "pentagram_catalyst"};
	RITUAL.corruptionCost = 40;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." has performed the 'Call to Darkness' ritual, meaning that an admin should probably possess them!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("cherished_by_evil");
	RITUAL.name = "(T1) Cherished By Evil";
	RITUAL.description = "Insanity is for the weak, and your soul surely won't be taken without a reasonable sum. Performing this ritual instantly restores your sanity to full, and removes 50 points of corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "witch", "witch_druid"}; -- Tier I Faith of the Dark Ritual
	
	RITUAL.requirements = {"ice_catalyst", "purifying_stone", "elysian_catalyst"};
	RITUAL.corruptionCost = -50;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;
	
	function RITUAL:OnPerformed(player)
		player:HandleSanity(100);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("cloak_of_always_burning");
	RITUAL.name = "(T2) Cloak of Always Burning";
	RITUAL.description = "With an offering of catalysts, runestones and wicker branches you will be infused with a resistance to the natural and unnatural forces of life. Performing this ritual will grant you 100% resistance to fire and ice damage for 40 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin"}; -- Tier II Faith of the Family Ritual
	
	RITUAL.requirements = {"belphegor_catalyst", "ice_catalyst", "familial_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("cries_of_the_drowned_king");
	RITUAL.name = "(T1) Cries of the Drowned King";
	RITUAL.description = "After a long time at sea, you may hear the gurglings and wails of a drowned legend. Make an offering to the Gods and you may heed his wisdom. Performing this ritual will make you unable to lose oxygen while underwater for 1 hour, and during this time you will be able to drink from bodies of water without consequence.";
	RITUAL.onerequiredbelief = {"honor_the_gods", "one_with_the_druids", "the_black_sea", "witch_druid"}; -- Tier I Faith of the Family Ritual
	
	RITUAL.requirements = {"down_catalyst", "down_catalyst", "down_catalyst"};
	--RITUAL.corruptionCost = 5; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("demon_hunter");
	RITUAL.name = "(T1) Demon Hunter";
	RITUAL.description = "Show your hubris, ask for a challenge worthy of your martial prowess! Performing this ritual will give you 25 minutes to slay a random number of thralls, which will then reward you with 1000 faith (experience).";
	RITUAL.onerequiredbelief = {"honor_the_gods", "one_with_the_druids", "the_black_sea", "witch_druid"}; -- Tier I Faith of the Family Ritual
	
	RITUAL.requirements = {"light_catalyst", "elysian_catalyst", "pantheistic_catalyst"};
	--RITUAL.corruptionCost = 5; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;

	function RITUAL:OnPerformed(player)
		player.thrallsToKill = math.random(1, 3);
		
		Schema:EasyText(player, "goldenrod", "You now have 25 minutes to kill "..player.thrallsToKill.." Begotten thralls for your reward.");
		
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." just activated the 'Demon Hunter' ritual! Make sure there are enough thrall NPCs ("..player.thrallsToKill..") for him to kill!");
		if(math.random(1,10) == 1) then Schema:EasyText(GetAdmin(), "tomato", "The die have been cast...by random chance, an admin thrall has been requested to participate in this ritual!"); end

	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("infernal_incursion");
	RITUAL.name = "(T1) Infernal Incursion";
    RITUAL.description = "Loosen the veil between realms and agitate a few demons while you're at it. Preforming this ritual will give you twenty five minutes to slay a random number of thralls, which will then reward you with 1000 faith (experience).";	RITUAL.onerequiredbelief = {"soothsayer", "witch", "witch_druid"}; -- Tier I Faith of the Dark Ritual
	RITUAL.requirements = {"belphegor_catalyst", "pentagram_catalyst", "up_catalyst"};
	--RITUAL.corruptionCost = 5; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 10;
	RITUAL.experience = 5;
	
	function RITUAL:OnPerformed(player)
		player.thrallsToKill = math.random(1, 3);
		
		Schema:EasyText(player, "goldenrod", "You now have 25 minutes to kill "..player.thrallsToKill.." Begotten thralls for your reward.");
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." just activated the 'Infernal Incursion' ritual! Make sure there are enough thrall NPCs ("..player.thrallsToKill..") for him to kill!");
		if(math.random(1,10) == 1) then Schema:EasyText(GetAdmin(), "tomato", "The die have been cast...by random chance, an admin thrall has been requested to participate in this ritual!"); end
		
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("empowered_blood");
	RITUAL.name = "(T2) Empowered Blood";
	RITUAL.description = "Bloodlines mean all to the Children of Satan, especially those which have descent from ancient kings and sorcerers. Those with the purest bloodlines can draw on the strength of their ancestors to temporarily increase their maximum health by 50 for 15 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"pentagram_catalyst", "belphegor_catalyst", "elysian_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		player.maxHealthBoost = 50;
		player:SetMaxHealth(player:GetMaxHealth());
		player:SetHealth(player:Health() + 50);
		
		timer.Create("EmpoweredBloodTimer_"..player:EntIndex(), 900, 1, function()
			if IsValid(player) then
				player.maxHealthBoost = nil;
				
				local maxHealth = player:GetMaxHealth();
				
				player:SetMaxHealth(maxHealth);
				
				if player:Health() > maxHealth then
					player:SetHealth(maxHealth);
				end
				
				Clockwork.hint:Send(player, "The 'Empowered Blood' ritual has worn off...", 10, Color(175, 100, 100), true, true);
			end
		end);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("familial_seed");
	RITUAL.name = "(T1) Familial Seed";
	RITUAL.description = "The Gore Forest is lush and teeming with life when compared to the realms that followers of the Glaze inhabit. Goreic shamans can call upon the magic of the Goreic Forest to help mend their wounds. Performing this ritual will restore 150 health, 60% blood, and heal the specified limb of injuries. Removes 25 corruption.";
	RITUAL.onerequiredbelief = {"honor_the_gods", "one_with_the_druids", "the_black_sea", "witch_druid"}; -- Tier I Faith of the Family Ritual
	
	RITUAL.requirements = {"familial_catalyst", "familial_catalyst", "familial_catalyst"};
	RITUAL.corruptionCost = -25; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;
	
	function RITUAL:OnPerformed(player)
		player.selectingRegrowthLimb = true;
		
		netstream.Start(player, "OpenRegrowthMenu");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("hail_prince_thieves");
	RITUAL.name = "(T1) Hail Be to the Prince of Thieves";
	RITUAL.description = "From the slums of the Darklands to the chaste fields of the County Districts, thieves all pray to the same prince. Performing this ritual makes lockpicking significantly easier and increases the chance of finding loot from locked containers by 10% for the next 30 minutes. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "witch", "witch_druid"}; -- Tier I Faith of the Dark Ritual
	
	RITUAL.requirements = {"down_catalyst", "ice_catalyst", "ice_catalyst"};
	RITUAL.corruptionCost = 5;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 30;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("hear_me");
	RITUAL.name = "(T1) Hear Me";
	RITUAL.description = "You aren't anything at all until you've made yourself known. Performing this ritual grants you 300 faith (experience). Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "witch", "witch_druid"}; -- Tier I Faith of the Dark Ritual
	
	RITUAL.requirements = {"belphegor_catalyst", "belphegor_catalyst", "belphegor_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 300;
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("hellgorge");
	RITUAL.name = "(T1) Hellgorge";
	RITUAL.description = "With just a simple offering, you will be given the smallest of bites from the horn of plenty. It may be enough to sate you, but it will surely leave you with a desire for more. Performing this ritual will instantly reduce your hunger, thirst, and fatigue to zero. It will also reduce your corruption by 15 points.";
	RITUAL.onerequiredbelief = {"soothsayer", "witch", "witch_druid"}; -- Tier I Faith of the Dark Ritual
	
	RITUAL.requirements = {"up_catalyst", "down_catalyst", "belphegor_catalyst"};
	RITUAL.corruptionCost = -15;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;
	
	function RITUAL:OnPerformed(player)
		player:SetNeed("thirst", 0);
		player:SetNeed("hunger", 0);
		player:SetNeed("sleep", 0);
		
		Clockwork.chatBox:Add(player, nil, "itnofake", "An overwhelming rush of relief overcomes you as you feel rejuvenated.");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("holy_powderkeg");
	RITUAL.name = "(T2) Holy Powderkeg";
	RITUAL.description = "Hand me your rifles, lend me your spent pepper-poppers and snapdragons! I will cock, load, pump and magazine every gun of every faithful Philimonjio in our Lord’s army as I was born and bred to do so! Performing this ritual significantly increases reload speed for the next 15 minutes. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"flagellant", "acolyte"}; -- Tier II Faith of the Light Ritual
	
	RITUAL.requirements = {"holy_spirit", "light_catalyst", "trinity_catalyst"};
	RITUAL.corruptionCost = 5; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 50; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("cloak_of_the_black_hat");
	RITUAL.name = "(Unique) Cloak of the Black Hat";
	RITUAL.description = "Any child knows how to hide in the darkness. The Black Hat brings the darkness with them, stalking the halls of the nobility who falsely believe themselves to be safe and sound. They'll never be alone again. Performing this ritual will cause you to go invisible while crouched for the next 30 minutes, but you will be unable to attack while cloaked. Incurs 25 corruption.";
	RITUAL.requiredSubfaction = {"Kinisger"}; -- Subfaction Ritual
	
	RITUAL.requirements = {"pentagram_catalyst", "xolotl_catalyst", "ice_catalyst"};
	RITUAL.corruptionCost = 25; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 15;
	
	function RITUAL:OnPerformed(player)
		player:SetNetVar("kinisgerCloak", true);
		
		timer.Simple(1800, function()
			if IsValid(player) then
				if player:GetNetVar("kinisgerCloak", false) then
					player:SetNetVar("kinisgerCloak", false);
					
					if player.cloaked then
						player:Uncloak();
					end
					
					Clockwork.hint:Send(player, "The 'Cloak of the Black Hat' ritual has worn off...", 10, Color(175, 100, 100), true, true);
				end
			end
		end);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("kinisger_appearance_alteration");
	RITUAL.name = "(Unique) Kinisger Appearance Alteration";
	RITUAL.description = "Members of House Kinisger are masters of infiltration, owing to their use of dark magic and their mutant blood in order to change apperances.";
	RITUAL.requiredSubfaction = {"Kinisger"}; -- Subfaction Ritual
	
	RITUAL.requirements = {"down_catalyst", "down_catalyst", "ice_catalyst"};
	--RITUAL.corruptionCost = 50; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 15;
	RITUAL.isSilent = true;
	
	function RITUAL:OnPerformed(player)
		player.selectingNewAppearance = true;
		
		netstream.Start(player, "OpenAppearanceAlterationMenu");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("apostle_of_many_faces");
	RITUAL.name = "(Unique) Apostle of Many Faces";
	RITUAL.description = "A true blackhat's test of faith; to bear the effigies of pagan and pious faiths that oppose your own. To play the role of a foreign acolyte so well that you fool even the Gods is a mark of a master blackhat! Performing this ritual permanently allows you to equip or use all non-Voltist faith-locked equipment. Incurs 50 corruption.";
	RITUAL.requiredSubfaction = {"Kinisger"}; -- Subfaction Ritual
	
	RITUAL.requirements = {"xolotl_catalyst", "xolotl_catalyst", "xolotl_catalyst"};
	RITUAL.corruptionCost = 50;
	RITUAL.ritualTime = 15;
	
	function RITUAL:OnPerformed(player)
		player:SetCharacterData("apostle_of_many_faces", true);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		if player:GetCharacterData("apostle_of_many_faces") then
			Schema:EasyText(player, "firebrick", "You have already performed this ritual!");
		
			return false;
		end
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("ritual_of_shadow");
	RITUAL.name = "(Unique) Ritual of Shadow";
	RITUAL.description = "Although members of House Rekh-khet-sa cannot normally traverse the surface during daytime, there exists a ritual that can temporarily cloak them in darkness and shield them from light. Performing this ritual will prevent you from taking damage during daytime in the Wasteland for the next 40 minutes. Incurs 25 corruption.";
	RITUAL.requiredSubfaction = {"Rekh-khet-sa"}; -- Subfaction Ritual
	
	RITUAL.requirements = {"light_catalyst", "down_catalyst", "ice_catalyst"};
	RITUAL.corruptionCost = 25;
	RITUAL.ritualTime = 30;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("mark_of_the_devil");
	RITUAL.name = "(T2) Mark of the Devil";
	RITUAL.description = "The fate of those who offend the Dark Lord or His servants is a gruesome and horrific death, for they shall be marked for death by the hands of the Children of Satan. Performing this ritual will mark a character for death, highlighting them to all followers of the Faith of the Dark when nearby. Killing marked characters will give great rewards, especially if they are sacrificed.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"down_catalyst", "pentagram_catalyst", "down_catalyst"};
	--RITUAL.corruptionCost = 30; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 10;
	
	function RITUAL:OnPerformed(player)
		Clockwork.dermaRequest:RequestString(player, "Mark A Character", "Type the name of a character to be marked for death.", nil, function(result)
			local target = Clockwork.player:FindByID(result)
			
			if IsValid(target) then
				if target:Alive() then
					if target:GetFaction() ~= "Children of Satan" then
						Clockwork.dermaRequest:RequestConfirmation(player, "Mark Confirmation", "Are you sure you want to mark "..target:Name().." for death?", function()
							if IsValid(target) and target:Alive() and target:GetFaction() ~= "Children of Satan" then
								target:SetCharacterData("markedBySatanist", true);
								target:SetSharedVar("markedBySatanist", true);
								
								Schema:EasyText(player, "maroon", target:Name().." has been marked for death.");
								Schema:EasyText(GetAdmins(), "tomato", target:Name().." has been marked for death by "..player:Name().."!");
								
								for k, v in pairs (_player.GetAll()) do
									if v:HasInitialized() then
										if v == player or v:GetFaith() == "Faith of the Dark" then
											Clockwork.chatBox:Add(v, nil, "darkwhispernoprefix", player:Name().." calls forth the minions of the Dark Lord, marking the one by the name of "..target:Name().." to be killed for their transgressions.");
										end
									end
								end
								
								if player:GetSubfaction() ~= "Rekh-khet-sa" then
									player:HandleNeed("corruption", 30);
								end
							end
						end);
						
						return true;
					else
						Schema:EasyText(player, "firebrick", "This character is protected by some magical aura and cannot be marked!");
					end
				else
					Schema:EasyText(player, "darkgrey", "The target character is already dead!");
				end
			else
				Schema:EasyText(player, "grey", tostring(result).." is not a valid character!");
			end
		end)
		
		for i = 1, #RITUAL.requirements do
			player:GiveItem(item.CreateInstance(RITUAL.requirements[i]));
		end
		
		return false;
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("mark_of_the_devil_target");
	RITUAL.name = "(T2) Mark of the Devil (Target)";
	RITUAL.description = "The fate of those who offend the Dark Lord or His servants is a gruesome and horrific death, for they shall be marked for death by the hands of the Children of Satan. Performing this ritual will mark a character for death, highlighting them to all followers of the Faith of the Dark when nearby. Killing marked characters will give great rewards, especially if they are sacrificed. This ritual is silent.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"pentagram_catalyst", "down_catalyst", "down_catalyst"};
	--RITUAL.corruptionCost = 30; -- Corruption gets added once the UI is closed.
	RITUAL.ritualTime = 2;
	RITUAL.isSilent = true;
	
	function RITUAL:OnPerformed(player)
		local target = player:GetEyeTraceNoCursor().Entity;
		
		if IsValid(target) and target:IsPlayer() then
			if target:Alive() then
				--if target:GetFaith() ~= "Faith of the Dark" then
				if target:GetFaction() ~= "Children of Satan" then
					if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
						Clockwork.dermaRequest:RequestConfirmation(player, "Mark Confirmation", "Are you sure you want to mark "..target:Name().." for death?", function()
							if IsValid(target) and target:Alive() and target:GetFaction() ~= "Children of Satan" then
								target:SetCharacterData("markedBySatanist", true);
								target:SetSharedVar("markedBySatanist", true);
								
								Schema:EasyText(player, "maroon", target:Name().." has been marked for death.");
								Schema:EasyText(GetAdmins(), "tomato", target:Name().." has been marked for death by "..player:Name().."!");
								
								if player:GetSubfaction() ~= "Rekh-khet-sa" then
									player:HandleNeed("corruption", 30);
								end
							end
						end);
						
						return true;
					else
						Schema:EasyText(player, "firebrick", "This character is too far away!");
					end
				else
					Schema:EasyText(player, "firebrick", "This character is protected by some magical aura and cannot be marked!");
				end
			else
				Schema:EasyText(player, "darkgrey", "The target character is already dead!");
			end
		else
			Schema:EasyText(player, "firebrick", "You must look at a valid character!");
		end
		
		for i = 1, #RITUAL.requirements do
			player:GiveItem(item.CreateInstance(RITUAL.requirements[i]));
		end
		
		return false;
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local target = player:GetEyeTraceNoCursor().Entity;
		
		if IsValid(target) and target:IsPlayer() then
			if target:Alive() then
				--if target:GetFaith() ~= "Faith of the Dark" then
				if target:GetFaction() ~= "Children of Satan" then
					if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
						return true;
					else
						Schema:EasyText(player, "firebrick", "This character is too far away!");
					end
				else
					Schema:EasyText(player, "firebrick", "This character is protected by some magical aura and cannot be marked!");
				end
			else
				Schema:EasyText(player, "darkgrey", "The target character is already dead!");
			end
		else
			Schema:EasyText(player, "firebrick", "You must look at a valid character!");
		end
		
		return false;
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("noble_stature");
	RITUAL.name = "(T2) Noble Stature";
	RITUAL.description = "To show fright to a beast's snarl only invites its fangs. You will stand firm and tall, resolute in the face of savagery. Performing this ritual causes you to take 50% less damage and stability damage while standing completely still. This ritual lasts for 15 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"flagellant", "acolyte"}; -- Tier II Faith of the Light Ritual
	
	RITUAL.requirements = {"ice_catalyst", "down_catalyst", "light_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("payment_of_light");
	RITUAL.name = "(T1) Payment of Light";
	RITUAL.description = "Pick up the shattered remains of God and offer them back to the Glaze of Sol. Performing this ritual grants you 300 faith (experience). Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"repentant", "disciple"}; -- Tier I Faith of the Light Ritual
	
	RITUAL.requirements = {"light_catalyst", "light_catalyst", "light_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 300;
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("perseverance");
	RITUAL.name = "(T2) Perseverance";
	RITUAL.description = "In the Districts, work is unending, back-breaking, and purifying. Performing this ritual doubles the rate of your Stamina regeneration for 40 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"flagellant", "acolyte"}; -- Tier II Faith of the Light Ritual
	
	RITUAL.requirements = {"light_catalyst", "elysian_catalyst", "down_catalyst"};
	RITUAL.corruptionCost = 10; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 25; -- XP gained from performing the ritual.
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("regrowth");
	RITUAL.name = "(T3) Regrowth";
	RITUAL.description = "The Gore Forest is lush and teeming with life when compared to the realms that the followers of the Glaze inhabit. Goreic shamans can call upon the magic of the Goreic Forest to help mend their wounds. Performing this ritual will completely heal you of all injuries, afflictions, and corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"purifying_stone", "familial_catalyst", "up_catalyst"};
	RITUAL.corruptionCost = 0;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		--local max_poise = player:GetMaxPoise();
		local max_stability = player:GetMaxStability();
		local max_stamina = player:GetMaxStamina();
	
		player:ResetInjuries();
		player:TakeAllDiseases();
		player:SetHealth(player:GetMaxHealth() or 100);
		player:SetNeed("thirst", 0);
		player:SetNeed("hunger", 0);
		player:SetNeed("corruption", 0);
		player:SetNeed("sleep", 0);
		player:SetSharedVar("sanity", 100);
		player:SetCharacterData("sanity", 100);
		player:SetCharacterData("Stamina", max_stamina);
		player:SetNWInt("Stamina", max_stamina);
		player:SetCharacterData("stability", max_stability);
		--player:SetCharacterData("meleeStamina", max_poise);
		--player:SetNWInt("meleeStamina", max_poise);
		player:SetNWInt("freeze", 0);
		player:SetBloodLevel(5000);
		player:StopAllBleeding();
		Clockwork.limb:HealBody(player, 100);
		Clockwork.player:SetAction(player, "die", false);
		Clockwork.player:SetAction(player, "die_bleedout", false);
		
		if player:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
			Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
		end
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("regrowth_target");
	RITUAL.name = "(T3) Regrowth (Target)";
	RITUAL.description = "The Gore Forest is lush and teeming with life when compared to the realms that the followers of the Glaze inhabit. Goreic shamans can call upon the magic of the Goreic Forest to help mend their wounds. Performing this ritual will completely heal another character of all injuries, afflictions, and corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"familial_catalyst", "up_catalyst", "purifying_stone"};
	RITUAL.corruptionCost = 0;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local target = player:GetEyeTraceNoCursor().Entity;
		
		if IsValid(target) and target:IsPlayer() then
			if target:Alive() then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					return true;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
				end
			else
				Schema:EasyText(player, "darkgrey", "The target character is already dead!");
			end
		else
			Schema:EasyText(player, "firebrick", "You must look at a valid character!");
		end
		
		return false;
	end;
	function RITUAL:EndRitual(player)
		local target = player:GetEyeTraceNoCursor().Entity;
		
		if IsValid(target) and target:IsPlayer() then
			if target:Alive() then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					--local max_poise = target:GetMaxPoise();
					local max_stability = target:GetMaxStability();
					local max_stamina = target:GetMaxStamina();

					target:ResetInjuries();
					target:TakeAllDiseases();
					target:SetHealth(target:GetMaxHealth() or 100);
					target:SetNeed("thirst", 0);
					target:SetNeed("hunger", 0);
					target:SetNeed("corruption", 0);
					target:SetNeed("sleep", 0);
					target:SetSharedVar("sanity", 100);
					target:SetCharacterData("sanity", 100);
					target:SetCharacterData("Stamina", max_stamina);
					target:SetNWInt("Stamina", max_stamina);
					target:SetCharacterData("stability", max_stability);
					--target:SetCharacterData("meleeStamina", max_poise);
					--target:SetNWInt("meleeStamina", max_poise);
					target:SetNWInt("freeze", 0);
					target:SetBloodLevel(5000);
					target:StopAllBleeding();
					Clockwork.limb:HealBody(target, 100);
					Clockwork.player:SetAction(target, "die", false);
					Clockwork.player:SetAction(target, "die_bleedout", false);
					
					if target:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
						Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
					end
					
					return true;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
				end
			else
				Schema:EasyText(player, "darkgrey", "The target character is already dead!");
			end
		else
			Schema:EasyText(player, "firebrick", "You must look at a valid character!");
		end
		
		return false;
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("aura_of_powderheel");
	RITUAL.name = "(T3) Aura of Powderheel";
	RITUAL.description = "Call upon the power of the Great Tree in times of battle against its enemies to protect you from their non-traditional weaponry. Performing this ritual generates a spherical forcefield for 15 minutes, which reduces bullet damage to everyone around you within talking distance by 70%. Attempting to fire while inside the sphere will guarantee a misfire. Incurs 15 corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"pantheistic_catalyst", "xolotl_catalyst", "xolotl_catalyst"};
	RITUAL.corruptionCost = 15; -- Corruption incurred from performing rituals.
	RITUAL.ritualTime = 10; -- Time it takes for the ritual action bar to complete.
	RITUAL.experience = 75; -- XP gained from performing the ritual.

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("rooting");
	RITUAL.name = "(T1) Rooting";
	RITUAL.description = "When the incessant demonic chanting drives you angry, consider banishing them back to the hells that birthed them. Performing this ritual will remove 45 points of corruption.";
	RITUAL.onerequiredbelief = {"honor_the_gods", "one_with_the_druids", "the_black_sea", "witch_druid"}; -- Tier I Faith of the Family Ritual
	
	RITUAL.requirements = {"pantheistic_catalyst", "familial_catalyst", "familial_catalyst"};
	RITUAL.corruptionCost = -45;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("scornificationism");
	RITUAL.name = "(Unique) Scornificationism";
	RITUAL.description = "You are so utterly hateful of man's sinful nature that you refuse to die without taking sinners with you! Performing this ritual will prevent player or NPC damage from killing you or putting you into critical condition for the next 120 seconds, but you may still be killed or subdued through other means. Incurs 15 corruption.";
	RITUAL.onerequiredbelief = {"extinctionist"}; -- Unique Sol Orthodoxy Ritual
	
	RITUAL.requirements = {"purifying_stone", "light_catalyst", "elysian_catalyst"};
	RITUAL.corruptionCost = 15;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 100;

	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("sprouting");
	RITUAL.name = "(T2) Sprouting";
	RITUAL.description = "There is something to be learned from leaves, dirt, and bone. Performing this ritual will restore 200 health and 100% of blood, as well as healing all injuries. Removes 5 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin"}; -- Tier II Faith of the Family Ritual
	
	RITUAL.requirements = {"pantheistic_catalyst", "pantheistic_catalyst", "pantheistic_catalyst"};
	RITUAL.corruptionCost = -5;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 25;
	
	function RITUAL:OnPerformed(player)
		player:ResetInjuries();
		player:SetHealth(math.min(player:Health() + 200, player:GetMaxHealth()));
		player:SetBloodLevel(5000);
		
		Clockwork.chatBox:Add(player, nil, "itnofake", "An overwhelming rush of relief overcomes you as you feel rejuvenated.");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("soulscorch");
	RITUAL.name = "(Unique) Soulscorch";
	RITUAL.description = "Become a catalyst of mankind's extinction. When you are struck down, the Light will smite them thusly! Performing this ritual will cause you to radiate for 5 minutes, and upon your death you will deal an amount of damage corresponding to your sacrament level to anyone not of the Faith of the Light excluding Voltists (or half if they are) within talking distance. Incurs 15 corruption.";
	RITUAL.onerequiredbelief = {"extinctionist"}; -- Unique Sol Orthodoxy Ritual
	
	RITUAL.requirements = {"light_catalyst", "holy_spirit", "light_catalyst"};
	RITUAL.corruptionCost = 15;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
		Clockwork.chatBox:AddInTargetRadius(player, "me", "begins glowing with divine radiance!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("steel_will");
	RITUAL.name = "(T3) Steel Will";
	RITUAL.description = "Unbroken, undisturbed - the Glaze is with you! Performing this ritual restores your sanity to full, reduces sanity loss by 90%, and makes you immune to the effects of fear for 15 minutes. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"emissary", "extinctionist"}; -- Tier III Faith of the Light Ritual
	
	RITUAL.requirements = {"xolotl_catalyst", "holy_spirit", "light_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;

	function RITUAL:OnPerformed(player)
		player:HandleSanity(100);
		
		Clockwork.chatBox:Add(player, nil, "itnofake", "You feel like your mind is a stalwart fortress!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("enlightenment");
	RITUAL.name = "(T3) Enlightenment";
	RITUAL.description = "You have reached the pinnacle of Glazic understanding. Performing this ritual illuminates a large area around you for 15 minutes with holy light. It will raise the sanity of all Hard-Glazed characters in its light and also burn any Rekh-khet-sa heretics that approach. Incurs 10 corruption.";
	RITUAL.onerequiredbelief = {"emissary", "extinctionist"}; -- Tier III Faith of the Light Ritual
	
	RITUAL.requirements = {"holy_spirit", "light_catalyst", "light_catalyst"};
	RITUAL.corruptionCost = 10;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		player:SetSharedVar("enlightenmentActive", true);
		
		timer.Create("EnlightenmentTimer_"..player:EntIndex(), 900, 1, function()
			if IsValid(player) then
				if player:GetSharedVar("enlightenmentActive", false) then
					player:SetSharedVar("enlightenmentActive", false);
					
					Clockwork.hint:Send(player, "The 'Enlightenment' ritual has worn off...", 10, Color(175, 100, 100), true, true);
				end
			end
		end);
		
		Clockwork.chatBox:Add(player, nil, "itnofake", "You can feel a warm holy light exuding from every orifice in your body!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("summon_demon");
	RITUAL.name = "(T3) Summon Demon";
	RITUAL.description = "Summon a Begotten Thrall that has become the host of a hell demon. It will be hostile towards anyone not of the Faith of the Dark.";
	RITUAL.onerequiredbelief = {"sorcerer"}; -- Tier III Faith of the Dark Ritual
	RITUAL.requiredBeliefsSubfactionOverride = {["Rekh-khet-sa"] = {"embrace_the_darkness"}}; -- Tier III Faith of the Dark Ritual
	
	RITUAL.requirements = {"belphegor_catalyst", "tortured_spirit", "pentagram_catalyst"};
	RITUAL.corruptionCost = 25;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." has performed the 'Summon Demon' ritual, spawning a demon near their position!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) > 192) then
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
	function RITUAL:EndRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			--Schema:EasyText(player, "maroon", "The ground opens up beneath you, and a creature of hell crawls out! What have you done?!");

			--local entity = ents.Create("npc_bgt_otis");
			local entity = ents.Create("npc_bgt_eddie");
			local playerFaith = player:GetFaith();
			
			ParticleEffect("teleport_fx",trace.HitPos, Angle(0,0,0), nil)
			sound.Play("misc/summon.wav",trace.HitPos, 100, 100)
			--entity:SetPos(trace.HitPos);
			
			timer.Simple(0.5, function()
				if IsValid(entity) then
					entity:CustomInitialize();
					entity:Spawn();
					entity:Activate();
					
					entity:AddEntityRelationship(player, D_LI, 99);
					entity.summonedFaith = playerFaith;
					
					for k, v in pairs(_player.GetAll()) do
						if v:GetFaith() == playerFaith then
							entity:AddEntityRelationship(v, D_LI, 99);
						end
					end
					
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos + Vector(0, 0, 64), trace.HitNormal);
					Clockwork.chatBox:AddInTargetRadius(player, "it", "There is a blinding flash of light and thunderous noise as an unholy creature of Hell suddenly appears!", trace.HitPos, config.Get("talk_radius"):Get() * 3);
				end
			end);
		else
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("summon_familiar_bear");
	RITUAL.name = "(T3) Summon Familiar (Bear)";
	RITUAL.description = "Summon a spirit bear from the Gore Forest so that it may do your bidding. It will be hostile towards anyone not of the Faith of the Family. Incurs 15 corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"xolotl_catalyst", "familial_catalyst", "familial_catalyst"};
	RITUAL.corruptionCost = 15;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." has performed the 'Summon Familiar' ritual, spawning a spirit bear near their position!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) > 192) then
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
	function RITUAL:EndRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			--Schema:EasyText(player, "maroon", "The ground opens up beneath you, and a creature of hell crawls out! What have you done?!");

			local entity = ents.Create("npc_drg_animals_bear_spirit");
			local playerFaith = player:GetFaith();
			
			ParticleEffect("teleport_fx",trace.HitPos, Angle(0,0,0), nil)
			sound.Play("misc/summon.wav",trace.HitPos, 100, 100)
			--entity:SetPos(trace.HitPos);
			
			timer.Simple(0.5, function()
				if IsValid(entity) then
					entity:Spawn();
					entity:SetHealth(700);
					entity:Activate(); 
					entity:SetMaterial("models/props_combine/portalball001_sheet")
					entity:AddEntityRelationship(player, D_LI, 99);
					entity.XPValue = 250;
					
					entity.summonedFaith = playerFaith;
					
					for k, v in pairs(_player.GetAll()) do
						if v:GetFaith() == playerFaith then
							entity:AddEntityRelationship(v, D_LI, 99);
						else					
							local faction = v:GetFaction();
							
							if faction == "Goreic Warrior" then
								entity:AddEntityRelationship(v, D_LI, 99);
							end
						end
					end
					
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos + Vector(0, 0, 64), trace.HitNormal);
					Clockwork.chatBox:AddInTargetRadius(player, "it", "There is a blinding flash of light and thunderous noise as a creature of the Gore Forest suddenly appears!", trace.HitPos, config.Get("talk_radius"):Get() * 3);
				end
			end);
		else
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("summon_familiar_leopard");
	RITUAL.name = "(T3) Summon Familiar (Leopard)";
	RITUAL.description = "Summon a spirit leopard from the Gore Forest so that it may do your bidding. It will be hostile towards anyone not of the Faith of the Family. Incurs 15 corruption.";
	RITUAL.onerequiredbelief = {"watchful_raven"}; -- Tier III Faith of the Family Ritual
	
	RITUAL.requirements = {"xolotl_catalyst", "familial_catalyst", "pantheistic_catalyst"};
	RITUAL.corruptionCost = 15;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 50;
	
	function RITUAL:OnPerformed(player)
		Schema:EasyText(GetAdmins(), "tomato", player:Name().." has performed the 'Summon Familiar' ritual, spawning a spirit leopard near their position!");
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) > 192) then
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
	function RITUAL:EndRitual(player)
		local lastZone = player:GetCharacterData("LastZone");
		
		if lastZone == "theater" or lastZone == "tower" then
			if Schema.towerSafeZoneEnabled then
				Schema:EasyText(player, "firebrick", "There is some sort of supernatural force preventing you from doing this here!");
				return false;
			end
		end
		
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			--Schema:EasyText(player, "maroon", "The ground opens up beneath you, and a creature of hell crawls out! What have you done?!");

			local entity = ents.Create("npc_drg_animals_snowleopard_spirit");
			local playerFaith = player:GetFaith();
			
			ParticleEffect("teleport_fx",trace.HitPos, Angle(0,0,0), nil)
			sound.Play("misc/summon.wav",trace.HitPos, 100, 100)
			--entity:SetPos(trace.HitPos);
			
			timer.Simple(0.5, function()
				if IsValid(entity) then
					entity:Spawn();
					entity:SetHealth(475);
					entity:Activate(); 
					entity:SetMaterial("models/props_combine/portalball001_sheet")
					entity:AddEntityRelationship(player, D_LI, 99);
					entity.XPValue = 250;
					
					entity.summonedFaith = playerFaith;
					
					for k, v in pairs(_player.GetAll()) do
						if v:GetFaith() == playerFaith then
							entity:AddEntityRelationship(v, D_LI, 99);
						else					
							local faction = v:GetFaction();
							
							if faction == "Goreic Warrior" then
								entity:AddEntityRelationship(v, D_LI, 99);
							end
						end
					end
					
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos + Vector(0, 0, 64), trace.HitNormal);
					Clockwork.chatBox:AddInTargetRadius(player, "it", "There is a blinding flash of light and thunderous noise as a creature of the Gore Forest suddenly appears!", trace.HitPos, config.Get("talk_radius"):Get() * 3);
				end
			end);
		else
			Schema:EasyText(player, "firebrick", "You cannot summon that far away!");
			
			return false;
		end;
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("triumph_of_the_bark");
	RITUAL.name = "(T2) Triumph of Bark";
	RITUAL.description = "The Mother may be the creator of affliction, but she may cure those seen as strong. Performing this ritual will cure you of all diseases. Incurs 20 corruption.";
	RITUAL.onerequiredbelief = {"man_become_beast", "one_with_the_druids", "daring_trout", "shedskin"}; -- Tier II Faith of the Family Ritual
	
	RITUAL.requirements = {"up_catalyst", "pantheistic_catalyst", "pantheistic_catalyst"};
	RITUAL.corruptionCost = 20;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 30;
	
	function RITUAL:OnPerformed(player)
		local diseases = player:GetCharacterData("diseases", {});
		
		for i = 1, #diseases do
			local disease = diseases[i];
			
			if istable(disease) --[[and disease.uniqueID ~= "begotten_plague"]] then
				diseases[i] = nil;
			end
		end
		
		player:SetCharacterData("diseases", diseases);
		player:NetworkDiseases();
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()

RITUAL = cwRituals.rituals:New("upstaged");
	RITUAL.name = "(T2) Upstaged";
	RITUAL.description = "Don't dare try to match a jester's dance. One misstep and you'll be banished to hell. Performing this ritual causes riposte attacks to disarm your opponent, provided they aren't using a shield. This lasts 40 minutes. Incurs 5 corruption.";
	RITUAL.onerequiredbelief = {"soothsayer", "heretic", "shedskin"}; -- Tier II Faith of the Dark Ritual
	
	RITUAL.requirements = {"up_catalyst", "belphegor_catalyst", "belphegor_catalyst"};
	RITUAL.corruptionCost = 5;
	RITUAL.ritualTime = 10;
	RITUAL.experience = 30;
	
	function RITUAL:OnPerformed(player)
	end;
	function RITUAL:OnFail(player)
	end;
	function RITUAL:StartRitual(player)
	end;
	function RITUAL:EndRitual(player)
	end;
RITUAL:Register()