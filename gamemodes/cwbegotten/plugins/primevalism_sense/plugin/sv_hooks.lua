util.AddNetworkString("cwEcholocate")
util.AddNetworkString("cwEcholocatePing")

cwPrimevalismSense.lanternDeactivationTime = 10
cwPrimevalismSense.lanternDeactivationCooldown = 0

function cwPrimevalismSense:AddToEcholocationList(echolocationList, ent, player, zone)
    local curTime = CurTime()

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

        ent:ReadSound(self:GetWarcrySound(player, ent), 100, math.random(95, 105))

        local activeWeapon = ent:GetActiveWeapon()

        if ((!ent.nextLanternDeactivation or ent.nextLanternDeactivation < curTime) and (!IsValid(activeWeapon) or activeWeapon:GetClass() != "cw_lantern")) then
            ent.nextLanternDeactivation = (curTime + self.lanternDeactivationCooldown)
            ent.lanternDeactivationTime = (curTime + self.lanternDeactivationTime)
        end
    end

    table.insert(echolocationList, ent.echolocation)
end

local dot180Degrees = 0

local function IsEntityWithinDot(player, ent, dot)
    local normal = (ent:GetPos() - player:GetPos()):GetNormalized()

    return (player:GetForward():Dot(normal) > dot)
end

function cwPrimevalismSense:DoEcholocation(echolocationList, player, pos, zone, condition)
    for _, v in _player.Iterator() do
        if (!v:HasInitialized() or !v:Alive() or v.cwObserverMode or v == player) then continue end
        if (!condition(player, v, pos, zone)) then continue end

        self:AddToEcholocationList(echolocationList, v, player, v:GetCharacterData("LastZone"))
    end
end

local sonarRadius = (2048 * 2048)

function cwPrimevalismSense:StartEcholocation(player)
    local playerZone = player:GetCharacterData("LastZone")

    local echolocationList = {}

    self:DoEcholocation(echolocationList, player, player:GetPos(), playerZone, (playerZone == "caves" and function(player, target, pos, zone)
        return (target:GetCharacterData("LastZone") == zone and target:GetPos():DistToSqr(pos) <= sonarMineRadius)
    end or function(player, target, pos, zone)
        return (target:GetPos():DistToSqr(pos) <= sonarRadius)
    end))

    net.Start("cwEcholocatePing")
        net.WriteTable(echolocationList)
    net.Send(player)

    player:SelectWeapon("begotten_fists")
    player:SetWeaponRaised(false)
end

function cwPrimevalismSense:PlayerCanRaiseWeapon(player, weapon)
    if (weapon:GetClass() == "cw_lantern" and player.lanternDeactivationTime and player.lanternDeactivationTime > CurTime()) then return false end
end

function cwPrimevalismSense:Think()
    self:TripwireThink()
end

function cwPrimevalismSense:KeyPress(player, key)
    local action = Clockwork.player:GetAction(player)

	if ((key == IN_ATTACK and action == "tripwiring") or (key == IN_RELOAD and player.tripWiring)) then
		self:CancelTripwire(player)
	end

    if (key == IN_ATTACK and action == "cuttingTripwire") then
        Clockwork.player:SetAction(player, false)

        player:StopSound("begotten/layingtripwire.mp3")
    end

    if (key == IN_USE) then
        self:CheckPlayerDisarm(player)
    end
end

function cwPrimevalismSense:PlayerRagdolled(player, state, ragdoll)
	if (Clockwork.player:GetAction(player) == "tripwiring" or player.tripWiring) then
		self:CancelTripwire(player)
	end
end

function cwPrimevalismSense:ModifyPlayerSpeed(player, infoTable, action)
	if (action == "tripwiring" or action == "cuttingTripwire") then
		infoTable.runSpeed = infoTable.walkSpeed * 0.1
		infoTable.walkSpeed = infoTable.walkSpeed * 0.1
	end

    if (player.tripwireSlowdown and player.tripwireSlowdown > CurTime()) then
        infoTable.runSpeed = infoTable.walkSpeed * 0.65
        infoTable.walkSpeed = infoTable.walkSpeed * 0.65
    end
end