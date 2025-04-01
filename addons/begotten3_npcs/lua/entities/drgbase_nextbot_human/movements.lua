
-- Getters/setters --

function ENT:IsCrouching()
	return self:GetNW2Bool("DrGBaseCrouching")
end

if SERVER then

	-- Getters/setters --

	function ENT:SetCrouching(bool)
		self:SetNW2Bool("DrGBaseCrouching", bool)
	end

	-- Handlers --

	function ENT:OnUpdateSpeed()
		if self:IsClimbing() then return self.ClimbSpeed
		elseif self:IsCrouching() then
			if self:IsRunning() then return self.WalkSpeed
			else return self.CrouchSpeed end
		elseif self:IsRunning() then return self.RunSpeed
		else return self.WalkSpeed end
	end

	-- Climbing --

	function ENT:OnClimbing(ladder, left, down)
		if IsValid(ladder) then
			self:EmitSlotSound("DrGBaseLadderClimbing", 0.3, "player/footsteps/ladder"..math.random(4)..".wav")
		end
		return not down and left < 112.5
	end
	function ENT:OnStopClimbing(ladder, height, down)
		if down then return end
		local footstep = false
		self:PlayActivityAndMoveAbsolute(ACT_ZOMBIE_CLIMB_END, self.ClimbAnimRate, function(self, cycle)
			if cycle >= 0.875 and not footstep then
				footstep = true
				self:EmitFootstep()
			end
			if cycle > 0.5 or not IsValid(ladder) then return end
			self:EmitSlotSound("DrGBaseLadderClimbing", 0.3, "player/footsteps/ladder"..math.random(4)..".wav")
		end)
	end

end
