function Parry(target, dmginfo)
	if (target:IsPlayer()) then
		local wep = target:GetActiveWeapon()

		if (target:IsValid() and target:Alive() and (target:GetNWBool("Parry", false) == true) and IsValid(wep)) then
			local damageType = dmginfo:GetDamageType();
			local checkTypes = {[4] = true, [16] = true, [128] = true, [DMG_SNIPER] = true};

			if (checkTypes[damageType]) then
				local attacker = dmginfo:GetAttacker()
				
				target:SetNWBool("ParrySucess", true)
				attacker:SetNWBool("Parried", true)
				netstream.Start(target, "Parried", 0.2)
				netstream.Start(attacker, "Stunned", 3);
				dmginfo:SetDamage(0)
				target:EmitSound("meleesounds/DS2Parry.mp3")
				
				if attacker.CancelGuardening then
					attacker:CancelGuardening();
				end
				
				hook.Run("RunModifyPlayerSpeed", attacker, attacker.cwInfoTable, true);
				
				wep:SetNextPrimaryFire(0)
				
				if (wep.BlockSoundTable) then
					local blocksoundtable = GetSoundTable(wep.BlockSoundTable)
					target:EmitSound(blocksoundtable["blocksound"][math.random(1, #blocksoundtable["blocksound"])])
				end;

				if (IsValid(attacker) and attacker:IsPlayer()) then
					local attackerWeapon = attacker:GetActiveWeapon()
					local curTime = CurTime();
					
					if cwBeliefs and attacker.HasBelief and attacker:HasBelief("encore") then
						attackerWeapon:SetNextPrimaryFire(curTime + 1.5)
						attackerWeapon:SetNextSecondaryFire(curTime + 1.5)
					else
						attackerWeapon:SetNextPrimaryFire(curTime + 3)
						attackerWeapon:SetNextSecondaryFire(curTime + 3)
					end
				end
				
				if (wep.AttackTable) then
					local index = target:EntIndex();
					local attacktable = GetTable(wep.AttackTable)
					
					if (!target:IsRagdolled() and !target:GetNWBool("HasChangedWeapons", false)) then
						if (timer.Exists(index.."_ParrySuccessTimer")) then 
							timer.Destroy(index.."_ParrySuccessTimer")
						end
						
						target:SetNWBool("ParrySucess", true)
						local delay = (attacktable["delay"] + 1)
						
						timer.Create(index.."_ParrySuccessTimer", delay, 1, function()
							if (target:IsValid() --[[and target:Alive() and !target:IsRagdolled() and !target:GetNWBool("HasChangedWeapons", false) and (target:GetNWBool("ParrySucess", false) == true)]]) then
								target:SetNWBool("ParrySucess", false) 
							end
							
							if attacker:IsValid() then
								attacker:SetNWBool("Parried", false);
								
								hook.Run("RunModifyPlayerSpeed", attacker, attacker.cwInfoTable, true);
							end
						end)
					end
				end
			end
		end
	end
end	
hook.Add("PreEntityTakeDamage", "Parrying", Parry)
	
local function Guarding(ent, dmginfo)
	if (!ent:IsPlayer()) then
		return;
	end;
	
	if dmginfo:IsDamageType(DMG_DROWNRECOVER) then
		return;
	end;
	
	if ent:Alive() then
		local wep = ent:GetActiveWeapon()
		--local attacksoundtable = GetSoundTable(wep.AttackSoundTable)
		--local attacktable = GetTable(wep.AttackTable)
		local attacker = dmginfo:GetAttacker()
		local max_poise = ent:GetNWInt("maxMeleeStamina") or 90;

		if (ent:GetNWBool("Guardening") == true) then
			local damageinflictor = dmginfo:GetAttacker();
			local blocktable = GetTable(wep.BlockTable)
			local blocksoundtable = GetSoundTable(wep.BlockSoundTable)
			local blockthreshold = (blocktable["blockcone"] or 135) / 2;
			
			if blocktable["partialbulletblock"] == true and (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and (IsValid(attacker) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (attacker:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
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
		
			local canblock = false

			if ((blocktable["blockdamagetypes"])) then
				for _,v in ipairs((blocktable["blockdamagetypes"])) do
					if dmginfo:IsDamageType(v) then 
						canblock = true;
						break;
					end
				end
			end;
			
			if not canblock and wep.HoldType == "wos-begotten_dual" then
				if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_SNIPER) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and cwBeliefs and ent.HasBelief and ent:HasBelief("impossibly_skilled") then
					--dmginfo:ScaleDamage(0);
					canblock = true;
				end
			end

			if canblock then
				local enemywep = damageinflictor:GetActiveWeapon()
				local enemyattacktable = {}
				local PoiseTotal = 0;
				
				if (enemywep.AttackTable) then
					enemyattacktable = GetTable(enemywep.AttackTable)
				end;
				
				if dmginfo:IsDamageType(DMG_BULLET) then
					PoiseTotal = -math.Round(dmginfo:GetDamage() * 0.33);
					dmginfo:ScaleDamage(0);
				elseif dmginfo:IsDamageType(DMG_BUCKSHOT) then
					PoiseTotal = -math.Round(dmginfo:GetDamage());
					dmginfo:ScaleDamage(0);
				end

				if (IsValid(damageinflictor) and (math.abs(math.AngleDifference(ent:EyeAngles().y, (damageinflictor:GetPos() - ent:GetPos()):Angle().y)) <= blockthreshold)) then
					if enemywep.IsABegottenMelee == true then
						if ent:GetNWBool("Deflect") == true then
							damageinflictor:ViewPunch(Angle(-10,7,6))
						else
							damageinflictor:ViewPunch(Angle(-3,1,0))
						end
					end

					---- Block Sound
					if !damageinflictor:IsPlayer() and !ent:GetNWBool("Deflect", true) then
						if dmginfo:IsDamageType(128) then
							ent:EmitSound(blocksoundtable["blockwood"][math.random(1, #blocksoundtable["blockwood"])])
							--print "BLOCK NPC CRUSH"
						elseif dmginfo:IsDamageType(4) then
							ent:EmitSound(blocksoundtable["blockmetal"][math.random(1, #blocksoundtable["blockmetal"])])
							--print "BLOCK NPC SLASH"
						elseif dmginfo:IsDamageType(16) or dmginfo:IsDamageType(DMG_SNIPER) then
							ent:EmitSound(blocksoundtable["blockmetalpierce"][math.random(1, #blocksoundtable["blockmetalpierce"])])
							--print "BLOCK NPC PIERCE"
						elseif dmginfo:IsDamageType(2) or dmginfo:IsDamageType(1073741824) or dmginfo:IsDamageType(536870912) then
							ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
							--print "BLOCK NPC BULLET"
						end
					else
						if !ent:GetNWBool("Deflect", true) and damageinflictor:IsPlayer() and !dmginfo:IsDamageType(1073741824) then
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
									damageinflictor:Disorient(1)
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
							elseif dmginfo:IsDamageType(16) or dmginfo:IsDamageType(DMG_SNIPER) then
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
							
							if not damageinflictor.opponent then
								if enemywep then
									local weaponItemTable = item.GetByWeapon(enemywep);
									
									if weaponItemTable then
										if cwBeliefs and not damageinflictor:HasBelief("ingenuity_finisher") then
											weaponItemTable:TakeCondition(0.5);
										end
									end
								end
							end
						end
					end
					
					if not ent.opponent then
						if wep then
							local weaponItemTable = item.GetByWeapon(wep);
							local shieldEquipped = false;
							
							if ent.bgShieldData and ent.bgShieldData.uniqueID and ent.bgShieldData.realID then
								if IsValid(ent:GetWeapon(wep:GetClass())) and string.find(wep:GetClass(), ent.bgShieldData.uniqueID) then
									local shieldItem = Clockwork.inventory:FindItemByID(ent:GetInventory(), ent.bgShieldData.uniqueID, ent.bgShieldData.itemID);
									
									--printp(shieldItem:GetCondition());
									
									shieldEquipped = true;
									
									if cwBeliefs and not ent:HasBelief("ingenuity_finisher") then
										shieldItem:TakeCondition(math.max(dmginfo:GetDamage() / 50, 1));
									end
									
									--printp(shieldItem:GetCondition());
								end
							end
							
							if weaponItemTable and not shieldEquipped then
								if cwBeliefs and not ent:HasBelief("ingenuity_finisher") then
									weaponItemTable:TakeCondition(math.max(dmginfo:GetDamage() / 50, 1));
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
					
					-- Deal damage to people using fists if they hit a spiked shield.
					if ent:IsPlayer() and enemywep:IsValid() and enemywep:GetClass() == "begotten_fists" then
						if !Clockwork.player:HasFlags(damageinflictor, "T") then
							local activeWeapon = ent:GetActiveWeapon();
							
							if (IsValid(activeWeapon)) then
								if string.find(activeWeapon:GetClass(), "_shield8") then
									damageinflictor:TakeDamage(5, ent);
								end
							end
						end
					end
					
					-- Poise system
					
					--[[(For NPC Poise Damage WIP)
					if damageinflictor:IsValid() and (damageinflictor:IsNPC() or damageinflictor:IsNextBot()) and ent:IsValid() and ent:Alive() then
							--print (damageinflictor:GetClass())
					end
					--]]
						
					if !ent:GetNWBool("Deflect", true) and ent:IsValid() and ent:Alive() and damageinflictor:IsValid() then
						local poiseDamageModifier = 1;
						
						if damageinflictor.HasBelief then
							if damageinflictor:HasBelief("unrelenting") then
								poiseDamageModifier = poiseDamageModifier + 0.25;
							end

							if damageinflictor:HasBelief("fearsome_wolf") then
								if damageinflictor.warCryVictims then
									if table.HasValue(damageinflictor.warCryVictims, ent) then
										poiseDamageModifier = poiseDamageModifier + 0.15;
									end
								end
							end
						end
						
						if damageinflictor.bgCharmData and damageinflictor.HasCharmEquipped then
							if damageinflictor:HasCharmEquipped("ring_pummeler") then
								poiseDamageModifier = poiseDamageModifier + 0.15;
							end
							
							if damageinflictor:HasCharmEquipped("ring_pugilist") and enemywep:GetClass() == "begotten_fists" then
								if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor().isJavelin then
									-- nothing
								else
									poiseDamageModifier = poiseDamageModifier * 4;
								end
							end
						end
						
						--print("PRE MODIFIER POISE DAMAGE: "..damageinflictor.enemypoise);
					
						if damageinflictor:IsPlayer() and enemyattacktable["poisedamage"] then
							if damageinflictor:GetNWBool("Riposting") == true then
								damageinflictor.enemypoise = (((enemyattacktable["poisedamage"]) * 3) * poiseDamageModifier)
							elseif damageinflictor:GetNWBool("ThrustStance") == true then
								damageinflictor.enemypoise = (((enemyattacktable["poisedamage"]) * (enemyattacktable["altattackpoisedamagemodifier"])) * poiseDamageModifier)
							else
								damageinflictor.enemypoise = ((enemyattacktable["poisedamage"]) * poiseDamageModifier)
							end
							
							--print("POST MODIFIER POISE DAMAGE: "..damageinflictor.enemypoise);
							
							if ent.HasBelief then
								local newEnemyPoise = damageinflictor.enemypoise;
								
								if ent:HasBelief("warden") then
									newEnemyPoise = newEnemyPoise * 0.85;
								end
							
								if ent:HasBelief("fortitude_finisher") then
									newEnemyPoise = newEnemyPoise * 0.75;
								end 
								
								if ent:HasBelief("shieldwall") then
									local activeWeapon = ent:GetActiveWeapon();
									
									if string.find(activeWeapon:GetClass(), "_shield") then
										newEnemyPoise = newEnemyPoise * 0.85;
									end
								end
								
								PoiseTotal = math.min(blocktable["poiseresistance"] - newEnemyPoise, 0);
							else
								PoiseTotal = math.min(blocktable["poiseresistance"] - damageinflictor.enemypoise, 0);
							end
						elseif damageinflictor:IsNPC() or damageinflictor:IsNextBot() then
							if damageinflictor.Damage then
								damageinflictor.enemypoise = (damageinflictor.Damage * 2) or 20;
							elseif damageinflictor:GetClass() == "npc_animal_bear" then
								damageinflictor.enemypoise = 55;
							elseif damageinflictor:GetClass() == "npc_animal_cave_bear" then
								damageinflictor.enemypoise = 70;
							else
								damageinflictor.enemypoise = 20;
							end
							
							--print("POST MODIFIER POISE DAMAGE: "..damageinflictor.enemypoise);
							
							if ent.HasBelief then
								local newEnemyPoise = damageinflictor.enemypoise;
								
								if ent:HasBelief("warden") then
									newEnemyPoise = newEnemyPoise * 0.85;
								end
							
								if ent:HasBelief("fortitude_finisher") then
									newEnemyPoise = newEnemyPoise * 0.75;
								end 
								
								if ent:HasBelief("shieldwall") then
									local activeWeapon = ent:GetActiveWeapon();
									
									if string.find(activeWeapon:GetClass(), "_shield") then
										newEnemyPoise = newEnemyPoise * 0.85;
									end
								end
								
								PoiseTotal = math.min(blocktable["poiseresistance"] - newEnemyPoise, 0);
							else
								PoiseTotal = math.min(blocktable["poiseresistance"] - damageinflictor.enemypoise, 0);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
							end
						elseif PoiseTotal < -5 and PoiseTotal >= -10 then
							--print "Tier 2" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(3,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
							end
						elseif PoiseTotal < -10 and PoiseTotal >= -15 then
							--print "Tier 3" 
							dmginfo:ScaleDamage(0)
							ent:ViewPunch(Angle(5,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
							end
						elseif PoiseTotal < -15 and PoiseTotal >= -20 then
							--print "Tier 4"
							dmginfo:ScaleDamage(0.05)
							ent:ViewPunch(Angle(7,0,0))
							ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(2,6)..".wav")
							ent:TakePoise(PoiseTotal);
							ent:TakeStability(PoiseTotal)
							if enemyattacktable["attacktype"] == "ice_swing" then
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								ent:AddFreeze((PoiseTotal * -1) * (ent:WaterLevel() + 1), damageinflictor);
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
								if not string.find(wep:GetClass(), "_shield") and not string.find(wep:GetClass(), "begotten_fists") and not string.find(wep:GetClass(), "begotten_claws") then
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
											ent:TakeItem(itemTable, true)
											--ent:SelectWeapon("begotten_fists")
											ent:StripWeapon(wep:GetClass())
										end
									end
								end
							end
						end
					end
				
					-- Deflection
					if ent:GetNWBool("Deflect", true) and (IsValid(damageinflictor) and (dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(16) or (dmginfo:IsDamageType(DMG_SNIPER) and cwBeliefs and ent:HasBelief("impossibly_skilled")))) then
						if !damageinflictor:IsPlayer() then
							if dmginfo:IsDamageType(128) then
								ent:EmitSound(blocksoundtable["deflectwood"][math.random(1, #blocksoundtable["deflectwood"])])
								--print "DEFLECT CRUSH"
							elseif dmginfo:IsDamageType(4) then
								ent:EmitSound(blocksoundtable["deflectmetal"][math.random(1, #blocksoundtable["deflectmetal"])])
								--print "DEFLECT SLASH"
							elseif dmginfo:IsDamageType(16) or dmginfo:IsDamageType(DMG_SNIPER) then
								ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
								--print "DEFLECT PIERCE"
							elseif dmginfo:IsDamageType(1073741824) then
								ent:EmitSound(blocksoundtable["blockmissile"][math.random(1, #blocksoundtable["blockmissile"])])
								--print "DEFLECT JAVELIN"
							end
						else
							if damageinflictor:IsPlayer() then
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
								elseif dmginfo:IsDamageType(16) or dmginfo:IsDamageType(DMG_SNIPER) then
									ent:EmitSound(blocksoundtable["deflectmetalpierce"][math.random(1, #blocksoundtable["deflectmetalpierce"])])
									--print "deflect metalpierce 2"
								end
							end
							
							if not damageinflictor.opponent then
								if enemywep then
									local weaponItemTable = item.GetByWeapon(enemywep);
									
									if weaponItemTable then
										if cwBeliefs and not damageinflictor:HasBelief("ingenuity_finisher") then
											weaponItemTable:TakeCondition(0.5);
										end
									end
								end
							end
						end
						
						ent:SetNWBool("Deflect", false)
						
						local max_stability = ent:GetMaxStability();
						
						if ent.HasBelief then
							if ent:HasBelief("sidestep") then
								ent:SetNWInt("meleeStamina", math.Clamp(ent:GetNWInt("meleeStamina", max_poise) + 35, 0, max_poise));
								ent:SetCharacterData("stability", math.Clamp(ent:GetCharacterData("stability", max_stability) + 35, 0, max_stability));
							elseif ent:HasBelief("deflection") then
								ent:SetNWInt("meleeStamina", math.Clamp(ent:GetNWInt("meleeStamina", max_poise) + 25, 0, max_poise));
								ent:SetCharacterData("stability", math.Clamp(ent:GetCharacterData("stability", max_stability) + 25, 0, max_stability));
							else 
								ent:SetNWInt("meleeStamina", math.Clamp(ent:GetNWInt("meleeStamina", max_poise) + 10, 0, max_poise));
								ent:SetCharacterData("stability", math.Clamp(ent:GetCharacterData("stability", max_stability) + 10, 0, max_stability));
							end
						end
						
						Clockwork.datastream:Start(ent, "Parried", 0.2)
						dmginfo:ScaleDamage(0) 
						
						-- Deflection "mini stun" effect
						if damageinflictor:IsPlayer() then
							enemywep:SetNextPrimaryFire(CurTime() + (enemyattacktable["delay"]) + 1);
							if ent.HasBelief then
								if ent:HasBelief("deflection") then
									enemywep:SetNextPrimaryFire(CurTime() + (enemyattacktable["delay"]) + 2);
								elseif ent:HasBelief("deflection") then
									enemywep:SetNextPrimaryFire(CurTime() + (enemyattacktable["delay"]) + 3);
								end
							end
							--netstream.Start(damageinflictor, "Stunned", (enemyattacktable["delay"]));
							netstream.Start(damageinflictor, "MotionBlurStunned", (enemyattacktable["delay"]));
						end
					end
			
					dmginfo:SetDamagePosition(vector_origin)
				else				
					-- For being hit while blocking but outside of your blockcone (ex: hit in the back while blocking)
					if (ent:IsPlayer() and damageinflictor:IsPlayer()) then
						local attacker = dmginfo:GetAttacker();
						local trace = attacker:GetEyeTrace();
						local pos = ent:GetPos() + Vector(0,0, 50);
						
						if enemywep.IsABegottenMelee == true then
							local attackSoundTable = enemywep.AttackSoundTable;
							
							if dmginfo:IsDamageType(DMG_SNIPER) then
								attackSoundTable = "MetalSpearAttackSoundTable";
							end
							
							local enemyattacksoundtable = GetSoundTable(attackSoundTable)
							--print(enemyattacksoundtable["hitbody"][math.random(1, #enemyattacksoundtable["hitbody"])])
								
							if attacker:GetNWBool("ThrustStance") == true and attacker:GetNWBool("Riposting") != true then
								ent:EmitSound(enemyattacksoundtable["althitbody"][math.random(1, #enemyattacksoundtable["althitbody"])])
								-- For sacrificial attacks (thrust)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), damageinflictor);
								end
								if enemyattacktable["attacktype"] == "fire_swing" then
									ent:Ignite(enemywep.IgniteTime)
								end
							else
								ent:TakeStability(enemyattacktable["stabilitydamage"])		
								ent:EmitSound(enemyattacksoundtable["hitbody"][math.random(1, #enemyattacksoundtable["hitbody"])])
								-- For sacrificial attacks (regular)
								if enemyattacktable["attacktype"] == "ice_swing" then
									ent:AddFreeze((enemyattacktable["primarydamage"] * 1.5) * (ent:WaterLevel() + 1), damageinflictor);
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
									if cwBeliefs and not attacker:HasBelief("ingenuity_finisher") then
										weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
									end
								end
							end
						end
					end;
				end
			end
		elseif !ent.iFrames then
			local damageinflictor = dmginfo:GetAttacker();
			
			-- Deal damage to people using fists if they hit spiked armor.
			if damageinflictor:IsPlayer() then
				local enemywep = damageinflictor:GetActiveWeapon();
				
				if ent:IsPlayer() then
					-- Deal damage to people using fists if they hit spiked armor.
					if enemywep:IsValid() and enemywep:GetClass() == "begotten_fists" then
						if !Clockwork.player:HasFlags(damageinflictor, "T") then
							if ent:GetModel() == "models/begotten/satanists/hellspike_armor.mdl" then
								damageinflictor:TakeDamage(5, ent);
							end
						end
					end
				end
				
				-- If a beserker or a member of House Varazdat, gain HP back via lifeleech.
				if string.find(damageinflictor:GetModel(), "goreberzerker") then
					if IsValid(enemywep) and enemywep.IsABegottenMelee and not string.find(enemywep:GetClass(), "shield") then
						damageinflictor:SetHealth(math.Clamp(math.ceil(damageinflictor:Health() + (dmginfo:GetDamage() / 2)), 0, damageinflictor:GetMaxHealth()));
						
						damageinflictor:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(damageinflictor) then
								damageinflictor:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				elseif damageinflictor:GetSubfaction() == "Varazdat" then
					if IsValid(enemywep) and enemywep.IsABegottenMelee then
						local clothesItem = damageinflictor:GetClothesItem();
						local modifier = 2;
						
						if clothesItem then
							if clothesItem.weightclass == "Medium" then
								modifier = 3;
							elseif clothesItem.weightclass == "Heavy" then
								modifier = 4;
							end
						end
						
						damageinflictor:SetHealth(math.Clamp(math.ceil(damageinflictor:Health() + (dmginfo:GetDamage() / modifier)), 0, damageinflictor:GetMaxHealth()));
						
						damageinflictor:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(damageinflictor) then
								damageinflictor:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				end
				
				if cwBeliefs and damageinflictor.HasBelief and damageinflictor:HasBelief("thirst_blood_moon") and !damageinflictor.opponent then
					if cwDayNight and cwDayNight.currentCycle == "night" and damageinflictor:GetCharacterData("LastZone") == "wasteland" then
						damageinflictor:SetHealth(math.Clamp(math.ceil(damageinflictor:Health() + (dmginfo:GetDamage() / 2)), 0, damageinflictor:GetMaxHealth()));
						
						damageinflictor:ScreenFade(SCREENFADE.OUT, Color(100, 20, 20, 80), 0.2, 0.1);
						
						timer.Simple(0.2, function()
							if IsValid(damageinflictor) then
								damageinflictor:ScreenFade(SCREENFADE.IN, Color(100, 20, 20, 80), 0.2, 0);
							end
						end);
					end
				end
				
				if not damageinflictor.opponent then
					local enemywep = damageinflictor:GetActiveWeapon();
					
					if enemywep then
						local weaponItemTable = item.GetByWeapon(enemywep);
						
						if weaponItemTable then
							if cwBeliefs and not damageinflictor:HasBelief("ingenuity_finisher") then
								weaponItemTable:TakeCondition(math.min(dmginfo:GetDamage() / 100, 100));
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
								local blockTable = GetTable(activeWeapon.BlockTable);
								
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