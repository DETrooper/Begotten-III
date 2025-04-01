SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "Flail of Atonement"
SWEP.Category = "(Begotten) One Handed"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h"
SWEP.HoldTypeShield = "wos-begotten_1h_shield"

SWEP.WorldModel = "models/begoyten/solflail/w_solflail.mdl"

SWEP.ViewModel = "models/weapons/ageofchivalry/c_begotten_solflail.mdl"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_block"
SWEP.CriticalAnim = "a_sword_attack_chop_slow_01"
SWEP.CriticalAnimShield = "a_sword_shield_attack_chop_slow_01"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(-2.6, -0.403, -2.921)
SWEP.IronSightsAng = Vector(0, -4.926, 30.25)

--Sounds
SWEP.AttackSoundTable = "MetalFlailAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.MultiHit = 2;

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "SolFlailAttackTable"
SWEP.BlockTable = "SolFlailBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "Swing2" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1.1)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)	
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "Stab" ))
	self.Owner:GetViewModel():SetPlaybackRate(1.5)
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
	
	if self.critted then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "Stab" ))
		self.Owner:GetViewModel():SetPlaybackRate(1.5)
	else
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "Swing1" ) )
		self.Owner:GetViewModel():SetPlaybackRate(1.1)
	end
	
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])
end

function SWEP:ShouldCriticalHit()
	local chance = 10;
	
	if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("favored") then
		chance = 20;
	end
	
	if math.random(1, 100) <= chance then
		return true;
	end
end

function SWEP:OnMiss()
	local chance = 25;
	
	if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("favored") then
		chance = 10;
	end
	
	if math.random(1, 100) <= chance then
		local attacktable = GetTable(self.AttackTable)
		
		if attacktable then
			local damage = attacktable["primarydamage"];
			local damagetype = attacktable["dmgtype"];
			local attacksoundtable = GetSoundTable(self.AttackSoundTable);
			
			if attacksoundtable then
				self.Owner:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])]);
			end

			local d = DamageInfo()
			d:SetDamage(damage * math.Rand(0.5, 0.75));
			d:SetAttacker(self.Owner);
			d:SetDamageType(damagetype);
			d:SetDamagePosition(self.Owner:GetPos() + Vector(0, 0, 48));
			d:SetInflictor(self);

			self.Owner:TakeDamageInfo(d);
			
			local selfless = "himself";
			
			if (self.Owner:GetGender() == GENDER_FEMALE) then
				selfless = "herself";
			end
			
			Clockwork.chatBox:AddInTargetRadius(self.Owner, "me", "accidentally hits "..selfless.." with their own flail!", self.Owner:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		end
	end
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
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -30, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
}

SWEP.WElements = {
}