--[[
	Begotten III: Jesus Wept
--]]

--cwTempSpawns.spawnPoints = {};

-- Called just after a player spawns.
function cwTempSpawns:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) and (player:HasInitialized()) then
		local position = nil
		local rotate = nil
		local randomSpawn = nil
		local faction = player:GetFaction()

		if not self.spawnPoints then
			self.spawnPoints = {};
		end
		
		if (self.spawnPoints[faction] and #self.spawnPoints[faction] > 0) then
			randomSpawn = math.random(1, #self.spawnPoints[faction])
			position = self.spawnPoints[faction][randomSpawn].position
			rotate = self.spawnPoints[faction][randomSpawn].rotate

			if (position) then
				player:SetPos(position + Vector(0, 0, 8))
			end

			if (rotate) then
				player:SetEyeAngles(Angle(0, rotate, 0))
			end
		elseif (self.spawnPoints["default"]) then
			if (#self.spawnPoints["default"] > 0) then
				randomSpawn = math.random(1, #self.spawnPoints["default"])
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
	end;
end;