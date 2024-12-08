--[[
	Begotten III: Jesus Wept
--]]

ColorMaterial = Material("pp/colour")
-- A function to get a text's width.
local function GetFontWidth(font, text)
	if (!font or !text) then
		return;
	end;
	surface.SetFont(tostring(font));
		local textWidth, textHeight = surface.GetTextSize(tostring(text));
	return textWidth;
end;

-- A function to get a text's height.
local function GetFontHeight(font, text)
	if (!font or !text) then
		return;
	end;
	surface.SetFont(tostring(font));
		local textWidth, textHeight = surface.GetTextSize(tostring(text));
	return textHeight;
end;

local ara = {0.178, 0.238, 0.316, 0.412, 0.471, 0.548, 0.630, 0.693, 0.813, 0.944, 1.051, 1.147, 1.314, 1.497, 1.583, 1.651, 1.730, 1.791, 1.865, 1.952, 2.012, 2.142, 2.204, 2.287, 2.374, 2.456, 2.588, 2.693, 2.820, 3.456, 3.550, 3.622, 3.716, 3.778, 3.870, 3.943, 4.057}
surface.CreateFont("nx_IntroTextSmalls", {font = "Day Roman", size = ScaleToWideScreen(75), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallaaaa", {font = "Day Roman", size = ScaleToWideScreen(150), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallaaaaa", {font = "Day Roman", size = ScaleToWideScreen(50), weight = 700, antialiase = true, shadow = false})
surface.CreateFont("nov_IntroTextSmallfaaaaa", {font = "Day Roman", size = ScaleToWideScreen(50), weight = 700, antialiase = true, shadow = false})
surface.CreateFont("nov_IntroTextSmallaaafaa", {font = "Day Roman", size = ScaleToWideScreen(37), weight = 700, antialiase = true, shadow = true})
surface.CreateFont("nov_IntroTextSmallDETrooper", {font = "Day Roman", size = ScaleToWideScreen(24), weight = 700, antialiase = true, shadow = true})
local tab = {["$pp_colour_addr"] = 0.1, ["$pp_colour_brightness"] = -.1, ["$pp_colour_contrast"] = 0.5, ["$pp_colour_colour"] = 0.5, ["$pp_colour_mulr"] = 1, ["$pp_colour_mulg"] = -1, ["$pp_colour_mulb"] = -1 }
local tabs = { ["$pp_colour_brightness"] = -.3, ["$pp_colour_contrast"] = 0.5, ["$pp_colour_colour"] = 0.1, ["$pp_colour_mulr"] = 1, ["$pp_colour_mulg"] = -1, ["$pp_colour_mulb"] = -1 }
local tasbs = { ["$pp_colour_brightness"] = -.3,["$pp_colour_contrast"] = 1,["$pp_colour_colour"] = 0,}
local tasbds = {["$pp_colour_brightness"] = -.2,["$pp_colour_contrast"] = 2,["$pp_colour_colour"] = 0,}
local tasbds1r = {["$pp_colour_brightness"] = -.07,["$pp_colour_contrast"] = 2,["$pp_colour_colour"] = 0}
local tasbdsd = {["$pp_colour_brightness"] = -.1,["$pp_colour_contrast"] = 0.7,["$pp_colour_colour"] = 0,["$pp_colour_mulr"] = 3, }
local tabcrosstobear = {["$pp_colour_addr"] = 0, ["$pp_colour_brightness"] = 0.1, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.25, ["$pp_colour_mulr"] = 0.25, ["$pp_colour_mulg"] = 0.1, ["$pp_colour_mulb"] = 0.1}
local blockEffects = false;
netstream.Hook("MenuIntro", function(skip_enabled)
	if (Clockwork.ConVars.INTROENABLED:GetInt() ~= 1) and skip_enabled then
		if not Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
		
		if Clockwork.Client.MusicSound then
			Clockwork.Client.MusicSound:Stop();
		end
		
		if (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
			Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/event/cross_to_bear.mp3")
			Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.5, 100)
		end
		
		Clockwork.Client.Pending = nil
		Clockwork.Client.MusicFading = false
		Clockwork.Client.Intros = CurTime()
		cwIntroduction.DefaultIntro = true
	
		return;
	end

	timer.Simple(0.15, function()
		Clockwork.Client.Pending = nil
NODAs = nil NODA = nil Stuat = nil CANSINTRO = nil Clockwork.Client.Intros = nil stat = nil rawa = nil times = nil timeas = nil
Darwa = nil CRAWET = nil DARS3 = nil DARS2 = nil CRAWETs = nil CRAWETss = nil DARS = nil CRAWEaT = nil DARsS = nil
Clockwork.Client.Intros = CurTime() + 23.339
cwIntroduction.DefaultIntro = true
if not Clockwork.quiz:GetCompleted() then
	Clockwork.quiz.completed = true;
end
if Clockwork.Client.MusicSound then
	Clockwork.Client.MusicSound:Stop();
end

if !cwMusic or (cwMusic and (Clockwork.ConVars.MENUMUSIC and Clockwork.ConVars.MENUMUSIC:GetInt() == 1)) then
	Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/event/cross_to_bear.mp3")
	Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.5, 100)
end
Clockwork.Client.MusicFading = false
end)
end)
local redpent = Material("begotten/pentagram_red.png")

-- Called to get whether the local player's character screen is visible.
function cwIntroduction:GetPlayerCharacterScreenVisible(panel)
	if (Clockwork.Client.Pending or (Clockwork.Client.Intros and Clockwork.Client.Intros > CurTime()) or Clockwork.Client.MenuAp and Clockwork.Client.MenuAp > CurTime()) then
		return false
	end
end

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
				if math.random(1, 2) == 1 then
					Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/title/jesus_wept.mp3")
					Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.3, 100)
				else
					Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/event/cross_to_bear.mp3")
					Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.5, 100)
				end

				Clockwork.Client.MusicFading = false
			end
		end
	end
end

local BegottenWidth = GetFontWidth("nov_IntroTextSmallaaaa", "BEGOTTEN")
local BegottenHeight = GetFontHeight("nov_IntroTextSmallaaaa", "BEGOTTEN")
local JesusWeptHeight = GetFontHeight("nx_IntroTextSmalls", "JESUS WEPT")
local JesusWeptWidth = GetFontWidth("nx_IntroTextSmalls", "JESUS WEPT")
local JeWidth = GetFontWidth("nx_IntroTextSmalls", "JE")
local JesusWidth = GetFontWidth("nx_IntroTextSmalls", "JESUS ")
local ThreeWidth = GetFontWidth("nov_IntroTextSmallaaaa", "I I I")
local JesusWeWidth = GetFontWidth("nx_IntroTextSmalls", "JESUS WE")
local flashes = {"KILL","FLESH","DIE","BITCH","WHORE","COLD POP","YUM CHUG","HUNTER","CHANTIAM","POP","FUCK","KILL","KILL","GLAZE","GORE","WAR","VILLAGE","BURN","ROTTING","FLIES","RANCID","POPE","HIERARCHY","DARK","LIGHT","CAGE","TORTURE","DISMEMBER","CUT","MAIM","LORD","CHURCH","TOWER","ITZUTAK","BEGOTTEN","DEATH","HELL","INFERNO","LICK","TWISTED","TWISTED FUCK","CORPSE","FLAME","FORGOTTEN",}
local fonts = {"nov_IntroTextSmallaaaa", "nx_IntroTextSmalls", "nov_IntroTextSmallaaaaa"}
local colRed = Color(170, 170, 170, 255)
local colBlack = Color(0, 0, 0, 255)
local colred1 = Color(127, 127, 127, 255)
local tastat = {-0.05, 0.05, 0.07, -0.07, -0.1, -0.15}
local colred2 = Color(160, 0, 0, 255)
local colred3 = Color(150, 0, 0, 255)
local colred4 = Color(140, 0, 0, 255)
local colreddark = colred4
local colred5 = Color(170, 0, 0, 255)
local colgrey = Color(255, 255, 255)
local halfweptheight = (JesusWeptHeight * 0.5)
local halfweptwidth = (JesusWeptWidth * 0.5)
local begotaha = (BegottenHeight * 0.5)
local begotwi = (BegottenWidth * 0.5)
local threewid = (ThreeWidth * 0.5)
local scrW = ScrW()
local scrH = ScrH()
local half = (scrW * 0.5)
local fotr = (scrH * 0.45)
local haflfHE = (scrH * 0.56)
local oth = (scrH * 0.51)

local intsa = {0.25,0.48,2.2,2.35,2.52,2.95,8.219,8.372,8.524}
netstream.Hook("JesusWeptIntro", function(skip_enabled)
	if (Clockwork.ConVars.INTROENABLED:GetInt() ~= 1) and skip_enabled then
		if not Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
		
		if Clockwork.Client.MusicSound then
			Clockwork.Client.MusicSound:Stop();
		end
		
		if (!Clockwork.ConVars.MENUMUSIC or Clockwork.ConVars.MENUMUSIC:GetInt() == 1) then
			Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/title/jesus_wept.mp3")
			Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.3, 100)
		end
		
		Clockwork.Client.Pending = nil;
		Clockwork.Client.MusicFading = false
		cwIntroduction.JesusWeptIntro = CurTime()
		Clockwork.Client.JseR = true
		Clockwork.Client.IIIShown = true
		Clockwork.Client.BegottenShown = true
		Clockwork.Client.JEsusWeptShown = true
		Clockwork.Client.LogoAppear = true
		Clockwork.Client.MenuAp = CurTime();
	
		return;
	end

	Clockwork.Client.Pending = true
	
	timer.Simple(0.15, function()
		Clockwork.Client.Pending = nil
		Clockwork.Client.ShortSharp = nil
		Clockwork.Client.ShortTime = nil
		Clockwork.Client.LongSharp = nil
		Clockwork.Client.LongTime = nil
		Clockwork.Client.JseR = nil
		Clockwork.Client.IIIShown = nil
		Clockwork.Client.BegottenShown = nil
		Clockwork.Client.JEsusWeptShown = nil
		Clockwork.Client.LogoAppear = nil
		Clockwork.Client.Crazy = nil
		Clockwork.Client.MenuAp = nil
		Clockwork.Client.HoldTime = nil
		Clockwork.Client.LongSharpS = nil
		Clockwork.Client.APD = nil
		Clockwork.Client.AdPD = nil
		Clockwork.Client.dAPD = nil
		if not Clockwork.quiz:GetCompleted() then
			Clockwork.quiz.completed = true;
		end
		if Clockwork.Client.MusicSound then
			Clockwork.Client.MusicSound:Stop();
		end
		
		if !cwMusic or (cwMusic and (Clockwork.ConVars.MENUMUSIC and Clockwork.ConVars.MENUMUSIC:GetInt() == 1)) then
			Clockwork.Client.MusicSound = CreateSound(LocalPlayer(), "begotten3soundtrack/title/jesus_wept.mp3")
			Clockwork.Client.MusicSound:PlayEx(((Clockwork.ConVars.MENUMUSICVOLUME:GetInt() or 100) / 100) * 0.3, 100);
		end
		
		Clockwork.Client.MusicFading = false
		cwIntroduction.JesusWeptIntro = CurTime() + 19.3
		Clockwork.Client.ShortSharp = 10
		Clockwork.Client.LongSharp = 50
		for k, v in pairs (intsa) do
			timer.Simple(v, function()
				local as = 0.1
				if (v > 8) then
					as = 0.1
				end
				Clockwork.Client.ShortTime = CurTime() + as
				Clockwork.Client.HoldTime = nil
			end)
		end
		timer.Simple(3.537, function()
			Clockwork.Client.Crazy = true
		end)
		timer.Simple(4.909, function()
			Clockwork.Client.Crazy = nil
			Clockwork.Client.LongTime = CurTime() + 3
			Clockwork.Client.HoldTime = true
			Clockwork.Client.BegottenShown = true
		end)
		timer.Simple(9.688, function()
			Clockwork.Client.LogoAppear = true
			Clockwork.Client.IIIShown = true
		end)
		timer.Simple(14.498, function()
			Clockwork.Client.LongSharpS = nil
			Clockwork.Client.JEsusWeptShown = true
			Clockwork.Client.JseR = true
		end)
		Clockwork.Client.MenuAp = CurTime() + 19.292
	end)
end)

function cwIntroduction:HUDPaint()
	if (!self.JesusWeptIntro or !Clockwork.Client.Intros) then
		return
	end
	
	if (!Clockwork.kernel:IsChoosingCharacter()) then
		return
	end

	draw.RoundedBox(0, 0, 0, ScrW(), ScrH() * 0.125, Color(0, 0, 0))
	draw.RoundedBox(0, 0, ScrH() - ScrH() * 0.125, ScrW(), ScrH() * 0.125, Color(0, 0, 0))
end

function cwIntroduction:RenderScreenspaceEffects()
	if (!Clockwork.kernel:IsChoosingCharacter()) then
		return;
	end
	
	if (Clockwork.quiz:GetEnabled() and (!Clockwork.quiz:GetCompleted() or Clockwork.quiz.IntroTransition)) then
		return;
	end
		
	local activePanel = Clockwork.character:GetActivePanel();
	
	if IsValid(activePanel) and (activePanel.uniqueID) and activePanel.uniqueID ~= "cwCharacterList" and activePanel.uniqueID ~= "cwNecropolis" then
		if blockEffects == false then
			if not timer.Exists("IntroTransitionTimer") then
				timer.Create("IntroTransitionTimer", 1, 1, function()
					blockEffects = true;
				end);
			end
		end;
	elseif blockEffects == true then
		if not timer.Exists("IntroTransitionTimer") then
			timer.Create("IntroTransitionTimer", 1, 1, function()
				blockEffects = false;
			end);
		end
	end;
		
	if blockEffects == true then
		return;
	end

	local ft = FrameTime()
	local curTime = CurTime()
	local scrW = ScrW()
	local scrH = ScrH()

	if (self.DefaultIntro) then
		local ft = FrameTime()
		local curTime = CurTime()
		local scrW = ScrW()
		local scrH = ScrH()

		if (Clockwork.Client.Intros and Clockwork.Client.Intros > curTime) then
			if (NODA and NODA > curTime) then
				draw.RoundedBox(0, 0, 0, scrW, scrH, Color(0, 0, 0))
			else
				if (NODA and NODA + 0.1 > curTime) then
					if (math.random(1, 2) == 2) then
						DrawSharpen(table.Random({-100, 100}), table.Random({50, 200}))
						DrawColorModify(tab)
					else
						DrawSharpen(-30, 6)
						DrawMaterialOverlay("effects/tvscreen_noise002a", 1)
						DrawColorModify(tabs)
					end
				else
					if (!CANSINTRO) then
						DrawColorModify(tasbs)
					end
				end
			end

			if (!Stuat) then
				Stuat = true
				
				for k, v in pairs (ara) do
					if (k == #ara) then
						timer.Simple(v, function()
							NODA = nil
							CANSINTRO = true
							CRTAS = CurTime() + 19.6
						end)
					elseif (k == #ara - 1) then
						timer.Simple(v, function()
							NODA = CurTime() + 1
						end)
					else
						timer.Simple(v, function()
							NODA = CurTime() + 0.075
						end)
					end
				end
			end
			
			if (CANSINTRO) then
				--[[ColorMaterial:SetTexture("$fbtexture", render.GetScreenEffectTexture() )
				ColorMaterial:SetFloat("$pp_colour_addr", 0)
				ColorMaterial:SetFloat("$pp_colour_addg", -255)
				ColorMaterial:SetFloat("$pp_colour_addb", -255)
				ColorMaterial:SetFloat("$pp_colour_mulr", 0)
				ColorMaterial:SetFloat("$pp_colour_mulg", 0)
				ColorMaterial:SetFloat("$pp_colour_mulb", 0)
				ColorMaterial:SetFloat("$pp_colour_brightness", 0.1 )
				ColorMaterial:SetFloat("$pp_colour_contrast", 1 )
				ColorMaterial:SetFloat("$pp_colour_colour", 1 )
				render.SetMaterial(ColorMaterial)
				render.DrawScreenQuad()]]--
				
				--DrawColorModify(tabcrosstobear);
			
				if (!DARsS) then
					DARsS = 255
				end

				draw.RoundedBox(0, 0, 0, scrW, scrH, Color(150, 0, 0, DARsS))
				
				if (DARsS !=0) then
					DARsS = math.Approach(DARsS, 0, ft * 32)
				end
					
				if (!stat) then
					stat = 30
				end

				if (math.random(1, 2) == 2) then
					DrawSharpen(-stat + math.random(-6, 6), stat + math.random(-6, 6))
					--DrawColorModify(tab)
				else
					DrawSharpen(stat+ math.random(-6, 6), -stat + math.random(-6, 6))
				end
				
				if (!CRAWET) then
					CRAWET = CurTime() + 6.6
				end
				
				if (!CRAWETs) then
					CRAWETs = CurTime() + 9.85
				end
				
				if (!CRAWETss) then
					CRAWETss = CurTime() + 13
				end
				
				local DIDROT = false
				local rot = 0
				
				if (math.random(1, 2) == 1) then
					rot = math.random(-2, 2)
				end

				if (CRAWET and CRAWET < curTime) then
					if (!DARS) then
						DARS = 255
					end

					draw.RoundedBox(0, 0, 0, scrW, scrH, Color(255, 255, 255, DARS))
					
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", half - begotwi + 4, fotr + 4 - begotaha + 2, rot, colBlack)
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", half - begotwi, fotr - begotaha, rot, colRed)

					if (DARS != 0) then
						DARS = math.Approach(DARS, 0, ft * 256)
					end
				end
				
				if (CRAWETs and CRAWETs < curTime) then
					if (!DARS2) then
						DARS2 = 255
					end
					
					draw.RoundedBox(0, 0, 0, scrW, scrH, Color(255, 255, 255, DARS2))

					surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid + 4, oth + 4 - begotaha, rot, colBlack)
					surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid, oth - begotaha, rot, colgrey)
				
					if (DARS2 !=0) then
						DARS2 = math.Approach(DARS2, 0, ft * 256)
					end
				end
				
				if (CRAWETss and CRAWETss < curTime) then
					if (!DARS3) then
						DARS3 = 255
					end
					draw.RoundedBox(0, 0, 0, scrW, scrH, Color(255, 255, 255, DARS3))

					local rot = 0
					
					if (math.random(1, 2) == 1) then
						rot = math.random(-15, 15)
					end
					
					rot = 0
					
					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					
					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth, haflfHE - halfweptheight, rot, colred5)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth, haflfHE - halfweptheight, rot, colred5)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth, haflfHE - halfweptheight, rot,colred5)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth, haflfHE - halfweptheight, rot,colred5)
					
					if (DARS3 !=0) then
						DARS3 = math.Approach(DARS3, 0, ft * 256)
					end
					
					if (!Clockwork.Client.DrawsMenu) then
						Clockwork.Client.DrawsMenu = true
					end
				end
				
				local cha,aad = 200, 150

				if (CRTAS and CRTAS > curTime) then
					stat = math.Approach(stat, 0.1, ft * cha)
				else
					if (CRTAS and CRTAS + 6.5 < curTime) then
						stat = math.Approach(stat, 0.1, ft *  aad)
					else
						stat = math.Approach(stat, 0.1, ft *  aad)
					end
				end

				if (stat == 0.1) then
					stat = nil
					return
				end
			end
		elseif (Clockwork.Client.Intros and Clockwork.Client.Intros < curTime) then
			Clockwork.Client.Introsd = true
			
			if (Clockwork.kernel:IsChoosingCharacter()) then
				local stat = math.random(-10, 10)
				local toas = math.random(1, 300)
				if (!statast) then statast = 0 end
				if (toas == 4) then local panfa = math.Rand(0.05, 0.5) statast = curTime + panfa end
				if (!carw) then carw = 0 end
				
				if (math.random(1, 100) == 5) then
					local caow = math.Rand(0.1, 0.2)
					carw = curTime + caow
				end
				
				if (carw > curTime) then
					DrawColorModify(tasbdsd)
				else
					DrawColorModify(tasbds)
				end
				
				local pfa = math.random(-6, 6)
				local paf = math.random(-6, 6)
				DrawSharpen(stat + pfa, stat + paf)

				if (!Clockwork.character:GetActivePanel()) then
					if (statast > curTime) then
						stat = math.abs(stat)
						DrawMaterialOverlay("models/props_c17/fisheyelens", table.Random(tastat))
					end

					if (math.random(1, math.random(20, 30)) == 1) then
						for i = 1, math.random(1, 5) do
							local aptwat = table.Random(fonts)
							local aysery = table.Random(flashes)
							local poatw = math.random(0, scrW)
							local poath = math.random(0, scrH)
							local coastat = Color(math.random(1, 255), 0, 0)
							
							surface.DrawRotatedText(aysery, aptwat, poatw, poath, math.random(-5, 5), coastat)
						end
					end
					
					local DIDROT = false
					local rot = 0
					
					if (!ROTFOR) then
						ROTFOR = 0
					end
					
					if (math.random(1, 2) == 1) then
						local roatsa = math.random(-3, 3)
						rot = roatsa
					else
						if (math.random(1, 150) == 1) then
							local rotdegs = {-90, 90}
							rot = table.Random(rotdegs)
							DIDROT = true
							DrawSharpen(-150, 150)
							ROTFOR = curTime + math.Rand(0.1, 0.4)
						end
					end
					
					local ratva = 0
					local sexrat = half - begotwi;
					local fara = half - begotwi
					local fava = fotr + 4 - begotaha + 2
					local vag = fotr - begotaha
					
					if (ROTFOR > curTime) then
						--[[local matsu = math.random(87, 92)
						local matwy = math.random(87, 92)
						local pants = {matwy, matsu}--]]
						rot = math.random(87, 92)
						ratva = rot
						fara = ScrW() * 0.535
						fava = ScrH() * 0.1
						vag = ScrH() * 0.1
					end

					if (!Clasod) then
						Clasod = 0
					end
					
					if (!Clocak) then
						Clocak = true
						Clasod = 255
					end
					
					if (Clasod != 0) then
						draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, Clasod))
						Clasod = math.Approach(Clasod, 0, FrameTime() * 256)
					end
					
					surface.SetMaterial(redpent)
					surface.SetDrawColor(Color(255, 255, 255))
					local hox = ScrH() * 0.5
					surface.DrawTexturedRect(ScrW() * 0.5 - (hox / 2), ScrH() * 0.5 - (hox / 2), hox, hox)
						
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", fara, fava, rot, colBlack)
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", fara, vag, rot, colRed)
					
					if (ratva == 0 or math.random(1, 5) == 5) then
						rot = rot * math.random(0.5, 1.5)
						surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid + 4, oth + 4 - begotaha, rot, colBlack)
						surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid, oth - begotaha, rot, colgrey)
					end
					
					local rot = 0
					
					if (math.random(1, 2) == 1) then
						rot = math.random(-15, 15)
					end

					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					
					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth, haflfHE - halfweptheight, rot, colgrey)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth, haflfHE - halfweptheight, rot, colgrey)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth, haflfHE - halfweptheight, rot, colgrey)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth, haflfHE - halfweptheight, rot, colgrey)
					DrawSharpen(math.random(-5, 5), math.random(5, -5))
				end
			else
				statsa = nil
			end
		end
	end
	
	if (Clockwork.character:IsPanelPolling()) then
		DrawColorModify(tasbds1r)
	end
	
	if (self.JesusWeptIntro) then
		DrawColorModify(tasbds1r)

		if (Clockwork.Client.MenuAp and Clockwork.Client.MenuAp < curTime) then
			if (Clockwork.kernel:IsChoosingCharacter()) then
				local stat = math.random(-10, 10)
				local toas = math.random(1, 300)
				if (!statast) then statast = 0 end
				if (toas == 4) then local panfa = math.Rand(0.05, 0.5) statast = curTime + panfa end
				if (!carw) then carw = 0 end
				
				if (math.random(1, 100) == 5) then
					local caow = math.Rand(0.1, 0.2)
					carw = curTime + caow
				end
				
				if (carw > curTime) then
					DrawColorModify(tab)-- RED
				else
					DrawColorModify(tasbds)
				end
				
				local pfa = math.random(-6, 6)
				local paf = math.random(-6, 6)
				DrawSharpen(stat + pfa, stat + paf)

				if (!Clockwork.character:GetActivePanel()) then--
					if (statast > curTime) then
						stat = math.abs(stat)
						DrawMaterialOverlay("models/props_c17/fisheyelens", table.Random(tastat))
					end

					if (math.random(1, math.random(20, 30)) == 1) then
						for i = 1, math.random(1, 5) do
							local aptwat = table.Random(fonts)
							local aysery = table.Random(flashes)
							local poatw = math.random(0, scrW)
							local poath = math.random(0, scrH)
							local coastat = Color(math.random(1, 255), 0, 0)
							
							surface.DrawRotatedText(aysery, aptwat, poatw, poath, math.random(-5, 5), coastat)
						end
					end
					
					local DIDROT = false
					local rot = 0
					
					if (!ROTFOR) then
						ROTFOR = 0
					end
					
					if (math.random(1, 2) == 1) then
						local roatsa = math.random(-3, 3)
						rot = roatsa
					else
						if (math.random(1, 150) == 1) then
							local rotdegs = {-90, 90}
							rot = table.Random(rotdegs)
							DIDROT = true
							DrawSharpen(-150, 150)
							ROTFOR = curTime + math.Rand(0.1, 0.4)
						end
					end
					
					local ratva = 0
					local fara = half - begotwi
					local fava = fotr + 4 - begotaha + 2
					local vag = fotr - begotaha
					
					if (ROTFOR > curTime) then
						--[[local matsu = math.random(87, 92)
						local matwy = math.random(87, 92)
						local pants = {matwy, matsu}--]]
						rot = math.random(87, 92)
						ratva = rot
						fara = ScrW() * 0.535
						fava = ScrH() * 0.1
						vag = ScrH() * 0.1
					end
					
					if (!Clasod) then
						Clasod = 0
					end
					
					if (!Clocak) then
						Clocak = true
						Clasod = 255
					end
					
					if (Clasod != 0) then
						draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, Clasod))
						Clasod = math.Approach(Clasod, 0, FrameTime() * 256)
					end
					
					surface.SetMaterial(redpent)
					surface.SetDrawColor(Color(255, 255, 255))
					local hox = ScrH() * 0.5
					surface.DrawTexturedRect(ScrW() * 0.5 - (hox / 2), ScrH() * 0.5 - (hox / 2), hox, hox)
					
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", fara + 4, fava, rot, colBlack)
					surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", fara, vag, rot, colRed)

					if (ratva == 0 or math.random(1, 5) == 5) then
						rot = rot * math.random(0.5, 1.5)
						surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid + 4, oth + 4 - begotaha, rot, colBlack)
						surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid, oth - begotaha, rot, colgrey)
					end
					
					local rot = 0
					
					if (math.random(1, 2) == 1) then
						rot = math.random(-15, 15)
					end

					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
					local jes = Color(15, 15, 15)
					surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth, haflfHE - halfweptheight, rot, jes)
					surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth, haflfHE - halfweptheight, rot, jes)
					surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth, haflfHE - halfweptheight, rot, jes)
					surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth, haflfHE - halfweptheight, rot, jes)
					DrawSharpen(math.random(-5, 5), math.random(5, -5))
				end
			else
				statsa = nil
			end
		else
			if (Clockwork.Client.BegottenShown) then
				if (!Clockwork.Client.APD) then
					Clockwork.Client.APD = 255
				end
				
				Clockwork.Client.APD = math.Approach(Clockwork.Client.APD, 0, FrameTime() * 512)
				
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, Clockwork.Client.APD))
				local rot = 0
				surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", half - begotwi + 4, fotr + 4 - begotaha + 2, rot, colBlack)
				surface.DrawRotatedText("BEGOTTEN", "nov_IntroTextSmallaaaa", half - begotwi, fotr - begotaha, rot, colred1)
			end
			
			if (Clockwork.Client.IIIShown) then
				if (!Clockwork.Client.dAPD) then
					Clockwork.Client.dAPD = 255
				end
				
				Clockwork.Client.dAPD = math.Approach(Clockwork.Client.dAPD, 0, FrameTime() * 512)
				
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, Clockwork.Client.dAPD))
				local rot = 0
				surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid + 4, oth + 4 - begotaha, rot, colBlack)
				surface.DrawRotatedText("I I I", "nov_IntroTextSmallaaaa", half - threewid, oth - begotaha, rot, colgrey)
			end
			
			if (Clockwork.Client.JEsusWeptShown) then
				if (!Clockwork.Client.AdPD) then
					Clockwork.Client.AdPD = 255
				end
				
				Clockwork.Client.AdPD = math.Approach(Clockwork.Client.AdPD, 0, FrameTime() * 512)
				
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, Clockwork.Client.AdPD))
				local rot = math.random(-5, 5)
				surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
				surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
				surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
				surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth + 4, haflfHE - halfweptheight + 4, rot, colBlack)
				surface.DrawRotatedText("JE", "nx_IntroTextSmalls", half - halfweptwidth, haflfHE - halfweptheight, rot, colgrey)
				surface.DrawRotatedText("SUS", "nx_IntroTextSmalls", half - halfweptwidth + JeWidth, haflfHE - halfweptheight, rot, colgrey)
				surface.DrawRotatedText("WE", "nx_IntroTextSmalls", half - halfweptwidth + JesusWidth, haflfHE - halfweptheight, rot, colgrey)
				surface.DrawRotatedText("PT", "nx_IntroTextSmalls", half - halfweptwidth + JesusWeWidth, haflfHE - halfweptheight, rot, colgrey)
			end
		end
		
		if (Clockwork.Client.ShortTime and Clockwork.Client.ShortTime > curTime) then
			DrawSharpen(Clockwork.Client.ShortSharp, Clockwork.Client.ShortSharp)
		else
			if (Clockwork.Client.ShortSharp != 10) then
				Clockwork.Client.ShortSharp = 10
			end
		end
		
		if (Clockwork.Client.Crazy) then
			if (!Clockwork.Client.Rev) then
				Clockwork.Client.Rev = 25
			end
			
			if (!Clockwork.Client.Revra) then
				Clockwork.Client.Revra = false
			end
			
			local olca = 0.075
			
			if (!Clockwork.Client.RevTime) then
				Clockwork.Client.RevTime = CurTime() + olca
			elseif (Clockwork.Client.RevTime < curTime) then
				Clockwork.Client.Revra = !Clockwork.Client.Revra
				Clockwork.Client.RevTime = nil
			end
			
			if (Clockwork.Client.Revra) then
				Clockwork.Client.Rev = -25
			else
				Clockwork.Client.Rev = 25
			end
			
			DrawSharpen(1, Clockwork.Client.Rev)
		end
		
		if (Clockwork.Client.HoldTime) then
			Clockwork.Client.LongSharp = math.Approach(Clockwork.Client.LongSharp, 0, FrameTime() * 12)
			DrawSharpen(Clockwork.Client.LongSharp, Clockwork.Client.LongSharp)
		end
		
		if (Clockwork.Client.LogoAppear) then
			if (!Clockwork.Client.LongSharpS) then
				Clockwork.Client.LongSharpS = 100
			end

			Clockwork.Client.LongSharpS = math.Approach(Clockwork.Client.LongSharpS, 0, FrameTime() * 24)
			local jz = Clockwork.Client.LongSharpS
			
			if (Clockwork.Client.JseR) then
				jz = -jz
			end
			
			DrawSharpen(jz + math.random(-5, 5), jz + math.random(-5, 5))
		end
	end;
end