--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]
SilentMode = true
if (SERVER) then
	function printp(t)
		print(tostring(t));
		for k, v in pairs (_player.GetAll()) do
			if (v:IsAdmin()) then
				if (SilentMode) then
					Msg(tostring(t))
				else
					Msg(tostring(t))
					--v:ChatPrint(tostring(t));
				end;
			end;
		end;
	end;
else
	function printp(t)
		if (!IsValid(Clockwork.Client) or !Clockwork.Client.ChatPrint) then
			return;
		end;
		
		if (Clockwork.Client:IsAdmin()) then
			if (SilentMode) then
				print(tostring(t))
			else
				print(tostring(t))
				--Clockwork.Client:ChatPrint(tostring(t));
			end;
		end;
	end;
end;

_player, _team, _file, _sound = player, team, file, sound

GM.Name 	 = "Clockwork"
GM.Author 	 = "kurozael"
GM.Website 	 = "http://cloudsixteen.com/"
GM.Email 	 = ""

GM.Version 	 = "1"
GM.Description = "A roleplaying framework."

Clockwork.ClockworkFolder = Clockwork.ClockworkFolder or GM.Folder
Clockwork.SchemaFolder = Clockwork.SchemaFolder or GM.Folder
Clockwork.KernelVersion = "1"

Clockwork.DebugMode = true
Clockwork.DeveloperVersion = true

--[[
	Specify the level of logs.
	You really want to keep it at 3 if you don't know what you are doing.
	0 = no prints messages at all.
	1 = error messages only.
	2 = error messages and warnings only.
	3 = error, warning and good messages only.
	4 = everything, including developer messages to debug stuff.
	5 = a lot of spam in console. dangerous.
--]]

Clockwork.LogLevel = 4

if (SERVER) then
	Clockwork.Schema = engine.ActiveGamemode() or "cwbegotten"
end

if (SERVER) then
	function GM:GetGameDescription()
		return "Begotten III: Jesus Wept";
	end
	
	if (!gamemodeNameOverride) then
		RunConsoleCommand("sv_gamename_override", "Begotten III: Jesus Wept");
		gamemodeNameOverride = true;
	end;
end;



if (_G["cwSharedBooted"] and !Clockwork.DeveloperVersion and !Clockwork.DebugMode) then
	util.IncludeDirectory("clockwork/framework/hooks/")
		print("[Clockwork] Aborting full Lua refresh (not in developer mode).")
	return
end

AddCSLuaFile()
AddCSLuaFile("clockwork/framework/cl_kernel.lua")
AddCSLuaFile("clockwork/framework/sh_kernel.lua")
AddCSLuaFile("clockwork/framework/sh_enum.lua")
include("clockwork/framework/sh_enum.lua")
include("clockwork/framework/sh_kernel.lua")

if (CLIENT) then
	if (CW_SCRIPT_SHARED) then
		CW_SCRIPT_SHARED = Clockwork.kernel:Deserialize(CW_SCRIPT_SHARED)
	else
		CW_SCRIPT_SHARED = {}
	end

	Clockwork.Schema = CW_SCRIPT_SHARED.schemaFolder or Clockwork.Schema or engine.ActiveGamemode() or "cwbegotten"
else
	CW_SCRIPT_SHARED = CW_SCRIPT_SHARED or {schemaFolder = Clockwork.Schema}
end

if (!game.GetWorld) then
	game.GetWorld = function() return Entity(0) end
end

if (plugin) then
	plugin.ClearCache()
end

util.Include("clockwork/framework/sv_kernel.lua")
util.Include("clockwork/framework/cl_kernel.lua")
util.IncludeDirectory("libraries/", true)
util.IncludeAllSubfolders("clockwork/framework/commands/");
util.IncludeDirectory("commands/", true)
util.IncludeDirectory("directory/", true)
util.IncludeDirectory("config/", true)

Clockwork.kernel:IncludePlugins("plugins/", true);
item.IncludeItems("clockwork/framework/items/")
util.IncludeAllSubfolders("clockwork/framework/items/");

util.IncludeDirectory("system/", true)
util.IncludeDirectory("derma/", true)
util.IncludeDirectory("clockwork/framework/hooks/")
util.IncludeDirectory("clockwork/framework/utils/")

do
	local startTime = os.clock()
	MsgC(Color(0, 0, 255), "[Clockwork]", Color(192, 192, 192), " Loading schema...\n")
	Clockwork.kernel:IncludeSchema()
	hook.Run("ClockworkSchemaLoaded")
	MsgC(Color(0, 0, 255), "[Clockwork]", Color(192, 192, 192), " Schema took "..math.Round(os.clock() - startTime, 3).." second(s) to load!\n")
end

if (SERVER) then
	MsgC(Color(0, 0, 255, 255), "[Clockwork]", Color(192, 192, 192), " Schema \""..Schema:GetName().."\" ["..Clockwork.kernel:GetSchemaGamemodeVersion().."] by "..Schema:GetAuthor().." loaded!\n")
else
	hook.Run("ClockworkLoadShared", CW_SCRIPT_SHARED)
end

Clockwork.player:AddCharacterData("PhysDesc", NWTYPE_STRING, "")
Clockwork.player:AddPlayerData("Quiz", NWTYPE_BOOL, false)

plugin.IncludeEntities("clockwork/framework/entities")

if (SERVER) then
	hook.Run("ClockworkSaveShared", CW_SCRIPT_SHARED)

	fileio.Write("lua/Clockwork.lua", "CW_SCRIPT_SHARED = [["..Clockwork.kernel:Serialize(CW_SCRIPT_SHARED).."]]")
	AddCSLuaFile("Clockwork.lua")
end

_G["cwSharedBooted"] = true

hook.Run("ClockworkLoaded")