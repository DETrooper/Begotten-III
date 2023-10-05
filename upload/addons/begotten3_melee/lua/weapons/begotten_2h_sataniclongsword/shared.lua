SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Two Handed

SWEP.PrintName = "Satanic Longsword"
SWEP.Category = "(Begotten) Two Handed"
 
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h"

SWEP.ViewModel = "models/c_begotten_zweihander.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
 
--Anims
SWEP.BlockAnim = "a_heavy_2h_block"
SWEP.CriticalAnim = "a_heavy_2h_attack_slash_02"
SWEP.ParryAnim = "a_heavy_2h_parry"

SWEP.IronSightsPos = Vector(-15.32, 2, -6)
SWEP.IronSightsAng = Vector(4, -8.443, -60)

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.9
SWEP.PrimaryPlaybackRate = 0.9
SWEP.PrimaryIdleDelay = 0.85
SWEP.AltPlaybackRate = 0.65
SWEP.AltIdleDelay = 0.75
SWEP.PrimarySwingAnim = "a_heavy_2h_attack_slash_0"
SWEP.MultiHit = 2;

--Sounds
SWEP.AttackSoundTable = "HeavyMetalAttackSoundTable" 
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "SatanicLongswordAttackTable"
SWEP.BlockTable = "SatanicLongswordBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(self.CriticalPlaybackRate)
	self:IdleAnimationDelay( 1, 1 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	self:SendWeaponAnim(ACT_VM_UNDEPLOY); self.Owner:GetViewModel():SetPlaybackRate(1.3)
	self.Owner:ViewPunch(Angle(-30,0,0))
	self:IdleAnimationDelay( 1.5, 1.5 )
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, self.PrimarySwingAnim..math.random(1,2));

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
			self.Owner:GetViewModel():SetPlaybackRate(0.7)
			self:IdleAnimationDelay( 0.9, 0.9 )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
			self.Owner:GetViewModel():SetPlaybackRate(0.7)
			self:IdleAnimationDelay( 0.9, 0.9 )
		end
	end
end

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	end end)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_heavy_2h_attack_stab_01");

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)
	self:IdleAnimationDelay( 0.8, 0.8 )
	
	self.Owner:ViewPunch(Angle(6,0,0))

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end

function SWEP:IdleAnimationDelay( seconds, index )
	timer.Remove( self.Owner:EntIndex().."IdleAnimation" )
	self.Idling = index
	timer.Create( self.Owner:EntIndex().."IdleAnimation", seconds, 1, function()
		if not self:IsValid() or self.Idling == 0 then return end
		if self.Idling == index then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
			self.Owner:GetViewModel():SetPlaybackRate(1)
		end
	end )
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -5.5), angle = Angle(-20, 0, 5.556) }
}

SWEP.VElements = {
	["v_sataniclongsword"] = { type = "Model", model = "models/skyrim/draugr/greatsword/w_draugrgreatsword.mdl", bone = "RW_Weapon", rel = "", pos = Vector(2, 0.349, 2.5), angle = Angle(-5.844, 155.455, -1.17), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_sataniclongsword"] = { type = "Model", model = "models/skyrim/draugr/greatsword/w_draugrgreatsword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, -0.69, 1.557), angle = Angle(15.194, -29.222, 176.494), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 3} }
}