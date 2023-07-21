--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local colBlack = Color(0, 0, 0, 255);
local colRed = Color(170, 0, 0, 255)
local smallTextFont = Clockwork.option:GetFont("menu_text_small");
local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
local bigTextFont = Clockwork.option:GetFont("menu_text_big");
local fonts = {tinyTextFont, smallTextFont};

local PANEL = {};

function PANEL:Init()
	self:Rebuild();
end

function PANEL:Rebuild()
	local scrW, scrH;
	
	if g_VR and g_VR.active then
		scrW = 1920;
		scrH = 1080;
	else
		scrW = ScrW();
		scrH = ScrH();
	end
	
	if IsValid(self.disconnectButton) then
		self.disconnectButton:Remove()
	end;
	
	if IsValid(self.contentButton) then
		self.contentButton:Remove()
	end;
	
	if IsValid(self.proceedButton) then
		self.proceedButton:Remove()
	end;

	self:SetPos(0, 0);
	self:SetSize(scrW, scrH);
	self:SetDrawOnTop(false);
	self:SetPaintBackground(false);
	self:SetMouseInputEnabled(true);
	
	local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "DISCONNECT");
		
	self.disconnectButton = vgui.Create("cwLabelButton", self);
	self.disconnectButton:SetFont(smallTextFont);
	self.disconnectButton:SetText("DISCONNECT");
	self.disconnectButton.originalText = "DISCONNECT";
	self.disconnectButton:SizeToContents();
	
	if self.missingWorkshop then
		self.disconnectButton:SetPos(scrW * 0.25 - (newsizew / 2), scrH * 0.925);
	else
		self.disconnectButton:SetPos(scrW * 0.333 - (newsizew / 2), scrH * 0.925);
	end
	
	self.disconnectButton:SetCallback(function(panel)
		RunConsoleCommand("disconnect")
	end);
	self.disconnectButton:SetMouseInputEnabled(true);
	
	function self.disconnectButton:Paint(w, h)
		if (self:GetHovered()) then
			local texts = {"DISCONNECT", "dIsCoNnEcT", "DiScOnNeCt"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
	
	if self.missingWorkshop then
		newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "VIEW CONTENT");

		self.contentButton = vgui.Create("cwLabelButton", self);
		self.contentButton:SetFont(smallTextFont);
		self.contentButton:SetText("VIEW CONTENT");
		self.contentButton.originalText = "VIEW CONTENT";
		self.contentButton:SizeToContents();
		self.contentButton:SetPos(scrW / 2 - (newsizew / 2), scrH * 0.925);
		self.contentButton:SetCallback(function(panel)
			steamworks.ViewFile("2443075973")
		end);
		self.contentButton:SetMouseInputEnabled(true);
		
		function self.contentButton:Paint(w, h)
			if (self:GetHovered()) then
				local texts = {"VIEW CONTENT", "vIeW cOnTeNt", "ViEw CoNtEnT"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
	end
	
	newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "PROCEED ANYWAY");
		
	self.proceedButton = vgui.Create("cwLabelButton", self);
	self.proceedButton:SetFont(smallTextFont);
	self.proceedButton:SetText("PROCEED ANYWAY");
	self.proceedButton.originalText = "PROCEED ANYWAY";
	self.proceedButton:SizeToContents();
	
	if self.missingWorkshop then
		self.proceedButton:SetPos(scrW * 0.75 - (newsizew / 2), scrH * 0.925);
	else
		self.proceedButton:SetPos(scrW * 0.667 - (newsizew / 2), scrH * 0.925);
	end
	
	self.proceedButton:SetCallback(function(panel)
		netstream.Start("ContentBypass");
		
		Schema.contentVerified = "verified";
		
		self:Remove();
	end);
	self.proceedButton:SetMouseInputEnabled(true);
	
	function self.proceedButton:Paint(w, h)
		if (self:GetHovered()) then
			local texts = {"PROCEED ANYWAY", "pRoCeEd AnYwAy", "PrOcEeD aNyWaY"};
			
			for i = 1, math.random(2, 4) do
				surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
			end;
		end;
	end;
	
	self.missingMounts = "";
	
	for k, v in pairs(Schema.requiredMounts) do
		if !IsMounted(k) then
			if self.missingMounts == "" then
				self.missingMounts = v;
			else
				self.missingMounts = self.missingMounts..", "..v;
			end
		end
	end
	
	self:MakePopup(false);
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, colBlack);
	
	local newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(bigTextFont, "You are missing part of or all of the Begotten III VR content!");
	
	draw.SimpleText("You are missing part of or all of the Begotten III VR content!", bigTextFont, (w * 0.5) - (newsizew / 2), h * 0.4, colRed);
	
	if self.missingMounts ~= "" then
		if self.missingWorkshop then
			newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "You are also missing the following game mounts: "..self.missingMounts..".");
			draw.SimpleText("You are also missing the following game mounts: "..self.missingMounts..".", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.51, colRed);
		
			newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "The center button will take you to the content's Steam Workshop page.");
			draw.SimpleText("The center button will take you to the content's Steam Workshop page.", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.61, colRed);
			
			newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Alternatively, you can disconnect or proceed onwards at your own risk.");
			draw.SimpleText("Alternatively, you can disconnect or proceed onwards at your own risk.", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.71, colRed);
		else
			newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "You are missing the following game mounts: "..self.missingMounts..".");
			draw.SimpleText("You are missing the following game mounts: "..self.missingMounts..".", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.55, colRed);
			
			newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "You can disconnect or proceed onwards at your own risk.");
			draw.SimpleText("You can disconnect or proceed onwards at your own risk.", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.65, colRed);
		end
	elseif self.missingWorkshop then
		newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "The center button will take you to the content's Steam Workshop page.");
		draw.SimpleText("The center button will take you to the content's Steam Workshop page.", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.55, colRed);
		
		newsizew, newsizeH = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Alternatively, you can disconnect or proceed onwards at your own risk.");
		draw.SimpleText("Alternatively, you can disconnect or proceed onwards at your own risk.", smallTextFont, (w * 0.5) - (newsizew / 2), h * 0.65, colRed);
	else
		-- dunno how this would happen lol
		netstream.Start("ContentBypass", true);
		
		Schema.contentVerified = "verified";
		
		self:Remove();
	end
end

function PANEL:Think()
	local scrW, scrH;
	
	if g_VR and g_VR.active then
		scrW = 1920;
		scrH = 1080;
	else
		scrW = ScrW();
		scrH = ScrH();
	end

	if g_VR and g_VR.active then
		if !self.poppedUp then
			local basePos, baseAng;
			local ang = Angle(0,g_VR.tracking.hmd.ang.yaw-90,60);
			basePos, baseAng = WorldToLocal( g_VR.tracking.hmd.pos + Vector(0,0,-10) + Angle(0,g_VR.tracking.hmd.ang.yaw,0):Forward()*30 + ang:Forward()*1920*-0.02 + ang:Right()*1080*-0.02, ang, g_VR.origin, g_VR.originAngle)
				
			--right = down, up = normal, forward = right
			local ang = baseAng
			local pos = basePos + ang:Up()*0.1
			
			self:Rebuild();
			self:MakePopup();
			self.poppedUp = true;
		
			return;
		end
	end
	
	if self:GetWide() ~= scrW then
		self:Rebuild();
	end
end

vgui.Register("cwContentNotification", PANEL, "DPanel")