--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when a player attempts to NoClip.
function cwObserverMode:PlayerNoClip(player)
	Clockwork.player:RunClockworkCommand(player, "Observer")
	return false
end

-- Called at an interval while a player is connected.
function cwObserverMode:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if plyTab.cwObserverMode then
		if (!player:InVehicle() and player:GetMoveType() == MOVETYPE_NOCLIP) then
			local color = player:GetColor()
				player:SetRenderMode(RENDERMODE_TRANSALPHA);
				player:DrawWorldModel(false)
				player:DrawShadow(false)
				player:SetNoDraw(true)
				player:SetNotSolid(true)
			player:SetColor(Color(color.r, color.g, color.b, 0))
		else
			if (!plyTab.cwObserverReset) then
				cwObserverMode:MakePlayerExitObserverMode(player)
			end
		end
	end
end

EVENTMAPS = {
	["government_sector"] = true,
}
local eventmap = EVENTMAPS[game.GetMap()];

if (eventmap) then
	self.spectatorMode = true;
end;

local gfacs = {
	["Gatekeeper"] = true,
	["Holy Hierarchy"] = true
}

-- Called just after a player spawns.
function cwObserverMode:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (eventmap) then
		if !gfacs[player:GetFaction()] and !player:IsAdmin() then
			cwObserverMode:MakePlayerEnterObserverMode(player)
			player:StripWeapons();
		else
			cwObserverMode:MakePlayerExitObserverMode(target);
			player:Give("begotten_fists");
			player:Give("cw_senses");
		end
	end;
end;

function cwObserverMode:PlayerDeath(player)
	if self.spectatorMode and player:HasInitialized() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] Spectator mode is currently enabled! Type /spectate to toggle spectating.");
	end
end;

function cwObserverMode:PlayerCanBeIgnited(player)
	if player.cwObserverMode then return false end;
end

function cwObserverMode:PlayerCanSwitchCharacter(player, character)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		if !player.cwObserverMode then
			return false;
		end
	end;
end;

function cwObserverMode:PlayerCanSayLOOC(player, text)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot speak in LOOC while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerCanSayIC(player, text)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot speak while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerCanUseCommand(player, commandTable, arguments)
	local lowername = string.lower(commandTable.name);
	
	if (lowername != "spectate" and lowername != "adminhelp" and lowername != "pm") then
		if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
			Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot use commands while in spectator mode!");
			
			return false;
		end;
	end;
end;

function cwObserverMode:PlayerPickupItem(player, itemTable, itemEntity, bQuickUse) 
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot pick up items while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerUseItem(player, itemTable, itemEntity) 
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot use items while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerCanDropItem(player, itemTable, position) 
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot drop items while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerDestroyItem(player, itemTable) 
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot destroy items while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerCanPickupWeapon(player, weapon)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot pick up weapons while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerCanBeGivenWeapon(player, class, uniqueID, forceReturn)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	if player:GetMoveType() == MOVETYPE_NOCLIP and player:IsAdmin() then
		return true;
	end;
end;

function cwObserverMode:PlayerCanUseDoor(player, door)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot use doors while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerUse(player, entity)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		Schema:EasyText(player, "darkgrey", "["..self.name.."] You cannot use doors while in spectator mode!");
		
		return false;
	end;
end;

function cwObserverMode:PlayerPlayDeathSound(player, gender)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:PlayerCanDropWeapon(player, itemTable, weapon, bNoMsg)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:PlayerCanUseItem(player, itemTable, bNoMsg)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:CanPlayerEnterVehicle(player, vehicle, role)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;

function cwObserverMode:CanWeaponBeToggled(player, weapon)
	if player:GetMoveType() == MOVETYPE_NOCLIP and !player:IsAdmin() then
		return false;
	end;
end;