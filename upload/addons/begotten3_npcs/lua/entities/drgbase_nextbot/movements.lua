
-- Convars --

local ComputeDelay = CreateConVar("drgbase_compute_delay", "0.1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local AvoidObstacles = CreateConVar("drgbase_avoid_obstacles", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local MultSpeed = CreateConVar("drgbase_multiplier_speed", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Getters/setters --

function ENT:GetSpeed()
	return self:GetNW2Float("DrGBaseSpeed")
end

function ENT:Speed(scale)
	local speed = self:GetVelocity():Length()
	if scale then return speed/self:GetScale()
	else return speed end
end
function ENT:SpeedSqr(scale)
	if not scale then return self:GetVelocity():LengthSqr()
	else return (self:GetVelocity()/self:GetScale()):LengthSqr() end
end
function ENT:IsSpeedMore(speed, scale)
	return speed^2 < self:SpeedSqr(scale)
end
function ENT:IsSpeedLess(speed, scale)
	return speed^2 > self:SpeedSqr(scale)
end
function ENT:IsSpeedEqual(speed, scale)
	return speed^2 == self:SpeedSqr(scale)
end
function ENT:IsSpeedMoreEqual(speed, scale)
	return self:IsSpeedEqual(speed, scale) or self:IsSpeedMore(speed, scale)
end
function ENT:IsSpeedLessEqual(speed, scale)
	return self:IsSpeedEqual(speed, scale) or self:IsSpeedLess(speed, scale)
end

function ENT:GetMovement(ignoreZ)
	if not self:IsMoving() then return Vector(0, 0, 0) end
	local dir = self:GetVelocity()
	if ignoreZ then dir.z = 0 end
	return (self:GetAngles()-dir:Angle()):Forward()
end

function ENT:IsMoving()
	return not self:GetVelocity():IsZero()
end
function ENT:IsMovingUp()
	return math.Round(self:GetMovement().z) > 0
end
function ENT:IsMovingDown()
	return math.Round(self:GetMovement().z) < 0
end
function ENT:IsMovingForward()
	return math.Round(self:GetMovement().x) > 0
end
function ENT:IsMovingBackward()
	return math.Round(self:GetMovement().x) < 0
end
function ENT:IsMovingRight()
	return math.Round(self:GetMovement().y) > 0
end
function ENT:IsMovingLeft()
	return math.Round(self:GetMovement().y) < 0
end
function ENT:IsMovingForwardLeft()
	return self:IsMovingForward() and self:IsMovingLeft()
end
function ENT:IsMovingForwardRight()
	return self:IsMovingForward() and self:IsMovingRight()
end
function ENT:IsMovingBackwardLeft()
	return self:IsMovingBackward() and self:IsMovingLeft()
end
function ENT:IsMovingBackwardRight()
	return self:IsMovingBackward() and self:IsMovingRight()
end

function ENT:IsTurning(prec)
	return math.Round(self:GetAngles().y, prec) ~= math.Round(self._DrGBaseLastAngle.y, prec)
end
function ENT:IsTurningLeft(prec)
	if not self:IsTurning(prec) then return false end
	return math.AngleDifference(self:GetAngles().y, self._DrGBaseLastAngle.y) > 0
end
function ENT:IsTurningRight(prec)
	if not self:IsTurning(prec) then return false end
	return math.AngleDifference(self:GetAngles().y, self._DrGBaseLastAngle.y) < 0
end

function ENT:IsClimbing()
	return self:GetNW2Bool("DrGBaseClimbing")
end
function ENT:IsClimbingUp()
	return self:IsClimbing() and not self:IsClimbingDown()
end
function ENT:IsClimbingDown()
	return self:IsClimbing() and self:GetNW2Bool("DrGBaseClimbingDown")
end

-- Functions --

-- Hooks --

-- Handlers --

function ENT:_InitMovements()
	self._DrGBaseLastAngle = self:GetAngles()
end

function ENT:_HandleMovements()
	local angles = self:GetAngles()
	self:Timer(0.1, function()
		self._DrGBaseLastAngle = angles
	end)
end

if SERVER then

	-- Getters/setters --

	function ENT:SetSpeed(speed)
		self.loco:SetDesiredSpeed(speed*self:GetScale())
	end

	function ENT:IsRunning()
		if self:IsMoving() then
			local run = false
			if self:IsPossessed() then
				run = self:GetPossessor():KeyDown(IN_SPEED)
			else run = self:ShouldRun() end
			return run
		else return false end
	end

	function ENT:IsClimbingLadder(ladder)
		if IsValid(ladder) then
			return self:IsClimbingLadder() and ladder == self._DrGBaseClimbLadder
		else
			if not self:IsClimbing() then return false end
			return IsValid(self._DrGBaseClimbLadder), self._DrGBaseClimbLadder
		end
	end
	function ENT:IsClimbingLedge()
		return self:IsClimbing() and not IsValid(self._DrGBaseClimbLadder)
	end

	-- Functions --

	function ENT:Approach(pos, nb)
		if isentity(pos) then pos = pos:GetPos() end
		self.loco:Approach(pos, nb or 1)
	end
	function ENT:FaceTowards(pos)
		if isentity(pos) then pos = pos:GetPos() end
		self.loco:FaceTowards(pos)
	end
	function ENT:FaceInstant(pos)
		if isentity(pos) then pos = pos:GetPos() end
		local angle = (pos - self:GetPos()):Angle()
		self:SetAngles(Angle(0, angle.y, 0))
	end
	function ENT:FaceTo(toface)
		while true do
			local pos = toface
			if isentity(pos) then
				if not IsValid(pos) then return end
				pos = pos:GetPos()
			end
			local angle = (pos - self:GetPos()):Angle()
			if math.NormalizeAngle(math.Round(self:GetAngles().y)) == math.NormalizeAngle(math.Round(angle.y)) then return end
			self:FaceTowards(pos)
			self:YieldCoroutine(true)
		end
	end
	function ENT:FaceEnemy()
		if self:HasEnemy() then self:FaceTowards(self:GetEnemy()) end
	end

	function ENT:MoveTowards(pos)
		if isentity(pos) then pos = pos:GetPos() end
		self:FaceTowards(pos)
		self:Approach(pos)
	end
	function ENT:MoveAwayFrom(pos, face)
		if isentity(pos) then pos = pos:GetPos() end
		local away = self:GetPos()*2 - pos
		if face then
			self:FaceTowards(pos)
			self:Approach(away)
		else self:MoveTowards(away) end
	end

	function ENT:MoveForward(dist, callback)
		if not isnumber(dist) then
			self:Approach(self:GetPos() + self:GetForward())
		elseif dist > 0 then
			local start = self:GetPos()
			while self:GetRangeSquaredTo(start) < dist^2 do
				self:MoveForward()
				if isfunction(callback) and callback(self, self:GetRangeTo(start)) then return end
				self:YieldCoroutine(true)
			end
		end
	end
	function ENT:MoveBackward(dist, callback)
		if not isnumber(dist) then
			self:Approach(self:GetPos() - self:GetForward())
		elseif dist > 0 then
			local start = self:GetPos()
			while self:GetRangeSquaredTo(start) < dist^2 do
				self:MoveBackward()
				if isfunction(callback) and callback(self, self:GetRangeTo(start)) then return end
				self:YieldCoroutine(true)
			end
		end
	end
	function ENT:MoveRight(dist, callback)
		if not isnumber(dist) then
			self:Approach(self:GetPos() + self:GetRight())
		elseif dist > 0 then
			local start = self:GetPos()
			while self:GetRangeSquaredTo(start) < dist^2 do
				self:MoveRight()
				if isfunction(callback) and callback(self, self:GetRangeTo(start)) then return end
				self:YieldCoroutine(true)
			end
		end
	end
	function ENT:MoveLeft(dist, callback)
		if not isnumber(dist) then
			self:Approach(self:GetPos() - self:GetRight())
		elseif dist > 0 then
			local start = self:GetPos()
			while self:GetRangeSquaredTo(start) < dist^2 do
				self:MoveLeft()
				if isfunction(callback) and callback(self, self:GetRangeTo(start)) then return end
				self:YieldCoroutine(true)
			end
		end
	end

	function ENT:TurnRight(angle, callback)
		if not isnumber(angle) then
			self:FaceTowards(self:GetPos() + self:GetRight())
		elseif angle > 0 then
			local turned = 0
			local last = self:GetAngles()
			local forward = self:GetForward()
			forward:Rotate(Angle(0, -angle, 0))
			while math.Round(turned) < angle do
				if angle - turned < 180 then
					self:FaceTowards(self:GetPos() + forward)
				else self:TurnRight() end
				turned = turned + math.AngleDifference(last.y, self:GetAngles().y)
				if isfunction(callback) and callback(self, turned) then return end
				last = self:GetAngles()
				self:YieldCoroutine(true)
			end
		end
	end
	function ENT:TurnLeft(angle, callback)
		if not isnumber(angle) then
			self:FaceTowards(self:GetPos() - self:GetRight())
		elseif angle > 0 then
			if angle <= 0 then return end
			local turned = 0
			local last = self:GetAngles()
			local forward = self:GetForward()
			forward:Rotate(Angle(0, angle, 0))
			while math.Round(turned) < angle do
				if angle - turned < 180 then
					self:FaceTowards(self:GetPos() + forward)
				else self:TurnLeft() end
				turned = turned - math.AngleDifference(last.y, self:GetAngles().y)
				if isfunction(callback) and callback(self, turned) then return end
				last = self:GetAngles()
				self:YieldCoroutine(true)
			end
		end
	end

	-- Coroutine --

	local function ShouldCompute(self, path, pos)
		if not IsValid(path) then return true end
		local segments = #path:GetAllSegments()
		if path:GetAge() >= ComputeDelay:GetFloat()*segments then
			return path:GetEnd():DistToSqr(pos) > path:GetGoalTolerance()^2
		else return false end
	end
	function ENT:FollowPath(pos, tolerance, generator)
		if isentity(pos) then
			if not IsValid(pos) then return "unreachable" end
			if pos:GetClass() == "npc_barnacle" then
				pos = util.DrG_TraceLine({
					start = pos:GetPos(), endpos = pos:GetPos()-Vector(0, 0, 999999),
					collisiongroup = COLLISION_GROUP_DEBRIS
				}).HitPos
			else pos = pos:GetPos() end
		end
		tolerance = isnumber(tolerance) and tolerance or 20
		if navmesh.IsLoaded() and self:GetGroundEntity():IsWorld() then
			local path = self:GetPath()
			path:SetGoalTolerance(tolerance)
			local area = navmesh.GetNearestNavArea(pos)
			if IsValid(area) then pos = area:GetClosestPointOnArea(pos) or pos end
			if not IsValid(path) and
			self:GetRangeSquaredTo(pos) <= path:GetGoalTolerance()^2 then return "reached" end
			if ShouldCompute(self, path, pos) then path:Compute(self, pos, generator) end
			if not IsValid(path) then return "unreachable" end
			local current = path:GetCurrentGoal()
			local ledge = self:FindLedge(current.type ~= 2)
			if isvector(ledge) then
				self:ClimbLedge(ledge)
				path:Invalidate()
				return "ledge", ledge
			elseif current.type == 2 and
			self:GetRangeTo(current.pos) <= path:GetGoalTolerance() then
				if not self:AvoidObstacles(true) then
					self:MoveTowards(path:NextSegment().pos)
					if self.loco:IsStuck() then
						self:HandleStuck()
						return "stuck"
					else return "moving" end
				else return "obstacle" end
			elseif current.type == 4 then
				local ladder = current.ladder
				if not self.ClimbLaddersUp then return "unreachable" end
				if self:GetHullRangeSquaredTo(ladder:GetBottom()) < self.LaddersUpDistance^2 then
					self:ClimbLadderUp(ladder)
					path:Invalidate()
					return "ladder_up", ladder
				elseif not self:AvoidObstacles(true) then
					self:MoveTowards(current.pos)
					return "moving", ladder
				else return "obstacle" end
			elseif current.type == 5 then
				local ladder = current.ladder
				if not self.ClimbLaddersDown then
					local drop = ladder:GetTop().z - ladder:GetBottom().z
					if drop <= self.loco:GetDeathDropHeight() then
						if not self:AvoidObstacles(true) then
							self:MoveTowards(self:GetPos() + current.forward)
							if self.loco:IsStuck() then
								self:HandleStuck()
								return "stuck", ladder
							else return "moving", ladder end
						else return "obstacle" end
					else return "unreachable" end
				elseif self:GetHullRangeSquaredTo(ladder:GetTop()) < self.LaddersDownDistance^2 then
					self:ClimbLadderDown(ladder)
					path:Invalidate()
					return "ladder_down", ladder
				elseif not self:AvoidObstacles(true) then
					self:MoveTowards(current.pos)
					if self.loco:IsStuck() then
						self:HandleStuck()
						return "stuck", ladder
					else return "moving", ladder end
				else return "obstacle" end
			elseif not self:LastComputeSuccess() and
			path:GetCurrentGoal().distanceFromStart == path:LastSegment().distanceFromStart then
				return "unreachable"
			elseif not self:AvoidObstacles(true) then
				path:Update(self)
				if not IsValid(path) then return "reached"
				elseif self.loco:IsStuck() then
					self:HandleStuck()
					return "stuck"
				else return "moving" end
			else return "obstacle" end
		else
			local ledge = self:FindLedge()
			if isvector(ledge) then
				self:ClimbLedge(ledge)
				self:InvalidatePath()
				return "ledge", ledge
			elseif not self:AvoidObstacles(true) then
				if self:GetRangeSquaredTo(pos) > tolerance^2 then
					self:MoveTowards(pos)
					if self.loco:IsStuck() then
						self:HandleStuck()
						return "stuck"
					else return "moving" end
				else return "reached" end
			else return "obstacle" end
		end
	end

	function ENT:GoTo(pos, tolerance, callback)
		if isentity(pos) then pos = pos:GetPos() end
		if not isfunction(callback) then callback = function() end end
		while true do
			local res = self:FollowPath(pos, tolerance)
			if res == "reached" then return true
			elseif res == "unreachable" then
				return false
			else
				res = callback(self, self:GetPath())
				if isbool(res) then return res end
				self:YieldCoroutine(true)
			end
		end
	end

	function ENT:ChaseEntity(ent, tolerance, callback)
		if not isentity(ent) then return false end
		if not isfunction(callback) then callback = function() end end
		while IsValid(ent) do
			local res = self:FollowPath(ent, tolerance)
			if res == "reached" then return true
			elseif res == "unreachable" then
				return false
			else
				res = callback(self, self:GetPath())
				if isbool(res) then return res end
				self:YieldCoroutine(true)
			end
		end
		return false
	end

	-- Climbing --

	-- Ladders
	function ENT:ClimbLadder(ladder, down, callback)
		if self:IsClimbing() then return end
		local height = math.abs(ladder:GetTop().z - ladder:GetBottom().z)
		local res = self:OnStartClimbing(ladder, height, down)
		if res == false then return end
		self:SetNW2Bool("DrGBaseClimbing", true)
		self:SetNW2Bool("DrGBaseClimbingDown", down)
		self._DrGBaseClimbLadder = ladder
		if res ~= true then
			local offset = self:CalcOffset(self.ClimbOffset)*self:GetScale()
			offset.z = 0
			local lastHeight = self:GetPos().z
			local lastTime = CurTime()
			while true do
				self:FaceTowards(self:GetPos() - ladder:GetNormal())
				local pos
				if down then
					pos = ladder:GetPosAtHeight(lastHeight - self:GetSpeed()*self:GetScale()*(CurTime()-lastTime))
					self:SetPos(pos + offset)
					if ladder:GetBottom().z >= pos.z then break end
					local remaining = (ladder:GetBottom().z - pos.z)/self:GetScale()
					if self:OnClimbing(ladder, remaining, true) then break end
					if isfunction(callback) and callback(self, ladder, remaining, true) then break end
				else
					pos = ladder:GetPosAtHeight(lastHeight + self:GetSpeed()*self:GetScale()*(CurTime()-lastTime))
					self:SetPos(pos + offset)
					if ladder:GetTop().z <= pos.z then break end
					local remaining = (ladder:GetTop().z - pos.z)/self:GetScale()
					if self:OnClimbing(ladder, remaining, false) then break end
					if isfunction(callback) and callback(self, ladder, remaining, false) then break end
				end
				lastHeight = pos.z
				lastTime = CurTime()
				self:YieldCoroutine(false)
			end
			local pos = self:GetPos()
			if down then
				self:OnStopClimbing(ladder, ladder:GetBottom().z - pos.z, true)
			else self:OnStopClimbing(ladder, ladder:GetTop().z - pos.z, false) end
		else self:CustomClimbing(ladder, height, down) end
		self:SetNW2Bool("DrGBaseClimbing", false)
		self._DrGBaseClimbLadder = nil
		self:SetVelocity(Vector(0, 0, 0))
	end
	function ENT:ClimbLadderUp(ladder)
		return self:ClimbLadder(ladder, false)
	end
	function ENT:ClimbLadderDown(ladder)
		return self:ClimbLadder(ladder, true)
	end

	-- Ledges
	local function IsEntityClimbable(self, ent)
		if ent:IsWorld() then return true
		elseif not IsValid(ent) then return false end
		if ent:GetClass() == "func_lod" then return true end
		return self.ClimbProps and ent:GetClass() == "prop_physics" and ent:GetVelocity():IsZero()
	end
	function ENT:FindLedge(propOnly)
		if not self.ClimbLedges or (propOnly and not self.ClimbProps) then return end
		local hull = self:TraceHull(self:GetForward()*self.LedgeDetectionDistance, {step = true})
		if not hull.Hit then return end
		if IsValid(hull.Entity) then
			if hull.Entity:GetClass() == "prop_physics" then
				if not self.ClimbProps then return end
			elseif hull.Entity:GetClass() == "prop_door_rotating" then
				self:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
				self:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 100, math.random(70, 130));
				self:HandleDoorDamage(hull.Entity);
			end
		elseif propOnly then return end
		if IsEntityClimbable(self, hull.Entity) then
			local up = self:TraceHull(self:GetUp()*self.ClimbLedgesMaxHeight+Vector(0, 0, self:Height()*1.1)).HitPos
			local height = up.z - self:GetPos().z
			local i = 1
			local tr = {Hit = true, HitNonWorld = true}
			local precision = 5
			while tr.Hit do
				if i*precision > height then return end
				tr = self:TraceHull(self:GetForward()*self:Length(), {
					start = self:GetPos() + Vector(0, 0, i*precision)
				})
				i = i+1
			end
			local tr2 = self:TraceHull(self:GetUp()*-999, {
				start = tr.HitPos
			})
			if tr2.HitPos.z - self:GetPos().z > self.ClimbLedgesMaxHeight then return end
			local trRad = self:TraceHullRadial(999, 360, {
				collisiongroup = COLLISION_GROUP_DEBRIS,
				maxs = Vector(0.5, 0.5, self:Height()),
				mins = Vector(-0.5, -0.5, self:GetStepHeight())
			})
			local pos = self:GetPos()
			local ledge = self:TraceLine(trRad[1].Normal*self:Length(), {
				collisiongroup = COLLISION_GROUP_DEBRIS,
				start = Vector(pos.x, pos.y, tr2.HitPos.z - 1)
			}).HitPos
			local height = ledge.z - self:GetPos().z
			if math.Clamp(height, self.ClimbLedgesMinHeight, self.ClimbLedgesMaxHeight) == height then
				return ledge
			end
		end
	end
	function ENT:ClimbLedge(ledge, callback)
		if self:IsClimbing() then return end
		local height = math.abs(ledge.z - self:GetPos().z)
		local res = self:OnStartClimbing(ledge, height, false)
		if res == false then return end
		self:SetNW2Bool("DrGBaseClimbing", true)
		self:SetNW2Bool("DrGBaseClimbingDown", false)
		if res ~= true then
			local offset = self:CalcOffset(self.ClimbOffset)*self:GetScale()
			offset.z = 0
			local lastPos = self:GetPos()
			local lastTime = CurTime()
			while true do
				self:YieldCoroutine(false)
				self:FaceTowards(ledge)
				local pos = lastPos + lastPos:DrG_Direction(ledge):GetNormalized()*self:GetSpeed()*self:GetScale()*(CurTime()-lastTime)
				if pos.z > ledge.z then pos.z = ledge.z end
				lastTime = CurTime()
				lastPos = pos
				local hull = self:TraceHull(self:GetForward()*self.LedgeDetectionDistance, {
					start = lastPos
				})
				if not IsEntityClimbable(self, hull.Entity) then
					self:SetNW2Bool("DrGBaseClimbing", false)
					self:SetVelocity(Vector(0, 0, 0))
					return
				else
					self:SetPos(pos + offset)
					local remaining = math.abs(ledge.z - self:GetPos().z)/self:GetScale()
					if remaining == 0 then break end
					if self:OnClimbing(ledge, remaining, false) then break end
					if isfunction(callback) and callback(self, ledge, remaining, false) then break end
				end
			end
			self:OnStopClimbing(ledge, math.abs(ledge.z - self:GetPos().z), false)
		else self:CustomClimbing(ledge, height, false) end
		self:SetNW2Bool("DrGBaseClimbing", false)
		self:SetVelocity(Vector(0, 0, 0))
	end

	function ENT:AvoidObstacles(forwardOnly)
		if not AvoidObstacles:GetBool() then return false end
		local hulls = self:CollisionHulls(nil, forwardOnly)
		local direction
		if forwardOnly then
			if hulls.NorthWest.Hit and hulls.NorthEast.Hit then
				direction = "N"
				self:MoveBackward()
			elseif hulls.NorthWest.Hit then
				direction = "NW"
				self:MoveBackward()
				self:MoveRight()
			elseif hulls.NorthEast.Hit then
				direction = "NE"
				self:MoveBackward()
				self:MoveLeft()
			else return false end
			return true, direction
		else
			local nbHit = 0
			for k, tr in pairs(hulls) do
				if tr.Hit then nbHit = nbHit+1 end
			end
			if nbHit == 3 then
				if not hulls.NorthWest.Hit then
					direction = "SE"
					self:MoveForward()
					self:MoveLeft()
				elseif not hulls.NorthEast.Hit then
					direction = "SW"
					self:MoveForward()
					self:MoveRight()
				elseif not hulls.SouthEast.Hit then
					direction = "NW"
					self:MoveBackward()
					self:MoveRight()
				elseif not hulls.SouthWest.Hit then
					direction = "NE"
					self:MoveBackward()
					self:MoveLeft()
				end
			elseif nbHit == 2 then
				if hulls.NorthWest.Hit and hulls.NorthEast.Hit then
					direction = "N"
					self:MoveBackward()
				elseif hulls.NorthEast.Hit and hulls.SouthEast.Hit then
					direction = "E"
					self:MoveLeft()
				elseif hulls.SouthEast.Hit and hulls.SouthWest.Hit then
					direction = "S"
					self:MoveForward()
				elseif hulls.SouthWest.Hit and hulls.NorthWest.Hit then
					direction = "W"
					self:MoveRight()
				end
			elseif nbHit == 1 then
				if hulls.SouthEast.Hit then
					direction = "SE"
					self:MoveForward()
					self:MoveLeft()
				elseif hulls.SouthEast.Hit then
					direction = "SW"
					self:MoveForward()
					self:MoveRight()
				elseif hulls.NorthWest.Hit then
					direction = "NW"
					self:MoveBackward()
					self:MoveRight()
				elseif hulls.NorthEast.Hit then
					direction = "SE"
					self:MoveBackward()
					self:MoveLeft()
				end
			elseif nbHit == 0 then return false end
			return true, direction or "ALL"
		end
	end

	-- Update --

	function ENT:UpdateSpeed()
		if self:IsPlayingAnimation() then return end
		local speed = self:OnUpdateSpeed()
		if isnumber(speed) and speed >= 0 then
			self:SetSpeed(math.Clamp(speed*MultSpeed:GetFloat(), 0, math.huge))
		else
			local seq = self:GetSequence()
			if self:IsClimbing() then
				local success, vec, angles = self:GetSequenceMovement(seq, 0, 1)
				if success then
					local height = vec.z
					local duration = self:SequenceDuration(seq)
					speed = height/duration
				end
			else speed = self:GetSequenceGroundSpeed(seq) end
			if speed ~= 0 then self.loco:SetDesiredSpeed(speed*MultSpeed:GetFloat())
			else self.loco:SetDesiredSpeed(1) end
		end
	end
	function ENT:OnUpdateSpeed()
		if self:IsClimbing() then return self.ClimbSpeed
		elseif self.UseWalkframes then return -1
		elseif self:IsRunning() then return self.RunSpeed
		else return self.WalkSpeed end
	end

	-- Hooks --

	function ENT:OnStartClimbing() end
	function ENT:OnClimbing(...)
		return self:WhileClimbing(...)
	end
	function ENT:WhileClimbing() end
	function ENT:OnStopClimbing() end
	function ENT:CustomClimbing() end

	function ENT:HandleStuck()
		self:ClearStuck()
	end

	-- A function to make an NPC bash down a door. bgt change
	function ENT:HandleDoorDamage(door)
		if (!IsValid(door)) then
			return;
		end;

		if (Clockwork.entity:IsDoorLocked(door)) then
			return;
		end;

		if (!door.health) then
			if (Clockwork.entity:IsDoorLocked(door)) then
				door.health = 0;
				if (door.Barricades) then
					door.health = -1;
				end;
			else
				door.health = 2;
				if (door.Barricades) then
					door.health = 0;
				end;
			end;
		end

		door.health = door.health + 1;

		if (door.health >= 3) then
			door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
			door:SetNotSolid(true);
			door:DrawShadow(false);
			door:SetNoDraw(true);
			door:Fire("Unlock", "", 0);
			door:Fire("Open", "", 0);
			local position = door:GetPos();
			local angles = door:GetAngles();
			local model = door:GetModel();
			local skin = door:GetSkin();

			local fakeDoor = ents.Create("prop_physics");
				fakeDoor:SetPos(position);
				fakeDoor:SetAngles(angles);
				fakeDoor:SetModel(model);
				fakeDoor:SetSkin(skin);
				fakeDoor:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
				fakeDoor:DrawShadow(false);
			fakeDoor:Spawn();

			local position = self:GetPos();
			local doorPosition = fakeDoor:GetPos();

			fakeDoor:SetVelocity(Vector((position - doorPosition) * -40000, (position - doorPosition) * -40000, 0))	;

			timer.Simple(180, function()
				fakeDoor:Remove();

				if (IsValid(door)) then
					door:SetNotSolid(false);
					door:DrawShadow(true);
					door:SetNoDraw(false);
					
					door.health = nil;
				end;
			end);

			local physObj = fakeDoor:GetPhysicsObject();

			if (IsValid(physObj)) then
				physObj:ApplyForceOffset((doorPosition - position) * 1000, position);
			end;

			for k, v in pairs (ents.FindInSphere(doorPosition, 250)) do
				if (v:GetClass() == "prop_physics") then
					local physObj = v:GetPhysicsObject();

					if (IsValid(physObj)) then
						physObj:ApplyForceOffset((v:GetPos() - position) * 1000, position);
					end;
				end;
			end;
		end;
	end;

	-- Handlers --

else

	-- Getters/setters --

	-- Functions --

	-- Hooks --

	-- Handlers --

end
