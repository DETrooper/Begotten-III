--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local name = self:GetNWString("name");
	
	if !name or name:len() == 0 then
		y = Clockwork.kernel:DrawInfo("A large and formidable Goreic warship.", x, y, Clockwork.option:GetColor("white"), alpha);
	else
		y = Clockwork.kernel:DrawInfo("A large and formidable Goreic warship. The name '"..name.."' is chiselled onto its side in Goreic script.", x, y, Clockwork.option:GetColor("white"), alpha);
	end
end;

function ENT:Think()
	if self:GetNWBool("Ignited") then
		local curTime = CurTime();
		
		if !self.nextBurnCheck or self.nextBurnCheck < curTime then
			if !self.Particles then
				self.Particles = CreateParticleSystem(self, "fire_large_02", 1, 0, Vector(0, 0, 16));
			end
		
			if !self:IsDormant() then
				if !self.Sound then
					self.Sound = CreateSound(self, "ambient/fire/fire_med_loop1.wav");
					self.Sound:PlayEx(0.2, 100);
				end
			else 
				if self.Particles then
					self.Particles:StopEmissionAndDestroyImmediately();
					self.Particles = nil;
				end
			
				if self.Sound then
					self.Sound:Stop();
					self.Sound = nil;
				end
			end
			
			self.nextBurnCheck = curTime + 0.5;
		end
	else
		if self.Particles then
			self.Particles:StopEmissionAndDestroyImmediately();
			self.Particles = nil;
		end
	
		if self.Sound then
			self.Sound:Stop();
			self.Sound = nil;
		end
	end
end

function ENT:OnRemove()
	if self.Particles then
		self.Particles:StopEmissionAndDestroyImmediately();
		self.Particles = nil;
	end
	
	if self.Sound then
		self.Sound:Stop();
		self.Sound = nil;
	end
end