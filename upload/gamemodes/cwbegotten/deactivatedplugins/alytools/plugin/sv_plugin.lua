--[[
	Script written by Aly for Begotten III: Jesus Wept
	Unauthorized tampering will result in immediate corpsing
--]]

if not cwAlyTools.Teleporters then
	cwAlyTools.Teleporters = {};
	cwAlyTools.Portals = {};
end

-- Set a player's health and stamina.
function cwAlyTools:SetStatMultiplier(player)
	player:SetMaxHealth(1000);
	player:SetNetVar("MaxHP",1000)
	player:SetHealth(1000);
	player:SetLocalVar("maxStability", 1000);
	player:SetLocalVar("maxMeleeStamina", 1000);
	player:SetLocalVar("Max_Stamina", 1000);
	player:SetCharacterData("Max_Stamina", 1000);
	player:SetCharacterData("Stamina", 1000);
	player:SetNWInt("meleeStamina", 1000);
	player:SetNWInt("stability", 1000);
	player:SetSacramentLevel(40);
	player:SetNetVar("level", 40);
end;

-- A function to load all the teleporters.
function cwAlyTools:LoadTeleporters()
	local portals = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/AlyTools/teleporters/"..game.GetMap()));
	for k, v in pairs(portals) do
		local portal = ents.Create("cw_teleportal")
		portal:SetPos(v.position);
		portal:Spawn();
		portal:SetNWVector( "portaltarget", v.target )
	end
end;

-- A function to save all the teleporters.
function cwAlyTools:SaveTeleporters()
	local teleports = {};
	
	for k, v in pairs(ents.FindByClass( "cw_teleportal" )) do
		teleports[#teleports + 1] = {position = v:GetPos(),target = v:GetNWVector( "portaltarget")};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/AlyTools/teleporters/"..game.GetMap(), teleports);
end;

-- A function to load all the teleporters.
function cwAlyTools:LoadPowerCores()
	local portals = table.Copy(Clockwork.kernel:RestoreSchemaData("plugins/AlyTools/PowerCores/"..game.GetMap()));
	for k, v in pairs(portals) do
		local portal = ents.Create("cw_powercore")
		portal:SetPos(v.position);
		portal:Spawn();
		portal:SetNWVector( "portaltarget", v.target )
	end
end;

-- A function to save all the teleporters.
function cwAlyTools:SavePowerCores()
	local teleports = {};
	
	for k, v in pairs(ents.FindByClass( "cw_powercore" )) do
		teleports[#teleports + 1] = {position = v:GetPos(),target = v:GetNWVector( "portaltarget")};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/AlyTools/PowerCores/"..game.GetMap(), teleports);
end;

-- A function to add a teleporter.
function cwAlyTools:AddTeleporter(position, target)
	local portal = ents.Create("cw_teleportal")
	portal:SetPos(position);
	portal:Spawn();
	portal:SetNetVar( "portaltarget", target )
	self:SaveTeleporters();
end;

-- A function to add a teleporter.
function cwAlyTools:AddFuckedTeleporter(position, target)
	local portal = ents.Create("cw_fuckedteleportal")
	portal:SetPos(position);
	portal:Spawn();
	local targetpos = Vector(0,0,0);
	if target ~= Vector(0,0,0) then
		print("valid teleporter")
		targetpos = target-Vector(0,0,24)
	end
	portal:SetNWVector( "portaltarget", targetpos )
end;

-- A function to remove a teleportal.
function cwAlyTools:RemoveTeleporter(position, distance, player)
	if (position) then
		local count = 0;
		
		for k, v in pairs (ents.FindByClass( "cw_teleportal" )) do
			if (v:GetPos():Distance(position) < distance) then
				v:Remove()
				count = count + 1;
			end;
		end;
		
		for k, v in pairs (ents.FindByClass( "cw_fuckedteleportal" )) do
			if (v:GetPos():Distance(position) < distance) then
				v:Remove()
				count = count + 1;
			end;
		end;
		
		for k, v in pairs (ents.FindByClass( "cw_arriveportal" )) do
			if (v:GetPos():Distance(position) < distance) then
				v:Remove()
				count = count + 1;
			end;
		end;
		
		for k, v in pairs (ents.FindByClass( "cw_fuckedarriveportal" )) do
			if (v:GetPos():Distance(position) < distance) then
				v:Remove()
				count = count + 1;
			end;
		end;

		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed "..count.." teleporter(s) at your cursor position.");
			cwAlyTools:NotifyAly(player:Name().." has removed "..count.." teleporter(s)." )
		end;
		
		self:SaveTeleporters();
	end;
end;

-- A function to remove a teleportal.
function cwAlyTools:RemoveAllTeleporters(player)
	local count = 0;
	
	for k, v in pairs (ents.FindByClass( "cw_teleportal" )) do
		v:Remove()
		count = count + 1;
	end;
	
	for k, v in pairs (ents.FindByClass( "cw_fuckedteleportal" )) do
		v:Remove()
		count = count + 1;
	end;

	Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has deleted all teleporters.", nil);
	
	self:SaveTeleporters();
end;

-- A function to add a teleporter.
function cwAlyTools:AddPowerCore(position)
	local portal = ents.Create("cw_powercore")
	portal:SetPos(position);
	portal:Spawn();
	self:SavePowerCores();
end;

-- A function to remove a teleportal.
function cwAlyTools:RemovePowerCore(position, distance, player)
	if (position) then
		local count = 0;
		
		for k, v in pairs (ents.FindByClass( "cw_powercore" )) do
			if (v:GetPos():Distance(position) < distance) then
				v:Remove()
				count = count + 1;
			end;
		end;

		if (player and player:IsPlayer()) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You removed "..count.." power cores(s) at your cursor position.");
			cwAlyTools:NotifyAly(player:Name().." has removed "..count.." power cores(s)." )
		end;
		
		self:SavePowerCores();
	end;
end;

-- A function to remove a teleportal.
function cwAlyTools:RemoveAllPowerCores(player)
	local count = 0;
	
	for k, v in pairs (ents.FindByClass( "cw_powercore" )) do
		v:Remove()
		count = count + 1;
	end;
	
	Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has deleted all power cores.", nil);
	
	self:SavePowerCores();
end;

-- A function to remove a teleportal.
function cwAlyTools:NotifyAly(text)
	local alyishere = false;
	
	for _, v in _player.Iterator() do
		if v:SteamID() == "STEAM_0:0:15306745" then
			alyishere = true;
			Schema:EasyText(v, "cornflowerblue", "[ALYNOTIFY]:"..text, nil);
			break;
		end
	end
end;