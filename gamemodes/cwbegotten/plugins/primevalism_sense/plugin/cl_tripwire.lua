cwPrimevalismSense.tripwireInfo = cwPrimevalismSense.tripwireInfo or {
    start = vector_origin,
    rope = NULL,
    ent1 = NULL,
    ent2 = NULL,
    overridePos = nil,
}

function cwPrimevalismSense:CleanupTripwire()
    if (IsValid(cwPrimevalismSense.tripwireInfo.ent1)) then
        cwPrimevalismSense.tripwireInfo.ent1:Remove()
    end

    if (IsValid(cwPrimevalismSense.tripwireInfo.ent2)) then
        cwPrimevalismSense.tripwireInfo.ent2:Remove()
    end

    if (IsValid(cwPrimevalismSense.tripwireInfo.rope)) then
        cwPrimevalismSense.tripwireInfo.rope:Remove()
    end

    cwPrimevalismSense.tripwireInfo = {}
end

function cwPrimevalismSense:TripwireConfirmed(pos)
    cwPrimevalismSense.tripwireInfo.overridePos = pos
end

local validColor = Color(70, 255, 70)
local invalidColor = Color(200, 0, 0)

function cwPrimevalismSense:ClientModifyTripwirePos(pos)
    if (cwPrimevalismSense.tripwireInfo.overridePos) then
        pos[1] = cwPrimevalismSense.tripwireInfo.overridePos
        pos[2] = true
    end
end

function cwPrimevalismSense:UpdateRope()
    local ent = cwPrimevalismSense.tripwireInfo.ent2
    if (!IsValid(ent)) then return end

    local data = {}
    data.start = Clockwork.Client:EyePos()
    data.endpos = (data.start + Clockwork.Client:GetAimVector() * 96)
    data.filter = Clockwork.Client

    local tr = util.TraceLine(data)

    local pos = {tr.HitPos, false}

    hook.Run("ClientModifyTripwirePos", pos)

    ent:SetPos(pos[1])

    local placementValid = (self:ValidateRope(Clockwork.Client, cwPrimevalismSense.tripwireInfo.ent1:GetPos(), cwPrimevalismSense.tripwireInfo.ent2:GetPos(), cwPrimevalismSense.tripwireInfo.ent1.startNormal) or pos[2])

    cwPrimevalismSense.tripwireInfo.rope:SetColor((placementValid and validColor or invalidColor))
end

function cwPrimevalismSense:PollRope(player, move)
    local ent = cwPrimevalismSense.tripwireInfo.ent2
    if (!IsValid(ent)) then return end

    if (move:KeyPressed(IN_RELOAD)) then
        net.Start("cwFinishTripwire")
            net.WriteVector(vector_origin)
        net.SendToServer()
    elseif (move:KeyPressed(IN_USE)) then
        net.Start("cwFinishTripwire")
            net.WriteVector(ent:GetPos())
        net.SendToServer()
    end
end

function cwPrimevalismSense:DrawRopeHUD()
    local ent = cwPrimevalismSense.tripwireInfo.ent2
    if (!IsValid(ent)) then return end

    draw.SimpleTextOutlined("E - Confirm", "Subtitle_Talk", ScrW() / 2, ScrH() / 1.2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
    draw.SimpleTextOutlined("R - Cancel", "Subtitle_Talk", ScrW() / 2, ScrH() / 1.16, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
end

net.Receive("cwStartTripwire", function()
    local world = game.GetWorld()
    local info = net.ReadTable()

    cwPrimevalismSense:CleanupTripwire()

    local ent1 = ClientsideModel("models/hunter/blocks/cube025x025x025.mdl")
    ent1:SetNoDraw(true)
    ent1:SetPos(info.pos)
    ent1.startNormal = info.normal

    local ent2 = ClientsideModel("models/hunter/blocks/cube025x025x025.mdl")
    ent2:SetNoDraw(true)
    ent2:SetPos(info.pos)

    local rope = ents.CreateClientRope(ent1, 0, ent2, 0, {
        ["material"] = "cable/rope",
        ["width"] = 1,
        ["slack"] = 30,
    })

    cwPrimevalismSense.tripwireInfo.ent1 = ent1
    cwPrimevalismSense.tripwireInfo.ent2 = ent2
    cwPrimevalismSense.tripwireInfo.rope = rope

    cwPrimevalismSense:UpdateRope()
end)

net.Receive("cwConfirmTripwire", function()
    local pos = net.ReadVector()

    cwPrimevalismSense:TripwireConfirmed(pos)
end)

net.Receive("cwFinishTripwire", function()
    cwPrimevalismSense:CleanupTripwire()
end)