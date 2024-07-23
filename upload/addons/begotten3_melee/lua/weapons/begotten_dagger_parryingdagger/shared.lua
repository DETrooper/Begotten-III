SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dagger

SWEP.PrintName = "Parrying Dagger"
SWEP.Category = "(Begotten) Dagger"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h"

SWEP.ViewModel = "models/v_begottenknife.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_block"
SWEP.CriticalAnim = "a_sword_attack_stab_dagger"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(0, -11.86, -1.81)
SWEP.IronSightsAng = Vector(26.733, 0, 0)

--Sounds
SWEP.AttackSoundTable = "MetalDaggerAttackSoundTable" 
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.isDagger = true;

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "ParryingDaggerAttackTable"
SWEP.BlockTable = "ParryingDaggerBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.5)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ))
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_sword_attack_stab_dagger");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.5)
	
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

SWEP.VElements = {
	["v_parryingdagger"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, 0.518), angle = Angle(-87.663, 8.182, 120.389), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_parryingdagger"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.1, 0), angle = Angle(-90, 90, 36.234), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
	["v_left"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "Dummy16", rel = "", pos = Vector(0, -8.886, -0.1), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["v_right"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "Dummy01", rel = "", pos = Vector(0.5, -11.886, 0.5), angle = Angle(0, 90, 10), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.595, 1.157, 0.977), angle = Angle(110, 120, -176.495), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_right"] = { type = "Model", model = "models/demonssouls/weapons/parrying dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 1.557, -0.519), angle = Angle(-62.987, 64.286, 3.506), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}