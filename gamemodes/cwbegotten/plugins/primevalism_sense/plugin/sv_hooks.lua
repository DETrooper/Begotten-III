util.AddNetworkString("cwEcholocate")
util.AddNetworkString("cwEcholocatePing")

cwPrimevalismSense.lanternDeactivationTime = 10

function cwPrimevalismSense:Echolocate(ent, player, zone)
    ent.echolocation = {
        pos = ent:GetPos(),
        ang = ent:GetAngles(),
        anim = ent:GetSequence(),
        cycle = ent:GetCycle(),
        models = {ent:GetModel()},
    }

    if (ent:IsPlayer()) then
        local clothesModel = ent:GetClothesModel()
        if (clothesModel) then
            table.insert(ent.echolocation.models, clothesModel)
        end

        if (zone == "caves") then
            ent:ReadSound(self:GetWarcrySound(), 100, math.random(95, 105))
        end

        ent.lanternDeactivationTime = (CurTime() + self.lanternDeactivationTime)
    end

    net.Start("cwEcholocate")
        net.WriteTable(ent.echolocation)
    net.Send(player)
end

function cwPrimevalismSense:DoEcholocation(player, pos, zone, condition)
    for _, v in _player.Iterator() do
        if (!v:HasInitialized() or !v:Alive() or v.cwObserverMode or v == player) then continue end
        if (!condition(player, v, pos, zone)) then continue end

        self:Echolocate(v, player, v:GetCharacterData("LastZone"))
    end
end

local sonarRadius = (8192 * 8192)

function cwPrimevalismSense:StartEcholocation(player)
    local playerZone = player:GetCharacterData("LastZone")

    self:DoEcholocation(player, player:GetPos(), playerZone, (playerZone == "caves" and function(player, target, pos, zone)
        return (target:GetCharacterData("LastZone") == zone)
    end or function(player, target, pos, zone)
        return (target:GetPos():DistToSqr(pos) <= sonarRadius)
    end))

    net.Start("cwEcholocatePing")
    net.Send(player)

    player:SelectWeapon("begotten_fists")
    player:SetWeaponRaised(false)
end

function cwPrimevalismSense:PlayerCanRaiseWeapon(player, weapon)
    if (weapon:GetClass:GetClass() == "cw_lantern" and player.lanternDeactivationTime > CurTime()) then return false end
end

function cwPrimevalismSense:Think()
    self:TripwireThink()
end

function cwPrimevalismSense:KeyPress(player, key)
	if ((key == IN_ATTACK and Clockwork.player:GetAction(player) == "tripwiring") or key == IN_RELOAD and player.tripWiring) then
		self:CancelTripwire(player)
	end

    if (key == IN_USE) then
        self:CheckPlayerDisarm(player)
    end
end

function cwPrimevalismSense:PlayerRagdolled(player, state, ragdoll)
	if (Clockwork.player:GetAction(player) == "tripwiring" or and player.tripWiring) then
		self:CancelTripwire(player)
	end
end

function cwPrimevalismSense:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "tripwiring") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1
	end
end