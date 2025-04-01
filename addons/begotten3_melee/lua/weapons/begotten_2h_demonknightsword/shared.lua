SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Two Handed

SWEP.PrintName = "Demon Knight Sword"
SWEP.Category = "(Begotten) Great Weapon"
 
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
SWEP.MultiHit = 3;
SWEP.hasSwordplay = true;
SWEP.lastStand = true

SWEP.IgniteTime = 3
SWEP.FreezeDamage = 45
SWEP.CorruptionGain = 2

--Sounds
SWEP.AttackSoundTable = "HeavyMetalAttackSoundTable" 
SWEP.BlockSoundTable = "MetalBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "DemonKnightSwordAttackTable"
SWEP.BlockTable = "DemonKnightSwordBlockTable"

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
	local anim = self.PrimarySwingAnim;
	local rate = 0.7;
	
	if self:GetNW2Bool("swordplayActive") == true then
		anim = anim.."_fast";
		rate = 1;
	end

	--Attack animation
	self:TriggerAnim(self.Owner, anim);

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
			self.Owner:GetViewModel():SetPlaybackRate(rate)
			self:IdleAnimationDelay( 0.9, 0.9 )

		elseif ani == 2 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,-6,0))
			self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
			self.Owner:GetViewModel():SetPlaybackRate(rate)
			self:IdleAnimationDelay( 0.9, 0.9 )
		end

		if self.Owner.HandleNeed and not self.Owner.opponent and !self.Owner:GetCharmEquipped("warding_talisman") and self.Owner:GetFaith() != "Faith of the Dark" then
			if !self.Owner:GetCharmEquipped("crucifix") then
				self.Owner:HandleNeed("corruption", self.CorruptionGain);
			else
				self.Owner:HandleNeed("corruption", self.CorruptionGain * 0.5);
			end
		end

	end

end

function SWEP:HandleThrustAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	end end)
	
	local anim = "a_heavy_2h_attack_stab_01";
	local rate = 0.45;
	
	if self:GetNW2Bool("swordplayActive") == true then
		anim = anim.."_fast";
		rate = 0.7;
	end

	--Attack animation
	self:TriggerAnim(self.Owner, anim);

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:GetViewModel():SetPlaybackRate(rate)
	self:IdleAnimationDelay( 0.8, 0.8 )
	
	self.Owner:ViewPunch(Angle(6,0,0))

	if(SERVER) then
		if self.Owner.HandleNeed and not self.Owner.opponent and !self.Owner:GetCharmEquipped("warding_talisman") and self.Owner:GetFaith() != "Faith of the Dark" then
			if !self.Owner:GetCharmEquipped("crucifix") then
				self.Owner:HandleNeed("corruption", self.CorruptionGain);
			else
				self.Owner:HandleNeed("corruption", self.CorruptionGain * 0.5);
			end
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
	
		if(self:GetNWBool("iceSword")) then
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

		elseif(self:GetNWBool("fireSword")) then
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

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
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

local fireR, fireG, fireB = 219, 125, 70
local iceR, iceG, iceB = 100, 255, 255

/*
BONES -----------------------------------
1	 : 	Root
2	 : 	ValveBiped.Bip01_Spine4
3	 : 	RightArm_1stP
4	 : 	RightForeArm_1stP
5	 : 	RightHand_1stP
6	 : 	ValveBiped.Bip01_R_Clavicle
7	 : 	LeftArm_1stP
8	 : 	LeftForeArm_1stP
9	 : 	ValveBiped.Bip01_L_Forearm
10	 : 	LeftHand_1stP
11	 : 	ValveBiped.Bip01_L_Hand
12	 : 	LeftHandThumb1_1stP
13	 : 	LeftHandThumb2_1stP
14	 : 	LeftHandThumb3_1stP
15	 : 	ValveBiped.Bip01_L_Finger02
16	 : 	ValveBiped.Bip01_L_Finger01
17	 : 	ValveBiped.Bip01_L_Finger0
18	 : 	ValveBiped.Bip01_R_UpperArm
19	 : 	RightHandPinky1_1stP
20	 : 	ValveBiped.Bip01_R_Finger4
21	 : 	RightHandPinky2_1stP
22	 : 	ValveBiped.Bip01_R_Finger41
23	 : 	RightHandPinky3_1stP
24	 : 	ValveBiped.Bip01_R_Finger42
25	 : 	RightHandRing1_1stP
26	 : 	ValveBiped.Bip01_R_Finger3
27	 : 	RightHandRing2_1stP
28	 : 	ValveBiped.Bip01_R_Finger31
29	 : 	RightHandRing3_1stP
30	 : 	ValveBiped.Bip01_R_Finger32
31	 : 	RightHandMiddle1_1stP
32	 : 	ValveBiped.Bip01_R_Finger2
33	 : 	RightHandMiddle2_1stP
34	 : 	ValveBiped.Bip01_R_Finger21
35	 : 	RightHandMiddle3_1stP
36	 : 	ValveBiped.Bip01_R_Finger22
37	 : 	RightHandIndex1_1stP
38	 : 	ValveBiped.Bip01_R_Finger1
39	 : 	RightHandIndex2_1stP
40	 : 	ValveBiped.Bip01_R_Finger11
41	 : 	RightHandIndex3_1stP
42	 : 	ValveBiped.Bip01_R_Finger12
43	 : 	RightHandThumb1_1stP
44	 : 	ValveBiped.Bip01_R_Finger0
45	 : 	RightHandThumb2_1stP
46	 : 	ValveBiped.Bip01_R_Finger01
47	 : 	RightHandThumb3_1stP
48	 : 	ValveBiped.Bip01_R_Finger02
49	 : 	ValveBiped.Bip01_R_Hand
50	 : 	LeftHandIndex1_1stP
51	 : 	LeftHandIndex2_1stP
52	 : 	LeftHandIndex3_1stP
53	 : 	ValveBiped.Bip01_L_Finger12
54	 : 	ValveBiped.Bip01_L_Finger11
55	 : 	ValveBiped.Bip01_R_Forearm
56	 : 	ValveBiped.Bip01_L_UpperArm
57	 : 	LeftHandPinky1_1stP
58	 : 	ValveBiped.Bip01_L_Finger4
59	 : 	LeftHandPinky2_1stP
60	 : 	ValveBiped.Bip01_L_Finger41
61	 : 	LeftHandPinky3_1stP
62	 : 	ValveBiped.Bip01_L_Finger42
63	 : 	LeftHandRing1_1stP
64	 : 	ValveBiped.Bip01_L_Finger3
65	 : 	LeftHandRing2_1stP
66	 : 	ValveBiped.Bip01_L_Finger31
67	 : 	LeftHandRing3_1stP
68	 : 	ValveBiped.Bip01_L_Finger32
69	 : 	LeftHandMiddle1_1stP
70	 : 	ValveBiped.Bip01_L_Finger2
71	 : 	LeftHandMiddle2_1stP
72	 : 	ValveBiped.Bip01_L_Finger21
73	 : 	LeftHandMiddle3_1stP
74	 : 	ValveBiped.Bip01_L_Finger22
75	 : 	ValveBiped.Bip01_L_Finger1
76	 : 	ValveBiped.Bip01_L_Clavicle
77	 : 	RightForeArmTwist1_1stP
78	 : 	RightForeArmTwist2_1stP
79	 : 	ValveBiped.Bip01_R_Wrist
80	 : 	LeftForeArmTwist1_1stP
81	 : 	ValveBiped.Bip01_L_Ulna
82	 : 	LeftForeArmTwist2_1stP
83	 : 	ValveBiped.Bip01_L_Wrist
84	 : 	ValveBiped.Bip01_R_Ulna
85	 : 	RW_Weapon
86	 : 	__INVALIDBONE__
-----------------------------------------
*/

local startOffset = Vector(-1, -0.5, 10)
local endOffset = Vector(-5, 0, 55)

local startOffsetWorld = Vector(4, 0, -6)
local endOffsetWorld = Vector(2, -2, -48)

concommand.Add("startoffset", function(_, _, args)
	startOffsetWorld = Vector(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))

end)

concommand.Add("endoffset", function(_, _, args)
	endOffsetWorld = Vector(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
	
end)

local particleMaterial = Material("particle/smokesprites_0001")

function SWEP:PostDrawViewModel(viewModel)
	if(self:GetNWBool("fireSword") or self:GetNWBool("iceSword")) then
		local matrix = viewModel:GetBoneMatrix(85)
		local bonePos, boneRot = matrix:GetTranslation(), matrix:GetAngles()
		local forward = boneRot:Forward()
		local right = boneRot:Right()
		local up = boneRot:Up()

		local startPos = bonePos + (forward * startOffset.x) + (right * startOffset.y) + (up * startOffset.z)
		local endPos = startPos + (forward * endOffset.x) + (right * endOffset.y) + (up * endOffset.z)

		local amount = math.ceil(startPos:Distance(endPos) / 2)

		for i = 1, amount do
			local newStart = LerpVector(i/amount, startPos, endPos)

			newStart = newStart + VectorRand(-0.35, 0.35)

			local isIce = self:GetNWBool("iceSword")
			local r = isIce and iceR or fireR
			local g = isIce and iceG or fireG
			local b = isIce and iceB or fireB

			render.SetMaterial(particleMaterial)
			render.DrawSprite(newStart, 10, 10, Color(r, g, b))

			local otherStart = newStart + (right * 3)

			render.SetMaterial(particleMaterial)
			--render.DrawSprite(otherStart, 9, 10, Color(r, g, b))

		end

		--[[if(!self.madeFireEmitters) then
			self.madeFireEmitters = true
			self.ActiveEmitter = ParticleEmitter(startPos)

		end

		if(IsValid(self.ActiveEmitter) and (!self.nextParticles or self.nextParticles < CurTime())) then
			self.nextParticles = CurTime() + 0.1

			for i = 1, amount do
				local particlePos = LerpVector(i/amount, startPos, endPos)
			
				local particle = self.ActiveEmitter:Add("particle/smokesprites_0001", particlePos)

				if (particle) then
					particle:SetThinkFunction(function(this)
						if(!IsValid(viewModel)) then return end

						this:SetNextThink(CurTime())

						local matrix = viewModel:GetBoneMatrix(49)
						local bonePos, boneRot = matrix:GetTranslation(), matrix:GetAngles()
						local forward = boneRot:Forward()
						local right = boneRot:Right()
						local up = boneRot:Up()

						local startPos = bonePos + (forward * startOffset.x) + (right * startOffset.y) + (up * startOffset.z)
						local endPos = startPos + (forward * endOffset.x) + (right * endOffset.y) + (up * endOffset.z)

						local particlePos = LerpVector(i/amount, startPos, endPos)

						this:SetPos(particlePos + VectorRand(-2, 2))

					end)

					particle:SetNextThink(CurTime())

					particle:SetAirResistance(math.Rand(80, 128))
					particle:SetStartAlpha(100)
					particle:SetStartSize(4)
					particle:SetRollDelta(math.Rand(-0.2, 0.2))
					particle:SetEndAlpha(100)
					particle:SetVelocity(Vector(0, 0, -10))
					particle:SetLifeTime(0)
					particle:SetLighting(false)
					particle:SetGravity(Vector(math.Rand(-8, 8), math.Rand(-8, 8), math.Rand(16, -16)))
					particle:SetEndSize(4)
					particle:SetDieTime(math.random(1, 2))

					local isIce = self:GetNWBool("iceSword")
					local r = isIce and iceR or fireR
					local g = isIce and iceG or fireG
					local b = isIce and iceB or fireB

					particle:SetColor(r, g, b)
					particle:SetRoll(math.Rand(-180, 180))
				end
			
			end

		end]]

	end

end

local rndr = render
local mth = math
local srface = surface
local inpat = input

function SWEP:DrawWorldModel()
	local wepTab = self:GetTable()
	
	if self.OnMeleeStanceChanged then
		if self:GetNWString("stance") ~= self.stance then
			self:OnMeleeStanceChanged(self:GetNWString("stance"));
			
			return;
		end
	end
	
	if self:GetNW2String("activeShield"):len() > 0 then
		if !wepTab.activeShield or wepTab.activeShield ~= self:GetNW2String("activeShield") then
			wepTab.activeShield = self:GetNW2String("activeShield");
			self:EquipShield(wepTab.activeShield);
		end
	elseif wepTab.activeShield then
		wepTab.activeShield = nil;
		self:HolsterShield();
	end
	
	if self:GetNW2String("activeOffhand"):len() > 0 then
		if !wepTab.activeOffhand or wepTab.activeOffhand ~= self:GetNW2String("activeOffhand") then
			wepTab.activeOffhand = self:GetNW2String("activeOffhand");
			self:EquipOffhand(wepTab.activeOffhand);
		end
	elseif wepTab.activeOffhand then
		wepTab.activeOffhand = nil;
		self:HolsterOffhand();
	end

	if (wepTab.ShowWorldModel ~= false) then
		self:DrawModel()
	end
	
	if (!wepTab.WElements) then return end
	
	if (!wepTab.wRenderOrder) or table.IsEmpty(wepTab.wRenderOrder) then
		wepTab.wRenderOrder = {}

		for k, v in pairs(wepTab.WElements) do
			if (v.type == "Model") then
				table.insert(wepTab.wRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(wepTab.wRenderOrder, k)
			end
		end
	end
	
	for k, name in pairs(wepTab.wRenderOrder) do
		local v = wepTab.WElements[name]
		
		if (!v) then wepTab.wRenderOrder = nil break end
		
		if (v.type == "Model") then
			local model = v.modelEnt
			
			if !IsValid(model) or model:GetParent() ~= self.Owner and IsValid(self.Owner) then
				self:CreateModels(wepTab.WElements);
				
				return;
			end
			
			if (v.surpresslightning) then
				rndr.SuppressEngineLighting(true)
			end
			
			local color = v.color;
			
			if color then
				rndr.SetColorModulation(color.r/255, color.g/255, color.b/255)
				rndr.SetBlend(color.a/255)
				model:DrawModel()
				rndr.SetBlend(1)
				rndr.SetColorModulation(1, 1, 1)
			else
				model:DrawModel()
			end
			
			if (v.surpresslightning) then
				rndr.SuppressEngineLighting(false)
			end
		elseif (v.type == "Sprite" and sprite) then
			local sprite = v.spriteMaterial
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
			else
				pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
			end
			
			if (!pos) then continue end
			
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			rndr.SetMaterial(sprite)
			rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
		elseif (v.type == "Quad" and v.draw_func) then
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
			else
				pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
			end
			
			if (!pos) then continue end
			
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			
			cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func( self )
			cam.End3D2D()
		end
	end

	if(self:GetNWBool("fireSword") or self:GetNWBool("iceSword")) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		local matrix = self.Owner:GetBoneMatrix(bone)
		local bonePos, boneRot = matrix:GetTranslation(), matrix:GetAngles()
		local forward = boneRot:Forward()
		local right = boneRot:Right()
		local up = boneRot:Up()

		local startPos = bonePos + (forward * startOffsetWorld.x) + (right * startOffsetWorld.y) + (up * startOffsetWorld.z)
		local endPos = startPos + (forward * endOffsetWorld.x) + (right * endOffsetWorld.y) + (up * endOffsetWorld.z)

		local amount = math.ceil(startPos:Distance(endPos) / 2)

		if(!self.madeFireEmitters) then
			self.madeFireEmitters = true
			self.ActiveEmitter = ParticleEmitter(startPos)

		end

		if(IsValid(self.ActiveEmitter) and (!self.nextParticles or self.nextParticles < CurTime())) then
			self.nextParticles = CurTime() + 0.1

			for i = 1, amount do
				local particlePos = LerpVector(i/amount, startPos, endPos)
			
				local particle = self.ActiveEmitter:Add("particle/smokesprites_0001", particlePos)

				if (particle) then
					particle:SetThinkFunction(function(this)
						if(!IsValid(self) or !IsValid(self.Owner) or self.Owner:GetActiveWeapon() != self or (self.Owner == Clockwork.Client and !self.Owner:ShouldDrawLocalPlayer()) or self.Owner:GetMoveType() == MOVETYPE_NOCLIP) then this:SetLifeTime(3) return end

						this:SetNextThink(CurTime())

						local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
						local matrix = self.Owner:GetBoneMatrix(bone)
						local bonePos, boneRot = matrix:GetTranslation(), matrix:GetAngles()
						local forward = boneRot:Forward()
						local right = boneRot:Right()
						local up = boneRot:Up()

						local startPos = bonePos + (forward * startOffsetWorld.x) + (right * startOffsetWorld.y) + (up * startOffsetWorld.z)
						local endPos = startPos + (forward * endOffsetWorld.x) + (right * endOffsetWorld.y) + (up * endOffsetWorld.z)

						local particlePos = LerpVector(i/amount, startPos, endPos)

						this:SetPos(particlePos + VectorRand(-2, 2))

					end)

					particle:SetNextThink(CurTime())

					particle:SetAirResistance(math.Rand(80, 128))
					particle:SetStartAlpha(100)
					particle:SetStartSize(4)
					particle:SetRollDelta(math.Rand(-0.2, 0.2))
					particle:SetEndAlpha(100)
					particle:SetVelocity(Vector(0, 0, -10))
					particle:SetLifeTime(0)
					particle:SetLighting(false)
					particle:SetGravity(Vector(math.Rand(-8, 8), math.Rand(-8, 8), math.Rand(16, -16)))
					particle:SetEndSize(4)
					particle:SetDieTime(math.random(1, 2))

					local isIce = self:GetNWBool("iceSword")
					local r = isIce and iceR or fireR
					local g = isIce and iceG or fireG
					local b = isIce and iceB or fireB

					particle:SetColor(r, g, b)
					particle:SetRoll(math.Rand(-180, 180))
				end
			
			end

		end

	end

end

function SWEP:OnHolster()
	if(IsValid(self.ActiveEmitter)) then
		self.madeFireEmitters = false
		self.ActiveEmitter:Finish()
	
	end

end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -5.5), angle = Angle(-20, 0, 5.556) }
}

SWEP.VElements = {
	["weapon"] = { type = "Model", model = "models/prelude/demonknightsword.mdl", bone = "RW_Weapon", rel = "", pos = Vector(-0.216, 0.375, 1.215), angle = Angle(0, -8.929, -88.526), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["weapon"] = { type = "Model", model = "models/prelude/demonknightsword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.098, 1.299, 2.605), angle = Angle(0, -33.173, 95.476), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}