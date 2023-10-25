AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/goat.mdl" 
ENT.StartHealth = 55
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.ZombieFriendly = false -- Makes the SNPC friendly to the HL2 Zombies
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 130 -- How far the damage goes

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"die"} -- Death Animations
ENT.DeathAnimationTime = 10 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasDeathRagdoll = false

ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.6 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking

ENT.TimeUntilMeleeAttackDamage = 1.05 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 1.6 -- How much time until it can use a attack again? | Counted in Seconds
ENT.ArmorPiercing = 5;
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackDamageType = DMG_CLUB -- Type of Damage
ENT.HasDeathAnimation = false -- plays an animation when it dies
ENT.DeathAnimationSCHED = SCHED_DIE -- The animation for DeathAnim
ENT.DeathAnimationTime = 1
ENT.HasDeathRagdoll = true -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.PlayerFriendly = true -- When true, it will still attack If you attack to much, also this will make it friendly to rebels and characters like that
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 3 -- How many times does the player have to hit the SNPC for it to become enemy?
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"armormovement/body-lobe-1.wav.mp3","armormovement/body-lobe-2.wav.mp3","armormovement/body-lobe-3.wav.mp3"}
ENT.SoundTbl_Idle = {"goat/idle1.wav"}
ENT.SoundTbl_Alert = {"goat/idle1.wav"}
ENT.SoundTbl_MeleeAttack = {"physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"bear/woosh1.wav"}
ENT.SoundTbl_Pain = {"goat/idle1.wav"}
ENT.SoundTbl_Death = {"goat/idle1.wav"}

ENT.AllowPrintingInChat = false;
ENT.XPValue = 30;

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(35, 35 , 90), Vector(-35, -35, 0))
	--self:SetModelScale(0.7)
end

function ENT:CreateDeathCorpse(dmginfo,hitgroup)	
	self.HasDeathRagdoll = true -- Disable ragdoll
	self.HasDeathAnimation = true -- Disable death animation
	
	local gib = ents.Create( "prop_ragdoll" )
	gib:SetModel( "models/animals/goat.mdl" )
	gib:SetPos( self:LocalToWorld(Vector(0,0,0))) -- The Postion the model spawns
	gib:SetAngles( self:GetAngles() )
	gib:Spawn()
	
	timer.Simple(600, function()
		if IsValid(gib) then
			gib:Remove();
		end
	end);
end


/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/