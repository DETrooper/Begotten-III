AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/deer1.mdl" 
ENT.StartHealth = 70
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the nuumber is the more chance is has to spawn | 500 is a good number | Make the number smaller if you are using big decal like Antlion Splat
ENT.HasCustomBloodPoolParticle = true -- Should the SNPC have custom blood pool particle?
ENT.CustomBloodPoolParticle = "vj_bleedout_red_small" -- The custom blood pool particle
ENT.ZombieFriendly = true -- Makes the SNPC friendly to the HL2 Zombies
ENT.AntlionFriendly = true -- Makes the SNPC friendly to the Antlions
ENT.CombineFriendly = true -- Makes the SNPC friendly to the Combine
ENT.PlayerFriendly = true -- When true, this will make it friendly to rebels and characters like that
ENT.BrokenBloodSpawnUp = 10 -- Positive Number = Up | Negative Number = Down
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"deer/idle1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(45, 5 , 60), Vector(-45, -5, 0))
	
end




/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/