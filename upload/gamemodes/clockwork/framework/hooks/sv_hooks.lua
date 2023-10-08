--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DEFINE_BASECLASS("gamemode_base")

entsGetAllThisPlayerTick = {};
playerGetAllThisPlayerTick = {};

--[[
	@codebase Server
	@details Called when the server has initialized.
--]]
function GM:Initialize()
	item.Initialize()
	config.Import("gamemodes/clockwork/clockwork.cfg")
	config.SetInitialized(true)

	local useLocalMachineDate = config.GetVal("use_local_machine_date")
	local useLocalMachineTime = config.GetVal("use_local_machine_time")
	local defaultDate = Clockwork.option:GetKey("default_date")
	local defaultTime = Clockwork.option:GetKey("default_time")
	local defaultDays = Clockwork.option:GetKey("default_days")
	local username = config.GetVal("mysql_username")
	local password = config.GetVal("mysql_password")
	local database = config.GetVal("mysql_database")
	local dateInfo = os.date("*t")
	local host = string.gsub(config.GetVal("mysql_host"), "^http[s]?://", "", 1) -- Matches at beginning of string, matches http:// or https://, no need to check twice
	local port = config.GetVal("mysql_port")

	Clockwork.database.Module = "mysqloo"

	if (!host or host == "" or host == " " or host == "example.com" or host == "sqlite" or host == "example") then
		Clockwork.database.Module = "sqlite"
	end

	Clockwork.database:Connect(host, username, password, database, port)

	if (useLocalMachineTime) then
		config.Get("minute_time"):Set(60)
	end

	config.SetInitialized(true)

	table.Merge(Clockwork.time, defaultTime)
	table.Merge(Clockwork.date, defaultDate)
	math.randomseed(os.time())

	if (useLocalMachineTime) then
		local realDay = dateInfo.wday - 1

		if (realDay == 0) then
			realDay = #defaultDays
		end

		table.Merge(Clockwork.time, {
			minute = dateInfo.min,
			hour = dateInfo.hour,
			day = realDay
		})

		Clockwork.NextDateTimeThink = SysTime() + (60 - dateInfo.sec)
	else
		table.Merge(Clockwork.time, Clockwork.kernel:RestoreSchemaData("time"))
	end

	if (useLocalMachineDate) then
		dateInfo.year = dateInfo.year + (defaultDate.year - dateInfo.year)

		table.Merge(Clockwork.time, {
			month = dateInfo.month,
			year = dateInfo.year,
			day = dateInfo.yday
		})
	else
		table.Merge(Clockwork.date, Clockwork.kernel:RestoreSchemaData("date"))
	end

	CW_CONVAR_LOG = Clockwork.kernel:CreateConVar("cwLog", 1)

	for k, v in pairs(config.stored) do
		hook.Run("ClockworkConfigInitialized", k, v.value)
	end

	hook.Run("ClockworkInitialized")
end

function GM:OnePlayerSecond(player, curTime, infoTable)
	--local weaponClass = Clockwork.player:GetWeaponClass(player)
	--local color = player:GetColor()
	local isDrunk = Clockwork.player:GetDrunk(player)

	--player:HandleAttributeProgress(curTime)
	--player:HandleAttributeBoosts(curTime)

	player:SetDTString(STRING_FLAGS, player:GetFlags())
	player:SetNetVar("Model", player:GetDefaultModel())
	player:SetDTString(STRING_NAME, player:Name())
	player:SetNetVar("Cash", player:GetCash())
	player:SetNetVar("CustomColor", player:GetCharacterData("CustomColor"));

	if (player.cwDrunkTab) then
		for k, v in pairs(player.cwDrunkTab) do
			if (curTime >= v) then
				table.remove(player.cwDrunkTab, k)
			end
		end
	end

	if (isDrunk) then
		player:SetNetVar("IsDrunk", isDrunk)
	else
		player:SetNetVar("IsDrunk", 0)
	end

	--[[if (!config.GetVal("cash_enabled")) then
		player:SetCharacterData("Cash", 0, true)
		infoTable.wages = 0
	end]]--
end

-- Called at an interval while a player is connected.
function GM:PlayerThink(player, curTime, infoTable)
	--[[if (!player:InVehicle() and !player:IsRagdolled() and !player:IsBeingHeld() and player:Alive() and player:GetMoveType() == MOVETYPE_NOCLIP) then
		local color = player:GetColor()
			player:SetRenderMode(RENDERMODE_TRANSALPHA);
			player:DrawWorldModel(false)
			player:DrawShadow(false)
			player:SetNoDraw(true)
			player:SetNotSolid(true)
		player:SetColor(Color(color.r, color.g, color.b, 0))
	elseif (player.cwObserverMode) then
		if (!player.cwObserverReset) then
			Clockwork.kernel:MakePlayerExitObserverMode(player)
		end
	end]]--
	
	local waterLevel = player:WaterLevel();
	
	if (waterLevel >= 3) then
		player.submerged = true
		player.waterStartTime = player.waterStartTime or curTime
		
		if player:IsOnFire() then
			player:Extinguish();
		end
	else
		player.submerged = false
		player.waterStartTime = nil
		
		if (waterLevel > 1) then
			if player:IsOnFire() then
				player:Extinguish();
			end
		end
	end
	
	if !player.nextRagdollCheck or player.nextRagdollCheck < curTime then
		player.nextRagdollCheck = curTime + 1;
	
		if (player:IsRagdolled() and !player.cwObserverMode) then
			player:SetMoveType(MOVETYPE_OBSERVER)
			
			if player:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
				local action = Clockwork.player:GetAction(player);
				
				if action != "unragdoll" and action != "die" and action != "die_bleedout" then
					Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER);
				end
			end
		end
	end

	local storageTable = player:GetStorageTable()

	if (storageTable and hook.Run("PlayerStorageShouldClose", player, storageTable)) then
		Clockwork.storage:Close(player)
	end
	
	--[[local onGround = player:IsOnGround();
	
	if (onGround) then
		local crouching = player:KeyDown(IN_DUCK);
		local backwards = player:KeyDown(IN_BACK);
		local running = player:KeyDown(IN_SPEED);
		local modifier = crouching and 0.75 or 0.85;

		if (crouching) then
			infoTable.crouchedSpeed = infoTable.crouchedSpeed * modifier;
		end
		
		if (backwards) then
			infoTable.runSpeed = 20;
			printp(backwards)
		end;
		printp(infoTable.runSpeed)
	end;]]--
	
	if !player.nextInvThink or player.nextInvThink > curTime then
		local maxWeight = player:GetMaxWeight();

		infoTable.inventoryWeight = maxWeight;
		player.inventoryWeight = Clockwork.inventory:CalculateWeight(player:GetInventory());
		player.maxWeight = maxWeight;
		
		player:SetNetVar("InvWeight", math.ceil(infoTable.inventoryWeight))
		player:SetNetVar("InvSpace", math.ceil(infoTable.inventorySpace))
		--player:SetNetVar("Wages", math.ceil(infoTable.wages or 0))
		
		player.nextInvThink = curTime + 2;
	end
	
	--[[if !player.speedSetCooldown or player.speedSetCooldown < curTime then
		infoTable.walkSpeed = config.GetVal("walk_speed");
		infoTable.crouchedWalkSpeed = config.GetVal("crouched_speed");
		infoTable.jumpPower = config.GetVal("jump_power");
		infoTable.runSpeed = config.GetVal("run_speed");

		hook.Run("ModifyPlayerSpeed", player, infoTable);
		
		player:SetWalkSpeed(infoTable.walkSpeed);
		player:SetCrouchedWalkSpeed(infoTable.crouchedWalkSpeed);
		player:SetJumpPower(infoTable.jumpPower);
		
		if (player:KeyDown(IN_BACK)) then
			player:SetRunSpeed(infoTable.walkSpeed);
		else
			player:SetRunSpeed(infoTable.runSpeed);
		end;
		
		player.speedSetCooldown = curTime + 1;
	end;]]--

	--[[ Update whether the weapon has fired, or is being raised. --]]
	player:UpdateWeaponFired()
	player:SetDTBool(BOOL_ISRUNNING, infoTable.isRunning)
end

-- Called when a player has disconnected.
function GM:PlayerDisconnected(player)
	if (IsValid(player) and player:HasInitialized()) then
		--[[if (hook.Run("PlayerCharacterUnloaded", player) != true) then
			player:SaveCharacter()
		end]]--
		
		hook.Run("PrePlayerCharacterUnloaded", player)
	
		player:SaveCharacter()

		hook.Run("PlayerCharacterUnloaded", player)

		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID().." / "..player:IPAddress()..") has disconnected.")
		--Clockwork.chatBox:Add(nil, nil, "disconnect", player:SteamName().." has disconnected from the server.");
		
		for k, v in pairs (_player.GetAll()) do
			if v:IsAdmin() then
				Clockwork.chatBox:Add(v, nil, "disconnect", player:SteamName().." has disconnected from the server.");
			end
		end
	end
end

-- Called when Clockwork has initialized.
function GM:ClockworkInitialized()
	if (!config.GetVal("cash_enabled")) then
		Clockwork.command:SetHidden("GiveCash", true)
		Clockwork.command:SetHidden("DropCash", true)
		Clockwork.command:SetHidden("StorageTakeCash", true)
		Clockwork.command:SetHidden("StorageGiveCash", true)

		config.Get("scale_prop_cost"):Set(0, nil, true, true)
		config.Get("door_cost"):Set(0, nil, true, true)
	end

	if (config.GetVal("use_own_group_system")) then
		Clockwork.command:SetHidden("PlySetGroup", true)
		Clockwork.command:SetHidden("PlyDemote", true)
	end

	local gradientTexture = Clockwork.option:GetKey("gradient")
	local schemaLogo = Clockwork.option:GetKey("schema_logo")
	local introImage = Clockwork.option:GetKey("intro_image")

	if (gradientTexture != "gui/gradient_up") then
		Clockwork.kernel:AddFile("materials/"..gradientTexture..".png")
	end

	if (schemaLogo != "") then
		Clockwork.kernel:AddFile("materials/"..schemaLogo..".png")
	end

	if (introImage != "") then
		Clockwork.kernel:AddFile("materials/"..introImage..".png")
	end
end

-- Called when the Clockwork database has connected.
function GM:DatabaseConnected()
	Clockwork.bans:Load()
end

-- Called when the Clockwork database connection fails.
function GM:DatabaseConnectionFailed()
	Clockwork.database:Error(errText)
end

-- Called when a player's saved inventory should be added to.
function GM:PlayerAddToSavedInventory(player, character, Callback)
	for k, v in pairs(player:GetWeapons()) do
		local weaponItemTable = item.GetByWeapon(v)
		if (weaponItemTable) then
			Callback(weaponItemTable)
		end
	end
end

-- Called when a player's unlock info is needed.
function GM:PlayerGetUnlockInfo(player, entity)
	if (Clockwork.entity:IsDoor(entity)) then
		local unlockTime = config.GetVal("unlock_time")

		return {
			duration = unlockTime,
			Callback = function(player, entity)
				entity:Fire("unlock", "", 0)
			end
		}
	end
end

-- Called when a player's lock info is needed.
function GM:PlayerGetLockInfo(player, entity)
	if (Clockwork.entity:IsDoor(entity)) then
		local lockTime = config.GetVal("lock_time")

		return {
			duration = lockTime,
			Callback = function(player, entity)
				entity:Fire("lock", "", 0)
			end
		}
	end
end

do
	local meleeWeapons = {
		["weapon_hl2axe"] = 10,
		["weapon_hl2bottle"] = 5,
		["weapon_hl2brokenbottle"] = 5,
		["weapon_hl2hook"] = 15,
		["weapon_knife"] = 5,
		["weapon_hl2pan"] = 10,
		["weapon_hl2pickaxe"] = 15,
		["weapon_hl2pipe"] = 10,
		["weapon_hl2pot"] = 10,
		["weapon_hl2shovel"] = 15,
	}

	-- Called when a player attempts to fire a weapon.
	function GM:PlayerCanFireWeapon(player, bIsRaised, weapon, bIsSecondary)
		local canShootTime = player.cwNextShootTime
		local curTime = CurTime()
		local weaponClass = weapon:GetClass()

		if (meleeWeapons[weaponClass]) then
			if (player:GetCharacterData("Stamina") < meleeWeapons[weaponClass]) then
				return false
			end
		end

		if (player:IsRunning() and config.GetVal("sprint_lowers_weapon")) then
			return false
		end

		if (!bIsRaised and !hook.Run("PlayerCanUseLoweredWeapon", player, weapon, bIsSecondary)) then
			return false
		end

		if (canShootTime and canShootTime > curTime) then
			return false
		end

		return true
	end
end

-- Called when a player attempts to use a lowered weapon.
function GM:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if (secondary) then
		return weapon.NeverRaised or (weapon.Secondary and weapon.Secondary.NeverRaised)
	else
		return weapon.NeverRaised or (weapon.Primary and weapon.Primary.NeverRaised)
	end
end

-- Called when a player has been given flags.
function GM:PlayerFlagsGiven(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		Clockwork.player:GiveSpawnWeapon(player, "weapon_physgun")
	end

	if (string.find(flags, "t") and player:Alive()) then
		Clockwork.player:GiveSpawnWeapon(player, "gmod_tool")
	end

	player:SetDTString(STRING_FLAGS, player:GetFlags())
end

-- Called when a player has had flags taken.
function GM:PlayerFlagsTaken(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		if (!Clockwork.player:HasFlags(player, "p")) then
			Clockwork.player:TakeSpawnWeapon(player, "weapon_physgun")
		end
	end

	if (string.find(flags, "t") and player:Alive()) then
		if (!Clockwork.player:HasFlags(player, "t")) then
			Clockwork.player:TakeSpawnWeapon(player, "gmod_tool")
		end
	end

	player:SetDTString(STRING_FLAGS, player:GetFlags())
end

-- Called when a player's default skin is needed.
function GM:GetPlayerDefaultSkin(player)
	local model, skin = Clockwork.class:GetAppropriateModel(player:Team(), player)
	return skin
end

-- Called when a player's default model is needed.
function GM:GetPlayerDefaultModel(player)
	local model, skin = Clockwork.class:GetAppropriateModel(player:Team(), player)
	return model
end

-- Called when a player's default inventory is needed.
function GM:GetPlayerDefaultInventory(player, character, inventory)
	local startingInv = Clockwork.faction:FindByID(character.faction).startingInv

	if (istable(startingInv)) then
		for k, v in pairs(startingInv) do
			Clockwork.inventory:AddInstance(
				inventory, item.CreateInstance(k), v
			)
		end
	end
end

-- Called to get whether a player's weapon is raised.
function GM:GetPlayerWeaponRaised(player, class, weapon)
	if (Clockwork.kernel:IsDefaultWeapon(weapon)) then
		return true
	end

	if (player:IsRunning() and config.GetVal("sprint_lowers_weapon")) then
		return false
	end

	if (weapon:GetNWInt("Zoom") != 0) then
		return true
	end

	if (weapon:GetNWBool("Scope")) then
		return true
	end

	if (config.GetVal("raised_weapon_system")) then
		if (player.cwWeaponRaiseClass == class) then
			return true
		else
			player.cwWeaponRaiseClass = nil
		end

		if (player.cwAutoWepRaised == class) then
			return true
		else
			player.cwAutoWepRaised = nil
		end

		return false
	end

	return true
end

-- Called to get whether a player can give an item to storage.
function GM:PlayerCanGiveToStorage(player, storageTable, itemTable)
	itemTable.cwPropertyTab = itemTable.cwPropertyTab or {}
	itemTable.cwPropertyTab.key = player:GetCharacterKey()
	itemTable.cwPropertyTab.uniqueID = player:UniqueID()

	-- Changed it to == false
	--return true
end

-- Called to get whether a player can take an item to storage.
function GM:PlayerCanTakeFromStorage(player, storageTable, itemTable)
	if (itemTable.cwPropertyTab) then
		--[[if (Clockwork.entity:BelongsToAnotherCharacter(player, itemTable)) then
			Schema:EasyText(player, "peru", "You cannot pick up items belonging to your other character.")
			Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has attempted to take an item stored by another character.")

			return false
		else]]--
			itemTable.cwPropertyTab = nil
		--end
	end

	-- Changed it to == false
	--return true
end

-- Called when a player has given an item to storage.
function GM:PlayerGiveToStorage(player, storageTable, itemTable) end

-- Called when a player is given an item.
function GM:PlayerItemGiven(player, itemTable, bForce)
	Clockwork.storage:SyncItem(player, itemTable)
end

-- Called when a player has an item taken.
function GM:PlayerItemTaken(player, itemTable)
	Clockwork.storage:SyncItem(player, itemTable)
end

-- Called when a player's cash has been updated.
function GM:PlayerCashUpdated(player, amount, reason, bNoMsg)
	Clockwork.storage:SyncCash(player)
end

-- A function to scale damage by hit group.
--[[function GM:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)

end]]--

-- Called when a player switches their flashlight on or off.
function GM:PlayerSwitchFlashlight(player, bIsOn)
	local curTime = CurTime();
	
	if (player.DidAdminFlashlight) then
		player.DidAdminFlashlight = nil;
		return true;
	end;
	
	local activeWeapon = player:GetActiveWeapon();
	
	if hook.Run("PlayerCanRaiseWeapon", player, activeWeapon) ~= false then
		if (!player.cwNextRaise or player.cwNextRaise < curTime) then
			if (player:Alive() and !player:IsRagdolled()) then
				if (IsValid(activeWeapon)) then
					if (Clockwork.kernel:IsDefaultWeapon(activeWeapon)) then
						return false;
					elseif (activeWeapon:GetClass() == "cw_flashlight") then
						return true;
					end;
					
					local defaultTime = 1.25;
					local ti = activeWeapon.RaiseSpeed;
					local raised = player:IsWeaponRaised();
					
					if (!raised) then
						ti = activeWeapon.LowerSpeed;
					end;
					if (!ti) then
						ti = defaultTime
					end;
					local actionTime = ti
					local raiseSound = "cloth.wav";
					player.cwNextRaise = curTime + (actionTime + 0.25);
					
					if (activeWeapon.InstantRaise) then
						player:ToggleWeaponRaised();
						return;
					end;
					
					if (activeWeapon.RaiseSound) then
						raiseSound = activeWeapon.RaiseSound;
					end;
					
					if player:HasBelief("dexterity") then
						actionTime = actionTime * 0.66;
					end

					activeWeapon.nextFire = activeWeapon:GetNextPrimaryFire();
					activeWeapon:SetNextPrimaryFire(curTime + 60);
					activeWeapon:SetNextSecondaryFire(curTime + 60);
					
					Clockwork.player:SetAction(player, "raise", actionTime, 5, function()
						player:ToggleWeaponRaised();
						player:EmitSound(raiseSound, 70);
					end);
				end;
			end;
		elseif (player.cwNextRaise > curTime and Clockwork.player:GetAction(player) == "raise") then
			activeWeapon:SetNextPrimaryFire(activeWeapon.nextFire or curTime);
			activeWeapon:SetNextSecondaryFire(activeWeapon.nextFire or curTime);
		
			Clockwork.player:SetAction(player, false);
			player.cwNextRaise = curTime + 0.1;
		end;
	end

	return false;
end

concommand.Add("light", function(player)
	if (player:IsAdmin()) then
		player.DidAdminFlashlight = true;
		player:Flashlight(!player:FlashlightIsOn())
	end;
end);

concommand.Add("raise", function(player)
	if (player:IsAdmin()) then
		player:ToggleWeaponRaised();
	end;
end);

-- Called when Clockwork config has initialized.
function GM:ClockworkConfigInitialized(key, value)
	if (key == "cash_enabled" and !value) then
		for k, v in pairs(item.GetAll()) do
			v.cost = 0
		end
	elseif (key == "local_voice") then
		if (value) then
			RunConsoleCommand("sv_alltalk", "0")
		end
	end

	RunConsoleCommand("sv_maxrate", "80000")
end

-- Called when a Clockwork ConVar has changed.
function GM:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "local_voice" and newValue) then
		RunConsoleCommand("sv_alltalk", "1")
	end
end

-- Called when Clockwork config has changed.
function GM:ClockworkConfigChanged(key, data, previousValue, newValue)
	local plyTable = _player.GetAll()

	if (key == "default_flags") then
		for k, v in ipairs(plyTable) do
			if (v:HasInitialized() and v:Alive()) then
				if (string.find(previousValue, "p")) then
					if (!string.find(newValue, "p")) then
						if (!Clockwork.player:HasFlags(v, "p")) then
							Clockwork.player:TakeSpawnWeapon(v, "weapon_physgun")
						end
					end
				elseif (!string.find(previousValue, "p")) then
					if (string.find(newValue, "p")) then
						Clockwork.player:GiveSpawnWeapon(v, "weapon_physgun")
					end
				end

				if (string.find(previousValue, "t")) then
					if (!string.find(newValue, "t")) then
						if (!Clockwork.player:HasFlags(v, "t")) then
							Clockwork.player:TakeSpawnWeapon(v, "gmod_tool")
						end
					end
				elseif (!string.find(previousValue, "t")) then
					if (string.find(newValue, "t")) then
						Clockwork.player:GiveSpawnWeapon(v, "gmod_tool")
					end
				end
			end
		end
	elseif (key == "use_own_group_system") then
		if (newValue) then
			Clockwork.command:SetHidden("PlySetGroup", true)
			Clockwork.command:SetHidden("PlyDemote", true)
		else
			Clockwork.command:SetHidden("PlySetGroup", false)
			Clockwork.command:SetHidden("PlyDemote", false)
		end
	elseif (key == "crouched_speed") then
		for k, v in ipairs(plyTable) do
			v:SetCrouchedWalkSpeed(newValue)
		end
	elseif (key == "ooc_interval") then
		for k, v in ipairs(plyTable) do
			v.cwNextTalkOOC = nil
		end
	elseif (key == "jump_power") then
		for k, v in ipairs(plyTable) do
			v:SetJumpPower(newValue)
		end
	elseif (key == "walk_speed") then
		for k, v in ipairs(plyTable) do
			v:SetWalkSpeed(newValue)
		end
	elseif (key == "run_speed") then
		for k, v in ipairs(plyTable) do
			v:SetRunSpeed(newValue)
		end
	end
end

-- Called when a player attempts to sprays their tag.
function GM:PlayerSpray(player)
	return true;
end

-- Called when a player attempts to use an entity.
function GM:PlayerUse(player, entity)
	if (player:IsRagdolled(RAGDOLL_FALLENOVER)) then
		return false
	else
		if (Clockwork.entity:IsDoor(entity)) then
			if !entity:HasSpawnFlags(256) and !entity:HasSpawnFlags(8192) and !entity:HasSpawnFlags(32768) then
				if (hook.Run("PlayerCanUseDoor", player, entity)) ~= false then
					if (player:GetNetVar("tied") != 0) then
						return false;
					end;

					hook.Run("PlayerUseDoor", player, entity)
					Clockwork.entity:OpenDoor(entity, 0, nil, nil, player:GetPos())
					
					return false;
				end
			elseif (hook.Run("PlayerCanUseDoor", player, entity)) ~= false then
				if (player:GetNetVar("tied") != 0) then
					return false;
				end;
				
				hook.Run("PlayerUseDoor", player, entity)
				--Clockwork.entity:OpenDoor(entity, 0, nil, nil, player:GetPos())
				
				--return false;
			else
				return false;
			end
		--[[elseif (entity.UsableInVehicle) then
			if (player:InVehicle()) then
				if (entity.Use) then
					entity:Use(player, player)

					player.cwNextExitVehicle = CurTime() + 1
				end
			end]]--
		end
	
		return true
	end
end

-- Called when a player's move data is set up.
function GM:SetupMove(player, moveData)
	local isRunning = player:IsRunning();

	if isRunning and !player.accelerationFinished then
		local curTime = CurTime();
		local run_speed = player:GetTargetRunSpeed();
		local walk_speed = player:GetWalkSpeed();
		local final_speed = run_speed;
		
		if !player.startAcceleration then
			player.startAcceleration = curTime;
		end
		
		final_speed = Lerp(curTime - player.startAcceleration, walk_speed, run_speed);
		
		moveData:SetMaxClientSpeed(final_speed);
		
		if run_speed <= final_speed then
			player.accelerationFinished = true;
			player.startAcceleration = nil;
		end
		
		player.decelerationFinished = false;
		player.startDeceleration = nil;
	elseif !isRunning then
		if !player.decelerationFinished then
			local curTime = CurTime();
			local run_speed = player:GetTargetRunSpeed();
			local walk_speed = player:GetWalkSpeed();
			local final_speed = walk_speed;
			
			if !player.startDeceleration then
				player.startDeceleration = curTime;
			end
			
			final_speed = Lerp(curTime - player.startDeceleration, run_speed, walk_speed);
			
			moveData:SetMaxClientSpeed(final_speed);
			
			if run_speed >= final_speed then
				player.decelerationFinished = true;
				player.startDeceleration = nil;
			end
			
			player.accelerationFinished = false;
			player.startAcceleration = nil;
		else
			moveData:SetMaxClientSpeed(player:GetWalkSpeed());
		end
	end
end

-- Called when a player attempts to save a recognised name.
function GM:PlayerCanSaveRecognisedName(player, target)
	if (player != target) then return true end
end

-- Called when a player attempts to restore a recognised name.
function GM:PlayerCanRestoreRecognisedName(player, target)
	if (player != target) then return true end
end

-- Called when a player attempts to order an item shipment.
function GM:PlayerCanOrderShipment(player, itemTable)
	local curTime = CurTime()

	if (player.cwNextOrderTime and curTime < player.cwNextOrderTime) then
		return false
	end

	return true
end

-- Called when a player attempts to get up.
function GM:PlayerCanGetUp(player) return true end

-- Called when a player attempts to throw a punch.
function GM:PlayerCanThrowPunch(player) return true end

-- Called when a player attempts to punch an entity.
function GM:PlayerCanPunchEntity(player, entity) return false end

-- Called when a player attempts to knock a player out with a punch.
function GM:PlayerCanPunchKnockout(player, target, trace)
	if (trace.HitGroup == HITGROUP_HEAD) then
		return true
	end
end

-- Called when a player attempts to bypass the faction limit.
function GM:PlayerCanBypassFactionLimit(player, character) return false end

-- Called when a player attempts to bypass the class limit.
function GM:PlayerCanBypassClassLimit(player, class) return false end

-- Called when a player's pain sound should be played.
--[[
function GM:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (damageInfo:IsBulletDamage() and math.random() <= 0.5) then
		if (hitGroup == HITGROUP_HEAD) then
			return "vo/npc/"..gender.."01/ow0"..math.random(1, 2)..".wav"
		elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
			return "vo/npc/"..gender.."01/hitingut0"..math.random(1, 2)..".wav"
		elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
			return "vo/npc/"..gender.."01/myleg0"..math.random(1, 2)..".wav"
		elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
			return "vo/npc/"..gender.."01/myarm0"..math.random(1, 2)..".wav"
		elseif (hitGroup == HITGROUP_GEAR) then
			return "vo/npc/"..gender.."01/startle0"..math.random(1, 2)..".wav"
		end
	end

	return "vo/npc/"..gender.."01/pain0"..math.random(1, 9)..".wav"
end--]]

-- Called when a player has spawned.
function GM:PlayerSpawn(player)
	if (player:HasInitialized()) then
		player.spawning = true;
		
		player:ShouldDropWeapon(false)

		if (!player.cwLightSpawn) then
			Clockwork.hint:Clear(player);
		
			local FACTION = Clockwork.faction:FindByID(player:GetFaction())
			local relation = FACTION.entRelationship
			local playerRank, rank = player:GetFactionRank()
			local maxHealth = player:GetMaxHealth();
			--local maxArmor = player:GetMaxArmor();

			Clockwork.player:SetWeaponRaised(player, false)
			Clockwork.player:SetRagdollState(player, RAGDOLL_RESET)
			Clockwork.player:SetAction(player, false)
			Clockwork.player:SetDrunk(player, false)

			--Clockwork.attributes:ClearBoosts(player)

			self:PlayerSetModel(player)

			if (player:FlashlightIsOn()) then
				player:Flashlight(false)
			end

			player:SetForcedAnimation(false)
			player:SetCollisionGroup(COLLISION_GROUP_PLAYER)
			player:SetMaterial("")
			player:SetMoveType(MOVETYPE_WALK)
			player:Extinguish()
			player:UnSpectate()
			player:GodDisable()
			player:RunCommand("-duck")
			player:SetColor(Color(255, 255, 255, 255))
			player:SetupHands()

			player:SetWalkSpeed(config.GetVal("walk_speed"))
			player:SetCrouchedWalkSpeed(config.GetVal("crouched_speed"))
			player:SetJumpPower(config.GetVal("jump_power"))
			player:SetRunSpeed(config.GetVal("run_speed"))
			player:CrosshairDisable()
			player:SetCanZoom(false);
			
			player:SetMaxHealth(maxHealth)
			--player:SetMaxArmor(maxArmor)
			player:SetHealth(maxHealth)
			--player:SetArmor(maxArmor)

			--if (rank) then
				--player:SetMaxHealth(rank.maxHealth or maxHealth))
				--player:SetMaxArmor(rank.maxArmor or maxArmor)
				--player:SetHealth(rank.maxHealth or maxHealth)
				--player:SetArmor(rank.maxArmor or maxArmor)
			--end

			--[[if (istable(FACTION.respawnInv)) then
				local inventory = player:GetInventory()
				local itemQuantity

				for k, v in pairs(FACTION.respawnInv) do
					for i = 1, (v or 1) do
						itemQuantity = table.Count(inventory[k])

						if (itemQuantity < v) then
							player:GiveItem(item.CreateInstance(k), true)
						end
					end
				end
			end]]--

			if (prevRelation) then
				for k, v in pairs(ents.GetAll()) do
					if (v:IsNPC() or v:IsNextBot()) then
						prevRelation[player:SteamID()] = prevRelation[player:SteamID()] or {}
						local prevRelationVal = prevRelation[player:SteamID()][v:GetClass()]

						if (prevRelationVal) then
							v:AddEntityRelationship(player, prevRelationVal, 1)
						end
					end
				end
			end

			if (istable(relation)) then
				local relationEnts

				prevRelation = prevRelation or {}
				prevRelation[player:SteamID()] = prevRelation[player:SteamID()] or {}

				for k, v in pairs(relation) do
					relationEnts = ents.FindByClass(k)

					if (relationEnts) then
						for k2, v2 in pairs(relationEnts) do
							if (string.lower(v) == "like") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player)
								v2:AddEntityRelationship(player, D_LI, 1)
							elseif (string.lower(v) == "fear") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player)
								v2:AddEntityRelationship(player, D_FR, 1)
							elseif (string.lower(v) == "hate") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player)
								v2:AddEntityRelationship(player, D_HT, 1)
							else
								ErrorNoHalt("Attempting to add relationship using invalid relation '"..v.."' towards faction '"..FACTION.name.."'.\r\n")
							end
						end
					end
				end
			end

			if (player.cwFirstSpawn) then
				--[[local ammo = player:GetSavedAmmo()

				for k, v in pairs(ammo) do
					if (!string.find(k, "p_") and !string.find(k, "s_")) then
						player:GiveAmmo(v, k) ammo[k] = nil
					end
				end]]--
			else
				Clockwork.player:LightSpawn(player, true);
				player:UnLock()
			end
		end

		if (player.cwLightSpawn and player.cwSpawnCallback) then
			player.cwSpawnCallback(player, true)
			player.cwSpawnCallback = nil
		end

		hook.Run("PostPlayerSpawn", player, player.cwLightSpawn, player.cwChangeClass, player.cwFirstSpawn)
		
		Clockwork.player:SetRecognises(player, player, RECOGNISE_TOTAL)
		
		Clockwork.datastream:Start(player, "RadioState", player:GetCharacterData("radioState", false) or false);
		
		player.cwChangeClass = false
		player.cwLightSpawn = false
		
		timer.Simple(0.5, function()
			if IsValid(player) then
				player.spawning = false;
			end
		end);

		player:NetworkTraits();
		
		hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable);
	else
		player:KillSilent()
	end
end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel(player, entity)
	local model = player:GetModel();
	
	if string.find(model, "models/begotten/heads") then
		local clothesItem = player:GetClothesEquipped();

		if clothesItem and clothesItem.group then
			if clothesItem.genderless then
				model = "models/begotten/"..clothesItem.group..".mdl";
			else
				model = "models/begotten/"..clothesItem.group.."_"..string.lower(player:GetGender())..".mdl";
			end
		else
			local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
			local factionTable = Clockwork.faction:FindByID(faction);
			
			if factionTable then
				local subfaction = player:GetSharedVar("kinisgerOverrideSubfaction") or player:GetSubfaction();
				
				if subfaction and factionTable.subfactions then
					for k, v in pairs(factionTable.subfactions) do
						if k == subfaction and v.models then
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
	end
		
	local simpleModel = player_manager.TranslateToPlayerModelName(model)
	local info = Clockwork.animation:GetHandsInfo(model) or player_manager.TranslatePlayerHands(simpleModel)

	if (info) then
		entity:SetModel(info.model)
		entity:SetSkin(info.skin)

		local bodyGroups = tostring(info.body)

		if (bodyGroups) then
			bodyGroups = string.Explode("", bodyGroups)

			for k, v in pairs(bodyGroups) do
				local num = tonumber(v)

				if (num) then
					entity:SetBodygroup(k, num)
				end
			end
		end
	end

	hook.Run("PostCModelHandsSet", player, model, entity, info)
end

-- Called when a player attempts to connect to the server.
function GM:CheckPassword(steamID, ipAddress, svPassword, clPassword, name)
	steamID = util.SteamIDFrom64(steamID)
	local banTable = Clockwork.bans.stored[ipAddress] or Clockwork.bans.stored[steamID]

	if (banTable) then
		local unixTime = os.time()
		local unbanTime = tonumber(banTable.unbanTime)
		local timeLeft = unbanTime - unixTime
		local hoursLeft = math.Round(math.max(timeLeft / 3600, 0))
		local minutesLeft = math.Round(math.max(timeLeft / 60, 0))

		if (unbanTime > 0 and unixTime < unbanTime) then
			local bannedMessage = config.Get("banned_message"):Get()

			if (hoursLeft >= 1) then
				hoursLeft = tostring(hoursLeft)

				bannedMessage = string.gsub(bannedMessage, "!t", hoursLeft)
				bannedMessage = string.gsub(bannedMessage, "!f", "hour(s)")
			elseif (minutesLeft >= 1) then
				minutesLeft = tostring(minutesLeft)

				bannedMessage = string.gsub(bannedMessage, "!t", minutesLeft)
				bannedMessage = string.gsub(bannedMessage, "!f", "minutes(s)")
			else
				timeLeft = tostring(timeLeft)

				bannedMessage = string.gsub(bannedMessage, "!t", timeLeft)
				bannedMessage = string.gsub(bannedMessage, "!f", "second(s)")
			end

			return false, bannedMessage
		elseif (unbanTime == 0) then
			return false, banTable.reason
		else
			Clockwork.bans:Remove(ipAddress)
			Clockwork.bans:Remove(steamID)
			hook.Run("BanExpired", steamID, ipAddress);
		end
	end
end

-- Called when the Clockwork data is saved.
function GM:SaveData()
	-- changed here
	local players = _player.GetAll();
	
	for k, v in pairs(players) do
		if (v:HasInitialized()) then
			v:SaveCharacter()
		end
	end;

	if (!config.GetVal("use_local_machine_time")) then
		Clockwork.kernel:SaveSchemaData("time", Clockwork.time:GetSaveData())
	end

	if (!config.GetVal("use_local_machine_date")) then
		Clockwork.kernel:SaveSchemaData("date", Clockwork.date:GetSaveData())
	end
	
	Clockwork.kernel:SaveSchemaData("itemIndex", {ITEM_INDEX});
end

function GM:PlayerCanInteractCharacter(player, action, character)
	if (Clockwork.quiz:GetEnabled() and !Clockwork.quiz:GetCompleted(player)) then
		return false, "You got too many questions wrong!"
	else
		return true
	end
end

-- Called whe the map entities are initialized.
function GM:InitPostEntity()
	for k, v in pairs(ents.GetAll()) do
		if (IsValid(v)) then
			if (v:GetModel()) then
				Clockwork.entity:SetMapEntity(v, true)
				Clockwork.entity:SetStartAngles(v, v:GetAngles())
				Clockwork.entity:SetStartPosition(v, v:GetPos())

				if (Clockwork.entity:SetChairAnimations(v)) then
					v:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

					local physicsObject = v:GetPhysicsObject()

					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false)
					end
				end
			end

			if (Clockwork.entity:IsDoor(v)) then
				local entIndex = v:EntIndex()

				if (!Clockwork.entity.DoorEntities) then Clockwork.entity.DoorEntities = {}; end

				local doorEnts = Clockwork.entity.DoorEntities

				if (!doorEnts[entIndex]) then
					doorEnts[entIndex] = v
				end
			end
		end
	end

	netvars.SetNetVar("NoMySQL", Clockwork.NoMySQL)
	hook.Run("ClockworkInitPostEntity")

	for k, v in ipairs(ents.GetAll()) do
		local model = v:GetModel()

		if (!v:IsPlayer() and model and (model:find("wood") or model:find("table") or model:find("bench")
		or model:find("table") or model:find("chair") or model:find("box") or model:find("cardboard")
		or model:find("pallet"))) then
			v:SetKeyValue("negated", "1")
		end
	end
end

-- Called when a player is banned.
function GM:PlayerBanned(player, duration, reason) end;

-- Called just before a player's ban is removed.
function GM:PrePlayerUnbanned(identifier, banTable) end;

-- Called when a player's ban expires when they attempt to join.
function GM:BanExpired(steamID, ipAddress) end;

-- Called when a player's data has loaded.
function GM:PlayerDataLoaded(player)
	player.CountryCodeRequested = true;
	netstream.Start(player, "RequestCountryCode");
	if (player:IsBot()) then
		local allcountries = Clockwork.kernel.countries;
		local tab = {}
		for k, v in pairs (allcountries) do
			tab[#tab + 1] = k;
		end;
		Clockwork.kernel:CountryCode(player, table.Random(tab));
	end;
end

-- Called when a player fails the country code check, indicating potential VPN use.
function GM:PlayerCountryAuthFail(player, oldCode, newCode)
	Clockwork.kernel:PrintLog(LOGTYPE_URGENT, player:SteamName().." ("..player:SteamID().." / "..player:IPAddress()..") has connected from a different country than is saved in MySQL! [Code = "..oldCode..", NewCode = "..newCode.."]")
end;

-- Called when a player's country code is checked.
function GM:PlayerCountryAuthed(player, countryCode)
	if (!player:IsKicked()) then
		local steamName = player:SteamName();
		local steamID = player:SteamID();
		local ipAddress = player:IPAddress();
		local countryName = Clockwork.kernel:GetCountryName(player) or "Palestine";
		
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, steamName.." ("..steamID.." / "..ipAddress..") has connected from "..countryName..".")
		
		for k, v in pairs (_player.GetAll()) do
			if v:IsAdmin() then
				Clockwork.chatBox:Add(v, nil, "connect_country", steamName.." has connected to the server from "..countryName..".", {countryIcon = string.upper(countryCode)});
			end
		end
		
		player:SaveCharacter();
	end
end;

concommand.Add("sexfunny", function(player)
	if player:IsAdmin() then
		local steamName = player:SteamName();
		local steamID = player:SteamID();
		local ipAddress = player:IPAddress();
		local countrycode = player:GetData("CountryCode");
		local countryName = Clockwork.kernel:GetCountryName(player) or "Palestine";
		
		Clockwork.kernel:PrintLog(LOGTYPE_MINOR, steamName.." ("..steamID.." / "..ipAddress..") has connected from "..countryName..".")
		
		for k, v in pairs (_player.GetAll()) do
			if v:IsAdmin() then
				Clockwork.chatBox:Add(v, nil, "connect_country", steamName.." has connected to the server from "..countryName..".", {countryIcon = string.upper(countryCode)});
			end
		end
	end
end);

-- Called when a player initially spawns.
function GM:PlayerInitialSpawn(player)
	player.cwCharacterList = player.cwCharacterList or {}
	player.cwHasSpawned = true
	player.cwSharedVars = player.cwSharedVars or {}

	if (IsValid(player)) then
		player:KillSilent()
	end

	if (player:IsBot()) then
		config.Send(player)
	end
end

-- Called every frame while a player is dead.
function GM:PlayerDeathThink(player)
	--[[local action = Clockwork.player:GetAction(player)

	if (!player:HasInitialized()) then
		return true
	end

	if (player:IsCharacterMenuReset()) then
		return true
	end]]--

	--if (action == "spawn") then
		return true
	--else
		--player:Spawn()
	--end
end

-- Called when a player attempts to be given a weapon.
function GM:PlayerCanBeGivenWeapon(player, class, itemTable)
	return true
end

--[[local WEAPON_SLOTS = {
	"Primary",
	"Secondary",
	"Tertiary"
};]]--

-- Called when a player has been given a weapon.
function GM:PlayerGivenWeapon(player, class, itemTable)
	Clockwork.inventory:Rebuild(player)
end

-- Called when a player attempts to create a character.
function GM:PlayerCanCreateCharacter(player, character, characterID)
	if (Clockwork.quiz:GetEnabled() and !Clockwork.quiz:GetCompleted(player)) then
		return "You did not pass the test!"
	else
		return true
	end
end

-- Called when a player's bullet info should be adjusted.
function GM:PlayerAdjustBulletInfo(player, bulletInfo) end

-- Called when an entity fires some bullets.
function GM:EntityFireBullets(entity, bulletInfo) end

-- Called when a player's fall damage is needed.
function GM:GetFallDamage(player, velocity)
	--local ragdollEntity = nil
	local position = player:GetPos()
	local damage = math.max((velocity - 464) * 0.225225225, 0) * config.GetVal("scale_fall_damage")
	local filter = {player}
	
	if (Clockwork.player:HasFlags(player, "E")) then
		return 0
	end
	
	--[[if (config.GetVal("wood_breaks_fall")) then
		if (player:IsRagdolled()) then
			ragdollEntity = player:GetRagdollEntity()
			position = ragdollEntity:GetPos()
			filter = {player, ragdollEntity}
		end

		local traceLine = util.TraceLine({
			endpos = position - Vector(0, 0, 64),
			start = position,
			filter = filter
		})

		if (IsValid(traceLine.Entity) and traceLine.MatType == MAT_WOOD) then
			if (string.find(traceLine.Entity:GetClass(), "prop_physics")) then
				traceLine.Entity:Fire("break", "", 0)
				damage = damage * 0.25
			end
		end
	end]]--
	
	local holdingEnt = player:GetHoldingEntity();
	
	if IsValid(holdingEnt) then
		if Clockwork.entity:IsPlayerRagdoll(holdingEnt) then
			local ragdollPlayer = Clockwork.entity:GetPlayer(holdingEnt);
			
			if IsValid(ragdollPlayer) then
				local damageInfo = DamageInfo();
			
				holdingEnt.cwNextFallDamage = curTime;
				amount = hook.Run("GetFallDamage", ragdollPlayer, velocity)
				hook.Run("OnPlayerHitGround", ragdollPlayer, false, false, true);
				
				damageInfo:SetDamageType(DMG_FALL);
				damageInfo:SetDamage(amount);
				damageInfo:SetAttacker(game.GetWorld());
				
				ragdollPlayer:TakeDamageInfo(damageInfo);
			end
		end
	end
	
	-- Increase fall damage for duels since it will only happen if you fall out of the arena.
	if damage > 5 and player.opponent then
		return 10000;
	else
		if player.GetCharmEquipped and player:GetCharmEquipped("boot_contortionist") then
			damage = damage * 0.5;
		end
	end

	if (damage > 30) and !player:IsRagdolled() then
		if hook.Run("PlayerCanFallOverFromFallDamage", player) ~= false then
			timer.Simple(0, function()
				Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil)

				player:SetDTBool(BOOL_FALLENOVER, true)
			end);
		end
	end

	return damage
end

local valid_bot_factions;

-- Called when a player's data stream info has been sent.
function GM:PlayerDataStreamInfoSent(player)
	if (player:IsBot()) then
		Clockwork.player:LoadData(player, function(player)
			hook.Run("PlayerDataLoaded", player)

			if !valid_bot_factions then
				valid_bot_factions = {};
			
				local factions = table.ClearKeys(Clockwork.faction:GetAll(), true)
				
				for i = 1, #factions do
					local faction = factions[i];
					
					if !faction.disabled and !faction.hidden then
						table.insert(valid_bot_factions, faction);
					end
				end
			end
			
			local faction = valid_bot_factions[math.random(1, #valid_bot_factions)]

			if (faction) then
				local genders = {GENDER_MALE, GENDER_FEMALE}
				local gender = faction.singleGender or genders[math.random(1, #genders)]
				local models = faction.models[string.lower(gender)].heads
				local model = models[math.random(1, #models)]

				model = "models/begotten/heads/"..model.."_gore.mdl";

				Clockwork.player:LoadCharacter(player, 1, {
					faction = faction.name,
					gender = gender,
					model = model,
					name = player:Name(),
					data = {}
				}, function()
					Clockwork.player:LoadCharacter(player, 1)
				end)
			end
		end)
	elseif (!table.IsEmpty(Clockwork.faction:GetAll())) then
		Clockwork.player:LoadData(player, function()
			hook.Run("PlayerDataLoaded", player)

			local whitelisted = player:GetData("Whitelisted")
			local whitelistedSubfactions = player:GetData("WhitelistedSubfactions")
			local steamName = player:SteamName()
			local unixTime = os.time()

			Clockwork.player:SetCharacterMenuState(player, CHARACTER_MENU_OPEN)

			if (whitelisted) then
				for k, v in pairs(whitelisted) do
					if (Clockwork.faction:GetStored()[v]) then
						netstream.Start(player, "SetWhitelisted", {v, true})
					else
						whitelisted[k] = nil
					end
				end
			end
			
			if (whitelistedSubfactions) then
				for k, v in pairs(whitelistedSubfactions) do
					netstream.Start(player, "SetWhitelistedSubfaction", {v, true})
				end
			end

			Clockwork.player:GetCharacters(player, function(characters)
				if (characters) then
					for k, v in pairs(characters) do
						Clockwork.player:ConvertCharacterMySQL(v)
						player.cwCharacterList[v.characterID] = {}

						for k2, v2 in pairs(v) do
							if (k2 == "timeCreated") then
								if (v2 == "") then
									player.cwCharacterList[v.characterID][k2] = unixTime
								else
									player.cwCharacterList[v.characterID][k2] = v2
								end
							elseif (k2 == "lastPlayed") then
								player.cwCharacterList[v.characterID][k2] = unixTime
							elseif (k2 == "steamName") then
								player.cwCharacterList[v.characterID][k2] = steamName
							else
								player.cwCharacterList[v.characterID][k2] = v2
							end
						end
					end

					for k, v in pairs(player.cwCharacterList) do
						local bDelete = hook.Run("PlayerAdjustCharacterTable", player, v)

						if (!bDelete) then
							Clockwork.player:CharacterScreenAdd(player, v)
						else
							Clockwork.player:ForceDeleteCharacter(player, k)
						end
					end
				end

				Clockwork.player:SetCharacterMenuState(player, CHARACTER_MENU_LOADED)
			end)
		end)
	end
end

-- Called when a player's data stream info should be sent.
function GM:PlayerSendDataStreamInfo(player)
	netstream.Start(player, "SharedTables", Clockwork.SharedTables)

	if (Clockwork.OverrideColorMod and Clockwork.OverrideColorMod != nil) then
		netstream.Start(player, "SystemColGet", Clockwork.OverrideColorMod)
	end
end

-- Called when a player's death sound should be played.
function GM:PlayerPlayDeathSound(player, gender)
	return "vo/npc/"..string.lower(gender).."01/pain0"..math.random(1, 9)..".wav"
end

-- Called when a player's character data should be restored.
function GM:PlayerRestoreCharacterData(player, data)
	if (data["PhysDesc"]) then
		data["PhysDesc"] = Clockwork.kernel:ModifyPhysDesc(data["PhysDesc"])
	end

	if (!data["Equipment"]) then
		data["Equipment"] = {}
	end

	if (!data["Traits"]) then
		data["Traits"] = {};
	end;
	
	Clockwork.player:RestoreCharacterData(player, data)
end

concommand.Add("save_char", function(player)
	player:SaveCharacter();
end);

-- Called when a player's character data should be saved.
function GM:PlayerSaveCharacterData(player, data)
	if (config.Get("save_attribute_boosts"):Get()) then
		Clockwork.kernel:SavePlayerAttributeBoosts(player, data)
	end

	data["Health"] = player:Health()
	data["Armor"] = player:Armor()

	if (data["Health"] <= 1) then
		data["Health"] = nil
	end

	if (data["Armor"] <= 1) then
		data["Armor"] = nil
	end
end

-- Called when a player's data should be saved.
function GM:PlayerSaveData(player, data)
	if (data["Whitelisted"] and table.IsEmpty(data["Whitelisted"])) then
		data["Whitelisted"] = nil
	end
end

-- Called when a player's storage should close.
function GM:PlayerStorageShouldClose(player, storageTable)
	local entity = player:GetStorageEntity()
	local dist;

	if storageTable.distance then
		dist = (storageTable.distance * storageTable.distance);
	end
	
	if (player:IsRagdolled() or !player:Alive() or (storageTable.entity and !entity) or (storageTable.entity and storageTable.distance and player:GetShootPos():DistToSqr(entity:GetPos()) > dist)) then
		return true
	elseif (storageTable.ShouldClose and storageTable.ShouldClose(player, storageTable)) then
		return true
	end
end

-- Called when a player attempts to pickup a weapon.
function GM:PlayerCanPickupWeapon(player, weapon)
	if (player.cwForceGive or (player:GetEyeTraceNoCursor().Entity == weapon and player:KeyDown(IN_USE))) then
		return true
	else
		return false
	end
end

-- Called to modify the wages interval.
function GM:ModifyWagesInterval(info) end

-- Called to modify a player's wages info.
function GM:PlayerModifyWagesInfo(player, info) end

function GM:OneSecond()
	local sysTime = SysTime()
	local curTime = CurTime()

	--[[if (!Clockwork.NextHint or curTime >= Clockwork.NextHint) then
		Clockwork.hint:Distribute()
		Clockwork.NextHint = curTime + config.Get("hint_interval"):Get()
	end]]--

	--[[if (!Clockwork.NextWagesTime or curTime >= Clockwork.NextWagesTime) then
		Clockwork.kernel:DistributeWagesCash()

		local info = {
			interval = config.GetVal("wages_interval")
		}

		hook.Run("ModifyWagesInterval", info)

		Clockwork.NextWagesTime = curTime + info.interval
	end]]--

	--[[if (!Clockwork.NextDateTimeThink or sysTime >= Clockwork.NextDateTimeThink) then
		Clockwork.kernel:PerformDateTimeThink()
		Clockwork.NextDateTimeThink = sysTime + config.Get("minute_time"):Get()
	end]]--

	if (!Clockwork.NextSaveData or sysTime >= Clockwork.NextSaveData) then
		hook.Run("PreSaveData")
		hook.Run("SaveData")
		hook.Run("PostSaveData")

		Clockwork.NextSaveData = sysTime + config.Get("save_data_interval"):Get()
	end

	if (!Clockwork.NextCheckEmpty) then
		Clockwork.NextCheckEmpty = sysTime + 1200
	end

	if (sysTime >= Clockwork.NextCheckEmpty) then
		Clockwork.NextCheckEmpty = nil
		
		-- changed here
		if (_player.GetCount() <= 0) then
			RunConsoleCommand("changelevel", game.GetMap())
		end
	end
end

do
	local defaultInvWeight = config.GetVal("default_inv_weight")
	local defaultInvSpace = config.GetVal("default_inv_weight")
	local thinkRate = 0.2
	local cwNextThink = 0
	local cwNextSecond = 0
	local cwNextHalfSecond = 0;

	-- Called each tick.
	function GM:Tick()
		local curTime = CurTime()

		if (curTime >= cwNextThink) then
			local players = _player.GetAll();

			entsGetAllThisPlayerTick = {};
			playerGetAllThisPlayerTick = {};
			
			local allEnts = ents.GetAll();
			local badMovetypes = {
				[MOVETYPE_NOCLIP] = true,
				[MOVETYPE_OBSERVER] = true,
			}
			
			for i = 1, #allEnts do
				local entity = allEnts[i];
				local class = entity:GetClass();
				local isPlayer = tobool(class == "Player");
					
				entsGetAllThisPlayerTick[i] = {entity = entity, class = class, bIsPlayer = bIsPlayer, position = entity:GetPos(), bIsNPC = (entity:IsNPC() or entity:IsNextBot())}
			end;
			
			for i = 1, _player.GetCount() do
				local v = players[i];
				local position = v:GetPos();
				local alive = v:Alive();
					
				playerGetAllThisPlayerTick[i] = {player = v, alive = alive, position = position};
			end;

			for k, v in pairs(players) do
				local initialized = v:HasInitialized();

				if (initialized) then
					local alive = v:Alive();
					local infoTable = v.cwInfoTable

					infoTable.inventoryWeight = defaultInvWeight
					infoTable.inventorySpace = defaultInvSpace
					infoTable.crouchedSpeed = v.cwCrouchedSpeed
					infoTable.jumpPower = v.cwJumpPower
					infoTable.walkSpeed = v.cwWalkSpeed
					infoTable.isRunning = v:IsRunning()
					infoTable.isJumping = v:IsJumping()
					infoTable.runSpeed = v.cwRunSpeed

					hook.Run("PlayerThink", v, curTime, infoTable, alive, initialized)

					if (curTime >= cwNextSecond) then
						hook.Run("OnePlayerSecond", v, curTime, infoTable, alive, initialized)
					end
					
					if (curTime >= cwNextHalfSecond) then
						hook.Run("OnePlayerHalfSecond", v, curTime, infoTable, alive, initialized)
					end
				end
			end

			cwNextThink = curTime + thinkRate

			if (curTime >= cwNextSecond) then
				cwNextSecond = curTime + 1
			end
			
			if (curTime >= cwNextHalfSecond) then
				cwNextHalfSecond = curTime + 0.5
			end
		end
	end
end

-- Called every frame.
function GM:Think() end

-- Called when a player's health should regenerate.
function GM:PlayerShouldHealthRegenerate(player)
	return true
end

-- Called to get the entity that a player is holding.
function GM:PlayerGetHoldingEntity(player) end

-- A function to regenerate a player's health.
function GM:PlayerHealthRegenerate(player, health, maxHealth)
	local curTime = CurTime()
	
	if (player:Alive() and (!player.cwNextHealthRegen or curTime >= player.cwNextHealthRegen)) then
		local maxHealth = player:GetMaxHealth()
		local health = player:Health()

		if (health >= (maxHealth / 2) and (health < maxHealth)) then
			player:SetHealth(math.Clamp(
				health + 2, 0, maxHealth)
			)

			player.cwNextHealthRegen = curTime + 5
		elseif (health > 0) then
			player:SetHealth(
				math.Clamp(health + 2, 0, maxHealth)
			)

			player.cwNextHealthRegen = curTime + 10
		end
	end
end

-- Called when a player picks an item up.
function GM:PlayerPickupItem(player, itemTable, itemEntity, bQuickUse) end

-- Called when a player uses an item.
function GM:PlayerUseItem(player, itemTable, itemEntity)
	player:RebuildInventory()
end

-- Called when a player drops an item.
function GM:PlayerDropItem(player, itemTable, position, entity) end

-- Called when a player destroys an item.
function GM:PlayerDestroyItem(player, itemTable) end

-- Called when a player drops a weapon.
function GM:PlayerDropWeapon(player, itemTable, entity, weapon)
	if (itemTable:IsInstance() and IsValid(weapon)) then
		--[[local ammo = self:GetData("Ammo");

		if ammo then
			itemTable:SetData("Ammo", clipOne)
		end]]--
	end
end

-- Called when a player's data should be restored.
function GM:PlayerRestoreData(player, data)
	if (!data["Whitelisted"]) then
		data["Whitelisted"] = {}
	end
end

-- Called to get whether a player can pickup an entity.
function GM:AllowPlayerPickup(player, entity)
	return false
end

-- Called when a player selects a custom character option.
function GM:PlayerSelectCharacterOption(player, character, option) end

-- Called when a player attempts to see another player's status.
function GM:PlayerCanSeeStatus(player, target)
	return "# "..target:UserID().." | "..target:Name().." | "..target:SteamName().." | "..target:SteamID().." | "..target:IPAddress()
end

-- Called when a player attempts to see a player's chat.
function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
	return true
end

-- Called when a player attempts to hear another player's voice.
function GM:PlayerCanHearPlayersVoice(listener, speaker)
	if (!config.GetVal("voice_enabled")) then
		return false
	elseif (speaker:GetData("VoiceBan")) then
		return false
	elseif (!Clockwork.player:HasFlags(speaker, "x")) then
		return false
	end

	if (config.Get("local_voice"):Get()) then
		if (listener:IsRagdolled(RAGDOLL_KNOCKEDOUT) or !listener:Alive()) then
			return false
		elseif (speaker:IsRagdolled(RAGDOLL_KNOCKEDOUT) or !speaker:Alive()) then
			return false
		elseif (listener:GetPos():Distance(speaker:GetPos()) > config.Get("talk_radius"):Get()) then
			return false
		end
	end

	return true, true
end

-- Called when a player attempts to delete a character.
function GM:PlayerCanDeleteCharacter(player, character) end

-- Called when a player attempts to switch to a character.
function GM:PlayerCanSwitchCharacter(player, character)
	--[[if (!player:Alive() and !player:IsCharacterMenuReset()) then
		return "You cannot switch characters while being dead."
	else]]if (player:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
		return "You cannot switch characters while being unconscious."
	end

	return true
end

-- Called when a player attempts to use a character.
function GM:PlayerCanUseCharacter(player, character)
	local faction = Clockwork.faction:FindByID(character.faction)
	local playerRank, rank = player:GetFactionRank(character)
	local factionCount = 0
	local rankCount = 0

	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:GetFaction() == character.faction) then
				if (player != v) then
					if (rank and v:GetFactionRank() == playerRank) then
						rankCount = rankCount + 1
					end

					factionCount = factionCount + 1
				end
			end
		end
	end

	if (faction.playerLimit and factionCount >= faction.playerLimit) then
		return "There are too many characters in this faction."
	end

	if (rank and rank.playerLimit and rankCount >= rank.playerLimit) then
		return "There are too many characters in this class."
	end
end

-- Called when a player's weapons should be given.
function GM:PlayerGiveWeapons(player)
	local rankName, rank = player:GetFactionRank()
	local faction = Clockwork.faction:FindByID(player:GetFaction())

	if (rank and rank.weapons) then
		for k, v in pairs(rank.weapons) do
			Clockwork.player:GiveSpawnWeapon(player, v)
		end
	end

	if (faction and faction.weapons) then
		for k, v in pairs(faction.weapons) do
			Clockwork.player:GiveSpawnWeapon(player, v)
		end
	end
end

-- Called when a player deletes a character.
function GM:PlayerDeleteCharacter(player, character) end

-- Called when a player's armor is set.
function GM:PlayerArmorSet(player, newArmor, oldArmor)
	if (player:IsRagdolled()) then
		player:GetRagdollTable().armor = newArmor
	end
end

-- Called when a player's health is set.
function GM:PlayerHealthSet(player, newHealth, oldHealth)
	local bIsRagdolled = player:IsRagdolled()
	local maxHealth = player:GetMaxHealth()

	if (newHealth >= maxHealth) then
		player:RemoveAllDecals()

		if (bIsRagdolled) then
			player:GetRagdollEntity():RemoveAllDecals()
		end
	end

	if (bIsRagdolled) then
		player:GetRagdollTable().health = newHealth
	end
end

-- Called when a player attempts to own a door.
function GM:PlayerCanOwnDoor(player, door)
	if (Clockwork.entity:IsDoorUnownable(door)) then
		return false
	else
		return true
	end
end

-- Called when a player attempts to view a door.
function GM:PlayerCanViewDoor(player, door)
	if (Clockwork.entity:IsDoorUnownable(door)) then
		return false
	end

	return true
end

-- Called when a player attempts to holster a weapon.
function GM:PlayerCanHolsterWeapon(player, itemTable, weapon, bForce, bNoMsg)
	if (Clockwork.player:GetSpawnWeapon(player, itemTable:GetWeaponClass())) then
		if (!bNoMsg) then
			Schema:EasyText(player, "peru", "You cannot holster this weapon!")
		end

		return false
	elseif (itemTable.CanHolsterWeapon) then
		return itemTable:CanHolsterWeapon(player, weapon, bForce, bNoMsg)
	else
		return true
	end
end

-- Called when a player attempts to drop a weapon.
function GM:PlayerCanDropWeapon(player, itemTable, weapon, bNoMsg)
	if (Clockwork.player:GetSpawnWeapon(player, itemTable:GetWeaponClass())) then
		if (!bNoMsg) then
			Schema:EasyText(player, "peru", "You cannot drop this weapon!")
		end

		return false
	elseif (itemTable.CanDropWeapon) then
		return itemTable:CanDropWeapon(player, bNoMsg)
	else
		return true
	end
end

-- Called when a player attempts to use an item.
function GM:PlayerCanUseItem(player, itemTable, bNoMsg)
	local isWeapon = item.IsWeapon(itemTable)
	local isSpawnWeapon = false
	local allWeapons = player:GetWeapons();

	if (isWeapon) then
		isSpawnWeapon = Clockwork.player:GetSpawnWeapon(player, itemTable:GetWeaponClass())
	end

	if (isWeapon and isSpawnWeapon) then
		if (!bNoMsg) then
			Schema:EasyText(player, "peru", "You cannot use this weapon!")
		end

		return false
	else
		return true
	end
end

-- Called when a player attempts to drop an item.
function GM:PlayerCanDropItem(player, itemTable, bNoMsg) return true end

-- Called when a player attempts to destroy an item.
function GM:PlayerCanDestroyItem(player, itemTable, bNoMsg) return true end

-- Called when a player attempts to knockout a player.
function GM:PlayerCanKnockout(player, target) return true end

-- Called when death attempts to clear a player's name.
function GM:PlayerCanDeathClearName(player, attacker, damageInfo) return false end

-- Called when death attempts to clear a player's recognised names.
function GM:PlayerCanDeathClearRecognisedNames(player, attacker, damageInfo) return false end

-- Called when a player's ragdoll attempts to take damage.
function GM:PlayerRagdollCanTakeDamage(player, ragdoll, inflictor, attacker, hitGroup, damageInfo)
	if (!attacker:IsPlayer() and player:GetRagdollTable().immunity) then
		if (CurTime() <= player:GetRagdollTable().immunity) then
			return false
		end
	end

	return true
end

-- Called when the player attempts to be ragdolled.
function GM:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	if (IsValid(player.propellerengine)) then
		return false
	end;
	return true
end

-- Called when the player attempts to be unragdolled.
function GM:PlayerCanUnragdoll(player, state, ragdoll)
	return true
end

-- Called when a player has been ragdolled.
function GM:PlayerRagdolled(player, state, ragdoll)
	player:SetDTBool(BOOL_FALLENOVER, false)
	
	local action = Clockwork.player:GetAction(player);
	
	if (action == "putting_on_armor" or action == "taking_off_armor") then
		Clockwork.player:SetAction(player, nil);
	end
end

-- Called when a player has been unragdolled.
function GM:PlayerUnragdolled(player, state, ragdoll)
	player:SetDTBool(BOOL_FALLENOVER, false)
end

-- Called to check if a player does have a flag.
function GM:PlayerDoesHaveFlag(player, flag)
	if (string.find(config.Get("default_flags"):Get(), flag)) then
		return true
	end
end

-- Called when a player's model should be set.
function GM:PlayerSetModel(player)
	Clockwork.player:SetDefaultModel(player)
	Clockwork.player:SetDefaultSkin(player)
end

-- Called to check if a player does have door access.
function GM:PlayerDoesHaveDoorAccess(player, door, access, isAccurate)
	if (Clockwork.entity:GetOwner(door) != player) then
		local key = player:GetCharacterKey();
		
		if (door.accessList and door.accessList[key]) then
			if (isAccurate) then
				return door.accessList[key] == access;
			else
				return door.accessList[key] >= access;
			end;
		end;
		
		return false;
	else
		return true;
	end;
end;

-- Called to check if a player does know another player.
function GM:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	return realValue
end

-- Called when a player attempts to lock an entity.
function GM:PlayerCanLockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity)) then
		return Clockwork.player:HasDoorAccess(player, entity)
	else
		return true
	end
end

-- Called when a player's class has been set.
function GM:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange)
	player:SetCharacterData("Class", newClass.name)
end

-- Called when a player attempts to unlock an entity.
function GM:PlayerCanUnlockEntity(player, entity)
	if (Clockwork.entity:IsDoor(entity)) then
		return Clockwork.player:HasDoorAccess(player, entity)
	else
		return true
	end
end

-- Called when a player attempts to use a door.
function GM:PlayerCanUseDoor(player, door)
	if (Clockwork.entity:GetOwner(door) and !Clockwork.player:HasDoorAccess(player, door)) then
		return false
	end

	if (Clockwork.entity:IsDoorFalse(door)) then
		return false
	end
end

-- Called when a player uses a door.
function GM:PlayerUseDoor(player, door) end

-- Called when a player attempts to use an entity in a vehicle.
function GM:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if (entity.UsableInVehicle or Clockwork.entity:IsDoor(entity)) then
		return true
	end
end

-- Called when a player's ragdoll attempts to decay.
function GM:PlayerCanRagdollDecay(player, ragdoll, seconds)
	return true
end

-- Called when a player attempts to exit a vehicle.
function GM:CanExitVehicle(vehicle, player)
	if (player.cwNextExitVehicle and player.cwNextExitVehicle > CurTime()) then
		return false
	end

	if (IsValid(player) and player:IsPlayer()) then
		local trace = player:GetEyeTraceNoCursor()

		if (IsValid(trace.Entity) and !trace.Entity:IsVehicle()) then
			if (hook.Run("PlayerCanUseEntityInVehicle", player, trace.Entity, vehicle)) then
				return false
			end
		end
	end

	if (Clockwork.entity:IsChairEntity(vehicle) and !IsValid(vehicle:GetParent())) then
		local trace = player:GetEyeTraceNoCursor()

		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			trace = {
				start = trace.HitPos,
				endpos = trace.HitPos - Vector(0, 0, 1024),
				filter = {player, vehicle}
			}

			player.cwExitVehiclePos = util.TraceLine(trace).HitPos

			player:SetMoveType(MOVETYPE_NOCLIP)
		else
			return false
		end
	end

	return true
end

-- Called when a player leaves a vehicle.
function GM:PlayerLeaveVehicle(player, vehicle)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player) and !player:InVehicle()) then
			if (IsValid(vehicle)) then
				if (Clockwork.entity:IsChairEntity(vehicle)) then
					local position = player.cwExitVehiclePos or vehicle:GetPos()
					local targetPosition = Clockwork.player:GetSafePosition(player, position, vehicle)

					if (targetPosition) then
						player:SetMoveType(MOVETYPE_NOCLIP)
						
						for k, v in ipairs(targetPosition) do
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

					player:SetMoveType(MOVETYPE_WALK)
					player.cwExitVehiclePos = nil
				end
			end
		end
	end)
end

-- Called when a player attempts to enter a vehicle.
function GM:CanPlayerEnterVehicle(player, vehicle, role)
	return true
end

-- Called when a player enters a vehicle.
function GM:PlayerEnteredVehicle(player, vehicle, class)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player)) then
			local model = player:GetModel()
			local class = Clockwork.animation:GetModelClass(model)

			if (IsValid(vehicle) and !string.find(model, "/player/")) then
				if (class == "maleHuman" or class == "femaleHuman") then
					if (Clockwork.entity:IsChairEntity(vehicle)) then
						player:SetLocalPos(Vector(16.5438, -0.1642, -20.5493))
					else
						player:SetLocalPos(Vector(30.1880, 4.2020, -6.6476))
					end
				end
			end

			player:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		end
	end)
end

-- Called when a player attempts to change class.
function GM:PlayerCanChangeClass(player, class)
	local curTime = CurTime()

	if (player.cwNextChangeClass and curTime < player.cwNextChangeClass) then
		Schema:EasyText(player, "peru", "You cannot change classes for another "..math.ceil(player.cwNextChangeClass - curTime).." seconds!");

		return false
	else
		return true
	end
end

-- Called when a player attempts to earn wages cash.
function GM:PlayerCanEarnWagesCash(player, cash)
	return true
end

-- Called when a player is given wages cash.
function GM:PlayerGiveWagesCash(player, cash, wagesName)
	return true
end

-- Called when a player earns wages cash.
function GM:PlayerEarnWagesCash(player, cash) end

-- Called when Clockwork has loaded all of the entities.
function GM:ClockworkInitPostEntity() end

-- Called when a player attempts to say something in-character.
function GM:PlayerCanSayIC(player, text)
	if ((!player:Alive() or player:IsRagdolled(RAGDOLL_FALLENOVER)) and !Clockwork.player:GetDeathCode(player, true)) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")

		return false
	else
		return true
	end
end

-- Called when a player attempts to say something out-of-character.
function GM:PlayerCanSayOOC(player, text) return player:IsAdmin() end

-- Called when a player attempts to say something locally out-of-character.
function GM:PlayerCanSayLOOC(player, text) return true end

-- Called when attempts to use a command.
function GM:PlayerCanUseCommand(player, commandTable, arguments)
	return true
end

function GM:PlayerSay(player, text, bPublic)
	if (CLOCKWORK_PLAYERSAY_OVERRIDE) then
		return text;
	else
		return "";
	end;
end;

local function PlayerSayFunc(player, text)
	CLOCKWORK_PLAYERSAY_OVERRIDE = true;
	text = hook.Run("PlayerSay", player, text, true);
	CLOCKWORK_PLAYERSAY_OVERRIDE = nil;

	if (text == "") then return; end;

	local maxChatLength = config.Get("max_chat_length"):Get();
	local prefix = config.Get("command_prefix"):Get();
	local curTime = CurTime();

	if (string.len(text) >= maxChatLength) then
		text = string.sub(text, 0, maxChatLength);
	end;

	if (string.sub(text, 1, 2) == "//") then
		text = string.Trim(string.sub(text, 3));

		if (text != "") then
			if (hook.Run("PlayerCanSayOOC", player, text)) then
				if (!player.cwNextTalkOOC or curTime > player.cwNextTalkOOC or player:IsAdmin()) then
					Clockwork.kernel:ServerLog("[OOC] "..player:Name()..": "..text);
					Clockwork.chatBox:Add(nil, player, "ooc", text);
					player.cwNextTalkOOC = curTime + config.Get("ooc_interval"):Get();
				else
					Schema:EasyText(player, "grey", "You cannot cannot talk out-of-character for another "..math.ceil(player.cwNextTalkOOC - CurTime()).." second(s)!");
					return;
				end;
			end;
		end;
	elseif (string.sub(text, 1, 3) == ".//" or string.sub(text, 1, 4) == ".///" or string.sub(text, 1, 2) == "[[" or string.sub(text, 1, 3) == "[[[") then
		local adminText = string.sub(text, 1, 4) == ".///";
		local adminTextAlt = string.sub(text, 1, 3) == "[[[";
		
		if adminText then
			text = string.Trim(string.sub(text, 5));
		elseif adminTextAlt or (string.sub(text, 1, 3) == ".//") then
			text = string.Trim(string.sub(text, 4));
		else
			text = string.Trim(string.sub(text, 3));
		end;

		if (text != "") then
			if (hook.Run("PlayerCanSayLOOC", player, text)) then
				Clockwork.kernel:ServerLog("[LOOC] "..player:Name()..": "..text);
				
				if adminText or adminTextAlt then
					Clockwork.chatBox:AddInRadius(player, "loocnoicon", text, player:GetPos(), config.Get("talk_radius"):Get());
				else
					Clockwork.chatBox:AddInRadius(player, "looc", text, player:GetPos(), config.Get("talk_radius"):Get());
				end
			end;
		end;
	elseif (string.sub(text, 1, 1) == prefix) then
		local prefixLength = string.len(prefix);
		local arguments = Clockwork.kernel:ExplodeByTags(text, " ", "\"", "\"", true);
		local command = string.sub(arguments[1], prefixLength + 1);

		if (Clockwork.command.stored[command] and Clockwork.command.stored[command].arguments < 2
		and !Clockwork.command.stored[command].optionalArguments) then
			text = string.sub(text, string.len(command) + prefixLength + 2);

			if (text != "") then
				arguments = {command, text};
			else
				arguments = {command};
			end;
		else
			arguments[1] = command;
		end;

		Clockwork.command:ConsoleCommand(player, "cwCmd", arguments);
	elseif (hook.Run("PlayerCanSayIC", player, text)) then
		if player.victim and IsValid(player.victim) then
			Clockwork.chatBox:AddInRadius(player.victim, "ic", text, player:GetPos(), config.Get("talk_radius"):Get());
			
			hook.Run("PlayerSayICEmitSound", player.victim);
		elseif player.possessor and IsValid(player.possessor) then
			Clockwork.chatBox:Add({player, player.possessor}, player, "demonhosttalk", text);
		else
			Clockwork.chatBox:AddInRadius(player, "ic", text, player:GetPos(), config.Get("talk_radius"):Get());
			
			hook.Run("PlayerSayICEmitSound", player);
		end

		if (Clockwork.player:GetDeathCode(player, true)) then
			Clockwork.player:UseDeathCode(player, nil, {text});
		end;
	end;

	if (Clockwork.player:GetDeathCode(player)) then
		Clockwork.player:TakeDeathCode(player);
	end;
end;

netstream.Hook("PlayerSay", function(player, data)
	if (type(data) == "string") then
		PlayerSayFunc(player, data);
	end;
end);

function Clockwork.player:MakeSay(player, data)
	PlayerSayFunc(player, data);
end

-- Called when a player attempts to suicide.
function GM:CanPlayerSuicide(player) return false end

-- Called when a player attempts to punt an entity with the gravity gun.
function GM:GravGunPunt(player, entity)
	return config.Get("enable_gravgun_punt"):Get()
end

-- Called when a player attempts to pickup an entity with the gravity gun.
function GM:GravGunPickupAllowed(player, entity)
	if (IsValid(entity)) then
		if (!Clockwork.player:IsAdmin(player) and !Clockwork.entity:IsInteractable(entity)) then
			return false
		else
			return self.BaseClass:GravGunPickupAllowed(player, entity)
		end
	end

	return false
end

-- Called when a player picks up an entity with the gravity gun.
function GM:GravGunOnPickedUp(player, entity)
	player.cwIsHoldingEnt = entity
	entity.cwIsBeingHeld = player
end

-- Called when a player drops an entity with the gravity gun.
function GM:GravGunOnDropped(player, entity)
	player.cwIsHoldingEnt = nil
	entity.cwIsBeingHeld = nil
end

-- Called when a player attempts to unfreeze an entity.
function GM:CanPlayerUnfreeze(player, entity, physicsObject)
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	if (config.Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey()

		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false
		end
	end

	if (!bIsAdmin and !Clockwork.entity:IsInteractable(entity)) then
		return false
	end

	if (entity:IsVehicle()) then
		if (IsValid(entity:GetDriver())) then
			return false
		end
	end

	return true
end

-- Called when a player attempts to freeze an entity with the physics gun.
function GM:OnPhysgunFreeze(weapon, physicsObject, entity, player)
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	-- Let operators freeze static entities.
	if (IsValid(entity) and entity:GetPersistent() and Clockwork.player:HasFlags(player, "o")) then
		return BaseClass.OnPhysgunFreeze(self, weapon, physicsObject, entity, player)
	end

	if (config.GetVal("enable_prop_protection") and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey()

		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false
		end
	end

	if (!bIsAdmin and Clockwork.entity:IsChairEntity(entity)) then
		local entities = ents.FindInSphere(entity:GetPos(), 64)

		for k, v in pairs(entities) do
			if (Clockwork.entity:IsDoor(v)) then
				return false
			end
		end
	end

	if (entity:GetPhysicsObject():IsPenetrating()) then
		return false
	end

	if (!bIsAdmin and entity.PhysgunDisabled) then
		return false
	end

	if (!bIsAdmin and !Clockwork.entity:IsInteractable(entity)) then
		return false
	else
		return self.BaseClass:OnPhysgunFreeze(weapon, physicsObject, entity, player)
	end
end

-- Called when a player attempts to pickup an entity with the physics gun.
function GM:PhysgunPickup(player, entity)
	local bCanPickup = nil
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	if (!config.Get("enable_map_props_physgrab"):Get()) then
		if (Clockwork.entity:IsMapEntity(entity)) then
			bCanPickup = false
		end
	end

	if (!bIsAdmin and !Clockwork.entity:IsInteractable(entity)) then
		return false
	end

	if (!bIsAdmin and Clockwork.entity:IsPlayerRagdoll(entity)) then
		return false
	end

	if (!bIsAdmin and entity:GetClass() == "prop_ragdoll") then
		local ownerKey = entity:GetOwnerKey()

		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false
		end
	end

	if (!bIsAdmin) then
		bCanPickup = self.BaseClass:PhysgunPickup(player, entity)
	else
		bCanPickup = true
	end

	if (Clockwork.entity:IsChairEntity(entity) and !bIsAdmin) then
		local entities = ents.FindInSphere(entity:GetPos(), 256)

		for k, v in pairs(entities) do
			if (Clockwork.entity:IsDoor(v)) then
				return false
			end
		end
	end

	if (config.Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey()

		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			bCanPickup = false
		end
	end

	if (entity:IsPlayer() and entity:InVehicle() or entity.cwObserverMode) then
		bCanPickup = false
	end

	if (bCanPickup) then
		player.cwIsHoldingEnt = entity
		entity.cwIsBeingHeld = player

		if (!entity:IsPlayer()) then
			if (config.Get("prop_kill_protection"):Get()
			and !entity.cwLastCollideGroup) then
				Clockwork.entity:StopCollisionGroupRestore(entity)
				entity.cwLastCollideGroup = entity:GetCollisionGroup()
				entity:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			end

			entity.cwDamageImmunity = CurTime() + 60
		elseif (!entity.cwMoveType) then
			entity.cwMoveType = entity:GetMoveType()
			entity:SetMoveType(MOVETYPE_NOCLIP)
		end

		return true
	else
		return false
	end
end

-- Called when a player attempts to drop an entity with the physics gun.
function GM:PhysgunDrop(player, entity)
	if (!entity:IsPlayer() and entity.cwLastCollideGroup) then
		Clockwork.entity:ReturnCollisionGroup(
			entity, entity.cwLastCollideGroup
		)

		entity.cwLastCollideGroup = nil
	elseif (entity.cwMoveType) then
		entity:SetMoveType(MOVETYPE_WALK)
		entity.cwMoveType = nil
	end

	entity.cwDamageImmunity = CurTime() + 60
	player.cwIsHoldingEnt = nil
	entity.cwIsBeingHeld = nil
end

-- Called when a player attempts to spawn an NPC.
function GM:PlayerSpawnNPC(player, model)
	if (!Clockwork.player:HasFlags(player, "n")) then
		return false
	end

	if (!player:Alive() or player:IsRagdolled()) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")

		return false
	end

	if (!Clockwork.player:IsAdmin(player)) then
		return false
	else
		return true
	end
end

-- Called when an NPC has been killed.
function GM:OnNPCKilled(entity, attacker, inflictor) end

-- Called to get whether an entity is being held.
function GM:GetEntityBeingHeld(entity)
	return entity.cwIsBeingHeld or entity:IsPlayerHolding()
end

-- Called when an entity is removed.
function GM:EntityRemoved(entity)
	if (!Clockwork.kernel:IsShuttingDown()) then
		if (IsValid(entity)) then
			--[[if (entity:GetClass() == "prop_ragdoll") then
				if (entity.cwIsBelongings and entity.cwInventory and entity.cwCash
				and (table.Count(entity.cwInventory) > 0 or entity.cwCash > 0)) then
					local belongings = ents.Create("cw_belongings")

					belongings:SetAngles(Angle(0, 0, -90))
					belongings:SetData(entity.cwInventory, entity.cwCash)
					belongings:SetPos(entity:GetPos() + Vector(0, 0, 32))
					belongings:Spawn()

					entity.cwInventory = nil
					entity.cwCash = nil
				end
			end]]--

			local allProperty = Clockwork.player:GetAllProperty()
			local entIndex = entity:EntIndex()

			if (entity.cwGiveRefundTab
			and CurTime() <= entity.cwGiveRefundTab[1]) then
				if (IsValid(entity.cwGiveRefundTab[2])) then
					Clockwork.player:GiveCash(entity.cwGiveRefundTab[2], entity.cwGiveRefundTab[3], "Prop Refund")
				end
			end

			allProperty[entIndex] = nil

			if (entity:GetClass() == "csItem") then
				item.RemoveItemEntity(entity)
			end
		end

		Clockwork.entity:ClearProperty(entity)
	end
end

-- Called when an entity's menu option should be handled.
function GM:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass()

	if (class == "cw_item" and (arguments == "cwItemTake" or arguments == "cwItemUse")) then
		--[[if (Clockwork.entity:BelongsToAnotherCharacter(player, entity)) then
			Schema:EasyText(player, "peru", "You cannot pick up items you've dropped on another character!")
			return
		end]]--

		local itemTable = entity.cwItemTable
		local bQuickUse = (arguments == "cwItemUse")

		if (itemTable) then
			local bDidPickupItem = true
			local bCanPickup = (!itemTable.CanPickup or itemTable:CanPickup(player, bQuickUse, entity))

			if (bCanPickup != false) then
				player:SetItemEntity(entity)

				if (bQuickUse) then
					itemTable = player:GiveItem(itemTable, true)

					if itemTable then
						if (!Clockwork.player:InventoryAction(player, itemTable, "use")) then
							player:TakeItem(itemTable, true)
							bDidPickupItem = false
						else
							player:FakePickup(entity)
						end
					else
						printp("itemTable not found sv_hooks");
						bDidPickupItem = false
					end
				else
					local bSuccess, fault = player:GiveItem(itemTable)

					if (!bSuccess) then
						Schema:EasyText(player, "peru", fault)
						bDidPickupItem = false
					else
						player:FakePickup(entity)
					end
				end

				hook.Run(
					"PlayerPickupItem", player, itemTable, entity, bQuickUse
				)

				if (bDidPickupItem) then
					if (!itemTable.OnPickup or itemTable:OnPickup(player, bQuickUse, entity) != false) then
						entity:Remove()
					end
				end

				if !player.cwObserverMode then
					--local pickupSound = itemTable.pickupSound or "physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav"
					local pickupSound = itemTable.pickupSound or "generic_ui/ui_llite_0"..tostring(math.random(1, 3))..".wav";

					if (type(pickupSound) == "table") then
						pickupSound = pickupSound[math.random(1, #pickupSound)]
					end

					player:EmitSound(pickupSound)
				end

				player:SetItemEntity(nil)
			end
		end
	elseif (class == "cw_item" and arguments == "cwItemRepair") then
		local itemTable = entity.cwItemTable
		
		if itemTable then
			local itemCondition = itemTable:GetCondition();

			if itemCondition < 100 then
				if itemTable.repairItem then
					local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
					local repairItemTable;

					for k, v in pairs (itemList) do
						if v.uniqueID == itemTable.repairItem then
							repairItemTable = v;
							break;
						end
					end
		
					if repairItemTable then
						local replenishment = (repairItemTable.conditionReplenishment or 100) - ((100 - repairItemTable:GetCondition()) * (repairItemTable.conditionReplenishment / 100));
						
						itemTable:GiveCondition(math.min(replenishment, 100));
						repairItemTable:TakeCondition((itemTable:GetCondition() - itemCondition) / (repairItemTable.conditionReplenishment / 100));
						
						if repairItemTable:GetCondition() <= 0 then
							player:TakeItem(repairItemTable, true);
							
							Schema:EasyText(player, "olivedrab", "You have repaired your "..itemTable.name.." to "..tostring(math.Round(itemTable:GetCondition(), 2))..", using the last of the repair kit's parts in the process.");
						else
							Schema:EasyText(player, "green", "You have repaired your "..itemTable.name.." to "..tostring(math.Round(itemTable:GetCondition(), 2))..".");
							Clockwork.inventory:Rebuild(player);
						end
					else
						Schema:EasyText(player, "chocolate", "You do not have an item you can repair this item with!");
						return false;
					end
				end
			else
				Schema:EasyText(player, "peru", "This item is already in perfect condition and cannot be repaired.");
				return false;
			end
		end
	elseif (class == "cw_item" and arguments == "cwItemExamine") then
		local itemTable = entity.cwItemTable
		local itemCondition = itemTable:GetCondition();
		local itemEngraving = itemTable:GetData("engraving");
		local examineText = itemTable.description
		local conditionTextCategories = {"Armor", "Firearms", "Helms", "Melee", "Shields", "Javelins"};

		if (itemTable.GetEntityExamineText) then
			examineText = itemTable:GetEntityExamineText(entity)
		end

		if itemEngraving and itemEngraving ~= "" then
			local itemKills = itemTable:GetData("kills");
			
			if itemKills and itemKills > 0 then
				examineText = examineText.." It has \'"..itemEngraving.."\' engraved into it, alongside a tally mark of "..tostring(itemKills).." kills.";
			else
				examineText = examineText.." It has \'"..itemEngraving.."\' engraved into it.";
			end
		end

		if table.HasValue(conditionTextCategories, itemTable.category) then
			if itemCondition >= 90 then
				examineText = examineText.." It appears to be in immaculate condition.";
			elseif itemCondition < 90 and itemCondition >= 60 then
				examineText = examineText.." It appears to be in a somewhat battered condition.";
			elseif itemCondition < 60 and itemCondition >= 30 then
				examineText = examineText.." It appears to be in very poor condition.";
			elseif itemCondition < 30 and itemCondition > 0 then
				examineText = examineText.." It appears to be on the verge of breaking.";
			elseif itemCondition <= 0 then
				if itemTable:IsBroken() then
					examineText = examineText.." It is completely destroyed and only worth its weight in scrap now.";
				else
					examineText = examineText.." It is broken yet still usable to some degree.";
				end
			end
		elseif itemTable.category == "Shot" and itemTable.ammoMagazineSize then
			local rounds = itemTable:GetAmmoMagazine();
			
			examineText = examineText.." The magazine has "..tostring(rounds).." "..itemTable.ammoName.." rounds loaded.";
		end
		local co = itemTable.examineColor or "skyblue"
		Schema:EasyText(player, co, examineText)
	elseif (class == "cw_item" and arguments == "cwItemAmmo") then
		local itemTable = entity.cwItemTable

		if (item.IsWeapon(itemTable)) then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				if #ammo == 1 then
					if itemTable.usesMagazine and !string.find(ammo[1], "Magazine") then
						local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
						local magazineItem = item.CreateInstance(ammoItemID, nil, nil, true);
						
						if magazineItem and magazineItem.SetAmmoMagazine then
							magazineItem:SetAmmoMagazine(1);
							
							player:GiveItem(magazineItem);
						end
					else
						local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
						
						player:GiveItem(item.CreateInstance(ammoItemID, nil, nil, true));
					end
				elseif itemTable.usesMagazine then
					local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
					local magazineItem = item.CreateInstance(ammoItemID, nil, nil, true);
					
					if magazineItem and magazineItem.SetAmmoMagazine then
						magazineItem:SetAmmoMagazine(#ammo);
						
						player:GiveItem(magazineItem);
					end
				else
					for i = 1, #ammo do
						local round = ammo[i];
						
						if round then
							local roundItemID = string.gsub(string.lower(round), " ", "_");
							local roundItemInstance = item.CreateInstance(roundItemID, nil, nil, true);
							
							player:GiveItem(roundItemInstance);
						end
					end
				end
				
				itemTable:SetData("Ammo", {});
			end
		end
	elseif (class == "cw_item" and arguments == "cwItemMagazineAmmo") then
		local itemTable = entity.cwItemTable

		if (itemTable.category == "Shot" and itemTable.ammoMagazineSize) then
			if itemTable.TakeFromMagazine then
				itemTable:TakeFromMagazine(player);
			end
		end
	elseif (class == "cw_item") then
		local itemTable = entity.cwItemTable

		if (itemTable and itemTable.EntityHandleMenuOption) then
			itemTable:EntityHandleMenuOption(player, entity, option, arguments)
		end
	--[[elseif (entity:GetClass() == "cw_belongings" and arguments == "cwBelongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav")

		Clockwork.storage:Open(player, {
			name = "Belongings",
			cash = entity.cwCash,
			weight = 100,
			space = 200,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			isOneSided = true,
			OnGiveCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash
			end,
			OnTakeCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash
			end,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity)) then
					if ((!entity.cwInventory and !entity.cwCash)
					or (table.Count(entity.cwInventory) == 0 and entity.cwCash == 0)) then
						entity:Explode(entity:BoundingRadius() * 2)
						entity:Remove()
					end
				end
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false
			end
		})]]--
	elseif (class == "cw_shipment" and arguments == "cwShipmentOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav")
		player:FakePickup(entity)

		Clockwork.storage:Open(player, {
			name = "Shipment",
			weight = entity.cwWeight,
			space = entity.cwSpace,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			isOneSided = true,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity) and Clockwork.inventory:IsEmpty(entity.cwInventory)) then
					entity:Explode(entity:BoundingRadius() * 2)
					entity:Remove()
				end
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false
			end
		})
	elseif (class == "cw_cash" and arguments == "cwCashTake") then
		--[[if (Clockwork.entity:BelongsToAnotherCharacter(player, entity)) then
			Schema:EasyText(player, "peru", "You cannot pick up "..Clockwork.option:GetKey("name_cash", true).." that you've dropped on another character!");
			return
		end]]--

		Clockwork.player:GiveCash(player, entity.cwAmount, Clockwork.option:GetKey("name_cash"))
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav")
		player:FakePickup(entity)

		entity:Remove()
	end
end

-- Called when a player has spawned a prop.
function GM:PlayerSpawnedProp(player, model, entity)
	if (IsValid(entity)) then
		local scalePropCost = config.Get("scale_prop_cost"):Get()

		if (player.cwObserverMode) then scalePropCost = 0 end

		if (scalePropCost > 0) then
			local cost = math.ceil(math.max((entity:BoundingRadius() / 2) * scalePropCost, 1))
			local info = {cost = cost, name = "Prop"}

			hook.Run("PlayerAdjustPropCostInfo", player, entity, info)

			if (Clockwork.player:CanAfford(player, info.cost)) then
				Clockwork.player:GiveCash(player, -info.cost, info.name)
				entity.cwGiveRefundTab = {CurTime() + 10, player, info.cost}
			else
				Schema:EasyText(player, "chocolate", "You need another "..Clockwork.kernel:FormatCash(info.cost - player:GetCash(), nil, true).." to buy this!")
				entity:Remove()
				return
			end
		end

		if (IsValid(entity)) then
			self.BaseClass:PlayerSpawnedProp(player, model, entity)
			entity:SetOwnerKey(player:GetCharacterKey())

			if (IsValid(entity)) then
				Clockwork.kernel:PrintLog(LOGTYPE_URGENT, player:Name().." has spawned '"..tostring(model).."'.")

				if (config.Get("prop_kill_protection"):Get()) then
					entity.cwDamageImmunity = CurTime() + 60
				end
			end
		end
	end
end

-- Called when a player attempts to spawn a prop.
function GM:PlayerSpawnProp(player, model)
	if (!Clockwork.player:HasFlags(player, "e")) then
		return false
	end

	if (!player:Alive() or player:IsRagdolled()) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")
		return false
	end

	if (Clockwork.player:IsAdmin(player)) then
		return true
	end

	return self.BaseClass:PlayerSpawnProp(player, model)
end

-- Called when a player attempts to spawn a ragdoll.
function GM:PlayerSpawnRagdoll(player, model)
	if (!Clockwork.player:HasFlags(player, "r")) then return false end

	if (!player:Alive() or player:IsRagdolled()) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")

		return false
	end

	if (!Clockwork.player:IsAdmin(player)) then
		return false
	else
		return true
	end
end

-- Called when a player attempts to spawn an effect.
function GM:PlayerSpawnEffect(player, model)
	if (!player:Alive() or player:IsRagdolled()) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")

		return false
	end

	if (!Clockwork.player:IsAdmin(player)) then
		return false
	else
		return true
	end
end

-- Called when a player attempts to spawn a vehicle.
function GM:PlayerSpawnVehicle(player, model)
	if (!string.find(model, "chair") and !string.find(model, "seat")) then
		if (!Clockwork.player:HasFlags(player, "C")) then
			return false
		end
	elseif (!Clockwork.player:HasFlags(player, "c")) then
		return false
	end

	if (!player:Alive() or player:IsRagdolled()) then
		Schema:EasyText(player, "peru", "You cannot do this action at the moment!")

		return false
	end

	if (Clockwork.player:IsAdmin(player)) then
		return true
	end

	return self.BaseClass:PlayerSpawnVehicle(player, model)
end

-- Called when a player attempts to use a tool.
function GM:CanTool(player, trace, tool)
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	if (IsValid(trace.Entity)) then
		local bPropProtectionEnabled = config.Get("enable_prop_protection"):Get()
		local characterKey = player:GetCharacterKey()

		if (!bIsAdmin and !Clockwork.entity:IsInteractable(trace.Entity)) then
			return false
		end

		if (!bIsAdmin and Clockwork.entity:IsPlayerRagdoll(trace.Entity)) then
			return false
		end

		if (bPropProtectionEnabled and !bIsAdmin) then
			local ownerKey = trace.Entity:GetOwnerKey()

			if (ownerKey and characterKey != ownerKey) then
				return false
			end
		end

		if (!bIsAdmin) then
			if (tool == "nail") then
				local newTrace = {}

				newTrace.start = trace.HitPos
				newTrace.endpos = trace.HitPos + player:GetAimVector() * 16
				newTrace.filter = {player, trace.Entity}

				newTrace = util.TraceLine(newTrace)

				if (IsValid(newTrace.Entity)) then
					if (!Clockwork.entity:IsInteractable(newTrace.Entity) or Clockwork.entity:IsPlayerRagdoll(newTrace.Entity)) then
						return false
					end

					if (bPropProtectionEnabled) then
						local ownerKey = newTrace.Entity:GetOwnerKey()

						if (ownerKey and characterKey != ownerKey) then
							return false
						end
					end
				end
			elseif (tool == "remover" and player:KeyDown(IN_ATTACK2) and !player:KeyDownLast(IN_ATTACK2)) then
				if (!trace.Entity:IsMapEntity()) then
					local entities = constraint.GetAllConstrainedEntities(trace.Entity)

					for k, v in pairs(entities) do
						if (v:IsMapEntity() or Clockwork.entity:IsPlayerRagdoll(v)) then
							return false
						end

						if (bPropProtectionEnabled) then
							local ownerKey = v:GetOwnerKey()

							if (ownerKey and characterKey != ownerKey) then
								return false
							end
						end
					end
				else
					return false
				end
			end
		end
	end

	if (!bIsAdmin) then
		if (tool == "dynamite" or tool == "duplicator") then
			return false
		end

		return self.BaseClass:CanTool(player, trace, tool)
	else
		return true
	end
end

-- Called when a player attempts to use the property menu.
function GM:CanProperty(player, property, entity)
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	if (!player:Alive() or player:IsRagdolled() or !bIsAdmin) then
		return false
	end

	return self.BaseClass:CanProperty(player, property, entity)
end

-- Called when a player attempts to use drive.
function GM:CanDrive(player, entity)
	local bIsAdmin = Clockwork.player:IsAdmin(player)

	if (!player:Alive() or player:IsRagdolled() or !bIsAdmin) then
		return false
	end

	return self.BaseClass:CanDrive(player, entity)
end

-- Called when a player attempts to NoClip.
function GM:PlayerNoClip(player)
	if (player:IsRagdolled()) then
		return false
	elseif (player:IsSuperAdmin()) then
		return true
	else
		return false
	end
end

-- Called when a player's character has initialized.
function GM:PlayerCharacterInitialized(player)
	netstream.Start(player, "InvClear", true)
	--netstream.Start(player, "AttrClear", true)

	if (!Clockwork.class:FindByID(player:Team())) then
		Clockwork.class:AssignToDefault(player)
	end

	--[[player.cwAttrProgress = player.cwAttrProgress or {}
	player.cwAttrProgressTime = 0

	for k, v in pairs(Clockwork.attribute:GetAll()) do
		player:UpdateAttribute(k)
	end

	for k, v in pairs(player:GetAttributes()) do
		player.cwAttrProgress[k] = math.floor(v.progress)
	end

	local startHintsDelay = 4
	local starterHintsTable = {
		"Directory",
		"Give Name",
		"Target Recognises",
		"Raise Weapon"
	}

	for k, v in pairs(starterHintsTable) do
		local hintTable = Clockwork.hint:Find(v)

		if (hintTable and !player:GetData("Hint"..k)) then
			if (!hintTable.Callback or hintTable.Callback(player) != false) then
				timer.Simple(startHintsDelay, function()
					if (IsValid(player)) then
						Clockwork.hint:Send(player, hintTable.text, 30)
						player:SetData("Hint"..k, true)
					end
				end)

				startHintsDelay = startHintsDelay + 30
			end
		end
	end

	if (startHintsDelay > 4) then
		player.cwViewStartHints = true

		timer.Simple(startHintsDelay, function()
			if (IsValid(player)) then
				player.cwViewStartHints = false
			end
		end)
	end]]--

	timer.Simple(FrameTime() * 0.5, function()
		Clockwork.inventory:SendUpdateAll(player)
	end)

	netstream.Start(player, "CharacterInit", player:GetCharacterKey())

	--[[local playerFaction = player:GetFaction()
	local spawnRank = Clockwork.faction:GetDefaultRank(playerFaction) or Clockwork.faction:GetLowestRank(playerFaction)

	player:SetFactionRank(player:GetFactionRank() or spawnRank)

	local rankName, rankTable = player:GetFactionRank()

	if (rankTable) then
		if (rankTable.class and Clockwork.class:GetAll()[rankTable.class]) then

			Clockwork.class:Set(player, rankTable.class)
		end

		if (rankTable.model) then
			player:SetModel(rankTable.model)
		end
	end]]--
end

-- Called when a player has used their death code.
function GM:PlayerDeathCodeUsed(player, commandTable, arguments) end

-- Called when a player has created a character.
function GM:PlayerCharacterCreated(player, character)
	-- Horrible fucking fix because F2 wasn't working for brand new characters.
	-- For some reason the character key wasn't being given.

	timer.Simple(5, function()
		if IsValid(player) and character then
			local charactersTable = config.Get("mysql_characters_table"):Get();
			local key_found = false;
			
			local queryObj = Clockwork.database:Select(charactersTable)
				queryObj:Callback(function(result)
					for k, v in pairs(result) do
						if v._Key then
							if not character.data["Key"] then
								character.data["Key"] = v._Key;
								
								key_found = true;
							end
							
							if player:GetCharacterData("Key") and player:GetCharacterData("Key") ~= player:GetNetVar("Key") then 
								player:SetNetVar("Key", player:GetCharacterData("Key"));
							end
							
							break;
						end
					end
					
					if not key_found then
						-- Try again!!!!
						self:PlayerCharacterCreated(player, character);
					end
				end);
				
				queryObj:Where("_Name", character.name)
			queryObj:Execute()
		end
	end);
end

-- Called when a player's character has unloaded.
function GM:PlayerCharacterUnloaded(player)
	Clockwork.player:SetupRemovePropertyDelays(player)
	Clockwork.player:DisableProperty(player)
	Clockwork.player:SetRagdollState(player, RAGDOLL_RESET)
	Clockwork.storage:Close(player, true)
	player:SetTeam(TEAM_UNASSIGNED)
end

-- Called when a player's character has loaded.
function GM:PlayerCharacterLoaded(player)
	player:SetNetVar("InvWeight", config.Get("default_inv_weight"):Get())
	player:SetNetVar("InvSpace", config.Get("default_inv_space"):Get())
	player.cwCharLoadedTime = CurTime()
	player.cwCrouchedSpeed = config.Get("crouched_speed"):Get()
	player.cwInitialized = true
	--player.cwAttrBoosts = player.cwAttrBoosts or {}
	player.cwRagdollTab = player.cwRagdollTab or {}
	player.cwSpawnWeps = player.cwSpawnWeps or {}
	player.cwFirstSpawn = true
	player.cwLightSpawn = false
	player.cwChangeClass = false
	player.cwInfoTable = player.cwInfoTable or {}
	--player.cwSpawnAmmo = player.cwSpawnAmmo or {}
	player.cwJumpPower = config.Get("jump_power"):Get()
	player.cwWalkSpeed = config.Get("walk_speed"):Get()
	player.cwRunSpeed = config.Get("run_speed"):Get()
	
	if player.maxHealthBoost then
		player.maxHealthBoost = nil;
	end

	hook.Run("PlayerRestoreCharacterData", player, player:QueryCharacter("Data"))

	Clockwork.player:SetCharacterMenuState(player, CHARACTER_MENU_CLOSE)

	hook.Run("PlayerCharacterInitialized", player)

	Clockwork.player:RestoreRecognisedNames(player)
	Clockwork.player:ReturnProperty(player)
	Clockwork.player:SetInitialized(player, true)

	player.cwFirstSpawn = false
	
	player:SetNetVar("Faction", player:GetFaction());

	local charactersTable = config.Get("mysql_characters_table"):Get()
	local schemaFolder = Clockwork.kernel:GetSchemaFolder()
	local characterID = player:GetCharacterID()
	local onNextLoad = player:QueryCharacter("OnNextLoad")
	local steamID = player:SteamID()
	local query = "UPDATE "..charactersTable.." SET _OnNextLoad = \"\" WHERE"
	local playerFlags = player:GetPlayerFlags()

	if (onNextLoad != "") then
		local queryObj = Clockwork.database:Update(charactersTable)
			queryObj:Update("_OnNextLoad", "")
			queryObj:Where("_Schema", schemaFolder)
			queryObj:Where("_SteamID", steamID)
			queryObj:Where("_CharacterID", characterID)
		queryObj:Execute()

		player:SetCharacterData("OnNextLoad", "", true)

		CHARACTER = player:GetCharacter()
			PLAYER = player
				RunString(onNextLoad, md5.sumhexa(onNextLoad))
			PLAYER = nil
		CHARACTER = nil
	end

	if (playerFlags) then
		Clockwork.player:GiveFlags(player, playerFlags)
	end

	local className = player:GetCharacterData("Class")

	if (className) then
		local class = Clockwork.class:FindByID(className)

		Clockwork.class:Set(player, class.index, nil, true)
	end
	
	hook.Run("PostPlayerCharacterInitialized", player);
end

-- Called when a player's property should be restored.
function GM:PlayerReturnProperty(player) end

-- Called when config has initialized for a player.
function GM:PlayerConfigInitialized(player)
	hook.Run("PlayerSendDataStreamInfo", player)

	if (!player:IsBot()) then
		timer.Simple(FrameTime() * 32, function()
			if (IsValid(player)) then
				netstream.Start(player, "DataStreaming", true)
			end
		end)
	else
		hook.Run("PlayerDataStreamInfoSent", player)
	end
end

-- Called when a player's drop weapon info should be adjusted.
function GM:PlayerAdjustDropWeaponInfo(player, info)
	return true
end

-- Called when a player's character creation info should be adjusted.
function GM:PlayerAdjustCharacterCreationInfo(player, info, data) end

-- Called when a player's order item should be adjusted.
function GM:PlayerAdjustOrderItemTable(player, itemTable) end

-- Called when a player's next punch info should be adjusted.
function GM:PlayerAdjustNextPunchInfo(player, info) end

-- Called when a player uses an unknown item function.
function GM:PlayerUseUnknownItemFunction(player, itemTable, itemFunction) end

-- Called when a player's character table should be adjusted.
function GM:PlayerAdjustCharacterTable(player, character)
	-- Compatibility for new heads system.
	local model = character[Clockwork.kernel:SetCamelCase("Model", true)];

	if !string.find(model, "models/begotten/heads") then
		local _, findEnd = string.find(model, "male_");
		
		if findEnd then
			character[Clockwork.kernel:SetCamelCase("Model", true)] = "models/begotten/heads/male"..string.sub(model, findEnd, findEnd + 2).."_gore.mdl";
			return;
		end
			
		_, findEnd = string.find(model, "female_");

		if findEnd then
			character[Clockwork.kernel:SetCamelCase("Model", true)] = "models/begotten/heads/female"..string.sub(model, findEnd, findEnd + 2).."_gore.mdl";
			return;
		end
	end
end

-- Called when a player's character screen info should be adjusted.
function GM:PlayerAdjustCharacterScreenInfo(player, character, info)
	local playerRank, rank = player:GetFactionRank()

	if (rank and rank.model) then
		info.model = rank.model
	end
end

-- Called when a player's prop cost info should be adjusted.
function GM:PlayerAdjustPropCostInfo(player, entity, info) end

-- Called when a player's death info should be adjusted.
function GM:PlayerAdjustDeathInfo(player, info) end

-- Called when chat box info should be adjusted.
function GM:ChatBoxMessageAdded(info)
	if (info.class == "ic") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, info.speaker:Name().." says \""..info.text.."\"")
	--[[elseif (info.class == "yell") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, info.speaker:Name().." yells \""..info.text.."\"")
	elseif (info.class == "me") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, "*** "..info.speaker:Name().." "..info.text)]]
	elseif (info.class == "looc") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, "[LOOC] "..info.speaker:Name()..": "..info.text)
	end
end

-- Called when a player should gain a frag.
function GM:PlayerCanGainFrag(player, victim) return true end

function GM:PostPlayerCharacterInitialized(player)
	local maxHealth = player:GetMaxHealth();
	local health = player:GetCharacterData("Health")
	local armor = player:GetCharacterData("Armor")

	player:SetMaxHealth(maxHealth);
	
	if (health and health > 1) then
		player:SetHealth(health)
	else
		player:SetHealth(maxHealth);
	end

	if (armor and armor > 1) then
		player:SetArmor(armor)
	end
end

-- Called just after a player spawns.
function GM:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	local activeWeapon = player:GetActiveWeapon();
	
	if IsValid(activeWeapon) and activeWeapon:GetClass() == "begotten_fists" then
		if activeWeapon.OnDeploy then
			activeWeapon:OnDeploy();
		end
	end
	
	player:Fire("targetname", player:GetFaction(), 0)
end

-- Called just before a player would take damage.
function GM:PrePlayerTakeDamage(player, attacker, inflictor, damageInfo) end

-- Called when a player should take damage.
function GM:PlayerShouldTakeDamage(player, attacker, inflictor, damageInfo)
	if Clockwork.player:IsNoClipping(player) then
		return false;
	end
end

-- Called when a player is attacked by a trace.
function GM:PlayerTraceAttack(player, damageInfo, direction, trace)
	player.cwLastHitGroup = trace.HitGroup
	return false
end

-- Called just before a player dies.
function GM:DoPlayerDeath(player, attacker, damageInfo)
	Clockwork.player:SetAction(player, false)
	Clockwork.player:SetDrunk(player, false)

	local deathSound = hook.Run("PlayerPlayDeathSound", player, player:GetGender())
	local decayTime = config.Get("body_decay_time"):Get()

	if (decayTime > 0) then
		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, decayTime, Clockwork.kernel:ConvertForce(damageInfo:GetDamageForce() * 32))
	else
		Clockwork.player:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 600, Clockwork.kernel:ConvertForce(damageInfo:GetDamageForce() * 32))
	end

	if (hook.Run("PlayerCanDeathClearRecognisedNames", player, attacker, damageInfo)) then
		Clockwork.player:ClearRecognisedNames(player)
	end

	if (hook.Run("PlayerCanDeathClearName", player, attacker, damageInfo)) then
		Clockwork.player:ClearName(player)
	end

	if (deathSound) and !player.drowned then
		player:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1, 5)..".wav", 150)

		timer.Simple(FrameTime() * 25, function()
			if (IsValid(player)) then
				player:EmitSound(deathSound)
			end
		end)
	end

	player:SetForcedAnimation(false)
	player:Extinguish()
	player:AddDeaths(1)
	player:UnLock()
	
	-- Check if player is in a duel.
	if not player.opponent then
		--player:SetCharacterData("Ammo", {}, true)
		player:StripWeapons()
		--player.cwSpawnAmmo = {}
		player:StripAmmo()
	end

	if (IsValid(attacker) and attacker:IsPlayer() and player != attacker) then
		if (hook.Run("PlayerCanGainFrag", attacker, player)) then
			attacker:AddFrags(1)
		end
	end
	
	if (player.cwDeathPosition or player.cwDeathAngles) then
		player.cwDeathPosition = nil;
		player.cwDeathAngles = nil;
	end;
	
	player.cwDeathAngles = player:EyeAngles();
	player.cwDeathPosition = player:GetPos();
end

-- Called when a player dies.
function GM:PlayerDeath(player, inflictor, attacker, damageInfo)
	local ragdoll = player:GetRagdollEntity()

	if --[[!player.opponent and]] (ragdoll) then
		--local inventory = player:GetInventory();
		--local copy = Clockwork.inventory:CreateDuplicate(inventory);

		ragdoll.cwIsBelongings = true;
		--[[ragdoll.cwInventory = copy;
		ragdoll.cwCash = player:GetCash();

		for k,v in pairs(inventory) do
			for k2,v2 in pairs(v) do
				player:TakeItem(v2);
			end
		end
		
		player:SetCharacterData("Cash", 0, true);
		player:SetSharedVar("Cash", 0);]]--
		
		if (IsValid(inflictor) and inflictor:GetClass() == "prop_combine_ball") then
			if (damageInfo) then
				Clockwork.entity:Disintegrate(ragdoll, 3, damageInfo:GetDamageForce() * 32);
			else
				Clockwork.entity:Disintegrate(ragdoll, 3);
			end
		end
	end
	
	Clockwork.kernel:CalculateSpawnTime(player, inflictor, attacker, damageInfo);

	if IsValid(attacker) then
		if (attacker:IsPlayer() and damageInfo) then
			if (IsValid(attacker:GetActiveWeapon())) then
				local weapon = attacker:GetActiveWeapon()
				local itemTable = item.GetByWeapon(weapon)

				if (IsValid(weapon) and itemTable) then
					Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name().." with "..itemTable.name..", killing them!")
				else
					Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name().." with "..Clockwork.player:GetWeaponClass(attacker)..", killing them!")
				end
			else
				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name()..", killing them!")
			end
		else
			if (damageInfo) then
				Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, attacker:GetClass().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name()..", killing them!")
			end
		end
	end
end

function GM:PlayerSilentDeath(player)
	Clockwork.player:SetAction(player, false)
	Clockwork.player:SetDrunk(player, false)
end

-- Called when an item entity has taken damage.
function GM:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	return false
end

-- Called when an item entity has been destroyed.
function GM:ItemEntityDestroyed(itemEntity, itemTable) end

-- Called when a player's weapons should be given.
function GM:PlayerLoadout(player)
	--local weapons = Clockwork.class:Query(player:Team(), "weapons")
	--local ammo = Clockwork.class:Query(player:Team(), "ammo")

	player.cwSpawnWeps = {}
	--player.cwSpawnAmmo = {}

	if (Clockwork.player:HasFlags(player, "t")) then
		if !player:HasWeapon("gmod_tool") then
			Clockwork.player:GiveSpawnWeapon(player, "gmod_tool")
		end
	end

	if (Clockwork.player:HasFlags(player, "p")) then
		if !player:HasWeapon("weapon_physgun") then
			Clockwork.player:GiveSpawnWeapon(player, "weapon_physgun")
		end

		if (config.Get("custom_weapon_color"):Get()) then
			local weaponColor = player:GetInfo("cl_weaponcolor")

			player:SetWeaponColor(Vector(weaponColor))
		end
	end

	--Clockwork.player:GiveSpawnWeapon(player, "weapon_physcannon")

	if (config.Get("give_hands"):Get()) then
		if !player:HasWeapon("begotten_fists") then
			Clockwork.player:GiveSpawnWeapon(player, "begotten_fists")
		end
	end

	--[[if (config.Get("give_keys"):Get())  then
		if !player:HasWeapon("cw_keys") then
			Clockwork.player:GiveSpawnWeapon(player, "cw_keys")
		end
	end]]--

	--[[if (weapons) then
		for k, v in pairs(weapons) do
			if (!player:HasItemByID(v)) then
				local itemTable = item.CreateInstance(v)

				if (!Clockwork.player:GiveSpawnItemWeapon(player, itemTable)) then
					if !player:HasWeapon(v) then
						player:Give(v)
					end
				end
			end
		end
	end

	if (ammo) then
		for k, v in pairs(ammo) do
			Clockwork.player:GiveSpawnAmmo(player, k, v)
		end
	end]]--

	hook.Run("PlayerGiveWeapons", player)

	if (config.Get("give_hands"):Get()) then
		player:SelectWeapon("begotten_fists")
	end
end

-- Called when the server shuts down.
function GM:ShutDown()
	Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "Server shutting down!");
	
	--plugin.Call("PreSaveData")
	--plugin.Call("SaveData")
	--plugin.Call("PostSaveData")
	
	hook.Run("PreSaveData")
	hook.Run("SaveData")
	hook.Run("PostSaveData")
	
	Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "Data saved!");

	Clockwork.ShuttingDown = true
end

-- Called when a player presses F1.
function GM:ShowHelp(player)
	--netstream.Start(player, "InfoToggle", true)
	netstream.Start(player, "HotkeyMenu", true)
end

-- Called when a player presses F2.
function GM:ShowTeam(ply)
	if (!Clockwork.player:IsNoClipping(ply)) then
		local doRecogniseMenu = true
		local entity = ply:GetEyeTraceNoCursor().Entity

		if (IsValid(entity) and Clockwork.entity:IsDoor(entity)) then
			if (entity:GetPos():Distance(ply:GetShootPos()) <= 192) then
				if (hook.Run("PlayerCanViewDoor", ply, entity)) then
					if (hook.Run("PlayerUse", ply, entity)) then
						local owner = Clockwork.entity:GetOwner(entity)

						if (IsValid(owner)) then
							if (Clockwork.player:HasDoorAccess(ply, entity, DOOR_ACCESS_COMPLETE)) then
								local data = {
									sharedAccess = Clockwork.entity:DoorHasSharedAccess(entity),
									sharedText = Clockwork.entity:DoorHasSharedText(entity),
									unsellable = Clockwork.entity:IsDoorUnsellable(entity),
									accessList = {},
									isParent = Clockwork.entity:IsDoorParent(entity),
									entity = entity,
									owner = owner
								}
								
								--changed here
								local players = _player.GetAll();
								
								for k, v in pairs(players) do
									if (v != ply and v != owner) then
										if (Clockwork.player:HasDoorAccess(v, entity, DOOR_ACCESS_COMPLETE)) then
											data.accessList[v] = DOOR_ACCESS_COMPLETE
										elseif (Clockwork.player:HasDoorAccess(v, entity, DOOR_ACCESS_BASIC)) then
											data.accessList[v] = DOOR_ACCESS_BASIC
										end
									end
								end

								netstream.Start(ply, "DoorManagement", data)
							end
						else
							netstream.Start(ply, "PurchaseDoor", entity)
						end
					end
				end

				doRecogniseMenu = false
			end
		end

		if (config.Get("recognise_system"):Get()) then
			if (doRecogniseMenu) then
				netstream.Start(ply, "RecogniseMenu", true)
			end
		end
	end
end

-- Called when a player selects a custom character option.
function GM:PlayerSelectCustomCharacterOption(player, action, character) end

-- Called when a player takes damage.
function GM:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo) end

-- A function to calculate player damage.
function GM:PreCalculatePlayerDamage(player, hitGroup, damageInfo)
	--[[local bDamageIsValid = damageInfo:IsBulletDamage() or damageInfo:IsDamageType(DMG_CLUB) or damageInfo:IsDamageType(DMG_SLASH)
	local bHitGroupIsValid = true

	if (config.GetVal("armor_chest_only")) then
		if (hitGroup != HITGROUP_CHEST and hitGroup != HITGROUP_GENERIC) then
			bHitGroupIsValid = nil
		end
	end

	if (player:Armor() > 0 and bDamageIsValid and bHitGroupIsValid) then
		local armor = player:Armor() - damageInfo:GetDamage()

		if (armor < 0) then
			player:SetHealth(math.max(player:Health() - math.abs(armor), 1))
			player:SetArmor(math.max(armor, 0))
		else
			player:SetArmor(math.max(armor, 0))
		end
	else]]--
		player:SetHealth(math.max(player:Health() - damageInfo:GetDamage(), 1))
	--end
end

-- Called when an entity takes damage.
function GM:EntityTakeDamage(entity, damageInfo)
	local class = entity:GetClass();
	
	if class == "prop_dynamic" or class == "cw_duelstatue" or class == "cw_hellportal" then
		return true;
	elseif entity.cwInventory then
		return true;
	end
	
	if (entity:IsPlayer() and damageInfo:IsExplosionDamage() and !entity:IsRagdolled() and !entity:IsNoClipping()) then
		if !Clockwork.player:HasFlags(entity, "E") and !Clockwork.player:HasFlags(entity, "K") then
			if !cwBeliefs or (cwBeliefs and !entity:HasBelief("fortitude_finisher")) then
				local data = {}
					data.start = damageInfo:GetDamagePosition()
					data.endpos = entity:GetPos()
				local trace = util.TraceLine(data)

				Clockwork.player:SetRagdollState(entity, RAGDOLL_FALLENOVER, nil, nil, nil, nil, function(physicsObject, boneIndex, ragdoll, velocity, force)
					physicsObject:SetVelocity(trace.Normal * damageInfo:GetReportedPosition())
				end)
				
				entity:SetDTBool(BOOL_FALLENOVER, true)
				entity:SetDSP(36, false)
			end
		end
	end
	
	if (damageInfo:IsDamageType(DMG_CRUSH) and damageInfo:GetDamage() < 10) then
		damageInfo:SetDamage(0)
	end
	
	if (Clockwork.kernel:DoEntityTakeDamageHook(entity, damageInfo)) then
		return;
	end
	
	if (damageInfo:GetDamage() == 0) then
		return true;
	end

	local inflictor = damageInfo:GetInflictor()
	local attacker = damageInfo:GetAttacker()
	local amount = damageInfo:GetDamage()

	if (config.Get("prop_kill_protection"):Get()) then
		local curTime = CurTime()

		if ((IsValid(inflictor) and inflictor.cwDamageImmunity and inflictor.cwDamageImmunity > curTime and !inflictor:IsVehicle())
		or (IsValid(attacker) and attacker.cwDamageImmunity and attacker.cwDamageImmunity > curTime)) then
			entity.cwDamageImmunity = curTime + 1

			damageInfo:SetDamage(0)
			return false
		end

		if (IsValid(attacker) and attacker:GetClass() == "worldspawn"
		and entity.cwDamageImmunity and entity.cwDamageImmunity > curTime) then
			damageInfo:SetDamage(0)
			return false
		end

		if ((IsValid(inflictor) and inflictor:IsBeingHeld())
		or attacker:IsBeingHeld()) then
			damageInfo:SetDamage(0)
			return false
		end
	end

	if (entity:IsPlayer() and entity:InVehicle() and !IsValid(entity:GetVehicle():GetParent())) then
		entity.cwLastHitGroup = Clockwork.kernel:GetRagdollHitBone(entity, damageInfo:GetDamagePosition(), HITGROUP_GEAR)

		if (damageInfo:IsBulletDamage()) then
			if ((attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) and attacker != player) then
				damageInfo:ScaleDamage(10000)
			end
		end
	end
	
	local isPlayerRagdoll = Clockwork.entity:IsPlayerRagdoll(entity);
	local player = Clockwork.entity:GetPlayer(entity);
	local lastHitGroup;

	if (player and (entity:IsPlayer() or isPlayerRagdoll)) then
		--if (damageInfo:IsFallDamage() or config.Get("damage_view_punch"):Get()) then
			player:ViewPunch(
				Angle(math.random(amount, amount), math.random(amount, amount), math.random(amount, amount))
			)
		--end

		if (!isPlayerRagdoll) then
			local lastHitGroup = player:LastHitGroup()
			
			if IsValid(attacker) and attacker:IsPlayer() then
				local activeWeapon = attacker:GetActiveWeapon();
				
				if IsValid(activeWeapon) and activeWeapon.Base == "sword_swepbase" then
					lastHitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
				end
			end

			if (player:InVehicle() and damageInfo:IsExplosionDamage()) then
				if (!damageInfo:GetDamage() or damageInfo:GetDamage() == 0) then
					damageInfo:SetDamage(player:GetMaxHealth())
				end
			end

			--self:ScaleDamageByHitGroup(player, attacker, lastHitGroup, damageInfo, amount)

			if (damageInfo:GetDamage() > 0) then
				--hook.Run("CalculatePlayerDamage", player, lastHitGroup, damageInfo);
				player:SetVelocity(Clockwork.kernel:ConvertForce(damageInfo:GetDamageForce() * 32, 200))

				if (player:Alive() and player:Health() == 1) then
					player:SetFakingDeath(true)
						hook.Run("DoPlayerDeath", player, attacker, damageInfo)
						hook.Run("PlayerDeath", player, inflictor, attacker, damageInfo)
					player:SetFakingDeath(false, true)
				else
					local bNoMsg = hook.Run("PlayerTakeDamage", player, inflictor, attacker, lastHitGroup, damageInfo)
					local sound = hook.Run("PlayerPlayPainSound", player, player:GetGender(), damageInfo, lastHitGroup)

					if (sound and !bNoMsg) then
						player:EmitHitSound(sound)
					end

					local armor = "!"

					if (player:Armor() > 0) then
						armor = " and "..player:Armor().." armor!"
					end

					if IsValid(attacker) then
						if (attacker:IsPlayer()) then
							Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:Name().." with "..Clockwork.player:GetWeaponClass(attacker, "an unknown weapon")..", leaving them at "..player:Health().." health"..armor)
						else
							Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:GetClass()..", leaving them at "..player:Health().." health"..armor)
						end
					else
						Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from an unknown source, leaving them at "..player:Health().." health"..armor)
					end
				end
			end

			damageInfo:SetDamage(0)
			player.cwLastHitGroup = nil
		elseif !entity.cwIsBelongings then
			local hitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition())
			local curTime = CurTime()

			--self:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, amount)

			if (hook.Run("PlayerRagdollCanTakeDamage", player, entity, inflictor, attacker, hitGroup, damageInfo) and damageInfo:GetDamage() > 0) then
				local bAttackerValid = IsValid(attacker);
				
				if !bAttackerValid or (!attacker:IsPlayer()) then
					if (bAttackerValid and (attacker:GetClass() == "prop_ragdoll" or Clockwork.entity:IsDoor(attacker))) then
						return
					end
				end

				--hook.Run("CalculatePlayerDamage", player, hitGroup, damageInfo);

				if (player:Alive() and player:Health() == 1) then
					player:SetFakingDeath(true)
						player:GetRagdollTable().health = 0
						player:GetRagdollTable().armor = 0

						hook.Run("DoPlayerDeath", player, attacker, damageInfo)
						hook.Run("PlayerDeath", player, inflictor, attacker, damageInfo)
					player:SetFakingDeath(false, true)
				elseif (player:Alive()) then
					local bNoMsg = hook.Run("PlayerTakeDamage", player, inflictor, attacker, hitGroup, damageInfo)
					local sound = hook.Run("PlayerPlayPainSound", player, player:GetGender(), damageInfo, hitGroup)
					
					if (sound and !bNoMsg) then
						entity:EmitHitSound(sound)
					end

					local armor = "!"

					if (player:Armor() > 0) then
						armor = " and "..player:Armor().." armor!"
					end

					if IsValid(attacker) then
						if (attacker:IsPlayer()) then
							Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:Name().." with "..Clockwork.player:GetWeaponClass(attacker, "an unknown weapon")..", leaving them at "..player:Health().." health"..armor)
						else
							Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:GetClass()..", leaving them at "..player:Health().." health"..armor)
						end
					else
						Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from an unknown source, leaving them at "..player:Health().." health"..armor)
					end
				end
			end

			damageInfo:SetDamage(0)
			player.cwLastHitGroup = nil
		end
	elseif (entity:GetClass() == "prop_ragdoll") then
		if (IsValid(inflictor) and inflictor:GetClass() == "prop_combine_ball") then
			if (!entity.disintegrating) then
				Clockwork.entity:Disintegrate(entity, 3, damageInfo:GetDamageForce())

				entity.disintegrating = true
			end
		end
	end
end

-- Called when the death sound for a player should be played.
function GM:PlayerDeathSound(player) return true end

-- Called when a player attempts to spawn a SWEP.
function GM:PlayerSpawnSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false
	else
		return true
	end
end

-- Called when a player is given a SWEP.
function GM:PlayerGiveSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false
	else
		return true
	end
end

-- Called when attempts to spawn a SENT.
function GM:PlayerSpawnSENT(player, class)
	if (!player:IsSuperAdmin()) then
		return false
	else
		return true
	end
end

local wite = (192 * 192)

-- Called when a player presses a key.
function GM:KeyPress(player, key)
	if (key == IN_USE) then
		local trace = player:GetEyeTraceNoCursor()

		if (IsValid(trace.Entity) and trace.HitPos:DistToSqr(player:GetShootPos()) <= wite) then
			--if (hook.Run("PlayerUse", player, trace.Entity)) then

			--end
		end
	elseif (key == IN_WALK) then
		local velocity = player:GetVelocity():Length()

		if (velocity == 0 and player:KeyDown(IN_SPEED)) then
			if (player:Crouching()) then
				player:RunCommand("-duck")
			else
				player:RunCommand("+duck")
			end
		end
	elseif (key == IN_ATTACK) then
		local action = Clockwork.player:GetAction(player);
		
		if (action == "putting_on_armor" or action == "taking_off_armor") then
			Clockwork.player:SetAction(player, nil);
		end
	end
end

--[[
	@codebase Server
	@details Called when a player presses a button down.
	@param Player The player that is pressing a button.
	@param Enum The button that was pressed.
--]]
function GM:PlayerButtonDown(player, button)
	if (button == KEY_B) then
		if (config.Get("quick_raise_enabled"):GetBoolean()) then
			if (hook.Run("PlayerCanQuickRaise", player, player:GetActiveWeapon())) then
				Clockwork.player:ToggleWeaponRaised(player)
			end
		end
	end

	return self.BaseClass:PlayerButtonDown(player, button)
end

--[[
	@codebase Server
	@details Called to determine whether or not a player can quickly raise their weapon by pressing the x button.
	@param Player The player that is attempting to quickly raise their weapon.
	@param Weapon The player's current active weapon.
--]]
function GM:PlayerCanQuickRaise(player, weapon) return true end

-- Called when a player releases a key.
function GM:KeyRelease(player, key) end

-- A function to setup a player's visibility.
function GM:SetupPlayerVisibility(player)
	local ragdollEntity = player:GetRagdollEntity()

	if (ragdollEntity) then
		AddOriginToPVS(ragdollEntity:GetPos())
	end
end

-- Called after a player has spawned an NPC.
function GM:PlayerSpawnedNPC(player, npc)
	local faction
	local relation

	prevRelation = prevRelation or {}
	prevRelation[player:SteamID()] = prevRelation[player:SteamID()] or {}

	for k, v in ipairs(_player.GetAll()) do
		faction = Clockwork.faction:FindByID(v:GetFaction())

		if (faction) then
			relation = faction.entRelationship
		end

		if (istable(relation)) then
			for k2, v2 in pairs(relation) do
				if (k2 == npc:GetClass()) then
					if (string.lower(v2) == "like") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v)
						npc:AddEntityRelationship(v, D_LI, 1)
					elseif (string.lower(v2) == "fear") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v)
						npc:AddEntityRelationship(v, D_FR, 1)
					elseif (string.lower(v2) == "hate") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v)
						npc:AddEntityRelationship(v, D_HT, 1)
					else
						ErrorNoHalt("Attempting to add relationship using invalid relation '"..v2.."' towards faction '"..faction.name.."'.\r\n")
					end
				end
			end
		end
	end
end

--[[
	@codebase Server
	@details Called when an attribute is progressed to edit the amount it is progressed by.
	@param Player The player that has progressed the attribute.
	@param Table The attribute table of the attribute being progressed.
	@param Number The amount that is being progressed for editing purposes.
--]]
function GM:OnAttributeProgress(player, attribute, amount)
	amount = amount * config.Get("scale_attribute_progress"):Get()
end

--[[
	@codebase Server
	@details Called to add ammo types to be checked for and saved.
	@param Table The table filled with the current ammo types.
--]]
function GM:AdjustAmmoTypes(ammoTable)
	ammoTable["sniperpenetratedround"] = true
	ammoTable["striderminigun"] = true
	ammoTable["helicoptergun"] = true
	ammoTable["combinecannon"] = true
	ammoTable["smg1_grenade"] = true
	ammoTable["gaussenergy"] = true
	ammoTable["sniperround"] = true
	ammoTable["ar2altfire"] = true
	ammoTable["rpg_round"] = true
	ammoTable["xbowbolt"] = true
	ammoTable["buckshot"] = true
	ammoTable["alyxgun"] = true
	ammoTable["grenade"] = true
	ammoTable["thumper"] = true
	ammoTable["gravity"] = true
	ammoTable["battery"] = true
	ammoTable["pistol"] = true
	ammoTable["slam"] = true
	ammoTable["smg1"] = true
	ammoTable["357"] = true
	ammoTable["ar2"] = true
end

--[[
	@codebase Server
	@details Called after a player uses a command.
	@param Player The player that used the commmand.
	@param Table The table of the command that is being used.
	@param Table The arguments that have been given with the command, if any.
--]]
function GM:PostCommandUsed(player, command, arguments) end
local massiveFuck = (300 * 300)
-- A function to scale damage by hit group.
function GM:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	if (!damageInfo:IsFallDamage() and !damageInfo:IsDamageType(DMG_CRUSH) and damageInfo:GetDamage() > 5) then
		if (hitGroup == HITGROUP_HEAD) then
			if player:Alive() then
				player:SetDSP(35, false)
				player:ViewPunch(AngleRand())
			end
			
			if IsValid(attacker) and attacker:IsPlayer() then
				local attackerWeapon = attacker:GetActiveWeapon();
				
				if IsValid(attackerWeapon) and attackerWeapon.Base == "begotten_firearm_base" then
					if (player:GetPos():DistToSqr(attacker:GetPos()) <= massiveFuck) then
						damageInfo:ScaleDamage(config.Get("scale_head_dmg"):Get());
					end
				end
			end
		elseif IsValid(attacker) and attacker:IsPlayer() then
			local attackerWeapon = attacker:GetActiveWeapon();
			
			if IsValid(attackerWeapon) and attackerWeapon.Base == "begotten_firearm_base" then
				if (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
					damageInfo:ScaleDamage(config.Get("scale_chest_dmg"):Get());
				elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM or hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_GEAR) then
					damageInfo:ScaleDamage(config.Get("scale_limb_dmg"):Get());
				end
			end
		end
	end

	hook.Run("PlayerScaleDamageByHitGroup", player, attacker, hitGroup, damageInfo, baseDamage)
end

-- Called when a player cancels their attempt to get up.
function GM:PlayerCancelGetUp(player)
	if (player:Alive()) then
		local curTime = CurTime();
		
		if (!player.NextCancelMessage or player.NextCancelMessage < curTime) then
			player.NextCancelMessage = curTime + 3;
			
			local performs = {
				["restrained"] = {
					"is subdued and ceases #HIS attempt to get up.",
					"is pinned and stops moving.",
					"is held down.",
					"is held down and ceases moving.",
					"struggles as #HE cannot get up.",
				},
				["unrestrained"] = {
					"stops moving.",
					"lies still.",
					"falls back on the ground.",
					"ceases #HIS attempts to get up.",
				},
			};
			
			local gender = player:GetGender();
			local he, his = "he", "his";
				if (gender == GENDER_FEMALE) then
					he = "she"; his = "her";
				end;
			local restrained = (player:GetNetVar("IsDragged") and "restrained") or "unrestrained";
			local perform = string.gsub(string.gsub(table.Random(performs[restrained]), "#HIS", his), "#HE", he);
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(perform, "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		end;
	end;
end;

-- Called when a player starts getting up.
function GM:PlayerStartGetUp(player)
	if (player:Alive()) then
		local curTime = CurTime();
		
		if (!player.NextGetUpMessage or player.NextGetUpMessage < curTime) then
			player.NextGetUpMessage = curTime + 3;
			
			local performs = {
				["restrained"] = {
					"is subdued and ceases #HIS attempt to get up.",
					"struggles as #HE cannot get up.",
				},
				["unrestrained"] = {
					"begins to get back on #HIS feet.",
					"starts to push #HIMSELF up onto #HIS feet.",
					"starts to get up.",
					"struggles to get up.",
				},
			};
			
			local gender = player:GetGender();
			local he, his, himself = "he", "his", "himself";
				if (gender == GENDER_FEMALE) then
					he = "she"; his = "her"; himself = "herself";
				end;
			local restrained = (player:GetNetVar("IsDragged") and "restrained") or "unrestrained";
			local perform = string.gsub(string.gsub(string.gsub(table.Random(performs[restrained]), "#HIMSELF", himself), "#HIS", his), "#HE", he);
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(perform, "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		end;
	end;
end;

function GM:PlayerCanKnockOnDoor(player, door)
	return true;
end;

function GM:PlayerKnockOnDoor(player, door) end;

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)

end

function GM:RunModifyPlayerSpeed(player, infoTable, bIgnoreDelay)
	if !infoTable then return end;

	local curTime = CurTime();

	if bIgnoreDelay or !player.speedSetCooldown or player.speedSetCooldown < curTime then
		local action = Clockwork.player:GetAction(player);
	
		infoTable.walkSpeed = config.GetVal("walk_speed");
		infoTable.crouchedWalkSpeed = config.GetVal("crouched_speed");
		infoTable.jumpPower = config.GetVal("jump_power");
		infoTable.runSpeed = config.GetVal("run_speed");

		hook.Run("ModifyPlayerSpeed", player, infoTable, action);
		
		player:SetWalkSpeed(math.max(infoTable.walkSpeed, 1));
		player:SetCrouchedWalkSpeed(math.max(infoTable.crouchedWalkSpeed, 1));
		player:SetJumpPower(math.max(infoTable.jumpPower, 1));
		
		if (player:KeyDown(IN_BACK)) then
			player:SetRunSpeed(infoTable.walkSpeed);
		else
			player:SetRunSpeed(infoTable.runSpeed);
		end;
		
		player.speedSetCooldown = curTime + 1;
	end;
end