--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

cwObserverMode.ClientsideObserverEnabled = false;
cwObserverMode.ViewOrigin = Vector(0, 0, 0);
cwObserverMode.ViewAngle = Angle(0, 0, 0);
cwObserverMode.Velocity = Vector(0, 0, 0);

function cwObserverMode:CalcView(ply, origin, angles, fov)
	if (!cwObserverMode.ClientsideObserverEnabled) or !Clockwork.Client:IsAdmin() then
		return;
	end;
	
	if (cwObserverMode.SetView) then
		cwObserverMode.ViewOrigin = origin;
		cwObserverMode.ViewAngle = angles;
		
		cwObserverMode.SetView = false;
	end;
	
	local tra = {}
	tra.start = cwObserverMode.ViewOrigin;
	tra.endpos = cwObserverMode.ViewOrigin + (cwObserverMode.ViewAngle:Forward() * 99999)
	local a = util.TraceLine(tra);
	
	aimpos = a.HitPos;

	return {origin = cwObserverMode.ViewOrigin, angles = cwObserverMode.ViewAngle};
end;
hook.Add("CalcView", "ClientsideObserverView", cwObserverMode.CalcView);

function cwObserverMode:CreateMove(cmd)
	if (!cwObserverMode.ClientsideObserverEnabled) or !Clockwork.Client:IsAdmin() or !cmd then
		return;
	end;
	
	local time = 0.025;

	cwObserverMode.ViewOrigin = cwObserverMode.ViewOrigin + (cwObserverMode.Velocity * time);
	cwObserverMode.Velocity = cwObserverMode.Velocity * 0.95;
	
	local sensitivity = 0.022;
	
	cwObserverMode.ViewAngle.p = math.Clamp(cwObserverMode.ViewAngle.p + (cmd:GetMouseY() * sensitivity), -89, 89);
	cwObserverMode.ViewAngle.y = cwObserverMode.ViewAngle.y + (cmd:GetMouseX() * -1 * sensitivity);
	
	local add = Vector(0, 0, 0);
	local ang = cwObserverMode.ViewAngle;
	
	if (cmd:KeyDown(IN_FORWARD)) then 
		add = add + ang:Forward();
	end;
	
	if (cmd:KeyDown(IN_BACK)) then
		add = add - ang:Forward();
	end;
	
	if (cmd:KeyDown(IN_MOVERIGHT)) then 
		add = add + ang:Right();
	end;
	
	if (cmd:KeyDown(IN_MOVELEFT)) then 
		add = add - ang:Right();
	end;
	
	if (cmd:KeyDown(IN_JUMP)) then 
		add = add + ang:Up();
	end;
	
	if (cmd:KeyDown(IN_DUCK)) then 
		add = add - ang:Up();
	end;
	
	add = add:GetNormal() * time * 500;
	
	if (cmd:KeyDown(IN_SPEED)) then 
		add = add * 2;
	end;
	
	cwObserverMode.Velocity = cwObserverMode.Velocity + add;
	
	if (cwObserverMode.LockView == true) then
		cwObserverMode.LockView = cmd:GetViewAngles();
	end;
	
	if (cwObserverMode.LockView) then
		cmd:SetViewAngles(cwObserverMode.LockView);
	end;
	
	cmd:SetForwardMove(0);
	cmd:SetSideMove(0);
	cmd:SetUpMove(0);
end;
hook.Add("CreateMove", "ClientsideObserverMove", cwObserverMode.CreateMove);

function cwObserverMode:ToggleClientsideObserver()
	if Clockwork.Client:IsAdmin() then
		cwObserverMode.ClientsideObserverEnabled = !cwObserverMode.ClientsideObserverEnabled;
		cwObserverMode.LockView = cwObserverMode.ClientsideObserverEnabled;
		cwObserverMode.SetView = true;
	end
end;

netstream.Hook("ToggleClientsideObserver", function(data)
	cwObserverMode:ToggleClientsideObserver();
end);

-- Called to get whether the local player can see the admin ESP.
function cwObserverMode:PlayerCanSeeAdminESP()
	if ((!Clockwork.player:IsNoClipping(Clockwork.Client) and !cwObserverMode.ClientsideObserverEnabled) or !Clockwork.Client:IsAdmin()) then
		return false
	end
end

-- Called to get the action text of a player.
function cwObserverMode:GetStatusInfo(player, text)
	if (Clockwork.player:IsNoClipping(player)) then
		table.insert(text, "[Observer]")
	end
end

-- Called when a player attempts to NoClip.
function cwObserverMode:PlayerNoClip(player)
	return false
end

function cwObserverMode:CanOpenEntityMenu()
	if (Clockwork.player:IsNoClipping(Clockwork.Client) and !Clockwork.Client:IsAdmin()) then
		Clockwork.chatBox:Add(nil, "icon16/error.png", Color(200, 175, 200, 255), "You cannot interact with entities while in spectator mode!");
		return false;
	end
end

-- Called to check if a player does recognise another player.
function cwObserverMode:PlayerDoesRecognisePlayer(player, status, isAccurate, realValue)
	if Clockwork.Client:GetMoveType() == MOVETYPE_NOCLIP and Clockwork.Client:IsAdmin() then
		return true;
	end;
end