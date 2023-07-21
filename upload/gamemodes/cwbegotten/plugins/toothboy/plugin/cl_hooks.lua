--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local map = game.GetMap() == "rp_begotten3";

-- Called when the foreground HUD is painted.
function cwToothBoy:HUDPaintForeground()
	if (!map) then
		return;
	end;
	
	local curTime = CurTime()

	if (!self.NearToothBoy) then
		self.NearToothBoy = false
	end

	if (!self.NextNearToothBoy or curTime >= self.NextNearToothBoy) then
		self.NextNearToothBoy = curTime + 2
		
		local position = Clockwork.Client:GetPos()
		local entities = ents.FindInSphere(position, 1000);
		
		for i = 1, #entities do
			local entity = entities[i];
			
			if (entity:GetNWBool("tb", false)) then
				self.NearToothBoy = true
				break
			else
				self.NearToothBoy = false
			end
		end;
	end
end

-- Called when the screenspace effects are rendered.
function cwToothBoy:RenderScreenspaceEffects()
	if (Clockwork.kernel:IsScreenFadedBlack()) then
		return
	end
	
	local frameTime = FrameTime()
	local curTime = CurTime()

	if (Clockwork.Client.SanityZoom) then
		DrawSharpen(Clockwork.Client.SanityZoom * 20, Clockwork.Client.SanityZoom * 20)
		DrawMaterialOverlay("models/props_c17/fisheyelens", Clockwork.Client.SanityZoom)
		
		if (Clockwork.Client.SanityZoom != 0) then
			Clockwork.Client.SanityZoom = math.Approach(Clockwork.Client.SanityZoom, 0, frameTime / 4)
		else
			Clockwork.Client.SanityZoom = nil
		end
	end
	
	if (!map) then 
		return;
	end;

	if (!self.NextHalfSecond or curTime > self.NextHalfSecond) then
		self.NextHalfSecond = curTime + 0.5
		
		local canRun = true
		
		if (self.NextSteamRelease) then
			if (self.NextSteamRelease > curTime) then
				canRun = false
			else
				self.NextSteamRelease = nil
			end
		end
		
		if (canRun) then
			for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 320)) do
				if (v:GetNWBool("steamjet", false) == true) then
					self.SteamJetBlur = 0
					self.NextSteamRelease = curTime + 5
					
					break
				end
			end
		end
	end
	
	if (self.SteamJetBlur) then
		if (!self.SteamJetReverse) then
			if (self.SteamJetBlur != 5) then
				self.SteamJetBlur = math.Approach(self.SteamJetBlur, 5, frameTime * 8)
			else
				self.SteamJetReverse = true
			end
		else
			self.SteamJetBlur = math.Approach(self.SteamJetBlur, 0, frameTime * 3)
			
			if (self.SteamJetBlur == 0) then
				self.SteamJetBlur = nil
				self.SteamJetReverse = nil
			end
		end
		
		if (self.SteamJetBlur) then
			DrawMotionBlur(0.03, self.SteamJetBlur, 0)
		end
	end

	if (!self.NextHit or curTime > self.NextHit) then
		self.NextHit = curTime + 1
		
		if (Clockwork.Client:Alive()) then
			local trace = Clockwork.Client:GetEyeTrace()
			local entity = trace.Entity

			hook.Run("PlayerOnHit", entity)
		end
	end

	if ((self.Closeup and self.Closeup > curTime) or self.ToothboySharpen and self.ToothboySharpen > 0) then
		if (!self.ToothboySharpen) then
			self.ToothboySharpen = 17
		end
		
		DrawSharpen(1, self.ToothboySharpen)
		self.ToothboySharpen = math.Approach(self.ToothboySharpen, 0, frameTime * 32)
	elseif (self.ToothboySharpen and self.ToothboySharpen == 0) then
		self.ToothboySharpen = nil
	end
	
	if (self.Static and self.Static > curTime) then
		if (!Clockwork.Client.StaticNoise) then
			Clockwork.Client.StaticNoise = CreateSound(Clockwork.Client, "ambient/gas/steam2.wav")
			Clockwork.Client.StaticNoise:PlayEx(1, 200)
		end

		local staticModify = {
			["$pp_colour_brightness"] = -0.2,
			["$pp_colour_contrast"] = 2,
			["$pp_colour_colour"] = 0 - math.Rand(0.1, 0.4),
			["$pp_colour_addr"] = math.Rand(0.1, 0.5),
			["$pp_colour_addg"] = math.Rand(0.1, 0.5),
		}
		
		if self.Static > curTime + 0.15 then
			local dynamicLight = DynamicLight(Clockwork.Client:EntIndex() + 1);

			if (dynamicLight) then
				dynamicLight.brightness = 1;
				dynamicLight.Size = 256;
				dynamicLight.pos = Vector(12630, -10746, -1615);
				dynamicLight.r = 255;
				dynamicLight.g = 255;
				dynamicLight.b = 255;
				dynamicLight.Decay = 0;
				dynamicLight.DieTime = curTime + 0.1;
			end;
		end
		
		DrawColorModify(staticModify)
		DrawMaterialOverlay("effects/tvscreen_noise00"..math.random(1, 2).."a.vmt", 0.00001)
	else
		if (Clockwork.Client.StaticNoise) then
			Clockwork.Client.StaticNoise:Stop()
			Clockwork.Client.StaticNoise = nil
		end
	end
end

-- Called when the calc view table should be adjusted.
function cwToothBoy:CalcViewAdjustTable(view)
	local curTime = CurTime()
	
	if (self.Closeup and self.Closeup > curTime) then
		if (!self.ToothboyChange) then
			self.ToothboyChange = 1
		end
		
		local toothboyAngles = {
			Angle(-29.513, 63.305, 0.000),
			Angle(-21.730, 129.282, 0.000),
		}
		
		local toothboyPositions = {
			Vector(12616.533203, -10738.747070, -1624.610718),
			Vector(12645.633789, -10742.754883, -1624.610718),
		}
		
		view.origin = toothboyPositions[self.ToothboyChange]
		view.angles = toothboyAngles[self.ToothboyChange]
		
		if (!self.ToothboyChangeTime or curTime > self.ToothboyChangeTime) then
			self.ToothboyChangeTime = curTime + 0.15
			
			if (self.ToothboyChange == 1) then
				self.ToothboyChange = 2
			else
				self.ToothboyChange = 1
			end
		end
		
		return;
	end
end

-- Called every second when a player is looking at an entity.
function cwToothBoy:PlayerOnHit(entity)
	local curTime = CurTime()
	
	if (entity:GetNWBool("tb", false)) then
		if (!self.NextCloseup or curTime > self.NextCloseup) then
			self.NextCloseup = curTime + 300;
			
			local position = Clockwork.Client:GetPos()
			local toothboyPosition = entity:GetPos()
			local distance = toothboyPosition:Distance(position)
			
			if (distance > 1024) then
				return
			end
			
			local toothboyTime = curTime + math.Rand(0.25, 0.7)
			
			self.Closeup = toothboyTime
			self.Static = toothboyTime
			
			for i = 1, math.random(1, 3) do
				Clockwork.Client:EmitSound("begotten/tb/tb_"..math.random(1, 39)..".mp3", 500, math.random(35, 50))
			end
			
			Clockwork.Client:EmitSound("begotten/slender.wav", 60, 60)
		end
	end
end