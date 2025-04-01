--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local IsValid = IsValid;
local surface = surface;
local string = string;
local vgui = vgui;
local math = math;

local PANEL = {}

Derma_Hook(PANEL, "Paint", "Paint", "VoiceNotify");
Derma_Hook(PANEL, "PerformLayout", "Layout", "VoiceNotify");
Derma_Hook(PANEL, "ApplySchemeSettings", "Scheme", "VoiceNotify");
	
-- Called when the panel is initialized.
function PANEL:Init()
	self.LabelName = vgui.Create("DLabel", self);
end;

-- A function to set up the panel.
function PANEL:Setup(player)
	if (!Clockwork.player:DoesRecognise(player, RECOGNISE_TOTAL)) then
		local unrecognisedName, usedPhysDesc = Clockwork.player:GetUnrecognisedName(player);
		
		if (usedPhysDesc and string.len(unrecognisedName) > 24) then
			unrecognisedName = string.sub(unrecognisedName, 1, 21).."...";
		end;
		
		self.Recognises = false;
		self.LabelName:SetText("["..unrecognisedName.."]");
		self.Avatar = vgui.Create("DImage", self);
	else
		self.Recognises = true;
		self.LabelName:SetText(Clockwork.player:GetName(player));

		self.Avatar = vgui.Create("AvatarImage", self);
		self.Avatar:SetSize(32, 32);
	end;

	self.LabelName:SetFont("DermaDefault");
	self.LabelName:SetContentAlignment(4);
	self.LabelName:SetColor(color_white);
	self:InvalidateLayout();

	self.TeamColor = _team.GetColor(player:Team());
	self.Color = self.TeamColor;
	self.Player = player;
	self.Initialized = true;
	self.Volume = 0;

	if (self.Recognises) then
		self.Avatar:SetPlayer(player);
	else
		self.Avatar:SetImage("clockwork/unknown.png");
	end;
end;

-- Called every frame.
function PANEL:Think()
	if (self.Initialized and (!IsValid(self.Player) or !self.Player:IsSpeaking())) then
		self:Remove();
	end;
end;

-- Called when the panel should be painted.
function PANEL:Paint(w, h)
	if (IsValid(self.Player)) then
		local r, g, b = self.Color.r, self.Color.g, self.Color.b;
		local volume = math.Approach(self.Volume, self.Player:VoiceVolume(), FrameTime() * 30);

		surface.SetDrawColor(50 + (r * volume), 50 + (g * volume), 50 + (b * volume), 250);
		surface.DrawRect(0, 0, w, h);

		surface.SetDrawColor(150, 150, 150, 100);
		surface.DrawOutlinedRect(0, 0, w, h);
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetSize(200, 40);
	self.Avatar:SetPos(4, 4);
	self.Avatar:SetSize(32, 32);
	self.LabelName:SetPos(42, 16);
	self.LabelName:CenterVertical();
	self.LabelName:SizeToContents();
end;

-- Called when the panel should be layed out.
derma.DefineControl("VoiceNotify", "", PANEL, "DPanel");