function Parry(target, dmginfo)
	if (target:IsPlayer()) then
		local wep = target:GetActiveWeapon()

		if (target:IsValid() and target:Alive() and (target:GetNWBool("Parry", false) == true) and IsValid(wep)) then
			local damageType = dmginfo:GetDamageType();
			local checkTypes = {[4] = true, [16] = true, [128] = true};

			if (checkTypes[damageType]) then
				local attacker = dmginfo:GetAttacker()
				local blocktable = GetTable(wep.realBlockTable);
				
				target:SetNWBool("ParrySucess", true)
				attacker:SetNWBool("Parried", true)
				netstream.Start(target, "Parried", 0.2)
				netstream.Start(attacker, "Stunned", 3);
				dmginfo:SetDamage(0)
				target:EmitSound("meleesounds/DS2Parry.mp3")
				
				if attacker.CancelGuardening then
					attacker:CancelGuardening();
				end
				
				if attacker.OnParried then
					attacker:OnParried();
				end
				
				if attacker:IsPlayer() then
					-- Kill their acceleration and make them slower.
					--[[attacker.accelerationFinished = false;
					attacker.startAcceleration = nil;
					attacker.cwTargetRunSpeed = attacker:GetRunSpeed();
				
					hook.Run("RunModifyPlayerSpeed", attacker, attacker.cwInfoTable, true);]]--
					
					attacker:SetNetVar("runningDisabled", true);
					
					timer.Create("GroundedSprintTimer_"..tostring(attacker:EntIndex()), 3, 1, function()
						if IsValid(attacker) then
							attacker:SetNetVar("runningDisabled", nil);
						end
					end);
				end
				
				wep:SetNextPrimaryFire(0)
				
				if (wep.realBlockSoundTable) then
					local blocksoundtable = GetSoundTable(wep.realBlockSoundTable)
					
					target:EmitSound(blocksoundtable["blocksound"][math.random(1, #blocksoundtable["blocksound"])])
				end;
				
				-- Refund half the poise cost of parrying upon a successful parry.
				local max_poise = target:GetNetVar("maxMeleeStamina");
				
				target:SetNWInt("meleeStamina", math.Clamp(target:GetNWInt("meleeStamina") + math.Round(blocktable["parrytakestamina"] / 2), 0, max_poise));

				if (IsValid(attacker) and attacker:IsPlayer()) then
					local attackerWeapon = attacker:GetActiveWeapon();
					
					if IsValid(attackerWeapon) then
						local curTime = CurTime();
					
						if cwBeliefs and attacker.HasBelief and attacker:HasBelief("encore") then
							attackerWeapon:SetNextPrimaryFire(curTime + 1.5)
							attackerWeapon:SetNextSecondaryFire(curTime + 1.5)
						else
							attackerWeapon:SetNextPrimaryFire(curTime + 3)
							attackerWeapon:SetNextSecondaryFire(curTime + 3)
						end
						
						-- Make sure offhand swing is aborted if deflected.
						if attackerWeapon.Timers then
							if attackerWeapon.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] then
								attackerWeapon.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] = nil;
							end
						end
						
						if attackerWeapon:GetClass() == "begotten_fists" then
							Clockwork.chatBox:AddInTargetRadius(target, "me", " parries "..attacker:Name().." with their bare hands!", target:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						end
					end
				end
				
				local index = target:EntIndex();
				
				if (!target:IsRagdolled() and !target:GetNWBool("HasChangedWeapons", false)) then
					if (timer.Exists(index.."_ParrySuccessTimer")) then 
						timer.Destroy(index.."_ParrySuccessTimer")
					end
					
					target:SetNWBool("ParrySucess", true)
					
					local delay = 2;
					
					if wep.AttackTable then
						local attackTable;
						
						if wep:GetNWString("activeOffhand"):len() > 0 then
							local offhandTable = weapons.GetStored(wep:GetNWString("activeOffhand"));
							
							if offhandTable then
								attackTable = GetDualTable(wep.AttackTable, offhandTable.AttackTable);
							else
								attackTable = GetTable(wep.AttackTable);
							end
						else
							attackTable = GetTable(wep.AttackTable);
						end
						
						if attackTable then
							delay = (attackTable["delay"] + 1);
						end
					end
					
					timer.Create(index.."_ParrySuccessTimer", delay, 1, function()
						if (target:IsValid() --[[and target:Alive() and !target:IsRagdolled() and !target:GetNWBool("HasChangedWeapons", false) and (target:GetNWBool("ParrySucess", false) == true)]]) then
							target:SetNWBool("ParrySucess", false) 
						end
						
						if IsValid(attacker) then
							attacker:SetNWBool("Parried", false);
							
							if attacker:IsPlayer() then
								hook.Run("RunModifyPlayerSpeed", attacker, attacker.cwInfoTable, true);
							end
						end
					end)
				end
			end
		end
	end
end	
hook.Add("PreEntityTakeDamage", "Parrying", Parry)
	
local function Guarding(ent, dmginfo)
	if (!ent:IsPlayer()) then
		if ent:IsNPC() or ent:IsNextBot() then
			local attacker = dmginfo:GetAttacker()
			
			if IsValid(attacker) and attacker:IsPlayer() then
				if not attacker.opponent then
					local enemywep = attacker:GetActiveWeapon();
					
					if enemywep then
						local weaponItemTable = item.GetByWeapon(enemywep);
						
						if weaponItemTable then
							if !cwBeliefs or not attacker:HasBelief("ingenuity_finisher") then
								if cwBeliefs and attacker:HasBelief("scour_the_rust") then
									weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 200, 100));
								else
									weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
								end

								local enemyoffhand = enemywep:GetNWString("activeOffhand");
								
								if enemyoffhand:len() > 0 then
									for k, v in pairs(attacker.equipmentSlots) do
										if v:IsTheSameAs(weaponItemTable) then
											local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
											
											if offhandItemTable then
												if cwBeliefs and attacker:HasBelief("scour_the_rust") then
													offhandItemTable:TakeCondition(0.25);
												else
													offhandItemTable:TakeCondition(0.5);
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
			end
		end
		
		return;
	end;
	
	if dmginfo:IsDamageType(DMG_DROWNRECOVER) then
		return;
	end;
	
	local inflictor = dmginfo:GetInflictor();
	
	if IsValid(inflictor) and inflictor.unblockable then
		return;
	end
	
	if ent:Alive() then
		local wep = ent:GetActiveWeapon()
		--local attacksoundtable = GetSoundTable(wep.AttackSoundTable)
		--local attacktable = GetTable(wep.AttackTable)
		local attacker = dmginfo:GetAttacker()
		local max_poise = ent:GetNetVar("maxMeleeStamina") or 90;
		local conditionDamage = dmginfo:GetDamage();

		if (ent:GetNWBool("Guardening") == true) then
			local blocktable;
			
			if wep:GetNWString("activeOffhand"):len() > 0 then
				local offhandTable = weapons.GetStored(wep:GetNWString("activeOffhand"));
							
				if offhandTable then
					blocktable = GetDualTable(wep.realBlockTable, offhandTable.BlockTable);
				else
					blocktable = GetTable(wep.realBlockTable);
				end
			else
				blocktable = GetTable(wep.realBlockTable);
			end
			
			local blocksoundtable = GetSoundTable(wep.realBlockSoundTable)
			local blockthreshold = (blocktable["blockcone"] or 135) / 2;
			
			if blocktable["partialbulletblock"] == true and (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and (IsValid(attacker) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (attacker:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
				local enemyWeapon = attacker:GetActiveWeapon();
				
				if !IsValid(enemyWeapon) or !enemyWeapon.IgnoresBulletResistance then
					--ent:TakePoise(blocktable["guardblockamount"] * 0.5, 0, max_poise)

					if dmginfo:IsDamageType(DMG_BULLET) then
						ent:TakePoise(math.Round(dmginfo:GetDamage() * 0.5));
					elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
						ent:TakePoise(math.Round(dmginfo:GetDamage() * 1.5));
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
				if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) or (IsValid(inflictor) and inflictor.isJavelin)) and cwBeliefs and ent.HasBelief and ent:HasBelief("impossibly_skilled") then
					local enemyWeapon = attacker:GetActiveWeapon();
					
					if !IsValid(enemyWeapon) or !enemyWeapon.IgnoresBulletResistance then
						canblock = true;
					end
				end
			end

			if canblock then
				local enemywep;
				
				if attacker:IsPlayer() or attacker:IsNPC() then
					enemywep = attacker:GetActiveWeapon()
				end
				
				local enemyattacktable = {}
				local PoiseTotal = 0;
				
				if enemywep and (enemywep.AttackTable) then
					enemyattacktable = GetTable(enemywep.AttackTable)
				end;
				
				if dmginfo:IsDamageType(DMG_BULLET) then
					PoiseTotal = -math.Round(dmginfo:GetDamage() * 0.33);
					dmginfo:ScaleDamage(0);
				elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
					PoiseTotal = -math.Round(dmginfo:GetDamage());
					dmginfo:ScaleDamage(0);
				end

				if (IsValid(attacker) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (attacker:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
					if enemywep and enemywep.IsABegottenMelee == true then
						if ent:GetNWBool("Deflect") == true then
							attacker:ViewPunch(Angle(-10,7,6))
						else
							attacker:ViewPunch(Angle(-3,1,0))
						end
					end

					---- Block Sound
					if !attacker:IsPlayer() and !ent:GetNWBool("Deflect", true) then
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
						if !ent:GetNWBool("Deflect", true) and attacker:IsPlayer() and !dmginfo:IsDamageType(1073741824) then
							if enemywep.IsABegottenMelee == true and (!dmginfo:GetInflictor() or (dmginfo:GetInflictor() and !dmginfo:GetInflictor().isJavelin)) then
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
								if enemywep then
									local weaponItemTable = item.GetByWeapon(enemywep);
									
									if weaponItemTable then
										if !cwBeliefs or not attacker:HasBelief("ingenuity_finisher") then
											if cwBeliefs and attacker:HasBelief("scour_the_rust") then
												weaponItemTable:TakeCondition(0.25);
											else
												weaponItemTable:TakeCondition(0.5);
											end
											
											local enemyoffhand = enemywep:GetNWString("activeOffhand");
											
											if enemyoffhand:len() > 0 then
												for k, v in pairs(attacker.equipmentSlots) do
													if v:IsTheSameAs(weaponItemTable) then
														local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
														
														if offhandItemTable then
															if cwBeliefs and attacker:HasBelief("scour_the_rust") then
																offhandItemTable:TakeCondition(0.25);
															else
																offhandItemTable:TakeCondition(0.5);
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
						end
					end
					
					if not ent.opponent then
						if wep then
							local shieldItemTable = ent:GetShieldEquipped();
							local weaponItemTable = item.GetByWeapon(wep);
							local shieldEquipped = false;
							
							if shieldItemTable and wep:GetNWString("activeShield") == shieldItemTable.uniqueID then
								shieldEquipped = true;
								
								if !cwBeliefs or not ent:HasBelief("ingenuity_finisher") then
									if cwBeliefs and ent:HasBelief("scour_the_rust") then
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											shieldItemTable:TakeCondition(math.max((conditionDamage * (shieldItemTable.bulletConditionScale or 0.5)) / 2, 1));
										else
											shieldItemTable:TakeCondition(math.max(conditionDamage / 100, 1));
										end
									else
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											shieldItemTable:TakeCondition(math.max((conditionDamage * (shieldItemTable.bulletConditionScale or 0.5)), 1));
										else
											shieldItemTable:TakeCondition(math.max(conditionDamage / 50, 1));
										end
									end
								end
							end
							
							if weaponItemTable and not shieldEquipped then
								if !cwBeliefs or not ent:HasBelief("ingenuity_finisher") then
									if cwBeliefs and ent:HasBelief("scour_the_rust") then
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											weaponItemTable:TakeCondition(math.max((conditionDamage * (weaponItemTable.bulletConditionScale or 0.5)) / 2, 1));
										else
											weaponItemTable:TakeCondition(math.max(conditionDamage / 100, 1));
										end
									else
										if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
											weaponItemTable:TakeCondition(math.max((conditionDamage * (weaponItemTable.bulletConditionScale or 0.5)), 1));
										else
											weaponItemTable:TakeCondition(math.max(conditionDamage / 50, 1));
										end
									end
									
									local offhand = wep:GetNWString("activeOffhand");
									
									if offhand:len() > 0 then
										for k, v in pairs(ent.equipmentSlots) do
											if v:IsTheSameAs(weaponItemTable) then
												local offhandItemTable = ent.equipmentSlots[k.."Offhand"];
												
												if offhandItemTable then
													if cwBeliefs and ent:HasBelief("scour_the_rust") then
														if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
															offhandItemTable:TakeCondition(math.max((conditionDamage * (offhandItemTable.bulletConditionScale or 0.5)) / 2, 1));
														else
															offhandItemTable:TakeCondition(math.max(conditionDamage / 100, 1));
														end
													else
														if dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT) then
															offhandItemTable:TakeCondition(math.max((conditionDamage * (offhandItemTable.bulletConditionScale or 0.5)), 1));
														else
															offhandItemTable:TakeCondition(math.max(conditionDamage / 50, 1));
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
						if enemywep:GetClass() == "begotten_fists" then
							if !Clockwork.player:HasFlags(attacker, "T") then
								local activeWeapon = ent:GetActiveWeapon();
								
								if (IsValid(activeWeapon) and activeWeapon:GetNWString("activeShield"):len() > 0) then
									local blockTable = GetTable(activeWeapon:GetNWString("activeShield"));
									
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
							
							if (IsValid(activeWeapon) and activeWeapon:GetNWString("activeShield"):len() > 0) then
								local blockTable = GetTable(activeWeapon:GetNWString("activeShield"));

								if blockTable.electrified then
									local wepBlockTable = GetTable(enemywep.BlockTable);
									
									if wepBlockTable["blockeffect"] == "MetalSpark" then
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
						
					if !ent:GetNWBool("Deflect", true) and ent:IsValid() and ent:Alive() and attacker:IsValid() then
						local poiseDamageModifier = 1;
						
						if attacker.HasBelief then
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
								if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor().isJavelin then
									-- nothing
								else
									poiseDamageModifier = poiseDamageModifier * 4;
								end
							end
						end
						
						if enemywep and enemywep:GetNWString("activeOffhand"):len() > 0 then
							if !IsValid(dmginfo:GetInflictor()) or !dmginfo:GetInflictor().isJavelin then
								poiseDamageModifier = poiseDamageModifier * 0.6;
							end
						end
						
						--print("PRE MODIFIER POISE DAMAGE: "..attacker.enemypoise);
					
						if attacker:IsPlayer() and enemyattacktable["poisedamage"] then
							if attacker:GetNWBool("Riposting") == true then
								attacker.enemypoise = (((enemyattacktable["poisedamage"]) * 3) * poiseDamageModifier)
							elseif attacker:GetNWBool("ThrustStance") == true then
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
									
									if activeWeapon:GetNWString("activeShield"):len() > 0 then
										newEnemyPoise = newEnemyPoise * 0.85;
									end
								end
								
								PoiseTotal = math.min(blocktable["poiseresistance"] - newEnemyPoise, 0);
							else
								PoiseTotal = math.min(blocktable["poiseresistance"] - attacker.enemypoise, 0);
							end
						elseif attacker:IsNPC() or attacker:IsNextBot() then
							if attacker.Damage then
								attacker.enemypoise = (attacker.Damage * 2) or 20;
							elseif attacker:GetClass() == "npc_animal_bear" then
								attacker.enemypoise = 55;
							elseif attacker:GetClass() == "npc_animal_cave_bear" then
								attacker.enemypoise = 70;
							else
								attacker.enemypoise = 20;
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
									
									if activeWeapon:GetNWString("activeShield"):len() > 0 then
										newEnemyPoise = newEnemyPoise * 0.85;
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
							ent:TakePoise(PoiseTotal);
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -5 and PoiseTotal >= -10 then
							--print "Tier 2" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(3,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -10 and PoiseTotal >= -15 then
							--print "Tier 3" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(5,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
						elseif PoiseTotal < -15 and PoiseTotal >= -20 then
							--print "Tier 4"
							dmginfo:ScaleDamage(0.05)
							ent:ViewPunch(Angle(7,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.05)
							end
						elseif PoiseTotal < -20 and PoiseTotal >= -25 then
							--print "Tier 5" 
							dmginfo:ScaleDamage(0.1)
							ent:ViewPunch(Angle(9,1,1))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.1)
							end
						elseif PoiseTotal < -25 and PoiseTotal >= -30 then
							--print "Tier 6" 
							dmginfo:ScaleDamage(0.15)
							ent:ViewPunch(Angle(12,3,2))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.15)
							end
						elseif PoiseTotal < -30 and PoiseTotal >= -35 then
							--print "Tier 7" 
							dmginfo:ScaleDamage(0.2)
							ent:ViewPunch(Angle(14,8,6))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.2)
							end
						elseif PoiseTotal < -35 and PoiseTotal >= -40 then
							--print "Tier 8" 
							dmginfo:ScaleDamage(0.25)
							ent:ViewPunch(Angle(25,10,9))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.25)
							end
						elseif PoiseTotal < -40 and PoiseTotal >= -45 then
							--print "Tier 9"
							dmginfo:ScaleDamage(0.3)
							ent:ViewPunch(Angle(35,12,10))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.3)
							end
						elseif PoiseTotal < -45 then
							--print "Tier 10" 
							dmginfo:ScaleDamage(0.35)
							ent:ViewPunch(Angle(50,15,25))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), attacker);
							end
							if enemyattacktable["attacktype"] == "fire_swing" then
								ent:Ignite(enemywep.IgniteTime * 0.35)
							end
						end
					elseif !ent:GetNWBool("Deflect", true) then
						dmginfo:ScaleDamage(0)
					end
					-- Poise system
			
					if !ent:GetNWBool("Deflect", true) then
						local melsta = ent:GetNWInt("meleeStamina");
						local blockamount = (blocktable["guardblockamount"])
						local melsa = melsta - blockamount;
						local chance = math.random(1, 2);
						--local chance = 1; -- for testing
						
						if cwBeliefs and ent.HasBelief and ent:HasBelief("encore") then
							chance = math.random(1, 4);
						end
						
						--ent:SetNWInt("meleeStamina", math.Clamp(melsa, 0, max_poise))

						if !dmginfo:IsDamageType(DMG_BULLET) and !dmginfo:IsDamageType(DMG_BUCKSHOT) then
							ent:TakePoise(blockamount);
						end
						
						if melsa <= blockamount and not ent:IsRagdolled() and chance == 1 then
							if ent:GetCharacterData("stability") < 70 then
								if wep:GetNWString("activeShield"):len() == 0 and not string.find(wep:GetClass(), "begotten_fists") and not string.find(wep:GetClass(), "begotten_claws") then
									local dropMessages = {" goes flying out of their hand!", " is knocked out of their hand!"};
									local itemTable = Clockwork.item:GetByWeapon(wep);
									
									if ent.opponent then
										if (itemTable:HasPlayerEquipped(ent)) then
											itemTable:OnPlayerUnequipped(ent);
											ent:RebuildInventory();
											ent:SetWeaponRaised(false);
										end
										
										Clockwork.chatBox:AddInTargetRadius(ent, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], ent:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
									else
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
				
					-- Deflection
					if ent:GetNWBool("Deflect", true) and (IsValid(attacker) and (dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(16) or (cwBeliefs and ent:HasBelief("impossibly_skilled") and IsValid(inflictor) and inflictor.isJavelin))) then
						if !attacker:IsPlayer() then
							if dmginfo:IsDamageType(128) then
								ent:EmitSound(blocksoundtable["deflectwood"][math.random(1, #blocksoundtable["deflectwood"])])
								--print "DEFLECT CRUSH"
							elseif dmginfo:IsDamageType(4) then
								ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
								--print "DEFLECT SLASH"
							elseif dmginfo:IsDamageType(16) then
								ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
								--print "DEFLECT PIERCE"
							elseif dmginfo:IsDamageType(1073741824) then
								ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
								--print "DEFLECT JAVELIN"
							end
						else
							if attacker:IsPlayer() then
								if enemywep.IsABegottenMelee == true and (!dmginfo:GetInflictor() or (dmginfo:GetInflictor() and !dmginfo:GetInflictor().isJavelin)) then
									if enemywep.SoundMaterial == "Metal" then
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
										if !cwBeliefs or not attacker:HasBelief("ingenuity_finisher") then
											if attacker:HasBelief("scour_the_rust") then
												weaponItemTable:TakeCondition(0.25);
											else
												weaponItemTable:TakeCondition(0.5);
											end
											
											local offhand = enemywep:GetNWString("activeOffhand");
											
											if offhand:len() > 0 then
												for k, v in pairs(attacker.equipmentSlots) do
													if v:IsTheSameAs(weaponItemTable) then
														local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
														
														if offhandItemTable then
															if cwBeliefs and attacker:HasBelief("scour_the_rust") then
																offhandItemTable:TakeCondition(math.max(dmginfo:GetDamage() / 100, 1));
															else
																offhandItemTable:TakeCondition(math.max(dmginfo:GetDamage() / 50, 1));
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
						end
						
						ent:SetNWBool("Deflect", false)
						
						if ent.HasBelief then
							local max_stability = ent:GetMaxStability();
							local deflectionPoisePayback = 10;
						
							if ent:HasBelief("sidestep") then
								deflectionPoisePayback = 35;
							elseif ent:HasBelief("deflection") then
								deflectionPoisePayback = 25;
							end
							
							if IsValid(inflictor) and inflictor:GetNWString("activeOffhand") then
								deflectionPoisePayback = math.Round(deflectionPoisePayback * 1.5);
							end
							
							ent:SetNWInt("meleeStamina", math.Clamp(ent:GetNWInt("meleeStamina", max_poise) + deflectionPoisePayback, 0, max_poise));
							ent:SetCharacterData("stability", math.Clamp(ent:GetCharacterData("stability", max_stability) + deflectionPoisePayback, 0, max_stability));
							ent:SetNWInt("stability", ent:GetCharacterData("stability", max_stability));
						end
						
						Clockwork.datastream:Start(ent, "Parried", 0.2)
						dmginfo:ScaleDamage(0) 
						
						-- Deflection "mini stun" effect
						if attacker:IsPlayer() then
							attacker:SetNWBool("Deflected", true);
							
							local delay = enemyattacktable["delay"];
							
							if ent.HasBelief then
								if ent:HasBelief("sidestep") then
									delay = enemyattacktable["delay"] + 2;
								elseif ent:HasBelief("deflection") then
									delay = enemyattacktable["delay"] + 1;
								end
							end
							
							if enemywep then
								enemywep:SetNextPrimaryFire(CurTime() + delay);
								
								-- Make sure offhand swing is aborted if deflected.
								if enemywep.Timers then
									if enemywep.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] then
										enemywep.Timers["offhandStrikeTimer"..tostring(attacker:EntIndex())] = nil;
									end
								end
							end
							
							--netstream.Start(attacker, "Stunned", (enemyattacktable["delay"]));
							netstream.Start(attacker, "MotionBlurStunned", (enemyattacktable["delay"]));
							
							timer.Simple(delay, function()
								if IsValid(attacker) then
									attacker:SetNWBool("Deflected", false);
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
								
							if attacker:GetNWBool("ThrustStance") == true and attacker:GetNWBool("Riposting") != true then
								ent:EmitSound(enemyattacksoundtable["althitbody"][math.random(1, #enemyattacksoundtable["althitbody"])])
								-- For sacrificial attacks (thrust)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), attacker);
								end
								if enemyattacktable["attacktype"] == "fire_swing" then
									ent:Ignite(enemywep.IgniteTime)
								end
							else
								local stabilityDamage = enemyattacktable["stabilitydamage"];
								
								if enemywep:GetNWString("activeOffhand"):len() > 0 then
									if !IsValid(inflictor) or !inflictor.isJavelin then
										stabilityDamage = stabilityDamage * 0.6;
									end
								end
								
								ent:TakeStability(stabilityDamage)		
								
								ent:EmitSound(enemyattacksoundtable["hitbody"][math.random(1, #enemyattacksoundtable["hitbody"])])
								-- For sacrificial attacks (regular)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), attacker);
								end
								if enemyattacktable["attacktype"] == "fire_swing" then
									ent:Ignite(enemywep.IgniteTime)
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
								local weaponItemTable = item.GetByWeapon(enemywep);
								
								if weaponItemTable then
									if !cwBeliefs or not attacker:HasBelief("ingenuity_finisher") then
										if cwBeliefs and attacker:HasBelief("scour_the_rust") then
											weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 200, 100));
										else
											weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
										end
										
										local offhand = enemywep:GetNWString("activeOffhand");
										
										if offhand:len() > 0 then
											for k, v in pairs(attacker.equipmentSlots) do
												if v:IsTheSameAs(weaponItemTable) then
													local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
													
													if offhandItemTable then
														if cwBeliefs and attacker:HasBelief("scour_the_rust") then
															offhandItemTable:TakeCondition(math.max(dmginfo:GetDamage() / 100, 1));
														else
															offhandItemTable:TakeCondition(math.max(dmginfo:GetDamage() / 50, 1));
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
					end;
				end
			end
		elseif !ent.iFrames then
			-- Deal damage to people using fists if they hit spiked armor.
			if attacker:IsPlayer() then
				local enemywep = attacker:GetActiveWeapon();
				
				if ent:IsPlayer() then
					-- Deal damage to people using fists if they hit spiked armor.
					if enemywep:IsValid() and enemywep:GetClass() == "begotten_fists" then
						if !Clockwork.player:HasFlags(attacker, "T") then
							if ent:GetModel() == "models/begotten/satanists/hellspike_armor.mdl" then
								attacker:TakeDamage(5, ent);
							end
						end
					end
				end
				
				-- If a beserker or a member of House Varazdat, gain HP back via lifeleech.
				if attacker:GetSubfaction() == "Varazdat" then
					if IsValid(enemywep) and enemywep.IsABegottenMelee then
						local clothesItem = attacker:GetClothesEquipped();
						local modifier = 2;
						
						if clothesItem then
							if clothesItem.weightclass == "Medium" then
								modifier = 3;
							elseif clothesItem.weightclass == "Heavy" then
								modifier = 4;
							end
						end
						
						attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + (dmginfo:GetDamage() / modifier)), 0, attacker:GetMaxHealth()));
						
						attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(attacker) then
								attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				else
					if IsValid(enemywep) and enemywep.IsABegottenMelee and enemywep:GetNWString("activeShield"):len() <= 0 then
						local clothesItem = attacker:GetClothesEquipped();
						
						if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "lifeleech") then
							attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + (dmginfo:GetDamage() / 2)), 0, attacker:GetMaxHealth()));
							
							attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
							
							timer.Simple(0.2, function()
								if IsValid(attacker) then
									attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
								end
							end);
						end
					end
				end
				
				if cwBeliefs and attacker.HasBelief and attacker:HasBelief("thirst_blood_moon") and !attacker.opponent then
					if cwDayNight and cwDayNight.currentCycle == "night" and attacker:GetCharacterData("LastZone") == "wasteland" then
						attacker:SetHealth(math.Clamp(math.ceil(attacker:Health() + (dmginfo:GetDamage() / 2)), 0, attacker:GetMaxHealth()));
						
						attacker:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(attacker) then
								attacker:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				end
				
				if not attacker.opponent then
					local enemywep = attacker:GetActiveWeapon();
					
					if enemywep then
						local weaponItemTable = item.GetByWeapon(enemywep);
						
						if weaponItemTable then
							if cwBeliefs and not attacker:HasBelief("ingenuity_finisher") then
								if attacker:HasBelief("scour_the_rust") then
									weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 200, 100));
								else
									weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
								end
								
								local enemyoffhand = enemywep:GetNWString("activeOffhand");
								
								if enemyoffhand:len() > 0 then
									for k, v in pairs(attacker.equipmentSlots) do
										if v:IsTheSameAs(weaponItemTable) then
											local offhandItemTable = attacker.equipmentSlots[k.."Offhand"];
											
											if offhandItemTable then
												if cwBeliefs and attacker:HasBelief("scour_the_rust") then
													offhandItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 200, 100));
												else
													offhandItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
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
					if IsValid(activeWeapon) and (activeWeapon.Base == "sword_swepbase") then
						if (activeWeapon.IronSights == true) then
							local loweredParryDebug = activeWeapon:GetNextSecondaryFire();
							local curTime = CurTime();
							
							if (loweredParryDebug < curTime) then
								local blocktable;
								
								if activeWeapon:GetNWString("activeOffhand"):len() > 0 then
									local offhandTable = weapons.GetStored(activeWeapon:GetNWString("activeOffhand"));
												
									if offhandTable then
										blocktable = GetDualTable(activeWeapon.realBlockTable, offhandTable.BlockTable);
									else
										blocktable = GetTable(activeWeapon.realBlockTable);
									end
								else
									blocktable = GetTable(activeWeapon.realBlockTable);
								end
								
								if (blockTable and player:GetNWInt("meleeStamina", 100) >= blockTable["guardblockamount"] and !player:GetNWBool("Parried")) then
									player:SetNWBool("Guardening", true);
									player.beginBlockTransition = true;
									player.StaminaRegenDelay = 0;
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
		for k, v in pairs (_player.GetAll()) do
			v:Give("begotten_fists");
			v:SelectWeapon("begotten_fists");
			v:Give("cw_senses")
		end;
	else
		Clockwork.player:NotifyAdmins("operator", "fucklet "..player:Name().." just tried to run atyd");
	end
end);