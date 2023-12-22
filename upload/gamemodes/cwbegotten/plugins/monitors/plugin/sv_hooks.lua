cas.peak = math.Round(game.MaxPlayers() * 0.8);

function cas:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (!plyTab.nextAFKTimer or plyTab.nextAFKTimer < curTime) then
		plyTab.nextAFKTimer = curTime + 5;
		
		if self.afkKickerEnabled ~= false then
			local playerCount = _player.GetCount();
			
			if (playerCount < self.peak) then
				return;
			end;
			
			if (player:IsAdmin() or player:IsBot() or player:IsUserGroup("operator")) then
				return;
			end;
			
			if (!initialized) then
				if (!plyTab.lastNotInitialized) then
					plyTab.lastNotInitialized = curTime + 360; -- give them 6 minutes
				elseif (plyTab.lastNotInitialized < curTime) then
					Clockwork.kernel:PrintLog(LOGTYPE_MINOR, "Kicking "..player:Name().." for being AFK in the character menu.");
					player:Kick("You were kicked for being AFK for more than 6 minutes in the character menu.");
				end;
			else
				if (plyTab.lastNotInitialized) then
					plyTab.lastNotInitialized = nil;
				end;
				
				local eyeAngles = player:EyeAngles();

				if (!plyTab.lastAngles) then
					plyTab.lastAngles = eyeAngles.pitch;
				end;
				
				if (plyTab.lastAngles != eyeAngles.pitch) then
					plyTab.lastAFK = curTime + 900;
					plyTab.lastAngles = eyeAngles.pitch;
				elseif (plyTab.lastAFK and plyTab.lastAFK <= curTime) then
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