PLUGIN:SetGlobalAlias("cwToggleThrall");

function cwToggleThrall:PlayerCharacterLoaded(player)
    player:SetSharedVar("isThrall", player:GetCharacterData("isThrall", false));

end

function cwToggleThrall:PreEntityTakeDamage(entity, damageInfo)
    local attacker = damageInfo:GetAttacker();

    if(!IsValid(attacker) or !attacker:IsPlayer()) then return; end
    if(!IsValid(entity) or !entity:IsPlayer() or !string.find(entity:GetModel(), "_gorecap")) then return; end

    local ragdollEntity = entity:GetRagdollEntity();
	if (!IsValid(ragdollEntity) or Clockwork.kernel:GetRagdollHitGroup(ragdollEntity, damageInfo:GetDamagePosition()) != HITGROUP_HEAD)
	and Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition()) != HITGROUP_HEAD then return; end

    // How are you gonna hit someone in the head if they don't have a head?
    return true;

end