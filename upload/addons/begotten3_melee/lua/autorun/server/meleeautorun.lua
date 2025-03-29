function Parry(parrier, dmginfo)
	if (parrier:IsPlayer() and parrier:Alive() and !parrier:IsRagdolled() and parrier:GetNetVar("Parry", false) and parrier ~= dmginfo:GetAttacker()) then
		local wep = parrier:GetActiveWeapon()

		if IsValid(wep) then
			local damageType = dmginfo:GetDamageType();
			local checkTypes = {[4] = true, [16] = true, [128] = true};

			if (checkTypes[damageType]) then
				local inflictor = dmginfo:GetInflictor();
				
				if IsValid(inflictor) and inflictor.unblockable then
					return;
				end
				
				local curTime = CurTime();
				
				dmginfo:SetDamage(0);
				wep:SetNextPrimaryFire(curTime + 0.7);
				netstream.Start(parrier, "Parried", 0.2)
				
				-- Stamina should start regenerating upon successful parry after 0.5 seconds.
				parrier.blockStaminaRegen = math.min(parrier.blockStaminaRegen or 0, curTime + 0.5);
				
				if (wep.realBlockSoundTable) then
					local blocksoundtable = GetSoundTable(wep.realBlockSoundTable)
					
					parrier:EmitSound(blocksoundtable["blocksound"][math.random(1, #blocksoundtable["blocksound"])])
				end;
				
				local parryTarget = dmginfo:GetAttacker()
				local blocktable = GetTable(wep.realBlockTable);
				local isJavelin = IsValid(inflictor) and inflictor.isJavelin and !inflictor:IsWeapon();

				if cwBeliefs and parrier:HasBelief("repulsive_riposte") then
					parrier.parryStacks = (parrier.parryStacks or 0) + 1;

					if wep.Timers and wep.Timers["parryTimer"..tostring(parrier:EntIndex())] then
						wep.Timers["parryTimer"..tostring(parrier:EntIndex())].duration = wep.Timers["parryTimer"..tostring(parrier:EntIndex())].duration + 0.3;
					end
				end
				
				if parrier.parryStacks and parrier.parryStacks > 1 then
					parrier:EmitSound("meleesounds/DS2Parry.mp3", 100, 90 + math.min(255, 90 + (parrier.parryStacks * 10)))
				else
					parrier:EmitSound("meleesounds/DS2Parry.mp3")
				end

				-- Refund half the stamina cost of parrying upon a successful parry.
				--[[local max_poise = parrier:GetNetVar("maxMeleeStamina");
				
				parrier:SetNWInt("meleeStamina", math.Clamp(parrier:GetNWInt("meleeStamina") + math.Round(blocktable["parrytakestamina"] / 2), 0, max_poise));]]--
				
				local max_stamina = parrier:GetMaxStamina();
				
				parrier:SetStamina(math.min(max_stamina, parrier:GetNWInt("Stamina") + (math.Round(blocktable["parrytakestamina"] / 2) * (parrier.parryStacks or 1))));

				if !isJavelin then
					local index = parrier:EntIndex();
					
					if (timer.Exists(index.."_ParrySuccessTimer")) then 
						timer.Destroy(index.."_ParrySuccessTimer")
					end
					
					local delay = 2.5;
					
					if wep.AttackTable then
						local attackTable;
						
						if wep:GetNW2String("activeOffhand"):len() > 0 then
							local offhandTable = weapons.GetStored(wep:GetNW2String("activeOffhand"));
							
							if offhandTable then
								attackTable = GetDualTable(wep.AttackTable, offhandTable.AttackTable);
							else
								attackTable = GetTable(wep.AttackTable);
							end
						else
							attackTable = GetTable(wep.AttackTable);
						end
						
						if attackTable then
							delay = (attackTable["delay"] + 1.5);
						end
					end
					
					parrier:SetLocalVar("ParrySuccess", true)
					parrier.parryTarget = parryTarget;
					
					if IsValid(parryTarget) then
						parryTarget:SetLocalVar("Parried", true)

						timer.Create(tostring(index).."_ParriedTimer", delay, 1, function()
							if IsValid(parryTarget) then
								parryTarget:SetLocalVar("Parried", false);
								
								if parryTarget:IsPlayer() then
									hook.Run("RunModifyPlayerSpeed", parryTarget, parryTarget.cwInfoTable, true);
								end
							end
						end);
					
						if parryTarget:IsPlayer() then
							local parryTargetWeapon = parryTarget:GetActiveWeapon();
							
							if IsValid(parryTargetWeapon) then
								if cwBeliefs and parryTarget.HasBelief and parryTarget:HasBelief("encore") then
									parryTargetWeapon:SetNextPrimaryFire(curTime + 1.5)
									parryTargetWeapon:SetNextSecondaryFire(curTime + 1.5)
								else
									parryTargetWeapon:SetNextPrimaryFire(curTime + 3)
									parryTargetWeapon:SetNextSecondaryFire(curTime + 3)
								end
								
								-- Make sure offhand swing is aborted if deflected.
								if parryTargetWeapon.Timers then
									if parryTargetWeapon.Timers["strikeTimer"..tostring(parryTarget:EntIndex())] then
										parryTargetWeapon.Timers["strikeTimer"..tostring(parryTarget:EntIndex())] = nil;
									end
								
									if parryTargetWeapon.Timers["offhandStrikeTimer"..tostring(parryTarget:EntIndex())] then
										parryTargetWeapon.Timers["offhandStrikeTimer"..tostring(parryTarget:EntIndex())] = nil;
									end
									
									parryTargetWeapon.isAttacking = false;
								end
								
								if wep:GetClass() == "begotten_fists" then
									Clockwork.chatBox:AddInTargetRadius(parrier, "me", "parries "..parryTarget:Name().." with their bare hands!", parrier:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
								end
							end
							
							-- Make it so they can't regenerate poise while parried.
							parryTarget.blockStaminaRegen = curTime + delay + 1.5;
							
							parryTarget:SetNetVar("runningDisabled", true);
							
							timer.Create("GroundedSprintTimer_"..tostring(parryTarget:EntIndex()), 3, 1, function()
								if IsValid(parryTarget) then
									parryTarget:SetNetVar("runningDisabled", nil);
								end
							end);
						
							netstream.Start(parryTarget, "Stunned", (parryTarget:HasBelief("encore") and 0.5 or 1));
						end
						
						if parryTarget.CancelGuardening then
							parryTarget:CancelGuardening();
						end
						
						if parryTarget.OnParried then
							parryTarget:OnParried();
						end
					end

					if wep.hasSwordplay and (!cwBeliefs or parrier:HasBelief("blademaster")) then
						wep:SetNW2Bool("swordplayActive", true);
						
						-- 0.7 is weapon fire delay.
						wep:CreateTimer(0.5 + 0.7, "swordplayTimer"..wep:EntIndex(), function()
							if IsValid(wep) then
								wep:SetNW2Bool("swordplayActive", false);
							end
						end);
					end
					
					timer.Create(index.."_ParrySuccessTimer", delay, 1, function()
						if (parrier:IsValid()) then
							parrier:SetLocalVar("ParrySuccess", false) 
							parrier.parryTarget = nil;
						end
					end);
				end
			end
		end
	end
end	
hook.Add("PreEntityTakeDamage", "Parrying", Parry)
	
local function Guarding(ent, dmginfo)
	if dmginfo:IsDamageType(DMG_DROWNRECOVER) then
		return;
	end;
	
	local inflictor = dmginfo:GetInflictor();
	
	if IsValid(inflictor) and inflictor.unblockable then
		return;
	end
	
	local isJavelin = IsValid(inflictor) and inflictor.isJavelin and !inflictor:IsWeapon();
	
	if !ent.GetActiveWeapon or !IsValid(ent:GetActiveWeapon()) then
		if ent:IsNPC() or ent:IsNextBot() then
			local attacker = dmginfo:GetAttacker()
			
			if IsValid(attacker) and attacker:IsPlayer() then
				if not attacker.opponent then
					local enemywep = attacker:GetActiveWeapon();
					
					if IsValid(enemywep) and enemywep.IsABegottenMelee then
						local weaponItemTable = item.GetByWeapon(enemywep);
						
						if weaponItemTable then
							if (!cwBeliefs or !attacker:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
								local conditionLoss;

								
								if cwBeliefs and attacker:HasBelief("scour_the_rust") then
									conditionLoss = dmginfo:GetDamage() / 155;
								else
									conditionLoss = dmginfo:GetDamage() / 100;
								end
								
								if enemywep.isJavelin and attacker:GetNetVar("ThrustStance") then
									conditionLoss = conditionLoss * 40;
								end
								
								weaponItemTable:TakeCondition(math.min(conditionLoss, 100));

								local enemyoffhand = enemywep:GetNW2String("activeOffhand");
								
								if enemyoffhand:len() > 0 then
									for k, v in pairs(attacker.equipmentSlots) do
										if v:IsTheSameAs(weaponItemTable) then
											local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
											
											if offhandItemTable then
												offhandItemTable:TakeCondition(math.min(conditionLoss, 100));
											end
										
											break;
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
		return;
	end;
	
	local bIsPlayer = ent:IsPlayer();

	if (bIsPlayer and ent:Alive()) or (ent:IsNextBot() or ent:IsNPC()) and ent.GetActiveWeapon then
		local wep = ent:GetActiveWeapon()
		--local attacksoundtable = GetSoundTable(wep.AttackSoundTable)
		--local attacktable = GetTable(wep.AttackTable)
		local attacker = dmginfo:GetAttacker()
		--local max_poise = ent:GetNetVar("maxMeleeStamina") or 90;
		local conditionDamage = dmginfo:GetDamage();
		
		if inflictor:IsValid() and inflictor:IsWeapon() and inflictor.IsABegottenMelee and inflictor.AttackTable then
			local inflictorAttackTable = GetTable(inflictor.AttackTable);
			
			if inflictorAttackTable then
				if IsValid(attacker) and attacker.GetNetVar and attacker:GetNetVar("ThrustStance") then
					conditionDamage = (conditionDamage + (inflictorAttackTable.poisedamage or attacker.StaminaDamage or 0) * (inflictorAttackTable.altattackpoisedamagemodifier or 1)) / 2;
				else
					conditionDamage = (conditionDamage + (inflictorAttackTable.poisedamage or attacker.StaminaDamage or 0)) / 2;
				end
			end
		elseif attacker:IsValid() and attacker.StaminaDamage then
			conditionDamage = (conditionDamage + attacker.StaminaDamage) / 2;
		end

		local enemywep;
		if attacker:IsPlayer() or attacker:IsNPC() or attacker.GetActiveWeapon then
			enemywep = inflictor or attacker:GetActiveWeapon()
		end
		
		local enemyattacktable = {}
		if enemywep and (enemywep.AttackTable) then
			enemyattacktable = GetTable(enemywep.AttackTable)
		end

		if IsValid(wep) and (ent:GetNetVar("Guardening") or (ent.IsBlocking and ent:IsBlocking())) then
			local blocktable;
			local soundtable;
			
			if ent.BlockTable then
				blocktable = GetTable(ent.BlockTable);
				
				if blocktable then
					if !ent.BlockSoundTable then
						soundtable = blocktable.blocksoundtable;
					end
				else
					blocktable = GetTable(wep.realBlockTable);
				end
			else
				if wep:GetNW2String("activeOffhand"):len() > 0 then
					local offhandTable = weapons.GetStored(wep:GetNW2String("activeOffhand"));
								
					if offhandTable then
						blocktable = GetDualTable(wep.realBlockTable, offhandTable.BlockTable);
					else
						blocktable = GetTable(wep.realBlockTable);
					end
				else
					blocktable = GetTable(wep.realBlockTable);
				end
			end
			
			soundtable = soundtable or ent.BlockSoundTable or wep.realBlockSoundTable;
			
			local blocksoundtable = GetSoundTable(soundtable)
			local blockthreshold = (blocktable["blockcone"] or 135) / 2;
			
			if blocktable["partialbulletblock"] == true and (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and (IsValid(attacker) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (attacker:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
				local enemyWeapon = attacker:GetActiveWeapon();
				
				if !IsValid(enemyWeapon) or !enemyWeapon.IgnoresBulletResistance then
					--ent:TakePoise(blocktable["guardblockamount"] * 0.5, 0, max_poise)

					if dmginfo:IsDamageType(DMG_BULLET) then
						--ent:TakePoise(math.Round(dmginfo:GetDamage() * 0.5));
						ent:TakeStamina(math.Round(dmginfo:GetDamage() * 0.5));
					elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
						--ent:TakePoise(math.Round(dmginfo:GetDamage() * 1.5));
						ent:TakeStamina(math.Round(dmginfo:GetDamage() * 0.5));
					end
					
					ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
					
					dmginfo:ScaleDamage(0.35)
					
					if blocktable["specialeffect"] == false then
						local effectdata = EffectData() 
							effectdata:SetEntity(wep)
							effectdata:SetScale(3)
							effectdata:SetOrigin(ent:GetPos() + ent:GetForward() * blocktable["blockeffectforward"] + (blocktable["blockeffectpos"]),Angle(0,45,0))
						util.Effect(blocktable["blockeffect"], effectdata) 
					end

					if (blocktable["specialeffect"] == true) then
						local flame = blocktable["blockeffect"];
						local bone = ent:LookupBone("ValveBiped.Bip01_R_Hand");

						if (bone) then
							local f = ents.Create("prop_physics");
							f:SetModel("models/hunter/blocks/cube025x025x025.mdl");
							f:SetPos(ent:GetBonePosition(bone));
							f:SetAngles(Angle(0, 0, 0));
							f:Spawn();
							f.follower = bone;
							f:SetRenderMode(RENDERMODE_TRANSALPHA)
							f:SetColor(Color(255, 255, 255, 0));
							f:SetMoveType(MOVETYPE_NONE);
							f:SetParent(ent, ent:LookupBone("ValveBiped.Bip01_R_Hand"));
							f:DrawShadow(false)

							local py = f:GetPhysicsObject();

							if (IsValid(py)) then
								py:EnableMotion(false);
							end;

							f:SetCollisionGroup(COLLISION_GROUP_WORLD);

							timer.Simple(1, function()
								if (IsValid(f)) then
									f:Remove();
								end;
							end);

							if IsValid(f) then
								ParticleEffectAttach(flame, PATTACH_POINT_FOLLOW, f, f.follower)
							end;
						end
					end
				end
			end
		
			local canblock = false

			if ((blocktable["blockdamagetypes"])) then
				for _,v in ipairs((blocktable["blockdamagetypes"])) do
					if dmginfo:IsDamageType(v) then
						if v == DMG_BULLET or v == DMG_BUCKSHOT then
							local enemyWeapon = attacker:GetActiveWeapon();
							
							if !IsValid(enemyWeapon) or !enemyWeapon.IgnoresBulletResistance then
								canblock = true;
								break;
							end
						else
							canblock = true;
							break;
						end
					end
				end
			end;
			
			if not canblock and wep.realHoldType == "wos-begotten_dual" then
				if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) or (isJavelin)) and cwBeliefs and ent.HasBelief and ent:HasBelief("impossibly_skilled") then
					local enemyWeapon = attacker:GetActiveWeapon();
					
					if !IsValid(enemyWeapon) or !enemyWeapon.IgnoresBulletResistance then
						canblock = true;
					end
				end
			end

			if canblock then
				local PoiseTotal = 0;

				if (IsValid(attacker) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (attacker:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
					if dmginfo:IsDamageType(DMG_BULLET) then
						PoiseTotal = -math.Round(dmginfo:GetDamage() * 0.33);
						dmginfo:ScaleDamage(0);
					elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
						PoiseTotal = -math.Round(dmginfo:GetDamage());
						dmginfo:ScaleDamage(0);
					end
				
					if enemywep and enemywep.IsABegottenMelee then
						if ent:GetNetVar("Deflect") then
							attacker:ViewPunch(Angle(-10,7,6))
						else
							attacker:ViewPunch(Angle(-3,1,0))
						end
					end

					---- Block Sound
					if !attacker:IsPlayer() and !ent:GetNetVar("Deflect") then
						if dmginfo:IsDamageType(128) then
							ent:EmitSound(blocksoundtable["blockwood"][math.random(1, #blocksoundtable["blockwood"])])
							--print "BLOCK NPC CRUSH"
						elseif dmginfo:IsDamageType(4) then
							ent:EmitSound(blocksoundtable["blockmetal"][math.random(1, #blocksoundtable["blockmetal"])])
							--print "BLOCK NPC SLASH"
						elseif dmginfo:IsDamageType(16) then
							ent:EmitSound(blocksoundtable["blockmetalpierce"][math.random(1, #blocksoundtable["blockmetalpierce"])])
							--print "BLOCK NPC PIERCE"
						elseif dmginfo:IsDamageType(2) or dmginfo:IsDamageType(1073741824) or dmginfo:IsDamageType(536870912) then
							ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
							--print "BLOCK NPC BULLET"
						end
					else
						if !ent:GetNetVar("Deflect") and attacker:IsPlayer() and !dmginfo:IsDamageType(1073741824) then
							if enemywep.IsABegottenMelee and !isJavelin then
								if enemywep.SoundMaterial == "Metal" then
									ent:EmitSound(blocksoundtable["blockmetal"][math.random(1, #blocksoundtable["blockmetal"])])
									--print "metal"
								elseif enemywep.SoundMaterial == "Wooden" then
									ent:EmitSound(blocksoundtable["blockwood"][math.random(1, #blocksoundtable["blockwood"])])
									--print "wood"
								elseif enemywep.SoundMaterial == "MetalPierce" then
									ent:EmitSound(blocksoundtable["blockmetalpierce"][math.random(1, #blocksoundtable["blockmetalpierce"])])
									--print "metalpierce"
								elseif enemywep.SoundMaterial == "Punch" then
									ent:EmitSound(blocksoundtable["blockpunch"][math.random(1, #blocksoundtable["blockpunch"])])
									--print "punch"
								elseif enemywep.SoundMaterial == "Bell" then
									ent:EmitSound(blocksoundtable["blockmetal"][math.random(1, #blocksoundtable["blockmetal"])])
									timer.Simple(0.2, function() if ent:IsValid() then
									ent:EmitSound("meleesounds/bell.mp3")
									end end)
									ent:Disorient(2)
									attacker:Disorient(1)
									--print "bell"
								elseif enemywep.SoundMaterial == "Default" then
									ent:EmitSound(blocksoundtable["blocksound"][math.random(1, #blocksoundtable["blocksound"])])
									--print "default"
								end
							elseif dmginfo:IsDamageType(128) then
								ent:EmitSound(blocksoundtable["blockwood"][math.random(1, #blocksoundtable["blockwood"])])
								--print "blockwood"
							elseif dmginfo:IsDamageType(4) then
								ent:EmitSound(blocksoundtable["blockmetal"][math.random(1, #blocksoundtable["blockmetal"])])
								--print "blockmetal"
							elseif dmginfo:IsDamageType(16) then
								ent:EmitSound(blocksoundtable["blockmetalpierce"][math.random(1, #blocksoundtable["blockmetalpierce"])])
								--print "blockmetalpierce"
							elseif dmginfo:IsDamageType(2) or dmginfo:IsDamageType(1073741824) or dmginfo:IsDamageType(536870912) then
								ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
								--print "blockmissile"
							end
						end
							--[[
							else
								ent:EmitSound(blocksoundtable["blocksound"][math.random(1, #blocksoundtable["blocksound"])])
								--print "sex with penis"
							end
							--]] 
							
							if dmginfo:IsDamageType(1073741824) then
								ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
								--print "blockjavelin"
							else
							
							if not attacker.opponent then
								if IsValid(enemywep) and enemywep.IsABegottenMelee then
									local weaponItemTable = item.GetByWeapon(enemywep);
									
									if weaponItemTable then
										if (!cwBeliefs or !attacker:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
											local conditionLoss;
											
											if cwBeliefs and attacker:HasBelief("scour_the_rust") then
												conditionLoss = dmginfo:GetDamage() / 155;
											else
												conditionLoss = dmginfo:GetDamage() / 100;
											end
											
											if enemywep.isJavelin and attacker:GetNetVar("ThrustStance") then
												conditionLoss = conditionLoss * 40;
											end
											
											weaponItemTable:TakeCondition(math.min(conditionLoss, 100));

											local enemyoffhand = enemywep:GetNW2String("activeOffhand");
											
											if enemyoffhand:len() > 0 then
												for k, v in pairs(attacker.equipmentSlots) do
													if v:IsTheSameAs(weaponItemTable) then
														local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
														
														if offhandItemTable then
															offhandItemTable:TakeCondition(math.min(conditionLoss, 100));
														end
													
														break;
													end
												end
											end
										end
									end
								end
							end
						end
					end
					
					-- Condition damage.
					if bIsPlayer and !ent.opponent then
						if wep and !ent:GetNetVar("Deflect") then
							local shieldItemTable = ent:GetShieldEquipped();
							local weaponItemTable = item.GetByWeapon(wep);
							local shieldEquipped = false;
							
							if shieldItemTable and wep:GetNW2String("activeShield") == shieldItemTable.uniqueID then
								shieldEquipped = true;
								
								local shieldConditionDamage = conditionDamage;
								
								if IsValid(inflictor) and (inflictor.isJavelin or inflictor.IsABegottenMelee) then
									local inflictorItemTable = inflictor.itemTable or item.GetByWeapon(inflictor);
									
									if inflictorItemTable and inflictorItemTable.attributes then
										if table.HasValue(inflictorItemTable.attributes, "shieldbreaker") then
											shieldConditionDamage = shieldConditionDamage * 5;
										end
									end
								end
								
								if (!cwBeliefs or not ent:HasBelief("ingenuity_finisher")) or shieldItemTable.unrepairable then
									if cwBeliefs and ent:HasBelief("scour_the_rust") then
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											shieldItemTable:TakeCondition(math.max((shieldConditionDamage * (shieldItemTable.bulletConditionScale or 0.5)) / 1.55, 1));
										else
											shieldItemTable:TakeCondition(math.max(shieldConditionDamage / 15, 1));
										end
									else
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											shieldItemTable:TakeCondition(math.max((shieldConditionDamage * (shieldItemTable.bulletConditionScale or 0.5)), 1));
										else
											shieldItemTable:TakeCondition(math.max(shieldConditionDamage / 10, 1));
										end
									end
								end
							end
							
							if weaponItemTable and not shieldEquipped then
								if (!cwBeliefs or not ent:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
									local offhand = wep:GetNW2String("activeOffhand");
									
									if offhand:len() > 0 and ent:HasBelief("impossibly_skilled") then
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											conditionDamage = conditionDamage * 0.1;
										end
									end
								
									if cwBeliefs and ent:HasBelief("scour_the_rust") then
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											weaponItemTable:TakeCondition(math.max((conditionDamage * (weaponItemTable.bulletConditionScale or 0.5)) / 1.55, 1));
										else
											weaponItemTable:TakeCondition(math.max(conditionDamage / 15, 1));
										end
									else
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											weaponItemTable:TakeCondition(math.max((conditionDamage * (weaponItemTable.bulletConditionScale or 0.5)), 1));
										else
											weaponItemTable:TakeCondition(math.max(conditionDamage / 10, 1));
										end
									end
									
									if offhand:len() > 0 then
										for k, v in pairs(ent.equipmentSlots) do
											if v:IsTheSameAs(weaponItemTable) then
												local offhandItemTable = ent.equipmentSlots[k.."Offhand"];
												
												if offhandItemTable then
													if cwBeliefs and ent:HasBelief("scour_the_rust") then
														if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
															offhandItemTable:TakeCondition(math.max((conditionDamage * (offhandItemTable.bulletConditionScale or 0.5)) / 1.55, 1));
														else
															offhandItemTable:TakeCondition(math.max(conditionDamage / 15, 1));
														end
													else
														if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
															offhandItemTable:TakeCondition(math.max((conditionDamage * (offhandItemTable.bulletConditionScale or 0.5)), 1));
														else
															offhandItemTable:TakeCondition(math.max(conditionDamage / 10, 1));
														end
													end
												end
											
												break;
											end
										end
									end
								end
							end
						end
					end
					---- Block Sound
					
					-- Block Effect
					if (blocktable["specialeffect"]) == false then
						local effectdata = EffectData() 
							effectdata:SetEntity(wep)
							effectdata:SetScale(2)
						effectdata:SetOrigin(ent:GetPos() + ent:GetForward() * (blocktable["blockeffectforward"]) + (blocktable["blockeffectpos"]),Angle(0,45,0))
						util.Effect((blocktable["blockeffect"]), effectdata) 
						--ParticleEffect("blood_spurt_synth_01b",ent:GetPos() + ent:GetForward() * 40 + Vector(0 /* Forward/Back */, 0 /* Left/Right */, 65 /* Up/Down */),Angle(0,45,0),nil)
					end
					-- Block Effect
		
					-- Special Effect
					if (blocktable["specialeffect"]) == true then
						local flame = (blocktable["blockeffect"]);
						local bone = ent:LookupBone("ValveBiped.Bip01_R_Hand");
					
						if (bone) then -- this needs to get fixed up eventually
							local f = ents.Create("prop_physics");
							f:SetModel("models/hunter/blocks/cube025x025x025.mdl");
							f:SetPos(ent:GetBonePosition(bone));
							f:SetAngles(Angle(0, 0, 0));
							f:Spawn();
							f.follower = bone;
							f:SetRenderMode(RENDERMODE_TRANSALPHA)
							f:SetColor(Color(255, 255, 255, 0));
							f:SetMoveType(MOVETYPE_NONE);
							f:SetParent(ent, ent:LookupBone("ValveBiped.Bip01_R_Hand"));
							f:DrawShadow(false)
						
							local py = f:GetPhysicsObject();
						
							if (IsValid(py)) then
								py:EnableMotion(false);
							end;
						
							f:SetCollisionGroup(COLLISION_GROUP_WORLD);
		
							timer.Simple(1, function()
								if (IsValid(f)) then
									f:Remove();
								end;
							end);
						
							if IsValid(f) then
								ParticleEffectAttach(flame, PATTACH_POINT_FOLLOW, f, f.follower)
							end;
						end
					end
					
					-- Special Effect
					
					if attacker:IsPlayer() and enemywep:IsValid() then
						-- Deal damage to people using fists if they hit a spiked shield.
						if(enemyattacktable.takesSpikedDamage) then
							if !Clockwork.player:HasFlags(attacker, "T") then
								local activeWeapon = ent:GetActiveWeapon();
								
								if (activeWeapon:IsValid() and activeWeapon:GetNW2String("activeShield"):len() > 0) then
									local blockTable = GetTable(activeWeapon:GetNW2String("activeShield"));
									
									if blockTable.spiked then
										attacker:TakeDamage(5, ent);
									elseif blockTable.electrified then
										local clothesItem = attacker:GetClothesEquipped();
										
										if clothesItem and (clothesItem.type == "chainmail" or clothesItem.type == "plate") then
											local shockDamageInfo = DamageInfo();
											
											shockDamageInfo:SetDamage(math.random(3, 5));
											shockDamageInfo:SetAttacker(ent);
											shockDamageInfo:SetDamageType(DMG_SHOCK);
											
											Schema:DoTesla(attacker, false);
											attacker:TakeDamageInfo(shockDamageInfo);
										end
									end
								end
							end
						elseif enemywep.IsABegottenMelee and enemywep.BlockTable then
							local activeWeapon = ent:GetActiveWeapon();
							
							if (activeWeapon:IsValid() and activeWeapon:GetNW2String("activeShield"):len() > 0) then
								local blockTable = GetTable(activeWeapon:GetNW2String("activeShield"));

								if blockTable.electrified then
									
									if enemywep.SoundMaterial == "Metal" or enemywep.SoundMaterial == "MetalPierce" then
										local shockDamageInfo = DamageInfo();
										
										shockDamageInfo:SetDamage(math.random(3, 5));
										shockDamageInfo:SetAttacker(ent);
										shockDamageInfo:SetDamageType(DMG_SHOCK);
										
										Schema:DoTesla(attacker, false);
										attacker:TakeDamageInfo(shockDamageInfo);
									end
								end
							end
						end
					end
					
					-- Poise system
					
					--[[(For NPC Poise Damage WIP)
					if attacker:IsValid() and (attacker:IsNPC() or attacker:IsNextBot()) and ent:IsValid() and ent:Alive() then
							--print (attacker:GetClass())
					end
					--]]
						
					if bIsPlayer and !ent:GetNetVar("Deflect") and ent:Alive() and attacker:IsValid() then
						local poiseDamageModifier = 1;
						
						if attacker.HasBelief then
							if attacker:HasBelief("fanaticism") then
								local health = attacker:Health();
								local maxHealth = attacker:GetMaxHealth();
								local lowerBound = maxHealth * 0.1;
								local modifier = math.Clamp(-(((health - lowerBound) / (maxHealth - lowerBound)) - 1), 0, 1);
								local bonus = 1.5 * modifier;
								
								poiseDamageModifier = math.max(bonus, 1)
							end
							
							if attacker:HasBelief("unrelenting") then
								poiseDamageModifier = poiseDamageModifier + 0.25;
							end

							if attacker:HasBelief("fearsome_wolf") then
								if attacker.warCryVictims then
									if table.HasValue(attacker.warCryVictims, ent) then
										poiseDamageModifier = poiseDamageModifier + 0.15;
									end
								end
							end
						end
						
						if attacker.GetCharmEquipped then
							if attacker:GetCharmEquipped("ring_pummeler") then
								poiseDamageModifier = poiseDamageModifier + 0.15;
							end
							
							if attacker:GetCharmEquipped("ring_pugilist") and enemywep:GetClass() == "begotten_fists" then
								if !isJavelin then
									poiseDamageModifier = poiseDamageModifier * 4;
								end
							end
						end
						
						if IsValid(enemywep) and enemywep:GetNW2String("activeOffhand"):len() > 0 then
							if !isJavelin then
								poiseDamageModifier = poiseDamageModifier * 0.5;
							end
						end
					
						if attacker:IsPlayer() and enemyattacktable["poisedamage"] then
							--print("PRE MODIFIER POISE DAMAGE: "..enemyattacktable["poisedamage"]);
							
							if attacker:GetNetVar("Riposting") == true then
								attacker.enemypoise = (((enemyattacktable["poisedamage"]) * 3) * poiseDamageModifier)
							elseif attacker:GetNetVar("ThrustStance") == true then
								attacker.enemypoise = (((enemyattacktable["poisedamage"]) * (enemyattacktable["altattackpoisedamagemodifier"])) * poiseDamageModifier)
							else
								attacker.enemypoise = ((enemyattacktable["poisedamage"]) * poiseDamageModifier)
							end
							
							--print("POST MODIFIER POISE DAMAGE: "..attacker.enemypoise);
							
							if ent.HasBelief then
								local newEnemyPoise = attacker.enemypoise;
								
								if ent:HasBelief("warden") then
									newEnemyPoise = newEnemyPoise * 0.85;
								end
							
								if ent:HasBelief("fortitude_finisher") then
									newEnemyPoise = newEnemyPoise * 0.75;
								end 
								
								if ent:HasBelief("shieldwall") then
									local activeWeapon = ent:GetActiveWeapon();
									
									if activeWeapon:GetNW2String("activeShield"):len() > 0 then
										newEnemyPoise = newEnemyPoise - 10;
									end
								end
								
								PoiseTotal = math.min(blocktable["poiseresistance"] - newEnemyPoise, 0);
							else
								PoiseTotal = math.min(blocktable["poiseresistance"] - attacker.enemypoise, 0);
							end
						elseif attacker:IsNPC() or attacker:IsNextBot() then
							if attacker.StaminaDamage then
								attacker.enemypoise = attacker.StaminaDamage;
							elseif attacker.Damage then
								attacker.enemypoise = (attacker.Damage * 1.25) or 15;
							else
								attacker.enemypoise = 15;
							end
							
							--print("POST MODIFIER POISE DAMAGE: "..attacker.enemypoise);
							
							if ent.HasBelief then
								local newEnemyPoise = attacker.enemypoise;
								
								if ent:HasBelief("warden") then
									newEnemyPoise = newEnemyPoise * 0.85;
								end
							
								if ent:HasBelief("fortitude_finisher") then
									newEnemyPoise = newEnemyPoise * 0.75;
								end 
								
								if ent:HasBelief("shieldwall") then
									local activeWeapon = ent:GetActiveWeapon();
									
									if activeWeapon:GetNW2String("activeShield"):len() > 0 then
										newEnemyPoise = newEnemyPoise - 10;
									end
								end
								
								PoiseTotal = math.min(blocktable["poiseresistance"] - newEnemyPoise, 0);
							else
								PoiseTotal = math.min(blocktable["poiseresistance"] - attacker.enemypoise, 0);
							end
						end
						
						--print("POISE TOTAL DAMAGE: "..PoiseTotal);
						if PoiseTotal >= 0 or PoiseTotal < 0 and PoiseTotal > -1 then
							dmginfo:ScaleDamage(0)
						end 
					
						if PoiseTotal <= -1 and PoiseTotal >= -5 then
							--print "Tier 1" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(1,0,0))
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -5 and PoiseTotal >= -10 then
							--print "Tier 2" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(3,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -10 and PoiseTotal >= -15 then
							--print "Tier 3" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(5,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -15 and PoiseTotal >= -20 then
							--print "Tier 4"
							dmginfo:ScaleDamage(0.05)
							ent:ViewPunch(Angle(7,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.05)
								end
							end
						elseif PoiseTotal < -20 and PoiseTotal >= -25 then
							--print "Tier 5" 
							dmginfo:ScaleDamage(0.1)
							ent:ViewPunch(Angle(9,1,1))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.1)
								end
							end
						elseif PoiseTotal < -25 and PoiseTotal >= -30 then
							--print "Tier 6" 
							dmginfo:ScaleDamage(0.15)
							ent:ViewPunch(Angle(12,3,2))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.15)
								end
							end
						elseif PoiseTotal < -30 and PoiseTotal >= -35 then
							--print "Tier 7" 
							dmginfo:ScaleDamage(0.2)
							ent:ViewPunch(Angle(14,8,6))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.2)
								end
							end
						elseif PoiseTotal < -35 and PoiseTotal >= -40 then
							--print "Tier 8" 
							dmginfo:ScaleDamage(0.25)
							ent:ViewPunch(Angle(25,10,9))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.25)
								end
							end
						elseif PoiseTotal < -40 and PoiseTotal >= -45 then
							--print "Tier 9"
							dmginfo:ScaleDamage(0.3)
							ent:ViewPunch(Angle(35,12,10))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.3)
								end
							end
						elseif PoiseTotal < -45 then
							--print "Tier 10" 
							dmginfo:ScaleDamage(0.35)
							ent:ViewPunch(Angle(50,15,25))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							--ent:TakePoise(PoiseTotal);
							ent:TakeStamina(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								if !ent.wOSIsRolling or !ent:wOSIsRolling() then
									ent:Ignite(enemywep.IgniteTime * 0.35)
								end
							end
						end
					elseif !ent:GetNetVar("Deflect") then
						dmginfo:ScaleDamage(0)
					end
					-- Poise system
			
					if bIsPlayer and !ent:GetNetVar("Deflect") then
						--local melsta = ent:GetNWInt("meleeStamina", 90);
						local melsta = ent:GetNWInt("Stamina", 100);
						local blockamount = (blocktable["guardblockamount"]);
						
						if IsValid(enemywep) and enemywep:GetNW2String("activeOffhand"):len() > 0 then
							if !isJavelin then
								blockamount = blockamount * 0.5;
							end
						end
						
						if cwMedicalSystem then
							local injuries = cwMedicalSystem:GetInjuries(ent);
							
							if injuries then
								if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
									blockamount = blockamount + (blocktable["guardblockamount"] * 2);
								end
								
								if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
									blockamount = blockamount + (blocktable["guardblockamount"] * 2);
								end
							end
						end
						
						local melsa = melsta - blockamount;
						local chance = math.random(1, 2);
						--local chance = 1; -- for testing
						
						if cwBeliefs and ent.HasBelief and ent:HasBelief("encore") then
							chance = math.random(1, 4);
						end
						
						--ent:SetNWInt("meleeStamina", math.Clamp(melsa, 0, max_poise))

						if !dmginfo:IsDamageType(DMG_BULLET) and !dmginfo:IsDamageType(DMG_BUCKSHOT) then
							--ent:TakePoise(blockamount);
							ent:TakeStamina(blockamount);
						end
						
						if melsa <= blockamount and not ent:IsRagdolled() and chance == 1 then
							if ent:GetCharacterData("stability") < 70 then
								if !wep.noDisarm and wep:GetNW2String("activeShield"):len() == 0 and not string.find(wep:GetClass(), "begotten_fists") and not string.find(wep:GetClass(), "begotten_claws") then
									local dropMessages = {" goes flying out of their hand!", " is knocked out of their hand!"};
									local itemTable = Clockwork.item:GetByWeapon(wep);
									
									if itemTable then
										if ent.opponent then
											if (itemTable:HasPlayerEquipped(ent)) then
												itemTable:OnPlayerUnequipped(ent);
												ent:RebuildInventory();
												ent:SetWeaponRaised(false);
											end
											
											Clockwork.chatBox:AddInTargetRadius(ent, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], ent:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
										else
											itemTable:TakeCondition(10);
										
											local dropPos = ent:GetPos() + Vector(0, 0, 35) + ent:GetAngles():Forward() * 4
											local itemEnt = Clockwork.entity:CreateItem(ent, itemTable, dropPos);
											
											if (IsValid(itemEnt)) then
												Clockwork.chatBox:AddInTargetRadius(ent, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], ent:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
												ent:TakeItem(itemTable)
												--ent:SelectWeapon("begotten_fists")
												ent:StripWeapon(wep:GetClass())
											end
										end
									end
								end
							end
						end
					end
				
					-- Deflection
					if ent:GetNetVar("Deflect") and (!ent.nextDeflect or CurTime() > ent.nextDeflect) and (IsValid(attacker) and (dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(16) or (cwBeliefs and ent:HasBelief("impossibly_skilled") and isJavelin))) then
						if !attacker:IsPlayer() then
							if isJavelin then
								ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
								--print "DEFLECT JAVELIN"
							elseif dmginfo:IsDamageType(128) then
								ent:EmitSound(blocksoundtable["deflectwood"][math.random(1, #blocksoundtable["deflectwood"])])
								--print "DEFLECT CRUSH"
							elseif dmginfo:IsDamageType(4) then
								ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
								--print "DEFLECT SLASH"
							elseif dmginfo:IsDamageType(16) then
								ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
								--print "DEFLECT PIERCE"
							end
						else
							if attacker:IsPlayer() then
								if enemywep.IsABegottenMelee or isJavelin then
									if isJavelin then
										ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
										--print "deflect javelin"
									elseif enemywep.SoundMaterial == "Metal" then
										ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
										--print "deflect metal"
									elseif enemywep.SoundMaterial == "Wooden" then
										ent:EmitSound(blocksoundtable["deflectwood"][math.random(1, #blocksoundtable["deflectwood"])])
										--print "deflect wood"
									elseif enemywep.SoundMaterial == "MetalPierce" then
										ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
										--print "deflect metalpierce"
									elseif enemywep.SoundMaterial == "Punch" then
										ent:EmitSound(blocksoundtable["deflectpunch"][math.random(1, #blocksoundtable["deflectpunch"])])
										--print "deflect punch"
									elseif enemywep.SoundMaterial == "Bell" then
										ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
										--print "deflect bell"
									elseif enemywep.SoundMaterial == "Default" then
										ent:EmitSound(blocksoundtable["deflectsound"][math.random(1, #blocksoundtable["deflectsound"])])
										--print "deflect default"
									end
								elseif dmginfo:IsDamageType(128) then
									ent:EmitSound(blocksoundtable["deflectwood"][math.random(1, #blocksoundtable["deflectwood"])])
									--print "deflect wood 2"
								elseif dmginfo:IsDamageType(4) then
									ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
									--print "deflect metal 2"
								elseif dmginfo:IsDamageType(16) then
									ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
									--print "deflect metalpierce 2"
								end
							end
							
							if not attacker.opponent then
								if enemywep then
									local weaponItemTable = item.GetByWeapon(enemywep);
									
									if weaponItemTable then
										if (!cwBeliefs or not attacker:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
											local conditionLoss;
											
											if cwBeliefs and attacker:HasBelief("scour_the_rust") then
												conditionLoss = dmginfo:GetDamage() / 155;
											else
												conditionLoss = dmginfo:GetDamage() / 100;
											end
											
											if enemywep.isJavelin and attacker:GetNetVar("ThrustStance") then
												conditionLoss = conditionLoss * 40;
											end
											
											weaponItemTable:TakeCondition(math.min(conditionLoss, 100));

											local enemyoffhand = enemywep:GetNW2String("activeOffhand");
											
											if enemyoffhand:len() > 0 then
												for k, v in pairs(attacker.equipmentSlots) do
													if v:IsTheSameAs(weaponItemTable) then
														local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
														
														if offhandItemTable then
															offhandItemTable:TakeCondition(math.min(conditionLoss, 100));
														end
													
														break;
													end
												end
											end
										end
									end
								end
							end
						end
						
						ent:SetLocalVar("Deflect", false)
						wep:SetNextPrimaryFire(0);
						
						if ent.HasBelief then
							local max_stability = ent:GetMaxStability();
							local deflectionPoisePayback = 0;
							local deflectionStabilityPayback = 0;
						
							if ent:HasBelief("sidestep") then
								deflectionPoisePayback = 25;
								deflectionStabilityPayback = 15;
								wep.canDeflect = true;
							elseif ent:HasBelief("deflection") then
								deflectionPoisePayback = 15;
								deflectionStabilityPayback = 10;
							end
							
							if IsValid(inflictor) and inflictor:GetNW2String("activeOffhand") then
								deflectionPoisePayback = math.Round(deflectionPoisePayback * 1.5);
							end
							
							ent:HandleStamina(deflectionPoisePayback);
							ent:SetCharacterData("stability", math.Clamp(ent:GetCharacterData("stability", max_stability) + deflectionStabilityPayback, 0, max_stability));
							ent:SetNWInt("stability", ent:GetCharacterData("stability", max_stability));
						end
						
						netstream.Start(ent, "Parried", 0.2)
						dmginfo:ScaleDamage(0) 
						
						-- Deflection "mini stun" effect
						if attacker:IsPlayer() and (!IsValid(inflictor) or !isJavelin) then
							attacker:SetLocalVar("Deflected", true);
							
							local delay = enemyattacktable["delay"];
							
							if ent.HasBelief then
								if ent:HasBelief("sidestep") then
									delay = math.max(2, enemyattacktable["delay"]);
								elseif ent:HasBelief("deflection") then
									delay = math.max(1, enemyattacktable["delay"]);
								end
							end

							if enemywep then
								enemywep:SetNextPrimaryFire(CurTime() + delay);
								
								-- Make sure offhand swing is aborted if deflected.
								if enemywep.Timers then
									if enemywep.Timers["strikeTimer"..tostring(attacker:EntIndex())] then
										enemywep.Timers["strikeTimer"..tostring(attacker:EntIndex())] = nil;
									end
								
									if enemywep.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] then
										enemywep.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] = nil;
									end
								end
								
								enemywep.isAttacking = false;
							end
							
							--netstream.Start(attacker, "Stunned", (enemyattacktable["delay"]));
							netstream.Start(attacker, "MotionBlurStunned", (enemyattacktable["delay"]));
							
							timer.Simple(delay, function()
								if IsValid(attacker) then
									attacker:SetLocalVar("Deflected", false);
								end
							end);
						end
						
						if wep.hasSwordplay and (!cwBeliefs or ent:HasBelief("blademaster")) then
							wep:SetNW2Bool("swordplayActive", true);
							
							wep:CreateTimer(0.5, "swordplayTimer"..wep:EntIndex(), function()
								if IsValid(wep) then
									wep:SetNW2Bool("swordplayActive", false);
								end
							end);
						end
					end
			
					dmginfo:SetDamagePosition(vector_origin)
				else				
					-- For being hit while blocking but outside of your blockcone (ex: hit in the back while blocking)
					if (ent:IsPlayer() and attacker:IsPlayer()) then
						local attacker = dmginfo:GetAttacker();
						local trace = attacker:GetEyeTrace();
						local pos = ent:GetPos() + Vector(0,0, 50);
						
						if enemywep.IsABegottenMelee == true then
							local attackSoundTable = enemywep.AttackSoundTable;
							
							if IsValid(inflictor) and inflictor.isJavelin then
								attackSoundTable = "MetalSpearAttackSoundTable";
							end
							
							local enemyattacksoundtable = GetSoundTable(attackSoundTable)
							--print(enemyattacksoundtable["hitbody"][math.random(1, #enemyattacksoundtable["hitbody"])])
								
							if attacker:GetNetVar("ThrustStance") == true and attacker:GetNetVar("Riposting") != true then
								ent:EmitSound(enemyattacksoundtable["althitbody"][math.random(1, #enemyattacksoundtable["althitbody"])])
								-- For sacrificial attacks (thrust)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), attacker);
								end
								if enemyattacktable["attacktype"] == "fire_swing" then
									if !ent.wOSIsRolling or !ent:wOSIsRolling() then
										ent:Ignite(enemywep.IgniteTime)
									end
								end
							else
								local stabilityDamage = enemyattacktable["stabilitydamage"]

								if attacker:GetNetVar("ThrustStance") and enemyattacktable["altattackstabilitydamagemodifier"] then
									stabilityDamage = stabilityDamage * enemyattacktable["altattackstabilitydamagemodifier"];
								end
								
								if enemywep:GetNW2String("activeOffhand"):len() > 0 then
									if !isJavelin then
										stabilityDamage = stabilityDamage * 0.6;
									end
								end
								
								if cwBeliefs and attacker:HasBelief("might") then
									stabilityDamage = stabilityDamage * 1.15;
								end
								
								ent:TakeStability(stabilityDamage) // Note: Rework this shit!!! Should not make extra checks if the attack comes from behind while user is blocking
								
								ent:EmitSound(enemyattacksoundtable["hitbody"][math.random(1, #enemyattacksoundtable["hitbody"])])
								-- For sacrificial attacks (regular)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), attacker);
								end
								if enemyattacktable["attacktype"] == "fire_swing" then
									if !ent.wOSIsRolling or !ent:wOSIsRolling() then
										ent:Ignite(enemywep.IgniteTime)
									end
								end
							end
							
							-- Bellhammer special
							if enemywep.IsBellHammer == true then
								timer.Simple(0.2, function() if ent:IsValid() then
									ent:EmitSound("meleesounds/bell.mp3")
								end end)
								attacker:Disorient(1)
								ent:Disorient(5)
							end

							if (trace.HitPos:Distance(ent:GetPos()) < 128 and !trace.Entity:IsWorld() and trace.Entity:IsPlayer()) then
								pos = trace.HitPos;
							end;
						
							if (enemyattacktable["primarydamage"]) >= 12 then 
								bloodeffect = "bloodsplat"
							else
								bloodeffect = "bleedingsplat"
							end

							local effectdata = EffectData();
								effectdata:SetOrigin(pos);
								effectdata:SetEntity(attacker)
								effectdata:SetAttachment(5)
								effectdata:SetScale(16);
							util.Effect(bloodeffect, effectdata);
							
							if not attacker.opponent then
								if isJavelin then
									return;
								end
							
								local weaponItemTable = item.GetByWeapon(enemywep);
								
								if weaponItemTable then
									if (!cwBeliefs or not attacker:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
										local conditionLoss;
										
										if cwBeliefs and attacker:HasBelief("scour_the_rust") then
											conditionLoss = dmginfo:GetDamage() / 155;
										else
											conditionLoss = dmginfo:GetDamage() / 100;
										end
										
										if enemywep.isJavelin and attacker:GetNetVar("ThrustStance") then
											conditionLoss = conditionLoss * 40;
										end
										
										weaponItemTable:TakeCondition(math.min(conditionLoss, 100));

										local enemyoffhand = enemywep:GetNW2String("activeOffhand");
										
										if enemyoffhand:len() > 0 then
											for k, v in pairs(attacker.equipmentSlots) do
												if v:IsTheSameAs(weaponItemTable) then
													local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
													
													if offhandItemTable then
														offhandItemTable:TakeCondition(math.min(conditionLoss, 100));
													end
												
													break;
												end
											end
										end
									end
								end
							end
						end
					end;
				end
			end
		elseif !ent.iFrames then
			-- Deal damage to people using fists if they hit spiked armor.
			if attacker:IsPlayer() then
				local enemywep = inflictor or attacker:GetActiveWeapon();
				
				if ent:IsPlayer() then
					-- Deal damage to people using fists if they hit spiked armor.
					if enemywep:IsValid() and enemyattacktable.takesSpikedDamage then
						if !Clockwork.player:HasFlags(attacker, "T") then
							if ent:GetModel() == "models/begotten/satanists/hellspike_armor.mdl" then
								attacker:TakeDamage(5, ent);
							end
						end
					end
				end
				
				if not attacker.opponent then
					if isJavelin then
						return;
					end
					
					if IsValid(enemywep) and enemywep.IsABegottenMelee then
						local weaponItemTable = item.GetByWeapon(enemywep);
						
						if weaponItemTable then
							if (cwBeliefs and not attacker:HasBelief("ingenuity_finisher")) or weaponItemTable.unrepairable then
								local conditionLoss;
								
								if cwBeliefs and attacker:HasBelief("scour_the_rust") then
									conditionLoss = dmginfo:GetDamage() / 155;
								else
									conditionLoss = dmginfo:GetDamage() / 100;
								end
								
								if enemywep.isJavelin and attacker:GetNetVar("ThrustStance") then
									conditionLoss = conditionLoss * 40;
								end
								
								weaponItemTable:TakeCondition(math.min(conditionLoss, 100));

								local enemyoffhand = enemywep:GetNW2String("activeOffhand");
								
								if enemyoffhand:len() > 0 then
									for k, v in pairs(attacker.equipmentSlots) do
										if v:IsTheSameAs(weaponItemTable) then
											local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
											
											if offhandItemTable then
												offhandItemTable:TakeCondition(math.min(conditionLoss, 100));
											end
										
											break;
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
 
hook.Add("PreEntityTakeDamage", "Guarding", Guarding)

local function PlayerDisconnected(player)
	if IsValid(player) and IsValid(player.particleprop) then
		player.particleprop:Remove();
	end
end

hook.Add("PlayerDisconnected", "PlayerDisconnectedMeleeAutorun", PlayerDisconnected)

local function UpdateWeaponRaised(player, activeWeapon, bIsRaised, curTime)
	if bIsRaised then
		if (player:KeyDown(IN_ATTACK2)) and (!player:KeyDown(IN_USE)) then
			timer.Simple(FrameTime(), function()
				if (player:KeyDown(IN_ATTACK2)) and (!player:KeyDown(IN_USE)) then
					if activeWeapon:IsValid() and (activeWeapon.Base == "sword_swepbase") then
						if (activeWeapon.IronSights == true) then
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
								
								local guardblockamount = blockTable["guardblockamount"];
								
								if cwMedicalSystem then
									local injuries = cwMedicalSystem:GetInjuries(player);
									
									if injuries then
										if (injuries[HITGROUP_LEFTARM]["broken_bone"]) then
											guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
										end
										
										if (injuries[HITGROUP_RIGHTARM]["broken_bone"]) then
											guardblockamount = guardblockamount + (blockTable["guardblockamount"] * 2);
										end
									end
								end
								
								--if (blockTable and player:GetNWInt("meleeStamina", 100) >= guardblockamount and !player:GetNetVar("Parried")) then
								if (!activeWeapon.isMeleeFirearm or player:GetNetVar("ThrustStance")) and (blockTable and player:GetNWInt("Stamina", 100) >= guardblockamount and !player:GetNetVar("Parried")) then
									player:SetLocalVar("Guardening", true);
									player.beginBlockTransition = true;
									activeWeapon.Primary.Cone = activeWeapon.IronCone;
									activeWeapon.Primary.Recoil = activeWeapon.Primary.IronRecoil;
								else
									player:CancelGuardening()
								end;
							end;
						else
							player:CancelGuardening();
						end;
					end;
				end
			end);
		end
	else
		player:CancelGuardening();
	end
end
	
hook.Add("UpdateWeaponRaised", "UpdateWeaponRaisedMeleeAutorun", UpdateWeaponRaised)

--print("The Undergod demands.")

concommand.Add("atyd", function(player)
	if player:IsAdmin() then
		for _, v in _player.Iterator() do
			v:Give("begotten_fists");
			v:SelectWeapon("begotten_fists");
			v:Give("cw_senses")
		end;
	else
		Clockwork.player:NotifyAdmins("operator", "fucklet "..player:Name().." just tried to run atyd");
	end
end);

-- Bot blocking tester.

--[[local function StartCommandMeleeAutorun(player, ucmd)
	if player:IsBot() and player:Alive() then
		ucmd:SetButtons( IN_ATTACK2 )
	end
end

hook.Add("StartCommand", "StartCommandMeleeAutorun", StartCommandMeleeAutorun)]]--