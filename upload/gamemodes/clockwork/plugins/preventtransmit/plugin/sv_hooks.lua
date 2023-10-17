function cwTransmit:RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent != ply and IsValid(ent) and IsValid(ply) then
        ent:SetPreventTransmit(ply, stopTransmitting)

        local tab = ent:GetChildren()

        for i = 1, #tab do
            if IsValid(tab[i]) then
                RecursiveSetPreventTransmit(tab[i], ply, stopTransmitting);
            end
        end
    end
end

function cwTransmit:DisableNetworking(client, disable)
    local plys = 0

    for _, v in ipairs(player.GetAll()) do
        if v:IsAdmin() or v == client or !IsValid(v) then continue end

        RecursiveSetPreventTransmit(client, v, disable)

        plys = plys + 1
    end
end

function cwTransmit:PreMakePlayerEnterObserverMode(player)
    self:DisableNetworking(player, true);
end

function cwTransmit:PreMakePlayerExitObserverMode(player)
    self:DisableNetworking(player, false);
end

function cwTransmit:PlayerInitialSpawn(player)
    if (player:IsAdmin()) then return; end

    for _, v in ipairs(_player.GetAll()) do
        if (!v:IsAdmin() or v:GetMoveType() != MOVETYPE_NOCLIP) then continue; end

        self:RecursiveSetPreventTransmit(v, player, true);
    end
end