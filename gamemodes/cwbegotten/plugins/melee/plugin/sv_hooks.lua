--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local voltistSounds = {
	["death"] = {"npc/fast_zombie/wake1.wav", "npc/fast_zombie/leap1.wav", "npc/fast_zombie/fz_alert_close1.wav", "npc/fast_zombie/fz_frenzy1.wav", "npc/headcrab/attack2.wav", "npc/headcrab/attack3.wav", "npc/headcrab_poison/ph_rattle3.wav", "npc/headcrab_poison/ph_poisonbite3.wav"},
	["pain"] = {"npc/headcrab/die2.wav", "npc/headcrab_poison/ph_warning1.wav", "npc/headcrab_poison/ph_scream2.wav", "npc/antlion/pain1.wav", "npc/antlion/pain2.wav", "npc/assassin/ball_zap1.wav", "npc/barnacle/barnacle_die1.wav", "npc/scanner/cbot_discharge1.wav", "npc/scanner/cbot_energyexplosion1.wav"},
};

-- Called to do make fancy melee effects.
function cwMelee:DoMeleeHitEffects(entity, attacker, inflictor, position, originalDamage, damageInfo)
	if (IsValid(entity) and IsValid(attacker)) then
		if entity:IsPlayer() and (!entity:Alive() or entity.iFrames) or damageInfo:IsDamageType(DMG_CRUSH) then
			return;
		end

		local canblock = false;
		
		if entity:IsPlayer() then
			if cwPowerArmor and --[[entity:IsWearingPowerArmor()]] entity.wearingPowerArmor then
				entity:EmitSound("armor/generic_lowdamage_0"..math.random(1,6)..".wav");
				entity:EmitSound("armor/plate_damage_0"..math.random(1,7)..".wav");
				
				local effectData = EffectData();
					effectData:SetOrigin(position);
					effectData:SetEntity(entity);
					effectData:SetAttachment(5);
					effectData:SetScale(16);
				util.Effect("MetalSpark", effectData, true, true);
				
				return;
			end

			local entWeapon = entity:GetActiveWeapon();
			
			if IsValid(entWeapon) and !entWeapon.noDisarm and (entWeapon.Base == "begotten_firearm_base" or (entWeapon.isMeleeFirearm and !entity:GetNetVar("ThrustStance")) or entWeapon.isJavelin) and !entity:GetNetVar("Guardening") then
				if !(entWeapon.isJavelin and cwBeliefs and entity:GetNetVar("ThrustStance") and entity:HasBelief("strength")) then
					local dropMessages = {" goes flying out of their hand!", " is knocked out of their hand!"};
					local itemTable = Clockwork.item:GetByWeapon(entWeapon);
					
					if itemTable then
						if entity.opponent then
							if (itemTable:HasPlayerEquipped(entity)) then
								itemTable:OnPlayerUnequipped(entity);
								entity:RebuildInventory();
								entity:SetWeaponRaised(false);
							end
							
							Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
						else
							itemTable:TakeCondition(10);
						
							local dropPos = entity:GetPos() + Vector(0, 0, 35) + entity:GetAngles():Forward() * 4;
							local itemEntity = Clockwork.entity:CreateItem(entity, itemTable, dropPos);
							
							if (IsValid(itemEntity)) then
								entity:TakeItem(itemTable);
								entity:SelectWeapon("begotten_fists");
								entity:StripWeapon(entWeapon:GetClass());
								
								Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s "..itemTable.name..dropMessages[math.random(1, #dropMessages)], entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
							end
						end
					else
						entity:SelectWeapon("begotten_fists");
						entity:StripWeapon(entWeapon:GetClass());
					
						Clockwork.chatBox:AddInTargetRadius(entity, "me", "'s "..entWeapon.PrintName..dropMessages[math.random(1, #dropMessages)], entity:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
					end
				end
			end
		
			if entity:GetNetVar("Guardening") then
				if attacker:IsNPC() or attacker:IsNextBot() then
					if IsValid(entWeapon) and entWeapon.BlockTable then
						local blocktable = GetTable(entWeapon.BlockTable)
				
						if blocktable and table.HasValue(blocktable["blockdamagetypes"], damageInfo:GetDamageType()) then
							canblock = true;
						end
					end
				elseif IsValid(inflictor) then
					if IsValid(entWeapon) and entWeapon.BlockTable then
						local blocktable = GetTable(entWeapon.BlockTable)
						
						if blocktable then
							for i = 1, #blocktable["blockdamagetypes"] do
								if damageInfo:IsDamageType(blocktable["blockdamagetypes"][i]) then
									canblock = true;
									break;
								end
							end
						end
					end
				end
			end
		end
		
		if entity:IsNPC() or entity:IsNextBot() or (entity:IsPlayer() and (!entity:GetNetVar("Guardening") or (entity:GetNetVar("Guardening") and !canblock)) and (!entity:GetNetVar("Parry") == true)) or entity.isTrainingDummy then
			local victimPosition = entity:GetPos();
			local position = victimPosition;
			
			if entity:IsPlayer() and not entity:IsRagdolled() then
				position = victimPosition + Vector(0, 0, 50);
			end
			
			if attacker:IsPlayer() then
				local trace = attacker:GetEyeTrace();
				local traceDistance = trace.HitPos:Distance(victimPosition);
				
				if (traceDistance < 64 and !trace.Entity:IsWorld()) then
					position = trace.HitPos;
				end;
			end
			
			--local armorSound = "vo/k_lab/kl_fiddlesticks.wav";
			local armorSound = "physics/body/body_medium_break2.wav";
			local effectName = "bleedingsplat";
			local material = entity.ArmorMaterial;
			
			local hitbody = "physics/body/body_medium_break2.wav";
			local althitbody = "physics/body/body_medium_break4.wav";
			local didthrust = false;
			local playlowdamage = false;
			local attackerWeapon = attacker:GetActiveWeapon();

			if inflictor and IsValid(inflictor) then
				if (inflictor.AttackSoundTable) then
					local attackSoundTable = GetSoundTable(inflictor.AttackSoundTable)
					
					if attacker:GetNetVar("ThrustStance") == true and !attackerWeapon.ChoppingAltAttack then
						didthrust = true;
					end;
					
					if (attackSoundTable["althitbody"]) then
						althitbody = attackSoundTable["althitbody"][math.random(1, #attackSoundTable["althitbody"])];
					end;
					
					if (attackSoundTable["hitbody"]) then
						hitbody = attackSoundTable["hitbody"][math.random(1, #attackSoundTable["hitbody"])];
					end;
				end;
			end;
			
			armorSound = hitbody;
			
			local damage = damageInfo:GetDamage();

			if (entity:IsPlayer()) then
				local armorTable = entity:GetClothesEquipped();

				if (armorTable) then
					local hitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
					
					if !armorTable.effectiveLimbs or (armorTable.effectiveLimbs and armorTable.effectiveLimbs[hitGroup]) then
						if (armorTable.hitParticle) then
							effectName = armorTable.hitParticle;
						end;
	 
						if (armorTable.type) then
							material = armorTable.type;
						end;
						
						if attacker:IsPlayer() then
							if (armorTable.attributes) and table.HasValue(armorTable.attributes, "electrified") then
								if IsValid(inflictor) and inflictor.BlockTable then
									local clothesItem = attacker:GetClothesEquipped();
									
									if (inflictor:GetClass() == "begotten_fists" and clothesItem and (clothesItem.type == "chainmail" or clothesItem.type == "plate")) or (inflictor.SoundMaterial == "Metal" or inflictor.SoundMaterial == "MetalPierce") then
										local shockDamageInfo = DamageInfo();
										
										shockDamageInfo:SetDamage(10);
										
										Schema:DoTesla(attacker, false);
										attacker:TakeDamageInfo(shockDamageInfo);
									end
								end
							end
						end
					end;
				end;
			end;

			if (material) then
				material = string.lower(material);
				
				if (material == "cloth") then
					armorSound = "armor/cloth_damage_0"..math.random(1,7)..".wav";
				elseif (material == "chainmail") then
					armorSound = "armor/chainmail_damage_0"..math.random(1,7)..".wav";
				elseif (material == "leather") then
					armorSound = "armor/leather_damage_0"..math.random(1,9)..".wav";
				elseif (material == "plate") then
					armorSound = "armor/plate_damage_0"..math.random(1,7)..".wav";
				end;
			end;
			
			if (damage > 15) then
				effectName = "bloodsplat";
				
				if didthrust and attacker:GetNetVar("Riposting") != true then
					armorSound = althitbody;
				else
					armorSound = hitbody;
				end;
			elseif material == "chainmail" or material == "plate" or material == "leather" then
				if entity:IsNextBot() then
					effectName = "MetalSpark";
				end
				
				playlowdamage = true;
			end;
			
			if (entity:IsPlayer()) then
				local hitGroup = Clockwork.kernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());

				if (hitGroup == HITGROUP_HEAD) then
					if not entity:IsRagdolled() then
						position = victimPosition + Vector(0, 0, 70);
					end
				
					local helmetItem = entity:GetHelmetEquipped();

					if (!helmetItem) then
						local clothesItem = entity:GetClothesEquipped();
						
						if clothesItem and clothesItem.effectiveLimbs and clothesItem.effectiveLimbs[hitGroup] then
							if (clothesItem.type) then
								local material = clothesItem.type;
								
								if (material) then
									material = string.lower(material);
								
									if (material == "cloth") then
										armorSound = "armor/cloth_damage_0"..math.random(1,7)..".wav";
									elseif (material == "chainmail") then
										armorSound = "armor/chainmail_damage_0"..math.random(1,7)..".wav";
									elseif (material == "leather") then
										armorSound = "armor/leather_damage_0"..math.random(1,9)..".wav";
									elseif (material == "plate") then
										armorSound = "armor/plate_damage_0"..math.random(1,7)..".wav";
									end;
								else
									armorSound = hitbody
								end
							end;
							
							if (damage > 15) then
								effectName = "bloodsplat";
								
								if didthrust and attacker:GetNetVar("Riposting") != true then
									armorSound = althitbody;
								else
									armorSound = hitbody;
								end;
								
								playlowdamage = false;
							elseif clothesItem and clothesItem.hitParticle then
								effectName = clothesItem.hitParticle;
								playlowdamage = true;
							end
						else
							armorSound = hitbody
							effectName = "bleedingsplat";
							
							if (damage > 15) then
								effectName = "bloodsplat"
								playlowdamage = false;
							end;
							
							if didthrust and attacker:GetNetVar("Riposting") != true then
								armorSound = althitbody
							end
						end
					elseif (helmetItem) then
						local headMat = helmetItem.type;
						
						if (headMat) then
							headMat = string.lower(headMat);
						
							if (headMat == "cloth") then
								armorSound = "armor/cloth_damage_0"..math.random(1,7)..".wav";
							elseif (headMat == "chainmail") then
								armorSound = "armor/chainmail_damage_0"..math.random(1,7)..".wav";
							elseif (headMat == "leather") then
								armorSound = "armor/leather_damage_0"..math.random(1,9)..".wav";
							elseif (headMat == "plate") then
								armorSound = "armor/plate_damage_0"..math.random(1,7)..".wav";
							end;
						else
							armorSound = hitbody
						end
						
						if (damage > 15) then
							effectName = "bloodsplat";
							
							if didthrust and attacker:GetNetVar("Riposting") != true then
								armorSound = althitbody;
							else
								armorSound = hitbody;
							end;
							
							playlowdamage = false;
						elseif helmetItem.hitParticle then
							effectName = helmetItem.hitParticle;
							playlowdamage = true;
						end
					end;
				end;
			end;

			if effectName ~= "bleedingsplat" or damage > 0 then
				local effectData = EffectData();
					effectData:SetOrigin(position);
					effectData:SetEntity(entity);
					effectData:SetAttachment(5);
					effectData:SetScale(16);
				util.Effect(effectName, effectData, true, true);
			end
			
			local distance = attacker:GetPos():Distance(entity:GetPos())
			
			--printp("\nSV HOOKS DISTANCE: "..tostring(distance));
			
			if inflictor and IsValid(inflictor) then
				local class = inflictor:GetClass()
				local attackerWeapon = attacker:GetActiveWeapon();
				local attacktable = GetTable(attackerWeapon.AttackTable)
								
				if (string.find(class, "begotten_spear_")) then
					local maxPoleRange = (attacktable["meleerange"]) * 0.1
					local maxIneffectiveRange = maxPoleRange * 0.65

					if (distance > maxIneffectiveRange) or attacker:GetNetVar("Riposting") then
						entity:EmitSound(armorSound)
						
						if playlowdamage then
							entity:EmitSound("armor/generic_lowdamage_0"..math.random(1,6)..".wav");
						end
					elseif (distance <= maxIneffectiveRange) then -- Spear
						entity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2, 6)..".wav");
					end;
				elseif (string.find(class, "begotten_polearm_")) or (string.find(class, "begotten_scythe_")) then
					local maxPoleRange = (attacktable["meleerange"]) * 0.1
					local maxIneffectiveRange = maxPoleRange * 0.65

					if (distance <= maxIneffectiveRange) then -- Polearm
						if attacker:GetNetVar("Riposting") then
							entity:EmitSound(armorSound);
						elseif didthrust and inflictor.CanSwipeAttack then
							entity:EmitSound(althitbody);
						else
							entity:EmitSound( "physics/body/body_medium_impact_hard"..math.random(2, 6)..".wav", 80);
						end
					else
						if attacker:GetNetVar("Riposting") then
							entity:EmitSound(hitbody);
						elseif didthrust and inflictor.CanSwipeAttack then
							entity:EmitSound(althitbody);
						else
							entity:EmitSound(armorSound)
						end
					end;
				else -- Non-spear
					entity:EmitSound(armorSound)
					
					if playlowdamage then
						entity:EmitSound("armor/generic_lowdamage_0"..math.random(1,6)..".wav");
					end
				end;
			else -- Non-spear
				entity:EmitSound(armorSound)

				if playlowdamage then
					entity:EmitSound("armor/generic_lowdamage_0"..math.random(1,6)..".wav");
				end
			end
		end;
	end;
end;

local bannerIds = {
	"begotten_polearm_glazicbanner",
	"begotten_polearm_hillkeepersignum",
}

function cwMelee:PlayerHasBanner(player)
	local weapon = player:GetActiveWeapon()
	if(!IsValid(weapon)) then return false end
	if(#weapon:GetNW2String("activeShield", "") > 0) then return false end

	if(weapon.bannerType) then return weapon
	else
		-- If the player's armor has Blessing of the Banner, they don't need the banner actively out in order to have the effect.
		local clothes = player:GetClothesEquipped()
		if(clothes and clothes.attributes and table.HasValue(clothes.attributes, "banner_blessing")) then
			for _, v in pairs(bannerIds) do
				local wep = player:GetWeapon(v)
				if(IsValid(wep)) then return wep end

			end

		end

	end

	return false

end

local bannerDistance = (824 * 824);
function cwMelee:HandleBanners(player, curTime)
	if(player.nextBannerCheck and player.nextBannerCheck > curTime) then return end
	player.nextBannerCheck = curTime + 2

	if(!player:Alive()) then return end

	local index = player:EntIndex()

	local banner = self:PlayerHasBanner(player)
	if(!banner) then
		if(player.hadBanner) then
			player.hadBanner = false

			for _, v in _player.Iterator() do
				if(v.banners and v.banners[index]) then v.banners[index] = nil end

			end

		end

		return

	end

	player.hadBanner = true

	local playerPos = player:GetPos()
	for _, v in _player.Iterator() do
		if(!v:Alive()) then continue end

		if(!v.banners) then v.banners = {} end
		
		if(playerPos:DistToSqr(v:GetPos()) <= bannerDistance) then v.banners[index] = banner.bannerType
		elseif v.banners[index] then v.banners[index] = nil end

	end

end

-- Called at an interval while a player is connected.
function cwMelee:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if !initialized then
		return;
	end

	self:HandleBanners(player, curTime)
		
	if (!plyTab.nextStability or plyTab.nextStability < curTime) then
		local max_stability = player:GetMaxStability();
		local stability = player:GetCharacterData("stability", max_stability);

		if player:GetNetVar("freeze") > 0 and !player:GetNWBool("bliz_frozen") then
			if player:IsOnFire() then
				player:TakeFreeze(50);
			else
				player:TakeFreeze(1);
			end
		end
		
		if (stability >= max_stability or player:IsRagdolled() or (plyTab.stabilityCooldown and plyTab.stabilityCooldown > curTime)) then
			plyTab.nextStability = curTime + 1;
			return;
		end;

		local armorClass = player:GetArmorClass();
		local stabilityDelay = 2;
		local falloverTime = 5;
		
		--printp(armorClass);

		if (armorClass == "Medium") then
			stabilityDelay = 6;
			falloverTime = 5;
		elseif (armorClass == "Heavy") then
			stabilityDelay = 7;
			falloverTime = 7;
		end;
		
		if player:HasBelief("litheness_finisher") then
			stabilityDelay = stabilityDelay * 0.8;
		end
		
		--printp(stabilityDelay);
		
		if (stability <= 0 and !player:IsRagdolled()) then
			self:PlayerStabilityFallover(player, falloverTime);
			return;
		end;
		
		player:SetCharacterData("stability", math.Clamp(stability + 5, 0, max_stability));
		plyTab.nextStability = curTime + stabilityDelay;
	end;
	
	-- this needs to be made clientside
	
	local playedBreathing = false;

	if (!plyTab.nextBreathingCheck or plyTab.nextBreathingCheck < curTime) then
		plyTab.nextBreathingCheck = curTime + 0.6;
	
		if (alive) and !plyTab.possessor then
			--local max_poise = player:GetMaxPoise();
			--local poise = player:GetNWInt("meleeStamina", max_poise);
			local max_stamina = player:GetMaxStamina();
			local stamina = player:GetNWInt("Stamina", max_stamina);
			
			--if (poise < max_poise * 0.8) then
			if (stamina < max_stamina * 0.6) then
				if (!plyTab.BreathingSoundsa) then
					plyTab.BreathingSoundsa = CreateSound(player, "breathing1.wav");
				end
				
				if (!plyTab.nextBreathing or curTime >= plyTab.nextBreathing) then
					local gender = player:GetGender();
					local pitch = 90;
					
					if (gender == GENDER_FEMALE) then
						pitch = 125;
					end;
					
					--plyTab.nextBreathing = curTime + (0.50 + ((1.25 / max_poise) * poise));
					--plyTab.BreathingSoundsa:PlayEx(0.15 - ((0.15 / max_poise) * poise), pitch);
					plyTab.nextBreathing = curTime + (0.50 + ((1.25 / max_stamina) * stamina));
					plyTab.BreathingSoundsa:PlayEx(0.15 - ((0.15 / max_stamina) * stamina), pitch);
				end;
				
				playedBreathing = true;
			end;
		else
			if plyTab.BreathingSoundsa then
				plyTab.BreathingSoundsa:Stop();
				plyTab.BreathingSoundsa = nil;
			end
		end;
		
		if (!playedBreathing and plyTab.BreathingSoundsa) then
			plyTab.BreathingSoundsa:FadeOut(2);
			plyTab.BreathingSoundsa = nil;
		end;
	end;
end;

-- Called when a player falls over because they ran out of stability.
function cwMelee:PlayerStabilityFallover(player, falloverTime, bNoBoogie, bNoText)
	local curTime = CurTime();
	
	if !falloverTime then
		falloverTime = 5;
	end
	
	if player:GetCharacterData("stability", 100) > 0 then
		player:SetCharacterData("stability", 0);
		player:SetNWInt("stability", 0);
	end

	Clockwork.player:SetRagdollState(player, RAGDOLL_FALLENOVER, falloverTime);
	player.stabilityCooldown = curTime + (falloverTime - 5);
	player.stabilityStunned = true;
	
	if (!bNoBoogie) then
		timer.Simple(FrameTime() * 2, function()
			local ragdollEntity = player:GetRagdollEntity();
			
			if (IsValid(ragdollEntity)) then
				ragdollEntity:Fire("startragdollboogie")
				
				timer.Simple(5, function()
					if (IsValid(ragdollEntity)) then
						ragdollEntity:Fire("startragdollboogie")
					end;
				end);
			end;
		end);
	end;
	
	timer.Simple(falloverTime, function()
		if IsValid(player) then
			player.stabilityStunned = false;
		end
	end);
	
	local gender = player:GetGender() == GENDER_MALE and "his" or "her";
	
	if !bNoText then
		local randomPhrases = {
			"is knocked off #HIS feet!",
			"loses #HIS footing and falls to the ground!",
			"is violently knocked to the ground!",
			"is slammed hard and falls down!",
		}
		
		local phrase = randomPhrases[math.random(1, #randomPhrases)];
		local faction = (player:GetNetVar("kinisgerOverride") or player:GetFaction());
		local subfaction = (player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction());
		local pitch = 100;
		
		phrase = string.gsub(phrase, "#HIS", gender);
		Clockwork.chatBox:AddInTargetRadius(player, "me", string.gsub(phrase, "^.", string.lower), player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	end
	
	if IsValid(player.possessor) then
		pitch = 50;
	elseif gender == "his" then
		pitch = math.random(95, 110);
	else
		pitch = math.random(100, 115);
	end

	if (!Clockwork.player:HasFlags(player, "M")) then
		if player:GetSubfaith() == "Voltism" and cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
			player:EmitSound(voltistSounds["pain"][math.random(1, #voltistSounds["pain"])], 90, 150);
		else
			if (faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers") then
				if (gender == "his") then
					player:EmitSound("voice/man2/man2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Holy Hierarchy") then
				if (gender == "his") then
					if subfaction == "Low Ministry" then
						player:EmitSound("lmpainsounds/lm_stun" .. math.random(1, 4) .. ".mp3", 90, pitch)
					else
						player:EmitSound("voice/man4/man4_stun0"..math.random(1, 4)..".wav", 90, pitch)
					end
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "The Third Inquisition") then
				if (gender == "his") then
					player:EmitSound("voice/man4/man4_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female1/female1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Goreic Warrior") then
				if (gender == "his") then
					player:EmitSound("voice/man1/man1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Hillkeeper") then
				if (gender == "his") then
					player:EmitSound("hkpainsounds/hk_stun"..math.random(1, 4)..".mp3", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			elseif (faction == "Smog City Pirate") then
				if (gender == "his") then
					player:EmitSound("voice/man1/man1_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			else
				if (gender == "his") then
					player:EmitSound("voice/man3/man3_stun0"..math.random(1, 4)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female2/female2_stun0"..math.random(1, 4)..".wav", 90, pitch)
				end
			end
		end
	end

	if (!Clockwork.player:HasFlags(player, "M")) then
		if player:GetSubfaith() == "Voltism" and cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
			return;
		end
		
		timer.Simple(math.Rand(0.5, 3), function()
			if (player:IsValid() and player:Alive() and player:Health() <= 50) then
				if (gender == "his") then
					player:EmitSound("voice/male_fear0"..math.random(1, 8)..".wav", 90, pitch)
					player.nextPainSound = curTime + 0.5
				else
					player:EmitSound("voice/female_fear0"..math.random(1, 8)..".wav", 90, pitch)
					player.nextPainSound = curTime + 0.5
				end
			end
		end)
	end
end;

-- Called when a player has been unragdolled.
function cwMelee:PlayerUnragdolled(player, state, ragdoll)
	if player:Alive() then
		if player:GetCharacterData("stability", 100) <= 0 then
			player:SetCharacterData("stability", 80);
			player:SetNWInt("stability", 80);
			player.nextStability = CurTime() + 3;
		end
	end
end

-- Called when a player attempts to switch to a character.
function cwMelee:PlayerCanSwitchCharacter(player, character)
	if (player:Alive() and player:IsRagdolled()) then
		return "You cannot switch characters while you are fallen over!";
	end;
end;

-- Called when the character data is saved.
function cwMelee:PlayerSaveCharacterData(player, data)
	if (data["stability"]) then
		data["stability"] = math.Round(data["stability"]);
	end;
end;

-- Called when the character data is restored.
function cwMelee:PlayerRestoreCharacterData(player, data)
	if (data["stability"]) then
		data["stability"] = math.Clamp(data["stability"], 5, player:GetMaxStability()) or player:GetMaxStability();
	else
		data["stability"] = player:GetMaxStability();
	end;
	
	--[[if (!data["maxMeleeStamina"]) then
		data["maxMeleeStamina"] = player:GetMaxPoise();
	end;]]--
	
	--[[if (!data["meleeStamina"]) then
		data["meleeStamina"] = player:GetMaxPoise();
	end;]]--
end;

-- Called just after the player spawns in.
function cwMelee:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		local max_stability = player:GetMaxStability();
		--local max_poise = player:GetMaxPoise();
	
		if (!firstSpawn) then
			player:SetNWInt("stability", max_stability);
			player:SetCharacterData("stability", max_stability);
			player.nextPainSound = CurTime() + 0.5
		end
		
		player:SetLocalVar("maxStability", max_stability);
		--player:SetLocalVar("maxMeleeStamina", max_poise);
		--player:SetNWInt("meleeStamina", max_poise);
		player:SetLocalVar("freeze", 0);
	end;
end;

-- Called just after the player dies.
function cwMelee:PostPlayerDeath(player)
	local max_stability = player:GetMaxStability();
	--local max_poise = player:GetMaxPoise();
	
	player:SetCharacterData("stability", max_stability);
	player:SetNWInt("stability", max_stability);
	player:SetLocalVar("maxStability", max_stability);
	--player:SetLocalVar("maxMeleeStamina", max_poise);
	--player:SetNWInt("meleeStamina", max_poise);
	player:SetLocalVar("freeze", 0);
end;

-- Called every half second.
function cwMelee:OnePlayerHalfSecond(player, curTime, infoTable)
	local stability = player:GetCharacterData("stability", 100);
	local stabilityNetVar = player:GetNWInt("stability", 100);
	
	if (stability != stabilityNetVar) then
		player:SetNWInt("stability", math.Round(stability));
	end;
end;

-- Called when a player disconnects.
function cwMelee:PlayerDisconnected(player)
	-- getting moved to the client
	if (player.BreathingSoundsa) then
		player.BreathingSoundsa:Stop();
		player.BreathingSoundsa = nil;
	end;
end;

-- Called when a player switches their weapon. 
function cwMelee:PlayerSwitchWeapon(player, oldWeapon, newWeapon)
	hook.Run("PrePlayerLowerWeapon", player, oldWeapon, newWeapon);

	if (player:IsWeaponRaised()) then
		if IsValid(oldWeapon) and oldWeapon.IsABegottenMelee then
			if oldWeapon:GetNextPrimaryFire() > CurTime() then 
				return true;
			end
		end
	
		player:SetWeaponRaised(false);
	end;
end;

-- Called when a player wants to fallover.
function cwMelee:PlayerCanFallover(player)
	if player:GetNWBool("bliz_frozen") == true then
		return false;
	end
end

-- Called when a player attempts to use an item.
function cwMelee:PlayerCanUseItem(player, itemTable, noMessage)
	if player:GetNWBool("bliz_frozen") == true then
		Schema:EasyText(player, "firebrick", "You cannot use items while you are frozen!");
	
		return false;
	end
end;

-- Called when an entity has taken damage (runs after belief calculations but before FuckMyLife).
function cwMelee:EntityTakeDamageAfter(entity, damageInfo)
	if damageInfo and (entity:IsPlayer() or entity.isTrainingDummy) then
		local attacker = damageInfo:GetAttacker();
		local damage = damageInfo:GetDamage();
		local didthrust = false;

		if attacker:GetNetVar("ThrustStance") == true then
			didthrust = true;
		end;
	
		if damageInfo:IsDamageType(DMG_BURN) then
			entity:TakeFreeze(damageInfo:GetDamage())
			
			if entity:GetNWBool("bliz_frozen") and IsValid(entity.freezeEnt) then
				entity.freezeEnt:Remove();
				entity.freezeEnt = nil;
			end
		elseif entity:GetNWBool("bliz_frozen") then
			damageInfo:ScaleDamage(0.3);
		end
		
		if IsValid(attacker) then
			if attacker:IsPlayer() then
				local attackerWeapon = damageInfo:GetInflictor();
				
				if !IsValid(attackerWeapon) or !attackerWeapon:IsWeapon() then
					attackerWeapon = attacker:GetActiveWeapon();
				end
			
				if IsValid(attackerWeapon) then
					local weaponItemTable = item.GetByWeapon(attackerWeapon);
					
					if weaponItemTable and weaponItemTable.attributes and table.HasValue(weaponItemTable.attributes, "grounded") then
						if attacker:IsRunning() then
							damageInfo:ScaleDamage(0.4);
						end
						
						if entity:IsPlayer() and (!attacker:GetNetVar("Parried") and !attacker:GetNetVar("Deflected")) then
							local distance = attacker:GetPos():Distance(entity:GetPos())
							local attacktable = GetTable(attackerWeapon.AttackTable)
							local maxPoleRange = (attacktable["meleerange"]) * 0.1
							local maxIneffectiveRange = maxPoleRange * 0.65

							if distance >= maxIneffectiveRange or (didthrust and attackerWeapon.CanSwipeAttack) then
								entity:SetNetVar("runningDisabled", true);
								
								timer.Create("GroundedSprintTimer_"..tostring(entity:EntIndex()), 3, 1, function()
									if IsValid(entity) then
										entity:SetNetVar("runningDisabled", nil);
									end 
								end);
							end
						end
					end
				end
			end
		end
		
		if damageInfo:IsDamageType(DMG_BULLET) or damageInfo:IsDamageType(DMG_BUCKSHOT) then
			cwMelee:HandleStability(entity, math.Round(damageInfo:GetDamage() * 1.25), 5);
		else
			if damage >= 5 and entity:IsPlayer() then
				local targetVelocity = entity:GetVelocity();
				if math.abs(targetVelocity.x) > 200 or math.abs(targetVelocity.y) > 200 then
					damageInfo:ScaleDamage(1.3);
					entity:TakeStability(damage * 0.75);
				elseif entity:Crouching() then
					damageInfo:ScaleDamage(1.2);
					entity:TakeStability(damage * 0.8);
				end
			end
		end
	end
end

function cwMelee:ModifyPlayerSpeed(player, infoTable)
	if IsValid(player) and player:HasInitialized() then
		local freeze = player:GetNetVar("freeze", 0);

		infoTable.runSpeed = infoTable.runSpeed * (1 - (freeze / 200));
		infoTable.walkSpeed = infoTable.walkSpeed * (1 - (freeze / 200));
		
		if player:GetNetVar("Parried", false) then
			infoTable.runSpeed = infoTable.runSpeed * 0.8;
			infoTable.walkSpeed = infoTable.walkSpeed * 0.8;
		end
	end
end

-- Called when a player's pain sound should be played.
function cwMelee:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if player:Alive() and !Clockwork.player:HasFlags(player, "M") and player:WaterLevel() < 3 then
		local faction = (player:GetNetVar("kinisgerOverride") or player:GetFaction())
		local subfaction = (player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction());
		local pitch = 100;
		
		if IsValid(player.possessor) then
			pitch = 50;
		elseif gender == "Male" then
			pitch = math.random(95, 110);
		else
			pitch = math.random(100, 115);
		end
		
		if (!player.nextPainSound or player.nextPainSound < CurTime()) then
			if player:GetSubfaith() == "Voltism" and cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
				player:EmitSound(voltistSounds["pain"][math.random(1, #voltistSounds["pain"])], 90, 150);
				player.nextPainSound = CurTime() + 0.5;
				return;
			end
		
			if player:GetCharacterData("isThrall") then
				player:EmitSound("apocalypse/screams/far"..math.random(1,6)..".wav", 90, pitch);
				player.nextPainSound = CurTime()+0.5;
			elseif faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers" then
				if gender == "Male" then
					player:EmitSound("voice/man2/man2_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				else
					player:EmitSound("voice/female1/female1_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				end
			elseif faction == "Holy Hierarchy" then
				if gender == "Male" then
					if subfaction == "Low Ministry" then
						player:EmitSound("lmpainsounds/lm_pain"..math.random(1, 6)..".mp3", 90, pitch)
					else
						player:EmitSound("voice/man4/man4_pain0"..math.random(1, 6)..".wav", 90, pitch)
					end
					
					player.nextPainSound = CurTime()+0.5
				else
					player:EmitSound("voice/female1/female1_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				end
			elseif faction == "Goreic Warrior" then
				if gender == "Male" then
					player:EmitSound("voice/man1/man1_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				else
					player:EmitSound("voice/female2/female2_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				end
			elseif faction == "Hillkeeper" then
				if gender == "Male" then
					player:EmitSound("hkpainsounds/hk_pain"..math.random(1, 6)..".mp3", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				else
					player:EmitSound("voice/female2/female2_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				end
			else
				if gender == "Male" then
					player:EmitSound("voice/man3/man3_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				else
					player:EmitSound("voice/female2/female2_pain0"..math.random(1, 6)..".wav", 90, pitch)
					player.nextPainSound = CurTime()+0.5
				end
			end
		end
	end
end

-- Called when a player's death sound should be played.
function GM:PlayerPlayDeathSound(player, gender)
	if player.drowned or player.suffocating or player:WaterLevel() >= 3 then
		return;
	end

	local faction = (player:GetNetVar("kinisgerOverride") or player:GetFaction());
	local subfaction = (player:GetNetVar("kinisgerOverrideSubfaction") or player:GetSubfaction());
	local pitch = 100;
	
	if IsValid(player.possessor) then
		pitch = 50;
	elseif gender == "Male" and !player:GetCharacterData("isThrall") then
		if math.random(1, 100) == 100 then
			player:EmitSound("wilhelm.wav", 90, 100);
			return;
		end
	
		pitch = math.random(95, 110);
	else
		pitch = math.random(100, 115);
	end

	if !Clockwork.player:HasFlags(player, "M") then
		if player:GetSubfaith() == "Voltism" and cwBeliefs and (player:HasBelief("the_storm") or player:HasBelief("the_paradox_riddle_equation")) then
			player:EmitSound(voltistSounds["death"][math.random(1, #voltistSounds["death"])], 90, 150);
			return;
		end

		if player:GetCharacterData("isThrall") then
			player:EmitSound("apocalypse/screams/far"..math.random(1,6)..".wav", 90, pitch);
			player.nextPainSound = CurTime()+0.5;
		elseif faction == "Gatekeeper" or faction == "Pope Adyssa's Gatekeepers" then
			if gender == "Male" then
				player:EmitSound("voice/man2/man2_death0"..math.random(1, 9)..".wav", 90, pitch)
			else
				player:EmitSound("voice/female1/female1_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		elseif faction == "Holy Hierarchy" then
			if subfaction ~= "Low Ministry" then
				if gender == "Male" then
					player:EmitSound("voice/man4/man4_death0"..math.random(1, 9)..".wav", 90, pitch)
				else
					player:EmitSound("voice/female1/female1_death0"..math.random(1, 9)..".wav", 90, pitch)
				end
			else
				player:EmitSound("lmpainsounds/lm_death"..math.random(1, 6)..".mp3", 90, pitch)
			end
		elseif faction == "The Third Inquisition" then
			if gender == "Male" then
				player:EmitSound("voice/man4/man4_death0"..math.random(1, 9)..".wav", 90, pitch)
			else
				player:EmitSound("voice/female1/female1_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		elseif faction == "Goreic Warrior" then
			if gender == "Male" then
				player:EmitSound("voice/man1/man1_death0"..math.random(1, 9)..".wav", 90, pitch)
			else
				player:EmitSound("voice/female2/female2_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		elseif faction == "Hillkeeper" then
			if gender == "Male" then
				player:EmitSound("hkpainsounds/hk_death"..math.random(1, 9)..".mp3", 90, pitch)
			else
				player:EmitSound("voice/female2/female2_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		elseif faction == "Smog City Pirate" then
			if gender == "Male" then
				player:EmitSound("voice/man1/man1_death0"..math.random(1, 9)..".wav", 90, pitch)
			else
				player:EmitSound("voice/female2/female2_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		else
			if gender == "Male" then
				player:EmitSound("voice/man3/man3_death0"..math.random(1, 9)..".wav", 90, pitch)
			else
				player:EmitSound("voice/female2/female2_death0"..math.random(1, 9)..".wav", 90, pitch)
			end
		end
	end
end

function cwMelee:PostPlayerEnteredDuel(player)
	if player.duelData then
		for i, v in ipairs(player:GetWeaponsEquipped()) do
			if v.category == "Throwables" then
				if !player.duelData.javelins then
					player.duelData.javelins = {};
				end
				
				player.duelData.javelins[v.uniqueID] = table.Count(player:GetItemsByID(v.uniqueID));
			end
		end
	end
end

function cwMelee:PlayerExitedDuel(player)
	player:SetCharacterData("stability", player:GetMaxStability());
	player:SetNWInt("stability", player:GetCharacterData("stability", 100));

	for i, v in ipairs(player:GetWeaponsEquipped()) do
		if v.category == "Throwables" then
			player:Give(v.weaponClass or v.uniqueID);
		end
	end

	if player.duelData then
		player.duelData.javelins = nil;
	end
end

netstream.Hook("DummyGiveArmor", function(player, data)
	if IsValid(player) then
		if data and data[1] and IsValid(data[1]) and data[1].isTrainingDummy then
			if player:GetPos():Distance(data[1]:GetPos()) <= 96 then
				if data[2] and data[3] then
					local armorItem = Clockwork.inventory:FindItemByID(player:GetInventory(), data[2], data[3]);
					
					if armorItem then
						data[1]:SetArmorItem(armorItem);
						
						player:TakeItem(armorItem);
					else
						Schema:EasyText(player, "peru", "This item could not be found!");
					end
				else
					Schema:EasyText(player, "peru", "This item could not be found!");
				end
			else
				Schema:EasyText(player, "peru", "This training dummy is too far away to be interacted with!");
			end
		else
			Schema:EasyText(player, "peru", "A valid training dummy could not be found!");
		end
	end
end);

netstream.Hook("DummyStripArmor", function(player, data)
	if IsValid(player) then
		if data and data[1] and IsValid(data[1]) and data[1].isTrainingDummy then
			if player:GetPos():Distance(data[1]:GetPos()) <= 96 then
				local armorItem = data[1].armor;
				
				if armorItem then
					if player:GiveItem(armorItem) then
						data[1]:SetArmorItem(nil);
					end
				else
					Schema:EasyText(player, "peru", "This item could not be found!");
				end
			else
				Schema:EasyText(player, "peru", "This training dummy is too far away to be interacted with!");
			end
		else
			Schema:EasyText(player, "peru", "A valid training dummy could not be found!");
		end
	end
end);

netstream.Hook("DummyGiveHelmet", function(player, data)
	if IsValid(player) then
		if data and data[1] and IsValid(data[1]) and data[1].isTrainingDummy then
			if player:GetPos():Distance(data[1]:GetPos()) <= 96 then
				if data[2] and data[3] then
					local helmetItem = Clockwork.inventory:FindItemByID(player:GetInventory(), data[2], data[3]);
					
					if helmetItem then
						data[1]:SetHelmetItem(helmetItem);
						
						player:TakeItem(helmetItem);
					else
						Schema:EasyText(player, "peru", "This item could not be found!");
					end
				else
					Schema:EasyText(player, "peru", "This item could not be found!");
				end
			else
				Schema:EasyText(player, "peru", "This training dummy is too far away to be interacted with!");
			end
		else
			Schema:EasyText(player, "peru", "A valid training dummy could not be found!");
		end
	end
end);

netstream.Hook("DummyStripHelmet", function(player, data)
	if IsValid(player) then
		if data and data[1] and IsValid(data[1]) and data[1].isTrainingDummy then
			if player:GetPos():Distance(data[1]:GetPos()) <= 96 then
				local helmetItem = data[1].helmet;
				
				if helmetItem then
					if player:GiveItem(helmetItem) then
						data[1]:SetHelmetItem(nil);
					end
				else
					Schema:EasyText(player, "peru", "This item could not be found!");
				end
			else
				Schema:EasyText(player, "peru", "This training dummy is too far away to be interacted with!");
			end
		else
			Schema:EasyText(player, "peru", "A valid training dummy could not be found!");
		end
	end
end);

netstream.Hook("DummyExamine", function(player, data)
	if IsValid(player) then
		if data and data[1] and IsValid(data[1]) and data[1].isTrainingDummy then
			if player:GetPos():Distance(data[1]:GetPos()) <= 96 then
				if data[1].armor and data[1].helmet then
					Schema:EasyText(player, "slateblue", "This training dummy's "..data[1].armor.name.." is at "..data[1].armor:GetCondition().." condition, and its "..data[1].helmet.name.." is at "..data[1].helmet:GetCondition().." condition.");
				elseif data[1].armor then
					Schema:EasyText(player, "slateblue", "This training dummy's "..data[1].armor.name.." is at "..data[1].armor:GetCondition().." condition.");
				elseif data[1].helmet then
					Schema:EasyText(player, "slateblue", "This training dummy's "..data[1].helmet.name.." is at "..data[1].helmet:GetCondition().." condition.");
				else
					Schema:EasyText(player, "slateblue", "This training dummy is not wearing armor or a helmet.");
				end
			else
				Schema:EasyText(player, "peru", "This training dummy is too far away to be interacted with!");
			end
		else
			Schema:EasyText(player, "peru", "A valid training dummy could not be found!");
		end
	end
end);