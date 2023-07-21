--[[
	Begotten III: Jesus Wept
--]]

function cwLantern:PlayerUseUnknownItemFunction(player, itemTable, itemFunction)
	--[[
	if (itemFunction == "wearlantern") then
		itemTable:SetData("IsWorn", true);
	elseif (itemFunction == "unwearlantern") then
		itemTable:SetData("IsWorn", false);
	end;
	--]]
end;

-- Called at an interval while a player is connected.
function cwLantern:PlayerThink(player, curTime, infoTable)
	local activeWeapon = player:GetActiveWeapon();

	if (IsValid(activeWeapon) and activeWeapon:GetClass() == "cw_lantern") then
		local currentOil = player:GetCharacterData("oil", 0);
		
		if (tonumber(currentOil) > 0) then
			local bWeaponRaised = Clockwork.player:GetWeaponRaised(player);

			if (bWeaponRaised) then
				if (!player.lanternSound) then
					player:EmitSound("lantern/lantern_on.wav", 60, math.random(95, 105));
					player.lanternSound = true;
				end;
				
				if (!player.nextOilDrop or curTime > player.nextOilDrop) then
					player:SetCharacterData("oil", math.Clamp(currentOil - 1, 0, 100));
					player:SetSharedVar("oil", math.Round(player:GetCharacterData("oil"), 0));
					
					--[[if (player:HasItemByID("gascan")) then 
						player.nextOilDrop = curTime + 7;
					else
						player.nextOilDrop = curTime + 4;
					end;]]--
					
					player.nextOilDrop = curTime + 30;
				end;
			else
				if (player.lanternSound) then
					player:EmitSound("lantern/lantern_off.wav", 60, math.random(95, 105));
					player.lanternSound = false;
				end;
			end;
		end;
	end;
end;

-- Called when a player's character data should be saved.
function cwLantern:PlayerSaveCharacterData(player, data)
	if (data["oil"]) then
		data["oil"] = math.Round(data["oil"]);
	else
		data["oil"] = 0;
	end;
end;

-- Called when a player's character data should be restored.
function cwLantern:PlayerRestoreCharacterData(player, data)
	data["oil"] = data["oil"] or 0;
end;

-- Called when a player's shared variables should be set.
function cwLantern:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("oil", math.Round(player:GetCharacterData("oil"), 0));
end;

-- Called when a player's shared variables should be set.
function cwLantern:PostPlayerSpawn(player)
	player:SetSharedVar("oil", math.Round(player:GetCharacterData("oil"), 0));
end;

-- Called when a player is killed.
function cwLantern:PlayerDeath(player)
	if !player.opponent then
		player:SetCharacterData("oil", 0);
		player:SetSharedVar("oil", 0);
	end
end;