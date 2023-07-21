--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Called just after a player spawns.
function cwOxygen:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!firstSpawn and !lightSpawn) then
		player:SetCharacterData("oxygen", 100);
		player:SetSharedVar("oxygen", 100);
	end

	player.suffocating = nil
	player.drowned = nil
end;

-- Called at an interval while a player is connected.
function cwOxygen:PlayerThink(player, curTime, infoTable)
	if (!player.nextOxygenDecay or player.nextOxygenDecay < curTime) then
		if (!player:Alive() or player:GetMoveType() == MOVETYPE_NOCLIP or player.victim) then
			player.nextOxygenDecay = curTime + 5
			player.suffocating = nil
			
			return
		end
		
		local oxygen = player:GetCharacterData("oxygen", 100)
		local waterLevel = player:WaterLevel()
		local decayTime = 3
		local change = 0
		
		if (waterLevel >= 3) then
			if cwBeliefs and player.HasBelief and player:HasBelief("the_black_sea") then
				decayTime = 0.5
				change = -1
			elseif player.drownedKingActive then
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
			player:SetSharedVar("oxygen", newOxygen);
		end
		
		if (!player.suffocating) then
			if (oxygen <= 0) then
				player.suffocating = curTime
				decayTime = 0.5
			else
				player.suffocating = nil
			end
		else
			if (oxygen > 0) then
				player.suffocating = nil
			elseif (waterLevel >= 3) then
				decayTime = 1
				
				if (!player.drowned and (curTime - player.suffocating) > 10) then
					Clockwork.datastream:Start(player, "Drown", true)
					player.drowned = true
					
					timer.Simple(2, function()
						if IsValid(player) then
							player:DeathCauseOverride("Drowned to death.");
							--player:TakeDamage(10000);
							player:Kill();
						end
					end)
				end
				
				if (!player.drowned) then
					player:EmitSound("begotten/misc/npc_human_drowning_0"..math.random(1, 3)..".wav", 75, 100)
					Clockwork.datastream:Start(player, "Drown")
				end
			end
		end
		
		player.nextOxygenDecay = curTime + decayTime
	end
end;

function cwOxygen:PlayerCanSwitchCharacter(player, character)
	if player:GetCharacterData("oxygen", 100) < 100 then
		return "You cannot switch characters while your oxygen is below 100!";
	end
end

-- Called every half second while a player is connected to the server.
--[[function cwOxygen:OnePlayerHalfSecond(player)
	player:SetSharedVar("oxygen", math.Round(player:GetCharacterData("oxygen", 100)))
end;]]--

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