AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/toothtiger.mdl" 
ENT.StartHealth = 1500
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 235 -- How far the damage goes

ENT.TimeUntilMeleeAttackDamage = 1.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.3 -- How much time until it can use a attack again? | Counted in Seconds
ENT.ArmorPiercing = 100;
ENT.MeleeAttackDamage = 80
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"die"} -- Death Animations
ENT.DeathAnimationTime = 4 -- Time until the SNPC spawns its corpse and gets removed
ENT.HasDeathRagdoll = true
	-- ====== Flinching Code ====== --
ENT.Flinches = 2 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {}
ENT.SoundTbl_Idle = {"leopard/idle1.wav"}
ENT.SoundTbl_Alert = {"leopard/attack1.wav"}
ENT.SoundTbl_MeleeAttack = {"leopard/attack1.wav"}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_Pain = {"leopard/idle1.wav"}
ENT.SoundTbl_Death = {"leopard/idle1.wav"}

ENT.AllowPrintingInChat = false;
ENT.XPValue = 250;

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(150, 18, 110), Vector(-120, -18, 0))
end

function ENT:CreateDeathCorpse(dmginfo,hitgroup)	
	self.HasDeathRagdoll = true -- Disable ragdoll
	self.HasDeathAnimation = true -- Disable death animation
	
	local gib = ents.Create( "prop_ragdoll" )
	gib:SetModel( "models/animal_ragd/piratecat_toothtiger.mdl" )
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