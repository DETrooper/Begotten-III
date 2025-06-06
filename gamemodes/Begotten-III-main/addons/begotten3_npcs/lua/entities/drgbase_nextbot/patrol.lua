
-- Getters/setters --

-- Functions --

-- Hooks --

-- Handlers --

function ENT:_InitPatrol()
	if CLIENT then return end
	self._DrGBaseAddedPatrols = {}
end

if SERVER then

	-- Patrol class --

	local Patrol = {}
	Patrol.__index = Patrol
	function Patrol:New(type)
		local patrol = {}
		patrol._type = type
		patrol._time = CurTime()
		setmetatable(patrol, self)
		return patrol
	end
	function Patrol:GetType()
		return self._type
	end
	function Patrol:GetTime()
		return self._time
	end
	function Patrol:FetchPos()
		return Vector(0, 0, 0)
	end
	function Patrol:ShouldRun()
		return false
	end
	function Patrol:IsValid()
		return true
	end
	function Patrol:OnAdded() end
	function Patrol:OnRemoved() end
	function Patrol:OnReached() end
	function Patrol:OnUnreachable() end
	function Patrol:__tostring()
		return "Patrol"
	end

	function DrGBase.Patrol(type)
		if not isnumber(type) then return end
		local PatrolType = Patrol:New(type)
		PatrolType.__index = PatrolType
		return PatrolType
	end

	local PatrolPos = DrGBase.Patrol(PATROL_POS)
	function PatrolPos:New(pos, run)
		local patrol = {}
		patrol._pos = pos
		patrol._run = run
		setmetatable(patrol, self)
		return patrol
	end
	function PatrolPos:FetchPos()
		return self._pos
	end
	function PatrolPos:ShouldRun()
		return self._run or false
	end
	function PatrolPos:__tostring()
		return "PatrolPos ["..self:FetchPos():DrG_ToString(2).."]"
	end

	local PatrolSound = DrGBase.Patrol(PATROL_SOUND)
	function PatrolSound:New(sound)
		local patrol = {}
		patrol._sound = sound
		setmetatable(patrol, self)
		return patrol
	end
	function PatrolSound:FetchPos()
		return self:GetSound().Pos
	end
	function PatrolSound:GetSound()
		return self._sound
	end
	function PatrolSound:ShouldRun()
		return self:GetSound().Channel == CHAN_WEAPON
	end
	function PatrolSound:OnAdded(nextbot)
		if nextbot._DrGBasePatrolSound then
			local selfSound = self:GetSound()
			local oldSound = nextbot._DrGBasePatrolSound:GetSound()
			if oldSound.Channel == CHAN_WEAPON and selfSound.Channel ~= CHAN_WEAPON then return false end
			local selfDist = math.pow(selfSound.SoundLevel/2, 2)*selfSound.Volume
			local oldDist = math.pow(oldSound.SoundLevel/2, 2)*oldSound.Volume
			if oldDist > selfDist then return false end
			nextbot:RemovePatrol(nextbot._DrGBasePatrolSound)
		end
		nextbot._DrGBasePatrolSound = self
	end
	function PatrolSound:OnRemoved(nextbot)
		nextbot._DrGBasePatrolSound = nil
	end
	function PatrolSound:__tostring()
		return "PatrolSound ["..tostring(self:GetSound().Entity).."]"
	end

	local PatrolSearch = DrGBase.Patrol(PATROL_SEARCH)
	function PatrolSearch:New(enemy)
		if not IsValid(enemy) then return end
		local patrol = {}
		patrol._enemy = enemy
		patrol._pos = ent:GetPos()
		setmetatable(patrol, self)
		return patrol
	end
	function PatrolSearch:FetchPos()
		return self._pos
	end
	function PatrolSearch:GetEnemy()
		return self._ent
	end
	function PatrolSearch:ShouldRun(nextbot)
		return not nextbot:VisibleVec(self:FetchPos())
	end
	function PatrolSearch:IsValid(nextbot)
		local ent = self:GetEnemy()
		return IsValid(ent) and nextbot:IsEnemy(ent)
	end
	function PatrolSearch:__tostring()
		return "PatrolSearch ["..tostring(self:GetEnemy()).."]"
	end

	-- Getters/setters --

	function ENT:AddPatrol(patrol)
		if not patrol:IsValid(self) then return false end
		if self:HasPatrol(patrol) then return true end
		if patrol:OnAdded(self) == false then return false end
		self._DrGBaseAddedPatrols[patrol] = true
		self:SortPatrols()
		return true
	end
	function ENT:AddPatrolPos(pos, run)
		return self:AddPatrol(PatrolPos:New(pos, run))
	end
	function ENT:AddPatrolSound(sound)
		return self:AddPatrol(PatrolSound:New(sound))
	end
	function ENT:AddPatrolSearch(enemy)
		return self:AddPatrol(PatrolSearch:New(enemy))
	end

	function ENT:RemovePatrol(patrol)
		if not self:HasPatrol(patrol) then return false end
		self._DrGBaseAddedPatrols[patrol] = nil
		if patrol == self._DrGBasePatrol then
			self:SortPatrols()
		end
		patrol:OnRemoved(self)
		return true
	end

	function ENT:GetPatrol()
		local patrol = self._DrGBasePatrol
		if patrol == nil then return nil end
		if not patrol:IsValid(self) then
			self:RemovePatrol(patrol)
			self:SortPatrols()
			return self:GetPatrol()
		else return patrol end
	end
	function ENT:HasPatrol(patrol)
		if patrol then
			return self._DrGBaseAddedPatrols[patrol] or false
		else
			patrol = self:GetPatrol()
			if patrol == nil then return false end
			return patrol:IsValid(self)
		end
	end

	function ENT:SortPatrols()
		local added, patrol = table.DrG_Fetch(self._DrGBaseAddedPatrols, function(added1, added2, patrol1, patrol2)
			if patrol1:IsValid(self) and not patrol2:IsValid(self) then return true end
			if not patrol1:IsValid(self) and patrol2:IsValid(self) then return false end
			local res = self:OnSortPatrols(patrol1, patrol2)
			if isbool(res) then return res end
			local type1, type2 = patrol1:GetType(), patrol2:GetType()
			if type1 == type2 then
				return patrol1:GetTime() < patrol2:GetTime()
			else return type1 > type2 end
		end)
		self._DrGBasePatrol = patrol
	end
	function ENT:ClearPatrols()
		for patrol, added in pairs(self._DrGBaseAddedPatrols) do
			if added then self:RemovePatrol(patrol) end
		end
	end

	-- Functions --




	-- Hooks --

	function ENT:OnSortPatrols(patrol1, patrol2) end

	-- Handlers --

else

	-- Getters/setters --

	-- Functions --

	-- Hooks --

	-- Handlers --

end
