--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when a player starts typing.
concommand.Add("cwTypingStart", function(player, command, arguments)
	if (player:Alive() and !player:IsRagdolled(RAGDOLL_FALLENOVER)) then
		if (arguments and arguments[1]) then
			hook.Run("PlayerStartTypingDisplay", player, arguments[1])

			if (arguments[1] == "w") then
				player:SetNetVar("Typing", TYPING_WHISPER)
			elseif (arguments[1] == "p") then
				player:SetNetVar("Typing", TYPING_PERFORM)
			elseif (arguments[1] == "n") then
				player:SetNetVar("Typing", TYPING_NORMAL)
			elseif (arguments[1] == "r") then
				player:SetNetVar("Typing", TYPING_RADIO)
			elseif (arguments[1] == "y") then
				player:SetNetVar("Typing", TYPING_YELL)
			elseif (arguments[1] == "o") then
				player:SetNetVar("Typing", TYPING_OOC)
			end
		end
	end
end)

-- Called when a player finishes typing.
concommand.Add("cwTypingFinish", function(player, command, arguments)
	if (IsValid(player)) then
		if (arguments and arguments[1] and arguments[1] == "1") then
			hook.Run("PlayerFinishTypingDisplay", player, true)
		else
			hook.Run("PlayerFinishTypingDisplay", player)
		end

		player:SetNetVar("Typing", 0)
	end
end)