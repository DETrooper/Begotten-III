function cwTransmit:RecursiveSetPreventTransmit(ent, ply, stopTransmitting)
    if ent == ply or !IsValid(ent) or !IsValid(ply) then return; end

    ent:SetPreventTransmit(ply, stopTransmitting);

    local tab = ent:GetChildren();

    for i = 1, #tab do
        if !IsValid(tab[i]) then continue; end

        self:RecursiveSetPreventTransmit(tab[ i ], ply, stopTransmitting);
    end
end

function cwTransmit:DisableNetworking(client, disable)
    local plys = 0
	
    for _, v in pairs(player.GetAll()) do
        if v:IsAdmin() or v == client or !IsValid(v) then continue; end

        self:RecursiveSetPreventTransmit(client, v, disable);

        plys = plys + 1;
    end
end

function cwTransmit:PreMakePlayerEnterObserverMode(player)
	if player:IsAdmin() then
		self:DisableNetworking(player, true);
	end
end

function cwTransmit:PreMakePlayerExitObserverMode(player)
    self:DisableNetworking(player, false);
end

function cwTransmit:PlayerCharacterLoaded(player)
    if (player:IsAdmin()) then return; end

    for _, v in pairs(_player.GetAll()) do
        if(v == player or !v:IsAdmin() or v:GetMoveType() != MOVETYPE_NOCLIP) then continue; end
		
        self:RecursiveSetPreventTransmit(v, player, true);
    end
end