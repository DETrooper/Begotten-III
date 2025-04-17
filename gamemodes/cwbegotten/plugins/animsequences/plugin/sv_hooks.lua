util.AddNetworkString("bgRequestBoneData")

function cwAnimSequences:FinishSequence(player, callback, dontRespawn, weaponToSwitchTo)
    player:SetNWBool("bgAnimThirdPerson", false)
    player:SetNWString("bgAnimSequence", "")
    player:SetNWAngle("bgAnimAngle", angle_zero)

    if(player.disableGod) then player:GodDisable() end
    if(player:GetMoveType() != MOVETYPE_NOCLIP) then player:SetMoveType(MOVETYPE_WALK) end

    hook.Run("PlayerLoadout", player)

    if(weaponToSwitchTo) then
        local weapon = player:GetWeapon(weaponToSwitchTo)
        if(IsValid(weapon)) then player:SelectWeapon(weapon) end

    end

    if(callback) then callback(player) end

end

local playerMeta = FindMetaTable("Player")

function playerMeta:AbortAnimSequence()
    cwAnimSequences:FinishSequence(self)

end

function playerMeta:SetAnimSequence(sequenceName, callback, time, god, dontStrip, dontForceThirdPerson, dontFreeze, customAngles)
    local sequence = self:LookupSequence(sequenceName)
    local entIndex = self:EntIndex()

    local currentWeapon = self:GetActiveWeapon()
    local weaponClass = (IsValid(currentWeapon) and currentWeapon:GetClass() or nil)

    self:SetNWString("bgAnimSequence", sequenceName)
    if(!dontStrip) then self:StripWeapons() end
    if(!dontForceThirdPerson) then self:SetNWBool("bgAnimThirdPerson", true) end

    if(god and !self:IsInGodMode()) then
        self:GodEnable()
        self.disableGod = true
    
    end

    if(!dontFreeze) then
        self:SetMoveType(MOVETYPE_NONE)
        self:SetNWAngle("bgAnimAngle", customAngles or self:GetAngles())
    
    end

    self:SetForcedAnimation(sequenceName, (time or self:SequenceDuration(sequence)), _, function()
        cwAnimSequences:FinishSequence(self, callback, dontStrip, weaponClass)
    
    end)

end