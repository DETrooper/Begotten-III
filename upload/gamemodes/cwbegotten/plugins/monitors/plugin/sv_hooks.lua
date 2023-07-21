cas.peak = math.Round(game.MaxPlayers() * 0.8);

function cas:PlayerThink(player, curTime, infoTable, alive, initialized)
	if (!player.nextAFKTimer or player.nextAFKTimer < curTime) then
		player.nextAFKTimer = curTime + 5;
		
		if self.afkKickerEnabled ~= false then
			local playerCount = _player.GetCount();
			
			if (playerCount < self.peak) then
				return;
			end;
			
			if (player:IsAdmin() or player:IsBot() or player:IsUserGroup("operator")) then
				return;
			end;
			
			if (!initialized) then
				if (!player.lastNotInitialized) then
					player.lastNotInitialized = curTime + 360; -- give them 6 minutes
				elseif (player.lastNotInitialized < curTime) then
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Kicking "..player:Name().." for being AFK in the character menu.");
					player:Kick("You were kicked for being AFK for more than 6 minutes in the character menu.");
				end;
			else
				if (player.lastNotInitialized) then
					player.lastNotInitialized = nil;
				end;
				
				local eyeAngles = player:EyeAngles();

				if (!player.lastAngles) then
					player.lastAngles = eyeAngles.pitch;
				end;
				
				if (player.lastAngles != eyeAngles.pitch) then
					player.lastAFK = curTime + 900;
					player.lastAngles = eyeAngles.pitch;
				elseif (player.lastAFK and player.lastAFK <= curTime) then
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Kicking "..player:Name().." for being AFK.");
					player:Kick("You were kicked for being afk for more than 15 minutes.")
				end;
			end;
		end;
	end;
end;

function cas:GetStaff()
	local staff = {};
	for k, v in pairs (_player.GetAll()) do
		if (v:IsAdmin() or v:IsUserGroup("operator")) then
			staff[#staff + 1] = v;
		end;
	end;
	return staff
end;

-- A function to alert all currently online staff members.
function cas:NotifyStaff(text, noStaffCallback, color, icon)
	if (!text or !isstring(text)) then
		return;
	end;
	
	local staff = self:GetStaff();
	local color = color or "cornflowerblue";
	
	if (#staff > 0) then
		Schema:EasyText(staff, icon, color, text)
	else
		if (noStaffCallback) then
			noStaffCallback();
		end;
	end;
end;