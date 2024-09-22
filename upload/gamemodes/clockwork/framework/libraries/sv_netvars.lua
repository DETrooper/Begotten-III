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

util.AddNetworkString("nVar")
util.AddNetworkString("nDel")
util.AddNetworkString("nLcl")
util.AddNetworkString("gVar")

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
	--netstream.Start(receiver, "gVar", key, value)
	net.Start("gVar")
		net.WriteString(key)
		net.WriteType(value)
		
	if receiver then
		net.Send(receiver)
		return;
	end
	
	net.Broadcast()
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
				--netstream.Start(self, "nVar", entity:EntIndex(), k, v)
				net.Start("nVar")
					net.WriteUInt(entity:EntIndex(), 14);
					net.WriteString(k)
					net.WriteType(v)
				net.Send(self)
			end
		end
	end

	for k, v in pairs(globals) do
		--netstream.Start(self, "gVar", k, v)
		net.Start("gVar")
			net.WriteString(k)
			net.WriteType(v)
		net.Send(self)
	end
end

function entityMeta:SendNetVar(key, receiver)
	--netstream.Heavy(receiver, "nVar", self:EntIndex(), key, stored[self] and stored[self][key])
	net.Start("nVar")
		net.WriteUInt(self:EntIndex(), 14);
		net.WriteString(key)
		net.WriteType(stored[self] and stored[self][key])
		
	if receiver then
		net.Send(receiver)
		return;
	end
	
	net.Broadcast()
end

function entityMeta:ClearNetVars(receiver)
	if stored[self] then
		stored[self] = nil
		--netstream.Start(receiver, "nDel", self:EntIndex())
		net.Start("nDel")
			net.WriteEntity(self)
			
		if receiver then
			net.Send(receiver)
			return;
		end
		
		net.Broadcast()
	end
end

function entityMeta:SetNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end
	if (!istable(value) and value == self:GetNetVar(key)) then return end

	stored[self] = stored[self] or {}
	stored[self][key] = value

	self:SendNetVar(key, receiver)
end

function entityMeta:SetLocalVar(key, value)
	if !self:IsPlayer() then
		self:SetNetVar(key, value, self);
	
		return;
	end

	if (checkBadType(key, value)) then return end
	if (!istable(value) and value == self:GetNetVar(key)) then return end

	stored[self] = stored[self] or {}
	stored[self][key] = value

	--netstream.Start(self, "nLcl", key, value)
	net.Start("nLcl")
		net.WriteString(key)
		net.WriteType(value)
	net.Send(self)
end


function entityMeta:GetNetVar(key, default)
	local storedIndex = stored[self];

	if (storedIndex) then
		return storedIndex[key] or default;
	end

	return default
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