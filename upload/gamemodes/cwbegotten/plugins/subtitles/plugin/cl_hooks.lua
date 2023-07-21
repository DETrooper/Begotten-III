--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when the client initializes.
function cwCinematicText:Initialize()
	CW_CONVAR_SHOWCINEMATICS = Clockwork.kernel:CreateClientConVar("cwShowCinematics", 1, true, true);
end;

-- Called when the chat box info should be adjusted.
function cwCinematicText:ChatBoxAdjustInfo(info)
	if (Clockwork.Client:Alive()) then
		if (info.shouldHear) then
			if (CW_CONVAR_SHOWCINEMATICS:GetInt() == 1) then
				local textColor = Color(255, 255, 255);
				local goodClasses = {
					"ic",
					"yell",
					"whisper"
				};
				
				if (info.focusedOn) then
					textColor = Color(255, 255, 150);
				end;
				
				if (info.filter == "ic" and table.HasValue(goodClasses, info.class)) then
					local doesRecognise = Clockwork.player:DoesRecognise(info.speaker);
					local nameText = info.name;
					
					if (!doesRecognise) then
						nameText = "["..string.sub(Clockwork.player:GetPhysDesc(info.speaker), 0, 21).."...]";
					end
					
					if (info.class == "yell") then
						info.text = string.Trim(info.text, "!")
						info.text = string.Trim(info.text, ".")

						info.text = info.text.."!";
					elseif (info.class == "whisper") then
						info.text = info.text.."...";
					end;
					
					local lastChar = string.sub(info.text, string.len(info.text));
					local sayText = "says";
					
					if info.class == "ic" then
						if lastChar == "?" then
							sayText = "asks";
						elseif lastChar == "!" then
							sayText = "exclaims";
						end
					elseif info.class == "yell" then
						sayText = "yells";
					elseif info.class == "whisper" then
						sayText = "whispers";
					end
					
					if info.font then
						if info.font == "Voltism" then
							sayText = "chirps";
							
							if info.class == "ic" then
								if lastChar == "?" then
									sayText = "queries";
								elseif lastChar == "!" then
									sayText = "emits";
								end
							elseif info.class == "yell" then
								sayText = "shrieks";
							end
						end
					end
					
					cwCinematicText:PrintTextCenter(nameText.." "..sayText.." ".."\""..info.text.."\"", 10, textColor, info.font);
				end;
			end;
		end;
	end;
end;

-- Called when the foreground HUD should be painted.
function cwCinematicText:HUDPaintImportant()
	if (!hook.Run("CanPaintChatbox")) then
		return;
	end;
	local cinematicTextFont = Clockwork.option:GetFont("auto_bar_text");
	local colorWhite = Clockwork.option:GetColor("white");
	local frameTime = FrameTime();
	local curTime = CurTime();
	local scrW = ScrW();
	local scrH = ScrH();
	local x, y = scrW * 0.5, scrH * 0.8;

	if (!self.cinematicTexts) then
		self.cinematicTexts = {};
	end;
	
	if (table.Count(self.cinematicTexts) >= 8) then
		table.remove(self.cinematicTexts, 1);
	end;

	for k, v in pairs (self.cinematicTexts) do
		local cinematicText = v;
		
		if (!cinematicText.fadeColor) then
			cinematicText.fadeColor = Color(255, 255, 255, 255);
		end;
		
		if (!cinematicText.fadeDirection) then
			cinematicText.fadeDirection = 0;
		end;
		
		if (!cinematicText.fadeBack or curTime >= cinematicText.fadeBack) then
			cinematicText.alpha = math.Approach(cinematicText.alpha, cinematicText.targetAlpha, frameTime * 196);
			
			if (cinematicText.targetAlpha == 0) then
				cinematicText.fadeColor.r = math.Approach(cinematicText.fadeColor.r, 0, frameTime * 256);
				cinematicText.fadeColor.g = math.Approach(cinematicText.fadeColor.g, 0, frameTime * 256);
				cinematicText.fadeColor.b = math.Approach(cinematicText.fadeColor.b, 0, frameTime * 256);
			end;
			
			if (cinematicText.fadeDirection > -50 or cinematicText.fadeDirection < 50) then
				if (!cinematicText.chosenDirection) then
					cinematicText.chosenDirection = table.Random({-50, 50});
				end;
				
				cinematicText.fadeDirection = math.Approach(cinematicText.fadeDirection, cinematicText.chosenDirection, frameTime * 32);
			end;
		end;
		
		if (!cinematicText.delay) then
			cinematicText.delay = 5;
		end;
		
		if (!cinematicText.color) then
			cinematicText.color = Color(255, 255, 255, 255);
		end;

		if (cinematicText.targetAlpha == 0 and cinematicText.alpha == 0) then
			table.remove(self.cinematicTexts, k);
			return;
		elseif (cinematicText.targetAlpha == 255 and cinematicText.alpha == 255 and !cinematicText.fadeBack) then
			cinematicText.targetAlpha = 0;
			cinematicText.fadeBack = curTime + cinematicText.delay;
		end;

		for k2, v2 in ipairs (cinematicText.text) do
			Clockwork.kernel:OverrideMainFont(cinematicText.font or cinematicTextFont);
				y = Clockwork.kernel:DrawInfo(v2, x + cinematicText.offset + cinematicText.fadeDirection, y, cinematicText.fadeColor, cinematicText.alpha, nil, nil, 1);
			Clockwork.kernel:OverrideMainFont(false);
		end;
	end;
end;