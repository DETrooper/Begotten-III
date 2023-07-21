SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: One Handed

SWEP.PrintName = "1itemweapon"
SWEP.Category = "Begotten Melee"

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_1h"

SWEP.ViewModel = "models/v_onehandedbegotten.mdl"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_sword_block"
SWEP.CriticalAnim = "a_sword_attack_slash_fast_02"
SWEP.ParryAnim = "a_sword_parry"

SWEP.IronSightsPos = Vector(-7.64, -6.433, -0.96)
SWEP.IronSightsAng = Vector(-2.814, 8.442, -48.543)

--Sounds
SWEP.AttackSoundTable = "DefaultAttackSoundTable"
SWEP.BlockSoundTable = "DefaultBlockSoundTable"
SWEP.SoundMaterial = "Default" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = GetTable("DefaultAttackTable")
SWEP.BlockTable = GetTable("DefaultBlockTable")

--[[
local DefaultAttackTable = {
	["primarydamage"] = 10, -- Base damage before multipliers
	["dmgtype"] = 128, -- 4 for Slash, 128 for Blunt, 16 for Pierce
	["attacktype"] = "reg_swing", -- Damage entity that is spawned after a swing. For special weapon types only
	["canaltattack"] = false, -- Alternate attack stance, such as thrust or swipe
	["altattackdamagemodifier"] = 1, -- Modifies damage of alt attack
	["altattackpoisedamagemodifier"] = 0.5, -- Modifies poise damage of alt attack
	["armorpiercing"] = 0, -- Damage multiplier against armored foes 0-100
	["poisedamage"] = 0, -- Poise damage against blockers
	["stabilitydamage"] = 0, -- For knocking people down
	["takeammo"] = 3, -- Poise cost for each swing
	["delay"] = 1, -- Weapon attack delay
	["striketime"] = 0.4, -- Weapon attack speed
	["meleerange"] = 500, -- Weapon reach
	["hitscandistance"] = 45, -- Hitscan reach (for hitting objects, ragdolls and world. deals no damage)
	["punchstrength"] = Angle(0,1,0), -- Viewpunch when swinging
};
local DefaultBlockTable = {
	["guardblockamount"] = 10, -- Minimum poise taken after blocking
	["specialeffect"] = false, -- Special effect for sacrifical weapons
	["blockeffect"] = "MetalSpark", -- Draws an effect upon blocking
	["blockeffectforward"] = 25, -- How far out the block particle is from the player 
	["blockeffectpos"] = (Vector(0, -5, 65)), -- Position that the block particle appears when hit 
	["blockcone"] = 75, -- Blocks damage in degrees around your eyecursor
	["blockdamagetypes"] = {DMG_SLASH, DMG_CLUB, DMG_VEHICLE}, -- Will block these damge types
	["partialbulletblock"] = false, -- Whether or not to block 70% damage from bullets. Make sure DMG_BULLET is not listed above if true.
	["poiseresistance"] = 15, -- Poise damage deducted from enemy attacks
	["parrydifficulty"] = 0.15, -- Parry frames, more means parrying is easier
	["parrytakestamina"] = 15, -- Poise cost for parrying
	["canparry"] = true, -- Whether or not you can parry
};
--]]

if (SERVER) then
	-- A function to update the block table.
	function SWEP:UpdateBlockTable(newTable)
		self.BlockTable = table.Merge(newTable, self.BlockTable);
		PrintTable(self.BlockTable)
	end;
	
	-- A function to update the block sound table.
	function SWEP:UpdateBlockSoundTable(newTable)
		self.BlockSoundTable = table.Merge(newTable, self.BlockSoundTable);
	end;
	
	-- A function to update the weapon's animations.
	function SWEP:SetAnimations(block, critical, parry)
		if (block) then
			SWEP.BlockAnim = block;
		end;
		
		if (critical) then
			SWEP.CriticalAnim = critical;
		end;
		
		if (parry) then
			SWEP.ParryAnim = parry;
		end;
	end;
	
	-- A function to set the weapon's sound material.
	function SWEP:SetSoundMaterial(material)
		if (!self.validMaterials) then
			self.validMaterials = {
				["Metal"] = true,
				["Wooden"] = true,
				["MetalPierce"] = true,
				["Punch"] = true,
				["Default"] = true,
			};
		end;
		
		if (material and isstring(material) and self.validMaterials[material]) then
			self.SoundMaterial = material
		end;
	end;
	
	-- A function to update the attack table.
	function SWEP:UpdateAttackTable(newTable)
		self.AttackTable = newTable;
	end;
	
	-- A function to update the attack sound table.
	function SWEP:UpdateAttackSoundTable(newTable)
		self.AttackSoundTable = newTable;
	end;
end;

function SWEP:CriticalAnimation()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local viewModel = self.Owner:GetViewModel();
	viewModel:SendViewModelMatchingSequence(viewModel:LookupSequence("misscenter1"));
	self.Owner:GetViewModel():SetPlaybackRate(0.7)
	
	if (SERVER) then
		timer.Simple(0.05, function()
			if self:IsValid() then
				self.Weapon:EmitSound(table.Random(attacksoundtable["criticalswing"]));
			end;
		end);
	
		self.Owner:ViewPunch(Angle(1,4,1))
	end
end

function SWEP:ParryAnimation()
	local viewModel = self.Owner:GetViewModel()
	viewModel:SendViewModelMatchingSequence(viewModel:LookupSequence("misscenter1"))
end

function SWEP:HandlePrimaryAttack()
	local attacktable = GetTable(self.AttackTable);
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local viewModel = self.Owner:GetViewModel()
	viewModel:SendViewModelMatchingSequence(viewModel:LookupSequence("misscenter1"))
	self.Owner:GetViewModel():SetPlaybackRate(0.7)

	self:TriggerAnim(self.Owner, "a_sword_attack_slash_fast_0"..math.random(1, 2));
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])
end

function SWEP:HandleThrustAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_sword_attack_stab_fast_01");

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("thrust1"))
	self.Owner:GetViewModel():SetPlaybackRate(0.8)
	
	self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])])
	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(0,1,0))
	self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])])
end