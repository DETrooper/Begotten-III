--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local Color = Color;
local vgui = vgui;
local math = math;

local PANEL = {};

-- A function to set whether the panel is disabled.
function PANEL:SetDisabled(disabled)
	self.Disabled = disabled;
end;

-- A function to get whether the panel is disabled.
function PANEL:GetDisabled()
	return self.Disabled;
end;

-- A function to set whether the panel is depressed.
function PANEL:SetDepressed(depressed)
	self.Depressed = depressed;
end;

-- A function to get whether the panel is depressed.
function PANEL:GetDepressed()
	return self.Depressed;
end;

-- A function to set whether the panel is hovered.
function PANEL:SetHovered(hovered)
	self.Hovered = hovered;
end;

-- A function to get whether the panel is hovered.
function PANEL:GetHovered()
	return self.Hovered;
end;

-- Called when the cursor has entered the panel.
function PANEL:OnCursorEntered()
	if (!self:GetDisabled()) then
		self:SetHovered(true);
	end;
	
	DImage.ApplySchemeSettings(self);
end;

-- Called when the cursor has exited the panel.
function PANEL:OnCursorExited()
	self:SetHovered(false);
	DImage.ApplySchemeSettings(self);
end;

-- Called when the mouse is pressed.
function PANEL:OnMousePressed(code)
	self:MouseCapture(true);
	self:SetDepressed(true);
end;

-- Called when the mouse is released.
function PANEL:OnMouseReleased(code)
	self:MouseCapture(false);
	
	if (!self:GetDepressed()) then
		return;
	end;
	
	self:SetDepressed(false);
	
	if (!self:GetHovered()) then
		return;
	end;
	
	if (code == MOUSE_LEFT and self.DoClick and !self:GetDisabled()) then
		self.DoClick(self);
	end;
end;

-- A function to make the panel fade out.
function PANEL:FadeOut(speed, Callback)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255));
		
		if (animation.Finished) then
			panel:SetVisible(false);
				if (Callback) then
					Callback();
				end;
			self.animation = nil;
		end;
	end);
	
	if (self.animation) then
		self.animation:Start(speed);
	end;
end;

-- A function to make the panel fade in.
function PANEL:FadeIn(speed, Callback)
	self.animation = Derma_Anim("Fade Panel", self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255);
		
		if (animation.Finished) then
			if (Callback) then
				Callback();
			end;
			
			self.animation = nil;
		end;
	end);
	
	if (self.animation) then
		self.animation:Start(speed);
	end;

	self:SetVisible(true);
end;

-- Called every frame.
function PANEL:Think()
	if (self.animation) then
		self.animation:Run();
	end;
end;

-- A function to set the panel's Callback.
function PANEL:SetCallback(Callback)
	self.DoClick = function(button)
		Callback(button);
	end;
end;

vgui.Register("cwImageButton", PANEL, "DImage");
