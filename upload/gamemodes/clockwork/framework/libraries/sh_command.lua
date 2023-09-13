--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("command", Clockwork)

local stored = Clockwork.command.stored or {}
Clockwork.command.stored = stored

local hidden = {}
local alias = {}

CMD_KNOCKEDOUT = 2
CMD_FALLENOVER = 4
CMD_DEATHCODE = 8
CMD_RAGDOLLED = 16
CMD_VEHICLE = 32
CMD_DEAD = 64

CMD_DEFAULT = bit.bor(CMD_DEAD, CMD_KNOCKEDOUT)
CMD_HEAVY = bit.bor(CMD_DEAD, CMD_RAGDOLLED)
CMD_ALL = bit.bor(CMD_DEAD, CMD_VEHICLE, CMD_RAGDOLLED)

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE}

-- A function to register a new command.
function CLASS_TABLE:Register()
	return Clockwork.command:Register(self, self.name)
end

-- A function to get all stored commands.
function Clockwork.command:GetAll()
	return stored
end

-- A function to get a new command.
function Clockwork.command:New(name)
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE)
		object.name = name or "Unknown"
	return object
end

-- A function to remove a command.
function Clockwork.command:RemoveByID(identifier)
	stored[string.lower(string.gsub(identifier, "%s", ""))] = nil
end

-- A function to set whether a command is hidden.
function Clockwork.command:SetHidden(name, bHidden)
	local uniqueID = string.lower(string.gsub(name, "%s", ""))

	if (!bHidden and hidden[uniqueID]) then
		stored[uniqueID] = hidden[uniqueID]
		hidden[uniqueID] = nil
	elseif (hidden and stored[uniqueID]) then
		hidden[uniqueID] = stored[uniqueID]
		stored[uniqueID] = nil
	end

	if (SERVER) then
		netstream.Start(nil, "HideCommand", {
			index = Clockwork.kernel:GetShortCRC(uniqueID), hidden = bHidden
		})
	elseif (bHidden and hidden[uniqueID]) then
		self:RemoveHelp(hidden[uniqueID])
	elseif (!bHidden and stored[uniqueID]) then
		self:AddHelp(stored[uniqueID])
	end
end

-- A function to register a new command.
function Clockwork.command:Register(data, name)
	local realName = string.gsub(name, "%s", "")
	local uniqueID = string.lower(realName)

	if (CLIENT) then
		if (stored[uniqueID]) then
			self:RemoveHelp(stored[uniqueID])
		end
	end

	-- We do that so the Command Interpreter can find the command
 	-- if it's original, non-aliased name has been used.
 	alias[uniqueID] = uniqueID

 	if (data.alias and type(data.alias) == "table") then
 		for k, v in pairs(data.alias) do
 			alias[string.lower(tostring(v))] = uniqueID
 		end
 	end

	stored[uniqueID] = data
	stored[uniqueID].name = realName
	stored[uniqueID].text = data.text or "<none>"
	stored[uniqueID].flags = data.flags or 0
	stored[uniqueID].access = data.access or "b"
	stored[uniqueID].arguments = data.arguments or 0
	stored[uniqueID].uniqueID = uniqueID or "ERROR"

	if (CLIENT) then
		self:AddHelp(stored[uniqueID])
	end

	return stored[uniqueID]
end

-- A function to find a command by an identifier.
function Clockwork.command:FindByID(identifier)
	return stored[string.lower(string.gsub(identifier, "%s", ""))]
end

--[[
 	@codebase Shared
 	@details Returns command's table by alias or unique id.
	@param ID Identifier of the command to find. Can be alias or original command name.
--]]
function Clockwork.command:FindByAlias(identifier)
	return stored[alias[string.lower(string.gsub(identifier, "%s", ""))]]
end

--[[
	@codebase Shared
	@details Returns table of all command alias indexed by alias' names.
--]]
function Clockwork.command:GetAlias()
	return alias
end

if (SERVER) then
	function Clockwork.command:ConsoleCommand(player, command, arguments)
		if (IsValid(player) and player:HasInitialized()) then
			if (arguments and arguments[1]) then
				local realCommand = string.lower(arguments[1])
				local commandTable = self:FindByAlias(realCommand)
				local commandPrefix = config.GetVal("command_prefix")

				if (commandTable) then
					table.remove(arguments, 1)

					if (commandTable.cooldown and !player:IsAdmin()) then
						local curTime = CurTime()
						local cmdID = commandTable.uniqueID

						if (!player.cmdCooldowns) then
							player.cmdCooldowns = {}
						end

						local cmdCD = player.cmdCooldowns[cmdID]

						if (cmdCD) then
							if (cmdCD > curTime) then
								Schema:EasyText(player, "peru", "You cannot use this command for another "..math.Round(cmdCD - curTime).." seconds.")

								return false
							end
						end

						player.cmdCooldowns[cmdID] = curTime + commandTable.cooldown
					end

					for k, v in pairs(arguments) do
						arguments[k] = Clockwork.kernel:Replace(arguments[k], " ' ", "'")
						arguments[k] = Clockwork.kernel:Replace(arguments[k], " : ", ":")
					end

					if (hook.Run("PlayerCanUseCommand", player, commandTable, arguments)) then
						if (#arguments >= commandTable.arguments) then
							if ((Clockwork.player:HasFlags(player, commandTable.access) and ((!commandTable.faction)
							or (commandTable.faction and (commandTable.faction == player:GetFaction())
							or (istable(commandTable.faction) and table.HasValue(commandTable.faction, player:GetFaction())))))
							or player:HasPermission(commandTable.uniqueID)) then
								local flags = commandTable.flags

								if (Clockwork.player:GetDeathCode(player, true)) then
									if (flags == 0 and CMD_DEATHCODE == 0) then
										Clockwork.player:TakeDeathCode(player)
									end
								end

								if (bit.band(flags, CMD_DEAD) > 0 and !player:Alive()) then
									if (!player.cwDeathCodeAuth) then
										Schema:EasyText(player, "darkgrey", "You cannot do this action at the moment!")
									end return
								elseif (bit.band(flags, CMD_VEHICLE) > 0 and player:InVehicle()) then
									if (!player.cwDeathCodeAuth) then
										Schema:EasyText(player, "darkgrey", "You cannot do this action at the moment!")
									end return
								elseif (bit.band(flags, CMD_RAGDOLLED) > 0 and player:IsRagdolled()) then
									if (!player.cwDeathCodeAuth) then
										Schema:EasyText(player, "darkgrey", "You cannot do this action at the moment!")
									end return
								elseif (bit.band(flags, CMD_FALLENOVER) > 0 and player:GetRagdollState() == RAGDOLL_FALLENOVER) then
									if (!player.cwDeathCodeAuth) then
										Schema:EasyText(player, "darkgrey", "You cannot do this action at the moment!")
									end return
								elseif (bit.band(flags, CMD_KNOCKEDOUT) > 0 and player:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
									if (!player.cwDeathCodeAuth) then
										Schema:EasyText(player, "darkgrey", "You cannot do this action at the moment!")
									end return
								end

								if (commandTable.OnRun) then
									local bSuccess, value = pcall(commandTable.OnRun, commandTable, player, arguments)

									if (!bSuccess) then
										MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Command]\nThe '"..commandTable.name.."' command has failed to run.\n"..value.."\n")
									elseif (Clockwork.player:GetDeathCode(player, true)) then
										Clockwork.player:UseDeathCode(player, commandTable.name, arguments)
									end

									if (bSuccess) then
										if (!commandTable.logless) then
											if (table.concat(arguments, " ") != "") then
												Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name(true).." has used '"..commandPrefix..commandTable.name.." "..table.concat(arguments, " ").."'.")
											else
												Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name(true).." has used '"..commandPrefix..commandTable.name.."'.")
											end
										end;

										return value
									end

									hook.Run("PostCommandUsed", player, commandTable, arguments)
								end
							else
								Schema:EasyText(player, "firebrick", "You do not have access to this command, "..player:SteamName()..".")
							end
						else
							Schema:EasyText(player, "tomato", commandTable.name.." "..commandTable.text.."!")
						end
					end
				elseif (!Clockwork.player:GetDeathCode(player, true)) then
					Schema:EasyText(player, "darkgrey", "This is not a valid command or alias!")
				end
			elseif (!Clockwork.player:GetDeathCode(player, true)) then
				Schema:EasyText(player, "darkgrey", "This is not a valid command or alias!")
			end

			if (Clockwork.player:GetDeathCode(player)) then
				Clockwork.player:TakeDeathCode(player)
			end
		else
			Schema:EasyText(player, "peru", "You cannot use commands yet!")
		end
	end

	concommand.Add("cwCmd", function(player, command, arguments)
		Clockwork.command:ConsoleCommand(player, command, arguments)
	end)

	hook.Add("PlayerInitialSpawn", "Clockwork.command:PlayerInitialSpawn", function(player)
		local hiddenCommands = {}

		for k, v in pairs(hidden) do
			hiddenCommands[#hiddenCommands + 1] = Clockwork.kernel:GetShortCRC(k)
		end

		netstream.Start(player, "HiddenCommands", hiddenCommands)
	end)
else
	function Clockwork.command:AddHelp(commandTable)
		if (_G["ClockworkClientsideBooted"]) then return end

		local text = string.gsub(string.gsub(commandTable.text, ">", "&gt;"), "<", "&lt;")

		if (!commandTable.helpID) then
			commandTable.helpID = Clockwork.directory:AddCode("Commands", [[
				<div class="cwTitleSeperator">
					$command_prefix$]]..string.upper(commandTable.name)..[[
				</div>
				<div class="cwContentText">
					<div class="cwCodeText">
						<i>]]..text..[[</i>
					</div>
					]]..commandTable.tip..[[
				</div>
				<br>
			]], true, commandTable.name)
		end
	end

	-- A function to remove a command's help.
	function Clockwork.command:RemoveHelp(commandTable)
		if (commandTable.helpID) then
			Clockwork.directory:RemoveCode("Commands", commandTable.helpID)
			commandTable.helpID = nil
		end
	end
end
