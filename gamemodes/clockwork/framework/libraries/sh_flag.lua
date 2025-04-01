--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("flag", Clockwork)

local stored = Clockwork.flag.stored or {}
Clockwork.flag.stored = stored

-- A function to add a new flag.
function Clockwork.flag:Add(flag, name, details)
	stored[flag] = {
		name = name,
		details = details
	}
end

-- A function to get a flag.
function Clockwork.flag:Get(flag)
	return stored[flag]
end

-- A function to get the stored flags.
function Clockwork.flag:GetStored()
	return stored
end

-- A function to get a flag's name.
function Clockwork.flag:GetName(flag, default)
	if (stored[flag]) then
		return stored[flag].name
	else
		return default
	end
end

-- A function to get a flag's details.
function Clockwork.flag:GetDescription(flag, default)
	if (stored[flag]) then
		return stored[flag].details
	else
		return default
	end
end

-- A function to get a flag by it's name.
function Clockwork.flag:GetFlagByName(name, default)
	local lowerName = string.lower(name)

	for k, v in pairs(stored) do
		if (string.lower(v.name) == lowerName) then
			return k
		end
	end

	return default
end