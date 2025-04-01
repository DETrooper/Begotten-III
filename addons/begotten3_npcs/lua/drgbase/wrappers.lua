
-- Wrapper --

local entMETA = FindMetaTable("Entity")

local WRAPPERS = {}
local function NewWrapper(wrapper, ent)
	WRAPPERS[wrapper] = WRAPPERS[wrapper] or {}
	if not WRAPPERS[wrapper][ent] then
		local self = {}
		setmetatable(self, {__index = function(self, key)
			if key == "Wrapper" then return true
			elseif key == "Entity" then return ent
			elseif wrapper[key] ~= nil then return wrapper[key]
			elseif IsValid(ent) and ent:GetTable()[key] ~= nil then
				local val = ent:GetTable()[key]
				if isfunction(val) then
					return function(self, ...)
						return val(ent, ...)
					end
				else return val end
			elseif entMETA[key] ~= nil then
				local val = entMETA[key]
				if isfunction(val) then
					return function(self, ...)
						return val(ent, ...)
					end
				else return val end
			end
		end})
		WRAPPERS[wrapper][ent] = self
		return self
	else return WRAPPERS[wrapper][ent] end
end

local DEFAULT_WRAPPER = {}
function entMETA:DrG_Wrap()
	if SERVER then
		if self:DrG_IsDoor() then
			return DrGBase.WrapDoor(self)
		end
	end
	return NewWrapper(DEFAULT_WRAPPER, self)
end

if SERVER then

	-- Doors --

	local Door = {}
	Door.__index = Door
	function Door:New(ent)
		return NewWrapper(self, ent)
	end

	function Door:GetDouble()
		if not IsValid(self) then return NULL end
		local keyvalues = self:GetKeyValues()
		if isstring(keyvalues.slavename) then
			return ents.FindByName(keyvalues.slavename)[1]
		end
	end
	function Door:IsDouble()
		return IsValid(self:GetDouble())
	end

	function Door:Open(ent)
		if not IsValid(self) then return end
		if IsValid(ent) then
			local name = ent:GetName()
			self:Fire("OpenAwayFrom", name)
			if self:IsDouble() then
				self:GetDouble():Fire("OpenAwayFrom", name)
			end
		else
			self:Fire("Open")
			if self:IsDouble() then
				self:GetDouble():Fire("Open")
			end
		end
	end
	function Door:Close()
		if not IsValid(self) then return end
		self:Fire("Close")
		if self:IsDouble() then
			self:GetDouble():Fire("Close")
		end
	end

	function Door:GetSpeed()
		if not IsValid(self) then return -1 end
		return self:GetKeyValues()["speed"]
	end
	function Door:SetSpeed(speed)
		if not IsValid(self) then return end
		self:Fire("SetSpeed", speed)
		if self:IsDouble() then
			self:GetDouble():Fire("SetSpeed", speed)
		end
	end

	function DrGBase.WrapDoor(ent)
		return Door:New(ent)
	end

	-- CombineBall --

	local CombineBall = {}
	CombineBall.__index = CombineBall
	function CombineBall:New(ent)
		return NewWrapper(CombineBall, ent)
	end

	function CombineBall:Explode()
		self:Fire("Explode")
	end

end
