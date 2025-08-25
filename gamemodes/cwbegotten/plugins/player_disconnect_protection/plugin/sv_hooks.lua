
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

function cwPlayerDisconnectProtection:PlayerCanUseCharacter(client, character)
	if (client:GetClockworkUserGroup() != "user" or (client.cwWithoutBodyDiscAfter or 0) < CurTime()) then
		return
	end

	return "You cannot switch to this character as you have taken damage recently!"
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