SWEP.Base = "sword_swepbase"
-- WEAPON TYPE: Fisted

SWEP.PrintName = "Hands"
SWEP.Category = "(Begotten) Fisted"
SWEP.Author = ""
SWEP.Instructions = "";

SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.Weight = 9000
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
SWEP.AttackSoundTable = "PunchAttackSoundTable"
SWEP.BlockSoundTable = "FistBlockSoundTable"
SWEP.SoundMaterial = "Punch" -- Metal, Wooden, MetalPierce, Punch, Default

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "FistAttackTable"
SWEP.BlockTable = "FistBlockTable"

function SWEP:AttackAnimination()
	self:PlayPunchAnimation()
end

-- Overrides
function SWEP:PrimaryAttack()
	local wep = self.Weapon
	local ply = self.Owner
	local attacktable = GetTable(self.AttackTable);
	local curTime = CurTime();
	
	self.HolsterDelay = (curTime + attacktable["striketime"])
	
	if (IsValid(self.SwingEntity)) then
		self.SwingEntity:Remove()
	end
	
	--if self.Owner:Name() == "Mister Electric" then
	if self.Owner:IsPlayer() then
		if Clockwork.player:HasFlags(self.Owner, "T") then
			if SERVER then
				local foundents = 0
				
				for id, ent in pairs( self:SelectTargets( 3 ) ) do
					if ( !IsValid( ent ) ) then continue end

					foundents = foundents + 1
					local ed = EffectData()
					ed:SetOrigin(self.Owner:GetPos() + Vector(0, 0, 48));
					ed:SetEntity( ent )
					util.Effect( "rb655_force_lighting", ed, true, true )

					local dmg = DamageInfo()
					dmg:SetAttacker( self.Owner or self )
					dmg:SetInflictor( self.Owner or self )

					dmg:SetDamage(10);
					dmg:SetDamageForce(self:GetOwner():GetAimVector() * 100);
					ent:TakeDamageInfo( dmg )
					
					--[[local effectdata = EffectData()
					effectdata:SetOrigin(ent:GetPos() + Vector(0,0,48))
					effectdata:SetScale( 2 )
					effectdata:SetMagnitude( 3 )
					util.Effect( "ElectricSpark", effectdata )]]--

					if Clockwork.entity:IsPlayerRagdoll(ent) then
						Clockwork.entity:GetPlayer(ent):TakeStability(200, 10);
					elseif ent:IsPlayer() then
						ent:TakeStability(200, 10);
					end
					
					local num = string.format("%02d",math.random(1,11));
					ent:EmitSound("ambient/energy/newspark"..num..".wav");
					
					if ent:IsPlayer() then
						local ragdollEntity = ent:GetRagdollEntity();
						
						if (IsValid(ragdollEntity)) then
							ragdollEntity:Fire("startragdollboogie")
						end
					end
				end

				if ( foundents > 0 ) then
					--self:SetForce( self:GetForce() - foundents )
					if ( !self.SoundLightning ) then
						self.SoundLightning = CreateSound( self.Owner, "meleesounds/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
						self.SoundLightning:Play()
					else
						self.SoundLightning:Play()
					end

					timer.Create( "rb655_force_lighting_soundkill", 1, 1, function() if ( self.SoundLightning ) then self.SoundLightning:FadeOut(1) self.SoundLightning = nil end end )
				end
			end
			
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.2);
			
			return true;
		elseif Clockwork.player:HasFlags(self.Owner, "K") then
			if SERVER then
				timer.Simple(0.5, function()
					if IsValid(self.Owner) then
						local explosion = ents.Create("env_explosion");
						local explosionPos = self.Owner:GetPos() + (self.Owner:GetForward() * 32);
						
						for k, v in ipairs(ents.FindInSphere(explosionPos, 256)) do
							if (v:IsPlayer() and v ~= self.Owner) then
								local damageInfo = DamageInfo();

								damageInfo:SetDamagePosition(explosionPos);
								damageInfo:SetDamageForce(VectorRand() * 5);
								damageInfo:SetDamageType(DMG_BLAST);
								damageInfo:SetDamage(1000);
								
								--if (bGib) then
									--timer.Simple(3, function()
										Clockwork.plugin:Call("SplatCorpse", entity, 60, damageInfo:GetDamageForce());
									--end)
								--end;
							end;
						end;
						
						explosion:SetPos(self.Owner:GetPos());
						explosion:SetKeyValue("iMagnitude", "100");
						explosion:Spawn();
						explosion:Activate();
						explosion:Fire("Explode", "", 0);
					end;
				end);
			end
		end
	end

	-- Critical Attack
	-- OPTIMIZE NOTE: need to go through this again, my code probably some sloppy wacky shit being done
	if self.Owner:GetNWBool("ParrySucess") == true then
		if SERVER then  
			self:CriticalAnimation() 
			
			if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("flamboyance") then
				self.Weapon:SetNextPrimaryFire(curTime + ((attacktable["delay"]) * 0.9))
			else
				self.Weapon:SetNextPrimaryFire(curTime + (attacktable["delay"]))
			end
			
			self.Weapon:SetNextSecondaryFire(curTime + (attacktable["delay"]) * 0.1)
			self.isAttacking = true;
			
			self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..curTime, function()
				if IsValid(self) and IsValid(self.Owner) then
					if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
						if self.Owner:IsPlayer() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
							self:Hitscan(); -- For bullet holes.
							
							local pos = self.Owner:GetShootPos()
							local ang = self.Owner:GetAimVector():Angle()
							pos = pos + ang:Forward() + ang:Up()
							
							local add = 0
							local vel = self.Owner:GetVelocity():Length();
							if (vel > 0) then
								add = (vel / 10);
							end;
							local cum = self.Owner:GetEyeTrace().Entity;
							local tardist = 0;
							if (IsValid(cum) and cum:IsPlayer() or cum:IsNPC()) then
								tardist = math.abs((self.Owner:GetPos() - cum:GetPos()):Length()) -- autism
							end;
							if (add > tardist) then
								add = (tardist / 2)
							end;
							local sex = self.Owner:GetForward() * add;
								
							local ent = ents.Create("parry_swing")
							ent:SetAngles(self.Owner:GetAimVector():Angle())
							ent:SetOwner(self.Weapon:GetOwner())
							ent:SetPos(pos+sex)
							ent:Spawn()
							ent:Activate()
							ent:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 5)
							self.SwingEntity = ent;
							self.isAttacking = false;
						end
					end
				end
			end)
		end
		
		self.Owner:SetNWBool("Riposting", true) 
		self:CreateTimer(attacktable["striketime"] + 0.1, "riposteTimer"..curTime, function() 
			if IsValid(self) and self.Owner:IsValid() and self.Owner:Alive() and !self.Owner:IsRagdolled() then
				self.Owner:SetNWBool("Riposting", false)
			end
		end)
			
		self:TriggerAnim(self.Owner, self.Weapon.CriticalAnim);
		self.Owner:SetNWBool("ParrySucess", false) 
		return
	end
	
	if ( !self:CanPrimaryAttack() ) then 
		return
	end
	
	if self.Owner:GetNWBool("ThrustStance") == true then
		self.Owner.stance = "thrust_swing"
	else
		self.Owner.stance = (attacktable["attacktype"])
	end
	
	if self.Owner:GetNWBool("Guardening") == true then 
		return true 
	end

	--self.Owner.StaminaRegenDelay = 0
	self.Owner.nextStas = curTime + 5;

	wep:SetNextPrimaryFire( curTime + (attacktable["delay"]) )
	wep:SetNextSecondaryFire( curTime + (attacktable["delay"]) * 0.1 )
	
	if CLIENT then
		hook.Run("PlayerAttacks", self.Owner);
	end
	
	-- GLITCHED
	if self.HandleThrustAttack and self.Owner:GetNWBool("ThrustStance") == true and !self.Owner:GetNWBool("Riposting") then
		self:HandleThrustAttack()
	else
		self:HandlePrimaryAttack()
	end

	local rnda = self.Primary.Recoil * 1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	
	if SERVER and self:IsValid() and (!self.Owner.IsRagdolled or !self.Owner:IsRagdolled()) and self.Owner:Alive() then 
		ply:SetNWBool( "MelAttacking", true )
		
		self.isAttacking = true;
			
		self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..curTime, function()
			if IsValid(self) and IsValid(self.Owner) then
				if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
					if self.Owner:IsPlayer() and (!self.Owner.IsRagdolled or !self.Owner:IsRagdolled()) and self.Owner:Alive() then
						if self.Category == "(Begotten) Javelin" then
							ply:SetNWBool( "MelAttacking", false )
							self.isAttacking = false;
						else
							self:Hitscan(); -- For bullet holes.
							
							local pos = self.Owner:GetShootPos()
							local ang = self.Owner:GetAimVector():Angle()
							pos = pos + ang:Forward() + ang:Up()
				
							local add = 0
							local vel = self.Owner:GetVelocity():Length();
							if (vel > 0) then
								add = (vel / 10);
							end;
							local cum = self.Owner:GetEyeTrace().Entity;
							local tardist = 0;
							if (IsValid(cum) and cum:IsPlayer() or cum:IsNPC()) then
								tardist = math.abs((self.Owner:GetPos() - cum:GetPos()):Length()) -- autism
							end;
							if (add > tardist) then
								add = (tardist / 2)
							end;
							
							if !self.Owner:GetNWBool("Parry") then 
								local sex = self.Owner:GetForward() * add;
								local ent = ents.Create(self.Owner.stance)
								ent:SetAngles(self.Owner:GetAimVector():Angle())
								ent:SetOwner(self.Weapon:GetOwner())
								ent:SetPos(pos + sex)
								ent:Spawn()
								ent:Activate()
								ent:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector() * 5)
								ply:SetNWBool( "MelAttacking", false )
								self.Owner.Cum = ent;
								self.SwingEntity = ent;
								self.isAttacking = false;
							end
							
							if (self.Owner:KeyDown(IN_ATTACK2)) then
								if (!self.Owner:KeyDown(IN_USE)) then
									local activeWeapon = self.Owner:GetActiveWeapon();

									if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
										if (activeWeapon.IronSights == true) then
											local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
											local curTime = CurTime();
											
											if (loweredParryDebug < curTime) then
												local blockTable = GetTable(activeWeapon.BlockTable);
												
												if (blockTable and self.Owner:GetNWInt("meleeStamina", 100) >= blockTable["guardblockamount"] and !self.Owner:GetNWBool("Parried")) then
													self.Owner:SetNWBool("Guardening", true);
													self.Owner.beginBlockTransition = true;
													self.Owner.StaminaRegenDelay = 0;
													activeWeapon.Primary.Cone = activeWeapon.IronCone;
													activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
												else
													self.Owner:CancelGuardening()
												end;
											end;
										else
											self.Owner:CancelGuardening();
										end;
									end;
								end
							end
						end
					end
				end
			end
		end)
	end

	if (SERVER) then
		local max_poise = ply:GetNetVar("maxMeleeStamina");
		
		ply:SetNWInt("meleeStamina", math.Clamp(ply:GetNWInt("meleeStamina", max_poise) - (attacktable["takeammo"]), 0, max_poise))
	end;
end

function SWEP:HandlePrimaryAttack()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, "a_fists_attack"..math.random(1, 2));

	-- Viewmodel attack animation!
	self:PlayPunchAnimation();

	timer.Simple( 0.09, function() if self:IsValid() then
	self:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])]) end end)

	self.Owner:ViewPunch(attacktable["punchstrength"])
end

function SWEP:OnDeploy()
	local vm = self.Owner:GetViewModel();
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"));
end

function SWEP:PlayPunchAnimation()
	if (SERVER) then
		self.Weapon:CallOnClient("PlayPunchAnimation", "");
	end;

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
	
	if ( self.SoundLightning ) then self.SoundLightning:FadeOut(1) self.SoundLightning = nil end

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