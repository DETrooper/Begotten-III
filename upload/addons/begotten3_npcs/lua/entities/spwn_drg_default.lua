ENT.Base = "base_entity"
ENT.Type = "point"
ENT.IsDrGSpawner = true

-- Misc --
ENT.PrintName = "Spawner"
ENT.Category = "DrGBase"

-- Spawner --
ENT.ToSpawn = {}
ENT.AutoRemove = true
ENT.Radius = 0
ENT.Quantity = 0
ENT.Delay = 0

if SERVER then
	AddCSLuaFile()

	-- Init/Think --

	function ENT:Initialize()
		self._DrGBaseToSpawn = {}
		self._DrGBaseRadius = 0
		self._DrGBaseQuantity = 0
		self._DrGBaseDelay = 0
		self._DrGBaseSpawnedEntities = {}
		self:SetRadius(self.Radius)
		self:SetQuantity(self.Quantity)
		self:SetDelay(self.Delay)
		self:EnableAutoRemove(self.AutoRemove)
		for key, val in pairs(self.ToSpawn) do
			if isstring(key) and isnumber(val) then
				self:AddToSpawn(key, val)
			elseif isnumber(key) and isstring(val) then
				self:AddToSpawn(val, 1)
			end
		end
		self.Spawning = coroutine.create(function()
			self:SpawningCoroutine()
		end)
	end
	function ENT:_BaseInitialize() end
	function ENT:CustomInitialize() end

	function ENT:Think()
		if not self.Spawning then return end
		local ok, args = coroutine.resume(self.Spawning)
		if not ok then
			self.Spawning = nil
			ErrorNoHalt(self, " Error: ", args, "\n")
		end
		self:_BaseThink()
		self:CustomThink()
	end
	function ENT:_BaseThink() end
	function ENT:CustomThink() end

	function ENT:SpawningCoroutine()
		while true do
			if #self._DrGBaseToSpawn > 0 and
			#self._DrGBaseSpawnedEntities < self:GetQuantity() then
				local class = self._DrGBaseToSpawn[math.random(#self._DrGBaseToSpawn)]
				if self:BeforeSpawn(class) ~= false then
					local ent = ents.Create(class)
					if IsValid(ent) then
						ent:SetPos(self:GetPos())
						ent:SetPos(ent:DrG_RandomPos(self:GetRadius()))
						ent:Spawn()
						if self:AfterSpawn(ent) ~= false then
							table.insert(self._DrGBaseSpawnedEntities, ent)
							if self:EnableAutoRemove() then self:DeleteOnRemove(ent) end
							ent:CallOnRemove("DrGBaseSpawnerRemove", function(ent)
								if not IsValid(self) then return end
								table.RemoveByValue(self._DrGBaseSpawnedEntities, ent)
							end)
							coroutine.wait(self:GetDelay())
						else
							ent:Remove()
							coroutine.yield()
						end
					else coroutine.yield() end
				else coroutine.yield() end
			else coroutine.yield() end
		end
	end

	-- Spawner functions --

	function ENT:AddToSpawn(class, nb)
		self:RemoveToSpawn(class)
		if not isnumber(nb) or nb < 1 then nb = 1 end
		if nb <= 0 then return end
		if istable(class) then
			for i, clas in ipairs(class) do self:AddToSpawn(clas, nb) end
		elseif isstring(class) then
			class = string.lower(class)
			for i = 1, math.floor(nb) do table.insert(self._DrGBaseToSpawn, class) end
		end
	end
	function ENT:RemoveToSpawn(class)
		if istable(class) then
			for i, clas in ipairs(class) do self:RemoveToSpawn(clas) end
		elseif isstring(class) then
			table.RemoveByValue(self._DrGBaseToSpawn, string.lower(class))
		end
	end

	function ENT:GetSpawned()
		return self._DrGBaseSpawnedEntities
	end

	function ENT:GetRadius()
		return self._DrGBaseRadius
	end
	function ENT:SetRadius(radius)
		if not isnumber(radius) then return end
		self._DrGBaseRadius = math.Clamp(radius, 0, math.huge)
	end

	function ENT:GetQuantity()
		return self._DrGBaseQuantity
	end
	function ENT:SetQuantity(quantity)
		if not isnumber(quantity) then return end
		self._DrGBaseQuantity = math.Clamp(quantity, 0, math.huge)
	end

	function ENT:GetDelay()
		return self._DrGBaseDelay
	end
	function ENT:SetDelay(delay)
		if not isnumber(delay) then return end
		self._DrGBaseDelay = math.Clamp(delay, 0, math.huge)
	end

	function ENT:EnableAutoRemove(autoremove)
		if autoremove == nil then return self._DrGBaseAutoRemove or false
		else self._DrGBaseAutoRemove = tobool(autoremove) end
	end

	-- Spawner hooks --

	function ENT:BeforeSpawn() end
	function ENT:AfterSpawn() end

end
