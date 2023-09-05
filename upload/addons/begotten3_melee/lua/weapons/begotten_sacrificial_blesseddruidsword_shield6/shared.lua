SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Sacrificial / One Handed + Shield
-- SHIELD TYPE: shield6 (Iron Shield)

SWEP.PrintName = "Blessed Druid Sword + Iron Shield"
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
SWEP.BlockAnim = "a_sword_shield_block_pursuer"
SWEP.CriticalAnim = "a_sword_shield_attack_slash_slow_01"
SWEP.ParryAnim = "a_sword_shield_parry"

SWEP.IronSightsPos = Vector(9.56, -8.242, 6.199)
SWEP.IronSightsAng = Vector(-1.407, -5.628, -3.518)

-- Sacrificial Effects
SWEP.DrawEffect = "fire_small_03"
SWEP.AmbientEffect = "env_embers_small"
SWEP.IgniteTime = 3
SWEP.FreezeTime = nil

SWEP.SpecialDrawSound = "ambient/fire/ignite.wav" --For sacrifical weapons only, plays on top of regular draw sound

--Sounds
SWEP.AttackSoundTable = "SmallMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalShieldSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "BlessedDruidSwordAttackTable"
SWEP.BlockTable = "Shield_6_BlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.55)
	
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
	self:TriggerAnim(self.Owner, "a_sword_shield_attack_slash_fast_01");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.55)
	
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.05);
	end
end

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_sword_shield_attack_stab_fast_01");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "thrust1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.55)
	
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.05);
	end
end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	self.Owner:ViewPunch(Angle(0,1,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
	self.Owner:EmitSound(self.SpecialDrawSound)    
	self.OwnerOverride = self.Owner; -- this is fucked rofl
				
	-- SACRIFICAL WEAPON DRAW PARTICLE EFFECT
	local wep = self.Owner:GetActiveWeapon()
	
	if IsValid(self.Owner.particleprop) then
		self.Owner.particleprop:Remove();
	end
	
	local flame = wep.DrawEffect;
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand");
	
	if (bone) then
		local f = ents.Create("prop_physics");
		f:SetModel("models/hunter/blocks/cube025x025x025.mdl");
		f:SetModelScale(0, 0);
		f:SetPos(self.Owner:GetBonePosition(bone));
		f:SetAngles(Angle(0, 0, 0));
		f:Spawn();
		f.follower = bone;
		f:SetRenderMode(RENDERMODE_TRANSALPHA)
		f:SetColor(Color(255, 255, 255, 0));
		f:SetMoveType(MOVETYPE_NONE);
		f:SetParent(self.Owner, self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"));
		local py = f:GetPhysicsObject();
		if (IsValid(py)) then
			py:EnableMotion(false);
		end;
		
		f:DrawShadow(false);
		f:SetCollisionGroup(COLLISION_GROUP_WORLD);
	
		timer.Simple(1, function()
			if (IsValid(f)) then
				f:Remove();
			end;
		end);
		
		ParticleEffectAttach(flame, PATTACH_POINT_FOLLOW, f, f.follower)
	end;
	-- SACRIFICAL WEAPON DRAW PARTICLE EFFECT
	
	-- AMBIENT WEAPON PARTICLE EFFECT HERE
	local wep = self.Owner:GetActiveWeapon()
	
	local ambient = wep.AmbientEffect;
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand");
	
	if bone then
		local x = ents.Create("prop_physics");
		local getForward = self.Owner:GetForward();
		
		x:SetModel("models/hunter/blocks/cube025x025x025.mdl");
		x:SetModelScale(0, 0);
		x:SetPos(self.Owner:GetBonePosition(bone) + (self.Owner:GetForward() * 10) + (self.Owner:GetRight() * -12) + Vector(0, 0, 38));
		x:SetAngles(Angle(0, 0, 0));
		x:Spawn();
		x.follower = bone;
		x:SetRenderMode(RENDERMODE_TRANSALPHA);
		x:SetColor(Color(255, 255, 255, 0));
		x:SetMoveType(MOVETYPE_NONE);
		x:SetParent(self.Owner, self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"));
		self.Owner.particleprop = x

		local py = x:GetPhysicsObject();
		if (IsValid(py)) then
			py:EnableMotion(false);
		end;
		
		x:DrawShadow(false);
		x:SetCollisionGroup(COLLISION_GROUP_WORLD);
	
		ParticleEffectAttach(ambient, PATTACH_POINT_FOLLOW, x, x.follower)
	end;
	-- AMBIENT WEAPON PARTICLE EFFECT HERE		
end

function SWEP:OnHolster()
	if (SERVER) then
		if IsValid(self.Owner) and IsValid(self.Owner.particleprop) then
			self.Owner.particleprop:Remove();
		end
	end
end

function SWEP:OnRemove()
	if (SERVER) then
		if IsValid(self.OwnerOverride) and IsValid(self.OwnerOverride.particleprop) then
			self.OwnerOverride.particleprop:Remove();
		end
	end
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
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.3, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.4, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -14.027, 2.596), angle = Angle(-146.105, 71.299, -106.364), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_blesseddruidsword"] = { type = "Model", model = "models/begotten/weapons/sword1_unique.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.99, 1.299, 0.518), angle = Angle(-11.9, -174.157, -174.157), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_blesseddruidsword"] = { type = "Model", model = "models/begotten/weapons/sword1_unique.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.25, 0.518), angle = Angle(-180, -26.883, -10.52), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["w_shield6"] = { type = "Model", model = "models/demonssouls/shields/soldier's shield.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.5, 1.5, 0), angle = Angle(100, 67.5, 0), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}