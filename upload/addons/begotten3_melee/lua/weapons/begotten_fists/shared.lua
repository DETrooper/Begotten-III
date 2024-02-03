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
SWEP.CriticalAnim = "a_fists_attack1"
SWEP.ParryAnim = "a_dual_swords_parry"

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

function SWEP:CriticalAnimation()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)
	local owner = self.Owner;

	-- Viewmodel attack animation!
	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_uppercut" ) )
	owner:GetViewModel():SetPlaybackRate(0.4)
	
	if (SERVER) then
	timer.Simple( 0.05, function() if self:IsValid() then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)	
	owner:ViewPunch(Angle(1,4,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_uppercut" ))
end

function SWEP:AttackAnimination()
	self:PlayPunchAnimation()
end

-- Overrides
function SWEP:PrimaryAttack()
	local wep = self.Weapon;
	local owner = self.Owner;
	local attacktable = GetTable(self.AttackTable);
	
	if (!self:CanPrimaryAttack()) then 
		return true;
	end
	
	if owner:GetNWBool("Guardening") == true then 
		return true;
	end
	
	if !attacktable then
		return true;
	end
	
	--if owner:Name() == "Mister Electric" then
	if owner:IsPlayer() then
		if Clockwork.player:HasFlags(owner, "T") then
			if SERVER then
				local foundents = 0
				
				for id, ent in pairs( self:SelectTargets( 3 ) ) do
					if ( !IsValid( ent ) ) then continue end

					foundents = foundents + 1
					local ed = EffectData()
					ed:SetOrigin(owner:GetPos() + Vector(0, 0, 48));
					ed:SetEntity( ent )
					util.Effect( "rb655_force_lighting", ed, true, true )

					local dmg = DamageInfo()
					dmg:SetAttacker( owner or self )
					dmg:SetInflictor( owner or self )

					dmg:SetDamage(10);
					dmg:SetDamageForce(self:GetOwner():GetAimVector() * 100);
					dmg:SetDamageType(DMG_SHOCK);
					dmg:SetInflictor(self);
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
						self.SoundLightning = CreateSound( owner, "meleesounds/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
						self.SoundLightning:Play()
					else
						self.SoundLightning:Play()
					end

					timer.Create( "rb655_force_lighting_soundkill", 1, 1, function() if ( self.SoundLightning ) then self.SoundLightning:FadeOut(1) self.SoundLightning = nil end end )
				end
			end
			
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.2);
			
			return true;
		elseif Clockwork.player:HasFlags(owner, "K") then
			if SERVER then
				timer.Simple(0.5, function()
					if IsValid(owner) then
						local explosion = ents.Create("env_explosion");
						local explosionPos = owner:GetPos() + (owner:GetForward() * 32);
						
						for k, v in ipairs(ents.FindInSphere(explosionPos, 256)) do
							if (v:IsPlayer() and v ~= owner) then
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
						
						explosion:SetPos(owner:GetPos());
						explosion:SetKeyValue("iMagnitude", "100");
						explosion:Spawn();
						explosion:Activate();
						explosion:Fire("Explode", "", 0);
					end;
				end);
			end
		end
	end
	
	local curTime = CurTime();
	local stance = "reg_swing";
	
	if owner:GetNWBool("ThrustStance") == true then
		stance = "thrust_swing";
	else
		stance = (attacktable["attacktype"]);
	end
	
	if CLIENT then
		hook.Run("PlayerAttacks", owner);
	end
	
	-- Critical Attack
	if owner:GetNWBool("ParrySucess") == true then
		if SERVER then  
			self:CriticalAnimation() 
			
			if cwBeliefs and owner.HasBelief and owner:HasBelief("flamboyance") then
				self.Weapon:SetNextPrimaryFire(curTime + ((attacktable["delay"]) * 0.9))
			else
				self.Weapon:SetNextPrimaryFire(curTime + (attacktable["delay"]))
			end
			
			self.Weapon:SetNextSecondaryFire(curTime + (attacktable["delay"]) * 0.1)
			self.isAttacking = true;
			
			self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..owner:EntIndex(), function()
				if IsValid(self) and IsValid(owner) then
					if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
						self.isAttacking = false;
						owner:SetNWBool( "MelAttacking", false )
						
						if owner:IsPlayer() and !owner:IsRagdolled() and owner:Alive() then
							self:Hitscan(); -- For bullet holes.
							owner:LagCompensation(true);
						
							local pos = owner:GetShootPos();
							local aimVector = owner:GetAimVector();
							local meleeArc = (attacktable["meleearc"]) or 25;
							local meleeRange = (attacktable["meleerange"] / 9);
							local hitsAllowed = self.MultiHit or 1;
							local hitEntities = {};
							
							local tr = util.TraceLine({
								start = pos,
								endpos = pos + (aimVector * meleeRange),
								mask = MASK_SOLID,
								filter = owner
							})
							
							if tr.Hit then
								if IsValid(tr.Entity) then
									if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() or Clockwork.entity:IsPlayerRagdoll(tr.Entity) then
										table.insert(hitEntities, tr.Entity);
										
										if tr.Entity:GetNWBool("Parried") then
											self:HandleHit(tr.Entity, tr.HitPos, "parry_swing");
										else
											self:HandleHit(tr.Entity, tr.HitPos, stance);
										end
									end
								end
							end
								
							if IsValid(self) and owner:HasWeapon(self:GetClass()) then
								if !tr.Hit or #hitEntities < hitsAllowed then
									for i = 1, meleeArc - 1 do
										local newAimVector = Vector(aimVector);
									
										if (i % 2 == 0) then
											-- If even go left.
											newAimVector:Rotate(Angle(0, math.Round(i / 2), 0));
										else
											-- If odd go right.
											newAimVector:Rotate(Angle(0, -math.Round(i / 2), 0));
										end
											
										debugoverlay.Line(pos, pos + (newAimVector * meleeRange));

										local tr2 = util.TraceLine({
											start = pos,
											endpos = pos + (newAimVector * meleeRange),
											mask = MASK_SOLID,
											filter = owner
										})
										
										if tr2.Hit then
											if IsValid(tr2.Entity) and !table.HasValue(hitEntities, tr2.Entity) then
												if tr2.Entity:IsPlayer() or tr2.Entity:IsNPC() or tr2.Entity:IsNextBot() or Clockwork.entity:IsPlayerRagdoll(tr2.Entity) then
													table.insert(hitEntities, tr2.Entity);
													
													if tr2.Entity:GetNWBool("Parried") then
														self:HandleHit(tr2.Entity, tr2.HitPos, "parry_swing", #hitEntities);
													else
														self:HandleHit(tr2.Entity, tr2.HitPos, stance, #hitEntities);
													end
												end
											end
										
											if #hitEntities >= hitsAllowed or !IsValid(self) or !owner:HasWeapon(self:GetClass()) then
												break;
											end
										end
									end
								end
							end
							
							owner:LagCompensation(false);
							self.isAttacking = false;
						end
						
						if (owner:KeyDown(IN_ATTACK2)) then
							if (!owner:KeyDown(IN_USE)) then
								local activeWeapon = owner:GetActiveWeapon();

								if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
									if (activeWeapon.IronSights == true) then
										local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
										local curTime = CurTime();
										
										if (loweredParryDebug < curTime) then
											local blockTable = GetTable(activeWeapon.realBlockTable);
											
											if blockTable then
												local guardblockamount = blockTable["guardblockamount"];
												
												if cwMedicalSystem then
													local injuries = {};
													
													if SERVER then
														injuries = cwMedicalSystem:GetInjuries(owner);
													else
														injuries = Clockwork.Client.cwInjuries;
													end
													
													if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
														guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
													end
													
													if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
														guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
													end
												end
												
												--if (owner:GetNWInt("meleeStamina", 100) >= guardblockamount and !owner:GetNWBool("Parried")) then
												if (owner:GetNWInt("Stamina", 100) >= guardblockamount and !owner:GetNWBool("Parried")) then
													owner:SetNWBool("Guardening", true);
													owner.beginBlockTransition = true;
													activeWeapon.Primary.Cone = activeWeapon.IronCone;
													activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
												else
													owner:CancelGuardening()
												end;
											end;
										end;
									else
										owner:CancelGuardening();
									end;
								end;
							end
						end
					end
				end
			end)
		end
		
		owner:SetNWBool("Riposting", true) 
		self:CreateTimer(attacktable["striketime"] + 0.1, "riposteTimer"..owner:EntIndex(), function() 
			if IsValid(self) and owner:IsValid() and owner:Alive() and !owner:IsRagdolled() then
				owner:SetNWBool("Riposting", false)
			end
		end)
			
		self:TriggerAnim(owner, self.Weapon.realCriticalAnim);
		owner:SetNWBool("ParrySucess", false);
		
		owner.blockStaminaRegen = curTime + 5;
		
		return;
	end

	owner.blockStaminaRegen = curTime + 5;

	wep:SetNextPrimaryFire( curTime + (attacktable["delay"]) )
	wep:SetNextSecondaryFire( curTime + (attacktable["delay"]) * 0.1 )
	
	-- GLITCHED
	if self.HandleThrustAttack and owner:GetNWBool("ThrustStance") == true and !owner:GetNWBool("Riposting") then
		self:HandleThrustAttack()
	else
		self:HandlePrimaryAttack()
	end

	local rnda = self.Primary.Recoil * 1
	local rndb = self.Primary.Recoil * math.random(-1, 1)
	
	if SERVER and self:IsValid() and (!owner.IsRagdolled or !owner:IsRagdolled()) and owner:Alive() then 
		owner:SetNWBool( "MelAttacking", true )
		
		self.HolsterDelay = (curTime + attacktable["striketime"])
		self.isAttacking = true;
			
		self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..owner:EntIndex(), function()
			if IsValid(self) and IsValid(owner) then
				if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
					self.isAttacking = false;
					owner:SetNWBool( "MelAttacking", false )
				
					if owner:IsPlayer() and (!owner.IsRagdolled or !owner:IsRagdolled()) and owner:Alive() then
						if self.Category ~= "(Begotten) Javelin" then
							if !owner:GetNWBool("ParrySucess", false) and !owner:GetNWBool("Guardening", false) then
								self:Hitscan(); -- For bullet holes.
								owner:LagCompensation(true);
							
								local pos = owner:GetShootPos();
								local aimVector = owner:GetAimVector();
								local meleeArc = (attacktable["meleearc"]) or 25;
								local meleeRange = (attacktable["meleerange"] / 9);
								local hitsAllowed = self.MultiHit or 1;
								local hitEntities = {};
								
								if stance == "thrust_swing" then
									meleeArc = (attacktable["altmeleearc"]) or 25;
								
									if self.CanSwipeAttack then
										meleeRange = meleeRange * 0.8
									else
										meleeRange = meleeRange * 1.2
									end
								end

								local tr = util.TraceLine({
									start = pos,
									endpos = pos + (aimVector * meleeRange),
									mask = MASK_SOLID,
									filter = owner
								})
								
								if tr.Hit then
									if IsValid(tr.Entity) then
										if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() or Clockwork.entity:IsPlayerRagdoll(tr.Entity) then
											table.insert(hitEntities, tr.Entity);
										else
											hitsAllowed = 0;
										end
											
										self:HandleHit(tr.Entity, tr.HitPos, stance);
									end
								end
									
								if !tr.Hit or #hitEntities < hitsAllowed then
									for i = 1, meleeArc - 1 do
										local newAimVector = Vector(aimVector);
									
										if (i % 2 == 0) then
											-- If even go left.
											newAimVector:Rotate(Angle(0, math.Round(i / 2), 0));
										else
											-- If odd go right.
											newAimVector:Rotate(Angle(0, -math.Round(i / 2), 0));
										end

										local tr2 = util.TraceLine({
											start = pos,
											endpos = pos + (newAimVector * meleeRange),
											mask = MASK_SOLID,
											filter = owner
										})
										
										if tr2.Hit then
											if IsValid(tr2.Entity) and !table.HasValue(hitEntities, tr2.Entity) then
												if tr2.Entity:IsPlayer() or tr2.Entity:IsNPC() or tr2.Entity:IsNextBot() or Clockwork.entity:IsPlayerRagdoll(tr2.Entity) then
													table.insert(hitEntities, tr2.Entity);
													
													self:HandleHit(tr2.Entity, tr2.HitPos, stance, #hitEntities);
												end
											end
										
											if #hitEntities >= hitsAllowed then
												break;
											end
										end
									end
								end
							end
							
							owner:LagCompensation(false);
							
							if (owner:KeyDown(IN_ATTACK2)) then
								if (!owner:KeyDown(IN_USE)) then
									local activeWeapon = owner:GetActiveWeapon();

									if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
										if (activeWeapon.IronSights == true) then
											local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
											local curTime = CurTime();
											
											if (loweredParryDebug < curTime) then
												local blockTable = GetTable(activeWeapon.realBlockTable);
												
												if blockTable then
													local guardblockamount = blockTable["guardblockamount"];
													
													if cwMedicalSystem then
														local injuries = {};
														
														if SERVER then
															injuries = cwMedicalSystem:GetInjuries(owner);
														else
															injuries = Clockwork.Client.cwInjuries;
														end
														
														if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
															guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
														end
														
														if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
															guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
														end
													end
													
													--if (blockTable and owner:GetNWInt("meleeStamina", 100) >= guardblockamount and !owner:GetNWBool("Parried")) then
													if (blockTable and owner:GetNWInt("Stamina", 100) >= guardblockamount and !owner:GetNWBool("Parried")) then
														owner:SetNWBool("Guardening", true);
														owner.beginBlockTransition = true;
														activeWeapon.Primary.Cone = activeWeapon.IronCone;
														activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
													else
														owner:CancelGuardening()
													end;
												end;
											end;
										else
											owner:CancelGuardening();
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
		--local max_poise = owner:GetNetVar("maxMeleeStamina");
		local attackCost = attacktable["takeammo"];
		
		if cwMedicalSystem then
			local injuries = {};
			
			if SERVER then
				injuries = cwMedicalSystem:GetInjuries(owner);
			else
				injuries = Clockwork.Client.cwInjuries;
			end
			
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				attackCost = attackCost + (attacktable["takeammo"] * 2);
			end
			
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				attackCost = attackCost + (attacktable["takeammo"] * 2);
			end
		end
		
		--owner:SetNWInt("meleeStamina", math.Clamp(owner:GetNWInt("meleeStamina", max_poise) - (attackCost), 0, max_poise))
		owner:HandleStamina(-attackCost);
	end;
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
	local owner = self.Owner;

	owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * (attacktable["meleerange"] * 0.1),
		filter = owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * (attacktable["meleerange"] * 0.1),
			filter = owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
		owner:ViewPunch(Angle(-3,1,0))
		owner:EmitSound(attacksoundtable["hitworld"][math.random(1, #attacksoundtable["hitworld"])])
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos )
		end
	end

	owner:LagCompensation( false )
	
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	local ply = self.Owner;
	local wep = self.Weapon

	if ( self.SoundLightning ) then self.SoundLightning:FadeOut(1) self.SoundLightning = nil end
	
	ply:SetNWBool("MelAttacking", false)

	if (!Clockwork.player:GetWeaponRaised(ply)) then
		if (SERVER) then
			local trace = ply:GetEyeTraceNoCursor();

			if (IsValid(trace.Entity) and Clockwork.entity:IsDoor(trace.Entity)) then
				if (ply:GetShootPos():Distance(trace.HitPos) <= 64) then
					if (hook.Run("PlayerCanKnockOnDoor", ply, trace.Entity)) then
						self:PlayKnockSound();
					
						self.Weapon:SetNextPrimaryFire(CurTime() + 0.25);
						self.Weapon:SetNextSecondaryFire(CurTime() + 0.25);
					
						hook.Run("PlayerKnockOnDoor", ply, trace.Entity);
					end;
				end;
			end;
		end;
	else
		local LoweredParryDebug = self:GetNextSecondaryFire()
		local ParryDelay = self:GetNextPrimaryFire()
		local attacktable = GetTable(self.AttackTable);
		local attacksoundtable = GetSoundTable(self.AttackSoundTable)
		local blocktable = GetTable(self.BlockTable);
		local parryWindow = blocktable["parrydifficulty"] or 0.15;
		local curTime = CurTime();

		if ply:KeyDown(IN_ATTACK2) and !ply:KeyDown(IN_RELOAD) and ply:GetNWBool("Guardening") == true then
			-- Deflection
			if blocktable["candeflect"] == true then
				if ply:GetNWBool( "CanDeflect", true ) then
					local deflectionWindow = blocktable["deflectionwindow"] or 0.15;
					
					if ply.HasBelief --[[and ply:HasBelief("deflection")]] then
						ply:SetNWBool( "Deflect", true )
						
						if ply:HasBelief("impossibly_skilled") then
							deflectionWindow = deflectionWindow + 0.1;
						end
					end
					
					ply:SetNWBool( "CanDeflect", false )
					self:CreateTimer(1, "deflectionTimer"..ply:EntIndex(), function()
						if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
							ply:SetNWBool( "CanDeflect", true ) 
						end 
					end);
					
					self:CreateTimer(deflectionWindow, "deflectionOffTimer"..ply:EntIndex(), function()
						if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
							ply:SetNWBool( "Deflect", false ) 
						end 
					end);
				end
			end		
		end

		if ( !self.IronSightsPos ) then return end
		if ( LoweredParryDebug > curTime ) then return end
		if ( self:GetNextPrimaryFire() > curTime * 1.5 ) then return end
		if ( ply:KeyDown(IN_ATTACK2) ) then return end
		if ( !self:CanSecondaryAttack() ) then return end
		if ( ply:GetNWBool( "Guardening") ) == true then return end
		--if ( self.Weapon:GetNWInt("Reloading") > curTime ) then return end
		local parry_cost = blocktable["parrytakestamina"];
		
		if cwMedicalSystem then
			local injuries = {};
			
			if SERVER then
				injuries = cwMedicalSystem:GetInjuries(ply);
			else
				injuries = Clockwork.Client.cwInjuries;
			end
			
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				parry_cost = parry_cost + (blocktable["parrytakestamina"] * 2);
			end
			
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				parry_cost = parry_cost + (blocktable["parrytakestamina"] * 2);
			end
		end
		
		--if ply:GetNWInt("meleeStamina", 100) < parry_cost then return end
		if ply:GetNWInt("Stamina", 100) < parry_cost then return end
			
		self:ParryAnimation()
		ply:EmitSound(attacksoundtable["parryswing"][math.random(1, #attacksoundtable["parryswing"])])

		local wep = self.Weapon
		--local max_poise = ply:GetNetVar("maxMeleeStamina");

		wep:SetNextPrimaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
		wep:SetNextSecondaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
	 
		--Parry anim
		self:TriggerAnim(ply, self.ParryAnim);

		--ply:SetNWInt("meleeStamina", math.Clamp(ply:GetNWInt("meleeStamina") - parry_cost, 0, max_poise));
		ply:HandleStamina(-parry_cost);
			
		--Parry
		ply.blockStaminaRegen = curTime + 5;
		ply:SetNWBool( "Parry", true )
		self.isAttacking = false;
		
		if cwBeliefs and ply.HasBelief and ply:HasBelief("impossibly_skilled") then
			parryWindow = parryWindow + 0.1;
		end
		
		if ply:GetCharmEquipped("holy_sigils") then
			parryWindow = parryWindow + 0.1;
		end
		
		if self:GetClass() == "begotten_fists" and ply:GetCharmEquipped("ring_pugilist") then
			parryWindow = parryWindow + 0.1;
		end
		
		self:CreateTimer(parryWindow, "parryTimer"..ply:EntIndex(), function()
			if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
				ply:SetNWBool( "Parry", false )
				
				if (ply:KeyDown(IN_ATTACK2)) then
					if (!ply:KeyDown(IN_USE)) then
						local activeWeapon = ply:GetActiveWeapon();

						if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
							if (activeWeapon.IronSights == true) then
								local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
								local curTime = CurTime();
								
								if (loweredParryDebug < curTime) then
									local blockTable = GetTable(activeWeapon.BlockTable);
									
									if blockTable then
										local guardblockamount = blockTable["guardblockamount"];
										
										if cwMedicalSystem then
											local injuries = {};
											
											if SERVER then
												injuries = cwMedicalSystem:GetInjuries(ply);
											else
												injuries = Clockwork.Client.cwInjuries;
											end
											
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
											
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
										end
										
										--if (ply:GetNWInt("meleeStamina", 100) >= guardblockamount and !ply:GetNWBool("Parried")) then
										if (ply:GetNWInt("Stamina", 100) >= guardblockamount and !ply:GetNWBool("Parried")) then
											ply:SetNWBool("Guardening", true);
											ply.beginBlockTransition = true;
											activeWeapon.Primary.Cone = activeWeapon.IronCone;
											activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
										else
											ply:CancelGuardening()
										end;
									end;
								end;
							else
								ply:CancelGuardening();
							end;
						end;
					end
				end
			end
		end);
		
		self:CreateTimer(math.max((attacktable["delay"]), 2), "parryBlockTimer"..ply:EntIndex(), function()
			if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
				if (ply:KeyDown(IN_ATTACK2)) then
					if (!ply:KeyDown(IN_USE)) then
						local activeWeapon = ply:GetActiveWeapon();

						if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
							if (activeWeapon.IronSights == true) then
								local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
								local curTime = CurTime();
								
								if (loweredParryDebug < curTime) then
									local blockTable = GetTable(activeWeapon.BlockTable);
									
									if blockTable then
										local guardblockamount = blockTable["guardblockamount"];
										
										if cwMedicalSystem then
											local injuries = {};
											
											if SERVER then
												injuries = cwMedicalSystem:GetInjuries(ply);
											else
												injuries = Clockwork.Client.cwInjuries;
											end
											
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
											
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
										end
													
										--if (ply:GetNWInt("meleeStamina", 100) >= guardblockamount and !ply:GetNWBool("Parried")) then
										if (ply:GetNWInt("meleeStamina", 100) >= guardblockamount and !ply:GetNWBool("Parried")) then
											ply:SetNWBool("Guardening", true);
											ply.beginBlockTransition = true;
											activeWeapon.Primary.Cone = activeWeapon.IronCone;
											activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
										else
											ply:CancelGuardening()
										end;
									end;
								end;
							else
								ply:CancelGuardening();
							end;
						end;
					end
				end
			end
		end);
	end
end

function SWEP:OnDrop()
	self:Remove();
end;

if CLIENT then
	function SWEP:ViewModelDrawn(vm) end
	function SWEP:DrawWorldModel() end
end