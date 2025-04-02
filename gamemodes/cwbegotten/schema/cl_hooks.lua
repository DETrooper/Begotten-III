--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local requiredWorkshopAddons = {
	"2442758302",
	"2443016109",
	"2443045596",
	"2442796233",
	"2442809967",
	"2442244710",
	"2465148067",
	"2594063203",
	"2790936125",
	"3456524237",
};

if game.GetMap() == "rp_district21" then
	table.insert(requiredWorkshopAddons, "3121268073");
	table.insert(requiredWorkshopAddons, "3126101449");
	table.insert(requiredWorkshopAddons, "3015058225");
end

-- Disabled these for now since gabs added their content to the Begotten III content.
Schema.requiredMounts = {
	--["episodic"] = "Half-Life 2: Episode 1",
	--["ep2"] = "Half-Life 2: Episode 2",
	["cstrike"] = "Counter-Strike: Source",
};

Schema.cheapleMessages = {"I've gotta get away from that fucking thing!", "It's getting closer!", "What does that thing want from me!?", "Why can't anyone else see it!?", "Shit, it's getting closer!", "Gotta keep moving... gotta keep moving..."};

if !Schema.contentVerified then
	Schema.contentVerified = "unverified";
end

function Schema:Initialize()
	if (!file.Exists("b3", "DATA")) then
		file.CreateDir("b3")
	end
	
	if (self.tempTextures) then
		for i = 1, #self.tempTextures do
			self:DownloadMaterial(self.tempTextures[i].url, self.tempTextures[i].path);
		end;
	end;
	
	if render.GetHDREnabled() == false and game.GetMap() == "rp_begotten3" then
		RunConsoleCommand("mat_hdr_enabled", "1");
		RunConsoleCommand("retry");
	end
	
	--RunConsoleCommand("fps_max", "300");
	RunConsoleCommand("hud_draw_fixed_reticle", "0");
	RunConsoleCommand("mat_hdr_level", "2");
	RunConsoleCommand("mat_motion_blur_enabled", "1");
end

-- A function to start a sound.
function Schema:StartSound(soundStr, volume, pitch, dsp)
    if (!soundStr or type(soundStr) != "string") then
        return;
    end;
    
    if (Clockwork.Client.customSound) then
        Clockwork.Client.customSound:Stop();
        Clockwork.Client.customSound = nil;
        
        if (Clockwork.Client.customSoundOldDSP) then
            Clockwork.Client.customSoundOldDSP = nil;
        end;
    end;
    
    local pitch = math.Clamp(tonumber(pitch), 30, 255) or 100;
    local volume = tonumber(volume) or 1;
    local dsp = tonumber(dsp) or 0;
    
    if (volume > 1) then
        volume = volume / 100;
    end;
    
    if (!Clockwork.Client.customSound) then
        if not string.find(soundStr, "http") then
            Clockwork.Client.customSound = CreateSound(Clockwork.Client, soundStr);
            
            if (Clockwork.Client.customSound and !Clockwork.Client.customSound:IsPlaying()) then
                Clockwork.Client.customSound:SetDSP(dsp);
                Clockwork.Client.customSound:PlayEx(volume, pitch);
            end;
        else
            if pitch then
                if tonumber(pitch or 0) > 1 then
                    pitch = pitch / 100
                end
            end
            sound.PlayURL(soundStr, "noplay noblock", function(station)
                if (IsValid(station)) then
                    Clockwork.Client.customSound = station

                    station:SetPos(LocalPlayer():GetPos())

                    station:SetVolume(volume)
                    station:SetPlaybackRate(pitch)
                    station:Play()
                end
            end)
        end
    end;
end;

-- A function to stop a sound.
function Schema:StopSound()
	if (!Clockwork.Client.customSound) then
		return;
	else
		if (Clockwork.Client.customSound:IsPlaying()) then
			Clockwork.Client.customSound:Stop();
			Clockwork.Client.customSound = nil;
		
			if (Clockwork.Client.customSoundOldDSP) then
				Clockwork.Client.customSoundOldDSP = nil;
			end;
		end;
	end;
end;

-- A function to fade out a sound.
function Schema:FadeOut(duration)
	local duration = tonumber(duration) or 3;
	
	if (!Clockwork.Client.customSound or Clockwork.Client.customSoundFadingOut) then
		return;
	else
		if (Clockwork.Client.customSound:IsPlaying()) then
			Clockwork.Client.customSound:FadeOut(duration);
			Clockwork.Client.customSoundFadingOut = true;
			
			timer.Simple(duration, function()
				Clockwork.Client.customSound = nil;
				Clockwork.Client.customSoundFadingOut = nil;
				
				if (Clockwork.Client.customSoundOldDSP) then
					Clockwork.Client.customSoundOldDSP = nil;
				end;
			end);
		end;
	end;
end;

-- A function to change the volume of a sound.
function Schema:ChangeVolume(newVolume, delta)
	local newVolume = tonumber(newVolume) or 0;
	local delta = tonumber(delta) or 3;
	
	if (!Clockwork.Client.customSound or Clockwork.Client.customSoundChangingVolume) then
		return;
	else
		if (Clockwork.Client.customSound:IsPlaying() and Clockwork.Client.customSound:GetVolume() != newVolume) then
			Clockwork.Client.customSound:ChangeVolume(newVolume, delta);
			Clockwork.Client.customSoundChangingVolume = true;
			
			timer.Simple(delta, function()
				Clockwork.Client.customSoundChangingVolume = nil;
			end);
		end;
	end;
end;

-- A function to change the pitch of a sound.
function Schema:ChangePitch(newPitch, delta)
	local newPitch = tonumber(newPitch) or 0;
	local delta = tonumber(delta) or 3;
	
	if (!Clockwork.Client.customSound or Clockwork.Client.customSoundChangingPitch) then
		return;
	else
		if (Clockwork.Client.customSound:IsPlaying() and Clockwork.Client.customSound:GetPitch() != newPitch) then
			Clockwork.Client.customSound:ChangePitch(newPitch, delta);
			Clockwork.Client.customSoundChangingPitch = true;
			
			timer.Simple(delta, function()
				Clockwork.Client.customSoundChangingPitch = nil;
			end);
		end;
	end;
end;

-- A function to change the pitch of a sound.
function Schema:SetDSP(newDSP, reset)
	if (Clockwork.Client.customSoundOldDSP) then
		Clockwork.Client.customSoundOldDSP = nil;
	end;
	
	if (!Clockwork.Client.customSound) then
		return;
	else
		Clockwork.Client.customSoundOldDSP = Clockwork.Client.customSound:GetDSP();
		
		if (Clockwork.Client.customSound:IsPlaying() and Clockwork.Client.customSound:GetDSP() != newDSP) then
			if (!reset) then
				Clockwork.Client.customSound:SetDSP(tonumber(newDSP));
			else
				Clockwork.Client.customSound:SetDSP(Clockwork.Client.customSoundOldDSP);
			end;
		end;
	end;
end;

function Schema:Think()
	if Clockwork.Client:HasTrait("followed") and Clockwork.Client:Alive() and not self.caughtByCheaple then
		if IsValid(statichitman) then
			if Clockwork.Client.LoadingText then
				return;
			end
			
			local position = Clockwork.Client:GetPos();
			local cheaplePosition = statichitman:GetPos();
			local distance = cheaplePosition:DistToSqr(position);
			local yaw = (position - cheaplePosition):Angle().yaw;
			local forward = statichitman:GetForward();
			local zDifference = position.z - cheaplePosition.z;
			
			if Clockwork.Client:HasTrait("marked") then
				if !statichitman.flaming then
					statichitman.flaming = true;
					
					statichitman:ResetSequence("run_all");
					ParticleEffectAttach("env_fire_large", 1, statichitman, 1);
					
					statichitman:EmitSound("ambient/fire/fire_small1.wav");
				end
			end
				
			if statichitman.flaming then
				statichitman:SetPos(cheaplePosition + (forward * 1.5) + Vector(0, 0, zDifference * FrameTime()));
			else
				statichitman:SetPos(cheaplePosition + (forward * 0.325) + Vector(0, 0, zDifference * FrameTime()));
			end
			
			statichitman:SetAngles(Angle(0, yaw, 0));
			statichitman:FrameAdvance();
			
			if (distance <= 512 * 512) and Clockwork.Client:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT then
				local curTime =  CurTime();
			
				if Clockwork.HeartbeatSound and Clockwork.HeartbeatSound:IsPlaying() then
					Clockwork.HeartbeatSound:Stop();
				end 
			
				if not Schema.HeartbeatSound then
					Schema.HeartbeatSound = CreateSound(Clockwork.Client, "vj_player/heartbeat.wav");
					Schema.HeartbeatSound:Play();
				end
				
				if !self.nextCheapleMessage or self.nextCheapleMessage < curTime then
					self.nextCheapleMessage = curTime + math.random(30, 90);
					
					Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "***' "..self.cheapleMessages[math.random(1, #self.cheapleMessages)]);
				end
			else
				if Schema.HeartbeatSound then
					Schema.HeartbeatSound:FadeOut(3);
					Schema.HeartbeatSound = nil;
				end
			end
				
			if !self.nextCheapleSave or self.nextCheapleSave < CurTime() then
				self.nextCheapleSave = CurTime() + 1.5;
				
				netstream.Start("SaveCheaplePos", statichitman:GetPos());
			end
				
			if (distance < 64 * 64) then
				Schema:CheapleCaught();
			end
		end
		
		if Schema.caughtByCheaple and Schema.cheapleLight then
			local dynamicLight = DynamicLight(Clockwork.Client:EntIndex());
			
			dynamicLight.Pos = Vector(260, 4995, -10915); 
			dynamicLight.r = 255;
			dynamicLight.g = 160;
			dynamicLight.b = 160;
			dynamicLight.Brightness = 0.5;
			dynamicLight.Size = 1024;
			dynamicLight.DieTime = curTime + 0.1;
			dynamicLight.Style = 4;
		end
	elseif IsValid(statichitman) then
		self:ClearCheaple();
	elseif !Clockwork.Client:Alive() and Schema.caughtByCheaple then
		Schema.caughtByCheaple = false;
	end
end

netstream.Hook("CheaplePos", function(data)
	if Clockwork.Client:HasTrait("followed") and Clockwork.Client:Alive() and not Schema.caughtByCheaple then
		if IsValid(statichitman) and data then
			statichitman:SetPos(data);
		else
			Schema:CheapleFollows(data);
		end
	end
end);

netstream.Hook("PlayerCustomSoundCheck", function(data)
	local soundPlaying = false;
	
	if (Clockwork.Client.customSound and Clockwork.Client.customSound:IsPlaying()) then
		soundPlaying = true;
	end;
	
	netstream.Start("ConfirmCustomSoundCheck", {soundPlaying});
end);

netstream.Hook("StartCustomSound", function(data)
	local sound = data[1];
	local volume = data[2];
	local pitch = data[3];
	local dsp = data[4] or 0;
	
	Schema:StartSound(sound, volume, pitch, dsp)
end);

netstream.Hook("StopCustomSound", function(data)
	Schema:StopSound();
end);

netstream.Hook("FadeOutCustomSound", function(data)
	if (type(data) == "table") then
		data = data[1];
	end;
	
	Schema:FadeOut(data);
end);

netstream.Hook("CustomSoundChangeVolume", function(data)
	local newVolume = data[1];
	local delta = data[2];

	Schema:ChangeVolume(newVolume, delta);
end);

netstream.Hook("CustomSoundChangePitch", function(data)
	local newPitch = data[1];
	local delta = data[2];

	Schema:ChangePitch(newPitch, delta);
end);

netstream.Hook("CustomSoundChangeDSP", function(data)
	local newDSP = data;
	local reset = false;
	
	if (type(data) == "table") then
		newDSP = data[1];
		reset = data[2] or false;
	end;

	Schema:SetDSP(newDSP, reset);
end);


-- A function to print chatbox text without using RGB color.
function Schema:EasyText(...)
	local args = {...};
	local icon;
	
	for k, v in pairs (args) do
		-- IsColor() doesn't work in all cases.
		if (isentity(v) or (istable(v) and (!v.r and !v.g and !v.b))) then
			args[k] = nil;
			continue;
		end

		if isstring(v) and (string.find(v, ".png")) then
			icon = v;
			args[k] = nil
			continue;
		end;
		
		if (colors[v]) then
			args[k] = colors[v];
		end;
	end;
	
	Clockwork.chatBox:Add(nil, icon, unpack(args));
end;

netstream.Hook("EasyText", function(varargs)
	Schema:EasyText(unpack(varargs))
end);

-- Called when a player's footstep sound should be played.
function Schema:PlayerFootstep(player, position, foot, soundString, volume, recipientFilter)
	local running = nil;
	
	if (player:IsRunning()) then
		running = true;
	end;
	
	if cwPowerArmor and player:IsWearingPowerArmor()then
		if running then
			local runSounds = {
				"npc/dog/dog_footstep1.wav",
				"npc/dog/dog_footstep2.wav",
				"npc/dog/dog_footstep3.wav",
				"npc/dog/dog_footstep4.wav",
			}; 
			
			player:EmitSound(runSounds[math.random(1, #runSounds)]);
		else
			local walkSounds = {
				"npc/dog/dog_footstep_walk01.wav",
				"npc/dog/dog_footstep_walk02.wav",
				"npc/dog/dog_footstep_walk03.wav",
				"npc/dog/dog_footstep_walk04.wav",
				"npc/dog/dog_footstep_walk05.wav",
				"npc/dog/dog_footstep_walk06.wav",
				"npc/dog/dog_footstep_walk07.wav",
				"npc/dog/dog_footstep_walk08.wav",
				"npc/dog/dog_footstep_walk09.wav",
				"npc/dog/dog_footstep_walk10.wav"
			};
			
			player:EmitSound(walkSounds[math.random(1, #walkSounds)]);
		end
		
		return true;
	end
	
	if (player:Crouching() and player:GetNetVar("hasNimble")) or player:GetCharmEquipped("urn_silence") or player:GetColor().a <= 0 then
		return true;
	end;

	local clothesItem = player:GetClothesEquipped();
	
	if (clothesItem) then
		if (running) then
			if (clothesItem.runSound) then
				if (type(clothesItem.runSound) == "table") then
					player:EmitSound(clothesItem.runSound[math.random(1, #clothesItem.runSound)], 65, math.random(95, 100), 0.5);
				else
					player:EmitSound(clothesItem.runSound, 65, math.random(95, 100), 0.50);
				end;
			end;
		elseif (clothesItem.walkSound) then
			if (type(clothesItem.walkSound) == "table") then
				player:EmitSound(clothesItem.walkSound[math.random(1, #clothesItem.walkSound)], 65, math.random(95, 100), 0.5);
			else
				player:EmitSound(clothesItem.walkSound, 65, math.random(95, 100), 0.5);
			end;
		end;
	end;
	
	player:EmitSound(soundString);

	return true;
end;

-- Called when the local player attempts to zoom.
function Schema:PlayerCanZoom()
	return false;
end

local animalModels = {
	"models/animals/deer1.mdl",
	"models/animals/goat.mdl",
	"models/animals/bear.mdl",
	"models/animal_ragd/piratecat_leopard.mdl",
	"models/begotten/creatures/wolf.mdl",
};

-- Called when an entity's menu options are needed.
function Schema:GetEntityMenuOptions(entity, options)
	if Clockwork.Client:Alive() then
		local curTime = CurTime();
		local clientFaction = Clockwork.Client:GetNetVar("kinisgerOverride") or Clockwork.Client:GetFaction();
	
		if entity:IsPlayer() then
			local entFaction = entity:GetNetVar("kinisgerOverride") or entity:GetFaction();
			
			if entity:Alive() and (clientFaction == "Hillkeeper" or clientFaction == "Holy Hierarchy") and (entFaction ~= "Hillkeeper" and entFaction ~= "Holy Hierarchy") and entity:GetNetVar("tied") != 0 then
				for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
					if v:GetClass() == "cw_salesman" and v:GetNetworkedString("Name") == "The Headsman" then
						options["Sell Into Slavery"] = "cw_sellSlave";
						
						break;
					end
				end
			elseif entity:Alive() and clientFaction == "Goreic Warrior" and entFaction ~= "Goreic Warrior" and entity:GetNetVar("tied") != 0 then
				for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
					if v:GetClass() == "cw_salesman" and v:GetNetworkedString("Name") == "Reaver Despoiler" then
						options["Sell Into Slavery"] = "cw_sellSlave";
						
						break;
					end
				end
			elseif entity:IsWanted() and entity:GetNetVar("tied") != 0 then
				for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
					if v:GetClass() == "cw_bounty_board" then
						options["Turn In"] = "cw_turnInBounty";
						
						break;
					end
				end
			end
		elseif (entity:GetClass() == "prop_ragdoll") then
			local player = Clockwork.entity:GetPlayer(entity);

			if player then
				local playerFaction = player:GetNetVar("kinisgerOverride") or player:GetFaction();

				if player:Alive() and (clientFaction == "Hillkeeper" or clientFaction == "Holy Hierarchy") and (entFaction ~= "Hillkeeper" and entFaction ~= "Holy Hierarchy") and player:GetNetVar("tied") != 0 then
					for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
						if v:GetClass() == "cw_salesman" and v:GetNetworkedString("Name") == "The Headsman" then
							options["Sell Into Slavery"] = "cw_sellSlave";
							
							break;
						end
					end
				elseif player:Alive() and clientFaction == "Goreic Warrior" and playerFaction ~= "Goreic Warrior" and player:GetNetVar("tied") != 0 then
					for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
						if v:GetClass() == "cw_salesman" and v:GetNetworkedString("Name") == "Reaver Despoiler" then
							options["Sell Into Slavery"] = "cw_sellSlave";
							
							break;
						end
					end
				elseif player:IsWanted() and player:GetNetVar("tied") != 0 then
					for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
						if v:GetClass() == "cw_bounty_board" then
							options["Turn In"] = "cw_turnInBounty";
							
							break;
						end
					end
				end
			end
				
			if (!player or (player and (!player:Alive() or player:GetMoveType() ~= MOVETYPE_OBSERVER))) then
				local model = entity:GetModel();
				
				if table.HasValue(animalModels, entity:GetModel()) then
					--local activeWeapon = Clockwork.Client:GetActiveWeapon();
					
					--if activeWeapon:IsValid() and activeWeapon.isDagger then
						options["Mutilate"] = "cwCorpseMutilate";
						options["Skin"] = "cwCorpseSkin";
					--else
						--if !self.skinNotificationTimer or self.skinNotificationTimer < curTime then
							--Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You must have a dagger equipped in order to skin or mutilate this animal!");
							
							--self.skinNotificationTimer = curTime + 0.5;
						--end
					--end
				elseif entity:GetNWEntity("Player"):IsPlayer() or entity:GetNWEntity("Player") == game.GetWorld() then
					options["Pillage"] = "cw_corpseLoot";
					
					if entity:GetNWInt("bountyKey") then
						for k, v in pairs(ents.FindInSphere(Clockwork.Client:GetPos(), 512)) do
							if v:GetClass() == "cw_bounty_board" then
								options["Turn In"] = "cw_turnInBounty";
								
								break;
							end
						end
					end
				end
			end;
			
			if IsValid(entity:GetNWEntity("CinderBlock")) then
				options["Untie Rope"] = "cwUntieCinderBlock"
			end
		elseif (entity:GetClass() == "cw_belongings") then
			options["Open"] = "cw_belongingsOpen";
		elseif (entity:GetClass() == "prop_physics") then
			local model = entity:GetModel();
			
			if entity:GetNWBool("BIsCinderBlock") == true then
				options["Untie Rope"] = "cwUntieCinderBlock"
			elseif model == "models/animals/bear.mdl" then
				--local activeWeapon = Clockwork.Client:GetActiveWeapon();
				
				--if activeWeapon:IsValid() and activeWeapon.isDagger then
					options["Mutilate"] = "cwCorpseMutilate";
					options["Skin"] = "cwCorpseSkin";
				--[[else
					if !self.skinNotificationTimer or self.skinNotificationTimer < curTime then
						Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You must have a dagger equipped in order to skin or mutilate this animal!");
						
						self.skinNotificationTimer = curTime + 0.5;
					end
				end]]--
			end
		elseif (entity:GetClass() == "cw_radio") then
			if (!entity:IsCrazy()) then
				if (!entity:IsOff()) then
					options["Turn Off"] = "cw_radioToggle";
				else
					options["Turn On"] = "cw_radioToggle";
				end;
				
				if !entity:IsStatic() or (entity:IsStatic() and Clockwork.Client:IsAdmin()) then
					options["Set Frequency"] = function()
						Derma_StringRequest("Frequency", "What would you like to set the frequency to?", frequency, function(text)
							if ( IsValid(entity) ) then
								Clockwork.entity:ForceMenuOption(entity, "Set Frequency", text);
							end;
						end);
					end;
					
					options["Take"] = "cw_radioTake";
				end
			end;
		elseif (entity.tracks and entity.IsOff) then
			if (!entity:IsOff()) then
				options["Turn Off"] = "cwToggleGramophone";
			else
				options["Turn On"] = "cwToggleGramophone";
			end;
		elseif (entity:GetClass() == "cw_hound_cage_next") then
			options["Examine"] = "cwItemExamine";
			options["Pick Up"] = "cwItemHoundPickup";
		
			if entity:GetNWBool("houndunleashed",0) == 0 then
				options["Attack All"] = "cwHoundCageAttackAll";
				options["Spare Wanderers"] = "cwHoundCageSpareWanderers";
			end
		elseif (entity:GetClass() == "cw_siege_ladder") then
			if entity:GetNWEntity("owner") == Clockwork.Client then
				options["Tear Down"] = "cwTearDownSiegeLadder";
			end
		elseif (entity:GetClass() == "cw_bear_trap") then
			options["Examine"] = "cwItemExamine";
		
			if entity:GetNWString("state") == "trap" then
				if !cwBeliefs or Clockwork.Client:HasBelief("ingenious") then
					options["Reset"] = "cwResetBearTrap";
				end
			else
				if !cwBeliefs or Clockwork.Client:HasBelief("ingenious") then
					options["Set"] = "cwSetBearTrap";
				end
				
				options["Take"] = "cwTakeBearTrap";
			end
		end;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function Schema:PlayerAdjustCharacterScreenInfo(character, info)
	info.clothes = character.clothes;
	info.helmet = character.helmet;
	info.shield = character.shield;
	info.kills = character.kills or 0;
	info.kinisgerOverride = character.kinisgerOverride;
	info.kinisgerOverrideSubfaction = character.kinisgerOverrideSubfaction;
	info.rank = character.rank;
	info.rankOverride = character.rankOverride;
	info.faith = character.faith;
	info.subfaith = character.subfaith;
	info.location = character.location;
end

-- Called when the post progress bar info is needed.
function Schema:GetProgressBarInfoAction(action, percentage)
	if (action == "mutilating") then
		return {text = "You are harvesting meat from a corpse. Click to cancel.", percentage = percentage, flash = percentage > 75};
	elseif (action == "skinning") then
		return {text = "You are skinning an animal's corpse. Click to cancel.", percentage = percentage, flash = percentage > 75};
	elseif (action == "reloading") then
		local weaponName = Clockwork.Client:GetNetVar("cwProgressBarVerb") or "shot";
		local ammoName = Clockwork.Client:GetNetVar("cwProgressBarItem") or "weapon";
		
		return {text = "You are reloading your "..weaponName.." with "..ammoName..". Click to cancel.", percentage = percentage, flash = percentage < 0}
		--return {text = "You are reloading your weapon. Click to cancel.", percentage = percentage, flash = percentage > 75};
	elseif (action == "building") then
		return {text = "You are erecting a siege ladder. Click to cancel.", percentage = percentage, flash = percentage > 75};
	elseif (action == "bloodTest") then
		return {text = "You are testing someone's blood for corruption. Click to cancel.", percentage = percentage, flash = percentage > 75};
	elseif (action == "hell_teleporting") then
		return {text = "You are using dark magic to teleport to Hell. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "filling_bucket") then
		return {text = "You are filling a bucket. Click to cancel.", percentage = percentage, flash = percentage < 10};
	elseif (action == "filling_bottle") then
		return {text = "You are filling a bottle. Click to cancel.", percentage = percentage, flash = percentage < 10};
	end;
end;

function Schema:PlayerCanSeeDateTime()
    return false;
end;

function Schema:GetTargetPlayerName(player)
	if Clockwork.Client:IsAdmin() and Clockwork.player:IsNoClipping(Clockwork.Client) then
		return player:Name();
	end
	
	local subfaction = player:GetSubfaction();

	if subfaction == "Praeventor" or subfaction == "Outrider" then
		local clientFaction = Clockwork.Client:GetFaction();
		
		if clientFaction ~= "Gatekeeper" and clientFaction ~= "Hillkeeper" and clientFaction ~= "Holy Hierarchy" then
			return player:Name(true);
		end
	end
	
	return player:Name()
end

function Schema:OverrideTeamColor(player, bRecognized)
	local clientFaction = Clockwork.Client:GetFaction();
	local playerFaction = player:GetFaction();
	local clothesItem = player:GetClothesEquipped();
	local helmetItem = player:GetHelmetEquipped();
	local teamColor;
	
	if Clockwork.Client:IsAdmin() and Clockwork.player:IsNoClipping(Clockwork.Client) then
		return;
	end

	if bRecognized then
		if playerFaction == "Gatekeeper" and clientFaction ~= "Gatekeeper" and clientFaction ~= "Holy Hierarchy" then
			if player:GetSubfaction() == "Praeventor" then
				if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
					teamColor = Color(200, 200, 200, 255);
				end
			end
		elseif playerFaction == "Hillkeeper" and clientFaction ~= "Hillkeeper" and clientFaction ~= "Holy Hierarchy" then
			if player:GetSubfaction() == "Outrider" then
				if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
					teamColor = Color(200, 200, 200, 255);
				end
			end
		elseif playerFaction == "Children of Satan" and clientFaction ~= "Children of Satan" then
			if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
				local kinisgerOverride = player:GetNetVar("kinisgerOverride");
				
				if kinisgerOverride then
					local classTable = Clockwork.class:GetStored()[kinisgerOverride];
					
					if classTable then
						teamColor = _team.GetColor(classTable.index) or Color(200, 200, 200, 255);
					else
						teamColor = Color(200, 200, 200, 255);
					end
				else
					teamColor = Color(200, 200, 200, 255);
				end
			end
		end
	else
		if playerFaction == "Gatekeeper" and clientFaction ~= "Gatekeeper" and clientFaction ~= "Holy Hierarchy" then
			if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
				teamColor = Color(200, 200, 200, 255);
			end
		elseif playerFaction == "Hillkeeper" and clientFaction ~= "Hillkeeper" and clientFaction ~= "Holy Hierarchy" then
			if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
				teamColor = Color(200, 200, 200, 255);
			end
		elseif playerFaction == "Children of Satan" and clientFaction ~= "Children of Satan" then
			if (!clothesItem or !clothesItem.faction or (clothesItem.faction and clothesItem.faction ~= playerFaction)) and (!helmetItem or !helmetItem.faction or (helmetItem.faction and helmetItem.faction ~= playerFaction)) then
				local kinisgerOverride = player:GetNetVar("kinisgerOverride");
				
				if kinisgerOverride then
					local classTable = Clockwork.class:GetStored()[kinisgerOverride];
					
					if classTable then
						teamColor = _team.GetColor(classTable.index) or Color(200, 200, 200, 255);
					else
						teamColor = Color(200, 200, 200, 255);
					end
				else
					teamColor = Color(200, 200, 200, 255);
				end
			end
		end
	end
	
	return teamColor;
end

-- Called when an entity's target ID HUD should be painted.
function Schema:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		local physDesc = entity:GetNetworkedString("physDesc");
		
		if (physDesc != "") then
			info.y = Clockwork.kernel:DrawInfo(physDesc, info.x, info.y, colorWhite, info.alpha);
		end;
	elseif (entity:IsNPC() or entity:IsNextBot()) then
		local name = entity:GetNetworkedString("cw_Name");
		local title = entity:GetNetworkedString("cw_Title");
		
		if (name != "" and title != "") then
			info.y = Clockwork.kernel:DrawInfo(name, info.x, info.y, Color(255, 255, 100, 255), info.alpha);
			info.y = Clockwork.kernel:DrawInfo(title, info.x, info.y, Color(255, 255, 255, 255), info.alpha);
		end;
	end;
end;

-- Called when the target's status should be drawn.
function Schema:DrawTargetPlayerStatus(target, alpha, x, y)
	local informationColor = Clockwork.option:GetColor("information");
	local thirdPerson = "him";
	local mainStatus;
	local untieText;
	local gender = "He";
	local action = Clockwork.player:GetAction(target);
	
	if (target:GetGender() == GENDER_FEMALE) then
		thirdPerson = "her";
		gender = "She";
	end;
	
	if (target:Alive()) then
		if (action == "die") then
			mainStatus = gender.." is in critical condition and slowly dying.";
		elseif (action == "die_bleedout") then
			mainStatus = gender.." is bleeding out and slowly dying.";
		elseif (target:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
			mainStatus = gender.." is clearly unconscious.";
		end;
		
		if (target:GetNetVar("tied") != 0) then
			if (Clockwork.player:GetAction(Clockwork.Client) == "untie") then
				mainStatus = gender.. " is being untied.";
			else
				local untieText;
				
				if (target:GetShootPos():Distance(Clockwork.Client:GetShootPos()) <= 192) then
					if (Clockwork.Client:GetNetVar("tied") == 0) then
						mainStatus = "Press :+use: to untie "..thirdPerson..".";
						
						untieText = true;
					end;
				end;
				
				if (!untieText) then
					mainStatus = gender.." has been tied up.";
				end;
			end;
		elseif (Clockwork.player:GetAction(Clockwork.Client) == "tie") then
			mainStatus = gender.." is being tied up.";
		end;
		
		if (mainStatus) then
			y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(mainStatus), x, y, informationColor, alpha);
		end;
		
		return y;
	end;
end;

-- Called when the target's subfaction should be drawn.
function Schema:DrawTargetPlayerSubfaction(target, alpha, x, y)
	local playerSubfaction = Clockwork.Client:GetNetVar("kinisgerOverrideSubfaction") or Clockwork.Client:GetNetVar("subfaction");
	local targetSubfaction = target:GetNetVar("kinisgerOverrideSubfaction") or target:GetNetVar("subfaction");
	local subfactionText;

	if(target:GetSharedVar("isThrall")) then return; end
	
	if targetSubfaction and targetSubfaction ~= "" and targetSubfaction ~= "N/A" then
		local playerFaction = Clockwork.Client:GetNetVar("kinisgerOverride") or Clockwork.Client:GetFaction();
		local targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
		local textColor = Color(150, 150, 150, 255);

		if playerFaction == "Goreic Warrior" and targetFaction == "Goreic Warrior" then
			local FACTION = Clockwork.faction:FindByID(playerFaction)
			local SUBFACTION = nil;
			
			if FACTION.subfactions then
				for i = 1, #FACTION.subfactions do
					if FACTION.subfactions[i].name == playerSubfaction then
						SUBFACTION = FACTION.subfactions[i];
						break;
					end
				end
			end
			
			if SUBFACTION and SUBFACTION.rivalry == targetSubfaction then
				subfactionText = "A rival member of "..targetSubfaction..".";
				textColor = Color(255, 0, 0, 255);
			elseif playerSubfaction == targetSubfaction then
				subfactionText = "A fellow member of "..targetSubfaction..".";
				textColor = Color(0, 255, 0, 255);
			else
				subfactionText = "A member of "..targetSubfaction..".";
			end
		-- GetFaction() checks incase they're disguised.
		elseif Clockwork.Client:GetFaction() == "Children of Satan" and target:GetFaction() == "Children of Satan" then
			if target:GetModel() == "models/begotten/satanists/lordvasso/male_56.mdl" then
				subfactionText = "The chosen of Satan, the Dreadlord himself!";
				textColor = Color(0, 255, 0, 255);
			elseif Clockwork.Client:GetNetVar("subfaction") == target:GetNetVar("subfaction") or Clockwork.Client:GetNetVar("subfaction") == "Kinisger" and target:GetNetVar("kinisgerOverrideSubfaction") then
				local brother = "brother";
				
				if target:GetGender() == GENDER_FEMALE then
					brother = "sister";
				end
				
				if target:GetNetVar("kinisgerOverrideSubfaction") then
					subfactionText = "A "..brother.." of the Kinisger bloodline, masquerading as a "..targetSubfaction..".";
				else
					subfactionText = "A "..brother.." of the "..targetSubfaction.." bloodline.";
				end
				
				textColor = Color(0, 255, 0, 255);
			else
				if target:GetNetVar("kinisgerOverrideSubfaction") then
					subfactionText = "A member of the Kinisger bloodline, masquerading as a "..targetSubfaction..".";
				else
					subfactionText = "A member of the "..targetSubfaction.." bloodline.";
				end
			end
		elseif targetFaction ~= "Children of Satan" and targetFaction ~= "Goreic Warrior" then
			if targetSubfaction == "Ministry" then
				if playerSubfaction == targetSubfaction then
					subfactionText = "A fellow minister of the Holy Hierarchy.";
					textColor = Color(0, 255, 0, 255);
				else
					subfactionText = "A minister of the Holy Hierarchy.";
				end
			elseif targetSubfaction == "Low Ministry" then
				local wordstouse = "Clergyman"
				
				if target:GetGender() == GENDER_FEMALE then
					wordstouse = "Clergywoman"
				end

				local brother = "brother";
				
				if target:GetGender() == GENDER_FEMALE then
					brother = "sister";
				end

				if playerSubfaction == targetSubfaction then
					subfactionText = "A fellow " .. brother ..  " of the cloth.";
					textColor = Color(0, 255, 0, 255);

					local nameshield = string.lower(target:GetName())
					local ismaiden = string.find(nameshield, "shieldmaiden")

					if ismaiden == 1 then
						subfactionText = "The Shieldmaiden of the Holy Hierarchy. A fellow sister."
					end
				else
					subfactionText = "A lay " .. wordstouse .. " of the lesser Ministry.";

					local nameshield = string.lower(target:GetName())
					local ismaiden = string.find(nameshield, "shieldmaiden")

					if ismaiden == 1 then
						subfactionText = "The Shieldmaiden of the Holy Hierarchy."
					end
				end
			elseif targetSubfaction == "Inquisition" then
				if playerSubfaction == targetSubfaction then
					subfactionText = "A fellow inquisitor of the Holy Hierarchy.";
					textColor = Color(0, 255, 0, 255);
				else
					subfactionText = "An inquisitor of the Holy Hierarchy.";
				end
			elseif targetSubfaction == "Knights of Sol" then
				if playerSubfaction == targetSubfaction then
					subfactionText = "A fellow knight of the Holy Hierarchy.";
					textColor = Color(0, 255, 0, 255);
				else
					subfactionText = "A knight of the Holy Hierarchy.";
				end
			elseif playerFaction == "Gatekeeper" or playerFaction == "Holy Hierarchy" or playerFaction == "Hillkeeper" then
				if targetSubfaction == "Auxiliary" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow auxiliary of the Holy Order of the Gatekeepers.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "An auxiliary of the Holy Order of the Gatekeepers.";
					end
				elseif targetSubfaction == "Legionary" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow legionary of the Holy Order of the Gatekeepers.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A legionary of the Holy Order of the Gatekeepers.";
					end
				elseif targetSubfaction == "Praeventor" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow praeventor of the Holy Order of the Gatekeepers.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A praeventor of the Holy Order of the Gatekeepers.";
					end
				elseif targetSubfaction == "Watchman" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow watchman of the Hill of Light.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A watchman of the northern Hill of Light.";
					end
				elseif targetSubfaction == "Servus" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow servant of the Hill of Light.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A servant of the northern Hill of Light.";
					end
				elseif targetSubfaction == "Outrider" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow outrider of the Hill of Light.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "An outrider of the northern Hill of Light.";
					end
				end
			elseif playerFaction == "Smog City Pirate" then
				if targetSubfaction == "Voltists" then
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow Smog City Voltist.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A member of the Smog City Voltists.";
					end
				else
					if playerSubfaction == targetSubfaction then
						subfactionText = "A fellow Smog City pirate.";
						textColor = Color(0, 255, 0, 255);
					else
						subfactionText = "A member of the Smog City pirates.";
					end
				end
			elseif playerFaction ~= "Wanderer" and playerFaction == targetFaction then
				if playerSubfaction == targetSubfaction then
					subfactionText = "A fellow member of the "..targetSubfaction..".";
					textColor = Color(0, 255, 0, 255);
				else
					subfactionText = "A member of the "..targetSubfaction..".";
				end
			end
		end
		
		if subfactionText then
			return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(subfactionText), x, y, textColor, alpha);
		end
	end
end

-- Called when the target's subfaction should be drawn.
function Schema:DrawTargetPlayerLevel(target, alpha, x, y)
	local playerFaction = Clockwork.Client:GetFaction();
	local targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();
	local levelText;

	if(target:GetSharedVar("isThrall")) then return; end
	
	if playerFaction == "Children of Satan" and targetFaction ~= "Children of Satan" then
		local level = target:GetNetVar("level", 1)
		local textColor = Color(255, 100, 100, 255);
		
		if level < 10 then
			local thirdPerson = "him"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "her"
			end
			
			levelText = "A fresh little piggy, this one's soul has no power. Sacrificing "..thirdPerson.." would be an affront to the Dark Lord.";
		elseif level >= 10 and level < 20 then
			local thirdPerson = "His"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "Her"
			end

			textColor = Color(200, 150, 150, 255);
			levelText = "A small aura of power surrounds this one. "..thirdPerson.." soul would not be worth much to the Dark Lord.";
		elseif level >= 20 and level < 30 then
			textColor = Color(150, 200, 150, 255);
			levelText = "A ripe soul indeed, this one's soul would be worth much to the Dark Lord.";
		elseif level >= 30 then
			local thirdPerson = "His"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "Her"
			end
		
			textColor = Color(100, 255, 100, 255);
			levelText = "A strong aura of power surrounds this one. "..thirdPerson.." soul would be a splendid treat indeed!";
		end
		
		if levelText then
			return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(levelText), x, y, textColor, alpha);
		end
	--elseif Clockwork.Client:GetNetVar("subfaction") == "Clan Reaver" and targetFaction ~= "Goreic Warrior" then
	elseif playerFaction == "Goreic Warrior" and targetFaction ~= "Goreic Warrior" then
		local level = target:GetNetVar("level", 1)
		local textColor = Color(255, 100, 100, 255);
		
		if level < 10 then
			local thirdPerson = "He"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "She"
			end
			
			levelText = thirdPerson.." does not appear strong and would make for a pathetic slave.";
		elseif level >= 10 and level < 20 then
			local thirdPerson = "His"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "Her"
			end

			textColor = Color(200, 150, 150, 255);
			levelText = "This one is weak and would not sell for much at the slave markets.";
		elseif level >= 20 and level < 30 then
			textColor = Color(150, 200, 150, 255);
			levelText = "Able-bodied, this one would sell for a fair price at the slave markets.";
		elseif level >= 30 then
			local thirdPerson = "He"
			
			if (target:GetGender() == GENDER_FEMALE) then
				thirdPerson = "She"
			end
		
			textColor = Color(100, 255, 100, 255);
			levelText = thirdPerson.." looks very strong and would sell for a high price at the slave markets!";
		end
		
		if levelText then
			return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(levelText), x, y, textColor, alpha);
		end
	end
end

-- Called when the target's sanity level should be drawn.
function Schema:DrawTargetSanityLevel(target, alpha, x, y)
	local targetSanity = target:GetNetVar("sanity", 100)
	local playerHasBelief = Clockwork.Client:HasBelief("blank_stare")

	if(target:GetSharedVar("isThrall")) or !playerHasBelief then return; end
	
	if targetSanity > 90 then
		sanityText = "This one is perfectly sane."
		textColor = Color(255, 0, 0, 255);
	elseif targetSanity <= 90 and targetSanity > 80 then
		sanityText = "This one is slightly unnerved."
		textColor = Color(225, 30, 0, 255);
	elseif targetSanity <= 80 and targetSanity > 70 then
		sanityText = "This one questions their thoughts."
		textColor = Color(195, 60, 0, 255);
	elseif targetSanity <= 70 and targetSanity > 60 then
		sanityText = "This one is quite disturbed."
		textColor = Color(165, 90, 0, 255);
	elseif targetSanity <= 60 and targetSanity > 50 then
		sanityText = "This one frolicks towards insanity."
		textColor = Color(135, 120, 0, 255);
	elseif targetSanity <= 50 and targetSanity > 40 then
		sanityText = "This one is insane."
		textColor = Color(105, 150, 0, 255);
	elseif targetSanity <= 40 and targetSanity > 30 then
		sanityText = "This one is quite mad!"
		textColor = Color(75, 180, 0, 255);
	elseif targetSanity <= 30 and targetSanity > 20 then
		sanityText = "This one is deliciously demented!"
		textColor = Color(45, 210, 0, 255);
	elseif targetSanity <= 20 and targetSanity > 10 then
		sanityText = "This one's mind has ascended!"
		textColor = Color(15, 240, 0, 255);
	elseif targetSanity <= 10 then
		sanityText = "This one dances in the moonlight!"
		textColor = Color(0, 255, 0, 255);
	end
		
	if sanityText then
		return Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(sanityText), x, y, textColor, alpha);
	end
end

-- Called when a player's scoreboard options are needed.
function Schema:GetPlayerScoreboardOptions(player, options, menu)
	--[[if (Clockwork.command:FindByID("CharSetCustomClass")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("CharSetCustomClass").access)) then
			options["Custom Class"] = {};
			options["Custom Class"]["Set"] = function()
				Derma_StringRequest(player:Name(), "What would you like to set their custom class to?", player:GetNetVar("customClass"), function(text)
					Clockwork.kernel:RunCommand("CharSetCustomClass", player:Name(), text);
				end);
			end;
			
			if (player:GetNetVar("customClass")) then
				options["Custom Class"]["Take"] = function()
					Clockwork.kernel:RunCommand("CharTakeCustomClass", player:Name());
				end;
			end;
		end;
	end;]]--
	
	if (Clockwork.command:FindByID("CharPermaKill")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("CharPermaKill").access)) then
			options["Perma-Kill"] = function()
				RunConsoleCommand("aura", "CharPermaKill", player:Name());
			end;
		end;
	end;
	
	if (Clockwork.command:FindByID("CharUnPermaKill")) then
		if (Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:FindByID("CharUnPermaKill").access)) then
			options["Un-Perma-Kill"] = function()
				RunConsoleCommand("aura", "UnCharPermaKill", player:Name());
			end;
		end;
	end;
end;

-- Called when the local player's colorify should be adjusted.
function Schema:PlayerAdjustColorModify(colorModify)
	local frameTime = FrameTime();
	local interval = FrameTime() / 10;
	local curTime = CurTime();
	
	if (!self.colorModify) then
		self.colorModify = {
			brightness = colorModify["$pp_colour_brightness"],
			contrast = colorModify["$pp_colour_contrast"],
			color = colorModify["$pp_colour_colour"]
		};
	end;

	self.colorModify.brightness = math.Approach(self.colorModify.brightness, colorModify["$pp_colour_brightness"], interval);
	self.colorModify.contrast = math.Approach(self.colorModify.contrast, colorModify["$pp_colour_contrast"], interval);
	self.colorModify.color = math.Approach(self.colorModify.color, colorModify["$pp_colour_colour"], interval);

	colorModify["$pp_colour_brightness"] = self.colorModify.brightness;
	colorModify["$pp_colour_contrast"] = self.colorModify.contrast;
	colorModify["$pp_colour_colour"] = self.colorModify.color;
end;

-- Called to get if local player can get the screen text info.
function Schema:CanGetScreenTextInfo()
	if Clockwork.Client.LoadingText then
		return false;
	end
	
	if self.caughtByCheaple then
		return false;
	end
end

-- Called to get the screen text info.
function Schema:GetScreenTextInfo()
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	
	--[[if (Clockwork.Client:GetNetVar("permaKilled")) then
		return {
			alpha = blackFadeAlpha,
			title = "THIS CHARACTER IS PERMANENTLY KILLED",
			text = "Go to the character menu to make a new one."
		};
	else]]if (Clockwork.Client:GetNetVar("beingChloro")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "SOMEBODY IS USING CHLOROFORM ON YOU"
		};
	elseif (Clockwork.Client:GetNetVar("beingTied")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU ARE BEING TIED UP"
		};
	elseif (Clockwork.Client:GetNetVar("tied") != 0) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "YOU HAVE BEEN TIED UP"
		};
	end;
end;

-- Called when the local player's character screen faction is needed.
function Schema:GetPlayerCharacterScreenFaction(character)
	--[[if (character.customClass and character.customClass != "") then
		return character.customClass;
	end;]]--
end;

-- Called when the cinematic intro info is needed.
--[[function Schema:GetCinematicIntroInfo()
	return {
		credits = "Designed and developed by "..self:GetAuthor()..".",
		title = Clockwork.config:Get("intro_text_big"):Get(),
		text = Clockwork.config:Get("intro_text_small"):Get()
	};
end;]]--

function Schema:ModifyStatusEffects(tab)
	if Clockwork.Client:HasTrait("clumsy") then
		table.insert(tab, {text = "(-) Clumsy", color = Color(200, 40, 40)});
	end

	if Clockwork.Client:HasTrait("crosseyed") then
		table.insert(tab, {text = "(-) Cross Eyed", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("followed") then
		table.insert(tab, {text = "(-) Followed", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("gluttony") then
		table.insert(tab, {text = "(-) Gluttonous", color = Color(200, 40, 40)});
	end

	if Clockwork.Client:HasTrait("imbecile") then
		table.insert(tab, {text = "(-) Imbecile", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("marked") then
		table.insert(tab, {text = "(-) Marked", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("pacifist") then
		table.insert(tab, {text = "(-) Pacifist", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("possessed") then
		table.insert(tab, {text = "(-) Possessed", color = Color(200, 40, 40)});
	end
	
	if Clockwork.Client:HasTrait("scavenger") then
		table.insert(tab, {text = "(+) Scavenger", color = Color(0, 225, 0)});
	end
	
	if Clockwork.Client:HasTrait("winded") then
		table.insert(tab, {text = "(-) Winded", color = Color(200, 40, 40)});
	end
end

function Schema:GetAdminESPInfo(info)
	if (Clockwork.ConVars.NPCSPAWNESP and Clockwork.ConVars.NPCSPAWNESP:GetInt() == 1) then
		if (self.npcSpawns) then
			if (table.IsEmpty(self.npcSpawns)) then
				self.npcSpawns = nil;
				
				return;
			end;
			
			for k, v in pairs (self.npcSpawns) do
				for i, v2 in ipairs(v) do
					if (!v2 or !isvector(v2.pos)) then
						self.npcSpawns[k][i] = nil;
						
						continue;
					end;

					info[#info + 1] = {
						position = v2.pos,
						text = k;
						color = Color(255, 150, 150);
					};
				end
			end;
		end;
	end;
end

-- Called when a text entry has gotten focus.
function Schema:OnTextEntryGetFocus(panel)
	self.textEntryFocused = panel;
end;

-- Called when a text entry has lost focus.
function Schema:OnTextEntryLoseFocus(panel)
	self.textEntryFocused = nil;
end;

-- Called when the top screen HUD should be painted.
function Schema:HUDPaintTopScreen(info) end;

-- Called when the player info text is needed.
function Schema:GetPlayerInfoText(playerInfoText) end;

-- Called to check if a player does have an flag.
function Schema:PlayerDoesHaveFlag(player, flag) end;

-- Called to check if a player does recognise another player.
function Schema:PlayerDoesRecognisePlayer(target, status, isAccurate, realValue)
	local playerFaction = Clockwork.Client:GetNetVar("kinisgerOverride") or Clockwork.Client:GetFaction();
	local targetFaction = target:GetNetVar("kinisgerOverride") or target:GetFaction();

	if targetFaction == "Holy Hierarchy" then
		return true;
	elseif targetFaction == "Gatekeeper" or targetFaction == "Pope Adyssa's Gatekeepers" or targetFaction == "Hillkeeper" then
		if playerFaction == "Gatekeeper" or playerFaction == "Pope Adyssa's Gatekeepers" or playerFaction == "Hillkeeper" or playerFaction == "Holy Hierarchy" then
			return true;
		end
	elseif targetFaction == "Goreic Warrior" and playerFaction == "Goreic Warrior" then
		return true;
	elseif targetFaction == "Smog City Pirate" and playerFaction == "Smog City Pirate" then
		return true;
	elseif targetFaction == "The Third Inquisition" and playerFaction == "The Third Inquisition" then
		return true;
	-- GetFaction() checks incase they're disguised.
	elseif target:GetFaction() == "Children of Satan" and Clockwork.Client:GetFaction() == "Children of Satan" then
		return true;
	end
end;

-- Called each tick.
function Schema:Tick()
	local curTime = CurTime();
	
	-- This should stop people from loweirng their FPS to make lockpicking easier, at least w/o external programs.
	if !self.nextFPSCheck or curTime >= self.nextFPSCheck then
		self.nextFPSCheck = curTime + 0.05;
		
		--RunConsoleCommand("fps_max", "300");
		RunConsoleCommand("hud_draw_fixed_reticle", "0");
		RunConsoleCommand("mat_motion_blur_enabled", "1");
	end
	
	RunConsoleCommand("r_3dsky", "1");
	RunConsoleCommand("r_pixelfog", "1");
	RunConsoleCommand("mat_monitorgamma_tv_enabled", "0");

	-- Something is fucked with our SWEPs that is causing clientside models to build up and tank FPS.
	if !self.nextClientsideModelCheck or curTime >= self.nextClientsideModelCheck then
		self.nextClientsideModelCheck = curTime + 10;

		if Clockwork.character:IsPanelOpen() then
			return;
		end
		
		-- dunno why this check is needed but it apparently is
		if IsValid(Clockwork.Client) and Clockwork.Client.GetNW2Bool then
			if Clockwork.Client:GetNW2Bool("pac_in_editor") then
				return;
			end
		end
		
		for k, v in pairs(ents.GetAll()) do
			if string.find(v:GetClass(), "class C_BaseFlex") and v:GetModel() then
				if v:GetPos() == Vector(0, 0, 0) then
					if v:GetModel() == Clockwork.Client:GetModel() or v.noDelete then
						continue;
					end
					
					v:Remove();
				end
			end
		end
		
		--[[if IsValid(Clockwork.inventory.panel) then
			if Clockwork.inventory.panel:IsVisible() then
				Clockwork.inventory.panel:Rebuild();
			end
		end]]--
	end
	
	if self.crows then
		local position = Clockwork.Client:GetPos();
		local trace = {};
			trace.start = Clockwork.Client:GetPos();
			trace.endpos = trace.start + Vector(0, 0, 100000);
			trace.filter = {Clockwork.Client};
		local traceLine = util.TraceLine(trace);
		local soundPlayed = false;

		if (!traceLine.HitSky) then
			for k, v in pairs(self.crows) do
				if (IsValid(v)) then
					v:Remove();
					self.crows[k] = nil;
				end;
			end;
		else
			for k, v in pairs(self.crows) do 
				if (IsValid(v)) then 
					local pitchCheck = v:GetAngles().pitch < 10
					
					if ((v.nextFly or 0) < curTime and pitchCheck) then
						v.nextFly = curTime + math.Rand(0.2, 0.3);
						v:ResetSequence(0);
					end;
					
					local crowPosition = v:GetPos();
					crowPosition.z = position.z;
					
					local forward = v:GetPos() + v:GetForward();
					forward.z = math.Clamp(forward.z, v.position.z - 500, v.position.z + 200);
					
					v:SetPos(forward);
					
					local newPosition = (forward.z < v.position.z - 400);
					local forward = (newPosition and 0 or 6);
					local newAngle = v:GetAngles() + Angle(math.Rand(-30, forward), math.Rand(-10, 10), 0);
					
					if (math.random(1, 10) == 2) then 
						v.angle = newAngle;
					end;
					
					local angle = v.angle or newAngle;
					v.newAngle = v.newAngle or angle;
					local frameTime = FrameTime();
					
					v.newAngle.p = math.Approach(v.newAngle.p, angle.p, frameTime * 164);
					v.newAngle.y = math.Approach(v.newAngle.y, angle.y, frameTime * 34);
					
					local finalAngle = v.newAngle or angle;
					finalAngle.pitch = math.Clamp(finalAngle.pitch, -20, 20);
					
					v:SetAngles(finalAngle);
					
					if not soundPlayed then
						if math.random(1, 1000) == 1 then
							soundPlayed = true;

							v:EmitSound("crow"..math.random(3, 4)..".wav", math.random(20, 30));
						end
					end;
					
					if ((crowPosition - position):Length() > 2000) then
						v:Remove();
						self.crows[k] = nil;
					end;
				else
					self.crows[k] = nil;
				end;
			end;
		end;
		
		if table.IsEmpty(self.crows) then
			self.crows = nil;
		end
	end;
end;

function Schema:PlayerCanSeeCommand(commandTable)
	if commandTable.faith then
		local faith = Clockwork.Client:GetNetVar("faith");
		
		if istable(commandTable.faith) and !table.HasValue(commandTable.faith, faith) then
			return false;
		elseif isstring(commandTable.faith) and commandTable.faith ~= faith then
			return false;
		end
	end
	
	if commandTable.subfaith then
		local subfaith = Clockwork.Client:GetNetVar("subfaith");
		
		if istable(commandTable.subfaith) and !table.HasValue(commandTable.subfaith, subfaith) then
			return false;
		elseif isstring(commandTable.subfaith) and commandTable.subfaith ~= subfaith then
			return false;
		end
	end
end

-- Called when the local player attempts to see a class.
function Schema:PlayerCanSeeClass(class) end;

-- Called when the local player's motion blurs should be adjusted.
function Schema:PlayerAdjustMotionBlurs(motionBlurs) end;

-- Called when the scoreboard's class players should be sorted.
function Schema:ScoreboardSortClassPlayers(class, a, b) end;

-- Called when a player's scoreboard class is needed.
function Schema:GetPlayerScoreboardClass(player) end;

-- Called when the target player's fade distance is needed.
function Schema:GetTargetPlayerFadeDistance(player) end;

-- Called when the scoreboard's player info should be adjusted.
function Schema:ScoreboardAdjustPlayerInfo(info) end;

-- Called when the local player's class model info should be adjusted.
function Schema:PlayerAdjustClassModelInfo(class, info) end;

-- Called when the chat box info should be adjusted.
function Schema:ChatBoxAdjustInfo(info) end;

-- Called when a Clockwork ConVar has changed.
function Schema:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "cwWakeupSequence" and newValue) then
		if newValue == "0" then
			if Clockwork.Client.LoadingText then
				self:FinishWakeupSequence();
			end
		end
	end
end

-- Called to get whether the local player's character screen is visible.
function Schema:GetPlayerCharacterScreenVisible()
	if Schema.contentVerified ~= "verified" then
		return false;
	end
end

function Schema:CanShowTabMenu()
	if self.caughtByCheaple then
		return false;
	end
	
	if (Clockwork.Client:HasInitialized() and !Clockwork.Client:Alive()) then
		return false;
	end;
end

-- Called when the scoreboard should be shown.
function Schema:ScoreboardShow()
	if (Clockwork.Client:HasInitialized() and !Clockwork.Client:Alive()) then
		Clockwork.character:SetPanelOpen(true);
	end;
end;

function Schema:PlayerCanSeeBars(class)
	if self.caughtByCheaple then
		return false
	end
end

function Schema:CanPaintChatbox()
	if self.caughtByCheaple then
		return false;
	end;
end;

local noDisplayClasses = {
	"dwf",
	"dw ",
	"dwd",
	"dar",
	"rav",
	"rs ",
	"rsc",
	"rsf",
	"rel",
	"re ",
	"adm",
	"ad ",
	"su ",
	"op ",
};

function Schema:ShouldNotDisplayTyping(text)
	local prefix = config.Get("command_prefix"):Get()
	
	if string.sub(text, 1, 1) == prefix then
		local stringsub = string.sub(text, 2, 4);
		
		if table.HasValue(noDisplayClasses, stringsub) then
			return false;
		end
	end
end

-- Called to get whether the character menu should be created.
function Schema:ShouldCharacterMenuBeCreated()
	if Schema.contentVerified ~= "verified" then
		if Schema.contentVerified == "unverified" then
			for i = 1, #requiredWorkshopAddons do
				local addon = requiredWorkshopAddons[i];
			
				if !steamworks.IsSubscribed(addon) or !steamworks.ShouldMountAddon(addon) then
					local contentPanel = vgui.Create("cwContentNotification");
					
					contentPanel.missingWorkshop = true;
					contentPanel:Rebuild();
					
					Schema.contentVerified = "missing";
					
					return false;
				end
			end
			
			for k, v in pairs(Schema.requiredMounts) do
				if !IsMounted(k) then
					local contentPanel = vgui.Create("cwContentNotification");
					
					contentPanel:Rebuild();
					
					Schema.contentVerified = "missing";
					
					return false;
				end
			end
			
			Schema.contentVerified = "verified";
		end
	
		return false;
	end
end

-- A function to modify an item's markup tooltip.
function Schema:ModifyItemMarkupTooltip(category, maximumWeight, weight, condition, percentage, name, itemTable, x, y, width, height, frame, bShowWeight)
	if (category == "Melee") then
		local damageTypes = {[2] = "Bullet", [4] = "Slash", [16] = "Pierce", [128] = "Blunt"};
		local meleeMax = GetTable("meleemax");
		local meleeMin = GetTable("meleemin");
		local weaponClass = itemTable.uniqueID;
		local weaponStats = {["attack"] = nil, ["defense"] = nil};
		local weaponTable;
		
		if weaponClass then
			weaponTable = _G.weapons.Get(weaponClass);
			
			if weaponTable then
				category = weaponTable.Category or "Melee";
			end
		end
		
		if string.find(category, "(Begotten)") then
			category = string.sub(category, 12)
		end
		
		if category == "Fisted" then
			category = "Fisted Weapon";
		end
		
		if category == "Sacrificial" then
			category = "Sacrificial Weapon";
		end
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end
		
		if itemTable.requiredbeliefs and #itemTable.requiredbeliefs > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.requiredbeliefs do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.requiredbeliefs[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.requiredbeliefs[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if itemTable.onerequiredbelief and #itemTable.onerequiredbelief > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.onerequiredbelief do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.onerequiredbelief[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.onerequiredbelief[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs (One Of The Following): ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end

		if weaponTable then
			if weaponTable.AttackTable then
				weaponStats["attack"] = GetTable(weaponTable.AttackTable);
			end
			
			if weaponTable.BlockTable then
				weaponStats["defense"] = GetTable(weaponTable.BlockTable);
			end
			
			if weaponStats["attack"] and weaponStats["defense"] then
				frame:AddText("Weapon Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);

				if weaponStats["attack"].canaltattack then
					if weaponTable.CanSwipeAttack then
						frame:AddText("Alternate Attack: Swipe", Color(110, 30, 30), nil, 0.9);
					else
						frame:AddText("Alternate Attack: Thrust", Color(110, 30, 30), nil, 0.9);
					end
				end
				
				--[[if weaponStats["defense"].blockdamagetypes then
					local blockDamageTypes = "";
					
					for i = 1, #weaponStats["defense"].blockdamagetypes do
						local blockDamageType = weaponStats["defense"].blockdamagetypes[i];
						
						blockDamageTypes = blockDamageTypes..damageTypes[blockDamageType];
						
						if i < #weaponStats["defense"].blockdamagetypes then
							blockDamageTypes = blockDamageTypes..", ";
						end
					end
					
					if blockDamageTypes ~= "" then
						frame:AddText("Blocks Damage Types: "..blockDamageTypes, Color(110, 30, 30), nil, 0.9);
					end
				end]]--
			
				--[[if weaponStats["defense"].canparry then
					frame:AddText("Can Parry", Color(110, 30, 30), nil, 0.9);
				end]]--
				
				if itemTable.canUseShields then
					frame:AddText("Can Use Shields", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.isSacrifical then
					frame:AddText("Causes Corruption To Wielder", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.isPolearm then
					frame:AddText("Polearm: Up to +70% increased damage the further away the target is.", Color(110, 30, 30), nil, 0.9);
				end
				
				if weaponTable.hasSwordplay then
					frame:AddText("Swordplay: After deflecting or parrying an opponent, your next attack within 0.5s will have a faster striketime. This trait only works if you have 'Blademaster' unlocked.", Color(110, 30, 30), nil, 0.9);
				end
				
				if weaponTable.MultiHit then
					frame:AddText("Multi-Hit: Can hit up to "..tostring(weaponTable.MultiHit).." targets in a single swing.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.hasMinimumRange then
					frame:AddText("Minimum Effective Range: Targets under 50% of your max range will receive ineffective non-lethal damage.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.hasIncreasedDeflectionWindow then
					frame:AddText("Increased deflection window (0.25s)", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.huntingValue == 3 then
					frame:AddText("Hunting Dagger: Skinning and mutilating corpses gives higher quality yields and is much faster.", Color(110, 30, 30), nil, 0.9);
				end

				if weaponStats["defense"].parrydifficulty and weaponStats["defense"].parrydifficulty > 0.2 then
					frame:AddText("Has Increased Parry Window", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.unrepairable then
					frame:AddText("Unrepairable: This weapon cannot be repaired and will always take condition damage, irrespective of beliefs.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.attributes then
					if table.HasValue(itemTable.attributes, "aoebuff") then
						frame:AddText("Area of Effect Buff: +15% Attack Damage, -25% Received Damage, 1.5x Stamina Regen Rate, +2 Residual Sanity Gain, Immunity to Warcry Sanity & Disorientation Debuffs", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "concealable") then
						frame:AddText("Concealable (Does Not Show On Person)", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "conditionless") then
						frame:AddText("Conditionless: This item will not take condition damage.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "fear") then
						frame:AddText("Fear: Characters of opposing factions will be disoriented and lose sanity when near you.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "ice") then
						frame:AddText("Frigid: Freezes enemies in a block of ice upon contact.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "grounded") then
						frame:AddText("Grounded: Cannot attack while sprinting, but hitting enemies in effective range will discombobulate them, stopping them from sprinting for the next 3 seconds.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "fire") then
						frame:AddText("Incendiary: Sets enemies alight upon contact.", Color(110, 30, 30), nil, 0.9);
					end

					if table.HasValue(itemTable.attributes, "flail") then
						frame:AddText("Cannot Be Dual Wielded", Color(110, 30, 30), nil, 0.9);
						frame:AddText("Punisher: Doubles the stamina gained from flagellation.", Color(110, 30, 30), nil, 0.9);
						frame:AddText("Trust in God: With each strike, there is a 10% chance you will deal an overhead attack that deals +70% raw, stability and stamina damage. The 'Favored' belief raises this chance to 20%.", Color(110, 30, 30), nil, 0.9);
						frame:AddText("Foolhardy: With each miss, there is a 25% chance that you will strike yourself for half damage. The 'Favored' belief lowers this chance to 10%.", Color(110, 30, 30), nil, 0.9);
					end

					if table.HasValue(itemTable.attributes, "versatile") then
						frame:AddText("Versatile: Efficient in both mining and woodcutting, and suffers no condition loss from harvesting these nodes.", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "lifeleech") then
						frame:AddText("Lifeleech (Shieldless): 50% of damage dealt is returned as health.", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "rage") then
						frame:AddText("Rage (Shieldless): Movement speed is increased by 7%.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "shieldbreaker") then
						frame:AddText("Shieldbreaker: Deals extra condition damage to shields.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "bell") then
						frame:AddText("For Whom the Bell Tolls: Disorients any characters nearby with each holy strike.", Color(110, 30, 30), nil, 0.9);
					end
				end
			
				if weaponStats["attack"].dmgtype then
					frame:AddText("Damage Type: "..damageTypes[weaponStats["attack"].dmgtype] or "Unknown", Color(110, 30, 30), nil, 0.9);
				end
				
				if weaponStats["defense"].partialbulletblock then
					frame:AddText("Has Bullet Resistance", Color(110, 30, 30), nil, 0.9);
				end
				
				if string.find(weaponClass, "begotten_spear") or string.find(weaponClass, "begotten_polearm") or string.find(weaponClass, "begotten_scythe") then
					frame:AddText("Has Counter Damage: +40% Damage Bonus against running enemies when attacked from the front.", Color(110, 30, 30), nil, 0.9);
				elseif weaponTable.isDagger then
					frame:AddText("Has Backstab: Deal double damage and 100% AP damage to enemies' backs.", Color(110, 30, 30), nil, 0.9);
					frame:AddText("Has Coup de Grace: Deal double damage and 100% AP damage to knocked over enemies. Each hit will slightly increase the time it takes for knocked over enemies to get up.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.requireFaction and not table.IsEmpty(itemTable.requireFaction) and itemTable.requireFaction[1] ~= "Wanderer" then
					frame:AddText("Required Faction: "..table.concat(itemTable.requireFaction, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.requireFaith and not table.IsEmpty(itemTable.requireFaith) then
					frame:AddText("Required Faith: "..table.concat(itemTable.requireFaith, " or "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.requireSubfaction and not table.IsEmpty(itemTable.requireSubfaction) then
					frame:AddText("Required Subfaction: "..table.concat(itemTable.requireSubfaction, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.excludeFactions and not table.IsEmpty(itemTable.excludeFactions) then
					frame:AddText("Excluded Factions: "..table.concat(itemTable.excludeFactions, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if Clockwork.Client:GetFaction() == "Goreic Warrior" and itemTable.excludeSubfactions and not table.IsEmpty(itemTable.excludeSubfactions) then
					frame:AddText("Excluded Subfactions: "..table.concat(itemTable.excludeSubfactions, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				frame:AddText("Weapon Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				if weaponStats["attack"].takeammo then
					local percentage = math.min(weaponStats["attack"].takeammo / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Attack Cost", Color(110, 30, 30), nil, 1);
						frame:AddText("The cost of each melee attack in stamina consumed. Can be affected by modifiers such as injuries or beliefs.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].takeammo).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Attack Cost", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].delay then
					local max_value = meleeMax.delay;
					local min_value = meleeMin.delay;
					local percentage = 1 - ((weaponStats["attack"].delay - min_value) / (max_value - min_value));
					local toolTip = function(frame)
						frame:AddText("Attack Delay", Color(110, 30, 30), nil, 1);
						frame:AddText("The delay before starting another attack after swinging.", Color(225, 200, 200), nil, 0.8);
					end
				
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].delay).."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Attack Delay", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].striketime then
					local max_value = meleeMax.striketime;
					local min_value = meleeMin.striketime;
					local percentage = 1 - ((weaponStats["attack"].striketime - min_value) / (max_value - min_value));
					local toolTip = function(frame)
						frame:AddText("Swing Speed", Color(110, 30, 30), nil, 1);
						frame:AddText("The delay before your swing connects with any potential foes.", Color(225, 200, 200), nil, 0.8);
					end
				
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].striketime).."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Swing Speed", Color(110, 30, 30), toolTip, true);
				end
			
				--[[if weaponStats["attack"].delay and weaponStats["attack"].striketime then
					local min_value = 0.75;
					local max_value = 3.5;
					local attack_speed = weaponStats["attack"].delay + weaponStats["attack"].striketime;
					local percentage = 1 - ((attack_speed - min_value) / (max_value - min_value));

					frame:AddBar(12, {{text = tostring(weaponStats["attack"].delay + weaponStats["attack"].striketime).."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Attack Speed", Color(110, 30, 30), toolTip, true);
				end]]--
			
				if weaponStats["attack"].armorpiercing then
					local armorpiercing = weaponStats["attack"].armorpiercing;
					local damagetype = weaponStats["attack"].dmgtype;
					local originalAP = armorpiercing;
					
					if armorpiercing then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.7, 1));
						else
							armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.5, 1));
						end
					
						local percentage = math.min(armorpiercing / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Armor-Piercing Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("Armor piercing damage reflects your weapon's ability to pierce the armor of your foes. Higher values mean that less of your weapon's primary damage will be negated by their armor.", Color(225, 200, 200), nil, 0.8);
						end
			
						if armorpiercing < originalAP then
							frame:AddBar(12, {{text = tostring(armorpiercing).." / "..tostring(originalAP), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(armorpiercing), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
			
				if weaponStats["attack"].primarydamage and !weaponTable.isJavelin then
					local damage = weaponStats["attack"].primarydamage;
					local damagetype = weaponStats["attack"].dmgtype;
					local originalDamage = damage;
					
					if damage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							damage = math.Round(damage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							damage = math.Round(damage * Lerp(scalar, 0.4, 1));
						else
							damage = math.Round(damage * Lerp(scalar, 0.5, 1));
						end

						local percentage = math.min(damage / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Primary Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's health that your weapon does. Can be negated by armor proportional to your weapon's armor-piercing damage value.", Color(225, 200, 200), nil, 0.8);
						end
			
						if damage < originalDamage then
							frame:AddBar(12, {{text = tostring(damage).." / "..tostring(originalDamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Primary Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(damage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Primary Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponStats["attack"].stabilitydamage then
					local percentage = math.min(weaponStats["attack"].stabilitydamage / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Stability Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage to your foe's stability that your weapon does. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].stabilitydamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].poisedamage then
					local percentage = math.min(weaponStats["attack"].poisedamage / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Stamina Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage to your foe's stamina that your weapon does. Dealing stamina damage will reduce an enemy's staying power in a fight or their ability to flee. Can be negated by enemy shields, though stamina damage is combined with primary damage to deal condition damage to shields or blocking weapons.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].poisedamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stamina Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].meleearc then
					local percentage = math.min(weaponStats["attack"].meleearc / 60, 60);
					local toolTip = function(frame)
						frame:AddText("Weapon Arc", Color(110, 30, 30), nil, 1);
						frame:AddText("Your weapon arc determines how wide of a swing your attacks have. Caution should be exercised with weapons that have a large arc, as friendlies may unintentionally be hit.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].meleearc).."°", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Weapon Arc", Color(110, 30, 30), toolTip, true);
				end

				if weaponStats["attack"].meleerange then
					local percentage = math.min((weaponStats["attack"].meleerange - 425) / (1500 - 425), (1500 - 425));
					local toolTip = function(frame)
						frame:AddText("Melee Range", Color(110, 30, 30), nil, 1);
						frame:AddText("The melee range of your weapon determines how far you can strike. Some weapons such as polearms and spears have varied damage based on how far you are from a struck enemy as well.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].meleerange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Weapon Range", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].canaltattack then
					--frame:AddSpacer(4, Color(40, 40, 40, 120));
					
					if weaponStats["attack"].alttakeammo then
						local percentage = math.min(weaponStats["attack"].alttakeammo / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Cost", Color(110, 30, 30), nil, 1);
							frame:AddText("The cost of each of the alternate stance's melee attack in stamina consumed. Can be affected by modifiers such as injuries or beliefs.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].alttakeammo).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Cost", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["attack"].altarmorpiercing then
						local armorpiercing = weaponStats["attack"].altarmorpiercing;
						local damagetype;
						local originalAP = armorpiercing;
						
						if weaponTable.CanSwipeAttack then
							damagetype = DMG_CLUB;
						else
							damagetype = DMG_VEHICLE;
						end
						
						if armorpiercing then
							local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
						
							if damagetype == DMG_CLUB then
								armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.7, 1));
							else
								armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.5, 1));
							end
					
							local percentage = math.min(armorpiercing / 100, 100);
							local toolTip = function(frame)
								frame:AddText("Alternate Armor-Piercing Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("Armor piercing damage reflects your weapon's alternate attack's ability to pierce the armor of your foes. Higher values mean that less of your weapon's primary damage will be negated by their armor.", Color(225, 200, 200), nil, 0.8);
							end
				
							if armorpiercing < originalAP then
								frame:AddBar(12, {{text = tostring(armorpiercing).." / "..tostring(originalAP), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(armorpiercing), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
							end
						end
					end
				
					if weaponStats["attack"].primarydamage and weaponStats["attack"].altattackdamagemodifier then
						local damage = weaponStats["attack"].primarydamage;
						local damagetype;
						local originalDamage = damage;
						
						if weaponTable.CanSwipeAttack then
							damagetype = DMG_CLUB;
						else
							damagetype = DMG_VEHICLE;
						end
						
						if damage then
							local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
						
							if damagetype == DMG_CLUB then
								damage = math.Round(damage * Lerp(scalar, 0.75, 1));
							elseif damagetype == DMG_VEHICLE then
								damage = math.Round(damage * Lerp(scalar, 0.5, 1));
							end
					
							local percentage = math.min((damage / 100) * weaponStats["attack"].altattackdamagemodifier, 100);
							local toolTip = function(frame)
								frame:AddText("Alternate Attack Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("The damage to your foe's health that your weapon's alternate attack does. Can be negated by armor proportional to your weapon's armor-piercing damage value.", Color(225, 200, 200), nil, 0.8);
							end
				
							if damage < originalDamage then
								frame:AddBar(12, {{text = tostring(math.Round(damage * weaponStats["attack"].altattackdamagemodifier)).." / "..tostring(math.Round(originalDamage * weaponStats["attack"].altattackdamagemodifier)), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(math.Round(damage * weaponStats["attack"].altattackdamagemodifier)), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
							end
						end
					end
					
					if weaponStats["attack"].stabilitydamage and weaponStats["attack"].altattackstabilitydamagemodifier then
						local percentage = math.min((weaponStats["attack"].stabilitydamage / 100) * weaponStats["attack"].altattackstabilitydamagemodifier, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Stability Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's stability that your weapon's alternate attack does. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].stabilitydamage * weaponStats["attack"].altattackstabilitydamagemodifier), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Stability Damage", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["attack"].poisedamage and weaponStats["attack"].altattackpoisedamagemodifier then
						local percentage = math.min((weaponStats["attack"].poisedamage / 100) * weaponStats["attack"].altattackpoisedamagemodifier, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Stamina Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's stamina that your weapon's alternate attack does. Dealing stamina damage will reduce an enemy's staying power in a fight or their ability to flee. Can be negated by enemy shields.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].poisedamage * weaponStats["attack"].altattackpoisedamagemodifier), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Stamina Damage", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["attack"].altmeleearc then
						local percentage = math.min(weaponStats["attack"].altmeleearc / 60, 60);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Weapon Arc", Color(110, 30, 30), nil, 1);
							frame:AddText("Your alternate attack weapon arc determines how wide of a swing your alternate attacks have. Caution should be exercised with weapons that have a large arc, as friendlies may unintentionally be hit.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].altmeleearc).."°", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Weapon Arc", Color(110, 30, 30), toolTip, true);
					end

					if weaponStats["attack"].meleerange then
						local newRange = weaponStats["attack"].meleerange;
						
						if weaponStats["attack"].altmeleerange then
							newRange = weaponStats["attack"].altmeleerange;
						--[[else
							if weaponTable.CanSwipeAttack then
								newRange = math.Round(newRange * 0.8);
							else
								newRange = math.Round(newRange * 1.2);
							end]]--
						end
						
						if newRange ~= weaponStats["attack"].meleerange then
							local percentage = math.min((newRange - 425) / (1500 - 425), (1500 - 425));
							local toolTip = function(frame)
								frame:AddText("Alternate Attack Melee Range", Color(110, 30, 30), nil, 1);
								frame:AddText("The melee range of your weapon's alternate attack determines how far you can strike when in an alternate stance. Some weapons such as polearms and spears have varied damage based on how far you are from a struck enemy as well.", Color(225, 200, 200), nil, 0.8);
							end
			
							frame:AddBar(12, {{text = tostring(newRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Weapon Range", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponStats["defense"].blockcone then
					local percentage = math.min(weaponStats["defense"].blockcone / 270, 270);
					local toolTip = function(frame)
						frame:AddText("Block Cone", Color(110, 30, 30), nil, 1);
						frame:AddText("The block cone of your weapon or shield determines at what angles blocking is effective, when facing toward a foe.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(weaponStats["defense"].blockcone).."°", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", noDisplay = true}}, "Block Cone", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["defense"].guardblockamount then
					local percentage = math.min(weaponStats["defense"].guardblockamount / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Block Cost (Minimum)", Color(110, 30, 30), nil, 1);
						frame:AddText("The minimum block cost of your weapon or shield in stamina if an attack by an enemy foe causes any stamina damage at all.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(weaponStats["defense"].guardblockamount).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Block Cost (Minimum)", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["defense"].poiseresistance then
					local percentage = math.min(weaponStats["defense"].poiseresistance / 50, 50);
					local toolTip = function(frame)
						frame:AddText("Block Stamina Damage Resistance", Color(110, 30, 30), nil, 1);
						frame:AddText("The resistance of your weapon or shield to additional stamina damage beyond the minimum cost while blocking.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(weaponStats["defense"].poiseresistance).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Block Stamina Damage Resistance", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["defense"].canparry then
					if weaponStats["defense"].parrytakestamina then
						local percentage = math.min(weaponStats["defense"].parrytakestamina / 40, 40);
						local toolTip = function(frame)
							frame:AddText("Parry Cost", Color(110, 30, 30), nil, 1);
							frame:AddText("The stamina cost of attempting a parry. Successfully parrying a foe will refund half of this cost.", Color(225, 200, 200), nil, 0.8);
						end

						frame:AddBar(12, {{text = tostring(weaponStats["defense"].parrytakestamina).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Parry Cost", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["defense"].parrydifficulty then
						local percentage = math.Clamp(weaponStats["defense"].parrydifficulty / 0.3, 0, 1);
						local toolTip = function(frame)
							frame:AddText("Parry Window", Color(110, 30, 30), nil, 1);
							frame:AddText("The time in seconds after parrying that your parry will be active. Higher values mean that parrying will be easier as the window will be larger.", Color(225, 200, 200), nil, 0.8);
						end

						frame:AddBar(12, {{text = tostring(weaponStats["defense"].parrydifficulty).."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Parry Window", Color(110, 30, 30), toolTip, true);
					end
				end
			end
		end
		
		return true;
	elseif (category == "Throwables") then
		local damageTypes = {[2] = "Bullet", [4] = "Slash", [16] = "Pierce", [128] = "Blunt", [1073741824] = "Pierce"};
		local weaponClass = itemTable.uniqueID;
		local weaponStats = {["attack"] = nil, ["defense"] = nil};
		local weaponTable;

		if weaponClass then
			weaponTable = _G.weapons.Get(weaponClass);
			category = weaponTable.Category;
		end
		
		if string.find(category, "(Begotten)") then
			category = string.sub(category, 12)
		end
		
		if category == "Throwables" then
			category = "Throwable";
		end
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end
		
		if itemTable.requiredbeliefs and #itemTable.requiredbeliefs > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.requiredbeliefs do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.requiredbeliefs[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.requiredbeliefs[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if itemTable.onerequiredbelief and #itemTable.onerequiredbelief > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.onerequiredbelief do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.onerequiredbelief[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.onerequiredbelief[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs (One Of The Following): ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end

		if weaponTable then
			if weaponTable.AttackTable then
				weaponStats["attack"] = GetTable(weaponTable.AttackTable);
			end
			
			if weaponTable.BlockTable then
				weaponStats["defense"] = GetTable(weaponTable.BlockTable);
			end
			
			if weaponStats["attack"] and weaponStats["defense"] then
				frame:AddText("Weapon Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				frame:AddText("Easily Repairable: Costs less melee repair kit condition to repair.", Color(110, 30, 30), nil, 0.9);
				frame:AddText("Ranged Weapon: You will be disarmed upon taking damage with this weapon.", Color(110, 30, 30), nil, 0.9);
				frame:AddText("Variable Damage: Damage will be increased or decreased depending on the distance of the target. Targets further away will receive more damage.", Color(110, 30, 30), nil, 0.9);
				
				if !weaponStats["defense"].candeflect then
					frame:AddText("Cannot Deflect", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.isSacrifical then
					frame:AddText("Causes Corruption To Wielder", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.attributes then
					if table.HasValue(itemTable.attributes, "concealable") then
						frame:AddText("Concealable (Does Not Show On Person)", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "ice") then
						frame:AddText("Frigid: Freezes enemies in a block of ice upon contact.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "fire") then
						frame:AddText("Incendiary: Sets enemies alight upon contact.", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "lifeleech") then
						frame:AddText("Lifeleech (Shieldless): 50% of damage dealt is returned as health.", Color(110, 30, 30), nil, 0.9);
					end
				
					if table.HasValue(itemTable.attributes, "rage") then
						frame:AddText("Rage (Shieldless): Movement speed is increased by 7%.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "malleable") then
						frame:AddText("Malleable: Breaks on contact irrespective of any beliefs to prevent it from being picked up and thrown back.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "shieldbreaker") then
						frame:AddText("Shieldbreaker: Deals extra condition damage to shields.", Color(110, 30, 30), nil, 0.9);
					end
				end
			
				if weaponStats["attack"].dmgtype then
					frame:AddText("Damage Type: "..damageTypes[weaponStats["attack"].dmgtype] or "Unknown", Color(110, 30, 30), nil, 0.9);
				end
				
				frame:AddText("Weapon Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				if weaponStats["attack"].takeammo then
					local percentage = math.min(weaponStats["attack"].takeammo / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Attack Cost", Color(110, 30, 30), nil, 1);
						frame:AddText("The cost of each javelin toss in stamina consumed. Can be affected by modifiers such as injuries or beliefs.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].takeammo).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Attack Cost", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].armorpiercing then
					local armorpiercing = weaponStats["attack"].armorpiercing;
					local damagetype = weaponStats["attack"].dmgtype;
					local originalAP = armorpiercing;
					
					if armorpiercing then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.7, 1));
						else
							armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.5, 1));
						end
					
						local percentage = math.min(armorpiercing / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Armor-Piercing Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("Armor piercing damage reflects your weapon's ability to pierce the armor of your foes. Higher values mean that less of your weapon's primary damage will be negated by their armor. For javelins, this applies to both the projectile and melee stance damage. However, condition loss will only affect melee damage.", Color(225, 200, 200), nil, 0.8);
						end
			
						if armorpiercing < originalAP then
							frame:AddBar(12, {{text = tostring(armorpiercing).." / "..tostring(originalAP), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(armorpiercing), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponStats["attack"].mimimumdistancedamage then
					local damagetype = weaponStats["attack"].dmgtype;
					local mimimumdistancedamage = weaponStats["attack"].mimimumdistancedamage;
					local originalDamage = mimimumdistancedamage;
					
					if mimimumdistancedamage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							mimimumdistancedamage = math.Round(mimimumdistancedamage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							mimimumdistancedamage = math.Round(mimimumdistancedamage * Lerp(scalar, 0.4, 1));
						else
							mimimumdistancedamage = math.Round(mimimumdistancedamage * Lerp(scalar, 0.5, 1));
						end

						local percentage = math.min(mimimumdistancedamage / 200, 200);
						local toolTip = function(frame)
							frame:AddText("Minimum Projectile Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The minimum amount of damage your projectile can deal. This would be dealt with a point-blank hit, and would gradually increase the further away the target is.", Color(225, 200, 200), nil, 0.8);
						end
			
						if mimimumdistancedamage < originalDamage then
							frame:AddBar(12, {{text = tostring(mimimumdistancedamage).." / "..tostring(originalDamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(mimimumdistancedamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponStats["attack"].maximumdistancedamage then
					local damagetype = weaponStats["attack"].dmgtype;
					local maximumdistancedamage = weaponStats["attack"].maximumdistancedamage;
					local originalDamage = maximumdistancedamage;
					
					if maximumdistancedamage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							maximumdistancedamage = math.Round(maximumdistancedamage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							maximumdistancedamage = math.Round(maximumdistancedamage * Lerp(scalar, 0.4, 1));
						else
							maximumdistancedamage = math.Round(maximumdistancedamage * Lerp(scalar, 0.5, 1));
						end

						local percentage = math.min(maximumdistancedamage / 200, 200);
						local toolTip = function(frame)
							frame:AddText("Maximum Projectile Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The maximum amount of damage your projectile can deal. The maximum distance can be reached at about 40 feet from your target, and any distance beyond that will grant no additional damage.", Color(225, 200, 200), nil, 0.8);
						end
			
						if maximumdistancedamage < originalDamage then
							if string.find(weaponClass, "begotten_javelin_throwing_axe") or string.find(weaponClass, "begotten_javelin_throwing_dagger") then
									frame:AddBar(12, {{text = tostring(maximumdistancedamage).." / "..tostring(originalDamage).." (At 30 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
								else
									frame:AddBar(12, {{text = tostring(maximumdistancedamage).." / "..tostring(originalDamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
								end
						else
							if string.find(weaponClass, "begotten_javelin_throwing_axe") or string.find(weaponClass, "begotten_javelin_throwing_dagger") then
								frame:AddBar(12, {{text = tostring(maximumdistancedamage).." (At 30 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(maximumdistancedamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
							end
						end
					end
				end
				
				if weaponStats["attack"].stabilitydamage then
					local percentage = math.min(weaponStats["attack"].stabilitydamage / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Stability Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage to your foe's stability that your weapon does. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor. For javelins, this scales by distance; targets further away will take considerably more stability damage, and targets up close will take considerably less stability damage. At maximum range, the projectile will deal double this stability damage.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].stabilitydamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].poisedamage then
					local percentage = math.min(weaponStats["attack"].poisedamage / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Stamina Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage to your foe's stamina that your weapon does. Dealing stamina damage will reduce an enemy's staying power in a fight or their ability to flee. Can be negated by enemy shields.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponStats["attack"].poisedamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stamina Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponStats["attack"].canaltattack then
					--frame:AddSpacer(4, Color(40, 40, 40, 120));
					
					if weaponStats["attack"].alttakeammo then
						local percentage = math.min(weaponStats["attack"].alttakeammo / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Cost", Color(110, 30, 30), nil, 1);
							frame:AddText("The cost of each of the alternate stance's melee attack in stamina consumed. Can be affected by modifiers such as injuries or beliefs.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].alttakeammo).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Cost", Color(110, 30, 30), toolTip, true);
					end
					
				if weaponStats["attack"].primarydamage then -- Uses the "primarydamage" value but only applies to the melee attack of throwable weapons
					local damage = weaponStats["attack"].primarydamage;
					local damagetype = weaponStats["attack"].dmgtype;
					local originalDamage = damage;
					
					if damage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							damage = math.Round(damage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							damage = math.Round(damage * Lerp(scalar, 0.4, 1));
						else
							damage = math.Round(damage * Lerp(scalar, 0.5, 1));
						end

						local percentage = math.min(damage / 100, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's health that your melee attack does. Can be negated by armor proportional to your weapon's armor-piercing damage value.", Color(225, 200, 200), nil, 0.8);
						end
			
						if damage < originalDamage then
							frame:AddBar(12, {{text = tostring(damage).." / "..tostring(originalDamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(damage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
					
					if weaponStats["attack"].altarmorpiercing then
						local armorpiercing = weaponStats["attack"].altarmorpiercing;
						local damagetype;
						local originalAP = armorpiercing;
						
						if weaponTable.CanSwipeAttack then
							damagetype = DMG_CLUB;
						else
							damagetype = DMG_VEHICLE;
						end
						
						if armorpiercing then
							local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
						
							if damagetype == DMG_CLUB then
								armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.7, 1));
							else
								armorpiercing = math.Round(armorpiercing * Lerp(scalar, 0.5, 1));
							end
					
							local percentage = math.min(armorpiercing / 100, 100);
							local toolTip = function(frame)
								frame:AddText("Alternate Armor-Piercing Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("Armor piercing damage reflects your weapon's alternate attack's ability to pierce the armor of your foes. Higher values mean that less of your weapon's primary damage will be negated by their armor.", Color(225, 200, 200), nil, 0.8);
							end
				
							if armorpiercing < originalAP then
								frame:AddBar(12, {{text = tostring(armorpiercing).." / "..tostring(originalAP), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(armorpiercing), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Armor-Piercing Damage", Color(110, 30, 30), toolTip, true);
							end
						end
					end
				
					if weaponStats["attack"].primarydamage and weaponStats["attack"].altattackdamagemodifier then
						local damage = weaponStats["attack"].primarydamage;
						local damagetype;
						local originalDamage = damage;
						
						if weaponTable.CanSwipeAttack then
							damagetype = DMG_CLUB;
						else
							damagetype = DMG_VEHICLE;
						end
						
						if damage then
							local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
						
							if damagetype == DMG_CLUB then
								damage = math.Round(damage * Lerp(scalar, 0.75, 1));
							elseif damagetype == DMG_VEHICLE then
								damage = math.Round(damage * Lerp(scalar, 0.5, 1));
							end
						
							local percentage = math.min((damage / 100) * weaponStats["attack"].altattackdamagemodifier, 100);
							local toolTip = function(frame)
								frame:AddText("Alternate Attack Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("The damage to your foe's health that your weapon's alternate attack does. Can be negated by armor proportional to your weapon's armor-piercing damage value.", Color(225, 200, 200), nil, 0.8);
							end
				
							if damage < originalDamage then
								frame:AddBar(12, {{text = tostring(math.Round(damage * weaponStats["attack"].altattackdamagemodifier)).." / "..tostring(math.Round(originalDamage * weaponStats["attack"].altattackdamagemodifier)), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(math.Round(damage * weaponStats["attack"].altattackdamagemodifier)), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Damage", Color(110, 30, 30), toolTip, true);
							end
						end
					end
					
					if weaponStats["attack"].stabilitydamage and weaponStats["attack"].altattackstabilitydamagemodifier and weaponStats["attack"].altattackstabilitydamagemodifier != 0 then
						local percentage = math.min((weaponStats["attack"].stabilitydamage / 100) * weaponStats["attack"].altattackstabilitydamagemodifier, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Stability Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's stability that your weapon's alternate attack does. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].stabilitydamage * weaponStats["attack"].altattackstabilitydamagemodifier), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Stability Damage", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["attack"].poisedamage and weaponStats["attack"].altattackpoisedamagemodifier then
						local percentage = math.min((weaponStats["attack"].poisedamage / 100) * weaponStats["attack"].altattackpoisedamagemodifier, 100);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Stamina Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The damage to your foe's stamina that your weapon's alternate attack does. Dealing stamina damage will reduce an enemy's staying power in a fight or their ability to flee. Can be negated by enemy shields.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].poisedamage * weaponStats["attack"].altattackpoisedamagemodifier), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Stamina Damage", Color(110, 30, 30), toolTip, true);
					end
					
					if weaponStats["attack"].altmeleearc then
						local percentage = math.min(weaponStats["attack"].altmeleearc / 60, 60);
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Weapon Arc", Color(110, 30, 30), nil, 1);
							frame:AddText("Your alternate attack weapon arc determines how wide of a swing your alternate attacks have. Caution should be exercised with weapons that have a large arc, as friendlies may unintentionally be hit.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(weaponStats["attack"].altmeleearc).."°", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Weapon Arc", Color(110, 30, 30), toolTip, true);
					end

					if weaponStats["attack"].meleerange then
						local newRange = weaponStats["attack"].meleerange;
						
						if weaponStats["attack"].altmeleerange then
							newRange = weaponStats["attack"].altmeleerange;
						--[[else
							if weaponTable.CanSwipeAttack then
								newRange = math.Round(newRange * 0.8);
							else
								newRange = math.Round(newRange * 1.2);
							end]]--
						end
						
						local percentage = math.min((newRange - 425) / (1500 - 425), (1500 - 425));
						local toolTip = function(frame)
							frame:AddText("Alternate Attack Melee Range", Color(110, 30, 30), nil, 1);
							frame:AddText("The melee range of your weapon's alternate attack determines how far you can strike when in an alternate stance. Some weapons such as polearms and spears have varied damage based on how far you are from a struck enemy as well.", Color(225, 200, 200), nil, 0.8);
						end
			
						frame:AddBar(12, {{text = tostring(newRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Alternate Attack Weapon Range", Color(110, 30, 30), toolTip, true);
					end
				end
			end
		end
		
		return true;
	elseif (category == "Shields") then
		local damageTypes = {[2] = "Bullet", [4] = "Slash", [16] = "Pierce", [128] = "Blunt", [DMG_BUCKSHOT] = "Grapeshot"};
		local shieldClass = itemTable.uniqueID;
		local shieldStats = nil;
		
		category = "Shield";
		
		if itemTable.requiredbeliefs then
			if table.HasValue(itemTable.requiredbeliefs, "defender") then
				category = "Great Shield";
			end
		end

		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end;
		
		if itemTable.requiredbeliefs and #itemTable.requiredbeliefs > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.requiredbeliefs do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.requiredbeliefs[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.requiredbeliefs[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if itemTable.onerequiredbelief and #itemTable.onerequiredbelief > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.onerequiredbelief do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.onerequiredbelief[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.onerequiredbelief[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs (One Of The Following): ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if shieldClass then
			shieldStats = GetTable(shieldClass);
	
			if shieldStats then
				frame:AddText("Shield Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);

				if shieldStats.blockdamagetypes then
					local blockDamageTypes = "";
					
					for i = 1, #shieldStats.blockdamagetypes do
						local blockDamageType = shieldStats.blockdamagetypes[i];
						
						if damageTypes[blockDamageType] then
							blockDamageTypes = blockDamageTypes..damageTypes[blockDamageType];
							
							if i < #shieldStats.blockdamagetypes then
								blockDamageTypes = blockDamageTypes..", ";
							end
						end
					end
					
					if blockDamageTypes ~= "" then
						frame:AddText("Blocks Damage Types: "..blockDamageTypes, Color(110, 30, 30), nil, 0.9);
					end
				end
			
				if shieldStats.canparry then
					frame:AddText("Can Parry", Color(110, 30, 30), nil, 0.9);
				end
				
				if !shieldStats.candeflect then
					frame:AddText("Cannot Deflect", Color(110, 30, 30), nil, 0.9);
				end
				
				if shieldStats.partialbulletblock then
					frame:AddText("Has Bullet Resistance", Color(110, 30, 30), nil, 0.9);
				end
				
				if shieldStats.parrydifficulty and shieldStats.parrydifficulty > 0.2 then
					frame:AddText("Has Increased Parry Window", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.hasIncreasedDeflectionWindow then
					frame:AddText("Increased deflection window (0.25s)", Color(110, 30, 30), nil, 0.9);
				end
				
				if category == "Great Shield" then
					frame:AddText("Great Shield: Reduces sprint speed by 10% when held.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.unrepairable then
					frame:AddText("Unrepairable: This shield cannot be repaired and will always take condition damage, irrespective of beliefs.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.attributes then
					if table.HasValue(itemTable.attributes, "conditionless") then
						frame:AddText("Conditionless: This item will not take condition damage.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "electrified") then
						frame:AddText("Electrified: Deals shock damage to characters who hit your shield with metal weapons or their fists if wearing metallic armor.", Color(110, 30, 30), nil, 0.9);
					end
					
					if table.HasValue(itemTable.attributes, "spiked") then
						frame:AddText("Spiked: Taking damage from most fisted weapons will deal a small amount of damage back to the attacker.", Color(110, 30, 30), nil, 0.9);
					end

					if table.HasValue(itemTable.attributes, "unbreakable") then
						frame:AddText("Perfect Stamina Damage Resistance: You are immune to stamina damage while blocking, and will only suffer minimum block cost.", Color(110, 30, 30), nil, 0.9);
					end
				end
				
				if itemTable.requireFaction and not table.IsEmpty(itemTable.requireFaction) and itemTable.requireFaction[1] ~= "Wanderer" then
					frame:AddText("Required Faction: "..table.concat(itemTable.requireFaction, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.requireFaith and not table.IsEmpty(itemTable.requireFaith) then
					frame:AddText("Required Faith: "..table.concat(itemTable.requireFaith, " or "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.requireSubfaction and not table.IsEmpty(itemTable.requireSubfaction) then
					frame:AddText("Required Subfaction: "..table.concat(itemTable.requireSubfaction, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.excludeFactions and not table.IsEmpty(itemTable.excludeFactions) then
					frame:AddText("Excluded Factions: "..table.concat(itemTable.excludeFactions, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				if Clockwork.Client:GetFaction() == "Goreic Warrior" and itemTable.excludeSubfactions and not table.IsEmpty(itemTable.excludeSubfactions) then
					frame:AddText("Excluded Subfactions: "..table.concat(itemTable.excludeSubfactions, ", "), Color(110, 30, 30), nil, 0.9);
				end
				
				frame:AddText("Shield Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				if itemTable.conditionScale then
					local shieldDurability = math.Max(math.Round(500 + (50 - 500) * ((itemTable.conditionScale - 0.25) / (1.3 - 0.25))), 25)
					local percentage = shieldDurability / 500
					local toolTip = function(frame)
						frame:AddText("Shield Durability", Color(110, 30, 30), nil, 1);
						frame:AddText("The higher this stat is, the more blows your shield can take before it is broken.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(shieldDurability).." / 500", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Shield Durability", Color(110, 30, 30), toolTip, true);
				end
				
				if shieldStats.blockcone then
					local percentage = math.min(shieldStats.blockcone / 270, 270);
					local toolTip = function(frame)
						frame:AddText("Block Cone", Color(110, 30, 30), nil, 1);
						frame:AddText("The block cone of your weapon or shield determines at what angles blocking is effective, when facing toward a foe.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(shieldStats.blockcone).."°", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Block Cone", Color(110, 30, 30), toolTip, true);
				end
				
				if shieldStats.guardblockamount then
					local percentage = math.min(shieldStats.guardblockamount / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Block Cost (Minimum)", Color(110, 30, 30), nil, 1);
						frame:AddText("The minimum block cost of your weapon or shield in stamina if an attack by an enemy foe causes any stamina damage at all.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(shieldStats.guardblockamount).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Block Cost (Minimum)", Color(110, 30, 30), toolTip, true);
				end
				
				if shieldStats.poiseresistance then
					local percentage = math.min(shieldStats.poiseresistance / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Block Stamina Damage Resistance", Color(110, 30, 30), nil, 1);
						frame:AddText("The resistance of your weapon or shield to additional stamina damage beyond the minimum cost while blocking.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring(shieldStats.poiseresistance).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Block Stamina Damage Resistance", Color(110, 30, 30), toolTip, true);
				end
				
				if shieldStats.canparry then
					if shieldStats.parrytakestamina then
						local percentage = math.min(shieldStats.parrytakestamina / 40, 40);
						local toolTip = function(frame)
							frame:AddText("Parry Cost", Color(110, 30, 30), nil, 1);
							frame:AddText("The stamina cost of attempting a parry. Successfully parrying a foe will refund half of this cost.", Color(225, 200, 200), nil, 0.8);
						end

						frame:AddBar(12, {{text = tostring(shieldStats.parrytakestamina).." Stamina", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Parry Cost", Color(110, 30, 30), toolTip, true);
					end
					
					if shieldStats.parrydifficulty then
						local percentage = 1 - math.min(shieldStats.parrydifficulty / 0.3, 0.3);
						local toolTip = function(frame)
							frame:AddText("Parry Window", Color(110, 30, 30), nil, 1);
							frame:AddText("The time in seconds after parrying that your parry will be active. Higher values mean that parrying will be easier as the window will be larger.", Color(225, 200, 200), nil, 0.8);
						end

						frame:AddBar(12, {{text = tostring(shieldStats.parrydifficulty).."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Parry Window", Color(110, 30, 30), toolTip, true);
					end
				end
				
				if shieldStats.damagereduction then
					local percentage = math.min(1 - shieldStats.damagereduction, 0.3);
					local toolTip = function(frame)
						frame:AddText("Weapon Damage Reduction", Color(110, 30, 30), nil, 1);
						frame:AddText("Equipped shields can lower the damage of equipped weapons up to a value of 30% for the heaviest shields.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = tostring((1 - shieldStats.damagereduction) * 100).."%", percentage = percentage * 333.33, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Weapon Damage Reduction", Color(110, 30, 30), toolTip, true);
				end
			end
		end
		
		return true;
	elseif (category == "Armor" or category == "Helms") then
		local damageTypes = {[2] = "Bullet", [4] = "Slash", [16] = "Pierce", [128] = "Blunt"};
		local limbs = {[1] = "Head", [2] = "Chest", [3] = "Stomach", [4] = "Left Arm", [5] = "Right Arm", [6] = "Left Leg", [7] = "Right Leg"};
		local name = itemTable:GetName();
		
		if category == "Helms" then
			category = "Helmet";
		end
		
		if itemTable.weightclass and itemTable.type then
			local material = string.upper(string.sub(itemTable.type, 1, 1))..string.sub(itemTable.type, 2);
			
			frame:AddText(name.." - "..itemTable.weightclass.." "..material.." "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		elseif itemTable.type then
			local material = string.upper(string.sub(itemTable.type, 1, 1))..string.sub(itemTable.type, 2);
		
			frame:AddText(name.." - "..material.." "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		else
			frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		end
		
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end;
		
		if itemTable.requiredbeliefs and #itemTable.requiredbeliefs > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.requiredbeliefs do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.requiredbeliefs[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.requiredbeliefs[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if itemTable.onerequiredbelief and #itemTable.onerequiredbelief > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.onerequiredbelief do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.onerequiredbelief[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.onerequiredbelief[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs (One Of The Following): ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		frame:AddText("Armor Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);

		if itemTable.effectiveLimbs then
			local effectiveLimbsText = "Effective Limbs: ";
			
			for i = 1, 7 do
				if itemTable.effectiveLimbs[i] then
					if effectiveLimbsText ~= "Effective Limbs: " then
						effectiveLimbsText = effectiveLimbsText..", ";
					end
					
					effectiveLimbsText = effectiveLimbsText..limbs[i];
				end
			end
		
			frame:AddText(effectiveLimbsText, Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.unrepairable then
			frame:AddText("Unrepairable: This armor cannot be repaired and will always take condition damage, irrespective of beliefs.", Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.attributes then
			if table.HasValue(itemTable.attributes, "conditionless") then
				frame:AddText("Conditionless: This item will not take condition damage.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "disease_resistance") then
				frame:AddText("Disease Resistance: This item prevents airborne diseases from infecting you.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "double_jump") then
				frame:AddText("Double Jump: This item allows you to double jump by pressing your jump key while mid-air.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "electrified") then
				frame:AddText("Electrified: Deals shock damage to characters who hit you with metal weapons or their fists if wearing metallic armor.", Color(110, 30, 30), nil, 0.9);
			end
		
			if table.HasValue(itemTable.attributes, "fear") then
				frame:AddText("Fear: Characters of opposing factions will be disoriented and lose sanity when near you.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "increased_regeneration") then
				frame:AddText("Increased Regeneration: Triples the health regeneration from 'Gift of the Great Tree'.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "lifeleech") then
				frame:AddText("Lifeleech (Shieldless): 50% of damage dealt is returned as health", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "mothers_blessing") then
				frame:AddText("Mother's Blessing: Reduces corruption gain by 50%.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "night_vision") then
				frame:AddText("Night Vision: Night vision can be activated by right-clicking with Senses while this armor is equipped.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "not_unequippable") then
				frame:AddText("Not Unequippable: This item cannot be unequipped once worn and will remain equipped until your death.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "rage") then
				frame:AddText("Rage (Shieldless): Movement speed is increased by 7%", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "seafarer") then
				frame:AddText("Seafarer: Movement speed is increased by 3%, and throwables have 10% increased damage.", Color(110, 30, 30), nil, 0.9);
			end
			
			if table.HasValue(itemTable.attributes, "thermal_vision") then
				frame:AddText("Thermal Vision: Thermal vision replaces Senses while this armor is equipped.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "solblessed") then
				--frame:AddText("Blessed in Hatred: Equipping will grant the 'Hatred' bar, which will fill upon inflicting or taking damage. 100% 'Hatred' will prevent death from damage but will reduce 'Hatred' to 0%.", Color(110, 30, 30), nil, 0.9);
				frame:AddText("Blessed in Hatred: Equipping will grant the 'Hatred' bar, which will fill upon taking damage. 100% 'Hatred' will prevent death from damage but will reduce 'Hatred' to 0%.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "deathknell") then
				frame:AddText("Deathknell: Taking damage to the head will disorient both you and the attacker.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "bloodtoll") then
				frame:AddText("Blood Toll: Taking any damage to the head will always result in a bleed injury.", Color(110, 30, 30), nil, 0.9);
			end

			if table.HasValue(itemTable.attributes, "spiked") then
				frame:AddText("Spiked: Taking damage from most fisted weapons will deal a small amount of damage back to the attacker.", Color(110, 30, 30), nil, 0.9);
			end

		end
		
		--if itemTable.weight then
			if itemTable.weightclass == "Medium" then
				frame:AddText("Sprint Speed Reduction: 15%", Color(110, 30, 30), nil, 0.9);
			elseif itemTable.weightclass == "Heavy" then
				frame:AddText("Sprint Speed Reduction: 35%", Color(110, 30, 30), nil, 0.9);
			end
		--end
		
		if itemTable.requireFaction and not table.IsEmpty(itemTable.requireFaction) and itemTable.requireFaction[1] ~= "Wanderer" then
			frame:AddText("Required Faction: "..table.concat(itemTable.requireFaction, ", "), Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.requireFaith and not table.IsEmpty(itemTable.requireFaith) then
			frame:AddText("Required Faith: "..table.concat(itemTable.requireFaith, " or "), Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.requireSubfaction and not table.IsEmpty(itemTable.requireSubfaction) then
			frame:AddText("Required Subfaction: "..table.concat(itemTable.requireSubfaction, ", "), Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.excludeFactions and not table.IsEmpty(itemTable.excludeFactions) then
			frame:AddText("Excluded Factions: "..table.concat(itemTable.excludeFactions, ", "), Color(110, 30, 30), nil, 0.9);
		end
		
		if Clockwork.Client:GetFaction() == "Goreic Warrior" and itemTable.excludeSubfactions and not table.IsEmpty(itemTable.excludeSubfactions) then
			frame:AddText("Excluded Subfactions: "..table.concat(itemTable.excludeSubfactions, ", "), Color(110, 30, 30), nil, 0.9);
		end
		
		local addedStats = false;
		
		if itemTable.protection then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
			
			local protection = itemTable.protection;
			local originalProtection = protection;
			
			if (condition < 90) then
				protection = math.Round(protection * (condition / 100));
			end
			
			local percentage = math.min(protection, 100);
			local toolTip = function(frame)
				frame:AddText("Armor Effectiveness", Color(110, 30, 30), nil, 1);
				frame:AddText("Armor effectiveness, as the name implies, affects how effective your armor is against enemy attacks. Higher armor effectiveness values reduce the damage of enemy attacks, but can in turn be reduced by an enemy's armor-percing damage. Note that the lower your armor condition, the lower your protection will be.", Color(225, 200, 200), nil, 0.8);
			end

			if protection < originalProtection then
				frame:AddBar(12, {{text = tostring(protection).."% / "..originalProtection.."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor Effectiveness", Color(110, 30, 30), toolTip, true);
			else
				frame:AddBar(12, {{text = tostring(protection).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Armor Effectiveness", Color(110, 30, 30), toolTip, true);
			end
		end
		
		if itemTable.bluntScale then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
		
			local percentage = (1 - itemTable.bluntScale) * 100;
			local toolTip = function(frame)
				frame:AddText("Blunt Damage Resistance", Color(110, 30, 30), nil, 1);
				frame:AddText("Reduces blunt damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
			end

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Blunt Damage Resistance", Color(110, 30, 30), toolTip, true);
		end
		
		if itemTable.bulletScale then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
		
			local percentage = (1 - itemTable.bulletScale) * 100;
			local toolTip = function(frame)
				frame:AddText("Bullet Damage Resistance", Color(110, 30, 30), nil, 1);
				frame:AddText("Reduces bullet damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
			end

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Bullet Damage Resistance", Color(110, 30, 30), toolTip, true);
		end
		
		--[[if itemTable.damageTypeScales and itemTable.damageTypeScales[DMG_FALL] then
			local percentage = -itemTable.damageTypeScales[DMG_FALL];

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Fall Damage Resistance", Color(110, 30, 30), toolTip, true);
		end]]--
		
		if itemTable.pierceScale then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
			
			local percentage = (1 - itemTable.pierceScale) * 100;
			local toolTip = function(frame)
				frame:AddText("Pierce Damage Resistance", Color(110, 30, 30), nil, 1);
				frame:AddText("Reduces pierce damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
			end

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Pierce Damage Resistance", Color(110, 30, 30), toolTip, true);
		end
		
		if itemTable.slashScale then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
			
			local percentage = (1 - itemTable.slashScale) * 100;
			local toolTip = function(frame)
				frame:AddText("Slash Damage Resistance", Color(110, 30, 30), nil, 1);
				frame:AddText("Reduces slash damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
			end

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Slash Damage Resistance", Color(110, 30, 30), toolTip, true);
		end
		
		if itemTable.stabilityScale then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end	
			
			local percentage = (1 - itemTable.stabilityScale) * 100;
			local toolTip = function(frame)
				frame:AddText("Stability Damage Resistance", Color(110, 30, 30), nil, 1);
				frame:AddText("Reduces stability damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
			end

			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage Resistance", Color(110, 30, 30), toolTip, true);
		else
			local armorClass = itemTable.weightclass;
			
			if armorClass then
				if !addedStats then
					frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
					
					addedStats = true;
				end	
			
				local percentage = 0;
			
				if armorClass == "Heavy" then
					percentage = 0.4;
				elseif armorClass == "Medium" then
					percentage = 0.3;
				elseif armorClass == "Light" then
					percentage = 0.15;
				end
				
				percentage = percentage * 100;
				
				local toolTip = function(frame)
					frame:AddText("Stability Damage Resistance", Color(110, 30, 30), nil, 1);
					frame:AddText("Reduces stability damage by a flat amount irrespective of armor effectiveness.", Color(225, 200, 200), nil, 0.8);
				end
				
				frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage Resistance", Color(110, 30, 30), toolTip, true);
			end
		end
		
		if cwWarmth and cwWarmth.systemEnabled and itemTable.insulation then
			if !addedStats then
				frame:AddText("Armor Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				addedStats = true;
			end
			
			local percentage = itemTable.insulation;

			if(category == "Helmet") then percentage = percentage * 0.20;
			elseif(!itemTable.hasHelmet) then percentage = percentage * 0.80; end
		
			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Insulation", Color(110, 30, 30), true);
		end
		
		return true;
	elseif (category == "Crossbows") or (category == "Firearms") then
		local weaponAmmo = itemTable:GetData("Ammo");
		local weaponClass = itemTable.uniqueID;
		local weaponTable;

		if string.find(category, "(Begotten)") then
			category = string.gsub(category, "(Begotten) ", "");
		end
		
		if itemTable.firearmType then
			category = itemTable.firearmType;
		end
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end
		
		if itemTable.requireFaith and not table.IsEmpty(itemTable.requireFaith) then
			frame:AddText("Required Faith: "..table.concat(itemTable.requireFaith, " or "), Color(110, 30, 30), nil, 0.9);
		end

		if weaponClass then
			weaponTable = _G.weapons.Get(weaponClass);
			
			if weaponTable then
				frame:AddText("Weapon Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);

				if !weaponTable.MisfireChance or weaponTable.MisfireChance == 0 then
					frame:AddText("Cannot Misfire", Color(110, 30, 30), nil, 0.9);
				end
				
				frame:AddText("Ranged Weapon: You will be disarmed upon taking damage with this weapon.", Color(110, 30, 30), nil, 0.9);
				
				if itemTable.unrepairable then
					frame:AddText("Unrepairable: This weapon cannot be repaired and will always take condition damage, irrespective of beliefs.", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.attributes then
					if table.HasValue(itemTable.attributes, "melee") then
						frame:AddText("Melee Stance: Can be used as a melee weapon by switching stances.", Color(110, 30, 30), nil, 0.9);
					elseif table.HasValue(itemTable.attributes, "sundering_shot") then
						frame:AddText("Sundering Shot: Travelling at supersonic speeds, Old World Longshot ignores armor and shields entirely.", Color(110, 30, 30), nil, 0.9);
					elseif table.HasValue(itemTable.attributes, "sundering_shot_grapeshot") then
						frame:AddText("Sundering Shot: Travelling at supersonic speeds, Old World Grapeshot ignores armor and shields entirely.", Color(110, 30, 30), nil, 0.9);
					elseif table.HasValue(itemTable.attributes, "variable_damage") then
						frame:AddText("Variable Damage: Damage will be increased or decreased depending on the distance of the target. Targets further away will receive more damage.", Color(110, 30, 30), nil, 0.9);
					end
				end

				if itemTable.usesMagazine then
					frame:AddText("Uses Detachable Magazines", Color(110, 30, 30), nil, 0.9);
				elseif itemTable.isRevolver then
					frame:AddText("Has Revolving Barrels", Color(110, 30, 30), nil, 0.9);
				elseif itemTable.ammoCapacity and itemTable.ammoCapacity > 1 then
					frame:AddText("Has Fixed Magazine", Color(110, 30, 30), nil, 0.9);
				else
					frame:AddText("Has Single Shot", Color(110, 30, 30), nil, 0.9);
				end
				
				if weaponTable.IgnoresBulletResistance then
					frame:AddText("Ignores Bullet Resistance", Color(110, 30, 30), nil, 0.9);
				end
				
				if itemTable.ammoTypes then
					if itemTable.ammoTypes and #itemTable.ammoTypes > 0 then
						local ammoIcons = {};
						
						for i, v in ipairs(itemTable.ammoTypes) do
							local ammoItemTable = item.FindByID(string.lower(v));
							
							if ammoItemTable then
								table.insert(ammoIcons, {itemTable = ammoItemTable});
							end
						end
						
						frame:AddText("Shot Versatility: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
						frame:AddIconRow(ammoIcons, 48);
					end
					
					--[[if itemTable.ammoTypesNice then
						for i = 1, #itemTable.ammoTypesNice do
							frame:AddText("   "..itemTable.ammoTypesNice[i], Color(110, 30, 30), nil, 0.9);
						end
					else
						for i = 1, #itemTable.ammoTypes do
							frame:AddText("   "..itemTable.ammoTypes[i], Color(110, 30, 30), nil, 0.9);
						end
					end]]--
				end
				
				frame:AddText("Weapon Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				
				if weaponTable.Primary.IronAccuracy and !weaponTable.Primary.MaximumDistanceDamage then
					local accuracy = weaponTable.Primary.IronAccuracy;
					local originalAccuracy = accuracy;
					
					if condition and condition < 100 then
						accuracy = math.Truncate(accuracy * Lerp(condition / 90, 1.5, 1), 5);
					end
				
					local percentage = 1 - math.min(accuracy * 2, 1);
					local toolTip = function(frame)
						frame:AddText("Accuracy (Aiming)", Color(110, 30, 30), nil, 1);
						frame:AddText("The accuracy of your weapon while aiming down sights. Can be further increased by crouching and through the 'Marksman' belief.", Color(225, 200, 200), nil, 0.8);
					end
		
					if accuracy > originalAccuracy then
						frame:AddBar(12, {{text = tostring(accuracy).." / "..tostring(originalAccuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Aiming)", Color(110, 30, 30), toolTip, true);
					else
						frame:AddBar(12, {{text = tostring(accuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Aiming)", Color(110, 30, 30), toolTip, true);
					end
				end
				
				if weaponTable.Primary.Spread and !weaponTable.Primary.MaximumDistanceDamage then
					local accuracy = weaponTable.Primary.Spread;
					local originalAccuracy = accuracy;
					
					if condition and condition < 100 then
						accuracy = math.Truncate(accuracy * Lerp(condition / 90, 1.5, 1), 5);
					end
				
					local percentage = 1 - math.min(accuracy * 2, 1);
					local toolTip = function(frame)
						frame:AddText("Accuracy (Hip-Fire)", Color(110, 30, 30), nil, 1);
						frame:AddText("The accuracy of your weapon while hip-firing. Can be further increased by crouching.", Color(225, 200, 200), nil, 0.8);
					end
		
					if accuracy > originalAccuracy then
						frame:AddBar(12, {{text = tostring(accuracy).." / "..tostring(originalAccuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Hip-Fire)", Color(110, 30, 30), toolTip, true);
					else
						frame:AddBar(12, {{text = tostring(accuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Hip-Fire)", Color(110, 30, 30), toolTip, true);
					end
				end
				
				if weaponTable.Primary.NumShots > 1 then
					local percentage = math.min(weaponTable.Primary.NumShots, 32) / 32;
					local toolTip = function(frame)
						frame:AddText("Pellet Amount", Color(110, 30, 30), nil, 1);
						frame:AddText("The amount of projectiles fired from this weapon.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponTable.Primary.NumShots), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Pellet Amount", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponTable.Primary.RPM and weaponTable.Primary.ClipSize > 1 then
					local percentage = math.min(weaponTable.Primary.RPM, 650) / 650;
					local toolTip = function(frame)
						frame:AddText("Rate of Fire", Color(110, 30, 30), nil, 1);
						frame:AddText("The rate of fire of this weapon in rounds per minute.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponTable.Primary.RPM), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Rate of Fire", Color(110, 30, 30), toolTip, true);
				end
				
				if itemTable.reloadTime then
					local percentage = math.min(itemTable.reloadTime, 10);
					local toolTip = function(frame)
						frame:AddText("Reload Time", Color(110, 30, 30), nil, 1);
						frame:AddText("The amount of time in seconds it takes to reload this weapon.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(itemTable.reloadTime).."s", percentage = percentage * 10, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Reload Time", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponTable.Primary.MaximumDistanceDamage then
					local maximumdistancedamage = weaponTable.Primary.MaximumDistanceDamage;
					local originalDamage = maximumdistancedamage;
					
					if maximumdistancedamage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						maximumdistancedamage = math.Round(maximumdistancedamage * Lerp(scalar, 0.7, 1));

						local percentage = math.min(maximumdistancedamage / 150, 150);
						local toolTip = function(frame)
							frame:AddText("Maximum Projectile Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The maximum amount of damage your projectile can deal. The maximum distance can be reached at about 40 feet from your target, and any distance beyond that will grant no additional damage.", Color(225, 200, 200), nil, 0.8);
						end
			
						if maximumdistancedamage < originalDamage then
							frame:AddBar(12, {{text = tostring(maximumdistancedamage).." / "..tostring(originalDamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(maximumdistancedamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponTable.Primary.MinimumDistanceDamage then
					local minimumdistancedamage = weaponTable.Primary.MinimumDistanceDamage;
					local originalDamage = minimumdistancedamage;
					
					if minimumdistancedamage then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						minimumdistancedamage = math.Round(minimumdistancedamage * Lerp(scalar, 0.7, 1));

						local percentage = math.min(minimumdistancedamage / 150, 150);
						local toolTip = function(frame)
							frame:AddText("Minimum Projectile Damage", Color(110, 30, 30), nil, 1);
							frame:AddText("The minimum amount of damage your projectile can deal. This would be dealt with a point-blank hit, and would gradually increase the further away the target is.", Color(225, 200, 200), nil, 0.8);
						end
			
						if minimumdistancedamage < originalDamage then
							frame:AddBar(12, {{text = tostring(minimumdistancedamage).." / "..tostring(originalDamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(minimumdistancedamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponTable.Primary.StabilityDamage then
					local percentage = math.min(weaponTable.Primary.StabilityDamage / 100, 100);
					local toolTip = function(frame)
						frame:AddText("Stability Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage to your foe's stability that your fired projectiles deal. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor. For bolts, this scales by distance; targets further away will take considerably more stability damage, and targets up close will take considerably less stability damage. At maximum range, the projectile will deal double this stability damage.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponTable.Primary.StabilityDamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponTable.Primary.BoltRange then
					local boltRange = weaponTable.Primary.BoltRange;
					local originalBoltRange = boltRange;
					
					if boltRange then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						boltRange = math.Round(boltRange * Lerp(scalar, 0.5, 1));

						local percentage = math.min(boltRange / 200, 200);
						local toolTip = function(frame)
							frame:AddText("Bolt Range", Color(110, 30, 30), nil, 1);
							frame:AddText("The speed and maximum distance of your loosed bolt. If you wish to hit a target further away, aim higher!", Color(225, 200, 200), nil, 0.8);
						end
			
						if boltRange < originalBoltRange then
							frame:AddBar(12, {{text = tostring(boltRange).." / "..tostring(originalBoltRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Bolt Range", Color(110, 30, 30), toolTip, true);
						else
							frame:AddBar(12, {{text = tostring(boltRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Bolt Range", Color(110, 30, 30), toolTip, true);
						end
					end
				end
				
				if weaponTable.Primary.Damage and !weaponTable.Primary.MaximumDistanceDamage then
					local percentage = math.min(weaponTable.Primary.Damage / 80, 80);
					local toolTip = function(frame)
						frame:AddText("Shot Damage", Color(110, 30, 30), nil, 1);
						frame:AddText("The damage of this weapon's shot. Note that firearms have 100% armor-piercing.", Color(225, 200, 200), nil, 0.8);
					end
		
					frame:AddBar(12, {{text = tostring(weaponTable.Primary.Damage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Shot Damage", Color(110, 30, 30), toolTip, true);
				end
				
				if weaponAmmo then
					if #weaponAmmo > 0 then
						if itemTable.ammoCapacity > 1 then
							if itemTable.usesMagazine then
								frame:AddText("Loaded Shot: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
								
								local clipItem = Clockwork.item:FindByID(string.gsub(string.lower(weaponAmmo[1]), " ", "_"));
								
								if clipItem then
									frame:AddText(weaponAmmo[1].." ("..tostring(#weaponAmmo).."/"..tostring(clipItem.ammoMagazineSize or weaponTable.Primary.ClipSize)..")", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
								else
									frame:AddText(weaponAmmo[1].." ("..tostring(#weaponAmmo).."/"..tostring(weaponTable.Primary.ClipSize)..")", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
								end
							else
								-- Likely is multi-barreled gun.
								frame:AddText("Loaded Shot: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
								
								for i = 1, weaponTable.Primary.ClipSize do
									if i <= #weaponAmmo then
										frame:AddText(tostring(i)..") "..weaponAmmo[i], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
									else
										frame:AddText(tostring(i)..") Empty Chamber", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
									end
								end
							end
						else
							frame:AddText("Loaded Shot: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
							frame:AddText(weaponAmmo[1], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
						end
					else
						frame:AddText("This weapon is empty.", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
					end
				end
			end
		end
		
		return true;
	elseif (category == "Charms") then
		frame:AddText(name.." - Charm", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end;
		
		if itemTable.requireFaith and not table.IsEmpty(itemTable.requireFaith) then
			frame:AddText("Required Faith: "..table.concat(itemTable.requireFaith, " or "), Color(110, 30, 30), nil, 0.9);
		end
		
		frame:AddText("Effects: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable.charmEffects, Color(110, 30, 30), nil, 0.9);
		
		return true;
	elseif (category == "Shot") then
		if itemTable.ammoMagazineSize then
			local magazineAmmo = itemTable:GetAmmoMagazine();
			
			if magazineAmmo and magazineAmmo <= 0 then
				frame:AddText("Empty "..itemTable.name.." - Magazine", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
			else
				frame:AddText(itemTable.name.." - Magazine", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
			end
		else
			frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		end
		
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
		
		if itemTable.attributes then
			frame:AddText("Shot Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
		
			if table.HasValue(itemTable.attributes, "fire") then
				frame:AddText("Incendiary: Sets enemies alight upon contact.", Color(110, 30, 30), nil, 0.9);
			end
		end
		
		if frame.parent then
			local parent = frame.parent:GetParent():GetParent():GetParent():GetParent():GetParent();

			if IsValid(parent) and parent.itemTable then
				local weaponItemTable = parent.itemTable;
				local weaponClass = weaponItemTable.uniqueID;
				local weaponTable;

				if weaponClass then
					weaponTable = _G.weapons.Get(weaponClass);
				end
				
				if weaponTable and weaponTable.AmmoTypes and weaponTable.AmmoTypes[itemTable.ammoType] then				
					local ammoStats = weaponTable.AmmoTypes[itemTable.ammoType];
					
					if ammoStats then
						ammoStats(weaponTable);
					
						frame:AddText("Shot Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
						
						if weaponTable.Primary.IronAccuracy and !weaponTable.Primary.MaximumDistanceDamage then
							local accuracy = weaponTable.Primary.IronAccuracy;
							local originalAccuracy = accuracy;
							
							if condition and condition < 100 then
								accuracy = math.Truncate(accuracy * Lerp(condition / 90, 1.5, 1), 5);
							end
						
							local percentage = 1 - math.min(accuracy * 2, 1);
							local toolTip = function(frame)
								frame:AddText("Accuracy (Aiming)", Color(110, 30, 30), nil, 1);
								frame:AddText("The accuracy of your weapon while aiming down sights. Can be further increased by crouching and through the 'Marksman' belief.", Color(225, 200, 200), nil, 0.8);
							end
				
							if accuracy > originalAccuracy then
								frame:AddBar(12, {{text = tostring(accuracy).." / "..tostring(originalAccuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Aiming)", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(accuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Aiming)", Color(110, 30, 30), toolTip, true);
							end
						end
						
						if weaponTable.Primary.Spread and !weaponTable.Primary.MaximumDistanceDamage then
							local accuracy = weaponTable.Primary.Spread;
							local originalAccuracy = accuracy;
							
							if condition and condition < 100 then
								accuracy = math.Truncate(accuracy * Lerp(condition / 90, 1.5, 1), 5);
							end
						
							local percentage = 1 - math.min(accuracy * 2, 1);
							local toolTip = function(frame)
								frame:AddText("Accuracy (Hip-Fire)", Color(110, 30, 30), nil, 1);
								frame:AddText("The accuracy of your weapon while hip-firing. Can be further increased by crouching.", Color(225, 200, 200), nil, 0.8);
							end
				
							if accuracy > originalAccuracy then
								frame:AddBar(12, {{text = tostring(accuracy).." / "..tostring(originalAccuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Hip-Fire)", Color(110, 30, 30), toolTip, true);
							else
								frame:AddBar(12, {{text = tostring(accuracy), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Accuracy (Hip-Fire)", Color(110, 30, 30), toolTip, true);
							end
						end
						
						if weaponTable.Primary.NumShots > 1 then
							local percentage = math.min(weaponTable.Primary.NumShots, 32) / 32;
							local toolTip = function(frame)
								frame:AddText("Pellet Amount", Color(110, 30, 30), nil, 1);
								frame:AddText("The amount of projectiles fired from this weapon.", Color(225, 200, 200), nil, 0.8);
							end
				
							frame:AddBar(12, {{text = tostring(weaponTable.Primary.NumShots), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Pellet Amount", Color(110, 30, 30), toolTip, true);
						end
						
						if weaponTable.Primary.RPM and weaponTable.Primary.ClipSize > 1 then
							local percentage = math.min(weaponTable.Primary.RPM, 650) / 650;
							local toolTip = function(frame)
								frame:AddText("Rate of Fire", Color(110, 30, 30), nil, 1);
								frame:AddText("The rate of fire of this weapon in rounds per minute.", Color(225, 200, 200), nil, 0.8);
							end
				
							frame:AddBar(12, {{text = tostring(weaponTable.Primary.RPM), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Rate of Fire", Color(110, 30, 30), toolTip, true);
						end
						
						if weaponTable.Primary.MaximumDistanceDamage then
							local maximumdistancedamage = weaponTable.Primary.MaximumDistanceDamage;
							local originalDamage = maximumdistancedamage;
							
							if maximumdistancedamage then
								local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
							
								maximumdistancedamage = math.Round(maximumdistancedamage * Lerp(scalar, 0.7, 1));

								local percentage = math.min(maximumdistancedamage / 150, 150);
								local toolTip = function(frame)
									frame:AddText("Maximum Projectile Damage", Color(110, 30, 30), nil, 1);
									frame:AddText("The maximum amount of damage your projectile can deal. The maximum distance can be reached at about 40 feet from your target, and any distance beyond that will grant no additional damage.", Color(225, 200, 200), nil, 0.8);
								end
					
								if maximumdistancedamage < originalDamage then
									frame:AddBar(12, {{text = tostring(maximumdistancedamage).." / "..tostring(originalDamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
								else
									frame:AddBar(12, {{text = tostring(maximumdistancedamage).." (At 40 Feet)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Maximum Projectile Damage", Color(110, 30, 30), toolTip, true);
								end
							end
						end
						
						if weaponTable.Primary.MinimumDistanceDamage then
							local minimumdistancedamage = weaponTable.Primary.MinimumDistanceDamage;
							local originalDamage = minimumdistancedamage;
							
							if minimumdistancedamage then
								local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
							
								minimumdistancedamage = math.Round(minimumdistancedamage * Lerp(scalar, 0.7, 1));

								local percentage = math.min(minimumdistancedamage / 150, 150);
								local toolTip = function(frame)
									frame:AddText("Minimum Projectile Damage", Color(110, 30, 30), nil, 1);
									frame:AddText("The minimum amount of damage your projectile can deal. This would be dealt with a point-blank hit, and would gradually increase the further away the target is.", Color(225, 200, 200), nil, 0.8);
								end
					
								if minimumdistancedamage < originalDamage then
									frame:AddBar(12, {{text = tostring(minimumdistancedamage).." / "..tostring(originalDamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
								else
									frame:AddBar(12, {{text = tostring(minimumdistancedamage).." (Point-Blank)", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Minimum Projectile Damage", Color(110, 30, 30), toolTip, true);
								end
							end
						end
						
						if weaponTable.Primary.StabilityDamage then
							local percentage = math.min(weaponTable.Primary.StabilityDamage / 100, 100);
							local toolTip = function(frame)
								frame:AddText("Stability Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("The damage to your foe's stability that your fired projectiles deal. Dealing enough will temporarily knock your foe to the ground. Can be negated by enemy armor. For bolts, this scales by distance; targets further away will take considerably more stability damage, and targets up close will take considerably less stability damage. At maximum range, the projectile will deal double this stability damage.", Color(225, 200, 200), nil, 0.8);
							end
				
							frame:AddBar(12, {{text = tostring(weaponTable.Primary.StabilityDamage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Stability Damage", Color(110, 30, 30), toolTip, true);
						end
						
						if weaponTable.Primary.BoltRange then
							local boltRange = weaponTable.Primary.BoltRange;
							local originalBoltRange = boltRange;
							
							if boltRange then
								local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
							
								boltRange = math.Round(boltRange * Lerp(scalar, 0.5, 1));

								local percentage = math.min(boltRange / 200, 200);
								local toolTip = function(frame)
									frame:AddText("Bolt Range", Color(110, 30, 30), nil, 1);
									frame:AddText("The speed and maximum distance of your loosed bolt. If you wish to hit a target further away, aim higher!", Color(225, 200, 200), nil, 0.8);
								end
					
								if boltRange < originalBoltRange then
									frame:AddBar(12, {{text = tostring(boltRange).." / "..tostring(originalBoltRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Bolt Range", Color(110, 30, 30), toolTip, true);
								else
									frame:AddBar(12, {{text = tostring(boltRange), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Bolt Range", Color(110, 30, 30), toolTip, true);
								end
							end
						end
						
						if weaponTable.Primary.Damage and !weaponTable.Primary.MaximumDistanceDamage then
							local percentage = math.min(weaponTable.Primary.Damage / 80, 80);
							local toolTip = function(frame)
								frame:AddText("Shot Damage", Color(110, 30, 30), nil, 1);
								frame:AddText("The damage of this weapon's shot. Note that firearms have 100% armor-piercing.", Color(225, 200, 200), nil, 0.8);
							end
				
							frame:AddBar(12, {{text = tostring(weaponTable.Primary.Damage), percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Shot Damage", Color(110, 30, 30), toolTip, true);
						end
					end
				end
			end
		end
		
		if itemTable.ammoMagazineSize then
			local magazineAmmo = itemTable:GetAmmoMagazine();
			
			if magazineAmmo and magazineAmmo > 0 then
				frame:AddText("Loaded Shot: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
				frame:AddText(itemTable.ammoName.." ("..tostring(magazineAmmo).."/"..tostring(itemTable.ammoMagazineSize)..")", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
			else
				frame:AddText("This magazine is empty.", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			end
		end
		
		return true;
	elseif (category == "Medical") then
		local hitGroupToString = {
			[HITGROUP_CHEST] = "Chest",
			[HITGROUP_HEAD] = "Head",
			[HITGROUP_STOMACH] = "Stomach",
			[HITGROUP_LEFTARM] = "Left Arm",
			[HITGROUP_RIGHTARM] = "Right Arm",
			[HITGROUP_LEFTLEG] = "Left Leg",
			[HITGROUP_RIGHTLEG] = "Right Leg",
			[HITGROUP_GENERIC] = "Generic",
		};

		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
			frame:AddSpacer(2, Color(0, 0, 0, 0));
		end
		
		frame:AddText("Medical Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);

		if itemTable.applicable then
			frame:AddText("Applicable", Color(110, 30, 30), nil, 0.9);
		elseif itemTable.ingestible then
			frame:AddText("Ingestible", Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.canSave then
			frame:AddText("Can Revive From Critical Condition", Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.curesInjuries then
			frame:AddText("Cures Injuries: ", Color(110, 30, 30), nil, 0.9);
			
			for i = 1, #itemTable.curesInjuries do
				local injury = cwMedicalSystem.cwInjuryTable[itemTable.curesInjuries[i]];
				
				if injury then
					frame:AddText("    "..injury.name, Color(110, 30, 30), nil, 0.9);
				end
			end
		end
		
		if itemTable.stopsBleeding then
			frame:AddText("Stops Bleeding", Color(110, 30, 30), nil, 0.9);
		end
		
		if itemTable.limbs then
			if itemTable.limbs == "all" then
				frame:AddText("Supported Limbs: Heals All", Color(110, 30, 30), nil, 0.9);
			elseif #itemTable.limbs > 0 then
				frame:AddText("Supported Limbs: ", Color(110, 30, 30), nil, 0.9);
				
				for i = 1, #itemTable.limbs do
					frame:AddText("    "..hitGroupToString[itemTable.limbs[i]], Color(110, 30, 30), nil, 0.9);
				end
			end
		end

		if itemTable.healAmount or itemTable.restoresBlood then
			frame:AddText("Medical Stats: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
		
			if itemTable.healAmount and itemTable.healRepetition then	
				local healAmount = itemTable.healAmount;
				local healRepetition = itemTable.healRepetition;
				local healDelay = itemTable.healDelay;
				local percentage = math.min(healAmount / 100, 100);
				local toolTip = function(frame)
					frame:AddText("Heal Amount", Color(110, 30, 30), nil, 1);
					frame:AddText("The amount of health this item will restore every repetition.", Color(225, 200, 200), nil, 0.8);
				end

				frame:AddBar(12, {{text = healAmount.." Health", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Heal Amount", Color(110, 30, 30), toolTip, true);
				
				percentage = math.min(healRepetition / 8, 8);
				toolTip = function(frame)
					frame:AddText("Heal Repetitions", Color(110, 30, 30), nil, 1);
					frame:AddText("The amount of times that this item will restore health.", Color(225, 200, 200), nil, 0.8);
				end

				frame:AddBar(12, {{text = healRepetition, percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Heal Repetitions", Color(110, 30, 30), toolTip, true);
				
				if itemTable.healDelay then
					percentage = math.min(healDelay / 8, 8);
					toolTip = function(frame)
						frame:AddText("Heal Delay", Color(110, 30, 30), nil, 1);
						frame:AddText("The delay between each of this item's heal repetitions.", Color(225, 200, 200), nil, 0.8);
					end

					frame:AddBar(12, {{text = healDelay.."s", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Heal Delay", Color(110, 30, 30), toolTip, true);
				end
			end
			
			if itemTable.restoresBlood then	
				local healAmount = itemTable.restoresBlood;
				local percentage = math.min(healAmount / 2500, 2500);
				local toolTip = function(frame)
					frame:AddText("Restores Blood", Color(110, 30, 30), nil, 1);
					frame:AddText("The total amount of blood that this medical item will restore.", Color(225, 200, 200), nil, 0.8);
				end

				frame:AddBar(12, {{text = healAmount.." Blood", percentage = percentage * 100, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Restores Blood", Color(110, 30, 30), toolTip, true);
			end
		end
		
		return true;
	end
	
	if category == "Helms" then -- For helms that don't have armor like hats and hoods.
		category = "Headwear";
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
		
		if cwWarmth and cwWarmth.systemEnabled and itemTable.insulation then
			local percentage = itemTable.insulation * 0.20;
		
			frame:AddBar(12, {{text = tostring(percentage).."%", percentage = percentage, color = Color(110, 30, 30), font = "DermaDefault", textless = false, noDisplay = true}}, "Insulation", Color(110, 30, 30), true);
		end
		
		return true;
	elseif category == "Catalysts" then
		category = "Catalyst";
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
		
		return true;
	elseif category == "Backpacks" then
		category = "Backpack";
		
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
		
		if itemTable.invSpace then
			frame:AddText("Item Attributes: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddText("Increases Maximum Carry Weight: +"..tostring(itemTable.invSpace).."kg", Color(110, 30, 30), nil, 0.9);
		end
		
		return true;
	elseif category == "Scripture" and cwScriptures then
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
		
		if cwScriptures.booksRead then
			if table.HasValue(cwScriptures.booksRead, itemTable.uniqueID) then
				frame:AddText("Already read!", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1);
			end
		end
		
		if cwScriptures.booksCopied then
			if table.HasValue(cwScriptures.booksCopied, itemTable.uniqueID) then
				frame:AddText("Already copied!", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1);
			end
		end
		
		return true;
	else
		if itemTable.GetCustomName then
			name = itemTable:GetCustomName();
		end
	
		frame:AddText(name.." - "..category, Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(itemTable("description"), Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		
		if (bShowWeight) then
			frame:AddBar(20, {{text = weight.."kg", percentage = percentage * 100, color = Color(96, 96, 128), font = "DermaDefault", leftTextAlign = false, noDisplay = true}}, "Weight", Color(170, 170, 180));
		end;
	
		if itemTable.requiredbeliefs and #itemTable.requiredbeliefs > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.requiredbeliefs do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.requiredbeliefs[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.requiredbeliefs[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs: ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		if itemTable.onerequiredbelief and #itemTable.onerequiredbelief > 0 then
			local beliefIcons = {};
			
			for i = 1, #itemTable.onerequiredbelief do
				local beliefTable = cwBeliefs:FindBeliefByID(itemTable.onerequiredbelief[i]);
				
				if beliefTable then
					local tooltip = function(frame)
						frame:AddText(beliefTable.name, cwBeliefs:FindBeliefTreeByBelief(beliefTable.uniqueID).color, "Civ5ToolTip4");
						
						if beliefTable.quote then
							frame:AddText(beliefTable.description.."\n", Color(225, 200, 200));
							frame:AddText(beliefTable.quote, Color(128, 90, 90, 240));
						else
							frame:AddText(beliefTable.description, Color(225, 200, 200));
						end
					end
					
					if beliefTable.iconOverride then
						table.insert(beliefIcons, {icon = beliefTable.iconOverride, tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					else
						table.insert(beliefIcons, {icon = "begotten/ui/belieficons/"..itemTable.onerequiredbelief[i]..".png", tooltip = tooltip, button = function() cwBeliefs:OpenTree(nil, nil, nil, nil, nil, nil, beliefTable.uniqueID) end});
					end
				end
			end
			
			frame:AddText("Required Beliefs (One Of The Following): ", Color(225, 225, 225), "nov_IntroTextSmallDETrooper", 1.15);
			frame:AddIconRow(beliefIcons, 40);
		end
		
		hook.Run("SubModifyItemMarkupTooltip", category, maximumWeight, weight, condition, percentage, name, itemTable, x, y, width, height, frame, bShowWeight);
		
		return true;
	end
end

function Schema:ClockworkInitialized()
	Clockwork.directory:AddCategory("Faiths", "Faith is an integral part of Begotten III, as nearly all of Begotten's gameplay elements and story revolve around it. God has committed suicide, and no one left alive is pure, but that has not stopped what little that remains of humanity from looking to their gods in hope of salvation. After all, those without it have been targeted by the Undergod, and subsequently the Begotten. Each faith has its own rituals and major faction(s) associated with it.")
	Clockwork.directory:AddCategory("Mechanics", "Distinguishing Begotten III from its other text-based roleplay peers is its myriad gameplay mechanics. Character needs such as hunger and thirst form the backbone of your character's goal to stay alive. The beliefs system rewards those who survive longest with a means to increase their power and abilities. Crafting and resource gathering form the engine of every faction's economy. The medical system simulates disease and injuries to characters.\n\nBegotten III also features a comprehensive melee combat system.\n\nUltimately, while you are free to play Begotten in almost any way you see fit, mastering all of its mechanics is essential to survival in the Wasteland.")
end

function Schema:DirectoryOpenHomePage(panel)
	local WIPLabel = vgui.Create("DLabel", panel);
	
	WIPLabel:SetText("THE MANIFESTO IS A WORK IN PROGRESS!");
	WIPLabel:SetFont("manifestoContentHeader");
	WIPLabel:SetTextColor(Color(255, 20, 20));
	WIPLabel:SizeToContents();
	
	panel.panelList:AddItem(WIPLabel);
	
	local videoLabel = vgui.Create("DLabel", panel);
	
	videoLabel:SetText("Featured Video:");
	videoLabel:SetFont("manifestoContentHeader");
	videoLabel:SizeToContents();
	
	panel.panelList:AddItem(videoLabel)
	
	local video = vgui.Create("cwVideoPanel");
	
	video:SetSize(720, 380);
	video:SetURL();
	
	panel.panelList:AddItem(video)

	local beginnersLabel = vgui.Create("DLabel", panel);
	
	beginnersLabel:SetText("Beginner's Guide:");
	beginnersLabel:SetFont("manifestoContentHeader");
	beginnersLabel:SizeToContents();
	
	panel.panelList:AddItem(beginnersLabel);
end

netstream.Hook("Archives", function(data)
	Schema.archivesBookList = data;
end);

netstream.Hook("CheapleCutscene", function(data)
	Schema:CheapleCutscene();
end);

netstream.Hook("GoreWarhorn", function(data)
	if cwMusic then
		cwMusic:FadeOutAmbientMusic(2, 1);
	end
	
	Clockwork.Client:EmitSound("warhorns/warhorn_gore.mp3", 60, 100);
	
	util.ScreenShake(Clockwork.Client:GetPos(), 2, 5, 15, 1024);
end);

netstream.Hook("NPCSpawnESPInfo", function(data)
	if data then
		if data[1] then
			Schema.npcSpawns = data[1];
		end
	end
end);

-- Save data icon in top right.
local pentaFade;
local pentaAlpha = 0;
local pentaRotate = 0;
local mPentagram = Material("begotten/pentagram_red.png");

net.Receive("ServerSaveData", function()
	if net.ReadBool() then
		hook.Add("DrawOverlay", "DrawOverlayServerSaveData", function()
			if pentaFade then
				pentaAlpha = math.Approach(pentaAlpha, 0, FrameTime() * 400);
			else
				pentaAlpha = math.Approach(pentaAlpha, 255, FrameTime() * 400);
			end
			
			pentaRotate = (pentaRotate + (FrameTime() * 50)) % 360;
			
			local scrW = ScrW()
			local pentaSize = scrW * 0.032;
			
			surface.SetDrawColor(Color(139, 64, 0, pentaAlpha));
			surface.SetMaterial(mPentagram);
			surface.DrawTexturedRectRotated(scrW - pentaSize, pentaSize, pentaSize, pentaSize, pentaRotate);
		end);
	else
		pentaFade = true;
	
		timer.Simple(4, function()
			pentaFade = nil;
			pentaAlpha = 0;
			pentaRotate = 0;
			hook.Remove("DrawOverlay", "DrawOverlayServerSaveData");
		end);
	end
end);