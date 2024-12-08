SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed + Shield
-- SHIELD TYPE: shieldunique2 (Sol Shield)

SWEP.PrintName = "Glazic Sword + Sol Shield"
SWEP.Category = "(Begotten) Sacrificial"

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
SWEP.BlockAnim = "a_sword_shield_block_pursuer"
SWEP.CriticalAnim = "a_sword_shield_attack_slash_fast_01"
SWEP.ParryAnim = "a_sword_shield_parry"

SWEP.IronSightsPos = Vector(5.76, -7.639, 3.2)
SWEP.IronSightsAng = Vector(3.517, -15.478, -2.814)
SWEP.HasShield = true;

SWEP.IgniteTime = 3

--Sounds
SWEP.AttackSoundTable = "SmallMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalShieldSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GlazicSwordAttackTable"
SWEP.BlockTable = "shieldunique2"

function SWEP:InitFunc()
	self:SetNW2String("activeShield", "shieldunique2");
	self.realBlockAnim = self.BlockAnim;
	self.realBlockTable = GetTable(self.BlockTable);
	self.realBlockSoundTable = self.BlockSoundTable;
	self.realCriticalAnim = self.CriticalAnim;
	self.realHoldType = self.HoldType;
	self.realParryAnim = self.ParryAnim;
	self.realIronSightsPos = self.IronSightsPos;
	self.realIronSightsAng = self.IronSightsAng;
end

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
	
	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.02);
	end

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
	
	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.02);
	end

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
end

function SWEP:Hitscan()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (attacktable["meleerange"] * 0.109)),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	
	if ( tr.Hit ) and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
	
		-- Sacrifical Weapons Only
		local dist = self.Owner:GetPos():Distance(tr.HitPos + tr.HitPos:GetNormalized());
		if (dist <= 20) then
			util.Decal( "fadingscorch", tr.HitPos + tr.HitPos:GetNormalized(),tr.HitPos - tr.HitPos:GetNormalized() )
		else
			util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
		end;
			
		ParticleEffect( "gunsmoke", tr.HitPos, Angle( 0, 0, 0 ), self )
		-- Sacrifical Weapons Only

		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 2
		bullet.Hullsize = 0
		bullet.Distance = (attacktable["meleerange"] * 0.109)
		bullet.Damage = math.random( 0, 0 )
	
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetDamageType(DMG_CRUSH)
		end
		
		self.Owner:FireBullets(bullet, 2)
		
		if string.find(tr.Entity:GetClass(),"prop_ragdoll") then
		
			local data = self.Owner:GetEyeTrace();
			local effect = EffectData();
				effect:SetOrigin(data.HitPos);
				effect:SetScale(16);
			util.Effect("BloodImpact", effect);
			tr.Entity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
			if ( SERVER && IsValid( tr.Entity ) ) then
				local phys = tr.Entity:GetPhysicsObject()
				if ( IsValid( phys ) ) then
					phys:ApplyForceOffset( self.Owner:GetAimVector() * 135 * phys:GetMass(), tr.HitPos )
				end
				-- Sacrifical Weapons Only (Fire)
				tr.Entity:Ignite(self.IgniteTime)
				tr.Entity:EmitSound("ambient/fire/ignite.wav")
				-- Sacrifical Weapons Only (Fire)
			end	
		else
			self.Owner:ViewPunch(Angle(-3,1,0))
			self.Owner:EmitSound(attacksoundtable["hitworld"][math.random(1, #attacksoundtable["hitworld"])])
		end
	end
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(-0.201, 0.2, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0.189), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -15, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.3, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.4, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_solshield"] = { type = "Model", model = "models/demonssouls/shields/rune shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 4.675), angle = Angle(-146.105, 71.299, -106.364), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["v_glazicsword"] = { type = "Model", model = "models/demonssouls/weapons/rune sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.6, 0), angle = Angle(-80.65, 0, 85.324), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_solshield"] = { type = "Model", model = "models/demonssouls/weapons/rune sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 1.2, 0), angle = Angle(-80, 90, 10), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} },
	["w_glazicsword"] = { type = "Model", model = "models/demonssouls/shields/rune shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.899, 1.899, 0), angle = Angle(-99.351, -106.364, 43.247), size = Vector(1.1, 1.1, 1.1), material = "", skin = 0, bodygroup = {} }
}