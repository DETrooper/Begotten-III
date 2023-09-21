--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

CW_CONVAR_FILMGRAIN = Clockwork.kernel:CreateClientConVar("cwFilmGrain", 1, true, true);
CW_CONVAR_WAKEUPSEQUENCE = Clockwork.kernel:CreateClientConVar("cwWakeupSequence", 1, true, true);
CW_CONVAR_SHOWBLUR = Clockwork.kernel:CreateClientConVar("cwShowBlur", 1, true, true);
CW_CONVAR_SHOWCALCVIEW = Clockwork.kernel:CreateClientConVar("cwShowCalcView", 1, true, true);
CW_CONVAR_CINEMATICVIEW = Clockwork.kernel:CreateClientConVar("cwCinematicView", 0, true, true);
CW_CONVAR_CINEMATICVIEWOBS = Clockwork.kernel:CreateClientConVar("cwCinematicViewObs", 0, true, true);

Schema.blackBlur = Material("begotten/effects/blackblur.png");
Schema.filmGrainOverlay = Material("begotten/effects/grain_overlay");
Schema.stunEffects = {};
Schema.corpseModels = {};
Schema.blurAdd = 0;
Schema.npcTable = {
	["npc_crow"] = true,
};

Schema.bibleQuotes = {
	{spaghetti = "And I saw the beast, and the kings of the earth, and their armies, gathered together to make war against him that sat on the horse, and against his army.", pingas = "(Book of Revelation 19:19)"}, -- 
	{spaghetti = "Immediately after the tribulation of those days shall the sun be darkened, and the moon shall not give her light, and the stars shall fall from heaven, and the powers of the heavens shall be shaken.", pingas = "(Gospel of Matthew 24:29)"}, -- 
	{spaghetti = "And God saw that the wickedness of man was great in the earth, and that every imagination of the thoughts of his heart was only evil continually.", pingas = "(Book of Genesis 6:5)"}, --
	{spaghetti = "For, behold, the Lord will come with fire, and with his chariots like a whirlwind, to render his anger with fury, and his rebuke with flames of fire. For by fire and by his sword will the Lord plead with all flesh: and the slain of the Lord shall be many.", pingas = "(Book of Isaiah 66:15-16)"},
}

Schema.wakeupMusic = {
	"begotten3soundtrack/spawnmusic/c2rabies_03.wav",
	"begotten3soundtrack/spawnmusic/c2rabies_07.wav",
	"begotten3soundtrack/spawnmusic/c2rabies_08.wav",
	"begotten3soundtrack/spawnmusic/c2rabies_09.wav",
};

-- Called when the default motion blur values are needed.
function Schema:GetMotionBlurValues(x, y, forward, spin)
	local frameTime = FrameTime();
	local blurValue = 0;
	
	if (CW_CONVAR_SHOWBLUR:GetInt() != 1) then
		return;
	end;
	
	-- Make sure they aren't in char creation.
	if Clockwork.kernel:IsChoosingCharacter() then
		return;
	end

	if (Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsScreenFadedBlack()) then
		if (!Clockwork.kernel:IsChoosingCharacter()) then
			blurValue = math.max(0, 80 - ((Clockwork.Client:Sanity() or 100))) * 0.003;
			
			if (self.addBlurStart and self.addBlurTarget and self.addBlurStart > 0) then
				self.addBlurStart = math.Approach(self.addBlurStart, self.addBlurTarget, frameTime * self.addBlurInterval);
				
				blurValue = self.addBlurStart;
			else
				self.addBlurStart = nil;
				self.addBlurTarget = nil;
			end;
			
			if Clockwork.Client:GetMoveType() ~= MOVETYPE_NOCLIP then
				local shotPos = Clockwork.Client:GetShootPos()
				local aimVector = Clockwork.Client:GetAimVector();
				local hullTrace = util.TraceHull({
					start = shotPos,
					endpos = shotPos + aimVector * 600,
					filter = Clockwork.Client,
					mins = Vector(-30, -30, -30),
					maxs = Vector(30, 30, 30),
					mask = MASK_ALL,
					collisiongroup = COLLISION_GROUP_NONE,
					ignoreworld = true
				});
				
				if (hullTrace.Hit and hullTrace.Entity) then
					local distance = hullTrace.Entity:GetPos():Distance(Clockwork.Client:GetPos());
					
					if (distance < 512 and IsValid(hullTrace.Entity)) and Clockwork.Client:GetNetVar("steelWill", false) ~= true then
						if (hook.Run("ShouldEntityModifyBlur", hullTrace.Entity)) then
							self.blurAdd = math.Approach(self.blurAdd, 128 / distance, frameTime / 3);
						elseif (hook.Run("ShouldPlayerModifyBlur", hullTrace.Entity)) then
							self.blurAdd = math.Approach(self.blurAdd, 128 / distance, frameTime / 3);
						else
							self.blurAdd = math.Approach(self.blurAdd, 0, frameTime / 3);
						end;
					else
						self.blurAdd = math.Approach(self.blurAdd, 0, frameTime / 3);
					end;
				elseif (self.blurAdd and self.blurAdd > 0) then
					self.blurAdd = math.Approach(self.blurAdd, 0, frameTime / 3);
				end;
			elseif (self.blurAdd and self.blurAdd > 0) then
				self.blurAdd = math.Approach(self.blurAdd, 0, frameTime / 3);
			end
		else
			blurValue = blurValue + 0.1;
		end;
	end;

	if (self.blurAdd > 0) then
		if (!CRAZYBOB) then
			CRAZYBOB = 0;
		end;
		
		CRAZYBOB = math.Clamp(CRAZYBOB + (self.blurAdd * 100), 0, 10);
	end;
	
	return 0, 0, blurValue + self.blurAdd, 0;
end;

-- Called to get whether looking at a specified player should modify the motion blur.
function Schema:ShouldPlayerModifyBlur(entity)
	if entity:IsPlayer() and entity:GetMoveType() ~= MOVETYPE_NOCLIP and entity:GetColor().a > 0 then
		-- There's probably a better way to do this but I don't feel like networking clothes items and shit.
		local faction = entity:GetSharedVar("kinisgerOverride") or entity:GetFaction();
		local clientFaction = Clockwork.Client:GetSharedVar("kinisgerOverride") or Clockwork.Client:GetFaction();
		
		if faction == "Goreic Warrior" and clientFaction ~= "Goreic Warrior" then
			local bodygroup = entity:GetBodygroup(0);
			
			if entity:GetModel() == "models/begotten/goreicwarfighters/gorechieftan.mdl" or (bodygroup == 8 or bodygroup == 9) then
				return true;
			end
		elseif faction == "Children of Satan" and clientFaction ~= "Children of Satan" then
			if entity:GetModel() == "models/begotten/satanists/wraitharmor.mdl" then
				return true;
			end
		elseif faction == "Gatekeeper" and clientFaction == "Goreic Warrior" or clientFaction == "Children of Satan" then
			if entity:GetModel() == "models/begotten/gatekeepers/vexi.mdl" then
				return true;
			end
		end
	end
end;

-- Called to get whether looking at a specified entity should modify the motion blur.
function Schema:ShouldEntityModifyBlur(entity)
	local class = entity:GetClass();
	local model = entity:GetModel();
	
	if (self.npcTable[class] or class == "prop_ragdoll" and self.corpseModels[model]) then
		return true;
	elseif entity:IsNPC() or entity:IsNextBot() then
		if cwZombies and entity:IsZombie() then
			return true;
		end
	end;
end;

-- Called when the local player's default colorify should be set.
function Schema:PlayerSetDefaultColorModify(colorModify)
	colorModify["$pp_colour_brightness"] = 0;
	colorModify["$pp_colour_contrast"] = 1;
	colorModify["$pp_colour_colour"] = 1;
end;

-- Called when the foreground HUD should be painted.
function Schema:HUDPaintForeground()
	local frameTime = FrameTime();
	local curTime = CurTime();
	local scrW = ScrW();
	local scrH = ScrH();
	
	if (Clockwork.Client:Alive()) then
		if (self.cwBlackFade) then
			if (!self.cwBlackAlpha) then
				self.cwBlackAlpha = 1
			end
			
			if (curTime < self.cwBlackFade and self.cwBlackAlpha != 255) then
				self.cwBlackAlpha = math.Approach(self.cwBlackAlpha, 255, frameTime * 128)
			elseif (curTime >= self.cwBlackFade) then
				self.cwBlackAlpha = math.Approach(self.cwBlackAlpha, 1, frameTime * 128)
			end

			draw.RoundedBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, self.cwBlackAlpha))
			
			if (self.cwBlackAlpha == 1) then
				self.cwBlackAlpha = nil
				self.cwBlackFade = nil
			end
		end

		if (self.stunEffects) then
			for k, v in pairs(self.stunEffects) do
				local alpha = math.Clamp((255 / v[2]) * (v[1] - curTime), 0, 255);
				
				if (alpha != 0) then
					draw.RoundedBox(0, 0, 0, scrW, scrH, Color(255, 255, 255, alpha));
				else
					table.remove(self.stunEffects, k);
				end;
			end;
		end;
	end;
end;

function Schema:PlayerDrawWeaponSelect()
	if (Clockwork.Client.LoadingText) then
		return false;
	end;
	
	if self.caughtByCheaple then
		return false
	end
end;

function Unduck()
	RunConsoleCommand("-duck")
end;
CINEMATICLERP = CINEMATICLERP or 1

function Schema:CalcView(player, origin, angles, fov)
	local frameTime = FrameTime();
	local view = {origin = origin, angles = angles, fov = fov}

	if (CW_CONVAR_SHOWCALCVIEW:GetInt() != 1) then
		return
	end
	
	if Clockwork.Client:InVehicle() then
		return;
	end

	if (CW_CONVAR_CINEMATICVIEW:GetInt() == 1) then
		local CANRUN = true;
		if (CW_CONVAR_CINEMATICVIEWOBS:GetInt() == 1 and !Clockwork.player:IsNoClipping(Clockwork.Client)) then
			CANRUN = false
		end;
		
		if (CANRUN) then
			if (!lastAngs) then
				lastAngs = angles;
			end;
			local info = {yaw = 0, roll = 0, pitch = 0};
			local eyeAngs = EyeAngles();
			info.yaw = angles.y;
			info.pitch = angles.p;
			info.roll = angles.r;
			local ir = Angle(info.pitch, info.yaw, info.roll);
			view.angles = LerpAngle(CINEMATICLERP, lastAngs, ir);
			lastAngs = eyeAngs;

			if (!lastOr) then
				lastOr = origin;
			end;
			local eyePos = EyePos();
			view.origin = LerpVector(CINEMATICLERP, lastOr, origin);
			lastOr = eyePos;
			view.drawviewer = true
			
			if (!self.alp) then
				self.alp = 255;
			end;
			
			if (origin:Distance(view.origin) < 16) then
				self.alp = math.Approach(self.alp, 0, FrameTime() * 1024);
				
			elseif (CINEMATICLERP <= 0.5) then
				self.alp = math.Approach(self.alp, 255, FrameTime() * 1024)
			end;
			SEEING = self.alp;
			Clockwork.Client:SetColor(Color(255, 255, 255, self.alp))
		else
			lastAngs = nil
			lastOr = nil
		end;
	end;

	local scale = --[[math.Clamp(CW_CONVAR_HEADBOBSCALE:GetFloat(), 0, 1) or ]]1;
	
	if (!Clockwork.Client:Alive() and Clockwork.player:IsNoClipping(Clockwork.Client)) then
		view.origin = player:GetPos() + Vector(0, 0, 64);
		return view;
	end
	
	if (Clockwork.Client:IsRagdolled()) then
		local ragdollEntity = Clockwork.Client:GetRagdollEntity();
		local ragdollState = Clockwork.Client:GetRagdollState();
		
		if (Clockwork.BlackFadeIn == 255) then
			return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov};
		else
			local eyes = ragdollEntity:GetAttachment(ragdollEntity:LookupAttachment("eyes"));
			
			if (eyes) then
				local ragdollEyeAngles = eyes.Ang + Clockwork.kernel:GetRagdollEyeAngles();
				local physicsObject = ragdollEntity:GetPhysicsObject();
				
				if (IsValid(physicsObject)) then
					local velocity = physicsObject:GetVelocity().z;
					
					if (velocity <= -1000 and Clockwork.Client:GetMoveType() == MOVETYPE_WALK) then
						ragdollEyeAngles.p = ragdollEyeAngles.p + math.sin(curTime) * math.abs((velocity + 1000) - 16);
					end;
				end;
				
				return {origin = eyes.Pos, angles = ragdollEyeAngles, fov = fov};
			else
				return view
			end;
		end;
	elseif (!Clockwork.Client:Alive()) then
		return {origin = Vector(20000, 0, 0), angles = Angle(0, 0, 0), fov = fov};
	--[[elseif (Clockwork.Client:Health() <= 30) then
		if (!Clockwork.player:IsNoClipping(player)) then
			local approachTime = frameTime * 0.2;
			local info = {speed = 1, yaw = 0.1, roll = 1, pitch = 1};
			
			if (!self.HeadbobAngle) then
				self.HeadbobAngle = 0;
			end
			
			if (!self.HeadbobInfo) then
				self.HeadbobInfo = info;
			end;
			
			hook.Run("PlayerAdjustHeadbobInfo", info);
			
			info.roll = info.roll * 4
			info.yaw = info.yaw * 2
			info.speed = info.speed * math.min(15 * 0.25, 4);
			info.yaw = info.yaw * (math.min(15, 4) * 1.3);
			
			if (CRAZYBOB) then
				for k, v in pairs (info) do
					info[k] = v * CRAZYBOB;
				end;
				CRAZYBOB = math.Approach(CRAZYBOB, 0, FrameTime() * 32);
				if (CRAZYBOB <= 0) then
					CRAZYBOB = nil;
				end;
			end;
			
			self.HeadbobInfo.yaw = math.Approach(self.HeadbobInfo.yaw, info.yaw, approachTime);
			self.HeadbobInfo.roll = math.Approach(self.HeadbobInfo.roll, info.roll, approachTime);
			self.HeadbobInfo.speed = math.Approach(self.HeadbobInfo.speed, info.speed, approachTime);
			self.HeadbobInfo.pitch = math.Approach(self.HeadbobInfo.pitch, info.pitch, approachTime);
			self.HeadbobAngle = self.HeadbobAngle + (self.HeadbobInfo.speed * frameTime);

			angles.p = angles.p + (math.sin(self.HeadbobAngle) * self.HeadbobInfo.pitch);
			angles.y = angles.y + (math.sin(self.HeadbobAngle) * self.HeadbobInfo.yaw);
			angles.r = angles.r + (math.cos(self.HeadbobAngle) * self.HeadbobInfo.roll);
		end;]]--
	elseif scale > 0 then
		if (!Clockwork.player:IsNoClipping(player)) then
			local approachTime = frameTime * 2;
			local headHealth = Clockwork.limb:GetHealth(HITGROUP_HEAD, false);
			local info = {speed = 1.5, yaw = 0.35, roll = 0.2, pitch = 0.3};
			
			if headHealth then
				if headHealth <= 90 and headHealth > 75 then
					info.roll = 0.8;
					info.pitch = 0.8;
					info.yaw = 0.4;
				elseif headHealth <= 75 and headHealth > 50 then
					info.roll = 1.5;
					info.pitch = 1.5;
					info.yaw = 0.5;
				elseif headHealth <= 50 and headHealth > 25 then
					info.roll = 3;
					info.pitch = 3;
					info.yaw = 0.6;
				elseif headHealth <= 25 and headHealth > 10 then
					info.roll = 3.5;
					info.pitch = 3.5;
					info.yaw = 0.8;
				elseif headHealth < 10 then
					info.roll = 4;
					info.pitch = 4;
					info.yaw = 1;
				end
			end
			
			if (!self.HeadbobAngle) then
				self.HeadbobAngle = 0;
			end;
			
			if (!self.HeadbobInfo) then
				self.HeadbobInfo = info;
			end;
			
			hook.Run("PlayerAdjustHeadbobInfo", info);

			if (CRAZYBOB) then
				for k, v in pairs (info) do
					info[k] = v * CRAZYBOB;
				end;
				CRAZYBOB = math.Approach(CRAZYBOB, 0, FrameTime() * 32);
				if (CRAZYBOB <= 0) then
					CRAZYBOB = nil;
				end;
			end;
			
			info.speed = math.min(info.speed, 5)
			
			self.HeadbobInfo.yaw = math.Approach(self.HeadbobInfo.yaw, info.yaw, approachTime);
			self.HeadbobInfo.roll = math.Approach(self.HeadbobInfo.roll, info.roll, approachTime);
			self.HeadbobInfo.speed = math.Approach(self.HeadbobInfo.speed, info.speed, approachTime);
			self.HeadbobInfo.pitch = math.Approach(self.HeadbobInfo.pitch, info.pitch, approachTime);
			self.HeadbobAngle = self.HeadbobAngle + (self.HeadbobInfo.speed * frameTime);

			angles.p = angles.p + (math.sin(self.HeadbobAngle) * self.HeadbobInfo.pitch);
			angles.y = angles.y + (math.sin(self.HeadbobAngle) * self.HeadbobInfo.yaw);
			angles.r = angles.r + (math.cos(self.HeadbobAngle) * self.HeadbobInfo.roll);
		end;
	end;

	hook.Run("CalcViewAdjustTable", view);
	return view;
end;

-- Called when the calc view table should be adjusted.
function Schema:CalcViewAdjustTable(view)
	if (CW_CONVAR_SHOWCALCVIEW:GetInt() != 1) then
		return;
	end

	if (Clockwork.Client.Wakeup) then
		if (Clockwork.Client.WakeupOrigin and (Clockwork.Client.WakeupOrigin - view.origin).z > -0.05) then
			Schema:FinishWakeupSequence();
			return;
		end;
		
		if (!Clockwork.Client.WakeupAngles) then
			Clockwork.Client.WakeupAngles = EyeAngles() + Angle(math.random(60, 70), table.Random({-30, 30}), table.Random({-30, 30}));
		end;
		
		if (!Clockwork.Client.WakeupOrigin) then
			Clockwork.Client.WakeupOrigin = Clockwork.Client:GetPos() + Vector(0, 0, 12);
		end;
		
		if (!Clockwork.Client.WakeupFOV) then
			Clockwork.Client.WakeupFOV = view.fov + 6;
		end;
		
		local curTime = CurTime();
		
		if (Clockwork.Client.WakeupDuration and doneblinks and doneblinks < curTime) then
			if not Clockwork.Client.WakeupTime then
				Clockwork.Client.WakeupTime = curTime + 5 + Clockwork.Client.WakeupDuration;
			end
			
			local ratio = (1 - ((1 / (Clockwork.Client.WakeupDuration or 10)) * (Clockwork.Client.WakeupTime - curTime))) / 120 -- spaghetti
			Clockwork.Client.WakeupOrigin = LerpVector(ratio, Clockwork.Client.WakeupOrigin, view.origin);
			Clockwork.Client.WakeupAngles = LerpAngle(ratio, Clockwork.Client.WakeupAngles, view.angles);
			Clockwork.Client.WakeupFOV = Lerp(ratio, Clockwork.Client.WakeupFOV, view.fov);
		end;
		
		view.origin = Clockwork.Client.WakeupOrigin;
		view.angles = Clockwork.Client.WakeupAngles;
		view.fov = Clockwork.Client.WakeupFOV;
	end
end;

-- Called when the model view is calculated.
function Schema:CalcViewModelView(wep, vew, o, oa, p, a)
	if (Clockwork.Client.Wakeup) then
		return Vector(0, 0, 0), Angle(0, 0, 0)
	end;
end;

-- Called when the calc view table should be adjusted.
function Schema:PlayerAdjustHeadbobInfo(info)
	local drunk = Clockwork.player:GetDrunk();
	local sanity = Clockwork.Client:GetSharedVar("sanity");
	local scaleAdd = 0;
	local weapon = Clockwork.Client:GetActiveWeapon();
	
	if (sanity and sanity <= 66) then
		scaleAdd = 1.2;
	end;
	
	--local scale = math.max(scaleAdd, CW_CONVAR_HEADBOBSCALE:GetInt());
	local scale = math.max(scaleAdd, 1);
	
	if IsValid(weapon) and weapon:GetNWBool("M9K_Ironsights") then
		info.yaw = 0.1;
		info.roll = 0.1;
		info.speed = 0.5;
		info.pitch = 0.1;
	end
	
	if (tonumber(scale)) then
		scale = math.Clamp(scale, 0, 1);
	else
		scale = 1;
	end;
	
	if (SWIRLPO) then
		scale = scale + math.Clamp(SWIRLPO, 0, 1);
	end;

	if (Clockwork.Client:IsRunning()) then
		if (scale > 0) then
			info.speed = (info.speed * 8) * scale;
			info.roll = (info.roll * 4) * scale;
		end;
	elseif (Clockwork.Client:GetVelocity():Length() > 0) then
		if (scale > 0) then
			info.speed = (info.speed * 6) * scale;
			info.roll = (info.roll * 2) * scale;
		end;
	else
		info.roll = info.roll * scale;
	end;
	
	if (drunk) then
		info.speed = info.speed * math.min(drunk * 0.25, 4);
		info.yaw = info.yaw * math.min(drunk, 4);
	end;
end

-- Called when the foreground HUD is painted.
function Schema:HUDPaintForeground()
	if (Clockwork.Client:IsAdmin() and CW_CONVAR_CINEMATICVIEW:GetInt() == 1 and CW_CONVAR_CINEMATICVIEWOBS:GetInt() != 1) then
	if (!Clockwork.player:IsNoClipping(Clockwork.Client)) then
		if (SEEING and SEEING > 0) then
			local hitpos = Clockwork.Client:GetEyeTraceNoCursor().HitPos;
			if (hitpos:Distance(Clockwork.Client:GetPos()) < 2048) then
				local to = hitpos:ToScreen();
				if (!gSEX) then
					gSEX = 0;
				end;
				gSEX = math.Approach(gSEX, SEEING, FrameTime() * 32);
				draw.RoundedBox(0, to.x - 2, to.y - 2, 4, 4, Color(0, 0, 0, gSEX))
				draw.RoundedBox(0, to.x - 1, to.y - 1, 2, 2, Color(170, 0, 0, gSEX))
			end;
		end;
	end;
	end;

	local curTime = CurTime();
	
	if (Clockwork.Client:Alive()) then
		if (Schema.stunEffects) then
			for k, v in pairs(Schema.stunEffects) do
				local alpha = math.Clamp( ( 255 / v[2] ) * (v[1] - curTime), 0, 255 );
				
				if (alpha != 0) then
					draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, alpha) );
				else
					table.remove(Schema.stunEffects, k);
				end;
			end;
		end;
		
		if (Clockwork.Client.LoadingText) then
			if (!self.loadingAlpha) then self.loadingAlpha = 255; end;
			if (!tea) then tea = 3 end
			if (self.timeUntilFade and (self.timeUntilFade + tea) < curTime) then
				if (!CRASF) then
					CRASF = true
					Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 0.1);
					
					timer.Simple(0.5, function()
						if Clockwork.Client.LoadingText then
							Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 0);
						end
					end);
					
					timer.Simple(1.5, function()
						if Clockwork.Client.LoadingText then
							Clockwork.Client:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 0.1);
						end
					end);
					
					timer.Simple(2.5, function()
						if Clockwork.Client.LoadingText then
							Clockwork.Client:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 0);
						end
					end);
					
					doneblinks = CurTime() + 5;
					Clockwork.Client.WakeupTime = CurTime() + 5 + (Clockwork.Client.WakeupDuration or 10);
				end;
			end;
			
			if (self.timeUntilFade and self.timeUntilFade < curTime) then
				if (!ATYI) then
					ATYI = true
					Clockwork.Client.WakeupDuration = 10
					Clockwork.Client.Wakeup = true;
					Clockwork.Client.FUCKMYLIFETIME = CurTime() + 10
					Clockwork.Client.WakeupAngles = nil;
					Clockwork.Client.WakeupOrigin = nil;
				end;
				
				self.loadingAlpha = math.Approach(self.loadingAlpha, 0, FrameTime() * 512);
			end;

			draw.RoundedBox(0, -1, -1, ScrW() + 2, ScrH() + 2, Color(0, 0, 0, self.loadingAlpha))
		end;
		
		if (Clockwork.Client.Seq1) then
			if (!Clockwork.Client.BibleText) then
				Clockwork.Client.BibleText = {""};
				local ata = table.Random(self.bibleQuotes)
				self.jghrjhtjh = ata.pingas
				Clockwork.kernel:WrapTextSpaced(ata.spaghetti, "Subtitle_Yell", ScrW() * 0.75, Clockwork.Client.BibleText)
			end;
			
			local interval = FrameTime() * 48;
			local scrW = ScrW();
			local scrH = ScrH();
			if (!self.textAlpha) then
				self.textAlpha = 0;
			end;
			
			if (!self.timeUntilFade) then
				self.timeUntilFade = curTime + 10;
			elseif ((self.timeUntilFade - 2) < curTime) then
				self.textAlpha = math.Approach(self.textAlpha, 0, interval);
				if (self.textAlpha <= 0) then
					Clockwork.Client.Seq1 = nil;
				end;
			else
				self.textAlpha = math.Approach(self.textAlpha, 255, interval);
			end;
			
			if (!self.ay) then
				self.ay = 0;
			end;
			
			if (self.textAlpha >= 255) then
				self.canss = true
			end;
			
			if (self.canss) then
				self.ay = math.Clamp(math.Approach(self.ay, 255, interval / 2), 0, self.textAlpha);
			end;
			
			local se = #Clockwork.Client.BibleText 
			
			for k, v in pairs (Clockwork.Client.BibleText) do
				if (!self.cwFontHeight) then
					self.cwFontHeight = GetFontHeight("Subtitle_Yell", v) + 2;
				end;
				draw.SimpleText(v, "Subtitle_Yell", (scrW * 0.5) - 2, ((scrH * 0.5) + (self.cwFontHeight * k)) - 2, Color(0, 0, 0, self.textAlpha / 2), 1)
				draw.SimpleText(v, "Subtitle_Yell", scrW * 0.5, (scrH * 0.5) + (self.cwFontHeight * k), Color(255, 255, 255, self.textAlpha), 1)
			end;

			draw.SimpleText(self.jghrjhtjh, "Subtitle_Yell", scrW * 0.5 - 2, ((scrH * 0.5) + (self.cwFontHeight * (se + 2))) - 2, Color(0, 0, 0, self.ay / 2), 1)
			draw.SimpleText(self.jghrjhtjh, "Subtitle_Yell", scrW * 0.5, (scrH * 0.5) + (self.cwFontHeight * (se + 2)), Color(255, 255, 255, self.ay), 1)
		end;
	end;
	
	if (Clockwork.Client:IsAdmin() and (CW_CONVAR_CINEMATICVIEW:GetInt() == 1) and !Clockwork.chatBox:IsOpen() and input.IsKeyDown(KEY_C)) then
		draw.RoundedBox(0, (ScrW() * 0.5) - 75, 64, 150, 64, Color(0, 0, 0, 150))
		draw.SimpleText("Cinematic Lerp Value: "..CINEMATICLERP, "Default", (ScrW() * 0.5) - 75 + 4, 64 + 4, Color(255, 0, 0))
	end;
end;

local contrast = 1.8;
local distance = 100;

-- Called when the client moves their mouse.
function Schema:InputMouseApply(cmd, x, y, ang)
	
	if (!self.c or self.c < CurTime()) then
		self.c = CurTime() + 0.025;
		if (CW_CONVAR_CINEMATICVIEW:GetInt() == 1) then
			local mDelta = cmd:GetMouseWheel();
			local nd = CINEMATICLERP + (mDelta / 200)
			
			CINEMATICLERP = (math.Clamp(nd, 0.01, 1))
		end;
	end;

	if (!self.crosseyed) then
		return;
	end;
	
	if (x > 10 or y > 10) then
		local curTime = CurTime();
		
		if (!self.cwDidMoveHead or self.cwDidMoveHead < curTime) then
			self.cwDidMoveHead = curTime + 0.15;
		end;
	end;
end;

function GM:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "cwCinematicView" and (tonumber(newValue) == 1)) then
		netstream.Start("ands");
	end;
end

local blackOut = {
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 0,
	[ "$pp_colour_colour" ] = 0,
}

-- Called when screen space effects should be rendered.
function Schema:RenderScreenspaceEffects()
	if Schema.contentVerified ~= "verified" then
		DrawColorModify(blackOut);
		
		return;
	end

	local curTime = CurTime();
	local choosingCharacter = Clockwork.kernel:IsChoosingCharacter();

	if (!self.nextCrossEyeCheck or self.nextCrossEyeCheck < curTime) then
		self.nextCrossEyeCheck = curTime + 1;
		
		if (Clockwork.Client:HasInitialized() or Clockwork.Client:Alive()) then
			if (Clockwork.Client:HasTrait("crosseyed")) then
				self.crosseyed = true;
			else
				self.crosseyed = false;
			end;
		end;
	end;
	
	if (self.crosseyed and !choosingCharacter) then
		if (!self.contrast or !self.distance) then
			self.contrast = 0; self.distance = 0;
			self.contrastTarget = 0; self.distanceTarget = 0;
		end;

		local frameTime = FrameTime() * 512;
		
		if (self.cwDidMoveHead and self.cwDidMoveHead > curTime) then
			self.contrastTarget = 0;
			self.distanceTarget = 0;
			frameTime = frameTime / 2
		elseif (self.contrastTarget != contrast or self.distanceTarget != distance) then
			self.contrastTarget = contrast
			self.distanceTarget = distance
		end;
		
		self.contrast = math.Approach(self.contrast, self.contrastTarget, frameTime / 100);
		self.distance = math.Approach(self.distance, self.distanceTarget, frameTime);
		
		DrawSharpen(self.contrast, self.distance)
	end;
	
	if (Clockwork.Client:GetSharedVar("blackOut") and Clockwork.Client:Alive()) then
		local blackOut = {
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0,
			[ "$pp_colour_colour" ] = 0,
		}
		
		DrawColorModify(blackOut);
		return;
	end;
	
	if (!Clockwork.kernel:IsScreenFadedBlack()) then
		local frameTime = FrameTime();
		
		if (self.flashEffect) then
			local timeLeft = math.Clamp(self.flashEffect[1] - curTime, 0, self.flashEffect[2]);
			local incrementer = 1 / self.flashEffect[2];
			
			if (timeLeft > 0) then
				modify = {};
				
				modify["$pp_colour_brightness"] = 0;
				modify["$pp_colour_contrast"] = 1 + (timeLeft * incrementer);
				modify["$pp_colour_colour"] = 1 - (incrementer * timeLeft);
				modify["$pp_colour_addr"] = incrementer * timeLeft;
				modify["$pp_colour_addg"] = 0;
				modify["$pp_colour_addb"] = 0;
				modify["$pp_colour_mulr"] = 1;
				modify["$pp_colour_mulg"] = 0;
				modify["$pp_colour_mulb"] = 0;
				
				DrawColorModify(modify);
				
				if (!self.flashEffect[3]) then
					DrawMotionBlur(1 - (incrementer * timeLeft), incrementer * timeLeft, self.flashEffect[2]);
				end;
			end;
		end;
		
		if (self.motionBlurStunEffect) then
			local timeLeft = math.Clamp(self.motionBlurStunEffect[1] - curTime, 0, self.motionBlurStunEffect[2]);
			local incrementer = 1 / self.motionBlurStunEffect[2];
		
			if (timeLeft > 0) then
				DrawMotionBlur(1 - (incrementer * timeLeft), incrementer * timeLeft, self.motionBlurStunEffect[2]);
			end;
		end

		--if (CW_CONVAR_VIGNETTE:GetInt() == 1) then
			local scrW = ScrW();
			local scrH = ScrH();

			if (!self.cwVignetteAlpha) then
				self.cwVignetteAlpha = 0;
			end;
			
			if (Clockwork.Client.cwInDark and self.cwVignetteAlpha < 255) then
				self.cwVignetteAlpha = math.Approach(self.cwVignetteAlpha, 255, frameTime * 32);
			elseif (self.cwVignetteAlpha > 0) then
				self.cwVignetteAlpha = math.Approach(self.cwVignetteAlpha, 0, frameTime * 32);
			end;
			
			if (self.cwVignetteAlpha > 0) then
				for i = 1, 2 do
					surface.SetMaterial(self.blackBlur)
					surface.SetDrawColor(Color(255, 255, 255, self.cwVignetteAlpha / (i * 2)))
					surface.DrawTexturedRect(-1, -1, scrW + 2, scrH + 2)
				end;
			end;
			
			surface.SetMaterial(self.blackBlur)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(-1, -1, scrW + 2, scrH + 2)
		--end;
		
		if (self.cwDrownEffect) then
			self.cwDrownEffect = math.Approach(self.cwDrownEffect, 0, frameTime * 16);
			
			local colorModify = {};
				colorModify["$pp_colour_mulb"] = self.cwDrownEffect;
				colorModify["$pp_colour_colour"] = self.cwDrownEffect / 2;
			DrawColorModify(colorModify);
			
			if (self.cwDrownEffect == 0) then
				self.cwDrownEffect = nil;
			end;
		end;
		
		if (CW_CONVAR_FILMGRAIN:GetInt() == 1) and !choosingCharacter then
			if Clockwork.Client.currentCycle == "night" then
				local zone = Clockwork.Client:GetZone();
				
				if zone == "wasteland" or zone == "tower" then
					if !cwDueling or (cwDueling and !Clockwork.Client.dueling) then
						render.UpdateScreenEffectTexture();
					
						self.filmGrainOverlay:SetFloat("$refractamount", 0);
						self.filmGrainOverlay:SetFloat("$envmaptint", 0);
						self.filmGrainOverlay:SetFloat("$envmap", 0);
						self.filmGrainOverlay:SetFloat("$alpha", 1);
						self.filmGrainOverlay:SetInt("$ignorez", 0);
					
						render.SetMaterial(self.filmGrainOverlay);
						render.DrawScreenQuad();
					end
				end
			end
		end;
	end;
	
	if (!Clockwork.Client.cwNextLightColor or curTime > Clockwork.Client.cwNextLightColor) then
		Clockwork.Client.cwNextLightColor = curTime + 4;
		
		if (Clockwork.Client:Alive() and Clockwork.Client:HasInitialized()) then
			local eyePosition = Clockwork.Client:EyePos();
			local lightColor = render.GetLightColor(eyePosition);
			local red, green, blue = math.Round(lightColor.x * 255), math.Round(lightColor.y * 255), math.Round(lightColor.z * 255);
			
			netstream.Start("UpdateLightColor", red, green, blue);
			Clockwork.Client.cwLightColor = Color(red, green, blue);
		end;
	end;
	
	if (!Clockwork.Client.cwNextInDark or Clockwork.Client.cwNextInDark < curTime) then
		Clockwork.Client.cwNextInDark = curTime + 0.5;
		
		if (Clockwork.Client.cwLightColor) then
			if Clockwork.Client.cwLightColor.r >= 15 or Clockwork.Client.cwLightColor.g >= 15 or Clockwork.Client.cwLightColor.b >= 15 then
				Clockwork.Client.cwInDark = false;
			else
				Clockwork.Client.cwInDark = true;
			end;
		elseif (Clockwork.Client.cwInDark) then
			Clockwork.Client.cwInDark = false;
		end;
	end;
end;

-- A function to perform a vertigo zoom effect.
function Schema:SanityZoom(zoom, inverse)
	local zoom = zoom or -0.1
	local inverse = inverse or false
	
	if (zoom == 0) then
		zoom = -0.1
	end
	
	if (inverse and zoom > 0) then
		zoom = -zoom
	elseif (inverse and zoom < 0) then
		zoom = math.abs(zoom)
	end

	Clockwork.Client.SanityZoom = zoom
end;

-- A function to add a flash effect.
function Schema:AddFlashEffect()
	local curTime = CurTime();
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + 10, 10};
	self.flashEffect = {curTime + 20, 20};
	
	surface.PlaySound("hl1/fvox/flatline.wav");
end;

-- A function to add a stun effect.
function Schema:AddStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + duration, duration};
	self.flashEffect = {curTime + (duration * 2), duration * 2, true};
end;

function Schema:AddMotionBlurStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;

	self.motionBlurStunEffect = {curTime + (duration * 2), duration * 2, true};
end;

-- A function to add a black fade effect.
function Schema:AddBlackFade(time)
	if (!self.cwBlackFade) then
		self.cwBlackFade = 0
	end
	
	if (self.cwBlackFade) then
		self.cwBlackFade = CurTime() + time
	else
		self.cwBlackFade = self.cwBlackFade + (time + 2)
	end
end

netstream.Hook("WakeupSequence", function(data)
	if CW_CONVAR_WAKEUPSEQUENCE:GetInt() == 1 or !Clockwork.Client:IsAdmin() then
		Schema:RefreshWakeupSequence();
		
		Clockwork.Client.LoadingText = true;
		
		timer.Simple(2, function()
			if Clockwork.Client.LoadingText then
				Clockwork.Client.BibleText = nil;
				Clockwork.Client.Seq1 = true;
			end
		end);
		
		Clockwork.Client:EmitSound(Schema.wakeupMusic[math.random(1, #Schema.wakeupMusic)]);
	else
		Schema:FinishWakeupSequence();
	end
end);

netstream.Hook("ForceEndWakeupSequence", function(data)
	Schema:RefreshWakeupSequence();
end);

function Schema:RefreshWakeupSequence()
	doneblinks = nil
	Clockwork.Client.Wakeup = nil;
	Clockwork.Client.WakeupAngles = nil;
	Clockwork.Client.WakeupOrigin = nil;
	Clockwork.Client.WakeupDuration = nil;
	Clockwork.Client.WakeupTime = nil;
	Clockwork.Client.BibleText = nil
	Clockwork.Client.LoadingText = nil
	Clockwork.Client.FUCKMYLIFETIME = nil
	Clockwork.Client.Seq1 = nil;
	ATYI = nil
	doneblinks = nil
	self.loadingAlpha = nil
	blinks = nil
	reqblai = nil;
	bliany = nil
	tea = nil
	CRASF = nil
	noblinky = nil
	self.timeUntilFade = nil
	self.jghrjhtjh = nil
	self.canss = nil
	self.ay = nil
end;

function Schema:FinishWakeupSequence()
	self:RefreshWakeupSequence();
	netstream.Start("FinishWakeup");
end;

Clockwork.datastream:Hook("Stunned", function(data)
	Schema:AddStunEffect(data);
end);

Clockwork.datastream:Hook("MotionBlurStunned", function(data)
	Schema:AddMotionBlurStunEffect(data, true);
end);

Clockwork.datastream:Hook("Flashed", function(data)
	Schema:AddFlashEffect();
end);

Clockwork.datastream:Hook("ClearEffects", function(data)
	Schema.stunEffects = {};
	Schema.flashEffect = nil;
	Schema.motionBlurStunEffect = nil;
	Schema.parryEffects = {}
end);

Clockwork.setting:AddCheckBox("Screen effects", "Enable cinematic film grain.", "cwFilmGrain", "Toggle the filmgrain overlay.", function() return Clockwork.player:IsAdmin(Clockwork.Client); end);
Clockwork.setting:AddCheckBox("Screen effects", "Enable Calcview hook.", "cwShowCalcView", "Click to enable/disable the Calcview hook.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Screen effects", "Enable cinematic camera.", "cwCinematicView", "Click to enable/disable cinematic camera smoothing.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Screen effects", "Cinematic camera only in observer.", "cwCinematicViewObs", "Enables the cinematic camera only when you are in observer.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);

--
Clockwork.setting:AddCheckBox("Wakeup sequence", "Enable the wakeup sequence.", "cwWakeupSequence", "Click to enable/disable the wakeup sequence.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);
Clockwork.setting:AddCheckBox("Zones", "Enable motion blur.", "cwShowBlur", "Click to enable/disable motion blur.", function() return Clockwork.player:IsAdmin(Clockwork.Client) end);