--[[
	Begotten III: Jesus Wept
--]]

local weatherEffectCheckDelay = 5;

function cwWeather:ClockworkInitialized()
	self:SetWeather("normal");
	
	self.nextWeatherTime = CurTime() + math.random(900, 1500);
end

function cwWeather:SetWeather(weather, bSkipTransition)
	if (!table.HasValue(table.GetKeys(self.weatherTypes), weather)) then self.nextWeatherTime = CurTime() + 5; return; end
	
	self.nextWeatherTime = CurTime() + math.random(300, self.weatherTypes[weather].maxDuration or 1800);
	
	local oldWeather = self.weather or "normal";
	local weatherTable = self.weatherTypes[weather];
	local leadupTime = weatherTable.leadupTime;
	
	if bSkipTransition then leadupTime = nil end;
	
	if leadupTime then
		self.nextWeatherTime = self.nextWeatherTime + leadupTime;
	end

	timer.Create("WeatherChangeTimer", leadupTime or 0, 1, function()
		self.weather = weather;
		
		hook.Run("WeatherChanged", weather, oldWeather);
		
		netstream.Start(_player.GetAll(), "SetWeather", weather);
	end)
	
	if !bSkipTransition and weatherTable.leadupCallback then
		weatherTable.leadupCallback(oldWeather);
	end
end

function cwWeather:Think()
	local curTime = CurTime();
	
	if (self.nextWeatherTime and curTime <= self.nextWeatherTime) then return; end
	
	local currentWeatherTable = self.weatherTypes[self.weather];
	
	if currentWeatherTable.default then
		for k, v in RandomPairs(self.weatherTypes) do
			if !v.default and v.rarity and math.random(1, v.rarity) == 1 then self:SetWeather(k) return; end
		end
	end
	
	self:SetWeather("normal");
end

-- Called at an interval while the player is connected to the server.
function cwWeather:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if !initialized then return end;

	if !plyTab.nextWeatherEffectCheck then
		plyTab.nextWeatherEffectCheck = curTime + weatherEffectCheckDelay;
		
		return;
	end
	
	if plyTab.nextWeatherEffectCheck <= curTime then
		plyTab.nextWeatherEffectCheck = curTime + weatherEffectCheckDelay;
		
		if !alive or plyTab.cwObserverMode or plyTab.cwWakingUp then return end;
		
		local lastZone = player:GetCharacterData("LastZone");
		local zoneTable = zones:FindByID(lastZone);
		
		if !zoneTable or !zoneTable.hasWeather or !self:IsOutside(player:EyePos()) then return end;

		if lastZone == "wasteland" or lastZone == "tower" then
			local weather = self.weather;
			
			if weather == "acidrain" or weather == "bloodstorm" or weather == "thunderstorm" then
				if player:IsOnFire() then
					player:Extinguish();
				end
			end
		
			if weather == "thunderstorm" then
				if cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
					Schema:DoTesla(player, true);
				end
			elseif weather == "acidrain" then
				if cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
					Schema:DoTesla(player, true);
				end
				
				local armorItem = player:GetClothesEquipped();
				local helmetItem = player:GetHelmetEquipped();
				local shouldBurn = false;
				
				if !armorItem or (armorItem:GetCondition() or 0) <= 0 then
					shouldBurn = true;
				end
				
				if !helmetItem or (helmetItem:GetCondition() or 0) <= 0 then
					shouldBurn = true;
				end
				
				if !cwBeliefs or !player:HasBelief("ingenuity_finisher") then
					local hasScourRust = player:HasBelief("scour_the_rust");
				
					for k, v in pairs(player.equipmentSlots) do
						if v and v:IsInstance() then
							if !v.attributes or !table.HasValue(v.attributes, "conditionless") then
								if hasScourRust then
									v:TakeCondition(math.random(1, 2));
								else
									v:TakeCondition(math.random(1, 3));
								end
							end
						end
					end
				end
					
				if shouldBurn then
					local d = DamageInfo()
					d:SetDamage(math.random(1, 3));
					d:SetDamageType(DMG_BURN);
					d:SetDamagePosition(player:GetPos() + Vector(0, 0, 48));
					
					player:TakeDamageInfo(d);
					player:EmitSound("player/pl_burnpain"..math.random(1, 3)..".wav");
					
					Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(d:GetDamage()).." damage from acid rain, leaving them at "..player:Health().." health.");
				end
			end;
		end
	end
end

function cwWeather:PlayerCharacterInitialized(player)
	netstream.Start(player, "SetWeather", self.weather);
end

function cwWeather:ItemEntityThink(entity, itemTable)
	if self.weather == "acidrain" then
		local entPos = entity:GetPos() + Vector(0, 0, 4);
		
		if self:IsOutside(entPos) then
			for k, v in pairs(zones.stored) do
				local boundsTable = v.bounds;
				
				if boundsTable then
					if entPos:WithinAABox(boundsTable.min, boundsTable.max) then
						if !v.hasWeather then return end;
					end
				end
			end
			
			entity:TakeDamage(math.random(1, 3));
		end
	end
end

function cwWeather:PlayerCanBeIgnited(player)
	local lastZone = player:GetCharacterData("LastZone");
	local zoneTable = zones:FindByID(lastZone);
	
	if zoneTable and zoneTable.hasWeather then
		local weather = self.weather;
		
		if weather == "acidrain" or weather == "bloodstorm" or weather == "thunderstorm" then
			return false;
		end
	end
end

function cwWeather:ModifyStaminaDrain(player, drainTab)
	if self.weather == "ash" then
		local lastZone = player:GetCharacterData("LastZone");
		local zoneTable = zones:FindByID(lastZone);
		
		if zoneTable and zoneTable.hasWeather then
			if self:IsOutside(player:EyePos()) then
				drainTab.decrease = drainTab.decrease * 2;
			end
		end
	end
end

function cwWeather:PlayerRadioJammed(player, frequency, lastZone)
	local lastZone = player:GetCharacterData("LastZone");
	local zoneTable = zones:FindByID(lastZone);
	
	if zoneTable and zoneTable.hasWeather then
		if self.weather == "thunderstorm" then
			return true;
		end
	end
end

function cwWeather:WeatherChanged(weather, oldWeather)
	if weather == "bloodstorm" or oldWeather == "bloodstorm" then
		if Schema.spawnedNPCS then
			for i = 1, #Schema.spawnedNPCS do
				local entity = ents.GetByIndex(Schema.spawnedNPCS[i]);
				
				if IsValid(entity) and entity:IsZombie() then
					entity:Remove();
				end
			end
			
			Schema.spawnedNPCS = {};
		end
	end
end