--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Called when Clockwork is initialized.
function cwZombies:ClockworkInitialized()
	CW_CONVAR_ZOMBIEESP = Clockwork.kernel:CreateClientConVar("cwZombieESP", 1, false, true);
	--CW_CONVAR_ZOMBIEMUSIC = Clockwork.kernel:CreateClientConVar("cwZombieMusic", 1, false, true);
end;

-- Called every frame the local player is connected to the server.
--[[function cwZombies:Think()
	local curTime = CurTime();
	
	if (Clockwork.Client:HasInitialized()) then
		if (Clockwork.Client:Alive()) then
			if (Clockwork.Client:GetPos().z < -650) then
				return;
			end;
			
			if (!cwZombies:CanHearBattle()) then
				if (monsterPatch) then
					monsterPatch:Stop();
				end;
				
				if (terrorPatch) then
					terrorPatch:Stop();
				end;
				
				return;
			end;
			
			local velocity = Clockwork.Client:GetVelocity();
			local length = velocity:Length();
			
			if (length <= 10) then
				if (!Clockwork.Client.nextZombieChoir or Clockwork.Client.nextZombieChoir < curTime) then
					Clockwork.Client.nextZombieChoir = curTime + 90;
					
					if (math.random(1, 4) == 1) then
						local eyePos = EyePos();
						local randomVector = VectorRand();

						local randomSounds = {
							"begotten/l4d2/glimpse_hell1.wav",
							"begotten/l4d2/glimpse_hell2.wav",
							"begotten/l4d2/glimpse_hell3.wav",
							"begotten/l4d2/infection1.mp3",
							"begotten/l4d2/infection2.mp3",
							"begotten/l4d2/infection3.mp3"
						};

						sound.Play(randomSounds[math.random(1, #randomSounds)], eyePos + (randomVector * 40), math.random(60, 80), math.random(30, 40));
					end;
				end;
			end;
		
			if (!Clockwork.Client.nextMonsterCheck or curTime > Clockwork.Client.nextMonsterCheck) then
				Clockwork.Client.nextMonsterCheck = curTime + 0.2;
				
				local clientPosition = Clockwork.Client:GetPos();
				local dangerLevel = "No Danger";
				local dangerEntity = nil;
				local monster = nil;
				
				for k, v in pairs (ents.FindInSphere(clientPosition, self.checkDistance)) do
					local class = v:GetClass();
					local monsterPosition = v:GetPos();
					local distance = clientPosition:Distance(monsterPosition);
					local canSeeEntity = Clockwork.entity:CanSeeEntity(Clockwork.Client, v);
					
					if (table.HasValue(self.zombieNPCS, class)) then
						if (distance <= self.searchDistance and distance > self.dangerDistance) then
							if (canSeeEntity or distance < ((self.searchDistance - self.dangerDistance) / 2)) then
								dangerLevel = "Search";
							end;
						elseif (distance <= self.dangerDistance and distance > self.attackDistance) then
							dangerLevel = "Danger";
						elseif (distance <= self.attackDistance and distance >= 0) then
							if (canSeeEntity) then
								dangerLevel = "Danger";
							else
								dangerLevel = "Danger";
							end;
						end;
						
						if (Clockwork.Client:GetSharedVar("IsTarget") == true) then
							if (distance <= self.dangerDistance) then
								dangerLevel = "Attack";
							end;
						end;
						
						monster = v;
						dangerEntity = string.sub(tostring(class), 4, -1);
						
						break;
					end;
				end;
				
				monsterSound = nil;

				if (dangerLevel != "No Danger" and dangerEntity != nil) then
					if (dangerLevel == "Search") then
						monsterSound = "begotten/npc/"..dangerEntity.."/music/search_"..dangerEntity..".wav";
					elseif (dangerLevel == "Danger") then
						monsterSound = "begotten/npc/"..dangerEntity.."/music/dan_"..dangerEntity..".wav";
					elseif (dangerLevel == "Attack") then
						monsterSound = "begotten/npc/"..dangerEntity.."/music/att_"..dangerEntity..".wav";
					end;
				end;

				if (monsterSound != nil) then
					if (IsValid(monster)) then
						if (monsterSound != oldMonsterSound) then
							if (dangerLevel != "No Danger") then
								if (monsterPatch and monsterSound != oldMonsterSound and !self.monsterFading) then
									monsterPatch:FadeOut(1);
									self.monsterFading = true;
									
									timer.Simple(1, function()
										monsterPatch = nil;
									end);
								end;
								
								if (!monsterPatch) then
									monsterPatch = CreateSound(Clockwork.Client, monsterSound);
									
									if (!monsterPatch:IsPlaying() and monster and monster:GetPos():Distance(Clockwork.Client:GetPos()) <= self.checkDistance) then
										monsterPatch:PlayEx(1, 100);
										self.monsterFading = nil;
									end;
								end;
								
								oldMonsterSound = monsterSound;
							end;
						else
							if (dangerLevel != "No Danger") then
								if (!monsterPatch) then
									monsterPatch = CreateSound(Clockwork.Client, monsterSound);
									
									if (!monsterPatch:IsPlaying()) then
										monsterPatch:PlayEx(1, 100);
										self.monsterFading = nil;
										
										oldMonsterSound = monsterSound;
									end;
								end;
							end;
						end;
					else
						if (monsterPatch and !self.monsterFading) then
							if (monsterPatch and !self.monsterFading) then
								monsterPatch:FadeOut(20);
								self.monsterFading = true;
								
								timer.Simple(20, function()
									monsterPatch = nil;
								end);
							end;
						end;
					end;
				else
					if (monsterPatch and !self.monsterFading) then
						if (monsterPatch and !self.monsterFading) then
							monsterPatch:FadeOut(20);
							self.monsterFading = true;
							
							timer.Simple(20, function()
								monsterPatch = nil;
							end);
						end;
					end;
				end;

				local inRangeOfMonster = false;
				local isSuitor = false;

				for k, v in pairs (ents.FindInSphere(clientPosition, 750)) do
					local class = v:GetClass();

					if (table.HasValue(self.zombieNPCS, class)) then
						--if (Clockwork.entity:CanSeeEntity(Clockwork.Client, v)) then
							inRangeOfMonster = true;
							
							if (class == "cw_suitor") then
								isSuitor = true;
							end;
						--end;
					end;
				end;
				
				if (inRangeOfMonster and !Clockwork.Client.CantHearTerror) then
					terrorTrack = "begotten/ui/terror_meter_lp.wav";
					whineTrack = "begotten/ambient/horror/hallucination/whine_loop3.wav";

					local volume = 1;
					
					if (!terrorPatch and terrorTrack != nil) then
						terrorPatch = CreateSound(Clockwork.Client, terrorTrack);

						if (!terrorPatch:IsPlaying()) then
							terrorPatch:PlayEx(0, 100);
							terrorPatch:ChangeVolume(volume, 3);
						end;
					end;
					
					if (isSuitor) then
						if (!whinePatch and whineTrack != nil) then
							whinePatch = CreateSound(Clockwork.Client, whineTrack);
							
							local whineVolume = volume / 4;
							
							if (Clockwork.Client:HasTrait("delusional")) then
								whineVolume = 1;
							end;
							
							if (!whinePatch:IsPlaying()) then
								whinePatch:PlayEx(0.5, 100);
								whinePatch:ChangeVolume(whineVolume, 3);
							end;
						end;
					end;
				else
					if (terrorPatch) then
						timer.Simple(5, function()
							if (terrorPatch) then
								terrorPatch:FadeOut(1);
								terrorPatch = nil;
							end;
						end);
					end;
					
					if (whinePatch) then
						timer.Simple(5, function()
							if (whinePatch) then
								whinePatch:FadeOut(1);
								whinePatch = nil;
							end;
						end);
					end;
				end;
			end;
		else
			if (monsterPatch) then
				monsterPatch:Stop();
				monsterPatch = nil;
			end;

			if (terrorPatch) then
				terrorPatch:Stop();
				terrorPatch = nil;
			end;
			
			if (whinePatch) then
				whinePatch:Stop();
				whinePatch = nil;
			end;
		end;
	end;
	
	for k, v in pairs (ents.FindByClass("cw_zombie")) do
		if (!v.mutated) then
			v.mutated = true;
			
			if (math.random(1, 3) <= 2) then
				for i = 1, math.random(1, 40) do
					if (math.random(1, 3) == 1) then
						v:ManipulateBoneScale(i, Vector(math.Rand(0.8, 1), math.Rand(0.8, 1), math.Rand(0.8, 1)));
					end;
					
					if (math.random(1, 3) == 2) then
						v:ManipulateBonePosition(i, VectorRand() * math.random(-4, 4))
					end;
					
					if (math.random(1, 3) == 3) then
						v:ManipulateBoneAngles(i, Angle(math.random(-20, 0), math.random(-10, 10), math.random(-30, 30)));
					end;
				end;
				
				if (v:GetModel() and string.find(v:GetModel(), "female")) then
					if (math.random(1, 2) == 2) then
						v:ManipulateBonePosition(6, Vector(-2, -2, -2));
					end;
					
					v:ManipulateBoneAngles(6, Angle(table.Random({70, 90, 50, -70, -90, -50, 60, -60}) + math.random(-10, 10), math.random(-10, 10), math.random(-10, 10)));
				end;
			end;
		end;
	end;
end;]]--

-- Called when the screenspace effects are rendered.
--[[function cwZombies:PostDrawOpaqueRenderables()
	local entitiesInSphere = ents.FindInSphere(Clockwork.Client:GetPos(), 512);
	
	for k, v in pairs (entitiesInSphere) do
		local class = v:GetClass();
		
		if (IsValid(v) and class == "npc_citizen" or class == "npc_gman") then
			if (!string.find(v:GetModel(), "surviv")) then
			local clientPosition = LocalPlayer():GetPos();
			local entityPosition = v:GetPos();
			local distance = clientPosition:Distance(entityPosition);
			local headBone = v:LookupBone("ValveBiped.Bip01_Head1");
			
			if (headBone and distance < 320) then
				local bonePosition, boneAngles = v:GetBonePosition(headBone);
				local eyes = v:LookupAttachment("eyes");
				local eyesAttachment = v:GetAttachment(eyes);
				
				if (bonePosition and eyesAttachment) then
					local glowColor = Color(255, 150, 0, 255);
					local eyePos = EyePos();
					local forward = eyesAttachment.Ang:Forward();
					local right = eyesAttachment.Ang:Right();
					local position = eyesAttachment.Pos
					local difference = (eyePos - position);
					local differenceAngle = difference:Angle();
					local differenceForward = differenceAngle:Forward();
					local firstEye = position + (forward * 0.6) + (right * -1.25) + (differenceForward * 1);
					local secondEye = position + (forward * 0.6) + (right * 1.25) + (differenceForward * 1);
					
					render.SetMaterial(cwZombies.glowMaterial);
					render.DrawSprite(firstEye, 2, 1.8, glowColor);
					render.DrawSprite(secondEye, 2, 1.8, glowColor);
				end;
			end;
		end;
	end; end;
end;]]--

-- A function to get the admin ESP info.
function cwZombies:GetAdminESPInfo(info)
	if (CW_CONVAR_ZOMBIEESP:GetInt() == 1) then
		for k, v in ipairs(ents.FindByClass("npc_bgt_*")) do
			local class = v:GetClass();
			
			if (table.HasValue(self.zombieNPCS, class)) then
				local informationColor = Clockwork.option:GetColor("information");
				local maxHealth = v:GetMaxHealth();
				local health = v:Health();

				info[#info + 1] = {
					position = v:GetPos() + Vector(0, 0, 64),
					text = {
						{text = v.PrintName, color = informationColor},
						{text = "Health: ["..health.." / "..maxHealth.."]", color = informationColor}
					}
				};
			end;
		end;
		
		for k, v in ipairs(ents.FindByClass("npc_animal_*")) do
			local informationColor = Clockwork.option:GetColor("information");
			local maxHealth = v:GetMaxHealth();
			local health = v:Health();

			info[#info + 1] = {
				position = v:GetPos() + Vector(0, 0, 64),
				text = {
					{text = v.PrintName, color = informationColor},
					{text = "Health: ["..health.." / "..maxHealth.."]", color = informationColor}
				}
			};
		end
	end;
end;

-- Called when the screenspace effects are rendered.
--[[function cwZombies:RenderScreenspaceEffects()
	local curTime = CurTime();
	local clientPosition = Clockwork.Client:GetPos();
	
	for k, v in pairs(ents.FindByClass("cw_*")) do
		if ((v:IsNPC() or v:IsNextBot()) and v.GetClass and table.HasValue(self.zombieNPCS, v:GetClass())) then
			local entity = v;
			local entityPosition = entity:GetPos();
			local distance = entityPosition:Distance(clientPosition);
			
			if (distance < 500) then
				local dynamicLight = DynamicLight(entity:EntIndex().."_light");
				
				if (dynamicLight) then
					local foward = entity:GetForward();
					local obbMax = entity:OBBMaxs();
					
					dynamicLight.Pos = entityPosition + (foward * 20) + Vector(0, 0, obbMax.z * 0.8);
					dynamicLight.Brightness = 1;
					dynamicLight.r = 100;
					dynamicLight.g = 0;
					dynamicLight.b = 0;
					dynamicLight.Size = math.Clamp(400 - distance, 0, 120);
					dynamicLight.Decay = 0.3;
					dynamicLight.DieTime = curTime + 0.1;
					dynamicLight.Style = 1;
				end;
			end;
		end;
	end;
end;]]--