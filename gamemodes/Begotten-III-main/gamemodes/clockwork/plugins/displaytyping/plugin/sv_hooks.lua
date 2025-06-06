--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when a player's typing display has started.
function PLUGIN:PlayerStartTypingDisplay(player, code)
	if (!player:IsNoClipping()) then
		if (code == "n" or code == "y" or code == "w") then
			if (!player.typingBeep) then
				local rankName, rank = player:GetFactionRank()
				local faction = Clockwork.faction:FindByID(player:GetFaction())

				player.typingBeep = true

				if (rank and rank.startChatNoise) then
					player:EmitSound(rank.startChatNoise)
				elseif (faction and faction.startChatNoise) then
					player:EmitSound(faction.startChatNoise)
				end
			end
		end
		
		if code == "r" then
			if player:HasItemByID("handheld_radio") then
				if player:GetCharacterData("radioState", false) == true then
					local lastZone = player:GetCharacterData("LastZone");
		
					if lastZone == "wasteland" or lastZone == "tower" then
						if (!player.radioBeep) then
							player.radioBeep = true;
							
							player:EmitSound("radio/radio_in1.wav", 75, math.random(95, 100), 0.75, CHAN_AUTO);
							return;
						end;
					end
				end
			end
			
			local ent = player:GetEyeTrace().Entity;
			
			if ent:GetClass() == "cw_radio" then
				if (!ent:IsOff() and !ent:IsCrazy()) then
					if (!player.radioBeep) then
						player.radioBeep = true;
						
						ent:EmitSound("radio/radio_in1.wav", 75, math.random(95, 100), 0.75, CHAN_AUTO);
						return;
					end;
				end
			end
		end
	end
end

-- Called when a player's typing display has finished.
function PLUGIN:PlayerFinishTypingDisplay(player, textTyped)
	if (textTyped) then
		if (player.typingBeep) then
			local rankName, rank = player:GetFactionRank()
			local faction = Clockwork.faction:FindByID(player:GetFaction())

			if (rank and rank.endChatNoise) then
				player:EmitSound(rank.endChatNoise)
			elseif (faction and faction.endChatNoise) then
				player:EmitSound(faction.endChatNoise)
			end
		end
		
		if (player.radioBeep) and player:HasItemByID("handheld_radio") and player:GetCharacterData("radioState", false) == true then
			player:EmitSound("radio/radio_out"..tostring(math.random(1, 3))..".wav", 75, math.random(95, 100), 0.75, CHAN_AUTO);
		end
	end

	player.radioBeep = nil;
	player.typingBeep = nil
end