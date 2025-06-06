--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork = Clockwork or {}

if (!IsValid(Clockwork.Client)) then
	Clockwork.Client = LocalPlayer()
end;

if (!string.utf8len or !pon or !netstream) then
	include("external/utf8.lua")
	include("external/pon.lua")
	include("external/netstream.lua")
	include("external/md5.lua")
end

include("Clockwork.lua")
include("shared.lua")