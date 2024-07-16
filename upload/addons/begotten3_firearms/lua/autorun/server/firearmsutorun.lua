hook.Add("KeyPress", "KeyPressFirearms", function(ply, key)
	if key == IN_RELOAD then
		local activeWeapon = ply:GetActiveWeapon();
		
		if IsValid(activeWeapon) and activeWeapon.Base == "begotten_firearm_base" then
			activeWeapon.ReloadKeyTime = CurTime();
		end
	end
end);

hook.Add("KeyRelease", "KeyReleaseFirearms", function(ply, key)
	if key == IN_RELOAD then
		local activeWeapon = ply:GetActiveWeapon();
		
		if IsValid(activeWeapon) and activeWeapon.Base == "begotten_firearm_base" then
			if activeWeapon.ReloadKeyTime and CurTime() - activeWeapon.ReloadKeyTime > 0.15 then
				local action = Clockwork.player:GetAction(ply);
				
				if (action == "reloading") then
					Schema:EasyText(ply, "peru", "Your character is already reloading!");
					
					return;
				end
					
				netstream.Start(ply, "ReloadMenu", true);
				
				timer.Simple(0.5, function()
					if IsValid(activeWeapon) then
						activeWeapon.ReloadKeyTime = nil;
					end
				end);
			elseif IsFirstTimePredicted() then
				activeWeapon.ReloadKeyTime = nil;
			end
		end
	end
end);