AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/bear.mdl" 
ENT.StartHealth = 550
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_FriendlyNPCsSingle = {"npc_animal_bear","npc_animal_cave_bear","npc_animal_deer"}
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 170 -- How far the damage goes

ENT.TimeUntilMeleeAttackDamage = 0.7 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.6 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 50
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.SlowPlyOnMelee = false -- If true, then the player will slow down
ENT.SlowPlyWalkS = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlyRunS = 100 -- Running Speed when Slow Player is on
ENT.SlowPlyTime = 5 -- How much time until player's Speed resets
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.MeleeAttackBleedEnemy = false  -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.35 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 1 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"armormovement/body-lobe-1.wav.mp3","armormovement/body-lobe-2.wav.mp3","armormovement/body-lobe-3.wav.mp3"}
ENT.SoundTbl_Idle = {"bear/idle1.wav","bear/idle2.wav"}
ENT.SoundTbl_Alert = {"bear/attack1.wav","bear/attack2.wav"}
ENT.SoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard1.wav","physics/body/body_medium_impact_hard2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"bear/woosh1.wav"}
ENT.SoundTbl_Pain = {"bear/attack1.wav"}
ENT.SoundTbl_Death = {"bear/idle3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(35, 35 , 60), Vector(-35, -35, 0))
    self:SetSkin(2)

end

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/