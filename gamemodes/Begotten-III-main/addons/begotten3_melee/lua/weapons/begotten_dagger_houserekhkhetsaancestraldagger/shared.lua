SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dagger

SWEP.PrintName = "House Rekh-khet-sa Ancestral Dagger"
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
SWEP.AttackTable = "Ancestraldagger_Rekh_AttackTable"
SWEP.BlockTable = "Ancestraldagger_Rekh_BlockTable"

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
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.VElements = {
	["v_ancestralrekh"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.589, 1.299, 0.518), angle = Angle(-85.325, 8.182, 29.221), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_ancestralrekh"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 1, 0.518), angle = Angle(-90, 90, 106.363), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
	["v_left"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "Dummy16", rel = "", pos = Vector(0, -8.832, -0.519), angle = Angle(5.843, 78.311, -92.338), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} },
	["v_right"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "Dummy01", rel = "", pos = Vector(-0, -11.301, 0.55), angle = Angle(1.169, 64.286, -66.624), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 1, -0.301), angle = Angle(104.026, 47.922, 132.078), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_right"] = { type = "Model", model = "models/items/weapons/daggers_kryss/daggers_kryss.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.25, 1.59, 0), angle = Angle(-68.961, 85.324, 80.649), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}