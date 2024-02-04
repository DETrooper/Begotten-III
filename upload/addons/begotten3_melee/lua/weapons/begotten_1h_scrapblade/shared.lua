SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "Scrap Blade"
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
SWEP.AttackSoundTable = "SmallMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "ScrapBladeAttackTable"
SWEP.BlockTable = "ScrapBladeBlockTable"

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
	if self:GetNWString("activeShield"):len() > 0 then
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

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	if self:GetNWString("activeShield"):len() > 0 then
		self:TriggerAnim(self.Owner, "a_sword_shield_attack_stab_medium_01");
	else
		self:TriggerAnim(self.Owner, "a_sword_attack_stab_medium_01");
	end

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "thrust1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)
	
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
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
	["v_shishkebab"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 2.596, 1.557), angle = Angle(-3.507, -87.663, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.VElementsDual = {
	["v_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "Dummy16", rel = "", pos = Vector(-1.201, -6.753, -1), angle = Angle(-111.04, -36.235, -104.027), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} },
	["v_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "Dummy01", rel = "", pos = Vector(-0.5, -9, 0.2), angle = Angle(-90, 80.649, 12.857), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_shishkebab"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, 4.675), angle = Angle(180, 71.299, 8.182), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsDual = {
	["w_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.2, 0.2, -3.636), angle = Angle(8.182, 80.649, 10.519), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/shishkebab.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.589, 3.2, 2.596), angle = Angle(-22.209, -104.027, -180), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}