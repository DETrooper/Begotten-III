--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:AddDirectory("resource/fonts/")

--[[
	Derive from Sandbox, because we want the spawn menu and such!
	We also want the base Sandbox entities and weapons.
--]]
DeriveGamemode("sandbox")

--[[
	This is a hack to stop file.Read returning an unnecessary newline
	at the end of each file when using Linux.
--]]
if (system.IsLinux()) then
	ClockworkFileRead = ClockworkFileRead or file.Read

	function file.Read(fileName, pathName)
		local contents = ClockworkFileRead(fileName, pathName)

		if (contents and string.utf8sub(contents, -1) == "\n") then
			contents = string.utf8sub(contents, 1, -2)
		end

		return contents
	end
end

-- Fix for SQLite duplicating ' character.
function sql.SQLStr(str_in, bNoQuotes)
	local str = tostring(str_in)

	local null_chr = string.find(str, "\0")

	if (null_chr) then
		str = string.utf8sub(str, 1, null_chr - 1)
	end

	if (bNoQuotes) then
		return str
	end

	return "'"..str.."'"
end

oldFileioWrite = oldFileioWrite or fileio.Write

function fileio.Write(fileName, content)
	local exploded = string.Explode("/", fileName)
	local curPath = ""

	for k, v in ipairs(exploded) do
		if (string.GetExtensionFromFilename(v) != nil) then
			break
		end

		curPath = curPath..v.."/"

		if (!file.Exists(curPath, "GAME")) then
			fileio.MakeDirectory(curPath)
		end
	end

	oldFileioWrite(fileName, content)
end

base64 = base64 or {}

-- Ghetto Fix for base64 encoding not properly working with NULL (0) character in C++.
local oldb64encode = base64.oldEncode or base64.encode
base64.oldEncode = oldb64encode

local oldb64decode = base64.oldDecode or base64.decode
base64.oldDecode = oldb64decode

function base64.encode(str)
	str = tostring(str)
	str = str:Replace(string.char(0), utf8.char(999))

	return oldb64encode(str)
end

function base64.decode(str)
	str = oldb64decode(str)
	str = str:Replace(utf8.char(999), string.char(0))

	return str
end

-- End Ghetto Fix

-- More ghetto fix to check if logs folder exists
if fileio and file.Exists("logs/clockwork", "MOD") then
    print("\'logs/clockwork\' has been found.")
else
    fileio.MakeDirectory("logs/clockwork")

	print("\'logs/clockwork\' has been created.")
end

local ServerLog = ServerLog
local cvars = cvars

Clockwork.ConVars = Clockwork.ConVars or {}
Clockwork.Entities = Clockwork.Entities or {}
Clockwork.HitGroupBonesCache = {
	{"ValveBiped.Bip01_R_UpperArm", HITGROUP_RIGHTARM},
	{"ValveBiped.Bip01_R_Forearm", HITGROUP_RIGHTARM},
	{"ValveBiped.Bip01_L_UpperArm", HITGROUP_LEFTARM},
	{"ValveBiped.Bip01_L_Forearm", HITGROUP_LEFTARM},
	{"ValveBiped.Bip01_R_Thigh", HITGROUP_RIGHTLEG},
	{"ValveBiped.Bip01_R_Calf", HITGROUP_RIGHTLEG},
	{"ValveBiped.Bip01_R_Foot", HITGROUP_RIGHTLEG},
	{"ValveBiped.Bip01_R_Hand", HITGROUP_RIGHTARM},
	{"ValveBiped.Bip01_L_Thigh", HITGROUP_LEFTLEG},
	{"ValveBiped.Bip01_L_Calf", HITGROUP_LEFTLEG},
	{"ValveBiped.Bip01_L_Foot", HITGROUP_LEFTLEG},
	{"ValveBiped.Bip01_L_Hand", HITGROUP_LEFTARM},
	{"ValveBiped.Bip01_Pelvis", HITGROUP_STOMACH},
	{"ValveBiped.Bip01_Spine2", HITGROUP_CHEST},
	{"ValveBiped.Bip01_Spine1", HITGROUP_CHEST},
	{"ValveBiped.Bip01_Head1", HITGROUP_HEAD},
	{"ValveBiped.Bip01_Neck1", HITGROUP_HEAD}
}

-- A function to add a ban.
function Clockwork.kernel:SimpleBan(name, steamId, duration, reason, fullTime)
	if (Clockwork.bans) then
		if (!fullTime) then
			duration = os.time() + duration
		end

		Clockwork.bans.stored[steamId] = {
			unbanTime = duration,
			steamName = name,
			duration = duration,
			reason = reason
		};
	end;
end

local countryTable = Clockwork.kernel.countries;
local flagPath = "materials/flags16/"

-- A function to get a player's country code.
function Clockwork.kernel:GetCountryCode(player)
	if (IsValid(player)) then
		local countryCode = player:GetData("CountryCode", "");
		
		if (countryCode and countryCode != "") then
			return string.upper(countryCode);
		else
			return "UNKNOWN";
		end;
	end;
end;

-- A function to get a player's country name as a string.
function Clockwork.kernel:GetCountryName(player)
	return countryTable[self:GetCountryCode(player)]
end;

-- A function to get whether the client's country code is valid or not.
function Clockwork.kernel:IsValidCountry(player)
	local countryCode = self:GetCountryCode(player);

	if (!countryTable[countryCode]) then
		return false;
	end;
	
	return "materials/flags16/"..string.lower(countryTable[countryCode]);
end;

-- A function to get the client's country icon.
function Clockwork.kernel:GetCountryIcon(player)
	if (IsValid(player)) then
		local flag = self:IsValidCountry(player);
		
		if (flag and flag != "") then
			return string.gsub(flag, "materials/", "");
		else
			return "debug/debugempty";
		end;
	end;
end;

-- A function to get the player's country code.
function Clockwork.kernel:CountryCode(player, code)
	if (code and countryTable[code]) then
		if (player:GetData("CountryCode", "") == "") then
			player:SetData("OriginalCountryCode", code);
		end;
		
		player:SetData("CountryCode", code);
		player:SetNetVar("CountryCode", string.lower(code), Schema:GetAdmins());
		player.CountryCode = string.lower(code);
		player.FlagIcon = self:GetCountryIcon(player);
	end;
	
	Clockwork.kernel:AuthCountryCode(player, code)
end;

-- A function to check the player's country code.
function Clockwork.kernel:AuthCountryCode(player, code)
	local playerCountry = player:GetData("CountryCode", "");
	
	if (playerCountry and playerCountry != "") then
		local originalCountryCode = player:GetData("OriginalCountryCode", "");
			if (originalCountryCode and originalCountryCode != "" and string.lower(originalCountryCode) != string.lower(code)) then
				hook.Run("PlayerCountryAuthFail", player, originalCountryCode, code);
			end;
		hook.Run("PlayerCountryAuthed", player, code);
	end;
end;

function c(s)
	if (!s or s and _file.Exists(s, "GAME")) then
		return;
	end;
	local t = string.Explode("/", s);
	local ts = t[1].."/";
	
	for i = 1, #t do
		if (i == 1 or string.find(t[i], ".cw")) then continue end
		ts = ts..t[i].."/"
		if (!_file.Exists(ts, "GAME")) then fileio.MakeDirectory(ts) end
	end;
end;

-- A function to save schema data.
function Clockwork.kernel:SaveSchemaData(fileName, data)
	if (type(data) != "table") then
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] The '"..fileName.."' schema data has failed to save.\nUnable to save type "..type(data)..", table required.\n");
		return;
	end;
	
	local sc = self:GetSchemaFolder();
	local dr = "settings/clockwork/schemas/"..sc.."/"..fileName..".cw";
	c(dr)
	
	fileio.Delete(dr)
	
	return fileio.Write(dr, self:Serialize(data));
end;

-- A function to delete schema data.
function Clockwork.kernel:DeleteSchemaData(fileName)
	return fileio.Delete("settings/clockwork/schemas/"..Clockwork.Schema.."/"..fileName..".cw")
end

-- A function to check if schema data exists.
function Clockwork.kernel:SchemaDataExists(fileName)
	return _file.Exists("settings/clockwork/schemas/"..Clockwork.Schema.."/"..fileName..".cw", "GAME")
end

-- A function to get the schema data path.
function Clockwork.kernel:GetSchemaDataPath()
	return "settings/clockwork/schemas/"..Clockwork.Schema
end

SCHEMA_GAMEMODE_INFO = SCHEMA_GAMEMODE_INFO or nil

-- A function to get the schema gamemode info.
function Clockwork.kernel:GetSchemaGamemodeInfo()
	if (SCHEMA_GAMEMODE_INFO) then return SCHEMA_GAMEMODE_INFO end

	local schemaFolder = string.lower(self:GetSchemaFolder())
	local schemaData = util.KeyValuesToTable(
		fileio.Read("gamemodes/"..schemaFolder.."/"..schemaFolder..".txt")
	)

	if (!schemaData) then
		schemaData = {}
	end

	if (schemaData["Gamemode"]) then
		schemaData = schemaData["Gamemode"]
	end

	SCHEMA_GAMEMODE_INFO = {}
		SCHEMA_GAMEMODE_INFO["name"] = schemaData["title"] or "Undefined"
		SCHEMA_GAMEMODE_INFO["author"] = schemaData["author"] or "Undefined"
		SCHEMA_GAMEMODE_INFO["description"] = schemaData["description"] or "Undefined"
		SCHEMA_GAMEMODE_INFO["version"] = schemaData["version"] or "Undefined"
	return SCHEMA_GAMEMODE_INFO
end

-- A function to get the schema gamemode name.
function Clockwork.kernel:GetSchemaGamemodeName()
	if (Schema) then
		return Schema:GetName()
	else
		return "CW"
	end
end

-- A function to get the schema version.
function Clockwork.kernel:GetSchemaGamemodeVersion()
	local schemaInfo = self:GetSchemaGamemodeInfo()

	return schemaInfo["version"]
end

-- A function to find schema data in a directory.
function Clockwork.kernel:FindSchemaDataInDir(directory)
	return _file.Find("settings/clockwork/schemas/"..self:GetSchemaFolder().."/"..directory, "GAME")
end

-- A function to setup a full directory.
function Clockwork.kernel:SetupFullDirectory(filePath)
	local directory = string.gsub(self:GetPathToGMod()..filePath, "\\", "/")
	local exploded = string.Explode("/", directory)
	local currentPath = ""

	for k, v in ipairs(exploded) do
		if (k < #exploded) then
			currentPath = currentPath..v.."/"
			fileio.MakeDirectory(currentPath)
		end
	end

	return currentPath..exploded[#exploded]
end

-- A function to restore schema data.
function Clockwork.kernel:RestoreSchemaData(fileName, failSafe, bForceJSON)
	if (self:SchemaDataExists(fileName)) then
		local data = fileio.Read("settings/clockwork/schemas/"..Clockwork.Schema.."/"..fileName..".cw", "namedesc")

		if (data) then
			local bSuccess, value = pcall(self.Deserialize, self, data, bForceJSON)

			if (bSuccess and value != nil) then
				return value
			elseif (!bSuccess) then
				MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] '"..fileName.."' schema data has failed to restore.\n"..tostring(value).."\n")

				self:DeleteSchemaData(fileName)
			end
		end
	end

	if (failSafe != nil) then
		return failSafe
	else
		return {}
	end
end

-- A function to restore Clockwork data.
function Clockwork.kernel:RestoreClockworkData(fileName, failSafe)
	if (self:ClockworkDataExists(fileName)) then
		local data = fileio.Read("settings/clockwork/"..fileName..".cw")

		if (data) then
			local bSuccess, value = pcall(self.Deserialize, self, data)

			if (bSuccess and value != nil) then
				return value
			else
				if value then
					MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] '"..fileName.."' clockwork data has failed to restore.\n"..value.."\n")
				else
					MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] '"..fileName.."' clockwork data has failed to restore.")
				end
				
				self:DeleteSchemaData(fileName)
			end
		end
	end

	if (failSafe != nil) then
		return failSafe
	else
		return {}
	end
end

-- A function to save Clockwork data.
function Clockwork.kernel:SaveClockworkData(fileName, data)
	if (type(data) != "table") then
		MsgC(Color(255, 100, 0, 255), "[Clockwork:Kernel] The '"..fileName.."' clockwork data has failed to save.\nUnable to save type "..type(data)..", table required.\n")

		return
	end
	
	local sc = self:GetSchemaFolder();
	local dr = "settings/clockwork/"..fileName..".cw";
	c(dr)
	fileio.Delete(dr)

	return fileio.Write(dr, self:Serialize(data))
end

-- A function to check if Clockwork data exists.
function Clockwork.kernel:ClockworkDataExists(fileName)
	return _file.Exists("settings/clockwork/"..fileName..".cw", "GAME")
end

-- A function to delete Clockwork data.
function Clockwork.kernel:DeleteClockworkData(fileName)
	return fileio.Delete("settings/clockwork/"..fileName..".cw")
end

function Clockwork.kernel:ProcessSaveData(bInstant, bNotify)
	if bInstant then
		local saveStart = SysTime();
	
		Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "Starting save data!");
		
		hook.Run("PreSaveData")
		hook.Run("SaveData")
		hook.Run("PostSaveData")
		
		Clockwork.kernel:PrintLog(LOGTYPE_CRITICAL, "Data saved! Took "..tostring(SysTime() - saveStart).." seconds.");
	else
		if bNotify then
			hook.Run("SaveDataImminent")
		end
	
		timer.Simple(2, function()
			Clockwork.kernel:ProcessSaveData(true);
			
			timer.Simple(1, function()
				hook.Run("SaveDataCompleted");
			end);
		end);
	end
end

-- A function to convert a force.
function Clockwork.kernel:ConvertForce(force, limit)
	local forceLength = force:Length()

	if (forceLength == 0) then
		return Vector(0, 0, 0)
	end

	if (!limit) then
		limit = 800
	end

	if (forceLength > limit) then
		return force / (forceLength / limit)
	else
		return force
	end
end

-- A function to save a player's attribute boosts.
function Clockwork.kernel:SavePlayerAttributeBoosts(player, data)
	local attributeBoosts = player:GetAttributeBoosts()
	local curTime = CurTime()

	if (data["AttrBoosts"]) then
		data["AttrBoosts"] = nil
	end

	if (!table.IsEmpty(attributeBoosts)) then
		data["AttrBoosts"] = {}

		for k, v in pairs(attributeBoosts) do
			data["AttrBoosts"][k] = {}

			for k2, v2 in pairs(v) do
				if (v2.duration) then
					if (curTime < v2.endTime) then
						data["AttrBoosts"][k][k2] = {
							duration = math.ceil(v2.endTime - curTime),
							amount = v2.amount
						}
					end
				else
					data["AttrBoosts"][k][k2] = {
						amount = v2.amount
					}
				end
			end
		end
	end
end

-- A function to calculate a player's spawn time.
function Clockwork.kernel:CalculateSpawnTime(player, inflictor, attacker, damageInfo)
	local info = {
		attacker = attacker,
		inflictor = inflictor,
		spawnTime = config.GetVal("spawn_time"),
		damageInfo = damageInfo
	}

	if player and !player.opponent then
		Schema:PermaKillPlayer(player, player:GetRagdollEntity());
	end
	
	--[[timer.Simple(0.5, function()
		if IsValid(player) then
			player:SetPos(Vector(-12377.726563, 8237.457031, 7023.03125));
		end
	end);]]--
	
	hook.Run("PlayerAdjustDeathInfo", player, info)

	if (info.spawnTime and info.spawnTime > 0) then
		Clockwork.player:SetAction(player, "spawn", info.spawnTime, 3)
	end
end

-- A function to create a decal.
function Clockwork.kernel:CreateDecal(texture, position, temporary)
	local decal = ents.Create("infodecal")

	if (temporary) then
		decal:SetKeyValue("LowPriority", "true")
	end

	decal:SetKeyValue("Texture", texture)
	decal:SetPos(position)
	decal:Spawn()
	decal:Fire("activate")

	return decal
end

-- A function to handle a player's weapon fire delay.
function Clockwork.kernel:HandleWeaponFireDelay(player, bIsRaised, weapon, curTime)
	local delaySecondaryFire = nil
	local delayPrimaryFire = nil

	if (!hook.Run("PlayerCanFireWeapon", player, bIsRaised, weapon, true)) then
		delaySecondaryFire = curTime + 60
	end

	if (!hook.Run("PlayerCanFireWeapon", player, bIsRaised, weapon)) then
		delayPrimaryFire = curTime + 60
	end

	if (delaySecondaryFire == nil and weapon.secondaryFireDelayed) then
		weapon:SetNextSecondaryFire(weapon.secondaryFireDelayed)
		weapon.secondaryFireDelayed = nil
	end

	if (delayPrimaryFire == nil and weapon.primaryFireDelayed) then
		weapon:SetNextPrimaryFire(weapon.primaryFireDelayed)
		weapon.primaryFireDelayed = nil
	end

	if (delaySecondaryFire) then
		if (!weapon.secondaryFireDelayed) then
			weapon.secondaryFireDelayed = weapon:GetNextSecondaryFire()
		end

		--[[
			This is a terrible hotfix for the SMG not being able
			to fire after loading ammunition.
		--]]
		if (weapon:GetClass() != "weapon_smg1") then
			weapon:SetNextSecondaryFire(delaySecondaryFire)
		end
	end

	if (delayPrimaryFire) then
		if (!weapon.primaryFireDelayed) then
			weapon.primaryFireDelayed = weapon:GetNextPrimaryFire()
		end

		weapon:SetNextPrimaryFire(delayPrimaryFire)
	end
end

-- A function to get a ragdoll's hit bone.
function Clockwork.kernel:GetRagdollHitBone(entity, position, failSafe, minimum)
	local closest = {}

	for k, v in pairs(Clockwork.HitGroupBonesCache) do
		local bone = entity:LookupBone(v[1])

		if (bone) then
			local bonePosition = entity:GetBonePosition(bone)

			if (bonePosition) then
				local distance = bonePosition:Distance(position)

				if (!closest[1] or distance < closest[1]) then
					if (!minimum or distance <= minimum) then
						closest[1] = distance
						closest[2] = bone
					end
				end
			end
		end
	end

	if (closest[2]) then
		return closest[2]
	else
		return failSafe
	end
end

-- A function to get a ragdoll's hit group.
function Clockwork.kernel:GetRagdollHitGroup(entity, position)
	local closest = {nil, HITGROUP_GENERIC}

	for k, v in pairs(Clockwork.HitGroupBonesCache) do
		local bone = entity:LookupBone(v[1])

		if (bone) then
			local bonePosition = entity:GetBonePosition(bone)

			if (position) then
				local distance = bonePosition:Distance(position)

				if (!closest[1] or distance < closest[1]) then
					closest[1] = distance
					closest[2] = v[2]
				end
			end
		end
	end

	return closest[2]
end

-- A function to create blood effects at a position.
function Clockwork.kernel:CreateBloodEffects(position, decals, entity, forceVec, fScale)
	if (!entity.cwNextBlood or CurTime() >= entity.cwNextBlood) then
		local effectData = EffectData()
			effectData:SetOrigin(position)
			effectData:SetNormal(forceVec or (VectorRand() * 80))
			effectData:SetScale(fScale or 0.5)
		util.Effect("cw_bloodsmoke", effectData, true, true)

		local effectData = EffectData()
			effectData:SetOrigin(position)
			effectData:SetEntity(entity)
			effectData:SetStart(position)
			effectData:SetScale(fScale or 0.5)
		util.Effect("BloodImpact", effectData, true, true)

		for i = 1, decals do
			local trace = {}
				trace.start = position
				trace.endpos = trace.start
				trace.filter = entity
			trace = util.TraceLine(trace)

			util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end

		entity.cwNextBlood = CurTime() + 0.5
	end
end

-- A function to perform the date and time think.
function Clockwork.kernel:PerformDateTimeThink()
	local defaultDays = Clockwork.option:GetKey("default_days")
	local minute = Clockwork.time:GetMinute()
	local month = Clockwork.date:GetMonth()
	local year = Clockwork.date:GetYear()
	local hour = Clockwork.time:GetHour()
	local day = Clockwork.time:GetDay()

	Clockwork.time.minute = Clockwork.time:GetMinute() + 1

	if (Clockwork.time:GetMinute() >= 60) then
		Clockwork.time.minute = 0
		Clockwork.time.hour = Clockwork.time:GetHour() + 1

		if (Clockwork.time:GetHour() >= 24) then
			Clockwork.time.hour = 0
			Clockwork.time.day = Clockwork.time:GetDay() + 1
			Clockwork.date.day = Clockwork.date:GetDay() + 1

			if (Clockwork.time:GetDay() == #defaultDays + 1) then
				Clockwork.time.day = 1
			end

			if (Clockwork.date:GetDay() >= 31) then
				Clockwork.date.day = 1
				Clockwork.date.month = Clockwork.date:GetMonth() + 1

				if (Clockwork.date:GetMonth() >= 13) then
					Clockwork.date.month = 1
					Clockwork.date.year = Clockwork.date:GetYear() + 1
				end
			end
		end
	end

	if (Clockwork.time:GetMinute() != minute) then
		hook.Run("TimePassed", TIME_MINUTE)
	end

	if (Clockwork.time:GetHour() != hour) then
		hook.Run("TimePassed", TIME_HOUR)
	end

	if (Clockwork.time:GetDay() != day) then
		hook.Run("TimePassed", TIME_DAY)
	end

	if (Clockwork.date:GetMonth() != month) then
		hook.Run("TimePassed", TIME_MONTH)
	end

	if (Clockwork.date:GetYear() != year) then
		hook.Run("TimePassed", TIME_YEAR)
	end

	local month = self:ZeroNumberToDigits(Clockwork.date:GetMonth(), 2)
	local day = self:ZeroNumberToDigits(Clockwork.date:GetDay(), 2)

	netvars.SetNetVar("minute", minute)
	netvars.SetNetVar("hour", hour)
	netvars.SetNetVar("date", day.."/"..month.."/"..year)
	netvars.SetNetVar("day", day)
end

-- A function to create a ConVar.
function Clockwork.kernel:CreateConVar(name, value, flags, Callback)
	local conVar = CreateConVar(name, value, flags or FCVAR_REPLICATED + FCVAR_NOTIFY + FCVAR_ARCHIVE)

	cvars.AddChangeCallback(name, function(conVar, previousValue, newValue)
		hook.Run("ClockworkConVarChanged", conVar, previousValue, newValue)

		if (Callback) then
			Callback(conVar, previousValue, newValue)
		end
	end)

	return conVar
end

-- A function to get a player's custom color.
function Clockwork.kernel:SetPlayerColor(player, color)
	if (IsValid(player) and IsColor(color)) then
		local colorString = util.TableToJSON(color);
		
		player:SetCharacterData("CustomColor", colorString);
		player:SetNetVar("CustomColor", colorString);
		player:SaveCharacter();
	elseif (IsValid(player) and !color) then
		player:SetCharacterData("CustomColor", nil);
		player:SetNetVar("CustomColor", nil);
		player:SaveCharacter();
	end;
end;

-- A function to get a player's custom name color.
function Clockwork.kernel:PlayerNameColor(player)
	if (IsValid(player)) then
		local playerTeam = player:Team();
		local color = _team.GetColor(playerTeam);
		local characterColor = player:GetCharacterData("CustomColor");
		--local override = plugin.Call("GetPlayerNameColor", player, color, playerTeam);
		local override = hook.Run("GetPlayerNameColor", player, color, playerTeam);

		if (characterColor != nil) then
			color = util.JSONToTable(characterColor);
		end;
		
		if (override != nil and type(override) == "Color") then
			color = override;
		end;
		
		return Color(color.r, color.g, color.b, color.a);
	else
		return Color(0, 0, 0);
	end;
end;

-- A function to check if the server is shutting down.
function Clockwork.kernel:IsShuttingDown()
	return Clockwork.ShuttingDown
end

-- A function to distribute wages cash.
function Clockwork.kernel:DistributeWagesCash()
	for _, v in _player.Iterator() do
		if (v:HasInitialized() and v:Alive()) then
			local info = {
				wages = v:GetWages() or 0
			}

			hook.Run("PlayerModifyWagesInfo", v, info)

			if (hook.Run("PlayerCanEarnWagesCash", v, info.wages)) then
				if (info.wages > 0) then
					if (hook.Run("PlayerGiveWagesCash", v, info.wages, v:GetWagesName())) then
						Clockwork.player:GiveCash(v, info.wages, v:GetWagesName())
					end
				end

				hook.Run("PlayerEarnWagesCash", v, info.wages)
			end
		end
	end
end

-- A function to include the schema.
function Clockwork.kernel:IncludeSchema()
	local schemaFolder = self:GetSchemaFolder()

	if (schemaFolder and type(schemaFolder) == "string") then
		config.Load(nil, true)
			self:LoadSchema()
		config.Load()
	end
end

-- A function to print a log message.
function Clockwork.kernel:PrintLog(logType, text)
	local listeners = {}
	
	for _, v in _player.Iterator() do
		if (v:HasInitialized() and v:GetInfoNum("cwShowLog", 0) == 1) then
			if (Clockwork.player:IsAdmin(v)) then
				listeners[#listeners + 1] = v
			end
		end
	end

	netstream.Start(listeners, "Log", {
		logType = (logType or 5), text = text
	})

	if (game.IsDedicated()) then
		self:ServerLog(text)
	end
end

-- A function to log to the server.
function Clockwork.kernel:ServerLog(text)
	local dateInfo = os.date("*t")
	local unixTime = os.time()

	if (dateInfo) then
		if (dateInfo.month < 10) then dateInfo.month = "0"..dateInfo.month; end
		if (dateInfo.day < 10) then dateInfo.day = "0"..dateInfo.day; end
		local fileName = dateInfo.year.."-"..dateInfo.month.."-"..dateInfo.day

		if (dateInfo.hour < 10) then dateInfo.hour = "0"..dateInfo.hour; end
		if (dateInfo.min < 10) then dateInfo.min = "0"..dateInfo.min; end
		if (dateInfo.sec < 10) then dateInfo.sec = "0"..dateInfo.sec; end
		local time = dateInfo.hour..":"..dateInfo.min..":"..dateInfo.sec
		local logText = time..": "..string.gsub(text, "\n", "")

		fileio.Append("logs/clockwork/"..fileName..".log", logText.."\n")
	end

	ServerLog(text.."\n") hook.Run("ClockworkLog", text, unixTime)
end

-- A function to do the entity take damage hook.
function Clockwork.kernel:DoEntityTakeDamageHook(entity, damageInfo)
	local inflictor = damageInfo:GetInflictor()
	local attacker = damageInfo:GetAttacker()
	local amount = damageInfo:GetDamage()
	
	local isPlayerRagdoll = Clockwork.entity:IsPlayerRagdoll(entity);
	local player = Clockwork.entity:GetPlayer(entity);
	local ragdoll;
	local lastHitGroup;
	
	if (player) then
		ragdoll = player:GetRagdollEntity();
		
		if ragdoll and !ragdoll.cwIsBelongings then
			if (entity != ragdoll) then
				hook.Run("EntityTakeDamage", ragdoll, damageInfo)
				damageInfo:SetDamage(0)

				return true
			end
		end
	
		if (hook.Run("PlayerShouldTakeDamage", player, attacker) == false or
		hook.Run("PlayerShouldTakeDamageNew", player, attacker, inflictor, damageInfo) or
		player:IsInGodMode()) then
			damageInfo:SetDamage(0)
			return true
		end
	end
	
	if hook.Run("PreEntityTakeDamage", entity, damageInfo) == true then
		return true;
	end
	
	if hook.Run("EntityTakeDamageArmor", entity, damageInfo) == true then
		return true;
	end
	
	if hook.Run("EntityTakeDamageNew", entity, damageInfo) == true then
		return true;
	end
	
	if hook.Run("EntityTakeDamageAfter", entity, damageInfo) == true then
		return true;
	end
	
	if (player and (entity:IsPlayer() or isPlayerRagdoll)) then
		if (!isPlayerRagdoll) then
			lastHitGroup = player:LastHitGroup()
			
			if IsValid(attacker) and attacker:IsPlayer() then
				local activeWeapon = attacker:GetActiveWeapon();
				
				if activeWeapon:IsValid() and activeWeapon.Base == "sword_swepbase" then
					lastHitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
				end
			end
			
			hook.Run("ScaleDamageByHitGroup", player, attacker, lastHitGroup, damageInfo, amount);
		elseif !entity.cwIsBelongings then
			lastHitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition())
			
			hook.Run("ScaleDamageByHitGroup", player, attacker, lastHitGroup, damageInfo, amount);
		end
		
		if ragdoll and !ragdoll.cwIsBelongings then
			local physicsObject = entity:GetPhysicsObject()

			if (IsValid(physicsObject)) then
				local velocity = physicsObject:GetVelocity():Length()
				local curTime = CurTime()

				if (damageInfo:IsDamageType(DMG_CRUSH)) then
					if (entity:IsBeingHeld() or (entity.cwNextFallDamage and curTime < entity.cwNextFallDamage)) then
						damageInfo:SetDamage(0)
						return true
					end

					amount = hook.Run("GetFallDamage", player, velocity)
					hook.Run("OnPlayerHitGround", player, false, false, true);
					entity.cwNextFallDamage = curTime + 0.5;
					
					--print("Damage: " ..amount);
					--print("Velocity: "..tostring(physicsObject:GetVelocity()));
					--print("Vel Length: "..velocity);
					
					damageInfo:SetDamage(amount)
				end
			end
		end
	
		if hook.Run("FuckMyLife", player, damageInfo) == true then
			return true;
		end
		
		if !lastHitGroup then
			if isPlayerRagdoll then
				lastHitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition())
			else
				lastHitGroup = player:LastHitGroup()
			end
		end
		
		if lastHitGroup == HITGROUP_GENERIC then
			lastHitGroup = math.random(1, 7);
		end
		
		hook.Run("PreCalculatePlayerDamage", player, lastHitGroup, damageInfo);
		hook.Run("CalculatePlayerDamage", player, lastHitGroup, damageInfo);
		hook.Run("PostCalculatePlayerDamage", player, lastHitGroup, damageInfo);
	end
end

function Clockwork.kernel:ForceUnequipItem(player, uniqueID, itemID, arguments)
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
			itemTable:OnPlayerUnequipped(player, arguments, true);
		end
	end
end;

-- A function to transition from a knocked out state to a fallen over state.
function Clockwork.kernel:UnragdollTransition(player, delay)
	if (player:IsRagdolled(RAGDOLL_FALLENOVER) and player:Alive()) then
		Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, nil);
	else
		Clockwork.player:SetRagdollState(player, RAGDOLL_NONE);
	end;
end;

--[[ Disable game saving and admin cleanup. --]]
concommand.Add("gm_save", function(player, command, arguments)
	ErrorNoHalt("[Clockwork] "..player:Name().." ("..player:SteamID()..") has attempted to use gm_save command to potentially crash the server!\n")
end)

concommand.Add("botadd", function(player)
	if (player:IsAdmin()) then
		RunConsoleCommand("bot")
	end;
end);

local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

playerMeta.ClockworkSetCrouchedWalkSpeed = playerMeta.ClockworkSetCrouchedWalkSpeed or playerMeta.SetCrouchedWalkSpeed
playerMeta.ClockworkLastHitGroup = playerMeta.ClockworkLastHitGroup or playerMeta.LastHitGroup
playerMeta.ClockworkSetJumpPower = playerMeta.ClockworkSetJumpPower or playerMeta.SetJumpPower
playerMeta.ClockworkSetWalkSpeed = playerMeta.ClockworkSetWalkSpeed or playerMeta.SetWalkSpeed
playerMeta.ClockworkStripWeapons = playerMeta.ClockworkStripWeapons or playerMeta.StripWeapons
playerMeta.ClockworkSetRunSpeed = playerMeta.ClockworkSetRunSpeed or playerMeta.SetRunSpeed
entityMeta.ClockworkSetMaterial = entityMeta.ClockworkSetMaterial or entityMeta.SetMaterial
playerMeta.ClockworkStripWeapon = playerMeta.ClockworkStripWeapon or playerMeta.StripWeapon
entityMeta.ClockworkFireBullets = entityMeta.ClockworkFireBullets or entityMeta.FireBullets
entityMeta.ClockworkFire = entityMeta.ClockworkFire or entityMeta.Fire
playerMeta.ClockworkGodDisable = playerMeta.ClockworkGodDisable or playerMeta.GodDisable
entityMeta.ClockworkIgnite = entityMeta.ClockworkIgnite or entityMeta.Ignite
entityMeta.ClockworkExtinguish = entityMeta.ClockworkExtinguish or entityMeta.Extinguish
entityMeta.ClockworkWaterLevel = entityMeta.ClockworkWaterLevel or entityMeta.WaterLevel
playerMeta.ClockworkGodEnable = playerMeta.ClockworkGodEnable or playerMeta.GodEnable
entityMeta.ClockworkSetHealth = entityMeta.ClockworkSetHealth or entityMeta.SetHealth
entityMeta.ClockworkSetMaxHealth = entityMeta.ClockworkSetMaxHealth or entityMeta.SetMaxHealth
playerMeta.ClockworkUniqueID = playerMeta.ClockworkUniqueID or playerMeta.UniqueID
entityMeta.ClockworkSetColor = entityMeta.ClockworkSetColor or entityMeta.SetColor
entityMeta.ClockworkIsOnFire = entityMeta.ClockworkIsOnFire or entityMeta.IsOnFire
entityMeta.ClockworkSetModel = entityMeta.ClockworkSetModel or entityMeta.SetModel
playerMeta.ClockworkSetArmor = playerMeta.ClockworkSetArmor or playerMeta.SetArmor
entityMeta.ClockworkSetSkin = entityMeta.ClockworkSetSkin or entityMeta.SetSkin
entityMeta.ClockworkAlive = entityMeta.ClockworkAlive or playerMeta.Alive
playerMeta.ClockworkGive = playerMeta.ClockworkGive or playerMeta.Give
playerMeta.ClockworkKick = playerMeta.ClockworkKick or playerMeta.Kick
playerMeta.ClockworkSteamID64 = playerMeta.ClockworkSteamID64 or playerMeta.SteamID64
playerMeta.ClockworkPlayStepSound = playerMeta.ClockworkPlayStepSound or playerMeta.PlayStepSound
playerMeta.SteamName = playerMeta.SteamName or playerMeta.Name

function playerMeta:IsJogging()
	return false;
end;

function playerMeta:SteamID64()
	local value = self:ClockworkSteamID64()

	if (value == nil) then
		print("[Clockwork] Temporary fix for SteamID64 has been used.")
		return ""
	else
		return value
	end
end

-- A function to override player's name returned by player:Name().
function playerMeta:OverrideName(name)
	if (name and name != "") then
		self:SetNetVar("NameOverride", name)
	else
		self:SetNetVar("NameOverride", nil)
	end
end

-- A function to get a player's name.
function playerMeta:Name(bRealName)
	return (!bRealName and self:GetNetVar("NameOverride")) or self:QueryCharacter("Name", self:SteamName())
end

-- A function to make a player fire bullets.
function entityMeta:FireBullets(bulletInfo)
	if (self:IsPlayer()) then
		hook.Run("PlayerAdjustBulletInfo", self, bulletInfo)
	end

	hook.Run("EntityFireBullets", self, bulletInfo)
	return self:ClockworkFireBullets(bulletInfo)
end

function entityMeta:Fire(input, param, delay, activator, caller)
	hook.Run("EntityFire", self, input, param, delay, activator, caller)
	return self:ClockworkFire(input, param, delay, activator, caller)
end

-- A function to get whether a player is alive.
function playerMeta:Alive()
	if (!self.fakingDeath) then
		return self:ClockworkAlive()
	else
		return false
	end
end

-- A function to set whether a player is faking death.
function playerMeta:SetFakingDeath(fakingDeath, killSilent)
	self.fakingDeath = fakingDeath

	if (!fakingDeath and killSilent) then
		self:KillSilent()
	end
end

-- A function to save a player's character.
function playerMeta:SaveCharacter()
	Clockwork.player:SaveCharacter(self)
end

-- A function to give a player an item weapon.
function playerMeta:GiveItemWeapon(itemTable)
	Clockwork.player:GiveItemWeapon(self, itemTable)
end

-- A function to give a weapon to a player.
function playerMeta:Give(class, itemTable, bForceReturn)
	local iTeamIndex = self:Team()

	if (!hook.Run("PlayerCanBeGivenWeapon", self, class, itemTable)) then
		return
	end

	if (self:IsRagdolled() and !bForceReturn) then
		local ragdollWeapons = self:GetRagdollWeapons()
		local spawnWeapon = Clockwork.player:GetSpawnWeapon(self, class)
		local bCanHolster = (itemTable and hook.Run("PlayerCanHolsterWeapon", self, itemTable, true, true))

		if (!spawnWeapon) then iTeamIndex = nil; end

		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == class
			and v.weaponData["itemTable"] == itemTable) then
				v.canHolster = bCanHolster
				v.teamIndex = iTeamIndex
				return
			end
		end

		ragdollWeapons[#ragdollWeapons + 1] = {
			weaponData = {
				class = class,
				itemTable = itemTable,
			},
			canHolster = bCanHolster,
			teamIndex = iTeamIndex,
		}
	elseif (!self:HasWeapon(class)) then
		self.cwForceGive = true
			self:ClockworkGive(class)
		self.cwForceGive = nil

		local weapon = self:GetWeapon(class)

		if (IsValid(weapon) and itemTable) then
			netstream.Start(self, "WeaponItemData", {
				definition = item.GetDefinition(itemTable, true),
				weapon = weapon:EntIndex()
			})

			weapon:SetNWInt("ItemID", itemTable.itemID);
			weapon.cwItemTable = itemTable

			if (itemTable.OnWeaponGiven) then
				itemTable:OnWeaponGiven(self, weapon)
			end
		end
		
		return weapon;
	end

	hook.Run("PlayerGivenWeapon", self, class, itemTable)
end

-- A function to get a player's data.
function playerMeta:GetData(key, default)
	if (self.CustomData and self.CustomData[key] != nil) then
		return self.CustomData[key]
	else
		return default
	end
end

-- A function to get a player's playback rate.
function playerMeta:GetPlaybackRate()
	return self.cwPlaybackRate or 1
end

-- A function to set an entity's skin.
function entityMeta:SetSkin(skin)
	if IsValid(self) then
		self:ClockworkSetSkin(tonumber(skin) or 0)

		if (self:IsPlayer()) then
			hook.Run("PlayerSkinChanged", self, tonumber(skin) or 0)

			if (self:IsRagdolled()) then
				self:GetRagdollTable().skin = tonumber(skin) or 0
			end
		end
	end
end

-- A function to set an entity's model.
function entityMeta:SetModel(model)
	if IsValid(self) and (model) then
		self:ClockworkSetModel(model)

		if (self:IsPlayer()) then
			hook.Run("PlayerModelChanged", self, model)

			if (self:IsRagdolled()) then
				self:GetRagdollTable().model = model
			end
		end
	end;
end

-- A function to get an entity's owner key.
function entityMeta:GetOwnerKey()
	return self.cwOwnerKey
end

-- A function to set an entity's owner key.
function entityMeta:SetOwnerKey(key)
	self.cwOwnerKey = key
end

-- A function to get whether an entity is a map entity.
function entityMeta:IsMapEntity()
	return Clockwork.entity:IsMapEntity(self)
end

-- A function to get an entity's start position.
function entityMeta:GetStartPosition()
	return Clockwork.entity:GetStartPosition(self)
end

-- A function to emit a hit sound for an entity.
function entityMeta:EmitHitSound(sound)
	self:EmitSound("weapons/crossbow/hitbod2.wav",
		math.random(100, 150), math.random(150, 170)
	)

	timer.Simple(FrameTime() * 8, function()
		if (IsValid(self)) then
			self:EmitSound(sound)
		end
	end)
end

-- A function to set an entity's material.
function entityMeta:SetMaterial(material)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetMaterial(material)
	end

	self:ClockworkSetMaterial(material)
end

-- A function to set an entity's color.
function entityMeta:SetColor(color)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetColor(color)
	end
	
	self:ClockworkSetColor(color)
end

-- A function to get a player's information table.
function playerMeta:GetInfoTable()
	return self.cwInfoTable
end

-- A function to set a player's armor.
function playerMeta:SetArmor(armor)
	if (!armor) then
		return
	end

	local oldArmor = self:Armor()
		self:ClockworkSetArmor(armor)
	hook.Run("PlayerArmorSet", self, armor, oldArmor)
end

-- A function to set a player's health.
function playerMeta:SetHealth(health)
	if (!health) then
		return
	end

	local oldHealth = self:Health()
		self:ClockworkSetHealth(health)
	hook.Run("PlayerHealthSet", self, health, oldHealth)
end

-- A function to get whether a player is noclipping.
function playerMeta:IsNoClipping()
	return Clockwork.player:IsNoClipping(self)
end

-- A function to get whether a player is running.
function playerMeta:IsRunning()
	if self:KeyDown(IN_SPEED) then
		if self:Alive() and !self:IsRagdolled() and !self:InVehicle() and !self:Crouching() and self:WaterLevel() < 2 then
			if (self:GetVelocity():Length() >= self:GetWalkSpeed() or bNoWalkSpeed) then
				if !self:GetNetVar("runningDisabled") then
					return true;
				end
			end
		end
	end

	return false
end

-- A function to get whether a player is jumping.
function playerMeta:IsJumping()
	if (self:Alive() and !self:IsRagdolled() and !self:InVehicle()
	and !self:Crouching() and self.m_bJumping) then
		return true
	end

	return false
end

-- A function to strip a weapon from a player.
function playerMeta:StripWeapon(weaponClass)
	if (self:IsRagdolled()) then
		local ragdollWeapons = self:GetRagdollWeapons()

		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				ragdollWeapons[k] = nil
			end
		end
	else
		-- Experimental linux server crash fix by just removing the weapon manually instead of using StripWeapon which can infinitely loop.
		--[[local weaponObj = self:GetWeapon(weaponClass);
		
		if IsValid(weaponObj) then
			weaponObj:Remove();
		end]]--
		
		self:ClockworkStripWeapon(weaponClass)
	end
end

-- A function to get the player's target run speed.
function playerMeta:GetTargetRunSpeed()
	return self.cwTargetRunSpeed or self:GetRunSpeed()
end

-- A function to handle a player's attribute progress.
function playerMeta:HandleAttributeProgress(curTime)
	--[[if (self.cwAttrProgressTime and curTime >= self.cwAttrProgressTime) then
		self.cwAttrProgressTime = curTime + 30

		for k, v in pairs(self.cwAttrProgress) do
			local attributeTable = Clockwork.attribute:FindByID(k)

			if (attributeTable) then
				netstream.Start(self, "AttributeProgress", {
					index = attributeTable.index, amount = v
				})
			end
		end

		if (self.cwAttrProgress) then
			self.cwAttrProgress = {}
		end
	end]]--
end

-- A function to handle a player's attribute boosts.
function playerMeta:HandleAttributeBoosts(curTime)
	--[[for k, v in pairs(self.cwAttrBoosts) do
		for k2, v2 in pairs(v) do
			if (v2.duration and v2.endTime) then
				if (curTime > v2.endTime) then
					self:BoostAttribute(k2, k, false)
				else
					local timeLeft = v2.endTime - curTime

					if (timeLeft >= 0) then
						if (v2.default < 0) then
							v2.amount = math.min((v2.default / v2.duration) * timeLeft, 0)
						else
							v2.amount = math.max((v2.default / v2.duration) * timeLeft, 0)
						end
					end
				end
			end
		end
	end]]--
end

-- A function to strip a player's weapons.
function playerMeta:StripWeapons(ragdollForce)
	if (self:IsRagdolled() and !ragdollForce) then
		self:GetRagdollTable().weapons = {}
	else
		self:ClockworkStripWeapons()
	end
end

-- A function to enable God for a player.
function playerMeta:GodEnable()
	self.godMode = true; self:ClockworkGodEnable()
end

-- A function to disable God for a player.
function playerMeta:GodDisable()
	self.godMode = nil; self:ClockworkGodDisable()
end

-- A function to get whether a player has God mode enabled.
function playerMeta:IsInGodMode()
	return self.godMode
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

	-- A function to update whether a player's weapon has fired.
	function playerMeta:UpdateWeaponFired()
		--[[local activeWeapon = self:GetActiveWeapon();
		
		if (activeWeapon:IsValid()) then
			local weaponClass = activeWeapon:GetClass()
			local itemTable = item.GetByWeapon(activeWeapon)
			
			if (itemTable and itemTable:IsInstance()) then
				local ammo = itemTable:GetData("Ammo");
				
				if ammo then
					if itemTable.ammoCapacity == 1 then
						ammo = {};
					elseif itemTable.isRevolver and #ammo > 0 then
						table.remove(ammo, #ammo);
					elseif itemTable.usesMagazine and #ammo > 0 then
						table.remove(ammo, 1);
					end
					
					itemTable:SetData("Ammo", ammo);
				end
			end;
		end;]]--
	end
end

-- A function to get a player's water level.
function playerMeta:WaterLevel()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():WaterLevel()
	else
		return self:ClockworkWaterLevel()
	end
end

-- A function to get whether a player is on fire.
function playerMeta:IsOnFire()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():IsOnFire()
	else
		return self:ClockworkIsOnFire()
	end
end

-- A function to ignite a player.
function playerMeta:Ignite(length, radius)
	if hook.Run("PlayerCanBeIgnited", self) == false then return false end;

	if (self:IsRagdolled()) then
		self:GetRagdollEntity():Ignite(length, radius);
	end
	
	self:ClockworkIgnite(length, radius)
end

-- A function to extinguish a player.
function playerMeta:Extinguish()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():Extinguish()
	else
		return self:ClockworkExtinguish()
	end
end

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingHands()
	return Clockwork.player:GetWeaponClass(self) == "begotten_fists";
end

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingKeys()
	return Clockwork.player:GetWeaponClass(self) == "cw_keys"
end

-- A function to get a player's wages.
function playerMeta:GetWages()
	return Clockwork.player:GetWages(self)
end

-- A function to get whether a player is ragdolled.
function playerMeta:IsRagdolled(exception, entityless)
	return Clockwork.player:IsRagdolled(self, exception, entityless)
end

-- A function to get whether a player is kicked.
function playerMeta:IsKicked()
	return self.isKicked
end

-- A function to get whether a player has spawned.
function playerMeta:HasSpawned()
	return self.cwHasSpawned
end

-- A function to kick a player.
function playerMeta:Kick(reason)
	if (!self:IsKicked()) then
		timer.Simple(FrameTime() * 0.5, function()
			local isKicked = self:IsKicked()

			if (IsValid(self) and isKicked) then
				if (self:HasSpawned()) then
					game.ConsoleCommand("kickid "..self:UserID().." "..isKicked.."\n")
				else
					self.isKicked = nil
					self:Kick(isKicked)
				end
			end
		end)
	end

	if (!reason) then
		self.isKicked = "You have been kicked."
	else
		self.isKicked = reason
	end
end

-- A function to ban a player.
function playerMeta:Ban(duration, reason)
	Clockwork.bans:Add(self:SteamID(), duration * 60, reason)
end

-- A function to get a player's cash.
function playerMeta:GetCash()
	if (config.GetVal("cash_enabled")) then
		return self:QueryCharacter("Cash")
	else
		return 0
	end
end

-- A function to get a character's flags.
function playerMeta:GetFlags() return self:QueryCharacter("Flags") end

-- A function to get a player's faction.
function playerMeta:GetFaction() return self:QueryCharacter("Faction") end

-- A function to get a player's subfaction.
function playerMeta:GetSubfaction() return self:QueryCharacter("Subfaction") end

-- A function to get a player's faith.
function playerMeta:GetFaith() return self:QueryCharacter("Faith") end

-- A function to get a player's faith.
function playerMeta:GetSubfaith() return self:QueryCharacter("Subfaith") end

-- A function to get a player's gender.
function playerMeta:GetGender() return self:QueryCharacter("Gender") end

-- A function to get a player's inventory.
function playerMeta:GetInventory() return self:QueryCharacter("Inventory") end

-- A function to get a player's attributes.
--function playerMeta:GetAttributes() return self:QueryCharacter("Attributes") end

-- A function to get a player's saved ammo.
--function playerMeta:GetSavedAmmo() return self:QueryCharacter("Ammo") end

-- A function to get a player's default model.
function playerMeta:GetDefaultModel() return self:QueryCharacter("Model") end

-- A function to get a player's character ID.
function playerMeta:GetCharacterID() return self:QueryCharacter("CharacterID") end

-- A function to get the time when a player's character was created.
function playerMeta:GetTimeCreated() return self:QueryCharacter("TimeCreated") end

-- A function to get a player's character key.
function playerMeta:GetCharacterKey() return self:QueryCharacter("Key") or self:GetCharacterData("Key") end

-- A function to get a player's recognised names.
function playerMeta:GetRecognisedNames()
	return self:QueryCharacter("RecognisedNames")
end

-- A function to get a player's character table.
function playerMeta:GetCharacter() return Clockwork.player:GetCharacter(self) end

-- A function to get a player's storage table.
function playerMeta:GetStorageTable() return Clockwork.storage:GetTable(self) end

-- A function to get a player's ragdoll table.
function playerMeta:GetRagdollTable() return Clockwork.player:GetRagdollTable(self) end

-- A function to get a player's ragdoll state.
function playerMeta:GetRagdollState() return Clockwork.player:GetRagdollState(self) end

-- A function to get a player's storage entity.
function playerMeta:GetStorageEntity() return Clockwork.storage:GetEntity(self) end

-- A function to get a player's ragdoll entity.
function playerMeta:GetRagdollEntity() return Clockwork.player:GetRagdollEntity(self) end

-- A function to get a player's ragdoll weapons.
function playerMeta:GetRagdollWeapons()
	return self:GetRagdollTable().weapons or {}
end

-- A function to get whether a player's ragdoll has a weapon.
function playerMeta:RagdollHasWeapon(weaponClass)
	local ragdollWeapons = self:GetRagdollWeapons()

	if (ragdollWeapons) then
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				return true
			end
		end
	end
end

-- A function to set a player's maximum armor.
function playerMeta:SetMaxArmor(armor)
	self:SetNetVar("MaxAP", armor)
end

-- A function to get a player's maximum armor.
function playerMeta:GetMaxArmor(armor)
	local maxArmor = self:GetNetVar("MaxAP") or 100

	if (maxArmor > 0) then
		return maxArmor
	else
		return 100
	end
end

-- A function to set a player's maximum health.
function playerMeta:SetMaxHealth(health)
	self:SetNetVar("MaxHP", health)
	self:ClockworkSetMaxHealth(health)
end

-- A function to get a player's maximum health.
function playerMeta:GetMaxHealth(health)
	local maxHealth = self:GetNetVar("MaxHP") or 100
	local factionName = self:GetFaction();
	local FACTION = Clockwork.faction:FindByID(factionName)
	local subfaction = self:GetSubfaction();
	local subfaith = self:GetSubfaith();
	local faith = self:GetFaith();
	local boost = self:GetNetVar("loyaltypoints", 0)
	
	-- should probably move this all into hooks later.

	if FACTION then
		maxHealth = FACTION.maxHealth or 100;
		maxArmor = FACTION.maxArmor or 100;
	end
	
	if boost > 0 then
		maxhealth = maxHealth + boost
	end	
	
	if factionName == "The Third Inquisition" then
		maxHealth = maxHealth + 50;
	end
	
	if subfaction then
		if subfaction == "Clan Grock" then
			maxHealth = maxHealth + 175;
		elseif subfaction == "Knights of Sol" then
			maxHealth = maxHealth + 75;
		elseif subfaction == "Clan Gore" or subfaction == "Inquisition" or subfaction == "Philimaxio" then
			maxHealth = maxHealth + 50;
		elseif subfaction == "Clan Harald" then
			maxHealth = maxHealth + 45;
		elseif subfaction == "Clan Shagalax" or subfaction == "Machinists" or subfaction == "Watchman" then
			maxHealth = maxHealth + 30;
		elseif subfaction == "Clan Reaver" or subfaction == "Clan Crast" or subfaction == "Legionary" or subfaction == "Limitanei" or subfaction == "Varazdat" then
			maxHealth = maxHealth + 25;
		elseif subfaction == "Low Ministry" then
			maxHealth = maxHealth + 15;
		end
	end
	
	if subfaith then
		if subfaith == "Voltism" and !Clockwork.player:HasFlags(self, "T") then
			if self:HasBelief("jacobs_ladder") then
				maxHealth = maxHealth - 5;
			end
			
			if self:HasBelief("the_paradox_riddle_equation") then
				maxHealth = maxHealth - 5;
			end
			
			if self:HasBelief("yellow_and_black") then
				maxHealth = maxHealth - 5;
			end
			
			if self:HasBelief("the_storm") then
				maxHealth = maxHealth - 5;
			end
		end
	end
	
	if self:HasBelief("unyielding") then
		maxHealth = maxHealth + 25;
	end

	if self:HasBelief("fortitude_finisher") then
		maxHealth = maxHealth + 15;
	end
	
	if faith == "Faith of the Family" then	
		if self:HasBelief("man_become_beast") then
			maxHealth = maxHealth + 40;
		end
		
		if self:HasBelief("taste_of_blood") then
			maxHealth = maxHealth + 35;
		end
		
		if self:HasBelief("shieldwall") or self:HasBelief("shedskin") or self:HasBelief("gift_great_tree") then
			maxHealth = maxHealth + 25;
		end
	end

	if self:GetCharmEquipped("ring_vitality") then
		maxHealth = maxHealth + 25;
	elseif self:GetCharmEquipped("ring_vitality_lesser") then
		maxHealth = maxHealth + 15;
	end
	
	if self.maxHealthBoost then
		maxHealth = maxHealth + self.maxHealthBoost;
	end
	
	if cwMedicalSystem then
		local injuries = cwMedicalSystem:GetInjuries(self);
		
		if injuries then
			for k, v in pairs (injuries) do
				if v["burn"] then
					maxHealth = maxHealth - 5;
				end
			end
		end
	end
	
	if (self:Health() > maxHealth) and self.maxHealthSet then
		return self:Health();
	elseif (maxHealth > 0) then
		return maxHealth;
	else
		return 100
	end
end

-- A function to get whether a player is viewing the starter hints.
function playerMeta:IsViewingStarterHints()
	return self.cwViewStartHints
end

-- A function to get a player's last hit group.
function playerMeta:LastHitGroup()
	return self.cwLastHitGroup or self:ClockworkLastHitGroup()
end

-- A function to get whether an entity is being held.
function entityMeta:IsBeingHeld()
	if (IsValid(self)) then
		return hook.Run("GetEntityBeingHeld", self)
	end
end

-- A function to run a command on a player.
function playerMeta:RunCommand(...)
	netstream.Start(self, "RunCommand", {...})
end

-- A function to run a Clockwork command on a player.
function playerMeta:RunClockworkCmd(command, ...)
	Clockwork.player:RunClockworkCommand(self, command, ...)
end

-- A function to get a player's wages name.
function playerMeta:GetWagesName()
	return Clockwork.player:GetWagesName(self)
end

-- A function to create a player'a animation stop delay.
function playerMeta:CreateAnimationStopDelay(delay)
	timer.Create("ForcedAnim"..self:UniqueID(), delay, 1, function()
		if (IsValid(self)) then
			local forcedAnimation = self:GetForcedAnimation()

			if (forcedAnimation) then
				self:SetForcedAnimation(false)
			end
		end
	end)
end

-- A function to set a player's forced animation.
function playerMeta:SetForcedAnimation(animation, delay, OnAnimate, OnFinish)
	local forcedAnimation = self:GetForcedAnimation()
	local sequence = nil

	if (!animation) then
		if self:GetNetVar("ForceAnim") then
			self:SetNetVar("ForceAnim", nil)
		end
		
		self.cwForcedAnimation = nil

		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self)
		end

		return false
	end

	local bIsPermanent = (!delay or delay == 0)
	local bShouldPlay = (!forcedAnimation or forcedAnimation.delay != 0)

	if (bShouldPlay) then
		if (type(animation) == "string") then
			sequence = self:LookupSequence(animation)
		else
			sequence = self:SelectWeightedSequence(animation)
		end

		self.cwForcedAnimation = {
			animation = animation,
			OnAnimate = OnAnimate,
			OnFinish = OnFinish,
			delay = delay
		}

		if (bIsPermanent) then
			timer.Remove(
				"ForcedAnim"..self:UniqueID()
			)
		else
			self:CreateAnimationStopDelay(delay)
		end

		self:SetNetVar("ForceAnim", sequence)

		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self)
		end

		return true
	end
end

-- A function to set whether a player's config has initialized.
function playerMeta:SetConfigInitialized(initialized)
	self.cwConfigInitialized = initialized
end

-- A function to get whether a player's config has initialized.
function playerMeta:HasConfigInitialized()
	return self.cwConfigInitialized
end

-- A function to get a player's forced animation.
function playerMeta:GetForcedAnimation()
	return self.cwForcedAnimation
end

-- A function to get a player's item entity.
function playerMeta:GetItemEntity()
	if (IsValid(self.itemEntity)) then
		return self.itemEntity
	end
end

-- A function to set a player's item entity.
function playerMeta:SetItemEntity(entity)
	self.itemEntity = entity
end

-- A function to make a player fake pickup an entity.
function playerMeta:FakePickup(entity)
	local entityPosition = entity:GetPos()

	if (entity:IsPlayer()) then
		entityPosition = entity:GetShootPos()
	end

	local shootPosition = self:GetShootPos()
	local feetDistance = self:GetPos():Distance(entityPosition)
	local armsDistance = shootPosition:Distance(entityPosition)

	if (feetDistance < armsDistance) then
		self:SetForcedAnimation("pickup", 1.2)
	else
		self:SetForcedAnimation("gunrack", 1.2)
	end
end

-- A function to set the player's Clockwork user group.
function playerMeta:SetClockworkUserGroup(userGroup)
	if (self:GetClockworkUserGroup() != userGroup) then
		self.cwUserGroup = userGroup
		self:SetUserGroup(userGroup)
		self:SaveCharacter()

		hook.Run("OnPlayerUserGroupSet", self, userGroup)
	end
end

-- A function to get the player's Clockwork user group.
function playerMeta:GetClockworkUserGroup()
	return self.cwUserGroup
end

-- A function to get a player's items by ID.
function playerMeta:GetItemsByID(uniqueID)
	return Clockwork.inventory:GetItemsByID(
		self:GetInventory(), uniqueID
	)
end

-- A function to find a player's items by name.
function playerMeta:FindItemsByName(uniqueID, name)
	return Clockwork.inventory:FindItemsByName(
		self:GetInventory(), uniqueID, name
	)
end

-- A function to get the maximum weight a player can carry.
function playerMeta:GetMaxWeight()
	local backpackItem = self:GetBackpackEquipped();
	local clothesItem = self:GetClothesEquipped();
	--local itemsList = Clockwork.inventory:GetAsItemsList(self:GetInventory())
	--local weight = self:GetNetVar("InvWeight") or 8
	local weight = config.GetVal("default_inv_weight") or 15;
	
	weight = hook.Run("PlayerAdjustMaxWeight", self, weight);
	
	-- Apply item weight buffs after belief weight buffs.
	--[[for k, v in pairs(itemsList) do
		local addInvWeight = v.addInvSpace;
		
		if (addInvWeight) then
			weight = weight + addInvWeight
		end
	end]]--
	
	if backpackItem and backpackItem.invSpace then
		weight = weight + backpackItem.invSpace;
	end
	
	if clothesItem and clothesItem.pocketSpace then
		weight = weight + clothesItem.pocketSpace;
	end;
	
	return weight;
end

-- A function to get the maximum space a player can carry.
function playerMeta:GetMaxSpace()
	local backpackItem = self:GetBackpackEquipped();
	local clothesItem = self:GetClothesEquipped();
	--local itemsList = Clockwork.inventory:GetAsItemsList(self:GetInventory())
	--local space = self:GetNetVar("InvSpace") or 10;
	local space = config.GetVal("default_inv_space") or 100;

	--space = hook.Run("PlayerAdjustMaxSpace", player, space)
	
	--[[for k, v in pairs(itemsList) do
		local addInvSpace = v.addInvVolume
		if (addInvSpace) then
			space = space + addInvSpace
		end
	end]]--
	
	if backpackItem and backpackItem.invSpace then
		space = space + backpackItem.invSpace;
	end
	
	if clothesItem and clothesItem.pocketSpace then
		weight = weight + clothesItem.pocketSpace;
	end;

	return space
end

-- A function to get whether a player can hold a weight.
function playerMeta:CanHoldWeight(weight)
	local inventoryWeight = Clockwork.inventory:CalculateWeight(
		self:GetInventory()
	)

	--if (inventoryWeight + weight > self:GetMaxWeight()) then
	if (inventoryWeight + weight > self:GetMaxWeight() * 4) then
		return false
	else
		return true
	end
end

-- A function to get whether a player can hold a weight.
function playerMeta:CanHoldSpace(space)
	if (!Clockwork.inventory:UseSpaceSystem()) then
		return true
	end

	local inventorySpace = Clockwork.inventory:CalculateSpace(
		self:GetInventory()
	)

	if (inventorySpace + space > self:GetMaxSpace()) then
		return false
	else
		return true
	end
end

-- A function to get a player's inventory weight.
function playerMeta:GetInventoryWeight()
	return Clockwork.inventory:CalculateWeight(self:GetInventory())
end

-- A function to get a player's inventory weight.
function playerMeta:GetInventorySpace()
	return Clockwork.inventory:CalculateSpace(self:GetInventory())
end

-- A function to get whether a player has an item by ID.
function playerMeta:HasItemByID(uniqueID)
	return Clockwork.inventory:HasItemByID(
		self:GetInventory(), uniqueID
	)
end

-- A function to count how many items a player has by ID.
function playerMeta:GetItemCountByID(uniqueID)
	return Clockwork.inventory:GetItemCountByID(
		self:GetInventory(), uniqueID
	)
end

-- A function to get whether a player has a certain amount of items by ID.
function playerMeta:HasItemCountByID(uniqueID, amount)
	return Clockwork.inventory:HasItemCountByID(
		self:GetInventory(), uniqueID, amount
	)
end

-- A function to find a player's item by ID.
function playerMeta:FindItemByID(uniqueID, itemID)
	return Clockwork.inventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	)
end

-- A function to get whether a player has an item as a weapon.
function playerMeta:HasItemAsWeapon(itemTable)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = item.GetByWeapon(v)
		if (itemTable:IsTheSameAs(weaponItemTable)) then
			return true
		end
	end

	return false
end

-- A function to find a player's weapon item by ID.
function playerMeta:FindWeaponItemByID(uniqueID, itemID)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = item.GetByWeapon(v)
		if (weaponItemTable and weaponItemTable.uniqueID == uniqueID
		and weaponItemTable.itemID == itemID) then
			return weaponItemTable
		end
	end
end

-- A function to get whether a player has an item instance.
function playerMeta:HasItemInstance(itemTable)
	return Clockwork.inventory:HasItemInstance(
		self:GetInventory(), itemTable
	)
end

-- A function to get a player's item instance.
function playerMeta:GetItemInstance(uniqueID, itemID)
	return Clockwork.inventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	)
end

-- A function to take a player's item by ID.
function playerMeta:TakeItemByID(uniqueID, itemID)
	local itemTable = self:GetItemInstance(uniqueID, itemID)

	if (itemTable) then
		return self:TakeItem(itemTable, true)
	else
		return false
	end
end

-- A function to get a player's attribute boosts.
function playerMeta:GetAttributeBoosts()
	return self.cwAttrBoosts
end

-- A function to rebuild a player's inventory.
function playerMeta:RebuildInventory()
	Clockwork.inventory:Rebuild(self)
end

-- A function to give an item to a player.
function playerMeta:GiveItem(itemTable, bForce)
	if (isstring(itemTable)) then
		itemTable = item.CreateInstance(itemTable)
	-- There's some weird things happening with item instances that necessitate this for now.
	elseif itemTable.uniqueID and itemTable.itemID and !itemTable:IsInstance() then
		itemTable = item.CreateInstance(itemTable.uniqueID, itemTable.itemID);
	end

	if (!itemTable or !itemTable:IsInstance()) then
		debug.Trace()
		return false, "This item is not valid."
	end

	local inventory = self:GetInventory()

	if ((self:CanHoldWeight(itemTable.weight) and self:CanHoldSpace(itemTable.space)) or bForce) then
		if (itemTable.OnGiveToPlayer) then
			itemTable:OnGiveToPlayer(self)
		end

		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, self:Name().." has gained a "..itemTable.name.." "..itemTable.itemID..".")

		Clockwork.inventory:AddInstance(inventory, itemTable)
			netstream.Start(self, "InvGive", item.GetDefinition(itemTable, true))
		hook.Run("PlayerItemGiven", self, itemTable, bForce)

		Clockwork.inventory:Rebuild(self)

		return itemTable
	else
		return false, "You can only carry up to four times your non-overencumbered carrying capacity!"
	end
end

-- A function to take an item from a player.
function playerMeta:TakeItem(itemTable, bRemoveInstance)
	if (!itemTable or !itemTable:IsInstance()) then
		debug.Trace()
		return false
	end

	local inventory = self:GetInventory()

	if (itemTable.OnTakeFromPlayer) then
		itemTable:OnTakeFromPlayer(self)
	end
	
	Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, self:Name().." has lost a "..itemTable.name.." "..itemTable.itemID..".")

	hook.Run("PlayerItemTaken", self, itemTable);
	
	if self:GetItemEquipped(itemTable) then
		Clockwork.kernel:ForceUnequipItem(self, itemTable.uniqueID, itemTable.itemID);
	end
	
	Clockwork.inventory:RemoveInstance(inventory, itemTable);
	netstream.Start(self, "InvTake", {itemTable.index, itemTable.itemID, bRemoveInstance});
	
	if bRemoveInstance then
		item.RemoveInstance(itemTable.itemID);
	end
	
	Clockwork.inventory:Rebuild(self);

	return true
end

-- An easy function to give a table of items to a player.
function playerMeta:GiveItems(itemTables)
	for _, itemTable in pairs(itemTables) do
		self:GiveItem(itemTables)
	end
end

-- An easy function to take a table of items from a player.
function playerMeta:TakeItems(itemTables, bRemoveInstances)
	for _, itemTable in pairs(itemTables) do
		self:TakeItem(itemTable, bRemoveInstances)
	end
end

-- A function to update a player's attribute.
function playerMeta:UpdateAttribute(attribute, amount)
	return Clockwork.attributes:Update(self, attribute, amount)
end

-- A function to progress a player's attribute.
function playerMeta:ProgressAttribute(attribute, amount, gradual)
	return Clockwork.attributes:Progress(self, attribute, amount, gradual)
end

-- A function to boost a player's attribute.
function playerMeta:BoostAttribute(identifier, attribute, amount, duration)
	return Clockwork.attributes:Boost(self, identifier, attribute, amount, duration)
end

-- A function to get whether a boost is active for a player.
function playerMeta:IsBoostActive(identifier, attribute, amount, duration)
	return Clockwork.attributes:IsBoostActive(self, identifier, attribute, amount, duration)
end

-- A function to get a player's characters.
function playerMeta:GetCharacters()
	return self.cwCharacterList
end

-- A function to set a player's run speed.
function playerMeta:SetRunSpeed(speed, bClockwork)
	local final_speed = speed;

	if (!bClockwork) then
		self.cwRunSpeed = final_speed; 
	end
	
	self:ClockworkSetRunSpeed(final_speed)
end

-- A function to set a player's walk speed.
function playerMeta:SetWalkSpeed(speed, bClockwork)
	local final_speed = speed;

	if (!bClockwork) then
		self.cWalkSpeed = final_speed;
	end
	
	self:ClockworkSetWalkSpeed(final_speed);
end

-- A function to set a player's jump power.
function playerMeta:SetJumpPower(power, bClockwork)
	local final_power = power;
	
	if (!bClockwork) then
		self.cwJumpPower = final_power;
	end
	
	self:ClockworkSetJumpPower(final_power)
end

-- A function to set a player's crouched walk speed.
function playerMeta:SetCrouchedWalkSpeed(speed, bClockwork)
	local final_speed = speed;

	if (!bClockwork) then
		self.cwCrouchedSpeed = final_speed; 
	end
	
	self:ClockworkSetCrouchedWalkSpeed(final_speed);
end

-- A function to get whether a player has initialized.
function playerMeta:HasInitialized()
	return self.cwInitialized
end

-- A function to query a player's character table.
function playerMeta:QueryCharacter(key, default)
	if (self.cwCharacter) then
		return Clockwork.player:Query(self, key, default)
	else
		return default
	end
end

-- A function to get a player's shared variable.
function playerMeta:GetSharedVar(key, default)
	return self:GetNetVar(key, default)
end

-- A function to set a shared variable for a player.
function playerMeta:SetSharedVar(key, value, sharedTable)
	return self:SetNetVar(key, value)
end

-- A function to get a player's character data.
function playerMeta:GetCharacterData(key, default)
	local data = self:QueryCharacter("Data")

	if data then
		if (data[key] != nil) then
			return data[key]
		end
	end

	return default
end

-- A function to get a player's time joined.
function playerMeta:TimeJoined()
	return self.cwTimeJoined or os.time()
end

-- A function to get when a player last played.
function playerMeta:LastPlayed()
	return self.cwLastPlayed or os.time()
end

-- A function to get the entity a player is holding.
function playerMeta:GetHoldingEntity()
	return hook.Run("PlayerGetHoldingEntity", self) or self.cwIsHoldingEnt
end

-- A function to check if a player can afford an amount.
function playerMeta:CanAfford(amount)
	return Clockwork.player:CanAfford(self, amount)
end

-- A function to get a player's rank within their faction.
function playerMeta:GetFactionRank(character)
	return Clockwork.player:GetFactionRank(self, character)
end

-- A function to set a player's rank within their faction.
function playerMeta:SetFactionRank(rank)
	return Clockwork.player:SetFactionRank(self, rank)
end

-- A function to get a player's global flags.
function playerMeta:GetPlayerFlags()
	return Clockwork.player:GetPlayerFlags(self)
end

-- Set a player to be muted.
function playerMeta:SetMuted(bMuted)
	self.muted = bMuted;
end

-- Check if a player is muted.
function playerMeta:IsMuted()
	return self.muted;
end

playerMeta.GetName = playerMeta.Name
playerMeta.Nick = playerMeta.Name

concommand.Add("cwStatus", function(player, command, arguments)
	if (IsValid(player)) then
		if (Clockwork.player:IsAdmin(player)) then
			player:PrintMessage(2, "# User ID | Name | Steam Name | Steam ID | IP Address")

			for _, v in _player.Iterator() do
				if (v:HasInitialized()) then
					local status = hook.Run("PlayerCanSeeStatus", player, v)

					if (status) then
						player:PrintMessage(2, status)
					end
				end
			end
		else
			player:PrintMessage(2, "You do not have access to this command, "..player:Name()..".")
		end
	else
		print("# User ID | Name | Steam Name | Steam ID | IP Address")

		for k, v in ipairs(plyTable) do
			if (v:HasInitialized()) then
				print("# "..v:UserID().." | "..v:Name().." | "..v:SteamName().." | "..v:SteamID().." | "..v:IPAddress())
			end
		end
	end
end)

-- The most awfully written function in Clockwork.
-- Allows you to call certain commands from server console.
-- ToDo: Rewrite everything to be shorter
concommand.Add("cwc", function(player, command, arguments)
	-- Yep, it's awfully written, but it's not meant to be edited, so...
	local cmdTable = {
		sg	= "setgroup",
		d	 = "demote",
		sc	= "setcash",
		w	 = "whitelist",
		uw	= "unwhitelist",
		b	 = "ban",
		k	 = "kick",
		sn	= "setname",
		sm	= "setmodel",
		r	 = "restart",
		gf	= "giveflags",
		tf	= "takeflags"
	}
	
	if IsValid(player) then
		if !player:IsAdmin() then
			Schema:EasyText(Schema:GetAdmins(), "firebrick", "Player "..player:Name().." has attempted to run cwc with the arguments ("..table.concat(arguments, ", ")..") in console! It could be a bind or it could be malicious.");
		end
	end

	--	if called from console
	if (!IsValid(player)) then
		-- PlySetGroup
		if (arguments[1] == cmdTable.sg) then
			local target = _player.Find(arguments[2])
			local userGroup = arguments[3]

			if (userGroup != "superadmin" and userGroup != "admin" and userGroup != "operator") then
				MsgC(Color(255, 100, 0, 255), "The user group must be superadmin, admin or operator!\n")

				return
			end

			if (target) then
				if (!Clockwork.player:IsProtected(target)) then
					print("Console has set "..target:Name().."'s user group to "..userGroup..".")
					Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has set "..target:Name().."'s user group to "..userGroup..".")
						target:SetClockworkUserGroup(userGroup)
					Clockwork.player:LightSpawn(target, true, true)
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n")
			end

			return
		-- PlyDemote
		elseif (arguments[1] == cmdTable.d) then
			local target = _player.Find(arguments[2])

			if (target) then
				if (!Clockwork.player:IsProtected(target)) then
					local userGroup = target:GetClockworkUserGroup()

					if (userGroup != "user") then
						print("Console has demoted "..target:Name().." from "..userGroup.." to user.")
						Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has demoted "..target:Name().." from "..userGroup.." to user.")
							target:SetClockworkUserGroup("user")
						Clockwork.player:LightSpawn(target, true, true)
					else
						MsgC(Color(255, 100, 0, 255), "This player is only a user and cannot be demoted!\n")
					end
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n")
			end

			return
		-- SetCash
		elseif (arguments[1] == cmdTable.sc) then
			local target = _player.Find(arguments[2])
			local cash = math.floor(tonumber((arguments[3] or 0)))

			if (target) then
				if (cash and cash >= 1) then
					local playerName = "Console"
					local targetName = target:Name()
					local giveCash = cash - target:GetCash()

					Clockwork.player:GiveCash(target, giveCash)

					print("Console has set "..targetName.."'s cash to "..Clockwork.kernel:FormatCash(cash, nil, true)..".")
				else
					MsgC(Color(255, 100, 0, 255), "This is not a valid amount!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n")
			end

			return
		-- PlyWhitelist
		elseif (arguments[1] == cmdTable.w) then
			local target = _player.Find(arguments[2])

			if (target) then
				local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 3))

				if (factionTable) then
					if (factionTable.whitelist) then
						if (!Clockwork.player:IsWhitelisted(target, factionTable.name)) then
							Clockwork.player:SetWhitelisted(target, factionTable.name, true)
							Clockwork.player:SaveCharacter(target)

							print("Console has added "..target:Name().." to the "..factionTable.name.." whitelist.")
							Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has added "..target:Name().." to the "..factionTable.name.." whitelist.")
						else
							MsgC(Color(255, 100, 0, 255), target:Name().." is already on the "..factionTable.name.." whitelist!\n")
						end
					else
						MsgC(Color(255, 100, 0, 255), factionTable.name.." does not have a whitelist!\n")
					end
				else
					MsgC(Color(255, 100, 0, 255), table.concat(arguments, " ", 3).." is not a valid faction!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n")
			end

			return
		-- PlyUnWhitelist
		elseif (arguments[1] == cmdTable.uw) then
			local target = _player.Find(arguments[2])

			if (target) then
				local factionTable = Clockwork.faction:FindByID(table.concat(arguments, " ", 3))

				if (factionTable) then
					if (factionTable.whitelist) then
						if (Clockwork.player:IsWhitelisted(target, factionTable.name)) then
							Clockwork.player:SetWhitelisted(target, factionTable.name, false)
							Clockwork.player:SaveCharacter(target)

							print("Console has removed "..target:Name().." from the "..factionTable.name.." whitelist.")
							Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has removed "..target:Name().." from the "..factionTable.name.." whitelist.")
						else
							MsgC(Color(255, 100, 0, 255), target:Name().." is not on the "..factionTable.name.." whitelist!\n")
						end
					else
						MsgC(Color(255, 100, 0, 255), factionTable.name.." does not have a whitelist!\n")
					end
				else
					MsgC(Color(255, 100, 0, 255), factionTable.name.." is not a valid faction!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n")
			end

			return
		-- PlyBan
		elseif (arguments[1] == cmdTable.b) then
			local schemaFolder = Clockwork.kernel:GetSchemaFolder()
			local duration = tonumber(arguments[3])
			local reason = table.concat(arguments, " ", 4)

			if (!reason or reason == "") then
				reason = nil
			end

			if (!Clockwork.player:IsProtected(arguments[2])) then
				if (duration) then
					Clockwork.bans:Add(arguments[2], duration * 60, reason, function(steamName, duration, reason)
						if (IsValid(player)) then
							if (steamName) then
								if (duration > 0) then
									local hours = math.Round(duration / 3600)

									if (hours >= 1) then
										print("Console has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").")
										Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").")
									else
										print("Console has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").")
										Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").")
									end
								else
									print("Console has banned '"..steamName.."' permanently ("..reason..").")
									Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has banned '"..steamName.."' permanently ("..reason..").")
								end
							else
								MsgC(Color(255, 100, 0, 255), "This is not a valid identifier!\n")
							end
						end
					end)
				else
					MsgC(Color(255, 100, 0, 255), "This is not a valid duration!\n")
				end
			else
				local target = _player.Find(arguments[2])

				if (target) then
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n")
				else
					MsgC(Color(255, 100, 0, 255), "This player is protected!\n")
				end
			end

			return
		-- PlyKick
		elseif (arguments[1] == cmdTable.k) then
			local target = _player.Find(arguments[2])
			local reason = table.concat(arguments, " ", 3)

			if (!reason or reason == "") then
				reason = "N/A"
			end

			if (target) then
				if (!Clockwork.player:IsProtected(arguments[2])) then
					print("Console has kicked '"..target:Name().."' ("..reason..").")
					Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has kicked '"..target:Name().."' ("..reason..").")
						target:Kick(reason)
					target.kicked = true
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n")
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[1].." is not a valid player!\n")
			end

			return
		-- CharSetName
		elseif (arguments[1] == cmdTable.sn) then
			local target = _player.Find(arguments[2])

			if (target) then
				if (arguments[3] == "nil") then
					MsgC(Color(255, 100, 0, 255), "You have to specify the name as the last argument, it also has to be 'quoted'.\n")

					return
				else
					local name = table.concat(arguments, " ", 3)

					print("Console has set "..target:Name().."'s name to "..name..".")
					Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has set "..target:Name().."'s name to "..name..".")

					Clockwork.player:SetName(target, name)
				end
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n")
			end

			return
		-- CharSetModel
		elseif (arguments[1] == cmdTable.sm) then
			local target = _player.Find(arguments[2])

			if (target) then
				local model = table.concat(arguments, " ", 3)

				target:SetCharacterData("Model", model, true)
				target:SetModel(model)

				print("Console has set "..target:Name().."'s model to "..model..".")
				Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console has set "..target:Name().."'s model to "..model..".")
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n")
			end

			return
		-- MapRestart
		elseif (arguments[1] == cmdTable.r) then
			local delay = tonumber(arguments[2]) or 10

			if (type(arguments[2]) == "number") then
				delay = arguments[2]
			end

			print("Console is restarting the map in "..delay.." seconds!")
			Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console is restarting the map in "..delay.." seconds!")

			timer.Simple(delay, function()
				RunConsoleCommand("changelevel", game.GetMap())
			end)

			return
		-- GiveFlags
		elseif (arguments[1] == cmdTable.gf) then
			local target = _player.Find(arguments[2])

			if (target) then
				if (string.find(arguments[3], "a") or string.find(arguments[3], "s") or string.find(arguments[3], "o")) then
					MsgC(Color(255, 100, 0, 255), "You cannot give 'o', 'a' or 's' flags!\n")

					return
				end

				if (!arguments[3]) then print("You haven't entered any flags!") return end

				Clockwork.player:GiveFlags(target, arguments[3])

				print("Console gave "..target:Name().." '"..arguments[3].."' flags.")
				Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console gave "..target:Name().." '"..arguments[3].."' flags.")
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n")
			end

			return
		-- TakeFlags
		elseif (arguments[1] == cmdTable.tf) then
			local target = _player.Find(arguments[2])

			if (target) then
				if (string.find(arguments[3], "a") or string.find(arguments[3], "s") or string.find(arguments[3], "o")) then
					Schema:EasyText(player, "grey", "You cannot take 'o', 'a' or 's' flags!")

					return
				end

				if (!arguments[3]) then print("You haven't entered any flags!") return end

				Clockwork.player:TakeFlags(target, arguments[3])

				print("Console took '"..arguments[3].."' flags from "..target:Name()..".")
				Schema:EasyText(Schema:GetAdmins(), "lightslategrey", "Console took '"..arguments[3].."' flags from "..target:Name()..".")
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n")
			end

			return
		-- Everything else
		else
			MsgC(Color(255, 100, 0, 255), "'"..arguments[1].. "' command not found!\n")
		end
	-- if not too bad, players are not allowed to use this swag
	else
		
	end
end)

concommand.Add("cwDeathCode", function(player, command, arguments)
	if (player.cwDeathCodeIdx) then
		if (arguments and tonumber(arguments[1]) == player.cwDeathCodeIdx) then
			player.cwDeathCodeAuth = true
		end
	end
end)

local playerMeta = FindMetaTable("Player")

-- A function to get a player's lending account Steam ID.
function playerMeta:GetLender()
	if (self.cwLenderSteamID) then
		return self.cwLenderSteamID;
	else
		return "";
	end;
end;

function playerMeta:NetworkTraits()
	hook.Run("SetTraitSharedVars", self);

	netstream.Start(self, "TraitSync", self:GetCharacterData("Traits"));
end

-- A function to give a trait to a player.
function playerMeta:GiveTrait(uniqueID)
	local traits = self:GetCharacterData("Traits");
		
	if (traits and not table.HasValue(traits, uniqueID)) then
		table.insert(traits, uniqueID);
		
		self:SetCharacterData("Traits", traits);
		self:NetworkTraits();
		
		hook.Run("PlayerTraitGiven", self, uniqueID);
	end;
end;

-- A function to remove a trait from a player.
function playerMeta:RemoveTrait(uniqueID)
	local traits = self:GetCharacterData("Traits");
		
	if traits then
		for i = 1, #traits do
			if traits[i] == uniqueID then
				table.remove(traits, i);
				self:SetCharacterData("Traits", traits);
				self:NetworkTraits();
				
				hook.Run("PlayerTraitTaken", self, uniqueID);
				
				return;
			end
		end
	end;
end;

-- A function to get whether a player has a trait.
function playerMeta:HasTrait(uniqueID)
	local traits = self:GetCharacterData("Traits");
	
	if (traits and table.HasValue(traits, uniqueID)) then
		return true;
	end;
end;

-- A function to get a player's traits.
function playerMeta:GetTraits()
	return self:GetCharacterData("Traits");
end;

-- A function to set a player's character data.
function playerMeta:SetCharacterData(key, value, bFromBase)
	local character = self.cwCharacter

	if (!character) then return end

	if (bFromBase) then
		key = Clockwork.kernel:SetCamelCase(key, true)

		if (character[key] != nil) then
			character[key] = value
		end
	else
		local oldValue = character.data[key]
		character.data[key] = value

		if (!netvars.AreEqual(value, oldValue)) then
			Clockwork.player:UpdateCharacterData(self, key, value)

			--plugin.Call("PlayerCharacterDataChanged", self, key, oldValue, value)
			hook.Run("PlayerCharacterDataChanged", self, key, oldValue, value)
		end
	end
end

-- A function to set a player's data.
function playerMeta:SetData(key, value)
	if (self.CustomData) then
		local oldValue = self.CustomData[key]
		self.CustomData[key] = value

		if (value != oldValue) then
			Clockwork.player:UpdatePlayerData(self, key, value)
			--plugin.Call("PlayerDataChanged", self, key, oldValue, value)
			hook.Run("PlayerDataChanged", self, key, oldValue, value)
		end
	end
end

concommand.Add("OpenMenu", function(player)
	hook.Run("PlayerOpenedMenu", player);
end);

concommand.Add("CloseMenu", function(player)
	hook.Run("PlayerClosedMenu", player);
end);