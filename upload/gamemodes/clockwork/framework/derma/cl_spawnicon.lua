--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local CurTime = CurTime;
local surface = surface;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.PaintOver = function()
	
	end

	self.Icon.PaintOver = function(icon)
		local curTime = CurTime();
		
		if (self.Cooldown and self.Cooldown.expireTime > curTime) then
			local timeLeft = self.Cooldown.expireTime - curTime;
			local progress = 100 - ((100 / self.Cooldown.duration) * timeLeft);
	
			Clockwork.cooldown:DrawBox(
				self.x,
				self.y,
				self:GetWide(),
				self:GetTall(),
				progress, Color(255, 255, 255, 255 - ((255 / 100) * progress)),
				self.Cooldown.textureID
			);
		end;
		
		if (!self.MatOverride) then
			self.MatOverride = Clockwork.kernel:GetMaterial("gui/npc.png")--Clockwork.SpawnIconMaterial;
		end;
		
		if (self.BorderColor) then
			local alpha = 200--math.min(self.BorderColor.a, self:GetAlpha());
			self.MatOverride:SetVector("$color", Vector(self.BorderColor.r / 255, self.BorderColor.g / 255, self.BorderColor.b / 255));
			self.MatOverride:SetFloat("$alpha", alpha / 255);
				surface.SetDrawColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, alpha);
				surface.SetMaterial(self.MatOverride);
				--self:DrawTexturedRect();
				surface.DrawTexturedRect(self.x + 8, self.y + 4, self:GetWide() - 16, self:GetTall() - 8)
			self.MatOverride:SetFloat("$alpha", 1);
			self.MatOverride:SetVector("$color", Vector(1, 1, 1));
		end;
	end;
	
	timer.Simple(0, function()
		if IsValid(self) then
			self:SetTooltip(false)
		end
	end);
end;

-- A function to set the border color.
function PANEL:SetColor(color)
	self.BorderColor = color;
end;

-- A function to set the cooldown.
function PANEL:SetCooldown(expireTime, textureID)
	self.Cooldown = {
		expireTime = expireTime,
		textureID = textureID or surface.GetTextureID("vgui/white"),
		duration = expireTime - CurTime()
	};
end;

-- A function to override the paint over material.
function PANEL:OverrideMaterial(material)
	if (type(material) == "string") then
		material = Material(material);
	end;
	
	self.MatOverride = material;
end;

vgui.Register("cwSpawnIcon", PANEL, "SpawnIcon");