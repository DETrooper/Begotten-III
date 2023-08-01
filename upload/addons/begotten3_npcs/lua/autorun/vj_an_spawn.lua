/*--------------------------------------------------
	=============== Flesh Zombies Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Flesh Zombies
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "Begotten"
VJ.AddNPC("Bear","npc_animal_bear",vCat)
VJ.AddNPC("Cave Bear","npc_animal_cave_bear",vCat)
VJ.AddNPC("Goat","npc_animal_goat",vCat)
VJ.AddNPC("Deer","npc_animal_deer",vCat)
VJ.AddNPC("Snow Leopard","npc_animal_leopard",vCat)
VJ.AddNPC("Saber-Toothed Cat","npc_animal_toothtiger",vCat)
VJ.AddNPC("King Cobra","npc_animal_kingcobra",vCat)