--[[
	Begotten III: Jesus Wept
--]]

local drop = EffectData();
local map = game.GetMap();

if cwWeather.Emitter2D then
	cwWeather.Emitter2D:Finish()
	cwWeather.Emitter2D = nil;
end

function cwWeather:Think()
	if Clockwork.kernel:IsChoosingCharacter() and map ~= "rp_district21" then
		return;
	end

	if zones then
		local zoneTable = zones.currentZoneTable or zones.cwDefaultZone;
		
		if zoneTable then
			if !zoneTable.hasWeather then
				if self.loopingAmbience then
					self.loopingAmbience:FadeOut(2);
					self.loopingAmbience = nil;
				end
			
				return;
			end
		end
	end
	
	local weather = self.weather;
	
	if map == "rp_district21" and Clockwork.kernel:IsChoosingCharacter() then
		-- Always snow for title screen & char creation.
		weather = "snow";
	end

	if weather then
		local weatherTable = self.weatherTypes[weather];

		if weatherTable then
			local viewPos = EyePos();
			
			if weatherTable.precipitation then
				if !self.Emitter2D then
					self.Emitter2D = ParticleEmitter(viewPos);
				end
				
				self.Emitter2D:SetPos(viewPos);
			
				drop:SetOrigin(viewPos);
				util.Effect(weatherTable.precipitation, drop);
			else
				if self.Emitter2D then
					self.Emitter2D:Finish()
					self.Emitter2D = nil;
				end
			end
			
			local outside = self:IsOutside(viewPos);
		
			if weatherTable.ambience then
				local curTime = CurTime();
				
				if !self.nextWeatherAmbience or self.nextWeatherAmbience < curTime then
					self.nextWeatherAmbience = curTime + math.random(5, 10);
				
					if outside then
						Clockwork.Client:EmitSound(weatherTable.ambience[math.random(1, #weatherTable.ambience)] or "", 75, math.random(98, 102), 0.5);
					else
						if Clockwork.Client:InTower() then
							Clockwork.Client:EmitSound(weatherTable.ambience[math.random(1, #weatherTable.ambience)] or "", 75, math.random(98, 102), 0.05);
						else
							Clockwork.Client:EmitSound(weatherTable.ambience[math.random(1, #weatherTable.ambience)] or "", 75, math.random(98, 102), 0.25);
						end
					end
				end
			end
			
			if weatherTable.loopingAmbience then
				if !self.loopingAmbience then
					self.loopingAmbience = CreateSound(Clockwork.Client, weatherTable.loopingAmbience);
					
					if outside then
						self.loopingAmbience:PlayEx(0.4, 100);
					else
						if Clockwork.Client:InTower() then
							self.loopingAmbience:PlayEx(0.05, 100);
						else
							self.loopingAmbience:PlayEx(0.2, 100);
						end
					end
				end
				
				if outside and self.loopingAmbience:GetVolume() < 0.5 then
					self.loopingAmbience:ChangeVolume(0.5, 0.5);
				elseif !outside then
					if Clockwork.Client:InTower() and self.loopingAmbience:GetVolume() > 0.05 then
						self.loopingAmbience:ChangeVolume(0.05, 0.5);
					elseif self.loopingAmbience:GetVolume() > 0.25 then
						self.loopingAmbience:ChangeVolume(0.25, 0.5);
					end
				end
				
				return;
			end
		end
	end
	
	if self.Emitter2D then
		self.Emitter2D:Finish()
		self.Emitter2D = nil;
	end
	
	if self.loopingAmbience then
		self.loopingAmbience:FadeOut(2);
		self.loopingAmbience = nil;
	end
end

function cwWeather:OverrideZoneFogColors(zoneTable)
	if Clockwork.Client.dueling or Clockwork.kernel:IsChoosingCharacter() then return end;

	if self.weather and zoneTable.hasWeather then
		local weatherTable = self.weatherTypes[self.weather];
		
		if weatherTable then
			if cwDayNight and cwDayNight.nightWeight and zoneTable.hasNight then
				if weatherTable.fogColorsNight then
					local fogColors = weatherTable.fogColors;
					--local fogColorsNight = weatherTable.fogColorsNight;
					local fogColorsNight = zoneTable.fogColorsNight;
					
					return {r = Lerp(cwDayNight.nightWeight, fogColors.r, fogColorsNight.r), g = Lerp(cwDayNight.nightWeight, fogColors.g, fogColorsNight.g), b = Lerp(cwDayNight.nightWeight, fogColors.b, fogColorsNight.b)};
				end
			elseif weatherTable.fogColors then
				return weatherTable.fogColors;
			end
		end
	end
end

function cwWeather:OverrideZoneFogColorsSkybox(zoneTable)
	if Clockwork.Client.dueling or Clockwork.kernel:IsChoosingCharacter() then return end;

	if self.weather and zoneTable.hasWeather then
		local weatherTable = self.weatherTypes[self.weather];
		
		if weatherTable then
			return weatherTable.skyFix;
		end
	end
end

function cwWeather:OverrideZoneFogColorsSkyboxNight(zoneTable)
	if Clockwork.Client.dueling or Clockwork.kernel:IsChoosingCharacter() then return end;

	if self.weather and zoneTable.hasWeather then
		local weatherTable = self.weatherTypes[self.weather];
		
		if weatherTable then
			return weatherTable.skyFixNight;
		end
	end
end

function cwWeather:OverrideZoneFogDistance(zoneTable, fogStart, fogEnd)
	if Clockwork.kernel:IsChoosingCharacter() then
		if cwMapScene and Clockwork.Client.MenuVector and cwMapScene.curStored and cwMapScene.curStored.position and cwMapScene.curStored.position:IsEqualTol(Clockwork.Client.MenuVector, 5) then
			if game.GetMap() == "rp_district21" then
				return 128, 1024;
			else
				return 4000, 4028;
			end
		else
			return;
		end
	end

	if Clockwork.Client.dueling then return end;
	if Clockwork.Client:InTower() then return end;

	if self.weather and zoneTable.hasWeather then
		local weatherTable = self.weatherTypes[self.weather];
		
		if weatherTable then
			local targetStart, targetEnd;
			
			if cwDayNight and cwDayNight.nightWeight then
				if zoneTable.hasNight then
					if (zoneTable.fogStartNight and zoneTable.fogEndNight) then
						targetStart = Lerp(cwDayNight.nightWeight, weatherTable.fogStart or fogStart, weatherTable.fogStartNight or zoneTable.fogStartNight);
						targetEnd = Lerp(cwDayNight.nightWeight, weatherTable.fogEnd or fogEnd, weatherTable.fogEndNight or zoneTable.fogEndNight);
					end
				end
			end
			
			if game.GetMap() == "rp_district21" then
				if (!self:IsOutside(Clockwork.Client:GetPos()) and Clockwork.Client:InTower()) then
					targetStart = self.weatherTypes["normal"].fogStart * 1.5;
					targetEnd = self.weatherTypes["normal"].fogEnd * 1.5;
				end
			end

			if !targetStart or !targetEnd then
				targetStart = weatherTable.fogStart or fogStart;
				targetEnd = weatherTable.fogEnd or fogEnd;
			end
			
			return targetStart, targetEnd;
		end
	end
end

netstream.Hook("SetWeather", function(weather)
	cwWeather.weather = weather;
	
	local weatherTable = cwWeather.weatherTypes[weather];
	
	if cwWeather.loopingAmbience then
		if weatherTable.loopingAmbience and tostring(cwWeather.loopingAmbience) == "CSoundPatch ["..weatherTable.loopingAmbience.."]" then
			return;
		end
		
		cwWeather.loopingAmbience:FadeOut(2);
		cwWeather.loopingAmbience = nil;
	end
end);