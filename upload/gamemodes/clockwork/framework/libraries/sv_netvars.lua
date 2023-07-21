--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (netvars) then return end

library.New("netvars", _G)

local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

local stored = {}
local globals = {}

-- Check if there is an attempt to send a function. Can't send those.
local function checkBadType(name, object)
	local objectType = type(object)

	if (objectType == "function") then
		ErrorNoHalt("Net var '"..name.."' contains a bad object type!\n")

		return true
	elseif (objectType == "table") then
		for k, v in pairs(object) do
			-- Check both the key and the value for tables, and has recursion.
			if (checkBadType(name, k) or checkBadType(name, v)) then
				return true
			end
		end
	end
end

function netvars.SetNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
	if (netvars.GetNetVar(key) == value) then return end
	if (globals[key] == value) then return end

	globals[key] = value
	netstream.Start(receiver, "gVar", key, value)
end

function netvars.AreEqual(old, new)
	if (istable(old) and istable(new)) then
		return Clockwork.kernel:AreTablesEqual(old, new), "table"
	elseif (old == new) then
		return true
	end

	return false
end

function playerMeta:SyncVars()
	for entity, data in pairs(stored) do
		if (IsValid(entity)) then
			for k, v in pairs(data) do
				netstream.Start(self, "nVar", entity:EntIndex(), k, v)
			end
		end
	end

	for k, v in pairs(globals) do
		netstream.Start(self, "gVar", k, v)
	end
end

function entityMeta:SendNetVar(key, receiver)
	netstream.Heavy(receiver, "nVar", self:EntIndex(), key, stored[self] and stored[self][key])
end

function entityMeta:ClearNetVars(receiver)
	stored[self] = nil
	netstream.Start(receiver, "nDel", self:EntIndex())
end

function entityMeta:SetNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
	if (!istable(value) and value == self:GetNetVar(key)) then return end

	stored[self] = stored[self] or {}
	stored[self][key] = value

	self:SendNetVar(key, receiver)
end

function entityMeta:GetNetVar(key, default)
	if (stored[self] and stored[self][key] != nil) then
		return stored[self][key]
	end

	return default
end

function playerMeta:SetLocalVar(key, value)
	if (checkBadType(key, value)) then return end

	stored[self] = stored[self] or {}
	stored[self][key] = value

	netstream.Start(self, "nLcl", key, value)
end

playerMeta.GetLocalVar = entityMeta.GetNetVar

function netvars.GetNetVar(key, default)
	local value = globals[key]

	return value != nil and value or default
end

hook.Add("EntityRemoved", "nCleanUp", function(entity)
	entity:ClearNetVars()
end)

hook.Add("PlayerInitialSpawn", "nSync", function(client)
	client:SyncVars()
end)