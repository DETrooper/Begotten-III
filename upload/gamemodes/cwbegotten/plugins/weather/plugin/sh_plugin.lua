--[[
	Begotten III: Jesus Wept
--]]

game.AddParticles("particles/v92_simpleweather.pcf")
PrecacheParticleSystem("v92_weather_snow")
PrecacheParticleSystem("v92_weather_blizzard")

PLUGIN:SetGlobalAlias("cwWeather");

cwWeather.enabledMaps = {
    ["rp_begotten3"] = true,
    ["rp_district21"] = true,
}

cwWeather.systemEnabled = cwWeather.enabledMaps[game.GetMap()];

if cwWeather.systemEnabled then
	Clockwork.kernel:IncludePrefixed("cl_hooks.lua")
	Clockwork.kernel:IncludePrefixed("sv_hooks.lua")

	if game.GetMap() == "rp_district21" then
		cwWeather.weatherTypes = {
			["blizzard"] = {
				ambience = {
					"ambience/weather/blizzardgust1.mp3",
					"ambience/weather/blizzardgust2.mp3",
					"ambience/weather/blizzardgust3.mp3",
					"ambience/weather/blusterygust1.mp3",
					"ambience/weather/blusterygust2.mp3",
					"ambience/weather/blusterygust3.mp3",
					"ambience/weather/blusterygust4.mp3",
					"ambience/weather/blusterygust5.mp3",
					"ambience/weather/blusterygust6.mp3",
					"ambience/weather/blusterygust7.mp3",
					"ambience/weather/blusterygust8.mp3",
					"ambience/weather/blusterygust9.mp3",
				},
				fogStart = 128,
				fogEnd = 512,
				fogStartNight = 128,
				fogEndNight = 512,
				maxDuration = 600,
				precipitation = "sw_snow",
				rarity = 5
			},
			["fog"] = {
				fogStart = 128,
				fogEnd = 1024,
				fogStartNight = 128,
				fogEndNight = 666,
				rarity = 2
			},
			["normal"] = {
				default = true,
				minDuration = 1800,
				maxDuration = 2400,
			},
			["snow"] = {
				fogStart = 128,
				fogEnd = 2048,
				fogStartNight = 128,
				fogEndNight = 1024,
				precipitation = "sw_snow",
				rarity = 2
			},
		};
	else
		cwWeather.weatherTypes = {
			["acidrain"] = {
				loopingAmbience = "ambient/ambience/rainscapes/crucial_waterrain_light_loop.wav",
				fogColors = {r = 60, g = 47, b = 0},
				fogColorsNight = {r = 20, g = 16, b = 0},
				fogStart = 128,
				fogEnd = 1024,
				fogStartNight = 128,
				fogEndNight = 1024,
				maxDuration = 360,
				skyFix = {r = 25, g = 20, b = 1},
				skyFixNight = {r = 12, g = 10, b = 0},
				precipitation = "sw_acidrain",
				rarity = 6,
				leadupCallback = function()
					local playersInWeatherZones = {};
					
					for _, v in _player.Iterator() do
						if v:Alive() and v:HasInitialized() then
							local lastZone = v:GetCharacterData("LastZone") or "wasteland";
							local zoneTable = zones:FindByID(lastZone);
							
							if zoneTable.hasWeather then
								table.insert(playersInWeatherZones, v);
							end
						end
					end
					
					Clockwork.chatBox:Add(playersInWeatherZones, nil, "event", "An acrid smell slowly begins to permeate the Wasteland, foreshadowing the imminent arrival of acid rain.");
				end,
				leadupTime = 60,
			},
			["ash"] = {
				fogColors = {r = 40, g = 30, b = 17},
				fogColorsNight = {r = 20, g = 15, b = 7},
				fogStart = 256,
				fogEnd = 1300,
				fogStartNight = 256,
				fogEndNight = 950,
				skyFix = {r = 18, g = 15, b = 9},
				skyFixNight = {r = 12, g = 10, b = 6},
				precipitation = "sw_ash",
				rarity = 3,
			},
			["bloodstorm"] = {
				loopingAmbience = "ambient/ambience/rainscapes/crucial_waterrain_light_loop.wav",
				fogColors = {r = 39, g = 2, b = 2},
				fogColorsNight = {r = 20, g = 1, b = 1},
				fogStart = 128,
				fogEnd = 1024,
				fogStartNight = 128,
				fogEndNight = 1024,
				maxDuration = 900,
				minDuration = 600,
				precipitation = "sw_rain",
				skyFix = {r = 18, g = 2, b = 2},
				skyFixNight = {r = 11, g = 1, b = 1},
				rarity = 10,
				leadupCallback = function()
					local playersInWeatherZones = {};
					
					for _, v in _player.Iterator() do
						if v:Alive() and v:HasInitialized() then
							local lastZone = v:GetCharacterData("LastZone") or "wasteland";
							local zoneTable = zones:FindByID(lastZone);
							
							if zoneTable.hasWeather then
								table.insert(playersInWeatherZones, v);
							end
						end
					end
				
					netstream.Start(playersInWeatherZones, "EmitSound", {name = "begotten2/doom_moan.wav", pitch = 90, level = 80});
					Clockwork.chatBox:Add(playersInWeatherZones, nil, "event", "The distant howls of Begotten thralls can be heard throughout the land. Something evil is coming.");
				end,
				leadupTime = 60,
			},
			["fog"] = {
				fogStart = 64,
				fogEnd = 800,
				fogStartNight = 64,
				fogEndNight = 800,
				rarity = 2,
			},
			["normal"] = {
				default = true,
				minDuration = 1800,
				maxDuration = 2400,
			},
			["thunderstorm"] = {
				ambience = {
					"ambient/ambience/rainscapes/thunder_close01.wav",
					"ambient/ambience/rainscapes/thunder_close02.wav",
					"ambient/ambience/rainscapes/thunder_close03.wav",
					"ambient/ambience/rainscapes/thunder_close04.wav",
					"ambient/ambience/rainscapes/thunder_distant01.wav",
					"ambient/ambience/rainscapes/thunder_distant02.wav",
					"ambient/ambience/rainscapes/thunder_distant03.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_01.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_02.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_03.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_04.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_05.wav",
					"ambient/ambience/rainscapes/rain/stereo_gust_06.wav",
				},
				loopingAmbience = "ambient/ambience/rainscapes/crucial_waterrain_med_loop.wav",
				fogColors = {r = 24, g = 21, b = 18},
				fogColorsNight = {r = 24, g = 21, b = 18},
				fogStart = 128,
				fogEnd = 1024,
				fogStartNight = 128,
				fogEndNight = 1024,
				maxDuration = 1200,
				skyFix = {r = 13, g = 12, b = 10},
				skyFixNight = {r = 13, g = 12, b = 10},
				precipitation = "sw_rain",
				rarity = 6,
				leadupCallback = function()
					timer.Create("ThunderstormBuildupTimer", 5, 11, function()
						local playersInWeatherZones = {};
						
						for _, v in _player.Iterator() do
							if v:Alive() and v:HasInitialized() then
								local lastZone = v:GetCharacterData("LastZone") or "wasteland";
								local zoneTable = zones:FindByID(lastZone);
								
								if zoneTable.hasWeather then
									table.insert(playersInWeatherZones, v);
								end
							end
						end
						
						netstream.Start(playersInWeatherZones, "EmitSound", {name = "ambient/ambience/rainscapes/thunder_distant0"..math.random(1, 3)..".wav", pitch = math.random(95, 105), level = 80});
					end);
				end,
				leadupTime = 60,
			},
		};
	end
	
	function cwWeather:IsOutside(pos)
		local trace = {}
		trace.start = pos
		trace.endpos = trace.start + Vector(0, 0, 32768)
		trace.mask = MASK_SOLID
		trace.collisiongroup = COLLISION_GROUP_WEAPON
		local tr = util.TraceLine(trace)

		if CLIENT then
			self.HeightMin = (tr.HitPos - trace.start):Length();
		end

		if tr.HitSky or tr.HitNoDraw then 
			return true 
		end

		if tr.StartSolid or tr.HitNonWorld then 
			return false 
		end

		return false
	end
		
	local COMMAND = Clockwork.command:New("SetWeather");
		COMMAND.tip = "Set the weather. Valid weathers: "..table.concat(table.GetKeys(cwWeather.weatherTypes), ", ")..". \"Force\" argument skips the transitionary period.";
		COMMAND.text = "<string Cycle> [bool Force]";
		COMMAND.access = "a";
		COMMAND.arguments = 1;
		COMMAND.optionalArguments = 1;
		COMMAND.types = {"Weather"}

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			local weather = arguments[1];
			
			if table.HasValue(table.GetKeys(cwWeather.weatherTypes), weather) then
				if cwWeather.weather ~= weather then
					cwWeather:SetWeather(weather, tobool(arguments[2] or false));
					
					Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has set the weather to "..weather.."!");
				else
					Schema:EasyText(player, "darkgrey", "["..self.name.."] ".."This is already the weather!");
				end
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] ".."This is not a valid weather type! The valid weather types are "..table.concat(table.GetKeys(cwWeather.weatherTypes), ", ")..".");
			end;
		end;
	COMMAND:Register();
	
	local COMMAND = Clockwork.command:New("ChangeWeatherLength");
		COMMAND.tip = "Append or subtract from an active weather's length.";
		COMMAND.text = "<number Seconds>";
		COMMAND.access = "a";
		COMMAND.arguments = 1;

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			local seconds = tonumber(arguments[1] or 0);
			
			if seconds then
				cwWeather.nextWeatherTime = cwWeather.nextWeatherTime + seconds;
				
				Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has extended the "..cwWeather.weather.." by "..tostring(cwWeather.nextWeatherTime - CurTime()).." seconds!");
			else
				Schema:EasyText(player, "darkgrey", "This is not a valid amount!");
			end
		end;
	COMMAND:Register();

	local COMMAND = Clockwork.command:New("GetWeather");
		COMMAND.tip = "Get the active weather.";
		COMMAND.access = "a";
	
		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] ".."The weather is: "..cwWeather.weather.." with "..tostring(cwWeather.nextWeatherTime - CurTime()).." seconds left!");
		end;
	COMMAND:Register();
end
