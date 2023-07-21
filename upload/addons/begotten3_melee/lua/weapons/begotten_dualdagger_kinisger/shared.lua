SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Dual

SWEP.PrintName = "Dual Kinisger Daggers"
SWEP.Category = "(Begotten) Dual Dagger"

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
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "DualKinisgerDaggersAttackTable"
SWEP.BlockTable = "DualKinisgerDaggersBlockTable"

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

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_dual_swords_stab");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "powermissup" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.35)
	
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
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
SWEP.VElements = {
	["v_dagger_left"] = { type = "Model", model = "models/items/weapons/daggers_collector/daggers_collector.mdl", bone = "Dummy16", rel = "", pos = Vector(0, -8.832, -0.519), angle = Angle(5.843, 78.311, -92.338), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_dagger_right"] = { type = "Model", model = "models/items/weapons/daggers_collector/daggers_collector.mdl", bone = "Dummy01", rel = "", pos = Vector(-0, -11.301, 0.55), angle = Angle(1.169, 64.286, -66.624), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["dagger_left"] = { type = "Model", model = "models/items/weapons/daggers_collector/daggers_collector.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 1, -0.301), angle = Angle(104.026, 47.922, 132.078), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dagger_right"] = { type = "Model", model = "models/items/weapons/daggers_collector/daggers_collector.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.25, 1.59, 0), angle = Angle(-68.961, 85.324, 80.649), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}