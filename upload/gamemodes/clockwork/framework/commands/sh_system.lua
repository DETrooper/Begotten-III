--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--setskin
--setattribute

local COMMAND = Clockwork.command:New("CfgListVars");
	COMMAND.tip = "List the Clockwork config variables.";
	COMMAND.text = "[string Find]";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local searchData = arguments[1] or "";
			netstream.Start(player, "CfgListVars", searchData);
		Clockwork.player:Notify(player, "The config variables have been printed to the console.");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CfgSetVar");
	COMMAND.tip = "Set a Clockwork config variable.";
	COMMAND.text = "<string Key> [all Value] [string Map]";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local key = arguments[1];
		local value = arguments[2] or "";
		local configObject = config.Get(key);
		
		if (configObject:IsValid()) then
			local keyPrefix = "";
			local useMap = arguments[3];
			
			if (useMap == "") then
				useMap = nil;
			end;
			
			if (useMap) then
				useMap = string.lower(Clockwork.kernel:Replace(useMap, ".bsp", ""));
				keyPrefix = useMap.."'s ";
				
				if (!file.Exists("maps/"..useMap..".bsp", "GAME")) then
					Clockwork.player:Notify(player, useMap.." is not a valid map!");
					return;
				end;
			end;
			
			if (!configObject("isStatic")) then
				value = configObject:Set(value, useMap);
				
				if (value != nil) then
					local printValue = tostring(value);
					
					if (configObject("isPrivate")) then
						if (configObject("needsRestart")) then
							Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..string.rep("*", string.len(printValue)).."' for the next restart.");
						else
							Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..string.rep("*", string.len(printValue)).."'.");
						end;
					elseif (configObject("needsRestart")) then
						Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..printValue.."' for the next restart.");
					else
						Clockwork.player:NotifyAll(player:Name().." set "..keyPrefix..key.." to '"..printValue.."'.");
					end;
				else
					Clockwork.player:Notify(player, key.." was unable to be set!");
				end;
			else
				Clockwork.player:Notify(player, key.." is a static config key!");
			end;
		else
			Clockwork.player:Notify(player, key.." is not a valid config key!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Announce");
	COMMAND.tip = "Notify all players on the server.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local text = table.concat(arguments, " ");
		
		if (text) then
			if Schema.EasyText then
				for _, v in _player.Iterator() do
					if IsValid(v) and v:HasInitialized() then
						Schema:EasyText(v, "icon16/bell.png", "goldenrod", "[ANNOUNCEMENT] "..text);
						v:SendLua([[Clockwork.Client:EmitSound("ui/pickup_secret01.wav", 80, 80)]]);
					end
				end
			else
				Clockwork.player:Notify(PlayerCache or _player.GetAll(), text);
			end
		end;
	end;
COMMAND:Register();

--[[local COMMAND = Clockwork.command:New("ClearItems");
	COMMAND.tip = "Clear all items from the map.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local items = 0;
		
		for k, v in pairs (ents.FindByClass("cw_item")) do
			if (hook.Run("CanClearItem", v)) then
				v:Remove();
				items = items + 1;
			end;
		end;
		
		if (items > 0) then
			Clockwork.player:Notify(player, "You removed "..items.." items.");
		else
			Clockwork.player:Notify(player, "There were no items to remove.");
		end;
	end;
COMMAND:Register();]]--

local COMMAND = Clockwork.command:New("ClearNPCs");
	COMMAND.tip = "Clear all decals.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local npcs = 0;
		
		for k, v in pairs (ents.GetAll()) do
			if (v:IsNPC() or v:IsNextBot()) then
				v:Remove();
				npcs = npcs + 1;
			end;
		end;
		
		if (npcs > 0) then
			Clockwork.player:Notify(player, "You removed "..npcs.." NPCs.");
		else
			Clockwork.player:Notify(player, "There were no npcs to remove.");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyStopSound");
	COMMAND.tip = "Stop all sounds on a specific player.";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharStopSound", "StopSoundTarget", "StopSoundPlayer"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
			
			return;
		end;
	
		target:SendLua([[RunConsoleCommand("stopsound")]]);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StopSoundGlobal");
	COMMAND.tip = "Stop all sounds for all players.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			v:SendLua([[RunConsoleCommand("stopsound")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("StopSoundRadius");
	COMMAND.tip = "Stops all sounds to all players in a specified radius. Default radius is 512.";
	COMMAND.optionalArguments = 1;
	COMMAND.access = "s";
	COMMAND.text = "[int Radius]";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local players = {};
		
		for k, v in pairs (ents.FindInSphere(player:GetPos(), arguments[1] or 512)) do
			if (v:IsPlayer()) then
				players[#players + 1] = v;
			end;
		end;
		
		for k, v in pairs(players) do
			v:SendLua([[RunConsoleCommand("stopsound")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ClearDecals");
	COMMAND.tip = "Clear all decals.";
	COMMAND.access = "a";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		for _, v in _player.Iterator() do
			v:SendLua([[RunConsoleCommand("r_cleardecals")]]);
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyReset");
	COMMAND.tip = "Reset a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"Reset", "CharReset"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);

		if (!target) then
			target = player;
		end;
		
		local name = target:Name();
			if (target == player) then
				name = "yourself";
			end;
		local position = target:GetPos();
		local angles = target:GetAngles();
		local eyeAngles = target:EyeAngles();

		target:KillSilent();
		target:Spawn();
		target:SetPos(position);
		target:SetAngles(angles);
		target:SetEyeAngles(eyeAngles);
		
		Clockwork.player:Notify(player, "You have reset "..name..".");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyExtinguish");
	COMMAND.tip = "Extinguish a player.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "o";
	COMMAND.arguments = 1;
	COMMAND.alias = {"CharExtinguish", "Extinguish"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local name = target:Name();
			local playerName = player:Name();
			
			if (target:IsOnFire()) then
				target:Extinguish();
				Clockwork.player:Notify(player, "You have extinguished "..name);
			else
				Clockwork.player:Notify(player, name.." is not on fire!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyIgnite");
	COMMAND.tip = "Ignite a player.";
	COMMAND.text = "<string Name> <int Seconds>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharIgnite", "Ignite"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local name = target:Name();
			local playerName = player:Name();
			
			if (!target:IsOnFire()) then
				local time = tonumber(arguments[2]);
				
				for _, v in _player.Iterator() do
					if (v != player and v != target and v:IsAdmin() or v:IsUserGroup("operator")) then
						Clockwork.player:Notify(player, playerName.." has ignited "..name.." for "..time.." seconds.")
					end;
				end;
			
				Clockwork.player:Notify(player, "You have ignited "..name.." for "..time.." seconds.")
					if (target:IsAdmin()) then
						Clockwork.player:Notify(target, "You have been ignited by "..playerName.."!");
					end;
				target:Ignite(time, 0);
			else
				Clockwork.player:Notify(player, name.." is already on fire!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyWarn");
	COMMAND.tip = "Add a player to a whitelist.";
	COMMAND.text = "<string Name> <string Warning>";
	COMMAND.access = "s";
	COMMAND.arguments = 2;
	COMMAND.alias = {"CharWarn", "Warn"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			local playerName = player:Name();
			local name = target:Name();
			local message = table.concat(arguments, " ", 2);
			
			for _, v in _player.Iterator() do
				if (v != player and v != target and v:IsAdmin() or v:IsUserGroup("operator")) then
					Clockwork.player:Notify(v, playerName.." has warned "..name.." with the following message: \""..message.."\"")
				end;
			end;
			
			Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, playerName.." has warned "..name.." with the following message: \""..message.."\"");
			Clockwork.player:Notify(target, "You have been warned by "..playerName..": \""..message.."\"");
			Clockwork.player:Notify(player, "You have warned "..name..": \""..message.."\"");
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ListColors");
	COMMAND.tip = "Print all available colors to your console. First argument allows a search of the table.";
	COMMAND.text = "<string Search>";
	COMMAND.access = "a";
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local search = arguments[1];
		local colorTable = colors;
		local printTable = {};

		for k, v in pairs (colorTable) do
			if (search != nil and isstring(search)) then
				if (string.match(k, search)) then
					printTable[k] = v;
				else
					continue;
				end;
			else
				printTable[k] = v;
			end;
		end;
		
		if (printTable and !table.IsEmpty(printTable)) then
			netstream.Start(player, "PrintWithColor", "----- START COLOR LIST -----", Color(100, 255, 100));
				netstream.Heavy(player, "PrintTableWithColor", pon.encode(printTable));
			netstream.Start(player, "PrintWithColor", "----- END COLOR LIST -----", Color(100, 255, 100));
		elseif (isstring(search)) then
			Clockwork.player:Notify(player, "No colors found with the search argument '"..search.."'!")
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PluginLoad");
	COMMAND.tip = "Attempt to load a plugin.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local plugin = plugin.FindByID(arguments[1]);
		
		if (!plugin) then
			Clockwork.player:Notify(player, "This plugin is not valid!");
			return;
		end;
		
		local unloadTable = Clockwork.command:FindByID("PluginLoad");
		local loadTable = Clockwork.command:FindByID("PluginLoad");
		
		if (!plugin.IsDisabled(plugin.name)) then
			local bSuccess = plugin.SetUnloaded(plugin.name, false);
			local recipients = {};
			
			if (bSuccess) then
				Clockwork.player:NotifyAll(player:Name().." has loaded the "..plugin.name.." plugin for the next restart.");
				
				for _, v in _player.Iterator() do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					netstream.Start(recipients, "SystemPluginSet", {plugin.name, false});
				end;
			else
				Clockwork.player:Notify(player, "This plugin could not be loaded!");
			end;
		else
			Clockwork.player:Notify(player, "This plugin depends on another plugin!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("PluginUnload");
	COMMAND.tip = "Attempt to unload a plugin.";
	COMMAND.text = "<string Name>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local plugin = plugin.FindByID(arguments[1]);
		
		if (!plugin) then
			Clockwork.player:Notify(player, "This plugin is not valid!");
			return;
		end;
		
		local unloadTable = Clockwork.command:FindByID("PluginLoad");
		local loadTable = Clockwork.command:FindByID("PluginLoad");
		
		if (!plugin.IsDisabled(plugin.name)) then
			local bSuccess = plugin.SetUnloaded(plugin.name, true);
			local recipients = {};
			
			if (bSuccess) then
				Clockwork.player:NotifyAll(player:Name().." has unloaded the "..plugin.name.." plugin for the next restart.");
				
				for _, v in _player.Iterator() do
					if (v:HasInitialized()) then
						if (Clockwork.player:HasFlags(v, loadTable.access)
						or Clockwork.player:HasFlags(v, unloadTable.access)) then
							recipients[#recipients + 1] = v;
						end;
					end;
				end;
				
				if (#recipients > 0) then
					netstream.Start(recipients, "SystemPluginSet", {plugin.name, true});
				end;
			else
				Clockwork.player:Notify(player, "This plugin could not be unloaded!");
			end;
		else
			Clockwork.player:Notify(player, "This plugin depends on another plugin!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ShutDown");
	COMMAND.tip = "Shut down the server safely (this is the only way the save data functions will be called, so use this instead of the control panel). Leave the optional argument blank if you want the shut down to be immediate.";
	COMMAND.text = "[seconds Delay]";
	COMMAND.access = "s";
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local delay = arguments[1];
	
		if delay and tonumber(delay) and tonumber(delay) > 0 then
			local message = "The server will be shutting down in "..tostring(delay).." seconds!";
		
			for _, v in _player.Iterator() do
				Clockwork.player:Notify(v, message);
			end
			
			timer.Simple(delay, function()
				RunConsoleCommand("killserver");
			end);
		else
			RunConsoleCommand("killserver");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("SaveData");
	COMMAND.tip = "Save the server state manually.";
	COMMAND.access = "s";
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		Clockwork.kernel:ProcessSaveData(false, true);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleCharSwapping");
	COMMAND.tip = "Toggle whether or not charswapping should be enabled. Will only apply to alive characters and non-admins.";
	COMMAND.access = "s";
	COMMAND.alias = {"CharSwappingToggle", "DisableCharSwapping", "EnableCharSwapping"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if Clockwork.charSwappingDisabled then
			Clockwork.charSwappingDisabled = false;
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled charswapping for non-admins.");
			
			if Schema.fuckerJoeActive then
				Schema.fuckerJoeActive = false;
			end
		else
			Clockwork.charSwappingDisabled = true;
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled charswapping for non-admins.");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleFactionRatio");
	COMMAND.tip = "Toggle whether or not the faction ratio system should be enabled.";
	COMMAND.access = "s";
	COMMAND.alias = {"ToggleRatio", "FactionRatio", "RatioToggle"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if Clockwork.config:Get("faction_ratio_enabled"):Get() then
			Clockwork.config:Get("faction_ratio_enabled"):Set(false);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has disabled the faction ratio system.");
		else
			Clockwork.config:Get("faction_ratio_enabled"):Set(true);
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", player:Name().." has enabled the faction ratio system.");
		end
	end;
COMMAND:Register();