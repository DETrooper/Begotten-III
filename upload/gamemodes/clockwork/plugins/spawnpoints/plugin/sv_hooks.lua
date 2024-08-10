--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when Clockwork has loaded all of the entities.
function cwSpawnPoints:ClockworkInitPostEntity()
	self:LoadSpawnPoints()
end

-- Called when a player spawns.
function cwSpawnPoints:PlayerSpawn(player)
	if (player:HasInitialized()) then
		local position = nil
		local rotate = nil
		local randomSpawn = nil
		local faction = player:GetFaction()
		local class = Clockwork.class:FindByID(player:Team())
		local spawnPos = player:GetCharacterData("SpawnPoint")
		local spawnPosMap;
		
		if spawnPos then
			spawnPosMap = spawnPos.map;
		end
		
		if (!config.GetVal("spawn_where_left") or !spawnPos or (spawnPosMap and spawnPosMap ~= game.GetMap())) then
			if Clockwork.trait then
				local plyTraits = player:GetTraits() or {};
				
				for i = 1, #plyTraits do
					local trait = plyTraits[i];
					
					if self.spawnPoints[trait] and #self.spawnPoints[trait] > 0 then
						randomSpawn = math.random(1, #self.spawnPoints[trait])
						
						if self.spawnPoints[trait][randomSpawn] then
							position = self.spawnPoints[trait][randomSpawn].position
							rotate = self.spawnPoints[trait][randomSpawn].rotate

							if (position) then
								player:SetPos(position + Vector(0, 0, 8))
							end

							if (rotate) then
								player:SetEyeAngles(Angle(0, rotate, 0))
							end
						end
					end
				end
			end
				
			if (!position) and (class) then
				if (self.spawnPoints[class.name] and #self.spawnPoints[class.name] > 0) then
					randomSpawn = math.random(1, #self.spawnPoints[class.name])
					
					if self.spawnPoints[class.name][randomSpawn] then
						position = self.spawnPoints[class.name][randomSpawn].position
						rotate = self.spawnPoints[class.name][randomSpawn].rotate

						if (position) then
							player:SetPos(position + Vector(0, 0, 8))
						end

						if (rotate) then
							player:SetEyeAngles(Angle(0, rotate, 0))
						end
					end
				end
			end

			if (!position) then
				if (self.spawnPoints[faction] and #self.spawnPoints[faction] > 0) then
					randomSpawn = math.random(1, #self.spawnPoints[faction])
					
					if self.spawnPoints[faction][randomSpawn] then
						position = self.spawnPoints[faction][randomSpawn].position
						rotate = self.spawnPoints[faction][randomSpawn].rotate

						if (position) then
							player:SetPos(position + Vector(0, 0, 8))
						end

						if (rotate) then
							player:SetEyeAngles(Angle(0, rotate, 0))
						end
					end
				elseif (self.spawnPoints["default"]) then
					if (#self.spawnPoints["default"] > 0) then
						randomSpawn = math.random(1, #self.spawnPoints["default"])
						
						if self.spawnPoints["default"][randomSpawn] then
							position = self.spawnPoints["default"][randomSpawn].position
							rotate = self.spawnPoints["default"][randomSpawn].rotate

							if (position) then
								player:SetPos(position + Vector(0, 0, 8))
							end

							if (rotate) then
								player:SetEyeAngles(Angle(0, rotate, 0))
							end
						end
					end
				end
			end
		end

		if (player:IsAdmin()) then
			netstream.Heavy(player, "SpawnPointESPSync", self:GetSpawnPoints())
		end
	end
end

local groupCheck = {
	owner = true,
	superadmin = true,
	admin = true,
	operator = true
}

-- Called when a player's usergroup has been set.
function cwSpawnPoints:OnPlayerUserGroupSet(player, usergroup)
	if (groupCheck[string.lower(usergroup)]) then
		netstream.Heavy(player, "SpawnPointESPSync", self:GetSpawnPoints())
	end
end