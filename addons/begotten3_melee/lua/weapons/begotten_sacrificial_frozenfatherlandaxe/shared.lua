SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Sacrificial (Great Weapon)

SWEP.PrintName = "Frozen Fatherland Axe"
SWEP.Category = "(Begotten) Two Handed"

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
SWEP.PrimaryPlaybackRate = 0.85
SWEP.PrimaryIdleDelay = 0.9
SWEP.AltPlaybackRate = nil
SWEP.AltIdleDelay = nil
SWEP.PrimarySwingAnim = "a_heavy_great_attack_slash_01"

-- Sacrificial Effects
SWEP.DrawEffect = "steam_train"
SWEP.AmbientEffect = "striderbuster_smoke"
SWEP.IgniteTime = nil
SWEP.FreezeTime = 10
SWEP.FreezeDamage = 50;
SWEP.MultiHit = 2;
SWEP.ChoppingAltAttack = true;

--Sounds
SWEP.AttackSoundTable = "HeavyMetalAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

SWEP.CorruptionGain = 5; -- For sacrificial weapons, gives corruption for each swing

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "FrozenFatherlandAxeAttackTable"
SWEP.BlockTable = "FrozenFatherlandAxeBlockTable"

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
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_l" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 2  and self:IsValid() then
			self.Owner:ViewPunch(Angle(6,0,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_r" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )
		end
	end
	
	if self.Owner.HandleNeed and not self.Owner.opponent and !self.Owner:GetCharmEquipped("warding_talisman") then
		if !self.Owner:GetCharmEquipped("crucifix") then
			self.Owner:HandleNeed("corruption", self.CorruptionGain);
		else
			self.Owner:HandleNeed("corruption", self.CorruptionGain * 0.5);
		end
	end
end

function SWEP:HandleThrustAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
	
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_f" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self:IdleAnimationDelay( 1, 1 )
	
	--Attack animation
	self:TriggerAnim(self.Owner, self.CriticalAnim);
	
	self.Owner:ViewPunch(Angle(8,2,2))
	
	if self.Owner.HandleNeed and not self.Owner.opponent and !self.Owner:GetCharmEquipped("warding_talisman") then
		if !self.Owner:GetCharmEquipped("crucifix") then
			self.Owner:HandleNeed("corruption", self.CorruptionGain);
		else
			self.Owner:HandleNeed("corruption", self.CorruptionGain * 0.5);
		end
	end
end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
end

function SWEP:Deploy()
	if not self.Owner.cwWakingUp and not self.Owner.LoadingText then
		self:OnDeploy()
	end

	self.Owner.gestureweightbegin = 1;
	self.Owner:SetLocalVar("CanBlock", true)
	self.canDeflect = true
	self.Owner:SetNetVar("ThrustStance", false)
	self.Owner:SetLocalVar("ParrySuccess", false) 
	self.Owner:SetLocalVar("Riposting", false)
	self.Owner:SetLocalVar("MelAttacking", false ) -- This should fix the bug where you can't block until attacking.

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
		ParticleEffect( "ice_impact_heavy", tr.HitPos, Angle( 0, 0, 0 ), self )
	
		if (SERVER) then
				timer.Create( "freeze" .. self:EntIndex(), 0, 30, function() 
				self:DoFreezeRagdolls( tr.HitPos )
				timer.Remove( "freeze" .. self:EntIndex() )
			end )
		end
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
			end	
		else
			self.Owner:ViewPunch(Angle(-3,1,0))
			self.Owner:EmitSound(attacksoundtable["hitworld"][math.random(1, #attacksoundtable["hitworld"])])
		end
	end
end

function SWEP:DoFreezeRagdolls( pos )

	for k, v in pairs ( ents.FindInSphere( pos, 10 ) ) do
		if ( v:IsRagdoll() and v:GetNWBool( "IsStatue" ) == false ) then
			local bones = v:GetPhysicsObjectCount()
			v.StatueInfo = {}
			for bone = 1, bones-1 do
			
				local constraint = constraint.Weld( v, v, 0, bone, forcelimit )
				
				if ( constraint ) then
						v.StatueInfo[bone] = constraint
				end
				
				local effectdata = EffectData()
				effectdata:SetOrigin( v:GetPhysicsObjectNum( bone ):GetPos() )
				effectdata:SetScale( 1 )
				effectdata:SetMagnitude( 1 )
				util.Effect( "GlassImpact", effectdata, true, true )
				
				if ( GetConVarNumber( "sfw_fx_particles" ) == 1 ) then
					ParticleEffectAttach( "ice_freezing", 1, v, 1 )
				end
				end
				
			v:SetMaterial( "models/elemental/frozen" )
			v:SetNWBool( "IsStatue", true )

			if ( IsValid( v:GetPhysicsObject() ) ) then
				v:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_SELF_COLLISIONS )
			end
		end
		
		if ( v:GetClass() == "prop_physics" or v:GetClass() == "prop_dynamic" or v:GetClass() == "player" ) then
			if ( GetConVarNumber( "sfw_fx_particles" ) == 1 ) then
				ParticleEffectAttach( "ice_freezing_shortlt", 1, v, 1 )
			end
		end
	end
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["RightHandPinky3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.45, 1.2, 0.349), angle = Angle(0, -58.889, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -5, 0), angle = Angle(0, 0, 0) },
	["RightHandMiddle3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.1, 0.925, 0), angle = Angle(0, 0, 0) },
	["RightHandIndex3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.925, 0), angle = Angle(0, 0, 0) },
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -30, 0) },
	["RightHandRing3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.3, 0.55, 0.15), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_frozenfatherlandaxe"] = { type = "Model", model = "models/begotten/weapons/gore_ice_axe.mdl", bone = "RightHand_1stP", rel = "", pos = Vector(-3.901, -5.715, 1), angle = Angle(-73.637, 0, 0), size = Vector(0.91, 0.91, 0.91), material = "", skin = 0, bodygroup = {[0] = 3} }
}

SWEP.WElements = {
	["w_frozenfatherlandaxe"] = { type = "Model", model = "models/begotten/weapons/gore_ice_axe.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.8, -0.35, 23.377), angle = Angle(3.506, -87.663, 85.324), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {[0] = 3} }
}