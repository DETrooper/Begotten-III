--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

PLUGIN:SetGlobalAlias("cwDynamicAdverts")

util.Include("cl_plugin.lua")
util.Include("sv_plugin.lua")
util.Include("sv_hooks.lua")
util.Include("cl_hooks.lua")

cwDynamicAdverts.storedList = cwDynamicAdverts.storedList or {};