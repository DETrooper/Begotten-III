--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

netstream.Hook("SendCountryCode", function(player, data)
	if (player.CountryCodeRequested) then
		player.CountryCodeRequested = nil;
		
		Clockwork.kernel:CountryCode(player, data);
	end;
end);

netstream.Hook("GetTargetRecognises", function(player, data)
	if (IsValid(data) and data:IsPlayer()) then
		player:SetNetVar("TargetKnows", Clockwork.player:DoesRecognise(data, player))
	end
end)

netstream.Hook("EntityMenuOption", function(player, data)
	local entity = data[1]
	local option = data[2]
	local shootPos = player:GetShootPos()
	local arguments = data[3]
	local curTime = CurTime()

	if (IsValid(entity) and type(option) == "string") then
		if (entity:NearestPoint(shootPos):Distance(shootPos) <= 80) then
			if (hook.Run("PlayerUse", player, entity)) then
				if (!player.nextEntityHandle or player.nextEntityHandle <= curTime) then
					hook.Run("EntityHandleMenuOption", player, entity, option, arguments)

					player.nextEntityHandle = curTime + config.Get("entity_handle_time"):Get()
				else
					Schema:EasyText(player, "grey", "You cannot use another entity that fast!")
				end
			end
		end
	end
end)

netstream.Hook("MenuOption", function(player, data)
	local itemID = data.item
	local option = data.option
	local entity = data.entity
	local data = data.data
	local shootPos = player:GetShootPos()

	if (type(data) != "table") then
		data = {data}
	end

	local itemTable = item.FindInstance(itemID)
	if (itemTable and itemTable:IsInstance() and type(option) == "string") then
		if (itemTable.HandleOptions) then
			if (player:HasItemInstance(itemTable)) then
				itemTable:HandleOptions(option, player, data)
			elseif (IsValid(entity) and entity:GetClass() == "cw_item" and entity:GetItemTable() == itemTable and entity:NearestPoint(shootPos):Distance(shootPos) <= 80) then
				itemTable:HandleOptions(option, player, data, entity)
			end
		end
	end
end)

netstream.Hook("DataStreamInfoSent", function(player, data)
	if (!player.cwDatastreamInfoSent) then
		hook.Run("PlayerDataStreamInfoSent", player)

		timer.Simple(FrameTime() * 32, function()
			if (IsValid(player)) then
				netstream.Start(player, "DataStreamed", true)
			end
		end)

		player.cwDatastreamInfoSent = true
	end
end)

netstream.Hook("LocalPlayerCreated", function(player, data)
	if (IsValid(player) and !player:HasConfigInitialized()) then
		timer.Create("SendCfg"..player:UniqueID(), FrameTime(), 1, function()
			if (IsValid(player)) then
				config.Send(player)
			end
		end)		
	end
end)

netstream.Hook("InteractCharacter", function(player, data)
	local characterID = data.characterID
	local action = data.action

	if (characterID and action) then
		local character = player:GetCharacters()[characterID]

		if (character) then
			local fault = hook.Run("PlayerCanInteractCharacter", player, action, character)

			if (fault == false or type(fault) == "string") then
				return Clockwork.player:SetCreateFault(fault or "You cannot interact with this character!")
			elseif (action == "delete") then
				local bSuccess, fault = Clockwork.player:DeleteCharacter(player, characterID)

				if (!bSuccess) then
					Clockwork.player:SetCreateFault(player, fault)
				end
			elseif (action == "use") then
				local bSuccess, fault = Clockwork.player:UseCharacter(player, characterID)

				if (!bSuccess) then
					Clockwork.player:SetCreateFault(player, fault)
				end
			else
				hook.Run("PlayerSelectCustomCharacterOption", player, action, character)
			end
		end
	end
end)

netstream.Hook("UnpermakillCharacter", function(player, data)
	if player:IsAdmin() then
		local characterID = data.characterID;
		local target = data.target;
		
		if !target then
			target = player;
		end

		if (characterID) and IsValid(target) then
			local character = target:GetCharacters()[characterID];

			if (!character) then
				Schema:EasyText(player, "grey", characterID.." is not a valid character!");
				return 
			end
			
			local oldValue = character.data["permakilled"]
			character.data["permakilled"] = false

			if (!netvars.AreEqual(false, oldValue)) then
				Clockwork.player:UpdateCharacterData(target, "permakilled", false)

				--plugin.Call("PlayerCharacterDataChanged", target, "permakilled", oldValue, false)
				hook.Run("PlayerCharacterDataChanged", target, "permakilled", oldValue, false)
				local name = character.name or "N/A"
				Schema:EasyText(player, "cornflowerblue", "You have unpermakilled "..target:SteamName().."'s character \""..name.."\"!");
			else
				Schema:EasyText(player, "grey", "This character is not permakilled!");
			end
		
			Clockwork.player:SaveCharacter(player);
			
			for k, v in pairs(target.cwCharacterList) do
				local bDelete = hook.Run("PlayerAdjustCharacterTable", target, v)

				if (!bDelete) then
					Clockwork.player:CharacterScreenAdd(target, v)
				else
					Clockwork.player:ForceDeleteCharacter(target, k)
				end
			end
		end
	end
end)

netstream.Hook("GetQuizStatus", function(player, data)
	if (!Clockwork.quiz:GetEnabled() or Clockwork.quiz:GetCompleted(player)) then
		netstream.Start(player, "QuizCompleted", true)
	else
		netstream.Start(player, "QuizCompleted", false)
	end
end)

netstream.Hook("DoorManagement", function(player, data)
	if (IsValid(data[1]) and player:GetEyeTraceNoCursor().Entity == data[1]) then
		if (data[1]:GetPos():Distance(player:GetPos()) <= 192) then
			if (data[2] == "Purchase") then
				if (!Clockwork.entity:GetOwner(data[1])) then
					if (hook.Run("PlayerCanOwnDoor", player, data[1]) != false) then
						local doors = Clockwork.player:GetDoorCount(player)

						if (doors == config.Get("max_doors"):Get()) then
							Schema:EasyText(player, "peru", "You cannot purchase another door!")
						else
							local doorCost = config.Get("door_cost"):Get()

							if (doorCost == 0 or Clockwork.player:CanAfford(player, doorCost)) then
								local doorName = Clockwork.entity:GetDoorName(data[1])

								if (doorName == "false" or doorName == "hidden" or doorName == "") then
									doorName = "Door"
								end

								if (doorCost > 0) then
									Clockwork.player:GiveCash(player, -doorCost, doorName)
								end

								Clockwork.player:GiveDoor(player, data[1])
							else
								Schema:EasyText(player, "olive", "You need another "..Clockwork.kernel:FormatCash(doorCost - player:GetCash(), nil, true).."!");
							end
						end
					end
				end
			elseif (data[2] == "Access") then
				if (Clockwork.player:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE)) then
					if (IsValid(data[3]) and data[3] != player and data[3] != Clockwork.entity:GetOwner(data[1])) then
						if (data[4] == DOOR_ACCESS_COMPLETE) then
							if (Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE)) then
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)
							else
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE)
							end
						elseif (data[4] == DOOR_ACCESS_BASIC) then
							if (Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)) then
								Clockwork.player:TakeDoorAccess(data[3], data[1])
							else
								Clockwork.player:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)
							end
						end

						if (Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE)) then
							netstream.Start(player, "DoorAccess", {data[3], DOOR_ACCESS_COMPLETE})
						elseif (Clockwork.player:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)) then
							netstream.Start(player, "DoorAccess", {data[3], DOOR_ACCESS_BASIC})
						else
							netstream.Start(player, "DoorAccess", {data[3]})
						end
					end
				end
			elseif (data[2] == "Unshare") then
				if (Clockwork.entity:IsDoorParent(data[1])) then
					if (data[3] == "Text") then
						netstream.Start(player, "SetSharedText", false)

						data[1].cwDoorSharedTxt = nil
					else
						netstream.Start(player, "SetSharedAccess", false)

						data[1].cwDoorSharedAxs = nil
					end
				end
			elseif (data[2] == "Share") then
				if (Clockwork.entity:IsDoorParent(data[1])) then
					if (data[3] == "Text") then
						netstream.Start(player, "SetSharedText", true)

						data[1].cwDoorSharedTxt = true
					else
						netstream.Start(player, "SetSharedAccess", true)

						data[1].cwDoorSharedAxs = true
					end
				end
			elseif (data[2] == "Text" and data[3] != "") then
				if (Clockwork.player:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE)) then
					if (!string.find(string.gsub(string.lower(data[3]), "%s", ""), "thisdoorcanbepurchased") and string.find(data[3], "%w")) then
						Clockwork.entity:SetDoorText(data[1], string.utf8sub(data[3], 1, 32))
					end
				end
			elseif (data[2] == "Sell") then
				if (Clockwork.entity:GetOwner(data[1]) == player) then
					if (!Clockwork.entity:IsDoorUnsellable(data[1])) then
						Clockwork.player:TakeDoor(player, data[1])
					end
				end
			end
		end
	end
end)

netstream.Hook("CreateCharacter", function(player, data)
	Clockwork.player:CreateCharacterFromData(player, data)
end)

netstream.Hook("RecogniseOption", function(player, data)
	local recogniseData = data

	if (config.Get("recognise_system"):Get()) then
		if (type(recogniseData) == "string") then	
			local playSound = false

			if (recogniseData == "look") then
				local target = player:GetEyeTraceNoCursor().Entity

				if target:IsPlayer() then
					if (target:HasInitialized() and !Clockwork.player:IsNoClipping(target) and target != player) then
						Clockwork.player:SetRecognises(target, player, RECOGNISE_SAVE)

						playSound = true
					end
				end
			else
				local position = player:GetPos()
				local plyTable = _player.GetAll()
				local talkRadius = config.Get("talk_radius"):Get()

				for k, v in ipairs(plyTable) do
					if (v:HasInitialized() and player != v) then
						if (!Clockwork.player:IsNoClipping(v)) then
							local distance = v:GetPos():Distance(position)
							local recognise = false

							if (recogniseData == "whisper") then
								if (distance <= math.min(talkRadius / 3, 80)) then
									recognise = true
								end
							elseif (recogniseData == "yell") then
								if (distance <= talkRadius * 2) then
									recognise = true
								end
							elseif (recogniseData == "talk") then
								if (distance <= talkRadius) then
									recognise = true
								end
							end

							if (recognise) then
								Clockwork.player:SetRecognises(v, player, RECOGNISE_SAVE)

								if (!playSound) then
									playSound = true
								end
							end
						end
					end
				end
			end

			if (playSound) then
				Clockwork.player:PlaySound(player, "buttons/button17.wav")
			end
		end
	end
end)

netstream.Hook("QuizCompleted", function(player, data)
	if (player.cwQuizAnswers and !Clockwork.quiz:GetCompleted(player)) then
		local questionsAmount = Clockwork.quiz:GetQuestionsAmount()
		local correctAnswers = 0
		local quizQuestions = Clockwork.quiz:GetQuestions()

		for k, v in pairs(quizQuestions) do
			if (player.cwQuizAnswers[k]) then
				if (Clockwork.quiz:IsAnswerCorrect(k, player.cwQuizAnswers[k])) then
					correctAnswers = correctAnswers + 1
				end
			end
		end
		
		--printp(correctAnswers);
		--printp(math.Round(questionsAmount * (Clockwork.quiz:GetPercentage() / 100)));

		if (correctAnswers < math.Round(questionsAmount * (Clockwork.quiz:GetPercentage() / 100))) then
			Clockwork.quiz:CallKickCallback(player, correctAnswers)
		else
			Clockwork.quiz:SetCompleted(player, true)
		end
	end
end)

netstream.Hook("UnequipItem", function(player, data)
	local arguments = data[3]
	local uniqueID = data[1]
	local itemID = data[2]

	if (!player:Alive() or player:IsRagdolled()) then
		return
	end
	
	if cwDueling then
		if player.opponent then
			Schema:EasyText(player, "peru", "You cannot unequip items while in a duel!");
			return;
		elseif cwDueling:PlayerIsInMatchmaking(player) then
			Schema:EasyText(player, "peru", "You cannot unequip items while matchmaking for a duel!");
			return;
		end
	end
	
	local itemTable = player:FindItemByID(uniqueID, itemID)

	if (!itemTable) then
		itemTable = player:FindWeaponItemByID(uniqueID, itemID)
	end

	if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
		if (itemTable:HasPlayerEquipped(player, arguments)) then
			itemTable:OnPlayerUnequipped(player, arguments)
			--player:SetWeaponRaised(false)
			
			player:RebuildInventory()
		end
	end
end)

netstream.Hook("UseAmmo", function(player, data)
	if data and data[1] and data[2] and data[3] and data[4] then
		local ammoUniqueID = data[1]
		local ammoItemID = data[2]
		local firearmUniqueID = data[3]
		local firearmItemID = data[4]

		if (!player:Alive() or player:IsRagdolled()) then
			return
		end

		local ammoItemTable = player:FindItemByID(ammoUniqueID, ammoItemID);
		local firearmItemTable = player:FindItemByID(firearmUniqueID, firearmItemID);
		
		if (!firearmItemTable) then
			firearmItemTable = player:FindWeaponItemByID(firearmUniqueID, firearmItemID);
		end

		if (ammoItemTable and firearmItemTable and ammoItemTable.CanUseOnItem) then
			--if (firearmItemTable:HasPlayerEquipped(player)) then
				if ammoItemTable:CanUseOnItem(player, firearmItemTable, true) then
					ammoItemTable:UseOnItem(player, firearmItemTable, true);
					--player:TakeItem(ammoItemTable, true);
				end
			--end
		end
	end
end)

netstream.Hook("MergeRepair", function(player, data)
	if data and data[1] and data[2] and data[3] and data[4] then
		local repairerUniqueID = data[1]
		local repairerItemID = data[2]
		local repaireeUniqueID = data[3]
		local repaireeItemID = data[4]

		if (!player:Alive() or player:IsRagdolled()) then
			return
		end

		local repairerItemTable = player:FindItemByID(repairerUniqueID, repairerItemID);
		local repaireeItemTable = player:FindItemByID(repaireeUniqueID, repaireeItemID);

		if (repairerItemTable and repaireeItemTable) then
			if repairerItemID == repaireeItemID then
				Schema:EasyText(player, "peru", "You cannot repair an item with the same instance of the item!");
				return;
			end
		
			if !cwBeliefs or (cwBeliefs and player:HasBelief("mechanic")) then
				local repairerCondition = repairerItemTable:GetCondition();
				local repaireeCondition = repaireeItemTable:GetCondition();
				
				if repairerCondition <= 0 then
					Schema:EasyText(player, "peru", "You cannot repair an item with a broken item!");
					return;
				end
			
				if repaireeCondition < 100 then
					if repaireeCondition <= 0 then
						if cwBeliefs and !player:HasBelief("artisan") then
							Schema:EasyText(player, "peru", "The "..(repaireeItemTable.name or "item").." is broken and cannot be repaired without the 'Artisan' belief!");
							return;
						end
					end
					
					repaireeItemTable:SetCondition(math.min(repaireeCondition + repairerCondition, 100));
					
					player:TakeItem(repairerItemTable, true);
					
					Schema:EasyText(player, "cornflowerblue", "You have repaired a "..(repaireeItemTable.name or "item").." with another item of its type.");
				else
					Schema:EasyText(player, "peru", "The "..(repaireeItemTable.name or "item").." you are trying to repair is not damaged!");
					return;
				end
			else
				Schema:EasyText(player, "peru", "The "..(repaireeItemTable.name or "item").." cannot be repaired with another item without the 'Mechanic' belief!");
			end
		end
	end
end)


netstream.Hook("MergeAmmoMagazine", function(player, data)
	if data and data[1] and data[2] and data[3] and data[4] then
		local ammoUniqueID = data[1]
		local ammoItemID = data[2]
		local magazineUniqueID = data[3]
		local magazineItemID = data[4]

		if (!player:Alive() or player:IsRagdolled()) then
			return
		end

		local ammoItemTable = player:FindItemByID(ammoUniqueID, ammoItemID);
		local magazineItemTable = player:FindItemByID(magazineUniqueID, magazineItemID);

		if (ammoItemTable and magazineItemTable and ammoItemTable.UseOnMagazine) then
			if ammoItemTable:UseOnMagazine(player, magazineItemTable) then
				player:TakeItem(ammoItemTable, true);
			end
		end
	end
end)

netstream.Hook("TakeAmmoMagazine", function(player, data)
	if data and data[1] and data[2] and data[3] and data[4] then
		local ammoUniqueID = data[1]
		local ammoItemID = data[2]
		local magazineUniqueID = data[3]
		local magazineItemID = data[4]

		if (!player:Alive() or player:IsRagdolled()) then
			return
		end

		local ammoItemTable = player:FindItemByID(ammoUniqueID, ammoItemID);
		local magazineItemTable = player:FindItemByID(magazineUniqueID, magazineItemID);

		if (ammoItemTable and magazineItemTable and ammoItemTable.TakeFromMagazine) then
			ammoItemTable:TakeFromMagazine(player, magazineItemTable);
		end
	end
end)

netstream.Hook("QuizAnswer", function(player, data)
	if (!player.cwQuizAnswers) then
		player.cwQuizAnswers = {}
	end

	local question = data[1]
	local answer = data[2]

	if (Clockwork.quiz:GetQuestion(question)) then
		player.cwQuizAnswers[question] = answer
	end
end)

netstream.Hook("RefreshCharacterMenu", function(player)
	for k, v in pairs(player.cwCharacterList) do
		local bDelete = hook.Run("PlayerAdjustCharacterTable", player, v)

		if (!bDelete) then
			Clockwork.player:CharacterScreenAdd(player, v)
		else
			Clockwork.player:ForceDeleteCharacter(player, k)
		end
	end
end)