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

--[[
netstream.Hook("nVar", function(index, key, value)
	stored[index] = stored[index] or {}
	stored[index][key] = value
end)

netstream.Hook("nDel", function(index)
	stored[index] = nil
end)

netstream.Hook("nLcl", function(key, value)
	stored[LocalPlayer():EntIndex()] = stored[LocalPlayer():EntIndex()] or {}
	stored[LocalPlayer():EntIndex()][key] = value
end)

netstream.Hook("gVar", function(key, value)
	globals[key] = value
end)
]]--

net.Receive("nVar", function()
	local index = net.ReadUInt(14);
	local key = net.ReadString()
	local value = net.ReadType()

	stored[index] = stored[index] or {}
	stored[index][key] = value
end)

net.Receive("nDel", function()
	local index = net.ReadUInt(14);

	stored[index] = nil
end)

net.Receive("nLcl", function()
	local key = net.ReadString()
	local value = net.ReadType()

	stored[LocalPlayer():EntIndex()] = stored[LocalPlayer():EntIndex()] or {}
	stored[LocalPlayer():EntIndex()][key] = value
end)

net.Receive("gVar", function()
	local key = net.ReadString()
	local value = net.ReadType()

	globals[key] = value
end)

function netvars.GetNetVar(key, default)
	local value = globals[key]

	return value != nil and value or default
end

function entityMeta:SetNetVar(key, value)
	local index = self:EntIndex()

	stored[index] = stored[index] or {}
	stored[index][key] = value
end

function entityMeta:SetLocalVar(key, value)
	self:SetNetVar(key, value);
end

function entityMeta:GetNetVar(key, default)
	local storedIndex = stored[self:EntIndex()];

	if (storedIndex) then
		return storedIndex[key] or default;
	end

	return default
end

playerMeta.GetNetVar = entityMeta.GetNetVar
playerMeta.GetLocalVar = entityMeta.GetNetVar