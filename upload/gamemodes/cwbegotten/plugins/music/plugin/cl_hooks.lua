-- Dynamic Music by Cash Wednesday and DETrooper

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

CW_CONVAR_AMBIENTMUSIC = Clockwork.kernel:CreateClientConVar("cwAmbientMusic", 1, true, true)
CW_CONVAR_AMBIENTMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwAmbientMusicVolume", 100, true, true)
CW_CONVAR_BATTLEMUSIC = Clockwork.kernel:CreateClientConVar("cwBattleMusic", 1, true, true)
CW_CONVAR_BATTLEMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwBattleMusicVolume", 100, true, true)
CW_CONVAR_MENUMUSIC = Clockwork.kernel:CreateClientConVar("cwMenuMusic", 1, true, true)
CW_CONVAR_MENUMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwMenuMusicVolume", 100, true, true)

cwMusic.AmbientMusicTable = {
	["tower"] = { -- ambient music for the tower of light
		{track = "begotten3soundtrack/ambiencetower/acclb-preparethestageofnight.mp3", length = 265},
		{track = "begotten3soundtrack/ambiencetower/ackh-intheblackstone.mp3", length = 264},
		{track = "begotten3soundtrack/ambiencetower/ac-thedarkmother.mp3", length = 281},
		{track = "begotten3soundtrack/ambiencetower/ac-them.mp3", length = 306},
		{track = "begotten3soundtrack/ambiencetower/ac-thevoid.mp3", length = 276, volume = 0.5},
		{track = "begotten3soundtrack/ambiencetower/ct-wecannotescapethepast.mp3", length = 276, volume = 0.5},
		{track = "begotten3soundtrack/ambiencetower/clb-disembodied.mp3", length = 281},
		{track = "begotten3soundtrack/ambiencetower/clb-eachnight.mp3", length = 411},
		{track = "begotten3soundtrack/ambiencetower/mo-apostolikon.mp3", length = 585},
		{track = "begotten3soundtrack/ambiencetower/mo-chaliceofeternity.mp3", length = 574},
		{track = "begotten3soundtrack/ambiencetower/mo-illuminatio.mp3", length = 471},
		{track = "begotten3soundtrack/ambiencetower/mo-logos.mp3", length = 354},
		{track = "begotten3soundtrack/ambiencetower/mo-transfiguration-edited.mp3", length = 261},
	},

	["wasteland"] = { -- ambient music for the wasteland
		{track = "begotten3soundtrack/ambiencewasteland/acclb-thegreatorderofthings.mp3", length = 289},
		{track = "begotten3soundtrack/ambiencewasteland/co9-fragmentsofmyself.mp3", length = 458},
		{track = "begotten3soundtrack/ambiencewasteland/co9-inolongerhearyou.mp3", length = 381},
		{track = "begotten3soundtrack/ambiencewasteland/clb-antumbra.mp3", length = 425},
		{track = "begotten3soundtrack/ambiencewasteland/clb-wherevertheheartgoes.mp3", length = 414},
		{track = "begotten3soundtrack/ambiencewasteland/mo-consecration.mp3", length = 428},
		{track = "begotten3soundtrack/ambiencewasteland/mo-ecclesiauniversalis.mp3", length = 607},
		{track = "begotten3soundtrack/ambiencewasteland/mo-heosphoros.mp3", length = 493},
		{track = "begotten3soundtrack/ambiencewasteland/mo-hierosgamos.mp3", length = 543},
		{track = "begotten3soundtrack/ambiencewasteland/mo-mysteriisdesanguine.mp3", length = 506},
		{track = "begotten3soundtrack/ambiencewasteland/mo-sacrumnoctis.mp3", length = 556, volume = 0.75},
		{track = "begotten3soundtrack/ambiencewasteland/mo-thylight.mp3", length = 570},
		{track = "begotten3soundtrack/ambiencewasteland/ss-transference.mp3", length = 332},
	},

	["wastelandnight"] = { -- ambient music for the wasteland (night)
		{track = "begotten3soundtrack/ambiencenight/dw-untitled3.mp3", length = 128, volume = 0.75},
		{track = "begotten3soundtrack/ambiencenight/dw-dream.mp3", length = 317, volume = 0.75},
		{track = "begotten3soundtrack/ambiencenight/ss-thecastleanomaly.mp3", length = 612},
		{track = "begotten3soundtrack/ambiencenight/ss-aristarchusplateau.mp3", length = 546},
		{track = "begotten3soundtrack/ambiencenight/as-throughthedesert.mp3", length = 391},
		{track = "begotten3soundtrack/ambiencenight/ns-blackmoonpt2.mp3", length = 253},
		{track = "begotten3soundtrack/ambiencenight/ns-blackmoonpt1.mp3", length = 369},
		{track = "begotten3soundtrack/ambiencenight/pa-frozencaveofwhispers.mp3", length = 696, volume = 0.75},
	},
	
	["goericforest"] = { -- ambient music for the goeric forest
		{track = "begotten3soundtrack/ambiencegoeric/hb_surtrsart.mp3", length = 141},
		{track = "begotten3soundtrack/ambiencegoeric/hb-surtrbacktrack.mp3", length = 61},
		{track = "begotten3soundtrack/ambiencegoeric/hb-surtrintro.mp3", length = 81},
		{track = "begotten3soundtrack/ambiencegoeric/hb-valravnbacktracking.mp3", length = 266},
		{track = "begotten3soundtrack/ambiencegoeric/hb-volcano.mp3", length = 444},
		{track = "begotten3soundtrack/ambiencegoeric/nu-torngat.mp3", length = 500, volume = 0.75},
		{track = "begotten3soundtrack/ambiencegoeric/pw-permafrost.mp3", length = 250},
		{track = "begotten3soundtrack/ambiencegoeric/twa-barb503423011.mp3", length = 129},
		{track = "begotten3soundtrack/ambiencegoeric/twa-menofthesea.mp3", length = 114, volume = 0.75},
		{track = "begotten3soundtrack/ambiencegoeric/twa-wintersbard.mp3", length = 116, volume = 0.75},
	},
	
	["insanity"] = { -- ambient music for insane players
		{track = "begotten3soundtrack/insanity/scorntrailertheme.mp3", length = 97},
	},
}
cwMusic.BattleMusicTable = {
	["combat"] = { -- combat music for regular players/wanderers
		{track = "begotten3soundtrack/combat/bt-afterlife.mp3", length = 265},
		{track = "begotten3soundtrack/combat/bt-allthatremains.mp3", length = 211},
		{track = "begotten3soundtrack/combat/bt-attackintheaftermath.mp3", length = 141},
		{track = "begotten3soundtrack/combat/bt-blindtodefeat.mp3", length = 128},
		{track = "begotten3soundtrack/combat/bt-challengeforpower.mp3", length = 219},
		{track = "begotten3soundtrack/combat/bt-concessionofpain.mp3", length = 178},
		{track = "begotten3soundtrack/combat/bt-crownoflife.mp3", length = 250},
		{track = "begotten3soundtrack/combat/bt-denialofdestiny.mp3", length = 151},
		{track = "begotten3soundtrack/combat/bt-drownedintorment.mp3", length = 125},
		{track = "begotten3soundtrack/combat/bt-eternalwar.mp3", length = 128},
		{track = "begotten3soundtrack/combat/bt-icon.mp3", length = 165},
		{track = "begotten3soundtrack/combat/bt-lostsoulsdomain.mp3", length = 225},
		{track = "begotten3soundtrack/combat/bt-nuclearannihilation.mp3", length = 172},
		{track = "begotten3soundtrack/combat/bt-plaguebearer.mp3", length = 175},
		{track = "begotten3soundtrack/combat/bt-prophetofhatred.mp3", length = 209},
		{track = "begotten3soundtrack/combat/bt-psychologicalwarfare.mp3", length = 117},
		{track = "begotten3soundtrack/combat/bt-warmaster.mp3", length = 190},
		{track = "begotten3soundtrack/combat/bt-whatdwellswithin.mp3", length = 174},
	},
	
	["combat_goeric"] = { -- combat music for gores
		{track = "begotten3soundtrack/combatgoeric/hb-bridgecombatthird.mp3", length = 136},
		{track = "begotten3soundtrack/combatgoeric/hb-combatvalravnbalcony.mp3", length = 86},
		{track = "begotten3soundtrack/combatgoeric/hb-seaofcorpsescombat.mp3", length = 165},
		{track = "begotten3soundtrack/combatgoeric/hb-surtrfight2.mp3", length = 194},
		{track = "begotten3soundtrack/combatgoeric/hb-valravnbattle1.mp3", length = 93},
		{track = "begotten3soundtrack/combatgoeric/hb-volcanofightfinal.mp3", length = 182},
	},
}

function cwMusic:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "cwAmbientMusic" and newValue) then
		if newValue == "0" then
			self:StopAmbientMusic();
		else
			cwMusic.AmbientMusicChangeCooldown = CurTime() + 5;
		end
	elseif (name == "cwAmbientMusicVolume" and newValue) then
		if newValue == "0" then
			CW_CONVAR_AMBIENTMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			CW_CONVAR_AMBIENTMUSIC:SetInt(1);
		elseif self.AmbientMusic then
			self.AmbientMusic:ChangeVolume(math.max(0, (tonumber(newValue) / 100) * (self.TrackVolume or 1)));
		end
	elseif (name == "cwBattleMusic" and newValue) then
		if newValue == "0" then
			self:StopBattleMusic();
		end
	elseif (name == "cwBattleMusicVolume" and newValue) then
		if newValue == "0" then
			CW_CONVAR_BATTLEMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			CW_CONVAR_BATTLEMUSIC:SetInt(1);
		elseif self.BattleMusic then
			self.BattleMusic:ChangeVolume(math.max(0, (tonumber(newValue) / 100) * (self.TrackVolume or 1)));
		end
	elseif (name == "cwMenuMusic" and newValue) then
		if newValue == "0" then
			if Clockwork.MusicSound then
				Clockwork.MusicSound:Stop();
				cwMusic.TrackVolume = nil
			end
		end
	elseif (name == "cwMenuMusicVolume" and newValue) then
		if newValue == "0" then
			CW_CONVAR_MENUMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			CW_CONVAR_MENUMUSIC:SetInt(1);
		elseif Clockwork.MusicSound then
			Clockwork.MusicSound:ChangeVolume(math.max(0, (tonumber(newValue) / 100) * (self.TrackVolume or 1)));
		end
	end
end

function cwMusic:PlayerAttacks(player)
	if player:GetPos():DistToSqr(Clockwork.Client:GetPos()) >= (2048 * 2048) then
		if cwMusic.NextBattleMusic then
			if (cwMusic.NextBattleMusic > curTime) then
				self:AddBattleMusicTime(20);
			end
		end
	end
end

function cwMusic:PlayerChangedZones(newZone, previousZone)
	if newZone == "gore_tree" or newZone == "gore" or newZone == "gore_hallway" then
		if previousZone != "gore_tree" and previousZone != "gore" and previousZone != "gore_hallway" then
			self:FadeOutAmbientMusic(4, 1);
		end
	elseif game.GetMap() == "rp_scraptown" then
		if (newZone == "tower" and previousZone == "wasteland") or (previousZone == "tower" and newZone == "wasteland") then
			-- do nothing
		else
			self:FadeOutAmbientMusic(4, 1);
		end
	else
		self:FadeOutAmbientMusic(4, 1);
	end
end

function cwMusic:Tick()
	if (!map) then
		return;
	end;
	
	local curTime = CurTime()

	if (!cwMusic.AmbientMusicChangeCooldown or cwMusic.AmbientMusicChangeCooldown < curTime) then
		cwMusic.AmbientMusicChangeCooldown = curTime + 5;

		if (Clockwork.Client.HasInitialized == nil) then
			return;
		end
		
		if Clockwork.Client:HasInitialized() and Clockwork.Client:Alive() then
			if (!Clockwork.menu:GetOpen()) and (!Clockwork.kernel:IsChoosingCharacter()) then
				if self:CanPlayAmbientMusic() then
					self:StartAmbientMusic();
				else
					if (!cwMusic.MusicEndTime or cwMusic.MusicEndTime < curTime) then
						self:StopAmbientMusic()
					end
				end
			end
		end
	end
		
	if (!cwMusic.MusicCheck or cwMusic.MusicCheck < curTime) then
		cwMusic.MusicCheck = curTime + 1;

		if (Clockwork.kernel:IsChoosingCharacter()) then
			self:FadeOutAmbientMusic(0.5, 1);
			self:FadeOutBattleMusic(0.5, 1);
		elseif (!Clockwork.Client:Alive()) then
			self:FadeOutAmbientMusic(4, 1);
			self:FadeOutBattleMusic(4, 1);
		end
	end

	if (cwMusic.NextBattleMusic) then
		if (cwMusic.NextBattleMusic < curTime) then
			if (cwMusic.BattleMusic and cwMusic.BattleMusic:IsPlaying()) then
				if (!cwMusic.BattleMusicFadingOut) then
					cwMusic.BattleMusicFadingOut = true
					cwMusic.BattleMusic:FadeOut(8)
					cwMusic.NextBattleMusic = nil
					cwMusic.MaxBattleLength = nil
					cwMusic.MusicStartTime = nil
					cwMusic.BattleMusicChangeCooldown = curTime + 16

					timer.Simple(8, function()
						cwMusic.BattleMusic = nil
						cwMusic.BattleMusicFadingOut = nil
					end)
				end
			end
		end
	end
end

function cwMusic:StartAmbientMusic()
	if (!self:CanPlayAmbientMusic()) then
		return
	end
	
	local curTime = CurTime()
	
	if (!cwMusic.NextAmbientCall or curTime > cwMusic.NextAmbientCall) then
		cwMusic.NextAmbientCall = curTime + 0.5
	else
		return
	end

	if (!cwMusic.AmbientMusic) then
		local trackType = "wasteland"
		local zone = Clockwork.Client:GetZone();
		
		if zone == "wasteland" and cwMusic.currentCycle == "night" then
			trackType = "wastelandnight";
		elseif zone == "tower" and game.GetMap() ~= "rp_scraptown" then
			trackType = "tower";
		elseif zone == "gore" or zone == "gore_hallway" or zone == "gore_tree" then
			trackType = "goericforest";
		end
		
		--if (cwMusic:Sanity() < 20) then
			--trackType = "insanity"
		--end
		
		local musicTable = self:GetRandomAmbientMusic(trackType)
		local trackName = musicTable.track
		local trackLength = musicTable.length
		
		cwMusic.MusicStartTime = curTime
		cwMusic.MusicEndTime = curTime + trackLength + 10;
		cwMusic.MaxAmbientLength = trackLength
		cwMusic.AmbientMusic = CreateSound(Clockwork.Client, trackName)
		
		if (!cwMusic.RecentAmbientTracks) then
			cwMusic.RecentAmbientTracks = {}
		end
		
		table.insert(cwMusic.RecentAmbientTracks, trackName);
		
		if #cwMusic.RecentAmbientTracks > 4 then
			for i = 2, #cwMusic.RecentAmbientTracks do
				cwMusic.RecentAmbientTracks[i - 1] = cwMusic.RecentAmbientTracks[i];
				
				if i == #cwMusic.RecentAmbientTracks then
					cwMusic.RecentAmbientTracks[i] = nil;
				end
			end
		end
		
		if musicTable.volume then
			cwMusic.TrackVolume = musicTable.volume;
			cwMusic.AmbientMusic:PlayEx(math.max((CW_CONVAR_AMBIENTMUSICVOLUME:GetInt() or 100) * musicTable.volume, 0) / 100, 100);
		else
			cwMusic.TrackVolume = 1;
			cwMusic.AmbientMusic:PlayEx((CW_CONVAR_AMBIENTMUSICVOLUME:GetInt() or 100) / 100, 100);
		end
	end
end

function cwMusic:GetRandomAmbientMusic(musicType)
	if (self.AmbientMusicTable[musicType]) then
		if cwMusic.RecentAmbientTracks then
			local valid_music_table = {};
			
			for i = 1, #self.AmbientMusicTable[musicType] do
				local musicTable = self.AmbientMusicTable[musicType][i];
				local trackName = musicTable.track;
				
				if not table.HasValue(cwMusic.RecentAmbientTracks, trackName) then
					table.insert(valid_music_table, trackName);
				end
			end
			
			local randomTrackName = valid_music_table[math.random(1, #valid_music_table)];
			
			for i = 1, #self.AmbientMusicTable[musicType] do
				if self.AmbientMusicTable[musicType][i].track == randomTrackName then
					local randomTrack = self.AmbientMusicTable[musicType][i];
					
					return {track = randomTrack.track, length = randomTrack.length, volume = randomTrack.volume or 1};
				end
			end
		else
			local randomTrack = self.AmbientMusicTable[musicType][math.random(1, #self.AmbientMusicTable[musicType])];
			
			return {track = randomTrack.track, length = randomTrack.length, volume = randomTrack.volume or 1};
		end
	end
end

function cwMusic:CanPlayAmbientMusic()
	if (!map) then
		return;
	end;
	
	if not self.enabled then
		return false;
	end
	
	if not Clockwork.Client:Alive() then
		return false;
	end
	
	if Clockwork.Client.LoadingText then
		return false;
	end
	
	if Clockwork.Client.dueling then
		return false;
	end

	--if (Clockwork.Client:IsAdmin()) then
		if (CW_CONVAR_AMBIENTMUSIC and CW_CONVAR_AMBIENTMUSIC:GetInt() != 1) then
			return false
		end
	--end
	
	if (cwMusic.BattleMusic) then
		if (cwMusic.BattleMusic:IsPlaying()) then
			return false
		end
	end
	
	if (cwMusic.AmbientMusic) then
		if (cwMusic.AmbientMusic:IsPlaying()) then -- Music is currently playing, or so it says.
			return false
		end
	end
	
	local zone = Clockwork.Client:GetZone();
		
	if zone == "caves" or zone == "scrapper" or zone == "hell" or zone == "manor" or zone == "toothboy" or zone == "duel" or zone == "theater" or string.find(zone, "sea_") then
		-- No ambient music in these areas.
		return false
	end
	
	return true
end

function cwMusic:FadeOutAmbientMusic(seconds, delay)
	local curTime = CurTime()

	if (!delay) then
		delay = 0;
	end
	
	if (!cwMusic.AmbientMusicFadingOut) then
		cwMusic.AmbientMusicFadingOut = true
	
		timer.Create("AmbientFadeOutTimer", delay, 1, function()
			if cwMusic.AmbientMusic then
				cwMusic.AmbientMusic:FadeOut(seconds)
			end
			
			cwMusic.MaxAmbientLength = nil
			cwMusic.MusicStartTime = nil
			cwMusic.MusicEndTime = nil;
			
			--[[if Clockwork.Client:GetZone() == "manor" then
				cwMusic.AmbientMusicChangeCooldown = curTime + math.random(10, 30);
			else]]--
				cwMusic.AmbientMusicChangeCooldown = curTime + math.random(30, 180); -- 30 second to 3 minute delay before the next ambient track.
			--end
			
			timer.Simple(seconds, function()
				cwMusic.AmbientMusic = nil
				cwMusic.AmbientMusicFadingOut = nil
				cwMusic.TrackVolume = nil
			end)
		end)
	end
end

function cwMusic:StopAmbientMusic()
	local curTime = CurTime()

	if cwMusic.AmbientMusic then
		cwMusic.AmbientMusic:Stop();
	end
	
	cwMusic.MaxAmbientLength = nil
	cwMusic.MusicStartTime = nil
	cwMusic.MusicEndTime = nil;
	cwMusic.AmbientMusicChangeCooldown = curTime + math.random(30, 180); -- 30 second to 3 minute delay before the next ambient track.
	cwMusic.AmbientMusic = nil
	cwMusic.AmbientMusicFadingOut = nil
	cwMusic.TrackVolume = nil
end

function cwMusic:AddBattleMusicTime(timeToAdd)
	if (!cwMusic.NextBattleMusic) then
		return
	end
	
	local curTime = CurTime()
	
	if (cwMusic.NextBattleMusic < curTime) then
		cwMusic.NextBattleMusic = nil
		
		return
	end
	
	local timeLeft = (cwMusic.NextBattleMusic - curTime)
	cwMusic.NextBattleMusic = cwMusic.NextBattleMusic - timeLeft + math.Clamp(timeToAdd, 0, 60)
	
	-- Uncomment this and comment the above if you want the time added to be stackable.
	--cwMusic.NextBattleMusic = cwMusic.NextBattleMusic + math.Clamp(timeToAdd, 0, 60)
end

function cwMusic:StartBattleMusic(limit)
	if (!self:CanPlayBattleMusic()) then
		return
	end
	
	local curTime = CurTime()
	
	if (!cwMusic.NextBattleCall or curTime > cwMusic.NextBattleCall) then
		cwMusic.NextBattleCall = curTime + 0.5
	else
		return
	end
	
	if (cwMusic.NextBattleMusic) then
		if (cwMusic.NextBattleMusic > curTime) then
			self:AddBattleMusicTime(20)
			return
		end
	else
		--local faction = cwMusic:GetFaction()
		local trackType = "combat"
		local zone = Clockwork.Client:GetZone();
		
		--[[if (faction == FACTION_GOREIC) then
			trackType = "combat_goeric"
		end]]--
		
		if zone == "gore" or zone == "gore_hallway" or zone == "gore_tree" then
			trackType = "combat_goeric"
		end
		
		local musicTable = self:GetRandomBattleMusic(trackType)
		local trackName = musicTable.track
		local trackLength = musicTable.length
		
		if limit == false then
			cwMusic.NextBattleMusic = curTime + trackLength
		else
			cwMusic.NextBattleMusic = curTime + 30
		end
		
		cwMusic.MusicStartTime = curTime
		cwMusic.MaxBattleLength = trackLength
		cwMusic.BattleMusic = CreateSound(Clockwork.Client, trackName)
		
		self:FadeOutAmbientMusic(2, 1);
		
		if (!cwMusic.RecentBattleTracks) then
			cwMusic.RecentBattleTracks = {}
		end
		
		table.insert(cwMusic.RecentBattleTracks, trackName);
		
		if #cwMusic.RecentBattleTracks > 4 then
			for i = 2, #cwMusic.RecentBattleTracks do
				cwMusic.RecentBattleTracks[i - 1] = cwMusic.RecentBattleTracks[i];
				
				if i == #cwMusic.RecentBattleTracks then
					cwMusic.RecentBattleTracks[i] = nil;
				end
			end
		end
		
		if musicTable.volume then
			cwMusic.TrackVolume = musicTable.volume;
			cwMusic.BattleMusic:PlayEx(math.max((CW_CONVAR_BATTLEMUSICVOLUME:GetInt() or 100) * musicTable.volume, 0) / 100, 100);
		else
			cwMusic.TrackVolume = 1;
			cwMusic.BattleMusic:PlayEx((CW_CONVAR_BATTLEMUSICVOLUME:GetInt() or 100) / 100, 100);
		end
	end
end

function cwMusic:GetRandomBattleMusic(musicType)
	if (self.BattleMusicTable[musicType]) then
		if cwMusic.RecentBattleTracks then
			local valid_music_table = {};
			
			for i = 1, #self.BattleMusicTable[musicType] do
				local musicTable = self.BattleMusicTable[musicType][i];
				local trackName = musicTable.track;
				
				if not table.HasValue(cwMusic.RecentBattleTracks, trackName) then
					table.insert(valid_music_table, trackName);
				end
			end
			
			local randomTrackName = valid_music_table[math.random(1, #valid_music_table)];
			
			for i = 1, #self.BattleMusicTable[musicType] do
				if self.BattleMusicTable[musicType][i].track == randomTrackName then
					local randomTrack = self.BattleMusicTable[musicType][i];
					
					return {track = randomTrack.track, length = randomTrack.length, volume = randomTrack.volume or 1};
				end
			end
		else
			local randomTrack = self.BattleMusicTable[musicType][math.random(1, #self.BattleMusicTable[musicType])];
			
			return {track = randomTrack.track, length = randomTrack.length, volume = randomTrack.volume or 1};
		end
	end
end

function cwMusic:CanPlayBattleMusic()
	if (!map) then
		return;
	end;
	
	if not self.enabled then
		return false;
	end

	if not Clockwork.Client:Alive() then
		return false;
	end
	
	if Clockwork.Client.LoadingText then
		return false;
	end

	--if (Clockwork.Client:IsAdmin()) then
		if (CW_CONVAR_BATTLEMUSIC and CW_CONVAR_BATTLEMUSIC:GetInt() != 1) then
			return false
		end
	--end
	
	local zone = Clockwork.Client:GetZone();

	if zone == "tower" or zone == "theater" then
		if game.GetMap() ~= "rp_scraptown" then
			return false
		end
	end
	
	if (cwMusic.BattleMusicChangeCooldown) then
		if (cwMusic.BattleMusicChangeCooldown > CurTime()) then
			return false
		end
	end
	
	return true
end

function cwMusic:FadeOutBattleMusic(seconds, delay)
	local curTime = CurTime()

	if (!delay) then
		delay = 0;
	end
	
	if (!cwMusic.BattleMusicFadingOut) then
		cwMusic.BattleMusicFadingOut = true
	
		timer.Create("BattleFadeOutTimer", delay, 1, function()
			if cwMusic.BattleMusic then
				cwMusic.BattleMusic:FadeOut(seconds)
			end
			
			cwMusic.NextBattleMusic = nil
			cwMusic.MaxBattleLength = nil
			cwMusic.MusicStartTime = nil
			cwMusic.MusicEndTime = nil;
			cwMusic.BattleMusicChangeCooldown = curTime + 1; -- i want this to be really low
			
			timer.Simple(seconds, function()
				cwMusic.BattleMusic = nil
				cwMusic.BattleMusicFadingOut = nil
				cwMusic.TrackVolume = nil
			end)
		end)
	end
end

function cwMusic:StopBattleMusic()
	local curTime = CurTime()

	if cwMusic.BattleMusic then
		cwMusic.BattleMusic:Stop()
	end
	
	cwMusic.NextBattleMusic = nil
	cwMusic.MaxBattleLength = nil
	cwMusic.MusicStartTime = nil
	cwMusic.BattleMusicChangeCooldown = curTime + 6
	cwMusic.BattleMusic = nil
	cwMusic.BattleMusicFadingOut = nil
	cwMusic.TrackVolume = nil
end

Clockwork.datastream:Hook("EnableDynamicMusic", function(data)
	cwMusic.enabled = true;
end)

Clockwork.datastream:Hook("DisableDynamicMusic", function(data)
	cwMusic.enabled = false;
end)

Clockwork.datastream:Hook("StartAmbientMusic", function(data)
	cwMusic:StartAmbientMusic();
end)

Clockwork.datastream:Hook("StartBattleMusic", function(data)
	cwMusic:StartBattleMusic(true);
end)

Clockwork.datastream:Hook("StartBattleMusicNoLimit", function(data)
	cwMusic:StartBattleMusic(false);
end)

Clockwork.datastream:Hook("FadeAllMusic", function(data)
	if cwMusic.AmbientMusic then
		cwMusic:FadeOutAmbientMusic(4, 1);
	end
	
	if cwMusic.BattleMusic then
		cwMusic:FadeOutBattleMusic(4, 1);
	end
end)

Clockwork.datastream:Hook("FadeAmbientMusic", function(data)
	cwMusic:FadeOutAmbientMusic(4, 1);
end)

Clockwork.datastream:Hook("StopAmbientMusic", function(data)
	cwMusic:StopAmbientMusic();
end)

Clockwork.datastream:Hook("FadeBattleMusic", function(data)
	cwMusic:FadeOutBattleMusic(4, 1);
end)

Clockwork.datastream:Hook("StopBattleMusic", function(data)
	cwMusic:StopBattleMusic();
end)

Clockwork.setting:AddCheckBox("Dynamic Music", "Enable dynamic ambient music.", "cwAmbientMusic", "Click to enable/disable the dynamic ambient music system.")
Clockwork.setting:AddNumberSlider("Dynamic Music", "Ambient music volume:", "cwAmbientMusicVolume", 0, 100, 0, "Adjust the volume of the ambient music.");
Clockwork.setting:AddCheckBox("Dynamic Music", "Enable dynamic battle music.", "cwBattleMusic", "Click to enable/disable the dynamic battle music system.")
Clockwork.setting:AddNumberSlider("Dynamic Music", "Battle music volume:", "cwBattleMusicVolume", 0, 100, 0, "Adjust the volume of the battle music.");
Clockwork.setting:AddCheckBox("Dynamic Music", "Enable main menu music.", "cwMenuMusic", "Click to enable/disable the main menu music.")
Clockwork.setting:AddNumberSlider("Dynamic Music", "Main menu music volume:", "cwMenuMusicVolume", 0, 100, 0, "Adjust the volume of the main menu music.");