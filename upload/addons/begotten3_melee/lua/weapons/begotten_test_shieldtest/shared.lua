SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "BOT SHIELD TEST"
SWEP.Category = "Begotten Melee"

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
SWEP.CriticalAnim = "a_sword_attack_chop_slow_01"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(5.44, -8, 2)
SWEP.IronSightsAng = Vector(2.5, -8.443, -14.775)

--Sounds
SWEP.AttackSoundTable = "SmallMetalAttackSoundTable"
SWEP.BlockSoundTable = "MetalShieldSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GlazicusAttackTable"
SWEP.BlockTable = "Shield_1_BlockTable"

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.5)
	
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

function SWEP:PrimaryAttack()
local ply = self.Owner
if (ply:GetNWInt("meleeStamina") != 100) then
ply:SetNWInt("meleeStamina", 100)
end
self.Owner:SetNWBool( "Deflect", false )

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end

function SWEP:Think()
	local curTime = CurTime();
	local ply = self.Owner
	local wep = self.Weapon
	local blocksoundtable = GetSoundTable(self.BlockSoundTable)
	local blocktable = GetTable(self.BlockTable)
	local attacktable = GetTable(self.AttackTable)
	
	self:HandleBreathing()

	if (SERVER) then
		if ply:GetNWBool( "MelAttacking") == false and ply:KeyDown(IN_ATTACK2) and ply:KeyDown(IN_USE) and wep:GetNWInt("Reloading") < CurTime() and (attacktable["canaltattack"]) == true then
			if (!self.Owner.StanceSwitchOn or curTime > self.Owner.StanceSwitchOn) then
				if ply:GetNWBool("ThrustStance")  == false then
					if self.CanSwipeAttack == true then
						ply:SetNWBool( "ThrustStance", true )
						self.Owner:PrintMessage(HUD_PRINTTALK, "*** Switched to swiping stance.")
						self.Owner.StanceSwitchOn = curTime + 1;
					else
						ply:SetNWBool( "ThrustStance", true )
						self.Owner:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
						self.Owner.StanceSwitchOn = curTime + 1;
					end
				else
					if self.CanSwipeAttack == true then
						ply:SetNWBool( "ThrustStance", false )
						self.Owner:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
						self.Owner.StanceSwitchOn = curTime + 1;
					else
						ply:SetNWBool( "ThrustStance", false )
						self.Owner:PrintMessage(HUD_PRINTTALK, "*** Switched to slashing stance.")
						self.Owner.StanceSwitchOn = curTime + 1;
					end
				end
			end
		end
	end
	
	-- For stamina regen
	if SERVER then
		if (!self.Owner:GetNWInt("meleeStamina")) then
		end;
		
		if (ply:GetNWInt("meleeStamina") != 100) then
			if (!Clockwork.player:GetWeaponRaised(ply) or (ply:GetNWInt("meleeStamina") < 100 and self.Owner.StaminaRegenDelay >= 135 and ply:GetNWBool( "Guardening" ) == false)) then
				local curTime = CurTime();
				if (!ply.nextRegens or ply.nextRegens < curTime) then
					ply.nextRegens = curTime + self.RegenDelay;
					ply:SetNWInt("meleeStamina", math.Clamp(ply:GetNWInt("meleeStamina") + 1, 0, 100))
				end;
			end
		end;

		if ply:GetNWBool( "Guardening" ) == false then
			self.Owner.StaminaRegenDelay = self.Owner.StaminaRegenDelay + 1
		end
	
		if self.Owner.StaminaRegenDelay > 135 then 
			self.Owner.StaminaRegenDelay = 135
		end
	end	 
	-- For stamina regen
 
	if self.IronSights == false then
		ply:SetNWBool( "Guardening", false )
	end
		
	local LoweredParryDebug = self:GetNextSecondaryFire()
	
	if self.IronSights == true and ply:GetNWBool( "MelAttacking") == false and ply:KeyDown(IN_ATTACK) and wep:GetNWInt("Reloading") < CurTime() and ply:GetNWInt("meleeStamina", 100) >= blocktable["guardblockamount"] and ( LoweredParryDebug < CurTime() ) then
			ply:SetNWBool( "Guardening", true )
			self.Owner.StaminaRegenDelay = 0
			self.Primary.Cone = self.IronCone
			self.Primary.Recoil = self.Primary.IronRecoil
		else
			ply:SetNWBool( "Guardening", false )
			self.Primary.Cone = self.DefaultCone		
			self.Primary.Recoil = self.DefaultRecoil
	end
		
	-- Parry
	if ply:KeyDown(IN_RELOAD) and (blocktable["canparry"] == true) then
		self:SecondaryAttack()
	end
	-- Parry
				
	if ply:GetNWBool("Guardening") == true then
		self:TriggerAnim2(self.Owner, self.BlockAnim, 0);
		if (SERVER) and self.Owner:GetNWBool( "CanBlock", true ) then
			self.Owner:EmitSound(blocksoundtable["guardsound"][math.random(1, #blocksoundtable["guardsound"])])
			self.Owner:SetNWBool( "CanBlock", false )
		end	
		
	elseif ply:GetNWBool("Guardening") == false then
		self:TriggerAnim2(self.Owner, self.BlockAnim, 1);
		self.Owner:SetNWBool( "CanBlock", true )

		if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 350 and wep:GetNWInt("Reloading") < CurTime() and self.Sprint == true and self.BlackMesaSprint == false then
			wep:SetNextPrimaryFire( CurTime() + 0.3 )
			wep:SetNextSecondaryFire( CurTime() + 0.3 )
		end
		
		function self.Owner:OnTakeDamage(dmginfo)
			self:HandleDamage(dmginfo)
			dmginfo:SetDamage(0)
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
	["v_glazicus"] = { type = "Model", model = "models/demonssouls/weapons/broad sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4, 1.7, 1.2), angle = Angle(-90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_glazicus"] = { type = "Model", model = "models/demonssouls/weapons/broad sword.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.68, 1.2, 0.899), angle = Angle(-80, 90, 10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt1"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.557, 0.518, -15.065), angle = Angle(8.182, -1.17, -1.17), size = Vector(0.23, 0.23, 0.432), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt2"] = { type = "Model", model = "models/props_c17/streetsign004e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(1.2, -0.519, -0.519), angle = Angle(0, -90, 1.169), size = Vector(0.779, 0.779, 0.779), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt3"] = { type = "Model", model = "models/props_junk/ravenholmsign.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(0.518, 0.518, 14.6), angle = Angle(3.506, -1.17, 1.169), size = Vector(0.23, 0.239, 0.43), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/wood_fence01a", skin = 0, bodygroup = {} },
	["shield1_spear_glazic_pt4"] = { type = "Model", model = "models/props_interiors/refrigeratorDoor01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shield1", pos = Vector(-0.7, -1.558, 2.595), angle = Angle(3.506, -1.17, 1.169), size = Vector(0.33, 0.33, 0.33), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shield1"] = { type = "Model", model = "models/props_debris/metal_panel02a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-1.558, -4.677, -1.558), angle = Angle(5.843, 57.271, 94.675), size = Vector(0.67, 0.67, 0.67), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}