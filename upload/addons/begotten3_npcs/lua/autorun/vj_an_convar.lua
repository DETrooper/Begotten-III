/*--------------------------------------------------
	=============== Flesh Zombies ConVars ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load ConVars for Flesh Zombies
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-------------------------------------------------------------------
local AddConvars = {}

for k, v in pairs(AddConvars) do
	if !ConVarExists( k ) then CreateConVar( k, v, {FCVAR_NONE} ) end
end