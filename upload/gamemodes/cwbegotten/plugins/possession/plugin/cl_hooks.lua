--[[
	Begotten III: Jesus Wept
--]]

local glowMaterial = Material("sprites/redglow1");

surface.CreateFont("UseHint", {font = "Trebuchet24", size = 18, weight = 750});

-- Called each tick.
function cwPossession:Tick()
	local curTime = CurTime();
	
	if !self.possessionCheck or self.possessionCheck <= curTime then
		self.possessionCheck = curTime + 0.5;
		
		if Clockwork.Client.possessor then
			if !IsValid(Clockwork.Client.possessor) or !Clockwork.Client:GetSharedVar("currentlyPossessed") then
				if Clockwork.Client.PossessedSound then
					Clockwork.Client.PossessedSound:Stop();
				end
				
				Clockwork.Client.possessor = nil;
			end
		elseif Clockwork.Client.victim then
			if !IsValid(Clockwork.Client.victim) or !Clockwork.Client.victim:GetSharedVar("currentlyPossessed") then
				if Clockwork.Client.PossessedSound then
					Clockwork.Client.PossessedSound:Stop();
				end
			
				--Clockwork.Client:DrawViewModel(true); -- shit doesn't work
				Clockwork.Client.victim = nil;
			end
		end
	end
end

-- Called to get the action text of a player.
function cwPossession:GetStatusInfo(player, text)
	local trackedPlayerID = Clockwork.Client:GetNetVar("tracktarget");
	
	if trackedPlayerID then
		local steamID = player:SteamID();
		
		if steamID then
			if steamID == trackedPlayerID then
				table.insert(text, "[TRACKING]");
			end
		end
	end
end

-- Called when the local player attempts to see the top bars.
function cwPossession:PlayerCanSeeBars(class)
	if (Clockwork.Client.victim) then
		return false;
	end
end

function cwPossession:KeyPress(player, key)
	--[[if (key == IN_RELOAD or key == IN_ATTACK or key == IN_ATTACK2) then
		print("A");
		return false;
	end]]--
end

function cwPossession:HUDPaint()
	if Clockwork.Client.victim and IsValid(Clockwork.Client.victim) then
		local victim = Clockwork.Client.victim;
		
		if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:Alive() then
			if !cwDayNight.moonHallucination and !Clockwork.Client.CosmicRuptureRender then
				local scrW, scrH = ScrW(), ScrH();
				local width = 200 / 1.5
				
				draw.SimpleText("POSSESSING "..string.upper(victim:Name()), "UseHint", 50, 40, COLOR_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				
				draw.SimpleText("Health:", "UseHint", 50, 65, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				draw.SimpleText(victim:Health(), "UseHint", 120, 65, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				
				draw.SimpleText("Stamina:", "UseHint", 50, 90, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				draw.SimpleText(victim:GetNetVar("Stamina", 100), "UseHint", 120, 90, COLOR_WHITE, TEXT_ALIGN_LEFTR, TEXT_ALIGN_RIGHT);
				
				if IsValid(victim:GetActiveWeapon()) then
					draw.SimpleText("LAlt:", "UseHint", 50, 115, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					draw.SimpleText(victim:GetActiveWeapon():GetPrintName().." Raised: "..tostring(victim:IsWeaponRaised()), "UseHint", 120, 115, victim:IsWeaponRaised() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					
					draw.SimpleText("Tab:         Change Weapon Stance", "UseHint", 50, 140, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				end
			end
		end
	end
end

-- Called when the target's marked status should be drawn.
function cwPossession:DrawTargetPlayerMarked(target, alpha, x, y)
	local trackedPlayerID = Clockwork.Client:GetNetVar("tracktarget");
	
	if trackedPlayerID then
		local steamID = target:SteamID();
		
		if steamID then
			if steamID == trackedPlayerID then
				y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData("{TRACKED}"), x, y, Color(255, 0, 200), alpha);
				
				return y;
			end
		end
	end
end;

function cwPossession:AddEntityOutlines(outlines)
	local trackedPlayerID = Clockwork.Client:GetNetVar("tracktarget");
	if trackedPlayerID then
		local playerCount = _player.GetCount();
		local players = _player.GetAll();

		for i = 1, playerCount do
			local v, k = players[i], i;
			if v:SteamID() == trackedPlayerID then
				self:DrawPlayerOutline(v, outlines, Color(255, 0, 255, 255));
			end;
		end;
	end
end

function cwPossession:DrawPlayerOutline(player, outlines, color)
	if (player:GetMoveType() == MOVETYPE_WALK) then
		outlines:Add(player, color, 2, true);
	elseif player:IsRagdolled() then
		outlines:Add(player:GetRagdollEntity(), color, 2, true);
	end;
end;

-- Called when the screenspace effects are rendered.
function cwPossession:PostDrawOpaqueRenderables()
	local entitiesInSphere = ents.FindInSphere(Clockwork.Client:GetPos(), 512);
	
	for k, v in pairs (entitiesInSphere) do	
		if (IsValid(v) and v:IsPlayer() and (v:GetMoveType() == MOVETYPE_WALK or v:IsRagdolled())) then
			if v:GetSharedVar("currentlyPossessed") or v:GetSharedVar("possessionFreakout") then
				if v ~= Clockwork.Client and !Clockwork.Client.victim then
					local headBone = v:LookupBone("ValveBiped.Bip01_Head1");
					
					if (headBone) then
						local bonePosition, boneAngles = v:GetBonePosition(headBone);
						local eyes = v:LookupAttachment("eyes");
						local eyesAttachment = v:GetAttachment(eyes);
						
						if (bonePosition and eyesAttachment) then
							local glowColor = Color(255, 50, 50, 255);
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
				
				if cwMusic then
					cwMusic:FadeOutAmbientMusic(2, 1);
				end
			end;
		end; 
	end;
end;

function cwPossession:RenderScreenspaceEffects()
	local curTime = CurTime();
	
	if Clockwork.Client.possessor or Clockwork.Client.victim then
		if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() and Clockwork.Client:Alive() then
			if !cwDayNight.moonHallucination and !Clockwork.Client.CosmicRuptureRender then
				if !Clockwork.Client.PossessionOverlayCheck or Clockwork.Client.PossessionOverlayCheck < curTime then
					overlay = false;
					
					if !Clockwork.Client:IsNoClipping() then
						overlay = true;
					end
					
					Clockwork.Client.PossessionOverlayCheck = curTime + 0.1;
				end
				
				if overlay then
					DrawMaterialOverlay("begotten/effects/veins", 0.1);
					DrawMaterialOverlay("begotten/effects/sanity_overlay", 0.1);
					DrawMaterialOverlay("begotten/effects/veins", 0.1);
				end
			end
		end
	end
end;

function cwPossession:PlayerDrawWeaponSelect()
	if (Clockwork.Client.possessor) then
		return false;
	end;
end

Clockwork.datastream:Hook("Possessing", function(data)
	if IsValid(data) then
		Clockwork.Client.victim = data;
		
		--Clockwork.Client:DrawViewModel(false); -- shit doesn't work
		Clockwork.Client:EmitSound("possession/st_decent.wav");
		
		timer.Simple(3.5, function()
			if IsValid(Clockwork.Client.victim) then
				Clockwork.Client.PossessedSound = CreateSound(Clockwork.Client, "misc/st_seventhday_03.wav");
				Clockwork.Client.PossessedSound:PlayEx(0.4, 100);
			end
		end);
	end
end);

Clockwork.datastream:Hook("Possessed", function(data)
	if IsValid(data) then
		Clockwork.Client.possessor = data;
		
		Clockwork.Client:EmitSound("possession/st_decent.wav");
		
		timer.Simple(3.5, function()
			if IsValid(Clockwork.Client.possessor) then
				Clockwork.Client.PossessedSound = CreateSound(Clockwork.Client, "misc/st_seventhday_03.wav");
				Clockwork.Client.PossessedSound:PlayEx(0.4, 100);
			end
		end);
	end
end);

net.Receive("PossessionFreakoutAnim", function()
	local target = net.ReadEntity();
	
	if target:IsValid() and target:Alive() then
		local lookup = target:LookupSequence("a_possession_crazy")
		
		target:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, lookup, 0, false);
		
		timer.Simple(30, function()
			if IsValid(target) then
				target:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM);
			end
		end);
	end 
end);

Clockwork.chatBox:RegisterClass("demontalk", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), "An overpowering voice in the back of your head speaks to you: "..info.text);
end);

Clockwork.chatBox:RegisterClass("demonnicetalk", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(255, 251, 219, 255), "A melodic and deep voice thunders in the back of your head: "..info.text);
end);

Clockwork.chatBox:RegisterClass("demonhosttalk", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), "You gather all your strength and speak inside your mind to the demon "..info.text);
end);

Clockwork.chatBox:RegisterClass("whispersomeone", "ic", function(info)
	if (info.shouldHear) then
		local color = Color(255, 255, 175, 255);
							
		if (info.focusedOn) then
			color = Color(175, 255, 175, 255);
		end;

		if info.font then
			Clockwork.chatBox:Add(info.filtered, nil, color, "Someone whispers \""..info.text.."\"", info.font);
		else
			Clockwork.chatBox:Add(info.filtered, nil, color, "Someone whispers \""..info.text.."\"");
		end;
	end;
end);
