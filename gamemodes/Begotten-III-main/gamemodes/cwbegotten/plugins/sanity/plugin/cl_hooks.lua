--[[
	Begotten III: Jesus Wept
--]]

local hallucinationModels = {"models/undead/charple01.mdl", "models/skeleton/skeleton_whole.mdl"};
local medSanitySounds = {"begotten/ambient/atmosphere/apocalypse/hits/hit_1.wav", "begotten/ambient/atmosphere/apocalypse/hits/hit_2.wav", "begotten/ambient/atmosphere/apocalypse/hits/hit_3.wav", "begotten/ambient/atmosphere/apocalypse/hits/hit_4.wav", "damnation/apocalypt/metal4.mp3", "damnation/apocalypt/metal10.mp3", "damnation/apocalypt/metal11.mp3", "damnation/apocalypt/metal12.mp3", "damnation/apocalypt/metal17.mp3", "damnation/apocalypt/metal18.mp3", "damnation/apocalypt/metal19.mp3", "damnation/apocalypt/strange3.mp3", "damnation/apocalypt/woosh2.mp3", "begotten/ui/spine_tingeling.mp3"};
local lowSanitySounds = {"damnation/apocalypt/ambience_echos.mp3", "begotten2/doom_moan.wav", "damnation/apocalypt/ambience_horn.mp3", "damnation/apocalypt/ambience_lonely.mp3", "damnation/apocalypt/ambience_ladder1.mp3", "damnation/apocalypt/ambience_metal4.mp3", "damnation/apocalypt/ambience_open.mp3", "damnation/apocalypt/ambience_door.mp3", "damnation/apocalypt/ambience_exhale.mp3", "damnation/apocalypt/ambience_silence.mp3", "damnation/apocalypt/whisper2.mp3", "damnation/apocalypt/whisper3.mp3"};
local sanityTexts = {"...", "Insane", "Losing Sanity", "Sane", "Sanity is a measure of your character's mental condition: the lower it gets the more detached from reality they will become. Witnessing or partaking in disturbing acts is detrimental to one's sanity."};

-- Called when the bars are needed.
--[[function cwSanity:GetBars(bars)
	local sanity = Clockwork.Client:GetNetVar("sanity", 100)
	
	if (sanity) then
		if (!self.sanity) then
			self.sanity = sanity
		elseif (sanity != self.sanity) then
			self.sanity = math.Approach(self.sanity, sanity, FrameTime() * (16 * math.Clamp(((self.sanity - sanity) / 10), 1, 10)))
		end
		
		if (sanity < 100) then
			bars:Add("sanity", Color(100, 50, 100), "sanity", self.sanity, 100, self.sanity < 10)
		end
	end
end]]--

function cwSanity:CanPlayAmbientMusic()
	local sanity = Clockwork.Client:Sanity() or 100;
	
	if sanity <= 20 then
		return false;
	end
end

function cwSanity:CanPlayBattleMusic()
	local sanity = Clockwork.Client:Sanity() or 100;
	
	if sanity <= 20 then
		return false;
	end
end

-- Called when the opaque renderables are drawn.
function cwSanity:PostDrawOpaqueRenderables()
	if (Clockwork.Client:HasInitialized() and Clockwork.Client:Alive()) then
		local sanity = Clockwork.Client:Sanity() or 100;
		local position = Clockwork.Client:GetPos();
		
		if (sanity <= 20) then
			for k, v in pairs (ents.FindInSphere(position, 512)) do
				local moveType = v:GetMoveType();
				
				if (v:IsPlayer() and (moveType == MOVETYPE_WALK or moveType == MOVETYPE_LADDER) and v != Clockwork.Client) then
					local model = v:GetModel();
					
					if (string.find(model, "humans")) then
						local clientPosition = LocalPlayer():GetPos();
						local entityPosition = v:GetPos();
						local distance = clientPosition:Distance(entityPosition);
						local headBone = v:LookupBone("ValveBiped.Bip01_Head1");
						
						if (headBone and distance < 512) then
							local bonePosition, boneAngles = v:GetBonePosition(headBone);
							local eyes = v:LookupAttachment("eyes");
							local eyesAttachment = v:GetAttachment(eyes);
							
							if (bonePosition and eyesAttachment) then
								local glowColor = Color(200, 0, 0, 255);
								local eyePos = EyePos();
								local forward = eyesAttachment.Ang:Forward();
								local right = eyesAttachment.Ang:Right();
								local position = eyesAttachment.Pos
								local difference = (eyePos - position);
								local differenceAngle = difference:Angle();
								local differenceForward = differenceAngle:Forward();
								local firstEye = position + (forward * 0.6) + (right * -1.25) + (differenceForward * 1);
								local secondEye = position + (forward * 0.6) + (right * 1.25) + (differenceForward * 1);
								
								render.SetMaterial(glowMaterial);
								render.DrawSprite(firstEye, 2, 1.8, glowColor);
								render.DrawSprite(secondEye, 2, 1.8, glowColor);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;

function cwSanity:Think()
	if Clockwork.Client:HasInitialized() then
		local curTime = CurTime()
		local sanity = Clockwork.Client:Sanity();
		
		if sanity <= 20 and Clockwork.Client:Alive() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT then
			if !self.sanityAmbience then
				self.sanityAmbience = CreateSound(Clockwork.Client, "begotten2/tone_alley.wav");
				self.sanityAmbience:Play();
				
				if cwMusic then
					if cwMusic.AmbientMusic then
						cwMusic:FadeOutAmbientMusic(4, 1);
					end
					
					if cwMusic.BattleMusic then
						cwMusic:FadeOutBattleMusic(4, 1);
					end
				end
			end
			
			if Clockwork.Client:GetMoveType() ~= MOVETYPE_NOCLIP then
				if !self.nextSanityHallucination then
					self.nextSanityHallucination = curTime + math.random(300, 1500);
				end

				if self.nextSanityHallucination <= curTime then
					local player = Clockwork.Client;
					local hallucinationModel = ClientsideModel(table.Random(hallucinationModels), RENDERGROUP_OPAQUE);
					
					hallucinationModel:SetSequence(hallucinationModel:LookupSequence("idle"));
					hallucinationModel:SetPos(player:GetPos() + (player:GetForward() * 32) + Vector(0, 0, 2));
					hallucinationModel:SetAngles(player:GetAngles() + Angle(0, 180, 0));
					hallucinationModel:SetParent(player);
					hallucinationModel:Spawn();
					
					player:EmitSound("begotten/slender.wav");

					timer.Simple(0.1, function()
						if IsValid(hallucinationModel) then
							hallucinationModel:Remove();
						end
					end);
					
					self.nextSanityHallucination = curTime + math.random(300, 1500);
				end
			end
		else
			if self.nextSanityHallucination then
				self.nextSanityHallucination = nil;
			end
		
			if self.sanityAmbience and self.sanityAmbience ~= "fading" then
				if Clockwork.kernel:IsChoosingCharacter() then
					self.sanityAmbience:Stop();
					self.sanityAmbience = nil;
				else
					self.sanityAmbience:FadeOut(4);
					self.sanityAmbience = "fading";
					
					timer.Simple(4, function()
						self.sanityAmbience = nil;
					end);
				end
				
				for i, v in ipairs(lowSanitySounds) do
					Clockwork.Client:StopSound(v);
				end
			end
		end
		
		if !self.itemSpeakTimer then
			self.itemSpeakTimer = curTime + math.random(180, 480);
		end
		
		if self.itemSpeakTimer < curTime then
			self.itemSpeakTimer = curTime + math.random(120, 240);
		
			if Clockwork.Client:Alive() and sanity <= 50 and Clockwork.Client:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT and !Clockwork.player:IsNoClipping(Clockwork.Client) and !Clockwork.Client.victim then
				local corpseFound;
				local itemFound;
				local radioFound;
				
				for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 256)) do
					if (v:GetClass() == "prop_ragdoll") then
						local nwEntity = v:GetNWEntity("Player");
						
						if (nwEntity:IsPlayer() and !nwEntity:Alive()) or nwEntity == game.GetWorld() or v:GetModel() == "models/undead/charple01.mdl" then
							corpseFound = v;
							break;
						end
					elseif (v:GetClass() == "cw_item") then
						itemFound = v;
						break;
					elseif (v:GetClass() == "cw_radio") then
						radioFound = v;
						break;
					end
				end
				
				if corpseFound then
					if cwBeliefs and cwBeliefs:HasBelief("savage") then
						local cannibalSaying = self.cannibalSayings[math.random(1, #self.cannibalSayings)];
						
						if corpseFound:GetNWEntity("Player"):IsPlayer() then
							local name = "The corpse";

							if Clockwork.player:DoesRecognise(corpseFound:GetNWEntity("Player")) then
								name = corpseFound:GetNWEntity("Player"):Name();
							else
								local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(corpseFound:GetNWEntity("Player"));
								
								if (usedPhysDesc and string.utf8len(unrecognisedName) > 24) then
									unrecognisedName = string.utf8sub(unrecognisedName, 1, 21).."...";
								end;
								
								name = "["..unrecognisedName.."]";
							end
							
							Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), name.." says \""..cannibalSaying.."\"");
						else
							Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "The corpse says \""..cannibalSaying.."\"");
						end
					else
						local corpseSaying = self.corpseSayings[math.random(1, #self.corpseSayings)];
						
						if corpseFound:GetNWEntity("Player"):IsPlayer() then
							local name = "The corpse";

							if Clockwork.player:DoesRecognise(corpseFound:GetNWEntity("Player")) then
								name = corpseFound:GetNWEntity("Player"):Name();
							else
								local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(corpseFound:GetNWEntity("Player"));
								
								if (usedPhysDesc and string.utf8len(unrecognisedName) > 24) then
									unrecognisedName = string.utf8sub(unrecognisedName, 1, 21).."...";
								end;
								
								name = "["..unrecognisedName.."]";
							end
						
							Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), name.." says \""..corpseSaying.."\"");
						else
							Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "The corpse says \""..corpseSaying.."\"");
						end
					end
				elseif itemFound then
					local itemTable = itemFound:GetItemTable();
					
					if itemTable and self.itemSayings[itemTable.category] then
						local itemSaying = self.itemSayings[itemTable.category][math.random(1, #self.itemSayings[itemTable.category])];
						
						Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "The "..itemTable.name.." says \""..itemSaying.."\"");
					end
				elseif radioFound then
					Clockwork.chatBox:Add(nil, nil, Color(75, 150, 50, 255), "The radio emits: \""..self.radioSayings[math.random(1, #self.radioSayings)].."\"");
					
					sound.Play("radio/radio_out"..tostring(math.random(2, 3))..".wav", radioFound:GetPos(), 80, 100, 1);
				else
					local inventory = Clockwork.inventory:GetClient();
					
					if math.random(1, 2) == 1 and Clockwork.inventory:HasItemInstance(inventory, "handheld_radio") and Clockwork.Client.radioState then
						Clockwork.chatBox:Add(nil, nil, Color(75, 150, 50, 255), "Your handheld radio emits: \""..self.radioSayings[math.random(1, #self.radioSayings)].."\"");
						
						Clockwork.Client:EmitSound("radio/radio_out"..tostring(math.random(2, 3))..".wav");
					elseif table.Count(inventory) > 3 then
						Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "***' You hear a muffled voice coming from your backpack \""..self.backpackSayings[math.random(1, #self.backpackSayings)].."\"");
					end
				end
			end
		end
		
		if (sanity <= 40 and Clockwork.Client:Alive() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT and !Clockwork.Client.dueling and !Clockwork.player:IsNoClipping(Clockwork.Client)) then
			local has_saintly_composure = (cwBeliefs and cwBeliefs:HasBelief("saintly_composure"));
			
			if !has_saintly_composure then
				if (sanity <= 20) then 
					if !self.nextSanitySound or self.nextSanitySound < curTime then
						self.nextSanitySound = curTime + math.random(40, 60);
					
						Clockwork.Client:EmitSound(table.Random(lowSanitySounds), 60);
					end
				else
					if !self.nextSanitySound or self.nextSanitySound < curTime then
						self.nextSanitySound = curTime + math.random(20, 60);
					
						Clockwork.Client:EmitSound(table.Random(medSanitySounds), 60, math.random(75, 100));
					end
				end
				
				local traceLine = nil;
				local position = Clockwork.Client:GetPos();

				if (!self.nextCockroachCheck) then
					self.nextCockroachCheck = curTime + 5;
				elseif (self.nextCockroachCheck < curTime) then
					local trace = {};
						trace.start = position;
						trace.endpos = position + Vector(0, 0, 300);
						trace.filter = {Clockwork.Client};
					traceLine = util.TraceLine(trace);
					
					self.allowedToSee = true;
					self.nextCockroachCheck = curTime + 1;
				end;
				
				if (traceLine and (!traceLine.Hit or (traceLine.HitPos and traceLine.HitPos.z - position.z > 300))) then
					self.allowedToSee = false;
					
					for k, v in pairs(self.cockroaches) do
						if (IsValid(v)) then
							v:Remove();
						end;
					end;
					
					self.cockroaches = {};
				elseif (self.allowedToSee) then
					local eyeAngles = Clockwork.Client:EyeAngles();
					local eyePos = Clockwork.Client:EyePos();
					local lightColor = render.GetLightColor(position);
					local lightColorDark = ((lightColor.r * 255) + (lightColor.g * 255) + (lightColor.b * 255)) / 3;
					local isDark = lightColorDark > 26;
					local aimVector = eyePos + (Clockwork.Client:GetAimVector() * 20);

					for k, v in pairs(self.cockroaches) do
						if (IsValid(v)) then
							local cockroachAngle = v:GetAngles();
							local cockroachPos = v:GetPos();
							
							if ((!v.sequenceDuration or v.sequenceDuration < curTime) and v.animation) then 
								local sequence = v.animation;
								
								v.sequenceDuration = curTime + v:SequenceDuration(sequence);
								v:ResetSequence(sequence);
							end;
							
							local groundPosition = cockroachPos;
							
							local trace = {};
								trace.start = groundPosition + Vector(0, 0, 30);
								trace.endpos = trace.start - Vector(0, 0, 130);
								trace.filter = {v, Clockwork.Client};
							local traceLine = util.TraceLine(trace);
							
							groundPosition = traceLine.HitPos;
							
							if (v.newPosition) then
								v:SetPos(v.newPosition + (cockroachAngle:Forward() * (math.max(0.05, (math.Rand(0.01, 0.3) * math.Rand(0.3, 1.2))))));
								groundPosition = v.newPosition;
								v.newPosition = nil;
							else
								v:SetPos(groundPosition + (cockroachAngle:Forward() * ((math.Rand(0.01, 0.3) * 2.2) * math.Rand(0.5, 1.2))));
								v.addAngles = math.random(-10, 10);
								
								if (!v.angle) then
									v:SetAngles(Angle(0, cockroachAngle.yaw + v.addAngles,0));
								end;
							end;
							
							if (!v.chance) then
								if (v.addPos) then
									v.chance = 36;
								else
									v.chance = 1;
								end;
							end;
							
							if (math.random(1, 4) <= 2) then
								if (math.random(1, (v.addPos and 3000 or 6002) - (sanity * 2)) <= v.chance) then
									sound.Play("physics/wood/wood_strain"..math.random(2, 5)..".wav", cockroachPos, 40, math.random(140, 200));
								end;

								if (v.addAngles > 0) then
									v.addAngles = -5;
									v.newAngles = (v.newAngles or 0) + v.addAngles;
								else
									v.addAngles = 5;
									v.newAngles = (v.newAngles or 0) + v.addAngles;
								end;
							end;
							
							local distance = cockroachPos:Distance(position);
							
							if (v.addPos and lightColorDark <= 10) then
								v.speed = math.Rand(0.01, 0.3) * 2.2;
								
								if (lightColorDark > 30) then
									v.speed = v.moveSpeed * 2;
								end;
								
								v.addPos = v.addPos + (v:GetForward() * v.speed);
								v:SetPos(aimVector + v.addPos);
								
								local newAngles = (eyePos - aimVector):Angle() + Angle(90, 0, 0);
								
								if ((!v.newAngles)) then
									v.newAngles = math.random(0, 360);
								end;
								
								if (!isDark) then
									if (math.random(1, 4) <= 3) then
										v.newAngles = v.newAngles + math.random(-20, 20);
									end;
								end;
								
								newAngles:RotateAroundAxis(newAngles:Up(), v.newAngles);
								v:SetAngles(newAngles);
								
								if ((aimVector + v.addPos):Distance(aimVector) > 60 and !isDark) then
									v:SetPos(aimVector);
									v.addPos = VectorRand() * math.random(1, 30);
									v.isScreenRoach = true;
								end;
							else
								if ((((distance >= 100 or math.abs(cockroachPos.z - position.z) > 4) and eyeAngles.pitch < -1) or distance > 500)) then
									if (distance > 200) then
										v.newPosition = position;
									else
										v.speed = v.moveSpeed * 2;
									end;
									
									v:SetAngles(Angle(0, ((position + v:GetRight() * 100) - cockroachPos):Angle().yaw + math.random(-20, 20), 0));
								else
									v.speed = v.moveSpeed * math.Rand(0.5, 1);
									
									if (isDark) then
										v.speed = v.moveSpeed * 5;
									end;
								end;
							end;
							
							if (isDark) then
								v.speed = v.moveSpeed * 5;
							end;
							
							if (lightColorDark > 26) then
								v.speed = 2;
							else
								if (v.isScreenRoach) then
									v:SetColor(Color(0, 0, 0, 0));
									v.isScreenRoach = false;
									
									timer.Simple(math.Rand(0.3, 2), function()
										if (IsValid(v)) then
											v:SetColor(Color(0, 0, 0, 255));
										end;
									end);
								end;
							end;
						end;
					end;
					
					local cockroachNumber = math.min(80, -(sanity - 40) * 2) + 1;
					
					if ((#self.cockroaches < cockroachNumber and Clockwork.Client:EyeAngles().p < 0)) then
						if #self.cockroaches <= 0 then
							if ((!Clockwork.Client.nextInfection or curTime > Clockwork.Client.nextInfection)) then
								Clockwork.Client.nextInfection = curTime + 10;
								
								Clockwork.Client:EmitSound("begotten/l4d2/infection"..math.random(1, 3)..".mp3", 500);
							end;
						end
					
						for i = 1, math.Clamp(cockroachNumber - #self.cockroaches, 0, 10) do
							local cockroach = ClientsideModel("models/antlion_grub.mdl", RENDERGROUP_BOTH);
							local color = math.Rand(1.5, 2) * 100;
							local modelScale = math.Rand(0.1, 0.2) + (math.Rand(0.05, 0.1) * (100 / (-sanity + 100))) / 2;
							
							cockroach:SetMaterial("models/headcrab_classic/headcrabsheet");
							cockroach:SetRenderMode(RENDERMODE_TRANSALPHA);
							cockroach:SetColor(Color(color, color, color, 255))
							cockroach:SetModelScale(cockroach:GetModelScale() * modelScale);
							cockroach:SetAngles(Angle(0, math.random(0, 360), 0));
							cockroach.addAngles = 1;
							cockroach.moveSpeed = 5;
							
							local randomChance = math.random(1, 12);

							if (randomChance == 1) then
								cockroach.addPos = VectorRand() * math.random(1, 40) 
								cockroach.speed = 0.05
								cockroach.moveSpeed = 0.05
								
								local newAngles = (eyePos - aimVector):Angle() + Angle(90, 0, 0);
								
								if (cockroach.newAngles) then
									cockroach.newAngles = math.random(0, 360);
									newAngles:RotateAroundAxis(newAngles:Up(), cockroach.newAngles);
								end;
								
								cockroach:SetAngles(newAngles);
								
								timer.Simple(math.Rand(0.1, 2), function()
									if (IsValid(cockroach)) then
										cockroach:SetColor(Color(20, 14, 12, 255));
									end;
								end);
								
								modelScale = math.Rand(0.25, 0.9);
								
								cockroach:DrawShadow(false);
								cockroach:SetColor(Color(0, 0, 0, 255));
								cockroach:SetMaterial("models/debug/debugwhite");
								cockroach:SetModelScale(modelScale * 0.15, 1);
							end;
							
							local trace = {};
								trace.start = position + (Vector(math.random(-150, 150) ,math.random(-150, 150), 0) * math.Rand(0.5, 1));
								trace.endpos = (trace.start - Vector(0, 0, 100));
								trace.filter = {cockroach, Clockwork.Client};
								trace.mask = MASK_SOLID;
							local traceLine = util.TraceLine(trace);
							
							cockroach:SetPos(traceLine.HitPos - Vector(0, 0, 1));
							self.cockroaches[#self.cockroaches + 1] = cockroach;
						end;
					else
						for k, v in pairs(self.cockroaches) do
							if (IsValid(v)) then
								local cockroachPosition = v:GetPos();
								local distance = cockroachPosition:Distance(position);
								
								if (IsValid(v) and k > cockroachNumber and !v.shouldRemove) then
									v.shouldRemove = true;
									v.moveSpeed = 5;
									v.angle = v:GetAngles();
								elseif (IsValid(v) and v.shouldRemove and distance > 100) then
									v:Remove();
									
									self.cockroaches[k] = nil;
								end;
							end;
						end;
					end;
				end;
			else
				if (#self.cockroaches > 0) then
					for k, v in pairs(self.cockroaches) do
						if (IsValid(v)) then
							v:Remove();
						end;
					end;
				end;
			end;
		else
			if (#self.cockroaches > 0) then
				for k, v in pairs(self.cockroaches) do
					if (IsValid(v)) then
						v:Remove();
					end;
				end;
			end;
		end;
		
		if (!Clockwork.Client:Alive() and #self.cockroaches > 0) then
			for k, v in pairs(self.cockroaches) do
				if (IsValid(v)) then
					v:Remove();
				end;
			end;
		end;
	end
end

-- Called when the screenspace effects are rendered.
function cwSanity:RenderScreenspaceEffects()
	if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() then
		local sanity = Clockwork.Client:Sanity() or 100;
		local has_saintly_composure = (cwBeliefs and cwBeliefs:HasBelief("saintly_composure"));
		local position = Clockwork.Client:GetPos();
		local curTime = CurTime();
		local frameTime = FrameTime();

		if !self.insanitySkeletons then
			self.insanitySkeletons = {};
		end
		
		for k, v in pairs(self.insanitySkeletons) do 
			local entity = Entity(k);
			
			if (!IsValid(entity) or (entity:GetMoveType() != MOVETYPE_WALK and entity:GetMoveType() != MOVETYPE_LADDER) or !IsValid(v) or v:GetParent() ~= entity) then
				if (IsValid(v)) then
					v:Remove();
				end;
				
				self.insanitySkeletons[k] = nil
			elseif (sanity > 20) and !has_saintly_composure then
				if (IsValid(v)) then
					v:Remove();
				end;
				
				self.insanitySkeletons[k] = nil;
				entity:SetRenderMode(RENDERMODE_TRANSALPHA);
				entity:SetColor(Color(255, 255, 255, 255));
			end;
		end;

		if (sanity <= 20) and !has_saintly_composure and !Clockwork.Client.victim then 
			local shouldPlay = false

			for k, v in pairs(player.GetAll()) do
				if (v != Clockwork.Client) then
					local playerIndex = v:EntIndex();
					local playerPosition = v:GetPos();
					local distance = playerPosition:DistToSqr(position);
					local moveType = v:GetMoveType();
					
					if (moveType == MOVETYPE_WALK or moveType == MOVETYPE_LADDER) and distance < (750 * 750) then
						if (!IsValid(self.insanitySkeletons[playerIndex])) then
							local skeletonEnt = ClientsideModel("models/skeleton/skeleton_whole.mdl", RENDERGROUP_OPAQUE)
							
							skeletonEnt:SetParent(v);
							skeletonEnt:SetRenderMode(RENDERMODE_TRANSALPHA);
							skeletonEnt:SetColor(Color(255, 255, 255, 0));
							skeletonEnt:AddEffects(EF_BONEMERGE);
							skeletonEnt:SetSkin(2);
							
							v:SetRenderMode(RENDERMODE_TRANSALPHA);
							v:SetColor(Color(255, 255, 255, 255));
							
							if v:GetColor().a > 0 then
								local repetition = 0;
								
								timer.Create(playerIndex.."_skeletonDecay", 0.01, 255, function()
									if (IsValid(self.insanitySkeletons[playerIndex]) and IsValid(v)) then
										repetition = repetition + 1;
										
										v:SetRenderMode(RENDERMODE_TRANSALPHA);
										v:SetColor(Color(255, 255, 255, 255 - math.Clamp(repetition, 0, 255)));
										self.insanitySkeletons[playerIndex]:SetColor(Color(255, 255, 255, 0 + repetition));
									end;
								end);
							else
								v:SetRenderMode(RENDERMODE_TRANSALPHA);
								v:SetColor(Color(255, 255, 255, 0));
								skeletonEnt:SetColor(Color(255, 255, 255, 255));
							end
							
							self.insanitySkeletons[playerIndex] = skeletonEnt;
								
							--shouldPlay = true;
						end
						
						local dynamicLight = DynamicLight(playerIndex);
						local eyePos = v:EyePos();
						local curTime = CurTime();
						
						if (dynamicLight) then
							dynamicLight.pos = eyePos;
							dynamicLight.r = 255;
							dynamicLight.g = 200;
							dynamicLight.b = 200;
							dynamicLight.brightness = 0.5;
							dynamicLight.Decay = 1000;
							dynamicLight.Size = 128;
							dynamicLight.DieTime = curTime + 1;
						end;
					end;
					
					if (shouldPlay) and !Clockwork.Client.LoadingText then
						Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 40);
						
						timer.Simple(0.4, function() 
							Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 60);
						end);
						
						shouldPlay = false;
					end;
				end;
			end;
		end;
		
		if (sanity <= 50) then
			if !Clockwork.Client:GetNetVar("senses") then
				if (!self.contrastAdd) then
					self.contrastAdd = 0;
				end;

				local sanityModify = {};
					sanityModify["$pp_colour_brightness"] = 0 + (self.contrastAdd * 0.1);
					sanityModify["$pp_colour_contrast"] = 1 + self.contrastAdd;
					sanityModify["$pp_colour_addg"] = (0 - self.contrastAdd);
					sanityModify["$pp_colour_addb"] = (0 - self.contrastAdd);
				DrawColorModify(sanityModify);
				
				self.contrastAdd = math.Approach(self.contrastAdd, math.Remap(sanity, 0, 50, 0.1, 0), frameTime * 0.25);
			end
		end;
	end;
end;

-- Called when the F1 Text is needed.
function cwSanity:PostMainMenuRebuild(menu)
	if IsValid(menu) then
		local sanity = Clockwork.Client:GetNetVar("sanity", 100)

		self.sanity = sanity

		if IsValid(menu.statusInfo) then
			local sanityColor = Color(150 - sanity, sanity, 0, 225);
			
			menu.statusInfo.iconFrame.iconSanity:SetColor(sanityColor);
			menu.statusInfo.iconFrame.iconSanity.text:SetTextColor(sanityColor);
			menu.statusInfo.iconFrame.iconSanity.text:SetText(tostring(math.Round(sanity)).."%");
		end
	end;
end

function cwSanity:PlayerCanShowUnrecognised(player, x, y, color, alpha, flashAlpha)
	if player:Alive() then
		local sanity = Clockwork.Client:GetNetVar("sanity", 100)
		
		if (sanity <= 30 and sanity > 20) then
			return "All you see is a worthless fucking piggy ready to be slaughtered.";
		elseif (sanity <= 20) then
			return "...";
		end;
	end;
end;

-- A function to get sanity's markup tooltip.
function cwSanity:BuildSanityTooltip(x, y, width, height, frame)
	local sanity = Clockwork.Client:GetNetVar("sanity", 100)
	
	if sanity then
		local sanityColor = Color(100 - sanity, sanity, 0, 225);
		local selectedText = math.Clamp(math.Round(sanity / 25), 1, 4);
		
		frame:AddText("Sanity", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(sanityTexts[5], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		frame:AddBar(20, {{text = tostring(sanity).."%", percentage = sanity, color = sanityColor, font = "DermaDefault", textless = true, noDisplay = true}}, sanityTexts[selectedText], sanityColor);
	end
end;

function cwSanity:SpookyScarySkeletons()
	if (!AfT) then AfT = CreateSound(Clockwork.Client, "begotten/npc/brute/music/att_brute.wav") end
	AfT:PlayEx(1, 100)
	AfT:ChangePitch(90, 6)
	timer.Simple(6.5, function()
		AfT:FadeOut(6);
	end);
	Clockwork.Client.SkelesColor = 255;
	cwDayNight:MoonTrigger(true, true)
	if (!SKELES) then
		SKELES = {}
	end;
	Clockwork.Client.CnSkele = nil
	if (SKELES) then
		for k, v in pairs (SKELES) do
			hook.Remove("Think", "t"..tostring(v:EntIndex()))
			v:Remove()
		end
	end
	timer.Simple(6.5, function()
		Clockwork.Client.CnSkele = true
	end);
	for i = 1, 5 do
		SKELES[i] = ClientsideModel("models/begotten/skeleton.mdl", RENDERGROUP_BOTH)
		SKELES[i]:ResetSequence("run_all_panicked")
		SKELES[i]:SetSkin(3)
		SKELES[i]:SetRenderMode(RENDERMODE_TRANSALPHA)
		local nt = i
		hook.Add("Think", "t"..nt, function()
			if (Clockwork.Client.CnSkele) then
				Clockwork.Client.SkelesColor = math.Approach(Clockwork.Client.SkelesColor, 0, FrameTime() * 32)
			end;
			if (IsValid(SKELES[i])) then
				if (!SKELES[i].X or !SKELES[i].Y) then
					SKELES[i].X = 100
					SKELES[i].Y = 100
				end;
				local curtime = CurTime();
				SKELES[i].X = 100 * math.sin(-curtime)
				SKELES[i].Y = math.sin(curtime) * math.sin(-curtime)
				if (!SKELES[i].offset) then
					SKELES[i].offset = math.random(-150, 150)
				end;
				local sr = {[1] = 20,[2] = 0,[3] = -20,[4] = -35,[5] = 35,}
				local srt = {[4] = 10,[5] = 10,}
				local t = Clockwork.Client:GetForward()*35;
				local p = Clockwork.Client:GetPos()
				p.x = p.x + math.Clamp(t.x, 35, 40);
				local POZA = Vector(p.x, p.y, p.z + 10);
				if (sr[i]) then
					POZA.y = POZA.y - sr[i]; 
				end;
				if (srt[i]) then
					POZA.x = POZA.x - srt[i]; 
				end;
				local sta = Clockwork.Client:GetPos() + Clockwork.Client:WorldToLocal(POZA)
				sta.z = p.z + 10
				SKELES[i]:SetPos(sta)
				SKELES[i]:SetAngles(Angle(0, ((Clockwork.Client:GetPos() - SKELES[i]:GetPos()):Angle().yaw), 0));
				if (!SKELES[i].heady) then
					SKELES[i].heady = 0
				else
					SKELES[i].heady = math.Approach(SKELES[i].heady, math.random(-180, 180), FrameTime() * 256)
					if (SKELES[i].heady >= 360) then
						SKELES[i].heady = 0;
					end;
				end;
				SKELES[i]:SetPoseParameter("head_yaw", SKELES[i].heady)
				SKELES[i]:SetPoseParameter("head_pitch", -10)
				SKELES[i]:SetPoseParameter("head_roll", -SKELES[i].heady)
				SKELES[i]:SetColor(Color(255, 255, 255, Clockwork.Client.SkelesColor))
				local dyna = DynamicLight(i);
				if (dyna) then
					dyna.pos = SKELES[i]:GetPos() + Vector(0, 0, 64)
					dyna.r = 100
					dyna.g = 20
					dyna.b = 20
					dyna.brightness = 0.5
					dyna.Decay = 2000
					dyna.Size = 256
					dyna.DieTime = CurTime()
				end;
				if (Clockwork.Client.SkelesColor <= 0 and IsValid(SKELES[i])) then
					SKELES[i]:Remove();
					SKELES[i] = nil;
					hook.Remove("Think", "t"..nt)
				end;
			else
				hook.Remove("Think", "t"..nt)
			end;
		end);
	end;
end;

netstream.Hook("ScarePlayer", function()
	if cwMusic then
		if cwMusic.AmbientMusic then
			cwMusic:StopAmbientMusic();
		end
		
		if cwMusic.BattleMusic then
			cwMusic:StopBattleMusic();
		end
	end

	cwSanity:Scaresae();
end)

netstream.Hook("SpookyScarySkeletons", function()
	cwSanity:SpookyScarySkeletons();
end);