util.AddNetworkString("cwStartTripwire")
util.AddNetworkString("cwFinishTripwire")
util.AddNetworkString("cwConfirmTripwire")
util.AddNetworkString("cwCancelTripwire")

cwPrimevalismSense.tripwires = cwPrimevalismSense.tripwires or {}

net.Receive("cwFinishTripwire", function(_, player)
    if (!player.tripWiring) then return end

    local endPos = net.ReadVector()

    if (endPos:DistToSqr(vector_origin) < 4) then
        player.tripWiring = nil
        
        net.Start("cwFinishTripwire")
        net.Send(player)

        return
    end

    if (!cwPrimevalismSense:ValidateRope(player, player.tripWiring, endPos)) then Schema:EasyText(player, "peru", "That position is not valid!") return end

    player.tripwirePos = player.tripWiring
    player.tripWiring = nil

    net.Start("cwConfirmTripwire")
        net.WriteVector(player.tripwirePos)
    net.Send(player)

    player:EmitSound("begotten/layingtripwire.mp3", 60, math.random(95, 105))

    Clockwork.player:SetAction(player, "tripwiring", 10, 6.57, function()
        if (!player.tripwirePos) then return end

        player:StopSound("begotten/layingtripwire.mp3")

        local world = game.GetWorld()
        local rope = constraint.CreateKeyframeRope(endPos, 0.5, "cable/xbeam", NULL, world, world:LocalToWorld(player.tripwirePos), 0, world, world:LocalToWorld(endPos), 0, {
            ["Length"] = ((player.tripwirePos - endPos):Length() + 100),
        })

        table.insert(cwPrimevalismSense.tripwires, {
            rope = rope,
            startPos = player.tripwirePos,
            endPos = endPos,
        })

        net.Start("cwFinishTripwire")
        net.Send(player)
    end)
end)

function cwPrimevalismSense:CancelTripwire(player)
    Clockwork.player:SetAction(player, nil)

    net.Start("cwFinishTripwire")
    net.Send(player)

    local item = Clockwork.item:CreateInstance("tripwire")
    player:GiveItem(item, true)
end

function cwPrimevalismSense:CheckTripwireCollision(info)
    local data = {}
    data.start = info.startPos
    data.endpos = info.endPos
    data.collisiongroup = COLLISION_GROUP_PLAYER

    local tr = util.TraceLine(data)
    if (!tr.Hit or !IsValid(tr.Entity) or !tr.Entity:IsPlayer()) then return end

    print(tr.Entity)
end

function cwPrimevalismSense:TripwireThink()
    for _, v in ipairs(self.tripwires) do
        self:CheckTripwireCollision(v)
    end
end

function cwPrimevalismSense:FindTripwiresAlongRay(rayPos, rayDir)
    local found = {}

    for i, v in ipairs(self.tripwires) do
        local hitPos = util.IntersectToleratedRayWithLine(rayPos, rayDir, v.startPos, v.endPos)
        if (!hitPos) then continue end

        table.insert(found, {
            index = i,
            hitPos = hitPos
        })
    end

    return found
end

local maxReach = 96 * 96

function cwPrimevalismSense:CheckPlayerDisarm(player)
    local eyePos = player:EyePos()
    
    local ropes = self:FindTripwiresAlongRay(eyePos, player:GetAimVector())
    if (#ropes == 0) then return end

    local best
    local bestDist = math.huge

    // Find closest rope
    for i, v in ipairs(ropes) do
        local dist = v.hitPos:DistToSqr(eyePos)

        if (dist < bestDist) then
            best = i
            bestDist = dist
        end
    end

    // Check if too far
    if (bestDist > maxReach) then return end

    // Check for LOS
    local data = {}
    data.start = eyePos
    data.endpos = ropes[best].hitPos
    data.filter = player

    if (util.TraceLine(data).Hit) then return end

    // TODO: Implement disarming
end