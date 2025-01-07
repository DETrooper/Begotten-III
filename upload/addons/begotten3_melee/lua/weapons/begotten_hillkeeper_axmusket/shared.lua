SWEP.VMPos = Vector(0.5, -4, 0.5) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0, 0, 0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.

SWEP.ViewModelBoneMods = {
	["v_ee3_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.ViewModelBoneModsAlternate = {
	["RightHandPinky3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.45, 1.2, 0.349), angle = Angle(0, -58.889, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -5, 0), angle = Angle(0, 0, 0) },
	["RightHandMiddle3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.1, 0.925, 0), angle = Angle(0, 0, 0) },
	["RightHandIndex3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.925, 0), angle = Angle(0, 0, 0) },
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -30, 0) },
	["RightHandRing3_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.3, 0.55, 0.15), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["v_axmusket"] = { type = "Model", model = "models/begoyten/gunaxe/gunaxe.mdl", bone = "v_ee3_reference001", rel = "", pos = Vector(0.5, 3.5, 2), angle = Angle(0, -90, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.VElementsAlternate = {
	["v_axmusket"] = { type = "Model", model = "models/begoyten/gunaxe/gunaxe.mdl", bone = "RightHand_1stP", rel = "", pos = Vector(-3.5, -3.5, 2.5), angle = Angle(-3.5, -90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["w_axmusket"] = { type = "Model", model = "models/begoyten/gunaxe/gunaxe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 0.899, -3.3), angle = Angle(-8.183, 1.169, -97.014), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElementsAlternate = {
	["w_axmusket"] = { type = "Model", model = "models/begoyten/gunaxe/gunaxe.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.199, -0.9, 17.142), angle = Angle(-97.014, 78.311, -22.209), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Gun = ("begotten_hillkeeper_axmusket")					-- must be the name of your swep
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "Begotten"
SWEP.Author					= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.MuzzleAttachment		= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" 		-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Hillkeeper Axmusket"	-- Weapon name (Shown on HUD)	
SWEP.Slot					= 2			-- Slot in the weapon selection menu
SWEP.SlotPos				= 79		-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false		-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight					= 30		-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"	-- how others view you carrying the weapon
SWEP.HoldTypeAlternate = "wos-begotten_2h_great"

-- View Model
SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/synbf3/c_ee3.mdl"
SWEP.ViewModelAlternate 	= "models/c_begotten_pulverizer.mdl"
SWEP.WorldModel				= "models/weapons/w_airgun.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands 						= true

-- World Model
SWEP.Base					= "sword_swepbase"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater 		= false

SWEP.Primary.Sound			= Sound("weapons/cb4/cb4-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 25		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize		= 1		-- Size of a clip
SWEP.Primary.DefaultClip	= 0			-- Bullets you start with
SWEP.Primary.KickUp			= 30		-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 1			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 1			-- Maximum up recoil (stock)
SWEP.Primary.Automatic		= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg"

SWEP.Secondary.IronFOV		= 80		-- How much you 'zoom' in. Less is more! 	

SWEP.data 					= {}		-- The starting firemode
SWEP.data.ironsights		= 1

SWEP.Primary.NumShots		= 1			-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage			= 95		-- Base damage per bullet
SWEP.Primary.Spread			= .1		-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy 	= .04 		-- Ironsight accuracy, should be the same for shotguns

SWEP.SelectiveFire			= false
SWEP.MisfireChance = 5;

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-2.9, -10, 1)
SWEP.SightsAng = Vector(0, 0, -1)
SWEP.SightsPosAlternate = Vector(-10.761, 2.411, -9.961)
SWEP.SightsAngAlternate = Vector(21.106, 0, -23.921)
SWEP.RunSightsPos = Vector(-0.64, 0, -0.08)
SWEP.RunSightsAng = Vector(-10.554, 29.548, -19.698)
SWEP.BlockAnim = "a_heavy_great_block"
SWEP.CriticalAnim = "a_heavy_great_attack_slash_02"
SWEP.ParryAnim = "a_heavy_great_parry"

--For 2h viewmodel
SWEP.CriticalPlaybackRate = 0.9
SWEP.PrimaryPlaybackRate = 0.85
SWEP.PrimaryIdleDelay = 0.9
SWEP.AltPlaybackRate = nil
SWEP.AltIdleDelay = nil
SWEP.PrimarySwingAnim = "a_heavy_great_attack_slash_01"
SWEP.MultiHit = 2;

SWEP.AttackSoundTable = "HeavyMetalRangedAttackSoundTable"
SWEP.BlockSoundTable = "WoodenBlockSoundTable"
SWEP.SoundMaterial = "Metal" -- Metal, Wooden, MetalPierce, Punch, Default

SWEP.WindUpSound = "draw/skyrim_axe_draw1.mp3" --For 2h weapons only, plays before primarysound

/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
SWEP.AttackTable = "GunAxeAttackTable"
SWEP.BlockTable = "GunAxeBlockTable"
SWEP.isMeleeFirearm = true;

SWEP.AmmoTypes = {
	["Longshot"] = function(SWEP)
		SWEP.Primary.Sound = Sound("weapons/cb4/cb4-1.wav");
		SWEP.Primary.NumShots = 1;
		SWEP.Primary.Damage = 95;
		SWEP.Primary.Spread = .1;
		SWEP.Primary.IronAccuracy = .04;
		SWEP.Primary.Ammo = "smg";
		
		if SWEP.Owner and SWEP.Owner:IsPlayer() then
			if SWEP.Owner:GetVelocity() == Vector(0, 0, 0) then
				if SWEP.Owner.HasBelief and SWEP.Owner:HasBelief("marksman") then
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .03;
						SWEP.Primary.IronAccuracy = .015;
					else
						SWEP.Primary.Spread = .04;
						SWEP.Primary.IronAccuracy = .025;
					end
				else
					if SWEP.Owner:Crouching() then
						SWEP.Primary.Spread = .04;
						SWEP.Primary.IronAccuracy = .025;
					else
						SWEP.Primary.Spread = .045;
						SWEP.Primary.IronAccuracy = .03;
					end
				end
			end
		end
		
		return true;
	end,
};

function SWEP:AdjustFireBegotten()
	if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				local ammoType = ammo[1];
				
				if self.AmmoTypes[ammoType] then
					if !self.notPowder then
						local forceJam = false;
					
						--[[
						if cwRituals then
							local ownerPos = self.Owner:GetPos();
							
							for _, v in _player.Iterator() do
								if v:GetNetVar("powderheelActive") then
									if v:GetPos():Distance(ownerPos) <= config.Get("talk_radius"):Get() then
										forceJam = true;
										
										break;
									end
								end
							end
						end
						--]]
					
						if !self.noJam or forceJam then
							local hasPistolier = cwBeliefs and self.Owner.HasBelief and self.Owner:HasBelief("pistolier");
							local hasFavored = self.Owner:GetNetVar("favored");
							local hasMarked = self.Owner:GetNetVar("marked");
							
							local misfireChance = self.MisfireChance;
							local itemCondition = itemTable:GetCondition();

							if itemCondition < 90 then
								misfireChance = misfireChance + math.Round(((100 - itemCondition) / 5));
							end
							
							if hasPistolier then
								misfireChance = math.Round(misfireChance / 5);
							end
							
							if hasFavored then
								misfireChance = math.Round(misfireChance / 2);
							end
							
							if hasMarked then
								misfireChance = math.Round(misfireChance * 1.5);
							end
						
							--if math.random(1, 100) <= misfireChance then
							if forceJam or util.SharedRandom("misfire_"..self.Owner:EntIndex(), 1, 100) <= misfireChance then -- acceptable risk of people being able to hack this on the client
								self:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
								
								-- 10% chance on misfire for the gun to fucking explode.
								if !hasPistolier and !forceJam and ((!hasMarked and math.random(1, 100) <= 10) or (hasMarked and math.random(1, 100) <= 20)) then
									if SERVER then
										local position = self.Owner:GetPos();
										
										Clockwork.chatBox:AddInTargetRadius(self.Owner, "me", "pulls the trigger on their "..self.PrintName.." and it suddenly explodes!", position, config.Get("talk_radius"):Get() * 2);
										
										Schema:EasyText(Schema:GetAdmins(), "icon16/bomb.png", "tomato", self.Owner:Name().."'s "..self.PrintName.." exploded!");
									
										local effectData = EffectData();
										effectData:SetStart(position);
										effectData:SetOrigin(position);
										effectData:SetScale(256);
										effectData:SetRadius(256);
										effectData:SetMagnitude(50);

										util.Effect("Explosion", effectData, true, true);
										util.BlastDamage(self, self, position, 8, 75);
									end
									
									if itemTable.TakeCondition then
										itemTable:Break();
									end
								else
									if SERVER then
										self.Owner:EmitSound("vj_weapons/dryfire_revolver.wav");
										
										if forceJam then
											Clockwork.chatBox:Add(self.Owner, nil, "it", "Some magical force prevents your firearm from firing, jamming it in the process!")
										else
											Clockwork.chatBox:Add(self.Owner, nil, "it", "Your firearm was loaded with a dud round and misfires!")
										end
									end
									
									self:SetNextPrimaryFire(CurTime() + 2);
								end
							
								return false;
							end
						end
					end
					
					self.AmmoTypes[ammoType](self); -- Execute the function that modifies the weapon behavior based on ammo type.
					return true;
				else
					-- Shouldn't really be possible but maybe we can do something with this later like making it explode the weapon.
					printp("Invalid ammo loaded!");
					return false;
				end
			end
		end
	end
end

function SWEP:CanFireBegotten()
	if Clockwork then
		if Schema and (Schema.towerSafeZoneEnabled) then
			if self.Owner.GetFaction and self.Owner.InTower and self.Owner:InTower() and not self.Owner:IsAdmin() then
				local faction = self.Owner:GetFaction();
			
				if faction ~= "Gatekeeper" and faction ~= "Holy Hierarchy" and faction ~= "Pope Adyssa's Gatekeepers" and faction ~= "Hillkeeper" then
					if SERVER then
						Clockwork.player:Notify(self.Owner, "You cannot attack in this holy place!");
					end
					
					return false;
				end
			end
		end
	
		if self.Owner:GetNW2Bool("Cloaked", false) == true then
			return false;
		end
	
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				return true;
			else
				return false;
			end
		end
	end
	
	return true;
end

function SWEP:TakeAmmoBegotten(amount)
	if Clockwork then
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local ammo = itemTable:GetData("Ammo");
			local magazine;
			
			if itemTable.usesMagazine then
				if ammo and #ammo > 0 then
					local round = ammo[1];
					
					if string.find(round, "Magazine") then
						magazine = round;
					end
				end
			end
			
			if ammo and #ammo > amount then
				for i = 1, amount do
					table.remove(ammo, amount - (i - 1));
				end
			else
				ammo = {};
			end
			
			if SERVER then
				if table.IsEmpty(ammo) and magazine then
					if IsValid(self.Owner) and self.Owner:IsPlayer() then
						local magazineItemID = string.gsub(string.lower(magazine), " ", "_");
						local magazineItem = item.CreateInstance(magazineItemID);
						
						if magazineItem and magazineItem.SetAmmoMagazine then
							magazineItem:SetAmmoMagazine(0);
							
							self.Owner:GiveItem(magazineItem);
						end
					end
				end
			end
			
			if itemTable.SetData then
				itemTable:SetData("Ammo", ammo);
			end
			
			-- Also handle weapon item condition here.
			if itemTable.TakeCondition then
				local conditionLoss = math.max((((1000 - self.Primary.RPM) / 1000) * amount), 0.5);
				
				if !itemTable.unrepairable then
					if IsValid(self.Owner) and self.Owner:IsPlayer() then
						if self.Owner.HasBelief then
							if self.Owner:HasBelief("ingenuity_finisher") then
								return;
							elseif self.Owner:HasBelief("scour_the_rust") then
								conditionLoss = conditionLoss / 2;
							end
						end
					end
				end
				
				itemTable:TakeCondition(conditionLoss);
			end
		end
	end
end

function SWEP:PrimaryAttack()
	local curTime = CurTime();

	if not IsValid(self) or not IsValid(self.Weapon) or not IsValid(self.Owner) then 
		return;
	end
	
	if self.Owner:GetNetVar("ThrustStance") then
		local wep = self.Weapon;
		local owner = self.Owner;
		
		if (!self:CanPrimaryAttack()) then 
			return true;
		end
		
		if owner:GetNetVar("Guardening") == true then 
			return true;
		end
		
		local attacktable = GetTable(self.AttackTable);
		
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

		if cwBeliefs and owner.HasBelief and owner:HasBelief("flamboyance") then
			delay = delay * 0.9;
		end

		if CLIENT then
			hook.Run("PlayerAttacks", owner);
		end
		
		local bAttack = true;
		local bParry = owner:GetNetVar("ParrySuccess");

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
			if self.HandleThrustAttack and owner:GetNetVar("ThrustStance") == true and !owner:GetNetVar("Riposting") then
				if self:HandleThrustAttack() ~= false then bAttack = true end;
			else
				if self:HandlePrimaryAttack() ~= false then bAttack = true end;
			end
		end
		
		if SERVER and bAttack and self:IsValid() and (!owner.IsRagdolled or !owner:IsRagdolled()) and owner:Alive() then 
			owner:SetLocalVar("MelAttacking", true )
			
			self.HolsterDelay = (curTime + strikeTime)
			self.isAttacking = true;
				
			self:CreateTimer(strikeTime + 0.1, "strikeTimer"..owner:EntIndex(), function()
				if IsValid(self) and IsValid(owner) then
					if self.isAttacking then -- This can be set to false elsewhere and will abort the attack.
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
								
								if !bParry and (stance == "thrust_swing") then
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
												end
											end
										
											if #hitEntities >= hitsAllowed then
												break;
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
												local blockTable = GetTable(activeWeapon.realBlockTable);
												
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
													if owner:GetNetVar("ThrustStance") and (owner:GetNWInt("Stamina", 100) >= blockTable["guardblockamount"] and !owner:GetNetVar("Parried")) then
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
	else
		if IsFirstTimePredicted() then
			if self.Owner:IsPlayer() and self:CanFireBegotten() then
				if !self.Owner:KeyDown(IN_SPEED) then
					if !self:AdjustFireBegotten() then
						return;
					end
					
					self:ShootBulletInformation();
					self.Weapon:TakeAmmoBegotten(1); -- This should really only ever be 1 unless for some reason we have burst-fire guns or some shit, especially since we have different ammo types.
					--self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
					
					if SERVER then
						local filter = RecipientFilter();
						
						if zones then
							filter:AddPlayers(zones:GetPlayersInSupraZone(zones:GetPlayerSupraZone(self.Owner)));
						else
							filter:AddAllPlayers();
						end
						
						self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0, filter);
					else
						self.Weapon:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 511, math.random(98, 102), 1, CHAN_WEAPON, 0, 0);
					end

					local effect = EffectData();
					local Forward = self.Owner:GetForward()
					local Right = self.Owner:GetRight()
					
					effect:SetOrigin(self.Owner:GetShootPos() + (Forward * 65) + (Right * 5));
					effect:SetNormal( self.Owner:GetAimVector());
					util.Effect( "effect_awoi_smoke", effect );

					self.Owner:SetAnimation( PLAYER_ATTACK1 )
					self.Owner:MuzzleFlash()
					self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
					
					if self.BoltAction then 
						self:BoltBack() 
					end
					
					if SERVER then
						self.Owner.cloakCooldown = CurTime() + 30;
					end
				end
			end
		elseif self:CanPrimaryAttack() and self.Owner:IsNPC() then
			self:ShootBulletInformation()
			self.Weapon:TakePrimaryAmmo(1)
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Weapon:EmitSound(self.Primary.Sound)
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			self.Owner:MuzzleFlash()
			self.Weapon:SetNextPrimaryFire(curTime + 1 / (self.Primary.RPM / 60))
		end
	end
end

function SWEP:CanSecondaryAttack()
	if self.Owner:GetNetVar("ThrustStance") then
		return true
	end
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end

	local LoweredParryDebug = self:GetNextSecondaryFire()
	local ParryDelay = self:GetNextPrimaryFire()
	local attacktable = GetTable(self.AttackTable);
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local blocktable = GetTable(self.realBlockTable);
	local ply = self.Owner;
	
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
									if ply:GetNetVar("ThrustStance") and (ply:GetNWInt("Stamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
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
									if ply:GetNetVar("ThrustStance") and (ply:GetNWInt("Stamina", 100) >= guardblockamount and !ply:GetNetVar("Parried")) then
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

function SWEP:CriticalAnimation()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	self.Weapon:EmitSound(self.WindUpSound)

	-- Viewmodel attack animation!
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_f" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self:IdleAnimationDelay( 1, 1 )
	
	if (SERVER) then
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["criticalswing"][math.random(1, #attacksoundtable["criticalswing"])])
	end end)
	self.Owner:ViewPunch(Angle(10,1,1))
	end
	
end

function SWEP:ParryAnimation()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "brace_out" ) )
	self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:ViewPunch(Angle(-30,0,0))
	self:IdleAnimationDelay( 1.5, 1.5 )
end

function SWEP:HandlePrimaryAttack()

	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	local attacktable = GetTable(self.AttackTable)

	--Attack animation
	self:TriggerAnim(self.Owner, self.PrimarySwingAnim);

	-- Viewmodel attack animation!
	self.Weapon:EmitSound(self.WindUpSound)
	timer.Simple( attacktable["striketime"] - 0.05, function() if self:IsValid() and self.isAttacking then
	self.Weapon:EmitSound(attacksoundtable["primarysound"][math.random(1, #attacksoundtable["primarysound"])])
	end end)
    
    if (SERVER) then
		local ani = math.random( 1, 2 )
		if ani == 1 and self:IsValid() then
			self.Owner:ViewPunch(Angle(0,6,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_l" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )

		elseif ani == 2  and self:IsValid() then
			self.Owner:ViewPunch(Angle(6,0,0))
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "atk_r" ) )
			self.Owner:GetViewModel():SetPlaybackRate(self.PrimaryPlaybackRate)
			self:IdleAnimationDelay( self.PrimaryIdleDelay, self.PrimaryIdleDelay )
		end
	end
end

function SWEP:IronSight()
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	
	if !self.Owner:IsWeaponRaised(self) then
		return;
	end

	if !self.Owner:IsNPC() then
		if self.ResetSights and CurTime() >= self.ResetSights then
			self.ResetSights = nil
		end
	end
	
	if self.Owner:GetNetVar("ThrustStance") then
		self.Owner:SetFOV(0, 0.5);
		self.realIronSightsPos = self.SightsPosAlternate;
		self.realIronSightsAng = self.SightsAngAlternate;
	
		return;
	end
	
	local bIron = self:GetIronsights();
   
	if self.Owner:KeyPressed(IN_SPEED) --[[and not (self.Weapon:GetNWBool("Reloading"))]] then
		if self.Weapon:GetNextPrimaryFire() <= (CurTime()+0.3) then
			self.Weapon:SetNextPrimaryFire(CurTime()+0.3)                           -- Make it so you can't shoot for another quarter second
		end
		
		self.realIronSightsPos = self.RunSightsPos                                  -- Hold it down
		self.realIronSightsAng = self.RunSightsAng                                  -- Hold it down
		self:SetIronsights(true, self.Owner)                                    -- Set the ironsight true
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = false
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end
	end                                                            
 
	if self.Owner:KeyReleased(IN_SPEED) then
		self:SetIronsights(false, self.Owner)                        -- Set the ironsight true
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = self.OrigCrossHair
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end
	end

	if !self.Owner:KeyDown(IN_SPEED) then
		if self.Owner:KeyPressed(IN_ATTACK2) --[[and not (self.Weapon:GetNWBool("Reloading"))]] then
			self.Owner:SetFOV(self.Secondary.IronFOV, 0.5);
			self.realIronSightsPos = self.SightsPos                                     -- Bring it up
			self.realIronSightsAng = self.SightsAng                                     -- Bring it up
			self:SetIronsights(true, self.Owner)
			self.DrawCrosshair = false
			
			if CLIENT then return end
			
			if self.Secondary.ScopeZoom then
				self.Owner:DrawViewModel(false)
			end

			return
		end
	end

	if self.Owner:KeyReleased(IN_ATTACK2) and !self.Owner:KeyDown(IN_SPEED) then
		self.Owner:SetFOV(0, 0.5);
		self.DrawCrosshair = self.OrigCrossHair
		self:SetIronsights(false, self.Owner)
		
		if CLIENT then return end
		
		if self.Secondary.ScopeZoom then
			self.Owner:DrawViewModel(true)
		end

		return
	end
	
	if self.Owner:KeyDown(IN_ATTACK2) and !self.Owner:KeyDown(IN_SPEED) then
		self.SwayScale  = 0.05
		self.BobScale   = 0.05
	else
		self.SwayScale  = 1.0
		self.BobScale   = 1.0
	end
end

function SWEP:AdjustMouseSensitivity()
	if self.Owner:GetNetVar("ThrustStance") then
		if self.Owner:GetNetVar("Guardening") == true then
			return 0.5
		end
	else
		if self:GetIronsights() and !self.Owner:KeyDown(IN_SPEED) then
			return 0.25;
		end
	end
end

function SWEP:OnDeploy()
	local attacksoundtable = GetSoundTable(self.AttackSoundTable)
	self.Owner:ViewPunch(Angle(5,25,5))
	self:IdleAnimationDelay( 3, 3 )
	if !self.Owner.cwObserverMode then self.Weapon:EmitSound(attacksoundtable["drawsound"][math.random(1, #attacksoundtable["drawsound"])]) end;
end

function SWEP:Deploy()
	if SERVER then
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			self.Weapon:CallOnClient("Initialize");
		end

		if self.OnMeleeStanceChanged then
			self:OnMeleeStanceChanged("reg_swing");
		end
	end

	if not self.Owner.cwWakingUp and not self.Owner.LoadingText then
		self:OnDeploy()
	end

	self.canDeflect = true;
	self.Owner.gestureweightbegin = 1;
	self.Owner:SetLocalVar("CanBlock", true)
	self.Owner:SetNetVar("ThrustStance", false)
	self.Owner:SetLocalVar("ParrySuccess", false) 
	self.Owner:SetLocalVar("Riposting", false)
	self.Owner:SetLocalVar("MelAttacking", false ) -- This should fix the bug where you can't block until attacking.

	self:SetIronsights(false, self.Owner)
	self:SetNextPrimaryFire(0)
	self:SetNextSecondaryFire(0)
	self:SetHoldType( self.HoldType )	
	self.Primary.Cone = self.DefaultCone
	--self.Weapon:SetNWInt("Reloading", CurTime() + self:SequenceDuration() )
	self.isAttacking = false;
	
	if !self.Owner:IsNPC() and self.Owner != nil then
		if self.ResetSights and self.Owner:GetViewModel() != nil then
			self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
		end
	end
	
	return true
end

function SWEP:OnHolster()
	if IsValid(self.Owner) and self.Owner:IsPlayer() then
		if CLIENT then
			local vm = self.Owner:GetViewModel()
			
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		else
			self.Owner:SetFOV(0, 0.5);
		end
	end
end

function SWEP:PostThink()
	if SERVER then
		local curTime = CurTime();
		local player = self.Owner;
		
		if !self.notPowder and (!self.waterCheck or self.waterCheck <= curTime) then
			self.waterCheck = curTime + 0.5;
			
			if IsValid(player) and player:IsPlayer() then
				if self.Owner:WaterLevel() >= 3 then
					if !self.Owner.cwObserverMode then
						if Clockwork then
							local itemTable = item.GetByWeapon(self);
							
							if itemTable then
								local ammo = itemTable:GetData("Ammo");
								
								if ammo and #ammo > 0 and !itemTable.usesMagazine then
									itemTable:SetData("Ammo", {});
									
									Clockwork.player:Notify(self.Owner, "Your weapon fills with water and your powder charge is ruined!");
								end
							end
						end
					end
				end
			end
		end
	end
	
	self:IronSight();
end

function SWEP:SetIronsights(b)
	self.Weapon:SetNWBool("M9K_Ironsights", b)
end
 
function SWEP:GetIronsights()
	return self.Weapon:GetNWBool("M9K_Ironsights")
end

local TracerName = "Tracer"
 
function SWEP:ShootBulletInformation()
	local CurrentDamage
	local CurrentRecoil
	local CurrentCone
	local basedamage
   
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		CurrentCone = self.Primary.IronAccuracy
	else
		CurrentCone = self.Primary.Spread
	end
	
	if Clockwork and IsValid(self.Owner) then
		local stamina = self.Owner:GetNWInt("Stamina", 100);
		
		if stamina < 50 then
			CurrentCone = CurrentCone + (CurrentCone - (CurrentCone * (0.01 * (stamina * 2))));
		end
		
		local itemTable = item.GetByWeapon(self);
		
		if itemTable then
			local itemCondition = itemTable:GetCondition();

			if itemCondition and itemCondition < 100 then
				CurrentCone = CurrentCone * Lerp(itemCondition / 90, 1.5, 1);
			end
		end
	end
	
	--local damagedice = math.Rand(.85,1.3)
   
	--basedamage = self.Primary.Damage
	--CurrentDamage = basedamage * damagedice
	CurrentDamage = self.Primary.Damage;
	CurrentRecoil = self.Primary.Recoil
   
	if (self:GetIronsights() == true) and self.Owner:KeyDown(IN_ATTACK2) then
		self:ShootBullet(CurrentDamage, CurrentRecoil / 6, self.Primary.NumShots, CurrentCone)
	else
		if IsValid(self) then
			if IsValid(self.Weapon) then
				if IsValid(self.Owner) then
					self:ShootBullet(CurrentDamage, CurrentRecoil, self.Primary.NumShots, CurrentCone)
				end
			end
		end	
	end
end
 
/*---------------------------------------------------------
   Name: SWEP:ShootBullet()
   Desc: A convenience func to shoot bullets.
-----------------------------------------------------*/
local TracerName = "Tracer"
 
function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)
 
		num_bullets             = num_bullets or 1
		aimcone                         = aimcone or 0
 
		self:ShootEffects()
 
		if self.Tracer == 1 then
				TracerName = "Ar2Tracer"
		elseif self.Tracer == 2 then
				TracerName = "AirboatGunHeavyTracer"
		else
				TracerName = "Tracer"
		end
	   
		local bullet = {}
		bullet.Num              = num_bullets
		bullet.Src              = self.Owner:GetShootPos()                      -- Source
		bullet.Dir              = self.Owner:GetAimVector()                     -- Dir of bullet
		bullet.Spread   = Vector(aimcone, aimcone, 0)                   -- Aim Cone
		bullet.Tracer   = 3                                                     -- Show a tracer on every x bullets
		bullet.TracerName = TracerName
		bullet.Force    = damage * 0.25                                 -- Amount of force to give to phys objects
		bullet.Damage   = damage
		bullet.Callback = function(attacker, tracedata, dmginfo)
			dmginfo:SetInflictor(self);
		end
						  
		if self.Primary.Ammo == "buckshot" then
			bullet.AmmoType = "Buckshot";
		else
			bullet.AmmoType = "SMG1";
		end
		
		if IsValid(self) then
			if IsValid(self.Weapon) then
				if IsValid(self.Owner) then
					self.Owner:FireBullets(bullet)
				end
			end
		end

		local angle = Angle(-self.Primary.KickUp, 0, 0);

		self.Owner:ViewPunch(angle);
		
		-- This is ghetto as fuck rofl.
		timer.Simple(0.15, function()
			if IsValid(self) and IsValid(self.Owner) then
				local eyes = self.Owner:EyeAngles();
			
				eyes.pitch = eyes.pitch - self.Primary.KickUp;

				self.Owner:SetEyeAngles(eyes);
			end
		end);
end

function SWEP:IdleAnimationDelay( seconds, index )
	timer.Remove( self.Owner:EntIndex().."IdleAnimation" )
	self.Idling = index
	timer.Create( self.Owner:EntIndex().."IdleAnimation", seconds, 1, function()
		if not self:IsValid() or self.Idling == 0 then return end
		if self.Idling == index then
			local vm = self.Owner:GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) )
			self.Owner:GetViewModel():SetPlaybackRate(1)
		end
	end )
end

local IRONSIGHT_TIME = 0.3
-- //Time to enter in the ironsight mod

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
 
function SWEP:GetViewModelPosition(pos, ang)
	if (not self.realIronSightsPos) then return pos, ang end
	
	local bIron = self.Weapon:GetNWBool("M9K_Ironsights")

	if self.Owner:GetNetVar("ThrustStance") then
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
		
		breath = (math.sin(CurTime())/(2)) * MulB 

				pos = pos + ModX
				pos = pos + ModY + (EyeAngles():Up() * (breath) )
				pos = pos + ModZ
				
				ang = ang 
				
			ang:RotateAroundAxis( ang:Right(), (math.sin(CurTime()/2)) * MulI )
			ang:RotateAroundAxis( ang:Up(), (math.sin(CurTime()/2)) * MulI )
			ang:RotateAroundAxis( ang:Forward(), (math.sin(CurTime()/2)) * MulI )

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
			
			angles:RotateAroundAxis( angles:Right(), (math.sin(CurTime()*2)/19) * (MulBI) )
			angles:RotateAroundAxis( angles:Up(), (math.sin(CurTime()/2)/19) * (MulBI) )
			
			ply:SetEyeAngles( ply:EyeAngles()+( (angles*Mul) * self.SightBreathMul ) )	
		end
	else
		if (bIron != self.bLastIron) then
				self.bLastIron = bIron
				self.fIronTime = CurTime()

		end

		local fIronTime = self.fIronTime or 0

		if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
				return pos, ang
		end

		local Mul = 1.0

		if (fIronTime > CurTime() - IRONSIGHT_TIME) then
				Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

				if not bIron then Mul = 1 - Mul end
		end

		local Offset    = self.realIronSightsPos

		if (self.realIronSightsAng) then
				ang = ang * 1
				ang:RotateAroundAxis(ang:Right(),               self.realIronSightsAng.x * Mul)
				ang:RotateAroundAxis(ang:Up(),          self.realIronSightsAng.y * Mul)
				ang:RotateAroundAxis(ang:Forward(),     self.realIronSightsAng.z * Mul)
		end

		local Right     = ang:Right()
		local Up                = ang:Up()
		local Forward   = ang:Forward()

		pos = pos + Offset.x * Right * Mul
		pos = pos + Offset.y * Forward * Mul
		pos = pos + Offset.z * Up * Mul
	end
	
	return pos, ang
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
		self.Owner:EmitSound("weapons/ageofchivalry/flailshield/flailshield_block.wav", 60)
	end

	self:SetHoldType(self:GetHoldtypeOverride());
	self:Initialize();
end