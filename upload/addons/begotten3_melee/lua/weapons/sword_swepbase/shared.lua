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
SWEP.BluntAltAttack = false;
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

function SWEP:Hitscan()
	local attacktable = GetTable(self.AttackTable);
	local attacksoundtable = GetSoundTable(self.AttackSoundTable);
	local isThrusting = self.Owner:GetNetVar("ThrustStance");
	local meleerange;
	
	if !isThrusting and self.isJavelin then return false end;
	
	if isThrusting and attacktable["altmeleerange"] then
		meleerange = attacktable["altmeleerange"];
	else
		meleerange = attacktable["meleerange"] or 1;
	end
	
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (meleerange) / 9),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )
	
	if ( tr.Hit ) and !tr.Entity:IsPlayer() and !tr.Entity:IsNPC() then
		local bullet = {};
		
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 2
		bullet.Hullsize = 0
		bullet.Distance = (meleerange / 9)
		bullet.Damage = 0;
	
		bullet.Callback = function(attacker, tr, dmginfo)
			dmginfo:SetDamageType(DMG_CRUSH)
		end
		
		self.Owner:FireBullets(bullet, 2);
		
		if string.find(tr.Entity:GetClass(), "prop_ragdoll") then
			local data = self.Owner:GetEyeTrace();
			local effect = EffectData();
				effect:SetOrigin(data.HitPos);
				effect:SetScale(16);
			util.Effect("BloodImpact", effect, true, true);
			
			--if not Clockwork.entity:GetPlayer(tr.Entity) or not Clockwork.entity:GetPlayer(tr.Entity):Alive() then
				if self.Owner:GetNetVar("ThrustStance") != true then
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
	local plyTab = player:GetTable();
	
	if (plyTab.beginBlockTransition) then
		if (player:GetNetVar("Guardening") == true) then
			self:TriggerAnim2(player, self.realBlockAnim, 0);
			
			if ((SERVER) and player:GetNetVar("CanBlock", true)) then
				if (self.realBlockSoundTable) then
					local blockSoundTable = GetSoundTable(self.realBlockSoundTable)
					
					player:EmitSound(blockSoundTable["guardsound"][math.random(1, #blockSoundTable["guardsound"])], 65, math.random(100, 90))
				end;

				player:SetLocalVar("CanBlock", false);
			end;
		elseif !player:GetNetVar("Guardening") then
			self:TriggerAnim2(player, self.realBlockAnim, 1);
			player:SetLocalVar("CanBlock", true)
			
			local velocity = player:GetVelocity();
			local length = velocity:Length();
			local running = player:KeyDown(IN_SPEED);

			if (running and length > 350 and (self.Sprint == true)) then
				local weapon = self.Weapon
				local curTime = CurTime();
				
				weapon:SetNextPrimaryFire(curTime + 0.3);
				weapon:SetNextSecondaryFire(curTime + 0.3);
			end
		end;
		
		plyTab.beginBlockTransition = false;
	end;
	
	if SERVER then
		local curTime = CurTime();
		
		-- Last ditch effort to fix the clientside itemtable desync.
		if !self.nextItemSend or self.nextItemSend <= curTime then
			if IsValid(player) and player:IsPlayer() then
				local itemTable = item.GetByWeapon(self);
					
				if itemTable then
					netstream.Start(player, "WeaponItemData", {
						definition = item.GetDefinition(itemTable, true),
						weapon = self:EntIndex()
					})

					if self:GetNWInt("ItemID") ~= itemTable.itemID then
						self:SetNWInt("ItemID", itemTable.itemID)
					end
					
					self.cwItemTable = itemTable
				end
			end
			
			self.nextItemSend = curTime + math.random(1, 5);
		end
	end
	
	if self.PostThink then
		self:PostThink();
	end
	
	for k, v in next, self.Timers do
		if v.start + v.duration <= CurTime() then
			v.callback()
			self.Timers[k] = nil
		end
	end
end

function SWEP:AdjustMouseSensitivity()
	if self:GetNW2String("activeShield"):len() > 0 then
		local blockTable = GetTable(self:GetNW2String("activeShield"));
		
		if blockTable then
			if blockTable.sensitivityoverride then
				if self.Owner:GetNetVar("Guardening") == true then
					return blockTable.sensitivityoverride.guarded;
				else
					return blockTable.sensitivityoverride.unguarded;
				end
			end
		end
	end
	
	if self.Owner:GetNetVar("Guardening") == true then
		return 0.5
	end
end

function SWEP:CanPrimaryAttack()
	local attacktable = GetTable(self.AttackTable);
	
	if Schema and (Schema.towerSafeZoneEnabled) then
		if self.Owner.GetFaction and self.Owner.InTower and self.Owner:InTower() and not self.Owner:IsAdmin() and not self.Owner.possessor then
			local faction = self.Owner:GetFaction();
		
			if faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy" and faction ~= "Pope Adyssa's Gatekeepers" and faction ~= "Hillkeeper" then
				if SERVER then
					Clockwork.player:Notify(self.Owner, "You cannot attack in this holy place!");
				end
				
				local curTime = CurTime();
				
				self.Weapon:SetNextPrimaryFire(curTime + 2);
				self.Weapon:SetNextSecondaryFire(curTime + 2);
				
				return false;
			end
		end

		if self.Owner:GetNW2Bool("Cloaked", false) == true then
			return false;
		end
	end
	
	if Clockwork and Clockwork.player:GetAction(self.Owner) == "raise" then
		return false;
	end
	
	if self.Owner:IsRunning() and !self.Owner:HasBelief("manifesto") then
		local weaponItemTable = item.GetByWeapon(self);
		
		if weaponItemTable and weaponItemTable.attributes and table.HasValue(weaponItemTable.attributes, "grounded") then
			return false;
		end
	end
	
	local attackCost = 1;
	
	if self.Owner:GetNetVar("ThrustStance") and attacktable["alttakeammo"] then
		attackCost = attacktable["alttakeammo"];
	else
		attackCost = attacktable["takeammo"];
	end
	
	if cwMedicalSystem then
		local injuries;
		
		if SERVER then
			injuries = cwMedicalSystem:GetInjuries(self.Owner);
		else
			injuries = Clockwork.Client.cwInjuries;
		end
		
		if injuries then
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				attackCost = attackCost + (attacktable["takeammo"] * 2);
			end
			
			if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
				attackCost = attackCost + (attacktable["takeammo"] * 2);
			end
		end
	end
	
	--return self.Owner:GetNWInt("meleeStamina") >= attackCost;
	return self.Owner:GetNWInt("Stamina") >= attackCost;
end

function SWEP:PrimaryAttack()
	local wep = self.Weapon;
	local owner = self.Owner;
	
	if (!self:CanPrimaryAttack()) then 
		return true;
	end
	
	if owner:GetNetVar("Guardening") == true then 
		return true;
	end
	
	if self.critted then self.critted = false end;
	
	local attacktable = GetTable(self.AttackTable);
	local offhandAttackTable;
	local offhandWeapon;
	
	if !attacktable then
		return true;
	end
	
	local curTime = CurTime();
	local delay = attacktable["delay"];
	local stance = "reg_swing";
	local strikeTime = attacktable["striketime"];

	if self:GetNW2Bool("swordplayActive") == true then
		strikeTime = strikeTime * 0.7;
	end
	
	if self:GetNW2String("activeOffhand"):len() > 0 then
		offhandWeapon = weapons.GetStored(self:GetNW2String("activeOffhand"));
		
		if offhandWeapon then
			offhandAttackTable = GetTable(offhandWeapon.AttackTable);
			delay = math.max(attacktable["delay"], offhandAttackTable["delay"]) * 0.95;
			strikeTime = math.max(strikeTime, offhandAttackTable["striketime"], 0.3); -- Dual weapon striketime shall not be lower than 0.3 seconds.
		end
	end
	
	if cwBeliefs and owner.HasBelief and owner:HasBelief("flamboyance") then
		delay = delay * 0.9;
	end
	
	if owner:GetNetVar("ThrustStance") == true then
		stance = "thrust_swing";
	else
		stance = (attacktable["attacktype"]);
	end
	
	if CLIENT then
		hook.Run("PlayerAttacks", owner);
	end
	
	local bAttack = true;
	local bParry = owner:GetNetVar("ParrySuccess");
	local thrustOverride = false;

	owner.blockStaminaRegen = curTime + 5;
	
	if !owner.cloakCooldown or owner.cloakCooldown < (curTime + 5) then
		owner.cloakCooldown = curTime + 5;
	end

	wep:SetNextPrimaryFire(curTime + delay);
	wep:SetNextSecondaryFire(curTime + (delay * 0.1));
	
	if bParry then
		local anim = self.Weapon.realCriticalAnim;
		
		if self:GetNW2Bool("swordplayActive") == true then
			anim = "a_heavy_2h_attack_slash_02_fast";
		end
		
		self:CriticalAnimation();
		self:TriggerAnim(owner, anim);
		owner:SetLocalVar("Riposting", true);
		owner:SetLocalVar("ParrySuccess", false);
	else
		if self.ShouldCriticalHit then
			self.critted = self:ShouldCriticalHit();
		end
	
		if offhandAttackTable then
			local attacksoundtable = GetSoundTable(self.AttackSoundTable);
			local attacksoundtableOffhand = GetSoundTable(offhandWeapon.AttackSoundTable);
			local vm = self.Owner:GetViewModel();
			
			thrustOverride = (!attacktable.canaltattack and attacktable.dmgtype == DMG_VEHICLE) or (!offhandAttackTable.canaltattack and offhandAttackTable.dmgtype == DMG_VEHICLE);
			
			if (owner:GetNetVar("ThrustStance") == true and !owner:GetNetVar("Riposting")) or thrustOverride then
				--Attack animation
				local anim_suffix = "_medium";
				local speed = strikeTime;
				
				if speed <= 0.3 then
					anim_suffix = "_veryfast";
				elseif speed <= 0.35 then
					anim_suffix = "_fast";
				elseif speed >= 0.5 then
					anim_suffix = "_slow";
				end
				
				self:TriggerAnim(self.Owner, "a_dual_swords_stab"..anim_suffix);

				-- Viewmodel attack animation!
				vm:SendViewModelMatchingSequence(vm:LookupSequence("powermissup"));
				self.Owner:GetViewModel():SetPlaybackRate(Lerp(strikeTime, 0.7, 0.3));
				
				if !attacktable.canaltattack and attacktable.dmgtype == DMG_VEHICLE then
					self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])]);
				else
					self.Weapon:EmitSound(attacksoundtable["altsound"][math.random(1, #attacksoundtable["altsound"])]);
				end
				
				if !offhandAttackTable.canaltattack and offhandAttackTable.dmgtype == DMG_VEHICLE then
					self.Weapon:EmitSound(attacksoundtableOffhand["primarysound"][math.random(1, #attacksoundtableOffhand["primarysound"])]);
				else
					self.Weapon:EmitSound(attacksoundtableOffhand["altsound"][math.random(1, #attacksoundtableOffhand["altsound"])]);
				end
				
				self.Owner:ViewPunch(attacktable["punchstrength"] + Angle(1, 1, 1));
			else
				--Attack animation
				local anim_suffix = "_medium";
				local speed = strikeTime;
				
				if speed <= 0.3 then
					anim_suffix = "_veryfast";
				elseif speed <= 0.35 then
					anim_suffix = "_fast";
				elseif speed >= 0.5 then
					anim_suffix = "_slow";
				end
				
				self:TriggerAnim(self.Owner, "a_dual_swords_slash"..anim_suffix.."_0"..tostring(math.random(1, 2)));

				-- Viewmodel attack animation!
				if math.random(1, 2) == 1 then
					vm:SendViewModelMatchingSequence( vm:LookupSequence( "powermissleft1" ) )
				else
					vm:SendViewModelMatchingSequence( vm:LookupSequence( "powermissR1" ) )
				end
				
				self.Owner:GetViewModel():SetPlaybackRate(Lerp(strikeTime + 0.1, 0.45, 0.2));
				
				self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])]);
				self.Weapon:EmitSound(attacksoundtableOffhand["primarysound"][math.random(1, #attacksoundtableOffhand["primarysound"])]);
				self.Owner:ViewPunch(attacktable["punchstrength"] + Angle(1, 1, 1));
			end
		else
			if self.HandleThrustAttack and owner:GetNetVar("ThrustStance") == true and !owner:GetNetVar("Riposting") then
				if self:HandleThrustAttack() ~= false then bAttack = true end;
			else
				if self:HandlePrimaryAttack() ~= false then bAttack = true end;
			end
		end
	end
	
	if SERVER and bAttack and self:IsValid() and (!owner.IsRagdolled or !owner:IsRagdolled()) and owner:Alive() then
		owner:SetLocalVar("MelAttacking", true )
		
		self.HolsterDelay = (curTime + strikeTime)
		self.isAttacking = true;
			
		self:CreateTimer(strikeTime + 0.1, "strikeTimer"..owner:EntIndex(), function()
			if IsValid(self) and IsValid(owner) then
				if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
					local hitSomething = false;
					
					owner:SetLocalVar("MelAttacking", false);
					
					if bParry and IsValid(owner.parryTarget) and owner.parryTarget:IsPlayer() then
						local parryTargetWeapon = owner.parryTarget:GetActiveWeapon();
						
						if IsValid(parryTargetWeapon) and owner.parryTarget:IsWeaponRaised(parryTargetWeapon) then
							parryTargetWeapon:SetNextPrimaryFire(0);
							parryTargetWeapon:SetNextSecondaryFire(0);
						end
						
						owner.parryTarget.blockStaminaRegen = math.min(owner.parryTarget.blockStaminaRegen, curTime + 0.5);
					end
				
					if owner:IsPlayer() and (!owner.IsRagdolled or !owner:IsRagdolled()) and owner:Alive() then
						if !owner:GetNetVar("ParrySuccess", false) and !owner:GetNetVar("Guardening", false) then
							self:Hitscan(); -- For bullet holes.
							owner:LagCompensation(true);
						
							local pos = owner:GetShootPos();
							local aimVector = owner:GetAimVector();
							local meleeArc = attacktable["meleearc"] or 25;
							local meleeRange = (attacktable["meleerange"] or 1) / 10;
							local hitsAllowed = self.MultiHit or 1;
							local hitEntities = {};
							
							if !bParry and (stance == "thrust_swing" or thrustOverride) then
								meleeArc = attacktable["altmeleearc"] or attacktable["meleearc"] or 25;
							
								if attacktable.canaltattack then
									if attacktable.altmeleerange then
										meleeRange = attacktable.altmeleerange / 10;
									end
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
										
									if bParry and tr.Entity:GetNetVar("Parried") and tr.Entity == owner.parryTarget then
										self:HandleHit(tr.Entity, tr.HitPos, "parry_swing");
									else
										self:HandleHit(tr.Entity, tr.HitPos, stance);
									end
									
									hitSomething = true;
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
												
												if bParry and tr2.Entity:GetNetVar("Parried") and tr2.Entity == owner.parryTarget then
													self:HandleHit(tr2.Entity, tr2.HitPos, "parry_swing", #hitEntities);
												else
													self:HandleHit(tr2.Entity, tr2.HitPos, stance, #hitEntities);
												end
												
												hitSomething = true;
											end
										end
									
										if #hitEntities >= hitsAllowed then
											break;
										end
									end
								end
							end
						
							if offhandAttackTable then
								if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
									meleeArc = offhandAttackTable["meleearc"] or 25;
									meleeRange = (offhandAttackTable["meleerange"] or 1) / 10;
									hitsAllowed = offhandWeapon.MultiHit or 1;
									table.Empty(hitEntities);
									
									if stance == "thrust_swing" or thrustOverride then
										meleeArc = offhandAttackTable["altmeleearc"] or offhandAttackTable["meleearc"] or 25;
									
										if offhandAttackTable.canaltattack then
											if offhandAttackTable.altmeleerange then
												meleeRange = offhandAttackTable.altmeleerange;
											end
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

											if bParry and tr.Entity:GetNetVar("Parried") and tr.Entity == owner.parryTarget then
												self:HandleHit(tr.Entity, tr.HitPos, "parry_swing", nil, offhandWeapon, offhandAttackTable);
											else
												self:HandleHit(tr.Entity, tr.HitPos, stance, nil, offhandWeapon, offhandAttackTable);
											end
											
											hitSomething = true;
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
														
														if bParry and tr2.Entity:GetNetVar("Parried") and tr2.Entity == owner.parryTarget then
															self:HandleHit(tr2.Entity, tr2.HitPos, "parry_swing", #hitEntities, offhandWeapon, offhandAttackTable);
														else
															self:HandleHit(tr2.Entity, tr2.HitPos, stance, #hitEntities, offhandWeapon, offhandAttackTable);
														end
														
														hitSomething = true;
													end
												end
											
												if #hitEntities >= hitsAllowed then
													break;
												end
											end
										end
									end
								end
							end
							
							owner:LagCompensation(false);
						end
						
						if (owner:KeyDown(IN_ATTACK2)) then
							if (!owner:KeyDown(IN_USE)) then
								local activeWeapon = owner:GetActiveWeapon();

								if activeWeapon:IsValid() and (activeWeapon.Base == "sword_swepbase") then
									if (activeWeapon.realIronSights == true) then
										local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
										local curTime = CurTime();
										
										if (loweredParryDebug < curTime) then
											local blockTable;
											
											if activeWeapon:GetNW2String("activeOffhand"):len() > 0 then
												local offhandTable = weapons.GetStored(activeWeapon:GetNW2String("activeOffhand"));
												
												if offhandTable then
													blockTable = GetDualTable(activeWeapon.realBlockTable, offhandTable.BlockTable);
												else
													blockTable = GetTable(activeWeapon.realBlockTable);
												end
											else
												blockTable = GetTable(activeWeapon.realBlockTable);
											end
											
											if blockTable then
												local guardblockamount = blockTable["guardblockamount"];
												
												if cwMedicalSystem then
													local injuries;
													
													if SERVER then
														injuries = cwMedicalSystem:GetInjuries(owner);
													else
														injuries = Clockwork.Client.cwInjuries;
													end
													
													if injuries then
														if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
															guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
														end
														
														if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
															guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
														end
													end
												end
												
												--if (owner:GetNWInt("meleeStamina", 100) >= guardblockamount and !owner:GetNetVar("Parried")) then
												if (owner:GetNWInt("Stamina", 100) >= blockTable["guardblockamount"] and !owner:GetNetVar("Parried")) then
													owner:SetLocalVar("Guardening", true);
													owner.beginBlockTransition = true;
													activeWeapon.Primary.Cone = activeWeapon.IronCone;
													activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
												else
													owner:CancelGuardening()
												end;
											end
										end;
									else
										owner:CancelGuardening();
									end;
								end;
							end
						end
					end
					
					if !hitSomething and self.OnMiss then
						local meleerange;
						
						if self.Owner:GetNetVar("ThrustStance") and attacktable["altmeleerange"] then
							meleerange = attacktable["altmeleerange"];
						else
							meleerange = attacktable["meleerange"] or 1;
						end
					
						local tr = util.TraceLine( {
							start = self.Owner:GetShootPos(),
							endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * (meleerange) / 9),
							filter = self.Owner,
							mask = MASK_SHOT_HULL
						} )
					
						if !tr.Hit then
							self:OnMiss();
						end
					end
					
					self.isAttacking = false;
				end
				
				if owner:GetNetVar("Riposting") then
					owner:SetLocalVar("Riposting", false);
				end
			end
		end)
	end

	if (SERVER) then
		--local max_poise = owner:GetNetVar("maxMeleeStamina");
		local takeAmmo = attacktable["takeammo"] or 1;
		local takeAmmoOffhand;
		
		if self.Owner:GetNetVar("ThrustStance") then
			if attacktable["alttakeammo"] then
				takeAmmo = attacktable["alttakeammo"];
			end
			
			if offhandAttackTable then
				if attacktable["alttakeammo"] then
					takeAmmoOffhand = offhandAttackTable["alttakeammo"];
				else
					takeAmmoOffhand = offhandAttackTable["takeammo"];
				end
			end
		else
			if offhandAttackTable then
				takeAmmoOffhand = offhandAttackTable["takeammo"];
			end
		end
		
		if offhandAttackTable then
			takeAmmo = math.max((takeAmmo + takeAmmoOffhand) * 0.75);
		end
		
		local attackCost = takeAmmo;

		if cwMedicalSystem then
			local injuries;
			
			if SERVER then
				injuries = cwMedicalSystem:GetInjuries(self.Owner);
			else
				injuries = Clockwork.Client.cwInjuries;
			end
			
			if injuries then
				if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
					attackCost = attackCost + (takeAmmo * 2);
				end
				
				if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
					attackCost = attackCost + (takeAmmo * 2);
				end
			end
		end
			
		--owner:SetNWInt("meleeStamina", math.Clamp(owner:GetNWInt("meleeStamina", max_poise) - attackCost, 0, max_poise));
		owner:HandleStamina(-attackCost);
	end;
end

--if (SERVER) then
	function SWEP:HandleHit(hit, src, swingType, hitIndex, offhandWeapon, offhandAttackTable)
		local attacktable = GetTable(offhandAttackTable or self.AttackTable);
		local attacksoundtable = GetSoundTable(self.AttackSoundTable);
		local blockTable = GetTable(self:GetNW2String("activeShield"));
		local hit_reduction = 1;
		local shield_reduction = 1;
		local owner = self.Owner;
		local weaponClass = self:GetClass();
		local bTake;
		local enemywep;
		local weapon = self;
		local distance = (owner:GetPos():Distance(hit:GetPos()))
		
		if offhandWeapon then
			attacksoundtable = GetSoundTable(offhandWeapon.AttackSoundTable);
			weaponClass = self:GetNW2String("activeOffhand");
			
			if !self.Owner:HasWeapon(weaponClass) then
				weapon = self.Owner:Give(weaponClass) or self;
				
				bTake = true;
			end
		end
		
		if (hit:IsWorld()) then
			for k, v in pairs (ents.FindInSphere(src, 32)) do
				if (v:GetClass() == "prop_ragdoll") and Clockwork.entity:IsPlayerRagdoll(v) then
					hit = Clockwork.entity:GetPlayer(v);
					break;
				end;
			end;
		elseif hit:GetClass() == "prop_ragdoll" and Clockwork.entity:IsPlayerRagdoll(hit) then
			hit = Clockwork.entity:GetPlayer(hit);
		end;

		if hit:IsValid() and hit:IsPlayer() then
			enemywep = hit:GetActiveWeapon()
		end
		
		if blockTable then
			shield_reduction = blockTable.damagereduction or 1;
		end
		
		if cwBeliefs and owner.HasBelief then
			if owner:HasBelief("shieldwall") then
				shield_reduction = 1;
			end
		end
		
		if hitIndex then
			if !cwBeliefs or !owner.HasBelief or !owner:HasBelief("unrelenting") then
				hit_reduction = (1 / hitIndex);
			end
		end
		
		local damage = (attacktable["primarydamage"])
		local damagetype = (attacktable["dmgtype"])
		local stabilitydamage = (attacktable["stabilitydamage"]);

		if self.Owner:GetNetVar("ThrustStance") and attacktable["altattackstabilitydamagemodifier"] then
			stabilitydamage = stabilitydamage * attacktable["altattackstabilitydamagemodifier"];
		end
		
		if self:GetNW2String("activeOffhand"):len() > 0 then -- Dual Weapon damage reduction
			damage = damage * 0.75;
			stabilitydamage = stabilitydamage * 0.7;
		end

		if swingType == "parry_swing" then
			if (IsValid(hit) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
				local d = DamageInfo()
				
				if cwBeliefs and owner.HasBelief and owner:HasBelief("repulsive_riposte") then
					d:SetDamage(damage * shield_reduction * 3.5 * hit_reduction);
				else
					d:SetDamage(damage * shield_reduction * 3 * hit_reduction);
				end
				
				d:SetAttacker( owner )
				d:SetDamageType( damagetype )
				d:SetDamagePosition(src)
				d:SetInflictor(weapon);
			
				if (hit:IsPlayer()) then
					d:SetDamageForce(owner:GetForward() * 5000);

					if (hit:IsRagdolled()) then
						if self.isDagger then -- Daggers deal more damage against fallen opponents
							d:ScaleDamage(2);
							
							if hit:GetNetVar("ActName") == "unragdoll" then
								Clockwork.player:ExtendAction(hit, 0.7);
							end
						end
					end
				end
				
				hit:TakeDamageInfo(d)

				if (hit:IsNPC() or hit:IsNextBot()) then
					local trace = owner:GetEyeTrace();
					
					-- Fire attack type
					if (hit:IsValid()) and attacktable["attacktype"] == "fire_swing" then
						if offhandWeapon then
							hit:Ignite(weapon.IgniteTime);
						else
							hit:Ignite(weapon.IgniteTime);
						end
					end
					
					-- Ice attack type
					if (hit:IsValid()) and attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
						if offhandWeapon then
							hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
						else
							hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
						end
					end
				end

				if hit:IsPlayer() and !hit:IsRagdolled() and hit:GetNetVar("Deflect") != true and hit:GetNetVar("Parry") != true and !hit.iFrames then
					self:TriggerAnim4(hit, "a_shared_hit_0"..math.random(1, 3));
					
					if owner.upstagedActive and not hit.opponent then
						if IsValid(enemywep) and !enemywep.noDisarm then
							if --[[enemywep:GetNW2String("activeShield"):len() == 0 and]] not string.find(enemywep:GetClass(), "begotten_fists") and not string.find(enemywep:GetClass(), "begotten_claws") then
								local dropMessages = {" goes flying out of their hand!", " is knocked out of their hand!"};
								local dropPos = hit:GetPos() + Vector(0, 0, 35) + hit:GetAngles():Forward() * 4
								local itemTable = Clockwork.item:GetByWeapon(enemywep);
								
								if itemTable then
									local itemEnt = Clockwork.entity:CreateItem(hit, itemTable, dropPos);
									
									if (IsValid(itemEnt)) then
										Clockwork.chatBox:AddInTargetRadius(hit, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], hit:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
										hit:TakeItem(itemTable)
										hit:SelectWeapon("begotten_fists")
										hit:StripWeapon(enemywep:GetClass())
									end
								end
							end
						end
					end
				end
				 
				if hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit.iFrames then
					hit:TakeStability((stabilitydamage * 3) * shield_reduction * hit_reduction)		

					-- Fire attack type
					if (hit:IsValid()) and attacktable["attacktype"] == "fire_swing" then
						if offhandWeapon then
							hit:Ignite(weapon.IgniteTime);
						else
							hit:Ignite(weapon.IgniteTime);
						end
					end
					
					-- Ice attack type
					if (hit:IsValid()) and attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
						if offhandWeapon then
							hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
						else
							hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
						end
					end
				end
			end
		elseif swingType == "thrust_swing" then
			if !owner:GetNetVar("ThrustStance") then
				if !self.isMeleeFirearm then
					owner:SetNetVar("ThrustStance", false);
				end
			end

			if hit:IsValid() and hit:IsPlayer() then
				enemywep = hit:GetActiveWeapon()
			end

			if owner:IsValid() and !owner:IsRagdolled() and owner:Alive() then
				-- Spear Damage System		
				damagetype = 16;
				
				-- Blunt swipe or piercing thrust?
				if weapon.CanSwipeAttack == true then
					damagetype = 128
					
					if hit:IsValid() then
						if (hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect")) and !hit.iFrames then
							-- KNOCKBACK
							local knockback = owner:GetAngles():Forward() * 750;
							knockback.z = 0
							
							timer.Simple(0.1, function()
								if IsValid(hit) then
									hit:SetVelocity(knockback);
								end
							end);
							
							if hit:IsPlayer() then
								hit:TakeStability(25 * shield_reduction * hit_reduction);
							end
						end
					end
				elseif weapon.BluntAltAttack == true then
					damagetype = 128
					if hit:IsValid() then
						if (hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect")) and !hit.iFrames then							
							if hit:IsPlayer() then
								hit:TakeStability((stabilitydamage * 0.5) * shield_reduction * hit_reduction);
							end
						end
					end
				end
				-- Polearm alt attack spear shaft hit system
				if (IsValid(self)) then
					if string.find(weaponClass, "begotten_polearm_") and weapon.CanSwipeAttack != true then		
						local maxPoleRange = (attacktable["meleerange"]) * 0.1
						local maxIneffectiveRange = maxPoleRange * 0.53
						local clampedDistance = math.min(math.max(distance, 0), maxPoleRange)
						local ratio = clampedDistance / maxPoleRange
						local minDamage = (attacktable["primarydamage"] * 0.7)
						local maxDamage = (attacktable["primarydamage"] * 1.7)
						local variableDamage = minDamage + (maxDamage - minDamage) * ratio
						
						if distance <= maxIneffectiveRange and hit:IsValid() then
							if (hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect")) and !hit.iFrames then
								damage = math.max(1, (attacktable["primarydamage"]) * 0.01)
								damagetype = 128
								
								-- KNOCKBACK
								local knockback = owner:GetAngles():Forward() * 700;
								knockback.z = 0
								
								-- timers are shit but whatever
								timer.Simple(0.1, function()
									if IsValid(hit) then
										hit:SetVelocity(knockback);
									end
								end);
								
								if hit:IsPlayer() then
									hit:TakeStability(5)
								end
							end
						elseif distance > maxIneffectiveRange and hit:IsValid() then
							if (hit:IsNPC() or hit:IsNextBot()) or hit:IsPlayer() then
								damage = variableDamage
								damagetype = 16
							end
						end
					end
				end
				
				-- Condition damage modifier
				local itemTable = item.GetByWeapon(self);
				
				if offhandWeapon then
					for k, v in pairs(self.Owner.equipmentSlots) do
						if v:IsTheSameAs(itemTable) then
							local offhandItem = self.Owner.equipmentSlots[k.."Offhand"];
							
							if offhandItem then
								itemTable = offhandItem;
							end
						
							break;
						end
					end
				end
				
				if itemTable then
					local condition = itemTable:GetCondition();
					
					if condition and condition < 100 then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							damage = math.Round(damage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							damage = math.Round(damage * Lerp(scalar, 0.4, 1));
						else
							damage = math.Round(damage * Lerp(scalar, 0.5, 1));
						end
					end
				end
				
				if (IsValid(hit) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
					local d = DamageInfo()
					d:SetDamage( damage * shield_reduction * (attacktable["altattackdamagemodifier"] or 1) * hit_reduction)
					d:SetAttacker( owner )
					d:SetDamageType( damagetype )
					d:SetDamagePosition(src)
					d:SetInflictor(weapon);
				
					if (hit:IsPlayer()) then
						d:SetDamageForce(owner:GetForward() * 5000);
						
						if (hit:IsRagdolled()) then
							if self.isDagger then -- Daggers deal more damage against fallen opponents
								d:ScaleDamage(2);
								
								if hit:GetNetVar("ActName") == "unragdoll" then
									Clockwork.player:ExtendAction(hit, 0.7);
								end
							end
						end
					end
					
					hit:TakeDamageInfo(d)
					
					if (hit:IsNPC() or hit:IsNextBot()) then
						-- Fire attack type
						if attacktable["attacktype"] == "fire_swing" then
							if offhandWeapon then
								hit:Ignite(weapon.IgniteTime);
							else
								hit:Ignite(weapon.IgniteTime);
							end
						end
						
						-- Ice attack type
						if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
							if offhandWeapon then
								hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
							else
								hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
							end
						end
					else
						if hit:IsPlayer() and !hit:GetNetVar("Guardening") == true and !hit:GetNetVar("Parry") == true and !hit.iFrames then
							-- Fire attack type
							if attacktable["attacktype"] == "fire_swing" then
								if offhandWeapon then
									hit:Ignite(weapon.IgniteTime);
								else
									hit:Ignite(weapon.IgniteTime);
								end
							end
							
							-- Ice attack type
							if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
								if offhandWeapon then
									hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
								else
									hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
								end
							end
							
							if weapon.CanSwipeAttack == true then
								hit:TakeStability(15)		
							end
						end
					end

					if hit:IsPlayer() and !hit:IsRagdolled() and hit:GetNetVar("Deflect") != true and hit:GetNetVar("Parry") != true and !hit.iFrames then
						self:TriggerAnim4(hit, "a_shared_hit_0"..math.random(1, 3)); 
					end
				end
			end
		elseif swingType == "polearm_swing" then
			local poledamage = (attacktable["primarydamage"])
			local poletype = (attacktable["dmgtype"])
			local maxPoleRange = (attacktable["meleerange"]) * 0.1
			local maxIneffectiveRange = maxPoleRange * 0.53
			local clampedDistance = math.min(math.max(distance, 0), maxPoleRange)
			local ratio = clampedDistance / maxPoleRange
			local minDamage = (attacktable["primarydamage"] * 0.7)
			local maxDamage = (attacktable["primarydamage"] * 1.7)
			local variableDamage = minDamage + (maxDamage - minDamage) * ratio
			local minStabilityDamage = (attacktable["stabilitydamage"] * 0.7)
			local maxStabilityDamage = (attacktable["stabilitydamage"] * 1.7)
			local variableStabilityDamage = minStabilityDamage + (maxStabilityDamage - minStabilityDamage) * ratio
		
			if owner:GetNetVar("ThrustStance") then
				owner:SetNetVar("ThrustStance", false);
			end

			if (!hit.nexthit or CurTime() > hit.nexthit) then 
				hit.nexthit = CurTime() + 1
			end

			if hit:IsValid() and hit:IsPlayer() then
				enemywep = hit:GetActiveWeapon()
			end

			if !owner:IsRagdolled() and owner:Alive() then
				-- Polearm Damage System				
				if distance <= maxIneffectiveRange then
					if (hit:IsNPC() or hit:IsNextBot()) or hit:IsPlayer() then
						poledamage = (attacktable["primarydamage"]) * 0.01
						poletype = 128
						if hit:IsValid() and hit:IsPlayer() and !hit:GetNetVar("Guardening") == true and hit:GetNetVar("Parry") != true and !hit.iFrames then
							hit:TakeStability(15)
							-- KNOCKBACK
							local knockback = owner:GetAngles():Forward() * 700;
							knockback.z = 0
							
							timer.Simple(0.1, function()
								if IsValid(hit) then
									hit:SetVelocity(knockback);
								end
							end);
						end
					end
				else
					if (hit:IsNPC() or hit:IsNextBot()) or hit:IsPlayer() then
						poletype = (attacktable["dmgtype"])
						poledamage = variableDamage
						
						-- counter damage
						local targetVelocity = hit:GetVelocity();
						
						if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
							local entEyeAngles = hit:EyeAngles();
						
							if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - hit:GetPos()):Angle().y)) <= 90 then
								poledamage = poledamage + (poledamage * 0.5);
							end
						end
						
						if hit:IsValid() and hit:IsPlayer() and !hit:GetNetVar("Guardening") == true and hit:GetNetVar("Parry") != true and !hit.iFrames then
							hit:TakeStability(variableStabilityDamage)
						end
					end
				end
				
				-- Condition damage modifier
				local itemTable = item.GetByWeapon(self);
				
				if offhandWeapon then
					for k, v in pairs(self.Owner.equipmentSlots) do
						if v:IsTheSameAs(itemTable) then
							local offhandItem = self.Owner.equipmentSlots[k.."Offhand"];
							
							if offhandItem then
								itemTable = offhandItem;
							end
						
							break;
						end
					end
				end
				
				if itemTable then
					local condition = itemTable:GetCondition();
					
					if condition and condition < 100 then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if poletype == DMG_CLUB then
							poledamage = math.Round(poledamage * Lerp(scalar, 0.75, 1));
						elseif poletype == DMG_SLASH then
							poledamage = math.Round(poledamage * Lerp(scalar, 0.4, 1));
						else
							poledamage = math.Round(poledamage * Lerp(scalar, 0.5, 1));
						end
					end
				end
			
				-- Polearm Damage System
				if (IsValid(hit) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
					local d = DamageInfo()
					d:SetDamage( poledamage * shield_reduction * hit_reduction)
					d:SetAttacker( owner )
					d:SetDamageType( damagetype )
					d:SetDamagePosition(src)
					d:SetInflictor(weapon);
				
					if (hit:IsPlayer()) then
						d:SetDamageForce(owner:GetForward() * 5000);
				
						if (hit:IsRagdolled()) then
							if self.isDagger then -- Daggers deal more damage against fallen opponents
								d:ScaleDamage(2);

								if hit:GetNetVar("ActName") == "unragdoll" then
									Clockwork.player:ExtendAction(hit, 0.7);
								end
							end
						end
					end

					hit:TakeDamageInfo(d)

					if (hit:IsNPC() or hit:IsNextBot()) then
						-- Fire attack type
						if attacktable["attacktype"] == "fire_swing" then
							if offhandWeapon then
								hit:Ignite(weapon.IgniteTime);
							else
								hit:Ignite(weapon.IgniteTime);
							end
						end
						
						-- Ice attack type
						if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
							if offhandWeapon then
								hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
							else
								hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
							end
						end
					else
						if hit:IsPlayer() and !hit:GetNetVar("Guardening") == true and !hit:GetNetVar("Parry") == true and !hit.iFrames then
							-- Fire attack type
							if attacktable["attacktype"] == "fire_swing" then
								if offhandWeapon then
									hit:Ignite(weapon.IgniteTime);
								else
									hit:Ignite(weapon.IgniteTime);
								end
							end
							
							-- Ice attack type
							if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
								if offhandWeapon then
									hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
								else
									hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
								end
							end
						end
					end

					if hit:IsPlayer() and !hit:IsRagdolled() and hit:GetNetVar("Deflect") != true and hit:GetNetVar("Parry") != true and !hit.iFrames then
						self:TriggerAnim4(hit, "a_shared_hit_0"..math.random(1, 3)); 
					end
				end
			end
		else -- reg_swing and others
			if owner:GetNetVar("ThrustStance") then
				if !self.isMeleeFirearm then
					owner:SetNetVar("ThrustStance", false);
				end
			end

			if hit:IsValid() and hit:IsPlayer() then
				enemywep = hit:GetActiveWeapon()
			end

			if !owner:IsRagdolled() and owner:Alive() then				
				-- Spear Damage System (Messy)					
				if (IsValid(self)) then
					if string.find(weaponClass, "begotten_spear_") then
						local maxPoleRange = (attacktable["meleerange"]) * 0.1
						local maxIneffectiveRange = maxPoleRange * 0.53
					
						if distance <= maxIneffectiveRange and hit:IsValid() then
							damage = (attacktable["primarydamage"]) * 0.01
							damagetype = 128
							
							if (hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect")) and !hit.iFrames then
								--print "Spear Shaft Hit"
								damage = math.max(1, (attacktable["primarydamage"]) * 0.01)
								damagetype = 128
								
								-- KNOCKBACK
								local knockback = owner:GetAngles():Forward() * 600;
								knockback.z = 0

								timer.Simple(0.1, function()
									if IsValid(hit) then
										hit:SetVelocity(knockback);
									end
								end);
								
								if hit:IsPlayer() then
									hit:TakeStability(15)
								end
							end
					
						elseif distance > maxIneffectiveRange and hit:IsValid() then
							damage = (attacktable["primarydamage"])
							damagetype = (attacktable["dmgtype"])
							
							if (hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect")) and !hit.iFrames then
								-- counter damage
								local targetVelocity = hit:GetVelocity();
								
								if math.abs(targetVelocity.x) > 150 or math.abs(targetVelocity.y) > 150 then
									local entEyeAngles = hit:EyeAngles();
								
									if math.abs(math.AngleDifference(entEyeAngles.y, (owner:GetPos() - hit:GetPos()):Angle().y)) <= 90 then
										damage = damage + (damage * 0.5);
									end
								end
								
								if hit:IsPlayer() then
									hit:TakeStability((stabilitydamage * shield_reduction * hit_reduction));
								end
							end
						end
					else
						-- For non-spears
						if hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect") and !hit.iFrames then
							if owner.GetCharmEquipped and owner:GetCharmEquipped("ring_pugilist") and weaponClass == "begotten_fists" then
								hit:TakeStability(25);
							else
								hit:TakeStability((stabilitydamage * shield_reduction * hit_reduction));
							end
						end
						
						-- Bellhammer special
						if weapon.IsBellHammer == true and ((hit:IsNPC() or hit:IsNextBot()) or (hit:IsPlayer() and !hit:GetNetVar("Guardening") and !hit:GetNetVar("Parry") and !hit:GetNetVar("Deflect"))) and !hit.iFrames then
							owner:Disorient(1)
							
							timer.Simple(0.2, function() 
								if hit:IsValid() and (hit:IsNPC() or hit:IsNextBot()) or hit:IsPlayer() then
									hit:EmitSound("meleesounds/bell.mp3")
								end 
							end);
							
							if hit:IsPlayer() then
								hit:Disorient(5);
							end
						end
					end
				end

				-- Condition damage modifier
				local itemTable = item.GetByWeapon(self);
				
				if offhandWeapon then
					for k, v in pairs(self.Owner.equipmentSlots) do
						if v:IsTheSameAs(itemTable) then
							local offhandItem = self.Owner.equipmentSlots[k.."Offhand"];
							
							if offhandItem then
								itemTable = offhandItem;
							end
						
							break;
						end
					end
				end

				if itemTable then
					local condition = itemTable:GetCondition();
					
					if condition and condition < 100 then
						local scalar = Lerp(condition / 90, 0, 1); -- Make it so damage does not start deterioriating until below 90% condition.
					
						if damagetype == DMG_CLUB then
							damage = math.Round(damage * Lerp(scalar, 0.75, 1));
						elseif damagetype == DMG_SLASH then
							damage = math.Round(damage * Lerp(scalar, 0.4, 1));
						else
							damage = math.Round(damage * Lerp(scalar, 0.5, 1));
						end
					end
				end
				
				if self.critted then
					damage = math.Round(damage * 1.7);
				end
			
				-- Spear Damage System (Messy)
				if (IsValid(hit) and owner:IsValid() and !owner:IsRagdolled() and owner:Alive()) then
					local d = DamageInfo()
					d:SetDamage( damage * shield_reduction * hit_reduction)
					d:SetAttacker( owner )
					d:SetDamageType( damagetype )
					d:SetDamagePosition(src)
					d:SetInflictor(weapon);
				
					if (hit:IsPlayer()) then
						d:SetDamageForce(owner:GetForward() * 5000);
						
						if (hit:IsRagdolled()) then
							if self.isDagger then -- Daggers deal more damage against fallen opponents
								d:ScaleDamage(2);

								if hit:GetNetVar("ActName") == "unragdoll" then
									Clockwork.player:ExtendAction(hit, 0.7);
								end
							end
						end
					end
					
					hit:TakeDamageInfo(d)

					if (hit:IsNPC() or hit:IsNextBot()) then
						-- Fire attack type
						if attacktable["attacktype"] == "fire_swing" then
							if offhandWeapon then
								hit:Ignite(weapon.IgniteTime);
							else
								hit:Ignite(weapon.IgniteTime);
							end
						end
						
						-- Ice attack type
						if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
							if offhandWeapon then
								hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
							else
								hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
							end
						end
					else
						if hit:IsPlayer() and !hit:GetNetVar("Guardening") == true and !hit:GetNetVar("Parry") == true and !hit.iFrames then
							-- Fire attack type
							if attacktable["attacktype"] == "fire_swing" then
								if offhandWeapon then
									hit:Ignite(weapon.IgniteTime);
								else
									hit:Ignite(weapon.IgniteTime);
								end
							end
							
							-- Ice attack type
							if attacktable["attacktype"] == "ice_swing" and hit.AddFreeze then
								if offhandWeapon then
									hit:AddFreeze((weapon.FreezeDamage * 0.6) * (hit:WaterLevel() + 1), owner);
								else
									hit:AddFreeze(weapon.FreezeDamage * (hit:WaterLevel() + 1), owner);
								end
							end
						end
					end

					if hit:IsPlayer() and !hit:IsRagdolled() and hit:GetNetVar("Deflect") != true and hit:GetNetVar("Parry") != true and !hit.iFrames then
						self:TriggerAnim4(hit, "a_shared_hit_0"..math.random(1, 3)); 
					end
				end
			end
		end
		
		if bTake then
			timer.Simple(FrameTime(), function()
				if IsValid(self.Owner) then
					self.Owner:StripWeapon(weaponClass);
				end
			end);
		end
	end
--end

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

	local bIron = ply:GetNetVar("Guardening");
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
	
	local Offset	= self.realIronSightsPos;

		
	if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 350 and ply:WaterLevel() < 1 and self.Sprint == true --[[and wep:GetNWInt("Reloading") < CurTime()]] then
		SprintMul = Lerp(FT*4, SprintMul, 1)	
		--wep:SetNWBool( "SprintShit", true )			
	else
		SprintMul = Lerp(FT*4, SprintMul, 0)
		--wep:SetNWBool( "SprintShit", false )				
	end
	
	if ( self.realIronSightsAng ) then	
		ModAngX = self.realIronSightsAng.x
		ModAngY = self.realIronSightsAng.y 
		ModAngZ = self.realIronSightsAng.z
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
	local blocktable;
	local ply = self.Owner;

	if self:GetNW2String("activeOffhand"):len() > 0 then
		local offhandTable = weapons.GetStored(self:GetNW2String("activeOffhand"));
		
		if offhandTable then
			blocktable = GetDualTable(self.realBlockTable, offhandTable.BlockTable);
		else
			blocktable = GetTable(self.realBlockTable);
		end
	else
		blocktable = GetTable(self.realBlockTable);
	end
	
	ply:SetLocalVar("MelAttacking", false)
	
	local parryWindow = blocktable["parrydifficulty"] or 0.15;
	local curTime = CurTime();

	if ply:KeyDown(IN_ATTACK2) and !ply:KeyDown(IN_RELOAD) and ply:GetNetVar("Guardening") == true then
		-- Deflection
		if blocktable["candeflect"] == true then
			local deflectioncooldown = 1.5;
			
			if ply:HasBelief("sidestep") then
				deflectioncooldown = 1.2
			end
		
			if self.canDeflect then
				local deflectionWindow = blocktable["deflectionwindow"] or 0.15;
				
				--if ply.HasBelief and ply:HasBelief("deflection") then
				if (!ply.nextDeflect or curTime > ply.nextDeflect) then
					ply:SetLocalVar("Deflect", true )
					
					if ply:HasBelief("impossibly_skilled") then
						deflectionWindow = deflectionWindow + 0.1;
					end
					
					if ply:GetCharmEquipped("holy_sigils") then
						deflectionWindow = deflectionWindow + 0.1;
					end
				end
								
				self:CreateTimer(deflectionWindow, "deflectionOffTimer"..ply:EntIndex(), function()
					if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
						ply:SetLocalVar("Deflect", false ) 
					end 
				end);

				self.canDeflect = false;
				self:CreateTimer(deflectioncooldown, "deflectionTimer"..ply:EntIndex(), function()
					if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
						self.canDeflect = true;
					end 
				end);
			else
				self:CreateTimer(deflectioncooldown, "deflectionTimer"..ply:EntIndex(), function()
					if self:IsValid() and !ply:IsRagdolled() and ply:Alive() then
						self.canDeflect = true;
					end 
				end);
			end
		end		
	end

	if ( !self.realIronSightsPos ) then return end
	if ( LoweredParryDebug > curTime ) then return end
	if ( self:GetNextPrimaryFire() > curTime * 1.5 ) then return end
	if ( ply:KeyDown(IN_ATTACK2) ) then return end
	if ( !self:CanSecondaryAttack() ) then return end
	if ( ply:GetNetVar("Guardening") ) == true then return end
	--if ( self.Weapon:GetNWInt("Reloading") > curTime ) then return end
	local parry_cost = blocktable["parrytakestamina"];
	
	if cwMedicalSystem then
		local injuries;
		
		if SERVER then
			injuries = cwMedicalSystem:GetInjuries(ply);
		else
			injuries = Clockwork.Client.cwInjuries;
		end
		
		if injuries then
			if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
				parry_cost = parry_cost + (blocktable["parrytakestamina"] * 2);
			end
			
			if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
				parry_cost = parry_cost + (blocktable["parrytakestamina"] * 2);
			end
		end
	end
	
	--if ply:GetNWInt("meleeStamina", 100) < parry_cost then return end
	if ply:GetNWInt("Stamina", 100) < parry_cost then return end
	
	if self.ParryAnimation then
		self:ParryAnimation()
	else
		ErrorNoHalt("ParryAnimation function not found for swep: "..self:GetClass());
	end
	
	ply:EmitSound(attacksoundtable["parryswing"][math.random(1, #attacksoundtable["parryswing"])])

	local wep = self.Weapon
	--local max_poise = ply:GetNetVar("maxMeleeStamina");

	wep:SetNextPrimaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
	wep:SetNextSecondaryFire(math.max(curTime + (attacktable["delay"]), curTime + 2));
 
	--Parry anim
	self:TriggerAnim(ply, self.realParryAnim);

	--ply:SetNWInt("meleeStamina", math.Clamp(ply:GetNWInt("meleeStamina") - parry_cost, 0, max_poise));
	ply:HandleStamina(-parry_cost);
		
	--Parry
	ply.blockStaminaRegen = curTime + 5;
	ply:SetLocalVar("Parry", true )
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
		if self:IsValid() and ply:IsValid() then
			ply:SetLocalVar("Parry", false)
			
			if ply.parryStacks then
				ply.parryStacks = nil;
			end
			
			if ply:IsRagdolled() or !ply:Alive() then return end;
			
			if (ply:KeyDown(IN_ATTACK2)) then
				if (!ply:KeyDown(IN_USE)) then
					local activeWeapon = ply:GetActiveWeapon();

					if activeWeapon:IsValid() and (activeWeapon.Base == "sword_swepbase") then
						if (activeWeapon.realIronSights == true) then
							local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
							local curTime = CurTime();
							
							if (loweredParryDebug < curTime) then
								local blockTable;

								if activeWeapon:GetNW2String("activeOffhand"):len() > 0 then
									local offhandTable = weapons.GetStored(activeWeapon:GetNW2String("activeOffhand"));
									
									if offhandTable then
										blockTable = GetDualTable(activeWeapon.realBlockTable, offhandTable.BlockTable);
									else
										blockTable = GetTable(activeWeapon.realBlockTable);
									end
								else
									blockTable = GetTable(activeWeapon.realBlockTable);
								end
								
								if blockTable then
									local guardblockamount = blockTable["guardblockamount"];
									
									if cwMedicalSystem then
										local injuries;
										
										if SERVER then
											injuries = cwMedicalSystem:GetInjuries(ply);
										else
											injuries = Clockwork.Client.cwInjuries;
										end
										
										if injuries then
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
											
											if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
										end
									end
													
									--if (ply:GetNWInt("meleeStamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
									if (ply:GetNWInt("Stamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
										ply:SetLocalVar("Guardening", true);
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

					if activeWeapon:IsValid() and (activeWeapon.Base == "sword_swepbase") then
						if (activeWeapon.realIronSights == true) then
							local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
							local curTime = CurTime();
							
							if (loweredParryDebug < curTime) then
								local blockTable;

								if activeWeapon:GetNW2String("activeOffhand"):len() > 0 then
									local offhandTable = weapons.GetStored(activeWeapon:GetNW2String("activeOffhand"));
									
									if offhandTable then
										blockTable = GetDualTable(activeWeapon.realBlockTable, offhandTable.BlockTable);
									else
										blockTable = GetTable(activeWeapon.realBlockTable);
									end
								else
									blockTable = GetTable(activeWeapon.realBlockTable);
								end
								
								if blockTable then
									local guardblockamount = blockTable["guardblockamount"];
									
									if cwMedicalSystem then
										local injuries;
										
										if SERVER then
											injuries = cwMedicalSystem:GetInjuries(ply);
										else
											injuries = Clockwork.Client.cwInjuries;
										end
										
										if injuries then
											if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
											
											if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
												guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
											end
										end
									end
													
									--if (ply:GetNWInt("meleeStamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
									if (ply:GetNWInt("Stamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
										ply:SetLocalVar("Guardening", true);
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
	
function SWEP:Equip()
	self:SetHoldType(self:GetHoldtypeOverride())
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
	self:TriggerAnim2(player, self.realBlockAnim, 1);
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
	return false
end

function SWEP:GetPrintName()
	if self:GetNW2String("activeShield"):len() > 0 and !self.HasShield then
		local shieldTable = GetTable(self:GetNW2String("activeShield"));
		
		if shieldTable and shieldTable.name then
			return self.PrintName.." & "..shieldTable.name;
		end
	elseif self:GetNW2String("activeOffhand"):len() > 0 then
		local weaponTable = weapons.GetStored(self:GetNW2String("activeOffhand"));

		if weaponTable and weaponTable.PrintName then
			if weaponTable.PrintName == self.PrintName then
				if self.DualNameOverride then
					return self.DualNameOverride;
				else
					return "Dual "..self.PrintName.."s";
				end
			else
				local tab = {self.PrintName, weaponTable.PrintName};
			
				table.sort(tab);
			
				return tab[1].." & "..tab[2];
			end
		end
	end
	
	return self.PrintName;
end

function SWEP:EquipOffhand(weaponClass)
	if self:GetNW2String("activeShield"):len() > 0 then
		self:HolsterShield();
	end

	if SERVER then
		self:CallOnClient("EquipOffhand", weaponClass);
	end
	
	local weaponTable = weapons.GetStored(weaponClass);
	
	if weaponTable then
		self:SetNW2String("activeOffhand", weaponClass);

		if IsValid(self.Owner) then
			self.Owner:CancelGuardening();
		end
		
		self:Initialize();
	end
end

function SWEP:HolsterOffhand()
	if SERVER then
		self:CallOnClient("HolsterOffhand"); 
	end

	self:SetNW2String("activeOffhand", "");
	
	if CLIENT then
		self:RemoveModels();
	end

	if IsValid(self.Owner) then
		self.Owner:CancelGuardening();
	end
	
	self:Initialize();
end

function SWEP:EquipShield(uniqueID)
	if self:GetNW2String("activeOffhand"):len() > 0 then
		return;
	end

	if SERVER then
		self:CallOnClient("EquipShield", uniqueID);
	end
	
	local shieldTable = GetTable(uniqueID);
	
	if shieldTable then
		self:SetNW2String("activeShield", uniqueID);

		if IsValid(self.Owner) then
			self.Owner:CancelGuardening();
		end

		self:Initialize();
	end
end

function SWEP:HolsterShield()
	if SERVER then
		self:CallOnClient("HolsterShield"); 
	end
	
	self:SetNW2String("activeShield", "");
	
	if CLIENT then
		self:RemoveModels();
	end
	
	if IsValid(self.Owner) then
		self.Owner:CancelGuardening();
	end
	
	self:Initialize();
end

function SWEP:Initialize()
	if self:GetNW2String("activeShield"):len() > 0 and !self.HasShield then
		local shieldTable = GetTable(self:GetNW2String("activeShield"));
		
		if shieldTable then
			local weaponTable = weapons.GetStored(self:GetClass());
			
			self.realIronSights = true;
			self.realBlockAnim = shieldTable.blockanim;
			self.realBlockTable = shieldTable;
			self.realBlockTableOffhand = nil;
			self.realBlockSoundTable = shieldTable.blocksoundtable;
			self.realCriticalAnim = self.CriticalAnimShield;
			self.realHoldType = self.HoldTypeShield;
			self.realParryAnim = "a_sword_shield_parry";
			self.ViewModel = weaponTable.ViewModel;
			self.ViewModelFOV = weaponTable.ViewModelFOV;
			self.ViewModelBoneMods = weaponTable.ViewModelBoneMods;
			
			local ironsightsTab = shieldTable.ironsights[self.ViewModel];
			
			if ironsightsTab then
				self.realIronSightsPos = ironsightsTab.pos;
				self.realIronSightsAng = ironsightsTab.ang;
			else
				self.realIronSightsPos = self.IronSightsPos;
				self.realIronSightsAng = self.IronSightsAng;
			end
		else
			error("Shield not found for player "..self.Owner:GetName().." swep "..self:GetPrintName().." shield "..self:GetNW2String("activeShield").."!");
		end
	elseif self:GetNW2String("activeOffhand"):len() > 0 then
		local weaponTable = weapons.GetStored(self:GetNW2String("activeOffhand"));
		
		if weaponTable then
			self.realIronSights = self.IronSights;
			self.realBlockAnim = "a_dual_swords_block";
			self.realBlockTable = GetTable(self.BlockTable);
			self.realBlockTableOffhand = GetTable(weaponTable.BlockTable or self.BlockTable);
			self.realBlockSoundTable = self.BlockSoundTable;
			self.realCriticalAnim = "a_dual_swords_slash_medium_01";
			self.realHoldType = "wos-begotten_dual";
			self.realParryAnim = "a_dual_swords_parry";
			self.realIronSightsPos = Vector(7.76, -4.824, -1.321);
			self.realIronSightsAng = Vector(0, 28.843, 8.442);
			self.ViewModel = "models/c_begotten_duals.mdl";
			self.ViewModelFOV = 70;
			self.ViewModelBoneMods = {};
			self.MultiHit = 2;
		else
			error("Weapon for dual-wielding not found for player "..self.Owner:GetName().." swep "..self:GetPrintName().." left weapon "..self:GetNW2String("activeOffhand").."!");
		end
	else
		local weaponTable = weapons.GetStored(self:GetClass());
		
		self.realIronSights = self.IronSights;
		self.realBlockAnim = self.BlockAnim or self.realBlockAnim;
		self.realBlockTable = GetTable(self.BlockTable);
		self.realBlockTableOffhand = nil;
		self.realBlockSoundTable = self.BlockSoundTable;
		self.realCriticalAnim = self.CriticalAnim;
		self.realHoldType = self.HoldType;
		self.realParryAnim = self.ParryAnim;
		self.realIronSightsPos = self.IronSightsPos;
		self.realIronSightsAng = self.IronSightsAng;
		self.ViewModel = weaponTable.ViewModel;
		self.ViewModelFOV = weaponTable.ViewModelFOV;
		self.ViewModelBoneMods = weaponTable.ViewModelBoneMods;
		self.MultiHit = weaponTable.MultiHit;
	end
	
	if self.ViewModelAlternate and self.Owner:GetNetVar("ThrustStance") then
		self.ViewModel = self.ViewModelAlternate;
	end

	self:InitFunc();
	
	if IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner:GetActiveWeapon() == self then
		local vm = self.Owner:GetViewModel();
		
		if IsValid(vm) then
			vm:SetModel(self.ViewModel);
		end
	end
	
	local blocktable = self.realBlockTable;
	local blocktableOffhand = self.realBlockTableOffhand;
	
	if blocktableOffhand then
		self.RaiseSpeed = math.max(blocktable["raisespeed"], blocktableOffhand["raisespeed"]) * 1.666;
		self.LowerSpeed =  math.max(blocktable["raisespeed"], blocktableOffhand["raisespeed"]) * 1.666;
		self.InstantRaise = (blocktable["instantraise"] and blocktableOffhand["instantraise"]);
	else
		self.RaiseSpeed = blocktable["raisespeed"];
		self.LowerSpeed = blocktable["raisespeed"];
		self.InstantRaise = blocktable["instantraise"];
	end
	
	self.RaiseSound = "cloth.wav";

	if CLIENT then
		local weaponTable = weapons.GetStored(self:GetClass());
		
		self.VElements = table.FullCopy(weaponTable.VElements);
		self.WElements = table.FullCopy(weaponTable.WElements);
		self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods);
		
		if self:GetNWString("stance") == "thrust_swing" then
			if weaponTable.VElementsAlternate then
				self.VElements = table.FullCopy(weaponTable.VElementsAlternate);
			end;
			
			if weaponTable.WElementsAlternate then
				self.WElements = table.FullCopy(weaponTable.WElementsAlternate);
			end;
			
			if weaponTable.ViewModelBoneModsAlternate then
				self.ViewModelBoneMods = table.FullCopy(weaponTable.ViewModelBoneMods);
			end
		end
	
		if !self.HasShield then
			if self:GetNW2String("activeShield"):len() > 0 then
				local shieldTable = GetTable(self:GetNW2String("activeShield"));
				
				if shieldTable then
					if shieldTable.ViewModelBoneMods then
						if !self.ViewModelBoneMods then
							self.ViewModelBoneMods = {};
						end
					
						for k, v in pairs(shieldTable.ViewModelBoneMods) do
							if k == self.ViewModel then
								if !self.OriginalViewModelBoneMods then
									self.OriginalViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods);
								end
							
								for k2, v2 in pairs(v) do
									self.ViewModelBoneMods[k2] = table.FullCopy(v2);
								end
								
								break;
							end
						end
					end
				
					if self.VElements and shieldTable.VElements then
						for k, v in pairs(shieldTable.VElements) do
							if k == self.ViewModel then
								for k2, v2 in pairs(v) do
									self.VElements[k2] = table.FullCopy(v2);
								end
								
								break;
							end
						end
					end
					
					if self.WElements and shieldTable.WElements then
						for k, v in pairs(shieldTable.WElements) do
							self.WElements[k] = table.FullCopy(v);
						end
					end
				end
			else
				if self.ViewModelBoneMods and self.OriginalViewModelBoneMods then
					for k, v in pairs(self.OriginalViewModelBoneMods) do
						self.ViewModelBoneMods = table.FullCopy(self.OriginalViewModelBoneMods);
					end
				end
			
				if self.VElements then
					for k, v in pairs(self.VElements) do
						if string.find(k, "shield") then
							self.VElements[k] = nil;
						end
					end
				end
				
				if self.WElements then
					for k, v in pairs(self.WElements) do
						if string.find(k, "shield") then
							self.WElements[k] = nil;
						end
					end
				end
			end
		end
		
		if self:GetNW2String("activeOffhand"):len() > 0 then
			local offhandTable = weapons.GetStored(self:GetNW2String("activeOffhand"));
			
			if offhandTable then
				self.VElements = {};
				self.WElements = {};
				
				if self.VElements and self.VElementsDual and offhandTable.VElements and offhandTable.VElementsDual then
					self.VElements["w_left"] = table.FullCopy(offhandTable.VElementsDual["v_left"]);
					self.VElements["w_right"] = table.FullCopy(self.VElementsDual["v_right"]);
				end
				
				if self.WElements and self.WElementsDual and offhandTable.WElements and offhandTable.WElementsDual then
					self.WElements["w_left"] = table.FullCopy(offhandTable.WElementsDual["w_left"]);
					self.WElements["w_right"] = table.FullCopy(self.WElementsDual["w_right"]);
				end
			end
		end

		if LocalPlayer() == self.Owner then
			self:CreateModels(self.VElements) // create viewmodels
		end
		
		self:CreateModels(self.WElements) // create worldmodels
		
		if self.VElements then
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
		end
		
		if self.WElements then
			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		if IsValid(self.Owner) and self.Owner:IsPlayer() and self.Owner:GetActiveWeapon() == self then
			local vm = self.Owner:GetViewModel();
			
			if IsValid(vm) then
				vm:SetModel(self.ViewModel);
				self:ResetBonePositions(vm);
			end
		end
	end
	
	self:SetHoldType(self:GetHoldtypeOverride());
end

function SWEP:Holster()
	local player = self.OwnerOverride or self.Owner;
	
	if IsValid(player) then
		timer.Remove(player:EntIndex().."IdleAnimation");

		if player:IsPlayer() then
			self:StopAllAnims(player);
		end
		
		if CLIENT then
			if player:IsPlayer() then
				local vm = player:GetViewModel()
				
				if IsValid(vm) then
					self:ResetBonePositions(vm)
					vm:SetSubMaterial( 0, "" )
					vm:SetSubMaterial( 1, "" )
					vm:SetSubMaterial( 2, "" )
				end
			end
		else
			if player:GetNetVar("ThrustStance") then
				player:SetNetVar("ThrustStance", false);
			end
			
			if player:GetNetVar("Parry") then
				player:SetLocalVar("Parry", false);
			end
			
			if player:GetNetVar("ParrySuccess") then
				player:SetLocalVar("ParrySuccess", false);
			end
			
			if player:GetNetVar("Riposting") then
				player:SetLocalVar("Riposting", false);
			end
			
			if player.parryStacks then
				player.parryStacks = nil;
			end
		end
	end
	
	if self.OnHolster then
		self:OnHolster();
	end
	
	if CLIENT then
		self:RemoveModels();
	end
	
	return true;
end

function SWEP:OnRemove()
	self:Holster();
end

function SWEP:GetHoldtypeOverride()
	return self.realHoldType or self.HoldType;
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
		self:SubMatFunc()
		
		local vm = self.Owner:GetViewModel()
		self:UpdateBonePositions(vm)
		
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end

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
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model") then
				local model = v.modelEnt
				
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
				
				local color = v.color;
				
				if color then
					rndr.SetColorModulation(color.r/255, color.g/255, color.b/255)
					rndr.SetBlend(color.a/255)
					model:DrawModel()
					rndr.SetBlend(1)
					rndr.SetColorModulation(1, 1, 1)
				else
					model:DrawModel()
				end
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(false)
				end
			elseif (v.type == "Sprite" and sprite) then
				local sprite = v.spriteMaterial
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
	
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		local wepTab = self:GetTable()
		
		if self.OnMeleeStanceChanged then
			if self:GetNWString("stance") ~= self.stance then
				self:OnMeleeStanceChanged(self:GetNWString("stance"));
				
				return;
			end
		end
		
		if self:GetNW2String("activeShield"):len() > 0 then
			if !wepTab.activeShield or wepTab.activeShield ~= self:GetNW2String("activeShield") then
				wepTab.activeShield = self:GetNW2String("activeShield");
				self:EquipShield(wepTab.activeShield);
			end
		elseif wepTab.activeShield then
			wepTab.activeShield = nil;
			self:HolsterShield();
		end
		
		if self:GetNW2String("activeOffhand"):len() > 0 then
			if !wepTab.activeOffhand or wepTab.activeOffhand ~= self:GetNW2String("activeOffhand") then
				wepTab.activeOffhand = self:GetNW2String("activeOffhand");
				self:EquipOffhand(wepTab.activeOffhand);
			end
		elseif wepTab.activeOffhand then
			wepTab.activeOffhand = nil;
			self:HolsterOffhand();
		end

		if (wepTab.ShowWorldModel ~= false) then
			self:DrawModel()
		end
		
		if (!wepTab.WElements) then return end
		
		if (!wepTab.wRenderOrder) or table.IsEmpty(wepTab.wRenderOrder) then
			wepTab.wRenderOrder = {}

			for k, v in pairs(wepTab.WElements) do
				if (v.type == "Model") then
					table.insert(wepTab.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(wepTab.wRenderOrder, k)
				end
			end
		end
		
		for k, name in pairs(wepTab.wRenderOrder) do
			local v = wepTab.WElements[name]
			
			if (!v) then wepTab.wRenderOrder = nil break end
			
			if (v.type == "Model") then
				local model = v.modelEnt
				
				if !IsValid(model) or model:GetParent() ~= self.Owner and IsValid(self.Owner) then
					self:CreateModels(wepTab.WElements);
					
					return;
				end
			
				--[[ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				model:SetAngles(ang)
				
				if v.size then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				end
				
				if (v.material and model:GetMaterial() != v.material) then
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
				end]]--
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(true)
				end
				
				local color = v.color;
				
				if color then
					rndr.SetColorModulation(color.r/255, color.g/255, color.b/255)
					rndr.SetBlend(color.a/255)
					model:DrawModel()
					rndr.SetBlend(1)
					rndr.SetColorModulation(1, 1, 1)
				else
					model:DrawModel()
				end
				
				if (v.surpresslightning) then
					rndr.SuppressEngineLighting(false)
				end
			elseif (v.type == "Sprite" and sprite) then
				local sprite = v.spriteMaterial
				local pos, ang
				
				if (v.bone) then
					pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
				else
					pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
				end
				
				if (!pos) then continue end
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				rndr.SetMaterial(sprite)
				rndr.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == "Quad" and v.draw_func) then
				local pos, ang
				
				if (v.bone) then
					pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self)
				else
					pos, ang = self:GetBoneOrientation(wepTab.WElements, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
				end
				
				if (!pos) then continue end
				
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
			
			if basetab == self.VElements then
				local m = ent:GetBoneMatrix(bone)
				
				if (m) then
					pos, ang = m:GetTranslation(), m:GetAngles();
				end
			end

			if !pos and !ang then
				pos = ent:GetPos();
				ang = ent:GetAngles();
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel()) then
				if self.ViewModelFlip then
					ang.r = -ang.r 
				end
			end
		end
		
		return pos, ang, bone;
	end

	function SWEP:CreateModels( tab )
		if (!tab) then return end
		if (!IsValid(self.Owner)) then return end

		for k, v in pairs( tab ) do
			if IsValid(v.modelEnt) then
				v.modelEnt:Remove();
			end
		
			if (v.type == "Model" and v.model and v.model != "" and !IsValid(v.modelEnt) and 
				string.find(v.model, ".mdl") and file.Exists(v.model, "GAME")) then
				
				local modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				
				if (IsValid(modelEnt)) then
					--[[modelEnt:SetPos(self:GetPos())
					modelEnt:SetAngles(self:GetAngles())
					modelEnt:SetParent(self)]]--
					modelEnt:SetNoDraw(true)
					
					local pos, ang, bone;
					
					if tab == self.VElements then
						pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner:GetViewModel())
					else
						if (v.bone) then
							pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner or self)
						else
							pos, ang, bone = self:GetBoneOrientation(tab, v, self.Owner or self, "ValveBiped.Bip01_R_Hand")
						end
					end
					
					if pos and ang and bone then
						modelEnt:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z);
						ang:RotateAroundAxis(ang:Up(), v.angle.y)
						ang:RotateAroundAxis(ang:Right(), v.angle.p)
						ang:RotateAroundAxis(ang:Forward(), v.angle.r)
						modelEnt:SetAngles(ang)
						
						if tab == self.VElements then
							--modelEnt:FollowBone(self.Owner:GetViewModel(), bone);
						else
							modelEnt:FollowBone(self.Owner, bone);
						end
						
						if v.size then
							local matrix = Matrix()
							matrix:Scale(v.size)
							modelEnt:EnableMatrix( "RenderMultiply", matrix )
						end
						
						if (v.material and modelEnt:GetMaterial() != v.material) then
							modelEnt:SetMaterial(v.material)
						end
						
						if (v.skin and v.skin != modelEnt:GetSkin()) then
							modelEnt:SetSkin(v.skin)
						end
						
						if (v.bodygroup) then
							for k, v in pairs( v.bodygroup ) do
								if (modelEnt:GetBodygroup(k) != v) then
									modelEnt:SetBodygroup(k, v)
								end
							end
						end
					end
					
					v.modelEnt = modelEnt;
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
		net.SendPVS(target:GetPos());
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
		for _, player in _player.Iterator() do
			if player:IsValid() and player:Alive() then
				local plyTab = player:GetTable();
				local setWeight = false;
			
				if !plyTab.gestureweightbegin then
					plyTab.gestureweightbegin = 0;
				end
				
				if !plyTab.gestureweightblock then
					plyTab.gestureweightblock = 0;
				end
			
				if plyTab.gestureweightbegin == 1 then
					plyTab.gestureweightbegin = 0;
					plyTab.gestureweightprogress = 1;
					
					setWeight = true;
				elseif plyTab.gestureweightbegin == 2 then
					plyTab.gestureweightbegin = 0;
					plyTab.gestureweightprogress = 2;
					
					setWeight = true;
				end
				
				if plyTab.gestureweightprogress == 1 then
					plyTab.gestureweightblock = math.Clamp(plyTab.gestureweightblock + (FrameTime() * 10), 0, 1);
					
					setWeight = true;
				elseif plyTab.gestureweightprogress == 2 then
					plyTab.gestureweightblock = math.Clamp(plyTab.gestureweightblock + ((FrameTime() * 10) * -1), 0, 1);

					setWeight = true;
				end
					
				if plyTab.gestureweightblock == 0 or plyTab.gestureweightblock == 1 then
					plyTab.gestureweightprogress = 0;
				end;

				if plyTab.gestureweightlookup and plyTab.gestureweightblock > 0 then
					player:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, plyTab.gestureweightlookup, 0, 1);
				end
					
				--print("gestureweightbegin: "..plyTab.gestureweightbegin.." gestureweightprogress: "..plyTab.gestureweightprogress.." gestureweightblock: "..plyTab.gestureweightblock);
				
				if setWeight then
					player:AnimSetGestureWeight(GESTURE_SLOT_VCD, plyTab.gestureweightblock);
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
		net.SendPVS(target:GetPos());
	end;
end;

--For flinching

if SERVER then
	util.AddNetworkString( "BegottenAnim4" )
end;

if CLIENT then
	net.Receive( "BegottenAnim4", function()
		 local target = net.ReadEntity()
		 if target:IsValid() and target:Alive() then
		 local anim = net.ReadString()
		 local lookup = target:LookupSequence(anim)
		 target:AddVCDSequenceToGestureSlot( GESTURE_SLOT_FLINCH, lookup, 0, 1 );
	end end )
end;

function SWEP:TriggerAnim4(target, anim) -- The two arguments for this function are "target" and "anim". Target is the entity we want to call the animation on, and anim being the animation itself.
	if SERVER then
		if (!target or !IsValid(target)) then
			target = self.Owner; -- Redundancy check to make sure that we don't get any errors incase "target" isn't valid.
		end;
		
		net.Start( "BegottenAnim4", true )
		net.WriteEntity( target ); -- Before, the argument here was just "self.Owner" which was always going to return the player holding the weapon, making them flinch instead of whatever "target" is.
		net.WriteString( anim );
		net.SendPVS(target:GetPos());
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
			target.gestureweightlookup = 0;

			target:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD);
			target:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM);
			target:AnimResetGestureSlot(GESTURE_SLOT_VCD);
		end 
	end);
end;

function SWEP:StopAllAnims(target)
	if SERVER then
		net.Start("BegottenAnimStop", true);
		net.WriteEntity(target);
		net.Broadcast();
	end;
end;

-- ENDS --

print ('The Undergod is watching.') 