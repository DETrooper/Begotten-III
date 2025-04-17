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

    --[[cmd:RemoveKey(IN_FORWARD)
    cmd:RemoveKey(IN_BACK)
    cmd:RemoveKey(IN_MOVELEFT)
    cmd:RemoveKey(IN_MOVERIGHT)
    cmd:RemoveKey(IN_JUMP)
    cmd:RemoveKey(IN_DUCK)
    cmd:RemoveKey(IN_ATTACK)
    cmd:RemoveKey(IN_ATTACK2)
    cmd:RemoveKey(IN_RELOAD)]]

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
	if(angle and !angle:IsZero()) then player:SetRenderAngles(angle) end

end

function cwAnimSequences:ModifyPlayerPlaybackRate(player, plyTab)
    if(#player:GetAnimSequence() > 0) then plyTab.cwPlaybackRate = 1 end

end