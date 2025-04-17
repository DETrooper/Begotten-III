PLUGIN:SetGlobalAlias("cwAnimSequences")

Clockwork.kernel:IncludePrefixed("cl_hooks.lua")
Clockwork.kernel:IncludePrefixed("sv_hooks.lua")

local playerMeta = FindMetaTable("Player")

function playerMeta:GetAnimSequence()
    return self:GetNWString("bgAnimSequence", "")

end

function cwAnimSequences:StartCommand(player, cmd)
    local sequence = player:GetAnimSequence()
    if(#sequence <= 0) then return end

    cmd:ClearMovement()
    cmd:RemoveKey(IN_ATTACK)
    cmd:RemoveKey(IN_ATTACK2)
    cmd:RemoveKey(IN_RELOAD)

end

function cwAnimSequences:SetupMove(player, move)
    local sequence = player:GetAnimSequence()
    if(#sequence <= 0) then return end

end

function cwAnimSequences:BegottenPlayerCanUseBind(player, button)
    if(#player:GetAnimSequence() > 0) then return false end

end

function cwAnimSequences:UpdateAnimation(player)
	local angle = player:GetNWAngle("bgAnimAngle", nil)
	if(angle) then player:SetRenderAngles(angle) end
end