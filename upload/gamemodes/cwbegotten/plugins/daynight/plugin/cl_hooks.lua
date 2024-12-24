--[[
	Begotten III: Jesus Wept
--]]

local moonMat = Material("begotten/effects/bloodmoon.png");
local moonSubMat = Material("begotten/effects/moonsubliminal1.png");
local shadowScreams = {
	"misc/sight_01.wav",
	"misc/sight_02.wav",
	"misc/sight_03.wav",
	"misc/sight_04.wav",
	"misc/chatter_02.ogg",
	"misc/chatter_03.ogg",
};

Clockwork.ConVars.DAYNIGHTMOON = Clockwork.kernel:CreateClientConVar("cwDayNightMoon", 1, true, true)
Clockwork.ConVars.DAYNIGHTHALLUCINATIONS = Clockwork.kernel:CreateClientConVar("cwDayNightHallucinations", 1, true, true)

if !cwDayNight.nightWeight then
	cwDayNight.nightWeight = 0;
end

-- Called every frame.
function cwDayNight:Think()
	if Clockwork.Client:HasInitialized() then
		local curTime = CurTime();
		local cycle = Clockwork.Client.currentCycle;
		
		if self.nightWeight and (self.nightWeight < 1 or self.nightWeight > 0) then
			if !self.nextWeightTick or self.nextWeightTick <= curTime then
				if cycle == "night" then
					self.nightWeight = 1;
				elseif cycle == "daytonight" then
					self.nightWeight = math.Clamp(self.nightWeight + 0.003333333, 0, 1);
				elseif cycle == "nighttoday" then
					self.nightWeight = math.Clamp(self.nightWeight - 0.003333333, 0, 1);
				else
					self.nightWeight = 0;
				end
				
				self.nextWeightTick = curTime + 1;
				
				--printp("Clientside nightweight: "..tostring(self.nightWeight));
			end
		end
	
		if cycle == "night" and Clockwork.Client:GetZone() == "wasteland" and not Clockwork.player:IsNoClipping(Clockwork.Client) and not Clockwork.Client.dueling then
			local flashlightEnabled = Clockwork.Client:FlashlightIsOn();
			local sanity = Clockwork.Client:GetNetVar("sanity", 100);
			local max_shadows = 10;
			local position = Clockwork.Client:GetPos();
			
			if not self.crows then
				self.crows = {};
			end
			
			if not self.shadows then
				self.shadows = {};
			end
			
			if (Clockwork.ConVars.DAYNIGHTHALLUCINATIONS:GetInt() == 1) then
				if not self.moonHallucination then
					if not self.moonHallucinationTimer then
						self.moonHallucinationTimer = curTime + math.random(120, 300);
					end
					
					if curTime >= self.moonHallucinationTimer then
						if (!cwBeliefs or !cwBeliefs:HasBelief("lunar_repudiation")) and util.TraceLine(util.GetPlayerTrace(Clockwork.Client, Clockwork.Client:GetUp())).HitSky then
							self.moonHallucination = true;
							moonSubMat = Material("begotten/effects/moonsubliminal"..tostring(math.random(1, 6))..".png");
							
							timer.Simple(0.5, function()
								self.moonHallucinationTimer = curTime + math.random(120, 300);
								self.moonHallucination = false;
							end);
							
							Clockwork.Client:EmitSound("misc/static05s.wav");
						else
							self.moonHallucinationTimer = curTime + math.random(30, 60);
						end
					end
				end
				
				if (Clockwork.Client:Alive() and Clockwork.Client:HasInitialized()) then
					--if (sanity < 75) then
						if (!Clockwork.Client.nextCrows or curTime > Clockwork.Client.nextCrows) then
							Clockwork.Client.nextCrows = curTime + 16;
							
							local eyeAngles = EyeAngles();
							
							if (#self.crows < 10 and eyeAngles.pitch > 5) then
								local trace = {};
									trace.start = Clockwork.Client:LocalToWorld(Vector(math.random(-200, 200), math.random(-200, 200), 800));
									trace.endpos = trace.start + Vector(0, 0, 500000);
									trace.filter = {Clockwork.Client};
								local traceLine = util.TraceLine(trace);
								
								if (traceLine.HitSky) then
									for i = 1, 10 - #self.crows do 
										local crowModel = ClientsideModel("models/crow.mdl", RENDERGROUP_OPAQUE);
										
										if IsValid(crowModel) then
											local trace = {};
												trace.start = Clockwork.Client:LocalToWorld(Vector(math.random(-200, 200),math.random(-200, 200), 800));
												trace.endpos = trace.start + Vector(0, 0, 760);
												trace.filter = {Clockwork.Client};
											local traceLine = util.TraceLine(trace);
											
											local randomPosition = (traceLine.HitPos - Vector(0, 0, ((traceLine.HitPos.z - position.z) * math.Rand(0.6, 0.9)))) + VectorRand() * 20;
											
											crowModel:SetPos(randomPosition);
											crowModel:SetAngles(Angle(0, math.random(0, 359), 0));
											crowModel.speed = math.Rand(2.5, 3);
											crowModel.position = crowModel:GetPos();
											crowModel.nextFly = curTime;
											crowModel:ResetSequence(0);
											
											table.insert(self.crows, crowModel);
										end
									end;
								end;
							end;
						end;
						
						local soundPlayed = false;
						local trace = {};
							trace.start = Clockwork.Client:GetPos();
							trace.endpos = trace.start + Vector(0, 0, 100000);
							trace.filter = {Clockwork.Client};
						local traceLine = util.TraceLine(trace);

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
										self.crows[k]:Remove();
										self.crows[k] = nil;
									end;
								else
									self.crows[k] = nil;
								end;
							end;
						end;
					--end
				end;

				for k, v in pairs(self.shadows) do
					local shadowPosition = v:GetPos();
					local distance = shadowPosition:DistToSqr(position);
					
					if not v.timeLeft then
						v.timeLeft = curTime + math.random(90, 120);
					end
					
					if (!IsValid(v)) then
						self.shadows[k] = nil 
					elseif (curTime >= v.timeLeft) then
						v:Remove();
						self.shadows[k] = nil;
					elseif (distance > 1024 * 1024) then
						v:Remove();
						self.shadows[k] = nil;
					else
						--[[if (senses and sanity < 30) then
							if (!v.originalMaterial) then
								v.originalMaterial = v:GetMaterial();
								
								v:SetColor(Color(0, 0, 0, 255));
								v:SetMaterial("models/debug/debugwhite");
							end
						else
							if (v.originalMaterial) then
								v:SetRenderMode(RENDERMODE_TRANSALPHA);
								v:SetMaterial(v.originalMaterial);
								v:SetColor(Color(0, 0, 0, 0));
							end;
						end;]]--
						
						local forward = v:GetForward() * 0.15;
						
						v.boneOffset = v.boneOffset or {};
						
						for i = 1, 30 do
							if (math.random(1, 10) == 1) then
								v.boneOffset[i] = (VectorRand() * (0.02 * math.random(1, 3)));
							end;
							
							v:ManipulateBonePosition(i, v:GetManipulateBonePosition(i) + (v.boneOffset[i] or Vector(0, 0, 0)));
						end;
						
						if (flashlightEnabled) then
							--v:RemoveEffects(EF_ITEM_BLINK);
							v:SetColor(Color(0, 0, 0, 0));
						else
							v:SetMaterial("models/zombie_fast/fast_zombie_sheet");
							v:SetColor(Color(100, 100, 100, 255));
							--v:AddEffects(EF_ITEM_BLINK);
						end;
						
						local yaw = (position - shadowPosition):Angle().yaw;
						
						v:SetPos(shadowPosition + forward);
						v:SetAngles(Angle(0, yaw, 0));

						if (!v.curTime or v.curTime < curTime) then 
							local sequenceID = math.random(1, 15);
							
							v.curTime = curTime + v:SequenceDuration(sequenceID);
							v:ResetSequence(sequenceID);
						end;
						
						if not v.soundPlayed and (distance < 512 * 512) and (distance >= 128 * 128) then
							if math.random(1, 4) == 1 then
								sound.Play(shadowScreams[math.random(1, #shadowScreams)], v:GetPos(), 75, math.random(75, 95), 0.75);
							end
							
							v.soundPlayed = true;
						elseif (distance < 128 * 128) and (distance >= 64 * 64) then
							if !Clockwork.Client.cwInDark then
								sound.Play("misc/death_0"..math.random(1, 4)..".ogg", v:GetPos(), 75, math.random(75, 95), 0.75);
								v:Remove();
								self.shadows[k] = nil;
							end
						elseif (distance < 64 * 64) then
							if Clockwork.Client.cwInDark then
								if Clockwork.Client:GetDTInt(INT_RAGDOLLSTATE) != RAGDOLL_KNOCKEDOUT then
									sound.Play("misc/attack_0"..math.random(1, 2)..".ogg", v:GetPos(), 75, math.random(75, 95), 0.75);
									netstream.Start("ShadowDamage");
									Schema:AddStunEffect(1);
									
									if cwMelee then
										util.ScreenShake(Clockwork.Client:GetPos(), 15, 2, 3, 10);
										cwMelee.blurAmount = 5;
									end
								end
							else
								sound.Play("misc/death_0"..math.random(1, 4)..".ogg", v:GetPos(), 75, math.random(75, 95), 0.75);
							end
							
							v:Remove();
							self.shadows[k] = nil;
						end
					end;
				end;

				--[[if (#self.shadows < max_shadows and ((flashlightEnabled or senses) or sanity < 20)) then
					local playersInRadius = false;
					
					for k, v in pairs(ents.FindInSphere(position, 400)) do
						local isPlayer = v:IsPlayer();
						local moveType = v:GetMoveType();
						
						if (isPlayer and v != Clockwork.Client and moveType == MOVETYPE_WALK) then
							playersInRadius = true;
							
							local playerPosition = v:GetPos();
							local model = v:GetModel();
							local shadow = ClientsideModel(model, RENDERGROUP_OPAQUE);

							shadow:SetRenderMode(RENDERMODE_TRANSALPHA)
							shadow:SetMaterial("models/debug/debugwhite")
							shadow:SetColor(Color(0, 0, 0, 0))

							local trace = {};
								trace.start = playerPosition;
								trace.endpos = trace.start - Vector(0, 0, 500);
								trace.filter = {Clockwork.Client};
							local traceLine = util.TraceLine(trace);
							
							local sequence = v:GetSequence();
							shadow:SetPos(traceLine.HitPos);
							shadow:ResetSequence(sequence);
							table.insert(self.shadows, shadow);
						end
					end
				end]]--
					
				if self.shadows and (#self.shadows < max_shadows) and sanity <= 25 then
					if !cwBeliefs or (cwBeliefs and !cwBeliefs:HasBelief("saintly_composure")) then		
						--if (!playersInRadius and math.random(1, 20) == 1) then

						if math.random(1, 300) == 1 then
							local model = table.Random(self.shadowModels);
							local shadow = ClientsideModel(model, RENDERGROUP_OPAQUE)
							
							if IsValid(shadow) then
								shadow:SetRenderMode(RENDERMODE_TRANSALPHA);
								shadow:SetMaterial("models/debug/debugwhite");
								shadow:SetColor(Color(0, 0, 0, 0));
								
								local x = 0;
								local y = 0;
								
								if math.random(1, 2) == 1 then
									x = math.random(-750, -500);
								else
									x = math.random(500, 750);
								end
								
								if math.random(1, 2) == 1 then
									y = math.random(-750, -500);
								else
									y = math.random(500, 750);
								end
								
								local trace = {};
									trace.start = Clockwork.Client:LocalToWorld(Vector(x, y, 0));
									trace.endpos = trace.start - Vector(0, 0, 500);
									trace.filter = {Clockwork.Client};
								local traceLine = util.TraceLine(trace);
								
								local sequence = shadow:LookupSequence("idle_angry");
								shadow:SetPos(traceLine.HitPos);
								shadow:ResetSequence(sequence);
								shadow.timeLeft = curTime + math.random(90, 120);
								
								table.insert(self.shadows, shadow);
							end
						end;
					end;
				end;
			else
				if self.crows then
					for k, v in pairs(self.crows) do
						if (IsValid(v)) then
							v:Remove();
							self.crows[k] = nil;
						end;
					end;
				end
			
				if self.shadows then
					for k, v in pairs(self.shadows) do
						if (IsValid(v)) then
							v:Remove();
							self.shadows[k] = nil;
						end;
					end;
				end
			end;
		else
			self.moonHallucinationTimer = CurTime() + math.random(120, 300);
		
			if self.crows then
				for k, v in pairs(self.crows) do
					if (IsValid(v)) then
						v:Remove();
						self.crows[k] = nil;
					end;
				end;
			end
		
			if self.shadows then
				for k, v in pairs(self.shadows) do
					if (IsValid(v)) then
						v:Remove();
						self.shadows[k] = nil;
					end;
				end;
			end
		end;
	end;
end;

-- Called when the local player attempts to see the top bars.
function cwDayNight:PlayerCanSeeBars(class)
	if (self.moonHallucination) then
		return false;
	end
end

function cwDayNight:PlayerDrawWeaponSelect()
	if (self.moonHallucination) then
		return false;
	end;
end;

local up = Vector(0, 0, 500);
local down = Angle(0, -90, 0);

function cwDayNight:PostDrawSkyBox()
	if Clockwork.Client.currentCycle == "night" then
		local zoneTable = zones:FindByID(zones.cwCurrentZone or "wasteland");

		if zoneTable.hasNight then
			cam.Start3D2D(Clockwork.Client:GetPos() + up, down, 1);
				cam.IgnoreZ(true);
				render.SuppressEngineLighting(true)
				surface.SetMaterial(moonMat);
				surface.SetDrawColor(255, 255, 255, 255);
				surface.DrawTexturedRect(-100, -100, 200, 200);
				render.SuppressEngineLighting(false)
				cam.IgnoreZ(false);
			cam.End3D2D();
		end
	end
end

-- this is all spaghetti and I just don't give a fuck!!!!!!!!!!!!!!!!!!!!!
function cwDayNight:RenderScreenspaceEffects()
	if (Clockwork.Client.MoonSharps and Clockwork.Client.MoonSharps > 0) then
		local fac = (Clockwork.Client.MoonSharps / 40)
		DrawSharpen(-Clockwork.Client.MoonSharps/10, Clockwork.Client.MoonSharps + (math.random(-10, 10) * fac));
		Clockwork.Client.MoonSharps = math.Approach(Clockwork.Client.MoonSharps, 0, FrameTime() * 8)
		local redcol = Clockwork.Client.MoonSharps/10
		local c = redcol * fac
		local themoon = {
			[ "$pp_colour_mulr" ] = c,
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0 + (1 - fac),
			[ "$pp_colour_colour" ] = 0 + (1 - fac),
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] =0,
		}
		DrawColorModify(themoon)
	elseif (Clockwork.Client.MoonSharps and Clockwork.Client.MoonSharps <= 0) then
		Clockwork.Client.MoonSharps = nil;
	end
	
	if self.moonHallucination then
		DrawMaterialOverlay("begotten/effects/filmgrain_moon", 1);
		surface.SetMaterial(moonMat);
		surface.SetDrawColor(Color(255, 255, 255, 150));
		surface.DrawTexturedRect((ScrW() / 2) - 179 + math.random(-20, 20), (ScrH() / 2) - 179 + math.random(-20, 20), 357, 357);
		surface.SetMaterial(moonSubMat);
		surface.SetDrawColor(Color(255, 255, 255, 250));
		surface.DrawTexturedRect((ScrW() / 2) - 200 + math.random(-20, 20), (ScrH() / 2) + 300 + math.random(-20, 20), 400, 100);
	end;
end;

function cwDayNight:MoonTrigger(sharpen, force)
	if (Clockwork.Client:IsAdmin() and !force) then
		if (Clockwork.ConVars.DAYNIGHTMOON and Clockwork.ConVars.DAYNIGHTMOON:GetInt() != 1) then
			return;
		end
	end

	cwMusic:StopBattleMusic()
	cwMusic:StopAmbientMusic()
			
	Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 100, math.random(70, 90))
	Schema:SanityZoom(0.2)
	Schema:AddStunEffect(0.2);
	CRAZYBOB = 100;
	if (!Clockwork.Client.Moon) then
		Clockwork.Client.Moon = CreateSound(Clockwork.Client, "begotten/ui/ui_horror.wav");
		local pi = math.random(40, 60);
		local npi = pi - math.random(5, 15);
		Clockwork.Client.Moon:PlayEx(0, pi);
		Clockwork.Client.Moon:ChangeVolume(0.6, 1)
		Clockwork.Client.Moon:ChangePitch(npi, 3);
		
		timer.Simple(3, function()
			Clockwork.Client.Moon:FadeOut(3);
			timer.Simple(3, function()
				Clockwork.Client.Moon = nil;
			end);
		end);
	end;

	for i = 1, 2 do
		Clockwork.Client:EmitSound("begotten/ui/sanity_touch.mp3", 40, math.random(70, 110) + (math.random(10, 30)))
		Clockwork.Client:EmitSound("begotten/panic.mp3", 30, math.random(30, 50) + (i * 12))
	end;
	
	Clockwork.Client:EmitSound("begotten/ui/font_appear.mp3", 60, 80)
	
	if (!sharpen) then
		timer.Simple(FrameTime(), function()
			Clockwork.Client.MoonSharps = 40;
		end);
	end;
end;

function cwDayNight:ClockworkConVarChanged(name, previousValue, newValue)
	if Clockwork.player:IsAdmin(Clockwork.Client) then
		if (name == "cwDayNightMoon" and newValue) then
			if newValue == "0" then

			end
		elseif (name == "cwDayNightHallucinations" and newValue) then
			if newValue == "0" then
				if self.crows then
					for k, v in pairs(self.crows) do
						if (IsValid(v)) then
							v:Remove();
							self.crows[k] = nil;
						end;
					end;
				end
			
				if self.shadows then
					for k, v in pairs(self.shadows) do
						if (IsValid(v)) then
							v:Remove();
							self.shadows[k] = nil;
						end;
					end;
				end
			else
				self.moonHallucinationTimer = CurTime() + math.random(120, 300);
			end
		end
	end
end


netstream.Hook("MoonTrigger", function()
	cwDayNight:MoonTrigger();
end);

netstream.Hook("SetCurrentCycle", function(currentCycle)
	Clockwork.Client.currentCycle = currentCycle;
	
	if currentCycle == "daytonight" then
		cwDayNight.nightWeight = 0;
	elseif currentCycle == "nighttoday" then
		cwDayNight.nightWeight = 1;
	end
	
	cwDayNight.nextWeightTick = 0;
	
	if currentCycle == "night" then
		cwDayNight.moonHallucinationTimer = CurTime() + math.random(120, 300);
		cwDayNight.nightWeight = 0;
	end
end);

netstream.Hook("SetNightWeight", function(nightWeight)
	cwDayNight.nightWeight = nightWeight;
end);

Clockwork.setting:AddCheckBox("Day/night cycle", "Enable moon effects.", "cwDayNightMoon", "Click to toggle the effects of looking at the Blood Moon.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Day/night cycle", "Enable night hallucinations.", "cwDayNightHallucinations", "Click to toggle the nighttime hallucinatons.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);