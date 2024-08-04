--[[
	Begotten III: Jesus Wept
--]]

cwDayNight.launchExtraLength = 900; -- Extra 15 minutes (in seconds) of daytime after server launches.

cwDayNight.cycles = {
	["day"] = {
		length = 5400, -- 1.5 hours in seconds.
		nextCycle = "daytonight",
		fadeMusic = false -- Fade music on transitioning to this phase?
	},
	["daytonight"] = {
		length = 300, -- 5 minutes in seconds.
		nextCycle = "night",
		eventText = "The sky begins to darken and bells ring aloud throughout the wasteland, signalling the immediate need for shelter. Night is coming.",
		sound = {farSound = "cosmicrupture/bellsdistant.wav", closeSound = "cosmicrupture/bellsclose.wav"},
		fadeMusic = true
	},
	["night"] = {
		length = 1800, -- 30 minutes in seconds.
		nextCycle = "nighttoday",
		eventText = "The Blood Moon has risen to claim those who still wander the wasteland.",
		fadeMusic = true
	},
	["nighttoday"] = {
		length = 300, -- 5 minutes in seconds.
		nextCycle = "day",
		eventText = "The Blood Moon finally subsides and the sky begins to lighten. You have survived another night.",
		fadeMusic = true
	},
};

if game.GetMap() == "rp_scraptown" then
	local tab = cwDayNight.cycles["daytonight"];
	
	tab.eventText = "The sky begins to darken and the klaxons ring aloud throughout the wasteland, signalling the immediate need for shelter. Night is coming.";
	tab.sound = "warhorns/scrapperklaxon.mp3";
end

function cwDayNight:ChangeCycle(cycle, notify)
	local cycleTable = self.cycles[cycle];
	
	self.currentCycle = cycle;
	self.nextCycleTime = CurTime() + cycleTable.length;
	self:SetupBloodMoon();
	
	local close_players = {};
	local far_players = {};

	local playerCount = _player.GetCount();
	local players = _player.GetAll();

	for i = 1, playerCount do
		local player, k = players[i], i;

		if IsValid(player) and player:HasInitialized() then
			local lastZone = player:GetCharacterData("LastZone");
			
			Clockwork.datastream:Start(player, "SetCurrentCycle", self.currentCycle);
			
			if cycleTable.fadeMusic then
				if lastZone == "wasteland" or (lastZone == "tower" and cycle == "daytonight") then
					Clockwork.datastream:Start(player, "FadeAmbientMusic");
				end
			end
			
			if lastZone == "wasteland" or lastZone == "tower" then
				Clockwork.datastream:Start(player, "RefreshCurrentZone");
				
				if notify then
					if cycleTable.eventText then
						Clockwork.chatBox:Add(player, nil, "event", cycleTable.eventText);
					end
					
					if lastZone == "wasteland" then
						table.insert(far_players, player);
					else
						table.insert(close_players, player);
					end
				end
			elseif player:GetSubfaction() == "Rekh-khet-sa" then
				if cycle == "night" then
					Clockwork.chatBox:Add(player, nil, "event", "You feel the Blood Moon rising. It is time to prowl.");
				elseif cycle == "nighttoday" then
					Clockwork.chatBox:Add(player, nil, "event", "The Blood Moon is fading, it is no longer safe for you to stalk the Wastes.");
				end
			end
		end
	end
	
	if notify then
		if cycleTable.sound then
			if istable(cycleTable.sound) then
				Clockwork.datastream:Start(close_players, "EmitSound", {name = cycleTable.sound.closeSound, pitch = 90, level = 60});
				Clockwork.datastream:Start(far_players, "EmitSound", {name = cycleTable.sound.farSound, pitch = 100, level = 75});
			else
				Clockwork.datastream:Start(close_players, "EmitSound", {name = cycleTable.sound, pitch = 90, level = 60});
				Clockwork.datastream:Start(far_players, "EmitSound", {name = cycleTable.sound, pitch = 100, level = 75});
			end
		end
	end
	
	if cycle == "nighttoday" or cycle == "night" then
		if !cwWeather or cwWeather.weather ~= "bloodstorm" then
			for i, index in ipairs(Schema.spawnedNPCs["thrall"]) do
				local entity = ents.GetByIndex(Schema.spawnedNPCs[i]);
				
				if IsValid(entity) and (entity:IsNPC() or entity:IsNextBot()) then
					entity:Remove();
				end
			end
			
			Schema.spawnedNPCs["thrall"] = {};
		end
	end
	
	hook.Run("DayNightCycleChanged", cycle);
end

function cwDayNight:SetupBloodMoon()
	local env_skypaint_list = ents.FindByClass("env_skypaint");
	local env_sun_list = ents.FindByClass("env_sun");
	
	if (#env_sun_list > 0) then
		local env_sun = env_sun_list[1];
		
		if IsValid(env_sun) then
			if (#env_skypaint_list > 0) then
				local env_skypaint = env_skypaint_list[1];
		
				if IsValid(env_skypaint) then
					if self.currentCycle == "night" then
						env_skypaint:SetTopColor(Vector(0.016, 0, 0));
						env_skypaint:SetBottomColor(Vector(0.016, 0, 0));
						env_sun:SetKeyValue("sun_dir", tostring(Angle(0, 0, 1)));
					else
						env_skypaint:SetTopColor(Vector(0.12, 0.029, 0.00));
						env_skypaint:SetBottomColor(Vector(0.12, 0.029, 0.00));
						env_sun:SetKeyValue("sun_dir", tostring(Angle(0, 0, -1)));
					end

					env_skypaint:SetFadeBias(1);
					env_skypaint:SetSunNormal(env_sun:GetInternalVariable("m_vDirection"));
					env_skypaint:SetSunColor(Vector(0.5, 0.1, 0.05));
					env_skypaint:SetSunSize(0.2);
				end
			end
		end
	end
	
	if not self.towerShutters or not self.towerShuttersButton then
		local entities = ents.GetAll();
			
		for k, v in pairs (entities) do 
			if v:GetName() == "tower_skylight_shutters" then
				self.towerShutters = v;
			elseif v:GetName() == "shutters" then
				self.towerShuttersButton = v;
			end
		end
	end
	
	if self.towerShutters and self.towerShuttersButton then
		if self.currentCycle == "nighttoday" then
			if self.towerShutters:GetSaveTable().m_toggle_state == 1 then
				-- Shutters are closed.

				self.towerShuttersButton:Fire("Press", nil, 3);
			end
		elseif self.currentCycle == "daytonight" or self.currentCycle == "night" then	
			if self.towerShutters:GetSaveTable().m_toggle_state == 0 then
				-- Shutters are open.

				self.towerShuttersButton:Fire("Press", nil, 3);
			end
		end
	end
end

function cwDayNight:GetCurrentCycle()
	return self.currentCycle;
end

function cwDayNight:GetCycleTimeLeft()
	if self.nextCycleTime then
		return self.nextCycleTime - CurTime();
	end
	
	return 0;
end

function cwDayNight:ModifyCycleTimeLeft(amount)
	if self.nextCycleTime then
		self.nextCycleTime = self.nextCycleTime + amount;
	else
		self.nextCycleTime = amount;
	end
end