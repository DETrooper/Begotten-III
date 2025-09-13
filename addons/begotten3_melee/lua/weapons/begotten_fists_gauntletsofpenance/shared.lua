SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Fisted

SWEP.PrintName = "Gauntlets of Penance"
SWEP.Category = "(Begotten) Fisted"
SWEP.Author = ""
SWEP.Instructions = "";

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_fists"

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_fists_block"
SWEP.CriticalAnim = "a_fists_attack1"
SWEP.ParryAnim = "a_dual_swords_parry"

SWEP.IronSightsPos = Vector(0, -5, -2)
SWEP.IronSightsAng = Vector(20, 0, 0)

SWEP.LoweredAngles = Angle(-50, 0, 0)

--Sounds
SWEP.AttackSoundTable = "LeatherFistedAttackSoundTable"
SWEP.BlockSoundTable = "FistBlockSoundTable"
SWEP.SoundMaterial = "Punch" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GauntletsOfPenanceAttackTable"
SWEP.BlockTable = "GauntletsOfPenanceBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)
	local owner = self.Owner;

	-- Viewmodel attack animation!
	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_uppercut" ) )
	owner:GetViewModel():SetPlaybackRate(0.4)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)	
	owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_uppercut" ))
end

function SWEP:AttackAnimination()
	self:PlayPunchAnimation()
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_fists_attack"..math.random(1, 2));

	-- Viewmodel attack animation!
	if (SERVER) then
		self:PlayPunchAnimation();
	end

	timer.Simple( 0.09, function() if self:IsValid() then
	self:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])]) end end)

	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"));
end

function SWEP:PlayPunchAnimation()
	--[[if (SERVER) then
		self.Weapon:CallOnClient("PlayPunchAnimation", "");
	end;]]--

 	if (self.left == nil) then self.left = true; else self.left = !self.left; end;

	local anim = "fists_right";
 
 	if (self.left) then
		anim = "fists_left";
	end;
 
 	local vm = self.Owner:GetViewModel();

 	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim));	self.Owner:GetViewModel():SetPlaybackRate(0.55)

end;

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/
SWEP.VElements = {
	["v_gauntlets_left"] = { type = "Model", model = "models/demonssouls/weapons/hands_of_god.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3, 1, -0.494), angle = Angle(-90.778, 78.888, 160.667), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} },
	["v_gauntlets_right"] = { type = "Model", model = "models/demonssouls/weapons/hands_of_god.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1, 0.5), pos = Vector(3, 1.48, -0.494), angle = Angle(-83.334, -114.445, -25.556), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_gauntlets_right"] = { type = "Model", model = "models/demonssouls/weapons/hands_of_god.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.493, 0.493), angle = Angle(-72.223, -85.556, -7.778), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_gauntlets_left"] = { type = "Model", model = "models/demonssouls/weapons/hands_of_god.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.469, 1.48, 0), angle = Angle(-98.889, -147.778, -85.556), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}