--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- A function to make a player exit observer mode.
function cwObserverMode:MakePlayerExitObserverMode(player)
	hook.Run("PreMakePlayerExitObserverMode", player);

	player.cwObserverReset = true
	player:DrawWorldModel(true)
	player:DrawShadow(true)
	player:SetNoDraw(false)
	player:SetNoTarget(false)
	player:SetRenderMode(RENDERMODE_TRANSALPHA);
	player:Extinguish();
	
	if player:Alive() then
		player:SetMoveType(player.cwObserverMoveType or MOVETYPE_WALK)
		player:SetNotSolid(false)
	else
		player:SetMoveType(MOVETYPE_OBSERVER)
	end
	
	player:UnSpectate();
	
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player)) then
			if (player.cwObserverColor) then
				player:SetColor(Color(player.cwObserverColor.r, player.cwObserverColor.g, player.cwObserverColor.b, player.cwObserverColor.a))
			end

			player.cwObserverMoveType = nil
			player.cwObserverReset = nil
			player.cwObserverPos = nil
			player.cwObserverAng = nil
			player.cwObserverMode = nil
		end
	end)
end

-- A function to make a player enter observer mode.
function cwObserverMode:MakePlayerEnterObserverMode(player)
	hook.Run("PreMakePlayerEnterObserverMode", player);

	player.cwObserverMoveType = player:GetMoveType()
	player.cwObserverPos = player:GetPos()
	player.cwObserverAng = player:EyeAngles()
	player.cwObserverColor = player:GetColor()
	player.cwObserverMode = true
	
	if !player:Alive() then
		player:SetObserverMode(OBS_MODE_ROAMING); -- Don't know why this is needed now but it is.
	end
	
	player:SetMoveType(MOVETYPE_NOCLIP)
	player:SetNoTarget(true)
	player:Extinguish();
end
