local validColor = Color(0, 255, 0)
local invalidColor = Color(100, 100, 100)
local minDistance = (38 * 38)
local maxDistance = (168 * 168)
local minYSpace = 6

local upVec = Vector(0, 0, 1)
local upTolerance = 0.9

function cwPrimevalismSense:ValidateYSpace(pos, normal, filter)
    if (normal:Dot(upVec) >= upTolerance) then return false end

    // Basically we want to offset the trace angle so it doesn't just point straight down if you're trying to place on uneven surfaces.
    if (normal.z < 0) then
        normal = upVec
    else
        normal = normal:Angle():Up()
    end

    local data = {}
    data.start = pos
    data.endpos = (data.start + (normal * -minYSpace))
    data.filter = filter

    return (!util.TraceLine(data).Hit)
end

function cwPrimevalismSense:ValidateRope(player, startPos, endPos, startNormal)
    local data = {}
    data.start = player:EyePos()
    data.endpos = (data.start + player:GetAimVector() * 96)
    data.filter = player

    local tr = util.TraceLine(data)

    if (!tr.Hit or (IsValid(tr.Entity) and !tr.Entity:IsWorld())) then return false end

    if (!self:ValidateYSpace(startPos, startNormal, (CLIENT and self.tripwireInfo.ent1 or NULL))) then return false end
    if (!self:ValidateYSpace(endPos, tr.HitNormal, (CLIENT and self.tripwireInfo.ent2 or NULL))) then return false end

    local dist = startPos:DistToSqr(endPos)

    if (dist < minDistance or dist > maxDistance) then return false end

    return true
end