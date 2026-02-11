local ITEM = Clockwork.item:New()
ITEM.name = "Tripwire"
ITEM.uniqueID = "tripwire"
ITEM.model = "models/begotten/misc/rope.mdl"
ITEM.weight = 0.4
ITEM.iconoverride = "begotten/ui/itemicons/tripwire.png"
ITEM.category = "Tools"
ITEM.requiredbeliefs = {"mechanic", "soothsayer"}

function ITEM:OnUse(player)
    local data = {}
    data.start = player:EyePos()
    data.endpos = (data.start + player:GetAimVector() * 96)
    data.filter = player

    local tr = util.TraceLine(data)

    if (!tr.Hit) then Schema:EasyText(player, "peru", "You cannot lay tripwire on nothing!") return false end
    if (!cwPrimevalismSense:ValidateYSpace(tr.HitPos)) then Schema:EasyText(player, "peru", "You cannot lay tripewire this close to the ground!") return false end

    player.tripWiring = tr.HitPos

    net.Start("cwStartTripwire")
        net.WriteVector(player.tripWiring)
    net.Send(player)

    return true
end

function ITEM:OnEntitySpawned(ent)
    ent:SetMaterial("models/props_c17/paper01")
end

function ITEM:OnDrop(player, position) end

ITEM:Register()