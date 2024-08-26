--[[
	Begotten III: Jesus Wept
--]]

local DeathStrings = {
	Fall = {
		"Fell to death",
		"Fell from a great height",
	},
	Drowned = {
		"Drowned to death",
		"Ran out of oxygen",
	},
	Fire = {
		"Burned alive",
		"Burned to a crisp",
		"Cooked to death",
	},
	Default = {
		"Corpsed",
		"Turned into pink mist",
		"Shot to death",
	},
	Stab = {
		"Penetrated",
		"Stabbed to death",
	},
	Club = {
		"Bludgeoned to death",
		"Had their skull smashed in",
		"Hammered into the ground",
	},
	Poison = {
		"Poisoned to death",
	},
	Acid = {
		"Melted until nothing remained",
		"Scourged with acid",
	},
	Suicide = {
		"Took the easy way out",
		"Went straight to hell by killing themself",
	},
	Prop = {
		"Crushed to death",
		"Flattened",
		"Pulverized",
	},
	Slash = {
		"Cut down",
		"Sliced to pieces",
		"Cut to ribbons",
	},
	Electricity = {
		"Shocked to death",
		"Electrocuted",
	},
	Laser = {
		"Shot with a laser",
	},
	Disintegrated = {
		"Completely disintegrated",
	},
	Explosion = {
		"Blown up",
		"Blown to pieces",
	},
}

local DamageSpecific = {
	[tostring(DMG_BLAST)] = DeathStrings.Explosion,
	[tostring(DMG_SLASH)] = DeathStrings.Slash,
	[tostring(DMG_ENERGYBEAM)] = DeathStrings.Laser,
	[tostring(DMG_DISSOLVE)] = DeathStrings.Disintegrated,
	[tostring(DMG_SHOCK)] = DeathStrings.Electricity,
	[tostring(DMG_GENERIC)] = DeathStrings.Default,
	[tostring(DMG_BULLET)] = DeathStrings.Default,
	[tostring(DMG_BUCKSHOT)] = DeathStrings.Default,
	[tostring(DMG_DIRECT)] = DeathStrings.Default,
	[tostring(DMG_VEHICLE)] = DeathStrings.Stab,
	[tostring(DMG_CLUB)]  = DeathStrings.Club,
	[tostring(DMG_CRUSH)] = DeathStrings.Prop,
	[tostring(DMG_PHYSGUN)] = DeathStrings.Prop,
	[tostring(DMG_BURN)] = DeathStrings.Fire,
	[tostring(DMG_SLOWBURN)] = DeathStrings.Fire,
	[tostring(DMG_DROWN)] = DeathStrings.Drowned,
	[tostring(DMG_DROWNRECOVER)] = DeathStrings.Drowned,
	[tostring(DMG_FALL)] = DeathStrings.Fall,
	[tostring(DMG_PARALYZE)] = DeathStrings.Poison,
	[tostring(DMG_NERVEGAS)] = DeathStrings.Poison,
	[tostring(DMG_POISON)] = DeathStrings.Poison,
	[tostring(DMG_ACID)] = DeathStrings.Acid,
	[tostring(DMG_RADIATION)] = DeathStrings.Acid,
}

local damagePriority = {
	DMG_DISSOLVE,
	DMG_PLASMA,
	DMG_FALL,
	DMG_SHOCK,
	DMG_SONIC,
	DMG_ENERGYBEAM,
	DMG_RADIATION,
	DMG_DROWN,
	DMG_BURN,
	DMG_PARALYZE,
	DMG_NERVEGAS,
	DMG_ACID,
	DMG_NERVEGAS,
	DMG_POISON,
	DMG_CRUSH,
	DMG_VEHICLE,
	DMG_BLAST,
	DMG_CLUB,
	DMG_SLASH,
	DMG_BUCKSHOT,
	DMG_BULLET,
	DMG_AIRBOAT,
	DMG_DIRECT,
	DMG_PHYSGUN,
	DMG_SLOWBURN
}

-- Called when a player dies.
function cwDeathCauses:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (!player.opponent) then
		player:SetCharacterData("necropolisData", {model = player:GetModel(), playerBodygroups = {player:GetBodygroup(0), player:GetBodygroup(1)}, skin = player:GetSkin()});
	
		if player.deathCauseOverriden ~= true then
			local attackerName;
			local inflictorflame = false
			
			if inflictor and IsValid(inflictor) then
				local inflictorClass = inflictor:GetClass();
				
				inflictorflame = string.find(inflictorClass, "flame") or string.find(inflictorClass, "fire");
			end
			
			if attacker and IsValid(attacker) then
				local attackerClass = attacker:GetClass();
			
				if attacker:IsPlayer() then
					local attackerFaction = attacker:GetNetVar("kinisgerOverride") or attacker:GetFaction();
					
					if Clockwork.player:DoesRecognise(player, attacker) then
						attackerName = attacker:Name();
					elseif attackerFaction == "Goreic Warrior" then
						attackerName = "an unknown Goreic Warrior";
					elseif attackerFaction == "Children of Satan" then
						attackerName = "an unknown Child of Satan";
					elseif attackerFaction == "Gatekeeper" or attackerFaction == "Pope Adyssa's Gatekeepers" then
						attackerName = "an unknown Gatekeeper";
					elseif attackerFaction == "Holy Hierarchy" then
						local attackerSubfaction = attacker:GetSubfaction();
						
						if attackerSubfaction == "Inquisition" then
							attackerName = "an unknown Inquisitor";
						elseif attackerSubfaction == "Knights of Sol" then
							attackerName =  "an unknown Knight of Sol";
						else
							attackerName =  "an unknown Glazic nobleman";
						end
					else
						attackerName = "an unknown assailant";
					end
					
					local attackerKills = attacker:GetKills();
					
					attacker:SetKills(attackerKills + 1);
				elseif attackerClass == "trigger_hurt" or inflictorflame or string.find(attackerClass, "flame") or string.find(attackerClass, "fire") then
					local melt=false
					
					if (attackerClass == "trigger_hurt") then
						--Clockwork.player:NotifyAll(player:Name().." has been killed by trigger_hurt '"..attacker:MapCreationID().."'.");
						melt=true
					end
					
					local ragdollEntity = player:GetRagdollEntity();
					local burnsound;
					
					if (IsValid(ragdollEntity)) then
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Fire("startragdollboogie")
						ragdollEntity:Ignite(7,32)
						
						burnsound = CreateSound( ragdollEntity, "npc/headcrab/headcrab_burning_loop2.wav")
					end
					if melt then
						
						timer.Create( "lavadeath"..player:Name(), 5, 1, function()
							if IsValid(player) then
								--[[local model = "models/Humans/Charple01.mdl";
								
								if !Clockwork.player:HasFlags(player, "E") then
									player:SetCharacterData("Model", model, true);
									player:SetModel(model);
								end]]--
								
								if (IsValid(ragdollEntity)) then
									if cwGore then
										cwGore:SplatCorpse(ragdollEntity, 60);
									end
									
									game.AddParticles( "particles/gmod_effects.pcf" )
									PrecacheParticleSystem( "generic_smoke" )
									ParticleEffectAttach( "generic_smoke", 1, ragdollEntity, 1 )
									burnsound:Stop()
									if melt then
										ragdollEntity:Ignite(5,64)
										ragdollEntity:Remove()
									end
								end
							end
						end);
					else
						timer.Create( "burndeath"..player:Name(), 5, 1, function()
							--[[local model = "models/Humans/Charple01.mdl"
							
							if !Clockwork.player:HasFlags(player, "E") then
								player:SetCharacterData("Model", model, true);
								player:SetModel(model);
							end]]--
							
							if cwGore then
								cwGore:RotCorpse(ragCorpse, 0.1);
							end
							
							if (IsValid(ragdollEntity)) then
								ragdollEntity:SetModel(model);
								game.AddParticles( "particles/gmod_effects.pcf" )
								PrecacheParticleSystem( "generic_smoke" )
								ParticleEffectAttach( "generic_smoke", 1, ragdollEntity, 1 )
								burnsound:Stop()
							end
						end
						)
					end
				end
			end
			
			if !attackerName and IsValid(attacker) then
				if attacker:IsNPC() or attacker:IsNextBot() then
					attackerName = "a "..attacker.PrintName or "a "..attacker:GetClass();
				else
					attackerName = "a "..attacker:GetClass();
				end
			end
		
			if damageInfo then
				local damageType = "Killed";
				local highestDamageType = nil;
				local highestDamagePriority = #damagePriority;
				
				for i = 1, #damagePriority do
					if damageInfo:IsDamageType(damagePriority[i]) then
						if damagePriority[i] == DMG_FIRE then
							local ragdollEntity = player:GetRagdollEntity();
							timer.Create( "burndeath"..player:Name(), 5, 1, function()
								--[[local model = "models/Humans/Charple01.mdl";
								
								if !Clockwork.player:HasFlags(player, "E") then
									player:SetCharacterData("Model", model, true);
									player:SetModel(model);
								end]]--
								
								if (IsValid(ragdollEntity)) then
									if cwGore then
										cwGore:SplatCorpse(ragdollEntity, 1);
									end
								end

								game.AddParticles( "particles/gmod_effects.pcf" )
								PrecacheParticleSystem( "generic_smoke" )
								player:EmitSound("ambient/energy/newspark01.wav")
								ParticleEffectAttach( "generic_smoke", 1, player, 1 )
							end
							)
							
							
							if (IsValid(ragdollEntity)) then
								ragdollEntity:Fire("startragdollboogie")
								ragdollEntity:Fire("startragdollboogie")
								ragdollEntity:Fire("startragdollboogie")
								ragdollEntity:Fire("startragdollboogie")
								ragdollEntity:Ignite(7,32)
							end
						end
						
						if i <= highestDamagePriority then
							highestDamageType = damagePriority[i];
							highestDamagePriority = i;
						end
					end
				end
				
				if highestDamageType then
					if DamageSpecific[tostring(highestDamageType)] then
						damageType = DamageSpecific[tostring(highestDamageType)][math.random(1, #DamageSpecific[tostring(highestDamageType)])];
					end
				end
				
				if (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) then
					if (IsValid(attacker:GetActiveWeapon())) then
						local weapon = attacker:GetActiveWeapon()
						local itemTable = item.GetByWeapon(weapon)

						if IsValid(weapon) then
							if itemTable then
								player:SetCharacterData("deathcause", damageType.." with a "..itemTable.name.." by "..attackerName..".");
								--printp(damageType.." with a "..itemTable.name.." by "..attackerName..".");
							else
								player:SetCharacterData("deathcause", damageType.." with a "..weapon:GetPrintName().." by "..attackerName..".");
								--printp(damageType.." with a "..weapon:GetPrintName().." by "..attackerName..".");
							end
						else
							player:SetCharacterData("deathcause", damageType.." with a "..Clockwork.player:GetWeaponClass(attacker).." by "..attackerName..".");
							--printp(damageType.." with a "..Clockwork.player:GetWeaponClass(attacker).." by "..attackerName..".");
						end
					else
						player:SetCharacterData("deathcause", damageType.." indirectly by "..attackerName..".");
						--printp(damageType.." indirectly by "..attackerName..".");
					end
				else
					player:SetCharacterData("deathcause", damageType..".");
					--printp(damageType..".");
				end
			else
				--printp("No damageinfo found!");
				if (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) then
					if (IsValid(attacker:GetActiveWeapon())) then
						local weapon = attacker:GetActiveWeapon()
						local itemTable = item.GetByWeapon(weapon)

						if IsValid(weapon) then
							if itemTable then
								player:SetCharacterData("deathcause", "Killed with a "..itemTable.name.." by "..attackerName..".");
								--printp("Killed with a "..itemTable.name.." by "..attackerName..".");
							else
								player:SetCharacterData("deathcause", "Killed with a "..weapon:GetPrintName().." by "..attackerName..".");
								--printp("Killed with a "..weapon:GetPrintName().." by "..attackerName..".");
							end
						else
							player:SetCharacterData("deathcause", "Killed with a "..Clockwork.player:GetWeaponClass(attacker).." by "..attackerName..".");
							--printp("Killed with a "..Clockwork.player:GetWeaponClass(attacker).." by "..attackerName..".");
						end
					else
						player:SetCharacterData("deathcause", "Killed indirectly by "..attackerName..".");
						--printp("Killed indirectly by "..attackerName);
					end
				else
					player:SetCharacterData("deathcause", "Died under mysterious circumstances.");
					--printp("Died under mysterious circumstances.");
				end
			end
		end
	end
end

-- Called when a player's character screen info should be adjusted.
function cwDeathCauses:PlayerAdjustCharacterScreenInfo(player, character, info)
	if character.data["deathcause"] then
		info.deathcause = character.data["deathcause"];
	end
end