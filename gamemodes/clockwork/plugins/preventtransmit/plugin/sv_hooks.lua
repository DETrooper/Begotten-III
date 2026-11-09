cwTransmit.cullDistanceSqr = 9000000;
cwTransmit.cullClasses = {
    ["cw_item"] = true,
    ["cw_belongings"] = true,
    ["cw_paper"] = true,
};

cwTransmit.TrackedEntities = cwTransmit.TrackedEntities or {};

function cwTransmit:OnEntityCreated(ent)
    timer.Simple(0.1, function()
        if IsValid(ent) and self.cullClasses[ent:GetClass()] then
            self.TrackedEntities[ent] = true
        end
    end)
end

function cwTransmit:EntityRemoved(ent)
    self.TrackedEntities[ent] = nil
end

function cwTransmit:RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent == ply or not IsValid(ent) or not IsValid(ply) then return end
    ent:SetPreventTransmit(ply, stopTransmitting)
    local tab = ent:GetChildren()
    for i = 1, #tab do
        if IsValid(tab[i]) then
            self:RecursiveSetPreventTransmit(tab[i], ply, stopTransmitting)
        end
    end
end

function cwTransmit:DisableNetworking(client, disable)
    for _, v in ipairs(player.GetAll()) do
        if v:IsAdmin() or v == client or not IsValid(v) then continue end
        self:RecursiveSetPreventTransmit(client, v, disable)
    end
end

function cwTransmit:PreMakePlayerEnterObserverMode(player)
    if player:IsAdmin() and not Clockwork.player:HasFlags(player, "i") then
        self:DisableNetworking(player, true)
    end
end

function cwTransmit:PreMakePlayerExitObserverMode(player)
    self:DisableNetworking(player, false)
end

function cwTransmit:PlayerCharacterLoaded(player)
    if (player:IsAdmin()) then return; end

    for _, v in _player.Iterator() do
        if (v == player or not v:IsAdmin() or v:GetMoveType() ~= MOVETYPE_NOCLIP or Clockwork.player:HasFlags(v, "i")) then continue; end
        
        self:RecursiveSetPreventTransmit(v, player, true);
    end
end

function cwTransmit:PlayerDisconnected(ply)
    for ent, _ in pairs(self.TrackedEntities) do
        if IsValid(ent) and ent._cwPvsDormant then
            ent._cwPvsDormant[ply] = nil
        end
    end
end



-- Staggered spatial culler: 16 players per sub-tick, strict dirty checking
local nextPvsTick = 0
local pvsPlayerIndex = 1
local activeEnts = {}
local activePos = {}

hook.Add("Tick", "cwTransmit_SpatialCull", function()
    local curTime = CurTime()
    if curTime < nextPvsTick then return end
    nextPvsTick = curTime + 0.05 -- 20 Hz sub-tick check

    local players = player.GetAll()
    local numPlayers = #players
    if numPlayers == 0 then return end

    -- Pre-collect valid entities and their positions ONCE per 0.05s step (reused buffer)
    local entCount = 0
    for ent, _ in pairs(cwTransmit.TrackedEntities) do
        if IsValid(ent) then
            entCount = entCount + 1
            activeEnts[entCount] = ent
            activePos[entCount] = ent:GetPos()
        else
            cwTransmit.TrackedEntities[ent] = nil
        end
    end
    if entCount == 0 then return end

    local cullDist = cwTransmit.cullDistanceSqr
    local batchSize = math.min(16, numPlayers)
    local cullBots = cwTransmit.cullBots or false

    -- Clean up stale array tail references
    for i = entCount + 1, #activeEnts do
        activeEnts[i] = nil
        activePos[i] = nil
    end

    for step = 1, batchSize do
        if pvsPlayerIndex > numPlayers then pvsPlayerIndex = 1 end
        local ply = players[pvsPlayerIndex]
        pvsPlayerIndex = pvsPlayerIndex + 1

        if IsValid(ply) and ply:Alive() and (not ply:IsBot() or cullBots) then
            local isAdminObserver = ply:IsAdmin() and (ply.cwObserverMode or ply:GetMoveType() == MOVETYPE_NOCLIP)
            local viewEnt = ply:GetViewEntity()
            local plyPos = (IsValid(viewEnt) and viewEnt:GetPos()) or ply:GetPos()
            if ply.IsRagdolled and ply:IsRagdolled() then
                local rag = ply:GetRagdollEntity()
                if IsValid(rag) then plyPos = rag:GetPos() end
            end

            for i = 1, entCount do
                local ent = activeEnts[i]
                local dormant = ent._cwPvsDormant
                if not dormant then
                    dormant = {}
                    ent._cwPvsDormant = dormant
                end

                local isFar = (not isAdminObserver) and (activePos[i]:DistToSqr(plyPos) > cullDist)
                if dormant[ply] ~= isFar then
                    dormant[ply] = isFar
                    cwTransmit:RecursiveSetPreventTransmit(ent, ply, isFar)
                end
            end
        end
    end
end)
