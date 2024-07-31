SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Polearm

SWEP.PrintName = "Gatekeeper Poleaxe"
SWEP.Category = "(Begotten) Polearm"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_spear_2h"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_spear_2h_block"
SWEP.CriticalAnim = "a_spear_2h_halberd_attack2_fast"
SWEP.ParryAnim = "a_spear_2h_parry"

SWEP.IronSightsPos = Vector(3.64, -8.04, -6.56)
SWEP.IronSightsAng = Vector(10, 0.703, 50)

--Sounds
SWEP.AttackSoundTable = "MetalPolearmAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GatekeeperPoleaxeAttackTable"
SWEP.BlockTable = "GatekeeperPoleaxeBlockTable"

-- For polearms only
SWEP.ShortPolearm = true
SWEP.CanSwipeAttack = false
SWEP.MultiHit = 2;

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.33)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)	
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
end 

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	if IsValid(self) then
		self:TriggerAnim(self.Owner, "a_spear_2h_halberd_attack1_fast");
	end
	
	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.33)
	
	self:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_spear_2h_attack_medium");

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.5)
	
	self:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,5,0))
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.444, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -12.789), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0, 2.407), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.3, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.925), angle = Angle(-56.667, 0, 0) }
}

SWEP.VElements = {
	["v_gatekeeperpoleaxe"] = { type = "Model", model = "models/witcher2soldiers/tw2_halberd.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(4.5, -3.5, -25), angle = Angle(-5.2, 160.13, 80.649), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_gatekeeperpoleaxe"] = { type = "Model", model = "models/witcher2soldiers/tw2_halberd.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 4.9, 20), angle = Angle(-3.6, 162.468, -101.689), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}