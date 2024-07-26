SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Sacrificial / Two Handed

SWEP.PrintName = "Unholy Sigil Sword (Fire)"
SWEP.Category = "(Begotten) Sacrificial"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h"

SWEP.ViewModel = "models/c_begotten_zweihander.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_heavy_2h_block"
SWEP.CriticalAnim = "a_heavy_2h_attack_slash_02"
SWEP.ParryAnim = "a_heavy_2h_parry"

SWEP.IronSightsPos = Vector(-15.32, 2, -6)
SWEP.IronSightsAng = Vector(4, -8.443, -60)

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.9
SWEP.PrimaryPlaybackRate = 0.9
SWEP.PrimaryIdleDelay = 0.85
SWEP.AltPlaybackRate = 0.65
SWEP.AltIdleDelay = 0.75
SWEP.PrimarySwingAnim = "a_heavy_2h_attack_slash_01"

-- Sacrificial Effects
SWEP.DrawEffect = "fire_small_03"
SWEP.AmbientEffect = "env_embers_small"
SWEP.IgniteTime = 6
SWEP.FreezeTime = nil
SWEP.MultiHit = 2;

--Sounds
SWEP.AttackSoundTable = "HeavyMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound
SWEP.SpecialDrawSound = "ambient/fire/ignite.wav" --For sacrifical weapons only, plays on top of regular draw sound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "UnholySigilSword_Fire_AttackTable"
SWEP.BlockTable = "UnholySigilSword_Fire_BlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(self.CriticalPlaybackRate)
	self:IdleAnimationDelay( 1, 1 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end
				
function SWEP:ParryAnimation()
	self:SendWeaponAnim(ACT_VM_UNDEPLOY); self.Owner:GetViewModel():SetPlaybackRate(1.3)
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
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
			self.Owner:GetViewModel():SetPlaybackRate(0.7)
			self:IdleAnimationDelay( 0.9, 0.9 )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
			self.Owner:GetViewModel():SetPlaybackRate(0.7)
			self:IdleAnimationDelay( 0.9, 0.9 )
		end
	end
	
	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.05);
	end
end

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	end end)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_heavy_2h_attack_stab_01");

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)
	self:IdleAnimationDelay( 0.8, 0.8 )
	
	self.Owner:ViewPunch(Angle(6,0,0))

	if self.Owner.HandleNeed and not self.Owner.opponent then
		self.Owner:HandleNeed("corruption", attacktable["primarydamage"] * 0.05);
	end
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

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	self.Owner:ViewPunch(Angle(0,1,0))
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
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
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -5.5), angle = Angle(-20, 0, 5.556) }
}

SWEP.VElements = {
	["v_unholysigilsword"]= { type = "Model", model = "models/props/begotten/melee/smelter_sword.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0.85, 0.518, 46.234), angle = Angle(0, -118.053, -92), size = Vector(0.8, 0.8, 0.8), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_unholysigilsword"] = { type = "Model", model = "models/props/begotten/melee/smelter_sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.3, -0.69, -45), angle = Angle(3, 57.272, 89.3), size = Vector(0.899, 0.899, 0.899), material = "", skin = 0, bodygroup = {} }
}