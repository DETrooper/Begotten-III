SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dagger

SWEP.PrintName = "Ravenstone Shard"
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
SWEP.AttackTable = "RavenstoneShardAttackTable"
SWEP.BlockTable = "RavenstoneShardBlockTable"

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
	["v_ravenstoneshard"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.469, 1.48, -0.494), angle = Angle(180, 72.222, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_ravenstoneshard"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -0.494), angle = Angle(180, 63.333, 12.222), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
	["v_right"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.469, 1.48, -1.481), angle = Angle(174.444, 85.555, 18.888), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), material = "", skin = 0, bodygroup = {} },
	["v_left"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.469, 1.48, 0.493), angle = Angle(-3.333, 101.111, 30), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_right"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.2, 1.48, -0.494), angle = Angle(-156.668, 72.222, 3.332), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} },
	["w_left"] = { type = "Model", model = "models/weapons/cultistdagger.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.2, 1, 0.493), angle = Angle(14.444, 98.888, 12.222), size = Vector(1.2, 1.2, 1.2), material = "", skin = 0, bodygroup = {} }
}


