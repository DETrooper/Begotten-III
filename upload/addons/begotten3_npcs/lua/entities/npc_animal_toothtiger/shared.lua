ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Saber-Toothed Cat"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Animals"

if (CLIENT) then
local Name = "Saber-Toothed Cat"
local LangName = "npc_animal_toothtiger"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end