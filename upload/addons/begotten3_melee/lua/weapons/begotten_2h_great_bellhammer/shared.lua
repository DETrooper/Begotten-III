SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Two Handed (Great Weapon)

SWEP.PrintName = "Bell Hammer"
SWEP.Category = "(Begotten) Great Weapon"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h_great"

SWEP.ViewModel = "models/weapons/c_kaine_sword.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_heavy_great_block"
SWEP.CriticalAnim = "a_heavy_great_attack_slash_slow_02"
SWEP.ParryAnim = "a_heavy_great_parry"
SWEP.IronSightsPos = Vector(-15, 3, -8)
SWEP.IronSightsAng = Vector(0, 0, -60)

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.65
SWEP.PrimaryPlaybackRate = 0.65
SWEP.PrimaryIdleDelay = 1.5
SWEP.AltPlaybackRate = nil
SWEP.AltIdleDelay = nil
SWEP.PrimarySwingAnim = "a_heavy_great_attack_slash_slow_01"

--For Bellhammer only
SWEP.IsBellHammer = true;

--Sounds
SWEP.AttackSoundTable = "BellHammerAttackSoundTable"
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Bell" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "BellHammerAttackTable"
SWEP.BlockTable = "BellHammerBlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(self.CriticalPlaybackRate)
	self:IdleAnimationDelay( 1.5, 1.5 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(30,1,1))
	end
	
end

function SWEP:ParryAnimation()
	self:SendWeaponAnim(ACT_VM_DRAW); self.Owner:GetViewModel():SetPlaybackRate(1.3)
	self.Owner:ViewPunch(Angle(-50,0,0))
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
	
	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.02);
	end
    
    if (SERVER) then
		local ani = math.random( 1, 3 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,25,0))
			self.Weapon:SendWeaponAnim(ACT_VM_MISSLEFT)
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-25,0))
			self.Weapon:SendWeaponAnim(ACT_VM_MISSRIGHT)
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 3  and self:IsValid() then
			self.Owner:ViewPunch(Angle(25,0,0))
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
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

function SWEP:IdleAnimationDelay( seconds, index )
	timer.Remove( self.Owner:EntIndex().."IdleAnimation" )
	self.Idling = index
	timer.Create( self.Owner:EntIndex().."IdleAnimation", seconds, 1, function()
		if not self:IsValid() or self.Idling == 0 then return end
		if self.Idling == index then
			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
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
		
		-- Bellhammer radius disorient
		for k, v in pairs (ents.FindInSphere(self.Owner:GetPos(), 200)) do
			if v:IsPlayer() then
				v:Disorient(1)
			end
		end

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
				if tr.Entity:IsValid() then
					tr.Entity:EmitSound("meleesounds/bell.mp3")
				end
			end	
		else
			self.Owner:ViewPunch(Angle(-25,5,0))
			self.Owner:EmitSound(attacksoundtable["hitworld"][math.random(1, #attacksoundtable["hitworld"])])
			timer.Simple( 0.2, function() if self:IsValid() then
			self.Owner:EmitSound("meleesounds/bell.mp3")
			end end)
		end
	end
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["LeftArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.25, -0.25, 0), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Root"] = { scale = Vector(1, 1, 1), pos = Vector(-5, 0.185, 1.296), angle = Angle(-5.558, -76.667, 0) }
}

SWEP.VElements = {
	["v_bellhammer"] = { type = "Model", model = "models/props/begotten/melee/sacred_chime_hammer.mdl", bone = "RW_Weapon", rel = "", pos = Vector(-0.791, -0.59, -10), angle = Angle(97.013, 122.726, -19.871), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_bellhammer"] = { type = "Model", model = "models/props/begotten/melee/sacred_chime_hammer.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.65, 1.389, 0.589), angle = Angle(82.986, 52.597, 162.468), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}