local line1 = "Begotten";
local line2 = "Corpsemas";

function cwIntroduction:Skip(player)
	if !player.demiurge then
		cwIntroduction:InitDemiurge(player);
	end

    player.demiurge.line1 = #line1;
    player.demiurge.line2 = #line2+1;
    player.demiurge.skipped = true;
    player.demiurge.allowInput = true;

    player.demiurge.blackAlpha[1] = 0;
    player.demiurge.begottenAlpha[1] = 255;

    for _, v in pairs(player.demiurge.apocalypseAlpha) do
        v[1] = 255;
    end
end

function cwIntroduction:DoIntro(player)
    player.Pending = true;

	timer.Simple(0.15, function()
        player.Pending = nil;
        self:StartDemiurge(player);

		if !Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
	end);
end

netstream.Hook("MenuIntro", function(skip_enabled)
	if (Clockwork.ConVars.INTROENABLED:GetInt() ~= 1) and skip_enabled then
		if not Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
		
		cwIntroduction:Skip(Clockwork.Client);
		
		local snd = file.Exists("sound/apocalypse/district21.mp3", "GAME") and "sound/apocalypse/district21.mp3" or "sound/vo/k_lab/kl_fiddlesticks.wav";
		
		sound.PlayFile(snd, "noplay noblock", function(station, errCode, errStr)
			if(!IsValid(station) or !station) then ErrorNoHalt("[Clockwork] Unable to load Demiurge music! "..errStr.." ["..errCode.."]"); end

			Clockwork.Client.demiurge.station = station;
			
			if (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
				Clockwork.Client.demiurge.station:SetVolume((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100);
				Clockwork.Client.demiurge.station:Play();
			end
		end);
		
		return;
	end
	
    cwIntroduction:DoIntro(Clockwork.Client);
end);

netstream.Hook("JesusWeptIntro", function(skip_enabled)
	if (Clockwork.ConVars.INTROENABLED:GetInt() ~= 1) and skip_enabled then
		if not Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
		
		cwIntroduction:Skip(Clockwork.Client);
		
		local snd = file.Exists("sound/apocalypse/district21.mp3", "GAME") and "sound/apocalypse/district21.mp3" or "sound/vo/k_lab/kl_fiddlesticks.wav";
		
		sound.PlayFile(snd, "noplay noblock", function(station, errCode, errStr)
			if(!IsValid(station) or !station) then ErrorNoHalt("[Clockwork] Unable to load Demiurge music! "..errStr.." ["..errCode.."]"); end

			Clockwork.Client.demiurge.station = station;
			
			if (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
				Clockwork.Client.demiurge.station:SetVolume((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100);
				Clockwork.Client.demiurge.station:Play();
			end
		end);
		
		return;
	end
	
    cwIntroduction:DoIntro(Clockwork.Client);
end);

-- Called every frame.
function cwIntroduction:Tick()
	if (!Clockwork.kernel:IsChoosingCharacter()) then
		if (Clockwork.Client.MusicSound and !Clockwork.Client.MusicFading) then
			Clockwork.Client.MusicFading = true
			Clockwork.Client.MusicSound:FadeOut(4)
			
			timer.Simple(4, function()
				Clockwork.Client.MusicFading = nil
				Clockwork.Client.MusicSound = nil
				Clockwork.Client.MusicSoundFadedOut = true
			end)
		end
	elseif (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
		if (Clockwork.Client.MusicSoundFadedOut) then
			if (!Clockwork.Client.MusicSound) then
				Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "apocalypse/district21.mp3")
				Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100), 100)

				Clockwork.Client.MusicFading = false
			end
		end
	end
end

function cwIntroduction:InitDemiurge(player)
    player.demiurge = {};
    player.demiurge.blackAlpha = {255, 255, 0, 0, 0};
    player.demiurge.begottenAlpha = {0, 0, 0, 0, 0};
    player.demiurge.allowInput = false;
    player.demiurge.apocalypseAlpha = {};
    player.demiurge.skipped = false;

    for i = 1, #line2 do player.demiurge.apocalypseAlpha[i] = {0, 0, 0, 0, 0}; end
end

function cwIntroduction:PlaySong(player)
    local snd = file.Exists("sound/apocalypse/district21.mp3", "GAME") and "sound/apocalypse/district21.mp3" or "sound/vo/k_lab/kl_fiddlesticks.wav";
    local skip = 1;

    sound.PlayFile(snd, "noplay noblock", function(station, errCode, errStr)
        if(!IsValid(station) or !station) then ErrorNoHalt("[Clockwork] Unable to load Demiurge music! "..errStr.." ["..errCode.."]"); end

        player.demiurge.station = station;
		
		if (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
			player.demiurge.station:SetVolume((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100);
			player.demiurge.station:Play();
		end

        timer.Simple(1.708*skip, function()
            if(!player.demiurge or (player.demiurge and player.demiurge.skipped)) then return; end

            player.demiurge.blackAlpha[5] = 255;
            player.demiurge.blackAlpha[2] = 0;
            player.demiurge.blackAlpha[3] = CurTime();
            player.demiurge.blackAlpha[4] = 20;

            timer.Simple(7.524*skip, function()
                if(!player.demiurge or (player.demiurge and player.demiurge.skipped)) then return; end

                player.demiurge.begottenAlpha[5] = 0;
                player.demiurge.begottenAlpha[2] = 255;
                player.demiurge.begottenAlpha[3] = CurTime();
                player.demiurge.begottenAlpha[4] = 5;

                timer.Simple(1.997, function()
                    if(!player.demiurge or (player.demiurge and player.demiurge.skipped)) then return; end

                    for i = 1, #line2 do
                        player.demiurge.apocalypseAlpha[i][5] = 0;
                        player.demiurge.apocalypseAlpha[i][2] = 255;
                        player.demiurge.apocalypseAlpha[i][3] = CurTime() + (i*.85);
                        player.demiurge.apocalypseAlpha[i][4] = 0.9;

                        if(i != #line2) then continue; end

                        timer.Simple((i-0.5)+1, function()
                            if(!player.demiurge or (player.demiurge and player.demiurge.skipped)) then return; end

                            player.demiurge.allowInput = true;
                        end);
                    end
                end);
            end);
        end);
    end);
end

function cwIntroduction:StartDemiurge(player)
    if(player.demiurge and IsValid(player.demiurge.station)) then player.demiurge.station:Stop(); end

    player.doneDemiurge = true;
    player.blockEffects = false;

    self:InitDemiurge(player);

    self:PlaySong(player);
end

function cwIntroduction:StopDemiurge(player)
    if (!player.demiurge) then return end;

	if IsValid(player.demiurge.station) then
		player.demiurge.station:Stop();
		player.demiurge.station = nil;
		Clockwork.Client.MusicSoundFadedOut = true
	end

    player.blockEffects = false;
end

function cwIntroduction:GetPlayerCharacterScreenVisible(panel)
	if (Clockwork.Client.Pending or (Clockwork.Client.demiurge and !Clockwork.Client.demiurge.allowInput)) then return false; end
end

function cwIntroduction:Think()
    local player = LocalPlayer() --Clockwork.Client;
    local curTime = CurTime();

    if (!Clockwork.kernel:IsChoosingCharacter() and player.demiurge and ((player.doneDemiurge and !player.demiurge.fading) or player.demiurge.skipped)) then
        self:StopDemiurge(player);
    elseif(Clockwork.kernel:IsChoosingCharacter() and !player.demiurge and player.doneDemiurge) then
        self:StartDemiurge(player);
        self:Skip(player);
    end

    if(!player.demiurge or player.demiurge.skipped) then return; end

    player.demiurge.blackAlpha[1] = Lerp((curTime - player.demiurge.blackAlpha[3])/player.demiurge.blackAlpha[4], player.demiurge.blackAlpha[5], player.demiurge.blackAlpha[2]);

    player.demiurge.begottenAlpha[1] = Lerp((curTime - player.demiurge.begottenAlpha[3])/player.demiurge.begottenAlpha[4], player.demiurge.begottenAlpha[5], player.demiurge.begottenAlpha[2]);

    for _, v in pairs(player.demiurge.apocalypseAlpha) do
        v[1] = Lerp((curTime - v[3])/v[4], v[5], v[2]);
    end
end

local function makeFont(title, font)
    surface.CreateFont(title,
    {
    	font		= font,
    	size		= ScreenScale(69),
    	weight		= 700,
    	antialiase	= true,
    	additive 	= false,
    	extended 	= true
    });
end

makeFont("demiurgemenuTextDistrict21", "Subway Haze");

function cwIntroduction:DrawOverlay()
    local player = LocalPlayer() --Clockwork.Client;
    local width, height = ScrW(), ScrH();
    local halfWidth, halfHeight = width/2, height/2;

    if(!player.demiurge) then return; end
    if(player.blockEffects) then return; end
	if !Clockwork.kernel:IsChoosingCharacter() then return end;

    local activePanel = Clockwork.character:GetActivePanel();

    if IsValid(activePanel) then return; end

    surface.SetDrawColor(0,0,0,player.demiurge.blackAlpha[1]);
    surface.DrawRect(0,0,width,height);

    surface.SetFont("demiurgemenuTextDistrict21");

    local textPos = halfWidth - (surface.GetTextSize(line1)/2);

    for i = 1, #line1 do
        //if(player.demiurge.begottenAlpha <= 0) then continue; end

        local text = string.sub(line1, i, i);

        local matrix = Matrix();
        //matrix:Rotate(Angle(0, TimedCos(0.01, -1, 1, i*0.1), 0));
        matrix:Translate(Vector(TimedCos(0.2, -15, 15, i+2), TimedCos(0.2, -15, 15, i+3)));
        cam.PushModelMatrix(matrix);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos), (height/3.6), Color(255,255,255,Lerp(player.demiurge.begottenAlpha[1]/255, 0, 15)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        cam.PopModelMatrix();

        local matrix = Matrix();
        //matrix:Rotate(Angle(0, TimedCos(0.01, -1, 1, i), 0));
        matrix:Translate(Vector(TimedCos(0.1, -5, 5, i), TimedCos(0.1, -10, 10, i+3)));
        cam.PushModelMatrix(matrix);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos)+10, (height/3.6)+10, Color(0,0,0,player.demiurge.begottenAlpha[1]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos), (height/3.6), Color(255,255,255,player.demiurge.begottenAlpha[1]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        cam.PopModelMatrix();

        textPos = textPos + surface.GetTextSize(text);

    end

    textPos = halfWidth - (surface.GetTextSize(line2)/2);

    for i = 1, #line2 do
        //if(player["intro_apocalypseAlpha"..i] <= 0) then continue; end

        local text = string.sub(line2, i, i);

        local matrix = Matrix();
        //matrix:Rotate(Angle(0, TimedCos(0.1, -1, 1, i*0.1), 0));
        matrix:Translate(Vector(TimedCos(0.2, -15, 15, i+5), TimedCos(0.2, -15, 15, i+7)));
        cam.PushModelMatrix(matrix);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos), (height/2), Color(255,255,255,Lerp(player.demiurge.apocalypseAlpha[i][1]/255, 0, 15)), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        cam.PopModelMatrix();

        local matrix = Matrix();
        //matrix:Rotate(Angle(0, TimedCos(0.1, -1, -1, i*0.1), 0));
        matrix:Translate(Vector(TimedCos(0.1, -5, 5, i+2), TimedCos(0.1, -10, 10, i+3)));
        cam.PushModelMatrix(matrix);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos)+10, (height/2)+10, Color(0,0,0,player.demiurge.apocalypseAlpha[i][1]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
                draw.SimpleText(text, "demiurgemenuTextDistrict21", (textPos), (height/2), Color(255,255,255,player.demiurge.apocalypseAlpha[i][1]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        cam.PopModelMatrix();

        textPos = textPos + surface.GetTextSize(text);

    end

end

function cwIntroduction:StartCommand(player, cmd)
    if (player.demiurge and input.WasKeyPressed(KEY_SPACE) and !player.demiurge.skipped) then
        cwIntroduction:Skip(player);
    end
end