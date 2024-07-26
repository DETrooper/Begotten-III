SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Two Handed (Great Weapon)

SWEP.PrintName = "Club"
SWEP.Category = "(Begotten) Two Handed"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h_great"

SWEP.ViewModel = "models/weapons/c_kaine_sword.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_heavy_great_block"
SWEP.CriticalAnim = "a_heavy_great_attack_slash_02"
SWEP.ParryAnim = "a_heavy_great_parry"
SWEP.IronSightsPos = Vector(-15, 3, -8)
SWEP.IronSightsAng = Vector(0, 0, -60)

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.9
SWEP.PrimaryPlaybackRate = 0.85
SWEP.PrimaryIdleDelay = 0.9
SWEP.AltPlaybackRate = nil
SWEP.AltIdleDelay = nil
SWEP.PrimarySwingAnim = "a_heavy_great_attack_slash_01"

--Sounds
SWEP.AttackSoundTable = "HeavyWoodenAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Wooden" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "ClubAttackTable"
SWEP.BlockTable = "ClubBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(self.CriticalPlaybackRate)
	self:IdleAnimationDelay( 1, 1 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(10,1,1))
	end
	
end

function SWEP:ParryAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW); self.Owner:GetViewModel():SetPlaybackRate(1.3)
	self.Owner:ViewPunch(Angle(-30,0,0))
	self:IdleAnimationDelay( 1.5, 1.5 )
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, self.PrimarySwingAnim);

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 3 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_MISSRIGHT)
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 3  and self:IsValid() then
			self.Owner:ViewPunch(Angle(6,0,0))
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )
		end
	end
end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
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
	["LeftArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.25, -0.25, 0), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Root"] = { scale = Vector(1, 1, 1), pos = Vector(-5, 0.185, 1.296), angle = Angle(-5.558, -76.667, 0) }
}

SWEP.VElements = {
	["v_club"] = { type = "Model", model = "models/demonssouls/weapons/club.mdl", bone = "RW_Weapon", rel = "", pos = Vector(-0.19, -0.03, -1), angle = Angle(98.9, 122.726, -101.689), size = Vector(0.879, 0.879, 0.879), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_club"] = { type = "Model", model = "models/demonssouls/weapons/club.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.596, 1.557, 1.557), angle = Angle(85.324, 85.324, -22.209), size = Vector(1.1, 1.1, 1.1), material = "", skin = 0, bodygroup = {} }
}