--[[
	Begotten III: Jesus Wept
	Sailing
	By: DETrooper
--]]

local map = game.GetMap();

if map == "rp_begotten3" then
	cwSailing.gorewatchBounds = {Vector(9422, 11862, -1210), Vector(10055, 10389, -770)};
elseif map == "rp_district21" then
	cwSailing.gorewatchBounds = {Vector(-9328, -8640, -146), Vector(-8771, -8105, 686)};
end

if !cwSailing.shipDestinations then
	if map == "rp_begotten3" or map == "rp_district21" then
		cwSailing.shipDestinations = {
			["docks"] = {name = "the Gore Forest"},
			["hell"] = {name = "Hell"},
			["wasteland"] = {name = "the Wasteland"},
			["wastelandlava"] = {name = "the Lava Coast"},
		};
	end
end

if !cwSailing.shipLocations then
	if map == "rp_begotten3" then
		cwSailing.shipLocations = {
			["docks"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-3103.90625, 385.65625, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2734.59375, 366.75, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2449.3125, 526.375, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2075.25, 489.28125, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-2610, 1189, 11619), angles = Angle(0, 0, 0)},
				},
			},
			["calm"] = {
				["longship"] = {
					{occupied = false, pos = Vector(1876.71875, 10203.3125, -6371.375)},
					{occupied = false, pos = Vector(790.40625, 11458, -6360)},
					{occupied = false, pos = Vector(640, 8000, -6350)},
					{occupied = false, pos = Vector(-808.40625, 6717.125, -6345.21875)},
					{occupied = false, pos = Vector(-2537.46875, 7600.9375, -6348.8125)},
					{occupied = false, pos = Vector(-1691.71875, 9417.625, -6330.75)},
					{occupied = false, pos = Vector(-2067.9375, 11629.28125, -6340)},
					{occupied = false, pos = Vector(2746.5625, 7385.03125, -6334)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-1939, 13492, -6318), angles = Angle(0, 180, 0)},
				},
			},
			["hell"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-6427.40625, -9967.3125, -7286.4375), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-6001.875, -9808.0625, -7282.75), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-7776.6875, -8341, -7273), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-8087.8125, -8427.71875, -7274.59375), angles = Angle(0, 0, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-7399, -9808, -7230), angles = Angle(0, 180, 0)},
				},
			},
			["rough"] = {
				["longship"] = {
					{occupied = false, pos = Vector(9275.28125, 8330.0625, -6338.9375)},
					{occupied = false, pos = Vector(6780.6875, 10250.71875, -6334.1875)},
					{occupied = false, pos = Vector(6564.09375, 13210.03125, -6372.9375)},
					{occupied = false, pos = Vector(12241.09375, 13060.8125, -6325.8125)},
					{occupied = false, pos = Vector(11180.84375, 9724.34375, -6359.21875)},
					{occupied = false, pos = Vector(12100.0625, 6700.15625, -6345.15625)},
					{occupied = false, pos = Vector(6785.84375, 7462.71875, -6370.03125)},
					{occupied = false, pos = Vector(9380.34375, 5756.28125, -6350.15625)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(6984, 10383, -6312), angles = Angle(0, 180, 0)},
				},
			},
			["styx"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-7068.96875, 11547.34375, -6354.25), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-6981.4375, 9059.625, -6353.1875), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-7200.84375, 6400.71875, -6318.6875), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-10678.65625, 6590.59375, -6353.59375), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-12773.3125, 7341.09375, -6345.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-13250.3125, 13000.5, -6350.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-11920.90625, 10846.6875, -6364.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-9430.5, 11500, -6365.90625), angles = Angle(0, 0, 0)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-10942, 9260, -6332), angles = Angle(0, 90, 0)},
				},
			},
			["wasteland"] = {
				["longship"] = {
					{occupied = false, pos = Vector(13369, 10869, -1932), angles = Angle(0, -90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(13530, 10152, -1930), angles = Angle(0, -90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(12134, 10843, -1927), angles = Angle(0, -90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(12690, 8688, -1927), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(12558, 6973, -1929), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(13388, 6824, -1927), angles = Angle(0, -90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(12648, 8041, -1935), angles = Angle(0, -90, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(14406, 9225, -1913), angles = Angle(0, 0, 0)},
				},
			},
			["wastelandlava"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-13442, -14395, -1752), angles = Angle(0, 90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-14422, -13440, -1748), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-12431, 4962, -1752), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-12514, 3665, -1746), angles = Angle(0, 0, -0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-11391, -14609, -1747), angles = Angle(0, -90, 0)},
				},
			},
		};
	elseif game.GetMap() == "rp_district21" then
		cwSailing.shipLocations = {
			["docks"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-3103.90625, 385.65625, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2734.59375, 366.75, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2449.3125, 526.375, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-2075.25, 489.28125, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-2589, 373, 11619), angles = Angle(0, -90, 0)},
				},
			},
			["calm"] = {
				["longship"] = {
					{occupied = false, pos = Vector(1876.71875, 10203.3125, -6371.375)},
					{occupied = false, pos = Vector(790.40625, 11458, -6360)},
					{occupied = false, pos = Vector(640, 8000, -6350)},
					{occupied = false, pos = Vector(-808.40625, 6717.125, -6345.21875)},
					{occupied = false, pos = Vector(-2537.46875, 7600.9375, -6348.8125)},
					{occupied = false, pos = Vector(-1691.71875, 9417.625, -6330.75)},
					{occupied = false, pos = Vector(-2067.9375, 11629.28125, -6340)},
					{occupied = false, pos = Vector(2746.5625, 7385.03125, -6334)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-1939, 13492, -6318), angles = Angle(0, 180, 0)},
				},
			},
			["hell"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-6427.40625, -9967.3125, -7286.4375), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-6001.875, -9808.0625, -7282.75), angles = Angle(0, 180, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-7776.6875, -8341, -7273), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-8087.8125, -8427.71875, -7274.59375), angles = Angle(0, 0, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-7399, -9808, -7230), angles = Angle(0, 180, 0)},
				},
			},
			["rough"] = {
				["longship"] = {
					{occupied = false, pos = Vector(9275.28125, 8330.0625, -6338.9375)},
					{occupied = false, pos = Vector(6780.6875, 10250.71875, -6334.1875)},
					{occupied = false, pos = Vector(6564.09375, 13210.03125, -6372.9375)},
					{occupied = false, pos = Vector(12241.09375, 13060.8125, -6325.8125)},
					{occupied = false, pos = Vector(11180.84375, 9724.34375, -6359.21875)},
					{occupied = false, pos = Vector(12100.0625, 6700.15625, -6345.15625)},
					{occupied = false, pos = Vector(6785.84375, 7462.71875, -6370.03125)},
					{occupied = false, pos = Vector(9380.34375, 5756.28125, -6350.15625)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(6984, 10383, -6312), angles = Angle(0, 180, 0)},
				},
			},
			["styx"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-7068.96875, 11547.34375, -6354.25), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-6981.4375, 9059.625, -6353.1875), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-7200.84375, 6400.71875, -6318.6875), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-10678.65625, 6590.59375, -6353.59375), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-12773.3125, 7341.09375, -6345.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-13250.3125, 13000.5, -6350.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-11920.90625, 10846.6875, -6364.40625), angles = Angle(0, 0, 0)},
					{occupied = false, pos = Vector(-9430.5, 11500, -6365.90625), angles = Angle(0, 0, 0)},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-10942, 9260, -6332), angles = Angle(0, 90, 0)},
				},
			},
			["wasteland"] = {
				["longship"] = {
					{occupied = false, pos = Vector(-12337, -12851, -1081), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-13006, -12851, -1081), angles = Angle(0, 0, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-9137, -11912, -1081), angles = Angle(0, 90, 0), bodygroup = 1},
					{occupied = false, pos = Vector(-13822, -13339, -1081), angles = Angle(0, 90, 0), bodygroup = 1},
				},
				["ironclad"] = {
					{occupied = false, pos = Vector(-11858, -13461, -1081), angles = Angle(0, -90, 0)},
				},
			},
		};
	end
end

if not cwSailing.longships then
	cwSailing.longships = {};
end

function cwSailing:LongshipExists(itemID)
	for i, v in ipairs(self.longships) do
		if IsValid(v[2]) then
			if v[2].itemID and v[2].itemID == itemID then
				return v[2];
			end
		end
	end
end

function cwSailing:SpawnLongship(owner, location, itemTable)
	if IsValid(owner) then
		if !itemTable or !self:LongshipExists(itemTable.itemID) then
			local longshipEnt = ents.Create(itemTable.longshipEnt or "cw_longship");
			
			longshipEnt:Spawn();
			
			local destination = self:FindValidLongshipSpawn(longshipEnt, location);
			
			if itemTable and itemTable.itemID then
				longshipEnt.itemID = itemTable.itemID;
			end
			
			if destination then
				local longshipAngles = Angle(0, 90, 0);
				local longshipBodygroup = 0;
				
				if destination.angles then
					longshipAngles = destination.angles;
				end
				
				if destination.bodygroup then
					longshipBodygroup = destination.bodygroup;
				end
			
				longshipEnt:SetPos(destination.pos);
				longshipEnt:SetAngles(longshipAngles);
				longshipEnt:SetBodygroup(0, longshipBodygroup);

				if longshipEnt.longshipType == "ironclad" then
					local steamEngineEnt = longshipEnt:AttachSteamEngine();
					
					if IsValid(steamEngineEnt) then
						if itemTable then
							steamEngineEnt.fuel = itemTable:GetData("fuel") or 0;
						else
							steamEngineEnt.fuel = 0;
						end
					end
					
					if itemTable and itemTable:GetData("machinegunUpgrade") then
						longshipEnt:AttachMachinegun();
					end
				else
					local longshipHealth = 500;
					
					if owner:GetSubfaction() == "Clan Harald" then
						longshipHealth = 1000;
						longshipEnt:SetSkin(1);
					end
					
					if itemTable then
						longshipHealth = itemTable:GetData("health") or longshipHealth;
					end
					
					longshipEnt.health = longshipHealth;
					
					if longshipEnt.health < 500 then
						longshipEnt.repairable = true;
					else
						longshipEnt.repairable = false;
					end
				end
				
				longshipEnt:EmitSound("ambient/water/wave"..math.random(1, 6)..".wav");
				
				longshipEnt.destination = nil;
				longshipEnt.location = location;
				longshipEnt.owner = owner;
				longshipEnt.ownerID = owner:GetCharacterKey();
				longshipEnt.playersOnBoard = {};
				
				if location == "docks" then
					-- If the ship is still at port after five minutes and the docks are full, remove it and let someone else take a spot.
					self:CreateDockTimer(longshipEnt);
				end
				
				table.insert(self.longships, {longshipEnt:EntIndex(), longshipEnt});
				
				return longshipEnt;
			end
			
			-- No available spot found so remove it.
			Schema:EasyText(owner, "peru", "The location you are trying to spawn your longship in is currently full or invalid!");
			
			-- Add these so the owner gets refunded when it gets deleted.
			longshipEnt.owner = owner;
			longshipEnt.ownerID = owner:GetCharacterKey();
			
			longshipEnt:Remove();
		else
			Schema:EasyText(owner, "peru", "The longship for this scroll is already undocked!");
		end
	end
end

function cwSailing:CreateDockTimer(longshipEnt, timeOverride)
	local despawnTime = timeOverride or 300;
	
	-- Ironclad only gets 1 spot so increase the time to 15 minutes.
	if !timeOverride and longshipEnt.longshipType == "ironclad" then 
		despawnTime = 900;
	end;
	
	timer.Create("DockTimer_"..tostring(longshipEnt:EntIndex()), despawnTime, 1, function()
		if IsValid(longshipEnt) then
			if longshipEnt.location == "docks" then
				for i, v in ipairs(self.shipLocations["docks"][longshipEnt.longshipType]) do
					if v.occupied == false then
						return;
					end
				end
				
				if timer.Exists("SailTimer_"..tostring(longshipEnt:EntIndex())) then
					-- If the ship is still at port after five minutes and the docks are full, remove it and let someone else take a spot.
					self:CreateDockTimer(longshipEnt);
					
					return;
				end
				
				longshipEnt:Remove();
			end
		end
	end);
end

function cwSailing:BeginSailing(longshipEnt, destination, caller)
	local longshipEntPos = longshipEnt:GetPos();
	local longshipEntAngles = longshipEnt:GetAngles();

	--printp("ent pos: "..tostring(longshipEntPos));
	
	if caller:GetCharacterKey() == longshipEnt.ownerID then
		local owner = caller;
		
		if !IsValid(longshipEnt.owner) then
			longshipEnt.owner = caller;
		end
		
		--local ownerPos = longshipEnt.owner:GetPos();
		--printp("owner pos: "..tostring(ownerPos));
		
		local tr = util.TraceHull({
			start = owner:EyePos(),
			endpos = owner:GetPos() - Vector(0, 0, 100),
			maxs = owner:OBBMaxs(),
			mins = owner:OBBMins(),
			filter = function( ent ) return ( ent == longshipEnt ) end,
			collisiongroup = COLLISION_GROUP_NONE,
		});

		if IsValid(tr.Entity) and tr.Entity == longshipEnt then
			if longshipEnt.CanMove then
				if longshipEnt:CanMove() == false then return end;
			end
			
			longshipEnt.destination = destination;
			
			local sail_time = 30;
			--local sail_time = 5; -- for testing
			local sea_zone = self:DetermineSeaZone(longshipEnt, destination);
			
			if owner:GetSubfaction() == "Clan Harald" then
				sail_time = 10;
			end
			
			--printp("selected sea zone: "..sea_zone);
			Schema:EasyText(owner, "icon16/anchor.png", "cornflowerblue", "Setting sail in "..tostring(sail_time).." seconds!");
			Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", owner:Name().."'s "..longshipEnt.longshipType.." is setting sail to destination "..destination.."!");
			
			if longshipEnt.longshipType == "longship" then
				longshipEnt:EmitSound("ambient/machines/thumper_dust.wav");
			elseif longshipEnt.longshipType == "ironclad" then
				local filter = RecipientFilter();
				local filterTab = {};
				local zone = owner:GetCharacterData("LastZone");
				
				for _, v2 in _player.Iterator() do
					if v2:Alive() and v2:GetCharacterData("LastZone") == zone then
						if v2:GetPos():Distance2D(longshipEntPos) < 6000 then
							table.insert(filterTab, v2);
						end
					end
				end
				
				filter:AddPlayers(filterTab);

				longshipEnt:EmitSound("begotten/sfx/ironcladhorn.wav", 110, nil, nil, nil, nil, nil, filter);
				util.ScreenShake(longshipEntPos, 1, 20, 15, 1024, true);
			end
		
			Clockwork.chatBox:AddInTargetRadius(owner, "me", "prepares to set sail for "..tostring(self.shipDestinations[destination].name)..".", owner:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			
			longshipEnt:SetBodygroup(0, 0);
			
			timer.Create("SailTimer_"..tostring(longshipEnt:EntIndex()), sail_time, 1, function()
				if IsValid(longshipEnt) then
					local owner = longshipEnt.owner;
					
					if IsValid(owner) then
						local tr = util.TraceHull({
							start = owner:EyePos(),
							endpos = owner:GetPos() - Vector(0, 0, 100),
							maxs = owner:OBBMaxs(),
							mins = owner:OBBMins(),
							filter = function( ent ) return ( ent == longshipEnt ) end,
							collisiongroup = COLLISION_GROUP_NONE,
						});
						
						if IsValid(tr.Entity) and tr.Entity == longshipEnt then
							cwSailing:MoveLongship(longshipEnt, sea_zone);
							
							return;
						end
					end
				end
				
				longshipEnt:SetBodygroup(0, 1);
				
				--printp("Owner not within AA box");
				longshipEnt.destination = nil;
				--printp("sailing aborted!");
				
				Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", "Sailing aborted for "..longshipEnt.longshipType.." "..longshipEnt:EntIndex().."!");
			end);
		end
	else
		if longshipEnt.CanMove then
			if longshipEnt:CanMove() == false then return end;
		end
			
		longshipEnt.destination = destination;
		
		local sail_time = 30;
		local sea_zone = self:DetermineSeaZone(longshipEnt, destination);
		
		Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", "A "..longshipEnt.longshipType.." with no owner is setting sail to destination "..destination.."!");
		
		if longshipEnt.longshipType == "longship" then
			longshipEnt:EmitSound("ambient/machines/thumper_dust.wav");
		elseif longshipEnt.longshipType == "ironclad" then
			local filter = RecipientFilter();
			local filterTab = {};
			local zone = caller:GetCharacterData("LastZone");
			
			for _, v2 in _player.Iterator() do
				if v2:Alive() and v2:GetCharacterData("LastZone") == zone then
					if v2:GetPos():Distance2D(longshipEntPos) < 6000 then
						table.insert(filterTab, v2);
					end
				end
			end
			
			filter:AddPlayers(filterTab);

			longshipEnt:EmitSound("begotten/sfx/ironcladhorn.wav", 110, nil, nil, nil, nil, nil, filter);
			util.ScreenShake(longshipEntPos, 1, 20, 15, 1024, true);
		end
		
		longshipEnt:SetBodygroup(0, 0);
		
		timer.Create("SailTimer_"..tostring(longshipEnt:EntIndex()), sail_time, 1, function()
			if IsValid(longshipEnt) then
				cwSailing:MoveLongship(longshipEnt, sea_zone);
			end
		end);
	end
end

function cwSailing:DetermineSeaZone(longshipEnt, destination)
	local sea_zone = "calm"; -- default
	
	-- todo: maybe put sea_zone in destination table?
	if destination == "wasteland" or destination == "docks" then
		if longshipEnt.location == "wastelandlava" then
			sea_zone = "styx";
		else
			local owner = longshipEnt.owner;
			local rand;

			if IsValid(owner) then
				if owner:HasBelief("favored") then
					rand = math.random(6);
				elseif owner:HasTrait("marked") then
					rand = math.random(2);
				else
					rand = math.random(4);
				end
			else
				rand = math.random(4);
			end
			
			if rand == 1 then
				sea_zone = "rough";
			end
		end
	elseif destination == "hell" or destination == "wastelandlava" then
		sea_zone = "styx";
	end
	
	return sea_zone;
end

function cwSailing:MoveLongship(longshipEnt, location)
	if IsValid(longshipEnt) then
		if longshipEnt.longshipType == "ironclad" then
			local steamEngine = longshipEnt.steamEngine;
			
			if !IsValid(steamEngine) or !steamEngine:GetNWBool("turnedOn") or !steamEngine.fuel or steamEngine.fuel <= 0 then
				return false;
			end
		end
	
		local destination = self:FindValidLongshipSpawn(longshipEnt, location);
		
		if destination then
			local longshipAngles = Angle(0, 90, 0);
			local longshipCurAngles = longshipEnt:GetAngles();
			local longshipBodygroup = 0;
			
			if destination.angles then
				longshipAngles = destination.angles;
			end
			
			if destination.bodygroup then
				longshipBodygroup = destination.bodygroup;
			end
			
			--printp("Longship New Angles: "..tostring(longshipAngles));
			
			-- Cache positions of all players aboard the longship.
			local longshipPlayers = {};
			
			for _, player in _player.Iterator() do
				if IsValid(player) then
					local tr = util.TraceHull({
						start = player:EyePos(),
						endpos = player:GetPos() - Vector(0, 0, 100),
						maxs = player:OBBMaxs(),
						mins = player:OBBMins(),
						filter = function( ent ) return (ent == longshipEnt) end,
						collisiongroup = COLLISION_GROUP_NONE,
					});
					
					if IsValid(tr.Entity) and tr.Entity == longshipEnt then
						local longshipEntPos = longshipEnt:GetPos();
						local offset = self:GetPlayerOffset(longshipEnt, player, longshipAngles.y);
						
						if (!player.cwObserverMode) then
							if player.cloaked and player:GetNetVar("kinisgerCloak") then
								player.cloakedCheck = CurTime() + 10;
							end				
						
							player:GodEnable(); -- Stops fall damage and damage from falling into lava for example as there is a delay between the ship being teleported and the players being teleported. Also prevents them from being popped during transition.
							player:Freeze(true);
		
							timer.Simple(3, function()
								if IsValid(player) then
									player.disableMovement = true;
								end
							end);
						end
						
						player:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 3, 3);
						
						table.insert(longshipPlayers, {player, offset});
					end
				end
			end
		
			timer.Simple(5, function()
				if IsValid(longshipEnt) then
					longshipEnt.playersOnBoard = {};
					longshipEnt:SetPos(destination.pos);
					longshipEnt:SetAngles(longshipAngles);
					longshipEnt:SetBodygroup(0, longshipBodygroup);
					longshipEnt.location = location;
					
					--printp("Position index: "..tostring(longship.position));
					--printp("Longship Angles Set: "..tostring(longshipEnt:GetAngles()));
					
					if longshipEnt.spawnedNPCs then
						for i, v in ipairs(longshipEnt.spawnedNPCs) do
							local entity = Entity(v);
							
							if entity and (entity:IsNPC() or entity:IsNextBot()) then
								entity:Remove();
							end
						end
						
						longshipEnt.spawnedNPCs = nil;
					end
				
					if IsValid(longshipEnt.owner) then
						Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", longshipEnt.owner:Name().."'s longship with "..#longshipPlayers.." players aboard has arrived at "..location.."!");
					else
						Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", "A longship with no owner with "..#longshipPlayers.." players aboard has arrived at "..location.."!");
					end
					
					if longshipEnt.OnMoved then
						longshipEnt:OnMoved();
					end
					
					longshipEnt.checkCooldown = CurTime() + 2;
					
					local longshipNewPos = longshipEnt:GetPos();
				
					for i, longshipPlayerTab in ipairs(longshipPlayers) do
						local player = longshipPlayerTab[1];
						
						if IsValid(player) then
							local playerDist = longshipPlayerTab[2];
							local playerEyeAngles = player:EyeAngles();
							local playerNewPos = Vector(longshipNewPos.x + -playerDist.x, longshipNewPos.y + -playerDist.y, longshipNewPos.z + playerDist.z);
							
							--printp("Longship New Pos: "..tostring(longshipNewPos));
							--printp("Player: "..player:Name());
							--printp("Player Offset From Ship Center: "..tostring(playerDist));					
							--printp("Player New Pos: "..tostring(playerNewPos));
							
							local combined_y = math.abs(longshipAngles.y) + math.abs(longshipCurAngles.y);
							
							if math.abs(longshipAngles.y) >= 180 then
								combined_y = math.abs(longshipAngles.y) - math.abs(longshipCurAngles.y);
							end
							
							timer.Simple(0.2, function()
								if IsValid(player) then
									if (!player.cwObserverMode) then
										player:SetLocalVar("blackOut", true);
										
										--[[if !player:IsRagdolled() then
											player:Spawn();
										end]]--
										
										player:Freeze(true);
										player:GodEnable();
										
										timer.Simple(0.8, function()
											if IsValid(player) then
												if player.disableMovement then
													player.disableMovement = false;
													player:GodDisable(); -- Re-enable god mode.
													player:Freeze(false);
												end
												
												--[[print("Player Old Eye Angles: "..tostring(playerEyeAngles));
												print("Longship Old Angles: "..tostring(longshipCurAngles));
												print("Longship New Angles: "..tostring(longshipAngles));
												print("Combined Y: "..tostring(combined_y));
												print("Player New Eye Angles: "..tostring(Angle(playerEyeAngles.x, playerEyeAngles.y + combined_y, playerEyeAngles.z)));
												
												print("Player Pos Set: "..tostring(player:GetPos()));
												print("Player Eye Angles Set: "..tostring(player:EyeAngles()));]]--
												
												player:SetEyeAngles(Angle(playerEyeAngles.x, playerEyeAngles.y + combined_y, playerEyeAngles.z));
												player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 3, 0);
												player:SetLocalVar("blackOut", false);
											end
										end);
									end
																		
									if player:IsRagdolled() then
										local ragdoll = player.cwRagdollTab.entity;
										
										if IsValid(ragdoll) then
											ragdoll:GetPhysicsObject():EnableMotion(false);

											timer.Simple(0.1, function()
												if IsValid(ragdoll) then
													local ragdollAngles = ragdoll:GetPhysicsObject():GetAngles();
													
													ragdoll:GetPhysicsObject():SetAngles(Angle(ragdollAngles.x, ragdollAngles.y + combined_y, ragdollAngles.z));
													ragdoll:GetPhysicsObject():SetPos(playerNewPos + Vector(0, 0, 8), true);
													
													timer.Simple(1.5, function()
														if IsValid(ragdoll) then
															ragdoll:GetPhysicsObject():EnableMotion(true);
														end
													end);
												elseif IsValid(player) then
													player:SetPos(playerNewPos);
												end
											end);
										end
									else
										player:SetPos(playerNewPos);
									end
									
									local target = player.cwHoldingEnt;
									
									if IsValid(target) then
										local destinationRaised = playerNewPos + Vector(0, 0, 8);
									
										if IsValid(player.cwHoldingGrab) then
											player.cwHoldingGrab:SetComputePosition(destinationRaised);
										end
									
										if target:GetClass() == "prop_ragdoll" then
											local targetPos = target:GetPos();
											
											for j = 0, target:GetPhysicsObjectCount() - 1 do
												local phys = target:GetPhysicsObjectNum(j);
												local newPos = target:GetPos();
												
												newPos:Sub(targetPos);
												newPos:Add(destinationRaised);
												phys:Wake()
												phys:SetPos(newPos)
											end
										else
											target:SetPos(destinationRaised);
										end
									end
									
									if location == "calm" or location == "rough" or location == "styx" then
										table.insert(longshipEnt.playersOnBoard, player);
									end
								end
							end);
						end
					end
					
					if location == "docks" then
						self:CreateDockTimer(longshipEnt);
						
						longshipEnt.destination = nil;
					elseif location == "wasteland" then
						local alarm = self.gorewatchAlarm;

						if IsValid(alarm) and !alarm:GetNWBool("broken") then
							for _, v in _player.Iterator() do
								local faction = v:GetNetVar("kinisgerOverride") or v:GetFaction();
								
								if (faction == "Gatekeeper" or faction == "Holy Hierarchy" or faction == "Hillkeeper") and !v.cwObserverMode and v:GetPos():WithinAABox(cwSailing.gorewatchBounds[1], cwSailing.gorewatchBounds[2]) then
									timer.Simple(math.random(5, 10), function()
										local alarm = self.gorewatchAlarm;
										
										if IsValid(alarm) then
											if !alarm.nextAlarm or alarm.nextAlarm < CurTime() then
												alarm.nextAlarm = CurTime() + 180;
												
												util.ScreenShake(alarm:GetPos(), 1, 20, 15, 1024, true);
												
												Clockwork.chatBox:AddInRadius(nil, "localevent", "The Gorewatch alarm sounds, heralding the arrival of a Goreic host!", alarm:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 4);
												
												local alarmPos = alarm:GetPos();
												local filter = RecipientFilter();
												local filterTab = {};
												
												for _2, v2 in _player.Iterator() do
													if v2:Alive() and v2:GetCharacterData("LastZone") == "wasteland" then
														if v2:GetPos():Distance2D(alarmPos) < 6000 then
															table.insert(filterTab, v2);
														end
													end
												end
												
												filter:AddPlayers(filterTab);

												if IsValid(alarm.speaker) then
													alarm.speaker:EmitSound("warhorns/hell_alarm.mp3", 110, nil, nil, nil, nil, nil, filter);
												else
													alarm:EmitSound("warhorns/hell_alarm.mp3", 110, nil, nil, nil, nil, nil, filter);
												end
											end
										end
									end);
									
									break;
								end
							end
						end
						
						longshipEnt.destination = nil;
					elseif location == "calm" or location == "rough" or location == "styx" then
						--timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), 30, 1, function() -- for testing
						local duration = math.random(90, 120);
						
						if longshipEnt.longshipType == "ironclad" then
							duration = math.random(20, 30);
						else
							if IsValid(longshipEnt.owner) and longshipEnt.owner:GetSubfaction() == "Clan Harald" then
								duration = math.random(45, 60);
							end
						end
						
						if longshipEnt.destination == "hell" then
							duration = math.random(200, 240);

							for _, v in _player.Iterator() do
								if v:GetFaction() == "Children of Satan" and v:Alive() then
									v:SendLua([[Clockwork.Client:EmitSound("begotten/sfx/hellwind.wav")]]);
									Schema:EasyText(v, "red", "An overwhelming gust of infernal wind erupts past you, carrying the whispers of damned souls released from their suffering. The Dark Lord's domain has been breached by a Goreic host, and they will soon descend upon the manor.");
									v:HandleSanity(-15);
								end
							end
							
							timer.Simple(5, function()
								for _, v in _player.Iterator() do
									if v:GetFaction() == "Children of Satan" and v:Alive() then
										v:Disorient(5);
									end
								end
							end);
						end
						
						timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), duration, 1, function()
							--printp("Travel timer fired!");
							if IsValid(longshipEnt) and longshipEnt.destination then
								if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
									self:MoveLongship(longshipEnt, longshipEnt.destination);
								end
							end
						end);
					else
						longshipEnt.destination = nil;
					end
					
					self:UpdateLongship(longshipEnt);
				end
			end);
			
			return;
		end
		
		-- No available spot found.
		if IsValid(longshipEnt.owner) then
			Schema:EasyText(longshipEnt.owner, "peru", "The location you are trying to move your longship to is currently full or invalid! Waiting 30 more seconds.");
		end
		
		for _, player in _player.Iterator() do
			local tr = util.TraceHull({
				start = player:EyePos(),
				endpos = player:GetPos() - Vector(0, 0, 100),
				maxs = player:OBBMaxs(),
				mins = player:OBBMins(),
				filter = function( ent ) return ( ent == longshipEnt ) end,
				collisiongroup = COLLISION_GROUP_NONE,
			});
	
			if IsValid(tr.Entity) and tr.Entity == longshipEnt then
				local longshipEntPos = longshipEnt:GetPos();
				
				if (!player.cwObserverMode) then
					player:Freeze(false);
					player:SetGravity(1);
				end
			end
		end
		
		timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), 30, 1, function()
			--printp("Travel timer fired!");
			if IsValid(longshipEnt) and longshipEnt.destination then
				if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
					self:MoveLongship(longshipEnt, longshipEnt.destination);
				end
			end
		end);
	end
end

function cwSailing:FindValidLongshipSpawn(longshipEnt, location)
	local valid_spawns = {};
	local longshipType = longshipEnt.longshipType;
	
	if self.shipLocations[location][longshipType] then
		for i, v in ipairs(self.shipLocations[location][longshipType]) do
			if v.occupied == false then
				if location == "docks" then
					if game.GetMap() == "rp_district21" then
						-- Ironclad shares docking space with middle 2 longship docking spaces, so make sure they're clear.
						if longshipEnt.longshipType == "ironclad" then
							if !self.shipLocations[location]["longship"][2].occupied and !self.shipLocations[location]["longship"][3].occupied then
								table.insert(valid_spawns, v);
							end
							
							continue;
						else
							if !self.shipLocations[location]["ironclad"][1].occupied then
								table.insert(valid_spawns, v);
							end
							
							continue;
						end
					end
				end
				
				table.insert(valid_spawns, v);
			end
		end
	end
	
	if !(#valid_spawns > 0) then
		return;
	end
	
	local spawn = valid_spawns[math.random(1, #valid_spawns)];
	
	for i, v in ipairs(self.shipLocations[location][longshipType]) do
		if spawn.pos == v.pos then
			if IsValid(longshipEnt) then
				if longshipEnt.location and longshipEnt.position then
					self.shipLocations[longshipEnt.location][longshipEnt.longshipType][longshipEnt.position].occupied = false;
				end
				
				longshipEnt.location = location;
				longshipEnt.position = i;
			end
			
			spawn.occupied = true;
			
			return spawn;
		end
	end
end

function cwSailing:GetPlayerOffset(longshipEnt, player, new_y)
	local longshipEntAngles = longshipEnt:GetAngles();
	local longshipEntPos = longshipEnt:GetPos();
	local playerPos = player:GetPos();
	local offset = Vector(longshipEntPos.x + -playerPos.x, longshipEntPos.y + -playerPos.y, -(longshipEntPos.z + -playerPos.z) + 2);
	local old_y = longshipEntAngles.y;
	local combined_y = 0;
	
	if old_y < 0 then
		old_y = old_y + 360;
	end
	
	if new_y < 0 then
		new_y = new_y + 360;
	end
	
	--printp("Old Y: "..tostring(old_y));
	--printp("New Y: "..tostring(new_y));
	
	combined_y = new_y - old_y;
	
	if combined_y < 0 then
		combined_y = combined_y + 360;
	end
	
	--printp("Combined Y: "..tostring(combined_y));
	--printp("Old Offset: "..tostring(offset));
	
	local new_angle = Angle(0, combined_y, 0);
	new_angle:Normalize();
	
	offset:Rotate(new_angle);
	
	--printp("New Offset: "..tostring(offset));

	return offset;
end

function cwSailing:UpdateLongship(longshipEnt)
	if IsValid(longshipEnt) then
		if IsValid(longshipEnt.owner) then
			--longshipEnt.owner:SetCharacterData("longshipHP", longshipEnt.health);
		end
		
		if cwSailing.longships[longshipEnt:EntIndex()] then
			cwSailing.longships[longshipEnt:EntIndex()][2] = longshipEnt;
		else
			table.insert(self.longships, {longshipEnt:EntIndex(), longshipEnt});
		end
		
		if longshipEnt.location ~= "docks" then
			if timer.Exists("DockTimer_"..tostring(longshipEnt:EntIndex())) then
				timer.Remove("DockTimer_"..tostring(longshipEnt:EntIndex()))
			end
		end
	end
end

function cwSailing:RemoveLongship(longshipEnt)
	if IsValid(longshipEnt) then
		if !longshipEnt.husk then
			if longshipEnt.location and longshipEnt.position then
				self.shipLocations[longshipEnt.location][longshipEnt.longshipType][longshipEnt.position].occupied = false;
			end
		end
		
		if IsValid(longshipEnt.owner) then
			if longshipEnt.health then
				if longshipEnt.health > 0 then
					Schema:EasyText(longshipEnt.owner, "icon16/anchor.png", "cornflowerblue", "Your "..longshipEnt.longshipType.." has returned to its dock.");
				end
			else
				Schema:EasyText(longshipEnt.owner, "icon16/anchor.png", "cornflowerblue", "Your "..longshipEnt.longshipType.." has returned to its dock.");
			end
		end

		for i = 1, #self.longships do
			if self.longships[i][1] == longshipEnt:EntIndex() then
				table.remove(self.longships, i);
				break;
			end
		end
		
		if timer.Exists("DockTimer_"..tostring(longshipEnt:EntIndex())) then
			timer.Remove("DockTimer_"..tostring(longshipEnt:EntIndex()))
		end
		
		if timer.Exists("SailTimer_"..tostring(longshipEnt:EntIndex())) then
			timer.Remove("SailTimer_"..tostring(longshipEnt:EntIndex()))
		end
		
		if timer.Exists("TravelTimer_"..tostring(longshipEnt:EntIndex())) then
			timer.Remove("TravelTimer_"..tostring(longshipEnt:EntIndex()))
		end
	end
end

-- A function to load saved longships
function cwSailing:LoadLongships()
	local longships = Clockwork.kernel:RestoreSchemaData("plugins/sailing/"..game.GetMap())

	for k, v in pairs(longships) do
		local location = v.location;
		local position = v.position;
		
		if location and position then
			local longshipType = v.longshipType or "longship";
			
			if !self.shipLocations[location] or !self.shipLocations[location][longshipType] then return end;
			
			local destination = self.shipLocations[location][longshipType][position];
			
			if !destination then return end;
			
			local longshipEnt = ents.Create(v.class or "cw_longship");
			
			longshipEnt:Spawn();
			
			local longshipAngles = Angle(0, 90, 0);
			local longshipBodygroup = 0;
			
			if destination.angles then
				longshipAngles = destination.angles;
			end
			
			if destination.bodygroup then
				longshipBodygroup = destination.bodygroup;
			end
		
			longshipEnt:SetPos(destination.pos);
			longshipEnt:SetAngles(longshipAngles);
			longshipEnt:SetBodygroup(0, longshipBodygroup);

			if longshipType == "ironclad" then
				local steamEngineEnt = longshipEnt:AttachSteamEngine();
				
				if IsValid(steamEngineEnt) then
					if v.fuel then
						steamEngineEnt.fuel = v.fuel or 0;
					else
						steamEngineEnt.fuel = 0;
					end
				end
				
				if v.machinegun then
					longshipEnt:AttachMachinegun();
				end
			else
				local longshipHealth = 500;
				
				if v.skin then
					longshipEnt:SetSkin(v.skin);
				end
				
				if v.health then
					longshipHealth = v.health or longshipHealth;
				end
				
				longshipEnt.health = longshipHealth;
				
				if longshipEnt.health < 500 then
					longshipEnt.repairable = true;
				else
					longshipEnt.repairable = false;
				end
			end
			
			longshipEnt:EmitSound("ambient/water/wave"..math.random(1, 6)..".wav");
			
			longshipEnt.itemID = v.itemID;
			longshipEnt.location = location;
			longshipEnt.position = position;
			longshipEnt.ownerID = v.ownerID;
			longshipEnt.playersOnBoard = {};
			
			if v.cwInventory then
				longshipEnt.cwInventory = Clockwork.inventory:ToLoadable(v.cwInventory) or {};
			else
				longshipEnt.cwInventory = {};
			end
			
			longshipEnt.cwCash = v.cwCash or 0;
			
			if location == "docks" then
				-- If the ship is still at port after thirty minutes and the docks are full, remove it and let someone else take a spot.
				self:CreateDockTimer(longshipEnt, 1800);
			end
			
			table.insert(self.longships, {longshipEnt:EntIndex(), longshipEnt});
			
			return longshipEnt;
		end
	end
end

-- A function to save all active longships.
function cwSailing:SaveLongships()
	local longships = {}

	for k, v in pairs(ents.FindByClass("cw_longship*")) do
		if (v:GetClass() == "cw_longship_husk") then
			continue;
		end;
		
		local saveTab = {
			itemID = v.itemID,
			ownerID = v.ownerID,
			location = v.location,
			position = v.position,
			health = v.health,
			skin = v:GetSkin(),
		};
		
		if IsValid(v.steamEngine) then
			saveTab.fuel = v.steamEngine.fuel or 0;
		end
		
		if v.machinegun then
			saveTab.machinegun = true;
		end
		
		if v.cwInventory then
			saveTab.cwInventory = Clockwork.inventory:ToSaveable(v.cwInventory);
		end
		
		saveTab.cwCash = v.cwCash or 0;

		longships[#longships + 1] = saveTab;
	end

	Clockwork.kernel:SaveSchemaData("plugins/sailing/"..game.GetMap(), longships)
end

concommand.Add("cw_BurnShip", function(player, cmd, args)
	if player:GetFaction() == "Goreic Warrior" then
		return;
	end
	
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;
		
		if entity:GetPos():Distance(player:GetPos()) < 256 then
			if (entity:GetClass() == "cw_longship") then
				if entity.enchantment then
					Schema:EasyText(player, "peru", "This longship seems to have an invisible force that prevents it from being burnt!");
					
					return false;
				end
			
				local activeWeapon = player:GetActiveWeapon();
				
				if activeWeapon:IsValid() and activeWeapon:GetClass() == "cw_lantern" then
					local oil = player:GetNetVar("oil", 0);
				
					--if oil >= 75 then
					if oil >= 1 and player:IsWeaponRaised(activeWeapon) then
						local inventory = player:GetInventory();
						local oil_count = 0;
						
						for k, v in pairs(inventory) do
							if v and istable(v) then
								for k2, v2 in pairs(v) do
									if v2.uniqueID == "large_oil" then
										oil_count = oil_count + 1;
									end
								end
							end
						end
						
						if oil_count < 2 then
							Schema:EasyText(player, "peru", "You need at least two large oils to burn this longship!");
							
							return false;
						end
						
						if cwWeather and cwWeather.weather == "thunderstorm" or cwWeather.weather == "bloodstorm" or cwWeather.weather == "acidrain" then
							Schema:EasyText(player, "peru", "You cannot start a fire while it is raining outside!");
							
							return false;
						end
					
						--if !entity.destination then
							Clockwork.player:SetAction(player, "burn_longship", 10, 1, function() 
								if entity:IsValid() then
									if entity:GetPos():Distance(player:GetPos()) < 256 then
										local activeWeapon = player:GetActiveWeapon();
										
										if activeWeapon:IsValid() and activeWeapon:GetClass() == "cw_lantern" then
											local oil = player:GetNetVar("oil", 0);
											
											--if oil >= 75 then
											if oil >= 1 and player:IsWeaponRaised(activeWeapon) then
												local inventory = player:GetInventory();
												local oil_count = 0;
												
												for k, v in pairs(inventory) do
													if v and istable(v) then
														for k2, v2 in pairs(v) do
															if v2.uniqueID == "large_oil" then
																oil_count = oil_count + 1;
															end
														end
													end
												end
												
												if oil_count < 2 then
													Schema:EasyText(player, "peru", "You need at least two large oils to burn this longship!");
													
													return false;
												end
												
												if cwWeather and cwWeather.weather == "thunderstorm" or cwWeather.weather == "bloodstorm" or cwWeather.weather == "acidrain" then
													Schema:EasyText(player, "peru", "You cannot start a fire while it is raining outside!");
													
													return false;
												end
												
												for i = 1, 2 do 
													player:TakeItemByID("large_oil");
												end
												
												--[[local weaponItemTable = item.GetByWeapon(activeWeapon);
												
												if weaponItemTable then
													weaponItemTable:SetData("oil", math.Clamp(oil - 75, 0, 100));
													player:SetNetVar("oil", math.Round(weaponItemTable:GetData("oil"), 0));
												end]]--
												
												if !entity.health then
													entity.health = 500;
												end
											
												--if !entity.destination then
													--entity:Ignite(600, 0);
													entity:SetNWBool("Ignited", true);
													
													entity:EmitSound("ambient/fire/gascan_ignite1.wav");
													
													if timer.Exists("SailTimer_"..tostring(entity:EntIndex())) then
														timer.Remove("SailTimer_"..tostring(entity:EntIndex()));
														entity.destination = nil;
														entity:SetBodygroup(0, 1);
													end
													
													local owner = entity.owner;
													
													if (IsValid(owner) and owner:Alive()) then
														local subfaction = owner:GetSubfaction()
														local bHasBelief = owner:HasBelief("daring_trout")

														if (subfaction == "Clan Harald" and bHasBelief) then
															Schema:EasyText(owner, "icon16/anchor.png", "red", "A raven lands on your shoulder with smoldering wings! Your longship has been set alight and must be extinguished soon!")
															owner:SendLua([[Clockwork.Client:EmitSound("npc/crow/die" .. math.random(1, 2) .. ".wav", 70, 100)]])

															owner.nextLongshipNotify = CurTime() + 60
														end
													end
													
													Clockwork.chatBox:AddInTargetRadius(player, "me", "ignites the longship before them with their lantern!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
												--else
													--Schema:EasyText(player, "peru", "This longship cannot be lit on fire as it is currently setting sail!");
												--end
											else
												Schema:EasyText(player, "peru", "Your lantern must be lit in order to ignite this longship!");
											end
										end
									end
								end
							end);
						--else
							--Schema:EasyText(player, "peru", "This longship cannot be lit on fire as it is currently setting sail!");
						--end
					else
						Schema:EasyText(player, "peru", "Your lantern must be lit in order to ignite this longship!");
					end
				end
			end
		end
	end;
end);

concommand.Add("cw_CheckShipStatus", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;
		
		if IsValid(entity) and (entity.longshipType) then
			local status_string = "";
			
			if entity:GetClass() == "cw_longship_ironclad" then
				status_string = "A Shagalaxian Steel behemoth powered by a steam engine.";
				
				if entity.machinegun then
					status_string = status_string.." An Old World Machinegun is mounted on its bow.";
				end
			end
			
			if entity.health then
				local health = entity.health;
				
				if entity:GetSkin() == 1 then
					if health >= 1000 then
						status_string = status_string.."The longship looks to be in immaculate condition.";
					elseif health < 1000 and health >= 600 then
						status_string = status_string.."The longship looks to be slightly damaged.";
					elseif health < 600 and health >= 250 then
						status_string = status_string.."The longship looks to be moderately damaged, though still safe to sail.";
					else
						status_string = status_string.."The longship looks to be severely damaged. It is probably unsafe to sail in.";
					end
				else
					if health >= 500 then
						status_string = status_string.."The longship looks to be in immaculate condition.";
					elseif health < 500 and health >= 400 then
						status_string = status_string.."The longship looks to be slightly damaged.";
					elseif health < 400 and health >= 250 then
						status_string = status_string.."The longship looks to be moderately damaged, though still safe to sail.";
					else
						status_string = status_string.."The longship looks to be severely damaged. It is probably unsafe to sail in.";
					end
				end
			end
			
			if entity:GetNWBool("Ignited") then
				status_string = status_string.." It is currently on fire!";
			end
			
			if entity.destination then
				if cwSailing.shipDestinations[entity.destination] then
					status_string = status_string.." You remember that this "..entity.longshipType.." is headed to "..tostring(cwSailing.shipDestinations[entity.destination].name)..".";
				end
			end
			
			if status_string ~= "" then
				Schema:EasyText(player, "slateblue", status_string);
			end
			
			if player:IsAdmin() then
				status_string = "(ADMIN)";
			
				if IsValid(entity.owner) then
					status_string = status_string.." Ship Owner: "..entity.owner:Name();
				else
					status_string = status_string.." Ship Owner: None";
				end
				
				if entity.health then
					local health = entity.health;
					
					status_string = status_string.." Ship True HP: "..tostring(entity.health);
				end
				
				if timer.Exists("TravelTimer_"..tostring(entity:EntIndex())) then
					local timeLeft = timer.TimeLeft("TravelTimer_"..tostring(entity:EntIndex()));
					local timerPaused = false;
					
					if timeLeft < 0 then
						timerPaused = true;
					end
					
					status_string = status_string.." | ETA To Destination: "..tostring(math.abs(timeLeft)).." | Paused: "..tostring(timerPaused);
				end
				
				Schema:EasyText(player, "slateblue", status_string);
			end
			
			-- For debugging
			--[[local entPos = entity:GetPos();
			local playerPos = player:GetPos();
			local offset = Vector(entPos.x + -playerPos.x, entPos.y + -playerPos.y, -(entPos.z + -playerPos.z) + 2);
			
			printp("Offset: "..tostring(offset));]]--
		end
	end;
end);

concommand.Add("cw_ExtinguishShip", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_longship") then
			Clockwork.player:SetAction(player, "extinguish_longship", 10, 1, function() 
				if entity:IsValid() then
					if entity.health and entity.health > 0 then
						--entity:Extinguish();
						
						entity:SetNWBool("Ignited", false);
						entity:StopParticles();
					end
				end
			end);
		end
	end;
end);

concommand.Add("cw_RepairShip", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_longship") then
			local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
			local repairItemTable;

			for k, v in pairs (itemList) do
				if v.uniqueID == "wood" then
					repairItemTable = v;
					break;
				end
			end
			
			if repairItemTable then
				Clockwork.player:SetAction(player, "repair_longship", 30, 1, function() 
					if entity:IsValid() and player:HasItemInstance(repairItemTable) then
						if entity:GetSkin() == 1 then
							entity:SetHP(math.min(entity.health + 100, 1000));
						else
							entity:SetHP(math.min(entity.health + 100, 500));
						end
						
						player:TakeItem(repairItemTable, true);
					end
				end);
			else
				Schema:EasyText(player, "chocolate", "You do not have any wood to repair this Longship with!");
			end
		end
	end;
end);

concommand.Add("cw_MoveShipGoreForest", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if !entity.destination then
				if !entity:GetNWBool("Ignited") then
					if hook.Run("CanPlayerMoveLongship", entity, player) then
						cwSailing:BeginSailing(entity, "docks", player);
					else
						Schema:EasyText(player, "maroon", "You do not have permission to sail this "..entity.longshipType.."!");
					end
				else
					Schema:EasyText(player, "maroon", "This "..entity.longshipType.." cannot sail because it is on fire!");
				end
			else
				Schema:EasyText(player, "maroon", "This "..entity.longshipType.." is already preparing to sail!");
			end
		end
	end;
end);

concommand.Add("cw_MoveShipWasteland", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if !entity.destination then
				if !entity:GetNWBool("Ignited") then
					if hook.Run("CanPlayerMoveLongship", entity, player) then
						cwSailing:BeginSailing(entity, "wasteland", player);
					else
						Schema:EasyText(player, "maroon", "You do not have permission to sail this "..entity.longshipType.."!");
					end
				else
					Schema:EasyText(player, "maroon", "This "..entity.longshipType.." cannot sail because it is on fire!");
				end
			else
				Schema:EasyText(player, "maroon", "This "..entity.longshipType.." is already preparing to sail!");
			end
		end
	end;
end);

concommand.Add("cw_MoveShipLava", function(player, cmd, args)
	if game.GetMap() ~= "rp_begotten3" then return end;
	
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if entity.enchantment then
				if !entity.destination then
					if !entity:GetNWBool("Ignited") then
						if hook.Run("CanPlayerMoveLongship", entity, player) then
							cwSailing:BeginSailing(entity, "wastelandlava", player);
						else
							Schema:EasyText(player, "maroon", "You do not have permission to sail this "..entity.longshipType.."!");
						end
					else
						Schema:EasyText(player, "maroon", "This "..entity.longshipType.." cannot sail because it is on fire!");
					end
				else
					Schema:EasyText(player, "maroon", "This "..entity.longshipType.." is already preparing to sail!");
				end
			else
				Schema:EasyText(player, "chocolate", "Your longship lacks the enchantment required to navigate the River Styx safely.");
			end
		end
	end;
end);

concommand.Add("cw_MoveShipHell", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if entity.enchantment then
				if cwSailing.hellSailingEnabled then
					if !entity.destination then
						if !entity:GetNWBool("Ignited") then
							if hook.Run("CanPlayerMoveLongship", entity, player) then
								cwSailing:BeginSailing(entity, "hell", player);
							else
								Schema:EasyText(player, "maroon", "You do not have permission to sail this "..entity.longshipType.."!");
							end
						else
							Schema:EasyText(player, "maroon", "This "..entity.longshipType.." cannot sail because it is on fire!");
						end
					else
						Schema:EasyText(player, "maroon", "This "..entity.longshipType.." is already preparing to sail!");
					end
				else
					Schema:EasyText(player, "chocolate", "The mere thought of sailing to Hell drives a nail into your mind. Consult the gods for guidance.");
					player:HandleSanity(-5);

					Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "goldenrod", player:Name() .. " has attempted to sail to Hell while /ToggleHellSailing is disabled! Expect a prayer.")
				end
			else
				Schema:EasyText(player, "chocolate", "Your longship lacks the enchantment required to navigate the River Styx safely.");
			end
		end
	end;
end);

concommand.Add("cw_AbortSailing", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if timer.Exists("SailTimer_"..tostring(entity:EntIndex())) then
				if hook.Run("CanPlayerMoveLongship", entity, player) then
					entity:SetBodygroup(0, 1);
					entity.destination = nil;
					
					timer.Remove("SailTimer_"..tostring(entity:EntIndex()));
					
					Clockwork.chatBox:AddInTargetRadius(player, "me", "aborts their preparations for sailing.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					
					Schema:EasyText(Schema:GetAdmins(), "icon16/anchor.png", "cornflowerblue", "Sailing aborted for longship "..entity:EntIndex().." by "..player:Name().."!");
				else
					Schema:EasyText(player, "maroon", "You do not have permission to abort this "..entity.longshipType.."'s sailing!");
				end
			else
				Schema:EasyText(player, "maroon", "This "..entity.longshipType.." is not preparing to sail!");
			end
		end
	end;
end);

concommand.Add("cw_DockLongship", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if entity.location == "docks" then
				if !IsValid(entity.owner) or entity.owner:GetCharacterKey() ~= entity.ownerID or !entity.owner:Alive() or entity.owner:GetNetVar("tied") ~= 0 then
					entity.owner = player;
					entity.ownerID = player:GetCharacterKey();
				end
				
				if entity.owner == player then
					entity:Remove();
				else
					Schema:EasyText(player, "maroon", "This "..entity.longshipType.." does not belong to you!");
				end
			else
				Schema:EasyText(player, "maroon", "This "..entity.longshipType.." must be at the Gore Forest to dock!");
			end
		end
	end;
end);

concommand.Add("cw_CargoHold", function(player, cmd, args)
	if player:IsAdmin() or player:GetFaction() == "Goreic Warrior" or player:GetNetVar("kinisgerOverride") == "Goreic Warrior" then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity.longshipType) then
				if (!entity.cwInventory) then
					entity.cwInventory = {};
				end;
				
				if (!entity.cwCash) then
					entity.cwCash = 0;
				end

				player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				
				local weight = 40;
				
				if entity:GetClass() == "cw_longship_ironclad" then
					weight = 80;
				end
				
				Clockwork.storage:Open(player, {
					name = "Cargo Hold",
					weight = weight,
					entity = entity,
					distance = entity:OBBMaxs():Length(),
					inventory = entity.cwInventory,
					cash = entity.cwCash,
					OnGiveCash = function(player, storageTable, cash)
						entity.cwCash = storageTable.cash;
					end,
					OnTakeCash = function(player, storageTable, cash)
						entity.cwCash = storageTable.cash;
					end
				});
			end
		end;
	end;
end);

concommand.Add("cw_ShipTimerSpeed", function(player, cmd, args)
	if player:IsAdmin() then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local longshipEnt = trace.Entity;

			if (longshipEnt:GetClass() == "cw_longship" or longshipEnt:GetClass() == "cw_longship_ironclad") and longshipEnt.destination then
				if timer.Exists("TravelTimer_"..tostring(longshipEnt:EntIndex())) then
					timer.Adjust("TravelTimer_"..tostring(longshipEnt:EntIndex()), 5, 1, function()
						if IsValid(longshipEnt) and longshipEnt.destination then
							if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
								cwSailing:MoveLongship(longshipEnt, longshipEnt.destination);
							end
						end
					end);
				end
			end
		end;
	end
end);

concommand.Add("cw_ShipTimerPause", function(player, cmd, args)
	if player:IsAdmin() then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity.longshipType) and entity.destination then
				if timer.Exists("TravelTimer_"..tostring(entity:EntIndex())) then
					timer.Toggle("TravelTimer_"..tostring(entity:EntIndex()));
					
					if timer.TimeLeft("TravelTimer_"..tostring(entity:EntIndex())) < 0 then
						Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipTimerPause] Timer paused!");
					else
						Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipTimerPause] Timer unpaused!");
					end
				end
			end
		end;
	end
end);

concommand.Add("cw_ShipToggleEnchantment", function(player, cmd, args)
	if player:IsAdmin() then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity.longshipType) then
				if entity.enchantment then
					entity.enchantment = false;
					
					Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipToggleEnchantment] This ship can no longer navigate the River Styx!");
				else
					entity.enchantment = true;
					
					Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipToggleEnchantment] This ship can now navigate the River Styx!");
				end
				
				local itemID = entity.itemID;
				
				if itemID then
					local itemTable = item.FindInstance(itemID);

					if itemTable then
						itemTable:SetData("enchantment", entity.enchantment);
					end
				end
			end
		end;
	end
end);

concommand.Add("cw_ShipToggleFreeSailing", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity.longshipType) then
			if player:GetCharacterKey() == entity.ownerID then
				if entity:GetNWBool("freeSailing") then
					entity:SetNWBool("freeSailing", false);
					
					Schema:EasyText(player, "maroon", "You have disabled free sailing for this "..entity.longshipType..". Only you may sail it unless you are incapacitated.");
				else
					entity:SetNWBool("freeSailing", true);
					
					Schema:EasyText(player, "olivedrab", "You have enabled free sailing for this "..entity.longshipType..". Any Gore can now sail it.");
				end
			else
				Schema:EasyText(player, "maroon", "You do not have permission to toggle free sailing for this "..entity.longshipType.."!");
			end
		end
	end;
end);

concommand.Add("cw_RepairGorewatchAlarm", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_gorewatchalarm") and player:GetPos():Distance2D(entity:GetPos()) < 300 then
			if !entity:GetNWBool("broken") then
				Schema:EasyText(player, "chocolate", "The alarm system has already been repaired!");
				
				return;
			end
		
			local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
			local repairItemTable;

			for k, v in pairs (itemList) do
				if v.uniqueID == "tech" then
					repairItemTable = v;
					break;
				end
			end
			
			if repairItemTable then
				Clockwork.player:SetAction(player, "repair_alarm", 30, 1, function() 
					if entity:IsValid() and entity:GetNWBool("broken") and player:HasItemInstance(repairItemTable) then
						entity:SetNWBool("broken", false);
						entity:EmitSound("ambient/levels/caves/ol04_gearengage.wav");
						
						Clockwork.chatBox:AddInRadius(nil, "localevent", "With the clanging of gears, the repaired alarm system re-activates.", entity:GetPos(), 666);
						
						player:TakeItem(repairItemTable, true);
					end
				end);
			else
				Schema:EasyText(player, "chocolate", "You do not have any tech to repair the alarm system with!");
			end
		end
	end;
end);

concommand.Add("cw_SteamEngineRepair", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_steam_engine") and player:GetPos():Distance2D(entity:GetPos()) < 300 then
			if !entity:GetNWBool("broken") then
				Schema:EasyText(player, "chocolate", "The steam engine has already been fully repaired!");
				
				return;
			end
		
			local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
			local scrapRequired = 3;
			local scrapCount = 0;

			for k, v in pairs(itemList) do
				if v.uniqueID == "scrap" then
					scrapCount = scrapCount + 1;
					
					if scrapCount >= 3 then
						Clockwork.player:SetAction(player, "repair_steam_engine", 30, 1, function() 
							if entity:IsValid() and entity:GetNWBool("broken") then
								local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
								local scrapItems = {};
								
								for k, v in pairs(itemList) do
									if v.uniqueID == "scrap" then
										table.insert(scrapItems, v);
										
										if #scrapItems == 3 then
											break;
										end
									end
								end
								
								if #scrapItems == 3 then
									for i, v in ipairs(scrapItems) do
										player:TakeItem(v);
									end
									
									entity:SetNWBool("broken", false);
									entity:EmitSound("ambient/levels/caves/ol04_gearengage.wav");
								
									Clockwork.chatBox:AddInRadius(nil, "localevent", "With the clanging of gears, the repaired steam engine re-activates.", entity:GetPos(), 666);

									return;
								end
								
								Schema:EasyText(player, "chocolate", "You do not have enough scrap to repair the steam engine with! You require " .. tostring(scrapRequired) .. " scrap!");
							end
						end);
						
						return;
					end
				end
			end
			
			Schema:EasyText(player, "chocolate", "You do not have enough scrap to repair the steam engine with! You require " .. tostring(scrapRequired) .. " scrap!");
		end
	end;
end);

concommand.Add("cw_SteamEngineFuel", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_steam_engine") and player:GetPos():Distance2D(entity:GetPos()) < 300 then
			if args[1] == "refuel" then
				local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
				local refuelItemTable;

				for k, v in pairs (itemList) do
					if v.uniqueID == "charcoal" then
						refuelItemTable = v;
						break;
					end
				end
				
				if refuelItemTable then
					Clockwork.player:SetAction(player, "refuel_ironclad", 15, 1, function() 
						if entity:IsValid() and player:HasItemInstance(refuelItemTable) then
							entity:AddFuel(refuelItemTable);
							entity:EmitSound("ambient/levels/outland/forklift_stop.wav");
							
							if cwBeliefs then
								player:HandleXP(2);
							end
							
							player:TakeItem(refuelItemTable, true);
						end
					end);
				else
					Schema:EasyText(player, "chocolate", "You do not have any charcoal to fuel the steam engine with!");
				end
			else
				local fuel = entity.fuel;
				
				if fuel and fuel > 0 then
					Schema:EasyText(player, "olivedrab", "The fuel gauge reads "..tostring(math.Round(fuel, 2)).."%.");
				else
					Schema:EasyText(player, "chocolate", "The fuel gauge reads empty!");
				end
			end
		end
	end;
end);

concommand.Add("cw_SteamEngine", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_steam_engine") and player:GetPos():Distance2D(entity:GetPos()) < 300 then
			if args[1] == "on" then
				local bSuccess, fault = entity:TurnOn();
				
				if !bSuccess then
					if fault then
						Schema:EasyText(player, "chocolate", fault);
					else
						Schema:EasyText(player, "chocolate", "The steam engine cannot be turned on right now!");
					end
				end
			else
				local bSuccess, fault = entity:TurnOff();
				
				if !bSuccess then
					if fault then
						Schema:EasyText(player, "chocolate", fault);
					else
						Schema:EasyText(player, "chocolate", "The steam engine cannot be turned off right now!");
					end
				end
			end
		end
	end;
end);

function cwSailing:ContainerCanDropItems(entity)
	if (entity.longshipType) then
		return false;
	end;
end;