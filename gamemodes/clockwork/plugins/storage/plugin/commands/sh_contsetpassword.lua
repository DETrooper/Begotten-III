--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local COMMAND = Clockwork.command:New("ContSetPassword")
COMMAND.tip = "Set a container's password."
COMMAND.text = "<string Pass>"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			local model = string.lower(trace.Entity:GetModel())

			if (cwStorage.containerList[model]) then
				if cwStaticEnts then
					for k, v in pairs(cwStaticEnts.staticEnts) do
						if (trace.Entity == v) then
							Schema:EasyText(player, "grey", "["..self.name.."] You cannot set passwords on static prop containers! Note that passworded containers are already persistent.");

							return;
						end;
					end;
				end
			
				if (!trace.Entity.cwInventory) then
					cwStorage.storage[trace.Entity] = trace.Entity
					trace.Entity.cwInventory = {}
				end

				trace.Entity.cwPassword = table.concat(arguments, " ")
				trace.Entity.cwLockTier = 3;
				trace.Entity:SetNWBool("hasPassword", true);
				trace.Entity:SetNWBool("unlocked", false);
				cwStorage:SaveStorage()

				Schema:EasyText(player, "cornflowerblue", "["..self.name.." This container's password has been set to '"..trace.Entity.cwPassword.."'.")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContGetPassword")
COMMAND.tip = "Get a container's password."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
			if (trace.Entity.cwPassword) then
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] This container's password is '"..trace.Entity.cwPassword.."'.")
			else
				Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container or it does not have a password!")
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid container!")
	end
end

COMMAND:Register()

local COMMAND = Clockwork.command:New("ContForceOpen")
COMMAND.tip = "Open a container without the password."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor()

	if (IsValid(trace.Entity) and Clockwork.entity:IsPhysicsEntity(trace.Entity)) then
		local model = string.lower(trace.Entity:GetModel())

		if (cwStorage.containerList[model]) then
			local containerWeight = cwStorage.containerList[model][1]

			cwStorage:OpenContainer(player, trace.Entity, containerWeight, true)
		end
	end
end

COMMAND:Register()