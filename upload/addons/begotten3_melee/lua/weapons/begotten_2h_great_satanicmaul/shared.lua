SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Two Handed (Great Weapon)

SWEP.PrintName = "Satanic Maul"
SWEP.Category = "(Begotten) Great Weapon"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h_great"

SWEP.ViewModel = "models/c_begotten_pulverizer.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_heavy_great_block"
SWEP.CriticalAnim = "a_heavy_great_attack_slash_02"
SWEP.ParryAnim = "a_heavy_great_parry"
SWEP.IronSightsPos = Vector(-12.04, -1.407, -0.12)
SWEP.IronSightsAng = Vector(7.738, 0, -27.438)

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.9
SWEP.PrimaryPlaybackRate = 1
SWEP.PrimaryIdleDelay = 0.9
SWEP.AltPlaybackRate = nil
SWEP.AltIdleDelay = nil
SWEP.PrimarySwingAnim = "a_heavy_great_attack_slash_01"

--Sounds
SWEP.AttackSoundTable = "MetalBluntPolearmAttackSoundTable"
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "SatanicMaulAttackTable"
SWEP.BlockTable = "SatanicMaulBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_f" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self:IdleAnimationDelay( 1, 1 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(10,1,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "brace_out" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:ViewPunch(Angle(-30,0,0))
	self:IdleAnimationDelay( 1.5, 1.5 )
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, self.PrimarySwingAnim);

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 3 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_l" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-6,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_h_l" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 3  and self:IsValid() then
			self.Owner:ViewPunch(Angle(6,0,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_r" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )
		end
	end
end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end

function SWEP:Deploy()
	if not self.Owner.cwWakingUp and not self.Owner.LoadingText then
		self:OnDeploy()
	end

	self.Owner.gestureweightbegin = 1;
	self.Owner:SetNWBool("CanBlock", true)
	self.Owner:SetNWBool("CanDeflect", true)
	self.Owner:SetNWBool("ThrustStance", false)
	self.Owner:SetNWBool("ParrySucess", false) 
	self.Owner:SetNWBool("Riposting", false)
	self.Owner:SetNWBool( "MelAttacking", false ) -- This should fix the bug where you can't block until attacking.
	
	self:SetNextPrimaryFire(0)
	self:SetNextSecondaryFire(0)
	self:SetHoldType( self.HoldType )	
	self.Primary.Cone = self.DefaultCone
	--self.Weapon:SetNWInt("Reloading", CurTime() + self:SequenceDuration() )
	self.isAttacking = false;
	
	return true
end

function SWEP:IdleAnimationDelay( seconds, index )
	timer.Remove( self.Owner:EntIndex().."IdleAnimation" )
	self.Idling = index
	timer.Create( self.Owner:EntIndex().."IdleAnimation", seconds, 1, function()
		if not self:IsValid() or self.Idling == 0 then return end
		if self.Idling == index then
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
			self.Owner:GetViewModel():SetPlaybackRate(1)
		end
	end )
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -5, 0), angle = Angle(0, 0, 0) },
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -30, 0) },
}

SWEP.VElements = {
	["v_satanicmaul"] = { type = "Model", model = "models/skyrim/daedric/warhammer/w_daedricwarhammer.mdl", bone = "RightHand_1stP", rel = "", pos = Vector(-5.591, 9.5, 2.299), angle = Angle(-1.17, -10.52, -94.676), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_satanicmaul"] = { type = "Model", model = "models/skyrim/daedric/warhammer/w_daedricwarhammer.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.9, -1, 10.899), angle = Angle(-8.183, -164.805, 3.506), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}