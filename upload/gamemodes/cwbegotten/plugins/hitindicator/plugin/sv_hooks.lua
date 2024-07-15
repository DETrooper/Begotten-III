function cwHitIndicator:EntityTakeDamage(entity, damageInfo)
    if(!IsValid(entity) or (!entity:IsPlayer() and !entity:IsNPC() and !entity:IsNextBot())) then return; end
    
    local attacker = damageInfo:GetAttacker();
    if(!IsValid(attacker) or !attacker:IsPlayer()) then return; end

    local inflictor = damageInfo:GetInflictor();
    if(!IsValid(inflictor) or (!inflictor.isJavelin and (!inflictor:IsWeapon() or inflictor.Base != "begotten_firearm_base"))) then print("asdasd") return; end

    attacker:ReadSound("begotten/sfx/shot_"..math.random(1,5)..".wav", _, _, _, "cwHitIndicator");

end

local playerMeta = FindMetaTable("Player");

util.AddNetworkString("cwReadSound");

function playerMeta:ReadSound(snd, level, pitch, volume, conVar)
	net.Start("cwReadSound");
		net.WriteString(snd or "");
		net.WriteUInt(level or 75, 8);
		net.WriteUInt(pitch or 100, 16);
		net.WriteUInt(volume or 1, 8);
        net.WriteString(conVar or "");
	net.Send(self);

end