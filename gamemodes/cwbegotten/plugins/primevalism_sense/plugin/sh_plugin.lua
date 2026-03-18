PLUGIN:SetGlobalAlias("cwPrimevalismSense")

Clockwork.kernel:IncludePrefixed("sh_tripwire.lua")

Clockwork.kernel:IncludePrefixed("cl_tripwire.lua")
Clockwork.kernel:IncludePrefixed("cl_hooks.lua")
Clockwork.kernel:IncludePrefixed("sv_tripwire.lua")
Clockwork.kernel:IncludePrefixed("sv_hooks.lua")

function cwPrimevalismSense:GetWarcrySound()
    return string.format("warcries/primevalist%.2i.mp3", math.random(1, 2))
end