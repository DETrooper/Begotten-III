local ITEM = Clockwork.item:New()
ITEM.name = "Tripwire"
ITEM.description = "A thin coiled strip of wire, able to be attached to surfaces by both ends. Sprinting into a tripwire will cause the victim to fall over, while walking into one will slow them down."
ITEM.uniqueID = "tripwire"
ITEM.model = "models/begotten/misc/rope.mdl"
ITEM.weight = 0.4
ITEM.iconoverride = "begotten/ui/itemicons/tripwire.png"
ITEM.category = "Tools"
ITEM.requiredbeliefs = {"mechanic", "bestial"}

function ITEM:OnUse(player)
    local data = {}
    data.start = player:EyePos()
    data.endpos = (data.start + player:GetAimVector() * 96)
    data.filter = player

    local tr = util.TraceLine(data)

    if (!tr.Hit) then Schema:EasyText(player, "peru", "You cannot lay tripwire on nothing!") return false end
    if (IsValid(tr.Entity) and !tr.Entity:IsWorld()) then Schema:EasyText(player, "peru", "You can only lay tripwire on terrain!") return false end
    if (!cwPrimevalismSense:ValidateYSpace(tr.HitPos, tr.HitNormal)) then Schema:EasyText(player, "peru", "You cannot lay tripewire this close to the ground!") return false end

    player.tripWiring = {pos = tr.HitPos, normal = tr.HitNormal}

    net.Start("cwStartTripwire")
        net.WriteTable(player.tripWiring)
    net.Send(player)
end

function ITEM:OnEntitySpawned(ent)
    ent:SetMaterial("models/props_c17/paper01")
end

function ITEM:OnDrop(player, position) end

ITEM:Register()