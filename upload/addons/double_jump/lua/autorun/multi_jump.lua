game.AddParticles("particles/advisor.pcf");
game.AddParticles("particles/grub_blood.pcf");

PrecacheParticleSystem("advisor_plat_break");
PrecacheParticleSystem("GrubBlood");

--[[local function GetMoveVector(mv)
	local ang = mv:GetAngles()

	local max_speed = mv:GetMaxSpeed()

	local forward = math.Clamp(mv:GetForwardSpeed(), -max_speed, max_speed)
	local side = math.Clamp(mv:GetSideSpeed(), -max_speed, max_speed)

	local abs_xy_move = math.abs(forward) + math.abs(side)

	if abs_xy_move == 0 then
		return Vector(0, 0, 0)
	end

	local mul = max_speed / abs_xy_move

	local vec = Vector()

	vec:Add(ang:Forward() * forward)
	vec:Add(ang:Right() * side)

	vec:Mul(mul)

	return vec
end]]--

hook.Add("SetupMove", "Multi Jump", function(ply, mv)
	-- Let the engine handle movement from the ground
	if ply:OnGround() then
		ply:SetJumpLevel(0)

		return
	end	

	-- Don't do anything if not jumping
	if not mv:KeyPressed(IN_JUMP) then
		return
	end

	if (ply.IsRagdolled and ply:IsRagdolled()) or ply:GetMoveType() ~= MOVETYPE_WALK or ply:GetNWBool("bliz_frozen") or Clockwork.player:GetAction(ply) ~= "" then
		return;
	end
	
	ply:SetJumpLevel(ply:GetJumpLevel() + 1)

	if ply:GetJumpLevel() > ply:GetMaxJumpLevel() then
		return
	end

	local vel = mv:GetVelocity();

	mv:SetVelocity(Vector(vel.x, vel.y, ply:GetJumpPower() * 3));

	ply:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP , -1)
	
	local curTime = CurTime();
	
	if !ply.jumpSoundPlayed or ply.jumpSoundPlayed < curTime then
		if (!ply.GetCharmEquipped or !ply:GetCharmEquipped("urn_silence")) then
			ply:EmitSound("begotten/ambient/corpse/body_drop2.wav", 60, math.random(85, 105));
		
			ply.jumpSoundPlayed = curTime + 0.25;
		end
	end
	
	if ply.bloodWingsActive then
		ply:ModifyBloodLevel(-15);

		ParticleEffect("GrubSquashBlood2", ply:GetPos() + Vector(0, 0, 10), ply:GetAngles());
	else
		if ply.HandleNeed then
			ply:HandleNeed("sleep", 2);
		end
	
		ParticleEffect("advisor_plat_break", ply:GetPos() + Vector(0, 0, 10), ply:GetAngles());
	end
end)

local playerMeta = FindMetaTable("Player")

function playerMeta:GetJumpLevel()
	return self:GetDTInt(23)
end

function playerMeta:SetJumpLevel(level)
	self:SetDTInt(23, level)
end

function playerMeta:GetMaxJumpLevel(level)
	if self.bloodWingsActive or self:GetModel() == "models/begotten/wanderers/voltist_heavy.mdl" then
		return self:GetDTInt(24)
	else
		return 0;
	end
end

function playerMeta:SetMaxJumpLevel(level)
	self:SetDTInt(24, level)
end

function playerMeta:GetExtraJumpPower()
	return self:GetDTFloat(25)
end

function playerMeta:SetExtraJumpPower(power)
	self:SetDTFloat(25, power)
end