
-- Convars --

local EnemyRadius = CreateConVar("drgbase_ai_radius", "5000", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Getters/setters --

function ENT:IsAIDisabled()
	return self:GetNW2Bool("DrGBaseAIDisabled") or GetConVar("ai_disabled"):GetBool()
end

function ENT:GetEnemy()
	return self:GetNW2Entity("DrGBaseEnemy")
end
function ENT:HasEnemy()
	return IsValid(self:GetEnemy())
end
function ENT:HaveEnemy()
	return self:HasEnemy()
end
function ENT:HadEnemy()
	return self._DrGBaseHadEnemy
end

function ENT:GetNemesis()
	if self:HasNemesis() then
		return self:GetEnemy()
	else return NULL end
end
function ENT:HasNemesis()
	return self:GetNW2Bool("DrGBaseNemesis") and self:HasEnemy()
end
function ENT:HaveNemesis()
	return self:HasNemesis()
end
function ENT:HadNemesis()
	return self:GetNW2Bool("DrGBaseNemesis") and self:HadEnemy()
end

-- Functions --

-- Hooks --

function ENT:OnNewEnemy() end
function ENT:OnEnemyChange() end
function ENT:OnLastEnemy() end

-- Handlers --

function ENT:_InitAI()
	if SERVER then
		self._DrGBaseAllyDamageTolerance = {}
		self._DrGBaseAfraidOfDamageTolerance = {}
		self._DrGBaseNeutralDamageTolerance = {}
	end
	self:SetNW2VarProxy("DrGBaseEnemy", function(self, _, old, new)
		if not self._DrGBaseHadEnemy and IsValid(new) then
			self._DrGBaseHadEnemy = true
			self:OnNewEnemy(new)
		elseif self._DrGBaseHadEnemy and not IsValid(new) then
			self._DrGBaseHadEnemy = false
			self:OnLastEnemy(old)
		else self:OnEnemyChange(old, new) end
	end)
end

if SERVER then

	-- Getters/setters --

	function ENT:SetAIDisabled(bool)
		local disabled = self:GetNW2Bool("DrGBaseAIDisabled")
		self:SetNW2Bool("DrGBaseAIDisabled", bool)
		if disabled and not bool then
			self:UpdateAI()
		end
	end
	function ENT:DisableAI()
		self:SetAIDisabled(true)
	end
	function ENT:EnableAI()
		self:SetAIDisabled(false)
	end

	function ENT:SetEnemy(enemy)
		self:SetNW2Entity("DrGBaseEnemy", enemy)
		self:SetNW2Bool("DrGBaseNemesis", false)
	end
	function ENT:SetNemesis(nemesis)
		self:SetNW2Entity("DrGBaseEnemy", nemesis)
		self:SetNW2Bool("DrGBaseNemesis", true)
	end

	-- Functions --

	function ENT:UpdateAI()
		self:UpdateHostilesSight()
		self:UpdateEnemy()
	end

	function ENT:UpdateEnemy()
		local enemy
		if not self:IsPossessed() then
			if self:HasNemesis() then return self:GetNemesis() end
			enemy = self:OnUpdateEnemy()
			if enemy == nil then return self:GetEnemy() end
			if not IsValid(enemy) or
			self:GetRangeSquaredTo(enemy) > EnemyRadius:GetFloat()^2 then
				enemy = NULL
			end
			if self:IsAfraidOf(enemy) and
			not self:IsInRange(enemy, self.WatchAfraidOfRange) then
				enemy = NULL
			end
		else enemy = NULL end
		self:SetEnemy(enemy)
		return enemy
	end
	local function CompareEnemies(self, ent1, ent2)
		local res = self:OnFetchEnemy(ent1, ent2)
		if isbool(res) then return res end
		local prio1 = self:GetPriority(ent1)
		local prio2 = self:GetPriority(ent2)
		if prio1 > prio2 then return true
		elseif prio2 > prio1 then return false
		else return self:GetRangeSquaredTo(ent1) < self:GetRangeSquaredTo(ent2) end
	end
	function ENT:FetchEnemy()
		if self:IsPossessed() then return NULL end
		local current = NULL
		for enemy in self:HostileIterator(true) do
			if not IsValid(current) or CompareEnemies(self, enemy, current) then
				current = enemy
			end
		end
		return current
	end

	-- Hooks --

	function ENT:OnRangeAttack() end
	function ENT:OnMeleeAttack() end
	function ENT:OnChaseEnemy() end
	function ENT:OnAvoidEnemy() end
	function ENT:OnIdleEnemy() end
	function ENT:OnEnemyUnreachable() end
	function ENT:OnAllyEnemy() end
	function ENT:OnNeutralEnemy() end

	function ENT:OnAvoidAfraidOf() end
	function ENT:OnIdleAfraidOf() end

	function ENT:OnReachedPatrol()
		self:Wait(math.random(3, 7))
	end
	function ENT:OnPatrolUnreachable()
		self:Wait(math.random(3, 7))
	end
	function ENT:OnPatrolling(...)
		return self:WhilePatrolling(...)
	end
	function ENT:WhilePatrolling() end

	function ENT:OnIdle()
		self:AddPatrolPos(self:RandomPos(1500))
	end

	function ENT:OnUpdateEnemy()
		return self:FetchEnemy()
	end
	function ENT:OnFetchEnemy() end

	function ENT:ShouldRun()
		if self:HasEnemy() then return true end
		local patrol = self:GetPatrol()
		return IsValid(patrol) and patrol:ShouldRun(self)
	end

	-- Handlers --

	cvars.AddChangeCallback("ai_disabled", function(_, _, new)
		for _, nextbot in ipairs(DrGBase.GetNextbots()) do
			if not tobool(new) then nextbot:UpdateAI() end
		end
	end, "DrGBaseDisableAIUpdateBT")

end
