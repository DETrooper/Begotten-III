SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed + Shield
-- SHIELD TYPE: shield1 (Scrap Shield)

SWEP.PrintName = "Gore Falchion + Scrap Shield"
SWEP.Category = "(Begotten) One Handed"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h_shield"

SWEP.ViewModel = "models/v_onehandedbegotten.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_shield_block_twindragon"
SWEP.CriticalAnim = "a_sword_shield_attack_slash_slow_01"
SWEP.ParryAnim = "a_sword_shield_parry"

SWEP.IronSightsPos = Vector(5.44, -8, 2)
SWEP.IronSightsAng = Vector(2.5, -8.443, -14.775)

--Sounds
SWEP.AttackSoundTable = "MediumMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalShieldSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GoreFalchionAttackTable"
SWEP.BlockTable = "Shield_1_BlockTable"

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
	self:TriggerAnim(self.Owner, "a_sword_shield_attack_slash_slow_01");

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
	self:TriggerAnim(self.Owner, "a_sword_shield_attack_stab_medium_01");

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

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(-0.201, 0.2, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(-0, 0.5, 0.189), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.3, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.4, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["shield1"] = { type = "Model", model = "models/props_debris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.792, -2.597, 3.635), angle = Angle(146.104, -1.17, 36.234), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_gorefalchion"] = { type = "Model", model = "models/begotten/weapons/sword4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.99, 1.299, -0.801), angle = Angle(-11.9, -167.144, -169.482), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_gorefalchion"] = { type = "Model", model = "models/begotten/weapons/sword4.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.9, 1.2, 0.899), angle = Angle(-180, -19.871, -10.52), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt1"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.557, 0.518, -15.065), angle = Angle(8.182, -1.17, -1.17), size = Vector(0.23, 0.23, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt2"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.2, -0.519, -0.519), angle = Angle(0, -90, 1.169), size = Vector(0.779, 0.779, 0.779), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt3"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(0.518, 0.518, 14.6), angle = Angle(3.506, -1.17, 1.169), size = Vector(0.23, 0.239, 0.43), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt4"] = { type = "Model", model = "models/props_interiors/refrigeratorDoor01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(-0.7, -1.558, 2.595), angle = Angle(3.506, -1.17, 1.169), size = Vector(0.33, 0.33, 0.33), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1"] = { type = "Model", model = "models/props_debris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -4.677, -1.558), angle = Angle(5.843, 57.271, 94.675), size = Vector(0.67, 0.67, 0.67), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}