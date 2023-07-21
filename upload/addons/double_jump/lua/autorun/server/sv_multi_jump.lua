hook.Add("OnEntityCreated", "Multi Jump", function(ply)
	if ply:IsPlayer() then
		ply:SetJumpLevel(0)
		ply:SetMaxJumpLevel(1)
		ply:SetExtraJumpPower(1)
	end
end)
