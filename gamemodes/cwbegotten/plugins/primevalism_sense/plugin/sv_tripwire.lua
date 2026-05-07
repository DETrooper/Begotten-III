util.AddNetworkString("cwStartTripwire")
util.AddNetworkString("cwFinishTripwire")
util.AddNetworkString("cwConfirmTripwire")
util.AddNetworkString("cwCancelTripwire")

cwPrimevalismSense.tripwireHits = 5

cwPrimevalismSense.tripwires = cwPrimevalismSense.tripwires or {}

function cwPrimevalismSense:ReorderTripwires()
    for i, v in ipairs(self.tripwires) do
        v.index = i
    end
end

function cwPrimevalismSense:GetTripwireIndex(rope)
    for i, v in ipairs(self.tripwires) do
        if (v == rope) then return i end
    end
end

function cwPrimevalismSense:CreateTripwire(startPos, endPos, ent)
    local rope = constraint.CreateKeyframeRope(endPos, 0.5, "models/flesh", NULL, ent, ent:LocalToWorld(startPos), 0, ent, ent:LocalToWorld(endPos), 0, {
        ["Length"] = ((startPos - endPos):Length() + 25),
    })

    table.insert(cwPrimevalismSense.tripwires, {
        rope = rope,
        startPos = startPos,
        endPos = endPos,
        hitsLeft = cwPrimevalismSense.tripwireHits,
        index = (#cwPrimevalismSense.tripwires + 1),
        nextHit = 0,
    })

    return cwPrimevalismSense.tripwires[#cwPrimevalismSense.tripwires]
end

net.Receive("cwFinishTripwire", function(_, player)
    if (!player.tripWiring) then return end
    if (Clockwork.player:GetAction(player)) then return end

    local endPos = net.ReadVector()

    if (endPos:DistToSqr(vector_origin) < 4) then
        player.tripWiring = nil
        
        net.Start("cwFinishTripwire")
        net.Send(player)

        return
    end

    if (!cwPrimevalismSense:ValidateRope(player, player.tripWiring.pos, endPos, player.tripWiring.normal)) then Schema:EasyText(player, "peru", "That position is not valid!") return end

    player.tripwireInfo = player.tripWiring
    player.tripWiring = nil

    net.Start("cwConfirmTripwire")
        net.WriteVector(endPos)
    net.Send(player)

    player:EmitSound("begotten/layingtripwire.mp3", 60, math.random(95, 105))

    Clockwork.player:SetAction(player, "tripwiring", 6.57, 10, function()
        if (!player.tripwireInfo) then return end

        player:StopSound("begotten/layingtripwire.mp3")

        cwPrimevalismSense:CreateTripwire(player.tripwireInfo.pos, endPos, game.GetWorld())

        net.Start("cwFinishTripwire")
        net.Send(player)

        player.tripwireInfo = nil
    end)
end)

function cwPrimevalismSense:CancelTripwire(player)
    Clockwork.player:SetAction(player, nil)

    net.Start("cwFinishTripwire")
    net.Send(player)

    local item = Clockwork.item:CreateInstance("tripwire")
    player:GiveItem(item, true)

    player:StopSound("begotten/layingtripwire.mp3")

    player.tripWiring = nil
end

local tripwireMes = {
    "runs right into a tripwire, stumbling and falling over!",
    "trips over a tripwire, falling onto the ground!",
    "sprints over a tripwire, stumbling and losing their balance!",
}

function cwPrimevalismSense:OnPlayerTripwired(player, info)
    player:EmitSound(string.format("begotten/tripwire%i.mp3", math.random(1, 5)), 100, math.random(95, 105))

    player.tripwireSlowdown = (CurTime() + 4)
    hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true)

    if (player:IsRunning()) then
        cwMelee:PlayerStabilityFallover(player, 8, _, true)

        Clockwork.chatBox:AddInTargetRadius(player, "me", tripwireMes[math.random(#tripwireMes)], player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)
    end

    info.hitsLeft = (info.hitsLeft - 1)

    if (info.hitsLeft == 0) then
        cwPrimevalismSense:RemoveTripwire(info)

        Clockwork.chatBox:AddInTargetRadius(player, "it", "The tripwire finally snaps!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)
    end
end

function cwPrimevalismSense:CheckTripwireCollision(info)
    local curTime = CurTime()

    if (info.nextHit > curTime) then return end

    local data = {}
    data.start = info.startPos
    data.endpos = info.endPos
    data.collisiongroup = COLLISION_GROUP_PLAYER

    local tr = util.TraceLine(data)
    local player = tr.Entity

    if (!tr.Hit or !IsValid(player) or !player:IsPlayer()) then return end
    if (player.cwObserverMode or !player:Alive() or !player:HasInitialized() or player:IsRagdolled() or (player.tripwireSlowdown and player.tripwireSlowdown > curTime)) then return end

    info.nextHit = curTime + 1

    hook.Run("OnPlayerTripwired", player, info)
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

function cwPrimevalismSense:DisarmTripwire(player, rope)
    if (Clockwork.player:GetAction(player) or !player:HasBelief("ingenious")) then return end

    Clockwork.chatBox:AddInTargetRadius(player, "me", "begins cutting a tripwire.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2)

    player:EmitSound("begotten/layingtripwire.mp3", 60, 50)

    Clockwork.player:SetAction(player, "cuttingTripwire", 12, 10, function()
        if (!rope or !self:GetTripwireIndex(rope) or player.tripWiring) then return end

        player:StopSound("begotten/layingtripwire.mp3", 60, 50)

        cwPrimevalismSense:RemoveTripwire(rope)
    end)
end

local maxReach = 72
local maxReachSqr = (maxReach * maxReach)

function cwPrimevalismSense:CheckPlayerDisarm(player)
    if (Clockwork.player:GetAction(player)) then return end

    local eyePos = player:EyePos()
    
    local ropes = self:FindTripwiresAlongRay(eyePos, player:GetAimVector() * maxReach)

    if (#ropes == 0) then return end

    local best
    local bestDist = math.huge

    for i, v in ipairs(ropes) do
        local dist = v.hitPos:DistToSqr(eyePos)

        if (dist < bestDist) then
            best = i
            bestDist = dist
        end
    end

    if (bestDist > maxReachSqr) then return end

    local data = {}
    data.start = eyePos
    data.endpos = ropes[best].hitPos
    data.filter = player

    if (util.TraceLine(data).Hit) then return end

    if (!IsValid(player) or !ropes[best] or !self.tripwires[ropes[best].index] or player.tripWiring) then return end
    
    self:DisarmTripwire(player, self.tripwires[ropes[best].index])
end

function cwPrimevalismSense:RemoveTripwire(rope)
    local index = (istable(rope) and self:GetTripwireIndex(rope) or rope)
    if (!index) then return end

    local wire = self.tripwires[index]
    if (!wire) then return end

    if (IsValid(wire.rope)) then
        wire.rope:Remove()
    end

    table.remove(self.tripwires, index)

    self:ReorderTripwires()
end
