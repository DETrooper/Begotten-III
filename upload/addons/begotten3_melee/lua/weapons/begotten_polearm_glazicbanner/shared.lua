SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Polearm

SWEP.PrintName = "Glazic Banner"
SWEP.Category = "(Begotten) Polearm"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_2h"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_heavy_2h_block"
SWEP.CriticalAnim = "a_heavy_2h_attack_slash_02"
SWEP.ParryAnim = "a_heavy_2h_parry"

SWEP.PrimarySwingAnim = "a_heavy_2h_attack_slash_0"

SWEP.IronSightsPos = Vector(3.64, -8.04, -6.56)
SWEP.IronSightsAng = Vector(10, 0.703, 50)

SWEP.LoweredAngles = Angle(-20, 0, 0)

--Sounds
SWEP.AttackSoundTable = "MetalBluntPolearmAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "MetalPierce" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GlazicBannerAttackTable"
SWEP.BlockTable = "GlazicBannerBlockTable"

local bannerDistance = (824 * 824);

function SWEP:CriticalAnimation() --Thrust critical
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.25)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)	
	self.Owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
end 

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, self.PrimarySwingAnim..math.random(1,2));
	
	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.25)
	
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	end end)
	
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:HandleThrustAttack() -- Swipe attack

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_heavy_2h_attack_stab_01");

	-- Viewmodel attack animation!
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:GetViewModel():SetPlaybackRate(0.4)
	
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	end end)

	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,5,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end

function SWEP:Holster()
	local player = self.OwnerOverride or self.Owner;
	
	timer.Remove(player:EntIndex().."IdleAnimation");

	self:StopAllAnims(player);
	
	player:SetNWBool("ThrustStance", false);
	player:SetNWBool("ParrySucess", false) ;
	player:SetNWBool("Riposting", false);

	if CLIENT and IsValid(player) and player:IsPlayer() then
		local vm = player:GetViewModel()
		
		if IsValid(vm) then
			player:SetNWBool( "Parry", false )
			self:ResetBonePositions(vm)
			vm:SetSubMaterial( 0, "" )
			vm:SetSubMaterial( 1, "" )
			vm:SetSubMaterial( 2, "" )
		end
	end
	
	if SERVER then
		self.nextBannerCheck = CurTime() + 2;

		local index = self:EntIndex();

		for k, v in pairs(_player.GetAll()) do
			if v.banners and v.banners[index] then
				v.banners[index] = nil;
			end
		end
	end
	
	return true;
end

-- Unique think for Glazic Banner.
function SWEP:Think()
	local player = self.Owner;
	
	if SERVER then
		local curTime = CurTime();
		
		if !self.nextBannerCheck or self.nextBannerCheck <= curTime then
			self.nextBannerCheck = curTime + 2;
		
			if IsValid(player) then
				local index = self:EntIndex();
				local playerPos = player:GetPos();
			
				--[[for k, v in pairs(ents.FindInSphere(playerPos)) do

				end]]--
				
				for k, v in pairs(_player.GetAll()) do
					if v:Alive() then
						local faction = v:GetFaction();
						
						if !v.banners then
							v.banners = {};
						end
						
						if playerPos:DistToSqr(v:GetPos()) <= (bannerDistance) then
							v.banners[index] = "glazic";
						elseif v.banners[index] then
							v.banners[self:EntIndex()] = nil;
						end
					end
				end
			end
		end
	end
	
	if (player.beginBlockTransition) then
		if (player:GetNWBool("Guardening") == true) then
			self:TriggerAnim2(player, self.BlockAnim, 0);
			
			if ((SERVER) and player:GetNWBool("CanBlock", true)) then
				if (!self.SexyAss) then
					self.SexyAss = GetSoundTable(self.BlockSoundTable);
				end;
				
				if (self.SexyAss) then
					player:EmitSound(self.SexyAss["guardsound"][math.random(1, #self.SexyAss["guardsound"])], 65, math.random(100, 90))
				end;

				player:SetNWBool("CanBlock", false);
			end;
		elseif (player:GetNWBool("Guardening") == false) then
			self:TriggerAnim2(player, self.BlockAnim, 1);
			player:SetNWBool("CanBlock", true)
			
			local velocity = player:GetVelocity();
			local length = velocity:Length();
			local running = player:KeyDown(IN_SPEED);

			if (running and length > 350 and (self.Sprint == true)) then
				local weapon = self.Weapon
				local curTime = CurTime();
				
				weapon:SetNextPrimaryFire(curTime + 0.3);
				weapon:SetNextSecondaryFire(curTime + 0.3);
			end

			function self.Owner:OnTakeDamage(dmginfo)
				self:HandleDamage(dmginfo)
				dmginfo:SetDamage(0)
			end;
		end;
		
		player.beginBlockTransition = false;
	end;
	
	for k, v in next, self.Timers do
		if v.start + v.duration <= CurTime() then
			v.callback()
			self.Timers[k] = nil
		end
	end
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.ViewModelBoneMods = {
	["v_weapon.Knife_Handle"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.444, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -12.789), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0, 2.407), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.3, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.925), angle = Angle(-56.667, 0, 0) }
}

SWEP.VElements = {
	["v_glazicbanner"] = { type = "Model", model = "models/begotten/misc/gatekeeper_banner.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(3.9, 0.2, -17.143), angle = Angle(1.169, -61.949, 10.519), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_glazicbanner"] = { type = "Model", model = "models/begotten/misc/gatekeeper_banner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.3, 1.5, -57.662), angle = Angle(180, -122.727, -2.5), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}