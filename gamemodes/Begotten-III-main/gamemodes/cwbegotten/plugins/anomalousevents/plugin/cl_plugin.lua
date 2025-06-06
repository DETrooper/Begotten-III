Clockwork.Client.CosmicRuptureRender = false;

cwAnomalous.tvNoises = {
	{track = "distortedradio1.mp3", length = 222},
};

local tvLocations = {
	-- Tower of Power
	{
		["tvmonitor"] = {model = "models/props_c17/tv_monitor01.mdl", pos = Vector(1689.28125, -5235.875, -1326.96875), angles = Angle(0, -135, 0)};
		["tvscreen"] = {model = "models/props_c17/tv_monitor01_screen.mdl", pos = Vector(1689.28125, -5235.875, -1326.96875), angles = Angle(0, -135, 0)};
		["tvtable"] = {model = "models/props_c17/FurnitureTable003a.mdl", pos = Vector(1688.78125, -5236.53125, -1346.03125), angles = Angle(0, -135, 0)};
	},
	-- Store Backroom
	{
		["tvmonitor"] = {model = "models/props_c17/tv_monitor01.mdl", pos = Vector(-3591.5, -2517.6875, -1853.09375), angles = Angle(0, 45, 0)};
		["tvscreen"] = {model = "models/props_c17/tv_monitor01_screen.mdl", pos = Vector(-3591.5, -2517.6875, -1853.09375), angles = Angle(0, 45, 0)};
		["tvtable"] = {model = "models/props_c17/FurnitureTable003a.mdl", pos = Vector(-3592.34375, -2519, -1872.125), angles = Angle(0, 45, 0)};
	},
	-- Destroyed Building Sideroom
	{
		["tvmonitor"] = {model = "models/props_c17/tv_monitor01.mdl", pos = Vector(1547.0625, -3002.40625, -1863.03125), angles = Angle(0, 135, 0)};
		["tvscreen"] = {model = "models/props_c17/tv_monitor01_screen.mdl", pos = Vector(1547.0625, -3002.40625, -1863.03125), angles = Angle(0, 135, 0)};
		["tvtable"] = {model = "models/props_c17/FurnitureTable003a.mdl", pos = Vector(1548.65625, -3004.1875, -1882.09375), angles = Angle(0, 135, 0)};
	},
	-- Mines Building Sideroom
	{
		["tvmonitor"] = {model = "models/props_c17/tv_monitor01.mdl", pos = Vector(-3374.71875, 1307.59375, -1791.96875), angles = Angle(0, 90, 0)};
		["tvscreen"] = {model = "models/props_c17/tv_monitor01_screen.mdl", pos = Vector(-3374.71875, 1307.59375, -1791.96875), angles = Angle(0, 90, 0)};
		["tvtable"] = {model = "models/props_c17/FurnitureTable003a.mdl", pos = Vector(-3374.1875, 1306.5, -1811.0625), angles = Angle(0, 90, 0)};
	},
};

function cwAnomalous:CosmicRupture()
	local position = Clockwork.Client:GetPos();
	local curTime = CurTime();
	local thunderSounds = {
		"ambient/weather/thunderstorm/lightning_strike_1.wav",
		"ambient/weather/thunderstorm/lightning_strike_2.wav",
		"ambient/weather/thunderstorm/lightning_strike_3.wav",
		"ambient/weather/thunderstorm/lightning_strike_4.wav"
	};

	util.ScreenShake(Clockwork.Client:GetPos(), 15, 10, 60, 500)
	
	timer.Simple(math.Rand(1, 3), function()
		local randomThunder = math.random(1, #thunderSounds);
		Clockwork.Client:EmitSound(thunderSounds[randomThunder], 500, math.random(95, 105));
		table.remove(thunderSounds, randomThunder);
	end);
	
	timer.Simple(math.Rand(8, 10), function()
		local randomThunder = math.random(1, #thunderSounds);
		Clockwork.Client:EmitSound(thunderSounds[randomThunder], 500, math.random(95, 105));
		table.remove(thunderSounds, randomThunder);
	end);
	
	timer.Simple(math.Rand(15, 18), function()
		local randomThunder = math.random(1, #thunderSounds);
		Clockwork.Client:EmitSound(thunderSounds[randomThunder], 500, math.random(95, 105));
		table.remove(thunderSounds, randomThunder);
	end);
	
	timer.Simple(math.Rand(24, 26), function()
		Clockwork.Client:EmitSound(thunderSounds[1], 500, math.random(95, 105));
	end);
	
	timer.Simple(20, function()
		Clockwork.Client:EmitSound("cosmicrupture/cosmicrupture.wav", 500, 100);
	end);
	
	timer.Simple(36.75, function()
		Clockwork.Client.CosmicRuptureRender = true;
	end);
	
	timer.Simple(59, function()
		Clockwork.Client.CosmicRuptureRender = false;
		Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 2, 0);
	end);
end;

function cwAnomalous:StartNearestTVHallucination()
	for i = 1, #tvLocations do
		local location = tvLocations[i];
		
		for k, v in pairs(ents.FindInSphere(location.tvmonitor.pos, 2048)) do
			if v == Clockwork.Client then
				self:StartTVHallucination(tvLocations[i]);
				break;
			end
		end
	end
end

function cwAnomalous:StartRandomTVHallucination()
	self:StartTVHallucination(tvLocations[math.random(1, #tvLocations)]);
end

function cwAnomalous:StartTVHallucination(location)
	if not self.tvPlaying then
		local curTime = CurTime();
		
		self.tvLocation = location;

		for k, v in pairs(ents.FindInSphere(location.tvmonitor.pos, 2048)) do				
			if v == Clockwork.Client then
				-- Player is close enough to the hallucination for us to begin it.
				self.tvNoise = self.tvNoises[math.random(1, #self.tvNoises)];
				self.tvPlaying = true;
				self.tvPlayingTimer = curTime + (self.tvNoise.length or 300);

				self.tvMonitor = ClientsideModel(location.tvmonitor.model, RENDERGROUP_OPAQUE);
				self.tvScreen = ClientsideModel(location.tvscreen.model, RENDERGROUP_OPAQUE);
				self.tvTable = ClientsideModel(location.tvtable.model, RENDERGROUP_OPAQUE);
				
				self.tvMonitor:SetAngles(location.tvmonitor.angles);
				self.tvMonitor:SetPos(location.tvmonitor.pos);
				
				self.tvScreen:SetAngles(location.tvscreen.angles);
				self.tvScreen:SetPos(location.tvscreen.pos);
				self.tvScreen:SetMaterial("effects/fucked_screen");
				sound.Play(self.tvNoise.track, self.tvScreen:GetPos(), 80, 100, 1);
			
				self.tvTable:SetAngles(location.tvtable.angles);
				self.tvTable:SetPos(location.tvtable.pos);
				
				self.tvDynamicLight = DynamicLight(1);
			
				if (self.tvDynamicLight) then
					self.tvDynamicLight.Pos = self.tvScreen:GetPos() + (self.tvMonitor:GetForward() * 10);
					self.tvDynamicLight.r = 100;
					self.tvDynamicLight.g = 100;
					self.tvDynamicLight.b = 100;
					self.tvDynamicLight.Brightness = 0.1;
					self.tvDynamicLight.Size = 100;
					self.tvDynamicLight.DieTime = curTime + (self.tvNoise.length or 300);
					self.tvDynamicLight.Style = 1;
				end;
				
				return;
			end
		end
		
		-- No TV location found.
		self.tvPlayingTimer = curTime + math.random(900, 1800);
		self.tvLocation = nil;
	end
end

netstream.Hook("CosmicRupture", function(data)
	cwAnomalous:CosmicRupture();
end);

netstream.Hook("StartNearestTVHallucination", function(data)
	cwAnomalous:StartNearestTVHallucination();
end);