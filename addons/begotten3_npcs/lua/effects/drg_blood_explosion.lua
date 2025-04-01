function EFFECT:Init(data)
	local ent = data:GetEntity()
	if not IsValid(ent) then return end
	local color = data:GetFlags()
	for i = 0, (ent:GetBoneCount()-1) do
		if ent:GetBoneName(i) == "__INVALIDBONE__" then continue end
		local pos, angles = ent:GetBonePosition(i)
		if color == BLOOD_COLOR_RED then
			ParticleEffect("blood_impact_red_01_goop", pos, angles, ent)
		elseif color == BLOOD_COLOR_YELLOW then
			ParticleEffect("blood_impact_yellow_01", pos, angles, ent)
		elseif color == BLOOD_COLOR_GREEN then
			ParticleEffect("blood_impact_green_01", pos, angles, ent)
		elseif color == BLOOD_COLOR_ANTLION then
			ParticleEffect("blood_impact_antlion_01", pos, angles, ent)
		elseif color == BLOOD_COLOR_ZOMBIE then
			ParticleEffect("blood_impact_zombie_01", pos, angles, ent)
		elseif color == BLOOD_COLOR_ANTLION_WORKER then
			ParticleEffect("blood_impact_antlion_worker_01", pos, angles, ent)
		end
	end
end

function EFFECT:Think() return false end
function EFFECT:Render() end
