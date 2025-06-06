SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "Board"
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
SWEP.CriticalAnim = "a_sword_attack_slash_slow_01"
SWEP.CriticalAnimShield = "a_sword_shield_attack_slash_slow_01"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(-7.64, -6.433, -0.96)
SWEP.IronSightsAng = Vector(-2.814, 8.442, -48.543)

--Sounds
SWEP.AttackSoundTable = "MediumWoodenAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Wooden" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "BoardAttackTable"
SWEP.BlockTable = "BoardBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)
	
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
		self:TriggerAnim(self.Owner, "a_sword_shield_attack_slash_slow_01");
	else
		self:TriggerAnim(self.Owner, "a_sword_attack_slash_slow_0"..math.random(1,2));
	end

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)
	
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

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(-0.201, 0.2, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(-0, 0.5, 0.189), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.3, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.4, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_board"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.099, -0.201, 11.947), angle = Angle(8.182, -75.974, 180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_board"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.299, 11.947), angle = Angle(-174.157, 73.636, 1.169), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
	["v_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "Dummy16", rel = "", pos = Vector(-3, -2, -1.2), angle = Angle(-111.04, -36.235, -104.027), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["v_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "Dummy01", rel = "", pos = Vector(-3.4, 0, 0.7), angle = Angle(-90, 80.649, 12.857), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.6, -1, -11), angle = Angle(8.182, 80.649, 10.519), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/board.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.6, 6, 11), angle = Angle(-22.209, -104.027, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}