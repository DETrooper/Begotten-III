function cwAnimSequences:ShouldForceThirdPerson(player)
    if(player:GetNWBool("bgAnimThirdPerson")) then return true end

end

function cwAnimSequences:ModifyThirdPersonFilter(player, filter)
    local ent = player:GetNWEntity("bgAnimFilter")
    if(IsValid(ent)) then table.insert(filter, ent) end

end