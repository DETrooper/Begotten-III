local validColor = Color(0, 255, 0)
local invalidColor = Color(100, 100, 100)
local maxDistance = 168 * 168
local minYSpace = 6

function cwPrimevalismSense:ValidateYSpace(pos, filter)
    local data = {}
    data.start = pos
    data.endpos = (data.start - Vector(0, 0, minYSpace))
    data.filter = filter

    return (!util.TraceLine(data).Hit)
end

function cwPrimevalismSense:ValidateRope(player, startPos, endPos)
    local data = {}
    data.start = player:EyePos()
    data.endpos = (data.start + player:GetAimVector() * 96)
    data.filter = player

    if (!util.TraceLine(data).Hit) then return false end

    if (!ValidateYSpace(startPos, (CLIENT and self.tripwireInfo.ent1 or NULL))) then return false end
    if (!ValidateYSpace(endPos, (CLIENT and self.tripwireInfo.ent2 or NULL))) then return false end

    if (startPos:DistToSqr(endPos) > maxDistance) then return false end

    return true
end