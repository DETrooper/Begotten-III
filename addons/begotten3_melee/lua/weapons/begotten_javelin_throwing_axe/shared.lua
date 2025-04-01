SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Javelin

SWEP.PrintName = "Throwing Axe"
SWEP.Category = "(Begotten) Throwable"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_javelin_1h"
SWEP.HoldTypeShield = "wos-begotten_javelin_shield"
SWEP.HoldTypeAlternate = "wos-begotten_1h"
SWEP.HoldTypeAlternateShield = "wos-begotten_1h_shield"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

SWEP.IronSights = false;
SWEP.CanParry = false;

--Sounds
SWEP.SoundMaterial = "MetalPierce" -- Metal, Wooden, MetalPierce, Punch, Default
SWEP.AttackSoundTable = "MediumMetalAttackSoundTable"

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/

SWEP.AttackTable = "ThrowingAxeAttackTable"

SWEP.Primary.Round = ("begotten_javelin_throwing_axe_thrown");

SWEP.isJavelin = true;
SWEP.SticksInShields = true;

function SWEP:AttackAnimination()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:GetViewModel():SetPlaybackRate(0.75)
end

function SWEP:CanSecondaryAttack()
	return self:GetNW2String("activeShield"):len() > 0;
end

function SWEP:HandlePrimaryAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)
	
	--Attack animation
	self:TriggerAnim(self.Owner, "a_javelin_throw");
	
	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );
	self.Owner:GetViewModel():SetPlaybackRate(0.8)	
	--self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Weapon:EmitSound(Sound("Weapon_Knife.Slash"))
	self.Owner:ViewPunch(Angle(0, 2, 1))
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 1000);
	
	timer.Create("javelin_timer_"..self.Owner:EntIndex(), 0.5, 1, function()
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon() and self.Owner:GetActiveWeapon().PrintName == "Throwing Axe" then
			self:FireJavelin();
			
			self.Owner.cloakCooldown = CurTime() + 5;
		end
	end);
	
	return false;
end

function SWEP:HandleThrustAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	if self:GetNW2String("activeShield"):len() > 0 then
		self:TriggerAnim(self.Owner, "a_sword_shield_attack_chop_slow_01");
	else
		self:TriggerAnim(self.Owner, "a_sword_attack_chop_slow_01");
	end

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );
	self.Owner:GetViewModel():SetPlaybackRate(0.4)
	
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])
end

function SWEP:FireJavelin()
	local owner = self.Owner;

	if !IsValid(owner) then
		return;
	end

	pos = owner:GetShootPos()
	
	if SERVER then
		local javelin = ents.Create(self.Primary.Round)
		if !javelin:IsValid() then return false end
		
		javelin:SetModel("models/demonssouls/weapons/cut throwing axe offset.mdl");
		javelin:SetAngles(owner:GetAimVector():Angle());
		javelin:SetPos(pos)
		javelin:SetOwner(owner)
		javelin.AttackTable = GetTable(self.AttackTable);
		javelin.Owner = owner
		javelin:Spawn()
		javelin:Activate()

		local phys = javelin:GetPhysicsObject()
		
		if owner.GetCharmEquipped and owner:GetCharmEquipped("hurlers_talisman") then
			phys:SetVelocity(owner:GetAimVector() * 1380);
		else
			phys:SetVelocity(owner:GetAimVector() * 1000);
		end
	end
	
	if SERVER and owner:IsPlayer() then
		local anglo = Angle(1, -5, 1);
		
		owner:ViewPunch(anglo)
		
		local itemTable = Clockwork.item:GetByWeapon(self);
		
		if !itemTable then
			print("itemTable invalid! "..owner:Name().." "..self:GetClass());
			
			return;
		end
		
		if owner.opponent then
			--Clockwork.kernel:ForceUnequipItem(owner, itemTable.uniqueID, itemTable.itemID);
			
			if owner.duelData and owner.duelData.javelins then
				local javelinCount = owner.duelData.javelins[itemTable.uniqueID];
				
				if javelinCount and javelinCount > 1 then
					owner.duelData.javelins[itemTable.uniqueID] = javelinCount - 1;
					
					owner:SetWeaponRaised(false);
					
					return;
				end
			end
			
			--[[if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
				if (itemTable:HasPlayerEquipped(owner)) then
					itemTable:OnPlayerUnequipped(owner)
				end
			end]]--
			
			if owner.StripWeapon then
				owner:StripWeapon("begotten_javelin_throwing_axe");
			end
		else
			local possible_replacements = owner:GetItemsByID(itemTable.uniqueID);
			
			for k, v in pairs(possible_replacements) do
				if !v:IsTheSameAs(itemTable) and !v:IsBroken() then
					self:SetNWInt("ItemID", v.itemID);
					
					local slot;
					
					for i, v2 in ipairs(itemTable.slots) do
						local slotItem = owner.equipmentSlots[v2];
						
						if slotItem and slotItem:IsTheSameAs(itemTable) then
							slot = v2;
						end
					end
					
					Clockwork.equipment:EquipItem(owner, v, slot)
					owner:SetWeaponRaised(false);
					owner:TakeItem(itemTable);
				
					return;
				end
			end
		
			owner:TakeItem(itemTable);
		end
		
		for i, v in ipairs(owner:GetWeaponsEquipped()) do
			local weaponClass = v.weaponClass or v.uniqueID;
		
			if weaponClass and owner:HasWeapon(weaponClass) then
				owner:SelectWeapon(weaponClass);
				
				break;
			end
		end	
	end
end

function SWEP:OnDeploy()
	self.Owner:ViewPunch(Angle(0,1,0))
    self.Weapon:EmitSound("draw/skyrim_mace_draw1.mp3")
	
	if timer.Exists("javelin_timer_"..self.Owner:EntIndex()) then
		timer.Remove("javelin_timer_"..self.Owner:EntIndex());
	end
end

function SWEP:GetHoldtypeOverride()
	if IsValid(self.Owner) then
		if self:GetNW2String("activeShield"):len() > 0 then
			if self.Owner:GetNetVar("ThrustStance") then
				self.realHoldType = self.HoldTypeAlternateShield;
			else
				self.realHoldType = self.HoldTypeShield;
			end
		else
			if self.Owner:GetNetVar("ThrustStance") then
				self.realHoldType = self.HoldTypeAlternate;
			else
				self.realHoldType = self.HoldType;
			end
		end
	end

	return self.realHoldType or self.HoldType;
end

function SWEP:OnMeleeStanceChanged(stance)
	self:SetNWString("stance", stance);
	self.stance = stance;

	if SERVER then
		self:CallOnClient("OnMeleeStanceChanged", stance);
	else
		if self.WElementsAlternate then
			self:Initialize();
			
			return; -- SetHoldType already called in Initialize.
		end
	end
	
	self:SetHoldType(self:GetHoldtypeOverride());
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
	["v_throwing_axe"] = { type = "Model", model = "models/demonssouls/weapons/cut throwing axe.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(0,0,5), angle = Angle(110,40,180), size = Vector(1,1,1), material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_throwing_axe"] = { type = "Model", model = "models/demonssouls/weapons/cut throwing axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -0.9), angle = Angle(-100, -110, 0), size = Vector(1, 1, 1), material = "", skin = 0, bodygroup = {} }
}