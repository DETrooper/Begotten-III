SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Fisted

SWEP.PrintName = "Iron Knuckles"
SWEP.Category = "(Begotten) Fisted"
SWEP.Author = ""
SWEP.Instructions = "";

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 2
SWEP.UseHands = true

SWEP.HoldType = "wos-begotten_fists"

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false

--Anims
SWEP.BlockAnim = "a_fists_block"

SWEP.IronSightsPos = Vector(0, -5, -2)
SWEP.IronSightsAng = Vector(20, 0, 0)

SWEP.LoweredAngles = Angle(-50, 0, 0)

--Sounds
SWEP.AttackSoundTable = "MetalFistedAttackSoundTable"
SWEP.BlockSoundTable = "FistBlockSoundTable"
SWEP.SoundMaterial = "Punch" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "IronKnucklesAttackTable"
SWEP.BlockTable = "IronKnucklesBlockTable"

function SWEP:AttackAnimination()
	self:PlayPunchAnimation()
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_fists_attack"..math.random(1, 2));

	-- Viewmodel attack animation!
	if (SERVER) then
		self:PlayPunchAnimation();
	end

	timer.Simple( 0.09, function() if self:IsValid() then
	self:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])]) end end)

	self.Owner:ViewPunch(attacktable["punchstrength"])

end

function SWEP:OnDeploy()
	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"));
end

function SWEP:PlayPunchAnimation()
	--[[if (SERVER) then
		self.Weapon:CallOnClient("PlayPunchAnimation", "");
	end;]]--

 	if (self.left == nil) then self.left = true; else self.left = !self.left; end;

	local anim = "fists_right";
 
 	if (self.left) then
		anim = "fists_left";
	end;
 
 	local vm = self.Owner:GetViewModel();

 	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim));	self.Owner:GetViewModel():SetPlaybackRate(0.55)

end;

function SWEP:PlayKnockSound()
	if (SERVER) then
		self.Weapon:CallOnClient("PlayKnockSound", "");
	end;
	self.Weapon:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
end;

function SWEP:Hitscan()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * (attacktable["meleerange"] * 0.1),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * (attacktable["meleerange"] * 0.1),
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
		self.Owner:ViewPunch(Angle(-3,1,0))
		self.Owner:EmitSound(attacksoundtable["hitworld"][math.random(1, #attacksoundtable["hitworld"])])
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	self.Owner:LagCompensation( false )
	
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	local ply = self.Owner
	local wep = self.Weapon

	if (!Clockwork.player:GetWeaponRaised(ply)) then
		if (SERVER) then
			local trace = self.Owner:GetEyeTraceNoCursor();

			if (IsValid(trace.Entity) and Clockwork.entity:IsDoor(trace.Entity)) then
				if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 64) then
					if (hook.Run("PlayerCanKnockOnDoor", self.Owner, trace.Entity)) then
						self:PlayKnockSound();
					
						self.Weapon:SetNextPrimaryFire(CurTime() + 0.25);
						self.Weapon:SetNextSecondaryFire(CurTime() + 0.25);
					
						hook.Run("PlayerKnockOnDoor", self.Owner, trace.Entity);
					end;
				end;
			end;
		end;
	else
		local LoweredParryDebug = self:GetNextSecondaryFire()
		local ParryDelay = self:GetNextPrimaryFire()

		if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_RELOAD) and self.Owner:GetNWBool("Guardening") == true then
			-- Deflection
			if self.Owner:GetNWBool( "CanDeflect", true ) then
			
				if self.Owner.HasBelief and self.Owner:HasBelief("deflection") then
					self.Owner:SetNWBool( "Deflect", true )
				end
				
				self.Owner:SetNWBool( "CanDeflect", false )
				timer.Simple( 1,function() if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
				self.Owner:SetNWBool( "CanDeflect", true ) end end)
				timer.Simple( 0.15,function() if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
				self.Owner:SetNWBool( "Deflect", false ) end end)
			end
		end			
	end			
end

function SWEP:OnDrop()
	self:Remove();
end;

/*---------------------------------------------------------
	Bone Mods
---------------------------------------------------------*/
SWEP.VElements = {
	["v_ironknuckle_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knuckles.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2, 0.389, 0), angle = Angle(0, -106.364, -92.338), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["v_ironknuckle_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knuckles.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 0.5, -0.201), angle = Angle(0, -106.364, -92.338), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_ironknuckles_right"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knuckles.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.099, 0.85, 0.15), angle = Angle(-15.195, 97.013, 85.324), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["w_ironknuckles_left"] = { type = "Model", model = "models/mosi/fallout4/props/weapons/melee/knuckles.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2, 0.649, 0.6), angle = Angle(1.169, 90, 111.039), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}