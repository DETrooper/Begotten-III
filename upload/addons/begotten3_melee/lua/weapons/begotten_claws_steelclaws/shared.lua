SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Claws

SWEP.PrintName = "Steel Claws"
SWEP.Category = "(Begotten) Claws"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_claws"

SWEP.ViewModel = "models/divii/weapons/v_knife_t.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_claws_block"
SWEP.CriticalAnim = "a_claws_attack_left_slash"
SWEP.ParryAnim = "a_claws_attack_left_slash_fast"

SWEP.IronSightsPos = Vector(0.36, -3.418, -1.29)
SWEP.IronSightsAng = Vector(20.402, 0, 0)

--Sounds
SWEP.AttackSoundTable = "MetalClawsAttackSoundTable" 
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "SteelClawsAttackTable"
SWEP.BlockTable = "SteelClawsBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.75)
	
	self:TriggerAnim3(self.Owner, "a_claws_attack_right_slash");
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	self:TriggerAnim3(self.Owner, "a_claws_attack_right_slash_fast");
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	local attackanim = math.random( 1, 2 )
	
	if attackanim == 1 and self:IsValid() then
		self:TriggerAnim(self.Owner, "a_claws_attack_left_slash");
	elseif attackanim == 2 and self:IsValid() then
		self:TriggerAnim(self.Owner, "a_claws_attack_right_slash");
	end

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:GetViewModel():SetPlaybackRate(0.75)
	
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
	["blade01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) },
	["blade05"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_steel_claw2"] = { type = "Model", model = "models/props/begotten/melee/claws.mdl", bone = "Bone26", rel = "", pos = Vector(1.557, -0.301, -0.401), angle = Angle(-22.209, 97.013, -3.507), size = Vector(0.5, 0.5, 0.5), material = "", skin = 0, bodygroup = {} },
	["v_steel_claw1"] = { type = "Model", model = "models/props/begotten/melee/claws.mdl", bone = "Bone03", rel = "", pos = Vector(1.557, 0.3, -0.519), angle = Angle(180, -97.014, 169.481), size = Vector(0.5, 0.5, 0.5), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_steel_claw2"] = { type = "Model", model = "models/props/begotten/melee/claws.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0, 0, 0.518), angle = Angle(-78.312, 90, 5.843), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_steel_claw1"] = { type = "Model", model = "models/props/begotten/melee/claws.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(-90, 73.636, -10.52), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}