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

function cwPossession:PreDrawPlayerHands(ent, viewModel, player, weapon)
	if Clockwork.Client.victim then
		return true;
	end
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
				
				draw.SimpleText("Poise:", "UseHint", 50, 115, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
				draw.SimpleText(victim:GetNWInt("meleeStamina", 100), "UseHint", 120, 115, COLOR_WHITE, TEXT_ALIGN_LEFTR, TEXT_ALIGN_RIGHT);
				
				if IsValid(victim:GetActiveWeapon()) then
					draw.SimpleText("Weapon:", "UseHint", 50, 140, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					draw.SimpleText(victim:GetActiveWeapon():GetPrintName(), "UseHint", 120, 140, COLOR_WHITE, TEXT_ALIGN_LEFTR, TEXT_ALIGN_RIGHT);
				
					draw.SimpleText("Raised:", "UseHint", 50, 165, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					draw.SimpleText(tostring(victim:IsWeaponRaised()), "UseHint", 120, 165, victim:IsWeaponRaised() and COLOR_GREEN or COLOR_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					
					draw.SimpleText("Stance:", "UseHint", 50, 190, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					
					if victim:GetNWBool("ThrustStance") == true then
						draw.SimpleText("Thrust", "UseHint", 120, 190, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					else
						draw.SimpleText("Swipe", "UseHint", 120, 190, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT);
					end
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

function cwPossession:CanShowTabMenu()
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
		
		Clockwork.menu:SetOpen(false);
		Clockwork.character:SetPanelOpen(false);
		
		if (IsValid(Clockwork.Client.cwBeliefPanel)) then
			Clockwork.Client.cwBeliefPanel:Close()
			Clockwork.Client.cwBeliefPanel:Remove()
			Clockwork.Client.cwBeliefPanel = nil;
		end
		
		if (IsValid(Clockwork.Client.cwCraftingMenu)) then
			Clockwork.Client.cwCraftingMenu:Close()
			Clockwork.Client.cwCraftingMenu:Remove()
			Clockwork.Client.cwCraftingMenu = nil;
		end
		
		if (IsValid(Clockwork.Client.cwRitualsMenu)) then
			Clockwork.Client.cwRitualsMenu:Close()
			Clockwork.Client.cwRitualsMenu:Remove()
			Clockwork.Client.cwRitualsMenu = nil;
		end
		
		if cwMusic then
			cwMusic:StopAmbientMusic();
			cwMusic:StopBattleMusic();
		end
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

-- Radial Menu Stuff

local radialSelect;
local radialSelectPanel;
local radialSelectStop = -1;
local radialMenuOpen = 0;
local fadeout = 255;
local dist;

surface.CreateFont( "radial", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(14),
	weight = 900,
})

surface.CreateFont( "radial_big", {
	font = "Immortal",
	extended = false,
	size = Clockwork.kernel:FontScreenScale(20),
	weight = 900,
})

function cwPossession:ScoreboardShow()
	if !Clockwork.Client.victim then
		return;
	end
	
	radialMenuOpen = 1;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local x = scrW / 2;
	local textColor = Color(170, 0, 0);
	
	if not radialMenu then
		radialMenu = vgui.Create( "DFrame" )
		radialMenu.center = vgui.Create( "DLabel", radialMenu )
		radialMenu.north = vgui.Create( "DLabel", radialMenu )
		radialMenu.northeast = vgui.Create( "DLabel", radialMenu )
		radialMenu.east = vgui.Create( "DLabel", radialMenu )
		radialMenu.southeast = vgui.Create( "DLabel", radialMenu )
		radialMenu.south = vgui.Create( "DLabel", radialMenu )
		radialMenu.southwest = vgui.Create( "DLabel", radialMenu )
		radialMenu.west = vgui.Create( "DLabel", radialMenu )
		radialMenu.northwest = vgui.Create( "DLabel", radialMenu )
	end;
	
	radialMenu:SetSize(x, x)
	radialMenu:SetPos(scrW / 2 - (x/2), scrH / 2 - (x/2));
	radialMenu:SetDraggable(false)
	radialMenu:ShowCloseButton(false);

	radialMenu:SetTitle("");
	radialMenu.mouseX = scrW / 2;
	radialMenu.mouseY = scrH / 2;
	radialMenu.mouseX2 = scrW / 2;
	radialMenu.mouseY2 = scrH / 2;
	gui.EnableScreenClicker(1);
	radialMenu:SetCursor("blank");
	
	size = radialMenu:GetSize() / 2
	centerpos = size*.5
	
	radialSelect = radialMenu.center;

	radialMenu.center:SetSize( (size), (size) )
	radialMenu.center:SetPos( centerpos, centerpos )
	radialMenu.center:SetText( "Demon Heal" )
	radialMenu.center:SetTextColor(textColor);
	radialMenu.center:SetContentAlignment(5);
	radialMenu.center:SetFont("radial");
	radialMenu.center.callback = function()
		Clockwork.kernel:RunCommand("DemonHeal");
	end

	radialMenu.north:SetSize( (size), (size) )
	radialMenu.north:SetPos( centerpos, centerpos * .25 )
	radialMenu.north:SetText( "Demon Shriek" )
	radialMenu.north:SetTextColor(textColor);
	radialMenu.north:SetContentAlignment(5);
	radialMenu.north:SetFont("radial");
	radialMenu.north.callback = function()
		Clockwork.kernel:RunCommand("DemonShriek");
	end

	radialMenu.northeast:SetSize( (size), (size) )
	radialMenu.northeast:SetPos( centerpos * 1.525, centerpos * .625 )
	radialMenu.northeast:SetText( "Untie" )
	radialMenu.northeast:SetTextColor(textColor);
	radialMenu.northeast:SetContentAlignment(5);
	radialMenu.northeast:SetFont("radial");
	radialMenu.northeast.callback = function()
		Clockwork.kernel:RunCommand("ForceUntie", Clockwork.Client.victim:Name());
	end

	radialMenu.east:SetSize( (size), (size) )
	radialMenu.east:SetPos( centerpos * 1.625, centerpos )
	radialMenu.east:SetText( "Summon" )
	radialMenu.east:SetTextColor(textColor);
	radialMenu.east:SetContentAlignment(5);
	radialMenu.east:SetFont("radial");
	radialMenu.east.callback = function()
		Clockwork.kernel:RunCommand("PlySummonDemon", Clockwork.Client.victim:Name());
	end
	
	radialMenu.southeast:SetSize( (size), (size) )
	radialMenu.southeast:SetPos( centerpos * 1.525, centerpos * 1.375 )
	radialMenu.southeast:SetText( "Fallover" )
	radialMenu.southeast:SetTextColor(textColor);
	radialMenu.southeast:SetContentAlignment(5);
	radialMenu.southeast:SetFont("radial");
	radialMenu.southeast.callback = function()
		Clockwork.kernel:RunCommand("ForceFallover", Clockwork.Client.victim:Name());
	end
	
	radialMenu.south:SetSize( (size), (size) )
	radialMenu.south:SetPos( centerpos, centerpos * 1.75 )
	radialMenu.south:SetText( "Unpossess" )
	radialMenu.south:SetTextColor(textColor);
	radialMenu.south:SetContentAlignment(5);
	radialMenu.south:SetFont("radial");
	radialMenu.south.callback = function()
		Clockwork.kernel:RunCommand("PlyUnPossess");
	end
	
	radialMenu.southwest:SetSize( (size), (size) )
	radialMenu.southwest:SetPos( centerpos * 0.475, centerpos * 1.375 )
	radialMenu.southwest:SetText( "Suicide"	)
	radialMenu.southwest:SetTextColor(textColor);
	radialMenu.southwest:SetContentAlignment(5);
	radialMenu.southwest:SetFont("radial");
	radialMenu.southwest.callback = function()
		Clockwork.kernel:RunCommand("ForceSuicide", Clockwork.Client.victim:Name());
	end
	
	radialMenu.west:SetSize( (size), (size) )
	radialMenu.west:SetPos( centerpos * .375, centerpos )
	radialMenu.west:SetText( "Explode" )
	radialMenu.west:SetTextColor(textColor);
	radialMenu.west:SetContentAlignment(5);
	radialMenu.west:SetFont("radial");
	radialMenu.west.callback = function()
		Clockwork.kernel:RunCommand("ExplodePlayer", Clockwork.Client.victim:Name());
	end
	
	radialMenu.northwest:SetSize( (size), (size) )
	radialMenu.northwest:SetPos( centerpos * 0.475, centerpos * .625 )
	radialMenu.northwest:SetText( "Open Inventory" )
	radialMenu.northwest:SetTextColor(textColor);
	radialMenu.northwest:SetContentAlignment(5);
	radialMenu.northwest:SetFont("radial");
	radialMenu.northwest.callback = function()
		Clockwork.kernel:RunCommand("PlySearch", Clockwork.Client.victim:Name());
	end
	
	function radialMenu:Think() -- x + x / (scrW / 2) (mouse sensitivity increase?)
		local ScrW = scrW;
		local ScrH = scrH;
		
		local m_cursorX = gui.MouseX();
		local m_cursorY = gui.MouseY();
		
		local centerx = ScrW / 2;
		local centery = ScrH / 2;
		
		local m_maxButtonX = ScrW / 1.5;
		local m_maxButtonY = ScrH / 1.5;
		
		local cursorDistX = ( m_cursorX - centerx );
		local cursorDistY = ( m_cursorY - centery );
		local buttonRadius = math.max(m_maxButtonX - centerx, m_maxButtonY - centery);
		
		local cursorDist = math.sqrt((cursorDistX * cursorDistX) + (cursorDistY * cursorDistY));
		
		if(radialMenuOpen == 1) then
			if(cursorDistX != 0.0 and cursorDistY != 0.0) then
				if(cursorDist > buttonRadius) then
					cursorDistX = cursorDistX * (buttonRadius / cursorDist);
					cursorDistY = cursorDistY * (buttonRadius / cursorDist);
					
					m_cursorX = centerx + cursorDistX;
					m_cursorY = centery + cursorDistY;

					input.SetCursorPos( m_cursorX, m_cursorY );
					radialMenu:SetCursor("blank");
				end;
			end;
		end;
		
		local ang = math.abs(math.deg(math.atan((gui.MouseY() - ScrH / 2)/(gui.MouseX() - ScrW / 2))))

		if (gui.MouseX() < centerx) then -- under center height
			if (gui.MouseY() > centery) then --
				ang = -90 - ang-- make negative
			else
				ang = ang - 90 -- make negative, add inner radius outer radius check with a gap 2/9/20
			end
		else						-- over center height
			if (gui.MouseY() > centery) then
				ang = 90 + ang
			else
				ang = 90 - ang
			end
		end
		
		if(radialMenuOpen == 1) then	
			if(cursorDist < buttonRadius / 2) then -- 2 or 3?
				radialSelect = radialMenu.center;
			else
				if(ang >= -22.5 and ang < 22.5) then
					radialSelect = radialMenu.north;
				elseif(ang >= 22.5 and ang < 67.5) then
					radialSelect = radialMenu.northeast;
				elseif(ang >= 67.5 and ang < 112.5) then
					radialSelect = radialMenu.east;
				elseif(ang >= 112.5 and ang < 157.5) then
					radialSelect = radialMenu.southeast;
				elseif(ang >= 157.5 or ang < -157.5) then -- wrap around -180 180
					radialSelect = radialMenu.south;
				elseif(ang >= -157.5 and ang < -112.5) then
					radialSelect = radialMenu.southwest;
				elseif(ang >= -112.5 and ang < -67.5) then
					radialSelect = radialMenu.west;
				elseif(ang >= -67.5 and ang < -22.5) then
					radialSelect = radialMenu.northwest;
				end;
			end;
			
			if(radialSelect == radialMenu.center and radialSelectStop != 0) then
				radialSelectStop = 0;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.center:SetFont("radial_big");
			elseif(radialSelect != radialMenu.center) then
				radialMenu.center:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.north and radialSelectStop != 1) then
				radialSelectStop = 1;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.north:SetFont("radial_big");
			elseif(radialSelect != radialMenu.north) then
				radialMenu.north:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.northeast and radialSelectStop != 2) then
				radialSelectStop = 2;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.northeast:SetFont("radial_big");
			elseif(radialSelect != radialMenu.northeast) then
				radialMenu.northeast:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.east and radialSelectStop != 3) then
				radialSelectStop = 3;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.east:SetFont("radial_big");
			elseif(radialSelect != radialMenu.east) then
				radialMenu.east:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.southeast and radialSelectStop != 4) then
				radialSelectStop = 4;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.southeast:SetFont("radial_big");
			elseif(radialSelect != radialMenu.southeast) then
				radialMenu.southeast:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.south and radialSelectStop != 5) then
				radialSelectStop = 5;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.south:SetFont("radial_big");
			elseif(radialSelect != radialMenu.south) then
				radialMenu.south:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.southwest and radialSelectStop != 6) then
				radialSelectStop = 6;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.southwest:SetFont("radial_big");
			elseif(radialSelect != radialMenu.southwest) then
				radialMenu.southwest:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.west and radialSelectStop != 7) then
				radialSelectStop = 7;
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.west:SetFont("radial_big");
			elseif(radialSelect != radialMenu.west) then
				radialMenu.west:SetFont("radial");
			end;
			
			if(radialSelect == radialMenu.northwest and radialSelectStop != 8) then
				radialSelectStop = 8
				surface.PlaySound("buttons/lightswitch2.wav");
				radialMenu.northwest:SetFont("radial_big");
			elseif(radialSelect != radialMenu.northwest) then
				radialMenu.northwest:SetFont("radial");
			end;
		end;
		
		if(radialMenuOpen == 0) then
			fadeout = fadeout - FrameTime() * 200;
			radialMenu:SetAlpha(fadeout);
			gui.EnableScreenClicker( false );
			
			if(fadeout <= 0) then
				radialSelect = nil;
				radialSelectStop = -1;
				fadeout = 0;
				radialMenu:Close();
				radialMenu = nil;
			end;
		else
			if(fadeout < 255) then
				fadeout = 255;
				radialMenu:SetAlpha(255);
				gui.EnableScreenClicker( 1 );
			end;
		end;
	end;
	
	function radialMenu:OnMousePressed( mousecode )
		if(mousecode == MOUSE_LEFT and radialMenuOpen == 1) then
			cwPossession:ScoreboardHide();
			
			radialMenuOpen = 0;
		elseif(mousecode == MOUSE_RIGHT and radialMenuOpen == 1) then
			radialMenuOpen = 0;
			surface.PlaySound("garrysmod/ui_return.wav");
		end;
	end;
	
	function radialMenu:Paint()
		surface.SetDrawColor(0, 0, 0, 0);
	end;
end;

-- Called when the scoreboard should be hidden.
function cwPossession:ScoreboardHide()
	if (radialMenuOpen == 0) then
		return;
	end;

	if radialSelect and radialSelect.callback then
		radialSelect.callback();	
	end
	
	if (radialMenu and radialMenu:IsVisible()) then
		radialMenuOpen = 0;
	end;
end