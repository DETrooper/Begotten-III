
Clockwork.kernel:IncludePrefixed("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local function SaveCharacter(character, steamID, inventory)
	local charactersTable = config.Get("mysql_characters_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local queryObj = Clockwork.database:Update(charactersTable)
		queryObj:Where("_Schema", schemaFolder)
		queryObj:Where("_SteamID", steamID)
		queryObj:Where("_CharacterID", character.characterID)
		if (inventory) then queryObj:Update("_Inventory", util.TableToJSON(inventory)) end
		queryObj:Update("_Data", util.TableToJSON(character.data))
	queryObj:Execute()

	local ply = player.GetBySteamID(steamID)

	if ply then
		ply.cwCharacterList[character.characterID] = character
	end
end

local function DropToGroundAndRotateBySurface(entity, bIsCheck)
	local pos = entity:GetPos()
	local mins, _ = entity:GetCollisionBounds()
	mins.x, mins.y = 0, 0
	mins.z = mins.z * 2

	local trace = util.TraceHull({
		start = pos,
		endpos = pos + mins,
		filter = entity,
		mask = MASK_PLAYERSOLID
	})

	if (!trace.Hit) then
		trace = util.TraceLine({
			start = pos,
			endpos = pos + Vector(0, 0, -1024),
			filter = entity,
			mask = MASK_PLAYERSOLID
		})

		if (!trace.Hit) then
			return
		end

		entity:SetPos(trace.HitPos)
		DropToGroundAndRotateBySurface(entity)
	elseif (!bIsCheck) then
		local angles = entity:GetAngles()
		local surfaceAngle = trace.HitNormal:Angle()
		entity:SetAngles(Angle(surfaceAngle.pitch - 270, angles.yaw, 0))

		if (!entity.bPlayerSetLastTick) then
			angles.pitch, angles.roll = 0, 0

			local character = entity.character
			Clockwork.player:SetOfflineCharacterData(character, "SpawnPoint", {
				map = game.GetMap(),
				x = pos.x,
				y = pos.y,
				z = pos.z,
				angles = angles,
			})
		end
	end
end

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)

	self.removeAfter = -1
	self.nextGroundCheck = -1
	self.nextPainSound = 0.5
	self.bPlayerSetLastTick = nil -- for visualization
	self.playerName = nil -- for visualization
	self.playerSteamID = nil -- for visualization
	self.character = nil -- for visualization
	self.characterKey = nil -- for visualization
	self.characterBounty = nil -- for visualization
	self.health = nil -- for visualization
	self.equipmentSlots = nil -- for visualization
	self.inventory = nil -- for visualization
	self.inventory2 = nil -- for visualization
	self.cash = nil -- for visualization
	self.faction = nil -- for visualization
	self.soundsPitch = nil -- for visualization
	self.painSounds = nil -- for visualization
	self.deathSounds = nil -- for visualization
end

function ENT:SetExistenceDuration(duration)
	self.removeAfter = CurTime() + duration
end

function ENT:SetPlayer(client)
	local model = client:GetModel()
	self:SetModel(model)
	self:SetSkin(client:GetSkin())
	self:SetColor(client:GetColor())
	self:SetMaterial(client:GetMaterial())
	self:SetBodygroup(0, client:GetBodygroup(0))
	self:SetBodygroup(1, client:GetBodygroup(1))

	local clothes

	-- replicating https://github.com/DETrooper/Begotten-III/blob/main/upload/gamemodes/clockwork/framework/libraries/sv_player.lua#L2610
	if (string.find(model, "models/begotten/heads")) then
		local clothesItem = client:GetClothesEquipped()

		if clothesItem and clothesItem.group then
			if clothesItem.genderless then
				clothes = "models/begotten/" .. clothesItem.group .. ".mdl"
			else
				clothes = "models/begotten/" .. clothesItem.group .. "_" .. string.lower(client:GetGender()) .. ".mdl"
			end
		else
			local faction = client:GetNetVar("kinisgerOverride") or client:GetFaction()
			local factionTable = Clockwork.faction:FindByID(faction)

			if factionTable then
				local subfaction = client:GetNetVar("kinisgerOverrideSubfaction") or client:GetSubfaction()

				if subfaction and factionTable.subfactions then
					for i, v in ipairs(factionTable.subfactions) do
						if v.name == subfaction and v.models then
							clothes = v.models[string.lower(client:GetGender())].clothes

							break
						end
					end
				end

				if string.find(model, "models/begotten/heads") then
					clothes = factionTable.models[string.lower(client:GetGender())].clothes
				end
			end
		end
	end

	if (clothes) then
		self:SetClothes(clothes)
	end

	local mins, maxs = self:GetModelRenderBounds()
	local max2D = math.max(mins.x * -1, mins.y * -1, maxs.x, maxs.y)
	mins.x, mins.y, maxs.x, maxs.y = max2D * -1, max2D * -1, max2D, max2D
	maxs.z = mins.z * -4

	local bPhysicsCreated = self:PhysicsInitBox(mins, maxs, "flesh")
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMoveType(MOVETYPE_NONE)

	local faction = (client:GetNetVar("kinisgerOverride") or client:GetFaction())
	self.playerName = client:Name()
	self.playerSteamID = client:SteamID()
	self.character = client:GetCharacter()
	self.characterKey = client:GetCharacterKey()
	self.characterBounty = client:GetCharacterData("bounty")
	self.health = client:Health()
	self.equipmentSlots = table.Copy(client.equipmentSlots)
	self.inventory = client:GetInventory()
	self.inventory2 = table.Copy(self.inventory)
	self.cash = client:GetCash()
	self.faction = faction

	if (bPhysicsCreated) then
		local physicsObject = self:GetPhysicsObject()
		physicsObject:Wake()
		physicsObject:EnableMotion(false)
	end

	if (faction == "Hillkeeper" or faction == "Holy Hierarchy") then
		for _, v in ipairs(ents.FindByClass("npc_drg_animals_wolf")) do
			v:AddEntityRelationship(self, D_LI, 99)
		end
	end

	self.bPlayerSetLastTick = true
	cwPlayerDisconnectProtection.playerBodies[self.characterKey] = self

	-- not precahing it earlier so it will be more readable for anyone who decides to make actual "Get" functions for pain and death sounds (not ones that emit them)
	if (!Clockwork.player:HasFlags(client, "M")) then
		local bIsMale = client:GetGender() == "Male"
		local subfaction = (client:GetNetVar("kinisgerOverrideSubfaction") or client:GetSubfaction())

		if (client:GetSubfaith() == "Voltism" and cwBeliefs and (client:HasBelief("the_storm") or client:HasBelief("the_paradox_riddle_equation"))) then
			self.painSounds {
				"npc/headcrab/die2.wav",
				"npc/headcrab_poison/ph_warning1.wav",
				"npc/headcrab_poison/ph_scream2.wav",
				"npc/antlion/pain1.wav",
				"npc/antlion/pain2.wav",
				"npc/assassin/ball_zap1.wav",
				"npc/barnacle/barnacle_die1.wav",
				"npc/scanner/cbot_discharge1.wav",
				"npc/scanner/cbot_energyexplosion1.wav"
			}
			self.deathSounds = {
				"npc/fast_zombie/wake1.wav",
				"npc/fast_zombie/leap1.wav",
				"npc/fast_zombie/fz_alert_close1.wav",
				"npc/fast_zombie/fz_frenzy1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
				"npc/headcrab_poison/ph_rattle3.wav",
				"npc/headcrab_poison/ph_poisonbite3.wav"
			}

			self.soundsPitch = 150
			return
		elseif (faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers" or (faction == "Holy Hierarchy" and !bIsMale) or (faction == "The Third Inquisition" and !bIsMale)) then
			if (bIsMale) then
				self.painSounds = {
					"voice/man2/man2_pain01.wav",
					"voice/man2/man2_pain02.wav",
					"voice/man2/man2_pain03.wav",
					"voice/man2/man2_pain04.wav",
					"voice/man2/man2_pain05.wav",
					"voice/man2/man2_pain06.wav"
				}
				self.deathSounds = {
					"voice/man2/man2_death01.wav",
					"voice/man2/man2_death02.wav",
					"voice/man2/man2_death03.wav",
					"voice/man2/man2_death04.wav",
					"voice/man2/man2_death05.wav",
					"voice/man2/man2_death06.wav",
					"voice/man2/man2_death07.wav",
					"voice/man2/man2_death08.wav",
					"voice/man2/man2_death09.wav"
				}
			else
				self.painSounds = {
					"voice/female1/female1_pain01.wav",
					"voice/female1/female1_pain02.wav",
					"voice/female1/female1_pain03.wav",
					"voice/female1/female1_pain04.wav",
					"voice/female1/female1_pain05.wav",
					"voice/female1/female1_pain06.wav"
				}
				self.deathSounds = {
					"voice/female1/female1_death01.wav",
					"voice/female1/female1_death02.wav",
					"voice/female1/female1_death03.wav",
					"voice/female1/female1_death04.wav",
					"voice/female1/female1_death05.wav",
					"voice/female1/female1_death06.wav",
					"voice/female1/female1_death07.wav",
					"voice/female1/female1_death08.wav",
					"voice/female1/female1_death09.wav"
				}
			end
		elseif ((faction == "Holy Hierarchy" or faction == "The Third Inquisition") and bIsMale) then
			if (subfaction == "Low Ministry") then
				self.painSounds = {
					"lmpainsounds/lm_pain1.wav",
					"lmpainsounds/lm_pain2.wav",
					"lmpainsounds/lm_pain3.wav",
					"lmpainsounds/lm_pain4.wav",
					"lmpainsounds/lm_pain5.wav",
					"lmpainsounds/lm_pain6.wav"
				}
				self.deathSounds = {
					"lmpainsounds/lm_death1.wav",
					"lmpainsounds/lm_death2.wav",
					"lmpainsounds/lm_death3.wav",
					"lmpainsounds/lm_death4.wav",
					"lmpainsounds/lm_death5.wav",
					"lmpainsounds/lm_death6.wav"
				}
			else
				self.painSounds = {
					"voice/man4/man4_pain01.wav",
					"voice/man4/man4_pain02.wav",
					"voice/man4/man4_pain03.wav",
					"voice/man4/man4_pain04.wav",
					"voice/man4/man4_pain05.wav",
					"voice/man4/man4_pain06.wav"
				}
				self.deathSounds = {
					"voice/man4/man4_death01.wav",
					"voice/man4/man4_death02.wav",
					"voice/man4/man4_death03.wav",
					"voice/man4/man4_death04.wav",
					"voice/man4/man4_death05.wav",
					"voice/man4/man4_death06.wav",
					"voice/man4/man4_death07.wav",
					"voice/man4/man4_death08.wav",
					"voice/man4/man4_death09.wav"
				}
			end
		elseif (!bIsMale) then
			self.painSounds = {
				"voice/female2/female2_pain01.wav",
				"voice/female2/female2_pain02.wav",
				"voice/female2/female2_pain03.wav",
				"voice/female2/female2_pain04.wav",
				"voice/female2/female2_pain05.wav",
				"voice/female2/female2_pain06.wav"
			}
			self.deathSounds = {
				"voice/female2/female2_death01.wav",
				"voice/female2/female2_death02.wav",
				"voice/female2/female2_death03.wav",
				"voice/female2/female2_death04.wav",
				"voice/female2/female2_death05.wav",
				"voice/female2/female2_death06.wav",
				"voice/female2/female2_death07.wav",
				"voice/female2/female2_death08.wav",
				"voice/female2/female2_death09.wav"
			}
		elseif (faction == "Goreic Warrior" or faction == "Smog City Pirates") then
			self.painSounds = {
				"voice/man1/man1_pain01.wav",
				"voice/man1/man1_pain02.wav",
				"voice/man1/man1_pain03.wav",
				"voice/man1/man1_pain04.wav",
				"voice/man1/man1_pain05.wav",
				"voice/man1/man1_pain06.wav"
			}
			self.deathSounds = {
				"voice/man1/man1_death01.wav",
				"voice/man1/man1_death02.wav",
				"voice/man1/man1_death03.wav",
				"voice/man1/man1_death04.wav",
				"voice/man1/man1_death05.wav",
				"voice/man1/man1_death06.wav",
				"voice/man1/man1_death07.wav",
				"voice/man1/man1_death08.wav",
				"voice/man1/man1_death09.wav",
			}
		elseif (faction == "Hillkeeper") then
			self.painSounds = {
				"hkpainsounds/hk_pain1.wav",
				"hkpainsounds/hk_pain2.wav",
				"hkpainsounds/hk_pain3.wav",
				"hkpainsounds/hk_pain4.wav",
				"hkpainsounds/hk_pain5.wav",
				"hkpainsounds/hk_pain6.wav"
			}
			self.deathSounds = {
				"hkpainsounds/hk_death1.wav",
				"hkpainsounds/hk_death2.wav",
				"hkpainsounds/hk_death3.wav",
				"hkpainsounds/hk_death4.wav",
				"hkpainsounds/hk_death5.wav",
				"hkpainsounds/hk_death6.wav",
				"hkpainsounds/hk_death7.wav",
				"hkpainsounds/hk_death8.wav",
				"hkpainsounds/hk_death9.wav"
			}
		else
			self.painSounds = {
				"voice/man3/man3_pain01.wav",
				"voice/man3/man3_pain02.wav",
				"voice/man3/man3_pain03.wav",
				"voice/man3/man3_pain04.wav",
				"voice/man3/man3_pain05.wav",
				"voice/man3/man3_pain06.wav"
			}
			self.deathSounds = {
				"voice/man3/man3_death01.wav",
				"voice/man3/man3_death02.wav",
				"voice/man3/man3_death03.wav",
				"voice/man3/man3_death04.wav",
				"voice/man3/man3_death05.wav",
				"voice/man3/man3_death06.wav",
				"voice/man3/man3_death07.wav",
				"voice/man3/man3_death08.wav",
				"voice/man3/man3_death09.wav"
			}
		end

		if (bIsMale) then
			self.soundsPitch = {95, 110}
		else
			self.soundsPitch = {100, 115}
		end
	end
end

function ENT:OnTakeDamage(damageInfo)
	local character = self.character
	local steamID = self.playerSteamID
	local damage = math.ceil(damageInfo:GetDamage())
	self.health = self.health - damage
	self.removeAfter = self.removeAfter + Clockwork.ConVars.PLY_BODY_EXIST_ADD_ON_HIT:GetInt()

	local attacker = damageInfo:GetAttacker()
	local inflictor = damageInfo:GetInflictor()
	if (self.health > 0) then
		-- TODO: use DamageLog and KillLog hooks on PrintLog calls and make them work without Player entity
		if (IsValid(attacker)) then
			if (attacker:IsPlayer()) then
				if IsValid(inflictor) --[[and (inflictor:IsWeapon() or inflictor.isJavelin)]] then
					inflictor = inflictor.PrintName or inflictor:GetClass()
				else
					local activeWeapon = attacker:GetActiveWeapon()

					if activeWeapon:IsValid() then
						if inflictor.GetPrintName then
							inflictor = inflictor:GetPrintName()
						end

						if !inflictor or !isstring(inflictor) then
							inflictor = activeWeapon.PrintName or activeWeapon:GetClass()
						end
					else
						inflictor = "an unknown weapon"
					end
				end

				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, self.playerName ..
					" (sleeping) has taken " .. tostring(damage) .. " damage from " .. attacker:Name() ..
					" with " .. inflictor .. ", leaving them at " .. self.health .. " health!")
			else
				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, self.playerName ..
					" (sleeping) has taken " .. tostring(damage) .. " damage from " .. attacker:GetClass() ..
					", leaving them at " .. self.health .. " health!")
			end
		else
			if IsValid(inflictor) then
				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, self.playerName .. " (sleeping) has taken " ..
					tostring(damage) .. " damage from " .. inflictor:GetClass() .. ", leaving them at " ..
					self.health .. " health!")
			else
				Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, self.playerName .. " (sleeping) has taken "
					.. tostring(damage) .. " damage from an unknown source, leaving them at " ..
					self.health .. " health!")
			end
		end

		if (self.soundsPitch) then
			local curTime = CurTime()
			if (self.nextPainSound <= CurTime()) then
				local pitch = self.soundsPitch
				pitch = istable(pitch) and math.random(pitch[1], pitch[2]) or pitch
				local painSound = self.painSounds[math.random(1, #self.painSounds)]

				self:EmitSound(painSound, 90, pitch)
				self.nextPainSound = curTime + 0.5
			end
		end

		Clockwork.player:SetOfflineCharacterData(character, "Health", self.health)
		SaveCharacter(character, steamID, false)

		return
	elseif (IsValid(attacker)) then -- TODO: use DamageLog and KillLog hooks on PrintLog calls and make them work without Player entity
		if (attacker:IsPlayer()) then
			if IsValid(inflictor) --[[and (inflictor:IsWeapon() or inflictor.isJavelin)]] then
				inflictor = inflictor.PrintName or inflictor:GetClass()
			else
				local activeWeapon = attacker:GetActiveWeapon()

				if activeWeapon:IsValid() then
					if inflictor.GetPrintName then
						inflictor = inflictor:GetPrintName()
					end

					if !inflictor or !isstring(inflictor) then
						inflictor = activeWeapon.PrintName or activeWeapon:GetClass()
					end
				else
					inflictor = "an unknown weapon"
				end
			end

			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name() ..
				" has dealt " .. tostring(math.ceil(damage)) .. " damage to " .. self.playerName ..
				" (sleeping) with " .. inflictor .. ", killing them!")
		else
			Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:GetClass() ..
				" has dealt " .. tostring(math.ceil(damage)) .. " damage to " .. self.playerName ..
				" (sleeping), killing them!")
		end
	elseif (IsValid(inflictor)) then
		Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, inflictor:GetClass() ..
		" has dealt " .. tostring(math.ceil(damage)) .. " damage to " .. self.playerName ..
		" (sleeping), killing them!")
	else
		Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, self.playerName .. " has taken " .. tostring(math.ceil(damage)) ..
			" damage from an unknown source, killing them!")
	end


	local inventory = self.inventory
	local inventory2 = self.inventory2

	-- replicating https://github.com/DETrooper/Begotten-III/blob/main/upload/gamemodes/cwbegotten/schema/sv_schema.lua#L1482
	for k, v in pairs(inventory2) do
		local itemTable = Clockwork.item:FindByID(k);

		if (itemTable and itemTable.allowStorage == false) then
			inventory2[k] = nil
		end
	end

	-- replicating https://github.com/DETrooper/Begotten-III/blob/main/upload/gamemodes/clockwork/framework/sv_kernel.lua#L2171
	for k, v in pairs(inventory) do
		for k2, v2 in pairs(v) do
			if (!v2 or !v2:IsInstance()) then
				debug.Trace()

				continue
			end

			if (v2.OnTakeFromDisconnectedPlayer) then
				itemTable:OnTakeFromDisconnectedPlayer(self)
			end

			Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, self.playerName ..
				" has lost a " .. v2.name .. " " .. v2.itemID .. ".")

			hook.Run("DisconnectedPlayerItemTaken", self, v2)

			Clockwork.inventory:RemoveInstance(inventory, v2)
		end
	end

	Clockwork.player:SetOfflineCharacterData(character, "deathcause", "Died under mysterious circumstances.")
	Clockwork.player:SetOfflineCharacterData(character, "permakilled", true)
	Clockwork.player:SetOfflineCharacterData(character, "Cash", 0)
	Clockwork.player:SetOfflineCharacterData(character, "Equipment", {})
	SaveCharacter(character, steamID, inventory)

	-- replicating https://github.com/DETrooper/Begotten-III/blob/main/upload/gamemodes/cwbegotten/schema/sv_schema.lua#L1467
	if (Clockwork.equipment:RawGetItemEquipped(self.equipmentSlots, "satchel_denial", "Charms")) then
		local pos = self:GetPos()
		local dist = ((config.Get("talk_radius"):Get() * 2) / 2)
		local distSqr = (dist * dist)
		local listeners = {}

		for _, v in _player.Iterator() do
			if (v:HasInitialized()) then
				local realTrace = Clockwork.player:GetRealTrace(v)

				if ((realTrace.HitPos:DistToSqr(pos) <= distSqr) or pos:DistToSqr(v:GetPos()) <= distSqr) then
					listeners[#listeners + 1] = v
				end
			elseif (v:GetNetVar("tracktarget")) then
				trk = v:GetNetVar("tracktarget")

				if trk == speaker:SteamID() then
					listeners[#listeners + 1] = v
				end
			end;
		end

		Clockwork.chatBox:Add(listeners, "The body disintegrates before your very eyes!")

		self:Remove()

		return
	end

	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetModel(self:GetModel())
	ragdoll:SetPos(self:GetPos())
	ragdoll:SetAngles(self:GetAngles())
	ragdoll:SetSkin(self:GetSkin())
	ragdoll:SetColor(self:GetColor())
	ragdoll:SetMaterial(self:GetMaterial())
	ragdoll:SetBodygroup(0, self:GetBodygroup(0))
	ragdoll:SetBodygroup(1, self:GetBodygroup(1))
	ragdoll:Spawn()

	ragdoll:SetNWEntity("Player", game.GetWorld())
	ragdoll:SetNW2String("clothes", self:GetClothes())
	if ((self.characterBounty or 0) > 0) then
		ragdoll:SetNWInt("bountyKey", self.characterKey)
	end

	ragdoll.cwIsBelongings = true
	ragdoll.cwInventory = inventory2
	ragdoll.cwCash = self.cash

	ragdoll:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local physObj = ragdoll:GetPhysicsObjectNum(i)

		if (IsValid(physObj)) then
			local index = ragdoll:TranslatePhysBoneToBone(i)

			if (index) then
				local position, angles = self:GetBonePosition(index)

				physObj:SetPos(position)
				physObj:SetAngles(angles)
			end
		end
	end

	cwGore:RotCorpse(ragdoll, 600)

	local pitch = self.soundsPitch
	if (pitch) then
		pitch = istable(pitch) and math.random(pitch[1], pitch[2]) or pitch
		local deathSound = self.deathSounds[math.random(1, #self.deathSounds)]
		timer.Simple(engine.TickInterval() * 2, function()
			if (IsValid(ragdoll)) then
				ragdoll:EmitSound(deathSound, 90, pitch)
			end
		end)
	end

	self:Remove()
end

function ENT:Think()
	local curTime = CurTime()

	if (self.removeAfter > 0 and self.removeAfter <= curTime) then
		self:Remove()

		return
	end

	if (self.bPlayerSetLastTick) then
		self:ResetSequence(self:LookupSequence("lying_down"))
		DropToGroundAndRotateBySurface(self)

		self.nextGroundCheck = curTime + 1
		self.bPlayerSetLastTick = nil

		return
	end

	if (self.nextGroundCheck > 0 and self.nextGroundCheck <= curTime) then
		DropToGroundAndRotateBySurface(self, true)

		self.nextGroundCheck = curTime + 1
	end
end

function ENT:OnRemove()
	if (Clockwork.ShuttingDown) then
		SaveCharacter(self.character, self.playerSteamID)
	end

	cwPlayerDisconnectProtection.playerBodies[self.characterKey] = nil
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
