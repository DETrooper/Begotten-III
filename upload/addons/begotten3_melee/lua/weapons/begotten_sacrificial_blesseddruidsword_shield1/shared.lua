SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Sacrificial / One Handed + Shield
-- SHIELD TYPE: shield1 (Scrap Shield)

SWEP.PrintName = "Blessed Druid Sword + Scrap Shield"
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
SWEP.BlockAnim = "a_sword_shield_block_twindragon"
SWEP.CriticalAnim = "a_sword_shield_attack_slash_slow_01"
SWEP.ParryAnim = "a_sword_shield_parry"

SWEP.IronSightsPos = Vector(5.44, -8, 2)
SWEP.IronSightsAng = Vector(2.5, -8.443, -14.775)

-- Sacrificial Effects
SWEP.DrawEffect = "fire_small_03"
SWEP.AmbientEffect = "env_embers_small"
SWEP.IgniteTime = 5
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
SWEP.BlockTable = "Shield_1_BlockTable"

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
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(-0, 0.5, 0.189), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.3, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.4, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -34.445, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.5, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["shield1"] = { type = "Model", model = "models/props_debris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-7.792, -2.597, 3.635), angle = Angle(146.104, -1.17, 36.234), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_blesseddruidsword"] = { type = "Model", model = "models/begotten/weapons/sword1_unique.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.99, 1.299, 0.518), angle = Angle(-11.9, -174.157, -174.157), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_blesseddruidsword"] = { type = "Model", model = "models/begotten/weapons/sword1_unique.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.25, 0.518), angle = Angle(-180, -26.883, -10.52), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt2"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(-2.597, -7.792, 6.751), angle = Angle(-80.651, 12.857, -75.974), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt9"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.85, 0.518, -0.519), angle = Angle(87.662, -180, -1.17), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt3"] = { type = "Model", model = "models/props_c17/streetsign005b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(0.518, -9.87, 10.909), angle = Angle(139.091, -87.664, -2), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt6"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(2, 0.518, -0.519), angle = Angle(-180, -178.831, -1.17), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt1"] = { type = "Model", model = "models/props_c17/streetsign001c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.557, -9.87, -12.988), angle = Angle(134.416, -92.338, 1.169), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt4"] = { type = "Model", model = "models/props_interiors/pot02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(-1.191, -2.57, 5), angle = Angle(33.895, -92.338, -85.325), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt5"] = { type = "Model", model = "models/props_c17/streetsign002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(0.518, 5.714, 12), angle = Angle(94.675, -5.844, -82.987), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt7"] = { type = "Model", model = "models/Gibs/Fast_Zombie_Torso.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(6.3, -0.519, 27.531), angle = Angle(178.83, -180, -1.17), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_satanic_pt8"] = { type = "Model", model = "models/props_c17/streetsign004f.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.57, 0.518, -0.519), angle = Angle(0, -90, 1.169), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1"] = { type = "Model", model = "models/props_debris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -4.677, -1.558), angle = Angle(5.843, 57.271, 94.675), size = Vector(0.67, 0.67, 0.67), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}