--[[
	Begotten III: Jesus Wept
	Scrap Factory Minigame
	By: DETrooper
--]]

cwScrapFactory.cycleTime = 75; -- 75 seconds to turn off all the valves
cwScrapFactory.machineSounds = {"ambient/levels/outland/ol03_bincreak01.wav", "ambient/levels/outland/ol03_bincreak02.wav", "ambient/levels/outland/ol03_bincreak03.wav", "ambient/levels/outland/ol03_bincreak04.wav", "ambient/levels/outland/ol03_bincreak05.wav"};
cwScrapFactory.maxoverheatingvalves = 6; -- max number of valves that might need to be turned during any given process cycle.
--cwScrapFactory.totalvalves = 8; -- max number of valves that can spawn at map start
cwScrapFactory.rewardXP = 200;

local map = game.GetMap();

if map == "rp_begotten3" then
	SCRAP_FACTORY_VALVES = {
		{spawnPosition = Vector(-2999.1875, -11968.40625, -1553.96875), spawnAngles = Angle(0, 90, -45), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-3690.9375, -12071.34375, -1585.25), spawnAngles = Angle(-9.580, 8.438, -51.812), steamAngles = Angle(60.513, 77.036, 153.501)},
		{spawnPosition = Vector(-2415.6875, -11432.03125, -1549.5), spawnAngles = Angle(0, 180, 45), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-2379.59375, -11629.90625, -1554.03125), spawnAngles = Angle(0, 180, 45), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-1462.90625, -11525.9375, -1549.125), spawnAngles = Angle(45, -90, 0), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-1426.6875, -11722.46875, -1554.40625), spawnAngles = Angle(45, -90, 0), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-623.75, -11466.59375, -1547.40625), spawnAngles = Angle(0, -90, -45), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-634.21875, -11330.71875, -1548.625), spawnAngles = Angle(45, 180, 0), steamAngles = Angle(45, -180, 0)},
		{spawnPosition = Vector(-345.09375, -12032, -1501.125), spawnAngles = Angle(90, -90, 180), steamAngles = Angle(0, 90, 0)},
		{spawnPosition = Vector(-735.4375, -11588.34375, -1427.125), spawnAngles = Angle(0, 0, 45), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-1563.3125, -11704.375, -1427.1875), spawnAngles = Angle(45, 0, 0), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-2447.9375, -11966.96875, -1426.96875), spawnAngles = Angle(45, 0, 0), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-2540.3125, -11460.65625, -1427.1875), spawnAngles = Angle(45, -90, 0), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-3238.6875, -11540.625, -1427.28125), spawnAngles = Angle(45, 0, 0), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-3411.40625, -11676.5625, -1551.6875), spawnAngles = Angle(45, 90, 0), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-3885.09375, -11878.71875, -1427.0625), spawnAngles = Angle(45, -90, 0), steamAngles = Angle(45, 90, 0)},
	};
	
	cwScrapFactory.coalBoxBounds = {["upper"] = Vector(-3716.030273, -11794.492188, -1215.335083), ["lower"] = Vector(-3772.80542, -11729.588867, -1258.917969)};
	cwScrapFactory.coalBoxOrigin = Vector(-3743.759033, -11763.916992, -1258.871704);
	cwScrapFactory.lowerLevelBounds = {["upper"] = Vector(-52.869308, -12183.576172, -1339.164551), ["lower"] = Vector(-4124.074219, -11233.364258, -1659.234375)};
	cwScrapFactory.machineSoundVector = Vector(-3707.699951, -11729.515625, -1187.269775);
	cwScrapFactory.orePilePos = Vector(6705.34375, -12330.09375, -709.125);
	cwScrapFactory.orePileAngles = Angle(2.505, 169.893, 2.988);
	cwScrapFactory.rewardPositions = {
		Vector(-3758, -11781, -1230),
		Vector(-3758, -11765, -1230),
		Vector(-3758, -11743, -1230),
		Vector(-3744, -11781, -1230),
		Vector(-3744, -11765, -1230),
		Vector(-3744, -11743, -1230),
		Vector(-3730, -11781, -1230),
		Vector(-3730, -11765, -1230),
		Vector(-3730, -11743, -1230),
	};
	cwScrapFactory.screenShakeVector = Vector(-2095, -11690, -1400);
elseif map == "rp_scraptown" then
	SCRAP_FACTORY_VALVES = {
		{spawnPosition = Vector(-5852.656250, -7414.375000, -986.812500), spawnAngles = Angle(89.995, -90.005, 180.000), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-6022.250000, -6605.062500, -969.906250), spawnAngles = Angle(0.000, -134.995, 0.000), steamAngles = Angle(60.513, 77.036, 153.501)},
		{spawnPosition = Vector(-6132.250000, -6712.500000, -1033.093750), spawnAngles = Angle(44.995, -1.983, 0.000), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-6243.250000, -6960.843750, -914.500000), spawnAngles = Angle(-45.000, -35.986, -45.000), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-6657.656250, -7098.968750, -1039.656250), spawnAngles = Angle(44.995, -8.350, -45.000), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-6366.250000, -7097.125000, -1040.187500), spawnAngles = Angle(0.000, 0.011, 0.000), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-6969.750000, -6894.375000, -1039.843750), spawnAngles = Angle(44.989, 89.995, 0.000), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-6876.343750, -7032.937500, -916.781250), spawnAngles = Angle(0.000, 127.991, -45.000), steamAngles = Angle(45, -180, 0)},
		{spawnPosition = Vector(-7420.968750, -6787.156250, -1037.437500), spawnAngles = Angle(44.995, -10.887, -45.000), steamAngles = Angle(0, 90, 0)},
		{spawnPosition = Vector(-7162.875000, -7440.906250, -914.406250), spawnAngles = Angle(0.000, 179.539, -45.000), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-8241.656250, -6899.093750, -1039.593750), spawnAngles = Angle(44.995, -11.091, -45.000), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-7957.968750, -7348.937500, -915.281250), spawnAngles = Angle(0.110, -91.066, -53.998), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-8467.968750, -7170.625000, -1042.843750), spawnAngles = Angle(44.995, -1.307, 45.000), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-9266.812500, -7064.406250, -995.312500), spawnAngles = Angle(-45.000, -89.995, -90.000), steamAngles = Angle(45, 180, 0)},
		{spawnPosition = Vector(-9288.093750, -7101.593750, -1018.187500), spawnAngles = Angle(44.995, -179.989, -90.000), steamAngles = Angle(45, -90, 0)},
		{spawnPosition = Vector(-9277.812500, -7470.062500, -1088.812500), spawnAngles = Angle(-49.340, 107.803, -53.547), steamAngles = Angle(45, 90, 0)},
		{spawnPosition = Vector(-9267.031250, -7140.687500, -855.375000), spawnAngles = Angle(45.000, 89.978, 90.000), steamAngles = Angle(45, 90, 0)},
	};
	
	cwScrapFactory.coalBoxBounds = {["upper"] = Vector(-9221, -7108, -704), ["lower"] = Vector(-9280, -7176, -747)};
	cwScrapFactory.coalBoxOrigin = Vector(-9247, -7144, -722);
	cwScrapFactory.lowerLevelBounds = {["upper"] = Vector(-5683, -6603, -821), ["lower"] = Vector(-9685, -7710, -1118)};
	cwScrapFactory.machineSoundVector = Vector(-9237, -7104, -667);
	cwScrapFactory.orePilePos = Vector(-3905.9375, -7302.96875, 140.3125);
	cwScrapFactory.orePileAngles = Angle(-5.224, -83.134, 8.289);
	cwScrapFactory.rewardPositions = {
		Vector(-9237, -7163, -718),
		Vector(-9252, -7163, -718),
		Vector(-9267, -7163, -718),
		Vector(-9237, -7143, -718),
		Vector(-9252, -7143, -718),
		Vector(-9267, -7143, -718),
		Vector(-9237, -7123, -718),
		Vector(-9252, -7123, -718),
		Vector(-9267, -7123, -718),
	};
	cwScrapFactory.screenShakeVector = Vector(-7348, -7089, -828);
end

function cwScrapFactory:StartProcessing()
	if !self.cycleInProgress then
		if self.valves and #self.valves > 0 then
			local overheating_valves = {};
			local valid_valves = {};
			
			for i = 1, #self.valves do
				if IsValid(self.valves[i]) then
					table.insert(valid_valves, self.valves[i]);
				end
			end
			
			if #valid_valves >= 6 then
				for i = 1, math.random(3, self.maxoverheatingvalves) do
					local random_valve = math.random(1, #valid_valves);
					
					valid_valves[random_valve]:StartOverheating();
					
					table.insert(overheating_valves, valid_valves[random_valve]);
					table.remove(valid_valves, random_valve);
				end
				
				timer.Create("ScrapCycleAlarmTimer", self.cycleTime - 20, 1, function()
					local players = _player.GetAll()
			
					for i = 1, _player.GetCount() do
						local player = players[i];
						
						if IsValid(player) then
							netstream.Start(player, "StartScrapFactoryAlarm");
						end
					end
				end);
				
				timer.Create("ScrapCycleTimer", self.cycleTime, 1, function()
					if self.cycleInProgress == true then
						self:ApplyPipesForces();
						self:StopProcessingCycle();
						self:StopValvesOverheating();
					end
				end);
			
				self.cycleInProgress = true;
			else
				printp("Less than 6 valves found!");
			end
		else
			printp("No valid valves found!");
		end
	end
end

function cwScrapFactory:CheckProcessingCycle()
	if self.cycleInProgress == true then
		if self.valves then
			for i = 1, #self.valves do
				if self.valves[i].overheating == true then
					return;
				end
			end
		end
	
		-- No valves are overheating, begin phase 2 and wait 30 seconds then distribute rewards.
		if timer.Exists("ScrapCycleAlarmTimer") then
			timer.Remove("ScrapCycleAlarmTimer")
		end
		
		if timer.Exists("ScrapCycleTimer") then
			timer.Remove("ScrapCycleTimer")
		end
		
		if IsValid(self.alarmEnt) then
			local players = _player.GetAll()
	
			for i = 1, _player.GetCount() do
				local player = players[i];
				
				if IsValid(player) then
					netstream.Start(player, "StopScrapFactoryAlarm");
				end
			end
		end
		
		timer.Simple(30, function()
			cwScrapFactory:StopProcessingCycle();
			
			local darkPresent = false;
			local familyPresent = false;
			local lightPresent = false;
			local voltistPresent = false;
			
			local scanPos = cwScrapFactory.rewardPositions[1];
			local playersPresent = {};
			
			for k, v in pairs(_player.GetAll()) do
				if IsValid(v) and v:HasInitialized() and v:Alive() and !Clockwork.player:IsNoClipping(v) then
					local lastZone = v:GetCharacterData("LastZone");
				
					if lastZone == "scrapper" then
						table.insert(playersPresent, v);
					
						if v:GetSharedVar("subfaith") == "Voltism" then
							voltistPresent = true;
						else
							local vFaith = v:GetFaith();
							
							if vFaith == "Faith of the Light" then
								lightPresent = true;
							elseif vFaith == "Faith of the Family" then
								familyPresent = true;
							elseif vFaith == "Faith of the Dark" then
								darkPresent = true;
							end
						end
					end
				end
			end
			
			if cwBeliefs and #playersPresent > 0 then
				local xpPerPlayer = math.Round(cwScrapFactory.rewardXP / #playersPresent);
			
				for i, v in ipairs(playersPresent) do
					v:HandleXP(xpPerPlayer)
				end
			end
			
			local bestResources = {"gold_ingot"};
			local greatResources = {"fine_steel_ingot"};
			local goodResources = {"steel_ingot"};
			local decentResources = {"iron_ingot"};
			local shitResources = {"wrought_iron_ingot"};
			
			if darkPresent then
				table.insert(bestResources, "hellforged_steel_ingot");
			end
			
			if familyPresent then
				table.insert(bestResources, "shagalaxian_steel_ingot");
			end
			
			if lightPresent then
				table.insert(bestResources, "maximilian_steel_ingot");
			end
			
			if voltistPresent then
				table.insert(bestResources, "technocraft");
				table.insert(greatResources, "tech");
				table.insert(goodResources, "tech");
			end
			
			for i = 1, #cwScrapFactory.rewardPositions do
				local position = cwScrapFactory.rewardPositions[i];
				local resource = "scrap";
				
				if i == 1 and voltistPresent then
					resource = "tech";
				else
					if math.random(1, 100) >= 75 then
						if math.random(1, 50) == 1 then
							resource = bestResources[math.random(1, #bestResources)];
						elseif math.random(1, 15) == 1 then
							resource = greatResources[math.random(1, #greatResources)];
						elseif math.random(1, 5) == 1 then
							resource = goodResources[math.random(1, #goodResources)];
						elseif math.random(1, 3) == 1 then
							resource = decentResources[math.random(1, #decentResources)];
						else
							resource = shitResources[math.random(1, #shitResources)];
						end
					end
				end
				
				local itemTable = item.CreateInstance(resource);

				if (itemTable) then
					local item = Clockwork.entity:CreateItem(nil, itemTable, position);

					item:Spawn();
					item:EmitSound("plats/elevbell1.wav");
				end
			end
		end);
	end
end

function cwScrapFactory:StopProcessingCycle()
	if self.cycleInProgress == true then
		if timer.Exists("ScrapCycleAlarmTimer") then
			timer.Remove("ScrapCycleAlarmTimer")
		end
		
		if timer.Exists("ScrapCycleTimer") then
			timer.Remove("ScrapCycleTimer")
		end
	
		if IsValid(self.alarmEnt) then
			local players = _player.GetAll()
	
			for i = 1, _player.GetCount() do
				local player = players[i];
				
				if IsValid(player) then
					netstream.Start(player, "StopScrapFactoryAlarm");
				end
			end
		end
		
		self.cycleInProgress = false;
	end
end

function cwScrapFactory:StopValvesOverheating()
	for i = 1, #self.valves do
		local valveEnt = self.valves[i];
		
		if valveEnt.overheating == true then
			valveEnt:StopOverheating();
		end
	end
end

function cwScrapFactory:PlayerUse(player, entity)
	if (entity:GetClass() == "cw_scrapfactoryvalve") then
		if entity.overheating == true then
			local position = player:GetPos();
			local distance = position:Distance(entity:GetPos())
			
			if (distance > 64) then
				return
			end;
			
			if (!player.cwUseActionEntity) then
				player.cwUseActionEntity = entity;
				
				local duration = 5;
				
				if player.GetCharmEquipped and player:GetCharmEquipped("wrench") then
					duration = 1;
				end
				
				Clockwork.player:SetUseKeyAction(player, "turn_scrapfactory_valve", duration, 1, function() 
					if (IsValid(entity)) then
						if (entity.overheating == true) then
							entity:EmitSound("buttons/lever2.wav");
							entity:StopOverheating();
							cwScrapFactory:CheckProcessingCycle();
						end;
					end;
				end);
			end;
		end;
	end;
end;

function cwScrapFactory:ApplyPipesForces()
	if self.cycleInProgress == true then
		util.ScreenShake(self.screenShakeVector, 5, 5, 2, 5000);
	
		local players = _player.GetAll()
			
		for i = 1, _player.GetCount() do
			local player = players[i];
			
			if IsValid(player) then
				local playerPos = player:GetPos();
				
				netstream.Start(player, "ScrapFactoryExplosion");
				
				if (!player.cwObserverMode) then
					if playerPos:WithinAABox(self.lowerLevelBounds["lower"], self.lowerLevelBounds["upper"]) then
						Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, 8);
						player:SendLua([[Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 80)]]);
								
						timer.Simple(0.2, function()
							if (IsValid(player)) then
								local ragdollEntity = player:GetRagdollEntity()
								local physicsObject = ragdollEntity:GetPhysicsObject()
								
								physicsObject:ApplyForceCenter(Vector(10000, 10000, 0));
							end
						end);
					end
				end
			end
		end
	end
end

--[[concommand.Add("cw_TurnScrapFactoryValve", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;

		if (entity:GetClass() == "cw_scrapfactoryvalve") then
			CreateSound(entity, "buttons/lever2.wav"):Play();
			
			Clockwork.player:SetAction(player, "turn_scrapfactory_valve", 10, 1, function() 
				if entity:IsValid() then
					if entity.overheating == true then
						entity:StopOverheating();
						
						cwScrapFactory:CheckProcessingCycle();
					end
				end
			end);
		end
	end;
end);]]--