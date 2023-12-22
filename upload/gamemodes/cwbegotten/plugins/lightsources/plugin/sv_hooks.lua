--[[
	Begotten III: Jesus Wept
--]]

-- Called at an interval while a player is connected.
function cwLantern:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	local activeWeapon = player:GetActiveWeapon();

	if (IsValid(activeWeapon) and activeWeapon:GetClass() == "cw_lantern") then
		local weaponItemTable = item.GetByWeapon(activeWeapon);
		
		if weaponItemTable then
			local currentOil = weaponItemTable:GetData("oil");
			
			if (tonumber(currentOil) > 0) then
				local bWeaponRaised = Clockwork.player:GetWeaponRaised(player);

				if (bWeaponRaised) then
					if (!plyTab.lanternSound) then
						player:EmitSound("lantern/lantern_on.wav", 60, math.random(95, 105));
						plyTab.lanternSound = true;
					end;
					
					if (!plyTab.nextOilDrop or curTime > plyTab.nextOilDrop) then
						weaponItemTable:SetData("oil", math.Clamp(currentOil - 1, 0, 100));
						player:SetSharedVar("oil", math.Round(weaponItemTable:GetData("oil"), 0));

						plyTab.nextOilDrop = curTime + 30;
					end;
				else
					if (plyTab.lanternSound) then
						player:EmitSound("lantern/lantern_off.wav", 60, math.random(95, 105));
						plyTab.lanternSound = false;
					end;
				end;
				
				if !player:GetSharedVar("oil") then
					player:SetSharedVar("oil", math.Round(weaponItemTable:GetData("oil"), 0));
				end
				
				return;
			end;
		end;
	end
	
	if player:GetSharedVar("oil") then
		player:SetSharedVar("oil", nil);
	end;
end;

-- Called when a player's shared variables should be set.
function cwLantern:PostPlayerSpawn(player)
	if player:GetSharedVar("oil") then
		player:SetSharedVar("oil", nil);
	end
end;

-- Called when a player is killed.
function cwLantern:PlayerDeath(player)
	if !player.opponent then
		player:SetSharedVar("oil", 0);
	end
end;