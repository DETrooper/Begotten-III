--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Called just after a player spawns.
function cwOxygen:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		if !player:GetCharacterData("oxygen") then
			player:SetCharacterData("oxygen", 100);
		end
		
		player:SetLocalVar("oxygen", player:GetCharacterData("oxygen"));
	end

	player.suffocating = nil
	player.drowned = nil
end;

-- Called at an interval while a player is connected.
function cwOxygen:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (!plyTab.nextOxygenDecay or plyTab.nextOxygenDecay < curTime) then
		if (!player:Alive() or player:GetMoveType() == MOVETYPE_NOCLIP or plyTab.victim) then
			plyTab.nextOxygenDecay = curTime + 5
			plyTab.suffocating = nil
			
			return
		end
		
		local oxygen = player:GetCharacterData("oxygen", 100)
		local waterLevel = infoTable.waterLevel;
		local decayTime = 3
		local change = 0
		
		if (waterLevel >= 3) then
			if cwBeliefs and player.HasBelief and player:HasBelief("the_black_sea") then
				decayTime = 0.5
				change = -1
			elseif plyTab.drownedKingActive then
				decayTime = 0.5
				change = 0;
			else
				decayTime = 0.3
				change = -2
			end
		elseif (oxygen != 100) then
			decayTime = 1
			change = 5
		end
		
		if (change != 0) then
			local newOxygen = math.Clamp(oxygen + change, 0, 100);
			
			player:SetCharacterData("oxygen", newOxygen);
			player:SetLocalVar("oxygen", newOxygen);
		end
		
		if (!plyTab.suffocating) then
			if (oxygen <= 0) then
				plyTab.suffocating = curTime
				decayTime = 0.5
			else
				plyTab.suffocating = nil
			end
		else
			if (oxygen > 0) then
				plyTab.suffocating = nil
			elseif (waterLevel >= 3) then
				decayTime = 1
				
				if (!plyTab.drowned and (curTime - plyTab.suffocating) > 10) then
					netstream.Start(player, "Drown", true)
					plyTab.drowned = true
					
					timer.Simple(2, function()
						if IsValid(player) then
							player:DeathCauseOverride("Drowned to death.");
							--player:TakeDamage(10000);
							player:Kill();
						end
					end)
				end
				
				if (!plyTab.drowned) then
					player:EmitSound("begotten/misc/npc_human_drowning_0"..math.random(1, 3)..".wav", 75, 100)
					netstream.Start(player, "Drown")
				end
			end
		end
		
		plyTab.nextOxygenDecay = curTime + decayTime
	end
end;

function cwOxygen:PlayerCanSwitchCharacter(player, character)
	if player:GetCharacterData("oxygen", 100) < 100 then
		return "You cannot switch characters while your oxygen is below 100!";
	end
end

-- Called when the player's character data is saved.
function cwOxygen:PlayerSaveCharacterData(player, data)
	if (data["oxygen"]) then
		data["oxygen"] = math.Round(data["oxygen"])
	end
end

-- Called when the player's character data should be restored.
function cwOxygen:PlayerRestoreCharacterData(player, data)
	data["oxygen"] = data["oxygen"] or 100
end