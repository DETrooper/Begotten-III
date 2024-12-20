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
	elseif map == "rp_district21" then
		Schema.siegeLadderPositions = {
			-- Hill of Light
			{pos = Vector(-4253.44, 11041.47, 44.88), ang = Angle(45, 179.99, 0), boundsA = Vector(-4698, 11293, 232), boundsB = Vector(-3865, 10651, -35)},
			{pos = Vector(-8154.84, 9666.28, 46.56), ang = Angle(44.99, -0.88, 0), boundsA = Vector(7696, 10106, 480), boundsB = Vector(-8326, 9341, 66)},
			-- Hill of Light Citadel
			{pos = Vector(-7311.12, 11067, 176.69), ang = Angle(-58.67, 0, 0), boundsA = Vector(-7754, 11317, 345), boundsB = Vector(-7136, 10858, 132)},
			{pos = Vector(-7339.94, 11914.5, 156.59), ang = Angle(-55.8, 0, 0), boundsA = Vector(-7216, 11715, 141), boundsB = Vector(-7671, 12004, 289)},
			-- Gorewatch
			{pos = Vector(-8296.06, -8492.81, -319), ang = Angle(45, -179.56, 0), boundsA = Vector(-8756, -8612, 176), boundsB = Vector(-8414, -8168, -150)},
			{pos = Vector(-9182.06, -9113.06, -320.75), ang = Angle(45, 90, 0), boundsA = Vector(-9293, -8649, 176), boundsB = Vector(-8842, -9041, -150)},
			-- Crane
			{pos = Vector(-13654.16, -12306.47, -883.59), ang = Angle(44.99, -88.9, 0), boundsA = Vector(-13461, -12773, -445), boundsB = Vector(-13783, -12079, -873)},
			-- Water Tower
			{pos = Vector(-2745.69, -1459.94, -537.44), ang = Angle(54.55, -88.07, -0.15), boundsA = Vector(-2679, -1879, -225), boundsB = Vector(-3486, -1373, -689)},
		}
	end
end

local ITEM = Clockwork.item:New();
	ITEM.name = "Bear Trap";
	ITEM.uniqueID = "bear_trap";
	ITEM.model = "models/begotten/beartrap/beartrapopen.mdl";
	ITEM.weight = 5;
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
	ITEM.name = "War Hound Cage";
	ITEM.uniqueID = "war_hound_cage";
	ITEM.model = "models/begotten_apocalypse/items/houndcage.mdl";
	ITEM.weight = 15;
	ITEM.category = "Tools";
	ITEM.description = "A steel cage for tamed wolves provided by the Headsman and his slaving ilk. The numerous wolves of the North, believed to be descendants of once-loyal hounds, can still be brought back into the fold and live a loyal life. Snakecatchers and Headsmen often used these hounds to hunt men in the woods, for the mines or for their faith. ";
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/houndcage.png";
	--ITEM.useText = "Deploy";
	ITEM.requiredbeliefs = {};
	ITEM.stackable = false;
	ITEM:AddData("wolfskin", 0, true);
	ITEM:AddData("wolfhealth", 0, true);
	
	--[[
	function ITEM:OnUse(player, itemEntity)
	end
	]]
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) 
	end;

	function ITEM:OnEntitySpawned(entity2)
		local entity = ents.Create("cw_hound_cage_next");
		entity:Spawn();
		entity:Activate();
		entity:SetPos(entity2:GetPos());
		entity:SetAngles(entity2:GetAngles());
		if self:GetData("wolfskin") then
			entity:SetSkin(self:GetData("wolfskin"));
		end
		if self:GetData("wolfhealth") then
			entity.setwolfhealth = self:GetData("wolfhealth");
		end

		if entity.isplayingsound then
			entity:StopLoopingSound(entity.isplayingsound)
			entity.isplayingsound = entity:StartLoopingSound( "fiend/cagehound.wav" )
		end
		
		entity2:Remove();
	end;

ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Empty Hound Cage";
	ITEM.uniqueID = "empty_hound_cage";
	ITEM.model = "models/begotten_apocalypse/items/houndcage.mdl";
	ITEM.weight = 10;
	ITEM.category = "Tools";
	ITEM.description = "A steel cage for tamed wolves provided by the Headsman and his slaving ilk. The cage is empty, devoid of a loyal companion. Fetch one, would you?";
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/houndcage.png";
	ITEM.useText = "Capture";
	ITEM.requiredbeliefs = {};
	ITEM.stackable = false;
	
	function ITEM:OnUse(player, itemEntity)
		eyetraceplayer = player:GetEyeTrace()
		if eyetraceplayer.Hit == true and eyetraceplayer.Entity then
			local ent = eyetraceplayer.Entity
			if IsValid(ent) and ent:GetClass() == "npc_drg_animals_wolf" and ent:GetPos():Distance(player:GetPos())<100 and player:GetFaction() == ent.summonedFaith then
				local item = player:GiveItem(Clockwork.item:CreateInstance("war_hound_cage"), true);
				if item then
					item:SetData("wolfskin", ent:GetSkin())
					item:SetData("wolfhealth", ent:Health())
				end
				ent:Remove();
				player:TakeItem(self, true);
				Schema:EasyText(player, "chocolate", "A hound is captured.");
				player:EmitSound("fiend/cageshut.wav")
			else
				Schema:EasyText(player, "chocolate", "Nothing to catch.");
				return false
			end
		end
	end
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) 
	end;
	
	function ITEM:OnEntitySpawned(entity2)
		for i = 1, 9 do
			entity2:SetSubMaterial(i, "begotten/effects/blureffect")
		end
	end;
	
	ITEM.components = {breakdownType = "meltdown", items = {"scrap", "scrap", "scrap"}};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Campfire Kit";
	ITEM.uniqueID = "campfire_kit"
	ITEM.model = "models/mosi/fallout4/props/junk/components/wood.mdl";
	ITEM.weight = 2;
	ITEM.useText = "Deploy";
	ITEM.category = "Other";
	ITEM.useSound = "physics/wood/wood_strain3.wav";
	ITEM.description = "A large kit that is able to deploy a campfire which will last for 10 minutes, though more wood may be added as fuel to extend its lifetime.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/wood.png"
	ITEM.stackable = false;

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local tr = player:GetEyeTrace();
		local position = tr.HitPos;
		local valuewater = bit.band(util.PointContents(position), CONTENTS_WATER) == CONTENTS_WATER;
		
		if player:InTower() then
			Schema:EasyText(player, "peru", "You cannot deploy this in the Tower of Light!");
			return false;
		end
		
		if tr.Entity and tr.Entity:GetClass() == "cw_longship" then
			Schema:EasyText(player, "peru", "You cannot deploy this on a longship!");
			return false;
		end
		
		for i, v in ipairs(ents.FindByClass("cw_longship")) do
			if v.playersOnBoard then
				for i2, v2 in ipairs(v.playersOnBoard) do
					if player == v2 then
						Schema:EasyText(player, "peru", "You cannot deploy this while sailing!");
						return false;
					end
				end
			end
		end
		
		if (player:GetPos():DistToSqr(position) <= 36864) and valuewater == false then
			local ent = ents.Create("cw_fireplace")
			ent:SetPos(position)
			ent:Spawn()
		elseif valuewater == true then
			Schema:EasyText(player, "peru", "You cannot deploy this underwater!");
			return false;
		else
			Schema:EasyText(player, "peru", "You cannot deploy this that far away!")
			return false;
		end
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Siege Ladder";
	ITEM.uniqueID = "siege_ladder";
	ITEM.model = "models/begotten/misc/siegeladder_compact.mdl";
	ITEM.weight = 9;
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
					player.ladderConstructing = {index = i, itemTable = self};
					ladderPos.occupier = "constructing";
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "begins erecting a siege ladder!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
					
					Clockwork.player:SetAction(player, "building", 30, 3, function()
						if IsValid(player) and player.ladderConstructing and player:HasItemInstance(self) then
							local ladderPos = Schema.siegeLadderPositions[player.ladderConstructing.index];
							local ladderEnt = ents.Create("cw_siege_ladder");
							
							if IsValid(ladderEnt) then
								ladderEnt:SetAngles(ladderPos.ang);
								ladderEnt:SetPos(ladderPos.pos);
								ladderEnt:SetNWEntity("owner", player);
								ladderEnt:Spawn();
								
								ladderEnt.strikesRequired = math.Round(15 * ((self:GetCondition() or 100) / 100));
								ladderPos.occupier = ladderEnt;
								ladderEnt.occupyingPosition = player.ladderConstructing.index;
								
								player:TakeItem(self);
							end

							player.ladderConstructing = nil;
						else
							ladderPos.occupier = nil;
						end
					end);
					
					return false;
				end
			end
		end
		
		local map = game.GetMap();
		
		if map == "rp_district21" then
			Schema:EasyText(player, "chocolate", "You must erect this siege ladder at a valid location outside the walls of the Hill of Light or Gorewatch, or near the Crane or Water Tower!");
		else
			Schema:EasyText(player, "chocolate", "You must erect this siege ladder at a valid location outside the walls of the Castle or the Tower of Light!");
		end
		
		return false;
	end
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if player.ladderConstructing then
			if player.ladderConstructing.itemTable == self then
				Clockwork.player:SetAction(player, false);
			end
		end
	end;
	
	ITEM.components = {breakdownType = "breakdown", items = {"wood", "wood", "wood", "wood", "wood", "wood"}};
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Snow Dog";
	ITEM.model = "models/food/hotdog.mdl";
	ITEM.category = "Other";
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
	ITEM.weight = 2.5;
	ITEM.category = "Tools";
	ITEM.description = "A collection of tools and materials that can easily be used to repair one's armor.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit_armor.png";
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
	ITEM.weight = 2.5;
	ITEM.category = "Tools";
	ITEM.description = "A collection of delicate tools and spare parts that can be used to repair firearms.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit_firearms.png";
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
	ITEM.weight = 2.5;
	ITEM.category = "Tools";
	ITEM.description = "A collection of tools and materials that can easily be used to repair one's melee weapon or shield.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/repair_kit_melee.png";
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
	ITEM.model = "models/items/weapons/blacksmithhammer/bl_hammer.mdl";
	ITEM.weight = 0.2;
	ITEM.category = "Tools";
	ITEM.description = "A small tool that can be used to etch a name into a weapon or shield.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/engraving_tool.png"
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
					if (target:GetNetVar("tied") == 0) then
						if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
							if (target:GetAimVector():DotProduct( player:GetAimVector() ) > 0 or (target:IsRagdolled() and !trace.Entity.cwIsBelongings)) then
								local faction = player:GetFaction();
								
								if target:InTower() and Schema.towerSafeZoneEnabled and (faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy" and faction ~= "Hillkeeper") then
									if game.GetMap() == "rp_begotten3" then
										Schema:EasyText(player, "peru", "You cannot tie characters in the Tower of Light if you are not of the Holy Hierarchy!");
									else
										Schema:EasyText(player, "peru", "You cannot tie characters in the safezone if you are not of the Holy Hierarchy!");
									end
									
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
									if (player:Alive() and !player:IsRagdolled() and target:GetNetVar("tied") == 0 and !target.cwObserverMode and !target.possessor 
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
			player:SetNetVar("battery", math.Round(player:GetCharacterData("battery", 0), 0));
			
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
	ITEM.weight = 0.3;
	ITEM.category = "Communication"
	ITEM.description = "A stout warhorn that when blown will communicate orders to nearby friendlies.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/warhorn.png"
	ITEM.customFunctions = {"Sound Attack", "Sound Rally", "Sound Rally - Marching Formation", "Sound Rally - Shieldwall", "Sound Retreat"};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
	
	if (SERVER) then
		function ITEM:OnCustomFunction(player, name)
			local curTime = CurTime();
		
			if !player.nextWarHorn or player.nextWarHorn <= curTime then
				player.nextWarHorn = curTime + 5;
				
				local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
				local playerPos = player:GetPos();
				local radius = Clockwork.config:Get("talk_radius"):Get() * 4;
			
				if faction == "Gatekeeper" or faction == "Hillkeeper" or faction == "Holy Hierarchy" then
					if (name == "Sound Attack") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Hillkeeper" or vFaction == "Holy Hierarchy" then
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
								
								if vFaction == "Gatekeeper" or vFaction == "Hillkeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn7.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Marching Formation") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Hillkeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a marching formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/warhorn8.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Shieldwall") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Gatekeeper" or vFaction == "Hillkeeper" or vFaction == "Holy Hierarchy" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a shieldwall formation!");
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
								
								if vFaction == "Gatekeeper" or vFaction == "Hillkeeper" or vFaction == "Holy Hierarchy" then
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
						
						player:EmitSound("warhorns/gore_warhorn_attack.mp3", 100, math.random(88, 108));
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
						
						player:EmitSound("warhorns/gore_warhorn_rally.mp3", 100, math.random(88, 108));
					elseif (name == "Sound Rally - Marching Formation") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a marching formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/gore_warhorn_formation.mp3", 100, math.random(95, 118));
					elseif (name == "Sound Rally - Shieldwall") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == faction then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, signalling a rally in a shieldwall formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." blows their warhorn, but its signal is unknown to you!");
								end
							end
						end
						
						player:EmitSound("warhorns/gore_warhorn_formation.mp3", 100, math.random(77, 86));
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
						
						player:EmitSound("warhorns/gore_warhorn_retreat.mp3", 100, math.random(88, 108));
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
	ITEM.weight = 0.2;
	ITEM.category = "Communication"
	ITEM.description = "A human skull that has been grafted with holes to generate a bone-chilling whistle.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/skull.png"
	ITEM.customFunctions = {"Sound Attack", "Sound Rally", "Sound Rally - Marching Formation", "Sound Rally - Shieldwall", "Sound Retreat"};
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
					elseif (name == "Sound Rally - Marching Formation") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a rally in a marching formation!");
								else
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds a terrifying death whistle!");
								end
							end
						end
						player:EmitSound("warhorns/deathwhistle5.mp3", 100, math.random(98, 102));
					elseif (name == "Sound Rally - Shieldwall") then
						for k, v in pairs(ents.FindInSphere(playerPos, radius)) do
							if v:IsPlayer() then
								local vFaction = v:GetFaction();
								
								if vFaction == "Children of Satan" then
									Clockwork.chatBox:Add(v, nil, "localevent", player:Name().." sounds their death whistle, signalling a rally in a shieldwall formation!");
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

local ITEM = Clockwork.item:New();
	ITEM.name = "Empty Bucket";
	ITEM.uniqueID = "empty_bucket";
	ITEM.model = "models/props_junk/MetalBucket01a.mdl";
	ITEM.weight = 1;
	ITEM.category = "Tools";
	ITEM.description = "An iron bucket devoid of any contents.";
	ITEM.customFunctions = {"Fill"};
	ITEM.iconoverride = "begotten_apocalypse/ui/itemicons/bucket.png"
	--ITEM.itemSpawnerInfo = {category = "Junk", rarity = 95};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	function ITEM:OnCustomFunction(player, name)
		if (name == "Fill") then
			local lastZone = player:GetCharacterData("LastZone");
			local waterLevel = player:WaterLevel();
			local nearSmithy;
			if (waterLevel and waterLevel > 0) then
				for i = 1, #cwRecipes.smithyLocations do
					if player:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
						Schema:EasyText(player, "firebrick", "You cannot fill a bucket with this water!");
						return false;
					end
				end

				
				Clockwork.chatBox:AddInTargetRadius(player, "me", "begins filling a bucket with water.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				-- input water swish sound

				player:EmitSound("apocalypse/cauldron/fillup.mp3");
				-- start progress bar for begins filling a bucket of water.
				Clockwork.player:SetAction(player, "filling_bucket", 10, 3, function()
					-- input water full sound
					
					if lastZone ~= "gore" then
						player:GiveItem(Clockwork.item:CreateInstance("dirty_water_bucket"), true);
					else
						player:GiveItem(Clockwork.item:CreateInstance("purified_water_bucket"), true);
					end

					player:TakeItem(self, true);
				end);
			else
				Schema:EasyText(player, "firebrick", "You must be standing in water to fill this bucket!");
			end;
		end;
	end;
ITEM:Register();

local ITEM = Clockwork.item:New();
	ITEM.name = "Empty Bottle";
	ITEM.uniqueID = "empty_bottle";
	ITEM.model = "models/props_junk/GlassBottle01a.mdl";
	ITEM.weight = 0.1;
	ITEM.category = "Tools";
	ITEM.description = "A glass bottle devoid of any contents.";
	ITEM.customFunctions = {"Fill"};
	ITEM.iconoverride = "materials/begotten/ui/itemicons/cold_pop.png";
	--ITEM.itemSpawnerInfo = {category = "Junk", rarity = 95};
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;

	function ITEM:OnCustomFunction(player, name)
		if (name == "Fill") then
			local waterLevel = player:WaterLevel();
			local lastZone = player:GetCharacterData("LastZone");
			if waterLevel and waterLevel > 0 then
				for i = 1, #cwRecipes.smithyLocations do
					if player:GetPos():DistToSqr(cwRecipes.smithyLocations[i]) < (256 * 256) then
						Schema:EasyText(player, "firebrick", "You cannot fill a bucket with this water!");
						return false;
					end
				end

				if lastZone ~= "gore" then
					Clockwork.chatBox:AddInTargetRadius(player, "me", "begins filling an empty bottle with water, almost spilling the contents multiple times as they struggle to fight off the cold biting their fingers.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					-- input water swish sound

					-- start progress bar for begins filling a bucket of water.
					Clockwork.player:SetAction(player, "filling_bottle", 15, 3, function()
						-- input water full sound
						player:GiveItem(Clockwork.item:CreateInstance("dirtywater"), true);
						player:TakeItem(self, true);
					end);
				else
					Clockwork.chatBox:AddInTargetRadius(player, "me", "begins filling an empty bottle with water.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					-- input water swish sound

					-- start progress bar for begins filling a bucket of water.
					Clockwork.player:SetAction(player, "filling_bottle", 5, 3, function()
						-- input water full sound
						player:GiveItem(Clockwork.item:CreateInstance("purified_water"), true);
						player:TakeItem(self, true);
					end);
				end
			else
				Schema:EasyText(player, "firebrick", "You must be standing in water to fill this bottle!");
			end;
		end;
	end;
ITEM:Register();