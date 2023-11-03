--[[
	Begotten III: Jesus Wept
	Sailing
	By: DETrooper
--]]

SHIP_DESTINATIONS = {
	["docks"] = {name = "the Gore Forest"},
	["hell"] = {name = "Hell"},
	["pillars"] = {name = "the Pillars of Creation"},
	["wasteland"] = {name = "the Wasteland"},
};

if not SHIP_LOCATIONS then
	SHIP_LOCATIONS = {
		["docks"] = {
			{occupied = false, pos = Vector(-3103.90625, 385.65625, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-2734.59375, 366.75, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-2449.3125, 526.375, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-2075.25, 489.28125, 11600), angles = Angle(0, 180, 0), bodygroup = 1},
		},
		["calm"] = {
			{occupied = false, pos = Vector(1876.71875, 10203.3125, -6371.375)},
			{occupied = false, pos = Vector(790.40625, 11458, -6360)},
			{occupied = false, pos = Vector(640, 8000, -6350)},
			{occupied = false, pos = Vector(-808.40625, 6717.125, -6345.21875)},
			{occupied = false, pos = Vector(-2537.46875, 7600.9375, -6348.8125)},
			{occupied = false, pos = Vector(-1691.71875, 9417.625, -6330.75)},
			{occupied = false, pos = Vector(-2067.9375, 11629.28125, -6340)},
			{occupied = false, pos = Vector(2746.5625, 7385.03125, -6334)},
		},
		["hell"] = {
			{occupied = false, pos = Vector(-6427.40625, -9967.3125, -7286.4375), angles = Angle(0, 180, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-6001.875, -9808.0625, -7282.75), angles = Angle(0, 180, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-7776.6875, -8341, -7273), angles = Angle(0, 0, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-8087.8125, -8427.71875, -7274.59375), angles = Angle(0, 0, 0), bodygroup = 1},
		},
		["pillars"] = {
			{occupied = false, pos = Vector(-10496.59375, 252.625, -1753.875), angles = Angle(0, 90, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-11942.6875, -908.5, -1760.875), angles = Angle(0, 45, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-12148.46875, -2820.53125, -1746.59375), angles = Angle(0, 90, 0), bodygroup = 1},
			{occupied = false, pos = Vector(-11161.21875, -3833.46875, -1755.84375), angles = Angle(0, 135, 0), bodygroup = 1},
		},
		["rough"] = {
			{occupied = false, pos = Vector(9275.28125, 8330.0625, -6338.9375)},
			{occupied = false, pos = Vector(6780.6875, 10250.71875, -6334.1875)},
			{occupied = false, pos = Vector(6564.09375, 13210.03125, -6372.9375)},
			{occupied = false, pos = Vector(12241.09375, 13060.8125, -6325.8125)},
			{occupied = false, pos = Vector(11180.84375, 9724.34375, -6359.21875)},
			{occupied = false, pos = Vector(12100.0625, 6700.15625, -6345.15625)},
			{occupied = false, pos = Vector(6785.84375, 7462.71875, -6370.03125)},
			{occupied = false, pos = Vector(9380.34375, 5756.28125, -6350.15625)},
		},
		["styx"] = {
			{occupied = false, pos = Vector(-7068.96875, 11547.34375, -6354.25), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-6981.4375, 9059.625, -6353.1875), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-7200.84375, 6400.71875, -6318.6875), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-10678.65625, 6590.59375, -6353.59375), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-12773.3125, 7341.09375, -6345.40625), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-13250.3125, 13000.5, -6350.40625), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-11920.90625, 10846.6875, -6364.40625), angles = Angle(0, 0, 0)},
			{occupied = false, pos = Vector(-9430.5, 11500, -6365.90625), angles = Angle(0, 0, 0)},
		},
		["wasteland"] = {
			{occupied = false, pos = Vector(13921.59375, 6783.96875, -1913.40625), angles = Angle(0, 315, 0), bodygroup = 1},
			{occupied = false, pos = Vector(13556.78125, 7011.25, -1918.03125), angles = Angle(0, 315, 0), bodygroup = 1},
			{occupied = false, pos = Vector(12609.5625, 7953.28125, -1925.0625), angles = Angle(0, 315, 0), bodygroup = 1},
			{occupied = false, pos = Vector(13014.09375, 8767.59375, -1913.1875), angles = Angle(0, 270, 0), bodygroup = 1},
			{occupied = false, pos = Vector(13358.46875, 9641.65625, -1925.15625), angles = Angle(0, 315, 0), bodygroup = 1},
			{occupied = false, pos = Vector(13709.8125, 10730.25, -1921), angles = Angle(0, 225, 0), bodygroup = 1},
			{occupied = false, pos = Vector(13000.125, 10841.0625, -1923.03125), angles = Angle(0, 225, 0), bodygroup = 1},
			{occupied = false, pos = Vector(12022.3125, 10821.21875, -1927.6875), angles = Angle(0, 270, 0), bodygroup = 1},
		},
	};
end

if not cwSailing.longships then
	cwSailing.longships = {};
end

function cwSailing:SpawnLongship(owner, location)
	if IsValid(owner) then
		if !IsValid(owner.longship) then
			local longshipEnt = ents.Create("cw_longship");
			local destination = self:FindValidLongshipSpawn(longshipEnt, location);
			
			if destination then
				local longshipAngles = Angle(0, 90, 0);
				local longshipBodygroup = 0;
				--local longshipHealth = owner:GetCharacterData("longshipHP");
				local longshipHealth = 500;
				
				if destination.angles then
					longshipAngles = destination.angles;
				end
				
				if destination.bodygroup then
					longshipBodygroup = destination.bodygroup;
				end
				
				if (!longshipHealth) then
					--owner:SetCharacterData("longshipHP", longshipHealth);
				end
				
				if owner:GetSubfaction() == "Clan Harald" then
					longshipHealth = 1000;
				end
			
				longshipEnt:SetPos(destination.pos);
				longshipEnt:SetAngles(longshipAngles);
				longshipEnt:Spawn();
				longshipEnt:SetBodygroup(0, longshipBodygroup);
				
				if owner:GetSubfaction() == "Clan Harald" then
					longshipEnt:SetSkin(1);
				end
				
				longshipEnt.destination = nil;
				longshipEnt.health = longshipHealth;
				longshipEnt.ignited = false;
				longshipEnt.location = location;
				longshipEnt.owner = owner;
				longshipEnt.playersOnBoard = {};
				
				if longshipEnt.health < 500 then
					longshipEnt.repairable = true;
				else
					longshipEnt.repairable = false;
				end
				
				owner.longship = longshipEnt;
				
				if location == "docks" then
					timer.Create("DockTimer_"..tostring(longshipEnt:EntIndex()), 300, 1, function()
						if IsValid(longshipEnt) then
							-- If the ship is still at port after five minutes and the docks are full, remove it and let someone else take a spot.
							if longshipEnt.location == "docks" then
								for j = 1, #SHIP_LOCATIONS["docks"] do
									if SHIP_LOCATIONS["docks"][j].occupied == false then
										return;
									end
								end
								
								longshipEnt:Remove();
							end
						end
					end);
				end
				
				table.insert(self.longships, {longshipEnt:EntIndex(), longshipEnt});
				
				return;
			end
			
			-- No available spot found so remove it.
			Schema:EasyText(owner, "peru", "The location you are trying to spawn your longship in is currently full or invalid!");
			longshipEnt:Remove();
		else
			Schema:EasyText(owner, "peru", "You already have a longship!");
		end
	end
end

function cwSailing:BeginSailing(longshipEnt, destination)
	local longshipEntPos = longshipEnt:GetPos();
	local longshipEntAngles = longshipEnt:GetAngles();
	local longshipEntBoundingBox = self:GetLongshipBoundingBox(longshipEnt);

	--printp("ent pos: "..tostring(longshipEntPos));
	--printp("ent bb1: "..tostring(longshipEntBoundingBox["lower"]));
	--printp("ent bb2: "..tostring(longshipEntBoundingBox["upper"]));
	
	if IsValid(longshipEnt.owner) then
		--local ownerPos = longshipEnt.owner:GetPos();
		--printp("owner pos: "..tostring(ownerPos));
		--printp("owner is on board: "..tostring(ownerPos:WithinAABox(longshipEntBoundingBox["lower"], longshipEntBoundingBox["upper"])));
		local tr = util.TraceLine({
			start = longshipEnt.owner:GetPos(),
			endpos = longshipEnt.owner:GetPos() - Vector(0, 0, 64),
			filter = function( ent ) return ( ent:GetClass() == "cw_longship" ) end,
			collisiongroup = COLLISION_GROUP_NONE,
		});
				
		--if ownerPos:WithinAABox(longshipEntBoundingBox["lower"], longshipEntBoundingBox["upper"]) then
		if IsValid(tr.Entity) then
			longshipEnt.destination = destination;
			
			local sail_time = 30;
			--local sail_time = 5; -- for testing
			local sea_zone = self:DetermineSeaZone(longshipEnt, destination);
			
			--printp("selected sea zone: "..sea_zone);
			Schema:EasyText(longshipEnt.owner, "icon16/anchor.png", "cornflowerblue", "Setting sail in "..tostring(sail_time).." seconds!");
			Schema:EasyText(GetAdmins(), "icon16/anchor.png", "cornflowerblue", longshipEnt.owner:Name().."'s longship is setting sail to destination "..destination.."!");
			
			longshipEnt:SetBodygroup(0, 0);
			
			timer.Create("SailTimer_"..tostring(longshipEnt:EntIndex()), sail_time, 1, function()
				if IsValid(longshipEnt) then
					if IsValid(longshipEnt.owner) and longshipEnt.owner then
						--local ownerPos = longshipEnt.owner:GetPos();
						local tr = util.TraceLine({
							start = longshipEnt.owner:GetPos(),
							endpos = longshipEnt.owner:GetPos() - Vector(0, 0, 64),
							filter = function( ent ) return ( ent:GetClass() == "cw_longship" ) end,
							collisiongroup = COLLISION_GROUP_NONE,
						});
						
						--if ownerPos:WithinAABox(longshipEntBoundingBox["lower"], longshipEntBoundingBox["upper"]) then
						if IsValid(tr.Entity) then
							cwSailing:MoveLongship(longshipEnt, longshipEntBoundingBox, sea_zone);
							
							return;
						end
					end
				end
				
				longshipEnt:SetBodygroup(0, 1);
				
				--printp("Owner not within AA box");
				longshipEnt.destination = nil;
				--printp("sailing aborted!");
				
				Schema:EasyText(GetAdmins(), "icon16/anchor.png", "cornflowerblue", "Sailing aborted for longship "..longshipEnt:EntIndex().."!");
			end);
		end
	else
		longshipEnt.destination = destination;
		
		local sail_time = 30;
		local sea_zone = self:DetermineSeaZone(longshipEnt, destination);
		
		timer.Create("SailTimer_"..tostring(longshipEnt:EntIndex()), sail_time, 1, function()
			if IsValid(longshipEnt) then
				cwSailing:MoveLongship(longshipEnt, longshipEntBoundingBox, sea_zone);
			end
		end);
	end
end

function cwSailing:DetermineSeaZone(longshipEnt, destination)
	local sea_zone = "calm"; -- default
	
	-- todo: maybe put sea_zone in destination table?
	if destination == "wasteland" or destination == "docks" then
		local rand = math.random(4);
		
		if rand > 3 then
			sea_zone = "rough";
		end
	elseif destination == "hell" or destination == "pillars" then
		sea_zone = "styx";
	end
	
	return sea_zone;
end

function cwSailing:MoveLongship(longshipEnt, longshipEntBoundingBox, location)
	if IsValid(longshipEnt) then
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
			local players = _player.GetAll()
			
			for j = 1, _player.GetCount() do
				local player = players[j];
				
				if IsValid(player) then
					--local playerPos = player:GetPos();
					local tr = util.TraceLine({
						start = player:GetPos(),
						endpos = player:GetPos() - Vector(0, 0, 64),
						filter = function( ent ) return ( ent:GetClass() == "cw_longship" ) end,
						collisiongroup = COLLISION_GROUP_NONE,
					});
					
					--if playerPos:WithinAABox(longshipEntBoundingBox["lower"], longshipEntBoundingBox["upper"]) then
					if IsValid(tr.Entity) then
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
						
						player:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 5, 5);
						
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
					
					if IsValid(longshipEnt.owner) then
						Schema:EasyText(GetAdmins(), "icon16/anchor.png", "cornflowerblue", longshipEnt.owner:Name().."'s longship with "..#longshipPlayers.." players aboard has arrived at "..location.."!");
					else
						Schema:EasyText(GetAdmins(), "icon16/anchor.png", "cornflowerblue", "A longship with no owner with "..#longshipPlayers.." players aboard has arrived at "..location.."!");
					end
					
					local longshipNewPos = longshipEnt:GetPos();
					
					if IsValid(longshipEnt) then
						for j = 1, #longshipPlayers do
							local player = longshipPlayers[j][1];
							
							if IsValid(player) then
								local playerDist = longshipPlayers[j][2];
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
											player:SetSharedVar("blackOut", true);
											
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
													player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
													player:SetSharedVar("blackOut", false);
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
														ragdoll:GetPhysicsObject():SetPos(playerNewPos + Vector(0, 0, 32), true);
														
														timer.Simple(1.5, function()
															if IsValid(ragdoll) then
																ragdoll:GetPhysicsObject():EnableMotion(true);
															end
														end);
													elseif IsValid(player) then
														player:SetPos(playerNewPos + Vector(0, 0, 16));
													end
												end);
											end
										else
											player:SetPos(playerNewPos + Vector(0, 0, 8));
										end
										
										local target = player.cwHoldingEnt;
										
										if IsValid(target) then
											local destinationRaised = playerNewPos + Vector(0, 0, 32);
										
											if IsValid(player.cwHoldingGrab) then
												player.cwHoldingGrab:SetComputePosition(destinationRaised);
											end
										
											if target:GetClass() == "prop_ragdoll" then
												local targetPos = target:GetPos();
												
												for i = 0, target:GetPhysicsObjectCount() - 1 do
													local phys = target:GetPhysicsObjectNum(i);
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
					end
					
					if location == "docks" then
						timer.Create("DockTimer_"..tostring(longshipEnt:EntIndex()), 300, 1, function()
							if IsValid(longshipEnt) then
								-- If the ship is still at port after five minutes and the docks are full, remove it and let someone else take a spot.
								if longshipEnt.location == "docks" then
									for j = 1, #SHIP_LOCATIONS["docks"] do
										if SHIP_LOCATIONS["docks"][j].occupied == false then
											return;
										end
									end
									
									longshipEnt:Remove();
								end
							end
						end);
						
						longshipEnt.destination = nil;
					elseif location == "wasteland" or location == "hell" or location == "pillars" then
						longshipEnt.destination = nil;
					elseif location == "calm" or location == "rough" or location == "styx" then
						--timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), 30, 1, function() -- for testing
						local duration = math.random(180, 240);
						
						if IsValid(longshipEnt.owner) and longshipEnt.owner:GetSubfaction() == "Clan Harald" then
							duration = math.random(90, 150);
						end
						
						timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), duration, 1, function()
							--printp("Travel timer fired!");
							if IsValid(longshipEnt) and longshipEnt.destination then
								if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
									self:MoveLongship(longshipEnt, self:GetLongshipBoundingBox(longshipEnt), longshipEnt.destination);
								end
							end
						end);
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
		
		local players = _player.GetAll()
		
		for i = 1, _player.GetCount() do
			local player = players[i];
			
			if IsValid(player) then
				--local playerPos = player:GetPos();
				local tr = util.TraceLine({
					start = player:GetPos(),
					endpos = player:GetPos() - Vector(0, 0, 64),
					filter = function( ent ) return ( ent:GetClass() == "cw_longship" ) end,
					collisiongroup = COLLISION_GROUP_NONE,
				});
				
				--if playerPos:WithinAABox(longshipEntBoundingBox["lower"], longshipEntBoundingBox["upper"]) then
				if IsValid(tr.Entity) then
					local longshipEntPos = longshipEnt:GetPos();
					
					if (!player.cwObserverMode) then
						player:Freeze(false);
						player:SetGravity(1);
					end
				end
			end
		end
		
		timer.Create("TravelTimer_"..tostring(longshipEnt:EntIndex()), 30, 1, function()
			--printp("Travel timer fired!");
			if IsValid(longshipEnt) and longshipEnt.destination then
				if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
					self:MoveLongship(longshipEnt, self:GetLongshipBoundingBox(longshipEnt), longshipEnt.destination);
				end
			end
		end);
	end
end

function cwSailing:FindValidLongshipSpawn(longshipEnt, location)
	local valid_spawns = {};
	
	if SHIP_LOCATIONS[location] then
		for i = 1, #SHIP_LOCATIONS[location] do
			if SHIP_LOCATIONS[location][i].occupied == false then
				table.insert(valid_spawns, SHIP_LOCATIONS[location][i]);
			end
		end
	end
	
	if !(#valid_spawns > 0) then
		return;
	end
	
	local spawn = valid_spawns[math.random(1, #valid_spawns)];
	
	for i = 1, #SHIP_LOCATIONS[location] do
		if spawn.pos == SHIP_LOCATIONS[location][i].pos then
			if IsValid(longshipEnt) then
				if longshipEnt.location and longshipEnt.position then
					SHIP_LOCATIONS[longshipEnt.location][longshipEnt.position].occupied = false;
				end
				
				longshipEnt.location = location;
				longshipEnt.position = i;
			end
			
			spawn.occupied = true;
			
			return spawn;
		end
	end
end

function cwSailing:GetLongshipBoundingBox(longshipEnt)
	local longshipEntAngles = longshipEnt:GetAngles();
	local longshipEntPos = longshipEnt:GetPos();
	local y = math.Round(longshipEntAngles.y);
	
	local lower_vector_offset = Vector(100, 525, 38.5);
	local upper_vector_offset = Vector(-100, -525, 200);
	
	--printp("Bounding Box Lower: "..tostring(lower_vector_offset));
	--printp("Bounding Box Upper: "..tostring(upper_vector_offset));
	--printp("Y Rotation: "..tostring(y));
	
	if math.abs(y) ~= 180 then
		lower_vector_offset:Rotate(Angle(0, y, 0));
		upper_vector_offset:Rotate(Angle(0, y, 0));
		
		--printp("New Bounding Box Lower: "..tostring(lower_vector_offset));
		--printp("New Bounding Box Upper: "..tostring(upper_vector_offset));
	end
	
	local lower_vector = Vector(longshipEntPos + lower_vector_offset);
	local upper_vector = Vector(longshipEntPos + upper_vector_offset);
	
	return {["lower"] = lower_vector, ["upper"] = upper_vector};
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
				SHIP_LOCATIONS[longshipEnt.location][longshipEnt.position].occupied = false;
			end
		end
		
		if IsValid(longshipEnt.owner) then
			longshipEnt.owner.longship = nil;
			
			if longshipEnt.health then
				if longshipEnt.health > 0 then
					Schema:EasyText(longshipEnt.owner, "icon16/anchor.png", "cornflowerblue", "Your longship has returned to its dock.");
				end
			else
				Schema:EasyText(longshipEnt.owner, "icon16/anchor.png", "cornflowerblue", "Your longship has returned to its dock.");
			end
		end

		for i = 1, #cwSailing.longships do
			if cwSailing.longships[i][1] == longshipEnt:EntIndex() then
				table.remove(cwSailing.longships, i);
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

--[[concommand.Add("cw_BurnShip", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;
		
		if (entity:GetClass() == "cw_longship") then
			if !entity.destination then -- Ship is sailing.
				Clockwork.player:SetAction(player, "burn_longship", 10, 1, function() 
					if entity:IsValid() then
						if !entity.destination then
							if entity.health and entity.health > 0 then
								entity:Ignite(300, 0);
								entity.ignited = true;
							end
						else
							Schema:EasyText(player, "peru", "This longship cannot be lit on fire as it is currently setting sail!");
						end
					end
				end);
			else
				Schema:EasyText(player, "peru", "This longship cannot be lit on fire as it is currently setting sail!");
			end
		end
	end;
end);]]--

concommand.Add("cw_CheckShipStatus", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;
		local status_string = "";
		
		if (entity:GetClass() == "cw_longship") then
			if entity.health then
				local health = entity.health;
				
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
			
			if entity.destination then
				if SHIP_DESTINATIONS[entity.destination] then
					status_string = status_string.." You remember that this longship is headed to "..tostring(SHIP_DESTINATIONS[entity.destination].name)..".";
				end
			end
			
			Schema:EasyText(player, "slateblue", status_string);
			
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
						entity:Extinguish();
						entity.ignited = false;
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
					if entity:IsValid() then
						entity:SetHP(500);
					end
				end);
				
				player:TakeItem(repairItemTable, true);
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

		if (entity:GetClass() == "cw_longship") then
			if !entity.destination then
				if !entity.ignited then
					if player:GetFaction() == "Goreic Warrior" or player:IsAdmin() then
						if IsValid(entity.owner) then
							if entity.owner == player then
								cwSailing:BeginSailing(entity, "docks");
							end
						else
							cwSailing:BeginSailing(entity, "docks");
						end
					else
						Schema:EasyText(player, "maroon", "This longship cannot sail because it is on fire!");
					end
				end
			end
		end
	end;
end);

concommand.Add("cw_MoveShipWasteland", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_longship") then
			if !entity.destination then
				if !entity.ignited then
					if player:GetFaction() == "Goreic Warrior" or player:IsAdmin() then
						if IsValid(entity.owner) then
							if entity.owner == player then
								cwSailing:BeginSailing(entity, "wasteland");
							end
						else
							cwSailing:BeginSailing(entity, "wasteland");
						end
					else
						Schema:EasyText(player, "maroon", "This longship cannot sail because it is on fire!");
					end
				end
			end
		end
	end;
end);

concommand.Add("cw_MoveShipPillars", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_longship") then
			if entity.enchantment then
				if !entity.destination then
					if !entity.ignited then
						if player:GetFaction() == "Goreic Warrior" or player:IsAdmin() then
							if IsValid(entity.owner) then
								if entity.owner == player then
									cwSailing:BeginSailing(entity, "pillars");
								end
							else
								cwSailing:BeginSailing(entity, "pillars");
							end
						end
					else
						Schema:EasyText(player, "maroon", "This longship cannot sail because it is on fire!");
					end
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

		if (entity:GetClass() == "cw_longship") then
			if entity.enchantment then
				if !entity.destination then
					if !entity.ignited then
						if player:GetFaction() == "Goreic Warrior" then
							if IsValid(entity.owner) then
								if entity.owner == player then
									cwSailing:BeginSailing(entity, "hell");
								end
							else
								cwSailing:BeginSailing(entity, "hell");
							end
						end
					else
						Schema:EasyText(player, "maroon", "This longship cannot sail because it is on fire!");
					end
				end
			else
				Schema:EasyText(player, "chocolate", "Your longship lacks the enchantment required to navigate the River Styx safely.");
			end
		end
	end;
end);

concommand.Add("cw_CargoHold", function(player, cmd, args)
	if player:IsAdmin() or player:GetFaction() == "Goreic Warrior" then
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_longship") then
				if (!entity.cwInventory) then
					entity.cwInventory = {};
				end;

				player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
				
				Clockwork.storage:Open(player, {
					name = "Cargo Hold",
					weight = 40,
					entity = entity,
					distance = entity:OBBMaxs():Length(),
					inventory = entity.cwInventory,
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

			if (longshipEnt:GetClass() == "cw_longship") and longshipEnt.destination then
				if timer.Exists("TravelTimer_"..tostring(longshipEnt:EntIndex())) then
					timer.Adjust("TravelTimer_"..tostring(longshipEnt:EntIndex()), 5, 1, function()
						if IsValid(longshipEnt) and longshipEnt.destination then
							local longshipEntBoundingBox = cwSailing:GetLongshipBoundingBox(longshipEnt);
							
							if longshipEnt.location == "calm" or longshipEnt.location == "rough" or longshipEnt.location == "styx" then
								cwSailing:MoveLongship(longshipEnt, cwSailing:GetLongshipBoundingBox(longshipEnt), longshipEnt.destination);
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

			if (entity:GetClass() == "cw_longship") and entity.destination then
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

			if (entity:GetClass() == "cw_longship") then
				if entity.enchantment then
					entity.enchantment = false;
					
					Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipToggleEnchantment] This ship can no longer navigate the River Styx!");
				else
					entity.enchantment = true;
					
					Schema:EasyText(player, "icon16/anchor.png", "cornflowerblue", "[cw_ShipToggleEnchantment] This ship can now navigate the River Styx!");
				end
			end
		end;
	end
end);

function cwSailing:ContainerCanDropItems(entity)
	if (entity:GetClass() == "cw_longship") then
		return false;
	end;
end;