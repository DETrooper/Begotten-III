--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("faction", Clockwork)

Clockwork.faction.stored = Clockwork.faction.stored or {};
Clockwork.faction.buffer = Clockwork.faction.buffer or {};

function Clockwork.faction:GetStored()
	return self.stored
end

function Clockwork.faction:GetBuffer()
	return self.buffer
end

FACTION_CITIZENS_FEMALE = {
	"models/begotten/wanderers/wanderer/female_01.mdl",
	"models/begotten/wanderers/wanderer/female_02.mdl",
	"models/begotten/wanderers/wanderer/female_04.mdl",
	"models/begotten/wanderers/wanderer/female_05.mdl",
	"models/begotten/wanderers/wanderer/female_06.mdl",
	"models/begotten/wanderers/wanderer/female_32.mdl"
}

FACTION_CITIZENS_MALE = {
	"models/begotten/wanderers/wanderer/male_01.mdl",
	"models/begotten/wanderers/wanderer/male_02.mdl",
	"models/begotten/wanderers/wanderer/male_03.mdl",
	"models/begotten/wanderers/wanderer/male_04.mdl",
	"models/begotten/wanderers/wanderer/male_05.mdl",
	"models/begotten/wanderers/wanderer/male_06.mdl",
	"models/begotten/wanderers/wanderer/male_07.mdl",
	"models/begotten/wanderers/wanderer/male_08.mdl",
	"models/begotten/wanderers/wanderer/male_09.mdl",
	"models/begotten/wanderers/wanderer/male_11.mdl",
	"models/begotten/wanderers/wanderer/male_12.mdl",
	"models/begotten/wanderers/wanderer/male_13.mdl",
	"models/begotten/wanderers/wanderer/male_16.mdl",
	"models/begotten/wanderers/wanderer/male_22.mdl",
	"models/begotten/wanderers/wanderer/male_56.mdl"
}

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE}

-- A function to register a new faction.
function CLASS_TABLE:Register()
	return Clockwork.faction:Register(self, self.name)
end

-- A function to get a new faction.
function Clockwork.faction:New(name)
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE)
		object.name = name or "Unknown"
	return object
end

-- A function to register a new faction.
function Clockwork.faction:Register(data, name)
	if (data.models) then
		data.models.female = data.models.female or FACTION_CITIZENS_FEMALE;
		data.models.male = data.models.male or FACTION_CITIZENS_MALE;
	else
		data.models = {
			female = FACTION_CITIZENS_FEMALE,
			male = FACTION_CITIZENS_MALE
		}
		
		if (data.subfactions) and data.subfactions[1].models then
			data.models.female = data.subfactions[1].models.female or FACTION_CITIZENS_FEMALE;
			data.models.male = data.subfactions[1].models.male or FACTION_CITIZENS_MALE;
		end
	end

	data.limit = data.limit or 128
	data.index = Clockwork.kernel:GetShortCRC(name)
	data.name = data.name or name

	self.buffer[data.index] = data
	self.stored[data.name] = data

	if (SERVER and !_G["cwSharedBooted"]) then
		if (data.models) then
			for k, v in pairs(data.models.female) do
				Clockwork.kernel:AddFile(v)
			end

			for k, v in pairs(data.models.male) do
				Clockwork.kernel:AddFile(v)
			end
		end

		if (data.material) then
			Clockwork.kernel:AddFile("materials/"..data.material..".png")
		end
	end

	return data.name
end

-- A function to get the faction limit.
function Clockwork.faction:GetLimit(name)
	local faction = Clockwork.faction:FindByID(name)

	if (faction) then
		if (faction.limit != 128) then
			return math.ceil(faction.limit / (128 / _player.GetCount()))
		else
			return game.MaxPlayers()
		end
	else
		return 0
	end
end

-- A function to get whether a gender is valid.
function Clockwork.faction:IsGenderValid(faction, gender)
	local factionTable = Clockwork.faction:FindByID(faction)

	if (factionTable and (gender == GENDER_MALE or gender == GENDER_FEMALE)) then
		if (!factionTable.singleGender or gender == factionTable.singleGender) then
			return true
		end
	end
end

-- A function to get whether a model is valid.
function Clockwork.faction:IsModelValid(faction, gender, model)
	if (gender and model) then
		local factionTable = Clockwork.faction:FindByID(faction)

		if factionTable then
			if table.HasValue(factionTable.models[string.lower(gender)], model) then
				return true;
			elseif factionTable.subfactions then
				for i = 1, #factionTable.subfactions do
					if table.HasValue(factionTable.subfactions[i].models[string.lower(gender)], model) then
						return true;
					end
				end
			end
		end
	end
end

-- A function to find a faction by an identifier.
function Clockwork.faction:FindByID(identifier)
	if (!identifier) then return end
	
	if (tonumber(identifier)) then
		return self.buffer[tonumber(identifier)]
	elseif (self.stored[identifier]) then
		return self.stored[identifier]
	else
		local shortest = nil
		local shortestLength = math.huge
		local lowerIdentifier = string.lower(identifier)

		for k, v in pairs(Clockwork.faction:GetAll())do
			if (string.find(string.lower(k), lowerIdentifier)
				and string.utf8len(k) < shortestLength) then
				shortestLength = string.utf8len(k)
				shortest = v
			end
		end

		return shortest
	end
end

-- A function to get all factions.
function Clockwork.faction:GetAll()
	return self.stored
end

-- A function to get each player in a faction.
function Clockwork.faction:GetPlayers(faction)
	local players = {}

	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:GetFaction() == faction) then
				players[#players + 1] = v
			end
		end
	end

	return players
end

-- A function to get the rank with the lowest 'position' (highest rank) in this faction.
function Clockwork.faction:GetHighestRank(factionID)
	local faction = Clockwork.faction:FindByID(factionID)

	if (istable(faction.ranks)) then
		local lowestPos
		local highestRank
		local rankTable

		for k, v in pairs(faction.ranks) do
			if (!lowestPos) then
				lowestPos = v.position
				rankTable = v
				highestRank = k
			else
				if (v.position) then
					if (math.min(lowestPos, v.position) == v.position) then
						highestRank = k
						rankTable = v
						lowestPos = v.position
					end
				end
			end
		end

		return highestRank, rankTable
	end
end

-- A function to get the rank with the highest 'position' (lowest rank) in this faction.
function Clockwork.faction:GetLowestRank(factionID)
	local faction = Clockwork.faction:FindByID(factionID)

	if (istable(faction.ranks)) then
		local highestPos
		local lowestRank
		local rankTable

		for k, v in pairs(faction.ranks) do
			if (!highestPos) then
				highestPos = v.position
				lowestRank = k
				rankTable = v
			else
				if (v.position) then
					if (math.max(highestPos, v.position) == v.position) then
						lowestRank = k
						rankTable = v
						highestPos = v.position
					end
				end
			end
		end

		return lowestRank, rankTable
	end
end

-- A function to get the rank with the next lowest 'position' (next highest rank).
function Clockwork.faction:GetHigherRank(factionID, rank)
	local highestRank, rankTable = self:GetHighestRank(factionID)

	factionID = Clockwork.faction:FindByID(factionID)

	if (istable(faction.ranks) and istable(rank) and rank.position and rank.position != rankTable.position) then
		for k, v in pairs(faction.ranks) do
			if (v.position == (rank.position - 1)) then
				return k, v
			end
		end
	end
end

-- A function to get the rank with the next highest 'position' (next lowest rank).
function Clockwork.faction:GetLowerRank(factionID, rank)
	local lowestRank, rankTable = self:GetLowestRank(factionID)

	factionID = self:FindByID(factionID)

	if (istable(factionID.ranks) and istable(rank) and rank.position and rank.position != rankTable.position) then
		for k, v in pairs(factionID.ranks) do
			if (v.position == (rank.position + 1)) then
				return k, v
			end
		end
	end
end

-- A function to get the default rank of a faction.
function Clockwork.faction:GetDefaultRank(factionID)
	local faction = Clockwork.faction:FindByID(factionID)

	if (istable(faction.ranks)) then
		local lowestPos
		local highestRank

		for k, v in pairs(faction.ranks) do
			if (v.default) then
				return k, v
			end
		end
	end
end

if (SERVER) then
	function Clockwork.faction:HasReachedMaximum(player, factionID)
		local factionTable = Clockwork.faction:FindByID(factionID)
		local characters = player:GetCharacters()

		if (factionTable and factionTable.maximum) then
			local totalCharacters = 0

			for k, v in pairs(characters) do
				if (v.faction == factionTable.name) then
					totalCharacters = totalCharacters + 1
				end
			end

			if (totalCharacters >= factionTable.maximum) then
				return true
			end
		end
	end
else
	function Clockwork.faction:HasReachedMaximum(factionID)
		local factionTable = Clockwork.faction:FindByID(factionID)
		local characters = Clockwork.character:GetAll()

		if (factionTable and factionTable.maximum) then
			local totalCharacters = 0

			for k, v in pairs(characters) do
				if (v.faction == factionTable.name) then
					totalCharacters = totalCharacters + 1
				end
			end

			if (totalCharacters >= factionTable.maximum) then
				return true
			end
		end
	end
end

_faction = faction