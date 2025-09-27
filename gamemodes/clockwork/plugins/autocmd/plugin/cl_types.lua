local PLUGIN = PLUGIN


PLUGIN:RegisterArgumentType("Player", function(argument)
    local matches = {}

    for _, ply in _player.Iterator() do
        if string.find(string.lower(ply:Nick()), string.lower(argument), 1, true) then
            table.insert(matches, ply:Nick())
        end
    end

    return matches
end)

PLUGIN:RegisterArgumentType("Weather", function(argument)
    local matches = {}

    for weather, _ in pairs(cwWeather.weatherTypes) do
        if string.find(string.lower(weather), string.lower(argument), 1, true) then
            table.insert(matches, weather)
        end
    end

    return matches

end)

PLUGIN:RegisterArgumentType("Rank", function(argument, args)
    if !args or !args[1] then return {} end

    local plystr = args[1]

    local target = Clockwork.player:FindByID(plystr)

    local ranks = {}


    if target then
        local targetFaction = target:GetNetVar("kinisgerOverride", target:GetFaction());
        ranks = Schema.Ranks[targetFaction] or {}
    end

    local matches = {}

    for k, v in pairs(ranks) do
        if string.find(string.lower(v), string.lower(argument), 1, true) then
            table.insert(matches, v)
        end
    end

    return matches

end)

Clockwork.command:RegisterType("Radius", function(argument, args)
    return {}
end, function(current_arg, args)
    render.SetColorMaterial()
    local pos = LocalPlayer():GetEyeTrace().HitPos
    local radius = tonumber(current_arg)

    if radius then
        render.DrawSphere(pos, radius, 15, 15, Color(0, 175, 175, 20))

        render.DrawWireframeSphere(pos, radius, 15, 15, Color(255, 255, 255, 100))

        for _, player in pairs(ents.FindInSphere(pos, radius)) do
            if IsValid(player) and player:IsPlayer() and player:Alive() then
                local headBone = player:LookupBone("ValveBiped.Bip01_Head1")

                if headBone then
                    local headPos = player:GetBonePosition(headBone)
                    if headPos then
                        render.DrawWireframeSphere(headPos, 8, 6, 6, Color(0, 255, 0))
                    end
                end
            end
        end
    end
end)

local seek = {
    ["ply"] = "Player",
    ["char"] = "Player"
}

local cmdblacklist = {
    ["charfallover"] = true,
    ["charcancelgetup"] = true,
    ["charphysdesc"] = true,
}


function PLUGIN:ClockworkSchemaLoaded()
    for k, v in pairs(Clockwork.command:GetAll()) do
        for k2, v2 in pairs(seek) do
            if k:lower():find(k2) and !cmdblacklist[k:lower()] and !v.types then
                v.types = {}
                v.types[1] = v2
            end
        end
    end
end