--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (!Clockwork.player) then include("sh_player.lua") end
if (!Clockwork.database) then include("sv_database.lua") end
if (!Clockwork.chatBox) then include("sv_chatbox.lua") end
if (!Clockwork.hint) then include("sv_hint.lua") end
if (!Clockwork.trait) then include("sh_trait.lua") end

local plyProperty = Clockwork.player.property or {}
Clockwork.player.property = plyProperty

function Clockwork.player:RestoreData(player, data)
	for k, v in pairs(data) do
		self:UpdatePlayerData(player, k, v)
	end

	for k, v in pairs(self.playerData) do
		if (data[k] == nil) then
			player:SetData(k, v.default)
		end
	end
end

function Clockwork.player:RestoreCharacterData(player, data)
	for k, v in pairs(data) do
		self:UpdateCharacterData(player, k, v)
	end

	for k, v in pairs(self.characterData) do
		if (data[k] == nil) then
			player:SetCharacterData(k, v.default)
		end
	end
end

function Clockwork.player:UpdateCharacterData(player, key, value)
	local characterData = self.characterData

	if (characterData[key]) then
		if (characterData[key].callback) then
			value = characterData[key].callback(player, value)
		end

		if (key == "PhysDesc") then
			player:SetDTString(STRING_PHYSDESC, value)

			return
		end

		player:SetNetVar(key, value)
	end
end

function Clockwork.player:UpdatePlayerData(player, key, value)
	local playerData = self.playerData

	if (playerData[key]) then
		if (playerData[key].callback) then
			value = playerData[key].callback(player, value)
		end

		player:SetNetVar(key, value)
	end
end

-- A function to run an inventory action for a player.
function Clockwork.player:InventoryAction(player, itemTable, action)
	return Clockwork.inventory:InventoryAction(player, action, itemTable.uniqueID, itemTable.itemID);
end

-- A function to create a character from data.
function Clockwork.player:CreateCharacterFromData(player, data)
	if (player.cwIsCreatingChar) then
		return
	end

	local minimumPhysDesc = config.Get("minimum_physdesc"):Get()
	local attributesTable = Clockwork.attribute:GetAll()
	local factionTable = Clockwork.faction:FindByID(data.faction)
	local attributes = nil
	local info = {}

	if (!table.IsEmpty(attributesTable)) then
		for k, v in pairs(attributesTable) do
			if (v.isOnCharScreen) then
				attributes = true
				break
			end
		end
	end
	
	local traitsTable = Clockwork.trait:GetAll();
	local hasTraits = nil;
	
	if (!table.IsEmpty(traitsTable)) then
		for k, v in pairs(traitsTable) do
			hasTraits = true;
			break;
		end;
	end;

	if (!factionTable) then
		return self:SetCreateFault(
			player, "This is not a valid faction."
		)
	end
	
	if (factionTable.subfactions) then
		for i = 1, #factionTable.subfactions do
			local subfaction = factionTable.subfactions[i];
		
			if subfaction.name == data.subfaction then
				if subfaction.locked then
					return self:SetCreateFault(
						player, "This subfaction is locked and cannot be selected!"
					);
				elseif subfaction.whitelist and !Clockwork.player:IsWhitelistedSubfaction(player, subfaction.name) then
					return self:SetCreateFault(
						player, "You are not whitelisted for this subfaction!"
					);
				end
			end
		end
	end

	info.attributes = {}
	info.traits = { positive = {}, negative = {} }
	info.faction = factionTable.name
	info.subfaction = data.subfaction
	info.faith = data.faith
	info.subfaith = "N/A"
	info.gender = data.gender
	info.model = data.model
	info.skin = data.skin
	info.lastPlayed = data.lastPlayed
	info.timeCreated = data.timeCreated
	info.data = {}
	
	if (data.plugin) then
		for k, v in pairs(data.plugin) do
			info.data[k] = v
		end
	end

	local classes = false

	for k, v in pairs(Clockwork.class:GetAll()) do
		if (v.isOnCharScreen and (v.factions
		and table.HasValue(v.factions, factionTable.name))) then
			classes = true
		end
	end

	if (classes) then
		local classTable = Clockwork.class:FindByID(data.class)

		if (!classTable) then
			return self:SetCreateFault(
				player, "This is not a valid class."
			)
		else
			info.data["class"] = classTable.name
		end
	end
	
	if (hasTraits and type(data.traits) == "table") then
		local maximumPoints = Clockwork.config:Get("max_trait_points"):Get();
		local pointsSpent = 0;
		
		if data.subfaction == "Clan Crast" then
			maximumPoints = maximumPoints - 4;
		elseif data.subfaction == "Kinisger" then
			maximumPoints = maximumPoints - 3;
		end
		
		info.data["Traits"] = {};
	
		for k, v in pairs(data.traits) do
			local traitTable = Clockwork.trait:FindByID(v);
			
			if (traitTable) then
				if traitTable.disables then
					for i, v in ipairs(traitTable.disables) do
						if table.HasValue(data.traits, v) then
							return self:SetCreateFault(player, "You have selected traits that are incompatible with eachother!");
						end
					end
				end
				
				table.insert(info.data["Traits"], traitTable.uniqueID);
				pointsSpent = pointsSpent + traitTable.points;
			end;
		end;
		
		if table.HasValue(data.traits, "leper") then
			local dummyEnt = ents.Create("prop_dynamic");
			
			if IsValid(dummyEnt) then
				dummyEnt:SetModel(info.model);
				
				info.skin = dummyEnt:SkinCount() - 1;
				
				dummyEnt:Remove();
			end
		end
		
		if (pointsSpent > maximumPoints) then
			return self:SetCreateFault(player, "Your trait point balance must be equal to or above 0!");
		end;
	elseif (hasTraits) then
		return self:SetCreateFault(player, "You did not choose any of the available traits!");
	end;

	--[[if (attributes and type(data.attributes) == "table") then
		local maximumPoints = config.Get("default_attribute_points"):Get()
		local pointsSpent = 0

		if (factionTable.attributePointsScale) then
			maximumPoints = math.Round(maximumPoints * factionTable.attributePointsScale)
		end

		if (factionTable.maximumAttributePoints) then
			maximumPoints = factionTable.maximumAttributePoints
		end

		for k, v in pairs(data.attributes) do
			local attributeTable = Clockwork.attribute:FindByID(k)

			if (attributeTable and attributeTable.isOnCharScreen) then
				local uniqueID = attributeTable.uniqueID
				local amount = math.Clamp(v, 0, attributeTable.maximum)

				info.attributes[uniqueID] = {
					amount = amount,
					progress = 0
				}

				pointsSpent = pointsSpent + amount
			end
		end

		if (pointsSpent > maximumPoints) then
			return self:SetCreateFault(
				player, "You have used too many attribute points."
			)
		end
	elseif (attributes) then
		return self:SetCreateFault(
			player, "You have invested points into an invalid attribute."
		)
	end]]--

	if (!factionTable.GetName) then
		if (!factionTable.useFullName) then
			if (data.forename and data.surname) then
				data.forename = string.gsub(data.forename, "^.", string.upper)
				data.surname = string.gsub(data.surname, "^.", string.upper)
				
				local forename = string.lower(data.forename);
				local surname = string.lower(data.surname);

				if (string.find(data.forename, "[%p%s%d]") or string.find(data.surname, "[%p%s%d]")) then
					return self:SetCreateFault(
						player, "Character's name must not contain any special characters."
					)
				end
				
				local blacklistedNames = {};
				
				if Schema.Ranks then
					for k, v in pairs(Schema.Ranks) do
						for i, v2 in ipairs(v) do
							if v2 ~= "" then
								table.insert(blacklistedNames, string.lower(v2));
							end
						end
					end
				end
				
				for i = 1, #blacklistedNames do
					local blacklistedName = blacklistedNames[i];
				
					if (string.find(forename, blacklistedName) or string.find(surname, blacklistedName)) then
						if Schema.EasyText then
							Schema:EasyText(Schema:GetAdmins(), "tomato", player:Name().." has attempted to make a character with the blacklisted phrase "..blacklistedName.."!");
						end
					
						return self:SetCreateFault(
							player, "Character's name must not contain any blacklisted phrases."
						)
					end
				end

				--[[if (!string.find(data.forename, "[aeiou]") or !string.find(data.surname, "[aeiou]")) then
					return self:SetCreateFault(
						player, "Your forename and surname must both contain at least one vowel!"
					)
				end]]--

				if (string.utf8len(data.forename) < 2 or string.utf8len(data.surname) < 2) then
					return self:SetCreateFault(
						player, "Your name must more than two characters long."
					)
				end

				if (string.utf8len(data.forename) > 16 or string.utf8len(data.surname) > 16) then
					return self:SetCreateFault(
						player, "Your name must be less than 16 characters long."
					)
				end
			else
				return self:SetCreateFault(
					player, "You did not choose a name or the name you chose is invalid."
				)
			end
		elseif (!data.fullName or data.fullName == "") then
			return self:SetCreateFault(
				player, "You did not choose a name or the name you chose is invalid."
			)
		end
	end

	if (Clockwork.command:FindByID("CharPhysDesc") != nil) then
		if (type(data.physDesc) != "string") then
			return self:SetCreateFault(
				player, "You did not specify any text."
			)
		elseif (string.utf8len(data.physDesc) < minimumPhysDesc) then
			return self:SetCreateFault(
				player, "The description must be at least "..minimumPhysDesc.." letters long."
			)
		end

		info.data["PhysDesc"] = Clockwork.kernel:ModifyPhysDesc(data.physDesc)
	end

	if (!factionTable.GetModel and !info.model) then
		return self:SetCreateFault(
			player, "You did not choose a model, or the model that you chose is not valid!"
		)
	end
	
	if (!Clockwork.faction:IsGenderValid(info.faction, info.gender)) then
		return self:SetCreateFault(
			player, "You did not choose a gender, or the gender that you chose is not valid!"
		)
	end
	
	if factionTable.disabled and !player:IsAdmin() then
		return self:SetCreateFault(
			player, "This faction is currently disabled!"
		)
	end
	
	if factionTable.availablefaiths and data.faith then
		if !table.HasValue(factionTable.availablefaiths, data.faith) then
			if data.subfaction and factionTable.subfactionsToAvailableFaiths then
				if !factionTable.subfactionsToAvailableFaiths[data.subfaction] or !table.HasValue(factionTable.subfactionsToAvailableFaiths[data.subfaction], data.faith) then
					return self:SetCreateFault(
						player, "This subfaction cannot take the "..data.faith.." faith!"
					)
				end
			else
				return self:SetCreateFault(
					player, "This faction cannot take the "..data.faith.." faith!"
				)
			end
		end
	end

	if (factionTable.whitelist and !self:IsWhitelisted(player, info.faction)) then
		return self:SetCreateFault(
			player, "You are not on the "..info.faction.." whitelist!"
		)
	elseif (Clockwork.faction:IsModelValid(factionTable.name, info.gender, info.model)
	or (factionTable.GetModel and !info.model)) then
		local charactersTable = config.Get("mysql_characters_table"):Get()
		local schemaFolder = Clockwork.kernel:GetSchemaFolder()
		local characterID = nil
		local characters = player:GetCharacters()

		if (Clockwork.faction:HasReachedMaximum(player, factionTable.name)) then
			return self:SetCreateFault(
				player, "You cannot create any more characters in this faction."
			)
		end

		for i = 1, self:GetMaximumCharacters(player) do
			if (!characters[i]) then
				characterID = i
				break
			end
		end

		if (characterID) then
			if (factionTable.GetName) then
				info.name = factionTable:GetName(player, true)
			elseif (!factionTable.useFullName) then
				info.name = data.forename.." "..data.surname
			else
				info.name = data.fullName
			end

			if (factionTable.GetModel) then
				info.model = factionTable:GetModel(player, info, data)
			else
				info.model = data.model
			end

			if (factionTable.OnCreation) then
				local fault = factionTable:OnCreation(player, info)

				if (fault == false or type(fault) == "string") then
					return self:SetCreateFault(
						player, fault or "There was an error creating this character!"
					)
				end
			end

			for k, v in pairs(characters) do
				if (v.name == info.name) then
					return self:SetCreateFault(
						player, "You already have a character with the name '"..info.name.."'!"
					)
				end
			end

			local fault = hook.Run("PlayerAdjustCharacterCreationInfo", player, info, data)

			if (fault == false or type(fault) == "string") then
				return self:SetCreateFault(
					player, fault or "There was an error creating this character!"
				)
			end

			local queryObj = Clockwork.database:Select(charactersTable)
				queryObj:Where("_Schema", schemaFolder)
				queryObj:Where("_Name", info.name)
				queryObj:Callback(function(result)
					if (!IsValid(player)) then return end

					if (Clockwork.database:IsResult(result)) then
						self:SetCreateFault(
							player, "A character with the name '"..info.name.."' already exists!"
						)
						player.cwIsCreatingChar = nil
					else
						self:LoadCharacter(player, characterID,
							{
								attributes = info.attributes,
								traits = info.traits,
								faction = info.faction,
								subfaction = info.subfaction,
								faith = info.faith,
								subfaith = info.subfaith,
								gender = info.gender,
								model = info.model,
								skin = info.skin,
								name = info.name,
								lastPlayed = info.lastPlayed,
								timeCreated = info.timeCreated,
								data = info.data
							},
							function()
								Clockwork.kernel:PrintLog(LOGTYPE_MINOR,
									player:SteamName().." has created a "..info.faction.." character called '"..info.name.."'."
								)

								netstream.Start(player, "CharacterFinish", {bSuccess = true})

								player.cwIsCreatingChar = nil

								--[[local characters = player:GetCharacters()

								if (table.Count(characters) == 1) then
									self:UseCharacter(player, characterID)
								end]]--
							end
						)
					end
				end)
			queryObj:Execute()
		else
			return self:SetCreateFault(player, "You cannot create any more characters!")
		end
	else
		return self:SetCreateFault(
			player, "You did not choose a model, or the model that you chose is not valid!"
		)
	end
end

-- A function to open the character menu.
function Clockwork.player:SetCharacterMenuOpen(player, bReset)
	netstream.Start(player, "CharacterOpen", (bReset == true))

	if (bReset) then
		player:KillSilent()
	end
end

-- A function to start a sound for a player.
function Clockwork.player:StartSound(player, uniqueID, sound, fVolume)
	if (!player.cwSoundsPlaying) then
		player.cwSoundsPlaying = {}
	end

	if (!player.cwSoundsPlaying[uniqueID]
	or player.cwSoundsPlaying[uniqueID] != sound) then
		player.cwSoundsPlaying[uniqueID] = sound

		netstream.Start(player, "StartSound", {
			uniqueID = uniqueID, sound = sound, volume = (fVolume or 0.75)
		})
	end
end

-- A function to stop a sound for a player.
function Clockwork.player:StopSound(player, uniqueID, iFadeOut)
	if (!player.cwSoundsPlaying) then
		player.cwSoundsPlaying = {}
	end

	if (player.cwSoundsPlaying[uniqueID]) then
		player.cwSoundsPlaying[uniqueID] = nil

		netstream.Start(player, "StopSound", {
			uniqueID = uniqueID, fadeOut = (iFadeOut or 0)
		})
	end
end

-- A function to get whether a player is noclipping.
function Clockwork.player:IsNoClipping(player)
	if (player:GetMoveType() == MOVETYPE_NOCLIP
	and !player:InVehicle()) then
		return true
	end
end

-- A function to get whether a player is an admin.
function Clockwork.player:IsAdmin(player)
	if (self:HasFlags(player, "o")) then
		return true
	end
end

-- A function to get whether a player can hear another player.
function Clockwork.player:CanHearPlayer(player, target, iAllowance)
	if (config.Get("messages_must_see_player"):Get()) then
		return self:CanSeePlayer(player, target, (iAllowance or 0.5), true)
	else
		return true
	end
end

-- A functon to get all property.
function Clockwork.player:GetAllProperty()
	for k, v in pairs(plyProperty) do
		if (!IsValid(v)) then
			plyProperty[k] = nil
		end
	end

	return plyProperty
end

-- A function to set a player's action.
function Clockwork.player:SetAction(player, action, duration, priority, Callback)
	local currentAction = self:GetAction(player)

	if (!action or type(action) != "string" or action == "") then
		timer.Remove("Action"..player:UniqueID())

		player:SetNetVar("StartActTime", 0)
		player:SetNetVar("ActDuration", 0)
		player:SetNetVar("ActName", "")
		
		hook.Run("ActionStopped", player, currentAction);
		hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);

		return
	elseif (duration == false or duration == 0) then
		if (currentAction == action) then
			return self:SetAction(player, false)
		else
			return false
		end
	end

	if (player.cwAction) then
		if ((priority and priority > player.cwAction[2]) or !currentAction or action == player.cwAction[1]) then
			player.cwAction = nil
		end
	end

	if (!player.cwAction) then
		local curTime = CurTime()

		player:SetNetVar("StartActTime", curTime)
		player:SetNetVar("ActDuration", duration)
		player:SetNetVar("ActName", action)

		if (priority) then
			player.cwAction = {action, priority}
		else
			player.cwAction = nil
		end

		timer.Create("Action"..player:UniqueID(), duration, 1, function()
			if (Callback) and IsValid(player) then
				hook.Run("ActionCompletedPreCallback", player, action);
				Callback();
				hook.Run("ActionCompletedPostCallback", player, action);
				
				hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
			end
		end)
		
		hook.Run("ActionBegun", player, action);
	end
	
	hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
end

function Clockwork.player:SetUseKeyAction(player, action, duration, priority, Callback)
	if player:KeyDown(IN_USE) then
		Clockwork.player:SetAction(player, action, duration, priority, Callback);
		
		player.cwUseAction = action;
	end
end

-- A function to set the player's character menu state.
function Clockwork.player:SetCharacterMenuState(player, state)
	netstream.Start(player, "CharacterMenu", state)
end

-- A function to get a player's action.
function Clockwork.player:GetAction(player, percentage)
	local startActionTime = player:GetNetVar("StartActTime") or 0
	local actionDuration = player:GetNetVar("ActDuration") or 0
	local curTime = CurTime()
	local action = player:GetNetVar("ActName") or "Unknown"

	if (startActionTime and CurTime() < startActionTime + actionDuration) then
		if (percentage) then
			return action, (100 / actionDuration) * (actionDuration - ((startActionTime + actionDuration) - curTime))
		else
			return action, actionDuration, startActionTime
		end
	end
end

function Clockwork.player:ExtendAction(player, extendTime)
	local startActionTime = player:GetNetVar("StartActTime") or 0
	local actionDuration = player:GetNetVar("ActDuration") or 0
	local curTime = CurTime()
	local action = player:GetNetVar("ActName") or "Unknown"
	
	if (startActionTime and CurTime() < startActionTime + actionDuration) then
		player:SetNetVar("ActDuration", actionDuration + extendTime);
		
		if timer.Exists("Action"..player:UniqueID()) then
			timer.Adjust("Action"..player:UniqueID(), math.max(0, (startActionTime - CurTime()) + actionDuration + extendTime));
		end
		
		hook.Run("ActionExtended", player, action);
	end
end

-- A function to run a Clockwork command on a player.
function Clockwork.player:RunClockworkCommand(player, command, ...)
	return Clockwork.command:ConsoleCommand(player, "cwCmd", {command, ...})
end

-- A function to get a player's wages name.
function Clockwork.player:GetWagesName(player)
	return Clockwork.class:Query(player:Team(), "wagesName", config.Get("wages_name"):Get())
end

-- A function to get whether a player can see an entity.
function Clockwork.player:CanSeeEntity(player, target, iAllowance, tIgnoreEnts)
	if (player:GetEyeTraceNoCursor().Entity != target) then
		return self:CanSeePosition(player, target:LocalToWorld(target:OBBCenter()), iAllowance, tIgnoreEnts, target)
	else
		return true
	end
end

--[[
	Duplicate functions, keeping them like this for backward compatiblity.
--]]
Clockwork.player.CanSeePlayer = Clockwork.player.CanSeeEntity
Clockwork.player.CanSeeNPC = Clockwork.player.CanSeeEntity

-- A function to get whether a player can see a position.
function Clockwork.player:CanSeePosition(player, position, iAllowance, tIgnoreEnts, targetEnt)
	local trace = {}

	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	trace.start = player:GetShootPos()
	trace.endpos = position
	trace.filter = {player, targetEnt}

	if (tIgnoreEnts) then
		if (type(tIgnoreEnts) == "table") then
			table.Add(trace.filter, tIgnoreEnts)
		else
			table.Add(trace.filter, ents.GetAll())
		end
	end

	trace = util.TraceLine(trace)

	if (trace.Fraction >= (iAllowance or 0.75)) then
		return true
	end
end

-- A function to get whether a player's weapon is raised.
function Clockwork.player:GetWeaponRaised(player, bIsCached)
	return player:IsWeaponRaised()
end

-- A function to toggle whether a player's weapon is raised.
function Clockwork.player:ToggleWeaponRaised(player)
	player:ToggleWeaponRaised()
end

-- A function to set whether a player's weapon is raised.
function Clockwork.player:SetWeaponRaised(player, bIsRaised)
	return player:SetWeaponRaised(bIsRaised)
end

-- A function to setup a player's remove property delays.
function Clockwork.player:SetupRemovePropertyDelays(player, bAllCharacters)
	local uniqueID = player:UniqueID()
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		local removeDelay = Clockwork.entity:QueryProperty(v, "removeDelay")

		if (IsValid(v) and removeDelay) then
			if (uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")
			and (bAllCharacters or key == Clockwork.entity:QueryProperty(v, "key"))) then
				timer.Create("RemoveDelay"..v:EntIndex(), removeDelay, 1, function(entity)
					if (IsValid(entity)) then
						entity:Remove()
					end
				end, v)
			end
		end
	end
end

-- A function to disable a player's property.
function Clockwork.player:DisableProperty(player, bCharacterOnly)
	local uniqueID = player:UniqueID()
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		if (IsValid(v) and uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")
		and (!bCharacterOnly or key == Clockwork.entity:QueryProperty(v, "key"))) then
			Clockwork.entity:SetPropertyVar(v, "owner", NULL)

			if (Clockwork.entity:QueryProperty(v, "networked")) then
				v:SetNWEntity("Owner", NULL)
			end

			v:SetOwnerKey(nil)
			v:SetNWBool("Owned", false)
			v:SetNWInt("Key", 0)

			if (v.SetPlayer) then
				v:SetVar("Founder", NULL)
				v:SetVar("FounderIndex", 0)
				v:SetNWString("FounderName", "")
			end
		end
	end
end

-- A function to give property to a player.
function Clockwork.player:GiveProperty(player, entity, networked, removeDelay)
	timer.Remove("RemoveDelay"..entity:EntIndex())
	Clockwork.entity:ClearProperty(entity)

	entity.cwPropertyTab = {
		key = player:GetCharacterKey(),
		owner = player,
		owned = true,
		uniqueID = player:UniqueID(),
		networked = networked,
		removeDelay = removeDelay
	}

	if (entity.SetPlayer) then
		entity:SetPlayer(player)
	end

	if (networked) then
		entity:SetNWEntity("Owner", player)
	end

	entity:SetOwnerKey(player:GetCharacterKey())
	entity:SetNWBool("Owned", true)

	if (tonumber(entity.cwPropertyTab.key)) then
		entity:SetNWInt("Key", entity.cwPropertyTab.key)
	end

	plyProperty[entity:EntIndex()] = entity
	hook.Run("PlayerPropertyGiven", player, entity, networked, removeDelay)
end

-- A function to give property to an offline player.
function Clockwork.player:GivePropertyOffline(key, uniqueID, entity, networked, removeDelay)
	Clockwork.entity:ClearProperty(entity)

	if (key and uniqueID) then
		local propertyUniqueID = Clockwork.entity:QueryProperty(entity, "uniqueID")
		local owner = player.GetByUniqueID(uniqueID)

		if (IsValid(owner) and owner:GetCharacterKey() == key) then
			self:GiveProperty(owner, entity, networked, removeDelay)
			return
		else
			owner = nil
		end

		if (propertyUniqueID) then
			timer.Remove("RemoveDelay"..entity:EntIndex().." "..cwPropertyTabUniqueID)
		end

		entity.cwPropertyTab = {
			key = key,
			owner = owner,
			owned = true,
			uniqueID = uniqueID,
			networked = networked,
			removeDelay = removeDelay
		}

		if (IsValid(entity.cwPropertyTab.owner)) then
			if (entity.SetPlayer) then
				entity:SetPlayer(entity.cwPropertyTab.owner)
			end

			if (networked) then
				entity:SetNWEntity("Owner", entity.cwPropertyTab.owner)
			end
		end

		entity:SetNWBool("Owned", true)
		entity:SetNWInt("Key", key)
		entity:SetOwnerKey(key)

		plyProperty[entity:EntIndex()] = entity
		hook.Run("PlayerPropertyGivenOffline", key, uniqueID, entity, networked, removeDelay)
	end
end

-- A function to take property from an offline player.
function Clockwork.player:TakePropertyOffline(key, uniqueID, entity, bAnyCharacter)
	if (key and uniqueID) then
		local owner = player.GetByUniqueID(uniqueID)

		if (IsValid(owner) and owner:GetCharacterKey() == key) then
			self:TakeProperty(owner, entity)
			return
		end

		if (Clockwork.entity:QueryProperty(entity, "uniqueID") == uniqueID
		and Clockwork.entity:QueryProperty(entity, "key") == key) then
			entity.cwPropertyTab = nil
			entity:SetNWEntity("Owner", NULL)
			entity:SetNWBool("Owned", false)
			entity:SetNWInt("Key", 0)
			entity:SetOwnerKey(nil)

			if (entity.SetPlayer) then
				entity:SetVar("Founder", nil)
				entity:SetVar("FounderIndex", nil)
				entity:SetNWString("FounderName", "")
			end

			plyProperty[entity:EntIndex()] = nil
			hook.Run("PlayerPropertyTakenOffline", key, uniqueID, entity)
		end
	end
end

-- A function to take property from a player.
function Clockwork.player:TakeProperty(player, entity)
	if (Clockwork.entity:GetOwner(entity) == player) then
		entity.cwPropertyTab = nil

		entity:SetNWEntity("Owner", NULL)
		entity:SetNWBool("Owned", false)
		entity:SetNWInt("Key", 0)
		entity:SetOwnerKey(nil)

		if (entity.SetPlayer) then
			entity:SetVar("Founder", nil)
			entity:SetVar("FounderIndex", nil)
			entity:SetNWString("FounderName", "")
		end

		plyProperty[entity:EntIndex()] = nil
		hook.Run("PlayerPropertyTaken", player, entity)
	end
end

-- A function to set a player to their default skin.
function Clockwork.player:SetDefaultSkin(player)
	--player:SetSkin(self:GetDefaultSkin(player))
	
	if player then
		local currentCharacter = player.cwCharacter;
		
		if currentCharacter and currentCharacter.skin then
			player:SetSkin(currentCharacter.skin);
		end
	end
end

-- A function to get a player's default skin.
function Clockwork.player:GetDefaultSkin(player)
	return hook.Run("GetPlayerDefaultSkin", player)
end

-- A function to set a player to their default model.
function Clockwork.player:SetDefaultModel(player)
	player:SetModel(self:GetDefaultModel(player))
end

-- A function to get a player's default model.
function Clockwork.player:GetDefaultModel(player)
	return hook.Run("GetPlayerDefaultModel", player)
end

-- A function to get whether a player is drunk.
function Clockwork.player:GetDrunk(player)
	if (player.cwDrunkTab) then return #player.cwDrunkTab end
end

-- A function to set whether a player is drunk.
function Clockwork.player:SetDrunk(player, expire)
	local curTime = CurTime()

	if (expire == false) then
		player.cwDrunkTab = nil
	elseif (!player.cwDrunkTab) then
		player.cwDrunkTab = {curTime + expire}
	else
		player.cwDrunkTab[#player.cwDrunkTab + 1] = curTime + expire
	end

	player:SetLocalVar("IsDrunk", self:GetDrunk(player) or 0)
end

-- A function to strip a player's default ammo.
function Clockwork.player:StripDefaultAmmo(player, weapon, itemTable)
end

-- A function to check if a player is whitelisted for a faction.
function Clockwork.player:IsWhitelisted(player, faction)
	local whitelists = player:GetData("Whitelisted")

	if (whitelists) then
		return table.HasValue(player:GetData("Whitelisted"), faction)
	else
		return false
	end
end

-- A function to check if a player is whitelisted for a subfaction.
function Clockwork.player:IsWhitelistedSubfaction(player, subfaction)
	local whitelists = player:GetData("WhitelistedSubfactions")

	if (whitelists) then
		return table.HasValue(player:GetData("WhitelistedSubfactions"), subfaction)
	else
		return false
	end
end

-- A function to set whether a player is whitelisted for a faction.
function Clockwork.player:SetWhitelisted(player, faction, isWhitelisted)
	local whitelisted = player:GetData("Whitelisted", {})
	local newTab = {}; -- Janky fix since sometimes players get randomly de-whitelisted by it being a key-value pair table.

	for k, v in pairs(whitelisted) do
		if !table.HasValue(newTab, v) then
			table.insert(newTab, v);
		end
	end
	
	if isWhitelisted then
		if !table.HasValue(newTab, faction) then
			table.insert(newTab, faction);
		end
	else
		table.RemoveByValue(newTab, faction);
	end

	netstream.Start(
		player, "SetWhitelisted", {faction, isWhitelisted}
	)
	player:SetData("Whitelisted", newTab)
end

-- A function to set whether a player is whitelisted for a subfaction.
function Clockwork.player:SetWhitelistedSubfaction(player, subfaction, isWhitelisted)
	local whitelisted = player:GetData("WhitelistedSubfactions", {})
	local newTab = {}; -- Janky fix since sometimes players get randomly de-whitelisted by it being a key-value pair table.

	for k, v in pairs(whitelisted) do
		if !table.HasValue(newTab, v) then
			table.insert(newTab, v);
		end
	end
	
	if isWhitelisted then
		if !table.HasValue(newTab, subfaction) then
			table.insert(newTab, subfaction);
		end
	else
		table.RemoveByValue(newTab, subfaction);
	end

	netstream.Start(
		player, "SetWhitelistedSubfaction", {subfaction, isWhitelisted}
	)
	player:SetData("WhitelistedSubfactions", newTab)
end

-- A function to create a Condition timer.
function Clockwork.player:ConditionTimer(player, delay, Condition, Callback)
	local realDelay = CurTime() + delay
	local uniqueID = player:UniqueID()

	if (player.cwConditionTimer) then
		player.cwConditionTimer.Callback(false)
		player.cwConditionTimer = nil
	end

	player.cwConditionTimer = {
		delay = realDelay,
		Callback = Callback,
		Condition = Condition
	}

	timer.Create("CondTimer"..uniqueID, 0, 0, function()
		if (!IsValid(player)) then
			timer.Remove("CondTimer"..uniqueID)
			Callback(false)
			return
		end

		if (Condition()) then
			if (CurTime() >= realDelay) then
				Callback(true) player.cwConditionTimer = nil
				timer.Remove("CondTimer"..uniqueID)
			end
		else
			Callback(false) player.cwConditionTimer = nil
			timer.Remove("CondTimer"..uniqueID)
		end
	end)
end

-- A function to create an entity Condition timer.
function Clockwork.player:EntityConditionTimer(player, target, entity, delay, distance, Condition, Callback)
	local realEntity = entity or target
	local realDelay = CurTime() + delay
	local uniqueID = player:UniqueID()

	if (player.cwConditionEntTimer) then
		player.cwConditionEntTimer.Callback(false)
		player.cwConditionEntTimer = nil
	end

	player.cwConditionEntTimer = {
		delay = realDelay, target = target,
		entity = realEntity, distance = distance,
		Callback = Callback, Condition = Condition
	}

	timer.Create("EntityCondTimer"..uniqueID, 0, 0, function()
		if (!IsValid(player)) then
			timer.Remove("EntityCondTimer"..uniqueID)
			Callback(false)
			return
		end

		local traceLine = player:GetEyeTraceNoCursor()

		if (IsValid(target) and IsValid(realEntity) and traceLine.Entity == realEntity
		and traceLine.Entity:GetPos():Distance(player:GetShootPos()) <= distance
		and Condition()) then
			if (CurTime() >= realDelay) then
				Callback(true) player.cwConditionEntTimer = nil
				timer.Remove("EntityCondTimer"..uniqueID)
			end
		else
			Callback(false) player.cwConditionEntTimer = nil
			timer.Remove("EntityCondTimer"..uniqueID)
		end
	end)
end

-- A function to get a player's spawn ammo.
--[[function Clockwork.player:GetSpawnAmmo(player, ammo)
	if (ammo) then
		return player.cwSpawnAmmo[ammo]
	else
		return player.cwSpawnAmmo
	end
end]]--

-- A function to get a player's spawn weapon.
function Clockwork.player:GetSpawnWeapon(player, weapon)
	if (weapon) and player.cwSpawnWeps then
		return player.cwSpawnWeps[weapon]
	end
end

-- A function to take spawn ammo from a player.
--[[function Clockwork.player:TakeSpawnAmmo(player, ammo, amount)
	if (player.cwSpawnAmmo[ammo]) then
		if (player.cwSpawnAmmo[ammo] < amount) then
			amount = player.cwSpawnAmmo[ammo]

			player.cwSpawnAmmo[ammo] = nil
		else
			player.cwSpawnAmmo[ammo] = player.cwSpawnAmmo[ammo] - amount
		end

		player:RemoveAmmo(amount, ammo)
	end
end]]--

-- A function to give the player spawn ammo.
--[[function Clockwork.player:GiveSpawnAmmo(player, ammo, amount)
	if (player.cwSpawnAmmo[ammo]) then
		player.cwSpawnAmmo[ammo] = player.cwSpawnAmmo[ammo] + amount
	else
		player.cwSpawnAmmo[ammo] = amount
	end

	player:GiveAmmo(amount, ammo)
end]]--

-- A function to take a player's spawn weapon.
function Clockwork.player:TakeSpawnWeapon(player, class)
	player.cwSpawnWeps[class] = nil
	player:StripWeapon(class)
end

-- A function to give a player a spawn weapon.
function Clockwork.player:GiveSpawnWeapon(player, class)
	player.cwSpawnWeps[class] = true
	player:Give(class)
end

-- A function to give a player an item weapon.
function Clockwork.player:GiveItemWeapon(player, itemTable)
	if (item.IsWeapon(itemTable)) then
		player:Give(itemTable:GetWeaponClass(), itemTable)
		return true
	end
end

-- A function to give a player a spawn item weapon.
function Clockwork.player:GiveSpawnItemWeapon(player, itemTable)
	if (item.IsWeapon(itemTable)) then
		player.cwSpawnWeps[itemTable:GetWeaponClass()] = true
		player:Give(itemTable:GetWeaponClass(), itemTable)

		return true
	end
end

-- A function to give flags to a character.
function Clockwork.player:GiveFlags(player, flags)
	for i = 1, #flags do
		local flag = string.utf8sub(flags, i, i)

		if (!string.find(player:GetFlags(), flag)) then
			player:SetCharacterData("Flags", player:GetFlags()..flag, true)

			hook.Run("PlayerFlagsGiven", player, flag)
		end
	end
end

-- A function to give flags to a player.
function Clockwork.player:GivePlayerFlags(player, flags)
	for i = 1, #flags do
		local flag = string.utf8sub(flags, i, i)

		if (!string.find(player:GetPlayerFlags(), flag)) then
			player:SetData("Flags", player:GetPlayerFlags()..flag, true)

			hook.Run("PlayerFlagsGiven", player, flag)
		end
	end
end

-- A function to play a sound to a player.
function Clockwork.player:PlaySound(player, sound)
	netstream.Start(player, "PlaySound",sound)
end

-- A function to get a player's maximum characters.
function Clockwork.player:GetMaximumCharacters(player)
	if player:IsAdmin() then
		return 100;
	else
		local maximum = config.Get("additional_characters"):Get()

		for k, v in pairs(Clockwork.faction:GetAll()) do
			if (!v.whitelist or self:IsWhitelisted(player, v.name)) then
				maximum = maximum + 1
			end
		end

		return maximum
	end
end

-- A function to query a player's character.
function Clockwork.player:Query(player, key, default)
	local character = player.cwCharacter;

	if (character) then
		key = Clockwork.kernel:SetCamelCase(key, true)

		if (character[key] != nil) then
			return character[key]
		end
	end

	return default
end

-- A function to set a player to a safe position.
function Clockwork.player:SetSafePosition(player, position, filter)
	player:SetPos(position + Vector(0, 0, 4))

	if (player:IsStuck()) then
		player:DropToFloor()
		player:SetPos(player:GetPos() + Vector(0, 0, 4))

		if (!istable(filter) and !isfunction(filter)) then
			filter = {filter}
		end

		if (istable(filter)) then
			table.insert(filter, player)
		end

		if (!player:IsStuck()) then return end

		local positions = Clockwork.player:GetSafePosition(player, player:GetPos(), filter, 3)

		for k, v in ipairs(positions) do
			player:SetPos(v)

			if (!player:IsStuck()) then
				return
			else
				player:DropToFloor()

				if (!player:IsStuck()) then
					return
				end
			end
		end
	end
end

-- A function to get the safest position near a position.
function Clockwork.player:GetSafePosition(player, position, filter, margin)
	margin = margin or 3

	local pos = position
	local min, max = Vector(-16, -16, 0), Vector(16, 16, 32)
	local positions = {}

	for x = -margin, margin do
		for y = -margin, margin do
			local pick = pos + Vector(x * margin * 10, y * margin * 10, 0)

			if (!util.IsInWorld(pick)) then continue end

			local data = {}
				data.start = pick + min + Vector(0, 0, margin * 1.25)
				data.endpos = pick + max
				data.filter = filter or player
			local trace = util.TraceLine(data)

			if (trace.StartSolid or trace.Hit) then continue end

			data.start = pick + Vector(-max.x, -max.y, margin * 1.25)
			data.endpos = pick + Vector(min.x, min.y, 32)

			local trace2 = util.TraceLine(data)

			if (trace2.StartSolid or trace2.Hit) then continue end

			data.start = pos
			data.endpos = pick

			local trace3 = util.TraceLine(data)

			if (trace3.Hit or trace3.StartSolid) then continue end

			table.insert(positions, pick)
		end
	end

	table.sort(positions, function(a, b)
		return a:Distance(pos) < b:Distance(pos)
	end)

	return positions
end

-- Called to convert a player's data to a string.
function Clockwork.player:ConvertDataString(player, data)
	local bSuccess, value = pcall(util.JSONToTable, data)

	if (bSuccess and value != nil) then
		return value
	else
		return {}
	end
end

-- A function to return a player's property.
function Clockwork.player:ReturnProperty(player)
	local uniqueID = player:UniqueID()
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		if (IsValid(v)) then
			if (uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")) then
				if (key == Clockwork.entity:QueryProperty(v, "key")) then
					self:GiveProperty(player, v, Clockwork.entity:QueryProperty(v, "networked"))
				end
			end
		end
	end

	hook.Run("PlayerReturnProperty", player)
end

-- A function to take flags from a character.
function Clockwork.player:TakeFlags(player, flags)
	for i = 1, #flags do
		local flag = string.utf8sub(flags, i, i)

		if (string.find(player:GetFlags(), flag)) then
			player:SetCharacterData("Flags", string.gsub(player:GetFlags(), flag, ""), true)

			hook.Run("PlayerFlagsTaken", player, flag)
		end
	end
end

-- A function to take flags from a player.
function Clockwork.player:TakePlayerFlags(player, flags)
	for i = 1, #flags do
		local flag = string.utf8sub(flags, i, i)

		if (string.find(player:GetPlayerFlags(), flag)) then
			player:SetData("Flags", string.gsub(player:GetFlags(), flag, ""), true)

			hook.Run("PlayerFlagsTaken", player, flag)
		end
	end
end

-- A function to set whether a player's menu is open.
function Clockwork.player:SetMenuOpen(player, isOpen)
	netstream.Start(player, "MenuOpen", isOpen)
end

-- A function to set whether a player has intialized.
function Clockwork.player:SetInitialized(player, initialized)
	player:SetNetVar("Initialized", initialized)
end

-- A function to check if a player has any flags.
function Clockwork.player:HasAnyFlags(player, flags, bByDefault)
	if (player.cwCharacter) then
		local playerFlags = player:GetFlags()

		if (Clockwork.class:HasAnyFlags(player:Team(), flags) and !bByDefault) then
			return true
		end

		for i = 1, #flags do
			local flag = string.utf8sub(flags, i, i)
			local bSuccess = true

			if (!bByDefault) then
				local hasFlag = hook.Run("PlayerDoesHaveFlag", player, flag)

				if (hasFlag != false) then
					if (hasFlag) then
						return true
					end
				else
					bSuccess = nil
				end
			end

			if (bSuccess) then
				if (flag == "s") then
					if (player:IsSuperAdmin()) then
						return true
					end
				elseif (flag == "a") then
					if (player:IsAdmin()) then
						return true
					end
				elseif (flag == "o") then
					if (player:IsSuperAdmin() or player:IsAdmin()) then
						return true
					elseif (player:IsUserGroup("operator")) then
						return true
					end
				elseif (string.find(playerFlags, flag)) then
					return true
				end
			end
		end
	end
end

-- A function to check if a player has flags.
function Clockwork.player:HasFlags(player, flags, bByDefault, bIsStrict)
	if (player:IsPlayer() and player.cwCharacter) then
		local playerFlags = player:GetFlags()

		if (Clockwork.class:HasFlags(player:Team(), flags) and !bByDefault) then
			return true
		end

		if (!bIsStrict) then
			for k, v in ipairs(string.Explode("", flags)) do
				if (!bByDefault) then
					local hasFlag = hook.Run("PlayerDoesHaveFlag", player, v)

					if (hasFlag) then
						return true
					end
				end

				if (v == "s") then
					if (player:IsSuperAdmin()) then
						return true
					end
				elseif (v == "a") then
					if (player:IsAdmin()) then
						return true
					end
				elseif (v == "o") then
					if (player:IsUserGroup("operator") or player:IsAdmin()) then
						return true
					end
				end

				if (string.find(playerFlags, v)) then
					return true
				end
			end
		end

		for i = 1, #flags do
			local flag = string.utf8sub(flags, i, i)
			local bSuccess

			if (!bByDefault) then
				local hasFlag = hook.Run("PlayerDoesHaveFlag", player, flag)

				if (hasFlag != false) then
					if (hasFlag) then
						bSuccess = true
					end
				else
					return
				end
			end

			if (!bSuccess) then
				if (flag == "s") then
					if (!player:IsSuperAdmin()) then
						return
					end
				elseif (flag == "a") then
					if (!player:IsAdmin()) then
						return
					end
				elseif (flag == "o") then
					if (!player:IsSuperAdmin() and !player:IsAdmin()) then
						if (!player:IsUserGroup("operator")) then
							return
						end
					end
				elseif (!string.find(playerFlags, flag)) then
					return
				end
			end
		end

		return true
	end
end

-- A function to use a player's death code.
function Clockwork.player:UseDeathCode(player, commandTable, arguments)
	hook.Run("PlayerDeathCodeUsed", player, commandTable, arguments)

	self:TakeDeathCode(player)
end

-- A function to get whether a player has a death code.
function Clockwork.player:GetDeathCode(player, authenticated)
	if (player.cwDeathCodeIdx and (!authenticated or player.cwDeathCodeAuth)) then
		return player.cwDeathCodeIdx
	end
end

-- A function to take a player's death code.
function Clockwork.player:TakeDeathCode(player)
	player.cwDeathCodeAuth = nil
	player.cwDeathCodeIdx = nil
end

-- A function to give a player their death code.
function Clockwork.player:GiveDeathCode(player)
	player.cwDeathCodeIdx = math.random(0, 99999)
	player.cwDeathCodeAuth = nil

	netstream.Start(player, "ChatBoxDeathCode", player.cwDeathCodeIdx)
end

-- A function to take a door from a player.
function Clockwork.player:TakeDoor(player, door, bForce, bThisDoorOnly, bChildrenOnly)
	--local doorCost = config.Get("door_cost"):Get()

	if (!bThisDoorOnly) then
		local doorParent = Clockwork.entity:GetDoorParent(door)

		if (!doorParent or bChildrenOnly) then
			for k, v in pairs(Clockwork.entity:GetDoorChildren(door)) do
				if (IsValid(v)) then
					self:TakeDoor(player, v, true, true)
				end
			end
		else
			return self:TakeDoor(player, doorParent, bForce)
		end
	end

	if (hook.Run("PlayerCanUnlockEntity", player, door)) then
		door:Fire("unlock", "", 0)
		door:EmitSound("doors/door_latch3.wav")
	end

	Clockwork.entity:SetDoorText(door, false)
	self:TakeProperty(player, door)

	hook.Run("PlayerDoorTaken", player, door)

	if (door:GetClass() == "prop_dynamic") then
		if (!door:IsMapEntity()) then
			door:Remove()
		end
	end

	--[[if (!force and doorCost > 0) then
		self:GiveCash(player, doorCost / 2, "selling a door")
	end]]--
end

-- A function to get a player's faction table.
function Clockwork.player:GetFactionTable(player)
	return Clockwork.faction:GetAll()[player:GetFaction()]
end

-- A function to give a door to a player.
function Clockwork.player:GiveDoor(player, door, name, unsellable, override)
	if (Clockwork.entity:IsDoor(door)) then
		local doorParent = Clockwork.entity:GetDoorParent(door)

		if (doorParent and !override) then
			self:GiveDoor(player, doorParent, name, unsellable)
		else
			for k, v in pairs(Clockwork.entity:GetDoorChildren(door)) do
				if (IsValid(v)) then
					self:GiveDoor(player, v, name, unsellable, true)
				end
			end

			door.unsellable = unsellable
			door.accessList = {}

			Clockwork.entity:SetDoorText(door, name or "A purchased door.")
			self:GiveProperty(player, door, true)

			hook.Run("PlayerDoorGiven", player, door)

			--[[if (hook.Run("PlayerCanUnlockEntity", player, door)) then
				door:EmitSound("doors/door_latch3.wav")
				door:Fire("unlock", "", 0)
			end]]--
		end
	end
end

-- A function to get a player's real trace.
function Clockwork.player:GetRealTrace(player, useFilterTrace)
	local eyePos = player:EyePos()
	local trace = player:GetEyeTraceNoCursor()

	local newTrace = util.TraceLine({
		endpos = eyePos + (player:GetAimVector() * 4096),
		filter = player,
		start = eyePos,
		mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	})

	if ((IsValid(newTrace.Entity) and (!IsValid(trace.Entity)
	or trace.Entity:IsVehicle()) and !newTrace.HitWorld) or useFilterTrace) then
		trace = newTrace
	end

	return trace
end

-- A function to check if a player recognises another player.
function Clockwork.player:DoesRecognise(player, target, status, isAccurate)
	if (!status) then
		return self:DoesRecognise(player, target, RECOGNISE_PARTIAL)
	elseif (config.Get("recognise_system"):Get()) then
		local recognisedNames = player:GetRecognisedNames()
		local realValue = false
		local key = target:GetCharacterKey()

		if (recognisedNames and recognisedNames[key]) then
			if (isAccurate) then
				realValue = (recognisedNames[key] == status)
			else
				realValue = (recognisedNames[key] >= status)
			end
		end

		return hook.Run("PlayerDoesRecognisePlayer", player, target, status, isAccurate, realValue)
	else
		return true
	end
end

function Clockwork.player:GetName(player, target)
	if (self:DoesRecognise(player, target)) then
		return target:Name()
	else
		return self:GetUnrecognisedName(target)
	end
end

-- A function to send a player a creation fault.
function Clockwork.player:SetCreateFault(player, fault)
	if (!fault) then
		fault = "There has been an unknown error, please contact the administrator!"
	end

	netstream.Start(player, "CharacterFinish", {bSuccess = false, fault = fault})
end

-- A function to force a player to delete a character.
function Clockwork.player:ForceDeleteCharacter(player, characterID)
	local charactersTable = config.Get("mysql_characters_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local character = player.cwCharacterList[characterID]

	if (character) then
		local queryObj = Clockwork.database:Delete(charactersTable)
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Where("_SteamID", player:SteamID())
			queryObj:Where("_CharacterID", characterID)
		queryObj:Execute()

		if (!hook.Run("PlayerDeleteCharacter", player, character)) then
			Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:SteamName().." has deleted the character '"..character.name.."'.")
		end

		player.cwCharacterList[characterID] = nil

		netstream.Start(player, "CharacterRemove", characterID)
	end
end

-- A function to delete a player's character.
function Clockwork.player:DeleteCharacter(player, characterID)
	local character = player.cwCharacterList[characterID]
	
	if (character) then
		if (player.cwCharacter != character) then
			local fault = hook.Run("PlayerCanDeleteCharacter", player, character)
			
			if (fault == nil or fault == true) then
				self:ForceDeleteCharacter(player, characterID)
				
				return true
			elseif (type(fault) != "string") then
				return false, "You cannot delete this character!"
			else
				return false, fault
			end
		else
			return false, "You cannot delete the character you are using!"
		end
	else
		return false, "This character does not exist!"
	end
end

-- A function to use a player's character.
function Clockwork.player:UseCharacter(player, characterID)
	local currentCharacter = player.cwCharacter;
	local character = player.cwCharacterList[characterID]

	if (!character) then
		return false, "This character does not exist!"
	end

	if (currentCharacter != character) then
		local factionTable = Clockwork.faction:FindByID(character.faction)
		local fault = hook.Run("PlayerCanUseCharacter", player, character)

		if (fault == nil or fault == true) then
			local players = #Clockwork.faction:GetPlayers(character.faction)
			local limit = Clockwork.faction:GetLimit(factionTable.name)
			local ratio = factionTable.ratio;

			if (currentCharacter and character.faction == currentCharacter.faction) then
				players = players - 1
			end

			if (hook.Run("PlayerCanBypassFactionLimit", player, character)) then
				limit = nil
				ratio = nil
			end
			
			if factionTable.characterLimit and !player:IsAdmin() then
				local chars = 0;
			
				for k, v in pairs(player.cwCharacterList) do
					if v ~= character and v.faction == character.faction and !v.data["permakilled"] then
						chars = chars + 1;
					end
				end
				
				if chars >= factionTable.characterLimit then
					return false, "You cannot switch to this character as you have exceeded the character limit for this faction!";
				end
			end

			if (limit and limit ~= 0 and players == limit) then
				return false, "The "..character.faction.." faction is full ("..limit.."/"..limit..")!"
			elseif Clockwork.config:Get("faction_ratio_enabled"):Get() and (ratio and players > math.max(1, math.floor(ratio * _player.GetCount()))) then
				return false, "The "..character.faction.." faction is full!"
			else
				if (currentCharacter) then
					local fault = hook.Run("PlayerCanSwitchCharacter", player, character)

					if (fault != nil and fault != true) then
						return false, fault or "You cannot switch to this character!"
					end
					
					Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:SteamName().." has unloaded the character '"..currentCharacter.name.."'.")
				end

				Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:SteamName().." has loaded the character '"..character.name.."'.")

				self:LoadCharacter(player, characterID)

				return true
			end
		else
			return false, fault or "You cannot use this character!"
		end
	else
		return false, "You are already using this character!"
	end
end

-- A function to get a player's character.
function Clockwork.player:GetCharacter(player)
	return player.cwCharacter
end

-- A function to get a player's unrecognised name.
function Clockwork.player:GetUnrecognisedName(player, bFormatted)
	local unrecognisedPhysDesc = self:GetPhysDesc(player)
	local unrecognisedName = config.Get("unrecognised_name"):Get()
	local usedPhysDesc = false

	if (unrecognisedPhysDesc != "") then
		unrecognisedName = unrecognisedPhysDesc
		usedPhysDesc = true
	end

	if (bFormatted) then
		if (string.utf8len(unrecognisedName) > 24) then
			unrecognisedName = string.utf8sub(unrecognisedName, 1, 21).."..."
		end

		unrecognisedName = "["..unrecognisedName.."]"
	end

	return unrecognisedName, usedPhysDesc
end

-- A function to format text based on a relationship.
function Clockwork.player:FormatRecognisedText(player, text, ...)
	local arguments = {...}

	for i = 1, #arguments do
		if (string.find(text, "%%s") and IsValid(arguments[i])) then
			local unrecognisedName = "["..self:GetUnrecognisedName(arguments[i]).."]"

			if (self:DoesRecognise(player, arguments[i])) then
				unrecognisedName = arguments[i]:Name()
			end

			text = string.gsub(text, "%%s", unrecognisedName, 1)
		end
	end

	return text
end

-- A function to restore a recognised name.
function Clockwork.player:RestoreRecognisedName(player, target)
	local recognisedNames = player:GetRecognisedNames()
	local key = target:GetCharacterKey()

	if (recognisedNames[key]) then
		if (hook.Run("PlayerCanRestoreRecognisedName", player, target)) then
			self:SetRecognises(player, target, recognisedNames[key], true)
		else
			recognisedNames[key] = nil
		end
	end
end

-- A function to restore a player's recognised names.
function Clockwork.player:RestoreRecognisedNames(player)
	netstream.Start(player, "ClearRecognisedNames", true)

	if (config.Get("save_recognised_names"):Get()) then
		for _, v in _player.Iterator() do
			if (v:HasInitialized()) then
				self:RestoreRecognisedName(player, v)
				self:RestoreRecognisedName(v, player)
			end
		end
	end
end

-- A function to set whether a player recognises a player.
function Clockwork.player:SetRecognises(player, target, status, bForce)
	local recognisedNames = player:GetRecognisedNames()
	local name = target:Name()
	local key = target:GetCharacterKey()

	if (key == nil) then 
		if (player ~= target) then 
			print("CHARACTER KEY NIL FOR PLAYER "..string.upper(target:Name())) 
		end;
		
		return;
	end;

	if (status == RECOGNISE_SAVE) then
		if (config.Get("save_recognised_names"):Get()) then
			if (!hook.Run("PlayerCanSaveRecognisedName", player, target)) then
				status = RECOGNISE_TOTAL
			end
		else
			status = RECOGNISE_TOTAL
		end
	end

	if (!status or bForce or !self:DoesRecognise(player, target, status)) then
		recognisedNames[key] = status or nil

		netstream.Start(player, "RecognisedName", {
			key = key, status = (status or 0)
		})
	end
end

-- A function to get a player's physical description.
function Clockwork.player:GetPhysDesc(player)
	local physDesc = player:GetDTString(STRING_PHYSDESC)
	local team = player:Team()

	if (physDesc == "") then
		physDesc = Clockwork.class:Query(team, "defaultPhysDesc", "")
	end

	if (physDesc == "") then
		physDesc = config.Get("default_physdesc"):Get()
	end

	if (!physDesc or physDesc == "") then
		physDesc = "This character has no physical description set."
	else
		physDesc = Clockwork.kernel:ModifyPhysDesc(physDesc)
	end

	local override = hook.Run("GetPlayerPhysDescOverride", player, physDesc)

	if (override) then
		physDesc = override
	end

	return physDesc
end

-- A function to clear a player's recognised names list.
function Clockwork.player:ClearRecognisedNames(player, status, isAccurate)
	if (!status) then
		local character = player.cwCharacter;

		if (character) then
			character.recognisedNames = {}

			netstream.Start(player, "ClearRecognisedNames", true)
		end
	else
		for _, v in _player.Iterator() do
			if (v:HasInitialized()) then
				if (self:DoesRecognise(player, v, status, isAccurate)) then
					self:SetRecognises(player, v, false)
				end
			end
		end
	end

	hook.Run("PlayerRecognisedNamesCleared", player, status, isAccurate)
end

-- A function to clear a player's name from being recognised.
function Clockwork.player:ClearName(player, status, isAccurate)
	for _, v in _player.Iterator() do
		if (v:HasInitialized()) then
			if (!status or self:DoesRecognise(v, player, status, isAccurate)) then
				self:SetRecognises(v, player, false)
			end
		end
	end

	hook.Run("PlayerNameCleared", player, status, isAccurate)
end

-- A function to holsters all of a player's weapons.
function Clockwork.player:HolsterAll(player)
	for k, v in pairs(player:GetWeapons()) do
		local class = v:GetClass()
		local itemTable = item.GetByWeapon(v)

		if (itemTable and hook.Run("PlayerCanHolsterWeapon", player, itemTable, v, true, true)) then
			hook.Run("PlayerHolsterWeapon", player, itemTable, v, true)
			player:StripWeapon(class)
			player:GiveItem(itemTable, true)
		end
	end

	player:SelectWeapon("begotten_fists")
end

-- A function to set whether a player's character is banned.
function Clockwork.player:SetBanned(player, banned)
	player:SaveCharacter()
end

-- A function to set a player's name.
function Clockwork.player:SetName(player, name, saveless)
	local previousName = player:Name()
	local newName = name

	player:SetCharacterData("Name", newName, true)
	player:SetDTString(STRING_NAME, newName)

	if (!player.cwFirstSpawn) then
		hook.Run("PlayerNameChanged", player, previousName, newName)
	end

	if (!saveless) then
		player:SaveCharacter()
	end
end

-- A function to get a player's property entities.
function Clockwork.player:GetPropertyEntities(player, class)
	local uniqueID = player:UniqueID()
	local entities = {}
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		if (uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")) then
			if (key == Clockwork.entity:QueryProperty(v, "key")) then
				if (!class or v:GetClass() == class) then
					entities[#entities + 1] = v
				end
			end
		end
	end

	return entities
end

-- A function to get a player's property count.
function Clockwork.player:GetPropertyCount(player, class)
	local uniqueID = player:UniqueID()
	local count = 0
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		if (uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")) then
			if (key == Clockwork.entity:QueryProperty(v, "key")) then
				if (!class or v:GetClass() == class) then
					count = count + 1
				end
			end
		end
	end

	return count
end

-- A function to get a player's door count.
function Clockwork.player:GetDoorCount(player)
	local uniqueID = player:UniqueID()
	local count = 0
	local key = player:GetCharacterKey()

	for k, v in pairs(self:GetAllProperty()) do
		if (Clockwork.entity:IsDoor(v) and !Clockwork.entity:GetDoorParent(v)) then
			if (uniqueID == Clockwork.entity:QueryProperty(v, "uniqueID")) then
				if (player:GetCharacterKey() == Clockwork.entity:QueryProperty(v, "key")) then
					count = count + 1
				end
			end
		end
	end

	return count
end

-- A function to take a player's door access.
function Clockwork.player:TakeDoorAccess(player, door)
	if (door.accessList) then
		door.accessList[player:GetCharacterKey()] = false
	end
end

-- A function to give a player door access.
function Clockwork.player:GiveDoorAccess(player, door, access)
	local key = player:GetCharacterKey()

	if (!door.accessList) then
		door.accessList = {
			[key] = access
		}
	else
		door.accessList[key] = access
	end
end

-- A function to check if a player has door access.
function Clockwork.player:HasDoorAccess(player, door, access, isAccurate)
	if (!access) then
		return self:HasDoorAccess(player, door, DOOR_ACCESS_BASIC, isAccurate)
	else
		local doorParent = Clockwork.entity:GetDoorParent(door)
		local key = player:GetCharacterKey()

		if (doorParent and Clockwork.entity:DoorHasSharedAccess(doorParent)
		and (!door.accessList or door.accessList[key] == nil)) then
			return hook.Run("PlayerDoesHaveDoorAccess", player, doorParent, access, isAccurate)
		else
			return hook.Run("PlayerDoesHaveDoorAccess", player, door, access, isAccurate)
		end
	end
end

-- A function to check if a player can afford an amount.
function Clockwork.player:CanAfford(player, amount)
	if (config.Get("cash_enabled"):Get()) then
		return (player:GetCash() >= amount)
	else
		return true
	end
end

-- A function to give a player an amount of cash.
function Clockwork.player:GiveCash(player, amount, reason, bNoMsg)
	if (config.Get("cash_enabled"):Get()) then
		local positiveHintColor = "positive_hint"
		local negativeHintColor = "negative_hint"
		local roundedAmount = math.Round(amount)
		local cash = math.Round(math.max(player:GetCash() + roundedAmount, 0))

		player:SetCharacterData("Cash", cash, true)
		player:SetLocalVar("Cash", cash)

		if (roundedAmount < 0) then
			roundedAmount = math.abs(roundedAmount)

			if (!bNoMsg) then
				if (reason) then
					Clockwork.hint:Send(
						player, "Your character has lost the sum of "..Clockwork.kernel:FormatCash(roundedAmount).." ("..reason..").", 4, negativeHintColor
					)
				else
					Clockwork.hint:Send(
						player, "Your character has lost the sum of "..Clockwork.kernel:FormatCash(roundedAmount)..".", 4, negativeHintColor
					)
				end
			end
		elseif (roundedAmount > 0) then
			if (!bNoMsg) then
				if (reason) then
					Clockwork.hint:Send(
						player, "Your character has gained the sum of "..Clockwork.kernel:FormatCash(roundedAmount).." ("..reason..").", 4, positiveHintColor
					)
				else
					Clockwork.hint:Send(
						player, "Your character has gained the sum of "..Clockwork.kernel:FormatCash(roundedAmount)..".", 4, positiveHintColor
					)
				end
			end
		end

		hook.Run("PlayerCashUpdated", player, roundedAmount, reason, bNoMsg)
	end
end

-- A function to show cinematic text to a player.
function Clockwork.player:CinematicText(player, text, color, barLength, hangTime)
	netstream.Start(player, "CinematicText", {
		text = text,
		color = color,
		barLength = barLength,
		hangTime = hangTime
	})
end

-- A function to show cinematic text to each player.
function Clockwork.player:CinematicTextAll(text, color, hangTime)
	for _, v in _player.Iterator() do
		if (v:HasInitialized()) then
			self:CinematicText(v, text, color, hangTime)
		end
	end
end

-- A function to get if a player is protected.
function Clockwork.player:IsProtected(identifier)
	local steamID = nil
	local ownerSteamID = config.Get("owner_steamid"):Get()
	local bSuccess, value = pcall(IsValid, identifier)

	if (!bSuccess or value == false) then
		local player = _player.Find(identifier)

		if (IsValid(player)) then
			steamID = player:SteamID()
		end
	else
		steamID = identifier:SteamID()
	end

	if (string.find(ownerSteamID, ",")) then
		ownerSteamID = string.gsub(ownerSteamID, " ", "")
		ownerSteamID = string.Split(ownerSteamID, ",")

		for k, v in pairs(ownerSteamID) do
			if (steamID and steamID == v) then
				return true
			end
		end
	else
		if (steamID and steamID == ownerSteamID) then
			return true
		end
	end

	return false
end

-- A function to notify each player in a radius.
function Clockwork.player:NotifyInRadius(text, class, position, radius)
	local listeners = {}

	for _, v in _player.Iterator() do
		if (v:HasInitialized()) then
			if (position:DistToSqr(v:GetPos()) <= (radius * radius)) then
				listeners[#listeners + 1] = v
			end
		end
	end

	self:Notify(listeners, text, class)
end

-- A function to notify each player.
function Clockwork.player:NotifyAll(text, icon)
	-- Changing this to only notify admins for now. - DETrooper
	--self:Notify(nil, text, true, icon)
	
	Clockwork.player:NotifyAdmins("operator", text, icon);
end

--[[
	@codebase Server
	@details A function to notify admins by rank.
	@param String The rank and up that will be notified.
	@param String The text that will be sent to each admin.
	@param String The name of the icon that will be used in the message, can be nil.
--]]
function Clockwork.player:NotifyAdmins(adminLevel, text, icon)
	for k, v in pairs(player.GetAll()) do
		if (adminLevel == "operator" or adminLevel == "o") then
			if (v:IsAdmin()) then
				self:Notify(v, text, true, icon)
			end
		elseif (adminLevel == "admin" or adminLevel == "a") then
			if (v:IsAdmin() and !v:IsUserGroup("operator")) then
				self:Notify(v, text, true, icon)
			end
		elseif (adminLevel == "superadmin" or adminLevel == "s") then
			if (v:IsSuperAdmin()) then
				self:Notify(v, text, true, icon)
			end
		end
	end
end

-- A function to notify a player.
function Clockwork.player:Notify(player, text, class, icon)
	if (type(player) == "table") then
		for k, v in pairs(player) do
			self:Notify(v, text, class)
		end
	elseif (class == true) then
		if (icon) then
			local data = {icon = icon}
			
			Clockwork.chatBox:Add(player, nil, "notify_all", text, data)
		else
			Clockwork.chatBox:Add(player, nil, "notify_all", text)
		end
	elseif (!class) then
		if (icon) then
			Clockwork.chatBox:Add(player, nil, "notify", text, {icon = icon})
		else
			Clockwork.chatBox:Add(player, nil, "notify", text)
		end
	else
		cwDatastream:Start(player, "Notification", {text = text, class = class})
	end
end

-- A function to set a player's weapons list from a table.
function Clockwork.player:SetWeapons(player, weapons, bForceReturn)
	for k, v in pairs(weapons) do
		if (!player:HasWeapon(v.weaponData["class"])) then
			if (!v.teamIndex or player:Team() == v.teamIndex) then
				local weapon = player:Give(v.weaponData["class"], v.weaponData["itemTable"], bForceReturn);
				
				if IsValid(weapon) then
					local activeShield = v.weaponData["shield"];
					
					if activeShield and activeShield:len() > 0 then
						weapon:EquipShield(activeShield);
					end
				end
			end
		end
	end
end

-- A function to give ammo to a player from a table.
--[[function Clockwork.player:GiveAmmo(player, ammo)
	for k, v in pairs(ammo) do
		player:GiveAmmo(v, k)
	end
end]]--

-- A function to set a player's ammo list from a table.
--[[function Clockwork.player:SetAmmo(player, ammo)
	for k, v in pairs(ammo) do
		player:SetAmmo(v, k)
	end
end]]--

-- A function to get a player's ammo list as a table.
--[[function Clockwork.player:GetAmmo(player, bDoStrip)
	local spawnAmmo = self:GetSpawnAmmo(player)
	local ammoTypes = {}
	local ammo = {}

	for k, v in pairs(item.GetAll()) do
		if (v.ammoClass) then
			ammoTypes[v.ammoClass] = true
		end
	end

	hook.Run("AdjustAmmoTypes", ammoTypes)

	if (ammoTypes) then
		for k, v in pairs(ammoTypes) do
			if (v) then
				ammo[k] = player:GetAmmoCount(k)
			end
		end
	end

	if (spawnAmmo) then
		for k, v in pairs(spawnAmmo) do
			if (ammo[k]) then
				ammo[k] = math.max(ammo[k] - v, 0)
			end
		end
	end

	if (bDoStrip) then
		player:RemoveAllAmmo()
	end

	return ammo
end]]--

-- A function to get a player's weapons list as a table.
function Clockwork.player:GetWeapons(player, bDoKeep)
	local weapons = {}

	for k, v in pairs(player:GetWeapons()) do
		local itemTable = item.GetByWeapon(v)
		local teamIndex = player:Team()
		local class = v:GetClass()

		if (!self:GetSpawnWeapon(player, class)) then
			teamIndex = nil
		end

		weapons[#weapons + 1] = {
			weaponData = {
				itemTable = itemTable,
				class = class,
				shield = v:GetNWString("activeShield"),
			},
			teamIndex = teamIndex
		}

		if (!bDoKeep) then
			player:StripWeapon(class)
		end
	end

	return weapons
end

-- A function to get the total weight of a player's equipped weapons.
function Clockwork.player:GetEquippedWeight(player)
	local weight = 0

	for k, v in pairs(player:GetWeapons()) do
		local itemTable = item.GetByWeapon(v)

		if (itemTable) then
			weight = weight + itemTable.weight
		end
	end

	return weight
end

-- A function to get the total space of a player's equipped weapons.
function Clockwork.player:GetEquippedSpace(player)
	local space = 0

	for k, v in pairs(player:GetWeapons()) do
		local itemTable = item.GetByWeapon(v)

		if (itemTable) then
			space = space + itemTable.space
		end
	end

	return space
end

-- A function to get a player's holstered weapon.
function Clockwork.player:GetHolsteredWeapon(player)
	for k, v in pairs(player:GetWeapons()) do
		local itemTable = item.GetByWeapon(v)
		local class = v:GetClass()

		if (itemTable) then
			if (self:GetWeaponClass(player) != class) then
				return class
			end
		end
	end
end

-- A function to check whether a player is ragdolled.
function Clockwork.player:IsRagdolled(player, exception, bNoEntity)
	if (player:GetRagdollEntity() or bNoEntity) then
		local ragdolled = player:GetDTInt(INT_RAGDOLLSTATE)

		if (ragdolled == exception) then
			return false
		else
			return (ragdolled != RAGDOLL_NONE)
		end
	end
end

-- A function to set a player's unragdoll time.
function Clockwork.player:SetUnragdollTime(player, delay)
	player.cwRagdollPaused = nil;
	
	if (delay) then
		self:SetAction(player, "unragdoll", delay, 2, function()
			if (IsValid(player) and player:Alive()) then
				Clockwork.kernel:UnragdollTransition(player, delay);
			end;
		end);
	else
		self:SetAction(player, "unragdoll", false);
	end;
end;

-- A function to pause a player's unragdoll time.
function Clockwork.player:PauseUnragdollTime(player)
	if (!player.cwRagdollPaused) then
		local unragdollTime = self:GetUnragdollTime(player)
		local curTime = CurTime()

		if (player:IsRagdolled()) then
			if (unragdollTime > 0) then
				player.cwRagdollPaused = unragdollTime - curTime
				self:SetAction(player, "unragdoll", false)
			end
		end
	end
end

-- A function to start a player's unragdoll time.
function Clockwork.player:StartUnragdollTime(player)
	if (player.cwRagdollPaused) then
		if (player:IsRagdolled()) then
			self:SetUnragdollTime(player, player.cwRagdollPaused)

			player.cwRagdollPaused = nil
		end
	end
end

-- A function to get a player's unragdoll time.
function Clockwork.player:GetUnragdollTime(player)
	local action, actionDuration, startActionTime = self:GetAction(player)

	if (action == "unragdoll") then
		return startActionTime + actionDuration
	else
		return 0
	end
end

-- A function to get a player's ragdoll state.
function Clockwork.player:GetRagdollState(player)
	return player:GetDTInt(INT_RAGDOLLSTATE)
end

-- A function to get a player's ragdoll entity.
function Clockwork.player:GetRagdollEntity(player)
	local plyTable = player:GetTable();
	local ragdollTab = plyTable.cwRagdollTab;
	
	if (ragdollTab) then
		if (IsValid(ragdollTab.entity)) then
			return ragdollTab.entity
		end
	end
end

-- A function to get a player's ragdoll table.
function Clockwork.player:GetRagdollTable(player)
	return player.cwRagdollTab
end

-- A function to do a player's ragdoll decay check.
function Clockwork.player:DoRagdollDecayCheck(player, ragdoll)
	local index = ragdoll:EntIndex()

	timer.Create("DecayCheck"..index, 60, 0, function()
		local ragdollIsValid = IsValid(ragdoll)
		local playerIsValid = IsValid(player)

		if (!playerIsValid and ragdollIsValid) then
			if (!Clockwork.entity:IsDecaying(ragdoll)) then
				local decayTime = config.Get("body_decay_time"):Get()

				if (decayTime > 0 and hook.Run("PlayerCanRagdollDecay", player, ragdoll, decayTime)) then
					Clockwork.entity:Decay(ragdoll, decayTime)
				end
			else
				timer.Remove("DecayCheck"..index)
			end
		elseif (!ragdollIsValid) then
			timer.Remove("DecayCheck"..index)
		end
	end)
end

-- A function to set a player's ragdoll immunity.
function Clockwork.player:SetRagdollImmunity(player, delay)
	if (delay) then
		player:GetRagdollTable().immunity = CurTime() + delay
	else
		player:GetRagdollTable().immunity = 0
	end
end

-- A function to set a player's ragdoll state.
function Clockwork.player:SetRagdollState(player, state, delay, decay, force, multiplier, velocityCallback)
	if !IsValid(player) or !player:IsPlayer() then
		return;
	end
	
	if (state == RAGDOLL_KNOCKEDOUT or state == RAGDOLL_FALLENOVER) then
		Clockwork.player:SetAction(player, false);
		
		if (player:IsRagdolled()) then
			if (hook.Run("PlayerCanRagdoll", player, state, delay, decay, player.cwRagdollTab)) ~= false then
				self:SetUnragdollTime(player, delay)
					player:SetDTInt(INT_RAGDOLLSTATE, state)
					player.cwRagdollTab.delay = delay
					player.cwRagdollTab.decay = decay
				hook.Run("PlayerRagdolled", player, state, player.cwRagdollTab)
			end
		elseif (hook.Run("PlayerCanRagdoll", player, state, delay, decay)) ~= false then
			local velocity = player:GetVelocity() + (player:GetAimVector() * 128);
			local ragdoll = ents.Create("prop_ragdoll")
			local model = player:GetModel();
			local bodygroups = player:GetBodyGroups()
			
			velocity = Vector(velocity.x, velocity.y, 0);

			ragdoll:SetMaterial(player:GetMaterial())
			ragdoll:SetAngles(player:GetAngles())
			ragdoll:SetColor(player:GetColor())
			ragdoll:SetModel(model)
			ragdoll:SetSkin(player:GetSkin())
			ragdoll:SetPos(player:GetPos())
			ragdoll:SetBodygroup(0, player:GetBodygroup(0));
			ragdoll:SetBodygroup(1, player:GetBodygroup(1));
			ragdoll:Spawn()
			
			ragdoll.cwNextFallDamage = CurTime() + 1;

			if string.find(model, "models/begotten/heads") then
				local clothesItem = player:GetClothesEquipped();

				if clothesItem and clothesItem.group then
					if clothesItem.genderless then
						model = "models/begotten/"..clothesItem.group..".mdl";
					else
						model = "models/begotten/"..clothesItem.group.."_"..string.lower(player:GetGender())..".mdl";
					end
				else
					local faction = player:GetNetVar("kinisgerOverride") or player:GetFaction();
					local factionTable = Clockwork.faction:FindByID(faction);
					
					if factionTable then
						local subfaction = player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
						
						if subfaction and factionTable.subfactions then
							for i, v in ipairs(factionTable.subfactions) do
								if v.name == subfaction and v.models then
									model = v.models[string.lower(player:GetGender())].clothes;
								
									break;
								end
							end
						end
						
						if string.find(model, "models/begotten/heads") then
							model = factionTable.models[string.lower(player:GetGender())].clothes;
						end
					end
				end
				
				ragdoll:SetNWString("clothes", model);
			end

			player.cwRagdollTab = {}
			player.cwRagdollTab.eyeAngles = player:EyeAngles()
			player.cwRagdollTab.immunity = CurTime() + config.Get("ragdoll_immunity_time"):Get()
			player.cwRagdollTab.moveType = MOVETYPE_WALK
			player.cwRagdollTab.entity = ragdoll
			player.cwRagdollTab.health = player:Health()
			player.cwRagdollTab.armor = player:Armor()
			player.cwRagdollTab.delay = delay
			player.cwRagdollTab.decay = decay

			if (!player:IsOnGround()) then
				player.cwRagdollTab.immunity = 0
			end

			if (IsValid(ragdoll)) then
				local headIndex = ragdoll:LookupBone("ValveBiped.Bip01_Head1")

				ragdoll:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

				for i = 1, ragdoll:GetPhysicsObjectCount() do
					local physicsObject = ragdoll:GetPhysicsObjectNum(i)
					local boneIndex = ragdoll:TranslatePhysBoneToBone(i)
					local position, angle = player:GetBonePosition(boneIndex)

					if (IsValid(physicsObject)) then
						physicsObject:SetPos(position)
						physicsObject:SetAngles(angle)

						if (!velocityCallback) then
							if (boneIndex == headIndex) then
								physicsObject:SetVelocity(velocity * 1.5)
							else
								physicsObject:SetVelocity(velocity)
							end

							if (force) then
								if (boneIndex == headIndex) then
									physicsObject:ApplyForceCenter(force * 1.5)
								else
									physicsObject:ApplyForceCenter(force)
								end
							end
						else
							velocityCallback(physicsObject, boneIndex, ragdoll, velocity, force)
						end
					end
				end
			end

			if (player:Alive()) then
				if (IsValid(player:GetActiveWeapon())) then
					player.cwRagdollTab.weapon = self:GetWeaponClass(player)
				end

				player.cwRagdollTab.weapons = self:GetWeapons(player, true)

				if (delay) then
					self:SetUnragdollTime(player, delay)
				end
			end

			if (player:InVehicle()) then
				player:ExitVehicle()
				player.cwRagdollTab.eyeAngles = Angle(0, 0, 0)
			end

			if (player:IsOnFire()) then
				ragdoll:Ignite(8, 0)
			end

			player:Spectate(OBS_MODE_CHASE)
			player:RunCommand("-duck")
			player:RunCommand("-voicerecord")
			player:SetMoveType(MOVETYPE_OBSERVER)
			player:StripWeapons(true)
			player:SpectateEntity(ragdoll)
			player:CrosshairDisable()
			player:SetCanZoom(false);

			if (player:FlashlightIsOn()) then
				player:Flashlight(false)
			end

			player.cwRagdollPaused = nil

			player:SetDTInt(INT_RAGDOLLSTATE, state)
			player:SetDTEntity(2, ragdoll)

			if (state != RAGDOLL_FALLENOVER) then
				self:GiveDeathCode(player)
			end

			Clockwork.entity:SetPlayer(ragdoll, player)
			--self:DoRagdollDecayCheck(player, ragdoll)

			hook.Run("PlayerRagdolled", player, state, player.cwRagdollTab)
		end
	elseif (state == RAGDOLL_NONE or state == RAGDOLL_RESET) then
		if (player:IsRagdolled(nil, true)) then
			local ragdollTable = player:GetRagdollTable()

			if (hook.Run("PlayerCanUnragdoll", player, state, ragdollTable)) then
				player:UnSpectate()
				player:CrosshairEnable()

				if (state != RAGDOLL_RESET) then
					self:LightSpawn(player, nil, nil, true)
				end
				
				if IsValid(ragdollTable.entity) then
					-- Mark it worldspawn instead of nil so we know it used to be a player ragdoll.
					ragdollTable.entity:SetNWEntity("Player", game.GetWorld());
				end

				if (state != RAGDOLL_RESET) then
					if (IsValid(ragdollTable.entity)) then
						local velocity = ragdollTable.entity:GetVelocity()
						local position = Clockwork.entity:GetPelvisPosition(ragdollTable.entity)

						if (position) then
							self:SetSafePosition(player, position, ragdollTable.entity)
						end

						player:SetSkin(ragdollTable.entity:GetSkin())
						player:SetColor(ragdollTable.entity:GetColor())
						player:SetMaterial(ragdollTable.entity:GetMaterial())

						if (!ragdollTable.model) then
							player:SetModel(ragdollTable.entity:GetModel())
						else
							player:SetModel(ragdollTable.model)
						end

						if (!ragdollTable.skin) then
							player:SetSkin(ragdollTable.entity:GetSkin())
						else
							player:SetSkin(ragdollTable.skin)
						end

						player:SetVelocity(velocity)
					end

					player:SetArmor(ragdollTable.armor)
					player:SetHealth(ragdollTable.health)
					player:SetMoveType(ragdollTable.moveType)
					player:SetEyeAngles(ragdollTable.eyeAngles)
				end
				
				if (state == RAGDOLL_RESET) then
					if (IsValid(ragdollTable.entity) and player:Alive()) then
						timer.Remove("DecayCheck"..ragdollTable.entity:EntIndex())
						
						ragdollTable.entity:Remove();
					end
				end

				if (state != RAGDOLL_RESET) then
					self:SetWeapons(player, ragdollTable.weapons, true)

					if (ragdollTable.weapon) then
						player:SelectWeapon(ragdollTable.weapon)
					end
					
					local decay = ragdollTable.decay;

					if (decay) then
						if (hook.Run("PlayerCanRagdollDecay", player, ragdollTable.entity, decay)) then
							Clockwork.entity:Decay(ragdollTable.entity, decay)
						end
					elseif IsValid(ragdollTable.entity) then
						ragdollTable.entity:Remove()
					end
				end

				self:SetUnragdollTime(player, false)
					player:SetDTInt(INT_RAGDOLLSTATE, RAGDOLL_NONE)
					player:SetDTEntity(2, NULL)
				hook.Run("PlayerUnragdolled", player, state, ragdollTable)

				player.cwRagdollPaused = nil
				player.cwRagdollTab = {}
			end
		end
	end
end

-- A function to make a player drop their weapons.
function Clockwork.player:DropWeapons(player)
	local pos = player:GetPos();
	local ragdollEntity = player:GetRagdollEntity();
	local shieldItem = player:GetShieldEquipped();
	
	if IsValid(ragdollEntity) then
		pos = ragdollEntity:GetPos();
	end

	if shieldItem and hook.Run("PlayerCanDropWeapon", player, shieldItem, NULL, true) then
		local entity = Clockwork.entity:CreateItem(player, shieldItem, pos + Vector(0, 0, math.random(1, 48)), Angle(0, 0, 0));

		if (IsValid(entity)) then
			player:TakeItem(shieldItem);
		end
	end

	for i, v in ipairs(player:GetWeaponsEquipped()) do
		if (v and hook.Run("PlayerCanDropWeapon", player, v, NULL, true)) then
			local entity = Clockwork.entity:CreateItem(player, v, pos + Vector(0, 0, math.random(1, 48)), Angle(0, 0, 0));

			if (IsValid(entity)) then
				player:TakeItem(v);
			end
		end
	end
end

-- A function to lightly spawn a player.
function Clockwork.player:LightSpawn(player, weapons, ammo, bForceReturn)
	if (player:IsRagdolled() and !bForceReturn) then
		self:SetRagdollState(player, RAGDOLL_NONE)
	end

	player.cwLightSpawn = true

	local moveType = player:GetMoveType()
	local material = player:GetMaterial()
	local position = player:GetPos()
	local angles = player:EyeAngles()
	local weapon = player:GetActiveWeapon()
	local health = player:Health()
	local armor = player:Armor()
	local model = player:GetModel()
	local color = player:GetColor()	
	local skin = player:GetSkin()

	--[[if (ammo) then
		if (type(ammo) != "table") then
			ammo = self:GetAmmo(player, true)
		end
	end]]--

	if (weapons) then
		if (type(weapons) != "table") then
			weapons = self:GetWeapons(player)
		end

		if (IsValid(weapon)) then
			weapon = weapon:GetClass()
		end
	end

	player.cwSpawnCallback = function(player, gamemodeHook)
		player:SetPos(position)
		player:SetSkin(skin)
		player:SetModel(model)
		player:SetColor(color)
		player:SetArmor(armor)
		player:SetHealth(health)
		player:SetMaterial(material)
		player:SetMoveType(moveType)
		player:SetEyeAngles(angles)
		
		if (weapons) then
			hook.Run("PlayerLoadout", player)

			self:SetWeapons(player, weapons, bForceReturn)

			if (type(weapon) == "string") then
				player:SelectWeapon(weapon)
			end
		end

		--[[if (ammo) then
			self:GiveAmmo(player, ammo)
		end]]--

		if (gamemodeHook) then
			special = special or false

			hook.Run("PostPlayerLightSpawn", player, weapons, ammo, special)
		end

		player:ResetSequence(
			player:GetSequence()
		)
	end

	player:Spawn()
end

-- A function to convert a table to camel case.
function Clockwork.player:ConvertToCamelCase(baseTable)
	local newTable = {}

	for k, v in pairs(baseTable) do
		local key = Clockwork.kernel:SetCamelCase(string.gsub(k, "_", ""), true)

		if (key and key != "") then
			newTable[key] = v
		end
	end

	return newTable
end

-- A function to get a player's characters.
function Clockwork.player:GetCharacters(player, Callback)
	if (!IsValid(player)) then return end

	local charactersTable = config.Get("mysql_characters_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local queryObj = Clockwork.database:Select(charactersTable)
		queryObj:Where("_Schema", schemaFolder)
		queryObj:Where("_SteamID", player:SteamID())
		queryObj:Callback(function(result)
			if (!IsValid(player)) then return end

			if (Clockwork.database:IsResult(result)) then
				local characters = {}

				for k, v in pairs(result) do
					characters[k] = self:ConvertToCamelCase(v)
				end

				Callback(characters)
			else
				Callback()
			end
		end)
	queryObj:Execute()
end

-- A function to add a character to the character screen.
function Clockwork.player:CharacterScreenAdd(player, character)
	-- todo: make a hook that makes this cleaner instead of doing everything here
	local info = {
		name = character.name,
		model = character.data["powerArmor"] or character.model,
		skin = character.skin,
		gender = character.gender,
		faction = character.faction,
		subfaction = character.subfaction,
		permakilled = character.data["permakilled"],
		weapons = character.data["weapons"],
		characterID = character.characterID
	}

	if (character.data["PhysDesc"]) then
		if (string.utf8len(character.data["PhysDesc"]) > 64) then
			info.details = string.utf8sub(character.data["PhysDesc"], 1, 64).."..."
		else
			info.details = character.data["PhysDesc"]
		end
	end

	hook.Run("PlayerAdjustCharacterScreenInfo", player, character, info)
	netstream.Start(player, "CharacterAdd", info)
end

-- A function to convert a character's MySQL variables to Lua variables.
function Clockwork.player:ConvertCharacterMySQL(baseTable)
	baseTable.recognisedNames = self:ConvertCharacterRecognisedNamesString(baseTable.recognisedNames)
	baseTable.characterID = tonumber(baseTable.characterID)
	baseTable.attributes = self:ConvertCharacterDataString(baseTable.attributes)
	baseTable.traits = self:ConvertCharacterDataString(baseTable.traits)
	baseTable.inventory = Clockwork.inventory:ToLoadable(
		self:ConvertCharacterDataString(baseTable.inventory)
	)
	baseTable.cash = tonumber(baseTable.cash)
	baseTable.ammo = self:ConvertCharacterDataString(baseTable.ammo)
	baseTable.data = self:ConvertCharacterDataString(baseTable.data)
	baseTable.key = tonumber(baseTable.key)
end

-- A function to get a player's character ID.
function Clockwork.player:GetCharacterID(player)
	local character = player.cwCharacter

	if (character) then
		for k, v in pairs(player:GetCharacters()) do
			if (v == character) then
				return k
			end
		end
	end
end

-- A function to load a player's character.
function Clockwork.player:LoadCharacter(player, characterID, tMergeCreate, Callback, bForce)
	local character = {}
	local unixTime = os.time()

	if (tMergeCreate) then
		character = {}
		character.name = name
		character.data = {}
		character.ammo = {}
		character.cash = config.Get("default_cash"):Get()
		character.model = "models/police.mdl"
		character.skin = 0
		character.flags = "b"
		character.schema = Clockwork.kernel:GetSchemaFolder()
		character.gender = GENDER_MALE
		character.faction = FACTION_CITIZEN
		character.subfaction = "N/A"
		character.faith = "Faith of the Light"
		character.subfaith = "N/A"
		character.steamID = player:SteamID()
		character.steamName = player:SteamName()
		character.inventory = {}
		character.attributes = {}
		character.traits = { positive = {}, negative = {} }
		character.onNextLoad = ""
		character.lastPlayed = unixTime
		character.timeCreated = unixTime
		character.characterID = characterID
		character.recognisedNames = {}

		if (!player.cwCharacterList[characterID]) then
			table.Merge(character, tMergeCreate)

			if (character and type(character) == "table") then
				if (!bForce) then
					local fault = hook.Run("PlayerCanCreateCharacter", player, character, characterID)

					if (fault == false or type(fault) == "string") then
						return self:SetCreateFault(player, fault or "You cannot create this character!")
					end
				end
				
				character.inventory = {}
				hook.Run("GetPlayerDefaultInventory", player, character, character.inventory)
				hook.Run("PrePlayerCharacterCreated", player, character);

				self:SaveCharacter(player, true, character, function(key)
					player.cwCharacterList[characterID] = character
					player.cwCharacterList[characterID].key = key

					self:CharacterScreenAdd(player, character)

					if (Callback) then
						Callback()
					end
				end)
				
				hook.Run("PlayerCharacterCreated", player, character);
			end
		end
	else
		character = player.cwCharacterList[characterID]

		if (character) then
			if (player.cwCharacter) then
				hook.Run("PrePlayerCharacterUnloaded", player)
			
				self:SaveCharacter(player)
				self:UpdateCharacter(player)

				hook.Run("PlayerCharacterUnloaded", player)
			end

			player.cwCharacter = character

			if (player:Alive()) then
				player:KillSilent()
			end

			if (self:SetBasicSharedVars(player)) then
				hook.Run("PlayerCharacterLoaded", player)
				hook.Run("PostPlayerCharacterLoaded", player)
				player:SaveCharacter()
			end
		end
	end
end

function Clockwork.player:UnloadCharacter(player, Callback)
	if (player.cwCharacter) then
		hook.Run("PrePlayerCharacterUnloaded", player)
	
		self:SaveCharacter(player)

		hook.Run("PlayerCharacterUnloaded", player)
		
		player.cwCharacter = nil;
		player.cwInitialized = false;
		self:SetInitialized(player, false);
		self:SetCharacterMenuOpen(player, true);
		
		if (Callback) then
			Callback()
		end
	end
end

-- A function to set a player's basic shared variables.
function Clockwork.player:SetBasicSharedVars(player)
	local gender = player:GetGender()
	local playerFaction = player:GetFaction()

	player:SetDTString(STRING_FLAGS, player:GetFlags())
	player:SetNetVar("Model", self:GetDefaultModel(player))
	player:SetDTString(STRING_NAME, player:Name(true))
	player:SetNetVar("Key", player:GetCharacterKey())
	player:SetNetVar("CharacterID", player:GetCharacterID())
	player:SetNetVar("faith", player:GetFaith())
	player:SetNetVar("subfaith", player:GetSubfaith());
	player:SetNetVar("subfaction", player:GetSubfaction())

	if (Clockwork.faction:GetAll()[playerFaction]) then
		player:SetNetVar("Faction", Clockwork.faction:GetAll()[playerFaction].index)
	end

	if (gender == GENDER_MALE) then
		player:SetNetVar("Gender", 2)
	else
		player:SetNetVar("Gender", 1)
	end

	return true
end

-- A function to get the character's ammo as a string.
--[[function Clockwork.player:GetCharacterAmmoString(player, character, bRawTable)
	local ammo = table.Copy(character.ammo)

	for k, v in pairs(self:GetAmmo(player)) do
		if (v > 0) then
			ammo[k] = v
		end
	end

	if (!bRawTable) then
		return util.TableToJSON(ammo)
	else
		return ammo
	end
end]]--

-- A function to get the character's data as a string.
function Clockwork.player:GetCharacterDataString(player, character, bRawTable)
	local data = table.Copy(character.data)
	hook.Run("PlayerSaveCharacterData", player, data)

	if (!bRawTable) then
		return util.TableToJSON(data)
	else
		return data
	end
end

-- A function to get the character's recognised names as a string.
function Clockwork.player:GetCharacterRecognisedNamesString(player, character)
	local recognisedNames = {}

	for k, v in pairs(character.recognisedNames) do
		if (v == RECOGNISE_SAVE) then
			recognisedNames[#recognisedNames + 1] = k
		end
	end

	return util.TableToJSON(recognisedNames)
end

-- A function to get the character's inventory as a string.
function Clockwork.player:GetCharacterInventoryString(player, character, bRawTable)
	local inventory = Clockwork.inventory:CreateDuplicate(character.inventory)
	hook.Run("PlayerAddToSavedInventory", player, character, function(itemTable)
		Clockwork.inventory:AddInstance(inventory, itemTable)
	end)

	if (!bRawTable) then
		return util.TableToJSON(Clockwork.inventory:ToSaveable(inventory))
	else
		return inventory
	end
end

-- A function to convert a character's recognised names string to a table.
function Clockwork.player:ConvertCharacterRecognisedNamesString(data)
	local bSuccess, value = pcall(util.JSONToTable, data)

	if (bSuccess and value != nil) then
		local recognisedNames = {}

		for k, v in pairs(value) do
			recognisedNames[v] = RECOGNISE_SAVE
		end

		return recognisedNames
	else
		return {}
	end
end

-- A function to convert a character's data string to a table.
function Clockwork.player:ConvertCharacterDataString(data)
	local bSuccess, value = pcall(util.JSONToTable, data)

	if (bSuccess and value != nil) then
		return value
	else
		return {}
	end
end

-- A function to load a player's data.
function Clockwork.player:LoadData(player, Callback)
	local playersTable = config.Get("mysql_players_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local unixTime = os.time()
	local steamID = player:SteamID()

	local queryObj = Clockwork.database:Select(playersTable)
		queryObj:Where("_Schema", schemaFolder)
		queryObj:Where("_SteamID", steamID)
		queryObj:Callback(function(result)
			if (!IsValid(player)) then
				return
			end
			
			if (!player.CustomData) then
				player.CustomData = {}
			end
			
			local onNextPlay = ""
			
			if (Clockwork.database:IsResult(result)) then
				local timeJoined = tonumber(result[1]._TimeJoined)
				local lastPlayed = tonumber(result[1]._LastPlayed)
				local lenderSteamID = result[1]._LenderSteamID;
				local userGroup = result[1]._UserGroup
				local dataString = result[1]._Data
				local data = Clockwork.player:ConvertDataString(player, dataString)
				
				if (lenderSteamID and lenderSteamID != "") then
					player.cwLenderSteamID = lenderSteamID
				end;
				
				player.cwTimeJoined = timeJoined
				player.cwLastPlayed = lastPlayed
				player.cwUserGroup = userGroup
				player.CustomData = data

				onNextPlay = result[1]._OnNextPlay
			else
				
				player.cwLenderSteamID = "";
				player.cwTimeJoined = unixTime
				player.cwLastPlayed = unixTime
				player.cwUserGroup = "user"
				player.CustomData = self:SaveData(player, true)
			end
			
			if (self:IsProtected(player)) then
				player.cwUserGroup = "superadmin"
			end

			if (!player.cwUserGroup or player.cwUserGroup == "") then
				player.cwUserGroup = "user"
			end
			
			if (!config.Get("use_own_group_system"):Get() and player.cwUserGroup != "user") then
				player:SetUserGroup(player.cwUserGroup)
			end
			
			--plugin.Call("PlayerRestoreData", player, player.CustomData)
			hook.Run("PlayerRestoreData", player, player.CustomData);
			
			if (Callback and IsValid(player)) then
				Callback(player)
			end
			
			if (onNextPlay != "") then
				local updateObj = Clockwork.database:Update(playersTable)
					updateObj:Update("_OnNextPlay", "")
					updateObj:Update("_SteamID", steamID)
					updateObj:Update("_Schema", schemaFolder)
				updateObj:Push()

				PLAYER = player
					RunString(onNextPlay, md5.sumhexa(onNextPlay))
				PLAYER = nil
			end
		end)
	queryObj:Execute()

	timer.Simple(2, function()
		if (IsValid(player) and !player.CustomData) then
			self:LoadData(player, Callback)
		end
	end)
end

-- A function to save a players's data.
function Clockwork.player:SaveData(player, bCreate)
	local lenderSteamID = player:GetLender();

	if (!bCreate) then
		local steamName = Clockwork.database:Escape(player:SteamName())
		local playersTable = config.Get("mysql_players_table"):Get()
		local data = table.Copy(player.CustomData)
		local schemaFolder = Clockwork.kernel:GetSchemaFolder()
		local userGroup = player:GetClockworkUserGroup()
		local ipAddress = player:IPAddress()
		local steamID = player:SteamID()

		--plugin.Call("PlayerSaveData", player, data)
		hook.Run("PlayerSaveData", player, data)

		local queryObj = Clockwork.database:Update(playersTable)
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Where("_SteamID", steamID)
			queryObj:Update("_LastPlayed", os.time())
			queryObj:Update("_SteamName", steamName)
			queryObj:Update("_IPAddress", ipAddress)
			queryObj:Update("_LenderSteamID", lenderSteamID)
			queryObj:Update("_UserGroup", userGroup)
			queryObj:Update("_SteamID", steamID)
			queryObj:Update("_Schema", schemaFolder)
			queryObj:Update("_Data", util.TableToJSON(data))
		queryObj:Execute()

		player.CustomData = data
	else
		local playersTable = config.Get("mysql_players_table"):Get()
		local queryObj = Clockwork.database:Insert(playersTable)
			queryObj:Insert("_Data", "")
			queryObj:Insert("_Schema", Clockwork.kernel:GetSchemaFolder())
			queryObj:Insert("_SteamID", player:SteamID())
			queryObj:Insert("_Donations", "")
			queryObj:Insert("_UserGroup", "user")
			queryObj:Insert("_IPAddress", player:IPAddress())
			queryObj:Insert("_LenderSteamID", lenderSteamID)
			queryObj:Insert("_SteamName", player:SteamName())
			queryObj:Insert("_OnNextPlay", "")
			queryObj:Insert("_LastPlayed", os.time())
			queryObj:Insert("_TimeJoined", os.time())
		queryObj:Execute()

		return {}
	end
end

-- A function to update a player's character.
function Clockwork.player:UpdateCharacter(player)
	player.cwCharacter.inventory = self:GetCharacterInventoryString(player, player.cwCharacter, true)
	--player.cwCharacter.ammo = self:GetCharacterAmmoString(player, player.cwCharacter, true)
	player.cwCharacter.data = self:GetCharacterDataString(player, player.cwCharacter, true)
end

-- A function to save a player's character.
function Clockwork.player:SaveCharacter(player, bCreate, character, Callback)
	if (bCreate) then
		local charactersTable = config.Get("mysql_characters_table"):Get()
		local values = ""
		local amount = 1
		local keys = ""

		if (!character or type(character) != "table") then
			character = player.cwCharacter
		end

		local queryObj = Clockwork.database:Insert(charactersTable)
			for k, v in pairs(character) do
				local tableKey = "_"..Clockwork.kernel:SetCamelCase(k, false)

				if (k == "recognisedNames") then
					queryObj:Insert(tableKey, util.TableToJSON(character.recognisedNames))
				elseif (k == "attributes") then
					queryObj:Insert(tableKey, util.TableToJSON(character.attributes))
				elseif (k == "traits") then
					queryObj:Insert(tableKey, util.TableToJSON(character.traits))
				elseif (k == "inventory") then
					queryObj:Insert(tableKey, util.TableToJSON(Clockwork.inventory:ToSaveable(character.inventory)))
				--[[elseif (k == "ammo") then
					queryObj:Insert(tableKey, util.TableToJSON(character.ammo))]]--
				elseif (k == "data") then
					queryObj:Insert(tableKey, util.TableToJSON(v))
				else
					queryObj:Insert(tableKey, v)
				end
			end

			if (system.IsWindows()) then
				queryObj:Callback(function(result, status, lastID)
					if (Callback) then
						Callback(tonumber(lastID))
					end
				end)
			elseif (system.IsLinux()) then
				queryObj:Callback(function(result, status, lastID)
					if (Callback) then
						Callback(tonumber(lastID))
					end
				end)
			end
		queryObj:Execute()
	elseif (player:HasInitialized()) then
		local currentCharacter = player.cwCharacter
		local charactersTable = config.Get("mysql_characters_table"):Get()
		local schemaFolder = Clockwork.kernel:GetSchemaFolder()
		local unixTime = os.time()
		local steamID = player:SteamID()

		if (!character) then
			character = currentCharacter
		end
		
		if (!character.subfaith) then
			character.subfaith = player:GetSubfaith() or "N/A";
		end

		local queryObj = Clockwork.database:Update(charactersTable)
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Where("_SteamID", steamID)
			queryObj:Where("_CharacterID", character.characterID)
			queryObj:Update("_RecognisedNames", self:GetCharacterRecognisedNamesString(player, character))
			queryObj:Update("_Attributes", util.TableToJSON(character.attributes))
			queryObj:Update("_Traits", util.TableToJSON(character.traits))
			queryObj:Update("_LastPlayed", unixTime)
			queryObj:Update("_SteamName", player:SteamName())
			queryObj:Update("_Faction", character.faction)
			queryObj:Update("_Subfaction", character.subfaction)
			queryObj:Update("_Faith", character.faith)
			queryObj:Update("_Subfaith", character.subfaith)
			queryObj:Update("_Gender", character.gender)
			queryObj:Update("_Schema", character.schema)
			queryObj:Update("_Model", character.model)
			queryObj:Update("_Skin", character.skin)
			queryObj:Update("_Flags", character.flags)
			queryObj:Update("_Cash", character.cash)
			queryObj:Update("_Name", character.name)

			if (currentCharacter == character) then
				queryObj:Update("_Inventory", self:GetCharacterInventoryString(player, character))
				---queryObj:Update("_Ammo", self:GetCharacterAmmoString(player, character))
				queryObj:Update("_Data", self:GetCharacterDataString(player, character))
			else
				queryObj:Update("_Inventory", util.TableToJSON(Clockwork.inventory:ToSaveable(character.inventory)))
				--queryObj:Update("_Ammo", util.TableToJSON(character.ammo))
				queryObj:Update("_Data", util.TableToJSON(character.data))
			end
		queryObj:Execute()

		--[[ Save the player's data after pushing the update. --]]
		self:SaveData(player)
	end
end

-- A function to get the class of a player's active weapon.
function Clockwork.player:GetWeaponClass(player, safe)
	if (IsValid(player:GetActiveWeapon())) then
		return player:GetActiveWeapon():GetClass()
	else
		return safe
	end
end

-- A function to get a player's wages.
function Clockwork.player:GetWages(player)
	--return player:GetNetVar("Wages")
	return player.cwInfoTable.wages;
end

-- A function to set a character's flags.
function Clockwork.player:SetFlags(player, flags)
	self:TakeFlags(player, player:GetFlags())
	self:GiveFlags(player, flags)
end

-- A function to set a player's flags.
function Clockwork.player:SetPlayerFlags(player, flags)
	self:TakePlayerFlags(player, player:GetPlayerFlags())
	self:GivePlayerFlags(player, flags)
end

-- A function to set a player's rank within their faction.
function Clockwork.player:SetFactionRank(player, rank)
	if (rank) then
		local faction = Clockwork.faction:FindByID(player:GetFaction())

		if (faction and istable(faction.ranks)) then
			for k, v in pairs(faction.ranks) do
				if (k == rank) then
					player:SetCharacterData("factionrank", k)

					if (v.class and Clockwork.class:GetAll()[v.class]) then
						Clockwork.class:Set(player, v.class)
					end

					if (v.model) then
						player:SetModel(v.model)
					end

					if (istable(v.weapons)) then
						for k, v in pairs(v.weapons) do
							self:GiveSpawnWeapon(player, v)
						end
					end

					break
				end
			end
		end
	end
end

-- A function to get a player's global flags.
function Clockwork.player:GetPlayerFlags(player)
	return player:GetData("Flags") or ""
end

local playerMeta = FindMetaTable("Player")

function playerMeta:GiveCash(amount, reason, bNoMsg)
	return Clockwork.player:GiveCash(self, amount, reason, bNoMsg)
end

function playerMeta:Notify(text, class, icon)
	return Clockwork.player:Notify(self, text, class, icon)
end