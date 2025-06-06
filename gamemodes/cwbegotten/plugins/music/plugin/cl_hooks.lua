-- Dynamic Music by Cash Wednesday and DETrooper

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown" or game.GetMap() == "rp_district21" or game.GetMap == "bg_district34";

Clockwork.ConVars.AMBIENTMUSIC = Clockwork.kernel:CreateClientConVar("cwAmbientMusic", 1, true, true)
Clockwork.ConVars.AMBIENTMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwAmbientMusicVolume", 100, true, true)
Clockwork.ConVars.BATTLEMUSIC = Clockwork.kernel:CreateClientConVar("cwBattleMusic", 1, true, true)
Clockwork.ConVars.BATTLEMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwBattleMusicVolume", 100, true, true)
Clockwork.ConVars.MENUMUSIC = Clockwork.kernel:CreateClientConVar("cwMenuMusic", 1, true, true)
Clockwork.ConVars.MENUMUSICVOLUME = Clockwork.kernel:CreateClientConVar("cwMenuMusicVolume", 100, true, true)

if game.GetMap() == "rp_district21" then
	Clockwork.ConVars.AMBIENTMUSICCLASSIC = Clockwork.kernel:CreateClientConVar("cwAmbientMusicClassic", 0, true, true)
	Clockwork.ConVars.BATTLEMUSICCLASSIC = Clockwork.kernel:CreateClientConVar("cwBattleMusicClassic", 0, true, true)
end

cwMusic.AmbientMusicTable = {
	["Tower of Light Ambience"] = { -- ambient music for the tower of light
		{name = "Atrium Carceri & Cities Last Broadcast - Prepare the Stage of Night", track = "begotten3soundtrack/ambiencetower/acclb-preparethestageofnight.mp3", length = 265},
		{name = "Atrium Carceri & Kammarheit - In the Black Stone", track = "begotten3soundtrack/ambiencetower/ackh-intheblackstone.mp3", length = 264},
		{name = "Atrium Carceri - The Dark Mother", track = "begotten3soundtrack/ambiencetower/ac-thedarkmother.mp3", length = 281},
		{name = "Atrium Carceri - Them", track = "begotten3soundtrack/ambiencetower/ac-them.mp3", length = 306},
		{name = "Atrium Carceri - The Void", track = "begotten3soundtrack/ambiencetower/ac-thevoid.mp3", length = 276, volume = 0.5},
		{name = "Cities Last Broadcast - Conduct", track = "begotten3soundtrack/ambiencetower/clb-conduct-edited.mp3", length = 242},
		{name = "Cities Last Broadcast - Disembodied", track = "begotten3soundtrack/ambiencetower/clb-disembodied.mp3", length = 281},
		{name = "Cities Last Broadcast - Each Night", track = "begotten3soundtrack/ambiencetower/clb-eachnight.mp3", length = 411},
		{name = "Metatron Omega - Apostolikon", track = "begotten3soundtrack/ambiencetower/mo-apostolikon.mp3", length = 585},
		{name = "Metatron Omega - Chalice of Eternity", track = "begotten3soundtrack/ambiencetower/mo-chaliceofeternity.mp3", length = 574},
		{name = "Metatron Omega - Illuminatio", track = "begotten3soundtrack/ambiencetower/mo-illuminatio.mp3", length = 471},
		{name = "Metatron Omega - Logos", track = "begotten3soundtrack/ambiencetower/mo-logos.mp3", length = 354},
		{name = "Metatron Omega - Transfiguration", track = "begotten3soundtrack/ambiencetower/mo-transfiguration-edited.mp3", length = 261},
		{name = "The Caretaker - We Cannot Escape The Past", track = "begotten3soundtrack/ambiencetower/ct-wecannotescapethepast.mp3", length = 124, volume = 0.5},
	},
	["Wasteland Ambience"] = { -- ambient music for the wasteland
		{name = "Atrium Carceri & Cities Last Broadcast - The Great Order of Things", track = "begotten3soundtrack/ambiencewasteland/acclb-thegreatorderofthings.mp3", length = 289},
		{name = "Council of Nine - Fragments of Myself", track = "begotten3soundtrack/ambiencewasteland/co9-fragmentsofmyself.mp3", length = 458},
		{name = "Council of Nine - I No Longer Hear You", track = "begotten3soundtrack/ambiencewasteland/co9-inolongerhearyou.mp3", length = 381},
		{name = "Cities Last Broadcast - Antumbra", track = "begotten3soundtrack/ambiencewasteland/clb-antumbra.mp3", length = 425},
		{name = "Cities Last Broadcast - Wherever the Heart Goes", track = "begotten3soundtrack/ambiencewasteland/clb-wherevertheheartgoes.mp3", length = 414},
		{name = "Metatron Omega - Apostolikon", track = "begotten3soundtrack/ambiencewasteland/mo-consecration.mp3", length = 428},
		{name = "Metatron Omega - Ecclesia Universalis", track = "begotten3soundtrack/ambiencewasteland/mo-ecclesiauniversalis.mp3", length = 607},
		{name = "Metatron Omega - Heosphoros", track = "begotten3soundtrack/ambiencewasteland/mo-heosphoros.mp3", length = 493},
		{name = "Metatron Omega - Hierosgamos", track = "begotten3soundtrack/ambiencewasteland/mo-hierosgamos.mp3", length = 543},
		{name = "Metatron Omega - Mysteriis De Sanguine", track = "begotten3soundtrack/ambiencewasteland/mo-mysteriisdesanguine.mp3", length = 506},
		{name = "Metatron Omega - Sacrum Noctis", track = "begotten3soundtrack/ambiencewasteland/mo-sacrumnoctis.mp3", length = 556, volume = 0.75},
		{name = "Metatron Omega - Thy Light", track = "begotten3soundtrack/ambiencewasteland/mo-thylight.mp3", length = 570},
		{name = "Sphäre Sechs - Transference", track = "begotten3soundtrack/ambiencewasteland/ss-transference.mp3", length = 332},
	},
	["Wasteland Nighttime Ambience"] = { -- ambient music for the wasteland (night)
		{name = "Ager Sonus - Through the Desert", track = "begotten3soundtrack/ambiencenight/as-throughthedesert.mp3", length = 391},
		{name = "Darkwood OST - Untitled 3", track = "begotten3soundtrack/ambiencenight/dw-untitled3.mp3", length = 128, volume = 0.75},
		{name = "Darkwood OST - Dream", track = "begotten3soundtrack/ambiencenight/dw-dream.mp3", length = 317, volume = 0.75},
		{name = "Northumbria - Black Moon (Part 1)", track = "begotten3soundtrack/ambiencenight/ns-blackmoonpt1.mp3", length = 369},
		{name = "Northumbria - Black Moon (Part 2)", track = "begotten3soundtrack/ambiencenight/ns-blackmoonpt2.mp3", length = 253},
		{name = "Psionic Asylum - Frozen Cave of Whispers", track = "begotten3soundtrack/ambiencenight/pa-frozencaveofwhispers.mp3", length = 696, volume = 0.75},
		{name = "Sphäre Sechs - The Castle Anomaly", track = "begotten3soundtrack/ambiencenight/ss-thecastleanomaly.mp3", length = 612},
		{name = "Sphäre Sechs - Aristarchus Plateau", track = "begotten3soundtrack/ambiencenight/ss-aristarchusplateau.mp3", length = 546},
	},
	["Gore Forest Ambience"] = { -- ambient music for the goeric forest
		{name = "Hellblade OST - Surtr Start", track = "begotten3soundtrack/ambiencegoeric/hb_surtrsart.mp3", length = 141},
		{name = "Hellblade OST - Surtr Backtrack", track = "begotten3soundtrack/ambiencegoeric/hb-surtrbacktrack.mp3", length = 61},
		{name = "Hellblade OST - Surtr Intro", track = "begotten3soundtrack/ambiencegoeric/hb-surtrintro.mp3", length = 81},
		{name = "Hellblade OST - Valravn Backtracking", track = "begotten3soundtrack/ambiencegoeric/hb-valravnbacktracking.mp3", length = 266},
		{name = "Hellblade OST - Volcano", track = "begotten3soundtrack/ambiencegoeric/hb-volcano.mp3", length = 444},
		{name = "Northumbria - Torngat", track = "begotten3soundtrack/ambiencegoeric/nu-torngat.mp3", length = 500, volume = 0.75},
		{name = "Paleowolf - Permafrost", track = "begotten3soundtrack/ambiencegoeric/pw-permafrost.mp3", length = 250},
		{name = "Total War: ATTILA - Barbarian Ambient", track = "begotten3soundtrack/ambiencegoeric/twa-barb503423011.mp3", length = 129},
		{name = "Total War: ATTILA - Barbarian Ambient 2", track = "begotten3soundtrack/ambiencegoeric/twa-menofthesea.mp3", length = 114, volume = 0.75},
		{name = "Total War: ATTILA - Barbarian Ambient 3", track = "begotten3soundtrack/ambiencegoeric/twa-wintersbard.mp3", length = 116, volume = 0.75},
	},
	--[[["Insanity Ambience"] = {
		{name = "Scorn - Trailer Theme", track = "begotten3soundtrack/insanity/scorntrailertheme.mp3", length = 97},
	},]]
}

cwMusic.BattleMusicTable = {
	["Wasteland Combat"] = { -- combat music for regular players/wanderers
		{name = "Bolt Thrower - Afterlife", track = "begotten3soundtrack/combat/bt-afterlife.mp3", length = 265},
		{name = "Bolt Thrower - All That Remains", track = "begotten3soundtrack/combat/bt-allthatremains.mp3", length = 211},
		{name = "Bolt Thrower - Attack in the Aftermath", track = "begotten3soundtrack/combat/bt-attackintheaftermath.mp3", length = 141},
		{name = "Bolt Thrower - Blind to Defeat", track = "begotten3soundtrack/combat/bt-blindtodefeat.mp3", length = 128},
		{name = "Bolt Thrower - Challenge For Power", track = "begotten3soundtrack/combat/bt-challengeforpower.mp3", length = 180},
		{name = "Bolt Thrower - Concession of Pain", track = "begotten3soundtrack/combat/bt-concessionofpain.mp3", length = 178},
		{name = "Bolt Thrower - Crown of Life", track = "begotten3soundtrack/combat/bt-crownoflife.mp3", length = 250},
		{name = "Bolt Thrower - Denial of Destiny", track = "begotten3soundtrack/combat/bt-denialofdestiny.mp3", length = 151},
		{name = "Bolt Thrower - Drowned in Torment", track = "begotten3soundtrack/combat/bt-drownedintorment.mp3", length = 125},
		{name = "Bolt Thrower - Eternal War", track = "begotten3soundtrack/combat/bt-eternalwar.mp3", length = 128},
		{name = "Bolt Thrower - Forgotten Existence", track = "begotten3soundtrack/combat/bt-forgottenexistence.mp3", length = 172},
		{name = "Bolt Thrower - Icon", track = "begotten3soundtrack/combat/bt-icon.mp3", length = 165},
		{name = "Bolt Thrower - In Battle There Is No Law", track = "begotten3soundtrack/combat/bt-inbattlethereisnolaw.mp3", length = 160},
		{name = "Bolt Thrower - Lost Souls Domain", track = "begotten3soundtrack/combat/bt-lostsoulsdomain.mp3", length = 225},
		{name = "Bolt Thrower - Nuclear Annihilation", track = "begotten3soundtrack/combat/bt-nuclearannihilation.mp3", length = 172},
		{name = "Bolt Thrower - Plague Bearer", track = "begotten3soundtrack/combat/bt-plaguebearer.mp3", length = 175},
		{name = "Bolt Thrower - Prophet of Hatred", track = "begotten3soundtrack/combat/bt-prophetofhatred.mp3", length = 209},
		{name = "Bolt Thrower - Psychological Warfare", track = "begotten3soundtrack/combat/bt-psychologicalwarfare.mp3", length = 117},
		{name = "Bolt Thrower - War Master", track = "begotten3soundtrack/combat/bt-warmaster.mp3", length = 190},
		{name = "Bolt Thrower - What Dwells Within", track = "begotten3soundtrack/combat/bt-whatdwellswithin.mp3", length = 174},
	},
	["Gore Forest Combat"] = { -- combat music for gores
		{name = "Hellblade OST - Bridge Combat Third", track = "begotten3soundtrack/combatgoeric/hb-bridgecombatthird.mp3", length = 136},
		{name = "Hellblade OST - Combat Valravn Balcony", track = "begotten3soundtrack/combatgoeric/hb-combatvalravnbalcony.mp3", length = 86},
		{name = "Hellblade OST - Sea of Corpses Combat", track = "begotten3soundtrack/combatgoeric/hb-seaofcorpsescombat.mp3", length = 165},
		{name = "Hellblade OST - Surtr Fight 2", track = "begotten3soundtrack/combatgoeric/hb-surtrfight2.mp3", length = 194},
		{name = "Hellblade OST - Valravn Battle 1", track = "begotten3soundtrack/combatgoeric/hb-valravnbattle1.mp3", length = 93},
		{name = "Hellblade OST - Volcano Fight Final", track = "begotten3soundtrack/combatgoeric/hb-volcanofightfinal.mp3", length = 182},
	},
}

if game.GetMap() == "rp_district21" then
	local ambientTable = {
		["Hill of Light Ambience"] = { -- ambient music for the hill of light
			{track = "ambience/hill_of_light/Altars.ogg", length = 256},
			{track = "ambience/hill_of_light/Bleak_Night.ogg", length = 268},
			{track = "ambience/hill_of_light/Cold_Breeze.ogg", length = 272},
			{track = "ambience/hill_of_light/Frostbite.ogg", length = 335},
			{track = "ambience/hill_of_light/Howling_Wolves.ogg", length = 247, volume = 0.5},
			{track = "ambience/hill_of_light/Moonlight.ogg", length = 185, volume = 0.5},
			{track = "ambience/hill_of_light/Nox_Eterna.ogg", length = 273},
			{track = "ambience/hill_of_light/Voice_Of_The_Night.ogg", length = 186},
		},
		["District 21 Ambience"] = { -- ambient music for the d21 wasteland
			{track = "ambience/outskirts/day/cripple.mp3", length = 74, volume = 1.8},
			{track = "ambience/outskirts/day/darkness_falls.mp3", length = 280, volume = 1.8},
			{track = "ambience/outskirts/day/dawn.mp3", length = 216, volume = 1.8},
			{track = "ambience/outskirts/day/frequency.mp3", length = 434, volume = 1.8},
			{track = "ambience/outskirts/day/hunter.mp3", length = 179, volume = 1.85},
			{track = "ambience/outskirts/day/mother.mp3", length = 95, volume = 1.85},
			{track = "ambience/outskirts/day/passing.mp3", length = 138, volume = 1.85},
			{track = "ambience/outskirts/day/prepare.mp3", length = 184, volume = 1.85},
			{track = "ambience/outskirts/day/reborn.mp3", length = 234, volume = 1.85},
			{track = "ambience/outskirts/day/rest.mp3", length = 70, volume = 1.85},
			{track = "ambience/outskirts/day/watcher.mp3", length = 263, volume = 1.85},
			{track = "ambience/outskirts/day/winds.mp3", length = 196, volume = 1.85},
			{track = "ambience/outskirts/day/abberance.mp3", length = 184, volume = 1.85},
			{track = "ambience/outskirts/day/deepwoods.mp3", length = 117, volume = 1.85},
			{track = "ambience/outskirts/day/rally.mp3", length = 184, volume = 1.85},
			{track = "ambience/outskirts/day/saintly.mp3", length = 44, volume = 1.85},
			{track = "ambience/outskirts/day/wicked_things.mp3", length = 44, volume = 1.85},
			{track = "ambience/outskirts/day/youth.mp3", length = 74, volume = 1.85},
		},
		["District 21 Nighttime Ambience"] = { -- ambient music for the d21 wasteland night
			{track = "ambience/outskirts/night/amnesia.mp3", length = 65, volume = 1.8},
			{track = "ambience/outskirts/night/ancient_land.mp3", length = 206, volume = 1.8},
			{track = "ambience/outskirts/night/before.mp3", length = 227, volume = 1.8},
			{track = "ambience/outskirts/night/dark_water.mp3", length = 77, volume = 1.8},
			{track = "ambience/outskirts/night/darkness.mp3", length = 76, volume = 1.8},
			{track = "ambience/outskirts/night/lost_moon.mp3", length = 127, volume = 1.8},
			{track = "ambience/outskirts/night/memory.mp3", length = 179, volume = 1.8},
			{track = "ambience/outskirts/night/penumbra.mp3", length = 120, volume = 1.8},
			{track = "ambience/outskirts/night/prelude.mp3", length = 154, volume = 1.8},
		},
	};
	
	local combatTable = {
		["District 21 Combat"] = {
			{track = "ambience/outskirtscombat/defenders_of_light.mp3", length = 167}, volume = 1.75,
			{track = "ambience/outskirtscombat/fight_with_fear.mp3", length = 152, volume = 1.75},
			{track = "ambience/outskirtscombat/hearth.mp3", length = 159, volume = 1.75},
			{track = "ambience/outskirtscombat/highlander.mp3", length = 194, volume = 1.75},
			{track = "ambience/outskirtscombat/kite_wall.mp3", length = 203, volume = 1.75},
			{track = "ambience/outskirtscombat/northern_horde.mp3", length = 252, volume = 1.75},
			{track = "ambience/outskirtscombat/sacrifice_the_forsaken.mp3", length = 188, volume = 1.75},
			{track = "ambience/outskirtscombat/vengeance.mp3", length = 163, volume = 1.75},
			{track = "ambience/outskirtscombat/wrath_of_blood.mp3", length = 193, volume = 1.75},
		},
	};
	
	table.Merge(cwMusic.AmbientMusicTable, ambientTable, true);
	table.Merge(cwMusic.BattleMusicTable, combatTable, true);
end

function cwMusic:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "cwAmbientMusic" and newValue) then
		if newValue == "0" then
			self:StopAmbientMusic();
		else
			cwMusic.AmbientMusicChangeCooldown = CurTime() + 5;
		end
	elseif (name == "cwAmbientMusicVolume" and newValue) then
		if newValue == "0" then
			Clockwork.ConVars.AMBIENTMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			Clockwork.ConVars.AMBIENTMUSIC:SetInt(1);
		elseif self.AmbientMusic then
			self.AmbientMusic:ChangeVolume(math.max(0, (tonumber(newValue) / 100) * (self.TrackVolume or 1)));
		end
	elseif (name == "cwBattleMusic" and newValue) then
		if newValue == "0" or newValue == "2" and cwDueling and !Clockwork.Client.dueling then
			self:StopBattleMusic();
		end
	elseif (name == "cwBattleMusicVolume" and newValue) then
		if newValue == "0" then
			Clockwork.ConVars.BATTLEMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			Clockwork.ConVars.BATTLEMUSIC:SetInt(1);
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
			Clockwork.ConVars.MENUMUSIC:SetInt(0);
		elseif previousValue == "0" and newValue ~= "0" then
			Clockwork.ConVars.MENUMUSIC:SetInt(1);
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
	if newZone == previousZone then return end;

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
				if hook.Run("CanPlayAmbientMusic") ~= false then
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

function cwMusic:StartAmbientMusic(bForce, trackOverride)
	if !bForce and hook.Run("CanPlayAmbientMusic") == false then
		return
	end
	
	local curTime = CurTime()
	
	if bForce then
		if self.AmbientMusic then
			self:StopAmbientMusic();
		end
		
		if self.BattleMusic then
			self:StopBattleMusic();
		end
	else
		if (!cwMusic.NextAmbientCall or curTime > cwMusic.NextAmbientCall) then
			cwMusic.NextAmbientCall = curTime + 0.5
		else
			return
		end
	end
		
	if (!cwMusic.AmbientMusic) then
		local trackType = self:GetAmbientMusicCategory() or "wasteland";
		local musicTable = trackOverride or self:GetRandomAmbientMusic(trackType);
		local trackName = musicTable.track;
		local trackLength = musicTable.length or SoundDuration(trackName);
		
		cwMusic.MusicStartTime = curTime
		cwMusic.MusicEndTime = curTime + trackLength
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
			cwMusic.AmbientMusic:PlayEx(math.max((Clockwork.ConVars.AMBIENTMUSICVOLUME:GetInt() or 100) * musicTable.volume, 0) / 100, 100);
		else
			cwMusic.TrackVolume = 1;
			cwMusic.AmbientMusic:PlayEx((Clockwork.ConVars.AMBIENTMUSICVOLUME:GetInt() or 100) / 100, 100);
		end
	end
end

function cwMusic:GetAmbientMusicCategory()
	local trackType = "Wasteland Ambience"
	local zone = Clockwork.Client:GetZone();
	
	if game.GetMap() == "rp_district21" and Clockwork.ConVars.AMBIENTMUSICCLASSIC:GetInt() ~= 1 then
		trackType = "District 21 Ambience"
		
		if zone == "wasteland" and cwDayNight and cwDayNight.currentCycle == "night" then
			trackType = "District 21 Nighttime Ambience";
		elseif zone == "tower"  then
			trackType = "Hill of Light Ambience";
		elseif zone == "gore" or zone == "gore_hallway" or zone == "gore_tree" then
			trackType = "Gore Forest Ambience";
		end
	else
		if zone == "wasteland" and cwDayNight and cwDayNight.currentCycle == "night" then
			trackType = "Wasteland Nighttime Ambience";
		elseif zone == "tower" and game.GetMap() ~= "rp_scraptown" then
			trackType = "Tower of Light Ambience";
		elseif zone == "gore" or zone == "gore_hallway" or zone == "gore_tree" then
			trackType = "Gore Forest Ambience";
		end
	end
	
	return trackType;
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
					
					return {track = randomTrack.track, length = randomTrack.length or SoundDuration(randomTrack.track), volume = randomTrack.volume or 1};
				end
			end
		else
			local randomTrack = self.AmbientMusicTable[musicType][math.random(1, #self.AmbientMusicTable[musicType])];
			
			return {track = randomTrack.track, length = randomTrack.length or SoundDuration(randomTrack.track), volume = randomTrack.volume or 1};
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

	--if (Clockwork.Client:IsAdmin()) then
		if (Clockwork.ConVars.AMBIENTMUSIC and Clockwork.ConVars.AMBIENTMUSIC:GetInt() < 1) then
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
		
	if zone == "caves" or zone == "scrapper" or zone == "hell" or zone == "manor" or zone == "toothboy" or zone == "duel" or zone == "theater" or zone == "hillbunker" or string.find(zone, "sea_") then
		-- No ambient music in these areas.
		return false
	end
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

function cwMusic:StartBattleMusic(limit, bForce, trackOverride)
	if !bForce and hook.Run("CanPlayBattleMusic") == false then
		return
	end
	
	local curTime = CurTime()
	
	if bForce then
		if self.AmbientMusic then
			self:StopAmbientMusic();
		end
		
		if self.BattleMusic then
			self:StopBattleMusic();
		end
	else
		if (!cwMusic.NextBattleCall or curTime > cwMusic.NextBattleCall) then
			cwMusic.NextBattleCall = curTime + 0.5
		else
			return
		end
	end
	
	if (cwMusic.NextBattleMusic) then
		if (cwMusic.NextBattleMusic > curTime) then
			self:AddBattleMusicTime(20)
			return
		end
	else
		local trackType = self:GetBattleMusicCategory() or "Wasteland Combat";
		local musicTable = trackOverride or self:GetRandomBattleMusic(trackType);
		local trackName = musicTable.track;
		local trackLength = musicTable.length or SoundDuration(trackName);
		
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
			cwMusic.BattleMusic:PlayEx(math.max((Clockwork.ConVars.BATTLEMUSICVOLUME:GetInt() or 100) * musicTable.volume, 0) / 100, 100);
		else
			cwMusic.TrackVolume = 1;
			cwMusic.BattleMusic:PlayEx((Clockwork.ConVars.BATTLEMUSICVOLUME:GetInt() or 100) / 100, 100);
		end
	end
end

function cwMusic:GetBattleMusicCategory()
	local trackType = "Wasteland Combat";
	local zone = Clockwork.Client:GetZone();
	
	if (game.GetMap() == "rp_district21" and Clockwork.ConVars.BATTLEMUSICCLASSIC:GetInt() ~= 1) then
		trackType = "District 21 Combat"
	end
	
	if zone == "gore" or zone == "gore_hallway" or zone == "gore_tree" then
		trackType = "Gore Forest Combat";
	end
	
	return trackType;
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
					
					return {track = randomTrack.track, length = randomTrack.length or SoundDuration(randomTrack.track), volume = randomTrack.volume or 1};
				end
			end
		else
			local randomTrack = self.BattleMusicTable[musicType][math.random(1, #self.BattleMusicTable[musicType])];
			
			return {track = randomTrack.track, length = randomTrack.length or SoundDuration(randomTrack.track), volume = randomTrack.volume or 1};
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
		if (Clockwork.ConVars.BATTLEMUSIC and Clockwork.ConVars.BATTLEMUSIC:GetInt() < 1) then
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

netstream.Hook("EnableDynamicMusic", function(data)
	cwMusic.enabled = true;
end)

netstream.Hook("DisableDynamicMusic", function(data)
	cwMusic.enabled = false;
end)

netstream.Hook("StartAmbientMusic", function(data)
	cwMusic:StartAmbientMusic();
end)

netstream.Hook("StartBattleMusic", function(data)
	cwMusic:StartBattleMusic(true);
end)

netstream.Hook("StartBattleMusicNoLimit", function(data)
	cwMusic:StartBattleMusic(false);
end)

netstream.Hook("FadeAllMusic", function(data)
	if cwMusic.AmbientMusic then
		cwMusic:FadeOutAmbientMusic(4, 1);
	end
	
	if cwMusic.BattleMusic then
		cwMusic:FadeOutBattleMusic(4, 1);
	end
end)

netstream.Hook("FadeAmbientMusic", function(data)
	cwMusic:FadeOutAmbientMusic(4, 1);
end)

netstream.Hook("StopAmbientMusic", function(data)
	cwMusic:StopAmbientMusic();
end)

netstream.Hook("FadeBattleMusic", function(data)
	cwMusic:FadeOutBattleMusic(4, 1);
end)

netstream.Hook("StopBattleMusic", function(data)
	cwMusic:StopBattleMusic();
end)

function cwMusic:SetupSettingsCustomPanel(category, text, panel)
	if category == "Dynamic Music" and text == "Music player" then
		panel:SetName("Music Player");
		panel:SetPadding(4);
		panel.trackButtons = {};
		
		function panel:Think()
			if cwMusic.BattleMusic then
				local playingSound = tostring(cwMusic.BattleMusic);
				
				if playingSound then
					playingSound = playingSound:match("%[(.+)%]");
					
					for k, v in pairs(cwMusic.BattleMusicTable) do
						for i, v2 in ipairs(v) do
							if v2.track == playingSound then
								local timeLeft = math.max(0, math.ceil((cwMusic.NextBattleMusic or 0) - CurTime()));
								
								panel:SetName("Music Player - "..(v2.name or v2.track).." ("..string.FormattedTime(timeLeft, "%02i:%02i")..")");
								
								for i2, v3 in ipairs(panel.trackButtons) do
									if v3.track == playingSound then
										if !v3:GetToggle() then
											v3:SetToggle(true);
										end
									elseif v3:GetToggle() then
										v3:SetToggle(false);
									end
								end
							
								return;
							end
						end
					end
				end
			elseif cwMusic.AmbientMusic then
				local playingSound = tostring(cwMusic.AmbientMusic);
				
				if playingSound then
					playingSound = playingSound:match("%[(.+)%]");
					
					for k, v in pairs(cwMusic.AmbientMusicTable) do
						for i, v2 in ipairs(v) do
							if v2.track == playingSound then
								local timeLeft = math.max(0, math.ceil((cwMusic.MusicEndTime or 0) - CurTime()));
								
								panel:SetName("Music Player - "..(v2.name or v2.track).." ("..string.FormattedTime(timeLeft, "%02i:%02i")..")");
								
								for i2, v3 in ipairs(panel.trackButtons) do
									if v3.track == playingSound then
										if !v3:GetToggle() then
											v3:SetToggle(true);
										end
									elseif v3:GetToggle() then
										v3:SetToggle(false);
									end
								end
							
								return;
							end
						end
					end
				end
			end
			
			panel:SetName("Music Player");
		end
		
		local categoryList = vgui.Create("DCategoryList");
		
		categoryList:SetHeight(300);
		
		function categoryList:Paint()
		
		end
		
		for k, v in pairs(self.AmbientMusicTable) do
			local category = categoryList:Add(k);
			local panelList = vgui.Create("DPanelList");
			
			panelList:SetPaintBackground(false);
		
			for i, v2 in ipairs(v) do
				local musicButton = vgui.Create("DButton");
				
				musicButton:SetSize(300, 24);
				musicButton:SetText((v2.name or v2.track).." ("..string.FormattedTime(v2.length or SoundDuration(v2.track), "%02i:%02i")..")");
				musicButton:SetFont("begotsettingsfont2");
				musicButton:SetIsToggle(true);
				musicButton.track = v2.track;
				
				function musicButton.DoClick()
					if musicButton:GetToggle() then
						cwMusic:StopAmbientMusic();
						musicButton:SetToggle(false);
					else
						cwMusic:StartAmbientMusic(true, v2);
						musicButton:SetToggle(true);
					end
				end
				
				function musicButton.Paint()
					local w, h = musicButton:GetSize();

					if (musicButton.m_bBackground) then
						local color = Color(45, 20, 20, 175);
						
						musicButton:SetTextColor(Color(150, 150, 150, 150));
						
						if (musicButton:GetDisabled()) then
							color = Color(20, 20, 20, 175);
							musicButton:SetTextColor(Color(100, 100, 100, 150));
						elseif (musicButton.Depressed) or musicButton:GetToggle() then
							color = Color(70, 0, 0, 175);
							musicButton:SetTextColor(Color(200, 200, 200, 150));
						elseif (musicButton.Hovered) then
							color = Color(70, 20, 20, 175);
							musicButton:SetTextColor(Color(175, 175, 175, 150));
						end;

						draw.RoundedBox(4, 4, 0, w - 8, h, color);
					end;
				end

				panelList:AddItem(musicButton);
				
				table.insert(panel.trackButtons, musicButton);
			end
			
			panelList:SetSpacing(1);
			panelList:SetPadding(4);
			panelList:EnableVerticalScrollbar();
			panelList:EnableHorizontal(false);
			
			category:SetContents(panelList);
		end
		
		for k, v in pairs(self.BattleMusicTable) do
			local category = categoryList:Add(k);
			local panelList = vgui.Create("DPanelList");
			
			panelList:SetPaintBackground(false);
		
			for i, v2 in ipairs(v) do
				local musicButton = vgui.Create("DButton");
				
				musicButton:SetSize(300, 24);
				musicButton:SetText((v2.name or v2.track).." ("..string.FormattedTime(v2.length or SoundDuration(v2.track), "%02i:%02i")..")");
				musicButton:SetIsToggle(true);
				musicButton:SetFont("begotsettingsfont2");
				musicButton.track = v2.track;
				
				function musicButton.DoClick()
					if musicButton:GetToggle() then
						cwMusic:StopBattleMusic();
						musicButton:SetToggle(false);
					else
						cwMusic:StartBattleMusic(false, true, v2);
						musicButton:SetToggle(true);
					end
				end
				
				function musicButton.Paint()
					local w, h = musicButton:GetSize();

					if (musicButton.m_bBackground) then
						local color = Color(45, 20, 20, 175);
						
						musicButton:SetTextColor(Color(150, 150, 150, 150));
						
						if (musicButton:GetDisabled()) then
							color = Color(20, 20, 20, 175);
							musicButton:SetTextColor(Color(100, 100, 100, 150));
						elseif (musicButton.Depressed) or musicButton:GetToggle() then
							color = Color(70, 0, 0, 175);
							musicButton:SetTextColor(Color(200, 200, 200, 150));
						elseif (musicButton.Hovered) then
							color = Color(70, 20, 20, 175);
							musicButton:SetTextColor(Color(175, 175, 175, 150));
						end;

						draw.RoundedBox(4, 4, 0, w - 8, h, color);
					end;
				end
				
				panelList:AddItem(musicButton);
				
				table.insert(panel.trackButtons, musicButton);
			end
			
			panelList:SetSpacing(1);
			panelList:SetPadding(4);
			panelList:EnableVerticalScrollbar();
			panelList:EnableHorizontal(false);
			
			category:SetContents(panelList);
		end
		
		panel:AddItem(categoryList);
		panel.categoryList = categoryList;
	end
end

Clockwork.setting:AddCheckBox("Dynamic Music", "Enable dynamic ambient music.", "cwAmbientMusic", "Click to toggle the dynamic ambient music system.")
if game.GetMap() == "rp_district21" then Clockwork.setting:AddCheckBox("Dynamic Music", "Enable classic ambient music.", "cwAmbientMusicClassic", "Click to enable/disable the classic Begotten III music.") end
Clockwork.setting:AddNumberSlider("Dynamic Music", "Ambient music volume:", "cwAmbientMusicVolume", 0, 100, 0, "Adjust the volume of the ambient music.");
Clockwork.setting:AddMultiChoice("Dynamic Music", "Enable dynamic battle music:", "cwBattleMusic", {{"Enable", "Click to enable the dynamic battle music system."}, {"Enable (Duels Only)", "Click to enable the dynamic battle music system only in duels."}, {"Disable", "Click to disable the dynamic battle music system."}})
if game.GetMap() == "rp_district21" then Clockwork.setting:AddCheckBox("Dynamic Music", "Enable classic battle music.", "cwBattleMusicClassic", "Click to enable/disable the classic Begotten III music.") end
Clockwork.setting:AddNumberSlider("Dynamic Music", "Battle music volume:", "cwBattleMusicVolume", 0, 100, 0, "Adjust the volume of the battle music.");
Clockwork.setting:AddCheckBox("Dynamic Music", "Enable main menu music.", "cwMenuMusic", "Click to toggle the main menu music.")
Clockwork.setting:AddNumberSlider("Dynamic Music", "Main menu music volume:", "cwMenuMusicVolume", 0, 100, 0, "Adjust the volume of the main menu music.");
Clockwork.setting:AddCustomPanel("Dynamic Music", "Music player", "DForm");