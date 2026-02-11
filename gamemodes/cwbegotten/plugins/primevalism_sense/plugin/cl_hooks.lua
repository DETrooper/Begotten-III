cwPrimevalismSense.echolocations = (cwPrimevalismSense.echolocations or {})
cwPrimevalismSense.echolocationInfo = (cwPrimevalismSense.echolocationInfo or {
    startTime = 0,
    hasPreppedEnd = false,
})

local echolocationTime = 10
local echolocationEndTime = 0.7
local echolocationPrepEndTime = (echolocationTime - echolocationEndTime)

local echoOverlay = Material("effects/tp_eyefx/tpeye")
echoOverlay:SetVector("$color", Vector(0.1, 0, 0))

local echoMat = CreateMaterial("cwEcholocation", "UnlitGeneric", {
    ["$basetexture"] = "color/white",
    ["$ignorez"] = "1",
})

local echoColor = Color(94, 14, 14)
local echoMod = Color(echoColor.r / 255, echoColor.g / 255, echoColor.b / 255)

local colorModify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.3,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 0.3,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

net.Receive("cwEcholocate", function()
    local info = net.ReadTable()

    local ent = ClientsideModel(info.models[1])
    ent:SetPos(info.pos)
    ent:SetAngles(info.ang)
    ent:ResetSequence(info.anim)
    ent:SetCycle(info.cycle)
    ent:SetNoDraw(true)
    ent:SetPlaybackRate(0)

    local echolocation = {
        index = (#cwPrimevalismSense.echolocations + 1),
        entities = {ent},
        info = info,
    }

    if (#info.models > 1) then
        for i, v in ipairs(info.models) do
            if (i == 1) then continue end

            local curEnt = ClientsideModel(v)
            curEnt:SetPos(info.pos)
            curEnt:SetAngles(info.ang)
            curEnt:ResetSequence(info.anim)
            curEnt:SetCycle(info.cycle)
            curEnt:SetNoDraw(true)
            curEnt:SetPlaybackRate(0)

            curEnt:SetParent(ent)
			curEnt:AddEffects(EF_BONEMERGE)

            table.insert(echolocation.entities, curEnt)
        end
    end

    table.insert(cwPrimevalismSense.echolocations, echolocation)
end)

net.Receive("cwEcholocatePing", function()
    cwPrimevalismSense.echolocationInfo.startTime = CurTime()
    cwPrimevalismSense.echolocationInfo.hasPreppedEnd = false

    cwPrimevalismSense.echolocationInfo.sound = CreateSound(Clockwork.Client, "misc/st_seventhday_03.wav")
    cwPrimevalismSense.echolocationInfo.sound:PlayEx(0, 70)
    cwPrimevalismSense.echolocationInfo.sound:ChangeVolume(0.3, 1)

    Clockwork.Client:ScreenFade(SCREENFADE.IN, color_black, echolocationEndTime, 0)
end)

function cwPrimevalismSense:OnEcholocationEnd()
    for _, v in ipairs(self.echolocations) do
        for _, vv in ipairs(v.entities) do
            vv:Remove()
        end
    end

    self.echolocations = {}

    self.echolocationInfo.sound:FadeOut(1)

    Clockwork.Client:ScreenFade(SCREENFADE.IN, color_black, echolocationEndTime, 0)
end

function cwPrimevalismSense:PrepEcholocationEnd()
    Clockwork.Client:ScreenFade(SCREENFADE.OUT, color_black, echolocationEndTime, 0)
end

function cwPrimevalismSense:DoScreenspaceEffects()
    local curTime = CurTime()

    if ((curTime - self.echolocationInfo.startTime) > echolocationTime) then
        if (self.echolocationInfo.startTime != 0) then
            hook.Run("OnEcholocationEnd")

            self.echolocationInfo.startTime = 0
        end

        return
    end

    if (!self.echolocationInfo.hasPreppedEnd and (curTime - self.echolocationInfo.startTime) > echolocationPrepEndTime) then
        hook.Run("PrepEcholocationEnd")

        self.echolocationInfo.hasPreppedEnd = true
    end

    DrawColorModify(colorModify)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(echoOverlay)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

    local scrW, scrH = ScrW(), ScrH()

    for i, v in ipairs(self.echolocations) do
        local timeSince = (curTime - self.echolocationInfo.startTime)

        local pos = v.entities[1]:LocalToWorld(v.entities[1]:OBBCenter()):ToScreen()

        surface.SetDrawColor(ColorAlpha(echoColor, Lerp(timeSince/0.1, 0, TimedCos(0.5, 50, 100, 0))))

        for i = 1, 3 do
            surface.DrawOutlinedCircle(math.Clamp(pos.x, 0, scrW), math.Clamp(pos.y, 0, scrH), Lerp(math.max(timeSince - i * 0.1, 0)/echolocationTime, 0, 700), 2)
        end
    end

    local size = TimedCos(0.5, 4, 7, 0)
    DrawBloom(0.1, 100, size, size, 0.1, 0.5, 1.5, 2, 0)
end

function cwPrimevalismSense:ShouldntDrawFogPlane()
    if ((CurTime() - self.echolocationInfo.startTime) <= echolocationTime) then return true end
end

function cwPrimevalismSense:PreDrawViewModels()
    if ((CurTime() - self.echolocationInfo.startTime) <= echolocationTime) then return end

    cam.Start2D()
        self:DoScreenspaceEffects()
    cam.End2D()

    cam.Start3D(_, _, _, _, _, _, _, 1, 666666666)
        render.MaterialOverride(echoMat)
        render.SuppressEngineLighting(true)
        render.SetColorModulation(echoMod.r, echoMod.g, echoMod.b)

        cam.IgnoreZ(true)

        local fogMode = render.GetFogMode()
        render.FogMode(MATERIAL_FOG_NONE)

        local fogStart, fogEnd = render.GetFogDistances()
        render.FogStart(666666666)
        render.FogEnd(666666666)

        for i, v in ipairs(self.echolocations) do
            for ii, vv in ipairs(v.entities) do
                vv:DrawModel()
            end
        end

        render.MaterialOverride()
        render.SuppressEngineLighting(false)
        render.FogMode(fogMode)
        render.FogStart(fogStart)
        render.FogEnd(fogEnd)

        cam.IgnoreZ(false)
    cam.End3D()
end

function cwPrimevalismSense:PlayerDrawWeaponSelect()
    if ((CurTime() - self.echolocationInfo.startTime) <= echolocationTime) then return false end
end

function cwPrimevalismSense:Think()
    self:UpdateRope()
end

function cwPrimevalismSense:SetupMove(player, move, cmd)
    if (!IsFirstTimePredicted()) then return end

    self:PollRope(player, move)
end

function cwPrimevalismSense:HUDPaint()
    self:DrawRopeHUD()
end

function cwPrimevalismSense:GetProgressBarInfoAction(action, percentage)
	if (action == "tripwiring") then
		return {text = "You are laying down tripwire. Click to cancel.", percentage = percentage, flash = percentage < 0}
	end
end