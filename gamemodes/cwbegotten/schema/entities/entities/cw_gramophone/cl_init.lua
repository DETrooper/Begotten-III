--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id")
	local colorWhite = Clockwork.option:GetColor("white")
	
	y = Clockwork.kernel:DrawInfo("Gramophone", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("An old gramophone capable of playing records.", x, y, colorWhite, alpha);
end;

function ENT:Think()
	local curTime = CurTime();
	
	if !self.nextSoundCheck or self.nextSoundCheck < curTime then
		if !self:IsOff() and self:GetDTString(1) ~= "" and Clockwork.Client:GetPos():DistToSqr(self:GetPos()) < (2048 * 2048) then
			if cwSanity and Clockwork.Client:Sanity() <= 40 then
				if self.Sound and self.SoundName ~= "begotten3soundtrack/insanity/postalredux-thecity.mp3" then
					self.Sound:Stop();
					self.Sound = nil;
				end
				
				if !self.Sound then
					self.Sound = CreateSound(self, "begotten3soundtrack/insanity/postalredux-thecity.mp3");
					self.Sound:PlayEx(1, 100);
					self.SoundName = "begotten3soundtrack/insanity/postalredux-thecity.mp3";
					
					timer.Create("GramophoneInsanityTimer_"..self:EntIndex(), 98, 0, function()
						self.Sound:Stop();
						self.Sound:PlayEx(1, 100);
					end);
				end
			else
				if self.Sound and self.SoundName ~= self:GetDTString(1) then
					self.Sound:Stop();
					self.Sound = nil;
					
					if timer.Exists("GramophoneInsanityTimer_"..self:EntIndex()) then
						timer.Remove("GramophoneInsanityTimer_"..self:EntIndex());
					end;
				end
			
				if !self.Sound then
					self.Sound = CreateSound(self, self:GetDTString(1));
					self.Sound:PlayEx(1, 100);
					self.SoundName = self:GetDTString(1);
				end
			end
		elseif self.Sound then
			self.Sound:Stop();
			self.Sound = nil;
			
			if timer.Exists("GramophoneInsanityTimer_"..self:EntIndex()) then
				timer.Remove("GramophoneInsanityTimer_"..self:EntIndex());
			end;
		end
		
		self.nextSoundCheck = curTime + 0.5;
	end
end

function ENT:OnRemove()
	if self.Sound then
		self.Sound:Stop();
	end
	
	if timer.Exists("GramophoneInsanityTimer_"..self:EntIndex()) then
		timer.Remove("GramophoneInsanityTimer_"..self:EntIndex());
	end;
end;