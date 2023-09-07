-- to whoever is reading this I put comments starting with "OPTIMIZE NOTE:" around this file that we eventually come back to more indepth and fuck with

SWEP.Base = "weapon_base"

SWEP.AdminSpawnable = false

SWEP.AutoSwitchTo = false
SWEP.Slot = 0
SWEP.PrintName = "base sword"
SWEP.Author = ""
SWEP.Spawnable = false 
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.DrawCrosshair = false

SWEP.MeleeRangeAdditive = 0.1 --Extra time the attack entities exist

SWEP.IsABegottenMelee = true;
SWEP.PartialBulletBlock = false;

SWEP.Secondary.IronFOV = 60

SWEP.IronSights = true
SWEP.ParryType = "parry_swing"
SWEP.ParryAnim = ACT_VM_HITCENTER

function SWEP:AttackAnimination()
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
end

SWEP.IronSightsPos = Vector(-16.08, -4.624, 5.828)
SWEP.IronSightsAng = Vector(0, 0, -70)

SWEP.Category = "Begotten"
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.Instructions = "LMB - Swing | RMB - Guard | R - Parry"
SWEP.Purpose = ""
SWEP.HoldType = "melee2"
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_begotten_melee.mdl"
SWEP.EntAccuracy = 0

SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.IronsightTime = 0.17

SWEP.DisableMuzzle = 1
SWEP.LuaShells = false
SWEP.ShellName = "hg_rifle_shell"

SWEP.DefSwayScale 	= 1.3
SWEP.DefBobScale 	= 1.3
SWEP.MaxDist = 35

--Sounds
SWEP.AttackSoundTable = "DefaultAttackSoundTable"
SWEP.BlockSoundTable = "DefaultBlockSoundTable"
SWEP.SoundMaterial = "Default" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.AttackTable = "DefaultAttackTable"
SWEP.BlockTable = "DefaultBlockTable"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = ""
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Spread = 1
SWEP.Primary.Cone = 1
SWEP.IronCone = 1
SWEP.DefaultCone = 1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1
SWEP.Primary.IronRecoil = 1
SWEP.DefaultRecoil = 1

SWEP.IgniteTime = 5; -- For fire weapons
SWEP.FreezeTime = 5; -- For ice weapons
SWEP.CanSwipeAttack = false;
SWEP.IsBellHammer = false;
 
SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Damage		= 100;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "";

SWEP.Tracer = 6
SWEP.CustomTracerName = "Tracer"

SWEP.RegenDelay = 0.1;

SWEP.Sprint = false

SWEP.SprintMul = 3

SWEP.RunPos = Vector(0,0,0)
SWEP.RunAng = Vector(-9.146, 0, 0)

SWEP.SightBreath = false
SWEP.SightBreathMul = 1

SWEP.InfinityBreathHolding = true
SWEP.BreathHoldingTime = 10

SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(-9.146, 0, 0)

SWEP.Skins = false

SWEP.SkinsFrame = 1

SWEP.SkinsTable = {
}

SWEP.SomeData = {}

SWEP.SomeData.SubMat0 = nil
SWEP.SomeData.SubMat1 = nil
SWEP.SomeData.SubMat2 = nil
SWEP.SomeData.SubMat3 = nil

-- BACKSWORD3 TIMER STUFF

SWEP.Timers = SWEP.Timers or {}

function SWEP:CreateTimer(time, identifier, callback)
	self.Timers[identifier] = {
		start = CurTime(),
		duration = time,
		callback = callback,
	}
end

local rndr = render
local mth = math
local srface = surface
local inpat = input

function SWEP:Deploy()
	if self:GetClass() == "begotten_fists" or (!self.Owner.cwWakingUp and !self.Owner.LoadingText) then
		self:OnDeploy()
	end
	
	self.Owner.gestureweightbegin = 2;
	self.Owner.StaminaRegenDelay = 1
	self.Owner:SetNWBool("CanBlock", true)
	self.Owner:SetNWBool("CanDeflect", true)
	self.Owner:SetNWBool("ThrustStance", false)
	self.Owner:SetNWBool("ParrySucess", false) 
	self.Owner:SetNWBool("Riposting", false)
	self.Owner:SetNWBool( "MelAttacking", false ) -- This should fix the bug where you can't block until attacking.
	self.OwnerOverride = self.Owner;

	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(0)
	self:SetNextSecondaryFire(0)
	self:SetHoldType( self.HoldType )	
	self.Primary.Cone = self.DefaultCone
	--self.Weapon:SetNWInt("Reloading", CurTime() + self:SequenceDuration() )
	self.isAttacking = false;
	
	return true
end

function SWEP:Hitscan()
	local attacktable = GetTable(self.AttackTable);
	local attacksoundtable = GetSoundTable(self.AttackSoundTable);
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (attacktable["meleerange"]) * 0.109),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	
	if ( tr.Hit ) and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then

		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 2
		bullet.Hullsize = 0
		bullet.Distance = (attacktable["meleerange"] * 0.109)
		bullet.Damage = 0;
	
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetDamageType(DMG_CRUSH)
		end
		
		self.Owner:FireBullets(bullet, 2)
		
		if string.find(tr.Entity:GetClass(), "prop_ragdoll") then
			local data = self.Owner:GetEyeTrace();
			local effect = EffectData();
				effect:SetOrigin(data.HitPos);
				effect:SetScale(16);
			util.Effect("BloodImpact", effect);
			
			--if not Clockwork.entity:GetPlayer(tr.Entity) or not Clockwork.entity:GetPlayer(tr.Entity):Alive() then
				if self.Owner:GetNWBool("ThrustStance") != true then
					tr.Entity:EmitSound(attacksoundtable["hitbody"][math.random(1, #attacksoundtable["hitbody"])])
				else
					tr.Entity:EmitSound(attacksoundtable["althitbody"][math.random(1, #attacksoundtable["althitbody"])])
				end
			--end
			
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
	end
end

function SWEP:Think()
	local player = self.Owner;
	
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

function SWEP:AdjustMouseSensitivity()
	if self.Owner:GetNWBool( "Guardening" ) == true then
		return 0.5
	end
end

function SWEP:CanPrimaryAttack()
	local attacktable = GetTable(self.AttackTable);
	
	if Schema and (Schema.towerSafeZoneEnabled) then
		if self.Owner.GetFaction and self.Owner.InTower and self.Owner:InTower() and not self.Owner:IsAdmin() and not self.Owner.possessor then
			local faction = self.Owner:GetFaction();
		
			if faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy" and faction ~= "Pope Adyssa's Gatekeepers" then
				if SERVER then
					Clockwork.player:Notify(self.Owner, "You cannot attack in this holy place!");
				end
				
				local curTime = CurTime();
				
				self.Weapon:SetNextPrimaryFire(curTime + 2);
				self.Weapon:SetNextSecondaryFire(curTime + 2);
				
				return false;
			end
		end

		if self.Owner:GetNWBool("Cloaked", false) == true then
			return false;
		end
	end
	
	return self.Owner:GetNWInt("meleeStamina") >= (attacktable["takeammo"])
end

function SWEP:PrimaryAttack()
	local wep = self.Weapon
	local ply = self.Owner
	local attacktable = GetTable(self.AttackTable);
	local curTime = CurTime();
	
	if (IsValid(self.SwingEntity)) then
		self.SwingEntity:Remove()
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
			
			self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..self.Owner:EntIndex(), function()
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
			end)
		end
		
		self.Owner:SetNWBool("Riposting", true) 
		self:CreateTimer(attacktable["striketime"] + 0.1, "riposteTimer"..self.Owner:EntIndex(), function() 
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
		
		self.HolsterDelay = (curTime + attacktable["striketime"])
		self.isAttacking = true;
			
		self:CreateTimer(attacktable["striketime"] + 0.1, "strikeTimer"..self.Owner:EntIndex(), function()
			if IsValid(self) and IsValid(self.Owner) then
				if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
					if self.Owner:IsPlayer() and (!self.Owner.IsRagdolled or !self.Owner:IsRagdolled()) and self.Owner:Alive() then
						if self.Category == "(Begotten) Javelin" then
							ply:SetNWBool( "MelAttacking", false )
							self.isAttacking = false;
						else
							if !self.Owner:GetNWBool("ParrySucess", false) and !self.Owner:GetNWBool("Guardening", false) then
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

local nxt = 0
local ftmul = 0
local fmul
local nxtsken = 0

SWEP.AngFrames = {
["FOV"] = 0,
["PosAdd"] = Vector(0, 0, 0),
[0] = Angle(0,0,0),
[1] = Angle(5,5,5),
[2] = Angle(0,-15,-5),
[3] = Angle(0,15,-25)
}

SWEP.IdkTestView = false

local ViewMul1 = 0
local nxtfraem = 0
local maxframe = 3
local tstang = Angle(0,0,0)
local lerpfov = 0
local ironfov = 0
local lerpsprint = Angle(0,0,0)
local posadd = Vector(0, 0, 0)
local skensangle = Angle(0, 0, 0)

local lerpshitmudafaka = Angle(0,0,0)

function SWEP:ViewCalc()
end

function SWEP:CalcView( ply, origin, angles, fov )
	if !IsFirstTimePredicted() then
		local FT = FrameTime()
		-- OPTIMIZE NOTE: most likely some shit in here can be messed around with
		local ply = self.Owner
		local wep = self.Weapon
		local angtime = wep:GetNWInt( "AngFrame" )

		local sprintshit = Angle(0, 0, mth.sin(CurTime()/0.1) * self.SprintMul)

		self:ViewCalc()
			
			tstang = LerpAngle( FT*2, tstang, self.AngFrames[angtime])
			lerpfov = Lerp( FT*2, lerpfov, self.AngFrames["FOV"])

			posadd = LerpVector( FT*2, posadd, self.AngFrames["PosAdd"])
				
			if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 350 and ply:WaterLevel() != 3 and ( ConVarExists( "hg_viewbob" ) and GetConVarNumber( "hg_viewbob" ) == 1 ) then
				lerpsprint = Lerp( FT*2, lerpsprint, sprintshit)
			else
				lerpsprint = Lerp( FT*2, lerpsprint, Angle(0,0,0))
			end
			
			if wep:GetNWBool("AnimExpect") == true then
				skensangle = LerpAngle( FT*2, skensangle, Angle(mth.sin(CurTime()/2) * 2, mth.sin(CurTime()/2) * 5, mth.sin(CurTime()/2) * 5) )
			else
				skensangle = LerpAngle( FT*2, skensangle, Angle(0, 0, 0) )
			end
			
			lerpshitmudafaka = LerpAngle( FT*7, lerpshitmudafaka, ply:EyeAngles())
			
			origin = origin + posadd
			
			if self.IdkTestView == false then
				angles = angles + tstang + lerpsprint + skensangle //angles + self.AngFrames[angtime]//LerpAngle( FT*2, angles, angles + self.AngFrames[angtime])
			else
				angles = lerpshitmudafaka + lerpsprint
			end
			
			fov = fov + lerpfov - ironfov
			
			return origin, angles, fov
	end
end

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
	local Mul = 0
	local MulB = 0
	local MulI = 0
	local MulBI = 0
	local breath = 0
	
	local ModX = 0
	local ModY = 0
	local ModZ = 0
	
	local ModAngX = 0
	local ModAngY = 0
	local ModAngZ = 0
	
	local SprintMul = 0
	
	local nearwallang = 0
	
	local veloshit = 0

function SWEP:GetViewModelPosition( pos, ang )
local ply = self.Owner
local wep = self.Weapon
	if !ply:IsValid() then return end

	local bIron = ply:GetNWBool( "Guardening" )
	--local sprintshit = wep:GetNWBool( "SprintShit" )
	
		if ( bIron ) then 
			self.SwayScale 	= 1
			self.BobScale 	= 1
		else 
			self.SwayScale 	= self.DefSwayScale
			self.BobScale 	= self.DefBobScale
		end

	local FT = 0
	if game.SinglePlayer() then
		FT = FrameTime()
	else
		FT = FrameTime()/2
	end
	local FT2 = FT / 25
	
	local Offset	= self.IronSightsPos

		
	if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 350 and ply:WaterLevel() < 1 and self.Sprint == true --[[and wep:GetNWInt("Reloading") < CurTime()]] then
		SprintMul = Lerp(FT*4, SprintMul, 1)	
		--wep:SetNWBool( "SprintShit", true )			
	else
		SprintMul = Lerp(FT*4, SprintMul, 0)
		--wep:SetNWBool( "SprintShit", false )				
	end
	
	if ( self.IronSightsAng ) then	
		ModAngX = self.IronSightsAng.x
		ModAngY = self.IronSightsAng.y 
		ModAngZ = self.IronSightsAng.z
	end
	

	
	wep:SetNWInt("NearWallMul", nearwallang)
	if ply:KeyDown(IN_MOVERIGHT) then
		veloshit = Lerp(FT*6, veloshit, -ply:GetVelocity():Length()/100 )//-5 )	
	elseif ply:KeyDown(IN_MOVELEFT) then
		veloshit = Lerp(FT*6, veloshit, ply:GetVelocity():Length()/100 )//5 )
	else
		veloshit = Lerp(FT*6, veloshit, 0 )
	end
	
		ang = ang * 1

		ang:RotateAroundAxis( ang:Right(), 		( ModAngX * Mul ) + (self.RunAng.x * SprintMul) + (self.WallAng.x * nearwallang) )
		ang:RotateAroundAxis( ang:Up(), 		( ModAngY * Mul ) + (self.RunAng.y * SprintMul) + (self.WallAng.y * nearwallang) )
		ang:RotateAroundAxis( ang:Forward(), 	( ModAngZ * Mul ) + (veloshit) + (self.RunAng.z * SprintMul) + (self.WallAng.z * nearwallang)  )
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

			ModX = Offset.x * Right * Mul + ( ang:Right() * (self.RunPos.x * SprintMul) ) + ( ang:Right() * (self.WallPos.x * nearwallang) ) 
			ModY = Offset.y * Forward * Mul + ( ang:Forward() * (self.RunPos.y * SprintMul) )  + ( ang:Forward()  * (self.WallPos.y * nearwallang) )
			ModZ = Offset.z * Up * Mul + ( ang:Up() * (self.RunPos.z * SprintMul) )  + ( ang:Up()  * (self.WallPos.z * nearwallang))
		/*	ModX = Offset.x * Right 
			ModY = Offset.y * Forward + ( ang:Forward() * -5) 
			ModZ = Offset.z * Up + ( ang:Up() * -3)*/
		
	if bIron then
		Mul = Lerp(FT*15, Mul, 1)
		MulB = Lerp(FT*15, MulB, 0)	
	else
		Mul = Lerp(FT*7, Mul, 0)
		MulB = Lerp(FT*15, MulB, 1)
	end
	
	if ply:KeyDown(IN_DUCK) then 
		MulI = Lerp(FT*2, MulI, 0)
	elseif bIron then
		MulI = Lerp(FT*15, MulI, 0)
	else
		MulI = Lerp(FT*15, MulI, 1)
	end
	
	breath = (mth.sin(CurTime())/(2)) * MulB 

			pos = pos + ModX
			pos = pos + ModY + (EyeAngles():Up() * (breath) )
			pos = pos + ModZ
			
			ang = ang 
			
		ang:RotateAroundAxis( ang:Right(), (mth.sin(CurTime()/2)) * MulI )
		ang:RotateAroundAxis( ang:Up(), (mth.sin(CurTime()/2)) * MulI )
		ang:RotateAroundAxis( ang:Forward(), (mth.sin(CurTime()/2)) * MulI )

	if self.SightBreath == true then
		if bIron and (!ply:KeyDown(IN_SPEED) or wep:GetNWBool("over_breathhold") == true ) then 
				
			if ply:KeyDown(IN_DUCK) then
				MulBI = Lerp(FT*6, MulBI, 0.1)
			elseif ply:GetVelocity():Length() > 50 then
				MulBI = Lerp(FT*6, MulBI, 2)		
			else
				MulBI = Lerp(FT*6, MulBI, 0.3)
			end
		elseif bIron and ply:KeyDown(IN_SPEED) and wep:GetNWBool("over_breathhold") == false then
			MulBI = Lerp(FT*6, MulBI, 0.01)
		else	
			MulBI = Lerp(FT*6, MulBI, 0)	
		end			
		
		if !game.SinglePlayer() then
			MulBI = MulBI*0.6
		end
			
		local angles = Angle(0,0,0)
		
		angles:RotateAroundAxis( angles:Right(), (mth.sin(CurTime()*2)/19) * (MulBI) )
		angles:RotateAroundAxis( angles:Up(), (mth.sin(CurTime()/2)/19) * (MulBI) )
		
		ply:SetEyeAngles( ply:EyeAngles()+( (angles*Mul) * self.SightBreathMul ) )	
	end
			
return pos, ang

--end

end

SWEP.NextSecondaryAttack = 0

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:SecondaryAttack()
	local LoweredParryDebug = self:GetNextSecondaryFire()
	local ParryDelay = self:GetNextPrimaryFire()
	local attacktable = GetTable(self.AttackTable);
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local blocktable = GetTable(self.BlockTable);
	local parryWindow = blocktable["parrydifficulty"] or 0.15;
	local curTime = CurTime();

	if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_RELOAD) and self.Owner:GetNWBool("Guardening") == true then
		-- Deflection
		if blocktable["candeflect"] == true then
			if self.Owner:GetNWBool( "CanDeflect", true ) then
				local deflectionWindow = 0.15;
				
				-- Increased deflection window for bucklers.
				if string.find(self:GetClass(), "_shield4") then
					deflectionWindow = 0.25;
				end
				
				if self.Owner.HasBelief --[[and self.Owner:HasBelief("deflection")]] then
					self.Owner:SetNWBool( "Deflect", true )
					
					if self.Owner:HasBelief("impossibly_skilled") then
						deflectionWindow = deflectionWindow + 0.1;
					end
				end
				
				self.Owner:SetNWBool( "CanDeflect", false )
				self:CreateTimer(1, "deflectionTimer"..self.Owner:EntIndex(), function()
					if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
						self.Owner:SetNWBool( "CanDeflect", true ) 
					end 
				end);
				
				self:CreateTimer(deflectionWindow, "deflectionOffTimer"..self.Owner:EntIndex(), function()
					if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
						self.Owner:SetNWBool( "Deflect", false ) 
					end 
				end);
			end
		end		
	end

	if ( !self.IronSightsPos ) then return end
	if ( LoweredParryDebug > curTime ) then return end
	if ( self:GetNextPrimaryFire() > curTime * 1.5 ) then return end
	if ( self.Owner:KeyDown(IN_ATTACK2) ) then return end
	if ( !self:CanSecondaryAttack() ) then return end
	if ( self.Owner:GetNWBool( "Guardening") ) == true then return end
	--if ( self.Weapon:GetNWInt("Reloading") > curTime ) then return end
	if self.Owner:GetNWInt("meleeStamina", 100) < blocktable["parrytakestamina"] then return end
		
	self:ParryAnimation()
	self.Owner:EmitSound(attacksoundtable["parryswing"][math.random(1, #attacksoundtable["parryswing"])])

	local wep = self.Weapon
	local ply = self.Owner
	local max_poise = ply:GetNetVar("maxMeleeStamina");

	wep:SetNextPrimaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
	wep:SetNextSecondaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
 
	--Parry anim
	self:TriggerAnim(self.Owner, self.ParryAnim);

	self.Owner:SetNWInt("meleeStamina", math.Clamp(self.Owner:GetNWInt("meleeStamina") - blocktable["parrytakestamina"], 0, max_poise));
		
	--Parry
	--self.Owner.StaminaRegenDelay = 0
	self.Owner.nextStas = curTime + 5;
	self.Owner:SetNWBool( "Parry", true )
	self.isAttacking = false;
	
	if cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("impossibly_skilled") then
		parryWindow = parryWindow + 0.1;
	end
	
	self:CreateTimer(parryWindow, "parryTimer"..self.Owner:EntIndex(), function()
		if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
			self.Owner:SetNWBool( "Parry", false )
			
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
	end);
	
	self:CreateTimer(0.5, "parryBlockTimer"..self.Owner:EntIndex(), function()
		if self:IsValid() and !self.Owner:IsRagdolled() and self.Owner:Alive() then
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
	end);
end
	
function SWEP:Equip()
	self:SetHoldType(self.HoldType)
end	
	
function SWEP:OnRestore()
	self.NextSecondaryAttack = 0
end

-- For Mr. Electric's lightning attack, we can use it for other shit too.
function SWEP:SelectTargets( num )
	local t = {}
	local dist = 666

	--[[local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * dist,
		filter = self.Owner
	} )]]

	local p = {}
	for id, ply in pairs( ents.GetAll() ) do
		if ply:IsPlayer() or ply:IsNPC() or Clockwork.entity:IsPlayerRagdoll(ply) then
			if ply == self.Owner or ply.cwObserverMode then
				continue;
			end
		
			local tr = util.TraceLine( {
				start = self.Owner:GetShootPos(),
				endpos = ply.GetShootPos && ply:GetShootPos() or ply:GetPos(),
				filter = self.Owner,
			} )

			if ( tr.Entity != ply && IsValid( tr.Entity ) or tr.Entity == game.GetWorld() ) then continue end

			local pos1 = self.Owner:GetPos() + self.Owner:GetAimVector() * dist
			local pos2 = ply:GetPos()
			local dot = self.Owner:GetAimVector():Dot( ( self.Owner:GetPos() - pos2 ):GetNormalized() )

			if ( pos1:Distance( pos2 ) <= dist && ply:EntIndex() > 0 && ply:GetModel() && ply:GetModel() != "" ) then
				table.insert( p, { ply = ply, dist = tr.HitPos:Distance( pos2 ), dot = dot, score = -dot + ( ( dist - pos1:Distance( pos2 ) ) / dist ) * 50 } )
			end
		end
	end

	for id, ply in SortedPairsByMemberValue( p, "dist" ) do
		table.insert( t, ply.ply )
		if ( #t >= num ) then return t end
	end

	return t
end

--[[---------------------------------------------------------

-----------------------------------------------------------]]
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	-- Set us up the texture
	srface.SetDrawColor( 255, 255, 255, alpha )
	srface.SetTexture( self.WepSelectIcon )
	
	-- Lets get a sin wave to make it bounce
	local fsin = 0
	-- And fucking rotation
	local rsin = 0
	
	if ( self.BounceWeaponIcon == true ) then
		fsin = mth.sin( CurTime() * 10 ) * 5
		rsin = mth.sin( CurTime() * 5 ) * 10
	end
	
	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20
	
	-- Draw that mother
	srface.DrawTexturedRectRotated( x + 80 + (fsin), y + 50 - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin), rsin )
	
	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	
end

function SWEP:NearWall()
if self.Owner:IsNPC() or !self.Owner:IsValid() then return end
	return self.Owner:GetShootPos():Distance(self.Owner:GetEyeTrace().HitPos) <= self.MaxDist and !self.Owner:GetEyeTrace().Entity:IsPlayer() and !self.Owner:GetEyeTrace().Entity:IsNPC()
end

function SWEP:TraceCollider(addforward, addright, addup)
	local angles = self.Owner:EyeAngles()
	local collider = {}
	
	collider.start = self.Owner:EyePos()
	collider.endpos = collider.start + angles:Forward() * addforward
	collider.endpos = collider.endpos + angles:Right() * addright
	collider.endpos = collider.endpos + angles:Up() * addup
	collider.filter = self.Owner	
	
	local trace = util.TraceLine(collider)	
	
	return self.Owner:GetShootPos():Distance(trace.HitPos)
end

/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378
	   
	DESCRIPTION:
		This script is meant for experienced scripters 
		that KNOW WHAT THEY ARE DOING. Don't come to me 
		with basic Lua questions.
		
		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.
		
		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/

if CLIENT then
surface.CreateFont( "QuadFont", {
	font = "Arial",
	size = 25,
	weight = 5,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false, 
} )

surface.CreateFont( "QuadFontSmall", {
	font = "Arial",
	size = 15,
	weight = 5,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false, 
} )

end

function SWEP:ResetGestures(player)
	if self.IronSights then
		self:TriggerAnim2(player, self.BlockAnim, 1);
	end
end

function SWEP:InitFunc()
end

function SWEP:QuadsHere()
end

function SWEP:GetSCKshitPos(vm)
	//local vm = self.VElements[vm].modelEnt
	local pos, ang
	pos = self.VElements[vm].modelEnt:GetPos()
	ang = self.VElements[vm].modelEnt:GetAngles()
	
	return pos, ang
end

function SWEP:GetCapabilities()
	return bit.bor( CAP_WEAPON_RANGE_ATTACK1, CAP_INNATE_RANGE_ATTACK1 )
end

function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:Initialize()
	self:InitFunc();
	
	local blocktable = GetTable(self.BlockTable);
	self.RaiseSpeed = blocktable["raisespeed"]
	self.LowerSpeed = blocktable["raisespeed"]
	self.InstantRaise = blocktable["instantraise"]
	self.RaiseSound = "cloth.wav"; 

	if CLIENT then
		self:SetHoldType( self.HoldType );
		
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		if LocalPlayer() == self.Owner then
			self:CreateModels(self.VElements) // create viewmodels
		end
		
		self:CreateModels(self.WElements) // create worldmodels

		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			local vm = self.Owner:GetViewModel()
			
			if IsValid(vm) then
				self:ResetBonePositions(vm);
			end
		end
	end
end

function SWEP:OnDrop()
	self:OnRemove();
end

function SWEP:Holster()
	local player = self.OwnerOverride or self.Owner;
	
	timer.Remove(player:EntIndex().."IdleAnimation");

	self:StopAllAnims(player);
	
	player:SetNWBool("ThrustStance", false);
	player:SetNWBool("Parry", false);
	player:SetNWBool("ParrySucess", false);
	player:SetNWBool("Riposting", false);

	if CLIENT and IsValid(player) and player:IsPlayer() then
		local vm = player:GetViewModel()
		
		if IsValid(vm) then
			self:ResetBonePositions(vm)
			vm:SetSubMaterial( 0, "" )
			vm:SetSubMaterial( 1, "" )
			vm:SetSubMaterial( 2, "" )
		end
	end
	
	return true;
end

function SWEP:OnRemove()
	self:Holster();
	
	if CLIENT then
		self:RemoveModels();
	end
end

function SWEP:RemoveModels()
	if self.vRenderOrder then
		for k, name in ipairs( self.vRenderOrder ) do
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			
			local model = v.modelEnt;
			
			if (v.type == "Model" and IsValid(model)) then
				model:Remove();
			end
		end
	end
	
	if self.wRenderOrder then
		for k, name in pairs( self.wRenderOrder ) do
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local model = v.modelEnt;

			if (v.type == "Model" and IsValid(model)) then
				model:Remove();
			end
		end
	end
end

function SWEP:SubMatFunc()
	local vm = self.Owner:GetViewModel()--Get view model
	local wep = self.Weapon
	
	if vm:IsValid() then
		if self.SomeData.SubMat0 != nil and self.Skins == false then
			vm:SetSubMaterial( 0, self.SomeData.SubMat0 )--Change its material
		else
			vm:SetSubMaterial( 0, "" )
		end
		
		if self.Skins == true then 
			vm:SetSubMaterial( 0, self.SkinsTable[self.Weapon:GetNWInt( "hgskin" )].path )
		end

		if self.SomeData.SubMat1 != nil and self.Skins == false then
			vm:SetSubMaterial( 1, self.SomeData.SubMat1 )--Change its material
		else
			vm:SetSubMaterial( 1, "" )
		end
	
	end
end

if CLIENT then
	local redflare = Material( "effects/redflare" ) 

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn(vm)
		self:CustomDrawn(vm)
		
		self:SubMatFunc()
		
		local vm = self.Owner:GetViewModel()
		self:UpdateBonePositions(vm)
		
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then

			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model") then
				if !IsValid(model) then
					self:CreateModels(self.VElements);
					
					return;
				end

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(true)
				end
				
				rndr.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				rndr.SetBlend(v.color.a/255)
				model:DrawModel()
				rndr.SetBlend(1)
				rndr.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(false)
				end
				
					if name == "Laser" then
							local pos = model:GetPos()
							local ang = model:GetAngles()
							local lsize = mth.random(3,5)
							local endpos, startpos			// = pos + ang:Up() * 10000
							
							if name == "Laser" then
								endpos = pos + ang:Right() * -1 + ang:Forward() * 10000 + ang:Up() * 1.2// + ang:Up() * 10
								startpos = pos + ang:Right() * -1 + ang:Forward() * 5 + ang:Up() * 1.2// + ang:Up() * 10
							end
							
							local trc = util.TraceLine({
								start = startpos,
								endpos = endpos
							})
					
							rndr.SetMaterial( redflare )
							rndr.DrawBeam(startpos, trc.HitPos, 0.2, 0, 0.99, Color(255,255,255, 100))
							rndr.DrawSprite( trc.HitPos,lsize,lsize,Color( 255,255,255 ) )
					
					end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				rndr.SetMaterial(sprite)
				rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end
	
	function SWEP:CustomWorldDrawn()
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		self:CustomWorldDrawn()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model") then
				if !IsValid(model) then
					self:CreateModels(self.WElements);
					
					return;
				end
			
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(true)
				end
				
				rndr.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				rndr.SetBlend(v.color.a/255)
				model:DrawModel()
				rndr.SetBlend(1)
				rndr.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				rndr.SetMaterial(sprite)
				rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r 
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )
		if (!tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
				string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				if IsValid(v.modelEnt) then
					v.modelEnt:Remove();
				end
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)	
		if !vm then return end;
		if (!vm:GetBoneCount()) then return end
		
		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
	end
	
	function SWEP:CustomDrawn()

	end

	/**************************
		Global utility code
	**************************/
	
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

-- ALY'S CHANGES, COPY THIS PART INTO NEW ITEMS --
-- OPTIMIZE NOTE: we can try changing this shit over to netstream instead of the net library, I honestly don't know if that'd be better or worse for performance especially since netstream uses net internally but maybe worth a shot??

if SERVER then
	util.AddNetworkString( "BegottenAnim" )
end;

if CLIENT then
	net.Receive( "BegottenAnim", function()
		 local target = net.ReadEntity()
		 if target:IsValid() and target:Alive() then
		 local anim = net.ReadString()
		 local lookup = target:LookupSequence(anim)
		 target:AddVCDSequenceToGestureSlot( GESTURE_SLOT_CUSTOM, lookup, 0, 1 );
		 end
	end )
end;

function SWEP:TriggerAnim(target, anim)
	if SERVER then
		net.Start( "BegottenAnim", true )
		net.WriteEntity( self.Owner );
		net.WriteString( anim );
		net.Broadcast();
	end;
end;

-- For blocking

if SERVER then
	util.AddNetworkString("BegottenAnim2")
end;

if (CLIENT) then
	net.Receive( "BegottenAnim2", function()
		local target = net.ReadEntity();
		
		if target:IsValid() then
			local anim = net.ReadString();
			local beginorend = net.ReadFloat();
			local lookup = target:LookupSequence(anim);
			
			target.gestureweightlookup = lookup;
			
			if (beginorend == 0) then
				target.gestureweightbegin = 1;
			elseif (beginorend == 1) then
				target.gestureweightbegin = 2;
			end;
		end;
	end);
end;

function SWEP:TriggerAnim2(target, anim, beginorend)
	if SERVER then
		if not self.Owner.gestureweightbegin then
			self.Owner.gestureweightbegin = 1;
		end
	
		if self.Owner.gestureweightbegin and beginorend ~= self.Owner.gestureweightbegin - 1 then
			net.Start("BegottenAnim2", true)
			net.WriteEntity(target);
			net.WriteString(anim);
			net.WriteFloat(beginorend);
			net.Broadcast();
			
			if self.Owner:IsValid() then
				local lookup = self.Owner:LookupSequence(anim)
				
				if beginorend == 0 then
					self.Owner.gestureweightbegin = 1;
				elseif beginorend == 1 then
					self.Owner.gestureweightbegin = 2;
				end
			end
			
			self.Owner.gestureweightlookup = lookup;
		end
	end;
end

if CLIENT then
	hook.Add("Think", "Blockthink", function()
		local plys = player.GetAll();
		
		for i = 1, _player.GetCount() do
			local player = plys[i];
			
			if player:IsValid() and player:Alive() then
				local setWeight = false;
			
				if !player.gestureweightbegin then
					player.gestureweightbegin = 0;
				end
				
				if !player.gestureweightblock then
					player.gestureweightblock = 0;
				end
			
				if player.gestureweightbegin == 1 then
					player.gestureweightbegin = 0;
					player.gestureweightprogress = 1;
					
					setWeight = true;
				elseif player.gestureweightbegin == 2 then
					player.gestureweightbegin = 0;
					player.gestureweightprogress = 2;
					
					setWeight = true;
				end
				
				if player.gestureweightprogress == 1 then
					player.gestureweightblock = math.Clamp(player.gestureweightblock + (FrameTime() * 10), 0, 1);
					
					setWeight = true;
				elseif player.gestureweightprogress == 2 then
					player.gestureweightblock = math.Clamp(player.gestureweightblock + ((FrameTime() * 10) * -1), 0, 1);

					setWeight = true;
				end
					
				if player.gestureweightblock == 0 or player.gestureweightblock == 1 then
					player.gestureweightprogress = 0;
				end;

				if player.gestureweightlookup and player.gestureweightblock > 0 then
					player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, player.gestureweightlookup, 0, 1);
				end
					
				--print("gestureweightbegin: "..player.gestureweightbegin.." gestureweightprogress: "..player.gestureweightprogress.." gestureweightblock: "..player.gestureweightblock);
				
				if setWeight then
					player:AnimSetGestureWeight(GESTURE_SLOT_VCD, player.gestureweightblock);
				end
				-- OPTIMIZE NOTE: there has to be a better way to do this...maybe not.
			end
		end
	end);
end

--For specials attacks & extras

if SERVER then
	util.AddNetworkString( "BegottenAnim3" )
end;

if CLIENT then
	net.Receive( "BegottenAnim3", function()
		 local target = net.ReadEntity()
		 if target:IsValid() and target:Alive() then
		 local anim = net.ReadString()
		 local lookup = target:LookupSequence(anim)
		 target:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, lookup, 0, 1 );
	end end )
end;

function SWEP:TriggerAnim3(target, anim)
	if SERVER then
		net.Start( "BegottenAnim3", true )
		net.WriteEntity( self.Owner );
		net.WriteString( anim );
		net.Broadcast();
	end;
end;

-- To stop anims

if SERVER then
	util.AddNetworkString( "BegottenAnimStop" )
end;

if CLIENT then
	net.Receive( "BegottenAnimStop", function()
		local target = net.ReadEntity()
		
		if target:IsValid() and target:Alive() then
			target.gestureweightbegin = 0;
			target.gestureweightblock = 0;
			target.gestureweightprogress = 0;

			target:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD);
			target:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM);
			target:AnimResetGestureSlot(GESTURE_SLOT_VCD);
		end 
	end);
end;

function SWEP:StopAllAnims(target)
	if SERVER then
		net.Start( "BegottenAnimStop", true )
		net.WriteEntity(target);
		net.Broadcast();
	end;
end;

-- ENDS --

print ('The Undergod is watching.') 