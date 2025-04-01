--[[
	Begotten III: Jesus Wept
	Anomalous Events
	By: DETrooper
--]]

-- Called when the local player attempts to see the top bars.
function cwAnomalous:PlayerCanSeeBars(class)
	if (Clockwork.Client.CosmicRuptureRender) then
		return false;
	end
end

function cwAnomalous:PlayerDrawWeaponSelect()
	if (Clockwork.Client.CosmicRuptureRender) then
		return false;
	end;
end;

-- Called when the screenspace effects are rendered.
function cwAnomalous:RenderScreenspaceEffects()
	if (Clockwork.Client.CosmicRuptureRender) then
		DrawMaterialOverlay("effects/fucked", 0.0001);
	end
end

function cwAnomalous:Think()
	if Clockwork.Client:HasInitialized() then
		local curTime = CurTime()
		
		if not self.tvPlayingTimer then
			self.tvPlayingTimer = curTime + math.random(900, 1800);
		end
		
		if curTime >= self.tvPlayingTimer then
			if not self.tvPlaying then
				self:StartRandomTVHallucination();
			else
				self.tvPlaying = false;
				self.tvPlayingTimer = curTime + math.random(900, 1800);
				
				if IsValid(self.tvMonitor) then
					self.tvMonitor:Remove();
				end
				
				if IsValid(self.tvScreen) then
					self.tvScreen:Remove();
				end
				
				if IsValid(self.tvTable) then
					self.tvTable:Remove();
				end
				
				self.tvMonitor = nil;
				self.tvScreen = nil;
				self.tvTable = nil;
			end
		end
	end
end