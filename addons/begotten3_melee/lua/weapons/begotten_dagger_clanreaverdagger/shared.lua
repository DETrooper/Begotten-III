SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dagger

SWEP.PrintName = "Clan Reaver Dagger"
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
SWEP.AttackTable = "ClanReaverDaggerAttackTable"
SWEP.BlockTable = "ClanReaverDaggerBlockTable"

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
	["v_clanreaver_dagger"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.457, 1.48, -1.481), angle = Angle(92.222, -134.445, -158.89), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_clanreaver_dagger"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.469, 0.493, -1.481), angle = Angle(81.111, -7.778, 74.444), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
    ["v_left"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "Dummy16", rel = "", pos = Vector(-0.094, -10.37, 0), angle = Angle(0, -92.223, 172.222), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} },
	["v_right"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "Dummy01", rel = "", pos = Vector(0.493, -12.801, 0.493), angle = Angle(7.777, -103.334, 176.667), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.469, 0.899, 1.48), angle = Angle(-98.889, -105.556, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_right"] = { type = "Model", model = "models/props_sr_weapons/ebony_dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.899, -2.47), angle = Angle(101.111, 96.666, -12.223), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}