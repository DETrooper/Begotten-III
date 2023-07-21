SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Spear + Shield
-- SHIELD TYPE: shield6 (Iron Shield)

SWEP.PrintName = "Scrap Spear + Iron Shield"
SWEP.Category = "(Begotten) Spear"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_spear_shield"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_spear_shield_block_pursuer"
SWEP.CriticalAnim = "a_spear_shield_attack"
SWEP.ParryAnim = "a_spear_shield_parry"

SWEP.IronSightsPos = Vector(4.88, -9.447, 4.039)
SWEP.IronSightsAng = Vector(0, 1.406, -14.775)

--Sounds
SWEP.AttackSoundTable = "MetalSpearAttackSoundTable"
SWEP.BlockSoundTable = "MetalShieldSoundTable"
SWEP.SoundMaterial = "MetalPierce" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "ScrapSpearAttackTable"
SWEP.BlockTable = "Shield_6_BlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self.Owner:GetViewModel():SetPlaybackRate(0.8)	
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
	self:TriggerAnim(self.Owner, "a_spear_shield_attack");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self.Owner:GetViewModel():SetPlaybackRate(0.8)	
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
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
	["v_spear_poolcue"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/poolcue.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0.518, 0.518, -6.753), angle = Angle(-3.507, 132.078, -1.17), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 3} },
	["quad"] = { type = "Quad", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(9.383, -80, -50.864), angle = Angle(-52.223, -116.667, -7.778), size = 0.2, draw_func = nil},
	["v_shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(15.064, -0.519, -0.519), angle = Angle(61.948, 80.649, -15.195), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_spear_poolcue"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/poolcue.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 4.199, 14.026), angle = Angle(-180, -8.183, -10.52), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[0] = 3} },
	["w_shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.5, 1.5, 0), angle = Angle(100, 67.5, 0), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}