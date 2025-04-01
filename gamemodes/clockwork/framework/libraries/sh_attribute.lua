--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("attribute", Clockwork)

local stored = Clockwork.attribute.stored or {}
local buffer = Clockwork.attribute.buffer or {}
Clockwork.attribute.stored = stored
Clockwork.attribute.buffer = buffer

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE}

-- A function to register a new attribute.
function CLASS_TABLE:Register()
	return Clockwork.attribute:Register(self)
end

-- A function to get a new attribute.
function Clockwork.attribute:New(name)
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE)
		object.name = name or "Unknown"
	return object
end

-- A function to get the attribute buffer.
function Clockwork.attribute:GetBuffer()
	return buffer
end

-- A function to get all attributes.
function Clockwork.attribute:GetAll()
	return stored
end

-- A function to register a new attribute.
function Clockwork.attribute:Register(attribute)
	attribute.uniqueID = attribute.uniqueID or string.lower(string.gsub(attribute.name, "%s", "_"))
	attribute.index = Clockwork.kernel:GetShortCRC(attribute.name)
	attribute.cache = {}

	if (!attribute.category) then
		attribute.category = "Attributes"
	end

	for i = -attribute.maximum, attribute.maximum do
		attribute.cache[i] = {}
	end

	stored[attribute.uniqueID] = attribute
	buffer[attribute.index] = attribute

	if (SERVER and attribute.image) then
		Clockwork.kernel:AddFile("materials/"..attribute.image..".png")
	end

	return attribute.uniqueID
end

-- A function to find an attribute by an identifier.
function Clockwork.attribute:FindByID(identifier)
	if (!identifier) then return end

	if (buffer[identifier]) then
		return buffer[identifier]
	elseif (stored[identifier]) then
		return stored[identifier]
	end

	local tAttributeTab = nil

	for k, v in pairs(stored) do
		if (string.find(string.lower(v.name), string.lower(identifier))) then
			if (tAttributeTab) then
				if (string.utf8len(v.name) < string.utf8len(tAttributeTab.name)) then
					tAttributeTab = v
				end
			else
				tAttributeTab = v
			end
		end
	end

	return tAttributeTab
end