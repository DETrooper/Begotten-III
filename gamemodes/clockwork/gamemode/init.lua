--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork = Clockwork or {}

do
	Clockwork.startTime = os.clock()
	local startTime = Clockwork.startTime

	local function SafeRequire(mod)
		local success, value = pcall(require, mod)

		if (!success) then
			ErrorNoHalt("[Clockwork] Critical Error - Failed to open '"..mod.."' module!\n")

			return false
		end

		return true
	end

	if (Clockwork and Clockwork.kernel) then
		MsgC(Color(0, 0, 255, 255), "[Clockwork]", Color(192, 192, 192), " Change detected! Refreshing...\n")
	else
		MsgC(Color(0, 0, 255, 255), "[Clockwork]", Color(192, 192, 192), " Framework is initializing...\n")
	end

	if (!SafeRequire("fileio")) then
		ErrorNoHalt("[Clockwork] fileio module has failed to load!\nAborting startup...\n")
		return
	end
	
	-- A function to get the amount of time since the server booted.
	function GetTimeSinceBoot()
		return math.Round(os.clock() - startTime, 3)
	end

	if (!string.utf8len or !pon or !netstream) then
		AddCSLuaFile("external/utf8.lua")
		AddCSLuaFile("external/pon.lua")
		AddCSLuaFile("external/netstream.lua")
		AddCSLuaFile("external/md5.lua")
	end

	AddCSLuaFile("cl_init.lua")

	if (!string.utf8len or !pon or !netstream or !vnet) then
		include("external/utf8.lua")
		include("external/pon.lua")
		include("external/netstream.lua")
		include("external/md5.lua")
	end

	include("shared.lua")

	if (Clockwork and cwBootComplete) then
		MsgC(Color(0, 0, 255, 255), "[Clockwork]", Color(192, 192, 192), " AutoRefresh handled serverside in "..GetTimeSinceBoot().. " second(s)\n")
	else
		MsgC(Color(0, 0, 255, 255), "[Clockwork]", Color(192, 192, 192), " Framework version ["..Clockwork.kernel:GetVersionBuild().."] loading took "..GetTimeSinceBoot().. " second(s)\n")
		Clockwork.LastBootTime = startTime
	end
end

_G["cwBootComplete"] = true