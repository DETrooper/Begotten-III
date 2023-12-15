if (SERVER) then
	local map = game.GetMap();

	Schema.siegeLadderPositions = {};

	if map == "rp_begotten3" then
		Schema.siegeLadderPositions = {
			-- Tower
			{pos = Vector(4265.21875, 12294.34375, -1583), ang = Angle(-45, 0, 0), boundsA = Vector(3250, 11942, -1092), boundsB = Vector(4690, 12861, -2000)},
			{pos = Vector(3703.65625, 10982.875, -1796.5625), ang = Angle(-56, 0, 0), boundsA = Vector(3250, 11942, -1092), boundsB = Vector(3782, 10180, -2000)},
			{pos = Vector(365.625, 9597.0625, -1645.875), ang = Angle(-61.935, -112.714, -5.279), boundsA = Vector(103, 9311, -1801), boundsB = Vector(1107, 10108, -1234)},
			{pos = Vector(-268.65625, 9617, -1634.53125), ang = Angle(-58.508, -72.021, 2.065), boundsA = Vector(103, 9311, -1801), boundsB = Vector(-818, 10238, -1133)},
			{pos = Vector(-5141.9375, 13244.65625, -1456.78125), ang = Angle(-45.582, -170.986, -0.692), boundsA = Vector(-4533, 13545, -845), boundsB = Vector(-5492, 12580, -1807)},
			
			-- Castle
			{pos = Vector(-11592, -13690, -1680), ang = Angle(-62, 0, 0), boundsA = Vector(-11113, -14113, -1732), boundsB = Vector(-12148, -12889, -1314)},
			{pos = Vector(-11592, -12340, -1680), ang = Angle(-62, 0, 0), boundsA = Vector(-11187, -11653, -1732), boundsB = Vector(-12148, -12889, -1314)},
			
			-- Gorewatch
			{pos = Vector(9731.46875, 12398.34375, -1387.8125), ang = Angle(53.740, -87.638, 0.566), boundsA = Vector(10075, 12370, -1235), boundsB = Vector(9198, 11844, -940)},
			{pos = Vector(9718.8125, 9857.78125, -1286.84375), ang = Angle(61.908, 90.989, 1.417), boundsA = Vector(10053, 9873, -1221), boundsB = Vector(9262, 10410, -952)},
		}
	elseif map == "rp_begotten_redux" then
		Schema.siegeLadderPositions = {
			-- Town
			{pos = Vector(-8332.8125, -8357.53125, 68.03125), ang = Angle(-62.611, 0, 0), boundsA = Vector(-8942, -8678, 53), boundsB = Vector(-8155, -8130, 584)},
			{pos = Vector(-8334.15625, -7899.34375, 52.0625), ang = Angle(-62.425, 0, 0), boundsA = Vector(-8155, -8130, 584), boundsB = Vector(-8942, -7572, 53)},
			
			-- Old Manor Fort
			{pos = Vector(10553.375, 9878.125, 684.65625), ang = Angle(-78.387, -176.287, -3.532), boundsA = Vector(11045, 13394, 680), boundsB = Vector(10130, 11804, 1076)},
			{pos = Vector(10653.15625, 10881.3125, 684.34375), ang = Angle(-58.656, 179.824, 0.786), boundsA = Vector(10130, 11804, 1076), boundsB = Vector(11248, 10366, 630)},
			{pos = Vector(10424.65625, 12854.96875, 674.8125), ang = Angle(-72.065, -173.32, -5.262), boundsA = Vector(11248, 10366, 630), boundsB = Vector(10405, 9455, 1140)},
		}
	elseif map == "rp_scraptown" then
		Schema.siegeLadderPositions = {
			-- Scrap Town Bridge
			{pos = Vector(-505.0625, -3355.15625, 343.90625), ang = Angle(-89.703, 147.766, -147.343), boundsA = Vector(-100, -3260, 325), boundsB = Vector(-1460, -3449, 550)},
			{pos = Vector(-495.78125, -3530.9375, 345.1875), ang = Angle(-89.995, -179, 180), boundsA = Vector(-1460, -3449, 550), boundsB = Vector(-100, -3630, 325)},
			-- Scrap Town Gate
			{pos = Vector(-1861.375, -3282.84375, 186.125), ang = Angle(67.401, 180, 0), boundsA = Vector(-1619, -2970, 113), boundsB = Vector(-2447, -3455, 562)},
			{pos = Vector(-1859.59375, -3643.625, 188.4375), ang = Angle(67.401, 180, 0), boundsA = Vector(-2447, -3455, 562), boundsB = Vector(-1736, -3869, 153)},
		}
	end
end

local ITEM = Clockwork.item:New();
	ITEM.name = "Bear Trap";
	ITEM.uniqueID = "bear_trap";
	ITEM.model = "models/begotten/beartrap/beartrapopen.mdl";
	ITEM.weight = 10;
	ITEM.category = "Tools";
	ITEM.description = "A metal pressure-activated trap with jagged teeth, designed to capture the strongest of prey, be they animal or man.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bear_trap.png";
	ITEM.useText = "Deploy";
	ITEM.requiredbeliefs = {"ingenious"};
	
	function ITEM:OnUse(player, itemEntity)
		if Schema.towerSafeZoneEnabled and player:InTower() then
			Schema:EasyText(player, "chocolate", "You cannot deploy a bear trap inside a safezone!");
			
			return false;
		end

		local trapEnt = ents.Create("cw_bear_trap");
		
		if IsValid(trapEnt) then
			trapEnt:SetAngles(player:GetAngles());
			trapEnt:SetPos(player:GetPos());
			trapEnt.condition = self:GetCondition() or 100;
			trapEnt.owner = player;
			trapEnt:Spawn();
		end
	end
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "scrap", "iron_chunks"}};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Siege Ladder";
	ITEM.uniqueID = "siege_ladder";
	ITEM.model = "models/begotten/misc/siegeladder_compact.mdl";
	ITEM.weight = 11;
	ITEM.category = "Tools";
	ITEM.description = "A long, sturdy siege ladder for the express purpose of scaling the fortifications of the Castle, Gorewatch, or the Tower of Light.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/siege_ladder.png";
	ITEM.useText = "Erect";
	
	function ITEM:OnUse(player, itemEntity)
		local playerPos = player:GetPos();
		
		for i = 1, #Schema.siegeLadderPositions do
			local ladderPos = Schema.siegeLadderPositions[i];
			
			if not ladderPos.occupier then
				if playerPos:WithinAABox(ladderPos.boundsA, ladderPos.boundsB) then
					player.ladderConstructing = {index = i, condition = self:GetCondition()};
					ladderPos.occupier = "constructing";
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "begins erecting a siege ladder!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
					
					Clockwork.player:SetAction(player, "building", 30, 3, function()
						if IsValid(player) and player.ladderConstructing then
							local ladderPos = Schema.siegeLadderPositions[player.ladderConstructing.index];
							local ladderEnt = ents.Create("cw_siege_ladder");
							if IsValid(ladderEnt) then
								ladderEnt:SetAngles(ladderPos.ang);
								ladderEnt:SetPos(ladderPos.pos);
								ladderEnt:SetNWEntity("owner", player);
								ladderEnt:Spawn();
								
								ladderEnt.strikesRequired = math.Round(15 * ((self:GetCondition() or 100) / 100));
							end
							
							ladderPos.occupier = ladderEnt;
							ladderEnt.occupyingPosition = player.ladderConstructing.index;
							player.ladderConstructing = nil;
						else
							ladderPos.occupier = nil;
						end
					end);
					
					return;
				end
			end
		end
		
		Schema:EasyText(player, "chocolate", "You must erect this siege ladder at a valid location outside the walls of the Castle or the Tower of Light!");
		return false;
	end
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood", "wood", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Snow Dog";
	ITEM.model = "models/food/hotdog.mdl";
	ITEM.category = "Garbage";
	ITEM.weight = 0.3;
	ITEM.description = "A snowdog. You can wear it as a hat..";
	ITEM.uniqueID = "snowdog";
	ITEM.useText = "Wear"
	-- Called when a player drops the item.
	function ITEM:OnUse(player, position)
		Clockwork.player:Notify(player, "You attempt to wear your new snowdog prize hat, but end up eating it instead.");
		player:EmitSound("npc/barnacle/barnacle_digesting1.wav");
		timer.Simple(0.5, function()
			if (player:GetGender() == GENDER_MALE) then
				player:EmitSound("vo/npc/male01/moan0"..math.random(1, 4)..".wav")
			else
				player:EmitSound("vo/npc/female01/moan0"..math.random(1, 4)..".wav")
			end;
		end);
		timer.Create(player:EntIndex().."snowdawg", 3, 2, function()
			if (!IsValid(player)) then
				return;
			end;
		if (player:GetGender() == GENDER_MALE) then
			player:EmitSound("vo/npc/male01/moan0"..math.random(1, 4)..".wav")
		else
			player:EmitSound("vo/npc/female01/moan0"..math.random(1, 4)..".wav")
		end;
		end);
	end;
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	-- Called when the item entity has spawned.
	function ITEM:OnEntitySpawned(entity)
		entity:SetMaterial("models/props/cs_office/snowmana");
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Armor Repair Kit";
	ITEM.uniqueID = "armor_repair_kit";
	ITEM.cost = 50;
	ITEM.model = "models/props/de_prodigy/ammo_can_02.mdl";
	ITEM.weight = 1;
	ITEM.category = "Tools";
	ITEM.description = "A collection of tools and materials that can easily be used to repair one's armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit.png";
	ITEM.conditionReplenishment = 200;
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Repair Kits", rarity = 900, bNoSupercrate = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Firearm Repair Kit";
	ITEM.uniqueID = "firearm_repair_kit";
	ITEM.cost = 50;
	ITEM.model = "models/props/de_prodigy/ammo_can_02.mdl";
	ITEM.weight = 1;
	ITEM.category = "Tools";
	ITEM.description = "A collection of delicate tools and spare parts that can be used to repair firearms.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit.png";
	ITEM.conditionReplenishment = 200;
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Repair Kits", rarity = 900, bNoSupercrate = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Melee Repair Kit";
	ITEM.uniqueID = "weapon_repair_kit";
	ITEM.cost = 50;
	ITEM.model = "models/props/de_prodigy/ammo_can_02.mdl";
	ITEM.weight = 1;
	ITEM.category = "Tools";
	ITEM.description = "A collection of tools and materials that can easily be used to repair one's melee weapon or shield.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit.png";
	ITEM.conditionReplenishment = 200;
	ITEM.stackable = false;
	
	ITEM.itemSpawnerInfo = {category = "Repair Kits", rarity = 700, bNoSupercrate = true};
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Engraving Tool";
	ITEM.uniqueID = "engraving_tool";
	ITEM.cost = 50;
	ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
	ITEM.weight = 0.25;
	ITEM.category = "Tools";
	ITEM.description = "A small tool that can be used to etch a name into a weapon or shield.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ampoule.png"
	--ITEM.itemSpawnerInfo = {category = "Junk", rarity = 95};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Bindings";
	ITEM.category = "Tools";
	ITEM.cost = 4;
	ITEM.model = "models/begotten/misc/rope.mdl";
	ITEM.weight = 0.2;
	ITEM.access = "v";
	ITEM.useText = "Tie";
	ITEM.description = "A collection of rope that can be fitted around a person's wrists to bind them together.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/bindings.png"
	
	ITEM.stackable = true;
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are already tying a character!");
			
			return false;
		else
			local trace = player:GetEyeTraceNoCursor();
			local target = Clockwork.entity:GetPlayer(trace.Entity);
			local tieTime = 6;
			
			if player.HasBelief and player:HasBelief("dexterity") then
				tieTime = 4;
			end
			
			if (target) then
				if (!target:HasGodMode() and !target.cwObserverMode and !target.possessor) then
					if (target:GetSharedVar("tied") == 0) then
						if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
							if (target:GetAimVector():DotProduct( player:GetAimVector() ) > 0 or (target:IsRagdolled() and !trace.Entity.cwIsBelongings)) then
								local faction = player:GetFaction();
								
								if target:InTower() and Schema.towerSafeZoneEnabled and (faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy") then
									Schema:EasyText(player, "peru", "You cannot tie characters in the Tower of Light if you are not of the Holy Hierarchy!");
									return false;
								end
								
								if player:GetMoveType() == MOVETYPE_WALK then
									for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
										if v:IsPlayer() then
											Clockwork.chatBox:Add(v, player, "me", "starts tying up "..Clockwork.player:FormatRecognisedText(v, "%s", target)..".");
										end
									end
								end
								Clockwork.player:SetAction(player, "tie", tieTime);
								
								Clockwork.player:EntityConditionTimer(player, target, trace.Entity, tieTime, 192, function()
									if (player:Alive() and !player:IsRagdolled() and target:GetSharedVar("tied") == 0 and !target.cwObserverMode and !target.possessor 
									and (target:GetAimVector():DotProduct(player:GetAimVector()) > 0 or (target:IsRagdolled() and !trace.Entity.cwIsBelongings))) then
										return true;
									end;
								end, function(success)
									if (success) then
										player.isTying = nil;
										
										Schema:TiePlayer(target, true, nil);
										
										player:TakeItem(self, true);
									else
										player.isTying = nil;
									end;
									
									Clockwork.player:SetAction(player, "tie", false);
								end);
							else
								Schema:EasyText(player, "peru", "You cannot tie characters that are facing you!");
								
								return false;
							end;
							
							player.isTying = true;
							
							Clockwork.player:SetMenuOpen(player, false);
							
							return false;
						else
							Schema:EasyText(player, "firebrick", "This character is too far away!");
							
							return false;
						end;
					else
						Schema:EasyText(player, "peru", "This character is already tied!");
						
						return false;
					end;
				else
					if player.cwWakingUp then
						Schema:EasyText(player, "firebrick", "This character is waking up after spawning and cannot currently be tied!");
					else
						Schema:EasyText(player, "firebrick", "This character cannot currently be tied!");
					end
					
					return false;
				end
			else
				Schema:EasyText(player, "firebrick", "That is not a valid character!");
				
				return false;
			end;
		end;
	end;
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are currently tying a character!");
			
			return false;
		end;
	end;
	ITEM.itemSpawnerInfo = {category = "Junk", rarity = 200};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Refurbished Blood Test Kit";
	ITEM.category = "Tools";
	ITEM.cost = 100;
	ITEM.model = "models/kali/miscstuff/stalker/aid/first aid kit.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Test Blood";
	ITEM.description = "An ancient device used to test another person's blood for corruption. This one is worn by age and may even be unreliable.";
	ITEM.stackable = false;
	
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blood_test_kit.png"
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are already testing a character!");
			
			return false;
		else
			local trace = player:GetEyeTraceNoCursor();
			local target = Clockwork.entity:GetPlayer(trace.Entity);
			local testTime = 15;
			
			if (target) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					if player:GetMoveType() == MOVETYPE_WALK then
						for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
							if v:IsPlayer() then
								Clockwork.chatBox:Add(v, player, "me", "begins a blood test on "..Clockwork.player:FormatRecognisedText(v, "%s", target)..".");
							end
						end
					end
					Clockwork.player:SetAction(player, "bloodTest", testTime);
					
					Clockwork.player:EntityConditionTimer(player, target, trace.Entity, testTime, 192, function()
						if (player:Alive() and !player:IsRagdolled() and player:HasItemInstance(self)) then
							return true;
						end;
					end, function(success)
						if (success) then
							player.isTying = nil;
							
							Schema:BloodTestPlayer(target, true);
							
							if self then
								local condition = self:GetCondition() - 20;
							
								if condition <= 0 then
									player:TakeItem(self, true);
								else
									self:SetCondition(condition);
								end
							end
						else
							player.isTying = nil;
						end;
						
						Clockwork.player:SetAction(player, "bloodTest", false);
					end);
					
					player.isTying = true;
					
					Clockwork.player:SetMenuOpen(player, false);
					
					return false;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
					
					return false;
				end;
			else
				Schema:EasyText(player, "firebrick", "That is not a valid character!");
				
				return false;
			end;
		end;
	end;
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are currently tying a character!");
			
			return false;
		end;
	end;
	--ITEM.itemSpawnerInfo = {category = "Medical", rarity = 500};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Advanced Blood Test Kit";
	ITEM.category = "Tools";
	ITEM.cost = 2500;
	ITEM.model = "models/kali/miscstuff/stalker/aid/first aid kit.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Test Blood";
	ITEM.description = "An ancient device used to test another person's blood for corruption. This device in particular is an advanced model, designed by Skylight engineers to detect the blood of the infamous Black Hats.";
	ITEM.stackable = false;
	
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blood_test_kit.png"
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are already testing a character!");
			
			return false;
		else
			local trace = player:GetEyeTraceNoCursor();
			local target = Clockwork.entity:GetPlayer(trace.Entity);
			local testTime = 15;
			
			if (target) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					if player:GetMoveType() == MOVETYPE_WALK then
						for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
							if v:IsPlayer() then
								Clockwork.chatBox:Add(v, player, "me", "begins a blood test on "..Clockwork.player:FormatRecognisedText(v, "%s", target)..".");
							end
						end
					end
					Clockwork.player:SetAction(player, "bloodTest", testTime);
					
					Clockwork.player:EntityConditionTimer(player, target, trace.Entity, testTime, 192, function()
						if (player:Alive() and !player:IsRagdolled() and player:HasItemInstance(self)) then
							return true;
						end;
					end, function(success)
						if (success) then
							player.isTying = nil;
							
							Schema:BloodTestPlayer(target, false, true);
							
							if self then
								local condition = self:GetCondition() - 10;
							
								if condition <= 0 then
									player:TakeItem(self, true);
								else
									self:SetCondition(condition);
								end
							end
						else
							player.isTying = nil;
						end;
						
						Clockwork.player:SetAction(player, "bloodTest", false);
					end);
					
					player.isTying = true;
					
					Clockwork.player:SetMenuOpen(player, false);
					
					return false;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
					
					return false;
				end;
			else
				Schema:EasyText(player, "firebrick", "That is not a valid character!");
				
				return false;
			end;
		end;
	end;
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are currently testing a character!");
			
			return false;
		end;
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Blood Test Kit";
	ITEM.category = "Tools";
	ITEM.cost = 1000;
	ITEM.model = "models/kali/miscstuff/stalker/aid/first aid kit.mdl";
	ITEM.weight = 0.4;
	ITEM.useText = "Test Blood";
	ITEM.description = "An ancient device used to test another person's blood for corruption.";
	ITEM.stackable = false;
	
	ITEM.iconoverride = "materials/begotten/ui/itemicons/blood_test_kit.png"
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are already testing a character!");
			
			return false;
		else
			local trace = player:GetEyeTraceNoCursor();
			local target = Clockwork.entity:GetPlayer(trace.Entity);
			local testTime = 15;
			
			if (target) then
				if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
					if player:GetMoveType() == MOVETYPE_WALK then
						for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)) do
							if v:IsPlayer() then
								Clockwork.chatBox:Add(v, player, "me", "begins a blood test on "..Clockwork.player:FormatRecognisedText(v, "%s", target)..".");
							end
						end
					end
					Clockwork.player:SetAction(player, "bloodTest", testTime);
					
					Clockwork.player:EntityConditionTimer(player, target, trace.Entity, testTime, 192, function()
						if (player:Alive() and !player:IsRagdolled() and player:HasItemInstance(self)) then
							return true;
						end;
					end, function(success)
						if (success) then
							player.isTying = nil;
							
							Schema:BloodTestPlayer(target, false);
							
							if self then
								local condition = self:GetCondition() - 10;
							
								if condition <= 0 then
									player:TakeItem(self, true);
								else
									self:SetCondition(condition);
								end
							end
						else
							player.isTying = nil;
						end;
						
						Clockwork.player:SetAction(player, "bloodTest", false);
					end);
					
					player.isTying = true;
					
					Clockwork.player:SetMenuOpen(player, false);
					
					return false;
				else
					Schema:EasyText(player, "firebrick", "This character is too far away!");
					
					return false;
				end;
			else
				Schema:EasyText(player, "firebrick", "That is not a valid character!");
				
				return false;
			end;
		end;
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player.isTying) then
			Schema:EasyText(player, "peru", "You are currently testing a character!");
			
			return false;
		end;
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "District One Power Cell";
	ITEM.uniqueID = "power_cell";
	ITEM.cost = 500;
	ITEM.model = "models/mosi/fallout4/props/junk/components/nuclear.mdl";
	ITEM.weight = 1;
	ITEM.category = "Tools";
	ITEM.description = "A nuclear power cell of ancient Glazic manufacture, used to power District One armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/power_cell.png"
	ITEM.useText = "Recharge Power Armor";
	ITEM.useSound = "items/battery_pickup.wav";
	
	ITEM.itemSpawnerInfo = {category = "Armor", rarity = 600, supercrateOnly = true};
	
	function ITEM:OnUse(player, itemEntity)
		if player:IsWearingPowerArmor() then
			local currentCharge = player:GetCharacterData("battery", 0);
		
			player:SetCharacterData("battery", math.Clamp(currentCharge + 75, 0, 100));
			player:SetSharedVar("battery", math.Round(player:GetCharacterData("battery", 0), 0));
			
			player.nextChargeDepleted = CurTime() + 120;
		else
			Schema:EasyText(player, "chocolate", "You must be inside a suit of power armor in order to recharge it!");
			
			return false;
		end
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Warhorn";
	ITEM.model = "models/begotten/misc/warhorn.mdl";
	ITEM.weight = 1;
	ITEM.category = "Communication"
	ITEM.description = "A stout warhorn that when blown will communicate orders to nearby friendlies.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/warhorn.png"
	ITEM.customFunctions = {"Sound Attack", "Sound Rally", "Sound Rally - Line", "Sound Rally - Square", "Sound Retreat"};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			local curTime = CurTime();
		
			if !player.nextWarHorn or player.nextWarHorn <= curTime then
				player.nextWarHorn = curTime + 5;
				
				local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
				local playerPos = player:GetPos();
				local radius = Clockwork.config:Get("talk_radius"):Get() * 4;
			
				if faction == "Gatekeeper" or faction == "Holy Hierarchy" then
					if (name == "Sound Attack") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling an attack!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn3.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn7.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Line") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a line formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn8.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Square") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a square formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn4.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Retreat") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a retreat!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn6.mp3", 100, math.random(98, 102));
					end;
				elseif faction == "Goreic Warrior" then
					if (name == "Sound Attack") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling an attack!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn3.mp3", 100,  math.random(80, 95));
					elseif (name == "Sound Rally") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn7.mp3", 100,  math.random(80, 95));
					elseif (name == "Sound Rally - Line") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a line formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn7.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Square") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a square formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn7.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Retreat") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a retreat!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn6.mp3", 100, math.random(80, 95));
					end;
 
				else
					Schema:EasyText(player, "peru", "You are not the correct faction to do this!");
				end
			end
		end;
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Death Whistle";
	ITEM.model = "models/begotten/misc/skull.mdl";
	ITEM.weight = 1;
	ITEM.category = "Communication"
	ITEM.description = "A human skull that has been grafted with holes to generate a bone-chilling whistle.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skull.png"
	ITEM.customFunctions = {"Sound Attack", "Sound Rally", "Sound Rally - Line", "Sound Rally - Square", "Sound Retreat"};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			local curTime = CurTime();
			if !player.nextWarHorn or player.nextWarHorn <= curTime then
				player.nextWarHorn = curTime + 5;
				local faction = player:GetFaction();
				local playerPos = player:GetPos();
				local radius = Clockwork.config:Get("talk_radius"):Get() * 4;
				if faction == "Children of Satan" then
					if (name == "Sound Attack") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling an attack!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle"..math.random(1,2)..".mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a rally!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle5.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Line") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a rally in a line formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle5.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Square") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a rally in a square formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle5.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Retreat") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a retreat!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle"..math.random(3,4)..".mp3", 100, math.random(98, 102));
					end;
				else
					Schema:EasyText(player, "peru", "You are not the correct faction to do this!");
				end
			end
		end;
	end;
ITEM:Register();