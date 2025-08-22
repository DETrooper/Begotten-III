
cwPlayerDisconnectProtection.playerBodyExistenceAfterDisc = 1200 -- (in seconds)
cwPlayerDisconnectProtection.playerBodyExistenceAddAfterHit = 10 -- (in seconds)
cwPlayerDisconnectProtection.playerBodies = cwPlayerDisconnectProtection.playerBodies or {}

local function CreatePlayerBody(client, curTime)
	local playerBody = ents.Create("cw_player_body")
	playerBody:SetPos(client:GetPos())
	playerBody:SetAngles(client:GetAngles())
	playerBody:Spawn()
	playerBody:Activate()

	playerBody:SetExistenceDuration(client.cwWithoutBodyDiscAfter - curTime)
	playerBody:SetPlayer(client)
end

gameevent.Listen("player_disconnect")
function cwPlayerDisconnectProtection:player_disconnect(data)
	local client = Player(data.userid)
	local curTime = CurTime()

	if (!IsValid(client) or client.opponent) then
		return
	elseif (client:GetClockworkUserGroup() != "user" or
		data.reason != "Disconnect by user." or (client.cwWithoutBodyDiscAfter or 0) < curTime) then
		return
	end

	CreatePlayerBody(client, curTime)
end

-- unfortunately, there is no option to prevent player from loading character
function cwPlayerDisconnectProtection:PrePlayerCharacterUnloaded(client, bIsReload)
	if (bIsReload or client.cwIsDisconnecting) then
		return
	end

	local curTime = CurTime()

	if (!client.opponent and client:GetClockworkUserGroup() == "user"
		and (client.cwWithoutBodyDiscAfter or 0) > curTime) then -- no >= because it is pointless (player body will iterally be removed on the next tick)
		CreatePlayerBody(client, curTime)
	end

	client.cwWithoutBodyDiscAfter = nil
end

function cwPlayerDisconnectProtection:PostPlayerCharacterLoaded(client)
	local charKey = client:GetCharacterKey()
	local playerBody = self.playerBodies[charKey]

	if (playerBody) then
		playerBody:Remove()
	end
end

function cwPlayerDisconnectProtection:PostPlayerSpawn(client)
	client.cwWithoutBodyDiscAfter = nil
end

function cwPlayerDisconnectProtection:PostPlayerDeath(client)
	client.cwWithoutBodyDiscAfter = nil
end

function cwPlayerDisconnectProtection:PostEntityTakeDamage(entity, damageInfo)
	if (!entity:IsPlayer() or !entity:Alive() or entity:GetClockworkUserGroup() != "user" or entity.opponent) then
		return
	end

	local attacker = damageInfo:GetAttacker()

	if (!attacker:IsPlayer() and !attacker:IsNPC() and !attacker:IsNextBot()) then
		return
	end

	entity.cwWithoutBodyDiscAfter = CurTime() + self.playerBodyExistenceAfterDisc
end