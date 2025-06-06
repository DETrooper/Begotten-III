SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "Pipe Mace"
SWEP.Category = "(Begotten) One Handed"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h"
SWEP.HoldTypeShield = "wos-begotten_1h_shield"

SWEP.ViewModel = "models/v_onehandedbegotten.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_block"
SWEP.CriticalAnim = "a_sword_attack_chop_fast_01"
SWEP.CriticalAnimShield = "a_sword_shield_attack_chop_fast_01"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(-7.64, -6.433, -0.96)
SWEP.IronSightsAng = Vector(-2.814, 8.442, -48.543)

--Sounds
SWEP.AttackSoundTable = "SmallMetalBluntAttackSoundTable"
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "PipeMaceAttackTable"
SWEP.BlockTable = "PipeMaceBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.55)
	
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
	if self:GetNW2String("activeShield"):len() > 0 then
		self:TriggerAnim(self.Owner, "a_sword_shield_attack_chop_fast_01");
	else
		self:TriggerAnim(self.Owner, "a_sword_attack_chop_fast_01");
	end

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.55)
	
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
	["v_pipemace"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.099, 1.2, 1.889), angle = Angle(8.182, -75.974, 180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} }
}

SWEP.WElements = {
	["w_pipemace"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.59, 2.9), angle = Angle(-174.157, 73.636, 1.169), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} }
}

SWEP.VElementsDual = {
	["v_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "Dummy16", rel = "", pos = Vector(-1.201, -6.753, -0.6), angle = Angle(-111.04, -36.235, -104.027), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} },
	["v_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "Dummy01", rel = "", pos = Vector(-1, -7, 0.7), angle = Angle(-90, 80.649, 12.857), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.2, 0.2, -4), angle = Angle(8.182, 80.649, 10.519), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} },
	["w_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/leadpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.589, 3.2, 4), angle = Angle(-22.209, -104.027, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 1} }
}