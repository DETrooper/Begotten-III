--[[
	Begotten III: Jesus Wept
	Anomalous Events
	By: DETrooper
--]]

local radioMoonSounds = {
	{track = "radio/radio_moon1.wav", length = 12},
};

local radioScareSounds = {
	{track = "distortedradio1.mp3", length = 222},
};

function cwAnomalous:Think()
	local curTime = CurTime();
	--local cwDayNight = cwDayNight;
	
	-- Disabled for now until new sounds are added.
	--[[if cwDayNight.currentCycle == "night" then
		-- Don't play moon hallucinations near the end of the night.
		if (curTime < cwDayNight.nextCycleTime - 600) then
			if not self.nextMoonSpeak then
				self.nextMoonSpeak = curTime + math.random(300, 600);
			end
			
			if (self.nextMoonSpeak < curTime) then
				local radios = ents.FindByClass("cw_radio");
				
				for k, v in ipairs(radios) do
					if (!v:IsOff() and !v:IsCrazy()) then
						self:MakeMoonSpeak(v);
					end
				end
				
				self.nextMoonSpeak = curTime + math.random(120, 300);
			end
		end
	end]]--
	
	if not self.nextRadioScare then
		-- Random time between 1.5 hours to 4 hours for a radio scare to occur.
		self.nextRadioScare = curTime + math.random(5400, 14400);
	end
	
	if (self.nextRadioScare < curTime) then
		if (game.GetMap() != "rp_begotten3") then
			return;
		end;
		
		if not self.scareRadio then
			local radios = ents.FindByClass("cw_radio");
			local valid_radios = {};
			
			for k, v in ipairs(radios) do
				if (!v:IsOff()) then
					table.insert(valid_radios, v);
				end
			end
			
			if #valid_radios > 0 then
				self:MakeRadioCrazy(valid_radios[math.random(1, #valid_radios)]);
			else
				-- Wait another 5-10 minutes before trying again.
				self.nextRadioScare = curTime + math.random(300, 600);
			end
		else
			self.nextRadioScare = curTime + math.random(5400, 14400);
			self.scareRadio:SetCrazy(false);
			self.scareRadio = nil;
		end
	end;
end;

function cwAnomalous:CycleChanged(cycle)
	if cycle == "night" then
		self.nextMoonSpeak = CurTime() + math.random(120, 300);
	end
end

function cwAnomalous:MakeMoonSpeak(radio)
	if IsValid(radio) then
		local moonSound = radioMoonSounds[math.random(1, #radioMoonSounds)];
		
		if math.random(1, 2) == 1 then
			radio:EmitSound("ambient/levels/outland/ol01_teleconferencebegin.wav");
		else
			radio:EmitSound("ambient/levels/citadel/datatransrandom01.wav");
		end
		
		timer.Simple(6, function()
			if IsValid(radio) then
				radio:EmitSound(moonSound.track);
				
				timer.Simple(moonSound.length - 1, function()
					if IsValid(radio) then
						radio:EmitSound("ambient/levels/outland/ol01_teleconferenceend.wav");
					end
				end);
			end
		end);
	end
end

function cwAnomalous:MakeRadioCrazy(radio)
	if IsValid(radio) then
		local scareSound = radioScareSounds[math.random(1, #radioScareSounds)];
		
		self.scareRadio = radio;
		radio:SetCrazy(true);
		
		if math.random(1, 2) == 1 then
			radio:EmitSound("ambient/levels/outland/ol01_teleconferencebegin.wav");
		else
			radio:EmitSound("ambient/levels/citadel/datatransrandom01.wav");
		end
		
		timer.Simple(6, function()
			if IsValid(radio) then
				local filter = RecipientFilter();
				
				filter:AddAllPlayers()
			
				radio:EmitSound(scareSound.track, 75, 100, 1, CHAN_AUTO, 0, 0, filter);
				
				timer.Simple(scareSound.length - 1, function()
					if IsValid(radio) then
						radio:EmitSound("ambient/levels/outland/ol01_teleconferenceend.wav");
						radio:SetCrazy(false);
					end
				end);
			end
		end);
		
		self.nextRadioScare = CurTime() + scareSound.length + 10 or 300;
	end
end