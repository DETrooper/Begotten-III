--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local invalid_zones = {"sea_rough", "sea_calm", "sea_styx", "gore_hallway", "gore_tree", "toothboy"};

-- Called right before a player's character has unloaded.
function cwSpawnSaver:PrePlayerCharacterUnloaded(player)
	if (config.Get("spawn_where_left"):Get() and hook.Run("ShouldSavePlayerSpawn", player) != false and player:Alive() and player:IsOnGround() and !player.cwObserverMode and not player.opponent) then
		local lastZone = player:GetCharacterData("LastZone");
		
		-- Make sure player isn't in a zone we wouldn't want them spawning in and make sure they're not in a duel.
		if lastZone and not table.HasValue(invalid_zones, lastZone) then
			local position = player:GetPos()
			local posTable = {
				map = game.GetMap(),
				x = position.x,
				y = position.y,
				z = position.z,
				angles = player:EyeAngles()
			}

			player:SetCharacterData("SpawnPoint", posTable)
		else
			player:SetCharacterData("SpawnPoint", nil)
		end
	end
end

function cwSpawnSaver:OnMapChange(newMap)
	for k, v in ipairs(_player.GetAll()) do
		self:PrePlayerCharacterUnloaded(v)
	end
end

function cwSpawnSaver:PreSaveData()
	local players = _player.GetAll();

	for k, v in pairs(players) do
		self:PrePlayerCharacterUnloaded(v)
	end
end

-- Called just after a player spawns.
function cwSpawnSaver:PostPlayerSpawn(player, bLightSpawn, bChangeClass, bFirstSpawn)
	if !bLightSpawn and not player.opponent then
		local spawnPos = player:GetCharacterData("SpawnPoint")

		if (spawnPos and config.GetVal("spawn_where_left")) then
			if (spawnPos.map == game.GetMap()) then
				player:SetPos(Vector(spawnPos.x, spawnPos.y, spawnPos.z + 8))
				player:SetEyeAngles(Angle(0, spawnPos.angles.yaw, 0));
			end
		end
	end
end

--[[function cwSpawnSaver:PlayerDeath(player)
	player:SetCharacterData("SpawnPoint", nil);
end]]--