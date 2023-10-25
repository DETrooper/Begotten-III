SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Javelin

SWEP.PrintName = "Pilum"
SWEP.Category = "(Begotten) Javelin"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_javelin"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false

SWEP.IronSights = false;
SWEP.CanParry = false;

--Sounds
SWEP.SoundMaterial = "MetalPierce" -- Metal, Wooden, MetalPierce, Punch, Default
SWEP.AttackSoundTable = "MetalSpearAttackSoundTable" 

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/

SWEP.AttackTable = "PilumAttackTable"

SWEP.Primary.Round = ("begotten_javelin_pilum_thrown");

SWEP.isJavelin = true;
SWEP.SticksInShields = true;

function SWEP:Hitscan()
	return false;
end

function SWEP:AttackAnimination()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	self.Owner:GetViewModel():SetPlaybackRate(0.75)
end

function SWEP:CanSecondaryAttack()
	return false;
end

function SWEP:SecondaryAttack()
	return false;
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
	self.Owner:ViewPunch(attacktable["punchstrength"])
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 1000);
	
	timer.Create("javelin_timer_"..self.Owner:EntIndex(), 0.5, 1, function()
		if IsValid(self) and IsValid(self.Owner) and self.Owner:GetActiveWeapon() and self.Owner:GetActiveWeapon().PrintName == "Pilum" then
			self:FireJavelin();
		end
	end);
end

function SWEP:FireJavelin()
	if !IsValid(self.Owner) then
		return;
	end

	pos = self.Owner:GetShootPos()
	
	if SERVER then
		local javelin = ents.Create(self.Primary.Round)
		if !javelin:IsValid() then return false end
		
		javelin:SetModel("models/props/begotten/melee/heide_lance.mdl");
		javelin:SetAngles(self.Owner:GetAimVector():Angle())
		javelin:SetPos(pos)
		javelin:SetOwner(self.Owner)
		javelin:Spawn()
		javelin.AttackTable = self.AttackTable;
		javelin.Owner = self.Owner
		javelin:Activate()
		eyes = self.Owner:EyeAngles()
		
		local phys = javelin:GetPhysicsObject()
		
		if self.Owner.GetCharmEquipped and self.Owner:GetCharmEquipped("hurlers_talisman") then
			phys:SetVelocity(self.Owner:GetAimVector() * 1600);
		else
			phys:SetVelocity(self.Owner:GetAimVector() * 1250);
		end
	end
	
	if SERVER and self.Owner:IsPlayer() then
		local anglo = Angle(-10, -5, 0);
		
		self.Owner:ViewPunch(anglo)
		
		local itemTable = Clockwork.item:GetByWeapon(self);
		
		if itemTable then
			if self.Owner.opponent then
				--Clockwork.kernel:ForceUnequipItem(self.Owner, itemTable.uniqueID, itemTable.itemID);
				
				if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
					if (itemTable:HasPlayerEquipped(self.Owner)) then
						itemTable:OnPlayerUnequipped(self.Owner)
						--[[self.Owner:RebuildInventory()
						self.Owner:SetWeaponRaised(false)]]--
					end
				end
				
				if self.Owner.StripWeapon then
					self.Owner:StripWeapon("begotten_javelin_pilum");
				end
			else
				self.Owner:TakeItem(itemTable, true);
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

function SWEP:TriggerAnim2(target, anim, beginorend)
	return;
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
	["v_pilum"] = { type = "Model", model = "models/props/begotten/melee/heide_lance.mdl", bone = "v_weapon.Knife_Handle", rel = "", pos = Vector(2.4, 0.15, -6.753), angle = Angle(105, 0, 82.986), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_pilum"] = { type = "Model", model = "models/props/begotten/melee/heide_lance.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.89, 0.2, -10.91), angle = Angle(97.013, 40.909, 54.935), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}