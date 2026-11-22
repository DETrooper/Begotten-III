local PLUGIN = PLUGIN

function PLUGIN:OnEntityCreated(ent)
    timer.Simple(2.5, function()
        if not IsValid(ent) then return end
        local class = ent:GetClass()
        if class == "prop_ragdoll" then
            local ragPlayer = (Clockwork and Clockwork.entity and Clockwork.entity:GetPlayer(ent));
            if ent.cwIsBeingHeld or IsValid(ent.cwHoldingGrab) or ent:IsPlayerHolding() or (IsValid(ragPlayer) and ragPlayer:GetNetVar("IsDragged")) then return end
            local count = ent:GetPhysicsObjectCount()
            if count and count > 0 then
                local allStationary = true
                for i = 0, count - 1 do
                    local phys = ent:GetPhysicsObjectNum(i)
                    if IsValid(phys) and phys:IsMoveable() and not phys:IsAsleep() then
                        if phys:GetVelocity():LengthSqr() >= 16 or phys:GetAngleVelocity():LengthSqr() >= 16 then
                            allStationary = false
                            break
                        end
                    end
                end

                if allStationary then
                    for i = 0, count - 1 do
                        local phys = ent:GetPhysicsObjectNum(i)
                        if IsValid(phys) and phys:IsMoveable() and not phys:IsAsleep() then
                            phys:Sleep()
                        end
                    end
                end
            end
        elseif class == "cw_item" or class == "prop_physics" then
            if ent.cwIsBeingHeld or IsValid(ent.cwHoldingGrab) or ent:IsPlayerHolding() then return end
            local count = ent:GetPhysicsObjectCount()
            if count and count > 0 then
                for i = 0, count - 1 do
                    local phys = ent:GetPhysicsObjectNum(i)
                    if IsValid(phys) and phys:IsMoveable() and not phys:IsAsleep() then
                        if phys:GetVelocity():LengthSqr() < 16 and phys:GetAngleVelocity():LengthSqr() < 16 then
                            phys:Sleep()
                        end
                    end
                end
            end
        end
    end)
end
