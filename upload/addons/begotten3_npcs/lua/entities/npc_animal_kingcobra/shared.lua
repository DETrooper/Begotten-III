ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "King Cobra"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Animals"

if (CLIENT) then
local Name = "King Cobra"
local LangName = "npc_animal_kingcobra"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end