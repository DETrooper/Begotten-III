SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dual

SWEP.PrintName = "Dual Axes"
SWEP.Category = "(Begotten) Dual"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_dual"

SWEP.ViewModel = "models/c_begotten_duals.mdl"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_dual_swords_block"
SWEP.CriticalAnim = "a_dual_swords_slash_01"
SWEP.ParryAnim = "a_dual_swords_parry"

SWEP.IronSightsPos = Vector(7.76, -4.824, -1.321)
SWEP.IronSightsAng = Vector(0, 28.843, 8.442)

SWEP.LoweredPosition = Vector(-70, 0, 0)

--Sounds
SWEP.AttackSoundTable = "DualSwordsAttackSoundTable" 
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "DualAxesAttackTable"
SWEP.BlockTable = "DualAxesBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "powerkill1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.3)
	
	if (SERVER) then
	timer.Simple(0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "crouchmiss" ) )
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_dual_swords_slash_0"..math.random(1, 2));

	-- Viewmodel attack animation!
    if (SERVER) then
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "powermissleft1" ) )
			self.Owner:GetViewModel():SetPlaybackRate(0.3)

		elseif ani == 2  and self:IsValid() then
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "powermissR1" ) )
			self.Owner:GetViewModel():SetPlaybackRate(0.3)
		end
	end
	
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end

function SWEP:Deploy()
	if not self.Owner.cwWakingUp and not self.Owner.LoadingText then
		self:OnDeploy()
	end

	self.Owner.gestureweightbegin = 1;
	self.Owner.StaminaRegenDelay = 1
	self.Owner:SetNWBool("CanBlock", true)
	self.Owner:SetNWBool("CanDeflect", true)
	self.Owner:SetNWBool("ThrustStance", false)
	self.Owner:SetNWBool("ParrySucess", false) 
	self.Owner:SetNWBool("Riposting", false)
	self.Owner:SetNWBool( "MelAttacking", false ) -- This should fix the bug where you can't block until attacking.

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.8)
	
	self:SetNextPrimaryFire(0)
	self:SetNextSecondaryFire(0)
	self:SetHoldType( self.HoldType )	
	self.Primary.Cone = self.DefaultCone
	--self.Weapon:SetNWInt("Reloading", CurTime() + self:SequenceDuration() )
	self.isAttacking = false;
	
	return true
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["cutterL_root"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["cutterR_root"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_axeleft"] = { type = "Model", model = "models/begotten/weapons/axe1.mdl", bone = "Dummy16", rel = "", pos = Vector(-0.59, -6, 0.5), angle = Angle(15.194, 157.792, 99.35), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_axeright"] = { type = "Model", model = "models/begotten/weapons/axe1.mdl", bone = "Dummy01", rel = "", pos = Vector(0.5, -11, 0.449), angle = Angle(-180, -22.209, -93), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_axe_1"] = { type = "Model", model = "models/begotten/weapons/axe1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 2.579, 5.714), angle = Angle(-164.805, 0, -12.858), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["w_axe_2"] = { type = "Model", model = "models/begotten/weapons/axe1.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 0.589, -2.597), angle = Angle(10.519, 174.156, -10.52), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}