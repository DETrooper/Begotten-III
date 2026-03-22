SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "Whip"
SWEP.Category = "(Begotten) One Handed"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h"
SWEP.HoldTypeShield = "wos-begotten_1h_shield"

SWEP.ViewModel = "models/v_onehandedbegotten.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_block"
SWEP.CriticalAnim = "a_sword_attack_slash_slow_01"
SWEP.CriticalAnimShield = "a_sword_shield_attack_slash_slow_01"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(-7.64, -6.433, -0.96)
SWEP.IronSightsAng = Vector(-2.814, 8.442, -48.543)

--Sounds
SWEP.AttackSoundTable = "LeatherWhipAttackSoundTable"
SWEP.BlockSoundTable = "FistBlockSoundTable"
SWEP.SoundMaterial = "Punch" -- Metal, Wooden, MetalPierce, Punch, Default
SWEP.MultiHit = 5;
SWEP.WhipSpeedBoost = true;
SWEP.WhipPoison = true;
SWEP.CorruptionGain = 1;

function SWEP:SendAnimation(seq)
	net.Start("cwSWEPAnimator");
		net.WriteEntity(self);
		net.WriteString("v_whip");
		net.WriteString("w_whip");
		net.WriteString(seq);
	net.Broadcast();

end

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "SatanicWhipAttackTable"
SWEP.BlockTable = "SatanicWhipBlockTable"

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
	if self:GetNW2String("activeShield"):len() > 0 then
		self:TriggerAnim(self.Owner, "a_sword_shield_attack_slash_slow_01");
	else
		self:TriggerAnim(self.Owner, "a_sword_attack_slash_slow_01");
	end

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	self.Owner:GetViewModel():SetPlaybackRate(0.45)

	if(SERVER) then self:SendAnimation("swing"); end
	
	self.Weapon:EmitSound("begotten/weapons/whip/discipline_device_woosh_01.wav", 100, math.random(85, 95))
	self.Owner:ViewPunch(attacktable["punchstrength"])

	if self.Owner.HandleNeed and not self.Owner.opponent and !self.Owner:GetCharmEquipped("warding_talisman") then
		if !self.Owner:GetCharmEquipped("crucifix") then
			self.Owner:HandleNeed("corruption", self.CorruptionGain);
		else
			self.Owner:HandleNeed("corruption", self.CorruptionGain * 0.5);
		end
	end

end

function SWEP:PostThink()
	if(SERVER) then return; end

	local vWhip = self.VElements["v_whip"].modelEnt;
	local wWhip = self.WElements["w_whip"].modelEnt;
	
	if(IsValid(vWhip)) then
		if(vWhip:GetSequence() == vWhip:LookupSequence("swing") and vWhip:GetCycle() == 1) then
			vWhip:ResetSequence("idle");

		end

		vWhip:FrameAdvance();

	end

	if(IsValid(wWhip)) then
		if(wWhip:GetSequence() == wWhip:LookupSequence("swing") and wWhip:GetCycle() == 1) then
			wWhip:ResetSequence("idle");

		end

		wWhip:FrameAdvance();

	end

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;

end

function SWEP:Deploy()
	if SERVER then
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			local weaponItem = Clockwork.item:GetByWeapon(self);
			
			if weaponItem then
				if weaponItem.canUseOffhand then
					for i, v in ipairs(weaponItem.slots) do
						if v then
							local slot = self.Owner.equipmentSlots[v];

							if slot and slot.weaponClass == self:GetClass() then
								local offhandSlot = self.Owner.equipmentSlots[v.."Offhand"];
								
								if offhandSlot and offhandSlot.weaponClass then
									self:EquipOffhand(offhandSlot.weaponClass);
								end

								break;
							end
						end
					end
				end
				
				if self:GetNW2String("activeOffhand"):len() <= 0 and weaponItem.canUseShields then
					local shieldItem = self.Owner:GetShieldEquipped();
					
					if (shieldItem) then
						for i, v in ipairs(shieldItem.slots) do
							if v then
								local slot = self.Owner.equipmentSlots[v];
								
								if slot then
									if slot.weaponClass == self:GetClass() then
										self:EquipShield(shieldItem.uniqueID);
										
										break;
									end
								end
							end
						end
					end
				end
			end
			
			self.Weapon:CallOnClient("Initialize");
		end

		if self.OnMeleeStanceChanged then
			self:OnMeleeStanceChanged("reg_swing");
		end

		self:SendAnimation("idle");

	end
	
	self.Owner.gestureweightbegin = 2;
	self.Owner:SetLocalVar("CanBlock", true)
	self.canDeflect = true;
	self.Owner:SetNetVar("ThrustStance", false)
	self.Owner:SetLocalVar("ParrySuccess", false) 
	self.Owner:SetLocalVar("Riposting", false)
	self.Owner:SetLocalVar("MelAttacking", false ) -- This should fix the bug where you can't block until attacking.
	self.OwnerOverride = self.Owner;

	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(0)
	self:SetNextSecondaryFire(0)
	self:SetHoldType(self:GetHoldtypeOverride())
	self.Primary.Cone = self.DefaultCone
	--self.Weapon:SetNWInt("Reloading", CurTime() + self:SequenceDuration() )
	self.isAttacking = false;
	
	if self:GetClass() == "begotten_fists" or (!self.Owner.cwWakingUp and !self.Owner.LoadingText) then
		if self:GetNW2String("activeShield"):len() <= 0 then
			local offhandWeapon = weapons.GetStored(self:GetNW2String("activeOffhand"));
			
			if offhandWeapon then
				local attacksoundtable = GetSoundTable(self.AttackSoundTable);
				local attacksoundtableOffhand = GetSoundTable(offhandWeapon.AttackSoundTable);
				
				self.Owner:ViewPunch(Angle(0,1,0));
				
				if !self.Owner.cwObserverMode then 
					self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
					self.Weapon:EmitSound(attacksoundtableOffhand["drawsound"][math.random(1, #attacksoundtableOffhand["drawsound"])])
				end
				
				return true;
			end
		end

		self:OnDeploy();
	end
	
	return true
end

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/

SWEP.VElements = {
	["v_whip"] = { type = "Model", model = "models/begotten/weapons/whip.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.602, 1.629, 7.988), angle = Angle(4, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_whip"] = { type = "Model", model = "models/begotten/weapons/whip.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.151, 7.82), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

hook.Remove("PostCalculatePlayerDamage", "cwSatanicWhipTakeDamagePoison");
hook.Add("PreCalculatePlayerDamage", "cwSatanicWhipTakeDamagePoison", function(entity, hitGroup, damageInfo)
	local curTime = CurTime();
	local attacker = damageInfo:GetAttacker();
	if(!IsValid(attacker) or !attacker:IsPlayer()) then return; end

	local weapon = damageInfo:GetInflictor();
	if(!IsValid(weapon)) then return; end
	if(damageInfo:GetDamage() <= 0) then return; end

	if(weapon.WhipSpeedBoost) then
		attacker:SetNWFloat("WhipSpeedBoost", curTime + 5);
		hook.Run("RunModifyPlayerSpeed", attacker, attacker.cwInfoTable, true);

	end

	if(entity:GetFaith() == "Faith of the Dark") then
		if(weapon.WhipSpeedBoost) then
			damageInfo:ScaleDamage(0.25);
			entity:SetNWFloat("WhipSpeedBoost", curTime + 5);
			hook.Run("RunModifyPlayerSpeed", entity, entity.cwInfoTable, true);

		end
		
		return;
	
	end

	if(!weapon.WhipPoison) then return; end

	if(!entity.whipScare or entity.whipScare < curTime) then
		entity.whipScare = curTime + 20;
		netstream.Start(entity, "ScarePlayer");

	end

	entity:ModifyBloodLevel(-150);
	entity:HandleSanity(math.random(-2, -1));

	entity.poisonTicks = math.random(5, 6);
	entity.poisoner = attacker;
	entity.poisoninflictor = inflictor;

end);

local fovModifier = 0;
hook.Add("CalcViewAdjustTable", "cwSatanicWhipSpeedBoostFOV", function(view)
	local curTime = CurTime();

    if(Clockwork.character.isOpen) then return; end

	local speedBoostTime = Clockwork.Client:GetNWFloat("WhipSpeedBoost", 0);
	if(speedBoostTime < curTime) then return; end

	fovModifier = math.Approach(fovModifier, (speedBoostTime - curTime < 0.35 and 0 or 15), 40 * RealFrameTime());

    view.fov = view.fov + fovModifier;

end);

hook.Add("ModifyPlayerSpeed", "cwSatanicWhipSpeedBoost", function(player, infoTable)
	local curTime = CurTime();

	if(player:GetNWFloat("WhipSpeedBoost", 0) > curTime) then
		infoTable.runSpeed = infoTable.runSpeed * 1.15;
		infoTable.walkSpeed = infoTable.walkSpeed * 1.15;

	end

end);

if(SERVER) then
	util.AddNetworkString("cwSWEPAnimator");

else
	net.Receive("cwSWEPAnimator", function()
		local weapon = net.ReadEntity();
		local viewModelName = net.ReadString();
		local worldModelName = net.ReadString();
		local sequence = net.ReadString();

		if(!IsValid(weapon)) then return; end
		if(!weapon.VElements or !weapon.WElements) then return; end

		local vModel = weapon.VElements[viewModelName].modelEnt;
		if(IsValid(vModel)) then
			vModel:ResetSequence(sequence);
			vModel:SetPlaybackRate(1);
			vModel:SetCycle(0);

		end

		local wModel = weapon.WElements[worldModelName].modelEnt;
		if(IsValid(wModel)) then
			wModel:ResetSequence(sequence);
			wModel:SetPlaybackRate(1);
			wModel:SetCycle(0);

		end
	
	end);

end