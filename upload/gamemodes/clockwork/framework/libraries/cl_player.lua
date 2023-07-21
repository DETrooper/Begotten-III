--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (!Clockwork.player) then
	include("sh_player.lua")
end

-- A function to get whether the local player can hold a weight.
function Clockwork.player:CanHoldWeight(weight)
	local inventoryWeight = Clockwork.inventory:CalculateWeight(
		Clockwork.inventory:GetClient()
	)

	--if (inventoryWeight + weight > self:GetMaxWeight()) then
	if (inventoryWeight + weight > self:GetMaxWeight() * 4) then
		return false
	else
		return true
	end
end

-- A function to get whether the local player can fit a space.
function Clockwork.player:CanHoldSpace(space)
	local inventorySpace = Clockwork.inventory:CalculateSpace(
		Clockwork.inventory:GetClient()
	)

	if (inventorySpace + space > self:GetMaxSpace()) then
		return false
	else
		return true
	end
end

-- A function to get the maximum amount of weight the local player can carry.
function Clockwork.player:GetMaxWeight()
	local itemsList = Clockwork.inventory:GetAsItemsList(
		Clockwork.inventory:GetClient()
	)

	local weight = Clockwork.Client:GetNetVar("InvWeight") or config.GetVal("default_inv_weight")

	--[[for k, v in pairs(itemsList) do
		local addInvWeight = v.addInvSpace

		if (addInvWeight) then
			weight = weight + addInvWeight
		end
	end]]--
	
	--[[if Clockwork.Client.bgBackpackData then
		local backpackItem = Clockwork.inventory:FindItemByID(
			Clockwork.inventory:GetClient(),
			Clockwork.Client.bgBackpackData.uniqueID, Clockwork.Client.bgBackpackData.itemID
		);
		
		if backpackItem and backpackItem.invSpace then
			weight = weight + backpackItem.invSpace;
		end
	end]]--

	return weight
end

-- A function to get the maximum amount of space the local player can carry.
function Clockwork.player:GetMaxSpace()
	local itemsList = Clockwork.inventory:GetAsItemsList(
		Clockwork.inventory:GetClient()
	)
	local space = Clockwork.Client:GetNetVar("InvSpace") or config.GetVal("default_inv_space")

	--[[for k, v in pairs(itemsList) do
		local addInvSpace = v.addInvVolume

		if (addInvSpace) then
			space = space + addInvSpace
		end
	end]]--
	
	--[[if Clockwork.Client.bgBackpackData and Clockwork.Client.bgBackpackData[1] then
		local backpackItem = Clockwork.inventory:FindItemByID(
			Clockwork.inventory:GetClient(),
			Clockwork.Client.bgBackpackData[1].uniqueID, Clockwork.Client.bgBackpackData[1].itemID
		);
		
		if backpackItem and backpackItem.invSpace then
			space = space + backpackItem.invSpace;
		end
	end]]--

	return space
end

-- A function to get the local player's clothes data.
function Clockwork.player:GetClothesData()
	return Clockwork.ClothesData
end

-- A function to get the local player's accessory data.
function Clockwork.player:GetAccessoryData()
	return Clockwork.AccessoryData
end

-- A function to get the local player's clothes item.
function Clockwork.player:GetClothesItem()
	local clothesData = self:GetClothesData()

	if (clothesData.itemID != nil and clothesData.uniqueID != nil) then
		return Clockwork.inventory:FindItemByID(
			Clockwork.inventory:GetClient(),
			clothesData.uniqueID, clothesData.itemID
		)
	end
end

-- A function to get whether the local player is wearing clothes.
function Clockwork.player:IsWearingClothes()
	return (self:GetClothesItem() != nil)
end

-- A function to get whether the local player has an accessory.
function Clockwork.player:HasAccessory(uniqueID)
	local accessoryData = self:GetAccessoryData()

	for k, v in pairs(accessoryData) do
		if (string.lower(v) == string.lower(uniqueID)) then
			return true
		end
	end

	return false
end

-- A function to get whether the local player is wearing an accessory.
function Clockwork.player:IsWearingAccessory(itemTable)
	local accessoryData = self:GetAccessoryData()
	local itemID = itemTable.itemID

	if (accessoryData[itemID]) then
		return true
	else
		return false
	end
end

-- A function to get whether the local player is wearing an item.
function Clockwork.player:IsWearingItem(itemTable)
	local clothesItem = self:GetClothesItem()
	return (clothesItem and clothesItem:IsTheSameAs(itemTable))
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

-- A function to get whether the local player's data has streamed.
function Clockwork.player:HasDataStreamed()
	return Clockwork.DataHasStreamed
end

-- A function to get whether a player can hear another player.
function Clockwork.player:CanHearPlayer(player, target, allowance)
	if (config.GetVal("messages_must_see_player")) then
		return self:CanSeePlayer(player, target, (allowance or 0.5), true)
	else
		return true
	end
end

-- A function to get whether the target recognises the local player.
function Clockwork.player:DoesTargetRecognise()
	if (config.GetVal("recognise_system")) then
		return Clockwork.Client:GetNetVar("TargetKnows")
	else
		return true
	end
end

-- A function to get a player's real trace.
function Clockwork.player:GetRealTrace(player, useFilterTrace)
	if (!IsValid(player)) then
		return
	end

	local angles = player:GetAimVector() * 4096
	local eyePos = EyePos()

	if (player != Clockwork.Client) then
		eyePos = player:EyePos()
	end

	local trace = util.TraceLine({
		endpos = eyePos + angles,
		start = eyePos,
		filter = player
	})

	local newTrace = util.TraceLine({
		endpos = eyePos + angles,
		filter = player,
		start = eyePos,
		mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	})

	if ((IsValid(newTrace.Entity) and !newTrace.HitWorld and (!IsValid(trace.Entity)
	or string.find(trace.Entity:GetClass(), "vehicle"))) or useFilterTrace) then
		trace = newTrace
	end

	return trace
end

-- A function to get the local player's action.
function Clockwork.player:GetAction(player, percentage)
	local startActionTime = player:GetNetVar("StartActTime") or 0
	local actionDuration = player:GetNetVar("ActDuration") or 0
	local curTime = CurTime()
	local action = player:GetNetVar("ActName") or "Unknown"

	if (curTime < startActionTime + actionDuration) then
		if (percentage) then
			return action, (100 / actionDuration) * (actionDuration - ((startActionTime + actionDuration) - curTime))
		else
			return action, actionDuration, startActionTime
		end
	else
		return "", 0, 0
	end
end

-- A function to get the local player's maximum characters.
function Clockwork.player:GetMaximumCharacters()
	if Clockwork.Client:IsAdmin() then
		return 100;
	else
		local whitelisted = Clockwork.character:GetWhitelisted()
		local maximum = config.Get("additional_characters"):Get(2)

		for k, v in pairs(Clockwork.faction:GetStored()) do
			if (!v.whitelist or table.HasValue(whitelisted, v.name)) then
				maximum = maximum + 1
			end
		end

		return maximum
	end
end

-- A function to get whether a player's weapon is raised.
function Clockwork.player:GetWeaponRaised(player)
	return player:IsWeaponRaised()
end

-- A function to get a player's unrecognised name.
function Clockwork.player:GetUnrecognisedName(player)
	local unrecognisedPhysDesc = self:GetPhysDesc(player)
	local unrecognisedName = config.Get("unrecognised_name"):Get()
	local usedPhysDesc

	if (unrecognisedPhysDesc) then
		unrecognisedName = unrecognisedPhysDesc
		usedPhysDesc = true
	end

	return unrecognisedName, usedPhysDesc
end

function Clockwork.player:GetName(target)
	if (self:DoesRecognise(target)) then
		return target:Name()
	else
		return self:GetUnrecognisedName(target)
	end
end

-- A function to get whether a player can see an NPC.
function Clockwork.player:CanSeeNPC(player, target, allowance, ignoreEnts)
	if (player:GetEyeTraceNoCursor().Entity == target) then
		return true
	else
		local trace = {}

		trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
		trace.start = player:GetShootPos()
		trace.endpos = target:GetShootPos()
		trace.filter = {player, target}

		if (ignoreEnts) then
			if (type(ignoreEnts) == "table") then
				table.Add(trace.filter, ignoreEnts)
			else
				table.Add(trace.filter, ents.GetAll())
			end
		end

		trace = util.TraceLine(trace)

		if (trace.Fraction >= (allowance or 0.75)) then
			return true
		end
	end
end

-- A function to get whether a player can see a player.
function Clockwork.player:CanSeePlayer(player, target, allowance, ignoreEnts)
	if (player:GetEyeTraceNoCursor().Entity == target) then
		return true
	elseif (target:GetEyeTraceNoCursor().Entity == player) then
		return true
	else
		local trace = {}

		trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
		trace.start = player:GetShootPos()
		trace.endpos = target:GetShootPos()
		trace.filter = {player, target}

		if (ignoreEnts) then
			if (type(ignoreEnts) == "table") then
				table.Add(trace.filter, ignoreEnts)
			else
				table.Add(trace.filter, ents.GetAll())
			end
		end

		trace = util.TraceLine(trace)

		if (trace.Fraction >= (allowance or 0.75)) then
			return true
		end
	end
end

-- A function to get whether a player can see an entity.
function Clockwork.player:CanSeeEntity(player, target, allowance, ignoreEnts)
	if (player:GetEyeTraceNoCursor().Entity == target) then
		return true
	else
		local trace = {}

		trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
		trace.start = player:GetShootPos()
		trace.endpos = target:LocalToWorld(target:OBBCenter())
		trace.filter = {player, target}

		if (ignoreEnts) then
			if (type(ignoreEnts) == "table") then
				table.Add(trace.filter, ignoreEnts)
			else
				table.Add(trace.filter, ents.GetAll())
			end
		end

		trace = util.TraceLine(trace)

		if (trace.Fraction >= (allowance or 0.75)) then
			return true
		end
	end
end

-- A function to get whether a player can see a position.
function Clockwork.player:CanSeePosition(player, position, allowance, ignoreEnts)
	local trace = {}

	trace.mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
	trace.start = player:GetShootPos()
	trace.endpos = position
	trace.filter = player

	if (ignoreEnts) then
		if (type(ignoreEnts) == "table") then
			table.Add(trace.filter, ignoreEnts)
		else
			table.Add(trace.filter, ents.GetAll())
		end
	end

	trace = util.TraceLine(trace)

	if (trace.Fraction >= (allowance or 0.75)) then
		return true
	end
end

-- A function to get a player's wages name.
function Clockwork.player:GetWagesName(player)
	return Clockwork.class:Query(player:Team(), "wagesName", config.Get("wages_name"):Get())
end

-- A function to check whether a player is ragdolled
function Clockwork.player:IsRagdolled(player, exception, entityless)
	if (player:GetRagdollEntity() or entityless) then
		if (player:GetDTInt(INT_RAGDOLLSTATE) == 0) then
			return false
		elseif (player:GetDTInt(INT_RAGDOLLSTATE) == exception) then
			return false
		else
			return (player:GetDTInt(INT_RAGDOLLSTATE) != RAGDOLL_NONE)
		end
	end
end

-- A function to get whether the local player recognises another player.
function Clockwork.player:DoesRecognise(player, status, isAccurate)
	if (!status) then
		return self:DoesRecognise(player, RECOGNISE_PARTIAL)
	elseif (config.Get("recognise_system"):Get()) then
		local key = self:GetCharacterKey(player)
		local realValue = false

		if (self:GetCharacterKey(Clockwork.Client) == key) then
			return true
		elseif (Clockwork.RecognisedNames[key]) then
			if (isAccurate) then
				realValue = (Clockwork.RecognisedNames[key] == status)
			else
				realValue = (Clockwork.RecognisedNames[key] >= status)
			end
		end

		return hook.Run("PlayerDoesRecognisePlayer", player, status, isAccurate, realValue)
	else
		return true
	end
end

-- A function to get a player's character key.
function Clockwork.player:GetCharacterKey(player)
	if (IsValid(player)) then
		return player:GetNetVar("Key")
	end
end

-- A function to get a player's ragdoll state.
function Clockwork.player:GetRagdollState(player)
	if (player:GetDTInt(INT_RAGDOLLSTATE) == 0) then
		return false
	else
		return player:GetDTInt(INT_RAGDOLLSTATE)
	end
end

-- A function to get a player's physical description.
function Clockwork.player:GetPhysDesc(player)
	if (!player) then
		player = Clockwork.Client
	end

	local physDesc = player:GetDTString(STRING_PHYSDESC)
	local team = player:Team()

	if (physDesc == "") then
		physDesc = Clockwork.class:Query(team, "defaultPhysDesc", "")
	end

	if (physDesc == "") then
		physDesc = config.Get("default_physdesc"):Get()
	end

	if (!physDesc or physDesc == "") then
		physDesc = "This character has no description."
	else
		physDesc = Clockwork.kernel:ModifyPhysDesc(physDesc)
	end

	local override = hook.Run("GetPlayerPhysDescOverride", player, physDesc)

	if (override) then
		physDesc = override
	end

	return physDesc
end

-- A function to get the local player's wages.
function Clockwork.player:GetWages()
	return Clockwork.Client:GetNetVar("Wages")
end

-- A function to get the local player's cash.
function Clockwork.player:GetCash()
	return Clockwork.Client:GetNetVar("Cash") or 0
end

-- A function to get a player's ragdoll entity.
function Clockwork.player:GetRagdollEntity(player)
	local ragdollEntity = player:GetDTEntity(2)

	if (IsValid(ragdollEntity)) then
		return ragdollEntity
	end
end

-- A function to get a player's default skin.
function Clockwork.player:GetDefaultSkin(player)
	local model, skin = Clockwork.class:GetAppropriateModel(player:Team(), player)

	return skin
end

-- A function to get a player's default model.
function Clockwork.player:GetDefaultModel(player)
	local model, skin = Clockwork.class:GetAppropriateModel(player:Team(), player)
	return model
end

-- A function to check if a player has any flags.
function Clockwork.player:HasAnyFlags(player, flags, bByDefault)
	local playerFlags = player:GetDTString(STRING_FLAGS)

	if (playerFlags != nil and playerFlags != "") then
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

-- A function to check if a player has access.
function Clockwork.player:HasFlags(player, flags, bByDefault, bIsStrict)
	local playerFlags = player:GetDTString(STRING_FLAGS)

	if (playerFlags != nil and playerFlags != "") then
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
					return false
				end
			end
		end

		return true
	end
end

-- A function to get whether the local player is drunk.
function Clockwork.player:GetDrunk()
	local isDrunk = LocalPlayer():GetNetVar("IsDrunk") or 0

	if (isDrunk and isDrunk > 0) then
		return isDrunk
	end
end

-- A function to get a player's chat icon.
function Clockwork.player:GetChatIcon(player)
	local icon

	if (!IsValid(player)) then
		return "icon16/user_delete.png"
	end

	for k, v in pairs(Clockwork.icon:GetAll()) do
		if (v.callback(player)) then
			if (!icon) then
				icon = v.path
			end

			if (v.isPlayer) then
				icon = v.path
				break
			end
		end
	end

	if (!icon) then
		local faction = player:GetFaction()
		icon = "icon16/user_gray.png"
		
		if (player:GetGender() == GENDER_FEMALE) then
			icon = "icon16/user_red.png"
		end;

		if (faction and Clockwork.faction:GetStored()[faction]) then
			if (Clockwork.faction:GetStored()[faction].whitelist) then
				icon = "icon16/add.png"
			end
		end
	end

	return icon
end

-- A function to create a player's gear.
function Clockwork.player:CreateGear(gearClass, itemID)
	if (!self.cwGearTab) then
		self.cwGearTab = {}
	end

	if (self.cwGearTab[gearClass]) then
		self.cwGearTab[gearClass] = nil;
	end
	
	--self.cwGearTab[gearClass] = itemTable;
	self.cwGearTab[gearClass] = itemID;
end

-- A function to get a player's gear.
function Clockwork.player:GetGear(gearClass)
	if (!self.cwGearTab) then
		self.cwGearTab = {}
	end
	
	if (self.cwGearTab and self.cwGearTab[gearClass]) then
		return self.cwGearTab[gearClass];
	end
end

-- A function to remove a player's gear.
function Clockwork.player:RemoveGear(gearClass)
	if (self.cwGearTab and self.cwGearTab[gearClass]) then
		self.cwGearTab[gearClass] = nil;
	end
	
	local slots = {"Primary", "Secondary", "Tertiary"};
	
	if not self.cwGearTab[slots[1]] then
		if self.cwGearTab[slots[2]] then
			self.cwGearTab[slots[1]] = self.cwGearTab[slots[2]];
			self.cwGearTab[slots[2]] = nil;
			
			if self.cwGearTab[slots[3]] then
				self.cwGearTab[slots[2]] = self.cwGearTab[slots[3]];
				self.cwGearTab[slots[3]] = nil;
			end
		elseif self.cwGearTab[slots[3]] then
			self.cwGearTab[slots[1]] = self.cwGearTab[slots[3]];
			self.cwGearTab[slots[3]] = nil;
		end
	elseif not self.cwGearTab[slots[2]] then
		if self.cwGearTab[slots[3]] then
			self.cwGearTab[slots[2]] = self.cwGearTab[slots[3]];
			self.cwGearTab[slots[3]] = nil;
		end
	end
end

-- A function to strip all of a player's gear.
function Clockwork.player:StripGear()
	self.cwGearTab = {};
end

local clothesItems;
local playerMeta = FindMetaTable("Player")

function playerMeta:GetClothesItem()
	local clothesString = self:GetSharedVar("clothesString");
	
	if !clothesItems then
		clothesItems = {};
	
		for k, v in pairs(item.GetStored()) do
			if v.category == "Armor" then
				clothesItems[v.uniqueID] = v;
			end
		end
	end
	
	if clothesString then
		for k, v in pairs(clothesItems) do
			if v.uniqueID == clothesString then
				return v;
			end
		end
	end
end