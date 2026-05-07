PLUGIN:SetGlobalAlias("cwPrimevalismSense")

Clockwork.kernel:IncludePrefixed("sh_tripwire.lua")

Clockwork.kernel:IncludePrefixed("cl_tripwire.lua")
Clockwork.kernel:IncludePrefixed("cl_hooks.lua")
Clockwork.kernel:IncludePrefixed("sv_tripwire.lua")
Clockwork.kernel:IncludePrefixed("sv_hooks.lua")

local farCryDist = (600 * 600)

function cwPrimevalismSense:GetWarcrySound(player, ent)
    if (IsValid(ent) and player:GetPos():DistToSqr(ent:GetPos()) > farCryDist) then
        return string.format("warcries/primevalist%.2i.mp3", math.random(1, 2))
    else
        return string.format("warcries/volatile_alarming_%.2i_0.mp3", math.random(0, 2))
    end
end