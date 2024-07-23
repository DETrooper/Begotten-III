--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local cwSpawnPoints = cwSpawnPoints
local spawnPointData

--Called when the plugin is initialized.
function cwSpawnPoints:Initialize()
	Clockwork.ConVars.SPAWNPOINTESP = Clockwork.kernel:CreateClientConVar("cwSpawnPointESP", 0, true, true)

	Clockwork.setting:AddCheckBox("Admin ESP", "Show Spawn Points.", "cwSpawnPointESP", "Whether or not to show spawn points in the admin ESP.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client)
	end)
end

local colorWhite = Color(255, 255, 255, 255)
local colorViolet = Color(180, 100, 255, 255)
local spawnColor

-- Called when the ESP info is needed.
function cwSpawnPoints:GetAdminESPInfo(info)
	if (Clockwork.ConVars.SPAWNPOINTESP:GetInt() == 1 and spawnPointData) then
		for typeName, spawnPoints in pairs(spawnPointData) do
			spawnColor = colorViolet

			for k, class in pairs(Clockwork.class:GetAll()) do
				if (class.factions[1] == typeName or typeName == k) then
					spawnColor = class.color
				end
			end

			for k, v in pairs(spawnPoints) do
				table.insert(info, {
					position = v.position,
					text = {
						{
							text = "SpawnPoint",
							color = colorWhite
						},
						{
							text = string.utf8upper(typeName),
							color = spawnColor
						}
					}
				})
			end
		end
	end
end

-- Called to sync up the ESP data from the server.
netstream.Hook("SpawnPointESPSync", function(data)
	spawnPointData = data
end)