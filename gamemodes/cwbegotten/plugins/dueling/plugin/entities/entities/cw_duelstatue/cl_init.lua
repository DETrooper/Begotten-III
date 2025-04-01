--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	y = Clockwork.kernel:DrawInfo("A blindfolded statue with a mysterious aura of death and decay. You feel as though touching it will fill you with a nigh-insatiable bloodlust.", x, y, Clockwork.option:GetColor("white"), alpha);
end;

function ENT:Think()
	local curTime = CurTime();
	
	if !self.nextSoundCheck or self.nextSoundCheck < curTime then
		if Clockwork.Client:GetPos():DistToSqr(self:GetPos()) < (600 * 600) then
			if !self.Sound then
				self.Sound = CreateSound(self, "ambient/statue/st_seventhday_01.wav");
				self.Sound:PlayEx(0.2, 100);
			end
		elseif self.Sound then
			self.Sound:Stop();
			self.Sound = nil;
		end
		
		self.nextSoundCheck = curTime + 0.5;
	end
end

function ENT:OnRemove()
	if self.Sound then
		self.Sound:Stop();
	end
end;