--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

function ENT:Think()
	local curTime = CurTime();
	
	if !self.nextSoundCheck or self.nextSoundCheck < curTime then
		if Clockwork.Client:GetPos():DistToSqr(self:GetPos()) < (666 * 666) and self:GetNWBool("Ignited") then
			if !self.Sound then
				self.Sound = CreateSound(self, "ambient/fire/fire_small_loop1.wav");
				self.Sound:PlayEx(0.7, 100);
			end
		elseif self.Sound then
			self.Sound:Stop();
			self.Sound = nil;
		end
		
		self.nextSoundCheck = curTime + 0.5;
	end
	
	if !self.nextLightCheck or self.nextLightCheck < curTime then
		if self:GetNWBool("Ignited") then
			local light = DynamicLight(self:EntIndex())
			
			if (light) then
				light.Pos = self:GetPos() + self:GetUp() * 15
				light.R = 255
				light.G = 100
				light.B = 0
				light.Brightness = 1.7
				light.Size = 2250
				light.Decay = 400
				light.DieTime = curTime + 1
			end
		end
		
		self.nextLightCheck = curTime + 0.2;
	end
end

function ENT:OnRemove()
	if self.Sound then
		self.Sound:Stop();
	end
end;