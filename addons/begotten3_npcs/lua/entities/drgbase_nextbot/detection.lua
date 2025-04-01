
-- Convars --

local EnableSight = CreateConVar("drgbase_ai_sight", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local EnableHearing = CreateConVar("drgbase_ai_hearing", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Getters/setters --

function ENT:GetSightFOV()
	return self:GetNW2Int("DrGBaseSightFOV")
end
function ENT:GetSightRange()
	return self:GetNW2Int("DrGBaseSightRange")
end
function ENT:GetSightLuminosityRange()
	return self:GetNW2Float("DrGBaseMinLuminosity"), self:GetNW2Float("DrGBaseMaxLuminosity")
end
function ENT:IsBlind()
	if not EnableSight:GetBool() then return true end
	if self:GetCooldown("DrGBaseBlind") > 0 then return true end
	return self:GetSightFOV() <= 0 or self:GetSightRange() <= 0
end

function ENT:GetHearingCoefficient()
	return self:GetNW2Int("DrGBaseHearingCoefficient")
end
function ENT:IsDeaf()
	if not EnableHearing:GetBool() then return true
	else return self:GetHearingCoefficient() <= 0 end
end

-- Functions --

-- Hooks --

-- Handlers --

function ENT:_InitDetection()
	self._DrGBaseWasInSight = {}
	if CLIENT then return end
	self:SetSightFOV(self.SightFOV)
	self:SetSightRange(self.SightRange)
	self:SetSightLuminosityRange(self.MinLuminosity, self.MaxLuminosity)
	self:SetHearingCoefficient(self.HearingCoefficient)
end

if SERVER then

	-- Getters/setters --

	function ENT:SetSightFOV(angle)
		if angle > 360 then angle = 360 end
		if angle < 0 then angle = 0 end
		self:SetNW2Int("DrGBaseSightFOV", angle)
	end
	function ENT:SetSightRange(range)
		if range < 0 then range = 0 end
		self:SetNW2Int("DrGBaseSightRange", range)
	end
	function ENT:SetSightLuminosityRange(min, max)
		if isnumber(max) then
			self:SetNW2Float("DrGBaseMinLuminosity", math.Clamp(min, 0, 1))
			self:SetNW2Float("DrGBaseMaxLuminosity", math.Clamp(max, 0, 1))
		else self:SetSightLuminosityRange(0, min) end
	end

	function ENT:SetHearingCoefficient(coeff)
		if coeff < 0 then coeff = 0 end
		self:SetNW2Int("DrGBaseHearingCoefficient", coeff)
	end

	-- Functions --

	function ENT:IsInSight(ent)
		if not IsValid(ent) then return false end
		if self:IsBlind() then return false end
		if ent == self then return true end
		local eyepos = self:EyePos()
		local sightRange = self:GetSightRange(); -- bgt change
		if ent:IsPlayer() and ent:Crouching() then
			if Clockwork and cwBeliefs and ent:HasBelief("nimble") then
				sightRange = math.Round(sightRange * 0.333);
			end
		end
		if eyepos:DistToSqr(ent:GetPos()) > sightRange^2 then return false end
		if ent:IsPlayer() then
			if ent:DrG_IsPossessing() then return self:IsInSight(ent:DrG_GetPossessing()) end
			local luminosity = ent:FlashlightIsOn() and 1 or ent:DrG_Luminosity()
			local min, max = self:GetSightLuminosityRange()
			if luminosity < min or luminosity > max then return false end
		end
		local angle = (eyepos + self:EyeAngles():Forward()):DrG_Degrees(ent:WorldSpaceCenter(), eyepos)
		if angle > self:GetSightFOV()/2 then return false end
		if Clockwork then -- bgt change
			return Clockwork.entity:CanSeeEntity(self, ent);
		else
			return self:Visible(ent)
		end
	end

	net.DrG_DefineCallback("DrGBaseIsInSight", function(nextbot, ent)
		if not IsValid(nextbot) or not IsValid(ent) then return false
		else return nextbot:IsInSight(ent) end
	end)

	-- Get entities in sight
	function ENT:GetInSight(disp, spotted)
		if istable(disp) then
			local insight = {}
			for i, dis in ipairs(disp) do
				table.Merge(insight, self:GetInSight(dis, spotted))
			end
			return insight
		elseif isnumber(disp) then
			local insight = {}
			for ent in self:EntityIterator(disp, spotted) do
				if self:IsInSight(ent) then table.insert(insight, ent) end
			end
			return insight
		else return self:GetInSight({D_LI, D_HT, D_FR, D_NU}, spotted) end
	end
	function ENT:GetAlliesInSight(spotted)
		return self:GetInSight(D_LI, spotted)
	end
	function ENT:GetEnemiesInSight(spotted)
		return self:GetInSight(D_HT, spotted)
	end
	function ENT:GetAfraidOfInSight(spotted)
		return self:GetInSight(D_FR, spotted)
	end
	function ENT:GetHostilesInSight(spotted)
		return self:GetInSight({D_HT, D_FR}, spotted)
	end
	function ENT:GetNeutralInSight(spotted)
		return self:GetInSight(D_NU, spotted)
	end

	-- Check if entities are in sight
	function ENT:UpdateSight(disp, spotted)
		if self:IsAIDisabled() then return end
		if istable(disp) then
			for i, dis in ipairs(disp) do self:UpdateSight(dis, spotted) end
		elseif isnumber(disp) then
			for ent in self:EntityIterator(disp, spotted) do
				local insight = self:IsInSight(ent)
				if not insight and self._DrGBaseWasInSight[ent] then
					self:OnLostSight(ent)
				elseif insight then self:OnSight(ent) end
				self._DrGBaseWasInSight[ent] = insight
			end
		else self:UpdateSight({
			D_LI, D_HT, D_FR, D_NU
		}, spotted) end
	end
	function ENT:UpdateAlliesSight(spotted)
		return self:UpdateSight(D_LI, spotted)
	end
	function ENT:UpdateEnemiesSight(spotted)
		return self:UpdateSight(D_HT, spotted)
	end
	function ENT:UpdateAfraidOfSight(spotted)
		return self:UpdateSight(D_FR, spotted)
	end
	function ENT:UpdateHostilesSight(spotted)
		return self:UpdateSight({D_HT, D_FR}, spotted)
	end
	function ENT:UpdateNeutralSight(spotted)
		return self:UpdateSight(D_NU, spotted)
	end

	function ENT:Blind(blind)
		if self:IsBlind() then return end
		local res = self:OnBlind(blind)
		if res == true then return
		elseif isnumber(res) then blind:ScaleDuration(res) end
		self:SetCooldown("DrGBaseBlind", blind:GetDuration())
		if not isfunction(self.OnBlinded) then return end
		self:ReactInCoroutine(self.OnBlinded, blind)
	end

	-- Hooks --

	function ENT:OnContact(ent)
		self:SpotEntity(ent)
	end
	function ENT:OnSight(ent)
		self:SpotEntity(ent)
	end
	function ENT:OnLostSight() end
	function ENT:OnSound(ent, sound)
		self:SpotEntity(ent)
	end
	function ENT:OnBlind() end
	--function ENT:OnBlinded() end

	-- Handlers --

	--[[local function ATTN_TO_SNDLVL(attn)
		return (50+20)/attn
	end
	local function SNDLVL_TO_ATTN(sndlvl)
		return sndlvl > 50 and 20/(sndlvl-50) or 4
	end
	local SOUND_NORMAL_CLIP_DIST = 1000]]

	local function HandleSound(ent, sound)
		if #DrGBase.GetNextbots() == 0 then return end
		sound.Pos = sound.Pos or ent:GetPos()
		--[[local attenuation = SNDLVL_TO_ATTN(sound.SoundLevel)
		local distance = ((2*SOUND_NORMAL_CLIP_DIST)/attenuation*sound.Volume)/2]]
		local distance = math.pow(sound.SoundLevel/2, 2)*sound.Volume
		--print(distance)
		for i, nextbot in ipairs(DrGBase.GetNextbots()) do
			if ent == nextbot then continue end
			if nextbot:IsAIDisabled() then continue end
			if nextbot:IsDeaf() then continue end
			local mult = nextbot:VisibleVec(sound.Pos) and 1 or 0.5
			if (distance*nextbot:GetHearingCoefficient()*mult)^2 >= nextbot:GetRangeSquaredTo(sound.Pos) then
				nextbot:Timer(0, nextbot.OnSound, ent, sound)
			end
		end
	end
	hook.Add("EntityEmitSound", "DrGBaseNextbotHearing", function(sound)
		if not EnableHearing:GetBool() then return end
		if not IsValid(sound.Entity) then return end
		if sound.Entity:IsPlayer() then
			HandleSound(sound.Entity, sound)
		elseif sound.Entity:IsVehicle() then
			local driver = sound.Entity:GetDriver()
			if IsValid(driver) and driver:IsPlayer() then
				HandleSound(driver, sound)
			end
		end
	end)

else

	-- Getters/setters --

	function ENT:IsInSight(ent, callback)
		if IsValid(ent) then
			return self:NetCallback("DrGBaseIsInSight", callback, ent)
		elseif isfunction(callback) then callback(self, false) end
	end
	function ENT:WasInSight(ent)
		if not IsValid(ent) then return false end
		self:IsInSight(ent, function(self, insight)
			if not IsValid(ent) then return end
			self._DrGBaseWasInSight[ent] = insight
		end)
		return self._DrGBaseWasInSight[ent] or false
	end

end
